#include "main.h"

/* Лого Claude: 16x7 знакомест, без заголовка ширины/высоты — logo_draw() знает размер. */
const char claudecode[112] = {
    0x00, 0x00, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x00, 0x00,
    0x00, 0x00, 0x3f, 0x3f, 0x03, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x03, 0x3f, 0x3f, 0x00, 0x00,
    0x30, 0x30, 0x3f, 0x3f, 0x30, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x30, 0x3f, 0x3f, 0x30, 0x30,
    0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f,
    0x00, 0x00, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x00, 0x00,
    0x00, 0x00, 0x03, 0x3f, 0x03, 0x3f, 0x03, 0x03, 0x03, 0x03, 0x3f, 0x03, 0x3f, 0x03, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x0f, 0x00, 0x0f, 0x00, 0x00, 0x00, 0x00, 0x0f, 0x00, 0x0f, 0x00, 0x00, 0x00
};

uchar* VI53 = (uchar*)0xcc00;
uchar* VI54 = (uchar*)0xcc03;
const char B_let[90] = {11,8,
    0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3d, 0x10, 
    0x3f, 0x3f, 0x1f, 0x0f, 0x0f, 0x0f, 0x0f, 0x3f, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x40, 0x40, 0x3f, 
    0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x1f, 
    0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x37, 0x40, 
    0x3f, 0x3f, 0x1f, 0x0f, 0x0f, 0x0f, 0x0f, 0x3d, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x40, 0x40, 0x3f, 
    0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 
    0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 
    0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x07, 
    0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x40, 0x40
};
const char o_let[56] = {9,6,
    0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 
    0x3f, 0x3f, 0x17, 0x03, 0x03, 0x3f, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x3f, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x3f, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x3f, 
    0x3f, 0x3f, 0x3d, 0x3c, 0x3c, 0x3f, 
    0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 
    0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 
    0x03, 0x03, 0x03, 0x03, 0x03, 0x03
};
const char u_let[56] = {9,6,
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x3f, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x3f, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x3f, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x3f, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x3f, 
    0x3f, 0x3f, 0x3d, 0x3c, 0x3c, 0x3f, 
    0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 
    0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 
    0x03, 0x03, 0x03, 0x03, 0x03, 0x03
};
const char l_let[56] = {9,6,
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x40, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x40, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x40, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x40, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x40, 
    0x3f, 0x3f, 0x3d, 0x3c, 0x3c, 0x3c, 
    0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 
    0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 
    0x03, 0x03, 0x03, 0x03, 0x03, 0x03
};
const char d_let[56] = {9,6,
    0x3f, 0x3f, 0x3f, 0x3f, 0x3d, 0x34, 
    0x3f, 0x3f, 0x17, 0x03, 0x03, 0x3f, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x3f, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x3f, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x3f, 
    0x3f, 0x3f, 0x3d, 0x3c, 0x3c, 0x3f, 
    0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 
    0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x1f, 
    0x03, 0x03, 0x03, 0x03, 0x01, 0x40
};
const char e_let[56] = {9,6,
    0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 
    0x3f, 0x3f, 0x17, 0x03, 0x03, 0x03, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x40, 
    0x3f, 0x3f, 0x3f, 0x3f, 0x15, 0x40, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x40, 
    0x3f, 0x3f, 0x3d, 0x3c, 0x3c, 0x3c, 
    0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 
    0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 
    0x03, 0x03, 0x03, 0x03, 0x03, 0x03
};
const char r_let[56] = {9,6,
    0x3f, 0x3f, 0x3f, 0x3f, 0x3d, 0x34, 
    0x3f, 0x3f, 0x17, 0x03, 0x03, 0x3f, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x3f, 
    0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x0f, 
    0x3f, 0x3f, 0x3f, 0x3f, 0x3d, 0x30, 
    0x3f, 0x3f, 0x17, 0x03, 0x03, 0x3f, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x3f, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x3f, 
    0x03, 0x03, 0x01, 0x40, 0x40, 0x03
};
const char D1_let[82] = {10,8,
    0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3d, 0x30, 
    0x3f, 0x3f, 0x17, 0x03, 0x03, 0x03, 0x03, 0x3f, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x40, 0x40, 0x3f, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x40, 0x40, 0x3f, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x40, 0x40, 0x3f, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x40, 0x40, 0x3f, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x40, 0x40, 0x3f, 
    0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 
    0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 
    0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x1f, 0x07
};
const char a_let[56] = {9,6,
    0x40, 0x2a, 0x3f, 0x3f, 0x3d, 0x30, 
    0x30, 0x3a, 0x1f, 0x0f, 0x0f, 0x3f, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x3f, 
    0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 
    0x3f, 0x3f, 0x17, 0x03, 0x03, 0x3f, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x3f, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x3f, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x3f, 
    0x0f, 0x0f, 0x05, 0x40, 0x40, 0x0f
};
const char s_let[56] = {9,6,
    0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 
    0x3f, 0x3f, 0x1f, 0x0f, 0x0f, 0x0f, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x40, 
    0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 
    0x03, 0x03, 0x03, 0x2b, 0x3f, 0x3f, 
    0x40, 0x40, 0x40, 0x2a, 0x3f, 0x3f, 
    0x3c, 0x3c, 0x3c, 0x3e, 0x3f, 0x3f, 
    0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 
    0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f
};
const char h_let[74] = {9,8,
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x40, 0x40, 0x3f, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x40, 0x40, 0x3f, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x40, 0x40, 0x3f, 
    0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 0x3f, 
    0x3f, 0x3f, 0x17, 0x03, 0x03, 0x03, 0x03, 0x3f, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x40, 0x40, 0x3f, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x40, 0x40, 0x3f, 
    0x3f, 0x3f, 0x15, 0x40, 0x40, 0x40, 0x40, 0x3f, 
    0x0f, 0x0f, 0x05, 0x40, 0x40, 0x40, 0x40, 0x0f
};

// ============================================================
// Защита бренда PALMIRA. Не править, не поняв цепочку:
//   спрайты букв -> 16-битная чексумма -> ключи XOR -> строки
//
// В бинарнике «PALMIRA ORIGINAL SOFTWARE» — случайные байты.
// brand_verify() суммирует 11 больших букв (B_let..h_let, 694 байта
// подряд в памяти). Ожидание 0x8715. Младший байт — ключ PALMIRA (0x15),
// старший — SOFTWARE (0x87). Патч любой буквы ломает ключи, строки
// декодируются в мусор. Патч строк без знания ключей тоже бесполезен.
// ============================================================
static const unsigned char brand_palmira_enc[] = {
    0x45,0x54,0x59,0x58,0x5c,0x47,0x54,0x35,
    0x5a,0x47,0x5c,0x52,0x5c,0x5b,0x54,0x59,0x15
};
static const unsigned char brand_software_enc[] = {
    0xd4,0xc8,0xc1,0xd3,0xd0,0xc6,0xd5,0xc2,0x87
};

// Expected 16-bit sum of all 11 big letter sprites (B_let..h_let)
#define BRAND_SPRITE_CSUM  0x8715
#define BRAND_KEY_PALMIRA  0x15   // low byte of checksum
#define BRAND_KEY_SOFTWARE 0x87   // high byte of checksum

char brand_tampered;               // 0=clean, non-zero=someone was here
static unsigned char brand_buf[18]; // decode buffer (longest string + NUL)

// Compute 16-bit checksum of all brand letter sprites (B_let..h_let, 694 bytes).
// Sprites are contiguous in memory — verify as one block.
static void brand_verify(void)
{
    unsigned int sum = 0;
    unsigned int i;
    const unsigned char *p = (const unsigned char*)B_let;

    for (i = 0; i < 694; i++) sum += p[i];

    if (sum != BRAND_SPRITE_CSUM)
        brand_tampered = 1;
}

// Decode a brand string in-place into brand_buf.
// Returns pointer to NUL-terminated decoded string.
static unsigned char* brand_decode(const unsigned char *enc, unsigned char len, unsigned char key)
{
    unsigned char i;
    for (i = 0; i < len; i++) brand_buf[i] = enc[i] ^ key;
    return brand_buf;
}

const char d0_dig[14] = {3,4,
    0x38, 0x1c, 0x2c, 0x10, 
    0x3f, 0x15, 0x2a, 0x15, 
    0x0b, 0x0f, 0x0f, 0x01
};
const char d1_dig[14] = {3,4,
       0x00, 0x38, 0x14, 0x00, 
    0x00, 0x2b, 0x15, 0x00, 
    0x0a, 0x0f, 0x0f, 0x05
};
const char d2_dig[14] = {3,4,
    0x38, 0x0c, 0x3c, 0x10, 
    0x20, 0x3e, 0x07, 0x00, 
    0x0f, 0x0f, 0x0f, 0x05
};
const char d3_dig[14] = {3,4,
    0x08, 0x0c, 0x3c, 0x04, 
    0x30, 0x12, 0x2d, 0x10, 
    0x0b, 0x0f, 0x0f, 0x01
};
const char d4_dig[14] = {3,4,
     0x3c, 0x00, 0x00, 0x00, 
    0x0f, 0x2e, 0x3f, 0x04, 
    0x00, 0x0a, 0x0f, 0x00
};
const char d5_dig[14] = {3,4,
    0x3c, 0x1c, 0x0c, 0x04, 
    0x33, 0x13, 0x2b, 0x14, 
    0x0b, 0x0f, 0x0f, 0x01
};
const char d6_dig[14] = {3,4,
    0x38, 0x1c, 0x0c, 0x00, 
    0x3f, 0x17, 0x2b, 0x14, 
    0x0b, 0x0f, 0x0f, 0x01
};
const char d7_dig[14] = {3,4,
        0x1c, 0x0c, 0x3c, 0x14, 
    0x20, 0x3e, 0x07, 0x00, 
    0x0f, 0x05, 0x00, 0x00
};
const char d8_dig[14] = {3,4,
    0x38, 0x1c, 0x2c, 0x10, 
    0x3e, 0x17, 0x2b, 0x14, 
    0x0b, 0x0f, 0x0f, 0x01
};
const char d9_dig[14] = {3,4,
    0x38, 0x1c, 0x2c, 0x10, 
    0x0b, 0x2d, 0x3e, 0x05, 
    0x08, 0x0f, 0x01, 0x00
};

unsigned char *Digits[] =
{
 d0_dig,d1_dig,d2_dig,d3_dig,d4_dig,d5_dig,d6_dig,d7_dig,d8_dig,d9_dig
};
const char l_a[14] = {3,4,
    0x20, 0x3c, 0x34, 0x00, 
    0x3f, 0x35, 0x3a, 0x15, 
    0x0f, 0x05, 0x0a, 0x05
};
const char l_b[14] = {3,4,
    0x3c, 0x1c, 0x2c, 0x10, 
    0x3f, 0x17, 0x2b, 0x14, 
    0x0f, 0x0f, 0x0f, 0x01
};
const char l_c[14] = {3,4,
    0x38, 0x1c, 0x2c, 0x10, 
    0x3f, 0x15, 0x20, 0x10, 
    0x0b, 0x0f, 0x0f, 0x01
};
const char l_d[14] = {3,4,
    0x3c, 0x1c, 0x34, 0x00, 
    0x3f, 0x15, 0x2a, 0x15, 
    0x0f, 0x0f, 0x07, 0x00
};
const char l_e[14] = {3,4,
    0x3c, 0x1c, 0x0c, 0x04, 
    0x3f, 0x17, 0x03, 0x00, 
    0x0f, 0x0f, 0x0f, 0x05
};
const char l_f[14] = {3,4,
    0x3c, 0x1c, 0x0c, 0x04, 
    0x3f, 0x17, 0x03, 0x00, 
    0x0f, 0x05, 0x00, 0x00
};
const char l_g[14] = {3,4,
    0x38, 0x1c, 0x0c, 0x04, 
    0x3f, 0x15, 0x2c, 0x14, 
    0x0b, 0x0f, 0x0f, 0x05
};
const char l_h[14] = {3,4,
    0x3c, 0x14, 0x28, 0x14, 
    0x3f, 0x17, 0x2b, 0x15, 
    0x0f, 0x05, 0x0a, 0x05
};
const char l_i[14] = {3,4,
    0x08, 0x3c, 0x1c, 0x00, 
    0x00, 0x3f, 0x15, 0x00, 
    0x0a, 0x0f, 0x0f, 0x00
};
const char l_j[14] = {3,4,
    0x00, 0x00, 0x28, 0x14, 
    0x30, 0x10, 0x2a, 0x15, 
    0x02, 0x0f, 0x0f, 0x01
};
const char l_k[14] = {3,4,
    0x3c, 0x14, 0x38, 0x04, 
    0x3f, 0x1f, 0x35, 0x00, 
    0x0f, 0x05, 0x0a, 0x05
};
const char l_l[14] = {3,4,
    0x3c, 0x14, 0x00, 0x00, 
    0x3f, 0x15, 0x00, 0x00, 
    0x0f, 0x0f, 0x0f, 0x05
};
const char l_m[14] = {3,4,
    0x3c, 0x10, 0x38, 0x14, 
    0x3f, 0x0b, 0x2b, 0x15, 
    0x0f, 0x00, 0x0a, 0x05
};
const char l_n[14] = {3,4,
    0x3c, 0x10, 0x28, 0x14, 
    0x3f, 0x2f, 0x3e, 0x15, 
    0x0f, 0x00, 0x0b, 0x05
};
const char l_o[14] = {3,4,
    0x38, 0x0c, 0x2c, 0x10, 
    0x3f, 0x00, 0x2a, 0x15, 
    0x0b, 0x0f, 0x0f, 0x01
};
const char l_p[14] = {3,4,
    0x3c, 0x1c, 0x2c, 0x10, 
    0x3f, 0x3d, 0x3e, 0x05, 
    0x0f, 0x05, 0x00, 0x00
};
const char l_q[14] = {3,4,
    0x30, 0x1c, 0x2c, 0x10, 
    0x3f, 0x15, 0x3a, 0x05, 
    0x02, 0x0f, 0x0b, 0x05
};
const char l_r[14] = {3,4,
    0x3c, 0x1c, 0x2c, 0x10, 
    0x3f, 0x3d, 0x3e, 0x01, 
    0x0f, 0x05, 0x0a, 0x05
};
const char l_s[14] = {3,4,
    0x38, 0x1c, 0x0c, 0x00, 
    0x02, 0x03, 0x2b, 0x14, 
    0x0f, 0x0f, 0x0f, 0x01
};
const char l_t[14] = {3,4,
    0x0c, 0x3c, 0x1c, 0x04, 
    0x00, 0x3f, 0x15, 0x00, 
    0x00, 0x0f, 0x05, 0x00
};
const char l_u[14] = {3,4,
    0x3c, 0x14, 0x28, 0x14, 
    0x3f, 0x15, 0x2a, 0x15, 
    0x0f, 0x0f, 0x0f, 0x05
};
const char l_v[14] = {3,4,
    0x3c, 0x14, 0x28, 0x14, 
    0x3f, 0x35, 0x3a, 0x15, 
    0x02, 0x0f, 0x07, 0x00
};
const char l_w[14] = {3,4,
    0x3c, 0x00, 0x28, 0x14, 
    0x3f, 0x38, 0x3a, 0x15, 
    0x0f, 0x01, 0x0b, 0x05
};
const char l_x[14] = {3,4,
    0x3c, 0x14, 0x28, 0x14, 
    0x30, 0x1f, 0x2f, 0x10, 
    0x0f, 0x05, 0x0a, 0x05
};
const char l_y[14] = {3,4,
    0x3c, 0x00, 0x28, 0x14, 
    0x02, 0x3f, 0x17, 0x00, 
    0x00, 0x0f, 0x05, 0x00
};
const char l_z[14] = {3,4,
    0x3c, 0x3c, 0x3c, 0x04, 
    0x20, 0x1e, 0x01, 0x00, 
    0x0f, 0x0f, 0x0f, 0x05
};

const char l_dd[14] = {3,4,
    0x00, 0x20, 0x10, 0x00, 
    0x00, 0x22, 0x11, 0x00, 
    0x00, 0x02, 0x01, 0x00
};
const char space[14] = {3,4,
    0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00, 
    0x00, 0x00, 0x00, 0x00
};
uint16_t bd_music_1ch[128] = {10339,8155,6880,5169,9162,7738,6880,4581,6468,5768,5169,4319,5768,3056,5444,3440,
							  10339,5169,13760,9162,11536,4581,9162,11536,10339,5169,13760,9162,6468,2584,5169,6468,
						      11536,5768,15476,10339,7263,2884,5768,7263,13760,5444,12226,5169,7738,7738, 3869,7738,
						      5169,5169,5169,5169,5169,5169,5169,5169,5169,5169,5169,5169,5169,5169,5169,5169,
						      5169,5169,5169,5169,5169,5169,5169,5169,5169,5169,5169,5169,5768,5768,5768,5768,
						      5169,2584,5169,2884,5169,3056,5169,3440,5768,2884,5768,2884,5768,3869,5768,2884,
						      5169,5169,5169,5169,5169,5169,5169,5169,5169,5169,5169,5169,5768,5768,5768,5768,
						      4077,5169,6880,8155,4581,5768,7738,11536,4077,5169,6880,8155,4581,5768,7738,11536
};
uint16_t bd_music_2ch[128] = {20678,13760,10339,8639,23073,12226,11536,7738,25874,25874,12937,25874,11536,3869,10889,4319,
							  20678,20678,20678,20678,23073,23073,23073,23073,20678,20678,20678,20678,12937,12937,12937,12937,
							  23073,23073,23073,23073,14526,14526,14526,14526,27520,6880,27520,6880,30953,30953,20678,20678,
							  20678,20678,20678,20678,10339,10339,20678,20678,23073,23073,23073,23073,11536,11536,23073,23073,
							  20678,4077,20678,3869,10339,4077,20678,3869,23073,4077,23073,3869,11536,4581,23073,4319,
							  20678,20678,20678,3440,10339,10339,20678,4319,23073,23073,23073,23073,11536,11536,23073,23073,
							  20678,4077,20678,3869,10339,4077,20678,3869,23073,4077,23073,3869,11536,4581,23073,4319,
							  5169,6880,8155,10339,5768,7738,9162,23073,3440,4077,5169,6880,7738,9162,11536,23073

};

void play_note(unsigned int note_ch1, unsigned int note_ch2)
{
VI53[0] = note_ch1;
VI53[0] = note_ch1>>8;
VI53[1] = note_ch2;
VI53[1] = note_ch2>>8;

}
void sound_mute(void)
{
#asm
    LD  HL, 0cc03h
    LD  (HL),36H
    LD  (HL),66H
    LD  (HL),0B6H
#endasm

}

// ============================================================
// In-game SFX engine (КР580ВИ53 PIT).
// ch0 = events (diamond/boulder/explosion), ch1 = movement.
// A tone is a 16-bit divisor written to the channel (smaller =
// higher pitch); silence = re-arm the mode-3 control word.
// Game logic only flags events; sound_update() runs once/frame.
// ============================================================
unsigned char ev_id = 0;   // active event sound id (0 = none)
unsigned char ev_t  = 0;   // frames remaining on ch0
unsigned char mv_t  = 0;   // frames remaining on ch1 (movement)
unsigned char mv_k  = 0;   // movement kind: 0=space (click), 1=dirt (rumble)
unsigned char fall_dia_toggle = 0;  // alternates "ding"/"don" for diamond falls

// SFX divisor tables. Frame 0 plays sound, frame 1 loads near-silence.
// PIT_CLK ≈ 1.8 MHz.  div=25000 -> 72 Hz (sub-audible = "silence").
static const uint16_t dia_div[5]      = {6000, 7000, 8000, 7000, 6000}; // diamond: rise-fall rumble
static const uint16_t fall_dia_div[2]  = {1200, 2000};           // diamond fall: "ding" (higher)
static const uint16_t fall_dia2_div[2] = {2500, 4000};           // diamond fall: "don" (higher)
static const uint16_t boul_div[2]      = {9000, 12000};          // boulder: thud
static const uint16_t expl_div[6]     = {4500,6000,8000,12000,18000,24000}; // explosion
static const uint16_t move_div[2]     = {1800, 25000};           // walk: click->silence
static const uint16_t move_dirt_div[2] = {4000, 25000};          // dig: thud->silence
// tap sound now uses direct PIT write (see sound_tap)
static const unsigned char ev_dur[6] = {0, 2, 2, 5, 6};        // fall=2,boul=2,dia=5,expl=6

// --- Diamond-quota celebration jingle ---
// 4 bright ascending notes × 3 ticks each = 12 ticks (1.5 sec at 8 t/s)
unsigned char quota_jingle_t;                         // >0 = jingle active, counts down
unsigned char quota_jingle_phase;                     // current note 0-3
unsigned char quota_jingle_sub;                       // sub-counter 0-2 per note
#define QUOTA_JINGLE_LEN 12
static const uint16_t quota_jingle_div[4] = {5169, 4319, 3440, 3056};  // ascending, cheerful

// --- Exit entrance celebration jingle ---
// 5 bright ascending notes × 3 ticks each = 15 ticks (~1.9 sec at 8 t/s)
// C5→E5→G5→C6→E6: звонкий перебор вверх
unsigned char exit_jingle_t;                          // >0 = jingle active, counts down
unsigned char exit_jingle_phase;                      // current note 0-4
unsigned char exit_jingle_sub;                        // sub-counter 0-2 per note
#define EXIT_JINGLE_LEN 15
static const uint16_t exit_jingle_div[5] = {3442, 2731, 2296, 1719, 1365};  // C5,E5,G5,C6,E6

void sound_ch0(uint16_t d) { VI53[0] = d; VI53[0] = d >> 8; }
void sound_ch1(uint16_t d) { VI53[1] = d; VI53[1] = d >> 8; }

void sound_event(unsigned char id)
{
    if (id >= ev_id) { ev_id = id; ev_t = ev_dur[id]; }  // higher priority wins
    if (id == SFX_FALL_DIAMOND) fall_dia_toggle = !fall_dia_toggle;  // alternate ding/don
}

void sound_move(void)
{
    // Short thump per step on empty space (~120 Hz, ~7 ms)
    VI53[1] = 15000 & 0xFF;
    VI53[1] = 15000 >> 8;
#asm
    lxi  b, 600
_walk_wait:
    dcx  b
    mov  a, b
    ora  c
    jnz  _walk_wait
#endasm
    VI54[0] = 0x66;
}

void sound_move_dirt(void)
{
    // Low thud for digging (~60 Hz, ~10 ms)
    VI53[1] = 30000 & 0xFF;
    VI53[1] = 30000 >> 8;
#asm
    lxi  b, 1000
_dirt_wait:
    dcx  b
    mov  a, b
    ora  c
    jnz  _dirt_wait
#endasm
    VI54[0] = 0x66;
}

void sound_tap(void)
{
    // Start ch1 tone directly (~180 Hz)
    VI53[1] = 10000 & 0xFF;
    VI53[1] = 10000 >> 8;
    // Brief delay (~2 ms) — let PIT output one edge of the square wave
#asm
    lxi  b, 600
_tap_wait:
    dcx  b
    mov  a, b
    ora  c
    jnz  _tap_wait
#endasm
    // Silence ch1
    VI54[0] = 0x66;
}

void sound_update(void)
{
    // --- Exit entrance jingle: 5 bright ascending notes, 3 ticks each ---
    if (exit_jingle_t) {
        exit_jingle_t--;
        sound_ch0(exit_jingle_div[exit_jingle_phase]);
        if (++exit_jingle_sub >= 3) { exit_jingle_sub = 0; exit_jingle_phase++; }
        if (exit_jingle_t == 0) { exit_jingle_phase = 0; exit_jingle_sub = 0; VI54[0] = 0x36; }
    }
    // --- Diamond-quota jingle: 4 bright ascending notes, 3 ticks each ---
    else if (quota_jingle_t) {
        quota_jingle_t--;
        sound_ch0(quota_jingle_div[quota_jingle_phase]);
        if (++quota_jingle_sub >= 3) { quota_jingle_sub = 0; quota_jingle_phase++; }
        if (quota_jingle_t == 0) { quota_jingle_phase = 0; quota_jingle_sub = 0; VI54[0] = 0x36; }
    }
    else if (ev_t) {
        ev_t--;
        if      (ev_id == SFX_DIAMOND)      sound_ch0(dia_div[ev_t]);
        else if (ev_id == SFX_FALL_DIAMOND) {
            if (fall_dia_toggle)
                sound_ch0(fall_dia2_div[ev_t]);  // "don"
            else
                sound_ch0(fall_dia_div[ev_t]);   // "ding"
        }
        else if (ev_id == SFX_BOULDER)      sound_ch0(boul_div[ev_t]);
        else                                sound_ch0(expl_div[ev_t]);
        if (ev_t == 0) { ev_id = 0; VI54[0] = 0x36; }
    }
    if (mv_t) {
        mv_t--;
        if (mv_k == 1)
            sound_ch1(move_dirt_div[mv_t]);
        else
            sound_ch1(move_div[mv_t]);
        if (mv_t == 0) VI54[0] = 0x66;
    }
}

// One blip of the end-of-cave time bonus.  The C64
// (ScoreTimeRemainingSound, $87c8) sweeps voice 3 downwards once per
// scored second; here the pitch walks down an eight-step scale and wraps,
// which gives the same insistent "brrrrp" as the clock runs out.
static const uint16_t score_tick_div[8] =
    {2600, 2300, 2050, 1820, 1620, 1450, 1290, 1150};

void sound_score_tick(unsigned char phase)
{
    sound_ch0(score_tick_div[phase & 7]);
}

void sound_game_init(void)
{
    sound_mute();
    ev_id = 0; ev_t = 0; mv_t = 0; mv_k = 0;
    quota_jingle_t = 0; quota_jingle_phase = 0; quota_jingle_sub = 0;
    exit_jingle_t = 0; exit_jingle_phase = 0; exit_jingle_sub = 0;
}



void show_big_dig(char x,char y,uint16_t val)
{
    uchar dig_buffer[6];
    char n=0;
    unsigned char c;
	

	if (val == 0)
        {
            put_sprite(x,y, Digits[0]);
            return;
        }
	
		
        while(val != 0)
	{
		c = val % 10;
                val = val / 10;
		dig_buffer[n++] = c;
	}
        while (n!=0)
        {
                n--;
                put_sprite(x,y, Digits[dig_buffer[n]]);
                x+=4;
        }
}
unsigned char *Letters[] =
{
 l_a,l_b,l_c,l_d,l_e,l_f,l_g,l_h,l_i,l_j,l_k,l_l,l_m,l_n,l_o,l_p,l_q,l_r,l_s,l_t,l_u,l_v,l_w,l_x,l_y,l_z,l_dd
};
void delay(int tick)
{
 while(tick>0)
    {
        tick--;
    }
}
void printf_letters(uchar x,uchar y, uchar* text)
{
uint8_t i = 0;  // ������ ��� ����������� �� ������

    // �������� �� ������� ������� � ������
    while (text[i] != '\0') {
        // �������� ASCII-��� �������� �������
        uint8_t ascii_code = (uint8_t)text[i];
         if (ascii_code==32) {put_sprite(x, y, space);x+=4;}
         if (ascii_code==':') {put_sprite(x, y, l_dd);x+=4;}
        if (ascii_code >= 'A' && ascii_code <= 'Z') {
            put_sprite(x, y, Letters[ascii_code - 'A']);
            x += 4;
        } else if (ascii_code >= 'a' && ascii_code <= 'z') {
            put_sprite(x, y, Letters[ascii_code - 'a']);
            x += 4;
        }
        
        // ��������� � ���������� �������
        i++;
    }
}
char symbol = 64;

// ============================================================
// Title background.
//
// The pattern behind (and inside) the big letters is characters 64..75 of
// the generator — twelve rotations of one diagonal weave — and every
// animated cell holds the *same* code at any instant; only which code
// changes.  window_fill() used to walk all 1541 cells of the window and
// rewrite every one of them each step: about 100000 tacts, five times a
// whole VG75 frame, so the beam always caught the fill half done and the
// new pattern visibly wiped down the screen.
//
// Instead the screen keeps code 64 everywhere and we rewrite the *glyph*
// of character 64 — twelve bytes, and the entire background turns over at
// once, between frames.  The generator RAM has to be mapped in over TM9
// while we do it; that costs two more writes and, measured on the
// emulator, disturbs nothing else on screen.
// ============================================================
#define BG_CHAR 64          // the code every animated cell holds
#define BG_PHASES 11        // scanlines the VG75 actually shows per character

// Characters 64..75 are twelve rotations of a twelve-line weave, but the cell
// on screen is only ELEVEN scanlines tall (measured: 23 rows over 253 pixels,
// and VG75 parameter byte 0x7a asks for 11 lines per character row).  So each
// of those rotations drops a different line of the pattern — and the pattern
// is banded, six lines of two lit pixels and six of six, so dropping a dark
// line or a bright one moves the brightness of the whole background by 6%.
// Cycling them therefore made the screen breathe once every twelve steps,
// which is the flicker left over once the redraw was gone.
//
// The rotations are built here over the eleven lines that are really shown,
// so every phase displays the same set of lines, merely shifted: the weave
// still scrolls a pixel a step, at constant brightness.
unsigned char bg_glyphs[BG_PHASES * 12];
unsigned char bg_phase;
unsigned char *bg_src;

static void title_bg_init(void)
{
    uchar k, i, j;

    for (k = 0; k < BG_PHASES; k++) {
        j = k;
        for (i = 0; i < BG_PHASES; i++) {
            bg_glyphs[k * 12 + i] = zg8x12[j];
            if (++j == BG_PHASES) j = 0;
        }
        bg_glyphs[k * 12 + 11] = zg8x12[11];   // line 12: stored, never shown
    }
    bg_phase = 0;
}

// Pick the next glyph.  Kept apart from the poke below so that none of this
// arithmetic lands inside the blanking gap.
static void title_bg_prepare(void)
{
    bg_src = bg_glyphs + bg_phase * 12;
    if (++bg_phase == BG_PHASES) bg_phase = 0;
}

// Map the generator in, drop twelve bytes into character BG_CHAR, map it out.
// Reading the generator while the CRT is fetching from it snows the picture,
// so this must run inside the blanking gap and must therefore be short: the
// unrolled form is about 300 tacts against roughly 2000 for the same thing
// written as a C loop, and a blanking gap is only one character row.
static void title_bg_poke(void)
{
#asm
        LHLD _bg_src
        XCHG                    ; DE = the twelve bytes to write
        LXI  H,0CE00h           ; TM9 config register (address as in main.c)
        MVI  M,80h              ; generator RAM mapped in
        LXI  H,0DC00h           ; RU10 + BG_CHAR*16 = 0D800h + 400h
        LDAX D
        MOV  M,A
        INX  D
        INX  H
        LDAX D
        MOV  M,A
        INX  D
        INX  H
        LDAX D
        MOV  M,A
        INX  D
        INX  H
        LDAX D
        MOV  M,A
        INX  D
        INX  H
        LDAX D
        MOV  M,A
        INX  D
        INX  H
        LDAX D
        MOV  M,A
        INX  D
        INX  H
        LDAX D
        MOV  M,A
        INX  D
        INX  H
        LDAX D
        MOV  M,A
        INX  D
        INX  H
        LDAX D
        MOV  M,A
        INX  D
        INX  H
        LDAX D
        MOV  M,A
        INX  D
        INX  H
        LDAX D
        MOV  M,A
        INX  D
        INX  H
        LDAX D
        MOV  M,A
        LXI  H,0CE00h
        MVI  M,0E0h             ; and back
#endasm
}

// ============================================================
// demo_mode_run: run a cave with C64 DemoMoveData input.
// Returns when demo data ends or any key is pressed.
// ============================================================
static unsigned char any_key_pressed(void) {
    unsigned char kb;
    kb = key_scan(0x7e);
    if (!(kb & 0x80)) return 1;  // space
    kb = key_scan(0xfd);
    if (!(kb & 0x04) || !(kb & 0x20) || !(kb & 0x80) ||
        !(kb & 0x10) || !(kb & 0x40)) return 1;  // enter/up/down/left/right
    return 0;
}

void demo_mode_run(void) {
    // C64 DemoMoveData is scripted for Cave A only (C64: STX Cave = 1)
    cave = 0;

    // Full game-screen init (same as main() before the game loop)
    clrscr();
    get_sprites_adresses_from_mass();
    map_x = 0; map_y = 0;

    // The demo plays a real cave, so it drives the same score and lives
    // globals the game does — start it clean, and leave it clean.
    score_reset();
    lives = 3;

    init_game_for_cave(cave);
    invalidate_window();
    calculateWindowCenter();
    sound_game_init();
    draw_hud();
    sprites_anim();

    is_demo_mode = 1;
    demo_repeat = 0;
    demo_move_idx = 0;
    demo_cur_dir = 0xFF;

    while (is_demo_mode) {
        // Any key pressed → exit demo
        if (any_key_pressed()) {
            is_demo_mode = 0;
            break;
        }

        tick_begin();            // same fixed rate as the real game loop
        game_tick_step();
        camera_follow_rockford();
        show_window();
        update_hud();
        sprites_anim();
        sound_update();
        tick_wait();

        // Handle cave exit (death, timeout, level complete)
        if (exit_cave_flag || game_over || level_complete) {
            break;
        }
    }

    is_demo_mode = 0;
    sound_mute();
    score_reset();
    lives = 3;
}

// ============================================================
// title_draw_full: redraw ALL title elements (BOULDER DASH, etc.)
// Called after demo returns — screen was overwritten by game.
// ============================================================
static void title_draw_full(void) {
    uchar t, x;
    clrscr();  // clear entire screen (demo graphics, HUD, etc.)
    symbol = BG_CHAR;   // the window is laid down in one code; the glyph animates
    // Redraw border (may be corrupted by demo game rendering).
    // Рамка сдвинута +4 вправо — иначе хвост ORIGINAL (x=64..66) лезет в бордюр.
    for (t = 4; t < 75; t++) {
        put_char(t, 1, 63);
        put_char(t, 2, 63);
        put_char(t, 26, 63);
        put_char(t, 27, 63);
    }
    for (t = 1; t < 27; t++) {
        put_char(4, t, 63);
        put_char(5, t + 1, 63);
        put_char(73, t, 63);
        put_char(74, t + 1, 63);
    }
    fill_bd_window();
    x = 8;
    put_sprite(x,4, B_let);
    put_sprite(x+=10,6, o_let);
    put_sprite(x+=8,6, u_let);
    put_sprite(x+=8,6, l_let);
    put_sprite(x+=8,6, d_let);
    put_sprite(x+=8,6, e_let);
    put_sprite(x+=8,6, r_let);
    x = 18;
    put_sprite(x,15, D1_let);
    put_sprite(x+=10,16, a_let);
    put_sprite(x+=8,16, s_let);
    put_sprite(x+=8,16, h_let);
    /* +4 от левого края рамки (ещё пол шага); сетка blank = 8,12,… */
    printf_letters(8,28,  brand_decode(brand_palmira_enc, 17, BRAND_KEY_PALMIRA));
    printf_letters(12,31, brand_decode(brand_software_enc, 9, BRAND_KEY_SOFTWARE));
    show_big_dig(48,31,2026);                 /* SOFTWARE + пробел + год */
    printf_letters(12,34, "LIEPA and GRAY");
    printf_letters(16,37, "PRESS SPACE");
}

// ============================================================
// The four text lines under the logo are shared by the title, the score
// screen and the cave menu. Wipe the full glyph span first.
// PALMIRA ORIGINAL ends at x=68 (последняя L) — blank обязан её покрыть.
// ============================================================
static void title_blank_text_lines(void) {
    /* 16*4 с x=8 → до x=68 (L от ORIGINAL); внутри рамки */
    printf_letters(8,28, "                ");
    printf_letters(8,31, "                ");
    printf_letters(8,34, "                ");
    printf_letters(8,37, "                ");
}

// Six score digits, leading zeros kept as on the C64 (.000000.high.000000.)
static void draw_score6(uchar x, uchar y, unsigned char *d) {
    uchar i;
    for (i = 0; i < 6; i++) {
        put_sprite(x, y, Digits[d[i]]);
        x += 4;
    }
}

// ============================================================
// title_draw_scores: the second music pass shows the session scores where
// the credits were.  The C64 does the same swap on its three upper text
// lines (SetupTitleScreenText, $8292) — two players there, one here.
// ============================================================
static void title_draw_scores(void) {
    title_blank_text_lines();
    printf_letters(18,28, "HIGH SCORE");
    draw_score6(26,31, high_score);
    printf_letters(18,34, "LAST SCORE");
    draw_score6(26,37, last_score);
}

// ============================================================
// title_draw_cave_select: overwrite bottom text lines for cave
// selection. Big BOULDER DASH letters stay from title_draw_full.
// ============================================================
static void title_draw_cave_select(void) {
    title_blank_text_lines();
    printf_letters(8,28,  " ARROWS SELECT  ");
    printf_letters(24,31, "CAVE:   ");
    printf_letters(10,37, "SPACE TO START  ");
}

// ============================================================
// title_music_loop: play 128-note music cycle.
// Returns 1 if SPACE pressed (→ cave select), 0 if music finished (→ demo).
// On the cave-select screen (phase=1), UP/DOWN change the cave letter.
// ============================================================
// One note used to last as long as window_fill took to grind through the
// window, about 200 ms.  With the fill gone the loop would come round in
// one frame and the whole tune would race by, so the note now holds itself
// for the same time explicitly — and SPACE is polled every frame of it
// instead of once per note, which also makes the key answer quicker.
// The "same time" claim above was a bad estimate: window_fill walked 67x23
// = 1541 bytes at roughly 55 T each, about 48 ms, plus delay(250) and the
// rounding up to a frame — some 4 frames, ~68 ms a note.  Tuned by ear
// since: 12 frames (203 ms) dragged, 6 (101 ms) ran away, so 9 it is.
// One note is one frame count here, so this is the only tempo knob —
// +-1 frame is about +-17 ms a note.  (The C64 itself is far slower:
// 8 music ticks at 25 Hz = 320 ms a note, 41 s for a loop.)
#define TITLE_NOTE_VSYNCS 9         // 9 frames at 59.19 Hz = 152 ms per note,
                                    // 19.5 s a loop, ~39 s before the demo
#define BG_STEP_VSYNCS    6         // pattern steps 1.5x per note = 9.9 steps/s

static unsigned char title_music_loop(unsigned char phase) {
    uint8_t s = 0;
    uchar v, bgw;

    bgw = 1;                        // step the pattern on the very first frame
    while (1) {
        play_note(bd_music_1ch[s], bd_music_2ch[s]);
        s++;
        if (s == 128) return 0;  // music cycle done → demo

        if (phase == 1) {
            // Cave selection: UP/DOWN — только A–P (бонусы Q–T не выбираются)
            if (!(key_scan(0xfd) & 0x20)) { if (cave < 15) cave++; }
            if (!(key_scan(0xfd) & 0x80)) { if (cave > 0)  cave--; }
            put_sprite(50, 31, Letters[cave]);
        }

        // Hold the note out, polling SPACE every frame, and step the pattern
        // on its own faster clock — it no longer costs a screen repaint, so
        // its rate has nothing to do with the tempo of the music any more.
        for (v = 0; v < TITLE_NOTE_VSYNCS; v++) {
            if (!(key_scan(0x7e) & 0x80)) {   // SPACE pressed
                sound_mute();
                while (!(key_scan(0x7e) & 0x80));  // wait release
                return 1;  // → cave select or start game
            }
            if (--bgw) {
                waitVSync();
            } else {
                // The generator write has to land in the blanking gap or the
                // picture snows: choose the glyph first, then let the frame
                // pulse be followed immediately by the stores.  Nothing may
                // come between these two calls.
                bgw = BG_STEP_VSYNCS;
                title_bg_prepare();
                waitVSync();
                title_bg_poke();
            }
        }
    }
}

// ============================================================
// Creator splash: the Claude Code logo fades up, holds, fades out.
//
// The screen is one bit per pixel, so "brightness" is the fraction of
// pixels lit: a 4x4 ordered (Bayer) dither switches them on a few at a
// time — exactly 3 of every 48 per step — which reads as a fade.
//
// A pseudographic byte is a 6-bit mask of lit pixels (bit0 = top left,
// bit1 = top right, ... bit5 = bottom right, see set_pseudograph in
// main.c), so a fade step is nothing but logo[cell] & mask: no
// per-pixel work at all.  Which mask a cell wants depends only on where
// it sits in the 4x4 dither grid — its pixel columns are 2*cx, 2*cx+1
// and its pixel rows 3*cy..3*cy+2 — so cx&1 and cy&3 select it, giving
// 8 masks per step.
//
// SPACE at any point during the fades or the hold aborts straight to
// the title screen; so does the end of the fade-out.
// ============================================================
#define LOGO_W      16   // cells across (32 px)
#define LOGO_H      7    // cells down   (21 px)
#define LOGO_X      28   // centred on the title-screen artwork (~col 36)
#define LOGO_Y      16   // rows 16..22 of the 0..38 the title screen uses
#define FADE_STEPS  16
#define FADE_FRAMES 4    // vsyncs per fade step: 16*4 = 64 frames = 1.08 s each way
#define HOLD_FRAMES 296  // vsyncs the finished logo stays up = 5.0 s at 59.19 Hz

// fade_mask[step*8 + (cy&3)*2 + (cx&1)] — step 0 blank, step 16 fully lit.
static const unsigned char fade_mask[17*8] = {
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,   // step  0
    0x01, 0x00, 0x04, 0x00, 0x10, 0x00, 0x00, 0x00,   // step  1
    0x01, 0x10, 0x04, 0x00, 0x10, 0x01, 0x00, 0x04,   // step  2
    0x01, 0x11, 0x04, 0x04, 0x10, 0x11, 0x00, 0x04,   // step  3
    0x11, 0x11, 0x04, 0x04, 0x11, 0x11, 0x04, 0x04,   // step  4
    0x19, 0x11, 0x24, 0x04, 0x11, 0x11, 0x06, 0x04,   // step  5
    0x19, 0x11, 0x24, 0x06, 0x11, 0x19, 0x06, 0x24,   // step  6
    0x19, 0x19, 0x24, 0x26, 0x11, 0x19, 0x06, 0x26,   // step  7
    0x19, 0x19, 0x26, 0x26, 0x19, 0x19, 0x26, 0x26,   // step  8
    0x1B, 0x19, 0x2E, 0x26, 0x39, 0x19, 0x26, 0x26,   // step  9
    0x1B, 0x39, 0x2E, 0x26, 0x39, 0x1B, 0x26, 0x2E,   // step 10
    0x1B, 0x3B, 0x2E, 0x2E, 0x39, 0x3B, 0x26, 0x2E,   // step 11
    0x3B, 0x3B, 0x2E, 0x2E, 0x3B, 0x3B, 0x2E, 0x2E,   // step 12
    0x3F, 0x3B, 0x3E, 0x2E, 0x3B, 0x3B, 0x2F, 0x2E,   // step 13
    0x3F, 0x3B, 0x3E, 0x2F, 0x3B, 0x3F, 0x2F, 0x3E,   // step 14
    0x3F, 0x3F, 0x3E, 0x3F, 0x3B, 0x3F, 0x2F, 0x3F,   // step 15
    0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F    // step 16
};

static void logo_draw(unsigned char step)
{
    uchar *msk, *row, *src, *dst;
    uchar cy, cx;

    msk = (uchar*)fade_mask + (step << 3);
    src = (uchar*)claudecode;
    for (cy = 0; cy < LOGO_H; cy++) {
        row = msk + ((cy & 3) << 1);
        dst = charAddr(LOGO_X, LOGO_Y + cy);
        for (cx = 0; cx < LOGO_W; cx++)
            *dst++ = *src++ & row[cx & 1];
    }
}

// Hold for n frames; returns 1 the moment SPACE goes down.
static unsigned char logo_wait(unsigned int n)
{
    while (n--) {
        waitVSync();
        if (!(key_scan(0x7e) & 0x80)) return 1;
    }
    return 0;
}

void show_claude_logo(void)
{
    unsigned char k, skip;

    sound_mute();     // PIT is in whatever state the monitor left it
    clrscr();
    skip = 0;

    for (k = 1; k <= FADE_STEPS && !skip; k++) {
        logo_draw(k);
        skip = logo_wait(FADE_FRAMES);
    }
    if (!skip) skip = logo_wait(HOLD_FRAMES);
    for (k = FADE_STEPS; k != 0 && !skip; k--) {
        logo_draw(k - 1);
        skip = logo_wait(FADE_FRAMES);
    }

    while (!(key_scan(0x7e) & 0x80));  // wait release, else the title sees it too
    clrscr();
}

// ============================================================
// PALMIRA intro: a steel wall scrolls, then lifts the credits out of
// itself one letter at a time, then slides up and leaves them behind.
//
// The wall is BetonAnim's tiles (tiles.c), which were sitting in the
// binary unused: six frames of the same brickwork moved up one pixel
// each, wrapping every 6 px.  BetonAnim itself doubles three of the
// frames, which makes the scroll limp — WallFrames below plays the six
// in order for an even 1 px per frame.
//
// A tile is 6x4 cells but the pattern inside it repeats every 3 cells
// across and every 2 down, so a band of any size is filled straight
// from the tile with row (y&3) and column (x-WALL_X)%6 — no tile seams
// to line up.
//
// Each letter rises inside a window exactly its own 3 cells tall, so
// the two text lines can never draw over each other: with `d` pixels
// still to travel, window pixel row p shows letter row p-d once p>=d
// and wall everywhere above that.  d counts 9 (wholly hidden) down to
// 0 (home), and a cell is 3 px, so the motion is per-pixel, not
// per-character-row.
// ============================================================
#define WALL_X      4    // band left edge, matches "PALMIRA ORIGINAL"
#define WALL_W      64   // 16 letters * 4 cells
#define WALL_TOP    15
#define WALL_BOT    24   // inclusive
#define L1_Y        17   // "PALMIRA ORIGINAL"
#define L2_X        20   // "SOFTWARE" is 8 letters, centred under line 1
#define L2_Y        20
#define LI_MAX      24   // letters in the two lines (spaces do not count)
#define RISE        9    // pixels a letter travels = its window height
#define WALL_HOLD   2    // vsyncs per scroll frame -> up to 30 px/s
#define WALL_INTRO  75   // scroll frames before the letters start.  Not a clean
                         // 75*16.9 ms: the band repaint overruns the frame, so
                         // this phase measures nearer 4.4 s than its 1.3 s floor
#define LAUNCH_GAP  3    // frames between two letters setting off
#define LEAVE_HOLD  3    // vsyncs per row while the wall slides away
#define READ_HOLD   59   // vsyncs the finished credits stay up = 1.0 s


// Six frames in scroll order (BetonAnim's own order stutters).
unsigned char *WallFrames[6] = { s_beton, beton1, beton2, beton3, beton4, beton5 };

static uchar li_x[LI_MAX];      // column of each letter
static uchar li_y[LI_MAX];      // top row of each letter
static uchar li_j[LI_MAX];      // its column phase in the 6-cell wall pattern
static uchar li_d[LI_MAX];      // pixels left to rise; 0 = home, 0xFF = waiting
static uchar li_ord[LI_MAX];    // the random order they set off in
static uchar *li_spr[LI_MAX];
static uchar li_n;

// letter pixel row -> cell row / shift within the cell, for rows 0..6
static const uchar k_row[7] = {0, 0, 0, 1, 1, 1, 2};
static const uchar k_sub[7] = {0, 1, 2, 0, 1, 2, 0};

// One line of the credits into the slot table; returns the next free slot.
static uchar li_line(uchar n, uchar x, uchar y, uchar *text)
{
    uchar i;
    for (i = 0; text[i]; i++) {
        if (text[i] != ' ') {
            li_x[n] = x;
            li_y[n] = y;
            li_j[n] = (x - WALL_X) % 6;
            li_spr[n] = Letters[text[i] - 'A'];
            li_d[n] = 0xFF;
            n++;
        }
        x += 4;
    }
    return n;
}

static void li_build(void)
{
    uchar i, k, t;

    li_n = li_line(0, WALL_X, L1_Y, brand_decode(brand_palmira_enc, 17, BRAND_KEY_PALMIRA));
    li_n = li_line(li_n, L2_X, L2_Y, brand_decode(brand_software_enc, 9, BRAND_KEY_SOFTWARE));

    for (i = 0; i < li_n; i++) li_ord[i] = i;
    for (i = li_n - 1; i != 0; i--) {          // Fisher-Yates
        k = random(0, i + 1);
        t = li_ord[i]; li_ord[i] = li_ord[k]; li_ord[k] = t;
    }
}

// ------------------------------------------------------------
// Band painting, in asm: the C version cost about 175 T per cell and
// 640 cells a frame is 63 ms, which capped the whole intro near 14 fps.
//
// The saving grace is that a band row only ever holds one of two
// patterns: in every one of the six frames tile row 0 equals row 2 and
// row 1 equals row 3, so (y & 1) picks the pattern, not (y & 3).  Each
// frame therefore expands its tile into two 64-byte rows once, and then
// every band row is a straight blit of one of them.
//
// The blit reads through SP (POP B / MOV M,C / MOV M,B moves two bytes
// in 34 T), the same trick put_bitmap already uses; it is unrolled four
// deep, so a 64-byte row costs about 1250 T against the 11 000 T the C
// loop needed.  Interrupts stay off here as everywhere else in the game.
// ------------------------------------------------------------
// A letter that has arrived must then be left alone: repainting the wall
// over it every frame and stamping it back was what made it blink.  Letters
// sit on a 4-cell grid from WALL_X, so "leave alone" is one flag per group
// of four cells, per text line, rebuilt once a frame from the settled set.
// All six frames are expanded once, at intro start, into ready-made 64-byte
// band rows: 6 frames x (even row, odd row).  Rebuilding them every frame
// cost about 5000 tacts, and on this machine a whole 50 Hz frame is only
// ~17000 tacts -- the DMA halts the CPU roughly half the time, measured at
// 0.86 MHz effective against a nominal 1.78.
unsigned char wf_rows[6 * 128];
unsigned char *wf_even, *wf_odd;   // the two rows of the current frame
unsigned char wf_row;
unsigned char wf_skip1[16], wf_skip2[16];   // per 4-cell group, 1 = do not paint
unsigned char wf_any1, wf_any2;             // is either line masked at all
unsigned char *wf_skipp;                    // mask the blit is to use
unsigned char wf_y0, wf_y1;                 // row range for the unmasked pass

// Expand every frame into its two band rows.  Called once per intro.
static void wall_rows_init(void)
{
    uchar f, i, j;
    uchar *tile, *dst;

    for (f = 0; f < 6; f++) {
        tile = WallFrames[f];
        dst  = wf_rows + f * 128;
        j = 0;
        for (i = 0; i < 64; i++) { dst[i]      = tile[j];     if (++j == 6) j = 0; }
        j = 0;
        for (i = 0; i < 64; i++) { dst[64 + i] = tile[6 + j]; if (++j == 6) j = 0; }
    }
}

// Blit the pattern for row wf_row into the band.
static void wall_blit_asm(void)
{
#asm
        EXTERN _radio86rkVideoMem       ; screen base, defined in main.c
        LXI  H,0
        DAD  SP
        SHLD wb_sp
        LDA  _wf_row
        ADD  A
        MOV  L,A
        MVI  H,0D0h             ; row-offset table built by create_table
        MOV  E,M
        INX  H
        MOV  D,M                ; DE = row * 78
        LHLD _radio86rkVideoMem
        DAD  D
        INX  H
        INX  H
        INX  H
        INX  H                  ; + WALL_X (4)
        SHLD wb_dst
        LDA  _wf_row
        ANI  1
        JZ   wb_even
        LHLD _wf_odd
        JMP  wb_go
wb_even:LHLD _wf_even
wb_go:  SPHL                    ; SP = source row
        LHLD wb_dst             ; HL = screen
        MVI  A,8                ; 8 passes of 8 bytes = 64
wb_lp:  POP  B
        MOV  M,C
        INX  H
        MOV  M,B
        INX  H
        POP  B
        MOV  M,C
        INX  H
        MOV  M,B
        INX  H
        POP  B
        MOV  M,C
        INX  H
        MOV  M,B
        INX  H
        POP  B
        MOV  M,C
        INX  H
        MOV  M,B
        INX  H
        DCR  A
        JNZ  wb_lp
        LHLD wb_sp
        SPHL
        RET
wb_sp:  defw 0
wb_dst: defw 0
#endasm
}

// Clear row wf_row of the band.  Fast path: does not preserve BC/DE/HL;
// call from C loops must use wall_blank_asm_safe() instead.
static void wall_blank_asm(void)
{
#asm
        LDA  _wf_row
        ADD  A
        MOV  L,A
        MVI  H,0D0h
        MOV  E,M
        INX  H
        MOV  D,M
        LHLD _radio86rkVideoMem
        DAD  D
        INX  H
        INX  H
        INX  H
        INX  H
        MVI  A,8
wk_lp:  MVI  M,0
        INX  H
        MVI  M,0
        INX  H
        MVI  M,0
        INX  H
        MVI  M,0
        INX  H
        MVI  M,0
        INX  H
        MVI  M,0
        INX  H
        MVI  M,0
        INX  H
        MVI  M,0
        INX  H
        DCR  A
        JNZ  wk_lp
#endasm
}

// Paint rows wf_y0..wf_y1 with nothing masked off, row loop and all.  This is
// the whole of phase 1 and the start of phase 2, and keeping the loop in C
// cost ten calls plus the mask test per frame, which on a 17000-tact frame is
// not small change.
static void wall_paint_plain_asm(void)
{
#asm
        LXI  H,0
        DAD  SP
        SHLD wp_sp
        LDA  _wf_y0
        STA  wp_row
wp_next:LDA  wp_row
        ADD  A
        MOV  L,A
        MVI  H,0D0h             ; row-offset table built by create_table
        MOV  E,M
        INX  H
        MOV  D,M
        LHLD _radio86rkVideoMem
        DAD  D
        INX  H
        INX  H
        INX  H
        INX  H                  ; + WALL_X (4)
        SHLD wp_dst
        LDA  wp_row
        ANI  1
        JZ   wp_even
        LHLD _wf_odd
        JMP  wp_go
wp_even:LHLD _wf_even
wp_go:  SPHL                    ; SP = source row
        LHLD wp_dst
        MVI  A,8                ; 8 passes of 8 bytes = 64
wp_lp:  POP  B
        MOV  M,C
        INX  H
        MOV  M,B
        INX  H
        POP  B
        MOV  M,C
        INX  H
        MOV  M,B
        INX  H
        POP  B
        MOV  M,C
        INX  H
        MOV  M,B
        INX  H
        POP  B
        MOV  M,C
        INX  H
        MOV  M,B
        INX  H
        DCR  A
        JNZ  wp_lp
        LHLD wp_sp              ; back on the C stack before anything else
        SPHL
        LDA  _wf_y1
        MOV  B,A
        LDA  wp_row
        CMP  B
        JZ   wp_done
        INR  A
        STA  wp_row
        JMP  wp_next
wp_done:
        RET
wp_sp:  defw 0
wp_dst: defw 0
wp_row: defb 0
#endasm
}

// Same as wall_blank_asm, but preserves BC/DE/HL for callers that
// sit inside a C for‑loop (wall_blank).
static void wall_blank_asm_safe(void)
{
#asm
        PUSH B
        PUSH D
        PUSH H
        LDA  _wf_row
        ADD  A
        MOV  L,A
        MVI  H,0D0h
        MOV  E,M
        INX  H
        MOV  D,M
        LHLD _radio86rkVideoMem
        DAD  D
        INX  H
        INX  H
        INX  H
        INX  H
        MVI  A,8
wks_lp: MVI  M,0
        INX  H
        MVI  M,0
        INX  H
        MVI  M,0
        INX  H
        MVI  M,0
        INX  H
        MVI  M,0
        INX  H
        MVI  M,0
        INX  H
        MVI  M,0
        INX  H
        MVI  M,0
        INX  H
        DCR  A
        JNZ  wks_lp
        POP  H
        POP  D
        POP  B
        RET
#endasm
}

// Same blit, but skipping the 4-cell groups a finished letter occupies.
static void wall_blit_mask_asm(void)
{
#asm
        LXI  H,0
        DAD  SP
        SHLD wm_sp
        LDA  _wf_row
        ADD  A
        MOV  L,A
        MVI  H,0D0h
        MOV  E,M
        INX  H
        MOV  D,M
        LHLD _radio86rkVideoMem
        DAD  D
        INX  H
        INX  H
        INX  H
        INX  H
        SHLD wm_dst
        LDA  _wf_row
        ANI  1
        JZ   wm_even
        LHLD _wf_odd
        JMP  wm_go
wm_even:LHLD _wf_even
wm_go:  SPHL                    ; SP = source row
        LHLD _wf_skipp
        XCHG                    ; DE = mask
        LHLD wm_dst             ; HL = screen
        MVI  A,16
        STA  wm_cnt
wm_grp: LDAX D
        INX  D
        ORA  A
        JNZ  wm_hole
        POP  B
        MOV  M,C
        INX  H
        MOV  M,B
        INX  H
        POP  B
        MOV  M,C
        INX  H
        MOV  M,B
        INX  H
        JMP  wm_next
wm_hole:POP  B                  ; a letter lives here: step over, keep SP in line
        POP  B
        INX  H
        INX  H
        INX  H
        INX  H
wm_next:LDA  wm_cnt
        DCR  A
        STA  wm_cnt
        JNZ  wm_grp
        LHLD wm_sp
        SPHL
        RET
wm_sp:  defw 0
wm_dst: defw 0
wm_cnt: defb 0
#endasm
}

// Which 4-cell groups are occupied by letters that have already arrived.
static void li_masks(void)
{
    uchar i;

    for (i = 0; i < 16; i++) { wf_skip1[i] = 0; wf_skip2[i] = 0; }
    wf_any1 = 0;
    wf_any2 = 0;
    for (i = 0; i < li_n; i++) {
        if (li_d[i]) continue;                       // 0xFF waiting, >0 still rising
        if (li_y[i] == L1_Y) { wf_skip1[(li_x[i] - WALL_X) >> 2] = 1; wf_any1 = 1; }
        else                 { wf_skip2[(li_x[i] - WALL_X) >> 2] = 1; wf_any2 = 1; }
    }
}

// Fill band rows y0..y1 (inclusive) with wall frame f (0..5).
static void wall_fill(uchar f, uchar y0, uchar y1)
{
    uchar y;

    li_masks();
    wf_even = wf_rows + f * 128;
    wf_odd  = wf_even + 64;
    if (!wf_any1 && !wf_any2) {          // no letter to protect yet: one asm pass
        wf_y0 = y0;
        wf_y1 = y1;
        wall_paint_plain_asm();
        return;
    }
    for (y = y0; y <= y1; y++) {
        wf_row = y;
        if (wf_any1 && y >= L1_Y && y <= L1_Y + 2) {
            wf_skipp = wf_skip1;
            wall_blit_mask_asm();
        } else if (wf_any2 && y >= L2_Y && y <= L2_Y + 2) {
            wf_skipp = wf_skip2;
            wall_blit_mask_asm();
        } else {
            wall_blit_asm();
        }
    }
}

// Restore the letters that live in row y (used as the wall uncovers a row).
static void li_redraw_row(uchar y)
{
    uchar i;

    for (i = 0; i < li_n; i++)
        if (li_y[i] <= y && y <= li_y[i] + 2)
            put_sprite(li_x[i], li_y[i], li_spr[i]);
}

static void wall_blank(uchar y0, uchar y1)
{
    uchar y;

    for (y = y0; y <= y1; y++) { wf_row = y; wall_blank_asm_safe(); }
}

// Draw slot `n` with li_d[n] pixels still to rise, wall showing above it.
//
// The three pixel rows of an output cell are three *consecutive* letter
// rows, so a whole cell row of the letter is either a straight copy (when
// the offset falls on a cell boundary) or a one- or two-pixel vertical
// shift of two stacked cells — a couple of operations per cell instead of
// three table lookups.  Only the single cell row straddling the wall edge
// needs the slow path; rows the letter has not reached are already wall,
// painted by wall_fill this frame, and are left alone.
static void letter_rise(uchar n)
{
    uchar *dat, *dst, *pat, *a;
    uchar r, c, s, d, k, top;

    d   = li_d[n];
    dat = li_spr[n] + 2;                    // skip the {rows,cols} header
    for (r = 0; r < 3; r++) {
        top = r * 3;                        // window pixel row this cell starts at
        if (top + 2 < d) continue;          // letter has not got here yet
        dst = charAddr(li_x[n], li_y[n] + r);
        if (top >= d) {
            k = top - d;                    // letter pixel row shown at the top
            a = dat + k_row[k] * 4;
            s = k_sub[k];
            if (s == 0)
                for (c = 0; c < 4; c++) dst[c] = a[c];
            else if (s == 1)
                for (c = 0; c < 4; c++) dst[c] = (a[c] >> 2) | ((a[c + 4] & 0x03) << 4);
            else
                for (c = 0; c < 4; c++) dst[c] = (a[c] >> 4) | ((a[c + 4] & 0x0F) << 2);
        } else {
            // Straddles the edge: wall at the top of the cell, the first one
            // or two pixel rows of the letter below it.  Same trick again, so
            // that every shift here is by a constant too.
            pat = ((li_y[n] + r) & 1) ? wf_odd : wf_even;
            pat += li_x[n] - WALL_X;
            if (d - top == 1)
                for (c = 0; c < 4; c++) dst[c] = (pat[c] & 0x03) | ((dat[c] & 0x0F) << 2);
            else
                for (c = 0; c < 4; c++) dst[c] = (pat[c] & 0x0F) | ((dat[c] & 0x03) << 4);
        }
    }
}

// Returns 1 if SPACE cut it short (caller then goes straight to the title).
unsigned char show_palmira_intro(void)
{
    uchar f, i, n, launch, started, moving, bot, skip;

    sound_mute();
    clrscr();
    brand_verify();     // verify brand sprite integrity
    li_build();
    wall_rows_init();

    f = 0;
    skip = 0;

    // ---- 1. bare wall, scrolling ----
    for (n = 0; n < WALL_INTRO && !skip; n++) {
        wall_fill(f, WALL_TOP, WALL_BOT);
        if (++f == 6) f = 0;
        skip = logo_wait(WALL_HOLD);
    }

    // ---- 2. letters rise out of it, in random order ----
    started = 0;
    launch  = 0;
    while (!skip) {
        wall_fill(f, WALL_TOP, WALL_BOT);
        moving = 0;
        for (i = 0; i < li_n; i++) {
            if (li_d[i] == 0xFF || li_d[i] == 0) continue;   // waiting, or home already
            letter_rise(i);
            li_d[i]--;
            if (li_d[i]) moving++;
            else put_sprite(li_x[i], li_y[i], li_spr[i]);    // arrived: stamped once,
        }                                                    // then the mask protects it
        if (started == li_n && !moving) break;
        if (launch) launch--;
        else if (started < li_n) {
            li_d[li_ord[started++]] = RISE;
            launch = LAUNCH_GAP;
        }
        if (++f == 6) f = 0;
        skip = logo_wait(WALL_HOLD);
    }

    // ---- 3. the wall slides up and off, credits stay ----
    // Rows the wall has already left keep what they hold, so nothing below
    // the edge is touched again — only the row just vacated is cleared, and
    // only the letters standing in it are stamped back.
    bot = WALL_BOT;
    while (!skip) {
        wall_fill(f, WALL_TOP, bot);
        if (++f == 6) f = 0;
        skip = logo_wait(LEAVE_HOLD);
        if (skip || bot == WALL_TOP) break;
        wf_row = bot;
        wall_blank_asm();
        li_redraw_row(bot);
        bot--;
    }
    if (!skip) {
        wall_blank(WALL_TOP, WALL_BOT);
        for (i = 0; i < li_n; i++) put_sprite(li_x[i], li_y[i], li_spr[i]);
        skip = logo_wait(READ_HOLD);
    }

    while (!(key_scan(0x7e) & 0x80));   // wait release
    clrscr();
    return skip;
}

void show_title(void)
{
    title_bg_init();

    // --- Outer loop: title → scores → demo → title → ... ---
    // The C64 starts the demo once the tune has looped twice
    // (MusicTickRoutine, $841e: CMP MusicLoopedCount, #$02).  Those two
    // loops are used here to show the title on the first and the session
    // scores on the second.  SPACE on either goes to cave selection.
    for (;;) {
        cave = 0;
        title_draw_full();
        if (!title_music_loop(0)) {          // 1st loop: title screen
            title_draw_scores();
            if (!title_music_loop(0)) {      // 2nd loop: high / last score
                sound_mute();
                demo_mode_run();
                continue;                    // demo over → full title redraw
            }
        }

        // ---- SPACE on either screen: cave selection, big letters stay ----
        title_draw_cave_select();
        if (title_music_loop(1)) {
            // SPACE pressed → start game with selected cave
            sound_mute();
            while (!(key_scan(0x7e) & 0x80));  // wait release
            return;  // → main() starts the game
        }
        // Music ran out on the menu → demo, then back to the full title
        sound_mute();
        demo_mode_run();
    }
}



void fill_bd_window(void)
{
#asm
        LXI H,0A78CH
        MVI A,67
        LXI D, 79
        CMA
        ADD E
        MOV E,A
        
        MVI A,23
        MOV C,A
        LDA _symbol
        ;����� ������ �� ������� x y ������ � HL
X_FILL1:MVI B,67
DRAW_X1:MOV M,A
        INX H
        DCR B
        JNZ DRAW_X1
        DCR C
        JZ EXIT_W_F1
        DAD D
        JMP X_FILL1
EXIT_W_F1:
#endasm
}