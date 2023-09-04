@includefrom superfx.asm
;====================================
; IRQ Handler
;====================================

base !NMILoc
SEI
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

LDA #$20			; Check G (Go) Flag & IRQ Flag;Check G (Go) Flag & IRQ Flag
BIT !SFR			;\ If operation isn't done;\Loop if operation isn't done
BNE .NoNMI			;/ skip...;/yet...

LDA $4210
JML $008179	; NMI

.NoNMI
REP #$30                  ; \ Pull everything back ; Index (16 bit) Accum (16 bit) 
PLB                       ;  | 
PLY                       ;  | 
PLX                       ;  | 
PLA                       ;  | 
PLP                       ; / 
RTI                       ; And Return 
base off