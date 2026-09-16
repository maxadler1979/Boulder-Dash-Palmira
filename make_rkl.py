#!/usr/bin/env python3
"""
make_rkl.py — Python-версия -make-rka.js
Упаковывает a.bin в blddash.rkl (формат загрузки РК86).
Формат: [start_hi][start_lo][end_hi][end_lo][data][0][0][0][0xE6][crc_hi][crc_lo]
Все байты (кроме data) кодируются через tbl.bin.
"""

import sys
import os

def load_all(name):
    with open(name, 'rb') as f:
        return f.read()

def save(name, data):
    with open(name, 'wb') as f:
        f.write(data)

def apogey_sum(data, decode):
    s = 0
    for i in range(len(data) - 1):
        s += decode[data[i]] * 257
    s = (s & 0xFF00) + ((s + decode[data[-1]]) & 0xFF)
    return s & 0xFFFF

def main():
    # Загружаем таблицу кодирования
    tbl = load_all("tbl.bin")
    if len(tbl) != 256:
        print(f"ERROR: tbl.bin size is {len(tbl)}, expected 256")
        sys.exit(1)

    # Строим encode/decode
    encode = list(tbl)        # byte -> encoded char
    decode = [0] * 256        # encoded char -> byte
    for i in range(256):
        decode[encode[i]] = i

    # Загружаем скомпилированный бинарник
    if not os.path.exists("a.bin"):
        print("ERROR: a.bin not found. Run compile first.")
        sys.exit(1)

    data = load_all("a.bin")
    if len(data) == 0:
        print("ERROR: a.bin is empty")
        sys.exit(1)

    start = 0x0000
    end = start + len(data) - 1
    crc = apogey_sum(data, decode)

    print(f"a.bin: {len(data)} bytes, start=0x{start:04X}, end=0x{end:04X}, crc=0x{crc:04X}")

    # Формируем выходной файл
    out = bytearray()
    out.append(encode[start >> 8])
    out.append(encode[start & 0xFF])
    out.append(encode[end >> 8])
    out.append(encode[end & 0xFF])
    out.extend(data)
    out.append(encode[0])
    out.append(encode[0])
    out.append(encode[0])
    out.append(encode[0xE6])
    out.append(encode[crc >> 8])
    out.append(encode[crc & 0xFF])

    save("blddash.rkl", bytes(out))
    print(f"blddash.rkl: {len(out)} bytes written")

if __name__ == '__main__':
    main()
