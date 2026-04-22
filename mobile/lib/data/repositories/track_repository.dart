import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../local/app_database.dart';

/// Запись треков рейса (Фаза 7.3).
class TrackRepository {
  TrackRepository(this._db);

  final AppDatabase _db;

  static const _uuid = Uuid();

  Future<String> startTrip() async {
    final id = _uuid.v4();
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db
        .into(_db.trackTrips)
        .insert(TrackTripsCompanion.insert(id: id, startedAtMs: now));
    return id;
  }

  Future<void> appendPoint({
    required String tripId,
    required double lat,
    required double lon,
    double? sog,
    double? cog,
    DateTime? at,
  }) async {
    final ms = (at ?? DateTime.now()).millisecondsSinceEpoch;
    await _db
        .into(_db.trackPoints)
        .insert(
          TrackPointsCompanion.insert(
            tripId: tripId,
            t: ms,
            lat: lat,
            lon: lon,
            sog: Value(sog),
            cog: Value(cog),
          ),
        );
  }

  Future<void> endTrip(String tripId) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await (_db.update(_db.trackTrips)..where((t) => t.id.equals(tripId))).write(
      TrackTripsCompanion(endedAtMs: Value(now)),
    );
  }

  Future<List<TrackPointRow>> pointsForTrip(String tripId) {
    return (_db.select(_db.trackPoints)
          ..where((p) => p.tripId.equals(tripId))
          ..orderBy([(p) => OrderingTerm.asc(p.t)]))
        .get();
  }

  Future<TrackTripRow?> tripById(String id) {
    return (_db.select(
      _db.trackTrips,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<TrackTripRow>> tripsNewestFirst() {
    return (_db.select(
      _db.trackTrips,
    )..orderBy([(t) => OrderingTerm.desc(t.startedAtMs)])).get();
  }
}
