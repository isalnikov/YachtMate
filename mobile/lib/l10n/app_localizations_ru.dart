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
  String get languageSwitchTooltip => 'Выбор языка (английский / русский)';

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

  @override
  String get mapLayersTooltip => 'Слои карты';

  @override
  String get mapLayersSheetTitle => 'Слои карты (демо)';

  @override
  String get mapLayerDepthContours => 'Изобаты (синтетика)';

  @override
  String get mapLayerNavAids => 'Навигационные знаки (синтетика)';

  @override
  String get mapDepthLegendTitle => 'Легенда';

  @override
  String get mapDepthLegendBody =>
      '5 м (голубой), 10 м (синий), 20 м (тёмно-синий). Синтетический GeoJSON — не для плавания.';

  @override
  String get mapLongPressTitle => 'Позиция (WGS84)';

  @override
  String get mapLongPressLatitude => 'Широта';

  @override
  String get mapLongPressLongitude => 'Долгота';

  @override
  String get mapLongPressDepth => 'Глубина (демо-слой)';

  @override
  String get mapLongPressDepthUnavailable =>
      'Нет изобаты поблизости — включите слой или сместите точку.';

  @override
  String get mapLongPressNavAid => 'Ближайший знак';

  @override
  String get mapLongPressNavUnavailable => '—';

  @override
  String get mapLongPressAddWaypoint => 'Добавить точку маршрута';

  @override
  String get mapAisDemoTooltip => 'Демо AIS (записанный NMEA)';

  @override
  String get weatherScreenTitle => 'Погода и приливы';

  @override
  String get weatherRefreshTooltip => 'Обновить прогноз';

  @override
  String get weatherGpsTooltip => 'Точка прогноза по GPS';

  @override
  String get weatherStaleBanner => 'Показан кэш — нет сети или ошибка API.';

  @override
  String weatherCoordinates(String lat, String lon) {
    return 'Точка прогноза: $lat°, $lon°';
  }

  @override
  String weatherLastUpdated(String time) {
    return 'Опорное время данных: $time';
  }

  @override
  String weatherLoadError(String detail) {
    return 'Не удалось загрузить прогноз: $detail';
  }

  @override
  String get weatherHourlyHeading => 'Почасовой (48 ч)';

  @override
  String get weatherTidesSection => 'Приливы (демо)';

  @override
  String get weatherRefreshing => 'Обновление…';

  @override
  String get weatherGpsDenied => 'Нет доступа к геолокации.';

  @override
  String get weatherGpsUpdated => 'Точка прогноза по текущему GPS.';

  @override
  String weatherGpsError(String detail) {
    return 'Ошибка GPS: $detail';
  }

  @override
  String get tidesHigh => 'Вода растёт';

  @override
  String get tidesLow => 'Вода падает';

  @override
  String weatherWaveSuffix(String m) {
    return ' · волна $m м';
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
    return '$tempC °C · ветер $windKn уз / $windDir° · осадки $rainMm мм · $pressHpa гПа$wavePart';
  }

  @override
  String weatherTideRow(String time, String height, String kind) {
    return '$time · $height · $kind';
  }
}
