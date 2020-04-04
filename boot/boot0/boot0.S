/*
 * Filename: boot0.S
 * Description:
 *  - Sets up the machine registers (including the stack pointers) properly
 *    for execution in 16-bit mode.
 *  - Utilizes the BIOS interrupt mechanism to output messages to the screen.
 *  - Reads the second stage bootloader from the disk into appropriate location.
 *    (boot1 is put just after MBR and before the first partition, i.e. from
 *    sector 2 to sector 63.)
 *  - Correctly transfers execution to the loaded second stage bootloader.
 */

 /* define the boot0 and boot1 address */
    
    .globl start
start:
    /* assemble the file in 16-bit mode */

    /* Clear the interrupts flag, disabling the interrupts.
     * Clear the direction flag, to configure auto-increment mode.
     */
    cli
    cld

    .code16
/*******************************************************************************
*   YOUR 16-bit CODE
*******************************************************************************/

/*step 2, Clear the segment registers ​%ds​,​ %es​, ​%fs,​ %gs,​and ​%ss.​*/

    xorw %bx , %bx
    mov  %bx , %ds
    mov  %bx , %es
    mov  %bx , %fs 
    mov  %bx , %gs  
    mov  %bx , %ss  

/*step 3, Setup the stack.*/

    mov  $0x7bfc , %sp 

/*step 4, Setup normal video mode (80 x 25 text), and print a start up message (STARTUP_MSG)*/

    xorb %ah , %ah
    movb $0x03, %al      
    int $0x10
    movb $0xe, %ah      
    mov  $STARTUP_MSG , %si
    call Print_Char
    

/*step 5, Load the second stage bootloader to the correct memory location*/
# 1.About this part pushw=push because it is a .code16 16bit code.
# 2.Also pushl= twice push, we could this one of them once to fill the LBA 4bytes
# 3.We may also use move %eax, push %eax to fix it.
# Based on these, I used a combination to fix this part.

    pushw $0x00       #Upper 16-bits of 48-bit starting LBA
    pushw $0x00 

    mov  $0x0001,%eax #lower 16-bits of 48-bit starting LBA
    push %eax #dstination address

    # pushl $32256    #Destination address

    # mov  $0x7e00,%eax #Destination address
    # push %eax #dstination address

    push $0            #Destination address
    push $0x7e00       #Destination address

    push $62 #Number of sectors to read
    push $0x10 #Size of DAP (16 bytes)

    mov  $0x42 , %ah
    mov %sp , %si

/*step 5, interrupt and jump to the correct address to start up the boot1*/

    int  $0x13

    push $0x7e00  #jmp
    ret

/*******************************************************************************
*   DATA STRUCTURES
*******************************************************************************/

STARTUP_MSG:
    .ascii    "Start boot0 ...\r\n\0"

LOAD_FAIL_MSG:
    .ascii    "Error during loading boot1.\r\n\0"

Print_Char:
    lodsb
    cmp $0, %al
    je done
    int $0x10
    jmp Print_Char
done:
    ret