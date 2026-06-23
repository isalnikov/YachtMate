# Step 42 — Live Tides Api

| | |
|---|---|
| **requires** | step-16 |
| **phase** | H |
| **est. files** | 5 |

## Goal

Replace demo_tides.json with API (WorldTides or NOAA) + Drift cache.

## Контекст

- См. `plan/features/` для доменной логики
- `img/design/screenshot-findings.md` где применимо

## IN SCOPE

- `tides_repository.dart`
- `tides_api_client.dart`
- `update tides_screen.dart`

## OUT OF SCOPE

- Tidal current atlas maps

## Tasks

- [ ] Offline cache 7 days
- [ ] Fallback to demo on error
- [ ] Station search by GPS

## Acceptance Criteria

- [ ] TidesScreen shows live HW/LW when online
- [ ] Offline uses cache

---

## AGENT PROMPT

```
Step 42 Captain Wrongel: Live tides API with Drift cache, fallback demo. plan/features/F03.
Requires step-16. Run flutter test.
```
