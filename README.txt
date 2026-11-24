Time Pilot DX - milestone 3 (16-direction ship, 3 player shots with autofire)
Source: Coleco Time Pilot (USA) 8K F8, md5 fc2104dd2dadf9a6176c1c1c8f87ced9

mk_dx.py          builds Time_Pilot_DX.a26 (16K F6 + Superchip); runs gen_m3.py first; needs dasm
gen_m3.py         ship frames (bank 1 page $D4) + 16-direction tables; shipgen.py rasterizes the in-between frames
src/m3.asm        DxPre (turning, ship frame, scroll heading) and DxShot (3 shots, autofire, round-robin drawing)
src/dx_b2.asm     bank 2 far-call dispatcher + Superchip init;  src/dx_ram.h  Superchip RAM map
b0.asm, b1.asm    byte-exact disassembly of the original;  cmp.py  ROM-vs-ROM frame comparison;  tools/  disassembler + libretro frontend
