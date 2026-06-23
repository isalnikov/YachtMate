# Step 14 — Weather Timeline & Hour Cards

| | |
|---|---|
| **requires** | step-01–07 |
| **phase** | C |
| **est. files** | 6 |

## Goal

Windy-style timeline scrubber + horizontal hour cards на `weather_screen.dart`.

## Контекст

- `mobile/lib/features/weather/weather_screen.dart`
- `mobile/lib/domain/weather/open_meteo_parse.dart`
- `img/design/screenshot-findings.md` — Windy timeline

## IN SCOPE

- `mobile/lib/features/weather/widgets/weather_timeline_bar.dart`
- `mobile/lib/features/weather/widgets/weather_hour_card.dart`
- `mobile/lib/features/weather/widgets/wind_legend_bar.dart`
- Provider `selectedHourIndexProvider`
- Refactor weather_screen

## OUT OF SCOPE

- Wind rose (step-15)
- Map wind layer animation

## Tasks

- [ ] Timeline: 48h scroll, selected hour highlighted teal
- [ ] Hour card: wind kn, gust, direction arrow, temp
- [ ] Legend bar: 0–45 kts gradient from CwColors.windScale
- [ ] Tap hour → update detail section

## Acceptance Criteria

- [ ] Weather cache tests still pass
- [ ] Works offline with cached data

---

## AGENT PROMPT

```
Step 14: Weather timeline bar + hour cards + wind legend.
weather_screen refactor. Riverpod selectedHourIndex. flutter test.
Референс Windy в screenshot-findings.md.
```
