; Time Pilot DX - M4 band kernel (bank 1, at $D125). Two enemy sprites per band, no flicker.
; 9 bands x 16 lines, X = band (8 = top). Each band: T1 position P1, T2 position P0, T3 HMOVE + pointers,
; then 13 drawn rows (Y = 12..0): B rows (even Y) draw missiles, A rows (odd Y) draw clouds.
; P0 is vertically delayed: GRP0 for the next row is written late in each line and appears when GRP1 is
; written at the start of the next one.  P0 shows the ship in band 4 and enemies elsewhere.
; Per-band inputs (built in bank 2): SC arrays P1C/P1HM (HM | REFP1 bit 3), P0C/P0HM (HM | REFP0 bit 3),
; P0LO (lo-1)/P0HI, COL0, P1HI;  zp $BF,X P1 lo (page P1HI), $CD,X/$DC,X missile enables, $E8,X cloud row.
; RESP is written at cycle 5k+17 after WSYNC, exactly as the original's SBC loop did.

LD025   STA   COLUBK
        BIT   $85
        BPL   KStart
        JMP   LD355             ; era warp effect (original)
KStart  LDA   SCR+COL0+8        ; (the top kernel left VDELs, GRPs and NUSIZs at 0)
        STA   COLUP0
        LDA   #1
        STA   VDELP0
        LDA   SCR+PF1N+8
        STA   PF1
        LDA   SCR+PF2N+8
        STA   PF2
        LDX   #8                ; band 8: P1 was already positioned by the top kernel (from $BE),
        BNE   KT2               ; so it skips T1 - this keeps the kernel at the original's 143 lines
        ; ---- T1: blank the sprites, coarse-position P1
KT1     STA   WSYNC
        LDA   SCR+COL0,X        ; 4  (sprites are not blanked: an edge row repeats instead of a gap)
        STA   COLUP0            ; 7
        NOP                     ; 9
        NOP                     ; 11
        LDY   SCR+P1C,X         ; 15
.d1     DEY
        BPL   .d1               ; 5(Y+1)-1
        STA   RESP1             ; write at 5k+17
        ; ---- T2: P1 fine motion, coarse-position P0
KT2     STA   WSYNC
        LDA   SCR+P1HM,X        ; 4
        STA   HMP1              ; 7
        LDA   SCR+P0HM,X        ; 11
        LDY   SCR+P0C,X         ; 15
.d2     DEY
        BPL   .d2
        STA   RESP0
        STA   HMP0
        ; ---- T3: HMOVE, pointers for this band (67 cycles)
        STA   WSYNC
        STA   HMOVE             ; 3
        LDA   $BF,X
        STA   $F2               ; 10
        LDA   SCR+P1HI,X        ;     M6: P1 page per band (enemy page, or another page for specials)
        STA   $F3               ; 17
        LDA   SCR+P1HM,X
        STA   REFP1             ; 24
        LDA   SCR+P0HM,X
        STA   REFP0             ; 31
        LDA   SCR+P0LO,X        ;     P0LO holds lo-1: ($FE),Y always fetches the next row
        STA   $FE               ; 38
        LDA   SCR+P0HI,X
        STA   $FF               ; 45
        LDA   $CD,X
        STA   $F4               ; 52
        LDA   $DC,X
        STA   $F6               ; 59
        LDY   #13               ; 61
        LDA   ($FE),Y
        STA   GRP0              ; 69  row 12 (shown when GRP1 is written)
        DEY                     ; 71  (KLoopB's WSYNC write ends at 74)
KLoopB  STA   WSYNC         ; B row (even Y): clouds too (same pair as the A row above, except in a band's
        LDA   ($F2),Y           ;   first row, where this replaces the setup lines' row-15 value)
        STA   GRP1              ; 8
        LDA   ($F8),Y
        STA   PF0               ; 16
        LDA   ($FA),Y
        STA   PF1               ; 24
        LDA   ($FC),Y
        STA   PF2               ; 32
        LDA   ($F6),Y
        STA   ENAM1             ; 40
        LDA   ($F4),Y
        STA   ENAM0             ; 48
        LDA   ($FE),Y
        STA   GRP0              ; 56
        DEY                     ; 58
KLoopA  STA   WSYNC
        LDA   ($F2),Y
        STA   GRP1              ; 8
        LDA   ($F8),Y
        STA   PF0               ; 16
        LDA   ($FA),Y
        STA   PF1               ; 24
        LDA   ($FC),Y
        STA   PF2               ; 32
        LDA   ($FE),Y
        STA   GRP0              ; 40
        DEY                     ; 42
        BNE   KLoopB            ; 45
        ; ---- last row of the band (Y = 0); then the next band's cloud pointers and its first
        ; cloud row (PF1/PF2, precomputed) so the three setup lines show the right cloud shape
        STA   WSYNC
        LDA   ($F2),Y
        STA   GRP1              ; 8
        LDA   ($F4),Y
        STA   ENAM0             ; 16
        CLC
        LDA   $E8,X
        TAY
        ADC   $E6
        STA   $F8
        TYA
        ADC   $E7
        STA   $FA
        TYA
        ADC   $E8
        STA   $FC               ; 46
        DEX                     ; 48
        BMI   KDone             ; 50  (after band 0 go straight to the bottom panel)
        LDA   SCR+PF1N,X        ;     next band's first cloud row
        STA   PF1               ; 57
        LDA   SCR+PF2N,X
        STA   PF2               ; 64
        JMP   KT1               ; 67 (KT1's WSYNC write at 70)
KDone   JMP   LD1B6

    IF >.d1 != >(.d1+3)
        ERR
    ENDIF
    IF >.d2 != >(.d2+3)
        ERR
    ENDIF
    IF >KLoopB != >(KLoopA+30)
        ECHO "note: band loop crosses a page (harmless, lines have slack)"
    ENDIF
