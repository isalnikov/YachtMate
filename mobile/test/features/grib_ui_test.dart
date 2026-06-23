import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/features/grib/grib_import_screen.dart';
import 'package:captain_wrongel/features/grib/grib_import_storage.dart';
import 'package:captain_wrongel/features/grib/widgets/grib_file_list.dart';
import 'package:captain_wrongel/l10n/app_localizations.dart';
import 'package:captain_wrongel/widgets/cw_button.dart';
import 'package:captain_wrongel/widgets/cw_card.dart';
import 'package:captain_wrongel/widgets/cw_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<Widget> host({Map<String, Object> prefs = const {}}) async {
    SharedPreferences.setMockInitialValues(prefs);
    final shared = await SharedPreferences.getInstance();

    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => shared),
      ],
      child: MaterialApp(
        theme: CwTheme.material(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: GribImportScreen()),
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

    testWidgets('loads legacy path stub into file list', (tester) async {
      await tester.pumpWidget(
        await host(
          prefs: {gribLegacyPathPrefsKey: '/legacy/stub/wind.grb'},
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CwEmptyState), findsNothing);
      expect(find.byKey(const Key('grib_file_list')), findsOneWidget);
      expect(find.byType(CwCard), findsOneWidget);
      expect(find.text('wind.grb'), findsOneWidget);
      expect(find.text('/legacy/stub/wind.grb'), findsOneWidget);
    });

    testWidgets('import button adds stub file and shows CwCard list', (
      tester,
    ) async {
      await tester.pumpWidget(await host());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('grib_import_button')));
      await tester.pump();
      expect(find.byType(LinearProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(find.byType(CwEmptyState), findsNothing);
      expect(find.byType(GribFileList), findsOneWidget);
      expect(find.byType(CwCard), findsOneWidget);
      expect(find.text('weather.grb'), findsOneWidget);
      expect(find.text('Stub path saved locally.'), findsOneWidget);
    });

    testWidgets('empty state CTA triggers import', (tester) async {
      await tester.pumpWidget(await host());
      await tester.pumpAndSettle();

      await tester.tap(
        find.descendant(
          of: find.byKey(const Key('grib_empty_state')),
          matching: find.byType(CwButton),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(find.byType(GribFileList), findsOneWidget);
      expect(find.text('weather.grb'), findsOneWidget);
    });
  });
}
