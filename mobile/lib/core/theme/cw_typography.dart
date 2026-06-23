import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';

import 'cw_theme_extensions.dart';

/// Captain Wrongel typography tokens (design-system-spec §3).
abstract final class CwTypography {
  static TextTheme textTheme({
    required Color textPrimary,
    required Color textMuted,
  }) {
    return TextTheme(
      displayLarge: display(color: textPrimary),
      headlineLarge: h1(color: textPrimary),
      headlineMedium: h2(color: textPrimary),
      bodyLarge: body(color: textPrimary),
      bodySmall: caption(color: textMuted),
      labelLarge: button(color: textPrimary),
    );
  }

  static TextStyle display({required Color color}) => TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        height: 1.2,
        color: color,
      );

  static TextStyle h1({required Color color}) => TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.25,
        color: color,
      );

  static TextStyle h2({required Color color}) => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: color,
      );

  static TextStyle body({required Color color}) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: color,
      );

  static TextStyle caption({required Color color}) => TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: color,
      );

  static TextStyle button({required Color color}) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.0,
        color: color,
      );

  static TextStyle monoCoords({required Color color}) => TextStyle(
        fontFamily: 'monospace',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.2,
        fontFeatures: const [FontFeature.tabularFigures()],
        color: color,
      );

  /// Formats [lat] and [lon] as DD°MM.mmm' with N/S/E/W hemispheres.
  static String formatCoords(double lat, double lon) {
    return '${_formatAxis(lat, padDegrees: 2, pos: 'N', neg: 'S')} '
        '${_formatAxis(lon, padDegrees: 3, pos: 'E', neg: 'W')}';
  }

  static String _formatAxis(
    double value, {
    required int padDegrees,
    required String pos,
    required String neg,
  }) {
    final hemisphere = value >= 0 ? pos : neg;
    final absolute = value.abs();
    final degrees = absolute.floor();
    final minutes = (absolute - degrees) * 60;
    final degreesText = degrees.toString().padLeft(padDegrees, '0');
    final minutesText = minutes.toStringAsFixed(3).padLeft(6, '0');
    return '$degreesText°$minutesText\' $hemisphere';
  }

  /// Coordinate label using [monoCoords] and semantic colors from theme.
  static Widget coords(BuildContext context, double lat, double lon) {
    final colors = context.cwColors;
    return Text(
      formatCoords(lat, lon),
      style: monoCoords(color: colors.textPrimary),
    );
  }
}
