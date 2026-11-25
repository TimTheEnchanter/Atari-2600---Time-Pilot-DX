; Time Pilot DX - M4 band-table builder (bank 3, $D800 area). Runs every frame after LF346 (and LF813's missile part).
; Scratch: $F2 x, $F3 y then band, $F4 state then upper band, $F5 reflect, $F6 frame base, $F7 offset
; ($F8-$FF hold the far-call return addresses.)  Fills, per band: P1 (zp $BF lo, SC P1C/P1HM) and P0 (SC P0C/P0HM/P0LO/P0HI), COL0.
; P1 lo 0 / P0 lo 1 = blank (both point at the blank start of every enemy page).
SHIPB   = 4             ; band drawn with the ship on P0
SHIPX   = $50           ; ship x (the top kernel positions the original ship from $50)
SHIPC   = 5             ; POSC[$50]
SHIPHM  = $20           ; POSHM[$50] (checked by gen_m4.py)
BOSSL   = $C6           ; boss halves in every enemy page (gen_m5.py)
BOSSR   = $E2

    MAC SETP1                   ; P1 coarse/HM for band X; band 8's x also goes to $BE (top kernel)
        LDA   $F2
        STA   SCW+P1C,X
        LDA   $F5
        STA   SCW+P1HM,X
        CPX   #8
        BNE   .s1
        LDA   SCR+TMPX
        STA   $BE
.s1
    ENDM

DxBuild SUBROUTINE
        ; ---- progress bar: kills done out of the mode's quota, in 8 steps
        LDA   #0
        LDX   $80
        CPX   #2
        BNE   .bar
        LDY   $87
        LDA   QUOTA,Y
        SEC
        SBC   $96               ; kills done
        LDX   #0
.div    CMP   QUOTA8,Y
        BCC   .dv
        SBC   QUOTA8,Y
        INX
        CPX   #8
        BCC   .div
.dv     LDA   BARPAT,X
.bar    STA   SCW+BAR
        LDY   $96               ; bottom-panel icon: stage by kills left + 7 * era
        LDA   ICON56,Y
        LDY   $95
        CLC
        ADC   ERA7,Y
        STA   SCW+ICONIX
        ; ---- this frame's enemy page (eras 3 and 5 alternate two pages every 8 frames) and colour
        LDY   $95
        LDA   T_PAGE,Y
        CPY   #2
        BEQ   .anim
        CPY   #4
        BNE   .pg
.anim   LDX   $81
        TXA
        AND   #8
        BEQ   .pg0
        LDA   T_PAGE,Y
        CLC
        ADC   #1
        BNE   .pg
.pg0    LDA   T_PAGE,Y
.pg     CMP   SCR+P0HI+0        ; page/colour unchanged since last frame?
        BNE   .newpg
        LDX   T_ECOL,Y
        CPX   SCR+COL0+0
        BEQ   .samepg
.newpg  LDX   #8
.pgl    STA   SCW+P0HI,X
        DEX
        BPL   .pgl
        LDA   T_ECOL,Y           ; enemy colour (original COLUP1)
        LDX   #8
.coll   STA   SCW+COL0,X
        DEX
        BPL   .coll
        LDA   #$D4              ; ship band: ship page and colour
        STA   SCW+P0HI+SHIPB
        LDA   T_SCOL,Y
        STA   SCW+COL0+SHIPB
.samepg
        ; ---- empty bands (unrolled): P1 lo 0, coarse 0, HM of x=0, P0 lo 1 (P0HM bit 0 = band taken)
        LDA   #0
        STA   $BE
        STA   $BF
        STA   SCW+P1C+0
        STA   SCW+P0C+0
        STA   $C0
        STA   SCW+P1C+1
        STA   SCW+P0C+1
        STA   $C1
        STA   SCW+P1C+2
        STA   SCW+P0C+2
        STA   $C2
        STA   SCW+P1C+3
        STA   SCW+P0C+3
        STA   $C3
        STA   SCW+P1C+4
        STA   $C4
        STA   SCW+P1C+5
        STA   SCW+P0C+5
        STA   $C5
        STA   SCW+P1C+6
        STA   SCW+P0C+6
        STA   $C6
        STA   SCW+P1C+7
        STA   SCW+P0C+7
        STA   $C7
        STA   SCW+P1C+8
        STA   SCW+P0C+8
        LDA   POSHM
        STA   SCW+P1HM+0
        STA   SCW+P0HM+0
        STA   SCW+P1HM+1
        STA   SCW+P0HM+1
        STA   SCW+P1HM+2
        STA   SCW+P0HM+2
        STA   SCW+P1HM+3
        STA   SCW+P0HM+3
        STA   SCW+P1HM+4
        STA   SCW+P1HM+5
        STA   SCW+P0HM+5
        STA   SCW+P1HM+6
        STA   SCW+P0HM+6
        STA   SCW+P1HM+7
        STA   SCW+P0HM+7
        STA   SCW+P1HM+8
        STA   SCW+P0HM+8
        LDA   #1
        STA   SCW+P0LO+0
        STA   SCW+P0LO+1
        STA   SCW+P0LO+2
        STA   SCW+P0LO+3
        STA   SCW+P0LO+5
        STA   SCW+P0LO+6
        STA   SCW+P0LO+7
        STA   SCW+P0LO+8
        ; ---- ship on P0 in its band
        LDA   $A4
        STA   SCW+P0LO+SHIPB
        LDA   #SHIPC
        STA   SCW+P0C+SHIPB
        LDA   $A3
        AND   #4
        ASL
        ORA   #SHIPHM|1
        STA   SCW+P0HM+SHIPB
        ; ---- the era boss first: two halves side by side (P1 left, P0 right), blinking after a hit
        LDX   #NENEMY-1
.bs     LDA   ENS,X
        AND   #$40
        BEQ   .bn
        LDA   ENX,X
        BEQ   .bn
        LDA   ENY,X
        BNE   .bf
.bn     DEX
        BPL   .bs
        BMI   .bdone
.bf     LDA   SCR+BOSSFL
        LSR
        BCS   .bdone            ; blink frame
        STX   $A2
        LDA   ENS,X
        BMI   .bx               ; exploding: an explosion on both halves
        AND   #4                ; heading left: mirrored, so the halves swap sides
        BNE   .bl
        LDA   #BOSSL
        LDY   #BOSSR
        BNE   .bb
.bl     LDA   #BOSSR
        LDY   #BOSSL
        BNE   .bb
.bx     LDA   #$A6
        TAY
.bb     STA   $F6
        STY   SCW+BOSSB2
        LDX   $A2
        LDA   ENY,X
        STA   $F3
        LDA   ENS,X
        STA   $F4
        LDA   ENX,X
        JSR   .place
        LDX   $A2
        LDA   ENY,X
        STA   $F3
        LDA   ENS,X
        STA   $F4
        LDA   SCR+BOSSB2
        STA   $F6
        LDA   ENX,X
        CMP   #$8A              ; right half past the last position ($91): leave it off-screen
        BCS   .bdone            ; (larger x makes the band's RESP late and loses a frame)
        ADC   #8
        JSR   .place
.bdone
        ; ---- the other enemies: 0-3 original zero-page slots, 4-5 Superchip slots
        LDA   SCR+ROT           ; start with a different enemy each frame
        CLC
        ADC   #1
        CMP   #NENEMY+NEX
        BCC   .r0
        LDA   #0
.r0     STA   SCW+ROT
        LDA   #NENEMY+NEX
        STA   SCW+ROTN
        LDY   SCR+ROT
.en     STY   $A2
        LDA   INTIM             ; out of overscan time: leave the rest out of this frame's tables
        CMP   #6                ; (one enemy with a spill costs ~4.5 units)
        BCC   .done
        CPY   #NENEMY
        BCS   .g1
        LDA   $00A5,Y
        BEQ   .nxt
        LDA   $00A9,Y
        BEQ   .nxt
        STA   $F3
        LDA   $00AD,Y
        AND   #$40
        BNE   .nxt              ; the boss is already drawn
        LDA   $00AD,Y
        STA   $F4
        LDA   $00A5,Y
        JMP   .got
.g1     LDA   SCR+EX2-NENEMY,Y
        BEQ   .nxt
        LDA   SCR+EY2-NENEMY,Y
        BEQ   .nxt
        STA   $F3
        LDA   SCR+ES2-NENEMY,Y
        STA   $F4
        LDA   SCR+EX2-NENEMY,Y
.got    PHA                     ; frame base by heading, or the explosion frame
        LDA   $F4
        AND   #7
        TAX
        LDA   T_FBASE,X
        BIT   $F4
        BPL   .ne
        LDA   #$A6
.ne     STA   $F6
        PLA
        JSR   .place
.nxt    LDA   SCR+ROTN
        SEC
        SBC   #1
        BEQ   .done
        STA   SCW+ROTN
        LDY   $A2
        INY
        CPY   #NENEMY+NEX
        BCC   .nx2
        LDY   #0
.nx2    JMP   .en
.done   LDA   SCR+P1HM+8        ; band 8's P1 is positioned by the top kernel from $BE: no extra fine motion
        AND   #$0F
        STA   SCW+P1HM+8
    IFCONST DEBUGT
        LDA   INTIM
        STA   $B8
    ENDIF
        RTS
; PLACE: A = x (non-zero), $F3 = y, $F4 = state (reflect from bit 2), $F6 = frame base.
; Puts the sprite in P1 if its band(s) are free there, else in P0 (never the ship's). Uses $F2-$F7.
.place  STA   SCW+TMPX
        TAX
        LDA   POSC,X
        STA   $F2               ; coarse
        LDA   POSHM,X
        STA   $F5
        LDA   $F4
        AND   #4
        ASL
        ORA   #1                ; reflect | taken
        ORA   $F5
        STA   $F5
        LDA   $F3
        AND   #$0F
        STA   $F7               ; off
        LDA   $F3
        LSR
        LSR
        LSR
        LSR
        STA   $F3               ; band b
        LDX   #$FF
        LDA   $F7
        CMP   #3
        BCC   .nos
        LDX   $F3
        INX
        CPX   #9
        BCC   .nos
        LDX   #0                ; spills off the top: original wraps it to band 0
.nos    STX   $F4               ; upper band or $FF
        LDX   $F3
        LDA   $BF,X
        BNE   .tryp0
        LDX   $F4
        BMI   .p1
        LDA   $BF,X
        BNE   .tryp0
.p1     LDX   $F3
        LDA   $F6
        SEC
        SBC   $F7
        STA   $BF,X
        SETP1
        LDX   $F4
        BMI   .prts
        LDA   $F6
        CLC
        ADC   #16
        SEC
        SBC   $F7
        STA   $BF,X
        SETP1
.prts   RTS
.tryp0  LDX   $F3
        LDA   SCR+P0HM,X
        LSR
        BCS   .prts
        LDX   $F4
        BMI   .p0
        LDA   SCR+P0HM,X
        LSR
        BCS   .prts
.p0     LDX   $F3
        LDA   $F6
        SEC
        SBC   $F7
        STA   SCW+P0LO,X
        LDA   $F2
        STA   SCW+P0C,X
        LDA   $F5
        STA   SCW+P0HM,X
        LDX   $F4
        BMI   .prts
        LDA   $F6
        CLC
        ADC   #16
        SEC
        SBC   $F7
        STA   SCW+P0LO,X
        LDA   $F2
        STA   SCW+P0C,X
        LDA   $F5
        STA   SCW+P0HM,X
        RTS

QUOTA   .byte 56, 56, 56, 56  ; kills per era, indexed by $87 (arcade: 56; original LF272 8/16/24/24)
QUOTA8  .byte 7, 7, 7, 7
BARPAT  .byte $00,$01,$03,$07,$0F,$1F,$3F,$7F,$FF
ERA7    .byte 0, 7, 14, 21, 28
