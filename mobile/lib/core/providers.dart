import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/local/app_database.dart';
import '../data/repositories/audit_repository.dart';
import '../data/repositories/chart_region_repository.dart';
import '../data/repositories/route_repository.dart';
import 'logging/app_logger.dart';

/// Injected after `SharedPreferences.getInstance()` in [main].
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw StateError('bootstrap SharedPreferences'),
);

final databaseProvider = Provider<AppDatabase>(
  (ref) => throw StateError('bootstrap AppDatabase'),
);

final auditRepositoryProvider = Provider<AuditRepository>(
  (ref) => AuditRepository(ref.watch(databaseProvider)),
);

final routeRepositoryProvider = Provider<RouteRepository>(
  (ref) => RouteRepository(ref.watch(databaseProvider)),
);

final chartRegionRepositoryProvider = Provider<ChartRegionRepository>(
  (ref) => ChartRegionRepository(ref.watch(databaseProvider)),
);

/// One UUID per process — correlates audit rows for this run.
final sessionIdProvider = Provider<String>(
  (ref) => throw StateError('bootstrap session id'),
);

final rootLoggerProvider = Provider<AppLogger>((ref) => AppLogger('app'));

class LocaleController extends StateNotifier<Locale> {
  LocaleController(this._prefs) : super(_readLocale(_prefs));

  final SharedPreferences _prefs;

  static Locale _readLocale(SharedPreferences prefs) {
    switch (prefs.getString(_localeKey)) {
      case 'ru':
        return const Locale('ru');
      default:
        return const Locale('en');
    }
  }

  static const _localeKey = 'localeCode';

  Future<void> setLocale(Locale locale) async {
    await _prefs.setString(_localeKey, locale.languageCode);
    state = locale;
  }
}

final localeControllerProvider =
    StateNotifierProvider<LocaleController, Locale>((ref) {
      return LocaleController(ref.watch(sharedPreferencesProvider));
    });
