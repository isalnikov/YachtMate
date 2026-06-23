# Step 52 — Feature Flags Freemium

| | |
|---|---|
| **requires** | step-27 |
| **phase** | I |
| **est. files** | 4 |

## Goal

Feature flags: free vs premium gates for AIS cloud, offline charts, GRIB.

## Контекст

- См. `plan/features/` для доменной логики
- `img/design/screenshot-findings.md` где применимо

## IN SCOPE

- `core/feature_flags.dart`
- `paywall_placeholder_sheet.dart`

## OUT OF SCOPE

- Stripe/RevenueCat billing

## Tasks

- [ ] Flags in SharedPreferences
- [ ] CwBottomSheet upgrade CTA
- [ ] Audit log

## Acceptance Criteria

- [ ] Gated feature shows paywall sheet

---

## AGENT PROMPT

```
Step 52 Captain Wrongel: Freemium feature flags IDEAS2.
Requires step-27. Run flutter test.
```
