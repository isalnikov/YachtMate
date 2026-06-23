# Step 10 — Map Layer Sheet (Navionics-style)

| | |
|---|---|
| **requires** | step-06, step-09 |
| **phase** | C |
| **est. files** | 5 |

## Goal

Переделать `map_layer_sheet.dart`: grid overlay thumbnails, sections OVERLAYS / CHART / SHALLOW.

## Контекст

- `mobile/lib/features/map/map_layer_sheet.dart`
- `img/design/screenshots/navigation/navionics_4.png`
- `screenshot-findings.md` — Map Options spec

## IN SCOPE

- `mobile/lib/features/map/widgets/layer_thumbnail_grid.dart`
- `mobile/lib/features/map/widgets/map_layer_sheet.dart` (refactor)
- Layer model enum update if needed
- Tests

## OUT OF SCOPE

- Новые tile sources
- SonarChart real data

## Tasks

- [ ] Grid 4 col: thumbnail 72×72 + label
- [ ] Selected: 2px teal border
- [ ] Sections with CwSectionHeader caps
- [ ] Shallow highlight toggle switch
- [ ] Night chart mode toggle (links step-26 later)

## Acceptance Criteria

- [ ] Sheet opens from layers FAB
- [ ] Selection persists in provider

---

## AGENT PROMPT

```
Step 10: Navionics-style Map Layer Sheet с thumbnail grid.
Рефактор map_layer_sheet + layer_thumbnail_grid. CwBottomSheet wrapper.
flutter test.
```
