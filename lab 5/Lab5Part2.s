
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
    
    # some constants
    andi $t2, $t2, 0x0
    li $t9, 0x9
    li $t7, 1
    
    # loop 
    loop:
    # load portD
    la $t1, PORTE # get address of portE
    
    # call functions
    jal LEDon
    NOP

    jal myDelay
    NOP
 
    # determine if it goes 1-8 or 8-1 LED
    bltz $t2, inc 
    beq $t2, $t9, dec
       
    ADDV:
    addu $t2, $t2, $t7
    J loop
    NOP  
   
    # 8 -> 1
    dec:
    jal LEDon
    li $t7, -1
    J ADDV
    NOP
    
    # 1 -> 8
    inc:
    jal LEDon
    li $t7, 1
    J ADDV
    NOP
    
    /*	     functions		*/  
    
    # led on/off function
    LEDon:
    li $t8, 1
    sll $t3, $t8, $t2
    sw 	$t3, 0($t1)	
    jr	$ra
    NOP
 
    # delay function
    myDelay:
    lw $t0, PORTD
    srl $t6, $t1, 8
    addi $t0, $t0, 1
    li $t4,  200          # delay = 200
    mul $t5, $t0, $t4 
    loop1: beqz $t5, done    # if zero then done
    NOP
    addi    $t5, $t5, -1      
    J loop1             
    NOP
    done:   
    jr $ra                 	
    NOP
    
/* return to main */
    
hmm:    J hmm
    NOP
endProgram:
    J endProgram
    NOP
.end main



.data
HelloWorld: .asciiz "Assembly Hello World \n"


