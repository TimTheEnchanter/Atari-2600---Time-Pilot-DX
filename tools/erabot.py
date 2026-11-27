import sys, random, ctypes as C
sys.path.insert(0,'/home/claude/tools')
from lr import Emu
rom=sys.argv[1]
for era in range(5):
    e=Emu(rom); e.run(30); e.press(3)
    m=C.cast(e.lib.retro_get_memory_data(2),C.POINTER(C.c_uint8))
    for i in range(150): e.run(1)
    m[0x15]=era; m[0x0B]=(m[0x0B]&0x0F)|(era<<4)
    r=random.Random(era); j=16; bad=[]; deaths=0; lastA4=0; eras=set(); paras=0; lastpn=0; forms=0; prevex=(1,1); bosses=0; lastb=0
    for i in range(10000):
        if i%40==0: j=16|r.choice([0,1,2,4,8,5,6,9,10])
        if i==4000: m[0x16]=2
        l=e.run(1,joy=j)[0]
        if l!=262: bad.append((i,l))
        a4=e.r(0xA4)
        if a4==0xA0 and lastA4!=0xA0: deaths+=1
        lastA4=a4; eras.add(e.r(0x95))
        pn=e.sc(0x15)[0]
        if pn>lastpn: paras+=1
        lastpn=pn
        ex=tuple(e.sc(0,2))
        if ex[0] and ex[1] and not prevex[0] and not prevex[1]: forms+=1
        prevex=ex
        hp=e.sc(6)[0]
        if hp and not lastb: bosses+=1
        lastb=hp
        if e.r(0xA0)==0xFF: e.press(3); m[0x15]=era
    print('era',era,'eras seen',sorted(eras),'deaths',deaths,'rescues',paras,'formations',forms,'bosses',bosses,'score %02X%02X'%(e.r(0x8f),e.r(0x8d)),'bad',len(bad),bad[:4])
