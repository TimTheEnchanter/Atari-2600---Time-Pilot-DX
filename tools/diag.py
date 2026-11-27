import sys, random, ctypes as C
sys.path.insert(0,'/home/claude/tools')
from lr import Emu
era=int(sys.argv[1]); maxbad=int(sys.argv[2]) if len(sys.argv)>2 else 4
e=Emu('/home/claude/tp/Time_Pilot_DX.a26'); e.run(30); e.press(3)
d=Emu('/tmp/dbg6.a26'); d.run(30)
L=e.lib; L.retro_serialize_size.restype=C.c_size_t
m=C.cast(e.lib.retro_get_memory_data(2),C.POINTER(C.c_uint8))
for i in range(150): e.run(1)
m[0x15]=era; m[0x0B]=(m[0x0B]&0x0F)|(era<<4)
r=random.Random(era); j=16; nb=0
for i in range(10000):
    if i%40==0: j=16|r.choice([0,1,2,4,8,5,6,9,10])
    if i==4000: m[0x16]=2
    n=L.retro_serialize_size(); buf=C.create_string_buffer(n); L.retro_serialize(buf,n)
    l=e.run(1,joy=j)[0]
    if l!=262:
        d.lib.retro_unserialize(buf,n); dl=d.run(1,joy=j)[0]
        print(i,l,'dbg',dl,'phase',d.r(0x81)&7,'m6in',d.r(0xBD),'pd',d.r(0xBA),'bb',d.r(0xB9),'m6out',d.r(0xBB),'vb_end',d.r(0xB3),'vb_en',d.r(0xB7),'os_b',d.r(0xB8),'os_lf',d.r(0xBC),'state',e.r(0x80),'A4',hex(e.r(0xA4)),'boss',e.sc(6,3),'mis',[hex(e.r(a)) for a in (0xD6,0xD7,0xD8,0xD9,0xDA,0xDB)],'para',e.sc(0x13,2))
        nb+=1
        if nb>=maxbad: break
    if e.r(0xA0)==0xFF: e.press(3); m[0x15]=era
