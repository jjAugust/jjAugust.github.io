
obj/boot/boot1.elf:     file format elf32-i386


Disassembly of section .text:

00007e00 <start>:
    .globl start
 start:
    /* assemble the following instructions in 16-bit mode */
    .code16

    cli
    7e00:	fa                   	cli    
    cld
    7e01:	fc                   	cld    
    ***************************************************************************/

    /* TODO: PRINT STARTUP MESSAGE HERE */
    
    /*Setup normal video mode (80 x 25 text), and print a start up message (STARTUP_MSG)*/
    movb $0xe, %ah 
    7e02:	b4 0e                	mov    $0xe,%ah
    mov  $STARTUP_MSG , %si
    7e04:	be a3 7e e8 8f       	mov    $0x8fe87ea3,%esi
    call Print_Char
    7e09:	00                 	add    %ah,%ah

00007e0a <seta20.1>:
    /* enable A20
     * This is done because of a quirk in the x86 architecture.
     * See http://wiki.osdev.org/A20 for more information.
     */
seta20.1:
    inb    $0x64, %al
    7e0a:	e4 64                	in     $0x64,%al
    testb    $0x2, %al
    7e0c:	a8 02                	test   $0x2,%al
    jnz    seta20.1
    7e0e:	75 fa                	jne    7e0a <seta20.1>
    movb    $0xd1, %al
    7e10:	b0 d1                	mov    $0xd1,%al
    outb    %al, $0x64
    7e12:	e6 64                	out    %al,$0x64

00007e14 <seta20.2>:
seta20.2:
    inb    $0x64, %al
    7e14:	e4 64                	in     $0x64,%al
    testb    $0x2, %al
    7e16:	a8 02                	test   $0x2,%al
    jnz    seta20.2
    7e18:	75 fa                	jne    7e14 <seta20.2>
    movb    $0xdf, %al
    7e1a:	b0 df                	mov    $0xdf,%al
    outb    %al, $0x60
    7e1c:	e6 60                	out    %al,$0x60

00007e1e <e820>:
     * memory is usable, reserved, or possibly bad.
     *
     * For more information: http://wiki.osdev.org/Detecting_Memory_(x86)
     */
e820:
    xorl    %ebx, %ebx        # ebx must be 0 when first calling e820
    7e1e:	66 31 db             	xor    %bx,%bx
    movl    $SMAP_SIG, %edx   # edx must be 'SMAP' when calling e820
    7e21:	66 ba 50 41          	mov    $0x4150,%dx
    7e25:	4d                   	dec    %ebp
    7e26:	53                   	push   %ebx
    movw    $(smap+4), %di    # set the address of the output buffer
    7e27:	bf 12 7f         	mov    $0xb9667f12,%edi

00007e2a <e820.1>:
e820.1:
    movl    $20, %ecx         # set the size of the output buffer
    7e2a:	66 b9 14 00          	mov    $0x14,%cx
    7e2e:	00 00                	add    %al,(%eax)
    movl    $0xe820, %eax     # set the BIOS service code
    7e30:	66 b8 20 e8          	mov    $0xe820,%ax
    7e34:	00 00                	add    %al,(%eax)
    int    $0x15              # call BIOS service e820h
    7e36:	cd 15                	int    $0x15

00007e38 <e820.2>:
e820.2:
    jc    e820.fail           # error during e820h
    7e38:	72 24                	jb     7e5e <e820.fail>
    cmpl    $SMAP_SIG, %eax   # check eax, which should be 'SMAP'
    7e3a:	66 3d 50 41          	cmp    $0x4150,%ax
    7e3e:	4d                   	dec    %ebp
    7e3f:	53                   	push   %ebx
    jne    e820.fail
    7e40:	75 1c                	jne    7e5e <e820.fail>

00007e42 <e820.3>:
e820.3:
    movl    $20, -4(%di)
    7e42:	66 c7 45 fc 14 00    	movw   $0x14,-0x4(%ebp)
    7e48:	00 00                	add    %al,(%eax)
    addw    $24, %di
    7e4a:	83 c7 18             	add    $0x18,%edi
    cmpl    $0x0, %ebx        # whether it's the last descriptor
    7e4d:	66 83 fb 00          	cmp    $0x0,%bx
    je    e820.4
    7e51:	74 02                	je     7e55 <e820.4>
    jmp    e820.1
    7e53:	eb d5                	jmp    7e2a <e820.1>

00007e55 <e820.4>:
e820.4:                       # zero the descriptor after the last one
    xorb    %al, %al
    7e55:	30 c0                	xor    %al,%al
    movw    $20, %cx
    7e57:	b9 14 00 f3 aa       	mov    $0xaaf30014,%ecx
    rep    stosb
    jmp    switch_prot
    7e5c:	eb 09                	jmp    7e67 <switch_prot>

00007e5e <e820.fail>:
e820.fail:
    /***************************************************************************
     * TODO: PRINT FAILURE MESSAGE HERE
     **************************************************************************/
    /*Setup normal video mode (80 x 25 text), and print a FAILURE message (E820_FAIL_MSG)*/
    movb $0xe, %ah 
    7e5e:	b4 0e                	mov    $0xe,%ah
    mov  $E820_FAIL_MSG , %si
    7e60:	be b5 7e e8 33       	mov    $0x33e87eb5,%esi
    call Print_Char
    7e65:	00                 	add    %dh,%ah

00007e66 <spin16>:
    

spin16:
    hlt
    7e66:	f4                   	hlt    

00007e67 <switch_prot>:
    /***************************************************************************
    *TODO: SETUP JUMP TO PROTECTED MODE
    ***************************************************************************/

    /*  Configure the CPU to use GDT*/
    lgdt gdtdesc      
    7e67:	0f 01 16             	lgdtl  (%esi)
    7e6a:	08 7f 0f             	or     %bh,0xf(%edi)
    
    /*step 4.1 Switch CPU to protected mode */
    movl %cr0,%eax
    7e6d:	20 c0                	and    %al,%al
    xor $0x1, %eax
    7e6f:	66 83 f0 01          	xor    $0x1,%ax
    movl %eax, %cr0
    7e73:	0f 22 c0             	mov    %eax,%cr0
    
    /*step 4.2 issue a long jump */

    ljmp $PROT_MODE_CSEG, $desc
    7e76:	ea 7b 7e 08 00   	ljmp   $0xbb66,$0x87e7b

00007e7b <desc>:
    * YOUR 32-bit mode code here
    ***************************************************************************/

    /*step 4.3 set up the rest of the segment registers to (data segment entry in the GDT)*/

    mov $PROT_MODE_DSEG , %bx
    7e7b:	66 bb 10 00          	mov    $0x10,%bx
    mov %bx , %ds
    7e7f:	8e db                	mov    %ebx,%ds
    mov %bx , %es
    7e81:	8e c3                	mov    %ebx,%es
    mov %bx , %fs
    7e83:	8e e3                	mov    %ebx,%fs
    mov %bx , %gs
    7e85:	8e eb                	mov    %ebx,%gs
    mov %bx , %ss
    7e87:	8e d3                	mov    %ebx,%ss

    pushl $smap
    7e89:	68 0e 7f 00 00       	push   $0x7f0e
    pushl $0x7c00
    7e8e:	68 00 7c 00 00       	push   $0x7c00
    call boot1main
    7e93:	e8 1e 10 00 00       	call   8eb6 <boot1main>

00007e98 <spin>:

    /* It shall never reach here! */
spin:
    hlt
    7e98:	f4                   	hlt    

00007e99 <Print_Char>:

    /*printout a character function by myself*/
    .globl Print_Char
Print_Char:
    lodsb
    7e99:	ac                   	lods   %ds:(%esi),%al
    cmp $0, %al
    7e9a:	3c 00                	cmp    $0x0,%al
    je done
    7e9c:	74 04                	je     7ea2 <done>
    int $0x10
    7e9e:	cd 10                	int    $0x10
    jmp Print_Char
    7ea0:	eb f7                	jmp    7e99 <Print_Char>

00007ea2 <done>:
done:
    ret
    7ea2:	c3                   	ret    

00007ea3 <STARTUP_MSG>:
    7ea3:	53                   	push   %ebx
    7ea4:	74 61                	je     7f07 <gdt+0x17>
    7ea6:	72 74                	jb     7f1c <smap+0xe>
    7ea8:	20 62 6f             	and    %ah,0x6f(%edx)
    7eab:	6f                   	outsl  %ds:(%esi),(%dx)
    7eac:	74 31                	je     7edf <NO_BOOTABLE_MSG+0x8>
    7eae:	20 2e                	and    %ch,(%esi)
    7eb0:	2e 2e 0d 0a 00   	cs cs or $0x7265000a,%eax

00007eb5 <E820_FAIL_MSG>:
    7eb5:	65 72 72             	gs jb  7f2a <smap+0x1c>
    7eb8:	6f                   	outsl  %ds:(%esi),(%dx)
    7eb9:	72 20                	jb     7edb <NO_BOOTABLE_MSG+0x4>
    7ebb:	77 68                	ja     7f25 <smap+0x17>
    7ebd:	65 6e                	outsb  %gs:(%esi),(%dx)
    7ebf:	20 64 65 74          	and    %ah,0x74(%ebp,%eiz,2)
    7ec3:	65 63 74 69 6e       	arpl   %si,%gs:0x6e(%ecx,%ebp,2)
    7ec8:	67 20 6d 65          	and    %ch,0x65(%di)
    7ecc:	6d                   	insl   (%dx),%es:(%edi)
    7ecd:	6f                   	outsl  %ds:(%esi),(%dx)
    7ece:	72 79                	jb     7f49 <smap+0x3b>
    7ed0:	20 6d 61             	and    %ch,0x61(%ebp)
    7ed3:	70 0d                	jo     7ee2 <NO_BOOTABLE_MSG+0xb>
    7ed5:	0a 00                	or     (%eax),%al

00007ed7 <NO_BOOTABLE_MSG>:
    7ed7:	4e                   	dec    %esi
    7ed8:	6f                   	outsl  %ds:(%esi),(%dx)
    7ed9:	20 62 6f             	and    %ah,0x6f(%edx)
    7edc:	6f                   	outsl  %ds:(%esi),(%dx)
    7edd:	74 61                	je     7f40 <smap+0x32>
    7edf:	62 6c 65 20          	bound  %ebp,0x20(%ebp,%eiz,2)
    7ee3:	70 61                	jo     7f46 <smap+0x38>
    7ee5:	72 74                	jb     7f5b <smap+0x4d>
    7ee7:	69 74 69 6f 6e 2e 0d 	imul   $0xa0d2e6e,0x6f(%ecx,%ebp,2),%esi
    7eee:	0a 
    7eef:	00                 	add    %al,(%eax)

00007ef0 <gdt>:
    7ef0:	00 00                	add    %al,(%eax)
    7ef2:	00 00                	add    %al,(%eax)
    7ef4:	00 00                	add    %al,(%eax)
    7ef6:	00 00                	add    %al,(%eax)
    7ef8:	ff                   	(bad)  
    7ef9:	ff 00                	incl   (%eax)
    7efb:	00 00                	add    %al,(%eax)
    7efd:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7f04:	00 92 cf 00      	add    %dl,0x2700cf(%edx)

00007f08 <gdtdesc>:
    7f08:	27                   	daa    
    7f09:	00 f0                	add    %dh,%al
    7f0b:	7e 00                	jle    7f0d <gdtdesc+0x5>
    7f0d:	00                 	add    %al,(%eax)

00007f0e <smap>:
    7f0e:	00 00                	add    %al,(%eax)
    7f10:	00 00                	add    %al,(%eax)
    7f12:	00 00                	add    %al,(%eax)
    7f14:	00 00                	add    %al,(%eax)
    7f16:	00 00                	add    %al,(%eax)
    7f18:	00 00                	add    %al,(%eax)
    7f1a:	00 00                	add    %al,(%eax)
    7f1c:	00 00                	add    %al,(%eax)
    7f1e:	00 00                	add    %al,(%eax)
    7f20:	00 00                	add    %al,(%eax)
    7f22:	00 00                	add    %al,(%eax)
    7f24:	00 00                	add    %al,(%eax)
    7f26:	00 00                	add    %al,(%eax)
    7f28:	00 00                	add    %al,(%eax)
    7f2a:	00 00                	add    %al,(%eax)
    7f2c:	00 00                	add    %al,(%eax)
    7f2e:	00 00                	add    %al,(%eax)
    7f30:	00 00                	add    %al,(%eax)
    7f32:	00 00                	add    %al,(%eax)
    7f34:	00 00                	add    %al,(%eax)
    7f36:	00 00                	add    %al,(%eax)
    7f38:	00 00                	add    %al,(%eax)
    7f3a:	00 00                	add    %al,(%eax)
    7f3c:	00 00                	add    %al,(%eax)
    7f3e:	00 00                	add    %al,(%eax)
    7f40:	00 00                	add    %al,(%eax)
    7f42:	00 00                	add    %al,(%eax)
    7f44:	00 00                	add    %al,(%eax)
    7f46:	00 00                	add    %al,(%eax)
    7f48:	00 00                	add    %al,(%eax)
    7f4a:	00 00                	add    %al,(%eax)
    7f4c:	00 00                	add    %al,(%eax)
    7f4e:	00 00                	add    %al,(%eax)
    7f50:	00 00                	add    %al,(%eax)
    7f52:	00 00                	add    %al,(%eax)
    7f54:	00 00                	add    %al,(%eax)
    7f56:	00 00                	add    %al,(%eax)
    7f58:	00 00                	add    %al,(%eax)
    7f5a:	00 00                	add    %al,(%eax)
    7f5c:	00 00                	add    %al,(%eax)
    7f5e:	00 00                	add    %al,(%eax)
    7f60:	00 00                	add    %al,(%eax)
    7f62:	00 00                	add    %al,(%eax)
    7f64:	00 00                	add    %al,(%eax)
    7f66:	00 00                	add    %al,(%eax)
    7f68:	00 00                	add    %al,(%eax)
    7f6a:	00 00                	add    %al,(%eax)
    7f6c:	00 00                	add    %al,(%eax)
    7f6e:	00 00                	add    %al,(%eax)
    7f70:	00 00                	add    %al,(%eax)
    7f72:	00 00                	add    %al,(%eax)
    7f74:	00 00                	add    %al,(%eax)
    7f76:	00 00                	add    %al,(%eax)
    7f78:	00 00                	add    %al,(%eax)
    7f7a:	00 00                	add    %al,(%eax)
    7f7c:	00 00                	add    %al,(%eax)
    7f7e:	00 00                	add    %al,(%eax)
    7f80:	00 00                	add    %al,(%eax)
    7f82:	00 00                	add    %al,(%eax)
    7f84:	00 00                	add    %al,(%eax)
    7f86:	00 00                	add    %al,(%eax)
    7f88:	00 00                	add    %al,(%eax)
    7f8a:	00 00                	add    %al,(%eax)
    7f8c:	00 00                	add    %al,(%eax)
    7f8e:	00 00                	add    %al,(%eax)
    7f90:	00 00                	add    %al,(%eax)
    7f92:	00 00                	add    %al,(%eax)
    7f94:	00 00                	add    %al,(%eax)
    7f96:	00 00                	add    %al,(%eax)
    7f98:	00 00                	add    %al,(%eax)
    7f9a:	00 00                	add    %al,(%eax)
    7f9c:	00 00                	add    %al,(%eax)
    7f9e:	00 00                	add    %al,(%eax)
    7fa0:	00 00                	add    %al,(%eax)
    7fa2:	00 00                	add    %al,(%eax)
    7fa4:	00 00                	add    %al,(%eax)
    7fa6:	00 00                	add    %al,(%eax)
    7fa8:	00 00                	add    %al,(%eax)
    7faa:	00 00                	add    %al,(%eax)
    7fac:	00 00                	add    %al,(%eax)
    7fae:	00 00                	add    %al,(%eax)
    7fb0:	00 00                	add    %al,(%eax)
    7fb2:	00 00                	add    %al,(%eax)
    7fb4:	00 00                	add    %al,(%eax)
    7fb6:	00 00                	add    %al,(%eax)
    7fb8:	00 00                	add    %al,(%eax)
    7fba:	00 00                	add    %al,(%eax)
    7fbc:	00 00                	add    %al,(%eax)
    7fbe:	00 00                	add    %al,(%eax)
    7fc0:	00 00                	add    %al,(%eax)
    7fc2:	00 00                	add    %al,(%eax)
    7fc4:	00 00                	add    %al,(%eax)
    7fc6:	00 00                	add    %al,(%eax)
    7fc8:	00 00                	add    %al,(%eax)
    7fca:	00 00                	add    %al,(%eax)
    7fcc:	00 00                	add    %al,(%eax)
    7fce:	00 00                	add    %al,(%eax)
    7fd0:	00 00                	add    %al,(%eax)
    7fd2:	00 00                	add    %al,(%eax)
    7fd4:	00 00                	add    %al,(%eax)
    7fd6:	00 00                	add    %al,(%eax)
    7fd8:	00 00                	add    %al,(%eax)
    7fda:	00 00                	add    %al,(%eax)
    7fdc:	00 00                	add    %al,(%eax)
    7fde:	00 00                	add    %al,(%eax)
    7fe0:	00 00                	add    %al,(%eax)
    7fe2:	00 00                	add    %al,(%eax)
    7fe4:	00 00                	add    %al,(%eax)
    7fe6:	00 00                	add    %al,(%eax)
    7fe8:	00 00                	add    %al,(%eax)
    7fea:	00 00                	add    %al,(%eax)
    7fec:	00 00                	add    %al,(%eax)
    7fee:	00 00                	add    %al,(%eax)
    7ff0:	00 00                	add    %al,(%eax)
    7ff2:	00 00                	add    %al,(%eax)
    7ff4:	00 00                	add    %al,(%eax)
    7ff6:	00 00                	add    %al,(%eax)
    7ff8:	00 00                	add    %al,(%eax)
    7ffa:	00 00                	add    %al,(%eax)
    7ffc:	00 00                	add    %al,(%eax)
    7ffe:	00 00                	add    %al,(%eax)
    8000:	00 00                	add    %al,(%eax)
    8002:	00 00                	add    %al,(%eax)
    8004:	00 00                	add    %al,(%eax)
    8006:	00 00                	add    %al,(%eax)
    8008:	00 00                	add    %al,(%eax)
    800a:	00 00                	add    %al,(%eax)
    800c:	00 00                	add    %al,(%eax)
    800e:	00 00                	add    %al,(%eax)
    8010:	00 00                	add    %al,(%eax)
    8012:	00 00                	add    %al,(%eax)
    8014:	00 00                	add    %al,(%eax)
    8016:	00 00                	add    %al,(%eax)
    8018:	00 00                	add    %al,(%eax)
    801a:	00 00                	add    %al,(%eax)
    801c:	00 00                	add    %al,(%eax)
    801e:	00 00                	add    %al,(%eax)
    8020:	00 00                	add    %al,(%eax)
    8022:	00 00                	add    %al,(%eax)
    8024:	00 00                	add    %al,(%eax)
    8026:	00 00                	add    %al,(%eax)
    8028:	00 00                	add    %al,(%eax)
    802a:	00 00                	add    %al,(%eax)
    802c:	00 00                	add    %al,(%eax)
    802e:	00 00                	add    %al,(%eax)
    8030:	00 00                	add    %al,(%eax)
    8032:	00 00                	add    %al,(%eax)
    8034:	00 00                	add    %al,(%eax)
    8036:	00 00                	add    %al,(%eax)
    8038:	00 00                	add    %al,(%eax)
    803a:	00 00                	add    %al,(%eax)
    803c:	00 00                	add    %al,(%eax)
    803e:	00 00                	add    %al,(%eax)
    8040:	00 00                	add    %al,(%eax)
    8042:	00 00                	add    %al,(%eax)
    8044:	00 00                	add    %al,(%eax)
    8046:	00 00                	add    %al,(%eax)
    8048:	00 00                	add    %al,(%eax)
    804a:	00 00                	add    %al,(%eax)
    804c:	00 00                	add    %al,(%eax)
    804e:	00 00                	add    %al,(%eax)
    8050:	00 00                	add    %al,(%eax)
    8052:	00 00                	add    %al,(%eax)
    8054:	00 00                	add    %al,(%eax)
    8056:	00 00                	add    %al,(%eax)
    8058:	00 00                	add    %al,(%eax)
    805a:	00 00                	add    %al,(%eax)
    805c:	00 00                	add    %al,(%eax)
    805e:	00 00                	add    %al,(%eax)
    8060:	00 00                	add    %al,(%eax)
    8062:	00 00                	add    %al,(%eax)
    8064:	00 00                	add    %al,(%eax)
    8066:	00 00                	add    %al,(%eax)
    8068:	00 00                	add    %al,(%eax)
    806a:	00 00                	add    %al,(%eax)
    806c:	00 00                	add    %al,(%eax)
    806e:	00 00                	add    %al,(%eax)
    8070:	00 00                	add    %al,(%eax)
    8072:	00 00                	add    %al,(%eax)
    8074:	00 00                	add    %al,(%eax)
    8076:	00 00                	add    %al,(%eax)
    8078:	00 00                	add    %al,(%eax)
    807a:	00 00                	add    %al,(%eax)
    807c:	00 00                	add    %al,(%eax)
    807e:	00 00                	add    %al,(%eax)
    8080:	00 00                	add    %al,(%eax)
    8082:	00 00                	add    %al,(%eax)
    8084:	00 00                	add    %al,(%eax)
    8086:	00 00                	add    %al,(%eax)
    8088:	00 00                	add    %al,(%eax)
    808a:	00 00                	add    %al,(%eax)
    808c:	00 00                	add    %al,(%eax)
    808e:	00 00                	add    %al,(%eax)
    8090:	00 00                	add    %al,(%eax)
    8092:	00 00                	add    %al,(%eax)
    8094:	00 00                	add    %al,(%eax)
    8096:	00 00                	add    %al,(%eax)
    8098:	00 00                	add    %al,(%eax)
    809a:	00 00                	add    %al,(%eax)
    809c:	00 00                	add    %al,(%eax)
    809e:	00 00                	add    %al,(%eax)
    80a0:	00 00                	add    %al,(%eax)
    80a2:	00 00                	add    %al,(%eax)
    80a4:	00 00                	add    %al,(%eax)
    80a6:	00 00                	add    %al,(%eax)
    80a8:	00 00                	add    %al,(%eax)
    80aa:	00 00                	add    %al,(%eax)
    80ac:	00 00                	add    %al,(%eax)
    80ae:	00 00                	add    %al,(%eax)
    80b0:	00 00                	add    %al,(%eax)
    80b2:	00 00                	add    %al,(%eax)
    80b4:	00 00                	add    %al,(%eax)
    80b6:	00 00                	add    %al,(%eax)
    80b8:	00 00                	add    %al,(%eax)
    80ba:	00 00                	add    %al,(%eax)
    80bc:	00 00                	add    %al,(%eax)
    80be:	00 00                	add    %al,(%eax)
    80c0:	00 00                	add    %al,(%eax)
    80c2:	00 00                	add    %al,(%eax)
    80c4:	00 00                	add    %al,(%eax)
    80c6:	00 00                	add    %al,(%eax)
    80c8:	00 00                	add    %al,(%eax)
    80ca:	00 00                	add    %al,(%eax)
    80cc:	00 00                	add    %al,(%eax)
    80ce:	00 00                	add    %al,(%eax)
    80d0:	00 00                	add    %al,(%eax)
    80d2:	00 00                	add    %al,(%eax)
    80d4:	00 00                	add    %al,(%eax)
    80d6:	00 00                	add    %al,(%eax)
    80d8:	00 00                	add    %al,(%eax)
    80da:	00 00                	add    %al,(%eax)
    80dc:	00 00                	add    %al,(%eax)
    80de:	00 00                	add    %al,(%eax)
    80e0:	00 00                	add    %al,(%eax)
    80e2:	00 00                	add    %al,(%eax)
    80e4:	00 00                	add    %al,(%eax)
    80e6:	00 00                	add    %al,(%eax)
    80e8:	00 00                	add    %al,(%eax)
    80ea:	00 00                	add    %al,(%eax)
    80ec:	00 00                	add    %al,(%eax)
    80ee:	00 00                	add    %al,(%eax)
    80f0:	00 00                	add    %al,(%eax)
    80f2:	00 00                	add    %al,(%eax)
    80f4:	00 00                	add    %al,(%eax)
    80f6:	00 00                	add    %al,(%eax)
    80f8:	00 00                	add    %al,(%eax)
    80fa:	00 00                	add    %al,(%eax)
    80fc:	00 00                	add    %al,(%eax)
    80fe:	00 00                	add    %al,(%eax)
    8100:	00 00                	add    %al,(%eax)
    8102:	00 00                	add    %al,(%eax)
    8104:	00 00                	add    %al,(%eax)
    8106:	00 00                	add    %al,(%eax)
    8108:	00 00                	add    %al,(%eax)
    810a:	00 00                	add    %al,(%eax)
    810c:	00 00                	add    %al,(%eax)
    810e:	00 00                	add    %al,(%eax)
    8110:	00 00                	add    %al,(%eax)
    8112:	00 00                	add    %al,(%eax)
    8114:	00 00                	add    %al,(%eax)
    8116:	00 00                	add    %al,(%eax)
    8118:	00 00                	add    %al,(%eax)
    811a:	00 00                	add    %al,(%eax)
    811c:	00 00                	add    %al,(%eax)
    811e:	00 00                	add    %al,(%eax)
    8120:	00 00                	add    %al,(%eax)
    8122:	00 00                	add    %al,(%eax)
    8124:	00 00                	add    %al,(%eax)
    8126:	00 00                	add    %al,(%eax)
    8128:	00 00                	add    %al,(%eax)
    812a:	00 00                	add    %al,(%eax)
    812c:	00 00                	add    %al,(%eax)
    812e:	00 00                	add    %al,(%eax)
    8130:	00 00                	add    %al,(%eax)
    8132:	00 00                	add    %al,(%eax)
    8134:	00 00                	add    %al,(%eax)
    8136:	00 00                	add    %al,(%eax)
    8138:	00 00                	add    %al,(%eax)
    813a:	00 00                	add    %al,(%eax)
    813c:	00 00                	add    %al,(%eax)
    813e:	00 00                	add    %al,(%eax)
    8140:	00 00                	add    %al,(%eax)
    8142:	00 00                	add    %al,(%eax)
    8144:	00 00                	add    %al,(%eax)
    8146:	00 00                	add    %al,(%eax)
    8148:	00 00                	add    %al,(%eax)
    814a:	00 00                	add    %al,(%eax)
    814c:	00 00                	add    %al,(%eax)
    814e:	00 00                	add    %al,(%eax)
    8150:	00 00                	add    %al,(%eax)
    8152:	00 00                	add    %al,(%eax)
    8154:	00 00                	add    %al,(%eax)
    8156:	00 00                	add    %al,(%eax)
    8158:	00 00                	add    %al,(%eax)
    815a:	00 00                	add    %al,(%eax)
    815c:	00 00                	add    %al,(%eax)
    815e:	00 00                	add    %al,(%eax)
    8160:	00 00                	add    %al,(%eax)
    8162:	00 00                	add    %al,(%eax)
    8164:	00 00                	add    %al,(%eax)
    8166:	00 00                	add    %al,(%eax)
    8168:	00 00                	add    %al,(%eax)
    816a:	00 00                	add    %al,(%eax)
    816c:	00 00                	add    %al,(%eax)
    816e:	00 00                	add    %al,(%eax)
    8170:	00 00                	add    %al,(%eax)
    8172:	00 00                	add    %al,(%eax)
    8174:	00 00                	add    %al,(%eax)
    8176:	00 00                	add    %al,(%eax)
    8178:	00 00                	add    %al,(%eax)
    817a:	00 00                	add    %al,(%eax)
    817c:	00 00                	add    %al,(%eax)
    817e:	00 00                	add    %al,(%eax)
    8180:	00 00                	add    %al,(%eax)
    8182:	00 00                	add    %al,(%eax)
    8184:	00 00                	add    %al,(%eax)
    8186:	00 00                	add    %al,(%eax)
    8188:	00 00                	add    %al,(%eax)
    818a:	00 00                	add    %al,(%eax)
    818c:	00 00                	add    %al,(%eax)
    818e:	00 00                	add    %al,(%eax)
    8190:	00 00                	add    %al,(%eax)
    8192:	00 00                	add    %al,(%eax)
    8194:	00 00                	add    %al,(%eax)
    8196:	00 00                	add    %al,(%eax)
    8198:	00 00                	add    %al,(%eax)
    819a:	00 00                	add    %al,(%eax)
    819c:	00 00                	add    %al,(%eax)
    819e:	00 00                	add    %al,(%eax)
    81a0:	00 00                	add    %al,(%eax)
    81a2:	00 00                	add    %al,(%eax)
    81a4:	00 00                	add    %al,(%eax)
    81a6:	00 00                	add    %al,(%eax)
    81a8:	00 00                	add    %al,(%eax)
    81aa:	00 00                	add    %al,(%eax)
    81ac:	00 00                	add    %al,(%eax)
    81ae:	00 00                	add    %al,(%eax)
    81b0:	00 00                	add    %al,(%eax)
    81b2:	00 00                	add    %al,(%eax)
    81b4:	00 00                	add    %al,(%eax)
    81b6:	00 00                	add    %al,(%eax)
    81b8:	00 00                	add    %al,(%eax)
    81ba:	00 00                	add    %al,(%eax)
    81bc:	00 00                	add    %al,(%eax)
    81be:	00 00                	add    %al,(%eax)
    81c0:	00 00                	add    %al,(%eax)
    81c2:	00 00                	add    %al,(%eax)
    81c4:	00 00                	add    %al,(%eax)
    81c6:	00 00                	add    %al,(%eax)
    81c8:	00 00                	add    %al,(%eax)
    81ca:	00 00                	add    %al,(%eax)
    81cc:	00 00                	add    %al,(%eax)
    81ce:	00 00                	add    %al,(%eax)
    81d0:	00 00                	add    %al,(%eax)
    81d2:	00 00                	add    %al,(%eax)
    81d4:	00 00                	add    %al,(%eax)
    81d6:	00 00                	add    %al,(%eax)
    81d8:	00 00                	add    %al,(%eax)
    81da:	00 00                	add    %al,(%eax)
    81dc:	00 00                	add    %al,(%eax)
    81de:	00 00                	add    %al,(%eax)
    81e0:	00 00                	add    %al,(%eax)
    81e2:	00 00                	add    %al,(%eax)
    81e4:	00 00                	add    %al,(%eax)
    81e6:	00 00                	add    %al,(%eax)
    81e8:	00 00                	add    %al,(%eax)
    81ea:	00 00                	add    %al,(%eax)
    81ec:	00 00                	add    %al,(%eax)
    81ee:	00 00                	add    %al,(%eax)
    81f0:	00 00                	add    %al,(%eax)
    81f2:	00 00                	add    %al,(%eax)
    81f4:	00 00                	add    %al,(%eax)
    81f6:	00 00                	add    %al,(%eax)
    81f8:	00 00                	add    %al,(%eax)
    81fa:	00 00                	add    %al,(%eax)
    81fc:	00 00                	add    %al,(%eax)
    81fe:	00 00                	add    %al,(%eax)
    8200:	00 00                	add    %al,(%eax)
    8202:	00 00                	add    %al,(%eax)
    8204:	00 00                	add    %al,(%eax)
    8206:	00 00                	add    %al,(%eax)
    8208:	00 00                	add    %al,(%eax)
    820a:	00 00                	add    %al,(%eax)
    820c:	00 00                	add    %al,(%eax)
    820e:	00 00                	add    %al,(%eax)
    8210:	00 00                	add    %al,(%eax)
    8212:	00 00                	add    %al,(%eax)
    8214:	00 00                	add    %al,(%eax)
    8216:	00 00                	add    %al,(%eax)
    8218:	00 00                	add    %al,(%eax)
    821a:	00 00                	add    %al,(%eax)
    821c:	00 00                	add    %al,(%eax)
    821e:	00 00                	add    %al,(%eax)
    8220:	00 00                	add    %al,(%eax)
    8222:	00 00                	add    %al,(%eax)
    8224:	00 00                	add    %al,(%eax)
    8226:	00 00                	add    %al,(%eax)
    8228:	00 00                	add    %al,(%eax)
    822a:	00 00                	add    %al,(%eax)
    822c:	00 00                	add    %al,(%eax)
    822e:	00 00                	add    %al,(%eax)
    8230:	00 00                	add    %al,(%eax)
    8232:	00 00                	add    %al,(%eax)
    8234:	00 00                	add    %al,(%eax)
    8236:	00 00                	add    %al,(%eax)
    8238:	00 00                	add    %al,(%eax)
    823a:	00 00                	add    %al,(%eax)
    823c:	00 00                	add    %al,(%eax)
    823e:	00 00                	add    %al,(%eax)
    8240:	00 00                	add    %al,(%eax)
    8242:	00 00                	add    %al,(%eax)
    8244:	00 00                	add    %al,(%eax)
    8246:	00 00                	add    %al,(%eax)
    8248:	00 00                	add    %al,(%eax)
    824a:	00 00                	add    %al,(%eax)
    824c:	00 00                	add    %al,(%eax)
    824e:	00 00                	add    %al,(%eax)
    8250:	00 00                	add    %al,(%eax)
    8252:	00 00                	add    %al,(%eax)
    8254:	00 00                	add    %al,(%eax)
    8256:	00 00                	add    %al,(%eax)
    8258:	00 00                	add    %al,(%eax)
    825a:	00 00                	add    %al,(%eax)
    825c:	00 00                	add    %al,(%eax)
    825e:	00 00                	add    %al,(%eax)
    8260:	00 00                	add    %al,(%eax)
    8262:	00 00                	add    %al,(%eax)
    8264:	00 00                	add    %al,(%eax)
    8266:	00 00                	add    %al,(%eax)
    8268:	00 00                	add    %al,(%eax)
    826a:	00 00                	add    %al,(%eax)
    826c:	00 00                	add    %al,(%eax)
    826e:	00 00                	add    %al,(%eax)
    8270:	00 00                	add    %al,(%eax)
    8272:	00 00                	add    %al,(%eax)
    8274:	00 00                	add    %al,(%eax)
    8276:	00 00                	add    %al,(%eax)
    8278:	00 00                	add    %al,(%eax)
    827a:	00 00                	add    %al,(%eax)
    827c:	00 00                	add    %al,(%eax)
    827e:	00 00                	add    %al,(%eax)
    8280:	00 00                	add    %al,(%eax)
    8282:	00 00                	add    %al,(%eax)
    8284:	00 00                	add    %al,(%eax)
    8286:	00 00                	add    %al,(%eax)
    8288:	00 00                	add    %al,(%eax)
    828a:	00 00                	add    %al,(%eax)
    828c:	00 00                	add    %al,(%eax)
    828e:	00 00                	add    %al,(%eax)
    8290:	00 00                	add    %al,(%eax)
    8292:	00 00                	add    %al,(%eax)
    8294:	00 00                	add    %al,(%eax)
    8296:	00 00                	add    %al,(%eax)
    8298:	00 00                	add    %al,(%eax)
    829a:	00 00                	add    %al,(%eax)
    829c:	00 00                	add    %al,(%eax)
    829e:	00 00                	add    %al,(%eax)
    82a0:	00 00                	add    %al,(%eax)
    82a2:	00 00                	add    %al,(%eax)
    82a4:	00 00                	add    %al,(%eax)
    82a6:	00 00                	add    %al,(%eax)
    82a8:	00 00                	add    %al,(%eax)
    82aa:	00 00                	add    %al,(%eax)
    82ac:	00 00                	add    %al,(%eax)
    82ae:	00 00                	add    %al,(%eax)
    82b0:	00 00                	add    %al,(%eax)
    82b2:	00 00                	add    %al,(%eax)
    82b4:	00 00                	add    %al,(%eax)
    82b6:	00 00                	add    %al,(%eax)
    82b8:	00 00                	add    %al,(%eax)
    82ba:	00 00                	add    %al,(%eax)
    82bc:	00 00                	add    %al,(%eax)
    82be:	00 00                	add    %al,(%eax)
    82c0:	00 00                	add    %al,(%eax)
    82c2:	00 00                	add    %al,(%eax)
    82c4:	00 00                	add    %al,(%eax)
    82c6:	00 00                	add    %al,(%eax)
    82c8:	00 00                	add    %al,(%eax)
    82ca:	00 00                	add    %al,(%eax)
    82cc:	00 00                	add    %al,(%eax)
    82ce:	00 00                	add    %al,(%eax)
    82d0:	00 00                	add    %al,(%eax)
    82d2:	00 00                	add    %al,(%eax)
    82d4:	00 00                	add    %al,(%eax)
    82d6:	00 00                	add    %al,(%eax)
    82d8:	00 00                	add    %al,(%eax)
    82da:	00 00                	add    %al,(%eax)
    82dc:	00 00                	add    %al,(%eax)
    82de:	00 00                	add    %al,(%eax)
    82e0:	00 00                	add    %al,(%eax)
    82e2:	00 00                	add    %al,(%eax)
    82e4:	00 00                	add    %al,(%eax)
    82e6:	00 00                	add    %al,(%eax)
    82e8:	00 00                	add    %al,(%eax)
    82ea:	00 00                	add    %al,(%eax)
    82ec:	00 00                	add    %al,(%eax)
    82ee:	00 00                	add    %al,(%eax)
    82f0:	00 00                	add    %al,(%eax)
    82f2:	00 00                	add    %al,(%eax)
    82f4:	00 00                	add    %al,(%eax)
    82f6:	00 00                	add    %al,(%eax)
    82f8:	00 00                	add    %al,(%eax)
    82fa:	00 00                	add    %al,(%eax)
    82fc:	00 00                	add    %al,(%eax)
    82fe:	00 00                	add    %al,(%eax)
    8300:	00 00                	add    %al,(%eax)
    8302:	00 00                	add    %al,(%eax)
    8304:	00 00                	add    %al,(%eax)
    8306:	00 00                	add    %al,(%eax)
    8308:	00 00                	add    %al,(%eax)
    830a:	00 00                	add    %al,(%eax)
    830c:	00 00                	add    %al,(%eax)
    830e:	00 00                	add    %al,(%eax)
    8310:	00 00                	add    %al,(%eax)
    8312:	00 00                	add    %al,(%eax)
    8314:	00 00                	add    %al,(%eax)
    8316:	00 00                	add    %al,(%eax)
    8318:	00 00                	add    %al,(%eax)
    831a:	00 00                	add    %al,(%eax)
    831c:	00 00                	add    %al,(%eax)
    831e:	00 00                	add    %al,(%eax)
    8320:	00 00                	add    %al,(%eax)
    8322:	00 00                	add    %al,(%eax)
    8324:	00 00                	add    %al,(%eax)
    8326:	00 00                	add    %al,(%eax)
    8328:	00 00                	add    %al,(%eax)
    832a:	00 00                	add    %al,(%eax)
    832c:	00 00                	add    %al,(%eax)
    832e:	00 00                	add    %al,(%eax)
    8330:	00 00                	add    %al,(%eax)
    8332:	00 00                	add    %al,(%eax)
    8334:	00 00                	add    %al,(%eax)
    8336:	00 00                	add    %al,(%eax)
    8338:	00 00                	add    %al,(%eax)
    833a:	00 00                	add    %al,(%eax)
    833c:	00 00                	add    %al,(%eax)
    833e:	00 00                	add    %al,(%eax)
    8340:	00 00                	add    %al,(%eax)
    8342:	00 00                	add    %al,(%eax)
    8344:	00 00                	add    %al,(%eax)
    8346:	00 00                	add    %al,(%eax)
    8348:	00 00                	add    %al,(%eax)
    834a:	00 00                	add    %al,(%eax)
    834c:	00 00                	add    %al,(%eax)
    834e:	00 00                	add    %al,(%eax)
    8350:	00 00                	add    %al,(%eax)
    8352:	00 00                	add    %al,(%eax)
    8354:	00 00                	add    %al,(%eax)
    8356:	00 00                	add    %al,(%eax)
    8358:	00 00                	add    %al,(%eax)
    835a:	00 00                	add    %al,(%eax)
    835c:	00 00                	add    %al,(%eax)
    835e:	00 00                	add    %al,(%eax)
    8360:	00 00                	add    %al,(%eax)
    8362:	00 00                	add    %al,(%eax)
    8364:	00 00                	add    %al,(%eax)
    8366:	00 00                	add    %al,(%eax)
    8368:	00 00                	add    %al,(%eax)
    836a:	00 00                	add    %al,(%eax)
    836c:	00 00                	add    %al,(%eax)
    836e:	00 00                	add    %al,(%eax)
    8370:	00 00                	add    %al,(%eax)
    8372:	00 00                	add    %al,(%eax)
    8374:	00 00                	add    %al,(%eax)
    8376:	00 00                	add    %al,(%eax)
    8378:	00 00                	add    %al,(%eax)
    837a:	00 00                	add    %al,(%eax)
    837c:	00 00                	add    %al,(%eax)
    837e:	00 00                	add    %al,(%eax)
    8380:	00 00                	add    %al,(%eax)
    8382:	00 00                	add    %al,(%eax)
    8384:	00 00                	add    %al,(%eax)
    8386:	00 00                	add    %al,(%eax)
    8388:	00 00                	add    %al,(%eax)
    838a:	00 00                	add    %al,(%eax)
    838c:	00 00                	add    %al,(%eax)
    838e:	00 00                	add    %al,(%eax)
    8390:	00 00                	add    %al,(%eax)
    8392:	00 00                	add    %al,(%eax)
    8394:	00 00                	add    %al,(%eax)
    8396:	00 00                	add    %al,(%eax)
    8398:	00 00                	add    %al,(%eax)
    839a:	00 00                	add    %al,(%eax)
    839c:	00 00                	add    %al,(%eax)
    839e:	00 00                	add    %al,(%eax)
    83a0:	00 00                	add    %al,(%eax)
    83a2:	00 00                	add    %al,(%eax)
    83a4:	00 00                	add    %al,(%eax)
    83a6:	00 00                	add    %al,(%eax)
    83a8:	00 00                	add    %al,(%eax)
    83aa:	00 00                	add    %al,(%eax)
    83ac:	00 00                	add    %al,(%eax)
    83ae:	00 00                	add    %al,(%eax)
    83b0:	00 00                	add    %al,(%eax)
    83b2:	00 00                	add    %al,(%eax)
    83b4:	00 00                	add    %al,(%eax)
    83b6:	00 00                	add    %al,(%eax)
    83b8:	00 00                	add    %al,(%eax)
    83ba:	00 00                	add    %al,(%eax)
    83bc:	00 00                	add    %al,(%eax)
    83be:	00 00                	add    %al,(%eax)
    83c0:	00 00                	add    %al,(%eax)
    83c2:	00 00                	add    %al,(%eax)
    83c4:	00 00                	add    %al,(%eax)
    83c6:	00 00                	add    %al,(%eax)
    83c8:	00 00                	add    %al,(%eax)
    83ca:	00 00                	add    %al,(%eax)
    83cc:	00 00                	add    %al,(%eax)
    83ce:	00 00                	add    %al,(%eax)
    83d0:	00 00                	add    %al,(%eax)
    83d2:	00 00                	add    %al,(%eax)
    83d4:	00 00                	add    %al,(%eax)
    83d6:	00 00                	add    %al,(%eax)
    83d8:	00 00                	add    %al,(%eax)
    83da:	00 00                	add    %al,(%eax)
    83dc:	00 00                	add    %al,(%eax)
    83de:	00 00                	add    %al,(%eax)
    83e0:	00 00                	add    %al,(%eax)
    83e2:	00 00                	add    %al,(%eax)
    83e4:	00 00                	add    %al,(%eax)
    83e6:	00 00                	add    %al,(%eax)
    83e8:	00 00                	add    %al,(%eax)
    83ea:	00 00                	add    %al,(%eax)
    83ec:	00 00                	add    %al,(%eax)
    83ee:	00 00                	add    %al,(%eax)
    83f0:	00 00                	add    %al,(%eax)
    83f2:	00 00                	add    %al,(%eax)
    83f4:	00 00                	add    %al,(%eax)
    83f6:	00 00                	add    %al,(%eax)
    83f8:	00 00                	add    %al,(%eax)
    83fa:	00 00                	add    %al,(%eax)
    83fc:	00 00                	add    %al,(%eax)
    83fe:	00 00                	add    %al,(%eax)
    8400:	00 00                	add    %al,(%eax)
    8402:	00 00                	add    %al,(%eax)
    8404:	00 00                	add    %al,(%eax)
    8406:	00 00                	add    %al,(%eax)
    8408:	00 00                	add    %al,(%eax)
    840a:	00 00                	add    %al,(%eax)
    840c:	00 00                	add    %al,(%eax)
    840e:	00 00                	add    %al,(%eax)
    8410:	00 00                	add    %al,(%eax)
    8412:	00 00                	add    %al,(%eax)
    8414:	00 00                	add    %al,(%eax)
    8416:	00 00                	add    %al,(%eax)
    8418:	00 00                	add    %al,(%eax)
    841a:	00 00                	add    %al,(%eax)
    841c:	00 00                	add    %al,(%eax)
    841e:	00 00                	add    %al,(%eax)
    8420:	00 00                	add    %al,(%eax)
    8422:	00 00                	add    %al,(%eax)
    8424:	00 00                	add    %al,(%eax)
    8426:	00 00                	add    %al,(%eax)
    8428:	00 00                	add    %al,(%eax)
    842a:	00 00                	add    %al,(%eax)
    842c:	00 00                	add    %al,(%eax)
    842e:	00 00                	add    %al,(%eax)
    8430:	00 00                	add    %al,(%eax)
    8432:	00 00                	add    %al,(%eax)
    8434:	00 00                	add    %al,(%eax)
    8436:	00 00                	add    %al,(%eax)
    8438:	00 00                	add    %al,(%eax)
    843a:	00 00                	add    %al,(%eax)
    843c:	00 00                	add    %al,(%eax)
    843e:	00 00                	add    %al,(%eax)
    8440:	00 00                	add    %al,(%eax)
    8442:	00 00                	add    %al,(%eax)
    8444:	00 00                	add    %al,(%eax)
    8446:	00 00                	add    %al,(%eax)
    8448:	00 00                	add    %al,(%eax)
    844a:	00 00                	add    %al,(%eax)
    844c:	00 00                	add    %al,(%eax)
    844e:	00 00                	add    %al,(%eax)
    8450:	00 00                	add    %al,(%eax)
    8452:	00 00                	add    %al,(%eax)
    8454:	00 00                	add    %al,(%eax)
    8456:	00 00                	add    %al,(%eax)
    8458:	00 00                	add    %al,(%eax)
    845a:	00 00                	add    %al,(%eax)
    845c:	00 00                	add    %al,(%eax)
    845e:	00 00                	add    %al,(%eax)
    8460:	00 00                	add    %al,(%eax)
    8462:	00 00                	add    %al,(%eax)
    8464:	00 00                	add    %al,(%eax)
    8466:	00 00                	add    %al,(%eax)
    8468:	00 00                	add    %al,(%eax)
    846a:	00 00                	add    %al,(%eax)
    846c:	00 00                	add    %al,(%eax)
    846e:	00 00                	add    %al,(%eax)
    8470:	00 00                	add    %al,(%eax)
    8472:	00 00                	add    %al,(%eax)
    8474:	00 00                	add    %al,(%eax)
    8476:	00 00                	add    %al,(%eax)
    8478:	00 00                	add    %al,(%eax)
    847a:	00 00                	add    %al,(%eax)
    847c:	00 00                	add    %al,(%eax)
    847e:	00 00                	add    %al,(%eax)
    8480:	00 00                	add    %al,(%eax)
    8482:	00 00                	add    %al,(%eax)
    8484:	00 00                	add    %al,(%eax)
    8486:	00 00                	add    %al,(%eax)
    8488:	00 00                	add    %al,(%eax)
    848a:	00 00                	add    %al,(%eax)
    848c:	00 00                	add    %al,(%eax)
    848e:	00 00                	add    %al,(%eax)
    8490:	00 00                	add    %al,(%eax)
    8492:	00 00                	add    %al,(%eax)
    8494:	00 00                	add    %al,(%eax)
    8496:	00 00                	add    %al,(%eax)
    8498:	00 00                	add    %al,(%eax)
    849a:	00 00                	add    %al,(%eax)
    849c:	00 00                	add    %al,(%eax)
    849e:	00 00                	add    %al,(%eax)
    84a0:	00 00                	add    %al,(%eax)
    84a2:	00 00                	add    %al,(%eax)
    84a4:	00 00                	add    %al,(%eax)
    84a6:	00 00                	add    %al,(%eax)
    84a8:	00 00                	add    %al,(%eax)
    84aa:	00 00                	add    %al,(%eax)
    84ac:	00 00                	add    %al,(%eax)
    84ae:	00 00                	add    %al,(%eax)
    84b0:	00 00                	add    %al,(%eax)
    84b2:	00 00                	add    %al,(%eax)
    84b4:	00 00                	add    %al,(%eax)
    84b6:	00 00                	add    %al,(%eax)
    84b8:	00 00                	add    %al,(%eax)
    84ba:	00 00                	add    %al,(%eax)
    84bc:	00 00                	add    %al,(%eax)
    84be:	00 00                	add    %al,(%eax)
    84c0:	00 00                	add    %al,(%eax)
    84c2:	00 00                	add    %al,(%eax)
    84c4:	00 00                	add    %al,(%eax)
    84c6:	00 00                	add    %al,(%eax)
    84c8:	00 00                	add    %al,(%eax)
    84ca:	00 00                	add    %al,(%eax)
    84cc:	00 00                	add    %al,(%eax)
    84ce:	00 00                	add    %al,(%eax)
    84d0:	00 00                	add    %al,(%eax)
    84d2:	00 00                	add    %al,(%eax)
    84d4:	00 00                	add    %al,(%eax)
    84d6:	00 00                	add    %al,(%eax)
    84d8:	00 00                	add    %al,(%eax)
    84da:	00 00                	add    %al,(%eax)
    84dc:	00 00                	add    %al,(%eax)
    84de:	00 00                	add    %al,(%eax)
    84e0:	00 00                	add    %al,(%eax)
    84e2:	00 00                	add    %al,(%eax)
    84e4:	00 00                	add    %al,(%eax)
    84e6:	00 00                	add    %al,(%eax)
    84e8:	00 00                	add    %al,(%eax)
    84ea:	00 00                	add    %al,(%eax)
    84ec:	00 00                	add    %al,(%eax)
    84ee:	00 00                	add    %al,(%eax)
    84f0:	00 00                	add    %al,(%eax)
    84f2:	00 00                	add    %al,(%eax)
    84f4:	00 00                	add    %al,(%eax)
    84f6:	00 00                	add    %al,(%eax)
    84f8:	00 00                	add    %al,(%eax)
    84fa:	00 00                	add    %al,(%eax)
    84fc:	00 00                	add    %al,(%eax)
    84fe:	00 00                	add    %al,(%eax)
    8500:	00 00                	add    %al,(%eax)
    8502:	00 00                	add    %al,(%eax)
    8504:	00 00                	add    %al,(%eax)
    8506:	00 00                	add    %al,(%eax)
    8508:	00 00                	add    %al,(%eax)
    850a:	00 00                	add    %al,(%eax)
    850c:	00 00                	add    %al,(%eax)
    850e:	00 00                	add    %al,(%eax)
    8510:	00 00                	add    %al,(%eax)
    8512:	00 00                	add    %al,(%eax)
    8514:	00 00                	add    %al,(%eax)
    8516:	00 00                	add    %al,(%eax)
    8518:	00 00                	add    %al,(%eax)
    851a:	00 00                	add    %al,(%eax)
    851c:	00 00                	add    %al,(%eax)
    851e:	00 00                	add    %al,(%eax)
    8520:	00 00                	add    %al,(%eax)
    8522:	00 00                	add    %al,(%eax)
    8524:	00 00                	add    %al,(%eax)
    8526:	00 00                	add    %al,(%eax)
    8528:	00 00                	add    %al,(%eax)
    852a:	00 00                	add    %al,(%eax)
    852c:	00 00                	add    %al,(%eax)
    852e:	00 00                	add    %al,(%eax)
    8530:	00 00                	add    %al,(%eax)
    8532:	00 00                	add    %al,(%eax)
    8534:	00 00                	add    %al,(%eax)
    8536:	00 00                	add    %al,(%eax)
    8538:	00 00                	add    %al,(%eax)
    853a:	00 00                	add    %al,(%eax)
    853c:	00 00                	add    %al,(%eax)
    853e:	00 00                	add    %al,(%eax)
    8540:	00 00                	add    %al,(%eax)
    8542:	00 00                	add    %al,(%eax)
    8544:	00 00                	add    %al,(%eax)
    8546:	00 00                	add    %al,(%eax)
    8548:	00 00                	add    %al,(%eax)
    854a:	00 00                	add    %al,(%eax)
    854c:	00 00                	add    %al,(%eax)
    854e:	00 00                	add    %al,(%eax)
    8550:	00 00                	add    %al,(%eax)
    8552:	00 00                	add    %al,(%eax)
    8554:	00 00                	add    %al,(%eax)
    8556:	00 00                	add    %al,(%eax)
    8558:	00 00                	add    %al,(%eax)
    855a:	00 00                	add    %al,(%eax)
    855c:	00 00                	add    %al,(%eax)
    855e:	00 00                	add    %al,(%eax)
    8560:	00 00                	add    %al,(%eax)
    8562:	00 00                	add    %al,(%eax)
    8564:	00 00                	add    %al,(%eax)
    8566:	00 00                	add    %al,(%eax)
    8568:	00 00                	add    %al,(%eax)
    856a:	00 00                	add    %al,(%eax)
    856c:	00 00                	add    %al,(%eax)
    856e:	00 00                	add    %al,(%eax)
    8570:	00 00                	add    %al,(%eax)
    8572:	00 00                	add    %al,(%eax)
    8574:	00 00                	add    %al,(%eax)
    8576:	00 00                	add    %al,(%eax)
    8578:	00 00                	add    %al,(%eax)
    857a:	00 00                	add    %al,(%eax)
    857c:	00 00                	add    %al,(%eax)
    857e:	00 00                	add    %al,(%eax)
    8580:	00 00                	add    %al,(%eax)
    8582:	00 00                	add    %al,(%eax)
    8584:	00 00                	add    %al,(%eax)
    8586:	00 00                	add    %al,(%eax)
    8588:	00 00                	add    %al,(%eax)
    858a:	00 00                	add    %al,(%eax)
    858c:	00 00                	add    %al,(%eax)
    858e:	00 00                	add    %al,(%eax)
    8590:	00 00                	add    %al,(%eax)
    8592:	00 00                	add    %al,(%eax)
    8594:	00 00                	add    %al,(%eax)
    8596:	00 00                	add    %al,(%eax)
    8598:	00 00                	add    %al,(%eax)
    859a:	00 00                	add    %al,(%eax)
    859c:	00 00                	add    %al,(%eax)
    859e:	00 00                	add    %al,(%eax)
    85a0:	00 00                	add    %al,(%eax)
    85a2:	00 00                	add    %al,(%eax)
    85a4:	00 00                	add    %al,(%eax)
    85a6:	00 00                	add    %al,(%eax)
    85a8:	00 00                	add    %al,(%eax)
    85aa:	00 00                	add    %al,(%eax)
    85ac:	00 00                	add    %al,(%eax)
    85ae:	00 00                	add    %al,(%eax)
    85b0:	00 00                	add    %al,(%eax)
    85b2:	00 00                	add    %al,(%eax)
    85b4:	00 00                	add    %al,(%eax)
    85b6:	00 00                	add    %al,(%eax)
    85b8:	00 00                	add    %al,(%eax)
    85ba:	00 00                	add    %al,(%eax)
    85bc:	00 00                	add    %al,(%eax)
    85be:	00 00                	add    %al,(%eax)
    85c0:	00 00                	add    %al,(%eax)
    85c2:	00 00                	add    %al,(%eax)
    85c4:	00 00                	add    %al,(%eax)
    85c6:	00 00                	add    %al,(%eax)
    85c8:	00 00                	add    %al,(%eax)
    85ca:	00 00                	add    %al,(%eax)
    85cc:	00 00                	add    %al,(%eax)
    85ce:	00 00                	add    %al,(%eax)
    85d0:	00 00                	add    %al,(%eax)
    85d2:	00 00                	add    %al,(%eax)
    85d4:	00 00                	add    %al,(%eax)
    85d6:	00 00                	add    %al,(%eax)
    85d8:	00 00                	add    %al,(%eax)
    85da:	00 00                	add    %al,(%eax)
    85dc:	00 00                	add    %al,(%eax)
    85de:	00 00                	add    %al,(%eax)
    85e0:	00 00                	add    %al,(%eax)
    85e2:	00 00                	add    %al,(%eax)
    85e4:	00 00                	add    %al,(%eax)
    85e6:	00 00                	add    %al,(%eax)
    85e8:	00 00                	add    %al,(%eax)
    85ea:	00 00                	add    %al,(%eax)
    85ec:	00 00                	add    %al,(%eax)
    85ee:	00 00                	add    %al,(%eax)
    85f0:	00 00                	add    %al,(%eax)
    85f2:	00 00                	add    %al,(%eax)
    85f4:	00 00                	add    %al,(%eax)
    85f6:	00 00                	add    %al,(%eax)
    85f8:	00 00                	add    %al,(%eax)
    85fa:	00 00                	add    %al,(%eax)
    85fc:	00 00                	add    %al,(%eax)
    85fe:	00 00                	add    %al,(%eax)
    8600:	00 00                	add    %al,(%eax)
    8602:	00 00                	add    %al,(%eax)
    8604:	00 00                	add    %al,(%eax)
    8606:	00 00                	add    %al,(%eax)
    8608:	00 00                	add    %al,(%eax)
    860a:	00 00                	add    %al,(%eax)
    860c:	00 00                	add    %al,(%eax)
    860e:	00 00                	add    %al,(%eax)
    8610:	00 00                	add    %al,(%eax)
    8612:	00 00                	add    %al,(%eax)
    8614:	00 00                	add    %al,(%eax)
    8616:	00 00                	add    %al,(%eax)
    8618:	00 00                	add    %al,(%eax)
    861a:	00 00                	add    %al,(%eax)
    861c:	00 00                	add    %al,(%eax)
    861e:	00 00                	add    %al,(%eax)
    8620:	00 00                	add    %al,(%eax)
    8622:	00 00                	add    %al,(%eax)
    8624:	00 00                	add    %al,(%eax)
    8626:	00 00                	add    %al,(%eax)
    8628:	00 00                	add    %al,(%eax)
    862a:	00 00                	add    %al,(%eax)
    862c:	00 00                	add    %al,(%eax)
    862e:	00 00                	add    %al,(%eax)
    8630:	00 00                	add    %al,(%eax)
    8632:	00 00                	add    %al,(%eax)
    8634:	00 00                	add    %al,(%eax)
    8636:	00 00                	add    %al,(%eax)
    8638:	00 00                	add    %al,(%eax)
    863a:	00 00                	add    %al,(%eax)
    863c:	00 00                	add    %al,(%eax)
    863e:	00 00                	add    %al,(%eax)
    8640:	00 00                	add    %al,(%eax)
    8642:	00 00                	add    %al,(%eax)
    8644:	00 00                	add    %al,(%eax)
    8646:	00 00                	add    %al,(%eax)
    8648:	00 00                	add    %al,(%eax)
    864a:	00 00                	add    %al,(%eax)
    864c:	00 00                	add    %al,(%eax)
    864e:	00 00                	add    %al,(%eax)
    8650:	00 00                	add    %al,(%eax)
    8652:	00 00                	add    %al,(%eax)
    8654:	00 00                	add    %al,(%eax)
    8656:	00 00                	add    %al,(%eax)
    8658:	00 00                	add    %al,(%eax)
    865a:	00 00                	add    %al,(%eax)
    865c:	00 00                	add    %al,(%eax)
    865e:	00 00                	add    %al,(%eax)
    8660:	00 00                	add    %al,(%eax)
    8662:	00 00                	add    %al,(%eax)
    8664:	00 00                	add    %al,(%eax)
    8666:	00 00                	add    %al,(%eax)
    8668:	00 00                	add    %al,(%eax)
    866a:	00 00                	add    %al,(%eax)
    866c:	00 00                	add    %al,(%eax)
    866e:	00 00                	add    %al,(%eax)
    8670:	00 00                	add    %al,(%eax)
    8672:	00 00                	add    %al,(%eax)
    8674:	00 00                	add    %al,(%eax)
    8676:	00 00                	add    %al,(%eax)
    8678:	00 00                	add    %al,(%eax)
    867a:	00 00                	add    %al,(%eax)
    867c:	00 00                	add    %al,(%eax)
    867e:	00 00                	add    %al,(%eax)
    8680:	00 00                	add    %al,(%eax)
    8682:	00 00                	add    %al,(%eax)
    8684:	00 00                	add    %al,(%eax)
    8686:	00 00                	add    %al,(%eax)
    8688:	00 00                	add    %al,(%eax)
    868a:	00 00                	add    %al,(%eax)
    868c:	00 00                	add    %al,(%eax)
    868e:	00 00                	add    %al,(%eax)
    8690:	00 00                	add    %al,(%eax)
    8692:	00 00                	add    %al,(%eax)
    8694:	00 00                	add    %al,(%eax)
    8696:	00 00                	add    %al,(%eax)
    8698:	00 00                	add    %al,(%eax)
    869a:	00 00                	add    %al,(%eax)
    869c:	00 00                	add    %al,(%eax)
    869e:	00 00                	add    %al,(%eax)
    86a0:	00 00                	add    %al,(%eax)
    86a2:	00 00                	add    %al,(%eax)
    86a4:	00 00                	add    %al,(%eax)
    86a6:	00 00                	add    %al,(%eax)
    86a8:	00 00                	add    %al,(%eax)
    86aa:	00 00                	add    %al,(%eax)
    86ac:	00 00                	add    %al,(%eax)
    86ae:	00 00                	add    %al,(%eax)
    86b0:	00 00                	add    %al,(%eax)
    86b2:	00 00                	add    %al,(%eax)
    86b4:	00 00                	add    %al,(%eax)
    86b6:	00 00                	add    %al,(%eax)
    86b8:	00 00                	add    %al,(%eax)
    86ba:	00 00                	add    %al,(%eax)
    86bc:	00 00                	add    %al,(%eax)
    86be:	00 00                	add    %al,(%eax)
    86c0:	00 00                	add    %al,(%eax)
    86c2:	00 00                	add    %al,(%eax)
    86c4:	00 00                	add    %al,(%eax)
    86c6:	00 00                	add    %al,(%eax)
    86c8:	00 00                	add    %al,(%eax)
    86ca:	00 00                	add    %al,(%eax)
    86cc:	00 00                	add    %al,(%eax)
    86ce:	00 00                	add    %al,(%eax)
    86d0:	00 00                	add    %al,(%eax)
    86d2:	00 00                	add    %al,(%eax)
    86d4:	00 00                	add    %al,(%eax)
    86d6:	00 00                	add    %al,(%eax)
    86d8:	00 00                	add    %al,(%eax)
    86da:	00 00                	add    %al,(%eax)
    86dc:	00 00                	add    %al,(%eax)
    86de:	00 00                	add    %al,(%eax)
    86e0:	00 00                	add    %al,(%eax)
    86e2:	00 00                	add    %al,(%eax)
    86e4:	00 00                	add    %al,(%eax)
    86e6:	00 00                	add    %al,(%eax)
    86e8:	00 00                	add    %al,(%eax)
    86ea:	00 00                	add    %al,(%eax)
    86ec:	00 00                	add    %al,(%eax)
    86ee:	00 00                	add    %al,(%eax)
    86f0:	00 00                	add    %al,(%eax)
    86f2:	00 00                	add    %al,(%eax)
    86f4:	00 00                	add    %al,(%eax)
    86f6:	00 00                	add    %al,(%eax)
    86f8:	00 00                	add    %al,(%eax)
    86fa:	00 00                	add    %al,(%eax)
    86fc:	00 00                	add    %al,(%eax)
    86fe:	00 00                	add    %al,(%eax)
    8700:	00 00                	add    %al,(%eax)
    8702:	00 00                	add    %al,(%eax)
    8704:	00 00                	add    %al,(%eax)
    8706:	00 00                	add    %al,(%eax)
    8708:	00 00                	add    %al,(%eax)
    870a:	00 00                	add    %al,(%eax)
    870c:	00 00                	add    %al,(%eax)
    870e:	00 00                	add    %al,(%eax)
    8710:	00 00                	add    %al,(%eax)
    8712:	00 00                	add    %al,(%eax)
    8714:	00 00                	add    %al,(%eax)
    8716:	00 00                	add    %al,(%eax)
    8718:	00 00                	add    %al,(%eax)
    871a:	00 00                	add    %al,(%eax)
    871c:	00 00                	add    %al,(%eax)
    871e:	00 00                	add    %al,(%eax)
    8720:	00 00                	add    %al,(%eax)
    8722:	00 00                	add    %al,(%eax)
    8724:	00 00                	add    %al,(%eax)
    8726:	00 00                	add    %al,(%eax)
    8728:	00 00                	add    %al,(%eax)
    872a:	00 00                	add    %al,(%eax)
    872c:	00 00                	add    %al,(%eax)
    872e:	00 00                	add    %al,(%eax)
    8730:	00 00                	add    %al,(%eax)
    8732:	00 00                	add    %al,(%eax)
    8734:	00 00                	add    %al,(%eax)
    8736:	00 00                	add    %al,(%eax)
    8738:	00 00                	add    %al,(%eax)
    873a:	00 00                	add    %al,(%eax)
    873c:	00 00                	add    %al,(%eax)
    873e:	00 00                	add    %al,(%eax)
    8740:	00 00                	add    %al,(%eax)
    8742:	00 00                	add    %al,(%eax)
    8744:	00 00                	add    %al,(%eax)
    8746:	00 00                	add    %al,(%eax)
    8748:	00 00                	add    %al,(%eax)
    874a:	00 00                	add    %al,(%eax)
    874c:	00 00                	add    %al,(%eax)
    874e:	00 00                	add    %al,(%eax)
    8750:	00 00                	add    %al,(%eax)
    8752:	00 00                	add    %al,(%eax)
    8754:	00 00                	add    %al,(%eax)
    8756:	00 00                	add    %al,(%eax)
    8758:	00 00                	add    %al,(%eax)
    875a:	00 00                	add    %al,(%eax)
    875c:	00 00                	add    %al,(%eax)
    875e:	00 00                	add    %al,(%eax)
    8760:	00 00                	add    %al,(%eax)
    8762:	00 00                	add    %al,(%eax)
    8764:	00 00                	add    %al,(%eax)
    8766:	00 00                	add    %al,(%eax)
    8768:	00 00                	add    %al,(%eax)
    876a:	00 00                	add    %al,(%eax)
    876c:	00 00                	add    %al,(%eax)
    876e:	00 00                	add    %al,(%eax)
    8770:	00 00                	add    %al,(%eax)
    8772:	00 00                	add    %al,(%eax)
    8774:	00 00                	add    %al,(%eax)
    8776:	00 00                	add    %al,(%eax)
    8778:	00 00                	add    %al,(%eax)
    877a:	00 00                	add    %al,(%eax)
    877c:	00 00                	add    %al,(%eax)
    877e:	00 00                	add    %al,(%eax)
    8780:	00 00                	add    %al,(%eax)
    8782:	00 00                	add    %al,(%eax)
    8784:	00 00                	add    %al,(%eax)
    8786:	00 00                	add    %al,(%eax)
    8788:	00 00                	add    %al,(%eax)
    878a:	00 00                	add    %al,(%eax)
    878c:	00 00                	add    %al,(%eax)
    878e:	00 00                	add    %al,(%eax)
    8790:	00 00                	add    %al,(%eax)
    8792:	00 00                	add    %al,(%eax)
    8794:	00 00                	add    %al,(%eax)
    8796:	00 00                	add    %al,(%eax)
    8798:	00 00                	add    %al,(%eax)
    879a:	00 00                	add    %al,(%eax)
    879c:	00 00                	add    %al,(%eax)
    879e:	00 00                	add    %al,(%eax)
    87a0:	00 00                	add    %al,(%eax)
    87a2:	00 00                	add    %al,(%eax)
    87a4:	00 00                	add    %al,(%eax)
    87a6:	00 00                	add    %al,(%eax)
    87a8:	00 00                	add    %al,(%eax)
    87aa:	00 00                	add    %al,(%eax)
    87ac:	00 00                	add    %al,(%eax)
    87ae:	00 00                	add    %al,(%eax)
    87b0:	00 00                	add    %al,(%eax)
    87b2:	00 00                	add    %al,(%eax)
    87b4:	00 00                	add    %al,(%eax)
    87b6:	00 00                	add    %al,(%eax)
    87b8:	00 00                	add    %al,(%eax)
    87ba:	00 00                	add    %al,(%eax)
    87bc:	00 00                	add    %al,(%eax)
    87be:	00 00                	add    %al,(%eax)
    87c0:	00 00                	add    %al,(%eax)
    87c2:	00 00                	add    %al,(%eax)
    87c4:	00 00                	add    %al,(%eax)
    87c6:	00 00                	add    %al,(%eax)
    87c8:	00 00                	add    %al,(%eax)
    87ca:	00 00                	add    %al,(%eax)
    87cc:	00 00                	add    %al,(%eax)
    87ce:	00 00                	add    %al,(%eax)
    87d0:	00 00                	add    %al,(%eax)
    87d2:	00 00                	add    %al,(%eax)
    87d4:	00 00                	add    %al,(%eax)
    87d6:	00 00                	add    %al,(%eax)
    87d8:	00 00                	add    %al,(%eax)
    87da:	00 00                	add    %al,(%eax)
    87dc:	00 00                	add    %al,(%eax)
    87de:	00 00                	add    %al,(%eax)
    87e0:	00 00                	add    %al,(%eax)
    87e2:	00 00                	add    %al,(%eax)
    87e4:	00 00                	add    %al,(%eax)
    87e6:	00 00                	add    %al,(%eax)
    87e8:	00 00                	add    %al,(%eax)
    87ea:	00 00                	add    %al,(%eax)
    87ec:	00 00                	add    %al,(%eax)
    87ee:	00 00                	add    %al,(%eax)
    87f0:	00 00                	add    %al,(%eax)
    87f2:	00 00                	add    %al,(%eax)
    87f4:	00 00                	add    %al,(%eax)
    87f6:	00 00                	add    %al,(%eax)
    87f8:	00 00                	add    %al,(%eax)
    87fa:	00 00                	add    %al,(%eax)
    87fc:	00 00                	add    %al,(%eax)
    87fe:	00 00                	add    %al,(%eax)
    8800:	00 00                	add    %al,(%eax)
    8802:	00 00                	add    %al,(%eax)
    8804:	00 00                	add    %al,(%eax)
    8806:	00 00                	add    %al,(%eax)
    8808:	00 00                	add    %al,(%eax)
    880a:	00 00                	add    %al,(%eax)
    880c:	00 00                	add    %al,(%eax)
    880e:	00 00                	add    %al,(%eax)
    8810:	00 00                	add    %al,(%eax)
    8812:	00 00                	add    %al,(%eax)
    8814:	00 00                	add    %al,(%eax)
    8816:	00 00                	add    %al,(%eax)
    8818:	00 00                	add    %al,(%eax)
    881a:	00 00                	add    %al,(%eax)
    881c:	00 00                	add    %al,(%eax)
    881e:	00 00                	add    %al,(%eax)
    8820:	00 00                	add    %al,(%eax)
    8822:	00 00                	add    %al,(%eax)
    8824:	00 00                	add    %al,(%eax)
    8826:	00 00                	add    %al,(%eax)
    8828:	00 00                	add    %al,(%eax)
    882a:	00 00                	add    %al,(%eax)
    882c:	00 00                	add    %al,(%eax)
    882e:	00 00                	add    %al,(%eax)
    8830:	00 00                	add    %al,(%eax)
    8832:	00 00                	add    %al,(%eax)
    8834:	00 00                	add    %al,(%eax)
    8836:	00 00                	add    %al,(%eax)
    8838:	00 00                	add    %al,(%eax)
    883a:	00 00                	add    %al,(%eax)
    883c:	00 00                	add    %al,(%eax)
    883e:	00 00                	add    %al,(%eax)
    8840:	00 00                	add    %al,(%eax)
    8842:	00 00                	add    %al,(%eax)
    8844:	00 00                	add    %al,(%eax)
    8846:	00 00                	add    %al,(%eax)
    8848:	00 00                	add    %al,(%eax)
    884a:	00 00                	add    %al,(%eax)
    884c:	00 00                	add    %al,(%eax)
    884e:	00 00                	add    %al,(%eax)
    8850:	00 00                	add    %al,(%eax)
    8852:	00 00                	add    %al,(%eax)
    8854:	00 00                	add    %al,(%eax)
    8856:	00 00                	add    %al,(%eax)
    8858:	00 00                	add    %al,(%eax)
    885a:	00 00                	add    %al,(%eax)
    885c:	00 00                	add    %al,(%eax)
    885e:	00 00                	add    %al,(%eax)
    8860:	00 00                	add    %al,(%eax)
    8862:	00 00                	add    %al,(%eax)
    8864:	00 00                	add    %al,(%eax)
    8866:	00 00                	add    %al,(%eax)
    8868:	00 00                	add    %al,(%eax)
    886a:	00 00                	add    %al,(%eax)
    886c:	00 00                	add    %al,(%eax)
    886e:	00 00                	add    %al,(%eax)
    8870:	00 00                	add    %al,(%eax)
    8872:	00 00                	add    %al,(%eax)
    8874:	00 00                	add    %al,(%eax)
    8876:	00 00                	add    %al,(%eax)
    8878:	00 00                	add    %al,(%eax)
    887a:	00 00                	add    %al,(%eax)
    887c:	00 00                	add    %al,(%eax)
    887e:	00 00                	add    %al,(%eax)
    8880:	00 00                	add    %al,(%eax)
    8882:	00 00                	add    %al,(%eax)
    8884:	00 00                	add    %al,(%eax)
    8886:	00 00                	add    %al,(%eax)
    8888:	00 00                	add    %al,(%eax)
    888a:	00 00                	add    %al,(%eax)
    888c:	00 00                	add    %al,(%eax)
    888e:	00 00                	add    %al,(%eax)
    8890:	00 00                	add    %al,(%eax)
    8892:	00 00                	add    %al,(%eax)
    8894:	00 00                	add    %al,(%eax)
    8896:	00 00                	add    %al,(%eax)
    8898:	00 00                	add    %al,(%eax)
    889a:	00 00                	add    %al,(%eax)
    889c:	00 00                	add    %al,(%eax)
    889e:	00 00                	add    %al,(%eax)
    88a0:	00 00                	add    %al,(%eax)
    88a2:	00 00                	add    %al,(%eax)
    88a4:	00 00                	add    %al,(%eax)
    88a6:	00 00                	add    %al,(%eax)
    88a8:	00 00                	add    %al,(%eax)
    88aa:	00 00                	add    %al,(%eax)
    88ac:	00 00                	add    %al,(%eax)
    88ae:	00 00                	add    %al,(%eax)
    88b0:	00 00                	add    %al,(%eax)
    88b2:	00 00                	add    %al,(%eax)
    88b4:	00 00                	add    %al,(%eax)
    88b6:	00 00                	add    %al,(%eax)
    88b8:	00 00                	add    %al,(%eax)
    88ba:	00 00                	add    %al,(%eax)
    88bc:	00 00                	add    %al,(%eax)
    88be:	00 00                	add    %al,(%eax)
    88c0:	00 00                	add    %al,(%eax)
    88c2:	00 00                	add    %al,(%eax)
    88c4:	00 00                	add    %al,(%eax)
    88c6:	00 00                	add    %al,(%eax)
    88c8:	00 00                	add    %al,(%eax)
    88ca:	00 00                	add    %al,(%eax)
    88cc:	00 00                	add    %al,(%eax)
    88ce:	00 00                	add    %al,(%eax)
    88d0:	00 00                	add    %al,(%eax)
    88d2:	00 00                	add    %al,(%eax)
    88d4:	00 00                	add    %al,(%eax)
    88d6:	00 00                	add    %al,(%eax)
    88d8:	00 00                	add    %al,(%eax)
    88da:	00 00                	add    %al,(%eax)
    88dc:	00 00                	add    %al,(%eax)
    88de:	00 00                	add    %al,(%eax)
    88e0:	00 00                	add    %al,(%eax)
    88e2:	00 00                	add    %al,(%eax)
    88e4:	00 00                	add    %al,(%eax)
    88e6:	00 00                	add    %al,(%eax)
    88e8:	00 00                	add    %al,(%eax)
    88ea:	00 00                	add    %al,(%eax)
    88ec:	00 00                	add    %al,(%eax)
    88ee:	00 00                	add    %al,(%eax)
    88f0:	00 00                	add    %al,(%eax)
    88f2:	00 00                	add    %al,(%eax)
    88f4:	00 00                	add    %al,(%eax)
    88f6:	00 00                	add    %al,(%eax)
    88f8:	00 00                	add    %al,(%eax)
    88fa:	00 00                	add    %al,(%eax)
    88fc:	00 00                	add    %al,(%eax)
    88fe:	00 00                	add    %al,(%eax)
    8900:	00 00                	add    %al,(%eax)
    8902:	00 00                	add    %al,(%eax)
    8904:	00 00                	add    %al,(%eax)
    8906:	00 00                	add    %al,(%eax)
    8908:	00 00                	add    %al,(%eax)
    890a:	00 00                	add    %al,(%eax)
    890c:	00 00                	add    %al,(%eax)
    890e:	00 00                	add    %al,(%eax)
    8910:	00 00                	add    %al,(%eax)
    8912:	00 00                	add    %al,(%eax)
    8914:	00 00                	add    %al,(%eax)
    8916:	00 00                	add    %al,(%eax)
    8918:	00 00                	add    %al,(%eax)
    891a:	00 00                	add    %al,(%eax)
    891c:	00 00                	add    %al,(%eax)
    891e:	00 00                	add    %al,(%eax)
    8920:	00 00                	add    %al,(%eax)
    8922:	00 00                	add    %al,(%eax)
    8924:	00 00                	add    %al,(%eax)
    8926:	00 00                	add    %al,(%eax)
    8928:	00 00                	add    %al,(%eax)
    892a:	00 00                	add    %al,(%eax)
    892c:	00 00                	add    %al,(%eax)
    892e:	00 00                	add    %al,(%eax)
    8930:	00 00                	add    %al,(%eax)
    8932:	00 00                	add    %al,(%eax)
    8934:	00 00                	add    %al,(%eax)
    8936:	00 00                	add    %al,(%eax)
    8938:	00 00                	add    %al,(%eax)
    893a:	00 00                	add    %al,(%eax)
    893c:	00 00                	add    %al,(%eax)
    893e:	00 00                	add    %al,(%eax)
    8940:	00 00                	add    %al,(%eax)
    8942:	00 00                	add    %al,(%eax)
    8944:	00 00                	add    %al,(%eax)
    8946:	00 00                	add    %al,(%eax)
    8948:	00 00                	add    %al,(%eax)
    894a:	00 00                	add    %al,(%eax)
    894c:	00 00                	add    %al,(%eax)
    894e:	00 00                	add    %al,(%eax)
    8950:	00 00                	add    %al,(%eax)
    8952:	00 00                	add    %al,(%eax)
    8954:	00 00                	add    %al,(%eax)
    8956:	00 00                	add    %al,(%eax)
    8958:	00 00                	add    %al,(%eax)
    895a:	00 00                	add    %al,(%eax)
    895c:	00 00                	add    %al,(%eax)
    895e:	00 00                	add    %al,(%eax)
    8960:	00 00                	add    %al,(%eax)
    8962:	00 00                	add    %al,(%eax)
    8964:	00 00                	add    %al,(%eax)
    8966:	00 00                	add    %al,(%eax)
    8968:	00 00                	add    %al,(%eax)
    896a:	00 00                	add    %al,(%eax)
    896c:	00 00                	add    %al,(%eax)
    896e:	00 00                	add    %al,(%eax)
    8970:	00 00                	add    %al,(%eax)
    8972:	00 00                	add    %al,(%eax)
    8974:	00 00                	add    %al,(%eax)
    8976:	00 00                	add    %al,(%eax)
    8978:	00 00                	add    %al,(%eax)
    897a:	00 00                	add    %al,(%eax)
    897c:	00 00                	add    %al,(%eax)
    897e:	00 00                	add    %al,(%eax)
    8980:	00 00                	add    %al,(%eax)
    8982:	00 00                	add    %al,(%eax)
    8984:	00 00                	add    %al,(%eax)
    8986:	00 00                	add    %al,(%eax)
    8988:	00 00                	add    %al,(%eax)
    898a:	00 00                	add    %al,(%eax)
    898c:	00 00                	add    %al,(%eax)
    898e:	00 00                	add    %al,(%eax)
    8990:	00 00                	add    %al,(%eax)
    8992:	00 00                	add    %al,(%eax)
    8994:	00 00                	add    %al,(%eax)
    8996:	00 00                	add    %al,(%eax)
    8998:	00 00                	add    %al,(%eax)
    899a:	00 00                	add    %al,(%eax)
    899c:	00 00                	add    %al,(%eax)
    899e:	00 00                	add    %al,(%eax)
    89a0:	00 00                	add    %al,(%eax)
    89a2:	00 00                	add    %al,(%eax)
    89a4:	00 00                	add    %al,(%eax)
    89a6:	00 00                	add    %al,(%eax)
    89a8:	00 00                	add    %al,(%eax)
    89aa:	00 00                	add    %al,(%eax)
    89ac:	00 00                	add    %al,(%eax)
    89ae:	00 00                	add    %al,(%eax)
    89b0:	00 00                	add    %al,(%eax)
    89b2:	00 00                	add    %al,(%eax)
    89b4:	00 00                	add    %al,(%eax)
    89b6:	00 00                	add    %al,(%eax)
    89b8:	00 00                	add    %al,(%eax)
    89ba:	00 00                	add    %al,(%eax)
    89bc:	00 00                	add    %al,(%eax)
    89be:	00 00                	add    %al,(%eax)
    89c0:	00 00                	add    %al,(%eax)
    89c2:	00 00                	add    %al,(%eax)
    89c4:	00 00                	add    %al,(%eax)
    89c6:	00 00                	add    %al,(%eax)
    89c8:	00 00                	add    %al,(%eax)
    89ca:	00 00                	add    %al,(%eax)
    89cc:	00 00                	add    %al,(%eax)
    89ce:	00 00                	add    %al,(%eax)
    89d0:	00 00                	add    %al,(%eax)
    89d2:	00 00                	add    %al,(%eax)
    89d4:	00 00                	add    %al,(%eax)
    89d6:	00 00                	add    %al,(%eax)
    89d8:	00 00                	add    %al,(%eax)
    89da:	00 00                	add    %al,(%eax)
    89dc:	00 00                	add    %al,(%eax)
    89de:	00 00                	add    %al,(%eax)
    89e0:	00 00                	add    %al,(%eax)
    89e2:	00 00                	add    %al,(%eax)
    89e4:	00 00                	add    %al,(%eax)
    89e6:	00 00                	add    %al,(%eax)
    89e8:	00 00                	add    %al,(%eax)
    89ea:	00 00                	add    %al,(%eax)
    89ec:	00 00                	add    %al,(%eax)
    89ee:	00 00                	add    %al,(%eax)
    89f0:	00 00                	add    %al,(%eax)
    89f2:	00 00                	add    %al,(%eax)
    89f4:	00 00                	add    %al,(%eax)
    89f6:	00 00                	add    %al,(%eax)
    89f8:	00 00                	add    %al,(%eax)
    89fa:	00 00                	add    %al,(%eax)
    89fc:	00 00                	add    %al,(%eax)
    89fe:	00 00                	add    %al,(%eax)
    8a00:	00 00                	add    %al,(%eax)
    8a02:	00 00                	add    %al,(%eax)
    8a04:	00 00                	add    %al,(%eax)
    8a06:	00 00                	add    %al,(%eax)
    8a08:	00 00                	add    %al,(%eax)
    8a0a:	00 00                	add    %al,(%eax)
    8a0c:	00 00                	add    %al,(%eax)
    8a0e:	00 00                	add    %al,(%eax)
    8a10:	00 00                	add    %al,(%eax)
    8a12:	00 00                	add    %al,(%eax)
    8a14:	00 00                	add    %al,(%eax)
    8a16:	00 00                	add    %al,(%eax)
    8a18:	00 00                	add    %al,(%eax)
    8a1a:	00 00                	add    %al,(%eax)
    8a1c:	00 00                	add    %al,(%eax)
    8a1e:	00 00                	add    %al,(%eax)
    8a20:	00 00                	add    %al,(%eax)
    8a22:	00 00                	add    %al,(%eax)
    8a24:	00 00                	add    %al,(%eax)
    8a26:	00 00                	add    %al,(%eax)
    8a28:	00 00                	add    %al,(%eax)
    8a2a:	00 00                	add    %al,(%eax)
    8a2c:	00 00                	add    %al,(%eax)
    8a2e:	00 00                	add    %al,(%eax)
    8a30:	00 00                	add    %al,(%eax)
    8a32:	00 00                	add    %al,(%eax)
    8a34:	00 00                	add    %al,(%eax)
    8a36:	00 00                	add    %al,(%eax)
    8a38:	00 00                	add    %al,(%eax)
    8a3a:	00 00                	add    %al,(%eax)
    8a3c:	00 00                	add    %al,(%eax)
    8a3e:	00 00                	add    %al,(%eax)
    8a40:	00 00                	add    %al,(%eax)
    8a42:	00 00                	add    %al,(%eax)
    8a44:	00 00                	add    %al,(%eax)
    8a46:	00 00                	add    %al,(%eax)
    8a48:	00 00                	add    %al,(%eax)
    8a4a:	00 00                	add    %al,(%eax)
    8a4c:	00 00                	add    %al,(%eax)
    8a4e:	00 00                	add    %al,(%eax)
    8a50:	00 00                	add    %al,(%eax)
    8a52:	00 00                	add    %al,(%eax)
    8a54:	00 00                	add    %al,(%eax)
    8a56:	00 00                	add    %al,(%eax)
    8a58:	00 00                	add    %al,(%eax)
    8a5a:	00 00                	add    %al,(%eax)
    8a5c:	00 00                	add    %al,(%eax)
    8a5e:	00 00                	add    %al,(%eax)
    8a60:	00 00                	add    %al,(%eax)
    8a62:	00 00                	add    %al,(%eax)
    8a64:	00 00                	add    %al,(%eax)
    8a66:	00 00                	add    %al,(%eax)
    8a68:	00 00                	add    %al,(%eax)
    8a6a:	00 00                	add    %al,(%eax)
    8a6c:	00 00                	add    %al,(%eax)
    8a6e:	00 00                	add    %al,(%eax)
    8a70:	00 00                	add    %al,(%eax)
    8a72:	00 00                	add    %al,(%eax)
    8a74:	00 00                	add    %al,(%eax)
    8a76:	00 00                	add    %al,(%eax)
    8a78:	00 00                	add    %al,(%eax)
    8a7a:	00 00                	add    %al,(%eax)
    8a7c:	00 00                	add    %al,(%eax)
    8a7e:	00 00                	add    %al,(%eax)
    8a80:	00 00                	add    %al,(%eax)
    8a82:	00 00                	add    %al,(%eax)
    8a84:	00 00                	add    %al,(%eax)
    8a86:	00 00                	add    %al,(%eax)
    8a88:	00 00                	add    %al,(%eax)
    8a8a:	00 00                	add    %al,(%eax)
    8a8c:	00 00                	add    %al,(%eax)
    8a8e:	00 00                	add    %al,(%eax)
    8a90:	00 00                	add    %al,(%eax)
    8a92:	00 00                	add    %al,(%eax)
    8a94:	00 00                	add    %al,(%eax)
    8a96:	00 00                	add    %al,(%eax)
    8a98:	00 00                	add    %al,(%eax)
    8a9a:	00 00                	add    %al,(%eax)
    8a9c:	00 00                	add    %al,(%eax)
    8a9e:	00 00                	add    %al,(%eax)
    8aa0:	00 00                	add    %al,(%eax)
    8aa2:	00 00                	add    %al,(%eax)
    8aa4:	00 00                	add    %al,(%eax)
    8aa6:	00 00                	add    %al,(%eax)
    8aa8:	00 00                	add    %al,(%eax)
    8aaa:	00 00                	add    %al,(%eax)
    8aac:	00 00                	add    %al,(%eax)
    8aae:	00 00                	add    %al,(%eax)
    8ab0:	00 00                	add    %al,(%eax)
    8ab2:	00 00                	add    %al,(%eax)
    8ab4:	00 00                	add    %al,(%eax)
    8ab6:	00 00                	add    %al,(%eax)
    8ab8:	00 00                	add    %al,(%eax)
    8aba:	00 00                	add    %al,(%eax)
    8abc:	00 00                	add    %al,(%eax)
    8abe:	00 00                	add    %al,(%eax)
    8ac0:	00 00                	add    %al,(%eax)
    8ac2:	00 00                	add    %al,(%eax)
    8ac4:	00 00                	add    %al,(%eax)
    8ac6:	00 00                	add    %al,(%eax)
    8ac8:	00 00                	add    %al,(%eax)
    8aca:	00 00                	add    %al,(%eax)
    8acc:	00 00                	add    %al,(%eax)
    8ace:	00 00                	add    %al,(%eax)
    8ad0:	00 00                	add    %al,(%eax)
    8ad2:	00 00                	add    %al,(%eax)
    8ad4:	00 00                	add    %al,(%eax)
    8ad6:	00 00                	add    %al,(%eax)
    8ad8:	00 00                	add    %al,(%eax)
    8ada:	00 00                	add    %al,(%eax)
    8adc:	00 00                	add    %al,(%eax)
    8ade:	00 00                	add    %al,(%eax)
    8ae0:	00 00                	add    %al,(%eax)
    8ae2:	00 00                	add    %al,(%eax)
    8ae4:	00 00                	add    %al,(%eax)
    8ae6:	00 00                	add    %al,(%eax)
    8ae8:	00 00                	add    %al,(%eax)
    8aea:	00 00                	add    %al,(%eax)
    8aec:	00 00                	add    %al,(%eax)
    8aee:	00 00                	add    %al,(%eax)
    8af0:	00 00                	add    %al,(%eax)
    8af2:	00 00                	add    %al,(%eax)
    8af4:	00 00                	add    %al,(%eax)
    8af6:	00 00                	add    %al,(%eax)
    8af8:	00 00                	add    %al,(%eax)
    8afa:	00 00                	add    %al,(%eax)
    8afc:	00 00                	add    %al,(%eax)
    8afe:	00 00                	add    %al,(%eax)
    8b00:	00 00                	add    %al,(%eax)
    8b02:	00 00                	add    %al,(%eax)
    8b04:	00 00                	add    %al,(%eax)
    8b06:	00 00                	add    %al,(%eax)
    8b08:	00 00                	add    %al,(%eax)
    8b0a:	00 00                	add    %al,(%eax)
    8b0c:	00 00                	add    %al,(%eax)

00008b0e <putc>:
 */
volatile char *video = (volatile char*) 0xB8000;

void
putc (int l, int color, char ch)
{
    8b0e:	55                   	push   %ebp
    8b0f:	e8 9f 02 00 00       	call   8db3 <__x86.get_pc_thunk.dx>
    8b14:	81 c2 98 07 00 00    	add    $0x798,%edx
    8b1a:	89 e5                	mov    %esp,%ebp
    8b1c:	8b 45 08             	mov    0x8(%ebp),%eax
	volatile char * p = video + l * 2;
    8b1f:	01 c0                	add    %eax,%eax
    8b21:	03 82 34 00 00 00    	add    0x34(%edx),%eax
	* p = ch;
    8b27:	8b 55 10             	mov    0x10(%ebp),%edx
    8b2a:	88 10                	mov    %dl,(%eax)
	* (p + 1) = color;
    8b2c:	8b 55 0c             	mov    0xc(%ebp),%edx
    8b2f:	88 50 01             	mov    %dl,0x1(%eax)
}
    8b32:	5d                   	pop    %ebp
    8b33:	c3                   	ret    

00008b34 <puts>:


int
puts (int r, int c, int color, const char *string)
{
    8b34:	55                   	push   %ebp
    8b35:	89 e5                	mov    %esp,%ebp
    8b37:	56                   	push   %esi
    8b38:	53                   	push   %ebx
	int l = r * 80 + c;
    8b39:	6b 75 08 50          	imul   $0x50,0x8(%ebp),%esi
{
    8b3d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	int l = r * 80 + c;
    8b40:	03 75 0c             	add    0xc(%ebp),%esi
    8b43:	89 f0                	mov    %esi,%eax
	while (*string != 0)
    8b45:	8b 55 14             	mov    0x14(%ebp),%edx
    8b48:	29 f2                	sub    %esi,%edx
    8b4a:	0f be 14 02          	movsbl (%edx,%eax,1),%edx
    8b4e:	84 d2                	test   %dl,%dl
    8b50:	74 12                	je     8b64 <puts+0x30>
	{
		putc (l++, color, *string++);
    8b52:	52                   	push   %edx
    8b53:	8d 58 01             	lea    0x1(%eax),%ebx
    8b56:	51                   	push   %ecx
    8b57:	50                   	push   %eax
    8b58:	e8 b1 ff ff ff       	call   8b0e <putc>
    8b5d:	83 c4 0c             	add    $0xc,%esp
    8b60:	89 d8                	mov    %ebx,%eax
    8b62:	eb e1                	jmp    8b45 <puts+0x11>
	}
	return l;
}
    8b64:	8d 65 f8             	lea    -0x8(%ebp),%esp
    8b67:	5b                   	pop    %ebx
    8b68:	5e                   	pop    %esi
    8b69:	5d                   	pop    %ebp
    8b6a:	c3                   	ret    

00008b6b <putline>:
char * blank =
"                                                                                ";

void
putline (char * s)
{
    8b6b:	e8 3f 02 00 00       	call   8daf <__x86.get_pc_thunk.ax>
    8b70:	05 3c 07 00 00       	add    $0x73c,%eax
    8b75:	55                   	push   %ebp
	puts (row = (row >= CRT_ROWS) ? 0 : row + 1, 0, VGA_CLR_BLACK, blank);
    8b76:	8b 90 dc 00 00 00    	mov    0xdc(%eax),%edx
    8b7c:	8b 88 38 00 00 00    	mov    0x38(%eax),%ecx
{
    8b82:	89 e5                	mov    %esp,%ebp
    8b84:	53                   	push   %ebx
	puts (row = (row >= CRT_ROWS) ? 0 : row + 1, 0, VGA_CLR_BLACK, blank);
    8b85:	83 fa 18             	cmp    $0x18,%edx
    8b88:	8d 5a 01             	lea    0x1(%edx),%ebx
    8b8b:	7e 02                	jle    8b8f <putline+0x24>
    8b8d:	31 db                	xor    %ebx,%ebx
    8b8f:	51                   	push   %ecx
    8b90:	6a 00                	push   $0x0
    8b92:	6a 00                	push   $0x0
    8b94:	53                   	push   %ebx
    8b95:	89 98 dc 00 00 00    	mov    %ebx,0xdc(%eax)
    8b9b:	e8 94 ff ff ff       	call   8b34 <puts>
	puts (row, 0, VGA_CLR_WHITE, s);
    8ba0:	ff 75 08             	pushl  0x8(%ebp)
    8ba3:	6a 0f                	push   $0xf
    8ba5:	6a 00                	push   $0x0
    8ba7:	53                   	push   %ebx
    8ba8:	e8 87 ff ff ff       	call   8b34 <puts>
}
    8bad:	83 c4 20             	add    $0x20,%esp
    8bb0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    8bb3:	c9                   	leave  
    8bb4:	c3                   	ret    

00008bb5 <roll>:

void
roll (int r)
{
    8bb5:	55                   	push   %ebp
    8bb6:	e8 f4 01 00 00       	call   8daf <__x86.get_pc_thunk.ax>
    8bbb:	05 f1 06 00 00       	add    $0x6f1,%eax
    8bc0:	89 e5                	mov    %esp,%ebp
	row = r;
    8bc2:	8b 55 08             	mov    0x8(%ebp),%edx
}
    8bc5:	5d                   	pop    %ebp
	row = r;
    8bc6:	89 90 dc 00 00 00    	mov    %edx,0xdc(%eax)
}
    8bcc:	c3                   	ret    

00008bcd <panic>:

void
panic (char * m)
{
    8bcd:	55                   	push   %ebp
    8bce:	89 e5                	mov    %esp,%ebp
	puts (0, 0, VGA_CLR_RED, m);
    8bd0:	ff 75 08             	pushl  0x8(%ebp)
    8bd3:	6a 04                	push   $0x4
    8bd5:	6a 00                	push   $0x0
    8bd7:	6a 00                	push   $0x0
    8bd9:	e8 56 ff ff ff       	call   8b34 <puts>
    8bde:	83 c4 10             	add    $0x10,%esp
	while (1)
	{
		asm volatile("hlt");
    8be1:	f4                   	hlt    
    8be2:	eb fd                	jmp    8be1 <panic+0x14>

00008be4 <strlen>:
 * string
 */

int
strlen (const char *s)
{
    8be4:	55                   	push   %ebp
	int n;

	for (n = 0; *s != '\0'; s++)
    8be5:	31 c0                	xor    %eax,%eax
{
    8be7:	89 e5                	mov    %esp,%ebp
    8be9:	8b 55 08             	mov    0x8(%ebp),%edx
	for (n = 0; *s != '\0'; s++)
    8bec:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
    8bf0:	74 03                	je     8bf5 <strlen+0x11>
		n++;
    8bf2:	40                   	inc    %eax
    8bf3:	eb f7                	jmp    8bec <strlen+0x8>
	return n;
}
    8bf5:	5d                   	pop    %ebp
    8bf6:	c3                   	ret    

00008bf7 <reverse>:

/* reverse:  reverse string s in place */
void
reverse (char s[])
{
    8bf7:	55                   	push   %ebp
    8bf8:	89 e5                	mov    %esp,%ebp
    8bfa:	56                   	push   %esi
    8bfb:	53                   	push   %ebx
    8bfc:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i, j;
	char c;

	for (i = 0, j = strlen (s) - 1; i < j; i++, j--)
    8bff:	51                   	push   %ecx
    8c00:	e8 df ff ff ff       	call   8be4 <strlen>
    8c05:	5a                   	pop    %edx
    8c06:	48                   	dec    %eax
    8c07:	31 d2                	xor    %edx,%edx
    8c09:	39 c2                	cmp    %eax,%edx
    8c0b:	7d 13                	jge    8c20 <reverse+0x29>
	{
		c = s[i];
    8c0d:	0f b6 34 11          	movzbl (%ecx,%edx,1),%esi
		s[i] = s[j];
    8c11:	8a 1c 01             	mov    (%ecx,%eax,1),%bl
    8c14:	88 1c 11             	mov    %bl,(%ecx,%edx,1)
	for (i = 0, j = strlen (s) - 1; i < j; i++, j--)
    8c17:	42                   	inc    %edx
		s[j] = c;
    8c18:	89 f3                	mov    %esi,%ebx
    8c1a:	88 1c 01             	mov    %bl,(%ecx,%eax,1)
	for (i = 0, j = strlen (s) - 1; i < j; i++, j--)
    8c1d:	48                   	dec    %eax
    8c1e:	eb e9                	jmp    8c09 <reverse+0x12>
	}
}
    8c20:	8d 65 f8             	lea    -0x8(%ebp),%esp
    8c23:	5b                   	pop    %ebx
    8c24:	5e                   	pop    %esi
    8c25:	5d                   	pop    %ebp
    8c26:	c3                   	ret    

00008c27 <itox>:

/* itoa:  convert n to characters in s */
void
itox (int n, char s[], int root, char * table)
{
    8c27:	55                   	push   %ebp
    8c28:	89 e5                	mov    %esp,%ebp
    8c2a:	57                   	push   %edi
    8c2b:	56                   	push   %esi
    8c2c:	53                   	push   %ebx
    8c2d:	31 db                	xor    %ebx,%ebx
    8c2f:	83 ec 08             	sub    $0x8,%esp
    8c32:	8b 45 08             	mov    0x8(%ebp),%eax
    8c35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    8c38:	8b 75 14             	mov    0x14(%ebp),%esi
    8c3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    8c3e:	8b 45 10             	mov    0x10(%ebp),%eax
    8c41:	8b 55 f0             	mov    -0x10(%ebp),%edx
    8c44:	89 45 ec             	mov    %eax,-0x14(%ebp)
    8c47:	8b 45 f0             	mov    -0x10(%ebp),%eax
    8c4a:	c1 fa 1f             	sar    $0x1f,%edx
    8c4d:	31 d0                	xor    %edx,%eax
    8c4f:	29 d0                	sub    %edx,%eax
    8c51:	99                   	cltd   
	if ((sign = n) < 0) /* record sign */
		n = -n; /* make n positive */
	i = 0;
	do
	{ /* generate digits in reverse order */
		s[i++] = table[n % root]; /* get next digit */
    8c52:	8d 7b 01             	lea    0x1(%ebx),%edi
    8c55:	f7 7d ec             	idivl  -0x14(%ebp)
    8c58:	8a 14 16             	mov    (%esi,%edx,1),%dl
	} while ((n /= root) > 0); /* delete it */
    8c5b:	85 c0                	test   %eax,%eax
		s[i++] = table[n % root]; /* get next digit */
    8c5d:	88 54 39 ff          	mov    %dl,-0x1(%ecx,%edi,1)
    8c61:	89 fa                	mov    %edi,%edx
	} while ((n /= root) > 0); /* delete it */
    8c63:	7e 04                	jle    8c69 <itox+0x42>
		s[i++] = table[n % root]; /* get next digit */
    8c65:	89 fb                	mov    %edi,%ebx
    8c67:	eb e8                	jmp    8c51 <itox+0x2a>
	if (sign < 0)
    8c69:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    8c6d:	79 07                	jns    8c76 <itox+0x4f>
		s[i++] = '-';
    8c6f:	8d 7b 02             	lea    0x2(%ebx),%edi
    8c72:	c6 04 11 2d          	movb   $0x2d,(%ecx,%edx,1)
	s[i] = '\0';
    8c76:	c6 04 39 00          	movb   $0x0,(%ecx,%edi,1)
	reverse (s);
    8c7a:	89 4d 08             	mov    %ecx,0x8(%ebp)
}
    8c7d:	58                   	pop    %eax
    8c7e:	5a                   	pop    %edx
    8c7f:	5b                   	pop    %ebx
    8c80:	5e                   	pop    %esi
    8c81:	5f                   	pop    %edi
    8c82:	5d                   	pop    %ebp
	reverse (s);
    8c83:	e9 6f ff ff ff       	jmp    8bf7 <reverse>

00008c88 <itoa>:

void
itoa (int n, char s[])
{
    8c88:	e8 22 01 00 00       	call   8daf <__x86.get_pc_thunk.ax>
    8c8d:	05 1f 06 00 00       	add    $0x61f,%eax
    8c92:	55                   	push   %ebp
	static char dec[] = "0123456789";
	itox(n, s, 10, dec);
    8c93:	8d 80 28 00 00 00    	lea    0x28(%eax),%eax
{
    8c99:	89 e5                	mov    %esp,%ebp
	itox(n, s, 10, dec);
    8c9b:	50                   	push   %eax
    8c9c:	6a 0a                	push   $0xa
    8c9e:	ff 75 0c             	pushl  0xc(%ebp)
    8ca1:	ff 75 08             	pushl  0x8(%ebp)
    8ca4:	e8 7e ff ff ff       	call   8c27 <itox>
}
    8ca9:	83 c4 10             	add    $0x10,%esp
    8cac:	c9                   	leave  
    8cad:	c3                   	ret    

00008cae <itoh>:


void
itoh (int n, char* s)
{
    8cae:	e8 fc 00 00 00       	call   8daf <__x86.get_pc_thunk.ax>
    8cb3:	05 f9 05 00 00       	add    $0x5f9,%eax
    8cb8:	55                   	push   %ebp
	static char hex[] = "0123456789abcdef";
	itox(n, s, 16, hex);
    8cb9:	8d 80 14 00 00 00    	lea    0x14(%eax),%eax
{
    8cbf:	89 e5                	mov    %esp,%ebp
	itox(n, s, 16, hex);
    8cc1:	50                   	push   %eax
    8cc2:	6a 10                	push   $0x10
    8cc4:	ff 75 0c             	pushl  0xc(%ebp)
    8cc7:	ff 75 08             	pushl  0x8(%ebp)
    8cca:	e8 58 ff ff ff       	call   8c27 <itox>
}
    8ccf:	83 c4 10             	add    $0x10,%esp
    8cd2:	c9                   	leave  
    8cd3:	c3                   	ret    

00008cd4 <puti>:
{
    8cd4:	55                   	push   %ebp
    8cd5:	e8 d5 00 00 00       	call   8daf <__x86.get_pc_thunk.ax>
    8cda:	05 d2 05 00 00       	add    $0x5d2,%eax
    8cdf:	89 e5                	mov    %esp,%ebp
    8ce1:	53                   	push   %ebx
	itoh (i, puti_str);
    8ce2:	8d 98 b4 00 00 00    	lea    0xb4(%eax),%ebx
    8ce8:	53                   	push   %ebx
    8ce9:	ff 75 08             	pushl  0x8(%ebp)
    8cec:	e8 bd ff ff ff       	call   8cae <itoh>
	putline (puti_str);
    8cf1:	58                   	pop    %eax
    8cf2:	5a                   	pop    %edx
    8cf3:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
    8cf6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    8cf9:	c9                   	leave  
	putline (puti_str);
    8cfa:	e9 6c fe ff ff       	jmp    8b6b <putline>

00008cff <readsector>:
		/* do nothing */;
}

void
readsector (void *dst, uint32_t offset)
{
    8cff:	55                   	push   %ebp
    8d00:	89 e5                	mov    %esp,%ebp
    8d02:	57                   	push   %edi

static inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
    8d03:	bf f7 01 00 00       	mov    $0x1f7,%edi
    8d08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    8d0b:	89 fa                	mov    %edi,%edx
    8d0d:	ec                   	in     (%dx),%al
	while ((inb (0x1F7) & 0xC0) != 0x40)
    8d0e:	83 e0 c0             	and    $0xffffffc0,%eax
    8d11:	3c 40                	cmp    $0x40,%al
    8d13:	75 f6                	jne    8d0b <readsector+0xc>
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
    8d15:	b0 01                	mov    $0x1,%al
    8d17:	ba f2 01 00 00       	mov    $0x1f2,%edx
    8d1c:	ee                   	out    %al,(%dx)
    8d1d:	ba f3 01 00 00       	mov    $0x1f3,%edx
    8d22:	88 c8                	mov    %cl,%al
    8d24:	ee                   	out    %al,(%dx)
	// wait for disk to be ready
	waitdisk ();

	outb (0x1F2, 1);		// count = 1
	outb (0x1F3, offset);
	outb (0x1F4, offset >> 8);
    8d25:	89 c8                	mov    %ecx,%eax
    8d27:	ba f4 01 00 00       	mov    $0x1f4,%edx
    8d2c:	c1 e8 08             	shr    $0x8,%eax
    8d2f:	ee                   	out    %al,(%dx)
	outb (0x1F5, offset >> 16);
    8d30:	89 c8                	mov    %ecx,%eax
    8d32:	ba f5 01 00 00       	mov    $0x1f5,%edx
    8d37:	c1 e8 10             	shr    $0x10,%eax
    8d3a:	ee                   	out    %al,(%dx)
	outb (0x1F6, (offset >> 24) | 0xE0);
    8d3b:	89 c8                	mov    %ecx,%eax
    8d3d:	ba f6 01 00 00       	mov    $0x1f6,%edx
    8d42:	c1 e8 18             	shr    $0x18,%eax
    8d45:	83 c8 e0             	or     $0xffffffe0,%eax
    8d48:	ee                   	out    %al,(%dx)
    8d49:	b0 20                	mov    $0x20,%al
    8d4b:	89 fa                	mov    %edi,%edx
    8d4d:	ee                   	out    %al,(%dx)
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
    8d4e:	ba f7 01 00 00       	mov    $0x1f7,%edx
    8d53:	ec                   	in     (%dx),%al
	while ((inb (0x1F7) & 0xC0) != 0x40)
    8d54:	83 e0 c0             	and    $0xffffffc0,%eax
    8d57:	3c 40                	cmp    $0x40,%al
    8d59:	75 f8                	jne    8d53 <readsector+0x54>
}

static inline void
insl(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsl"			:
    8d5b:	8b 7d 08             	mov    0x8(%ebp),%edi
    8d5e:	b9 80 00 00 00       	mov    $0x80,%ecx
    8d63:	ba f0 01 00 00       	mov    $0x1f0,%edx
    8d68:	fc                   	cld    
    8d69:	f2 6d                	repnz insl (%dx),%es:(%edi)
	// wait for disk to be ready
	waitdisk ();

	// read a sector
	insl (0x1F0, dst, SECTOR_SIZE / 4);
}
    8d6b:	5f                   	pop    %edi
    8d6c:	5d                   	pop    %ebp
    8d6d:	c3                   	ret    

00008d6e <readsection>:

// Read 'count' bytes at 'offset' from kernel into virtual address 'va'.
// Might copy more than asked
void
readsection (uint32_t va, uint32_t count, uint32_t offset, uint32_t lba)
{
    8d6e:	55                   	push   %ebp
    8d6f:	89 e5                	mov    %esp,%ebp
    8d71:	57                   	push   %edi
    8d72:	56                   	push   %esi
    8d73:	53                   	push   %ebx
    8d74:	8b 5d 08             	mov    0x8(%ebp),%ebx
	end_va = va + count;
	// round down to sector boundary
	va &= ~(SECTOR_SIZE - 1);

	// translate from bytes to sectors, and kernel starts at sector 1
	offset = (offset / SECTOR_SIZE) + lba;
    8d77:	8b 7d 10             	mov    0x10(%ebp),%edi
	va &= 0xFFFFFF;
    8d7a:	89 de                	mov    %ebx,%esi
	va &= ~(SECTOR_SIZE - 1);
    8d7c:	81 e3 00 fe ff 00    	and    $0xfffe00,%ebx
	va &= 0xFFFFFF;
    8d82:	81 e6 ff ff ff 00    	and    $0xffffff,%esi
	offset = (offset / SECTOR_SIZE) + lba;
    8d88:	c1 ef 09             	shr    $0x9,%edi
	end_va = va + count;
    8d8b:	03 75 0c             	add    0xc(%ebp),%esi
	offset = (offset / SECTOR_SIZE) + lba;
    8d8e:	03 7d 14             	add    0x14(%ebp),%edi

	// If this is too slow, we could read lots of sectors at a time.
	// We'd write more to memory than asked, but it doesn't matter --
	// we load in increasing order.
	while (va < end_va)
    8d91:	39 f3                	cmp    %esi,%ebx
    8d93:	73 12                	jae    8da7 <readsection+0x39>
	{
		readsector ((uint8_t*) va, offset);
    8d95:	57                   	push   %edi
    8d96:	53                   	push   %ebx
		va += SECTOR_SIZE;
		offset++;
    8d97:	47                   	inc    %edi
		va += SECTOR_SIZE;
    8d98:	81 c3 00 02 00 00    	add    $0x200,%ebx
		readsector ((uint8_t*) va, offset);
    8d9e:	e8 5c ff ff ff       	call   8cff <readsector>
		offset++;
    8da3:	58                   	pop    %eax
    8da4:	5a                   	pop    %edx
    8da5:	eb ea                	jmp    8d91 <readsection+0x23>
	}
}
    8da7:	8d 65 f4             	lea    -0xc(%ebp),%esp
    8daa:	5b                   	pop    %ebx
    8dab:	5e                   	pop    %esi
    8dac:	5f                   	pop    %edi
    8dad:	5d                   	pop    %ebp
    8dae:	c3                   	ret    

00008daf <__x86.get_pc_thunk.ax>:
    8daf:	8b 04 24             	mov    (%esp),%eax
    8db2:	c3                   	ret    

00008db3 <__x86.get_pc_thunk.dx>:
    8db3:	8b 14 24             	mov    (%esp),%edx
    8db6:	c3                   	ret    

00008db7 <load_kernel>:

#define ELFHDR      ((elfhdr *) 0x20000)

uint32_t
load_kernel(uint32_t dkernel) // dkernel is the first_lba field of the partition table entry of the bootable partition
{
    8db7:	55                   	push   %ebp
    8db8:	89 e5                	mov    %esp,%ebp
    8dba:	57                   	push   %edi
    8dbb:	56                   	push   %esi
    8dbc:	53                   	push   %ebx
    8dbd:	e8 83 01 00 00       	call   8f45 <__x86.get_pc_thunk.bx>
    8dc2:	81 c3 ea 04 00 00    	add    $0x4ea,%ebx
    8dc8:	83 ec 0c             	sub    $0xc,%esp
    // load kernel from the beginning of the first bootable partition
    proghdr *ph, *eph;

    readsection((uint32_t) ELFHDR, SECTOR_SIZE * 8, 0, dkernel);
    8dcb:	ff 75 08             	pushl  0x8(%ebp)
    8dce:	6a 00                	push   $0x0
    8dd0:	68 00 10 00 00       	push   $0x1000
    8dd5:	68 00 00 02 00       	push   $0x20000
    8dda:	e8 8f ff ff ff       	call   8d6e <readsection>

    // is this a valid ELF?
    if (ELFHDR->e_magic != ELF_MAGIC)
    8ddf:	83 c4 10             	add    $0x10,%esp
    8de2:	81 3d 00 00 02 00 7f 	cmpl   $0x464c457f,0x20000
    8de9:	45 4c 46 
    8dec:	74 12                	je     8e00 <load_kernel+0x49>
        panic ("Kernel is not a valid elf.");
    8dee:	8d 83 fe fc ff ff    	lea    -0x302(%ebx),%eax
    8df4:	83 ec 0c             	sub    $0xc,%esp
    8df7:	50                   	push   %eax
    8df8:	e8 d0 fd ff ff       	call   8bcd <panic>
    8dfd:	83 c4 10             	add    $0x10,%esp

    // load each program segment (ignores ph flags)
    ph = (proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
    8e00:	a1 1c 00 02 00       	mov    0x2001c,%eax
    eph = ph + ELFHDR->e_phnum;
    8e05:	0f b7 35 2c 00 02 00 	movzwl 0x2002c,%esi
    ph = (proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
    8e0c:	8d b8 00 00 02 00    	lea    0x20000(%eax),%edi
    eph = ph + ELFHDR->e_phnum;
    8e12:	c1 e6 05             	shl    $0x5,%esi
    8e15:	01 fe                	add    %edi,%esi

    for (; ph < eph; ph++)
    8e17:	39 f7                	cmp    %esi,%edi
    8e19:	73 19                	jae    8e34 <load_kernel+0x7d>
    {
        readsection(ph->p_va, ph->p_memsz, ph->p_offset, dkernel);
    8e1b:	ff 75 08             	pushl  0x8(%ebp)
    8e1e:	ff 77 04             	pushl  0x4(%edi)
    for (; ph < eph; ph++)
    8e21:	83 c7 20             	add    $0x20,%edi
        readsection(ph->p_va, ph->p_memsz, ph->p_offset, dkernel);
    8e24:	ff 77 f4             	pushl  -0xc(%edi)
    8e27:	ff 77 e8             	pushl  -0x18(%edi)
    8e2a:	e8 3f ff ff ff       	call   8d6e <readsection>
    for (; ph < eph; ph++)
    8e2f:	83 c4 10             	add    $0x10,%esp
    8e32:	eb e3                	jmp    8e17 <load_kernel+0x60>
    }

    return (ELFHDR->e_entry & 0xFFFFFF);
    8e34:	a1 18 00 02 00       	mov    0x20018,%eax
}
    8e39:	8d 65 f4             	lea    -0xc(%ebp),%esp
    8e3c:	5b                   	pop    %ebx
    return (ELFHDR->e_entry & 0xFFFFFF);
    8e3d:	25 ff ff ff 00       	and    $0xffffff,%eax
}
    8e42:	5e                   	pop    %esi
    8e43:	5f                   	pop    %edi
    8e44:	5d                   	pop    %ebp
    8e45:	c3                   	ret    

00008e46 <parse_e820>:

mboot_info_t *
parse_e820 (bios_smap_t *smap)
{
    8e46:	55                   	push   %ebp
    8e47:	89 e5                	mov    %esp,%ebp
    8e49:	57                   	push   %edi
    8e4a:	56                   	push   %esi
    8e4b:	53                   	push   %ebx
    bios_smap_t *p;
    uint32_t mmap_len;
    p = smap;
    mmap_len = 0;
    8e4c:	31 f6                	xor    %esi,%esi
    8e4e:	e8 f2 00 00 00       	call   8f45 <__x86.get_pc_thunk.bx>
    8e53:	81 c3 59 04 00 00    	add    $0x459,%ebx
{
    8e59:	83 ec 18             	sub    $0x18,%esp
    8e5c:	8b 7d 08             	mov    0x8(%ebp),%edi
    putline ("* E820 Memory Map *");
    8e5f:	8d 83 19 fd ff ff    	lea    -0x2e7(%ebx),%eax
    8e65:	50                   	push   %eax
    8e66:	e8 00 fd ff ff       	call   8b6b <putline>
    while (p->base_addr != 0 || p->length != 0 || p->type != 0)
    8e6b:	83 c4 10             	add    $0x10,%esp
    8e6e:	8b 44 37 04          	mov    0x4(%edi,%esi,1),%eax
    8e72:	89 c1                	mov    %eax,%ecx
    8e74:	0b 4c 37 08          	or     0x8(%edi,%esi,1),%ecx
    8e78:	74 11                	je     8e8b <parse_e820+0x45>
    {
        puti (p->base_addr);
    8e7a:	83 ec 0c             	sub    $0xc,%esp
        p ++;
        mmap_len += sizeof(bios_smap_t);
    8e7d:	83 c6 18             	add    $0x18,%esi
        puti (p->base_addr);
    8e80:	50                   	push   %eax
    8e81:	e8 4e fe ff ff       	call   8cd4 <puti>
        mmap_len += sizeof(bios_smap_t);
    8e86:	83 c4 10             	add    $0x10,%esp
    8e89:	eb e3                	jmp    8e6e <parse_e820+0x28>
    while (p->base_addr != 0 || p->length != 0 || p->type != 0)
    8e8b:	8b 54 37 10          	mov    0x10(%edi,%esi,1),%edx
    8e8f:	0b 54 37 0c          	or     0xc(%edi,%esi,1),%edx
    8e93:	75 e5                	jne    8e7a <parse_e820+0x34>
    8e95:	83 7c 37 14 00       	cmpl   $0x0,0x14(%edi,%esi,1)
    8e9a:	75 de                	jne    8e7a <parse_e820+0x34>
    }
    mboot_info.mmap_length = mmap_len;
    8e9c:	89 b3 80 00 00 00    	mov    %esi,0x80(%ebx)
    mboot_info.mmap_addr = (uint32_t) smap;
    8ea2:	89 bb 84 00 00 00    	mov    %edi,0x84(%ebx)
    return &mboot_info;
    8ea8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    8eab:	8d 83 54 00 00 00    	lea    0x54(%ebx),%eax
    8eb1:	5b                   	pop    %ebx
    8eb2:	5e                   	pop    %esi
    8eb3:	5f                   	pop    %edi
    8eb4:	5d                   	pop    %ebp
    8eb5:	c3                   	ret    

00008eb6 <boot1main>:
{
    8eb6:	55                   	push   %ebp
    8eb7:	89 e5                	mov    %esp,%ebp
    8eb9:	57                   	push   %edi
    8eba:	56                   	push   %esi
    8ebb:	53                   	push   %ebx
    for(int m = 0; m < 4; m++){//4 entries
    8ebc:	31 f6                	xor    %esi,%esi
    8ebe:	e8 82 00 00 00       	call   8f45 <__x86.get_pc_thunk.bx>
    8ec3:	81 c3 e9 03 00 00    	add    $0x3e9,%ebx
{
    8ec9:	83 ec 18             	sub    $0x18,%esp
    8ecc:	8b 7d 08             	mov    0x8(%ebp),%edi
    roll(10);
    8ecf:	6a 0a                	push   $0xa
    8ed1:	e8 df fc ff ff       	call   8bb5 <roll>
    putline("Start boot1 main ...");
    8ed6:	8d 83 2d fd ff ff    	lea    -0x2d3(%ebx),%eax
    8edc:	89 04 24             	mov    %eax,(%esp)
    8edf:	e8 87 fc ff ff       	call   8b6b <putline>
    8ee4:	83 c4 10             	add    $0x10,%esp
        if(mbr->partition[m].bootable != BOOTABLE_PARTITION) {
    8ee7:	89 f0                	mov    %esi,%eax
    8ee9:	c1 e0 04             	shl    $0x4,%eax
    8eec:	80 bc 07 be 01 00 00 	cmpb   $0x80,0x1be(%edi,%eax,1)
    8ef3:	80 
    8ef4:	75 2f                	jne    8f25 <boot1main+0x6f>
            parse_e820(smap);//parse the mem map
    8ef6:	83 ec 0c             	sub    $0xc,%esp
    8ef9:	ff 75 0c             	pushl  0xc(%ebp)
            exec_kernel(load_kernel(mbr->partition[m].first_lba), &mboot_info);//prepare the parameter then execute the kernel with the right parameters
    8efc:	83 c6 1b             	add    $0x1b,%esi
    8eff:	c1 e6 04             	shl    $0x4,%esi
            parse_e820(smap);//parse the mem map
    8f02:	e8 3f ff ff ff       	call   8e46 <parse_e820>
            exec_kernel(load_kernel(mbr->partition[m].first_lba), &mboot_info);//prepare the parameter then execute the kernel with the right parameters
    8f07:	58                   	pop    %eax
    8f08:	ff 74 37 16          	pushl  0x16(%edi,%esi,1)
    8f0c:	e8 a6 fe ff ff       	call   8db7 <load_kernel>
    8f11:	5a                   	pop    %edx
    8f12:	8d 93 54 00 00 00    	lea    0x54(%ebx),%edx
    8f18:	59                   	pop    %ecx
    8f19:	52                   	push   %edx
    8f1a:	50                   	push   %eax
    8f1b:	e8 29 00 00 00       	call   8f49 <exec_kernel>
            break;//If the bootable field of a partition is equal to BOOTABLE_PARTITION, then it is bootable.
    8f20:	83 c4 10             	add    $0x10,%esp
    8f23:	eb 06                	jmp    8f2b <boot1main+0x75>
    for(int m = 0; m < 4; m++){//4 entries
    8f25:	46                   	inc    %esi
    8f26:	83 fe 04             	cmp    $0x4,%esi
    8f29:	75 bc                	jne    8ee7 <boot1main+0x31>
    panic ("Fail to load kernel.");
    8f2b:	8d 83 42 fd ff ff    	lea    -0x2be(%ebx),%eax
    8f31:	83 ec 0c             	sub    $0xc,%esp
    8f34:	50                   	push   %eax
    8f35:	e8 93 fc ff ff       	call   8bcd <panic>
}
    8f3a:	83 c4 10             	add    $0x10,%esp
    8f3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    8f40:	5b                   	pop    %ebx
    8f41:	5e                   	pop    %esi
    8f42:	5f                   	pop    %edi
    8f43:	5d                   	pop    %ebp
    8f44:	c3                   	ret    

00008f45 <__x86.get_pc_thunk.bx>:
    8f45:	8b 1c 24             	mov    (%esp),%ebx
    8f48:	c3                   	ret    

00008f49 <exec_kernel>:
	.set  MBOOT_INFO_MAGIC, 0x2badb002

	.globl	exec_kernel
	.code32
exec_kernel:
	cli
    8f49:	fa                   	cli    
	movl	$MBOOT_INFO_MAGIC, %eax
    8f4a:	b8 02 b0 ad 2b       	mov    $0x2badb002,%eax
	movl	8(%esp), %ebx
    8f4f:	8b 5c 24 08          	mov    0x8(%esp),%ebx
	movl	4(%esp), %edx
    8f53:	8b 54 24 04          	mov    0x4(%esp),%edx
	jmp	*%edx
    8f57:	ff e2                	jmp    *%edx

Disassembly of section .rodata:

00008f59 <.rodata>:
    8f59:	20 20                	and    %ah,(%eax)
    8f5b:	20 20                	and    %ah,(%eax)
    8f5d:	20 20                	and    %ah,(%eax)
    8f5f:	20 20                	and    %ah,(%eax)
    8f61:	20 20                	and    %ah,(%eax)
    8f63:	20 20                	and    %ah,(%eax)
    8f65:	20 20                	and    %ah,(%eax)
    8f67:	20 20                	and    %ah,(%eax)
    8f69:	20 20                	and    %ah,(%eax)
    8f6b:	20 20                	and    %ah,(%eax)
    8f6d:	20 20                	and    %ah,(%eax)
    8f6f:	20 20                	and    %ah,(%eax)
    8f71:	20 20                	and    %ah,(%eax)
    8f73:	20 20                	and    %ah,(%eax)
    8f75:	20 20                	and    %ah,(%eax)
    8f77:	20 20                	and    %ah,(%eax)
    8f79:	20 20                	and    %ah,(%eax)
    8f7b:	20 20                	and    %ah,(%eax)
    8f7d:	20 20                	and    %ah,(%eax)
    8f7f:	20 20                	and    %ah,(%eax)
    8f81:	20 20                	and    %ah,(%eax)
    8f83:	20 20                	and    %ah,(%eax)
    8f85:	20 20                	and    %ah,(%eax)
    8f87:	20 20                	and    %ah,(%eax)
    8f89:	20 20                	and    %ah,(%eax)
    8f8b:	20 20                	and    %ah,(%eax)
    8f8d:	20 20                	and    %ah,(%eax)
    8f8f:	20 20                	and    %ah,(%eax)
    8f91:	20 20                	and    %ah,(%eax)
    8f93:	20 20                	and    %ah,(%eax)
    8f95:	20 20                	and    %ah,(%eax)
    8f97:	20 20                	and    %ah,(%eax)
    8f99:	20 20                	and    %ah,(%eax)
    8f9b:	20 20                	and    %ah,(%eax)
    8f9d:	20 20                	and    %ah,(%eax)
    8f9f:	20 20                	and    %ah,(%eax)
    8fa1:	20 20                	and    %ah,(%eax)
    8fa3:	20 20                	and    %ah,(%eax)
    8fa5:	20 20                	and    %ah,(%eax)
    8fa7:	20 20                	and    %ah,(%eax)
    8fa9:	00 4b 65             	add    %cl,0x65(%ebx)
    8fac:	72 6e                	jb     901c <exec_kernel+0xd3>
    8fae:	65 6c                	gs insb (%dx),%es:(%edi)
    8fb0:	20 69 73             	and    %ch,0x73(%ecx)
    8fb3:	20 6e 6f             	and    %ch,0x6f(%esi)
    8fb6:	74 20                	je     8fd8 <exec_kernel+0x8f>
    8fb8:	61                   	popa   
    8fb9:	20 76 61             	and    %dh,0x61(%esi)
    8fbc:	6c                   	insb   (%dx),%es:(%edi)
    8fbd:	69 64 20 65 6c 66 2e 	imul   $0x2e666c,0x65(%eax,%eiz,1),%esp
    8fc4:	00 
    8fc5:	2a 20                	sub    (%eax),%ah
    8fc7:	45                   	inc    %ebp
    8fc8:	38 32                	cmp    %dh,(%edx)
    8fca:	30 20                	xor    %ah,(%eax)
    8fcc:	4d                   	dec    %ebp
    8fcd:	65 6d                	gs insl (%dx),%es:(%edi)
    8fcf:	6f                   	outsl  %ds:(%esi),(%dx)
    8fd0:	72 79                	jb     904b <exec_kernel+0x102>
    8fd2:	20 4d 61             	and    %cl,0x61(%ebp)
    8fd5:	70 20                	jo     8ff7 <exec_kernel+0xae>
    8fd7:	2a 00                	sub    (%eax),%al
    8fd9:	53                   	push   %ebx
    8fda:	74 61                	je     903d <exec_kernel+0xf4>
    8fdc:	72 74                	jb     9052 <exec_kernel+0x109>
    8fde:	20 62 6f             	and    %ah,0x6f(%edx)
    8fe1:	6f                   	outsl  %ds:(%esi),(%dx)
    8fe2:	74 31                	je     9015 <exec_kernel+0xcc>
    8fe4:	20 6d 61             	and    %ch,0x61(%ebp)
    8fe7:	69 6e 20 2e 2e 2e 00 	imul   $0x2e2e2e,0x20(%esi),%ebp
    8fee:	46                   	inc    %esi
    8fef:	61                   	popa   
    8ff0:	69 6c 20 74 6f 20 6c 	imul   $0x6f6c206f,0x74(%eax,%eiz,1),%ebp
    8ff7:	6f 
    8ff8:	61                   	popa   
    8ff9:	64 20 6b 65          	and    %ch,%fs:0x65(%ebx)
    8ffd:	72 6e                	jb     906d <exec_kernel+0x124>
    8fff:	65 6c                	gs insb (%dx),%es:(%edi)
    9001:	2e                   	cs
    9002:	00                   	.byte 0x0

Disassembly of section .eh_frame:

00009004 <.eh_frame>:
    9004:	14 00                	adc    $0x0,%al
    9006:	00 00                	add    %al,(%eax)
    9008:	00 00                	add    %al,(%eax)
    900a:	00 00                	add    %al,(%eax)
    900c:	01 7a 52             	add    %edi,0x52(%edx)
    900f:	00 01                	add    %al,(%ecx)
    9011:	7c 08                	jl     901b <exec_kernel+0xd2>
    9013:	01 1b                	add    %ebx,(%ebx)
    9015:	0c 04                	or     $0x4,%al
    9017:	04 88                	add    $0x88,%al
    9019:	01 00                	add    %eax,(%eax)
    901b:	00 1c 00             	add    %bl,(%eax,%eax,1)
    901e:	00 00                	add    %al,(%eax)
    9020:	1c 00                	sbb    $0x0,%al
    9022:	00 00                	add    %al,(%eax)
    9024:	ea fa ff ff 26 00 00 	ljmp   $0x0,$0x26fffffa
    902b:	00 00                	add    %al,(%eax)
    902d:	41                   	inc    %ecx
    902e:	0e                   	push   %cs
    902f:	08 85 02 4d 0d 05    	or     %al,0x50d4d02(%ebp)
    9035:	57                   	push   %edi
    9036:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    9039:	04 00                	add    $0x0,%al
    903b:	00 24 00             	add    %ah,(%eax,%eax,1)
    903e:	00 00                	add    %al,(%eax)
    9040:	3c 00                	cmp    $0x0,%al
    9042:	00 00                	add    %al,(%eax)
    9044:	f0 fa                	lock cli 
    9046:	ff                   	(bad)  
    9047:	ff 37                	pushl  (%edi)
    9049:	00 00                	add    %al,(%eax)
    904b:	00 00                	add    %al,(%eax)
    904d:	41                   	inc    %ecx
    904e:	0e                   	push   %cs
    904f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    9055:	42                   	inc    %edx
    9056:	86 03                	xchg   %al,(%ebx)
    9058:	83 04 6f c3          	addl   $0xffffffc3,(%edi,%ebp,2)
    905c:	41                   	inc    %ecx
    905d:	c6 41 c5 0c          	movb   $0xc,-0x3b(%ecx)
    9061:	04 04                	add    $0x4,%al
    9063:	00 20                	add    %ah,(%eax)
    9065:	00 00                	add    %al,(%eax)
    9067:	00 64 00 00          	add    %ah,0x0(%eax,%eax,1)
    906b:	00 ff                	add    %bh,%bh
    906d:	fa                   	cli    
    906e:	ff                   	(bad)  
    906f:	ff 4a 00             	decl   0x0(%edx)
    9072:	00 00                	add    %al,(%eax)
    9074:	00 4b 0e             	add    %cl,0xe(%ebx)
    9077:	08 85 02 4e 0d 05    	or     %al,0x50d4e02(%ebp)
    907d:	41                   	inc    %ecx
    907e:	83 03 6f             	addl   $0x6f,(%ebx)
    9081:	c5 c3 0c             	(bad)  
    9084:	04 04                	add    $0x4,%al
    9086:	00 00                	add    %al,(%eax)
    9088:	1c 00                	sbb    $0x0,%al
    908a:	00 00                	add    %al,(%eax)
    908c:	88 00                	mov    %al,(%eax)
    908e:	00 00                	add    %al,(%eax)
    9090:	25 fb ff ff 18       	and    $0x18fffffb,%eax
    9095:	00 00                	add    %al,(%eax)
    9097:	00 00                	add    %al,(%eax)
    9099:	41                   	inc    %ecx
    909a:	0e                   	push   %cs
    909b:	08 85 02 4c 0d 05    	or     %al,0x50d4c02(%ebp)
    90a1:	44                   	inc    %esp
    90a2:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    90a5:	04 00                	add    $0x0,%al
    90a7:	00 18                	add    %bl,(%eax)
    90a9:	00 00                	add    %al,(%eax)
    90ab:	00 a8 00 00 00 1d    	add    %ch,0x1d000000(%eax)
    90b1:	fb                   	sti    
    90b2:	ff                   	(bad)  
    90b3:	ff 17                	call   *(%edi)
    90b5:	00 00                	add    %al,(%eax)
    90b7:	00 00                	add    %al,(%eax)
    90b9:	41                   	inc    %ecx
    90ba:	0e                   	push   %cs
    90bb:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    90c1:	00 00                	add    %al,(%eax)
    90c3:	00 1c 00             	add    %bl,(%eax,%eax,1)
    90c6:	00 00                	add    %al,(%eax)
    90c8:	c4 00                	les    (%eax),%eax
    90ca:	00 00                	add    %al,(%eax)
    90cc:	18 fb                	sbb    %bh,%bl
    90ce:	ff                   	(bad)  
    90cf:	ff 13                	call   *(%ebx)
    90d1:	00 00                	add    %al,(%eax)
    90d3:	00 00                	add    %al,(%eax)
    90d5:	41                   	inc    %ecx
    90d6:	0e                   	push   %cs
    90d7:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
    90dd:	4d                   	dec    %ebp
    90de:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    90e1:	04 00                	add    $0x0,%al
    90e3:	00 24 00             	add    %ah,(%eax,%eax,1)
    90e6:	00 00                	add    %al,(%eax)
    90e8:	e4 00                	in     $0x0,%al
    90ea:	00 00                	add    %al,(%eax)
    90ec:	0b fb                	or     %ebx,%edi
    90ee:	ff                   	(bad)  
    90ef:	ff 30                	pushl  (%eax)
    90f1:	00 00                	add    %al,(%eax)
    90f3:	00 00                	add    %al,(%eax)
    90f5:	41                   	inc    %ecx
    90f6:	0e                   	push   %cs
    90f7:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    90fd:	42                   	inc    %edx
    90fe:	86 03                	xchg   %al,(%ebx)
    9100:	83 04 68 c3          	addl   $0xffffffc3,(%eax,%ebp,2)
    9104:	41                   	inc    %ecx
    9105:	c6 41 c5 0c          	movb   $0xc,-0x3b(%ecx)
    9109:	04 04                	add    $0x4,%al
    910b:	00 28                	add    %ch,(%eax)
    910d:	00 00                	add    %al,(%eax)
    910f:	00 0c 01             	add    %cl,(%ecx,%eax,1)
    9112:	00 00                	add    %al,(%eax)
    9114:	13 fb                	adc    %ebx,%edi
    9116:	ff                   	(bad)  
    9117:	ff 61 00             	jmp    *0x0(%ecx)
    911a:	00 00                	add    %al,(%eax)
    911c:	00 41 0e             	add    %al,0xe(%ecx)
    911f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    9125:	43                   	inc    %ebx
    9126:	87 03                	xchg   %eax,(%ebx)
    9128:	86 04 83             	xchg   %al,(%ebx,%eax,4)
    912b:	05 02 53 c3 41       	add    $0x41c35302,%eax
    9130:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
    9134:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    9137:	04 1c                	add    $0x1c,%al
    9139:	00 00                	add    %al,(%eax)
    913b:	00 38                	add    %bh,(%eax)
    913d:	01 00                	add    %eax,(%eax)
    913f:	00 48 fb             	add    %cl,-0x5(%eax)
    9142:	ff                   	(bad)  
    9143:	ff 26                	jmp    *(%esi)
    9145:	00 00                	add    %al,(%eax)
    9147:	00 00                	add    %al,(%eax)
    9149:	4b                   	dec    %ebx
    914a:	0e                   	push   %cs
    914b:	08 85 02 48 0d 05    	or     %al,0x50d4802(%ebp)
    9151:	52                   	push   %edx
    9152:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    9155:	04 00                	add    $0x0,%al
    9157:	00 1c 00             	add    %bl,(%eax,%eax,1)
    915a:	00 00                	add    %al,(%eax)
    915c:	58                   	pop    %eax
    915d:	01 00                	add    %eax,(%eax)
    915f:	00 4e fb             	add    %cl,-0x5(%esi)
    9162:	ff                   	(bad)  
    9163:	ff 26                	jmp    *(%esi)
    9165:	00 00                	add    %al,(%eax)
    9167:	00 00                	add    %al,(%eax)
    9169:	4b                   	dec    %ebx
    916a:	0e                   	push   %cs
    916b:	08 85 02 48 0d 05    	or     %al,0x50d4802(%ebp)
    9171:	52                   	push   %edx
    9172:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    9175:	04 00                	add    $0x0,%al
    9177:	00 20                	add    %ah,(%eax)
    9179:	00 00                	add    %al,(%eax)
    917b:	00 78 01             	add    %bh,0x1(%eax)
    917e:	00 00                	add    %al,(%eax)
    9180:	54                   	push   %esp
    9181:	fb                   	sti    
    9182:	ff                   	(bad)  
    9183:	ff 2b                	ljmp   *(%ebx)
    9185:	00 00                	add    %al,(%eax)
    9187:	00 00                	add    %al,(%eax)
    9189:	41                   	inc    %ecx
    918a:	0e                   	push   %cs
    918b:	08 85 02 4c 0d 05    	or     %al,0x50d4c02(%ebp)
    9191:	41                   	inc    %ecx
    9192:	83 03 58             	addl   $0x58,(%ebx)
    9195:	c5 c3 0c             	(bad)  
    9198:	04 04                	add    $0x4,%al
    919a:	00 00                	add    %al,(%eax)
    919c:	20 00                	and    %al,(%eax)
    919e:	00 00                	add    %al,(%eax)
    91a0:	9c                   	pushf  
    91a1:	01 00                	add    %eax,(%eax)
    91a3:	00 5b fb             	add    %bl,-0x5(%ebx)
    91a6:	ff                   	(bad)  
    91a7:	ff 6f 00             	ljmp   *0x0(%edi)
    91aa:	00 00                	add    %al,(%eax)
    91ac:	00 41 0e             	add    %al,0xe(%ecx)
    91af:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    91b5:	41                   	inc    %ecx
    91b6:	87 03                	xchg   %eax,(%ebx)
    91b8:	02 69 c7             	add    -0x39(%ecx),%ch
    91bb:	41                   	inc    %ecx
    91bc:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    91bf:	04 28                	add    $0x28,%al
    91c1:	00 00                	add    %al,(%eax)
    91c3:	00 c0                	add    %al,%al
    91c5:	01 00                	add    %eax,(%eax)
    91c7:	00 a6 fb ff ff 41    	add    %ah,0x41fffffb(%esi)
    91cd:	00 00                	add    %al,(%eax)
    91cf:	00 00                	add    %al,(%eax)
    91d1:	41                   	inc    %ecx
    91d2:	0e                   	push   %cs
    91d3:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    91d9:	43                   	inc    %ebx
    91da:	87 03                	xchg   %eax,(%ebx)
    91dc:	86 04 83             	xchg   %al,(%ebx,%eax,4)
    91df:	05 77 c3 41 c6       	add    $0xc641c377,%eax
    91e4:	41                   	inc    %ecx
    91e5:	c7 41 c5 0c 04 04 00 	movl   $0x4040c,-0x3b(%ecx)
    91ec:	10 00                	adc    %al,(%eax)
    91ee:	00 00                	add    %al,(%eax)
    91f0:	ec                   	in     (%dx),%al
    91f1:	01 00                	add    %eax,(%eax)
    91f3:	00 bb fb ff ff 04    	add    %bh,0x4fffffb(%ebx)
    91f9:	00 00                	add    %al,(%eax)
    91fb:	00 00                	add    %al,(%eax)
    91fd:	00 00                	add    %al,(%eax)
    91ff:	00 10                	add    %dl,(%eax)
    9201:	00 00                	add    %al,(%eax)
    9203:	00 00                	add    %al,(%eax)
    9205:	02 00                	add    (%eax),%al
    9207:	00 ab fb ff ff 04    	add    %ch,0x4fffffb(%ebx)
    920d:	00 00                	add    %al,(%eax)
    920f:	00 00                	add    %al,(%eax)
    9211:	00 00                	add    %al,(%eax)
    9213:	00 28                	add    %ch,(%eax)
    9215:	00 00                	add    %al,(%eax)
    9217:	00 14 02             	add    %dl,(%edx,%eax,1)
    921a:	00 00                	add    %al,(%eax)
    921c:	9b                   	fwait
    921d:	fb                   	sti    
    921e:	ff                   	(bad)  
    921f:	ff 8f 00 00 00 00    	decl   0x0(%edi)
    9225:	41                   	inc    %ecx
    9226:	0e                   	push   %cs
    9227:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    922d:	43                   	inc    %ebx
    922e:	87 03                	xchg   %eax,(%ebx)
    9230:	86 04 83             	xchg   %al,(%ebx,%eax,4)
    9233:	05 02 80 c3 46       	add    $0x46c38002,%eax
    9238:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
    923c:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    923f:	04 28                	add    $0x28,%al
    9241:	00 00                	add    %al,(%eax)
    9243:	00 40 02             	add    %al,0x2(%eax)
    9246:	00 00                	add    %al,(%eax)
    9248:	fe                   	(bad)  
    9249:	fb                   	sti    
    924a:	ff                   	(bad)  
    924b:	ff 70 00             	pushl  0x0(%eax)
    924e:	00 00                	add    %al,(%eax)
    9250:	00 41 0e             	add    %al,0xe(%ecx)
    9253:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    9259:	43                   	inc    %ebx
    925a:	87 03                	xchg   %eax,(%ebx)
    925c:	86 04 83             	xchg   %al,(%ebx,%eax,4)
    925f:	05 02 66 c3 41       	add    $0x41c36602,%eax
    9264:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
    9268:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    926b:	04 28                	add    $0x28,%al
    926d:	00 00                	add    %al,(%eax)
    926f:	00 6c 02 00          	add    %ch,0x0(%edx,%eax,1)
    9273:	00 42 fc             	add    %al,-0x4(%edx)
    9276:	ff                   	(bad)  
    9277:	ff 8f 00 00 00 00    	decl   0x0(%edi)
    927d:	41                   	inc    %ecx
    927e:	0e                   	push   %cs
    927f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    9285:	43                   	inc    %ebx
    9286:	87 03                	xchg   %eax,(%ebx)
    9288:	86 04 83             	xchg   %al,(%ebx,%eax,4)
    928b:	05 02 85 c3 41       	add    $0x41c38502,%eax
    9290:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
    9294:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    9297:	04 10                	add    $0x10,%al
    9299:	00 00                	add    %al,(%eax)
    929b:	00 98 02 00 00 a5    	add    %bl,-0x5afffffe(%eax)
    92a1:	fc                   	cld    
    92a2:	ff                   	(bad)  
    92a3:	ff 04 00             	incl   (%eax,%eax,1)
    92a6:	00 00                	add    %al,(%eax)
    92a8:	00 00                	add    %al,(%eax)
    92aa:	00 00                	add    %al,(%eax)

Disassembly of section .got.plt:

000092ac <_GLOBAL_OFFSET_TABLE_>:
    92ac:	00 00                	add    %al,(%eax)
    92ae:	00 00                	add    %al,(%eax)
    92b0:	00 00                	add    %al,(%eax)
    92b2:	00 00                	add    %al,(%eax)
    92b4:	00 00                	add    %al,(%eax)
    92b6:	00 00                	add    %al,(%eax)

Disassembly of section .data:

000092c0 <hex.1142>:
    92c0:	30 31                	xor    %dh,(%ecx)
    92c2:	32 33                	xor    (%ebx),%dh
    92c4:	34 35                	xor    $0x35,%al
    92c6:	36 37                	ss aaa 
    92c8:	38 39                	cmp    %bh,(%ecx)
    92ca:	61                   	popa   
    92cb:	62 63 64             	bound  %esp,0x64(%ebx)
    92ce:	65 66 00 00          	data16 add %al,%gs:(%eax)
    92d2:	00 00                	add    %al,(%eax)

000092d4 <dec.1137>:
    92d4:	30 31                	xor    %dh,(%ecx)
    92d6:	32 33                	xor    (%ebx),%dh
    92d8:	34 35                	xor    $0x35,%al
    92da:	36 37                	ss aaa 
    92dc:	38 39                	cmp    %bh,(%ecx)
    92de:	00 00                	add    %al,(%eax)

000092e0 <video>:
volatile char *video = (volatile char*) 0xB8000;
    92e0:	00 80 0b 00      	add    %al,-0x70a6fff5(%eax)

000092e4 <blank>:
char * blank =
    92e4:	59                   	pop    %ecx
    92e5:	8f 00                	popl   (%eax)
    92e7:	00 00                	add    %al,(%eax)
    92e9:	00 00                	add    %al,(%eax)
    92eb:	00 00                	add    %al,(%eax)
    92ed:	00 00                	add    %al,(%eax)
    92ef:	00 00                	add    %al,(%eax)
    92f1:	00 00                	add    %al,(%eax)
    92f3:	00 00                	add    %al,(%eax)
    92f5:	00 00                	add    %al,(%eax)
    92f7:	00 00                	add    %al,(%eax)
    92f9:	00 00                	add    %al,(%eax)
    92fb:	00 00                	add    %al,(%eax)
    92fd:	00 00                	add    %al,(%eax)
    92ff:	00               	add    %al,0x0(%eax)

00009300 <mboot_info>:
mboot_info_t mboot_info =
    9300:	40                   	inc    %eax
    9301:	00 00                	add    %al,(%eax)
    9303:	00 00                	add    %al,(%eax)
    9305:	00 00                	add    %al,(%eax)
    9307:	00 00                	add    %al,(%eax)
    9309:	00 00                	add    %al,(%eax)
    930b:	00 00                	add    %al,(%eax)
    930d:	00 00                	add    %al,(%eax)
    930f:	00 00                	add    %al,(%eax)
    9311:	00 00                	add    %al,(%eax)
    9313:	00 00                	add    %al,(%eax)
    9315:	00 00                	add    %al,(%eax)
    9317:	00 00                	add    %al,(%eax)
    9319:	00 00                	add    %al,(%eax)
    931b:	00 00                	add    %al,(%eax)
    931d:	00 00                	add    %al,(%eax)
    931f:	00 00                	add    %al,(%eax)
    9321:	00 00                	add    %al,(%eax)
    9323:	00 00                	add    %al,(%eax)
    9325:	00 00                	add    %al,(%eax)
    9327:	00 00                	add    %al,(%eax)
    9329:	00 00                	add    %al,(%eax)
    932b:	00 00                	add    %al,(%eax)
    932d:	00 00                	add    %al,(%eax)
    932f:	00 00                	add    %al,(%eax)
    9331:	00 00                	add    %al,(%eax)
    9333:	00 00                	add    %al,(%eax)
    9335:	00 00                	add    %al,(%eax)
    9337:	00 00                	add    %al,(%eax)
    9339:	00 00                	add    %al,(%eax)
    933b:	00 00                	add    %al,(%eax)
    933d:	00 00                	add    %al,(%eax)
    933f:	00 00                	add    %al,(%eax)
    9341:	00 00                	add    %al,(%eax)
    9343:	00 00                	add    %al,(%eax)
    9345:	00 00                	add    %al,(%eax)
    9347:	00 00                	add    %al,(%eax)
    9349:	00 00                	add    %al,(%eax)
    934b:	00 00                	add    %al,(%eax)
    934d:	00 00                	add    %al,(%eax)
    934f:	00 00                	add    %al,(%eax)
    9351:	00 00                	add    %al,(%eax)
    9353:	00 00                	add    %al,(%eax)
    9355:	00 00                	add    %al,(%eax)
    9357:	00 00                	add    %al,(%eax)
    9359:	00 00                	add    %al,(%eax)
    935b:	00 00                	add    %al,(%eax)
    935d:	00 00                	add    %al,(%eax)
    935f:	00                   	.byte 0x0

Disassembly of section .bss:

00009360 <__bss_start>:
    9360:	00 00                	add    %al,(%eax)
    9362:	00 00                	add    %al,(%eax)
    9364:	00 00                	add    %al,(%eax)
    9366:	00 00                	add    %al,(%eax)
    9368:	00 00                	add    %al,(%eax)
    936a:	00 00                	add    %al,(%eax)
    936c:	00 00                	add    %al,(%eax)
    936e:	00 00                	add    %al,(%eax)
    9370:	00 00                	add    %al,(%eax)
    9372:	00 00                	add    %al,(%eax)
    9374:	00 00                	add    %al,(%eax)
    9376:	00 00                	add    %al,(%eax)
    9378:	00 00                	add    %al,(%eax)
    937a:	00 00                	add    %al,(%eax)
    937c:	00 00                	add    %al,(%eax)
    937e:	00 00                	add    %al,(%eax)
    9380:	00 00                	add    %al,(%eax)
    9382:	00 00                	add    %al,(%eax)
    9384:	00 00                	add    %al,(%eax)
    9386:	00 00                	add    %al,(%eax)

00009388 <row>:
static int row = 0;
    9388:	00 00                	add    %al,(%eax)
    938a:	00 00                	add    %al,(%eax)

Disassembly of section .comment:

00000000 <.comment>:
   0:	47                   	inc    %edi
   1:	43                   	inc    %ebx
   2:	43                   	inc    %ebx
   3:	3a 20                	cmp    (%eax),%ah
   5:	28 55 62             	sub    %dl,0x62(%ebp)
   8:	75 6e                	jne    78 <PROT_MODE_DSEG+0x68>
   a:	74 75                	je     81 <PROT_MODE_DSEG+0x71>
   c:	20 37                	and    %dh,(%edi)
   e:	2e 35 2e 30 2d 33    	cs xor $0x332d302e,%eax
  14:	75 62                	jne    78 <PROT_MODE_DSEG+0x68>
  16:	75 6e                	jne    86 <PROT_MODE_DSEG+0x76>
  18:	74 75                	je     8f <PROT_MODE_DSEG+0x7f>
  1a:	31 7e 31             	xor    %edi,0x31(%esi)
  1d:	38 2e                	cmp    %ch,(%esi)
  1f:	30 34 29             	xor    %dh,(%ecx,%ebp,1)
  22:	20 37                	and    %dh,(%edi)
  24:	2e                   	cs
  25:	35                   	.byte 0x35
  26:	2e 30 00             	xor    %al,%cs:(%eax)

Disassembly of section .debug_aranges:

00000000 <.debug_aranges>:
   0:	1c 00                	sbb    $0x0,%al
   2:	00 00                	add    %al,(%eax)
   4:	02 00                	add    (%eax),%al
   6:	00 00                	add    %al,(%eax)
   8:	00 00                	add    %al,(%eax)
   a:	04 00                	add    $0x0,%al
   c:	00 00                	add    %al,(%eax)
   e:	00 00                	add    %al,(%eax)
  10:	00 7e 00             	add    %bh,0x0(%esi)
  13:	00 0e                	add    %cl,(%esi)
  15:	0d 00 00 00 00       	or     $0x0,%eax
  1a:	00 00                	add    %al,(%eax)
  1c:	00 00                	add    %al,(%eax)
  1e:	00 00                	add    %al,(%eax)
  20:	1c 00                	sbb    $0x0,%al
  22:	00 00                	add    %al,(%eax)
  24:	02 00                	add    (%eax),%al
  26:	26 00 00             	add    %al,%es:(%eax)
  29:	00 04 00             	add    %al,(%eax,%eax,1)
  2c:	00 00                	add    %al,(%eax)
  2e:	00 00                	add    %al,(%eax)
  30:	0e                   	push   %cs
  31:	8b 00                	mov    (%eax),%eax
  33:	00 a1 02 00 00 00    	add    %ah,0x2(%ecx)
  39:	00 00                	add    %al,(%eax)
  3b:	00 00                	add    %al,(%eax)
  3d:	00 00                	add    %al,(%eax)
  3f:	00 1c 00             	add    %bl,(%eax,%eax,1)
  42:	00 00                	add    %al,(%eax)
  44:	02 00                	add    (%eax),%al
  46:	bd 06 00 00 04       	mov    $0x4000006,%ebp
  4b:	00 00                	add    %al,(%eax)
  4d:	00 00                	add    %al,(%eax)
  4f:	00 b7 8d 00 00 8e    	add    %dh,-0x71ffff73(%edi)
  55:	01 00                	add    %eax,(%eax)
  57:	00 00                	add    %al,(%eax)
  59:	00 00                	add    %al,(%eax)
  5b:	00 00                	add    %al,(%eax)
  5d:	00 00                	add    %al,(%eax)
  5f:	00 1c 00             	add    %bl,(%eax,%eax,1)
  62:	00 00                	add    %al,(%eax)
  64:	02 00                	add    (%eax),%al
  66:	4e                   	dec    %esi
  67:	0d 00 00 04 00       	or     $0x40000,%eax
  6c:	00 00                	add    %al,(%eax)
  6e:	00 00                	add    %al,(%eax)
  70:	49                   	dec    %ecx
  71:	8f 00                	popl   (%eax)
  73:	00 10                	add    %dl,(%eax)
  75:	00 00                	add    %al,(%eax)
  77:	00 00                	add    %al,(%eax)
  79:	00 00                	add    %al,(%eax)
  7b:	00 00                	add    %al,(%eax)
  7d:	00 00                	add    %al,(%eax)
  7f:	00                   	.byte 0x0

Disassembly of section .debug_info:

00000000 <.debug_info>:
   0:	22 00                	and    (%eax),%al
   2:	00 00                	add    %al,(%eax)
   4:	02 00                	add    (%eax),%al
   6:	00 00                	add    %al,(%eax)
   8:	00 00                	add    %al,(%eax)
   a:	04 01                	add    $0x1,%al
   c:	00 00                	add    %al,(%eax)
   e:	00 00                	add    %al,(%eax)
  10:	00 7e 00             	add    %bh,0x0(%esi)
  13:	00 0e                	add    %cl,(%esi)
  15:	8b 00                	mov    (%eax),%eax
  17:	00 00                	add    %al,(%eax)
  19:	00 00                	add    %al,(%eax)
  1b:	00 13                	add    %dl,(%ebx)
  1d:	00 00                	add    %al,(%eax)
  1f:	00 31                	add    %dh,(%ecx)
  21:	00 00                	add    %al,(%eax)
  23:	00 01                	add    %al,(%ecx)
  25:	80 93 06 00 00 04 00 	adcb   $0x0,0x4000006(%ebx)
  2c:	14 00                	adc    $0x0,%al
  2e:	00 00                	add    %al,(%eax)
  30:	04 01                	add    $0x1,%al
  32:	4a                   	dec    %edx
  33:	01 00                	add    %eax,(%eax)
  35:	00 0c 87             	add    %cl,(%edi,%eax,4)
  38:	00 00                	add    %al,(%eax)
  3a:	00 13                	add    %dl,(%ebx)
  3c:	00 00                	add    %al,(%eax)
  3e:	00 0e                	add    %cl,(%esi)
  40:	8b 00                	mov    (%eax),%eax
  42:	00 a1 02 00 00 82    	add    %ah,-0x7dfffffe(%ecx)
  48:	00 00                	add    %al,(%eax)
  4a:	00 02                	add    %al,(%edx)
  4c:	01 06                	add    %eax,(%esi)
  4e:	d0 00                	rolb   (%eax)
  50:	00 00                	add    %al,(%eax)
  52:	03 9d 00 00 00 02    	add    0x2000000(%ebp),%ebx
  58:	0d 37 00 00 00       	or     $0x37,%eax
  5d:	02 01                	add    (%ecx),%al
  5f:	08 ce                	or     %cl,%dh
  61:	00 00                	add    %al,(%eax)
  63:	00 02                	add    %al,(%edx)
  65:	02 05 55 00 00 00    	add    0x55,%al
  6b:	02 02                	add    (%edx),%al
  6d:	07                   	pop    %es
  6e:	10 01                	adc    %al,(%ecx)
  70:	00 00                	add    %al,(%eax)
  72:	03 fe                	add    %esi,%edi
  74:	00 00                	add    %al,(%eax)
  76:	00 02                	add    %al,(%edx)
  78:	10 57 00             	adc    %dl,0x0(%edi)
  7b:	00 00                	add    %al,(%eax)
  7d:	04 04                	add    $0x4,%al
  7f:	05 69 6e 74 00       	add    $0x746e69,%eax
  84:	03 fd                	add    %ebp,%edi
  86:	00 00                	add    %al,(%eax)
  88:	00 02                	add    %al,(%edx)
  8a:	11 69 00             	adc    %ebp,0x0(%ecx)
  8d:	00 00                	add    %al,(%eax)
  8f:	02 04 07             	add    (%edi,%eax,1),%al
  92:	f0 00 00             	lock add %al,(%eax)
  95:	00 02                	add    %al,(%edx)
  97:	08 05 af 00 00 00    	or     %al,0xaf
  9d:	02 08                	add    (%eax),%cl
  9f:	07                   	pop    %es
  a0:	e6 00                	out    %al,$0x0
  a2:	00 00                	add    %al,(%eax)
  a4:	05 b0 01 00 00       	add    $0x1b0,%eax
  a9:	01 06                	add    %eax,(%esi)
  ab:	8f 00                	popl   (%eax)
  ad:	00 00                	add    %al,(%eax)
  af:	05 03 e0 92 00       	add    $0x92e003,%eax
  b4:	00 06                	add    %al,(%esi)
  b6:	04 9c                	add    $0x9c,%al
  b8:	00 00                	add    %al,(%eax)
  ba:	00 02                	add    %al,(%edx)
  bc:	01 06                	add    %eax,(%esi)
  be:	d7                   	xlat   %ds:(%ebx)
  bf:	00 00                	add    %al,(%eax)
  c1:	00 07                	add    %al,(%edi)
  c3:	95                   	xchg   %eax,%ebp
  c4:	00 00                	add    %al,(%eax)
  c6:	00 08                	add    %cl,(%eax)
  c8:	95                   	xchg   %eax,%ebp
  c9:	00 00                	add    %al,(%eax)
  cb:	00 09                	add    %cl,(%ecx)
  cd:	72 6f                	jb     13e <PROT_MODE_DSEG+0x12e>
  cf:	77 00                	ja     d1 <PROT_MODE_DSEG+0xc1>
  d1:	01 1c 57             	add    %ebx,(%edi,%edx,2)
  d4:	00 00                	add    %al,(%eax)
  d6:	00 05 03 88 93 00    	add    %al,0x938803
  dc:	00 05 a5 01 00 00    	add    %al,0x1a5
  e2:	01 1e                	add    %ebx,(%esi)
  e4:	c8 00 00 00          	enter  $0x0,$0x0
  e8:	05 03 e4 92 00       	add    $0x92e403,%eax
  ed:	00 06                	add    %al,(%esi)
  ef:	04 95                	add    $0x95,%al
  f1:	00 00                	add    %al,(%eax)
  f3:	00 0a                	add    %cl,(%edx)
  f5:	95                   	xchg   %eax,%ebp
  f6:	00 00                	add    %al,(%eax)
  f8:	00 de                	add    %bl,%dh
  fa:	00 00                	add    %al,(%eax)
  fc:	00 0b                	add    %cl,(%ebx)
  fe:	69 00 00 00 27 00    	imul   $0x270000,(%eax),%eax
 104:	0c 41                	or     $0x41,%al
 106:	01 00                	add    %eax,(%eax)
 108:	00 01                	add    %al,(%ecx)
 10a:	38 ce                	cmp    %cl,%dh
 10c:	00 00                	add    %al,(%eax)
 10e:	00 05 03 60 93 00    	add    %al,0x936003
 114:	00 0d bd 00 00 00    	add    %cl,0xbd
 11a:	01 a4 6e 8d 00 00 41 	add    %esp,0x4100008d(%esi,%ebp,2)
 121:	00 00                	add    %al,(%eax)
 123:	00 01                	add    %al,(%ecx)
 125:	9c                   	pushf  
 126:	56                   	push   %esi
 127:	01 00                	add    %eax,(%eax)
 129:	00 0e                	add    %cl,(%esi)
 12b:	76 61                	jbe    18e <PROT_MODE_DSEG+0x17e>
 12d:	00 01                	add    %al,(%ecx)
 12f:	a4                   	movsb  %ds:(%esi),%es:(%edi)
 130:	5e                   	pop    %esi
 131:	00 00                	add    %al,(%eax)
 133:	00 00                	add    %al,(%eax)
 135:	00 00                	add    %al,(%eax)
 137:	00 0f                	add    %cl,(%edi)
 139:	62 04 00             	bound  %eax,(%eax,%eax,1)
 13c:	00 01                	add    %al,(%ecx)
 13e:	a4                   	movsb  %ds:(%esi),%es:(%edi)
 13f:	5e                   	pop    %esi
 140:	00 00                	add    %al,(%eax)
 142:	00 02                	add    %al,(%edx)
 144:	91                   	xchg   %eax,%ecx
 145:	04 10                	add    $0x10,%al
 147:	1b 02                	sbb    (%edx),%eax
 149:	00 00                	add    %al,(%eax)
 14b:	01 a4 5e 00 00 00 63 	add    %esp,0x63000000(%esi,%ebx,2)
 152:	00 00                	add    %al,(%eax)
 154:	00 11                	add    %dl,(%ecx)
 156:	6c                   	insb   (%dx),%es:(%edi)
 157:	62 61 00             	bound  %esp,0x0(%ecx)
 15a:	01 a4 5e 00 00 00 02 	add    %esp,0x2000000(%esi,%ebx,2)
 161:	91                   	xchg   %eax,%ecx
 162:	0c 12                	or     $0x12,%al
 164:	3d 00 00 00 01       	cmp    $0x1000000,%eax
 169:	a6                   	cmpsb  %es:(%edi),%ds:(%esi)
 16a:	5e                   	pop    %esi
 16b:	00 00                	add    %al,(%eax)
 16d:	00 a6 00 00 00 13    	add    %ah,0x13000000(%esi)
 173:	a3 8d 00 00 56       	mov    %eax,0x5600008d
 178:	01 00                	add    %eax,(%eax)
 17a:	00 00                	add    %al,(%eax)
 17c:	0d 7c 00 00 00       	or     $0x7c,%eax
 181:	01 8e ff 8c 00 00    	add    %ecx,0x8cff(%esi)
 187:	6f                   	outsl  %ds:(%esi),(%dx)
 188:	00 00                	add    %al,(%eax)
 18a:	00 01                	add    %al,(%ecx)
 18c:	9c                   	pushf  
 18d:	0b 03                	or     (%ebx),%eax
 18f:	00 00                	add    %al,(%eax)
 191:	11 64 73 74          	adc    %esp,0x74(%ebx,%esi,2)
 195:	00 01                	add    %al,(%ecx)
 197:	8e 0b                	mov    (%ebx),%cs
 199:	03 00                	add    (%eax),%eax
 19b:	00 02                	add    %al,(%edx)
 19d:	91                   	xchg   %eax,%ecx
 19e:	00 0f                	add    %cl,(%edi)
 1a0:	1b 02                	sbb    (%edx),%eax
 1a2:	00 00                	add    %al,(%eax)
 1a4:	01 8e 5e 00 00 00    	add    %ecx,0x5e(%esi)
 1aa:	02 91 04 14 0d 03    	add    0x30d1404(%ecx),%dl
 1b0:	00 00                	add    %al,(%eax)
 1b2:	03 8d 00 00 00 00    	add    0x0(%ebp),%ecx
 1b8:	00 00                	add    %al,(%eax)
 1ba:	01 91 bf 01 00 00    	add    %edx,0x1bf(%ecx)
 1c0:	15 50 06 00 00       	adc    $0x650,%eax
 1c5:	03 8d 00 00 18 00    	add    0x180000(%ebp),%ecx
 1cb:	00 00                	add    %al,(%eax)
 1cd:	01 89 16 60 06 00    	add    %ecx,0x66016(%ecx)
 1d3:	00 d1                	add    %dl,%cl
 1d5:	00 00                	add    %al,(%eax)
 1d7:	00 17                	add    %dl,(%edi)
 1d9:	18 00                	sbb    %al,(%eax)
 1db:	00 00                	add    %al,(%eax)
 1dd:	18 6b 06             	sbb    %ch,0x6(%ebx)
 1e0:	00 00                	add    %al,(%eax)
 1e2:	00 00                	add    %al,(%eax)
 1e4:	00 19                	add    %bl,(%ecx)
 1e6:	77 06                	ja     1ee <PROT_MODE_DSEG+0x1de>
 1e8:	00 00                	add    %al,(%eax)
 1ea:	15 8d 00 00 08       	adc    $0x800008d,%eax
 1ef:	00 00                	add    %al,(%eax)
 1f1:	00 01                	add    %al,(%ecx)
 1f3:	93                   	xchg   %eax,%ebx
 1f4:	e5 01                	in     $0x1,%eax
 1f6:	00 00                	add    %al,(%eax)
 1f8:	16                   	push   %ss
 1f9:	8a 06                	mov    (%esi),%al
 1fb:	00 00                	add    %al,(%eax)
 1fd:	e7 00                	out    %eax,$0x0
 1ff:	00 00                	add    %al,(%eax)
 201:	16                   	push   %ss
 202:	7f 06                	jg     20a <PROT_MODE_DSEG+0x1fa>
 204:	00 00                	add    %al,(%eax)
 206:	fb                   	sti    
 207:	00 00                	add    %al,(%eax)
 209:	00 00                	add    %al,(%eax)
 20b:	19 77 06             	sbb    %esi,0x6(%edi)
 20e:	00 00                	add    %al,(%eax)
 210:	1d 8d 00 00 08       	sbb    $0x800008d,%eax
 215:	00 00                	add    %al,(%eax)
 217:	00 01                	add    %al,(%ecx)
 219:	94                   	xchg   %eax,%esp
 21a:	0b 02                	or     (%edx),%eax
 21c:	00 00                	add    %al,(%eax)
 21e:	16                   	push   %ss
 21f:	8a 06                	mov    (%esi),%al
 221:	00 00                	add    %al,(%eax)
 223:	11 01                	adc    %eax,(%ecx)
 225:	00 00                	add    %al,(%eax)
 227:	16                   	push   %ss
 228:	7f 06                	jg     230 <PROT_MODE_DSEG+0x220>
 22a:	00 00                	add    %al,(%eax)
 22c:	24 01                	and    $0x1,%al
 22e:	00 00                	add    %al,(%eax)
 230:	00 14 77             	add    %dl,(%edi,%esi,2)
 233:	06                   	push   %es
 234:	00 00                	add    %al,(%eax)
 236:	27                   	daa    
 237:	8d 00                	lea    (%eax),%eax
 239:	00 30                	add    %dh,(%eax)
 23b:	00 00                	add    %al,(%eax)
 23d:	00 01                	add    %al,(%ecx)
 23f:	95                   	xchg   %eax,%ebp
 240:	31 02                	xor    %eax,(%edx)
 242:	00 00                	add    %al,(%eax)
 244:	16                   	push   %ss
 245:	8a 06                	mov    (%esi),%al
 247:	00 00                	add    %al,(%eax)
 249:	3a 01                	cmp    (%ecx),%al
 24b:	00 00                	add    %al,(%eax)
 24d:	16                   	push   %ss
 24e:	7f 06                	jg     256 <PROT_MODE_DSEG+0x246>
 250:	00 00                	add    %al,(%eax)
 252:	4e                   	dec    %esi
 253:	01 00                	add    %eax,(%eax)
 255:	00 00                	add    %al,(%eax)
 257:	14 77                	adc    $0x77,%al
 259:	06                   	push   %es
 25a:	00 00                	add    %al,(%eax)
 25c:	32 8d 00 00 48 00    	xor    0x480000(%ebp),%cl
 262:	00 00                	add    %al,(%eax)
 264:	01 96 57 02 00 00    	add    %edx,0x257(%esi)
 26a:	16                   	push   %ss
 26b:	8a 06                	mov    (%esi),%al
 26d:	00 00                	add    %al,(%eax)
 26f:	64 01 00             	add    %eax,%fs:(%eax)
 272:	00 16                	add    %dl,(%esi)
 274:	7f 06                	jg     27c <PROT_MODE_DSEG+0x26c>
 276:	00 00                	add    %al,(%eax)
 278:	78 01                	js     27b <PROT_MODE_DSEG+0x26b>
 27a:	00 00                	add    %al,(%eax)
 27c:	00 14 77             	add    %dl,(%edi,%esi,2)
 27f:	06                   	push   %es
 280:	00 00                	add    %al,(%eax)
 282:	3d 8d 00 00 60       	cmp    $0x6000008d,%eax
 287:	00 00                	add    %al,(%eax)
 289:	00 01                	add    %al,(%ecx)
 28b:	97                   	xchg   %eax,%edi
 28c:	7d 02                	jge    290 <PROT_MODE_DSEG+0x280>
 28e:	00 00                	add    %al,(%eax)
 290:	16                   	push   %ss
 291:	8a 06                	mov    (%esi),%al
 293:	00 00                	add    %al,(%eax)
 295:	8e 01                	mov    (%ecx),%es
 297:	00 00                	add    %al,(%eax)
 299:	16                   	push   %ss
 29a:	7f 06                	jg     2a2 <PROT_MODE_DSEG+0x292>
 29c:	00 00                	add    %al,(%eax)
 29e:	a8 01                	test   $0x1,%al
 2a0:	00 00                	add    %al,(%eax)
 2a2:	00 19                	add    %bl,(%ecx)
 2a4:	77 06                	ja     2ac <PROT_MODE_DSEG+0x29c>
 2a6:	00 00                	add    %al,(%eax)
 2a8:	49                   	dec    %ecx
 2a9:	8d 00                	lea    (%eax),%eax
 2ab:	00 05 00 00 00 01    	add    %al,0x1000000
 2b1:	98                   	cwtl   
 2b2:	a3 02 00 00 16       	mov    %eax,0x16000002
 2b7:	8a 06                	mov    (%esi),%al
 2b9:	00 00                	add    %al,(%eax)
 2bb:	be 01 00 00 16       	mov    $0x16000001,%esi
 2c0:	7f 06                	jg     2c8 <PROT_MODE_DSEG+0x2b8>
 2c2:	00 00                	add    %al,(%eax)
 2c4:	d3 01                	roll   %cl,(%ecx)
 2c6:	00 00                	add    %al,(%eax)
 2c8:	00 19                	add    %bl,(%ecx)
 2ca:	0d 03 00 00 4e       	or     $0x4e000003,%eax
 2cf:	8d 00                	lea    (%eax),%eax
 2d1:	00 0d 00 00 00 01    	add    %cl,0x1000000
 2d7:	9b df 02             	filds  (%edx)
 2da:	00 00                	add    %al,(%eax)
 2dc:	1a 50 06             	sbb    0x6(%eax),%dl
 2df:	00 00                	add    %al,(%eax)
 2e1:	4e                   	dec    %esi
 2e2:	8d 00                	lea    (%eax),%eax
 2e4:	00 06                	add    %al,(%esi)
 2e6:	00 00                	add    %al,(%eax)
 2e8:	00 01                	add    %al,(%ecx)
 2ea:	89 16                	mov    %edx,(%esi)
 2ec:	60                   	pusha  
 2ed:	06                   	push   %es
 2ee:	00 00                	add    %al,(%eax)
 2f0:	e9 01 00 00 1b       	jmp    1b0002f6 <_end+0x1aff6f6a>
 2f5:	4e                   	dec    %esi
 2f6:	8d 00                	lea    (%eax),%eax
 2f8:	00 06                	add    %al,(%esi)
 2fa:	00 00                	add    %al,(%eax)
 2fc:	00 18                	add    %bl,(%eax)
 2fe:	6b 06 00             	imul   $0x0,(%esi),%eax
 301:	00 00                	add    %al,(%eax)
 303:	00 00                	add    %al,(%eax)
 305:	1a 22                	sbb    (%edx),%ah
 307:	06                   	push   %es
 308:	00 00                	add    %al,(%eax)
 30a:	5b                   	pop    %ebx
 30b:	8d 00                	lea    (%eax),%eax
 30d:	00 10                	add    %dl,(%eax)
 30f:	00 00                	add    %al,(%eax)
 311:	00 01                	add    %al,(%ecx)
 313:	9e                   	sahf   
 314:	16                   	push   %ss
 315:	44                   	inc    %esp
 316:	06                   	push   %es
 317:	00 00                	add    %al,(%eax)
 319:	ff 01                	incl   (%ecx)
 31b:	00 00                	add    %al,(%eax)
 31d:	16                   	push   %ss
 31e:	39 06                	cmp    %eax,(%esi)
 320:	00 00                	add    %al,(%eax)
 322:	14 02                	adc    $0x2,%al
 324:	00 00                	add    %al,(%eax)
 326:	16                   	push   %ss
 327:	2e 06                	cs push %es
 329:	00 00                	add    %al,(%eax)
 32b:	28 02                	sub    %al,(%edx)
 32d:	00 00                	add    %al,(%eax)
 32f:	00 00                	add    %al,(%eax)
 331:	1c 04                	sbb    $0x4,%al
 333:	1d 44 00 00 00       	sbb    $0x44,%eax
 338:	01 86 01 0d dc 00    	add    %eax,0xdc0d01(%esi)
 33e:	00 00                	add    %al,(%eax)
 340:	01 7b ae             	add    %edi,-0x52(%ebx)
 343:	8c 00                	mov    %es,(%eax)
 345:	00 26                	add    %ah,(%esi)
 347:	00 00                	add    %al,(%eax)
 349:	00 01                	add    %al,(%ecx)
 34b:	9c                   	pushf  
 34c:	5d                   	pop    %ebp
 34d:	03 00                	add    (%eax),%eax
 34f:	00 11                	add    %dl,(%ecx)
 351:	6e                   	outsb  %ds:(%esi),(%dx)
 352:	00 01                	add    %al,(%ecx)
 354:	7b 57                	jnp    3ad <PROT_MODE_DSEG+0x39d>
 356:	00 00                	add    %al,(%eax)
 358:	00 02                	add    %al,(%edx)
 35a:	91                   	xchg   %eax,%ecx
 35b:	00 11                	add    %dl,(%ecx)
 35d:	73 00                	jae    35f <PROT_MODE_DSEG+0x34f>
 35f:	01 7b c8             	add    %edi,-0x38(%ebx)
 362:	00 00                	add    %al,(%eax)
 364:	00 02                	add    %al,(%edx)
 366:	91                   	xchg   %eax,%ecx
 367:	04 09                	add    $0x9,%al
 369:	68 65 78 00 01       	push   $0x1007865
 36e:	7d 5d                	jge    3cd <PROT_MODE_DSEG+0x3bd>
 370:	03 00                	add    (%eax),%eax
 372:	00 05 03 c0 92 00    	add    %al,0x92c003
 378:	00 13                	add    %dl,(%ebx)
 37a:	cf                   	iret   
 37b:	8c 00                	mov    %es,(%eax)
 37d:	00 c5                	add    %al,%ch
 37f:	03 00                	add    (%eax),%eax
 381:	00 00                	add    %al,(%eax)
 383:	0a 95 00 00 00 6d    	or     0x6d000000(%ebp),%dl
 389:	03 00                	add    (%eax),%eax
 38b:	00 0b                	add    %cl,(%ebx)
 38d:	69 00 00 00 10 00    	imul   $0x100000,(%eax),%eax
 393:	0d c9 00 00 00       	or     $0xc9,%eax
 398:	01 73 88             	add    %esi,-0x78(%ebx)
 39b:	8c 00                	mov    %es,(%eax)
 39d:	00 26                	add    %ah,(%esi)
 39f:	00 00                	add    %al,(%eax)
 3a1:	00 01                	add    %al,(%ecx)
 3a3:	9c                   	pushf  
 3a4:	b5 03                	mov    $0x3,%ch
 3a6:	00 00                	add    %al,(%eax)
 3a8:	11 6e 00             	adc    %ebp,0x0(%esi)
 3ab:	01 73 57             	add    %esi,0x57(%ebx)
 3ae:	00 00                	add    %al,(%eax)
 3b0:	00 02                	add    %al,(%edx)
 3b2:	91                   	xchg   %eax,%ecx
 3b3:	00 11                	add    %dl,(%ecx)
 3b5:	73 00                	jae    3b7 <PROT_MODE_DSEG+0x3a7>
 3b7:	01 73 c8             	add    %esi,-0x38(%ebx)
 3ba:	00 00                	add    %al,(%eax)
 3bc:	00 02                	add    %al,(%edx)
 3be:	91                   	xchg   %eax,%ecx
 3bf:	04 09                	add    $0x9,%al
 3c1:	64 65 63 00          	fs arpl %ax,%gs:(%eax)
 3c5:	01 75 b5             	add    %esi,-0x4b(%ebp)
 3c8:	03 00                	add    (%eax),%eax
 3ca:	00 05 03 d4 92 00    	add    %al,0x92d403
 3d0:	00 13                	add    %dl,(%ebx)
 3d2:	a9 8c 00 00 c5       	test   $0xc500008c,%eax
 3d7:	03 00                	add    (%eax),%eax
 3d9:	00 00                	add    %al,(%eax)
 3db:	0a 95 00 00 00 c5    	or     -0x3b000000(%ebp),%dl
 3e1:	03 00                	add    (%eax),%eax
 3e3:	00 0b                	add    %cl,(%ebx)
 3e5:	69 00 00 00 0a 00    	imul   $0xa0000,(%eax),%eax
 3eb:	0d 06 01 00 00       	or     $0x106,%eax
 3f0:	01 61 27             	add    %esp,0x27(%ecx)
 3f3:	8c 00                	mov    %es,(%eax)
 3f5:	00 61 00             	add    %ah,0x0(%ecx)
 3f8:	00 00                	add    %al,(%eax)
 3fa:	01 9c 35 04 00 00 0e 	add    %ebx,0xe000004(%ebp,%esi,1)
 401:	6e                   	outsb  %ds:(%esi),(%dx)
 402:	00 01                	add    %al,(%ecx)
 404:	61                   	popa   
 405:	57                   	push   %edi
 406:	00 00                	add    %al,(%eax)
 408:	00 3e                	add    %bh,(%esi)
 40a:	02 00                	add    (%eax),%al
 40c:	00 11                	add    %dl,(%ecx)
 40e:	73 00                	jae    410 <PROT_MODE_DSEG+0x400>
 410:	01 61 c8             	add    %esp,-0x38(%ecx)
 413:	00 00                	add    %al,(%eax)
 415:	00 02                	add    %al,(%edx)
 417:	91                   	xchg   %eax,%ecx
 418:	04 0f                	add    $0xf,%al
 41a:	ab                   	stos   %eax,%es:(%edi)
 41b:	01 00                	add    %eax,(%eax)
 41d:	00 01                	add    %al,(%ecx)
 41f:	61                   	popa   
 420:	57                   	push   %edi
 421:	00 00                	add    %al,(%eax)
 423:	00 02                	add    %al,(%edx)
 425:	91                   	xchg   %eax,%ecx
 426:	08 0f                	or     %cl,(%edi)
 428:	a7                   	cmpsl  %es:(%edi),%ds:(%esi)
 429:	03 00                	add    (%eax),%eax
 42b:	00 01                	add    %al,(%ecx)
 42d:	61                   	popa   
 42e:	c8 00 00 00          	enter  $0x0,$0x0
 432:	02 91 0c 1e 69 00    	add    0x691e0c(%ecx),%dl
 438:	01 63 57             	add    %esp,0x57(%ebx)
 43b:	00 00                	add    %al,(%eax)
 43d:	00 5d 02             	add    %bl,0x2(%ebp)
 440:	00 00                	add    %al,(%eax)
 442:	12 34 01             	adc    (%ecx,%eax,1),%dh
 445:	00 00                	add    %al,(%eax)
 447:	01 63 57             	add    %esp,0x57(%ebx)
 44a:	00 00                	add    %al,(%eax)
 44c:	00 91 02 00 00 1f    	add    %dl,0x1f000002(%ecx)
 452:	88 8c 00 00 35 04 00 	mov    %cl,0x43500(%eax,%eax,1)
 459:	00 00                	add    %al,(%eax)
 45b:	0d 39 01 00 00       	or     $0x139,%eax
 460:	01 52 f7             	add    %edx,-0x9(%edx)
 463:	8b 00                	mov    (%eax),%eax
 465:	00 30                	add    %dh,(%eax)
 467:	00 00                	add    %al,(%eax)
 469:	00 01                	add    %al,(%ecx)
 46b:	9c                   	pushf  
 46c:	85 04 00             	test   %eax,(%eax,%eax,1)
 46f:	00 11                	add    %dl,(%ecx)
 471:	73 00                	jae    473 <PROT_MODE_DSEG+0x463>
 473:	01 52 c8             	add    %edx,-0x38(%edx)
 476:	00 00                	add    %al,(%eax)
 478:	00 02                	add    %al,(%edx)
 47a:	91                   	xchg   %eax,%ecx
 47b:	00 1e                	add    %bl,(%esi)
 47d:	69 00 01 54 57 00    	imul   $0x575401,(%eax),%eax
 483:	00 00                	add    %al,(%eax)
 485:	a5                   	movsl  %ds:(%esi),%es:(%edi)
 486:	02 00                	add    (%eax),%al
 488:	00 09                	add    %cl,(%ecx)
 48a:	6a 00                	push   $0x0
 48c:	01 54 57 00          	add    %edx,0x0(%edi,%edx,2)
 490:	00 00                	add    %al,(%eax)
 492:	01 50 1e             	add    %edx,0x1e(%eax)
 495:	63 00                	arpl   %ax,(%eax)
 497:	01 55 95             	add    %edx,-0x6b(%ebp)
 49a:	00 00                	add    %al,(%eax)
 49c:	00 c4                	add    %al,%ah
 49e:	02 00                	add    (%eax),%al
 4a0:	00 13                	add    %dl,(%ebx)
 4a2:	05 8c 00 00 85       	add    $0x8500008c,%eax
 4a7:	04 00                	add    $0x0,%al
 4a9:	00 00                	add    %al,(%eax)
 4ab:	20 23                	and    %ah,(%ebx)
 4ad:	01 00                	add    %eax,(%eax)
 4af:	00 01                	add    %al,(%ecx)
 4b1:	47                   	inc    %edi
 4b2:	57                   	push   %edi
 4b3:	00 00                	add    %al,(%eax)
 4b5:	00 e4                	add    %ah,%ah
 4b7:	8b 00                	mov    (%eax),%eax
 4b9:	00 13                	add    %dl,(%ebx)
 4bb:	00 00                	add    %al,(%eax)
 4bd:	00 01                	add    %al,(%ecx)
 4bf:	9c                   	pushf  
 4c0:	b9 04 00 00 0e       	mov    $0xe000004,%ecx
 4c5:	73 00                	jae    4c7 <PROT_MODE_DSEG+0x4b7>
 4c7:	01 47 b9             	add    %eax,-0x47(%edi)
 4ca:	04 00                	add    $0x0,%al
 4cc:	00 d7                	add    %dl,%bh
 4ce:	02 00                	add    (%eax),%al
 4d0:	00 1e                	add    %bl,(%esi)
 4d2:	6e                   	outsb  %ds:(%esi),(%dx)
 4d3:	00 01                	add    %al,(%ecx)
 4d5:	49                   	dec    %ecx
 4d6:	57                   	push   %edi
 4d7:	00 00                	add    %al,(%eax)
 4d9:	00 fc                	add    %bh,%ah
 4db:	02 00                	add    (%eax),%al
 4dd:	00 00                	add    %al,(%eax)
 4df:	06                   	push   %es
 4e0:	04 a1                	add    $0xa1,%al
 4e2:	00 00                	add    %al,(%eax)
 4e4:	00 0d 77 00 00 00    	add    %cl,0x77
 4ea:	01 3b                	add    %edi,(%ebx)
 4ec:	d4 8c                	aam    $0x8c
 4ee:	00 00                	add    %al,(%eax)
 4f0:	2b 00                	sub    (%eax),%eax
 4f2:	00 00                	add    %al,(%eax)
 4f4:	01 9c f4 04 00 00 0e 	add    %ebx,0xe000004(%esp,%esi,8)
 4fb:	69 00 01 3b 4c 00    	imul   $0x4c3b01,(%eax),%eax
 501:	00 00                	add    %al,(%eax)
 503:	1b 03                	sbb    (%ebx),%eax
 505:	00 00                	add    %al,(%eax)
 507:	13 f1                	adc    %ecx,%esi
 509:	8c 00                	mov    %es,(%eax)
 50b:	00 15 03 00 00 1f    	add    %dl,0x1f000003
 511:	ff 8c 00 00 41 05 00 	decl   0x54100(%eax,%eax,1)
 518:	00 00                	add    %al,(%eax)
 51a:	0d 71 00 00 00       	or     $0x71,%eax
 51f:	01 2f                	add    %ebp,(%edi)
 521:	cd 8b                	int    $0x8b
 523:	00 00                	add    %al,(%eax)
 525:	17                   	pop    %ss
 526:	00 00                	add    %al,(%eax)
 528:	00 01                	add    %al,(%ecx)
 52a:	9c                   	pushf  
 52b:	1f                   	pop    %ds
 52c:	05 00 00 11 6d       	add    $0x6d110000,%eax
 531:	00 01                	add    %al,(%ecx)
 533:	2f                   	das    
 534:	c8 00 00 00          	enter  $0x0,$0x0
 538:	02 91 00 13 de 8b    	add    -0x7421ed00(%ecx),%dl
 53e:	00 00                	add    %al,(%eax)
 540:	75 05                	jne    547 <PROT_MODE_DSEG+0x537>
 542:	00 00                	add    %al,(%eax)
 544:	00 0d 65 00 00 00    	add    %cl,0x65
 54a:	01 29                	add    %ebp,(%ecx)
 54c:	b5 8b                	mov    $0x8b,%ch
 54e:	00 00                	add    %al,(%eax)
 550:	18 00                	sbb    %al,(%eax)
 552:	00 00                	add    %al,(%eax)
 554:	01 9c 41 05 00 00 11 	add    %ebx,0x11000005(%ecx,%eax,2)
 55b:	72 00                	jb     55d <PROT_MODE_DSEG+0x54d>
 55d:	01 29                	add    %ebp,(%ecx)
 55f:	57                   	push   %edi
 560:	00 00                	add    %al,(%eax)
 562:	00 02                	add    %al,(%edx)
 564:	91                   	xchg   %eax,%ecx
 565:	00 00                	add    %al,(%eax)
 567:	0d 4d 00 00 00       	or     $0x4d,%eax
 56c:	01 22                	add    %esp,(%edx)
 56e:	6b 8b 00 00 4a 00 00 	imul   $0x0,0x4a0000(%ebx),%ecx
 575:	00 01                	add    %al,(%ecx)
 577:	9c                   	pushf  
 578:	75 05                	jne    57f <PROT_MODE_DSEG+0x56f>
 57a:	00 00                	add    %al,(%eax)
 57c:	11 73 00             	adc    %esi,0x0(%ebx)
 57f:	01 22                	add    %esp,(%edx)
 581:	c8 00 00 00          	enter  $0x0,$0x0
 585:	02 91 00 13 a0 8b    	add    -0x745fed00(%ecx),%dl
 58b:	00 00                	add    %al,(%eax)
 58d:	75 05                	jne    594 <PROT_MODE_DSEG+0x584>
 58f:	00 00                	add    %al,(%eax)
 591:	13 ad 8b 00 00 75    	adc    0x7500008b(%ebp),%ebp
 597:	05 00 00 00 20       	add    $0x20000000,%eax
 59c:	0b 01                	or     (%ecx),%eax
 59e:	00 00                	add    %al,(%eax)
 5a0:	01 12                	add    %edx,(%edx)
 5a2:	57                   	push   %edi
 5a3:	00 00                	add    %al,(%eax)
 5a5:	00 34 8b             	add    %dh,(%ebx,%ecx,4)
 5a8:	00 00                	add    %al,(%eax)
 5aa:	37                   	aaa    
 5ab:	00 00                	add    %al,(%eax)
 5ad:	00 01                	add    %al,(%ecx)
 5af:	9c                   	pushf  
 5b0:	da 05 00 00 11 72    	fiaddl 0x72110000
 5b6:	00 01                	add    %al,(%ecx)
 5b8:	12 57 00             	adc    0x0(%edi),%dl
 5bb:	00 00                	add    %al,(%eax)
 5bd:	02 91 00 11 63 00    	add    0x631100(%ecx),%dl
 5c3:	01 12                	add    %edx,(%edx)
 5c5:	57                   	push   %edi
 5c6:	00 00                	add    %al,(%eax)
 5c8:	00 02                	add    %al,(%edx)
 5ca:	91                   	xchg   %eax,%ecx
 5cb:	04 0f                	add    $0xf,%al
 5cd:	5f                   	pop    %edi
 5ce:	00 00                	add    %al,(%eax)
 5d0:	00 01                	add    %al,(%ecx)
 5d2:	12 57 00             	adc    0x0(%edi),%dl
 5d5:	00 00                	add    %al,(%eax)
 5d7:	02 91 08 10 6a 00    	add    0x6a1008(%ecx),%dl
 5dd:	00 00                	add    %al,(%eax)
 5df:	01 12                	add    %edx,(%edx)
 5e1:	b9 04 00 00 2f       	mov    $0x2f000004,%ecx
 5e6:	03 00                	add    (%eax),%eax
 5e8:	00 1e                	add    %bl,(%esi)
 5ea:	6c                   	insb   (%dx),%es:(%edi)
 5eb:	00 01                	add    %al,(%ecx)
 5ed:	14 57                	adc    $0x57,%al
 5ef:	00 00                	add    %al,(%eax)
 5f1:	00 b1 03 00 00 13    	add    %dh,0x13000003(%ecx)
 5f7:	5d                   	pop    %ebp
 5f8:	8b 00                	mov    (%eax),%eax
 5fa:	00 da                	add    %bl,%dl
 5fc:	05 00 00 00 0d       	add    $0xd000000,%eax
 601:	e1 00                	loope  603 <PROT_MODE_DSEG+0x5f3>
 603:	00 00                	add    %al,(%eax)
 605:	01 09                	add    %ecx,(%ecx)
 607:	0e                   	push   %cs
 608:	8b 00                	mov    (%eax),%eax
 60a:	00 26                	add    %ah,(%esi)
 60c:	00 00                	add    %al,(%eax)
 60e:	00 01                	add    %al,(%ecx)
 610:	9c                   	pushf  
 611:	22 06                	and    (%esi),%al
 613:	00 00                	add    %al,(%eax)
 615:	11 6c 00 01          	adc    %ebp,0x1(%eax,%eax,1)
 619:	09 57 00             	or     %edx,0x0(%edi)
 61c:	00 00                	add    %al,(%eax)
 61e:	02 91 00 0f 5f 00    	add    0x5f0f00(%ecx),%dl
 624:	00 00                	add    %al,(%eax)
 626:	01 09                	add    %ecx,(%ecx)
 628:	57                   	push   %edi
 629:	00 00                	add    %al,(%eax)
 62b:	00 02                	add    %al,(%edx)
 62d:	91                   	xchg   %eax,%ecx
 62e:	04 11                	add    $0x11,%al
 630:	63 68 00             	arpl   %bp,0x0(%eax)
 633:	01 09                	add    %ecx,(%ecx)
 635:	95                   	xchg   %eax,%ebp
 636:	00 00                	add    %al,(%eax)
 638:	00 02                	add    %al,(%edx)
 63a:	91                   	xchg   %eax,%ecx
 63b:	08 09                	or     %cl,(%ecx)
 63d:	70 00                	jo     63f <PROT_MODE_DSEG+0x62f>
 63f:	01 0b                	add    %ecx,(%ebx)
 641:	8f 00                	popl   (%eax)
 643:	00 00                	add    %al,(%eax)
 645:	01 50 00             	add    %edx,0x0(%eax)
 648:	21 aa 00 00 00 02    	and    %ebp,0x2000000(%edx)
 64e:	2d 03 50 06 00       	sub    $0x65003,%eax
 653:	00 22                	add    %ah,(%edx)
 655:	2f                   	das    
 656:	01 00                	add    %eax,(%eax)
 658:	00 02                	add    %al,(%edx)
 65a:	2d 57 00 00 00       	sub    $0x57,%eax
 65f:	22 c3                	and    %bl,%al
 661:	03 00                	add    (%eax),%eax
 663:	00 02                	add    %al,(%edx)
 665:	2d 0b 03 00 00       	sub    $0x30b,%eax
 66a:	23 63 6e             	and    0x6e(%ebx),%esp
 66d:	74 00                	je     66f <PROT_MODE_DSEG+0x65f>
 66f:	02 2d 57 00 00 00    	add    0x57,%ch
 675:	00 24 69             	add    %ah,(%ecx,%ebp,2)
 678:	6e                   	outsb  %ds:(%esi),(%dx)
 679:	62 00                	bound  %eax,(%eax)
 67b:	02 25 2c 00 00 00    	add    0x2c,%ah
 681:	03 77 06             	add    0x6(%edi),%esi
 684:	00 00                	add    %al,(%eax)
 686:	22 2f                	and    (%edi),%ch
 688:	01 00                	add    %eax,(%eax)
 68a:	00 02                	add    %al,(%edx)
 68c:	25 57 00 00 00       	and    $0x57,%eax
 691:	25 2a 01 00 00       	and    $0x12a,%eax
 696:	02 27                	add    (%edi),%ah
 698:	2c 00                	sub    $0x0,%al
 69a:	00 00                	add    %al,(%eax)
 69c:	00 26                	add    %ah,(%esi)
 69e:	a5                   	movsl  %ds:(%esi),%es:(%edi)
 69f:	00 00                	add    %al,(%eax)
 6a1:	00 02                	add    %al,(%edx)
 6a3:	19 03                	sbb    %eax,(%ebx)
 6a5:	22 2f                	and    (%edi),%ch
 6a7:	01 00                	add    %eax,(%eax)
 6a9:	00 02                	add    %al,(%edx)
 6ab:	19 57 00             	sbb    %edx,0x0(%edi)
 6ae:	00 00                	add    %al,(%eax)
 6b0:	22 2a                	and    (%edx),%ch
 6b2:	01 00                	add    %eax,(%eax)
 6b4:	00 02                	add    %al,(%edx)
 6b6:	19 2c 00             	sbb    %ebp,(%eax,%eax,1)
 6b9:	00 00                	add    %al,(%eax)
 6bb:	00 00                	add    %al,(%eax)
 6bd:	8d 06                	lea    (%esi),%eax
 6bf:	00 00                	add    %al,(%eax)
 6c1:	04 00                	add    $0x0,%al
 6c3:	1c 02                	sbb    $0x2,%al
 6c5:	00 00                	add    %al,(%eax)
 6c7:	04 01                	add    $0x1,%al
 6c9:	4a                   	dec    %edx
 6ca:	01 00                	add    %eax,(%eax)
 6cc:	00 0c 46             	add    %cl,(%esi,%eax,2)
 6cf:	04 00                	add    $0x0,%al
 6d1:	00 13                	add    %dl,(%ebx)
 6d3:	00 00                	add    %al,(%eax)
 6d5:	00 b7 8d 00 00 8e    	add    %dh,-0x71ffff73(%edi)
 6db:	01 00                	add    %eax,(%eax)
 6dd:	00 ff                	add    %bh,%bh
 6df:	01 00                	add    %eax,(%eax)
 6e1:	00 02                	add    %al,(%edx)
 6e3:	01 06                	add    %eax,(%esi)
 6e5:	d0 00                	rolb   (%eax)
 6e7:	00 00                	add    %al,(%eax)
 6e9:	03 9d 00 00 00 02    	add    0x2000000(%ebp),%ebx
 6ef:	0d 37 00 00 00       	or     $0x37,%eax
 6f4:	02 01                	add    (%ecx),%al
 6f6:	08 ce                	or     %cl,%dh
 6f8:	00 00                	add    %al,(%eax)
 6fa:	00 02                	add    %al,(%edx)
 6fc:	02 05 55 00 00 00    	add    0x55,%al
 702:	03 30                	add    (%eax),%esi
 704:	03 00                	add    (%eax),%eax
 706:	00 02                	add    %al,(%edx)
 708:	0f 50                	(bad)  
 70a:	00 00                	add    %al,(%eax)
 70c:	00 02                	add    %al,(%edx)
 70e:	02 07                	add    (%edi),%al
 710:	10 01                	adc    %al,(%ecx)
 712:	00 00                	add    %al,(%eax)
 714:	04 04                	add    $0x4,%al
 716:	05 69 6e 74 00       	add    $0x746e69,%eax
 71b:	03 fd                	add    %ebp,%edi
 71d:	00 00                	add    %al,(%eax)
 71f:	00 02                	add    %al,(%edx)
 721:	11 69 00             	adc    %ebp,0x0(%ecx)
 724:	00 00                	add    %al,(%eax)
 726:	02 04 07             	add    (%edi,%eax,1),%al
 729:	f0 00 00             	lock add %al,(%eax)
 72c:	00 02                	add    %al,(%edx)
 72e:	08 05 af 00 00 00    	or     %al,0xaf
 734:	03 fc                	add    %esp,%edi
 736:	01 00                	add    %eax,(%eax)
 738:	00 02                	add    %al,(%edx)
 73a:	13 82 00 00 00 02    	adc    0x2000000(%edx),%eax
 740:	08 07                	or     %al,(%edi)
 742:	e6 00                	out    %al,$0x0
 744:	00 00                	add    %al,(%eax)
 746:	05 10 02 65 d9       	add    $0xd9650210,%eax
 74b:	00 00                	add    %al,(%eax)
 74d:	00 06                	add    %al,(%esi)
 74f:	22 03                	and    (%ebx),%al
 751:	00 00                	add    %al,(%eax)
 753:	02 67 2c             	add    0x2c(%edi),%ah
 756:	00 00                	add    %al,(%eax)
 758:	00 00                	add    %al,(%eax)
 75a:	06                   	push   %es
 75b:	04 03                	add    $0x3,%al
 75d:	00 00                	add    %al,(%eax)
 75f:	02 6a d9             	add    -0x27(%edx),%ch
 762:	00 00                	add    %al,(%eax)
 764:	00 01                	add    %al,(%ecx)
 766:	07                   	pop    %es
 767:	69 64 00 02 6b 2c 00 	imul   $0x2c6b,0x2(%eax,%eax,1),%esp
 76e:	00 
 76f:	00 04 06             	add    %al,(%esi,%eax,1)
 772:	b5 03                	mov    $0x3,%ch
 774:	00 00                	add    %al,(%eax)
 776:	02 6f d9             	add    -0x27(%edi),%ch
 779:	00 00                	add    %al,(%eax)
 77b:	00 05 06 f9 03 00    	add    %al,0x3f906
 781:	00 02                	add    %al,(%edx)
 783:	70 5e                	jo     7e3 <PROT_MODE_DSEG+0x7d3>
 785:	00 00                	add    %al,(%eax)
 787:	00 08                	add    %cl,(%eax)
 789:	06                   	push   %es
 78a:	b5 04                	mov    $0x4,%ch
 78c:	00 00                	add    %al,(%eax)
 78e:	02 71 5e             	add    0x5e(%ecx),%dh
 791:	00 00                	add    %al,(%eax)
 793:	00 0c 00             	add    %cl,(%eax,%eax,1)
 796:	08 2c 00             	or     %ch,(%eax,%eax,1)
 799:	00 00                	add    %al,(%eax)
 79b:	e9 00 00 00 09       	jmp    90007a0 <_end+0x8ff7414>
 7a0:	69 00 00 00 02 00    	imul   $0x20000,(%eax),%eax
 7a6:	0a 6d 62             	or     0x62(%ebp),%ch
 7a9:	72 00                	jb     7ab <PROT_MODE_DSEG+0x79b>
 7ab:	00 02                	add    %al,(%edx)
 7ad:	02 61 2a             	add    0x2a(%ecx),%ah
 7b0:	01 00                	add    %eax,(%eax)
 7b2:	00 06                	add    %al,(%esi)
 7b4:	22 02                	and    (%edx),%al
 7b6:	00 00                	add    %al,(%eax)
 7b8:	02 63 2a             	add    0x2a(%ebx),%ah
 7bb:	01 00                	add    %eax,(%eax)
 7bd:	00 00                	add    %al,(%eax)
 7bf:	0b b6 01 00 00 02    	or     0x2000001(%esi),%esi
 7c5:	64 3b 01             	cmp    %fs:(%ecx),%eax
 7c8:	00 00                	add    %al,(%eax)
 7ca:	b4 01                	mov    $0x1,%ah
 7cc:	0b ba 02 00 00 02    	or     0x2000002(%edx),%edi
 7d2:	72 4b                	jb     81f <PROT_MODE_DSEG+0x80f>
 7d4:	01 00                	add    %eax,(%eax)
 7d6:	00 be 01 0b 22 04    	add    %bh,0x4220b01(%esi)
 7dc:	00 00                	add    %al,(%eax)
 7de:	02 73 5b             	add    0x5b(%ebx),%dh
 7e1:	01 00                	add    %eax,(%eax)
 7e3:	00 fe                	add    %bh,%dh
 7e5:	01 00                	add    %eax,(%eax)
 7e7:	08 2c 00             	or     %ch,(%eax,%eax,1)
 7ea:	00 00                	add    %al,(%eax)
 7ec:	3b 01                	cmp    (%ecx),%eax
 7ee:	00 00                	add    %al,(%eax)
 7f0:	0c 69                	or     $0x69,%al
 7f2:	00 00                	add    %al,(%eax)
 7f4:	00 b3 01 00 08 2c    	add    %dh,0x2c080001(%ebx)
 7fa:	00 00                	add    %al,(%eax)
 7fc:	00 4b 01             	add    %cl,0x1(%ebx)
 7ff:	00 00                	add    %al,(%eax)
 801:	09 69 00             	or     %ebp,0x0(%ecx)
 804:	00 00                	add    %al,(%eax)
 806:	09 00                	or     %eax,(%eax)
 808:	08 89 00 00 00 5b    	or     %cl,0x5b000000(%ecx)
 80e:	01 00                	add    %eax,(%eax)
 810:	00 09                	add    %cl,(%ecx)
 812:	69 00 00 00 03 00    	imul   $0x30000,(%eax),%eax
 818:	08 2c 00             	or     %ch,(%eax,%eax,1)
 81b:	00 00                	add    %al,(%eax)
 81d:	6b 01 00             	imul   $0x0,(%ecx),%eax
 820:	00 09                	add    %cl,(%ecx)
 822:	69 00 00 00 01 00    	imul   $0x10000,(%eax),%eax
 828:	03 98 02 00 00 02    	add    0x2000002(%eax),%ebx
 82e:	74 e9                	je     819 <PROT_MODE_DSEG+0x809>
 830:	00 00                	add    %al,(%eax)
 832:	00 0d 0e 03 00 00    	add    %cl,0x30e
 838:	18 02                	sbb    %al,(%edx)
 83a:	7e b3                	jle    7ef <PROT_MODE_DSEG+0x7df>
 83c:	01 00                	add    %eax,(%eax)
 83e:	00 06                	add    %al,(%esi)
 840:	f4                   	hlt    
 841:	03 00                	add    (%eax),%eax
 843:	00 02                	add    %al,(%edx)
 845:	7f 5e                	jg     8a5 <PROT_MODE_DSEG+0x895>
 847:	00 00                	add    %al,(%eax)
 849:	00 00                	add    %al,(%eax)
 84b:	06                   	push   %es
 84c:	be 03 00 00 02       	mov    $0x2000003,%esi
 851:	80 77 00 00          	xorb   $0x0,0x0(%edi)
 855:	00 04 06             	add    %al,(%esi,%eax,1)
 858:	3e 03 00             	add    %ds:(%eax),%eax
 85b:	00 02                	add    %al,(%edx)
 85d:	81 77 00 00 00 0c 06 	xorl   $0x60c0000,0x0(%edi)
 864:	a0 02 00 00 02       	mov    0x2000002,%al
 869:	82 5e 00 00          	sbbb   $0x0,0x0(%esi)
 86d:	00 14 00             	add    %dl,(%eax,%eax,1)
 870:	03 c4                	add    %esp,%eax
 872:	02 00                	add    (%eax),%al
 874:	00 02                	add    %al,(%edx)
 876:	83 76 01 00          	xorl   $0x0,0x1(%esi)
 87a:	00 0d bf 01 00 00    	add    %cl,0x1bf
 880:	34 02                	xor    $0x2,%al
 882:	8b 7f 02             	mov    0x2(%edi),%edi
 885:	00 00                	add    %al,(%eax)
 887:	06                   	push   %es
 888:	ad                   	lods   %ds:(%esi),%eax
 889:	03 00                	add    (%eax),%eax
 88b:	00 02                	add    %al,(%edx)
 88d:	8c 5e 00             	mov    %ds,0x0(%esi)
 890:	00 00                	add    %al,(%eax)
 892:	00 06                	add    %al,(%esi)
 894:	79 03                	jns    899 <PROT_MODE_DSEG+0x889>
 896:	00 00                	add    %al,(%eax)
 898:	02 8d 7f 02 00 00    	add    0x27f(%ebp),%cl
 89e:	04 06                	add    $0x6,%al
 8a0:	9e                   	sahf   
 8a1:	02 00                	add    (%eax),%al
 8a3:	00 02                	add    %al,(%edx)
 8a5:	8e 45 00             	mov    0x0(%ebp),%es
 8a8:	00 00                	add    %al,(%eax)
 8aa:	10 06                	adc    %al,(%esi)
 8ac:	3d 02 00 00 02       	cmp    $0x2000002,%eax
 8b1:	8f 45 00             	popl   0x0(%ebp)
 8b4:	00 00                	add    %al,(%eax)
 8b6:	12 06                	adc    (%esi),%al
 8b8:	e7 02                	out    %eax,$0x2
 8ba:	00 00                	add    %al,(%eax)
 8bc:	02 90 5e 00 00 00    	add    0x5e(%eax),%dl
 8c2:	14 06                	adc    $0x6,%al
 8c4:	f4                   	hlt    
 8c5:	01 00                	add    %eax,(%eax)
 8c7:	00 02                	add    %al,(%edx)
 8c9:	91                   	xchg   %eax,%ecx
 8ca:	5e                   	pop    %esi
 8cb:	00 00                	add    %al,(%eax)
 8cd:	00 18                	add    %bl,(%eax)
 8cf:	06                   	push   %es
 8d0:	98                   	cwtl   
 8d1:	03 00                	add    (%eax),%eax
 8d3:	00 02                	add    %al,(%edx)
 8d5:	92                   	xchg   %eax,%edx
 8d6:	5e                   	pop    %esi
 8d7:	00 00                	add    %al,(%eax)
 8d9:	00 1c 06             	add    %bl,(%esi,%eax,1)
 8dc:	d1 03                	roll   (%ebx)
 8de:	00 00                	add    %al,(%eax)
 8e0:	02 93 5e 00 00 00    	add    0x5e(%ebx),%dl
 8e6:	20 06                	and    %al,(%esi)
 8e8:	2d 02 00 00 02       	sub    $0x2000002,%eax
 8ed:	94                   	xchg   %eax,%esp
 8ee:	5e                   	pop    %esi
 8ef:	00 00                	add    %al,(%eax)
 8f1:	00 24 06             	add    %ah,(%esi,%eax,1)
 8f4:	b1 02                	mov    $0x2,%cl
 8f6:	00 00                	add    %al,(%eax)
 8f8:	02 95 45 00 00 00    	add    0x45(%ebp),%dl
 8fe:	28 06                	sub    %al,(%esi)
 900:	47                   	inc    %edi
 901:	02 00                	add    (%eax),%al
 903:	00 02                	add    %al,(%edx)
 905:	96                   	xchg   %eax,%esi
 906:	45                   	inc    %ebp
 907:	00 00                	add    %al,(%eax)
 909:	00 2a                	add    %ch,(%edx)
 90b:	06                   	push   %es
 90c:	1a 04 00             	sbb    (%eax,%eax,1),%al
 90f:	00 02                	add    %al,(%edx)
 911:	97                   	xchg   %eax,%edi
 912:	45                   	inc    %ebp
 913:	00 00                	add    %al,(%eax)
 915:	00 2c 06             	add    %ch,(%esi,%eax,1)
 918:	86 02                	xchg   %al,(%edx)
 91a:	00 00                	add    %al,(%eax)
 91c:	02 98 45 00 00 00    	add    0x45(%eax),%bl
 922:	2e 06                	cs push %es
 924:	2c 04                	sub    $0x4,%al
 926:	00 00                	add    %al,(%eax)
 928:	02 99 45 00 00 00    	add    0x45(%ecx),%bl
 92e:	30 06                	xor    %al,(%esi)
 930:	c6 01 00             	movb   $0x0,(%ecx)
 933:	00 02                	add    %al,(%edx)
 935:	9a 45 00 00 00 32 00 	lcall  $0x32,$0x45
 93c:	08 2c 00             	or     %ch,(%eax,%eax,1)
 93f:	00 00                	add    %al,(%eax)
 941:	8f 02                	popl   (%edx)
 943:	00 00                	add    %al,(%eax)
 945:	09 69 00             	or     %ebp,0x0(%ecx)
 948:	00 00                	add    %al,(%eax)
 94a:	0b 00                	or     (%eax),%eax
 94c:	03 db                	add    %ebx,%ebx
 94e:	01 00                	add    %eax,(%eax)
 950:	00 02                	add    %al,(%edx)
 952:	9b                   	fwait
 953:	be 01 00 00 0d       	mov    $0xd000001,%esi
 958:	7e 02                	jle    95c <PROT_MODE_DSEG+0x94c>
 95a:	00 00                	add    %al,(%eax)
 95c:	20 02                	and    %al,(%edx)
 95e:	9e                   	sahf   
 95f:	07                   	pop    %es
 960:	03 00                	add    (%eax),%eax
 962:	00 06                	add    %al,(%esi)
 964:	77 02                	ja     968 <PROT_MODE_DSEG+0x958>
 966:	00 00                	add    %al,(%eax)
 968:	02 9f 5e 00 00 00    	add    0x5e(%edi),%bl
 96e:	00 06                	add    %al,(%esi)
 970:	19 02                	sbb    %eax,(%edx)
 972:	00 00                	add    %al,(%eax)
 974:	02 a0 5e 00 00 00    	add    0x5e(%eax),%ah
 97a:	04 06                	add    $0x6,%al
 97c:	50                   	push   %eax
 97d:	03 00                	add    (%eax),%eax
 97f:	00 02                	add    %al,(%edx)
 981:	a1 5e 00 00 00       	mov    0x5e,%eax
 986:	08 06                	or     %al,(%esi)
 988:	b0 04                	mov    $0x4,%al
 98a:	00 00                	add    %al,(%eax)
 98c:	02 a2 5e 00 00 00    	add    0x5e(%edx),%ah
 992:	0c 06                	or     $0x6,%al
 994:	11 04 00             	adc    %eax,(%eax,%eax,1)
 997:	00 02                	add    %al,(%edx)
 999:	a3 5e 00 00 00       	mov    %eax,0x5e
 99e:	10 06                	adc    %al,(%esi)
 9a0:	11 02                	adc    %eax,(%edx)
 9a2:	00 00                	add    %al,(%eax)
 9a4:	02 a4 5e 00 00 00 14 	add    0x14000000(%esi,%ebx,2),%ah
 9ab:	06                   	push   %es
 9ac:	66 03 00             	add    (%eax),%ax
 9af:	00 02                	add    %al,(%edx)
 9b1:	a5                   	movsl  %ds:(%esi),%es:(%edi)
 9b2:	5e                   	pop    %esi
 9b3:	00 00                	add    %al,(%eax)
 9b5:	00 18                	add    %bl,(%eax)
 9b7:	06                   	push   %es
 9b8:	9e                   	sahf   
 9b9:	04 00                	add    $0x0,%al
 9bb:	00 02                	add    %al,(%edx)
 9bd:	a6                   	cmpsb  %es:(%edi),%ds:(%esi)
 9be:	5e                   	pop    %esi
 9bf:	00 00                	add    %al,(%eax)
 9c1:	00 1c 00             	add    %bl,(%eax,%eax,1)
 9c4:	03 7e 02             	add    0x2(%esi),%edi
 9c7:	00 00                	add    %al,(%eax)
 9c9:	02 a7 9a 02 00 00    	add    0x29a(%edi),%ah
 9cf:	05 04 02 b6 4b       	add    $0x4bb60204,%eax
 9d4:	03 00                	add    (%eax),%eax
 9d6:	00 06                	add    %al,(%esi)
 9d8:	fd                   	std    
 9d9:	02 00                	add    (%eax),%al
 9db:	00 02                	add    %al,(%edx)
 9dd:	b7 2c                	mov    $0x2c,%bh
 9df:	00 00                	add    %al,(%eax)
 9e1:	00 00                	add    %al,(%eax)
 9e3:	06                   	push   %es
 9e4:	f1                   	icebp  
 9e5:	02 00                	add    (%eax),%al
 9e7:	00 02                	add    %al,(%edx)
 9e9:	b8 2c 00 00 00       	mov    $0x2c,%eax
 9ee:	01 06                	add    %eax,(%esi)
 9f0:	f7 02 00 00 02 b9    	testl  $0xb9020000,(%edx)
 9f6:	2c 00                	sub    $0x0,%al
 9f8:	00 00                	add    %al,(%eax)
 9fa:	02 06                	add    (%esi),%al
 9fc:	71 02                	jno    a00 <PROT_MODE_DSEG+0x9f0>
 9fe:	00 00                	add    %al,(%eax)
 a00:	02 ba 2c 00 00 00    	add    0x2c(%edx),%bh
 a06:	03 00                	add    (%eax),%eax
 a08:	05 10 02 c7 84       	add    $0x84c70210,%eax
 a0d:	03 00                	add    (%eax),%eax
 a0f:	00 06                	add    %al,(%esi)
 a11:	f1                   	icebp  
 a12:	03 00                	add    (%eax),%eax
 a14:	00 02                	add    %al,(%edx)
 a16:	c8 5e 00 00          	enter  $0x5e,$0x0
 a1a:	00 00                	add    %al,(%eax)
 a1c:	06                   	push   %es
 a1d:	69 02 00 00 02 c9    	imul   $0xc9020000,(%edx),%eax
 a23:	5e                   	pop    %esi
 a24:	00 00                	add    %al,(%eax)
 a26:	00 04 06             	add    %al,(%esi,%eax,1)
 a29:	c3                   	ret    
 a2a:	03 00                	add    (%eax),%eax
 a2c:	00 02                	add    %al,(%edx)
 a2e:	ca 5e 00             	lret   $0x5e
 a31:	00 00                	add    %al,(%eax)
 a33:	08 06                	or     %al,(%esi)
 a35:	68 04 00 00 02       	push   $0x2000004
 a3a:	cb                   	lret   
 a3b:	5e                   	pop    %esi
 a3c:	00 00                	add    %al,(%eax)
 a3e:	00 0c 00             	add    %cl,(%eax,%eax,1)
 a41:	05 10 02 cd bd       	add    $0xbdcd0210,%eax
 a46:	03 00                	add    (%eax),%eax
 a48:	00 07                	add    %al,(%edi)
 a4a:	6e                   	outsb  %ds:(%esi),(%dx)
 a4b:	75 6d                	jne    aba <PROT_MODE_DSEG+0xaaa>
 a4d:	00 02                	add    %al,(%edx)
 a4f:	ce                   	into   
 a50:	5e                   	pop    %esi
 a51:	00 00                	add    %al,(%eax)
 a53:	00 00                	add    %al,(%eax)
 a55:	06                   	push   %es
 a56:	f4                   	hlt    
 a57:	03 00                	add    (%eax),%eax
 a59:	00 02                	add    %al,(%edx)
 a5b:	cf                   	iret   
 a5c:	5e                   	pop    %esi
 a5d:	00 00                	add    %al,(%eax)
 a5f:	00 04 06             	add    %al,(%esi,%eax,1)
 a62:	c3                   	ret    
 a63:	03 00                	add    (%eax),%eax
 a65:	00 02                	add    %al,(%edx)
 a67:	d0 5e 00             	rcrb   0x0(%esi)
 a6a:	00 00                	add    %al,(%eax)
 a6c:	08 06                	or     %al,(%esi)
 a6e:	92                   	xchg   %eax,%edx
 a6f:	02 00                	add    (%eax),%al
 a71:	00 02                	add    %al,(%edx)
 a73:	d1 5e 00             	rcrl   0x0(%esi)
 a76:	00 00                	add    %al,(%eax)
 a78:	0c 00                	or     $0x0,%al
 a7a:	0e                   	push   %cs
 a7b:	10 02                	adc    %al,(%edx)
 a7d:	c6                   	(bad)  
 a7e:	dc 03                	faddl  (%ebx)
 a80:	00 00                	add    %al,(%eax)
 a82:	0f 8b 03 00 00 02    	jnp    2000a8b <_end+0x1ff76ff>
 a88:	cc                   	int3   
 a89:	4b                   	dec    %ebx
 a8a:	03 00                	add    (%eax),%eax
 a8c:	00 10                	add    %dl,(%eax)
 a8e:	65 6c                	gs insb (%dx),%es:(%edi)
 a90:	66 00 02             	data16 add %al,(%edx)
 a93:	d2 84 03 00 00 00 0d 	rolb   %cl,0xd000000(%ebx,%eax,1)
 a9a:	45                   	inc    %ebp
 a9b:	03 00                	add    (%eax),%eax
 a9d:	00 60 02             	add    %ah,0x2(%eax)
 aa0:	ae                   	scas   %es:(%edi),%al
 aa1:	e5 04                	in     $0x4,%eax
 aa3:	00 00                	add    %al,(%eax)
 aa5:	06                   	push   %es
 aa6:	2f                   	das    
 aa7:	02 00                	add    (%eax),%al
 aa9:	00 02                	add    %al,(%edx)
 aab:	af                   	scas   %es:(%edi),%eax
 aac:	5e                   	pop    %esi
 aad:	00 00                	add    %al,(%eax)
 aaf:	00 00                	add    %al,(%eax)
 ab1:	06                   	push   %es
 ab2:	18 03                	sbb    %al,(%ebx)
 ab4:	00 00                	add    %al,(%eax)
 ab6:	02 b2 5e 00 00 00    	add    0x5e(%edx),%dh
 abc:	04 06                	add    $0x6,%al
 abe:	d9 03                	flds   (%ebx)
 ac0:	00 00                	add    %al,(%eax)
 ac2:	02 b3 5e 00 00 00    	add    0x5e(%ebx),%dh
 ac8:	08 06                	or     %al,(%esi)
 aca:	7f 03                	jg     acf <PROT_MODE_DSEG+0xabf>
 acc:	00 00                	add    %al,(%eax)
 ace:	02 bb 12 03 00 00    	add    0x312(%ebx),%bh
 ad4:	0c 06                	or     $0x6,%al
 ad6:	35 02 00 00 02       	xor    $0x2000002,%eax
 adb:	be 5e 00 00 00       	mov    $0x5e,%esi
 ae0:	10 06                	adc    %al,(%esi)
 ae2:	5d                   	pop    %ebp
 ae3:	04 00                	add    $0x0,%al
 ae5:	00 02                	add    %al,(%edx)
 ae7:	c2 5e 00             	ret    $0x5e
 aea:	00 00                	add    %al,(%eax)
 aec:	14 06                	adc    $0x6,%al
 aee:	5f                   	pop    %edi
 aef:	02 00                	add    (%eax),%al
 af1:	00 02                	add    %al,(%edx)
 af3:	c3                   	ret    
 af4:	5e                   	pop    %esi
 af5:	00 00                	add    %al,(%eax)
 af7:	00 18                	add    %bl,(%eax)
 af9:	06                   	push   %es
 afa:	2b 03                	sub    (%ebx),%eax
 afc:	00 00                	add    %al,(%eax)
 afe:	02 d3                	add    %bl,%dl
 b00:	bd 03 00 00 1c       	mov    $0x1c000003,%ebp
 b05:	06                   	push   %es
 b06:	39 03                	cmp    %eax,(%ebx)
 b08:	00 00                	add    %al,(%eax)
 b0a:	02 d6                	add    %dh,%dl
 b0c:	5e                   	pop    %esi
 b0d:	00 00                	add    %al,(%eax)
 b0f:	00 2c 06             	add    %ch,(%esi,%eax,1)
 b12:	d1 01                	roll   (%ecx)
 b14:	00 00                	add    %al,(%eax)
 b16:	02 d8                	add    %al,%bl
 b18:	5e                   	pop    %esi
 b19:	00 00                	add    %al,(%eax)
 b1b:	00 30                	add    %dh,(%eax)
 b1d:	06                   	push   %es
 b1e:	03 04 00             	add    (%eax,%eax,1),%eax
 b21:	00 02                	add    %al,(%edx)
 b23:	dc 5e 00             	fcompl 0x0(%esi)
 b26:	00 00                	add    %al,(%eax)
 b28:	34 06                	xor    $0x6,%al
 b2a:	a5                   	movsl  %ds:(%esi),%es:(%edi)
 b2b:	02 00                	add    (%eax),%al
 b2d:	00 02                	add    %al,(%edx)
 b2f:	dd 5e 00             	fstpl  0x0(%esi)
 b32:	00 00                	add    %al,(%eax)
 b34:	38 06                	cmp    %al,(%esi)
 b36:	a0 03 00 00 02       	mov    0x2000003,%al
 b3b:	e0 5e                	loopne b9b <PROT_MODE_DSEG+0xb8b>
 b3d:	00 00                	add    %al,(%eax)
 b3f:	00 3c 06             	add    %bh,(%esi,%eax,1)
 b42:	72 04                	jb     b48 <PROT_MODE_DSEG+0xb38>
 b44:	00 00                	add    %al,(%eax)
 b46:	02 e3                	add    %bl,%ah
 b48:	5e                   	pop    %esi
 b49:	00 00                	add    %al,(%eax)
 b4b:	00 40 06             	add    %al,0x6(%eax)
 b4e:	a6                   	cmpsb  %es:(%edi),%ds:(%esi)
 b4f:	04 00                	add    $0x0,%al
 b51:	00 02                	add    %al,(%edx)
 b53:	e6 5e                	out    %al,$0x5e
 b55:	00 00                	add    %al,(%eax)
 b57:	00 44 06 55          	add    %al,0x55(%esi,%eax,1)
 b5b:	03 00                	add    (%eax),%eax
 b5d:	00 02                	add    %al,(%edx)
 b5f:	e9 5e 00 00 00       	jmp    bc2 <PROT_MODE_DSEG+0xbb2>
 b64:	48                   	dec    %eax
 b65:	06                   	push   %es
 b66:	e3 03                	jecxz  b6b <PROT_MODE_DSEG+0xb5b>
 b68:	00 00                	add    %al,(%eax)
 b6a:	02 ea                	add    %dl,%ch
 b6c:	5e                   	pop    %esi
 b6d:	00 00                	add    %al,(%eax)
 b6f:	00 4c 06 c8          	add    %cl,-0x38(%esi,%eax,1)
 b73:	03 00                	add    (%eax),%eax
 b75:	00 02                	add    %al,(%edx)
 b77:	eb 5e                	jmp    bd7 <PROT_MODE_DSEG+0xbc7>
 b79:	00 00                	add    %al,(%eax)
 b7b:	00 50 06             	add    %dl,0x6(%eax)
 b7e:	83 04 00 00          	addl   $0x0,(%eax,%eax,1)
 b82:	02 ec                	add    %ah,%ch
 b84:	5e                   	pop    %esi
 b85:	00 00                	add    %al,(%eax)
 b87:	00 54 06 e2          	add    %dl,-0x1e(%esi,%eax,1)
 b8b:	01 00                	add    %eax,(%eax)
 b8d:	00 02                	add    %al,(%edx)
 b8f:	ed                   	in     (%dx),%eax
 b90:	5e                   	pop    %esi
 b91:	00 00                	add    %al,(%eax)
 b93:	00 58 06             	add    %bl,0x6(%eax)
 b96:	34 04                	xor    $0x4,%al
 b98:	00 00                	add    %al,(%eax)
 b9a:	02 ee                	add    %dh,%ch
 b9c:	5e                   	pop    %esi
 b9d:	00 00                	add    %al,(%eax)
 b9f:	00 5c 00 03          	add    %bl,0x3(%eax,%eax,1)
 ba3:	d0 02                	rolb   (%edx)
 ba5:	00 00                	add    %al,(%eax)
 ba7:	02 ef                	add    %bh,%ch
 ba9:	dc 03                	faddl  (%ebx)
 bab:	00 00                	add    %al,(%eax)
 bad:	11 45 03             	adc    %eax,0x3(%ebp)
 bb0:	00 00                	add    %al,(%eax)
 bb2:	01 13                	add    %edx,(%ebx)
 bb4:	e5 04                	in     $0x4,%eax
 bb6:	00 00                	add    %al,(%eax)
 bb8:	05 03 00 93 00       	add    $0x930003,%eax
 bbd:	00 12                	add    %dl,(%edx)
 bbf:	6e                   	outsb  %ds:(%esi),(%dx)
 bc0:	03 00                	add    (%eax),%eax
 bc2:	00 01                	add    %al,(%ecx)
 bc4:	51                   	push   %ecx
 bc5:	57                   	push   %edi
 bc6:	05 00 00 46 8e       	add    $0x8e460000,%eax
 bcb:	00 00                	add    %al,(%eax)
 bcd:	70 00                	jo     bcf <PROT_MODE_DSEG+0xbbf>
 bcf:	00 00                	add    %al,(%eax)
 bd1:	01 9c 57 05 00 00 13 	add    %ebx,0x13000005(%edi,%edx,2)
 bd8:	13 03                	adc    (%ebx),%eax
 bda:	00 00                	add    %al,(%eax)
 bdc:	01 51 5d             	add    %edx,0x5d(%ecx)
 bdf:	05 00 00 02 91       	add    $0x91020000,%eax
 be4:	00 14 70             	add    %dl,(%eax,%esi,2)
 be7:	00 01                	add    %al,(%ecx)
 be9:	53                   	push   %ebx
 bea:	5d                   	pop    %ebp
 beb:	05 00 00 e5 03       	add    $0x3e50000,%eax
 bf0:	00 00                	add    %al,(%eax)
 bf2:	15 95 04 00 00       	adc    $0x495,%eax
 bf7:	01 54 5e 00          	add    %edx,0x0(%esi,%ebx,2)
 bfb:	00 00                	add    %al,(%eax)
 bfd:	53                   	push   %ebx
 bfe:	04 00                	add    $0x0,%al
 c00:	00 16                	add    %dl,(%esi)
 c02:	6b 8e 00 00 4e 06 00 	imul   $0x0,0x64e0000(%esi),%ecx
 c09:	00 16                	add    %dl,(%esi)
 c0b:	86 8e 00 00 59 06    	xchg   %cl,0x6590000(%esi)
 c11:	00 00                	add    %al,(%eax)
 c13:	00 17                	add    %dl,(%edi)
 c15:	04 e5                	add    $0xe5,%al
 c17:	04 00                	add    $0x0,%al
 c19:	00 17                	add    %dl,(%edi)
 c1b:	04 b3                	add    $0xb3,%al
 c1d:	01 00                	add    %eax,(%eax)
 c1f:	00 12                	add    %dl,(%edx)
 c21:	05 02 00 00 01       	add    $0x1000002,%eax
 c26:	39 5e 00             	cmp    %ebx,0x0(%esi)
 c29:	00 00                	add    %al,(%eax)
 c2b:	b7 8d                	mov    $0x8d,%bh
 c2d:	00 00                	add    %al,(%eax)
 c2f:	8f 00                	popl   (%eax)
 c31:	00 00                	add    %al,(%eax)
 c33:	01 9c c3 05 00 00 13 	add    %ebx,0x13000005(%ebx,%eax,8)
 c3a:	90                   	nop
 c3b:	03 00                	add    (%eax),%eax
 c3d:	00 01                	add    %al,(%ecx)
 c3f:	39 5e 00             	cmp    %ebx,0x0(%esi)
 c42:	00 00                	add    %al,(%eax)
 c44:	02 91 00 14 70 68    	add    0x68701400(%ecx),%dl
 c4a:	00 01                	add    %al,(%ecx)
 c4c:	3c c3                	cmp    $0xc3,%al
 c4e:	05 00 00 99 04       	add    $0x4990000,%eax
 c53:	00 00                	add    %al,(%eax)
 c55:	14 65                	adc    $0x65,%al
 c57:	70 68                	jo     cc1 <PROT_MODE_DSEG+0xcb1>
 c59:	00 01                	add    %al,(%ecx)
 c5b:	3c c3                	cmp    $0xc3,%al
 c5d:	05 00 00 c4 04       	add    $0x4c40000,%eax
 c62:	00 00                	add    %al,(%eax)
 c64:	16                   	push   %ss
 c65:	df 8d 00 00 64 06    	fisttps 0x6640000(%ebp)
 c6b:	00 00                	add    %al,(%eax)
 c6d:	16                   	push   %ss
 c6e:	fd                   	std    
 c6f:	8d 00                	lea    (%eax),%eax
 c71:	00 6f 06             	add    %ch,0x6(%edi)
 c74:	00 00                	add    %al,(%eax)
 c76:	16                   	push   %ss
 c77:	2f                   	das    
 c78:	8e 00                	mov    (%eax),%es
 c7a:	00 64 06 00          	add    %ah,0x0(%esi,%eax,1)
 c7e:	00 00                	add    %al,(%eax)
 c80:	17                   	pop    %ss
 c81:	04 07                	add    $0x7,%al
 c83:	03 00                	add    (%eax),%eax
 c85:	00 18                	add    %bl,(%eax)
 c87:	dd 02                	fldl   (%edx)
 c89:	00 00                	add    %al,(%eax)
 c8b:	01 1e                	add    %ebx,(%esi)
 c8d:	b6 8e                	mov    $0x8e,%dh
 c8f:	00 00                	add    %al,(%eax)
 c91:	8f 00                	popl   (%eax)
 c93:	00 00                	add    %al,(%eax)
 c95:	01 9c 48 06 00 00 19 	add    %ebx,0x19000006(%eax,%ecx,2)
 c9c:	6d                   	insl   (%dx),%es:(%edi)
 c9d:	62 72 00             	bound  %esi,0x0(%edx)
 ca0:	01 1e                	add    %ebx,(%esi)
 ca2:	48                   	dec    %eax
 ca3:	06                   	push   %es
 ca4:	00 00                	add    %al,(%eax)
 ca6:	02 91 00 13 13 03    	add    0x3131300(%ecx),%dl
 cac:	00 00                	add    %al,(%eax)
 cae:	01 1e                	add    %ebx,(%esi)
 cb0:	5d                   	pop    %ebp
 cb1:	05 00 00 02 91       	add    $0x91020000,%eax
 cb6:	04 1a                	add    $0x1a,%al
 cb8:	78 00                	js     cba <PROT_MODE_DSEG+0xcaa>
 cba:	00 00                	add    %al,(%eax)
 cbc:	2c 06                	sub    $0x6,%al
 cbe:	00 00                	add    %al,(%eax)
 cc0:	14 6d                	adc    $0x6d,%al
 cc2:	00 01                	add    %al,(%ecx)
 cc4:	29 57 00             	sub    %edx,0x0(%edi)
 cc7:	00 00                	add    %al,(%eax)
 cc9:	d7                   	xlat   %ds:(%ebx)
 cca:	04 00                	add    $0x0,%al
 ccc:	00 16                	add    %dl,(%esi)
 cce:	07                   	pop    %es
 ccf:	8f 00                	popl   (%eax)
 cd1:	00 01                	add    %al,(%ecx)
 cd3:	05 00 00 16 11       	add    $0x11160000,%eax
 cd8:	8f 00                	popl   (%eax)
 cda:	00 63 05             	add    %ah,0x5(%ebx)
 cdd:	00 00                	add    %al,(%eax)
 cdf:	16                   	push   %ss
 ce0:	20 8f 00 00 7a 06    	and    %cl,0x67a0000(%edi)
 ce6:	00 00                	add    %al,(%eax)
 ce8:	00 16                	add    %dl,(%esi)
 cea:	d6                   	(bad)  
 ceb:	8e 00                	mov    (%eax),%es
 ced:	00 85 06 00 00 16    	add    %al,0x16000006(%ebp)
 cf3:	e4 8e                	in     $0x8e,%al
 cf5:	00 00                	add    %al,(%eax)
 cf7:	4e                   	dec    %esi
 cf8:	06                   	push   %es
 cf9:	00 00                	add    %al,(%eax)
 cfb:	16                   	push   %ss
 cfc:	3a 8f 00 00 6f 06    	cmp    0x66f0000(%edi),%cl
 d02:	00 00                	add    %al,(%eax)
 d04:	00 17                	add    %dl,(%edi)
 d06:	04 6b                	add    $0x6b,%al
 d08:	01 00                	add    %eax,(%eax)
 d0a:	00 1b                	add    %bl,(%ebx)
 d0c:	4d                   	dec    %ebp
 d0d:	00 00                	add    %al,(%eax)
 d0f:	00 4d 00             	add    %cl,0x0(%ebp)
 d12:	00 00                	add    %al,(%eax)
 d14:	02 4f 1b             	add    0x1b(%edi),%cl
 d17:	77 00                	ja     d19 <PROT_MODE_DSEG+0xd09>
 d19:	00 00                	add    %al,(%eax)
 d1b:	77 00                	ja     d1d <PROT_MODE_DSEG+0xd0d>
 d1d:	00 00                	add    %al,(%eax)
 d1f:	02 50 1b             	add    0x1b(%eax),%dl
 d22:	bd 00 00 00 bd       	mov    $0xbd000000,%ebp
 d27:	00 00                	add    %al,(%eax)
 d29:	00 02                	add    %al,(%edx)
 d2b:	78 1b                	js     d48 <PROT_MODE_DSEG+0xd38>
 d2d:	71 00                	jno    d2f <PROT_MODE_DSEG+0xd1f>
 d2f:	00 00                	add    %al,(%eax)
 d31:	71 00                	jno    d33 <PROT_MODE_DSEG+0xd23>
 d33:	00 00                	add    %al,(%eax)
 d35:	02 52 1b             	add    0x1b(%edx),%dl
 d38:	53                   	push   %ebx
 d39:	02 00                	add    (%eax),%al
 d3b:	00 53 02             	add    %dl,0x2(%ebx)
 d3e:	00 00                	add    %al,(%eax)
 d40:	01 11                	add    %edx,(%ecx)
 d42:	1b 65 00             	sbb    0x0(%ebp),%esp
 d45:	00 00                	add    %al,(%eax)
 d47:	65 00 00             	add    %al,%gs:(%eax)
 d4a:	00 02                	add    %al,(%edx)
 d4c:	51                   	push   %ecx
 d4d:	00 22                	add    %ah,(%edx)
 d4f:	00 00                	add    %al,(%eax)
 d51:	00 02                	add    %al,(%edx)
 d53:	00 9e 03 00 00 04    	add    %bl,0x4000003(%esi)
 d59:	01 b3 02 00 00 49    	add    %esi,0x49000002(%ebx)
 d5f:	8f 00                	popl   (%eax)
 d61:	00 59 8f             	add    %bl,-0x71(%ecx)
 d64:	00 00                	add    %al,(%eax)
 d66:	c3                   	ret    
 d67:	04 00                	add    $0x0,%al
 d69:	00 13                	add    %dl,(%ebx)
 d6b:	00 00                	add    %al,(%eax)
 d6d:	00 31                	add    %dh,(%ecx)
 d6f:	00 00                	add    %al,(%eax)
 d71:	00 01                	add    %al,(%ecx)
 d73:	80                   	.byte 0x80

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	01 11                	add    %edx,(%ecx)
   2:	00 10                	add    %dl,(%eax)
   4:	06                   	push   %es
   5:	11 01                	adc    %eax,(%ecx)
   7:	12 01                	adc    (%ecx),%al
   9:	03 0e                	add    (%esi),%ecx
   b:	1b 0e                	sbb    (%esi),%ecx
   d:	25 0e 13 05 00       	and    $0x5130e,%eax
  12:	00 00                	add    %al,(%eax)
  14:	01 11                	add    %edx,(%ecx)
  16:	01 25 0e 13 0b 03    	add    %esp,0x30b130e
  1c:	0e                   	push   %cs
  1d:	1b 0e                	sbb    (%esi),%ecx
  1f:	11 01                	adc    %eax,(%ecx)
  21:	12 06                	adc    (%esi),%al
  23:	10 17                	adc    %dl,(%edi)
  25:	00 00                	add    %al,(%eax)
  27:	02 24 00             	add    (%eax,%eax,1),%ah
  2a:	0b 0b                	or     (%ebx),%ecx
  2c:	3e 0b 03             	or     %ds:(%ebx),%eax
  2f:	0e                   	push   %cs
  30:	00 00                	add    %al,(%eax)
  32:	03 16                	add    (%esi),%edx
  34:	00 03                	add    %al,(%ebx)
  36:	0e                   	push   %cs
  37:	3a 0b                	cmp    (%ebx),%cl
  39:	3b 0b                	cmp    (%ebx),%ecx
  3b:	49                   	dec    %ecx
  3c:	13 00                	adc    (%eax),%eax
  3e:	00 04 24             	add    %al,(%esp)
  41:	00 0b                	add    %cl,(%ebx)
  43:	0b 3e                	or     (%esi),%edi
  45:	0b 03                	or     (%ebx),%eax
  47:	08 00                	or     %al,(%eax)
  49:	00 05 34 00 03 0e    	add    %al,0xe030034
  4f:	3a 0b                	cmp    (%ebx),%cl
  51:	3b 0b                	cmp    (%ebx),%ecx
  53:	49                   	dec    %ecx
  54:	13 3f                	adc    (%edi),%edi
  56:	19 02                	sbb    %eax,(%edx)
  58:	18 00                	sbb    %al,(%eax)
  5a:	00 06                	add    %al,(%esi)
  5c:	0f 00 0b             	str    (%ebx)
  5f:	0b 49 13             	or     0x13(%ecx),%ecx
  62:	00 00                	add    %al,(%eax)
  64:	07                   	pop    %es
  65:	35 00 49 13 00       	xor    $0x134900,%eax
  6a:	00 08                	add    %cl,(%eax)
  6c:	26 00 49 13          	add    %cl,%es:0x13(%ecx)
  70:	00 00                	add    %al,(%eax)
  72:	09 34 00             	or     %esi,(%eax,%eax,1)
  75:	03 08                	add    (%eax),%ecx
  77:	3a 0b                	cmp    (%ebx),%cl
  79:	3b 0b                	cmp    (%ebx),%ecx
  7b:	49                   	dec    %ecx
  7c:	13 02                	adc    (%edx),%eax
  7e:	18 00                	sbb    %al,(%eax)
  80:	00 0a                	add    %cl,(%edx)
  82:	01 01                	add    %eax,(%ecx)
  84:	49                   	dec    %ecx
  85:	13 01                	adc    (%ecx),%eax
  87:	13 00                	adc    (%eax),%eax
  89:	00 0b                	add    %cl,(%ebx)
  8b:	21 00                	and    %eax,(%eax)
  8d:	49                   	dec    %ecx
  8e:	13 2f                	adc    (%edi),%ebp
  90:	0b 00                	or     (%eax),%eax
  92:	00 0c 34             	add    %cl,(%esp,%esi,1)
  95:	00 03                	add    %al,(%ebx)
  97:	0e                   	push   %cs
  98:	3a 0b                	cmp    (%ebx),%cl
  9a:	3b 0b                	cmp    (%ebx),%ecx
  9c:	49                   	dec    %ecx
  9d:	13 02                	adc    (%edx),%eax
  9f:	18 00                	sbb    %al,(%eax)
  a1:	00 0d 2e 01 3f 19    	add    %cl,0x193f012e
  a7:	03 0e                	add    (%esi),%ecx
  a9:	3a 0b                	cmp    (%ebx),%cl
  ab:	3b 0b                	cmp    (%ebx),%ecx
  ad:	27                   	daa    
  ae:	19 11                	sbb    %edx,(%ecx)
  b0:	01 12                	add    %edx,(%edx)
  b2:	06                   	push   %es
  b3:	40                   	inc    %eax
  b4:	18 97 42 19 01 13    	sbb    %dl,0x13011942(%edi)
  ba:	00 00                	add    %al,(%eax)
  bc:	0e                   	push   %cs
  bd:	05 00 03 08 3a       	add    $0x3a080300,%eax
  c2:	0b 3b                	or     (%ebx),%edi
  c4:	0b 49 13             	or     0x13(%ecx),%ecx
  c7:	02 17                	add    (%edi),%dl
  c9:	00 00                	add    %al,(%eax)
  cb:	0f 05                	syscall 
  cd:	00 03                	add    %al,(%ebx)
  cf:	0e                   	push   %cs
  d0:	3a 0b                	cmp    (%ebx),%cl
  d2:	3b 0b                	cmp    (%ebx),%ecx
  d4:	49                   	dec    %ecx
  d5:	13 02                	adc    (%edx),%eax
  d7:	18 00                	sbb    %al,(%eax)
  d9:	00 10                	add    %dl,(%eax)
  db:	05 00 03 0e 3a       	add    $0x3a0e0300,%eax
  e0:	0b 3b                	or     (%ebx),%edi
  e2:	0b 49 13             	or     0x13(%ecx),%ecx
  e5:	02 17                	add    (%edi),%dl
  e7:	00 00                	add    %al,(%eax)
  e9:	11 05 00 03 08 3a    	adc    %eax,0x3a080300
  ef:	0b 3b                	or     (%ebx),%edi
  f1:	0b 49 13             	or     0x13(%ecx),%ecx
  f4:	02 18                	add    (%eax),%bl
  f6:	00 00                	add    %al,(%eax)
  f8:	12 34 00             	adc    (%eax,%eax,1),%dh
  fb:	03 0e                	add    (%esi),%ecx
  fd:	3a 0b                	cmp    (%ebx),%cl
  ff:	3b 0b                	cmp    (%ebx),%ecx
 101:	49                   	dec    %ecx
 102:	13 02                	adc    (%edx),%eax
 104:	17                   	pop    %ss
 105:	00 00                	add    %al,(%eax)
 107:	13 89 82 01 00 11    	adc    0x11000182(%ecx),%ecx
 10d:	01 31                	add    %esi,(%ecx)
 10f:	13 00                	adc    (%eax),%eax
 111:	00 14 1d 01 31 13 52 	add    %dl,0x52133101(,%ebx,1)
 118:	01 55 17             	add    %edx,0x17(%ebp)
 11b:	58                   	pop    %eax
 11c:	0b 59 0b             	or     0xb(%ecx),%ebx
 11f:	01 13                	add    %edx,(%ebx)
 121:	00 00                	add    %al,(%eax)
 123:	15 1d 01 31 13       	adc    $0x1331011d,%eax
 128:	52                   	push   %edx
 129:	01 55 17             	add    %edx,0x17(%ebp)
 12c:	58                   	pop    %eax
 12d:	0b 59 0b             	or     0xb(%ecx),%ebx
 130:	00 00                	add    %al,(%eax)
 132:	16                   	push   %ss
 133:	05 00 31 13 02       	add    $0x2133100,%eax
 138:	17                   	pop    %ss
 139:	00 00                	add    %al,(%eax)
 13b:	17                   	pop    %ss
 13c:	0b 01                	or     (%ecx),%eax
 13e:	55                   	push   %ebp
 13f:	17                   	pop    %ss
 140:	00 00                	add    %al,(%eax)
 142:	18 34 00             	sbb    %dh,(%eax,%eax,1)
 145:	31 13                	xor    %edx,(%ebx)
 147:	00 00                	add    %al,(%eax)
 149:	19 1d 01 31 13 11    	sbb    %ebx,0x11133101
 14f:	01 12                	add    %edx,(%edx)
 151:	06                   	push   %es
 152:	58                   	pop    %eax
 153:	0b 59 0b             	or     0xb(%ecx),%ebx
 156:	01 13                	add    %edx,(%ebx)
 158:	00 00                	add    %al,(%eax)
 15a:	1a 1d 01 31 13 11    	sbb    0x11133101,%bl
 160:	01 12                	add    %edx,(%edx)
 162:	06                   	push   %es
 163:	58                   	pop    %eax
 164:	0b 59 0b             	or     0xb(%ecx),%ebx
 167:	00 00                	add    %al,(%eax)
 169:	1b 0b                	sbb    (%ebx),%ecx
 16b:	01 11                	add    %edx,(%ecx)
 16d:	01 12                	add    %edx,(%edx)
 16f:	06                   	push   %es
 170:	00 00                	add    %al,(%eax)
 172:	1c 0f                	sbb    $0xf,%al
 174:	00 0b                	add    %cl,(%ebx)
 176:	0b 00                	or     (%eax),%eax
 178:	00 1d 2e 00 03 0e    	add    %bl,0xe03002e
 17e:	3a 0b                	cmp    (%ebx),%cl
 180:	3b 0b                	cmp    (%ebx),%ecx
 182:	27                   	daa    
 183:	19 20                	sbb    %esp,(%eax)
 185:	0b 00                	or     (%eax),%eax
 187:	00 1e                	add    %bl,(%esi)
 189:	34 00                	xor    $0x0,%al
 18b:	03 08                	add    (%eax),%ecx
 18d:	3a 0b                	cmp    (%ebx),%cl
 18f:	3b 0b                	cmp    (%ebx),%ecx
 191:	49                   	dec    %ecx
 192:	13 02                	adc    (%edx),%eax
 194:	17                   	pop    %ss
 195:	00 00                	add    %al,(%eax)
 197:	1f                   	pop    %ds
 198:	89 82 01 00 11 01    	mov    %eax,0x1110001(%edx)
 19e:	95                   	xchg   %eax,%ebp
 19f:	42                   	inc    %edx
 1a0:	19 31                	sbb    %esi,(%ecx)
 1a2:	13 00                	adc    (%eax),%eax
 1a4:	00 20                	add    %ah,(%eax)
 1a6:	2e 01 3f             	add    %edi,%cs:(%edi)
 1a9:	19 03                	sbb    %eax,(%ebx)
 1ab:	0e                   	push   %cs
 1ac:	3a 0b                	cmp    (%ebx),%cl
 1ae:	3b 0b                	cmp    (%ebx),%ecx
 1b0:	27                   	daa    
 1b1:	19 49 13             	sbb    %ecx,0x13(%ecx)
 1b4:	11 01                	adc    %eax,(%ecx)
 1b6:	12 06                	adc    (%esi),%al
 1b8:	40                   	inc    %eax
 1b9:	18 97 42 19 01 13    	sbb    %dl,0x13011942(%edi)
 1bf:	00 00                	add    %al,(%eax)
 1c1:	21 2e                	and    %ebp,(%esi)
 1c3:	01 03                	add    %eax,(%ebx)
 1c5:	0e                   	push   %cs
 1c6:	3a 0b                	cmp    (%ebx),%cl
 1c8:	3b 0b                	cmp    (%ebx),%ecx
 1ca:	27                   	daa    
 1cb:	19 20                	sbb    %esp,(%eax)
 1cd:	0b 01                	or     (%ecx),%eax
 1cf:	13 00                	adc    (%eax),%eax
 1d1:	00 22                	add    %ah,(%edx)
 1d3:	05 00 03 0e 3a       	add    $0x3a0e0300,%eax
 1d8:	0b 3b                	or     (%ebx),%edi
 1da:	0b 49 13             	or     0x13(%ecx),%ecx
 1dd:	00 00                	add    %al,(%eax)
 1df:	23 05 00 03 08 3a    	and    0x3a080300,%eax
 1e5:	0b 3b                	or     (%ebx),%edi
 1e7:	0b 49 13             	or     0x13(%ecx),%ecx
 1ea:	00 00                	add    %al,(%eax)
 1ec:	24 2e                	and    $0x2e,%al
 1ee:	01 03                	add    %eax,(%ebx)
 1f0:	08 3a                	or     %bh,(%edx)
 1f2:	0b 3b                	or     (%ebx),%edi
 1f4:	0b 27                	or     (%edi),%esp
 1f6:	19 49 13             	sbb    %ecx,0x13(%ecx)
 1f9:	20 0b                	and    %cl,(%ebx)
 1fb:	01 13                	add    %edx,(%ebx)
 1fd:	00 00                	add    %al,(%eax)
 1ff:	25 34 00 03 0e       	and    $0xe030034,%eax
 204:	3a 0b                	cmp    (%ebx),%cl
 206:	3b 0b                	cmp    (%ebx),%ecx
 208:	49                   	dec    %ecx
 209:	13 00                	adc    (%eax),%eax
 20b:	00 26                	add    %ah,(%esi)
 20d:	2e 01 03             	add    %eax,%cs:(%ebx)
 210:	0e                   	push   %cs
 211:	3a 0b                	cmp    (%ebx),%cl
 213:	3b 0b                	cmp    (%ebx),%ecx
 215:	27                   	daa    
 216:	19 20                	sbb    %esp,(%eax)
 218:	0b 00                	or     (%eax),%eax
 21a:	00 00                	add    %al,(%eax)
 21c:	01 11                	add    %edx,(%ecx)
 21e:	01 25 0e 13 0b 03    	add    %esp,0x30b130e
 224:	0e                   	push   %cs
 225:	1b 0e                	sbb    (%esi),%ecx
 227:	11 01                	adc    %eax,(%ecx)
 229:	12 06                	adc    (%esi),%al
 22b:	10 17                	adc    %dl,(%edi)
 22d:	00 00                	add    %al,(%eax)
 22f:	02 24 00             	add    (%eax,%eax,1),%ah
 232:	0b 0b                	or     (%ebx),%ecx
 234:	3e 0b 03             	or     %ds:(%ebx),%eax
 237:	0e                   	push   %cs
 238:	00 00                	add    %al,(%eax)
 23a:	03 16                	add    (%esi),%edx
 23c:	00 03                	add    %al,(%ebx)
 23e:	0e                   	push   %cs
 23f:	3a 0b                	cmp    (%ebx),%cl
 241:	3b 0b                	cmp    (%ebx),%ecx
 243:	49                   	dec    %ecx
 244:	13 00                	adc    (%eax),%eax
 246:	00 04 24             	add    %al,(%esp)
 249:	00 0b                	add    %cl,(%ebx)
 24b:	0b 3e                	or     (%esi),%edi
 24d:	0b 03                	or     (%ebx),%eax
 24f:	08 00                	or     %al,(%eax)
 251:	00 05 13 01 0b 0b    	add    %al,0xb0b0113
 257:	3a 0b                	cmp    (%ebx),%cl
 259:	3b 0b                	cmp    (%ebx),%ecx
 25b:	01 13                	add    %edx,(%ebx)
 25d:	00 00                	add    %al,(%eax)
 25f:	06                   	push   %es
 260:	0d 00 03 0e 3a       	or     $0x3a0e0300,%eax
 265:	0b 3b                	or     (%ebx),%edi
 267:	0b 49 13             	or     0x13(%ecx),%ecx
 26a:	38 0b                	cmp    %cl,(%ebx)
 26c:	00 00                	add    %al,(%eax)
 26e:	07                   	pop    %es
 26f:	0d 00 03 08 3a       	or     $0x3a080300,%eax
 274:	0b 3b                	or     (%ebx),%edi
 276:	0b 49 13             	or     0x13(%ecx),%ecx
 279:	38 0b                	cmp    %cl,(%ebx)
 27b:	00 00                	add    %al,(%eax)
 27d:	08 01                	or     %al,(%ecx)
 27f:	01 49 13             	add    %ecx,0x13(%ecx)
 282:	01 13                	add    %edx,(%ebx)
 284:	00 00                	add    %al,(%eax)
 286:	09 21                	or     %esp,(%ecx)
 288:	00 49 13             	add    %cl,0x13(%ecx)
 28b:	2f                   	das    
 28c:	0b 00                	or     (%eax),%eax
 28e:	00 0a                	add    %cl,(%edx)
 290:	13 01                	adc    (%ecx),%eax
 292:	03 08                	add    (%eax),%ecx
 294:	0b 05 3a 0b 3b 0b    	or     0xb3b0b3a,%eax
 29a:	01 13                	add    %edx,(%ebx)
 29c:	00 00                	add    %al,(%eax)
 29e:	0b 0d 00 03 0e 3a    	or     0x3a0e0300,%ecx
 2a4:	0b 3b                	or     (%ebx),%edi
 2a6:	0b 49 13             	or     0x13(%ecx),%ecx
 2a9:	38 05 00 00 0c 21    	cmp    %al,0x210c0000
 2af:	00 49 13             	add    %cl,0x13(%ecx)
 2b2:	2f                   	das    
 2b3:	05 00 00 0d 13       	add    $0x130d0000,%eax
 2b8:	01 03                	add    %eax,(%ebx)
 2ba:	0e                   	push   %cs
 2bb:	0b 0b                	or     (%ebx),%ecx
 2bd:	3a 0b                	cmp    (%ebx),%cl
 2bf:	3b 0b                	cmp    (%ebx),%ecx
 2c1:	01 13                	add    %edx,(%ebx)
 2c3:	00 00                	add    %al,(%eax)
 2c5:	0e                   	push   %cs
 2c6:	17                   	pop    %ss
 2c7:	01 0b                	add    %ecx,(%ebx)
 2c9:	0b 3a                	or     (%edx),%edi
 2cb:	0b 3b                	or     (%ebx),%edi
 2cd:	0b 01                	or     (%ecx),%eax
 2cf:	13 00                	adc    (%eax),%eax
 2d1:	00 0f                	add    %cl,(%edi)
 2d3:	0d 00 03 0e 3a       	or     $0x3a0e0300,%eax
 2d8:	0b 3b                	or     (%ebx),%edi
 2da:	0b 49 13             	or     0x13(%ecx),%ecx
 2dd:	00 00                	add    %al,(%eax)
 2df:	10 0d 00 03 08 3a    	adc    %cl,0x3a080300
 2e5:	0b 3b                	or     (%ebx),%edi
 2e7:	0b 49 13             	or     0x13(%ecx),%ecx
 2ea:	00 00                	add    %al,(%eax)
 2ec:	11 34 00             	adc    %esi,(%eax,%eax,1)
 2ef:	03 0e                	add    (%esi),%ecx
 2f1:	3a 0b                	cmp    (%ebx),%cl
 2f3:	3b 0b                	cmp    (%ebx),%ecx
 2f5:	49                   	dec    %ecx
 2f6:	13 3f                	adc    (%edi),%edi
 2f8:	19 02                	sbb    %eax,(%edx)
 2fa:	18 00                	sbb    %al,(%eax)
 2fc:	00 12                	add    %dl,(%edx)
 2fe:	2e 01 3f             	add    %edi,%cs:(%edi)
 301:	19 03                	sbb    %eax,(%ebx)
 303:	0e                   	push   %cs
 304:	3a 0b                	cmp    (%ebx),%cl
 306:	3b 0b                	cmp    (%ebx),%ecx
 308:	27                   	daa    
 309:	19 49 13             	sbb    %ecx,0x13(%ecx)
 30c:	11 01                	adc    %eax,(%ecx)
 30e:	12 06                	adc    (%esi),%al
 310:	40                   	inc    %eax
 311:	18 97 42 19 01 13    	sbb    %dl,0x13011942(%edi)
 317:	00 00                	add    %al,(%eax)
 319:	13 05 00 03 0e 3a    	adc    0x3a0e0300,%eax
 31f:	0b 3b                	or     (%ebx),%edi
 321:	0b 49 13             	or     0x13(%ecx),%ecx
 324:	02 18                	add    (%eax),%bl
 326:	00 00                	add    %al,(%eax)
 328:	14 34                	adc    $0x34,%al
 32a:	00 03                	add    %al,(%ebx)
 32c:	08 3a                	or     %bh,(%edx)
 32e:	0b 3b                	or     (%ebx),%edi
 330:	0b 49 13             	or     0x13(%ecx),%ecx
 333:	02 17                	add    (%edi),%dl
 335:	00 00                	add    %al,(%eax)
 337:	15 34 00 03 0e       	adc    $0xe030034,%eax
 33c:	3a 0b                	cmp    (%ebx),%cl
 33e:	3b 0b                	cmp    (%ebx),%ecx
 340:	49                   	dec    %ecx
 341:	13 02                	adc    (%edx),%eax
 343:	17                   	pop    %ss
 344:	00 00                	add    %al,(%eax)
 346:	16                   	push   %ss
 347:	89 82 01 00 11 01    	mov    %eax,0x1110001(%edx)
 34d:	31 13                	xor    %edx,(%ebx)
 34f:	00 00                	add    %al,(%eax)
 351:	17                   	pop    %ss
 352:	0f 00 0b             	str    (%ebx)
 355:	0b 49 13             	or     0x13(%ecx),%ecx
 358:	00 00                	add    %al,(%eax)
 35a:	18 2e                	sbb    %ch,(%esi)
 35c:	01 3f                	add    %edi,(%edi)
 35e:	19 03                	sbb    %eax,(%ebx)
 360:	0e                   	push   %cs
 361:	3a 0b                	cmp    (%ebx),%cl
 363:	3b 0b                	cmp    (%ebx),%ecx
 365:	27                   	daa    
 366:	19 11                	sbb    %edx,(%ecx)
 368:	01 12                	add    %edx,(%edx)
 36a:	06                   	push   %es
 36b:	40                   	inc    %eax
 36c:	18 97 42 19 01 13    	sbb    %dl,0x13011942(%edi)
 372:	00 00                	add    %al,(%eax)
 374:	19 05 00 03 08 3a    	sbb    %eax,0x3a080300
 37a:	0b 3b                	or     (%ebx),%edi
 37c:	0b 49 13             	or     0x13(%ecx),%ecx
 37f:	02 18                	add    (%eax),%bl
 381:	00 00                	add    %al,(%eax)
 383:	1a 0b                	sbb    (%ebx),%cl
 385:	01 55 17             	add    %edx,0x17(%ebp)
 388:	01 13                	add    %edx,(%ebx)
 38a:	00 00                	add    %al,(%eax)
 38c:	1b 2e                	sbb    (%esi),%ebp
 38e:	00 3f                	add    %bh,(%edi)
 390:	19 3c 19             	sbb    %edi,(%ecx,%ebx,1)
 393:	6e                   	outsb  %ds:(%esi),(%dx)
 394:	0e                   	push   %cs
 395:	03 0e                	add    (%esi),%ecx
 397:	3a 0b                	cmp    (%ebx),%cl
 399:	3b 0b                	cmp    (%ebx),%ecx
 39b:	00 00                	add    %al,(%eax)
 39d:	00 01                	add    %al,(%ecx)
 39f:	11 00                	adc    %eax,(%eax)
 3a1:	10 06                	adc    %al,(%esi)
 3a3:	11 01                	adc    %eax,(%ecx)
 3a5:	12 01                	adc    (%ecx),%al
 3a7:	03 0e                	add    (%esi),%ecx
 3a9:	1b 0e                	sbb    (%esi),%ecx
 3ab:	25 0e 13 05 00       	and    $0x5130e,%eax
 3b0:	00 00                	add    %al,(%eax)

Disassembly of section .debug_line:

00000000 <.debug_line>:
   0:	7e 00                	jle    2 <PROT_MODE_CSEG-0x6>
   2:	00 00                	add    %al,(%eax)
   4:	02 00                	add    (%eax),%al
   6:	29 00                	sub    %eax,(%eax)
   8:	00 00                	add    %al,(%eax)
   a:	01 01                	add    %eax,(%ecx)
   c:	fb                   	sti    
   d:	0e                   	push   %cs
   e:	0d 00 01 01 01       	or     $0x1010100,%eax
  13:	01 00                	add    %eax,(%eax)
  15:	00 00                	add    %al,(%eax)
  17:	01 00                	add    %eax,(%eax)
  19:	00 01                	add    %al,(%ecx)
  1b:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  1e:	74 2f                	je     4f <PROT_MODE_DSEG+0x3f>
  20:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  23:	74 31                	je     56 <PROT_MODE_DSEG+0x46>
  25:	00 00                	add    %al,(%eax)
  27:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  2a:	74 31                	je     5d <PROT_MODE_DSEG+0x4d>
  2c:	2e 53                	cs push %ebx
  2e:	00 01                	add    %al,(%ecx)
  30:	00 00                	add    %al,(%eax)
  32:	00 00                	add    %al,(%eax)
  34:	05 02 00 7e 00       	add    $0x7e0002,%eax
  39:	00 03                	add    %al,(%ebx)
  3b:	21 01                	and    %eax,(%ecx)
  3d:	21 03                	and    %eax,(%ebx)
  3f:	09 20                	or     %esp,(%eax)
  41:	2f                   	das    
  42:	3d 43 2f 2f 2f       	cmp    $0x2f2f2f43,%eax
  47:	2f                   	das    
  48:	30 2f                	xor    %ch,(%edi)
  4a:	2f                   	das    
  4b:	2f                   	das    
  4c:	2f                   	das    
  4d:	03 0c 2e             	add    (%esi,%ebp,1),%ecx
  50:	3d 67 3e 67 67       	cmp    $0x67673e67,%eax
  55:	30 2f                	xor    %ch,(%edi)
  57:	67 30 83 3d 4b       	xor    %al,0x4b3d(%bp,%di)
  5c:	2f                   	das    
  5d:	30 2f                	xor    %ch,(%edi)
  5f:	3d 2f 34 2f 3d       	cmp    $0x3d2f342f,%eax
  64:	40                   	inc    %eax
  65:	28 5b 3d             	sub    %bl,0x3d(%ebx)
  68:	4b                   	dec    %ebx
  69:	40                   	inc    %eax
  6a:	03 0d 58 4b 2f 2f    	add    0x2f2f4b58,%ecx
  70:	2f                   	das    
  71:	2f                   	das    
  72:	30 59 59             	xor    %bl,0x59(%ecx)
  75:	5c                   	pop    %esp
  76:	25 21 2f 2f 2f       	and    $0x2f2f2f21,%eax
  7b:	30 02                	xor    %al,(%edx)
  7d:	ec                   	in     (%dx),%al
  7e:	18 00                	sbb    %al,(%eax)
  80:	01 01                	add    %eax,(%ecx)
  82:	79 01                	jns    85 <PROT_MODE_DSEG+0x75>
  84:	00 00                	add    %al,(%eax)
  86:	02 00                	add    (%eax),%al
  88:	3a 00                	cmp    (%eax),%al
  8a:	00 00                	add    %al,(%eax)
  8c:	01 01                	add    %eax,(%ecx)
  8e:	fb                   	sti    
  8f:	0e                   	push   %cs
  90:	0d 00 01 01 01       	or     $0x1010100,%eax
  95:	01 00                	add    %eax,(%eax)
  97:	00 00                	add    %al,(%eax)
  99:	01 00                	add    %eax,(%eax)
  9b:	00 01                	add    %al,(%ecx)
  9d:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  a0:	74 2f                	je     d1 <PROT_MODE_DSEG+0xc1>
  a2:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  a5:	74 31                	je     d8 <PROT_MODE_DSEG+0xc8>
  a7:	00 00                	add    %al,(%eax)
  a9:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  ac:	74 31                	je     df <PROT_MODE_DSEG+0xcf>
  ae:	6c                   	insb   (%dx),%es:(%edi)
  af:	69 62 2e 63 00 01 00 	imul   $0x10063,0x2e(%edx),%esp
  b6:	00 62 6f             	add    %ah,0x6f(%edx)
  b9:	6f                   	outsl  %ds:(%esi),(%dx)
  ba:	74 31                	je     ed <PROT_MODE_DSEG+0xdd>
  bc:	6c                   	insb   (%dx),%es:(%edi)
  bd:	69 62 2e 68 00 01 00 	imul   $0x10068,0x2e(%edx),%esp
  c4:	00 00                	add    %al,(%eax)
  c6:	00 05 02 0e 8b 00    	add    %al,0x8b0e02
  cc:	00 03                	add    %al,(%ebx)
  ce:	09 01                	or     %eax,(%ecx)
  d0:	d6                   	(bad)  
  d1:	3d 83 59 67 33       	cmp    $0x33675983,%eax
  d6:	59                   	pop    %ecx
  d7:	49                   	dec    %ecx
  d8:	3d 59 ca 08 23       	cmp    $0x2308ca59,%eax
  dd:	03 09                	add    (%ecx),%ecx
  df:	74 ad                	je     8e <PROT_MODE_DSEG+0x7e>
  e1:	b9 3d 00 02 04       	mov    $0x402003d,%ecx
  e6:	04 06                	add    $0x6,%al
  e8:	9e                   	sahf   
  e9:	00 02                	add    %al,(%edx)
  eb:	04 04                	add    $0x4,%al
  ed:	06                   	push   %es
  ee:	08 13                	or     %dl,(%ebx)
  f0:	00 02                	add    %al,(%edx)
  f2:	04 04                	add    $0x4,%al
  f4:	c9                   	leave  
  f5:	86 c9                	xchg   %cl,%cl
  f7:	3d 1f 67 24 3d       	cmp    $0x3d24671f,%eax
  fc:	00 02                	add    %al,(%edx)
  fe:	04 01                	add    $0x1,%al
 100:	08 15 03 14 3c 23    	or     %dl,0x233c1403
 106:	2b 2e                	sub    (%esi),%ebp
 108:	00 02                	add    %al,(%edx)
 10a:	04 01                	add    $0x1,%al
 10c:	3f                   	aas    
 10d:	00 02                	add    %al,(%edx)
 10f:	04 03                	add    $0x3,%al
 111:	67 3e 33 58 40       	xor    %ds:0x40(%bx,%si),%ebx
 116:	00 02                	add    %al,(%edx)
 118:	04 01                	add    $0x1,%al
 11a:	06                   	push   %es
 11b:	9e                   	sahf   
 11c:	00 02                	add    %al,(%edx)
 11e:	04 03                	add    $0x3,%al
 120:	06                   	push   %es
 121:	4c                   	dec    %esp
 122:	00 02                	add    %al,(%edx)
 124:	04 03                	add    $0x3,%al
 126:	4b                   	dec    %ebx
 127:	00 02                	add    %al,(%edx)
 129:	04 03                	add    $0x3,%al
 12b:	63 00                	arpl   %ax,(%eax)
 12d:	02 04 03             	add    (%ebx,%eax,1),%al
 130:	24 00                	and    $0x0,%al
 132:	02 04 03             	add    (%ebx,%eax,1),%al
 135:	54                   	push   %esp
 136:	42                   	inc    %edx
 137:	79 ac                	jns    e5 <PROT_MODE_DSEG+0xd5>
 139:	00 02                	add    %al,(%edx)
 13b:	04 01                	add    $0x1,%al
 13d:	08 ec                	or     %ch,%ah
 13f:	00 02                	add    %al,(%edx)
 141:	04 01                	add    $0x1,%al
 143:	91                   	xchg   %eax,%ecx
 144:	00 02                	add    %al,(%edx)
 146:	04 01                	add    $0x1,%al
 148:	2d 00 02 04 01       	sub    $0x1040200,%eax
 14d:	67 2d 4c 67 75 4b    	addr16 sub $0x4b75674c,%eax
 153:	3d 65 5d ae 64       	cmp    $0x64ae5d65,%eax
 158:	30 d7                	xor    %dl,%bh
 15a:	5d                   	pop    %ebp
 15b:	ae                   	scas   %es:(%edi),%al
 15c:	64 30 d7             	fs xor %dl,%bh
 15f:	03 bd 7f 58 d7 e5    	add    -0x1a28a781(%ebp),%edi
 165:	59                   	pop    %ecx
 166:	49                   	dec    %ecx
 167:	03 d1                	add    %ecx,%edx
 169:	00 58 04             	add    %bl,0x4(%eax)
 16c:	02 03                	add    (%ebx),%al
 16e:	99                   	cltd   
 16f:	7f 4a                	jg     1bb <PROT_MODE_DSEG+0x1ab>
 171:	04 01                	add    $0x1,%al
 173:	03 e7                	add    %edi,%esp
 175:	00 58 04             	add    %bl,0x4(%eax)
 178:	02 03                	add    (%ebx),%al
 17a:	99                   	cltd   
 17b:	7f 3c                	jg     1b9 <PROT_MODE_DSEG+0x1a9>
 17d:	04 01                	add    $0x1,%al
 17f:	03 e1                	add    %ecx,%esp
 181:	00 3c 04             	add    %bh,(%esp,%eax,1)
 184:	02 03                	add    (%ebx),%al
 186:	92                   	xchg   %eax,%edx
 187:	7f 74                	jg     1fd <PROT_MODE_DSEG+0x1ed>
 189:	04 01                	add    $0x1,%al
 18b:	03 fa                	add    %edx,%edi
 18d:	00 f2                	add    %dh,%dl
 18f:	04 02                	add    $0x2,%al
 191:	03 86 7f 2e 04 01    	add    0x1042e7f(%esi),%eax
 197:	03 fa                	add    %edx,%edi
 199:	00 58 04             	add    %bl,0x4(%eax)
 19c:	02 03                	add    (%ebx),%al
 19e:	86 7f 3c             	xchg   %bh,0x3c(%edi)
 1a1:	04 01                	add    $0x1,%al
 1a3:	03 fb                	add    %ebx,%edi
 1a5:	00 20                	add    %ah,(%eax)
 1a7:	04 02                	add    $0x2,%al
 1a9:	03 85 7f 2e 04 01    	add    0x1042e7f(%ebp),%eax
 1af:	03 fb                	add    %ebx,%edi
 1b1:	00 58 04             	add    %bl,0x4(%eax)
 1b4:	02 03                	add    (%ebx),%al
 1b6:	85 7f 3c             	test   %edi,0x3c(%edi)
 1b9:	04 01                	add    $0x1,%al
 1bb:	03 fc                	add    %esp,%edi
 1bd:	00 20                	add    %ah,(%eax)
 1bf:	04 02                	add    $0x2,%al
 1c1:	03 84 7f 2e 04 01 03 	add    0x301042e(%edi,%edi,2),%eax
 1c8:	fc                   	cld    
 1c9:	00 58 04             	add    %bl,0x4(%eax)
 1cc:	02 03                	add    (%ebx),%al
 1ce:	84 7f 66             	test   %bh,0x66(%edi)
 1d1:	03 0d 66 04 01 03    	add    0x3010466,%ecx
 1d7:	e1 00                	loope  1d9 <PROT_MODE_DSEG+0x1c9>
 1d9:	66 04 02             	data16 add $0x2,%al
 1dc:	03 a6 7f 74 04 01    	add    0x104747f(%esi),%esp
 1e2:	03 f0                	add    %eax,%esi
 1e4:	00 f2                	add    %dh,%dl
 1e6:	42                   	inc    %edx
 1e7:	66 03 09             	add    (%ecx),%cx
 1ea:	3c 03                	cmp    $0x3,%al
 1ec:	7a 3c                	jp     22a <PROT_MODE_DSEG+0x21a>
 1ee:	31 63 6c             	xor    %esp,0x6c(%ebx)
 1f1:	37                   	aaa    
 1f2:	41                   	inc    %ecx
 1f3:	41                   	inc    %ecx
 1f4:	4c                   	dec    %esp
 1f5:	30 1f                	xor    %bl,(%edi)
 1f7:	65 5a                	gs pop %edx
 1f9:	4c                   	dec    %esp
 1fa:	02 08                	add    (%eax),%cl
 1fc:	00 01                	add    %al,(%ecx)
 1fe:	01 b0 00 00 00 02    	add    %esi,0x2000000(%eax)
 204:	00 3b                	add    %bh,(%ebx)
 206:	00 00                	add    %al,(%eax)
 208:	00 01                	add    %al,(%ecx)
 20a:	01 fb                	add    %edi,%ebx
 20c:	0e                   	push   %cs
 20d:	0d 00 01 01 01       	or     $0x1010100,%eax
 212:	01 00                	add    %eax,(%eax)
 214:	00 00                	add    %al,(%eax)
 216:	01 00                	add    %eax,(%eax)
 218:	00 01                	add    %al,(%ecx)
 21a:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 21d:	74 2f                	je     24e <PROT_MODE_DSEG+0x23e>
 21f:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 222:	74 31                	je     255 <PROT_MODE_DSEG+0x245>
 224:	00 00                	add    %al,(%eax)
 226:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 229:	74 31                	je     25c <PROT_MODE_DSEG+0x24c>
 22b:	6d                   	insl   (%dx),%es:(%edi)
 22c:	61                   	popa   
 22d:	69 6e 2e 63 00 01 00 	imul   $0x10063,0x2e(%esi),%ebp
 234:	00 62 6f             	add    %ah,0x6f(%edx)
 237:	6f                   	outsl  %ds:(%esi),(%dx)
 238:	74 31                	je     26b <PROT_MODE_DSEG+0x25b>
 23a:	6c                   	insb   (%dx),%es:(%edi)
 23b:	69 62 2e 68 00 01 00 	imul   $0x10068,0x2e(%edx),%esp
 242:	00 00                	add    %al,(%eax)
 244:	00 05 02 b7 8d 00    	add    %al,0x8db702
 24a:	00 03                	add    %al,(%ebx)
 24c:	39 01                	cmp    %eax,(%ecx)
 24e:	08 40 08             	or     %al,0x8(%eax)
 251:	3f                   	aas    
 252:	e5 08                	in     $0x8,%eax
 254:	23 59 73             	and    0x73(%ecx),%ebx
 257:	67 00 02             	add    %al,(%bp,%si)
 25a:	04 01                	add    $0x1,%al
 25c:	5a                   	pop    %edx
 25d:	00 02                	add    %al,(%edx)
 25f:	04 02                	add    $0x2,%al
 261:	4c                   	dec    %esp
 262:	00 02                	add    %al,(%edx)
 264:	04 02                	add    $0x2,%al
 266:	64 00 02             	add    %al,%fs:(%edx)
 269:	04 02                	add    $0x2,%al
 26b:	3e 00 02             	add    %al,%ds:(%edx)
 26e:	04 02                	add    $0x2,%al
 270:	aa                   	stos   %al,%es:(%edi)
 271:	5d                   	pop    %ebp
 272:	59                   	pop    %ecx
 273:	49                   	dec    %ecx
 274:	59                   	pop    %ecx
 275:	4e                   	dec    %esi
 276:	6a c4                	push   $0xffffffc4
 278:	3c 41                	cmp    $0x41,%al
 27a:	bb e6 3e 3a 68       	mov    $0x683a3ee6,%ebx
 27f:	00 02                	add    %al,(%edx)
 281:	04 01                	add    $0x1,%al
 283:	54                   	push   %esp
 284:	00 02                	add    %al,(%edx)
 286:	04 02                	add    $0x2,%al
 288:	06                   	push   %es
 289:	9e                   	sahf   
 28a:	06                   	push   %es
 28b:	7a 67                	jp     2f4 <PROT_MODE_DSEG+0x2e4>
 28d:	68 03 be 7f d6       	push   $0xd67fbe03
 292:	03 0a                	add    (%edx),%ecx
 294:	66 03 76 c8          	add    -0x38(%esi),%si
 298:	3c 3e                	cmp    $0x3e,%al
 29a:	76 08                	jbe    2a4 <PROT_MODE_DSEG+0x294>
 29c:	19 e7                	sbb    %esp,%edi
 29e:	67 65 59             	addr16 gs pop %ecx
 2a1:	08 83 00 02 04 02    	or     %al,0x2040200(%ebx)
 2a7:	03 7a 58             	add    0x58(%edx),%edi
 2aa:	03 0a                	add    (%edx),%ecx
 2ac:	66 e5 02             	in     $0x2,%ax
 2af:	0b 00                	or     (%eax),%eax
 2b1:	01 01                	add    %eax,(%ecx)
 2b3:	46                   	inc    %esi
 2b4:	00 00                	add    %al,(%eax)
 2b6:	00 02                	add    %al,(%edx)
 2b8:	00 2f                	add    %ch,(%edi)
 2ba:	00 00                	add    %al,(%eax)
 2bc:	00 01                	add    %al,(%ecx)
 2be:	01 fb                	add    %edi,%ebx
 2c0:	0e                   	push   %cs
 2c1:	0d 00 01 01 01       	or     $0x1010100,%eax
 2c6:	01 00                	add    %eax,(%eax)
 2c8:	00 00                	add    %al,(%eax)
 2ca:	01 00                	add    %eax,(%eax)
 2cc:	00 01                	add    %al,(%ecx)
 2ce:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 2d1:	74 2f                	je     302 <PROT_MODE_DSEG+0x2f2>
 2d3:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 2d6:	74 31                	je     309 <PROT_MODE_DSEG+0x2f9>
 2d8:	00 00                	add    %al,(%eax)
 2da:	65 78 65             	gs js  342 <PROT_MODE_DSEG+0x332>
 2dd:	63 5f 6b             	arpl   %bx,0x6b(%edi)
 2e0:	65 72 6e             	gs jb  351 <PROT_MODE_DSEG+0x341>
 2e3:	65 6c                	gs insb (%dx),%es:(%edi)
 2e5:	2e 53                	cs push %ebx
 2e7:	00 01                	add    %al,(%ecx)
 2e9:	00 00                	add    %al,(%eax)
 2eb:	00 00                	add    %al,(%eax)
 2ed:	05 02 49 8f 00       	add    $0x8f4902,%eax
 2f2:	00 17                	add    %dl,(%edi)
 2f4:	21 59 4b             	and    %ebx,0x4b(%ecx)
 2f7:	4b                   	dec    %ebx
 2f8:	02 02                	add    (%edx),%al
 2fa:	00 01                	add    %al,(%ecx)
 2fc:	01                   	.byte 0x1

Disassembly of section .debug_str:

00000000 <.debug_str>:
   0:	62 6f 6f             	bound  %ebp,0x6f(%edi)
   3:	74 2f                	je     34 <PROT_MODE_DSEG+0x24>
   5:	62 6f 6f             	bound  %ebp,0x6f(%edi)
   8:	74 31                	je     3b <PROT_MODE_DSEG+0x2b>
   a:	2f                   	das    
   b:	62 6f 6f             	bound  %ebp,0x6f(%edi)
   e:	74 31                	je     41 <PROT_MODE_DSEG+0x31>
  10:	2e 53                	cs push %ebx
  12:	00 2f                	add    %ch,(%edi)
  14:	68 6f 6d 65 2f       	push   $0x2f656d6f
  19:	73 74                	jae    8f <PROT_MODE_DSEG+0x7f>
  1b:	75 64                	jne    81 <PROT_MODE_DSEG+0x71>
  1d:	65 6e                	outsb  %gs:(%esi),(%dx)
  1f:	74 2f                	je     50 <PROT_MODE_DSEG+0x40>
  21:	6f                   	outsl  %ds:(%esi),(%dx)
  22:	73 2d                	jae    51 <PROT_MODE_DSEG+0x41>
  24:	73 32                	jae    58 <PROT_MODE_DSEG+0x48>
  26:	30 2d 6a 6a 41 75    	xor    %ch,0x75416a6a
  2c:	67 75 73             	addr16 jne a2 <PROT_MODE_DSEG+0x92>
  2f:	74 00                	je     31 <PROT_MODE_DSEG+0x21>
  31:	47                   	inc    %edi
  32:	4e                   	dec    %esi
  33:	55                   	push   %ebp
  34:	20 41 53             	and    %al,0x53(%ecx)
  37:	20 32                	and    %dh,(%edx)
  39:	2e 33 30             	xor    %cs:(%eax),%esi
  3c:	00 65 6e             	add    %ah,0x6e(%ebp)
  3f:	64 5f                	fs pop %edi
  41:	76 61                	jbe    a4 <PROT_MODE_DSEG+0x94>
  43:	00 77 61             	add    %dh,0x61(%edi)
  46:	69 74 64 69 73 6b 00 	imul   $0x70006b73,0x69(%esp,%eiz,2),%esi
  4d:	70 
  4e:	75 74                	jne    c4 <PROT_MODE_DSEG+0xb4>
  50:	6c                   	insb   (%dx),%es:(%edi)
  51:	69 6e 65 00 73 68 6f 	imul   $0x6f687300,0x65(%esi),%ebp
  58:	72 74                	jb     ce <PROT_MODE_DSEG+0xbe>
  5a:	20 69 6e             	and    %ch,0x6e(%ecx)
  5d:	74 00                	je     5f <PROT_MODE_DSEG+0x4f>
  5f:	63 6f 6c             	arpl   %bp,0x6c(%edi)
  62:	6f                   	outsl  %ds:(%esi),(%dx)
  63:	72 00                	jb     65 <PROT_MODE_DSEG+0x55>
  65:	72 6f                	jb     d6 <PROT_MODE_DSEG+0xc6>
  67:	6c                   	insb   (%dx),%es:(%edi)
  68:	6c                   	insb   (%dx),%es:(%edi)
  69:	00 73 74             	add    %dh,0x74(%ebx)
  6c:	72 69                	jb     d7 <PROT_MODE_DSEG+0xc7>
  6e:	6e                   	outsb  %ds:(%esi),(%dx)
  6f:	67 00 70 61          	add    %dh,0x61(%bx,%si)
  73:	6e                   	outsb  %ds:(%esi),(%dx)
  74:	69 63 00 70 75 74 69 	imul   $0x69747570,0x0(%ebx),%esp
  7b:	00 72 65             	add    %dh,0x65(%edx)
  7e:	61                   	popa   
  7f:	64 73 65             	fs jae e7 <PROT_MODE_DSEG+0xd7>
  82:	63 74 6f 72          	arpl   %si,0x72(%edi,%ebp,2)
  86:	00 62 6f             	add    %ah,0x6f(%edx)
  89:	6f                   	outsl  %ds:(%esi),(%dx)
  8a:	74 2f                	je     bb <PROT_MODE_DSEG+0xab>
  8c:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  8f:	74 31                	je     c2 <PROT_MODE_DSEG+0xb2>
  91:	2f                   	das    
  92:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  95:	74 31                	je     c8 <PROT_MODE_DSEG+0xb8>
  97:	6c                   	insb   (%dx),%es:(%edi)
  98:	69 62 2e 63 00 75 69 	imul   $0x69750063,0x2e(%edx),%esp
  9f:	6e                   	outsb  %ds:(%esi),(%dx)
  a0:	74 38                	je     da <PROT_MODE_DSEG+0xca>
  a2:	5f                   	pop    %edi
  a3:	74 00                	je     a5 <PROT_MODE_DSEG+0x95>
  a5:	6f                   	outsl  %ds:(%esi),(%dx)
  a6:	75 74                	jne    11c <PROT_MODE_DSEG+0x10c>
  a8:	62 00                	bound  %eax,(%eax)
  aa:	69 6e 73 6c 00 6c 6f 	imul   $0x6f6c006c,0x73(%esi),%ebp
  b1:	6e                   	outsb  %ds:(%esi),(%dx)
  b2:	67 20 6c 6f          	and    %ch,0x6f(%si)
  b6:	6e                   	outsb  %ds:(%esi),(%dx)
  b7:	67 20 69 6e          	and    %ch,0x6e(%bx,%di)
  bb:	74 00                	je     bd <PROT_MODE_DSEG+0xad>
  bd:	72 65                	jb     124 <PROT_MODE_DSEG+0x114>
  bf:	61                   	popa   
  c0:	64 73 65             	fs jae 128 <PROT_MODE_DSEG+0x118>
  c3:	63 74 69 6f          	arpl   %si,0x6f(%ecx,%ebp,2)
  c7:	6e                   	outsb  %ds:(%esi),(%dx)
  c8:	00 69 74             	add    %ch,0x74(%ecx)
  cb:	6f                   	outsl  %ds:(%esi),(%dx)
  cc:	61                   	popa   
  cd:	00 75 6e             	add    %dh,0x6e(%ebp)
  d0:	73 69                	jae    13b <PROT_MODE_DSEG+0x12b>
  d2:	67 6e                	outsb  %ds:(%si),(%dx)
  d4:	65 64 20 63 68       	gs and %ah,%fs:0x68(%ebx)
  d9:	61                   	popa   
  da:	72 00                	jb     dc <PROT_MODE_DSEG+0xcc>
  dc:	69 74 6f 68 00 70 75 	imul   $0x74757000,0x68(%edi,%ebp,2),%esi
  e3:	74 
  e4:	63 00                	arpl   %ax,(%eax)
  e6:	6c                   	insb   (%dx),%es:(%edi)
  e7:	6f                   	outsl  %ds:(%esi),(%dx)
  e8:	6e                   	outsb  %ds:(%esi),(%dx)
  e9:	67 20 6c 6f          	and    %ch,0x6f(%si)
  ed:	6e                   	outsb  %ds:(%esi),(%dx)
  ee:	67 20 75 6e          	and    %dh,0x6e(%di)
  f2:	73 69                	jae    15d <PROT_MODE_DSEG+0x14d>
  f4:	67 6e                	outsb  %ds:(%si),(%dx)
  f6:	65 64 20 69 6e       	gs and %ch,%fs:0x6e(%ecx)
  fb:	74 00                	je     fd <PROT_MODE_DSEG+0xed>
  fd:	75 69                	jne    168 <PROT_MODE_DSEG+0x158>
  ff:	6e                   	outsb  %ds:(%esi),(%dx)
 100:	74 33                	je     135 <PROT_MODE_DSEG+0x125>
 102:	32 5f 74             	xor    0x74(%edi),%bl
 105:	00 69 74             	add    %ch,0x74(%ecx)
 108:	6f                   	outsl  %ds:(%esi),(%dx)
 109:	78 00                	js     10b <PROT_MODE_DSEG+0xfb>
 10b:	70 75                	jo     182 <PROT_MODE_DSEG+0x172>
 10d:	74 73                	je     182 <PROT_MODE_DSEG+0x172>
 10f:	00 73 68             	add    %dh,0x68(%ebx)
 112:	6f                   	outsl  %ds:(%esi),(%dx)
 113:	72 74                	jb     189 <PROT_MODE_DSEG+0x179>
 115:	20 75 6e             	and    %dh,0x6e(%ebp)
 118:	73 69                	jae    183 <PROT_MODE_DSEG+0x173>
 11a:	67 6e                	outsb  %ds:(%si),(%dx)
 11c:	65 64 20 69 6e       	gs and %ch,%fs:0x6e(%ecx)
 121:	74 00                	je     123 <PROT_MODE_DSEG+0x113>
 123:	73 74                	jae    199 <PROT_MODE_DSEG+0x189>
 125:	72 6c                	jb     193 <PROT_MODE_DSEG+0x183>
 127:	65 6e                	outsb  %gs:(%esi),(%dx)
 129:	00 64 61 74          	add    %ah,0x74(%ecx,%eiz,2)
 12d:	61                   	popa   
 12e:	00 70 6f             	add    %dh,0x6f(%eax)
 131:	72 74                	jb     1a7 <PROT_MODE_DSEG+0x197>
 133:	00 73 69             	add    %dh,0x69(%ebx)
 136:	67 6e                	outsb  %ds:(%si),(%dx)
 138:	00 72 65             	add    %dh,0x65(%edx)
 13b:	76 65                	jbe    1a2 <PROT_MODE_DSEG+0x192>
 13d:	72 73                	jb     1b2 <PROT_MODE_DSEG+0x1a2>
 13f:	65 00 70 75          	add    %dh,%gs:0x75(%eax)
 143:	74 69                	je     1ae <PROT_MODE_DSEG+0x19e>
 145:	5f                   	pop    %edi
 146:	73 74                	jae    1bc <PROT_MODE_DSEG+0x1ac>
 148:	72 00                	jb     14a <PROT_MODE_DSEG+0x13a>
 14a:	47                   	inc    %edi
 14b:	4e                   	dec    %esi
 14c:	55                   	push   %ebp
 14d:	20 43 31             	and    %al,0x31(%ebx)
 150:	31 20                	xor    %esp,(%eax)
 152:	37                   	aaa    
 153:	2e 35 2e 30 20 2d    	cs xor $0x2d20302e,%eax
 159:	6d                   	insl   (%dx),%es:(%edi)
 15a:	33 32                	xor    (%edx),%esi
 15c:	20 2d 6d 74 75 6e    	and    %ch,0x6e75746d
 162:	65 3d 67 65 6e 65    	gs cmp $0x656e6567,%eax
 168:	72 69                	jb     1d3 <PROT_MODE_DSEG+0x1c3>
 16a:	63 20                	arpl   %sp,(%eax)
 16c:	2d 6d 61 72 63       	sub    $0x6372616d,%eax
 171:	68 3d 69 36 38       	push   $0x3836693d
 176:	36 20 2d 67 20 2d 4f 	and    %ch,%ss:0x4f2d2067
 17d:	73 20                	jae    19f <PROT_MODE_DSEG+0x18f>
 17f:	2d 4f 73 20 2d       	sub    $0x2d20734f,%eax
 184:	66 6e                	data16 outsb %ds:(%esi),(%dx)
 186:	6f                   	outsl  %ds:(%esi),(%dx)
 187:	2d 62 75 69 6c       	sub    $0x6c697562,%eax
 18c:	74 69                	je     1f7 <PROT_MODE_DSEG+0x1e7>
 18e:	6e                   	outsb  %ds:(%esi),(%dx)
 18f:	20 2d 66 6e 6f 2d    	and    %ch,0x2d6f6e66
 195:	73 74                	jae    20b <PROT_MODE_DSEG+0x1fb>
 197:	61                   	popa   
 198:	63 6b 2d             	arpl   %bp,0x2d(%ebx)
 19b:	70 72                	jo     20f <PROT_MODE_DSEG+0x1ff>
 19d:	6f                   	outsl  %ds:(%esi),(%dx)
 19e:	74 65                	je     205 <PROT_MODE_DSEG+0x1f5>
 1a0:	63 74 6f 72          	arpl   %si,0x72(%edi,%ebp,2)
 1a4:	00 62 6c             	add    %ah,0x6c(%edx)
 1a7:	61                   	popa   
 1a8:	6e                   	outsb  %ds:(%esi),(%dx)
 1a9:	6b 00 72             	imul   $0x72,(%eax),%eax
 1ac:	6f                   	outsl  %ds:(%esi),(%dx)
 1ad:	6f                   	outsl  %ds:(%esi),(%dx)
 1ae:	74 00                	je     1b0 <PROT_MODE_DSEG+0x1a0>
 1b0:	76 69                	jbe    21b <PROT_MODE_DSEG+0x20b>
 1b2:	64 65 6f             	fs outsl %gs:(%esi),(%dx)
 1b5:	00 64 69 73          	add    %ah,0x73(%ecx,%ebp,2)
 1b9:	6b 5f 73 69          	imul   $0x69,0x73(%edi),%ebx
 1bd:	67 00 65 6c          	add    %ah,0x6c(%di)
 1c1:	66 68 64 66          	pushw  $0x6664
 1c5:	00 65 5f             	add    %ah,0x5f(%ebp)
 1c8:	73 68                	jae    232 <PROT_MODE_DSEG+0x222>
 1ca:	73 74                	jae    240 <PROT_MODE_DSEG+0x230>
 1cc:	72 6e                	jb     23c <PROT_MODE_DSEG+0x22c>
 1ce:	64 78 00             	fs js  1d1 <PROT_MODE_DSEG+0x1c1>
 1d1:	6d                   	insl   (%dx),%es:(%edi)
 1d2:	6d                   	insl   (%dx),%es:(%edi)
 1d3:	61                   	popa   
 1d4:	70 5f                	jo     235 <PROT_MODE_DSEG+0x225>
 1d6:	61                   	popa   
 1d7:	64 64 72 00          	fs fs jb 1db <PROT_MODE_DSEG+0x1cb>
 1db:	65 6c                	gs insb (%dx),%es:(%edi)
 1dd:	66 68 64 72          	pushw  $0x7264
 1e1:	00 76 62             	add    %dh,0x62(%esi)
 1e4:	65 5f                	gs pop %edi
 1e6:	69 6e 74 65 72 66 61 	imul   $0x61667265,0x74(%esi),%ebp
 1ed:	63 65 5f             	arpl   %sp,0x5f(%ebp)
 1f0:	6f                   	outsl  %ds:(%esi),(%dx)
 1f1:	66 66 00 65 5f       	data16 data16 add %ah,0x5f(%ebp)
 1f6:	65 6e                	outsb  %gs:(%esi),(%dx)
 1f8:	74 72                	je     26c <PROT_MODE_DSEG+0x25c>
 1fa:	79 00                	jns    1fc <PROT_MODE_DSEG+0x1ec>
 1fc:	75 69                	jne    267 <PROT_MODE_DSEG+0x257>
 1fe:	6e                   	outsb  %ds:(%esi),(%dx)
 1ff:	74 36                	je     237 <PROT_MODE_DSEG+0x227>
 201:	34 5f                	xor    $0x5f,%al
 203:	74 00                	je     205 <PROT_MODE_DSEG+0x1f5>
 205:	6c                   	insb   (%dx),%es:(%edi)
 206:	6f                   	outsl  %ds:(%esi),(%dx)
 207:	61                   	popa   
 208:	64 5f                	fs pop %edi
 20a:	6b 65 72 6e          	imul   $0x6e,0x72(%ebp),%esp
 20e:	65 6c                	gs insb (%dx),%es:(%edi)
 210:	00 70 5f             	add    %dh,0x5f(%eax)
 213:	6d                   	insl   (%dx),%es:(%edi)
 214:	65 6d                	gs insl (%dx),%es:(%edi)
 216:	73 7a                	jae    292 <PROT_MODE_DSEG+0x282>
 218:	00 70 5f             	add    %dh,0x5f(%eax)
 21b:	6f                   	outsl  %ds:(%esi),(%dx)
 21c:	66 66 73 65          	data16 data16 jae 285 <PROT_MODE_DSEG+0x275>
 220:	74 00                	je     222 <PROT_MODE_DSEG+0x212>
 222:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 225:	74 6c                	je     293 <PROT_MODE_DSEG+0x283>
 227:	6f                   	outsl  %ds:(%esi),(%dx)
 228:	61                   	popa   
 229:	64 65 72 00          	fs gs jb 22d <PROT_MODE_DSEG+0x21d>
 22d:	65 5f                	gs pop %edi
 22f:	66 6c                	data16 insb (%dx),%es:(%edi)
 231:	61                   	popa   
 232:	67 73 00             	addr16 jae 235 <PROT_MODE_DSEG+0x225>
 235:	63 6d 64             	arpl   %bp,0x64(%ebp)
 238:	6c                   	insb   (%dx),%es:(%edi)
 239:	69 6e 65 00 65 5f 6d 	imul   $0x6d5f6500,0x65(%esi),%ebp
 240:	61                   	popa   
 241:	63 68 69             	arpl   %bp,0x69(%eax)
 244:	6e                   	outsb  %ds:(%esi),(%dx)
 245:	65 00 65 5f          	add    %ah,%gs:0x5f(%ebp)
 249:	70 68                	jo     2b3 <PROT_MODE_DSEG+0x2a3>
 24b:	65 6e                	outsb  %gs:(%esi),(%dx)
 24d:	74 73                	je     2c2 <PROT_MODE_DSEG+0x2b2>
 24f:	69 7a 65 00 65 78 65 	imul   $0x65786500,0x65(%edx),%edi
 256:	63 5f 6b             	arpl   %bx,0x6b(%edi)
 259:	65 72 6e             	gs jb  2ca <PROT_MODE_DSEG+0x2ba>
 25c:	65 6c                	gs insb (%dx),%es:(%edi)
 25e:	00 6d 6f             	add    %ch,0x6f(%ebp)
 261:	64 73 5f             	fs jae 2c3 <PROT_MODE_DSEG+0x2b3>
 264:	61                   	popa   
 265:	64 64 72 00          	fs fs jb 269 <PROT_MODE_DSEG+0x259>
 269:	73 74                	jae    2df <PROT_MODE_DSEG+0x2cf>
 26b:	72 73                	jb     2e0 <PROT_MODE_DSEG+0x2d0>
 26d:	69 7a 65 00 70 61 72 	imul   $0x72617000,0x65(%edx),%edi
 274:	74 33                	je     2a9 <PROT_MODE_DSEG+0x299>
 276:	00 70 5f             	add    %dh,0x5f(%eax)
 279:	74 79                	je     2f4 <PROT_MODE_DSEG+0x2e4>
 27b:	70 65                	jo     2e2 <PROT_MODE_DSEG+0x2d2>
 27d:	00 70 72             	add    %dh,0x72(%eax)
 280:	6f                   	outsl  %ds:(%esi),(%dx)
 281:	67 68 64 72 00 65    	addr16 push $0x65007264
 287:	5f                   	pop    %edi
 288:	73 68                	jae    2f2 <PROT_MODE_DSEG+0x2e2>
 28a:	65 6e                	outsb  %gs:(%esi),(%dx)
 28c:	74 73                	je     301 <PROT_MODE_DSEG+0x2f1>
 28e:	69 7a 65 00 73 68 6e 	imul   $0x6e687300,0x65(%edx),%edi
 295:	64 78 00             	fs js  298 <PROT_MODE_DSEG+0x288>
 298:	6d                   	insl   (%dx),%es:(%edi)
 299:	62 72 5f             	bound  %esi,0x5f(%edx)
 29c:	74 00                	je     29e <PROT_MODE_DSEG+0x28e>
 29e:	65 5f                	gs pop %edi
 2a0:	74 79                	je     31b <PROT_MODE_DSEG+0x30b>
 2a2:	70 65                	jo     309 <PROT_MODE_DSEG+0x2f9>
 2a4:	00 64 72 69          	add    %ah,0x69(%edx,%esi,2)
 2a8:	76 65                	jbe    30f <PROT_MODE_DSEG+0x2ff>
 2aa:	73 5f                	jae    30b <PROT_MODE_DSEG+0x2fb>
 2ac:	61                   	popa   
 2ad:	64 64 72 00          	fs fs jb 2b1 <PROT_MODE_DSEG+0x2a1>
 2b1:	65 5f                	gs pop %edi
 2b3:	65 68 73 69 7a 65    	gs push $0x657a6973
 2b9:	00 70 61             	add    %dh,0x61(%eax)
 2bc:	72 74                	jb     332 <PROT_MODE_DSEG+0x322>
 2be:	69 74 69 6f 6e 00 62 	imul   $0x6962006e,0x6f(%ecx,%ebp,2),%esi
 2c5:	69 
 2c6:	6f                   	outsl  %ds:(%esi),(%dx)
 2c7:	73 5f                	jae    328 <PROT_MODE_DSEG+0x318>
 2c9:	73 6d                	jae    338 <PROT_MODE_DSEG+0x328>
 2cb:	61                   	popa   
 2cc:	70 5f                	jo     32d <PROT_MODE_DSEG+0x31d>
 2ce:	74 00                	je     2d0 <PROT_MODE_DSEG+0x2c0>
 2d0:	6d                   	insl   (%dx),%es:(%edi)
 2d1:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 2d4:	74 5f                	je     335 <PROT_MODE_DSEG+0x325>
 2d6:	69 6e 66 6f 5f 74 00 	imul   $0x745f6f,0x66(%esi),%ebp
 2dd:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 2e0:	74 31                	je     313 <PROT_MODE_DSEG+0x303>
 2e2:	6d                   	insl   (%dx),%es:(%edi)
 2e3:	61                   	popa   
 2e4:	69 6e 00 65 5f 76 65 	imul   $0x65765f65,0x0(%esi),%ebp
 2eb:	72 73                	jb     360 <PROT_MODE_DSEG+0x350>
 2ed:	69 6f 6e 00 70 61 72 	imul   $0x72617000,0x6e(%edi),%ebp
 2f4:	74 31                	je     327 <PROT_MODE_DSEG+0x317>
 2f6:	00 70 61             	add    %dh,0x61(%eax)
 2f9:	72 74                	jb     36f <PROT_MODE_DSEG+0x35f>
 2fb:	32 00                	xor    (%eax),%al
 2fd:	64 72 69             	fs jb  369 <PROT_MODE_DSEG+0x359>
 300:	76 65                	jbe    367 <PROT_MODE_DSEG+0x357>
 302:	72 00                	jb     304 <PROT_MODE_DSEG+0x2f4>
 304:	66 69 72 73 74 5f    	imul   $0x5f74,0x73(%edx),%si
 30a:	63 68 73             	arpl   %bp,0x73(%eax)
 30d:	00 62 69             	add    %ah,0x69(%edx)
 310:	6f                   	outsl  %ds:(%esi),(%dx)
 311:	73 5f                	jae    372 <PROT_MODE_DSEG+0x362>
 313:	73 6d                	jae    382 <PROT_MODE_DSEG+0x372>
 315:	61                   	popa   
 316:	70 00                	jo     318 <PROT_MODE_DSEG+0x308>
 318:	6d                   	insl   (%dx),%es:(%edi)
 319:	65 6d                	gs insl (%dx),%es:(%edi)
 31b:	5f                   	pop    %edi
 31c:	6c                   	insb   (%dx),%es:(%edi)
 31d:	6f                   	outsl  %ds:(%esi),(%dx)
 31e:	77 65                	ja     385 <PROT_MODE_DSEG+0x375>
 320:	72 00                	jb     322 <PROT_MODE_DSEG+0x312>
 322:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 325:	74 61                	je     388 <PROT_MODE_DSEG+0x378>
 327:	62 6c 65 00          	bound  %ebp,0x0(%ebp,%eiz,2)
 32b:	73 79                	jae    3a6 <PROT_MODE_DSEG+0x396>
 32d:	6d                   	insl   (%dx),%es:(%edi)
 32e:	73 00                	jae    330 <PROT_MODE_DSEG+0x320>
 330:	75 69                	jne    39b <PROT_MODE_DSEG+0x38b>
 332:	6e                   	outsb  %ds:(%esi),(%dx)
 333:	74 31                	je     366 <PROT_MODE_DSEG+0x356>
 335:	36 5f                	ss pop %edi
 337:	74 00                	je     339 <PROT_MODE_DSEG+0x329>
 339:	6d                   	insl   (%dx),%es:(%edi)
 33a:	6d                   	insl   (%dx),%es:(%edi)
 33b:	61                   	popa   
 33c:	70 5f                	jo     39d <PROT_MODE_DSEG+0x38d>
 33e:	6c                   	insb   (%dx),%es:(%edi)
 33f:	65 6e                	outsb  %gs:(%esi),(%dx)
 341:	67 74 68             	addr16 je 3ac <PROT_MODE_DSEG+0x39c>
 344:	00 6d 62             	add    %ch,0x62(%ebp)
 347:	6f                   	outsl  %ds:(%esi),(%dx)
 348:	6f                   	outsl  %ds:(%esi),(%dx)
 349:	74 5f                	je     3aa <PROT_MODE_DSEG+0x39a>
 34b:	69 6e 66 6f 00 70 5f 	imul   $0x5f70006f,0x66(%esi),%ebp
 352:	76 61                	jbe    3b5 <PROT_MODE_DSEG+0x3a5>
 354:	00 76 62             	add    %dh,0x62(%esi)
 357:	65 5f                	gs pop %edi
 359:	63 6f 6e             	arpl   %bp,0x6e(%edi)
 35c:	74 72                	je     3d0 <PROT_MODE_DSEG+0x3c0>
 35e:	6f                   	outsl  %ds:(%esi),(%dx)
 35f:	6c                   	insb   (%dx),%es:(%edi)
 360:	5f                   	pop    %edi
 361:	69 6e 66 6f 00 70 5f 	imul   $0x5f70006f,0x66(%esi),%ebp
 368:	66 6c                	data16 insb (%dx),%es:(%edi)
 36a:	61                   	popa   
 36b:	67 73 00             	addr16 jae 36e <PROT_MODE_DSEG+0x35e>
 36e:	70 61                	jo     3d1 <PROT_MODE_DSEG+0x3c1>
 370:	72 73                	jb     3e5 <PROT_MODE_DSEG+0x3d5>
 372:	65 5f                	gs pop %edi
 374:	65 38 32             	cmp    %dh,%gs:(%edx)
 377:	30 00                	xor    %al,(%eax)
 379:	65 5f                	gs pop %edi
 37b:	65 6c                	gs insb (%dx),%es:(%edi)
 37d:	66 00 62 6f          	data16 add %ah,0x6f(%edx)
 381:	6f                   	outsl  %ds:(%esi),(%dx)
 382:	74 5f                	je     3e3 <PROT_MODE_DSEG+0x3d3>
 384:	64 65 76 69          	fs gs jbe 3f1 <PROT_MODE_DSEG+0x3e1>
 388:	63 65 00             	arpl   %sp,0x0(%ebp)
 38b:	61                   	popa   
 38c:	6f                   	outsl  %ds:(%esi),(%dx)
 38d:	75 74                	jne    403 <PROT_MODE_DSEG+0x3f3>
 38f:	00 64 6b 65          	add    %ah,0x65(%ebx,%ebp,2)
 393:	72 6e                	jb     403 <PROT_MODE_DSEG+0x3f3>
 395:	65 6c                	gs insb (%dx),%es:(%edi)
 397:	00 65 5f             	add    %ah,0x5f(%ebp)
 39a:	70 68                	jo     404 <PROT_MODE_DSEG+0x3f4>
 39c:	6f                   	outsl  %ds:(%esi),(%dx)
 39d:	66 66 00 63 6f       	data16 data16 add %ah,0x6f(%ebx)
 3a2:	6e                   	outsb  %ds:(%esi),(%dx)
 3a3:	66 69 67 5f 74 61    	imul   $0x6174,0x5f(%edi),%sp
 3a9:	62 6c 65 00          	bound  %ebp,0x0(%ebp,%eiz,2)
 3ad:	65 5f                	gs pop %edi
 3af:	6d                   	insl   (%dx),%es:(%edi)
 3b0:	61                   	popa   
 3b1:	67 69 63 00 6c 61 73 	imul   $0x7473616c,0x0(%bp,%di),%esp
 3b8:	74 
 3b9:	5f                   	pop    %edi
 3ba:	63 68 73             	arpl   %bp,0x73(%eax)
 3bd:	00 62 61             	add    %ah,0x61(%edx)
 3c0:	73 65                	jae    427 <PROT_MODE_DSEG+0x417>
 3c2:	5f                   	pop    %edi
 3c3:	61                   	popa   
 3c4:	64 64 72 00          	fs fs jb 3c8 <PROT_MODE_DSEG+0x3b8>
 3c8:	76 62                	jbe    42c <PROT_MODE_DSEG+0x41c>
 3ca:	65 5f                	gs pop %edi
 3cc:	6d                   	insl   (%dx),%es:(%edi)
 3cd:	6f                   	outsl  %ds:(%esi),(%dx)
 3ce:	64 65 00 65 5f       	fs add %ah,%gs:0x5f(%ebp)
 3d3:	73 68                	jae    43d <PROT_MODE_DSEG+0x42d>
 3d5:	6f                   	outsl  %ds:(%esi),(%dx)
 3d6:	66 66 00 6d 65       	data16 data16 add %ch,0x65(%ebp)
 3db:	6d                   	insl   (%dx),%es:(%edi)
 3dc:	5f                   	pop    %edi
 3dd:	75 70                	jne    44f <PROT_MODE_DSEG+0x43f>
 3df:	70 65                	jo     446 <PROT_MODE_DSEG+0x436>
 3e1:	72 00                	jb     3e3 <PROT_MODE_DSEG+0x3d3>
 3e3:	76 62                	jbe    447 <PROT_MODE_DSEG+0x437>
 3e5:	65 5f                	gs pop %edi
 3e7:	6d                   	insl   (%dx),%es:(%edi)
 3e8:	6f                   	outsl  %ds:(%esi),(%dx)
 3e9:	64 65 5f             	fs gs pop %edi
 3ec:	69 6e 66 6f 00 74 61 	imul   $0x6174006f,0x66(%esi),%ebp
 3f3:	62 73 69             	bound  %esi,0x69(%ebx)
 3f6:	7a 65                	jp     45d <PROT_MODE_DSEG+0x44d>
 3f8:	00 66 69             	add    %ah,0x69(%esi)
 3fb:	72 73                	jb     470 <PROT_MODE_DSEG+0x460>
 3fd:	74 5f                	je     45e <PROT_MODE_DSEG+0x44e>
 3ff:	6c                   	insb   (%dx),%es:(%edi)
 400:	62 61 00             	bound  %esp,0x0(%ecx)
 403:	64 72 69             	fs jb  46f <PROT_MODE_DSEG+0x45f>
 406:	76 65                	jbe    46d <PROT_MODE_DSEG+0x45d>
 408:	73 5f                	jae    469 <PROT_MODE_DSEG+0x459>
 40a:	6c                   	insb   (%dx),%es:(%edi)
 40b:	65 6e                	outsb  %gs:(%esi),(%dx)
 40d:	67 74 68             	addr16 je 478 <PROT_MODE_DSEG+0x468>
 410:	00 70 5f             	add    %dh,0x5f(%eax)
 413:	66 69 6c 65 73 7a 00 	imul   $0x7a,0x73(%ebp,%eiz,2),%bp
 41a:	65 5f                	gs pop %edi
 41c:	70 68                	jo     486 <PROT_MODE_DSEG+0x476>
 41e:	6e                   	outsb  %ds:(%esi),(%dx)
 41f:	75 6d                	jne    48e <PROT_MODE_DSEG+0x47e>
 421:	00 73 69             	add    %dh,0x69(%ebx)
 424:	67 6e                	outsb  %ds:(%si),(%dx)
 426:	61                   	popa   
 427:	74 75                	je     49e <PROT_MODE_DSEG+0x48e>
 429:	72 65                	jb     490 <PROT_MODE_DSEG+0x480>
 42b:	00 65 5f             	add    %ah,0x5f(%ebp)
 42e:	73 68                	jae    498 <PROT_MODE_DSEG+0x488>
 430:	6e                   	outsb  %ds:(%esi),(%dx)
 431:	75 6d                	jne    4a0 <PROT_MODE_DSEG+0x490>
 433:	00 76 62             	add    %dh,0x62(%esi)
 436:	65 5f                	gs pop %edi
 438:	69 6e 74 65 72 66 61 	imul   $0x61667265,0x74(%esi),%ebp
 43f:	63 65 5f             	arpl   %sp,0x5f(%ebp)
 442:	6c                   	insb   (%dx),%es:(%edi)
 443:	65 6e                	outsb  %gs:(%esi),(%dx)
 445:	00 62 6f             	add    %ah,0x6f(%edx)
 448:	6f                   	outsl  %ds:(%esi),(%dx)
 449:	74 2f                	je     47a <PROT_MODE_DSEG+0x46a>
 44b:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 44e:	74 31                	je     481 <PROT_MODE_DSEG+0x471>
 450:	2f                   	das    
 451:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 454:	74 31                	je     487 <PROT_MODE_DSEG+0x477>
 456:	6d                   	insl   (%dx),%es:(%edi)
 457:	61                   	popa   
 458:	69 6e 2e 63 00 6d 6f 	imul   $0x6f6d0063,0x2e(%esi),%ebp
 45f:	64 73 5f             	fs jae 4c1 <PROT_MODE_DSEG+0x4b1>
 462:	63 6f 75             	arpl   %bp,0x75(%edi)
 465:	6e                   	outsb  %ds:(%esi),(%dx)
 466:	74 00                	je     468 <PROT_MODE_DSEG+0x458>
 468:	5f                   	pop    %edi
 469:	72 65                	jb     4d0 <PROT_MODE_DSEG+0x4c0>
 46b:	73 65                	jae    4d2 <PROT_MODE_DSEG+0x4c2>
 46d:	72 76                	jb     4e5 <PROT_MODE_DSEG+0x4d5>
 46f:	65 64 00 62 6f       	gs add %ah,%fs:0x6f(%edx)
 474:	6f                   	outsl  %ds:(%esi),(%dx)
 475:	74 5f                	je     4d6 <PROT_MODE_DSEG+0x4c6>
 477:	6c                   	insb   (%dx),%es:(%edi)
 478:	6f                   	outsl  %ds:(%esi),(%dx)
 479:	61                   	popa   
 47a:	64 65 72 5f          	fs gs jb 4dd <PROT_MODE_DSEG+0x4cd>
 47e:	6e                   	outsb  %ds:(%esi),(%dx)
 47f:	61                   	popa   
 480:	6d                   	insl   (%dx),%es:(%edi)
 481:	65 00 76 62          	add    %dh,%gs:0x62(%esi)
 485:	65 5f                	gs pop %edi
 487:	69 6e 74 65 72 66 61 	imul   $0x61667265,0x74(%esi),%ebp
 48e:	63 65 5f             	arpl   %sp,0x5f(%ebp)
 491:	73 65                	jae    4f8 <PROT_MODE_DSEG+0x4e8>
 493:	67 00 6d 6d          	add    %ch,0x6d(%di)
 497:	61                   	popa   
 498:	70 5f                	jo     4f9 <PROT_MODE_DSEG+0x4e9>
 49a:	6c                   	insb   (%dx),%es:(%edi)
 49b:	65 6e                	outsb  %gs:(%esi),(%dx)
 49d:	00 70 5f             	add    %dh,0x5f(%eax)
 4a0:	61                   	popa   
 4a1:	6c                   	insb   (%dx),%es:(%edi)
 4a2:	69 67 6e 00 61 70 6d 	imul   $0x6d706100,0x6e(%edi),%esp
 4a9:	5f                   	pop    %edi
 4aa:	74 61                	je     50d <PROT_MODE_DSEG+0x4fd>
 4ac:	62 6c 65 00          	bound  %ebp,0x0(%ebp,%eiz,2)
 4b0:	70 5f                	jo     511 <PROT_MODE_DSEG+0x501>
 4b2:	70 61                	jo     515 <PROT_MODE_DSEG+0x505>
 4b4:	00 73 65             	add    %dh,0x65(%ebx)
 4b7:	63 74 6f 72          	arpl   %si,0x72(%edi,%ebp,2)
 4bb:	73 5f                	jae    51c <PROT_MODE_DSEG+0x50c>
 4bd:	63 6f 75             	arpl   %bp,0x75(%edi)
 4c0:	6e                   	outsb  %ds:(%esi),(%dx)
 4c1:	74 00                	je     4c3 <PROT_MODE_DSEG+0x4b3>
 4c3:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 4c6:	74 2f                	je     4f7 <PROT_MODE_DSEG+0x4e7>
 4c8:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 4cb:	74 31                	je     4fe <PROT_MODE_DSEG+0x4ee>
 4cd:	2f                   	das    
 4ce:	65 78 65             	gs js  536 <PROT_MODE_DSEG+0x526>
 4d1:	63 5f 6b             	arpl   %bx,0x6b(%edi)
 4d4:	65 72 6e             	gs jb  545 <PROT_MODE_DSEG+0x535>
 4d7:	65 6c                	gs insb (%dx),%es:(%edi)
 4d9:	2e 53                	cs push %ebx
 4db:	00                   	.byte 0x0

Disassembly of section .debug_loc:

00000000 <.debug_loc>:
   0:	60                   	pusha  
   1:	02 00                	add    (%eax),%al
   3:	00 69 02             	add    %ch,0x2(%ecx)
   6:	00 00                	add    %al,(%eax)
   8:	02 00                	add    (%eax),%al
   a:	91                   	xchg   %eax,%ecx
   b:	00 69 02             	add    %ch,0x2(%ecx)
   e:	00 00                	add    %al,(%eax)
  10:	7a 02                	jp     14 <PROT_MODE_DSEG+0x4>
  12:	00 00                	add    %al,(%eax)
  14:	0a 00                	or     (%eax),%al
  16:	91                   	xchg   %eax,%ecx
  17:	00 06                	add    %al,(%esi)
  19:	0c ff                	or     $0xff,%al
  1b:	ff                   	(bad)  
  1c:	ff 00                	incl   (%eax)
  1e:	1a 9f 7a 02 00 00    	sbb    0x27a(%edi),%bl
  24:	80 02 00             	addb   $0x0,(%edx)
  27:	00 01                	add    %al,(%ecx)
  29:	00 56 80             	add    %dl,-0x80(%esi)
  2c:	02 00                	add    (%eax),%al
  2e:	00 90 02 00 00 01    	add    %dl,0x1000002(%eax)
  34:	00 53 90             	add    %dl,-0x70(%ebx)
  37:	02 00                	add    (%eax),%al
  39:	00 94 02 00 00 02 00 	add    %dl,0x20000(%edx,%eax,1)
  40:	74 00                	je     42 <PROT_MODE_DSEG+0x32>
  42:	94                   	xchg   %eax,%esp
  43:	02 00                	add    (%eax),%al
  45:	00 95 02 00 00 04    	add    %dl,0x4000002(%ebp)
  4b:	00 73 80             	add    %dh,-0x80(%ebx)
  4e:	7c 9f                	jl     ffffffef <SMAP_SIG+0xacb2be9f>
  50:	95                   	xchg   %eax,%ebp
  51:	02 00                	add    (%eax),%al
  53:	00 9d 02 00 00 01    	add    %bl,0x1000002(%ebp)
  59:	00 53 00             	add    %dl,0x0(%ebx)
  5c:	00 00                	add    %al,(%eax)
  5e:	00 00                	add    %al,(%eax)
  60:	00 00                	add    %al,(%eax)
  62:	00 60 02             	add    %ah,0x2(%eax)
  65:	00 00                	add    %al,(%eax)
  67:	83 02 00             	addl   $0x0,(%edx)
  6a:	00 02                	add    %al,(%edx)
  6c:	00 91 08 83 02 00    	add    %dl,0x28308(%ecx)
  72:	00 8a 02 00 00 01    	add    %cl,0x1000002(%edx)
  78:	00 57 8a             	add    %dl,-0x76(%edi)
  7b:	02 00                	add    (%eax),%al
  7d:	00 94 02 00 00 02 00 	add    %dl,0x20000(%edx,%eax,1)
  84:	74 04                	je     8a <PROT_MODE_DSEG+0x7a>
  86:	94                   	xchg   %eax,%esp
  87:	02 00                	add    (%eax),%al
  89:	00 95 02 00 00 03    	add    %dl,0x3000002(%ebp)
  8f:	00 77 7f             	add    %dh,0x7f(%edi)
  92:	9f                   	lahf   
  93:	95                   	xchg   %eax,%ebp
  94:	02 00                	add    (%eax),%al
  96:	00 9f 02 00 00 01    	add    %bl,0x1000002(%edi)
  9c:	00 57 00             	add    %dl,0x0(%edi)
  9f:	00 00                	add    %al,(%eax)
  a1:	00 00                	add    %al,(%eax)
  a3:	00 00                	add    %al,(%eax)
  a5:	00 80 02 00 00 9e    	add    %al,-0x61fffffe(%eax)
  ab:	02 00                	add    (%eax),%al
  ad:	00 01                	add    %al,(%ecx)
  af:	00 56 9e             	add    %dl,-0x62(%esi)
  b2:	02 00                	add    (%eax),%al
  b4:	00 a1 02 00 00 0e    	add    %ah,0xe000002(%ecx)
  ba:	00 91 00 06 0c ff    	add    %dl,-0xf3fa00(%ecx)
  c0:	ff                   	(bad)  
  c1:	ff 00                	incl   (%eax)
  c3:	1a 91 04 06 22 9f    	sbb    -0x60ddf9fc(%ecx),%dl
  c9:	00 00                	add    %al,(%eax)
  cb:	00 00                	add    %al,(%eax)
  cd:	00 00                	add    %al,(%eax)
  cf:	00 00                	add    %al,(%eax)
  d1:	fd                   	std    
  d2:	01 00                	add    %eax,(%eax)
  d4:	00 00                	add    %al,(%eax)
  d6:	02 00                	add    (%eax),%al
  d8:	00 04 00             	add    %al,(%eax,%eax,1)
  db:	0a f7                	or     %bh,%dh
  dd:	01 9f 00 00 00 00    	add    %ebx,0x0(%edi)
  e3:	00 00                	add    %al,(%eax)
  e5:	00 00                	add    %al,(%eax)
  e7:	07                   	pop    %es
  e8:	02 00                	add    (%eax),%al
  ea:	00 0f                	add    %cl,(%edi)
  ec:	02 00                	add    (%eax),%al
  ee:	00 02                	add    %al,(%edx)
  f0:	00 31                	add    %dh,(%ecx)
  f2:	9f                   	lahf   
  f3:	00 00                	add    %al,(%eax)
  f5:	00 00                	add    %al,(%eax)
  f7:	00 00                	add    %al,(%eax)
  f9:	00 00                	add    %al,(%eax)
  fb:	07                   	pop    %es
  fc:	02 00                	add    (%eax),%al
  fe:	00 0f                	add    %cl,(%edi)
 100:	02 00                	add    (%eax),%al
 102:	00 04 00             	add    %al,(%eax,%eax,1)
 105:	0a f2                	or     %dl,%dh
 107:	01 9f 00 00 00 00    	add    %ebx,0x0(%edi)
 10d:	00 00                	add    %al,(%eax)
 10f:	00 00                	add    %al,(%eax)
 111:	0f 02 00             	lar    (%eax),%eax
 114:	00 17                	add    %dl,(%edi)
 116:	02 00                	add    (%eax),%al
 118:	00 01                	add    %al,(%ecx)
 11a:	00 51 00             	add    %dl,0x0(%ecx)
 11d:	00 00                	add    %al,(%eax)
 11f:	00 00                	add    %al,(%eax)
 121:	00 00                	add    %al,(%eax)
 123:	00 0f                	add    %cl,(%edi)
 125:	02 00                	add    (%eax),%al
 127:	00 17                	add    %dl,(%edi)
 129:	02 00                	add    (%eax),%al
 12b:	00 04 00             	add    %al,(%eax,%eax,1)
 12e:	0a f3                	or     %bl,%dh
 130:	01 9f 00 00 00 00    	add    %ebx,0x0(%edi)
 136:	00 00                	add    %al,(%eax)
 138:	00 00                	add    %al,(%eax)
 13a:	17                   	pop    %ss
 13b:	02 00                	add    (%eax),%al
 13d:	00 22                	add    %ah,(%edx)
 13f:	02 00                	add    (%eax),%al
 141:	00 02                	add    %al,(%edx)
 143:	00 91 05 00 00 00    	add    %dl,0x5(%ecx)
 149:	00 00                	add    %al,(%eax)
 14b:	00 00                	add    %al,(%eax)
 14d:	00 17                	add    %dl,(%edi)
 14f:	02 00                	add    (%eax),%al
 151:	00 22                	add    %ah,(%edx)
 153:	02 00                	add    (%eax),%al
 155:	00 04 00             	add    %al,(%eax,%eax,1)
 158:	0a f4                	or     %ah,%dh
 15a:	01 9f 00 00 00 00    	add    %ebx,0x0(%edi)
 160:	00 00                	add    %al,(%eax)
 162:	00 00                	add    %al,(%eax)
 164:	22 02                	and    (%edx),%al
 166:	00 00                	add    %al,(%eax)
 168:	2d 02 00 00 02       	sub    $0x2000002,%eax
 16d:	00 91 06 00 00 00    	add    %dl,0x6(%ecx)
 173:	00 00                	add    %al,(%eax)
 175:	00 00                	add    %al,(%eax)
 177:	00 22                	add    %ah,(%edx)
 179:	02 00                	add    (%eax),%al
 17b:	00 2d 02 00 00 04    	add    %ch,0x4000002
 181:	00 0a                	add    %cl,(%edx)
 183:	f5                   	cmc    
 184:	01 9f 00 00 00 00    	add    %ebx,0x0(%edi)
 18a:	00 00                	add    %al,(%eax)
 18c:	00 00                	add    %al,(%eax)
 18e:	2d 02 00 00 3b       	sub    $0x3b000002,%eax
 193:	02 00                	add    (%eax),%al
 195:	00 08                	add    %cl,(%eax)
 197:	00 91 07 94 01 09    	add    %dl,0x9019407(%ecx)
 19d:	e0 21                	loopne 1c0 <PROT_MODE_DSEG+0x1b0>
 19f:	9f                   	lahf   
 1a0:	00 00                	add    %al,(%eax)
 1a2:	00 00                	add    %al,(%eax)
 1a4:	00 00                	add    %al,(%eax)
 1a6:	00 00                	add    %al,(%eax)
 1a8:	2d 02 00 00 3b       	sub    $0x3b000002,%eax
 1ad:	02 00                	add    (%eax),%al
 1af:	00 04 00             	add    %al,(%eax,%eax,1)
 1b2:	0a f6                	or     %dh,%dh
 1b4:	01 9f 00 00 00 00    	add    %ebx,0x0(%edi)
 1ba:	00 00                	add    %al,(%eax)
 1bc:	00 00                	add    %al,(%eax)
 1be:	3b 02                	cmp    (%edx),%eax
 1c0:	00 00                	add    %al,(%eax)
 1c2:	40                   	inc    %eax
 1c3:	02 00                	add    (%eax),%al
 1c5:	00 03                	add    %al,(%ebx)
 1c7:	00 08                	add    %cl,(%eax)
 1c9:	20 9f 00 00 00 00    	and    %bl,0x0(%edi)
 1cf:	00 00                	add    %al,(%eax)
 1d1:	00 00                	add    %al,(%eax)
 1d3:	3b 02                	cmp    (%edx),%eax
 1d5:	00 00                	add    %al,(%eax)
 1d7:	40                   	inc    %eax
 1d8:	02 00                	add    (%eax),%al
 1da:	00 04 00             	add    %al,(%eax,%eax,1)
 1dd:	0a f7                	or     %bh,%dh
 1df:	01 9f 00 00 00 00    	add    %ebx,0x0(%edi)
 1e5:	00 00                	add    %al,(%eax)
 1e7:	00 00                	add    %al,(%eax)
 1e9:	45                   	inc    %ebp
 1ea:	02 00                	add    (%eax),%al
 1ec:	00 46 02             	add    %al,0x2(%esi)
 1ef:	00 00                	add    %al,(%eax)
 1f1:	04 00                	add    $0x0,%al
 1f3:	0a f7                	or     %bh,%dh
 1f5:	01 9f 00 00 00 00    	add    %ebx,0x0(%edi)
 1fb:	00 00                	add    %al,(%eax)
 1fd:	00 00                	add    %al,(%eax)
 1ff:	4d                   	dec    %ebp
 200:	02 00                	add    (%eax),%al
 202:	00 5d 02             	add    %bl,0x2(%ebp)
 205:	00 00                	add    %al,(%eax)
 207:	03 00                	add    (%eax),%eax
 209:	08 80 9f 00 00 00    	or     %al,0x9f(%eax)
 20f:	00 00                	add    %al,(%eax)
 211:	00 00                	add    %al,(%eax)
 213:	00 4d 02             	add    %cl,0x2(%ebp)
 216:	00 00                	add    %al,(%eax)
 218:	5d                   	pop    %ebp
 219:	02 00                	add    (%eax),%al
 21b:	00 02                	add    %al,(%edx)
 21d:	00 91 00 00 00 00    	add    %dl,0x0(%ecx)
 223:	00 00                	add    %al,(%eax)
 225:	00 00                	add    %al,(%eax)
 227:	00 4d 02             	add    %cl,0x2(%ebp)
 22a:	00 00                	add    %al,(%eax)
 22c:	5d                   	pop    %ebp
 22d:	02 00                	add    (%eax),%al
 22f:	00 04 00             	add    %al,(%eax,%eax,1)
 232:	0a f0                	or     %al,%dh
 234:	01 9f 00 00 00 00    	add    %ebx,0x0(%edi)
 23a:	00 00                	add    %al,(%eax)
 23c:	00 00                	add    %al,(%eax)
 23e:	19 01                	sbb    %eax,(%ecx)
 240:	00 00                	add    %al,(%eax)
 242:	43                   	inc    %ebx
 243:	01 00                	add    %eax,(%eax)
 245:	00 02                	add    %al,(%edx)
 247:	00 91 00 43 01 00    	add    %dl,0x14300(%ecx)
 24d:	00 70 01             	add    %dh,0x1(%eax)
 250:	00 00                	add    %al,(%eax)
 252:	01 00                	add    %eax,(%eax)
 254:	50                   	push   %eax
 255:	00 00                	add    %al,(%eax)
 257:	00 00                	add    %al,(%eax)
 259:	00 00                	add    %al,(%eax)
 25b:	00 00                	add    %al,(%eax)
 25d:	43                   	inc    %ebx
 25e:	01 00                	add    %eax,(%eax)
 260:	00 47 01             	add    %al,0x1(%edi)
 263:	00 00                	add    %al,(%eax)
 265:	01 00                	add    %eax,(%eax)
 267:	53                   	push   %ebx
 268:	47                   	inc    %edi
 269:	01 00                	add    %eax,(%eax)
 26b:	00 5b 01             	add    %bl,0x1(%ebx)
 26e:	00 00                	add    %al,(%eax)
 270:	01 00                	add    %eax,(%eax)
 272:	57                   	push   %edi
 273:	5b                   	pop    %ebx
 274:	01 00                	add    %eax,(%eax)
 276:	00 64 01 00          	add    %ah,0x0(%ecx,%eax,1)
 27a:	00 01                	add    %al,(%ecx)
 27c:	00 52 64             	add    %dl,0x64(%edx)
 27f:	01 00                	add    %eax,(%eax)
 281:	00 74 01 00          	add    %dh,0x0(%ecx,%eax,1)
 285:	00 01                	add    %al,(%ecx)
 287:	00 57 00             	add    %dl,0x0(%edi)
 28a:	00 00                	add    %al,(%eax)
 28c:	00 00                	add    %al,(%eax)
 28e:	00 00                	add    %al,(%eax)
 290:	00 1c 01             	add    %bl,(%ecx,%eax,1)
 293:	00 00                	add    %al,(%eax)
 295:	30 01                	xor    %al,(%ecx)
 297:	00 00                	add    %al,(%eax)
 299:	02 00                	add    (%eax),%al
 29b:	91                   	xchg   %eax,%ecx
 29c:	68 00 00 00 00       	push   $0x0
 2a1:	00 00                	add    %al,(%eax)
 2a3:	00 00                	add    %al,(%eax)
 2a5:	e9 00 00 00 fb       	jmp    fb0002aa <SMAP_SIG+0xa7b2c15a>
 2aa:	00 00                	add    %al,(%eax)
 2ac:	00 02                	add    %al,(%edx)
 2ae:	00 30                	add    %dh,(%eax)
 2b0:	9f                   	lahf   
 2b1:	fb                   	sti    
 2b2:	00 00                	add    %al,(%eax)
 2b4:	00 19                	add    %bl,(%ecx)
 2b6:	01 00                	add    %eax,(%eax)
 2b8:	00 01                	add    %al,(%ecx)
 2ba:	00 52 00             	add    %dl,0x0(%edx)
 2bd:	00 00                	add    %al,(%eax)
 2bf:	00 00                	add    %al,(%eax)
 2c1:	00 00                	add    %al,(%eax)
 2c3:	00 03                	add    %al,(%ebx)
 2c5:	01 00                	add    %eax,(%eax)
 2c7:	00 12                	add    %dl,(%edx)
 2c9:	01 00                	add    %eax,(%eax)
 2cb:	00 01                	add    %al,(%ecx)
 2cd:	00 56 00             	add    %dl,0x0(%esi)
 2d0:	00 00                	add    %al,(%eax)
 2d2:	00 00                	add    %al,(%eax)
 2d4:	00 00                	add    %al,(%eax)
 2d6:	00 d6                	add    %dl,%dh
 2d8:	00 00                	add    %al,(%eax)
 2da:	00 de                	add    %bl,%dh
 2dc:	00 00                	add    %al,(%eax)
 2de:	00 02                	add    %al,(%edx)
 2e0:	00 91 00 de 00 00    	add    %dl,0xde00(%ecx)
 2e6:	00 e9                	add    %ch,%cl
 2e8:	00 00                	add    %al,(%eax)
 2ea:	00 07                	add    %al,(%edi)
 2ec:	00 91 00 06 70 00    	add    %dl,0x700600(%ecx)
 2f2:	22 9f 00 00 00 00    	and    0x0(%edi),%bl
 2f8:	00 00                	add    %al,(%eax)
 2fa:	00 00                	add    %al,(%eax)
 2fc:	d6                   	(bad)  
 2fd:	00 00                	add    %al,(%eax)
 2ff:	00 de                	add    %bl,%dh
 301:	00 00                	add    %al,(%eax)
 303:	00 02                	add    %al,(%edx)
 305:	00 30                	add    %dh,(%eax)
 307:	9f                   	lahf   
 308:	de 00                	fiadds (%eax)
 30a:	00 00                	add    %al,(%eax)
 30c:	e9 00 00 00 01       	jmp    1000311 <_end+0xff6f85>
 311:	00 50 00             	add    %dl,0x0(%eax)
 314:	00 00                	add    %al,(%eax)
 316:	00 00                	add    %al,(%eax)
 318:	00 00                	add    %al,(%eax)
 31a:	00 c6                	add    %al,%dh
 31c:	01 00                	add    %eax,(%eax)
 31e:	00 e8                	add    %ch,%al
 320:	01 00                	add    %eax,(%eax)
 322:	00 02                	add    %al,(%edx)
 324:	00 91 00 00 00 00    	add    %dl,0x0(%ecx)
 32a:	00 00                	add    %al,(%eax)
 32c:	00 00                	add    %al,(%eax)
 32e:	00 26                	add    %ah,(%esi)
 330:	00 00                	add    %al,(%eax)
 332:	00 37                	add    %dh,(%edi)
 334:	00 00                	add    %al,(%eax)
 336:	00 02                	add    %al,(%edx)
 338:	00 91 0c 37 00 00    	add    %dl,0x370c(%ecx)
 33e:	00 44 00 00          	add    %al,0x0(%eax,%eax,1)
 342:	00 0a                	add    %cl,(%edx)
 344:	00 91 0c 06 70 00    	add    %dl,0x70060c(%ecx)
 34a:	22 76 00             	and    0x0(%esi),%dh
 34d:	1c 9f                	sbb    $0x9f,%al
 34f:	44                   	inc    %esp
 350:	00 00                	add    %al,(%eax)
 352:	00 4e 00             	add    %cl,0x0(%esi)
 355:	00 00                	add    %al,(%eax)
 357:	0c 00                	or     $0x0,%al
 359:	91                   	xchg   %eax,%ecx
 35a:	0c 06                	or     $0x6,%al
 35c:	70 00                	jo     35e <PROT_MODE_DSEG+0x34e>
 35e:	22 76 00             	and    0x0(%esi),%dh
 361:	1c 23                	sbb    $0x23,%al
 363:	01 9f 4e 00 00 00    	add    %ebx,0x4e(%edi)
 369:	56                   	push   %esi
 36a:	00 00                	add    %al,(%eax)
 36c:	00 0a                	add    %cl,(%edx)
 36e:	00 91 0c 06 73 00    	add    %dl,0x73060c(%ecx)
 374:	22 76 00             	and    0x0(%esi),%dh
 377:	1c 9f                	sbb    $0x9f,%al
 379:	56                   	push   %esi
 37a:	00 00                	add    %al,(%eax)
 37c:	00 5b 00             	add    %bl,0x0(%ebx)
 37f:	00 00                	add    %al,(%eax)
 381:	0a 00                	or     (%eax),%al
 383:	91                   	xchg   %eax,%ecx
 384:	0c 06                	or     $0x6,%al
 386:	70 00                	jo     388 <PROT_MODE_DSEG+0x378>
 388:	22 76 00             	and    0x0(%esi),%dh
 38b:	1c 9f                	sbb    $0x9f,%al
 38d:	5b                   	pop    %ebx
 38e:	00 00                	add    %al,(%eax)
 390:	00 5d 00             	add    %bl,0x0(%ebp)
 393:	00 00                	add    %al,(%eax)
 395:	12 00                	adc    (%eax),%al
 397:	91                   	xchg   %eax,%ecx
 398:	0c 06                	or     $0x6,%al
 39a:	91                   	xchg   %eax,%ecx
 39b:	00 06                	add    %al,(%esi)
 39d:	08 50 1e             	or     %dl,0x1e(%eax)
 3a0:	1c 70                	sbb    $0x70,%al
 3a2:	00 22                	add    %ah,(%edx)
 3a4:	91                   	xchg   %eax,%ecx
 3a5:	04 06                	add    $0x6,%al
 3a7:	1c 9f                	sbb    $0x9f,%al
 3a9:	00 00                	add    %al,(%eax)
 3ab:	00 00                	add    %al,(%eax)
 3ad:	00 00                	add    %al,(%eax)
 3af:	00 00                	add    %al,(%eax)
 3b1:	35 00 00 00 37       	xor    $0x37000000,%eax
 3b6:	00 00                	add    %al,(%eax)
 3b8:	00 01                	add    %al,(%ecx)
 3ba:	00 56 37             	add    %dl,0x37(%esi)
 3bd:	00 00                	add    %al,(%eax)
 3bf:	00 48 00             	add    %cl,0x0(%eax)
 3c2:	00 00                	add    %al,(%eax)
 3c4:	01 00                	add    %eax,(%eax)
 3c6:	50                   	push   %eax
 3c7:	48                   	dec    %eax
 3c8:	00 00                	add    %al,(%eax)
 3ca:	00 56 00             	add    %dl,0x0(%esi)
 3cd:	00 00                	add    %al,(%eax)
 3cf:	01 00                	add    %eax,(%eax)
 3d1:	53                   	push   %ebx
 3d2:	56                   	push   %esi
 3d3:	00 00                	add    %al,(%eax)
 3d5:	00 5d 00             	add    %bl,0x0(%ebp)
 3d8:	00 00                	add    %al,(%eax)
 3da:	01 00                	add    %eax,(%eax)
 3dc:	50                   	push   %eax
 3dd:	00 00                	add    %al,(%eax)
 3df:	00 00                	add    %al,(%eax)
 3e1:	00 00                	add    %al,(%eax)
 3e3:	00 00                	add    %al,(%eax)
 3e5:	a8 00                	test   $0x0,%al
 3e7:	00 00                	add    %al,(%eax)
 3e9:	b7 00                	mov    $0x0,%bh
 3eb:	00 00                	add    %al,(%eax)
 3ed:	01 00                	add    %eax,(%eax)
 3ef:	57                   	push   %edi
 3f0:	b7 00                	mov    $0x0,%bh
 3f2:	00 00                	add    %al,(%eax)
 3f4:	c9                   	leave  
 3f5:	00 00                	add    %al,(%eax)
 3f7:	00 06                	add    %al,(%esi)
 3f9:	00 77 00             	add    %dh,0x0(%edi)
 3fc:	76 00                	jbe    3fe <PROT_MODE_DSEG+0x3ee>
 3fe:	22 9f c9 00 00 00    	and    0xc9(%edi),%bl
 404:	cf                   	iret   
 405:	00 00                	add    %al,(%eax)
 407:	00 08                	add    %cl,(%eax)
 409:	00 77 00             	add    %dh,0x0(%edi)
 40c:	76 00                	jbe    40e <PROT_MODE_DSEG+0x3fe>
 40e:	22 48 1c             	and    0x1c(%eax),%cl
 411:	9f                   	lahf   
 412:	d4 00                	aam    $0x0
 414:	00 00                	add    %al,(%eax)
 416:	fc                   	cld    
 417:	00 00                	add    %al,(%eax)
 419:	00 06                	add    %al,(%esi)
 41b:	00 77 00             	add    %dh,0x0(%edi)
 41e:	76 00                	jbe    420 <PROT_MODE_DSEG+0x410>
 420:	22 9f fc 00 00 00    	and    0xfc(%edi),%bl
 426:	fd                   	std    
 427:	00 00                	add    %al,(%eax)
 429:	00 0a                	add    %cl,(%edx)
 42b:	00 77 00             	add    %dh,0x0(%edi)
 42e:	03 2c 93             	add    (%ebx,%edx,4),%ebp
 431:	00 00                	add    %al,(%eax)
 433:	06                   	push   %es
 434:	22 9f fd 00 00 00    	and    0xfd(%edi),%bl
 43a:	ff 00                	incl   (%eax)
 43c:	00 00                	add    %al,(%eax)
 43e:	0b 00                	or     (%eax),%eax
 440:	91                   	xchg   %eax,%ecx
 441:	00 06                	add    %al,(%esi)
 443:	03 2c 93             	add    (%ebx,%edx,4),%ebp
 446:	00 00                	add    %al,(%eax)
 448:	06                   	push   %es
 449:	22 9f 00 00 00 00    	and    0x0(%edi),%bl
 44f:	00 00                	add    %al,(%eax)
 451:	00 00                	add    %al,(%eax)
 453:	a8 00                	test   $0x0,%al
 455:	00 00                	add    %al,(%eax)
 457:	b7 00                	mov    $0x0,%bh
 459:	00 00                	add    %al,(%eax)
 45b:	02 00                	add    (%eax),%al
 45d:	30 9f b7 00 00 00    	xor    %bl,0xb7(%edi)
 463:	c9                   	leave  
 464:	00 00                	add    %al,(%eax)
 466:	00 01                	add    %al,(%ecx)
 468:	00 56 c9             	add    %dl,-0x37(%esi)
 46b:	00 00                	add    %al,(%eax)
 46d:	00 cf                	add    %cl,%bh
 46f:	00 00                	add    %al,(%eax)
 471:	00 03                	add    %al,(%ebx)
 473:	00 76 68             	add    %dh,0x68(%esi)
 476:	9f                   	lahf   
 477:	cf                   	iret   
 478:	00 00                	add    %al,(%eax)
 47a:	00 fc                	add    %bh,%ah
 47c:	00 00                	add    %al,(%eax)
 47e:	00 01                	add    %al,(%ecx)
 480:	00 56 fc             	add    %dl,-0x4(%esi)
 483:	00 00                	add    %al,(%eax)
 485:	00 ff                	add    %bh,%bh
 487:	00 00                	add    %al,(%eax)
 489:	00 05 00 03 2c 93    	add    %al,0x932c0300
 48f:	00 00                	add    %al,(%eax)
 491:	00 00                	add    %al,(%eax)
 493:	00 00                	add    %al,(%eax)
 495:	00 00                	add    %al,(%eax)
 497:	00 00                	add    %al,(%eax)
 499:	5b                   	pop    %ebx
 49a:	00 00                	add    %al,(%eax)
 49c:	00 6d 00             	add    %ch,0x0(%ebp)
 49f:	00 00                	add    %al,(%eax)
 4a1:	01 00                	add    %eax,(%eax)
 4a3:	57                   	push   %edi
 4a4:	6d                   	insl   (%dx),%es:(%edi)
 4a5:	00 00                	add    %al,(%eax)
 4a7:	00 78 00             	add    %bh,0x0(%eax)
 4aa:	00 00                	add    %al,(%eax)
 4ac:	03 00                	add    (%eax),%eax
 4ae:	77 60                	ja     510 <PROT_MODE_DSEG+0x500>
 4b0:	9f                   	lahf   
 4b1:	78 00                	js     4b3 <PROT_MODE_DSEG+0x4a3>
 4b3:	00 00                	add    %al,(%eax)
 4b5:	8d 00                	lea    (%eax),%eax
 4b7:	00 00                	add    %al,(%eax)
 4b9:	01 00                	add    %eax,(%eax)
 4bb:	57                   	push   %edi
 4bc:	00 00                	add    %al,(%eax)
 4be:	00 00                	add    %al,(%eax)
 4c0:	00 00                	add    %al,(%eax)
 4c2:	00 00                	add    %al,(%eax)
 4c4:	60                   	pusha  
 4c5:	00 00                	add    %al,(%eax)
 4c7:	00 8c 00 00 00 01 00 	add    %cl,0x10000(%eax,%eax,1)
 4ce:	56                   	push   %esi
 4cf:	00 00                	add    %al,(%eax)
 4d1:	00 00                	add    %al,(%eax)
 4d3:	00 00                	add    %al,(%eax)
 4d5:	00 00                	add    %al,(%eax)
 4d7:	2d 01 00 00 30       	sub    $0x30000001,%eax
 4dc:	01 00                	add    %eax,(%eax)
 4de:	00 02                	add    %al,(%edx)
 4e0:	00 30                	add    %dh,(%eax)
 4e2:	9f                   	lahf   
 4e3:	30 01                	xor    %al,(%ecx)
 4e5:	00 00                	add    %al,(%eax)
 4e7:	48                   	dec    %eax
 4e8:	01 00                	add    %eax,(%eax)
 4ea:	00 01                	add    %al,(%ecx)
 4ec:	00 56 48             	add    %dl,0x48(%esi)
 4ef:	01 00                	add    %eax,(%eax)
 4f1:	00 4b 01             	add    %cl,0x1(%ebx)
 4f4:	00 00                	add    %al,(%eax)
 4f6:	03 00                	add    (%eax),%eax
 4f8:	76 65                	jbe    55f <PROT_MODE_DSEG+0x54f>
 4fa:	9f                   	lahf   
 4fb:	6e                   	outsb  %ds:(%esi),(%dx)
 4fc:	01 00                	add    %eax,(%eax)
 4fe:	00 74 01 00          	add    %dh,0x0(%ecx,%eax,1)
 502:	00 01                	add    %al,(%ecx)
 504:	00 56 00             	add    %dl,0x0(%esi)
 507:	00 00                	add    %al,(%eax)
 509:	00 00                	add    %al,(%eax)
 50b:	00 00                	add    %al,(%eax)
 50d:	00                   	.byte 0x0

Disassembly of section .debug_ranges:

00000000 <.debug_ranges>:
   0:	f5                   	cmc    
   1:	01 00                	add    %eax,(%eax)
   3:	00 fa                	add    %bh,%dl
   5:	01 00                	add    %eax,(%eax)
   7:	00 fd                	add    %bh,%ch
   9:	01 00                	add    %eax,(%eax)
   b:	00 07                	add    %al,(%edi)
   d:	02 00                	add    (%eax),%al
   f:	00 00                	add    %al,(%eax)
  11:	00 00                	add    %al,(%eax)
  13:	00 00                	add    %al,(%eax)
  15:	00 00                	add    %al,(%eax)
  17:	00 f5                	add    %dh,%ch
  19:	01 00                	add    %eax,(%eax)
  1b:	00 fa                	add    %bh,%dl
  1d:	01 00                	add    %eax,(%eax)
  1f:	00 fd                	add    %bh,%ch
  21:	01 00                	add    %eax,(%eax)
  23:	00 00                	add    %al,(%eax)
  25:	02 00                	add    (%eax),%al
  27:	00 00                	add    %al,(%eax)
  29:	00 00                	add    %al,(%eax)
  2b:	00 00                	add    %al,(%eax)
  2d:	00 00                	add    %al,(%eax)
  2f:	00 19                	add    %bl,(%ecx)
  31:	02 00                	add    (%eax),%al
  33:	00 1e                	add    %bl,(%esi)
  35:	02 00                	add    (%eax),%al
  37:	00 21                	add    %ah,(%ecx)
  39:	02 00                	add    (%eax),%al
  3b:	00 22                	add    %ah,(%edx)
  3d:	02 00                	add    (%eax),%al
  3f:	00 00                	add    %al,(%eax)
  41:	00 00                	add    %al,(%eax)
  43:	00 00                	add    %al,(%eax)
  45:	00 00                	add    %al,(%eax)
  47:	00 24 02             	add    %ah,(%edx,%eax,1)
  4a:	00 00                	add    %al,(%eax)
  4c:	29 02                	sub    %eax,(%edx)
  4e:	00 00                	add    %al,(%eax)
  50:	2c 02                	sub    $0x2,%al
  52:	00 00                	add    %al,(%eax)
  54:	2d 02 00 00 00       	sub    $0x2,%eax
  59:	00 00                	add    %al,(%eax)
  5b:	00 00                	add    %al,(%eax)
  5d:	00 00                	add    %al,(%eax)
  5f:	00 2f                	add    %ch,(%edi)
  61:	02 00                	add    (%eax),%al
  63:	00 34 02             	add    %dh,(%edx,%eax,1)
  66:	00 00                	add    %al,(%eax)
  68:	3a 02                	cmp    (%edx),%al
  6a:	00 00                	add    %al,(%eax)
  6c:	3b 02                	cmp    (%edx),%eax
  6e:	00 00                	add    %al,(%eax)
  70:	00 00                	add    %al,(%eax)
  72:	00 00                	add    %al,(%eax)
  74:	00 00                	add    %al,(%eax)
  76:	00 00                	add    %al,(%eax)
  78:	05 01 00 00 12       	add    $0x12000001,%eax
  7d:	01 00                	add    %eax,(%eax)
  7f:	00 30                	add    %dh,(%eax)
  81:	01 00                	add    %eax,(%eax)
  83:	00 74 01 00          	add    %dh,0x0(%ecx,%eax,1)
  87:	00 00                	add    %al,(%eax)
  89:	00 00                	add    %al,(%eax)
  8b:	00 00                	add    %al,(%eax)
  8d:	00 00                	add    %al,(%eax)
  8f:	00                   	.byte 0x0
