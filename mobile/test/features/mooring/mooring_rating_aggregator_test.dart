import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/features/mooring/mooring_rating_aggregator.dart';
import 'package:flutter_test/flutter_test.dart';

MooringPlaceRow _place({required String id, String? servicesJson}) {
  return MooringPlaceRow(
    id: id,
    kind: 'marina',
    name: 'Test',
    lat: 36.7,
    lon: 29.1,
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

MooringReviewDraftRow _review({
  required String placeId,
  required int stars,
}) {
  return MooringReviewDraftRow(
    id: 'r-$placeId-$stars',
    placeId: placeId,
    stars: stars,
    comment: null,
    createdAtMs: 1,
    synced: false,
  );
}

void main() {
  test('mooringPhotoUrl reads services.photoUrl', () {
    expect(
      mooringPhotoUrl(
        _place(
          id: 'p1',
          servicesJson:
              '{"photoUrl":"https://example.com/marina.jpg","depthM":3}',
        ),
      ),
      'https://example.com/marina.jpg',
    );
    expect(mooringPhotoUrl(_place(id: 'p2')), isNull);
  });

  test('mooringSeedRatingStars prefers catalog seedRating', () {
    expect(
      mooringSeedRatingStars(
        _place(id: 'p1', servicesJson: '{"seedRating":4.8}'),
      ),
      4.8,
    );
    expect(
      mooringSeedRatingStars(_place(id: 'demo_marina')),
      greaterThanOrEqualTo(3.0),
    );
  });

  test('mooringAggregatedRatingStars averages seed and local reviews', () {
    final place = _place(id: 'p1', servicesJson: '{"seedRating":4.0}');
    expect(
      mooringAggregatedRatingStars(place: place, reviews: const []),
      4.0,
    );
    expect(
      mooringAggregatedRatingStars(
        place: place,
        reviews: [
          _review(placeId: 'p1', stars: 5),
          _review(placeId: 'other', stars: 1),
        ],
      ),
      4.5,
    );
  });
}
