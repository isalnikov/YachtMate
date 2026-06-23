import 'package:flutter/material.dart';

import 'cw_night_theme.dart';
import 'cw_theme.dart';

/// Active app chrome palette: deck (default), night red, or high contrast.
enum CwThemeMode {
  deck,
  nightRed,
  highContrast;

  /// High contrast wins over night red; both are independent user prefs.
  static CwThemeMode resolve({
    required bool nightRedEnabled,
    required bool highContrastEnabled,
  }) {
    if (highContrastEnabled) return CwThemeMode.highContrast;
    if (nightRedEnabled) return CwThemeMode.nightRed;
    return CwThemeMode.deck;
  }

  ThemeData get materialTheme => switch (this) {
    CwThemeMode.deck => CwTheme.material(),
    CwThemeMode.nightRed => CwNightTheme.material(),
    CwThemeMode.highContrast => CwTheme.materialHighContrast(),
  };

  /// When leaving night red UI, charts can switch back to a day palette.
  bool get prefersChartNightPalette => this == CwThemeMode.nightRed;
}
