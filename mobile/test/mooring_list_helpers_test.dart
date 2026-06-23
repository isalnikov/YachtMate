import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/features/mooring/mooring_list_helpers.dart';
import 'package:flutter_test/flutter_test.dart';

MooringPlaceRow _place({
  required String id,
  required String kind,
  required String name,
  double lat = 36.7,
  double lon = 29.1,
  String? servicesJson,
}) {
  return MooringPlaceRow(
    id: id,
    kind: kind,
    name: name,
    lat: lat,
    lon: lon,
    vhf: null,
    phone: null,
    email: null,
    websiteUrl: null,
    bookingUrl: null,
    servicesJson: servicesJson,
    notes: null,
    sourceUpdatedAtMs: null,
  );
}

void main() {
  final places = [
    _place(id: 'm1', kind: kMooringKindMarina, name: 'Alpha Marina'),
    _place(
      id: 'a1',
      kind: kMooringKindAnchorage,
      name: 'Beta Cove',
      lat: 36.71,
      lon: 29.11,
      servicesJson: '{"holding":"mud"}',
    ),
    _place(id: 'b1', kind: kMooringKindBuoy, name: 'Gamma Buoy'),
  ];

  test('filterMooringPlaces applies search and kind filters together', () {
    final marinaOnly = filterMooringPlaces(
      places: places,
      query: '',
      kindFilters: {kMooringKindMarina},
    );
    expect(marinaOnly, hasLength(1));
    expect(marinaOnly.single.name, 'Alpha Marina');

    final searchAndKind = filterMooringPlaces(
      places: places,
      query: 'beta',
      kindFilters: {kMooringKindAnchorage},
    );
    expect(searchAndKind, hasLength(1));
    expect(searchAndKind.single.id, 'a1');

    final noMatch = filterMooringPlaces(
      places: places,
      query: 'alpha',
      kindFilters: {kMooringKindAnchorage},
    );
    expect(noMatch, isEmpty);
  });

  test('sortMooringPlaces orders by distance from reference', () {
    final refLat = 36.7;
    final refLon = 29.1;
    final sorted = sortMooringPlaces(
      places: places,
      mode: MooringSortMode.distance,
      refLat: refLat,
      refLon: refLon,
    );
    expect(sorted.first.id, 'm1');
  });

  test('sortMooringPlaces orders by demo rating descending', () {
    final sorted = sortMooringPlaces(
      places: places,
      mode: MooringSortMode.rating,
    );
    final ratings = sorted
        .map((p) => mooringDemoRatingStars(p.id))
        .toList(growable: false);
    for (var i = 0; i < ratings.length - 1; i++) {
      expect(ratings[i], greaterThanOrEqualTo(ratings[i + 1]));
    }
  });

  test('mooringDepthChipText reads depthM and holding', () {
    expect(
      mooringDepthChipText(
        _place(
          id: 'd1',
          kind: kMooringKindMarina,
          name: 'Deep',
          servicesJson: '{"depthM":4.5}',
        ),
      ),
      '4.5 m',
    );
    expect(
      mooringDepthChipText(
        _place(
          id: 'd2',
          kind: kMooringKindAnchorage,
          name: 'Mud',
          servicesJson: '{"holding":"mud"}',
        ),
      ),
      'mud',
    );
  });
}
