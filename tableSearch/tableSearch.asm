
; tableSearch.asm
;
; Created: 23/07/2021 9:54:00 AM
; Author : James Meldrum
;

; Define here the variables
.def  temp  =r16 ; temp stores the current value we're looking into in the table
.def  maxVal =r17 ; maxVal stores the largest value found in the array

; Define here Reset and interrupt vectors, if any
; the only one at the moment is the reset vector
;that points to the start of the program (i.e., label: start)
reset:
   rjmp start
   reti      ; Addr $01
   reti      ; Addr $02
   reti      ; Addr $03
   reti      ; Addr $04
   reti      ; Addr $05
   reti      ; Addr $06        Use 'rjmp myVector'
   reti      ; Addr $07        to define a interrupt vector
   reti      ; Addr $08
   reti      ; Addr $09
   reti      ; Addr $0A
   reti      ; Addr $0B        This is just an example
   reti      ; Addr $0C        Not all MCUs have the same
   reti      ; Addr $0D        number of interrupt vectors
   reti      ; Addr $0E
   reti      ; Addr $0F
   reti      ; Addr $10

; Program starts here after Reset
start:		; start here

; The Z register is used as a pointer to the t  entries in the table 
; so we need to load the location of the table into the high and 
; low byte of Z. 
; Note how we use the directives 'high' and 'low' to do this.
	LDI ZH, high(Tble<<1)	; Initialize Z-pointer
	LDI ZL, low(Tble<<1)	; a byte at a time  (why <<1?)



loop:
	LPM temp, Z				; Load constant from table in memory pointed to by Z (r31:r30)
	CP maxVal, temp         ; Equivalent to if(temp - maxVal > 0) { call assignMaxVal }
	BRLO assignMaxVal       ; 
incr:
	INC ZL 		; move the array pointer
	; Note here that we only increment and compare the lower byte
	; (very risky - why risky?).
	CPI ZL, LOW((Tble << 1) + 64) ; Tble+64 is one past the final entry
	BRNE loop

skrt:
	JMP exit

assignMaxVal:
	MOV maxVal, temp		; Initialize maxVal ; TODO this should be the minium value expressable (We just use unsigned ints here)
	JMP incr				; Once updated, jump back to incrementing the table cursor (pointer to current value in table we're comparing against the largest)

exit:
	RET

; Create 64 bytes in code memory of table to search.
; The DC directive defines constants in (code) memory
; you will search this table for the desired entry.
Tble:
	.DB 190, 109, 110,  32,   7,  74,  81, 167
	.DB 245, 239, 117,   0, 195, 194, 189, 191
	.DB  98,  42, 203, 223,  90,  83,  76, 136
	.DB 213, 153,  86,  77, 116, 108,  92, 143
	.DB 102,  19, 175, 103, 251,  68, 154,  12
	.DB 181, 127,  80,  43, 159, 252,  44,  76 
	.DB 170, 229, 132, 180,  40, 244, 138, 174
	.DB  28, 162, 252,  55,  26, 211,  45,  58
.exit  ;done
