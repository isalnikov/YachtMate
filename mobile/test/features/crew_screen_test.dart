import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/data/repositories/audit_repository.dart';
import 'package:captain_wrongel/features/crew/crew_screen.dart';
import 'package:captain_wrongel/features/crew/widgets/crew_role_card.dart';
import 'package:captain_wrongel/l10n/app_localizations.dart';
import 'package:captain_wrongel/widgets/cw_button.dart';
import 'package:captain_wrongel/widgets/cw_card.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<Widget> host({
    Map<String, Object> prefs = const {},
  }) async {
    SharedPreferences.setMockInitialValues(prefs);
    final shared = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => shared),
        databaseProvider.overrideWith((ref) => db),
        sessionIdProvider.overrideWith((ref) => 'step32'),
        auditRepositoryProvider.overrideWithValue(AuditRepository(db)),
      ],
      child: MaterialApp(
        theme: CwTheme.material(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: CrewScreen()),
      ),
    );
  }

  group('CrewScreen', () {
    testWidgets('shows captain role card and chips by default', (tester) async {
      await tester.pumpWidget(await host());
      await tester.pumpAndSettle();

      expect(find.byType(CrewRoleCard), findsOneWidget);
      expect(find.byType(CrewRoleBadge), findsOneWidget);
      expect(find.text('Captain'), findsWidgets);
      expect(find.text('Crew'), findsWidgets);
      expect(find.byType(CwCard), findsNWidgets(2));
    });

    testWidgets('shows crew role badge when joined as crew', (tester) async {
      await tester.pumpWidget(
        await host(prefs: {'crew_role': 'crew', 'crew_invite_display': 'ABC123'}),
      );
      await tester.pumpAndSettle();

      expect(find.text('Crew'), findsWidgets);
      expect(find.text('Captain'), findsWidgets);
    });

    testWidgets('create ship shows invite code card', (tester) async {
      await tester.pumpWidget(await host());
      await tester.pumpAndSettle();

      expect(find.text('Share this code so others can join the same ship ID on their device.'), findsNothing);

      await tester.tap(find.widgetWithText(CwButton, 'Create ship & invite code'));
      await tester.pumpAndSettle();

      expect(find.text('Share this code so others can join the same ship ID on their device.'), findsOneWidget);
      expect(find.byType(CwCard), findsNWidgets(3));
      expect(find.widgetWithText(CwButton, 'Copy message'), findsOneWidget);
    });

    testWidgets('copy invite code puts code on clipboard', (tester) async {
      String? copied;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = call.arguments['text'] as String?;
        }
        return null;
      });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, null),
      );

      await tester.pumpWidget(await host());
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(CwButton, 'Create ship & invite code'));
      await tester.pumpAndSettle();

      final codeFinder = find.byWidgetPredicate(
        (w) => w is SelectableText && (w.data?.length ?? 0) == 6,
      );
      expect(codeFinder, findsOneWidget);
      final code = (tester.widget<SelectableText>(codeFinder).data)!;

      await tester.tap(find.widgetWithText(CwButton, 'Copy message'));
      await tester.pump();

      expect(copied, code);
      expect(find.text('Message copied.'), findsOneWidget);
    });

    testWidgets('join ship switches to crew role', (tester) async {
      await tester.pumpWidget(await host());
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(CwButton, 'Create ship & invite code'));
      await tester.pumpAndSettle();

      final codeFinder = find.byWidgetPredicate(
        (w) => w is SelectableText && (w.data?.length ?? 0) == 6,
      );
      final code = (tester.widget<SelectableText>(codeFinder).data)!;

      await tester.tap(find.widgetWithText(CwButton, 'Leave ship'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), code);
      await tester.tap(find.widgetWithText(CwButton, 'Join ship'));
      await tester.pumpAndSettle();

      expect(find.text('Crew'), findsWidgets);
    });

    testWidgets('leave ship clears invite card', (tester) async {
      await tester.pumpWidget(await host());
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(CwButton, 'Create ship & invite code'));
      await tester.pumpAndSettle();
      expect(find.text('Share this code so others can join the same ship ID on their device.'), findsOneWidget);

      await tester.tap(find.widgetWithText(CwButton, 'Leave ship'));
      await tester.pumpAndSettle();

      expect(find.text('Share this code so others can join the same ship ID on their device.'), findsNothing);
      expect(find.byType(CwCard), findsNWidgets(2));
    });
  });
}
