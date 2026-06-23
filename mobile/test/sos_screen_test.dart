import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/data/repositories/audit_repository.dart';
import 'package:captain_wrongel/features/distress/sos_screen.dart';
import 'package:captain_wrongel/features/distress/widgets/sos_emergency_panel.dart';
import 'package:captain_wrongel/features/distress/widgets/sos_timer_display.dart';
import 'package:captain_wrongel/features/distress/widgets/sos_type_selector.dart';
import 'package:captain_wrongel/l10n/app_localizations.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<void> pumpSosScreen(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          auditRepositoryProvider.overrideWithValue(AuditRepository(db)),
          sessionIdProvider.overrideWithValue('test-session'),
        ],
        child: MaterialApp(
          theme: CwTheme.material(),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: SosScreen()),
        ),
      ),
    );
    await tester.pump();
  }

  Future<void> scrollToHoldPanel(WidgetTester tester) async {
    await tester.scrollUntilVisible(
      find.text('HOLD TO ACTIVATE'),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
  }

  testWidgets('SosScreen renders type selector and hold panel', (tester) async {
    await pumpSosScreen(tester);

    expect(find.byType(SosTypeSelector), findsOneWidget);
    expect(find.text('Medical'), findsOneWidget);
    expect(find.text('Fire'), findsOneWidget);

    await scrollToHoldPanel(tester);
    expect(find.byType(SosEmergencyPanel), findsOneWidget);
    expect(find.text('HOLD TO ACTIVATE'), findsOneWidget);
  });

  testWidgets('two-step gate blocks activation without acknowledgment',
      (tester) async {
    await pumpSosScreen(tester);
    await scrollToHoldPanel(tester);

    final panel =
        tester.widget<SosEmergencyPanel>(find.byType(SosEmergencyPanel));
    expect(panel.enabled, isFalse);

    final holdCenter = tester.getCenter(find.text('HOLD TO ACTIVATE'));
    final gesture = await tester.startGesture(holdCenter);
    await tester.pump(const Duration(seconds: 3));
    await gesture.up();

    expect(find.byType(SosTimerDisplay), findsNothing);
  });

  testWidgets('selecting emergency type updates chip state', (tester) async {
    await pumpSosScreen(tester);

    await tester.tap(find.text('Fire'));
    await tester.pump();

    expect(find.byKey(const Key('sos_type_fire')), findsOneWidget);
  });

  testWidgets('acknowledged hold shows confirm dialog', (tester) async {
    await pumpSosScreen(tester);

    await tester.ensureVisible(find.byType(CheckboxListTile));
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pump();

    await scrollToHoldPanel(tester);
    final panel =
        tester.widget<SosEmergencyPanel>(find.byType(SosEmergencyPanel));
    expect(panel.enabled, isTrue);

    final holdCenter = tester.getCenter(find.text('HOLD TO ACTIVATE'));
    final gesture = await tester.startGesture(holdCenter);
    for (var i = 0; i < 45; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    await gesture.up();
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
  });
}
