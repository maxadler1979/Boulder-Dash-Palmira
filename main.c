#include <string.h>
#include <stdint.h>
#include "main.h"

uint8_t* VG75 = (uchar*)0xC000;
uint8_t* VT57 = (uchar*)0xE000;
volatile uint8_t* vv55 = (uint8_t*)0xc200;
volatile uchar* VV55 = (uchar*)0xC200;
uchar* TM9 =  (uchar*)0xCE00;
uchar* RU10 = (uchar*)0xd800;

uint8_t* radio86rkVideoMem = (uchar*)(SCREEN);
unsigned char *bmpadr;
unsigned char bitmap[0xccc+78+78];

char cave;
uint16_t GetRandFromSeed(uint16_t randVal)
{
	/* 16-битный Galois LFSR, примитивный полином x^16+x^15+x^13+x^4+1
	 * (маска 0xA010). Полный период 65535 — как у C64, без нуля.
	 * Амёба берёт младший байт: маска роста <= 0x7F, старший не нужен. */
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
     if(min >= max) {
        return min;
    }
    return min + GetRand() % (max - min);
}


void waitVSync() {
 #asm
    lxi h,0c001h
    mov a,m
waitHorzSync_1:
    mov a, m
    ani 20h
    jz waitHorzSync_1
  #endasm
}

// ============================================================
// Темп тика привязан к кадру ВГ75 (см. VSYNC_HZ / TICKS_PER_SEC в main.h).
//
// Раньше главный цикл крутился на полной скорости: пещера с валунами
// тикала медленнее пустой, а таймер считал тики, не секунды. Теперь
// каждому тику выдаётся бюджет кадровых импульсов, и tick_wait() держит
// его, пока бюджет не израсходован.
//
// Кадровые импульсы, прошедшие ВО ВРЕМЯ расчёта физики, после него уже
// не поймать — поэтому vsync_poll() встроен в циклы строк process_physics
// (20 раз/тик) и show_window (10 раз/тик). Интервал 1-2 мс при периоде
// кадра ~17 мс, ни один импульс не теряется.
//
// Если тик не уложился в бюджет (очень тяжёлая пещера), vs_left обнуляется
// раньше, tick_wait() сразу возвращается: игра замедляется, но ничего
// не пропускает и не «догоняет».
// ============================================================
unsigned char vs_left;          // vsyncs still owed for this tick
unsigned char vs_prev;          // frame-pulse level at the last sample
unsigned char vs_acc;           // remainder accumulator for VSYNC_HZ/TICKS_PER_SEC

// Edge-detect the VG75 frame pulse and spend one vsync of the budget.
// Preserves BC/DE/HL (it is called from the middle of the asm scan and
// render loops); clobbers A and flags only.
void vsync_poll(void) {
#asm
            PUSH H
            LXI  H,0c001h
            MOV  A,M
            ANI  20h                ; frame pulse level (0 or 20h)
            LXI  H,_vs_prev
            CMP  M
            JZ   vp_done            ; unchanged -> nothing to do
            MOV  M,A                ; remember the new level
            ORA  A
            JZ   vp_done            ; 1->0 edge -> not a new frame
            LXI  H,_vs_left
            MOV  A,M
            ORA  A
            JZ   vp_done            ; budget already spent
            DCR  M
vp_done:
            POP  H
#endasm
}

// Budget for this tick: VSYNC_HZ/TICKS_PER_SEC vsyncs, remainder carried
// over so the average is exact for any ratio (8/s -> 6,6,6,7).
void tick_begin(void) {
    unsigned char n = 0;
    vs_acc += VSYNC_HZ;
    while (vs_acc >= TICKS_PER_SEC) {
        vs_acc -= TICKS_PER_SEC;
        n++;
    }
    vs_left = n;
}

// Hold the tick until its vsync budget is spent.
//
// Safety net: if the VG75 frame-pulse bit turns out not to pulse on this
// machine, the budget would never be spent and every tick would stall on
// the guard. Three such ticks in a row and pacing switches itself off for
// good — the game then behaves exactly as it did before pacing existed
// (flat out), instead of crawling. A tick that simply overran its budget
// cannot trip this: it leaves vs_left at 0 and never enters the loop.
unsigned char vs_dead;      // 1 = no frame pulse here, pacing disabled
unsigned char vs_fails;

void tick_wait(void) {
    unsigned int guard;
    if (vs_dead) return;
    guard = 4000;            // ~3x the longest legitimate wait (7 vsyncs)
    while (vs_left && --guard) vsync_poll();
    if (vs_left) {
        vs_fails++;
        if (vs_fails >= 3) vs_dead = 1;
    }
    else vs_fails = 0;
}


void screen_setup(uint16_t adr,uint16_t length)
{
  VG75[1] = 0; //
  VG75[0] = 0x4d;//77; //
  VG75[0] = 0x2e; //2a
  VG75[0] = 0x7a; //7b
  VG75[0] = 0x58; //53; //
  VG75[1] = 0x27; //0x27; //
  while((VG75[1] & 0x20) == 0); //
  while((VG75[1] & 0x20) == 0); //
  VT57[8] = 0x80; //
  VT57[4] = (uint16_t) (adr); //
  VT57[4] = ((uint16_t)adr >> 8); // //
  VT57[5] = (uint16_t)((length)-1); //
  VT57[5] = 0x40 | (uint16_t)(((length)-1)>>8); //
  VT57[8] = 0xA4; //

}

uint8_t key_scan(uint8_t row) // ���������� ��� ������� �������
{
    uchar z = 0;
    vv55[0] = row;
    return vv55[1];
}

 uint8_t GetInput()
{
  uint8_t kb;
  kb=0xff;

//dig=key_scan(0xfb);//fb - 1(253)2(251)3(247)4(239)5(223)6(191)7(127)
 kb=key_scan(0x7e); //7e = f1 f2 f3 f4 f5 space y z x
   if (!(kb & 0x80)) //space
    {
        return KEY_space;
    }

 kb=key_scan(0xfd);
   if (!(kb & 0x04))  // 251 -> bit 2
    {
       return KEY_enter;
    }

   if (!(kb & 0x20))  // 223 -> bit 5
    {

        return KEY_up;
    }
   if (!(kb & 0x80))  // 127 -> bit 7
    {
       return KEY_down;
    }
   if (!(kb & 0x10))  // 239 -> bit 4
    {
      return KEY_left;
    }
   if (!(kb & 0x40))  // 191 -> bit 6
    {
        return KEY_right;
    }
	return kb;

}


void clear_chargen_ram(void)
{
int n;
 for (n=0;n<2048;n++)
 {
  RU10[n]=255;
 }
}

void set_pseudograph(void)
{
// Генерация 64 псевдографических символов (0-63) в знакогенератор RU10.
// Каждый символ: 3 группы по 4 байта, выбранные битами кода символа.
// Биты 0-1 -> байты 0-3, биты 2-3 -> байты 4-7, биты 4-5 -> байты 8-11.
// Значения: 00=0xFF, 01=0x0F, 10=0xF0, 11=0x00.
// После каждых 12 байт — 4 байта заполнения 0xFF.
const unsigned char vals[4] = {0xFF, 0x0F, 0xF0, 0x00};
int c, i, addr = 0;

for (c = 0; c < 64; c++)
{
	unsigned char a = vals[(c >> 0) & 3];
	unsigned char b = vals[(c >> 2) & 3];
	unsigned char v = vals[(c >> 4) & 3];

	for (i = 0; i < 4; i++) RU10[addr++] = a;
	for (i = 0; i < 4; i++) RU10[addr++] = b;
	for (i = 0; i < 4; i++) RU10[addr++] = v;
	for (i = 0; i < 4; i++) RU10[addr++] = 0xFF;
}
}

void copy_zg(void)
{
// Копирование шрифтовой части (символы 64-127) в знакогенератор RU10.
// Псевдографические символы 0-63 уже сгенерированы set_pseudograph().
int r;
char a;
int addr = 64 * 16; // начало символа 64 (каждый символ занимает 16 байт)

for (r = 0; r < 768; r += 12) // 64 символа по 12 байт (768 байт)
{
	for (a = 0; a < 12; a++)
	{
		RU10[addr++] = zg8x12[r + a];
	}
	addr += 4; // 4 байта заполнения (уже заполнены 0xFF из clear_chargen_ram)
}
}


void pause(void)
{
int a=400;
while(a>0) a--;
}


char map_x,map_y;
unsigned char *spr_addr;
unsigned char *xy_addr;


void stick_map(void)
{
uint8_t kb;
kb = key_scan(0xfd);


   if (!(kb & 0x20))  // 223 -> bit 5
    {
     move_camera_up();

        //KEY_up;
    }
   if (!(kb & 0x80))  // 127 -> bit 7
    {
     move_camera_down();

       //KEY_down;
    }
   if (!(kb & 0x10))  // 239 -> bit 4
    {
     move_camera_left();

      //KEY_left;
    }
   if (!(kb & 0x40))  // 191 -> bit 6
    {
      move_camera_right();

        //KEY_right;
    }
}


// ============================================================
// HUD dirty flags (set by game_logic when values change)
// ============================================================
unsigned char hud_dirty;

// Globals for fast ASM sprite-area clear
unsigned char csr_x, csr_y, csr_len;

static void clear_sprite_row_asm(void) {
#asm
    ; Compute screen address = video_base + sm_y[y] + x
    ; Step 1: Read sm_y[y] value
    LXI  H,_sm_y      ; HL = &sm_y[0]
    LDA  _csr_y
    ADD  A            ; y*2 (16-bit table)
    MOV  E,A
    MVI  D,0
    DAD  D            ; HL = &sm_y[y]
    MOV  E,M
    INX  H
    MOV  D,M          ; DE = sm_y[y] = y*78
    ; Step 2: Add video base
    LHLD _radio86rkVideoMem
    DAD  D            ; HL = base + y*78
    ; Step 3: Add x
    LDA  _csr_x
    MOV  E,A
    MVI  D,0
    DAD  D            ; HL = base + y*78 + x
    ; Now clear 3 rows × len bytes
    LDA  _csr_len
    MOV  C,A          ; C = len
    MVI  B,3          ; B = 3 rows (sprite height in char rows)
csr_lp:
    PUSH H
    MOV  E,C
csr_ilp:
    MVI  M,0
    INX  H
    DCR  E
    JNZ  csr_ilp
    POP  H
    LXI  D,78
    DAD  D
    DCR  B
    JNZ  csr_lp
    RET
#endasm
}

static void clear_sprite_row(unsigned char x, unsigned char y, unsigned char len) {
    csr_x = x; csr_y = y; csr_len = len;
    clear_sprite_row_asm();
}

// ============================================================
// ASM digit extraction — fast subtraction loops (no division).
// Output: sbd_digits[0..2] = hundreds,tens,ones; sbd_count = 1..3
// ============================================================
unsigned char sbd_val, sbd_count;
unsigned char sbd_digits[3];

static void extract_digits_asm(void) {
#asm
    LDA  _sbd_val
    ORA  A
    JZ   eda_zero

    ; Extract hundreds
    MVI  B,0
eda_h_lp:
    CPI  100
    JC   eda_h_done
    SUI  100
    INR  B
    JMP  eda_h_lp
eda_h_done:
    ; Extract tens from remainder
    MOV  D,A
    MVI  E,0
eda_t_lp:
    MOV  A,D
    CPI  10
    JC   eda_t_done
    SUI  10
    MOV  D,A
    INR  E
    JMP  eda_t_lp
eda_t_done:
    ; Store: B=hundreds, E=tens, D=ones
    LXI  H,_sbd_digits
    MOV  M,B
    INX  H
    MOV  M,E
    INX  H
    MOV  M,D
    ; Set count
    MOV  A,B
    ORA  A
    JNZ  eda_cnt3
    MOV  A,E
    ORA  A
    JNZ  eda_cnt2
    MVI  A,1
    STA  _sbd_count
    RET
eda_cnt2:
    MVI  A,2
    STA  _sbd_count
    RET
eda_cnt3:
    MVI  A,3
    STA  _sbd_count
    RET
eda_zero:
    XRA  A
    STA  _sbd_digits
    STA  _sbd_digits+1
    STA  _sbd_digits+2
    MVI  A,1
    STA  _sbd_count
#endasm
}

// Fast digit render: ASM extraction + put_sprite for each digit
static void hud_dig(unsigned char x, unsigned char y, unsigned char val) {
    unsigned char i, start;
    sbd_val = val;
    extract_digits_asm();
    // Skip leading zeros: start = 3 - sbd_count
    start = 3 - sbd_count;
    for (i = start; i < 3; i++) {
        put_sprite(x, y, Digits[sbd_digits[i]]);
        x += 4;
    }
}

// ============================================================
// The middle HUD field, x = 24..53, does double duty: normally the
// diamond count, but for SCORE_SHOW_TICKS ticks after the score moves it
// shows the score instead.  There is no room on 78 columns for both, and
// the score is only interesting the moment it changes.
//
//   diamonds: D at 24, collected at 30, needed at 44   (ends at 50)
//   score:    six digits at 24                          (ends at 46)
//
// The quota sits at 44, not 42: cave I holds 178 diamonds, and a
// three-digit count runs to x=40, which butted straight up against the
// quota and read as one number ("D 17875").
// ============================================================
#define HUD_MID_X    24
#define HUD_MID_LEN  30

static void hud_score(unsigned char x, unsigned char y) {
    unsigned char i;
    for (i = 0; i < 6; i++) {          // leading zeros kept, as on the C64
        put_sprite(x, y, Digits[score_digits[i]]);
        x += 4;
    }
}

static void hud_mid_field(void) {
    clear_sprite_row(HUD_MID_X, 0, HUD_MID_LEN);
    if (score_flash) {
        hud_score(HUD_MID_X, 0);
    } else {
        printf_letters(HUD_MID_X, 0, "D");
        hud_dig(30, 0, diamonds_collected);
        hud_dig(44, 0, diamonds_needed);
    }
}

// ============================================================
// draw_hud: full HUD redraw (called once at cave start).
// Layout: T150  D12/15  L3
// ============================================================
void draw_hud(void) {
    clear_sprite_row(2, 0, 76);  // shifted +2 right
    printf_letters(2, 0, "T");
    hud_dig(8, 0, time_remaining);
    hud_mid_field();
    printf_letters(54, 0, "L");
    hud_dig(60, 0, lives);
    hud_dirty = 0;
}

// ============================================================
// update_hud: incremental redraw — only dirty regions.
// ============================================================
void update_hud(void) {
    // Score display runs down on the HUD clock, not the game clock, so it
    // has to be aged before the early-out below.
    if (score_flash) {
        score_flash--;
        if (score_flash == 0) hud_dirty |= HUD_DIRTY_DIAMONDS;  // back to diamonds
    }
    if (!hud_dirty) return;
    if (hud_dirty & HUD_DIRTY_TIME) {
        clear_sprite_row(8, 0, 12);
        hud_dig(8, 0, time_remaining);
    }
    if (hud_dirty & HUD_DIRTY_DIAMONDS) {
        hud_mid_field();
    }
    if (hud_dirty & HUD_DIRTY_LIVES) {
        clear_sprite_row(60, 0, 4);
        hud_dig(60, 0, lives);
    }
    hud_dirty = 0;
}

// ============================================================
// score_time_bonus (C64 CaveComplete, $8859)
//
// When a cave is finished the clock is run down one second at a time and
// each second is worth Level+1 points.  Level is the 1..5 difficulty from
// the C64 title screen; we only ever play sublevel 1, so it is 1 point a
// second.  One vsync per point matches the C64 pace (~16 ms), and the
// blip walks down a scale the way ScoreTimeRemainingSound sweeps voice 3.
//
// score_add() re-arms score_flash on every point, so the middle field
// stays on the score for the whole count and does not flip back to the
// diamonds half way through.
// ============================================================
static void score_time_bonus(void) {
    unsigned char phase = 0;
    while (time_remaining > 0) {
        waitVSync();            // redraw straight after the frame pulse: the
                                // HUD sits on the first rows the CRT fetches,
                                // and clearing it mid-frame tears the digits
        time_remaining--;
        score_add(1);
        hud_dirty |= HUD_DIRTY_TIME;
        update_hud();
        sound_score_tick(phase++);
    }
    sound_mute();
    score_flash = SCORE_SHOW_TICKS;   // hold the total up through the curtain
}

void main() {


clrscr();
screen_setup (0xA600,0xe52);//ccc+78
create_table();

clear_chargen_ram();
TM9[0] = 0x80;

set_pseudograph();
copy_zg();
TM9[0] = 0xe0;

// Opening sequence: steel wall -> PALMIRA credits -> Claude logo -> title.
// SPACE means "take me to the title", so a skip in the intro skips the rest.
if (!show_palmira_intro()) show_claude_logo();
show_title();
lives = 3; score_reset();   // fresh game (the demo shares these globals)
get_sprites_adresses_from_mass();// ������ ���������� ������ (�������� �������� ������� ��������)
init_empt_spark_anim();         // runtime init for extern sprite pointers
			  clrscr();
map_x=0;
map_y=0;


while(1)
{
 init_game_for_cave(cave);
 invalidate_window();
 calculateWindowCenter();
 sound_game_init();
			  draw_hud();
  sprites_anim();  // reset MapObj sprites for new level (exit_open now 0, etc.)

 while(1)
 {
  tick_begin();                // fixed-rate pacing: TICKS_PER_SEC ticks/second
  game_tick_step();
  camera_follow_rockford();
  show_window();
			  update_hud();
  sprites_anim();
  sound_update();
  tick_wait();                 // hold the tick to its vsync budget
  if (level_complete) break;
  if (exit_cave_flag) break;   // death+fire or timeout (C64 DeathClick / OutOfTime)
 }

 sound_mute();

 // --- Curtain helper: steel walls close in from edges (C64: CoverLevel) ---
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
 	// Level finished — advance to next cave (C64: PostRunCaveActions -> next level)
 	score_time_bonus();   // C64 CaveComplete: 1 point per second left on the clock
 	do_curtain();
 	cave++;
 	if (cave >= 20) cave = 0;
 	continue;
 }

 if (exit_cave_flag) {
 	// Rockford died or time ran out — lose a life (C64: LoseLife)
 	lose_life();
 	do_curtain();

 	if (gameover_flag) {
 		// No lives left — GAME OVER (C64: SetTopLineTextToGameOverAndDelay)
 		{ int d; for (d = 0; d < 1200; d++) { int x = d; (void)x; } }
 		score_end_game();   // stash as last score, beat the high score if it can
 		show_title();
 		get_sprites_adresses_from_mass();
		init_empt_spark_anim();
 		clrscr();
 		map_x = 0; map_y = 0;
	 	// cave is set by player in show_title() — don't override
 		lives = 3;
 		gameover_flag = 0;
 		score_reset();
 		continue;
 	}
 	// Lives remain — restart same cave (C64: restart level after death)
 	continue;
 }
}

}
