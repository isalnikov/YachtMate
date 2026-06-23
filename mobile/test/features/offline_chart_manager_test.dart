import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/data/repositories/chart_region_repository.dart';
import 'package:captain_wrongel/features/map/offline_chart_manager_screen.dart';
import 'package:captain_wrongel/l10n/app_localizations.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('OfflineChartManagerScreen lists and deletes regions', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final repo = ChartRegionRepository(db);
    await repo.upsert(
      regionId: 'offline_demo_1',
      path: 'sqlite:42',
      licenseTier: 'demo',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWith((ref) => prefs),
          databaseProvider.overrideWith((ref) => db),
        ],
        child: MaterialApp(
          theme: CwTheme.material(),
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const OfflineChartManagerScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('offline_demo_1'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('offline_demo_1'), findsNothing);
    expect(find.textContaining('No offline regions yet'), findsOneWidget);
  });
}
