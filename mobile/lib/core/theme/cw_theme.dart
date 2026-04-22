import 'package:flutter/material.dart';

/// Dark-first palette: deep blue deck, orange/teal accents (Фаза 0 / полировка §8).
abstract final class CwTheme {
  static const Color deckBlue = Color(0xFF0D1B2A);
  static const Color accentOrange = Color(0xFFE67E22);
  static const Color accentTeal = Color(0xFF1ABC9C);

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
      primary: const Color(0xFFFFE135),
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
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: surface,
        selectedIconTheme: const IconThemeData(color: Color(0xFFFFE135)),
        selectedLabelTextStyle: const TextStyle(color: Color(0xFFFFE135)),
        unselectedIconTheme: const IconThemeData(color: onSurface),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: const Color(0xFFFFE135).withValues(alpha: 0.35),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }
}
