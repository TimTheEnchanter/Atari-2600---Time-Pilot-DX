Time Pilot DX - milestone 1 (F6 + Superchip skeleton)
Source: Coleco Time Pilot (USA) 8K F8, md5 fc2104dd2dadf9a6176c1c1c8f87ced9

b0.asm, b1.asm   byte-exact disassembly of the original's two banks (dasm: reassembles identically)
mk_dx.py         builds Time_Pilot_DX.a26 (16K F6 + Superchip) from them; needs dasm
cmp.py           frame-by-frame RAM + pixel comparison of two ROMs under the Stella libretro core
tools/vcsdis.py  tracing disassembler;  tools/lr.py  ctypes libretro frontend (needs stella_libretro.so)

Bank map: 0 logic ($F000), 1 enemy-band kernel ($D000, shifted +$100), 2 top score/attract kernels ($F000),
3 bottom panel + era icon ($D000). Superchip RAM: write $x000-$x07F, read $x080-$x0FF (unused so far).
Switch stubs in each bank's unused tail $xFE5-$xFF5; cycle pad PAD1 keeps band timing identical (22 cycles).
