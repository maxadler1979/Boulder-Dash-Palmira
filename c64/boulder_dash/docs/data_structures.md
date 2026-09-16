# Структуры данных Boulder Dash

## Инфлейт-пещера (Inflated Cave)

Каждая логическая клетка пещеры занимает 2×2 символа в инфлейт-пещере. Это сделано для плавного скроллинга.

```
Логическая клетка:
+---+---+
| 0 | 1 |
+---+---+
| 2 | 3 |
+---+---+
```

Каждый символ хранит код объекта.

## Смещения внутри пещеры

Относительно NW (North-West) угла:

```
|NW:$00|N:$01|NE:$02|
|------+-----+------|
| W:$28|C:$29| E:$2a|
|------+-----+------|
|SW:$50|S:$51|SE:$52|
|======+=====+======|
|   $78|  $79|   $7a|
```

CaveCurrentCellPtr всегда указывает на NW клетку, а текущая клетка 'C' смещена на +$29.

## Коды объектов

```
Код  | Символ | Название          | Свойства
-----|--------|-------------------|---------------------------
$00  | .      | Empty (пусто)     | Проходим
$01  | A      | Dirt (земля)      | Можно копать
$02  | B      | Wall (стена)      | Непроходима
$03  | C      | Magic wall         | Превращает валуны в алмазы
$04  | D      | Exit (выход)       | Открывается при квоте
$07  | G      | Steel wall         | Неразрушима
$08  | H      | Firefly (светлячок)| Взрывается при контакте
$10  | P      | Boulder (валун)    | Падает, катится
$14  | T      | Diamond (алмаз)    | Падает, катится
$25  | %      | Inbox (вход)       | Точка появления
$30  | 0      | Butterfly (бабочка)| Взрывается при контакте
$32  | 2      | Butterfly variant  |
$3a  | :      | Amoeba (амёба)     | Растёт, убивает при касании
```

## Формат уровня (CaveData)

### Заголовок (32 байта = $20)

| Offset | Байт | Поле |
|--------|------|------|
| $00 | 1 | CaveNumber |
| $01 | 1 | MagicWallMillingTime / Amoeba3PercentMax |
| $02 | 1 | InitialDiamondValue |
| $03 | 1 | ExtraDiamondValue |
| $04 | 1 | InitialRandomSeed Sublevel 1 |
| $05 | 1 | InitialRandomSeed Sublevel 2 |
| $06 | 1 | InitialRandomSeed Sublevel 3 |
| $07 | 1 | InitialRandomSeed Sublevel 4 |
| $08 | 1 | InitialRandomSeed Sublevel 5 |
| $09 | 1 | DiamondsNeeded Sublevel 1 |
| $0a | 1 | DiamondsNeeded Sublevel 2 |
| $0b | 1 | DiamondsNeeded Sublevel 3 |
| $0c | 1 | DiamondsNeeded Sublevel 4 |
| $0d | 1 | DiamondsNeeded Sublevel 5 |
| $0e | 1 | CaveTime Sublevel 1 |
| $0f | 1 | CaveTime Sublevel 2 |
| $10 | 1 | CaveTime Sublevel 3 |
| $11 | 1 | CaveTime Sublevel 4 |
| $12 | 1 | CaveTime Sublevel 5 |
| $13 | 1 | BackgroundColour1 |
| $14 | 1 | BackgroundColour2 |
| $15 | 1 | ForegroundColour |
| $16 | 1 | ? (неизвестно) |
| $17 | 1 | ? (неизвестно) |
| $18 | 1 | RandomObjectNumber1 |
| $19 | 1 | RandomObjectNumber2 |
| $1a | 1 | RandomObjectNumber3 |
| $1b | 1 | RandomObjectNumber4 |
| $1c | 1 | ProbabilityOfObject1 |
| $1d | 1 | ProbabilityOfObject2 |
| $1e | 1 | ProbabilityOfObject3 |
| $1f | 1 | ProbabilityOfObject4 |

### Команды рисования уровня

После заголовка следуют команды. Каждая команда начинается с байта кода:

```
Биты: 7 6 5 4 3 2 1 0
      c c o o o o o o

cc = команда, oooooo = объект
```

**Команды:**

| Код | Команда | Формат |
|-----|---------|--------|
| $00 | Single | `[cmd_obj]` — один объект в (x,y) |
| $40 | Line | `[cmd_obj] [x] [y] [len] [dir]` — линия из len объектов |
| $80 | FilledRect | `[cmd_obj] [x] [y] [w] [h] [interior]` — заполненный прямоугольник |
| $c0 | Rect | `[cmd_obj] [x] [y] [w] [h]` — контур прямоугольника |

**Направления для Line:**
```
N=0, NE=1, E=2, SE=3, S=4, SW=5, W=6, NW=7
```

**Параметры Single:**
```
Байт 0: [ccoooooo] - команда + объект
         Объект помещается в (0,0)??? — уточнить
```

**Параметры Line:**
```
Байт 0: [ccoooooo] [xx] [yy] [len] [dir]
         xx, yy — позиция (байт кодирует x и y в половинках?)
```

**Параметры FilledRect:**
```
Байт 0: [ccoooooo] [xx] [yy] [ww] [hh] [interior_obj]
```

**Параметры Rect:**
```
Байт 0: [ccoooooo] [xx] [yy] [ww] [hh]
```

## Формат анимации

### GameCharData ($875)
Содержит определения игровых символов (шрифт).

### RockfordAnimationChars ($885)
Спрайт/символы для анимации Рокфорда:
- Моргание (blink)
- Топание ногами (foot tap)

### AnimatedCharData ($5406)
256 анимированных символов (characters).

## Таблицы объектов

### ObjCodeFromScannedThisTickCodeTable
Преобразование сканированного кода в код объекта.

### BaseCharNoForObjectTable
Базовый номер символа для каждого типа объекта (для рендеринга).

### ObjHandlerVectorTable
Векторы (адреса-1) обработчиков для каждого типа объекта в главном цикле ProcessCave.

## Случайные числа

### TimeBasedRandomNumber ($6ad0)
Читает таймеры CIA #1 и CIA #2, комбинирует через EOR/ADC.
Используется для некритичных случайных событий.

### PseudoRandom ($6d5e)
Линейный конгруэнтный генератор. Детерминирован (для воспроизводимости пещер).

## Звуковая система

### SID Voice Tables
- ExplosionSIDVoiceTable ($6e53)
- FallingBoulderSIDVoiceTable ($6f14)
- DiamondQuotaReachedSoundSIDValues ($711a)
- RockfordCollectingDiamondSIDValues ($7214)

### MusicData
Музыкальные последовательности с нотами и длительностями.

### MusicNoteToFreqTable ($7ce9)
Преобразование номера ноты в частоту SID.
