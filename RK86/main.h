#ifndef __MAIN_H
#define __MAIN_H

/*
 * Boulder Dash, стандартный Радио-86РК (32 КБ).
 *
 * ЖЁСТКИЙ ВЕРХНИЙ ПРЕДЕЛ ИГРЫ: 0x75FF.
 * Выше — ячейки монитора 0x7600–0x76CF (не трогать).
 *
 * Видео: ВГ75 считает VG75_TIMING_ROWS строк (полный кадр/vsync).
 * В ОЗУ только VIDEO_ROWS × 78; последний байт EOS (F3h) — стоп ПДП,
 * хвост кадра ВГ75 fill'ит без ПДП (частота не прыгает).
 *
 *   0000 – …      код / данные / BSS (не заходить за SM_Y)
 *   стек          с SM_Y вниз
 *   SM_Y          таблица смещений VIDEO_ROWS слов
 *   SCREEN..75FF  видеобуфер VIDEO_LEN байт
 */

#include "objects.h"
#include "sprites.h"

#define pgm_read_byte(x) (*((uint8_t*)x))
#define pgm_read_word(x) (*((uint16_t*)x))
#define pgm_read_ptr(x) (*((unsigned char*)x))

#define VIDEO_BPL 78
/* Логические строки y=0..35 (HUD@3, тайлы FIELD_Y..FIELD_Y+31). */
#define VIDEO_ROWS 36
#define VIDEO_LEN  (VIDEO_ROWS * VIDEO_BPL)
/* Тайминг ВГ75: строк в кадре (не размер ОЗУ!). 38 → 0x25. */
#define VG75_TIMING_ROWS 38
/* Спецкоды ВГ75: EOR=F1h (конец строки), EOS=F3h (конец экрана). */
#define VG75_EOR  0xF1
#define VG75_EOS  0xF3
#define mark_dma_stop() (*(uchar *)(SCREEN + VIDEO_LEN - 1) = VG75_EOS)

#define bool char
#define true 1
#define false 0
#define uint8_t  unsigned char
#define uint16_t unsigned int
#define int32_t  long
#define nullptr  0
#define int8_t   char
#define int16_t  int
#define uchar  unsigned char

/* SCREEN = 0x7600 - VIDEO_LEN; SM_Y = SCREEN - VIDEO_ROWS*2 */
#define SCREEN    0x6b08
#define SM_Y_ADDR 0x6ac0
#define HUD_Y     3
#define FIELD_Y   4

/* Окно камеры: 11x8 тайлов (11*6=66 → lab_x=6). */
#define WIN_W     11
#define WIN_H     8
#define WIN_CELLS (WIN_W * WIN_H)   /* 88 */
#define WIN_LAB_X 6                 /* (78 - 66) / 2 */
#define MAP_X_MAX (40 - WIN_W)      /* 29 */
#define MAP_Y_MAX (22 - WIN_H)      /* 14 */

/* Матрица (РК86_7.md §8): AP2=PA0/PB2 → scan 0xFE bit2; P=PA6/PB0 → scan 0xBF bit0 */

#define FONT_WIDTH 4
#define FONT_HEIGHT 6

#define VSYNC_HZ       50   /* штатный РК86: 50 Гц (Пальмира ~59–60) */
#define TICKS_PER_SEC  8

/* Темп заставки: на Пальмире 9 кадров @60 Гц ≈150 мс/ноту → @50 Гц = 8 */
#define TITLE_NOTE_VSYNCS  8

#define NUM_CAVES 16
#define MENU_CAVE_X  41   /* "ARROWS CAVE A" с x=29 */
#define MENU_CAVE_Y  16


extern unsigned char vs_left;
extern unsigned char vs_prev;
void vsync_poll(void);
void tick_begin(void);
void tick_wait(void);
void waitVSync(void);

extern uint8_t* radio86rkVideoMem;
extern unsigned char *spr_addr;
extern unsigned char *xy_addr;
extern unsigned char kb;

void clrscr(void);
void create_table(void);
void fillRect(void);
void put_sprite(char x, char y, uint8_t* sprite);
void put_char(uchar x, uchar y, uchar s);
void put_text(uchar x, uchar y, uchar* text, uchar len);
void printf_letters(uchar x, uchar y, char* text);
uchar* charAddr(uchar x, uchar y);

int random(int min, int max);
uint16_t GetRand(void);
uint8_t key_scan(uint8_t row);

extern unsigned char work_cave[];
extern char map_x, map_y;
extern unsigned char sdvig;
extern unsigned int elementNumber;
extern unsigned char *CaveZxObj[];
void move_camera_right(void);
void move_camera_left(void);
void move_camera_up(void);
void move_camera_down(void);
void calculateWindowCenter(void);
int  start_cave(char cav);
void cave_unpack(unsigned char *src, unsigned char *dst);

void show_window(void);
void sprites_anim(void);
void invalidate_window(void);
void get_sprites_adresses_from_mass(void);
void init_empt_spark_anim(void);

extern char cave;
extern char rockford_anim;
extern char rockford_dir;
extern char exit_open;
extern unsigned char game_tick;
extern unsigned char game_over;
extern unsigned char level_complete;
extern unsigned char exit_enter_timer;
extern unsigned char rockford_dead_ticks;
extern unsigned char gameover_flag;
extern unsigned char exit_cave_flag;
extern unsigned char magic_wall_active;
extern unsigned char is_demo_mode;
extern unsigned char demo_repeat;
extern unsigned char demo_move_idx;
extern unsigned char demo_cur_dir;
void init_game_for_cave(char cav);
void game_tick_step(void);
void camera_follow_rockford(void);
void lose_life(void);

#define SFX_FALL_DIAMOND 1
#define SFX_MOVE     1
#define SFX_BOULDER  2
#define SFX_DIAMOND  3
#define SFX_EXPLODE  4
extern unsigned char ev_id;
extern unsigned char ev_t;
extern unsigned char fall_dia_toggle;
void sound_event(unsigned char id);
void sound_move(void);
void sound_move_dirt(void);
void sound_tap(void);
void sound_update(void);
void sound_game_init(void);
void sound_mute(void);
unsigned char play_bd_tune(void);
void sound_score_tick(unsigned char phase);

extern unsigned char time_remaining;
extern unsigned char lives;
extern unsigned char diamonds_collected;
extern unsigned char diamonds_needed;
extern unsigned char hud_dirty;
#define HUD_DIRTY_TIME     0x01
#define HUD_DIRTY_DIAMONDS 0x02
#define HUD_DIRTY_LIVES    0x04
#define HUD_DIRTY_SCORE    0x08
#define HUD_DIRTY_ALL      0xFF
void draw_hud(void);
void draw_pause_hud(void);
void update_hud(void);

extern unsigned char score_digits[];
extern unsigned char last_score[];
extern unsigned char high_score[];
extern unsigned char score_flash;
extern unsigned char extra_life_fx;
extern unsigned char diamond_value;
extern unsigned char diamond_extra;
void score_add(unsigned char v);
void score_reset(void);
void score_end_game(void);
#define EXTRA_LIFE_FX_TICKS 20

extern unsigned char dia_quota_flash;
extern unsigned char quota_jingle_t;
extern unsigned char exit_jingle_t;
extern unsigned char exit_jingle_phase;
extern unsigned char exit_jingle_sub;
#define EXIT_JINGLE_LEN 15

extern uchar* fr_a;
extern uchar fr_w;
extern uchar fr_h;
extern uchar fr_c;
extern uchar radio86rkVideoBpl;

#endif
