import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Pending map camera target set from mooring detail «Navigate».
class MapCameraTarget {
  const MapCameraTarget({
    required this.lat,
    required this.lon,
    this.zoom = 14,
  });

  final double lat;
  final double lon;
  final double zoom;
}

final mapCameraTargetProvider =
    StateNotifierProvider<MapCameraTargetNotifier, MapCameraTarget?>(
  (ref) => MapCameraTargetNotifier(),
);

class MapCameraTargetNotifier extends StateNotifier<MapCameraTarget?> {
  MapCameraTargetNotifier() : super(null);

  void focusOn(double lat, double lon, {double zoom = 14}) {
    state = MapCameraTarget(lat: lat, lon: lon, zoom: zoom);
  }

  void clear() => state = null;
}
