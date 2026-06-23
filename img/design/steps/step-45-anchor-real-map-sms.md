# Step 45 — Anchor Real Map Sms

| | |
|---|---|
| **requires** | step-19 |
| **phase** | H |
| **est. files** | 4 |

## Goal

Anchor watch: MapLibre mini-map instead of CustomPaint; optional SMS on drift via url_launcher.

## Контекст

- См. `plan/features/` для доменной логики
- `img/design/screenshot-findings.md` где применимо

## IN SCOPE

- `anchor_zone_map.dart MapLibre or reuse map panel`
- `sms alert on alarm`

## OUT OF SCOPE

- Zenkou multi-anchor
- Contour geofence

## Tasks

- [ ] Circle source/layer on map
- [ ] SMS pref in settings
- [ ] Test mode no SMS

## Acceptance Criteria

- [ ] Alarm still triggers tests
- [ ] Map shows circle on device with MapLibre

---

## AGENT PROMPT

```
Step 45 Captain Wrongel: Anchor real map + optional SMS. F06.
Requires step-19. Run flutter test.
```
