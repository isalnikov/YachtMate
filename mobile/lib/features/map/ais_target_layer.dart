import 'package:maplibre_gl/maplibre_gl.dart';

import '../../domain/ais/ais_target.dart';

const cwAisSourceId = 'cw_ais_targets';
const cwAisLayerId = 'cw_ais_targets_circles';

/// GeoJSON точек AIS для отображения на карте.
Map<String, dynamic> aisTargetsToGeoJson(Map<int, AisTarget> targets) {
  final features = <Map<String, dynamic>>[];
  for (final t in targets.values) {
    features.add({
      'type': 'Feature',
      'properties': {
        'mmsi': t.mmsi,
        'sog': t.sogKnots,
      },
      'geometry': {
        'type': 'Point',
        'coordinates': [t.longitudeDeg, t.latitudeDeg],
      },
    });
  }
  return {'type': 'FeatureCollection', 'features': features};
}

Future<void> installAisTargetLayer(MapLibreMapController c) async {
  final empty = aisTargetsToGeoJson(const {});
  await c.addGeoJsonSource(cwAisSourceId, empty);
  await c.addCircleLayer(
    cwAisSourceId,
    cwAisLayerId,
    const CircleLayerProperties(
      circleRadius: 9,
      circleColor: '#E91E63',
      circleOpacity: 0.92,
      circleStrokeWidth: 2,
      circleStrokeColor: '#880E4F',
    ),
  );
}

Future<void> updateAisTargetsLayer(
  MapLibreMapController c,
  Map<int, AisTarget> targets,
) async {
  try {
    await c.setGeoJsonSource(cwAisSourceId, aisTargetsToGeoJson(targets));
  } catch (_) {
    // Стиль мог быть перезагружен — Фаза 3 игнорирует гонку.
  }
}
