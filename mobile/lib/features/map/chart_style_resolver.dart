import '../../core/theme/cw_theme_mode.dart';
import 'map_layer_kinds.dart';

/// MapLibre base style URLs per chart palette (free / prototype tiles).
abstract class ChartStyleUrls {
  static const standard = 'https://demotiles.maplibre.org/style.json';
  static const paper = 'https://tiles.openfreemap.org/styles/bright';
  static const simple = 'https://tiles.openfreemap.org/styles/positron';
  static const night = 'https://tiles.openfreemap.org/styles/dark';
}

/// Resolves the effective MapLibre [style.json] URL from chart pref and theme.
///
/// Night red UI ([CwThemeMode.nightRed]) or explicit [ChartStyleKind.night]
/// both select the dark chart palette.
String chartStyleUrlFor({
  required ChartStyleKind chartStyle,
  required CwThemeMode themeMode,
}) {
  if (themeMode.prefersChartNightPalette ||
      chartStyle == ChartStyleKind.night) {
    return ChartStyleUrls.night;
  }

  return switch (chartStyle) {
    ChartStyleKind.standard => ChartStyleUrls.standard,
    ChartStyleKind.paper => ChartStyleUrls.paper,
    ChartStyleKind.simple => ChartStyleUrls.simple,
    ChartStyleKind.night => ChartStyleUrls.night,
  };
}

/// Convenience when theme is derived from persisted settings flags.
String chartStyleUrlFromPrefs({
  required ChartStyleKind chartStyle,
  required bool nightRedEnabled,
  required bool highContrastEnabled,
}) {
  return chartStyleUrlFor(
    chartStyle: chartStyle,
    themeMode: CwThemeMode.resolve(
      nightRedEnabled: nightRedEnabled,
      highContrastEnabled: highContrastEnabled,
    ),
  );
}
