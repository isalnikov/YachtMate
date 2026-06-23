// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

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
  String get languageSwitchTooltip => 'Choose interface language';

  @override
  String get localeEnglish => 'English';

  @override
  String get localeRussian => 'Russian';

  @override
  String get localeGerman => 'German';

  @override
  String get localeFrench => 'French';

  @override
  String get localeSpanish => 'Spanish';

  @override
  String get localeItalian => 'Italian';

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
  String get mapLayerMooringPois => 'Marinas & anchorages (catalog)';

  @override
  String get mapLayerSectionOverlays => 'Overlays';

  @override
  String get mapLayerSectionChart => 'Chart';

  @override
  String get mapLayerSectionShallow => 'Shallow';

  @override
  String get mapLayerOverlayNone => 'No Overlay';

  @override
  String get mapLayerOverlaySatellite => 'Satellite';

  @override
  String get mapLayerOverlayRelief => 'Relief Shading';

  @override
  String get mapLayerOverlaySonar => 'Sonar';

  @override
  String get mapLayerChartStandard => 'Standard';

  @override
  String get mapLayerChartPaper => 'Paper';

  @override
  String get mapLayerChartSimple => 'Simple';

  @override
  String get mapLayerChartNight => 'Night';

  @override
  String get mapLayerShallowHighlight => 'Shallow highlight';

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
  String get mapNavigateHere => 'Navigate here';

  @override
  String get mapCoordsCopied => 'Coordinates copied';

  @override
  String get mapPeekCoordsSemantic => 'Map center coordinates — tap to copy';

  @override
  String mapPeekDepthMeters(int meters) {
    return 'Depth: $meters m';
  }

  @override
  String get mapAisDemoTooltip => 'AIS demo stream (recorded NMEA)';

  @override
  String get aisScreenTitle => 'AIS';

  @override
  String get moreMenuAis => 'AIS traffic';

  @override
  String get moreMenuAisSubtitle => 'Local NMEA · CPA/TCPA · vessel filters';

  @override
  String get aisFilterAll => 'All';

  @override
  String get aisFilterCargo => 'Cargo';

  @override
  String get aisFilterTanker => 'Tanker';

  @override
  String get aisFilterPleasure => 'Pleasure';

  @override
  String get aisLocalStreamTitle => 'Local stream';

  @override
  String get aisLocalStreamBody => 'NMEA 0183 · Wi‑Fi/BT gateway · CPA/TCPA';

  @override
  String get aisDemoStart => 'Start demo';

  @override
  String get aisDemoStop => 'Stop';

  @override
  String get aisDemoActive => 'Demo NMEA stream active';

  @override
  String aisTargetsCount(int count) {
    return '$count targets';
  }

  @override
  String get aisTapVessel => 'Tap a vessel for details';

  @override
  String aisVesselSog(String knots) {
    return '$knots kn';
  }

  @override
  String aisVesselCog(String degrees) {
    return '$degrees°';
  }

  @override
  String aisVesselCpa(String nm) {
    return '$nm nm';
  }

  @override
  String aisVesselTcpa(String minutes) {
    return '$minutes min';
  }

  @override
  String get aisCpaWarning => 'CPA < 1 nm';

  @override
  String get mapZoomInTooltip => 'Zoom in';

  @override
  String get mapZoomOutTooltip => 'Zoom out';

  @override
  String get mapCompassNorthUpTooltip => 'North up — tap for heading up';

  @override
  String get mapCompassHeadingUpTooltip => 'Heading up — tap for north up';

  @override
  String get mapFollowGpsTooltip => 'Follow GPS';

  @override
  String get mapFollowGpsActiveTooltip => 'Following GPS — tap to stop';

  @override
  String get mapGpsStatusSemantic => 'GPS status — tap for location settings';

  @override
  String mapGpsAccuracyMeters(int meters) {
    return '±$meters m';
  }

  @override
  String mapGpsSogKnots(String knots) {
    return '$knots kn';
  }

  @override
  String get mapGpsLocationSettingsHint =>
      'Check location permission and GPS accuracy in system settings.';

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
  String get weatherLayerWindTooltip => 'Wind layer';

  @override
  String get weatherLayerWavesTooltip => 'Wave layer';

  @override
  String get weatherLayerTempTooltip => 'Temperature layer';

  @override
  String get weatherLayerPressureTooltip => 'Pressure layer';

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
  String get weatherSeeAllTides => 'See all tides';

  @override
  String get tidesScreenTitle => 'Tides';

  @override
  String get tidesCurveHeading => 'Today\'s curve (demo)';

  @override
  String get tidesTableHeading => '7-day schedule (demo)';

  @override
  String get tidesMoonHeading => 'Moon phase';

  @override
  String get tidesSunHeading => 'Sun times (approx.)';

  @override
  String get tidesTableDay => 'Day';

  @override
  String get tidesHighShort => 'HW';

  @override
  String get tidesLowShort => 'LW';

  @override
  String get tidesEmpty => 'No tide data available.';

  @override
  String get tidesStaleBanner =>
      'Showing cached tides — network or API unavailable.';

  @override
  String get tidesDemoBanner =>
      'Illustrative demo data — no live station for this location.';

  @override
  String tidesHeightM(String height) {
    return '$height m';
  }

  @override
  String tidesTableCell(String time, String height, String kind) {
    return '$time · $height · $kind';
  }

  @override
  String tidesSunLine(String sunrise, String sunset) {
    return 'Sunrise $sunrise · Sunset $sunset';
  }

  @override
  String get moreMenuTides => 'Tides';

  @override
  String get moreMenuTidesSubtitle => 'Demo curve, 7-day table, moon & sun';

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

  @override
  String get routePlanRoute => 'Plan route';

  @override
  String get routeStatsTitle => 'Route summary';

  @override
  String get routeStatsDistance => 'Distance';

  @override
  String get routeStatsEta => 'ETA';

  @override
  String get routeStatsWaypointCount => 'WPs';

  @override
  String routeStatsDistanceValue(String nm) {
    return '$nm nm';
  }

  @override
  String get routeStatsEtaUnknown => '—';

  @override
  String routeStatsEtaMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String routeStatsEtaHours(int hours) {
    return '$hours h';
  }

  @override
  String routeStatsEtaHoursMinutes(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String routeStatsWaypointCountValue(int count) {
    return '$count';
  }

  @override
  String get routeWaypointListTitle => 'Waypoints';

  @override
  String get routeWaypointEmpty => 'No waypoints yet. Add points on the map.';

  @override
  String routeWaypointDefaultName(int index) {
    return 'WP $index';
  }

  @override
  String get routeSafetyOk => 'Depth check OK along waypoints (demo grid).';

  @override
  String routeSafetyShallow(int index) {
    return 'Shallow water at WP $index: draft + clearance exceeds demo depth.';
  }

  @override
  String get routeShowCorridor => 'Safety corridor';

  @override
  String get routeShowCorridorSubtitle =>
      'Green ±50 m buffer around the route on the map';

  @override
  String get mooringScreenTitle => 'Marinas & anchorages';

  @override
  String get mooringKindMarina => 'Marina';

  @override
  String get mooringKindAnchorage => 'Anchorage';

  @override
  String get mooringKindBuoy => 'Mooring buoy';

  @override
  String get mooringViewList => 'List';

  @override
  String get mooringSortDistance => 'Distance';

  @override
  String get mooringSortRating => 'Rating';

  @override
  String get mooringDepthUnknown => 'Depth n/a';

  @override
  String mooringDistanceNm(String distance) {
    return '$distance nm';
  }

  @override
  String get mooringEmptyFiltered =>
      'Try clearing filters or broadening your search.';

  @override
  String get mooringVhf => 'VHF';

  @override
  String get mooringPhone => 'Phone';

  @override
  String get mooringServices => 'Services / attributes';

  @override
  String get mooringNotes => 'Notes';

  @override
  String get mooringReviewTitle => 'Review (offline draft)';

  @override
  String get mooringReviewStars => 'Rating';

  @override
  String get mooringReviewComment => 'Comment (stored locally until sync)';

  @override
  String get mooringReviewSave => 'Save draft';

  @override
  String get mooringReviewQueued =>
      'Review saved in the outbox. Use “Sync reviews” on this tab when online (MVP uses a local acceptor until the server is connected).';

  @override
  String get mooringDetailClose => 'Close';

  @override
  String get mooringEmptyCatalog => 'No mooring POIs loaded.';

  @override
  String get mooringGdprHint =>
      'Comments stay on device until upload; only IDs and ratings go to audit logs.';

  @override
  String get mooringPendingSectionTitle => 'Pending reviews (offline outbox)';

  @override
  String get mooringCatalogSectionTitle => 'Directory';

  @override
  String mooringPendingReviewLine(String placeId, int stars, String time) {
    return '$placeId · $stars ★ · $time';
  }

  @override
  String get mooringEmail => 'Email';

  @override
  String get mooringWebsite => 'Website';

  @override
  String get mooringBook => 'Book berth';

  @override
  String get mooringOpenMap => 'Open map';

  @override
  String get mooringCall => 'Call';

  @override
  String get mooringSyncPending => 'Sync reviews';

  @override
  String mooringSyncDone(int count) {
    return 'Submitted $count review(s).';
  }

  @override
  String mooringSyncFailed(int count) {
    return 'Could not submit some drafts ($count).';
  }

  @override
  String get mooringSearchHint => 'Search by name';

  @override
  String get mooringSearchNoResults => 'Nothing matches your search.';

  @override
  String get mooringSvcElectricity => 'Electricity';

  @override
  String get mooringSvcWater => 'Water';

  @override
  String get mooringSvcWifi => 'Wi‑Fi';

  @override
  String get mooringSvcFuel => 'Fuel';

  @override
  String get mooringSvcProtection => 'Shelter';

  @override
  String get mooringSvcHolding => 'Holding';

  @override
  String get logbookTitle => 'Ship\'s log';

  @override
  String get logbookEmpty =>
      'No log entries yet. Tap + to add fuel, maintenance, or general notes.';

  @override
  String get logbookAddEntry => 'Add entry';

  @override
  String get logbookCategory => 'Category';

  @override
  String get logbookCategoryNote => 'Note / general';

  @override
  String get logbookCategoryFuel => 'Fuel';

  @override
  String get logbookCategoryMaintenance => 'Maintenance';

  @override
  String get logbookCategoryWatch => 'Watch / handover';

  @override
  String get logbookCategoryOther => 'Other';

  @override
  String get logbookEntryTitle => 'Title';

  @override
  String get logbookEntryBody => 'Details';

  @override
  String get logbookSave => 'Save';

  @override
  String get logbookCancel => 'Cancel';

  @override
  String get logbookExportCsv => 'Export CSV';

  @override
  String get logbookExportCopied =>
      'CSV copied to clipboard — paste into a spreadsheet or file.';

  @override
  String get logbookDeleteTitle => 'Delete entry';

  @override
  String get logbookDeleteConfirm => 'Remove this log entry from the device?';

  @override
  String get logbookDelete => 'Delete';

  @override
  String get logbookEntryDeleted => 'Entry deleted.';

  @override
  String get logbookCrewNoDelete =>
      'Only the captain can delete log entries on this device.';

  @override
  String get moreMenuHeadline => 'Safety, log & crew';

  @override
  String get moreMenuLogbook => 'Ship\'s log';

  @override
  String get moreMenuSos => 'SOS / distress';

  @override
  String get moreMenuTrack => 'Track recording';

  @override
  String get moreMenuChecklists => 'Checklists';

  @override
  String get moreMenuVault => 'Document vault';

  @override
  String get moreMenuCrew => 'Crew & ship';

  @override
  String get sosTitle => 'Distress (SOS)';

  @override
  String get sosBody =>
      'Use only in a real emergency. Test mode records a critical audit event and does not open SMS or email.';

  @override
  String get sosTestMode => 'Test mode (no external send)';

  @override
  String get sosVesselName => 'Vessel name';

  @override
  String get sosSmsNumber => 'SMS number (E.164, optional)';

  @override
  String get sosRegionRescue =>
      'Regional rescue (display only, verify locally)';

  @override
  String get sosOpenSettings => 'Open options';

  @override
  String get sosStep1 => 'I understand this is for genuine distress';

  @override
  String get sosStep2 => 'Hold the button to trigger (2s)';

  @override
  String get sosHold => 'HOLD TO ACTIVATE';

  @override
  String get sosAfterTest => 'Test distress recorded. No message was sent.';

  @override
  String get sosAfterLive =>
      'If a number is set, an SMS compose view may open. Add a body if the platform allows.';

  @override
  String get sosNoNumber =>
      'Set an SMS number in the field above, or copy the text from the next dialog.';

  @override
  String get sosCopyMessage => 'Copy message';

  @override
  String get sosMessageCopied => 'Message copied.';

  @override
  String get sosTypeLabel => 'Emergency type';

  @override
  String get sosTypeMedical => 'Medical';

  @override
  String get sosTypeFire => 'Fire';

  @override
  String get sosTypeSinking => 'Sinking';

  @override
  String get sosTypeManOverboard => 'Man overboard';

  @override
  String get sosMessagePreview => 'Message preview';

  @override
  String get sosCoordsPending => 'Acquiring position…';

  @override
  String get sosTimerActive => 'Distress active';

  @override
  String get sosTimerElapsed => 'Elapsed';

  @override
  String get trackTitle => 'Trip track';

  @override
  String get trackRecordingActive => 'Recording…';

  @override
  String get trackIdle => 'Not recording';

  @override
  String get trackStart => 'Start recording';

  @override
  String get trackStop => 'Stop & save';

  @override
  String trackPoints(int count) {
    return '$count points';
  }

  @override
  String get trackStatsPoints => 'Points';

  @override
  String get trackStatsDuration => 'Duration';

  @override
  String get trackEmptyTrips => 'No saved trips';

  @override
  String get trackEmptyTripsMessage =>
      'Stop a recording to save a passage here.';

  @override
  String get checklistsTitle => 'Safety checklists';

  @override
  String get checklistTplDeparture => 'Before departure';

  @override
  String get checklistTplDocking => 'Docking / mooring';

  @override
  String get checklistTplStorm => 'Storm preparation';

  @override
  String get checklistComplete => 'Mark all done';

  @override
  String get checklistCompletedAudit => 'Checklist completed.';

  @override
  String get vaultTitle => 'Document vault';

  @override
  String get vaultPinSetupTitle => 'Create vault PIN';

  @override
  String get vaultPinUnlockTitle => 'Unlock vault';

  @override
  String get vaultPinHint => '4–12 digits recommended';

  @override
  String get vaultPinConfirmLabel => 'Confirm PIN';

  @override
  String get vaultUnlock => 'Unlock';

  @override
  String get vaultLockedHint =>
      'Documents are encrypted at rest with your PIN.';

  @override
  String get vaultEmpty => 'No encrypted files stored yet.';

  @override
  String get vaultPickFile => 'Pick file';

  @override
  String get vaultEncryptedBadge => 'Encrypted';

  @override
  String get vaultDecryptPreview => 'Preview / decrypt check';

  @override
  String get vaultDeleteForbidden => 'Only the captain can delete vault files.';

  @override
  String get crewTitle => 'Crew & ship';

  @override
  String get crewCreateShip => 'Create ship & invite code';

  @override
  String get crewJoinShip => 'Join ship';

  @override
  String get crewInviteExplain =>
      'Share this code so others can join the same ship ID on their device.';

  @override
  String get crewLeave => 'Leave ship';

  @override
  String get crewRoleCaptain => 'Captain';

  @override
  String get crewRoleCrew => 'Crew';

  @override
  String get moreMenuSettings => 'Settings';

  @override
  String get settingsAccessibilitySection => 'Accessibility';

  @override
  String get settingsGloveMode => 'Glove mode';

  @override
  String get settingsGloveModeSubtitle => 'Larger buttons and tap targets';

  @override
  String get settingsTextSize => 'Text size';

  @override
  String get settingsTextSizeStandard => 'Standard';

  @override
  String get settingsTextSizeLarge => 'Large';

  @override
  String get settingsTextSizeExtraLarge => 'Extra large';

  @override
  String get settingsHighContrast => 'High contrast';

  @override
  String get settingsNightWatch => 'Night watch (red)';

  @override
  String get settingsNightWatchSubtitle => 'Red UI to preserve night vision';

  @override
  String get settingsNightWatchChartNightHint =>
      'Tip: Map layers → Chart → Night pairs well with this theme.';

  @override
  String get settingsNightWatchChartDayHint =>
      'Tip: Map layers → Chart → Standard for a daytime chart palette.';

  @override
  String get settingsEnergySection => 'Battery & GPS';

  @override
  String get settingsVesselSection => 'Vessel';

  @override
  String get settingsDisplaySection => 'Display';

  @override
  String get settingsAboutSection => 'About';

  @override
  String get settingsVesselName => 'Vessel name';

  @override
  String settingsVesselLoa(String unit) {
    return 'Length overall ($unit)';
  }

  @override
  String settingsVesselDraft(String unit) {
    return 'Draft ($unit)';
  }

  @override
  String get settingsVesselType => 'Hull type';

  @override
  String get settingsVesselTypeSailing => 'Sailing yacht';

  @override
  String get settingsVesselTypeMotor => 'Motor yacht';

  @override
  String get settingsVesselTypeCatamaran => 'Catamaran';

  @override
  String get settingsVesselTypeOther => 'Other';

  @override
  String get settingsUnits => 'Units';

  @override
  String get settingsUnitsMetric => 'Metric';

  @override
  String get settingsUnitsImperial => 'Imperial';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeDeck => 'Deck';

  @override
  String get settingsThemeNightRed => 'Night red';

  @override
  String get settingsThemeHighContrast => 'High contrast';

  @override
  String get settingsAboutAppName => 'Captain Wrongel';

  @override
  String settingsAboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String get settingsAboutTagline =>
      'Offline-first yacht navigator. Not for primary navigation.';

  @override
  String get energyProfileEco => 'Eco passage';

  @override
  String get energyProfilePassage => 'Balanced';

  @override
  String get energyProfileSport => 'Precision';

  @override
  String get energyProfileEcoDescription =>
      'Fewer GPS fixes while recording and lighter map work when the app is backgrounded.';

  @override
  String get energyProfilePassageDescription =>
      'Default balance for coastal sailing.';

  @override
  String get energyProfileSportDescription =>
      'More frequent track points and faster AIS demo updates.';

  @override
  String get moreMenuKnots => 'Knot guide';

  @override
  String get knotsTitle => 'Maritime knots';

  @override
  String get knotsSearchHint => 'Search knots';

  @override
  String get knotsLoadError => 'Could not load knot catalog.';

  @override
  String get knotsEmpty => 'The knot catalog is empty.';

  @override
  String get knotsNoMatch => 'No knots match your search.';

  @override
  String get knotStepsHeading => 'Steps';

  @override
  String get knotCategoryLoops => 'Loops';

  @override
  String get knotCategoryBends => 'Bends';

  @override
  String get knotCategoryHitches => 'Hitches';

  @override
  String get knotCategoryStoppers => 'Stoppers';

  @override
  String get knotCategoryEmergency => 'Emergency';

  @override
  String get knotCategoryAll => 'All';

  @override
  String get knotCategoryFavorites => 'Favorites';

  @override
  String get knotDifficultyEasy => 'Easy';

  @override
  String get knotDifficultyMedium => 'Medium';

  @override
  String get knotDifficultyHard => 'Hard';

  @override
  String get knotAddFavorite => 'Add to favorites';

  @override
  String get knotRemoveFavorite => 'Remove from favorites';

  @override
  String get moreMenuToolbox => 'Maritime toolbox';

  @override
  String get moreMenuToolboxSubtitle =>
      'Anchor, compass, GRIB, shore, radio, medical, expenses…';

  @override
  String get toolboxTitle => 'Maritime toolbox';

  @override
  String get toolboxLead =>
      'Training and safety utilities; not a substitute for certified equipment or medical care.';

  @override
  String get toolboxAnchorWatch => 'Anchor watch';

  @override
  String get toolboxCompass => 'Compass & sun times';

  @override
  String get toolboxGrib => 'GRIB files (import)';

  @override
  String get toolboxCoastal => 'Coastal guide (POI)';

  @override
  String get toolboxVhf => 'VHF & COLREG trainer';

  @override
  String get toolboxMedical => 'Medical glossary';

  @override
  String get toolboxExpenses => 'Voyager cashbook';

  @override
  String get toolboxSectionNavigation => 'Navigation';

  @override
  String get toolboxSectionSafety => 'Safety';

  @override
  String get toolboxSectionReference => 'Reference';

  @override
  String get badgeNew => 'NEW';

  @override
  String get anchorWatchTitle => 'Anchor watch';

  @override
  String get anchorWatchHint =>
      'Drop anchor when moored, set radius, then arm. Alarm if position drifts beyond the circle. For professional ground tackle use your own judgment.';

  @override
  String get anchorWatchRadius => 'Allowed radius';

  @override
  String get anchorWatchDistance => 'Distance to anchor';

  @override
  String get anchorWatchDrop => 'Mark anchor position (GPS)';

  @override
  String get anchorWatchArm => 'Arm watch';

  @override
  String get anchorWatchDisarm => 'Disarm';

  @override
  String get anchorWatchClear => 'Clear anchor position';

  @override
  String get anchorWatchAlarmBanner => 'VESSEL MOVED OUTSIDE ANCHOR CIRCLE';

  @override
  String get anchorWatchDismissAlarm => 'Acknowledge';

  @override
  String get anchorWatchGpsLost =>
      'No recent GPS fix — verify receiver and sky view.';

  @override
  String get anchorWatchMapPlaceholder =>
      'Mark anchor position to show zone map';

  @override
  String get anchorWatchInZone => 'IN ZONE';

  @override
  String get anchorWatchDrifting => 'DRIFTING';

  @override
  String get anchorWatchDisarmed => 'Disarmed';

  @override
  String get anchorWatchArmedBadge => 'ARMED';

  @override
  String get compassTitle => 'Compass & sun';

  @override
  String get compassDisclaimer =>
      'Magnetic compass uses device sensors; solar times are approximate.';

  @override
  String get compassUnavailablePlatform =>
      'Compass stream is unavailable on this platform.';

  @override
  String get compassHeadingLabel => 'Heading (magnetic variation not applied)';

  @override
  String get astroSectionTitle =>
      'Approximate sunrise / sunset (UTC converted to local)';

  @override
  String get astroNeedGps => 'Need a GPS fix to estimate sun times.';

  @override
  String get astroSunrise => 'Sunrise';

  @override
  String get astroSunset => 'Sunset';

  @override
  String get gribTitle => 'GRIB import';

  @override
  String get gribStubBody =>
      'Decoder for GRIB (wgrib/ecCodes style) is not bundled yet. You can park a file path for future offline viewers.';

  @override
  String get gribLastPath => 'Last stub path';

  @override
  String get gribSimulatePick => 'Simulate picking a GRIB file';

  @override
  String get gribStubSaved => 'Stub path saved locally.';

  @override
  String get gribEmpty => 'No GRIB files imported yet.';

  @override
  String get gribImport => 'Import GRIB file';

  @override
  String get gribStatusPending => 'Pending decode';

  @override
  String get coastalGuideTitle => 'Coastal POI';

  @override
  String get coastalLoadError => 'Could not load coastal POIs.';

  @override
  String get coastalEmpty => 'No coastal POIs.';

  @override
  String get coastalSearchHint => 'Search shore POIs';

  @override
  String get coastalNoMatch => 'No POIs match your filters.';

  @override
  String get coastalCategoryAll => 'All';

  @override
  String get coastalCategoryBeach => 'Beach';

  @override
  String get coastalCategoryFuel => 'Fuel';

  @override
  String get coastalCategoryMarina => 'Marina';

  @override
  String get coastalCategoryRestaurant => 'Restaurant';

  @override
  String get coastalCategoryAttraction => 'Attraction';

  @override
  String get coastalCategoryOther => 'Other';

  @override
  String coastalCoordinates(String lat, String lon) {
    return '$lat°, $lon°';
  }

  @override
  String get medicalGlossaryTitle => 'Medical glossary';

  @override
  String get medicalDisclaimer =>
      'Educational snippets only — call emergency services when needed.';

  @override
  String get medicalLoadError => 'Could not load medical glossary.';

  @override
  String get vhfTrainingTitle => 'VHF & COLREG';

  @override
  String get vhfTabScenarios => 'Scenarios';

  @override
  String get vhfTabQuiz => 'COLREG quiz';

  @override
  String get vhfTabSessions => 'Recordings';

  @override
  String get vhfScenariosLoadError => 'Could not load VHF scenarios.';

  @override
  String get vhfScenariosEmpty => 'No VHF scenarios available.';

  @override
  String get vhfScenarioPickHint => 'Pick a scenario to practice radio calls.';

  @override
  String get vhfScenarioBack => 'All scenarios';

  @override
  String get vhfDifficultyBeginner => 'Beginner';

  @override
  String get vhfDifficultyIntermediate => 'Intermediate';

  @override
  String get vhfDifficultyAdvanced => 'Advanced';

  @override
  String get vhfDialogueShore => 'Shore';

  @override
  String get vhfDialogueYou => 'You';

  @override
  String vhfQuizProgress(int current, int total) {
    return 'Question $current of $total';
  }

  @override
  String get vhfQuizPickAnswer => 'Select an answer first.';

  @override
  String get vhfSessionsHint =>
      'Recordings stay on this device. Transcription uses the microphone (paraphrase), not offline file decoding.';

  @override
  String get vhfSessionsLoadError => 'Could not load recordings list.';

  @override
  String get vhfSessionsEmpty => 'No VHF recordings yet.';

  @override
  String get vhfRecordStart => 'Record';

  @override
  String get vhfRecordStop => 'Stop';

  @override
  String get vhfRecordWebUnsupported =>
      'Recording is not supported in the web build.';

  @override
  String get vhfTranscribeHint =>
      'Tap the mic: speak a short summary to store as text. For full verbatim from the audio file use a desktop tool with a GRIB/audio pipeline (post-MVP).';

  @override
  String get vhfTranscribeDone => 'Transcript saved.';

  @override
  String get vhfQuizLoadError => 'Could not load quiz.';

  @override
  String get vhfQuizEmpty => 'No quiz questions.';

  @override
  String get vhfQuizWrong => 'Not quite — review COLREG.';

  @override
  String get vhfQuizPrev => 'Previous';

  @override
  String get vhfQuizNext => 'Next';

  @override
  String get vhfQuizDone => 'Finish';

  @override
  String get vhfQuizComplete => 'Last question answered.';

  @override
  String get expensesTitle => 'Voyager cashbook';

  @override
  String get expensesDisclaimer =>
      'Totals are stored only on device — no shore sync in MVP.';

  @override
  String get expensesLoadError => 'Could not load expenses.';

  @override
  String get expenseAdd => 'Add expense';

  @override
  String get expenseSave => 'Save';

  @override
  String get expenseAmount => 'Amount';

  @override
  String get expenseNote => 'Note';

  @override
  String get expenseEmpty => 'No expenses logged.';

  @override
  String get expenseSummaryTitle => 'Trip total';

  @override
  String get expenseCatFuel => 'Fuel';

  @override
  String get expenseCatFood => 'Food';

  @override
  String get expenseCatMarina => 'Marina fees';

  @override
  String get expenseCatMooringFee => 'Mooring';

  @override
  String get expenseCatGear => 'Gear & repairs';

  @override
  String get expenseCatProvisions => 'Provisions';

  @override
  String get expenseCatOther => 'Other';

  @override
  String get onboardingWelcomeTagline => 'Captain Wrongel';

  @override
  String get onboardingWelcomeTitle => 'Your crewmate on every voyage';

  @override
  String get onboardingWelcomeSubtitle =>
      'Offline charts, weather, moorings — one deck.';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingBack => 'Back';

  @override
  String get onboardingGetStarted => 'Get started';

  @override
  String get onboardingPermissionsTitle => 'Enable permissions';

  @override
  String get onboardingPermissionsBody =>
      'Location powers charts, weather, and anchor watch. Notifications alert you to drift and weather changes.';

  @override
  String get onboardingLocationTitle => 'Location';

  @override
  String get onboardingLocationButton => 'Allow location';

  @override
  String get onboardingNotificationTitle => 'Notifications';

  @override
  String get onboardingNotificationButton => 'Allow notifications';

  @override
  String get onboardingExperienceTitle => 'Your experience';

  @override
  String get onboardingExperienceBody =>
      'We\'ll tune tips and defaults to match your sailing style.';

  @override
  String get onboardingExperienceBeginner => 'Beginner';

  @override
  String get onboardingExperienceCruiser => 'Cruiser';

  @override
  String get onboardingExperienceRacer => 'Racer';

  @override
  String get onboardingRegionTitle => 'Where do you sail?';

  @override
  String get onboardingRegionBody =>
      'We prioritize charts and mooring data for your region.';

  @override
  String get onboardingRegionMediterranean => 'Mediterranean';

  @override
  String get onboardingRegionCaribbean => 'Caribbean';

  @override
  String get onboardingRegionOther => 'Other';
}
