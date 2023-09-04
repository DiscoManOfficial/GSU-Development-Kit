@includefrom superfx.asm
; ===================================================================
; Repoint $7F8000 to Freespace if any patch, sprite, block or anything else uses it. ;
; ===================================================================

; Actual code for jumping: Freespace + 8

; =======================================================
;  Cancel out RAM routine creation
; =======================================================
pushpc
;ORG $008027
;	SEP #$30	; Not needed
;	BRA +		; GSU patch hijacks this place now :)
;
;ORG $008052
;+	

; =======================================================
;  Repoint every RAM routine JSL to avoid crashes
; =======================================================

ORG $008642
JSL Unroll

ORG $0094FD
JSL Unroll

ORG $0095AB
JSL Unroll

ORG $009632
JSL Unroll

ORG $009759
JSL Unroll

ORG $009870
JSL Unroll

ORG $009888
JSL Unroll

ORG $009A6F
JSL Unroll

ORG $009C9F
JSL Unroll

ORG $00A1C3
JSL Unroll

ORG $00A295
JSL Unroll

ORG $0086D8
JSL Unroll_OAM_0391
RTS
rep 2 : nop
pullpc

Unroll:
REP #$20
LDY.b #Unroll_GSU>>16	;\
LDA.w #Unroll_GSU		;/This code will load the SuperFX code in ROM
JSR $1E80
RTL

Unroll_OAM_0391:
REP #$20
LDY.b #Unroll_GSU2>>16	;\
LDA.w #Unroll_GSU2		;/This code will load the SuperFX code in ROM
JSR $1E80
RTL

arch superfx
Unroll_GSU:
IBT R1,#$F0
IWT R0,#$0201
IBT R2,#$04
IWT R12,#$0081

CACHE
MOVE R13,R15
FROM R1
STB (R0)
LOOP
ADD R2
STOP

Unroll_GSU2:
IBT R1,#$F0
IWT R0,#$0391
IBT R2,#$04
IBT R12,#$1D

CACHE
MOVE R13,R15
STB (R0)
LOOP
ADD R2
STOP
arch 65816
print bytes