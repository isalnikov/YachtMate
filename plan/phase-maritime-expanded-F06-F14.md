# План реализации F06, F09–F14 (морские модули)

> **Цель:** вынести в продукт обучающий/безопасностный контур: якорь, компас/астро, задел GRIB, прибрежные POI, УКВ+COLREG+записи+STT, медсправочник, касса рейса/берега (F14).

**Архитектура:** единая точка входа **Maritime toolbox** из «Ещё»; вложенные экраны по модулям; Drift для долгоживущих данных (расходы, метаданные записей УКВ); JSON-ассеты для справочников/квизов; `user_action_audit` на критичных действиях; микрофон/запись с platform-гвардами (web — деградация).

**Технологии:** `geolocator`, `flutter_compass` (iOS/Android; web — заглушка), `record` + `just_audio` (скорость `setSpeed`), `speech_to_text` (транскрипция; требуются разрешения), `file_picker` (GRIB-файл), существующий `Drift` + миграция `schemaVersion` 8+.

---

## Фаза A — инфраструктура (сделано в первом PR)

- [x] Зависимости: `flutter_compass`, `record`, `just_audio`, `speech_to_text`
- [x] `MaritimeToolboxScreen` + одна плитка в `More` вместо 7 отдельных пунктов
- [x] ARB (en/ru + копии для de/fr/es/it) + `flutter gen-l10n`
- [x] `plan/phase-maritime-expanded-F06-F14.md` (этот документ)

## F06 — Якорная вахта

| Шаг | Действие | Файлы / тесты |
|-----|----------|----------------|
| 1 | Утилита `haversineM` (м) | `lib/domain/anchor/geo.dart` |
| 2 | Prefs: `anchorLat`, `anchorLon`, `radiusM`, `armed` | `lib/core/anchor_watch_controller.dart` |
| 3 | `StateNotifier` + таймер/позиция, флаги: тревога, «потеря GPS» (таймаут) | `anchor_watch_controller.dart` |
| 4 | UI: сброс якоря, радиус, дистанция, снятие тревоги | `lib/features/anchor/anchor_watch_screen.dart` |
| 5 | Аудит: `anchor_drop`, `anchor_arm`, `anchor_disarm`, `anchor_alarm` | `AuditRepository` |
| 6 | Тест: `haversine` + логика дистанции / edge | `test/anchor_watch_test.dart` |

**Вне scope v1:** фоновый сервис 24/7, push, SMS; контур «соседи»; отдельный полигон (только **круг**).

## F09 — Цифровой компас + астро

| Шаг | Действие | Примечание |
|-----|----------|------------|
| 1 | Подписка на `FlutterCompass.events` (не web) | `compass_screen.dart` |
| 2 | Прибл. восход/закат (свой `domain/astro/solar_times.dart`) | не для офиц. навигации |
| 3 | GPS место для астро при отказе компаса — только текст широты для расчёта солнца | |

## F10 — GRIB офлайн

| Шаг | Действие |
|-----|----------|
| 1 | Экран: объяснение MVP, выбор файла через `file_picker`, сохранение пути в prefs |
| 2 | Без декодирования GRIB в бандле — явный текст «decoder post-MVP (ecCodes)» |

## F11 — Прибрежный гид POI

| Шаг | Действие |
|-----|----------|
| 1 | `assets/coastal/shore_poi_demo.geojson` (минимум точек) |
| 2 | Парсер списка как у марин (упрощённый) |
| 3 | `CoastalGuideScreen` — список + поиск |

## F12 — УКВ / COLREG / записи

| Шаг | Действие |
|-----|----------|
| 1 | JSON `assets/training/colreg_quiz_demo.json` — викторина |
| 2 | Запись: `AudioRecorder`, файлы под `app dir`/`vhf/` |
| 3 | Таблица Drift `vhf_recordings`: путь, дата, транскрипт |
| 4 | Воспроизведение `AudioPlayer.setSpeed()` (быстро/медленно) |
| 5 | Транскрипт: `speech_to_text.listen` по кнопке после записи или повтор воспроизведения через таймер |

**Ограничение:** качество STT зависит от ОС; офлайн STT не гарантирован — дисклеймер в UI.

## F13 — Медицина / жаргон / IMO

| Шаг | Действие |
|-----|----------|
| 1 | `assets/reference/medical_glossary_demo.json` |
| 2 | Экран списка по категориям как у узлов |

## F14 — Касса рейса / мониторинг берега (MVP данных)

| Шаг | Действие |
|-----|----------|
| 1 | Таблица `expense_entries`: сумма minor unit, валюта, категория (fuel, food, marina, gear, other), заметка, время |
| 2 | Репозиторий + простой отчёт «по категориям» и список |
| 3 | Экран **Voyager cashbook** + аудит добавления траты |

**Вне scope v1:** синк с сервером SafeTrx-like, шаринг с берегом в реальном времени.

---

## Контроль качества

- После каждого блока: `dart run build_runner build` (Drift), `flutter analyze`, `flutter test`
- Разрешения Android/iOS для микрофона вручную при необходимости в нативных конфигах (минимально — через `permission_handler` уже в проекте)

## Порядок внедрения в коде (итерации)

1. Toolbox + F06  
2. F09  
3. F11 + F13 (JSON-экраны)  
4. F12 (Drift + запись + плеер + STT)  
5. F10 stub  
6. F14 Drift + UI  

После первого merge можно расширять декодер GRIB, якорный контур, УКВ-сценарии.
