#!/usr/bin/env python3
"""
make_rk.py — упаковка a.bin в bin/blddash.rka для Апогей БК-01 / Emu80.

Формат как у РК (start/end + data + xor), расширение .rka:
  [start_hi][start_lo][end_hi][end_lo][data…][xor][0]
"""

import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
BIN_DIR = os.path.join(HERE, "..", "bin")
OUT_NAME = os.path.join(BIN_DIR, "blddash.rka")


def main():
    abin = os.path.join(HERE, "a.bin")
    if not os.path.exists(abin):
        print("ERROR: a.bin not found. Run compile first.")
        sys.exit(1)

    data = open(abin, "rb").read()
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

    os.makedirs(BIN_DIR, exist_ok=True)
    open(OUT_NAME, "wb").write(out)
    print(f"a.bin: {len(open(abin, 'rb').read())} bytes, start=0x{start:04X}, end=0x{end:04X}")
    print(f"{OUT_NAME}: {len(out)} bytes written")


if __name__ == "__main__":
    main()
