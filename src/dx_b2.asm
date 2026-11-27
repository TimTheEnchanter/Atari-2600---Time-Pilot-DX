; Time Pilot DX - new code in bank 2 (free area $F10A-$F98C, reached via CALL2 at $F100)
; Far call from bank 0:  LDX #id / JSR CALL2   (X selects the routine; A,Y pass through)
; M7: GAME OVER in the top box: the title kernel (LF993) with its own bitmap, same instructions and timing.
; Bank 0 points the state-2 top-kernel jump at it (DXPRE sets $B3/$B4), so it must stay at $F113.
GOKern  LDA   #21
        STA   $FE
        LDA   #22
        STA   $FF
GOK1    STA   WSYNC
        LDY   $FE
        LDA   GO0,Y
        STA   GRP0
        LDA   GO1,Y
        STA   GRP1
        LDA   GO2,Y
        STA   GRP0
        LDA   GO5,Y
        STA   $A2
        LDA   GO3,Y
        LDX   GO4,Y
        LDY   $A2
        STA   GRP1
        STX   GRP0
        STY   GRP1
        STX   GRP0
        DEC   $FE
        DEC   $FF
        BNE   GOK1
        JMP   LFB8E

    IF GOKern != $F113
      ERR
    ENDIF

DISP2   LDA   D2HI,X
        PHA
        LDA   D2LO,X
        PHA
        RTS

F_SCINIT = 0
F_PRE   = 1
F_SHOT  = 2
F_BUILD = 3
F_CLOUD = 4
F_SHIP  = 5
F_ENEMY = 6
F_M6    = 7
D2LO    .byte <(SCInit-1), <(DxPre-1), <(DxShot-1), <(B3Build-1), <(DxCloudC-1), <(DxShip-1), <(B3Enemy-1), <(DxM6-1)
D2HI    .byte >(SCInit-1), >(DxPre-1), >(DxShot-1), >(B3Build-1), >(DxCloudC-1), >(DxShip-1), >(B3Enemy-1), >(DxM6-1)

    include "m7_go.asm"         ; 6 x 22 bytes, each column inside one page (no page-cross cycles)
    IF >GO0 != >(GO5+21)
      ERR
    ENDIF

; routines that live in bank 3
B3Enemy LDX   #1
        JMP   CALL3
B3Build LDX   #2
        JMP   CALL3

; Clear the Superchip RAM; if it doesn't read back, stop on a red screen (cart set to plain F6).
SCInit  LDX   #$7F
.t1     TXA
        EOR   #$5A
        STA   SCW,X
        DEX
        BPL   .t1
        LDX   #$7F
.t2     TXA
        EOR   #$5A
        CMP   SCR,X
        BNE   SCFail
        LDA   #0
        STA   SCW,X
        DEX
        BPL   .t2
        RTS
SCFail  LDA   #$42
        STA   COLUBK
        LDA   #0
        STA   VBLANK
        JMP   SCFail

    include "m3.asm"
    include "m3_tables.asm"
    include "m4c.asm"
    include "m6.asm"
