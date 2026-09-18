#!/usr/bin/env python3
"""
make_rk.py — упаковка a.bin в blddash.rka для Апогей БК-01 / Emu80.

Формат как у РК (start/end + data + xor), расширение .rka:
  [start_hi][start_lo][end_hi][end_lo][data…][xor][0]
"""

import os
import sys


def main():
    if not os.path.exists("a.bin"):
        print("ERROR: a.bin not found. Run compile first.")
        sys.exit(1)

    data = open("a.bin", "rb").read()
    if len(data) == 0:
        print("ERROR: a.bin is empty")
        sys.exit(1)

    start = 0x0000
    size = len(data)
    if size & 1:
        data = data + b"\x00"
        size += 1
    end = start + size - 1

    chkh = 0
    for b in data:
        chkh ^= b

    out = bytearray()
    out.append(start >> 8)
    out.append(start & 0xFF)
    out.append(end >> 8)
    out.append(end & 0xFF)
    out.extend(data)
    out.append(chkh)
    out.append(0)

    open("blddash.rka", "wb").write(out)
    print(f"a.bin: {len(open('a.bin','rb').read())} bytes, start=0x{start:04X}, end=0x{end:04X}")
    print(f"blddash.rka: {len(out)} bytes written")


if __name__ == "__main__":
    main()
