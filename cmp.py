"""Run the original and DX ROMs with the same scripted input; report first RAM/pixel mismatch and line counts."""
import sys, random
sys.path.insert(0, '/home/claude/tools')
from lr import Emu

def script(n, seed=1):
    r = random.Random(seed); out = []; j = 0
    for i in range(n):
        if i % 23 == 0: j = r.choice([0, 1, 2, 4, 8, 5, 6, 9, 10]) | (16 if r.random() < .5 else 0)
        out.append(j)
    return out

def main(a, b, n=6000):
    ea, eb = Emu(a), Emu(b)
    la, lb = set(), set()
    for e in (ea, eb): e.run(30, joy=CONST or 0)
    for e in (ea, eb): e.press(3)  # reset switch -> start game
    import ctypes as C
    pa = ea.lib.retro_get_memory_data(2); pb = eb.lib.retro_get_memory_data(2)
    C.memmove(pb, pa, 0x70)          # sync $80-$EF (RNG seed comes from power-on RAM)
    s = script(n); bad = 0
    j = CONST or 0; k = 0; seen = set()
    for i in range(n):
        if ea.r(0x81) % 8 == 4 and eb.r(0x81) % 8 == 4:
            k += 1
            if k % 3 == 0: j = s[i] if CONST is None else CONST
        if i % 1500 == 700:      # force the era boss to appear (kills left -> 0) in both
            for pp in (pa, pb):
                m = C.cast(pp, C.POINTER(C.c_uint8))
                if (i // 1500) % 2: m[0x16] = 0                   # boss appears
                else: m[0x09] |= 0x40; m[0x00] = 1                # era cleared -> warp
        if i % 9000 == 8000:                                    # last life -> eventual game over
            for pp in (pa, pb):
                m = C.cast(pp, C.POINTER(C.c_uint8)); m[0x0B] = (m[0x0B] & 0xF8) | 1
        if i % 9000 == 8999:
            for e in (ea, eb): e.press(3)
        seen.add((ea.r(0x95), ea.r(0x80), ea.r(0x85) >> 7))
        x = ea.run(1, joy=j)[0]; y = eb.run(1, joy=j)[0]
        la.add(x); lb.add(y)
        ra, rb = ea.ram(), eb.ram()
        if ra[:0x7C] != rb[:0x7C] or ea.frame != eb.frame:
            d = [hex(0x80 + k) for k in range(0x7C) if ra[k] != rb[k]]
            print('frame', i, 'RAM diff', d[:10], 'pixels', 'same' if ea.frame == eb.frame else 'DIFFER')
            ea.shot('cmp_a.png'); eb.shot('cmp_b.png'); bad = 1; break
    print('seen (era,state,warp):', sorted(seen))
    print('lines orig', sorted(la), 'dx', sorted(lb), 'OK' if not bad else 'MISMATCH',
          'era', ea.r(0x95), 'score %02X%02X' % (ea.r(0x8f), ea.r(0x8d)), 'state', ea.r(0x80))

CONST = int(sys.argv[4]) if len(sys.argv) > 4 else None
main(sys.argv[1], sys.argv[2], int(sys.argv[3]) if len(sys.argv) > 3 else 6000)
