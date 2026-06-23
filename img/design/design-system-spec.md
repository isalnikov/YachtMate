# Design System — сводная спецификация

> Детальная реализация разбита по шагам 01–07.  
> Референс HTML: `docs/ui/styles.css`

---

## 1. Брендинг

| Элемент | Значение |
|---------|----------|
| Название | **Captain Wrongel** (рабочее) |
| Альтернативы | SeaPilot, HelmMaster, YachtMate |
| Tone | Профессиональный, спокойный, надёжный |
| Иконка | Штурвал + волна, teal на deck blue |

---

## 2. Цвета

### 2.1 Core (Day/Dark deck mode)

| Token | Hex | Usage |
|-------|-----|-------|
| `deckBlue` | `#0D1B2A` | Scaffold, nav |
| `panelBlue` | `#122438` | Cards |
| `accentTeal` | `#1ABC9C` | Primary, active |
| `accentOrange` | `#E67E22` | Secondary, warnings |
| `textPrimary` | `#E8F4FC` | Body |
| `textMuted` | `#8BA4BC` | Captions |
| `danger` | `#EF4444` | SOS, alarms |
| `safe` | `#22C55E` | OK, anchor in zone |

### 2.2 Marine data colors

| Data | Color |
|------|-------|
| Wind 0–10 kn | `#3B82F6` → `#22D3EE` |
| Wind 10–25 kn | `#22C55E` → `#EAB308` |
| Wind 25+ kn | `#F97316` → `#EF4444` |
| Depth shallow | `#FBBF24` highlight |
| Depth safe | transparent |
| AIS cargo | `#A78BFA` |
| AIS pleasure | `#34D399` |

### 2.3 Night red mode (step-26)

| Token | Hex |
|-------|-----|
| `nightRed` | `#CC0000` |
| `nightBg` | `#1A0000` |
| `nightText` | `#FF6666` |

### 2.4 High contrast (exists)

Yellow `#FFE135` on black — `CwTheme.materialHighContrast()`

---

## 3. Типографика

| Style | Size | Weight | Line height |
|-------|------|--------|-------------|
| display | 28sp | 800 | 1.2 |
| h1 | 22sp | 700 | 1.25 |
| h2 | 18sp | 600 | 1.3 |
| body | 16sp | 400 | 1.5 |
| caption | 13sp | 400 | 1.4 |
| button | 16sp | 600 | 1.0 |
| monoCoords | 14sp | 500 | 1.2 (tabular) |

**Шрифт:** system default + Cyrillic; optional `JetBrains Mono` для координат (step-02).

**Glove mode:** +2sp ко всем размерам.

---

## 4. Spacing (8px grid)

| Token | dp |
|-------|-----|
| xs | 4 |
| s | 8 |
| m | 16 |
| l | 24 |
| xl | 32 |
| xxl | 48 |

**Touch targets:** min 44dp; glove 52dp.

**Radius:** sm 8, md 16 (`--radius`), lg 24, full 999.

---

## 5. Компоненты (индекс)

| Component | Step | File (target) |
|-----------|------|---------------|
| `CwTokens` | 01 | `lib/core/theme/cw_tokens.dart` |
| `CwTypography` | 02 | `lib/core/theme/cw_typography.dart` |
| `CwButton` | 03 | `lib/widgets/cw_button.dart` |
| `CwCard` | 04 | `lib/widgets/cw_card.dart` |
| `CwTextField` | 05 | `lib/widgets/cw_text_field.dart` |
| `CwBottomSheet` | 06 | `lib/widgets/cw_bottom_sheet.dart` |
| `CwAppBar` | 07 | `lib/widgets/cw_app_bar.dart` |
| `MapControlsOverlay` | 09 | `lib/features/map/widgets/` |
| `MapLayerSheet` | 10 | `lib/features/map/widgets/` |
| `WeatherTimeline` | 14 | `lib/features/weather/widgets/` |
| `WindRose` | 15 | `lib/features/weather/widgets/` |
| `TideCurveChart` | 16 | `lib/features/weather/widgets/` |
| `MooringCard` | 17 | `lib/features/mooring/widgets/` |
| `AnchorZoneEditor` | 19 | `lib/features/anchor/widgets/` |
| `AisVesselSheet` | 20 | `lib/features/ais/widgets/` |
| `SosEmergencyPanel` | 21 | `lib/features/distress/widgets/` |

---

## 6. Экраны — ключевые размеры (phone 390×844)

### Map screen
| Element | Position | Size |
|---------|----------|------|
| Status pill | top center, safe+8 | h32, px12 |
| Zoom FABs | right 12, centerY±40 | 48×48 |
| Compass | right 12, bottom 180 | 56×56 |
| Layer button | right 12, bottom 120 | 48×48 |
| Coords | bottom left, above nav | h28 |
| Bottom sheet peek | bottom nav+0 | h120 collapsed |

### Weather screen
| Element | Size |
|---------|------|
| Timeline bar | h64 |
| Legend | h24 |
| Hour card | w80 h100 |
| Wind rose | 160×160 |

---

## 7. Accessibility

- WCAG AA contrast: 4.5:1 body, 3:1 large text
- `Semantics` on all interactive map controls
- `reduceMotion` → disable chart animations
- Screen reader: coords as «41 degrees 12 minutes North»

---

## 8. Breakpoints

| Name | Width | Layout |
|------|-------|--------|
| xs | 320–414 | Single column |
| s | 414–768 | Phone default |
| m | 768–1024 | NavigationRail |
| l | 1024+ | Split map+panel |

Уже в `shell_screen.dart`: 720 rail, 900 extended.

---

## 9. i18n (step-27)

Текущие: EN, RU, DE, FR, ES, IT.  
Добавить: EL, TR, EL (греческий), PT — по img.md.

Форматы:
- Координаты: DD°MM.mmm' (настройка)
- Ветер: knots default
- Глубина: metres / feet toggle
