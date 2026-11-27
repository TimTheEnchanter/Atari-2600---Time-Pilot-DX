import sys, ctypes as C
sys.path.insert(0,'/home/claude/tools')
from lr import Emu
e=Emu(sys.argv[1] if len(sys.argv)>1 else '/home/claude/tp/Time_Pilot_DX.a26'); e.run(60); e.press(3)
m=C.cast(e.lib.retro_get_memory_data(2),C.POINTER(C.c_uint8))
def calm():
    for k in range(4): m[0x25+k]=0; m[0x29+k]=0; m[0x2D+k]=0
    m[0x58]=0;m[0x59]=0;m[0x5A]=0;m[0x5B]=0
spawned=None; shots=0; bad=0
for i in range(6000):
    calm()
    px,py=e.sc(0x13,2)
    j=0
    if py:
        if spawned is None: spawned=i; print('para spawned frame',i,'at',px,py,'SDIR',e.r(0x9e))
        if px<74: j|=4
        elif px>86: j|=8
        if py>64: j|=1
        elif py<58: j|=2
    l=e.run(1,joy=j)[0]
    if l!=262: bad+=1
    if py and shots<3 and spawned and i-spawned in (5,60,120):
        e.shot('/tmp/para_%d.png'%shots,2); shots+=1
    s='%02X%02X'%(e.r(0x8f),e.r(0x8d))
    if py and not e.sc(0x14)[0]:
        print('para gone frame',i,'last',px,py,'score',s,'PARN',e.sc(0x15)[0])
print('bad frames',bad)
