; bank 1 org $D000
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
    ORG $1000
    RORG $D000
LD000   JMP   LD00B                 ; D000 4C 0B D0
        .byte $EA,$EA,$EA,$EA,$EA,$6C,$FE,$FF     ; D003
LD00B   BIT   $FFF8                 ; D00B 2C F8 FF
        BIT   $FFF8                 ; D00E 2C F8 FF
LD011   LDY   $80                   ; D011 A4 80
        BNE   LD016                 ; D013 D0 01
        INY                         ; D015 C8
LD016   CLD                         ; D016 D8
        LDX   #$FF                  ; D017 A2 FF
        TXS                         ; D019 9A
        INX                         ; D01A E8
        TXA                         ; D01B 8A
LD01C   STA   VSYNC,X               ; D01C 95 00
        INX                         ; D01E E8
        BNE   LD01C                 ; D01F D0 FB
        STY   $82                   ; D021 84 82
        BEQ   LD000                 ; D023 F0 DB
LD025   LDX   #$03                  ; D025 A2 03
        LDY   #$0F                  ; D027 A0 0F
        STA   COLUBK                ; D029 85 09
        LDA   ($F8),Y               ; D02B B1 F8
        STA   PF0                   ; D02D 85 0D
        LDA   ($F2),Y               ; D02F B1 F2
        STA   GRP1                  ; D031 85 1C
        LDA   ($FA),Y               ; D033 B1 FA
        STA   PF1                   ; D035 85 0E
        LDA   ($FC),Y               ; D037 B1 FC
        STA   PF2                   ; D039 85 0F
        DEY                         ; D03B 88
        STA   CXCLR                 ; D03C 85 2C
        BIT   $85                   ; D03E 24 85
        BPL   LD06E                 ; D040 10 2C
        JMP   LD355                 ; D042 4C 55 D3
LD045   STA   WSYNC                 ; D045 85 02
        LDA   ($F8),Y               ; D047 B1 F8
        STA   PF0                   ; D049 85 0D
        LDA   ($F2),Y               ; D04B B1 F2
        STA   GRP1                  ; D04D 85 1C
        LDA   ($FA),Y               ; D04F B1 FA
        STA   PF1                   ; D051 85 0E
        LDA   ($FC),Y               ; D053 B1 FC
        STA   PF2                   ; D055 85 0F
        DEY                         ; D057 88
        BNE   LD06E                 ; D058 D0 14
        CLC                         ; D05A 18
        LDA   $ED,X                 ; D05B B5 ED
        TAY                         ; D05D A8
        ADC   $E6                   ; D05E 65 E6
        STA   $F8                   ; D060 85 F8
        TYA                         ; D062 98
        ADC   $E7                   ; D063 65 E7
        STA   $FA                   ; D065 85 FA
        TYA                         ; D067 98
        ADC   $E8                   ; D068 65 E8
        STA   $FC                   ; D06A 85 FC
        LDY   #$00                  ; D06C A0 00
LD06E   STA   WSYNC                 ; D06E 85 02
LD070   LDA   ($F2),Y               ; D070 B1 F2
        STA   GRP1                  ; D072 85 1C
        LDA   ($F6),Y               ; D074 B1 F6
        STA   ENAM1                 ; D076 85 1E
        LDA   ($F4),Y               ; D078 B1 F4
        STA   ENAM0                 ; D07A 85 1D
        DEY                         ; D07C 88
        BPL   LD045                 ; D07D 10 C6
        LDY   #$0F                  ; D07F A0 0F
        DEX                         ; D081 CA
        BMI   LD0B4                 ; D082 30 30
        LDA   $C4,X                 ; D084 B5 C4
        STA   $F2                   ; D086 85 F2
        LDA   $D2,X                 ; D088 B5 D2
        STA   $F4                   ; D08A 85 F4
        LDA   $E1,X                 ; D08C B5 E1
        STA   $F6                   ; D08E 85 F6
        LDA   $B2,X                 ; D090 B5 B2
        STA   REFP1                 ; D092 85 0C
        LDA   $BB,X                 ; D094 B5 BB
        BEQ   LD045                 ; D096 F0 AD
        STA   WSYNC                 ; D098 85 02
        SEC                         ; D09A 38
LD09B   SBC   #$0F                  ; D09B E9 0F
        BCS   LD09B                 ; D09D B0 FC
        ASL                         ; D09F 0A
        ASL                         ; D0A0 0A
        ASL                         ; D0A1 0A
        ASL                         ; D0A2 0A
        EOR   #$F0                  ; D0A3 49 F0
        ADC   #$90                  ; D0A5 69 90
        STA.w $0011                 ; D0A7 8D 11 00
        STA   HMP1                  ; D0AA 85 21
        STA   WSYNC                 ; D0AC 85 02
        STA   HMOVE                 ; D0AE 85 2A
        DEY                         ; D0B0 88
        JMP   LD070                 ; D0B1 4C 70 D0
LD0B4   LDA   $C3                   ; D0B4 A5 C3
        STA   $F2                   ; D0B6 85 F2
        LDA   $D1                   ; D0B8 A5 D1
        STA   $F4                   ; D0BA 85 F4
        LDA   $E0                   ; D0BC A5 E0
        STA   $F6                   ; D0BE 85 F6
        LDA   #$04                  ; D0C0 A9 04
        STA   CTRLPF                ; D0C2 85 0A
        LDX   #$03                  ; D0C4 A2 03
        LDA   $B1                   ; D0C6 A5 B1
        STA   REFP1                 ; D0C8 85 0C
        LDA   $BA                   ; D0CA A5 BA
        BEQ   LD0EA                 ; D0CC F0 1C
        STA   WSYNC                 ; D0CE 85 02
        SEC                         ; D0D0 38
LD0D1   SBC   #$0F                  ; D0D1 E9 0F
        BCS   LD0D1                 ; D0D3 B0 FC
        ASL                         ; D0D5 0A
        ASL                         ; D0D6 0A
        ASL                         ; D0D7 0A
        ASL                         ; D0D8 0A
        EOR   #$F0                  ; D0D9 49 F0
        ADC   #$90                  ; D0DB 69 90
        STA.w $0011                 ; D0DD 8D 11 00
        STA   HMP1                  ; D0E0 85 21
        STA   WSYNC                 ; D0E2 85 02
        STA   HMOVE                 ; D0E4 85 2A
        DEY                         ; D0E6 88
        JMP   LD11B                 ; D0E7 4C 1B D1
LD0EA   STA   WSYNC                 ; D0EA 85 02
        LDA   ($F8),Y               ; D0EC B1 F8
        STA   PF0                   ; D0EE 85 0D
        LDA   ($F2),Y               ; D0F0 B1 F2
        STA   GRP1                  ; D0F2 85 1C
        LDA   ($FA),Y               ; D0F4 B1 FA
        STA   PF1                   ; D0F6 85 0E
        LDA   ($FC),Y               ; D0F8 B1 FC
        STA   PF2                   ; D0FA 85 0F
        LDA   ($FE),Y               ; D0FC B1 FE
        STA   GRP0                  ; D0FE 85 1B
        DEY                         ; D100 88
        BNE   LD119                 ; D101 D0 16
        CLC                         ; D103 18
        LDA   $EC                   ; D104 A5 EC
        TAY                         ; D106 A8
        ADC   $E6                   ; D107 65 E6
        STA   $F8                   ; D109 85 F8
        TYA                         ; D10B 98
        ADC   $E7                   ; D10C 65 E7
        STA   $FA                   ; D10E 85 FA
        TYA                         ; D110 98
        ADC   $E8                   ; D111 65 E8
        STA   $FC                   ; D113 85 FC
        LDY   #$00                  ; D115 A0 00
        BEQ   LD11B                 ; D117 F0 02
LD119   STA   WSYNC                 ; D119 85 02
LD11B   LDA   ($F2),Y               ; D11B B1 F2
        STA   GRP1                  ; D11D 85 1C
        LDA   ($F6),Y               ; D11F B1 F6
        STA   ENAM1                 ; D121 85 1E
        LDA   ($F4),Y               ; D123 B1 F4
        STA   ENAM0                 ; D125 85 1D
        LDA   ($FE),Y               ; D127 B1 FE
        STA   GRP0                  ; D129 85 1B
        DEY                         ; D12B 88
        BPL   LD0EA                 ; D12C 10 BC
        LDY   #$0F                  ; D12E A0 0F
        LDA   $C2                   ; D130 A5 C2
        STA   $F2                   ; D132 85 F2
        LDA   $D0                   ; D134 A5 D0
        STA   $F4                   ; D136 85 F4
        LDA   $DF                   ; D138 A5 DF
        STA   $F6                   ; D13A 85 F6
        LDA   $B0                   ; D13C A5 B0
        STA   REFP1                 ; D13E 85 0C
        LDA   $B9                   ; D140 A5 B9
        BEQ   LD160                 ; D142 F0 1C
LD144   STA   WSYNC                 ; D144 85 02
        SEC                         ; D146 38
LD147   SBC   #$0F                  ; D147 E9 0F
        BCS   LD147                 ; D149 B0 FC
        ASL                         ; D14B 0A
        ASL                         ; D14C 0A
        ASL                         ; D14D 0A
        ASL                         ; D14E 0A
        EOR   #$F0                  ; D14F 49 F0
        ADC   #$90                  ; D151 69 90
        STA.w $0011                 ; D153 8D 11 00
        STA   HMP1                  ; D156 85 21
        STA   WSYNC                 ; D158 85 02
        STA   HMOVE                 ; D15A 85 2A
        DEY                         ; D15C 88
        JMP   LD18B                 ; D15D 4C 8B D1
LD160   STA   WSYNC                 ; D160 85 02
        LDA   ($F8),Y               ; D162 B1 F8
        STA   PF0                   ; D164 85 0D
        LDA   ($F2),Y               ; D166 B1 F2
        STA   GRP1                  ; D168 85 1C
        LDA   ($FA),Y               ; D16A B1 FA
        STA   PF1                   ; D16C 85 0E
        LDA   ($FC),Y               ; D16E B1 FC
        STA   PF2                   ; D170 85 0F
        DEY                         ; D172 88
        BNE   LD189                 ; D173 D0 14
        CLC                         ; D175 18
        LDA   $E8,X                 ; D176 B5 E8
        TAY                         ; D178 A8
        ADC   $E6                   ; D179 65 E6
        STA   $F8                   ; D17B 85 F8
        TYA                         ; D17D 98
        ADC   $E7                   ; D17E 65 E7
        STA   $FA                   ; D180 85 FA
        TYA                         ; D182 98
        ADC   $E8                   ; D183 65 E8
        STA   $FC                   ; D185 85 FC
        LDY   #$00                  ; D187 A0 00
LD189   STA   WSYNC                 ; D189 85 02
LD18B   LDA   ($F2),Y               ; D18B B1 F2
        STA   GRP1                  ; D18D 85 1C
        LDA   ($F6),Y               ; D18F B1 F6
        STA   ENAM1                 ; D191 85 1E
        LDA   ($F4),Y               ; D193 B1 F4
        STA   ENAM0                 ; D195 85 1D
        DEY                         ; D197 88
        BPL   LD160                 ; D198 10 C6
        LDY   #$0F                  ; D19A A0 0F
        DEX                         ; D19C CA
        BMI   LD1B6                 ; D19D 30 17
        LDA   $BF,X                 ; D19F B5 BF
        STA   $F2                   ; D1A1 85 F2
        LDA   $CD,X                 ; D1A3 B5 CD
        STA   $F4                   ; D1A5 85 F4
        LDA   $DC,X                 ; D1A7 B5 DC
        STA   $F6                   ; D1A9 85 F6
        LDA   $AD,X                 ; D1AB B5 AD
        STA   REFP1                 ; D1AD 85 0C
        LDA   $B6,X                 ; D1AF B5 B6
        BEQ   LD160                 ; D1B1 F0 AD
        JMP   LD144                 ; D1B3 4C 44 D1
LD1B6   STA   WSYNC                 ; D1B6 85 02
        LDA   LD522                 ; D1B8 AD 22 D5
        STA   COLUBK                ; D1BB 85 09
        LDX   #$00                  ; D1BD A2 00
        STX   PF0                   ; D1BF 86 0D
        STX   GRP1                  ; D1C1 86 1C
        STX   PF1                   ; D1C3 86 0E
        STX   GRP0                  ; D1C5 86 1B
        STX   PF2                   ; D1C7 86 0F
        STX   REFP0                 ; D1C9 86 0B
        STX   REFP1                 ; D1CB 86 0C
        LDA   #$40                  ; D1CD A9 40
        STA   HMP0                  ; D1CF 85 20
        LDA   #$50                  ; D1D1 A9 50
        STA.w $0010                 ; D1D3 8D 10 00
        STA   RESP1                 ; D1D6 85 11
        STA   HMP1                  ; D1D8 85 21
        LDY   $80                   ; D1DA A4 80
        LDA   LD526,Y               ; D1DC B9 26 D5
        STA   COLUPF                ; D1DF 85 08
        LDA   LD529,Y               ; D1E1 B9 29 D5
        STA   COLUP0                ; D1E4 85 06
        STA   COLUP1                ; D1E6 85 07
        LDA   LD523,Y               ; D1E8 B9 23 D5
        STA   WSYNC                 ; D1EB 85 02
        STA   HMOVE                 ; D1ED 85 2A
        STA   COLUBK                ; D1EF 85 09
        LDA   #$01                  ; D1F1 A9 01
        STA   VDELP0                ; D1F3 85 25
        STA   VDELP1                ; D1F5 85 26
        LDA   #$01                  ; D1F7 A9 01
        STA   CTRLPF                ; D1F9 85 0A
        LDX   $95                   ; D1FB A6 95
        LDA   LD326,X               ; D1FD BD 26 D3
        STA   $F3                   ; D200 85 F3
        STA   $F5                   ; D202 85 F5
        STA   $F7                   ; D204 85 F7
        STA   $F9                   ; D206 85 F9
        STA   $FB                   ; D208 85 FB
        STA   $FD                   ; D20A 85 FD
        LDA   #$03                  ; D20C A9 03
        STA   NUSIZ0                ; D20E 85 04
        STA   NUSIZ1                ; D210 85 05
        LDX   #$FF                  ; D212 A2 FF
        CPY   #$01                  ; D214 C0 01
        BCS   LD286                 ; D216 B0 6E
        STA   WSYNC                 ; D218 85 02
        STX   PF2                   ; D21A 86 0F
        LDA   #$09                  ; D21C A9 09
        STA   $FE                   ; D21E 85 FE
        STA   $FF                   ; D220 85 FF
        LDA   INPT4                 ; D222 A5 0C
        ORA   INPT5                 ; D224 05 0D
        BPL   LD257                 ; D226 10 2F
LD228   STA   WSYNC                 ; D228 85 02
        LDY   $FE                   ; D22A A4 FE
        LDA   LD400,Y               ; D22C B9 00 D4
        STA   GRP0                  ; D22F 85 1B
        LDA   LD40A,Y               ; D231 B9 0A D4
        STA   GRP1                  ; D234 85 1C
        LDA   LD414,Y               ; D236 B9 14 D4
        STA   GRP0                  ; D239 85 1B
        LDA   LD432,Y               ; D23B B9 32 D4
        STA   $A2                   ; D23E 85 A2
        LDA   LD41E,Y               ; D240 B9 1E D4
        LDX   LD428,Y               ; D243 BE 28 D4
        LDY   $A2                   ; D246 A4 A2
        STA   GRP1                  ; D248 85 1C
        STX   GRP0                  ; D24A 86 1B
        STY   GRP1                  ; D24C 84 1C
        STX   GRP0                  ; D24E 86 1B
        DEC   $FE                   ; D250 C6 FE
        BPL   LD228                 ; D252 10 D4
        JMP   LD2DB                 ; D254 4C DB D2
LD257   STA   WSYNC                 ; D257 85 02
        LDY   $FE                   ; D259 A4 FE
        LDA   LD59C,Y               ; D25B B9 9C D5
        STA   GRP0                  ; D25E 85 1B
        LDA   LD5A6,Y               ; D260 B9 A6 D5
        STA   GRP1                  ; D263 85 1C
        LDA   LD5B0,Y               ; D265 B9 B0 D5
        STA   GRP0                  ; D268 85 1B
        LDA   LD5CE,Y               ; D26A B9 CE D5
        STA   $A2                   ; D26D 85 A2
        LDA   LD5BA,Y               ; D26F B9 BA D5
        LDX   LD5C4,Y               ; D272 BE C4 D5
        LDY   $A2                   ; D275 A4 A2
        STA   GRP1                  ; D277 85 1C
        STX   GRP0                  ; D279 86 1B
        STY   GRP1                  ; D27B 84 1C
        STX   GRP0                  ; D27D 86 1B
        DEC   $FE                   ; D27F C6 FE
        BPL   LD257                 ; D281 10 D4
        JMP   LD2DB                 ; D283 4C DB D2
LD286   LDY   $96                   ; D286 A4 96
        LDA   LD30D,Y               ; D288 B9 0D D3
        TAY                         ; D28B A8
        STA   WSYNC                 ; D28C 85 02
        STX   PF2                   ; D28E 86 0F
        LDA   LD32B,Y               ; D290 B9 2B D3
        STA   $F2                   ; D293 85 F2
        LDA   LD332,Y               ; D295 B9 32 D3
        STA   $F4                   ; D298 85 F4
        LDA   LD339,Y               ; D29A B9 39 D3
        STA   $F6                   ; D29D 85 F6
        LDA   LD340,Y               ; D29F B9 40 D3
        STA   $F8                   ; D2A2 85 F8
        LDA   LD347,Y               ; D2A4 B9 47 D3
        STA   $FA                   ; D2A7 85 FA
        LDA   LD34E,Y               ; D2A9 B9 4E D3
        STA   $FC                   ; D2AC 85 FC
        LDA   #$09                  ; D2AE A9 09
        STA   $FE                   ; D2B0 85 FE
        STA   $FF                   ; D2B2 85 FF
LD2B4   LDY   $FE                   ; D2B4 A4 FE
        LDA   ($FC),Y               ; D2B6 B1 FC
        STA   WSYNC                 ; D2B8 85 02
        STA   $A2                   ; D2BA 85 A2
        LDA   ($F2),Y               ; D2BC B1 F2
        STA   GRP0                  ; D2BE 85 1B
        LDA   ($F4),Y               ; D2C0 B1 F4
        STA   GRP1                  ; D2C2 85 1C
        LDA   ($F6),Y               ; D2C4 B1 F6
        STA   GRP0                  ; D2C6 85 1B
        LDA   ($FA),Y               ; D2C8 B1 FA
        TAX                         ; D2CA AA
        LDA   ($F8),Y               ; D2CB B1 F8
        LDY   $A2                   ; D2CD A4 A2
        STA   GRP1                  ; D2CF 85 1C
        STX   GRP0                  ; D2D1 86 1B
        STY   GRP1                  ; D2D3 84 1C
        STX   GRP0                  ; D2D5 86 1B
        DEC   $FE                   ; D2D7 C6 FE
        BPL   LD2B4                 ; D2D9 10 D9
LD2DB   LDA   #$00                  ; D2DB A9 00
        STA   WSYNC                 ; D2DD 85 02
        STA   GRP0                  ; D2DF 85 1B
        STA   GRP1                  ; D2E1 85 1C
        STA   GRP0                  ; D2E3 85 1B
        STA   GRP1                  ; D2E5 85 1C
        STA   VDELP0                ; D2E7 85 25
        STA   VDELP1                ; D2E9 85 26
        STA   NUSIZ0                ; D2EB 85 04
        STA   NUSIZ1                ; D2ED 85 05
        STA   REFP0                 ; D2EF 85 0B
        STA   REFP1                 ; D2F1 85 0C
        STA   ENAM0                 ; D2F3 85 1D
        STA   ENAM1                 ; D2F5 85 1E
        STA   WSYNC                 ; D2F7 85 02
        STA   CTRLPF                ; D2F9 85 0A
        STA   PF2                   ; D2FB 85 0F
        STA   PF1                   ; D2FD 85 0E
        STA   PF0                   ; D2FF 85 0D
        STA   ENABL                 ; D301 85 1F
        LDA   LD522                 ; D303 AD 22 D5
        STA   WSYNC                 ; D306 85 02
        STA   COLUBK                ; D308 85 09
        JMP   LD000                 ; D30A 4C 00 D0
LD30D   .byte $00,$01,$01,$01,$01,$02,$02,$02     ; D30D
        .byte $02,$03,$03,$03,$03,$04,$04,$04     ; D315
        .byte $04,$05,$05,$05,$05,$06,$06,$06     ; D31D
        .byte $06                                 ; D325
LD326   .byte $D8,$D9,$DA,$DC,$DD                 ; D326
LD32B   .byte $00,$00,$00,$00,$00,$00,$4C         ; D32B
LD332   .byte $00,$00,$00,$4D,$4D,$4D,$4D         ; D332
LD339   .byte $00,$00,$4C,$4C,$4C,$4C,$4C         ; D339
LD340   .byte $00,$4D,$4D,$4D,$4D,$4D,$4D         ; D340
LD347   .byte $00,$00,$00,$00,$4C,$4C,$4C         ; D347
LD34E   .byte $00,$00,$00,$00,$00,$4D,$4D         ; D34E
LD355   LDY   #$3F                  ; D355 A0 3F
LD357   STA   WSYNC                 ; D357 85 02
        LDA   #$00                  ; D359 A9 00
        STA   PF0                   ; D35B 85 0D
        STA   PF1                   ; D35D 85 0E
        STA   PF2                   ; D35F 85 0F
        STA   GRP1                  ; D361 85 1C
        STA   ENAM0                 ; D363 85 1D
        STA   ENAM1                 ; D365 85 1E
        DEY                         ; D367 88
        BNE   LD357                 ; D368 D0 ED
        LDY   #$0F                  ; D36A A0 0F
        LDX   #$06                  ; D36C A2 06
        LDA   $81                   ; D36E A5 81
        AND   #$F0                  ; D370 29 F0
        ORA   #$04                  ; D372 09 04
        STA   $F2                   ; D374 85 F2
        LDA   $81                   ; D376 A5 81
        LSR                         ; D378 4A
        LSR                         ; D379 4A
        STA   $A2                   ; D37A 85 A2
LD37C   STA   WSYNC                 ; D37C 85 02
        LDA   ($FE),Y               ; D37E B1 FE
        STA   GRP0                  ; D380 85 1B
        LDA   #$0E                  ; D382 A9 0E
        STA   COLUP0                ; D384 85 06
        DEY                         ; D386 88
        DEX                         ; D387 CA
        BNE   LD37C                 ; D388 D0 F2
        LDX   #$04                  ; D38A A2 04
LD38C   STA   WSYNC                 ; D38C 85 02
        LDA   ($FE),Y               ; D38E B1 FE
        STA   GRP0                  ; D390 85 1B
        LDA   $F2                   ; D392 A5 F2
        LSR   $A2                   ; D394 46 A2
        BCC   LD39A                 ; D396 90 02
        ORA   #$08                  ; D398 09 08
LD39A   STA   COLUBK                ; D39A 85 09
        DEY                         ; D39C 88
        DEX                         ; D39D CA
        BNE   LD38C                 ; D39E D0 EC
        LDX   $95                   ; D3A0 A6 95
        LDA   LD3EE,X               ; D3A2 BD EE D3
        STA   WSYNC                 ; D3A5 85 02
        STA   COLUBK                ; D3A7 85 09
        LDA   ($FE),Y               ; D3A9 B1 FE
        STA   GRP0                  ; D3AB 85 1B
        DEY                         ; D3AD 88
LD3AE   STA   WSYNC                 ; D3AE 85 02
        LDA   ($FE),Y               ; D3B0 B1 FE
        STA   GRP0                  ; D3B2 85 1B
        DEY                         ; D3B4 88
        BPL   LD3AE                 ; D3B5 10 F7
        LDY   #$40                  ; D3B7 A0 40
        LDA   $81                   ; D3B9 A5 81
        AND   #$03                  ; D3BB 29 03
        BNE   LD3D0                 ; D3BD D0 11
        LDA   $81                   ; D3BF A5 81
        LSR                         ; D3C1 4A
        LSR                         ; D3C2 4A
        AND   #$01                  ; D3C3 29 01
        TAX                         ; D3C5 AA
        LDA   #$67                  ; D3C6 A9 67
        STA   $97,X                 ; D3C8 95 97
        LDA   #$00                  ; D3CA A9 00
        STA   $99,X                 ; D3CC 95 99
        STA   $9B,X                 ; D3CE 95 9B
LD3D0   STA   WSYNC                 ; D3D0 85 02
        DEY                         ; D3D2 88
        BNE   LD3D0                 ; D3D3 D0 FB
        STY   GRP0                  ; D3D5 84 1B
        STY   GRP1                  ; D3D7 84 1C
        STY   ENAM0                 ; D3D9 84 1D
        STY   ENAM1                 ; D3DB 84 1E
        STY   ENABL                 ; D3DD 84 1F
        STY   VDELP0                ; D3DF 84 25
        STY   VDELP1                ; D3E1 84 26
        STY   REFP0                 ; D3E3 84 0B
        STY   REFP1                 ; D3E5 84 0C
        STY   NUSIZ0                ; D3E7 84 04
        STY   NUSIZ1                ; D3E9 84 05
        JMP   LD1B6                 ; D3EB 4C B6 D1
LD3EE   .byte $72,$A8,$06,$54,$00,$E5,$90,$F5     ; D3EE
        .byte $82,$85,$F0,$E5,$90,$F5,$E8,$89     ; D3F6
        .byte $89,$C5                             ; D3FE
LD400   .byte $03,$04,$09,$0A,$0A,$0A,$0A,$49     ; D400
        .byte $E4,$43                             ; D408
LD40A   .byte $C3,$23,$90,$50,$10,$10,$50,$91     ; D40A
        .byte $21,$C0                             ; D412
LD414   .byte $F1,$F3,$C3,$C0,$C1,$C3,$C3,$C3     ; D414
        .byte $C3,$C1                             ; D41C
LD41E   .byte $E1,$F3,$33,$33,$F1,$F1,$33,$33     ; D41E
        .byte $F3,$E1                             ; D426
LD428   .byte $E1,$F3,$33,$30,$E0,$E0,$30,$33     ; D428
        .byte $F3,$E1                             ; D430
LD432   .byte $E0,$F0,$30,$30,$E0,$E0,$30,$30     ; D432
        .byte $F0,$E0,$B1,$A0,$C5,$A0,$A0,$B1     ; D43A
        .byte $A0,$B7,$A0,$A0,$A0,$A0,$A0,$B1     ; D442
        .byte $BA,$A0,$A0,$A0,$A0,$A0,$A0,$A0     ; D44A
        .byte $A0,$80,$B4,$A0,$A0,$A0,$F7,$A0     ; D452
        .byte $A0,$A0,$A0,$B9,$BB,$A0,$AC,$A0     ; D45A
        .byte $A0,$D5,$A0,$A0,$C6,$A0,$A0,$A0     ; D462
        .byte $A0,$A0,$A0,$B3,$A0,$A5,$CF,$A0     ; D46A
        .byte $A0,$D9,$A0,$A0,$FF,$A0,$AA,$A0     ; D472
        .byte $A0,$B4,$A0,$B1,$A0,$A0,$A0,$A0     ; D47A
        .byte $B1,$A0,$B8,$A0,$A0,$A0,$A0,$A0     ; D482
        .byte $A0,$BA,$A0,$A0,$D2,$A0,$A0,$A0     ; D48A
        .byte $FF,$A0,$80,$A0,$A0,$A0,$A0,$FF     ; D492
        .byte $B1,$A0,$A0,$A0,$A0,$A0,$A0,$A0     ; D49A
        .byte $A0,$A0,$C2,$A0,$A0,$C6,$A0,$AC     ; D4A2
        .byte $C3,$A0,$A0,$D0,$A0,$A0,$E0,$CF     ; D4AA
        .byte $A0,$A0,$A0,$A0,$A0,$B4,$A0,$A4     ; D4B2
        .byte $CF,$A0,$B7,$A0,$B1,$A0,$A0,$A0     ; D4BA
        .byte $A0,$A0,$A0,$B8,$A0,$A0,$A0,$C5     ; D4C2
        .byte $A0,$A0,$BA,$A0,$A0,$D2,$A0,$A0     ; D4CA
        .byte $A0,$FF,$A0,$80,$A0,$A0,$A0,$A0     ; D4D2
        .byte $FF,$B1,$A0,$A0,$D1,$A0,$A0,$A0     ; D4DA
        .byte $A0,$A0,$A0,$C2,$A0,$A0,$B3,$A0     ; D4E2
        .byte $AC,$A0,$A0,$A0,$A0,$A0,$A0,$E0     ; D4EA
        .byte $A0,$A0,$A0,$A0,$A0,$A0,$B4,$A0     ; D4F2
        .byte $A0,$CF,$A0,$A0,$A0,$C5,$00,$00     ; D4FA
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D502
        .byte $00,$00,$00,$00,$00,$00,$02,$02     ; D50A
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D512
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D51A
LD522   .byte $0C                                 ; D522
LD523   .byte $C4,$00,$06                         ; D523
LD526   .byte $42,$28,$98                         ; D526
LD529   .byte $08,$42,$00,$00,$10,$7C,$38,$10     ; D529
        .byte $54,$FE,$FE,$7C,$6C,$28,$38,$38     ; D531
        .byte $10,$10,$00,$00,$00,$00,$4C,$CC     ; D539
        .byte $FC,$3C,$FE,$FE,$72,$1B,$07,$01     ; D541
        .byte $00,$00,$00,$00,$00,$00,$00,$20     ; D549
        .byte $30,$78,$3C,$FF,$FE,$F8,$B0,$20     ; D551
        .byte $00,$00,$00,$00,$00,$00,$03,$0F     ; D559
        .byte $3F,$FA,$F2,$FE,$3C,$7C,$6C,$20     ; D561
        .byte $00,$00,$00,$00,$08,$08,$1C,$1C     ; D569
        .byte $14,$36,$3E,$7F,$7F,$2A,$08,$1C     ; D571
        .byte $3E,$08,$00,$00,$20,$84,$40,$1D     ; D579
        .byte $AE,$3A,$5D,$2C,$3A,$54,$2D,$42     ; D581
        .byte $10,$80,$00,$00,$00,$00,$00,$00     ; D589
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D591
        .byte $00,$00,$00                         ; D599
LD59C   .byte $FF,$80,$A8,$A8,$A8,$B8,$A8,$A8     ; D59C
        .byte $80,$FF                             ; D5A4
LD5A6   .byte $FF,$00,$8E,$8A,$8A,$EA,$AA,$EA     ; D5A6
        .byte $00,$FF                             ; D5AE
LD5B0   .byte $FF,$00,$4A,$4A,$4A,$4E,$4A,$EA     ; D5B0
        .byte $00,$FF                             ; D5B8
LD5BA   .byte $FF,$00,$E8,$A8,$A8,$AE,$A8,$AE     ; D5BA
        .byte $00,$FF                             ; D5C2
LD5C4   .byte $FF,$00,$87,$85,$81,$E1,$81,$E1     ; D5C4
        .byte $00,$FF                             ; D5CC
LD5CE   .byte $FF,$01,$55,$51,$61,$71,$51,$71     ; D5CE
        .byte $01,$FF,$B6,$A0,$C1,$A0,$A0,$A0     ; D5D6
        .byte $A0,$B0,$A0,$C4,$A0,$C6,$A0,$A0     ; D5DE
        .byte $A0,$A0,$BA,$A0,$A0,$A0,$A0,$A0     ; D5E6
        .byte $B9,$A0,$A0,$80,$A0,$A0,$A0,$A0     ; D5EE
        .byte $F7,$C6,$A0,$A0,$A0,$C1,$A0,$A0     ; D5F6
        .byte $A0,$B5,$00,$00,$00,$00,$00,$00     ; D5FE
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D606
        .byte $00,$00,$00,$00,$00,$00,$80,$80     ; D60E
        .byte $80,$80,$00,$00,$00,$00,$00,$00     ; D616
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D61E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D626
        .byte $80,$80,$C0,$C0,$C0,$C0,$80,$80     ; D62E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D636
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D63E
        .byte $00,$00,$80,$80,$C0,$C0,$E0,$E0     ; D646
        .byte $E0,$E0,$C0,$C0,$80,$80,$00,$00     ; D64E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D656
        .byte $00,$00,$00,$00,$00,$00,$40,$40     ; D65E
        .byte $E0,$E0,$F0,$F0,$F0,$F0,$E0,$E0     ; D666
        .byte $C0,$C0,$00,$00,$00,$00,$00,$00     ; D66E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D676
        .byte $00,$00,$A0,$A0,$F0,$F0,$F8,$F8     ; D67E
        .byte $F8,$F8,$F0,$F0,$E0,$E0,$00,$00     ; D686
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D68E
        .byte $00,$00,$00,$00,$00,$00,$D0,$D0     ; D696
        .byte $F8,$F8,$FC,$FC,$FC,$FC,$F8,$F8     ; D69E
        .byte $70,$70,$00,$00,$00,$00,$00,$00     ; D6A6
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D6AE
        .byte $00,$00,$68,$68,$FC,$FC,$FE,$FE     ; D6B6
        .byte $FE,$FE,$7C,$7C,$38,$38,$00,$00     ; D6BE
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D6C6
        .byte $00,$00,$00,$00,$00,$00,$34,$34     ; D6CE
        .byte $7E,$7E,$FF,$FF,$7F,$7F,$3E,$3E     ; D6D6
        .byte $1C,$1C,$00,$00,$00,$00,$00,$00     ; D6DE
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D6E6
        .byte $00,$00,$A0,$A0,$B0,$A0,$AC,$A0     ; D6EE
        .byte $A0,$A0,$A0,$A0,$A0,$8C,$A0,$A0     ; D6F6
        .byte $B4,$B6,$00,$00,$00,$00,$00,$00     ; D6FE
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D706
        .byte $00,$00,$00,$00,$00,$00,$01,$01     ; D70E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D716
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D71E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D726
        .byte $01,$01,$03,$03,$01,$01,$00,$00     ; D72E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D736
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D73E
        .byte $00,$00,$01,$01,$03,$03,$07,$07     ; D746
        .byte $03,$03,$01,$01,$00,$00,$00,$00     ; D74E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D756
        .byte $00,$00,$00,$00,$00,$00,$03,$03     ; D75E
        .byte $07,$07,$0F,$0F,$07,$07,$03,$03     ; D766
        .byte $01,$01,$00,$00,$00,$00,$00,$00     ; D76E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D776
        .byte $00,$00,$06,$06,$0F,$0F,$1F,$1F     ; D77E
        .byte $0F,$0F,$07,$07,$03,$03,$00,$00     ; D786
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D78E
        .byte $00,$00,$00,$00,$00,$00,$0D,$0D     ; D796
        .byte $1F,$1F,$3F,$3F,$1F,$1F,$0F,$0F     ; D79E
        .byte $07,$07,$00,$00,$00,$00,$00,$00     ; D7A6
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D7AE
        .byte $00,$00,$1A,$1A,$3F,$3F,$7F,$7F     ; D7B6
        .byte $3F,$3F,$1F,$1F,$0E,$0E,$00,$00     ; D7BE
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D7C6
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D7CE
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D7D6
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D7DE
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D7E6
        .byte $00,$00,$C2,$A0,$B7,$A0,$A0,$A0     ; D7EE
        .byte $A0,$B0,$A0,$C4,$A0,$B0,$A0,$B0     ; D7F6
        .byte $A0,$C5,$00,$00,$00,$00,$00,$00     ; D7FE
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D806
        .byte $00,$00,$00,$00,$18,$3C,$3C,$18     ; D80E
        .byte $18,$FF,$5A,$FF,$FF,$00,$00,$00     ; D816
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D81E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D826
        .byte $00,$00,$64,$F2,$B9,$1C,$06,$07     ; D82E
        .byte $17,$09,$04,$02,$00,$00,$00,$00     ; D836
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D83E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D846
        .byte $00,$1E,$04,$7F,$FF,$F5,$84,$9F     ; D84E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D856
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D85E
        .byte $00,$00,$00,$00,$00,$04,$02,$13     ; D866
        .byte $07,$0E,$1C,$35,$62,$64,$48,$40     ; D86E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D876
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D87E
        .byte $00,$00,$00,$00,$FF,$5A,$FF,$FF     ; D886
        .byte $18,$18,$3C,$3C,$18,$00,$00,$00     ; D88E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D896
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D89E
        .byte $00,$20,$84,$40,$1D,$AE,$3A,$5D     ; D8A6
        .byte $2C,$3A,$54,$2D,$42,$10,$80,$00     ; D8AE
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D8B6
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D8BE
        .byte $00,$0C,$0C,$00,$0C,$1E,$BF,$FF     ; D8C6
        .byte $7F,$FF,$BF,$1E,$0C,$00,$00,$00     ; D8CE
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D8D6
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D8DE
        .byte $A0,$A0,$B0,$A0,$A0,$A0,$A0,$A0     ; D8E6
        .byte $A0,$80,$A0,$FF,$A0,$A0,$A0,$A0     ; D8EE
        .byte $C4,$A0,$A0,$C4,$A0,$A0,$80,$A0     ; D8F6
        .byte $A0,$A0,$00,$00,$00,$00,$00,$00     ; D8FE
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D906
        .byte $00,$00,$00,$00,$10,$38,$10,$10     ; D90E
        .byte $10,$FE,$FE,$10,$10,$00,$00,$00     ; D916
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D91E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D926
        .byte $00,$00,$00,$60,$F4,$FC,$9E,$0E     ; D92E
        .byte $0F,$01,$00,$00,$00,$00,$00,$00     ; D936
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D93E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D946
        .byte $00,$00,$08,$1C,$7F,$FF,$D8,$90     ; D94E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D956
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D95E
        .byte $00,$00,$00,$00,$00,$00,$01,$0F     ; D966
        .byte $0E,$0E,$1E,$30,$60,$60,$60,$20     ; D96E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D976
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D97E
        .byte $00,$00,$00,$00,$10,$10,$FE,$FE     ; D986
        .byte $10,$10,$10,$38,$10,$00,$00,$00     ; D98E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D996
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D99E
        .byte $00,$20,$84,$40,$1D,$AE,$3A,$5D     ; D9A6
        .byte $2C,$3A,$54,$2D,$42,$10,$80,$00     ; D9AE
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D9B6
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D9BE
        .byte $00,$04,$04,$0C,$4C,$7C,$4F,$9D     ; D9C6
        .byte $9E,$F8,$98,$10,$10,$00,$00,$00     ; D9CE
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; D9D6
        .byte $00,$00,$00,$00,$00,$00,$A0,$BA     ; D9DE
        .byte $A0,$A0,$A0,$A0,$A0,$A0,$FF,$A0     ; D9E6
        .byte $80,$CD,$C4,$A0,$A0,$FF,$A0,$A0     ; D9EE
        .byte $A0,$C6,$B0,$A0,$A0,$AC,$B5,$BA     ; D9F6
        .byte $A0,$AC,$00,$00,$00,$00,$00,$00     ; D9FE
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DA06
        .byte $00,$00,$00,$00,$00,$44,$38,$38     ; DA0E
        .byte $7C,$44,$38,$10,$F0,$00,$00,$00     ; DA16
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DA1E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DA26
        .byte $00,$00,$00,$07,$1A,$0F,$39,$FE     ; DA2E
        .byte $98,$8B,$0C,$00,$00,$00,$00,$00     ; DA36
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DA3E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DA46
        .byte $00,$1F,$0A,$FF,$99,$9E,$08,$F0     ; DA4E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DA56
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DA5E
        .byte $00,$00,$00,$00,$00,$00,$00,$07     ; DA66
        .byte $1A,$0F,$39,$FE,$98,$8B,$0C,$00     ; DA6E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DA76
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DA7E
        .byte $00,$00,$00,$00,$00,$44,$38,$38     ; DA86
        .byte $7C,$44,$38,$10,$F0,$00,$00,$00     ; DA8E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DA96
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DA9E
        .byte $00,$20,$84,$40,$1D,$AE,$3A,$5D     ; DAA6
        .byte $2C,$3A,$54,$2D,$42,$10,$80,$00     ; DAAE
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DAB6
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DABE
        .byte $00,$00,$E7,$42,$7F,$FF,$F5,$D5     ; DAC6
        .byte $DE,$E4,$5C,$C0,$00,$00,$00,$00     ; DACE
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DAD6
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DADE
        .byte $C1,$A0,$A0,$A0,$A0,$B0,$AC,$C4     ; DAE6
        .byte $A0,$A0,$A0,$A0,$C3,$A0,$80,$A0     ; DAEE
        .byte $FF,$A0,$A0,$A0,$A0,$80,$AC,$A0     ; DAF6
        .byte $FF,$A0,$00,$00,$00,$00,$00,$00     ; DAFE
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DB06
        .byte $00,$00,$00,$00,$00,$44,$38,$38     ; DB0E
        .byte $7C,$44,$38,$10,$0F,$00,$00,$00     ; DB16
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DB1E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DB26
        .byte $00,$00,$00,$07,$1A,$0F,$39,$FE     ; DB2E
        .byte $98,$88,$18,$60,$00,$00,$00,$00     ; DB36
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DB3E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DB46
        .byte $00,$1F,$0A,$FF,$99,$9E,$08,$0F     ; DB4E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DB56
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DB5E
        .byte $00,$00,$00,$00,$00,$00,$00,$07     ; DB66
        .byte $1A,$0F,$39,$FE,$98,$88,$18,$60     ; DB6E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DB76
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DB7E
        .byte $00,$00,$00,$00,$00,$44,$38,$38     ; DB86
        .byte $7C,$44,$38,$10,$0F,$00,$00,$00     ; DB8E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DB96
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DB9E
        .byte $00,$20,$84,$40,$1D,$AE,$3A,$5D     ; DBA6
        .byte $2C,$3A,$54,$2D,$42,$10,$80,$00     ; DBAE
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DBB6
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DBBE
        .byte $00,$00,$E7,$42,$7F,$FF,$F5,$D5     ; DBC6
        .byte $DE,$E4,$47,$60,$00,$00,$00,$00     ; DBCE
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DBD6
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DBDE
        .byte $A0,$C5,$A0,$AC,$A0,$A0,$A0,$A0     ; DBE6
        .byte $A0,$C4,$A0,$A0,$C2,$A0,$A0,$C4     ; DBEE
        .byte $A0,$80,$C5,$A0,$A0,$A0,$A0,$A0     ; DBF6
        .byte $A0,$B6,$00,$00,$00,$00,$00,$00     ; DBFE
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DC06
        .byte $00,$00,$00,$00,$2A,$1C,$08,$49     ; DC0E
        .byte $7F,$3E,$14,$08,$08,$00,$00,$00     ; DC16
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DC1E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DC26
        .byte $00,$00,$00,$6C,$FC,$BC,$1C,$3C     ; DC2E
        .byte $3E,$03,$00,$00,$00,$00,$00,$00     ; DC36
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DC3E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DC46
        .byte $00,$00,$30,$38,$7F,$FE,$B8,$B0     ; DC4E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DC56
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DC5E
        .byte $00,$00,$00,$00,$00,$00,$00,$03     ; DC66
        .byte $7E,$7C,$3C,$7C,$4C,$4C,$00,$00     ; DC6E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DC76
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DC7E
        .byte $00,$00,$00,$00,$08,$08,$14,$3E     ; DC86
        .byte $7F,$49,$08,$1C,$2A,$00,$00,$00     ; DC8E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DC96
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DC9E
        .byte $00,$20,$84,$40,$1D,$AE,$3A,$5D     ; DCA6
        .byte $2C,$3A,$54,$2D,$42,$10,$80,$00     ; DCAE
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DCB6
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DCBE
        .byte $00,$00,$00,$04,$0C,$7F,$F3,$7F     ; DCC6
        .byte $FE,$C0,$C0,$80,$80,$00,$00,$00     ; DCCE
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DCD6
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DCDE
        .byte $A0,$B0,$B8,$B0,$A0,$A0,$A0,$AD     ; DCE6
        .byte $A0,$A0,$B4,$A0,$A0,$A0,$A0,$B9     ; DCEE
        .byte $A0,$A0,$A0,$A0,$A0,$A0,$AC,$A0     ; DCF6
        .byte $A0,$C3,$00,$00,$00,$00,$00,$00     ; DCFE
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DD06
        .byte $00,$00,$00,$00,$00,$3C,$7E,$D5     ; DD0E
        .byte $FF,$7E,$3C,$18,$00,$00,$00,$00     ; DD16
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DD1E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DD26
        .byte $00,$00,$00,$3C,$7E,$D5,$FF,$7E     ; DD2E
        .byte $3C,$18,$00,$00,$00,$00,$00,$00     ; DD36
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DD3E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DD46
        .byte $00,$3C,$7E,$D5,$FF,$7E,$3C,$18     ; DD4E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DD56
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DD5E
        .byte $00,$00,$00,$00,$00,$00,$00,$3C     ; DD66
        .byte $7E,$D5,$FF,$7E,$3C,$18,$00,$00     ; DD6E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DD76
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DD7E
        .byte $00,$00,$00,$00,$00,$3C,$7E,$D5     ; DD86
        .byte $FF,$7E,$3C,$18,$00,$00,$00,$00     ; DD8E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DD96
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DD9E
        .byte $00,$20,$84,$40,$1D,$AE,$3A,$5D     ; DDA6
        .byte $2C,$3A,$54,$2D,$42,$10,$80,$00     ; DDAE
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DDB6
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DDBE
        .byte $00,$00,$3C,$7E,$7E,$D5,$AB,$7E     ; DDC6
        .byte $7E,$D5,$AB,$7E,$7E,$3C,$00,$00     ; DDCE
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DDD6
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DDDE
        .byte $B7,$A0,$A0,$A0,$A0,$A0,$A0,$B0     ; DDE6
        .byte $C2,$82,$A0,$A0,$A0,$A0,$C1,$A0     ; DDEE
        .byte $C4,$A0,$B0,$A0,$A0,$C5,$E0,$A0     ; DDF6
        .byte $AA,$A0,$00,$00,$00,$00,$00,$00     ; DDFE
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DE06
        .byte $00,$00,$00,$00,$00,$3C,$7E,$AB     ; DE0E
        .byte $FF,$7E,$3C,$18,$00,$00,$00,$00     ; DE16
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DE1E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DE26
        .byte $00,$00,$00,$3C,$7E,$AB,$FF,$7E     ; DE2E
        .byte $3C,$18,$00,$00,$00,$00,$00,$00     ; DE36
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DE3E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DE46
        .byte $00,$3C,$7E,$AB,$FF,$7E,$3C,$18     ; DE4E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DE56
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DE5E
        .byte $00,$00,$00,$00,$00,$00,$00,$3C     ; DE66
        .byte $7E,$AB,$FF,$7E,$3C,$18,$00,$00     ; DE6E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DE76
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DE7E
        .byte $00,$00,$00,$00,$00,$3C,$7E,$AB     ; DE86
        .byte $FF,$7E,$3C,$18,$00,$00,$00,$00     ; DE8E
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DE96
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DE9E
        .byte $00,$20,$84,$40,$1D,$AE,$3A,$5D     ; DEA6
        .byte $2C,$3A,$54,$2D,$42,$10,$80,$00     ; DEAE
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DEB6
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DEBE
        .byte $00,$00,$3C,$7E,$7E,$AB,$D5,$7E     ; DEC6
        .byte $7E,$AB,$D5,$7E,$7E,$3C,$00,$00     ; DECE
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DED6
        .byte $00,$00,$00,$00,$00,$00,$00,$00     ; DEDE
        .byte $A0,$A0,$BA,$A0,$B9,$A0,$A0,$A0     ; DEE6
        .byte $A0,$A0,$A0,$BA,$B0,$AC,$B4,$B0     ; DEEE
        .byte $A0,$B5,$B0,$A0,$A0,$A0,$B0,$A0     ; DEF6
        .byte $A0,$A0,$A0,$A0,$BA,$A0,$B6,$A0     ; DEFE
        .byte $A0,$A0,$A0,$C4,$A0,$BA,$A0,$A0     ; DF06
        .byte $A0,$A0,$A0,$A0,$B0,$A0,$A0,$A0     ; DF0E
        .byte $A0,$B4,$A0,$A0,$A0,$FF,$A0,$D1     ; DF16
        .byte $B9,$A0,$80,$AC,$FF,$A0,$A0,$A0     ; DF1E
        .byte $AD,$B0,$A0,$AC,$C5,$A0,$A0,$D5     ; DF26
        .byte $C2,$A0,$C4,$A0,$A0,$A0,$A0,$A0     ; DF2E
        .byte $A0,$FF,$A0,$E0,$A0,$A0,$A0,$A0     ; DF36
        .byte $FF,$A0,$A0,$A0,$A0,$BA,$A0,$B6     ; DF3E
        .byte $A0,$C5,$AD,$A0,$A0,$AD,$BA,$A0     ; DF46
        .byte $AC,$A0,$A0,$A0,$A0,$A0,$A0,$A0     ; DF4E
        .byte $A0,$A0,$A0,$A0,$A0,$A0,$FF,$A0     ; DF56
        .byte $D1,$B9,$A0,$98,$A0,$FF,$A0,$C2     ; DF5E
        .byte $B0,$A0,$B0,$A4,$A0,$A0,$A0,$A0     ; DF66
        .byte $A0,$C5,$AC,$C4,$A0,$A0,$C1,$A0     ; DF6E
        .byte $A0,$A0,$FF,$A0,$E0,$A0,$A0,$A0     ; DF76
        .byte $A0,$FF,$A0,$A0,$A0,$A0,$BA,$A0     ; DF7E
        .byte $B6,$A0,$C5,$A0,$A0,$A0,$A0,$BA     ; DF86
        .byte $C4,$A0,$B4,$B0,$A0,$B7,$A0,$A0     ; DF8E
        .byte $C5,$A0,$A0,$A0,$A0,$94,$A0,$FF     ; DF96
        .byte $A0,$C6,$B9,$A0,$80,$A0,$A0,$A0     ; DF9E
        .byte $C2,$B0,$A0,$B0,$A0,$A0,$A0,$A0     ; DFA6
        .byte $A0,$A0,$C5,$A0,$C4,$A0,$A0,$C1     ; DFAE
        .byte $A0,$A0,$D6,$FF,$A0,$82,$A0,$A0     ; DFB6
        .byte $A0,$A0,$C2,$A0,$A0,$A0,$A0,$BA     ; DFBE
        .byte $A0,$B9,$A0,$A0,$A0,$A0,$A0,$A0     ; DFC6
        .byte $BA,$AA,$A0,$B4,$A0,$A0,$B8,$A0     ; DFCE
        .byte $A0,$C5,$A0,$A0,$A0,$A0,$94,$A0     ; DFD6
        .byte $FF,$A0,$A0,$B9,$A0,$80,$A0,$B0     ; DFDE
        .byte $A0,$A0,$B0,$A0,$A0,$A0,$A0,$CD     ; DFE6
        .byte $A0,$A0,$C8,$B0,$A0,$C4,$A0,$A0     ; DFEE
        .byte $A0,$A0,$A0,$A0,$11,$D0,$11,$D0     ; DFF6
        .byte $25,$D0                             ; DFFE
