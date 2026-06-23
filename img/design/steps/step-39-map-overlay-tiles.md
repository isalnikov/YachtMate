# Step 39 — Map Overlay Tiles

| | |
|---|---|
| **requires** | step-10 |
| **phase** | H |
| **est. files** | 5 |

## Goal

Wire MapOverlayKind to MapLibre raster sources (satellite, relief, sonar placeholder).

## Контекст

- См. `plan/features/` для доменной логики
- `img/design/screenshot-findings.md` где применимо

## IN SCOPE

- `map_tile_overlay_controller.dart`
- `map_screen.dart apply overlays`
- `map_overlay_tiles_test.dart`

## OUT OF SCOPE

- Licensing Navionics tiles
- SonarChart HD data

## Tasks

- [ ] Read overlay from mapLayerPreferencesProvider
- [ ] Add/remove raster layers on change
- [ ] Fallback if URL missing

## Acceptance Criteria

- [ ] Selecting overlay changes visible map
- [ ] Prefs persist

---

## AGENT PROMPT

```
Step 39 Captain Wrongel: Connect MapOverlayKind UI to MapLibre raster layers. step-10 layer sheet.
Requires step-10. Run flutter test.
```
