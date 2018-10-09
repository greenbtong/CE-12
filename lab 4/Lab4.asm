; Brian Tong
; btong1@ucsc.edu 
; 1315598
; Section 01C MW 1-3 - TA: Mike - Tutor: Sasha
; Lab 4 Caesar Cipher


	.ORIG x3000
	
	;CLEAR 
	AND R0, R0, 0 
	AND R1, R1, 0 
	AND R2, R2, 0 
	AND R3, R3, 0 
	AND R4, R4, 0 
	AND R5, R5, 0 
	AND R6, R6, 0 
	AND R7, R7, 0 

	;greeting
	LEA R0, GREETING
	PUTS 

	;the question
LOOP 	LEA R0, QUESTION
	PUTS 

	;user's input
INPUT	GETC 
	OUT 

	;clear temps 
	JSR rARRAY 
	AND R5, R5, 0
	ST R5, MOVED 

	;check if the char is "X"
	;X = 88
	AND R5, R5, 0
	LD R5, X
	AND R6, R6, 0
	ADD R6, R6, R0
	ADD R6, R6, R5
	BRz END

	;check if the char is "E"
	;E = 69
	AND R5, R5, 0
	LD R5, E
	AND R6, R6, 0 
	ADD R6, R6, R0
	ADD R6, R6, R5
	BRz eFLAG
	
	;check if the char is "D"
	;D = 68
	AND R5, R5, 0
	LD R5, D
	AND R6, R6, 0 
	ADD R6, R6, R0
	ADD R6, R6, R5
	BRz dFLAG

	;if input is none of the above (try again) 
	BRnzp INPUT

	;Decrypted Flag
dFLAG 	AND R1, R1, 0 
	ADD R1, R1, 1 
	ST R1, TYPE
	BRnzp CIPHER

	;Encrypted Flag
eFLAG 	AND R1, R1, 0 
	ADD R1, R1, 0 
	ST R1, TYPE 
	BRnzp CIPHER

	;ask user for cipher value
CIPHER	LEA R0, CIPHERQ 
	PUTS 

	;value can go from 1-25 (so loop to read two digits) 
cLOOP 	GETC 
	OUT

	;check if the char is "ENTER"
	;ENTER = 10
	AND R6, R6, 0
	ADD R6, R6, R0
	ADD R6, R6, -10
	BRz NEXT

	;get number value
	AND R3, R3, 0
	LD R3, NUMBERS
	AND R6, R6, 0
	ADD R6, R6, R0
	ADD R6, R6, R3

	;now consider the tenth place
	;set up for the for loop
	AND R4, R4, 0 
	ADD R4, R4, 9 ; for a for loop (10 X)
	AND R2, R2, 0 
	AND R3, R3, 0 
	AND R5, R5, 0 
	LD R2, MOVED 
	ADD R3, R3, R2 ;temp use
	

	;For loop
mFOR	ADD R2, R2, R3 
	ADD R4, R4, -1 ;counter
	BRp mFOR

	;add the char value to get the sum
	AND R1, R1, 0 
	ADD R2, R2, R6 
	ST R2, MOVED 
	BRnzp cLOOP

	;Ask User for string
NEXT	LEA R0, INSTRING
	PUTS

	;char count intialized 
	AND R5, R5, 0
	LD R5, COUNT 
	ADD R5, R5, -1 
	ST R5, COUNT 

	;Read user's string
sLOOP 	GETC
	OUT

	;count the number of char
	AND R5, R5, 0 
	LD R5, COUNT 
	ADD R5, R5, 1 
	ST R5, COUNT 
	
	;check if the char is "ENTER"
	AND R6, R6, 0
	ADD R6, R6, R0
	ADD R6, R6, -10
	BRz RESULTS

	;store string to array
	ST R5, COL
	AND R4, R4, 0 
	ST R4, ROW
	ST R0, TEMPCHAR ;use to pass around
	JSR STORE

	;determine if user wanted D/E
	LD R2, TYPE 
	BRz ENCRYPT
	BRp DECRYPT

	;user wants string to be encrypted
ENCRYPT	JSR ENCRYPTING
	BRnzp sLOOP

	;user wants string to be decrypted
DECRYPT JSR DECRYPTING 
	BRnzp sLOOP

	;print outputs
RESULTS	LEA R0, ANSWER
	PUTS 

	JSR PRINT
	BRnzp LOOP
	
	;concluded
END 	LEA R0, OVER 
	PUTS 
	HALT

GREETING .STRINGZ "Hello, welcome to my Caesar Cipher program \n"
QUESTION .STRINGZ "(E)ncrypt or D(ecrypt) or e(X)it? \n"
CIPHERQ .STRINGZ "\nCipher (1-25)\n"
INSTRING .STRINGZ "String (200)\n"
ANSWER .STRINGZ "Result"
ENCRYPTED .STRINGZ "\n<Encrypted> "
DECRYPTED .STRINGZ "\n<Decrypted> "
OVER .STRINGZ "\nGoodbye!"

TYPE .BLKW 1
MOVED .BLKW 1
COUNT .BLKW 1
COL .BLKW 1
ROW .BLKW 1
TEMPCHAR .BLKW 1
SAVE .BLKW 1


AVALUE .FILL 199
D	.FILL -68
E	.FILL -69
X	.FILL -88
NUMBERS	.FILL -48
CAPSTART .FILL 65
upSTART .FILL -65
upEND	.FILL -90
UNDSTART .FILL 97
lowSTART .FILL -97
lowEND	.FILL -122
ALPHABET .FILL 26

;FUNCTIONS

;ARRAY RESET FUNCTION
	;set up pointers
rARRAY	AND R1, R1, 0
	AND R2, R2, 0 
	AND R3, R3, 0
	AND R4, R4, 0 
	AND R5, R5, 0
	LD R3, AVALUE
	ADD R3, R3, R3
	NOT R3, R3
	ADD R3, R3, 1

	;go through the 2-D array and set to 0
rLOOP	LEA R2, ARRAY
	ADD R2, R2, R1
	STR R4, R2, 0 
	ADD R1, R1, 1
	ADD R5, R1, R3
	BRn rLOOP
	RET

;END OF ARRAY RESET FUNCTION

;STORE FUNCTION

	;2d array pointer
STORE	AND R3, R3, 0
	AND R4, R4, 0
	AND R5, R5, 0 
	LD R4, COL
	LD R5, ROW
	BRp MOVES
	BRnz CONTS

	;move pointer to correct index
MOVES	AND R3, R3, 0
	LD R3, AVALUE
	ADD R4, R4, R3
	
	;store char into array
CONTS	AND R3, R3, 0
	LEA R3, ARRAY
	ADD R3, R3, R4 ; get value at address of R5
	LD R5, TEMPCHAR
	STR R5, R3, 0 
	RET

;END OF STORE FUNCTION


;Load array Function
	
	;load array
LOAD	AND R3, R3, 0
	AND R2, R2, 0
	AND R5, R5, 0 
	LD R5, COL
	LD R0, ROW
	BRp MOVEL
	BRnz CONTL

	;move pointer to correct index
MOVEL	LD R2, AVALUE
	ADD R5, R5, R2
	
	;store char into array
CONTL	LEA R3, ARRAY
	ADD R3, R3, R5 ; get value at address of R5
	LDR R3, R3, 0
	ST R3, TEMPCHAR
	RET

;END Load array Function


;ENCRYPTING Function

	;store encrytped string in row tow of array
ENCRYPTING ST R7, SAVE 
	AND R4, R4, 0
	ADD R4, R4, 1 
	ST R4, ROW 

	AND R1, R1, 0 
	AND R2, R2, 0 
	AND R3, R3, 0 
	AND R4, R4, 0 
	AND R5, R5, 0 
	AND R6, R6, 0 
	AND R7, R7, 0 

	;load upper case boundary 
	LD R2, upSTART 
	LD R3, upEND

	;load lower case boundary
	LD R6, lowSTART 
	LD R7, lowEND 
	
	;test if char maybe upper case
	LD R1, TEMPCHAR
	ADD R5, R1, R2 
	BRzp UPPERCONTE
	BRn CONTCHECKE

	;check if char is in upper case range
UPPERCONTE AND R5, R5, 0
	ADD R5, R1, R3 
	BRnz INUPE
	BRp CONTCHECKE

	;in upper range
INUPE 	LD R2, CAPSTART 
	ADD R4, R4, R2
	BRnzp SHIFTE

	;check if char is neither low/up case
CONTCHECKE AND R5, R5, 0 
	ADD R5, R1, R6 
	BRzp LOWERCONTE
	BRn NOTCHARE

	;check if char in in lower case range
LOWERCONTE AND R5, R5, 0 
	ADD R5, R1, R7 
	BRnz INLOWE
	BRp NOTCHARE

	;in lower range
INLOWE	LD R2, UNDSTART
	AND R4, R4, 0
	ADD R4, R4, R2
	BRnzp SHIFTE

	;determine the new shifted spot
SHIFTE	AND R2, R2, 0
	AND R3, R3, 0
	AND R5, R5, 0 
	AND R6, R6, 0 
	AND R7, R7, 0 
	 
	LD R7, MOVED 
	LD R2, ALPHABET ;get -26
	NOT R2, R2 		
	ADD R2, R2, 1 
	
	;char value is negative
	ADD R5, R5, R4 
	NOT R5, R5 
	ADD R5, R5, 1 

	ADD R3, R1, R5 ;get char value (up/low)
	ADD R6, R3, R7 ;MOVED + char value
	ADD R5, R6, R2 ;(if positive - then goes pass)
	BRzp OVERE
	BRn GOODE

	;fix the overloaded char
OVERE	AND R6, R6, 0 
	ADD R6, R5, 0 ;value once the value goes over

	;save the moved char
GOODE	AND R0, R0, 0 
	ADD R0, R4, R6 
	ST R0, TEMPCHAR 
	
	;not a char or ready to store
NOTCHARE JSR STORE
	LD R7, SAVE 
	RET 

;END Encrypting function


;Decrypting function

	;store decrypted string in row two of array
DECRYPTING ST R7, SAVE
	AND R4, R4, 0 
	ADD R4, R4, 1 
	ST R4, ROW 

	AND R1, R1, 0 
	AND R2, R2, 0 
	AND R3, R3, 0 
	AND R4, R4, 0 
	AND R5, R5, 0 
	AND R6, R6, 0 
	AND R7, R7, 0 

	;load upper case boundary 
	LD R2, upSTART 
	LD R3, upEND 

	;load lower case boundary 
	LD R6, lowSTART 
	LD R7, lowEND 

	;test if char maybe upper case
	LD R1, TEMPCHAR 
	ADD R5, R1, R2 	
	BRzp UPPERCONTD
	BRn NOTCHARD

	;check if char is in upper case range
UPPERCONTD AND R5, R5, 0 
	ADD R5, R1, R3 
	BRnz INUPD
	BRp CONTCHECKD

	;in upper range
INUPD	LD R2, CAPSTART 
	ADD R4, R4, R2 
	BRnzp SHIFTD

	;check if char is neither low/up case
CONTCHECKD AND R5, R5, 0 
	ADD R5, R1, R6 
	BRzp LOWERCONTD
	BRn NOTCHARD

	;check if char in in lower case range
LOWERCONTD AND R5, R5, 0 
	ADD R5, R1, R7 
	BRnz INLOWD
	BRp NOTCHARD

	;in lower range
INLOWD	LD R2, UNDSTART
	AND R4, R4, 0 
	ADD R4, R4, R2 
	BRnzp SHIFTD

	;determine the new shifted spot
SHIFTD 	AND R2, R2, 0 
	AND R3, R3, 0
	AND R5, R5, 0 
	AND R6, R6, 0 
	AND R7, R7, 0 

	LD R7, MOVED ;opposite direction
	NOT R7, R7 
	ADD R7, R7, 1 

	LD R2, ALPHABET ;get -26
	NOT R2, R2 
	ADD R2, R2, 1 

	ADD R5, R5, R4 
	NOT R5, R5 
	ADD R5, R5, 1 

	;char value is negative
	ADD R3, R1, R5 ;get char value (up/low)
	ADD R6, R3, R7 ;MOVED + char value
	BRn OVERD
	BRzp GOODD

	;fix the overloaded char
OVERD	LD R2, ALPHABET
	ADD R6, R6, R2 ;value once the value goes over

	;save the moved char
GOODD	AND R0, R0, 0 
	ADD R0, R4, R6
	ST R0, TEMPCHAR 

	;not a char or ready to store
NOTCHARD JSR STORE
	LD R7, SAVE 
	RET 

;END Decrypting function


;Print array function 

	;print 2D array
PRINT	ST R7, SAVE
	AND R1, R1, 0
	AND R2, R2, 0 
	AND R3, R3, 0 
	AND R4, R4, 0
	AND R5, R5, 0
	AND R6, R6, 0
	ADD R4, R4, 1
	LD R5, TYPE
	BRp PRINTE
	BRz PRINTD

	;print out the E/D
nROUND	AND R6, R6, 0
	AND R3, R3, 0
	AND R1, R1, 0
	LD R6, ROW
	ADD R1, R1, 1
	LD R7, TYPE
	BRp PRINTD
	BRz PRINTE

	;encrypted print
PRINTE	LEA R0, ENCRYPTED
	PUTS
	BRnzp PRINTCHARS

	;decrypted print
PRINTD	LEA R0, DECRYPTED
	PUTS
	BRnzp PRINTCHARS
	
	;print the strings	
PRINTCHARS ST R1, ROW
	ST R3, COL
	JSR LOAD
	LD R0, TEMPCHAR
	OUT
	
	LD R2, AVALUE
	NOT R2, R2
	ADD R2, R2, 1
	LD R3, COL
	ADD R3, R3, 1
	ST R3, COL
	AND R6, R6, 0
	ADD R6, R3, R2
	BRn PRINTCHARS

	ADD R4, R4, -1
	BRz nROUND
		
	AND R0, R0, 0
	ADD R0, R0, 10
	OUT
	LD R7, SAVE	
	RET

;END Print Function

ARRAY .BLKW 400

.END