// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Captain Wrongel';

  @override
  String get tabMap => 'Map';

  @override
  String get tabRoute => 'Route';

  @override
  String get tabWeather => 'Weather';

  @override
  String get tabMooring => 'Mooring';

  @override
  String get tabMore => 'More';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get languageLabel => 'Language';

  @override
  String get languageSwitchTooltip => 'Choose language (English / Russian)';

  @override
  String get localeEnglish => 'English';

  @override
  String get localeRussian => 'Russian';

  @override
  String get bootstrapNote =>
      'Phase 0 shell — navigation and charts follow in Phase 1.';

  @override
  String get mapUnavailableOnPlatform =>
      'Raster/vector charts run on Android, iOS, or web. Linux desktop shows this placeholder.';

  @override
  String get mapLoadingStyle => 'Loading chart style…';

  @override
  String get disclaimerTitle => 'Navigation notice';

  @override
  String get disclaimerP1 =>
      'Captain Wrongel is not an ECDIS, radar, or official nautical chart system. Charts and GPS may be inaccurate or outdated.';

  @override
  String get disclaimerP2 =>
      'You alone are responsible for safe navigation, collision avoidance (COLREG), and verifying all information against official publications.';

  @override
  String get disclaimerAccept => 'I understand — continue';

  @override
  String get offlineCacheStart => 'Downloading tiles for the visible region…';

  @override
  String get offlineCacheDone => 'Offline region saved';

  @override
  String get offlineCacheFail =>
      'Could not cache offline tiles (network or engine).';

  @override
  String get mapLayersTooltip => 'Map layers';

  @override
  String get mapLayersSheetTitle => 'Map layers (demo)';

  @override
  String get mapLayerDepthContours => 'Depth contours (synthetic)';

  @override
  String get mapLayerNavAids => 'Navigation marks (synthetic)';

  @override
  String get mapDepthLegendTitle => 'Legend';

  @override
  String get mapDepthLegendBody =>
      'Blue lines: EMODnet Bathymetry contours (example region: Fethiye, Turkey). Single display color — depth values drive routing grid only. Not official charts.';

  @override
  String get mapLongPressTitle => 'Position (WGS84)';

  @override
  String get mapLongPressLatitude => 'Latitude';

  @override
  String get mapLongPressLongitude => 'Longitude';

  @override
  String get mapLongPressDepth => 'Depth (demo)';

  @override
  String get mapLongPressDepthUnavailable =>
      'No contour within range — enable the layer or move closer.';

  @override
  String get mapLongPressNavAid => 'Nearest mark';

  @override
  String get mapLongPressNavUnavailable => '—';

  @override
  String get mapLongPressAddWaypoint => 'Add route waypoint';

  @override
  String get mapAisDemoTooltip => 'AIS demo stream (recorded NMEA)';

  @override
  String get weatherScreenTitle => 'Weather & tides';

  @override
  String get weatherRefreshTooltip => 'Refresh forecast';

  @override
  String get weatherGpsTooltip => 'Use GPS for forecast location';

  @override
  String get weatherStaleBanner =>
      'Showing cached forecast — network or API unavailable.';

  @override
  String weatherCoordinates(String lat, String lon) {
    return 'Forecast pin: $lat°, $lon°';
  }

  @override
  String weatherLastUpdated(String time) {
    return 'Model run reference: $time';
  }

  @override
  String weatherLoadError(String detail) {
    return 'Could not load forecast: $detail';
  }

  @override
  String get weatherHourlyHeading => 'Hourly (48 h)';

  @override
  String get weatherTidesSection => 'Tides (demo)';

  @override
  String get weatherRefreshing => 'Refreshing…';

  @override
  String get weatherGpsDenied => 'Location permission denied.';

  @override
  String get weatherGpsUpdated => 'Forecast uses your GPS position.';

  @override
  String weatherGpsError(String detail) {
    return 'GPS error: $detail';
  }

  @override
  String get tidesHigh => 'High water';

  @override
  String get tidesLow => 'Low water';

  @override
  String weatherWaveSuffix(String m) {
    return ' · wave $m m';
  }

  @override
  String weatherHourLine(
    String tempC,
    String windKn,
    String windDir,
    String rainMm,
    String pressHpa,
    String wavePart,
  ) {
    return '$tempC °C · wind $windKn kn / $windDir° · rain $rainMm mm · $pressHpa hPa$wavePart';
  }

  @override
  String weatherTideRow(String time, String height, String kind) {
    return '$time · $height · $kind';
  }

  @override
  String get routeScreenTitle => 'Route (advisory)';

  @override
  String get routeAdvisoryDisclaimerTitle => 'Advisory routing (synthetic)';

  @override
  String get routeAdvisoryDisclaimerBody =>
      'The path is computed on a demo depth grid, not an official chart. It is for orientation only; you are responsible for safe navigation and depth under keel.';

  @override
  String get routeAdvisoryDisclaimerAccept => 'I understand';

  @override
  String routeActiveRouteLabel(String id) {
    return 'Current draft: $id';
  }

  @override
  String get routeActiveRouteUnknown => 'none';

  @override
  String get routeShipDraftM => 'Draft (m)';

  @override
  String get routeShipClearanceM => 'Under-keel clearance (m)';

  @override
  String get routeComputeAdvisory => 'Compute advisory path';

  @override
  String get routeClearAdvisory => 'Clear path';

  @override
  String get routeSyntheticNote =>
      'Depth grid samples the same synthetic contour GeoJSON as the map layer — not official survey data.';

  @override
  String get routeAdvisoryChartLoadFailed =>
      'Could not load demo chart contours for routing.';

  @override
  String get routeAdvisoryNoRoute =>
      'No saved route yet. Add waypoints on the map.';

  @override
  String get routeAdvisoryNeedTwoPoints =>
      'Need at least two waypoints (start and end).';

  @override
  String get routeAdvisoryComputed => 'Advisory polyline drawn on the map.';

  @override
  String routeAdvisoryFailed(String reason) {
    return 'Could not compute path: $reason';
  }
}
