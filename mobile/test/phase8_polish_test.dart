import 'package:captain_wrongel/core/accessibility_preferences_controller.dart';
import 'package:captain_wrongel/core/energy_profile_controller.dart';
import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/core/theme_mode_controller.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('EnergyProfileController persists eco', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => prefs),
        databaseProvider.overrideWith((ref) => db),
        sessionIdProvider.overrideWith((ref) => 'phase8'),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(energyProfileProvider.notifier)
        .setProfile(EnergyProfile.eco);

    expect(prefs.getString(EnergyProfileController.preferenceKey), 'eco');
    expect(container.read(energyProfileProvider), EnergyProfile.eco);
  });

  test('AccessibilityPreferencesController persists glove mode', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => prefs),
        databaseProvider.overrideWith((ref) => db),
        sessionIdProvider.overrideWith((ref) => 'phase8'),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(accessibilityPreferencesProvider.notifier)
        .setGloveMode(true);

    expect(prefs.getBool(AccessibilityPreferencesController.glovePreferenceKey), true);
    expect(container.read(accessibilityPreferencesProvider).gloveMode, true);
  });

  test('ThemeModeController persists night red toggle', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => prefs),
        databaseProvider.overrideWith((ref) => db),
        sessionIdProvider.overrideWith((ref) => 'phase8'),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(themeModeProvider.notifier)
        .setNightRedEnabled(true);

    expect(prefs.getBool(ThemeModeController.preferenceKey), true);
    expect(container.read(themeModeProvider), true);
  });
}
