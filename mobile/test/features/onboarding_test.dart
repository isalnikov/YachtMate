import 'package:captain_wrongel/app.dart';
import 'package:captain_wrongel/core/disclaimer_gate.dart';
import 'package:captain_wrongel/core/onboarding_prefs.dart';
import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/features/onboarding/onboarding_flow.dart';
import 'package:captain_wrongel/features/shell/shell_screen.dart';
import 'package:captain_wrongel/l10n/app_localizations.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<SharedPreferences> mockPrefs([Map<String, Object>? values]) async {
    SharedPreferences.setMockInitialValues(values ?? {});
    return SharedPreferences.getInstance();
  }

  ProviderScope buildScope({
    required SharedPreferences prefs,
    required Widget child,
  }) {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => prefs),
        databaseProvider.overrideWith((ref) {
          ref.onDispose(db.close);
          return db;
        }),
        sessionIdProvider.overrideWith((ref) => 'onboarding-test-session'),
      ],
      child: child,
    );
  }

  Future<void> advanceOnboarding(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('onboarding_next')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('onboarding_next')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('onboarding_experience_cruiser')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('onboarding_next')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('onboarding_region_mediterranean')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('onboarding_get_started')));
    await tester.pumpAndSettle();
  }

  testWidgets('onboarding shows four pages with dot indicator', (tester) async {
    final prefs = await mockPrefs();

    await tester.pumpWidget(
      buildScope(
        prefs: prefs,
        child: MaterialApp(
          theme: CwTheme.material(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const OnboardingFlow(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Captain Wrongel'), findsOneWidget);
    expect(find.text('Your crewmate on every voyage'), findsOneWidget);
    expect(find.byKey(const Key('onboarding_next')), findsOneWidget);

    await tester.tap(find.byKey(const Key('onboarding_next')));
    await tester.pumpAndSettle();

    expect(find.text('Enable permissions'), findsOneWidget);
    expect(find.byKey(const Key('onboarding_back')), findsOneWidget);
  });

  testWidgets('completing onboarding persists prefs and shows shell', (
    tester,
  ) async {
    final prefs = await mockPrefs({kDisclaimerV1AcceptedKey: true});

    await tester.pumpWidget(
      buildScope(prefs: prefs, child: const CaptainWrongelApp()),
    );
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingFlow), findsOneWidget);
    expect(find.byType(ShellScreen), findsNothing);

    await advanceOnboarding(tester);

    expect(find.byType(ShellScreen), findsOneWidget);
    expect(find.byType(OnboardingFlow), findsNothing);
    expect(prefs.getBool(kOnboardingCompleteKey), isTrue);
    expect(prefs.getString(kOnboardingExperienceKey), 'cruiser');
    expect(prefs.getString(kOnboardingRegionKey), 'mediterranean');
  });

  testWidgets('repeat launch skips onboarding when pref is set', (tester) async {
    final prefs = await mockPrefs({
      kDisclaimerV1AcceptedKey: true,
      kOnboardingCompleteKey: true,
    });

    await tester.pumpWidget(
      buildScope(prefs: prefs, child: const CaptainWrongelApp()),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ShellScreen), findsOneWidget);
    expect(find.byType(OnboardingFlow), findsNothing);
  });
}
