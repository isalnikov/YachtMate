import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'route_tables.dart';

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

@DriftDatabase(tables: [UserActionAudits, Routes, RouteWaypoints, ChartRegions])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 2;

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
        },
      );
}

/// Opens [AppDatabase] on a SQLite file under application documents.
Future<AppDatabase> openAppDatabase() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File(p.join(dir.path, 'app.db'));
  final executor = LazyDatabase(() async {
    return NativeDatabase.createInBackground(file);
  });
  return AppDatabase(executor);
}
