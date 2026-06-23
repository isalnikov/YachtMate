import 'dart:math' as math;

import 'package:flutter/material.dart' show Color;
import 'package:maplibre_gl/maplibre_gl.dart';

import '../../core/anchor_watch_controller.dart';
import '../../core/theme/cw_tokens.dart';
import '../../domain/anchor/geo.dart';

const cwAnchorCircleSourceId = 'cw_anchor_circle';
const cwAnchorCircleFillLayerId = 'cw_anchor_circle_fill';
const cwAnchorCircleLineLayerId = 'cw_anchor_circle_line';
const cwAnchorDriftSourceId = 'cw_anchor_drift';
const cwAnchorDriftLineLayerId = 'cw_anchor_drift_line';
const cwAnchorPointSourceId = 'cw_anchor_point';
const cwAnchorPointLayerId = 'cw_anchor_point_circle';
const cwVesselPointSourceId = 'cw_anchor_vessel';
const cwVesselPointLayerId = 'cw_anchor_vessel_circle';

String _hex(Color c) {
  final rgb = c.toARGB32() & 0xFFFFFF;
  return '#${rgb.toRadixString(16).padLeft(6, '0').toUpperCase()}';
}

final _zoneFill = _hex(CwPalette.accentTeal);
final _zoneStroke = _hex(CwPalette.accentTeal);
final _vesselFill = _hex(CwPalette.accentOrange);
final _anchorStroke = _hex(CwPalette.textPrimary);

Map<String, dynamic> _emptyFc() => {
      'type': 'FeatureCollection',
      'features': <dynamic>[],
    };

Map<String, dynamic> _circleGeoJson({
  required double anchorLat,
  required double anchorLon,
  required double radiusM,
}) {
  return {
    'type': 'FeatureCollection',
    'features': [
      {
        'type': 'Feature',
        'properties': const {'kind': 'zone'},
        'geometry': {
          'type': 'Polygon',
          'coordinates': [
            anchorCircleRing(
              anchorLat: anchorLat,
              anchorLon: anchorLon,
              radiusM: radiusM,
            ),
          ],
        },
      },
    ],
  };
}

Map<String, dynamic> _driftGeoJson(List<AnchorDriftPoint> history) {
  if (history.length < 2) return _emptyFc();
  return {
    'type': 'FeatureCollection',
    'features': [
      {
        'type': 'Feature',
        'properties': const {'kind': 'drift'},
        'geometry': {
          'type': 'LineString',
          'coordinates': history.map((p) => [p.lon, p.lat]).toList(),
        },
      },
    ],
  };
}

Map<String, dynamic> _anchorPointGeoJson({
  required double anchorLat,
  required double anchorLon,
}) {
  return {
    'type': 'FeatureCollection',
    'features': [
      {
        'type': 'Feature',
        'properties': const {'kind': 'anchor'},
        'geometry': {
          'type': 'Point',
          'coordinates': [anchorLon, anchorLat],
        },
      },
    ],
  };
}

Map<String, dynamic> _vesselPointGeoJson({
  required double? currentLat,
  required double? currentLon,
}) {
  if (currentLat == null || currentLon == null) return _emptyFc();
  return {
    'type': 'FeatureCollection',
    'features': [
      {
        'type': 'Feature',
        'properties': const {'kind': 'vessel'},
        'geometry': {
          'type': 'Point',
          'coordinates': [currentLon, currentLat],
        },
      },
    ],
  };
}

Future<void> installAnchorZoneLayers(MapLibreMapController c) async {
  await c.addGeoJsonSource(cwAnchorCircleSourceId, _emptyFc());
  await c.addGeoJsonSource(cwAnchorDriftSourceId, _emptyFc());
  await c.addGeoJsonSource(cwAnchorPointSourceId, _emptyFc());
  await c.addGeoJsonSource(cwVesselPointSourceId, _emptyFc());

  await c.addFillLayer(
    cwAnchorCircleSourceId,
    cwAnchorCircleFillLayerId,
    FillLayerProperties(
      fillColor: _zoneFill,
      fillOpacity: 0.12,
      fillOutlineColor: _zoneStroke,
    ),
  );
  await c.addLineLayer(
    cwAnchorCircleSourceId,
    cwAnchorCircleLineLayerId,
    LineLayerProperties(
      lineColor: _zoneStroke,
      lineWidth: 2,
      lineOpacity: 0.85,
    ),
  );
  await c.addLineLayer(
    cwAnchorDriftSourceId,
    cwAnchorDriftLineLayerId,
    LineLayerProperties(
      lineColor: '#8BA4BC',
      lineWidth: 2,
      lineOpacity: 0.55,
    ),
  );
  await c.addCircleLayer(
    cwAnchorPointSourceId,
    cwAnchorPointLayerId,
    CircleLayerProperties(
      circleRadius: 6,
      circleColor: _anchorStroke,
      circleStrokeWidth: 2,
      circleStrokeColor: _anchorStroke,
      circleOpacity: 0.9,
    ),
  );
  await c.addCircleLayer(
    cwVesselPointSourceId,
    cwVesselPointLayerId,
    CircleLayerProperties(
      circleRadius: 7,
      circleColor: _vesselFill,
      circleStrokeWidth: 2,
      circleStrokeColor: _anchorStroke,
      circleOpacity: 1,
    ),
  );
}

Future<void> updateAnchorZoneLayers(
  MapLibreMapController c, {
  required double anchorLat,
  required double anchorLon,
  required double radiusM,
  required double? currentLat,
  required double? currentLon,
  required List<AnchorDriftPoint> driftHistory,
}) async {
  try {
    await c.setGeoJsonSource(
      cwAnchorCircleSourceId,
      _circleGeoJson(
        anchorLat: anchorLat,
        anchorLon: anchorLon,
        radiusM: radiusM,
      ),
    );
    await c.setGeoJsonSource(
      cwAnchorDriftSourceId,
      _driftGeoJson(driftHistory),
    );
    await c.setGeoJsonSource(
      cwAnchorPointSourceId,
      _anchorPointGeoJson(anchorLat: anchorLat, anchorLon: anchorLon),
    );
    await c.setGeoJsonSource(
      cwVesselPointSourceId,
      _vesselPointGeoJson(currentLat: currentLat, currentLon: currentLon),
    );
  } catch (_) {}
}

/// Zoom level so the anchor circle fits the mini-map panel.
double anchorZoneMapZoom(double radiusM, double lat) {
  final diameterM = (radiusM * 2.4).clamp(60.0, 800.0);
  final latRad = lat * math.pi / 180;
  const worldMPerPxAtZoom0 = 156543.03392;
  const viewPx = 180.0;
  final zoom = worldMPerPxAtZoom0 * viewPx * math.cos(latRad) / diameterM;
  return (math.log(zoom) / math.ln2).clamp(11.0, 17.0);
}
