import 'package:captain_wrongel/core/map_layer_preferences_controller.dart';
import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('setDepthContoursVisible persists and audits once', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => prefs),
        databaseProvider.overrideWith((ref) => db),
        sessionIdProvider.overrideWith((ref) => 'sess-layer'),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(mapLayerPreferencesProvider.notifier)
        .setDepthContoursVisible(true);

    expect(
      prefs.getBool(MapLayerPreferencesController.depthPreferenceKey),
      true,
    );
    expect(container.read(mapLayerPreferencesProvider).depthContours, true);

    final audits = await db.select(db.userActionAudits).get();
    expect(audits.where((a) => a.action == 'layer_toggle').length, 1);

    await container
        .read(mapLayerPreferencesProvider.notifier)
        .setDepthContoursVisible(true);

    final audits2 = await db.select(db.userActionAudits).get();
    expect(audits2.where((a) => a.action == 'layer_toggle').length, 1);
  });

  test('setMooringPoisVisible persists and audits', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => prefs),
        databaseProvider.overrideWith((ref) => db),
        sessionIdProvider.overrideWith((ref) => 'sess-mooring-layer'),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(mapLayerPreferencesProvider).mooringPois, true);

    await container
        .read(mapLayerPreferencesProvider.notifier)
        .setMooringPoisVisible(false);

    expect(
      prefs.getBool(MapLayerPreferencesController.mooringPoisPreferenceKey),
      false,
    );
    expect(container.read(mapLayerPreferencesProvider).mooringPois, false);

    final audits = await db.select(db.userActionAudits).get();
    expect(
      audits
          .where(
            (a) =>
                a.action == 'layer_toggle' &&
                a.contextJson?.contains('mooring_pois') == true,
          )
          .length,
      1,
    );
  });
}
