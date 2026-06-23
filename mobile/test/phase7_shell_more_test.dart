import 'package:captain_wrongel/app.dart';
import 'package:captain_wrongel/core/disclaimer_gate.dart';
import 'package:captain_wrongel/core/onboarding_prefs.dart';
import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// UI flow: open More → see Phase 7 hub (no device build; same as integration target).
void main() {
  testWidgets('More menu shows safety headline', (tester) async {
    SharedPreferences.setMockInitialValues({
      kDisclaimerV1AcceptedKey: true,
      kOnboardingCompleteKey: true,
    });
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWith((ref) => prefs),
          databaseProvider.overrideWith((ref) => db),
          sessionIdProvider.overrideWith((ref) => 'phase7-shell-test'),
        ],
        child: const CaptainWrongelApp(),
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 3));

    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();

    expect(find.text('Safety, log & crew'), findsOneWidget);
  });
}
