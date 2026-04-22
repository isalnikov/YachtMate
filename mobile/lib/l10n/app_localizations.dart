import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
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
    Locale('en'),
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
  /// **'Choose language (English / Russian)'**
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

  /// No description provided for @mapDepthLegendTitle.
  ///
  /// In en, this message translates to:
  /// **'Legend'**
  String get mapDepthLegendTitle;

  /// No description provided for @mapDepthLegendBody.
  ///
  /// In en, this message translates to:
  /// **'5 m (light blue), 10 m (blue), 20 m (dark blue). Synthetic GeoJSON — not for navigation.'**
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

  /// No description provided for @mapAisDemoTooltip.
  ///
  /// In en, this message translates to:
  /// **'AIS demo stream (recorded NMEA)'**
  String get mapAisDemoTooltip;

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
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
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
