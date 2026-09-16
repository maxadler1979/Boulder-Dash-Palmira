        ; 6b3e:   10 fa      B
        L $6b3a
        ; 6b40:   a2 00      L
        X #$00
        ; 6b42:   a0 00      L
        Y #$00
        ; 6b44:   b1 46      L
        A (LocalVar),Y
        ; 6b46:   c9 01      C
        P #$01
        ; 6b48:   d0 02      B
        E $6b4c
        ; 6b4a:   a9 20      L
        A #$20
        ; 6b4c:   9d 00 0c   S
        A GameTileMap1_or_TitleTextTileMap,X
        ; 6b4f:   e8         I
        X 
        ; 6b50:   18         C
        C 
        ; 6b51:   69 34      A
        C #$34
        ; 6b53:   9d 00 0c   S
        A GameTileMap1_or_TitleTextTileMap,X
        ; 6b56:   e8         I
        X 
        ; 6b57:   c8         I
        Y 
        ; 6b58:   c0 14      C
        Y #$14
        ; 6b5a:   d0 e8      B
        E $6b44
        ; 6b5c:   60         R
        S 

; 

ReadJoystickDirectionPort1:
        ; 6b5d:   ad 01 dc   L
        A Cia1_DataB
        ; 6b60:   29 0f      A
        D #$0f
        ; 6b62:   60         R
        S 


ReadJoystickDirectionPort2:
        ; 6b63:   ad 00 dc   L
        A Cia1_DataA
        ; 6b66:   29 0f      A
        D #$0f
        ; 6b68:   60         R
        S 

; 
; NOTE: multiple entry points!

ReadFireButtonCurrentPlayer:
        ; 6b69:   a5 9d      L
        A CurrentPlayer


ReadFireButtonPlayerInA:
        ; 6b6b:   25 a4      A
        D NumJoysticksMinusOne
        ; 6b6d:   f0 05      B
        Q ReadFireButtonPort1
        ; 6b6f:   ad 00 dc   L
        A Cia1_DataA
        ; 6b72:   d0 03      B
        E _StoreFireButtonBit


ReadFireButtonPort1:
        ; 6b74:   ad 01 dc   L
        A Cia1_DataB


_StoreFireButtonBit:
        ; 6b77:   29 10      A
        D #$10
        ; 6b79:   85 b8      S
        A FireButtonStatus
        ; 6b7b:   60         R
        S 

; 

Text_ByPeterLiepa:
; ..by.peter.liepa....
        ; 6b7c:   20 20 22 39
        20 30 25 34  25 32 20 2c  29 25 30 21
        ; 6b8c:   20 20 20 20
        


Text__WithChrisGrey:
; ..with.chris.grey...
        ; 6b90:   20 20 37 29
        34 28 20 23  28 32 29 33  20 27 32 25
        ; 6ba0:   39 20 20 20
        


F1Text__Line4:
; 1.player..1.joystick
        ; 6ba4:   11 20 30 2c
        21 39 25 32  20 20 11 20  2a 2f 39 33
        ; 6bb4:   34 29 23 2b
        


Text_Plyr1Ply2:
; .plyr.1......plyr.2.
        ; 6bb8:   20 30 2c 39
        32 20 11 20  20 20 20 20  20 30 2c 39
        ; 6bc8:   32 20 12 20
        


Text_LastScores:
; .000000.last.000000.
        ; 6bcc:   20 10 10 10
        10 10 10 20  2c 21 33 34  20 10 10 10
        ; 6bdc:   10 10 10 20
        


Text_HighScores:
; .000000.high.000000.
        ; 6be0:   20 10 10 10
        10 10 10 20  28 29 27 28  20 10 10 10
        ; 6bf0:   10 10 10 20
        


Text_GameOver:
; .g.a.m.e...o.v.e.r..
        ; 6bf4:   20 27 20 21
        20 2d 20 25  20 20 20 2f  20 36 20 25
        ; 6c04:   20 32 20 20
        


Pre_level_Marquee_Text:
; player.1?.3.men.a?0.
        ; 6c08:   30 2c 21 39
        25 32 20 11  0d 20 13 20  2d 25 2e 20
        ; 6c18:   21 0f 10 20
        


Text_OutOfTime:
; ....out.of.time.....
        ; 6c1c:   20 20 20 20
        2f 35 34 20  2f 26 20 34  29 2d 25 20
        ; 6c2c:   20 20 20 20
        


Text_BonusLife:
; .b.o.n.u.s..l.i.f.e.
        ; 6c30:   20 22 20 2f
        20 2e 20 35  20 33 20 20  2c 20 29 20
        ; 6c40:   26 20 25 20
        


F1Text__Line5:
; .cave?.a..level?.1..
        ; 6c44:   20 23 21 36
        25 1a 20 21  20 20 2c 25  36 25 2c 1a
        ; 6c54:   20 11 20 20
        


Text__SpaceBarToResume:
; .spacebar.to.resume.
        ; 6c58:   20 33 30 21
        23 25 22 21  32 20 34 2f  20 32 25 33
        ; 6c68:   35 2d 25 20
        


Text_PressButtonToPlay:
; press.button.to.play
        ; 6c6c:   30 32 25 33
        33 20 22 35  34 34 2f 2e  20 34 2f 20
        ; 6c7c:   30 2c 21 39
        

; 
; ---------------------------------------------------------------
; INPUTS:
; ObjectTypeForScreenUpdate       $8A         = Object code
; InflatedCaveOutputOutputPtr    $36 & $37   = Position
; 
; NOTES:
;  Call SetInflatedCaveOutputPtr to set InflatedCaveOutputPtr
;  Inflated Cave: $4003 - $4dc2
; ---------------------------------------------------------------

SetCellInInflatedCave:
        ; 6c80:   a6 8a      L
        X ObjectTypeForScreenUpdate
        ; 6c82:   bd 28 5f   L
        A BaseCharNoForObjectTable,X
        ; 6c85:   a0 00      L
        Y #$00
        ; 6c87:   91 36      S
        A (InflatedCaveOutputPtr),Y
        ; 6c89:   18         C
        C 
        ; 6c8a:   69 01      A
        C #$01
        ; 6c8c:   c8         I
        Y 
        ; 6c8d:   91 36      S
        A (InflatedCaveOutputPtr),Y
        ; 6c8f:   69 0f      A
        C #$0f
        ; 6c91:   a0 50      L
        Y #$50
        ; 6c93:   91 36      S
        A (InflatedCaveOutputPtr),Y
        ; 6c95:   69 01      A
        C #$01
        ; 6c97:   c8         I
        Y 
        ; 6c98:   91 36      S
        A (InflatedCaveOutputPtr),Y
        ; 6c9a:   60         R
        S 

; 
; ---------------------------------------------
; INPUTS:
; .InflatedCaveCurrentCellPtr $34 & 35
; y = Offset
; OUTPUT:
; .InflatedCaveOutputPtr $36 & $37
; 
; Inflated Cave: $4003 - $4dc2
; ---------------------------------------------

SetInflatedCaveOutputPtr:
        ; 6c9b:   a2 fd      L
        X #$fd
        ; 6c9d:   98         T
        A 
        ; 6c9e:   e8         I
        X 
        ; 6c9f:   e8         I
        X 
        ; 6ca0:   e8         I
        X 
        ; 6ca1:   dd b0 53   C
        P InflatedCaveOffsetAdjustTable,X
        ; 6ca4:   d0 f8      B
        E $6c9e
        ; 6ca6:   18         C
        C 
        ; 6ca7:   a5 34      L
        A InflatedCaveCurrentCellPtr
        ; 6ca9:   7d b1 53   A
        C InflatedCaveOffsetAdjustTable+1,X
        ; 6cac:   85 36      S
        A InflatedCaveOutputPtr
        ; 6cae:   a5 35      L
        A InflatedCaveCurrentCellPtr+1
        ; 6cb0:   7d b2 53   A
        C InflatedCaveOffsetAdjustTable+2,X
        ; 6cb3:   85 37      S
        A InflatedCaveOutputPtr+1
        ; 6cb5:   60         R
        S 

; 
; Set a cell in the cave (where the game logic occurs) and the inflated cave
; (staging area for screen, each cell is presented as 2x2 characters).
; 
; A contains the object type and Y the offset from the current position.
; A is preseCaverved.

SetCell:
        ; 6cb6:   85 8a      S
        A ObjectTypeForScreenUpdate
        ; 6cb8:   91 32      S
        A (CaveCurrentCellPtr),Y ; the cave
        ; 6cba:   a5 92      L
        A CaveMatrixY
        ; 6cbc:   0a         A
        L A
        ; 6cbd:   aa         T
        X 
        ; 6cbe:   a5 91      L
        A CaveMatrixX
        ; 6cc0:   0a         A
        L A
        ; 6cc1:   18         C
        C 
        ; 6cc2:   7d da 53   A
        C InflatedCaveLineAddressTable,X
        ; 6cc5:   85 34      S
        A InflatedCaveCurrentCellPtr
        ; 6cc7:   a9 00      L
        A #$00
        ; 6cc9:   7d db 53   A
        C InflatedCaveLineAddressTable+1,X
        ; 6ccc:   85 35      S
        A InflatedCaveCurrentCellPtr+1
        ; 6cce:   20 9b 6c   J
        R SetInflatedCaveOutputPtr
        ; 6cd1:   20 80 6c   J
        R SetCellInInflatedCave ; the inflated cave
        ; 6cd4:   a5 8a      L
        A ObjectTypeForScreenUpdate
        ; 6cd6:   60         R
        S 

; 

__ProcessCave__ClearCurrentCell:
        ; 6cd7:   a9 00      L
        A #$00
        ; 6cd9:   85 8a      S
        A ObjectTypeForScreenUpdate
        ; 6cdb:   a0 29      L
        Y #$29
        ; 6cdd:   91 32      S
        A (CaveCurrentCellPtr),Y
        ; 6cdf:   a5 34      L
        A InflatedCaveCurrentCellPtr
        ; 6ce1:   85 36      S
        A InflatedCaveOutputPtr
        ; 6ce3:   a5 35      L
        A InflatedCaveCurrentCellPtr+1
        ; 6ce5:   85 37      S
        A InflatedCaveOutputPtr+1
        ; 6ce7:   20 80 6c   J
        R SetCellInInflatedCave
        ; 6cea:   4c 15 7e   J
        P __ProcessCave__NoObjectHandler

; 

PseudoRandom:
; .RandSeed1
; ...........\/............
; |b7|b6|b5|b4|b3|b2|b1|b0|
; ...........\/............     C
; |b0| 0| 0| 0| 0| 0| 0| 0|--->|b1|
; ...........\/............
; .SeededRandTemp1
        ; 6ced:   a5 3f      L
        A RandSeed1
        ; 6cef:   6a         R
        R A
        ; 6cf0:   6a         R
        R A
        ; 6cf1:   29 80      A
        D #$80
        ; 6cf3:   8d 04 98   S
        A SeededRandTemp1

; 
; .RandSeed2
; ...........\/............
; |b7|b6|b5|b4|b3|b2|b1|b0|
; ...........\/............     C
; |0 |b7|b6|b5|b4|b3|b2|b1|--->|b0|
; ...........\/............
; .SeededRandTemp2
        ; 6cf6:   a5 3e      L
        A RandSeed2
        ; 6cf8:   6a         R
        R A
        ; 6cf9:   29 7f      A
        D #$7f
        ; 6cfb:   8d 05 98   S
        A SeededRandTemp2

; .\/RandSeed2
; ...........\/............
; |b7|b6|b5|b4|b3|b2|b1|b0|
; ...........\/............     C
; |b0| 0| 0| 0| 0| 0| 0| 0|--->|b1|
; ...........\/............
; ....+(RandSeed2+0x13)....
; .\/RandSeed2
        ; 6cfe:   a5 3e      L
        A RandSeed2
        ; 6d00:   6a         R
        R A
        ; 6d01:   6a         R
        R A
        ; 6d02:   29 80      A
        D #$80
        ; 6d04:   18         C
        C 
        ; 6d05:   65 3e      A
        C RandSeed2
        ; 6d07:   69 13      A
        C #$13
        ; 6d09:   85 3e      S
        A RandSeed2

; 
        ; 6d0b:   a5 3f      L
        A RandSeed1
        ; 6d0d:   6d 04 98   A
        C SeededRandTemp1
        ; 6d10:   6d 05 98   A
        C SeededRandTemp2
        ; 6d13:   85 3f      S
        A RandSeed1
        ; 6d15:   60         R
        S 

; 
; Update one cave cell and on screen provided it isn't steel wall.

SetCellButPreserveSteelWall:
        ; 6d16:   b1 32      L
        A (CaveCurrentCellPtr),Y

; Object $07 = steel wall.
        ; 6d18:   c9 07      C
        P #$07
        ; 6d1a:   f0 05      B
        Q _Finished
        ; 6d1c:   a5 89      L
        A ObjectTypeForUpdateCaveCell
        ; 6d1e:   20 b6 6c   J
        R SetCell


_Finished:
        ; 6d21:   60         R
        S 

; Specify object type for fill in ObjectTypeForUpdateCaveCell (v).
; If the starred cell is the current cell the update occurs as shown:
; -------------
; |   |   |   |
; |---+---+---|
; | v |*v*|v-1|
; |---+---+---|
; |v-1|v-1|v-1|
; |---+---+---|
; |v-1|v-1|v-1|
; -------------

Explode3x3CellsDownOneRow:
        ; 6d22:   a0 28      L
        Y #$28
        ; 6d24:   20 16 6d   J
        R SetCellButPreserveSteelWall
        ; 6d27:   a0 29      L
        Y #$29
        ; 6d29:   20 16 6d   J
        R SetCellButPreserveSteelWall

; The decrement backs off the fill type for squares yet to
; be processed -- eg. back from explosion stage 1 to stage 0.
        ; 6d2c:   c6 89      D
        C ObjectTypeForUpdateCaveCell
        ; 6d2e:   a0 2a      L
        Y #$2a
        ; 6d30:   20 16 6d   J
        R SetCellButPreserveSteelWall
        ; 6d33:   a0 50      L
        Y #$50
        ; 6d35:   20 16 6d   J
        R SetCellButPreserveSteelWall
        ; 6d38:   a0 51      L
        Y #$51
        ; 6d3a:   20 16 6d   J
        R SetCellButPreserveSteelWall
        ; 6d3d:   a0 52      L
        Y #$52
        ; 6d3f:   20 16 6d   J
        R SetCellButPreserveSteelWall
        ; 6d42:   a0 78      L
        Y #$78
        ; 6d44:   20 16 6d   J
        R SetCellButPreserveSteelWall
        ; 6d47:   a0 79      L
        Y #$79
        ; 6d49:   20 16 6d   J
        R SetCellButPreserveSteelWall
        ; 6d4c:   a0 7a      L
        Y #$7a
        ; 6d4e:   20 16 6d   J
        R SetCellButPreserveSteelWall
        ; 6d51:   4c 91 6d   J
        P Explode3x3Cells__Common

; Handler for object $04.

ProcessHiddenOutbox:
        ; 6d54:   a5 90      L
        A LevelCompleteFlag
        ; 6d56:   f0 07      B
        Q ProcessHiddenOutbox__NotEnoughDiamonds
        ; 6d58:   a0 29      L
        Y #$29

; Object $05 = flashing outbox.
        ; 6d5a:   a9 05      L
        A #$05
        ; 6d5c:   20 b6 6c   J
        R SetCell


ProcessHiddenOutbox__NotEnoughDiamonds:
        ; 6d5f:   4c 15 7e   J
        P __ProcessCave__NoObjectHandler

; Specify object type for fill in ObjectTypeForUpdateCaveCell (v).
; If the starred cell is the current cell the update occurs as shown:
; -------------
; | v | v | v |
; |---+---+---|
; | v |*v*|v-1|
; |---+---+---|
; |v-1|v-1|v-1|
; -------------

Explode3x3Cells:
        ; 6d62:   a0 00      L
        Y #$00
        ; 6d64:   20 16 6d   J
        R SetCellButPreserveSteelWall
        ; 6d67:   a0 01      L
        Y #$01
        ; 6d69:   20 16 6d   J
        R SetCellButPreserveSteelWall
        ; 6d6c:   a0 02      L
        Y #$02
        ; 6d6e:   20 16 6d   J
        R SetCellButPreserveSteelWall
        ; 6d71:   a0 28      L
        Y #$28
        ; 6d73:   20 16 6d   J
        R SetCellButPreserveSteelWall
        ; 6d76:   a0 29      L
        Y #$29
        ; 6d78:   20 16 6d   J
        R SetCellButPreserveSteelWall

; The decrement backs off the fill type for squares yet to
; be processed -- eg. back from explosion stage 1 to stage 0.
        ; 6d7b:   c6 89      D
        C ObjectTypeForUpdateCaveCell
        ; 6d7d:   a0 2a      L
        Y #$2a
        ; 6d7f:   20 16 6d   J
        R SetCellButPreserveSteelWall
        ; 6d82:   a0 50      L
        Y #$50
        ; 6d84:   20 16 6d   J
        R SetCellButPreserveSteelWall
        ; 6d87:   a0 51      L
        Y #$51
        ; 6d89:   20 16 6d   J
        R SetCellButPreserveSteelWall
        ; 6d8c:   a0 52      L
        Y #$52
        ; 6d8e:   20 16 6d   J
        R SetCellButPreserveSteelWall

; This is used by both Set3x3 functions.

Explode3x3Cells__Common:
        ; 6d91:   a9 50      L
        A #$50
        ; 6d93:   8d 11 98   S
        A $9811
        ; 6d96:   20 e3 7c   J
        R ResetVoice2
        ; 6d99:   a2 06      L
        X #$06


Explode3x3Cells__SoundLoop:
        ; 6d9b:   bd a5 6d   L
        A ExplosionSIDVoiceTable,X
        ; 6d9e:   9d 07 d4   S
        A Sid_Voice2FreqLo,X
        ; 6da1:   ca         D
        X 
        ; 6da2:   10 f7      B
        L Explode3x3Cells__SoundLoop
        ; 6da4:   60         R
        S 

; All values for one SID voice.

ExplosionSIDVoiceTable:
        ; 6da5:   32 14 0f 00
        81 1b 00

; Matrix offset values used for firefly and butterfly turns.

FromLeftClockwiseOffsetTable:
        ; 6dac:   28 01 2a 51
        


FromDownClockwiseOffsetTable:
        ; 6db0:   51 28 01 2a
        

; X is zeroed when the test succeeds. Note that this function tests
; for both scanned and unscanned Rockfords, but only pre-existing amoeba.

TestForRockfordOrAmoeba:
        ; 6db4:   b1 32      L
        A (CaveCurrentCellPtr),Y

; Object $38 = Rockford.
        ; 6db6:   c9 38      C
        P #$38
        ; 6db8:   90 06      B
        C TestForRockfordOrAmoeba__Finished

; Object $3b = Amoeba created this frame.
        ; 6dba:   c9 3b      C
        P #$3b
        ; 6dbc:   b0 02      B
        S TestForRockfordOrAmoeba__Finished
        ; 6dbe:   a2 00      L
        X #$00


TestForRockfordOrAmoeba__Finished:
        ; 6dc0:   60         R
        S 

; Sets the Z flag when an explosion should occur.

TestForExplosionByContactWithRockfordOrAmoeba:
        ; 6dc1:   a2 01      L
        X #$01
        ; 6dc3:   a0 01      L
        Y #$01
        ; 6dc5:   20 b4 6d   J
        R TestForRockfordOrAmoeba
        ; 6dc8:   a0 28      L
        Y #$28
        ; 6dca:   20 b4 6d   J
        R TestForRockfordOrAmoeba
        ; 6dcd:   a0 2a      L
        Y #$2a
        ; 6dcf:   20 b4 6d   J
        R TestForRockfordOrAmoeba
        ; 6dd2:   a0 51      L
        Y #$51
        ; 6dd4:   20 b4 6d   J
        R TestForRockfordOrAmoeba
        ; 6dd7:   e0 00      C
        X #$00
        ; 6dd9:   60         R
        S 

; 

ProcessFirefly:
        ; 6dda:   20 c1 6d   J
        R TestForExplosionByContactWithRockfordOrAmoeba
        ; 6ddd:   d0 0a      B
        E ProcessFirefly__NoExplosion

; Install an explosion to space.
        ; 6ddf:   a9 1c      L
        A #$1c
        ; 6de1:   85 89      S
        A ObjectTypeForUpdateCaveCell
        ; 6de3:   20 62 6d   J
        R Explode3x3Cells
        ; 6de6:   4c 15 7e   J
        P __ProcessCave__NoObjectHandler

; Get the direction the firefly is facing: 0=left, 1=up, 2=right, 3=down.

ProcessFirefly__NoExplosion:
        ; 6de9:   a0 29      L
        Y #$29
        ; 6deb:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 6ded:   29 03      A
        D #$03
        ; 6def:   aa         T
        X 

; Check if there is a space to the firefly's left.
        ; 6df0:   bc b0 6d   L
        Y FromDownClockwiseOffsetTable,X
        ; 6df3:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 6df5:   d0 0e      B
        E ProcessFirefly__CantTurnLeft

; Turn left and move.
        ; 6df7:   18         C
        C 
        ; 6df8:   8a         T
        A 
        ; 6df9:   69 03      A
        C #$03
        ; 6dfb:   29 03      A
        D #$03
        ; 6dfd:   69 0c      A
        C #$0c
        ; 6dff:   20 b6 6c   J
        R SetCell
        ; 6e02:   4c d7 6c   J
        P __ProcessCave__ClearCurrentCell

; Check if there is a space straight ahead.

ProcessFirefly__CantTurnLeft:
        ; 6e05:   bc ac 6d   L
        Y FromLeftClockwiseOffsetTable,X
        ; 6e08:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 6e0a:   d0 0d      B
        E ProcessFirefly__CantMoveStraightAhead

; Move straight ahead.
        ; 6e0c:   18         C
        C 
        ; 6e0d:   8a         T
        A 
        ; 6e0e:   69 0c      A
        C #$0c
        ; 6e10:   bc ac 6d   L
        Y FromLeftClockwiseOffsetTable,X
        ; 6e13:   20 b6 6c   J
        R SetCell
        ; 6e16:   4c d7 6c   J
        P __ProcessCave__ClearCurrentCell

; Turn right, but do not move.

ProcessFirefly__CantMoveStraightAhead:
        ; 6e19:   18         C
        C 
        ; 6e1a:   a0 29      L
        Y #$29
        ; 6e1c:   8a         T
        A 
        ; 6e1d:   69 01      A
        C #$01
        ; 6e1f:   29 03      A
        D #$03
        ; 6e21:   69 0c      A
        C #$0c
        ; 6e23:   91 32      S
        A (CaveCurrentCellPtr),Y
        ; 6e25:   4c 15 7e   J
        P __ProcessCave__NoObjectHandler

; 

FallingDiamondSoundFX:
        ; 6e28:   ee 0d 98   I
        C $980d
        ; 6e2b:   a2 03      L
        X #$03


FallingDiamondSoundFX__Loop:
        ; 6e2d:   bd 8c 71   L
        A RockfordCollectingDiamondSIDValues+2,X
        ; 6e30:   9d 7f 98   S
        A $987f,X
        ; 6e33:   ca         D
        X 
        ; 6e34:   10 f7      B
        L FallingDiamondSoundFX__Loop
        ; 6e36:   a9 a0      L
        A #$a0
        ; 6e38:   8d 83 98   S
        A $9883
        ; 6e3b:   20 d0 6a   J
        R TimeBasedRandomNumber
        ; 6e3e:   8d 7d 98   S
        A Voice1SIDRegsBuffer
        ; 6e41:   20 d0 6a   J
        R TimeBasedRandomNumber
        ; 6e44:   29 07      A
        D #$07
        ; 6e46:   0a         A
        L A
        ; 6e47:   0a         A
        L A
        ; 6e48:   0a         A
        L A
        ; 6e49:   69 86      A
        C #$86
        ; 6e4b:   8d 7e 98   S
        A $987e
        ; 6e4e:   60         R
        S 

; All values for one SID voice.

FallingBoulderSIDVoiceTable:
        ; 6e4f:   32 09 07 00
        81 00 f0

; 

FallingBoulderSoundFX:
        ; 6e56:   ee 0d 98   I
        C $980d
        ; 6e59:   a2 06      L
        X #$06


FallingBoulderSoundFX__Loop:
        ; 6e5b:   bd 4f 6e   L
        A FallingBoulderSIDVoiceTable,X
        ; 6e5e:   9d 7d 98   S
        A Voice1SIDRegsBuffer,X
        ; 6e61:   ca         D
        X 
        ; 6e62:   10 f7      B
        L FallingBoulderSoundFX__Loop
        ; 6e64:   60         R
        S 

; Tests if an object is slippery.
; In:
; A: The object code to test.
; Out:
; Z: 1 if slippery.
; Modified:
; X

TestIfObjectSlippery:
        ; 6e65:   a2 00      L
        X #$00
        ; 6e67:   c9 10      C
        P #$10
        ; 6e69:   d0 02      B
        E TestIfObjectSlippery_NotOnBoulder
        ; 6e6b:   a2 01      L
        X #$01


TestIfObjectSlippery_NotOnBoulder:
        ; 6e6d:   c9 14      C
        P #$14
        ; 6e6f:   d0 02      B
        E TestIfObjectSlippery_NotOnDiamond
        ; 6e71:   a2 01      L
        X #$01


TestIfObjectSlippery_NotOnDiamond:
        ; 6e73:   c9 02      C
        P #$02
        ; 6e75:   d0 02      B
        E TestIfObjectSlippery_NotOnBrickWall
        ; 6e77:   a2 01      L
        X #$01


TestIfObjectSlippery_NotOnBrickWall:
        ; 6e79:   e0 01      C
        X #$01
        ; 6e7b:   60         R
        S 

; 

CheckIfFallingObjectKillsAnimal:
        ; 6e7c:   a2 01      L
        X #$01

; Test for hitting a butterfly.
        ; 6e7e:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 6e80:   29 33      A
        D #$33
        ; 6e82:   d1 32      C
        P (CaveCurrentCellPtr),Y
        ; 6e84:   d0 0c      B
        E CheckIfFallingObjectKillsAnimal_NotButterfly
        ; 6e86:   09 30      O
        A #$30
        ; 6e88:   d1 32      C
        P (CaveCurrentCellPtr),Y
        ; 6e8a:   d0 06      B
        E CheckIfFallingObjectKillsAnimal_NotButterfly

; Remember to explode to diamonds.
        ; 6e8c:   a2 00      L
        X #$00
        ; 6e8e:   a9 21      L
        A #$21
        ; 6e90:   85 89      S
        A ObjectTypeForUpdateCaveCell


CheckIfFallingObjectKillsAnimal_NotButterfly:
        ; 6e92:   e0 00      C
        X #$00
        ; 6e94:   f0 14      B
        Q CheckIfFallingObjectKillsAnimal_Finished
        ; 6e96:   a2 01      L
        X #$01

; Test for hitting a firefly.
        ; 6e98:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 6e9a:   29 0b      A
        D #$0b
        ; 6e9c:   d1 32      C
        P (CaveCurrentCellPtr),Y
        ; 6e9e:   d0 0a      B
        E CheckIfFallingObjectKillsAnimal_Finished
        ; 6ea0:   29 08      A
        D #$08
        ; 6ea2:   f0 06      B
        Q CheckIfFallingObjectKillsAnimal_Finished
        ; 6ea4:   a2 00      L
        X #$00

; Remember to explode to space.
        ; 6ea6:   a9 1c      L
        A #$1c
        ; 6ea8:   85 89      S
        A ObjectTypeForUpdateCaveCell


CheckIfFallingObjectKillsAnimal_Finished:
        ; 6eaa:   e0 00      C
        X #$00
        ; 6eac:   60         R
        S 

; 

ProcessButterfly:
        ; 6ead:   20 c1 6d   J
        R TestForExplosionByContactWithRockfordOrAmoeba
        ; 6eb0:   d0 0a      B
        E ProcessButterfly__NoExplosion

; Install an explosion to diamonds.
        ; 6eb2:   a9 21      L
        A #$21
        ; 6eb4:   85 89      S
        A ObjectTypeForUpdateCaveCell
        ; 6eb6:   20 62 6d   J
        R Explode3x3Cells
        ; 6eb9:   4c 15 7e   J
        P __ProcessCave__NoObjectHandler

; Get the direction the butterfly is facing: 0=down, 1=left, 2=up, 3=right.

ProcessButterfly__NoExplosion:
        ; 6ebc:   a0 29      L
        Y #$29
        ; 6ebe:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 6ec0:   29 03      A
        D #$03
        ; 6ec2:   aa         T
        X 

; Check if there is a space to the right.
        ; 6ec3:   bc ac 6d   L
        Y FromLeftClockwiseOffsetTable,X
        ; 6ec6:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 6ec8:   d0 0e      B
        E ProcessButterfly__CantTurnRight

; Turn right and move.
        ; 6eca:   18         C
        C 
        ; 6ecb:   8a         T
        A 
        ; 6ecc:   69 01      A
        C #$01
        ; 6ece:   29 03      A
        D #$03
        ; 6ed0:   69 34      A
        C #$34
        ; 6ed2:   20 b6 6c   J
        R SetCell
        ; 6ed5:   4c d7 6c   J
        P __ProcessCave__ClearCurrentCell

; Check if there is a space straight ahead.

ProcessButterfly__CantTurnRight:
        ; 6ed8:   bc b0 6d   L
        Y FromDownClockwiseOffsetTable,X
        ; 6edb:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 6edd:   d0 0d      B
        E ProcessButterfly__CantMoveStraightAhead

; Move straight ahead.
        ; 6edf:   18         C
        C 
        ; 6ee0:   8a         T
        A 
        ; 6ee1:   69 34      A
        C #$34
        ; 6ee3:   bc b0 6d   L
        Y FromDownClockwiseOffsetTable,X
        ; 6ee6:   20 b6 6c   J
        R SetCell
        ; 6ee9:   4c d7 6c   J
        P __ProcessCave__ClearCurrentCell

; Turn left, but do not move.

ProcessButterfly__CantMoveStraightAhead:
        ; 6eec:   18         C
        C 
        ; 6eed:   a0 29      L
        Y #$29
        ; 6eef:   8a         T
        A 
        ; 6ef0:   69 03      A
        C #$03
        ; 6ef2:   29 03      A
        D #$03
        ; 6ef4:   69 34      A
        C #$34
        ; 6ef6:   91 32      S
        A (CaveCurrentCellPtr),Y
        ; 6ef8:   4c 15 7e   J
        P __ProcessCave__NoObjectHandler

; 

__ProcessCave__CreateScannedStationaryDiamond:
        ; 6efb:   a0 29      L
        Y #$29
        ; 6efd:   a9 15      L
        A #$15
        ; 6eff:   20 b6 6c   J
        R SetCell
        ; 6f02:   4c 15 7e   J
        P __ProcessCave__NoObjectHandler

; 

ProcessFallingDiamond:
        ; 6f05:   a0 51      L
        Y #$51

; Check for a space below.
        ; 6f07:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 6f09:   d0 08      B
        E ProcessFallingDiamond__NoSpaceBelow

; Move the falling diamond down one row, and mark as scanned.
        ; 6f0b:   a9 17      L
        A #$17
        ; 6f0d:   20 b6 6c   J
        R SetCell
        ; 6f10:   4c d7 6c   J
        P __ProcessCave__ClearCurrentCell

; Check for a magic wall below.

ProcessFallingDiamond__NoSpaceBelow:
        ; 6f13:   c9 03      C
        P #$03
        ; 6f15:   d0 1d      B
        E ProcessFallingDiamond__NoMagicWallBelow

; Has the magic wall already been activated?
        ; 6f17:   a5 8d      L
        A MagicWallActiveState
        ; 6f19:   d0 04      B
        E ProcessFallingDiamond__MagicWallAlreadyActivated

; Activate the magic wall.
        ; 6f1b:   a9 01      L
        A #$01
        ; 6f1d:   85 8d      S
        A MagicWallActiveState

; Is the magic wall still active? If not the diamond will just be consumed.

ProcessFallingDiamond__MagicWallAlreadyActivated:
        ; 6f1f:   c9 01      C
        P #$01
        ; 6f21:   d0 0b      B
        E ProcessFallingDiamond__ClearDiamondAboveMagicWall

; Is the row below the magic wall empty? If not the diamond will just be consumed.
        ; 6f23:   a0 79      L
        Y #$79
        ; 6f25:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 6f27:   d0 05      B
        E ProcessFallingDiamond__ClearDiamondAboveMagicWall

; Convert the diamond to a (scanned) falling boulder below the magic wall.
        ; 6f29:   a9 13      L
        A #$13
        ; 6f2b:   20 b6 6c   J
        R SetCell


ProcessFallingDiamond__ClearDiamondAboveMagicWall:
        ; 6f2e:   20 56 6e   J
        R FallingBoulderSoundFX
        ; 6f31:   4c d7 6c   J
        P __ProcessCave__ClearCurrentCell

; Tinkle while the diamond falls.

ProcessFallingDiamond__NoMagicWallBelow:
        ; 6f34:   20 28 6e   J
        R FallingDiamondSoundFX

; Check if the diamond has hit a slippery object.
        ; 6f37:   a0 51      L
        Y #$51
        ; 6f39:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 6f3b:   20 65 6e   J
        R TestIfObjectSlippery
        ; 6f3e:   d0 2b      B
        E ProcessFallingDiamond__NotSlipperyHit

; Is there a space below-left?
        ; 6f40:   a0 50      L
        Y #$50
        ; 6f42:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 6f44:   d0 0e      B
        E ProcessFallingDiamond__CantFallLeft

; Is there a space left?
        ; 6f46:   a0 28      L
        Y #$28
        ; 6f48:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 6f4a:   d0 08      B
        E ProcessFallingDiamond__CantFallLeft

; Move the diamond left.
        ; 6f4c:   a9 17      L
        A #$17
        ; 6f4e:   20 b6 6c   J
        R SetCell
        ; 6f51:   4c d7 6c   J
        P __ProcessCave__ClearCurrentCell

; Is there a space below-right?

ProcessFallingDiamond__CantFallLeft:
        ; 6f54:   a0 52      L
        Y #$52
        ; 6f56:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 6f58:   d0 0e      B
        E ProcessFallingDiamond__CantFallRight

; Is there a space right?
        ; 6f5a:   a0 2a      L
        Y #$2a
        ; 6f5c:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 6f5e:   d0 08      B
        E ProcessFallingDiamond__CantFallRight

; Move the diamond right.
        ; 6f60:   a9 17      L
        A #$17
        ; 6f62:   20 b6 6c   J
        R SetCell
        ; 6f65:   4c d7 6c   J
        P __ProcessCave__ClearCurrentCell

; The diamond is on a slippery object, but can't fall left or right.

ProcessFallingDiamond__CantFallRight:
        ; 6f68:   4c fb 6e   J
        P __ProcessCave__CreateScannedStationaryDiamond

; Have we hit Rockford on the head?

ProcessFallingDiamond__NotSlipperyHit:
        ; 6f6b:   c9 38      C
        P #$38
        ; 6f6d:   d0 0a      B
        E ProcessFallingDiamond__DidntHitRockford

; Poor old Rockford is dead -- explode him to space.
        ; 6f6f:   a9 1c      L
        A #$1c
        ; 6f71:   85 89      S
        A ObjectTypeForUpdateCaveCell
        ; 6f73:   20 22 6d   J
        R Explode3x3CellsDownOneRow
        ; 6f76:   4c 15 7e   J
        P __ProcessCave__NoObjectHandler

; Have we hit an animal?

ProcessFallingDiamond__DidntHitRockford:
        ; 6f79:   20 7c 6e   J
        R CheckIfFallingObjectKillsAnimal
        ; 6f7c:   d0 06      B
        E ProcessFallingDiamond__DidntHitAnimal

; Explode the animal.
        ; 6f7e:   20 22 6d   J
        R Explode3x3CellsDownOneRow
        ; 6f81:   4c 15 7e   J
        P __ProcessCave__NoObjectHandler

; Can't do anything interesting, so convert to a stationary diamond.

ProcessFallingDiamond__DidntHitAnimal:
        ; 6f84:   4c fb 6e   J
        P __ProcessCave__CreateScannedStationaryDiamond

; 

ProcessStationaryDiamond:
        ; 6f87:   a0 51      L
        Y #$51

; Is there a space below the diamond?
        ; 6f89:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 6f8b:   d0 0b      B
        E ProcessStationaryDiamond__NoSpaceBelow

; Convert to a scanned falling diamond and move down.
        ; 6f8d:   a9 17      L
        A #$17
        ; 6f8f:   20 b6 6c   J
        R SetCell
        ; 6f92:   20 28 6e   J
        R FallingDiamondSoundFX
        ; 6f95:   4c d7 6c   J
        P __ProcessCave__ClearCurrentCell

; Is the diamond sitting on a slippery object?

ProcessStationaryDiamond__NoSpaceBelow:
        ; 6f98:   a0 51      L
        Y #$51
        ; 6f9a:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 6f9c:   20 65 6e   J
        R TestIfObjectSlippery
        ; 6f9f:   d0 28      B
        E ProcessStationaryDiamond__Finished

; Is there a space below-left?
        ; 6fa1:   a0 50      L
        Y #$50
        ; 6fa3:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 6fa5:   d0 0e      B
        E ProcessStationaryDiamond__CantFallLeft

; Is there a space left?
        ; 6fa7:   a0 28      L
        Y #$28
        ; 6fa9:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 6fab:   d0 08      B
        E ProcessStationaryDiamond__CantFallLeft

; Move the diamond left.
        ; 6fad:   a9 17      L
        A #$17
        ; 6faf:   20 b6 6c   J
        R SetCell
        ; 6fb2:   4c d7 6c   J
        P __ProcessCave__ClearCurrentCell

; Is there a space below-right?

ProcessStationaryDiamond__CantFallLeft:
        ; 6fb5:   a0 52      L
        Y #$52
        ; 6fb7:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 6fb9:   d0 0e      B
        E ProcessStationaryDiamond__Finished

; Is there a space right?
        ; 6fbb:   a0 2a      L
        Y #$2a
        ; 6fbd:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 6fbf:   d0 08      B
        E ProcessStationaryDiamond__Finished

; Move the diamond right.
        ; 6fc1:   a9 17      L
        A #$17
        ; 6fc3:   20 b6 6c   J
        R SetCell
        ; 6fc6:   4c d7 6c   J
        P __ProcessCave__ClearCurrentCell


ProcessStationaryDiamond__Finished:
        ; 6fc9:   4c 15 7e   J
        P __ProcessCave__NoObjectHandler

; 

AmoebaUpLeftRightDownOffsetTable:
        ; 6fcc:   01 28 2a 51
        

; 

ProcessAmoeba:
        ; 6fd0:   ee 02 98   I
        C AmoebaCellCountThisTick
        ; 6fd3:   ad 03 98   L
        A AmoebaCellCountPreviousTick
        ; 6fd6:   c9 c8      C
        P #$c8
        ; 6fd8:   90 08      B
        C __ProcessAmoeba__NotTooBig


__ProcessAmoeba__GreaterOrEqualTo200:
; $11 = Scanned stationary boulder.
        ; 6fda:   a9 11      L
        A #$11
        ; 6fdc:   20 b6 6c   J
        R SetCell
        ; 6fdf:   4c 15 7e   J
        P __ProcessCave__NoObjectHandler


__ProcessAmoeba__NotTooBig:
        ; 6fe2:   a5 8c      L
        A AmeobaCouldGrowLastTick
        ; 6fe4:   d0 08      B
        E __ProcessAmoeba__NotConfined

; $14 = Stationary diamond.
        ; 6fe6:   a9 14      L
        A #$14
        ; 6fe8:   20 b6 6c   J
        R SetCell
        ; 6feb:   4c 15 7e   J
        P __ProcessCave__NoObjectHandler


__ProcessAmoeba__NotConfined:
        ; 6fee:   a5 42      L
        A AmeobaCouldGrowThisTick
        ; 6ff0:   d0 20      B
        E __ProcessAmoeba__AlreadyKnowAmoebaCanGrowThisTick
        ; 6ff2:   a9 03      L
        A #$03
        ; 6ff4:   85 46      S
        A LocalVar
        ; 6ff6:   a2 01      L
        X #$01


__ProcessAmoeba__ConfinementTestLoop:
        ; 6ff8:   a4 46      L
        Y LocalVar
        ; 6ffa:   b9 cc 6f   L
        A AmoebaUpLeftRightDownOffsetTable,Y
        ; 6ffd:   a8         T
        Y 
        ; 6ffe:   b1 32      L
        A (CaveCurrentCellPtr),Y

; $00 = Space, $01 = Dirt, $02 = Brick wall.
; Amoeba can grow into space and dirt. It is confined by anything else.
        ; 7000:   c9 02      C
        P #$02
        ; 7002:   b0 02      B
        S __ProcessAmoeba__CantGrowThisDirection
        ; 7004:   a2 00      L
        X #$00


__ProcessAmoeba__CantGrowThisDirection:
        ; 7006:   c6 46      D
        C LocalVar
        ; 7008:   10 ee      B
        L __ProcessAmoeba__ConfinementTestLoop
        ; 700a:   e0 00      C
        X #$00
        ; 700c:   d0 04      B
        E __ProcessAmoeba__AlreadyKnowAmoebaCanGrowThisTick
        ; 700e:   a9 01      L
        A #$01
        ; 7010:   85 42      S
        A AmeobaCouldGrowThisTick


__ProcessAmoeba__AlreadyKnowAmoebaCanGrowThisTick:
        ; 7012:   20 d0 6a   J
        R TimeBasedRandomNumber
        ; 7015:   25 9a      A
        D AmoebaGrowthProbabilityMask
        ; 7017:   c9 04      C
        P #$04
        ; 7019:   b0 1b      B
        S __ProcessAmoeba__DontGrowThisTick
        ; 701b:   aa         T
        X 
        ; 701c:   bc cc 6f   L
        Y AmoebaUpLeftRightDownOffsetTable,X
        ; 701f:   a2 01      L
        X #$01
        ; 7021:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 7023:   d0 02      B
        E __ProcessAmoeba__NotSpace
        ; 7025:   a2 00      L
        X #$00


__ProcessAmoeba__NotSpace:
        ; 7027:   c9 01      C
        P #$01
        ; 7029:   d0 02      B
        E __ProcessAmoeba__NotDirt
        ; 702b:   a2 00      L
        X #$00


__ProcessAmoeba__NotDirt:
        ; 702d:   e0 00      C
        X #$00
        ; 702f:   d0 05      B
        E __ProcessAmoeba__DontGrowThisTick

; $3b = Scanned amoeba.
        ; 7031:   a9 3b      L
        A #$3b
        ; 7033:   20 b6 6c   J
        R SetCell


__ProcessAmoeba__DontGrowThisTick:
        ; 7036:   4c 15 7e   J
        P __ProcessCave__NoObjectHandler

; 

ExtraLife:
        ; 7039:   a5 5c      L
        A Lives
        ; 703b:   c9 09      C
        P #$09
        ; 703d:   f0 06      B
        Q $7045
        ; 703f:   e6 5c      I
        C Lives
        ; 7041:   a9 80      L
        A #$80
        ; 7043:   85 a8      S
        A ExtraLifeFXCounter
        ; 7045:   60         R
        S 


ProcessExtraLife:
        ; 7046:   a5 a9      L
        A OldScore1000sDigit
        ; 7048:   c5 61      C
        P ScoreDigits+2
        ; 704a:   f0 03      B
        Q $704f
        ; 704c:   20 39 70   J
        R ExtraLife
        ; 704f:   a5 aa      L
        A OldScore100sDigit
        ; 7051:   c9 04      C
        P #$04
        ; 7053:   d0 07      B
        E $705c
        ; 7055:   c5 62      C
        P ScoreDigits+3
        ; 7057:   f0 03      B
        Q $705c
        ; 7059:   20 39 70   J
        R ExtraLife
        ; 705c:   60         R
        S 

; You get an extra life every 500 points.

IncrementScore:
        ; 705d:   a5 61      L
        A ScoreDigits+2
        ; 705f:   85 a9      S
        A OldScore1000sDigit
        ; 7061:   a5 62      L
        A ScoreDigits+3
        ; 7063:   85 aa      S
        A OldScore100sDigit
        ; 7065:   a2 05      L
        X #$05
        ; 7067:   18         C
        C 
        ; 7068:   b5 5f      L
        A ScoreDigits,X
        ; 706a:   75 4e      A
        C ScoreIncrementDigits,X
        ; 706c:   c9 0a      C
        P #$0a
        ; 706e:   90 02      B
        C $7072
        ; 7070:   e9 0a      S
        C #$0a
        ; 7072:   95 5f      S
        A ScoreDigits,X
        ; 7074:   09 10      O
        A #$10
        ; 7076:   9d 48 98   S
        A ScoreChars,X
        ; 7079:   ca         D
        X 
        ; 707a:   10 ec      B
        L $7068
        ; 707c:   20 46 70   J
        R ProcessExtraLife
        ; 707f:   60         R
        S 

; 

DiamondQuotaReachedSoundSIDValues:
; $32, $2f:
;     A frequency value of $2f32. On PAL machines this gives a
;     frequency of 709.5212042331696 HZ
;     Calculated using this formula (PAL): (reg*985250)/16777216
; $00, $00:
;     Pulse width. N/A
; $81:
;     Control register
;     Noise waveform, ADSR cycle
; $19:
;     Attack 8 ms, Decay 750 ms
; $01:
;     Sustain volume of 0, Release 24 ms
        ; 7080:   32 2f 00 00
        81 19 01


InitiateDiamondQuotaReachedSound:
        ; 7087:   a9 01      L
        A #$01
        ; 7089:   85 d8      S
        A SFXTrigger_DiamondQuotaReachedOrEntryBoxExplode
        ; 708b:   60         R
        S 

; 

CheckIfLevelTimeIsUp:
        ; 708c:   a5 ab      L
        A TimeLeft
        ; 708e:   d0 34      B
        E $70c4
        ; 7090:   a5 ac      L
        A TimeLeft+1
        ; 7092:   d0 30      B
        E $70c4
        ; 7094:   a5 ad      L
        A TimeLeft+2
        ; 7096:   d0 05      B
        E TimeRunningOutFX
        ; 7098:   a9 02      L
        A #$02
        ; 709a:   85 97      S
        A ExitCaveFlag
        ; 709c:   60         R
        S 


TimeRunningOutFX:
        ; 709d:   ad 11 98   L
        A $9811
        ; 70a0:   d0 22      B
        E $70c4
        ; 70a2:   20 e3 7c   J
        R ResetVoice2
        ; 70a5:   a9 0a      L
        A #$0a
        ; 70a7:   8d 0c d4   S
        A Sid_Voice2AttackDecay
        ; 70aa:   a9 00      L
        A #$00
        ; 70ac:   8d 0d d4   S
        A Sid_Voice2SustainRelease
        ; 70af:   a9 27      L
        A #$27
        ; 70b1:   38         S
        C 
        ; 70b2:   e5 ad      S
        C TimeLeft+2
        ; 70b4:   8d 08 d4   S
        A Sid_Voice2FreqHi
        ; 70b7:   a9 11      L
        A #$11
        ; 70b9:   8d 0b d4   S
        A Sid_Voice2Ctrl
        ; 70bc:   ad 0d 98   L
        A $980d
        ; 70bf:   09 80      O
        A #$80
        ; 70c1:   8d 0d 98   S
        A $980d
        ; 70c4:   60         R
        S 

; 

GameSecondTick:
; Subtract one from time (it'a a zero-based string).
        ; 70c5:   a2 02      L
        X #$02
        ; 70c7:   18         C
        C 
        ; 70c8:   b5 ab      L
        A TimeLeft,X
        ; 70ca:   69 09      A
        C #$09
        ; 70cc:   c9 0a      C
        P #$0a
        ; 70ce:   90 02      B
        C $70d2
        ; 70d0:   e9 0a      S
        C #$0a
        ; 70d2:   95 ab      S
        A TimeLeft,X
        ; 70d4:   09 10      O
        A #$10
        ; 70d6:   9d 44 98   S
        A TimeLeftText,X
        ; 70d9:   ca         D
        X 
        ; 70da:   10 ec      B
        L $70c8

; 
        ; 70dc:   20 8c 70   J
        R CheckIfLevelTimeIsUp
        ; 70df:   60         R
        S 

; 

GameSecondTickWithAmoebaProcessing:
        ; 70e0:   20 c5 70   J
        R GameSecondTick
        ; 70e3:   e6 af      I
        C TimeCaveHasRan
        ; 70e5:   a5 af      L
        A TimeCaveHasRan
        ; 70e7:   cd 01 24   C
        P BufferedLevel_MagicWallMillingTimeOrAmoeba3PercentMax
        ; 70ea:   d0 04      B
        E GameSecondTickWithAmoebaProcessing__Exit
        ; 70ec:   a9 0f      L
        A #$0f
        ; 70ee:   85 9a      S
        A AmoebaGrowthProbabilityMask


GameSecondTickWithAmoebaProcessing__Exit:
        ; 70f0:   60         R
        S 


FlashingEntryBoxSecondTick:
        ; 70f1:   c6 95      D
        C FlashingEntryBoxCountDown
        ; 70f3:   d0 0f      B
        E FlashingEntryBoxSecondTick__Exit


FlashingEntryBoxSecondTick__Birth:
        ; 70f5:   20 87 70   J
        R InitiateDiamondQuotaReachedSound
        ; 70f8:   a9 00      L
        A #$00
        ; 70fa:   85 93      S
        A FlashingEntryBoxFlag
        ; 70fc:   85 fb      S
        A LastKeyInScanRow0_ScannedMoreThanOnce
        ; 70fe:   85 fc      S
        A LastKeyInScanRow7_ScannedMoreThanOnce
        ; 7100:   a9 01      L
        A #$01
        ; 7102:   85 94      S
        A EnableSomeSFXAndMarqueeUpdates


FlashingEntryBoxSecondTick__Exit:
        ; 7104:   60         R
        S 

; 

SetTopLineToScore:
        ; 7105:   a9 3a      L
        A #&lt;CurrentPlayerScoresText
        ; 7107:   85 46      S
        A LocalVar
        ; 7109:   a9 98      L
        A #&gt;CurrentPlayerScoresText
        ; 710b:   85 47      S
        A LocalVar+1
        ; 710d:   20 16 6b   J
        R SetTopLineText
        ; 7110:   60         R
        S 

; 

SubSecondTick:
        ; 7111:   e6 ae      I
        C SubSecondCounter
        ; 7113:   a5 ae      L
        A SubSecondCounter
        ; 7115:   c9 3c      C
        P #$3c
        ; 7117:   d0 13      B
        E SubSecondTick_Exit


SubSecondTick__OneGameSecondPassed:
        ; 7119:   a9 00      L
        A #$00
        ; 711b:   85 ae      S
        A SubSecondCounter
        ; 711d:   a5 9b      L
        A SecondsDontPass
        ; 711f:   d0 0b      B
        E SubSecondTick_Exit
        ; 7121:   a5 93      L
        A FlashingEntryBoxFlag
        ; 7123:   d0 04      B
        E SubSecondTick__FlashingEntryBoxSecondTick
        ; 7125:   20 e0 70   J
        R GameSecondTickWithAmoebaProcessing
        ; 7128:   60         R
        S 


SubSecondTick__FlashingEntryBoxSecondTick:
        ; 7129:   20 f1 70   J
        R FlashingEntryBoxSecondTick


SubSecondTick_Exit:
        ; 712c:   60         R
        S 

; 

IncrementDiamondCount:
        ; 712d:   a2 01      L
        X #$01
        ; 712f:   18         C
        C 
        ; 7130:   8a         T
        A 
        ; 7131:   75 b0      A
        C DiamondCountDigits,X
        ; 7133:   c9 0a      C
        P #$0a
        ; 7135:   90 02      B
        C $7139
        ; 7137:   e9 0a      S
        C #$0a
        ; 7139:   95 b0      S
        A DiamondCountDigits,X
        ; 713b:   09 10      O
        A #$10

; Update the diamond count in CurrentPlayerInfoText.
        ; 713d:   9d 41 98   S
        A $9841,X
        ; 7140:   ca         D
        X 
        ; 7141:   10 ed      B
        L $7130
        ; 7143:   60         R
        S 

; 

DiamondQuotaDigitsToString:
        ; 7144:   a2 01      L
        X #$01
        ; 7146:   b5 b2      L
        A DiamondQuotaDigits,X
        ; 7148:   09 10      O
        A #$10
        ; 714a:   9d 3b 98   S
        A DiamondQuotaString,X
        ; 714d:   ca         D
        X 
        ; 714e:   10 f6      B
        L $7146
        ; 7150:   60         R
        S 


ScoreIncrementToString:
        ; 7151:   a2 01      L
        X #$01
        ; 7153:   b5 52      L
        A ScoreIncrementDigits+4,X
        ; 7155:   09 10      O
        A #$10
        ; 7157:   9d 3e 98   S
        A DiamondValueString,X
        ; 715a:   ca         D
        X 
        ; 715b:   10 f6      B
        L $7153
        ; 715d:   60         R
        S 

; 

CheckIfGotDiamondQuota:
        ; 715e:   a5 b0      L
        A DiamondCountDigits
        ; 7160:   c5 b2      C
        P DiamondQuotaDigits
        ; 7162:   d0 25      B
        E __CheckIfGotDiamondQuota__Exit
        ; 7164:   a5 b1      L
        A DiamondCountDigits+1
        ; 7166:   c5 b3      C
        P DiamondQuotaDigits+1
        ; 7168:   d0 1f      B
        E __CheckIfGotDiamondQuota__Exit

; Quota reached.
        ; 716a:   a9 01      L
        A #$01
        ; 716c:   85 90      S
        A LevelCompleteFlag

; Set score increment to the value of diamonds above the quota.
        ; 716e:   a2 02      L
        X #$02
        ; 7170:   b5 b4      L
        A ExtraDiamondValue,X
        ; 7172:   95 51      S
        A ScoreIncrementDigits+3,X
        ; 7174:   ca         D
        X 
        ; 7175:   10 f9      B
        L $7170
        ; 7177:   20 51 71   J
        R ScoreIncrementToString

; Display diamonds where the diamond quota used to be displayed.
        ; 717a:   a9 3c      L
        A #$3c
        ; 717c:   8d 3b 98   S
        A DiamondQuotaString
        ; 717f:   8d 3c 98   S
        A $983c

; Diamond quota FX.
        ; 7182:   20 87 70   J
        R InitiateDiamondQuotaReachedSound
        ; 7185:   a9 06      L
        A #$06
        ; 7187:   85 a5      S
        A WhiteFlashWhiteCount


__CheckIfGotDiamondQuota__Exit:
        ; 7189:   60         R
        S 

; 

RockfordCollectingDiamondSIDValues:
        ; 718a:   78 14 07 00
        11 00 f0

; 

RockfordMovingToDiamond:
        ; 7191:   ee 0d 98   I
        C $980d
        ; 7194:   a2 06      L
        X #$06


RockfordMovingToDiamond__Loop:
        ; 7196:   bd 8a 71   L
        A RockfordCollectingDiamondSIDValues,X
        ; 7199:   9d 7d 98   S
        A Voice1SIDRegsBuffer,X
        ; 719c:   ca         D
        X 
        ; 719d:   10 f7      B
        L RockfordMovingToDiamond__Loop
        ; 719f:   20 5d 70   J
        R IncrementScore
        ; 71a2:   20 2d 71   J
        R IncrementDiamondCount
        ; 71a5:   20 5e 71   J
        R CheckIfGotDiamondQuota
        ; 71a8:   e6 b7      I
        C RockfordMoveSucceededFlag
        ; 71aa:   60         R
        S 

; 

RockfordTriesToMoveBoulder:
        ; 71ab:   20 d0 6a   J
        R TimeBasedRandomNumber
        ; 71ae:   29 03      A
        D #$03
        ; 71b0:   d0 0a      B
        E $71bc
        ; 71b2:   e6 b7      I
        C RockfordMoveSucceededFlag
        ; 71b4:   20 56 6e   J
        R FallingBoulderSoundFX
        ; 71b7:   a9 11      L
        A #$11
        ; 71b9:   20 b6 6c   J
        R SetCell
        ; 71bc:   60         R
        S 

; 

TryToMoveRockford:
        ; 71bd:   a9 00      L
        A #$00
        ; 71bf:   85 b7      S
        A RockfordMoveSucceededFlag
        ; 71c1:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 71c3:   d0 08      B
        E TryToMoveRockford__NotSpace
        ; 71c5:   e6 b7      I
        C RockfordMoveSucceededFlag
        ; 71c7:   a9 35      L
        A #$35
        ; 71c9:   8d 08 98   S
        A $9808
        ; 71cc:   60         R
        S 


TryToMoveRockford__NotSpace:
        ; 71cd:   c9 01      C
        P #$01
        ; 71cf:   d0 08      B
        E TryToMoveRockford__NotDirt
        ; 71d1:   e6 b7      I
        C RockfordMoveSucceededFlag
        ; 71d3:   a9 a5      L
        A #$a5
        ; 71d5:   8d 08 98   S
        A $9808
        ; 71d8:   60         R
        S 


TryToMoveRockford__NotDirt:
        ; 71d9:   c9 14      C
        P #$14
        ; 71db:   d0 03      B
        E TryToMoveRockford__NotDiamond
        ; 71dd:   4c 91 71   J
        P RockfordMovingToDiamond


TryToMoveRockford__NotDiamond:
        ; 71e0:   c9 05      C
        P #$05
        ; 71e2:   d0 0a      B
        E TryToMoveRockford__NotOutbox
        ; 71e4:   a9 02      L
        A #$02
        ; 71e6:   85 97      S
        A ExitCaveFlag
        ; 71e8:   a9 01      L
        A #$01
        ; 71ea:   85 9f      S
        A EnteredOutboxFlag
        ; 71ec:   e6 b7      I
        C RockfordMoveSucceededFlag


TryToMoveRockford__NotOutbox:
        ; 71ee:   c9 10      C
        P #$10
        ; 71f0:   d0 1e      B
        E TryToMoveRockford__Finished
        ; 71f2:   c0 28      C
        Y #$28
        ; 71f4:   d0 0b      B
        E TryToMoveRockford__NotMovingBoulderLeft
        ; 71f6:   a0 27      L
        Y #$27
        ; 71f8:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 71fa:   d0 03      B
        E TryToMoveRockford__CantMoveBoulderLeft
        ; 71fc:   20 ab 71   J
        R RockfordTriesToMoveBoulder


TryToMoveRockford__CantMoveBoulderLeft:
        ; 71ff:   a0 28      L
        Y #$28


TryToMoveRockford__NotMovingBoulderLeft:
        ; 7201:   c0 2a      C
        Y #$2a
        ; 7203:   d0 0b      B
        E TryToMoveRockford__Finished
        ; 7205:   a0 2b      L
        Y #$2b
        ; 7207:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 7209:   d0 03      B
        E TryToMoveRockford__CantMoveBoulderRight
        ; 720b:   20 ab 71   J
        R RockfordTriesToMoveBoulder


TryToMoveRockford__CantMoveBoulderRight:
        ; 720e:   a0 2a      L
        Y #$2a


TryToMoveRockford__Finished:
        ; 7210:   60         R
        S 


MoveRockfordIfPossible:
        ; 7211:   20 bd 71   J
        R TryToMoveRockford
        ; 7214:   a5 b7      L
        A RockfordMoveSucceededFlag
        ; 7216:   f0 1d      B
        Q MoveRockfordIfPossible__CantMove
        ; 7218:   20 69 6b   J
        R ReadFireButtonCurrentPlayer
        ; 721b:   d0 0a      B
        E MoveRockfordIfPossible__FireNotPressed
        ; 721d:   a9 00      L
        A #$00
        ; 721f:   20 b6 6c   J
        R SetCell
        ; 7222:   a9 00      L
        A #$00
        ; 7224:   85 b7      S
        A RockfordMoveSucceededFlag
        ; 7226:   60         R
        S 


MoveRockfordIfPossible__FireNotPressed:
        ; 7227:   a9 39      L
        A #$39
        ; 7229:   20 b6 6c   J
        R SetCell
        ; 722c:   a0 29      L
        Y #$29
        ; 722e:   a9 00      L
        A #$00
        ; 7230:   20 b6 6c   J
        R SetCell
        ; 7233:   e6 b7      I
        C RockfordMoveSucceededFlag


MoveRockfordIfPossible__CantMove:
        ; 7235:   60         R
        S 


HandleJoystickForRockford:
; 8 4 2 1
; -------
; . . . * Up    - $e (14)
; . . * . Down  - $d (13)
; . * . . Left  - $b (11)
; * . . . Right - $7 (7)
; * . . * ur    - $6 (6)
; * . * . dr    - $5 (5)
; . * * . dl    - $9 (9)
; . * . * ul    - $a (10)
        ; 7236:   c9 0d      C
        P #$0d
        ; 7238:   d0 17      B
        E HandleJoystickForRockford__NotDown


HandleJoystickForRockford__Down:
        ; 723a:   a5 e5      L
        A RockfordCellsFromTopOfScreen
        ; 723c:   c9 06      C
        P #$06
        ; 723e:   d0 05      B
        E $7245
        ; 7240:   a5 ee      L
        A ScrollDirectionY
        ; 7242:   f0 01      B
        Q $7245

; Rockford stalls here. This is a weird effect which only happens in the
; x-direction when he's moving to the right, the x-component of the scroll
; is to the left and he's at a specific x-coordinate on the screen.
        ; 7244:   60         R
        S 
        ; 7245:   a0 51      L
        Y #$51
        ; 7247:   20 11 72   J
        R MoveRockfordIfPossible
        ; 724a:   a5 b7      L
        A RockfordMoveSucceededFlag
        ; 724c:   f0 02      B
        Q $7250
        ; 724e:   e6 45      I
        C RockfordY
        ; 7250:   60         R
        S 


HandleJoystickForRockford__NotDown:
        ; 7251:   c9 0e      C
        P #$0e
        ; 7253:   d0 0c      B
        E HandleJoystickForRockford__NotUp


HandleJoystickForRockford__Up:
        ; 7255:   a0 01      L
        Y #$01
        ; 7257:   20 11 72   J
        R MoveRockfordIfPossible
        ; 725a:   a5 b7      L
        A RockfordMoveSucceededFlag
        ; 725c:   f0 02      B
        Q $7260
        ; 725e:   c6 45      D
        C RockfordY
        ; 7260:   60         R
        S 


HandleJoystickForRockford__NotUp:
        ; 7261:   c9 08      C
        P #$08
        ; 7263:   b0 1b      B
        S HandleJoystickForRockford__NotRight


HandleJoystickForRockford__Right:
; Right or any diagional that includes right.
        ; 7265:   a5 e6      L
        A RockfordCellsFromLeftOfScreen
        ; 7267:   c9 08      C
        P #$08
        ; 7269:   d0 05      B
        E $7270
        ; 726b:   a5 ea      L
        A ScrollDirectionX
        ; 726d:   f0 01      B
        Q $7270

; Rockford stalls here. This is a weird effect which only happens in the
; y-direction when he's moving down, the y-component of the scroll is up
; and he's at a specific y-coordinate on the screen.
        ; 726f:   60         R
        S 
        ; 7270:   a9 00      L
        A #$00
        ; 7272:   85 98      S
        A RockfordDir_0Right_1Left_is_sticky_
        ; 7274:   a0 2a      L
        Y #$2a
        ; 7276:   20 11 72   J
        R MoveRockfordIfPossible
        ; 7279:   a5 b7      L
        A RockfordMoveSucceededFlag
        ; 727b:   f0 02      B
        Q $727f
        ; 727d:   e6 44      I
        C RockfordX
        ; 727f:   60         R
        S 


HandleJoystickForRockford__NotRight:
        ; 7280:   c9 0c      C
        P #$0c
        ; 7282:   b0 0f      B
        S HandleJoystickForRockford__Finished


HandleJoystickForRockford__Left:
; >=$8 && <$c (not $e or $d)
; Left or any diagional that includes left.
        ; 7284:   a9 01      L
        A #$01
        ; 7286:   85 98      S
        A RockfordDir_0Right_1Left_is_sticky_
        ; 7288:   a0 28      L
        Y #$28
        ; 728a:   20 11 72   J
        R MoveRockfordIfPossible
        ; 728d:   a5 b7      L
        A RockfordMoveSucceededFlag
        ; 728f:   f0 02      B
        Q HandleJoystickForRockford__Finished
        ; 7291:   c6 44      D
        C RockfordX


HandleJoystickForRockford__Finished:
        ; 7293:   60         R
        S 

; 

ProcessRockford:
        ; 7294:   a5 a2      L
        A IsDemoMode
        ; 7296:   f0 05      B
        Q __ProcessRockford__NotDemoMode


__ProcessRockford__DemoMode:
        ; 7298:   a5 8b      L
        A JoystickStatus
        ; 729a:   4c ad 72   J
        P __ProcessRockford__Process


__ProcessRockford__NotDemoMode:
        ; 729d:   a5 a4      L
        A NumJoysticksMinusOne
        ; 729f:   25 9d      A
        D CurrentPlayer
        ; 72a1:   f0 05      B
        Q $72a8
        ; 72a3:   20 63 6b   J
        R ReadJoystickDirectionPort2

; Branch always taken.
        ; 72a6:   d0 03      B
        E $72ab
        ; 72a8:   20 5d 6b   J
        R ReadJoystickDirectionPort1
        ; 72ab:   85 8b      S
        A JoystickStatus


__ProcessRockford__Process:
        ; 72ad:   20 36 72   J
        R HandleJoystickForRockford
        ; 72b0:   a9 00      L
        A #$00
        ; 72b2:   85 96      S
        A RockfordDeadTicks
        ; 72b4:   4c 15 7e   J
        P __ProcessCave__NoObjectHandler

; These two tables are processed in one sweep by '.ProcessExplosion'.

ExplodeToSpaceObjectSequenceTable:
        ; 72b7:   1f 00 1e 1f
        1d 1e 1c 1d  1b 1c


ExplodeToDiamondObjectSequenceTable:
        ; 72c1:   24 14 23 24
        22 23 21 22  20 21

; 

PreRockfordObjectSequenceTable:
        ; 72cb:   28 38 27 28
        26 27 25 26

; 

ProcessExplosion:
        ; 72d3:   a0 29      L
        Y #$29
        ; 72d5:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 72d7:   a0 00      L
        Y #$00


ProcessExplosion__FindSequenceLoop:
        ; 72d9:   d9 b7 72   C
        P ExplodeToSpaceObjectSequenceTable,Y
        ; 72dc:   d0 03      B
        E ProcessExplosion__SequenceNotMatched
        ; 72de:   be b8 72   L
        X ExplodeToSpaceObjectSequenceTable+1,Y


ProcessExplosion__SequenceNotMatched:
        ; 72e1:   c8         I
        Y 
        ; 72e2:   c8         I
        Y 
        ; 72e3:   c0 14      C
        Y #$14
        ; 72e5:   d0 f2      B
        E ProcessExplosion__FindSequenceLoop
        ; 72e7:   8a         T
        A 
        ; 72e8:   a0 29      L
        Y #$29
        ; 72ea:   20 b6 6c   J
        R SetCell
        ; 72ed:   4c 15 7e   J
        P __ProcessCave__NoObjectHandler


ProcessRockfordsAppearance:
        ; 72f0:   a5 95      L
        A FlashingEntryBoxCountDown
        ; 72f2:   d0 1a      B
        E ProcessRockfordsAppearance__Exit
        ; 72f4:   a0 29      L
        Y #$29
        ; 72f6:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 72f8:   a0 00      L
        Y #$00


ProcessRockfordsAppearance__FindSequenceLoop:
        ; 72fa:   d9 cb 72   C
        P PreRockfordObjectSequenceTable,Y
        ; 72fd:   d0 03      B
        E ProcessRockfordsAppearance__SequenceNotMatched
        ; 72ff:   be cc 72   L
        X PreRockfordObjectSequenceTable+1,Y


ProcessRockfordsAppearance__SequenceNotMatched:
        ; 7302:   c8         I
        Y 
        ; 7303:   c8         I
        Y 
        ; 7304:   c0 08      C
        Y #$08
        ; 7306:   d0 f2      B
        E ProcessRockfordsAppearance__FindSequenceLoop
        ; 7308:   8a         T
        A 
        ; 7309:   a0 29      L
        Y #$29
        ; 730b:   20 b6 6c   J
        R SetCell


ProcessRockfordsAppearance__Exit:
        ; 730e:   4c 15 7e   J
        P __ProcessCave__NoObjectHandler


RenderSteelWallInInflatedCaveHelper:
; $2e is the base character of the first steel wall.
; There'a another at $4a.
        ; 7311:   a9 2e      L
        A #$2e
        ; 7313:   a0 00      L
        Y #$00
        ; 7315:   91 36      S
        A (InflatedCaveOutputPtr),Y
        ; 7317:   18         C
        C 
        ; 7318:   69 01      A
        C #$01
        ; 731a:   c8         I
        Y 
        ; 731b:   91 36      S
        A (InflatedCaveOutputPtr),Y
        ; 731d:   69 0f      A
        C #$0f
        ; 731f:   a0 50      L
        Y #$50
        ; 7321:   91 36      S
        A (InflatedCaveOutputPtr),Y
        ; 7323:   69 01      A
        C #$01
        ; 7325:   c8         I
        Y 
        ; 7326:   91 36      S
        A (InflatedCaveOutputPtr),Y
        ; 7328:   60         R
        S 


RenderSteelWallInInflatedCave:
        ; 7329:   a5 92      L
        A CaveMatrixY
        ; 732b:   0a         A
        L A
        ; 732c:   aa         T
        X 
        ; 732d:   a5 91      L
        A CaveMatrixX
        ; 732f:   0a         A
        L A
        ; 7330:   18         C
        C 
        ; 7331:   7d da 53   A
        C InflatedCaveLineAddressTable,X
        ; 7334:   85 34      S
        A InflatedCaveCurrentCellPtr
        ; 7336:   a9 00      L
        A #$00
        ; 7338:   7d db 53   A
        C InflatedCaveLineAddressTable+1,X
        ; 733b:   85 35      S
        A InflatedCaveCurrentCellPtr+1
        ; 733d:   20 9b 6c   J
        R SetInflatedCaveOutputPtr
        ; 7340:   20 11 73   J
        R RenderSteelWallInInflatedCaveHelper
        ; 7343:   60         R
        S 

; 

ProcessInAndOutBoxes:
        ; 7344:   a0 29      L
        Y #$29
        ; 7346:   e6 b9      I
        C FlashingEntryBoxState
        ; 7348:   a5 b9      L
        A FlashingEntryBoxState
        ; 734a:   29 01      A
        D #$01
        ; 734c:   d0 0c      B
        E __ProcessInAndOutBoxes__Steel

; Render cell from lattice to Inflated cave.
; Is either cell $05[E] (outbox) or $25[%] (inbox),
; both of which map to (via .BaseCharNoForObjectTable)
; a hollow box.

__ProcessInAndOutBoxes__Door:
        ; 734e:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 7350:   20 b6 6c   J
        R SetCell

; If it's the inbox do some extra processing to arrange
; Rockford's appearence.
        ; 7353:   c9 25      C
        P #$25
        ; 7355:   d0 06      B
        E __ProcessInAndOutBoxes__Exit
        ; 7357:   4c f0 72   J
        P ProcessRockfordsAppearance


__ProcessInAndOutBoxes__Steel:
        ; 735a:   20 29 73   J
        R RenderSteelWallInInflatedCave


__ProcessInAndOutBoxes__Exit:
        ; 735d:   4c 15 7e   J
        P __ProcessCave__NoObjectHandler

; 

ProcessStationaryBoulder:
        ; 7360:   a0 51      L
        Y #$51
        ; 7362:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 7364:   d0 0b      B
        E ProcessStationaryBoulder__NoSpaceBelow

; $13 = Scanned falling boulder
        ; 7366:   a9 13      L
        A #$13
        ; 7368:   20 b6 6c   J
        R SetCell
        ; 736b:   20 56 6e   J
        R FallingBoulderSoundFX
        ; 736e:   4c d7 6c   J
        P __ProcessCave__ClearCurrentCell


ProcessStationaryBoulder__NoSpaceBelow:
        ; 7371:   a0 51      L
        Y #$51
        ; 7373:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 7375:   20 65 6e   J
        R TestIfObjectSlippery
        ; 7378:   d0 28      B
        E ProcessStationaryBoulder__Finished
        ; 737a:   a0 50      L
        Y #$50
        ; 737c:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 737e:   d0 0e      B
        E ProcessStationaryBoulder__CantFallLeft
        ; 7380:   a0 28      L
        Y #$28
        ; 7382:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 7384:   d0 08      B
        E ProcessStationaryBoulder__CantFallLeft
        ; 7386:   a9 13      L
        A #$13
        ; 7388:   20 b6 6c   J
        R SetCell
        ; 738b:   4c d7 6c   J
        P __ProcessCave__ClearCurrentCell


ProcessStationaryBoulder__CantFallLeft:
        ; 738e:   a0 52      L
        Y #$52
        ; 7390:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 7392:   d0 0e      B
        E ProcessStationaryBoulder__Finished
        ; 7394:   a0 2a      L
        Y #$2a
        ; 7396:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 7398:   d0 08      B
        E ProcessStationaryBoulder__Finished
        ; 739a:   a9 13      L
        A #$13
        ; 739c:   20 b6 6c   J
        R SetCell
        ; 739f:   4c d7 6c   J
        P __ProcessCave__ClearCurrentCell


ProcessStationaryBoulder__Finished:
        ; 73a2:   4c 15 7e   J
        P __ProcessCave__NoObjectHandler


CreateScannedStationaryBoulder:
        ; 73a5:   a0 29      L
        Y #$29
        ; 73a7:   a9 11      L
        A #$11
        ; 73a9:   20 b6 6c   J
        R SetCell
        ; 73ac:   60         R
        S 


ProcessFallingBoulder:
        ; 73ad:   a0 51      L
        Y #$51
        ; 73af:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 73b1:   d0 08      B
        E ProcessFallingBoulder__NoSpaceBelow

; $13 = Scanned falling boulder
        ; 73b3:   a9 13      L
        A #$13
        ; 73b5:   20 b6 6c   J
        R SetCell
        ; 73b8:   4c d7 6c   J
        P __ProcessCave__ClearCurrentCell


ProcessFallingBoulder__NoSpaceBelow:
        ; 73bb:   c9 03      C
        P #$03
        ; 73bd:   d0 21      B
        E ProcessFallingBoulder__NoMagicWallBelow
        ; 73bf:   a5 8d      L
        A MagicWallActiveState
        ; 73c1:   d0 04      B
        E ProcessFallingBoulder__MagicWallAlreadyActivated
        ; 73c3:   a9 01      L
        A #$01
        ; 73c5:   85 8d      S
        A MagicWallActiveState


ProcessFallingBoulder__MagicWallAlreadyActivated:
        ; 73c7:   c9 01      C
        P #$01
        ; 73c9:   d0 0b      B
        E ProcessFallingBoulder__ClearBoulderAboveMagicWall
        ; 73cb:   a0 79      L
        Y #$79
        ; 73cd:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 73cf:   d0 05      B
        E ProcessFallingBoulder__ClearBoulderAboveMagicWall

; $17 = Scanned falling diamond
        ; 73d1:   a9 17      L
        A #$17
        ; 73d3:   20 b6 6c   J
        R SetCell


ProcessFallingBoulder__ClearBoulderAboveMagicWall:
        ; 73d6:   a9 00      L
        A #$00
        ; 73d8:   a0 29      L
        Y #$29
        ; 73da:   20 b6 6c   J
        R SetCell

; NOTE: When a diamond is consumed my a magic wall the current scan is aborted.
        ; 73dd:   4c 28 6e   J
        P FallingDiamondSoundFX


ProcessFallingBoulder__NoMagicWallBelow:
        ; 73e0:   20 56 6e   J
        R FallingBoulderSoundFX
        ; 73e3:   a0 51      L
        Y #$51
        ; 73e5:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 73e7:   20 65 6e   J
        R TestIfObjectSlippery
        ; 73ea:   d0 2e      B
        E ProcessFallingBoulder__NotSlipperyHit
        ; 73ec:   a0 50      L
        Y #$50
        ; 73ee:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 73f0:   d0 0e      B
        E ProcessFallingBoulder__CantFallLeft
        ; 73f2:   a0 28      L
        Y #$28
        ; 73f4:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 73f6:   d0 08      B
        E ProcessFallingBoulder__CantFallLeft
        ; 73f8:   a9 13      L
        A #$13
        ; 73fa:   20 b6 6c   J
        R SetCell
        ; 73fd:   4c d7 6c   J
        P __ProcessCave__ClearCurrentCell


ProcessFallingBoulder__CantFallLeft:
        ; 7400:   a0 52      L
        Y #$52
        ; 7402:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 7404:   d0 0e      B
        E ProcessFallingBoulder__CantFallRight
        ; 7406:   a0 2a      L
        Y #$2a
        ; 7408:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 740a:   d0 08      B
        E ProcessFallingBoulder__CantFallRight
        ; 740c:   a9 13      L
        A #$13
        ; 740e:   20 b6 6c   J
        R SetCell
        ; 7411:   4c d7 6c   J
        P __ProcessCave__ClearCurrentCell


ProcessFallingBoulder__CantFallRight:
        ; 7414:   20 a5 73   J
        R CreateScannedStationaryBoulder
        ; 7417:   4c 15 7e   J
        P __ProcessCave__NoObjectHandler


ProcessFallingBoulder__NotSlipperyHit:
        ; 741a:   c9 38      C
        P #$38
        ; 741c:   d0 0a      B
        E ProcessFallingBoulder__DidntHitRockford
        ; 741e:   a9 1c      L
        A #$1c
        ; 7420:   85 89      S
        A ObjectTypeForUpdateCaveCell
        ; 7422:   20 22 6d   J
        R Explode3x3CellsDownOneRow
        ; 7425:   4c 15 7e   J
        P __ProcessCave__NoObjectHandler


ProcessFallingBoulder__DidntHitRockford:
        ; 7428:   20 7c 6e   J
        R CheckIfFallingObjectKillsAnimal
        ; 742b:   d0 06      B
        E ProcessFallingBoulder__DidntHitAnimal
        ; 742d:   20 22 6d   J
        R Explode3x3CellsDownOneRow
        ; 7430:   4c 15 7e   J
        P __ProcessCave__NoObjectHandler


ProcessFallingBoulder__DidntHitAnimal:
        ; 7433:   20 a5 73   J
        R CreateScannedStationaryBoulder
        ; 7436:   4c 15 7e   J
        P __ProcessCave__NoObjectHandler


BlankLines0and4ofSpaceChars:
        ; 7439:   a9 00      L
        A #$00
        ; 743b:   8d 00 33   S
        A CopiedGameCharData+$200
        ; 743e:   8d 04 33   S
        A CopiedGameCharData+$204
        ; 7441:   8d 08 33   S
        A CopiedGameCharData+$208
        ; 7444:   8d 0c 33   S
        A CopiedGameCharData+$20c
        ; 7447:   8d 80 33   S
        A CopiedGameCharData+$280
        ; 744a:   8d 84 33   S
        A CopiedGameCharData+$284
        ; 744d:   8d 88 33   S
        A CopiedGameCharData+$288
        ; 7450:   8d 8c 33   S
        A CopiedGameCharData+$28c
        ; 7453:   60         R
        S 

; 

ExtraLifeFX:
        ; 7454:   a5 a8      L
        A ExtraLifeFXCounter
        ; 7456:   c9 01      C
        P #$01
        ; 7458:   d0 06      B
        E __ExtraLifeFX__DoFX__
        ; 745a:   20 39 74   J
        R BlankLines0and4ofSpaceChars
        ; 745d:   c6 a8      D
        C ExtraLifeFXCounter
        ; 745f:   60         R
        S 

; 

__ExtraLifeFX__DoFX__:
        ; 7460:   20 d0 6a   J
        R TimeBasedRandomNumber
        ; 7463:   8d 00 33   S
        A CopiedGameCharData+$200
        ; 7466:   8d 0c 33   S
        A CopiedGameCharData+$20c
        ; 7469:   20 d0 6a   J
        R TimeBasedRandomNumber
        ; 746c:   8d 84 33   S
        A CopiedGameCharData+$284
        ; 746f:   8d 88 33   S
        A CopiedGameCharData+$288
        ; 7472:   20 d0 6a   J
        R TimeBasedRandomNumber
        ; 7475:   8d 04 33   S
        A CopiedGameCharData+$204
        ; 7478:   8d 08 33   S
        A CopiedGameCharData+$208
        ; 747b:   20 d0 6a   J
        R TimeBasedRandomNumber
        ; 747e:   8d 80 33   S
        A CopiedGameCharData+$280
        ; 7481:   8d 8c 33   S
        A CopiedGameCharData+$28c
        ; 7484:   c6 a8      D
        C ExtraLifeFXCounter
        ; 7486:   60         R
        S 

; 

ScrollingBGTick:
        ; 7487:   ac 00 20   L
        Y CopiedTitleChar
        ; 748a:   a2 00      L
        X #$00


_AnimateBkgndLoop:
        ; 748c:   bd 01 20   L
        A CopiedTitleChar+1,X
        ; 748f:   9d 00 20   S
        A CopiedTitleChar,X
        ; 7492:   e8         I
        X 
        ; 7493:   e0 07      C
        X #$07
        ; 7495:   d0 f5      B
        E _AnimateBkgndLoop
        ; 7497:   8c 07 20   S
        Y CopiedTitleChar+7
        ; 749a:   60         R
        S 

; 

YScrollTable:
        ; 749b:   03 c0 ff 07
        00 00 08 00  00 0c 40 00


XScrollTable:
        ; 74a7:   03 c0 ff 09
        00 00 0a 00  00 10 40 00

; 

CalcScrollOffsets_XIfNeeded_YIfNeeded:
        ; 74b3:   a5 e1      L
        A XScrollTableIndex
        ; 74b5:   d0 0e      B
        E $74c5
        ; 74b7:   a5 e2      L
        A XCoarseScrollDirFlag
        ; 74b9:   d0 0a      B
        E $74c5

; 

CalcXScrollOffsets_X_YIfNeeded:
        ; 74bb:   a5 e8      L
        A ScreenLeft
        ; 74bd:   4a         L
        R A
        ; 74be:   49 ff      E
        R #$ff
        ; 74c0:   38         S
        C 
        ; 74c1:   65 44      A
        C RockfordX

; These instructions produce the same result as:
; 1. LDA .ScreenLeft
; 2. LSR A
; 3. EOR #$ff
; 5. CLC
; 6. ADC #$01
; 7. CLC
; 8. ADC .unsure_RockfordX
; Steps 1-2 : A = .ScreenLeft/2 (convert from chars to cells)
; Steps 3-6 : A = -A
; Steps 7-8 : A = A + .RockfordX
; So : A = .RockfordX - .ScreenLeft/2
        ; 74c3:   85 e6      S
        A RockfordCellsFromLeftOfScreen

; 
        ; 74c5:   a5 e3      L
        A YScrollTableIndex
        ; 74c7:   d0 0e      B
        E $74d7
        ; 74c9:   a5 e4      L
        A YCoarseScrollDirFlag
        ; 74cb:   d0 0a      B
        E $74d7

; 

CalcYScrollOffsets_Y:
        ; 74cd:   a5 ec      L
        A ScreenTop
        ; 74cf:   4a         L
        R A
        ; 74d0:   49 ff      E
        R #$ff
        ; 74d2:   38         S
        C 
        ; 74d3:   65 45      A
        C RockfordY
        ; 74d5:   85 e5      S
        A RockfordCellsFromTopOfScreen
        ; 74d7:   60         R
        S 

; 

XScrollVicCtl2Table:
        ; 74d8:   15 13 11 17
        


YScrollVicCtl1Table:
; Higher indices scroll up (Rockford moving down).
        ; 74dc:   17 15 13 11
        

; 

ScheduleYScroll:
        ; 74e0:   a5 e3      L
        A YScrollTableIndex
        ; 74e2:   d0 11      B
        E __ScheduleYScroll__ContinueScroll
        ; 74e4:   a5 e4      L
        A YCoarseScrollDirFlag
        ; 74e6:   d0 0d      B
        E __ScheduleYScroll__ContinueScroll
        ; 74e8:   a5 c2      L
        A AnotherFrameCounter
        ; 74ea:   29 01      A
        D #$01
        ; 74ec:   f0 01      B
        Q __ScheduleYScroll__StartScroll
        ; 74ee:   60         R
        S 


__ScheduleYScroll__StartScroll:
; We only start a scroll if .AnotherFrameCounter is even.
; This is important to keep the scrolling logic in sync with the rest of the IRQ handler.
; (IRQ handler flips buffers on even frames and copies the visible section of the inflated
; cave the the back buffer on odd frames.)
; 
; .FineScrollDirY: $40 up, $c0 down.
        ; 74ef:   a5 ed      L
        A FineScrollDirY
        ; 74f1:   c9 c0      C
        P #$c0
        ; 74f3:   f0 4d      B
        Q __ScheduleYScroll__DownOneChar


__ScheduleYScroll__ContinueScroll:
        ; 74f5:   a5 eb      L
        A FineScrollY
        ; 74f7:   18         C
        C 
        ; 74f8:   65 ed      A
        C FineScrollDirY
        ; 74fa:   85 eb      S
        A FineScrollY

; // THE C FLAG IS ALL-IMPORTANT HERE!
        ; 74fc:   a5 ec      L
        A ScreenTop
        ; 74fe:   65 ee      A
        C ScrollDirectionY
        ; 7500:   85 ec      S
        A ScreenTop
        ; 7502:   a5 eb      L
        A FineScrollY
        ; 7504:   18         C
        C 
        ; 7505:   2a         R
        L A
        ; 7506:   2a         R
        L A
        ; 7507:   2a         R
        L A
        ; 7508:   2a         R
        L A
        ; 7509:   29 07      A
        D #$07
        ; 750b:   4a         L
        R A
        ; 750c:   85 e3      S
        A YScrollTableIndex
        ; 750e:   aa         T
        X 
        ; 750f:   bd dc 74   L
        A YScrollVicCtl1Table,X

; It is important to realise that this is the $d011 setting for the NEXT frame.
; $d011 has already been set from .RastInt_vic_control1 earlier in the handler.
        ; 7512:   85 54      S
        A RastInt_vic_control1
        ; 7514:   a5 e3      L
        A YScrollTableIndex
        ; 7516:   c9 01      C
        P #$01

; "Why compare to 1?", you ask:
; ============================================================================================
; 
; Let's assume we've just initiated a scroll.
; n is always even since scrolling only starts on even frames.
; 
; Frame n+0 (this frame):
; -----------------------
; 1) .RastInt_vic_control1 = .YScrollVicCtl1Table[1] ($15)
; This setting takes effect in the next frame.
; The previous setting was .YScrollVicCtl1Table[0] ($17), the resting state when not scrolling.
; 
; 2) We change .InflatedCaveSubsetPtrH & InflatedCaveSubsetPtrL.
; Since the Inflated Cave is copied to the back buffer on odd frames and it then has to be
; flipped to the front, which happens in even frames, this change will not be seen for a bit.
; This is why we do it at what seems like a strange fine scroll value (not an extreme).
; 
; 3). Our caller flips the buffers (since we're an even frame).
; 
; Frame n+1:
; ----------
; The $d011 value set during in frame n+0 ($15) is now in effect.
; 
; 1) .RastInt_vic_control1 = .YScrollVicCtl1Table[2] ($13)
; 
; 2) Our caller copies the Inflated Cave to the back buffer.
; The back buffer now reflects the changes made in frame n+0 step 2.
; It is not visible yet however as it has to be flipped to the front.
; 
; Frame n+2:
; ----------
; The $d011 value set during in frame n+1 ($13) is now in effect.
; We have looped! That means we need a coarse scroll.
; The sequence is 4, 5, 6, 7, 0, 1, 2, 3 because of bad line strangeness
; due to the screen splitting. Boulder Dash only uses 5, 7, 1, 3.
; 
; 1) .RastInt_vic_control1 = .YScrollVicCtl1Table[3] ($11)
; 
; 2) Our caller flips the buffers. The changes made in frame n+0 step 2 are now visible,
; just when we need them!
        ; 7518:   d0 11      B
        E $752b
        ; 751a:   a5 e4      L
        A YCoarseScrollDirFlag
        ; 751c:   d0 0d      B
        E $752b


__ScheduleYScroll__UpOneChar:
; Stuff on screen moves up, Rockford moving down.
        ; 751e:   a5 d6      L
        A InflatedCaveSubset
        ; 7520:   18         C
        C 
        ; 7521:   69 50      A
        C #$50
        ; 7523:   85 d6      S
        A InflatedCaveSubset
        ; 7525:   a5 d7      L
        A InflatedCaveSubset+1
        ; 7527:   69 00      A
        C #$00
        ; 7529:   85 d7      S
        A InflatedCaveSubset+1
        ; 752b:   a5 e3      L
        A YScrollTableIndex
        ; 752d:   d0 25      B
        E $7554
        ; 752f:   a5 e4      L
        A YCoarseScrollDirFlag
        ; 7531:   c9 01      C
        P #$01
        ; 7533:   d0 1f      B
        E $7554
        ; 7535:   20 cd 74   J
        R CalcYScrollOffsets_Y
        ; 7538:   a5 ec      L
        A ScreenTop
        ; 753a:   f0 18      B
        Q $7554
        ; 753c:   a5 e5      L
        A RockfordCellsFromTopOfScreen
        ; 753e:   c9 07      C
        P #$07
        ; 7540:   f0 12      B
        Q $7554


__ScheduleYScroll__DownOneChar:
; Stuff on screen moves down, Rockford moving up.
; 
; Things are slightly different when scrolling down (Rockford going up). We start scrolling on an
; even frame and under these conditions, as explained above. The fine scroll changes take one frame
; to reach the screen and the coarse scroll changes take two frames. The $d011 scroll settings to
; scroll up are 5, 7, 1 & 3, we rest on 7. Since the coarse scroll path is two frames we schedule a
; coarse scroll this frame but hold off scheduling a fine scroll till the next frame (which takes
; only one frame). This means it takes two frames to initiate an upward scroll whereas scrolling
; down takes one.
        ; 7542:   a5 d6      L
        A InflatedCaveSubset
        ; 7544:   38         S
        C 
        ; 7545:   e9 50      S
        C #$50
        ; 7547:   85 d6      S
        A InflatedCaveSubset
        ; 7549:   a5 d7      L
        A InflatedCaveSubset+1
        ; 754b:   e9 00      S
        C #$00
        ; 754d:   85 d7      S
        A InflatedCaveSubset+1
        ; 754f:   a9 03      L
        A #$03
        ; 7551:   85 e4      S
        A YCoarseScrollDirFlag
        ; 7553:   60         R
        S 
        ; 7554:   a5 e3      L
        A YScrollTableIndex
        ; 7556:   85 e4      S
        A YCoarseScrollDirFlag
        ; 7558:   60         R
        S 

; 

ScheduleXScroll:
        ; 7559:   a5 e1      L
        A XScrollTableIndex
        ; 755b:   d0 11      B
        E $756e
        ; 755d:   a5 e2      L
        A XCoarseScrollDirFlag
        ; 755f:   d0 0d      B
        E $756e
        ; 7561:   a5 c2      L
        A AnotherFrameCounter
        ; 7563:   29 01      A
        D #$01
        ; 7565:   f0 01      B
        Q $7568
        ; 7567:   60         R
        S 
        ; 7568:   a5 e9      L
        A FineScrollDirX
        ; 756a:   c9 c0      C
        P #$c0
        ; 756c:   f0 50      B
        Q $75be
        ; 756e:   a5 e7      L
        A FineScrollX
        ; 7570:   18         C
        C 
        ; 7571:   65 e9      A
        C FineScrollDirX
        ; 7573:   85 e7      S
        A FineScrollX
        ; 7575:   a5 e8      L
        A ScreenLeft
        ; 7577:   65 ea      A
        C ScrollDirectionX
        ; 7579:   85 e8      S
        A ScreenLeft
        ; 757b:   a5 e7      L
        A FineScrollX
        ; 757d:   18         C
        C 
        ; 757e:   2a         R
        L A
        ; 757f:   2a         R
        L A
        ; 7580:   2a         R
        L A
        ; 7581:   29 03      A
        D #$03
        ; 7583:   85 e1      S
        A XScrollTableIndex
        ; 7585:   aa         T
        X 
        ; 7586:   bd d8 74   L
        A XScrollVicCtl2Table,X
        ; 7589:   a6 95      L
        X FlashingEntryBoxCountDown
        ; 758b:   d0 08      B
        E $7595
        ; 758d:   a6 5d      L
        X Cave
        ; 758f:   e0 11      C
        X #$11
        ; 7591:   90 02      B
        C $7595
        ; 7593:   09 08      O
        A #$08
        ; 7595:   85 56      S
        A RastInt_vic_control2
        ; 7597:   a5 e1      L
        A XScrollTableIndex
        ; 7599:   c9 01      C
        P #$01
        ; 759b:   d0 0a      B
        E $75a7
        ; 759d:   a5 e2      L
        A XCoarseScrollDirFlag
        ; 759f:   d0 06      B
        E $75a7
        ; 75a1:   e6 d6      I
        C InflatedCaveSubset
        ; 75a3:   d0 02      B
        E $75a7
        ; 75a5:   e6 d7      I
        C InflatedCaveSubset+1
        ; 75a7:   a5 e1      L
        A XScrollTableIndex
        ; 75a9:   d0 25      B
        E $75d0
        ; 75ab:   a5 e2      L
        A XCoarseScrollDirFlag
        ; 75ad:   c9 01      C
        P #$01
        ; 75af:   d0 1f      B
        E $75d0
        ; 75b1:   20 bb 74   J
        R CalcXScrollOffsets_X_YIfNeeded
        ; 75b4:   a5 e8      L
        A ScreenLeft
        ; 75b6:   f0 18      B
        Q $75d0
        ; 75b8:   a5 e6      L
        A RockfordCellsFromLeftOfScreen
        ; 75ba:   c9 09      C
        P #$09
        ; 75bc:   f0 12      B
        Q $75d0
        ; 75be:   a5 d6      L
        A InflatedCaveSubset
        ; 75c0:   38         S
        C 
        ; 75c1:   e9 01      S
        C #$01
        ; 75c3:   85 d6      S
        A InflatedCaveSubset
        ; 75c5:   a5 d7      L
        A InflatedCaveSubset+1
        ; 75c7:   e9 00      S
        C #$00
        ; 75c9:   85 d7      S
        A InflatedCaveSubset+1
        ; 75cb:   a9 03      L
        A #$03
        ; 75cd:   85 e2      S
        A XCoarseScrollDirFlag
        ; 75cf:   60         R
        S 
        ; 75d0:   a5 e1      L
        A XScrollTableIndex
        ; 75d2:   85 e2      S
        A XCoarseScrollDirFlag
        ; 75d4:   60         R
        S 

; 

StopScrollingAtEdges:
        ; 75d5:   a2 00      L
        X #$00


__StopScrollingAtEdges__ClipYDir:
; We only stop the scroll if we've fine scrolled right up to the edge.
        ; 75d7:   a5 eb      L
        A FineScrollY
        ; 75d9:   d0 18      B
        E __StopScrollingAtEdges__ClipXDir
        ; 75db:   a5 ec      L
        A ScreenTop
        ; 75dd:   d0 08      B
        E __StopScrollingAtEdges__NotScrolledFullyDown


__StopScrollingAtEdges__ScrolledFullyUp:
        ; 75df:   a4 ee      L
        Y ScrollDirectionY
        ; 75e1:   f0 04      B
        Q __StopScrollingAtEdges__NotScrolledFullyDown


__StopScrollingAtEdges__DirUp:
; Stop the Y-scroll.
        ; 75e3:   86 ed      S
        X FineScrollDirY
        ; 75e5:   86 ee      S
        X ScrollDirectionY


__StopScrollingAtEdges__NotScrolledFullyDown:
        ; 75e7:   c9 15      C
        P #$15
        ; 75e9:   d0 08      B
        E __StopScrollingAtEdges__ClipXDir


__StopScrollingAtEdges__ScrolledFullyUp2:
        ; 75eb:   a4 ee      L
        Y ScrollDirectionY
        ; 75ed:   d0 04      B
        E __StopScrollingAtEdges__ClipXDir


__StopScrollingAtEdges__DirUp2:
; Stop the Y-scroll.
        ; 75ef:   86 ed      S
        X FineScrollDirY
        ; 75f1:   86 ee      S
        X ScrollDirectionY

; 

__StopScrollingAtEdges__ClipXDir:
; We only stop the scroll if we've fine scrolled right up to the edge.
        ; 75f3:   a5 e7      L
        A FineScrollX
        ; 75f5:   d0 18      B
        E __StopScrollingAtEdges__Exit
        ; 75f7:   a5 e8      L
        A ScreenLeft
        ; 75f9:   d0 08      B
        E $7603


__StopScrollingAtEdges__ScrolledFullyRight:
        ; 75fb:   a4 ea      L
        Y ScrollDirectionX
        ; 75fd:   f0 04      B
        Q $7603


__StopScrollingAtEdges__DirLeft:
; Stop the X-scroll.
        ; 75ff:   86 e9      S
        X FineScrollDirX
        ; 7601:   86 ea      S
        X ScrollDirectionX

; 
        ; 7603:   c9 2a      C
        P #$2a
        ; 7605:   d0 08      B
        E __StopScrollingAtEdges__Exit


__StopScrollingAtEdges__ScrolledFullyLeft:
        ; 7607:   a4 ea      L
        Y ScrollDirectionX
        ; 7609:   d0 04      B
        E __StopScrollingAtEdges__Exit


__StopScrollingAtEdges__DirRight:
; Stop the X-scroll.
        ; 760b:   86 e9      S
        X FineScrollDirX
        ; 760d:   86 ea      S
        X ScrollDirectionX

; 

__StopScrollingAtEdges__Exit:
        ; 760f:   60         R
        S 

; 

ChooseYScrollDirection:
        ; 7610:   a5 e5      L
        A RockfordCellsFromTopOfScreen
        ; 7612:   c9 0b      C
        P #$0b
        ; 7614:   30 08      B
        I $761e

; Scroll down if Rockford is >=11 cells from top.

__ChooseYScrollDirection__Up:
        ; 7616:   a9 40      L
        A #$40
        ; 7618:   85 ed      S
        A FineScrollDirY
        ; 761a:   a9 00      L
        A #$00
        ; 761c:   85 ee      S
        A ScrollDirectionY
        ; 761e:   a5 e5      L
        A RockfordCellsFromTopOfScreen
        ; 7620:   c9 05      C
        P #$05
        ; 7622:   10 08      B
        L $762c

; Scroll up if Rockford is <5 cells from top.

__ChooseYScrollDirection__Down:
        ; 7624:   a9 c0      L
        A #$c0
        ; 7626:   85 ed      S
        A FineScrollDirY
        ; 7628:   a9 ff      L
        A #$ff
        ; 762a:   85 ee      S
        A ScrollDirectionY
        ; 762c:   60         R
        S 


ChooseXScrollDirection:
        ; 762d:   a5 e6      L
        A RockfordCellsFromLeftOfScreen
        ; 762f:   c9 11      C
        P #$11
        ; 7631:   30 08      B
        I $763b

; Scroll right if Rockford >=17 cells from left.

__ChooseXScrollDirection__Left:
        ; 7633:   a9 40      L
        A #$40
        ; 7635:   85 e9      S
        A FineScrollDirX
        ; 7637:   a9 00      L
        A #$00
        ; 7639:   85 ea      S
        A ScrollDirectionX
        ; 763b:   a5 e6      L
        A RockfordCellsFromLeftOfScreen
        ; 763d:   c9 03      C
        P #$03
        ; 763f:   10 08      B
        L $7649

; Scroll left if Rockford <3 cells from left.

__ChooseXScrollDirection__Right:
        ; 7641:   a9 c0      L
        A #$c0
        ; 7643:   85 e9      S
        A FineScrollDirX
        ; 7645:   a9 ff      L
        A #$ff
        ; 7647:   85 ea      S
        A ScrollDirectionX
        ; 7649:   60         R
        S 


ChooseScrollDirection:
        ; 764a:   a0 09      L
        Y #$09
        ; 764c:   a2 04      L
        X #$04


__ChooseScrollDirection__YLoop:
        ; 764e:   a5 e5      L
        A RockfordCellsFromTopOfScreen
        ; 7650:   d9 9b 74   C
        P YScrollTable,Y
        ; 7653:   d0 0a      B
        E __ChooseScrollDirection__YNoMatch


__ChooseScrollDirection__YMatch:
        ; 7655:   b9 9c 74   L
        A YScrollTable+1,Y
        ; 7658:   85 ed      S
        A FineScrollDirY
        ; 765a:   b9 9d 74   L
        A YScrollTable+2,Y
        ; 765d:   85 ee      S
        A ScrollDirectionY


__ChooseScrollDirection__YNoMatch:
        ; 765f:   a5 ec      L
        A ScreenTop
        ; 7661:   f0 0f      B
        Q __ChooseScrollDirection__YNext
        ; 7663:   a5 ed      L
        A FineScrollDirY
        ; 7665:   d0 0b      B
        E __ChooseScrollDirection__YNext
        ; 7667:   a5 95      L
        A FlashingEntryBoxCountDown
        ; 7669:   f0 07      B
        Q __ChooseScrollDirection__YNext
        ; 766b:   a5 e5      L
        A RockfordCellsFromTopOfScreen
        ; 766d:   d9 9b 74   C
        P YScrollTable,Y
        ; 7670:   90 e3      B
        C __ChooseScrollDirection__YMatch


__ChooseScrollDirection__YNext:
        ; 7672:   88         D
        Y 
        ; 7673:   88         D
        Y 
        ; 7674:   88         D
        Y 
        ; 7675:   ca         D
        X 
        ; 7676:   d0 d6      B
        E __ChooseScrollDirection__YLoop
        ; 7678:   20 10 76   J
        R ChooseYScrollDirection
        ; 767b:   a0 09      L
        Y #$09
        ; 767d:   a2 04      L
        X #$04
        ; 767f:   a5 e6      L
        A RockfordCellsFromLeftOfScreen
        ; 7681:   d9 a7 74   C
        P XScrollTable,Y
        ; 7684:   d0 0a      B
        E $7690
        ; 7686:   b9 a8 74   L
        A XScrollTable+1,Y
        ; 7689:   85 e9      S
        A FineScrollDirX
        ; 768b:   b9 a9 74   L
        A XScrollTable+2,Y
        ; 768e:   85 ea      S
        A ScrollDirectionX
        ; 7690:   a5 e8      L
        A ScreenLeft
        ; 7692:   f0 0f      B
        Q $76a3
        ; 7694:   a5 e9      L
        A FineScrollDirX
        ; 7696:   d0 0b      B
        E $76a3
        ; 7698:   a5 95      L
        A FlashingEntryBoxCountDown
        ; 769a:   f0 07      B
        Q $76a3
        ; 769c:   a5 e6      L
        A RockfordCellsFromLeftOfScreen
        ; 769e:   d9 a7 74   C
        P XScrollTable,Y
        ; 76a1:   90 e3      B
        C $7686
        ; 76a3:   88         D
        Y 
        ; 76a4:   88         D
        Y 
        ; 76a5:   88         D
        Y 
        ; 76a6:   ca         D
        X 
        ; 76a7:   d0 d6      B
        E $767f
        ; 76a9:   20 2d 76   J
        R ChooseXScrollDirection
        ; 76ac:   60         R
        S 

; 

Scroller:
        ; 76ad:   a5 a6      L
        A IsBonusLevelFlag
        ; 76af:   f0 05      B
        Q __Scroller__DoScroll
        ; 76b1:   a5 95      L
        A FlashingEntryBoxCountDown
        ; 76b3:   d0 01      B
        E __Scroller__DoScroll
        ; 76b5:   60         R
        S 


__Scroller__DoScroll:
        ; 76b6:   20 b3 74   J
        R CalcScrollOffsets_XIfNeeded_YIfNeeded
        ; 76b9:   20 4a 76   J
        R ChooseScrollDirection
        ; 76bc:   20 d5 75   J
        R StopScrollingAtEdges
        ; 76bf:   20 59 75   J
        R ScheduleXScroll
        ; 76c2:   20 e0 74   J
        R ScheduleYScroll
        ; 76c5:   60         R
        S 

; 

AdvanceCaveCurrentCellPtr:
        ; 76c6:   e6 32      I
        C CaveCurrentCellPtr
        ; 76c8:   d0 02      B
        E $76cc
        ; 76ca:   e6 33      I
        C CaveCurrentCellPtr+1
        ; 76cc:   60         R
        S 

; IN: ZF, A
; 
; .CaveCurrentCellPtr(???) points to the NW cell ($00).
; The current cell C is at an offset of $29. See table below:
; ---------------------
; |NW:$00|N:$01|NE:$02|
; |------+-----+------|
; | W:$28|C:$29| E:$2a|
; |------+-----+------|
; |SW:$50|S:$51|SE:$52|
; |======+=====+======|
; |   $78|  $79|   $7a|
; ---------------------

ResetCaveCurrentCellPtr:
        ; 76cd:   f0 02      B
        Q $76d1
        ; 76cf:   a9 28      L
        A #$28
        ; 76d1:   18         C
        C 
        ; 76d2:   69 27      A
        C #$27
        ; 76d4:   85 32      S
        A CaveCurrentCellPtr
        ; 76d6:   a9 08      L
        A #$08
        ; 76d8:   85 33      S
        A CaveCurrentCellPtr+1
        ; 76da:   60         R
        S 

; 

FillInflatedCaveWithScrollingSteelWallChar:
        ; 76db:   a2 00      L
        X #$00
        ; 76dd:   bd da 53   L
        A InflatedCaveLineAddressTable,X
        ; 76e0:   85 34      S
        A InflatedCaveCurrentCellPtr
        ; 76e2:   bd db 53   L
        A InflatedCaveLineAddressTable+1,X
        ; 76e5:   85 35      S
        A InflatedCaveCurrentCellPtr+1
        ; 76e7:   a0 00      L
        Y #$00
        ; 76e9:   a9 7c      L
        A #$7c
        ; 76eb:   91 34      S
        A (InflatedCaveCurrentCellPtr),Y
        ; 76ed:   c8         I
        Y 

; $a0(160) is two character lines (each cell is 2x2).
        ; 76ee:   c0 a0      C
        Y #$a0
        ; 76f0:   d0 f9      B
        E $76eb
        ; 76f2:   e8         I
        X 
        ; 76f3:   e8         I
        X 
        ; 76f4:   e0 2c      C
        X #$2c
        ; 76f6:   d0 e5      B
        E $76dd
        ; 76f8:   60         R
        S 

; 

CoverLevel:
; Build a line address table for currently visible
; portion of empanded lattice.
        ; 76f9:   a5 d6      L
        A InflatedCaveSubset
        ; 76fb:   85 02      S
        A __CoverLevel__LineAddressTable
        ; 76fd:   a5 d7      L
        A InflatedCaveSubset+1
        ; 76ff:   85 03      S
        A __CoverLevel__LineAddressTable+1
        ; 7701:   a2 00      L
        X #$00
        ; 7703:   b5 02      L
        A __CoverLevel__LineAddressTable,X
        ; 7705:   18         C
        C 
        ; 7706:   69 50      A
        C #$50
        ; 7708:   95 04      S
        A __CoverLevel__LineAddressTable+2,X
        ; 770a:   b5 03      L
        A __CoverLevel__LineAddressTable+1,X
        ; 770c:   69 00      A
        C #$00
        ; 770e:   95 05      S
        A __CoverLevel__LineAddressTable+3,X
        ; 7710:   e8         I
        X 
        ; 7711:   e8         I
        X 
        ; 7712:   e0 2e      C
        X #$2e
        ; 7714:   d0 ed      B
        E $7703

; 
        ; 7716:   a9 00      L
        A #$00

; Not used as CellX. Is a simple loop counter.
        ; 7718:   85 91      S
        A CaveMatrixX


__CoverLevel__Outer:
        ; 771a:   a2 00      L
        X #$00


__CoverLevel__Inner:
        ; 771c:   a9 00      L
        A #$00

; .CoverLevel::__POINTLESS really is totally pointless. The game does
; both read and write it but it has no effect. We never actually get
; to $7736 and even if we did we'd simply fall through to
; .__CoverLevel__PointlessBranchTarget. I suspect that during development
; the plan was to first cover the level with scrolling steel walls for a bit
; and then start filling with spaces - a sort of fade in fade out effect -
; and the pointless code and variable are what's left.
        ; 771e:   85 ba      S
        A CoverLevel__POINTLESS__
        ; 7720:   b5 02      L
        A __CoverLevel__LineAddressTable,X
        ; 7722:   85 36      S
        A InflatedCaveOutputPtr
        ; 7724:   b5 03      L
        A __CoverLevel__LineAddressTable+1,X
        ; 7726:   85 37      S
        A InflatedCaveOutputPtr+1


__CoverLevel__RandomNumber:
        ; 7728:   20 d0 6a   J
        R TimeBasedRandomNumber
        ; 772b:   29 3f      A
        D #$3f
        ; 772d:   c9 2b      C
        P #$2b

; Take branch below if A>=$2b(43)
        ; 772f:   b0 f7      B
        S __CoverLevel__RandomNumber

; 0<=A<=$2a(42)
        ; 7731:   a8         T
        Y 
        ; 7732:   e6 ba      I
        C CoverLevel__POINTLESS__
        ; 7734:   d0 04      B
        E __CoverLevel__PointlessBranchTarget
        ; 7736:   a9 00      L
        A #$00
        ; 7738:   91 36      S
        A (InflatedCaveOutputPtr),Y


__CoverLevel__PointlessBranchTarget:
; $7c is scrolling steel wall.
        ; 773a:   a9 7c      L
        A #$7c
        ; 773c:   91 36      S
        A (InflatedCaveOutputPtr),Y
        ; 773e:   e8         I
        X 
        ; 773f:   e8         I
        X 
        ; 7740:   e0 30      C
        X #$30
        ; 7742:   d0 d8      B
        E __CoverLevel__Inner
        ; 7744:   e6 91      I
        C CaveMatrixX
        ; 7746:   a5 91      L
        A CaveMatrixX
        ; 7748:   c9 30      C
        P #$30
        ; 774a:   d0 ce      B
        E __CoverLevel__Outer
        ; 774c:   60         R
        S 

; Pads the Inflated Cave ($4003 - $4DC2) with 1st steel wall char ($4a).
; Padded bytes: $4000-4002 (3 bytes) and $4dc3-4ec2 (256 bytes).

PadInflatedCave:
        ; 774d:   a2 00      L
        X #$00
        ; 774f:   a9 4a      L
        A #$4a
        ; 7751:   9d c3 4d   S
        A InflatedCave__END_PLUS_ONE__,X
        ; 7754:   ca         D
        X 
        ; 7755:   d0 fa      B
        E $7751
        ; 7757:   a2 02      L
        X #$02
        ; 7759:   9d 00 40   S
        A $4000,X
        ; 775c:   ca         D
        X 
        ; 775d:   10 fa      B
        L $7759
        ; 775f:   60         R
        S 

; Uncover one random cell on each line, 69 times (no already uncovered checks).

RandomlyUncoverScreen:
; Loop 69 times.
        ; 7760:   a9 45      L
        A #$45
        ; 7762:   85 bb      S
        A _LoopCounter

; 
        ; 7764:   a9 00      L
        A #$00
        ; 7766:   85 92      S
        A CaveMatrixY
        ; 7768:   20 cd 76   J
        R ResetCaveCurrentCellPtr


__RandomlyUncoverScreen__GetRandomNumber:
        ; 776b:   20 d0 6a   J
        R TimeBasedRandomNumber
        ; 776e:   85 91      S
        A CaveMatrixX
        ; 7770:   a9 27      L
        A #$27
        ; 7772:   38         S
        C 
        ; 7773:   e5 91      S
        C CaveMatrixX
        ; 7775:   90 f4      B
        C __RandomlyUncoverScreen__GetRandomNumber

; .CaveCurrentCellX <= $27(39)
; A = 39-.CaveCurrentCellX
        ; 7777:   85 bc      S
        A RandomlyUncoverScreen__OffsetToStartOfNextLine
        ; 7779:   e6 bc      I
        C RandomlyUncoverScreen__OffsetToStartOfNextLine

; .RandomlyUncoverScreen::OffsetToStartOfNextLine = 40-.CaveCurrentCellX
; 
; Adjust .CaveCurrentCellPtr(Low&High) to point to .CaveCurrentCellX on the line.
        ; 777b:   a5 32      L
        A CaveCurrentCellPtr
        ; 777d:   18         C
        C 
        ; 777e:   65 91      A
        C CaveMatrixX
        ; 7780:   85 32      S
        A CaveCurrentCellPtr
        ; 7782:   a5 33      L
        A CaveCurrentCellPtr+1
        ; 7784:   69 00      A
        C #$00
        ; 7786:   85 33      S
        A CaveCurrentCellPtr+1

; Setting the cell to itself like this will make it appear.
        ; 7788:   a0 29      L
        Y #$29
        ; 778a:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 778c:   20 b6 6c   J
        R SetCell

; Move to the start of the next line.
        ; 778f:   a5 32      L
        A CaveCurrentCellPtr
        ; 7791:   18         C
        C 
        ; 7792:   65 bc      A
        C RandomlyUncoverScreen__OffsetToStartOfNextLine
        ; 7794:   85 32      S
        A CaveCurrentCellPtr
        ; 7796:   a5 33      L
        A CaveCurrentCellPtr+1
        ; 7798:   69 00      A
        C #$00
        ; 779a:   85 33      S
        A CaveCurrentCellPtr+1

; 
        ; 779c:   e6 92      I
        C CaveMatrixY
        ; 779e:   a5 92      L
        A CaveMatrixY
        ; 77a0:   c9 16      C
        P #$16
        ; 77a2:   d0 c7      B
        E __RandomlyUncoverScreen__GetRandomNumber
        ; 77a4:   c6 bb      D
        C _LoopCounter
        ; 77a6:   d0 bc      B
        E $7764
        ; 77a8:   60         R
        S 

; 

PlayRevealLevelSoundAndRedefineChar:
        ; 77a9:   a5 bd      L
        A PlayRevealLevelSoundAndRedefineCharFlag
        ; 77ab:   f0 4b      B
        Q __PlayRevealLevelSoundAndRedefineChar__Disabled


__PlayRevealLevelSoundAndRedefineChar__Enabled:
        ; 77ad:   a9 00      L
        A #$00
        ; 77af:   8d 0d 98   S
        A $980d

; We add one before we use it, so the phase number outside are one less than in here.
        ; 77b2:   ee 0b 98   I
        C PlayRevealLevelSoundAndRedefineChar__SFXPhase
        ; 77b5:   ad 0b 98   L
        A PlayRevealLevelSoundAndRedefineChar__SFXPhase
        ; 77b8:   c9 02      C
        P #$02
        ; 77ba:   f0 24      B
        Q __PlayRevealLevelSoundAndRedefineChar__RedefineChar
        ; 77bc:   c9 01      C
        P #$01
        ; 77be:   d0 16      B
        E __PlayRevealLevelSoundAndRedefineChar__ReleasePhase

; 1 = Attack phase

__PlayRevealLevelSoundAndRedefineChar__AttackPhase:
        ; 77c0:   a9 05      L
        A #$05
        ; 77c2:   8d 0c d4   S
        A Sid_Voice2AttackDecay
        ; 77c5:   20 d0 6a   J
        R TimeBasedRandomNumber
        ; 77c8:   29 7f      A
        D #$7f
        ; 77ca:   69 64      A
        C #$64
        ; 77cc:   8d 08 d4   S
        A Sid_Voice2FreqHi
        ; 77cf:   a9 11      L
        A #$11
        ; 77d1:   8d 0b d4   S
        A Sid_Voice2Ctrl

; Branch always taken.
        ; 77d4:   d0 0a      B
        E __PlayRevealLevelSoundAndRedefineChar__RedefineChar

; 3 = Release phase

__PlayRevealLevelSoundAndRedefineChar__ReleasePhase:
        ; 77d6:   a2 00      L
        X #$00
        ; 77d8:   8e 0b 98   S
        X PlayRevealLevelSoundAndRedefineChar__SFXPhase
        ; 77db:   a9 10      L
        A #$10
        ; 77dd:   8d 0b d4   S
        A Sid_Voice2Ctrl

; 2 = Sustain phase

__PlayRevealLevelSoundAndRedefineChar__RedefineChar:
        ; 77e0:   ad e0 33   L
        A CopiedGameCharData+$2e0
        ; 77e3:   85 4a      S
        A PlayRevealLevelSoundAndRedefineChar__FirstLine
        ; 77e5:   a2 00      L
        X #$00


__PlayRevealLevelSoundAndRedefineChar__Loop:
        ; 77e7:   bd e1 33   L
        A CopiedGameCharData+$2e1,X
        ; 77ea:   9d e0 33   S
        A CopiedGameCharData+$2e0,X
        ; 77ed:   e8         I
        X 
        ; 77ee:   e0 07      C
        X #$07
        ; 77f0:   d0 f5      B
        E __PlayRevealLevelSoundAndRedefineChar__Loop
        ; 77f2:   a5 4a      L
        A PlayRevealLevelSoundAndRedefineChar__FirstLine
        ; 77f4:   8d e7 33   S
        A CopiedGameCharData+$2e7
        ; 77f7:   60         R
        S 


__PlayRevealLevelSoundAndRedefineChar__Disabled:
; When can be disabled in any phase so reset it to the attack phase.
        ; 77f8:   a9 00      L
        A #$00
        ; 77fa:   8d 0b 98   S
        A PlayRevealLevelSoundAndRedefineChar__SFXPhase
        ; 77fd:   60         R
        S 

; 

UncoverCaveScreen:
; Randomly "uncover" screen.
; The game is mainly interrupt driven and the this function takes some
; time to complete. When it returns the screen will not be totally uncovered.
        ; 77fe:   20 60 77   J
        R RandomlyUncoverScreen

; Uncover the entire screen.
        ; 7801:   a9 00      L
        A #$00
        ; 7803:   85 92      S
        A CaveMatrixY
        ; 7805:   20 cd 76   J
        R ResetCaveCurrentCellPtr
        ; 7808:   a9 00      L
        A #$00
        ; 780a:   85 91      S
        A CaveMatrixX
        ; 780c:   a0 29      L
        Y #$29
        ; 780e:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 7810:   20 b6 6c   J
        R SetCell
        ; 7813:   20 c6 76   J
        R AdvanceCaveCurrentCellPtr
        ; 7816:   e6 91      I
        C CaveMatrixX
        ; 7818:   a5 91      L
        A CaveMatrixX
        ; 781a:   c9 28      C
        P #$28
        ; 781c:   d0 ee      B
        E $780c
        ; 781e:   e6 92      I
        C CaveMatrixY
        ; 7820:   a5 92      L
        A CaveMatrixY
        ; 7822:   c9 16      C
        P #$16
        ; 7824:   d0 e2      B
        E $7808

; What is the purpose of the padding?
        ; 7826:   20 4d 77   J
        R PadInflatedCave
        ; 7829:   60         R
        S 

; Handle animating Rockford.
; IN: X is source offset. Y is destination offset.
; X and Y are preserved.

AnimateRockford:
        ; 782a:   a5 8b      L
        A JoystickStatus
        ; 782c:   c9 0f      C
        P #$0f
        ; 782e:   f0 3c      B
        Q AnimateRockford__Bored
        ; 7830:   a9 00      L
        A #$00
        ; 7832:   85 be      S
        A __TapFootFlag
        ; 7834:   85 bf      S
        A __BlinkFlag
        ; 7836:   a5 98      L
        A RockfordDir_0Right_1Left_is_sticky_
        ; 7838:   d0 19      B
        E $7853

; Right facing.
        ; 783a:   bd e8 65   L
        A RockfordAnimationChars+$200,X
        ; 783d:   99 60 32   S
        A CopiedGameCharData+$160,Y
        ; 7840:   bd f0 65   L
        A RockfordAnimationChars+$208,X
        ; 7843:   99 68 32   S
        A CopiedGameCharData+$168,Y
        ; 7846:   bd 68 66   L
        A RockfordAnimationChars+$280,X
        ; 7849:   99 e0 32   S
        A CopiedGameCharData+$1e0,Y
        ; 784c:   bd 70 66   L
        A RockfordAnimationChars+$288,X
        ; 784f:   99 e8 32   S
        A CopiedGameCharData+$1e8,Y
        ; 7852:   60         R
        S 

; Left facing.
        ; 7853:   bd e8 64   L
        A RockfordAnimationChars+$100,X
        ; 7856:   99 60 32   S
        A CopiedGameCharData+$160,Y
        ; 7859:   bd f0 64   L
        A RockfordAnimationChars+$108,X
        ; 785c:   99 68 32   S
        A CopiedGameCharData+$168,Y
        ; 785f:   bd 68 65   L
        A RockfordAnimationChars+$180,X
        ; 7862:   99 e0 32   S
        A CopiedGameCharData+$1e0,Y
        ; 7865:   bd 70 65   L
        A RockfordAnimationChars+$188,X
        ; 7868:   99 e8 32   S
        A CopiedGameCharData+$1e8,Y
        ; 786b:   60         R
        S 


AnimateRockford__Bored:
        ; 786c:   e0 00      C
        X #$00
        ; 786e:   d0 1c      B
        E AnimateRockford__RedfineBlinkingChars


AnimateRockford__FirstLine:
        ; 7870:   a9 00      L
        A #$00
        ; 7872:   85 bf      S
        A __BlinkFlag
        ; 7874:   20 d0 6a   J
        R TimeBasedRandomNumber
        ; 7877:   29 03      A
        D #$03
        ; 7879:   d0 04      B
        E AnimateRockford__DontBlink

; Set blink flag. There's a 1 in 4 chance of this occuring.
        ; 787b:   a9 01      L
        A #$01
        ; 787d:   85 bf      S
        A __BlinkFlag


AnimateRockford__DontBlink:
        ; 787f:   20 d0 6a   J
        R TimeBasedRandomNumber
        ; 7882:   29 0f      A
        D #$0f
        ; 7884:   d0 06      B
        E AnimateRockford__RedfineBlinkingChars

; Toggle the foot tapping. There's a one in 16 chance of this.
        ; 7886:   a9 01      L
        A #$01
        ; 7888:   45 be      E
        R __TapFootFlag
        ; 788a:   85 be      S
        A __TapFootFlag


AnimateRockford__RedfineBlinkingChars:
        ; 788c:   a5 bf      L
        A __BlinkFlag
        ; 788e:   f0 0f      B
        Q AnimateRockford__ResetBlinkingChars
        ; 7890:   bd e8 63   L
        A RockfordAnimationChars,X
        ; 7893:   99 60 32   S
        A CopiedGameCharData+$160,Y
        ; 7896:   bd f0 63   L
        A RockfordAnimationChars+8,X
        ; 7899:   99 68 32   S
        A CopiedGameCharData+$168,Y
        ; 789c:   4c ab 78   J
        P AnimateRockford__RedfineFootTappingChars


AnimateRockford__ResetBlinkingChars:
        ; 789f:   b9 10 32   L
        A CopiedGameCharData+$110,Y
        ; 78a2:   99 60 32   S
        A CopiedGameCharData+$160,Y
        ; 78a5:   b9 18 32   L
        A CopiedGameCharData+$118,Y
        ; 78a8:   99 68 32   S
        A CopiedGameCharData+$168,Y


AnimateRockford__RedfineFootTappingChars:
        ; 78ab:   a5 be      L
        A __TapFootFlag
        ; 78ad:   f0 0d      B
        Q AnimateRockford__ResetFootTappingChars
        ; 78af:   bd 68 64   L
        A RockfordAnimationChars+$80,X
        ; 78b2:   99 e0 32   S
        A CopiedGameCharData+$1e0,Y
        ; 78b5:   bd 70 64   L
        A RockfordAnimationChars+$88,X
        ; 78b8:   99 e8 32   S
        A CopiedGameCharData+$1e8,Y
        ; 78bb:   60         R
        S 


AnimateRockford__ResetFootTappingChars:
        ; 78bc:   b9 90 32   L
        A CopiedGameCharData+$190,Y
        ; 78bf:   99 e0 32   S
        A CopiedGameCharData+$1e0,Y
        ; 78c2:   b9 98 32   L
        A CopiedGameCharData+$198,Y
        ; 78c5:   99 e8 32   S
        A CopiedGameCharData+$1e8,Y
        ; 78c8:   60         R
        S 


AnimateGameCharsAndHandleTopLineSwitch:
        ; 78c9:   a5 95      L
        A FlashingEntryBoxCountDown
        ; 78cb:   d0 07      B
        E $78d4
        ; 78cd:   a5 94      L
        A EnableSomeSFXAndMarqueeUpdates
        ; 78cf:   f0 03      B
        Q $78d4
        ; 78d1:   20 05 71   J
        R SetTopLineToScore
        ; 78d4:   a5 c0      L
        A AnimationFrameTimes8
        ; 78d6:   0a         A
        L A
        ; 78d7:   aa         T
        X 
        ; 78d8:   a0 00      L
        Y #$00


AnimateGameCharsAndHandleTopLineSwitch__Loop:
; Diamonds
        ; 78da:   bd 06 56   L
        A AnimatedCharData+$200,X
        ; 78dd:   99 40 32   S
        A CopiedGameCharData+$140,Y
        ; 78e0:   bd 0e 56   L
        A AnimatedCharData+$208,X
        ; 78e3:   99 48 32   S
        A CopiedGameCharData+$148,Y
        ; 78e6:   bd 86 56   L
        A AnimatedCharData+$280,X
        ; 78e9:   99 c0 32   S
        A CopiedGameCharData+$1c0,Y
        ; 78ec:   bd 8e 56   L
        A AnimatedCharData+$288,X
        ; 78ef:   99 c8 32   S
        A CopiedGameCharData+$1c8,Y

; 
        ; 78f2:   a5 ff      L
        A AnimationEnableFlags
        ; 78f4:   f0 58      B
        Q $794e
        ; 78f6:   c9 04      C
        P #$04
        ; 78f8:   90 18      B
        C $7912

; Amoeba
        ; 78fa:   bd 06 54   L
        A AnimatedCharData,X
        ; 78fd:   99 00 32   S
        A CopiedGameCharData+$100,Y
        ; 7900:   bd 0e 54   L
        A AnimatedCharData+8,X
        ; 7903:   99 08 32   S
        A CopiedGameCharData+$108,Y
        ; 7906:   bd 86 54   L
        A AnimatedCharData+$80,X
        ; 7909:   99 80 32   S
        A CopiedGameCharData+$180,Y
        ; 790c:   bd 8e 54   L
        A AnimatedCharData+$88,X
        ; 790f:   99 88 32   S
        A CopiedGameCharData+$188,Y

; 
        ; 7912:   a5 ff      L
        A AnimationEnableFlags
        ; 7914:   29 02      A
        D #$02
        ; 7916:   f0 18      B
        Q $7930

; Butterfly
        ; 7918:   bd 06 57   L
        A AnimatedCharData+$300,X
        ; 791b:   99 00 31   S
        A CopiedGameCharData,Y
        ; 791e:   bd 0e 57   L
        A AnimatedCharData+$308,X
        ; 7921:   99 08 31   S
        A CopiedGameCharData+8,Y
        ; 7924:   bd 86 57   L
        A AnimatedCharData+$380,X
        ; 7927:   99 80 31   S
        A CopiedGameCharData+$80,Y
        ; 792a:   bd 8e 57   L
        A AnimatedCharData+$388,X
        ; 792d:   99 88 31   S
        A CopiedGameCharData+$88,Y

; 
        ; 7930:   a5 ff      L
        A AnimationEnableFlags
        ; 7932:   29 01      A
        D #$01
        ; 7934:   f0 18      B
        Q $794e

; Firefly
        ; 7936:   bd 06 55   L
        A AnimatedCharData+$100,X
        ; 7939:   99 20 33   S
        A CopiedGameCharData+$220,Y
        ; 793c:   bd 0e 55   L
        A AnimatedCharData+$108,X
        ; 793f:   99 28 33   S
        A CopiedGameCharData+$228,Y
        ; 7942:   bd 86 55   L
        A AnimatedCharData+$180,X
        ; 7945:   99 a0 33   S
        A CopiedGameCharData+$2a0,Y
        ; 7948:   bd 8e 55   L
        A AnimatedCharData+$188,X
        ; 794b:   99 a8 33   S
        A CopiedGameCharData+$2a8,Y

; 
        ; 794e:   20 2a 78   J
        R AnimateRockford
        ; 7951:   e8         I
        X 
        ; 7952:   c8         I
        Y 
        ; 7953:   c0 08      C
        Y #$08
        ; 7955:   d0 83      B
        E AnimateGameCharsAndHandleTopLineSwitch__Loop
        ; 7957:   60         R
        S 


WhiteFlash:
        ; 7958:   a5 a5      L
        A WhiteFlashWhiteCount
        ; 795a:   f0 14      B
        Q $7970
        ; 795c:   a9 01      L
        A #$01
        ; 795e:   8d 21 d0   S
        A Vic_BkgndColour0
        ; 7961:   8d 20 d0   S
        A Vic_BorderColour
        ; 7964:   c6 a5      D
        C WhiteFlashWhiteCount
        ; 7966:   d0 08      B
        E $7970
        ; 7968:   a9 00      L
        A #$00
        ; 796a:   8d 21 d0   S
        A Vic_BkgndColour0
        ; 796d:   8d 20 d0   S
        A Vic_BorderColour
        ; 7970:   60         R
        S 


SoundFX:
        ; 7971:   a9 0f      L
        A #$0f
        ; 7973:   8d 18 d4   S
        A Sid_FilterModeAndVolume
        ; 7976:   a5 9b      L
        A SecondsDontPass
        ; 7978:   f0 01      B
        Q SoundFX_NotPaused


SoundFX_Paused:
        ; 797a:   60         R
        S 


SoundFX_NotPaused:
        ; 797b:   a5 d8      L
        A SFXTrigger_DiamondQuotaReachedOrEntryBoxExplode
        ; 797d:   f0 21      B
        Q $79a0


SoundFX_DiamondQuotaReachedOrEntryBoxExplode_Check:
        ; 797f:   a5 d9      L
        A SFXTimer_DiamondQuotaReachedOrEntryBoxExplode
        ; 7981:   d0 12      B
        E SoundFX_DiamondQuotaReachedOrEntryBoxExplode_InProgress


SoundFX_DiamondQuotaReachedOrEntryBoxExplode_Start:
        ; 7983:   20 e7 7c   J
        R ResetVoice3
        ; 7986:   a2 06      L
        X #$06
        ; 7988:   bd 80 70   L
        A DiamondQuotaReachedSoundSIDValues,X
        ; 798b:   9d 0e d4   S
        A Sid_Voice3FreqLo,X
        ; 798e:   ca         D
        X 
        ; 798f:   10 f7      B
        L $7988
        ; 7991:   a9 21      L
        A #$21
        ; 7993:   85 d9      S
        A SFXTimer_DiamondQuotaReachedOrEntryBoxExplode


SoundFX_DiamondQuotaReachedOrEntryBoxExplode_InProgress:
        ; 7995:   c6 d9      D
        C SFXTimer_DiamondQuotaReachedOrEntryBoxExplode
        ; 7997:   d0 07      B
        E $79a0 ; The target of this branch may as well be $79d2


SoundFX_DiamondQuotaReachedOrEntryBoxExplode_Stop:
        ; 7999:   a9 00      L
        A #$00
        ; 799b:   85 d8      S
        A SFXTrigger_DiamondQuotaReachedOrEntryBoxExplode
        ; 799d:   20 e7 7c   J
        R ResetVoice3
        ; 79a0:   a5 d9      L
        A SFXTimer_DiamondQuotaReachedOrEntryBoxExplode
        ; 79a2:   d0 2e      B
        E $79d2
        ; 79a4:   a5 94      L
        A EnableSomeSFXAndMarqueeUpdates ; Note that not all SFX use this enable flag
        ; 79a6:   f0 21      B
        Q SoundFX_MagiWall_Check


SoundFX_Amoeba_Check:
        ; 79a8:   a5 43      L
        A AmoebaIsGrowing
        ; 79aa:   f0 1d      B
        Q SoundFX_MagiWall_Check


SoundFX_Amoeba_Tick:
        ; 79ac:   a9 10      L
        A #$10
        ; 79ae:   8d 12 d4   S
        A Sid_Voice3Ctrl
        ; 79b1:   20 d0 6a   J
        R TimeBasedRandomNumber
        ; 79b4:   29 1f      A
        D #$1f
        ; 79b6:   c9 08      C
        P #$08
        ; 79b8:   90 f7      B
        C $79b1 ; Keep on trying till we get a frequency in range
        ; 79ba:   8d 0f d4   S
        A Sid_Voice3FreqHi
        ; 79bd:   a9 30      L
        A #$30
        ; 79bf:   8d 13 d4   S
        A Sid_Voice3AttackDecay
        ; 79c2:   a9 11      L
        A #$11
        ; 79c4:   8d 12 d4   S
        A Sid_Voice3Ctrl
        ; 79c7:   d0 09      B
        E $79d2 ; Branch always taken


SoundFX_MagiWall_Check:
        ; 79c9:   a5 8d      L
        A MagicWallActiveState
        ; 79cb:   c9 01      C
        P #$01
        ; 79cd:   f0 03      B
        Q $79d2
        ; 79cf:   20 e7 7c   J
        R ResetVoice3
        ; 79d2:   ee 0f 98   I
        C $980f
        ; 79d5:   ad 0f 98   L
        A $980f
        ; 79d8:   2d 78 98   A
        D $9878
        ; 79db:   d0 55      B
        E _NotSureYet_
        ; 79dd:   ad 0d 98   L
        A $980d
        ; 79e0:   29 7f      A
        D #$7f
        ; 79e2:   f0 29      B
        Q $7a0d
        ; 79e4:   ae 7a 98   L
        X $987a
        ; 79e7:   ca         D
        X 
        ; 79e8:   8e 04 d4   S
        X Sid_Voice1Ctrl
        ; 79eb:   e0 80      C
        X #$80
        ; 79ed:   d0 05      B
        E $79f4
        ; 79ef:   a9 08      L
        A #$08
        ; 79f1:   8d 04 d4   S
        A Sid_Voice1Ctrl
        ; 79f4:   a2 06      L
        X #$06
        ; 79f6:   bd 7d 98   L
        A Voice1SIDRegsBuffer,X
        ; 79f9:   9d 76 98   S
        A $9876,X
        ; 79fc:   9d 00 d4   S
        A Sid_Voice1FreqLo,X
        ; 79ff:   ca         D
        X 
        ; 7a00:   10 f4      B
        L $79f6
        ; 7a02:   ad 0d 98   L
        A $980d
        ; 7a05:   29 80      A
        D #$80
        ; 7a07:   8d 0d 98   S
        A $980d
        ; 7a0a:   4c 32 7a   J
        P _NotSureYet_
        ; 7a0d:   4e 7c 98   L
        R $987c
        ; 7a10:   ad 7c 98   L
        A $987c
        ; 7a13:   29 f0      A
        D #$f0
        ; 7a15:   8d 7c 98   S
        A $987c
        ; 7a18:   8d 06 d4   S
        A Sid_Voice1SustainRelease
        ; 7a1b:   f0 0b      B
        Q $7a28
        ; 7a1d:   c9 04      C
        P #$04
        ; 7a1f:   b0 11      B
        S _NotSureYet_
        ; 7a21:   ae 7a 98   L
        X $987a
        ; 7a24:   e0 11      C
        X #$11
        ; 7a26:   d0 0a      B
        E _NotSureYet_
        ; 7a28:   a2 08      L
        X #$08
        ; 7a2a:   8e 04 d4   S
        X Sid_Voice1Ctrl
        ; 7a2d:   a9 00      L
        A #$00
        ; 7a2f:   8d 7c 98   S
        A $987c


_NotSureYet_:
        ; 7a32:   a5 bd      L
        A PlayRevealLevelSoundAndRedefineCharFlag
        ; 7a34:   f0 01      B
        Q $7a37
        ; 7a36:   60         R
        S 
        ; 7a37:   ad 11 98   L
        A $9811
        ; 7a3a:   f0 03      B
        Q $7a3f
        ; 7a3c:   ce 11 98   D
        C $9811
        ; 7a3f:   ad 0d 98   L
        A $980d
        ; 7a42:   29 80      A
        D #$80
        ; 7a44:   f0 01      B
        Q $7a47
        ; 7a46:   60         R
        S 
        ; 7a47:   ad 11 98   L
        A $9811
        ; 7a4a:   f0 01      B
        Q $7a4d
        ; 7a4c:   60         R
        S 
        ; 7a4d:   ad 09 98   L
        A $9809
        ; 7a50:   d0 2d      B
        E $7a7f
        ; 7a52:   ac 08 98   L
        Y $9808
        ; 7a55:   f0 2c      B
        Q $7a83
        ; 7a57:   20 e3 7c   J
        R ResetVoice2
        ; 7a5a:   8c 08 d4   S
        Y Sid_Voice2FreqHi
        ; 7a5d:   a9 00      L
        A #$00
        ; 7a5f:   8d 08 98   S
        A $9808
        ; 7a62:   a9 c0      L
        A #$c0
        ; 7a64:   8d 0d d4   S
        A Sid_Voice2SustainRelease
        ; 7a67:   a9 30      L
        A #$30
        ; 7a69:   8d 0c d4   S
        A Sid_Voice2AttackDecay
        ; 7a6c:   a9 81      L
        A #$81
        ; 7a6e:   8d 0b d4   S
        A Sid_Voice2Ctrl
        ; 7a71:   ad 0a 98   L
        A $980a
        ; 7a74:   c9 02      C
        P #$02
        ; 7a76:   f0 04      B
        Q $7a7c
        ; 7a78:   4a         L
        R A
        ; 7a79:   8d 0a 98   S
        A $980a
        ; 7a7c:   8d 09 98   S
        A $9809
        ; 7a7f:   ce 09 98   D
        C $9809
        ; 7a82:   60         R
        S 
        ; 7a83:   4c e3 7c   J
        P ResetVoice2

; 

RedefineMagicWallCharsToNormalWall:
        ; 7a86:   a2 07      L
        X #$07
        ; 7a88:   bd 70 32   L
        A CopiedGameCharData+$170,X
        ; 7a8b:   9d 10 31   S
        A CopiedGameCharData+$10,X
        ; 7a8e:   9d 18 31   S
        A CopiedGameCharData+$18,X
        ; 7a91:   9d 90 31   S
        A CopiedGameCharData+$90,X
        ; 7a94:   9d 98 31   S
        A CopiedGameCharData+$98,X
        ; 7a97:   ca         D
        X 
        ; 7a98:   10 ee      B
        L $7a88
        ; 7a9a:   60         R
        S 


MagicWallFX:
        ; 7a9b:   a5 c2      L
        A AnotherFrameCounter
        ; 7a9d:   29 01      A
        D #$01
        ; 7a9f:   f0 21      B
        Q MagicWallFX__Animate


MagicWallFX__Sound:
        ; 7aa1:   a9 10      L
        A #$10
        ; 7aa3:   8d 12 d4   S
        A Sid_Voice3Ctrl
        ; 7aa6:   20 d0 6a   J
        R TimeBasedRandomNumber
        ; 7aa9:   29 03      A
        D #$03
        ; 7aab:   0a         A
        L A
        ; 7aac:   0a         A
        L A
        ; 7aad:   0a         A
        L A
        ; 7aae:   69 86      A
        C #$86
        ; 7ab0:   8d 0f d4   S
        A Sid_Voice3FreqHi
        ; 7ab3:   a9 00      L
        A #$00
        ; 7ab5:   8d 13 d4   S
        A Sid_Voice3AttackDecay
        ; 7ab8:   a9 a0      L
        A #$a0
        ; 7aba:   8d 14 d4   S
        A Sid_Voice3SustainRelease
        ; 7abd:   a9 11      L
        A #$11
        ; 7abf:   8d 12 d4   S
        A Sid_Voice3Ctrl


MagicWallFX__Animate:
        ; 7ac2:   a5 c0      L
        A AnimationFrameTimes8
        ; 7ac4:   29 1f      A
        D #$1f

; A = 0 to 24 in multiples of 8.
        ; 7ac6:   aa         T
        X 
        ; 7ac7:   a0 00      L
        Y #$00


MagicWallFX__AnimateLoop:
        ; 7ac9:   bd 60 33   L
        A CopiedGameCharData+$260,X
        ; 7acc:   99 10 31   S
        A CopiedGameCharData+$10,Y
        ; 7acf:   99 18 31   S
        A CopiedGameCharData+$18,Y
        ; 7ad2:   99 90 31   S
        A CopiedGameCharData+$90,Y
        ; 7ad5:   99 98 31   S
        A CopiedGameCharData+$98,Y
        ; 7ad8:   e8         I
        X 
        ; 7ad9:   c8         I
        Y 
        ; 7ada:   c0 08      C
        Y #$08
        ; 7adc:   d0 eb      B
        E MagicWallFX__AnimateLoop
        ; 7ade:   60         R
        S 


HandleMagicWall:
        ; 7adf:   a5 8d      L
        A MagicWallActiveState
        ; 7ae1:   c9 01      C
        P #$01
        ; 7ae3:   d0 03      B
        E $7ae8
        ; 7ae5:   4c 9b 7a   J
        P MagicWallFX
        ; 7ae8:   c9 02      C
        P #$02
        ; 7aea:   d0 0a      B
        E $7af6
        ; 7aec:   20 86 7a   J
        R RedefineMagicWallCharsToNormalWall
        ; 7aef:   20 e7 7c   J
        R ResetVoice3
        ; 7af2:   a9 03      L
        A #$03
        ; 7af4:   85 8d      S
        A MagicWallActiveState
        ; 7af6:   60         R
        S 


Animate:
; Move to the next frame in animations.
; There are 8 frames in each animatiom and each
; character has 8 lines. So .AnimationFrameLineOffset
; is a multiple of 8 from 0 to 56.
        ; 7af7:   a5 c0      L
        A AnimationFrameTimes8
        ; 7af9:   18         C
        C 
        ; 7afa:   69 08      A
        C #$08
        ; 7afc:   29 3f      A
        D #$3f
        ; 7afe:   85 c0      S
        A AnimationFrameTimes8
        ; 7b00:   20 c9 78   J
        R AnimateGameCharsAndHandleTopLineSwitch
        ; 7b03:   20 df 7a   J
        R HandleMagicWall
        ; 7b06:   60         R
        S 


HandleMagicWallState:
; FWI: .MagicWallActiveState:
; 0 inactive. 1 active. 2 finished (signal to restore chars & kill sfx).
; 3 done and chars restored.
        ; 7b07:   a5 9b      L
        A SecondsDontPass
        ; 7b09:   49 01      E
        R #$01
        ; 7b0b:   25 8d      A
        D MagicWallActiveState
        ; 7b0d:   c9 01      C
        P #$01
        ; 7b0f:   d0 19      B
        E $7b2a

; We get here when state is 1 OR 3. I think the OR is a mistake.
; The error has no ramifications unless .MagicWallActiveSeconds wraps.
        ; 7b11:   e6 8e      I
        C MagicWallActiveFrameCounter
        ; 7b13:   a5 8e      L
        A MagicWallActiveFrameCounter
        ; 7b15:   c9 3c      C
        P #$3c
        ; 7b17:   d0 11      B
        E $7b2a
        ; 7b19:   a9 00      L
        A #$00
        ; 7b1b:   85 8e      S
        A MagicWallActiveFrameCounter
        ; 7b1d:   e6 8f      I
        C MagicWallActiveSeconds
        ; 7b1f:   a5 8f      L
        A MagicWallActiveSeconds
        ; 7b21:   cd 01 24   C
        P BufferedLevel_MagicWallMillingTimeOrAmoeba3PercentMax
        ; 7b24:   d0 04      B
        E $7b2a
        ; 7b26:   a9 02      L
        A #$02
        ; 7b28:   85 8d      S
        A MagicWallActiveState
        ; 7b2a:   60         R
        S 


GameIRQActions:
        ; 7b2b:   a5 a7      L
        A RastIntIsInMarquee
        ; 7b2d:   f0 01      B
        Q __GameIRQActions__InBody
        ; 7b2f:   60         R
        S 


__GameIRQActions__InBody:
        ; 7b30:   20 58 79   J
        R WhiteFlash
        ; 7b33:   20 a9 77   J
        R PlayRevealLevelSoundAndRedefineChar
        ; 7b36:   20 07 7b   J
        R HandleMagicWallState
        ; 7b39:   20 11 71   J
        R SubSecondTick
        ; 7b3c:   20 71 79   J
        R SoundFX
        ; 7b3f:   e6 c2      I
        C AnotherFrameCounter
        ; 7b41:   20 ad 76   J
        R Scroller
        ; 7b44:   a5 c2      L
        A AnotherFrameCounter
        ; 7b46:   29 01      A
        D #$01
        ; 7b48:   d0 0b      B
        E __GameIRQActions__CopyInflatedCaveToBackBuffer


__GameIRQActions__FlipBuffers:
        ; 7b4a:   ad 07 98   L
        A BackBufferVICMemControl
        ; 7b4d:   85 58      S
        A RastInt_vic_memory_control
        ; 7b4f:   49 80      E
        R #$80
        ; 7b51:   8d 07 98   S
        A BackBufferVICMemControl
        ; 7b54:   60         R
        S 


__GameIRQActions__CopyInflatedCaveToBackBuffer:
        ; 7b55:   4c 00 9e   J
        P MOVEDCopyInflatedCaveSubsetToBackBuffer

; Code moved to $9e00 and executed there. Is self-modifying!
; $7b58-$7d57 is moved to $9e00-$9fff. More code than needed is moved. 
; The routine occupies $7b58-$7c90.

CopyInflatedCaveSubsetToBackBuffer:
        ; 7b58:   a5 d6      L
        A InflatedCaveSubset
        ; 7b5a:   18         C
        C 
        ; 7b5b:   69 20      A
        C #$20
        ; 7b5d:   8d 51 9e   S
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$51

; Patched byte corresponds to $7ba9.
        ; 7b60:   a5 d7      L
        A InflatedCaveSubset+1
        ; 7b62:   69 03      A
        C #$03
        ; 7b64:   8d 52 9e   S
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$52

; Patched byte corresponds to $7baa.
        ; 7b67:   ad 07 98   L
        A BackBufferVICMemControl
        ; 7b6a:   4a         L
        R A
        ; 7b6b:   4a         L
        R A
        ; 7b6c:   49 03      E
        R #$03
        ; 7b6e:   18         C
        C 
        ; 7b6f:   69 01      A
        C #$01
        ; 7b71:   8d 55 9e   S
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$55

; Patched byte corresponds to $7bad.
        ; 7b74:   a9 b8      L
        A #$b8
        ; 7b76:   8d 54 9e   S
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$54

; Patched byte corresponds to $7bac.
; 
; Now clone the patch (with adjustment) for the next 13 entries.
        ; 7b79:   a2 00      L
        X #$00
        ; 7b7b:   bd 51 9e   L
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$51,X
        ; 7b7e:   18         C
        C 
        ; 7b7f:   69 50      A
        C #$50
        ; 7b81:   9d 57 9e   S
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$57,X
        ; 7b84:   bd 52 9e   L
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$52,X
        ; 7b87:   69 00      A
        C #$00
        ; 7b89:   9d 58 9e   S
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$58,X
        ; 7b8c:   bd 54 9e   L
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$54,X
        ; 7b8f:   18         C
        C 
        ; 7b90:   69 28      A
        C #$28
        ; 7b92:   9d 5a 9e   S
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$5a,X
        ; 7b95:   bd 55 9e   L
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$55,X
        ; 7b98:   69 00      A
        C #$00
        ; 7b9a:   9d 5b 9e   S
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$5b,X
        ; 7b9d:   8a         T
        A 
        ; 7b9e:   18         C
        C 
        ; 7b9f:   69 06      A
        C #$06
        ; 7ba1:   aa         T
        X 
        ; 7ba2:   e0 4e      C
        X #$4e
        ; 7ba4:   90 d5      B
        C $7b7b

; Now move the lower 14 lines of the subset to the lower 14 lines
; of the screen back-buffer.
        ; 7ba6:   a2 27      L
        X #$27
        ; 7ba8:   bd 00 50   L
        A TitleCharData,X
        ; 7bab:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 7bae:   bd 00 50   L
        A TitleCharData,X
        ; 7bb1:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 7bb4:   bd 00 50   L
        A TitleCharData,X
        ; 7bb7:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 7bba:   bd 00 50   L
        A TitleCharData,X
        ; 7bbd:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 7bc0:   bd 00 50   L
        A TitleCharData,X
        ; 7bc3:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 7bc6:   bd 00 50   L
        A TitleCharData,X
        ; 7bc9:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 7bcc:   bd 00 50   L
        A TitleCharData,X
        ; 7bcf:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 7bd2:   bd 00 50   L
        A TitleCharData,X
        ; 7bd5:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 7bd8:   bd 00 50   L
        A TitleCharData,X
        ; 7bdb:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 7bde:   bd 00 50   L
        A TitleCharData,X
        ; 7be1:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 7be4:   bd 00 50   L
        A TitleCharData,X
        ; 7be7:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 7bea:   bd 00 50   L
        A TitleCharData,X
        ; 7bed:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 7bf0:   bd 00 50   L
        A TitleCharData,X
        ; 7bf3:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 7bf6:   bd 00 50   L
        A TitleCharData,X
        ; 7bf9:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 7bfc:   ca         D
        X 
        ; 7bfd:   10 a9      B
        L $7ba8

; 
        ; 7bff:   ad 07 98   L
        A BackBufferVICMemControl
        ; 7c02:   4a         L
        R A
        ; 7c03:   4a         L
        R A
        ; 7c04:   49 03      E
        R #$03
        ; 7c06:   8d f4 9e   S
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$f4

; Patched byte corresponds to $9ef4
        ; 7c09:   a9 28      L
        A #$28
        ; 7c0b:   8d f3 9e   S
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$f3

; Patched byte corresponds to $9ef3
        ; 7c0e:   a5 d6      L
        A InflatedCaveSubset
        ; 7c10:   8d f0 9e   S
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$f0

; Patched byte corresponds to $9ef0
        ; 7c13:   a5 d7      L
        A InflatedCaveSubset+1
        ; 7c15:   8d f1 9e   S
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$f1

; Patched byte corresponds to $9ef1
; 
; Now clone the patch (with adjustment) for the next 9 entries.
        ; 7c18:   a2 00      L
        X #$00
        ; 7c1a:   bd f0 9e   L
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$f0,X
        ; 7c1d:   18         C
        C 
        ; 7c1e:   69 50      A
        C #$50
        ; 7c20:   9d f6 9e   S
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$f6,X
        ; 7c23:   bd f1 9e   L
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$f1,X
        ; 7c26:   69 00      A
        C #$00
        ; 7c28:   9d f7 9e   S
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$f7,X
        ; 7c2b:   bd f3 9e   L
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$f3,X
        ; 7c2e:   18         C
        C 
        ; 7c2f:   69 28      A
        C #$28
        ; 7c31:   9d f9 9e   S
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$f9,X
        ; 7c34:   bd f4 9e   L
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$f4,X
        ; 7c37:   69 00      A
        C #$00
        ; 7c39:   9d fa 9e   S
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$fa,X
        ; 7c3c:   8a         T
        A 
        ; 7c3d:   18         C
        C 
        ; 7c3e:   69 06      A
        C #$06
        ; 7c40:   aa         T
        X 
        ; 7c41:   e0 36      C
        X #$36
        ; 7c43:   90 d5      B
        C $7c1a

; Now move the upper 10 lines of the subset to the upper 10 lines
; of the screen back-buffer ***NOT*** including the top line.
        ; 7c45:   a2 27      L
        X #$27
        ; 7c47:   bd 00 50   L
        A TitleCharData,X
        ; 7c4a:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 7c4d:   bd 00 50   L
        A TitleCharData,X
        ; 7c50:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 7c53:   bd 00 50   L
        A TitleCharData,X
        ; 7c56:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 7c59:   bd 00 50   L
        A TitleCharData,X
        ; 7c5c:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 7c5f:   bd 00 50   L
        A TitleCharData,X
        ; 7c62:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 7c65:   bd 00 50   L
        A TitleCharData,X
        ; 7c68:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 7c6b:   bd 00 50   L
        A TitleCharData,X
        ; 7c6e:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 7c71:   bd 00 50   L
        A TitleCharData,X
        ; 7c74:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 7c77:   bd 00 50   L
        A TitleCharData,X
        ; 7c7a:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 7c7d:   bd 00 50   L
        A TitleCharData,X
        ; 7c80:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 7c83:   ca         D
        X 
        ; 7c84:   10 c1      B
        L $7c47
        ; 7c86:   20 f7 7a   J
        R Animate
        ; 7c89:   a5 a8      L
        A ExtraLifeFXCounter
        ; 7c8b:   f0 03      B
        Q $7c90
        ; 7c8d:   20 54 74   J
        R ExtraLifeFX
        ; 7c90:   60         R
        S 

; 

InstallRandomCaveObjectForCell:
        ; 7c91:   a2 01      L
        X #$01
        ; 7c93:   20 ed 6c   J
        R PseudoRandom
        ; 7c96:   a0 00      L
        Y #$00


_RandomObjTestLoop:
        ; 7c98:   d9 1c 24   C
        P BufferedLevel_ProbabilityOfObject1,Y
        ; 7c9b:   b0 03      B
        S _NotThisRandomObject

; BufferedLevel_ProbabilityOfObject1 > AF
        ; 7c9d:   be 18 24   L
        X BufferedLevel_RandomObjectNumber1,Y


_NotThisRandomObject:
        ; 7ca0:   c8         I
        Y 
        ; 7ca1:   c0 04      C
        Y #$04
        ; 7ca3:   d0 f3      B
        E _RandomObjTestLoop
        ; 7ca5:   8a         T
        A 
        ; 7ca6:   a0 29      L
        Y #$29
        ; 7ca8:   91 32      S
        A (CaveCurrentCellPtr),Y
        ; 7caa:   60         R
        S 

; 

FillWithDirtAndRandomObjects:
        ; 7cab:   a9 01      L
        A #$01
        ; 7cad:   85 92      S
        A CaveMatrixY
        ; 7caf:   20 cd 76   J
        R ResetCaveCurrentCellPtr


FillWithDirtAndRandomObjects__NextRow:
        ; 7cb2:   a9 00      L
        A #$00
        ; 7cb4:   85 91      S
        A CaveMatrixX


FillWithDirtAndRandomObjects__NextColumn:
        ; 7cb6:   20 91 7c   J
        R InstallRandomCaveObjectForCell
        ; 7cb9:   20 c6 76   J
        R AdvanceCaveCurrentCellPtr
        ; 7cbc:   e6 91      I
        C CaveMatrixX
        ; 7cbe:   a5 91      L
        A CaveMatrixX
        ; 7cc0:   c9 28      C
        P #$28
        ; 7cc2:   d0 f2      B
        E FillWithDirtAndRandomObjects__NextColumn
        ; 7cc4:   e6 92      I
        C CaveMatrixY
        ; 7cc6:   a5 92      L
        A CaveMatrixY
        ; 7cc8:   c9 16      C
        P #$16
        ; 7cca:   d0 e6      B
        E FillWithDirtAndRandomObjects__NextRow
        ; 7ccc:   60         R
        S 

; 

GameSpeedsForSublevelsArray:
        ; 7ccd:   0c 06 03 01
        00


CaveRowTransitionDelay:
        ; 7cd2:   a4 9c      L
        Y MatrixRowTransitionDelay
        ; 7cd4:   f0 08      B
        Q $7cde
        ; 7cd6:   a2 10      L
        X #$10
        ; 7cd8:   ca         D
        X 
        ; 7cd9:   d0 fd      B
        E $7cd8
        ; 7cdb:   88         D
        Y 
        ; 7cdc:   d0 f8      B
        E $7cd6
        ; 7cde:   60         R
        S 


ResetVoice1:
        ; 7cdf:   a2 04      L
        X #$04

; .Sid_Voice1Ctrl
        ; 7ce1:   d0 06      B
        E $7ce9


ResetVoice2:
        ; 7ce3:   a2 0b      L
        X #$0b

; .Sid_Voice2Ctrl
        ; 7ce5:   d0 02      B
        E $7ce9


ResetVoice3:
        ; 7ce7:   a2 12      L
        X #$12

; .Sid_Voice3Ctrl
        ; 7ce9:   a9 08      L
        A #$08
        ; 7ceb:   9d 00 d4   S
        A Sid_Voice1FreqLo,X
        ; 7cee:   a9 00      L
        A #$00
        ; 7cf0:   9d 00 d4   S
        A Sid_Voice1FreqLo,X

; .Sid_VoiceXCtrl
; 7      Select Random Noise Waveform, 1 = On
; 6      Select Pulse Waveform, 1 = On
; 5      Select Sawtooth Waveform, 1 = On
; 4      Select Triangle Waveform, 1 = On
; 3      Test Bit: 1 = Disable Oscillator
; 2      Ring Modulate Osc. X with Osc. X-1 Output, 1 = On
; 1      Synchronize Osc. X with Osc. X-1 Frequency, 1 = On
; 0      Gate Bit: 1 = Start Att/Dec/Sus, 0 = Start Release
        ; 7cf3:   60         R
        S 


ResetSound:
        ; 7cf4:   20 df 7c   J
        R ResetVoice1
        ; 7cf7:   20 e3 7c   J
        R ResetVoice2
        ; 7cfa:   20 e7 7c   J
        R ResetVoice3
        ; 7cfd:   a9 4f      L
        A #$4f
        ; 7cff:   8d 18 d4   S
        A Sid_FilterModeAndVolume

; .Sid_FilterModeAndVolume
; Select Filter Mode and Volume
; 7      Cut-Off Voice 3 Output: 1 = Off, 0 = On
; 6      Select Filter High-Pass Mode: 1 = On
; 5      Select Filter Band-Pass Mode: 1 = On
; 4      Select Filter Low-Pass Mode: 1 = On
; 3-0    Select Output Volume: 0-15
        ; 7d02:   60         R
        S 


Delay:
        ; 7d03:   a0 80      L
        Y #$80
        ; 7d05:   ca         D
        X 
        ; 7d06:   d0 fd      B
        E $7d05
        ; 7d08:   88         D
        Y 
        ; 7d09:   d0 fa      B
        E $7d05
        ; 7d0b:   60         R
        S 


FourDelays:
        ; 7d0c:   20 03 7d   J
        R Delay
        ; 7d0f:   20 03 7d   J
        R Delay
        ; 7d12:   20 03 7d   J
        R Delay
        ; 7d15:   20 03 7d   J
        R Delay
        ; 7d18:   60         R
        S 

; 

DelaySpaceKeyAborts:
        ; 7d19:   a0 90      L
        Y #$90
        ; 7d1b:   a2 00      L
        X #$00
        ; 7d1d:   a5 fc      L
        A LastKeyInScanRow7_ScannedMoreThanOnce
        ; 7d1f:   c9 ef      C
        P #$ef
        ; 7d21:   d0 01      B
        E $7d24
        ; 7d23:   60         R
        S 
        ; 7d24:   ca         D
        X 
        ; 7d25:   d0 f6      B
        E $7d1d
        ; 7d27:   88         D
        Y 
        ; 7d28:   d0 f1      B
        E $7d1b
        ; 7d2a:   60         R
        S 

; While paused we spin in this function until we're unpaused.

PauseLoop:
        ; 7d2b:   20 04 6b   J
        R BackupTopLine
        ; 7d2e:   a9 58      L
        A #&lt;Text__SpaceBarToResume
        ; 7d30:   85 46      S
        A LocalVar
        ; 7d32:   a9 6c      L
        A #&gt;Text__SpaceBarToResume
        ; 7d34:   85 47      S
        A LocalVar+1
        ; 7d36:   20 16 6b   J
        R SetTopLineText
        ; 7d39:   a5 9b      L
        A SecondsDontPass
        ; 7d3b:   c9 01      C
        P #$01
        ; 7d3d:   d0 07      B
        E $7d46
        ; 7d3f:   e6 9b      I
        C SecondsDontPass
        ; 7d41:   20 03 7d   J
        R Delay
        ; 7d44:   85 fc      S
        A LastKeyInScanRow7_ScannedMoreThanOnce
        ; 7d46:   20 19 7d   J
        R DelaySpaceKeyAborts
        ; 7d49:   a9 62      L
        A #&lt;TopLineBackup
        ; 7d4b:   85 46      S
        A LocalVar
        ; 7d4d:   a9 98      L
        A #&gt;TopLineBackup
        ; 7d4f:   85 47      S
        A LocalVar+1
        ; 7d51:   20 16 6b   J
        R SetTopLineText
        ; 7d54:   20 19 7d   J
        R DelaySpaceKeyAborts
        ; 7d57:   20 19 7d   J
        R DelaySpaceKeyAborts
        ; 7d5a:   20 19 7d   J
        R DelaySpaceKeyAborts
        ; 7d5d:   a5 fc      L
        A LastKeyInScanRow7_ScannedMoreThanOnce
        ; 7d5f:   c9 ef      C
        P #$ef
        ; 7d61:   d0 c8      B
        E PauseLoop
        ; 7d63:   20 03 7d   J
        R Delay
        ; 7d66:   a9 00      L
        A #$00
        ; 7d68:   85 fc      S
        A LastKeyInScanRow7_ScannedMoreThanOnce
        ; 7d6a:   60         R
        S 

; 

HandleInGameKeys:
        ; 7d6b:   a5 fc      L
        A LastKeyInScanRow7_ScannedMoreThanOnce
        ; 7d6d:   c9 ef      C
        P #$ef
        ; 7d6f:   d0 12      B
        E $7d83

; Pause game.

__HandleInGameKeys__SpacePressed:
        ; 7d71:   a2 00      L
        X #$00
        ; 7d73:   86 94      S
        X EnableSomeSFXAndMarqueeUpdates
        ; 7d75:   20 f4 7c   J
        R ResetSound
        ; 7d78:   e6 9b      I
        C SecondsDontPass
        ; 7d7a:   20 2b 7d   J
        R PauseLoop
        ; 7d7d:   a9 00      L
        A #$00
        ; 7d7f:   85 9b      S
        A SecondsDontPass
        ; 7d81:   e6 94      I
        C EnableSomeSFXAndMarqueeUpdates
        ; 7d83:   a5 fc      L
        A LastKeyInScanRow7_ScannedMoreThanOnce
        ; 7d85:   c9 7f      C
        P #$7f
        ; 7d87:   d0 0c      B
        E $7d95

; Suicide.

__HandleInGameKeys__RunStopPressed:
        ; 7d89:   a5 95      L
        A FlashingEntryBoxCountDown
        ; 7d8b:   d0 08      B
        E $7d95
        ; 7d8d:   a9 00      L
        A #$00
        ; 7d8f:   85 94      S
        A EnableSomeSFXAndMarqueeUpdates
        ; 7d91:   a9 02      L
        A #$02
        ; 7d93:   85 97      S
        A ExitCaveFlag
        ; 7d95:   a9 00      L
        A #$00
        ; 7d97:   85 fc      S
        A LastKeyInScanRow7_ScannedMoreThanOnce
        ; 7d99:   a5 fb      L
        A LastKeyInScanRow0_ScannedMoreThanOnce
        ; 7d9b:   c9 ef      C
        P #$ef
        ; 7d9d:   d0 03      B
        E $7da2

; Back to title screen.

__HandleInGameKeys_F1Pressed:
        ; 7d9f:   4c b3 8a   J
        P Main
        ; 7da2:   60         R
        S 

; Remember that this runs before the tick so 'ThisTick' refers to the previous one.
; 
; In C++ the function looks like this:
; 
; if (!AmeobaCouldGrowThisTick && AmoebaIsGrowing)
; {
;    AmeobaCouldGrowLastTick = false;
; }
; 
; AmoebaIsGrowing = AmeobaCouldGrowThisTick
; 
; AmeobaCouldGrowThisTick = false;
; AmoebaCellCountPreviousTick = AmoebaCellCountThisTick;
; AmoebaCellCountThisTick = 0;

PreTickAmoebaProcessing:
        ; 7da3:   a5 42      L
        A AmeobaCouldGrowThisTick
        ; 7da5:   d0 08      B
        E $7daf
        ; 7da7:   a5 43      L
        A AmoebaIsGrowing
        ; 7da9:   f0 04      B
        Q $7daf
        ; 7dab:   a9 00      L
        A #$00
        ; 7dad:   85 8c      S
        A AmeobaCouldGrowLastTick
        ; 7daf:   a5 42      L
        A AmeobaCouldGrowThisTick
        ; 7db1:   85 43      S
        A AmoebaIsGrowing

; Reset variables for next frame.
        ; 7db3:   a9 00      L
        A #$00
        ; 7db5:   85 42      S
        A AmeobaCouldGrowThisTick
        ; 7db7:   ad 02 98   L
        A AmoebaCellCountThisTick
        ; 7dba:   8d 03 98   S
        A AmoebaCellCountPreviousTick
        ; 7dbd:   a9 00      L
        A #$00
        ; 7dbf:   8d 02 98   S
        A AmoebaCellCountThisTick
        ; 7dc2:   60         R
        S 

; After Rockford has been dead for 16 ticks pressing fire continues.

DeathClick:
        ; 7dc3:   20 69 6b   J
        R ReadFireButtonCurrentPlayer
        ; 7dc6:   a5 96      L
        A RockfordDeadTicks
        ; 7dc8:   c9 10      C
        P #$10
        ; 7dca:   d0 0c      B
        E $7dd8
        ; 7dcc:   a5 b8      L
        A FireButtonStatus
        ; 7dce:   d0 08      B
        E $7dd8
        ; 7dd0:   a5 af      L
        A TimeCaveHasRan
        ; 7dd2:   f0 04      B
        Q $7dd8
        ; 7dd4:   a9 02      L
        A #$02
        ; 7dd6:   85 97      S
        A ExitCaveFlag
        ; 7dd8:   60         R
        S 

; 

ProcessCave:
        ; 7dd9:   a9 16      L
        A #$16
        ; 7ddb:   85 02      S
        A __CoverLevel__LineAddressTable
        ; 7ddd:   a5 5d      L
        A Cave
        ; 7ddf:   c9 11      C
        P #$11
        ; 7de1:   90 04      B
        C __ProcessCave__NotBonusCave


__ProcessCave__BonusCave:
        ; 7de3:   a9 0f      L
        A #$0f
        ; 7de5:   85 02      S
        A __CoverLevel__LineAddressTable


__ProcessCave__NotBonusCave:
        ; 7de7:   a9 01      L
        A #$01
        ; 7de9:   85 92      S
        A CaveMatrixY
        ; 7deb:   20 cd 76   J
        R ResetCaveCurrentCellPtr
        ; 7dee:   a9 10      L
        A #$10
        ; 7df0:   c5 96      C
        P RockfordDeadTicks
        ; 7df2:   f0 02      B
        Q $7df6
        ; 7df4:   e6 96      I
        C RockfordDeadTicks
        ; 7df6:   20 c3 7d   J
        R DeathClick
        ; 7df9:   20 a3 7d   J
        R PreTickAmoebaProcessing


__ProcessCave__NewRow:
        ; 7dfc:   a9 00      L
        A #$00
        ; 7dfe:   85 91      S
        A CaveMatrixX


__ProcessCave__ProcessCurrentCell:
        ; 7e00:   a0 29      L
        Y #$29
        ; 7e02:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 7e04:   0a         A
        L A
        ; 7e05:   aa         T
        X 
        ; 7e06:   bd 69 5f   L
        A ObjHandlerVectorTable+1,X
        ; 7e09:   f0 0a      B
        Q __ProcessCave__NoObjectHandler


__ProcessCave__ObjectHandler:
        ; 7e0b:   85 39      S
        A ObjHandlerVector+1
        ; 7e0d:   bd 68 5f   L
        A ObjHandlerVectorTable,X
        ; 7e10:   85 38      S
        A ObjHandlerVector
        ; 7e12:   6c 38 00   J
        P (ObjHandlerVector)


__ProcessCave__NoObjectHandler:
        ; 7e15:   a0 00      L
        Y #$00
        ; 7e17:   b1 32      L
        A (CaveCurrentCellPtr),Y
        ; 7e19:   aa         T
        X 
        ; 7e1a:   bd e8 5e   L
        A ObjCodeFromScannedThisTickCodeTable,X
        ; 7e1d:   f0 02      B
        Q __ProcessCave__NextCell


__ProcessCave__TurnTrailerToBaseType:
        ; 7e1f:   91 32      S
        A (CaveCurrentCellPtr),Y


__ProcessCave__NextCell:
        ; 7e21:   e6 32      I
        C CaveCurrentCellPtr
        ; 7e23:   d0 02      B
        E __ProcessCave__IncX


__ProcessCave__BumpUpCellPtrHigh:
        ; 7e25:   e6 33      I
        C CaveCurrentCellPtr+1


__ProcessCave__IncX:
        ; 7e27:   e6 91      I
        C CaveMatrixX
        ; 7e29:   a5 91      L
        A CaveMatrixX
        ; 7e2b:   c9 28      C
        P #$28
        ; 7e2d:   d0 d1      B
        E __ProcessCave__ProcessCurrentCell


__ProcessCave__NextRow:
        ; 7e2f:   20 d2 7c   J
        R CaveRowTransitionDelay
        ; 7e32:   e6 92      I
        C CaveMatrixY
        ; 7e34:   a5 92      L
        A CaveMatrixY
        ; 7e36:   c5 02      C
        P __CoverLevel__LineAddressTable
        ; 7e38:   d0 c2      B
        E __ProcessCave__NewRow
        ; 7e3a:   20 6b 7d   J
        R HandleInGameKeys
        ; 7e3d:   60         R
        S 


_NumTo3DigitDigits__Data_:
        ; 7e3e:   00 00 01
        


NumTo3DigitDigits:
        ; 7e41:   a2 02      L
        X #$02
        ; 7e43:   a9 00      L
        A #$00


NumTo3DigitDigits__ZeroDigit:
        ; 7e45:   95 c3      S
        A NumTo3DigitDigits__Result,X
        ; 7e47:   ca         D
        X 
        ; 7e48:   10 fb      B
        L NumTo3DigitDigits__ZeroDigit


NumTo3DigitDigits__CheckForTrivialCase:
        ; 7e4a:   a5 c6      L
        A NumTo3DigitDigits__NumberToConvert
        ; 7e4c:   f0 17      B
        Q NumTo3DigitDigits__Exit


NumTo3DigitDigits__NonTrivialCase:
        ; 7e4e:   a2 02      L
        X #$02
        ; 7e50:   18         C
        C 


NumTo3DigitDigits__IncrementResultLoop:
        ; 7e51:   b5 c3      L
        A NumTo3DigitDigits__Result,X
        ; 7e53:   7d 3e 7e   A
        C _NumTo3DigitDigits__Data_,X
        ; 7e56:   c9 0a      C
        P #$0a
        ; 7e58:   90 02      B
        C $7e5c
        ; 7e5a:   e9 0a      S
        C #$0a
        ; 7e5c:   95 c3      S
        A NumTo3DigitDigits__Result,X
        ; 7e5e:   ca         D
        X 
        ; 7e5f:   10 f0      B
        L NumTo3DigitDigits__IncrementResultLoop


NumTo3DigitDigits__CheckIfDone:
        ; 7e61:   c6 c6      D
        C NumTo3DigitDigits__NumberToConvert
        ; 7e63:   d0 e9      B
        E NumTo3DigitDigits__NonTrivialCase


NumTo3DigitDigits__Exit:
        ; 7e65:   60         R
        S 

; 0: Next level
; 1: Is bonus cave

LevelSequenceAndBonusLevelStatusArray:
        ; 7e66:   02 00 03 00
        04 00 11 00  06 00 07 00  08 00 12 00
        ; 7e76:   0a 00 0b 00
        0c 00 13 00  0e 00 0f 00  10 00 14 00
        ; 7e86:   05 01 09 01
        0d 01 15 01

; 

BufferLevel:
        ; 7e8e:   a5 5d      L
        A Cave
        ; 7e90:   c5 99      C
        P UnpackedCaveNumber
        ; 7e92:   f0 24      B
        Q __BufferLevel__InitRandomSeedAndColours


__BufferLevel__DoBuffer:
        ; 7e94:   85 99      S
        A UnpackedCaveNumber
        ; 7e96:   0a         A
        L A
        ; 7e97:   aa         T
        X 
        ; 7e98:   bd 65 7e   L
        A LevelSequenceAndBonusLevelStatusArray-1,X
        ; 7e9b:   85 a6      S
        A IsBonusLevelFlag
        ; 7e9d:   18         C
        C 
        ; 7e9e:   a9 2e      L
        A #&lt;CaveAData
        ; 7ea0:   7d 04 58   A
        C LevelOffsetArray-2,X
        ; 7ea3:   85 3c      S
        A CurrentLevelDataPtr
        ; 7ea5:   a9 58      L
        A #&gt;CaveAData
        ; 7ea7:   7d 05 58   A
        C LevelOffsetArray-1,X
        ; 7eaa:   85 3d      S
        A CurrentLevelDataPtr+1
        ; 7eac:   a0 00      L
        Y #$00


__BufferLevel__CopyElement:
        ; 7eae:   b1 3c      L
        A (CurrentLevelDataPtr),Y
        ; 7eb0:   99 00 24   S
        A BufferedLevel_CaveNumber,Y
        ; 7eb3:   c8         I
        Y 
        ; 7eb4:   c0 f0      C
        Y #$f0
        ; 7eb6:   d0 f6      B
        E __BufferLevel__CopyElement


__BufferLevel__InitRandomSeedAndColours:
        ; 7eb8:   a6 5e      L
        X Level
        ; 7eba:   bd 04 24   L
        A BufferedLevel_InitialRandomSeedForSublevel1,X
        ; 7ebd:   85 3e      S
        A RandSeed2
        ; 7ebf:   85 40      S
        A OrgRandSeed2_UNUSED_
        ; 7ec1:   a9 00      L
        A #$00
        ; 7ec3:   85 3f      S
        A RandSeed1
        ; 7ec5:   85 41      S
        A OrgRandSeed1_UNUSED_
        ; 7ec7:   ad 13 24   L
        A BufferedLevel_BackgroundColour1
        ; 7eca:   8d 22 d0   S
        A Vic_BkgndColour1
        ; 7ecd:   ad 14 24   L
        A BufferedLevel_BackgroundColour2
        ; 7ed0:   8d 23 d0   S
        A Vic_BkgndColour2
        ; 7ed3:   a0 28      L
        Y #$28
        ; 7ed5:   ad 15 24   L
        A BufferedLevel_ForegroundColour
        ; 7ed8:   20 e3 6a   J
        R SetupColourRam
        ; 7edb:   60         R
        S 

; $

InitGameVariablesFromLevelData:
        ; 7edc:   a9 00      L
        A #$00
        ; 7ede:   85 42      S
        A AmeobaCouldGrowThisTick
        ; 7ee0:   85 43      S
        A AmoebaIsGrowing
        ; 7ee2:   85 96      S
        A RockfordDeadTicks
        ; 7ee4:   85 97      S
        A ExitCaveFlag
        ; 7ee6:   85 8d      S
        A MagicWallActiveState
        ; 7ee8:   85 8e      S
        A MagicWallActiveFrameCounter
        ; 7eea:   85 8f      S
        A MagicWallActiveSeconds
        ; 7eec:   85 90      S
        A LevelCompleteFlag
        ; 7eee:   8d 02 98   S
        A AmoebaCellCountThisTick
        ; 7ef1:   85 af      S
        A TimeCaveHasRan
        ; 7ef3:   85 ae      S
        A SubSecondCounter
        ; 7ef5:   85 9f      S
        A EnteredOutboxFlag
        ; 7ef7:   85 9b      S
        A SecondsDontPass
        ; 7ef9:   8d 78 98   S
        A $9878
        ; 7efc:   20 86 7a   J
        R RedefineMagicWallCharsToNormalWall
        ; 7eff:   a6 5e      L
        X Level
        ; 7f01:   bd cd 7c   L
        A GameSpeedsForSublevelsArray,X
        ; 7f04:   85 9c      S
        A MatrixRowTransitionDelay

; Set cave time limit.
        ; 7f06:   bd 0e 24   L
        A BufferedLevel_CaveTimeForSublevel1,X
        ; 7f09:   85 c7      S
        A CaveTimeLimit
        ; 7f0b:   85 c6      S
        A NumTo3DigitDigits__NumberToConvert
        ; 7f0d:   20 41 7e   J
        R NumTo3DigitDigits
        ; 7f10:   a2 02      L
        X #$02
        ; 7f12:   b5 c3      L
        A NumTo3DigitDigits__Result,X
        ; 7f14:   95 ab      S
        A TimeLeft,X
        ; 7f16:   09 10      O
        A #$10
        ; 7f18:   9d 44 98   S
        A TimeLeftText,X
        ; 7f1b:   ca         D
        X 
        ; 7f1c:   10 f4      B
        L $7f12

; Set cave diamond quota.
        ; 7f1e:   a6 5e      L
        X Level
        ; 7f20:   bd 09 24   L
        A BufferedLevel_DiamondsNeededForSublevel1,X
        ; 7f23:   85 c6      S
        A NumTo3DigitDigits__NumberToConvert
        ; 7f25:   20 41 7e   J
        R NumTo3DigitDigits
        ; 7f28:   a2 01      L
        X #$01
        ; 7f2a:   b5 c4      L
        A NumTo3DigitDigits__Result+1,X
        ; 7f2c:   95 b2      S
        A DiamondQuotaDigits,X
        ; 7f2e:   ca         D
        X 
        ; 7f2f:   10 f9      B
        L $7f2a

; Set cave diamond diamond values.
        ; 7f31:   20 44 71   J
        R DiamondQuotaDigitsToString
        ; 7f34:   ad 02 24   L
        A BufferedLevel_InitialDiamondValue
        ; 7f37:   85 c6      S
        A NumTo3DigitDigits__NumberToConvert
        ; 7f39:   20 41 7e   J
        R NumTo3DigitDigits
        ; 7f3c:   a2 02      L
        X #$02
        ; 7f3e:   b5 c3      L
        A NumTo3DigitDigits__Result,X
        ; 7f40:   95 51      S
        A ScoreIncrementDigits+3,X
        ; 7f42:   ca         D
        X 
        ; 7f43:   10 f9      B
        L $7f3e
        ; 7f45:   ad 03 24   L
        A BufferedLevel_ExtraDiamondValue
        ; 7f48:   85 c6      S
        A NumTo3DigitDigits__NumberToConvert
        ; 7f4a:   20 41 7e   J
        R NumTo3DigitDigits
        ; 7f4d:   a2 02      L
        X #$02
        ; 7f4f:   b5 c3      L
        A NumTo3DigitDigits__Result,X
        ; 7f51:   95 b4      S
        A ExtraDiamondValue,X
        ; 7f53:   ca         D
        X 
        ; 7f54:   10 f9      B
        L $7f4f
        ; 7f56:   20 51 71   J
        R ScoreIncrementToString

; Reset diamond count.
        ; 7f59:   a9 00      L
        A #$00
        ; 7f5b:   85 b0      S
        A DiamondCountDigits
        ; 7f5d:   85 b1      S
        A DiamondCountDigits+1
        ; 7f5f:   09 10      O
        A #$10
        ; 7f61:   8d 41 98   S
        A $9841
        ; 7f64:   8d 42 98   S
        A $9842

; 
        ; 7f67:   a9 01      L
        A #$01
        ; 7f69:   85 8c      S
        A AmeobaCouldGrowLastTick
        ; 7f6b:   85 93      S
        A FlashingEntryBoxFlag
        ; 7f6d:   a9 04      L
        A #$04
        ; 7f6f:   85 95      S
        A FlashingEntryBoxCountDown
        ; 7f71:   a5 9f      L
        A EnteredOutboxFlag
        ; 7f73:   d0 0c      B
        E __InitGameVariablesFromLevelData__NotTwoJoysticksOnePlayer
        ; 7f75:   a5 a4      L
        A NumJoysticksMinusOne
        ; 7f77:   49 01      E
        R #$01
        ; 7f79:   25 9e      A
        D NumPlayerMinusOne
        ; 7f7b:   f0 04      B
        Q __InitGameVariablesFromLevelData__NotTwoJoysticksOnePlayer


__InitGameVariablesFromLevelData__TwoJoysticksOnePlayer:
; If we've got two players using a single joystick give them a bit more time.
        ; 7f7d:   a9 06      L
        A #$06
        ; 7f7f:   85 95      S
        A FlashingEntryBoxCountDown


__InitGameVariablesFromLevelData__NotTwoJoysticksOnePlayer:
        ; 7f81:   a5 5d      L
        A Cave
        ; 7f83:   c9 02      C
        P #$02
        ; 7f85:   d0 02      B
        E __InitGameVariablesFromLevelData__NotCaveB


__InitGameVariablesFromLevelData__CaveB:
; Cave B gets a tad more time.
        ; 7f87:   e6 95      I
        C FlashingEntryBoxCountDown


__InitGameVariablesFromLevelData__NotCaveB:
        ; 7f89:   a9 7f      L
        A #$7f
        ; 7f8b:   85 9a      S
        A AmoebaGrowthProbabilityMask
        ; 7f8d:   a9 07      L
        A #$07
        ; 7f8f:   85 ff      S
        A AnimationEnableFlags

; Bonus caves have all animations enabled and the rest use .LevelActiveAnimations[].
; Why all the logic for enabling animations are not part of the level data is beyond me.
        ; 7f91:   a6 5d      L
        X Cave
        ; 7f93:   e0 11      C
        X #$11
        ; 7f95:   b0 06      B
        S $7f9d


__InitGameVariablesFromLevelData__NotBonusCave:
        ; 7f97:   ca         D
        X 
        ; 7f98:   bd 79 83   L
        A LevelActiveAnimations,X


__InitGameVariablesFromLevelData__BonusCave:
        ; 7f9b:   85 ff      S
        A AnimationEnableFlags
        ; 7f9d:   60         R
        S 

; 

SetTopLineTextToGameOverAndDelay:
        ; 7f9e:   a9 f4      L
        A #&lt;Text_GameOver
        ; 7fa0:   85 46      S
        A LocalVar
        ; 7fa2:   a9 6b      L
        A #&gt;Text_GameOver
        ; 7fa4:   85 47      S
        A LocalVar+1
        ; 7fa6:   20 16 6b   J
        R SetTopLineText
        ; 7fa9:   20 0c 7d   J
        R FourDelays
        ; 7fac:   60         R
        S 

; 

WaitForDelayOrNextPlayersButton:
        ; 7fad:   a0 75      L
        Y #$75


__WaitForDelayOrNextPlayersButton__OuterDelayLoop:
        ; 7faf:   a2 80      L
        X #$80


__WaitForDelayOrNextPlayersButton__InnerDelayLoop:
        ; 7fb1:   a5 a6      L
        A IsBonusLevelFlag
        ; 7fb3:   d0 07      B
        E __WaitForDelayOrNextPlayersButton__IsBonusLevel


__WaitForDelayOrNextPlayersButton__NotBonusLevel:
        ; 7fb5:   a5 9d      L
        A CurrentPlayer
        ; 7fb7:   49 01      E
        R #$01
        ; 7fb9:   4c be 7f   J
        P __WaitForDelayOrNextPlayersButton__ReadButton


__WaitForDelayOrNextPlayersButton__IsBonusLevel:
        ; 7fbc:   a5 9d      L
        A CurrentPlayer


__WaitForDelayOrNextPlayersButton__ReadButton:
        ; 7fbe:   20 6b 6b   J
        R ReadFireButtonPlayerInA
        ; 7fc1:   d0 04      B
        E __WaitForDelayOrNextPlayersButton__NotPressed


__WaitForDelayOrNextPlayersButton__Pressed:
        ; 7fc3:   a0 01      L
        Y #$01
        ; 7fc5:   a2 01      L
        X #$01


__WaitForDelayOrNextPlayersButton__NotPressed:
        ; 7fc7:   ca         D
        X 
        ; 7fc8:   d0 e7      B
        E __WaitForDelayOrNextPlayersButton__InnerDelayLoop
        ; 7fca:   88         D
        Y 
        ; 7fcb:   d0 e2      B
        E __WaitForDelayOrNextPlayersButton__OuterDelayLoop
        ; 7fcd:   60         R
        S 

; 

OutOfTimeLoop:
        ; 7fce:   a9 14      L
        A #$14
        ; 7fd0:   8d 06 98   S
        A __OutOfTimeLoop__Counter
        ; 7fd3:   20 04 6b   J
        R BackupTopLine
        ; 7fd6:   a9 1c      L
        A #&lt;Text_OutOfTime
        ; 7fd8:   85 46      S
        A LocalVar
        ; 7fda:   a9 6c      L
        A #&gt;Text_OutOfTime
        ; 7fdc:   85 47      S
        A LocalVar+1
        ; 7fde:   20 16 6b   J
        R SetTopLineText
        ; 7fe1:   20 ad 7f   J
        R WaitForDelayOrNextPlayersButton

; Restore top line text.
        ; 7fe4:   a9 62      L
        A #&lt;TopLineBackup
        ; 7fe6:   85 46      S
        A LocalVar
        ; 7fe8:   a9 98      L
        A #&gt;TopLineBackup
        ; 7fea:   85 47      S
        A LocalVar+1
        ; 7fec:   20 16 6b   J
        R SetTopLineText
        ; 7fef:   20 ad 7f   J
        R WaitForDelayOrNextPlayersButton
        ; 7ff2:   20 ad 7f   J
        R WaitForDelayOrNextPlayersButton
        ; 7ff5:   20 ad 7f   J
        R WaitForDelayOrNextPlayersButton
        ; 7ff8:   ce 06 98   D
        C __OutOfTimeLoop__Counter
        ; 7ffb:   d0 04      B
        E $8001
        ; 7ffd:   a9 00      L
        A #$00
        ; 7fff:   85 b8      S
        A FireButtonStatus
        ; 8001:   a5 b8      L
        A FireButtonStatus
        ; 8003:   d0 ce      B
        E $7fd3
        ; 8005:   60         R
        S 

; 

ProcessBonusLevelAndInterLevelInfoDisplay:
        ; 8006:   a5 5d      L
        A Cave
        ; 8008:   0a         A
        L A
        ; 8009:   aa         T
        X 
        ; 800a:   bd 65 7e   L
        A NumTo3DigitDigits__Exit,X
        ; 800d:   85 a6      S
        A IsBonusLevelFlag
        ; 800f:   f0 11      B
        Q $8022
        ; 8011:   a9 30      L
        A #&lt;Text_BonusLife
        ; 8013:   85 46      S
        A LocalVar
        ; 8015:   a9 6c      L
        A #&gt;Text_BonusLife
        ; 8017:   85 47      S
        A LocalVar+1
        ; 8019:   20 16 6b   J
        R SetTopLineText
        ; 801c:   20 39 70   J
        R ExtraLife
        ; 801f:   4c 2d 80   J
        P $802d
        ; 8022:   a9 4e      L
        A #&lt;CurrentPlayerInfoText
        ; 8024:   85 46      S
        A LocalVar
        ; 8026:   a9 98      L
        A #&gt;CurrentPlayerInfoText
        ; 8028:   85 47      S
        A LocalVar+1
        ; 802a:   20 16 6b   J
        R SetTopLineText
        ; 802d:   60         R
        S 

; 

PostCaveRunActions:
        ; 802e:   a5 af      L
        A TimeCaveHasRan
        ; 8030:   c5 c7      C
        P CaveTimeLimit
        ; 8032:   d0 0c      B
        E __PostRunCaveActions__CheckIfGameOver


__PostRunCaveActions__TimeLimitReached:
        ; 8034:   a9 00      L
        A #$00
        ; 8036:   85 94      S
        A EnableSomeSFXAndMarqueeUpdates

; Without this the timer never display 000.
; It sets the first character of the third digit to zero.
; Only the first character need be set because BackupTopLine
; only looks at the first and .SetTopLineText takes a string.
        ; 8038:   a9 10      L
        A #$10
        ; 803a:   8d 18 0c   S
        A GameTileMap1_or_TitleTextTileMap+$18
        ; 803d:   20 ce 7f   J
        R OutOfTimeLoop


__PostRunCaveActions__CheckIfGameOver:
        ; 8040:   a5 a0      L
        A GameOverFlag
        ; 8042:   f0 0e      B
        Q __PostRunCaveActions__NotGameOver


__PostRunCaveActions__GameOver:
        ; 8044:   a9 00      L
        A #$00
        ; 8046:   85 94      S
        A EnableSomeSFXAndMarqueeUpdates
        ; 8048:   20 9e 7f   J
        R SetTopLineTextToGameOverAndDelay
        ; 804b:   a9 02      L
        A #$02
        ; 804d:   85 8d      S
        A MagicWallActiveState
        ; 804f:   4c 59 80   J
        P $8059


__PostRunCaveActions__NotGameOver:
        ; 8052:   a5 5d      L
        A Cave
        ; 8054:   f0 03      B
        Q $8059
        ; 8056:   20 06 80   J
        R ProcessBonusLevelAndInterLevelInfoDisplay

; Shut down magic walls.
        ; 8059:   a9 01      L
        A #$01
        ; 805b:   85 bd      S
        A PlayRevealLevelSoundAndRedefineCharFlag
        ; 805d:   20 f4 7c   J
        R ResetSound
        ; 8060:   20 f9 76   J
        R CoverLevel
        ; 8063:   20 db 76   J
        R FillInflatedCaveWithScrollingSteelWallChar
        ; 8066:   a5 a0      L
        A GameOverFlag
        ; 8068:   f0 03      B
        Q $806d
        ; 806a:   20 0c 7d   J
        R FourDelays
        ; 806d:   60         R
        S 

; For level 1:
; >C:0800 -A)}#w2F/C  &z5I.B TU -A)}#w2F/C  &z5I.B
; >C:0828             0D2F%y3G%y.B4H3G
; >C:0850 GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
; >C:0878 GAAAAAA.AATAP.AAAAAPAPAAAAAAA.AAAAPAAAAG
; >C:08a0 GAP%PAAAAAA.AAAAAAAAAPTAAPAAAA.AAAAA.AAG
; >C:08c8 GAAAAAAAAAA.AA.AAAAAPAPAAPAAAAAAAAPAAAAG
; >C:08f0 GPA..AAAAAAAAAPAAAAAAPAAPAAAAPAAAPAAAAAG
; >C:0918 GPAPPAAAAAAAAAPPAAPAAAAAAAAPAAAAAAPAP.AG
; >C:0940 GAAAPAAPAAAAAAAAPAAAAAPA.PAAAAAAAAPAPPAG
; >C:0968 GBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBAAAPAAPAG
; >C:0990 GA.AAAPAATA.AAPAPAAAAAAAAAATAP.AAAAAAPAG
; >C:09b8 GAATAAAAAPAAAAA.AAAAAAAAP..PAATAAAAPAAAG
; >C:09e0 GAAAPAAPAPAAAAAAAAAAAAAAPPAPAAPAAAAAAAAG
; >C:0a08 GA.AAAAAPAAAAAAAAPP.AAAAAAAPAAPATAAAA.AG
; >C:0a30 GAPAA.AAPA..AAAAAPAPTAATAAAAPAAAPAATAPAG
; >C:0a58 GATPAAAAAAAAAAAAAAPPPAAPAAAAAAAATAAAAAPG
; >C:0a80 GAAAAAAAABBBBBBBBBBBBBBBBBBBBBBBBBBBBBBG
; >C:0aa8 G..AAAAAAAAA.AAATAAAAPAAAAAPAAAPAAAAAAAG
; >C:0ad0 GP.AAAAAAAAAPPAAPAAAAAAAAPAAAAAAPAP.AADG
; >C:0af8 GAPAAPAAAAAAAAPAAAAAPA..AAAATAAAPAPPAAAG
; >C:0b20 GAAAAPTAA.AAAAAAAAPAAAAAAPAPTAAAAAAPAAAG
; >C:0b48 GAAA.AA.APAAPAPPAAAAAAAAAPAPTAAAAAAPAAPG
; >C:0b70 GATAAAAPAAAAA.AAAAAAAAA.APAAPAAAAPAAAPAG
; >C:0b98 GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG

DecompressedLevelRowPointerArray:
; 806e&nbsp;&nbsp;&nbsp;CaveMatrix_or_TitleLogoTileMap&nbsp;&nbsp;&nbsp;CaveMatrix_or_TitleLogoTileMap+$28&nbsp;&nbsp;&nbsp;CaveMatrix_or_TitleLogoTileMap+$50&nbsp;&nbsp;&nbsp;CaveMatrix_or_TitleLogoTileMap+$78&nbsp;&nbsp;&nbsp;
; 8076&nbsp;&nbsp;&nbsp;CaveMatrix_or_TitleLogoTileMap+$a0&nbsp;&nbsp;&nbsp;CaveMatrix_or_TitleLogoTileMap+$c8&nbsp;&nbsp;&nbsp;CaveMatrix_or_TitleLogoTileMap+$f0&nbsp;&nbsp;&nbsp;CaveMatrix_or_TitleLogoTileMap+$118&nbsp;&nbsp;&nbsp;
; 807e&nbsp;&nbsp;&nbsp;CaveMatrix_or_TitleLogoTileMap+$140&nbsp;&nbsp;&nbsp;CaveMatrix_or_TitleLogoTileMap+$168&nbsp;&nbsp;&nbsp;CaveMatrix_or_TitleLogoTileMap+$190&nbsp;&nbsp;&nbsp;CaveMatrix_or_TitleLogoTileMap+$1b8&nbsp;&nbsp;&nbsp;
; 8086&nbsp;&nbsp;&nbsp;CaveMatrix_or_TitleLogoTileMap+$1e0&nbsp;&nbsp;&nbsp;CaveMatrix_or_TitleLogoTileMap+$208&nbsp;&nbsp;&nbsp;CaveMatrix_or_TitleLogoTileMap+$230&nbsp;&nbsp;&nbsp;CaveMatrix_or_TitleLogoTileMap+$258&nbsp;&nbsp;&nbsp;
; 808e&nbsp;&nbsp;&nbsp;CaveMatrix_or_TitleLogoTileMap+$280&nbsp;&nbsp;&nbsp;CaveMatrix_or_TitleLogoTileMap+$2a8&nbsp;&nbsp;&nbsp;CaveMatrix_or_TitleLogoTileMap+$2d0&nbsp;&nbsp;&nbsp;CaveMatrix_or_TitleLogoTileMap+$2f8&nbsp;&nbsp;&nbsp;
; 8096&nbsp;&nbsp;&nbsp;CaveMatrix_or_TitleLogoTileMap+$320&nbsp;&nbsp;&nbsp;CaveMatrix_or_TitleLogoTileMap+$348&nbsp;&nbsp;&nbsp;CaveMatrix_or_TitleLogoTileMap+$370&nbsp;&nbsp;&nbsp;CaveMatrix_or_TitleLogoTileMap+$398&nbsp;&nbsp;&nbsp;

ExecuteLevelDrawCommands__SetOutputPointer:
        ; 809e:   a5 dc      L
        A ObjParam2DuringUnpack
        ; 80a0:   0a         A
        L A
        ; 80a1:   a8         T
        Y 
        ; 80a2:   18         C
        C 
        ; 80a3:   b9 6e 80   L
        A DecompressedLevelRowPointerArray,Y
        ; 80a6:   65 db      A
        C ObjParam1DuringUnpack
        ; 80a8:   85 3a      S
        A ExecuteLevelDrawCommands__OutPtr
        ; 80aa:   b9 6f 80   L
        A DecompressedLevelRowPointerArray+1,Y
        ; 80ad:   69 00      A
        C #$00
        ; 80af:   85 3b      S
        A ExecuteLevelDrawCommands__OutPtr+1
        ; 80b1:   60         R
        S 

; .ObjTypeDuringUnpack   : object
; .ObjParam1DuringUnpack : x
; .ObjParam2DuringUnpack : y

ExecuteLevelDrawCommands__OutputSingle:
        ; 80b2:   20 9e 80   J
        R ExecuteLevelDrawCommands__SetOutputPointer
        ; 80b5:   a5 da      L
        A ObjTypeDuringUnpack
        ; 80b7:   a0 00      L
        Y #$00
        ; 80b9:   91 3a      S
        A (ExecuteLevelDrawCommands__OutPtr),Y
        ; 80bb:   60         R
        S 

; 

ExecuteLevelDrawCommands__DrawLine__StepTable:
; $ffd8 = -40 --> N
; $ffd9 = -39 --> NE
; $0001 = +1  --> E
; $0029 = +41 --> SE
; $0028 = +40 --> S
; $0027 = +39 --> SW
; $ffff = -1  --> W
; $ffd7 = -41 --> NW
        ; 80bc:   d8 ff d9 ff
        01 00 29 00  28 00 27 00  ff ff d7 ff

; A : direction : 0->N, 1->NE, 2->E, 3->SE, 4->S, 5->SW, 6->W, 7->NW
; .ExecuteLevelDrawCommands::LineLength: length

ExecuteLevelDrawCommands__DrawLine:
        ; 80cc:   a0 00      L
        Y #$00
        ; 80ce:   0a         A
        L A
        ; 80cf:   aa         T
        X 
        ; 80d0:   bd bc 80   L
        A ExecuteLevelDrawCommands__DrawLine__StepTable,X
        ; 80d3:   85 c9      S
        A CaveLineStepValue
        ; 80d5:   bd bd 80   L
        A ExecuteLevelDrawCommands__DrawLine__StepTable+1,X
        ; 80d8:   85 ca      S
        A CaveLineStepValue+1


__ExecuteLevelDrawCommands__DrawLine__Next:
        ; 80da:   c6 c8      D
        C ExecuteLevelDrawCommands__LineLength
        ; 80dc:   30 14      B
        I __ExecuteLevelDrawCommands__DrawLine__Finished
        ; 80de:   a5 da      L
        A ObjTypeDuringUnpack
        ; 80e0:   91 3a      S
        A (ExecuteLevelDrawCommands__OutPtr),Y
        ; 80e2:   18         C
        C 
        ; 80e3:   a5 3a      L
        A ExecuteLevelDrawCommands__OutPtr
        ; 80e5:   65 c9      A
        C CaveLineStepValue
        ; 80e7:   85 3a      S
        A ExecuteLevelDrawCommands__OutPtr
        ; 80e9:   a5 3b      L
        A ExecuteLevelDrawCommands__OutPtr+1
        ; 80eb:   65 ca      A
        C CaveLineStepValue+1
        ; 80ed:   85 3b      S
        A ExecuteLevelDrawCommands__OutPtr+1
        ; 80ef:   4c da 80   J
        P __ExecuteLevelDrawCommands__DrawLine__Next


__ExecuteLevelDrawCommands__DrawLine__Finished:
        ; 80f2:   60         R
        S 

; 

ExecuteLevelDrawCommands__OutputLine:
        ; 80f3:   20 9e 80   J
        R ExecuteLevelDrawCommands__SetOutputPointer
        ; 80f6:   a5 dd      L
        A ObjParam3DuringUnpack
        ; 80f8:   85 c8      S
        A ExecuteLevelDrawCommands__LineLength
        ; 80fa:   a5 df      L
        A ObjParam4DuringUnpack
        ; 80fc:   20 cc 80   J
        R ExecuteLevelDrawCommands__DrawLine
        ; 80ff:   60         R
        S 

; .ObjTypeDuringUnpack   : object
; .ObjParam1DuringUnpack : x
; .ObjParam2DuringUnpack : y
; .ObjParam3DuringUnpack : width
; .ObjParam4DuringUnpack : height

ExecuteLevelDrawCommands__DrawFilledRect:
        ; 8100:   20 9e 80   J
        R ExecuteLevelDrawCommands__SetOutputPointer
        ; 8103:   a5 df      L
        A ObjParam4DuringUnpack
        ; 8105:   85 c8      S
        A ExecuteLevelDrawCommands__LineLength

; 

__ExecuteLevelDrawCommands__DrawFilledRect__NextLine:
; In this function .ExecuteLevelDrawCommands::LineLength is the height of the rect.
        ; 8107:   c6 c8      D
        C ExecuteLevelDrawCommands__LineLength
        ; 8109:   30 1c      B
        I __ExecuteLevelDrawCommands__DrawFilledRect__Finished

; Draw a horizontal line of .ObjTypeDuringUnpack, length .ObjParam3DuringUnpack.
        ; 810b:   a4 dd      L
        Y ObjParam3DuringUnpack


__ExecuteLevelDrawCommands__DrawFilledRect__NextCell:
        ; 810d:   88         D
        Y 
        ; 810e:   30 07      B
        I __ExecuteLevelDrawCommands__DrawFilledRect__LineFinished
        ; 8110:   a5 da      L
        A ObjTypeDuringUnpack
        ; 8112:   91 3a      S
        A (ExecuteLevelDrawCommands__OutPtr),Y
        ; 8114:   4c 0d 81   J
        P __ExecuteLevelDrawCommands__DrawFilledRect__NextCell

; Next row.

__ExecuteLevelDrawCommands__DrawFilledRect__LineFinished:
        ; 8117:   18         C
        C 
        ; 8118:   a5 3a      L
        A ExecuteLevelDrawCommands__OutPtr
        ; 811a:   69 28      A
        C #$28
        ; 811c:   85 3a      S
        A ExecuteLevelDrawCommands__OutPtr
        ; 811e:   a5 3b      L
        A ExecuteLevelDrawCommands__OutPtr+1
        ; 8120:   69 00      A
        C #$00
        ; 8122:   85 3b      S
        A ExecuteLevelDrawCommands__OutPtr+1
        ; 8124:   4c 07 81   J
        P __ExecuteLevelDrawCommands__DrawFilledRect__NextLine

; 

__ExecuteLevelDrawCommands__DrawFilledRect__Finished:
        ; 8127:   60         R
        S 

; .ObjTypeDuringUnpack   : outer object
; .ObjParam1DuringUnpack : x
; .ObjParam2DuringUnpack : y
; .ObjParam3DuringUnpack : width
; .ObjParam4DuringUnpack : height
; .ObjParam5DuringUnpack : inner object

ExecuteLevelDrawCommands__OutputFilledRect:
        ; 8128:   20 00 81   J
        R ExecuteLevelDrawCommands__DrawFilledRect
        ; 812b:   a5 e0      L
        A ObjParam5DuringUnpack
        ; 812d:   85 da      S
        A ObjTypeDuringUnpack
        ; 812f:   e6 db      I
        C ObjParam1DuringUnpack
        ; 8131:   e6 dc      I
        C ObjParam2DuringUnpack
        ; 8133:   c6 dd      D
        C ObjParam3DuringUnpack
        ; 8135:   c6 dd      D
        C ObjParam3DuringUnpack
        ; 8137:   c6 df      D
        C ObjParam4DuringUnpack
        ; 8139:   c6 df      D
        C ObjParam4DuringUnpack
        ; 813b:   20 00 81   J
        R ExecuteLevelDrawCommands__DrawFilledRect
        ; 813e:   60         R
        S 

; .ObjTypeDuringUnpack   : object
; .ObjParam1DuringUnpack : x
; .ObjParam2DuringUnpack : y
; .ObjParam3DuringUnpack : width
; .ObjParam4DuringUnpack : height

ExecuteLevelDrawCommands__OutputRect:
        ; 813f:   20 9e 80   J
        R ExecuteLevelDrawCommands__SetOutputPointer

; Draw top edge heading east, length is param3-1.
        ; 8142:   a5 dd      L
        A ObjParam3DuringUnpack
        ; 8144:   85 c8      S
        A ExecuteLevelDrawCommands__LineLength
        ; 8146:   c6 c8      D
        C ExecuteLevelDrawCommands__LineLength
        ; 8148:   a9 02      L
        A #$02
        ; 814a:   20 cc 80   J
        R ExecuteLevelDrawCommands__DrawLine

; Draw right edge heading south, length is param4-1. This fills the remaining cell of the top edge.
        ; 814d:   a5 df      L
        A ObjParam4DuringUnpack
        ; 814f:   85 c8      S
        A ExecuteLevelDrawCommands__LineLength
        ; 8151:   c6 c8      D
        C ExecuteLevelDrawCommands__LineLength
        ; 8153:   a9 04      L
        A #$04
        ; 8155:   20 cc 80   J
        R ExecuteLevelDrawCommands__DrawLine

; Draw bottom edge heading west, length is param3-1. This fills the remaining cell of the right edge.
        ; 8158:   a5 dd      L
        A ObjParam3DuringUnpack
        ; 815a:   85 c8      S
        A ExecuteLevelDrawCommands__LineLength
        ; 815c:   c6 c8      D
        C ExecuteLevelDrawCommands__LineLength
        ; 815e:   a9 06      L
        A #$06
        ; 8160:   20 cc 80   J
        R ExecuteLevelDrawCommands__DrawLine

; Draw left edge heading north, length is param4-1. This fills the remaining cell of the bottom edge.
        ; 8163:   a5 df      L
        A ObjParam4DuringUnpack
        ; 8165:   85 c8      S
        A ExecuteLevelDrawCommands__LineLength
        ; 8167:   c6 c8      D
        C ExecuteLevelDrawCommands__LineLength
        ; 8169:   a9 00      L
        A #$00
        ; 816b:   20 cc 80   J
        R ExecuteLevelDrawCommands__DrawLine
        ; 816e:   60         R
        S 

; 

ExecuteLevelDrawCommands__Advance3Bytes:
        ; 816f:   c8         I
        Y 
        ; 8170:   c8         I
        Y 
        ; 8171:   c8         I
        Y 
        ; 8172:   84 cb      S
        Y CaveUnpackOffset
        ; 8174:   60         R
        S 


ExecuteLevelDrawCommands__Advance5Bytes:
        ; 8175:   c8         I
        Y 
        ; 8176:   c8         I
        Y 
        ; 8177:   20 6f 81   J
        R ExecuteLevelDrawCommands__Advance3Bytes
        ; 817a:   60         R
        S 


ExecuteLevelDrawCommands__Advance6Bytes:
        ; 817b:   c8         I
        Y 
        ; 817c:   20 75 81   J
        R ExecuteLevelDrawCommands__Advance5Bytes
        ; 817f:   60         R
        S 

; 

ExecuteLevelDrawCommands:
        ; 8180:   a0 00      L
        Y #$00
        ; 8182:   84 cb      S
        Y CaveUnpackOffset


__ExecuteLevelDrawCommands__MainLoop:
        ; 8184:   a4 cb      L
        Y CaveUnpackOffset

; .BufferedLevel_Object
; ---------------------------------
; |$80|$40|$20|$10|$08|$04|$02|$01|
; ---------------------------------
; |Command|        Object         |
; ---------------------------------
; 
; Commands:
; $00 : single object     : (param1:x, param2:y)
; $40 : line              : (param1:x, param2:y, param3:length, param4:direction)
; $80 : filled rectangle  : (param1:x, param2:y, param3:width,  param4:height, param5:inner object)
; $c0 : rectangle
        ; 8186:   b9 20 24   L
        A BufferedLevel_Object,Y
        ; 8189:   c9 ff      C
        P #$ff
        ; 818b:   f0 62      B
        Q __ExecuteLevelDrawCommands__Exit
        ; 818d:   29 3f      A
        D #$3f
        ; 818f:   85 da      S
        A ObjTypeDuringUnpack
        ; 8191:   c9 25      C
        P #$25
        ; 8193:   d0 0a      B
        E __ExecuteLevelDrawCommands__GenericElementProcessing


__ExecuteLevelDrawCommands__IsRockford:
        ; 8195:   b9 21 24   L
        A BufferedLevel_Param1,Y
        ; 8198:   85 44      S
        A RockfordX
        ; 819a:   b9 22 24   L
        A BufferedLevel_Param2,Y
        ; 819d:   85 45      S
        A RockfordY


__ExecuteLevelDrawCommands__GenericElementProcessing:
        ; 819f:   b9 21 24   L
        A BufferedLevel_Param1,Y
        ; 81a2:   85 db      S
        A ObjParam1DuringUnpack
        ; 81a4:   b9 22 24   L
        A BufferedLevel_Param2,Y
        ; 81a7:   85 dc      S
        A ObjParam2DuringUnpack
        ; 81a9:   b9 23 24   L
        A BufferedLevel_Param3,Y
        ; 81ac:   85 dd      S
        A ObjParam3DuringUnpack
        ; 81ae:   b9 24 24   L
        A BufferedLevel_Param4,Y
        ; 81b1:   85 df      S
        A ObjParam4DuringUnpack
        ; 81b3:   b9 25 24   L
        A BufferedLevel_Param5,Y
        ; 81b6:   85 e0      S
        A ObjParam5DuringUnpack


__ExecuteLevelDrawCommands__SwitchOnCommand:
        ; 81b8:   b9 20 24   L
        A BufferedLevel_Object,Y
        ; 81bb:   29 c0      A
        D #$c0
        ; 81bd:   d0 09      B
        E _CmdNotSingleObj


__ExecuteLevelDrawCommands__Case_SingleObject:
        ; 81bf:   20 6f 81   J
        R ExecuteLevelDrawCommands__Advance3Bytes
        ; 81c2:   20 b2 80   J
        R ExecuteLevelDrawCommands__OutputSingle
        ; 81c5:   4c ec 81   J
        P __ExecuteLevelDrawCommands__NextElement


_CmdNotSingleObj:
        ; 81c8:   c9 40      C
        P #$40
        ; 81ca:   d0 09      B
        E _CmdNotLine


__ExecuteLevelDrawCommands__Case_Line:
        ; 81cc:   20 75 81   J
        R ExecuteLevelDrawCommands__Advance5Bytes
        ; 81cf:   20 f3 80   J
        R ExecuteLevelDrawCommands__OutputLine
        ; 81d2:   4c ec 81   J
        P __ExecuteLevelDrawCommands__NextElement


_CmdNotLine:
        ; 81d5:   c9 80      C
        P #$80
        ; 81d7:   d0 09      B
        E _CmdNotFilledRect


__ExecuteLevelDrawCommands__Case_FilledRect:
        ; 81d9:   20 7b 81   J
        R ExecuteLevelDrawCommands__Advance6Bytes
        ; 81dc:   20 28 81   J
        R ExecuteLevelDrawCommands__OutputFilledRect
        ; 81df:   4c ec 81   J
        P __ExecuteLevelDrawCommands__NextElement


_CmdNotFilledRect:
        ; 81e2:   c9 c0      C
        P #$c0
        ; 81e4:   d0 06      B
        E __ExecuteLevelDrawCommands__NextElement


__ExecuteLevelDrawCommands__Case_Rect:
        ; 81e6:   20 75 81   J
        R ExecuteLevelDrawCommands__Advance5Bytes
        ; 81e9:   20 3f 81   J
        R ExecuteLevelDrawCommands__OutputRect


__ExecuteLevelDrawCommands__NextElement:
        ; 81ec:   4c 84 81   J
        P __ExecuteLevelDrawCommands__MainLoop


__ExecuteLevelDrawCommands__Exit:
        ; 81ef:   60         R
        S 

; 

TitleScreenFillInPlayerAndJoystick:
        ; 81f0:   a5 a3      L
        A TitleScreenInLicenseMode
        ; 81f2:   d0 1a      B
        E __TitleScreenFillInPlayerAndJoystick__Exit
        ; 81f4:   a5 9e      L
        A NumPlayerMinusOne
        ; 81f6:   18         C
        C 
        ; 81f7:   69 11      A
        C #$11
        ; 81f9:   8d 70 0b   S
        A CaveMatrix_or_TitleLogoTileMap+$370
        ; 81fc:   69 34      A
        C #$34
        ; 81fe:   8d 71 0b   S
        A CaveMatrix_or_TitleLogoTileMap+$371
        ; 8201:   a5 a4      L
        A NumJoysticksMinusOne
        ; 8203:   18         C
        C 
        ; 8204:   69 11      A
        C #$11
        ; 8206:   8d 84 0b   S
        A CaveMatrix_or_TitleLogoTileMap+$384
        ; 8209:   69 34      A
        C #$34
        ; 820b:   8d 85 0b   S
        A CaveMatrix_or_TitleLogoTileMap+$385


__TitleScreenFillInPlayerAndJoystick__Exit:
        ; 820e:   60         R
        S 

; 

FrameLevelWithSteelWall:
        ; 820f:   a9 07      L
        A #$07
        ; 8211:   85 da      S
        A ObjTypeDuringUnpack
        ; 8213:   a9 00      L
        A #$00
        ; 8215:   85 db      S
        A ObjParam1DuringUnpack
        ; 8217:   a9 02      L
        A #$02
        ; 8219:   85 dc      S
        A ObjParam2DuringUnpack
        ; 821b:   a9 28      L
        A #$28
        ; 821d:   85 dd      S
        A ObjParam3DuringUnpack
        ; 821f:   a9 16      L
        A #$16
        ; 8221:   85 df      S
        A ObjParam4DuringUnpack
        ; 8223:   20 3f 81   J
        R ExecuteLevelDrawCommands__OutputRect
        ; 8226:   60         R
        S 

; 

SetupTitleScreenText:
; Top two lines and BD logo (copies too much):
; 66e8-67e7 to 0800-08ff (From line 1 column 1 to line 7 column 16)
; 67e8-68e7 to 0900-09ff (From line 7 column 17 to line 13 column 32)
; 68e8-69e7 to 0a00-0aff (From line 13 column 33 to line 20 column 8)
; License text (starts too early):
; 69d0-6acf to 0ee8-0fe7 (Tilemap @ $0c00: L19 C25 - L25 C40)
        ; 8227:   a2 00      L
        X #$00
        ; 8229:   bd e8 66   L
        A Top2LinesAndBoulderDashLogo,X
        ; 822c:   9d 00 08   S
        A CaveMatrix_or_TitleLogoTileMap,X
        ; 822f:   bd e8 67   L
        A Top2LinesAndBoulderDashLogo+$100,X
        ; 8232:   9d 00 09   S
        A CaveMatrix_or_TitleLogoTileMap+$100,X
        ; 8235:   bd e8 68   L
        A Top2LinesAndBoulderDashLogo+$200,X
        ; 8238:   9d 00 0a   S
        A CaveMatrix_or_TitleLogoTileMap+$200,X

; .......l-i-c-e-n-s-e-d-..f-r-o-m-.......
; .......c-r-a-c-k-e-d-..b-y-..n-o-v-a-...
; ..............c-..1-9-8-4-..............
; .f-i-r-s-t-..s-t-a-r-..s-o-f-t-w-a-r-e-.
; m-i-c-r-o-..f-u-n-.*-.m-i-c-r-o-..f-u-n-
        ; 823b:   bd d0 69   L
        A Top2LinesAndBoulderDashLogo+$2e8,X
        ; 823e:   9d e8 0e   S
        A GameTileMap1_or_TitleTextTileMap+$2e8,X
        ; 8241:   e8         I
        X 
        ; 8242:   d0 e5      B
        E $8229

; When we first start the game the license text is shown below the logo.
; Pressing F1 replaces this text with some credits on the upper three lines
; and the lower two with game information such as starting cave and level:
; 
; ..by.peter.liepa....
; ..with.chris.grey...
; press.button.to.play
; 1.player..1.joystick
; .cave:.a..level:.1..
; 
; After a game has been played or the demo has completed the upper three
; lines are replaced with high and last scores for both players:
; 
; .plyr.1......plyr.2.
; .001750.last.000000.
; .001750.high.000000.
; 1.player..1.joystick
; .cave:.a..level:.1..
        ; 8244:   a5 cc      L
        A ForceCreditsMode
        ; 8246:   05 a2      O
        A IsDemoMode
        ; 8248:   f0 48      B
        Q __SetupTitleScreenText__ScoresMode


__SetupTitleScreenText__CreditsMode:
        ; 824a:   a2 00      L
        X #$00
        ; 824c:   a0 00      L
        Y #$00


__SetupTitleScreenText__ByPeterLiepaLoop:
        ; 824e:   b9 7c 6b   L
        A Text_ByPeterLiepa,Y
        ; 8251:   9d f8 0a   S
        A CaveMatrix_or_TitleLogoTileMap+$2f8,X
        ; 8254:   e8         I
        X 
        ; 8255:   18         C
        C 
        ; 8256:   69 34      A
        C #$34
        ; 8258:   9d f8 0a   S
        A CaveMatrix_or_TitleLogoTileMap+$2f8,X
        ; 825b:   e8         I
        X 
        ; 825c:   c8         I
        Y 
        ; 825d:   c0 14      C
        Y #$14
        ; 825f:   d0 ed      B
        E __SetupTitleScreenText__ByPeterLiepaLoop
        ; 8261:   a2 00      L
        X #$00
        ; 8263:   a0 00      L
        Y #$00


__SetupTitleScreenText__WithChrisGreyLoop:
        ; 8265:   b9 90 6b   L
        A Text__WithChrisGrey,Y
        ; 8268:   9d 20 0b   S
        A CaveMatrix_or_TitleLogoTileMap+$320,X
        ; 826b:   e8         I
        X 
        ; 826c:   18         C
        C 
        ; 826d:   69 34      A
        C #$34
        ; 826f:   9d 20 0b   S
        A CaveMatrix_or_TitleLogoTileMap+$320,X
        ; 8272:   e8         I
        X 
        ; 8273:   c8         I
        Y 
        ; 8274:   c0 14      C
        Y #$14
        ; 8276:   d0 ed      B
        E __SetupTitleScreenText__WithChrisGreyLoop
        ; 8278:   a2 00      L
        X #$00
        ; 827a:   a0 00      L
        Y #$00


__SetupTitleScreenText__PressButtonToPlayLoop:
        ; 827c:   b9 6c 6c   L
        A Text_PressButtonToPlay,Y
        ; 827f:   9d 48 0b   S
        A CaveMatrix_or_TitleLogoTileMap+$348,X
        ; 8282:   e8         I
        X 
        ; 8283:   18         C
        C 
        ; 8284:   69 34      A
        C #$34
        ; 8286:   9d 48 0b   S
        A CaveMatrix_or_TitleLogoTileMap+$348,X
        ; 8289:   e8         I
        X 
        ; 828a:   c8         I
        Y 
        ; 828b:   c0 14      C
        Y #$14
        ; 828d:   d0 ed      B
        E __SetupTitleScreenText__PressButtonToPlayLoop


__SetupTitleScreenText__JumpToPart2:
        ; 828f:   4c d7 82   J
        P __SetupTitleScreenText__Part2


__SetupTitleScreenText__ScoresMode:
        ; 8292:   a2 00      L
        X #$00
        ; 8294:   a0 00      L
        Y #$00


__SetupTitleScreenText__Plyr1Ply2Loop:
        ; 8296:   b9 b8 6b   L
        A Text_Plyr1Ply2,Y
        ; 8299:   9d f8 0a   S
        A CaveMatrix_or_TitleLogoTileMap+$2f8,X
        ; 829c:   e8         I
        X 
        ; 829d:   18         C
        C 
        ; 829e:   69 34      A
        C #$34
        ; 82a0:   9d f8 0a   S
        A CaveMatrix_or_TitleLogoTileMap+$2f8,X
        ; 82a3:   e8         I
        X 
        ; 82a4:   c8         I
        Y 
        ; 82a5:   c0 14      C
        Y #$14
        ; 82a7:   d0 ed      B
        E __SetupTitleScreenText__Plyr1Ply2Loop
        ; 82a9:   a2 00      L
        X #$00
        ; 82ab:   a0 00      L
        Y #$00
        ; 82ad:   b9 12 98   L
        A CurrentHighScoreText,Y
        ; 82b0:   9d 20 0b   S
        A CaveMatrix_or_TitleLogoTileMap+$320,X
        ; 82b3:   e8         I
        X 
        ; 82b4:   18         C
        C 
        ; 82b5:   69 34      A
        C #$34
        ; 82b7:   9d 20 0b   S
        A CaveMatrix_or_TitleLogoTileMap+$320,X
        ; 82ba:   e8         I
        X 
        ; 82bb:   c8         I
        Y 
        ; 82bc:   c0 14      C
        Y #$14
        ; 82be:   d0 ed      B
        E $82ad
        ; 82c0:   a2 00      L
        X #$00
        ; 82c2:   a0 00      L
        Y #$00
        ; 82c4:   b9 26 98   L
        A CurrentLastScoreText,Y
        ; 82c7:   9d 48 0b   S
        A CaveMatrix_or_TitleLogoTileMap+$348,X
        ; 82ca:   e8         I
        X 
        ; 82cb:   18         C
        C 
        ; 82cc:   69 34      A
        C #$34
        ; 82ce:   9d 48 0b   S
        A CaveMatrix_or_TitleLogoTileMap+$348,X
        ; 82d1:   e8         I
        X 
        ; 82d2:   c8         I
        Y 
        ; 82d3:   c0 14      C
        Y #$14
        ; 82d5:   d0 ed      B
        E $82c4


__SetupTitleScreenText__Part2:
        ; 82d7:   a2 00      L
        X #$00
        ; 82d9:   a0 00      L
        Y #$00


__SetupTitleScreenText__F1TextLine5Loop:
; .cave?.a..level?.1..
        ; 82db:   b9 44 6c   L
        A F1Text__Line5,Y
        ; 82de:   9d 98 0b   S
        A CaveMatrix_or_TitleLogoTileMap+$398,X
        ; 82e1:   e8         I
        X 
        ; 82e2:   18         C
        C 
        ; 82e3:   69 34      A
        C #$34
        ; 82e5:   9d 98 0b   S
        A CaveMatrix_or_TitleLogoTileMap+$398,X
        ; 82e8:   e8         I
        X 
        ; 82e9:   c8         I
        Y 
        ; 82ea:   c0 14      C
        Y #$14
        ; 82ec:   d0 ed      B
        E __SetupTitleScreenText__F1TextLine5Loop
        ; 82ee:   a2 00      L
        X #$00
        ; 82f0:   a0 00      L
        Y #$00


__SetupTitleScreenText__F1TextLine4Loop:
; 1.player..1.joystick
        ; 82f2:   b9 a4 6b   L
        A F1Text__Line4,Y
        ; 82f5:   9d 70 0b   S
        A CaveMatrix_or_TitleLogoTileMap+$370,X
        ; 82f8:   e8         I
        X 
        ; 82f9:   18         C
        C 
        ; 82fa:   69 34      A
        C #$34
        ; 82fc:   9d 70 0b   S
        A CaveMatrix_or_TitleLogoTileMap+$370,X
        ; 82ff:   e8         I
        X 
        ; 8300:   c8         I
        Y 
        ; 8301:   c0 14      C
        Y #$14
        ; 8303:   d0 ed      B
        E __SetupTitleScreenText__F1TextLine4Loop
        ; 8305:   a2 27      L
        X #$27
        ; 8307:   a9 20      L
        A #$20
        ; 8309:   9d c0 0b   S
        A CaveMatrix_or_TitleLogoTileMap+$3c0,X
        ; 830c:   ca         D
        X 
        ; 830d:   10 fa      B
        L $8309
        ; 830f:   20 f0 81   J
        R TitleScreenFillInPlayerAndJoystick
        ; 8312:   a9 00      L
        A #$00
        ; 8314:   85 cc      S
        A ForceCreditsMode
        ; 8316:   60         R
        S 


MusicNoteToFreqTable:
        ; 8317:   dc 02 0a 03
        3a 03 6c 03  a0 03 d2 03  12 04 4c 04
        ; 8327:   92 04 d6 04
        20 05 6e 05  b8 05 14 06  74 06 d8 06
        ; 8337:   40 07 a4 07
        24 08 98 08  24 09 ac 09  40 0a dc 0a
        ; 8347:   70 0b 28 0c
        e8 0c b0 0d  80 0e 48 0f  48 10 30 11
        ; 8357:   48 12 58 13
        80 14 b8 15  e0 16 50 18  d0 19 60 1b
        ; 8367:   00 1d 90 1e
        90 20 60 22  90 24 b0 26  00 29 70 2b
        ; 8377:   c0 2d
        


LevelActiveAnimations:
; >=4   : Amoeba
; bit 1 : Butterfly
; bit 0 : Firefly
        ; 8379:   00 01 00 02
        01 01 05 01  00 01 01 01  06 03 01 01
        ; 8389:   02 01 01 01
        

; 

MakeF1ScreenControlsLightBlue:
        ; 838d:   a9 0e      L
        A #$0e
        ; 838f:   a2 01      L
        X #$01

; line 23, column 1
        ; 8391:   9d 70 db   S
        A C64_ColourRam+$370,X

; line 23, column 21
        ; 8394:   9d 84 db   S
        A C64_ColourRam+$384,X

; line 24, column 15
        ; 8397:   9d a6 db   S
        A C64_ColourRam+$3a6,X

; line 24, column 35
        ; 839a:   9d ba db   S
        A C64_ColourRam+$3ba,X
        ; 839d:   ca         D
        X 
        ; 839e:   10 f1      B
        L $8391
        ; 83a0:   60         R
        S 

; 

MakeFirstTwoLinesYellow:
        ; 83a1:   a9 07      L
        A #$07
        ; 83a3:   a2 4f      L
        X #$4f
        ; 83a5:   9d 00 d8   S
        A C64_ColourRam,X
        ; 83a8:   ca         D
        X 
        ; 83a9:   10 fa      B
        L $83a5
        ; 83ab:   60         R
        S 

; 

MusicTickRoutine:
        ; 83ac:   a5 c1      L
        A TitleScreenFrameCountMod4
        ; 83ae:   29 01      A
        D #$01
        ; 83b0:   d0 01      B
        E $83b3
        ; 83b2:   60         R
        S 
        ; 83b3:   ad 0c 98   L
        A MusicTickRoutine__Voice1SustainLevel
        ; 83b6:   c9 a0      C
        P #$a0
        ; 83b8:   d0 43      B
        E __MusicTickRoutine__TweakCurrentNote


__MusicTickRoutine__NextNote:
; Set voice 1&2 to triangle wave.
        ; 83ba:   a9 10      L
        A #$10
        ; 83bc:   8d 04 d4   S
        A Sid_Voice1Ctrl
        ; 83bf:   8d 0b d4   S
        A Sid_Voice2Ctrl

; Voice 2:
; Attack 10
; Decay 8
        ; 83c2:   a9 a8      L
        A #$a8
        ; 83c4:   8d 0c d4   S
        A Sid_Voice2AttackDecay
        ; 83c7:   8d 0d d4   S
        A Sid_Voice2SustainRelease

; 
        ; 83ca:   ae 00 98   L
        X MusicDataIndex
        ; 83cd:   ee 00 98   I
        C MusicDataIndex
        ; 83d0:   ee 00 98   I
        C MusicDataIndex
        ; 83d3:   bd e9 5f   L
        A MusicData+1,X
        ; 83d6:   0a         A
        L A
        ; 83d7:   a8         T
        Y 
        ; 83d8:   b9 03 83   L
        A MusicNoteToFreqTable-$14,Y
        ; 83db:   8d 00 d4   S
        A Sid_Voice1FreqLo
        ; 83de:   b9 04 83   L
        A MusicNoteToFreqTable-$13,Y
        ; 83e1:   8d 01 d4   S
        A Sid_Voice1FreqHi
        ; 83e4:   bd e8 5f   L
        A MusicData,X
        ; 83e7:   0a         A
        L A
        ; 83e8:   a8         T
        Y 
        ; 83e9:   b9 03 83   L
        A MusicNoteToFreqTable-$14,Y
        ; 83ec:   8d 07 d4   S
        A Sid_Voice2FreqLo
        ; 83ef:   b9 04 83   L
        A MusicNoteToFreqTable-$13,Y
        ; 83f2:   8d 08 d4   S
        A Sid_Voice2FreqHi
        ; 83f5:   ad 00 98   L
        A MusicDataIndex
        ; 83f8:   d0 03      B
        E __MusicTickRoutine__TweakCurrentNote
        ; 83fa:   ee 01 98   I
        C MusicLoopedCount


__MusicTickRoutine__TweakCurrentNote:
        ; 83fd:   ad 0c 98   L
        A MusicTickRoutine__Voice1SustainLevel
        ; 8400:   49 07      E
        R #$07
        ; 8402:   69 04      A
        C #$04
        ; 8404:   0a         A
        L A
        ; 8405:   0a         A
        L A
        ; 8406:   0a         A
        L A
        ; 8407:   0a         A
        L A
        ; 8408:   8d 06 d4   S
        A Sid_Voice1SustainRelease
        ; 840b:   a9 11      L
        A #$11
        ; 840d:   8d 04 d4   S
        A Sid_Voice1Ctrl
        ; 8410:   8d 0b d4   S
        A Sid_Voice2Ctrl
        ; 8413:   ad 0c 98   L
        A MusicTickRoutine__Voice1SustainLevel
        ; 8416:   18         C
        C 
        ; 8417:   69 01      A
        C #$01
        ; 8419:   29 a7      A
        D #$a7
        ; 841b:   8d 0c 98   S
        A MusicTickRoutine__Voice1SustainLevel
        ; 841e:   a5 a2      L
        A IsDemoMode
        ; 8420:   f0 0b      B
        Q $842d
        ; 8422:   ad 01 98   L
        A MusicLoopedCount
        ; 8425:   c9 02      C
        P #$02
        ; 8427:   d0 04      B
        E $842d
        ; 8429:   a9 01      L
        A #$01
        ; 842b:   85 cd      S
        A StartGameTrigger
        ; 842d:   60         R
        S 

; 

ScrollingBGUpdateFillChars:
        ; 842e:   a2 07      L
        X #$07
        ; 8430:   bd 30 20   L
        A CopiedTitleChar+$30,X
        ; 8433:   1d 00 20   O
        A CopiedTitleChar,X
        ; 8436:   9d 48 20   S
        A CopiedTitleChar+$48,X
        ; 8439:   bd 38 20   L
        A CopiedTitleChar+$38,X
        ; 843c:   1d 00 20   O
        A CopiedTitleChar,X
        ; 843f:   9d 50 20   S
        A CopiedTitleChar+$50,X
        ; 8442:   ca         D
        X 
        ; 8443:   10 eb      B
        L $8430
        ; 8445:   60         R
        S 


TitleIRQActions:
        ; 8446:   a5 cf      L
        A RastInt_FurthestFromTitleIRQRaceCondition
        ; 8448:   d0 07      B
        E __TitleIRQActions__NotZero


__TitleIRQActions__Zero:
        ; 844a:   a9 01      L
        A #$01
        ; 844c:   85 cf      S
        A RastInt_FurthestFromTitleIRQRaceCondition
        ; 844e:   4c 66 84   J
        P __TitleIRQActions__Return


__TitleIRQActions__NotZero:
        ; 8451:   e6 c1      I
        C TitleScreenFrameCountMod4
        ; 8453:   a5 c1      L
        A TitleScreenFrameCountMod4
        ; 8455:   c9 04      C
        P #$04
        ; 8457:   90 0a      B
        C __TitleIRQActions__Lt4


__TitleIRQActions__GtEq4:
        ; 8459:   a9 00      L
        A #$00
        ; 845b:   85 c1      S
        A TitleScreenFrameCountMod4
        ; 845d:   20 87 74   J
        R ScrollingBGTick
        ; 8460:   20 2e 84   J
        R ScrollingBGUpdateFillChars


__TitleIRQActions__Lt4:
        ; 8463:   20 ac 83   J
        R MusicTickRoutine


__TitleIRQActions__Return:
        ; 8466:   60         R
        S 


HandleNumPlayersAndJoysticks:
        ; 8467:   a5 fb      L
        A LastKeyInScanRow0_ScannedMoreThanOnce
        ; 8469:   c9 df      C
        P #$df
        ; 846b:   d0 2e      B
        E $849b


__HandleNumPlayersAndJoysticks__F3Pressed:
        ; 846d:   a9 00      L
        A #$00
        ; 846f:   8d 01 98   S
        A MusicLoopedCount

; .NumPlayersAndJoysticksState:
; 1 -> 1 player(s), 1 joystick(s)
; 2 -> 2 player(s), 1 joystick(s)
; 3 -> 2 player(s), 2 joystick(s)
        ; 8472:   e6 d0      I
        C NumPlayersAndJoysticksState
        ; 8474:   a5 d0      L
        A NumPlayersAndJoysticksState
        ; 8476:   c9 04      C
        P #$04
        ; 8478:   d0 0b      B
        E __HandleNumPlayersAndJoysticks__Not4


__HandleNumPlayersAndJoysticks__Is4:
        ; 847a:   a2 01      L
        X #$01
        ; 847c:   86 d0      S
        X NumPlayersAndJoysticksState
        ; 847e:   ca         D
        X 
        ; 847f:   86 9e      S
        X NumPlayerMinusOne
        ; 8481:   86 a4      S
        X NumJoysticksMinusOne
        ; 8483:   f0 10      B
        Q __HandleNumPlayersAndJoysticks__Not3


__HandleNumPlayersAndJoysticks__Not4:
        ; 8485:   a5 d0      L
        A NumPlayersAndJoysticksState
        ; 8487:   c9 02      C
        P #$02
        ; 8489:   d0 02      B
        E __HandleNumPlayersAndJoysticks__Not2


__HandleNumPlayersAndJoysticks__Is2:
        ; 848b:   e6 9e      I
        C NumPlayerMinusOne


__HandleNumPlayersAndJoysticks__Not2:
        ; 848d:   a5 d0      L
        A NumPlayersAndJoysticksState
        ; 848f:   c9 03      C
        P #$03
        ; 8491:   d0 02      B
        E __HandleNumPlayersAndJoysticks__Not3


__HandleNumPlayersAndJoysticks__Is3:
        ; 8493:   e6 a4      I
        C NumJoysticksMinusOne


__HandleNumPlayersAndJoysticks__Not3:
        ; 8495:   20 f0 81   J
        R TitleScreenFillInPlayerAndJoystick
        ; 8498:   20 0c 7d   J
        R FourDelays
        ; 849b:   a9 00      L
        A #$00
        ; 849d:   85 fb      S
        A LastKeyInScanRow0_ScannedMoreThanOnce
        ; 849f:   4c f0 81   J
        P TitleScreenFillInPlayerAndJoystick

; 

HandleCaveAndLevelSecection:
        ; 84a2:   20 5d 6b   J
        R ReadJoystickDirectionPort1
        ; 84a5:   c9 0f      C
        P #$0f
        ; 84a7:   f0 6b      B
        Q __HandleCaveAndLevelSecection__Centered

; Any joystick movement resets the music repeat count.
        ; 84a9:   a2 00      L
        X #$00
        ; 84ab:   8e 01 98   S
        X MusicLoopedCount

; 
        ; 84ae:   c9 0d      C
        P #$0d
        ; 84b0:   d0 06      B
        E $84b8


__HandleCaveAndLevelSecection__Down:
        ; 84b2:   a6 5e      L
        X Level
        ; 84b4:   f0 02      B
        Q $84b8
        ; 84b6:   c6 5e      D
        C Level
        ; 84b8:   c9 0e      C
        P #$0e
        ; 84ba:   d0 12      B
        E $84ce


__HandleCaveAndLevelSecection__Up:
        ; 84bc:   a9 04      L
        A #$04
        ; 84be:   c5 5e      C
        P Level
        ; 84c0:   f0 02      B
        Q $84c4
        ; 84c2:   e6 5e      I
        C Level

; If .Level is 3 (4 in game) set .Cave to 1 (A).
        ; 84c4:   a5 5e      L
        A Level
        ; 84c6:   c9 03      C
        P #$03
        ; 84c8:   d0 04      B
        E $84ce
        ; 84ca:   a9 01      L
        A #$01
        ; 84cc:   85 5d      S
        A Cave

; 
        ; 84ce:   20 5d 6b   J
        R ReadJoystickDirectionPort1
        ; 84d1:   c9 0b      C
        P #$0b
        ; 84d3:   d0 0a      B
        E $84df


__HandleCaveAndLevelSecection__Left:
        ; 84d5:   a5 5d      L
        A Cave
        ; 84d7:   c9 05      C
        P #$05
        ; 84d9:   90 04      B
        C $84df

; .Cave >= 5. Four caves back.
        ; 84db:   e9 04      S
        C #$04
        ; 84dd:   85 5d      S
        A Cave
        ; 84df:   20 5d 6b   J
        R ReadJoystickDirectionPort1
        ; 84e2:   c9 07      C
        P #$07
        ; 84e4:   d0 10      B
        E $84f6


__HandleCaveAndLevelSecection__Right:
; If .Level >=3 (>=4 as shown in game) the you can't select any Cave but A.
        ; 84e6:   a5 5e      L
        A Level
        ; 84e8:   c9 03      C
        P #$03
        ; 84ea:   b0 0a      B
        S $84f6

; .Level < 3 (< 4 in game)
        ; 84ec:   a5 5d      L
        A Cave
        ; 84ee:   c9 0d      C
        P #$0d
        ; 84f0:   b0 04      B
        S $84f6

; Skip four caves.
        ; 84f2:   69 04      A
        C #$04
        ; 84f4:   85 5d      S
        A Cave

; Skip writing to screen if we're in license mode.
; Interestingly the cave and level can still be adjusted.
        ; 84f6:   a5 a3      L
        A TitleScreenInLicenseMode
        ; 84f8:   d0 1a      B
        E __HandleCaveAndLevelSecection__Centered

; Write cave and level to screen.
        ; 84fa:   a5 5e      L
        A Level
        ; 84fc:   18         C
        C 
        ; 84fd:   69 11      A
        C #$11
        ; 84ff:   8d ba 0b   S
        A CaveMatrix_or_TitleLogoTileMap+$3ba
        ; 8502:   69 34      A
        C #$34
        ; 8504:   8d bb 0b   S
        A CaveMatrix_or_TitleLogoTileMap+$3bb
        ; 8507:   a5 5d      L
        A Cave
        ; 8509:   18         C
        C 
        ; 850a:   69 20      A
        C #$20
        ; 850c:   8d a6 0b   S
        A CaveMatrix_or_TitleLogoTileMap+$3a6
        ; 850f:   69 34      A
        C #$34
        ; 8511:   8d a7 0b   S
        A CaveMatrix_or_TitleLogoTileMap+$3a7


__HandleCaveAndLevelSecection__Centered:
        ; 8514:   20 03 7d   J
        R Delay
        ; 8517:   60         R
        S 

; 

TitleScreenLoop:
        ; 8518:   20 67 84   J
        R HandleNumPlayersAndJoysticks
        ; 851b:   20 a2 84   J
        R HandleCaveAndLevelSecection
        ; 851e:   a5 a3      L
        A TitleScreenInLicenseMode
        ; 8520:   f0 21      B
        Q TitleScreenLoop__NotLicenseMode

; 

__TitleScreenLoop__LicenseMode:
; Make lines 1 and 24 yellow.
        ; 8522:   a9 07      L
        A #$07
        ; 8524:   a2 27      L
        X #$27

; Line 24, column 1
        ; 8526:   9d 98 db   S
        A C64_ColourRam+$398,X

; Line 1, column 1
        ; 8529:   9d 00 d8   S
        A C64_ColourRam,X
        ; 852c:   ca         D
        X 
        ; 852d:   10 f7      B
        L $8526

; Is F1 pressed?
        ; 852f:   a5 fb      L
        A LastKeyInScanRow0_ScannedMoreThanOnce
        ; 8531:   c9 ef      C
        P #$ef
        ; 8533:   d0 4f      B
        E __TitleScreenLoop__F1NotPressed


__TitleScreenLoop__F1Pressed:
        ; 8535:   a9 01      L
        A #$01
        ; 8537:   85 cc      S
        A ForceCreditsMode
        ; 8539:   20 27 82   J
        R SetupTitleScreenText

; Set lower 23 lines of colour RAM to MCM-white.
        ; 853c:   a9 09      L
        A #$09
        ; 853e:   a0 50      L
        Y #$50
        ; 8540:   20 e3 6a   J
        R SetupColourRam


TitleScreenLoop__NotLicenseMode:
        ; 8543:   20 8d 83   J
        R MakeF1ScreenControlsLightBlue
        ; 8546:   20 a1 83   J
        R MakeFirstTwoLinesYellow
        ; 8549:   a9 01      L
        A #$01
        ; 854b:   a2 0d      L
        X #$0d

; Line 24 column 1
        ; 854d:   9d 98 db   S
        A C64_ColourRam+$398,X

; Line 24 column 29
        ; 8550:   9d aa db   S
        A C64_ColourRam+$3aa,X
        ; 8553:   ca         D
        X 
        ; 8554:   10 f7      B
        L $854d

; Fill in level and cave.
        ; 8556:   a5 5e      L
        A Level
        ; 8558:   18         C
        C 
        ; 8559:   69 11      A
        C #$11

; line 24, column 35
        ; 855b:   8d ba 0b   S
        A CaveMatrix_or_TitleLogoTileMap+$3ba
        ; 855e:   69 34      A
        C #$34
        ; 8560:   8d bb 0b   S
        A CaveMatrix_or_TitleLogoTileMap+$3bb
        ; 8563:   a5 5d      L
        A Cave
        ; 8565:   18         C
        C 
        ; 8566:   69 20      A
        C #$20

; line 24, column 15
        ; 8568:   8d a6 0b   S
        A CaveMatrix_or_TitleLogoTileMap+$3a6
        ; 856b:   69 34      A
        C #$34
        ; 856d:   8d a7 0b   S
        A CaveMatrix_or_TitleLogoTileMap+$3a7

; The number of joysticks and players is handled in .HandleNumPlayersAndJoysticks.
; This is lucky as this code only fills in the first character of the number of players.
        ; 8570:   a5 9e      L
        A NumPlayerMinusOne
        ; 8572:   c9 ff      C
        P #$ff
        ; 8574:   d0 02      B
        E $8578
        ; 8576:   e6 9e      I
        C NumPlayerMinusOne
        ; 8578:   a5 9e      L
        A NumPlayerMinusOne
        ; 857a:   18         C
        C 
        ; 857b:   69 11      A
        C #$11

; line 23, column 1
        ; 857d:   8d 70 0b   S
        A CaveMatrix_or_TitleLogoTileMap+$370

; 
        ; 8580:   a9 00      L
        A #$00
        ; 8582:   85 a3      S
        A TitleScreenInLicenseMode


__TitleScreenLoop__F1NotPressed:
        ; 8584:   a5 a3      L
        A TitleScreenInLicenseMode
        ; 8586:   d0 0b      B
        E $8593
        ; 8588:   20 74 6b   J
        R ReadFireButtonPort1
        ; 858b:   d0 06      B
        E $8593
        ; 858d:   85 a2      S
        A IsDemoMode
        ; 858f:   a9 01      L
        A #$01
        ; 8591:   85 cd      S
        A StartGameTrigger
        ; 8593:   a5 cd      L
        A StartGameTrigger
        ; 8595:   d0 03      B
        E $859a
        ; 8597:   4c 18 85   J
        P TitleScreenLoop
        ; 859a:   60         R
        S 

; 

RunTitleScreen:
; Reset scrolling background character.
        ; 859b:   a2 00      L
        X #$00
        ; 859d:   bd 58 20   L
        A CopiedTitleChar+$58,X
        ; 85a0:   9d 00 20   S
        A CopiedTitleChar,X
        ; 85a3:   e8         I
        X 
        ; 85a4:   e0 08      C
        X #$08
        ; 85a6:   d0 f5      B
        E $859d

; 
        ; 85a8:   a9 01      L
        A #$01
        ; 85aa:   85 5d      S
        A Cave
        ; 85ac:   85 a2      S
        A IsDemoMode
        ; 85ae:   20 18 85   J
        R TitleScreenLoop

; When we get here a game has started (this includes demo mode).
        ; 85b1:   a9 01      L
        A #$01
        ; 85b3:   85 bd      S
        A PlayRevealLevelSoundAndRedefineCharFlag
        ; 85b5:   85 c2      S
        A AnotherFrameCounter

; Retool raster interrupts for in-game mode.
        ; 85b7:   78         S
        I 
        ; 85b8:   a2 07      L
        X #$07
        ; 85ba:   bd 13 86   L
        A RastIntGameModeVICRegs,X
        ; 85bd:   95 54      S
        A RastInt_vic_control1,X
        ; 85bf:   ca         D
        X 
        ; 85c0:   10 f8      B
        L $85ba
        ; 85c2:   58         C
        I 
        ; 85c3:   a9 00      L
        A #$00
        ; 85c5:   85 ce      S
        A RastInt_IntroScreenFlag

; 
        ; 85c7:   85 c1      S
        A TitleScreenFrameCountMod4
        ; 85c9:   85 fb      S
        A LastKeyInScanRow0_ScannedMoreThanOnce
        ; 85cb:   85 fc      S
        A LastKeyInScanRow7_ScannedMoreThanOnce
        ; 85cd:   20 f4 7c   J
        R ResetSound
        ; 85d0:   a5 a2      L
        A IsDemoMode
        ; 85d2:   f0 07      B
        Q __RunTitleScreen__GameMode


__RunTitleScreen__DemoMode:
        ; 85d4:   a2 00      L
        X #$00
        ; 85d6:   86 5e      S
        X Level
        ; 85d8:   e8         I
        X 
        ; 85d9:   86 5d      S
        X Cave


__RunTitleScreen__GameMode:
; $984e: player.1,.2.men.a/1.
; .................|
; Men left----->---/
        ; 85db:   a9 13      L
        A #$13
        ; 85dd:   8d 58 98   S
        A $9858
        ; 85e0:   85 95      S
        A FlashingEntryBoxCountDown

; $984e: player.1,.2.men.a/1.
; .......................|
; Cave--------->---------/
        ; 85e2:   a5 5d      L
        A Cave
        ; 85e4:   18         C
        C 
        ; 85e5:   69 20      A
        C #$20
        ; 85e7:   8d 5e 98   S
        A $985e

; $984e: player.1,.2.men.a/1.
; .........................|
; Level---------->---------/
        ; 85ea:   a5 5e      L
        A Level
        ; 85ec:   18         C
        C 
        ; 85ed:   69 11      A
        C #$11
        ; 85ef:   8d 60 98   S
        A $9860

; Set top line text to player into display.
        ; 85f2:   a9 00      L
        A #$00
        ; 85f4:   85 94      S
        A EnableSomeSFXAndMarqueeUpdates
        ; 85f6:   a9 4e      L
        A #&lt;CurrentPlayerInfoText
        ; 85f8:   85 46      S
        A LocalVar
        ; 85fa:   a9 98      L
        A #&gt;CurrentPlayerInfoText
        ; 85fc:   85 47      S
        A LocalVar+1
        ; 85fe:   20 16 6b   J
        R SetTopLineText

; Start.
        ; 8601:   a9 02      L
        A #$02
        ; 8603:   85 97      S
        A ExitCaveFlag
        ; 8605:   60         R
        S 

; 

TitleModeVICColourRegs:
        ; 8606:   00 00 06 0e
        09

; struct RastIntVicRegs
; {
; BYTE Vic_Control1[2]; // $d011
; BYTE Vic_Control2[2]; // $d016
; BYTE Vic_MemCtrl[2];  // $d018
; BYTE Vic_Raster[2];   // $d012
; };
; 
; Vic_Control1 0x1b =
; ECM: off,
; Bitmap: off,
; Blank: off,
; 25 rows,
; Y Position: 3
; 
; Vic_Control2 0x18 =
; MCM: on,
; 40 cols,
; X Pos: 0
; 
; Vic_MemCtrl 0x38 =
; Charset 0x2000
; Tilemap 0x0c00
; 
; Vic_MemCtrl 0x28 =
; Charset 0x2000
; Tilemap 0x0800

RastIntTitleModeVICRegs:
        ; 860b:   1b 1b 18 18
        38 28 28 c2

; struct RastIntVicRegs
; {
; BYTE Vic_Control1[2]; // $d011
; BYTE Vic_Control2[2]; // $d016
; BYTE Vic_MemCtrl[2];  // $d018
; BYTE Vic_Raster[2];   // $d012
; };
; 
; Vic_Control1 0x10 =
; ECM: off,
; Bitmap: off,
; Blank: off,
; 24 rows,
; Y Position: 0
; 
; Vic_Control1 0x1b =
; ECM: off,
; Bitmap: off,
; Blank: off,
; 25 rows,
; Y Position: 3
; 
; Vic_Control2 0x10 =
; MCM: on,
; 38 cols,
; X Pos: 0
; 
; Vic_Control2 0x18 =
; MCM: on,
; 40 cols,
; X Pos: 0
; 
; Vic_MemCtrl 0x3c =
; Charset 0x3000
; Tilemap 0x0c00
; 
; Vic_MemCtrl 0x38 =
; Charset 0x2000
; Tilemap 0x0c00

RastIntGameModeVICRegs:
        ; 8613:   10 1b 10 18
        3c 38 28 3b

; 

SetupTitleScreen:
        ; 861b:   a9 00      L
        A #$00
        ; 861d:   85 cd      S
        A StartGameTrigger

; Tile map: $0800
; Charset : $2000
        ; 861f:   a9 28      L
        A #$28
        ; 8621:   8d 18 d0   S
        A Vic_MemCtrl

; Setup VIC colour registers.
        ; 8624:   a2 04      L
        X #$04
        ; 8626:   bd 06 86   L
        A TitleModeVICColourRegs,X
        ; 8629:   9d 20 d0   S
        A Vic_BorderColour,X
        ; 862c:   ca         D
        X 
        ; 862d:   10 f7      B
        L $8626

; 
        ; 862f:   a9 09      L
        A #$09
        ; 8631:   a0 00      L
        Y #$00
        ; 8633:   20 e3 6a   J
        R SetupColourRam
        ; 8636:   e6 46      I
        C LocalVar
        ; 8638:   c6 47      D
        C LocalVar+1
        ; 863a:   a9 01      L
        A #$01
        ; 863c:   91 46      S
        A (LocalVar),Y
        ; 863e:   c8         I
        Y 
        ; 863f:   d0 fb      B
        E $863c
        ; 8641:   20 a1 83   J
        R MakeFirstTwoLinesYellow
        ; 8644:   a5 a3      L
        A TitleScreenInLicenseMode
        ; 8646:   d0 03      B
        E $864b
        ; 8648:   20 8d 83   J
        R MakeF1ScreenControlsLightBlue
        ; 864b:   20 27 82   J
        R SetupTitleScreenText
        ; 864e:   a9 00      L
        A #$00
        ; 8650:   85 cf      S
        A RastInt_FurthestFromTitleIRQRaceCondition
        ; 8652:   a9 01      L
        A #$01
        ; 8654:   85 ce      S
        A RastInt_IntroScreenFlag
        ; 8656:   a5 cf      L
        A RastInt_FurthestFromTitleIRQRaceCondition
        ; 8658:   f0 fc      B
        Q $8656
        ; 865a:   a9 00      L
        A #$00
        ; 865c:   8d 00 98   S
        A MusicDataIndex
        ; 865f:   8d 01 98   S
        A MusicLoopedCount
        ; 8662:   8d 0b 98   S
        A PlayRevealLevelSoundAndRedefineChar__SFXPhase
        ; 8665:   8d 0e 98   S
        A $980e
        ; 8668:   8d 0f 98   S
        A $980f
        ; 866b:   8d 09 98   S
        A $9809
        ; 866e:   8d 08 98   S
        A $9808
        ; 8671:   8d 11 98   S
        A $9811
        ; 8674:   60         R
        S 


IRQHandler:
        ; 8675:   ad 19 d0   L
        A Vic_IntReq
        ; 8678:   8d 19 d0   S
        A Vic_IntReq
        ; 867b:   29 01      A
        D #$01
        ; 867d:   f0 1e      B
        Q __IRQHandler__Mandatory_Processing


__IRQHandler__Raster:
        ; 867f:   c6 a7      D
        C RastIntIsInMarquee
        ; 8681:   10 04      B
        L __IRQHandler__InBody


__IRQHandler__InMarquee:
        ; 8683:   a9 01      L
        A #$01
        ; 8685:   85 a7      S
        A RastIntIsInMarquee


__IRQHandler__InBody:
        ; 8687:   a6 a7      L
        X RastIntIsInMarquee
        ; 8689:   b5 54      L
        A RastInt_vic_control1,X
        ; 868b:   8d 11 d0   S
        A Vic_Control1
        ; 868e:   b5 56      L
        A RastInt_vic_control2,X
        ; 8690:   8d 16 d0   S
        A Vic_Control2
        ; 8693:   b5 58      L
        A RastInt_vic_memory_control,X
        ; 8695:   8d 18 d0   S
        A Vic_MemCtrl
        ; 8698:   b5 5a      L
        A RastInt_vic_raster_pos,X
        ; 869a:   8d 12 d0   S
        A Vic_Raster


__IRQHandler__Mandatory_Processing:
        ; 869d:   20 04 87   J
        R Sneaky_Returns_if_no_joystick_action_ELSE_Returns_to_IRQHandler_at_IRQHandler__SneakyEntryPoint


__IRQHandler__ScanKeyboardRow0:
        ; 86a0:   a9 fe      L
        A #$fe
        ; 86a2:   8d 00 dc   S
        A Cia1_DataA
        ; 86a5:   ad 01 dc   L
        A Cia1_DataB
        ; 86a8:   c9 ff      C
        P #$ff
        ; 86aa:   f0 0a      B
        Q __IRQHandler__ScanKeyboardRow7


__IRQHandler__KeyInScanRow0:
        ; 86ac:   c5 fd      C
        P LastKeyInScanRow0
        ; 86ae:   d0 04      B
        E __IRQHandler__KeyInScanRow0ScannedFirstTime


__IRQHandler__KeyInScanRow0ScannedMoreThanOnce:
        ; 86b0:   85 fb      S
        A LastKeyInScanRow0_ScannedMoreThanOnce
        ; 86b2:   f0 02      B
        Q __IRQHandler__ScanKeyboardRow7


__IRQHandler__KeyInScanRow0ScannedFirstTime:
        ; 86b4:   85 fd      S
        A LastKeyInScanRow0


__IRQHandler__ScanKeyboardRow7:
        ; 86b6:   a9 7f      L
        A #$7f
        ; 86b8:   8d 00 dc   S
        A Cia1_DataA
        ; 86bb:   ad 01 dc   L
        A Cia1_DataB
        ; 86be:   c9 ff      C
        P #$ff
        ; 86c0:   f0 0a      B
        Q __IRQHandler__DoneKeyScan


__IRQHandler__KeyInScanRow7:
        ; 86c2:   c5 fe      C
        P LastKeyInScanRow7
        ; 86c4:   d0 04      B
        E __IRQHandler__KeyInScanRow7ScannedFirstTime


__IRQHandler__KeyInScanRow7ScannedMoreThanOnce:
        ; 86c6:   85 fc      S
        A LastKeyInScanRow7_ScannedMoreThanOnce
        ; 86c8:   f0 02      B
        Q __IRQHandler__DoneKeyScan


__IRQHandler__KeyInScanRow7ScannedFirstTime:
        ; 86ca:   85 fe      S
        A LastKeyInScanRow7


__IRQHandler__DoneKeyScan:
        ; 86cc:   20 04 87   J
        R Sneaky_Returns_if_no_joystick_action_ELSE_Returns_to_IRQHandler_at_IRQHandler__SneakyEntryPoint


__IRQHandler__SneakyEntryPoint:
        ; 86cf:   a5 ce      L
        A RastInt_IntroScreenFlag
        ; 86d1:   c9 01      C
        P #$01
        ; 86d3:   d0 18      B
        E $86ed


__IRQHandler__InTitleScreen:
        ; 86d5:   a5 a3      L
        A TitleScreenInLicenseMode
        ; 86d7:   d0 04      B
        E $86dd
        ; 86d9:   a9 28      L
        A #$28
        ; 86db:   85 58      S
        A RastInt_vic_memory_control
        ; 86dd:   a9 00      L
        A #$00
        ; 86df:   8d 15 d0   S
        A Vic_SpriteEnable
        ; 86e2:   a9 18      L
        A #$18
        ; 86e4:   85 56      S
        A RastInt_vic_control2
        ; 86e6:   a9 1b      L
        A #$1b
        ; 86e8:   85 54      S
        A RastInt_vic_control1
        ; 86ea:   20 46 84   J
        R TitleIRQActions
        ; 86ed:   a5 ce      L
        A RastInt_IntroScreenFlag
        ; 86ef:   d0 08      B
        E $86f9


__IRQHandler__InGame:
        ; 86f1:   a9 7f      L
        A #$7f
        ; 86f3:   8d 15 d0   S
        A Vic_SpriteEnable
        ; 86f6:   20 2b 7b   J
        R GameIRQActions
        ; 86f9:   a9 00      L
        A #$00
        ; 86fb:   8d 1b d0   S
        A Vic_SpritePriority
        ; 86fe:   68         P
        A 
        ; 86ff:   a8         T
        Y 
        ; 8700:   68         P
        A 
        ; 8701:   aa         T
        X 
        ; 8702:   68         P
        A 
        ; 8703:   40         R
        I 


Sneaky_Returns_if_no_joystick_action_ELSE_Returns_to_IRQHandler_at_IRQHandler__SneakyEntryPoint:
        ; 8704:   a9 ff      L
        A #$ff
        ; 8706:   8d 00 dc   S
        A Cia1_DataA
        ; 8709:   ad 01 dc   L
        A Cia1_DataB
        ; 870c:   29 1f      A
        D #$1f
        ; 870e:   c9 1f      C
        P #$1f
        ; 8710:   f0 0f      B
        Q Sneaky__NoJoystickAction
        ; 8712:   a9 ff      L
        A #$ff
        ; 8714:   85 fb      S
        A LastKeyInScanRow0_ScannedMoreThanOnce
        ; 8716:   85 fc      S
        A LastKeyInScanRow7_ScannedMoreThanOnce
        ; 8718:   85 fd      S
        A LastKeyInScanRow0
        ; 871a:   85 fe      S
        A LastKeyInScanRow7


Sneaky__MessWithStack:
        ; 871c:   68         P
        A 
        ; 871d:   68         P
        A 
        ; 871e:   4c cf 86   J
        P __IRQHandler__SneakyEntryPoint


Sneaky__NoJoystickAction:
        ; 8721:   60         R
        S 


SetLevel:
        ; 8722:   20 8e 7e   J
        R BufferLevel
        ; 8725:   20 ab 7c   J
        R FillWithDirtAndRandomObjects
        ; 8728:   20 0f 82   J
        R FrameLevelWithSteelWall
        ; 872b:   20 80 81   J
        R ExecuteLevelDrawCommands
        ; 872e:   20 dc 7e   J
        R InitGameVariablesFromLevelData
        ; 8731:   a9 00      L
        A #$00
        ; 8733:   85 ed      S
        A FineScrollDirY
        ; 8735:   85 ee      S
        A ScrollDirectionY
        ; 8737:   85 e9      S
        A FineScrollDirX
        ; 8739:   85 ea      S
        A ScrollDirectionX
        ; 873b:   20 fe 77   J
        R UncoverCaveScreen
        ; 873e:   a9 00      L
        A #$00
        ; 8740:   85 bd      S
        A PlayRevealLevelSoundAndRedefineCharFlag
        ; 8742:   20 f4 7c   J
        R ResetSound
        ; 8745:   60         R
        S 

; 

InitPlayers:
        ; 8746:   a9 00      L
        A #$00
        ; 8748:   85 9d      S
        A CurrentPlayer
        ; 874a:   85 a0      S
        A GameOverFlag
        ; 874c:   a2 05      L
        X #$05
        ; 874e:   95 5f      S
        A ScoreDigits,X
        ; 8750:   95 4e      S
        A ScoreIncrementDigits,X
        ; 8752:   ca         D
        X 
        ; 8753:   10 f9      B
        L $874e
        ; 8755:   a9 03      L
        A #$03
        ; 8757:   85 5c      S
        A Lives
        ; 8759:   a2 08      L
        X #$08
        ; 875b:   b5 5c      L
        A Lives,X
        ; 875d:   95 6b      S
        A Player1_Lives,X
        ; 875f:   95 7a      S
        A Player2_Lives,X
        ; 8761:   ca         D
        X 
        ; 8762:   10 f7      B
        L $875b
        ; 8764:   a2 05      L
        X #$05
        ; 8766:   b5 74      L
        A Player1_HighScoreChars,X
        ; 8768:   95 65      S
        A HighScoreChars,X
        ; 876a:   ca         D
        X 
        ; 876b:   10 f9      B
        L $8766
        ; 876d:   60         R
        S 

; 

LoseLife:
        ; 876e:   c6 5c      D
        C Lives
        ; 8770:   a5 9d      L
        A CurrentPlayer
        ; 8772:   d0 0b      B
        E __LoseLife__BackupPlayer2__


__LoseLife__BackupPlayer1__:
; $5c-$6a to $6b-$79
        ; 8774:   a2 0e      L
        X #$0e
        ; 8776:   b5 5c      L
        A Lives,X
        ; 8778:   95 6b      S
        A Player1_Lives,X
        ; 877a:   ca         D
        X 
        ; 877b:   10 f9      B
        L $8776
        ; 877d:   30 09      B
        I __LoseLife__NextPlayer__

; NOTE: Branch above always taken.

__LoseLife__BackupPlayer2__:
; $5c-$6a to $7a-$88
        ; 877f:   a2 0e      L
        X #$0e
        ; 8781:   b5 5c      L
        A Lives,X
        ; 8783:   95 7a      S
        A Player2_Lives,X
        ; 8785:   ca         D
        X 
        ; 8786:   10 f9      B
        L $8781


__LoseLife__NextPlayer__:
; Player switched if multiplayer game and other player has lives left.
        ; 8788:   a5 9e      L
        A NumPlayerMinusOne
        ; 878a:   f0 13      B
        Q __LoseLife__RestoreNewPlayer__
        ; 878c:   a5 9d      L
        A CurrentPlayer
        ; 878e:   d0 09      B
        E $8799
        ; 8790:   a5 7a      L
        A Player2_Lives
        ; 8792:   f0 0b      B
        Q __LoseLife__RestoreNewPlayer__
        ; 8794:   e6 9d      I
        C CurrentPlayer
        ; 8796:   4c 9f 87   J
        P __LoseLife__RestoreNewPlayer__
        ; 8799:   a5 6b      L
        A Player1_Lives
        ; 879b:   f0 02      B
        Q __LoseLife__RestoreNewPlayer__
        ; 879d:   c6 9d      D
        C CurrentPlayer


__LoseLife__RestoreNewPlayer__:
        ; 879f:   a5 9d      L
        A CurrentPlayer
        ; 87a1:   d0 0b      B
        E __LoseLife__RestorePlayer2__


__LoseLife__RestorePlayer1__:
        ; 87a3:   a2 0e      L
        X #$0e
        ; 87a5:   b5 6b      L
        A Player1_Lives,X
        ; 87a7:   95 5c      S
        A Lives,X
        ; 87a9:   ca         D
        X 
        ; 87aa:   10 f9      B
        L $87a5
        ; 87ac:   30 09      B
        I __LoseLife__CheckIfGameOver__

; NOTE: Branch above always taken.

__LoseLife__RestorePlayer2__:
        ; 87ae:   a2 0e      L
        X #$0e
        ; 87b0:   b5 7a      L
        A Player2_Lives,X
        ; 87b2:   95 5c      S
        A Lives,X
        ; 87b4:   ca         D
        X 
        ; 87b5:   10 f9      B
        L $87b0


__LoseLife__CheckIfGameOver__:
; Since we only switch to a player that has a non-zero life count a count
; of zero means all players are dead.
        ; 87b7:   a5 5c      L
        A Lives
        ; 87b9:   d0 0c      B
        E __LoseLife__Exit__
        ; 87bb:   a9 01      L
        A #$01
        ; 87bd:   85 a0      S
        A GameOverFlag
        ; 87bf:   a9 03      L
        A #$03
        ; 87c1:   85 5c      S
        A Lives
        ; 87c3:   a9 00      L
        A #$00
        ; 87c5:   85 9d      S
        A CurrentPlayer


__LoseLife__Exit__:
        ; 87c7:   60         R
        S 

; 

ScoreTimeRemainingSound:
        ; 87c8:   c6 03      D
        C __CoverLevel__LineAddressTable+1
        ; 87ca:   a2 0f      L
        X #$0f

; 

__ScoreTimeRemainingSound__Loop:
; Voice 3: Triangle waveform, Gate bit off.
        ; 87cc:   a9 10      L
        A #$10
        ; 87ce:   8d 12 d4   S
        A Sid_Voice3Ctrl

; 
        ; 87d1:   86 02      S
        X __CoverLevel__LineAddressTable
        ; 87d3:   06 02      A
        L __CoverLevel__LineAddressTable
        ; 87d5:   a5 03      L
        A __CoverLevel__LineAddressTable+1
        ; 87d7:   38         S
        C 
        ; 87d8:   e5 02      S
        C __CoverLevel__LineAddressTable
        ; 87da:   8d 0f d4   S
        A Sid_Voice3FreqHi
        ; 87dd:   a9 a0      L
        A #$a0
        ; 87df:   8d 14 d4   S
        A Sid_Voice3SustainRelease
        ; 87e2:   a9 00      L
        A #$00
        ; 87e4:   8d 13 d4   S
        A Sid_Voice3AttackDecay

; Voice 3: Triangle waveform, Gate bit ON.
        ; 87e7:   a9 11      L
        A #$11
        ; 87e9:   8d 12 d4   S
        A Sid_Voice3Ctrl

; 
        ; 87ec:   a0 c0      L
        Y #$c0
        ; 87ee:   88         D
        Y 
        ; 87ef:   d0 fd      B
        E $87ee
        ; 87f1:   ca         D
        X 
        ; 87f2:   d0 d8      B
        E __ScoreTimeRemainingSound__Loop

; Voice 3: Triangle waveform, Gate bit off.
        ; 87f4:   a9 10      L
        A #$10
        ; 87f6:   8d 12 d4   S
        A Sid_Voice3Ctrl

; 
        ; 87f9:   60         R
        S 

; 

UpdateHighScoreIfNeeded:
        ; 87fa:   a9 00      L
        A #$00
        ; 87fc:   aa         T
        X 
        ; 87fd:   85 a1      S
        A UpdateHighScoreIfNeeded_NeedsUpdating
        ; 87ff:   b5 65      L
        A HighScoreChars,X
        ; 8801:   dd 48 98   C
        P ScoreChars,X
        ; 8804:   f0 08      B
        Q $880e
        ; 8806:   a2 05      L
        X #$05
        ; 8808:   b0 04      B
        S $880e
        ; 880a:   a9 01      L
        A #$01
        ; 880c:   85 a1      S
        A UpdateHighScoreIfNeeded_NeedsUpdating
        ; 880e:   e8         I
        X 
        ; 880f:   e0 06      C
        X #$06
        ; 8811:   d0 ec      B
        E $87ff
        ; 8813:   a5 a1      L
        A UpdateHighScoreIfNeeded_NeedsUpdating
        ; 8815:   f0 0a      B
        Q $8821
        ; 8817:   a2 05      L
        X #$05
        ; 8819:   bd 48 98   L
        A ScoreChars,X
        ; 881c:   95 65      S
        A HighScoreChars,X
        ; 881e:   ca         D
        X 
        ; 881f:   10 f8      B
        L $8819
        ; 8821:   60         R
        S 

; 

StashScores:
        ; 8822:   a2 05      L
        X #$05
        ; 8824:   b5 74      L
        A Player1_HighScoreChars,X
        ; 8826:   9d 27 98   S
        A $9827,X
        ; 8829:   b5 83      L
        A Player2_HighScoreChars,X
        ; 882b:   9d 33 98   S
        A $9833,X
        ; 882e:   b5 6e      L
        A Player1_ScoreDigits,X
        ; 8830:   18         C
        C 
        ; 8831:   69 10      A
        C #$10
        ; 8833:   9d 13 98   S
        A $9813,X
        ; 8836:   b5 7d      L
        A Player2_ScoreDigits,X
        ; 8838:   69 10      A
        C #$10
        ; 883a:   9d 1f 98   S
        A $981f,X
        ; 883d:   ca         D
        X 
        ; 883e:   10 e4      B
        L $8824
        ; 8840:   60         R
        S 

; 

NextCave:
        ; 8841:   a5 5d      L
        A Cave
        ; 8843:   0a         A
        L A
        ; 8844:   aa         T
        X 
        ; 8845:   bd 64 7e   L
        A LevelSequenceAndBonusLevelStatusArray-2,X
        ; 8848:   c9 15      C
        P #$15
        ; 884a:   d0 0a      B
        E $8856
        ; 884c:   a5 5e      L
        A Level
        ; 884e:   c9 04      C
        P #$04
        ; 8850:   f0 02      B
        Q $8854
        ; 8852:   e6 5e      I
        C Level
        ; 8854:   a9 01      L
        A #$01
        ; 8856:   85 5d      S
        A Cave
        ; 8858:   60         R
        S 

; 

CaveComplete:
; Set the score increment to zero.
        ; 8859:   a2 00      L
        X #$00
        ; 885b:   a9 00      L
        A #$00
        ; 885d:   95 4e      S
        A ScoreIncrementDigits,X
        ; 885f:   e8         I
        X 
        ; 8860:   e0 06      C
        X #$06
        ; 8862:   d0 f9      B
        E $885d

; .Level is one less than the actual level as displayed in the game.
; We add one to compensate for this discrepancy and store the result
; in the last digit of .ScoreIncrementDigits.
        ; 8864:   a5 5e      L
        A Level
        ; 8866:   18         C
        C 
        ; 8867:   69 01      A
        C #$01
        ; 8869:   85 53      S
        A ScoreIncrementDigits+5
        ; 886b:   a9 00      L
        A #$00
        ; 886d:   85 97      S
        A ExitCaveFlag
        ; 886f:   85 02      S
        A __CoverLevel__LineAddressTable
        ; 8871:   a9 d0      L
        A #$d0
        ; 8873:   85 03      S
        A __CoverLevel__LineAddressTable+1
        ; 8875:   20 8c 70   J
        R CheckIfLevelTimeIsUp
        ; 8878:   20 f4 7c   J
        R ResetSound

; When you complete a cave you get .Level+1 (.Level is 0 for level 1)
; points for every second remaining.

__CaveComplete__ScoreTimeRemainingLoop:
        ; 887b:   a5 97      L
        A ExitCaveFlag
        ; 887d:   d0 0b      B
        E $888a
        ; 887f:   20 c5 70   J
        R GameSecondTick
        ; 8882:   20 5d 70   J
        R IncrementScore
        ; 8885:   20 c8 87   J
        R ScoreTimeRemainingSound

; Branch always taken!
        ; 8888:   d0 f1      B
        E __CaveComplete__ScoreTimeRemainingLoop

; 
        ; 888a:   20 9d 70   J
        R TimeRunningOutFX
        ; 888d:   20 0c 7d   J
        R FourDelays
        ; 8890:   20 f4 7c   J
        R ResetSound
        ; 8893:   20 41 88   J
        R NextCave
        ; 8896:   60         R
        S 

; 

KillPlayer:
        ; 8897:   20 fa 87   J
        R UpdateHighScoreIfNeeded
        ; 889a:   20 6e 87   J
        R LoseLife
        ; 889d:   a5 a0      L
        A GameOverFlag
        ; 889f:   f0 09      B
        Q $88aa
        ; 88a1:   a9 00      L
        A #$00
        ; 88a3:   85 5d      S
        A Cave
        ; 88a5:   85 5e      S
        A Level
        ; 88a7:   20 22 88   J
        R StashScores
        ; 88aa:   60         R
        S 

; Exiting a cave happens when the player is killed, when time runs out
; or when the level is completed.

PerformCaveExitAction:
        ; 88ab:   a2 01      L
        X #$01
        ; 88ad:   86 9b      S
        X SecondsDontPass
        ; 88af:   a5 9f      L
        A EnteredOutboxFlag
        ; 88b1:   f0 06      B
        Q __PerformCaveExitAction__NotComplete


__PerformCaveExitAction__Complete:
        ; 88b3:   20 59 88   J
        R CaveComplete
        ; 88b6:   4c c6 88   J
        P __PerformCaveExitAction__CaveExitActions


__PerformCaveExitAction__NotComplete:
        ; 88b9:   a5 a6      L
        A IsBonusLevelFlag
        ; 88bb:   f0 06      B
        Q __PerformCaveExitAction__NotBonusLevel


__PerformCaveExitAction__BonusLevel:
        ; 88bd:   20 41 88   J
        R NextCave
        ; 88c0:   4c c6 88   J
        P __PerformCaveExitAction__CaveExitActions


__PerformCaveExitAction__NotBonusLevel:
        ; 88c3:   20 97 88   J
        R KillPlayer


__PerformCaveExitAction__CaveExitActions:
        ; 88c6:   a5 a2      L
        A IsDemoMode
        ; 88c8:   d0 2c      B
        E __PerformCaveExitAction__DemoMode


__PerformCaveExitAction__NotDemoMode:
; .CurrentPlayer is updated via the call to .KillPlayer above.
        ; 88ca:   a5 9d      L
        A CurrentPlayer
        ; 88cc:   18         C
        C 
        ; 88cd:   69 11      A
        C #$11
        ; 88cf:   8d 55 98   S
        A $9855

; .Lives is updated via the call to .KillPlayer above.
        ; 88d2:   a5 5c      L
        A Lives
        ; 88d4:   18         C
        C 
        ; 88d5:   69 10      A
        C #$10
        ; 88d7:   8d 58 98   S
        A $9858
        ; 88da:   aa         T
        X 

; $25 is the letter 'e'.
        ; 88db:   a9 25      L
        A #$25
        ; 88dd:   e0 11      C
        X #$11
        ; 88df:   d0 02      B
        E $88e3


__PerformCaveExitAction__OneLifeLeft:
; $21 is the letter 'a'.
        ; 88e1:   a9 21      L
        A #$21

; Patch the play info buffer: 'man' for one life and 'men' for more.
        ; 88e3:   8d 5b 98   S
        A $985b

; Cave and level, .Cave is updated in call the .NextCave above.
        ; 88e6:   a5 5d      L
        A Cave
        ; 88e8:   18         C
        C 
        ; 88e9:   69 20      A
        C #$20
        ; 88eb:   8d 5e 98   S
        A $985e
        ; 88ee:   a5 5e      L
        A Level
        ; 88f0:   18         C
        C 
        ; 88f1:   69 11      A
        C #$11
        ; 88f3:   8d 60 98   S
        A $9860


__PerformCaveExitAction__DemoMode:
        ; 88f6:   a9 00      L
        A #$00
        ; 88f8:   85 94      S
        A EnableSomeSFXAndMarqueeUpdates
        ; 88fa:   60         R
        S 

; 

RunCave:
        ; 88fb:   20 d9 7d   J
        R ProcessCave
        ; 88fe:   a5 97      L
        A ExitCaveFlag
        ; 8900:   f0 f9      B
        Q RunCave
        ; 8902:   20 f4 7c   J
        R ResetSound
        ; 8905:   20 ab 88   J
        R PerformCaveExitAction
        ; 8908:   a5 a8      L
        A ExtraLifeFXCounter
        ; 890a:   d0 fc      B
        E $8908
        ; 890c:   8d 08 98   S
        A $9808
        ; 890f:   8d 11 98   S
        A $9811
        ; 8912:   60         R
        S 

; 

DemoModeRunCave:
        ; 8913:   a9 00      L
        A #$00
        ; 8915:   85 d3      S
        A DemoMoveDataIndex
        ; 8917:   85 d4      S
        A ExitDemoModeFlag
        ; 8919:   85 d2      S
        A DemoMoveRepeatCount


__DemoModeRunCave__Loop:
        ; 891b:   a5 d2      L
        A DemoMoveRepeatCount
        ; 891d:   d0 1b      B
        E __DemoModeRunCave__RepeatMove
        ; 891f:   a6 d3      L
        X DemoMoveDataIndex
        ; 8921:   bd a8 5e   L
        A DemoMoveData,X
        ; 8924:   85 d2      S
        A DemoMoveRepeatCount
        ; 8926:   29 0f      A
        D #$0f
        ; 8928:   85 8b      S
        A JoystickStatus
        ; 892a:   d0 04      B
        E $8930
        ; 892c:   a9 01      L
        A #$01
        ; 892e:   85 d4      S
        A ExitDemoModeFlag
        ; 8930:   46 d2      L
        R DemoMoveRepeatCount
        ; 8932:   46 d2      L
        R DemoMoveRepeatCount
        ; 8934:   46 d2      L
        R DemoMoveRepeatCount
        ; 8936:   46 d2      L
        R DemoMoveRepeatCount
        ; 8938:   e6 d3      I
        C DemoMoveDataIndex


__DemoModeRunCave__RepeatMove:
        ; 893a:   20 74 6b   J
        R ReadFireButtonPort1
        ; 893d:   d0 04      B
        E $8943
        ; 893f:   a9 01      L
        A #$01
        ; 8941:   85 d4      S
        A ExitDemoModeFlag
        ; 8943:   a5 d4      L
        A ExitDemoModeFlag
        ; 8945:   d0 08      B
        E __DemoModeRunCave__Exit
        ; 8947:   20 d9 7d   J
        R ProcessCave
        ; 894a:   c6 d2      D
        C DemoMoveRepeatCount
        ; 894c:   4c 1b 89   J
        P __DemoModeRunCave__Loop


__DemoModeRunCave__Exit:
        ; 894f:   20 f4 7c   J
        R ResetSound
        ; 8952:   a5 9f      L
        A EnteredOutboxFlag
        ; 8954:   f0 03      B
        Q $8959
        ; 8956:   20 ab 88   J
        R PerformCaveExitAction
        ; 8959:   a9 00      L
        A #$00
        ; 895b:   85 5d      S
        A Cave
        ; 895d:   60         R
        S 

; 

ResetLastAndHighScoresAndPlayerInfoText:
        ; 895e:   a2 13      L
        X #$13


__ResetLastAndHighScoresAndPlayerInfoText__Loop:
        ; 8960:   bd cc 6b   L
        A Text_LastScores,X
        ; 8963:   9d 12 98   S
        A CurrentHighScoreText,X
        ; 8966:   bd e0 6b   L
        A Text_HighScores,X
        ; 8969:   9d 26 98   S
        A CurrentLastScoreText,X

; $20 is a space.
; Here's an example of contents during game: .12?10.00.147.000010
        ; 896c:   a9 20      L
        A #$20
        ; 896e:   9d 3a 98   S
        A CurrentPlayerScoresText,X
        ; 8971:   ca         D
        X 
        ; 8972:   10 ec      B
        L __ResetLastAndHighScoresAndPlayerInfoText__Loop

; $3c is a diamond.
        ; 8974:   a9 3c      L
        A #$3c
        ; 8976:   8d 3d 98   S
        A $983d
        ; 8979:   60         R
        S 

; 

InitAll:
; $0c00-$0c27 = 0x20
; Set the first line of the 1st in-game tilemap to spaces.
        ; 897a:   a2 28      L
        X #$28
        ; 897c:   a9 20      L
        A #$20


_InitBlankTopLine:
        ; 897e:   9d ff 0b   S
        A $0bff,X
        ; 8981:   ca         D
        X 
        ; 8982:   d0 fa      B
        E _InitBlankTopLine

; 
        ; 8984:   a9 60      L
        A #$60


_InitBlankRestOfScreen:
        ; 8986:   9d 28 0c   S
        A GameTileMap1_or_TitleTextTileMap+$28,X
        ; 8989:   9d 00 0d   S
        A GameTileMap1_or_TitleTextTileMap+$100,X
        ; 898c:   9d 00 0e   S
        A GameTileMap1_or_TitleTextTileMap+$200,X
        ; 898f:   9d 00 0f   S
        A GameTileMap1_or_TitleTextTileMap+$300,X
        ; 8992:   9d 00 2c   S
        A GameTileMap2,X
        ; 8995:   9d 00 2d   S
        A GameTileMap2+$100,X
        ; 8998:   9d 00 2e   S
        A GameTileMap2+$200,X
        ; 899b:   9d 00 2f   S
        A GameTileMap2+$300,X
        ; 899e:   e8         I
        X 
        ; 899f:   d0 e5      B
        E _InitBlankRestOfScreen


_InitCopyCharsAndTheme:
        ; 89a1:   bd 00 50   L
        A TitleCharData,X
        ; 89a4:   9d 00 20   S
        A CopiedTitleChar,X
        ; 89a7:   bd 00 51   L
        A TitleCharData+$100,X
        ; 89aa:   9d 00 21   S
        A CopiedTitleChar+$100,X
        ; 89ad:   bd 00 52   L
        A TitleCharData+$200,X
        ; 89b0:   9d 00 22   S
        A CopiedTitleChar+$200,X
        ; 89b3:   bd 00 53   L
        A TitleCharData+$300,X
        ; 89b6:   9d 00 23   S
        A CopiedTitleChar+$300,X

; MusicData $5fe8-$60e7 copied to $3000-$30ff
; GameCharData $60e8-$63e7 copied to $3100-$33ff
; That's a combined total of 1k
        ; 89b9:   bd e8 5f   L
        A MusicData,X
        ; 89bc:   9d 00 30   S
        A CopiedMusicData,X
        ; 89bf:   bd e8 60   L
        A GameCharData,X
        ; 89c2:   9d 00 31   S
        A CopiedGameCharData,X
        ; 89c5:   bd e8 61   L
        A GameCharData+$100,X
        ; 89c8:   9d 00 32   S
        A CopiedGameCharData+$100,X
        ; 89cb:   bd e8 62   L
        A GameCharData+$200,X
        ; 89ce:   9d 00 33   S
        A CopiedGameCharData+$200,X
        ; 89d1:   e8         I
        X 
        ; 89d2:   d0 cd      B
        E _InitCopyCharsAndTheme

; $3770-$3797 to $ff
; $3798-$37bf to $00
; Sprite data is at $3780-$37be
; Sets the first 8 lines to solid & and last 13 transparent.
; NOTE: Writes both before and after the sprite data.
        ; 89d4:   a2 27      L
        X #$27
        ; 89d6:   a9 ff      L
        A #$ff
        ; 89d8:   9d 70 37   S
        A $3770,X
        ; 89db:   a9 00      L
        A #$00
        ; 89dd:   9d 98 37   S
        A $3798,X
        ; 89e0:   ca         D
        X 
        ; 89e1:   10 f3      B
        L $89d6

; Set all sprite pointers in both tilemaps to $3780.
        ; 89e3:   a2 07      L
        X #$07
        ; 89e5:   a9 de      L
        A #$de
        ; 89e7:   9d f8 0f   S
        A $0ff8,X
        ; 89ea:   9d f8 2f   S
        A $2ff8,X
        ; 89ed:   a9 00      L
        A #$00
        ; 89ef:   9d 27 d0   S
        A Vic_SpriteColour0,X
        ; 89f2:   ca         D
        X 
        ; 89f3:   10 f0      B
        L $89e5

; Position the sprites.
; NOTE: To get a sprite to display on raster line y
;       set its y-coordinate to y-1.
        ; 89f5:   a0 0c      L
        Y #$0c
        ; 89f7:   a9 37      L
        A #$37
        ; 89f9:   99 00 d0   S
        A Vic_Sprite0X,Y
        ; 89fc:   aa         T
        X 
        ; 89fd:   a9 3a      L
        A #$3a
        ; 89ff:   99 01 d0   S
        A Vic_Sprite0Y,Y
        ; 8a02:   8a         T
        A 
        ; 8a03:   38         S
        C 
        ; 8a04:   e9 30      S
        C #$30
        ; 8a06:   88         D
        Y 
        ; 8a07:   88         D
        Y 
        ; 8a08:   10 ef      B
        L $89f9
        ; 8a0a:   a9 ff      L
        A #$ff
        ; 8a0c:   8d 1d d0   S
        A Vic_SpriteExpandX
        ; 8a0f:   a9 60      L
        A #$60
        ; 8a11:   8d 10 d0   S
        A Vic_SpriteMsbX
        ; 8a14:   60         R
        S 

; 

InitGameState:
        ; 8a15:   20 f4 7c   J
        R ResetSound
        ; 8a18:   a2 ff      L
        X #$ff
        ; 8a1a:   86 99      S
        X UnpackedCaveNumber
        ; 8a1c:   86 ce      S
        X RastInt_IntroScreenFlag
        ; 8a1e:   86 fb      S
        X LastKeyInScanRow0_ScannedMoreThanOnce
        ; 8a20:   86 fc      S
        X LastKeyInScanRow7_ScannedMoreThanOnce
        ; 8a22:   86 fd      S
        X LastKeyInScanRow0
        ; 8a24:   86 fe      S
        X LastKeyInScanRow7
        ; 8a26:   e8         I
        X 

; X=0
        ; 8a27:   86 e7      S
        X FineScrollX
        ; 8a29:   86 e8      S
        X ScreenLeft
        ; 8a2b:   86 eb      S
        X FineScrollY
        ; 8a2d:   86 ec      S
        X ScreenTop
        ; 8a2f:   86 a5      S
        X WhiteFlashWhiteCount
        ; 8a31:   86 5d      S
        X Cave
        ; 8a33:   86 5e      S
        X Level
        ; 8a35:   86 c0      S
        X AnimationFrameTimes8
        ; 8a37:   86 c1      S
        X TitleScreenFrameCountMod4
        ; 8a39:   86 e3      S
        X YScrollTableIndex
        ; 8a3b:   86 e4      S
        X YCoarseScrollDirFlag
        ; 8a3d:   86 e1      S
        X XScrollTableIndex
        ; 8a3f:   86 e2      S
        X XCoarseScrollDirFlag
        ; 8a41:   86 d8      S
        X SFXTrigger_DiamondQuotaReachedOrEntryBoxExplode
        ; 8a43:   86 d9      S
        X SFXTimer_DiamondQuotaReachedOrEntryBoxExplode
        ; 8a45:   e8         I
        X 

; X=1
        ; 8a46:   86 cc      S
        X ForceCreditsMode
        ; 8a48:   86 a2      S
        X IsDemoMode
        ; 8a4a:   86 a3      S
        X TitleScreenInLicenseMode

; Clumsily .InitGameState::DoOneTimeInit is not initialised by
; the game. BD relies on the fact that the C64's OS uses this
; as the current line length minus one and thus when the game
; starts it is never zero.
        ; 8a4c:   a5 d5      L
        A InitGameState__DoOneTimeInit
        ; 8a4e:   f0 30      B
        Q __InitGameState__Exit


__InitGameState__OneTimeInit:
        ; 8a50:   a2 04      L
        X #$04
        ; 8a52:   a9 00      L
        A #$00
        ; 8a54:   9d 20 d0   S
        A Vic_BorderColour,X
        ; 8a57:   ca         D
        X 
        ; 8a58:   10 fa      B
        L $8a54
        ; 8a5a:   a2 00      L
        X #$00
        ; 8a5c:   a9 10      L
        A #$10
        ; 8a5e:   95 74      S
        A Player1_HighScoreChars,X
        ; 8a60:   95 83      S
        A Player2_HighScoreChars,X
        ; 8a62:   95 65      S
        A HighScoreChars,X
        ; 8a64:   e8         I
        X 
        ; 8a65:   e0 06      C
        X #$06
        ; 8a67:   d0 f5      B
        E $8a5e
        ; 8a69:   a9 00      L
        A #$00
        ; 8a6b:   85 d5      S
        A InitGameState__DoOneTimeInit
        ; 8a6d:   85 a4      S
        A NumJoysticksMinusOne
        ; 8a6f:   85 9e      S
        A NumPlayerMinusOne
        ; 8a71:   85 a8      S
        A ExtraLifeFXCounter
        ; 8a73:   20 39 74   J
        R BlankLines0and4ofSpaceChars
        ; 8a76:   a9 01      L
        A #$01
        ; 8a78:   85 d0      S
        A NumPlayersAndJoysticksState
        ; 8a7a:   20 5e 89   J
        R ResetLastAndHighScoresAndPlayerInfoText
        ; 8a7d:   20 7a 89   J
        R InitAll


__InitGameState__Exit:
        ; 8a80:   60         R
        S 

; 

RasterSetTitleMode:
        ; 8a81:   a9 3c      L
        A #$3c
        ; 8a83:   8d 07 98   S
        A BackBufferVICMemControl
        ; 8a86:   20 db 76   J
        R FillInflatedCaveWithScrollingSteelWallChar
        ; 8a89:   78         S
        I 
        ; 8a8a:   a2 07      L
        X #$07
        ; 8a8c:   bd 0b 86   L
        A RastIntTitleModeVICRegs,X
        ; 8a8f:   95 54      S
        A RastInt_vic_control1,X
        ; 8a91:   ca         D
        X 
        ; 8a92:   10 f8      B
        L $8a8c
        ; 8a94:   a2 01      L
        X #$01
        ; 8a96:   8e 1a d0   S
        X Vic_IntMask
        ; 8a99:   e8         I
        X 
        ; 8a9a:   86 a7      S
        X RastIntIsInMarquee
        ; 8a9c:   a9 28      L
        A #$28
        ; 8a9e:   8d 12 d0   S
        A Vic_Raster

; Extended Color Text Mode : Off
; Bit Map Mode             : Off
; 25 rows                  : On
        ; 8aa1:   a9 18      L
        A #$18
        ; 8aa3:   8d 11 d0   S
        A Vic_Control1

; 
        ; 8aa6:   a9 75      L
        A #&lt;IRQHandler
        ; 8aa8:   8d 14 03   S
        A Krnl_IrqLo
        ; 8aab:   a9 86      L
        A #&gt;IRQHandler
        ; 8aad:   8d 15 03   S
        A Krnl_IrqHi
        ; 8ab0:   58         C
        I 
        ; 8ab1:   60         R
        S 


NMIHandler:
        ; 8ab2:   58         C
        I 

; Main entry point.

Main:
; Setup stack.
        ; 8ab3:   a2 ff      L
        X #$ff
        ; 8ab5:   9a         T
        S 

; Turn off all CIA interrupts.
        ; 8ab6:   a9 7f      L
        A #$7f
        ; 8ab8:   8d 0d dc   S
        A Cia1_IntCtrl
        ; 8abb:   8d 0d dd   S
        A Cia2_IntCtrl

; 
        ; 8abe:   a9 ff      L
        A #$ff
        ; 8ac0:   8d 04 dc   S
        A Cia1_TimerALo
        ; 8ac3:   8d 05 dc   S
        A Cia1_TimerAHi
        ; 8ac6:   a9 a0      L
        A #$a0
        ; 8ac8:   8d 04 dd   S
        A Cia2_TimerALo
        ; 8acb:   8d 05 dd   S
        A Cia2_TimerAHi
        ; 8ace:   a9 68      L
        A #$68
        ; 8ad0:   8d 06 dd   S
        A Cia2_TimerBLo
        ; 8ad3:   8d 07 dd   S
        A Cia2_TimerBHi
        ; 8ad6:   a9 17      L
        A #$17
        ; 8ad8:   8d 0e dd   S
        A Cia2_CtrlA
        ; 8adb:   8d 0f dd   S
        A Cia2_CtrlB

; Make NMI (RUN-STOP+RESTORE or cartridge) restart game.
        ; 8ade:   78         S
        I 
        ; 8adf:   a9 b2      L
        A #&lt;NMIHandler
        ; 8ae1:   8d 18 03   S
        A Krnl_NmiLo
        ; 8ae4:   a9 8a      L
        A #&gt;NMIHandler
        ; 8ae6:   8d 19 03   S
        A Krnl_NmiHi
        ; 8ae9:   58         C
        I 

; I/O area visible at $D000-$DFFF
; RAM visible at $A000-$BFFF
; KERNAL ROM visible at $E000-$FFFF
        ; 8aea:   a9 36      L
        A #$36
        ; 8aec:   85 01      S
        A Zp_6510IO

; 
        ; 8aee:   20 15 8a   J
        R InitGameState
        ; 8af1:   a9 08      L
        A #$08
        ; 8af3:   8d 0a 98   S
        A $980a

; Move 7b58-7d57 to 9e00-9fff.
        ; 8af6:   a0 00      L
        Y #$00
        ; 8af8:   a2 58      L
        X #&lt;CopyInflatedCaveSubsetToBackBuffer
        ; 8afa:   86 02      S
        X __CoverLevel__LineAddressTable
        ; 8afc:   86 04      S
        X __CoverLevel__LineAddressTable+2
        ; 8afe:   a2 7b      L
        X #&gt;CopyInflatedCaveSubsetToBackBuffer
        ; 8b00:   86 03      S
        X __CoverLevel__LineAddressTable+1
        ; 8b02:   e8         I
        X 
        ; 8b03:   86 05      S
        X __CoverLevel__LineAddressTable+3
        ; 8b05:   b1 02      L
        A (__CoverLevel__LineAddressTable),Y
        ; 8b07:   99 00 9e   S
        A MOVEDCopyInflatedCaveSubsetToBackBuffer,Y
        ; 8b0a:   b1 04      L
        A (__CoverLevel__LineAddressTable+2),Y
        ; 8b0c:   99 00 9f   S
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$100,Y
        ; 8b0f:   c8         I
        Y 
        ; 8b10:   d0 f3      B
        E $8b05

; 
        ; 8b12:   a9 03      L
        A #&lt;InflatedCave
        ; 8b14:   85 d6      S
        A InflatedCaveSubset
        ; 8b16:   a9 40      L
        A #&gt;InflatedCave
        ; 8b18:   85 d7      S
        A InflatedCaveSubset+1

; Moves 20 bytes from .Pre_level_Marquee_Text to $984e ($6c08-$6c1b to $984e-$9861).
        ; 8b1a:   a2 13      L
        X #$13
        ; 8b1c:   bd 08 6c   L
        A Pre_level_Marquee_Text,X
        ; 8b1f:   9d 4e 98   S
        A CurrentPlayerInfoText,X
        ; 8b22:   ca         D
        X 
        ; 8b23:   10 f7      B
        L $8b1c

; 
        ; 8b25:   a9 10      L
        A #$10
        ; 8b27:   a2 05      L
        X #$05
        ; 8b29:   9d 48 98   S
        A ScoreChars,X
        ; 8b2c:   ca         D
        X 
        ; 8b2d:   10 fa      B
        L $8b29

; 

Main__BEGIN__Is_Level_Zero:
        ; 8b2f:   a5 5d      L
        A Cave
        ; 8b31:   d0 27      B
        E Main__Level_Not_Zero


Main__Level_Is_Zero:
        ; 8b33:   a9 a0      L
        A #$a0
        ; 8b35:   8d 0c 98   S
        A MusicTickRoutine__Voice1SustainLevel
        ; 8b38:   20 81 8a   J
        R RasterSetTitleMode
        ; 8b3b:   20 1b 86   J
        R SetupTitleScreen
        ; 8b3e:   20 9b 85   J
        R RunTitleScreen
        ; 8b41:   a2 00      L
        X #$00
        ; 8b43:   a9 7c      L
        A #$7c
        ; 8b45:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 8b48:   9d 00 0d   S
        A GameTileMap1_or_TitleTextTileMap+$100,X
        ; 8b4b:   9d 00 0e   S
        A GameTileMap1_or_TitleTextTileMap+$200,X
        ; 8b4e:   9d f8 0e   S
        A GameTileMap1_or_TitleTextTileMap+$2f8,X
        ; 8b51:   e8         I
        X 
        ; 8b52:   d0 f1      B
        E $8b45
        ; 8b54:   20 46 87   J
        R InitPlayers
        ; 8b57:   4c 7a 8b   J
        P Main__ClearSpaceChar


Main__Level_Not_Zero:
        ; 8b5a:   20 22 87   J
        R SetLevel
        ; 8b5d:   a9 11      L
        A #$11
        ; 8b5f:   8d 7c 98   S
        A $987c
        ; 8b62:   a5 a2      L
        A IsDemoMode
        ; 8b64:   f0 0a      B
        Q $8b70
        ; 8b66:   20 13 89   J
        R DemoModeRunCave
        ; 8b69:   a9 00      L
        A #$00
        ; 8b6b:   85 a3      S
        A TitleScreenInLicenseMode
        ; 8b6d:   4c 77 8b   J
        P $8b77
        ; 8b70:   20 fb 88   J
        R RunCave
        ; 8b73:   a9 00      L
        A #$00
        ; 8b75:   85 42      S
        A AmeobaCouldGrowThisTick
        ; 8b77:   20 2e 80   J
        R PostCaveRunActions


Main__ClearSpaceChar:
        ; 8b7a:   a2 07      L
        X #$07
        ; 8b7c:   a9 00      L
        A #$00


Main__ClearSpaceCharLoop:
        ; 8b7e:   9d 00 20   S
        A CopiedTitleChar,X
        ; 8b81:   ca         D
        X 
        ; 8b82:   10 fa      B
        L Main__ClearSpaceCharLoop
        ; 8b84:   30 a9      B
        I Main__BEGIN__Is_Level_Zero


PartialSymbolTable:
        ; 8b86:   20 20 a8 00
        d5 81 79 00  3a 53 4b 34  20 20 a8 00
        ; 8b96:   e2 81 79 00
        3a 4c 50 58  20 20 a8 00  ec 81 79 00
        ; 8ba6:   3a 45 58 49
        54 20 a8 00  ef 81 79 00  4f 50 54 49
        ; 8bb6:   4f 4e a8 00
        f0 81 00 00  3a 45 58 49  54 20 a8 00
        ; 8bc6:   0e 82 7a 00
        4f 55 54 57  41 4c a8 00  0f 82 00 00
        ; 8bd6:   54 54 53 43
        45 4e a8 00  27 82 00 00  3a 4c 4f 4f
        ; 8be6:   50 31 a8 00
        29 82 7c 00  3a 4c 4f 4f  50 34 a8 00
        ; 8bf6:   4e 82 7c 00
        3a 4c 4f 4f  50 35 a8 00  65 82 7c 00
        ; 8c06:   3a 4c 4f 4f
        50 36 a8 00  7c 82 7c 00  3a 53 4b 31
        ; 8c16:   20 20 a8 00
        92 82 7c 00  3a 4c 4f 4f  50 37 a8 00
        ; 8c26:   96 82 7c 00
        3a 4c 4f 4f  50 38 a8 00  ad 82 7c 00
        ; 8c36:   3a 4c 4f 4f
        50 39 a8 00  c4 82 7c 00  3a 53 4b 32
        ; 8c46:   20 20 a8 00
        d7 82 7c 00  3a 4c 4f 4f  50 41 a8 00
        ; 8c56:   db 82 7c 00
        3a 4c 4f 4f  50 42 a8 00  f2 82 7c 00
        ; 8c66:   46 52 45 51
        20 20 a8 00  03 83 00 00  3a 4c 4f 4f
        ; 8c76:   50 43 a8 00
        09 83 7c 00  42 4c 55 45  20 20 a8 00
        ; 8c86:   8d 83 00 00
        3a 53 4b 30  20 20 a8 00  91 83 7d 00
        ; 8c96:   59 45 4c 4c
        4f 57 a8 00  a1 83 00 00  3a 53 4b 30
        ; 8ca6:   20 20 a8 00
        a5 83 7e 00  4d 55 53 50  4c 59 a8 00
        ; 8cb6:   ac 83 00 00
        3a 53 4b 30  20 20 a8 00  b3 83 7f 00
        ; 8cc6:   3a 53 4b 31
        20 20 a8 00  fd 83 7f 00  3a 45 58 49
        ; 8cd6:   54 20 a8 00
        2d 84 7f 00  4d 41 53 51  55 45 a8 00
        ; 8ce6:   2e 84 00 00
        3a 4c 4f 4f  50 20 a8 00  23 55 31 3a
        ; 8cf6:   35 2c 30 2c
        31 38 2c 31  38 20 e7 ff  a9 00 20 bd
        ; 8d06:   ff a9 0f a2
        08 a0 0f 20  ba ff 20 c0  ff a9 01 a2
        ; 8d16:   f2 a0 8c 20
        bd ff a9 05  a2 08 a0 05  20 ba ff 20
        ; 8d26:   c0 ff a2 0f
        20 c9 ff a2  00 bd f3 8c  20 d2 ff e8
        ; 8d36:   e0 0c d0 f5
        20 cc ff a2  0f 20 c6 ff  a2 00 20 cf
        ; 8d46:   ff c9 32 d0
        1f 20 cf ff  c9 33 d0 18  a0 14 20 cf
        ; 8d56:   ff 88 d0 fa
        a9 05 20 c3  ff a9 0f 20  c3 ff 20 cc
        ; 8d66:   ff 4c b3 8a
        a9 70 85 fb  a9 00 85 fa  aa a8 91 fa
        ; 8d76:   c8 d0 fb e8
        e0 20 d0 f6  4c b3 8a 55  00 ff 00 50
        ; 8d86:   00 ff ef ff
        00 ff 00 ff  00 00 00 00  00 00 00 00
        ; 8d96:   00 00 00 00
        00 00 00 00  00 00 00 00  00 00 00 00
        ; 8da6:   00 00 00 00
        00 00 00 00  00 00 00 00  00 00 00 00
        ; 8db6:   00 00 00 00
        00 00 00 00  00 00 00 00  00 00 00 00
        ; 8dc6:   00 00 00 00
        00 00 00 00  00 00 00 00  00 00 00 00
        ; 8dd6:   00 00 00 00
        00 00 00 00  00 00 00 00  00 00 00 00
        ; 8de6:   00 00 00 00
        00 00 00 00  00 00 00 00  00 00 00 00
        ; 8df6:   00 00 00 00
        00 00 00 00  00 00 00 00  00 00 00 00
        ; 8e06:   00 00 00 00
        00 00 00 00  00 00 00 00  00 00 00 00
        ; 8e16:   00 00 00 00
        00 00 00 00  00 00 00 00  00 00 00 00
        ; 8e26:   00 00 00 00
        00 00 00 00  00 00 00 00  00 00 00 00
        ; 8e36:   00 00 00 00
        00 00 00 00  00 00 00 00  00 00 00 00
        ; 8e46:   00 00 00 00
        00 00 00 00  00 00 00 00  00 00 00 00
        ; 8e56:   00 00 00 00
        00 00 00 00  00 00 00 00  00 00 00 00
        ; 8e66:   00 00 00 00
        00 00 00 00  00 00 00 00  00 00 00 00
        ; 8e76:   00 00 00 00
        00 00 00 00  00 00 00 00  00 00 00 00
        ; 8e86:   00 00 00 00
        00 00 00 00  00 00 00 00  00 00 00 00
        ; 8e96:   00 00 00 00
        00 00 00 00  00 00 00 00  00 00 00 00
        ; 8ea6:   00 00 00 00
        00 00 00 00  00 00 00 00  00 00 00 00
        ; 8eb6:   00 00 00 00
        00 00 00 00  00 00 ff ff  ff ff ff ff
        ; 8ec6:   ff ff ff ff
        ff ff ff ff  ff ff ff ff  ff ff ff ff
        ; 8ed6:   ff ff ff ff
        ff ff ff ff  ff ff ff ff  ff ff ff ff
        ; 8ee6:   ff ff ff ff
        ff ff ff ff  ff ff ff ff  ff ff ff ff
        ; 8ef6:   ff ff ff ff
        ff ff ff ff  ff ff 00 00  00 00 00 00
        ; 8f06:   00 00 00 00
        00 00 00 00  00 00 00 00  00 00 00 00
        ; 8f16:   00 00 00 00
        00 00 00 00  00 00 00 00  00 00 00 00
        ; 8f26:   00 00 00 00
        00 00 00 00  00 00 00 00  00 00 00 00
        ; 8f36:   00 00 00 00
        00 00 00 00  00 00 ff ff  ff ff ff ff
        ; 8f46:   ff ff ff ff
        ff ff ff ff  ff ff ff ff  ff ff ff ff
        ; 8f56:   ff ff ff ff
        ff ff ff ff  ff ff ff ff  ff ff ff ff
        ; 8f66:   ff ff ff ff
        ff ff ff ff  ff ff ff ff  ff ff ff ff
        ; 8f76:   ff ff ff ff
        ff ff ff ff  ff ff 00 00  00 00 00 00
        ; 8f86:   00 00 00 00
        00 00 00 00  00 00 00 00  00 00 00 00
        ; 8f96:   00 00 00 00
        00 00 00 00  00 00 00 00  00 00 00 00
        ; 8fa6:   00 00 00 00
        00 00 00 00  00 00 00 00  00 00 00 00
        ; 8fb6:   00 00 00 00
        00 00 00 00  00 00 ff ff  ff ff ff ff
        ; 8fc6:   ff ff ff ff
        ff ff ff ff  ff ff ff ff  ff ff ff ff
        ; 8fd6:   ff ff ff ff
        ff ff ff ff  ff ff ff ff  ff ff ff ff
        ; 8fe6:   ff ff ff ff
        ff ff ff ff  ff ff ff ff  ff ff ff ff
        ; 8ff6:   ff ff ff ff
        ff ff ff ff  ff ff


MOVEDCopyInflatedCaveSubsetToBackBuffer:
        ; 9e00:   a5 d6      L
        A InflatedCaveSubset
        ; 9e02:   18         C
        C 
        ; 9e03:   69 20      A
        C #$20
        ; 9e05:   8d 51 9e   S
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$51
        ; 9e08:   a5 d7      L
        A InflatedCaveSubset+1
        ; 9e0a:   69 03      A
        C #$03
        ; 9e0c:   8d 52 9e   S
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$52
        ; 9e0f:   ad 07 98   L
        A BackBufferVICMemControl
        ; 9e12:   4a         L
        R A
        ; 9e13:   4a         L
        R A
        ; 9e14:   49 03      E
        R #$03
        ; 9e16:   18         C
        C 
        ; 9e17:   69 01      A
        C #$01
        ; 9e19:   8d 55 9e   S
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$55
        ; 9e1c:   a9 b8      L
        A #$b8
        ; 9e1e:   8d 54 9e   S
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$54
        ; 9e21:   a2 00      L
        X #$00
        ; 9e23:   bd 51 9e   L
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$51,X
        ; 9e26:   18         C
        C 
        ; 9e27:   69 50      A
        C #$50
        ; 9e29:   9d 57 9e   S
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$57,X
        ; 9e2c:   bd 52 9e   L
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$52,X
        ; 9e2f:   69 00      A
        C #$00
        ; 9e31:   9d 58 9e   S
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$58,X
        ; 9e34:   bd 54 9e   L
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$54,X
        ; 9e37:   18         C
        C 
        ; 9e38:   69 28      A
        C #$28
        ; 9e3a:   9d 5a 9e   S
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$5a,X
        ; 9e3d:   bd 55 9e   L
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$55,X
        ; 9e40:   69 00      A
        C #$00
        ; 9e42:   9d 5b 9e   S
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$5b,X
        ; 9e45:   8a         T
        A 
        ; 9e46:   18         C
        C 
        ; 9e47:   69 06      A
        C #$06
        ; 9e49:   aa         T
        X 
        ; 9e4a:   e0 4e      C
        X #$4e
        ; 9e4c:   90 d5      B
        C MOVEDCopyInflatedCaveSubsetToBackBuffer+$23
        ; 9e4e:   a2 27      L
        X #$27
        ; 9e50:   bd 00 50   L
        A TitleCharData,X
        ; 9e53:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 9e56:   bd 00 50   L
        A TitleCharData,X
        ; 9e59:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 9e5c:   bd 00 50   L
        A TitleCharData,X
        ; 9e5f:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 9e62:   bd 00 50   L
        A TitleCharData,X
        ; 9e65:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 9e68:   bd 00 50   L
        A TitleCharData,X
        ; 9e6b:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 9e6e:   bd 00 50   L
        A TitleCharData,X
        ; 9e71:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 9e74:   bd 00 50   L
        A TitleCharData,X
        ; 9e77:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 9e7a:   bd 00 50   L
        A TitleCharData,X
        ; 9e7d:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 9e80:   bd 00 50   L
        A TitleCharData,X
        ; 9e83:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 9e86:   bd 00 50   L
        A TitleCharData,X
        ; 9e89:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 9e8c:   bd 00 50   L
        A TitleCharData,X
        ; 9e8f:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 9e92:   bd 00 50   L
        A TitleCharData,X
        ; 9e95:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 9e98:   bd 00 50   L
        A TitleCharData,X
        ; 9e9b:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 9e9e:   bd 00 50   L
        A TitleCharData,X
        ; 9ea1:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 9ea4:   ca         D
        X 
        ; 9ea5:   10 a9      B
        L MOVEDCopyInflatedCaveSubsetToBackBuffer+$50
        ; 9ea7:   ad 07 98   L
        A BackBufferVICMemControl
        ; 9eaa:   4a         L
        R A
        ; 9eab:   4a         L
        R A
        ; 9eac:   49 03      E
        R #$03
        ; 9eae:   8d f4 9e   S
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$f4
        ; 9eb1:   a9 28      L
        A #$28
        ; 9eb3:   8d f3 9e   S
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$f3
        ; 9eb6:   a5 d6      L
        A InflatedCaveSubset
        ; 9eb8:   8d f0 9e   S
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$f0
        ; 9ebb:   a5 d7      L
        A InflatedCaveSubset+1
        ; 9ebd:   8d f1 9e   S
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$f1
        ; 9ec0:   a2 00      L
        X #$00
        ; 9ec2:   bd f0 9e   L
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$f0,X
        ; 9ec5:   18         C
        C 
        ; 9ec6:   69 50      A
        C #$50
        ; 9ec8:   9d f6 9e   S
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$f6,X
        ; 9ecb:   bd f1 9e   L
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$f1,X
        ; 9ece:   69 00      A
        C #$00
        ; 9ed0:   9d f7 9e   S
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$f7,X
        ; 9ed3:   bd f3 9e   L
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$f3,X
        ; 9ed6:   18         C
        C 
        ; 9ed7:   69 28      A
        C #$28
        ; 9ed9:   9d f9 9e   S
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$f9,X
        ; 9edc:   bd f4 9e   L
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$f4,X
        ; 9edf:   69 00      A
        C #$00
        ; 9ee1:   9d fa 9e   S
        A MOVEDCopyInflatedCaveSubsetToBackBuffer+$fa,X
        ; 9ee4:   8a         T
        A 
        ; 9ee5:   18         C
        C 
        ; 9ee6:   69 06      A
        C #$06
        ; 9ee8:   aa         T
        X 
        ; 9ee9:   e0 36      C
        X #$36
        ; 9eeb:   90 d5      B
        C MOVEDCopyInflatedCaveSubsetToBackBuffer+$c2
        ; 9eed:   a2 27      L
        X #$27
        ; 9eef:   bd 00 50   L
        A TitleCharData,X
        ; 9ef2:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 9ef5:   bd 00 50   L
        A TitleCharData,X
        ; 9ef8:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 9efb:   bd 00 50   L
        A TitleCharData,X
        ; 9efe:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 9f01:   bd 00 50   L
        A TitleCharData,X
        ; 9f04:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 9f07:   bd 00 50   L
        A TitleCharData,X
        ; 9f0a:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 9f0d:   bd 00 50   L
        A TitleCharData,X
        ; 9f10:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 9f13:   bd 00 50   L
        A TitleCharData,X
        ; 9f16:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 9f19:   bd 00 50   L
        A TitleCharData,X
        ; 9f1c:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 9f1f:   bd 00 50   L
        A TitleCharData,X
        ; 9f22:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 9f25:   bd 00 50   L
        A TitleCharData,X
        ; 9f28:   9d 50 0c   S
        A GameTileMap1_or_TitleTextTileMap+$50,X
        ; 9f2b:   ca         D
        X 
        ; 9f2c:   10 c1      B
        L MOVEDCopyInflatedCaveSubsetToBackBuffer+$ef
        ; 9f2e:   20 f7 7a   J
        R Animate
        ; 9f31:   a5 a8      L
        A ExtraLifeFXCounter
        ; 9f33:   f0 03      B
        Q MOVEDCopyInflatedCaveSubsetToBackBuffer+$138
        ; 9f35:   20 54 74   J
        R ExtraLifeFX
        ; 9f38:   60         R
        S 

;         
