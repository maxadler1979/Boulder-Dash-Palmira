/*
 * game_logic.c — вся физика C64 (ProcessCave $7dd9) на 8080.
 *
 * Карта work_cave[880] сканируется каждый тик слева направо, сверху вниз.
 * Коды объектов — objects.h. Горячий путь (800 клеток) — чистый asm:
 * process_physics() сам разгребает инертное, а phys_handle()/do_amoeba/
 * falling_tick вызываются только для живых клеток.
 *
 * Два представления одной логики: PHYS_ASM=1 (то, что в релизе) и
 * портативный C-фоллбек. Алгоритм один, чтобы можно было свериться.
 */
#include "main.h"

char rockford_x, rockford_y;
int  rockford_i;
char rockford_dir;
char rockford_anim;
char fire_pressed;
// Unsigned, and it matters: cave I has 178 diamonds on the map, so a
// signed char would go negative past 127.  main.h always declared these
// unsigned - the definitions here did not match until now.
unsigned char diamonds_collected;
unsigned char diamonds_needed;
char exit_open;
unsigned char game_tick;
unsigned char game_over;          // 1 = Rockford is dead (C64: implicit - no Rockford on map)
unsigned char level_complete;
unsigned char exit_enter_timer;    // countdown when Rockford walks into open exit (20->0)
unsigned char rockford_dead_ticks; // C64 RockfordDeadTicks ($96): frames since Rockford died
unsigned char gameover_flag;       // 1 = true game over - lives exhausted (C64 GameOverFlag $a0)
unsigned char exit_cave_flag;      // 1 = exit current cave (death+fire, or timeout)
unsigned char magic_wall_active;  // 0=inactive (normal wall), 1=active (animated + milling)
unsigned char dia_quota_flash;    // diamond-quota-reached empty-inversion flash timer
unsigned char magic_wall_timer;   // frame counter 0-59 (C64: MagicWallActiveFrameCounter)
unsigned char magic_wall_seconds; // seconds the wall has been active
unsigned char magic_wall_milling_time; // max seconds from cave header (C64: MagicWallMillingTime)
unsigned char time_remaining;     // countdown timer (C64: TimeLeft, in game-seconds)
unsigned char lives = 3;          // player lives remaining
unsigned char time_subcounter;    // frame accumulator for second countdown

// --- Demo mode (C64: DemoMoveData + DemoModeRunCave) ---
unsigned char is_demo_mode;       // 1 = running automated demo
unsigned char demo_repeat;        // frames remaining for current direction
unsigned char demo_move_idx;      // index into DemoMoveData[]
unsigned char demo_cur_dir;       // current direction (0xFF = idle)

static const unsigned char DemoMoveData[64] = {
    0xFF, 0xFF, 0x1E, 0x77, 0x2D, 0x97, 0x4F, 0x2D,
    0x47, 0x3E, 0x1B, 0x4F, 0x1E, 0xB7, 0x1D, 0x27,
    0x4F, 0x6D, 0x17, 0x4D, 0x3B, 0x4F, 0x1D, 0x1B,
    0x47, 0x3B, 0x4F, 0x4E, 0x5B, 0x3E, 0x5B, 0x4D,
    0x3B, 0x5F, 0x3E, 0xAB, 0x1E, 0x3B, 0x1D, 0x6B,
    0x4D, 0x17, 0x4F, 0x3D, 0x47, 0x4D, 0x4B, 0x2E,
    0x27, 0x3E, 0xA7, 0xA7, 0x1D, 0x47, 0x1D, 0x47,
    0x2D, 0x5F, 0x57, 0x4E, 0x57, 0x6F, 0x1D, 0x00
};

// --- Amoeba physics state (C64: ProcessAmoeba) ---
unsigned char amoeba_count_this_tick;   // cells counted this scan
unsigned char amoeba_count_prev_tick;   // cells from previous scan
unsigned char amoeba_could_grow_this;   // at least one direction free this tick
unsigned char amoeba_could_grow_last;   // at least one direction free last tick
unsigned char amoeba_growth_mask;        // 0x7F slow (3.1%), switches to 0x0F fast (25%) after milling_time
unsigned char amoeba_milling_time;       // seconds until mask switches 0x7F->0x0F (C64: from header $01)

// --- Per-cave parameters (C64 BufferedLevel header, 32 bytes each) ---
// Extracted: amoeba mask ($01), diamond values ($02/$03),
//            diamonds needed ($09), time limit ($0e)
typedef struct {
    unsigned char amoeba_mask;   // $01 MagicWallMillingTime / Amoeba3PercentMax
    unsigned char diamonds;      // $09 DiamondsNeeded sublevel 1
    unsigned char time_limit;    // $0e CaveTime sublevel 1
    unsigned char dia_value;     // $02 InitialDiamondValue - points per diamond
    unsigned char dia_extra;     // $03 ExtraDiamondValue   - points once quota is met
} cave_params_t;

// amoeba_mask column = C64 header $01 doubled (milling time pre-scaled ~2x
// for 8080 speed), M clamped at 255.  Every other column is byte-for-byte
// the C64 header.
//
// Some quotas look impossible next to the map: D, M, N, O, P, Q and T have
// no diamonds drawn at all, and G/H/K have far fewer than they ask for.
// That is correct - those caves make their diamonds out of exploding
// butterflies, dying amoeba and magic-wall boulders.  I is the other
// extreme: 178 diamonds on the map for a quota of 75 ("Greed").
//
// Several caves really do score 0 for diamonds above the quota (C, K, L,
// Q-T) - also not a typo.
static const cave_params_t cave_params[16] = {
    //  mask  dia  time  val extra
    {0x28, 12, 150, 10, 15},   // A
    {0x28, 10, 150, 20, 50},   // B
    {0x00, 24, 150, 15,  0},   // C
    {0x28, 36, 120,  5, 20},   // D
    {0x28,  4, 150, 50, 90},   // E
    {0x28,  4, 150, 40, 60},   // F
    {0x96, 15, 120, 10, 20},   // G
    {0x28, 10, 120, 10, 20},   // H
    {0x28, 75, 150,  5, 10},   // I
    {0x28, 12, 150, 25, 60},   // J
    {0x28,  6, 120, 50,  0},   // K
    {0x28, 19, 180, 20,  0},   // L
    {0xFF, 50, 160,  5,  8},   // M
    {0x28, 30, 150, 10, 20},   // N
    {0x10, 15, 120, 10, 20},   // O
    {0x28, 12, 150, 10, 20}    // P
};

// ============================================================
// Score (C64: ScoreDigits $5f-$64, IncrementScore $705d)
//
// Kept as six decimal digits rather than a number, exactly as the C64
// does: addition is a digit-at-a-time carry loop (no 32-bit maths on an
// 8080), the HUD gets its digits for free, and "did the 1000s digit
// change" - which is how the extra life is detected - is one compare.
// digit[0] = hundred-thousands ... digit[5] = units.
// ============================================================
unsigned char score_digits[6];
unsigned char last_score[6];      // score of the last finished game
unsigned char high_score[6];      // best of this session (C64: HighScoreChars)
unsigned char score_flash;        /* legacy; score always on HUD now */
unsigned char extra_life_fx;      // >0 = empty tile sparkles (C64 ExtraLifeFXCounter)
unsigned char diamond_value;      // points the next diamond is worth
unsigned char diamond_extra;      // what it becomes once the quota is met

// C64 ExtraLife ($7039): capped at 9 lives, and no effect at all once
// there - the FX counter is only armed when a life was actually given.
static void extra_life(void)
{
    if (lives >= 9) return;
    lives++;
    hud_dirty |= HUD_DIRTY_LIVES;
    extra_life_fx = EXTRA_LIFE_FX_TICKS;
}

// Добавить v (0-255) к счёту. Шесть десятичных цифр, [0] = сотни тысяч.
// На 8080 нет 32-бит, поэтому сложение поразрядно с переносом, как на 6502
// (IncrementScore $705d). Extra life каждые 500 очков: сменилась цифра
// тысяч, либо цифра сотен ушла с 4 (C64 ProcessExtraLife $7046).
void score_add(unsigned char v)
{
    unsigned char inc[6];
    unsigned char old_th, old_hu, carry, s;
    int k;                              // int, not char: the loop runs to -1

    old_th = score_digits[2];
    old_hu = score_digits[3];

    inc[0] = 0; inc[1] = 0; inc[2] = 0;
    inc[3] = v / 100;  v = v - inc[3] * 100;
    inc[4] = v / 10;
    inc[5] = v - inc[4] * 10;

    carry = 0;
    for (k = 5; k >= 0; k--) {
        s = score_digits[k] + inc[k] + carry;
        if (s >= 10) { s -= 10; carry = 1; } else carry = 0;
        score_digits[k] = s;
    }

    if (old_th != score_digits[2]) extra_life();
    if (old_hu == 4 && score_digits[3] != 4) extra_life();

    hud_dirty |= HUD_DIRTY_SCORE;
}

void score_reset(void)
{
    unsigned char k;
    for (k = 0; k < 6; k++) score_digits[k] = 0;
    score_flash = 0;
    extra_life_fx = 0;
}

// End of a game: remember it as the last score and, if it beats it, as the
// session high score (C64 UpdateHighScoreIfNeeded $87fa + StashScores).
void score_end_game(void)
{
    unsigned char k, beats;

    for (k = 0; k < 6; k++) last_score[k] = score_digits[k];

    // Most significant differing digit decides (C64 UpdateHighScoreIfNeeded).
    beats = 0;
    for (k = 0; k < 6; k++) {
        if (score_digits[k] != high_score[k]) {
            beats = (score_digits[k] > high_score[k]);
            break;
        }
    }
    if (beats)
        for (k = 0; k < 6; k++) high_score[k] = score_digits[k];
}

// ------------------------------------------------------------
// Интерфейс скана: asm-цикл <-> обработчик клетки.
// 800 клеток обходит process_physics на 8080. Для живой клетки он
// кладёт phys_i / phys_col / phys_obj / phys_ptr и делает CALL
// phys_handle() без аргументов на стеке — sccz80 calling convention
// сюда не лезет.
// ------------------------------------------------------------
#define PHYS_ASM 1          // 1 = asm scan loop, 0 = portable C loop

int  phys_i;                // current cell index (40..839)
char phys_col;              // current column (0..39)
char phys_obj;              // current object code
char *phys_ptr;            // scratch: &work_cave[phys_i]

void phys_handle(void);     // dispatch for one active cell (C)

// ============================================================
void init_cave_objects(char cav)
{
    unsigned int i;
    const cave_params_t *cp = &cave_params[(unsigned char)cav];
    game_over = 0; level_complete = 0; exit_open = 0;
    rockford_dead_ticks = 0; exit_cave_flag = 0;
    exit_enter_timer = 0;
    MapObj[8] = (unsigned char*)beton12x12;  // force exit sprite to brick (not domik from prev level)


    gameover_flag = 0;  // reset on every cave init (C64: InitPlayers clears GameOverFlag)
    magic_wall_active = 0; magic_wall_timer = 0; magic_wall_seconds = 0;
    magic_wall_milling_time = cp->amoeba_mask;   // same C64 header field ($01)
    amoeba_milling_time    = cp->amoeba_mask;     // seconds until mask 0x7F->0x0F (pre-scaled for 8080)
    amoeba_growth_mask     = 0x7F;                // C64: slow initial growth (3.1%)
    time_remaining = cp->time_limit;             // C64: CaveTime
    time_subcounter = 0;
    hud_dirty = HUD_DIRTY_ALL;                   // force full HUD redraw
    score_flash = 0;                             // HUD starts on the diamond count
    diamonds_collected = 0;
    diamonds_needed = cp->diamonds;
    diamond_value = cp->dia_value;               // C64: BufferedLevel $02
    diamond_extra = cp->dia_extra;               //      BufferedLevel $03
    game_tick = 0; fire_pressed = 0; rockford_anim = 0;
    idle_tick = 0; idle_blink_timer = 0; idle_tap_timer = 0;
    idle_tap_counter = 0; idle_tap_phase = 0;
    update_idle_sprite();  // init idle_sprite_ptr -> stay
    amoeba_count_this_tick = 0; amoeba_count_prev_tick = 0;
    amoeba_could_grow_this = 1; amoeba_could_grow_last = 1;

    for (i = 0; i < 880; i++) {
        char obj = work_cave[i];
        if (obj == O_INBOX) {
            rockford_x = i % 40;
            rockford_y = i / 40;
            rockford_i = i;
            rockford_dir = 2;
            work_cave[i] = O_ROCKFORD;
        }
        else if (obj == O_FIREFLY)   work_cave[i] = O_FF_UP;
        else if (obj == O_BUTTERFLY) work_cave[i] = O_BF_UP;
        else if (obj == O_AMOEBA)    work_cave[i] = O_AMOEBA_A;
    }
}

// ============================================================
char get_rockford_input(void)
{
    char dir = 0xFF;
    fire_pressed = 0;                       // default: not pressed

    if (is_demo_mode) {
        // --- C64 DemoModeRunCave: feed joystick from DemoMoveData ---
        if (demo_repeat == 0) {
            unsigned char byte = DemoMoveData[demo_move_idx];
            unsigned char js = byte & 0x0F;
            demo_repeat = byte >> 4;
            demo_move_idx++;
            if (js == 0x00) {
                is_demo_mode = 0;           // exit demo (C64: STA ExitDemoModeFlag)
                return 0xFF;
            }
            // Map C64 joystick (active-low) to RK86 direction:
            //   $0D=down, $0E=up, <8=right, 8..$0B=left, $0F=idle
            if (js == 0x0D)      demo_cur_dir = 2;     // down
            else if (js == 0x0E) demo_cur_dir = 0;     // up
            else if (js < 8)     demo_cur_dir = 1;     // right (incl. UR/DR diags)
            else if (js < 0x0C)  demo_cur_dir = 3;     // left (incl. UL/DL diags)
            else                 demo_cur_dir = 0xFF;  // idle ($0F or other)
        }
        if (demo_repeat > 0) demo_repeat--;
        return demo_cur_dir;
    }

    kb = key_scan(0xfd);                  /* PA1: стрелки и ВК */
    if      (!(kb & 0x20)) dir = 0;       /* вверх  PB5 */
    else if (!(kb & 0x80)) dir = 2;       /* вниз   PB7 */
    else if (!(kb & 0x10)) dir = 3;       /* влево  PB4 */
    else if (!(kb & 0x40)) dir = 1;       /* вправо PB6 */
    if (!(kb & 0x04)) fire_pressed = 1;   /* ВК     PB2 */
    kb = key_scan(0x7f);                  /* PA7: пробел PB7 */
    if (!(kb & 0x80)) fire_pressed = 1;
    kb = key_scan(0x7e);
    if (!(kb & 0x80)) fire_pressed = 1;
    return dir;
}

// ============================================================
void process_rockford(void)
{
    char input, obj;
    int ni, ti;

    if (rockford_anim) {
        rockford_anim++;
        if (rockford_anim > 4) rockford_anim = 0;
    }

    // If Rockford is dead (cell destroyed by explosion), just return.
    // fire_pressed is already set by get_rockford_input() - used by
    // game_tick_step for the C64 DeathClick (fire after 16 dead ticks).
    input = get_rockford_input();
    if (work_cave[rockford_i] != O_ROCKFORD) {
        return;
    }

    // Rockford is alive - reset death tracking (C64: ProcessRockford STA RockfordDeadTicks)
    rockford_dead_ticks = 0;
    game_over = 0;

    if (input == 0xFF) { rockford_anim = 0; fire_pressed = 0; return; }

    if      (input == 0) ni = rockford_i - 40;
    else if (input == 1) ni = rockford_i + 1;
    else if (input == 2) ni = rockford_i + 40;
    else                 ni = rockford_i - 1;

    {
        char nx = rockford_x, ny = rockford_y;
        if      (input == 0) ny--;
        else if (input == 1) nx++;
        else if (input == 2) ny++;
        else                 nx--;
        if (nx < 0 || nx >= 40 || ny <= 0 || ny >= 21) {
            fire_pressed = 0; return;
        }
    }

    // Only update facing on left/right; up/down keep the previous direction
    if (input == 1 || input == 3) rockford_dir = input;
    obj = work_cave[ni];

    // --- Fire + direction: grab/push from adjacent cell, Rockford stays ---
    if (fire_pressed) {
        if (obj == O_DIRT) {
            work_cave[ni] = O_EMPTY;               // dig dirt
            sound_move_dirt();
        }
        else if (obj == O_DIAMOND || obj == O_DIAMOND_S) {
            // C64 RockfordMovingToDiamond: score, then count, then quota check -
            // so the diamond that completes the quota still scores the base value.
            score_add(diamond_value);
            diamonds_collected++;                    // grab diamond
            hud_dirty |= HUD_DIRTY_DIAMONDS;
            work_cave[ni] = O_EMPTY;
            sound_event(SFX_DIAMOND);
            if (diamonds_collected >= diamonds_needed && !exit_open) {
                exit_open = 1; dia_quota_flash = 12; quota_jingle_t = 12;
                diamond_value = diamond_extra;       // C64 CheckIfGotDiamondQuota
            }
        }
        else if (obj == O_BOULDER) {
            ti = ni + (input == 1 ? 1 : -1);        // push boulder left/right
            if (work_cave[ti] == O_EMPTY) {
                work_cave[ti] = O_BOULDER;
                work_cave[ni] = O_EMPTY;
                sound_event(SFX_BOULDER);
            }
        }
        else if (obj == O_EXIT && exit_open) {
            // Rockford walks into the exit - hide him, brief countdown
            work_cave[rockford_i] = O_EMPTY;
            rockford_i = -1;                   // detach from map so critters don't explode here
            exit_enter_timer = 20;
            exit_jingle_t = EXIT_JINGLE_LEN;  // cheerful upward arpeggio!
        }
        fire_pressed = 0;
        return;
    }

    // --- Normal movement: Rockford moves into target cell ---
    if (obj == O_EMPTY || obj == O_DIRT) {
        work_cave[rockford_i] = O_EMPTY;
        work_cave[ni] = O_ROCKFORD;
        rockford_i = ni;
        if      (input == 0) { rockford_y--; if (!rockford_anim) rockford_anim = 1; }
        else if (input == 1) { rockford_x++; if (!rockford_anim) rockford_anim = 1; }
        else if (input == 2) { rockford_y++; if (!rockford_anim) rockford_anim = 1; }
        else                 { rockford_x--; if (!rockford_anim) rockford_anim = 1; }
        if (obj == O_DIRT)
            sound_move_dirt();   // digging rumble
        else
            sound_move();        // walking click
    }
    else if (obj == O_DIAMOND || obj == O_DIAMOND_S) {
        score_add(diamond_value);                    // C64 RockfordMovingToDiamond
        diamonds_collected++;
        hud_dirty |= HUD_DIRTY_DIAMONDS;
        sound_event(SFX_DIAMOND);
        work_cave[rockford_i] = O_EMPTY;
        work_cave[ni] = O_ROCKFORD;
        rockford_i = ni;
        if      (input == 0) { rockford_y--; if (!rockford_anim) rockford_anim = 1; }
        else if (input == 1) { rockford_x++; if (!rockford_anim) rockford_anim = 1; }
        else if (input == 2) { rockford_y++; if (!rockford_anim) rockford_anim = 1; }
        else                 { rockford_x--; if (!rockford_anim) rockford_anim = 1; }
        if (diamonds_collected >= diamonds_needed && !exit_open) {
            exit_open = 1; dia_quota_flash = 12; quota_jingle_t = 12;
            diamond_value = diamond_extra;           // C64 CheckIfGotDiamondQuota
        }
    }
    else if (obj == O_EXIT && exit_open) {
        // Rockford walks into the exit - hide him, brief countdown
        work_cave[rockford_i] = O_EMPTY;
        rockford_i = -1;                   // detach from map so critters don't explode here
        exit_enter_timer = 20;
        exit_jingle_t = EXIT_JINGLE_LEN;  // cheerful upward arpeggio!
    }
    else if (obj == O_BOULDER && (input == 1 || input == 3)) {
        if (random(0, 100) < 25) {
            ti = ni + (input == 1 ? 1 : -1);
            if (work_cave[ti] == O_EMPTY) {
                work_cave[ti] = O_BOULDER;
                work_cave[rockford_i] = O_EMPTY;
                work_cave[ni] = O_ROCKFORD;
                rockford_i = ni;
                if (input == 1) { rockford_x++; if (!rockford_anim) rockford_anim = 1; }
                else { rockford_x--; if (!rockford_anim) rockford_anim = 1; }
                sound_event(SFX_BOULDER);
            }
        }
    }

    fire_pressed = 0;
}

// ============================================================
char is_round(char obj)
{
    return (obj == O_BOULDER || obj == O_BOULDER_S || obj == O_BOULDER_F ||
            obj == O_DIAMOND || obj == O_DIAMOND_S || obj == O_DIAMOND_F ||
            obj == O_BRICK);
}

void explode_3x3(int center, char expl_code);

// ============================================================
// Butterfly try-move (right-turn = clockwise)
// ============================================================
char bf_code(char rd) {
    return (rd==0)?O_BF_DOWN:(rd==1)?O_BF_LEFT:(rd==2)?O_BF_UP:O_BF_RIGHT;
}
char bf_try(int i, char col, char cur_dir, char turn_offset, char do_move)
{
    char rd = (cur_dir + turn_offset) & 3;
    int ti = i;
    char ok = 1;
    if      (rd == 0) { ti += 40; if (ti >= 840) ok = 0; }
    else if (rd == 1) { if (col <= 0) ok=0; else ti--; }
    else if (rd == 2) { ti -= 40; if (ti < 40) ok = 0; }
    else              { if (col >= 39) ok=0; else ti++; }
    if (!ok) return 0;
    if (!do_move) { work_cave[i] = bf_code(rd); return 1; }
    if (work_cave[ti] != O_EMPTY) {
        // Collision with falling object -> explode to diamonds
        if (work_cave[ti] == O_BOULDER_F || work_cave[ti] == O_BOULDER_S ||
            work_cave[ti] == O_DIAMOND_F || work_cave[ti] == O_DIAMOND_S) {
            explode_3x3(i, O_EXPL_D1);
            sound_event(SFX_EXPLODE);
            return 1;
        }
        return 0;
    }
    work_cave[i] = O_EMPTY;
    work_cave[ti] = (rd==0)?O_BF_DOWN_S:(rd==1)?O_BF_LEFT_S:(rd==2)?O_BF_UP_S:O_BF_RIGHT_S;
    return 1;
}

// ============================================================
// Firefly try-move (left-turn = counter-clockwise)
// ============================================================
char ff_code(char rd) {
    return (rd==0)?O_FF_DOWN:(rd==1)?O_FF_LEFT:(rd==2)?O_FF_UP:O_FF_RIGHT;
}
char ff_try(int i, char col, char cur_dir, char turn_offset, char do_move)
{
    char rd = (cur_dir + turn_offset) & 3;
    int ti = i;
    char ok = 1;
    if      (rd == 0) { ti += 40; if (ti >= 840) ok = 0; }
    else if (rd == 1) { if (col <= 0) ok=0; else ti--; }
    else if (rd == 2) { ti -= 40; if (ti < 40) ok = 0; }
    else              { if (col >= 39) ok=0; else ti++; }
    if (!ok) return 0;
    if (!do_move) { work_cave[i] = ff_code(rd); return 1; }
    if (work_cave[ti] != O_EMPTY) {
        // Collision with falling object -> explode to space
        if (work_cave[ti] == O_BOULDER_F || work_cave[ti] == O_BOULDER_S ||
            work_cave[ti] == O_DIAMOND_F || work_cave[ti] == O_DIAMOND_S) {
            explode_3x3(i, O_EXPL_S1);
            sound_event(SFX_EXPLODE);
            return 1;
        }
        return 0;
    }
    work_cave[i] = O_EMPTY;
    work_cave[ti] = (rd==0)?O_FF_DOWN_S:(rd==1)?O_FF_LEFT_S:(rd==2)?O_FF_UP_S:O_FF_RIGHT_S;
    return 1;
}

// ============================================================
// Boulder/diamond physics (C64: ProcessFallingBoulder / Diamond)
// ============================================================
// ============================================================
// 3x3 explosion (C64 Explode3x3Cells). Fills the 3x3 around
// 'center' with expl_code, preserving steel walls. expl_code is
// the first stage: O_EXPL_S1 (decays to empty) or O_EXPL_D1
// (decays to a diamond). Critters live within rows 1..20 and
// cols 1..38, so all nine indices stay inside work_cave[0..879].
// ============================================================
// Inlined: nine cells written directly (no per-cell CALL). Steel survives.
void explode_3x3(int center, char expl_code)
{
    // C64: if Rockford is inside the 3x3 blast zone, he dies
    if (work_cave[center-41] == O_ROCKFORD ||
        work_cave[center-40] == O_ROCKFORD ||
        work_cave[center-39] == O_ROCKFORD ||
        work_cave[center-1]  == O_ROCKFORD ||
        work_cave[center]    == O_ROCKFORD ||
        work_cave[center+1]  == O_ROCKFORD ||
        work_cave[center+39] == O_ROCKFORD ||
        work_cave[center+40] == O_ROCKFORD ||
        work_cave[center+41] == O_ROCKFORD) {
        game_over = 1;  // Rockford is dead -> triggers dead_ticks counting in game_tick_step
    }

    if (work_cave[center-41] != O_STEEL) work_cave[center-41] = expl_code;
    if (work_cave[center-40] != O_STEEL) work_cave[center-40] = expl_code;
    if (work_cave[center-39] != O_STEEL) work_cave[center-39] = expl_code;
    if (work_cave[center-1]  != O_STEEL) work_cave[center-1]  = expl_code;
    if (work_cave[center]    != O_STEEL) work_cave[center]    = expl_code;
    if (work_cave[center+1]  != O_STEEL) work_cave[center+1]  = expl_code;
    if (work_cave[center+39] != O_STEEL) work_cave[center+39] = expl_code;
    if (work_cave[center+40] != O_STEEL) work_cave[center+40] = expl_code;
    if (work_cave[center+41] != O_STEEL) work_cave[center+41] = expl_code;
}

// crush_table[code] = explosion code to spawn when a falling boulder/diamond
// lands on that object, else 0. Firefly (0x10-13 + scanned 0x28-2B) -> S1
// (empty blast); butterfly (0x14-17 + scanned 0x24-27) -> D1 (diamond blast).
// Indexed by a work_cave value (always 0x00..0x2C), replacing four range
// comparisons per falling object with a single table read.
static const unsigned char crush_table[0x2D] = {
    0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,               // 00-0F
    O_EXPL_S1,O_EXPL_S1,O_EXPL_S1,O_EXPL_S1,          // 10-13 firefly
    O_EXPL_D1,O_EXPL_D1,O_EXPL_D1,O_EXPL_D1,          // 14-17 butterfly
    0,0,0,0,0,0,0,0,                                  // 18-1F explosions
    0,0,0,0,                                          // 20-23
    O_EXPL_D1,O_EXPL_D1,O_EXPL_D1,O_EXPL_D1,          // 24-27 butterfly scanned
    O_EXPL_S1,O_EXPL_S1,O_EXPL_S1,O_EXPL_S1,          // 28-2B firefly scanned
    0,                                                 // 2C amoeba_S
};

// stationary = код, который остаётся, когда объект приземлился
// scanned    = код новой клетки при движении (*_S -> на следующем тике падает)
// falling    = 1, если уже падал в этом тике (тогда давит Rockford)
//
// Порядок как на C64 (ProcessFallingBoulder/Diamond):
//   1) снизу пусто        -> падаем, клетка становится *_S
//   2) снизу magic wall   -> валун<->алмаз в клетку через стену, себя стираем
//   3) снизу критер       -> crush_table, взрыв 3x3
//   4) уже падали + Rockford снизу -> смерть
//   5) снизу круглое      -> скат влево, иначе вправо (приоритет C64)
//   6) упёрлись, falling  -> становимся stationary (иначе лежащий так и лежит)
void falling_tick(int i, char col, char stationary, char scanned, char falling)
{
    char below = work_cave[i + 40];

    // Space below: keep falling (scanned -> falling code next tick)
    if (below == O_EMPTY) {
        work_cave[i] = O_EMPTY;
        work_cave[i+40] = scanned;
        if (stationary == O_DIAMOND)
            sound_event(SFX_FALL_DIAMOND);   // "ding"
        else
            sound_event(SFX_BOULDER);        // low thud
        return;
    }

    // Magic wall below (C64 ProcessFallingBoulder/Diamond): convert boulder<->diamond
    if (below == O_MAGIC) {
        // Activate magic wall if not already
        if (!magic_wall_active) {
            magic_wall_active = 1;
            magic_wall_timer = 0;
            magic_wall_seconds = 0;
        }
        // If still active and cell two below is empty -> convert
        if (magic_wall_active == 1 && work_cave[i + 80] == O_EMPTY) {
            // boulder -> diamond, diamond -> boulder
            work_cave[i + 80] = (scanned == O_DIAMOND_S) ? O_BOULDER_S : O_DIAMOND_S;
        }
        // Consume the falling object (C64: clear cell above magic wall)
        work_cave[i] = O_EMPTY;
        if (stationary == O_DIAMOND)
            sound_event(SFX_FALL_DIAMOND);   // diamond "ding"/"don"
        else
            sound_event(SFX_BOULDER);        // boulder thud
        return;
    }

    // Crushes a firefly (-> space blast, C64 $1c) or butterfly (-> diamond
    // blast, C64 $21). One table read covers both, for scanned and unscanned.
    {
        unsigned char cr = crush_table[(unsigned char)below];
        if (cr) {
            explode_3x3(i + 40, cr);
            sound_event(SFX_EXPLODE);
            return;
        }
    }

    if (falling) {
        // Lands on Rockford's head -> he is crushed (stationary object resting
        // on him does nothing - C64).
        if (below == O_ROCKFORD) {
            explode_3x3(i + 40, O_EXPL_S1);  // 3x3 space blast centered on Rockford
            sound_event(SFX_EXPLODE);
            // game_over is set inside explode_3x3 (Rockford is in his own blast)
            return;
        }
    }

    // Round object below: try to roll off to the side (stays falling)
    if (is_round(below)) {
        // Roll left-down
        if (col > 0 && work_cave[i-1] == O_EMPTY && work_cave[i+39] == O_EMPTY) {
            work_cave[i] = O_EMPTY;
            work_cave[i+39] = scanned;
            if (stationary == O_DIAMOND)
                sound_event(SFX_FALL_DIAMOND);   // diamond roll
            else
                sound_event(SFX_BOULDER);        // boulder roll
            return;
        }
        // Roll right-down
        if (col < 39 && work_cave[i+1] == O_EMPTY && work_cave[i+41] == O_EMPTY) {
            work_cave[i] = O_EMPTY;
            work_cave[i+41] = scanned;
            if (stationary == O_DIAMOND)
                sound_event(SFX_FALL_DIAMOND);   // diamond roll
            else
                sound_event(SFX_BOULDER);        // boulder roll
            return;
        }
    }

    // Blocked: a falling object comes to rest (becomes stationary again).
    if (falling) work_cave[i] = stationary;
}

// ============================================================
// Per-object handlers (C64 ProcessButterfly / ProcessFirefly).
// Extracted so both the asm scan loop and the C fallback share
// the exact same logic.
// ============================================================
void do_butterfly(int i, char col, char obj)
{
    char d;
    if      (obj == O_BF_DOWN)  d=0;
    else if (obj == O_BF_LEFT)  d=1;
    else if (obj == O_BF_UP)    d=2;
    else                        d=3;

    // Contact check: Rockford or Amoeba in one of the 4 neighbours?
    // Butterfly -> diamond blast (C64: $21 explosion to diamonds).
    {
        char hit = 0;
        char expl_code = O_EXPL_D1;
        if (i >= 80  && work_cave[i-40] == O_AMOEBA_A) hit = 1;
        if (i < 800 && work_cave[i+40] == O_AMOEBA_A) hit = 1;
        if (col > 0  && work_cave[i-1]  == O_AMOEBA_A) hit = 1;
        if (col < 39 && work_cave[i+1]  == O_AMOEBA_A) hit = 1;
        if (!hit) {
            if ((i - 40 == rockford_i && i >= 80)  ||
                (i + 40 == rockford_i && i < 800)  ||
                (i - 1  == rockford_i && col > 0)  ||
                (i + 1  == rockford_i && col < 39)) {
                hit = 1;
            }
        }
        if (hit) {
            explode_3x3(i, expl_code);  // 3x3 blast (C64: Explode3x3Cells)
            sound_event(SFX_EXPLODE);
            // game_over is set inside explode_3x3 if Rockford is in blast zone
            return;
        }
    }

    // Right(+1)->straight(0)->left(+3, turn only)->reverse(+2)
    if (bf_try(i,col,d,1,1)) return;
    if (bf_try(i,col,d,0,1)) return;
    if (bf_try(i,col,d,3,0)) return;
    work_cave[i] = bf_code((d + 2) & 3);
}

void do_firefly(int i, char col, char obj)
{
    char d;
    if      (obj == O_FF_DOWN)  d=0;
    else if (obj == O_FF_LEFT)  d=1;
    else if (obj == O_FF_UP)    d=2;
    else                        d=3;

    // Contact check: Rockford or Amoeba in one of the 4 neighbours?
    // Firefly -> space blast (C64: $1c explosion to space).
    {
        char hit = 0;
        char expl_code = O_EXPL_S1;
        if (i >= 80  && work_cave[i-40] == O_AMOEBA_A) hit = 1;
        if (i < 800 && work_cave[i+40] == O_AMOEBA_A) hit = 1;
        if (col > 0  && work_cave[i-1]  == O_AMOEBA_A) hit = 1;
        if (col < 39 && work_cave[i+1]  == O_AMOEBA_A) hit = 1;
        if (!hit) {
            if ((i - 40 == rockford_i && i >= 80)  ||
                (i + 40 == rockford_i && i < 800)  ||
                (i - 1  == rockford_i && col > 0)  ||
                (i + 1  == rockford_i && col < 39)) {
                hit = 1;
            }
        }
        if (hit) {
            explode_3x3(i, expl_code);  // 3x3 blast (C64: Explode3x3Cells)
            sound_event(SFX_EXPLODE);
            // game_over is set inside explode_3x3 if Rockford is in blast zone
            return;
        }
    }

    // Right(+1)->straight(0)->left(+3, turn only)->reverse(+2)
    if (ff_try(i,col,d,1,1)) return;
    if (ff_try(i,col,d,0,1)) return;
    if (ff_try(i,col,d,3,0)) return;
    work_cave[i] = ff_code((d + 2) & 3);
}

// ============================================================
// Амёба (C64 ProcessAmoeba $6fd0).
//
// Вызывается на каждую клетку O_AMOEBA_A. phys_ptr/phys_col уже выставлены
// сканом. Новая поросль пишется как O_AMOEBA_S и станет O_AMOEBA_A
// на следующем тике — иначе скан обработал бы её повторно.
//
// Правила C64, от них ломаются уровни, если соврать:
//   - больше 200 клеток за прошлый тик -> эта клетка становится валуном
//   - никуда не смогла расти прошлый тик -> становится алмазом
//     (пещеры D/G «душат» амёбу стенами именно так)
//   - рост: случайный байт & amoeba_growth_mask == 0, и сосед пустой.
//     Маска 0x7F (~3.1%), через N секунд 0x0F (~25%).
//
// C-версия на тяжёлой пещере стоила до 60 мс: sccz80 16-битная индексация
// плюс random(0,256) через библиотечное деление. Asm ходит указателями
// и берёт младший байт GetRand() — бит-в-бит то же значение, маска <= 0x7F.
// ============================================================
#if PHYS_ASM
void do_amoeba(void)
{
#asm
            ; --- amoeba_count_this_tick++ ---
            LXI  H,_amoeba_count_this_tick
            INR  M
            ; --- previous tick had >= 200 cells -> too big, become a boulder ---
            LDA  _amoeba_count_prev_tick
            CPI  200
            JC   am_notbig
            LHLD _phys_ptr
            MVI  M,0eh              ; O_BOULDER_S
            RET
am_notbig:
            ; --- couldnt grow anywhere last tick -> trapped, become a diamond ---
            LDA  _amoeba_could_grow_last
            ORA  A
            JNZ  am_probe
            LHLD _phys_ptr
            MVI  M,06h              ; O_DIAMOND
            RET
am_probe:
            ; --- has any cell already found room this tick?  if not, probe ---
            LDA  _amoeba_could_grow_this
            ORA  A
            JNZ  am_grow
            ; up (needs i >= 80)
            LHLD _phys_i
            MOV  A,H
            ORA  A
            JNZ  am_pr_up
            MOV  A,L
            CPI  80
            JC   am_pr_left
am_pr_up:
            LHLD _phys_ptr
            LXI  D,0ffd8h           ; -40
            DAD  D
            MOV  A,M
            CALL am_isfree
            JZ   am_setcan
am_pr_left:
            LDA  _phys_col
            ORA  A
            JZ   am_pr_right
            LHLD _phys_ptr
            DCX  H
            MOV  A,M
            CALL am_isfree
            JZ   am_setcan
am_pr_right:
            LDA  _phys_col
            CPI  39
            JNC  am_pr_down
            LHLD _phys_ptr
            INX  H
            MOV  A,M
            CALL am_isfree
            JZ   am_setcan
am_pr_down:
            LHLD _phys_i            ; needs i < 800
            MOV  A,H
            CPI  3
            JC   am_pr_dn
            JNZ  am_grow
            MOV  A,L
            CPI  20h
            JNC  am_grow
am_pr_dn:
            LHLD _phys_ptr
            LXI  D,40
            DAD  D
            MOV  A,M
            CALL am_isfree
            JNZ  am_grow
am_setcan:
            MVI  A,1
            STA  _amoeba_could_grow_this
am_grow:
            ; --- growth attempt (C64: TimeBasedRandomNumber AND mask, CMP #4) ---
            ; the same masked random is both the probability gate and the
            ; direction: 0=up 1=left 2=right 3=down
            CALL _GetRand           ; HL = 16-bit LFSR value
            LDA  _amoeba_growth_mask
            ANA  L                  ; A = random_byte & mask
            CPI  04h
            RNC                     ; >= 4 -> no growth this tick
            ORA  A
            JZ   am_up
            CPI  01h
            JZ   am_left
            CPI  02h
            JZ   am_right
            ; --- down (needs i < 800) ---
            LHLD _phys_i
            MOV  A,H
            CPI  3
            JC   am_dn_ok
            RNZ
            MOV  A,L
            CPI  20h
            RNC
am_dn_ok:
            LHLD _phys_ptr
            LXI  D,40
            DAD  D
            JMP  am_put
am_up:                              ; needs i >= 80
            LHLD _phys_i
            MOV  A,H
            ORA  A
            JNZ  am_up_ok
            MOV  A,L
            CPI  80
            RC
am_up_ok:
            LHLD _phys_ptr
            LXI  D,0ffd8h           ; -40
            DAD  D
            JMP  am_put
am_left:
            LDA  _phys_col
            ORA  A
            RZ                      ; col == 0
            LHLD _phys_ptr
            DCX  H
            JMP  am_put
am_right:
            LDA  _phys_col
            CPI  39
            RNC                     ; col >= 39
            LHLD _phys_ptr
            INX  H
am_put:
            MOV  A,M
            CALL am_isfree
            RNZ                     ; occupied -> nothing grows
            MVI  M,2ch              ; O_AMOEBA_S (becomes AMOEBA_A next scan)
            RET

; ---------- am_isfree(A=cell): Z set if the amoeba may spread into it ----------
am_isfree:
            ORA  A
            RZ                      ; O_EMPTY
            CPI  02h                ; O_DIRT
            RET
#endasm
}
#else
void do_amoeba(void)
{
    int  i   = phys_i;
    char col = phys_col;
    int  ti;
    char obj;

    // Count this amoeba cell
    amoeba_count_this_tick++;

    // Size check: if previous tick had >= 200 cells -> too big -> boulder
    if (amoeba_count_prev_tick >= 200) {
        work_cave[i] = O_BOULDER_S;
        return;
    }

    // Confinement check: if couldn't grow last tick -> trapped -> diamond
    if (!amoeba_could_grow_last) {
        work_cave[i] = O_DIAMOND;
        return;
    }

    // Test if amoeba can grow this tick (any free direction?)
    if (!amoeba_could_grow_this) {
        char can = 0;
        // Up
        if (i >= 80) {
            obj = work_cave[i - 40];
            if (obj == O_EMPTY || obj == O_DIRT) can = 1;
        }
        // Left
        if (!can && col > 0) {
            obj = work_cave[i - 1];
            if (obj == O_EMPTY || obj == O_DIRT) can = 1;
        }
        // Right
        if (!can && col < 39) {
            obj = work_cave[i + 1];
            if (obj == O_EMPTY || obj == O_DIRT) can = 1;
        }
        // Down
        if (!can && i < 800) {
            obj = work_cave[i + 40];
            if (obj == O_EMPTY || obj == O_DIRT) can = 1;
        }
        amoeba_could_grow_this = can;
    }

    // Growth attempt (C64: JSR TimeBasedRandomNumber, AND mask, CMP #4, TAX)
    // The SAME random & mask value is both the probability gate AND the direction:
    //   rnd & mask < 4  ->  grow in direction rnd (0=up,1=left,2=right,3=down)
    // This creates a mask-dependent direction bias (e.g. cave G mask 0x74 -> only up).
    {
        unsigned char rnd = random(0, 256) & amoeba_growth_mask;
        if (rnd < 4) {
            char dir = rnd;  // 0=up, 1=left, 2=right, 3=down
        switch (dir) {
        case 0: // Up
            if (i >= 80) {
                ti = i - 40;
                obj = work_cave[ti];
                if (obj == O_EMPTY || obj == O_DIRT)
                    work_cave[ti] = O_AMOEBA_S;
            }
            break;
        case 1: // Left
            if (col > 0) {
                ti = i - 1;
                obj = work_cave[ti];
                if (obj == O_EMPTY || obj == O_DIRT)
                    work_cave[ti] = O_AMOEBA_S;
            }
            break;
        case 2: // Right
            if (col < 39) {
                ti = i + 1;
                obj = work_cave[ti];
                if (obj == O_EMPTY || obj == O_DIRT)
                    work_cave[ti] = O_AMOEBA_S;
            }
            break;
        case 3: // Down
            if (i < 800) {
                ti = i + 40;
                obj = work_cave[ti];
                if (obj == O_EMPTY || obj == O_DIRT)
                    work_cave[ti] = O_AMOEBA_S;
            }
            break;
        }
    }
    }
}
#endif

// ============================================================
// phys_handle(): process ONE active cell. Reads phys_i/col/obj
// (set by the asm scan loop). obj is guaranteed to be one of
// {O_BOULDER(_F), O_DIAMOND(_F), O_FF_*, O_BF_*, O_EXPL_S1..S5,
//  O_EXPL_D1..D5}  (codes 0x04,0x06,0x0C,0x0D,0x10..0x21).
// ============================================================
#if PHYS_ASM
// --- 8080 asm port of phys_handle + falling_tick + do_butterfly/do_firefly.
// Reads phys_obj/phys_col/phys_ptr/phys_i (set by the scan loop) and works on
// work_cave directly; no nested C calls, no sccz80 stack args. Sound and the
// 3x3 explosion are inlined in asm too. Behaviour is byte-for-byte identical
// to the C fallback below (same scanned/falling codes, same C64 turn order).
//   ph_ptr = &work_cave[i]   ph_fall = falling_tick "already falling" flag
//   ph_d/ph_rd = critter dir   ph_bdir/ph_bscan/ph_explc = critter type params
void phys_handle(void)
{
#asm
            ; dispatch ordered by frequency: boulders and diamonds are by far
            ; the most common active cells, so they are matched first.
            LDA  _phys_obj
            CPI  04h
            JZ   ph_boulder         ; 0x04 stationary boulder
            CPI  06h
            JZ   ph_diamond         ; 0x06 stationary diamond
            CPI  0ch
            JZ   ph_boulderF        ; 0x0C falling boulder
            CPI  0dh
            JZ   ph_diamondF        ; 0x0D falling diamond
            CPI  23h
            JZ   ph_amoeba_c        ; 0x23 amoeba_A -> C handler
            CPI  14h
            JNC  ph_butter          ; 0x14-0x17 butterfly
            JMP  ph_fire            ; 0x10-0x13 firefly

ph_amoeba_c:
            CALL ph_geti            ; do_amoeba() reads phys_i
            JMP  _do_amoeba         ; tail call

; ---------- phys_i = phys_ptr - work_cave ----------
; The scan loop no longer computes the cell index for every active cell -
; boulders and diamonds never look at it.  Only the critters and the amoeba
; need it, and they ask for it here.
ph_geti:
            LHLD _phys_ptr
            LXI  D,_work_cave
            MOV  A,L
            SUB  E
            MOV  L,A
            MOV  A,H
            SBB  D
            MOV  H,A
            SHLD _phys_i
            RET

; ---------- falling_tick(stationary, scanned, falling) ----------
; v2 register plan - the cell pointer and the cell-below pointer stay live
; for the whole routine, so not one of the old
;     LHLD ph_ptr / LXI D,40 / DAD D   (36 T each, up to 4 times per call)
; sequences is left, and is_round() is inlined instead of CALLed:
;     HL = &work_cave[i]      DE = &work_cave[i+40]
;     B  = scanned code       C  = stationary code     ph_fall = falling flag
ph_boulder:
            MVI  B,0eh              ; O_BOULDER_S
            MVI  C,04h              ; O_BOULDER
            XRA  A
            JMP  ph_fall_common
ph_boulderF:
            MVI  B,0eh
            MVI  C,04h
            MVI  A,1
            JMP  ph_fall_common
ph_diamond:
            MVI  B,0fh              ; O_DIAMOND_S
            MVI  C,06h              ; O_DIAMOND
            XRA  A
            JMP  ph_fall_common
ph_diamondF:
            MVI  B,0fh
            MVI  C,06h
            MVI  A,1
ph_fall_common:
            STA  ph_fall
            LHLD _phys_ptr
            SHLD ph_ptr             ; base = &work_cave[i] (for the rare paths)
            XCHG                    ; DE = ptr
            LXI  H,40
            DAD  D
            XCHG                    ; DE = ptr+40, HL = ptr
            LDAX D                  ; A = below = work_cave[i+40]
            ORA  A
            JNZ  ft_notempty
            ; --- empty below: fall straight down ---
            MVI  M,00h              ; work_cave[i] = empty
            MOV  A,B
            STAX D                  ; work_cave[i+40] = scanned
            MOV  A,C
            CPI  06h                ; O_DIAMOND?
            JZ   ph_sfdia           ; tail jump: the sound helper RETs for us
            JMP  ph_sboul
ft_notempty:
            ; --- Magic wall check (C64: boulder/diamond on magic wall converts) ---
            CPI  0bh                ; O_MAGIC
            JZ   ft_magic_wall
            ; A = below. crush a firefly (->S1) or butterfly (->D1)?
            CPI  10h
            JC   ft_nocrush         ; <0x10 not a critter (the common case)
            CPI  18h
            JC   ft_crush_1017      ; 0x10-0x17 unscanned critter
            CPI  24h
            JC   ft_nocrush         ; 0x18-0x23 explosion/rockford/amoeba
            CPI  2ch
            JNC  ft_nocrush         ; >=0x2C not a critter
            CPI  28h
            JC   ft_crush_bf        ; 0x24-0x27 butterfly scanned -> D1
            JMP  ft_crush_ff        ; 0x28-0x2B firefly scanned  -> S1
ft_crush_1017:
            CPI  14h
            JC   ft_crush_ff        ; 0x10-0x13 firefly -> S1
ft_crush_bf:
            XCHG                    ; HL = &work_cave[i+40] = blast centre
            MVI  B,1dh              ; O_EXPL_D1
            CALL ph_expl
            JMP  ph_sexpl
ft_crush_ff:
            XCHG                    ; HL = &work_cave[i+40] = blast centre
            MVI  B,18h              ; O_EXPL_S1
            CALL ph_expl
            JMP  ph_sexpl
ft_nocrush:
            LDA  ph_fall
            ORA  A
            JZ   ft_round_check
            ; falling onto Rockford head -> 3x3 space blast centered on Rockford
            LDAX D
            CPI  22h                ; O_ROCKFORD
            JNZ  ft_round_check
            XCHG                    ; HL = Rockford cell = centre of 3x3 blast
            MVI  B,18h              ; O_EXPL_S1
            CALL ph_expl            ; 3x3 blast (sets _game_over via ph_rf_hit)
            JMP  ph_sexpl
ft_round_check:
            LDAX D                  ; A = below
            ; --- is_round(below) inlined: 3,4,6,0x0C-0x0F are round ---
            CPI  03h
            JC   ft_blocked         ; 0x00-0x02 -> flat (empty/steel/dirt)
            CPI  05h
            JC   ft_round           ; 0x03 brick, 0x04 boulder
            CPI  06h
            JZ   ft_round           ; 0x06 diamond
            CPI  0ch
            JC   ft_blocked         ; 0x07-0x0B
            CPI  10h
            JNC  ft_blocked         ; >= 0x10
ft_round:
            ; round object below: try to roll left-down, then right-down
            LDA  _phys_col
            ORA  A
            JZ   ft_try_right       ; col == 0 -> no left roll
            DCX  H
            MOV  A,M                ; work_cave[i-1]
            INX  H
            ORA  A
            JNZ  ft_try_right
            DCX  D                  ; DE = &work_cave[i+39]
            LDAX D
            ORA  A
            JNZ  ft_lroll_no
            MVI  M,00h              ; work_cave[i] = empty
            MOV  A,B
            STAX D                  ; work_cave[i+39] = scanned
            MOV  A,C
            CPI  06h                ; O_DIAMOND?
            JZ   ph_sfdia
            JMP  ph_sboul
ft_lroll_no:
            INX  D                  ; DE back to &work_cave[i+40]
ft_try_right:
            LDA  _phys_col
            CPI  39
            JNC  ft_blocked         ; col >= 39 -> no right roll
            INX  H
            MOV  A,M                ; work_cave[i+1]
            DCX  H
            ORA  A
            JNZ  ft_blocked
            INX  D                  ; DE = &work_cave[i+41]
            LDAX D
            ORA  A
            JNZ  ft_blocked
            MVI  M,00h              ; work_cave[i] = empty
            MOV  A,B
            STAX D                  ; work_cave[i+41] = scanned
            MOV  A,C
            CPI  06h                ; O_DIAMOND?
            JZ   ph_sfdia
            JMP  ph_sboul
ft_blocked:                         ; every path that gets here still has HL = ptr
            LDA  ph_fall
            ORA  A
            RZ                      ; stationary object: nothing to do
            MOV  M,C                ; falling object comes to rest
            RET

; ---------- magic wall: boulder <-> diamond conversion (C64 ProcessFallingBoulder/Diamond) ----------
ft_magic_wall:                      ; HL = ptr, DE = ptr+40
            ; Activate magic wall if not already active (C64: state 0 -> state 1)
            LDA  _magic_wall_active
            ORA  A
            JNZ  ftmw_active
            MVI  A,1
            STA  _magic_wall_active
            XRA  A
            STA  _magic_wall_timer
            STA  _magic_wall_seconds
            MVI  A,1                ; state is 1 now - no need to re-read it
ftmw_active:
            ; If magic wall expired (state != 1), just consume falling object
            CPI  1
            JNZ  ftmw_consume
            ; Check cell two rows below (i+80) is empty
            XCHG                    ; HL = ptr+40, DE = ptr
            PUSH D                  ; keep ptr
            LXI  D,40
            DAD  D                  ; HL = ptr+80
            POP  D                  ; DE = ptr
            MOV  A,M                ; work_cave[i+80]
            ORA  A
            JNZ  ftmw_consume2      ; blocked -> consume falling object
            ; Convert: boulder (scan=0x0E) -> diamond (0x0F), diamond (0x0F) -> boulder (0x0E)
            MOV  A,B
            CPI  0fh                ; DIAMOND_S -> produce boulder below
            JZ   ftmw_dia_to_boul
            MVI  M,0fh              ; DIAMOND_S below magic wall
            JMP  ftmw_consume2
ftmw_dia_to_boul:
            MVI  M,0eh              ; BOULDER_S below magic wall
ftmw_consume2:
            XCHG                    ; HL = ptr
ftmw_consume:
            ; Clear falling object cell (consumed by magic wall)
            MVI  M,00h
            MOV  A,B
            CPI  0fh                ; DIAMOND_S -> diamond sound
            JZ   ph_sfdia
            JMP  ph_sboul           ; else boulder sound
; ---------- do_butterfly / do_firefly ----------
ph_butter:
            MVI  A,14h
            STA  ph_bdir
            MVI  A,24h
            STA  ph_bscan
            MVI  A,1dh              ; O_EXPL_D1
            STA  ph_explc
            JMP  ph_critter
ph_fire:
            MVI  A,10h
            STA  ph_bdir
            MVI  A,28h
            STA  ph_bscan
            MVI  A,18h              ; O_EXPL_S1
            STA  ph_explc
ph_critter:
            CALL ph_geti            ; critters compare against rockford_i
            LHLD _phys_ptr
            SHLD ph_ptr
            ; d = (obj - bdir + 2) & 3
            LXI  H,ph_bdir
            LDA  _phys_obj
            SUB  M
            ADI  2
            ANI  3
            STA  ph_d
            ; --- contact check: is Rockford in a 4-neighbour? ---
            LHLD _rockford_i
            XCHG                    ; DE = rockford_i
            ; up: i-40 (guard i>=80)
            LHLD _phys_i
            MOV  A,H
            ORA  A
            JNZ  phc_up_go
            MOV  A,L
            CPI  80
            JC   phc_down
phc_up_go:
            LHLD _phys_i
            LXI  B,0ffd8h           ; -40
            DAD  B
            MOV  A,L
            CMP  E
            JNZ  phc_down
            MOV  A,H
            CMP  D
            JZ   phc_hit
phc_down:
            ; down: i+40 (guard i<800)
            LHLD _phys_i
            MOV  A,H
            CPI  3
            JC   phc_down_go
            JNZ  phc_left
            MOV  A,L
            CPI  20h
            JNC  phc_left
phc_down_go:
            LHLD _phys_i
            LXI  B,40
            DAD  B
            MOV  A,L
            CMP  E
            JNZ  phc_left
            MOV  A,H
            CMP  D
            JZ   phc_hit
phc_left:
            ; left: i-1 (guard col>0)
            LDA  _phys_col
            ORA  A
            JZ   phc_right
            LHLD _phys_i
            DCX  H
            MOV  A,L
            CMP  E
            JNZ  phc_right
            MOV  A,H
            CMP  D
            JZ   phc_hit
phc_right:
            ; right: i+1 (guard col<39)
            LDA  _phys_col
            CPI  39
            JNC  phc_am_up          ; no right neighbour -> amoeba check
            LHLD _phys_i
            INX  H
            MOV  A,L
            CMP  E
            JNZ  phc_am_up          ; no Rockford match -> amoeba check
            MOV  A,H
            CMP  D
            JNZ  phc_am_up          ; no Rockford match -> amoeba check
            JMP  phc_hit            ; Rockford on right -> explode
            ; --- amoeba contact check (C64: TestForExplosionByContactWithRockfordOrAmoeba) ---
            ; Check 4 neighbours for O_AMOEBA_A (0x23). If found, explode critter
            ; using ph_explc (D1 for butterfly, S1 for firefly). No game_over.
            ; up: i-40 (guard i>=80)
            LHLD _phys_i
            MOV  A,H
            ORA  A
            JNZ  phc_am_up
            MOV  A,L
            CPI  80
            JC   phc_am_down
phc_am_up:
            LHLD ph_ptr
            LXI  D,0ffd8h           ; -40
            DAD  D
            MOV  A,M
            CPI  23h                ; O_AMOEBA_A
            JZ   phc_hit_am
phc_am_down:
            LHLD _phys_i
            MOV  A,H
            CPI  3
            JC   phc_am_down_go
            JNZ  phc_am_left
            MOV  A,L
            CPI  20h
            JNC  phc_am_left
phc_am_down_go:
            LHLD ph_ptr
            LXI  D,40
            DAD  D
            MOV  A,M
            CPI  23h
            JZ   phc_hit_am
phc_am_left:
            LDA  _phys_col
            ORA  A
            JZ   phc_am_right
            LHLD ph_ptr
            DCX  H
            MOV  A,M
            CPI  23h
            JZ   phc_hit_am
phc_am_right:
            LDA  _phys_col
            CPI  39
            JNC  phc_move
            LHLD ph_ptr
            INX  H
            MOV  A,M
            CPI  23h
            JNZ  phc_move
phc_hit_am:
            ; 3x3 explosion centered on critter (C64: Explode3x3Cells)
            LDA  ph_explc
            MOV  B,A
            LHLD ph_ptr
            CALL ph_expl            ; fill 3x3 around critter
            CALL ph_sexpl
            RET
phc_hit:
            ; 3x3 explosion centered on critter (C64: Explode3x3Cells)
            LDA  ph_explc
            MOV  B,A
            LHLD ph_ptr
            CALL ph_expl            ; fill 3x3 around critter (covers Rockford too)
            ; ph_expl sets _game_over via ph_rf_hit only if Rockford is in blast
            CALL ph_sexpl
            RET
phc_move:
            ; try right-turn (move), straight (move), left-turn (turn only)
            LDA  ph_d
            INR  A
            ANI  3
            STA  ph_rd
            MVI  A,1
            STA  ph_move
            CALL ph_try
            ORA  A
            RNZ
            LDA  ph_d
            STA  ph_rd
            MVI  A,1
            STA  ph_move
            CALL ph_try
            ORA  A
            RNZ
            LDA  ph_d
            ADI  3
            ANI  3
            STA  ph_rd
            XRA  A
            STA  ph_move
            CALL ph_try
            ORA  A
            RNZ
            ; all blocked -> reverse: work_cave[i] = bdir + d
            LDA  ph_d
            MOV  C,A
            LDA  ph_bdir
            ADD  C
            LHLD ph_ptr
            MOV  M,A
            RET

; ---------- ph_try(rd=ph_rd, do_move=ph_move) -> A=1 handled / 0 next ----------
ph_try:
            LDA  ph_rd
            ORA  A
            JZ   pht_down
            CPI  1
            JZ   pht_left
            CPI  2
            JZ   pht_up
            ; rd==3 right (guard col<39)
            LDA  _phys_col
            CPI  39
            JNC  pht_ret0
            LXI  H,1
            JMP  pht_ok
pht_down:
            LHLD _phys_i            ; guard ti<840 -> i<800
            MOV  A,H
            CPI  3
            JC   pht_down_ok
            JNZ  pht_ret0
            MOV  A,L
            CPI  20h
            JNC  pht_ret0
pht_down_ok:
            LXI  H,40
            JMP  pht_ok
pht_left:
            LDA  _phys_col
            ORA  A
            JZ   pht_ret0
            LXI  H,0ffffh           ; -1
            JMP  pht_ok
pht_up:
            LHLD _phys_i            ; guard ti>=40 -> i>=80
            MOV  A,H
            ORA  A
            JNZ  pht_up_ok
            MOV  A,L
            CPI  80
            JC   pht_ret0
pht_up_ok:
            LXI  H,0ffd8h           ; -40
pht_ok:
            XCHG                    ; DE = delta
            LHLD ph_ptr
            DAD  D
            SHLD ph_tptr            ; ti pointer
            LDA  ph_move
            ORA  A
            JZ   pht_turnonly
            LHLD ph_tptr
            MOV  A,M                ; work_cave[ti]
            ORA  A
            JZ   pht_moveok
            CPI  0ch
            JC   pht_ret0           ; blocked by non-falling
            CPI  10h
            JNC  pht_ret0
            ; hit a falling boulder/diamond (0x0C-0x0F) -> explode at i
            LDA  ph_explc
            MOV  B,A
            LHLD ph_ptr
            CALL ph_expl
            CALL ph_sexpl
            JMP  pht_ret1
pht_moveok:
            LHLD ph_ptr
            MVI  M,00h              ; leave empty
            LDA  ph_rd
            ADI  2
            ANI  3
            MOV  B,A
            LDA  ph_bscan
            ADD  B
            MOV  B,A                ; scanned code for rd
            LHLD ph_tptr
            MOV  M,B
            JMP  pht_ret1
pht_turnonly:
            LDA  ph_rd
            ADI  2
            ANI  3
            MOV  B,A
            LDA  ph_bdir
            ADD  B                  ; dir code for rd
            LHLD ph_ptr
            MOV  M,A
            JMP  pht_ret1
pht_ret0:
            XRA  A
            RET
pht_ret1:
            MVI  A,1
            RET

; (ph_round removed - is_round() is now inlined at ft_round_check)

; ---------- ph_expl(HL=center ptr, B=code): 3x3 blast, steel survives ----------
ph_expl:
            XRA  A
            STA  ph_rf_hit           ; reset Rockford-in-blast flag
            LXI  D,0ffd7h           ; -41
            DAD  D
            CALL ph_ec              ; center-41
            INX  H
            CALL ph_ec              ; center-40
            INX  H
            CALL ph_ec              ; center-39
            LXI  D,38
            DAD  D
            CALL ph_ec              ; center-1
            INX  H
            CALL ph_ec              ; center
            INX  H
            CALL ph_ec              ; center+1
            LXI  D,38
            DAD  D
            CALL ph_ec              ; center+39
            INX  H
            CALL ph_ec              ; center+40
            INX  H
            CALL ph_ec              ; center+41
            LDA  ph_rf_hit          ; was Rockford inside the 3x3 blast?
            ORA  A
            RZ                      ; no - return
            STA  _game_over         ; yes - Rockford dies (triggers dead_ticks counting)
            RET
ph_ec:
            MOV  A,M
            CPI  01h                ; O_STEEL survives
            RZ
            CPI  22h                ; O_ROCKFORD?
            JNZ  ph_ec_wr           ; no - just write explosion code
            PUSH H                  ; save cell pointer
            LXI  H,ph_rf_hit
            MVI  M,1               ; set Rockford-in-blast flag
            POP  H                  ; restore cell pointer
ph_ec_wr:
            MOV  M,B
            RET

; ---------- sound: replicate sound_event() (id-priority) in asm ----------
ph_sfdia:                           ; SFX_FALL_DIAMOND (id 1, dur 2) - lowest priority
            LDA  _ev_id
            ORA  A
            RNZ                     ; any sound playing -> skip
            MVI  A,1
            STA  _ev_id
            MVI  A,2
            STA  _ev_t
            LDA  _fall_dia_toggle   ; alternate ding/don
            XRI  01h
            STA  _fall_dia_toggle
            RET
ph_sboul:                           ; SFX_BOULDER (id 2, dur 2)
            LDA  _ev_id
            CPI  3
            JNC  ph_sb_done         ; ev_id > 2 -> higher priority already active
            MVI  A,2
            STA  _ev_id
            MVI  A,2
            STA  _ev_t
ph_sb_done:
            RET
ph_sexpl:                           ; SFX_EXPLODE (id 4, dur 6) - always wins
            MVI  A,4
            STA  _ev_id
            MVI  A,6
            STA  _ev_t
            RET

ph_ptr:     defw 0
ph_tptr:    defw 0
ph_fall:    defb 0     ; (scanned/stationary codes now live in B/C)
ph_d:       defb 0
ph_rd:      defb 0
ph_move:    defb 0
ph_bdir:    defb 0
ph_bscan:   defb 0
ph_explc:   defb 0
ph_rf_hit:  defb 0     ; set to 1 by ph_ec if Rockford is inside the 3x3 blast
#endasm
}
#else
void phys_handle(void)
{
    int  i   = phys_i;
    char col = phys_col;
    char obj = phys_obj;

    if (obj == O_BOULDER)   { falling_tick(i, col, O_BOULDER, O_BOULDER_S, 0); return; }
    if (obj == O_BOULDER_F) { falling_tick(i, col, O_BOULDER, O_BOULDER_S, 1); return; }
    if (obj == O_DIAMOND)   { falling_tick(i, col, O_DIAMOND, O_DIAMOND_S, 0); return; }
    if (obj == O_DIAMOND_F) { falling_tick(i, col, O_DIAMOND, O_DIAMOND_S, 1); return; }

    if (obj >= O_BF_UP) { do_butterfly(i, col, obj); return; }  // 0x14..0x17
    do_firefly(i, col, obj);                                    // 0x10..0x13
}
#endif

// ============================================================
// Скан физики: один проход сверху вниз (порядок C64 ProcessCave).
//
// Регистры горячего цикла:
//   HL = &work_cave[i]   B = строк осталось (20..1)   C = групп по 4 (10..1)
//
// Раньше на каждую клетку держали 16-битный счётчик в DE И колонку в C:
// INR C / CPI 40 / DCX D / ORA E — 80 тактов на инертную клетку.
// Сейчас оба счётчика слиты в пару «строка/группа», тело развёрнуто
// по 4 клетки: MOV A,M / CPI 4 / JNC / INX H = 29 тактов на пустоту/сталь/
// землю/кирпич (коды 0x00..0x03). 800 клеток ~26к тактов вместо ~64к.
//
// Колонка не ведётся вообще: для редкого pp_call она восстанавливается
// как col = 40 - 4*C + slot. Заглушки pp_x0..x3 кладут адрес возврата
// на стек, любой выход из медленного пути — это RET обратно в развёртку.
//
// pp_bfast: лежащий валун/алмаз (0x04/0x06) почти никогда не двигается.
// Одно чтение work_cave[i+40] решает, стоит ли звать falling_tick.
// Падающие 0x0C/0x0D этот фильтр обходят — им нужно «приземлиться».
// ============================================================
#if PHYS_ASM
void process_physics(void)
{
#asm
            LXI  H,_work_cave       ; ptr -> cave base
            LXI  D,40
            DAD  D                  ; ptr -> first game cell (row 1)
            MVI  B,20               ; B = rows remaining (rows 1..20)
pp_rowlp:
            ; --- timebase: sample the VG75 frame pulse once per row, so the
            ;     pulses that pass *while* the scan runs are counted (see
            ;     vsync_poll() in main.c).  Only A and flags are touched. ---
            PUSH H
            LXI  H,0c001h
            MOV  A,M
            ANI  20h
            LXI  H,_vs_prev
            CMP  M
            JZ   pv_done
            MOV  M,A
            ORA  A
            JZ   pv_done            ; 1->0 edge, not a new frame
            LXI  H,_vs_left
            MOV  A,M
            ORA  A
            JZ   pv_done            ; budget already spent
            DCR  M
pv_done:
            POP  H
            MVI  C,10               ; C = groups of 4 columns remaining
pp_loop:
            ; ---- 4 cells unrolled: only 29 T-states per inert cell ----
            MOV  A,M
            CPI  04h
            JNC  pp_x0
pp_r0:      INX  H
            MOV  A,M
            CPI  04h
            JNC  pp_x1
pp_r1:      INX  H
            MOV  A,M
            CPI  04h
            JNC  pp_x2
pp_r2:      INX  H
            MOV  A,M
            CPI  04h
            JNC  pp_x3
pp_r3:      INX  H
            DCR  C
            JNZ  pp_loop
            DCR  B
            JNZ  pp_rowlp
            JMP  pp_endscan

            ; ---- slow-path stubs: push the resume address, remember which
            ;      of the 4 unrolled slots we are in (E), keep the code in A ----
pp_x0:      LXI  D,pp_r0
            PUSH D
            MVI  E,0
            JMP  pp_slow
pp_x1:      LXI  D,pp_r1
            PUSH D
            MVI  E,1
            JMP  pp_slow
pp_x2:      LXI  D,pp_r2
            PUSH D
            MVI  E,2
            JMP  pp_slow
pp_x3:      LXI  D,pp_r3
            PUSH D
            MVI  E,3
            JMP  pp_slow

pp_slow:                            ; A = object code >= 0x04, HL = &work_cave[i]
            CPI  04h
            JZ   pp_bfast           ; 0x04 boulder   -> cheap can it move? test
            CPI  06h
            JZ   pp_bfast           ; 0x06 diamond   -> cheap can it move? test
            CPI  0ch
            JZ   pp_call            ; 0x0C boulder_F (falling)
            CPI  0dh
            JZ   pp_call            ; 0x0D diamond_F (falling)
            CPI  0eh
            JZ   pp_conv_b          ; 0x0E BOULDER_S -> falling
            CPI  0fh
            JZ   pp_conv_d          ; 0x0F DIAMOND_S -> falling
            CPI  10h
            JC   pp_ret             ; 0x05,0x07-0x0B exit/inbox/amoeba/magic -> inert
            CPI  18h
            JC   pp_call            ; 0x10-0x17 firefly + butterfly -> active
            ; --- explosions 0x18-0x21 handled inline (no CALL) ---
            CPI  1ch
            JZ   pp_expl_s5         ; 0x1C EXPL_S5 -> EMPTY
            CPI  1dh
            JC   pp_expl_inc        ; 0x18-0x1B EXPL_S1-S4 -> advance
            CPI  21h
            JZ   pp_expl_d5         ; 0x21 EXPL_D5 -> DIAMOND
            CPI  22h
            JC   pp_expl_inc        ; 0x1D-0x20 EXPL_D1-D4 -> advance
            ; --- inert high codes (flags from the CPI 22h above still valid) ---
            JZ   pp_ret             ; 0x22 rockford -> inert
            CPI  23h
            JZ   pp_call            ; 0x23 amoeba_A -> active
            CPI  24h
            JC   pp_ret             ; (none)
            CPI  2ch
            JC   pp_conv_bf         ; 0x24-0x2B scanned critters -> convert
            JZ   pp_conv_am         ; 0x2C amoeba_S -> convert to amoeba_A
pp_ret:     RET                     ; >= 0x2D -> inert; back into the unrolled scan

; ------------------------------------------------------------
; pp_bfast - pre-filter for a *resting* boulder/diamond (0x04/0x06).
;
; A cave is full of boulders that sit on dirt and do nothing for the whole
; level, yet each of them cost ~454 T every tick: stub + pp_call + CALL
; phys_handle + dispatch + the whole falling_tick setup, only to fall out
; at ft_blocked with fall==0 and change nothing.
;
; One read of work_cave[i+40] decides it.  Only the cells falling_tick can
; actually react to are handed on to the full handler:
;   0x00        empty            -> starts falling
;   0x03,04,06,0x0C-0x0F  round  -> may roll off to the side
;   0x0B        magic wall
;   0x10-0x17, 0x24-0x2B  critter-> crushed by contact
; For everything else falling_tick would run is_round()==false and, since
; the object is not falling, return without a single write - so we return
; right here, in ~170 T instead of ~454 T.
; NOTE: only valid for the stationary codes.  0x0C/0x0D (already falling)
; must always reach falling_tick, because a blocked faller has to come to
; rest (work_cave[i] = stationary); they bypass this filter.
; ------------------------------------------------------------
pp_bfast:
            STA  _phys_obj          ; pp_call2 will not repeat this
            PUSH H
            MOV  A,L
            ADI  40
            MOV  L,A
            JNC  pbf_nc
            INR  H
pbf_nc:
            MOV  A,M                ; A = work_cave[i+40]
            POP  H
            ORA  A
            JZ   pp_call2           ; 0x00 empty -> it falls
            CPI  03h
            JC   pp_ret             ; 0x01 steel, 0x02 dirt -> stays put
            CPI  05h
            JC   pp_call2           ; 0x03 brick, 0x04 boulder -> round
            CPI  06h
            JZ   pp_call2           ; 0x06 diamond -> round
            CPI  0bh
            JC   pp_ret             ; 0x05, 0x07-0x0A -> stays put
            CPI  10h
            JC   pp_call2           ; 0x0B magic wall, 0x0C-0x0F round
            CPI  18h
            JC   pp_call2           ; 0x10-0x17 critter -> crushed
            CPI  24h
            JC   pp_ret             ; 0x18-0x23 explosion/rockford/amoeba
            CPI  2ch
            JC   pp_call2           ; 0x24-0x2B scanned critter -> crushed
            RET                     ; 0x2C amoeba scanned -> stays put

pp_expl_inc:
            INR  M                  ; advance explosion stage
            RET
pp_expl_s5:
            MVI  M,00h              ; EXPL_S5 -> EMPTY
            RET
pp_expl_d5:
            MVI  M,06h              ; EXPL_D5 -> DIAMOND
            RET
pp_conv_b:
            MVI  M,0ch              ; 0x0E BOULDER_S -> 0x0C falling boulder
            RET
pp_conv_d:
            MVI  M,0dh              ; 0x0F DIAMOND_S -> 0x0D falling diamond
            RET
pp_conv_bf:
            CPI  28h
            JC   pp_bf              ; 0x24..0x27 butterfly scanned -> -0x10
            SUI  18h                ; 0x28..0x2B firefly  scanned -> -0x18
            MOV  M,A
            RET
pp_bf:
            SUI  10h
            MOV  M,A
            RET
pp_conv_am:
            MVI  M,23h              ; 0x2C AMOEBA_S -> 0x23 AMOEBA_A
            RET
pp_call:
            STA  _phys_obj          ; save obj
pp_call2:                           ; entry for pp_bfast (obj already saved)
            SHLD _phys_ptr          ; save ptr (HL)
            ; col = 40 - 4*C + slot   (C = groups left 10..1, E = slot 0..3)
            MOV  A,C
            ADD  A
            ADD  A                  ; A = 4*C
            CMA                     ; A = -4C-1
            ADI  41                 ; A = 40-4C  (first column of this group)
            ADD  E                  ; + slot within the group
            STA  _phys_col
            PUSH B                  ; save row/group counters
            CALL _phys_handle       ; process this active cell
            POP  B                  ; restore counters
            LHLD _phys_ptr          ; restore ptr
            RET                     ; -> back into the unrolled scan
pp_endscan:
            ; --- Amoeba per-tick state rollover (C64: after ProcessCave scan) ---
            LDA  _amoeba_count_this_tick
            STA  _amoeba_count_prev_tick
            LDA  _amoeba_could_grow_this
            STA  _amoeba_could_grow_last
            XRA  A
            STA  _amoeba_count_this_tick
            STA  _amoeba_could_grow_this
            LDA  _game_tick
            INR  A
            STA  _game_tick
            ; --- Magic wall timer update (C64: HandleMagicWallState) ---
            LDA  _magic_wall_active
            CPI  1
            JNZ  pp_mw_done
            LDA  _magic_wall_timer
            INR  A
            STA  _magic_wall_timer
            CPI  08h                ; TICKS_PER_SEC ticks = 1 real second
            JNZ  pp_mw_done
            XRA  A
            STA  _magic_wall_timer
            LDA  _magic_wall_seconds
            INR  A
            STA  _magic_wall_seconds
            LXI  H,_magic_wall_milling_time
            CMP  M
            JNZ  pp_mw_done
            XRA  A
            STA  _magic_wall_active
            STA  _magic_wall_seconds
            STA  _magic_wall_timer
pp_mw_done:
            ; --- Time countdown (C64: SubSecondTick -> GameSecondTick) ---
            LXI  H,_time_subcounter
            INR  M
            MOV  A,M
            CPI  08h                ; TICKS_PER_SEC ticks = 1 real second
            JNZ  pp_tc_done
            MVI  M,0
            LDA  _time_remaining
            ORA  A
            JZ   pp_tc_done         ; already 0, stop
            DCR  A
            STA  _time_remaining
            LDA  _hud_dirty
            ORI  01h                ; HUD_DIRTY_TIME
            STA  _hud_dirty
pp_tc_done:
            ; --- Amoeba milling time (C64: GameSecondTickWithAmoebaProcessing) ---
            LXI  H,_amoeba_milling_time
            MOV  A,M
            ORA  A
            JZ   pp_am_done         ; already 0, skip
            DCR  M                   ; milling_time--
            JNZ  pp_am_done         ; not zero yet
            MVI  A,0x0F            ; time expired, speed up!  mask 0x7F->0x0F
            STA  _amoeba_growth_mask ; mask 0x7F->0x0F (3.1%->25%)
pp_am_done:
            RET
#endasm
}
#else
// Portable C fallback (identical algorithm, slower codegen).
void process_physics(void)
{
    int i;
    char col = 0;

    for (i = 40; i < 840; i++) {
        char obj = work_cave[i];

        if (obj == O_BOULDER_S) { work_cave[i] = O_BOULDER_F; goto next; }  // -> falling
        if (obj == O_DIAMOND_S) { work_cave[i] = O_DIAMOND_F; goto next; }  // -> falling
        if (obj == O_AMOEBA_S)  { work_cave[i] = O_AMOEBA_A;  goto next; }  // -> active
        if (obj >= O_BF_UP_S && obj <= O_BF_LEFT_S) { work_cave[i] = obj - 0x10; goto next; }
        if (obj >= O_FF_UP_S && obj <= O_FF_LEFT_S) { work_cave[i] = obj - 0x18; goto next; }

        if (obj >= O_EXPL_S1 && obj <= O_EXPL_S5) {
            work_cave[i] = (obj == O_EXPL_S5) ? O_EMPTY : obj + 1; goto next;
        }
        if (obj >= O_EXPL_D1 && obj <= O_EXPL_D5) {
            work_cave[i] = (obj == O_EXPL_D5) ? O_DIAMOND : obj + 1; goto next;
        }
        if (obj == O_AMOEBA_A)  { phys_i = i; phys_col = col; do_amoeba(); goto next; }
        if (obj >= O_BF_UP && obj <= O_BF_LEFT) { do_butterfly(i, col, obj); goto next; }
        if (obj >= O_FF_UP && obj <= O_FF_LEFT) { do_firefly(i, col, obj);   goto next; }
        if (obj == O_BOULDER)   { falling_tick(i, col, O_BOULDER, O_BOULDER_S, 0); goto next; }
        if (obj == O_BOULDER_F) { falling_tick(i, col, O_BOULDER, O_BOULDER_S, 1); goto next; }
        if (obj == O_DIAMOND)   { falling_tick(i, col, O_DIAMOND, O_DIAMOND_S, 0); goto next; }
        if (obj == O_DIAMOND_F) { falling_tick(i, col, O_DIAMOND, O_DIAMOND_S, 1); goto next; }

next:
        col++;
        if (col == 40) col = 0;
    }

    // Amoeba per-tick state rollover
    amoeba_count_prev_tick = amoeba_count_this_tick;
    amoeba_could_grow_last = amoeba_could_grow_this;
    amoeba_count_this_tick = 0;
    amoeba_could_grow_this = 0;

    game_tick++;

    // Magic wall timer update (C64: HandleMagicWallState)
    if (magic_wall_active == 1) {
        magic_wall_timer++;
        if (magic_wall_timer >= TICKS_PER_SEC) {
            magic_wall_timer = 0;
            magic_wall_seconds++;
            if (magic_wall_seconds >= magic_wall_milling_time) {
                magic_wall_active = 0;
                magic_wall_seconds = 0;
                magic_wall_timer = 0;
            }
        }
    }

    // Time countdown (C64: SubSecondTick -> GameSecondTick)
    time_subcounter++;
    if (time_subcounter >= TICKS_PER_SEC) {   // one real second
        time_subcounter = 0;
        if (time_remaining > 0) {
            time_remaining--;
            hud_dirty |= HUD_DIRTY_TIME;
        }
        }
        // Amoeba milling time (C64: GameSecondTickWithAmoebaProcessing)
        if (amoeba_milling_time > 0) {
            amoeba_milling_time--;
            if (amoeba_milling_time == 0) {
                amoeba_growth_mask = 0x0F;  // speed up! mask 0x7F->0x0F (3.1%->25%)
            }
        }
    }
}
#endif

// ============================================================
// lose_life (C64 LoseLife, $876e)
// Decrements lives. If lives reach 0, sets gameover_flag and resets
// lives to 3 for the next game (C64: "Since we only switch to a player
// that has a non-zero life count a count of zero means all players are dead.")
// ============================================================
void lose_life(void)
{
    if (lives > 0) {
        lives--;
        hud_dirty |= HUD_DIRTY_LIVES;
    }
    if (lives == 0) {
        gameover_flag = 1;
        lives = 3;          // reset for next game (C64: STA Lives after GameOverFlag=1)
    }
}

// ============================================================
// game_tick_step (C64: one scan-frame: ProcessRockford + ProcessCave)
//
// C64 death logic (RockfordDeadTicks / DeathClick):
//  1. When Rockford dies, his cell is replaced by explosion. game_over=1.
//  2. Physics keeps running (explosions animate, boulders fall).
//  3. rockford_dead_ticks increments each frame (caps at 16).
//  4. After 16 frames, pressing fire sets exit_cave_flag.
//  5. Main loop sees exit_cave_flag, calls lose_life(), then curtain.
// ============================================================
void game_tick_step(void)
{
    if (level_complete || exit_cave_flag) return;

    /* P=пауза (PA6/PB0), AP2=суицид (PA0/PB2). См. РК86_7.md §8. */
    if (!is_demo_mode) {
        if (!(key_scan(0xBF) & 0x01)) {
            sound_mute();
            draw_pause_hud();
            while (!(key_scan(0xBF) & 0x01)) waitVSync();
            for (;;) {
                waitVSync();
                if (!(key_scan(0xBF) & 0x01)) break;
            }
            while (!(key_scan(0xBF) & 0x01)) waitVSync();
            draw_hud();
        }
        if (!game_over && rockford_i >= 0 && !(key_scan(0xFE) & 0x04)) {
            explode_3x3(rockford_i, O_EXPL_S1);
            sound_event(SFX_EXPLODE);
            rockford_i = -1;
        }
    }

    // Rockford is walking into the exit - countdown, physics runs
    if (exit_enter_timer > 0) {
        exit_enter_timer--;
        process_physics();      // let physics finish (boulders fall, etc.)
        if (exit_enter_timer == 0) level_complete = 1;
        return;
    }

    process_rockford();   // reads input; if Rockford alive, resets game_over & dead_ticks

    // --- Idle animation update (C64: AnimateRockford, $782a) ---
    // When Rockford stands still (rockford_anim == 0), occasionally
    // blink and tap foot. Uses idle_tick counter to spread events evenly
    // instead of independent random triggers (which cause long dry spells
    // or chaotic clusters). Small randomness added for natural feel.
    if (!rockford_anim) {
        idle_tick++;

        // Blink: check every 8 ticks (1 sec), 50% chance → ~1 blink every 2 sec
        if (idle_blink_timer == 0 && (idle_tick & 0x07) == 0 && (random(0, 2) == 0)) {
            idle_blink_timer = 2;  // start 2-tick blink: morg1 → morg2 → done
        }
        if (idle_blink_timer > 0) {
            idle_blink_timer--;    // countdown each tick (2→1→0)
        }

        // Foot tap: 4-phase sequence triggered periodically
        // Phases: 3=ruki, 2=ruki_noga+click, 1=ruki, 0=ruki_noga+click
        // 3 ticks/phase → 12 ticks total → exactly 2 clicks ("цок-цок")
        if (idle_tap_timer == 0) {
            // Trigger: every ~6 sec (48 ticks), 50% chance
            if ((idle_tick % 48) == 0 && (random(0, 2) == 0)) {
                idle_tap_timer = 12;   // 4 phases × 3 ticks
                idle_tap_phase = 3;     // start: arms up
                idle_tap_counter = 0;
            }
        } else {
            idle_tap_timer--;
            idle_tap_counter++;
            if (idle_tap_counter >= 3) {
                idle_tap_counter = 0;
                idle_tap_phase--;       // next phase: 3→2→1→0
                // "цок" on phase 2 and 0 (foot comes down)
                if (idle_tap_phase == 2 || idle_tap_phase == 0) {
                    sound_tap();
                }
            }
        }
    } else {
        // Moving — clear all idle state (C64: STA $00 → __TapFootFlag, __BlinkFlag)
        idle_tick = 0;
        idle_blink_timer = 0;
        idle_tap_timer = 0;
        idle_tap_counter = 0;
        idle_tap_phase = 0;
    }
    update_idle_sprite();  // select the right idle sprite for sprites_anim()

    process_physics();    // always runs - explosions animate even after death

    if (game_over) {
        // Rockford is dead - count dead frames (C64: INC RockfordDeadTicks, cap at 16)
        if (rockford_dead_ticks < 16) {
            rockford_dead_ticks++;
        }
        // After 16 dead frames auto-restart OR fire button any time (C64: DeathClick)
        if (rockford_dead_ticks >= 16 || fire_pressed) {
            exit_cave_flag = 1;
        }
    }

    // Time expired - exit cave (C64: OutOfTimeLoop, then same as death)
    if (time_remaining == 0) {
        exit_cave_flag = 1;
    }
}


// ============================================================
void camera_follow_rockford(void)
{
    char tx = rockford_x - (WIN_W / 2);
    char ty = rockford_y - (WIN_H / 2);
    if (tx < 0) tx = 0;
    if (tx > MAP_X_MAX) tx = MAP_X_MAX;
    if (ty < 0) ty = 0;
    if (ty > MAP_Y_MAX) ty = MAP_Y_MAX;
    map_x = tx;
    map_y = ty;
}

// ============================================================
void init_game_for_cave(char cav)
{
    // Флаг «выход открыт» сбрасываем ДО start_cave(): въездной скролл
    // зовёт sprites_anim(), который иначе нарисует домик предыдущей пещеры.
    exit_open = 0;
    dia_quota_flash = 0;
    MapObj[8] = (unsigned char*)beton12x12;
    elementNumber = start_cave(cav);
    init_cave_objects(cav);
}
