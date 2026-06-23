# Step 11 — Map Bottom Sheet & Long-Press

| | |
|---|---|
| **requires** | step-09, step-10 |
| **phase** | C |
| **est. files** | 5 |

## Goal

Улучшить `map_long_press_sheet.dart` и collapsible bottom sheet с coords, depth, «Add waypoint», «Navigate here».

## Контекст

- `mobile/lib/features/map/map_long_press_sheet.dart`
- `mobile/lib/features/map/map_screen.dart`

## IN SCOPE

- `mobile/lib/features/map/widgets/map_context_sheet.dart`
- `mobile/lib/features/map/widgets/map_peek_sheet.dart` — DraggableScrollableSheet
- Refactor long press handler

## OUT OF SCOPE

- Route editor (step-12)

## Tasks

- [ ] Peek height 120dp: coords mono + depth label
- [ ] Expanded: actions list CwListTile
- [ ] Long press → haptic + sheet
- [ ] Coords copy to clipboard

## Acceptance Criteria

- [ ] Sheet draggable 0.15 → 0.5 screen height

---

## AGENT PROMPT

```
Step 11: Map peek sheet + context long-press sheet.
DraggableScrollableSheet, coords display CwTypography.monoCoords. flutter test.
```
