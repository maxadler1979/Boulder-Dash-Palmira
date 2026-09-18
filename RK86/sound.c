#include "main.h"

/* Пиу через EI/DI: C = полупериод (больше = ниже), A = число циклов.
 * BEEP_DECAY — тон падает; BEEP_RISE — тон растёт (взрыв). */

unsigned char ev_id;
unsigned char ev_t;
unsigned char fall_dia_toggle;
unsigned char beep_n;
unsigned char beep_d;
unsigned char quota_jingle_t;
unsigned char exit_jingle_t;
unsigned char exit_jingle_phase;
unsigned char exit_jingle_sub;

static void beep(unsigned char n, unsigned char d)
{
    beep_n = n;
    beep_d = d;
#asm
            LDA  _beep_n
            ORA  A
            JZ   bp_out
            MOV  B,A
            LDA  _beep_d
            MOV  C,A
            MOV  A,B
bp_loop:
            EI
            MOV  B,C
bp_h1:
            DCR  B
            JNZ  bp_h1
            DI
            MOV  B,C
bp_h2:
            DCR  B
            JNZ  bp_h2
            DCR  A
            JNZ  bp_loop
bp_out:
            DI
#endasm
}

static void beep_decay(unsigned char n, unsigned char d)
{
    beep_n = n;
    beep_d = d;
#asm
            LDA  _beep_n
            ORA  A
            JZ   bd_out
            LDA  _beep_d
            MOV  C,A
            LDA  _beep_n
bd_loop:
            EI
            MOV  B,C
bd_h1:
            DCR  B
            JNZ  bd_h1
            DI
            MOV  B,C
bd_h2:
            DCR  B
            JNZ  bd_h2
            INR  C
            INR  C
            INR  C
            INR  C
            DCR  A
            JNZ  bd_loop
bd_out:
            DI
#endasm
}

/* Нарастающий рёв: C уменьшается — тон поднимается. */
static void beep_rise(unsigned char n, unsigned char d)
{
    beep_n = n;
    beep_d = d;
#asm
            LDA  _beep_n
            ORA  A
            JZ   br_out
            LDA  _beep_d
            MOV  C,A
            LDA  _beep_n
br_loop:
            EI
            MOV  B,C
br_h1:
            DCR  B
            JNZ  br_h1
            DI
            MOV  B,C
br_h2:
            DCR  B
            JNZ  br_h2
            MOV  A,C
            CPI  8
            JC   br_nodcr
            DCR  C
            DCR  C
            DCR  C
            DCR  C
br_nodcr:
            LDA  _beep_n
            DCR  A
            STA  _beep_n
            JNZ  br_loop
br_out:
            DI
#endasm
}

void sound_mute(void)
{
    ev_id = 0;
    ev_t = 0;
}

void sound_event(unsigned char id)
{
    if (id == SFX_EXPLODE) {
        ev_id = id;
        ev_t = 6;   /* 6 тиков нарастания */
        return;
    }
    if (ev_id == SFX_EXPLODE && ev_t) return; /* взрыв не перебиваем */
    if (ev_t && id < ev_id) return;
    ev_id = id;
    ev_t = 1;
}

void sound_move(void)
{
    beep(6, 20);
}

void sound_move_dirt(void)
{
    beep(8, 28);
}

void sound_tap(void)
{
    beep(4, 24);
}

void sound_update(void)
{
    /* Взрыв: каждый тик выше и гуще — нарастающий шум. */
    if (ev_id == SFX_EXPLODE && ev_t) {
        unsigned char phase = (unsigned char)(6 - ev_t); /* 0..5 */
        beep_rise((unsigned char)(6 + phase * 3),
                  (unsigned char)(56 - phase * 8));
        ev_t--;
        if (ev_t == 0) ev_id = 0;
        return;
    }

    {
        unsigned char id = ev_id;
        ev_id = 0;
        ev_t = 0;
        if (id == SFX_DIAMOND) beep_decay(12, 8);
        else if (id == SFX_BOULDER) beep(8, 40);
        else if (id == SFX_FALL_DIAMOND) {
            if (fall_dia_toggle) beep_decay(5, 8);
            else beep_decay(5, 14);
        }
    }
}

void sound_score_tick(unsigned char phase)
{
    beep(3, (unsigned char)(12 + (phase & 7)));
}

/* Полный цикл title ch1 (128 нот), PIT/200 → EI/DI. */
static const unsigned char bd_tune[128] = {
    0x34, 0x29, 0x22, 0x1a, 0x2e, 0x27, 0x22, 0x17,
    0x20, 0x1d, 0x1a, 0x16, 0x1d, 0x0f, 0x1b, 0x11,
    0x34, 0x1a, 0x45, 0x2e, 0x3a, 0x17, 0x2e, 0x3a,
    0x34, 0x1a, 0x45, 0x2e, 0x20, 0x0d, 0x1a, 0x20,
    0x3a, 0x1d, 0x4d, 0x34, 0x24, 0x0e, 0x1d, 0x24,
    0x45, 0x1b, 0x3d, 0x1a, 0x27, 0x27, 0x13, 0x27,
    0x1a, 0x1a, 0x1a, 0x1a, 0x1a, 0x1a, 0x1a, 0x1a,
    0x1a, 0x1a, 0x1a, 0x1a, 0x1a, 0x1a, 0x1a, 0x1a,
    0x1a, 0x1a, 0x1a, 0x1a, 0x1a, 0x1a, 0x1a, 0x1a,
    0x1a, 0x1a, 0x1a, 0x1a, 0x1d, 0x1d, 0x1d, 0x1d,
    0x1a, 0x0d, 0x1a, 0x0e, 0x1a, 0x0f, 0x1a, 0x11,
    0x1d, 0x0e, 0x1d, 0x0e, 0x1d, 0x13, 0x1d, 0x0e,
    0x1a, 0x1a, 0x1a, 0x1a, 0x1a, 0x1a, 0x1a, 0x1a,
    0x1a, 0x1a, 0x1a, 0x1a, 0x1d, 0x1d, 0x1d, 0x1d,
    0x14, 0x1a, 0x22, 0x29, 0x17, 0x1d, 0x27, 0x3a,
    0x14, 0x1a, 0x22, 0x29, 0x17, 0x1d, 0x27, 0x3a
};

/* 2 круга title ch1.
 * 0 = доиграл → демо; 1 = SPACE/ВК → старт.
 * Стрелки меняют пещеру на лету (музыка не останавливается). */
unsigned char play_bd_tune(void)
{
    unsigned char loop, i, v, d, k;
    for (loop = 0; loop < 2; loop++) {
        for (i = 0; i < 128; i++) {
            d = bd_tune[i];
            beep(16, d);
            for (v = 0; v < TITLE_NOTE_VSYNCS; v++) {
                waitVSync();
                if (!(key_scan(0x7e) & 0x80)) return 1;
                k = key_scan(0xfd);
                if (!(k & 0x04)) return 1;
                if (!(k & 0x20) || !(k & 0x40)) {
                    if (cave < NUM_CAVES - 1) {
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
    return 0;
}

void sound_game_init(void)
{
    sound_mute();
    quota_jingle_t = 0;
    exit_jingle_t = 0;
    exit_jingle_phase = 0;
    exit_jingle_sub = 0;
}
