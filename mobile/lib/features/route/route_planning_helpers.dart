import 'dart:math' as math;

import '../../data/local/app_database.dart';
import '../../domain/routing/depth_grid.dart';

/// Default planning speed for ETA on the route tab (kn).
const kRoutePlanningSpeedKn = 6.0;

/// Sum of great-circle segment lengths in nautical miles.
double routeDistanceNm(Iterable<({double lat, double lon})> points) {
  final list = points.toList(growable: false);
  if (list.length < 2) return 0;

  var meters = 0.0;
  for (var i = 0; i < list.length - 1; i++) {
    meters += _haversineMeters(
      list[i].lat,
      list[i].lon,
      list[i + 1].lat,
      list[i + 1].lon,
    );
  }
  return meters / 1852.0;
}

/// Hours at [speedKn] knots; returns null when distance is zero.
double? routeEtaHours(double distanceNm, {double speedKn = kRoutePlanningSpeedKn}) {
  if (distanceNm <= 0 || speedKn <= 0) return null;
  return distanceNm / speedKn;
}

/// Result of sampling the depth grid at route waypoints (UI-only check).
class RouteDepthSafetyResult {
  const RouteDepthSafetyResult({required this.isSafe, this.unsafeWaypointIndex});

  final bool isSafe;

  /// 1-based waypoint index for display when [isSafe] is false.
  final int? unsafeWaypointIndex;

  static const ok = RouteDepthSafetyResult(isSafe: true);
}

RouteDepthSafetyResult checkRouteDepthSafety({
  required List<RouteWaypointRow> waypoints,
  required DepthGrid grid,
  required double draftM,
  required double clearanceM,
}) {
  final needDepth = draftM + clearanceM;
  if (needDepth <= 0 || waypoints.isEmpty) return RouteDepthSafetyResult.ok;

  for (var i = 0; i < waypoints.length; i++) {
    final wp = waypoints[i];
    final cell = grid.nearestCell(wp.lat, wp.lon);
    if (cell == null) {
      return RouteDepthSafetyResult(isSafe: false, unsafeWaypointIndex: i + 1);
    }
    final depth = grid.depthAtCell(cell.$1, cell.$2);
    if (depth == null || depth.isNaN || depth < needDepth) {
      return RouteDepthSafetyResult(isSafe: false, unsafeWaypointIndex: i + 1);
    }
  }
  return RouteDepthSafetyResult.ok;
}

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
