import 'package:drift/drift.dart';

import 'route_tables.dart';
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
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 3;

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
    },
      );
}

/// Открытие БД см. [open_database.dart] (ffi на io, sql.js на web).
