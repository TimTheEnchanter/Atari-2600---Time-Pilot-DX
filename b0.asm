; bank 0 org $F000
    processor 6502
VSYNC    = $00
VBLANK   = $01
WSYNC    = $02
RSYNC    = $03
NUSIZ0   = $04
NUSIZ1   = $05
COLUP0   = $06
COLUP1   = $07
COLUPF   = $08
COLUBK   = $09
CTRLPF   = $0A
REFP0    = $0B
REFP1    = $0C
PF0      = $0D
PF1      = $0E
PF2      = $0F
RESP0    = $10
RESP1    = $11
RESM0    = $12
RESM1    = $13
RESBL    = $14
AUDC0    = $15
AUDC1    = $16
AUDF0    = $17
AUDF1    = $18
AUDV0    = $19
AUDV1    = $1A
GRP0     = $1B
GRP1     = $1C
ENAM0    = $1D
ENAM1    = $1E
ENABL    = $1F
HMP0     = $20
HMP1     = $21
HMM0     = $22
HMM1     = $23
HMBL     = $24
VDELP0   = $25
VDELP1   = $26
VDELBL   = $27
RESMP0   = $28
RESMP1   = $29
HMOVE    = $2A
HMCLR    = $2B
CXCLR    = $2C
CXM0P    = $00
CXM1P    = $01
CXP0FB   = $02
CXP1FB   = $03
CXM0FB   = $04
CXM1FB   = $05
CXBLPF   = $06
CXPPMM   = $07
INPT0    = $08
INPT1    = $09
INPT2    = $0A
INPT3    = $0B
INPT4    = $0C
INPT5    = $0D
SWCHA    = $0280
SWACNT   = $0281
SWCHB    = $0282
SWBCNT   = $0283
INTIM    = $0284
TIMINT   = $0285
TIM1T    = $0294
TIM8T    = $0295
TIM64T   = $0296
T1024T   = $0297
    ORG $0000
    RORG $F000
LF000   NOP                         ; F000 EA
        BIT   $FFF9                 ; F001 2C F9 FF
        BIT   $FFF9                 ; F004 2C F9 FF
        NOP                         ; F007 EA
        NOP                         ; F008 EA
        NOP                         ; F009 EA
        NOP                         ; F00A EA
        NOP                         ; F00B EA
        NOP                         ; F00C EA
        NOP                         ; F00D EA
        NOP                         ; F00E EA
        NOP                         ; F00F EA
        NOP                         ; F010 EA
        NOP                         ; F011 EA
        JMP   ($FFFE)               ; F012 6C FE FF
LF015   LDY   $80                   ; F015 A4 80
        BNE   LF01A                 ; F017 D0 01
        INY                         ; F019 C8
LF01A   CLD                         ; F01A D8
        LDX   #$FF                  ; F01B A2 FF
        TXS                         ; F01D 9A
        INX                         ; F01E E8
        TXA                         ; F01F 8A
LF020   STA   VSYNC,X               ; F020 95 00
        INX                         ; F022 E8
        BNE   LF020                 ; F023 D0 FB
        STY   $82                   ; F025 84 82
LF027   LDX   INTIM                 ; F027 AE 84 02
        BNE   LF027                 ; F02A D0 FB
        LDA   #$02                  ; F02C A9 02
        STX   WSYNC                 ; F02E 86 02
        STA   VBLANK                ; F030 85 01
        LDA   #$24                  ; F032 A9 24
        STA   TIM64T                ; F034 8D 96 02
        INC   $81                   ; F037 E6 81
        DEX                         ; F039 CA
        TXS                         ; F03A 9A
        LDA   $82                   ; F03B A5 82
        ASL                         ; F03D 0A
        ASL                         ; F03E 0A
        ASL                         ; F03F 0A
        EOR   $82                   ; F040 45 82
        ASL                         ; F042 0A
        ROL   $82                   ; F043 26 82
        JSR   LF0AB                 ; F045 20 AB F0
        LDA   #$02                  ; F048 A9 02
LF04A   LDX   INTIM                 ; F04A AE 84 02
        BNE   LF04A                 ; F04D D0 FB
        STX   WSYNC                 ; F04F 86 02
        STA   VSYNC                 ; F051 85 00
        STX   WSYNC                 ; F053 86 02
        STX   WSYNC                 ; F055 86 02
        LDA   #$2A                  ; F057 A9 2A
        STX   WSYNC                 ; F059 86 02
        STX   VSYNC                 ; F05B 86 00
        STA   TIM64T                ; F05D 8D 96 02
        JSR   LF346                 ; F060 20 46 F3
LF063   LDX   INTIM                 ; F063 AE 84 02
        BNE   LF063                 ; F066 D0 FB
        JMP   LF8E6                 ; F068 4C E6 F8
LF06B   LDY   $82                   ; F06B A4 82
        LDA   #$00                  ; F06D A9 00
LF06F   STA   VSYNC,X               ; F06F 95 00
        INX                         ; F071 E8
        CPX   #$A3                  ; F072 E0 A3
        BCC   LF06F                 ; F074 90 F9
        STY   $82                   ; F076 84 82
        STA   AUDV0                 ; F078 85 19
        STA   AUDV1                 ; F07A 85 1A
        RTS                         ; F07C 60
LF07D   LDX   #$4E                  ; F07D A2 4E
        LDA   #$00                  ; F07F A9 00
LF081   STA   $A3,X                 ; F081 95 A3
        DEX                         ; F083 CA
        BPL   LF081                 ; F084 10 FB
        LDA   #$06                  ; F086 A9 06
        STA   $A3                   ; F088 85 A3
        LDA   #$4C                  ; F08A A9 4C
        STA   $A4                   ; F08C 85 A4
        LDA   #$0D                  ; F08E A9 0D
        STA   $E5                   ; F090 85 E5
        LDA   #$0C                  ; F092 A9 0C
        STA   $EB                   ; F094 85 EB
        STA   $EF                   ; F096 85 EF
        RTS                         ; F098 60
LF099   STA   $97,X                 ; F099 95 97
        LDA   #$00                  ; F09B A9 00
        STA   $99,X                 ; F09D 95 99
        STA   AUDV0,X               ; F09F 95 19
        RTS                         ; F0A1 60
LF0A2   LDA   #$00                  ; F0A2 A9 00
        STA   $97,X                 ; F0A4 95 97
        STA   $99,X                 ; F0A6 95 99
        STA   AUDV0,X               ; F0A8 95 19
        RTS                         ; F0AA 60
LF0AB   LDX   #$00                  ; F0AB A2 00
        LDA   SWCHA                 ; F0AD AD 80 02
        EOR   #$FF                  ; F0B0 49 FF
        BEQ   LF0B8                 ; F0B2 F0 04
        STX   $83                   ; F0B4 86 83
        BNE   LF0CE                 ; F0B6 D0 16
LF0B8   LDA   $81                   ; F0B8 A5 81
        BNE   LF0CE                 ; F0BA D0 12
        BIT   $83                   ; F0BC 24 83
        BMI   LF0CE                 ; F0BE 30 0E
        INC   $83                   ; F0C0 E6 83
        BPL   LF0CE                 ; F0C2 10 0A
        LDA   $80                   ; F0C4 A5 80
        BEQ   LF0CE                 ; F0C6 F0 06
        LDA   #$00                  ; F0C8 A9 00
        STA   $80                   ; F0CA 85 80
        STA   $A1                   ; F0CC 85 A1
LF0CE   LDA   SWCHB                 ; F0CE AD 82 02
        AND   #$03                  ; F0D1 29 03
        TAX                         ; F0D3 AA
        EOR   #$03                  ; F0D4 49 03
        AND   $85                   ; F0D6 25 85
        STX   $85                   ; F0D8 86 85
        AND   #$01                  ; F0DA 29 01
        BEQ   LF0E1                 ; F0DC F0 03
        JSR   LF111                 ; F0DE 20 11 F1
LF0E1   BIT   $A0                   ; F0E1 24 A0
        BPL   LF0F2                 ; F0E3 10 0D
        LDA   $81                   ; F0E5 A5 81
        BNE   LF10D                 ; F0E7 D0 24
        LDA   $93                   ; F0E9 A5 93
        EOR   $86                   ; F0EB 45 86
        STA   $93                   ; F0ED 85 93
        JMP   LF10D                 ; F0EF 4C 0D F1
LF0F2   LDA   $80                   ; F0F2 A5 80
        CMP   #$00                  ; F0F4 C9 00
        BNE   LF0FB                 ; F0F6 D0 03
        JSR   LF156                 ; F0F8 20 56 F1
LF0FB   LDA   $80                   ; F0FB A5 80
        CMP   #$02                  ; F0FD C9 02
        BNE   LF104                 ; F0FF D0 03
        JSR   LF276                 ; F101 20 76 F2
LF104   LDA   $80                   ; F104 A5 80
        CMP   #$01                  ; F106 C9 01
        BNE   LF10D                 ; F108 D0 03
        JSR   LF1A6                 ; F10A 20 A6 F1
LF10D   JSR   LF2E6                 ; F10D 20 E6 F2
        RTS                         ; F110 60
LF111   LDA   #$00                  ; F111 A9 00
        STA   $83                   ; F113 85 83
        STA   $84                   ; F115 85 84
        STA   $88                   ; F117 85 88
        LDA   SWCHB                 ; F119 AD 82 02
        ROL                         ; F11C 2A
        ROL                         ; F11D 2A
        ROL                         ; F11E 2A
        AND   #$03                  ; F11F 29 03
        TAY                         ; F121 A8
        LDA   LF152,Y               ; F122 B9 52 F1
        STA   $87                   ; F125 85 87
        TAY                         ; F127 A8
        LDX   #$00                  ; F128 A2 00
        CMP   #$03                  ; F12A C9 03
        BCC   LF12F                 ; F12C 90 01
        INX                         ; F12E E8
LF12F   STX   $86                   ; F12F 86 86
LF131   LDA   $87                   ; F131 A5 87
        STA   $89,X                 ; F133 95 89
        LDA   #$05                  ; F135 A9 05
        STA   $8B,X                 ; F137 95 8B
        LDA   #$00                  ; F139 A9 00
        STA   $8D,X                 ; F13B 95 8D
        STA   $8F,X                 ; F13D 95 8F
        LDA   LF272,Y               ; F13F B9 72 F2
        STA   $91,X                 ; F142 95 91
        DEX                         ; F144 CA
        BPL   LF131                 ; F145 10 EA
        LDA   #$01                  ; F147 A9 01
        STA   $80                   ; F149 85 80
        LDA   #$00                  ; F14B A9 00
        STA   $A0                   ; F14D 85 A0
        STA   $93                   ; F14F 85 93
        RTS                         ; F151 60
LF152   .byte $00,$02,$01,$03                     ; F152
LF156   LDA   $A1                   ; F156 A5 A1
        BNE   LF174                 ; F158 D0 1A
        LDX   #$80                  ; F15A A2 80
        JSR   LF06B                 ; F15C 20 6B F0
        LDA   #$2D                  ; F15F A9 2D
        STA   $A1                   ; F161 85 A1
        LDA   #$00                  ; F163 A9 00
        STA   $95                   ; F165 85 95
        JSR   LF07D                 ; F167 20 7D F0
        LDX   #$00                  ; F16A A2 00
        LDA   #$01                  ; F16C A9 01
        JSR   LF099                 ; F16E 20 99 F0
        JMP   LF1A5                 ; F171 4C A5 F1
LF174   LDA   $84                   ; F174 A5 84
        BEQ   LF17E                 ; F176 F0 06
        CMP   #$18                  ; F178 C9 18
        BCC   LF182                 ; F17A 90 06
        BCS   LF18E                 ; F17C B0 10
LF17E   LDA   $81                   ; F17E A5 81
        BPL   LF1A5                 ; F180 10 23
LF182   LDA   $81                   ; F182 A5 81
        AND   #$03                  ; F184 29 03
        BNE   LF1A5                 ; F186 D0 1D
        DEC   $A1                   ; F188 C6 A1
        INC   $84                   ; F18A E6 84
        BNE   LF1A5                 ; F18C D0 17
LF18E   LDA   $81                   ; F18E A5 81
        AND   #$03                  ; F190 29 03
        BNE   LF1A5                 ; F192 D0 11
        INC   $84                   ; F194 E6 84
        BPL   LF1A5                 ; F196 10 0D
        LDA   #$2D                  ; F198 A9 2D
        STA   $A1                   ; F19A 85 A1
        LDA   #$00                  ; F19C A9 00
        STA   $84                   ; F19E 85 84
        STA   $81                   ; F1A0 85 81
        JSR   LF338                 ; F1A2 20 38 F3
LF1A5   RTS                         ; F1A5 60
LF1A6   LDA   $84                   ; F1A6 A5 84
        BNE   LF1CE                 ; F1A8 D0 24
        LDX   $93                   ; F1AA A6 93
        LDA   $89,X                 ; F1AC B5 89
        BMI   LF1CE                 ; F1AE 30 1E
        LDX   #$94                  ; F1B0 A2 94
        JSR   LF06B                 ; F1B2 20 6B F0
        LDX   $93                   ; F1B5 A6 93
        LDA   $89,X                 ; F1B7 B5 89
        AND   #$03                  ; F1B9 29 03
        STA   $94                   ; F1BB 85 94
        LDA   $8B,X                 ; F1BD B5 8B
        LSR                         ; F1BF 4A
        LSR                         ; F1C0 4A
        LSR                         ; F1C1 4A
        LSR                         ; F1C2 4A
        AND   #$07                  ; F1C3 29 07
        STA   $95                   ; F1C5 85 95
        LDA   $91,X                 ; F1C7 B5 91
        STA   $96                   ; F1C9 85 96
        JSR   LF07D                 ; F1CB 20 7D F0
LF1CE   INC   $84                   ; F1CE E6 84
        BMI   LF1D5                 ; F1D0 30 03
        JMP   LF271                 ; F1D2 4C 71 F2
LF1D5   LDX   $93                   ; F1D5 A6 93
        LDA   $89,X                 ; F1D7 B5 89
        BMI   LF202                 ; F1D9 30 27
        AND   #$BF                  ; F1DB 29 BF
        ORA   #$80                  ; F1DD 09 80
        STA   $89,X                 ; F1DF 95 89
        LDA   $8B,X                 ; F1E1 B5 8B
        AND   #$07                  ; F1E3 29 07
        BEQ   LF237                 ; F1E5 F0 50
        DEC   $8B,X                 ; F1E7 D6 8B
        LDY   $95                   ; F1E9 A4 95
        LDA   LFDE0,Y               ; F1EB B9 E0 FD
        LDX   #$01                  ; F1EE A2 01
        JSR   LF099                 ; F1F0 20 99 F0
        LDA   #$00                  ; F1F3 A9 00
        STA   $A2                   ; F1F5 85 A2
        STA   $84                   ; F1F7 85 84
        STA   $9D                   ; F1F9 85 9D
        STA   $88                   ; F1FB 85 88
        INC   $80                   ; F1FD E6 80
        JMP   LF271                 ; F1FF 4C 71 F2
LF202   AND   #$7F                  ; F202 29 7F
        STA   $89,X                 ; F204 95 89
        AND   #$40                  ; F206 29 40
        BEQ   LF237                 ; F208 F0 2D
        LDA   $95                   ; F20A A5 95
        CLC                         ; F20C 18
        ADC   #$01                  ; F20D 69 01
        CMP   #$05                  ; F20F C9 05
        BCC   LF215                 ; F211 90 02
        LDA   #$00                  ; F213 A9 00
LF215   ASL                         ; F215 0A
        ASL                         ; F216 0A
        ASL                         ; F217 0A
        ASL                         ; F218 0A
        STA   $A2                   ; F219 85 A2
        LDA   $8B,X                 ; F21B B5 8B
        AND   #$0F                  ; F21D 29 0F
        ORA   $A2                   ; F21F 05 A2
        STA   $8B,X                 ; F221 95 8B
        LDY   $87                   ; F223 A4 87
        LDA   LF272,Y               ; F225 B9 72 F2
        STA   $91,X                 ; F228 95 91
        BIT   $88                   ; F22A 24 88
        BMI   LF237                 ; F22C 30 09
        INC   $8B,X                 ; F22E F6 8B
        LDA   #$00                  ; F230 A9 00
        STA   $84                   ; F232 85 84
        JMP   LF271                 ; F234 4C 71 F2
LF237   LDA   #$00                  ; F237 A9 00
        STA   $88                   ; F239 85 88
        LDA   $8B                   ; F23B A5 8B
        ORA   $8C                   ; F23D 05 8C
        AND   #$07                  ; F23F 29 07
        BNE   LF260                 ; F241 D0 1D
        LDA   #$00                  ; F243 A9 00
        STA   $A1                   ; F245 85 A1
        STA   $84                   ; F247 85 84
        STA   $83                   ; F249 85 83
        LDX   #$01                  ; F24B A2 01
        JSR   LF0A2                 ; F24D 20 A2 F0
        DEX                         ; F250 CA
        LDA   #$01                  ; F251 A9 01
        JSR   LF099                 ; F253 20 99 F0
        LDA   #$02                  ; F256 A9 02
        STA   $80                   ; F258 85 80
        LDA   #$FF                  ; F25A A9 FF
        STA   $A0                   ; F25C 85 A0
        BMI   LF271                 ; F25E 30 11
LF260   LDA   $93                   ; F260 A5 93
        EOR   $86                   ; F262 45 86
        STA   $93                   ; F264 85 93
        TAX                         ; F266 AA
        LDA   $8B,X                 ; F267 B5 8B
        AND   #$07                  ; F269 29 07
        BEQ   LF260                 ; F26B F0 F3
        LDA   #$00                  ; F26D A9 00
        STA   $84                   ; F26F 85 84
LF271   RTS                         ; F271 60
LF272   .byte $08,$10,$18,$18                     ; F272
LF276   LDA   $A4                   ; F276 A5 A4
        CMP   #$7C                  ; F278 C9 7C
        BNE   LF298                 ; F27A D0 1C
        INC   $84                   ; F27C E6 84
        LDA   $84                   ; F27E A5 84
        CMP   #$40                  ; F280 C9 40
        BCC   LF2E5                 ; F282 90 61
        LDA   #$8C                  ; F284 A9 8C
        STA   $A4                   ; F286 85 A4
        LDX   $93                   ; F288 A6 93
        LDA   $96                   ; F28A A5 96
        STA   $91,X                 ; F28C 95 91
        LDA   #$00                  ; F28E A9 00
        STA   $84                   ; F290 85 84
        LDA   #$01                  ; F292 A9 01
        STA   $80                   ; F294 85 80
        BNE   LF2E5                 ; F296 D0 4D
LF298   LDA   CXM1P                 ; F298 A5 01
        ORA   CXPPMM                ; F29A 05 07
        BPL   LF2E5                 ; F29C 10 47
        BIT   CXPPMM                ; F29E 24 07
        BPL   LF2AC                 ; F2A0 10 0A
        LDA   $C3                   ; F2A2 A5 C3
        CMP   #$97                  ; F2A4 C9 97
        BCC   LF2AC                 ; F2A6 90 04
        CMP   #$B7                  ; F2A8 C9 B7
        BCC   LF2E5                 ; F2AA 90 39
LF2AC   LDA   #$7C                  ; F2AC A9 7C
        STA   $A4                   ; F2AE 85 A4
        LDX   #$00                  ; F2B0 A2 00
        LDA   #$59                  ; F2B2 A9 59
        JSR   LF099                 ; F2B4 20 99 F0
        LDA   #$00                  ; F2B7 A9 00
        STA   $84                   ; F2B9 85 84
        LDA   #$00                  ; F2BB A9 00
        LDX   #$01                  ; F2BD A2 01
LF2BF   STA   $D8,X                 ; F2BF 95 D8
        STA   $DA,X                 ; F2C1 95 DA
        DEX                         ; F2C3 CA
        BPL   LF2BF                 ; F2C4 10 F9
        BIT   CXPPMM                ; F2C6 24 07
        BPL   LF2E5                 ; F2C8 10 1B
        LDX   #$03                  ; F2CA A2 03
LF2CC   LDA   $A9,X                 ; F2CC B5 A9
        LSR                         ; F2CE 4A
        LSR                         ; F2CF 4A
        LSR                         ; F2D0 4A
        LSR                         ; F2D1 4A
        CMP   #$03                  ; F2D2 C9 03
        BCC   LF2E2                 ; F2D4 90 0C
        CMP   #$05                  ; F2D6 C9 05
        BCS   LF2E2                 ; F2D8 B0 08
        LDA   $AD,X                 ; F2DA B5 AD
        ORA   #$80                  ; F2DC 09 80
        STA   $AD,X                 ; F2DE 95 AD
        BMI   LF2E5                 ; F2E0 30 03
LF2E2   DEX                         ; F2E2 CA
        BPL   LF2CC                 ; F2E3 10 E7
LF2E5   RTS                         ; F2E5 60
LF2E6   LDX   #$01                  ; F2E6 A2 01
LF2E8   LDY   $99,X                 ; F2E8 B4 99
        BNE   LF2F8                 ; F2EA D0 0C
LF2EC   LDY   $97,X                 ; F2EC B4 97
        BEQ   LF334                 ; F2EE F0 44
        LDA   LFF54,Y               ; F2F0 B9 54 FF
        STA   AUDC0,X               ; F2F3 95 15
        INY                         ; F2F5 C8
        BNE   LF303                 ; F2F6 D0 0B
LF2F8   LDA   $9B,X                 ; F2F8 B5 9B
        BEQ   LF303                 ; F2FA F0 07
        SEC                         ; F2FC 38
        SBC   #$01                  ; F2FD E9 01
        STA   $9B,X                 ; F2FF 95 9B
        BCS   LF334                 ; F301 B0 31
LF303   LDA   LFF54,Y               ; F303 B9 54 FF
        BEQ   LF331                 ; F306 F0 29
        CMP   #$FF                  ; F308 C9 FF
        BEQ   LF2EC                 ; F30A F0 E0
        CMP   #$80                  ; F30C C9 80
        BCC   LF31A                 ; F30E 90 0A
        AND   #$3F                  ; F310 29 3F
        STA   AUDF0,X               ; F312 95 17
        LDA   #$00                  ; F314 A9 00
        STA   AUDV0,X               ; F316 95 19
        BEQ   LF326                 ; F318 F0 0C
LF31A   STA   AUDF0,X               ; F31A 95 17
        LDA   #$0E                  ; F31C A9 0E
        CPX   #$00                  ; F31E E0 00
        BEQ   LF324                 ; F320 F0 02
        LDA   #$08                  ; F322 A9 08
LF324   STA   AUDV0,X               ; F324 95 19
LF326   INY                         ; F326 C8
        LDA   LFF54,Y               ; F327 B9 54 FF
        STA   $9B,X                 ; F32A 95 9B
        INY                         ; F32C C8
        STY   $99,X                 ; F32D 94 99
        BNE   LF334                 ; F32F D0 03
LF331   JSR   LF0A2                 ; F331 20 A2 F0
LF334   DEX                         ; F334 CA
        BPL   LF2E8                 ; F335 10 B1
        RTS                         ; F337 60
LF338   LDA   $95                   ; F338 A5 95
        CLC                         ; F33A 18
        ADC   #$01                  ; F33B 69 01
        CMP   #$05                  ; F33D C9 05
        BCC   LF343                 ; F33F 90 02
        LDA   #$00                  ; F341 A9 00
LF343   STA   $95                   ; F343 85 95
        RTS                         ; F345 60
LF346   BIT   $A0                   ; F346 24 A0
        BMI   LF3AD                 ; F348 30 63
        LDA   $80                   ; F34A A5 80
        CMP   #$01                  ; F34C C9 01
        BEQ   LF3AD                 ; F34E F0 5D
        BCC   LF355                 ; F350 90 03
        JSR   LF3DC                 ; F352 20 DC F3
LF355   LDA   $81                   ; F355 A5 81
        AND   #$07                  ; F357 29 07
        CMP   #$00                  ; F359 C9 00
        BNE   LF360                 ; F35B D0 03
        JSR   LF419                 ; F35D 20 19 F4
LF360   LDA   $81                   ; F360 A5 81
        AND   #$0F                  ; F362 29 0F
        CMP   #$01                  ; F364 C9 01
        BNE   LF36B                 ; F366 D0 03
        JSR   LF53C                 ; F368 20 3C F5
LF36B   LDA   $81                   ; F36B A5 81
        AND   #$07                  ; F36D 29 07
        CMP   #$02                  ; F36F C9 02
        BNE   LF376                 ; F371 D0 03
        JSR   LF59C                 ; F373 20 9C F5
LF376   LDA   $81                   ; F376 A5 81
        AND   #$3F                  ; F378 29 3F
        CMP   #$03                  ; F37A C9 03
        BNE   LF381                 ; F37C D0 03
        JSR   LF60C                 ; F37E 20 0C F6
LF381   LDA   $81                   ; F381 A5 81
        AND   #$07                  ; F383 29 07
        CMP   #$04                  ; F385 C9 04
        BNE   LF38C                 ; F387 D0 03
        JSR   LF67E                 ; F389 20 7E F6
LF38C   LDA   $81                   ; F38C A5 81
        AND   #$07                  ; F38E 29 07
        CMP   #$05                  ; F390 C9 05
        BNE   LF397                 ; F392 D0 03
        JSR   LF740                 ; F394 20 40 F7
LF397   LDA   $81                   ; F397 A5 81
        AND   #$07                  ; F399 29 07
        CMP   #$06                  ; F39B C9 06
        BNE   LF3A2                 ; F39D D0 03
        JSR   LF776                 ; F39F 20 76 F7
LF3A2   LDA   $81                   ; F3A2 A5 81
        AND   #$07                  ; F3A4 29 07
        CMP   #$07                  ; F3A6 C9 07
        BNE   LF3AD                 ; F3A8 D0 03
        JSR   LF59C                 ; F3AA 20 9C F5
LF3AD   JSR   LF813                 ; F3AD 20 13 F8
        LDY   $95                   ; F3B0 A4 95
        LDA   LFE3E,Y               ; F3B2 B9 3E FE
        STA   $E8                   ; F3B5 85 E8
        CPY   #$02                  ; F3B7 C0 02
        BEQ   LF3BF                 ; F3B9 F0 04
        CPY   #$04                  ; F3BB C0 04
        BNE   LF3C7                 ; F3BD D0 08
LF3BF   LDA   $81                   ; F3BF A5 81
        AND   #$08                  ; F3C1 29 08
        BEQ   LF3C7                 ; F3C3 F0 02
        INC   $E8                   ; F3C5 E6 E8
LF3C7   LDA   $80                   ; F3C7 A5 80
        CMP   #$01                  ; F3C9 C9 01
        BNE   LF3DB                 ; F3CB D0 0E
        LDX   $93                   ; F3CD A6 93
        LDA   $89,X                 ; F3CF B5 89
        AND   #$40                  ; F3D1 29 40
        BEQ   LF3DB                 ; F3D3 F0 06
        LDA   $85                   ; F3D5 A5 85
        ORA   #$80                  ; F3D7 09 80
        STA   $85                   ; F3D9 85 85
LF3DB   RTS                         ; F3DB 60
LF3DC   BIT   CXM0P                 ; F3DC 24 00
        BPL   LF418                 ; F3DE 10 38
        LDX   #$03                  ; F3E0 A2 03
LF3E2   LDA   $A5,X                 ; F3E2 B5 A5
        SEC                         ; F3E4 38
        SBC   $C9                   ; F3E5 E5 C9
        BPL   LF3EB                 ; F3E7 10 02
        EOR   #$FF                  ; F3E9 49 FF
LF3EB   CMP   #$0C                  ; F3EB C9 0C
        BCS   LF415                 ; F3ED B0 26
        LDA   $A9,X                 ; F3EF B5 A9
        SEC                         ; F3F1 38
        SBC   $CB                   ; F3F2 E5 CB
        BPL   LF3F8                 ; F3F4 10 02
        EOR   #$FF                  ; F3F6 49 FF
LF3F8   CMP   #$10                  ; F3F8 C9 10
        BCS   LF415                 ; F3FA B0 19
        LDA   $AD,X                 ; F3FC B5 AD
        ORA   #$80                  ; F3FE 09 80
        STA   $AD,X                 ; F400 95 AD
        LDA   #$59                  ; F402 A9 59
        LDX   #$00                  ; F404 A2 00
        JSR   LF099                 ; F406 20 99 F0
        LDA   #$00                  ; F409 A9 00
        STA   $C9                   ; F40B 85 C9
        STA   $CA                   ; F40D 85 CA
        STA   $CB                   ; F40F 85 CB
        STA   $CC                   ; F411 85 CC
        BEQ   LF418                 ; F413 F0 03
LF415   DEX                         ; F415 CA
        BPL   LF3E2                 ; F416 10 CA
LF418   RTS                         ; F418 60
LF419   LDA   $A4                   ; F419 A5 A4
        CMP   #$7C                  ; F41B C9 7C
        BCC   LF429                 ; F41D 90 0A
        LDA   $81                   ; F41F A5 81
        AND   #$08                  ; F421 29 08
        LSR                         ; F423 4A
        STA   $A3                   ; F424 85 A3
        JMP   LF4B6                 ; F426 4C B6 F4
LF429   LDY   $A3                   ; F429 A4 A3
        LDA   $80                   ; F42B A5 80
        CMP   #$02                  ; F42D C9 02
        BEQ   LF43C                 ; F42F F0 0B
        LDA   $81                   ; F431 A5 81
        BEQ   LF438                 ; F433 F0 03
        JMP   LF4B6                 ; F435 4C B6 F4
LF438   INY                         ; F438 C8
        JMP   LF469                 ; F439 4C 69 F4
LF43C   LDA   SWCHA                 ; F43C AD 80 02
        LDX   $93                   ; F43F A6 93
        BNE   LF447                 ; F441 D0 04
        LSR                         ; F443 4A
        LSR                         ; F444 4A
        LSR                         ; F445 4A
        LSR                         ; F446 4A
LF447   AND   #$0F                  ; F447 29 0F
        STA   $A2                   ; F449 85 A2
        CMP   #$0F                  ; F44B C9 0F
        BEQ   LF474                 ; F44D F0 25
        TAX                         ; F44F AA
        LDA   LFE2E,X               ; F450 BD 2E FE
        SEC                         ; F453 38
        SBC   $A3                   ; F454 E5 A3
        BEQ   LF474                 ; F456 F0 1C
        BPL   LF460                 ; F458 10 06
        CMP   #$FC                  ; F45A C9 FC
        BCC   LF466                 ; F45C 90 08
        BCS   LF468                 ; F45E B0 08
LF460   CMP   #$04                  ; F460 C9 04
        BCC   LF466                 ; F462 90 02
        BCS   LF468                 ; F464 B0 02
LF466   INY                         ; F466 C8
        INY                         ; F467 C8
LF468   DEY                         ; F468 88
LF469   TYA                         ; F469 98
        AND   #$07                  ; F46A 29 07
        STA   $A3                   ; F46C 85 A3
        TAY                         ; F46E A8
        LDA   LFECD,Y               ; F46F B9 CD FE
        STA   $A4                   ; F472 85 A4
LF474   LDA   $80                   ; F474 A5 80
        CMP   #$02                  ; F476 C9 02
        BNE   LF4B6                 ; F478 D0 3C
        LDX   $93                   ; F47A A6 93
        LDA   INPT4,X               ; F47C B5 0C
        BPL   LF486                 ; F47E 10 06
        LDA   #$00                  ; F480 A9 00
        STA   $9D                   ; F482 85 9D
        BEQ   LF4B6                 ; F484 F0 30
LF486   BIT   $9D                   ; F486 24 9D
        BMI   LF4B6                 ; F488 30 2C
        LDA   #$FF                  ; F48A A9 FF
        STA   $9D                   ; F48C 85 9D
        LDY   $A3                   ; F48E A4 A3
        STY   $C8                   ; F490 84 C8
        LDA   LF4A6,Y               ; F492 B9 A6 F4
        STA   $C9                   ; F495 85 C9
        LDA   LF4AE,Y               ; F497 B9 AE F4
        STA   $CB                   ; F49A 85 CB
        LDX   #$00                  ; F49C A2 00
        LDA   #$5F                  ; F49E A9 5F
        JSR   LF099                 ; F4A0 20 99 F0
        JMP   LF4B6                 ; F4A3 4C B6 F4
LF4A6   .byte $54,$5A,$5B,$5A,$54,$4F,$4E,$4E     ; F4A6
LF4AE   .byte $54,$50,$48,$40,$3E,$40,$48,$50     ; F4AE
LF4B6   LDX   $A3                   ; F4B6 A6 A3
        LDA   LFDE5,X               ; F4B8 BD E5 FD
        CLC                         ; F4BB 18
        ADC   $E5                   ; F4BC 65 E5
        BNE   LF4C2                 ; F4BE D0 02
        LDA   #$14                  ; F4C0 A9 14
LF4C2   BPL   LF4C6                 ; F4C2 10 02
        LDA   #$14                  ; F4C4 A9 14
LF4C6   CMP   #$15                  ; F4C6 C9 15
        BCC   LF4CC                 ; F4C8 90 02
        LDA   #$01                  ; F4CA A9 01
LF4CC   STA   $E5                   ; F4CC 85 E5
        LDA   #$00                  ; F4CE A9 00
        STA   $A2                   ; F4D0 85 A2
        LDA   LFDED,X               ; F4D2 BD ED FD
        BMI   LF4DC                 ; F4D5 30 05
        BEQ   LF50F                 ; F4D7 F0 36
        JMP   LF53B                 ; F4D9 4C 3B F5
LF4DC   LDX   #$00                  ; F4DC A2 00
LF4DE   LDA   $E9,X                 ; F4DE B5 E9
        BEQ   LF501                 ; F4E0 F0 1F
        CLC                         ; F4E2 18
        ADC   #$04                  ; F4E3 69 04
        CMP   #$1C                  ; F4E5 C9 1C
        BCC   LF4EB                 ; F4E7 90 02
        LDA   #$00                  ; F4E9 A9 00
LF4EB   STA   $E9,X                 ; F4EB 95 E9
        CMP   #$14                  ; F4ED C9 14
        BNE   LF501                 ; F4EF D0 10
        LDA   #$04                  ; F4F1 A9 04
        CPX   #$00                  ; F4F3 E0 00
        BEQ   LF4FB                 ; F4F5 F0 04
        STA   $E8,X                 ; F4F7 95 E8
        BNE   LF501                 ; F4F9 D0 06
LF4FB   STA   $A2                   ; F4FB 85 A2
        LDA   #$00                  ; F4FD A9 00
        STA   $F1                   ; F4FF 85 F1
LF501   INX                         ; F501 E8
        CPX   #$09                  ; F502 E0 09
        BCC   LF4DE                 ; F504 90 D8
        LDA   $A2                   ; F506 A5 A2
        BEQ   LF50C                 ; F508 F0 02
        STA   $F1                   ; F50A 85 F1
LF50C   JMP   LF53B                 ; F50C 4C 3B F5
LF50F   LDX   #$08                  ; F50F A2 08
LF511   LDA   $E9,X                 ; F511 B5 E9
        BEQ   LF532                 ; F513 F0 1D
        SEC                         ; F515 38
        SBC   #$04                  ; F516 E9 04
        BPL   LF51C                 ; F518 10 02
        LDA   #$00                  ; F51A A9 00
LF51C   STA   $E9,X                 ; F51C 95 E9
        CMP   #$08                  ; F51E C9 08
        BNE   LF532                 ; F520 D0 10
        LDA   #$18                  ; F522 A9 18
        CPX   #$08                  ; F524 E0 08
        BCS   LF52C                 ; F526 B0 04
        STA   $EA,X                 ; F528 95 EA
        BCC   LF532                 ; F52A 90 06
LF52C   STA   $A2                   ; F52C 85 A2
        LDA   #$00                  ; F52E A9 00
        STA   $E9                   ; F530 85 E9
LF532   DEX                         ; F532 CA
        BPL   LF511                 ; F533 10 DC
        LDA   $A2                   ; F535 A5 A2
        BEQ   LF53B                 ; F537 F0 02
        STA   $E9                   ; F539 85 E9
LF53B   RTS                         ; F53B 60
LF53C   LDA   $82                   ; F53C A5 82
        LDX   $95                   ; F53E A6 95
        CMP   LF593,X               ; F540 DD 93 F5
        BCC   LF548                 ; F543 90 03
        JMP   LF592                 ; F545 4C 92 F5
LF548   LDA   $81                   ; F548 A5 81
        LSR                         ; F54A 4A
        LSR                         ; F54B 4A
        LSR                         ; F54C 4A
        AND   #$03                  ; F54D 29 03
        TAX                         ; F54F AA
        LDY   #$00                  ; F550 A0 00
        LDA   $A5,X                 ; F552 B5 A5
        CMP   #$50                  ; F554 C9 50
        BCC   LF559                 ; F556 90 01
        INY                         ; F558 C8
LF559   LDA   $A9,X                 ; F559 B5 A9
        CMP   #$48                  ; F55B C9 48
        BCC   LF561                 ; F55D 90 02
        INY                         ; F55F C8
        INY                         ; F560 C8
LF561   LDA   $AD,X                 ; F561 B5 AD
        AND   #$07                  ; F563 29 07
        STA   $A2                   ; F565 85 A2
        LDA   LF598,Y               ; F567 B9 98 F5
        LDY   $A2                   ; F56A A4 A2
        SEC                         ; F56C 38
        SBC   $A2                   ; F56D E5 A2
        BEQ   LF592                 ; F56F F0 21
        BMI   LF579                 ; F571 30 06
        CMP   #$05                  ; F573 C9 05
        BCC   LF57D                 ; F575 90 06
        BCS   LF57F                 ; F577 B0 06
LF579   CMP   #$FC                  ; F579 C9 FC
        BCS   LF57F                 ; F57B B0 02
LF57D   INY                         ; F57D C8
        INY                         ; F57E C8
LF57F   DEY                         ; F57F 88
        TYA                         ; F580 98
        AND   #$07                  ; F581 29 07
        STA   $A2                   ; F583 85 A2
        LDX   #$03                  ; F585 A2 03
LF587   LDA   $AD,X                 ; F587 B5 AD
        AND   #$F0                  ; F589 29 F0
        ORA   $A2                   ; F58B 05 A2
        STA   $AD,X                 ; F58D 95 AD
        DEX                         ; F58F CA
        BPL   LF587                 ; F590 10 F5
LF592   RTS                         ; F592 60
LF593   .byte $14,$10,$40,$18,$60                 ; F593
LF598   .byte $01,$07,$03,$05                     ; F598
LF59C   LDY   $C8                   ; F59C A4 C8
        LDX   $A3                   ; F59E A6 A3
        LDA   $CB                   ; F5A0 A5 CB
        BEQ   LF5D6                 ; F5A2 F0 32
        STA   $CC                   ; F5A4 85 CC
        LDA   $C9                   ; F5A6 A5 C9
        STA   $CA                   ; F5A8 85 CA
        CLC                         ; F5AA 18
        ADC   LFFC5,Y               ; F5AB 79 C5 FF
        CMP   #$92                  ; F5AE C9 92
        BCS   LF5CA                 ; F5B0 B0 18
        CMP   #$02                  ; F5B2 C9 02
        BCC   LF5CA                 ; F5B4 90 14
        STA   $C9                   ; F5B6 85 C9
        LDA   $CB                   ; F5B8 A5 CB
        CLC                         ; F5BA 18
        ADC   LFFCD,Y               ; F5BB 79 CD FF
        CMP   #$8F                  ; F5BE C9 8F
        BCS   LF5CA                 ; F5C0 B0 08
        CMP   #$02                  ; F5C2 C9 02
        BCC   LF5CA                 ; F5C4 90 04
        STA   $CB                   ; F5C6 85 CB
        BCS   LF5D6                 ; F5C8 B0 0C
LF5CA   LDA   #$00                  ; F5CA A9 00
        STA   $C8                   ; F5CC 85 C8
        STA   $C9                   ; F5CE 85 C9
        STA   $CA                   ; F5D0 85 CA
        STA   $CB                   ; F5D2 85 CB
        STA   $CC                   ; F5D4 85 CC
LF5D6   LDX   #$01                  ; F5D6 A2 01
LF5D8   LDA   $D8,X                 ; F5D8 B5 D8
        BEQ   LF608                 ; F5DA F0 2C
        LDY   $D6,X                 ; F5DC B4 D6
        CLC                         ; F5DE 18
        ADC   LFFC5,Y               ; F5DF 79 C5 FF
        CMP   #$92                  ; F5E2 C9 92
        BCS   LF600                 ; F5E4 B0 1A
        CMP   #$02                  ; F5E6 C9 02
        BCC   LF600                 ; F5E8 90 16
        STA   $D8,X                 ; F5EA 95 D8
        LDA   $DA,X                 ; F5EC B5 DA
        BEQ   LF608                 ; F5EE F0 18
        CLC                         ; F5F0 18
        ADC   LFFCD,Y               ; F5F1 79 CD FF
        CMP   #$8F                  ; F5F4 C9 8F
        BCS   LF600                 ; F5F6 B0 08
        CMP   #$02                  ; F5F8 C9 02
        BCC   LF600                 ; F5FA 90 04
        STA   $DA,X                 ; F5FC 95 DA
        BCS   LF608                 ; F5FE B0 08
LF600   LDA   #$00                  ; F600 A9 00
        STA   $D6,X                 ; F602 95 D6
        STA   $D8,X                 ; F604 95 D8
        STA   $DA,X                 ; F606 95 DA
LF608   DEX                         ; F608 CA
        BPL   LF5D8                 ; F609 10 CD
        RTS                         ; F60B 60
LF60C   LDY   #$00                  ; F60C A0 00
        STY   $A2                   ; F60E 84 A2
        DEY                         ; F610 88
        LDX   #$03                  ; F611 A2 03
LF613   LDA   $AD,X                 ; F613 B5 AD
        AND   #$07                  ; F615 29 07
        ORA   $A2                   ; F617 05 A2
        STA   $A2                   ; F619 85 A2
        LDA   $A5,X                 ; F61B B5 A5
        ORA   $A9,X                 ; F61D 15 A9
        BNE   LF623                 ; F61F D0 02
        TXA                         ; F621 8A
        TAY                         ; F622 A8
LF623   DEX                         ; F623 CA
        BPL   LF613                 ; F624 10 ED
        TYA                         ; F626 98
        BMI   LF67D                 ; F627 30 54
        LDA   $82                   ; F629 A5 82
        AND   #$07                  ; F62B 29 07
        TAX                         ; F62D AA
        INX                         ; F62E E8
LF62F   LDA   $BF,X                 ; F62F B5 BF
        BNE   LF677                 ; F631 D0 44
        CPX   #$08                  ; F633 E0 08
        BEQ   LF677                 ; F635 F0 40
        CPX   #$00                  ; F637 E0 00
        BEQ   LF677                 ; F639 F0 3C
        LDA   $BE,X                 ; F63B B5 BE
        BNE   LF677                 ; F63D D0 38
        LDA   $C0,X                 ; F63F B5 C0
        BNE   LF677                 ; F641 D0 34
        TXA                         ; F643 8A
        ASL                         ; F644 0A
        ASL                         ; F645 0A
        ASL                         ; F646 0A
        ASL                         ; F647 0A
        ORA   #$01                  ; F648 09 01
        STA.w $00A9,Y               ; F64A 99 A9 00
        LDA   $A2                   ; F64D A5 A2
        STA.w $00AD,Y               ; F64F 99 AD 00
        LDA   $96                   ; F652 A5 96
        BNE   LF668                 ; F654 D0 12
        LDA   $80                   ; F656 A5 80
        BEQ   LF668                 ; F658 F0 0E
        BIT   $9F                   ; F65A 24 9F
        BMI   LF668                 ; F65C 30 0A
        LDA.w $00AD,Y               ; F65E B9 AD 00
        ORA   #$40                  ; F661 09 40
        STA.w $00AD,Y               ; F663 99 AD 00
        DEC   $9F                   ; F666 C6 9F
LF668   LDX   #$02                  ; F668 A2 02
        LDA   $A2                   ; F66A A5 A2
        CMP   #$04                  ; F66C C9 04
        BCC   LF672                 ; F66E 90 02
        LDX   #$91                  ; F670 A2 91
LF672   STX   $A5,Y                 ; F672 96 A5
        JMP   LF67D                 ; F674 4C 7D F6
LF677   DEX                         ; F677 CA
        BMI   LF67D                 ; F678 30 03
        JMP   LF62F                 ; F67A 4C 2F F6
LF67D   RTS                         ; F67D 60
LF67E   LDA   #$F7                  ; F67E A9 F7
        STA   $F3                   ; F680 85 F3
        LDY   $95                   ; F682 A4 95
        LDA   LF70B,Y               ; F684 B9 0B F7
        STA   $F2                   ; F687 85 F2
        LDX   #$03                  ; F689 A2 03
        LDA   #$00                  ; F68B A9 00
LF68D   ORA   $AD,X                 ; F68D 15 AD
        DEX                         ; F68F CA
        BPL   LF68D                 ; F690 10 FB
        AND   #$07                  ; F692 29 07
        STA   $A2                   ; F694 85 A2
        LDX   #$03                  ; F696 A2 03
LF698   LDY   $A2                   ; F698 A4 A2
        LDA   $A5,X                 ; F69A B5 A5
        BEQ   LF704                 ; F69C F0 66
        CLC                         ; F69E 18
        ADC   ($F2),Y               ; F69F 71 F2
        LDY   $A3                   ; F6A1 A4 A3
        CLC                         ; F6A3 18
        ADC   LFFD5,Y               ; F6A4 79 D5 FF
        CMP   #$F0                  ; F6A7 C9 F0
        BCC   LF6AD                 ; F6A9 90 02
        LDA   #$91                  ; F6AB A9 91
LF6AD   CMP   #$92                  ; F6AD C9 92
        BCC   LF6B3                 ; F6AF 90 02
        LDA   #$02                  ; F6B1 A9 02
LF6B3   CMP   #$02                  ; F6B3 C9 02
        BCS   LF6B9                 ; F6B5 B0 02
        LDA   #$91                  ; F6B7 A9 91
LF6B9   STA   $A5,X                 ; F6B9 95 A5
        LDA   $A2                   ; F6BB A5 A2
        ORA   #$08                  ; F6BD 09 08
        TAY                         ; F6BF A8
        LDA   $A9,X                 ; F6C0 B5 A9
        BEQ   LF704                 ; F6C2 F0 40
        CLC                         ; F6C4 18
        ADC   ($F2),Y               ; F6C5 71 F2
        LDY   $A3                   ; F6C7 A4 A3
        CLC                         ; F6C9 18
        ADC   LFFDD,Y               ; F6CA 79 DD FF
        STA   $A9,X                 ; F6CD 95 A9
        CMP   #$F0                  ; F6CF C9 F0
        BCS   LF6DB                 ; F6D1 B0 08
        CMP   #$8F                  ; F6D3 C9 8F
        BCS   LF6E7                 ; F6D5 B0 10
        CMP   #$02                  ; F6D7 C9 02
        BCS   LF704                 ; F6D9 B0 29
LF6DB   LDA   $C7                   ; F6DB A5 C7
        LDA   $C7                   ; F6DD A5 C7
        BNE   LF6F3                 ; F6DF D0 12
        LDA   #$8E                  ; F6E1 A9 8E
        STA   $A9,X                 ; F6E3 95 A9
        BNE   LF704                 ; F6E5 D0 1D
LF6E7   LDA   $BF                   ; F6E7 A5 BF
        LDA   $C0                   ; F6E9 A5 C0
        BNE   LF6F3                 ; F6EB D0 06
        LDA   #$02                  ; F6ED A9 02
        STA   $A9,X                 ; F6EF 95 A9
        BNE   LF704                 ; F6F1 D0 11
LF6F3   LDY   $AD,X                 ; F6F3 B4 AD
        LDA   #$00                  ; F6F5 A9 00
        STA   $AD,X                 ; F6F7 95 AD
        STA   $A5,X                 ; F6F9 95 A5
        STA   $A9,X                 ; F6FB 95 A9
        TYA                         ; F6FD 98
        AND   #$40                  ; F6FE 29 40
        BEQ   LF704                 ; F700 F0 02
        INC   $9F                   ; F702 E6 9F
LF704   DEX                         ; F704 CA
        BMI   LF70A                 ; F705 30 03
        JMP   LF698                 ; F707 4C 98 F6
LF70A   RTS                         ; F70A 60
LF70B   .byte $10,$20,$10,$30,$30,$00,$02,$02     ; F70B
        .byte $02,$00,$FE,$FE,$FE,$02,$02,$00     ; F713
        .byte $FE,$FE,$FE,$00,$02,$00,$03,$03     ; F71B
        .byte $03,$00,$FD,$FD,$FD,$03,$03,$00     ; F723
        .byte $FD,$FD,$FD,$00,$03,$00,$05,$05     ; F72B
        .byte $05,$00,$FB,$FB,$FB,$05,$05,$00     ; F733
        .byte $FB,$FB,$FB,$00,$05                 ; F73B
LF740   LDA   $82                   ; F740 A5 82
        LDX   $94                   ; F742 A6 94
        CMP   LF772,X               ; F744 DD 72 F7
        BCS   LF771                 ; F747 B0 28
        AND   #$03                  ; F749 29 03
        TAY                         ; F74B A8
        AND   #$01                  ; F74C 29 01
        TAX                         ; F74E AA
        LDA   $D8,X                 ; F74F B5 D8
        BNE   LF771                 ; F751 D0 1E
        LDA.w $00AD,Y               ; F753 B9 AD 00
        BMI   LF771                 ; F756 30 19
        LDA.w $00A5,Y               ; F758 B9 A5 00
        BEQ   LF771                 ; F75B F0 14
        CLC                         ; F75D 18
        ADC   #$04                  ; F75E 69 04
        STA   $D8,X                 ; F760 95 D8
        LDA.w $00AD,Y               ; F762 B9 AD 00
        AND   #$07                  ; F765 29 07
        STA   $D6,X                 ; F767 95 D6
        LDA.w $00A9,Y               ; F769 B9 A9 00
        JMP   LFC60                 ; F76C 4C 60 FC
LF76F   STA   $DA,X                 ; F76F 95 DA
LF771   RTS                         ; F771 60
LF772   .byte $10,$40,$80,$80                     ; F772
LF776   LDX   #$03                  ; F776 A2 03
LF778   LDA   $AD,X                 ; F778 B5 AD
        BPL   LF7AA                 ; F77A 10 2E
        TAY                         ; F77C A8
        CLC                         ; F77D 18
        ADC   #$10                  ; F77E 69 10
        AND   #$30                  ; F780 29 30
        BEQ   LF78F                 ; F782 F0 0B
        STA   $A2                   ; F784 85 A2
        TYA                         ; F786 98
        AND   #$CF                  ; F787 29 CF
        ORA   $A2                   ; F789 05 A2
        STA   $AD,X                 ; F78B 95 AD
        BMI   LF7AA                 ; F78D 30 1B
LF78F   LDA   #$00                  ; F78F A9 00
        STA   $AD,X                 ; F791 95 AD
        STA   $A5,X                 ; F793 95 A5
        STA   $A9,X                 ; F795 95 A9
        SEC                         ; F797 38
        LDA   $96                   ; F798 A5 96
        BEQ   LF79E                 ; F79A F0 02
        SBC   #$01                  ; F79C E9 01
LF79E   STA   $96                   ; F79E 85 96
        TYA                         ; F7A0 98
        AND   #$40                  ; F7A1 29 40
        BNE   LF7AF                 ; F7A3 D0 0A
        LDA   #$01                  ; F7A5 A9 01
        JSR   LF7D8                 ; F7A7 20 D8 F7
LF7AA   DEX                         ; F7AA CA
        BPL   LF778                 ; F7AB 10 CB
        BMI   LF812                 ; F7AD 30 63
LF7AF   LDA   #$30                  ; F7AF A9 30
        JSR   LF7D8                 ; F7B1 20 D8 F7
        LDX   $93                   ; F7B4 A6 93
        LDA   $89,X                 ; F7B6 B5 89
        ORA   #$40                  ; F7B8 09 40
        STA   $89,X                 ; F7BA 95 89
        LDA   $A4                   ; F7BC A5 A4
        CMP   #$7C                  ; F7BE C9 7C
        BCC   LF7C4                 ; F7C0 90 02
        DEC   $88                   ; F7C2 C6 88
LF7C4   LDY   $95                   ; F7C4 A4 95
        CPY   #$04                  ; F7C6 C0 04
        BNE   LF7D2                 ; F7C8 D0 08
        AND   #$07                  ; F7CA 29 07
        CMP   #$03                  ; F7CC C9 03
        BCS   LF7D2                 ; F7CE B0 02
        INC   $89,X                 ; F7D0 F6 89
LF7D2   LDA   #$01                  ; F7D2 A9 01
        STA   $80                   ; F7D4 85 80
        BNE   LF812                 ; F7D6 D0 3A
LF7D8   LDY   $93                   ; F7D8 A4 93
        SED                         ; F7DA F8
        CLC                         ; F7DB 18
        ADC.w $008D,Y               ; F7DC 79 8D 00
        STA.w $008D,Y               ; F7DF 99 8D 00
        LDA.w $008F,Y               ; F7E2 B9 8F 00
        STA   $F8                   ; F7E5 85 F8
        BCC   LF7EB                 ; F7E7 90 02
        ADC   #$00                  ; F7E9 69 00
LF7EB   STA.w $008F,Y               ; F7EB 99 8F 00
        CLD                         ; F7EE D8
        CMP   $F8                   ; F7EF C5 F8
        BEQ   LF811                 ; F7F1 F0 1E
        CMP   #$01                  ; F7F3 C9 01
        BNE   LF811                 ; F7F5 D0 1A
        LDA.w $008B,Y               ; F7F7 B9 8B 00
        AND   #$F0                  ; F7FA 29 F0
        STA   $F8                   ; F7FC 85 F8
        LDA.w $008B,Y               ; F7FE B9 8B 00
        AND   #$07                  ; F801 29 07
        CLC                         ; F803 18
        ADC   #$01                  ; F804 69 01
        CMP   #$05                  ; F806 C9 05
        BCC   LF80C                 ; F808 90 02
        LDA   #$04                  ; F80A A9 04
LF80C   ORA   $F8                   ; F80C 05 F8
        STA.w $008B,Y               ; F80E 99 8B 00
LF811   RTS                         ; F811 60
LF812   RTS                         ; F812 60
LF813   LDX   #$08                  ; F813 A2 08
LF815   LDA   #$00                  ; F815 A9 00
        STA   $BF,X                 ; F817 95 BF
        STA   $B6,X                 ; F819 95 B6
        STA   $CD,X                 ; F81B 95 CD
        STA   $DC,X                 ; F81D 95 DC
        LDA   $AD,X                 ; F81F B5 AD
        AND   #$F7                  ; F821 29 F7
        STA   $AD,X                 ; F823 95 AD
        DEX                         ; F825 CA
        BPL   LF815                 ; F826 10 ED
        LDA   $81                   ; F828 A5 81
        AND   #$01                  ; F82A 29 01
        TAX                         ; F82C AA
        LDA   $CB,X                 ; F82D B5 CB
        BEQ   LF843                 ; F82F F0 12
        TAY                         ; F831 A8
        LSR                         ; F832 4A
        LSR                         ; F833 4A
        LSR                         ; F834 4A
        LSR                         ; F835 4A
        TAX                         ; F836 AA
        TYA                         ; F837 98
        AND   #$0F                  ; F838 29 0F
        STA   $A2                   ; F83A 85 A2
        LDA   #$10                  ; F83C A9 10
        SEC                         ; F83E 38
        SBC   $A2                   ; F83F E5 A2
        STA   $CD,X                 ; F841 95 CD
LF843   LDA   $81                   ; F843 A5 81
        AND   #$01                  ; F845 29 01
        TAX                         ; F847 AA
        LDA   $DA,X                 ; F848 B5 DA
        BEQ   LF85E                 ; F84A F0 12
        TAY                         ; F84C A8
        LSR                         ; F84D 4A
        LSR                         ; F84E 4A
        LSR                         ; F84F 4A
        LSR                         ; F850 4A
        TAX                         ; F851 AA
        TYA                         ; F852 98
        AND   #$0F                  ; F853 29 0F
        STA   $A2                   ; F855 85 A2
        LDA   #$10                  ; F857 A9 10
        SEC                         ; F859 38
        SBC   $A2                   ; F85A E5 A2
        STA   $DC,X                 ; F85C 95 DC
LF85E   LDY   #$03                  ; F85E A0 03
LF860   LDA.w $00AD,Y               ; F860 B9 AD 00
        STA   $A2                   ; F863 85 A2
        AND   #$07                  ; F865 29 07
        TAX                         ; F867 AA
        AND   #$04                  ; F868 29 04
        ASL                         ; F86A 0A
        STA   $F2                   ; F86B 85 F2
        LDA   LFDD8,X               ; F86D BD D8 FD
        BIT   $A2                   ; F870 24 A2
        BVC   LF876                 ; F872 50 02
        LDA   #$C6                  ; F874 A9 C6
LF876   BIT   $A2                   ; F876 24 A2
        BPL   LF87C                 ; F878 10 02
        LDA   #$A6                  ; F87A A9 A6
LF87C   STA   $F4                   ; F87C 85 F4
        LDA.w $00A5,Y               ; F87E B9 A5 00
        BNE   LF886                 ; F881 D0 03
        JMP   LF8DF                 ; F883 4C DF F8
LF886   STA   $F6                   ; F886 85 F6
        LDA.w $00A9,Y               ; F888 B9 A9 00
        BNE   LF890                 ; F88B D0 03
        JMP   LF8DF                 ; F88D 4C DF F8
LF890   LSR                         ; F890 4A
        LSR                         ; F891 4A
        LSR                         ; F892 4A
        LSR                         ; F893 4A
        STA   $F8                   ; F894 85 F8
        LDA.w $00A9,Y               ; F896 B9 A9 00
        AND   #$0F                  ; F899 29 0F
        STA   $FA                   ; F89B 85 FA
        LDX   $F8                   ; F89D A6 F8
        LDA   $AD,X                 ; F89F B5 AD
        ORA   $F2                   ; F8A1 05 F2
        STA   $AD,X                 ; F8A3 95 AD
        LDA   $F6                   ; F8A5 A5 F6
        STA   $B6,X                 ; F8A7 95 B6
        LDA   $F4                   ; F8A9 A5 F4
        SEC                         ; F8AB 38
        SBC   $FA                   ; F8AC E5 FA
        STA   $BF,X                 ; F8AE 95 BF
        LDA   $FA                   ; F8B0 A5 FA
        CMP   #$03                  ; F8B2 C9 03
        BCC   LF8DF                 ; F8B4 90 29
        LDX   $F8                   ; F8B6 A6 F8
        INX                         ; F8B8 E8
        CPX   #$09                  ; F8B9 E0 09
        BCC   LF8BF                 ; F8BB 90 02
        LDX   #$00                  ; F8BD A2 00
LF8BF   LDA   $BF,X                 ; F8BF B5 BF
        LDA   #$10                  ; F8C1 A9 10
        SEC                         ; F8C3 38
        SBC   $FA                   ; F8C4 E5 FA
        CLC                         ; F8C6 18
        ADC   $F4                   ; F8C7 65 F4
        STA   $BF,X                 ; F8C9 95 BF
        LDA   $F6                   ; F8CB A5 F6
        STA   $B6,X                 ; F8CD 95 B6
        LDA   $AD,X                 ; F8CF B5 AD
        ORA   $F2                   ; F8D1 05 F2
        STA   $AD,X                 ; F8D3 95 AD
        CPX   #$00                  ; F8D5 E0 00
        BEQ   LF8DF                 ; F8D7 F0 06
        LDA   #$00                  ; F8D9 A9 00
        LDX   $F8                   ; F8DB A6 F8
        STA   $B6,X                 ; F8DD 95 B6
LF8DF   DEY                         ; F8DF 88
        BMI   LF8E5                 ; F8E0 30 03
        JMP   LF860                 ; F8E2 4C 60 F8
LF8E5   RTS                         ; F8E5 60
LF8E6   LDA   #$00                  ; F8E6 A9 00
        BIT   $83                   ; F8E8 24 83
        BPL   LF8EE                 ; F8EA 10 02
        LDA   #$02                  ; F8EC A9 02
LF8EE   STX   WSYNC                 ; F8EE 86 02
        STA   VBLANK                ; F8F0 85 01
        LDA   #$E4                  ; F8F2 A9 E4
        STA   TIM64T                ; F8F4 8D 96 02
        LDA   LFD78                 ; F8F7 AD 78 FD
        STA   COLUBK                ; F8FA 85 09
        LDY   $80                   ; F8FC A4 80
        LDA   LFD7C,Y               ; F8FE B9 7C FD
        STA   COLUPF                ; F901 85 08
        LDA   LFD82,Y               ; F903 B9 82 FD
        STA   COLUP0                ; F906 85 06
        STA   COLUP1                ; F908 85 07
        LDA   #$40                  ; F90A A9 40
        STA   RESP0                 ; F90C 85 10
        STA   RESP1                 ; F90E 85 11
        STA   HMP0                  ; F910 85 20
        LDA   #$50                  ; F912 A9 50
        STA   HMP1                  ; F914 85 21
        LDA   #$03                  ; F916 A9 03
        STA   NUSIZ0                ; F918 85 04
        STA   NUSIZ1                ; F91A 85 05
        LDA   #$01                  ; F91C A9 01
        STA   VDELP0                ; F91E 85 25
        STA   VDELP1                ; F920 85 26
        LDA   #$01                  ; F922 A9 01
        STA   CTRLPF                ; F924 85 0A
        STX   PF2                   ; F926 86 0F
        STX   HMOVE                 ; F928 86 2A
        LDA   LFD79,Y               ; F92A B9 79 FD
        STA   COLUBK                ; F92D 85 09
        LDA   #$FD                  ; F92F A9 FD
        STA   $F3                   ; F931 85 F3
        STA   $F5                   ; F933 85 F5
        STA   $F7                   ; F935 85 F7
        STA   $F9                   ; F937 85 F9
        STA   $FB                   ; F939 85 FB
        STA   $FD                   ; F93B 85 FD
        LDA   LF98D,Y               ; F93D B9 8D F9
        STA   $FE                   ; F940 85 FE
        LDA   LF990,Y               ; F942 B9 90 F9
        STA   $FF                   ; F945 85 FF
        LDA   $81                   ; F947 A5 81
        AND   #$01                  ; F949 29 01
        TAX                         ; F94B AA
        AND   #$01                  ; F94C 29 01
        TAY                         ; F94E A8
        LDA   $D8,X                 ; F94F B5 D8
        STA   $A2                   ; F951 85 A2
        LDA.w $00C9,Y               ; F953 B9 C9 00
        STA   HMCLR                 ; F956 85 2B
        LDX   #$FF                  ; F958 A2 FF
        STA   WSYNC                 ; F95A 85 02
        SEC                         ; F95C 38
LF95D   SBC   #$0F                  ; F95D E9 0F
        BCS   LF95D                 ; F95F B0 FC
        ASL                         ; F961 0A
        ASL                         ; F962 0A
        ASL                         ; F963 0A
        ASL                         ; F964 0A
        EOR   #$F0                  ; F965 49 F0
        ADC   #$90                  ; F967 69 90
        STA.w $0012                 ; F969 8D 12 00
        STA   HMM0                  ; F96C 85 22
        LDA   $A2                   ; F96E A5 A2
        STA   WSYNC                 ; F970 85 02
        SEC                         ; F972 38
LF973   SBC   #$0F                  ; F973 E9 0F
        BCS   LF973                 ; F975 B0 FC
        ASL                         ; F977 0A
        ASL                         ; F978 0A
        ASL                         ; F979 0A
        ASL                         ; F97A 0A
        EOR   #$F0                  ; F97B 49 F0
        ADC   #$90                  ; F97D 69 90
        STA.w $0013                 ; F97F 8D 13 00
        STA   HMM1                  ; F982 85 23
        STX   WSYNC                 ; F984 86 02
        STX   HMOVE                 ; F986 86 2A
        STX   PF2                   ; F988 86 0F
        JMP   ($00FE)               ; F98A 6C FE 00
LF98D   .byte $93,$D9,$64                         ; F98D
LF990   .byte $F9,$F9,$FA                         ; F990
LF993   LDA   $A1                   ; F993 A5 A1
        STA   $FE                   ; F995 85 FE
        LDA   #$16                  ; F997 A9 16
        STA   $FF                   ; F999 85 FF
        CMP   $A1                   ; F99B C5 A1
        BCC   LF9A8                 ; F99D 90 09
        LDY   $80                   ; F99F A4 80
        LDA   LFD85,Y               ; F9A1 B9 85 FD
        STA   COLUP0                ; F9A4 85 06
        STA   COLUP1                ; F9A6 85 07
LF9A8   STA   WSYNC                 ; F9A8 85 02
        LDY   $FE                   ; F9AA A4 FE
        LDA   LFCA0,Y               ; F9AC B9 A0 FC
        STA   GRP0                  ; F9AF 85 1B
        LDA   LFCCE,Y               ; F9B1 B9 CE FC
        STA   GRP1                  ; F9B4 85 1C
        LDA   LFE00,Y               ; F9B6 B9 00 FE
        STA   GRP0                  ; F9B9 85 1B
        LDA   LFE9F,Y               ; F9BB B9 9F FE
        STA   $A2                   ; F9BE 85 A2
        LDA   LFE43,Y               ; F9C0 B9 43 FE
        LDX   LFE71,Y               ; F9C3 BE 71 FE
        LDY   $A2                   ; F9C6 A4 A2
        STA   GRP1                  ; F9C8 85 1C
        STX   GRP0                  ; F9CA 86 1B
        STY   GRP1                  ; F9CC 84 1C
        STX   GRP0                  ; F9CE 86 1B
        DEC   $FE                   ; F9D0 C6 FE
        DEC   $FF                   ; F9D2 C6 FF
        BNE   LF9A8                 ; F9D4 D0 D2
        JMP   LFB8E                 ; F9D6 4C 8E FB
LF9D9   LDA   $93                   ; F9D9 A5 93
        LSR                         ; F9DB 4A
        LDA   #$00                  ; F9DC A9 00
        ROR                         ; F9DE 6A
        LDY   $80                   ; F9DF A4 80
        ORA   LFD7C,Y               ; F9E1 19 7C FD
        STA   COLUPF                ; F9E4 85 08
        LDA   #$09                  ; F9E6 A9 09
        STA   $FE                   ; F9E8 85 FE
LF9EA   STA   WSYNC                 ; F9EA 85 02
        LDY   $FE                   ; F9EC A4 FE
        LDA   LFD9C,Y               ; F9EE B9 9C FD
        STA   GRP0                  ; F9F1 85 1B
        LDA   LFDA6,Y               ; F9F3 B9 A6 FD
        STA   GRP1                  ; F9F6 85 1C
        LDA   LFDB0,Y               ; F9F8 B9 B0 FD
        STA   GRP0                  ; F9FB 85 1B
        LDA   LFDCE,Y               ; F9FD B9 CE FD
        STA   $A2                   ; FA00 85 A2
        LDA   LFDBA,Y               ; FA02 B9 BA FD
        LDX   LFDC4,Y               ; FA05 BE C4 FD
        LDY   $A2                   ; FA08 A4 A2
        STA   GRP1                  ; FA0A 85 1C
        STX   GRP0                  ; FA0C 86 1B
        STY   GRP1                  ; FA0E 84 1C
        STX   GRP0                  ; FA10 86 1B
        DEC   $FE                   ; FA12 C6 FE
        BPL   LF9EA                 ; FA14 10 D4
        STA   WSYNC                 ; FA16 85 02
        LDA   #$00                  ; FA18 A9 00
        STA   GRP0                  ; FA1A 85 1B
        STA   GRP1                  ; FA1C 85 1C
        STA   GRP0                  ; FA1E 85 1B
        STA   GRP1                  ; FA20 85 1C
        LDY   $80                   ; FA22 A4 80
        LDA   LFD85,Y               ; FA24 B9 85 FD
        STA   COLUP0                ; FA27 85 06
        STA   COLUP1                ; FA29 85 07
        STA   WSYNC                 ; FA2B 85 02
        LDA   #$64                  ; FA2D A9 64
        STA   $F2                   ; FA2F 85 F2
        STA   $FC                   ; FA31 85 FC
        LDY   $95                   ; FA33 A4 95
        LDA   LFA50,Y               ; FA35 B9 50 FA
        STA   $F4                   ; FA38 85 F4
        LDA   LFA55,Y               ; FA3A B9 55 FA
        STA   $F6                   ; FA3D 85 F6
        LDA   LFA5A,Y               ; FA3F B9 5A FA
        STA   $F8                   ; FA42 85 F8
        LDA   LFA5F,Y               ; FA44 B9 5F FA
        STA   $FA                   ; FA47 85 FA
        LDA   #$09                  ; FA49 A9 09
        STA   $FF                   ; FA4B 85 FF
        JMP   LFB67                 ; FA4D 4C 67 FB
LFA50   .byte $0A,$0A,$0A,$0A,$14                 ; FA50
LFA55   .byte $5A,$5A,$5A,$5A,$00                 ; FA55
LFA5A   .byte $0A,$28,$46,$50,$00                 ; FA5A
LFA5F   .byte $00,$00,$00,$1E,$0A                 ; FA5F
LFA64   LDA   $93                   ; FA64 A5 93
        TAX                         ; FA66 AA
        ROR                         ; FA67 6A
        ROR                         ; FA68 6A
        LDY   $80                   ; FA69 A4 80
        ORA   LFD7C,Y               ; FA6B 19 7C FD
        STA   COLUPF                ; FA6E 85 08
        LDA   #$00                  ; FA70 A9 00
        STA   $FA                   ; FA72 85 FA
        STA   $FC                   ; FA74 85 FC
        LDA   $8F,X                 ; FA76 B5 8F
        LSR                         ; FA78 4A
        LSR                         ; FA79 4A
        LSR                         ; FA7A 4A
        LSR                         ; FA7B 4A
        TAY                         ; FA7C A8
        LDA   LFB3F,Y               ; FA7D B9 3F FB
        STA   $F2                   ; FA80 85 F2
        LDA   $8F,X                 ; FA82 B5 8F
        AND   #$0F                  ; FA84 29 0F
        TAY                         ; FA86 A8
        LDA   LFB3F,Y               ; FA87 B9 3F FB
        STA   $F4                   ; FA8A 85 F4
        NOP                         ; FA8C EA
        LDA   $8D,X                 ; FA8D B5 8D
        LSR                         ; FA8F 4A
        LSR                         ; FA90 4A
        LSR                         ; FA91 4A
        LSR                         ; FA92 4A
        TAY                         ; FA93 A8
        LDA   LFB3F,Y               ; FA94 B9 3F FB
        STA   $F6                   ; FA97 85 F6
        LDA   $8D,X                 ; FA99 B5 8D
        AND   #$0F                  ; FA9B 29 0F
        TAY                         ; FA9D A8
        LDA   LFB3F,Y               ; FA9E B9 3F FB
        STA   $F8                   ; FAA1 85 F8
        LDA   #$09                  ; FAA3 A9 09
        STA   $FE                   ; FAA5 85 FE
        STA   $FF                   ; FAA7 85 FF
        LDY   $94                   ; FAA9 A4 94
        INY                         ; FAAB C8
        LDA   LFB49,Y               ; FAAC B9 49 FB
        STA   $A1                   ; FAAF 85 A1
LFAB1   LDY   $FE                   ; FAB1 A4 FE
        LDA   ($FC),Y               ; FAB3 B1 FC
        STA   WSYNC                 ; FAB5 85 02
        STA   $A2                   ; FAB7 85 A2
        LDA   ($F2),Y               ; FAB9 B1 F2
        STA   GRP0                  ; FABB 85 1B
        LDA   ($F4),Y               ; FABD B1 F4
        STA   GRP1                  ; FABF 85 1C
        LDA   ($F6),Y               ; FAC1 B1 F6
        STA   GRP0                  ; FAC3 85 1B
        LDA   ($FA),Y               ; FAC5 B1 FA
        TAX                         ; FAC7 AA
        LDA   ($F8),Y               ; FAC8 B1 F8
        LDY   $A2                   ; FACA A4 A2
        STA   GRP1                  ; FACC 85 1C
        STX   GRP0                  ; FACE 86 1B
        STY   GRP1                  ; FAD0 84 1C
        STX   GRP0                  ; FAD2 86 1B
        DEC   $FE                   ; FAD4 C6 FE
        BPL   LFAB1                 ; FAD6 10 D9
        LDA   #$64                  ; FAD8 A9 64
        STA   $F2                   ; FADA 85 F2
        STX   $FC                   ; FADC 86 FC
        STA   WSYNC                 ; FADE 85 02
        LDA   #$00                  ; FAE0 A9 00
        STA   GRP0                  ; FAE2 85 1B
        STA   GRP1                  ; FAE4 85 1C
        STA   GRP0                  ; FAE6 85 1B
        LDY   $80                   ; FAE8 A4 80
        LDA   LFD85,Y               ; FAEA B9 85 FD
        STA   COLUP0                ; FAED 85 06
        STA   COLUP1                ; FAEF 85 07
        LDX   $93                   ; FAF1 A6 93
        LDA   $8B,X                 ; FAF3 B5 8B
        AND   #$07                  ; FAF5 29 07
        TAX                         ; FAF7 AA
        LDA   LFB4F,X               ; FAF8 BD 4F FB
        STA   $F4                   ; FAFB 85 F4
        LDA   LFB55,X               ; FAFD BD 55 FB
        STA   $F6                   ; FB00 85 F6
        LDA   LFB5B,X               ; FB02 BD 5B FB
        STA   $F8                   ; FB05 85 F8
        LDA   LFB61,X               ; FB07 BD 61 FB
        STA   $FA                   ; FB0A 85 FA
        LDA   LFD7F,Y               ; FB0C B9 7F FD
        STA   COLUPF                ; FB0F 85 08
LFB11   LDA   #$00                  ; FB11 A9 00
        STA   WSYNC                 ; FB13 85 02
        STA   CTRLPF                ; FB15 85 0A
        STA   PF2                   ; FB17 85 0F
        LDY   $FF                   ; FB19 A4 FF
        STA   GRP0                  ; FB1B 85 1B
        LDA   ($F4),Y               ; FB1D B1 F4
        STA   GRP1                  ; FB1F 85 1C
        LDA   ($F6),Y               ; FB21 B1 F6
        STA   GRP0                  ; FB23 85 1B
        LDA   ($F8),Y               ; FB25 B1 F8
        TAX                         ; FB27 AA
        LDA   ($FA),Y               ; FB28 B1 FA
        LDY   #$00                  ; FB2A A0 00
        STA   GRP1                  ; FB2C 85 1C
        STX   GRP0                  ; FB2E 86 1B
        STY   GRP1                  ; FB30 84 1C
        STX   GRP0                  ; FB32 86 1B
        LDA   $A1                   ; FB34 A5 A1
        STA   PF2                   ; FB36 85 0F
        DEC   $FF                   ; FB38 C6 FF
        BPL   LFB11                 ; FB3A 10 D5
        JMP   LFB8E                 ; FB3C 4C 8E FB
LFB3F   .byte $00,$0A,$14,$1E,$28,$32,$3C,$46     ; FB3F
        .byte $50,$5A                             ; FB47
LFB49   .byte $00,$01,$05,$15,$15,$7F             ; FB49
LFB4F   .byte $64,$64,$64,$64,$6E,$6E             ; FB4F
LFB55   .byte $64,$64,$64,$6E,$6E,$6E             ; FB55
LFB5B   .byte $64,$64,$6E,$6E,$6E,$6E             ; FB5B
LFB61   .byte $64,$6E,$6E,$6E,$6E,$6E             ; FB61
LFB67   LDY   $FF                   ; FB67 A4 FF
        LDA   ($FC),Y               ; FB69 B1 FC
        STA   WSYNC                 ; FB6B 85 02
        STA   $A2                   ; FB6D 85 A2
        LDA   ($F2),Y               ; FB6F B1 F2
        STA   GRP0                  ; FB71 85 1B
        LDA   ($F4),Y               ; FB73 B1 F4
        STA   GRP1                  ; FB75 85 1C
        LDA   ($F6),Y               ; FB77 B1 F6
        STA   GRP0                  ; FB79 85 1B
        LDA   ($FA),Y               ; FB7B B1 FA
        TAX                         ; FB7D AA
        LDA   ($F8),Y               ; FB7E B1 F8
        LDY   $A2                   ; FB80 A4 A2
        STA   GRP1                  ; FB82 85 1C
        STX   GRP0                  ; FB84 86 1B
        STY   GRP1                  ; FB86 84 1C
        STX   GRP0                  ; FB88 86 1B
        DEC   $FF                   ; FB8A C6 FF
        BPL   LFB67                 ; FB8C 10 D9
LFB8E   STA   WSYNC                 ; FB8E 85 02
        LDA   #$00                  ; FB90 A9 00
        STA   VDELP0                ; FB92 85 25
        STA   VDELP1                ; FB94 85 26
        STA   GRP0                  ; FB96 85 1B
        STA   GRP1                  ; FB98 85 1C
        LDY   $80                   ; FB9A A4 80
        STA   NUSIZ0                ; FB9C 85 04
        STA   NUSIZ1                ; FB9E 85 05
        CPY   #$02                  ; FBA0 C0 02
        BNE   LFBA6                 ; FBA2 D0 02
        STA   PF2                   ; FBA4 85 0F
LFBA6   LDX   $E5                   ; FBA6 A6 E5
        LDA   LFED5,X               ; FBA8 BD D5 FE
        STA   $F9                   ; FBAB 85 F9
        LDA   LFC80,X               ; FBAD BD 80 FC
        STA   $FB                   ; FBB0 85 FB
        LDA   LFF00,X               ; FBB2 BD 00 FF
        STA   $FD                   ; FBB5 85 FD
        STA.w $002B                 ; FBB7 8D 2B 00
        LDA   #$00                  ; FBBA A9 00
        STA   PF2                   ; FBBC 85 0F
        STA   CTRLPF                ; FBBE 85 0A
        LDA   #$50                  ; FBC0 A9 50
        STA   WSYNC                 ; FBC2 85 02
        SEC                         ; FBC4 38
LFBC5   SBC   #$0F                  ; FBC5 E9 0F
        BCS   LFBC5                 ; FBC7 B0 FC
        ASL                         ; FBC9 0A
        ASL                         ; FBCA 0A
        ASL                         ; FBCB 0A
        ASL                         ; FBCC 0A
        EOR   #$F0                  ; FBCD 49 F0
        ADC   #$90                  ; FBCF 69 90
        STA.w $0010                 ; FBD1 8D 10 00
        STA   HMP0                  ; FBD4 85 20
        LDA   LFF15,X               ; FBD6 BD 15 FF
        STA   $E6                   ; FBD9 85 E6
        LDA   LFF2A,X               ; FBDB BD 2A FF
        STA   $E7                   ; FBDE 85 E7
        LDA   $BE                   ; FBE0 A5 BE
        STA   WSYNC                 ; FBE2 85 02
        SEC                         ; FBE4 38
LFBE5   SBC   #$0F                  ; FBE5 E9 0F
        BCS   LFBE5                 ; FBE7 B0 FC
        ASL                         ; FBE9 0A
        ASL                         ; FBEA 0A
        ASL                         ; FBEB 0A
        ASL                         ; FBEC 0A
        EOR   #$F0                  ; FBED 49 F0
        ADC   #$90                  ; FBEF 69 90
        STA.w $0011                 ; FBF1 8D 11 00
        STA   HMP1                  ; FBF4 85 21
        STA   WSYNC                 ; FBF6 85 02
        STA   HMOVE                 ; FBF8 85 2A
        LDY   $95                   ; FBFA A4 95
        LDA   LFD92,Y               ; FBFC B9 92 FD
        STA   COLUP0                ; FBFF 85 06
        LDA   LFD97,Y               ; FC01 B9 97 FD
        STA   COLUP1                ; FC04 85 07
        LDA   LFD8D,Y               ; FC06 B9 8D FD
        STA   COLUPF                ; FC09 85 08
        STA   HMCLR                 ; FC0B 85 2B
        LDA.w $00E8                 ; FC0D AD E8 00
        STA   $F3                   ; FC10 85 F3
        LDA   #$D5                  ; FC12 A9 D5
        STA   $F5                   ; FC14 85 F5
        STA   $F7                   ; FC16 85 F7
        LDA   #$D5                  ; FC18 A9 D5
        STA   $FF                   ; FC1A 85 FF
        LDA   LFF3F,X               ; FC1C BD 3F FF
        STA   $E8                   ; FC1F 85 E8
        CLC                         ; FC21 18
        LDX   $F1                   ; FC22 A6 F1
        TXA                         ; FC24 8A
        ADC   $E6                   ; FC25 65 E6
        STA   $F8                   ; FC27 85 F8
        LDA   $B5                   ; FC29 A5 B5
        STA   REFP1                 ; FC2B 85 0C
        LDA   LFD78                 ; FC2D AD 78 FD
        STA   COLUBK                ; FC30 85 09
        LDA   $C7                   ; FC32 A5 C7
        STA   $F2                   ; FC34 85 F2
        LDA   $D5                   ; FC36 A5 D5
        STA   $F4                   ; FC38 85 F4
        LDA   $E4                   ; FC3A A5 E4
        STA   $F6                   ; FC3C 85 F6
        LDA   $A4                   ; FC3E A5 A4
        STA   $FE                   ; FC40 85 FE
        LDA   $A3                   ; FC42 A5 A3
        AND   #$04                  ; FC44 29 04
        ASL                         ; FC46 0A
        STA   REFP0                 ; FC47 85 0B
        TXA                         ; FC49 8A
        ADC   $E7                   ; FC4A 65 E7
        STA   $FA                   ; FC4C 85 FA
        TXA                         ; FC4E 8A
        ADC   $E8                   ; FC4F 65 E8
        STA   $FC                   ; FC51 85 FC
        LDA   LFD88,Y               ; FC53 B9 88 FD
        JMP   LF000                 ; FC56 4C 00 F0
        .byte $00,$B1,$8B,$20,$D6,$2C,$C8         ; FC59
LFC60   CLC                         ; FC60 18
        ADC   #$04                  ; FC61 69 04
        CMP   #$8E                  ; FC63 C9 8E
        BCC   LFC69                 ; FC65 90 02
        LDA   #$8E                  ; FC67 A9 8E
LFC69   JMP   LF76F                 ; FC69 4C 6F F7
        .byte $20,$D6,$2C,$C8,$B1,$8B,$20,$D6     ; FC6C
        .byte $2C,$4C,$7A,$2C,$C8,$C8,$C8,$98     ; FC74
        .byte $18,$65,$8B,$85                     ; FC7C
LFC80   .byte $D7,$D7,$D7,$D7,$D7,$D7,$D6,$D6     ; FC80
        .byte $D6,$D6,$D6,$D6,$D6,$D6,$D7,$D7     ; FC88
        .byte $D7,$D7,$D7,$D7,$D7,$2C,$A2,$00     ; FC90
        .byte $A9,$00,$A0,$02,$20,$FA,$2C,$A5     ; FC98
LFCA0   .byte $78,$78,$30,$30,$3F,$3F,$31,$31     ; FCA0
        .byte $7F,$7F,$00,$00,$01,$01,$00,$00     ; FCA8
        .byte $00,$00,$00,$06,$07,$07,$00,$00     ; FCB0
        .byte $7C,$82,$BA,$A2,$BA,$82,$7C,$00     ; FCB8
        .byte $04,$04,$07,$04,$07,$00,$7F,$C3     ; FCC0
        .byte $99,$9F,$9F,$99,$C3,$7F             ; FCC8
LFCCE   .byte $1F,$1F,$06,$06,$06,$86,$86,$86     ; FCCE
        .byte $9F,$1F,$00,$00,$E1,$E1,$C0,$C0     ; FCD6
        .byte $C0,$C0,$C0,$D8,$F9,$F9,$00,$00     ; FCDE
        .byte $45,$45,$49,$71,$71,$49,$45,$00     ; FCE6
        .byte $25,$29,$BD,$A5,$BD,$00,$FF,$86     ; FCEE
        .byte $32,$32,$32,$32,$86,$FF,$85,$AB     ; FCF6
        .byte $48,$98,$3C,$7E,$66,$66,$66,$66     ; FCFE
        .byte $66,$66,$7E,$3C,$7E,$7E,$18,$18     ; FD06
        .byte $18,$18,$18,$38,$38,$18,$7E,$7E     ; FD0E
        .byte $60,$30,$18,$0C,$06,$66,$7E,$3C     ; FD16
        .byte $3C,$7E,$66,$06,$1C,$1C,$06,$66     ; FD1E
        .byte $7E,$3C,$0C,$0C,$7E,$7E,$6C,$6C     ; FD26
        .byte $6C,$6C,$0C,$0C,$3C,$7E,$66,$06     ; FD2E
        .byte $06,$7E,$7C,$60,$7E,$7E,$3C,$7E     ; FD36
        .byte $66,$66,$7E,$7C,$60,$66,$7E,$3C     ; FD3E
        .byte $30,$30,$30,$30,$18,$0C,$06,$66     ; FD46
        .byte $7E,$7E,$3C,$7E,$66,$66,$3C,$3C     ; FD4E
        .byte $66,$66,$7E,$3C,$3C,$7E,$66,$06     ; FD56
        .byte $3E,$7E,$66,$66,$7E,$3C,$00,$00     ; FD5E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; FD66
        .byte $C0,$F0,$FC,$5F,$4F,$7F,$3C,$3E     ; FD6E
        .byte $36,$04                             ; FD76
LFD78   .byte $0C                                 ; FD78
LFD79   .byte $C4,$28,$06                         ; FD79
LFD7C   .byte $00,$42,$42                         ; FD7C
LFD7F   .byte $00,$C2,$74                         ; FD7F
LFD82   .byte $34,$28,$2A                         ; FD82
LFD85   .byte $88,$00,$8A                         ; FD85
LFD88   .byte $72,$A8,$06,$54,$00                 ; FD88
LFD8D   .byte $0C,$84,$96,$0C,$14                 ; FD8D
LFD92   .byte $88,$C4,$42,$00,$88                 ; FD92
LFD97   .byte $D8,$00,$18,$98,$26                 ; FD97
LFD9C   .byte $FF,$C0,$80,$9E,$9F,$9F,$9E,$80     ; FD9C
        .byte $C0,$FF                             ; FDA4
LFDA6   .byte $FF,$E0,$60,$79,$F9,$F9,$79,$60     ; FDA6
        .byte $E0,$FF                             ; FDAE
LFDB0   .byte $FF,$67,$66,$E0,$E0,$E7,$E7,$60     ; FDB0
        .byte $60,$FF                             ; FDB8
LFDBA   .byte $FF,$3C,$78,$39,$19,$99,$99,$18     ; FDBA
        .byte $3C,$FF                             ; FDC2
LFDC4   .byte $FF,$0E,$06,$E6,$FE,$FE,$E7,$07     ; FDC4
        .byte $0F,$FF                             ; FDCC
LFDCE   .byte $FF,$79,$79,$01,$01,$79,$33,$87     ; FDCE
        .byte $CF,$FF                             ; FDD6
LFDD8   .byte $10,$2E,$4C,$6A,$88,$6A,$4C,$2E     ; FDD8
LFDE0   .byte $39,$3D,$45,$41,$4F                 ; FDE0
LFDE5   .byte $00,$FF,$FF,$FF,$00,$01,$01,$01     ; FDE5
LFDED   .byte $FF,$FF,$01,$00,$00,$00,$01,$FF     ; FDED
        .byte $A0,$A0,$A0,$A0,$A0,$C3,$D5,$B3     ; FDF5
        .byte $C6,$A0,$A0                         ; FDFD
LFE00   .byte $9F,$9F,$0C,$0C,$0C,$0C,$0C,$0C     ; FE00
        .byte $9E,$9E,$00,$00,$F9,$F9,$60,$60     ; FE08
        .byte $60,$60,$60,$60,$F9,$F9,$00,$00     ; FE10
        .byte $F4,$14,$14,$15,$17,$16,$F4,$00     ; FE18
        .byte $EF,$01,$CF,$08,$EF,$00,$FF,$04     ; FE20
        .byte $7C,$7C,$7C,$7C,$7C,$FF             ; FE28
LFE2E   .byte $FF,$FF,$FF,$FF,$FF,$03,$01,$02     ; FE2E
        .byte $FF,$05,$07,$06,$FF,$04,$00,$FF     ; FE36
LFE3E   .byte $D8,$D9,$DA,$DC,$DD                 ; FE3E
LFE43   .byte $E3,$E7,$66,$06,$06,$06,$06,$06     ; FE43
        .byte $07,$03,$00,$00,$C7,$C7,$C6,$C6     ; FE4B
        .byte $D6,$FE,$FE,$EE,$C7,$C7,$00,$00     ; FE53
        .byte $51,$51,$D1,$DF,$51,$51,$4E,$00     ; FE5B
        .byte $7A,$42,$73,$43,$7A,$00,$FF,$0C     ; FE63
        .byte $F9,$F9,$19,$F9,$0C,$FF             ; FE6B
LFE71   .byte $F0,$F8,$18,$18,$18,$18,$18,$19     ; FE71
        .byte $F9,$F1,$00,$00,$3F,$3F,$18,$1A     ; FE79
        .byte $1E,$1E,$1A,$18,$3F,$3F,$00,$00     ; FE81
        .byte $45,$45,$45,$55,$7D,$6D,$45,$00     ; FE89
        .byte $49,$C8,$C9,$49,$5D,$00,$FF,$38     ; FE91
        .byte $93,$F3,$F3,$93,$38,$FF             ; FE99
LFE9F   .byte $78,$78,$30,$30,$30,$30,$30,$B6     ; FE9F
        .byte $FE,$FE,$00,$00,$C0,$C0,$C0,$00     ; FEA7
        .byte $00,$00,$00,$C0,$C0,$C0,$00,$00     ; FEAF
        .byte $1F,$11,$01,$1F,$10,$51,$5F,$00     ; FEB7
        .byte $E0,$20,$E0,$00,$E0,$00,$FE,$7F     ; FEBF
        .byte $3F,$3F,$3B,$31,$7B,$FE             ; FEC7
LFECD   .byte $2C,$3C,$4C,$5C,$6C,$5C,$4C,$3C     ; FECD
LFED5   .byte $D7,$D7,$D7,$D7,$D7,$D6,$D6,$D6     ; FED5
        .byte $D6,$D6,$D6,$D6,$D6,$D7,$D7,$D7     ; FEDD
        .byte $D7,$D7,$D7,$D7,$D7,$D7,$D7,$D7     ; FEE5
        .byte $D7,$D7,$D7,$D6,$D6,$D6,$D6,$D6     ; FEED
        .byte $D6,$D6,$D6,$D7,$D7,$D7,$D7,$D7     ; FEF5
        .byte $D7,$D7,$A0                         ; FEFD
LFF00   .byte $D7,$D6,$D6,$D6,$D6,$D6,$D6,$D6     ; FF00
        .byte $D6,$D7,$D7,$D7,$D7,$D7,$D7,$D7     ; FF08
        .byte $D7,$D7,$D7,$D7,$D7                 ; FF10
LFF15   .byte $C4,$C4,$70,$8C,$A8,$C4,$A8,$8C     ; FF15
        .byte $70,$54,$38,$1C,$00,$C4,$C4,$C4     ; FF1D
        .byte $C4,$C4,$C4,$C4,$C4                 ; FF25
LFF2A   .byte $C4,$C4,$C4,$C4,$C4,$C4,$00,$1C     ; FF2A
        .byte $38,$54,$70,$8C,$A8,$C4,$A8,$8C     ; FF32
        .byte $70,$54,$38,$1C,$00                 ; FF3A
LFF3F   .byte $C4,$C4,$A8,$8C,$70,$54,$38,$1C     ; FF3F
        .byte $00,$C4,$C4,$C4,$C4,$C4,$00,$1C     ; FF47
        .byte $38,$54,$70,$8C,$A8                 ; FF4F
LFF54   .byte $FF,$04,$13,$05,$93,$02,$1D,$05     ; FF54
        .byte $9D,$02,$11,$05,$91,$02,$13,$05     ; FF5C
        .byte $93,$02,$13,$05,$93,$02,$14,$05     ; FF64
        .byte $94,$02,$17,$05,$97,$02,$17,$05     ; FF6C
        .byte $97,$02,$18,$05,$18,$02,$1D,$05     ; FF74
        .byte $9D,$02,$1D,$05,$9D,$02,$18,$05     ; FF7C
        .byte $98,$02,$17,$05,$97,$02,$1D,$07     ; FF84
        .byte $00,$03,$12,$FE,$FF,$03,$0C,$FE     ; FF8C
        .byte $FF,$08,$0C,$FE,$FF,$0F,$14,$02     ; FF94
        .byte $84,$02,$18,$02,$88,$02,$FF,$0E     ; FF9C
        .byte $02,$04,$06,$04,$04,$04,$84,$04     ; FFA4
        .byte $FF,$08,$10,$02,$08,$18,$00,$03     ; FFAC
        .byte $08,$02,$90,$01,$0C,$04,$00,$0C     ; FFB4
        .byte $08,$01,$88,$02,$04,$01,$84,$02     ; FFBC
        .byte $00                                 ; FFC4
LFFC5   .byte $00,$04,$04,$04,$00,$FC,$FC,$FC     ; FFC5
LFFCD   .byte $04,$04,$00,$FC,$FC,$FC,$00,$04     ; FFCD
LFFD5   .byte $00,$FC,$FC,$FC,$00,$04,$04,$04     ; FFD5
LFFDD   .byte $FC,$FC,$00,$04,$04,$04,$00,$FC     ; FFDD
        .byte $C2,$C6,$C6,$A0,$BB,$A0,$A0,$A0     ; FFE5
        .byte $C6,$A0,$B0,$A0,$A0,$A0,$A0,$C4     ; FFED
        .byte $A0,$A0,$A0,$A0,$A0,$15,$F0,$15     ; FFF5
        .byte $F0,$27,$F0                         ; FFFD
