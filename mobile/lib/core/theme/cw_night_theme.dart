import 'package:flutter/material.dart';

import 'cw_theme_extensions.dart';
import 'cw_tokens.dart';
import 'cw_typography.dart';

/// Red night-watch palette — preserves dark adaptation (step-26 / §2.3).
abstract final class CwNightTheme {
  static const Color background = CwPalette.nightBg;
  static const Color primary = CwPalette.nightRed;
  static const Color textPrimary = CwPalette.nightText;

  static ThemeData material() {
    const onSurface = textPrimary;
    final scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: primary,
      onPrimary: background,
      secondary: const Color(0xFFAA0000),
      onSecondary: textPrimary,
      surface: background,
      onSurface: onSurface,
      error: const Color(0xFFFF4444),
      onError: background,
      surfaceContainerHighest: CwPalette.nightPanel,
      outline: const Color(0xFF994444),
      outlineVariant: const Color(0xFF662222),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      textTheme: CwTypography.textTheme(
        textPrimary: onSurface,
        textMuted: CwPalette.nightTextMuted,
      ),
      extensions: const [CwColors.nightRed],
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: background,
        selectedIconTheme: const IconThemeData(color: primary),
        selectedLabelTextStyle: const TextStyle(color: primary),
        unselectedIconTheme: const IconThemeData(color: onSurface),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: background,
        indicatorColor: primary.withValues(alpha: 0.35),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: onSurface,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: background,
        selectedItemColor: primary,
        unselectedItemColor: CwPalette.nightTextMuted,
      ),
      drawerTheme: const DrawerThemeData(backgroundColor: background),
    );
  }
}
