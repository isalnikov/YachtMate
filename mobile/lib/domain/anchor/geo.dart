import 'dart:math' as math;

/// Local east/north offset in meters from [anchorLat]/[anchorLon].
({double eastM, double northM}) anchorOffsetMeters({
  required double anchorLat,
  required double anchorLon,
  required double lat,
  required double lon,
}) {
  const mPerDegLat = 111320.0;
  final mPerDegLon = mPerDegLat * math.cos(anchorLat * math.pi / 180);
  return (
    eastM: (lon - anchorLon) * mPerDegLon,
    northM: (lat - anchorLat) * mPerDegLat,
  );
}

/// Whether distance exceeds the allowed anchor circle (alarm latch logic).
bool shouldLatchAnchorAlarm({
  required double distanceM,
  required double radiusM,
  required bool alarmLatched,
}) =>
    !alarmLatched && distanceM > radiusM;

/// Closed GeoJSON ring `[lon, lat]` for a circle of [radiusM] around anchor.
List<List<double>> anchorCircleRing({
  required double anchorLat,
  required double anchorLon,
  required double radiusM,
  int segments = 64,
}) {
  const r = 6371000.0;
  final ring = <List<double>>[];
  final lat1 = anchorLat * math.pi / 180;
  final lon1 = anchorLon * math.pi / 180;
  final angDist = radiusM / r;
  for (var i = 0; i <= segments; i++) {
    final bearing = 2 * math.pi * i / segments;
    final lat2 = math.asin(
      math.sin(lat1) * math.cos(angDist) +
          math.cos(lat1) * math.sin(angDist) * math.cos(bearing),
    );
    final lon2 = lon1 +
        math.atan2(
          math.sin(bearing) * math.sin(angDist) * math.cos(lat1),
          math.cos(angDist) - math.sin(lat1) * math.sin(lat2),
        );
    ring.add([lon2 * 180 / math.pi, lat2 * 180 / math.pi]);
  }
  return ring;
}

/// Расстояние по поверхности сферы (м). Точность достаточна для якорной вахты.
double haversineMeters(double lat1, double lon1, double lat2, double lon2) {
  const r = 6371000.0;
  final p1 = lat1 * math.pi / 180;
  final p2 = lat2 * math.pi / 180;
  final dp = (lat2 - lat1) * math.pi / 180;
  final dl = (lon2 - lon1) * math.pi / 180;
  final h =
      math.sin(dp / 2) * math.sin(dp / 2) +
      math.cos(p1) * math.cos(p2) * math.sin(dl / 2) * math.sin(dl / 2);
  return 2 * r * math.asin(math.min(1.0, math.sqrt(h)));
}
