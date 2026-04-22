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

  @override
  String get mapUnavailableOnPlatform =>
      'Карта MapLibre на Android, iOS или в браузере. На Linux desktop — заглушка.';

  @override
  String get mapLoadingStyle => 'Загрузка стиля карты…';

  @override
  String get disclaimerTitle => 'Уведомление о навигации';

  @override
  String get disclaimerP1 =>
      'Captain Wrongel не является ECDIS, радаром или официальной навигационной картой. Карты и GPS могут содержать ошибки.';

  @override
  String get disclaimerP2 =>
      'Ответственность за безопасную навигацию, COLREG и сверку с официальными материалами полностью на судоводителе.';

  @override
  String get disclaimerAccept => 'Понимаю — продолжить';

  @override
  String get offlineCacheStart => 'Загрузка тайлов для видимой области…';

  @override
  String get offlineCacheDone => 'Офлайн-регион сохранён';

  @override
  String get offlineCacheFail =>
      'Не удалось сохранить тайлы (сеть или движок карты).';
}
