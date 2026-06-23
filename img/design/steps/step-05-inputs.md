# Step 05 — Input Components

| | |
|---|---|
| **requires** | step-01–03 |
| **phase** | A |
| **est. files** | 5 |

## Goal

`CwTextField`, `CwSearchBar`, `CwCoordinateField` (D°M'S"), `CwSlider`, `CwSegmentedControl`.

## Контекст

- `mobile/lib/features/route/route_screen.dart` — draft input
- `img/design/design-system-spec.md` §3.4.2

## IN SCOPE

- `mobile/lib/widgets/cw_text_field.dart`
- `mobile/lib/widgets/cw_search_bar.dart`
- `mobile/lib/widgets/cw_coordinate_field.dart`
- `mobile/lib/widgets/cw_segmented_control.dart`
- `mobile/test/widgets/cw_coordinate_field_test.dart`
- Применить CwSearchBar в `mooring_screen.dart`

## OUT OF SCOPE

- Date/time picker (использовать showDatePicker themed)

## Tasks

- [ ] CwTextField: prefix/suffix icon, error text
- [ ] CwCoordinateField: parse/format DMS
- [ ] CwSegmentedControl: Map/List toggle pattern
- [ ] Themed InputDecoration из CwColors

## Acceptance Criteria

- [ ] Coordinate field: 36°37.5'N → valid LatLng parse

---

## AGENT PROMPT

```
Step 05: Input widgets CwTextField, CwSearchBar, CwCoordinateField, CwSegmentedControl.
Подключи CwSearchBar к mooring_screen. Tests для coordinate parse. flutter test.
```
