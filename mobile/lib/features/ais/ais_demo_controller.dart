import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../domain/ais/ais_decode_pipeline.dart';
import 'ais_targets_provider.dart';

/// Воспроизведение демо-NMEA из asset (Фаза 3 — без реального TCP/BLE).
class AisDemoController extends StateNotifier<bool> {
  AisDemoController(this._ref) : super(false);

  final Ref _ref;

  Timer? _timer;
  final AisDecodePipeline _pipeline = AisDecodePipeline();
  List<String> _lines = const [];
  var _lineCursor = 0;

  Future<void> _ensureLines() async {
    if (_lines.isNotEmpty) return;
    final raw = await rootBundle.loadString('assets/nmea/demo_feed.nmea');
    _lines = raw
        .split(RegExp(r'\r?\n'))
        .map((l) => l.trim())
        .where((l) => l.startsWith('!AIVDM'))
        .toList(growable: false);
  }

  Future<void> toggle() async {
    await _ensureLines();
    if (state) {
      _timer?.cancel();
      _timer = null;
      _lineCursor = 0;
      _pipeline.resetAssembler();
      _ref.read(aisTargetsProvider.notifier).clear();
      await _ref.read(auditRepositoryProvider).record(
            sessionId: _ref.read(sessionIdProvider),
            module: 'M7',
            action: 'nmea_disconnect',
            contextJson: '{"mode":"demo_asset"}',
          );
      state = false;
      return;
    }

    await _ref.read(auditRepositoryProvider).record(
          sessionId: _ref.read(sessionIdProvider),
          module: 'M7',
          action: 'nmea_connect',
          contextJson: '{"mode":"demo_asset"}',
        );
    state = true;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) => _tick());
    _tick();
  }

  void _tick() {
    if (_lines.isEmpty) return;
    final line = _lines[_lineCursor++ % _lines.length];
    final pos = _pipeline.ingestLine(line);
    if (pos != null) {
      _ref.read(aisTargetsProvider.notifier).upsertFromReport(pos);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
