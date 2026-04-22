import 'dart:convert';

import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/data/repositories/mooring_repository.dart';
import 'package:captain_wrongel/data/repositories/mooring_review_outbound_client.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('import geojson seeds mooring places', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = MooringRepository(db);

    final root =
        jsonDecode(r'''
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {
        "id": "t1",
        "kind": "marina",
        "name": "Test marina",
        "services": {"water": true}
      },
      "geometry": {"type": "Point", "coordinates": [29.1, 36.7]}
    }
  ]
}
''')
            as Map<String, dynamic>;

    await repo.replaceFromGeoJson(root);
    final rows = await repo.allPlaces();
    expect(rows, hasLength(1));
    expect(rows.single.id, 't1');
    expect(rows.single.kind, 'marina');
    expect(rows.single.servicesJson, contains('water'));

    await repo.queueReviewDraft(placeId: 't1', stars: 5, comment: 'ok');
    final pending = await repo.pendingReviews();
    expect(pending, hasLength(1));
    expect(pending.single.stars, 5);
  });

  test('mergeFromGeoJson skips older rows by sourceUpdatedAtMs', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = MooringRepository(db);

    await repo.mergeFromGeoJson(
      jsonDecode(r'''
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {
        "id": "t1",
        "kind": "marina",
        "name": "First",
        "sourceUpdatedAtMs": 2000
      },
      "geometry": {"type": "Point", "coordinates": [29.1, 36.7]}
    }
  ]
}
''')
          as Map<String, dynamic>,
    );

    final statsNewer = await repo.mergeFromGeoJson(
      jsonDecode(r'''
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {
        "id": "t1",
        "kind": "marina",
        "name": "Second",
        "sourceUpdatedAtMs": 3000
      },
      "geometry": {"type": "Point", "coordinates": [29.1, 36.7]}
    }
  ]
}
''')
          as Map<String, dynamic>,
    );
    expect(statsNewer.inserted, 0);
    expect(statsNewer.updated, 1);
    expect((await repo.placeById('t1'))!.name, 'Second');

    final statsOlder = await repo.mergeFromGeoJson(
      jsonDecode(r'''
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {
        "id": "t1",
        "kind": "marina",
        "name": "Stale",
        "sourceUpdatedAtMs": 1000
      },
      "geometry": {"type": "Point", "coordinates": [29.1, 36.7]}
    }
  ]
}
''')
          as Map<String, dynamic>,
    );
    expect(statsOlder.skippedOlderOrEqual, 1);
    expect((await repo.placeById('t1'))!.name, 'Second');
  });

  test('syncPendingReviews clears queue via loopback client', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = MooringRepository(db);

    await repo.replaceFromGeoJson(
      jsonDecode(r'''
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {"id": "t1", "kind": "marina", "name": "X"},
      "geometry": {"type": "Point", "coordinates": [29.1, 36.7]}
    }
  ]
}
''')
          as Map<String, dynamic>,
    );

    await repo.queueReviewDraft(placeId: 't1', stars: 4);
    expect(await repo.pendingReviews(), hasLength(1));

    final stats = await repo.syncPendingReviews(
      const LoopbackMooringReviewOutboundClient(),
    );
    expect(stats.submitted, 1);
    expect(stats.failed, 0);
    expect(await repo.pendingReviews(), isEmpty);
  });
}
