# Step 19 — Anchor Watch UI

| | |
|---|---|
| **requires** | step-09 |
| **phase** | D |
| **est. files** | 6 |

## Goal

Редизайн `anchor_watch_screen.dart`: circle editor на карте, arm/disarm, drift history trail.

## Контекст

- `mobile/lib/features/anchor/anchor_watch_screen.dart`
- `img/design/competitive-analysis.md` — Anchor Alarm
- `docs/ui/anchor.html`

## IN SCOPE

- `mobile/lib/features/anchor/widgets/anchor_zone_map.dart`
- `mobile/lib/features/anchor/widgets/anchor_radius_slider.dart`
- `mobile/lib/features/anchor/widgets/anchor_status_panel.dart`
- Arm/disarm prominent CwButton danger/safe

## OUT OF SCOPE

- SMS alert integration
- Multi-anchor Zenkou mode

## Tasks

- [ ] Map mini view with circle overlay
- [ ] Slider radius 20–200m
- [ ] Status: IN ZONE green / DRIFTING red pulsing
- [ ] History polyline grey
- [ ] GPS loss banner preserved

## Acceptance Criteria

- [ ] Alarm triggers on simulated drift in test

---

## AGENT PROMPT

```
Step 19: Anchor watch UI — zone map, radius slider, status panel.
Рефактор anchor_watch_screen. Arm/disarm CwButton. flutter test.
```
