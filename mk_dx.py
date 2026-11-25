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

def chk(body, addr, expect, new):
    """replace the instruction at addr after checking it is the one we expect"""
    for a, l in body:
        if a == addr:
            assert expect in l.split(';')[0], (hex(addr), l, expect)
            return sub(body, addr, new)
    raise AssertionError('no line at %04X' % addr)

def patch_bytes(body, addr, vals, label=None):
    body = split_at(split_at(body, addr), addr + len(vals))
    out = []; done = False
    for a, l in body:
        if addr <= a < addr + len(vals):
            if not done:
                lab = label or l[:8].strip()
                out.append((addr, '%-8s.byte %s ; %04X (DX)' % (lab, ','.join('$%02X' % v for v in vals), addr))); done = True
            continue
        out.append((a, l))
    return out

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

def as_data(lines):
    out = []
    for a, l in lines:
        if '.byte' in l: out.append((a, l)); continue
        hx = l.split(';')[1].split()[1:]
        out.append((a, '%-8s.byte %s ; %04X (dead code)' % (l[:8].strip(), ','.join('$' + h for h in hx), a)))
    return out

def seg(org_off, rorg, lines):
    return ['    ORG $%04X' % org_off, '    RORG $%04X' % rorg] + [l for a, l in lines]

def shifted(lines, d):
    """re-address lines by +d (labels keep names; comment address updated)"""
    return [(a + d, re.sub(r'; ([0-9A-F]{4})', '; %04X' % (a + d), l, 1)) for a, l in lines]

def assemble(name, src_lines):
    p = os.path.join(HERE, 'build', name + '.asm')
    open(p, 'w').write('\n'.join(src_lines) + '\n')
    r = subprocess.run([DASM, p, '-I' + os.path.join(HERE, 'src'), '-f3', '-o' + p[:-4] + '.bin', '-l' + p[:-4] + '.lst', '-s' + p[:-4] + '.sym'],
                       capture_output=True, text=True)
    if r.returncode or not os.path.exists(p[:-4] + '.bin'):
        print(r.stdout[-2000:], r.stderr[-2000:]); sys.exit(1)
    for l in r.stdout.split('\n'):
        if 'free' in l: print(name, l.strip())
    b = open(p[:-4] + '.bin', 'rb').read()
    assert len(b) == 4096, (name, len(b))
    return b

open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'src', 'dbg.h'), 'w').write('DEBUGT = 1\n' if os.environ.get('DEBUGT') else '; release\n')

def DBG(zp):
    # DEBUGT=1 builds store INTIM (time left, x64 cycles) into a zero-page byte for timing tests
    return ("\n        LDA   INTIM\n        STA   " + zp) if os.environ.get('DEBUGT') else ''

def TAIL(zp):
    # tail call into bank 2; debug builds return here first and record INTIM
    # (a JSR here would push two more stack bytes into bank 3's $F6-$F7 scratch; debug stores live in bank 3 instead)
    return '        JMP   CALL2'

def main():
    for g in ('gen_m3.py', 'gen_m4.py', 'gen_m5.py'):
        subprocess.run([sys.executable, '-I', os.path.join(HERE, g)], check=True, cwd=HERE, capture_output=True)
    os.makedirs(os.path.join(HERE, 'build'), exist_ok=True)
    h0, b0 = parse(os.path.join(HERE, 'b0.asm'))
    h1, b1 = parse(os.path.join(HERE, 'b1.asm'))
    b0 = split_at(b0, 0xFFE5); b1 = split_at(b1, 0xDFE5)

    # ---------------- bank 0: logic ----------------
    L = sub(b0, 0xF98A, 'JMP   $FFE5')                      # kernel entry -> bank 2 via stub
    L = sub(L, 0xF032, 'LDA   #$26')                         # overscan +2 lines -> 262-line frames
    # ---- M3: 16-direction ship, 3 shots
    L = chk(L, 0xF060, 'JSR   LF346', 'JSR   DXPRE')
    L = chk(L, 0xF352, 'JSR   LF3DC', 'JSR   DXSHOT')
    L = chk(L, 0xF045, 'JSR   LF0AB', 'JSR   DXOS')            # M4: band tables built in overscan
    L = chk(L, 0xF08A, 'LDA   #$4C', 'LDA   #$50')           # new-life ship frame (heading 12)
    L = chk(L, 0xF85E, 'LDY   #$03', 'RTS')                  # M4: LF813 keeps the missile part; DxBuild does enemies
    L = chk(L, 0xF817, 'STA   $BF,X', 'BIT   $BF')            # ...and must not wipe DxBuild's P1 pointers
    L = chk(L, 0xF298, 'LDA   CXM1P', 'JMP   DXSHIP')         # software ship collisions
    L = chk(L, 0xF29A, 'ORA   CXPPMM', '.byte $EA')            # (keeps the following addresses)
    L = chk(L, 0xF2C6, 'BIT   CXPPMM', 'BIT   $80')            # rammer already handled by DxShip
    L = chk(L, 0xF278, 'CMP   #$7C', 'CMP   #$A0')           # exploding frame moved to $D4A0
    L = chk(L, 0xF284, 'LDA   #$8C', 'LDA   #$B0')           # hidden frame
    L = chk(L, 0xF2AC, 'LDA   #$7C', 'LDA   #$A0')
    L = chk(L, 0xF41B, 'CMP   #$7C', 'CMP   #$A0')
    L = chk(L, 0xF7BE, 'CMP   #$7C', 'CMP   #$A0')
    L = chk(L, 0xF43C, 'LDA   SWCHA', 'JMP   LF4B6')        # old turn + fire -> DxPre / DxShot
    L = chk(L, 0xF4B6, 'LDX   $A3', 'LDX   $9E')            # clouds scroll by SDIR
    L = chk(L, 0xF6A1, 'LDY   $A3', 'LDY   $9E')            # enemies scroll by SDIR
    L = chk(L, 0xF6C7, 'LDY   $A3', 'LDY   $9E')
    L = chk(L, 0xF5A0, 'LDA   $CB', 'LDA   #$00')           # old single-bullet mover off
    # LF7D8 (score add) used $F8 as scratch; DXPRE calls LF346 one level deeper than the original main loop,
    # so $F8 now holds LF7D8's own return address -> the boss-kill path (LF7AF) never reached era clear.
    for a, ins in ((0xF7E5, 'STA   $F2'), (0xF7EF, 'CMP   $F2'), (0xF7FC, 'STA   $F2'), (0xF80C, 'ORA   $F2')):
        L = chk(L, a, ins.replace('$F2', '$F8'), ins)
    L = patch_bytes(L, 0xF272, [56, 56, 56, 56])                # arcade: 56 kills per era (original 8/16/24/24)
    L = patch_bytes(L, 0xFECD, [0x10, 0x30, 0x50, 0x70, 0x90, 0x70, 0x50, 0x30])  # attract rotation frames
    first = rng(L, 0xF015, 0xF110)                          # reset, frame loop, switches (was in SC RAM page)
    src = list(h0) + ['; ===== DX bank 0: logic =====', '    ORG $0000', '    .byte 0']
    src += ['    include "dx_ram.h"']
    src += seg(0x100, 0xF100, [(0, 'CALL2   STA   $1FF8          ; far call -> bank 2 ($F103 JSR DISP2, $F106 back)')])
    src += seg(0x109, 0xF109, [(0, '        RTS')])
    src += seg(0x111, 0xF111, rng(L, 0xF111, 0xF992))
    src += ['; --- relocated first-page code ---'] + seg(0x993, 0xF993, first)
    src += ['DXINIT  SEI', '        CLD', '        LDX   #$FF', '        TXS',
            '        LDX   #0             ; F_SCINIT', '        JSR   CALL2', '        JMP   LF015',
            'DXPRE   LDX   #1             ; F_PRE: heading, ship frame, scroll heading', '        JSR   CALL2', '        JSR   LF346',
            '        LDX   #6             ; F_ENEMY: extra enemy slots; A = kills to score', '        JSR   CALL2',
            '.sc     CMP   #0', '        BEQ   .scd', '        PHA', '        LDA   #1', '        JSR   LF7D8', '        PLA',
            '        SEC', '        SBC   #1', '        JMP   .sc', '.scd' + DBG('$B7'),
            '        LDA   $81            ; cloud rows only change when LF419/LF4B6 ran (frame&7 = 0)',
            '        AND   #7', '        BEQ   .cl', '        AND   #3', '        BNE   .nocl', '        LDA   $80', '        CMP   #2', '        BEQ   .nocl',
            '.cl     LDA   INTIM', '        CMP   #12            ; ~9 x 64 cycles needed', '        BCC   .nocl',
            '        CMP   #$2B           ; wrapped: no time', '        BCS   .nocl',
            '        LDX   #4             ; F_CLOUD: first cloud rows per band (bank 3)', TAIL('$B3'),
            '.nocl' + DBG('$B3'), '        RTS',
            'DXOS    JSR   LF0AB          ; overscan: switches, state machine, sound' + DBG('$BC'),

            '        LDA   INTIM', '        CMP   #BUILDT        ; not enough overscan left: keep last frame\'s tables', '        BCC   .nob',
            '        CMP   #$27           ; above the start value: the timer already ran out and wrapped', '        BCS   .nob',
            '        LDX   #3             ; F_BUILD: per-band sprite tables for the next kernel', TAIL('$B8'),
            '.nob' + DBG('$B8'), '        RTS',
            'DXSHOT  LDX   #2             ; F_SHOT: hits, move, fire, pick shot to draw', '        JSR   CALL2',
            '        BEQ   .nosnd', '        LDX   #0', '        JSR   LF099', '.nosnd  RTS',
            'DXSHIP  LDA   $A4            ; ship collisions in software (replaces CXM1P/CXPPMM)',
            '        CMP   #$A0', '        BCS   .noh', '        LDX   #5', '        JSR   CALL2', '        CMP   #0',
            '        BEQ   .noh', '        JMP   LF2AC', '.noh    JMP   LF2E5']
    src += ['    IF . > $FC59', '      ERR', '    ENDIF']
    src += seg(0xC59, 0xFC59, rng(L, 0xFC59, 0xFFE4))
    src += ['    ORG $0FE5', '    RORG $FFE5',
            'S_TOP   STA   $1FF8          ; -> bank 2, continues at $FFE8',
            '    ORG $0FEE', '    RORG $FFEE',
            'S_FRAME JMP   LF027          ; arrives from bank 3 ($FFEB)',
            '    ORG $0FF4', '    RORG $FFF4',
            'S_RESET JMP   DXINIT         ; arrives from banks 1-3 ($FFF1)',
            '    ORG $0FFA', '    RORG $FFFA', '    .word DXINIT, DXINIT, DXINIT']
    bank0 = assemble('bank0', src)

    # ---------------- bank 2: top kernels (copy of bank 0) ----------------
    L = sub(b0, 0xFC56, 'JMP   S_BAND')
    L = chk(L, 0xFC18, 'LDA   #$D5', 'LDA   #$D4')            # ship frames now in bank 1 page $D4
    src = list(h0) + ['; ===== DX bank 2: top kernels + DX code =====', '    ORG $0000', '    .byte 0', '    include "dx_ram.h"']
    src += seg(0x103, 0xF103, [(0, '        JSR   DISP2'), (0, '        STA   $1FF6          ; -> bank 0 $F109 RTS'),
                               (0, 'CALL3   STA   $1FF9          ; far call -> bank 3 ($D10C JSR DISP3, $D10F back)')])
    src += seg(0x112, 0xF112, [(0, '        RTS')])
    src += ['    include "dx_b2.asm"', '    IF . > $F98D', '      ERR', '    ENDIF', '    echo "bank 2 free:", ($F98D - .)d']
    src += seg(0x993, 0xF993, rng(L, 0xF993, 0xFC5F) + as_data(rng(L, 0xFC60, 0xFC6B)) + rng(L, 0xFC6C, 0xFFE4))
    src += ['    ORG $0FE8', '    RORG $FFE8',
            '        JMP   ($00FE)        ; top kernel entry (from bank 0 S_TOP)',
            'S_BAND  STA   $1FF7          ; -> bank 1 at $FFEE',
            '    ORG $0FF1', '    RORG $FFF1',
            'S_RST2  STA   $1FF6',
            '    ORG $0FFA', '    RORG $FFFA', '    .word S_RST2, S_RST2, S_RST2']
    bank2 = assemble('bank2', src)

    # ---------------- bank 1: band kernel ----------------
    src = list(h1) + ['; ===== DX bank 1: band kernel =====', '    ORG $0000', '    .byte 0', '    include "dx_ram.h"']
    if os.environ.get('OLDKERN'):
        src += seg(0x125, 0xD125, shifted(rng(b1, 0xD025, 0xD1B5), 0x100))
    else:
        src += ['    ORG $0125', '    RORG $D125', '    include "kern.asm"']
    src += ['LD1B6   JMP   S_BOT          ; band kernel exit -> bank 3 bottom panel',
            'PAD1    NOP                  ; pad: original bank-switch path took 22 cycles',
            '        NOP', '        NOP', '        BIT   $80', '        JMP   LD025']
    src += ['    IF . > $D30D', '      ERR', '    ENDIF']
    B1 = split_at(split_at(b1, 0xD400), 0xD4C0)
    src += seg(0x30D, 0xD30D, rng(B1, 0xD30D, 0xD3FF))
    src += ['    ORG $0410', '    RORG $D410', '    include "ship16.asm"']
    import json
    boss = json.load(open(os.path.join(HERE, 'build', 'boss.json')))
    for pg in range(0xD8, 0xDF):
        B1 = split_at(split_at(split_at(B1, pg * 256), pg * 256 + 0xC6), pg * 256 + 0x100)
    src += seg(0x4C0, 0xD4C0, rng(B1, 0xD4C0, 0xD7FF))
    for pg in range(0xD8, 0xDF):
        src += seg((pg - 0xD0) * 256, pg * 256, rng(B1, pg * 256, pg * 256 + 0xC5))
        d = boss[str(pg)]
        src += seg((pg - 0xD0) * 256 + 0xC6, pg * 256 + 0xC6,
                   [(0, '        .byte ' + ','.join('$%02X' % v for v in d[i:i + 16])) for i in range(0, len(d), 16)])
    src += seg(0xF00, 0xDF00, rng(B1, 0xDF00, 0xDFE4))
    src += ['    ORG $0FE5', '    RORG $DFE5',
            'S_BOT   STA   $1FF9          ; -> bank 3 at $DFE8',
            '    ORG $0FEE', '    RORG $DFEE',
            '        JMP   PAD1           ; from bank 2 S_BAND',
            'S_RST1  STA   $1FF6',
            '    ORG $0FFA', '    RORG $DFFA', '    .word S_RST1, S_RST1, S_RST1']
    bank1 = assemble('bank1', src)

    # ---------------- bank 3: bottom panel (copy of bank 1) ----------------
    L = sub(b1, 0xD30A, 'JMP   S_FRM3')
    L = chk(L, 0xD286, 'LDY   $96', 'JMP   NEWBOT')          # in-game bottom panel moved (progress bar)
    L = chk(L, 0xD288, 'LDA   LD30D,Y', '.byte $EA,$EA')
    src = list(h1) + ['; ===== DX bank 3: bottom panel + DX code =====', '    ORG $0000', '    .byte 0', '    include "dx_ram.h"']
    src += seg(0x10C, 0xD10C, [(0, '        JSR   DISP3'), (0, '        STA   $1FF8          ; -> bank 2 $F112 RTS')])
    src += ['    include "dx_b3.asm"', '    IF . > $D1B6', '      ERR', '    ENDIF', '    echo "bank 3 free (low area):", ($D1B6 - .)d']
    L = patch_bytes(L, 0xD326, [0xD5] * 5)                    # icon pointers -> icon copies in page $D5
    L = split_at(split_at(split_at(L, 0xD52C), 0xD59C), 0xD800)
    src += seg(0x1B6, 0xD1B6, rng(L, 0xD1B6, 0xD52B))
    src += ['    ORG $052C', '    RORG $D52C', '    include "m5_icons.asm"', '    IF . > $D59C', '      ERR', '    ENDIF']
    src += seg(0x59C, 0xD59C, rng(L, 0xD59C, 0xD7FF))
    src += ['    ORG $0800', '    RORG $D800', '    include "b3big.asm"', '    IF . > $DFE5', '      ERR', '    ENDIF',
            '    echo "bank 3 free (main area):", ($DFE5 - .)d']
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
    out = os.environ.get('OUTROM') or os.path.join(HERE, 'Time_Pilot_DX.a26')
    open(out, 'wb').write(rom)
    print('built', out, len(rom))

main()
