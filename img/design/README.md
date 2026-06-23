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
| [steps/](steps/) | **Пошаговый план** — один шаг = одна кодер-сессия ИИ (~200k токенов) |

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

Уже реализовано (не дублировать в шагах, только **полировать**):

- 5-tab shell: Map | Route | Weather | Mooring | More
- 25+ экранов, Drift/SQLite, Riverpod, MapLibre
- Базовая тема `CwTheme` (deck blue + teal/orange)
- HTML-макеты: `docs/ui/`
- Фазы 0–8 в `plan/`

## Порядок выполнения

```
Фаза A (шаги 01–07)  → Design System
Фаза B (шаги 08–11)  → Shell & Onboarding
Фаза C (шаги 12–18) → Основные экраны
Фаза D (шаги 19–22) → Безопасность & AIS
Фаза E (шаги 23–25) → Справочники & обучение
Фаза F (шаги 26–28) → A11y, темы, адаптив
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
