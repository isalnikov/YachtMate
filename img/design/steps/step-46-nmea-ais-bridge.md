# Step 46 — Nmea Ais Bridge

| | |
|---|---|
| **requires** | step-20 |
| **phase** | H |
| **est. files** | 5 |

## Goal

TCP/UDP NMEA listener feeds ais_targets_controller; settings for host/port.

## Контекст

- См. `plan/features/` для доменной логики
- `img/design/screenshot-findings.md` где применимо

## IN SCOPE

- `nmea_tcp_client.dart`
- `ais_settings_screen.dart`
- `nmea_bridge_test.dart`

## OUT OF SCOPE

- Bluetooth BLE NMEA
- Cloud AIS

## Tasks

- [ ] Demo vs live source toggle
- [ ] Parse AIVDM from stream
- [ ] Reconnect logic

## Acceptance Criteria

- [ ] Live NMEA test fixture updates targets

---

## AGENT PROMPT

```
Step 46 Captain Wrongel: Local NMEA AIS bridge. F07.
Requires step-20. Run flutter test.
```
