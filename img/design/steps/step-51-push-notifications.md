# Step 51 — Push Notifications

| | |
|---|---|
| **requires** | step-19, step-14 |
| **phase** | I |
| **est. files** | 4 |

## Goal

Local notifications: anchor drift, weather alert thresholds.

## Контекст

- См. `plan/features/` для доменной логики
- `img/design/screenshot-findings.md` где применимо

## IN SCOPE

- `core/notifications/local_notifications_service.dart`
- `settings toggles`

## OUT OF SCOPE

- FCM remote push

## Tasks

- [ ] flutter_local_notifications
- [ ] Anchor alarm notification
- [ ] Wind > threshold

## Acceptance Criteria

- [ ] Notification fires in test/simulate

---

## AGENT PROMPT

```
Step 51 Captain Wrongel: Local push for anchor + weather.
Requires step-19, step-14. Run flutter test.
```
