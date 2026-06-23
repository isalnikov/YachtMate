import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repositories/audit_repository.dart';
import '../domain/anchor/geo.dart';

/// GPS fix recorded while anchor watch is armed (drift trail).
@immutable
class AnchorDriftPoint {
  const AnchorDriftPoint({required this.lat, required this.lon});

  final double lat;
  final double lon;
}

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
    this.currentLat,
    this.currentLon,
    this.driftHistory = const [],
  });

  final bool armed;
  final double? anchorLat;
  final double? anchorLon;
  final double radiusM;
  final bool alarmLatched;
  final bool gpsLost;
  final double? lastDistanceM;
  final DateTime? lastFixAt;
  final double? currentLat;
  final double? currentLon;
  final List<AnchorDriftPoint> driftHistory;

  bool get hasAnchor => anchorLat != null && anchorLon != null;

  bool get isDrifting =>
      armed &&
      lastDistanceM != null &&
      lastDistanceM! > radiusM;

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
    double? currentLat,
    double? currentLon,
    List<AnchorDriftPoint>? driftHistory,
    bool clearDriftHistory = false,
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
      currentLat: clearAnchor == true ? null : (currentLat ?? this.currentLat),
      currentLon: clearAnchor == true ? null : (currentLon ?? this.currentLon),
      driftHistory: clearDriftHistory || clearAnchor == true
          ? const []
          : (driftHistory ?? this.driftHistory),
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
  static const _maxDriftHistory = 120;
  static const _minRadiusM = 20.0;
  static const _maxRadiusM = 200.0;

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
    final clamped = r.clamp(_minRadiusM, _maxRadiusM);
    if (clamped == state.radiusM) return;
    await _prefs.setDouble(radiusKey, clamped);
    state = state.copyWith(radiusM: clamped);
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
    state = state.copyWith(
      armed: true,
      alarmLatched: false,
      gpsLost: false,
      clearDriftHistory: true,
    );
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
    state = state.copyWith(
      armed: false,
      alarmLatched: false,
      gpsLost: false,
      clearDriftHistory: true,
    );
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

    try {
      final p = await Geolocator.getCurrentPosition();
      await _ingestPosition(p.latitude, p.longitude);
    } catch (_) {
      final last = state.lastFixAt;
      final lost = last == null || DateTime.now().difference(last) > _gpsTimeout;
      state = state.copyWith(gpsLost: lost);
    }
  }

  /// Test hook: apply a GPS fix without calling [Geolocator].
  @visibleForTesting
  Future<void> ingestPositionForTest(double lat, double lon) =>
      _ingestPosition(lat, lon);

  Future<void> _ingestPosition(double lat, double lon) async {
    if (!state.armed || !state.hasAnchor) return;
    final aLat = state.anchorLat!;
    final aLon = state.anchorLon!;

    final d = haversineMeters(aLat, aLon, lat, lon);
    final now = DateTime.now();
    final history = [
      ...state.driftHistory,
      AnchorDriftPoint(lat: lat, lon: lon),
    ];
    if (history.length > _maxDriftHistory) {
      history.removeRange(0, history.length - _maxDriftHistory);
    }

    var next = state.copyWith(
      lastDistanceM: d,
      lastFixAt: now,
      gpsLost: false,
      currentLat: lat,
      currentLon: lon,
      driftHistory: history,
    );
    if (shouldLatchAnchorAlarm(
      distanceM: d,
      radiusM: state.radiusM,
      alarmLatched: state.alarmLatched,
    )) {
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
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
