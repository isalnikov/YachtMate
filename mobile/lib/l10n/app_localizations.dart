import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('ru'),
  ];

  /// Application name shown in UI and task switcher.
  ///
  /// In en, this message translates to:
  /// **'Captain Wrongel'**
  String get appTitle;

  /// No description provided for @tabMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get tabMap;

  /// No description provided for @tabRoute.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get tabRoute;

  /// No description provided for @tabWeather.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get tabWeather;

  /// No description provided for @tabMooring.
  ///
  /// In en, this message translates to:
  /// **'Mooring'**
  String get tabMooring;

  /// No description provided for @tabMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get tabMore;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @languageSwitchTooltip.
  ///
  /// In en, this message translates to:
  /// **'Choose interface language'**
  String get languageSwitchTooltip;

  /// No description provided for @localeEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get localeEnglish;

  /// No description provided for @localeRussian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get localeRussian;

  /// No description provided for @localeGerman.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get localeGerman;

  /// No description provided for @localeFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get localeFrench;

  /// No description provided for @localeSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get localeSpanish;

  /// No description provided for @localeItalian.
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get localeItalian;

  /// No description provided for @bootstrapNote.
  ///
  /// In en, this message translates to:
  /// **'Phase 0 shell — navigation and charts follow in Phase 1.'**
  String get bootstrapNote;

  /// No description provided for @mapUnavailableOnPlatform.
  ///
  /// In en, this message translates to:
  /// **'Raster/vector charts run on Android, iOS, or web. Linux desktop shows this placeholder.'**
  String get mapUnavailableOnPlatform;

  /// No description provided for @mapLoadingStyle.
  ///
  /// In en, this message translates to:
  /// **'Loading chart style…'**
  String get mapLoadingStyle;

  /// No description provided for @disclaimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Navigation notice'**
  String get disclaimerTitle;

  /// No description provided for @disclaimerP1.
  ///
  /// In en, this message translates to:
  /// **'Captain Wrongel is not an ECDIS, radar, or official nautical chart system. Charts and GPS may be inaccurate or outdated.'**
  String get disclaimerP1;

  /// No description provided for @disclaimerP2.
  ///
  /// In en, this message translates to:
  /// **'You alone are responsible for safe navigation, collision avoidance (COLREG), and verifying all information against official publications.'**
  String get disclaimerP2;

  /// No description provided for @disclaimerAccept.
  ///
  /// In en, this message translates to:
  /// **'I understand — continue'**
  String get disclaimerAccept;

  /// No description provided for @offlineCacheStart.
  ///
  /// In en, this message translates to:
  /// **'Downloading tiles for the visible region…'**
  String get offlineCacheStart;

  /// No description provided for @offlineCacheDone.
  ///
  /// In en, this message translates to:
  /// **'Offline region saved'**
  String get offlineCacheDone;

  /// No description provided for @offlineCacheFail.
  ///
  /// In en, this message translates to:
  /// **'Could not cache offline tiles (network or engine).'**
  String get offlineCacheFail;

  /// No description provided for @mapLayersTooltip.
  ///
  /// In en, this message translates to:
  /// **'Map layers'**
  String get mapLayersTooltip;

  /// No description provided for @mapLayersSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Map layers (demo)'**
  String get mapLayersSheetTitle;

  /// No description provided for @mapLayerDepthContours.
  ///
  /// In en, this message translates to:
  /// **'Depth contours (synthetic)'**
  String get mapLayerDepthContours;

  /// No description provided for @mapLayerNavAids.
  ///
  /// In en, this message translates to:
  /// **'Navigation marks (synthetic)'**
  String get mapLayerNavAids;

  /// No description provided for @mapLayerMooringPois.
  ///
  /// In en, this message translates to:
  /// **'Marinas & anchorages (catalog)'**
  String get mapLayerMooringPois;

  /// No description provided for @mapLayerSectionOverlays.
  ///
  /// In en, this message translates to:
  /// **'Overlays'**
  String get mapLayerSectionOverlays;

  /// No description provided for @mapLayerSectionChart.
  ///
  /// In en, this message translates to:
  /// **'Chart'**
  String get mapLayerSectionChart;

  /// No description provided for @mapLayerSectionShallow.
  ///
  /// In en, this message translates to:
  /// **'Shallow'**
  String get mapLayerSectionShallow;

  /// No description provided for @mapLayerOverlayNone.
  ///
  /// In en, this message translates to:
  /// **'No Overlay'**
  String get mapLayerOverlayNone;

  /// No description provided for @mapLayerOverlaySatellite.
  ///
  /// In en, this message translates to:
  /// **'Satellite'**
  String get mapLayerOverlaySatellite;

  /// No description provided for @mapLayerOverlayRelief.
  ///
  /// In en, this message translates to:
  /// **'Relief Shading'**
  String get mapLayerOverlayRelief;

  /// No description provided for @mapLayerOverlaySonar.
  ///
  /// In en, this message translates to:
  /// **'Sonar'**
  String get mapLayerOverlaySonar;

  /// No description provided for @mapLayerChartStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get mapLayerChartStandard;

  /// No description provided for @mapLayerChartPaper.
  ///
  /// In en, this message translates to:
  /// **'Paper'**
  String get mapLayerChartPaper;

  /// No description provided for @mapLayerChartSimple.
  ///
  /// In en, this message translates to:
  /// **'Simple'**
  String get mapLayerChartSimple;

  /// No description provided for @mapLayerChartNight.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get mapLayerChartNight;

  /// No description provided for @mapLayerShallowHighlight.
  ///
  /// In en, this message translates to:
  /// **'Shallow highlight'**
  String get mapLayerShallowHighlight;

  /// No description provided for @mapDepthLegendTitle.
  ///
  /// In en, this message translates to:
  /// **'Legend'**
  String get mapDepthLegendTitle;

  /// No description provided for @mapDepthLegendBody.
  ///
  /// In en, this message translates to:
  /// **'Blue lines: EMODnet Bathymetry contours (example region: Fethiye, Turkey). Single display color — depth values drive routing grid only. Not official charts.'**
  String get mapDepthLegendBody;

  /// No description provided for @mapLongPressTitle.
  ///
  /// In en, this message translates to:
  /// **'Position (WGS84)'**
  String get mapLongPressTitle;

  /// No description provided for @mapLongPressLatitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get mapLongPressLatitude;

  /// No description provided for @mapLongPressLongitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get mapLongPressLongitude;

  /// No description provided for @mapLongPressDepth.
  ///
  /// In en, this message translates to:
  /// **'Depth (demo)'**
  String get mapLongPressDepth;

  /// No description provided for @mapLongPressDepthUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No contour within range — enable the layer or move closer.'**
  String get mapLongPressDepthUnavailable;

  /// No description provided for @mapLongPressNavAid.
  ///
  /// In en, this message translates to:
  /// **'Nearest mark'**
  String get mapLongPressNavAid;

  /// No description provided for @mapLongPressNavUnavailable.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get mapLongPressNavUnavailable;

  /// No description provided for @mapLongPressAddWaypoint.
  ///
  /// In en, this message translates to:
  /// **'Add route waypoint'**
  String get mapLongPressAddWaypoint;

  /// No description provided for @mapNavigateHere.
  ///
  /// In en, this message translates to:
  /// **'Navigate here'**
  String get mapNavigateHere;

  /// No description provided for @mapCoordsCopied.
  ///
  /// In en, this message translates to:
  /// **'Coordinates copied'**
  String get mapCoordsCopied;

  /// No description provided for @mapPeekCoordsSemantic.
  ///
  /// In en, this message translates to:
  /// **'Map center coordinates — tap to copy'**
  String get mapPeekCoordsSemantic;

  /// No description provided for @mapPeekDepthMeters.
  ///
  /// In en, this message translates to:
  /// **'Depth: {meters} m'**
  String mapPeekDepthMeters(int meters);

  /// No description provided for @mapAisDemoTooltip.
  ///
  /// In en, this message translates to:
  /// **'AIS demo stream (recorded NMEA)'**
  String get mapAisDemoTooltip;

  /// No description provided for @aisScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'AIS'**
  String get aisScreenTitle;

  /// No description provided for @moreMenuAis.
  ///
  /// In en, this message translates to:
  /// **'AIS traffic'**
  String get moreMenuAis;

  /// No description provided for @moreMenuAisSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Local NMEA · CPA/TCPA · vessel filters'**
  String get moreMenuAisSubtitle;

  /// No description provided for @aisFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get aisFilterAll;

  /// No description provided for @aisFilterCargo.
  ///
  /// In en, this message translates to:
  /// **'Cargo'**
  String get aisFilterCargo;

  /// No description provided for @aisFilterTanker.
  ///
  /// In en, this message translates to:
  /// **'Tanker'**
  String get aisFilterTanker;

  /// No description provided for @aisFilterPleasure.
  ///
  /// In en, this message translates to:
  /// **'Pleasure'**
  String get aisFilterPleasure;

  /// No description provided for @aisLocalStreamTitle.
  ///
  /// In en, this message translates to:
  /// **'Local stream'**
  String get aisLocalStreamTitle;

  /// No description provided for @aisLocalStreamBody.
  ///
  /// In en, this message translates to:
  /// **'NMEA 0183 · Wi‑Fi/BT gateway · CPA/TCPA'**
  String get aisLocalStreamBody;

  /// No description provided for @aisDemoStart.
  ///
  /// In en, this message translates to:
  /// **'Start demo'**
  String get aisDemoStart;

  /// No description provided for @aisDemoStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get aisDemoStop;

  /// No description provided for @aisDemoActive.
  ///
  /// In en, this message translates to:
  /// **'Demo NMEA stream active'**
  String get aisDemoActive;

  /// No description provided for @aisTargetsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} targets'**
  String aisTargetsCount(int count);

  /// No description provided for @aisTapVessel.
  ///
  /// In en, this message translates to:
  /// **'Tap a vessel for details'**
  String get aisTapVessel;

  /// No description provided for @aisVesselSog.
  ///
  /// In en, this message translates to:
  /// **'{knots} kn'**
  String aisVesselSog(String knots);

  /// No description provided for @aisVesselCog.
  ///
  /// In en, this message translates to:
  /// **'{degrees}°'**
  String aisVesselCog(String degrees);

  /// No description provided for @aisVesselCpa.
  ///
  /// In en, this message translates to:
  /// **'{nm} nm'**
  String aisVesselCpa(String nm);

  /// No description provided for @aisVesselTcpa.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String aisVesselTcpa(String minutes);

  /// No description provided for @aisCpaWarning.
  ///
  /// In en, this message translates to:
  /// **'CPA < 1 nm'**
  String get aisCpaWarning;

  /// No description provided for @mapZoomInTooltip.
  ///
  /// In en, this message translates to:
  /// **'Zoom in'**
  String get mapZoomInTooltip;

  /// No description provided for @mapZoomOutTooltip.
  ///
  /// In en, this message translates to:
  /// **'Zoom out'**
  String get mapZoomOutTooltip;

  /// No description provided for @mapCompassNorthUpTooltip.
  ///
  /// In en, this message translates to:
  /// **'North up — tap for heading up'**
  String get mapCompassNorthUpTooltip;

  /// No description provided for @mapCompassHeadingUpTooltip.
  ///
  /// In en, this message translates to:
  /// **'Heading up — tap for north up'**
  String get mapCompassHeadingUpTooltip;

  /// No description provided for @mapFollowGpsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Follow GPS'**
  String get mapFollowGpsTooltip;

  /// No description provided for @mapFollowGpsActiveTooltip.
  ///
  /// In en, this message translates to:
  /// **'Following GPS — tap to stop'**
  String get mapFollowGpsActiveTooltip;

  /// No description provided for @mapGpsStatusSemantic.
  ///
  /// In en, this message translates to:
  /// **'GPS status — tap for location settings'**
  String get mapGpsStatusSemantic;

  /// No description provided for @mapGpsAccuracyMeters.
  ///
  /// In en, this message translates to:
  /// **'±{meters} m'**
  String mapGpsAccuracyMeters(int meters);

  /// No description provided for @mapGpsSogKnots.
  ///
  /// In en, this message translates to:
  /// **'{knots} kn'**
  String mapGpsSogKnots(String knots);

  /// No description provided for @mapGpsLocationSettingsHint.
  ///
  /// In en, this message translates to:
  /// **'Check location permission and GPS accuracy in system settings.'**
  String get mapGpsLocationSettingsHint;

  /// No description provided for @weatherScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Weather & tides'**
  String get weatherScreenTitle;

  /// No description provided for @weatherRefreshTooltip.
  ///
  /// In en, this message translates to:
  /// **'Refresh forecast'**
  String get weatherRefreshTooltip;

  /// No description provided for @weatherGpsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Use GPS for forecast location'**
  String get weatherGpsTooltip;

  /// No description provided for @weatherStaleBanner.
  ///
  /// In en, this message translates to:
  /// **'Showing cached forecast — network or API unavailable.'**
  String get weatherStaleBanner;

  /// No description provided for @weatherCoordinates.
  ///
  /// In en, this message translates to:
  /// **'Forecast pin: {lat}°, {lon}°'**
  String weatherCoordinates(String lat, String lon);

  /// No description provided for @weatherLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Model run reference: {time}'**
  String weatherLastUpdated(String time);

  /// No description provided for @weatherLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load forecast: {detail}'**
  String weatherLoadError(String detail);

  /// No description provided for @weatherHourlyHeading.
  ///
  /// In en, this message translates to:
  /// **'Hourly (48 h)'**
  String get weatherHourlyHeading;

  /// No description provided for @weatherLayerWindTooltip.
  ///
  /// In en, this message translates to:
  /// **'Wind layer'**
  String get weatherLayerWindTooltip;

  /// No description provided for @weatherLayerWavesTooltip.
  ///
  /// In en, this message translates to:
  /// **'Wave layer'**
  String get weatherLayerWavesTooltip;

  /// No description provided for @weatherLayerTempTooltip.
  ///
  /// In en, this message translates to:
  /// **'Temperature layer'**
  String get weatherLayerTempTooltip;

  /// No description provided for @weatherLayerPressureTooltip.
  ///
  /// In en, this message translates to:
  /// **'Pressure layer'**
  String get weatherLayerPressureTooltip;

  /// No description provided for @weatherTidesSection.
  ///
  /// In en, this message translates to:
  /// **'Tides (demo)'**
  String get weatherTidesSection;

  /// No description provided for @weatherRefreshing.
  ///
  /// In en, this message translates to:
  /// **'Refreshing…'**
  String get weatherRefreshing;

  /// No description provided for @weatherGpsDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied.'**
  String get weatherGpsDenied;

  /// No description provided for @weatherGpsUpdated.
  ///
  /// In en, this message translates to:
  /// **'Forecast uses your GPS position.'**
  String get weatherGpsUpdated;

  /// No description provided for @weatherGpsError.
  ///
  /// In en, this message translates to:
  /// **'GPS error: {detail}'**
  String weatherGpsError(String detail);

  /// No description provided for @tidesHigh.
  ///
  /// In en, this message translates to:
  /// **'High water'**
  String get tidesHigh;

  /// No description provided for @tidesLow.
  ///
  /// In en, this message translates to:
  /// **'Low water'**
  String get tidesLow;

  /// No description provided for @weatherWaveSuffix.
  ///
  /// In en, this message translates to:
  /// **' · wave {m} m'**
  String weatherWaveSuffix(String m);

  /// No description provided for @weatherHourLine.
  ///
  /// In en, this message translates to:
  /// **'{tempC} °C · wind {windKn} kn / {windDir}° · rain {rainMm} mm · {pressHpa} hPa{wavePart}'**
  String weatherHourLine(
    String tempC,
    String windKn,
    String windDir,
    String rainMm,
    String pressHpa,
    String wavePart,
  );

  /// No description provided for @weatherTideRow.
  ///
  /// In en, this message translates to:
  /// **'{time} · {height} · {kind}'**
  String weatherTideRow(String time, String height, String kind);

  /// No description provided for @weatherSeeAllTides.
  ///
  /// In en, this message translates to:
  /// **'See all tides'**
  String get weatherSeeAllTides;

  /// No description provided for @tidesScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Tides'**
  String get tidesScreenTitle;

  /// No description provided for @tidesCurveHeading.
  ///
  /// In en, this message translates to:
  /// **'Today\'s curve (demo)'**
  String get tidesCurveHeading;

  /// No description provided for @tidesTableHeading.
  ///
  /// In en, this message translates to:
  /// **'7-day schedule (demo)'**
  String get tidesTableHeading;

  /// No description provided for @tidesMoonHeading.
  ///
  /// In en, this message translates to:
  /// **'Moon phase'**
  String get tidesMoonHeading;

  /// No description provided for @tidesSunHeading.
  ///
  /// In en, this message translates to:
  /// **'Sun times (approx.)'**
  String get tidesSunHeading;

  /// No description provided for @tidesTableDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get tidesTableDay;

  /// No description provided for @tidesHighShort.
  ///
  /// In en, this message translates to:
  /// **'HW'**
  String get tidesHighShort;

  /// No description provided for @tidesLowShort.
  ///
  /// In en, this message translates to:
  /// **'LW'**
  String get tidesLowShort;

  /// No description provided for @tidesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No tide data available.'**
  String get tidesEmpty;

  /// No description provided for @tidesHeightM.
  ///
  /// In en, this message translates to:
  /// **'{height} m'**
  String tidesHeightM(String height);

  /// No description provided for @tidesTableCell.
  ///
  /// In en, this message translates to:
  /// **'{time} · {height} · {kind}'**
  String tidesTableCell(String time, String height, String kind);

  /// No description provided for @tidesSunLine.
  ///
  /// In en, this message translates to:
  /// **'Sunrise {sunrise} · Sunset {sunset}'**
  String tidesSunLine(String sunrise, String sunset);

  /// No description provided for @moreMenuTides.
  ///
  /// In en, this message translates to:
  /// **'Tides'**
  String get moreMenuTides;

  /// No description provided for @moreMenuTidesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Demo curve, 7-day table, moon & sun'**
  String get moreMenuTidesSubtitle;

  /// No description provided for @routeScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Route (advisory)'**
  String get routeScreenTitle;

  /// No description provided for @routeAdvisoryDisclaimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Advisory routing (synthetic)'**
  String get routeAdvisoryDisclaimerTitle;

  /// No description provided for @routeAdvisoryDisclaimerBody.
  ///
  /// In en, this message translates to:
  /// **'The path is computed on a demo depth grid, not an official chart. It is for orientation only; you are responsible for safe navigation and depth under keel.'**
  String get routeAdvisoryDisclaimerBody;

  /// No description provided for @routeAdvisoryDisclaimerAccept.
  ///
  /// In en, this message translates to:
  /// **'I understand'**
  String get routeAdvisoryDisclaimerAccept;

  /// No description provided for @routeActiveRouteLabel.
  ///
  /// In en, this message translates to:
  /// **'Current draft: {id}'**
  String routeActiveRouteLabel(String id);

  /// No description provided for @routeActiveRouteUnknown.
  ///
  /// In en, this message translates to:
  /// **'none'**
  String get routeActiveRouteUnknown;

  /// No description provided for @routeShipDraftM.
  ///
  /// In en, this message translates to:
  /// **'Draft (m)'**
  String get routeShipDraftM;

  /// No description provided for @routeShipClearanceM.
  ///
  /// In en, this message translates to:
  /// **'Under-keel clearance (m)'**
  String get routeShipClearanceM;

  /// No description provided for @routeComputeAdvisory.
  ///
  /// In en, this message translates to:
  /// **'Compute advisory path'**
  String get routeComputeAdvisory;

  /// No description provided for @routeClearAdvisory.
  ///
  /// In en, this message translates to:
  /// **'Clear path'**
  String get routeClearAdvisory;

  /// No description provided for @routeSyntheticNote.
  ///
  /// In en, this message translates to:
  /// **'Depth grid samples the same synthetic contour GeoJSON as the map layer — not official survey data.'**
  String get routeSyntheticNote;

  /// No description provided for @routeAdvisoryChartLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load demo chart contours for routing.'**
  String get routeAdvisoryChartLoadFailed;

  /// No description provided for @routeAdvisoryNoRoute.
  ///
  /// In en, this message translates to:
  /// **'No saved route yet. Add waypoints on the map.'**
  String get routeAdvisoryNoRoute;

  /// No description provided for @routeAdvisoryNeedTwoPoints.
  ///
  /// In en, this message translates to:
  /// **'Need at least two waypoints (start and end).'**
  String get routeAdvisoryNeedTwoPoints;

  /// No description provided for @routeAdvisoryComputed.
  ///
  /// In en, this message translates to:
  /// **'Advisory polyline drawn on the map.'**
  String get routeAdvisoryComputed;

  /// No description provided for @routeAdvisoryFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not compute path: {reason}'**
  String routeAdvisoryFailed(String reason);

  /// No description provided for @routePlanRoute.
  ///
  /// In en, this message translates to:
  /// **'Plan route'**
  String get routePlanRoute;

  /// No description provided for @routeStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Route summary'**
  String get routeStatsTitle;

  /// No description provided for @routeStatsDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get routeStatsDistance;

  /// No description provided for @routeStatsEta.
  ///
  /// In en, this message translates to:
  /// **'ETA'**
  String get routeStatsEta;

  /// No description provided for @routeStatsWaypointCount.
  ///
  /// In en, this message translates to:
  /// **'WPs'**
  String get routeStatsWaypointCount;

  /// No description provided for @routeStatsDistanceValue.
  ///
  /// In en, this message translates to:
  /// **'{nm} nm'**
  String routeStatsDistanceValue(String nm);

  /// No description provided for @routeStatsEtaUnknown.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get routeStatsEtaUnknown;

  /// No description provided for @routeStatsEtaMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String routeStatsEtaMinutes(int minutes);

  /// No description provided for @routeStatsEtaHours.
  ///
  /// In en, this message translates to:
  /// **'{hours} h'**
  String routeStatsEtaHours(int hours);

  /// No description provided for @routeStatsEtaHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} min'**
  String routeStatsEtaHoursMinutes(int hours, int minutes);

  /// No description provided for @routeStatsWaypointCountValue.
  ///
  /// In en, this message translates to:
  /// **'{count}'**
  String routeStatsWaypointCountValue(int count);

  /// No description provided for @routeWaypointListTitle.
  ///
  /// In en, this message translates to:
  /// **'Waypoints'**
  String get routeWaypointListTitle;

  /// No description provided for @routeWaypointEmpty.
  ///
  /// In en, this message translates to:
  /// **'No waypoints yet. Add points on the map.'**
  String get routeWaypointEmpty;

  /// No description provided for @routeWaypointDefaultName.
  ///
  /// In en, this message translates to:
  /// **'WP {index}'**
  String routeWaypointDefaultName(int index);

  /// No description provided for @routeSafetyOk.
  ///
  /// In en, this message translates to:
  /// **'Depth check OK along waypoints (demo grid).'**
  String get routeSafetyOk;

  /// No description provided for @routeSafetyShallow.
  ///
  /// In en, this message translates to:
  /// **'Shallow water at WP {index}: draft + clearance exceeds demo depth.'**
  String routeSafetyShallow(int index);

  /// No description provided for @routeShowCorridor.
  ///
  /// In en, this message translates to:
  /// **'Safety corridor'**
  String get routeShowCorridor;

  /// No description provided for @routeShowCorridorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Green ±50 m buffer around the route on the map'**
  String get routeShowCorridorSubtitle;

  /// No description provided for @mooringScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Marinas & anchorages'**
  String get mooringScreenTitle;

  /// No description provided for @mooringKindMarina.
  ///
  /// In en, this message translates to:
  /// **'Marina'**
  String get mooringKindMarina;

  /// No description provided for @mooringKindAnchorage.
  ///
  /// In en, this message translates to:
  /// **'Anchorage'**
  String get mooringKindAnchorage;

  /// No description provided for @mooringKindBuoy.
  ///
  /// In en, this message translates to:
  /// **'Mooring buoy'**
  String get mooringKindBuoy;

  /// No description provided for @mooringViewList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get mooringViewList;

  /// No description provided for @mooringSortDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get mooringSortDistance;

  /// No description provided for @mooringSortRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get mooringSortRating;

  /// No description provided for @mooringDepthUnknown.
  ///
  /// In en, this message translates to:
  /// **'Depth n/a'**
  String get mooringDepthUnknown;

  /// No description provided for @mooringDistanceNm.
  ///
  /// In en, this message translates to:
  /// **'{distance} nm'**
  String mooringDistanceNm(String distance);

  /// No description provided for @mooringEmptyFiltered.
  ///
  /// In en, this message translates to:
  /// **'Try clearing filters or broadening your search.'**
  String get mooringEmptyFiltered;

  /// No description provided for @mooringVhf.
  ///
  /// In en, this message translates to:
  /// **'VHF'**
  String get mooringVhf;

  /// No description provided for @mooringPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get mooringPhone;

  /// No description provided for @mooringServices.
  ///
  /// In en, this message translates to:
  /// **'Services / attributes'**
  String get mooringServices;

  /// No description provided for @mooringNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get mooringNotes;

  /// No description provided for @mooringReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review (offline draft)'**
  String get mooringReviewTitle;

  /// No description provided for @mooringReviewStars.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get mooringReviewStars;

  /// No description provided for @mooringReviewComment.
  ///
  /// In en, this message translates to:
  /// **'Comment (stored locally until sync)'**
  String get mooringReviewComment;

  /// No description provided for @mooringReviewSave.
  ///
  /// In en, this message translates to:
  /// **'Save draft'**
  String get mooringReviewSave;

  /// No description provided for @mooringReviewQueued.
  ///
  /// In en, this message translates to:
  /// **'Review saved in the outbox. Use “Sync reviews” on this tab when online (MVP uses a local acceptor until the server is connected).'**
  String get mooringReviewQueued;

  /// No description provided for @mooringDetailClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get mooringDetailClose;

  /// No description provided for @mooringEmptyCatalog.
  ///
  /// In en, this message translates to:
  /// **'No mooring POIs loaded.'**
  String get mooringEmptyCatalog;

  /// No description provided for @mooringGdprHint.
  ///
  /// In en, this message translates to:
  /// **'Comments stay on device until upload; only IDs and ratings go to audit logs.'**
  String get mooringGdprHint;

  /// No description provided for @mooringPendingSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Pending reviews (offline outbox)'**
  String get mooringPendingSectionTitle;

  /// No description provided for @mooringCatalogSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Directory'**
  String get mooringCatalogSectionTitle;

  /// No description provided for @mooringPendingReviewLine.
  ///
  /// In en, this message translates to:
  /// **'{placeId} · {stars} ★ · {time}'**
  String mooringPendingReviewLine(String placeId, int stars, String time);

  /// No description provided for @mooringEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get mooringEmail;

  /// No description provided for @mooringWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get mooringWebsite;

  /// No description provided for @mooringBook.
  ///
  /// In en, this message translates to:
  /// **'Book berth'**
  String get mooringBook;

  /// No description provided for @mooringOpenMap.
  ///
  /// In en, this message translates to:
  /// **'Open map'**
  String get mooringOpenMap;

  /// No description provided for @mooringCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get mooringCall;

  /// No description provided for @mooringSyncPending.
  ///
  /// In en, this message translates to:
  /// **'Sync reviews'**
  String get mooringSyncPending;

  /// No description provided for @mooringSyncDone.
  ///
  /// In en, this message translates to:
  /// **'Submitted {count} review(s).'**
  String mooringSyncDone(int count);

  /// No description provided for @mooringSyncFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not submit some drafts ({count}).'**
  String mooringSyncFailed(int count);

  /// No description provided for @mooringSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name'**
  String get mooringSearchHint;

  /// No description provided for @mooringSearchNoResults.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches your search.'**
  String get mooringSearchNoResults;

  /// No description provided for @mooringSvcElectricity.
  ///
  /// In en, this message translates to:
  /// **'Electricity'**
  String get mooringSvcElectricity;

  /// No description provided for @mooringSvcWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get mooringSvcWater;

  /// No description provided for @mooringSvcWifi.
  ///
  /// In en, this message translates to:
  /// **'Wi‑Fi'**
  String get mooringSvcWifi;

  /// No description provided for @mooringSvcFuel.
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get mooringSvcFuel;

  /// No description provided for @mooringSvcProtection.
  ///
  /// In en, this message translates to:
  /// **'Shelter'**
  String get mooringSvcProtection;

  /// No description provided for @mooringSvcHolding.
  ///
  /// In en, this message translates to:
  /// **'Holding'**
  String get mooringSvcHolding;

  /// No description provided for @logbookTitle.
  ///
  /// In en, this message translates to:
  /// **'Ship\'s log'**
  String get logbookTitle;

  /// No description provided for @logbookEmpty.
  ///
  /// In en, this message translates to:
  /// **'No log entries yet. Tap + to add fuel, maintenance, or general notes.'**
  String get logbookEmpty;

  /// No description provided for @logbookAddEntry.
  ///
  /// In en, this message translates to:
  /// **'Add entry'**
  String get logbookAddEntry;

  /// No description provided for @logbookCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get logbookCategory;

  /// No description provided for @logbookCategoryNote.
  ///
  /// In en, this message translates to:
  /// **'Note / general'**
  String get logbookCategoryNote;

  /// No description provided for @logbookCategoryFuel.
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get logbookCategoryFuel;

  /// No description provided for @logbookCategoryMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get logbookCategoryMaintenance;

  /// No description provided for @logbookCategoryWatch.
  ///
  /// In en, this message translates to:
  /// **'Watch / handover'**
  String get logbookCategoryWatch;

  /// No description provided for @logbookCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get logbookCategoryOther;

  /// No description provided for @logbookEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get logbookEntryTitle;

  /// No description provided for @logbookEntryBody.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get logbookEntryBody;

  /// No description provided for @logbookSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get logbookSave;

  /// No description provided for @logbookCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get logbookCancel;

  /// No description provided for @logbookExportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get logbookExportCsv;

  /// No description provided for @logbookExportCopied.
  ///
  /// In en, this message translates to:
  /// **'CSV copied to clipboard — paste into a spreadsheet or file.'**
  String get logbookExportCopied;

  /// No description provided for @logbookDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete entry'**
  String get logbookDeleteTitle;

  /// No description provided for @logbookDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove this log entry from the device?'**
  String get logbookDeleteConfirm;

  /// No description provided for @logbookDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get logbookDelete;

  /// No description provided for @logbookEntryDeleted.
  ///
  /// In en, this message translates to:
  /// **'Entry deleted.'**
  String get logbookEntryDeleted;

  /// No description provided for @logbookCrewNoDelete.
  ///
  /// In en, this message translates to:
  /// **'Only the captain can delete log entries on this device.'**
  String get logbookCrewNoDelete;

  /// No description provided for @moreMenuHeadline.
  ///
  /// In en, this message translates to:
  /// **'Safety, log & crew'**
  String get moreMenuHeadline;

  /// No description provided for @moreMenuLogbook.
  ///
  /// In en, this message translates to:
  /// **'Ship\'s log'**
  String get moreMenuLogbook;

  /// No description provided for @moreMenuSos.
  ///
  /// In en, this message translates to:
  /// **'SOS / distress'**
  String get moreMenuSos;

  /// No description provided for @moreMenuTrack.
  ///
  /// In en, this message translates to:
  /// **'Track recording'**
  String get moreMenuTrack;

  /// No description provided for @moreMenuChecklists.
  ///
  /// In en, this message translates to:
  /// **'Checklists'**
  String get moreMenuChecklists;

  /// No description provided for @moreMenuVault.
  ///
  /// In en, this message translates to:
  /// **'Document vault'**
  String get moreMenuVault;

  /// No description provided for @moreMenuCrew.
  ///
  /// In en, this message translates to:
  /// **'Crew & ship'**
  String get moreMenuCrew;

  /// No description provided for @sosTitle.
  ///
  /// In en, this message translates to:
  /// **'Distress (SOS)'**
  String get sosTitle;

  /// No description provided for @sosBody.
  ///
  /// In en, this message translates to:
  /// **'Use only in a real emergency. Test mode records a critical audit event and does not open SMS or email.'**
  String get sosBody;

  /// No description provided for @sosTestMode.
  ///
  /// In en, this message translates to:
  /// **'Test mode (no external send)'**
  String get sosTestMode;

  /// No description provided for @sosVesselName.
  ///
  /// In en, this message translates to:
  /// **'Vessel name'**
  String get sosVesselName;

  /// No description provided for @sosSmsNumber.
  ///
  /// In en, this message translates to:
  /// **'SMS number (E.164, optional)'**
  String get sosSmsNumber;

  /// No description provided for @sosRegionRescue.
  ///
  /// In en, this message translates to:
  /// **'Regional rescue (display only, verify locally)'**
  String get sosRegionRescue;

  /// No description provided for @sosOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open options'**
  String get sosOpenSettings;

  /// No description provided for @sosStep1.
  ///
  /// In en, this message translates to:
  /// **'I understand this is for genuine distress'**
  String get sosStep1;

  /// No description provided for @sosStep2.
  ///
  /// In en, this message translates to:
  /// **'Hold the button to trigger (2s)'**
  String get sosStep2;

  /// No description provided for @sosHold.
  ///
  /// In en, this message translates to:
  /// **'HOLD TO ACTIVATE'**
  String get sosHold;

  /// No description provided for @sosAfterTest.
  ///
  /// In en, this message translates to:
  /// **'Test distress recorded. No message was sent.'**
  String get sosAfterTest;

  /// No description provided for @sosAfterLive.
  ///
  /// In en, this message translates to:
  /// **'If a number is set, an SMS compose view may open. Add a body if the platform allows.'**
  String get sosAfterLive;

  /// No description provided for @sosNoNumber.
  ///
  /// In en, this message translates to:
  /// **'Set an SMS number in the field above, or copy the text from the next dialog.'**
  String get sosNoNumber;

  /// No description provided for @sosCopyMessage.
  ///
  /// In en, this message translates to:
  /// **'Copy message'**
  String get sosCopyMessage;

  /// No description provided for @sosMessageCopied.
  ///
  /// In en, this message translates to:
  /// **'Message copied.'**
  String get sosMessageCopied;

  /// No description provided for @sosTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Emergency type'**
  String get sosTypeLabel;

  /// No description provided for @sosTypeMedical.
  ///
  /// In en, this message translates to:
  /// **'Medical'**
  String get sosTypeMedical;

  /// No description provided for @sosTypeFire.
  ///
  /// In en, this message translates to:
  /// **'Fire'**
  String get sosTypeFire;

  /// No description provided for @sosTypeSinking.
  ///
  /// In en, this message translates to:
  /// **'Sinking'**
  String get sosTypeSinking;

  /// No description provided for @sosTypeManOverboard.
  ///
  /// In en, this message translates to:
  /// **'Man overboard'**
  String get sosTypeManOverboard;

  /// No description provided for @sosMessagePreview.
  ///
  /// In en, this message translates to:
  /// **'Message preview'**
  String get sosMessagePreview;

  /// No description provided for @sosCoordsPending.
  ///
  /// In en, this message translates to:
  /// **'Acquiring position…'**
  String get sosCoordsPending;

  /// No description provided for @sosTimerActive.
  ///
  /// In en, this message translates to:
  /// **'Distress active'**
  String get sosTimerActive;

  /// No description provided for @sosTimerElapsed.
  ///
  /// In en, this message translates to:
  /// **'Elapsed'**
  String get sosTimerElapsed;

  /// No description provided for @trackTitle.
  ///
  /// In en, this message translates to:
  /// **'Trip track'**
  String get trackTitle;

  /// No description provided for @trackRecordingActive.
  ///
  /// In en, this message translates to:
  /// **'Recording…'**
  String get trackRecordingActive;

  /// No description provided for @trackIdle.
  ///
  /// In en, this message translates to:
  /// **'Not recording'**
  String get trackIdle;

  /// No description provided for @trackStart.
  ///
  /// In en, this message translates to:
  /// **'Start recording'**
  String get trackStart;

  /// No description provided for @trackStop.
  ///
  /// In en, this message translates to:
  /// **'Stop & save'**
  String get trackStop;

  /// No description provided for @trackPoints.
  ///
  /// In en, this message translates to:
  /// **'{count} points'**
  String trackPoints(int count);

  /// No description provided for @trackStatsPoints.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get trackStatsPoints;

  /// No description provided for @trackStatsDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get trackStatsDuration;

  /// No description provided for @trackEmptyTrips.
  ///
  /// In en, this message translates to:
  /// **'No saved trips'**
  String get trackEmptyTrips;

  /// No description provided for @trackEmptyTripsMessage.
  ///
  /// In en, this message translates to:
  /// **'Stop a recording to save a passage here.'**
  String get trackEmptyTripsMessage;

  /// No description provided for @checklistsTitle.
  ///
  /// In en, this message translates to:
  /// **'Safety checklists'**
  String get checklistsTitle;

  /// No description provided for @checklistTplDeparture.
  ///
  /// In en, this message translates to:
  /// **'Before departure'**
  String get checklistTplDeparture;

  /// No description provided for @checklistTplDocking.
  ///
  /// In en, this message translates to:
  /// **'Docking / mooring'**
  String get checklistTplDocking;

  /// No description provided for @checklistTplStorm.
  ///
  /// In en, this message translates to:
  /// **'Storm preparation'**
  String get checklistTplStorm;

  /// No description provided for @checklistComplete.
  ///
  /// In en, this message translates to:
  /// **'Mark all done'**
  String get checklistComplete;

  /// No description provided for @checklistCompletedAudit.
  ///
  /// In en, this message translates to:
  /// **'Checklist completed.'**
  String get checklistCompletedAudit;

  /// No description provided for @vaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Document vault'**
  String get vaultTitle;

  /// No description provided for @vaultPinSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create vault PIN'**
  String get vaultPinSetupTitle;

  /// No description provided for @vaultPinUnlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock vault'**
  String get vaultPinUnlockTitle;

  /// No description provided for @vaultPinHint.
  ///
  /// In en, this message translates to:
  /// **'4–12 digits recommended'**
  String get vaultPinHint;

  /// No description provided for @vaultPinConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN'**
  String get vaultPinConfirmLabel;

  /// No description provided for @vaultUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get vaultUnlock;

  /// No description provided for @vaultLockedHint.
  ///
  /// In en, this message translates to:
  /// **'Documents are encrypted at rest with your PIN.'**
  String get vaultLockedHint;

  /// No description provided for @vaultEmpty.
  ///
  /// In en, this message translates to:
  /// **'No encrypted files stored yet.'**
  String get vaultEmpty;

  /// No description provided for @vaultPickFile.
  ///
  /// In en, this message translates to:
  /// **'Pick file'**
  String get vaultPickFile;

  /// No description provided for @vaultEncryptedBadge.
  ///
  /// In en, this message translates to:
  /// **'Encrypted'**
  String get vaultEncryptedBadge;

  /// No description provided for @vaultDecryptPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview / decrypt check'**
  String get vaultDecryptPreview;

  /// No description provided for @vaultDeleteForbidden.
  ///
  /// In en, this message translates to:
  /// **'Only the captain can delete vault files.'**
  String get vaultDeleteForbidden;

  /// No description provided for @crewTitle.
  ///
  /// In en, this message translates to:
  /// **'Crew & ship'**
  String get crewTitle;

  /// No description provided for @crewCreateShip.
  ///
  /// In en, this message translates to:
  /// **'Create ship & invite code'**
  String get crewCreateShip;

  /// No description provided for @crewJoinShip.
  ///
  /// In en, this message translates to:
  /// **'Join ship'**
  String get crewJoinShip;

  /// No description provided for @crewInviteExplain.
  ///
  /// In en, this message translates to:
  /// **'Share this code so others can join the same ship ID on their device.'**
  String get crewInviteExplain;

  /// No description provided for @crewLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave ship'**
  String get crewLeave;

  /// No description provided for @crewRoleCaptain.
  ///
  /// In en, this message translates to:
  /// **'Captain'**
  String get crewRoleCaptain;

  /// No description provided for @crewRoleCrew.
  ///
  /// In en, this message translates to:
  /// **'Crew'**
  String get crewRoleCrew;

  /// No description provided for @moreMenuSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get moreMenuSettings;

  /// No description provided for @settingsAccessibilitySection.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get settingsAccessibilitySection;

  /// No description provided for @settingsGloveMode.
  ///
  /// In en, this message translates to:
  /// **'Glove mode'**
  String get settingsGloveMode;

  /// No description provided for @settingsGloveModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Larger buttons and tap targets'**
  String get settingsGloveModeSubtitle;

  /// No description provided for @settingsTextSize.
  ///
  /// In en, this message translates to:
  /// **'Text size'**
  String get settingsTextSize;

  /// No description provided for @settingsTextSizeStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get settingsTextSizeStandard;

  /// No description provided for @settingsTextSizeLarge.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get settingsTextSizeLarge;

  /// No description provided for @settingsTextSizeExtraLarge.
  ///
  /// In en, this message translates to:
  /// **'Extra large'**
  String get settingsTextSizeExtraLarge;

  /// No description provided for @settingsHighContrast.
  ///
  /// In en, this message translates to:
  /// **'High contrast'**
  String get settingsHighContrast;

  /// No description provided for @settingsNightWatch.
  ///
  /// In en, this message translates to:
  /// **'Night watch (red)'**
  String get settingsNightWatch;

  /// No description provided for @settingsNightWatchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Red UI to preserve night vision'**
  String get settingsNightWatchSubtitle;

  /// No description provided for @settingsNightWatchChartNightHint.
  ///
  /// In en, this message translates to:
  /// **'Tip: Map layers → Chart → Night pairs well with this theme.'**
  String get settingsNightWatchChartNightHint;

  /// No description provided for @settingsNightWatchChartDayHint.
  ///
  /// In en, this message translates to:
  /// **'Tip: Map layers → Chart → Standard for a daytime chart palette.'**
  String get settingsNightWatchChartDayHint;

  /// No description provided for @settingsEnergySection.
  ///
  /// In en, this message translates to:
  /// **'Battery & GPS'**
  String get settingsEnergySection;

  /// No description provided for @settingsVesselSection.
  ///
  /// In en, this message translates to:
  /// **'Vessel'**
  String get settingsVesselSection;

  /// No description provided for @settingsDisplaySection.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get settingsDisplaySection;

  /// No description provided for @settingsAboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAboutSection;

  /// No description provided for @settingsVesselName.
  ///
  /// In en, this message translates to:
  /// **'Vessel name'**
  String get settingsVesselName;

  /// No description provided for @settingsVesselLoa.
  ///
  /// In en, this message translates to:
  /// **'Length overall ({unit})'**
  String settingsVesselLoa(String unit);

  /// No description provided for @settingsVesselDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft ({unit})'**
  String settingsVesselDraft(String unit);

  /// No description provided for @settingsVesselType.
  ///
  /// In en, this message translates to:
  /// **'Hull type'**
  String get settingsVesselType;

  /// No description provided for @settingsVesselTypeSailing.
  ///
  /// In en, this message translates to:
  /// **'Sailing yacht'**
  String get settingsVesselTypeSailing;

  /// No description provided for @settingsVesselTypeMotor.
  ///
  /// In en, this message translates to:
  /// **'Motor yacht'**
  String get settingsVesselTypeMotor;

  /// No description provided for @settingsVesselTypeCatamaran.
  ///
  /// In en, this message translates to:
  /// **'Catamaran'**
  String get settingsVesselTypeCatamaran;

  /// No description provided for @settingsVesselTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get settingsVesselTypeOther;

  /// No description provided for @settingsUnits.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get settingsUnits;

  /// No description provided for @settingsUnitsMetric.
  ///
  /// In en, this message translates to:
  /// **'Metric'**
  String get settingsUnitsMetric;

  /// No description provided for @settingsUnitsImperial.
  ///
  /// In en, this message translates to:
  /// **'Imperial'**
  String get settingsUnitsImperial;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeDeck.
  ///
  /// In en, this message translates to:
  /// **'Deck'**
  String get settingsThemeDeck;

  /// No description provided for @settingsThemeNightRed.
  ///
  /// In en, this message translates to:
  /// **'Night red'**
  String get settingsThemeNightRed;

  /// No description provided for @settingsThemeHighContrast.
  ///
  /// In en, this message translates to:
  /// **'High contrast'**
  String get settingsThemeHighContrast;

  /// No description provided for @settingsAboutAppName.
  ///
  /// In en, this message translates to:
  /// **'Captain Wrongel'**
  String get settingsAboutAppName;

  /// No description provided for @settingsAboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String settingsAboutVersion(String version);

  /// No description provided for @settingsAboutTagline.
  ///
  /// In en, this message translates to:
  /// **'Offline-first yacht navigator. Not for primary navigation.'**
  String get settingsAboutTagline;

  /// No description provided for @energyProfileEco.
  ///
  /// In en, this message translates to:
  /// **'Eco passage'**
  String get energyProfileEco;

  /// No description provided for @energyProfilePassage.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get energyProfilePassage;

  /// No description provided for @energyProfileSport.
  ///
  /// In en, this message translates to:
  /// **'Precision'**
  String get energyProfileSport;

  /// No description provided for @energyProfileEcoDescription.
  ///
  /// In en, this message translates to:
  /// **'Fewer GPS fixes while recording and lighter map work when the app is backgrounded.'**
  String get energyProfileEcoDescription;

  /// No description provided for @energyProfilePassageDescription.
  ///
  /// In en, this message translates to:
  /// **'Default balance for coastal sailing.'**
  String get energyProfilePassageDescription;

  /// No description provided for @energyProfileSportDescription.
  ///
  /// In en, this message translates to:
  /// **'More frequent track points and faster AIS demo updates.'**
  String get energyProfileSportDescription;

  /// No description provided for @moreMenuKnots.
  ///
  /// In en, this message translates to:
  /// **'Knot guide'**
  String get moreMenuKnots;

  /// No description provided for @knotsTitle.
  ///
  /// In en, this message translates to:
  /// **'Maritime knots'**
  String get knotsTitle;

  /// No description provided for @knotsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search knots'**
  String get knotsSearchHint;

  /// No description provided for @knotsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load knot catalog.'**
  String get knotsLoadError;

  /// No description provided for @knotsEmpty.
  ///
  /// In en, this message translates to:
  /// **'The knot catalog is empty.'**
  String get knotsEmpty;

  /// No description provided for @knotsNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No knots match your search.'**
  String get knotsNoMatch;

  /// No description provided for @knotStepsHeading.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get knotStepsHeading;

  /// No description provided for @knotCategoryLoops.
  ///
  /// In en, this message translates to:
  /// **'Loops'**
  String get knotCategoryLoops;

  /// No description provided for @knotCategoryBends.
  ///
  /// In en, this message translates to:
  /// **'Bends'**
  String get knotCategoryBends;

  /// No description provided for @knotCategoryHitches.
  ///
  /// In en, this message translates to:
  /// **'Hitches'**
  String get knotCategoryHitches;

  /// No description provided for @knotCategoryStoppers.
  ///
  /// In en, this message translates to:
  /// **'Stoppers'**
  String get knotCategoryStoppers;

  /// No description provided for @knotCategoryEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get knotCategoryEmergency;

  /// No description provided for @knotCategoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get knotCategoryAll;

  /// No description provided for @knotCategoryFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get knotCategoryFavorites;

  /// No description provided for @knotDifficultyEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get knotDifficultyEasy;

  /// No description provided for @knotDifficultyMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get knotDifficultyMedium;

  /// No description provided for @knotDifficultyHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get knotDifficultyHard;

  /// No description provided for @knotAddFavorite.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get knotAddFavorite;

  /// No description provided for @knotRemoveFavorite.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get knotRemoveFavorite;

  /// No description provided for @moreMenuToolbox.
  ///
  /// In en, this message translates to:
  /// **'Maritime toolbox'**
  String get moreMenuToolbox;

  /// No description provided for @moreMenuToolboxSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Anchor, compass, GRIB, shore, radio, medical, expenses…'**
  String get moreMenuToolboxSubtitle;

  /// No description provided for @toolboxTitle.
  ///
  /// In en, this message translates to:
  /// **'Maritime toolbox'**
  String get toolboxTitle;

  /// No description provided for @toolboxLead.
  ///
  /// In en, this message translates to:
  /// **'Training and safety utilities; not a substitute for certified equipment or medical care.'**
  String get toolboxLead;

  /// No description provided for @toolboxAnchorWatch.
  ///
  /// In en, this message translates to:
  /// **'Anchor watch'**
  String get toolboxAnchorWatch;

  /// No description provided for @toolboxCompass.
  ///
  /// In en, this message translates to:
  /// **'Compass & sun times'**
  String get toolboxCompass;

  /// No description provided for @toolboxGrib.
  ///
  /// In en, this message translates to:
  /// **'GRIB files (import)'**
  String get toolboxGrib;

  /// No description provided for @toolboxCoastal.
  ///
  /// In en, this message translates to:
  /// **'Coastal guide (POI)'**
  String get toolboxCoastal;

  /// No description provided for @toolboxVhf.
  ///
  /// In en, this message translates to:
  /// **'VHF & COLREG trainer'**
  String get toolboxVhf;

  /// No description provided for @toolboxMedical.
  ///
  /// In en, this message translates to:
  /// **'Medical glossary'**
  String get toolboxMedical;

  /// No description provided for @toolboxExpenses.
  ///
  /// In en, this message translates to:
  /// **'Voyager cashbook'**
  String get toolboxExpenses;

  /// No description provided for @toolboxSectionNavigation.
  ///
  /// In en, this message translates to:
  /// **'Navigation'**
  String get toolboxSectionNavigation;

  /// No description provided for @toolboxSectionSafety.
  ///
  /// In en, this message translates to:
  /// **'Safety'**
  String get toolboxSectionSafety;

  /// No description provided for @toolboxSectionReference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get toolboxSectionReference;

  /// No description provided for @badgeNew.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get badgeNew;

  /// No description provided for @anchorWatchTitle.
  ///
  /// In en, this message translates to:
  /// **'Anchor watch'**
  String get anchorWatchTitle;

  /// No description provided for @anchorWatchHint.
  ///
  /// In en, this message translates to:
  /// **'Drop anchor when moored, set radius, then arm. Alarm if position drifts beyond the circle. For professional ground tackle use your own judgment.'**
  String get anchorWatchHint;

  /// No description provided for @anchorWatchRadius.
  ///
  /// In en, this message translates to:
  /// **'Allowed radius'**
  String get anchorWatchRadius;

  /// No description provided for @anchorWatchDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance to anchor'**
  String get anchorWatchDistance;

  /// No description provided for @anchorWatchDrop.
  ///
  /// In en, this message translates to:
  /// **'Mark anchor position (GPS)'**
  String get anchorWatchDrop;

  /// No description provided for @anchorWatchArm.
  ///
  /// In en, this message translates to:
  /// **'Arm watch'**
  String get anchorWatchArm;

  /// No description provided for @anchorWatchDisarm.
  ///
  /// In en, this message translates to:
  /// **'Disarm'**
  String get anchorWatchDisarm;

  /// No description provided for @anchorWatchClear.
  ///
  /// In en, this message translates to:
  /// **'Clear anchor position'**
  String get anchorWatchClear;

  /// No description provided for @anchorWatchAlarmBanner.
  ///
  /// In en, this message translates to:
  /// **'VESSEL MOVED OUTSIDE ANCHOR CIRCLE'**
  String get anchorWatchAlarmBanner;

  /// No description provided for @anchorWatchDismissAlarm.
  ///
  /// In en, this message translates to:
  /// **'Acknowledge'**
  String get anchorWatchDismissAlarm;

  /// No description provided for @anchorWatchGpsLost.
  ///
  /// In en, this message translates to:
  /// **'No recent GPS fix — verify receiver and sky view.'**
  String get anchorWatchGpsLost;

  /// No description provided for @anchorWatchMapPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Mark anchor position to show zone map'**
  String get anchorWatchMapPlaceholder;

  /// No description provided for @anchorWatchInZone.
  ///
  /// In en, this message translates to:
  /// **'IN ZONE'**
  String get anchorWatchInZone;

  /// No description provided for @anchorWatchDrifting.
  ///
  /// In en, this message translates to:
  /// **'DRIFTING'**
  String get anchorWatchDrifting;

  /// No description provided for @anchorWatchDisarmed.
  ///
  /// In en, this message translates to:
  /// **'Disarmed'**
  String get anchorWatchDisarmed;

  /// No description provided for @anchorWatchArmedBadge.
  ///
  /// In en, this message translates to:
  /// **'ARMED'**
  String get anchorWatchArmedBadge;

  /// No description provided for @compassTitle.
  ///
  /// In en, this message translates to:
  /// **'Compass & sun'**
  String get compassTitle;

  /// No description provided for @compassDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Magnetic compass uses device sensors; solar times are approximate.'**
  String get compassDisclaimer;

  /// No description provided for @compassUnavailablePlatform.
  ///
  /// In en, this message translates to:
  /// **'Compass stream is unavailable on this platform.'**
  String get compassUnavailablePlatform;

  /// No description provided for @compassHeadingLabel.
  ///
  /// In en, this message translates to:
  /// **'Heading (magnetic variation not applied)'**
  String get compassHeadingLabel;

  /// No description provided for @astroSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Approximate sunrise / sunset (UTC converted to local)'**
  String get astroSectionTitle;

  /// No description provided for @astroNeedGps.
  ///
  /// In en, this message translates to:
  /// **'Need a GPS fix to estimate sun times.'**
  String get astroNeedGps;

  /// No description provided for @astroSunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get astroSunrise;

  /// No description provided for @astroSunset.
  ///
  /// In en, this message translates to:
  /// **'Sunset'**
  String get astroSunset;

  /// No description provided for @gribTitle.
  ///
  /// In en, this message translates to:
  /// **'GRIB import'**
  String get gribTitle;

  /// No description provided for @gribStubBody.
  ///
  /// In en, this message translates to:
  /// **'Decoder for GRIB (wgrib/ecCodes style) is not bundled yet. You can park a file path for future offline viewers.'**
  String get gribStubBody;

  /// No description provided for @gribLastPath.
  ///
  /// In en, this message translates to:
  /// **'Last stub path'**
  String get gribLastPath;

  /// No description provided for @gribSimulatePick.
  ///
  /// In en, this message translates to:
  /// **'Simulate picking a GRIB file'**
  String get gribSimulatePick;

  /// No description provided for @gribStubSaved.
  ///
  /// In en, this message translates to:
  /// **'Stub path saved locally.'**
  String get gribStubSaved;

  /// No description provided for @coastalGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'Coastal POI'**
  String get coastalGuideTitle;

  /// No description provided for @coastalLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load coastal POIs.'**
  String get coastalLoadError;

  /// No description provided for @coastalEmpty.
  ///
  /// In en, this message translates to:
  /// **'No coastal POIs.'**
  String get coastalEmpty;

  /// No description provided for @medicalGlossaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Medical glossary'**
  String get medicalGlossaryTitle;

  /// No description provided for @medicalDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Educational snippets only — call emergency services when needed.'**
  String get medicalDisclaimer;

  /// No description provided for @medicalLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load medical glossary.'**
  String get medicalLoadError;

  /// No description provided for @vhfTrainingTitle.
  ///
  /// In en, this message translates to:
  /// **'VHF & COLREG'**
  String get vhfTrainingTitle;

  /// No description provided for @vhfTabScenarios.
  ///
  /// In en, this message translates to:
  /// **'Scenarios'**
  String get vhfTabScenarios;

  /// No description provided for @vhfTabQuiz.
  ///
  /// In en, this message translates to:
  /// **'COLREG quiz'**
  String get vhfTabQuiz;

  /// No description provided for @vhfTabSessions.
  ///
  /// In en, this message translates to:
  /// **'Recordings'**
  String get vhfTabSessions;

  /// No description provided for @vhfScenariosLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load VHF scenarios.'**
  String get vhfScenariosLoadError;

  /// No description provided for @vhfScenariosEmpty.
  ///
  /// In en, this message translates to:
  /// **'No VHF scenarios available.'**
  String get vhfScenariosEmpty;

  /// No description provided for @vhfScenarioPickHint.
  ///
  /// In en, this message translates to:
  /// **'Pick a scenario to practice radio calls.'**
  String get vhfScenarioPickHint;

  /// No description provided for @vhfScenarioBack.
  ///
  /// In en, this message translates to:
  /// **'All scenarios'**
  String get vhfScenarioBack;

  /// No description provided for @vhfDifficultyBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get vhfDifficultyBeginner;

  /// No description provided for @vhfDifficultyIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get vhfDifficultyIntermediate;

  /// No description provided for @vhfDifficultyAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get vhfDifficultyAdvanced;

  /// No description provided for @vhfDialogueShore.
  ///
  /// In en, this message translates to:
  /// **'Shore'**
  String get vhfDialogueShore;

  /// No description provided for @vhfDialogueYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get vhfDialogueYou;

  /// No description provided for @vhfQuizProgress.
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String vhfQuizProgress(int current, int total);

  /// No description provided for @vhfQuizPickAnswer.
  ///
  /// In en, this message translates to:
  /// **'Select an answer first.'**
  String get vhfQuizPickAnswer;

  /// No description provided for @vhfSessionsHint.
  ///
  /// In en, this message translates to:
  /// **'Recordings stay on this device. Transcription uses the microphone (paraphrase), not offline file decoding.'**
  String get vhfSessionsHint;

  /// No description provided for @vhfSessionsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load recordings list.'**
  String get vhfSessionsLoadError;

  /// No description provided for @vhfSessionsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No VHF recordings yet.'**
  String get vhfSessionsEmpty;

  /// No description provided for @vhfRecordStart.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get vhfRecordStart;

  /// No description provided for @vhfRecordStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get vhfRecordStop;

  /// No description provided for @vhfRecordWebUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Recording is not supported in the web build.'**
  String get vhfRecordWebUnsupported;

  /// No description provided for @vhfTranscribeHint.
  ///
  /// In en, this message translates to:
  /// **'Tap the mic: speak a short summary to store as text. For full verbatim from the audio file use a desktop tool with a GRIB/audio pipeline (post-MVP).'**
  String get vhfTranscribeHint;

  /// No description provided for @vhfTranscribeDone.
  ///
  /// In en, this message translates to:
  /// **'Transcript saved.'**
  String get vhfTranscribeDone;

  /// No description provided for @vhfQuizLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load quiz.'**
  String get vhfQuizLoadError;

  /// No description provided for @vhfQuizEmpty.
  ///
  /// In en, this message translates to:
  /// **'No quiz questions.'**
  String get vhfQuizEmpty;

  /// No description provided for @vhfQuizWrong.
  ///
  /// In en, this message translates to:
  /// **'Not quite — review COLREG.'**
  String get vhfQuizWrong;

  /// No description provided for @vhfQuizPrev.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get vhfQuizPrev;

  /// No description provided for @vhfQuizNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get vhfQuizNext;

  /// No description provided for @vhfQuizDone.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get vhfQuizDone;

  /// No description provided for @vhfQuizComplete.
  ///
  /// In en, this message translates to:
  /// **'Last question answered.'**
  String get vhfQuizComplete;

  /// No description provided for @expensesTitle.
  ///
  /// In en, this message translates to:
  /// **'Voyager cashbook'**
  String get expensesTitle;

  /// No description provided for @expensesDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Totals are stored only on device — no shore sync in MVP.'**
  String get expensesDisclaimer;

  /// No description provided for @expensesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load expenses.'**
  String get expensesLoadError;

  /// No description provided for @expenseAdd.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get expenseAdd;

  /// No description provided for @expenseSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get expenseSave;

  /// No description provided for @expenseAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get expenseAmount;

  /// No description provided for @expenseNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get expenseNote;

  /// No description provided for @expenseEmpty.
  ///
  /// In en, this message translates to:
  /// **'No expenses logged.'**
  String get expenseEmpty;

  /// No description provided for @expenseCatFuel.
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get expenseCatFuel;

  /// No description provided for @expenseCatFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get expenseCatFood;

  /// No description provided for @expenseCatMarina.
  ///
  /// In en, this message translates to:
  /// **'Marina fees'**
  String get expenseCatMarina;

  /// No description provided for @expenseCatMooringFee.
  ///
  /// In en, this message translates to:
  /// **'Mooring'**
  String get expenseCatMooringFee;

  /// No description provided for @expenseCatGear.
  ///
  /// In en, this message translates to:
  /// **'Gear & repairs'**
  String get expenseCatGear;

  /// No description provided for @expenseCatProvisions.
  ///
  /// In en, this message translates to:
  /// **'Provisions'**
  String get expenseCatProvisions;

  /// No description provided for @expenseCatOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get expenseCatOther;

  /// No description provided for @onboardingWelcomeTagline.
  ///
  /// In en, this message translates to:
  /// **'Captain Wrongel'**
  String get onboardingWelcomeTagline;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Your crewmate on every voyage'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Offline charts, weather, moorings — one deck.'**
  String get onboardingWelcomeSubtitle;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get onboardingBack;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingPermissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable permissions'**
  String get onboardingPermissionsTitle;

  /// No description provided for @onboardingPermissionsBody.
  ///
  /// In en, this message translates to:
  /// **'Location powers charts, weather, and anchor watch. Notifications alert you to drift and weather changes.'**
  String get onboardingPermissionsBody;

  /// No description provided for @onboardingLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get onboardingLocationTitle;

  /// No description provided for @onboardingLocationButton.
  ///
  /// In en, this message translates to:
  /// **'Allow location'**
  String get onboardingLocationButton;

  /// No description provided for @onboardingNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get onboardingNotificationTitle;

  /// No description provided for @onboardingNotificationButton.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications'**
  String get onboardingNotificationButton;

  /// No description provided for @onboardingExperienceTitle.
  ///
  /// In en, this message translates to:
  /// **'Your experience'**
  String get onboardingExperienceTitle;

  /// No description provided for @onboardingExperienceBody.
  ///
  /// In en, this message translates to:
  /// **'We\'ll tune tips and defaults to match your sailing style.'**
  String get onboardingExperienceBody;

  /// No description provided for @onboardingExperienceBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get onboardingExperienceBeginner;

  /// No description provided for @onboardingExperienceCruiser.
  ///
  /// In en, this message translates to:
  /// **'Cruiser'**
  String get onboardingExperienceCruiser;

  /// No description provided for @onboardingExperienceRacer.
  ///
  /// In en, this message translates to:
  /// **'Racer'**
  String get onboardingExperienceRacer;

  /// No description provided for @onboardingRegionTitle.
  ///
  /// In en, this message translates to:
  /// **'Where do you sail?'**
  String get onboardingRegionTitle;

  /// No description provided for @onboardingRegionBody.
  ///
  /// In en, this message translates to:
  /// **'We prioritize charts and mooring data for your region.'**
  String get onboardingRegionBody;

  /// No description provided for @onboardingRegionMediterranean.
  ///
  /// In en, this message translates to:
  /// **'Mediterranean'**
  String get onboardingRegionMediterranean;

  /// No description provided for @onboardingRegionCaribbean.
  ///
  /// In en, this message translates to:
  /// **'Caribbean'**
  String get onboardingRegionCaribbean;

  /// No description provided for @onboardingRegionOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get onboardingRegionOther;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'ru',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
