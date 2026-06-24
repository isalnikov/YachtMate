# Step 61 — AIS Live Connection State

| | |
|---|---|
| **requires** | step-46 |
| **phase** | K |
| **est. files** | 3 |

## Goal

`liveConnected` reflects real TCP socket state, not optimistic flag after `start()`.

## IN SCOPE

- `nmea_tcp_client.dart` connection callbacks
- `ais_targets_controller.dart` bridge state

## Acceptance Criteria

- [ ] `liveConnected` false when TCP fails
- [ ] `liveConnected` true only after socket open
- [ ] `nmea_bridge_test.dart` covers failed connect
