import 'package:captain_wrongel/core/disclaimer_gate.dart';
import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('accept persists flag and audit row', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => prefs),
        databaseProvider.overrideWith((ref) => db),
        sessionIdProvider.overrideWith((ref) => 'sess-disclaimer'),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(disclaimerAcceptedProvider), false);
    await container.read(disclaimerAcceptedProvider.notifier).accept();
    expect(prefs.getBool(kDisclaimerV1AcceptedKey), true);
    expect(container.read(disclaimerAcceptedProvider), true);

    final audits = await db.select(db.userActionAudits).get();
    expect(audits.map((e) => e.action), contains('disclaimer_accept'));
  });
}
