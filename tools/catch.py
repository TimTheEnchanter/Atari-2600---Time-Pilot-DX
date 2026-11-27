import sys, random
sys.path.insert(0,'/home/claude/tools')
from lr import Emu
def dump(e):
    zp=[(hex(e.r(0xA5+k)),hex(e.r(0xA9+k)),hex(e.r(0xAD+k))) for k in range(4)]
    ex=list(zip(*(map(hex,e.sc(o,2)) for o in (0,2,4))))
    return 'zp',zp,'sc',ex,'boss HP/DIR/FL',e.sc(6,3),'A4',hex(e.r(0xA4)),'shot',[hex(e.r(a)) for a in (0xC9,0xCA,0xCB,0xCC)],'ebul',[hex(e.r(a)) for a in range(0xC0,0xC9)]
for seed in range(20,60):
    e=Emu(sys.argv[1]); e.run(30); e.press(3)
    r=random.Random(seed); j=16; hist=[]; found=False
    for i in range(20000):
        if i%40==0: j=16|r.choice([0,1,2,4,8,5,6,9,10])
        hist.append(dump(e)); hist=hist[-3:]
        l=e.run(1,joy=j)[0]
        if l!=262:
            print('seed',seed,'frame',i,'lines',l)
            for h in hist: print('  before',h)
            e.shot('/tmp/bad.png',2)
            for k in range(3):
                l=e.run(1,joy=j)[0]; print('  next',l,dump(e))
            found=True; break
        if e.r(0xA0)==0xFF: e.press(3)
    if found: break
    print('seed',seed,'ok')
