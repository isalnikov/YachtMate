# Captain Wrongel — дизайн-спецификация и план реализации

Папка создана на основе [`../img.md`](../img.md), анализа 40+ референс-приложений, скриншотов App Store и текущего состояния Flutter-приложения `mobile/`.

## Содержание

| Документ | Назначение |
|----------|------------|
| [competitive-analysis.md](competitive-analysis.md) | Конкурентный анализ UI/UX по категориям |
| [screenshot-findings.md](screenshot-findings.md) | Выводы из изученных скриншотов |
| [information-architecture.md](information-architecture.md) | IA, sitemap, user flows |
| [design-system-spec.md](design-system-spec.md) | Токены, компоненты, экраны (сводка) |
| [screenshots-manifest.json](screenshots-manifest.json) | Каталог скачанных скриншотов |
| [steps/](steps/) | **Пошаговый план 01–60** — один шаг = одна кодер-сессия ИИ (~200k токенов) |
| [phases-roadmap.md](phases-roadmap.md) | Roadmap фаз G–J (шаги 29–60) |

## Скриншоты

```
screenshots/
├── navigation/   navionics, isailor, inavx
├── weather/      windy, windy_app, windfinder, clime
├── mooring/      navily
├── tides/        tide_alert
├── reference/    knots
├── ais/          (MarineTraffic — без публичных скринов в API)
└── communication/
```

Всего **~55 изображений** из App Store (iTunes Lookup API).

## Принцип разбивки на шаги

Каждый файл `steps/step-NN-*.md` рассчитан на **одну автономную кодер-сессию** агента:

- **Контекст:** ≤200k токенов (чтение 5–15 файлов + генерация кода)
- **Выход:** рабочий код + тесты + без регрессий `flutter test`
- **Зависимости:** явно указаны в поле `requires`
- **Границы:** секции IN SCOPE / OUT OF SCOPE исключают расползание задачи

## Текущее состояние приложения

### ✅ Выполнено (шаги 01–28)

- Design system `Cw*` (токены, 15+ виджетов)
- Обновлены: Map, Route, Weather, Mooring, AIS, Anchor, SOS, Onboarding, Settings
- 226 тестов, tablet split, night red theme

### 🔲 Осталось (шаги 29–60)

| Фаза | Шаги | Суть |
|------|------|------|
| **G** UI Debt | 29–38 | Logbook, Track, Vault, Crew, Checklists, Compass, Coastal, Medical, Expenses, GRIB shell |
| **H** Data | 39–48 | Map tiles, live tides, GRIB decode, NMEA AIS, wind on map, offline charts |
| **I** Product | 49–54 | Community, voyage monitor, push, freemium, yacht hub, AI stub |
| **J** Polish | 55–60 | i18n EL/TR/PT, wind particles, errors, a11y, perf |

Подробно: [phases-roadmap.md](phases-roadmap.md)

## Порядок выполнения

```
01–28 ✅  Design System + primary tabs (DONE)
29–38     G — UI debt (вторичные экраны)
39–48     H — Data & maps wiring
49–54     I — Product modules
55–60     J — i18n, polish, perf
```

## Как запускать агента

1. Открыть `steps/step-NN-*.md`
2. Скопировать блок **AGENT PROMPT** в новую кодер-сессию
3. Убедиться, что все `requires` выполнены
4. После завершения — отметить чеклист в файле шага

## Связь с репозиторием

| Артефакт | Путь |
|----------|------|
| Flutter app | `mobile/` |
| HTML mockups | `docs/ui/` |
| Feature specs | `plan/features/F01–F14` |
| IDEAS2 modules M1–M14 | `plan/IDEAS2-structured.md` |
