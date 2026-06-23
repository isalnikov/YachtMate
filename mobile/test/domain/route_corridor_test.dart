import 'dart:math' as math;

import 'package:captain_wrongel/domain/routing/point_in_polygon.dart';
import 'package:captain_wrongel/domain/routing/route_corridor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('computeRouteCorridorRing returns empty for short polyline', () {
    expect(computeRouteCorridorRing(polyline: []), isEmpty);
    expect(
      computeRouteCorridorRing(polyline: [(lat: 36.0, lon: 29.0)]),
      isEmpty,
    );
  });

  test('straight segment buffer contains centerline and width ~100m', () {
    const lat1 = 36.0;
    const lon = 29.0;
    const lat2 = 36.01;
    const buffer = kRouteCorridorBufferMeters;

    final ring = computeRouteCorridorRing(
      polyline: [(lat: lat1, lon: lon), (lat: lat2, lon: lon)],
      bufferMeters: buffer,
    );

    expect(ring.length, greaterThan(4));

    final midLat = (lat1 + lat2) / 2;
    expect(
      pointInPolygonLonLat(lon: lon, lat: midLat, ring: ring),
      isTrue,
    );

    final mPerDegLon = 111320.0 * math.cos(midLat * math.pi / 180);
    final insideOffset = (buffer * 0.5) / mPerDegLon;
    final outsideOffset = (buffer * 1.2) / mPerDegLon;

    expect(
      pointInPolygonLonLat(lon: lon + insideOffset, lat: midLat, ring: ring),
      isTrue,
    );
    expect(
      pointInPolygonLonLat(lon: lon + outsideOffset, lat: midLat, ring: ring),
      isFalse,
    );
  });

  test('segmentInitialBearingDegrees is north for due-north segment', () {
    final bearing = segmentInitialBearingDegrees(36.0, 29.0, 37.0, 29.0);
    expect(bearing, closeTo(0, 0.5));
  });

  test('formatRouteLegLabel matches iSailor-style text', () {
    expect(
      formatRouteLegLabel(bearingDeg: 315.4, distanceNm: 0.44),
      '315° · 0.44 nm',
    );
  });

  test('routeLegSegments builds one leg per segment', () {
    final legs = routeLegSegments([
      (lat: 36.0, lon: 29.0),
      (lat: 36.01, lon: 29.0),
      (lat: 36.02, lon: 29.01),
    ]);
    expect(legs.length, 2);
    expect(legs.first.bearingDeg, closeTo(0, 1));
    expect(legs.first.distanceNm, greaterThan(0));
  });
}
