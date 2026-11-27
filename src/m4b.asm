; Time Pilot DX - M4b: two extra enemy slots in Superchip RAM (bank 2). Same flock heading, speeds, scroll,
; explosion timing and scoring as the original four; they move on a different frame phase (spreads the CPU).
; Runs in vblank after LF346 (bank 0 DXPRE -> bank 2 stub -> bank 3). Scratch $F2-$F4 (the stack is deeper here). Returns A = number of kills to score (1 BCD each).
DxEnemy SUBROUTINE
        LDA   #0
        STA   $A2
        LDA   $80
        CMP   #2
        BNE   .outj
        BIT   $A0
        BPL   .play
.outj   JMP   .out
.play
        ; ---- era boss: hit points on arrival, a straight heading, hit-blink countdown
        LDX   #NENEMY-1
.fb     LDA   ENS,X
        AND   #$40
        BNE   .fbg
        DEX
        BPL   .fb
        LDA   #0                ; no boss on screen (M8: its hit points survive a lost life)
        STA   SCW+BOSSDIR
        BEQ   .fl
.fbg    LDA   ENS,X
        BMI   .fl               ; exploding: leave it alone
        LDA   SCR+BOSSDIR
        BNE   .bh
        LDA   SCR+BOSSHP        ; boss (re)appears: fresh hit points only if the last one was killed
        BNE   .keep
        LDY   $95               ; hit points by era; heads across from the side it entered
        LDA   BOSSHPT,Y
        STA   SCW+BOSSHP
.keep
        LDA   #J_BOSS           ; M7: warning siren on channel 1 (as LF099; DXPRE brings the drone back)
        STA   $98
        LDA   #0
        STA   $9A
        STA   AUDV1
        LDA   ENX,X
        CMP   #$50
        LDA   #2
        BCC   .bd
        LDA   #6
.bd     STA   SCW+BOSSDIR
.bh     LDA   ENS,X
        AND   #$F8
        ORA   SCR+BOSSDIR
        STA   ENS,X
        LDA   SCR+BOSSFL
        BEQ   .fl
        SEC
        SBC   #1
        STA   SCW+BOSSFL
        ; ---- common heading of the flock (LF53C turns the original four together; skip the boss)
.fl     LDX   #NENEMY-1
.fh     LDA   ENS,X
        AND   #$40
        BEQ   .fh1
        DEX
        BPL   .fh
        LDX   #0
.fh1    LDA   ENS,X
        AND   #7
        STA   $F2
        LDX   #NEX-1
.st     LDA   SCR+EX2,X
        BEQ   .stn
        LDA   SCR+ES2,X
        AND   #$F8
        ORA   $F2
        STA   SCW+ES2,X
.stn    DEX
        BPL   .st
        LDA   $81
        AND   #7
        CMP   #2                ; original four move on phase 4
        BNE   .nm
        JSR   .move
.nm     LDA   $81
        AND   #7
        CMP   #6                ; explosion step (same phase as LF776)
        BNE   .ne
        JSR   .expl
.ne     LDA   $81
        AND   #63
        CMP   #35               ; original spawns on 3
        BNE   .out
        JSR   FormSpawn         ; M6: now and then a V formation instead
        BCS   .out
        JSR   .spawn
.out    LDA   $A2
        RTS

.move   LDY   $95
        LDA   SPDOFF,Y
        STA   $F3
        LDX   #NEX-1
.mv     LDA   SCR+EX2,X
        BEQ   .mn
        LDA   SCR+ES2,X
        AND   #7
        CLC
        ADC   $F3
        TAY
        LDA   SCR+EX2,X
        CLC
        ADC   SPD,Y
        LDY   SDIR
        CLC
        ADC   T_SCX,Y           ; scroll against the ship's heading
        CMP   #$F0              ; horizontal wrap exactly as LF67E
        BCC   .w1
        LDA   #$91
.w1     CMP   #$92
        BCC   .w2
        LDA   #2
.w2     CMP   #2
        BCS   .w3
        LDA   #$91
.w3     STA   SCW+EX2,X
        LDA   SCR+ES2,X
        AND   #7
        ORA   #8
        CLC
        ADC   $F3
        TAY
        LDA   SCR+EY2,X
        CLC
        ADC   SPD,Y
        LDY   SDIR
        CLC
        ADC   T_SCY,Y
        CMP   #$F0              ; off the bottom: re-enter at the top
        BCC   .y1
        LDA   #$8E
.y1     CMP   #$8F              ; off the top: re-enter at the bottom
        BCC   .y2
        LDA   #2
.y2     CMP   #2
        BCS   .y3
        LDA   #$8E
.y3     STA   SCW+EY2,X
        JMP   .mn
.del    LDA   #0
        STA   SCW+EX2,X
        STA   SCW+EY2,X
        STA   SCW+ES2,X
.mn     DEX
        BPL   .mv
        RTS

.expl   LDX   #NEX-1
.ex     LDA   SCR+ES2,X
        BPL   .xn
        TAY
        CLC
        ADC   #$10              ; explosion timer in bits 4-5, as LF776
        AND   #$30
        BEQ   .fin
        STA   $F4
        TYA
        AND   #$CF
        ORA   $F4
        STA   SCW+ES2,X
        JMP   .xn
.fin    LDA   #0
        STA   SCW+EX2,X
        STA   SCW+EY2,X
        STA   SCW+ES2,X
        LDA   $96               ; counts toward the era quota
        BEQ   .q0
        DEC   $96
.q0     INC   $A2
.xn     DEX
        BPL   .ex
        RTS

.spawn  LDX   #NEX-1
.sf     LDA   SCR+EX2,X
        BEQ   .free
        DEX
        BPL   .sf
        RTS
.free   LDA   $82               ; random band 1..7 that still has a free sprite
        AND   #7
        BNE   .b1
        LDA   #4
.b1     TAY
        LDA   $00BF,Y
        BEQ   .ok
        LDA   SCR+P0HM,Y
        LSR
        BCS   .no
.ok     TYA
        ASL
        ASL
        ASL
        ASL
        ORA   #1
        STA   SCW+EY2,X
        LDA   $F2
        STA   SCW+ES2,X
        LDY   #2                ; heading right: enter on the left edge, else the right (as LF60C)
        CMP   #4
        BCC   .sx
        LDY   #$91
.sx     TYA
        STA   SCW+EX2,X
.no     RTS
