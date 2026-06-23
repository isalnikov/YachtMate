import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/data/repositories/audit_repository.dart';
import 'package:captain_wrongel/data/repositories/expense_repository.dart';
import 'package:captain_wrongel/features/expenses/voyager_cashbook_screen.dart';
import 'package:captain_wrongel/features/expenses/widgets/expense_category_chips.dart';
import 'package:captain_wrongel/features/expenses/widgets/expense_entry_card.dart';
import 'package:captain_wrongel/features/expenses/widgets/expense_summary_card.dart';
import 'package:captain_wrongel/l10n/app_localizations.dart';
import 'package:captain_wrongel/widgets/cw_bottom_sheet.dart';
import 'package:captain_wrongel/widgets/cw_button.dart';
import 'package:captain_wrongel/widgets/cw_card.dart';
import 'package:captain_wrongel/widgets/cw_chip.dart';
import 'package:captain_wrongel/widgets/cw_empty_state.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<(Widget widget, AppDatabase db)> host({
    Locale locale = const Locale('en'),
  }) async {
    SharedPreferences.setMockInitialValues({});
    final shared = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final widget = ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => shared),
        databaseProvider.overrideWith((ref) => db),
        sessionIdProvider.overrideWith((ref) => 'step37'),
        auditRepositoryProvider.overrideWithValue(AuditRepository(db)),
      ],
      child: MaterialApp(
        theme: CwTheme.material(),
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: VoyagerCashbookScreen()),
      ),
    );

    return (widget, db);
  }

  Future<void> seedExpenses(AppDatabase db) async {
    final repo = ExpenseRepository(db);
    await repo.addEntry(
      category: 'fuel',
      amountMinor: 5000,
      note: 'Diesel at marina',
    );
    await repo.addEntry(category: 'food', amountMinor: 3200);
  }

  group('VoyagerCashbookScreen', () {
    testWidgets('shows summary card and empty state when no expenses',
        (tester) async {
      final (widget, _) = await host();
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      expect(find.byType(ExpenseSummaryCard), findsOneWidget);
      expect(find.byType(ExpenseCategoryChips), findsOneWidget);
      expect(find.byType(CwEmptyState), findsOneWidget);
      expect(find.text('Trip total'), findsOneWidget);
      expect(find.text('0.00 EUR'), findsOneWidget);
      expect(find.text('No expenses logged.'), findsOneWidget);
    });

    testWidgets('lists seeded expenses in CwCard entries', (tester) async {
      final (widget, db) = await host();
      await seedExpenses(db);

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      expect(find.byType(ExpenseEntryCard), findsNWidgets(2));
      expect(find.byType(CwCard), findsNWidgets(3));
      expect(find.text('82.00 EUR'), findsOneWidget);
      expect(find.text('Fuel · 50.00 EUR'), findsOneWidget);
      expect(find.text('Food · 32.00 EUR'), findsOneWidget);
      expect(find.text('Diesel at marina'), findsOneWidget);
    });

    testWidgets('filters expenses by category chip', (tester) async {
      final (widget, db) = await host();
      await seedExpenses(db);

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('expense_category_fuel')));
      await tester.pumpAndSettle();

      expect(find.byType(ExpenseEntryCard), findsOneWidget);
      expect(find.text('Diesel at marina'), findsOneWidget);
      expect(find.text('50.00 EUR'), findsOneWidget);
    });

    testWidgets('opens CwBottomSheet add form and saves expense', (tester) async {
      final (widget, db) = await host();

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('expense_add_button')));
      await tester.pumpAndSettle();

      expect(find.byType(CwBottomSheet), findsOneWidget);
      expect(find.byType(CwChip), findsWidgets);

      await tester.tap(find.byKey(const Key('expense_add_category_marina')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('expense_add_amount')), '12.50');
      await tester.enterText(
        find.byKey(const Key('expense_add_note')),
        'Harbour fee',
      );
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(find.byType(CwBottomSheet), findsNothing);
      expect(find.byType(ExpenseEntryCard), findsOneWidget);
      expect(find.text('12.50 EUR'), findsNWidgets(2));
      expect(find.text('Harbour fee'), findsOneWidget);
      expect(find.text('Marina fees · 12.50 EUR'), findsOneWidget);

      final rows = await ExpenseRepository(db).allDescending();
      expect(rows, hasLength(1));
      expect(rows.first.category, 'marina');
      expect(rows.first.amountMinor, 1250);
      expect(rows.first.note, 'Harbour fee');
    });

    testWidgets('deletes expense from CwCard entry', (tester) async {
      final (widget, db) = await host();
      await seedExpenses(db);

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      final rows = await ExpenseRepository(db).allDescending();
      final fuelId = rows.firstWhere((r) => r.category == 'fuel').id;

      await tester.tap(find.byKey(Key('expense_delete_$fuelId')));
      await tester.pumpAndSettle();

      expect(find.byType(ExpenseEntryCard), findsOneWidget);
      expect(find.text('Diesel at marina'), findsNothing);
      expect(find.text('32.00 EUR'), findsNWidgets(2));

      final remaining = await ExpenseRepository(db).allDescending();
      expect(remaining, hasLength(1));
      expect(remaining.first.category, 'food');
    });
  });
}
