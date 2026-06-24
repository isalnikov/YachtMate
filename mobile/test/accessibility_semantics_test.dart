import 'dart:math' show max, min;

import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/core/theme/cw_tokens.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/features/map/widgets/map_controls_overlay.dart';
import 'package:captain_wrongel/features/shell/shell_screen.dart';
import 'package:captain_wrongel/l10n/app_localizations.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

double _contrastRatio(Color fg, Color bg) {
  final l1 = fg.computeLuminance();
  final l2 = bg.computeLuminance();
  final lighter = max(l1, l2);
  final darker = min(l1, l2);
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  Future<Widget> wrap(Widget child) async {
    SharedPreferences.setMockInitialValues({});
    final shared = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());

    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => shared),
        databaseProvider.overrideWith((ref) {
          ref.onDispose(db.close);
          return db;
        }),
        sessionIdProvider.overrideWith((ref) => 'a11y-map-controls'),
      ],
      child: MaterialApp(
        theme: CwTheme.material(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(
          body: Stack(children: [child]),
        ),
      ),
    );
  }

  Future<Widget> wrapShell() async {
    SharedPreferences.setMockInitialValues({});
    final shared = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());

    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => shared),
        databaseProvider.overrideWith((ref) {
          ref.onDispose(db.close);
          return db;
        }),
        sessionIdProvider.overrideWith((ref) => 'a11y-shell'),
      ],
      child: MaterialApp(
        theme: CwTheme.material(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: const ShellScreen(),
      ),
    );
  }

  group('Shell tab semantics', () {
    testWidgets('primary tabs expose localized labels', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(await wrapShell());
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      for (final label in ['Map', 'Route', 'Weather', 'Mooring', 'More']) {
        expect(find.text(label), findsWidgets);
      }
    });
  });

  group('Map controls semantics', () {
    testWidgets('overlay buttons expose zoom and layer labels', (tester) async {
      await tester.pumpWidget(
        await wrap(
          MapControlsOverlay(
            enabled: true,
            headingUp: false,
            mapBearing: 0,
            followGps: false,
            onZoomIn: () {},
            onZoomOut: () {},
            onCompassToggle: () {},
            onLayers: () {},
            onFollowGpsToggle: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('Zoom in'), findsOneWidget);
      expect(find.bySemanticsLabel('Zoom out'), findsOneWidget);
      expect(find.bySemanticsLabel('Map layers'), findsOneWidget);
      expect(
        find.bySemanticsLabel('North up — tap for heading up'),
        findsOneWidget,
      );
    });
  });

  group('Contrast tokens', () {
    test('primary text on deck meets WCAG AA (4.5:1)', () {
      final ratio = _contrastRatio(CwPalette.textPrimary, CwPalette.deckBlue);
      expect(ratio, greaterThanOrEqualTo(4.5));
    });

    test('accent teal on deck meets large-text AA (3:1)', () {
      final ratio = _contrastRatio(CwPalette.accentTeal, CwPalette.deckBlue);
      expect(ratio, greaterThanOrEqualTo(3.0));
    });
  });
}
