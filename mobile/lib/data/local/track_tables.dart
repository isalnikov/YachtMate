import 'package:drift/drift.dart';

@DataClassName('TrackTripRow')
class TrackTrips extends Table {
  TextColumn get id => text()();

  IntColumn get startedAtMs => integer()();

  IntColumn get endedAtMs => integer().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

@DataClassName('TrackPointRow')
class TrackPoints extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get tripId => text()();

  IntColumn get t => integer()();

  RealColumn get lat => real()();

  RealColumn get lon => real()();

  RealColumn get sog => real().nullable()();

  RealColumn get cog => real().nullable()();
}
