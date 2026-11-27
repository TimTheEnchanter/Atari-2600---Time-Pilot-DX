import sys, random
sys.path.insert(0,'/home/claude/tools')
from lr import Emu
rom=sys.argv[1]
for seed in (5,7,9):
    e=Emu(rom); e.run(30); e.press(3)
    r=random.Random(seed); lines={}; j=16; eras=set(); deaths=0; prevl=None; kills=0; prevs=0; extra=0; maxon=0; on6=0
    for i in range(20000):
        if i%40==0: j=16|r.choice([0,1,2,4,8,5,6,9,10])
        l=e.run(1,joy=j)[0]; lines[l]=lines.get(l,0)+1
        eras.add(e.r(0x95)); lv=e.r(0x8b)&7
        if prevl is not None and lv<prevl: deaths+=1
        prevl=lv
        s=int('%02X%02X'%(e.r(0x8f),e.r(0x8d)))
        if s>prevs: kills+=s-prevs
        prevs=s
        if i%10==0:
            ex=sum(1 for v in e.sc(0,2) if v); on=ex+sum(1 for k in range(4) if e.r(0xA5+k) and e.r(0xA9+k))
            extra+=ex; maxon=max(maxon,on); on6+= on>=5
        if e.r(0xA0)==0xFF: e.press(3); prevl=None; prevs=0
    bad={k:v for k,v in lines.items() if k!=262}
    print('seed',seed,'points',kills,'eras', sorted(eras), 'deaths', deaths, 'extra slots avg %.2f'%(extra/2000), 'max on screen', maxon, '5+ on screen %d%%'%(on6/20), 'non-262 frames', sum(bad.values()), sorted(bad)[:6])
