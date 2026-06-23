# Step 28 — Tablet Split Layout

| | |
|---|---|
| **requires** | step-09–18 |
| **phase** | F |
| **est. files** | 8 |

## Goal

На планшетах ≥768px: split view map+panel для Mooring, Weather, Route (Navionics/iPad pattern).

## Контекст

- `mobile/lib/features/shell/shell_screen.dart`
- `mobile/test/shell_wide_layout_test.dart`
- `img/design/screenshot-findings.md` — Navionics split-screen

## IN SCOPE

- `mobile/lib/widgets/cw_split_view.dart` — master/detail
- `mobile/lib/features/mooring/mooring_screen.dart` — split mode
- `mobile/lib/features/weather/weather_screen.dart` — split mode
- `mobile/lib/features/route/route_screen.dart` — split mode
- Update wide layout tests

## OUT OF SCOPE

- Phone layout changes
- Desktop Linux specific

## Tasks

- [ ] CwSplitView: left 60% map/content, right 40% panel
- [ ] Mooring: map + list side by side
- [ ] Weather: timeline + detail panel
- [ ] Route: map + waypoint list
- [ ] Breakpoint 768 via LayoutBuilder

## Acceptance Criteria

- [ ] shell_wide_layout_test passes
- [ ] Phone single-column unchanged

---

## AGENT PROMPT

```
Step 28: CwSplitView для tablet ≥768px на mooring, weather, route screens.
Master-detail layout. Update shell_wide_layout_test. flutter test.
```
