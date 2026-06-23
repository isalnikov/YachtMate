import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/energy_profile_controller.dart';
import '../../core/providers.dart';
import '../../domain/ais/ais_decode_pipeline.dart';
import '../../domain/ais/ais_target.dart';
import '../../domain/ais/ais_vessel_category.dart';
import '../../domain/ais/aivdm_position_report.dart';
import '../../domain/ais/nmea_tcp_client.dart';
import 'ais_nmea_preferences.dart';

enum AisNmeaSourceMode { off, demo, live }

class AisNmeaBridgeState {
  const AisNmeaBridgeState({
    required this.mode,
    required this.liveConnected,
  });

  final AisNmeaSourceMode mode;
  final bool liveConnected;

  bool get isActive => mode != AisNmeaSourceMode.off;

  AisNmeaBridgeState copyWith({
    AisNmeaSourceMode? mode,
    bool? liveConnected,
  }) {
    return AisNmeaBridgeState(
      mode: mode ?? this.mode,
      liveConnected: liveConnected ?? this.liveConnected,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AisNmeaBridgeState &&
      other.mode == mode &&
      other.liveConnected == liveConnected;

  @override
  int get hashCode => Object.hash(mode, liveConnected);
}

class AisTargetsController extends StateNotifier<Map<int, AisTarget>> {
  AisTargetsController() : super(const {});

  void upsertFromReport(AisPositionReport r) {
    state = {
      ...state,
      r.mmsi: AisTarget(
        mmsi: r.mmsi,
        latitudeDeg: r.latitudeDeg,
        longitudeDeg: r.longitudeDeg,
        sogKnots: r.sogKnots,
        cogDegrees: r.cogDegrees,
        updatedAtUtc: DateTime.now().toUtc(),
        category: aisCategoryFromMmsi(r.mmsi),
        trueHeadingDeg:
            r.trueHeadingDeg == 511 ? null : r.trueHeadingDeg,
      ),
    };
  }

  void clear() => state = const {};
}

/// Demo vs live NMEA source; feeds [AisTargetsController] (Step 46).
class AisNmeaBridgeController extends StateNotifier<AisNmeaBridgeState> {
  AisNmeaBridgeController(this._ref)
    : super(
        const AisNmeaBridgeState(
          mode: AisNmeaSourceMode.off,
          liveConnected: false,
        ),
      ) {
    _ref.listen<AisNmeaEndpoint>(aisNmeaPreferencesProvider, (prev, next) {
      if (state.mode == AisNmeaSourceMode.live) {
        unawaited(_restartLive());
      }
    });
    _ref.listen<EnergyProfile>(energyProfileProvider, (prev, next) {
      if (state.mode == AisNmeaSourceMode.demo) {
        _restartDemoTimer();
      }
    });
  }

  final Ref _ref;

  Timer? _demoTimer;
  NmeaTcpClient? _tcpClient;
  StreamSubscription<String>? _lineSub;
  final AisDecodePipeline _pipeline = AisDecodePipeline();
  List<String> _demoLines = const [];
  var _demoCursor = 0;

  Future<void> setMode(AisNmeaSourceMode mode) async {
    if (mode == state.mode) return;
    await _stopCurrent();
    state = state.copyWith(mode: mode, liveConnected: false);

    switch (mode) {
      case AisNmeaSourceMode.off:
        return;
      case AisNmeaSourceMode.demo:
        await _startDemo();
      case AisNmeaSourceMode.live:
        await _startLive();
    }
  }

  Future<void> toggleDemo() async {
    if (state.mode == AisNmeaSourceMode.demo) {
      await setMode(AisNmeaSourceMode.off);
    } else {
      await setMode(AisNmeaSourceMode.demo);
    }
  }

  Future<void> _stopCurrent() async {
    _demoTimer?.cancel();
    _demoTimer = null;
    _demoCursor = 0;
    await _lineSub?.cancel();
    _lineSub = null;
    await _tcpClient?.stop();
    _tcpClient = null;
    _pipeline.resetAssembler();
    _ref.read(aisTargetsProvider.notifier).clear();

    if (state.mode != AisNmeaSourceMode.off) {
      await _ref
          .read(auditRepositoryProvider)
          .record(
            sessionId: _ref.read(sessionIdProvider),
            module: 'M7',
            action: 'nmea_disconnect',
            contextJson: _auditContext(state.mode),
          );
    }
  }

  Future<void> _startDemo() async {
    await _ensureDemoLines();
    await _ref
        .read(auditRepositoryProvider)
        .record(
          sessionId: _ref.read(sessionIdProvider),
          module: 'M7',
          action: 'nmea_connect',
          contextJson: _auditContext(AisNmeaSourceMode.demo),
        );
    _restartDemoTimer();
    _demoTick();
  }

  Future<void> _startLive() async {
    await _ref
        .read(auditRepositoryProvider)
        .record(
          sessionId: _ref.read(sessionIdProvider),
          module: 'M7',
          action: 'nmea_connect',
          contextJson: _auditContext(AisNmeaSourceMode.live),
        );
    await _restartLive();
  }

  Future<void> _restartLive() async {
    _demoTimer?.cancel();
    _demoTimer = null;
    await _lineSub?.cancel();
    _lineSub = null;
    await _tcpClient?.stop();
    _tcpClient = null;
    _pipeline.resetAssembler();
    _ref.read(aisTargetsProvider.notifier).clear();

    final endpoint = _ref.read(aisNmeaPreferencesProvider);
    final client = NmeaTcpClient(
      host: endpoint.host,
      port: endpoint.port,
      connect: _ref.read(nmeaSocketConnectProvider),
    );
    _tcpClient = client;
    _lineSub = client.lines.listen(_ingestLine);
    await client.start();
    state = state.copyWith(liveConnected: true);
  }

  Future<void> _ensureDemoLines() async {
    if (_demoLines.isNotEmpty) return;
    final raw = await rootBundle.loadString('assets/nmea/demo_feed.nmea');
    _demoLines = raw
        .split(RegExp(r'\r?\n'))
        .map((l) => l.trim())
        .where((l) => l.startsWith('!AIVDM'))
        .toList(growable: false);
  }

  void _restartDemoTimer() {
    _demoTimer?.cancel();
    final d = _ref.read(energyProfileProvider).aisDemoTickInterval;
    _demoTimer = Timer.periodic(d, (_) => _demoTick());
  }

  void _demoTick() {
    if (_demoLines.isEmpty) return;
    final line = _demoLines[_demoCursor++ % _demoLines.length];
    _ingestLine(line);
  }

  void _ingestLine(String line) {
    final pos = _pipeline.ingestLine(line);
    if (pos != null) {
      _ref.read(aisTargetsProvider.notifier).upsertFromReport(pos);
    }
  }

  String _auditContext(AisNmeaSourceMode mode) {
    final endpoint = _ref.read(aisNmeaPreferencesProvider);
    return switch (mode) {
      AisNmeaSourceMode.demo => '{"mode":"demo_asset"}',
      AisNmeaSourceMode.live =>
        '{"mode":"tcp","host":"${endpoint.host}","port":${endpoint.port}}',
      AisNmeaSourceMode.off => '{"mode":"off"}',
    };
  }

  @override
  void dispose() {
    _demoTimer?.cancel();
    unawaited(_lineSub?.cancel());
    unawaited(_tcpClient?.stop());
    super.dispose();
  }
}

/// Injected in tests to stub TCP connects.
final nmeaSocketConnectProvider = Provider<NmeaSocketConnect>(
  (ref) => Socket.connect,
);

final aisTargetsProvider =
    StateNotifierProvider<AisTargetsController, Map<int, AisTarget>>(
      (ref) => AisTargetsController(),
    );

final aisNmeaBridgeProvider =
    StateNotifierProvider<AisNmeaBridgeController, AisNmeaBridgeState>(
      (ref) => AisNmeaBridgeController(ref),
    );

/// Back-compat: `true` when demo NMEA is active.
final aisDemoProvider = Provider<bool>(
  (ref) => ref.watch(aisNmeaBridgeProvider).mode == AisNmeaSourceMode.demo,
);

final aisDemoToggleProvider = Provider<Future<void> Function()>(
  (ref) => () => ref.read(aisNmeaBridgeProvider.notifier).toggleDemo(),
);
