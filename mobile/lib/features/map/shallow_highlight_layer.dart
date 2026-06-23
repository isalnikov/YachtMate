import 'package:flutter/material.dart' show Color;
import 'package:maplibre_gl/maplibre_gl.dart';

import '../../core/theme/cw_tokens.dart';
import '../../domain/routing/depth_grid.dart';
import '../../domain/routing/navigation_layers_depth_grid.dart';

const cwShallowHighlightSourceId = 'cw_shallow_highlight';
const cwShallowHighlightLayerId = 'cw_shallow_highlight_fill';

String _hexRgb(Color color) {
  final rgb = color.toARGB32() & 0xFFFFFF;
  return '#${rgb.toRadixString(16).padLeft(6, '0').toUpperCase()}';
}

/// MapLibre fill color — [CwPalette.depthShallow].
final kShallowHighlightFillColor = _hexRgb(CwPalette.depthShallow);

List<List<double>> _cellPolygonRing(DepthGrid grid, int row, int col) {
  final lat0 = grid.originLatDeg + row * grid.latStepDeg;
  final lat1 = lat0 + grid.latStepDeg;
  final lon0 = grid.originLonDeg + col * grid.lonStepDeg;
  final lon1 = lon0 + grid.lonStepDeg;
  return [
    [lon0, lat0],
    [lon1, lat0],
    [lon1, lat1],
    [lon0, lat1],
    [lon0, lat0],
  ];
}

/// GeoJSON fill polygons for shallow cells on the demo depth grid.
Map<String, dynamic> shallowCellsToGeoJson(DepthGrid grid, double needDepthM) {
  final features = <Map<String, dynamic>>[];
  for (final (row, col) in collectShallowCells(grid, needDepthM)) {
    features.add({
      'type': 'Feature',
      'properties': const {'kind': 'shallow'},
      'geometry': {
        'type': 'Polygon',
        'coordinates': [_cellPolygonRing(grid, row, col)],
      },
    });
  }
  return {'type': 'FeatureCollection', 'features': features};
}

Future<void> installShallowHighlightLayer(MapLibreMapController c) async {
  await c.addGeoJsonSource(cwShallowHighlightSourceId, {
    'type': 'FeatureCollection',
    'features': <dynamic>[],
  });
  await c.addFillLayer(
    cwShallowHighlightSourceId,
    cwShallowHighlightLayerId,
    FillLayerProperties(
      fillColor: kShallowHighlightFillColor,
      fillOpacity: 0.35,
      fillOutlineColor: kShallowHighlightFillColor,
    ),
  );
}

Future<void> updateShallowHighlightLayer(
  MapLibreMapController c, {
  required DepthGrid grid,
  required double needDepthM,
}) async {
  try {
    await c.setGeoJsonSource(
      cwShallowHighlightSourceId,
      shallowCellsToGeoJson(grid, needDepthM),
    );
  } catch (_) {}
}

Future<void> applyShallowHighlightVisibility(
  MapLibreMapController c,
  bool visible,
) async {
  try {
    await c.setLayerProperties(
      cwShallowHighlightLayerId,
      FillLayerProperties(visibility: visible ? 'visible' : 'none'),
    );
  } catch (_) {}
}
