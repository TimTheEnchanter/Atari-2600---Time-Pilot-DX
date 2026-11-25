; Time Pilot DX - bank 2 part of the cloud precompute
; ---- vblank, after LF346: hand the cloud bases to bank 3, which precomputes PF1N/PF2N
DxCloudC SUBROUTINE
        LDY   $E5
        LDA   LFF2A,Y
        STA   SCW+CLB1
        LDA   LFC80,Y
        STA   SCW+CLH1
        LDA   LFF3F,Y
        STA   SCW+CLB2
        LDA   LFF00,Y
        STA   SCW+CLH2
        LDX   #0
        JMP   CALL3
