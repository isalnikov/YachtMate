import 'package:captain_wrongel/core/locale_controller.dart';
import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('reads ru from SharedPreferences when set', () async {
    SharedPreferences.setMockInitialValues({
      LocaleController.localePreferenceKey: 'ru',
    });
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => prefs),
        databaseProvider.overrideWith((ref) => db),
        sessionIdProvider.overrideWith((ref) => 'sess-locale'),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(localeControllerProvider).languageCode, 'ru');
  });

  test('setLocale persists code and records locale_change audit', () async {
    SharedPreferences.setMockInitialValues({
      LocaleController.localePreferenceKey: 'en',
    });
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => prefs),
        databaseProvider.overrideWith((ref) => db),
        sessionIdProvider.overrideWith((ref) => 'sess-locale'),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(localeControllerProvider.notifier)
        .setLocale(const Locale('ru'));

    expect(prefs.getString(LocaleController.localePreferenceKey), 'ru');
    expect(container.read(localeControllerProvider).languageCode, 'ru');

    final audits = await db.select(db.userActionAudits).get();
    final changes = audits.where((a) => a.action == 'locale_change').toList();
    expect(changes, hasLength(1));
    expect(changes.single.contextJson, contains('"from":"en"'));
    expect(changes.single.contextJson, contains('"to":"ru"'));
  });

  test('setLocale to same value does not write duplicate audit', () async {
    SharedPreferences.setMockInitialValues({
      LocaleController.localePreferenceKey: 'en',
    });
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => prefs),
        databaseProvider.overrideWith((ref) => db),
        sessionIdProvider.overrideWith((ref) => 'sess-locale'),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(localeControllerProvider.notifier)
        .setLocale(const Locale('en'));

    final audits = await db.select(db.userActionAudits).get();
    expect(audits.where((a) => a.action == 'locale_change'), isEmpty);
  });

  test('setLocale persists el tr pt codes', () async {
    for (final code in ['el', 'tr', 'pt']) {
      SharedPreferences.setMockInitialValues({
        LocaleController.localePreferenceKey: 'en',
      });
      final prefs = await SharedPreferences.getInstance();
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWith((ref) => prefs),
          databaseProvider.overrideWith((ref) => db),
          sessionIdProvider.overrideWith((ref) => 'sess-locale-$code'),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(localeControllerProvider.notifier)
          .setLocale(Locale(code));

      expect(prefs.getString(LocaleController.localePreferenceKey), code);
      expect(container.read(localeControllerProvider).languageCode, code);
    }
  });

  test('setLocale persists German code', () async {
    SharedPreferences.setMockInitialValues({
      LocaleController.localePreferenceKey: 'en',
    });
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => prefs),
        databaseProvider.overrideWith((ref) => db),
        sessionIdProvider.overrideWith((ref) => 'sess-locale'),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(localeControllerProvider.notifier)
        .setLocale(const Locale('de'));

    expect(prefs.getString(LocaleController.localePreferenceKey), 'de');
    expect(container.read(localeControllerProvider).languageCode, 'de');
  });
}
