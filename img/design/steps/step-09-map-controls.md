# Step 09 — Map Controls Overlay

| | |
|---|---|
| **requires** | step-01–07 |
| **phase** | C |
| **est. files** | 6 |

## Goal

Вынести map controls в `MapControlsOverlay`: zoom +/-, compass, layer button, follow GPS. Navionics-style circular FABs.

## Контекст

- `mobile/lib/features/map/map_screen.dart`
- `img/design/screenshot-findings.md` — Navionics FABs, iSailor zoom

## IN SCOPE

- `mobile/lib/features/map/widgets/map_controls_overlay.dart`
- `mobile/lib/features/map/widgets/map_compass_button.dart`
- `mobile/lib/features/map/widgets/map_zoom_buttons.dart`
- Рефактор `map_screen.dart` — Stack child
- `mobile/test/features/map_controls_test.dart`

## OUT OF SCOPE

- Layer sheet content (step-10)
- Bottom sheet POI (step-11)

## Tasks

- [ ] CwFab column right: zoom+, zoom-, compass, layers
- [ ] Compass: tap → north-up / heading-up toggle
- [ ] Follow GPS button state
- [ ] Position: right 12, vertical center bias

## Acceptance Criteria

- [ ] 48dp touch targets (52 glove via app.dart)
- [ ] Controls не перекрывают bottom nav

---

## AGENT PROMPT

```
Step 09: MapControlsOverlay с zoom, compass, layers, follow GPS.
CwFab из step-03. Рефактор map_screen Stack. Tests. flutter test.
Референс: img/design/screenshot-findings.md Navionics FABs.
```
