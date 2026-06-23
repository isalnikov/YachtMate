import 'package:captain_wrongel/domain/weather/wind_grid.dart';
import 'package:captain_wrongel/features/map/map_wind_overlay_layer.dart';
import 'package:captain_wrongel/features/weather/widgets/wind_legend_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:captain_wrongel/core/theme/cw_tokens.dart';

void main() {
  group('windArrowTip', () {
    test('points downwind from meteorological bearing', () {
      final tip = windArrowTip(
        lat: 36.0,
        lon: 29.0,
        windFromDeg: 0,
        speedKn: 20,
      );
      expect(tip.lat, lessThan(36.0));
      expect(tip.lon, closeTo(29.0, 0.01));
    });
  });

  group('windGridToGeoJson', () {
    test('emits one line feature per cell with color', () {
      final grid = WindGridBundle(
        fetchedAtUtc: DateTime.utc(2026, 1, 1),
        cells: const [
          WindGridCell(
            lat: 36.0,
            lon: 29.0,
            windSpeedKn: 15,
            windDirectionDeg: 270,
          ),
        ],
      );
      final geo = windGridToGeoJson(grid, CwPalette.windScale);
      final features = geo['features'] as List<dynamic>;
      expect(features, hasLength(1));
      final props = (features.first as Map)['properties'] as Map;
      expect(props['speedKn'], 15);
      expect(props['color'], isA<String>());
      expect(
        windColorForKn(15, CwPalette.windScale),
        isA<Color>(),
      );
    });
  });
}
