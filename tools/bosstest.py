import sys, ctypes as C
sys.path.insert(0,'/home/claude/tools')
from lr import Emu
rom=sys.argv[1] if len(sys.argv)>1 else '/home/claude/tp/Time_Pilot_DX.a26'
e=Emu(rom); e.run(60); e.press(3)
m=C.cast(e.lib.retro_get_memory_data(2),C.POINTER(C.c_uint8))
def calm(keep=None):
    for k in range(4):
        if k!=keep: m[0x25+k]=0; m[0x29+k]=0; m[0x2D+k]=0
    m[0x5A]=0; m[0x5B]=0
for i in range(300): calm(); e.run(1, joy=4)        # face west, empty sky
m[0x16]=0                                           # quota done -> boss comes
k=None
for i in range(2000):
    b=[j for j in range(4) if m[0x2D+j]&0x40 and m[0x25+j]]
    if b: k=b[0]; break
    calm(); e.run(1, joy=4)
print('boss in slot',k,'after',i,'frames; state',e.r(0x80),'A4',hex(e.r(0xA4)))
prev=None; shot=None
for i in range(1500):
    if m[0x2D+k]&0x40 and not m[0x2D+k]&0x80:
        m[0x25+k]=30; m[0x29+k]=64
    calm(k)
    e.run(1, joy=4|16)
    cur=(e.r(0x80),hex(e.r(0x89)),e.r(0x95),hex(e.r(0xAD+k)),e.sc(6)[0],'%02X%02X'%(e.r(0x8f),e.r(0x8d)),hex(e.r(0xA4)),hex(e.r(0x85)&0x80))
    if cur[:6]!=(prev or (None,)*8)[:6]: print(i,'80,89,95,bossstate,HP,score,A4,warp',cur)
    if shot is None and e.sc(6)[0]==3: e.shot('/home/claude/tp/shots/m5_boss_hit.png',2); shot=1
    if cur[7]!='0x0' and shot==1: e.shot('/home/claude/tp/shots/m5_warp.png',2); shot=2
    prev=cur
    if e.r(0x95)!=0 and e.r(0x80)==2: print('now in era',e.r(0x95)); e.shot('/home/claude/tp/shots/m5_era2.png',2); break
