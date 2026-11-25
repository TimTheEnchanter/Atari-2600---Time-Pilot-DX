; Time Pilot DX - new code in bank 3 (dead band-kernel area $D113-$D1B5).
; Reached from bank 2: LDX #id / JSR CALL3 ($F109 STA $1FF9 -> $D10C JSR DISP3, $D10F STA $1FF8 -> $F112 RTS)
DISP3   LDA   D3HI,X
        PHA
        LDA   D3LO,X
        PHA
        RTS
D3LO    .byte <(DxCloud-1), <(DxEnemy-1), <(DxBuild-1)
D3HI    .byte >(DxCloud-1), >(DxEnemy-1), >(DxBuild-1)

; Per band: the cloud row 15 (shown during the three setup lines) for PF1 and PF2, read from this bank's
; copy of the original cloud data, exactly where the kernel's pointers will point.
DxCloud SUBROUTINE
        LDA   SCR+CLH1
        STA   $F3
        LDX   #8
.l1     LDA   $E9,X             ; band's cloud row
        CLC
        ADC   SCR+CLB1
        STA   $F2
        LDY   #15
        LDA   ($F2),Y
        STA   SCW+PF1N,X
        DEX
        BPL   .l1
        LDA   SCR+CLH2
        STA   $F3
        LDX   #8
.l2     LDA   $E9,X
        CLC
        ADC   SCR+CLB2
        STA   $F2
        LDY   #15
        LDA   ($F2),Y
        STA   SCW+PF2N,X
        DEX
        BPL   .l2
    IFCONST DEBUGT
        LDA   INTIM
        STA   $B3
    ENDIF
        RTS

; ---- bottom panel, in-game path (moved from LD286 so the progress bar fits); same lines and timing
NEWBOT  LDY   SCR+ICONIX        ; stage (of 6 planes) + 7 * era, set by the builder
        STA   WSYNC
        STX   PF2               ; era icon box
        LDA   SCR+BAR
        STA   PF1               ; progress bar either side of the box (mirrored playfield)
        LDA   ICT0,Y
        STA   $F2
        LDA   ICT1,Y
        STA   $F4
        LDA   ICT2,Y
        STA   $F6
        LDA   ICT3,Y
        STA   $F8
        LDA   ICT4,Y
        STA   $FA
        LDA   ICT5,Y
        STA   $FC
        LDA   #$09
        STA   $FE
        STA   $FF
        JMP   LD2B4
