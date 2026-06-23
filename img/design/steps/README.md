# Пошаговый план реализации UI

**28 шагов** · один шаг = одна кодер-сессия ИИ (~200k токенов)

## Матрица шагов

| # | Файл | Фаза | Зависит от | Оценка файлов |
|---|------|------|------------|---------------|
| 01 | [step-01-design-tokens.md](step-01-design-tokens.md) | A | — | 3–5 |
| 02 | [step-02-typography-spacing.md](step-02-typography-spacing.md) | A | 01 | 3–4 |
| 03 | [step-03-buttons.md](step-03-buttons.md) | A | 01–02 | 4–6 |
| 04 | [step-04-cards-lists.md](step-04-cards-lists.md) | A | 01–02 | 4–6 |
| 05 | [step-05-inputs.md](step-05-inputs.md) | A | 01–03 | 4–6 |
| 06 | [step-06-feedback-sheets.md](step-06-feedback-sheets.md) | A | 01–04 | 5–7 |
| 07 | [step-07-app-bar-nav.md](step-07-app-bar-nav.md) | A | 01–06 | 4–6 |
| 08 | [step-08-onboarding.md](step-08-onboarding.md) | B | 01–07 | 6–8 |
| 09 | [step-09-map-controls.md](step-09-map-controls.md) | C | 01–07 | 5–8 |
| 10 | [step-10-map-layers-sheet.md](step-10-map-layers-sheet.md) | C | 09 | 4–6 |
| 11 | [step-11-map-bottom-sheet.md](step-11-map-bottom-sheet.md) | C | 09–10 | 4–6 |
| 12 | [step-12-route-screen.md](step-12-route-screen.md) | C | 01–07 | 5–7 |
| 13 | [step-13-route-corridor.md](step-13-route-corridor.md) | C | 12 | 4–6 |
| 14 | [step-14-weather-timeline.md](step-14-weather-timeline.md) | C | 01–07 | 5–7 |
| 15 | [step-15-weather-wind-rose.md](step-15-weather-wind-rose.md) | C | 14 | 4–6 |
| 16 | [step-16-tides-screen.md](step-16-tides-screen.md) | C | 14 | 5–7 |
| 17 | [step-17-mooring-list.md](step-17-mooring-list.md) | C | 04 | 5–7 |
| 18 | [step-18-mooring-detail.md](step-18-mooring-detail.md) | C | 17 | 4–6 |
| 19 | [step-19-anchor-watch.md](step-19-anchor-watch.md) | D | 09 | 5–7 |
| 20 | [step-20-ais-screen.md](step-20-ais-screen.md) | D | 09–11 | 6–8 |
| 21 | [step-21-sos-emergency.md](step-21-sos-emergency.md) | D | 03, 06 | 4–5 |
| 22 | [step-22-status-gps-bar.md](step-22-status-gps-bar.md) | D | 09 | 3–5 |
| 23 | [step-23-knots-ui.md](step-23-knots-ui.md) | E | 04 | 4–6 |
| 24 | [step-24-vhf-training-ui.md](step-24-vhf-training-ui.md) | E | 04, 06 | 5–7 |
| 25 | [step-25-toolbox-hub.md](step-25-toolbox-hub.md) | E | 04, 07 | 4–5 |
| 26 | [step-26-night-red-mode.md](step-26-night-red-mode.md) | F | 01 | 4–6 |
| 27 | [step-27-settings-vessel.md](step-27-settings-vessel.md) | F | 01–07 | 5–7 |
| 28 | [step-28-tablet-split-layout.md](step-28-tablet-split-layout.md) | F | 09–18 | 6–10 |

## Правила для агента

1. **Читать только** файлы из секции «Контекст» + прямые зависимости
2. **Не трогать** файлы из «OUT OF SCOPE»
3. **Запускать** `cd mobile && flutter test` перед завершением
4. **Коммит** только если пользователь попросил
5. Сверяться с `img/design/screenshot-findings.md` для визуала

## Фазы

- **A (01–07):** Design System — фундамент для всех экранов
- **B (08):** Onboarding
- **C (09–18):** Primary tabs polish
- **D (19–22):** Safety & AIS
- **E (23–25):** Toolbox & reference
- **F (26–28):** Themes & responsive
