import 'dart:math' show cos, pi, sin;

import 'package:flutter/material.dart' show Color;
import 'package:maplibre_gl/maplibre_gl.dart';

import '../../domain/weather/wind_grid.dart';
import '../weather/widgets/wind_legend_bar.dart';

const cwWindOverlaySourceId = 'cw_wind_overlay';
const cwWindOverlayLayerId = 'cw_wind_overlay_lines';

String _hexRgb(Color color) {
  final rgb = color.toARGB32() & 0xFFFFFF;
  return '#${rgb.toRadixString(16).padLeft(6, '0').toUpperCase()}';
}

/// Arrow endpoint in degrees for meteorological wind-from bearing.
({double lat, double lon}) windArrowTip({
  required double lat,
  required double lon,
  required double windFromDeg,
  required double speedKn,
}) {
  final toDeg = (windFromDeg + 180) % 360;
  final rad = toDeg * pi / 180;
  final lenDeg = 0.012 + (speedKn.clamp(0, 45) / 45) * 0.04;
  final dLat = lenDeg * cos(rad);
  final dLon = lenDeg * sin(rad) / cos(lat * pi / 180).clamp(0.2, 1.0);
  return (lat: lat + dLat, lon: lon + dLon);
}

/// GeoJSON line arrows colored by wind speed.
Map<String, dynamic> windGridToGeoJson(
  WindGridBundle grid,
  List<Color> windScale,
) {
  final features = <Map<String, dynamic>>[];
  for (final c in grid.cells) {
    if (c.windSpeedKn.isNaN) continue;
    final tip = windArrowTip(
      lat: c.lat,
      lon: c.lon,
      windFromDeg: c.windDirectionDeg,
      speedKn: c.windSpeedKn,
    );
    final color = _hexRgb(windColorForKn(c.windSpeedKn, windScale));
    features.add({
      'type': 'Feature',
      'properties': {
        'speedKn': c.windSpeedKn,
        'color': color,
      },
      'geometry': {
        'type': 'LineString',
        'coordinates': [
          [c.lon, c.lat],
          [tip.lon, tip.lat],
        ],
      },
    });
  }
  return {'type': 'FeatureCollection', 'features': features};
}

Future<void> installWindOverlayLayer(MapLibreMapController c) async {
  await c.addGeoJsonSource(cwWindOverlaySourceId, {
    'type': 'FeatureCollection',
    'features': <dynamic>[],
  });
  await c.addLineLayer(
    cwWindOverlaySourceId,
    cwWindOverlayLayerId,
    const LineLayerProperties(
      lineColor: ['get', 'color'],
      lineWidth: 2.8,
      lineOpacity: 0.88,
      lineCap: 'round',
    ),
  );
}

Future<void> updateWindOverlayLayer(
  MapLibreMapController c, {
  required WindGridBundle grid,
  required List<Color> windScale,
}) async {
  try {
    await c.setGeoJsonSource(
      cwWindOverlaySourceId,
      windGridToGeoJson(grid, windScale),
    );
  } catch (_) {}
}

Future<void> applyWindOverlayVisibility(
  MapLibreMapController c,
  bool visible,
) async {
  try {
    await c.setLayerProperties(
      cwWindOverlayLayerId,
      LineLayerProperties(visibility: visible ? 'visible' : 'none'),
    );
  } catch (_) {}
}
