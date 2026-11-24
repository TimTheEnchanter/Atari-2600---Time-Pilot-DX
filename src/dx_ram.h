; Time Pilot DX - Superchip RAM (128 bytes). Write port $1000-$107F, read port $1080-$10FF.
; $1000/$1080 are valid in every bank (only A12 matters), so these equates work in all four banks.
SCW     = $1000
SCR     = $1080
; ---- planned allocation (offsets) ----
; $00-$1F  extra enemy slots 4-7 (X, Y, state, aux) ........ M4
; $20-$2F  player shots 2-4 (dir, X, Y) ..................... M3
; $30-$3F  boss state, HP, bomb/missile slots ............... M5/M6
; $40-$4F  progress (kills toward 56), parachutist, formation  M4-M6
; $50-$5F  sound/music driver ............................... M7
; $60-$7F  spare
