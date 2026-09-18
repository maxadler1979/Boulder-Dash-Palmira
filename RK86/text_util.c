#include <string.h>
#include <stdint.h>
#include "main.h"

/* Смещения строк: равномерно VIDEO_BPL (create_table). */

void create_table(void)
{
    unsigned int *t = (unsigned int *)SM_Y_ADDR;
    unsigned int off = 0;
    uchar y;
    for (y = 0; y < VIDEO_ROWS; y++) {
        t[y] = off;
        off += VIDEO_BPL;
    }
}

uchar* charAddr(uchar x, uchar y)
{
    unsigned int *t = (unsigned int *)SM_Y_ADDR;
    return radio86rkVideoMem + t[y] + x;
}

void put_char(uchar x, uchar y, uchar s)
{
    uchar* a = charAddr(x, y);
    *a = s;
}

void put_text(uchar x, uchar y, uchar* text, uchar len)
{
    uchar* a = charAddr(x, y);
    uchar g = 0;
    while (g < len) {
        a[g] = text[g];
        g++;
    }
}

void printf_letters(uchar x, uchar y, char* text)
{
    uchar n = 0;
    while (text[n]) n++;
    put_text(x, y, (uchar*)text, n);
}

void clrscr(void)
{
    fr_a = (uchar *)SCREEN;
    fr_w = VIDEO_BPL;
    fr_h = VIDEO_ROWS;
    fr_c = 0x20;
    fillRect();
    mark_dma_stop();
}
