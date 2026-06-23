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
