@includefrom superfx.asm
pushpc

ORG $008494
LabelOAM:
	REP #$20
	LDY.b #CompressOAM>>16	;\
	LDA.w #CompressOAM		;/This code will load the SuperFX code in ROM
	JMP $1E80
	rep 42 : nop
warnpc $0084C8

pullpc

arch superfx
CompressOAM:
	SUB R0			;\ Clean ROM Bank
	ROMB			;/
	IBT R12,#$1F	;Set loop counter
	IBT R6,#$04		;Multiplication
	IWT R14,#$8474	;Start ROM Fetching (useless thanks to next instruction)
	WITH R14		;\Do index...
	ADD R12			;/$8474+R12+1 (Stop current fetch and fetch new data)
	IWT R2,#$0400	;RAM Address
	WITH R2			;Set R2 as source and destination
	ADD R12			;Do $6400+R12
	CACHE			;Put everything on CACHE RAM
	MOVE R13,R15	;Set loopback address
	IWT R1,#$0427	;RAM Address
	TO R5			;Set R5 as destination
	GETB			;Get ROM byte to R5
	WITH R1			;\Do index...
	ADD R5			;/$6423+R5
	DEC R14			;\ Fix R14 address
	DEC R14			;/
	LDW (R1)
	MULT R6			;Multiply R0 by 4
	DEC R1			;Do $6427-1 = $6426
	TO R5			;Set R5 as destination
	LDW (R1)		;Load whatever is in R1 to R5
	OR R5			;Do OR R5 on R0 and store it on R0
	MULT R6			;Multiply R0 by 4
	DEC R1			;Do $6426-1 = $6425
	TO R5			;Set R5 as destination
	LDW (R1)		;Load whatever is in R1 to R5
	OR R5			;Do OR R5 on R0 and store it on R0
	MULT R6			;Multiply R0 by 4
	DEC R1			;Do $6425-1 = $6424
	TO R5			;Set R5 as destination
	LDW (R1)		;Load whatever is in R1 to R5
	OR R5			;Do OR R5 on R0 and store it on R0
	STB (R2)		;Store whatever was in R0 to address in R2
	DEC R1			;Do $6424-1 = $6423
	DEC R2			;Grab $6401 and DEC it
	LDW (R1)
	MULT R6			;Multiply R0 by 4
	DEC R1			;Do $6423-1 = $6422
	TO R5			;Set R5 as destination
	LDW (R1)		;Load whatever is in R1 to R5
	OR R5			;Do OR R5 on R0 and store it on R0
	MULT R6			;Multiply R0 by 4
	DEC R1			;Do $6422-1 = $6421
	TO R5			;Set R5 as destination
	LDW (R1)		;Load whatever is in R1 to R5
	OR R5			;Do OR R5 on R0 and store it on R0
	MULT R6			;Multiply R0 by 4
	DEC R1			;Do $6421-1 = $6420
	TO R5			;Set R5 as destination
	LDW (R1)		;Load whatever is in R1 to R5
	OR R5			;Do OR R5 on R0 and store it on R0
	STB (R2)		;Store whatever was in R0 to address in R2
	DEC R2			;Fix R2 address
	LOOP			;Guess what?
	DEC R12			;Decrement loop counter once more
	STOP			;Put CPU to sleep
arch 65816