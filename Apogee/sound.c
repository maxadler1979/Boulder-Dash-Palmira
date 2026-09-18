#include "main.h"

/* Звук КР580ВИ53 — раскладка как на Пальмире (ch0 events, ch1 move),
 * база таймера Апогей EC00 (Пальмира CC00). */

uchar* VI53 = (uchar*)APOGEE_VI53;
uchar* VI54 = (uchar*)(APOGEE_VI53 + 3);

unsigned char ev_id;
unsigned char ev_t;
unsigned char mv_t;
unsigned char mv_k;
unsigned char fall_dia_toggle;
unsigned char quota_jingle_t;
unsigned char quota_jingle_phase;
unsigned char quota_jingle_sub;
unsigned char exit_jingle_t;
unsigned char exit_jingle_phase;
unsigned char exit_jingle_sub;

static const uint16_t dia_div[5]       = {6000, 7000, 8000, 7000, 6000};
static const uint16_t fall_dia_div[2]  = {1200, 2000};
static const uint16_t fall_dia2_div[2] = {2500, 4000};
static const uint16_t boul_div[2]      = {9000, 12000};
static const uint16_t expl_div[6]      = {4500, 6000, 8000, 12000, 18000, 24000};
static const unsigned char ev_dur[6]   = {0, 2, 2, 5, 6};

#define QUOTA_JINGLE_LEN 12
static const uint16_t quota_jingle_div[4] = {5169, 4319, 3440, 3056};
static const uint16_t exit_jingle_div[5]  = {3442, 2731, 2296, 1719, 1365};
static const uint16_t score_tick_div[8] =
    {2600, 2300, 2050, 1820, 1620, 1450, 1290, 1150};

void sound_ch0(uint16_t d) { VI53[0] = (uchar)d; VI53[0] = (uchar)(d >> 8); }
void sound_ch1(uint16_t d) { VI53[1] = (uchar)d; VI53[1] = (uchar)(d >> 8); }

void sound_mute(void)
{
#asm
    LXI  H, 0ec03h
    MVI  M, 36h
    MVI  M, 66h
    MVI  M, 0B6h
#endasm
    ev_id = 0;
    ev_t = 0;
    mv_t = 0;
}

void sound_event(unsigned char id)
{
    if (id >= ev_id) { ev_id = id; ev_t = ev_dur[id]; }
    if (id == SFX_FALL_DIAMOND) fall_dia_toggle = !fall_dia_toggle;
}

void sound_move(void)
{
    VI53[1] = (uchar)(15000 & 0xFF);
    VI53[1] = (uchar)(15000 >> 8);
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
    VI53[1] = (uchar)(30000 & 0xFF);
    VI53[1] = (uchar)(30000 >> 8);
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
    VI53[1] = (uchar)(10000 & 0xFF);
    VI53[1] = (uchar)(10000 >> 8);
#asm
    lxi  b, 600
_tap_wait:
    dcx  b
    mov  a, b
    ora  c
    jnz  _tap_wait
#endasm
    VI54[0] = 0x66;
}

void sound_update(void)
{
    if (exit_jingle_t) {
        exit_jingle_t--;
        sound_ch0(exit_jingle_div[exit_jingle_phase]);
        if (++exit_jingle_sub >= 3) { exit_jingle_sub = 0; exit_jingle_phase++; }
        if (exit_jingle_t == 0) { exit_jingle_phase = 0; exit_jingle_sub = 0; VI54[0] = 0x36; }
    }
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
                sound_ch0(fall_dia2_div[ev_t]);
            else
                sound_ch0(fall_dia_div[ev_t]);
        }
        else if (ev_id == SFX_BOULDER)      sound_ch0(boul_div[ev_t]);
        else                                sound_ch0(expl_div[ev_t]);
        if (ev_t == 0) { ev_id = 0; VI54[0] = 0x36; }
    }
    if (mv_t) {
        mv_t--;
        if (mv_t == 0) VI54[0] = 0x66;
    }
}

void sound_score_tick(unsigned char phase)
{
    sound_ch0(score_tick_div[phase & 7]);
}

/* Title: два канала ВИ53, как на Пальмире (title.c bd_music_* / play_note).
 * Цикл 128 нот × 2 круга; темп — TITLE_NOTE_VSYNCS @ VSYNC_HZ. */
static const uint16_t bd_music_1ch[128] = {
    10339,8155,6880,5169,9162,7738,6880,4581,6468,5768,5169,4319,5768,3056,5444,3440,
    10339,5169,13760,9162,11536,4581,9162,11536,10339,5169,13760,9162,6468,2584,5169,6468,
    11536,5768,15476,10339,7263,2884,5768,7263,13760,5444,12226,5169,7738,7738,3869,7738,
    5169,5169,5169,5169,5169,5169,5169,5169,5169,5169,5169,5169,5169,5169,5169,5169,
    5169,5169,5169,5169,5169,5169,5169,5169,5169,5169,5169,5169,5768,5768,5768,5768,
    5169,2584,5169,2884,5169,3056,5169,3440,5768,2884,5768,2884,5768,3869,5768,2884,
    5169,5169,5169,5169,5169,5169,5169,5169,5169,5169,5169,5169,5768,5768,5768,5768,
    4077,5169,6880,8155,4581,5768,7738,11536,4077,5169,6880,8155,4581,5768,7738,11536
};
static const uint16_t bd_music_2ch[128] = {
    20678,13760,10339,8639,23073,12226,11536,7738,25874,25874,12937,25874,11536,3869,10889,4319,
    20678,20678,20678,20678,23073,23073,23073,23073,20678,20678,20678,20678,12937,12937,12937,12937,
    23073,23073,23073,23073,14526,14526,14526,14526,27520,6880,27520,6880,30953,30953,20678,20678,
    20678,20678,20678,20678,10339,10339,20678,20678,23073,23073,23073,23073,11536,11536,23073,23073,
    20678,4077,20678,3869,10339,4077,20678,3869,23073,4077,23073,3869,11536,4581,23073,4319,
    20678,20678,20678,3440,10339,10339,20678,4319,23073,23073,23073,23073,11536,11536,23073,23073,
    20678,4077,20678,3869,10339,4077,20678,3869,23073,4077,23073,3869,11536,4581,23073,4319,
    5169,6880,8155,10339,5768,7738,9162,23073,3440,4077,5169,6880,7738,9162,11536,23073
};

static void play_note(uint16_t note_ch1, uint16_t note_ch2)
{
    VI53[0] = (uchar)note_ch1;
    VI53[0] = (uchar)(note_ch1 >> 8);
    VI53[1] = (uchar)note_ch2;
    VI53[1] = (uchar)(note_ch2 >> 8);
}

unsigned char play_bd_tune(void)
{
    unsigned char loop, i, v, k;
    sound_mute();
    for (loop = 0; loop < 2; loop++) {
        for (i = 0; i < 128; i++) {
            play_note(bd_music_1ch[i], bd_music_2ch[i]);
            for (v = 0; v < TITLE_NOTE_VSYNCS; v++) {
                waitVSync();
                if (!(key_scan(0x7e) & 0x80)) { sound_mute(); return 1; }
                k = key_scan(0xfd);
                if (!(k & 0x04)) { sound_mute(); return 1; }
                if (!(k & 0x20) || !(k & 0x40)) {
                    if (cave < MENU_CAVES - 1) {
                        cave++;
                        put_char(MENU_CAVE_X, MENU_CAVE_Y, (uchar)('A' + cave));
                    }
                    do {
                        waitVSync();
                        k = key_scan(0xfd);
                    } while ((k & 0x60) != 0x60);
                } else if (!(k & 0x80) || !(k & 0x10)) {
                    if (cave > 0) {
                        cave--;
                        put_char(MENU_CAVE_X, MENU_CAVE_Y, (uchar)('A' + cave));
                    }
                    do {
                        waitVSync();
                        k = key_scan(0xfd);
                    } while ((k & 0x90) != 0x90);
                }
            }
        }
    }
    sound_mute();
    return 0;
}

void sound_game_init(void)
{
    sound_mute();
    ev_id = 0;
    ev_t = 0;
    mv_t = 0;
    mv_k = 0;
    quota_jingle_t = 0;
    quota_jingle_phase = 0;
    quota_jingle_sub = 0;
    exit_jingle_t = 0;
    exit_jingle_phase = 0;
    exit_jingle_sub = 0;
}
