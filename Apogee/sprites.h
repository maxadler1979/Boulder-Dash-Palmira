#ifndef SPRITES_H
#define SPRITES_H

/*
 * Объявления спрайтов. Данные живут в tiles.c (тайлы) и rockford.c
 * (персонаж). Здесь только extern, чтобы не таскать десятки объявлений
 * по .c-файлам.
 *
 * Тайл — 24 байта, 6x4 знакоместа псевдографики 2x3 (см. шапку tiles.c).
 * Анимационные таблицы — массивы указателей на эти 24-байтные кадры;
 * sprites_anim() каждый тик копирует текущий кадр в MapObj[код].
 */

extern unsigned char *MapObj[];

extern const char empt[];
extern const char empt_inv[];
extern const char beton[];
extern const char brik[];
extern const char dirt[];
extern const char rock[];
extern const char s_beton[];
extern const char beton1[];
extern const char beton2[];
extern const char beton3[];
extern const char beton4[];
extern const char beton5[];
extern const char beton12x12[];
extern const char domik12x12[];
extern const char domik2_12x12[];
extern const char magic_wall_active1_12x12[];

extern const char d0[];
extern const char b1[];
extern const char m0[];
extern const char epl_1[];
extern const char epl_2[];
extern const char epl_3[];
extern const char am_1[];
extern const char muar1[];
extern const char muar2[];
extern const char muar3[];
extern const char muar4[];
extern const char stay[];
extern const unsigned char bd_logo[];
#define BD_LOGO_W 28
#define BD_LOGO_H 4

extern unsigned char *DimondAnim[];
extern unsigned char *ButterAnim[];
extern unsigned char *FireflyAnim[];
extern unsigned char *AmoebaAnim[];
extern unsigned char *BetonAnim[];
extern unsigned char *MagicWallAnim[];
extern unsigned char *Rockford_right[];
extern unsigned char *Rockford_left[];

extern unsigned char idle_tick;
extern unsigned char idle_blink_timer;
extern unsigned char idle_tap_timer;
extern unsigned char idle_tap_counter;
extern unsigned char idle_tap_phase;
extern unsigned char *idle_sprite_ptr;
void update_idle_sprite(void);

#endif
