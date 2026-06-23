# Step 40 — Chart Style Tiles

| | |
|---|---|
| **requires** | step-39, step-26 |
| **phase** | H |
| **est. files** | 5 |

## Goal

ChartStyleKind changes base style URL; night style when CwThemeMode.nightRed.

## Контекст

- См. `plan/features/` для доменной логики
- `img/design/screenshot-findings.md` где применимо

## IN SCOPE

- `chart_style_resolver.dart`
- `map_screen.dart`
- `cw_theme_mode integration`

## OUT OF SCOPE

- Custom ENC styling

## Tasks

- [ ] Map style URL per ChartStyleKind
- [ ] Sync with night red theme
- [ ] Audit log layer change

## Acceptance Criteria

- [ ] Night theme + chart night both darken map

---

## AGENT PROMPT

```
Step 40 Captain Wrongel: Wire chart style + night theme to MapLibre style URL.
Requires step-39, step-26. Run flutter test.
```
