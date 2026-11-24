import math
# plane in local coords: x right, y toward the tail (nose at -y); centre of the 8x16 cell = (3.5, 7.5)
RECTS = [(-0.5, 0.5, -6.6, 6.2),   # fuselage
         (-1.5, 1.5, -4.0, 0.2),   # cockpit/body
         (-3.6, 3.6, 0.2, 2.2),    # wings
         (-2.6, 2.6, 4.6, 5.6),    # tailplane
         (-1.4, 1.4, 3.6, 4.6)]
def inside(x, y): return any(a <= x <= b and c <= y <= d for a, b, c, d in RECTS)
def render(deg, thr=0.42, N=6):
    a = math.radians(deg); g = []
    for r in range(16):
        row = 0
        for c in range(8):
            hit = 0
            for sy in range(N):
                for sx in range(N):
                    x = c + (sx + .5) / N - 3.5; y = r + (sy + .5) / N - 8.0
                    # screen -> local (rotate by -deg; heading clockwise from up)
                    lx = x * math.cos(a) + y * math.sin(a); ly = -x * math.sin(a) + y * math.cos(a)
                    hit += inside(lx, ly)
            if hit / (N * N) > thr: row |= 0x80 >> c
        g.append(row)
    return g
if __name__ == '__main__':
    gs = [render(f * 22.5) for f in range(9)]
    for r in range(16): print('  '.join(format(g[r], '08b').replace('0', '.').replace('1', '#') for g in gs))
