import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/core/vessel_prefs.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/domain/routing/depth_grid.dart';
import 'package:captain_wrongel/features/route/route_planning_helpers.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('VesselPrefsController persists draft and profile fields', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => prefs),
        databaseProvider.overrideWith((ref) => db),
        sessionIdProvider.overrideWith((ref) => 'step27'),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(vesselPrefsProvider.notifier);
    await notifier.setName('Sea Breeze');
    await notifier.setLoaM(11.5);
    await notifier.setDraftM(1.8);
    await notifier.setType(VesselType.motor);
    await notifier.setUnits(UnitSystem.imperial);

    expect(prefs.getString(VesselPrefsController.nameKey), 'Sea Breeze');
    expect(prefs.getDouble(VesselPrefsController.loaKey), 11.5);
    expect(prefs.getDouble(VesselPrefsController.draftKey), 1.8);
    expect(prefs.getString(VesselPrefsController.typeKey), 'motor');
    expect(prefs.getString(VesselPrefsController.unitsKey), 'imperial');

    final profile = container.read(vesselPrefsProvider);
    expect(profile.name, 'Sea Breeze');
    expect(profile.draftM, 1.8);
    expect(profile.type, VesselType.motor);
    expect(profile.units, UnitSystem.imperial);
  });

  test('VesselPrefsController migrates legacy ship draft key', () async {
    SharedPreferences.setMockInitialValues({
      VesselPrefsController.legacyDraftKey: 3.2,
    });
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => prefs),
        databaseProvider.overrideWith((ref) => db),
        sessionIdProvider.overrideWith((ref) => 'step27'),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(vesselPrefsProvider).draftM, 3.2);
  });

  test('Route depth safety uses vessel draft from prefs', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => prefs),
        databaseProvider.overrideWith((ref) => db),
        sessionIdProvider.overrideWith((ref) => 'step27'),
      ],
    );
    addTearDown(container.dispose);

    await container.read(vesselPrefsProvider.notifier).setDraftM(1.5);

    final grid = DepthGrid(
      rows: 3,
      cols: 3,
      depthM: [
        [10, 10, 10],
        [10, 2, 10],
        [10, 10, 10],
      ],
      originLatDeg: 36.0,
      originLonDeg: 28.0,
      latStepDeg: 0.01,
      lonStepDeg: 0.01,
    );

    final waypoints = [
      const RouteWaypointRow(
        id: '1',
        routeId: 'r1',
        seq: 0,
        lat: 36.015,
        lon: 28.015,
        name: 'WP1',
      ),
    ];

    final draft = container.read(vesselPrefsProvider).draftM;
    final shallow = checkRouteDepthSafety(
      waypoints: waypoints,
      grid: grid,
      draftM: draft,
      clearanceM: 1.0,
    );
    expect(shallow.isSafe, isFalse);
    expect(shallow.unsafeWaypointIndex, 1);
  });
}
