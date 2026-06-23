# Step 25 — Toolbox Hub Redesign

| | |
|---|---|
| **requires** | step-04, step-07 |
| **phase** | E |
| **est. files** | 4 |

## Goal

`maritime_toolbox_screen.dart` → grid 2 col с иконками, badges «NEW», grouped sections.

## Контекст

- `mobile/lib/features/toolbox/maritime_toolbox_screen.dart`
- `docs/ui/tools.html`

## IN SCOPE

- `mobile/lib/features/toolbox/widgets/toolbox_grid_item.dart`
- Refactor toolbox screen layout
- Sections: Navigation | Safety | Reference

## OUT OF SCOPE

- New toolbox modules
- GRIB implementation

## Tasks

- [ ] 2-column grid CwCard icons
- [ ] Section headers CwSectionHeader
- [ ] Badge for stub features (GRIB)
- [ ] Consistent navigation to sub-screens

## Acceptance Criteria

- [ ] All 8 toolbox entries reachable

---

## AGENT PROMPT

```
Step 25: Toolbox hub grid redesign с sections и toolbox_grid_item.
Рефактор maritime_toolbox_screen. flutter test.
```
