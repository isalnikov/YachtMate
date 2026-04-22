# HTML-макеты интерфейса Captain Wrongel (после IDEAS2)

Статические страницы в **тёмно-синей** палитре с акцентами **оранжевый / бирюза**. Отражают структуру из [`../../plan/IDEAS2-structured.md`](../../plan/IDEAS2-structured.md): **5 пунктов нижнего меню** + хаб **«Ещё»** со всеми дополнительными модулями.

## Как открыть

```bash
cd docs/ui && python3 -m http.server 8765
```

Затем в браузере: `http://127.0.0.1:8765/index.html`

## Нижний док (5)

| Пункт | Файл |
|------|------|
| Карта | [map.html](map.html) |
| Маршрут | [route.html](route.html) — планирование (IDEAS2) |
| Погода | [weather.html](weather.html) — в т.ч. блок приливов `#tides` |
| Стоянка | [mooring.html](mooring.html) — марины, якорь, берег |
| Ещё | [more.html](more.html) — хаб всех остальных модулей |

## Хаб «Ещё» и вложенные экраны

- [ais.html](ais.html) — AIS и трафик  
- [community.html](community.html) — сообщество  
- [learn.html](learn.html) — обучение и справочники  
- [radio.html](radio.html) — УКВ / SMCP  
- [yacht.html](yacht.html) — журнал, бюджет, ТО, документы  
- [safety.html](safety.html) — SOS, чеклисты, мониторинг рейса  
- [tools.html](tools.html) — компас, GRIB, PDF, молнии*  
- [assistant.html](assistant.html) — офлайн ИИ (справка)  
- [settings.html](settings.html) — настройки  

## Прочее

- [index.html](index.html) — дисклеймер первого запуска  
- [menu.html](menu.html) — боковой аналог (Drawer)  
- [anchor.html](anchor.html) — полноэкранная якорная вахта (вход с `mooring.html`)  
- [navigation-map.html](navigation-map.html) — схема переходов  
- [logbook.html](logbook.html) — редирект на `yacht.html`  
- [marinas.html](marinas.html) — редирект на `mooring.html`  
- [styles.css](styles.css) — общие стили  

---

*Молнии: внешний слой при наличии сети, не навигационное решение.
