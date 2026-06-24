import 'package:drift/drift.dart';

import 'checklist_tables.dart';
import 'expense_tables.dart';
import 'grib_tables.dart';
import 'logbook_tables.dart';
import 'mooring_tables.dart';
import 'route_tables.dart';
import 'track_tables.dart';
import 'vault_tables.dart';
import 'vhf_tables.dart';
import 'tides_tables.dart';
import 'weather_tables.dart';

part 'app_database.g.dart';

/// Logical DDL: [Подробный план реализации.md] §5.2 — `user_action_audit`.
class UserActionAudits extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get t => integer()();

  TextColumn get sessionId => text()();

  TextColumn get module => text()();

  TextColumn get action => text()();

  TextColumn get severity => text().withDefault(const Constant('info'))();

  TextColumn get contextJson => text().nullable()();
}

@DriftDatabase(
  tables: [
    UserActionAudits,
    Routes,
    RouteWaypoints,
    ChartRegions,
    WeatherCacheRows,
    TidesCacheRows,
    MooringPlaces,
    MooringReviewDrafts,
    LogbookEntries,
    TrackTrips,
    TrackPoints,
    ChecklistInstances,
    VaultFiles,
    ExpenseEntries,
    VhfRecordings,
    GribImportCache,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 10;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(routes);
        await m.createTable(routeWaypoints);
        await m.createTable(chartRegions);
      }
      if (from < 3) {
        await m.createTable(weatherCacheRows);
      }
      if (from < 4) {
        await m.createTable(mooringPlaces);
        await m.createTable(mooringReviewDrafts);
      }
      if (from < 5) {
        await m.addColumn(mooringPlaces, mooringPlaces.email);
        await m.addColumn(mooringPlaces, mooringPlaces.websiteUrl);
        await m.addColumn(mooringPlaces, mooringPlaces.bookingUrl);
        await m.addColumn(mooringPlaces, mooringPlaces.sourceUpdatedAtMs);
      }
      if (from < 6) {
        await m.createTable(logbookEntries);
      }
      if (from < 7) {
        await m.createTable(trackTrips);
        await m.createTable(trackPoints);
        await m.createTable(checklistInstances);
        await m.createTable(vaultFiles);
      }
      if (from < 8) {
        await m.createTable(expenseEntries);
        await m.createTable(vhfRecordings);
      }
      if (from < 9) {
        await m.createTable(tidesCacheRows);
      }
      if (from < 10) {
        await m.createTable(gribImportCache);
      }
    },
  );
}

/// Открытие БД см. [open_database.dart] (ffi на io, sql.js на web).
