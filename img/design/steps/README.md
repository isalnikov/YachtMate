# Пошаговый план реализации

**60 шагов** · один шаг = одна кодер-сессия ИИ (~200k токенов)

> Шаги **01–28** ✅ выполнены. Шаги **29–60** — фазы G–J.

См. также: [phases-roadmap.md](../phases-roadmap.md)

---

## Фазы A–F (01–28) ✅ DONE

| # | Файл | Фаза |
|---|------|------|
| 01–07 | design tokens → app bar | A |
| 08 | onboarding | B |
| 09–18 | map, route, weather, mooring | C |
| 19–22 | anchor, AIS, SOS, GPS | D |
| 23–25 | knots, VHF, toolbox | E |
| 26–28 | night theme, settings, tablet | F |

---

## Фаза G — UI Debt (29–38)

Миграция экранов, не затронутых в 01–28, на `CwCard` / `CwButton` / `CwAppBar`.

| # | Файл | Экран |
|---|------|-------|
| 29 | [step-29-logbook-ui.md](step-29-logbook-ui.md) | Logbook |
| 30 | [step-30-track-ui.md](step-30-track-ui.md) | Track recording |
| 31 | [step-31-vault-ui.md](step-31-vault-ui.md) | Vault |
| 32 | [step-32-crew-ui.md](step-32-crew-ui.md) | Crew |
| 33 | [step-33-checklist-ui.md](step-33-checklist-ui.md) | Checklists |
| 34 | [step-34-compass-ui.md](step-34-compass-ui.md) | Compass + astro |
| 35 | [step-35-coastal-ui.md](step-35-coastal-ui.md) | Coastal guide |
| 36 | [step-36-medical-ui.md](step-36-medical-ui.md) | Medical glossary |
| 37 | [step-37-expenses-ui.md](step-37-expenses-ui.md) | Voyager cashbook |
| 38 | [step-38-grib-ui-shell.md](step-38-grib-ui-shell.md) | GRIB import shell |

**requires:** step-01–07 для всех G

---

## Фаза H — Data & Maps (39–48)

Подключение данных к UI, созданному в 01–28.

| # | Файл | Задача |
|---|------|--------|
| 39 | [step-39-map-overlay-tiles.md](step-39-map-overlay-tiles.md) | Satellite/relief/sonar tiles |
| 40 | [step-40-chart-style-tiles.md](step-40-chart-style-tiles.md) | Chart style + night on map |
| 41 | [step-41-shallow-highlight.md](step-41-shallow-highlight.md) | Shallow depth highlight |
| 42 | [step-42-live-tides-api.md](step-42-live-tides-api.md) | Live tides API |
| 43 | [step-43-mooring-photos-ratings.md](step-43-mooring-photos-ratings.md) | Photos + ratings |
| 44 | [step-44-grib-decoder-mvp.md](step-44-grib-decoder-mvp.md) | GRIB decoder |
| 45 | [step-45-anchor-real-map-sms.md](step-45-anchor-real-map-sms.md) | Anchor MapLibre + SMS |
| 46 | [step-46-nmea-ais-bridge.md](step-46-nmea-ais-bridge.md) | Local NMEA AIS |
| 47 | [step-47-wind-layer-on-map.md](step-47-wind-layer-on-map.md) | Wind overlay on map |
| 48 | [step-48-offline-chart-manager.md](step-48-offline-chart-manager.md) | Offline regions UI |

**requires:** step-09–10 для 39–41; step-16 для 42; step-17–18 для 43

---

## Фаза I — Product (49–54)

Модули из `docs/ui/` и IDEAS2 без Flutter-реализации.

| # | Файл | Задача |
|---|------|--------|
| 49 | [step-49-community-hub.md](step-49-community-hub.md) | Community M10 |
| 50 | [step-50-voyage-monitoring.md](step-50-voyage-monitoring.md) | SafeTrx-style |
| 51 | [step-51-push-notifications.md](step-51-push-notifications.md) | Anchor/weather push |
| 52 | [step-52-feature-flags-freemium.md](step-52-feature-flags-freemium.md) | Feature flags |
| 53 | [step-53-yacht-hub-screen.md](step-53-yacht-hub-screen.md) | Yacht hub M11 |
| 54 | [step-54-offline-assistant-stub.md](step-54-offline-assistant-stub.md) | AI assistant stub |

---

## Фаза J — Polish (55–60)

| # | Файл | Задача |
|---|------|--------|
| 55 | [step-55-i18n-el-tr-pt.md](step-55-i18n-el-tr-pt.md) | EL, TR, PT |
| 56 | [step-56-i18n-complete-eu.md](step-56-i18n-complete-eu.md) | DE/FR/ES/IT gaps |
| 57 | [step-57-wind-particles.md](step-57-wind-particles.md) | Wind animation |
| 58 | [step-58-error-catalog.md](step-58-error-catalog.md) | Error messages |
| 59 | [step-59-accessibility-audit.md](step-59-accessibility-audit.md) | WCAG pass |
| 60 | [step-60-performance-ui.md](step-60-performance-ui.md) | UI perf budget |

---

## Фаза K — Production Hardening (61–63)

Закрывает P0 из авторского ревью фазы H.

| # | Файл | Задача |
|---|------|--------|
| 61 | [step-61-ais-live-connection.md](step-61-ais-live-connection.md) | AIS `liveConnected` = реальный TCP |
| 62 | [step-62-wind-overlay-pan.md](step-62-wind-overlay-pan.md) | Wind overlay при панорамировании |
| 63 | [step-63-offline-pack-delete.md](step-63-offline-pack-delete.md) | Удаление MapLibre tile pack |

---

## Правила для агента

1. **requires** — все зависимости выполнены
2. `cd mobile && flutter test` перед завершением
3. Не расширять scope beyond IN SCOPE
4. Коммит — только по запросу пользователя
5. Сверка: `plan/features/F*.md`, `docs/ui/*.html`

## Порядок (рекомендуемый)

```
G: 29 → 30 → … → 38   (можно 29–32 параллельно разным агентам)
H: 39 → 40 → 41 → 42 → … → 48
I: 49–54 (после G, частично параллельно H)
J: 55–60 (в конце)
```
