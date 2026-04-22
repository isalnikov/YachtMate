import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/data/repositories/track_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TrackRepository start append end', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final r = TrackRepository(db);
    final id = await r.startTrip();
    await r.appendPoint(tripId: id, lat: 1, lon: 2, sog: 3, cog: 4);
    await r.appendPoint(tripId: id, lat: 1.1, lon: 2.1);
    final pts = await r.pointsForTrip(id);
    expect(pts, hasLength(2));
    await r.endTrip(id);
    final t = await r.tripById(id);
    expect(t?.endedAtMs, isNotNull);
  });
}
