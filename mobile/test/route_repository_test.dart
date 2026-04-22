import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/data/repositories/route_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('create route and replace waypoints', () async {
    final repo = RouteRepository(db);
    final id = await repo.createDraftRoute(name: 'Test');
    await repo.replaceWaypoints(id, [
      const WaypointDraft(lat: 59.9, lon: 30.3),
      const WaypointDraft(lat: 59.95, lon: 30.35, name: 'B'),
    ]);

    final w = await repo.waypointsOrdered(id);
    expect(w, hasLength(2));
    expect(w.first.lat, 59.9);
    expect(w.last.name, 'B');

    await repo.deleteRoute(id);
    final gone = await repo.routeById(id);
    expect(gone, null);
  });
}
