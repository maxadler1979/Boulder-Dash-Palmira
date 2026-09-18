#ifndef __MAIN_H
#define __MAIN_H

/*
 * Общий заголовок порта Boulder Dash на Радио-86РК (КР580ВМ80А / 8080).
 *
 * Карта памяти (жёсткий лимит: бинарник НЕ должен заходить за 0xA5FF):
 *   0x0000..0xA5FF  код и данные игры
 *   0xA600..0xB5FF  видеопамять ВГ75 (78 байт/строка; игровое поле с 0xA69C)
 *   0xB600+         стек
 *   0xC000..0xC001  кадровый импульс ВГ75 (бит 0x20) — наш vsync
 *   0xC200          контроллер клавиатуры ВВ55
 *   0xCC00          PIT8253 (два канала звука)
 *   0xD000          таблица смещений строк sm_y[] (строит create_table)
 *   0xD800          знакогенератор RU10 (псевдографика 2x3)
 */

#include "objects.h"
#include "sprites.h"

#define pgm_read_byte(x) (*((uint8_t*)x))
#define pgm_read_word(x) (*((uint16_t*)x))
#define pgm_read_ptr(x) (*((unsigned char*)x))

#define VIDEO_BPL 78
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
#define SCREEN 0xA600+156

#define KEY_enter    251
#define KEY_space    127
#define KEY_left     239
#define KEY_right    191
#define KEY_up       223
#define KEY_down     127

#define start_up_dframe   0x01
#define end_up_dframe     0x02
#define h_dframe          0x05
#define v_dframe          0x06
#define start_down_dframe 0x04
#define end_down_dframe   0x03

#define start_up_frame   0x01
#define end_up_frame     0x02
#define h_frame          0x05
#define v_frame          0x06
#define start_down_frame 0x04
#define end_down_frame   0x03

#define FONT_WIDTH 4
#define FONT_HEIGHT 6

/* ============================================================
 * Фиксированный темп. Тик игры привязан к кадровому импульсу ВГ75,
 * поэтому одна и та же пещера идёт с одной скоростью независимо от
 * того, сколько клеток шевелится. TICKS_PER_SEC тиков = одна реальная
 * секунда (таймер пещеры, magic wall, амёба).
 *
 *   VSYNC_HZ      — кадровая частота. Измерена на эмуляторе: брейкпоинт
 *                   на рутине каждого 5-го кадра дал 30037 тактов/кадр
 *                   (разброс 0.017%); при 1777777 Гц это 16.896 мс =
 *                   59.19 Гц. Долго здесь стояло 50, и всё paced-время
 *                   (особенно таймер пещеры) бежало на 18.4% быстрее.
 *                   Если секунды на экране расходятся с секундомером —
 *                   крутить ТОЛЬКО это число.
 *   TICKS_PER_SEC — игровых тиков в реальной секунде.
 * 59/8 не целое, tick_begin() размазывает остаток: 7,7,7,8 vsync =
 * 59 на 8 тиков, то есть 8 тик/с с ошибкой ~0.3%.
 * ============================================================ */
#define VSYNC_HZ       59
#define TICKS_PER_SEC  8

#define NUM_CAVES   20   /* A–T; Q–T = bonus intermissions */
#define MENU_CAVES  16   /* в меню выбираются только A–P */

extern unsigned char vs_left;
extern unsigned char vs_prev;
void vsync_poll(void);
void tick_begin(void);
void tick_wait(void);
void waitVSync(void);

/* --- Видео / текст / спрайты --- */
extern uint8_t* radio86rkVideoMem;
extern unsigned char *spr_addr;
extern unsigned char *xy_addr;
extern int sm_y[];
extern unsigned char zg8x12[];
extern unsigned char *Digits[];

void clrscr(void);
void create_table(void);
void put_sprite(char x, char y, uint8_t* sprite);
void put_char(uchar x, uchar y, uchar s);
void put_text(uchar x, uchar y, uchar* text, uchar len);
void put_dec(uchar x, uchar y, uint16_t val);
uchar* charAddr(uchar x, uchar y);
void fill_bd_window(void);

/* --- Ввод / PRNG --- */
int random(int min, int max);
uint16_t GetRand(void);
uint8_t key_scan(uint8_t row);

/* --- Камера / пещера --- */
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

/* --- Рендер окна 12x10 --- */
void show_window(void);
void sprites_anim(void);
void invalidate_window(void);
void get_sprites_adresses_from_mass(void);
void init_empt_spark_anim(void);

/* --- Заставки --- */
void show_title(void);
void show_claude_logo(void);
unsigned char show_palmira_intro(void);

/* --- Игровой цикл --- */
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

/* --- Звук (КР580ВИ53 PIT, два канала) --- */
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
void sound_score_tick(unsigned char phase);

/* --- HUD --- */
extern unsigned char time_remaining;
extern unsigned char lives;
extern unsigned char diamonds_collected;
extern unsigned char diamonds_needed;
extern unsigned char hud_dirty;
#define HUD_DIRTY_TIME     0x01
#define HUD_DIRTY_DIAMONDS 0x02
#define HUD_DIRTY_LIVES    0x04
#define HUD_DIRTY_ALL      0xFF
void draw_hud(void);
void draw_pause_hud(void);
void update_hud(void);

/* --- Очки (C64: шесть десятичных цифр, ExtraLife каждые 500) --- */
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
#define SCORE_SHOW_TICKS    12
#define EXTRA_LIFE_FX_TICKS 20

extern unsigned char dia_quota_flash;
extern unsigned char quota_jingle_t;
extern unsigned char exit_jingle_t;
extern unsigned char exit_jingle_phase;
extern unsigned char exit_jingle_sub;
#define EXIT_JINGLE_LEN 15

#endif
