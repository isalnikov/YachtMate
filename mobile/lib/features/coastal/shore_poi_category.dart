import '../../l10n/app_localizations.dart';

/// Localized label for a shore POI category key from GeoJSON.
String shorePoiCategoryLabel(AppLocalizations l10n, String category) {
  return switch (category) {
    'beach' => l10n.coastalCategoryBeach,
    'fuel' => l10n.coastalCategoryFuel,
    'marina' => l10n.coastalCategoryMarina,
    'restaurant' => l10n.coastalCategoryRestaurant,
    'attraction' => l10n.coastalCategoryAttraction,
    _ => l10n.coastalCategoryOther,
  };
}
