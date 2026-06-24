# Step 63 — Offline Pack Delete

| | |
|---|---|
| **requires** | step-48 |
| **phase** | K |
| **est. files** | 4 |

## Goal

Deleting a chart region removes MapLibre offline tile pack (`deleteOfflineRegion`).

## IN SCOPE

- `offline_chart_pack_deleter.dart`
- `chart_region_repository.dart` delete path

## Acceptance Criteria

- [ ] `sqlite:<id>` path triggers pack delete before DB row removal
- [ ] `offline_chart_manager_test.dart` verifies deleter called
