import 'depth_grid.dart';
import 'grid_astar.dart';
import 'point_in_polygon.dart';

/// Полигон запрета в WGS84 (замкнутое кольцо, последняя точка может дублировать первую).
class ForbiddenZone {
  ForbiddenZone(this.ringLonLat);

  final List<(double lon, double lat)> ringLonLat;
}

/// Результат расчёта advisory-маршрута (Фаза 5).
class AdvisoryRouteResult {
  AdvisoryRouteResult._(this.points, this.failureReason);

  factory AdvisoryRouteResult.ok(List<(double lat, double lon)> pts) =>
      AdvisoryRouteResult._(pts, null);

  factory AdvisoryRouteResult.fail(String reason) =>
      AdvisoryRouteResult._(const [], reason);

  final List<(double lat, double lon)> points;
  final String? failureReason;

  bool get isOk => failureReason == null && points.length >= 2;
}

/// Расчёт пути по сетке глубин с учётом осадки, запаса и запретных зон.
AdvisoryRouteResult computeAdvisoryRoute({
  required DepthGrid grid,
  required List<ForbiddenZone> forbidden,
  required double draftM,
  required double clearanceM,
  required double startLat,
  required double startLon,
  required double goalLat,
  required double goalLon,
}) {
  final needDepth = draftM + clearanceM;
  if (needDepth <= 0) {
    return AdvisoryRouteResult.fail('invalid_draft_clearance');
  }

  final startIdx = grid.nearestCell(startLat, startLon);
  final goalIdx = grid.nearestCell(goalLat, goalLon);
  if (startIdx == null || goalIdx == null) {
    return AdvisoryRouteResult.fail('endpoints_outside_grid');
  }

  bool navigable(int r, int c) {
    final d = grid.depthAtCell(r, c);
    if (d == null || d.isNaN) return false;
    if (d < needDepth) return false;
    final center = grid.cellCenter(r, c);
    for (final z in forbidden) {
      if (pointInPolygonLonLat(
            lon: center.$2,
            lat: center.$1,
            ring: z.ringLonLat,
          )) {
        return false;
      }
    }
    return true;
  }

  final pathCells = astarGridPath(
    grid: grid,
    start: startIdx,
    goal: goalIdx,
    navigable: navigable,
  );

  if (pathCells == null || pathCells.isEmpty) {
    return AdvisoryRouteResult.fail('no_path');
  }

  final pts = <(double, double)>[];
  for (final c in pathCells) {
    final xy = grid.cellCenter(c.$1, c.$2);
    pts.add((xy.$1, xy.$2));
  }
  return AdvisoryRouteResult.ok(pts);
}
