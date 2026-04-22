import 'dart:convert';

import 'package:captain_wrongel/domain/map/demo_navigation_layers_index.dart';
import 'package:captain_wrongel/domain/routing/navigation_layers_depth_grid.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'buildNavigationLayersDepthGrid assigns depths near contour segments',
    () {
      final root =
          jsonDecode(r'''
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {"depth_m": 5},
      "geometry": {
        "type": "LineString",
        "coordinates": [[30.22, 59.91], [30.38, 59.95]]
      }
    }
  ]
}''')
              as Map<String, dynamic>;

      final idx = DemoNavigationLayersIndex.fromGeoJson(root);
      final grid = buildNavigationLayersDepthGrid(
        idx,
        originLatDeg: 59.88,
        originLonDeg: 30.15,
        rows: 24,
        cols: 32,
        latStepDeg: 0.002,
        lonStepDeg: 0.006,
        maxContourDistanceM: 4000,
      );

      var finite = 0;
      for (var i = 0; i < grid.rows; i++) {
        for (var j = 0; j < grid.cols; j++) {
          final d = grid.depthAtCell(i, j);
          if (d != null && !d.isNaN) finite++;
        }
      }
      expect(finite, greaterThan(0));
    },
  );

  test(
    'NavigationLayersRoutingScenario uses chart grid without forbidden zones',
    () {
      final root =
          jsonDecode('{"type":"FeatureCollection","features":[]}')
              as Map<String, dynamic>;
      final idx = DemoNavigationLayersIndex.fromGeoJson(root);
      final s = NavigationLayersRoutingScenario.fromIndex(idx);
      expect(s.forbidden, isEmpty);
      expect(s.grid.rows, greaterThan(0));
    },
  );
}
