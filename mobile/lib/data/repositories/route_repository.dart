import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../local/app_database.dart';

/// Persistent draft routes and waypoints (Фаза 1.4).
class RouteRepository {
  RouteRepository(this._db);

  final AppDatabase _db;

  static const _uuid = Uuid();

  Future<String> createDraftRoute({required String name}) async {
    final id = _uuid.v4();
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db
        .into(_db.routes)
        .insert(
          RoutesCompanion.insert(
            id: id,
            name: name,
            createdAt: now,
            updatedAt: now,
          ),
        );
    return id;
  }

  /// Replaces all waypoints for a route in one transaction.
  Future<void> replaceWaypoints(
    String routeId,
    List<WaypointDraft> points,
  ) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.transaction(() async {
      await (_db.delete(
        _db.routeWaypoints,
      )..where((w) => w.routeId.equals(routeId))).go();
      var seq = 0;
      for (final p in points) {
        await _db
            .into(_db.routeWaypoints)
            .insert(
              RouteWaypointsCompanion.insert(
                id: _uuid.v4(),
                routeId: routeId,
                seq: seq++,
                lat: p.lat,
                lon: p.lon,
                name: Value(p.name),
              ),
            );
      }
      await (_db.update(_db.routes)..where((r) => r.id.equals(routeId))).write(
        RoutesCompanion(updatedAt: Value(now)),
      );
    });
  }

  Future<List<RouteWaypointRow>> waypointsOrdered(String routeId) {
    return (_db.select(_db.routeWaypoints)
          ..where((w) => w.routeId.equals(routeId))
          ..orderBy([(w) => OrderingTerm.asc(w.seq)]))
        .get();
  }

  Future<void> deleteRoute(String routeId) async {
    await (_db.delete(_db.routes)..where((r) => r.id.equals(routeId))).go();
  }

  Future<RouteEntity?> routeById(String routeId) {
    return (_db.select(
      _db.routes,
    )..where((r) => r.id.equals(routeId))).getSingleOrNull();
  }
}

class WaypointDraft {
  const WaypointDraft({required this.lat, required this.lon, this.name});

  final double lat;
  final double lon;
  final String? name;
}
