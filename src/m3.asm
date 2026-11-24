; Time Pilot DX - M3: 16-direction ship and 3 player shots (bank 2)
; Superchip RAM offsets
D16     = $20           ; ship heading 0-15 (0 = up, clockwise)
SHD     = $21           ; shot heading x3
SHX     = $24           ; shot X x3
SHY     = $27           ; shot Y x3 (0 = free)
SHOWN   = $2A           ; shot drawn last frame ($FF = none)
FIRET   = $2B           ; autofire countdown
NSHOT   = 3
SDIR    = $9E           ; zp: 8-way heading used by the original scroll code (alternates for odd headings)
AUTOF   = 8             ; frames between shots while fire is held

; ---------------------------------------------------------------- every frame, before LF346
DxPre   LDA   $80
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
DxShot  LDX   SCR+SHOWN
        BMI   .move
        LDA   $CB               ; LF3DC clears $C9-$CC when the drawn shot hits an enemy
        BNE   .move
        STA   SCW+SHY,X
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
        LDY   #0                ; sound to return
        LDX   $93
        LDA   INPT4,X
        BPL   .held
        STY   SCW+FIRET         ; released: next press fires at once
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
        LDY   #$5F              ; original shot sound
        ; ---- pick the next shot to draw (round robin over live shots)
.show   STY   $A2
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
