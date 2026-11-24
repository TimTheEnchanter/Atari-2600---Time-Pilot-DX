#!/usr/bin/env python3
"""Build Time Pilot DX (F6 + Superchip, 16K) from the verified disassembly b0.asm / b1.asm.

Bank map (F6 hotspots $1FF6-$1FF9 select banks 0-3; Superchip RAM: write $x000-$x07F, read $x080-$x0FF):
  bank 0  RORG $F000  logic   (orig bank 0; first-page code moved into the old top-kernel area)
  bank 1  RORG $D000  bands   (orig bank 1; band kernel shifted +$100 so page crossings are unchanged)
  bank 2  RORG $F000  top     (orig bank 0 copy; top score/attract kernels at original addresses)
  bank 3  RORG $D000  bottom  (orig bank 1 copy; bottom panel kernel at original addresses)
Switch stubs live in the unused tail $xFE5-$xFF5 of each bank.
"""
import re, subprocess, sys, os

DASM = '/home/claude/dasm/bin/dasm'
HERE = os.path.dirname(os.path.abspath(__file__))

def parse(path):
    head, body = [], []
    for l in open(path).read().split('\n'):
        m = re.search(r'; ([0-9A-F]{4})( |$)', l)
        if m and not l.startswith(';') and ('.byte' in l or len(l) > 8 and l[8:9] != ' ' or True) and re.match(r'^(L[0-9A-F]{4})?\s', l):
            body.append((int(m.group(1), 16), l))
        elif not body:
            if l.strip().startswith(('ORG', 'RORG')): continue
            head.append(l)
    return head, body

def blen(l):
    if '.byte' in l: return len(l.split('.byte')[1].split(';')[0].split(','))
    return len(l.split(';')[1].split()) - 1

def split_at(body, cut):
    """make sure no .byte row straddles address cut"""
    out = []
    for a, l in body:
        n = blen(l)
        if '.byte' in l and a < cut < a + n:
            vals = l.split('.byte')[1].split(';')[0].strip().split(',')
            lab = l[:8].strip()
            k = cut - a
            out.append((a, '%-8s.byte %s ; %04X' % (lab, ','.join(vals[:k]), a)))
            out.append((cut, '        .byte %s ; %04X' % (','.join(vals[k:]), cut)))
        else:
            out.append((a, l))
    return out

def rng(body, lo, hi):  # inclusive
    return [(a, l) for a, l in body if lo <= a <= hi]

def sub(body, addr, new):
    out = []
    hit = 0
    for a, l in body:
        if a == addr:
            lab = l[:8].strip()
            out.append((a, '%-8s%s ; %04X (DX)' % (lab, new, a))); hit = 1
        else:
            out.append((a, l))
    assert hit, hex(addr)
    return out

def seg(org_off, rorg, lines):
    return ['    ORG $%04X' % org_off, '    RORG $%04X' % rorg] + [l for a, l in lines]

def shifted(lines, d):
    """re-address lines by +d (labels keep names; comment address updated)"""
    return [(a + d, re.sub(r'; ([0-9A-F]{4})', '; %04X' % (a + d), l, 1)) for a, l in lines]

def assemble(name, src_lines):
    p = os.path.join(HERE, 'build', name + '.asm')
    open(p, 'w').write('\n'.join(src_lines) + '\n')
    r = subprocess.run([DASM, p, '-f3', '-o' + p[:-4] + '.bin', '-l' + p[:-4] + '.lst', '-s' + p[:-4] + '.sym'],
                       capture_output=True, text=True)
    if r.returncode or not os.path.exists(p[:-4] + '.bin'):
        print(r.stdout[-2000:], r.stderr[-2000:]); sys.exit(1)
    b = open(p[:-4] + '.bin', 'rb').read()
    assert len(b) == 4096, (name, len(b))
    return b

def main():
    os.makedirs(os.path.join(HERE, 'build'), exist_ok=True)
    h0, b0 = parse(os.path.join(HERE, 'b0.asm'))
    h1, b1 = parse(os.path.join(HERE, 'b1.asm'))
    b0 = split_at(b0, 0xFFE5); b1 = split_at(b1, 0xDFE5)

    # ---------------- bank 0: logic ----------------
    L = sub(b0, 0xF98A, 'JMP   $FFE5')                      # kernel entry -> bank 2 via stub
    first = rng(L, 0xF015, 0xF110)                          # reset, frame loop, switches (was in SC RAM page)
    src = list(h0) + ['; ===== DX bank 0: logic =====', '    ORG $0000', '    .byte 0']
    src += seg(0x111, 0xF111, rng(L, 0xF111, 0xF992))
    src += ['; --- relocated first-page code ---'] + seg(0x993, 0xF993, first)
    src += ['    IF . > $FC59', '      ERR', '    ENDIF']
    src += seg(0xC59, 0xFC59, rng(L, 0xFC59, 0xFFE4))
    src += ['    ORG $0FE5', '    RORG $FFE5',
            'S_TOP   STA   $1FF8          ; -> bank 2, continues at $FFE8',
            '    ORG $0FEE', '    RORG $FFEE',
            'S_FRAME JMP   LF027          ; arrives from bank 3 ($FFEB)',
            '    ORG $0FF4', '    RORG $FFF4',
            'S_RESET JMP   LF015          ; arrives from banks 1-3 ($FFF1)',
            '    ORG $0FFA', '    RORG $FFFA', '    .word LF015, LF015, LF015']
    bank0 = assemble('bank0', src)

    # ---------------- bank 2: top kernels (copy of bank 0) ----------------
    L = sub(b0, 0xFC56, 'JMP   S_BAND')
    src = list(h0) + ['; ===== DX bank 2: top kernels =====']
    src += seg(0x000, 0xF000, rng(L, 0xF000, 0xFFE4))
    src += ['    ORG $0FE8', '    RORG $FFE8',
            '        JMP   ($00FE)        ; top kernel entry (from bank 0 S_TOP)',
            'S_BAND  STA   $1FF7          ; -> bank 1 at $FFEE',
            '    ORG $0FF1', '    RORG $FFF1',
            'S_RST2  STA   $1FF6',
            '    ORG $0FFA', '    RORG $FFFA', '    .word S_RST2, S_RST2, S_RST2']
    bank2 = assemble('bank2', src)

    # ---------------- bank 1: band kernel ----------------
    band = shifted(rng(b1, 0xD025, 0xD1B5), 0x100)
    src = list(h1) + ['; ===== DX bank 1: band kernel =====', '    ORG $0000', '    .byte 0']
    src += seg(0x125, 0xD125, band)
    src += ['LD1B6   JMP   S_BOT          ; band kernel exit -> bank 3 bottom panel',
            'PAD1    NOP                  ; pad: original bank-switch path took 22 cycles',
            '        NOP', '        NOP', '        BIT   $80', '        JMP   LD025']
    src += ['    IF . > $D30D', '      ERR', '    ENDIF']
    src += seg(0x30D, 0xD30D, rng(b1, 0xD30D, 0xDFE4))
    src += ['    ORG $0FE5', '    RORG $DFE5',
            'S_BOT   STA   $1FF9          ; -> bank 3 at $DFE8',
            '    ORG $0FEE', '    RORG $DFEE',
            '        JMP   PAD1           ; from bank 2 S_BAND',
            'S_RST1  STA   $1FF6',
            '    ORG $0FFA', '    RORG $DFFA', '    .word S_RST1, S_RST1, S_RST1']
    bank1 = assemble('bank1', src)

    # ---------------- bank 3: bottom panel (copy of bank 1) ----------------
    L = sub(b1, 0xD30A, 'JMP   S_FRM3')
    src = list(h1) + ['; ===== DX bank 3: bottom panel =====']
    src += seg(0x000, 0xD000, rng(L, 0xD000, 0xDFE4))
    src += ['    ORG $0FE8', '    RORG $DFE8',
            '        JMP   LD1B6          ; from bank 1 S_BOT',
            'S_FRM3  STA   $1FF6          ; -> bank 0 S_FRAME ($FFEE)',
            '    ORG $0FF1', '    RORG $DFF1',
            'S_RST3  STA   $1FF6',
            '    ORG $0FFA', '    RORG $DFFA', '    .word S_RST3, S_RST3, S_RST3']
    bank3 = assemble('bank3', src)

    banks = [bytearray(b) for b in (bank0, bank1, bank2, bank3)]
    for b in banks:
        b[0:0x100] = bytes(0x100)          # Superchip RAM window: identical in every bank
    rom = b''.join(banks)
    out = os.path.join(HERE, 'Time_Pilot_DX.a26')
    open(out, 'wb').write(rom)
    print('built', out, len(rom))

main()
