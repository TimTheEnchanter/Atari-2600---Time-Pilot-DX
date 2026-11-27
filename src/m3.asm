; Time Pilot DX - M3: 16-direction ship and 3 player shots (bank 2)
; Superchip RAM offsets
D16     = $2A           ; ship heading 0-15 (0 = up, clockwise)
SHD     = $2B           ; shot heading x3
SHX     = $2E           ; shot X x3
SHY     = $31           ; shot Y x3 (0 = free)
SHOWN   = $34           ; shot drawn last frame ($FF = none)
FIRET   = $35           ; autofire countdown
NSHOT   = 3
; enemies: group 0 = the original 4 zero-page slots, group 1 = NEX Superchip slots (EX2/EY2/ES2)

; hit test of shot X against enemy group: {1} x(read) {2} y(read) {3} state(read) {4} state(write) {5} exit label
    MAC HITG
.he     LDA   SCR+SHY,X
        SEC
        SBC   {2},Y
        SEC
        SBC   #HITDY0
        CMP   #HITDY
        BCS   .hen
        LDA   SCR+SHX,X
        SEC
        SBC   {1},Y
        CMP   #HITDX
        BCC   .xok
        CMP   #HITDX+8          ; the boss is 16 pixels wide
        BCS   .hen
        LDA   {3},Y
        AND   #$40
        BEQ   .hen
.xok    LDA   {1},Y
        BEQ   .hen
        LDA   {3},Y
        BMI   .hen              ; already exploding
        AND   #$40
        BEQ   .kill
        JSR   BossHit           ; boss: one hit point (C = 1 on the last one)
        BCC   .spent
.kill   LDA   {3},Y
        ORA   #$80              ; hit: enemy explodes, shot is spent
        STA   {4},Y
.spent  LDA   #0
        STA   SCW+SHY,X
        LDA   #$59              ; original hit sound
        STA   $A2
        JMP   {5}
.hen    DEY
        BPL   .he
    ENDM
HITDX   = 11            ; shot x - enemy x in 0..10
HITDY0  = 2             ; shot y - enemy y in 2..11
HITDY   = 10           ; zp: 8-way heading used by the original scroll code (alternates for odd headings)
AUTOF   = 8             ; frames between shots while fire is held

; ---------------------------------------------------------------- every frame, before LF346
DxPre   SUBROUTINE
        LDA   $80
        CMP   #2
        BNE   .idle
        BIT   $A0
        BMI   .idle
        LDA   $A4
        CMP   #$A0              ; exploding ($A0) or hidden ($B0)?
        BCC   .alive
.sync   LDA   $A3               ; follow the original's A3 (attract rotation, explosion flicker)
        STA   SDIR
        ASL
        STA   SCW+D16
        RTS
.idle   LDA   #0
        LDX   #NSHOT-1
.clr    STA   SCW+SHY,X
        DEX
        BPL   .clr
        LDX   #5                ; extra enemy slots
.clr2   STA   SCW+EX2,X
        DEX
        BPL   .clr2
        LDA   #$FF
        STA   SCW+SHOWN
        BNE   .sync
.alive  LDA   SCR+D16
        LSR
        CMP   $A3
        BEQ   .insync
        LDA   $A3               ; something else set A3 (new life): restart from it
        ASL
        STA   SCW+D16
.insync LDA   $81
        AND   #3
        BNE   .face
        LDA   SWCHA
        LDX   $93
        BNE   .p1
        LSR
        LSR
        LSR
        LSR
.p1     AND   #$0F
        TAX
        LDA   STK16,X
        BMI   .face             ; stick centred
        SEC
        SBC   SCR+D16
        AND   #$0F
        BEQ   .face
        LDX   #1
        CMP   #9
        BCC   .turn             ; 1-8 steps clockwise -> turn clockwise
        LDX   #$FF
.turn   TXA
        CLC
        ADC   SCR+D16
        AND   #$0F
        STA   SCW+D16
.face   LDX   SCR+D16
        TXA
        LSR
        STA   $A3               ; mirror flag (b2) and 8-way heading for the rest of the game
        LDA   FRLO,X
        STA   $A4               ; ship frame in page $D4
        TXA
        LSR
        BCC   .even
        LDA   $81               ; odd heading: alternate the two neighbouring 8-way scroll headings
        AND   #8
        BEQ   .even0
        INX
.even0  TXA
        LSR
        AND   #7
        STA   SDIR
        RTS
.even   STA   SDIR
        RTS

; ---------------------------------------------------------------- play state, right after LF3DC (hit test)
; returns A = sound to start on channel 0 (0 = none)
DxShot  SUBROUTINE
        ; ---- software hit test: every live shot against every enemy (box from the original's hits)
        LDA   #0
        STA   $A2               ; sound to return
        LDA   $81               ; every other frame (shots move 2 px/frame, the box is 11 x 10)
        LSR
        BCC   .hgo
        JMP   .hdone
.hgo    LDX   #NSHOT-1
.hs     LDA   SCR+SHY,X
        BNE   .hlive
        JMP   HitNx
.hlive  LDY   #NENEMY-1
        HITG  ENX, ENY, ENS, ENS, HitNx
        LDY   #NEX-1
        HITG  SCR+EX2, SCR+EY2, SCR+ES2, SCW+ES2, HitNx
.hn
HitNx   DEX
        BMI   .hdone
        JMP   .hs
.hdone
.move   LDX   #NSHOT-1
.mv     LDA   SCR+SHY,X
        BEQ   .next
        LDY   SCR+SHD,X
        CLC
        ADC   SHDY,Y
        CMP   #$8F
        BCS   .kill
        CMP   #2
        BCC   .kill
        STA   SCW+SHY,X
        LDA   SCR+SHX,X
        CLC
        ADC   SHDX,Y
        CMP   #$92
        BCS   .kill
        CMP   #2
        BCC   .kill
        STA   SCW+SHX,X
        BCS   .next
.kill   LDA   #0
        STA   SCW+SHY,X
.next   DEX
        BPL   .mv
        ; ---- fire (autofire while held)
        LDX   $93
        LDA   INPT4,X
        BPL   .held
        LDA   #0
        STA   SCW+FIRET         ; released: next press fires at once
        BEQ   .show
.held   LDA   SCR+FIRET
        BEQ   .shoot
        SEC
        SBC   #1
        STA   SCW+FIRET
        JMP   .show
.shoot  LDX   #NSHOT-1
.find   LDA   SCR+SHY,X
        BEQ   .free
        DEX
        BPL   .find
        BMI   .show             ; all shots in flight
.free   LDY   SCR+D16
        TYA
        STA   SCW+SHD,X
        LDA   SHSX,Y
        STA   SCW+SHX,X
        LDA   SHSY,Y
        STA   SCW+SHY,X
        LDA   #AUTOF
        STA   SCW+FIRET
        LDA   $A2
        BNE   .show             ; a hit sound wins over the shot sound
        LDA   #$5F              ; original shot sound
        STA   $A2
        ; ---- pick the next shot to draw (round robin over live shots)
.show
        LDX   SCR+SHOWN
        LDY   #NSHOT
.pick   INX
        CPX   #NSHOT
        BCC   .chk
        LDX   #0
.chk    LDA   SCR+SHY,X
        BNE   .draw
        DEY
        BNE   .pick
        LDX   #$FF              ; nothing to draw
        LDA   #0
        STA   $C9
        STA   $CA
        BEQ   .done
.draw   STA   $CB
        STA   $CC
        LDA   SCR+SHX,X
        STA   $C9
        STA   $CA
        LDA   $CB
.done   STA   $CB
        STA   $CC
        STX   SCW+SHOWN
        LDA   $A2
        RTS

; ---- ship vs enemies / enemy bullets (replaces the hardware test at LF298); A = 1 if the ship is hit
DxShip  SUBROUTINE
        LDY   #NENEMY-1
.e      LDA   ENX,Y
        BEQ   .n
        LDA   ENS,Y
        BMI   .n
        LDA   ENX,Y
        SEC
        SBC   #60
        CMP   #32               ; enemy x 68..91 (range of the original's hardware hits); boss from 60
        BCS   .n
        CMP   #8
        BCS   .xin
        LDA   ENS,Y
        AND   #$40
        BEQ   .n
.xin
        LDA   ENY,Y
        SEC
        SBC   #49
        CMP   #28               ; enemy y 49..76
        BCS   .n
        LDA   ENS,Y             ; the plane that rammed the ship explodes too (the boss survives)
        AND   #$40
        BNE   .rb
        LDA   ENS,Y
        ORA   #$80
        STA   ENS,Y
.rb     LDA   #1
        RTS
.n      DEY
        BPL   .e
        LDY   #NEX-1
.e2     LDA   SCR+EX2,Y
        BEQ   .n2
        SEC
        SBC   #68
        CMP   #24
        BCS   .n2
        LDA   SCR+ES2,Y
        BMI   .n2
        LDA   SCR+EY2,Y
        SEC
        SBC   #49
        CMP   #28
        BCS   .n2
        LDA   SCR+ES2,Y
        ORA   #$80
        STA   SCW+ES2,Y
        LDA   #1
        RTS
.n2     DEY
        BPL   .e2
        LDX   #1
.b      LDA   $DA,X             ; enemy bullet y (0 = none)
        BEQ   .bn
        SEC
        SBC   #63
        CMP   #16               ; y 63..78
        BCS   .bn
        LDA   $D8,X
        SEC
        SBC   #76
        CMP   #10               ; x 76..85
        BCS   .bn
        LDA   #1
        RTS
.bn     DEX
        BPL   .b
        LDA   #0
        RTS

; ---- a shot hit the era boss: lose a hit point and blink; C = 1 when it should explode
BossHit SUBROUTINE
        LDA   SCR+BOSSHP
        CMP   #2
        BCC   .dead
        SBC   #1
        STA   SCW+BOSSHP
        LDA   #12
        STA   SCW+BOSSFL
        CLC
        RTS
.dead   LDA   #0                ; killed: the next era's boss gets full hit points
        STA   SCW+BOSSHP
        SEC
        RTS
