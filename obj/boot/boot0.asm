
obj/boot/boot0.elf:     file format elf32-i386


Disassembly of section .text:

00007c00 <start>:
    /* assemble the file in 16-bit mode */

    /* Clear the interrupts flag, disabling the interrupts.
     * Clear the direction flag, to configure auto-increment mode.
     */
    cli
    7c00:	fa                   	cli    
    cld
    7c01:	fc                   	cld    
*   YOUR 16-bit CODE
*******************************************************************************/

/*step 2, Clear the segment registers ​%ds​,​ %es​, ​%fs,​ %gs,​and ​%ss.​*/

    xorw %bx , %bx
    7c02:	31 db                	xor    %bx,%bx
    mov  %bx , %ds
    7c04:	8e db                	mov    %bx,%ds
    mov  %bx , %es
    7c06:	8e c3                	mov    %bx,%es
    mov  %bx , %fs 
    7c08:	8e e3                	mov    %bx,%fs
    mov  %bx , %gs  
    7c0a:	8e eb                	mov    %bx,%gs
    mov  %bx , %ss  
    7c0c:	8e d3                	mov    %bx,%ss

/*step 3, Setup the stack.*/

    mov  $0x7bfc , %sp 
    7c0e:	bc fc 7b             	mov    $0x7bfc,%sp

/*step 4, Setup normal video mode (80 x 25 text), and print a start up message (STARTUP_MSG)*/

    xorb %ah , %ah
    7c11:	30 e4                	xor    %ah,%ah
    movb $0x03, %al      
    7c13:	b0 03                	mov    $0x3,%al
    int $0x10
    7c15:	cd 10                	int    $0x10
    movb $0xe, %ah      
    7c17:	b4 0e                	mov    $0xe,%ah
    mov  $STARTUP_MSG , %si
    7c19:	be 3e 7c             	mov    $0x7c3e,%si
    call Print_Char
    7c1c:	e8 4f 00             	call   7c6e <Print_Char>
# 1.About this part pushw=push because it is a .code16 16bit code.
# 2.Also pushl= twice push, we could this one of them once to fill the LBA 4bytes
# 3.We may also use move %eax, push %eax to fix it.
# Based on these, I used a combination to fix this part.

    pushw $0x00       #Upper 16-bits of 48-bit starting LBA
    7c1f:	6a 00                	push   $0x0
    pushw $0x00 
    7c21:	6a 00                	push   $0x0

    mov  $0x0001,%eax #lower 16-bits of 48-bit starting LBA
    7c23:	66 b8 01 00 00 00    	mov    $0x1,%eax
    push %eax #dstination address
    7c29:	66 50                	push   %eax
    # pushl $32256    #Destination address

    # mov  $0x7e00,%eax #Destination address
    # push %eax #dstination address

    push $0            #Destination address
    7c2b:	6a 00                	push   $0x0
    push $0x7e00       #Destination address
    7c2d:	68 00 7e             	push   $0x7e00

    push $62 #Number of sectors to read
    7c30:	6a 3e                	push   $0x3e
    push $0x10 #Size of DAP (16 bytes)
    7c32:	6a 10                	push   $0x10

    mov  $0x42 , %ah
    7c34:	b4 42                	mov    $0x42,%ah
    mov %sp , %si
    7c36:	89 e6                	mov    %sp,%si

/*step 5, interrupt and jump to the correct address to start up the boot1*/

    int  $0x13
    7c38:	cd 13                	int    $0x13

    push $0x7e00  #jmp
    7c3a:	68 00 7e             	push   $0x7e00
    ret
    7c3d:	c3                   	ret    

00007c3e <STARTUP_MSG>:
    7c3e:	53                   	push   %bx
    7c3f:	74 61                	je     7ca2 <__bss_start+0x2a>
    7c41:	72 74                	jb     7cb7 <__bss_start+0x3f>
    7c43:	20 62 6f             	and    %ah,0x6f(%bp,%si)
    7c46:	6f                   	outsw  %ds:(%si),(%dx)
    7c47:	74 30                	je     7c79 <__bss_start+0x1>
    7c49:	20 2e 2e 2e          	and    %ch,0x2e2e
    7c4d:	0d 0a 00             	or     $0xa,%ax

00007c50 <LOAD_FAIL_MSG>:
    7c50:	45                   	inc    %bp
    7c51:	72 72                	jb     7cc5 <__bss_start+0x4d>
    7c53:	6f                   	outsw  %ds:(%si),(%dx)
    7c54:	72 20                	jb     7c76 <Print_Char+0x8>
    7c56:	64 75 72             	fs jne 7ccb <__bss_start+0x53>
    7c59:	69 6e 67 20 6c       	imul   $0x6c20,0x67(%bp),%bp
    7c5e:	6f                   	outsw  %ds:(%si),(%dx)
    7c5f:	61                   	popa   
    7c60:	64 69 6e 67 20 62    	imul   $0x6220,%fs:0x67(%bp),%bp
    7c66:	6f                   	outsw  %ds:(%si),(%dx)
    7c67:	6f                   	outsw  %ds:(%si),(%dx)
    7c68:	74 31                	je     7c9b <__bss_start+0x23>
    7c6a:	2e 0d 0a 00          	cs or  $0xa,%ax

00007c6e <Print_Char>:

LOAD_FAIL_MSG:
    .ascii    "Error during loading boot1.\r\n\0"

Print_Char:
    lodsb
    7c6e:	ac                   	lods   %ds:(%si),%al
    cmp $0, %al
    7c6f:	3c 00                	cmp    $0x0,%al
    je done
    7c71:	74 04                	je     7c77 <done>
    int $0x10
    7c73:	cd 10                	int    $0x10
    jmp Print_Char
    7c75:	eb f7                	jmp    7c6e <Print_Char>

00007c77 <done>:
done:
    7c77:	c3                   	ret    
