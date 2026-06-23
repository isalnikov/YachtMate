import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/core/theme/cw_theme_extensions.dart';
import 'package:captain_wrongel/core/theme/cw_tokens.dart';
import 'package:captain_wrongel/core/theme/cw_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CwTypography.textTheme', () {
    late TextTheme theme;

    setUp(() {
      theme = CwTypography.textTheme(
        textPrimary: CwPalette.textPrimary,
        textMuted: CwPalette.textMuted,
      );
    });

    test('includes all design-system styles', () {
      expect(theme.displayLarge, isNotNull);
      expect(theme.headlineLarge, isNotNull);
      expect(theme.headlineMedium, isNotNull);
      expect(theme.bodyLarge, isNotNull);
      expect(theme.bodySmall, isNotNull);
      expect(theme.labelLarge, isNotNull);
    });

    test('display matches spec', () {
      final style = theme.displayLarge!;
      expect(style.fontSize, 28);
      expect(style.fontWeight, FontWeight.w800);
      expect(style.height, 1.2);
      expect(style.color, CwPalette.textPrimary);
    });

    test('h1 matches spec', () {
      final style = theme.headlineLarge!;
      expect(style.fontSize, 22);
      expect(style.fontWeight, FontWeight.w700);
      expect(style.height, 1.25);
    });

    test('h2 matches spec', () {
      final style = theme.headlineMedium!;
      expect(style.fontSize, 18);
      expect(style.fontWeight, FontWeight.w600);
      expect(style.height, 1.3);
    });

    test('body matches spec', () {
      final style = theme.bodyLarge!;
      expect(style.fontSize, 16);
      expect(style.fontWeight, FontWeight.w400);
      expect(style.height, 1.5);
    });

    test('caption uses muted color', () {
      final style = theme.bodySmall!;
      expect(style.fontSize, 13);
      expect(style.fontWeight, FontWeight.w400);
      expect(style.height, 1.4);
      expect(style.color, CwPalette.textMuted);
    });

    test('button matches spec', () {
      final style = theme.labelLarge!;
      expect(style.fontSize, 16);
      expect(style.fontWeight, FontWeight.w600);
      expect(style.height, 1.0);
    });
  });

  group('CwTypography.monoCoords', () {
    test('uses tabular figures and monospace', () {
      final style = CwTypography.monoCoords(color: CwPalette.textPrimary);
      expect(style.fontSize, 14);
      expect(style.fontWeight, FontWeight.w500);
      expect(style.height, 1.2);
      expect(style.fontFamily, 'monospace');
      expect(
        style.fontFeatures,
        contains(const FontFeature.tabularFigures()),
      );
    });
  });

  group('CwTypography.formatCoords', () {
    test('formats positive lat/lon as DD°MM.mmm\'', () {
      expect(
        CwTypography.formatCoords(41.20575, 2.576117),
        "41°12.345' N 002°34.567' E",
      );
    });

    test('formats negative hemispheres', () {
      expect(
        CwTypography.formatCoords(-41.20575, -2.576117),
        "41°12.345' S 002°34.567' W",
      );
    });

    test('pads latitude minutes below ten', () {
      expect(
        CwTypography.formatCoords(0.0391667, 0),
        "00°02.350' N 000°00.000' E",
      );
    });
  });

  group('CwTypography.coords', () {
    testWidgets('renders formatted coordinates with mono style', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CwTheme.material(),
          home: Builder(
            builder: (context) => CwTypography.coords(context, 41.20575, 2.576117),
          ),
        ),
      );

      final text = tester.widget<Text>(find.byType(Text));
      expect(text.data, "41°12.345' N 002°34.567' E");
      expect(text.style?.fontFamily, 'monospace');
      expect(
        text.style?.fontFeatures,
        contains(const FontFeature.tabularFigures()),
      );
      expect(text.style?.color, CwColors.light.textPrimary);
    });
  });

  group('CwTheme integration', () {
    test('material() registers CwTypography textTheme', () {
      final theme = CwTheme.material();
      expect(theme.textTheme.displayLarge?.fontSize, 28);
      expect(theme.textTheme.bodyLarge?.fontSize, 16);
      expect(theme.textTheme.bodySmall?.color, CwColors.light.textMuted);
    });

    test('materialHighContrast() registers CwTypography textTheme', () {
      final theme = CwTheme.materialHighContrast();
      expect(theme.textTheme.displayLarge?.fontSize, 28);
      expect(theme.textTheme.bodyLarge?.color, const Color(0xFFF5F5F5));
    });
  });
}
