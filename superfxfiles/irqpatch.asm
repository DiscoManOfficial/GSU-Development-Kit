@includefrom superfx.asm
;====================================
; IRQ Handler
;====================================

base !IRQLoc
PHP
REP #$30
PHA
PHX
PHY
PHB
SEP #$30
LDA #$00
PHA
PLB

LDA #$20			; Check G (Go) Flag & IRQ Flag
BIT !SFR			;\ If operation isn't done
BNE .NoIRQ			;/ skip...

LDA $4211
JML $008383	; IRQ

.NoIRQ
REP #$30                  ; \ Pull everything back ; Index (16 bit) Accum (16 bit) 
PLB                       ;  | 
PLY                       ;  | 
PLX                       ;  | 
PLA                       ;  | 
PLP                       ; / 
RTI                       ; And Return 
base off