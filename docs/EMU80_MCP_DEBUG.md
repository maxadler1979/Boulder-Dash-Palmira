# Emu80 MCP Debugger — шпаргалка
Лежит - C:\Users\pma\Desktop\Emu80qt_40565_qt6_mcp\Emu80qt.exe
## Что это

Emu80 v4.0+ с MCP-сервером, доступным по HTTP на `http://127.0.0.1:19266/mcp`.

- **Протокол:** JSON-RPC 2.0 (не SSE, не stdio — простой HTTP POST)
- **MCP версия:** `2024-11-05`
- **Платформы:** Пальмира, РК86, Специалист, Орион, Вектор, ZX Spectrum и ещё 20+
- **CPU:** 8080 (основной), Z80 (на некоторых платформах)

---

## Быстрый старт

### 1. Проверить что сервер жив

```bash
curl -s -X POST http://127.0.0.1:19266/mcp \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1"}}}'
```

Ответ: `"serverInfo":{"name":"Emu80","version":"4.0.xxx"}` — значит жив.

### 2. Узнать текущую платформу и состояние

```bash
curl -s -X POST http://127.0.0.1:19266/mcp \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"sys_info","arguments":{}}}'
```

Возвращает: `platform`, `cpu.type`, `cpu.breaked`, `cpu.clock`, `available_platforms[]`.

### 3. Базовый цикл: пауза → смотрим → запуск

```bash
# Пауза
curl ... -d '{"jsonrpc":"2.0","id":X,"method":"tools/call","params":{"name":"debug_break","arguments":{}}}'

# Состояние CPU
curl ... -d '{"jsonrpc":"2.0","id":X,"method":"tools/call","params":{"name":"cpu_state","arguments":{}}}'

# Запуск
curl ... -d '{"jsonrpc":"2.0","id":X,"method":"tools/call","params":{"name":"emu_run","arguments":{}}}'
```

---

## Все инструменты

### `sys_info` — информация о системе
```json
{"name":"sys_info","arguments":{}}
```
**Ответ:** `platform`, `cpu` {`type`, `breaked`, `paused`, `clock`, `speed_factor`, `full_throttle`}, `server` {`name`, `version`, `port`}, `available_platforms[]`.

---

### `cpu_state` — регистры CPU + флаги
```json
{"name":"cpu_state","arguments":{}}
```
**Ответ:**
```json
{
  "cpu_type": "8080",
  "breaked": true,
  "running": false,
  "paused": false,
  "registers": {
    "af": {"hex": "FF92", "dec": 65426},
    "bc": {"hex": "7070", "dec": 28784},
    "de": {"hex": "D770", "dec": 55152},
    "hl": {"hex": "E5FF", "dec": 58879},
    "pc": {"hex": "FD59", "dec": 64857},
    "sp": {"hex": "D7F8", "dec": 55288}
  },
  "psw": {"hex": "0092", "dec": 146},
  "flags": {"S":true,"Z":false,"H":true,"P":false,"N":true,"C":false},
  "instruction": "JNZ FD9E",
  "iff": false
}
```
**Особенности:**
- Для Z80 добавляются `af2, bc2, de2, hl2, ix, iy, i, r, im`
- `instruction` — мнемоника по адресу PC
- Адреса всегда в hex, дублируются в dec для удобства

---

### `regs_set` — установка регистров
```json
{"name":"regs_set","arguments":{"pc":"0100","hl":"8000","a":"3e"}}
```
**Параметры (все опциональны):**
- `af, bc, de, hl, sp, pc, psw, iff` — для всех CPU
- `af2, bc2, de2, hl2, ix, iy, i, r, im` — Z80 only
- Формат: hex строка (`"3E"`), `0x`-префикс (`"0x3E"`), `0o`-восьмеричное, или десятичное число
- ⚠️ Требует паузы (`debug_break`)

---

### `debug_break` — пауза
```json
{"name":"debug_break","arguments":{}}
```
Идемпотентно. Возвращает `{"breaked":true,"pc":"XXXX","instruction":"..."}`.

---

### `emu_run` — запуск
```json
{"name":"emu_run","arguments":{}}
```
Выход из паузы или старт CPU если остановлен. Возвращает `{"breaked":false,"running":true,"pc":"XXXX"}`.

---

### `debug_step` — пошаговое выполнение
```json
{"name":"debug_step","arguments":{"mode":"into"}}
```
**Режимы:**
- `"into"` (по умолчанию) — одна инструкция, вход в CALL
- `"over"` — шаг через CALL (не заходя внутрь)
- `"out"` — выполнение до RET
- `"skip"` — продвинуть PC без выполнения (NOP-замена)

⚠️ Требует паузы. Возвращает новый PC и инструкцию.

---

### `emu_reset` — холодный сброс
```json
{"name":"emu_reset","arguments":{}}
```
Сброс в вектор рестарта (0xE000 для Пальмиры, 0xF800 для РК86).

---

### `mem_read` — чтение памяти
```json
{"name":"mem_read","arguments":{"addr":"8000","len":256}}
```
- `addr` — **обязателен**. Hex строка, `0x`-префикс, восьмеричное или десятичное.
- `len` — 1..4096 (по умолчанию 64).
- **Ответ:** `hex` (компактный дамп) + `ascii` (непечатные → `.`).

---

### `disasm` — дизассемблер
```json
{"name":"disasm","arguments":{"addr":"0100","count":32}}
```
- `addr` — стартовый адрес (по умолчанию PC)
- `count` — 1..64 инструкций (по умолчанию 16)
- **Ответ:** массив `[{address, bytes[], instruction}, ...]`

---

### `bp_set` — установка брейкпоинта
```json
{"name":"bp_set","arguments":{"addr":"8120","type":"exec"}}
```
- `addr` — **обязателен**
- `type` — `"exec"` (по умолчанию) или `"access"`
- Дубликаты игнорируются

---

### `bp_list` — список брейкпоинтов
```json
{"name":"bp_list","arguments":{}}
```
**Ответ:** `[{index, addr, type}, ...]`

---

### `bp_remove` — снять брейкпоинт
```json
{"name":"bp_remove","arguments":{"addr":"8120"}}
```
Возвращает количество снятых.

---

### `bp_clear` — снять ВСЕ брейкпоинты
```json
{"name":"bp_clear","arguments":{}}
```

---

### `screen` — скриншот
```json
{"name":"screen","arguments":{"size":"native"}}
```
- `size`: `"native"` (сырой текстура, по умолчанию) или `"view"` (растянутое окно)
- **Ответ:** MCP image content block (PNG, base64) + размеры в пикселях

⚠️ Возвращает PNG даже если экран чёрный — эмулятор рендерит всегда.

---

### `disk_attach` / `disk_detach` — образы дисков
```json
{"name":"disk_attach","arguments":{"drive":"A","path":"/path/to/disk.img"}}
```
```json
{"name":"disk_detach","arguments":{"drive":"A"}}
```
- `drive`: A, B, C, D
- Может потребоваться `emu_reset` для применения

---

### `state_save` / `state_load` — снапшоты
🚫 **НЕ РЕАЛИЗОВАНО** в Emu80. Вернут ошибку.

---

## Типовые сценарии

### Сценарий 1: Где мы сейчас?
```bash
# Пауза → регистры → дизасм вокруг PC → скриншот
curl ... debug_break
curl ... cpu_state
curl ... '{"name":"disasm","arguments":{"addr":"<PC из cpu_state>","count":16}}'
curl ... screen
```

### Сценарий 2: Брейкпоинт и инспекция
```bash
# Ставим брейкпоинт → запуск → ждём попадания → смотрим
curl ... '{"name":"bp_set","arguments":{"addr":"8120"}}'
curl ... emu_run
# ... эмулятор работает, попадёт в bp — CPU сам встанет на паузу ...
curl ... cpu_state
curl ... '{"name":"mem_read","arguments":{"addr":"8000","len":256}}'
```

### Сценарий 3: Трассировка
```bash
for i in $(seq 1 10); do
  curl ... '{"name":"debug_step","arguments":{"mode":"into"}}'
  # читаем ответ, смотрим PC и инструкцию
done
```

### Сценарий 4: Патч на лету (если бы был mem_write)
```bash
# Было бы: curl ... '{"name":"mem_write","arguments":{"addr":"8123","data":"00"}}'
# Пока只能用 regs_set + debug_step skip
```

---

## Адресное пространство (Boulder Dash на Пальмире)

```
0x0000-0x7FFF  RAM (64K, банкированный через lowerMem mapper)
0x8000-0xBFFF  RAM/устройства (банкированный через upperMem mapper)
0xC000-0xC1FF  CRT8275 (видеоконтроллер)
0xC200-0xC3FF  PPI1 (клавиатура, магнитофон)
0xC400-0xC5FF  PPI2 (SD-карта)
0xCC00-0xCDFF  PIT8253 (таймер-счётчик, звук)
0xCE00-0xCFFF  Регистр конфигурации (write-only)
0xD000-0xD7FF  RAM3 (доп. 2K)
0xD800-0xDFFF  Font RAM (знакогенератор)
0xE000-0xFFFF  ROM (ПЗУ, read-only) / DMA (write-only)
```

### Где искать данные игры (после загрузки blddash.rkl):
- `work_cave[]` — где-то в 0x8000+ (extern массив 800 байт)
- `MapObj[]` — таблица указателей на спрайты
- Стек: обычно в верхней RAM (0x7Fxx или 0xD7xx)
- Код игры: начинается с адреса загрузки `.rkr` файла

### Как найти work_cave:
```bash
# Смотрим .map файл после компиляции:
grep "work_cave" a.map
# Или через дизассемблер: найти LXI H,XXXX где XXXX = адрес work_cave
```

---

## Полезные однострочники

```bash
# Быстрая пауза + PC
curl -s -X POST http://127.0.0.1:19266/mcp -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"debug_break","arguments":{}}}' \
  | python3 -c "import sys,json; r=json.load(sys.stdin)['result']['content'][0]['text']; d=json.loads(r); print(f'PC={d[\"pc\"]}  {d[\"instruction\"]}')"

# Дамп памяти с подсветкой ненулевых байт
curl -s ... mem_read '{"addr":"8000","len":800}' | python3 -c "
import sys,json,re
t=json.load(sys.stdin)['result']['content'][0]['text']
d=json.loads(t)
hex_str=d['hex']
# показать только строки с ненулевыми байтами
for line in hex_str.split('\n'):
    if any(b!='00' for b in line.split()[1:]):
        print(line)
"

# Сохранить скриншот
curl -s ... screen | python3 -c "
import sys,json,base64
r=json.load(sys.stdin)['result']['content']
for c in r:
    if c.get('type')=='image':
        with open('screenshot.png','wb') as f:
            f.write(base64.b64decode(c['data']))
        print('Saved screenshot.png')
"
```

---

## Ограничения (чего нет)

| Отсутствует | Workaround |
|-------------|------------|
| `mem_write` | `regs_set` + `debug_step skip` для мелких правок; перекомпиляция для крупных |
| `emu_key` | Ручной ввод в окне эмулятора |
| `emu_load` | Копировать `.rkl` в `palmira/sdcard/GAMES/` и загружать из меню эмулятора |
| `state_save/load` | Не реализовано в Emu80 |
| Watchpoints | Ставить `bp_set access`, но только exec-брейкпоинты |

---

## Формат аргументов

Все адреса и числа принимаются в 4 форматах:
- `"3E"` — hex строка (по умолчанию)
- `"0x3E"` — с префиксом
- `"0o76"` — восьмеричное
- `62` — десятичное целое

---

## Как это подключено

MCP-сервер встроен в Emu80qt.exe. Запускается вместе с эмулятором.
Адрес: `http://127.0.0.1:19266/mcp`
Протокол: JSON-RPC 2.0 через HTTP POST (не SSE, не stdio)
Транспорт: каждый вызов — отдельный POST, ответ — JSON.

Для Claude Code: добавить в `settings.json`:
```json
{
  "mcpServers": {
    "emu80": {
      "type": "http",
      "url": "http://127.0.0.1:19266/mcp"
    }
  }
}
```

---

## Шаблон для нового проекта

```bash
# 1. Проверить платформу
curl -s -X POST http://127.0.0.1:19266/mcp \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"sys_info","arguments":{}}}' \
  | python3 -c "import sys,json; print(json.loads(json.load(sys.stdin)['result']['content'][0]['text'])['platform'])"

# 2. Сбросить
curl ... '{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"emu_reset","arguments":{}}}'

# 3. Загрузить программу (руками в GUI или через SD-карту)

# 4. Поставить брейкпоинт на точку входа
curl ... '{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"bp_set","arguments":{"addr":"0100"}}}'

# 5. Запустить
curl ... '{"jsonrpc":"2.0","id":4,"method":"tools/call","params":{"name":"emu_run","arguments":{}}}'

# 6. Пауза + скриншот
curl ... debug_break
curl ... screen
```
