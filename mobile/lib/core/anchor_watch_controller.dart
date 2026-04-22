import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repositories/audit_repository.dart';
import '../domain/anchor/geo.dart';

class AnchorWatchState {
  const AnchorWatchState({
    this.armed = false,
    this.anchorLat,
    this.anchorLon,
    this.radiusM = 40,
    this.alarmLatched = false,
    this.gpsLost = false,
    this.lastDistanceM,
    this.lastFixAt,
  });

  final bool armed;
  final double? anchorLat;
  final double? anchorLon;
  final double radiusM;
  final bool alarmLatched;
  final bool gpsLost;
  final double? lastDistanceM;
  final DateTime? lastFixAt;

  bool get hasAnchor => anchorLat != null && anchorLon != null;

  AnchorWatchState copyWith({
    bool? armed,
    double? anchorLat,
    double? anchorLon,
    double? radiusM,
    bool? alarmLatched,
    bool? clearAnchor,
    bool? gpsLost,
    double? lastDistanceM,
    DateTime? lastFixAt,
  }) {
    return AnchorWatchState(
      armed: armed ?? this.armed,
      anchorLat: clearAnchor == true ? null : (anchorLat ?? this.anchorLat),
      anchorLon: clearAnchor == true ? null : (anchorLon ?? this.anchorLon),
      radiusM: radiusM ?? this.radiusM,
      alarmLatched: alarmLatched ?? this.alarmLatched,
      gpsLost: gpsLost ?? this.gpsLost,
      lastDistanceM: lastDistanceM ?? this.lastDistanceM,
      lastFixAt: lastFixAt ?? this.lastFixAt,
    );
  }
}

class AnchorWatchController extends StateNotifier<AnchorWatchState> {
  AnchorWatchController(this._prefs, this._audit, this._sessionId)
    : super(_loadInitial(_prefs)) {
    if (state.armed && state.hasAnchor) {
      _startTimer();
    }
  }

  final SharedPreferences _prefs;
  final AuditRepository _audit;
  final String _sessionId;

  static const latKey = 'anchorWatchLat';
  static const lonKey = 'anchorWatchLon';
  static const radiusKey = 'anchorWatchRadiusM';
  static const armedKey = 'anchorWatchArmed';

  static const _gpsTimeout = Duration(seconds: 45);

  Timer? _timer;

  static AnchorWatchState _loadInitial(SharedPreferences p) {
    final lat = p.getDouble(latKey);
    final lon = p.getDouble(lonKey);
    final has = lat != null && lon != null;
    final armed = has && (p.getBool(armedKey) ?? false);
    return AnchorWatchState(
      armed: armed,
      anchorLat: lat,
      anchorLon: lon,
      radiusM: p.getDouble(radiusKey) ?? 40,
    );
  }

  Future<void> setRadiusMeters(double r) async {
    if (r < 5) return;
    if (r == state.radiusM) return;
    await _prefs.setDouble(radiusKey, r);
    state = state.copyWith(radiusM: r);
  }

  Future<void> dropAnchor() async {
    final p = await Geolocator.getCurrentPosition();
    await _prefs.setDouble(latKey, p.latitude);
    await _prefs.setDouble(lonKey, p.longitude);
    state = state.copyWith(anchorLat: p.latitude, anchorLon: p.longitude);
    await _audit.record(
      sessionId: _sessionId,
      module: 'M6',
      action: 'anchor_drop',
      contextJson:
          '{"lat":${p.latitude.toStringAsFixed(5)},"lon":${p.longitude.toStringAsFixed(5)}}',
    );
  }

  Future<void> clearAnchor() async {
    await _prefs.remove(latKey);
    await _prefs.remove(lonKey);
    await _prefs.setBool(armedKey, false);
    _stopTimer();
    state = const AnchorWatchState();
  }

  Future<void> arm() async {
    if (!state.hasAnchor) return;
    await _prefs.setBool(armedKey, true);
    state = state.copyWith(armed: true, alarmLatched: false, gpsLost: false);
    _startTimer();
    await _tick();
    await _audit.record(
      sessionId: _sessionId,
      module: 'M6',
      action: 'anchor_arm',
      contextJson: '{"radiusM":${state.radiusM.toStringAsFixed(0)}}',
    );
  }

  Future<void> disarm() async {
    await _prefs.setBool(armedKey, false);
    _stopTimer();
    state = state.copyWith(armed: false, alarmLatched: false, gpsLost: false);
    await _audit.record(
      sessionId: _sessionId,
      module: 'M6',
      action: 'anchor_disarm',
      contextJson: '{}',
    );
  }

  void acknowledgeAlarm() {
    if (!state.alarmLatched) return;
    state = state.copyWith(alarmLatched: false);
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      unawaited(_tick());
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _tick() async {
    if (!state.armed || !state.hasAnchor) return;
    final aLat = state.anchorLat!;
    final aLon = state.anchorLon!;

    try {
      final p = await Geolocator.getCurrentPosition();
      final d = haversineMeters(aLat, aLon, p.latitude, p.longitude);
      final now = DateTime.now();
      var next = state.copyWith(
        lastDistanceM: d,
        lastFixAt: now,
        gpsLost: false,
      );
      if (d > state.radiusM && !state.alarmLatched) {
        next = next.copyWith(alarmLatched: true);
        await _audit.record(
          sessionId: _sessionId,
          module: 'M6',
          action: 'anchor_alarm',
          contextJson:
              '{"distanceM":${d.toStringAsFixed(1)},"radiusM":${state.radiusM.toStringAsFixed(0)}}',
        );
      }
      state = next;
    } catch (_) {
      final last = state.lastFixAt;
      final lost = last == null || DateTime.now().difference(last) > _gpsTimeout;
      state = state.copyWith(gpsLost: lost);
    }
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
