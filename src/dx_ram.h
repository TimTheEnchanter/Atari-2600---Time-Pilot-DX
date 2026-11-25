; Time Pilot DX - Superchip RAM (128 bytes). Write port $1000-$107F, read port $1080-$10FF.
; $1000/$1080 are valid in every bank (only A12 matters), so these equates work in all four banks.
SCW     = $1000
SCR     = $1080
; ---- allocation (M4)
; $00-$17  enemy slots 0-7: X $00, Y $08, state $10 ................ M4b
; $18-$20  PF1N: next band's first cloud row (PF1), per band
; $21-$29  PF2N: same for PF2
; $2A-$35  M3: heading and shots (see m3.asm)
; $36-$74  per-band sprite tables (below)
; $75-$7F  spare (boss, progress, music)
PF1N    = $18
PF2N    = $21
P1C     = $36           ; P1 coarse delay
P1HM    = $3F           ; P1 HM | REFP1 (bit 3)
P0C     = $48
P0HM    = $51           ; P0 HM | REFP0 (bit 3)
P0LO    = $5A           ; P0 graphics pointer lo (1 = blank)
P0HI    = $63           ; P0 graphics page (era page, $D4 in the ship band)
COL0    = $6C           ; COLUP0 per band
CLB1    = $75           ; cloud PF1 base lo / page, PF2 base lo / page (bank 2 -> bank 3 hand-off)
CLH1    = $76
CLB2    = $77
CLH2    = $78
BUILDT  = 9             ; INTIM units (x64 cycles) DxBuild needs in overscan
BAR     = $79           ; progress bar pattern (PF1 beside the era icon)
EX2     = $00           ; M4b: extra enemy slots (2): X, Y, state (same format as the original's)
EY2     = $02
ES2     = $04
NEX     = 2
TMPX    = $7A           ; builder temp (enemy x for band 8)
ROT     = $7B           ; builder: first enemy this frame
ROTN    = $7C           ; builder: enemies left
ICONIX  = $7D           ; bottom-panel icon table index (stage + 7 * era)
SDIR    = $9E           ; zp: 8-way heading used by the original scroll code (alternates for odd headings)
NENEMY  = 4             ; original enemy slots (zero page)
ENX     = $00A5
ENY     = $00A9
ENS     = $00AD
BOSSHP  = $06           ; boss hits left (0 = no boss)
BOSSDIR = $07           ; boss heading (2 = right, 6 = left)
BOSSFL  = $08           ; boss hit-blink countdown
BOSSB2  = $09           ; builder temp: second half's frame base

    include "dbg.h"
