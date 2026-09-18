#include <string.h>
#include <stdint.h>
#include "main.h"

/* Инит экрана Апогей: ВГ75@EF00, ВТ57@F000, VIDEO @ D668 (ниже E100). */
uint8_t* VG75 = (uchar*)APOGEE_VG75;
uint8_t* VT57 = (uchar*)APOGEE_VT57;
volatile uint8_t* vv55 = (uint8_t*)APOGEE_KBD;

uint8_t* radio86rkVideoMem = (uchar*)(SCREEN);
uchar    radio86rkVideoBpl = VIDEO_BPL;
unsigned char kb;

uchar* fr_a;
uchar fr_w;
uchar fr_h;
uchar fr_c;

char cave;
char map_x, map_y;
unsigned char *spr_addr;
unsigned char *xy_addr;
unsigned char hud_dirty;

/* C64 LevelSequenceAndBonusLevelStatusArray → next cave (0=A … 19=T).
 * A–D → Q → E–H → R → I–L → S → M–P → T → A */
static const unsigned char cave_next[20] = {
    1, 2, 3, 16,    /* A B C D→Q */
    5, 6, 7, 17,    /* E F G H→R */
    9, 10, 11, 18,  /* I J K L→S */
    13, 14, 15, 19, /* M N O P→T */
    4, 8, 12, 0     /* Q→E R→I S→M T→A */
};

uint16_t GetRandFromSeed(uint16_t randVal)
{
    uint16_t lsb = randVal & 1;
    randVal >>= 1;
    if (lsb == 1) randVal ^= 0xA010u;
    return randVal;
}

uint16_t GetRand()
{
    static uint16_t randVal = 0xABC;
    randVal = GetRandFromSeed(randVal);
    return randVal;
}

int random(int min, int max)
{
    if (min >= max) return min;
    return min + GetRand() % (max - min);
}

void waitVSync() {
#asm
    lxi h,0ef01h
    mov a,m
waitHorzSync_1:
    mov a, m
    ani 20h
    jz waitHorzSync_1
#endasm
}

unsigned char vs_left;
unsigned char vs_prev;
unsigned char vs_acc;
unsigned char vs_dead;
unsigned char vs_fails;

void vsync_poll(void) {
#asm
            PUSH H
            LXI  H,0ef01h
            MOV  A,M
            ANI  20h
            LXI  H,_vs_prev
            CMP  M
            JZ   vp_done
            MOV  M,A
            ORA  A
            JZ   vp_done
            LXI  H,_vs_left
            MOV  A,M
            ORA  A
            JZ   vp_done
            DCR  M
vp_done:
            POP  H
#endasm
}

void tick_begin(void) {
    unsigned char n = 0;
    vs_acc += VSYNC_HZ;
    while (vs_acc >= TICKS_PER_SEC) {
        vs_acc -= TICKS_PER_SEC;
        n++;
    }
    vs_left = n;
}

void tick_wait(void) {
    unsigned int guard;
    if (vs_dead) return;
    guard = 4000;
    while (vs_left && --guard) vsync_poll();
    if (vs_left) {
        vs_fails++;
        if (vs_fails >= 3) vs_dead = 1;
    }
    else vs_fails = 0;
}

void screen_setup(uint16_t video_mem, uint16_t length)
{
  VG75[1] = 0; //
  VG75[0] = 0x4d; // chars/row - 1
  VG75[0] = (uchar)(VG75_TIMING_ROWS - 1); /* тайминг кадра, не размер ОЗУ */
  VG75[0] = 0x17; //7e
  VG75[0] = 0x53; //
  VG75[1] = 0x23; //
  waitVSync();
  VT57[8] = 0x80; //
  VT57[4] = (uchar)(video_mem); //
  VT57[4] = (uchar)((video_mem)>>8); //
  VT57[5] = (uchar)((length)-1); //
  VT57[5] = 0x40 | (uchar)(((length)-1)>>8); //
  VT57[8] = 0xA4; //
  /* Курсор ВГ75 за экран: Load Cursor → (7Fh, 7Fh). */
  VG75[1] = 0x80;
  VG75[0] = 0x7f;
  VG75[0] = 0x7f;
}

uint8_t key_scan(uint8_t row)
{
    vv55[0] = row;
    return vv55[1];
}

/* HUD по ширине поля (кол. 6..71). TIME с 7; остальные блоки равномерно до 71:
 *   TIME 150    DIAMONDS 012/075    SCORE 000000    LIVES 3    CAVE A
 */
#define HUD_X_TIME_L  7
#define HUD_X_TIME    12
#define HUD_X_DIA_L   19
#define HUD_X_DC      28
#define HUD_X_DN      32
#define HUD_X_SC_L    39
#define HUD_X_SC      45
#define HUD_X_LV_L    55
#define HUD_X_LV      61
#define HUD_X_CAVE_L  66
#define HUD_X_CAVE    71

static void hud_num3(unsigned char x, unsigned char y, unsigned char val)
{
    put_char(x,     y, '0' + (val / 100));
    put_char(x + 1, y, '0' + ((val / 10) % 10));
    put_char(x + 2, y, '0' + (val % 10));
}

static void hud_score6(unsigned char x, unsigned char y, unsigned char *d)
{
    unsigned char i;
    for (i = 0; i < 6; i++)
        put_char((uchar)(x + i), y, (uchar)('0' + d[i]));
}

static void hud_diamonds(void)
{
    hud_num3(HUD_X_DC, HUD_Y, diamonds_collected);
    put_char((uchar)(HUD_X_DC + 3), HUD_Y, '/');
    hud_num3(HUD_X_DN, HUD_Y, diamonds_needed);
}

void draw_hud(void)
{
    unsigned char i;
    for (i = 0; i < 78; i++) put_char(i, HUD_Y, 0x20);
    printf_letters(HUD_X_TIME_L, HUD_Y, "TIME");
    hud_num3(HUD_X_TIME, HUD_Y, time_remaining);
    printf_letters(HUD_X_DIA_L, HUD_Y, "DIAMONDS");
    hud_diamonds();
    printf_letters(HUD_X_SC_L, HUD_Y, "SCORE");
    hud_score6(HUD_X_SC, HUD_Y, score_digits);
    printf_letters(HUD_X_LV_L, HUD_Y, "LIVES");
    put_char(HUD_X_LV, HUD_Y, (uchar)('0' + lives));
    printf_letters(HUD_X_CAVE_L, HUD_Y, "CAVE");
    put_char(HUD_X_CAVE, HUD_Y, (uchar)('A' + cave));
    hud_dirty = 0;
}

/* Оверлей паузы на строке HUD. */
void draw_pause_hud(void)
{
    unsigned char i;
    for (i = 0; i < 78; i++) put_char(i, HUD_Y, 0x20);
    printf_letters((uchar)((78 - 14) / 2), HUD_Y, "PAUSE - PRESS P");
}

void update_hud(void)
{
    if (!hud_dirty) return;
    if (hud_dirty & HUD_DIRTY_TIME)
        hud_num3(HUD_X_TIME, HUD_Y, time_remaining);
    if (hud_dirty & HUD_DIRTY_DIAMONDS)
        hud_diamonds();
    if (hud_dirty & HUD_DIRTY_SCORE)
        hud_score6(HUD_X_SC, HUD_Y, score_digits);
    if (hud_dirty & HUD_DIRTY_LIVES)
        put_char(HUD_X_LV, HUD_Y, (uchar)('0' + lives));
    hud_dirty = 0;
}

static void score_time_bonus(void)
{
    unsigned char phase = 0;
    while (time_remaining > 0) {
        waitVSync();
        time_remaining--;
        score_add(1);
        hud_dirty |= HUD_DIRTY_TIME;
        update_hud();
        sound_score_tick(phase++);
    }
    sound_mute();
}

/* Меню: по центру 78 колонок, как второй экран Пальмиры — HIGH/LAST. */
#define MENU_CX(len) ((unsigned char)((78 - (len)) / 2))

static unsigned char demo_key_hit(void)
{
    unsigned char k;
    k = key_scan(0x7e);
    if (!(k & 0x80)) return 1;  /* space */
    k = key_scan(0xfd);
    if (!(k & 0x04) || !(k & 0x20) || !(k & 0x80) ||
        !(k & 0x10) || !(k & 0x40)) return 1;  /* enter/arrows */
    return 0;
}

static void wait_key_up(void)
{
    while (demo_key_hit())
        ;
}

/* C64 DemoMoveData на пещере A; любая клавиша / конец скрипта → выход. */
static void demo_mode_run(void)
{
    char saved_cave = cave;
    cave = 0;
    clrscr();
    score_reset();
    lives = 3;
    map_x = 0;
    map_y = 0;
    init_game_for_cave(cave);
    invalidate_window();
    calculateWindowCenter();
    sound_game_init();
    vs_dead = 0;
    vs_fails = 0;
    vs_acc = 0;
    draw_hud();
    sprites_anim();

    is_demo_mode = 1;
    demo_repeat = 0;
    demo_move_idx = 0;
    demo_cur_dir = 0xFF;

    while (is_demo_mode) {
        if (demo_key_hit()) {
            is_demo_mode = 0;
            break;
        }
        tick_begin();
        game_tick_step();
        camera_follow_rockford();
        show_window();
        update_hud();
        sprites_anim();
        sound_update();
        tick_wait();
        if (exit_cave_flag || game_over || level_complete)
            break;
    }

    is_demo_mode = 0;
    sound_mute();
    score_reset();
    lives = 3;
    cave = saved_cave;
    exit_cave_flag = 0;
    game_over = 0;
    level_complete = 0;
    gameover_flag = 0;
    wait_key_up();
}

static void draw_bd_logo(void)
{
    uchar x0 = (uchar)((78 - BD_LOGO_W) / 2);  /* центр: 25 */
    uchar y0 = 4;                               /* сверху, чуть ниже края */
    uchar r, c;
    const unsigned char *p = bd_logo;
    for (r = 0; r < BD_LOGO_H; r++)
        for (c = 0; c < BD_LOGO_W; c++)
            put_char((uchar)(x0 + c), (uchar)(y0 + r), *p++);
}

/* 1 = SPACE/ВК → игра; 0 = музыка кончилась → demo снаружи меню. */
static unsigned char show_menu(void)
{
    uchar sx, hx;
    if ((unsigned char)cave >= MENU_CAVES) cave = 0;
    clrscr();
    draw_bd_logo();
    printf_letters(MENU_CX(14), 8, "APOGEE VERSION");
    /* счёт */
    printf_letters(MENU_CX(5), 10, "SCORE");
    sx = MENU_CX(24);
    printf_letters(sx, 12, "HIGH ");
    hud_score6((uchar)(sx + 5), 12, high_score);
    printf_letters((uchar)(sx + 12), 12, "LAST ");
    hud_score6((uchar)(sx + 17), 12, last_score);
    /* управление — один левый край по самой длинной строке */
    hx = MENU_CX(20);
    printf_letters(hx, 16, "ARROWS CAVE A");
    put_char(MENU_CAVE_X, MENU_CAVE_Y, (uchar)('A' + cave));
    printf_letters(hx, 18, "SPACE FIRE");
    printf_letters(hx, 20, "AP2 SUICIDE  P PAUSE");
    /* копирайт */
    printf_letters(MENU_CX(13), 31, "GREETINGS PYK");
    printf_letters(MENU_CX(35), 33, "(C) 1984 PETER LIEPA & CHRIS GRAY");
    printf_letters(MENU_CX(30), 35, "PALMIRA ORIGINAL SOFTWARE 2026");
    if (!play_bd_tune())
        return 0;
    wait_key_up();
    clrscr();
    return 1;
}

void main()
{
#asm
    DI
    LXI SP,0D620h
#endasm
    create_table();
    clrscr();
    screen_setup(SCREEN, VIDEO_LEN);
    lives = 3;
    score_reset();
    get_sprites_adresses_from_mass();
    init_empt_spark_anim();
    for (;;) {
        if (!show_menu()) {
            demo_mode_run();
            continue;
        }
        break;
    }
    map_x = 0;
    map_y = 0;

    while (1) {
        init_game_for_cave(cave);
        invalidate_window();
        calculateWindowCenter();
        sound_game_init();
        draw_hud();
        sprites_anim();

        while (1) {
            tick_begin();
            game_tick_step();
            camera_follow_rockford();
            show_window();
            update_hud();
            sprites_anim();
            sound_update();
            tick_wait();
            if (level_complete) break;
            if (exit_cave_flag) break;
        }

        sound_mute();

#define do_curtain() {                                                  \
	int step, row, col, i;                                               \
	map_x = 0; map_y = 0;                                                \
	invalidate_window();                                                 \
	for (step = 0; step < 11; step++) {                                  \
		for (col = step; col < 40 - step; col++) {                       \
			work_cave[step * 40 + col] = 0x01;                           \
			work_cave[(21 - step) * 40 + col] = 0x01;                    \
		}                                                                \
		for (row = step + 1; row < 21 - step; row++) {                   \
			work_cave[row * 40 + step] = 0x01;                           \
			work_cave[row * 40 + (39 - step)] = 0x01;                    \
		}                                                                \
		show_window();                                                   \
		update_hud();                                                    \
		sprites_anim();                                                  \
		{ int d; for (d = 0; d < 250; d++) { int x = d; (void)x; } }     \
	}                                                                    \
	{ int d; for (d = 0; d < 800; d++) { int x = d; (void)x; } }         \
	for (i = 0; i < 880; i++) work_cave[i] = 0x00;                      \
	invalidate_window();                                                 \
	show_window();                                                       \
	update_hud();                                                        \
	{ int d; for (d = 0; d < 600; d++) { int x = d; (void)x; } }         \
 }

        if (level_complete) {
            score_time_bonus();
            do_curtain();
            /* C64 NextCave: A-D → Q → E-H → R → I-L → S → M-P → T → A */
            cave = (char)cave_next[(unsigned char)cave];
            continue;
        }

        if (exit_cave_flag) {
            /* C64 PerformCaveExitAction: бонус Q–T — NextCave, жизнь не снимается */
            if ((unsigned char)cave >= 16) {
                do_curtain();
                cave = (char)cave_next[(unsigned char)cave];
                continue;
            }
            lose_life();
            do_curtain();
            if (gameover_flag) {
                { int d; for (d = 0; d < 1200; d++) { int x = d; (void)x; } }
                score_end_game();
                for (;;) {
                    if (!show_menu()) {
                        demo_mode_run();
                        continue;
                    }
                    break;
                }
                get_sprites_adresses_from_mass();
                init_empt_spark_anim();
                map_x = 0;
                map_y = 0;
                lives = 3;
                gameover_flag = 0;
                score_reset();
                continue;
            }
            continue;
        }
    }
}
