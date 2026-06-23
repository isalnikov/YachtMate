# Step 27 — Settings & Vessel Profile

| | |
|---|---|
| **requires** | step-01–07 |
| **phase** | F |
| **est. files** | 6 |

## Goal

Редизайн settings: grouped sections, vessel profile (draft, length, type), units, theme picker.

## Контекст

- `mobile/lib/features/settings/settings_screen.dart`
- `img/design/design-system-spec.md` §4.11
- `docs/ui/settings.html`

## IN SCOPE

- `mobile/lib/features/settings/widgets/settings_section.dart`
- `mobile/lib/features/settings/widgets/vessel_profile_form.dart`
- `mobile/lib/core/vessel_prefs.dart`
- Refactor settings_screen

## OUT OF SCOPE

- Account sync
- Offline map download manager (stub only)

## Tasks

- [ ] Sections: Vessel | Display | Accessibility | Energy | About
- [ ] Vessel: name, LOA, draft, type dropdown
- [ ] Units: metric/imperial segmented
- [ ] Theme: Deck / Night red / High contrast chips
- [ ] Link glove mode, text scale (existing)

## Acceptance Criteria

- [ ] Vessel draft used in route safety check
- [ ] Prefs persist

---

## AGENT PROMPT

```
Step 27: Settings redesign — vessel profile form, grouped sections, theme picker.
vessel_prefs.dart, интеграция draft в route safety. flutter test.
```
