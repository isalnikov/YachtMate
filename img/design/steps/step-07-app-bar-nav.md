# Step 07 — AppBar & Navigation Polish

| | |
|---|---|
| **requires** | step-01–06 |
| **phase** | A |
| **est. files** | 5 |

## Goal

`CwAppBar`, улучшить `shell_screen.dart` NavigationBar/Rail с CwTokens. Status-consistent icons.

## Контекст

- `mobile/lib/features/shell/shell_screen.dart`
- `docs/ui/map.html` — topbar
- `mobile/lib/widgets/language_button.dart`

## IN SCOPE

- `mobile/lib/widgets/cw_app_bar.dart` — title, actions, back
- Обновить `shell_screen.dart` — цвета из CwColors, icon size
- Обновить 3 secondary screens: toolbox, settings, logbook — CwAppBar
- `mobile/test/shell_wide_layout_test.dart` — не сломать

## OUT OF SCOPE

- GPS status pill (step-22)
- Tablet split (step-28)

## Tasks

- [ ] CwAppBar: transparent on map screens, solid on others
- [ ] NavigationDestination: selected teal, unselected muted
- [ ] LanguageButton стилизовать под CwChip

## Acceptance Criteria

- [ ] shell_wide_layout_test passes
- [ ] Rail extended ≥900px unchanged behavior

---

## AGENT PROMPT

```
Step 07: CwAppBar + polish shell_screen NavigationBar/Rail с CwTokens.
Примени CwAppBar к toolbox, settings, logbook. flutter test включая shell_wide_layout_test.
```
