# Step 20 — AIS Dedicated Screen

| | |
|---|---|
| **requires** | step-09–11 |
| **phase** | D |
| **est. files** | 8 |

## Goal

Полноэкранный AIS из More menu: карта судов, фильтры, vessel info sheet, CPA/TCPA.

## Контекст

- `mobile/lib/features/ais/` — providers, demo stream
- `mobile/lib/domain/ais/` — CPA/TCPA
- `docs/ui/ais.html`
- `plan/features/F07-vessel-tracking-ais.md`

## IN SCOPE

- `mobile/lib/features/ais/ais_screen.dart` — NEW
- `mobile/lib/features/ais/widgets/ais_vessel_marker.dart`
- `mobile/lib/features/ais/widgets/ais_vessel_sheet.dart`
- `mobile/lib/features/ais/widgets/ais_filter_bar.dart`
- Link from `more_menu_screen.dart`

## OUT OF SCOPE

- Cloud AIS API
- AR mode

## Tasks

- [ ] Map with vessel triangles + heading vectors
- [ ] Tap vessel → bottom sheet: name, MMSI, SOG, COG, CPA
- [ ] Filter: Cargo / Tanker / Pleasure / All
- [ ] CPA warning CwBadge if <1nm
- [ ] Demo NMEA feed

## Acceptance Criteria

- [ ] AIS domain tests pass
- [ ] Screen accessible from More

---

## AGENT PROMPT

```
Step 20: AIS screen — ais_screen, vessel markers, filter bar, vessel sheet с CPA/TCPA.
Entry в more_menu. Demo NMEA. flutter test.
```
