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
}
