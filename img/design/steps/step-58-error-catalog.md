# Step 58 — Error Catalog

| | |
|---|---|
| **requires** | step-01–28 |
| **phase** | J |
| **est. files** | 5 |

## Goal

Centralized error messages: network, GPS, vault, routing; l10n keys.

## Контекст

- См. `plan/features/` для доменной логики
- `img/design/screenshot-findings.md` где применимо

## IN SCOPE

- `core/errors/cw_error_catalog.dart`
- `l10n error_* keys`
- `wire 5 screens`

## OUT OF SCOPE

- All screens at once

## Tasks

- [ ] Catalog enum + message()
- [ ] Snackbar uses catalog

## Acceptance Criteria

- [ ] error_catalog_test.dart

---

## AGENT PROMPT

```
Step 58 Captain Wrongel: Error message catalog img.md optional.
Requires step-01–28. Run flutter test.
```
