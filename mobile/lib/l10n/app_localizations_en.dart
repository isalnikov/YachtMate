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
}
