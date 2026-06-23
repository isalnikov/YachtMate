# Step 26 — Night Red Mode & Chart Day Mode

| | |
|---|---|
| **requires** | step-01 |
| **phase** | F |
| **est. files** | 6 |

## Goal

Red night theme для сохранения зрения + optional chart day palette toggle.

## Контекст

- `mobile/lib/core/theme/cw_theme.dart`
- `mobile/lib/features/settings/settings_screen.dart`
- `img/design/design-system-spec.md` §2.3

## IN SCOPE

- `mobile/lib/core/theme/cw_night_theme.dart`
- `CwThemeMode` enum: deck | nightRed | highContrast
- Settings toggle «Night watch (red)»
- `app.dart` theme switch
- Map chart style hint for day mode

## OUT OF SCOPE

- Auto sunset switch (optional nice-to-have if time)

## Tasks

- [ ] nightRed: bg #1A0000, primary #CC0000, text #FF6666
- [ ] Preserve chart readability
- [ ] Persist pref
- [ ] All nav chrome uses red theme

## Acceptance Criteria

- [ ] Toggle instant apply
- [ ] High contrast mode still works independently

---

## AGENT PROMPT

```
Step 26: Night red theme cw_night_theme.dart + settings toggle.
ThemeMode provider в app.dart. flutter test.
```
