import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/data/repositories/logbook_repository.dart';
import 'package:captain_wrongel/features/logbook/logbook_screen.dart';
import 'package:captain_wrongel/features/logbook/widgets/logbook_entry_card.dart';
import 'package:captain_wrongel/l10n/app_localizations.dart';
import 'package:captain_wrongel/widgets/cw_badge.dart';
import 'package:captain_wrongel/widgets/cw_button.dart';
import 'package:captain_wrongel/widgets/cw_empty_state.dart';
import 'package:captain_wrongel/widgets/cw_section_header.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<Widget> host({
    required AppDatabase db,
    Map<String, Object> prefs = const {},
  }) async {
    SharedPreferences.setMockInitialValues(prefs);
    final shared = await SharedPreferences.getInstance();

    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => shared),
        databaseProvider.overrideWith((ref) => db),
        sessionIdProvider.overrideWith((ref) => 'step29'),
      ],
      child: MaterialApp(
        theme: CwTheme.material(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: LogbookScreen()),
      ),
    );
  }

  Future<AppDatabase> memoryDb() async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    return db;
  }

  group('LogbookScreen', () {
    testWidgets('shows CwEmptyState with add CTA when no entries', (
      tester,
    ) async {
      final db = await memoryDb();
      await tester.pumpWidget(await host(db: db));
      await tester.pumpAndSettle();

      expect(find.byType(CwEmptyState), findsOneWidget);
      expect(find.text('Add entry'), findsOneWidget);
      expect(find.byType(CwFab), findsOneWidget);
    });

    testWidgets('opens add dialog from empty state CTA and FAB', (
      tester,
    ) async {
      final db = await memoryDb();
      await tester.pumpWidget(await host(db: db));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add entry'));
      await tester.pumpAndSettle();

      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(CwFab));
      await tester.pumpAndSettle();

      expect(find.text('Category'), findsOneWidget);
    });

    testWidgets('shows entry cards grouped by category sections', (
      tester,
    ) async {
      final db = await memoryDb();
      final repo = LogbookRepository(db);
      await repo.insertEntry(
        category: LogbookEntryCategories.note,
        payload: {'title': 'Morning note', 'body': 'Calm seas'},
      );
      await repo.insertEntry(
        category: LogbookEntryCategories.fuel,
        payload: {'title': 'Diesel top-up'},
      );

      await tester.pumpWidget(await host(db: db));
      await tester.pumpAndSettle();

      expect(find.byType(LogbookEntryCard), findsNWidgets(2));
      expect(find.byType(CwSectionHeader), findsNWidgets(2));
      expect(find.text('Morning note'), findsOneWidget);
      expect(find.text('Diesel top-up'), findsOneWidget);
      expect(find.text('Note / general'), findsWidgets);
      expect(find.text('Fuel'), findsWidgets);
      expect(find.byType(CwBadge), findsNWidgets(2));
    });

    testWidgets('filter chips narrow visible entries', (tester) async {
      final db = await memoryDb();
      final repo = LogbookRepository(db);
      await repo.insertEntry(
        category: LogbookEntryCategories.note,
        payload: {'title': 'Note only'},
      );
      await repo.insertEntry(
        category: LogbookEntryCategories.fuel,
        payload: {'title': 'Fuel only'},
      );

      await tester.pumpWidget(await host(db: db));
      await tester.pumpAndSettle();

      expect(find.text('Note only'), findsOneWidget);
      expect(find.text('Fuel only'), findsOneWidget);

      await tester.tap(find.widgetWithText(FilterChip, 'Fuel'));
      await tester.pumpAndSettle();

      expect(find.text('Fuel only'), findsOneWidget);
      expect(find.text('Note only'), findsNothing);
      expect(find.byType(CwSectionHeader), findsNothing);
    });

    testWidgets('captain sees delete control on entries', (tester) async {
      final db = await memoryDb();
      final repo = LogbookRepository(db);
      await repo.insertEntry(
        category: LogbookEntryCategories.other,
        payload: {'title': 'Captain entry'},
      );

      await tester.pumpWidget(await host(db: db));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('crew role hides delete control', (tester) async {
      final db = await memoryDb();
      final repo = LogbookRepository(db);
      await repo.insertEntry(
        category: LogbookEntryCategories.other,
        payload: {'title': 'Crew entry'},
      );

      await tester.pumpWidget(
        await host(db: db, prefs: {'crew_role': 'crew'}),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.delete_outline), findsNothing);
    });

    testWidgets('add entry via dialog persists to list', (tester) async {
      final db = await memoryDb();
      await tester.pumpWidget(await host(db: db));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(CwFab));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'Harbor arrival');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.byType(CwEmptyState), findsNothing);
      expect(find.text('Harbor arrival'), findsOneWidget);
    });
  });
}
