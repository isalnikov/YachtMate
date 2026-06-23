import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/data/repositories/track_repository.dart';
import 'package:captain_wrongel/features/track/track_screen.dart';
import 'package:captain_wrongel/features/track/widgets/track_stats_card.dart';
import 'package:captain_wrongel/l10n/app_localizations.dart';
import 'package:captain_wrongel/widgets/cw_button.dart';
import 'package:captain_wrongel/widgets/cw_empty_state.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<Widget> host({required AppDatabase db}) async {
    SharedPreferences.setMockInitialValues({});
    final shared = await SharedPreferences.getInstance();

    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => shared),
        databaseProvider.overrideWith((ref) => db),
        sessionIdProvider.overrideWith((ref) => 'step30'),
      ],
      child: MaterialApp(
        theme: CwTheme.material(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: TrackScreen()),
      ),
    );
  }

  Future<AppDatabase> memoryDb() async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    return db;
  }

  group('TrackScreen', () {
    testWidgets('shows stats card and idle controls when not recording', (
      tester,
    ) async {
      final db = await memoryDb();
      await tester.pumpWidget(await host(db: db));
      await tester.pumpAndSettle();

      expect(find.byType(TrackStatsCard), findsOneWidget);
      expect(find.text('Not recording'), findsOneWidget);
      expect(find.text('Start recording'), findsOneWidget);
      expect(find.text('Stop & save'), findsOneWidget);
      expect(find.byType(CwButton), findsNWidgets(2));
    });

    testWidgets('shows CwEmptyState when no saved trips', (tester) async {
      final db = await memoryDb();
      await tester.pumpWidget(await host(db: db));
      await tester.pumpAndSettle();

      expect(find.byType(CwEmptyState), findsOneWidget);
      expect(find.text('No saved trips'), findsOneWidget);
      expect(find.text('Stop a recording to save a passage here.'), findsOneWidget);
    });

    testWidgets('lists saved trips instead of empty state', (tester) async {
      final db = await memoryDb();
      final repo = TrackRepository(db);
      final id = await repo.startTrip();
      await repo.endTrip(id);

      await tester.pumpWidget(await host(db: db));
      await tester.pumpAndSettle();

      expect(find.byType(CwEmptyState), findsNothing);
      expect(find.text(id.substring(0, 8)), findsOneWidget);
    });

    testWidgets('stop button is disabled while idle', (tester) async {
      final db = await memoryDb();
      await tester.pumpWidget(await host(db: db));
      await tester.pumpAndSettle();

      final stopButton = tester.widget<CwButton>(
        find.widgetWithText(CwButton, 'Stop & save'),
      );
      expect(stopButton.onPressed, isNull);
    });
  });
}
