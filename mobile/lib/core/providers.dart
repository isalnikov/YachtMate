import 'dart:ui' show Locale;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/local/app_database.dart';
import '../data/repositories/audit_repository.dart';
import '../data/repositories/chart_region_repository.dart';
import '../data/repositories/checklist_repository.dart';
import '../data/repositories/expense_repository.dart';
import '../data/repositories/knot_reference_repository.dart';
import '../data/repositories/logbook_repository.dart';
import '../data/repositories/route_repository.dart';
import '../data/repositories/tides_repository.dart';
import '../data/repositories/track_repository.dart';
import '../data/repositories/vault_repository.dart';
import '../data/repositories/vhf_recording_repository.dart';
import '../data/repositories/weather_repository.dart';
import '../domain/reference/knot_entry.dart';
import 'accessibility_preferences_controller.dart';
import 'anchor_watch_controller.dart';
import 'energy_profile_controller.dart';
import 'feature_flags.dart';
import 'feature_flags_controller.dart';
import 'locale_controller.dart';
import 'logging/app_logger.dart';
import 'map_layer_preferences_controller.dart';
import 'notifications/local_notifications_service.dart';
import 'notifications/notification_preferences_controller.dart';
import 'theme_mode_controller.dart';
import 'vessel_prefs.dart';
import 'voyage_monitor_controller.dart';

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

final checklistRepositoryProvider = Provider<ChecklistRepository>(
  (ref) => ChecklistRepository(ref.watch(databaseProvider)),
);

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  final r = WeatherRepository(ref.watch(databaseProvider));
  ref.onDispose(r.dispose);
  return r;
});

final tidesRepositoryProvider = Provider<TidesRepository>((ref) {
  final r = TidesRepository(ref.watch(databaseProvider));
  ref.onDispose(r.dispose);
  return r;
});

final logbookRepositoryProvider = Provider<LogbookRepository>(
  (ref) => LogbookRepository(ref.watch(databaseProvider)),
);

final trackRepositoryProvider = Provider<TrackRepository>(
  (ref) => TrackRepository(ref.watch(databaseProvider)),
);

final vaultRepositoryProvider = Provider<VaultRepository>(
  (ref) => VaultRepository(ref.watch(databaseProvider)),
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
    StateNotifierProvider<MapLayerPreferencesController, MapLayerVisibility>((
      ref,
    ) {
      return MapLayerPreferencesController(
        ref.watch(sharedPreferencesProvider),
        ref.watch(auditRepositoryProvider),
        ref.watch(sessionIdProvider),
      );
    });

final accessibilityPreferencesProvider =
    StateNotifierProvider<
      AccessibilityPreferencesController,
      AccessibilityPreferences
    >((ref) {
      return AccessibilityPreferencesController(
        ref.watch(sharedPreferencesProvider),
        ref.watch(auditRepositoryProvider),
        ref.watch(sessionIdProvider),
      );
    });

final themeModeProvider = StateNotifierProvider<ThemeModeController, bool>((
  ref,
) {
  return ThemeModeController(
    ref.watch(sharedPreferencesProvider),
    ref.watch(auditRepositoryProvider),
    ref.watch(sessionIdProvider),
  );
});

final energyProfileProvider =
    StateNotifierProvider<EnergyProfileController, EnergyProfile>((ref) {
  return EnergyProfileController(
    ref.watch(sharedPreferencesProvider),
    ref.watch(auditRepositoryProvider),
    ref.watch(sessionIdProvider),
  );
});

final vesselPrefsProvider =
    StateNotifierProvider<VesselPrefsController, VesselProfile>((ref) {
      return VesselPrefsController(
        ref.watch(sharedPreferencesProvider),
        ref.watch(auditRepositoryProvider),
        ref.watch(sessionIdProvider),
      );
    });

final anchorWatchProvider =
    StateNotifierProvider<AnchorWatchController, AnchorWatchState>((ref) {
  return AnchorWatchController(
    ref.watch(sharedPreferencesProvider),
    ref.watch(auditRepositoryProvider),
    ref.watch(sessionIdProvider),
    notifications: ref.watch(localNotificationsPortProvider),
    notificationPrefs: () => ref.read(notificationPreferencesProvider),
  );
});

final localNotificationsPortProvider = Provider<LocalNotificationsPort>(
  (ref) => FlutterLocalNotificationsPort(),
);

final notificationPreferencesProvider = StateNotifierProvider<
    NotificationPreferencesController, NotificationPreferences>((ref) {
  return NotificationPreferencesController(
    ref.watch(sharedPreferencesProvider),
    ref.watch(auditRepositoryProvider),
    ref.watch(sessionIdProvider),
  );
});

final featureFlagsProvider =
    StateNotifierProvider<FeatureFlagsController, FeatureFlags>((ref) {
  return FeatureFlagsController(
    ref.watch(sharedPreferencesProvider),
    ref.watch(auditRepositoryProvider),
    ref.watch(sessionIdProvider),
  );
});

final voyageMonitorProvider =
    StateNotifierProvider<VoyageMonitorController, VoyageMonitorState>((ref) {
  return VoyageMonitorController(
    ref.watch(sharedPreferencesProvider),
    ref.watch(auditRepositoryProvider),
    ref.watch(sessionIdProvider),
  );
});

final expenseRepositoryProvider = Provider<ExpenseRepository>(
  (ref) => ExpenseRepository(ref.watch(databaseProvider)),
);

final vhfRecordingRepositoryProvider = Provider<VhfRecordingRepository>(
  (ref) => VhfRecordingRepository(ref.watch(databaseProvider)),
);

final knotReferenceRepositoryProvider = Provider<KnotReferenceRepository>(
  (ref) => KnotReferenceRepository(),
);

final knotsCatalogProvider = FutureProvider<List<KnotEntry>>((ref) async {
  return ref.watch(knotReferenceRepositoryProvider).loadCatalog();
});
