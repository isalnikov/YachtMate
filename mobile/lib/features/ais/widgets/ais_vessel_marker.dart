import 'dart:math' as math;

import 'package:maplibre_gl/maplibre_gl.dart';

import '../../../domain/ais/ais_target.dart';
import '../../../domain/ais/ais_vessel_category.dart';
import '../ais_filter_provider.dart';

const cwAisVesselSourceId = 'cw_ais_vessel_shapes';
const cwAisVesselFillLayerId = 'cw_ais_vessel_fill';
const cwAisVesselVectorLayerId = 'cw_ais_vessel_vectors';
const cwAisVesselHitLayerId = 'cw_ais_vessel_hit';

const _earthRadiusM = 6371000.0;
const _toRad = math.pi / 180;

String _categoryColor(AisVesselCategory category) => switch (category) {
      AisVesselCategory.cargo => '#A78BFA',
      AisVesselCategory.tanker => '#F472B6',
      AisVesselCategory.pleasure => '#34D399',
    };

List<double> _offsetLonLat(
  double latDeg,
  double lonDeg,
  double bearingDeg,
  double distM,
) {
  final br = bearingDeg * _toRad;
  final dLat = (distM / _earthRadiusM) * math.cos(br) * (180 / math.pi);
  final dLon =
      (distM / _earthRadiusM) *
      math.sin(br) *
      (180 / math.pi) /
      math.cos(latDeg * _toRad);
  return [lonDeg + dLon, latDeg + dLat];
}

/// Closed ring for a small triangle hull oriented along [cogDeg].
List<List<double>> vesselTriangleRing(
  double latDeg,
  double lonDeg,
  double cogDeg, {
  double aheadM = 180,
  double beamM = 70,
}) {
  final tip = _offsetLonLat(latDeg, lonDeg, cogDeg, aheadM);
  final port = _offsetLonLat(latDeg, lonDeg, cogDeg + 150, beamM);
  final stbd = _offsetLonLat(latDeg, lonDeg, cogDeg - 150, beamM);
  return [
    tip,
    port,
    stbd,
    tip,
  ];
}

/// Short heading vector from the vessel centroid.
List<List<double>> vesselHeadingLine(
  double latDeg,
  double lonDeg,
  double cogDeg, {
  double lengthM = 320,
}) {
  final end = _offsetLonLat(latDeg, lonDeg, cogDeg, lengthM);
  return [
    [lonDeg, latDeg],
    end,
  ];
}

Iterable<AisTarget> filterAisTargets(
  Map<int, AisTarget> targets,
  AisFilterSelection filter,
) {
  return targets.values.where((t) => filter.matches(t.category));
}

Map<String, dynamic> aisVesselsToGeoJson(
  Map<int, AisTarget> targets,
  AisFilterSelection filter,
) {
  final features = <Map<String, dynamic>>[];
  for (final t in filterAisTargets(targets, filter)) {
    final color = _categoryColor(t.category);
    features.add({
      'type': 'Feature',
      'properties': {
        'mmsi': t.mmsi,
        'name': t.displayName,
        'category': t.category.name,
        'fill': color,
      },
      'geometry': {
        'type': 'Polygon',
        'coordinates': [
          vesselTriangleRing(t.latitudeDeg, t.longitudeDeg, t.cogDegrees),
        ],
      },
    });
    features.add({
      'type': 'Feature',
      'properties': {
        'mmsi': t.mmsi,
        'stroke': color,
      },
      'geometry': {
        'type': 'LineString',
        'coordinates': vesselHeadingLine(
          t.latitudeDeg,
          t.longitudeDeg,
          t.cogDegrees,
        ),
      },
    });
    features.add({
      'type': 'Feature',
      'properties': {'mmsi': t.mmsi},
      'geometry': {
        'type': 'Point',
        'coordinates': [t.longitudeDeg, t.latitudeDeg],
      },
    });
  }
  return {'type': 'FeatureCollection', 'features': features};
}

Future<void> installAisVesselLayers(MapLibreMapController c) async {
  final empty = aisVesselsToGeoJson(const {}, AisFilterSelection.all);
  await c.addGeoJsonSource(cwAisVesselSourceId, empty);

  await c.addFillLayer(
    cwAisVesselSourceId,
    cwAisVesselFillLayerId,
    const FillLayerProperties(
      fillColor: ['get', 'fill'],
      fillOpacity: 0.88,
      fillOutlineColor: '#FFFFFF',
    ),
    filter: ['==', ['geometry-type'], 'Polygon'],
  );

  await c.addLineLayer(
    cwAisVesselSourceId,
    cwAisVesselVectorLayerId,
    const LineLayerProperties(
      lineColor: ['get', 'stroke'],
      lineWidth: 2.2,
      lineOpacity: 0.95,
    ),
    filter: ['==', ['geometry-type'], 'LineString'],
  );

  await c.addCircleLayer(
    cwAisVesselSourceId,
    cwAisVesselHitLayerId,
    const CircleLayerProperties(
      circleRadius: 16,
      circleOpacity: 0.01,
      circleColor: '#FFFFFF',
    ),
    filter: ['==', ['geometry-type'], 'Point'],
  );
}

Future<void> updateAisVesselLayers(
  MapLibreMapController c,
  Map<int, AisTarget> targets,
  AisFilterSelection filter,
) async {
  try {
    await c.setGeoJsonSource(
      cwAisVesselSourceId,
      aisVesselsToGeoJson(targets, filter),
    );
  } catch (_) {
    // Style reload race — safe to ignore in demo mode.
  }
}
