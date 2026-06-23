import 'package:captain_wrongel/core/theme/cw_night_theme.dart';
import 'package:captain_wrongel/core/theme/cw_theme_extensions.dart';
import 'package:captain_wrongel/core/theme/cw_theme_mode.dart';
import 'package:captain_wrongel/core/theme/cw_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CwNightTheme', () {
    test('uses night red palette tokens', () {
      expect(CwNightTheme.background, const Color(0xFF1A0000));
      expect(CwNightTheme.primary, const Color(0xFFCC0000));
      expect(CwNightTheme.textPrimary, const Color(0xFFFF6666));
    });

    test('material() registers night CwColors extension', () {
      final theme = CwNightTheme.material();
      expect(theme.scaffoldBackgroundColor, CwNightTheme.background);
      expect(theme.colorScheme.primary, CwNightTheme.primary);
      expect(theme.textTheme.bodyLarge?.color, CwNightTheme.textPrimary);
      expect(theme.extension<CwColors>(), CwColors.nightRed);
    });

    testWidgets('nav chrome uses red theme', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CwNightTheme.material(),
          home: Builder(
            builder: (context) {
              final navBar = Theme.of(context).navigationBarTheme;
              expect(navBar.backgroundColor, CwNightTheme.background);
              expect(navBar.indicatorColor, isNotNull);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });
  });

  group('CwThemeMode', () {
    test('resolve prioritizes high contrast over night red', () {
      expect(
        CwThemeMode.resolve(
          nightRedEnabled: true,
          highContrastEnabled: true,
        ),
        CwThemeMode.highContrast,
      );
    });

    test('resolve selects night red when enabled alone', () {
      expect(
        CwThemeMode.resolve(
          nightRedEnabled: true,
          highContrastEnabled: false,
        ),
        CwThemeMode.nightRed,
      );
    });

    test('resolve defaults to deck', () {
      expect(
        CwThemeMode.resolve(
          nightRedEnabled: false,
          highContrastEnabled: false,
        ),
        CwThemeMode.deck,
      );
    });

    test('prefersChartNightPalette only for nightRed', () {
      expect(CwThemeMode.nightRed.prefersChartNightPalette, isTrue);
      expect(CwThemeMode.deck.prefersChartNightPalette, isFalse);
      expect(CwThemeMode.highContrast.prefersChartNightPalette, isFalse);
    });

    test('materialTheme returns distinct scaffold colors', () {
      expect(
        CwThemeMode.deck.materialTheme.scaffoldBackgroundColor,
        CwPalette.deckBlue,
      );
      expect(
        CwThemeMode.nightRed.materialTheme.scaffoldBackgroundColor,
        CwPalette.nightBg,
      );
      expect(
        CwThemeMode.highContrast.materialTheme.scaffoldBackgroundColor,
        const Color(0xFF000000),
      );
    });
  });
}
