"""Competent-player bot for Time Pilot DX balance measurements.
Steers toward the nearest target (parachutist first, then homing missiles, then planes), fires constantly,
keeps lives topped up so a run covers the whole time budget. Usage: smartbot.py ROM [frames] [seeds]
Prints, per starting era: frames to clear the era (boss killed), kills/min, deaths/min by cause,
rescues, missiles shot down, bosses seen."""
import sys, random, ctypes as C, math
sys.path.insert(0, '/home/claude/tools')
from lr import Emu

SX, SY = 0x50, 0x46          # ship centre (bullet coordinates)
DANGER = 30

def stick(dx, dy):
    j = 0
    if dy > 6: j |= 1
    elif dy < -6: j |= 2
    if dx > 6: j |= 8
    elif dx < -6: j |= 4
    return j

def run(rom, era, frames, seed, lives=True, log=None):
    e = Emu(rom); e.run(30); e.press(3)
    m = C.cast(e.lib.retro_get_memory_data(2), C.POINTER(C.c_uint8))
    for i in range(150): e.run(1)
    m[0x15] = era; m[0x0B] = (m[0x0B] & 0x0F) | (era << 4)
    r = random.Random(seed)
    st = dict(forms=0, clear=None, kills=0, deaths=0, ram=0, bullet=0, rescues=0, mshot=0, bosses=0, bad=0)
    last96 = e.r(0x96); lastA4 = 0; lastpn = 0; lastb = 0; prevmis = (0, 0)
    wander = 0; wj = 0; prevex = (1, 1)
    for i in range(frames):
        # pick a target
        tgt = None
        px, py = e.sc(0x13, 2)
        if py: tgt = (px + 4, py + 6, 'para')
        else:
            best = None
            for k in range(4):
                x, y, s = e.r(0xA5 + k), e.r(0xA9 + k), e.r(0xAD + k)
                if x and y and not s & 0x80:
                    d = abs(x + 4 - SX) + abs(y + 6 - SY)
                    if best is None or d < best[0]: best = (d, x + 4, y + 6)
            for k in range(2):
                x, y, s = e.sc(0 + k)[0], e.sc(2 + k)[0], e.sc(4 + k)[0]
                if x and y and not s & 0x80:
                    d = abs(x + 4 - SX) + abs(y + 6 - SY)
                    if best is None or d < best[0]: best = (d, x + 4, y + 6)
            if best: tgt = (best[1], best[2], 'plane')
        # danger: a plane or bullet close to the ship -> fly away from it
        danger = None
        objs = [(e.r(0xA5 + k) + 4, e.r(0xA9 + k) + 6) for k in range(4) if e.r(0xA5 + k) and e.r(0xA9 + k) and not e.r(0xAD + k) & 0x80]
        objs += [(e.sc(k)[0] + 4, e.sc(2 + k)[0] + 6) for k in range(2) if e.sc(k)[0] and e.sc(2 + k)[0] and not e.sc(4 + k)[0] & 0x80]
        objs += [(e.r(0xD8 + k), e.r(0xDA + k)) for k in range(2) if e.r(0xDA + k)]
        for (x, y) in objs:
            d = abs(x - SX) + abs(y - SY)
            if d < DANGER and (danger is None or d < danger[0]): danger = (d, x, y)
        if danger and (not tgt or tgt[2] != 'para'):
            j = stick(SX - danger[1], SY - danger[2])
        elif tgt:
            j = stick(tgt[0] - SX, tgt[1] - SY)
            if r.random() < 0.15: j = r.choice([1, 2, 4, 8, 5, 6, 9, 10])   # imperfect player
        else:
            if wander <= 0: wj = r.choice([1, 2, 4, 8, 5, 6, 9, 10]); wander = 60
            wander -= 1; j = wj
        l = e.run(1, joy=j | 16)[0]
        if l != 262: st['bad'] += 1
        a4 = e.r(0xA4)
        if a4 == 0xA0 and lastA4 != 0xA0:
            st['deaths'] += 1
            hit = any(e.r(0xDA + k) and 63 - 8 <= e.r(0xDA + k) <= 78 + 8 and 76 - 8 <= e.r(0xD8 + k) <= 85 + 8 for k in range(2))
            hit = hit or any(prevmis[k] for k in range(2))
            st['bullet' if hit else 'ram'] += 1
        prevmis = tuple(bool(e.r(0xDA + k) and abs(e.r(0xDA + k) - 70) < 20 and abs(e.r(0xD8 + k) - 80) < 20) for k in range(2))
        lastA4 = a4
        v = e.r(0x96)
        if v < last96: st['kills'] += last96 - v
        last96 = v
        pn = e.sc(0x15)[0]
        if pn > lastpn: st['rescues'] += 1
        lastpn = pn
        hp = e.sc(6)[0]
        if hp and not lastb: st['bosses'] += 1
        lastb = hp
        ex = (e.sc(0)[0], e.sc(1)[0])
        if ex[0] and ex[1] and not prevex[0] and not prevex[1]: st['forms'] += 1
        prevex = ex
        if st['clear'] is None and e.r(0x95) != era: st['clear'] = i
        if log is not None and (not log or log[-1][1] != e.r(0x95)): log.append((i, e.r(0x95), '%02X%02X00' % (e.r(0x8F), e.r(0x8D)), st['deaths']))
        if lives: m[0x0B] = (m[0x0B] & 0xF8) | 3          # never run out of lives
        if e.r(0xA0) == 0xFF: break
    st['frames'] = i + 1
    return st

if __name__ == '__main__':
    rom = sys.argv[1]; frames = int(sys.argv[2]) if len(sys.argv) > 2 else 20000
    seeds = int(sys.argv[3]) if len(sys.argv) > 3 else 2
    eras = [int(x) for x in sys.argv[4].split(',')] if len(sys.argv) > 4 else range(5)
    for era in eras:
        S = [run(rom, era, frames, s) for s in range(seeds)]
        mins = sum(s['frames'] for s in S) / 3600
        tot = {k: sum(s[k] for s in S) for k in ('forms', 'kills', 'deaths', 'ram', 'bullet', 'rescues', 'mshot', 'bosses', 'bad')}
        clears = [s['clear'] for s in S]
        print('era %d: clear at %s  kills/min %.1f  deaths/min %.2f (ram %d, bullet %d)  rescues %d  forms %d  bosses %d  bad %d' % (
            era, clears, tot['kills'] / mins, tot['deaths'] / mins, tot['ram'], tot['bullet'], tot['rescues'], tot['forms'], tot['bosses'], tot['bad']))
