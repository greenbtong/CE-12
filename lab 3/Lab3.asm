; Brian Tong
; btong1@ucsc.edu 
; 1315598
; Section 01C MW 1-3 - TA: Mike - Tutor: Sasha
; Lab 3 Decimal Converter


	.ORIG x3000
	
	;greeting 
	LEA R0, GREETING
	PUTS	
	
	;the question
LOOP	LEA R0, QUESTION
	PUTS

	;clear everything
	AND R0, R0, 0 
	AND R1, R1, 0 ;R1 = neg/pos   
	AND R2, R2, 0 ;R2 = input sum

	;users input
INPUT	GETC 
	OUT
	
	;clear out. These will be temps
	AND R3, R3, 0 
	AND R4, R4, 0 
	AND R5, R5, 0
	AND R6, R6, 0
	AND R7, R7, 0	

	;check the first char. if neg/pos 
	;negative = 45
	AND R5, R5, 0
	LD R5, NEGATIVE
	AND R4, R4, 0
	ADD R4, R4, R0
	ADD R4, R4, R5 
	BRz NEG

	;check if the char is "ENTER"
	;ENTER = 10
	ADD R3, R3, R0
	ADD R3, R3, -10
	BRz NEXT

	;check if the char is "X"
	;X = 88
	AND R5, R5, 0
	LD R5, X
	AND R4, R4, 0
	ADD R4, R4, R0
	ADD R4, R4, R5
	BRz END

	;get the digit from the char (value will be held in R6)
	;0 = 48
	AND R5, R5, 0
	LD R5, NUMBERS
	ADD R6, R6, R0
	ADD R6, R6, R5

	;now consider the tenth, hundredth, thousandth place
	;set up for the for loop
	ADD R7, R7, 9 ; for a for loop (10 X)
	AND R3, R3, 0 ; clear temp for use
	ADD R3, R3, R2 ; temp uses as the previous sum

	; For loop
FOR	ADD R2, R2, R3 ; start of the for loop
	ADD R7, R7, -1 ; counter
	BRp FOR 

	;add the char to the sum
	ADD R2, R2, R6
	BRnzp INPUT ; get the next char

	;negative setting R1 = 1 = negative
NEG	ADD R1, R1, 1
	BRnzp INPUT ; get the next char

	; if R1 = 1 inverse value
INVERSE	NOT R2, R2 
	ADD R2, R2, 1
	BRnzp READ

	;Determine if it is negative or not
NEXT	ADD R1, R1, 0
	BRp INVERSE

	;display string
READ	LEA R0, ANSWER
	PUTS

	;clear temps (just in case)
	AND R3, R3, 0 ; MASK 
	AND R4, R4, 0 ; pointer
	AND R5, R5, 0 ; counter

	;convert string to binary
MASKLOOP AND R6, R6, 0 ; temp
	LEA R3, MASK
	ADD R3, R3, R4 ; shift pointer
	LDR R3, R3, 0 ; load value at address
	AND R6, R3, R2 ; determine if binary is zero or one
	BRz OUTZERO
	BRnp OUTONE

	;After output of zero or one
MASKCONT ADD R4, R4, 1 ;pointer shifed
	ADD R5, R4, -16 ; counter 
	BRn MASKLOOP ; ends when R4 = 16 and R5 = 0
	
	;"ENTER" = 10
	AND R0, R0, 0 
	ADD R0, R0, 10
	OUT
	BRnzp LOOP

	;print out 0
OUTZERO	AND R0, R0, 0
	LD R0, ZERO
	OUT
	BRnzp MASKCONT

	;print out 1
OUTONE	AND R0, R0, 0
	LD R0, ONE
	OUT
	BRnzp MASKCONT

	;concluded
END	LEA R0, OVER
	PUTS
	HALT
	
;String variables	
GREETING .STRINGZ "Welcome to the Conversion Program\n"
QUESTION .STRINGZ "Enter a decimal number or X to quit: \n"
ANSWER	.STRINGZ "Thanks, here it is in binary\n"
OVER	.STRINGz "\nBye. Have a great day."

;Constants
ZERO 	.FILL x30
ONE	.FILL x31
X	.FILL -88
NUMBERS	.FILL -48
NEGATIVE .FILL -45

;16 bit binary 
MASK	.FILL x8000
	.FILL x4000
	.FILL x2000
	.FILL x1000

	.FILL x0800
	.FILL x0400
	.FILL x0200
	.FILL x0100

	.FILL x0080
	.FILL x0040
	.FILL x0020
	.FILL x0010

	
	.FILL x0008
	.FILL x0004
	.FILL x0002
	.FILL x0001

	.END