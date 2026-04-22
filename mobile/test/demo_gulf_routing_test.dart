import 'package:captain_wrongel/domain/routing/auto_guidance.dart';
import 'package:captain_wrongel/domain/routing/demo_gulf_grid.dart';
import 'package:captain_wrongel/domain/routing/point_in_polygon.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('advisory route avoids shoal and forbidden rectangle', () {
    final demo = DemoGulfRoutingScenario.build();
    final g = demo.grid;

    final start = g.cellCenter(4, 4);
    final goal = g.cellCenter(28, 28);

    final r = computeAdvisoryRoute(
      grid: demo.grid,
      forbidden: demo.forbidden,
      draftM: 2.5,
      clearanceM: 1.0,
      startLat: start.$1,
      startLon: start.$2,
      goalLat: goal.$1,
      goalLon: goal.$2,
    );

    expect(r.isOk, true);
    expect(r.points.length >= 2, true);

    final need = 3.5;
    for (final p in r.points) {
      final cell = g.nearestCell(p.$1, p.$2);
      expect(cell, isNotNull);
      final d = g.depthAtCell(cell!.$1, cell.$2);
      expect(d, isNotNull);
      expect(d! >= need, true);
    }

    for (final p in r.points) {
      for (final z in demo.forbidden) {
        expect(
          pointInPolygonLonLat(
            lon: p.$2,
            lat: p.$1,
            ring: z.ringLonLat,
          ),
          false,
        );
      }
    }
  });

  test('under-keel requirement blocks shallow corridor', () {
    final demo = DemoGulfRoutingScenario.build();
    final g = demo.grid;
    final start = g.cellCenter(15, 15);
    final goal = g.cellCenter(16, 16);

    final r = computeAdvisoryRoute(
      grid: demo.grid,
      forbidden: demo.forbidden,
      draftM: 5,
      clearanceM: 5,
      startLat: start.$1,
      startLon: start.$2,
      goalLat: goal.$1,
      goalLon: goal.$2,
    );

    expect(r.isOk, false);
    expect(r.failureReason, isNotNull);
  });
}
