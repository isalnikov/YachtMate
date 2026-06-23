import 'package:flutter/material.dart';

import 'cw_tokens.dart';

/// Semantic color tokens exposed via [ThemeData.extensions].
@immutable
class CwColors extends ThemeExtension<CwColors> {
  const CwColors({
    required this.deckBlue,
    required this.panelBlue,
    required this.accentTeal,
    required this.accentOrange,
    required this.textPrimary,
    required this.textMuted,
    required this.danger,
    required this.safe,
    required this.windScale,
  });

  final Color deckBlue;
  final Color panelBlue;
  final Color accentTeal;
  final Color accentOrange;
  final Color textPrimary;
  final Color textMuted;
  final Color danger;
  final Color safe;
  final List<Color> windScale;

  static const light = CwColors(
    deckBlue: CwPalette.deckBlue,
    panelBlue: CwPalette.panelBlue,
    accentTeal: CwPalette.accentTeal,
    accentOrange: CwPalette.accentOrange,
    textPrimary: CwPalette.textPrimary,
    textMuted: CwPalette.textMuted,
    danger: CwPalette.danger,
    safe: CwPalette.safe,
    windScale: CwPalette.windScale,
  );

  /// Night red mode — red-tinted marine tokens for chart readability (step-26).
  static const nightRed = CwColors(
    deckBlue: CwPalette.nightBg,
    panelBlue: CwPalette.nightPanel,
    accentTeal: CwPalette.nightRed,
    accentOrange: CwPalette.nightRed,
    textPrimary: CwPalette.nightText,
    textMuted: CwPalette.nightTextMuted,
    danger: const Color(0xFFFF4444),
    safe: const Color(0xFF66AA66),
    windScale: CwPalette.nightWindScale,
  );

  @override
  CwColors copyWith({
    Color? deckBlue,
    Color? panelBlue,
    Color? accentTeal,
    Color? accentOrange,
    Color? textPrimary,
    Color? textMuted,
    Color? danger,
    Color? safe,
    List<Color>? windScale,
  }) {
    return CwColors(
      deckBlue: deckBlue ?? this.deckBlue,
      panelBlue: panelBlue ?? this.panelBlue,
      accentTeal: accentTeal ?? this.accentTeal,
      accentOrange: accentOrange ?? this.accentOrange,
      textPrimary: textPrimary ?? this.textPrimary,
      textMuted: textMuted ?? this.textMuted,
      danger: danger ?? this.danger,
      safe: safe ?? this.safe,
      windScale: windScale ?? this.windScale,
    );
  }

  @override
  CwColors lerp(covariant ThemeExtension<CwColors>? other, double t) {
    if (other is! CwColors) return this;
    return CwColors(
      deckBlue: Color.lerp(deckBlue, other.deckBlue, t)!,
      panelBlue: Color.lerp(panelBlue, other.panelBlue, t)!,
      accentTeal: Color.lerp(accentTeal, other.accentTeal, t)!,
      accentOrange: Color.lerp(accentOrange, other.accentOrange, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      safe: Color.lerp(safe, other.safe, t)!,
      windScale: List.generate(
        windScale.length,
        (i) => Color.lerp(windScale[i], other.windScale[i], t)!,
      ),
    );
  }
}

extension CwColorsContext on BuildContext {
  CwColors get cwColors => Theme.of(this).extension<CwColors>()!;
}
