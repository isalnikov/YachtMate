import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/energy_profile_controller.dart';
import '../../core/providers.dart';
import 'widgets/gps_fix_indicator.dart';

/// Snapshot for the map status pill.
@immutable
class MapGpsStatus {
  const MapGpsStatus({
    required this.fixStatus,
    this.accuracyM,
    this.sogKnots,
  });

  final GpsFixStatus fixStatus;
  final double? accuracyM;

  /// Speed over ground in knots; null when stationary.
  final double? sogKnots;

  static const initial = MapGpsStatus(fixStatus: GpsFixStatus.searching);
}

/// Meters per second → knots.
double metersPerSecondToKnots(double mps) => mps * 1.94384;

/// Minimum SOG to show on the pill (kn).
const double kMapStatusPillMinSogKnots = 0.5;

LocationSettings mapGpsLocationSettings(EnergyProfile profile) =>
    switch (profile) {
      EnergyProfile.eco => const LocationSettings(
        accuracy: LocationAccuracy.low,
        distanceFilter: 10,
      ),
      EnergyProfile.passage => const LocationSettings(
        accuracy: LocationAccuracy.medium,
        distanceFilter: 5,
      ),
      EnergyProfile.sport => const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    };

class MapGpsStatusNotifier extends StateNotifier<MapGpsStatus> {
  MapGpsStatusNotifier(this._ref, {bool start = true})
    : super(MapGpsStatus.initial) {
    if (start) unawaited(_bootstrap());
  }

  final Ref _ref;
  StreamSubscription<Position>? _positionSub;
  ProviderSubscription<EnergyProfile>? _profileSub;

  Future<void> _bootstrap() async {
    _profileSub = _ref.listen(energyProfileProvider, (_, _) {
      unawaited(_restartStream());
    });
    await _restartStream();
  }

  Future<void> _restartStream() async {
    await _positionSub?.cancel();
    _positionSub = null;

    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      state = const MapGpsStatus(fixStatus: GpsFixStatus.denied);
      return;
    }

    if (state.fixStatus == GpsFixStatus.denied) {
      state = MapGpsStatus.initial;
    }

    final settings = mapGpsLocationSettings(_ref.read(energyProfileProvider));
    _positionSub = Geolocator.getPositionStream(
      locationSettings: settings,
    ).listen(
      _onPosition,
      onError: (_) {
        state = const MapGpsStatus(fixStatus: GpsFixStatus.searching);
      },
    );
  }

  void _onPosition(Position pos) {
    final sogKn = metersPerSecondToKnots(pos.speed);
    state = MapGpsStatus(
      fixStatus: GpsFixStatus.fix,
      accuracyM: pos.accuracy,
      sogKnots: sogKn >= kMapStatusPillMinSogKnots ? sogKn : null,
    );
  }

  /// Test hook: apply a fix without calling [Geolocator].
  @visibleForTesting
  void applyTestFix({
    required GpsFixStatus fixStatus,
    double? accuracyM,
    double? sogKnots,
  }) {
    state = MapGpsStatus(
      fixStatus: fixStatus,
      accuracyM: accuracyM,
      sogKnots: sogKnots,
    );
  }

  @override
  void dispose() {
    _profileSub?.close();
    unawaited(_positionSub?.cancel());
    super.dispose();
  }
}

final mapGpsStatusProvider =
    StateNotifierProvider.autoDispose<MapGpsStatusNotifier, MapGpsStatus>((
      ref,
    ) {
      return MapGpsStatusNotifier(ref);
    });
