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
}
