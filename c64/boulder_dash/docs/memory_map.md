# Карта памяти Boulder Dash C64

## Общая раскладка памяти

```
$0000-$00ff  Zero Page (переменные)
$0100-$01ff  Стек 6502
$0200-$03ff  Системные переменные / буферы
$0400-$07e7  Видеопамять (стандартный экран)
$0800-$0bff  Свободно / данные
$0c00-$0fff  GameTileMap1_or_TitleTextTileMap (карта тайлов)
$1000-$3fff  Свободно / код
$4000-$4fff  InflatedCave (инфлейт-пещера: $4003-$4dc2)
$5000-$53af  TitleCharData (графика титульного экрана)
$53b0-$53d9  InflatedCaveOffsetAdjustTable
$53da-$5405  InflatedCaveLineAddressTable
$5406-$5805  AnimatedCharData (анимированные символы)
$5806-$582d  LevelOffsetArray (20+4 уровней)
$582e-$5af0  CaveData A-T + Bonus (определения пещер)
$5b00-$6acf  Код и данные
$6ad0-$6aff  TimeBasedRandomNumber, SetupColourRam
$6b00-$7fff  Основной код игры
$8000-$9fff  Код игры (продолжение)
$9800-$9bff  BackBuffer (задний буфер видео)
$a000-$bfff  BASIC ROM (свободно при отключении)
$c000-$cfff  Свободно (под ROM)
$d000-$d3ff  VIC-II регистры
$d400-$d7ff  SID регистры
$d800-$dbff  Colour RAM
$dc00-$dcff  CIA #1
$dd00-$ddff  CIA #2
$de00-$dfff  Свободно
$e000-$ffff  KERNAL ROM (свободно при отключении)
```

## Zero Page переменные (выборочно)

| Адрес | Назначение |
|-------|-----------|
| $d6-$d7 | InflatedCaveSubset (указатель на подмножество пещеры) |
| $d8-$d9 | CaveCurrentCellPtr (указатель на NW клетку) |
| $a8 | ExtraLifeFXCounter |

## Видеопамять и буферы

| Адрес | Размер | Назначение |
|-------|--------|-----------|
| $0400-$07e7 | $03e8 | Стандартный экран C64 (40x25) |
| $0c00-$0fff | $0400 | Карта тайлов для игры / титульного экрана |
| $4003-$4dc2 | $0dc0 | Инфлейт-пещера (40x22 = 880 клеток × 4 байта) |
| $9800-$9bff | $0400 | Задний буфер видео |

## Данные игры

| Адрес | Размер | Название | Описание |
|-------|--------|----------|----------|
| $5000 | $03b0 | TitleCharData | Символы титульного экрана (шрифт) |
| $53b0 | $002a | OffsetAdjustTable | Преобразование смещений пещеры |
| $53da | $002c | LineAddressTable | Адреса строк инфлейт-пещеры |
| $5406 | $0400 | AnimatedCharData | 256 символов анимации |
| $5806 | $0028 | LevelOffsetArray | 20 смещений к уровням |
| $582e | вар. | CaveData A-T+Bonus | 20+4 определения уровней |
| ~$5b00 | вар. | DemoMoveData | Демо-движения |
| ~$5b10 | вар. | ObjCodeTable | Коды объектов |
| ~$5b20 | вар. | BaseCharNoTable | Базовые номера символов |
| ~$5b30 | вар. | ObjHandlerVectorTable | Векторы обработчиков объектов |
| ~$5c00 | вар. | MusicData | Музыкальные данные |
| ~$5d00 | вар. | GameCharData | Игровые символы |
| ~$5d80 | вар. | RockfordAnimationChars | Анимация Рокфорда |

## Код игры (основные блоки)

### $6ad0-$6e00: Утилиты
- TimeBasedRandomNumber
- SetupColourRam
- BackupTopLine / SetTopLineText
- SetCell / SetCellInInflatedCave
- PseudoRandom

### $6e00-$7200: Обработка объектов
- Explode3x3Cells / Explode3x3CellsDownOneRow
- ProcessHiddenOutbox
- ProcessFirefly / ProcessButterfly
- ProcessFallingDiamond / ProcessStationaryDiamond
- ProcessAmoeba
- TestForRockfordOrAmoeba

### $7200-$7500: Игровая логика
- ProcessExtraLife / IncrementScore
- CheckIfGotDiamondQuota
- GameSecondTick / SubSecondTick
- ProcessRockford / HandleJoystickForRockford
- TryToMoveRockford / RockfordTriesToMoveBoulder
- ProcessExplosion / ProcessRockfordsAppearance

### $7500-$7af0: Пещера и графика
- ProcessInAndOutBoxes
- ProcessStationaryBoulder / ProcessFallingBoulder
- ScrollingBGTick / Scroller
- CoverLevel / PadInflatedCave / UncoverCaveScreen
- ProcessCave (главный цикл)
- ExecuteLevelDrawCommands

### $7af0-$7fff: Титульный экран
- TitleScreenFillInPlayerAndJoystick
- SetupTitleScreenText
- RunTitleScreen

### $8000-$9000: Основной код
- SetLevel / InitPlayers
- LoseLife / KillPlayer
- CaveComplete / NextCave
- RunCave / DemoModeRunCave
- InitAll / InitGameState
- Main

### $9000-$9fff: Код и данные
- MOVEDCopyInflatedCaveSubsetToBackBuffer
- Таблицы и вспомогательный код
