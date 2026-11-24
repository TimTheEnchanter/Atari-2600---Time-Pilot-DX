#!/usr/bin/env python3
"""Tracing disassembler for Atari 2600 ROMs (4K banks). Outputs dasm-style source.
usage: vcsdis.py rom bank origin entry[,entry...] [--data a-b,...] > out.asm
"""
import sys

OPS = {}
def op(code, mn, mode): OPS[code] = (mn, mode)
# modes: imp acc imm zp zpx zpy abs abx aby ind izx izy rel
tbl = """
00 BRK imp|01 ORA izx|05 ORA zp|06 ASL zp|08 PHP imp|09 ORA imm|0A ASL acc|0D ORA abs|0E ASL abs
10 BPL rel|11 ORA izy|15 ORA zpx|16 ASL zpx|18 CLC imp|19 ORA aby|1D ORA abx|1E ASL abx
20 JSR abs|21 AND izx|24 BIT zp|25 AND zp|26 ROL zp|28 PLP imp|29 AND imm|2A ROL acc|2C BIT abs|2D AND abs|2E ROL abs
30 BMI rel|31 AND izy|35 AND zpx|36 ROL zpx|38 SEC imp|39 AND aby|3D AND abx|3E ROL abx
40 RTI imp|41 EOR izx|45 EOR zp|46 LSR zp|48 PHA imp|49 EOR imm|4A LSR acc|4C JMP abs|4D EOR abs|4E LSR abs
50 BVC rel|51 EOR izy|55 EOR zpx|56 LSR zpx|58 CLI imp|59 EOR aby|5D EOR abx|5E LSR abx
60 RTS imp|61 ADC izx|65 ADC zp|66 ROR zp|68 PLA imp|69 ADC imm|6A ROR acc|6C JMP ind|6D ADC abs|6E ROR abs
70 BVS rel|71 ADC izy|75 ADC zpx|76 ROR zpx|78 SEI imp|79 ADC aby|7D ADC abx|7E ROR abx
81 STA izx|84 STY zp|85 STA zp|86 STX zp|88 DEY imp|8A TXA imp|8C STY abs|8D STA abs|8E STX abs
90 BCC rel|91 STA izy|94 STY zpx|95 STA zpx|96 STX zpy|98 TYA imp|99 STA aby|9A TXS imp|9D STA abx
A0 LDY imm|A1 LDA izx|A2 LDX imm|A4 LDY zp|A5 LDA zp|A6 LDX zp|A8 TAY imp|A9 LDA imm|AA TAX imp|AC LDY abs|AD LDA abs|AE LDX abs
B0 BCS rel|B1 LDA izy|B4 LDY zpx|B5 LDA zpx|B6 LDX zpy|B8 CLV imp|B9 LDA aby|BA TSX imp|BC LDY abx|BD LDA abx|BE LDX aby
C0 CPY imm|C1 CMP izx|C4 CPY zp|C5 CMP zp|C6 DEC zp|C8 INY imp|C9 CMP imm|CA DEX imp|CC CPY abs|CD CMP abs|CE DEC abs
D0 BNE rel|D1 CMP izy|D5 CMP zpx|D6 DEC zpx|D8 CLD imp|D9 CMP aby|DD CMP abx|DE DEC abx
E0 CPX imm|E1 SBC izx|E4 CPX zp|E5 SBC zp|E6 INC zp|E8 INX imp|E9 SBC imm|EA NOP imp|EC CPX abs|ED SBC abs|EE INC abs
F0 BEQ rel|F1 SBC izy|F5 SBC zpx|F6 INC zpx|F8 SED imp|F9 SBC aby|FD SBC abx|FE INC abx
"""
for line in tbl.strip().split('\n'):
    for e in line.split('|'):
        c, m, md = e.split(); op(int(c, 16), m, md)
SIZE = dict(imp=1, acc=1, imm=2, zp=2, zpx=2, zpy=2, rel=2, izx=2, izy=2, abs=3, abx=3, aby=3, ind=3)

TIA_W = ["VSYNC","VBLANK","WSYNC","RSYNC","NUSIZ0","NUSIZ1","COLUP0","COLUP1","COLUPF","COLUBK","CTRLPF","REFP0","REFP1","PF0","PF1","PF2","RESP0","RESP1","RESM0","RESM1","RESBL","AUDC0","AUDC1","AUDF0","AUDF1","AUDV0","AUDV1","GRP0","GRP1","ENAM0","ENAM1","ENABL","HMP0","HMP1","HMM0","HMM1","HMBL","VDELP0","VDELP1","VDELBL","RESMP0","RESMP1","HMOVE","HMCLR","CXCLR"]
TIA_R = ["CXM0P","CXM1P","CXP0FB","CXP1FB","CXM0FB","CXM1FB","CXBLPF","CXPPMM","INPT0","INPT1","INPT2","INPT3","INPT4","INPT5"]
RIOT = {0x280:"SWCHA",0x281:"SWACNT",0x282:"SWCHB",0x283:"SWBCNT",0x284:"INTIM",0x285:"TIMINT",0x294:"TIM1T",0x295:"TIM8T",0x296:"TIM64T",0x297:"T1024T"}
WRITES = {"STA","STX","STY"}

def main():
    a = sys.argv[1:]
    rom = open(a[0], 'rb').read()
    bank = int(a[1]); org = int(a[2], 16)
    entries = [int(x, 16) for x in a[3].split(',')]
    data = []
    if '--data' in a:
        for r in a[a.index('--data')+1].split(','):
            s, e = r.split('-'); data.append((int(s,16), int(e,16)))
    mem = rom[bank*4096:(bank+1)*4096]
    rd = lambda ad: mem[(ad - org) & 0xFFF]
    inbank = lambda ad: (ad & 0x1FFF) >= (org & 0x1FFF) and (ad & 0x1FFF) < (org & 0x1FFF) + 0x1000 if False else ((ad & 0xF000) == (org & 0xF000) or (ad & 0x1FFF) >= 0x1000 and (ad & 0xFFF) == (ad & 0xFFF))
    code = {}; labels = set(entries); refs = set()
    stack = list(entries)
    isdata = lambda ad: any(s <= ad <= e for s, e in data)
    while stack:
        pc = stack.pop()
        while True:
            pc = org | (pc & 0xFFF)
            if pc in code or isdata(pc): break
            o = rd(pc)
            if o not in OPS: break
            mn, md = OPS[o]; n = SIZE[md]
            b = [rd(pc+i) for i in range(n)]
            code[pc] = (mn, md, b)
            if md == 'rel':
                t = (pc + 2 + ((b[1] ^ 0x80) - 0x80)) & 0xFFFF
                t = org | (t & 0xFFF); labels.add(t); stack.append(t)
            if mn in ('JSR', 'JMP') and md == 'abs':
                t = b[1] | b[2] << 8
                if (t & 0x1000):
                    t2 = org | (t & 0xFFF)
                    if (t & 0xF000) == (org & 0xF000) or True:
                        labels.add(t2); stack.append(t2)
            if mn in ('RTS', 'RTI', 'BRK') or (mn == 'JMP'): break
            pc += n
    # data refs
    for pc, (mn, md, b) in code.items():
        if md in ('abs', 'abx', 'aby', 'ind'):
            t = b[1] | b[2] << 8
            if t & 0x1000 and (t & 0xFFF) < 0xFF6: refs.add(org | (t & 0xFFF))
        if md == 'imm': pass
    def name(t, mn, md, b):
        if md in ('zp','zpx','zpy','izx','izy'):
            v = b[1]
            if v < 0x80:
                if mn in WRITES or mn in ('INC','DEC','ASL','LSR','ROL','ROR'):
                    return TIA_W[v & 0x3F] if (v & 0x3F) < len(TIA_W) else "$%02X" % v
                return TIA_R[v & 0xF] if (v & 0xF) < len(TIA_R) else "$%02X" % v
            return "$%02X" % v
        v = b[1] | b[2] << 8
        if v < 0x80:
            return ("TIA_W[%d]" % v) if False else "$%04X" % v
        if (v & 0x1FFF) in RIOT or (v & 0x2FF) in RIOT and v < 0x1000: return RIOT.get(v & 0x2FF, "$%04X" % v)
        if v & 0x1000:
            t2 = org | (v & 0xFFF)
            if t2 in labels or t2 in refs:
                return "L%04X" % t2 if (v & 0xF000) == (org & 0xF000) else "L%04X+$%04X" % (t2, (v - t2) & 0xFFFF) if False else ("L%04X" % t2 if v == t2 else "$%04X" % v)
        return "$%04X" % v
    eq = ["%-8s = $%02X" % (n, i) for i, n in enumerate(TIA_W)] + ["%-8s = $%02X" % (n, i) for i, n in enumerate(TIA_R) if n not in TIA_W] + ["%-8s = $%04X" % (n, a) for a, n in RIOT.items()]
    out = ["; bank %d org $%04X" % (bank, org), "    processor 6502"] + eq + ["    ORG $%04X" % (bank*0x1000), "    RORG $%04X" % org]
    pc = org
    end = org + 0x1000
    while pc < end:
        if pc in code:
            mn, md, b = code[pc]
            lab = ("L%04X" % pc) if (pc in labels or pc in refs) else ""
            arg = ""
            if md == 'imm': arg = "#$%02X" % b[1]
            elif md == 'acc': arg = ""
            elif md == 'rel':
                t = org | ((pc + 2 + ((b[1] ^ 0x80) - 0x80)) & 0xFFF); arg = "L%04X" % t
            elif md == 'imp': arg = ""
            else:
                nm = name(pc, mn, md, b)
                force = ".w" if md in ('abs','abx','aby') and (b[1] | b[2] << 8) < 0x100 else ""
                arg = {'zp': nm, 'zpx': nm+",X", 'zpy': nm+",Y", 'abs': nm, 'abx': nm+",X", 'aby': nm+",Y",
                       'ind': "("+nm+")", 'izx': "("+nm+",X)", 'izy': "("+nm+"),Y"}[md]
                if force: mn = mn + force
            out.append("%-8s%-5s %-22s; %04X %s" % (lab, mn, arg, pc, ' '.join('%02X' % x for x in b)))
            pc += len(b)
        else:
            # data run until next code/label
            s = pc; row = []
            while pc < end and pc not in code and len(row) < 8:
                if row and (pc in labels or pc in refs): break
                row.append(rd(pc)); pc += 1
            lab = ("L%04X" % s) if (s in labels or s in refs) else ""
            out.append("%-8s.byte %-36s; %04X" % (lab, ','.join('$%02X' % x for x in row), s))
    print('\n'.join(out))
    sys.stderr.write("code bytes %d, labels %d\n" % (sum(len(v[2]) for v in code.values()), len(labels)))

main()
