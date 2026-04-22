import 'package:maplibre_gl/maplibre_gl.dart';

import '../../data/local/app_database.dart';

const cwMooringSourceId = 'cw_mooring_places';
const cwMooringCircleLayerId = 'cw_mooring_places_circles';

Map<String, dynamic> mooringPlacesToGeoJson(List<MooringPlaceRow> rows) {
  final features = <Map<String, dynamic>>[];
  for (final p in rows) {
    features.add({
      'type': 'Feature',
      'properties': {'id': p.id, 'kind': p.kind, 'name': p.name},
      'geometry': {
        'type': 'Point',
        'coordinates': [p.lon, p.lat],
      },
    });
  }
  return {'type': 'FeatureCollection', 'features': features};
}

Future<void> installMooringPlacesLayer(MapLibreMapController c) async {
  await c.addGeoJsonSource(cwMooringSourceId, mooringPlacesToGeoJson(const []));
  await c.addCircleLayer(
    cwMooringSourceId,
    cwMooringCircleLayerId,
    CircleLayerProperties(
      circleRadius: 10,
      circleOpacity: 0.9,
      circleStrokeWidth: 2,
      circleStrokeColor: '#FFFFFF',
      circleColor: [
        'match',
        ['get', 'kind'],
        'marina',
        '#1565C0',
        'anchorage',
        '#2E7D32',
        '#757575',
      ],
    ),
  );
}

Future<void> updateMooringPlacesLayer(
  MapLibreMapController c,
  List<MooringPlaceRow> rows,
) async {
  try {
    await c.setGeoJsonSource(cwMooringSourceId, mooringPlacesToGeoJson(rows));
  } catch (_) {}
}

Future<void> applyMooringPlacesVisibility(
  MapLibreMapController c,
  bool visible,
) async {
  try {
    await c.setLayerProperties(
      cwMooringCircleLayerId,
      CircleLayerProperties(visibility: visible ? 'visible' : 'none'),
    );
  } catch (_) {}
}
