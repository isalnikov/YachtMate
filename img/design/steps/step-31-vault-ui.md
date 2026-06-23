# Step 31 — Vault Ui

| | |
|---|---|
| **requires** | step-01–07 |
| **phase** | G |
| **est. files** | 4 |

## Goal

Vault: PIN entry CwTextField, file list CwCard, lock icon states.

## Контекст

- `mobile/lib/features/` — целевой экран
- `docs/ui/` — HTML-референс
- `img/design/design-system-spec.md`

## IN SCOPE

- `vault_screen.dart`
- `widgets/vault_pin_panel.dart`
- `vault_screen_test.dart`

## OUT OF SCOPE

- Crypto domain

## Tasks

- [ ] Masked PIN dots
- [ ] Import button CwButton secondary
- [ ] Encrypted badge

## Acceptance Criteria

- [ ] vault crypto tests pass

---

## AGENT PROMPT

```
Step 31 Captain Wrongel: Vault UI polish, keep VaultCrypto unchanged.
Requires step-01–07. Run flutter test.
```
