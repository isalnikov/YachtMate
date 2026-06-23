import 'package:captain_wrongel/app.dart';
import 'package:captain_wrongel/core/disclaimer_gate.dart';
import 'package:captain_wrongel/core/onboarding_prefs.dart';
import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Shell shows first tab and navigation', (tester) async {
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
          sessionIdProvider.overrideWith((ref) => 'test-session'),
        ],
        child: const CaptainWrongelApp(),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Map'), findsWidgets);
  });
}
