import 'dart:ui' show Locale;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/local/app_database.dart';
import '../data/repositories/audit_repository.dart';
import '../data/repositories/chart_region_repository.dart';
import '../data/repositories/route_repository.dart';
import '../data/repositories/tides_repository.dart';
import '../data/repositories/weather_repository.dart';
import 'locale_controller.dart';
import 'logging/app_logger.dart';
import 'map_layer_preferences_controller.dart';

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

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  final r = WeatherRepository(ref.watch(databaseProvider));
  ref.onDispose(r.dispose);
  return r;
});

final tidesRepositoryProvider = Provider<TidesRepository>(
  (ref) => TidesRepository(),
);

/// One UUID per process — correlates audit rows for this run.
final sessionIdProvider = Provider<String>(
  (ref) => throw StateError('bootstrap session id'),
);

final rootLoggerProvider = Provider<AppLogger>((ref) => AppLogger('app'));

final localeControllerProvider =
    StateNotifierProvider<LocaleController, Locale>((ref) {
  return LocaleController(
    ref.watch(sharedPreferencesProvider),
    ref.watch(auditRepositoryProvider),
    ref.watch(sessionIdProvider),
  );
});

final mapLayerPreferencesProvider =
    StateNotifierProvider<MapLayerPreferencesController, MapLayerVisibility>(
        (ref) {
  return MapLayerPreferencesController(
    ref.watch(sharedPreferencesProvider),
    ref.watch(auditRepositoryProvider),
    ref.watch(sessionIdProvider),
  );
});
