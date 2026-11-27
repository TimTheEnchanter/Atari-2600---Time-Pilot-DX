; Time Pilot DX - M6: arcade enemy behaviour (bank 2)
;  - parachutists: drift down through the sky, scroll with it; flying into one rescues him (1000, 2000 ... 5000)
;  - homing missiles (from 1970 on): enemy bullets turn one step toward the ship every 16 frames, scroll with
;    the sky, burn out after ~160 frames, and can be shot down
;  - boss bombs: the era boss drops an aimed shot every 32 frames (homing from 1970 on)
; Called every frame from bank 0 DXPRE (vblank, after DxEnemy). Returns A = BCD points to add (0 = none).
; Scratch $F2-$F4, $A2. Never runs on phase 0 (the cloud step needs that vblank); the heavy parts (homing,
; boss bombs, shot tests) run on odd phases, where vblank has ~19 units to spare (even phases only ~3-12).
TGTX    = $50           ; ship centre in bullet coordinates (DxShip's bullet box is x 76..85, y 63..78)
TGTY    = $46
MAGEMAX = 14            ; missile life in 8-frame steps (M8: was 20)
HOMMASK = 3             ; steer when (age & HOMMASK) = 0: every 32 frames (M8: was every 16)
HOMERA  = 2             ; first era with homing missiles (1970)

DxM6    SUBROUTINE
    IFCONST DEBUGT
        LDA   INTIM
        STA   $BD
    ENDIF
        LDA   #0
        STA   $A2               ; points to return
        LDA   $80
        CMP   #2
        BNE   .idle
        BIT   $A0
        BMI   .idle
        LDA   $81
        AND   #7
        BNE   .run
.ret    LDA   $A2
        RTS
.idle   LDA   #0                ; not playing: no parachutist, rescue count restarts
        STA   SCW+PARY
        STA   SCW+PARN
        LDX   $80               ; attract: the next game's first boss starts with full hit points
        BNE   .ret
        STA   SCW+BOSSHP
        BEQ   .ret
.run
        ; ================= parachutist
        LDA   SCR+PARY
        BEQ   .pspawn
        JMP   .pmove
.pdj    JMP   .pdone
.pspawn ; ---- spawn: every 256 frames (phase 5), 25%, not while the boss is up
        LDA   $81
        CMP   #$85
        BNE   .pdj
        LDA   $82               ; M8: 1 in 4 (was 1 in 2)
        AND   #$C0
        BNE   .pdj
        LDA   SCR+BOSSHP
        BNE   .pdj
        LDA   $A4
        CMP   #$A0              ; ship exploding / hidden
        BCS   .pdj
        LDY   SDIR              ; enter from the side the sky scrolls in from
        LDA   M6SCY,Y
        BEQ   .phor
        BMI   .ptop
        LDA   #4                ; sky moves up: come in at the bottom
        BNE   .pvy
.ptop   LDA   #$8C
.pvy    STA   SCW+PARY
        LDA   $82
        AND   #$3F
        ADC   #$20              ; x $20-$60
        STA   SCW+PARX
        JMP   .pdone
.phor   LDA   M6SCX,Y
        BMI   .pright
        LDA   #2
        BNE   .pvx
.pright LDA   #$91
.pvx    STA   SCW+PARX
        LDA   $82
        AND   #$3F
        ADC   #$28              ; y $28-$68
        STA   SCW+PARY
        JMP   .pdone
        ; ---- fall 1 px every 4 frames (phases 1, 5), scroll 4 px every 8 (phase 3)
.pmove  LDA   $81
        AND   #7
        AND   #3
        CMP   #1
        BNE   .pf
        LDA   SCR+PARY
        SEC
        SBC   #1
        STA   SCW+PARY
.pf     LDA   $81
        AND   #7
        CMP   #3
        BNE   .pcol
        LDY   SDIR
        LDA   SCR+PARX
        CLC
        ADC   M6SCX,Y
        CMP   #2
        BCC   .pgone
        CMP   #$92
        BCS   .pgone
        STA   SCW+PARX
        LDA   SCR+PARY
        CLC
        ADC   M6SCY,Y
        STA   SCW+PARY
.pcol   LDA   SCR+PARY          ; off the top or bottom?
        CMP   #2
        BCC   .pgone
        CMP   #$8F
        BCS   .pgone
        LDA   $A4               ; rescue: parachutist inside the ship's ram box
        CMP   #$A0
        BCS   .pdone
        LDA   SCR+PARX
        SEC
        SBC   #68
        CMP   #24
        BCS   .pdone
        LDA   SCR+PARY
        SEC
        SBC   #49
        CMP   #28
        BCS   .pdone
        LDX   SCR+PARN
        LDA   PARPTS,X
        STA   $A2
        CPX   #4
        BCS   .pgone
        INX
        STX   SCW+PARN
.pgone  LDA   #0
        STA   SCW+PARY
.pdone
        ; ================= boss bombs (phase 5, every 32 frames)
        LDA   $81
        AND   #31
        CMP   #13
        BNE   .bbdone
        LDA   SCR+BOSSHP
        BEQ   .bbdone
        LDA   $95               ; M8: homing bombs (1970 on) only every 64 frames
        CMP   #HOMERA
        BCC   .bb32
        LDA   $81
        AND   #32
        BNE   .bbdone
.bb32   LDY   #NENEMY-1
.bbf    LDA   ENS,Y
        AND   #$C0
        CMP   #$40              ; boss, not exploding
        BEQ   .bbg
        DEY
        BPL   .bbf
        BMI   .bbdone
.bbg    LDX   #1
.bbs    LDA   $D8,X
        BEQ   .bbfree
        DEX
        BPL   .bbs
        BMI   .bbdone
.bbfree LDA   ENX,Y
        CLC
        ADC   #8                ; from the middle of the 16-pixel boss
        CMP   #$92
        BCS   .bbdone
        STA   $D8,X
        STA   $F2
        LDA   ENY,Y
        CLC
        ADC   #4
        STA   $DA,X
        STA   $F3
        JSR   Aim
        STA   $D6,X
        LDA   #0
        STA   SCW+MAGE,X
.bbdone
        ; ================= homing missiles
        LDA   $95
        CMP   #HOMERA
        BCS   .mhome
        JMP   .mdone
.mhome
        LDA   $81
        AND   #7
        CMP   #3                ; age, scroll and steer on phase 3
        BNE   .mshot
        LDX   #1
.ml     LDA   $D8,X
        BEQ   .mz
        LDA   $DA,X
        BEQ   .mz
        LDA   SCR+MAGE,X
        CLC
        ADC   #1
        STA   SCW+MAGE,X
        CMP   #MAGEMAX
        BCS   .mkill            ; burnt out
        LDY   SDIR
        LDA   $D8,X
        CLC
        ADC   M6SCX,Y
        CMP   #2
        BCC   .mkill
        CMP   #$92
        BCS   .mkill
        STA   $D8,X
        STA   $F2
        LDA   $DA,X
        CLC
        ADC   M6SCY,Y
        CMP   #2
        BCC   .mkill
        CMP   #$8F
        BCS   .mkill
        STA   $DA,X
        STA   $F3
        LDA   SCR+MAGE,X
        AND   #HOMMASK
        BNE   .mn               ; steer every 32 frames
        JSR   Aim               ; A = wanted heading
        SEC
        SBC   $D6,X
        AND   #7
        BEQ   .mn
        LDY   #1
        CMP   #5
        BCC   .mt               ; 1-4 steps clockwise (4: either way)
        LDY   #$FF
.mt     TYA
        CLC
        ADC   $D6,X
        AND   #7
        STA   $D6,X
        JMP   .mn
.mz     LDA   #0
        STA   SCW+MAGE,X
        BEQ   .mn
.mkill  LDA   #0
        STA   $D6,X
        STA   $D8,X
        STA   $DA,X
        STA   SCW+MAGE,X
.mn     DEX
        BPL   .ml
        LDA   #1                ; phase 3: shot test too
        ; ---- player shots against missiles (odd phases)
.mshot  LSR
        BCC   .mdone
        LDX   #1
.ms     LDA   $DA,X
        BEQ   .msn
        LDY   #NSHOT-1
.msy    LDA   SCR+SHY,Y
        BEQ   .msyn
        SEC
        SBC   $DA,X
        CLC
        ADC   #7
        CMP   #15               ; |dy| < 8
        BCS   .msyn
        LDA   SCR+SHX,Y
        SEC
        SBC   $D8,X
        CLC
        ADC   #5
        CMP   #11               ; |dx| < 6
        BCS   .msyn
        LDA   #0                ; both gone
        STA   SCW+SHY,Y
        STA   $D6,X
        STA   $D8,X
        STA   $DA,X
        STA   SCW+MAGE,X
        LDA   $A2
        BNE   .msn
        LDA   #1                ; 100 points
        STA   $A2
        BNE   .msn
.msyn   DEY
        BPL   .msy
.msn    DEX
        BPL   .ms
.mdone
    IFCONST DEBUGT
        LDA   INTIM
        STA   $BB
    ENDIF
        LDA   $A2
        RTS

; ---- A = 8-way heading from ($F2,$F3) toward the ship (0 = up, clockwise, as the bullet tables). Keeps X.
; Uses $F2-$F4, Y and SC AIMT (its return address is at $F5-$F6).
Aim     SUBROUTINE
        LDA   #TGTX
        SEC
        SBC   $F2
        STA   $F4               ; dx (signed)
        BPL   .ax
        EOR   #$FF
        CLC
        ADC   #1
.ax     STA   SCW+AIMT          ; |dx|
        LDA   #TGTY
        SEC
        SBC   $F3
        STA   $F3               ; dy (signed)
        BPL   .ay
        EOR   #$FF
        CLC
        ADC   #1
.ay     STA   $F2               ; |dy|
        ASL                     ; 2|dy| < |dx|: horizontal
        CMP   SCR+AIMT
        BCC   .hor
        LDA   SCR+AIMT
        ASL
        CMP   $F2               ; 2|dx| < |dy|: vertical
        BCC   .ver
        LDY   #1                ; diagonal: 1 up-right, 3 down-right, 5 down-left, 7 up-left
        BIT   $F3
        BPL   .d1
        LDY   #3
.d1     BIT   $F4
        BPL   .d2
        TYA
        EOR   #6                ; 1 <-> 7, 3 <-> 5
        TAY
.d2     TYA
        RTS
.hor    LDA   #2
        BIT   $F4
        BPL   .h1
        LDA   #6
.h1     RTS
.ver    LDA   #0
        BIT   $F3
        BPL   .v1
        LDA   #4
.v1     RTS

PARPTS  .byte $10,$20,$30,$40,$50   ; rescue bonus, BCD hundreds (1000-5000)
M6SCX   .byte $00,$FC,$FC,$FC,$00,$04,$04,$04   ; sky scroll per 8 frames by SDIR (as LFFD5)
M6SCY   .byte $FC,$FC,$00,$04,$04,$04,$00,$FC   ; (as LFFDD)
