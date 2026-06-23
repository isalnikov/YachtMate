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
  String get languageSwitchTooltip => 'Выбор языка интерфейса';

  @override
  String get localeEnglish => 'Английский';

  @override
  String get localeRussian => 'Русский';

  @override
  String get localeGerman => 'Немецкий';

  @override
  String get localeFrench => 'Французский';

  @override
  String get localeSpanish => 'Испанский';

  @override
  String get localeItalian => 'Итальянский';

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
  String get mapLayerMooringPois => 'Марины и якорные (каталог)';

  @override
  String get mapLayerSectionOverlays => 'Наложения';

  @override
  String get mapLayerSectionChart => 'Карта';

  @override
  String get mapLayerSectionShallow => 'Мелководье';

  @override
  String get mapLayerOverlayNone => 'Без наложения';

  @override
  String get mapLayerOverlaySatellite => 'Спутник';

  @override
  String get mapLayerOverlayRelief => 'Рельеф';

  @override
  String get mapLayerOverlaySonar => 'Сонар';

  @override
  String get mapLayerChartStandard => 'Стандарт';

  @override
  String get mapLayerChartPaper => 'Бумажная';

  @override
  String get mapLayerChartSimple => 'Простая';

  @override
  String get mapLayerChartNight => 'Ночная';

  @override
  String get mapLayerShallowHighlight => 'Подсветка мелководья';

  @override
  String get mapDepthLegendTitle => 'Легенда';

  @override
  String get mapDepthLegendBody =>
      'Синие линии: изобаты EMODnet Bathymetry (пример: район Фетхие, Турция). На карте один цвет; значения глубин идут в расчёт сетки. Не официальные карты.';

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
  String get mapNavigateHere => 'Навигация сюда';

  @override
  String get mapCoordsCopied => 'Координаты скопированы';

  @override
  String get mapPeekCoordsSemantic =>
      'Координаты центра карты — нажмите, чтобы скопировать';

  @override
  String mapPeekDepthMeters(int meters) {
    return 'Глубина: $meters м';
  }

  @override
  String get mapAisDemoTooltip => 'Демо AIS (записанный NMEA)';

  @override
  String get aisScreenTitle => 'AIS';

  @override
  String get moreMenuAis => 'AIS и трафик';

  @override
  String get moreMenuAisSubtitle => 'Локальный NMEA · CPA/TCPA · фильтры';

  @override
  String get aisFilterAll => 'Все';

  @override
  String get aisFilterCargo => 'Грузовые';

  @override
  String get aisFilterTanker => 'Танкеры';

  @override
  String get aisFilterPleasure => 'Яхты';

  @override
  String get aisLocalStreamTitle => 'Локальный поток';

  @override
  String get aisLocalStreamBody => 'NMEA 0183 · Wi‑Fi/BT шлюз · CPA/TCPA';

  @override
  String get aisDemoStart => 'Демо';

  @override
  String get aisDemoStop => 'Стоп';

  @override
  String get aisDemoActive => 'Демо NMEA активно';

  @override
  String aisTargetsCount(int count) {
    return 'Целей: $count';
  }

  @override
  String get aisTapVessel => 'Нажмите на судно для деталей';

  @override
  String aisVesselSog(String knots) {
    return '$knots уз';
  }

  @override
  String aisVesselCog(String degrees) {
    return '$degrees°';
  }

  @override
  String aisVesselCpa(String nm) {
    return '$nm м.м.';
  }

  @override
  String aisVesselTcpa(String minutes) {
    return '$minutes мин';
  }

  @override
  String get aisCpaWarning => 'CPA < 1 м.м.';

  @override
  String get mapZoomInTooltip => 'Приблизить';

  @override
  String get mapZoomOutTooltip => 'Отдалить';

  @override
  String get mapCompassNorthUpTooltip =>
      'Север вверху — нажмите для курса вверх';

  @override
  String get mapCompassHeadingUpTooltip =>
      'Курс вверху — нажмите для севера вверху';

  @override
  String get mapFollowGpsTooltip => 'Следовать GPS';

  @override
  String get mapFollowGpsActiveTooltip =>
      'Следование GPS — нажмите, чтобы остановить';

  @override
  String get mapGpsStatusSemantic =>
      'Статус GPS — нажмите для настроек геолокации';

  @override
  String mapGpsAccuracyMeters(int meters) {
    return '±$meters м';
  }

  @override
  String mapGpsSogKnots(String knots) {
    return '$knots уз';
  }

  @override
  String get mapGpsLocationSettingsHint =>
      'Проверьте разрешение геолокации и точность GPS в настройках системы.';

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
  String get weatherLayerWindTooltip => 'Слой ветра';

  @override
  String get weatherLayerWavesTooltip => 'Слой волн';

  @override
  String get weatherLayerTempTooltip => 'Слой температуры';

  @override
  String get weatherLayerPressureTooltip => 'Слой давления';

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

  @override
  String get weatherSeeAllTides => 'Все приливы';

  @override
  String get tidesScreenTitle => 'Приливы';

  @override
  String get tidesCurveHeading => 'Кривая на сегодня (демо)';

  @override
  String get tidesTableHeading => 'Расписание на 7 дней (демо)';

  @override
  String get tidesMoonHeading => 'Фаза Луны';

  @override
  String get tidesSunHeading => 'Восход и закат (прибл.)';

  @override
  String get tidesTableDay => 'День';

  @override
  String get tidesHighShort => 'ПМ';

  @override
  String get tidesLowShort => 'ММ';

  @override
  String get tidesEmpty => 'Нет данных о приливах.';

  @override
  String tidesHeightM(String height) {
    return '$height м';
  }

  @override
  String tidesTableCell(String time, String height, String kind) {
    return '$time · $height · $kind';
  }

  @override
  String tidesSunLine(String sunrise, String sunset) {
    return 'Восход $sunrise · Закат $sunset';
  }

  @override
  String get moreMenuTides => 'Приливы';

  @override
  String get moreMenuTidesSubtitle =>
      'Демо-кривая, таблица 7 дней, Луна и Солнце';

  @override
  String get routeScreenTitle => 'Маршрут (advisory)';

  @override
  String get routeAdvisoryDisclaimerTitle => 'Advisory-маршрут (синтетика)';

  @override
  String get routeAdvisoryDisclaimerBody =>
      'Линия считается по демонстрационной глубинной сетке, не по официальной карте. Только для ориентира; безопасность и запас под килем обеспечиваете вы.';

  @override
  String get routeAdvisoryDisclaimerAccept => 'Понимаю';

  @override
  String routeActiveRouteLabel(String id) {
    return 'Текущий черновик: $id';
  }

  @override
  String get routeActiveRouteUnknown => 'нет';

  @override
  String get routeShipDraftM => 'Осада (м)';

  @override
  String get routeShipClearanceM => 'Запас под килем (м)';

  @override
  String get routeComputeAdvisory => 'Рассчитать advisory-путь';

  @override
  String get routeClearAdvisory => 'Скрыть линию';

  @override
  String get routeSyntheticNote =>
      'Глубины по тем же синтетическим изобатам, что на карте — не официальный промер.';

  @override
  String get routeAdvisoryChartLoadFailed =>
      'Не удалось загрузить контуры карты для расчёта.';

  @override
  String get routeAdvisoryNoRoute =>
      'Нет сохранённого маршрута. Добавьте точки на карте.';

  @override
  String get routeAdvisoryNeedTwoPoints =>
      'Нужны минимум две точки (начало и конец).';

  @override
  String get routeAdvisoryComputed => 'Advisory-полилиния показана на карте.';

  @override
  String routeAdvisoryFailed(String reason) {
    return 'Не удалось построить путь: $reason';
  }

  @override
  String get routePlanRoute => 'Построить маршрут';

  @override
  String get routeStatsTitle => 'Сводка маршрута';

  @override
  String get routeStatsDistance => 'Дистанция';

  @override
  String get routeStatsEta => 'ETA';

  @override
  String get routeStatsWaypointCount => 'Точки';

  @override
  String routeStatsDistanceValue(String nm) {
    return '$nm м.м.';
  }

  @override
  String get routeStatsEtaUnknown => '—';

  @override
  String routeStatsEtaMinutes(int minutes) {
    return '$minutes мин';
  }

  @override
  String routeStatsEtaHours(int hours) {
    return '$hours ч';
  }

  @override
  String routeStatsEtaHoursMinutes(int hours, int minutes) {
    return '$hours ч $minutes мин';
  }

  @override
  String routeStatsWaypointCountValue(int count) {
    return '$count';
  }

  @override
  String get routeWaypointListTitle => 'Точки маршрута';

  @override
  String get routeWaypointEmpty => 'Нет точек. Добавьте их на карте.';

  @override
  String routeWaypointDefaultName(int index) {
    return 'Т$index';
  }

  @override
  String get routeSafetyOk =>
      'Проверка глубины по точкам пройдена (демо-сетка).';

  @override
  String routeSafetyShallow(int index) {
    return 'Мелководье у Т$index: осадка + запас превышают глубину по демо-сетке.';
  }

  @override
  String get routeShowCorridor => 'Коридор безопасности';

  @override
  String get routeShowCorridorSubtitle =>
      'Зелёный буфер ±50 м вокруг маршрута на карте';

  @override
  String get mooringScreenTitle => 'Стоянка (марины и якорные)';

  @override
  String get mooringKindMarina => 'Марина';

  @override
  String get mooringKindAnchorage => 'Якорная стоянка';

  @override
  String get mooringKindBuoy => 'Буй';

  @override
  String get mooringViewList => 'Список';

  @override
  String get mooringSortDistance => 'Расстояние';

  @override
  String get mooringSortRating => 'Рейтинг';

  @override
  String get mooringDepthUnknown => 'Глубина н/д';

  @override
  String mooringDistanceNm(String distance) {
    return '$distance м.миль';
  }

  @override
  String get mooringEmptyFiltered => 'Снимите фильтры или измените поиск.';

  @override
  String get mooringVhf => 'УКВ';

  @override
  String get mooringPhone => 'Телефон';

  @override
  String get mooringServices => 'Услуги / свойства';

  @override
  String get mooringNotes => 'Примечания';

  @override
  String get mooringReviewTitle => 'Отзыв (офлайн-черновик)';

  @override
  String get mooringReviewStars => 'Оценка';

  @override
  String get mooringReviewComment => 'Комментарий (локально до синхронизации)';

  @override
  String get mooringReviewSave => 'Сохранить черновик';

  @override
  String get mooringReviewQueued =>
      'Отзыв сохранён в очереди. На этой вкладке нажмите «Отправить отзывы», когда есть сеть (в MVP используется локальный приёмник до подключения сервера).';

  @override
  String get mooringDetailClose => 'Закрыть';

  @override
  String get mooringEmptyCatalog => 'Нет загруженных объектов стоянки.';

  @override
  String get mooringGdprHint =>
      'Текст комментария остаётся на устройстве до выгрузки; в журнал аудита попадают только идентификаторы и оценка.';

  @override
  String get mooringPendingSectionTitle => 'Очередь отзывов (офлайн)';

  @override
  String get mooringCatalogSectionTitle => 'Справочник';

  @override
  String mooringPendingReviewLine(String placeId, int stars, String time) {
    return '$placeId · $stars ★ · $time';
  }

  @override
  String get mooringEmail => 'Эл. почта';

  @override
  String get mooringWebsite => 'Сайт';

  @override
  String get mooringBook => 'Бронирование';

  @override
  String get mooringOpenMap => 'На карте';

  @override
  String get mooringCall => 'Позвонить';

  @override
  String get mooringSyncPending => 'Отправить отзывы';

  @override
  String mooringSyncDone(int count) {
    return 'Отправлено черновиков: $count.';
  }

  @override
  String mooringSyncFailed(int count) {
    return 'Не удалось отправить часть черновиков ($count).';
  }

  @override
  String get mooringSearchHint => 'Поиск по названию';

  @override
  String get mooringSearchNoResults => 'Ничего не найдено.';

  @override
  String get mooringSvcElectricity => 'Электричество';

  @override
  String get mooringSvcWater => 'Вода';

  @override
  String get mooringSvcWifi => 'Wi‑Fi';

  @override
  String get mooringSvcFuel => 'Топливо';

  @override
  String get mooringSvcProtection => 'Защита от ветра';

  @override
  String get mooringSvcHolding => 'Держание грунта';

  @override
  String get logbookTitle => 'Судовой журнал';

  @override
  String get logbookEmpty =>
      'Записей пока нет. Нажмите +, чтобы добавить топливо, ТО или заметку.';

  @override
  String get logbookAddEntry => 'Добавить запись';

  @override
  String get logbookCategory => 'Категория';

  @override
  String get logbookCategoryNote => 'Заметка / общее';

  @override
  String get logbookCategoryFuel => 'Топливо';

  @override
  String get logbookCategoryMaintenance => 'Техобслуживание';

  @override
  String get logbookCategoryWatch => 'Вахта / передача';

  @override
  String get logbookCategoryOther => 'Прочее';

  @override
  String get logbookEntryTitle => 'Заголовок';

  @override
  String get logbookEntryBody => 'Подробности';

  @override
  String get logbookSave => 'Сохранить';

  @override
  String get logbookCancel => 'Отмена';

  @override
  String get logbookExportCsv => 'Экспорт CSV';

  @override
  String get logbookExportCopied =>
      'CSV скопирован в буфер — вставьте в таблицу или файл.';

  @override
  String get logbookDeleteTitle => 'Удалить запись';

  @override
  String get logbookDeleteConfirm => 'Удалить эту запись с устройства?';

  @override
  String get logbookDelete => 'Удалить';

  @override
  String get logbookEntryDeleted => 'Запись удалена.';

  @override
  String get logbookCrewNoDelete =>
      'Удалять записи журнала может только капитан на этом устройстве.';

  @override
  String get moreMenuHeadline => 'Безопасность, журнал и экипаж';

  @override
  String get moreMenuLogbook => 'Судовой журнал';

  @override
  String get moreMenuSos => 'SOS / бедствие';

  @override
  String get moreMenuTrack => 'Запись трека';

  @override
  String get moreMenuChecklists => 'Чек-листы';

  @override
  String get moreMenuVault => 'Документы в сейфе';

  @override
  String get moreMenuCrew => 'Экипаж и судно';

  @override
  String get sosTitle => 'Бедствие (SOS)';

  @override
  String get sosBody =>
      'Использовать только при реальной ЧС. Тест записывает событие critical в аудит и не открывает SMS/email.';

  @override
  String get sosTestMode => 'Тестовый режим (без отправки)';

  @override
  String get sosVesselName => 'Название судна';

  @override
  String get sosSmsNumber => 'Номер SMS (E.164, необязательно)';

  @override
  String get sosRegionRescue => 'Спасслужба региона (только справочно)';

  @override
  String get sosOpenSettings => 'Параметры';

  @override
  String get sosStep1 => 'Я понимаю: это только для реального бедствия';

  @override
  String get sosStep2 => 'Удерживайте кнопку 2 секунды';

  @override
  String get sosHold => 'УДЕРЖИВАТЬ ДЛЯ АКТИВАЦИИ';

  @override
  String get sosAfterTest => 'Тест зафиксирован. Сообщения не отправлялись.';

  @override
  String get sosAfterLive =>
      'При указанном номере может открыться черновик SMS.';

  @override
  String get sosNoNumber => 'Укажите номер SMS выше или скопируйте текст.';

  @override
  String get sosCopyMessage => 'Копировать текст';

  @override
  String get sosMessageCopied => 'Текст скопирован.';

  @override
  String get sosTypeLabel => 'Тип ЧС';

  @override
  String get sosTypeMedical => 'Медицинская';

  @override
  String get sosTypeFire => 'Пожар';

  @override
  String get sosTypeSinking => 'Затопление';

  @override
  String get sosTypeManOverboard => 'Человек за бортом';

  @override
  String get sosMessagePreview => 'Предпросмотр сообщения';

  @override
  String get sosCoordsPending => 'Определение координат…';

  @override
  String get sosTimerActive => 'Бедствие активно';

  @override
  String get sosTimerElapsed => 'Прошло';

  @override
  String get trackTitle => 'Трек рейса';

  @override
  String get trackRecordingActive => 'Запись…';

  @override
  String get trackIdle => 'Запись выключена';

  @override
  String get trackStart => 'Начать запись';

  @override
  String get trackStop => 'Стоп и сохранить';

  @override
  String trackPoints(int count) {
    return '$count точек';
  }

  @override
  String get trackStatsPoints => 'Точки';

  @override
  String get trackStatsDuration => 'Длительность';

  @override
  String get trackEmptyTrips => 'Нет сохранённых рейсов';

  @override
  String get trackEmptyTripsMessage =>
      'После остановки записи рейс появится здесь.';

  @override
  String get checklistsTitle => 'Чек-листы безопасности';

  @override
  String get checklistTplDeparture => 'Перед выходом в море';

  @override
  String get checklistTplDocking => 'Швартовка';

  @override
  String get checklistTplStorm => 'Штормовая готовность';

  @override
  String get checklistComplete => 'Отметить всё выполненным';

  @override
  String get checklistCompletedAudit => 'Чек-лист завершён.';

  @override
  String get vaultTitle => 'Сейф документов';

  @override
  String get vaultPinSetupTitle => 'Задайте PIN сейфа';

  @override
  String get vaultPinUnlockTitle => 'Разблокировать сейф';

  @override
  String get vaultPinHint => 'Рекомендуется 4–12 цифр';

  @override
  String get vaultPinConfirmLabel => 'Повторите PIN';

  @override
  String get vaultUnlock => 'Разблокировать';

  @override
  String get vaultLockedHint => 'Файлы шифруются на устройстве PIN-кодом.';

  @override
  String get vaultEmpty => 'Зашифрованных файлов пока нет.';

  @override
  String get vaultPickFile => 'Выбрать файл';

  @override
  String get vaultEncryptedBadge => 'Зашифровано';

  @override
  String get vaultDecryptPreview => 'Проверить расшифровку';

  @override
  String get vaultDeleteForbidden => 'Удалять файлы может только капитан.';

  @override
  String get crewTitle => 'Экипаж и судно';

  @override
  String get crewCreateShip => 'Создать судно и код приглашения';

  @override
  String get crewJoinShip => 'Вступить по коду';

  @override
  String get crewInviteExplain =>
      'Передайте код — на другом устройстве введите его для того же ship ID.';

  @override
  String get crewLeave => 'Покинуть судно';

  @override
  String get crewRoleCaptain => 'Капитан';

  @override
  String get crewRoleCrew => 'Экипаж';

  @override
  String get moreMenuSettings => 'Настройки';

  @override
  String get settingsAccessibilitySection => 'Доступность';

  @override
  String get settingsGloveMode => 'Режим перчатки';

  @override
  String get settingsGloveModeSubtitle => 'Крупнее кнопки и зоны нажатия';

  @override
  String get settingsTextSize => 'Размер текста';

  @override
  String get settingsTextSizeStandard => 'Обычный';

  @override
  String get settingsTextSizeLarge => 'Крупный';

  @override
  String get settingsTextSizeExtraLarge => 'Очень крупный';

  @override
  String get settingsHighContrast => 'Высокий контраст';

  @override
  String get settingsNightWatch => 'Ночная вахта (красный)';

  @override
  String get settingsNightWatchSubtitle =>
      'Красный интерфейс для сохранения ночного зрения';

  @override
  String get settingsNightWatchChartNightHint =>
      'Совет: Слои карты → Карта → Ночь хорошо сочетается с этой темой.';

  @override
  String get settingsNightWatchChartDayHint =>
      'Совет: Слои карты → Карта → Стандарт для дневной палитры.';

  @override
  String get settingsEnergySection => 'Батарея и GPS';

  @override
  String get settingsVesselSection => 'Судно';

  @override
  String get settingsDisplaySection => 'Интерфейс';

  @override
  String get settingsAboutSection => 'О приложении';

  @override
  String get settingsVesselName => 'Название судна';

  @override
  String settingsVesselLoa(String unit) {
    return 'Длина ($unit)';
  }

  @override
  String settingsVesselDraft(String unit) {
    return 'Осада ($unit)';
  }

  @override
  String get settingsVesselType => 'Тип корпуса';

  @override
  String get settingsVesselTypeSailing => 'Парусная яхта';

  @override
  String get settingsVesselTypeMotor => 'Моторная яхта';

  @override
  String get settingsVesselTypeCatamaran => 'Катамаран';

  @override
  String get settingsVesselTypeOther => 'Другое';

  @override
  String get settingsUnits => 'Единицы';

  @override
  String get settingsUnitsMetric => 'Метрические';

  @override
  String get settingsUnitsImperial => 'Имперские';

  @override
  String get settingsTheme => 'Тема';

  @override
  String get settingsThemeDeck => 'Палуба';

  @override
  String get settingsThemeNightRed => 'Ночь (красная)';

  @override
  String get settingsThemeHighContrast => 'Высокий контраст';

  @override
  String get settingsAboutAppName => 'Captain Wrongel';

  @override
  String settingsAboutVersion(String version) {
    return 'Версия $version';
  }

  @override
  String get settingsAboutTagline =>
      'Офлайн-навигатор для яхт. Не для основной навигации.';

  @override
  String get energyProfileEco => 'Эко-проход';

  @override
  String get energyProfilePassage => 'Сбалансированный';

  @override
  String get energyProfileSport => 'Точность';

  @override
  String get energyProfileEcoDescription =>
      'Реже точки трека и меньше работы карты в фоне.';

  @override
  String get energyProfilePassageDescription =>
      'Баланс для прибрежного плавания.';

  @override
  String get energyProfileSportDescription =>
      'Чаще точки трека и быстрее обновление AIS-демо.';

  @override
  String get moreMenuKnots => 'Справочник узлов';

  @override
  String get knotsTitle => 'Морские узлы';

  @override
  String get knotsSearchHint => 'Поиск узла';

  @override
  String get knotsLoadError => 'Не удалось загрузить каталог узлов.';

  @override
  String get knotsEmpty => 'Каталог узлов пуст.';

  @override
  String get knotsNoMatch => 'Ничего не найдено.';

  @override
  String get knotStepsHeading => 'Шаги';

  @override
  String get knotCategoryLoops => 'Петли';

  @override
  String get knotCategoryBends => 'Соединение концов';

  @override
  String get knotCategoryHitches => 'Штыки и крепления';

  @override
  String get knotCategoryStoppers => 'Стопорные узлы';

  @override
  String get knotCategoryEmergency => 'Аварийные';

  @override
  String get knotCategoryAll => 'Все';

  @override
  String get knotCategoryFavorites => 'Избранное';

  @override
  String get knotDifficultyEasy => 'Легко';

  @override
  String get knotDifficultyMedium => 'Средне';

  @override
  String get knotDifficultyHard => 'Сложно';

  @override
  String get knotAddFavorite => 'В избранное';

  @override
  String get knotRemoveFavorite => 'Убрать из избранного';

  @override
  String get moreMenuToolbox => 'Морская мастерская';

  @override
  String get moreMenuToolboxSubtitle =>
      'Якорь, компас, GRIB, берег, радио, медицина, расходы…';

  @override
  String get toolboxTitle => 'Морская мастерская';

  @override
  String get toolboxLead =>
      'Учебные и безопасностные утилиты; не замена сертифицированному оборудованию и скорой помощи.';

  @override
  String get toolboxAnchorWatch => 'Якорная вахта';

  @override
  String get toolboxCompass => 'Компас и солнце';

  @override
  String get toolboxGrib => 'Файлы GRIB (импорт)';

  @override
  String get toolboxCoastal => 'Прибрежный гид (POI)';

  @override
  String get toolboxVhf => 'УКВ и COLREG';

  @override
  String get toolboxMedical => 'Медицинский глоссарий';

  @override
  String get toolboxExpenses => 'Судовая касса';

  @override
  String get toolboxSectionNavigation => 'Навигация';

  @override
  String get toolboxSectionSafety => 'Безопасность';

  @override
  String get toolboxSectionReference => 'Справочник';

  @override
  String get badgeNew => 'НОВ';

  @override
  String get anchorWatchTitle => 'Якорная вахта';

  @override
  String get anchorWatchHint =>
      'Отметьте точку якоря на GPS, задайте радиус и включите контроль. Тревога при срыве за круг. Решение о якорном оснащении — на капитане.';

  @override
  String get anchorWatchRadius => 'Допустимый радиус';

  @override
  String get anchorWatchDistance => 'Дистанция до якоря';

  @override
  String get anchorWatchDrop => 'Зафиксировать якорь (GPS)';

  @override
  String get anchorWatchArm => 'Включить вахту';

  @override
  String get anchorWatchDisarm => 'Выключить';

  @override
  String get anchorWatchClear => 'Сбросить точку якоря';

  @override
  String get anchorWatchAlarmBanner => 'СУДНО ВЫШЛО ЗА ПРЕДЕЛЫ КРУГА';

  @override
  String get anchorWatchDismissAlarm => 'Подтвердить';

  @override
  String get anchorWatchGpsLost =>
      'Нет свежей GPS-навигации — проверьте приёмник и небо.';

  @override
  String get anchorWatchMapPlaceholder =>
      'Отметьте якорь, чтобы показать зону на карте';

  @override
  String get anchorWatchInZone => 'В ЗОНЕ';

  @override
  String get anchorWatchDrifting => 'СНОС';

  @override
  String get anchorWatchDisarmed => 'Вахта выкл.';

  @override
  String get anchorWatchArmedBadge => 'ВАХТА';

  @override
  String get compassTitle => 'Компас и солнце';

  @override
  String get compassDisclaimer =>
      'Компас по датчикам устройства; восход/закат приблизительные.';

  @override
  String get compassUnavailablePlatform =>
      'Компас недоступен на этой платформе.';

  @override
  String get compassHeadingLabel => 'Курс (склонение не учтено)';

  @override
  String get astroSectionTitle =>
      'Приблизительный восход и закат (UTC → локальное время)';

  @override
  String get astroNeedGps => 'Нужна GPS-позиция для расчёта.';

  @override
  String get astroSunrise => 'Восход';

  @override
  String get astroSunset => 'Закат';

  @override
  String get gribTitle => 'Импорт GRIB';

  @override
  String get gribStubBody =>
      'Декодер GRIB в приложении пока не встроен. Можно сохранить путь к файлу для будущего просмотра офлайн.';

  @override
  String get gribLastPath => 'Последний путь (заглушка)';

  @override
  String get gribSimulatePick => 'Симулировать выбор GRIB';

  @override
  String get gribStubSaved => 'Путь сохранён локально.';

  @override
  String get gribEmpty => 'Файлы GRIB ещё не импортированы.';

  @override
  String get gribImport => 'Импортировать GRIB';

  @override
  String get gribStatusPending => 'Ожидает декодирования';

  @override
  String get coastalGuideTitle => 'Прибрежные POI';

  @override
  String get coastalLoadError => 'Не удалось загрузить POI.';

  @override
  String get coastalEmpty => 'Нет прибрежных точек.';

  @override
  String get coastalSearchHint => 'Поиск береговых POI';

  @override
  String get coastalNoMatch => 'Нет точек по вашим фильтрам.';

  @override
  String get coastalCategoryAll => 'Все';

  @override
  String get coastalCategoryBeach => 'Пляж';

  @override
  String get coastalCategoryFuel => 'Топливо';

  @override
  String get coastalCategoryMarina => 'Марина';

  @override
  String get coastalCategoryRestaurant => 'Ресторан';

  @override
  String get coastalCategoryAttraction => 'Достопримечательность';

  @override
  String get coastalCategoryOther => 'Другое';

  @override
  String coastalCoordinates(String lat, String lon) {
    return '$lat°, $lon°';
  }

  @override
  String get medicalGlossaryTitle => 'Медицинский глоссарий';

  @override
  String get medicalDisclaimer =>
      'Только справочные сведения — при угрозе жизни вызывайте помощь.';

  @override
  String get medicalLoadError => 'Не удалось загрузить глоссарий.';

  @override
  String get vhfTrainingTitle => 'УКВ и COLREG';

  @override
  String get vhfTabScenarios => 'Сценарии';

  @override
  String get vhfTabQuiz => 'Викторина COLREG';

  @override
  String get vhfTabSessions => 'Записи';

  @override
  String get vhfScenariosLoadError => 'Не удалось загрузить сценарии УКВ.';

  @override
  String get vhfScenariosEmpty => 'Нет доступных сценариев УКВ.';

  @override
  String get vhfScenarioPickHint =>
      'Выберите сценарий для отработки радиообмена.';

  @override
  String get vhfScenarioBack => 'Все сценарии';

  @override
  String get vhfDifficultyBeginner => 'Начальный';

  @override
  String get vhfDifficultyIntermediate => 'Средний';

  @override
  String get vhfDifficultyAdvanced => 'Продвинутый';

  @override
  String get vhfDialogueShore => 'Берег';

  @override
  String get vhfDialogueYou => 'Вы';

  @override
  String vhfQuizProgress(int current, int total) {
    return 'Вопрос $current из $total';
  }

  @override
  String get vhfQuizPickAnswer => 'Сначала выберите ответ.';

  @override
  String get vhfSessionsHint =>
      'Записи только на устройстве. Расшифровка — через микрофон (пересказ), не из файла.';

  @override
  String get vhfSessionsLoadError => 'Не удалось загрузить записи.';

  @override
  String get vhfSessionsEmpty => 'Записей УКВ пока нет.';

  @override
  String get vhfRecordStart => 'Запись';

  @override
  String get vhfRecordStop => 'Стоп';

  @override
  String get vhfRecordWebUnsupported => 'В веб-сборке запись недоступна.';

  @override
  String get vhfTranscribeHint =>
      'Микрофон: произнесите краткое содержание для текста. Дословная расшифровка файла — вне MVP.';

  @override
  String get vhfTranscribeDone => 'Текст сохранён.';

  @override
  String get vhfQuizLoadError => 'Не удалось загрузить викторину.';

  @override
  String get vhfQuizEmpty => 'Нет вопросов.';

  @override
  String get vhfQuizWrong => 'Неверно — пересмотрите COLREG.';

  @override
  String get vhfQuizPrev => 'Назад';

  @override
  String get vhfQuizNext => 'Далее';

  @override
  String get vhfQuizDone => 'Готово';

  @override
  String get vhfQuizComplete => 'Последний ответ верный.';

  @override
  String get expensesTitle => 'Судовая касса';

  @override
  String get expensesDisclaimer =>
      'Суммы только на устройстве — синхронизации с берегом нет в MVP.';

  @override
  String get expensesLoadError => 'Не удалось загрузить расходы.';

  @override
  String get expenseAdd => 'Добавить расход';

  @override
  String get expenseSave => 'Сохранить';

  @override
  String get expenseAmount => 'Сумма';

  @override
  String get expenseNote => 'Примечание';

  @override
  String get expenseEmpty => 'Расходов пока нет.';

  @override
  String get expenseSummaryTitle => 'Итого по рейсу';

  @override
  String get expenseCatFuel => 'Топливо';

  @override
  String get expenseCatFood => 'Продукты';

  @override
  String get expenseCatMarina => 'Марина';

  @override
  String get expenseCatMooringFee => 'Швартовка';

  @override
  String get expenseCatGear => 'Снаряжение и ремонт';

  @override
  String get expenseCatProvisions => 'Провизия';

  @override
  String get expenseCatOther => 'Прочее';

  @override
  String get onboardingWelcomeTagline => 'Captain Wrongel';

  @override
  String get onboardingWelcomeTitle => 'Ваш помощник в каждом походе';

  @override
  String get onboardingWelcomeSubtitle =>
      'Офлайн-карты, погода, стоянки — всё на одной палубе.';

  @override
  String get onboardingNext => 'Далее';

  @override
  String get onboardingBack => 'Назад';

  @override
  String get onboardingGetStarted => 'Начать';

  @override
  String get onboardingPermissionsTitle => 'Разрешения';

  @override
  String get onboardingPermissionsBody =>
      'Геолокация нужна для карт, погоды и якорной вахты. Уведомления предупредят о дрейфе и изменении погоды.';

  @override
  String get onboardingLocationTitle => 'Геолокация';

  @override
  String get onboardingLocationButton => 'Разрешить геолокацию';

  @override
  String get onboardingNotificationTitle => 'Уведомления';

  @override
  String get onboardingNotificationButton => 'Разрешить уведомления';

  @override
  String get onboardingExperienceTitle => 'Ваш опыт';

  @override
  String get onboardingExperienceBody =>
      'Подстроим подсказки и настройки под ваш стиль плавания.';

  @override
  String get onboardingExperienceBeginner => 'Новичок';

  @override
  String get onboardingExperienceCruiser => 'Круизный';

  @override
  String get onboardingExperienceRacer => 'Гонщик';

  @override
  String get onboardingRegionTitle => 'Где вы ходите?';

  @override
  String get onboardingRegionBody =>
      'Приоритет карт и стоянок для вашего региона.';

  @override
  String get onboardingRegionMediterranean => 'Средиземноморье';

  @override
  String get onboardingRegionCaribbean => 'Карибы';

  @override
  String get onboardingRegionOther => 'Другое';
}
