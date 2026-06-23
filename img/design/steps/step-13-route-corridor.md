# Step 13 — Route Corridor & Leg Labels

| | |
|---|---|
| **requires** | step-12 |
| **phase** | C |
| **est. files** | 5 |

## Goal

Визуализация маршрута как iSailor: purple line, green safety corridor, bearing/distance labels на сегментах.

## Контекст

- `mobile/lib/features/map/map_screen.dart`
- `mobile/lib/domain/routing/` 
- `img/design/screenshot-findings.md` — iSailor route

## IN SCOPE

- `mobile/lib/domain/routing/route_corridor.dart` — buffer polygon
- `mobile/lib/features/map/widgets/route_overlay_layer.dart`
- Map layer для corridor + leg labels
- `mobile/test/domain/route_corridor_test.dart`

## OUT OF SCOPE

- MapLibre symbol layers если слишком сложно — использовать Flutter overlay widgets

## Tasks

- [ ] Corridor: green 15% alpha, ±50m default
- [ ] Route line: purple #9B59B6 3px
- [ ] Leg label: «315° · 0.44 nm»
- [ ] Toggle corridor in route screen

## Acceptance Criteria

- [ ] Active route shows corridor on map
- [ ] Unit tests for buffer geometry

---

## AGENT PROMPT

```
Step 13: Route corridor polygon + leg labels на карте.
route_corridor.dart domain logic, route_overlay_layer на map. Tests. flutter test.
Референс iSailor screenshot-findings.md.
```
