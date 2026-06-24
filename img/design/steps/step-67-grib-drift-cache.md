# Step 67 — GRIB Drift Cache

| | |
|---|---|
| **requires** | step-44 |
| **phase** | L |
| **est. files** | 6 |

## Goal

Store parsed GRIB metadata in Drift; decode once on import, not on every screen open.

## IN SCOPE

- `grib_tables.dart`
- `grib_import_repository.dart`
- Migrate legacy SharedPreferences paths

## Acceptance Criteria

- [ ] `grib_import_repository_test.dart`
- [ ] `grib_ui_test.dart` still passes
