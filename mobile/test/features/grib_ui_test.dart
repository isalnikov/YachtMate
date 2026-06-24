import 'dart:io';

import 'package:captain_wrongel/core/feature_flags.dart';
import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/features/grib/grib_import_screen.dart';
import 'package:captain_wrongel/features/grib/grib_import_storage.dart';
import 'package:captain_wrongel/features/grib/widgets/grib_file_list.dart';
import 'package:captain_wrongel/l10n/app_localizations.dart';
import 'package:captain_wrongel/widgets/cw_button.dart';
import 'package:captain_wrongel/widgets/cw_card.dart';
import 'package:captain_wrongel/widgets/cw_empty_state.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../fixtures/grib/minimal_wind_fixture.dart';

Future<String> _writeDemoFixture() async {
  final dir = await Directory.systemTemp.createTemp('cw_grib_ui_');
  final file = File('${dir.path}/demo_wind.grb2');
  await file.writeAsBytes(buildMinimalWindUvGrib2());
  return file.path;
}

Future<void> _waitForReload(WidgetTester tester) async {
  await tester.pump();
  await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
  await tester.pump();
}

Future<void> _tapImport(WidgetTester tester, Finder finder) async {
  await tester.runAsync(() async {
    await tester.tap(finder);
    await Future<void>.delayed(const Duration(milliseconds: 300));
  });
  await tester.pump();
  await tester.pump();
}

void main() {
  late String demoFixturePath;

  setUp(() async {
    demoFixturePath = await _writeDemoFixture();
  });
  Future<Widget> host({
    Map<String, Object> prefs = const {},
    Future<String?> Function()? demoFixtureBuilder,
  }) async {
    SharedPreferences.setMockInitialValues(prefs);
    final shared = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => shared),
        databaseProvider.overrideWith((ref) => db),
        sessionIdProvider.overrideWith((ref) => 'grib-ui-test'),
      ],
      child: MaterialApp(
        theme: CwTheme.material(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: GribImportScreen(
            demoFixtureBuilder: demoFixtureBuilder,
          ),
        ),
      ),
    );
  }

  group('GribImportScreen', () {
    testWidgets('shows empty state with import CTA when no files', (
      tester,
    ) async {
      await tester.pumpWidget(await host());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('grib_empty_state')), findsOneWidget);
      expect(find.byType(CwEmptyState), findsOneWidget);
      expect(find.text('No GRIB files imported yet.'), findsOneWidget);
      expect(find.byKey(const Key('grib_import_button')), findsOneWidget);
      expect(find.byType(GribFileList), findsNothing);
    });

    testWidgets('loads legacy path and shows decode error when missing', (
      tester,
    ) async {
      await tester.pumpWidget(
        await host(
          prefs: {gribLegacyPathPrefsKey: '/legacy/stub/wind.grb'},
        ),
      );
      await _waitForReload(tester);

      expect(find.byType(CwEmptyState), findsNothing);
      expect(find.byKey(const Key('grib_file_list')), findsOneWidget);
      expect(find.byType(CwCard), findsOneWidget);
      expect(find.text('wind.grb'), findsOneWidget);
      expect(find.text('Decode error'), findsOneWidget);
      expect(find.textContaining('File not found'), findsOneWidget);
    });

    testWidgets('import button adds parsed GRIB and shows metadata', (
      tester,
    ) async {
      await tester.pumpWidget(
        await host(
          prefs: {FeatureFlags.premiumKey: true},
          demoFixtureBuilder: () async => demoFixturePath,
        ),
      );
      await tester.pumpAndSettle();

      await _tapImport(tester, find.byKey(const Key('grib_import_button')));
      expect(find.byType(LinearProgressIndicator), findsNothing);

      expect(find.byType(CwEmptyState), findsNothing);
      expect(find.byType(GribFileList), findsOneWidget);
      expect(find.byType(CwCard), findsOneWidget);
      expect(find.text('demo_wind.grb2'), findsOneWidget);
      expect(find.text('Decoded'), findsOneWidget);
      expect(find.textContaining('2×2 grid'), findsOneWidget);
      expect(find.textContaining('U 2.5'), findsOneWidget);
      expect(find.text('GRIB imported and parsed.'), findsOneWidget);
    });

    testWidgets('empty state CTA triggers import', (tester) async {
      await tester.pumpWidget(
        await host(
          prefs: {FeatureFlags.premiumKey: true},
          demoFixtureBuilder: () async => demoFixturePath,
        ),
      );
      await tester.pumpAndSettle();

      await _tapImport(
        tester,
        find.descendant(
          of: find.byKey(const Key('grib_empty_state')),
          matching: find.byType(CwButton),
        ),
      );

      expect(find.byType(GribFileList), findsOneWidget);
      expect(find.text('demo_wind.grb2'), findsOneWidget);
    });
  });
}
