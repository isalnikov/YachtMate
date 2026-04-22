import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import '../../core/map_layer_preferences_controller.dart';
import 'map_navigation_asset.dart';

/// Идентификаторы стиля MapLibre для демо-слоёв (Фаза 2). См. `docs/data-licensing.md`.
const cwDemoDepthSourceId = 'cw_demo_depth';
const cwDemoDepthLayerId = 'cw_demo_depth_lines';
const cwDemoNavSourceId = 'cw_demo_nav';
const cwDemoNavLayerId = 'cw_demo_nav_circles';

Future<Map<String, dynamic>?> loadDemoLayersGeoJson() async {
  try {
    final raw = await rootBundle.loadString(kNavigationLayersGeoJsonAsset);
    return jsonDecode(raw) as Map<String, dynamic>;
  } catch (_) {
    return null;
  }
}

Map<String, dynamic> _featureCollectionOfLines(Map<String, dynamic> fc) {
  final feats = fc['features'];
  if (feats is! List<dynamic>) {
    return {'type': 'FeatureCollection', 'features': <dynamic>[]};
  }
  final out = <Map<String, dynamic>>[];
  for (final f in feats) {
    if (f is Map<String, dynamic>) {
      final g = f['geometry'];
      if (g is Map<String, dynamic> && g['type'] == 'LineString') {
        out.add(f);
      }
    }
  }
  return {'type': 'FeatureCollection', 'features': out};
}

Map<String, dynamic> _featureCollectionOfPoints(Map<String, dynamic> fc) {
  final feats = fc['features'];
  if (feats is! List<dynamic>) {
    return {'type': 'FeatureCollection', 'features': <dynamic>[]};
  }
  final out = <Map<String, dynamic>>[];
  for (final f in feats) {
    if (f is Map<String, dynamic>) {
      final g = f['geometry'];
      if (g is Map<String, dynamic> && g['type'] == 'Point') {
        out.add(f);
      }
    }
  }
  return {'type': 'FeatureCollection', 'features': out};
}

/// Добавляет источники и слои; при ошибке возвращает `false` (без падения UI).
Future<bool> installCwDemoLayers(
  MapLibreMapController controller,
  Map<String, dynamic> full,
  MapLayerVisibility visibility,
) async {
  try {
    final lines = _featureCollectionOfLines(full);
    final points = _featureCollectionOfPoints(full);

    await controller.addGeoJsonSource(cwDemoDepthSourceId, lines);
    await controller.addGeoJsonSource(cwDemoNavSourceId, points);

    await controller.addLineLayer(
      cwDemoDepthSourceId,
      cwDemoDepthLayerId,
      LineLayerProperties(
        lineColor: '#0277BD',
        lineWidth: 2.5,
        lineOpacity: 0.95,
        visibility: visibility.depthContours ? 'visible' : 'none',
      ),
    );

    await controller.addCircleLayer(
      cwDemoNavSourceId,
      cwDemoNavLayerId,
      CircleLayerProperties(
        circleRadius: 7,
        circleColor: '#FFC107',
        circleStrokeWidth: 2,
        circleStrokeColor: '#E65100',
        visibility: visibility.navigationAids ? 'visible' : 'none',
      ),
    );
    return true;
  } catch (_) {
    return false;
  }
}

Future<void> applyCwDemoLayerVisibility(
  MapLibreMapController controller,
  MapLayerVisibility visibility,
) async {
  try {
    await controller.setLayerProperties(
      cwDemoDepthLayerId,
      LineLayerProperties(
        visibility: visibility.depthContours ? 'visible' : 'none',
      ),
    );
    await controller.setLayerProperties(
      cwDemoNavLayerId,
      CircleLayerProperties(
        visibility: visibility.navigationAids ? 'visible' : 'none',
      ),
    );
  } catch (_) {
    // Нет слоя в стиле / гонка с перезагрузкой — Фаза 2 допускает тихую деградацию.
  }
}
