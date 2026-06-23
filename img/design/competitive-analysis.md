# Конкурентный анализ UI/UX (40+ приложений)

> Синтез по `img.md`, App Store скриншотам и публичным обзорам.  
> Целевой продукт: **Captain Wrongel** — offline-first супер-приложение для яхтсменов.

---

## Executive Summary

Рынок яхтенных приложений фрагментирован: пользователь вынужден ставить 5–10 apps (Navionics + Windy + Navily + MarineTraffic + Anchor Alarm). Лучшие решения объединяют **карту как хаб**, **слои данных поверх карты**, **bottom sheet для деталей** и **крупные touch-targets**. Главные боли: paywall на картах, перегруженные меню, плохая читаемость на солнце, отсутствие единого offline-режима.

**Стратегия Captain Wrongel:** взять паттерны лидеров, убрать их слабости, добавить Safety-first + Glove mode + единую тёмно-морскую дизайн-систему.

---

## 1. Навигация и карты

### Navionics Boating (лидер)
| Сильные стороны | Слабые стороны |
|-----------------|----------------|
| Круглые FAB-контролы zoom/search на карте | Агрессивный paywall после trial |
| Bottom sheet «Map Options» с превью слоёв | Перегруз иконками на маленьком экране |
| SonarChart HD контуры, relief shading | Нет единого emergency UX |
| Offline charts, community edits | Сложный onboarding (7 шагов) |

**Взять:** overlay switcher с thumbnail-превью; круглые map controls справа; heatmap глубин.

### iNavX / iSailor
| Сильные стороны | Слабые стороны |
|-----------------|----------------|
| Профессиональные waypoint + corridor (iSailor) | Устаревший визуальный стиль |
| Bearing/distance на сегментах маршрута | Мелкий текст на маршруте |
| GRIB, tides, anchor в одном app (iNavX) | Высокая цена карт |
| Scale bar, Rec indicator | Слабая адаптация под телефон |

**Взять:** фиолетовый маршрут + зелёный safety corridor; scale bar; bearing/дистанция на leg.

### C-Map Plan2Nav
**Взять:** split-screen на планшете; погода в боковой панели.

---

## 2. Погода

### Windy.com / Windy.app
| Сильные стороны | Слабые стороны |
|-----------------|----------------|
| Particle wind animation на карте | Сложность для новичков |
| Timeline scrubber внизу | Много кнопок справа |
| Цветовая легенда kts сверху | Тяжёлый для слабых устройств |
| HD toggle, модели GFS/ECMWF | Не морская терминология из коробки |

**Взять:** timeline + legend bar; layer switcher вертикально справа; цветовая шкала ветра в knots.

### Windfinder
| Сильные стороны | Слабые стороны |
|-----------------|----------------|
| «Wind, Weather, Waves & Tides» — один экран | Реклама в free |
| Favorites + Map tabs | Узкая специализация |
| Spot-based прогноз | Нет маршрутной интеграции |

**Взять:** табы Favorites/Map; spot pins на карте.

### PocketGrib / SailGrib
**Взять:** offline GRIB import UI; расчёт маршрута по погоде (post-MVP).

---

## 3. Приливы

### Tides Planner / Tide Guide / Tide Times
| Паттерн | Рекомендация |
|---------|--------------|
| Sine curve график HW/LW | Обязательный виджет |
| Таблица на неделю | Вторичный вид |
| Фазы луны | В weather/tides экране |
| Атлас течений | Post-MVP слой на карте |

---

## 4. AIS и трекеры

### Marine Traffic / VesselFinder
| Сильные стороны | Слабые стороны |
|-----------------|----------------|
| Треугольники судов с курсом | Облачная зависимость |
| Фильтр по типу судна | AR — gimmick на практике |
| CPA/TCPA | Платные фичи |
| Поиск по MMSI/имени | Перегруз на мобильном |

**Взять:** AIS markers с heading vector; vessel info bottom sheet; CPA warning chip.

---

## 5. Стоянки и якорь

### Navily
| Сильные стороны | Слабые стороны |
|-----------------|----------------|
| Community reviews + photos | Только Европа сильна |
| Красивый onboarding | Booking friction |
| Карта + список марин | Premium paywall |
| SOS community feature | |

**Взять:** карточка марины с фото/глубиной/ветрозащитой; community reviews; full-bleed onboarding.

### Anchor Alarm / Zenkou
**Взять:** круговая геозона на карте; push при выходе; история дрейфа.

---

## 6. Безопасность

### SafeTrx
**Взять:** voyage monitoring; shore contact; countdown timer; «I'm OK» check-in.

### Red Cross First Aid
**Взять:** пошаговые emergency cards; крупные CTA.

---

## 7. VHF и справочники

### VHF Talk / Trainer / COLREG 72
**Взять:** сценарии диалогов; фонетический алфавит; quiz mode; audio record/compare.

### Knot Guide
**Взять:** категории; пошаговые иллюстрации; избранное.

---

## 8. Сводная таблица паттернов

| Паттерн | Лучший референс | Приоритет для CW |
|---------|-----------------|------------------|
| Map-first hub | Navionics | P0 |
| Layer bottom sheet | Navionics | P0 |
| Wind timeline | Windy | P0 |
| Tide curve | Tides Planner | P1 |
| Marina cards | Navily | P1 |
| Anchor circle | Anchor Alarm | P0 |
| AIS vectors | Marine Traffic | P1 |
| SOS 2-step | SafeTrx | P0 |
| VHF scenarios | VHF Talk | P2 |
| Knot steps | Knot Guide | P2 |

---

## 9. Уникальные фишки Captain Wrongel (нет у конкурентов в одном app)

1. **Glove mode** — 52dp targets, уже частично в settings
2. **Red night mode** — сохранение ночного зрения (добавить)
3. **Единый offline vault** — документы + маршруты + GRIB
4. **Advisory routing** с disclaimer gate (уже есть)
5. **Энергопрофили** eco/passage/sport (уже есть)
6. **COLREG + VHF + узлы** в одном toolbox

---

## 10. Эвристики Нильсена — оценка рынка

| # | Эвристика | Типичная проблема конкурентов | Решение CW |
|---|-----------|------------------------------|------------|
| 1 | Visibility of status | GPS fix неочевиден | Status pill на карте |
| 2 | Match real world | Морские единицы | Knots/nm по умолчанию |
| 3 | User control | Случайный zoom | Lock north-up toggle |
| 4 | Consistency | Разные UI в модулях | Единая design system |
| 5 | Error prevention | Случайный SOS | 2-step confirm (есть) |
| 6 | Recognition | Иконки без подписей | Tab labels always show |
| 7 | Flexibility | Нет glove mode | Settings toggle |
| 8 | Minimalist design | Windy перегружен | Progressive disclosure |
| 9 | Error recovery | Offline без UI | Cache badges |
| 10 | Help | Нет onboarding | 4-screen onboarding |

---

## 11. Клики до ключевых функций (целевые метрики)

| Задача | Конкуренты (средн.) | Цель CW |
|--------|---------------------|---------|
| Проверить ветер | 3–5 тапов | 1 тап (weather tab) |
| Поставить якорь | 4–6 тапов | 2 тапа (mooring→anchor) |
| SOS | 3–8 тапов | 2 тапа + confirm |
| Слой глубин | 3–4 тапа | 2 тапа (layer sheet) |
| AIS судно | 2–3 тапа | 2 тапа (tap marker) |
