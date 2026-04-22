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

  @override
  String get mooringScreenTitle => 'Marinas & anchorages';

  @override
  String get mooringKindMarina => 'Marina';

  @override
  String get mooringKindAnchorage => 'Anchorage';

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
  String get vaultUnlock => 'Unlock';

  @override
  String get vaultLockedHint =>
      'Documents are encrypted at rest with your PIN.';

  @override
  String get vaultEmpty => 'No encrypted files stored yet.';

  @override
  String get vaultPickFile => 'Pick file';

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
  String get settingsEnergySection => 'Battery & GPS';

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
  String get coastalGuideTitle => 'Coastal POI';

  @override
  String get coastalLoadError => 'Could not load coastal POIs.';

  @override
  String get coastalEmpty => 'No coastal POIs.';

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
  String get vhfTabQuiz => 'COLREG quiz';

  @override
  String get vhfTabSessions => 'Recordings';

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
}
