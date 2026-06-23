import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/domain/checklist/checklist_templates.dart';
import 'package:captain_wrongel/features/checklist/checklist_detail_screen.dart';
import 'package:captain_wrongel/features/checklist/checklist_hub_screen.dart';
import 'package:captain_wrongel/features/checklist/widgets/checklist_progress.dart';
import 'package:captain_wrongel/l10n/app_localizations.dart';
import 'package:captain_wrongel/widgets/cw_app_bar.dart';
import 'package:captain_wrongel/widgets/cw_button.dart';
import 'package:captain_wrongel/widgets/cw_card.dart';
import 'package:captain_wrongel/widgets/cw_checkbox.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<Widget> host({
    required Widget body,
    AppDatabase? db,
  }) async {
    SharedPreferences.setMockInitialValues({});
    final shared = await SharedPreferences.getInstance();
    final database = db ?? AppDatabase(NativeDatabase.memory());
    if (db == null) {
      addTearDown(database.close);
    }

    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => shared),
        databaseProvider.overrideWith((ref) => database),
        sessionIdProvider.overrideWith((ref) => 'step33'),
      ],
      child: MaterialApp(
        theme: CwTheme.material(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: body),
      ),
    );
  }

  group('ChecklistHubScreen', () {
    testWidgets('shows CwCard grid for all templates', (tester) async {
      await tester.pumpWidget(
        await host(body: const ChecklistHubScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CwCard), findsNWidgets(3));
      expect(find.text('Before departure'), findsOneWidget);
      expect(find.text('Docking / mooring'), findsOneWidget);
      expect(find.text('Storm preparation'), findsOneWidget);
      expect(find.byKey(const Key('checklist_hub_departure')), findsOneWidget);
    });

    testWidgets('opens detail with CwAppBar on card tap', (tester) async {
      await tester.pumpWidget(
        await host(body: const ChecklistHubScreen()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('checklist_hub_departure')));
      await tester.pumpAndSettle();

      expect(find.byType(CwAppBar), findsOneWidget);
      expect(find.byType(ChecklistDetailScreen), findsOneWidget);
      expect(find.byType(ChecklistProgress), findsOneWidget);
      expect(find.byType(CwCheckbox), findsWidgets);
    });
  });

  group('ChecklistDetailScreen', () {
    testWidgets('shows progress and toggles item with strike-through', (
      tester,
    ) async {
      await tester.pumpWidget(
        await host(
          body: const ChecklistDetailScreen(
            templateKey: ChecklistTemplateKeys.departure,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ChecklistProgress), findsOneWidget);
      expect(find.text('0 / 5'), findsOneWidget);
      expect(find.text('Weather and sea state reviewed'), findsOneWidget);

      await tester.tap(find.byKey(const Key('checklist_item_weather')));
      await tester.pumpAndSettle();

      expect(find.text('1 / 5'), findsOneWidget);
      final label = tester.widget<Text>(
        find.descendant(
          of: find.byKey(const Key('checklist_item_weather')),
          matching: find.text('Weather and sea state reviewed'),
        ),
      );
      expect(label.style?.decoration, TextDecoration.lineThrough);
    });

    testWidgets('complete button marks all done and disables controls', (
      tester,
    ) async {
      await tester.pumpWidget(
        await host(
          body: const ChecklistDetailScreen(
            templateKey: ChecklistTemplateKeys.storm,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(CwButton));
      await tester.pumpAndSettle();

      expect(find.text('Checklist completed.'), findsOneWidget);
      expect(find.text('4 / 4'), findsOneWidget);
      expect(find.text('100%'), findsOneWidget);
    });
  });
}
