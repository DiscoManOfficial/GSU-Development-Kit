; ================================= ;
; Super FX Development Kit			;
;	by DiscoTheBat					;
; Read the Readme for details		;
; ================================= ;

sa1rom	;sfxrom don't work

!true = 1
!false = 0

!IRQLoc	=	$1000
!NMILoc	=	(IRQEnd-IRQ)+!IRQLoc

!R0				= $3000		; Default source/destination register
!R1				= $3002		; PLOT X position
!R2				= $3004		; PLOT Y position
!R3				= $3006		; (SP)
!R4				= $3008
!R5				= $300A		;
!R6				= $300C		; Multiplier for FMULT and LMULT
!R7				= $300E		;
!R8				= $3010		; Used in MERGE
!R9				= $3012		; Used in MERGE
!R10			= $3014		;
!R11			= $3016		; Return address set by LINK
!R12			= $3018		; Loop counter
!R13			= $301A		; Loop address
!R14			= $301C		; ROM buffer
!R15			= $301E		; Program counter
!SFR			= $3030		; Super FX status flag
!PBR			= $3034		; Program bank
!ROMBR			= $3036		;
!RAMBR			= $303C		;
!CBR			= $303E		;
!SCBR			= $3038		;
!SCMR			= $303A		;
!BRAMR			= $3033		;
!VCR			= $303B		;
!CFGR			= $3037		;
!CLSR			= $3039		;
!SP 			= $2FFF		; Stack Pointer

org $FFBD	;\ Expansion RAM Size
db $07		;/ For the SuperFX

org	$FFDA	;\ Enable correct handling of SRAM space
db	$33		;/

org	$FFB6							;\ Fixed data
db	$00,$00,$00,$00,$00,$00,$00		;/ Avoid issues with RAM data

org $FFD6	;\ Activate Super FX
db $15		;/

org $FFD8	;\ No SRAM necessary (?)
db $07		;/

org $FFE0	;Repoint Vector Info - Native
dw $0100,$0100,$0104,$0100,$0100,$0108,$8000,$010C

org $FFF0	;Repoint Vector Info - Emulation
dw $0100,$0100,$0104,$0100,$0100,$0108,$8000,$010C

ORG $8023					;\ Set Stack Pointer to $1FFF.
LDA #$1FFF					;/

if read1($806B) != $5C	;\  This hijack puts NMI loop into WRAM
ORG $806B				; | helps SNES to handle its issues better
	JMP RAMData_Wait	; | Also lends a bit of performance increase
	NOP					; | Fixes NMI usage as the wait loop is on WRAM
endif					;/	Allows Super FX to run at its maximum speed
	
org $8391						;\ IRQ routine checks for Super FX
	JSR RAMData_WaitForHBlank	;/

org $83C8						;\ However it is wise to be sure waits are done in WRAM
	JSR RAMData_WaitForHBlank	;/

incsrc "remap/dp.asm"				; Remaps $7E:0000-$7E:00FF
incsrc "remap/addr.asm"				; Remaps $7E:0100-$7E:1FFF
incsrc "remap/sram.asm"				; Remaps SRAM
incsrc "remap/map16.asm"			; Remaps Map16

org $008027
autoclean JML InitSuperFX

freedata
incsrc "boost/unrolled.asm"				; Offscreen Sprite Routine speed up.
incsrc "boost/oam.asm"					; OAM speed up.
InitSuperFX:

	PHB																	;\
	REP #$30															;|
	LDA #(RAMData_End-RAMData)-1										;| Copy RAM Code into RAM
	LDX #RAMData														;| RAM $7E1E80
	LDY #$1E80															;|
	MVN	$7E,RAMData>>16													;|
	LDA #(IRQEnd-IRQ)-1													;| Copy IRQ Handler into RAM
	LDX #IRQ															;| Actually RAM $7E1000
	LDY #!IRQLoc														;|
	MVN	$7E,IRQ>>16														;|
	LDA #(NMIEnd-NMI)-1													;| Copy NMI Handler into RAM
	LDX #NMI															;| Actually RAM $7E1024
	LDY #!NMILoc														;|
	MVN	$7E,NMI>>16														;|
	LDA #!SP															;| Set up stack pointer
	STA !R3																;| Note that it uses R3!
	SEP #$30															;|
	PLB																	;/

	LDA #$A0		;\SuperFX Init Code (Sets IRQ Mask, Multiply Speed, Double Clock and Backup RAM)
	STA !CFGR		;|
	LDA #$01		;|<Note: Manual states to NOT use this settings... But if Yoshi's Island uses... Why not me?>
	STA !CLSR		;|<Plus, it allows for EXTREMELY fast speed since MULT is done quickier as well>
	STA !BRAMR		;|<Note2: Newer versions don't use $A0... Why Nintendo... You can change to what option you think it's better>
	STZ !SCBR		;/

	LDA #$40	;\RTI
	STA $0104	;|
	STA $0100	;/

	LDA #$4C	;\
	STA $0108	;|
	LDA #$24	;|
	STA $0109	;|NMI Code Location
	LDA #$10	;|Uses RAM $7E1024
	STA $010A	;/

	LDA #$4C	;\
	STA $010C	;|
	STZ $010D	;|IRQ Code Location
	LDA #$10	;|Uses RAM $7E1000
	STA $010E	;/
	JML $008052
	
RAMData:
base $1E80			; This will get uploaded to $7E1E80

.InvokeGSU
	LDX #$3D			;\ Give Super FX Game Pak ROM and RAM access
	STX !SCMR			;/
	STY !PBR			; Set Super FX bank
	STA !R15			; (PC)
	SEP #$20			; Clear 16-bit mode
	LDA #$20			;\	Check for G (Go) Flag
-	BIT	!SFR			; | If routine isn't finished yet
	BNE	-				;/	Loop until it is...
	STZ !SCMR			; Give back ROM and RAM access to the SNES
	RTS

-	WAI				; Wait for any interrupt.
.Wait	LDA $10		;\ If NMI isn't ran yet, wait for interrupt.
	BEQ -			;/
	JMP $806F		; Return

-	LDY #$20
.WaitForHBlank
	BIT $4212
	BVS -
-	BIT $4212
	BVC -
-	DEY
	BNE -
	RTS
base off
.End

IRQ:
incsrc "superfxfiles/irqpatch.asm"
IRQEnd:

NMI:
incsrc "superfxfiles/nmipatch.asm"
NMIEnd:

print "Insert size............. ", freespaceuse, " bytes."
print "Total bytes modified.... ", bytes, " bytes."
print "Kit inserted successfully!"