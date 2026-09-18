#include "main.h"

//                   6      4            2
void put_sprite(char x,char y, uint8_t* sprite)
{
/*
 * Áëèòòåð ñïðàéòà ñ çàãîëîâêîì (áîëüøèå áóêâû PALMIRA, öèôðû HUD).
 * Ôîðìàò: [øèðèíà â ñëîâàõ][âûñîòà â ñòðîêàõ][äàííûå...].
 *
 * Òðþê 8080: SP ïåðåñòàâëÿåòñÿ íà äàííûå ñïðàéòà, POP B âûäà¸ò äâà áàéòà
 * çà 10 òàêòîâ. Ðåàëüíûé ñòåê ñïàñ¸í â stacksave. Àäðåñ ýêðàíà =
 * 0xA69C + sm_y[y] + x, òàáëèöà ñìåùåíèé ñòðîê ëåæèò â 0xD000
 * (å¸ ñòðîèò create_table). Íå âûçûâàòü èçíóòðè äðóãîãî «ñòåêîâîãî» áëèòà.
 */
#asm
        LXI H,6; x
        DAD SP
        MOV C,M; ˜˜˜˜˜˜˜˜˜ x ˜ c
        DCX H
        DCX H;4
        MOV A,M; y ˜˜˜˜˜ ˜˜˜˜˜˜˜˜ ˜ ˜˜˜˜˜˜˜˜˜˜˜
        DCX H;2
        MOV D,M
        DCX H
        MOV E,M
        XCHG
        SHLD SPRADDR
            LXI  H,0
            DAD  SP
            SHLD  stacksave
            ;˜˜˜˜˜˜˜˜˜ ˜˜˜˜

        ADD A;   ˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜ ˜˜ ˜˜˜˜˜˜
        MOV L,A 
        MVI H,$d0; ˜ HL ˜˜˜˜˜ ˜˜˜˜˜˜˜˜ ˜˜ ˜˜˜˜˜˜˜
        MOV E,M
        INX H
        MOV D,M; ˜ DE ˜˜˜˜˜˜˜˜ ˜ ˜˜˜˜˜˜ Y
        MOV L,C; ˜˜˜˜˜˜˜˜˜˜ ˜
        MVI H,0
        DAD D ; ˜˜˜˜˜˜˜˜˜ ˜ ˜˜˜˜˜˜ ˜˜˜ ˜
        XCHG 
        LHLD VADDR;   VADDR; ˜˜˜˜˜˜˜˜˜ ˜ HL ˜˜˜˜˜ ˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜
        DAD D; ˜˜ ˜˜˜˜ ˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜˜ radio86rkVideoMem + sm_y[y] + x;
        XCHG // ˜ DE ˜˜˜˜˜ ˜˜˜˜˜ ˜˜˜˜˜˜ ˜˜ ˜˜˜˜˜˜˜ x y

        lhld  SPRADDR;_put_sprite_3
	MOV A,M; ˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜ ˜˜˜˜˜˜˜
        STA w_sprite
        INX H
        MOV A,M;
        STA h_sprite
        INX H

        SPHL ;  ˜˜˜˜˜˜˜˜˜ ˜˜˜˜ ˜˜˜˜˜ ˜ ˜˜˜˜ (HL ->SP) ˜˜ ˜˜˜˜ ˜˜˜˜˜ ˜˜˜˜˜˜˜ ˜ ˜˜˜˜˜
        XCHG ;  ˜˜˜˜˜ ˜˜˜˜˜˜ ˜˜ ˜˜˜˜˜˜˜ x y ˜˜˜˜˜˜ ˜ HL 
        LDA h_sprite;
        LXI D, 79
        CMA
        ADD E
        MOV E,A
  
 ;˜˜˜˜˜ ˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜ ˜ ˜˜˜˜˜ ˜˜˜˜˜˜˜˜ ˜˜˜˜˜ ˜˜˜˜˜˜˜˜, ˜ HL ˜˜˜˜˜˜˜˜ ˜˜˜˜˜ ˜˜˜˜˜˜ ˜˜ ˜˜˜˜˜˜˜˜˜ ˜˜ ˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜˜ ˜ DE ˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜ ˜˜˜ ˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜
strt_draw:
        LDA h_sprite;
        ORA A
        RAR
vi:
        POP  B   ; 
        MOV  M,C ;1
        INX  H
        MOV  M,B ;2
        INX  H
        DCR  A;
        JNZ  vi;
  DAD  D;     ˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜ ˜˜˜˜˜˜˜
  LDA w_sprite;
  DCR A
  JZ ext_draw
  STA w_sprite
  JMP strt_draw
ext_draw:


;˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜ ˜ ˜˜˜˜˜
  LHLD  stacksave
  SPHL
  RET
SPRADDR:
    defw 0h
VADDR:
    defw  0A69Ch
w_sprite:
    defb 0h
h_sprite:
    defb 0h
stacksave:
    defw 0
#endasm
}


