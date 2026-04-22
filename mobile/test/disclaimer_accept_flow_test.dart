import 'package:captain_wrongel/app.dart';
import 'package:captain_wrongel/core/disclaimer_gate.dart';
import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/features/legal/disclaimer_screen.dart';
import 'package:captain_wrongel/features/shell/shell_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('tapping disclaimer accept shows shell without framework errors',
      (tester) async {
    final exceptions = <FlutterErrorDetails>[];
    final prior = FlutterError.onError;
    FlutterError.onError = (details) {
      exceptions.add(details);
      prior?.call(details);
    };
    addTearDown(() {
      FlutterError.onError = prior;
    });

    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWith((ref) => prefs),
          databaseProvider.overrideWith((ref) {
            ref.onDispose(db.close);
            return db;
          }),
          sessionIdProvider.overrideWith((ref) => 'flow-test-session'),
        ],
        child: const CaptainWrongelApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(DisclaimerScreen), findsOneWidget);
    expect(find.byType(ShellScreen), findsNothing);

    await tester.tap(find.byKey(const Key('disclaimer_accept')));
    await tester.pumpAndSettle();

    expect(
      exceptions,
      isEmpty,
      reason:
          'No Flutter framework errors during disclaimer → shell transition',
    );
    expect(find.byType(ShellScreen), findsOneWidget);
    expect(find.byType(DisclaimerScreen), findsNothing);

    expect(prefs.getBool(kDisclaimerV1AcceptedKey), isTrue);
  });
}
