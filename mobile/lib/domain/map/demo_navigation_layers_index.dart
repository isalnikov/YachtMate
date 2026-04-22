import 'dart:math' as math;

/// Локальный индекс демо-слоя (Фаза 2). См. лицензирование: `docs/data-licensing.md`.
///
/// GeoJSON coordinates use \[lon, lat\]. Query uses WGS84 lat/lon in degrees.
class DemoNavigationLayersIndex {
  DemoNavigationLayersIndex._(this._segments, this._navAids);

  final List<_ContourSegment> _segments;
  final List<_NavAid> _navAids;

  /// Parses a GeoJSON FeatureCollection map (decoded JSON).
  factory DemoNavigationLayersIndex.fromGeoJson(Map<String, dynamic> root) {
    final feats = root['features'];
    if (feats is! List<dynamic>) {
      return DemoNavigationLayersIndex._(const [], const []);
    }
    final segments = <_ContourSegment>[];
    final aids = <_NavAid>[];
    for (final raw in feats) {
      if (raw is! Map<String, dynamic>) continue;
      final geom = raw['geometry'];
      if (geom is! Map<String, dynamic>) continue;
      final type = geom['type'];
      final props = raw['properties'];
      final propMap = props is Map<String, dynamic> ? props : const {};
      if (type == 'LineString') {
        final depth = propMap['depth_m'];
        if (depth is! num) continue;
        final coords = geom['coordinates'];
        if (coords is! List<dynamic>) continue;
        final ring = <_LL>[];
        for (final c in coords) {
          if (c is List && c.length >= 2) {
            final lon = (c[0] as num).toDouble();
            final lat = (c[1] as num).toDouble();
            ring.add(_LL(lat, lon));
          }
        }
        for (var i = 0; i + 1 < ring.length; i++) {
          segments.add(
            _ContourSegment(
              a: ring[i],
              b: ring[i + 1],
              depthM: depth.toDouble(),
            ),
          );
        }
      } else if (type == 'Point') {
        final coords = geom['coordinates'];
        if (coords is! List || coords.length < 2) continue;
        final lon = (coords[0] as num).toDouble();
        final lat = (coords[1] as num).toDouble();
        final name = propMap['name'];
        aids.add(
          _NavAid(lat: lat, lon: lon, label: name is String ? name : ''),
        );
      }
    }
    return DemoNavigationLayersIndex._(segments, aids);
  }

  /// Глубина по ближайшей изобате в пределах [maxDistanceM], иначе `null`.
  double? nearestContourDepthM({
    required double lat,
    required double lon,
    double maxDistanceM = 800,
  }) {
    if (_segments.isEmpty) return null;
    var bestD = double.infinity;
    double? bestDepth;
    final q = _LL(lat, lon);
    for (final s in _segments) {
      final d = _pointToSegmentMeters(q, s.a, s.b);
      if (d < bestD) {
        bestD = d;
        bestDepth = s.depthM;
      }
    }
    if (bestD <= maxDistanceM) return bestDepth;
    return null;
  }

  /// Подпись навигационной отметки в пределах [maxDistanceM], иначе `null`.
  String? nearestNavAidLabel({
    required double lat,
    required double lon,
    double maxDistanceM = 500,
  }) {
    if (_navAids.isEmpty) return null;
    var bestD = double.infinity;
    String? bestLabel;
    for (final n in _navAids) {
      final d = _haversineMeters(lat, lon, n.lat, n.lon);
      if (d < bestD) {
        bestD = d;
        bestLabel = n.label;
      }
    }
    if (bestD <= maxDistanceM && (bestLabel?.isNotEmpty ?? false)) {
      return bestLabel;
    }
    return null;
  }
}

class _LL {
  const _LL(this.lat, this.lon);
  final double lat;
  final double lon;
}

class _ContourSegment {
  const _ContourSegment({
    required this.a,
    required this.b,
    required this.depthM,
  });
  final _LL a;
  final _LL b;
  final double depthM;
}

class _NavAid {
  const _NavAid({required this.lat, required this.lon, required this.label});
  final double lat;
  final double lon;
  final String label;
}

/// Meters between (lat1,lon1) and (lat2,lon2) on Earth ellipsoid approximation.
double _haversineMeters(double lat1, double lon1, double lat2, double lon2) {
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

double _pointToSegmentMeters(_LL q, _LL a, _LL b) {
  final latRad = q.lat * math.pi / 180;
  final mPerLat = 111320.0;
  final mPerLon = 111320.0 * math.cos(latRad);

  double locX(_LL p) => (p.lon - q.lon) * mPerLon;
  double locY(_LL p) => (p.lat - q.lat) * mPerLat;

  final ax = locX(a);
  final ay = locY(a);
  final bx = locX(b);
  final by = locY(b);

  final vx = bx - ax;
  final vy = by - ay;
  final wx = -ax;
  final wy = -ay;
  final c1 = vx * wx + vy * wy;
  if (c1 <= 0) {
    return math.sqrt(ax * ax + ay * ay);
  }
  final c2 = vx * vx + vy * vy;
  if (c2 <= c1) {
    return math.sqrt((-bx) * (-bx) + (-by) * (-by));
  }
  final t = c1 / c2;
  final px = ax + t * vx;
  final py = ay + t * vy;
  return math.sqrt(px * px + py * py);
}
