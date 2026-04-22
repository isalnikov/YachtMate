import 'package:drift/drift.dart';

/// Logical DDL: Подробный план §5.2 — маршруты.
@DataClassName('RouteEntity')
class Routes extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  IntColumn get createdAt => integer()();

  IntColumn get updatedAt => integer()();

  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

@DataClassName('RouteWaypointRow')
class RouteWaypoints extends Table {
  TextColumn get id => text()();

  TextColumn get routeId => text().references(Routes, #id, onDelete: KeyAction.cascade)();

  IntColumn get seq => integer()();

  RealColumn get lat => real()();

  RealColumn get lon => real()();

  TextColumn get name => text().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

@DataClassName('ChartRegionRow')
class ChartRegions extends Table {
  TextColumn get regionId => text()();

  TextColumn get path => text()();

  TextColumn get checksum => text().nullable()();

  IntColumn get installedAt => integer()();

  TextColumn get licenseTier => text()();

  @override
  Set<Column<Object>>? get primaryKey => {regionId};
}
