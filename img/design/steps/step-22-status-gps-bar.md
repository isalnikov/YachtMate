# Step 22 — GPS Status Bar

| | |
|---|---|
| **requires** | step-09 |
| **phase** | D |
| **est. files** | 4 |

## Goal

Glanceable status pill на карте: GPS fix, accuracy, speed, battery-aware indicator.

## Контекст

- `mobile/lib/features/map/map_screen.dart`
- `mobile/lib/core/` energy profile providers

## IN SCOPE

- `mobile/lib/features/map/widgets/map_status_pill.dart`
- `mobile/lib/features/map/widgets/gps_fix_indicator.dart`
- Integration in map_screen top center

## OUT OF SCOPE

- AIS signal indicator
- Cell signal (platform specific)

## Tasks

- [ ] Pill: semi-transparent panelBlue, h32, rounded full
- [ ] GPS: green dot fix / amber searching / red denied
- [ ] Show accuracy ±m, SOG kn when moving
- [ ] Tap → opens location settings hint

## Acceptance Criteria

- [ ] Visible on map, hidden on other tabs
- [ ] Eco mode shows leaf icon

---

## AGENT PROMPT

```
Step 22: map_status_pill + gps_fix_indicator на map_screen.
GPS accuracy, SOG, eco indicator. flutter test.
```
