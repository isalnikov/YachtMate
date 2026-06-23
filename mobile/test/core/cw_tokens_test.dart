import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/core/theme/cw_theme_extensions.dart';
import 'package:captain_wrongel/core/theme/cw_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CwSpacing', () {
    test('matches 8px grid', () {
      expect(CwSpacing.xs, 4);
      expect(CwSpacing.s, 8);
      expect(CwSpacing.m, 16);
      expect(CwSpacing.l, 24);
      expect(CwSpacing.xl, 32);
      expect(CwSpacing.xxl, 48);
    });
  });

  group('CwRadius', () {
    test('matches design spec', () {
      expect(CwRadius.sm, 8);
      expect(CwRadius.md, 16);
      expect(CwRadius.lg, 24);
    });
  });

  group('CwPalette', () {
    test('core colors match hex spec', () {
      expect(CwPalette.deckBlue, const Color(0xFF0D1B2A));
      expect(CwPalette.panelBlue, const Color(0xFF122438));
      expect(CwPalette.accentTeal, const Color(0xFF1ABC9C));
      expect(CwPalette.accentOrange, const Color(0xFFE67E22));
      expect(CwPalette.textPrimary, const Color(0xFFE8F4FC));
      expect(CwPalette.textMuted, const Color(0xFF8BA4BC));
      expect(CwPalette.danger, const Color(0xFFEF4444));
      expect(CwPalette.safe, const Color(0xFF22C55E));
      expect(CwPalette.nightBg, const Color(0xFF1A0000));
      expect(CwPalette.nightRed, const Color(0xFFCC0000));
      expect(CwPalette.nightText, const Color(0xFFFF6666));
    });

    test('windScale has six gradient stops', () {
      expect(CwPalette.windScale, hasLength(6));
      expect(CwPalette.windScale.first, const Color(0xFF3B82F6));
      expect(CwPalette.windScale.last, CwPalette.danger);
    });
  });

  group('CwColors ThemeExtension', () {
    test('light preset mirrors palette', () {
      expect(CwColors.light.deckBlue, CwPalette.deckBlue);
      expect(CwColors.light.windScale, CwPalette.windScale);
    });

    testWidgets('registered on CwTheme.material()', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CwTheme.material(),
          home: Builder(
            builder: (context) {
              final colors = Theme.of(context).extension<CwColors>();
              expect(colors, isNotNull);
              expect(context.cwColors.deckBlue, CwPalette.deckBlue);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('registered on CwTheme.materialHighContrast()', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CwTheme.materialHighContrast(),
          home: Builder(
            builder: (context) {
              expect(Theme.of(context).extension<CwColors>(), isNotNull);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    test('nightRed preset mirrors night palette', () {
      expect(CwColors.nightRed.deckBlue, CwPalette.nightBg);
      expect(CwColors.nightRed.accentTeal, CwPalette.nightRed);
      expect(CwColors.nightRed.windScale, CwPalette.nightWindScale);
    });
  });
}
