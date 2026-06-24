# Step 62 — Wind Overlay Pan Refresh

| | |
|---|---|
| **requires** | step-47 |
| **phase** | K |
| **est. files** | 3 |

## Goal

Wind grid refetches when map center moves beyond grid cell threshold.

## IN SCOPE

- `onCameraIdle` wind sync in `map_screen.dart`
- `wind_grid_refresh.dart` threshold helper

## Acceptance Criteria

- [ ] Pan triggers refresh when center shifts > ~0.04°
- [ ] Unit test for threshold helper
