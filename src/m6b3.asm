; Time Pilot DX - M6 formations (bank 3, in the dead warp-kernel copy $D355-$D3FF).
; On every spawn tick (every 64 frames) that finds both Superchip slots and a zero-page slot free, when the flock flies sideways, three planes come in together as a V: a leader in a free
; zero-page slot and two wingmen in the Superchip slots one band above and below, 12 pixels behind.
; Called by DxEnemy on its spawn tick instead of the single extra spawn; C = 1 when a formation was launched.
; Uses $F3-$F4 (its return address is at $F5-$F6, so no JSRs in here); $F2 = flock heading (set by DxEnemy).
FormSpawn SUBROUTINE
        LDA   SCR+BOSSHP
        BNE   .no
        LDA   $96
        CMP   #3                ; not right before the boss
        BCC   .no
        LDA   SCR+EX2
        ORA   SCR+EX2+1
        BNE   .no
        LDA   $F2
        AND   #3
        BEQ   .no               ; heading straight up or down
        LDY   #NENEMY-1
.fz     LDA   ENX,Y
        ORA   ENY,Y
        BEQ   .gotz
        DEY
        BPL   .fz
.no     CLC
        RTS
.gotz   STY   $F3
        LDA   $82               ; leader's band 2-5
        AND   #3
        CLC
        ADC   #2
        STA   $F4
        TAX                     ; the three bands need a free sprite each
        DEX
        LDY   #2
.fb     LDA   $BF,X
        BEQ   .fbn
        LDA   SCR+P0HM,X
        LSR
        BCS   .no
.fbn    INX
        DEY
        BPL   .fb
        LDY   $F3               ; leader
        LDA   $F4
        ASL                     ; band -> y (as LF60C)
        ASL
        ASL
        ASL
        ORA   #1
        STA   ENY,Y
        LDA   $F2
        STA   ENS,Y
        LDX   #14
        CMP   #4
        BCC   .lx
        LDX   #$85
.lx     TXA
        STA   ENX,Y
        LDX   #1                ; wingmen: slot 0 one band up, slot 1 one band down
.w      LDA   $F4
        CPX   #0
        BNE   .wd
        CLC
        ADC   #2
.wd     SEC
        SBC   #1
        ASL                     ; band -> y (as LF60C)
        ASL
        ASL
        ASL
        ORA   #1
        STA   SCW+EY2,X
        LDA   $F2
        STA   SCW+ES2,X
        LDY   #2
        CMP   #4
        BCC   .wx
        LDY   #$91
.wx     TYA
        STA   SCW+EX2,X
        DEX
        BPL   .w
        SEC
        RTS
