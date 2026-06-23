import 'dart:math' as math;

import '../anchor/geo.dart';

/// Default half-width of the safety corridor (meters each side of the route).
const kRouteCorridorBufferMeters = 50.0;

/// Active route polyline color (iSailor-style purple).
const kRouteLineColorHex = '#9B59B6';

/// Safety corridor fill (green at 15% opacity via map fillOpacity).
const kRouteCorridorFillColorHex = '#2ECC71';

const _mPerDegLat = 110540.0;

/// One route leg between consecutive waypoints.
class RouteLegSegment {
  const RouteLegSegment({
    required this.startLat,
    required this.startLon,
    required this.endLat,
    required this.endLon,
    required this.bearingDeg,
    required this.distanceNm,
  });

  final double startLat;
  final double startLon;
  final double endLat;
  final double endLon;
  final double bearingDeg;
  final double distanceNm;

  double get midLat => (startLat + endLat) / 2;
  double get midLon => (startLon + endLon) / 2;
}

/// Closed polygon ring around [polyline] in (lon, lat) order.
List<(double lon, double lat)> computeRouteCorridorRing({
  required List<({double lat, double lon})> polyline,
  double bufferMeters = kRouteCorridorBufferMeters,
}) {
  if (polyline.length < 2 || bufferMeters <= 0) return [];

  final lat0 =
      polyline.map((p) => p.lat).reduce((a, b) => a + b) / polyline.length;
  final lon0 =
      polyline.map((p) => p.lon).reduce((a, b) => a + b) / polyline.length;
  final mPerDegLon = 111320.0 * math.cos(lat0 * math.pi / 180);

  (double x, double y) toLocal(({double lat, double lon}) p) {
    return (
      (p.lon - lon0) * mPerDegLon,
      (p.lat - lat0) * _mPerDegLat,
    );
  }

  (double lon, double lat) toLonLat((double x, double y) p) {
    return (lon0 + p.$1 / mPerDegLon, lat0 + p.$2 / _mPerDegLat);
  }

  final pts = polyline.map(toLocal).toList(growable: false);
  final left = <(double x, double y)>[];
  final right = <(double x, double y)>[];

  for (var i = 0; i < pts.length - 1; i++) {
    final a = pts[i];
    final b = pts[i + 1];
    final dx = b.$1 - a.$1;
    final dy = b.$2 - a.$2;
    final len = math.sqrt(dx * dx + dy * dy);
    if (len < 1e-6) continue;

    final nx = -dy / len * bufferMeters;
    final ny = dx / len * bufferMeters;

    final aLeft = (a.$1 + nx, a.$2 + ny);
    final bLeft = (b.$1 + nx, b.$2 + ny);
    final aRight = (a.$1 - nx, a.$2 - ny);
    final bRight = (b.$1 - nx, b.$2 - ny);

    if (i == 0) {
      left.add(aLeft);
      right.add(aRight);
    }
    left.add(bLeft);
    right.add(bRight);
  }

  if (left.isEmpty) return [];

  final ring = <(double lon, double lat)>[
    for (final p in left) toLonLat(p),
    for (final p in right.reversed) toLonLat(p),
  ];
  if (ring.isNotEmpty) {
    ring.add(ring.first);
  }
  return ring;
}

/// Initial true bearing from point 1 to point 2 in degrees [0, 360).
double segmentInitialBearingDegrees(
  double lat1,
  double lon1,
  double lat2,
  double lon2,
) {
  final p1 = lat1 * math.pi / 180;
  final p2 = lat2 * math.pi / 180;
  final dLon = (lon2 - lon1) * math.pi / 180;
  final y = math.sin(dLon) * math.cos(p2);
  final x =
      math.cos(p1) * math.sin(p2) -
      math.sin(p1) * math.cos(p2) * math.cos(dLon);
  final brng = math.atan2(y, x) * 180 / math.pi;
  return (brng + 360) % 360;
}

/// Great-circle segment length in nautical miles.
double segmentDistanceNm(double lat1, double lon1, double lat2, double lon2) {
  return haversineMeters(lat1, lon1, lat2, lon2) / 1852.0;
}

/// Leg labels like «315° · 0.44 nm» (iSailor-style).
String formatRouteLegLabel({
  required double bearingDeg,
  required double distanceNm,
}) {
  final bearing = bearingDeg.round();
  return '$bearing° · ${distanceNm.toStringAsFixed(2)} nm';
}

List<RouteLegSegment> routeLegSegments(List<({double lat, double lon})> points) {
  if (points.length < 2) return const [];

  final legs = <RouteLegSegment>[];
  for (var i = 0; i < points.length - 1; i++) {
    final a = points[i];
    final b = points[i + 1];
    legs.add(
      RouteLegSegment(
        startLat: a.lat,
        startLon: a.lon,
        endLat: b.lat,
        endLon: b.lon,
        bearingDeg: segmentInitialBearingDegrees(a.lat, a.lon, b.lat, b.lon),
        distanceNm: segmentDistanceNm(a.lat, a.lon, b.lat, b.lon),
      ),
    );
  }
  return legs;
}
