#include <string.h>
#include <stdint.h>
#include "main.h"

/*
 * labirint.c — рендер окна WIN_W x WIN_H (11x8) клеток.
 *
 * MapObj[код] -> спрайт 6x4 знакоместа. sprites_anim() каждый тик переписывает
 * указатели анимированных кодов. show_window() сравнивает клетку карты
 * с теневым массивом shadow[WIN_CELLS] и блитует только изменившиеся
 * (для анимированных shadow хранит 0xFF — «всегда грязная»).
 */

unsigned int stacksave2;
uint8_t restore;
uint8_t lab_x;
uint8_t lab_y;
uint8_t lab_pointer;
uint8_t beton_pointer;
void put_sbitmap(void);
void copy_sprites_from_cave(void);
void fill_start_screen(void);
void restore_start_screen(void);


unsigned char sdvig = 0;


int string_y[22]= {
0,40,80,120,160,200,240,280,320,360,
400,440,480,520,560,600,640,680,720,760,800,840};


char start_scr[121];

/*
 * MapObj[код_объекта] — указатель на спрайт 12x12.
 * Индекс = байт work_cave. sprites_anim() каждый тик переписывает
 * слоты анимированных объектов (алмаз, критеры, амёба, выход, Rockford),
 * поэтому dirty-рендер помечает их 0xFF в shadow[] и всегда перерисовывает.
 */
unsigned char *MapObj[45] =
{
 empt,    // 00 empty
 beton,   // 01 steel wall
 dirt,    // 02 dirt
 brik,    // 03 brick wall
 rock,    // 04 boulder
 m0,      // 05 firefly base
 d0,      // 06 diamond
 b1,      // 07 butterfly base
 s_beton, // 08 exit
 stay,    // 09 inbox
 am_1,    // 0A amoeba
 magic_wall_active1_12x12, // 0B magic wall
 rock,    // 0C boulder_F (unused)
 d0,      // 0D diamond_F (unused)
 rock,    // 0E BOULDER_S (scanned stationary)
 d0,      // 0F DIAMOND_S (scanned stationary)
 m0,      // 10 FF_UP
 m0,      // 11 FF_RIGHT
 m0,      // 12 FF_DOWN
 m0,      // 13 FF_LEFT
 b1,      // 14 BF_UP
 b1,      // 15 BF_RIGHT
 b1,      // 16 BF_DOWN
 b1,      // 17 BF_LEFT
 epl_1,   // 18 EXPL_S1
 epl_2,   // 19 EXPL_S2
 epl_3,   // 1A EXPL_S3
 epl_1,   // 1B EXPL_S4
 epl_2,   // 1C EXPL_S5
 epl_1,   // 1D EXPL_D1
 epl_2,   // 1E EXPL_D2
 epl_3,   // 1F EXPL_D3
 epl_1,   // 20 EXPL_D4
 epl_2,   // 21 EXPL_D5
 stay,    // 22 rockford
 am_1,    // 23 amoeba_A
 b1,      // 24 BF_UP_S (scanned)
 b1,      // 25 BF_RIGHT_S
 b1,      // 26 BF_DOWN_S
 b1,      // 27 BF_LEFT_S
 m0,      // 28 FF_UP_S (scanned)
 m0,      // 29 FF_RIGHT_S
 m0,      // 2A FF_DOWN_S
 m0,      // 2B FF_LEFT_S
 am_1,    // 2C AMOEBA_S (scanned)
};

// Extra-life sparkle frames, indexed by spr_pointer (the same 0-3 counter
// the amoeba/butterfly animations run on).
// Initialised at runtime (zcc cannot fold extern addresses as constant
// expressions for a global initialiser).
unsigned char *EmptSparkAnim[4];

void init_empt_spark_anim(void)
{
    EmptSparkAnim[0] = (unsigned char*)muar1;
    EmptSparkAnim[1] = (unsigned char*)muar2;
    EmptSparkAnim[2] = (unsigned char*)muar3;
    EmptSparkAnim[3] = (unsigned char*)muar4;
}

uint8_t map_offsety;
uint8_t map_offsetx;
uint16_t screen_adresses[WIN_CELLS];
char i,j;
int lab_ptr;
uint8_t lab_adr;
uint8_t map_adr;
uint8_t stuff1;
uint8_t i_pointer;
uint8_t stuff2;
uint8_t j_pointer;
int dimond_pointer=0;
int spr_pointer=0;



// ============================================================
// sprites_anim: переставить указатели анимированных слотов MapObj[].
// Кадр выбирается один раз, пишется SHLD (16 тактов) вместо присваивания
// массива на C (~40 тактов) — 26 записей на тик.
// Слот MapObj[k] лежит по адресу _MapObj+2*k.
// ============================================================
void sprites_anim(void)
{
#asm
            ; ---------- exit (08) ----------
            LDA  _exit_open
            ORA  A
            JZ   sa_exit_closed
            LDA  _game_tick
            ANI  02h                ; open exit blinks with bit 1 of the tick
            JZ   sa_exit_ajar
            LXI  H,_domik12x12
            JMP  sa_exit_set
sa_exit_ajar:
            LXI  H,_domik2_12x12
            JMP  sa_exit_set
sa_exit_closed:
            LXI  H,_beton12x12
sa_exit_set:
            SHLD _MapObj+16         ; MapObj[0x08]
            ; ---------- diamond (06, 0D) : 9 frames ----------
            LDA  _dimond_pointer
            ADD  A
            MOV  E,A
            MVI  D,0
            LXI  H,_DimondAnim
            DAD  D
            MOV  A,M
            INX  H
            MOV  H,M
            MOV  L,A                ; HL = DimondAnim[dimond_pointer]
            SHLD _MapObj+12         ; MapObj[0x06]
            SHLD _MapObj+26         ; MapObj[0x0D] falling diamond
            ; ---------- DE = spr_pointer*2 (shared by the 4-frame anims) ----------
            LDA  _spr_pointer
            ADD  A
            MOV  E,A
            MVI  D,0
            ; ---------- butterfly (07, 14-17, 24-27) ----------
            LXI  H,_ButterAnim
            DAD  D
            MOV  A,M
            INX  H
            MOV  H,M
            MOV  L,A
            SHLD _MapObj+14         ; 0x07
            SHLD _MapObj+40         ; 0x14
            SHLD _MapObj+42         ; 0x15
            SHLD _MapObj+44         ; 0x16
            SHLD _MapObj+46         ; 0x17
            SHLD _MapObj+72         ; 0x24 scanned
            SHLD _MapObj+74         ; 0x25
            SHLD _MapObj+76         ; 0x26
            SHLD _MapObj+78         ; 0x27
            ; ---------- firefly (05, 10-13, 28-2B) ----------
            LXI  H,_FireflyAnim
            DAD  D
            MOV  A,M
            INX  H
            MOV  H,M
            MOV  L,A
            SHLD _MapObj+10         ; 0x05
            SHLD _MapObj+32         ; 0x10
            SHLD _MapObj+34         ; 0x11
            SHLD _MapObj+36         ; 0x12
            SHLD _MapObj+38         ; 0x13
            SHLD _MapObj+80         ; 0x28 scanned
            SHLD _MapObj+82         ; 0x29
            SHLD _MapObj+84         ; 0x2A
            SHLD _MapObj+86         ; 0x2B
            ; ---------- amoeba (0A, 23, 2C) ----------
            LXI  H,_AmoebaAnim
            DAD  D
            MOV  A,M
            INX  H
            MOV  H,M
            MOV  L,A
            SHLD _MapObj+20         ; 0x0A
            SHLD _MapObj+70         ; 0x23 active
            SHLD _MapObj+88         ; 0x2C scanned
            ; ---------- magic wall (0B) ----------
            LDA  _magic_wall_active
            ORA  A
            JZ   sa_mw_off
            LXI  H,_MagicWallAnim
            DAD  D
            MOV  A,M
            INX  H
            MOV  H,M
            MOV  L,A
            JMP  sa_mw_set
sa_mw_off:
            LXI  H,_brik
sa_mw_set:
            SHLD _MapObj+22         ; 0x0B
            ; ---------- rockford (22) ----------
            LDA  _rockford_anim
            ORA  A
            JZ   sa_rf_stay
            DCR  A
            ADD  A                  ; (rockford_anim-1)*2
            MOV  E,A
            MVI  D,0
            LDA  _rockford_dir
            CPI  03h
            JZ   sa_rf_left
            LXI  H,_Rockford_right
            JMP  sa_rf_get
sa_rf_left:
            LXI  H,_Rockford_left
sa_rf_get:
            DAD  D
            MOV  A,M
            INX  H
            MOV  H,M
            MOV  L,A
            JMP  sa_rf_set
sa_rf_stay:
            LHLD _idle_sprite_ptr
sa_rf_set:
            SHLD _MapObj+68         ; 0x22
            ; ---------- advance frame counters ----------
            LXI  H,_dimond_pointer
            INR  M
            MOV  A,M
            CPI  06h
            JNZ  sa_dp_ok
            MVI  M,0
sa_dp_ok:
            LXI  H,_spr_pointer
            INR  M
            MOV  A,M
            CPI  04h
            JNZ  sa_sp_ok
            MVI  M,0
sa_sp_ok:
            ; ---------- extra-life sparkle: cycle MapObj[0] (empty) ----------
            ; C64 ExtraLifeFX (7454h) shoves random bytes into two pixel lines
            ; of the space character for 128 frames so the whole background
            ; glitters.  The generator cannot be rewritten per frame here, so
            ; four pre-drawn empty tiles are cycled instead.
            LDA  _extra_life_fx
            ORA  A
            JZ   sa_spark_done
            DCR  A
            STA  _extra_life_fx
            JZ   sa_spark_off       ; last tick: put the plain tile back
            LDA  _spr_pointer       ; 0-3, already advanced above
            ADD  A
            MOV  E,A
            MVI  D,0
            LXI  H,_EmptSparkAnim
            DAD  D
            MOV  A,M
            INX  H
            MOV  H,M
            MOV  L,A                ; HL = EmptSparkAnim[spr_pointer]
            JMP  sa_spark_set
sa_spark_off:
            LXI  H,_empt
sa_spark_set:
            SHLD _MapObj            ; MapObj[0x00]
            CALL _invalidate_window
sa_spark_done:
            ; The quota flash runs after the sparkle on purpose: if both are
            ; live the flash is the more urgent signal and wins the tile.
            ; ---------- diamond-quota flash: invert MapObj[0] (empty) ----------
            LDA  _dia_quota_flash
            ORA  A
            JZ   sa_flash_done
            DCR  A
            STA  _dia_quota_flash
            ANI  01h                ; toggle every other tick
            JZ   sa_flash_empt
            LXI  H,_empt_inv        ; white block (all 0x3F)
            JMP  sa_flash_set
sa_flash_empt:
            LXI  H,_empt            ; normal empty (all 0x00)
sa_flash_set:
            SHLD _MapObj            ; MapObj[0x00]
            CALL _invalidate_window ; force redraw: shadow[] would not see the tile change
sa_flash_done:
#endasm
}
/*

void show_window_in_c(uint8_t map_offsetx,uint8_t map_offsety)
{
 lab_adr = 0;
 for(i=0;i<10;i++)
  {
    lab_ptr = map_offsetx + string_y[map_offsety++];
    for(j=0;j<12;j++)
    {
     spr_addr = MapObj[work_cave[lab_ptr++]]; // �������� ����� ������� ������ �� �������� �������� �����
     xy_addr = screen_adresses[lab_adr++];  // ������� ������� ����������� ���������� ������� �� ������� �� ������ �������� � ����
     put_sbitmap(); // ����� ������� �� �����
    }
  }
}
*/

/*
full = 5 - ������ �� ������� � ������� ������
AC = 4
���������� sdvig = 
5 - � = full  B = full C = full 
4 - � = sdvig B = full C = AC - sdvig 
3 - A = sdvig B = full C = AC - sdvig
2 - A = sdvig B = full C = AC - sdvig
1 - A = sdvig B = full C = AC - sdvig
0 - A = sdvig B = full C = AC - sdvig
 
*/


// ============================================================
// Dirty-cell рендер окна 11x8 (WIN_W x WIN_H).
//
// shadow[слот] хранит код объекта, который последний раз нарисовали
// в эту клетку окна, либо 0xFF, если спрайт переписывается каждый кадр
// (алмаз, критеры, амёба, Rockford, открытый выход...). Кода 0xFF
// в карте не бывает, сравнение никогда не совпадёт — клетка всегда
// грязная. Это тот же тест «указатель спрайта изменился», но на одном
// байте вместо двух и без выборки MapObj[] на пути пропуска.
//
// anim_code[код] — что писать в shadow: сам код для статики, 0xFF для аним.
//
// Горячий цикл без указателей в памяти:
//   BC = &work_cave[клетка]   HL = &shadow[слот]   DE = &screen_adresses[слот]
// 11 колонок развёрнуты, шаг строки cave += 29 (40-11), sw_blit сохраняет BC/DE/HL.
// ============================================================
#define RENDER_DIRTY 1

unsigned char shadow[WIN_CELLS];

// Shadow value per object code: 0xFF = "sprite re-pointed by sprites_anim
// every frame -> always redraw", otherwise the code itself.
// Must list exactly the MapObj[] entries written by sprites_anim().
unsigned char anim_code[45] = {
    0x00,0x01,0x02,0x03,0x04, 0xFF,0xFF,0xFF,0xFF, 0x09,  // 00-09 (05 ff,06 dia,07 bf,08 exit)
    0xFF,0xFF,                                            // 0A amoeba, 0B magic
    0x0C,0xFF,                                            // 0C boulder_F, 0D diamond_F(anim)
    0x0E,0x0F,                                            // 0E/0F scanned boulder/diamond
    0xFF,0xFF,0xFF,0xFF,                                  // 10-13 firefly
    0xFF,0xFF,0xFF,0xFF,                                  // 14-17 butterfly
    0x18,0x19,0x1A,0x1B,0x1C,                             // 18-1C explosion -> space
    0x1D,0x1E,0x1F,0x20,0x21,                             // 1D-21 explosion -> diamond
    0xFF,                                                 // 22 rockford
    0xFF,                                                 // 23 amoeba active
    0xFF,0xFF,0xFF,0xFF,                                  // 24-27 butterfly scanned
    0xFF,0xFF,0xFF,0xFF,                                  // 28-2B firefly scanned
    0xFF                                                  // 2C amoeba scanned
};

void invalidate_window(void)
{
#asm
            LXI  H,_shadow
            MVI  B,88               ; WIN_CELLS
iw_lp:      MVI  M,0ffh
            INX  H
            DCR  B
            JNZ  iw_lp
#endasm
}

#if RENDER_DIRTY
void show_window(void)
{
#asm
            ; ---- BC = &work_cave[map_y*40 + map_x] ----
            LDA  _map_y
            ADD  A                  ; y*2 (string_y is int[])
            MOV  E,A
            MVI  D,0
            LXI  H,_string_y
            DAD  D
            MOV  E,M
            INX  H
            MOV  D,M                ; DE = string_y[y] = y*40
            LXI  H,_work_cave
            DAD  D
            LDA  _map_x
            MOV  E,A
            MVI  D,0
            DAD  D                  ; HL = work_cave + y*40 + map_x
            MOV  B,H
            MOV  C,L                ; BC = cave ptr
            LXI  D,_screen_adresses ; DE = screen address table
            LXI  H,_shadow          ; HL = shadow
            MVI  A,8
            STA  sw_row
sw_rowlp:
            ; --- timebase: one frame-pulse sample per row (see vsync_poll()
            ;     in main.c).  BC/DE/HL preserved, only A and flags used. ---
            PUSH H
            LXI  H,0c001h
            MOV  A,M
            ANI  20h
            LXI  H,_vs_prev
            CMP  M
            JZ   svp_done
            MOV  M,A
            ORA  A
            JZ   svp_done
            LXI  H,_vs_left
            MOV  A,M
            ORA  A
            JZ   svp_done
            DCR  M
svp_done:
            POP  H
            ; ---- 11 columns, fully unrolled (WIN_W) ----
            LDAX B
            INX  B
            CMP  M
            JZ   sw_k1
            CALL sw_blit
sw_k1:
            INX  H
            INX  D
            INX  D

            LDAX B
            INX  B
            CMP  M
            JZ   sw_k2
            CALL sw_blit
sw_k2:
            INX  H
            INX  D
            INX  D

            LDAX B
            INX  B
            CMP  M
            JZ   sw_k3
            CALL sw_blit
sw_k3:
            INX  H
            INX  D
            INX  D

            LDAX B
            INX  B
            CMP  M
            JZ   sw_k4
            CALL sw_blit
sw_k4:
            INX  H
            INX  D
            INX  D

            LDAX B
            INX  B
            CMP  M
            JZ   sw_k5
            CALL sw_blit
sw_k5:
            INX  H
            INX  D
            INX  D

            LDAX B
            INX  B
            CMP  M
            JZ   sw_k6
            CALL sw_blit
sw_k6:
            INX  H
            INX  D
            INX  D

            LDAX B
            INX  B
            CMP  M
            JZ   sw_k7
            CALL sw_blit
sw_k7:
            INX  H
            INX  D
            INX  D

            LDAX B
            INX  B
            CMP  M
            JZ   sw_k8
            CALL sw_blit
sw_k8:
            INX  H
            INX  D
            INX  D

            LDAX B
            INX  B
            CMP  M
            JZ   sw_k9
            CALL sw_blit
sw_k9:
            INX  H
            INX  D
            INX  D

            LDAX B
            INX  B
            CMP  M
            JZ   sw_k10
            CALL sw_blit
sw_k10:
            INX  H
            INX  D
            INX  D

            LDAX B
            INX  B
            CMP  M
            JZ   sw_k11
            CALL sw_blit
sw_k11:
            INX  H
            INX  D
            INX  D
            ; ---- next map row: cave ptr += 40-11 = 29 ----
            MOV  A,C
            ADI  29
            MOV  C,A
            JNC  sw_nocy
            INR  B
sw_nocy:
            LDA  sw_row
            DCR  A
            STA  sw_row
            JNZ  sw_rowlp
            RET

; ------------------------------------------------------------
; sw_blit: slot content changed -> refresh shadow + blit sprite.
;   in : A = object code, HL = &shadow[slot],
;        DE = &screen_adresses[slot], BC = cave ptr
;   out: BC/DE/HL unchanged (A, flags clobbered)
; ------------------------------------------------------------
sw_blit:
            SHLD sw_sha             ; save shadow ptr
            PUSH B                  ; save cave ptr
            PUSH D                  ; save screen-table ptr
            MOV  C,A
            MVI  B,0                ; BC = code
            LXI  H,_anim_code
            DAD  B
            MOV  A,M                ; A = anim_code[code]
            LHLD sw_sha
            MOV  M,A                ; shadow[slot] = anim_code[code]
            XCHG                    ; HL = &screen_adresses[slot]
            MOV  E,M
            INX  H
            MOV  D,M                ; DE = screen destination
            XCHG                    ; HL = screen destination
            SHLD sw_dst
            MOV  A,C
            ADD  A
            MOV  C,A                ; BC = code*2 (B still 0)
            LXI  H,_MapObj
            DAD  B
            MOV  E,M
            INX  H
            MOV  D,M                ; DE = MapObj[code] = sprite ptr
            LXI  H,0
            DAD  SP
            SHLD sw_sp              ; save real SP
            XCHG                    ; HL = sprite ptr
            SPHL                    ; SP -> sprite data
            LHLD sw_dst             ; HL = screen destination
            LXI  D,73               ; row stride (78 - 5)
            ; --- 4 rows x 6 bytes, fully unrolled ---
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
            DAD  D

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
            DAD  D

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
            DAD  D

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
            ; --- restore ---
            LHLD sw_sp
            SPHL                    ; restore real SP
            POP  D                  ; screen-table ptr
            POP  B                  ; cave ptr
            LHLD sw_sha             ; shadow ptr
            RET
sw_row:     defb 0
sw_sha:     defw 0
sw_dst:     defw 0
sw_sp:      defw 0
#endasm
}
#else
void show_window()
{

 map_offsety = map_y;
 map_offsetx = map_x;

    #asm
            xra a
            sta _lab_adr // ��������� ������� ������. �� ���� ����������� ����� ������� �����  
            mvi a,10        // 10 �����
            sta _i_pointer; //���� �� ���������� �����
i_label:
            lda _map_offsety; // �������� �� ����� y ���������
            add a
            LXI H, _string_y // �������� � HL ������ ������� � ������������ ������� ���������� �� ������� ��������� (22 �����)
            ADD L
            MOV L,A
            MOV E,M
            INX H
            MOV D,M
            lda _map_offsetx // �������� �� ����� � ���������
            MOV L,A
            MVI H,0
            DAD D
            xchg
            lhld _string_y
            dad d
            xchg
            SHLD _lab_ptr // lab_ptr = map_offsetx + string_y[map_offsety++]; ����� ������ ������ ���� �����
            lda _map_offsety;
            inc a
            sta _map_offsety // ��������� �� 1 �������� �� Y
// ����� ������������ ������ �� 12�� ��������� 

            LXI  H,0
            DAD  SP
            SHLD  _stacksave2 // ��������� ����

            call repair_sprite
            call full_addr 
            LDA _sdvig
            call show_left

            LHLD  _stacksave2
            SPHL 

            mvi a,10        // 10 средних колонок (всего 1+10+1=12 спрайтов на ряд)
            sta _j_pointer; //���� �� ������
j_label:
            

            call repair_sprite
            call sub_addr

            LXI  H,0
            DAD  SP
            SHLD  _stacksave2 // ��������� ����
            mvi a,0
            call show_left

            LHLD  _stacksave2
            SPHL

            // ����� �� ��������� ������ � ������
            lda _j_pointer
            dcr a               // �������� ������� ������ �� � (12)
            sta _j_pointer
            jnz j_label
// �������� ��������� ������ � ������
            

            call repair_sprite
            call sub_addr
            LXI  H,0
            DAD  SP
            SHLD  _stacksave2 // ��������� ����
            mvi a,0
            call show_left     ; ������ ������ (������ 6 �������) ����� show_right,
                                ; ����� ������ ��� ��������� ������, � �� 6 ��������
                                ; ������ � sdvig �������� �� ������ ����
           
             LHLD  _stacksave2
            SPHL

            ; --- �������������� ���������� ������ ��� �������� ������ ---
            LDA _sdvig
            CPI 0
            JZ skip_extra_col   ; ���� sdvig=0, ������ ���

            call repair_sprite  ; ��������� ������ map_x+12

            LHLD scrad          ; ����� ����� ��������� �������
            LXI D, 6
            DAD D               ; scrad + 6 = ����� ��� ��������������� ������
            SHLD scrad

            LXI H,0
            DAD SP
            SHLD _stacksave2    ; ��������� SP
            LDA _sdvig
            call show_right     ; ��������� ������ sdvig ���� ������ �������
            LHLD _stacksave2
            SPHL

skip_extra_col:
            ; --- ����� ��������������� ������ ---

            // �� ��� �� ��������� ��������� ������

            lda _i_pointer
            dcr a               // �������� ������� ����� (10)
            sta _i_pointer
            jnz i_label
            ret
ac:
            defb 4
xc:
            defb 5
#endasm
}
#endif

void rep_sprite(void)
{
 #asm
repair_sprite:
     // ���������� ������ ������� � ����������� ��� � ����
            LXI D,_work_cave // �������� � DE ����� �������� ����
            LHLD _lab_ptr   // � HL �������� ����
            DAD D
            MOV E,M
            INX H
            MOV D,M
            XCHG
            SHLD _map_adr // ����� ������� ����� �������� ���� � ������� ����
             
            LHLD _lab_ptr
            INX H
            SHLD _lab_ptr // ��������� ��������� �������� �� 1

            //------------ ��������� ����� ������ �������� �� �������� ����� ���� �����
            LXI h,_MapObj;// ����� �������� + 24 �������� (������ ������ �������� 24 �����)
            push h
            lhld _map_adr // ����� �������� �� ��������
            mvi h,0
            dad h
            pop d
            dad d
            call l_gint
            shld sprad ;                  //��������� ����� ������������ ������� � ���� (HL ->SP)
            ret
full_addr:
            LXI H,_screen_adresses
            mvi b,0h
            LDA _lab_adr // �������� ��������� ������� ������ �� ���� �� ������ �� �������� � ��������� ����� ������ ������� ������� 
            MOV C, A     // ��������� ��� � �
            INR A        // ��������� +1
            INR A        // ��� ��� ��� �� ��� �� 1
            STA _lab_adr // � ��������
            DAD B        // �� � �������������� �������� �������� � ��������� ������ ������
            MOV e,M
            INX H
            MOV d,M 
            xchg
            shld scrad
            RET
sub_addr:
            LXI H,_screen_adresses
            mvi b,0h
            LDA _lab_adr // �������� ��������� ������� ������ �� ���� �� ������ �� �������� � ��������� ����� ������ ������� ������� 
            MOV C, A     // ��������� ��� � �
            INR A        // ��������� +1
            INR A        // ��� ��� ��� �� ��� �� 1
            STA _lab_adr // � ��������
            DAD B        // �� � �������������� �������� �������� � ��������� ������ ������
            MOV e,M
            INX H
            MOV d,M 
            XCHG
            
            ;MVI C,5
            LDA _sdvig
            ;SUB C
            MOV B, A        ; �������� A � B ��� ��������
            MOV A, L
            SBB B           ; �������� B �� A, ��������� ����������� � A
            MOV L, A        ; ���������� ��������� ������� � L
            JC adjust_H     ; ���� ��� ����, ������������ H
            
            shld scrad
            RET             ; ��������� ������������

adjust_H:
            DCR H           ; ��������� H �� 1 (��������� ����)
            
            shld scrad
            RET
sprad:
            defw 0
scrad:
            defw 0
 #endasm
}


void sprite_left(void)
{           //123456 // ������
#asm 
show_left: // � � ������� �������� �������� � ������� �����
            // �������� ����
            pop h                   ; ���� ����� �������� �� ������� ����� (�� ����� ���� �������� CALL)
            shld temp_return_addr   ; ��������� ����� �������� � temp_return_addr
            add a
            lxi b, lefts
            mov l,a
            mvi h,0
            dad b
            mov a,m
            inx h
            mov h,m
            mov l,a

            mvi a,4     // ����� 4 ������ �������
            pchl 
temp_return_addr: 
            defw 0 ; ����������� 2 ����� ��� ���������� �������� ������ ��������
     
left5:
            //6..... // ��� ������
            lhld sprad
            sphl
            lhld scrad
            LXI D, 78   // �������� �� ����� ��� ��������� ��������� ������
ml1:        POP  B      // ������� �� ����� ������� �������
            POP  B    
            POP  B    
            MOV  M,B ;6 // ������ 6� ������ ������ �����
            DAD D       // �������� � ������ ������ �������� ��� ��������� ������
            DCR A       // �������� ������� �����
            JNZ ml1
            lhld temp_return_addr    ; ���������� ����� �������� � HL
            pchl                     ; ������������ ������� �� ������������ ������
left4:
            //56.... // ��� ������
            lhld sprad
            sphl
            lhld scrad
            LXI D, 77   // �������� �� ����� ��� ��������� ��������� ������
ml2:        POP  B      // ������� �� ����� ������� �������
            POP  B    
            POP  B
            MOV  M,C ;5
            INX  H
            MOV  M,B ;6 // ������ 6� ������ ������ �����
            DAD D       // �������� � ������ ������ �������� ��� ��������� ������
            DCR A       // �������� ������� �����
            JNZ ml2
            lhld temp_return_addr    ; ���������� ����� �������� � HL
            pchl                     ; ������������ ������� �� ������������ ������
left3:
            //456... // ��� ������
            lhld sprad
            sphl
            lhld scrad 
            LXI D, 76   // �������� �� ����� ��� ��������� ��������� ������
ml3:        POP  B      // ������� �� ����� ������� �������
            POP  B
            MOV  M,B ;4
            INX  H
            POP  B
            MOV  M,C ;5
            INX  H
            MOV  M,B ;6 // ������ 6� ������ ������ �����
            DAD D       // �������� � ������ ������ �������� ��� ��������� ������
            DCR A       // �������� ������� �����
            JNZ ml3
            lhld temp_return_addr    ; ���������� ����� �������� � HL
            pchl                     ; ������������ ������� �� ������������ ������
left2:
            //3456.. // ��� ������
            lhld sprad
            sphl
            lhld scrad 
            LXI D, 75   // �������� �� ����� ��� ��������� ��������� ������
ml4:        POP  B      // ������� �� ����� ������� �������
            POP  B
            MOV  M,C ;3
            INX  H
            MOV  M,B ;4
            INX  H
            POP  B
            MOV  M,C ;5
            INX  H
            MOV  M,B ;6 // ������ 6� ������ ������ �����
            DAD D       // �������� � ������ ������ �������� ��� ��������� ������
            DCR A       // �������� ������� �����
            JNZ ml4
            lhld temp_return_addr    ; ���������� ����� �������� � HL
            pchl                     ; ������������ ������� �� ������������ ������
left1:
            //23456. // ��� ������ ����� - ������ ���������� �������
            lhld sprad
            sphl
            lhld scrad 
            LXI D, 74   // �������� �� ����� ��� ��������� ��������� ������
ml5:        POP  B      // ������� �� ����� ������� �������
            MOV  M,B ;2  // ������� ��������� ������� �������
            INX  H
            POP  B
            MOV  M,C ;3
            INX  H
            MOV  M,B ;4
            INX  H
            POP  B
            MOV  M,C ;5
            INX  H
            MOV  M,B ;6 // ������ 6� ������ ������ �����
            DAD D       // �������� � ������ ������ �������� ��� ��������� ������
            DCR A       // �������� ������� �����
            JNZ ml5
            lhld temp_return_addr    ; ���������� ����� �������� � HL
            pchl                     ; ������������ ������� �� ������������ ������
left0:
            //123456    // ��� ������
            lhld sprad
            sphl
            lhld scrad 
            LXI D, 73   // �������� �� ����� ��� ��������� ��������� ������
ml6:        POP  B      // ������� �� ����� ������� �������
            MOV  M,C ;1
            INX  H
            MOV  M,B ;2  // ������� ��������� ������� �������
            INX  H
            POP  B
            MOV  M,C ;3
            INX  H
            MOV  M,B ;4
            INX  H
            POP  B
            MOV  M,C ;5
            INX  H
            MOV  M,B ;6 // ������ 6� ������ ������ �����
            DAD D       // �������� � ������ ������ �������� ��� ��������� ������
            DCR A       // �������� ������� �����
            JNZ ml6
            lhld temp_return_addr    ; ���������� ����� �������� � HL
            pchl                     ; ������������ ������� �� ������������ ������
lefts:      
            defw left0,left1,left2,left3,left4,left5

#endasm
}

void sprite_right(void)
{          //123456 // ������
#asm 
show_right: // � � ������� �������� �������� � ������� �����
            // �������� ����
            pop h                   ; ���� ����� �������� �� ������� ����� (�� ����� ���� �������� CALL)
            shld temp_return_addr   ; ��������� ����� �������� � temp_return_addr
            add a
            lxi b, rights
            mov l,a
            mvi h,0
            dad b
            mov a,m
            inx h
            mov h,m
            mov l,a

            mvi a,4     // ����� 4 ������ �������
            pchl 
right1:
            //1..... // ��� ������
            lhld sprad
            sphl
            lhld scrad
            LXI D, 78   // �������� �� ����� ��� ��������� ��������� ������
mr1:        POP  B   ;   // 
            MOV  M,C ;1  // 
            POP  B   ; 
            POP  B   ; 
            DAD D       // �������� � ������ ������ �������� ��� ��������� ������
            DCR A       // �������� ������� �����
            JNZ mr1
            lhld temp_return_addr    ; ���������� ����� �������� � HL
            pchl                     ; ������������ ������� �� ������������ ������
right2:     
            //12.... // ��� ������
            lhld sprad
            sphl
            lhld scrad
            LXI D, 77   // �������� �� ����� ��� ��������� ��������� ������
mr2:        POP  B   ;   // 
            MOV  M,C ;1  // 
            INX  H       // 
            MOV  M,B ;2  // 
            POP  B   ; 
            POP  B   ; 
            DAD D       // �������� � ������ ������ �������� ��� ��������� ������
            DCR A       // �������� ������� �����
            JNZ mr2
            lhld temp_return_addr    ; ���������� ����� �������� � HL
            pchl                     ; ������������ ������� �� ������������ ������
right3:
            //123... // ��� ������
            lhld sprad
            sphl
            lhld scrad
            LXI D, 76   // �������� �� ����� ��� ��������� ��������� ������
mr3:        POP  B   ;   // 
            MOV  M,C ;1  // 
            INX  H       // 
            MOV  M,B ;2  // 
            INX  H
            POP  B   ; 
            MOV  M,C ;3
            POP  B   ; 
            DAD D       // �������� � ������ ������ �������� ��� ��������� ������
            DCR A       // �������� ������� �����
            JNZ mr3
            lhld temp_return_addr    ; ���������� ����� �������� � HL
            pchl                     ; ������������ ������� �� ������������ ������
right4:
            //1234..
            lhld sprad
            sphl
            lhld scrad
            LXI D, 75   // �������� �� ����� ��� ��������� ��������� ������
mr4:        POP  B   ;   // 
            MOV  M,C ;1  // 
            INX  H       // 
            MOV  M,B ;2  // 
            INX  H
            POP  B   ; 
            MOV  M,C ;3
            INX  H
            MOV  M,B ;4
            POP  B   ; 
            DAD D       // �������� � ������ ������ �������� ��� ��������� ������
            DCR A       // �������� ������� �����
            JNZ mr4
            lhld temp_return_addr    ; ���������� ����� �������� � HL
            pchl                     ; ������������ ������� �� ������������ ������
right5:
            //12345.
            lhld sprad
            sphl
            lhld scrad
            LXI D, 74   // �������� �� ����� ��� ��������� ��������� ������
mr5:        POP  B      // 
            MOV  M,C ;1  // 
            INX  H       // 
            MOV  M,B ;2  // 
            INX  H
            POP  B    
            MOV  M,C ;3
            INX  H
            MOV  M,B ;4
            INX  H
            POP  B    
            MOV  M,C ;5
            DAD D       // �������� � ������ ������ �������� ��� ��������� ������
            DCR A       // �������� ������� �����
            JNZ mr5
            lhld temp_return_addr    ; ���������� ����� �������� � HL
            pchl                     ; ������������ ������� �� ������������ ������
rights:
            defw left0,right1,right2,right3,right4,right5
#endasm
}
/*

            
           
*/
void get_sprites_adresses_from_mass(void)
{
 uint8_t n,j,p;
 p=0;
 lab_pointer = 0;
 
 lab_y = FIELD_Y;
 for (j = 0; j < WIN_H; j++)
 {
    lab_x = WIN_LAB_X;
    for (n = 0; n < WIN_W; n++)
    {
     screen_adresses[p++] = charAddr(lab_x, lab_y);
     lab_x += 6;
    }
    lab_y += 4;
 }
 restore = 0;
}

