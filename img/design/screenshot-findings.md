# Анализ скриншотов референс-приложений

> Визуальный разбор файлов в `screenshots/`.  
> Использовать при реализации шагов 09–18.

---

## Navigation

### Navionics (`navigation/navionics_*`)

**navionics_1–2 — карта offline**
- Полноэкранная карта, минимум chrome
- Круглые синие FAB: search (↖), camera, zoom +/- (↗), waypoint pin (↙)
- Плотные изобаты + soundings числами
- Промо-текст: «Study Charts / Even offline»

**navionics_4 — Map Options bottom sheet**
- Sheet ~40% высоты, заголовок + X
- Секция «OVERLAYS» caps label
- Горизонтальный grid thumbnail: No Overlay | Satellite | Relief Shading ✓ | Sonar
- Выбранный слой: синяя рамка + синий label

**Реализация CW (step-10):**
```
MapLayerSheet:
  - GridView 4 columns, 72×72 thumbnail + label
  - Selected: BorderSide 2px accentTeal
  - Sections: OVERLAYS | CHART STYLE | SHALLOW HIGHLIGHT
```

### iSailor (`navigation/isailor_*`)

**isailor_1 — маршрут в порту**
- Waypoints WP3–WP5 красные флаги
- Маршрут: solid purple line
- Safety corridor: translucent green polygon ±50m
- Bearing-distance labels на сегментах («315.7° - 820 m»)
- Dashed red track (actual)
- Scale bar «200 m» bottom-left
- Red «Rec» dot — запись трека
- Zoom +/- translucent right

**Реализация CW (step-13):**
- Route leg labels через `MapLibre` symbol layer или overlay widgets
- Corridor polygon из buffer вокруг polyline

### iNavX (`navigation/inavx_*`)
- Классический raster chart вид
- Toolbar сверху, меню layers
- Менее современный — **не копировать** визуал, только функции

---

## Weather

### Windy.app (`weather/windy_*`)
- Tablet layout: legend bar top (0–45 kts gradient)
- Particle/streamline arrows белые полупрозрачные
- Timeline bottom: дни + часы, scrubber
- Right toolbar: HD, location, layers, model (GFS)

**Реализация CW (step-14, 15):**
```dart
// WeatherTimelineBar — горизонтальный ListView часов
// WindLegendBar — LinearGradient + labels
// LayerToolbar — Column справа, 44dp icons
```

### Windy.com (`weather/windy_app_*`)
- Particle wind на heatmap (purple→red temperature/wind)
- Минимальный top chrome
- Responsive: tablet + phone

### Windfinder (`weather/windfinder_*`)
- Dark ocean hero, bold white headline
- Bottom nav: Favorites | Map
- Map overlay: colored wind spots

### Clime (`weather/clime_*`)
- Radar-centric, red/orange precipitation
- Менее релевантно для паруса — взять только alert banners

---

## Mooring

### Navily (`mooring/navily_*`)

**navily_1 — splash/onboarding**
- Full-bleed photo (bay + yachts)
- White anchor logo + lowercase «navily»
- Headline 3 строки bold на воде (контраст)

**navily_3–5 — карта и список**
- Pins марин/anchorages
- Card: фото, звёзды, глубина, wind protection icons

**Реализация CW (step-17, 18):**
- `MooringCard`: photo 16:9, chips depth/wind/mud
- Filter chips horizontal scroll

---

## Tides (`tides/tide_alert_*`)
- USPS app screenshots (замена Tide Times)
- График синусоиды, таблица HW/LW
- Использовать для `TideCurveChart` widget

---

## Сводка цветов конкурентов vs CW

| App | Primary | Water | Land | Accent |
|-----|---------|-------|------|--------|
| Navionics | #0066CC blue | light blue | yellow-green | blue FABs |
| Windy | dark grey | gradient | grey-green | red logo |
| Navily | white on photo | deep blue | hills tan | white |
| **Captain Wrongel** | #1ABC9C teal | #0D1B2A deck | chart tiles | #E67E22 orange |

CW сохраняет тёмную палитру `CwTheme` — лучше для ночи и OLED; конкуренты часто светлые карты днём → добавить **chart day mode** в step-26.

---

## Жесты (подтверждено скриншотами)

| Жест | Navionics | Windy | CW spec |
|------|-----------|-------|---------|
| Pinch zoom | ✓ | ✓ | ✓ |
| Double tap zoom | ✓ | — | ✓ |
| Long press | waypoint | — | context sheet |
| Pan | ✓ | ✓ | ✓ |
| Timeline scrub | — | ✓ | weather step-14 |
