import 'auto_guidance.dart';
import 'depth_grid.dart';

/// Синтетическая сетка для Невской губы (демо Фазы 5 — не для навигации).
///
/// Мелководье по «полосе» и прямоугольная запретная зона заставляют путь огибать препятствие.
class DemoGulfRoutingScenario {
  DemoGulfRoutingScenario._(this.grid, this.forbidden);

  final DepthGrid grid;
  final List<ForbiddenZone> forbidden;

  /// Маршрут по умолчанию: юг → север, обход центральной мели.
  static DemoGulfRoutingScenario build() {
    const rows = 32;
    const cols = 32;
    const originLat = 59.88;
    const originLon = 30.18;
    const dLat = 0.004;
    const dLon = 0.006;

    final depth = List.generate(
      rows,
      (i) => List<double>.generate(cols, (j) {
        var base = 18.0 + j * 0.15;
        if (i >= 12 && i <= 20 && j >= 10 && j <= 22) {
          base = 1.5;
        }
        return base;
      }),
    );

    final grid = DepthGrid(
      rows: rows,
      cols: cols,
      depthM: depth,
      originLatDeg: originLat,
      originLonDeg: originLon,
      latStepDeg: dLat,
      lonStepDeg: dLon,
    );

    final rect = <(double, double)>[
      (30.30, 59.96),
      (30.38, 59.96),
      (30.38, 59.99),
      (30.30, 59.99),
      (30.30, 59.96),
    ];

    return DemoGulfRoutingScenario._(grid, [ForbiddenZone(rect)]);
  }
}
