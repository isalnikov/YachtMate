import 'dart:convert';

import '../../data/local/app_database.dart';
import '../../domain/anchor/geo.dart';

/// Catalog kind values used by filter chips.
const kMooringKindMarina = 'marina';
const kMooringKindAnchorage = 'anchorage';
const kMooringKindBuoy = 'buoy';

const kMooringKindFilters = <String>{
  kMooringKindMarina,
  kMooringKindAnchorage,
  kMooringKindBuoy,
};

/// Default map center for Fethiye demo catalog (distance sort fallback).
const kMooringDemoRefLat = 36.65;
const kMooringDemoRefLon = 29.12;

enum MooringSortMode { distance, rating }

/// Applies text search and optional kind filters (empty [kindFilters] = all kinds).
List<MooringPlaceRow> filterMooringPlaces({
  required List<MooringPlaceRow> places,
  required String query,
  required Set<String> kindFilters,
}) {
  final q = query.trim().toLowerCase();
  return places.where((p) {
    if (kindFilters.isNotEmpty && !kindFilters.contains(p.kind)) {
      return false;
    }
    if (q.isNotEmpty && !p.name.toLowerCase().contains(q)) {
      return false;
    }
    return true;
  }).toList(growable: false);
}

/// Deterministic demo rating until aggregated reviews exist in the catalog.
double mooringDemoRatingStars(String placeId) {
  var hash = 0;
  for (final c in placeId.codeUnits) {
    hash = (hash * 31 + c) & 0x7fffffff;
  }
  return 3.0 + (hash % 21) / 10.0;
}

/// Depth chip label from `services.depthM` or holding ground for anchorages.
String? mooringDepthChipText(MooringPlaceRow place) {
  final raw = place.servicesJson;
  if (raw == null || raw.isEmpty) return null;
  try {
    final svc = jsonDecode(raw) as Map<String, dynamic>;
    final depth = svc['depthM'];
    if (depth is num) {
      return '${depth.toStringAsFixed(depth == depth.roundToDouble() ? 0 : 1)} m';
    }
    final holding = svc['holding'];
    if (holding is String && holding.isNotEmpty) {
      return holding;
    }
  } catch (_) {}
  return null;
}

double mooringDistanceNm(
  MooringPlaceRow place, {
  required double refLat,
  required double refLon,
}) {
  return haversineMeters(refLat, refLon, place.lat, place.lon) / 1852.0;
}

List<MooringPlaceRow> sortMooringPlaces({
  required List<MooringPlaceRow> places,
  required MooringSortMode mode,
  double refLat = kMooringDemoRefLat,
  double refLon = kMooringDemoRefLon,
}) {
  final sorted = List<MooringPlaceRow>.from(places);
  switch (mode) {
    case MooringSortMode.distance:
      sorted.sort((a, b) {
        final da = mooringDistanceNm(a, refLat: refLat, refLon: refLon);
        final db = mooringDistanceNm(b, refLat: refLat, refLon: refLon);
        final cmp = da.compareTo(db);
        if (cmp != 0) return cmp;
        return a.name.compareTo(b.name);
      });
    case MooringSortMode.rating:
      sorted.sort((a, b) {
        final ra = mooringDemoRatingStars(a.id);
        final rb = mooringDemoRatingStars(b.id);
        final cmp = rb.compareTo(ra);
        if (cmp != 0) return cmp;
        return a.name.compareTo(b.name);
      });
  }
  return sorted;
}
