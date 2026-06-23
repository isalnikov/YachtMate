# Step 16 — Tides Dedicated Screen

| | |
|---|---|
| **requires** | step-14 |
| **phase** | C |
| **est. files** | 6 |

## Goal

Отдельный экран/вкладка приливов: sine curve, HW/LW table, moon phase, sun times.

## Контекст

- `mobile/assets/tides/demo_tides.json`
- `mobile/lib/domain/weather/tide_demo_models.dart`
- `mobile/lib/features/weather/weather_screen.dart` — текущий tide block

## IN SCOPE

- `mobile/lib/features/tides/tides_screen.dart`
- `mobile/lib/features/tides/widgets/tide_curve_chart.dart`
- `mobile/lib/features/tides/widgets/tide_table.dart`
- Entry from weather screen «See all tides» + More menu link
- l10n keys

## OUT OF SCOPE

- Live tide API integration
- Current atlas maps

## Tasks

- [ ] TideCurveChart: CustomPainter smooth curve
- [ ] Markers HW/LW with time labels
- [ ] Table 7 days
- [ ] Moon phase icon row
- [ ] Sunrise/sunset from suncalc if available

## Acceptance Criteria

- [ ] Navigate Weather → Tides → back
- [ ] Demo data renders correctly

---

## AGENT PROMPT

```
Step 16: TidesScreen с tide_curve_chart, tide_table, moon phase.
Данные из demo_tides.json. Link from weather_screen. l10n. flutter test.
```
