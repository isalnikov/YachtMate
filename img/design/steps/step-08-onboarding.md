# Step 08 — Onboarding Flow

| | |
|---|---|
| **requires** | step-01–07 |
| **phase** | B |
| **est. files** | 7 |

## Goal

4 экрана onboarding после disclaimer: Welcome → Permissions → Experience level → Region. Сохранение в SharedPreferences.

## Контекст

- `mobile/lib/features/legal/disclaimer_screen.dart`
- `mobile/lib/app.dart`
- `img/design/competitive-analysis.md` — Navily full-bleed style
- `docs/ui/index.html`

## IN SCOPE

- `mobile/lib/features/onboarding/onboarding_flow.dart`
- `mobile/lib/features/onboarding/onboarding_page.dart`
- `mobile/lib/core/onboarding_prefs.dart`
- Обновить `app.dart` — Disclaimer → Onboarding → Shell
- l10n keys в `app_en.arb`, `app_ru.arb`
- `mobile/test/features/onboarding_test.dart`

## OUT OF SCOPE

- Paywall / subscription
- Tutorial tooltips на карте

## Tasks

- [ ] PageView 4 pages, dots indicator
- [ ] Page1: hero + «Captain Wrongel» tagline
- [ ] Page2: location + notification permission requests
- [ ] Page3: experience chips (Beginner/Cruiser/Racer)
- [ ] Page4: region picker (Mediterranean/Caribbean/Other)
- [ ] `onboardingComplete` pref

## Acceptance Criteria

- [ ] Повторный запуск пропускает onboarding
- [ ] disclaimer flow test still passes

---

## AGENT PROMPT

```
Step 08: Onboarding 4 screens после disclaimer.
onboarding_prefs, onboarding_flow, тесты. l10n EN+RU.
Flow: Disclaimer → Onboarding → Shell. Navily-style full-bleed page 1.
flutter test.
```
