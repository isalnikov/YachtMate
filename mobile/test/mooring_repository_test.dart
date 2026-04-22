import 'dart:convert';

import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/data/repositories/mooring_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('import geojson seeds mooring places', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = MooringRepository(db);

    final root = jsonDecode(r'''
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
''') as Map<String, dynamic>;

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
}
