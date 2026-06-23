import 'package:flutter/material.dart';

import 'cw_theme_extensions.dart';
import 'cw_tokens.dart';
import 'cw_typography.dart';

/// Dark-first palette: deep blue deck, orange/teal accents (Фаза 0 / полировка §8).
abstract final class CwTheme {
  static const Color deckBlue = CwPalette.deckBlue;
  static const Color accentOrange = CwPalette.accentOrange;
  static const Color accentTeal = CwPalette.accentTeal;

  static ThemeData material() {
    final scheme = ColorScheme.fromSeed(
      seedColor: accentTeal,
      brightness: Brightness.dark,
      primary: accentTeal,
      secondary: accentOrange,
      surface: deckBlue,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: deckBlue,
      textTheme: CwTypography.textTheme(
        textPrimary: CwColors.light.textPrimary,
        textMuted: CwColors.light.textMuted,
      ),
      extensions: const [CwColors.light],
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: deckBlue,
        indicatorColor: accentTeal.withValues(alpha: 0.35),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }

  /// Высокая контрастность: тёмный фон, почти белый текст, акцент жёлтый (Фаза 8).
  static ThemeData materialHighContrast() {
    const surface = Color(0xFF000000);
    const onSurface = Color(0xFFF5F5F5);
    final scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: CwPalette.highContrastAccent,
      onPrimary: Colors.black,
      secondary: accentTeal,
      onSecondary: Colors.black,
      surface: surface,
      onSurface: onSurface,
      error: const Color(0xFFFF5252),
      onError: Colors.black,
      surfaceContainerHighest: const Color(0xFF1C1C1C),
      outline: const Color(0xFFBDBDBD),
      outlineVariant: Color(0xFF616161),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: surface,
      textTheme: CwTypography.textTheme(
        textPrimary: onSurface,
        textMuted: const Color(0xFFBDBDBD),
      ),
      extensions: const [CwColors.light],
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: surface,
        selectedIconTheme: const IconThemeData(color: CwPalette.highContrastAccent),
        selectedLabelTextStyle: const TextStyle(color: CwPalette.highContrastAccent),
        unselectedIconTheme: const IconThemeData(color: onSurface),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: CwPalette.highContrastAccent.withValues(alpha: 0.35),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }
}
