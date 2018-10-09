#include <WProgram.h>
#include <xc.h>
/* define all global symbols here */
.global main
    

.text
.set noreorder

.ent main
main:
    /* this code blocks sets up the ability to print, do not alter it */
    ADDIU $v0,$zero,1
    LA $t0,__XC_UART
    SW $v0,0($t0)
    LA $t0,U1MODE
    LW $v0,0($t0)
    ORI $v0,$v0,0b1000
    SW $v0,0($t0)
    LA $t0,U1BRG
    ADDIU $v0,$zero,12
    SW $v0,0($t0)
    
    /* your code goes underneath this */
    LA $a0,HelloWorld
    JAL puts
    NOP
    
    /* slide swithces 
	1/RD8/2
	2/RD9/7
	3/RD10/8
	4/RD11/35
       
	push button
	1/RF1/4    < ==== portF
	2/RD5/34
	3/RD6/36
	4/RD7/37
	
	LED (portE) 8 bit
	0/RE0/33
	1/RE1/32
	2/RE2/31
	3/RE3/30
	4/RE4/29
	5/RE5/28
	6/RE6/27
	7/RE7/26
    */
    
    # Initialize TRISE, PORTE
    # clear - offset 4
    andi $t9, $t9, 0x0 
    addi $t9, $t9, 0x0FF 
    sw $t9, TRISECLR
    sw $t9, PORTECLR
   
    loop:
    # load portD, portF
    lw $t1, PORTD 
    lw $t2, PORTF 
    la $t3, PORTE # get address of portE
    
    # Switches (1-4) - portD - it is in 8 - 11 bit 
    srl $t4, $t1, 8 # Shift bits to 8 bit
    andi $t8, $t4, 0x000F # now shifted switch bit is check AND for 1111 
    sw $t8, 0($t3) # store into portE 0-3-bit

    # push button 1 - portF1 - 0010  
    sll $t6, $t2, 3 # Shift bits left 3 so 0001 0000
    andi $t7, $t6, 0x0010 # AND 0001 0000
    sw $t7, 0($t3) # store into portE 4-bit
    
    # push button 2-4 - portD
    andi $t5, $t1, 0x00E0 # and statement at 5,6,7 bit (0x00E0 = 1110 0000)
    add $t8, $t8, $t5 
    sw $t8, 0($t3) # store into portE 5-7-bit
    
    J loop
    NOP
    
    
hmm:    J hmm
    NOP
endProgram:
    J endProgram
    NOP
.end main



.data
HelloWorld: .asciiz "Assembly Hello World \n"


