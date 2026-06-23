import '../map/demo_navigation_layers_index.dart';
import 'auto_guidance.dart';
import 'depth_grid.dart';

/// Глубины ячеек по [DemoNavigationLayersIndex] — те же изобаты, что на карте (демо-слой).
///
/// Ячейки без изобаты в пределах [maxContourDistanceM] получают `double.nan` и считаются непроходимыми.
DepthGrid buildNavigationLayersDepthGrid(
  DemoNavigationLayersIndex index, {

  /// Юго-западный угол — охват выгрузки EMODnet contours (район Фетхие, Турция).
  double originLatDeg = 36.35,
  double originLonDeg = 27.80,
  int rows = 56,
  int cols = 82,
  double latStepDeg = 0.0125,
  double lonStepDeg = 0.025,
  double maxContourDistanceM = 8000,
}) {
  final depth = List.generate(
    rows,
    (i) => List<double>.generate(cols, (j) {
      final lat = originLatDeg + (i + 0.5) * latStepDeg;
      final lon = originLonDeg + (j + 0.5) * lonStepDeg;
      final d = index.nearestContourDepthM(
        lat: lat,
        lon: lon,
        maxDistanceM: maxContourDistanceM,
      );
      return d ?? double.nan;
    }),
  );

  return DepthGrid(
    rows: rows,
    cols: cols,
    depthM: depth,
    originLatDeg: originLatDeg,
    originLonDeg: originLonDeg,
    latStepDeg: latStepDeg,
    lonStepDeg: lonStepDeg,
  );
}

/// True when [depthM] is missing or shallower than [needDepthM] (draft + clearance).
bool isShallowDepth(double? depthM, double needDepthM) {
  if (needDepthM <= 0) return false;
  if (depthM == null || depthM.isNaN) return true;
  return depthM < needDepthM;
}

/// Cell indices on [grid] that are shallower than [needDepthM].
List<(int row, int col)> collectShallowCells(DepthGrid grid, double needDepthM) {
  if (needDepthM <= 0) return const [];

  final out = <(int, int)>[];
  for (var i = 0; i < grid.rows; i++) {
    for (var j = 0; j < grid.cols; j++) {
      if (isShallowDepth(grid.depthAtCell(i, j), needDepthM)) {
        out.add((i, j));
      }
    }
  }
  return out;
}

/// Сценарий advisory с сеткой из контуров карты (без синтетических запретных полигонов).
class NavigationLayersRoutingScenario {
  NavigationLayersRoutingScenario._(this.grid, this.forbidden);

  final DepthGrid grid;
  final List<ForbiddenZone> forbidden;

  factory NavigationLayersRoutingScenario.fromIndex(
    DemoNavigationLayersIndex index,
  ) {
    return NavigationLayersRoutingScenario._(
      buildNavigationLayersDepthGrid(index),
      const [],
    );
  }
}
