import 'package:captain_wrongel/core/theme/cw_theme_mode.dart';
import 'package:captain_wrongel/features/map/chart_style_resolver.dart';
import 'package:captain_wrongel/features/map/map_layer_kinds.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('chartStyleUrlFor', () {
    test('standard deck uses demo tiles', () {
      expect(
        chartStyleUrlFor(
          chartStyle: ChartStyleKind.standard,
          themeMode: CwThemeMode.deck,
        ),
        ChartStyleUrls.standard,
      );
    });

    test('paper deck uses bright openfreemap style', () {
      expect(
        chartStyleUrlFor(
          chartStyle: ChartStyleKind.paper,
          themeMode: CwThemeMode.deck,
        ),
        ChartStyleUrls.paper,
      );
    });

    test('simple deck uses positron style', () {
      expect(
        chartStyleUrlFor(
          chartStyle: ChartStyleKind.simple,
          themeMode: CwThemeMode.deck,
        ),
        ChartStyleUrls.simple,
      );
    });

    test('explicit night chart style uses dark tiles', () {
      expect(
        chartStyleUrlFor(
          chartStyle: ChartStyleKind.night,
          themeMode: CwThemeMode.deck,
        ),
        ChartStyleUrls.night,
      );
    });

    test('night red theme forces night chart regardless of chart pref', () {
      expect(
        chartStyleUrlFor(
          chartStyle: ChartStyleKind.standard,
          themeMode: CwThemeMode.nightRed,
        ),
        ChartStyleUrls.night,
      );
      expect(
        chartStyleUrlFor(
          chartStyle: ChartStyleKind.paper,
          themeMode: CwThemeMode.nightRed,
        ),
        ChartStyleUrls.night,
      );
    });

    test('high contrast wins over night red for chart palette', () {
      expect(
        chartStyleUrlFromPrefs(
          chartStyle: ChartStyleKind.standard,
          nightRedEnabled: true,
          highContrastEnabled: true,
        ),
        ChartStyleUrls.standard,
      );
    });
  });

  group('chartStyleUrlFromPrefs', () {
    test('matches chartStyleUrlFor for resolved theme', () {
      expect(
        chartStyleUrlFromPrefs(
          chartStyle: ChartStyleKind.simple,
          nightRedEnabled: false,
          highContrastEnabled: false,
        ),
        chartStyleUrlFor(
          chartStyle: ChartStyleKind.simple,
          themeMode: CwThemeMode.deck,
        ),
      );
    });
  });
}
