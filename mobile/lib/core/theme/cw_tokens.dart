import 'package:flutter/material.dart';

/// 8px-grid spacing tokens (design-system-spec §4).
abstract final class CwSpacing {
  static const double xs = 4;
  static const double s = 8;
  static const double m = 16;
  static const double l = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

/// Corner radius tokens (design-system-spec §4).
abstract final class CwRadius {
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double full = 999;
}

/// Raw color constants — core palette (§2.1) and marine data (§2.2).
abstract final class CwPalette {
  // Core (day/deck mode)
  static const Color deckBlue = Color(0xFF0D1B2A);
  static const Color panelBlue = Color(0xFF122438);
  static const Color accentTeal = Color(0xFF1ABC9C);
  static const Color accentOrange = Color(0xFFE67E22);
  static const Color textPrimary = Color(0xFFE8F4FC);
  static const Color textMuted = Color(0xFF8BA4BC);
  static const Color danger = Color(0xFFEF4444);
  static const Color safe = Color(0xFF22C55E);

  // Marine data — wind scale gradient stops
  static const Color windLowStart = Color(0xFF3B82F6); // 0–10 kn
  static const Color windLowEnd = Color(0xFF22D3EE);
  static const Color windMidStart = Color(0xFF22C55E); // 10–25 kn
  static const Color windMidEnd = Color(0xFFEAB308);
  static const Color windHighStart = Color(0xFFF97316); // 25+ kn
  static const Color windHighEnd = Color(0xFFEF4444);

  static const List<Color> windScale = [
    windLowStart,
    windLowEnd,
    windMidStart,
    windMidEnd,
    windHighStart,
    windHighEnd,
  ];

  // Marine data — depth & AIS
  static const Color depthShallow = Color(0xFFFBBF24);
  static const Color aisCargo = Color(0xFFA78BFA);
  static const Color aisPleasure = Color(0xFF34D399);

  // High contrast (§2.4)
  static const Color highContrastAccent = Color(0xFFFFE135);

  // Night red mode (§2.3 / step-26)
  static const Color nightBg = Color(0xFF1A0000);
  static const Color nightRed = Color(0xFFCC0000);
  static const Color nightText = Color(0xFFFF6666);
  static const Color nightPanel = Color(0xFF2A0808);
  static const Color nightTextMuted = Color(0xFFCC4444);

  /// Red-tinted wind scale stops — distinguishable on night background.
  static const List<Color> nightWindScale = [
    Color(0xFF880000), // 0–10 kn
    Color(0xFFAA2222),
    Color(0xFFCC4444), // 10–25 kn
    Color(0xFFDD5555),
    Color(0xFFEE3333), // 25+ kn
    Color(0xFFFF1111),
  ];
}
