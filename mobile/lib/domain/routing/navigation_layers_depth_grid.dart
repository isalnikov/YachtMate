import '../map/demo_navigation_layers_index.dart';
import 'auto_guidance.dart';
import 'depth_grid.dart';

/// Глубины ячеек по [DemoNavigationLayersIndex] — те же изобаты, что на карте (демо-слой).
///
/// Ячейки без изобаты в пределах [maxContourDistanceM] получают `double.nan` и считаются непроходимыми.
DepthGrid buildNavigationLayersDepthGrid(
  DemoNavigationLayersIndex index, {

  /// Юго-западный угол сетки — охват `demo_navigation_layers.geojson`.
  double originLatDeg = 59.88,
  double originLonDeg = 30.15,
  int rows = 45,
  int cols = 48,
  double latStepDeg = 0.002,
  double lonStepDeg = 0.006,
  double maxContourDistanceM = 2000,
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
