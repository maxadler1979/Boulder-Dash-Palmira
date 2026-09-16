# Boulder Dash C64 Disassembly

**Источник:** https://www.retrointernals.org/boulder-dash/boulder-dash-disassembly
**Дата сборки:** 2025-03-20
**Платформа:** Commodore 64 (MOS 6502 / 6510)
**Адреса:** $5000 - $9f38 (и выше для runtime данных)

## Структура проекта

```
boulder_dash/
├── README.md                          # Этот файл
├── docs/
│   ├── disassembly_raw.txt            # Сырой текст дизассемблирования
│   ├── disassembly.html               # Оригинальный HTML
│   ├── memory_map.md                  # Карта памяти
│   ├── data_structures.md             # Структуры данных
│   └── images/                        # Изображения из дизассемблирования
├── src/
│   ├── boulder_dash_disassembly.txt   # Полный дизассемблинг (текст)
│   └── boulder_dash.asm               # Форматированный ассемблерный код
├── data/
│   └── caves.asm                      # Определения всех пещер (уровней)
└── tools/                             # Утилиты для портирования
```

## Обзор игры

Boulder Dash — классическая игра 1984 года для C64, созданная Петером Лиепой (Peter Liepa) и Крисом Греем (Chris Grey). Игрок управляет Рокфордом (Rockford), собирая алмазы и избегая падающих валунов.

## Технические характеристики

- **Процессор:** MOS 6510 (6502)
- **Графика:** VIC-II (мультицветный режим)
- **Звук:** SID 6581/8580
- **Карта персонажей:** $5000 (TitleCharData)
- **Карта тайлов игры:** $0c00 (GameTileMap1)
- **Память инфлейт-пещеры:** $4003 - $4dc2
- **Экранная память:** $0400 (стандартная) / бэк-буфер $9800

## Карта памяти (ключевые адреса)

### Данные (ПЗУ / загрузка)

| Адрес | Размер | Название | Описание |
|-------|--------|----------|----------|
| $5000 | $03b0 | TitleCharData | Шрифт/графика титульного экрана |
| $53b0 | $002a | InflatedCaveOffsetAdjustTable | Преобразование смещений клеток пещеры |
| $53da | $002c | InflatedCaveLineAddressTable | Адреса строк инфлейт-пещеры ($4003+) |
| $5406 | $0400 | AnimatedCharData | Данные анимированных символов |
| $5806 | $0028 | LevelOffsetArray | Таблица смещений уровней |
| $582e+ | ~$0600 | CaveData (A-T, Bonus) | Определения 20+ уровней |
| $852+ | | MusicData | Музыкальные данные |
| $875 | | GameCharData | Графические символы игры |

### Код (основные процедуры)

| Адрес | Название | Описание |
|-------|----------|----------|
| $6ad0 | TimeBasedRandomNumber | Генератор случайных чисел на основе таймера CIA |
| $6af9 | SetupColourRam | Настройка Colour RAM |
| $6ad0 | BackupTopLine | Сохранение верхней строки |
| $6b19 | SetTopLineText | Установка текста верхней строки |
| $6d00 | SetCellInInflatedCave | Установка клетки в инфлейт-пещере |
| $6d3b | SetCell | Установка клетки |
| $6d5e | PseudoRandom | Псевдослучайный генератор |
| $6deb | Explode3x3CellsDownOneRow | Взрыв 3x3 со сдвигом вниз |
| $6e32 | Explode3x3Cells | Взрыв области 3x3 |
| $6e9b | TestForRockfordOrAmoeba | Проверка контакта с Рокфордом/амёбой |
| $6eb9 | ProcessFirefly | Обработка светлячка |
| $6f23 | ProcessButterfly | Обработка бабочки |
| $6f68 | ProcessFallingDiamond | Падающий алмаз |
| $6ff0 | ProcessStationaryDiamond | Неподвижный алмаз |
| $7038 | ProcessAmoeba | Обработка амёбы |
| $70a8 | ProcessExtraLife | Обработка дополнительной жизни |
| $7100 | IncrementScore | Увеличение счёта |
| $7130 | GameSecondTick | Игровая секунда |
| $7172 | SubSecondTick | Доли секунды |
| $7218 | CheckIfGotDiamondQuota | Проверка квоты алмазов |
| $72d0 | ProcessRockford | Обработка Рокфорда |
| $7343 | ProcessExplosion | Обработка взрыва |
| $73e4 | ProcessInAndOutBoxes | Входы/выходы |
| $73fb | ProcessStationaryBoulder | Неподвижный валун |
| $7418 | ProcessFallingBoulder | Падающий валун |
| $768b | Scroller | Скроллинг |
| $77ff | CoverLevel | Покрытие уровня |
| $7970 | ProcessCave | Главный цикл обработки пещеры |
| $7af4 | ExecuteLevelDrawCommands | Декодирование команд уровня |
| $7c1c | SetupTitleScreenText | Настройка титульного экрана |
| $7d2b | RunTitleScreen | Запуск титульного экрана |
| $7e9e | IRQHandler | Обработчик прерываний |
| $8086 | SetLevel | Установка уровня |
| $81cf | RunCave | Запуск пещеры |
| $828c | InitAll | Полная инициализация |
| $834e | InitGameState | Инициализация состояния игры |
| $83e2 | Main | Точка входа |

## Игровые объекты

Коды объектов в данных пещер:
```
$00 - Empty (пробел .)
$01 - Dirt (земля A)
$02 - Wall (стена B)
$03 - Magic wall (магическая стена C)
$04 - Exit (выход D)
$07 - Steel wall (стальная стена G)
$08 - Firefly (светлячок H)
$10 - Boulder (валун P)
$14 - Diamond (алмаз T)
$25 - Inbox (вход %)
$30 - Butterfly (бабочка 0)
$32 - Butterfly (бабочка 2)
$3a - Amoeba (амёба :)
```

## Формат команд пещеры

Каждый уровень закодирован как последовательность команд:
```
$00 - Single(x, y)          — одиночный объект
$40 - Line(x, y, len, dir)  — линия
$80 - FilledRect(x, y, w, h, interior) — заполненный прямоугольник
$c0 - Rect(x, y, w, h)      — прямоугольник (контур)
```

Направления: N=0, NE=1, E=2, SE=3, S=4, SW=5, W=6, NW=7

## Структура данных пещеры

Каждый уровень имеет заголовок из 32 ($20) байт:
```
Offset  | Описание
--------|------------------------------------------
$00     | CaveNumber
$01     | MagicWallMillingTimeOrAmoeba3PercentMax
$02     | InitialDiamondValue
$03     | ExtraDiamondValue
$04-$08 | InitialRandomSeed for sublevels 1-5
$09-$0d | DiamondsNeeded for sublevels 1-5
$0e-$12 | CaveTime for sublevels 1-5
$13     | BackgroundColour1
$14     | BackgroundColour2
$15     | ForegroundColour
$16-$17 | ?
$18-$1b | RandomObjectNumber 1-4
$1c-$1f | ProbabilityOfObject 1-4
```

## Инфлейт-пещера (Inflated Cave)

- Каждая логическая клетка пещеры занимает 2x2 символа
- Инфлейт-пещера расположена по адресам $4003 - $4dc2
- Указатель на NW клетку: CaveCurrentCellPtr
- Рассматриваемая клетка 'C' смещена от NW на +$29

## Система скроллинга

- Экран показывает подмножество инфлейт-пещеры
- Скроллинг отслеживает позицию Рокфорда
- Направления: по X и Y независимо

## Обработка прерываний

- **IRQ:** $7e9e — основной обработчик
  - Растровая линия для переключения экран/игра
  - Сканирование клавиатуры
  - Обработка звука и анимации
- **NMI:** $7058 — обработчик NMI

## Звуковая система (SID)

- 3 голоса SID используются для звуковых эффектов
- Музыка через MusicTickRoutine ($7cf3)
- Звуки: сбор алмаза, падение валуна, взрыв, амёба, магическая стена

## Заметки для портирования

1. **Аппаратные зависимости:**
   - VIC-II: заменить на графическую систему целевой платформы
   - SID: заменить на звуковую систему целевой платформы
   - CIA (таймеры, джойстик): заменить на систему ввода

2. **Структуры данных:**
   - Инфлейт-пещера $4003-$4dc2 (~$0dc0 байт = 3520)
   - 20 пещер (A-T) + 4 бонусных уровня
   - Каждая пещера ~64 байта описания

3. **Игровой цикл:**
   - ProcessCave → обработка всех клеток → Scroller → Animate → IRQ

4. **Генератор случайных чисел:**
   - TimeBasedRandomNumber ($6ad0) использует таймеры CIA
   - Псевдослучайный генератор ($6d5e) для детерминированного поведения

5. **Ключевые подсистемы для портирования:**
   - Графика: символы ($5000, $5406, $875)
   - Пещеры: ExecuteLevelDrawCommands ($7af4), ProcessCave ($7970)
   - Объекты: ProcessFirefly, ProcessButterfly, ProcessFallingBoulder/Diamond, ProcessAmoeba
   - Ввод: ReadJoystickDirection ($6d42), HandleJoystickForRockford ($7298)
   - Скроллинг: Scroller ($768b), GameIRQActions ($74c5)
