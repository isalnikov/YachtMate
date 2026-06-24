import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/features/grib/grib_import_screen.dart';
import 'package:captain_wrongel/features/toolbox/maritime_toolbox_screen.dart';
import 'package:captain_wrongel/features/toolbox/widgets/toolbox_grid_item.dart';
import 'package:captain_wrongel/l10n/app_localizations.dart';
import 'package:captain_wrongel/widgets/cw_app_bar.dart';
import 'package:captain_wrongel/widgets/cw_badge.dart';
import 'package:captain_wrongel/widgets/cw_section_header.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<Widget> host({Locale locale = const Locale('en')}) async {
    SharedPreferences.setMockInitialValues({});
    final shared = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => shared),
        databaseProvider.overrideWith((ref) => db),
        sessionIdProvider.overrideWith((ref) => 'toolbox-test'),
      ],
      child: MaterialApp(
        theme: CwTheme.material(),
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: MaritimeToolboxScreen()),
      ),
    );
  }

  group('MaritimeToolboxScreen', () {
    testWidgets('shows grouped sections with two-column grids', (tester) async {
      await tester.pumpWidget(await host());
      await tester.pumpAndSettle();

      expect(find.byType(CwSectionHeader), findsNWidgets(3));
      expect(find.text('NAVIGATION'), findsOneWidget);
      expect(find.text('SAFETY'), findsOneWidget);
      expect(find.text('REFERENCE'), findsOneWidget);
      expect(find.byType(ToolboxGridItem), findsNWidgets(8));
    });

    testWidgets('shows NEW badge on GRIB entry', (tester) async {
      await tester.pumpWidget(await host());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('toolbox_grib')), findsOneWidget);
      expect(find.text('NEW'), findsOneWidget);
      expect(find.byType(CwBadge), findsOneWidget);
    });

    testWidgets('navigates to GRIB screen from grid item', (tester) async {
      await tester.pumpWidget(await host());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('toolbox_grib')));
      await tester.pumpAndSettle();

      expect(find.byType(CwAppBar), findsOneWidget);
      expect(find.byType(GribImportScreen), findsOneWidget);
    });

    testWidgets('all eight toolbox entries are tappable', (tester) async {
      await tester.pumpWidget(await host());
      await tester.pumpAndSettle();

      for (final id in [
        'compass',
        'grib',
        'coastal',
        'anchor_watch',
        'vhf',
        'medical',
        'knots',
        'expenses',
      ]) {
        expect(find.byKey(Key('toolbox_$id')), findsOneWidget);
      }
    });
  });
}
