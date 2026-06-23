# Step 47 — Wind Layer On Map

| | |
|---|---|
| **requires** | step-14, step-39 |
| **phase** | H |
| **est. files** | 4 |

## Goal

Wind speed raster or arrows overlay on map from Open-Meteo / cache.

## Контекст

- См. `plan/features/` для доменной логики
- `img/design/screenshot-findings.md` где применимо

## IN SCOPE

- `map_wind_overlay_layer.dart`
- `weather_repository wind grid`

## OUT OF SCOPE

- Windy particles step-57

## Tasks

- [ ] Toggle in weather layer toolbar
- [ ] Color scale from windScale
- [ ] Eco mode throttles refresh

## Acceptance Criteria

- [ ] Wind layer visible on map tab

---

## AGENT PROMPT

```
Step 47 Captain Wrongel: Wind field overlay on map from cached forecast.
Requires step-14, step-39. Run flutter test.
```
