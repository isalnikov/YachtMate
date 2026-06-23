import 'dart:convert';

import '../../data/local/app_database.dart';
import 'mooring_list_helpers.dart';

/// Hero image URL from catalog `services.photoUrl` (GeoJSON import).
String? mooringPhotoUrl(MooringPlaceRow place) {
  final raw = place.servicesJson;
  if (raw == null || raw.isEmpty) return null;
  try {
    final svc = jsonDecode(raw) as Map<String, dynamic>;
    final url = svc['photoUrl'];
    if (url is String && url.trim().isNotEmpty) return url.trim();
  } catch (_) {}
  return null;
}

/// Catalog seed rating (`services.seedRating`) or deterministic demo fallback.
double mooringSeedRatingStars(MooringPlaceRow place) {
  final raw = place.servicesJson;
  if (raw != null && raw.isNotEmpty) {
    try {
      final svc = jsonDecode(raw) as Map<String, dynamic>;
      final seed = svc['seedRating'];
      if (seed is num) {
        return seed.toDouble().clamp(1.0, 5.0);
      }
    } catch (_) {}
  }
  return mooringDemoRatingStars(place.id);
}

/// Mean of seed rating and all local review drafts for [place].
double mooringAggregatedRatingStars({
  required MooringPlaceRow place,
  Iterable<MooringReviewDraftRow> reviews = const [],
}) {
  final values = <double>[mooringSeedRatingStars(place)];
  for (final review in reviews) {
    if (review.placeId == place.id) {
      values.add(review.stars.toDouble().clamp(1.0, 5.0));
    }
  }
  final sum = values.fold<double>(0, (a, b) => a + b);
  return sum / values.length;
}
