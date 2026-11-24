; Time Pilot DX - new code in bank 2 (free area $F10A-$F98C, reached via CALL2 at $F100)
; Far call from bank 0:  LDX #id / JSR CALL2   (X selects the routine; A,Y pass through)
DISP2   LDA   D2HI,X
        PHA
        LDA   D2LO,X
        PHA
        RTS

F_SCINIT = 0
F_PRE   = 1
F_SHOT  = 2
D2LO    .byte <(SCInit-1), <(DxPre-1), <(DxShot-1)
D2HI    .byte >(SCInit-1), >(DxPre-1), >(DxShot-1)

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
