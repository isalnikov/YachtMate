# Step 15 — Wind Rose & Layer Switcher

| | |
|---|---|
| **requires** | step-14 |
| **phase** | C |
| **est. files** | 5 |

## Goal

`WindRoseWidget` + vertical layer toolbar (wind/waves/temp/pressure) на weather screen.

## Контекст

- `mobile/lib/features/weather/weather_screen.dart`
- `img/design/design-system-spec.md` — Wind rose component

## IN SCOPE

- `mobile/lib/features/weather/widgets/wind_rose.dart`
- `mobile/lib/features/weather/widgets/weather_layer_toolbar.dart`
- CustomPainter для rose
- Tests painter logic

## OUT OF SCOPE

- Animated particles (post-MVP)
- GRIB overlay

## Tasks

- [ ] Rose 160dp: direction arrow, speed rings
- [ ] Toolbar right: 44dp icon buttons
- [ ] Layer state provider
- [ ] Selected layer affects hour card emphasis

## Acceptance Criteria

- [ ] Rose rotates to wind direction from data
- [ ] Golden test or unit test for angles

---

## AGENT PROMPT

```
Step 15: WindRoseWidget CustomPainter + weather_layer_toolbar.
Интеграция в weather_screen. Tests. flutter test.
```
