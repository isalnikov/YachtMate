import 'package:captain_wrongel/app.dart';
import 'package:captain_wrongel/core/disclaimer_gate.dart';
import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Regression: wide window (≥900px) uses extended [NavigationRail], which must
/// use [NavigationRailLabelType.none], not .all (Material assert).
void main() {
  testWidgets('Shell at 1200px builds without NavigationRail assert',
      (tester) async {
    SharedPreferences.setMockInitialValues({kDisclaimerV1AcceptedKey: true});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.binding.setSurfaceSize(const Size(1200, 800));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWith((ref) => prefs),
          databaseProvider.overrideWith((ref) {
            ref.onDispose(db.close);
            return db;
          }),
          sessionIdProvider.overrideWith((ref) => 'wide-shell-test'),
        ],
        child: const CaptainWrongelApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
