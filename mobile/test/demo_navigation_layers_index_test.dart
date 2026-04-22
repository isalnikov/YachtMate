import 'dart:convert';

import 'package:captain_wrongel/domain/map/demo_navigation_layers_index.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('nearestContourDepthM finds segment depth near demo corridor', () {
    final idx = DemoNavigationLayersIndex.fromGeoJson(
      jsonDecode(_sampleGeoJson) as Map<String, dynamic>,
    );

    final d = idx.nearestContourDepthM(
      lat: 59.92,
      lon: 30.25,
      maxDistanceM: 2000,
    );
    expect(d, 5);
  });

  test('nearestNavAidLabel returns beacon name near point', () {
    final idx = DemoNavigationLayersIndex.fromGeoJson(
      jsonDecode(_sampleGeoJson) as Map<String, dynamic>,
    );

    final label = idx.nearestNavAidLabel(
      lat: 59.94,
      lon: 30.32,
      maxDistanceM: 100,
    );
    expect(label, 'Demo beacon');
  });

  test('empty collection yields null depth', () {
    final idx = DemoNavigationLayersIndex.fromGeoJson({
      'type': 'FeatureCollection',
      'features': <dynamic>[],
    });
    expect(idx.nearestContourDepthM(lat: 0, lon: 0), isNull);
  });
}

/// Subset of `assets/map/demo_navigation_layers.geojson` inlined for tests.
const _sampleGeoJson = '''
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {"depth_m": 5},
      "geometry": {
        "type": "LineString",
        "coordinates": [[30.22, 59.91], [30.28, 59.93], [30.38, 59.95]]
      }
    },
    {
      "type": "Feature",
      "properties": {"name": "Demo beacon"},
      "geometry": {
        "type": "Point",
        "coordinates": [30.32, 59.94]
      }
    }
  ]
}
''';
