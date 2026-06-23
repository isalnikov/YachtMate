# Step 12 — Route Screen UI Overhaul

| | |
|---|---|
| **requires** | step-01–07 |
| **phase** | C |
| **est. files** | 6 |

## Goal

Редизайн `route_screen.dart`: waypoint list panel, route stats card, safety depth check UI.

## Контекст

- `mobile/lib/features/route/route_screen.dart`
- `docs/ui/route.html`
- `plan/features/F01-maritime-charts-routes-sync.md`

## IN SCOPE

- `mobile/lib/features/route/widgets/waypoint_list_panel.dart`
- `mobile/lib/features/route/widgets/route_stats_card.dart`
- `mobile/lib/features/route/widgets/safety_check_banner.dart`
- Refactor route_screen layout

## OUT OF SCOPE

- Corridor polygon on map (step-13)
- A* algorithm changes

## Tasks

- [ ] Stats: distance nm, ETA, WP count
- [ ] WaypointList: reorder, delete swipe
- [ ] Safety banner: red if draft > depth grid
- [ ] CwButton «Plan route» primary

## Acceptance Criteria

- [ ] Existing route tests pass
- [ ] Advisory disclaimer gate preserved

---

## AGENT PROMPT

```
Step 12: Route screen UI — waypoint_list_panel, route_stats_card, safety_check_banner.
CwCard/CwButton components. Не менять domain routing logic. flutter test.
```
