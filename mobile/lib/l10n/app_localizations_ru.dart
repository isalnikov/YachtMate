// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Captain Wrongel';

  @override
  String get tabMap => 'Карта';

  @override
  String get tabRoute => 'Маршрут';

  @override
  String get tabWeather => 'Погода';

  @override
  String get tabMooring => 'Стоянка';

  @override
  String get tabMore => 'Ещё';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get languageLabel => 'Язык';

  @override
  String get localeEnglish => 'Английский';

  @override
  String get localeRussian => 'Русский';

  @override
  String get bootstrapNote => 'Оболочка фазы 0 — карта и навигация в фазе 1.';
}
