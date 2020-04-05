
obj/kern/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <video_init>:
#include "video.h"
//tmphack
//#include<dev/serial.h>
void
video_init(void)
{
  100000:	55                   	push   %ebp
  100001:	57                   	push   %edi
  100002:	56                   	push   %esi
  100003:	53                   	push   %ebx
  100004:	83 ec 0c             	sub    $0xc,%esp
  100007:	e8 03 03 00 00       	call   10030f <__x86.get_pc_thunk.bx>
  10000c:	81 c3 f4 af 00 00    	add    $0xaff4,%ebx
	uint16_t was;
	unsigned pos;

	/* Get a pointer to the memory-mapped text display buffer. */
	cp = (uint16_t*) CGA_BUF;
	was = *cp;
  100012:	0f b7 15 00 80 0b 00 	movzwl 0xb8000,%edx
	*cp = (uint16_t) 0xA55A;
  100019:	66 c7 05 00 80 0b 00 	movw   $0xa55a,0xb8000
  100020:	5a a5 
	if (*cp != 0xA55A) {
  100022:	0f b7 05 00 80 0b 00 	movzwl 0xb8000,%eax
  100029:	66 3d 5a a5          	cmp    $0xa55a,%ax
  10002d:	0f 84 86 00 00 00    	je     1000b9 <video_init+0xb9>
		cp = (uint16_t*) MONO_BUF;
		addr_6845 = MONO_BASE;
  100033:	c7 c0 6c 94 16 00    	mov    $0x16946c,%eax
  100039:	c7 00 b4 03 00 00    	movl   $0x3b4,(%eax)
		dprintf("addr_6845:%x\n",addr_6845);
  10003f:	83 ec 08             	sub    $0x8,%esp
  100042:	68 b4 03 00 00       	push   $0x3b4
  100047:	8d 83 a0 aa ff ff    	lea    -0x5560(%ebx),%eax
  10004d:	50                   	push   %eax
  10004e:	e8 dc 1f 00 00       	call   10202f <dprintf>
  100053:	83 c4 10             	add    $0x10,%esp
		cp = (uint16_t*) MONO_BUF;
  100056:	bd 00 00 0b 00       	mov    $0xb0000,%ebp
		addr_6845 = CGA_BASE;
		dprintf("addr_6845:%x\n",addr_6845);
	}
	
	/* Extract cursor location */
	outb(addr_6845, 14);
  10005b:	83 ec 08             	sub    $0x8,%esp
  10005e:	6a 0e                	push   $0xe
  100060:	c7 c7 6c 94 16 00    	mov    $0x16946c,%edi
  100066:	ff 37                	pushl  (%edi)
  100068:	e8 2c 28 00 00       	call   102899 <outb>
	pos = inb(addr_6845 + 1) << 8;
  10006d:	8b 07                	mov    (%edi),%eax
  10006f:	83 c0 01             	add    $0x1,%eax
  100072:	89 04 24             	mov    %eax,(%esp)
  100075:	e8 07 28 00 00       	call   102881 <inb>
  10007a:	0f b6 f0             	movzbl %al,%esi
  10007d:	c1 e6 08             	shl    $0x8,%esi
	outb(addr_6845, 15);
  100080:	83 c4 08             	add    $0x8,%esp
  100083:	6a 0f                	push   $0xf
  100085:	ff 37                	pushl  (%edi)
  100087:	e8 0d 28 00 00       	call   102899 <outb>
	pos |= inb(addr_6845 + 1);
  10008c:	8b 07                	mov    (%edi),%eax
  10008e:	83 c0 01             	add    $0x1,%eax
  100091:	89 04 24             	mov    %eax,(%esp)
  100094:	e8 e8 27 00 00       	call   102881 <inb>
  100099:	0f b6 c0             	movzbl %al,%eax
  10009c:	09 c6                	or     %eax,%esi

	terminal.crt_buf = (uint16_t*) cp;
  10009e:	c7 c0 60 94 16 00    	mov    $0x169460,%eax
  1000a4:	89 28                	mov    %ebp,(%eax)
	terminal.crt_pos = pos;
  1000a6:	66 89 70 04          	mov    %si,0x4(%eax)
	terminal.active_console = 0;
  1000aa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
//  video_clear_screen();
}
  1000b1:	83 c4 1c             	add    $0x1c,%esp
  1000b4:	5b                   	pop    %ebx
  1000b5:	5e                   	pop    %esi
  1000b6:	5f                   	pop    %edi
  1000b7:	5d                   	pop    %ebp
  1000b8:	c3                   	ret    
		*cp = was;
  1000b9:	66 89 15 00 80 0b 00 	mov    %dx,0xb8000
		addr_6845 = CGA_BASE;
  1000c0:	c7 c0 6c 94 16 00    	mov    $0x16946c,%eax
  1000c6:	c7 00 d4 03 00 00    	movl   $0x3d4,(%eax)
		dprintf("addr_6845:%x\n",addr_6845);
  1000cc:	83 ec 08             	sub    $0x8,%esp
  1000cf:	68 d4 03 00 00       	push   $0x3d4
  1000d4:	8d 83 a0 aa ff ff    	lea    -0x5560(%ebx),%eax
  1000da:	50                   	push   %eax
  1000db:	e8 4f 1f 00 00       	call   10202f <dprintf>
  1000e0:	83 c4 10             	add    $0x10,%esp
	cp = (uint16_t*) CGA_BUF;
  1000e3:	bd 00 80 0b 00       	mov    $0xb8000,%ebp
  1000e8:	e9 6e ff ff ff       	jmp    10005b <video_init+0x5b>

001000ed <video_putc>:

void
video_putc(int c)
{
  1000ed:	57                   	push   %edi
  1000ee:	56                   	push   %esi
  1000ef:	53                   	push   %ebx
  1000f0:	e8 1a 02 00 00       	call   10030f <__x86.get_pc_thunk.bx>
  1000f5:	81 c3 0b af 00 00    	add    $0xaf0b,%ebx
  1000fb:	8b 44 24 10          	mov    0x10(%esp),%eax

	// if no attribute given, then use black on white
	if (!(c & ~0xFF))
  1000ff:	a9 00 ff ff ff       	test   $0xffffff00,%eax
  100104:	75 03                	jne    100109 <video_putc+0x1c>
		c |= 0x0700;
  100106:	80 cc 07             	or     $0x7,%ah

	switch (c & 0xff) {
  100109:	0f b6 d0             	movzbl %al,%edx
  10010c:	83 fa 09             	cmp    $0x9,%edx
  10010f:	0f 84 ee 00 00 00    	je     100203 <video_putc+0x116>
  100115:	83 fa 09             	cmp    $0x9,%edx
  100118:	0f 8e 96 00 00 00    	jle    1001b4 <video_putc+0xc7>
  10011e:	83 fa 0a             	cmp    $0xa,%edx
  100121:	0f 84 c6 00 00 00    	je     1001ed <video_putc+0x100>
  100127:	83 fa 0d             	cmp    $0xd,%edx
  10012a:	0f 85 15 01 00 00    	jne    100245 <video_putc+0x158>
		break;
	case '\n':
		terminal.crt_pos += CRT_COLS;
		/* fallthru */
	case '\r':
		terminal.crt_pos -= (terminal.crt_pos % CRT_COLS);
  100130:	c7 c2 60 94 16 00    	mov    $0x169460,%edx
  100136:	0f b7 42 04          	movzwl 0x4(%edx),%eax
  10013a:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  100140:	c1 e8 10             	shr    $0x10,%eax
  100143:	66 c1 e8 06          	shr    $0x6,%ax
  100147:	8d 04 80             	lea    (%eax,%eax,4),%eax
  10014a:	c1 e0 04             	shl    $0x4,%eax
  10014d:	66 89 42 04          	mov    %ax,0x4(%edx)
	default:
		terminal.crt_buf[terminal.crt_pos++] = c;		/* write the character */
		break;
	}

	if (terminal.crt_pos >= CRT_SIZE) {
  100151:	c7 c0 60 94 16 00    	mov    $0x169460,%eax
  100157:	66 81 78 04 cf 07    	cmpw   $0x7cf,0x4(%eax)
  10015d:	0f 87 01 01 00 00    	ja     100264 <video_putc+0x177>
		terminal.crt_pos -= CRT_COLS;
	}


	/* move that little blinky thing */
	outb(addr_6845, 14);
  100163:	83 ec 08             	sub    $0x8,%esp
  100166:	6a 0e                	push   $0xe
  100168:	c7 c6 6c 94 16 00    	mov    $0x16946c,%esi
  10016e:	ff 36                	pushl  (%esi)
  100170:	e8 24 27 00 00       	call   102899 <outb>
	outb(addr_6845 + 1, terminal.crt_pos >> 8);
  100175:	c7 c7 60 94 16 00    	mov    $0x169460,%edi
  10017b:	8b 06                	mov    (%esi),%eax
  10017d:	83 c0 01             	add    $0x1,%eax
  100180:	83 c4 08             	add    $0x8,%esp
  100183:	0f b6 57 05          	movzbl 0x5(%edi),%edx
  100187:	52                   	push   %edx
  100188:	50                   	push   %eax
  100189:	e8 0b 27 00 00       	call   102899 <outb>
	outb(addr_6845, 15);
  10018e:	83 c4 08             	add    $0x8,%esp
  100191:	6a 0f                	push   $0xf
  100193:	ff 36                	pushl  (%esi)
  100195:	e8 ff 26 00 00       	call   102899 <outb>
	outb(addr_6845 + 1, terminal.crt_pos);
  10019a:	8b 06                	mov    (%esi),%eax
  10019c:	83 c0 01             	add    $0x1,%eax
  10019f:	83 c4 08             	add    $0x8,%esp
  1001a2:	0f b6 57 04          	movzbl 0x4(%edi),%edx
  1001a6:	52                   	push   %edx
  1001a7:	50                   	push   %eax
  1001a8:	e8 ec 26 00 00       	call   102899 <outb>
       	  }
       outb(COM1+COM_TX, c);
       tmpcount++;
	  }
	*/
}
  1001ad:	83 c4 10             	add    $0x10,%esp
  1001b0:	5b                   	pop    %ebx
  1001b1:	5e                   	pop    %esi
  1001b2:	5f                   	pop    %edi
  1001b3:	c3                   	ret    
	switch (c & 0xff) {
  1001b4:	83 fa 08             	cmp    $0x8,%edx
  1001b7:	0f 85 88 00 00 00    	jne    100245 <video_putc+0x158>
		if (terminal.crt_pos > 0) {
  1001bd:	c7 c2 60 94 16 00    	mov    $0x169460,%edx
  1001c3:	0f b7 52 04          	movzwl 0x4(%edx),%edx
  1001c7:	66 85 d2             	test   %dx,%dx
  1001ca:	74 85                	je     100151 <video_putc+0x64>
			terminal.crt_pos--;
  1001cc:	83 ea 01             	sub    $0x1,%edx
  1001cf:	c7 c1 60 94 16 00    	mov    $0x169460,%ecx
  1001d5:	66 89 51 04          	mov    %dx,0x4(%ecx)
			terminal.crt_buf[terminal.crt_pos] = (c & ~0xff) | ' ';
  1001d9:	b0 00                	mov    $0x0,%al
  1001db:	0f b7 d2             	movzwl %dx,%edx
  1001de:	01 d2                	add    %edx,%edx
  1001e0:	03 11                	add    (%ecx),%edx
  1001e2:	83 c8 20             	or     $0x20,%eax
  1001e5:	66 89 02             	mov    %ax,(%edx)
  1001e8:	e9 64 ff ff ff       	jmp    100151 <video_putc+0x64>
		terminal.crt_pos += CRT_COLS;
  1001ed:	c7 c2 60 94 16 00    	mov    $0x169460,%edx
  1001f3:	0f b7 42 04          	movzwl 0x4(%edx),%eax
  1001f7:	83 c0 50             	add    $0x50,%eax
  1001fa:	66 89 42 04          	mov    %ax,0x4(%edx)
  1001fe:	e9 2d ff ff ff       	jmp    100130 <video_putc+0x43>
		video_putc(' ');
  100203:	83 ec 0c             	sub    $0xc,%esp
  100206:	6a 20                	push   $0x20
  100208:	e8 e0 fe ff ff       	call   1000ed <video_putc>
		video_putc(' ');
  10020d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  100214:	e8 d4 fe ff ff       	call   1000ed <video_putc>
		video_putc(' ');
  100219:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  100220:	e8 c8 fe ff ff       	call   1000ed <video_putc>
		video_putc(' ');
  100225:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10022c:	e8 bc fe ff ff       	call   1000ed <video_putc>
		video_putc(' ');
  100231:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  100238:	e8 b0 fe ff ff       	call   1000ed <video_putc>
		break;
  10023d:	83 c4 10             	add    $0x10,%esp
  100240:	e9 0c ff ff ff       	jmp    100151 <video_putc+0x64>
		terminal.crt_buf[terminal.crt_pos++] = c;		/* write the character */
  100245:	c7 c1 60 94 16 00    	mov    $0x169460,%ecx
  10024b:	8b 31                	mov    (%ecx),%esi
  10024d:	0f b7 51 04          	movzwl 0x4(%ecx),%edx
  100251:	8d 7a 01             	lea    0x1(%edx),%edi
  100254:	66 89 79 04          	mov    %di,0x4(%ecx)
  100258:	0f b7 d2             	movzwl %dx,%edx
  10025b:	66 89 04 56          	mov    %ax,(%esi,%edx,2)
		break;
  10025f:	e9 ed fe ff ff       	jmp    100151 <video_putc+0x64>
		memmove(terminal.crt_buf, terminal.crt_buf + CRT_COLS,
  100264:	8b 00                	mov    (%eax),%eax
  100266:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10026c:	83 ec 04             	sub    $0x4,%esp
  10026f:	68 00 0f 00 00       	push   $0xf00
  100274:	52                   	push   %edx
  100275:	50                   	push   %eax
  100276:	e8 54 1a 00 00       	call   101ccf <memmove>
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
  10027b:	83 c4 10             	add    $0x10,%esp
  10027e:	b8 80 07 00 00       	mov    $0x780,%eax
  100283:	eb 13                	jmp    100298 <video_putc+0x1ab>
			terminal.crt_buf[i] = 0x0700 | ' ';
  100285:	8d 14 00             	lea    (%eax,%eax,1),%edx
  100288:	c7 c1 60 94 16 00    	mov    $0x169460,%ecx
  10028e:	03 11                	add    (%ecx),%edx
  100290:	66 c7 02 20 07       	movw   $0x720,(%edx)
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
  100295:	83 c0 01             	add    $0x1,%eax
  100298:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  10029d:	7e e6                	jle    100285 <video_putc+0x198>
		terminal.crt_pos -= CRT_COLS;
  10029f:	c7 c2 60 94 16 00    	mov    $0x169460,%edx
  1002a5:	0f b7 42 04          	movzwl 0x4(%edx),%eax
  1002a9:	83 e8 50             	sub    $0x50,%eax
  1002ac:	66 89 42 04          	mov    %ax,0x4(%edx)
  1002b0:	e9 ae fe ff ff       	jmp    100163 <video_putc+0x76>

001002b5 <video_set_cursor>:

void
video_set_cursor (int x, int y)
{
  1002b5:	e8 51 00 00 00       	call   10030b <__x86.get_pc_thunk.cx>
  1002ba:	81 c1 46 ad 00 00    	add    $0xad46,%ecx
  1002c0:	8b 44 24 04          	mov    0x4(%esp),%eax
    terminal.crt_pos = x * CRT_COLS + y;
  1002c4:	8d 04 80             	lea    (%eax,%eax,4),%eax
  1002c7:	c1 e0 04             	shl    $0x4,%eax
  1002ca:	89 c2                	mov    %eax,%edx
  1002cc:	66 03 54 24 08       	add    0x8(%esp),%dx
  1002d1:	c7 c0 60 94 16 00    	mov    $0x169460,%eax
  1002d7:	66 89 50 04          	mov    %dx,0x4(%eax)
}
  1002db:	c3                   	ret    

001002dc <video_clear_screen>:

void
video_clear_screen ()
{
  1002dc:	53                   	push   %ebx
  1002dd:	e8 2d 00 00 00       	call   10030f <__x86.get_pc_thunk.bx>
  1002e2:	81 c3 1e ad 00 00    	add    $0xad1e,%ebx
    int i;
    for (i = 0; i < CRT_SIZE; i++)
  1002e8:	b8 00 00 00 00       	mov    $0x0,%eax
  1002ed:	eb 13                	jmp    100302 <video_clear_screen+0x26>
    {
        terminal.crt_buf[i] = ' ';
  1002ef:	8d 14 00             	lea    (%eax,%eax,1),%edx
  1002f2:	c7 c1 60 94 16 00    	mov    $0x169460,%ecx
  1002f8:	03 11                	add    (%ecx),%edx
  1002fa:	66 c7 02 20 00       	movw   $0x20,(%edx)
    for (i = 0; i < CRT_SIZE; i++)
  1002ff:	83 c0 01             	add    $0x1,%eax
  100302:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  100307:	7e e6                	jle    1002ef <video_clear_screen+0x13>
    }
}
  100309:	5b                   	pop    %ebx
  10030a:	c3                   	ret    

0010030b <__x86.get_pc_thunk.cx>:
  10030b:	8b 0c 24             	mov    (%esp),%ecx
  10030e:	c3                   	ret    

0010030f <__x86.get_pc_thunk.bx>:
  10030f:	8b 1c 24             	mov    (%esp),%ebx
  100312:	c3                   	ret    

00100313 <cons_init>:
	uint32_t rpos, wpos;
} cons;

void
cons_init()
{
  100313:	53                   	push   %ebx
  100314:	83 ec 0c             	sub    $0xc,%esp
  100317:	e8 f3 ff ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  10031c:	81 c3 e4 ac 00 00    	add    $0xace4,%ebx
	memset(&cons, 0x0, sizeof(cons));
  100322:	68 08 02 00 00       	push   $0x208
  100327:	6a 00                	push   $0x0
  100329:	ff b3 f8 ff ff ff    	pushl  -0x8(%ebx)
  10032f:	e8 52 19 00 00       	call   101c86 <memset>
	serial_init();
  100334:	e8 57 03 00 00       	call   100690 <serial_init>
	video_init();
  100339:	e8 c2 fc ff ff       	call   100000 <video_init>
}
  10033e:	83 c4 18             	add    $0x18,%esp
  100341:	5b                   	pop    %ebx
  100342:	c3                   	ret    

00100343 <cons_intr>:

void
cons_intr(int (*proc)(void))
{
  100343:	57                   	push   %edi
  100344:	56                   	push   %esi
  100345:	53                   	push   %ebx
  100346:	e8 d0 01 00 00       	call   10051b <__x86.get_pc_thunk.si>
  10034b:	81 c6 b5 ac 00 00    	add    $0xacb5,%esi
  100351:	8b 5c 24 10          	mov    0x10(%esp),%ebx
	int c;

	while ((c = (*proc)()) != -1) {
  100355:	ff d3                	call   *%ebx
  100357:	83 f8 ff             	cmp    $0xffffffff,%eax
  10035a:	74 30                	je     10038c <cons_intr+0x49>
		if (c == 0)
  10035c:	85 c0                	test   %eax,%eax
  10035e:	74 f5                	je     100355 <cons_intr+0x12>
			continue;
		cons.buf[cons.wpos++] = c;
  100360:	c7 c2 80 94 16 00    	mov    $0x169480,%edx
  100366:	8b ba 04 02 00 00    	mov    0x204(%edx),%edi
  10036c:	8d 4f 01             	lea    0x1(%edi),%ecx
  10036f:	89 8a 04 02 00 00    	mov    %ecx,0x204(%edx)
  100375:	88 04 3a             	mov    %al,(%edx,%edi,1)
		if (cons.wpos == CONSOLE_BUFFER_SIZE)
  100378:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
  10037e:	75 d5                	jne    100355 <cons_intr+0x12>
			cons.wpos = 0;
  100380:	c7 82 04 02 00 00 00 	movl   $0x0,0x204(%edx)
  100387:	00 00 00 
  10038a:	eb c9                	jmp    100355 <cons_intr+0x12>
	}
}
  10038c:	5b                   	pop    %ebx
  10038d:	5e                   	pop    %esi
  10038e:	5f                   	pop    %edi
  10038f:	c3                   	ret    

00100390 <cons_getc>:

char
cons_getc(void)
{
  100390:	53                   	push   %ebx
  100391:	83 ec 08             	sub    $0x8,%esp
  100394:	e8 76 ff ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  100399:	81 c3 67 ac 00 00    	add    $0xac67,%ebx
  int c;

  // poll for any pending input characters,
  // so that this function works even when interrupts are disabled
  // (e.g., when called from the kernel monitor).
  serial_intr();
  10039f:	e8 42 02 00 00       	call   1005e6 <serial_intr>
  keyboard_intr();
  1003a4:	e8 f7 04 00 00       	call   1008a0 <keyboard_intr>

  // grab the next character from the input buffer.
  if (cons.rpos != cons.wpos) {
  1003a9:	c7 c2 80 94 16 00    	mov    $0x169480,%edx
  1003af:	8b 82 00 02 00 00    	mov    0x200(%edx),%eax
  1003b5:	3b 82 04 02 00 00    	cmp    0x204(%edx),%eax
  1003bb:	74 2c                	je     1003e9 <cons_getc+0x59>
    c = cons.buf[cons.rpos++];
  1003bd:	8d 50 01             	lea    0x1(%eax),%edx
  1003c0:	c7 c1 80 94 16 00    	mov    $0x169480,%ecx
  1003c6:	89 91 00 02 00 00    	mov    %edx,0x200(%ecx)
  1003cc:	0f b6 04 01          	movzbl (%ecx,%eax,1),%eax
    if (cons.rpos == CONSOLE_BUFFER_SIZE)
  1003d0:	81 fa 00 02 00 00    	cmp    $0x200,%edx
  1003d6:	74 05                	je     1003dd <cons_getc+0x4d>
      cons.rpos = 0;
    return c;
  }
  return 0;
}
  1003d8:	83 c4 08             	add    $0x8,%esp
  1003db:	5b                   	pop    %ebx
  1003dc:	c3                   	ret    
      cons.rpos = 0;
  1003dd:	c7 81 00 02 00 00 00 	movl   $0x0,0x200(%ecx)
  1003e4:	00 00 00 
  1003e7:	eb ef                	jmp    1003d8 <cons_getc+0x48>
  return 0;
  1003e9:	b8 00 00 00 00       	mov    $0x0,%eax
  1003ee:	eb e8                	jmp    1003d8 <cons_getc+0x48>

001003f0 <cons_putc>:

void
cons_putc(char c)
{
  1003f0:	56                   	push   %esi
  1003f1:	53                   	push   %ebx
  1003f2:	83 ec 10             	sub    $0x10,%esp
  1003f5:	e8 15 ff ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  1003fa:	81 c3 06 ac 00 00    	add    $0xac06,%ebx
	serial_putc(c);
  100400:	0f be 74 24 1c       	movsbl 0x1c(%esp),%esi
  100405:	56                   	push   %esi
  100406:	e8 0e 02 00 00       	call   100619 <serial_putc>
  video_putc(c);
  10040b:	89 34 24             	mov    %esi,(%esp)
  10040e:	e8 da fc ff ff       	call   1000ed <video_putc>
}
  100413:	83 c4 14             	add    $0x14,%esp
  100416:	5b                   	pop    %ebx
  100417:	5e                   	pop    %esi
  100418:	c3                   	ret    

00100419 <getchar>:

char
getchar(void)
{
  100419:	83 ec 0c             	sub    $0xc,%esp
  char c;

  while ((c = cons_getc()) == 0)
  10041c:	e8 6f ff ff ff       	call   100390 <cons_getc>
  100421:	84 c0                	test   %al,%al
  100423:	74 f7                	je     10041c <getchar+0x3>
    /* do nothing */;
  return c;
}
  100425:	83 c4 0c             	add    $0xc,%esp
  100428:	c3                   	ret    

00100429 <putchar>:

void
putchar(char c)
{
  100429:	83 ec 18             	sub    $0x18,%esp
  cons_putc(c);
  10042c:	0f be 44 24 1c       	movsbl 0x1c(%esp),%eax
  100431:	50                   	push   %eax
  100432:	e8 b9 ff ff ff       	call   1003f0 <cons_putc>
}
  100437:	83 c4 1c             	add    $0x1c,%esp
  10043a:	c3                   	ret    

0010043b <readline>:

char *
readline(const char *prompt)
{
  10043b:	57                   	push   %edi
  10043c:	56                   	push   %esi
  10043d:	53                   	push   %ebx
  10043e:	e8 dc 00 00 00       	call   10051f <__x86.get_pc_thunk.di>
  100443:	81 c7 bd ab 00 00    	add    $0xabbd,%edi
  100449:	8b 44 24 10          	mov    0x10(%esp),%eax
  int i;
  char c;

  if (prompt != NULL)
  10044d:	85 c0                	test   %eax,%eax
  10044f:	74 15                	je     100466 <readline+0x2b>
    dprintf("%s", prompt);
  100451:	83 ec 08             	sub    $0x8,%esp
  100454:	50                   	push   %eax
  100455:	8d 87 ae aa ff ff    	lea    -0x5552(%edi),%eax
  10045b:	50                   	push   %eax
  10045c:	89 fb                	mov    %edi,%ebx
  10045e:	e8 cc 1b 00 00       	call   10202f <dprintf>
  100463:	83 c4 10             	add    $0x10,%esp
    } else if ((c == '\b' || c == '\x7f') && i > 0) {
      putchar('\b');
      i--;
    } else if (c >= ' ' && i < BUFLEN-1) {
      putchar(c);
      linebuf[i++] = c;
  100466:	be 00 00 00 00       	mov    $0x0,%esi
  10046b:	eb 44                	jmp    1004b1 <readline+0x76>
      dprintf("read error: %e\n", c);
  10046d:	83 ec 08             	sub    $0x8,%esp
  100470:	0f be c0             	movsbl %al,%eax
  100473:	50                   	push   %eax
  100474:	8d 87 b1 aa ff ff    	lea    -0x554f(%edi),%eax
  10047a:	50                   	push   %eax
  10047b:	89 fb                	mov    %edi,%ebx
  10047d:	e8 ad 1b 00 00       	call   10202f <dprintf>
      return NULL;
  100482:	83 c4 10             	add    $0x10,%esp
  100485:	b8 00 00 00 00       	mov    $0x0,%eax
      putchar('\n');
      linebuf[i] = 0;
      return linebuf;
    }
  }
}
  10048a:	5b                   	pop    %ebx
  10048b:	5e                   	pop    %esi
  10048c:	5f                   	pop    %edi
  10048d:	c3                   	ret    
    } else if (c >= ' ' && i < BUFLEN-1) {
  10048e:	80 fb 1f             	cmp    $0x1f,%bl
  100491:	0f 9f c2             	setg   %dl
  100494:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  10049a:	0f 9e c0             	setle  %al
  10049d:	84 c2                	test   %al,%dl
  10049f:	75 3f                	jne    1004e0 <readline+0xa5>
    } else if (c == '\n' || c == '\r') {
  1004a1:	80 fb 0a             	cmp    $0xa,%bl
  1004a4:	0f 94 c2             	sete   %dl
  1004a7:	80 fb 0d             	cmp    $0xd,%bl
  1004aa:	0f 94 c0             	sete   %al
  1004ad:	08 c2                	or     %al,%dl
  1004af:	75 4a                	jne    1004fb <readline+0xc0>
    c = getchar();
  1004b1:	e8 63 ff ff ff       	call   100419 <getchar>
  1004b6:	89 c3                	mov    %eax,%ebx
    if (c < 0) {
  1004b8:	84 c0                	test   %al,%al
  1004ba:	78 b1                	js     10046d <readline+0x32>
    } else if ((c == '\b' || c == '\x7f') && i > 0) {
  1004bc:	3c 08                	cmp    $0x8,%al
  1004be:	0f 94 c2             	sete   %dl
  1004c1:	3c 7f                	cmp    $0x7f,%al
  1004c3:	0f 94 c0             	sete   %al
  1004c6:	08 c2                	or     %al,%dl
  1004c8:	74 c4                	je     10048e <readline+0x53>
  1004ca:	85 f6                	test   %esi,%esi
  1004cc:	7e c0                	jle    10048e <readline+0x53>
      putchar('\b');
  1004ce:	83 ec 0c             	sub    $0xc,%esp
  1004d1:	6a 08                	push   $0x8
  1004d3:	e8 51 ff ff ff       	call   100429 <putchar>
      i--;
  1004d8:	83 ee 01             	sub    $0x1,%esi
  1004db:	83 c4 10             	add    $0x10,%esp
  1004de:	eb d1                	jmp    1004b1 <readline+0x76>
      putchar(c);
  1004e0:	83 ec 0c             	sub    $0xc,%esp
  1004e3:	0f be c3             	movsbl %bl,%eax
  1004e6:	50                   	push   %eax
  1004e7:	e8 3d ff ff ff       	call   100429 <putchar>
      linebuf[i++] = c;
  1004ec:	88 9c 37 00 d0 01 00 	mov    %bl,0x1d000(%edi,%esi,1)
  1004f3:	83 c4 10             	add    $0x10,%esp
  1004f6:	8d 76 01             	lea    0x1(%esi),%esi
  1004f9:	eb b6                	jmp    1004b1 <readline+0x76>
      putchar('\n');
  1004fb:	83 ec 0c             	sub    $0xc,%esp
  1004fe:	6a 0a                	push   $0xa
  100500:	e8 24 ff ff ff       	call   100429 <putchar>
      linebuf[i] = 0;
  100505:	c6 84 37 00 d0 01 00 	movb   $0x0,0x1d000(%edi,%esi,1)
  10050c:	00 
      return linebuf;
  10050d:	83 c4 10             	add    $0x10,%esp
  100510:	8d 87 00 d0 01 00    	lea    0x1d000(%edi),%eax
  100516:	e9 6f ff ff ff       	jmp    10048a <readline+0x4f>

0010051b <__x86.get_pc_thunk.si>:
  10051b:	8b 34 24             	mov    (%esp),%esi
  10051e:	c3                   	ret    

0010051f <__x86.get_pc_thunk.di>:
  10051f:	8b 3c 24             	mov    (%esp),%edi
  100522:	c3                   	ret    

00100523 <serial_proc_data>:
	inb(0x84);
}

static int
serial_proc_data(void)
{
  100523:	53                   	push   %ebx
  100524:	83 ec 14             	sub    $0x14,%esp
  100527:	e8 e3 fd ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  10052c:	81 c3 d4 aa 00 00    	add    $0xaad4,%ebx
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
  100532:	68 fd 03 00 00       	push   $0x3fd
  100537:	e8 45 23 00 00       	call   102881 <inb>
  10053c:	83 c4 10             	add    $0x10,%esp
  10053f:	a8 01                	test   $0x1,%al
  100541:	74 18                	je     10055b <serial_proc_data+0x38>
		return -1;
	return inb(COM1+COM_RX);
  100543:	83 ec 0c             	sub    $0xc,%esp
  100546:	68 f8 03 00 00       	push   $0x3f8
  10054b:	e8 31 23 00 00       	call   102881 <inb>
  100550:	0f b6 c0             	movzbl %al,%eax
  100553:	83 c4 10             	add    $0x10,%esp
}
  100556:	83 c4 08             	add    $0x8,%esp
  100559:	5b                   	pop    %ebx
  10055a:	c3                   	ret    
		return -1;
  10055b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100560:	eb f4                	jmp    100556 <serial_proc_data+0x33>

00100562 <delay>:
{
  100562:	53                   	push   %ebx
  100563:	83 ec 14             	sub    $0x14,%esp
  100566:	e8 a4 fd ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  10056b:	81 c3 95 aa 00 00    	add    $0xaa95,%ebx
	inb(0x84);
  100571:	68 84 00 00 00       	push   $0x84
  100576:	e8 06 23 00 00       	call   102881 <inb>
	inb(0x84);
  10057b:	c7 04 24 84 00 00 00 	movl   $0x84,(%esp)
  100582:	e8 fa 22 00 00       	call   102881 <inb>
	inb(0x84);
  100587:	c7 04 24 84 00 00 00 	movl   $0x84,(%esp)
  10058e:	e8 ee 22 00 00       	call   102881 <inb>
	inb(0x84);
  100593:	c7 04 24 84 00 00 00 	movl   $0x84,(%esp)
  10059a:	e8 e2 22 00 00       	call   102881 <inb>
}
  10059f:	83 c4 18             	add    $0x18,%esp
  1005a2:	5b                   	pop    %ebx
  1005a3:	c3                   	ret    

001005a4 <serial_reformatnewline>:
		cons_intr(serial_proc_data);
}

static int
serial_reformatnewline(int c, int p)
{
  1005a4:	56                   	push   %esi
  1005a5:	53                   	push   %ebx
  1005a6:	83 ec 04             	sub    $0x4,%esp
  1005a9:	e8 61 fd ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  1005ae:	81 c3 52 aa 00 00    	add    $0xaa52,%ebx
	int nl = '\n';
	/* POSIX requires newline on the serial line to
	 * be a CR-LF pair. Without this, you get a malformed output
	 * with clients like minicom or screen
	 */
	if (c == nl) {
  1005b4:	83 f8 0a             	cmp    $0xa,%eax
  1005b7:	74 0b                	je     1005c4 <serial_reformatnewline+0x20>
		outb(p, cr);
		outb(p, nl);
		return 1;
	}
	else
		return 0;
  1005b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1005be:	83 c4 04             	add    $0x4,%esp
  1005c1:	5b                   	pop    %ebx
  1005c2:	5e                   	pop    %esi
  1005c3:	c3                   	ret    
  1005c4:	89 d6                	mov    %edx,%esi
		outb(p, cr);
  1005c6:	83 ec 08             	sub    $0x8,%esp
  1005c9:	6a 0d                	push   $0xd
  1005cb:	52                   	push   %edx
  1005cc:	e8 c8 22 00 00       	call   102899 <outb>
		outb(p, nl);
  1005d1:	83 c4 08             	add    $0x8,%esp
  1005d4:	6a 0a                	push   $0xa
  1005d6:	56                   	push   %esi
  1005d7:	e8 bd 22 00 00       	call   102899 <outb>
		return 1;
  1005dc:	83 c4 10             	add    $0x10,%esp
  1005df:	b8 01 00 00 00       	mov    $0x1,%eax
  1005e4:	eb d8                	jmp    1005be <serial_reformatnewline+0x1a>

001005e6 <serial_intr>:
{
  1005e6:	53                   	push   %ebx
  1005e7:	83 ec 08             	sub    $0x8,%esp
  1005ea:	e8 20 fd ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  1005ef:	81 c3 11 aa 00 00    	add    $0xaa11,%ebx
	if (serial_exists)
  1005f5:	c7 c0 88 96 16 00    	mov    $0x169688,%eax
  1005fb:	80 38 00             	cmpb   $0x0,(%eax)
  1005fe:	75 05                	jne    100605 <serial_intr+0x1f>
}
  100600:	83 c4 08             	add    $0x8,%esp
  100603:	5b                   	pop    %ebx
  100604:	c3                   	ret    
		cons_intr(serial_proc_data);
  100605:	83 ec 0c             	sub    $0xc,%esp
  100608:	8d 83 23 55 ff ff    	lea    -0xaadd(%ebx),%eax
  10060e:	50                   	push   %eax
  10060f:	e8 2f fd ff ff       	call   100343 <cons_intr>
  100614:	83 c4 10             	add    $0x10,%esp
}
  100617:	eb e7                	jmp    100600 <serial_intr+0x1a>

00100619 <serial_putc>:

void
serial_putc(char c)
{
  100619:	57                   	push   %edi
  10061a:	56                   	push   %esi
  10061b:	53                   	push   %ebx
  10061c:	e8 ee fc ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  100621:	81 c3 df a9 00 00    	add    $0xa9df,%ebx
  100627:	8b 7c 24 10          	mov    0x10(%esp),%edi
	if (!serial_exists)
  10062b:	c7 c0 88 96 16 00    	mov    $0x169688,%eax
  100631:	80 38 00             	cmpb   $0x0,(%eax)
  100634:	74 3e                	je     100674 <serial_putc+0x5b>
		return;

	int i;
	for (i = 0;
  100636:	be 00 00 00 00       	mov    $0x0,%esi
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
  10063b:	83 ec 0c             	sub    $0xc,%esp
  10063e:	68 fd 03 00 00       	push   $0x3fd
  100643:	e8 39 22 00 00       	call   102881 <inb>
	for (i = 0;
  100648:	83 c4 10             	add    $0x10,%esp
  10064b:	a8 20                	test   $0x20,%al
  10064d:	75 12                	jne    100661 <serial_putc+0x48>
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
  10064f:	81 fe ff 31 00 00    	cmp    $0x31ff,%esi
  100655:	7f 0a                	jg     100661 <serial_putc+0x48>
	     i++)
		delay();
  100657:	e8 06 ff ff ff       	call   100562 <delay>
	     i++)
  10065c:	83 c6 01             	add    $0x1,%esi
  10065f:	eb da                	jmp    10063b <serial_putc+0x22>

	if (!serial_reformatnewline(c, COM1 + COM_TX))
  100661:	89 f8                	mov    %edi,%eax
  100663:	0f be c0             	movsbl %al,%eax
  100666:	ba f8 03 00 00       	mov    $0x3f8,%edx
  10066b:	e8 34 ff ff ff       	call   1005a4 <serial_reformatnewline>
  100670:	85 c0                	test   %eax,%eax
  100672:	74 04                	je     100678 <serial_putc+0x5f>
		outb(COM1 + COM_TX, c);
}
  100674:	5b                   	pop    %ebx
  100675:	5e                   	pop    %esi
  100676:	5f                   	pop    %edi
  100677:	c3                   	ret    
		outb(COM1 + COM_TX, c);
  100678:	83 ec 08             	sub    $0x8,%esp
  10067b:	89 f8                	mov    %edi,%eax
  10067d:	0f b6 f8             	movzbl %al,%edi
  100680:	57                   	push   %edi
  100681:	68 f8 03 00 00       	push   $0x3f8
  100686:	e8 0e 22 00 00       	call   102899 <outb>
  10068b:	83 c4 10             	add    $0x10,%esp
  10068e:	eb e4                	jmp    100674 <serial_putc+0x5b>

00100690 <serial_init>:

void
serial_init(void)
{
  100690:	53                   	push   %ebx
  100691:	83 ec 10             	sub    $0x10,%esp
  100694:	e8 76 fc ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  100699:	81 c3 67 a9 00 00    	add    $0xa967,%ebx
	/* turn off interrupt */
	outb(COM1 + COM_IER, 0);
  10069f:	6a 00                	push   $0x0
  1006a1:	68 f9 03 00 00       	push   $0x3f9
  1006a6:	e8 ee 21 00 00       	call   102899 <outb>

	/* set DLAB */
	outb(COM1 + COM_LCR, COM_LCR_DLAB);
  1006ab:	83 c4 08             	add    $0x8,%esp
  1006ae:	68 80 00 00 00       	push   $0x80
  1006b3:	68 fb 03 00 00       	push   $0x3fb
  1006b8:	e8 dc 21 00 00       	call   102899 <outb>

	/* set baud rate */
	outb(COM1 + COM_DLL, 0x0001 & 0xff);
  1006bd:	83 c4 08             	add    $0x8,%esp
  1006c0:	6a 01                	push   $0x1
  1006c2:	68 f8 03 00 00       	push   $0x3f8
  1006c7:	e8 cd 21 00 00       	call   102899 <outb>
	outb(COM1 + COM_DLM, 0x0001 >> 8);
  1006cc:	83 c4 08             	add    $0x8,%esp
  1006cf:	6a 00                	push   $0x0
  1006d1:	68 f9 03 00 00       	push   $0x3f9
  1006d6:	e8 be 21 00 00       	call   102899 <outb>

	/* Set the line status.  */
	outb(COM1 + COM_LCR, COM_LCR_WLEN8 & ~COM_LCR_DLAB);
  1006db:	83 c4 08             	add    $0x8,%esp
  1006de:	6a 03                	push   $0x3
  1006e0:	68 fb 03 00 00       	push   $0x3fb
  1006e5:	e8 af 21 00 00       	call   102899 <outb>

	/* Enable the FIFO.  */
	outb(COM1 + COM_FCR, 0xc7);
  1006ea:	83 c4 08             	add    $0x8,%esp
  1006ed:	68 c7 00 00 00       	push   $0xc7
  1006f2:	68 fa 03 00 00       	push   $0x3fa
  1006f7:	e8 9d 21 00 00       	call   102899 <outb>

	/* Turn on DTR, RTS, and OUT2.  */
	outb(COM1 + COM_MCR, 0x0b);
  1006fc:	83 c4 08             	add    $0x8,%esp
  1006ff:	6a 0b                	push   $0xb
  100701:	68 fc 03 00 00       	push   $0x3fc
  100706:	e8 8e 21 00 00       	call   102899 <outb>

	// Clear any preexisting overrun indications and interrupts
	// Serial COM1 doesn't exist if COM_LSR returns 0xFF
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
  10070b:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
  100712:	e8 6a 21 00 00       	call   102881 <inb>
  100717:	3c ff                	cmp    $0xff,%al
  100719:	c7 c0 88 96 16 00    	mov    $0x169688,%eax
  10071f:	0f 95 00             	setne  (%eax)
	(void) inb(COM1+COM_IIR);
  100722:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
  100729:	e8 53 21 00 00       	call   102881 <inb>
	(void) inb(COM1+COM_RX);
  10072e:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
  100735:	e8 47 21 00 00       	call   102881 <inb>
}
  10073a:	83 c4 18             	add    $0x18,%esp
  10073d:	5b                   	pop    %ebx
  10073e:	c3                   	ret    

0010073f <serial_intenable>:

void
serial_intenable(void)
{
  10073f:	53                   	push   %ebx
  100740:	83 ec 08             	sub    $0x8,%esp
  100743:	e8 c7 fb ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  100748:	81 c3 b8 a8 00 00    	add    $0xa8b8,%ebx
	if (serial_exists) {
  10074e:	c7 c0 88 96 16 00    	mov    $0x169688,%eax
  100754:	80 38 00             	cmpb   $0x0,(%eax)
  100757:	75 05                	jne    10075e <serial_intenable+0x1f>
		outb(COM1+COM_IER, 1);
		//intr_enable(IRQ_SERIAL13);
		serial_intr();
	}
}
  100759:	83 c4 08             	add    $0x8,%esp
  10075c:	5b                   	pop    %ebx
  10075d:	c3                   	ret    
		outb(COM1+COM_IER, 1);
  10075e:	83 ec 08             	sub    $0x8,%esp
  100761:	6a 01                	push   $0x1
  100763:	68 f9 03 00 00       	push   $0x3f9
  100768:	e8 2c 21 00 00       	call   102899 <outb>
		serial_intr();
  10076d:	e8 74 fe ff ff       	call   1005e6 <serial_intr>
  100772:	83 c4 10             	add    $0x10,%esp
}
  100775:	eb e2                	jmp    100759 <serial_intenable+0x1a>

00100777 <kbd_proc_data>:
 * Get data from the keyboard.  If we finish a character, return it.  Else 0.
 * Return -1 if no data.
 */
static int
kbd_proc_data(void)
{
  100777:	56                   	push   %esi
  100778:	53                   	push   %ebx
  100779:	83 ec 10             	sub    $0x10,%esp
  10077c:	e8 8e fb ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  100781:	81 c3 7f a8 00 00    	add    $0xa87f,%ebx
  int c;
  uint8_t data;
  static uint32_t shift;

  if ((inb(KBSTATP) & KBS_DIB) == 0)
  100787:	6a 64                	push   $0x64
  100789:	e8 f3 20 00 00       	call   102881 <inb>
  10078e:	83 c4 10             	add    $0x10,%esp
  100791:	a8 01                	test   $0x1,%al
  100793:	0f 84 00 01 00 00    	je     100899 <kbd_proc_data+0x122>
    return -1;

  data = inb(KBDATAP);
  100799:	83 ec 0c             	sub    $0xc,%esp
  10079c:	6a 60                	push   $0x60
  10079e:	e8 de 20 00 00       	call   102881 <inb>

  if (data == 0xE0) {
  1007a3:	83 c4 10             	add    $0x10,%esp
  1007a6:	3c e0                	cmp    $0xe0,%al
  1007a8:	0f 84 97 00 00 00    	je     100845 <kbd_proc_data+0xce>
    // E0 escape character
    shift |= E0ESC;
    return 0;
  } else if (data & 0x80) {
  1007ae:	84 c0                	test   %al,%al
  1007b0:	0f 88 a3 00 00 00    	js     100859 <kbd_proc_data+0xe2>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if (shift & E0ESC) {
  1007b6:	8b 93 00 d4 01 00    	mov    0x1d400(%ebx),%edx
  1007bc:	f6 c2 40             	test   $0x40,%dl
  1007bf:	74 0c                	je     1007cd <kbd_proc_data+0x56>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
  1007c1:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
  1007c4:	83 e2 bf             	and    $0xffffffbf,%edx
  1007c7:	89 93 00 d4 01 00    	mov    %edx,0x1d400(%ebx)
  }

  shift |= shiftcode[data];
  1007cd:	0f b6 c0             	movzbl %al,%eax
  1007d0:	0f b6 94 03 e0 ab ff 	movzbl -0x5420(%ebx,%eax,1),%edx
  1007d7:	ff 
  1007d8:	0b 93 00 d4 01 00    	or     0x1d400(%ebx),%edx
  shift ^= togglecode[data];
  1007de:	0f b6 8c 03 e0 aa ff 	movzbl -0x5520(%ebx,%eax,1),%ecx
  1007e5:	ff 
  1007e6:	31 ca                	xor    %ecx,%edx
  1007e8:	89 93 00 d4 01 00    	mov    %edx,0x1d400(%ebx)

  c = charcode[shift & (CTL | SHIFT)][data];
  1007ee:	89 d1                	mov    %edx,%ecx
  1007f0:	83 e1 03             	and    $0x3,%ecx
  1007f3:	8b 8c 8b a0 ff ff ff 	mov    -0x60(%ebx,%ecx,4),%ecx
  1007fa:	0f b6 04 01          	movzbl (%ecx,%eax,1),%eax
  1007fe:	0f b6 f0             	movzbl %al,%esi
  if (shift & CAPSLOCK) {
  100801:	f6 c2 08             	test   $0x8,%dl
  100804:	74 0d                	je     100813 <kbd_proc_data+0x9c>
    if ('a' <= c && c <= 'z')
  100806:	89 f0                	mov    %esi,%eax
  100808:	8d 4e 9f             	lea    -0x61(%esi),%ecx
  10080b:	83 f9 19             	cmp    $0x19,%ecx
  10080e:	77 79                	ja     100889 <kbd_proc_data+0x112>
      c += 'A' - 'a';
  100810:	83 ee 20             	sub    $0x20,%esi
      c += 'a' - 'A';
  }

  // Process special keys
  // Ctrl-Alt-Del: reboot
  if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  100813:	f7 d2                	not    %edx
  100815:	f6 c2 06             	test   $0x6,%dl
  100818:	75 37                	jne    100851 <kbd_proc_data+0xda>
  10081a:	81 fe e9 00 00 00    	cmp    $0xe9,%esi
  100820:	75 2f                	jne    100851 <kbd_proc_data+0xda>
    dprintf("Rebooting!\n");
  100822:	83 ec 0c             	sub    $0xc,%esp
  100825:	8d 83 c1 aa ff ff    	lea    -0x553f(%ebx),%eax
  10082b:	50                   	push   %eax
  10082c:	e8 fe 17 00 00       	call   10202f <dprintf>
    outb(0x92, 0x3); // courtesy of Chris Frost
  100831:	83 c4 08             	add    $0x8,%esp
  100834:	6a 03                	push   $0x3
  100836:	68 92 00 00 00       	push   $0x92
  10083b:	e8 59 20 00 00       	call   102899 <outb>
  100840:	83 c4 10             	add    $0x10,%esp
  100843:	eb 0c                	jmp    100851 <kbd_proc_data+0xda>
    shift |= E0ESC;
  100845:	83 8b 00 d4 01 00 40 	orl    $0x40,0x1d400(%ebx)
    return 0;
  10084c:	be 00 00 00 00       	mov    $0x0,%esi
  }

  return c;
}
  100851:	89 f0                	mov    %esi,%eax
  100853:	83 c4 04             	add    $0x4,%esp
  100856:	5b                   	pop    %ebx
  100857:	5e                   	pop    %esi
  100858:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
  100859:	8b 93 00 d4 01 00    	mov    0x1d400(%ebx),%edx
  10085f:	f6 c2 40             	test   $0x40,%dl
  100862:	75 03                	jne    100867 <kbd_proc_data+0xf0>
  100864:	83 e0 7f             	and    $0x7f,%eax
    shift &= ~(shiftcode[data] | E0ESC);
  100867:	0f b6 c0             	movzbl %al,%eax
  10086a:	0f b6 84 03 e0 ab ff 	movzbl -0x5420(%ebx,%eax,1),%eax
  100871:	ff 
  100872:	83 c8 40             	or     $0x40,%eax
  100875:	0f b6 c0             	movzbl %al,%eax
  100878:	f7 d0                	not    %eax
  10087a:	21 d0                	and    %edx,%eax
  10087c:	89 83 00 d4 01 00    	mov    %eax,0x1d400(%ebx)
    return 0;
  100882:	be 00 00 00 00       	mov    $0x0,%esi
  100887:	eb c8                	jmp    100851 <kbd_proc_data+0xda>
    else if ('A' <= c && c <= 'Z')
  100889:	83 e8 41             	sub    $0x41,%eax
  10088c:	83 f8 19             	cmp    $0x19,%eax
  10088f:	77 82                	ja     100813 <kbd_proc_data+0x9c>
      c += 'a' - 'A';
  100891:	83 c6 20             	add    $0x20,%esi
  100894:	e9 7a ff ff ff       	jmp    100813 <kbd_proc_data+0x9c>
    return -1;
  100899:	be ff ff ff ff       	mov    $0xffffffff,%esi
  10089e:	eb b1                	jmp    100851 <kbd_proc_data+0xda>

001008a0 <keyboard_intr>:

void
keyboard_intr(void)
{
  1008a0:	53                   	push   %ebx
  1008a1:	83 ec 14             	sub    $0x14,%esp
  1008a4:	e8 66 fa ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  1008a9:	81 c3 57 a7 00 00    	add    $0xa757,%ebx
  cons_intr(kbd_proc_data);
  1008af:	8d 83 77 57 ff ff    	lea    -0xa889(%ebx),%eax
  1008b5:	50                   	push   %eax
  1008b6:	e8 88 fa ff ff       	call   100343 <cons_intr>
}
  1008bb:	83 c4 18             	add    $0x18,%esp
  1008be:	5b                   	pop    %ebx
  1008bf:	c3                   	ret    

001008c0 <devinit>:

void intr_init(void);

void
devinit (void)
{
  1008c0:	53                   	push   %ebx
  1008c1:	83 ec 08             	sub    $0x8,%esp
  1008c4:	e8 46 fa ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  1008c9:	81 c3 37 a7 00 00    	add    $0xa737,%ebx
	seg_init ();
  1008cf:	e8 6d 1c 00 00       	call   102541 <seg_init>

	cons_init ();
  1008d4:	e8 3a fa ff ff       	call   100313 <cons_init>
	KERN_DEBUG("cons initialized.\n");
  1008d9:	83 ec 04             	sub    $0x4,%esp
  1008dc:	8d 83 e0 ac ff ff    	lea    -0x5320(%ebx),%eax
  1008e2:	50                   	push   %eax
  1008e3:	6a 13                	push   $0x13
  1008e5:	8d 83 f3 ac ff ff    	lea    -0x530d(%ebx),%eax
  1008eb:	50                   	push   %eax
  1008ec:	e8 72 15 00 00       	call   101e63 <debug_normal>

  	tsc_init();
  1008f1:	e8 5f 0d 00 00       	call   101655 <tsc_init>

	intr_init();
  1008f6:	e8 5f 08 00 00       	call   10115a <intr_init>

  	/* enable interrupts */
  	intr_enable (IRQ_TIMER);
  1008fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100902:	e8 83 08 00 00       	call   10118a <intr_enable>
  	intr_enable (IRQ_KBD);
  100907:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10090e:	e8 77 08 00 00       	call   10118a <intr_enable>
  	intr_enable (IRQ_SERIAL13);
  100913:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10091a:	e8 6b 08 00 00       	call   10118a <intr_enable>

}
  10091f:	83 c4 18             	add    $0x18,%esp
  100922:	5b                   	pop    %ebx
  100923:	c3                   	ret    

00100924 <intr_init_idt>:
pseudodesc_t idt_pd =
	{ .pd_lim = sizeof(idt) - 1, .pd_base = (uint32_t) idt };

static void
intr_init_idt(void)
{
  100924:	55                   	push   %ebp
  100925:	57                   	push   %edi
  100926:	56                   	push   %esi
  100927:	53                   	push   %ebx
  100928:	e8 ee fb ff ff       	call   10051b <__x86.get_pc_thunk.si>
  10092d:	81 c6 d3 a6 00 00    	add    $0xa6d3,%esi

	/* check that T_IRQ0 is a multiple of 8 */
	KERN_ASSERT((T_IRQ0 & 7) == 0);

	/* install a default handler */
	for (i = 0; i < sizeof(idt)/sizeof(idt[0]); i++)
  100933:	b8 00 00 00 00       	mov    $0x0,%eax
  100938:	eb 3e                	jmp    100978 <intr_init_idt+0x54>
		SETGATE(idt[i], 0, CPU_GDT_KCODE, &Xdefault, 0);
  10093a:	c7 c1 a0 96 16 00    	mov    $0x1696a0,%ecx
  100940:	c7 c5 6e 19 10 00    	mov    $0x10196e,%ebp
  100946:	66 89 2c c1          	mov    %bp,(%ecx,%eax,8)
  10094a:	66 c7 44 c1 02 08 00 	movw   $0x8,0x2(%ecx,%eax,8)
  100951:	c6 44 c1 04 00       	movb   $0x0,0x4(%ecx,%eax,8)
  100956:	0f b6 54 c1 05       	movzbl 0x5(%ecx,%eax,8),%edx
  10095b:	83 e2 f0             	and    $0xfffffff0,%edx
  10095e:	83 ca 0e             	or     $0xe,%edx
  100961:	83 e2 8f             	and    $0xffffff8f,%edx
  100964:	83 ca 80             	or     $0xffffff80,%edx
  100967:	88 54 c1 05          	mov    %dl,0x5(%ecx,%eax,8)
  10096b:	89 eb                	mov    %ebp,%ebx
  10096d:	c1 eb 10             	shr    $0x10,%ebx
  100970:	66 89 5c c1 06       	mov    %bx,0x6(%ecx,%eax,8)
	for (i = 0; i < sizeof(idt)/sizeof(idt[0]); i++)
  100975:	83 c0 01             	add    $0x1,%eax
  100978:	3d ff 00 00 00       	cmp    $0xff,%eax
  10097d:	76 bb                	jbe    10093a <intr_init_idt+0x16>

	SETGATE(idt[T_DIVIDE],            0, CPU_GDT_KCODE, &Xdivide,       0);
  10097f:	c7 c0 a0 96 16 00    	mov    $0x1696a0,%eax
  100985:	c7 c1 60 18 10 00    	mov    $0x101860,%ecx
  10098b:	66 89 08             	mov    %cx,(%eax)
  10098e:	66 c7 40 02 08 00    	movw   $0x8,0x2(%eax)
  100994:	c6 40 04 00          	movb   $0x0,0x4(%eax)
  100998:	0f b6 50 05          	movzbl 0x5(%eax),%edx
  10099c:	83 e2 f0             	and    $0xfffffff0,%edx
  10099f:	83 ca 0e             	or     $0xe,%edx
  1009a2:	83 e2 8f             	and    $0xffffff8f,%edx
  1009a5:	83 ca 80             	or     $0xffffff80,%edx
  1009a8:	88 50 05             	mov    %dl,0x5(%eax)
  1009ab:	c1 e9 10             	shr    $0x10,%ecx
  1009ae:	66 89 48 06          	mov    %cx,0x6(%eax)
	SETGATE(idt[T_DEBUG],             0, CPU_GDT_KCODE, &Xdebug,        0);
  1009b2:	c7 c1 6a 18 10 00    	mov    $0x10186a,%ecx
  1009b8:	66 89 48 08          	mov    %cx,0x8(%eax)
  1009bc:	66 c7 40 0a 08 00    	movw   $0x8,0xa(%eax)
  1009c2:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
  1009c6:	0f b6 50 0d          	movzbl 0xd(%eax),%edx
  1009ca:	83 e2 f0             	and    $0xfffffff0,%edx
  1009cd:	83 ca 0e             	or     $0xe,%edx
  1009d0:	83 e2 8f             	and    $0xffffff8f,%edx
  1009d3:	83 ca 80             	or     $0xffffff80,%edx
  1009d6:	88 50 0d             	mov    %dl,0xd(%eax)
  1009d9:	c1 e9 10             	shr    $0x10,%ecx
  1009dc:	66 89 48 0e          	mov    %cx,0xe(%eax)
	SETGATE(idt[T_NMI],               0, CPU_GDT_KCODE, &Xnmi,          0);
  1009e0:	c7 c1 74 18 10 00    	mov    $0x101874,%ecx
  1009e6:	66 89 48 10          	mov    %cx,0x10(%eax)
  1009ea:	66 c7 40 12 08 00    	movw   $0x8,0x12(%eax)
  1009f0:	c6 40 14 00          	movb   $0x0,0x14(%eax)
  1009f4:	0f b6 50 15          	movzbl 0x15(%eax),%edx
  1009f8:	83 e2 f0             	and    $0xfffffff0,%edx
  1009fb:	83 ca 0e             	or     $0xe,%edx
  1009fe:	83 e2 8f             	and    $0xffffff8f,%edx
  100a01:	83 ca 80             	or     $0xffffff80,%edx
  100a04:	88 50 15             	mov    %dl,0x15(%eax)
  100a07:	c1 e9 10             	shr    $0x10,%ecx
  100a0a:	66 89 48 16          	mov    %cx,0x16(%eax)
	SETGATE(idt[T_BRKPT],             0, CPU_GDT_KCODE, &Xbrkpt,        3);
  100a0e:	c7 c1 7e 18 10 00    	mov    $0x10187e,%ecx
  100a14:	66 89 48 18          	mov    %cx,0x18(%eax)
  100a18:	66 c7 40 1a 08 00    	movw   $0x8,0x1a(%eax)
  100a1e:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
  100a22:	0f b6 50 1d          	movzbl 0x1d(%eax),%edx
  100a26:	83 e2 f0             	and    $0xfffffff0,%edx
  100a29:	83 ca 0e             	or     $0xe,%edx
  100a2c:	83 e2 ef             	and    $0xffffffef,%edx
  100a2f:	83 ca e0             	or     $0xffffffe0,%edx
  100a32:	88 50 1d             	mov    %dl,0x1d(%eax)
  100a35:	c1 e9 10             	shr    $0x10,%ecx
  100a38:	66 89 48 1e          	mov    %cx,0x1e(%eax)
	SETGATE(idt[T_OFLOW],             0, CPU_GDT_KCODE, &Xoflow,        3);
  100a3c:	c7 c1 88 18 10 00    	mov    $0x101888,%ecx
  100a42:	66 89 48 20          	mov    %cx,0x20(%eax)
  100a46:	66 c7 40 22 08 00    	movw   $0x8,0x22(%eax)
  100a4c:	c6 40 24 00          	movb   $0x0,0x24(%eax)
  100a50:	0f b6 50 25          	movzbl 0x25(%eax),%edx
  100a54:	83 e2 f0             	and    $0xfffffff0,%edx
  100a57:	83 ca 0e             	or     $0xe,%edx
  100a5a:	83 e2 ef             	and    $0xffffffef,%edx
  100a5d:	83 ca e0             	or     $0xffffffe0,%edx
  100a60:	88 50 25             	mov    %dl,0x25(%eax)
  100a63:	c1 e9 10             	shr    $0x10,%ecx
  100a66:	66 89 48 26          	mov    %cx,0x26(%eax)
	SETGATE(idt[T_BOUND],             0, CPU_GDT_KCODE, &Xbound,        0);
  100a6a:	c7 c1 92 18 10 00    	mov    $0x101892,%ecx
  100a70:	66 89 48 28          	mov    %cx,0x28(%eax)
  100a74:	66 c7 40 2a 08 00    	movw   $0x8,0x2a(%eax)
  100a7a:	c6 40 2c 00          	movb   $0x0,0x2c(%eax)
  100a7e:	0f b6 50 2d          	movzbl 0x2d(%eax),%edx
  100a82:	83 e2 f0             	and    $0xfffffff0,%edx
  100a85:	83 ca 0e             	or     $0xe,%edx
  100a88:	83 e2 8f             	and    $0xffffff8f,%edx
  100a8b:	83 ca 80             	or     $0xffffff80,%edx
  100a8e:	88 50 2d             	mov    %dl,0x2d(%eax)
  100a91:	c1 e9 10             	shr    $0x10,%ecx
  100a94:	66 89 48 2e          	mov    %cx,0x2e(%eax)
	SETGATE(idt[T_ILLOP],             0, CPU_GDT_KCODE, &Xillop,        0);
  100a98:	c7 c1 9c 18 10 00    	mov    $0x10189c,%ecx
  100a9e:	66 89 48 30          	mov    %cx,0x30(%eax)
  100aa2:	66 c7 40 32 08 00    	movw   $0x8,0x32(%eax)
  100aa8:	c6 40 34 00          	movb   $0x0,0x34(%eax)
  100aac:	0f b6 50 35          	movzbl 0x35(%eax),%edx
  100ab0:	83 e2 f0             	and    $0xfffffff0,%edx
  100ab3:	83 ca 0e             	or     $0xe,%edx
  100ab6:	83 e2 8f             	and    $0xffffff8f,%edx
  100ab9:	83 ca 80             	or     $0xffffff80,%edx
  100abc:	88 50 35             	mov    %dl,0x35(%eax)
  100abf:	c1 e9 10             	shr    $0x10,%ecx
  100ac2:	66 89 48 36          	mov    %cx,0x36(%eax)
	SETGATE(idt[T_DEVICE],            0, CPU_GDT_KCODE, &Xdevice,       0);
  100ac6:	c7 c1 a6 18 10 00    	mov    $0x1018a6,%ecx
  100acc:	66 89 48 38          	mov    %cx,0x38(%eax)
  100ad0:	66 c7 40 3a 08 00    	movw   $0x8,0x3a(%eax)
  100ad6:	c6 40 3c 00          	movb   $0x0,0x3c(%eax)
  100ada:	0f b6 50 3d          	movzbl 0x3d(%eax),%edx
  100ade:	83 e2 f0             	and    $0xfffffff0,%edx
  100ae1:	83 ca 0e             	or     $0xe,%edx
  100ae4:	83 e2 8f             	and    $0xffffff8f,%edx
  100ae7:	83 ca 80             	or     $0xffffff80,%edx
  100aea:	88 50 3d             	mov    %dl,0x3d(%eax)
  100aed:	c1 e9 10             	shr    $0x10,%ecx
  100af0:	66 89 48 3e          	mov    %cx,0x3e(%eax)
	SETGATE(idt[T_DBLFLT],            0, CPU_GDT_KCODE, &Xdblflt,       0);
  100af4:	c7 c1 b0 18 10 00    	mov    $0x1018b0,%ecx
  100afa:	66 89 48 40          	mov    %cx,0x40(%eax)
  100afe:	66 c7 40 42 08 00    	movw   $0x8,0x42(%eax)
  100b04:	c6 40 44 00          	movb   $0x0,0x44(%eax)
  100b08:	0f b6 50 45          	movzbl 0x45(%eax),%edx
  100b0c:	83 e2 f0             	and    $0xfffffff0,%edx
  100b0f:	83 ca 0e             	or     $0xe,%edx
  100b12:	83 e2 8f             	and    $0xffffff8f,%edx
  100b15:	83 ca 80             	or     $0xffffff80,%edx
  100b18:	88 50 45             	mov    %dl,0x45(%eax)
  100b1b:	c1 e9 10             	shr    $0x10,%ecx
  100b1e:	66 89 48 46          	mov    %cx,0x46(%eax)
	SETGATE(idt[T_TSS],               0, CPU_GDT_KCODE, &Xtss,          0);
  100b22:	c7 c1 c2 18 10 00    	mov    $0x1018c2,%ecx
  100b28:	66 89 48 50          	mov    %cx,0x50(%eax)
  100b2c:	66 c7 40 52 08 00    	movw   $0x8,0x52(%eax)
  100b32:	c6 40 54 00          	movb   $0x0,0x54(%eax)
  100b36:	0f b6 50 55          	movzbl 0x55(%eax),%edx
  100b3a:	83 e2 f0             	and    $0xfffffff0,%edx
  100b3d:	83 ca 0e             	or     $0xe,%edx
  100b40:	83 e2 8f             	and    $0xffffff8f,%edx
  100b43:	83 ca 80             	or     $0xffffff80,%edx
  100b46:	88 50 55             	mov    %dl,0x55(%eax)
  100b49:	c1 e9 10             	shr    $0x10,%ecx
  100b4c:	66 89 48 56          	mov    %cx,0x56(%eax)
	SETGATE(idt[T_SEGNP],             0, CPU_GDT_KCODE, &Xsegnp,        0);
  100b50:	c7 c1 ca 18 10 00    	mov    $0x1018ca,%ecx
  100b56:	66 89 48 58          	mov    %cx,0x58(%eax)
  100b5a:	66 c7 40 5a 08 00    	movw   $0x8,0x5a(%eax)
  100b60:	c6 40 5c 00          	movb   $0x0,0x5c(%eax)
  100b64:	0f b6 50 5d          	movzbl 0x5d(%eax),%edx
  100b68:	83 e2 f0             	and    $0xfffffff0,%edx
  100b6b:	83 ca 0e             	or     $0xe,%edx
  100b6e:	83 e2 8f             	and    $0xffffff8f,%edx
  100b71:	83 ca 80             	or     $0xffffff80,%edx
  100b74:	88 50 5d             	mov    %dl,0x5d(%eax)
  100b77:	c1 e9 10             	shr    $0x10,%ecx
  100b7a:	66 89 48 5e          	mov    %cx,0x5e(%eax)
	SETGATE(idt[T_STACK],             0, CPU_GDT_KCODE, &Xstack,        0);
  100b7e:	c7 c1 d2 18 10 00    	mov    $0x1018d2,%ecx
  100b84:	66 89 48 60          	mov    %cx,0x60(%eax)
  100b88:	66 c7 40 62 08 00    	movw   $0x8,0x62(%eax)
  100b8e:	c6 40 64 00          	movb   $0x0,0x64(%eax)
  100b92:	0f b6 50 65          	movzbl 0x65(%eax),%edx
  100b96:	83 e2 f0             	and    $0xfffffff0,%edx
  100b99:	83 ca 0e             	or     $0xe,%edx
  100b9c:	83 e2 8f             	and    $0xffffff8f,%edx
  100b9f:	83 ca 80             	or     $0xffffff80,%edx
  100ba2:	88 50 65             	mov    %dl,0x65(%eax)
  100ba5:	c1 e9 10             	shr    $0x10,%ecx
  100ba8:	66 89 48 66          	mov    %cx,0x66(%eax)
	SETGATE(idt[T_GPFLT],             0, CPU_GDT_KCODE, &Xgpflt,        0);
  100bac:	c7 c1 da 18 10 00    	mov    $0x1018da,%ecx
  100bb2:	66 89 48 68          	mov    %cx,0x68(%eax)
  100bb6:	66 c7 40 6a 08 00    	movw   $0x8,0x6a(%eax)
  100bbc:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
  100bc0:	0f b6 50 6d          	movzbl 0x6d(%eax),%edx
  100bc4:	83 e2 f0             	and    $0xfffffff0,%edx
  100bc7:	83 ca 0e             	or     $0xe,%edx
  100bca:	83 e2 8f             	and    $0xffffff8f,%edx
  100bcd:	83 ca 80             	or     $0xffffff80,%edx
  100bd0:	88 50 6d             	mov    %dl,0x6d(%eax)
  100bd3:	c1 e9 10             	shr    $0x10,%ecx
  100bd6:	66 89 48 6e          	mov    %cx,0x6e(%eax)
	SETGATE(idt[T_PGFLT],             0, CPU_GDT_KCODE, &Xpgflt,        0);
  100bda:	c7 c1 e2 18 10 00    	mov    $0x1018e2,%ecx
  100be0:	66 89 48 70          	mov    %cx,0x70(%eax)
  100be4:	66 c7 40 72 08 00    	movw   $0x8,0x72(%eax)
  100bea:	c6 40 74 00          	movb   $0x0,0x74(%eax)
  100bee:	0f b6 50 75          	movzbl 0x75(%eax),%edx
  100bf2:	83 e2 f0             	and    $0xfffffff0,%edx
  100bf5:	83 ca 0e             	or     $0xe,%edx
  100bf8:	83 e2 8f             	and    $0xffffff8f,%edx
  100bfb:	83 ca 80             	or     $0xffffff80,%edx
  100bfe:	88 50 75             	mov    %dl,0x75(%eax)
  100c01:	c1 e9 10             	shr    $0x10,%ecx
  100c04:	66 89 48 76          	mov    %cx,0x76(%eax)
	SETGATE(idt[T_FPERR],             0, CPU_GDT_KCODE, &Xfperr,        0);
  100c08:	c7 c1 f4 18 10 00    	mov    $0x1018f4,%ecx
  100c0e:	66 89 88 80 00 00 00 	mov    %cx,0x80(%eax)
  100c15:	66 c7 80 82 00 00 00 	movw   $0x8,0x82(%eax)
  100c1c:	08 00 
  100c1e:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
  100c25:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
  100c2c:	83 e2 f0             	and    $0xfffffff0,%edx
  100c2f:	83 ca 0e             	or     $0xe,%edx
  100c32:	83 e2 8f             	and    $0xffffff8f,%edx
  100c35:	83 ca 80             	or     $0xffffff80,%edx
  100c38:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
  100c3e:	c1 e9 10             	shr    $0x10,%ecx
  100c41:	66 89 88 86 00 00 00 	mov    %cx,0x86(%eax)
	SETGATE(idt[T_ALIGN],             0, CPU_GDT_KCODE, &Xalign,        0);
  100c48:	c7 c1 fe 18 10 00    	mov    $0x1018fe,%ecx
  100c4e:	66 89 88 88 00 00 00 	mov    %cx,0x88(%eax)
  100c55:	66 c7 80 8a 00 00 00 	movw   $0x8,0x8a(%eax)
  100c5c:	08 00 
  100c5e:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
  100c65:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
  100c6c:	83 e2 f0             	and    $0xfffffff0,%edx
  100c6f:	83 ca 0e             	or     $0xe,%edx
  100c72:	83 e2 8f             	and    $0xffffff8f,%edx
  100c75:	83 ca 80             	or     $0xffffff80,%edx
  100c78:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
  100c7e:	c1 e9 10             	shr    $0x10,%ecx
  100c81:	66 89 88 8e 00 00 00 	mov    %cx,0x8e(%eax)
	SETGATE(idt[T_MCHK],              0, CPU_GDT_KCODE, &Xmchk,         0);
  100c88:	c7 c1 02 19 10 00    	mov    $0x101902,%ecx
  100c8e:	66 89 88 90 00 00 00 	mov    %cx,0x90(%eax)
  100c95:	66 c7 80 92 00 00 00 	movw   $0x8,0x92(%eax)
  100c9c:	08 00 
  100c9e:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
  100ca5:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
  100cac:	83 e2 f0             	and    $0xfffffff0,%edx
  100caf:	83 ca 0e             	or     $0xe,%edx
  100cb2:	83 e2 8f             	and    $0xffffff8f,%edx
  100cb5:	83 ca 80             	or     $0xffffff80,%edx
  100cb8:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
  100cbe:	c1 e9 10             	shr    $0x10,%ecx
  100cc1:	66 89 88 96 00 00 00 	mov    %cx,0x96(%eax)

	SETGATE(idt[T_IRQ0+IRQ_TIMER],    0, CPU_GDT_KCODE, &Xirq_timer,    0);
  100cc8:	c7 c1 08 19 10 00    	mov    $0x101908,%ecx
  100cce:	66 89 88 00 01 00 00 	mov    %cx,0x100(%eax)
  100cd5:	66 c7 80 02 01 00 00 	movw   $0x8,0x102(%eax)
  100cdc:	08 00 
  100cde:	c6 80 04 01 00 00 00 	movb   $0x0,0x104(%eax)
  100ce5:	0f b6 90 05 01 00 00 	movzbl 0x105(%eax),%edx
  100cec:	83 e2 f0             	and    $0xfffffff0,%edx
  100cef:	83 ca 0e             	or     $0xe,%edx
  100cf2:	83 e2 8f             	and    $0xffffff8f,%edx
  100cf5:	83 ca 80             	or     $0xffffff80,%edx
  100cf8:	88 90 05 01 00 00    	mov    %dl,0x105(%eax)
  100cfe:	c1 e9 10             	shr    $0x10,%ecx
  100d01:	66 89 88 06 01 00 00 	mov    %cx,0x106(%eax)
	SETGATE(idt[T_IRQ0+IRQ_KBD],      0, CPU_GDT_KCODE, &Xirq_kbd,      0);
  100d08:	c7 c1 0e 19 10 00    	mov    $0x10190e,%ecx
  100d0e:	66 89 88 08 01 00 00 	mov    %cx,0x108(%eax)
  100d15:	66 c7 80 0a 01 00 00 	movw   $0x8,0x10a(%eax)
  100d1c:	08 00 
  100d1e:	c6 80 0c 01 00 00 00 	movb   $0x0,0x10c(%eax)
  100d25:	0f b6 90 0d 01 00 00 	movzbl 0x10d(%eax),%edx
  100d2c:	83 e2 f0             	and    $0xfffffff0,%edx
  100d2f:	83 ca 0e             	or     $0xe,%edx
  100d32:	83 e2 8f             	and    $0xffffff8f,%edx
  100d35:	83 ca 80             	or     $0xffffff80,%edx
  100d38:	88 90 0d 01 00 00    	mov    %dl,0x10d(%eax)
  100d3e:	c1 e9 10             	shr    $0x10,%ecx
  100d41:	66 89 88 0e 01 00 00 	mov    %cx,0x10e(%eax)
	SETGATE(idt[T_IRQ0+IRQ_SLAVE],    0, CPU_GDT_KCODE, &Xirq_slave,    0);
  100d48:	c7 c1 14 19 10 00    	mov    $0x101914,%ecx
  100d4e:	66 89 88 10 01 00 00 	mov    %cx,0x110(%eax)
  100d55:	66 c7 80 12 01 00 00 	movw   $0x8,0x112(%eax)
  100d5c:	08 00 
  100d5e:	c6 80 14 01 00 00 00 	movb   $0x0,0x114(%eax)
  100d65:	0f b6 90 15 01 00 00 	movzbl 0x115(%eax),%edx
  100d6c:	83 e2 f0             	and    $0xfffffff0,%edx
  100d6f:	83 ca 0e             	or     $0xe,%edx
  100d72:	83 e2 8f             	and    $0xffffff8f,%edx
  100d75:	83 ca 80             	or     $0xffffff80,%edx
  100d78:	88 90 15 01 00 00    	mov    %dl,0x115(%eax)
  100d7e:	c1 e9 10             	shr    $0x10,%ecx
  100d81:	66 89 88 16 01 00 00 	mov    %cx,0x116(%eax)
	SETGATE(idt[T_IRQ0+IRQ_SERIAL24], 0, CPU_GDT_KCODE, &Xirq_serial2,  0);
  100d88:	c7 c1 1a 19 10 00    	mov    $0x10191a,%ecx
  100d8e:	66 89 88 18 01 00 00 	mov    %cx,0x118(%eax)
  100d95:	66 c7 80 1a 01 00 00 	movw   $0x8,0x11a(%eax)
  100d9c:	08 00 
  100d9e:	c6 80 1c 01 00 00 00 	movb   $0x0,0x11c(%eax)
  100da5:	0f b6 90 1d 01 00 00 	movzbl 0x11d(%eax),%edx
  100dac:	83 e2 f0             	and    $0xfffffff0,%edx
  100daf:	83 ca 0e             	or     $0xe,%edx
  100db2:	83 e2 8f             	and    $0xffffff8f,%edx
  100db5:	83 ca 80             	or     $0xffffff80,%edx
  100db8:	88 90 1d 01 00 00    	mov    %dl,0x11d(%eax)
  100dbe:	c1 e9 10             	shr    $0x10,%ecx
  100dc1:	66 89 88 1e 01 00 00 	mov    %cx,0x11e(%eax)
	SETGATE(idt[T_IRQ0+IRQ_SERIAL13], 0, CPU_GDT_KCODE, &Xirq_serial1,  0);
  100dc8:	c7 c1 20 19 10 00    	mov    $0x101920,%ecx
  100dce:	66 89 88 20 01 00 00 	mov    %cx,0x120(%eax)
  100dd5:	66 c7 80 22 01 00 00 	movw   $0x8,0x122(%eax)
  100ddc:	08 00 
  100dde:	c6 80 24 01 00 00 00 	movb   $0x0,0x124(%eax)
  100de5:	0f b6 90 25 01 00 00 	movzbl 0x125(%eax),%edx
  100dec:	83 e2 f0             	and    $0xfffffff0,%edx
  100def:	83 ca 0e             	or     $0xe,%edx
  100df2:	83 e2 8f             	and    $0xffffff8f,%edx
  100df5:	83 ca 80             	or     $0xffffff80,%edx
  100df8:	88 90 25 01 00 00    	mov    %dl,0x125(%eax)
  100dfe:	c1 e9 10             	shr    $0x10,%ecx
  100e01:	66 89 88 26 01 00 00 	mov    %cx,0x126(%eax)
	SETGATE(idt[T_IRQ0+IRQ_LPT2],     0, CPU_GDT_KCODE, &Xirq_lpt,      0);
  100e08:	c7 c1 26 19 10 00    	mov    $0x101926,%ecx
  100e0e:	66 89 88 28 01 00 00 	mov    %cx,0x128(%eax)
  100e15:	66 c7 80 2a 01 00 00 	movw   $0x8,0x12a(%eax)
  100e1c:	08 00 
  100e1e:	c6 80 2c 01 00 00 00 	movb   $0x0,0x12c(%eax)
  100e25:	0f b6 90 2d 01 00 00 	movzbl 0x12d(%eax),%edx
  100e2c:	83 e2 f0             	and    $0xfffffff0,%edx
  100e2f:	83 ca 0e             	or     $0xe,%edx
  100e32:	83 e2 8f             	and    $0xffffff8f,%edx
  100e35:	83 ca 80             	or     $0xffffff80,%edx
  100e38:	88 90 2d 01 00 00    	mov    %dl,0x12d(%eax)
  100e3e:	c1 e9 10             	shr    $0x10,%ecx
  100e41:	66 89 88 2e 01 00 00 	mov    %cx,0x12e(%eax)
	SETGATE(idt[T_IRQ0+IRQ_FLOPPY],   0, CPU_GDT_KCODE, &Xirq_floppy,   0);
  100e48:	c7 c1 2c 19 10 00    	mov    $0x10192c,%ecx
  100e4e:	66 89 88 30 01 00 00 	mov    %cx,0x130(%eax)
  100e55:	66 c7 80 32 01 00 00 	movw   $0x8,0x132(%eax)
  100e5c:	08 00 
  100e5e:	c6 80 34 01 00 00 00 	movb   $0x0,0x134(%eax)
  100e65:	0f b6 90 35 01 00 00 	movzbl 0x135(%eax),%edx
  100e6c:	83 e2 f0             	and    $0xfffffff0,%edx
  100e6f:	83 ca 0e             	or     $0xe,%edx
  100e72:	83 e2 8f             	and    $0xffffff8f,%edx
  100e75:	83 ca 80             	or     $0xffffff80,%edx
  100e78:	88 90 35 01 00 00    	mov    %dl,0x135(%eax)
  100e7e:	c1 e9 10             	shr    $0x10,%ecx
  100e81:	66 89 88 36 01 00 00 	mov    %cx,0x136(%eax)
	SETGATE(idt[T_IRQ0+IRQ_SPURIOUS], 0, CPU_GDT_KCODE, &Xirq_spurious, 0);
  100e88:	c7 c1 32 19 10 00    	mov    $0x101932,%ecx
  100e8e:	66 89 88 38 01 00 00 	mov    %cx,0x138(%eax)
  100e95:	66 c7 80 3a 01 00 00 	movw   $0x8,0x13a(%eax)
  100e9c:	08 00 
  100e9e:	c6 80 3c 01 00 00 00 	movb   $0x0,0x13c(%eax)
  100ea5:	0f b6 90 3d 01 00 00 	movzbl 0x13d(%eax),%edx
  100eac:	83 e2 f0             	and    $0xfffffff0,%edx
  100eaf:	83 ca 0e             	or     $0xe,%edx
  100eb2:	83 e2 8f             	and    $0xffffff8f,%edx
  100eb5:	83 ca 80             	or     $0xffffff80,%edx
  100eb8:	88 90 3d 01 00 00    	mov    %dl,0x13d(%eax)
  100ebe:	c1 e9 10             	shr    $0x10,%ecx
  100ec1:	66 89 88 3e 01 00 00 	mov    %cx,0x13e(%eax)
	SETGATE(idt[T_IRQ0+IRQ_RTC],      0, CPU_GDT_KCODE, &Xirq_rtc,      0);
  100ec8:	c7 c1 38 19 10 00    	mov    $0x101938,%ecx
  100ece:	66 89 88 40 01 00 00 	mov    %cx,0x140(%eax)
  100ed5:	66 c7 80 42 01 00 00 	movw   $0x8,0x142(%eax)
  100edc:	08 00 
  100ede:	c6 80 44 01 00 00 00 	movb   $0x0,0x144(%eax)
  100ee5:	0f b6 90 45 01 00 00 	movzbl 0x145(%eax),%edx
  100eec:	83 e2 f0             	and    $0xfffffff0,%edx
  100eef:	83 ca 0e             	or     $0xe,%edx
  100ef2:	83 e2 8f             	and    $0xffffff8f,%edx
  100ef5:	83 ca 80             	or     $0xffffff80,%edx
  100ef8:	88 90 45 01 00 00    	mov    %dl,0x145(%eax)
  100efe:	c1 e9 10             	shr    $0x10,%ecx
  100f01:	66 89 88 46 01 00 00 	mov    %cx,0x146(%eax)
	SETGATE(idt[T_IRQ0+9],            0, CPU_GDT_KCODE, &Xirq9,         0);
  100f08:	c7 c1 3e 19 10 00    	mov    $0x10193e,%ecx
  100f0e:	66 89 88 48 01 00 00 	mov    %cx,0x148(%eax)
  100f15:	66 c7 80 4a 01 00 00 	movw   $0x8,0x14a(%eax)
  100f1c:	08 00 
  100f1e:	c6 80 4c 01 00 00 00 	movb   $0x0,0x14c(%eax)
  100f25:	0f b6 90 4d 01 00 00 	movzbl 0x14d(%eax),%edx
  100f2c:	83 e2 f0             	and    $0xfffffff0,%edx
  100f2f:	83 ca 0e             	or     $0xe,%edx
  100f32:	83 e2 8f             	and    $0xffffff8f,%edx
  100f35:	83 ca 80             	or     $0xffffff80,%edx
  100f38:	88 90 4d 01 00 00    	mov    %dl,0x14d(%eax)
  100f3e:	c1 e9 10             	shr    $0x10,%ecx
  100f41:	66 89 88 4e 01 00 00 	mov    %cx,0x14e(%eax)
	SETGATE(idt[T_IRQ0+10],           0, CPU_GDT_KCODE, &Xirq10,        0);
  100f48:	c7 c2 44 19 10 00    	mov    $0x101944,%edx
  100f4e:	66 89 90 50 01 00 00 	mov    %dx,0x150(%eax)
  100f55:	66 c7 80 52 01 00 00 	movw   $0x8,0x152(%eax)
  100f5c:	08 00 
  100f5e:	c6 80 54 01 00 00 00 	movb   $0x0,0x154(%eax)
  100f65:	0f b6 90 55 01 00 00 	movzbl 0x155(%eax),%edx
  100f6c:	83 e2 f0             	and    $0xfffffff0,%edx
  100f6f:	83 ca 0e             	or     $0xe,%edx
  100f72:	83 e2 8f             	and    $0xffffff8f,%edx
  100f75:	83 ca 80             	or     $0xffffff80,%edx
  100f78:	88 90 55 01 00 00    	mov    %dl,0x155(%eax)
  100f7e:	c7 c2 44 19 10 00    	mov    $0x101944,%edx
  100f84:	c1 ea 10             	shr    $0x10,%edx
  100f87:	66 89 90 56 01 00 00 	mov    %dx,0x156(%eax)
	SETGATE(idt[T_IRQ0+11],           0, CPU_GDT_KCODE, &Xirq11,        0);
  100f8e:	c7 c1 4a 19 10 00    	mov    $0x10194a,%ecx
  100f94:	66 89 88 58 01 00 00 	mov    %cx,0x158(%eax)
  100f9b:	66 c7 80 5a 01 00 00 	movw   $0x8,0x15a(%eax)
  100fa2:	08 00 
  100fa4:	c6 80 5c 01 00 00 00 	movb   $0x0,0x15c(%eax)
  100fab:	0f b6 90 5d 01 00 00 	movzbl 0x15d(%eax),%edx
  100fb2:	83 e2 f0             	and    $0xfffffff0,%edx
  100fb5:	83 ca 0e             	or     $0xe,%edx
  100fb8:	83 e2 8f             	and    $0xffffff8f,%edx
  100fbb:	83 ca 80             	or     $0xffffff80,%edx
  100fbe:	88 90 5d 01 00 00    	mov    %dl,0x15d(%eax)
  100fc4:	c1 e9 10             	shr    $0x10,%ecx
  100fc7:	66 89 88 5e 01 00 00 	mov    %cx,0x15e(%eax)
	SETGATE(idt[T_IRQ0+IRQ_MOUSE],    0, CPU_GDT_KCODE, &Xirq_mouse,    0);
  100fce:	c7 c1 50 19 10 00    	mov    $0x101950,%ecx
  100fd4:	66 89 88 60 01 00 00 	mov    %cx,0x160(%eax)
  100fdb:	66 c7 80 62 01 00 00 	movw   $0x8,0x162(%eax)
  100fe2:	08 00 
  100fe4:	c6 80 64 01 00 00 00 	movb   $0x0,0x164(%eax)
  100feb:	0f b6 90 65 01 00 00 	movzbl 0x165(%eax),%edx
  100ff2:	83 e2 f0             	and    $0xfffffff0,%edx
  100ff5:	83 ca 0e             	or     $0xe,%edx
  100ff8:	83 e2 8f             	and    $0xffffff8f,%edx
  100ffb:	83 ca 80             	or     $0xffffff80,%edx
  100ffe:	88 90 65 01 00 00    	mov    %dl,0x165(%eax)
  101004:	c1 e9 10             	shr    $0x10,%ecx
  101007:	66 89 88 66 01 00 00 	mov    %cx,0x166(%eax)
	SETGATE(idt[T_IRQ0+IRQ_COPROCESSOR], 0, CPU_GDT_KCODE, &Xirq_coproc, 0);
  10100e:	c7 c1 56 19 10 00    	mov    $0x101956,%ecx
  101014:	66 89 88 68 01 00 00 	mov    %cx,0x168(%eax)
  10101b:	66 c7 80 6a 01 00 00 	movw   $0x8,0x16a(%eax)
  101022:	08 00 
  101024:	c6 80 6c 01 00 00 00 	movb   $0x0,0x16c(%eax)
  10102b:	0f b6 90 6d 01 00 00 	movzbl 0x16d(%eax),%edx
  101032:	83 e2 f0             	and    $0xfffffff0,%edx
  101035:	83 ca 0e             	or     $0xe,%edx
  101038:	83 e2 8f             	and    $0xffffff8f,%edx
  10103b:	83 ca 80             	or     $0xffffff80,%edx
  10103e:	88 90 6d 01 00 00    	mov    %dl,0x16d(%eax)
  101044:	c1 e9 10             	shr    $0x10,%ecx
  101047:	66 89 88 6e 01 00 00 	mov    %cx,0x16e(%eax)
	SETGATE(idt[T_IRQ0+IRQ_IDE1],     0, CPU_GDT_KCODE, &Xirq_ide1,     0);
  10104e:	c7 c1 5c 19 10 00    	mov    $0x10195c,%ecx
  101054:	66 89 88 70 01 00 00 	mov    %cx,0x170(%eax)
  10105b:	66 c7 80 72 01 00 00 	movw   $0x8,0x172(%eax)
  101062:	08 00 
  101064:	c6 80 74 01 00 00 00 	movb   $0x0,0x174(%eax)
  10106b:	0f b6 90 75 01 00 00 	movzbl 0x175(%eax),%edx
  101072:	83 e2 f0             	and    $0xfffffff0,%edx
  101075:	83 ca 0e             	or     $0xe,%edx
  101078:	83 e2 8f             	and    $0xffffff8f,%edx
  10107b:	83 ca 80             	or     $0xffffff80,%edx
  10107e:	88 90 75 01 00 00    	mov    %dl,0x175(%eax)
  101084:	c1 e9 10             	shr    $0x10,%ecx
  101087:	66 89 88 76 01 00 00 	mov    %cx,0x176(%eax)
	SETGATE(idt[T_IRQ0+IRQ_IDE2],     0, CPU_GDT_KCODE, &Xirq_ide2,     0);
  10108e:	c7 c1 62 19 10 00    	mov    $0x101962,%ecx
  101094:	66 89 88 78 01 00 00 	mov    %cx,0x178(%eax)
  10109b:	66 c7 80 7a 01 00 00 	movw   $0x8,0x17a(%eax)
  1010a2:	08 00 
  1010a4:	c6 80 7c 01 00 00 00 	movb   $0x0,0x17c(%eax)
  1010ab:	0f b6 90 7d 01 00 00 	movzbl 0x17d(%eax),%edx
  1010b2:	83 e2 f0             	and    $0xfffffff0,%edx
  1010b5:	83 ca 0e             	or     $0xe,%edx
  1010b8:	83 e2 8f             	and    $0xffffff8f,%edx
  1010bb:	83 ca 80             	or     $0xffffff80,%edx
  1010be:	88 90 7d 01 00 00    	mov    %dl,0x17d(%eax)
  1010c4:	c1 e9 10             	shr    $0x10,%ecx
  1010c7:	66 89 88 7e 01 00 00 	mov    %cx,0x17e(%eax)

	// Use DPL=3 here because system calls are explicitly invoked
	// by the user process (with "int $T_SYSCALL").
	SETGATE(idt[T_SYSCALL],           0, CPU_GDT_KCODE, &Xsyscall,      3);
  1010ce:	c7 c1 68 19 10 00    	mov    $0x101968,%ecx
  1010d4:	66 89 88 80 01 00 00 	mov    %cx,0x180(%eax)
  1010db:	66 c7 80 82 01 00 00 	movw   $0x8,0x182(%eax)
  1010e2:	08 00 
  1010e4:	c6 80 84 01 00 00 00 	movb   $0x0,0x184(%eax)
  1010eb:	0f b6 90 85 01 00 00 	movzbl 0x185(%eax),%edx
  1010f2:	83 e2 f0             	and    $0xfffffff0,%edx
  1010f5:	83 ca 0e             	or     $0xe,%edx
  1010f8:	83 e2 ef             	and    $0xffffffef,%edx
  1010fb:	83 ca e0             	or     $0xffffffe0,%edx
  1010fe:	88 90 85 01 00 00    	mov    %dl,0x185(%eax)
  101104:	c1 e9 10             	shr    $0x10,%ecx
  101107:	66 89 88 86 01 00 00 	mov    %cx,0x186(%eax)

	/* default */
	SETGATE(idt[T_DEFAULT],           0, CPU_GDT_KCODE, &Xdefault,      0);
  10110e:	c7 c1 6e 19 10 00    	mov    $0x10196e,%ecx
  101114:	66 89 88 f0 07 00 00 	mov    %cx,0x7f0(%eax)
  10111b:	66 c7 80 f2 07 00 00 	movw   $0x8,0x7f2(%eax)
  101122:	08 00 
  101124:	c6 80 f4 07 00 00 00 	movb   $0x0,0x7f4(%eax)
  10112b:	0f b6 90 f5 07 00 00 	movzbl 0x7f5(%eax),%edx
  101132:	83 e2 f0             	and    $0xfffffff0,%edx
  101135:	83 ca 0e             	or     $0xe,%edx
  101138:	83 e2 8f             	and    $0xffffff8f,%edx
  10113b:	83 ca 80             	or     $0xffffff80,%edx
  10113e:	88 90 f5 07 00 00    	mov    %dl,0x7f5(%eax)
  101144:	c1 e9 10             	shr    $0x10,%ecx
  101147:	66 89 88 f6 07 00 00 	mov    %cx,0x7f6(%eax)

	asm volatile("lidt %0" : : "m" (idt_pd));
  10114e:	0f 01 9e 20 03 00 00 	lidtl  0x320(%esi)
}
  101155:	5b                   	pop    %ebx
  101156:	5e                   	pop    %esi
  101157:	5f                   	pop    %edi
  101158:	5d                   	pop    %ebp
  101159:	c3                   	ret    

0010115a <intr_init>:

void
intr_init(void)
{
  10115a:	53                   	push   %ebx
  10115b:	83 ec 08             	sub    $0x8,%esp
  10115e:	e8 ac f1 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  101163:	81 c3 9d 9e 00 00    	add    $0x9e9d,%ebx
	if (intr_inited == TRUE)
  101169:	0f b6 83 04 d4 01 00 	movzbl 0x1d404(%ebx),%eax
  101170:	3c 01                	cmp    $0x1,%al
  101172:	74 11                	je     101185 <intr_init+0x2b>
		return;

  pic_init();
  101174:	e8 89 00 00 00       	call   101202 <pic_init>
	intr_init_idt();
  101179:	e8 a6 f7 ff ff       	call   100924 <intr_init_idt>
	intr_inited = TRUE;
  10117e:	c6 83 04 d4 01 00 01 	movb   $0x1,0x1d404(%ebx)
}
  101185:	83 c4 08             	add    $0x8,%esp
  101188:	5b                   	pop    %ebx
  101189:	c3                   	ret    

0010118a <intr_enable>:

void
intr_enable(uint8_t irq)
{
  10118a:	53                   	push   %ebx
  10118b:	83 ec 08             	sub    $0x8,%esp
  10118e:	e8 7c f1 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  101193:	81 c3 6d 9e 00 00    	add    $0x9e6d,%ebx
  101199:	8b 44 24 10          	mov    0x10(%esp),%eax
	if (irq >= 16)
  10119d:	3c 0f                	cmp    $0xf,%al
  10119f:	76 05                	jbe    1011a6 <intr_enable+0x1c>
		return;
	pic_enable(irq);
}
  1011a1:	83 c4 08             	add    $0x8,%esp
  1011a4:	5b                   	pop    %ebx
  1011a5:	c3                   	ret    
	pic_enable(irq);
  1011a6:	83 ec 0c             	sub    $0xc,%esp
  1011a9:	0f b6 c0             	movzbl %al,%eax
  1011ac:	50                   	push   %eax
  1011ad:	e8 a0 01 00 00       	call   101352 <pic_enable>
  1011b2:	83 c4 10             	add    $0x10,%esp
  1011b5:	eb ea                	jmp    1011a1 <intr_enable+0x17>

001011b7 <intr_eoi>:

void
intr_eoi(void)
{
  1011b7:	53                   	push   %ebx
  1011b8:	83 ec 08             	sub    $0x8,%esp
  1011bb:	e8 4f f1 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  1011c0:	81 c3 40 9e 00 00    	add    $0x9e40,%ebx
	pic_eoi();
  1011c6:	e8 b6 01 00 00       	call   101381 <pic_eoi>
}
  1011cb:	83 c4 08             	add    $0x8,%esp
  1011ce:	5b                   	pop    %ebx
  1011cf:	c3                   	ret    

001011d0 <intr_local_enable>:

void
intr_local_enable(void)
{
  1011d0:	53                   	push   %ebx
  1011d1:	83 ec 08             	sub    $0x8,%esp
  1011d4:	e8 36 f1 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  1011d9:	81 c3 27 9e 00 00    	add    $0x9e27,%ebx
	sti();
  1011df:	e8 f0 15 00 00       	call   1027d4 <sti>
}
  1011e4:	83 c4 08             	add    $0x8,%esp
  1011e7:	5b                   	pop    %ebx
  1011e8:	c3                   	ret    

001011e9 <intr_local_disable>:

void
intr_local_disable(void)
{
  1011e9:	53                   	push   %ebx
  1011ea:	83 ec 08             	sub    $0x8,%esp
  1011ed:	e8 1d f1 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  1011f2:	81 c3 0e 9e 00 00    	add    $0x9e0e,%ebx
	cli();
  1011f8:	e8 d5 15 00 00       	call   1027d2 <cli>
}
  1011fd:	83 c4 08             	add    $0x8,%esp
  101200:	5b                   	pop    %ebx
  101201:	c3                   	ret    

00101202 <pic_init>:
static bool pic_inited = FALSE;

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
  101202:	53                   	push   %ebx
  101203:	83 ec 08             	sub    $0x8,%esp
  101206:	e8 04 f1 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  10120b:	81 c3 f5 9d 00 00    	add    $0x9df5,%ebx
	if (pic_inited == TRUE)		// only do once on bootstrap CPU
  101211:	80 bb 05 d4 01 00 01 	cmpb   $0x1,0x1d405(%ebx)
  101218:	0f 84 ee 00 00 00    	je     10130c <pic_init+0x10a>
		return;
	pic_inited = TRUE;
  10121e:	c6 83 05 d4 01 00 01 	movb   $0x1,0x1d405(%ebx)

	/* mask all interrupts */
	outb(IO_PIC1+1, 0xff);
  101225:	83 ec 08             	sub    $0x8,%esp
  101228:	68 ff 00 00 00       	push   $0xff
  10122d:	6a 21                	push   $0x21
  10122f:	e8 65 16 00 00       	call   102899 <outb>
	outb(IO_PIC2+1, 0xff);
  101234:	83 c4 08             	add    $0x8,%esp
  101237:	68 ff 00 00 00       	push   $0xff
  10123c:	68 a1 00 00 00       	push   $0xa1
  101241:	e8 53 16 00 00       	call   102899 <outb>

	// ICW1:  0001g0hi
	//    g:  0 = edge triggering, 1 = level triggering
	//    h:  0 = cascaded PICs, 1 = master only
	//    i:  0 = no ICW4, 1 = ICW4 required
	outb(IO_PIC1, 0x11);
  101246:	83 c4 08             	add    $0x8,%esp
  101249:	6a 11                	push   $0x11
  10124b:	6a 20                	push   $0x20
  10124d:	e8 47 16 00 00       	call   102899 <outb>

	// ICW2:  Vector offset
	outb(IO_PIC1+1, T_IRQ0);
  101252:	83 c4 08             	add    $0x8,%esp
  101255:	6a 20                	push   $0x20
  101257:	6a 21                	push   $0x21
  101259:	e8 3b 16 00 00       	call   102899 <outb>

	// ICW3:  bit mask of IR lines connected to slave PICs (master PIC),
	//        3-bit No of IR line at which slave connects to master(slave PIC).
	outb(IO_PIC1+1, 1<<IRQ_SLAVE);
  10125e:	83 c4 08             	add    $0x8,%esp
  101261:	6a 04                	push   $0x4
  101263:	6a 21                	push   $0x21
  101265:	e8 2f 16 00 00       	call   102899 <outb>
	//    m:  0 = slave PIC, 1 = master PIC
	//	  (ignored when b is 0, as the master/slave role
	//	  can be hardwired).
	//    a:  1 = Automatic EOI mode
	//    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
	outb(IO_PIC1+1, 0x1);
  10126a:	83 c4 08             	add    $0x8,%esp
  10126d:	6a 01                	push   $0x1
  10126f:	6a 21                	push   $0x21
  101271:	e8 23 16 00 00       	call   102899 <outb>

	// Set up slave (8259A-2)
	outb(IO_PIC2, 0x11);			// ICW1
  101276:	83 c4 08             	add    $0x8,%esp
  101279:	6a 11                	push   $0x11
  10127b:	68 a0 00 00 00       	push   $0xa0
  101280:	e8 14 16 00 00       	call   102899 <outb>
	outb(IO_PIC2+1, T_IRQ0 + 8);		// ICW2
  101285:	83 c4 08             	add    $0x8,%esp
  101288:	6a 28                	push   $0x28
  10128a:	68 a1 00 00 00       	push   $0xa1
  10128f:	e8 05 16 00 00       	call   102899 <outb>
	outb(IO_PIC2+1, IRQ_SLAVE);		// ICW3
  101294:	83 c4 08             	add    $0x8,%esp
  101297:	6a 02                	push   $0x2
  101299:	68 a1 00 00 00       	push   $0xa1
  10129e:	e8 f6 15 00 00       	call   102899 <outb>
	// NB Automatic EOI mode doesn't tend to work on the slave.
	// Linux source code says it's "to be investigated".
	outb(IO_PIC2+1, 0x01);			// ICW4
  1012a3:	83 c4 08             	add    $0x8,%esp
  1012a6:	6a 01                	push   $0x1
  1012a8:	68 a1 00 00 00       	push   $0xa1
  1012ad:	e8 e7 15 00 00       	call   102899 <outb>

	// OCW3:  0ef01prs
	//   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
	//    p:  0 = no polling, 1 = polling mode
	//   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
	outb(IO_PIC1, 0x68);             /* clear specific mask */
  1012b2:	83 c4 08             	add    $0x8,%esp
  1012b5:	6a 68                	push   $0x68
  1012b7:	6a 20                	push   $0x20
  1012b9:	e8 db 15 00 00       	call   102899 <outb>
	outb(IO_PIC1, 0x0a);             /* read IRR by default */
  1012be:	83 c4 08             	add    $0x8,%esp
  1012c1:	6a 0a                	push   $0xa
  1012c3:	6a 20                	push   $0x20
  1012c5:	e8 cf 15 00 00       	call   102899 <outb>

	outb(IO_PIC2, 0x68);               /* OCW3 */
  1012ca:	83 c4 08             	add    $0x8,%esp
  1012cd:	6a 68                	push   $0x68
  1012cf:	68 a0 00 00 00       	push   $0xa0
  1012d4:	e8 c0 15 00 00       	call   102899 <outb>
	outb(IO_PIC2, 0x0a);               /* OCW3 */
  1012d9:	83 c4 08             	add    $0x8,%esp
  1012dc:	6a 0a                	push   $0xa
  1012de:	68 a0 00 00 00       	push   $0xa0
  1012e3:	e8 b1 15 00 00       	call   102899 <outb>

	// mask all interrupts
	outb(IO_PIC1+1, 0xFF);
  1012e8:	83 c4 08             	add    $0x8,%esp
  1012eb:	68 ff 00 00 00       	push   $0xff
  1012f0:	6a 21                	push   $0x21
  1012f2:	e8 a2 15 00 00       	call   102899 <outb>
	outb(IO_PIC2+1, 0xFF);
  1012f7:	83 c4 08             	add    $0x8,%esp
  1012fa:	68 ff 00 00 00       	push   $0xff
  1012ff:	68 a1 00 00 00       	push   $0xa1
  101304:	e8 90 15 00 00       	call   102899 <outb>
  101309:	83 c4 10             	add    $0x10,%esp
}
  10130c:	83 c4 08             	add    $0x8,%esp
  10130f:	5b                   	pop    %ebx
  101310:	c3                   	ret    

00101311 <pic_setmask>:

void
pic_setmask(uint16_t mask)
{
  101311:	56                   	push   %esi
  101312:	53                   	push   %ebx
  101313:	83 ec 0c             	sub    $0xc,%esp
  101316:	e8 f4 ef ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  10131b:	81 c3 e5 9c 00 00    	add    $0x9ce5,%ebx
  101321:	8b 74 24 18          	mov    0x18(%esp),%esi
	irqmask = mask;
  101325:	66 89 b3 26 03 00 00 	mov    %si,0x326(%ebx)
	outb(IO_PIC1+1, (char)mask);
  10132c:	89 f0                	mov    %esi,%eax
  10132e:	0f b6 c0             	movzbl %al,%eax
  101331:	50                   	push   %eax
  101332:	6a 21                	push   $0x21
  101334:	e8 60 15 00 00       	call   102899 <outb>
	outb(IO_PIC2+1, (char)(mask >> 8));
  101339:	83 c4 08             	add    $0x8,%esp
  10133c:	89 f0                	mov    %esi,%eax
  10133e:	0f b6 f4             	movzbl %ah,%esi
  101341:	56                   	push   %esi
  101342:	68 a1 00 00 00       	push   $0xa1
  101347:	e8 4d 15 00 00       	call   102899 <outb>
}
  10134c:	83 c4 14             	add    $0x14,%esp
  10134f:	5b                   	pop    %ebx
  101350:	5e                   	pop    %esi
  101351:	c3                   	ret    

00101352 <pic_enable>:

void
pic_enable(int irq)
{
  101352:	83 ec 18             	sub    $0x18,%esp
  101355:	e8 21 01 00 00       	call   10147b <__x86.get_pc_thunk.dx>
  10135a:	81 c2 a6 9c 00 00    	add    $0x9ca6,%edx
	pic_setmask(irqmask & ~(1 << irq));
  101360:	8b 4c 24 1c          	mov    0x1c(%esp),%ecx
  101364:	b8 01 00 00 00       	mov    $0x1,%eax
  101369:	d3 e0                	shl    %cl,%eax
  10136b:	f7 d0                	not    %eax
  10136d:	66 23 82 26 03 00 00 	and    0x326(%edx),%ax
  101374:	0f b7 c0             	movzwl %ax,%eax
  101377:	50                   	push   %eax
  101378:	e8 94 ff ff ff       	call   101311 <pic_setmask>
}
  10137d:	83 c4 1c             	add    $0x1c,%esp
  101380:	c3                   	ret    

00101381 <pic_eoi>:

void
pic_eoi(void)
{
  101381:	53                   	push   %ebx
  101382:	83 ec 10             	sub    $0x10,%esp
  101385:	e8 85 ef ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  10138a:	81 c3 76 9c 00 00    	add    $0x9c76,%ebx
	// OCW2: rse00xxx
	//   r: rotate
	//   s: specific
	//   e: end-of-interrupt
	// xxx: specific interrupt line
	outb(IO_PIC1, 0x20);
  101390:	6a 20                	push   $0x20
  101392:	6a 20                	push   $0x20
  101394:	e8 00 15 00 00       	call   102899 <outb>
	outb(IO_PIC2, 0x20);
  101399:	83 c4 08             	add    $0x8,%esp
  10139c:	6a 20                	push   $0x20
  10139e:	68 a0 00 00 00       	push   $0xa0
  1013a3:	e8 f1 14 00 00       	call   102899 <outb>
}
  1013a8:	83 c4 18             	add    $0x18,%esp
  1013ab:	5b                   	pop    %ebx
  1013ac:	c3                   	ret    

001013ad <pic_reset>:

void
pic_reset(void)
{
  1013ad:	53                   	push   %ebx
  1013ae:	83 ec 10             	sub    $0x10,%esp
  1013b1:	e8 59 ef ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  1013b6:	81 c3 4a 9c 00 00    	add    $0x9c4a,%ebx
	// mask all interrupts
	outb(IO_PIC1+1, 0x00);
  1013bc:	6a 00                	push   $0x0
  1013be:	6a 21                	push   $0x21
  1013c0:	e8 d4 14 00 00       	call   102899 <outb>
	outb(IO_PIC2+1, 0x00);
  1013c5:	83 c4 08             	add    $0x8,%esp
  1013c8:	6a 00                	push   $0x0
  1013ca:	68 a1 00 00 00       	push   $0xa1
  1013cf:	e8 c5 14 00 00       	call   102899 <outb>

	// ICW1:  0001g0hi
	//    g:  0 = edge triggering, 1 = level triggering
	//    h:  0 = cascaded PICs, 1 = master only
	//    i:  0 = no ICW4, 1 = ICW4 required
	outb(IO_PIC1, 0x11);
  1013d4:	83 c4 08             	add    $0x8,%esp
  1013d7:	6a 11                	push   $0x11
  1013d9:	6a 20                	push   $0x20
  1013db:	e8 b9 14 00 00       	call   102899 <outb>

	// ICW2:  Vector offset
	outb(IO_PIC1+1, T_IRQ0);
  1013e0:	83 c4 08             	add    $0x8,%esp
  1013e3:	6a 20                	push   $0x20
  1013e5:	6a 21                	push   $0x21
  1013e7:	e8 ad 14 00 00       	call   102899 <outb>

	// ICW3:  bit mask of IR lines connected to slave PICs (master PIC),
	//        3-bit No of IR line at which slave connects to master(slave PIC).
	outb(IO_PIC1+1, 1<<IRQ_SLAVE);
  1013ec:	83 c4 08             	add    $0x8,%esp
  1013ef:	6a 04                	push   $0x4
  1013f1:	6a 21                	push   $0x21
  1013f3:	e8 a1 14 00 00       	call   102899 <outb>
	//    m:  0 = slave PIC, 1 = master PIC
	//	  (ignored when b is 0, as the master/slave role
	//	  can be hardwired).
	//    a:  1 = Automatic EOI mode
	//    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
	outb(IO_PIC1+1, 0x3);
  1013f8:	83 c4 08             	add    $0x8,%esp
  1013fb:	6a 03                	push   $0x3
  1013fd:	6a 21                	push   $0x21
  1013ff:	e8 95 14 00 00       	call   102899 <outb>

	// Set up slave (8259A-2)
	outb(IO_PIC2, 0x11);			// ICW1
  101404:	83 c4 08             	add    $0x8,%esp
  101407:	6a 11                	push   $0x11
  101409:	68 a0 00 00 00       	push   $0xa0
  10140e:	e8 86 14 00 00       	call   102899 <outb>
	outb(IO_PIC2+1, T_IRQ0 + 8);		// ICW2
  101413:	83 c4 08             	add    $0x8,%esp
  101416:	6a 28                	push   $0x28
  101418:	68 a1 00 00 00       	push   $0xa1
  10141d:	e8 77 14 00 00       	call   102899 <outb>
	outb(IO_PIC2+1, IRQ_SLAVE);		// ICW3
  101422:	83 c4 08             	add    $0x8,%esp
  101425:	6a 02                	push   $0x2
  101427:	68 a1 00 00 00       	push   $0xa1
  10142c:	e8 68 14 00 00       	call   102899 <outb>
	// NB Automatic EOI mode doesn't tend to work on the slave.
	// Linux source code says it's "to be investigated".
	outb(IO_PIC2+1, 0x01);			// ICW4
  101431:	83 c4 08             	add    $0x8,%esp
  101434:	6a 01                	push   $0x1
  101436:	68 a1 00 00 00       	push   $0xa1
  10143b:	e8 59 14 00 00       	call   102899 <outb>

	// OCW3:  0ef01prs
	//   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
	//    p:  0 = no polling, 1 = polling mode
	//   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
	outb(IO_PIC1, 0x68);             /* clear specific mask */
  101440:	83 c4 08             	add    $0x8,%esp
  101443:	6a 68                	push   $0x68
  101445:	6a 20                	push   $0x20
  101447:	e8 4d 14 00 00       	call   102899 <outb>
	outb(IO_PIC1, 0x0a);             /* read IRR by default */
  10144c:	83 c4 08             	add    $0x8,%esp
  10144f:	6a 0a                	push   $0xa
  101451:	6a 20                	push   $0x20
  101453:	e8 41 14 00 00       	call   102899 <outb>

	outb(IO_PIC2, 0x68);               /* OCW3 */
  101458:	83 c4 08             	add    $0x8,%esp
  10145b:	6a 68                	push   $0x68
  10145d:	68 a0 00 00 00       	push   $0xa0
  101462:	e8 32 14 00 00       	call   102899 <outb>
	outb(IO_PIC2, 0x0a);               /* OCW3 */
  101467:	83 c4 08             	add    $0x8,%esp
  10146a:	6a 0a                	push   $0xa
  10146c:	68 a0 00 00 00       	push   $0xa0
  101471:	e8 23 14 00 00       	call   102899 <outb>
}
  101476:	83 c4 18             	add    $0x18,%esp
  101479:	5b                   	pop    %ebx
  10147a:	c3                   	ret    

0010147b <__x86.get_pc_thunk.dx>:
  10147b:	8b 14 24             	mov    (%esp),%edx
  10147e:	c3                   	ret    

0010147f <timer_hw_init>:

// Initialize the programmable interval timer.

void
timer_hw_init(void)
{
  10147f:	53                   	push   %ebx
  101480:	83 ec 10             	sub    $0x10,%esp
  101483:	e8 87 ee ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  101488:	81 c3 78 9b 00 00    	add    $0x9b78,%ebx
	outb(PIT_CONTROL, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  10148e:	6a 34                	push   $0x34
  101490:	6a 43                	push   $0x43
  101492:	e8 02 14 00 00       	call   102899 <outb>
	outb(PIT_CHANNEL0, LOW8(LATCH));
  101497:	83 c4 08             	add    $0x8,%esp
  10149a:	68 9c 00 00 00       	push   $0x9c
  10149f:	6a 40                	push   $0x40
  1014a1:	e8 f3 13 00 00       	call   102899 <outb>
	outb(PIT_CHANNEL0, HIGH8(LATCH));
  1014a6:	83 c4 08             	add    $0x8,%esp
  1014a9:	6a 2e                	push   $0x2e
  1014ab:	6a 40                	push   $0x40
  1014ad:	e8 e7 13 00 00       	call   102899 <outb>
}
  1014b2:	83 c4 18             	add    $0x18,%esp
  1014b5:	5b                   	pop    %ebx
  1014b6:	c3                   	ret    

001014b7 <tsc_calibrate>:
/*
 * XXX: From Linux 3.2.6: arch/x86/kernel/tsc.c: pit_calibrate_tsc()
 */
static uint64_t
tsc_calibrate(uint32_t latch, uint32_t ms, int loopmin)
{
  1014b7:	55                   	push   %ebp
  1014b8:	57                   	push   %edi
  1014b9:	56                   	push   %esi
  1014ba:	53                   	push   %ebx
  1014bb:	83 ec 48             	sub    $0x48,%esp
  1014be:	e8 58 f0 ff ff       	call   10051b <__x86.get_pc_thunk.si>
  1014c3:	81 c6 3d 9b 00 00    	add    $0x9b3d,%esi
  1014c9:	89 c7                	mov    %eax,%edi
  1014cb:	89 54 24 38          	mov    %edx,0x38(%esp)
  1014cf:	89 cd                	mov    %ecx,%ebp
	uint64_t tsc, t1, t2, delta, tscmin, tscmax;;
	int pitcnt;

	/* Set the Gate high, disable speaker */
	outb(0x61, (inb(0x61) & ~0x02) | 0x01);
  1014d1:	6a 61                	push   $0x61
  1014d3:	89 f3                	mov    %esi,%ebx
  1014d5:	e8 a7 13 00 00       	call   102881 <inb>
  1014da:	83 e0 fc             	and    $0xfffffffc,%eax
  1014dd:	83 c8 01             	or     $0x1,%eax
  1014e0:	83 c4 08             	add    $0x8,%esp
  1014e3:	0f b6 c0             	movzbl %al,%eax
  1014e6:	50                   	push   %eax
  1014e7:	6a 61                	push   $0x61
  1014e9:	e8 ab 13 00 00       	call   102899 <outb>
	/*
	 * Setup CTC channel 2 for mode 0, (interrupt on terminal
	 * count mode), binary count. Set the latch register to 50ms
	 * (LSB then MSB) to begin countdown.
	 */
	outb(0x43, 0xb0);
  1014ee:	83 c4 08             	add    $0x8,%esp
  1014f1:	68 b0 00 00 00       	push   $0xb0
  1014f6:	6a 43                	push   $0x43
  1014f8:	e8 9c 13 00 00       	call   102899 <outb>
	outb(0x42, latch & 0xff);
  1014fd:	83 c4 08             	add    $0x8,%esp
  101500:	89 f8                	mov    %edi,%eax
  101502:	0f b6 c0             	movzbl %al,%eax
  101505:	50                   	push   %eax
  101506:	6a 42                	push   $0x42
  101508:	e8 8c 13 00 00       	call   102899 <outb>
	outb(0x42, latch >> 8);
  10150d:	83 c4 08             	add    $0x8,%esp
  101510:	89 f8                	mov    %edi,%eax
  101512:	0f b6 fc             	movzbl %ah,%edi
  101515:	57                   	push   %edi
  101516:	6a 42                	push   $0x42
  101518:	e8 7c 13 00 00       	call   102899 <outb>

	tsc = t1 = t2 = rdtsc();
  10151d:	e8 cd 12 00 00       	call   1027ef <rdtsc>
  101522:	89 44 24 30          	mov    %eax,0x30(%esp)
  101526:	89 54 24 34          	mov    %edx,0x34(%esp)

	pitcnt = 0;
	tscmax = 0;
	tscmin = ~(uint64_t) 0x0;
	while ((inb(0x61) & 0x20) == 0) {
  10152a:	83 c4 10             	add    $0x10,%esp
	tsc = t1 = t2 = rdtsc();
  10152d:	89 44 24 18          	mov    %eax,0x18(%esp)
  101531:	89 54 24 1c          	mov    %edx,0x1c(%esp)
	pitcnt = 0;
  101535:	bf 00 00 00 00       	mov    $0x0,%edi
	tscmax = 0;
  10153a:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  101541:	00 
  101542:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  101549:	00 
	tscmin = ~(uint64_t) 0x0;
  10154a:	c7 44 24 08 ff ff ff 	movl   $0xffffffff,0x8(%esp)
  101551:	ff 
  101552:	c7 44 24 0c ff ff ff 	movl   $0xffffffff,0xc(%esp)
  101559:	ff 
	while ((inb(0x61) & 0x20) == 0) {
  10155a:	eb 13                	jmp    10156f <tsc_calibrate+0xb8>
		delta = t2 - tsc;
		tsc = t2;
		if (delta < tscmin)
			tscmin = delta;
		if (delta > tscmax)
			tscmax = delta;
  10155c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  101560:	89 5c 24 14          	mov    %ebx,0x14(%esp)
		pitcnt++;
  101564:	83 c7 01             	add    $0x1,%edi
		tsc = t2;
  101567:	89 44 24 18          	mov    %eax,0x18(%esp)
  10156b:	89 54 24 1c          	mov    %edx,0x1c(%esp)
	while ((inb(0x61) & 0x20) == 0) {
  10156f:	83 ec 0c             	sub    $0xc,%esp
  101572:	6a 61                	push   $0x61
  101574:	89 f3                	mov    %esi,%ebx
  101576:	e8 06 13 00 00       	call   102881 <inb>
  10157b:	83 c4 10             	add    $0x10,%esp
  10157e:	a8 20                	test   $0x20,%al
  101580:	75 39                	jne    1015bb <tsc_calibrate+0x104>
		t2 = rdtsc();
  101582:	89 f3                	mov    %esi,%ebx
  101584:	e8 66 12 00 00       	call   1027ef <rdtsc>
		delta = t2 - tsc;
  101589:	89 c1                	mov    %eax,%ecx
  10158b:	89 d3                	mov    %edx,%ebx
  10158d:	2b 4c 24 18          	sub    0x18(%esp),%ecx
  101591:	1b 5c 24 1c          	sbb    0x1c(%esp),%ebx
		if (delta < tscmin)
  101595:	39 5c 24 0c          	cmp    %ebx,0xc(%esp)
  101599:	77 08                	ja     1015a3 <tsc_calibrate+0xec>
  10159b:	72 0e                	jb     1015ab <tsc_calibrate+0xf4>
  10159d:	39 4c 24 08          	cmp    %ecx,0x8(%esp)
  1015a1:	76 08                	jbe    1015ab <tsc_calibrate+0xf4>
			tscmin = delta;
  1015a3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1015a7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
		if (delta > tscmax)
  1015ab:	39 5c 24 14          	cmp    %ebx,0x14(%esp)
  1015af:	72 ab                	jb     10155c <tsc_calibrate+0xa5>
  1015b1:	77 b1                	ja     101564 <tsc_calibrate+0xad>
  1015b3:	39 4c 24 10          	cmp    %ecx,0x10(%esp)
  1015b7:	73 ab                	jae    101564 <tsc_calibrate+0xad>
  1015b9:	eb a1                	jmp    10155c <tsc_calibrate+0xa5>
	 * times, then we have been hit by a massive SMI
	 *
	 * If the maximum is 10 times larger than the minimum,
	 * then we got hit by an SMI as well.
	 */
	KERN_DEBUG("pitcnt=%u, tscmin=%llu, tscmax=%llu\n",
  1015bb:	ff 74 24 14          	pushl  0x14(%esp)
  1015bf:	ff 74 24 14          	pushl  0x14(%esp)
  1015c3:	ff 74 24 14          	pushl  0x14(%esp)
  1015c7:	ff 74 24 14          	pushl  0x14(%esp)
  1015cb:	57                   	push   %edi
  1015cc:	8d 86 08 ad ff ff    	lea    -0x52f8(%esi),%eax
  1015d2:	50                   	push   %eax
  1015d3:	6a 3a                	push   $0x3a
  1015d5:	8d 86 2d ad ff ff    	lea    -0x52d3(%esi),%eax
  1015db:	50                   	push   %eax
  1015dc:	e8 82 08 00 00       	call   101e63 <debug_normal>
		   pitcnt, tscmin, tscmax);
	if (pitcnt < loopmin || tscmax > 10 * tscmin)
  1015e1:	83 c4 20             	add    $0x20,%esp
  1015e4:	39 ef                	cmp    %ebp,%edi
  1015e6:	7c 55                	jl     10163d <tsc_calibrate+0x186>
  1015e8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  1015ec:	8b 6c 24 0c          	mov    0xc(%esp),%ebp
  1015f0:	6b cd 0a             	imul   $0xa,%ebp,%ecx
  1015f3:	b8 0a 00 00 00       	mov    $0xa,%eax
  1015f8:	f7 e7                	mul    %edi
  1015fa:	01 ca                	add    %ecx,%edx
  1015fc:	8b 7c 24 10          	mov    0x10(%esp),%edi
  101600:	8b 6c 24 14          	mov    0x14(%esp),%ebp
  101604:	39 ea                	cmp    %ebp,%edx
  101606:	72 41                	jb     101649 <tsc_calibrate+0x192>
  101608:	77 04                	ja     10160e <tsc_calibrate+0x157>
  10160a:	39 f8                	cmp    %edi,%eax
  10160c:	72 3b                	jb     101649 <tsc_calibrate+0x192>
		return ~(uint64_t) 0x0;

	/* Calculate the PIT value */
	delta = t2 - t1;
  10160e:	8b 44 24 18          	mov    0x18(%esp),%eax
  101612:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  101616:	2b 44 24 20          	sub    0x20(%esp),%eax
  10161a:	1b 54 24 24          	sbb    0x24(%esp),%edx
	return delta / ms;
  10161e:	8b 4c 24 2c          	mov    0x2c(%esp),%ecx
  101622:	bb 00 00 00 00       	mov    $0x0,%ebx
  101627:	53                   	push   %ebx
  101628:	51                   	push   %ecx
  101629:	52                   	push   %edx
  10162a:	50                   	push   %eax
  10162b:	89 f3                	mov    %esi,%ebx
  10162d:	e8 1e 42 00 00       	call   105850 <__udivdi3>
  101632:	83 c4 10             	add    $0x10,%esp
}
  101635:	83 c4 3c             	add    $0x3c,%esp
  101638:	5b                   	pop    %ebx
  101639:	5e                   	pop    %esi
  10163a:	5f                   	pop    %edi
  10163b:	5d                   	pop    %ebp
  10163c:	c3                   	ret    
		return ~(uint64_t) 0x0;
  10163d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101642:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  101647:	eb ec                	jmp    101635 <tsc_calibrate+0x17e>
  101649:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10164e:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  101653:	eb e0                	jmp    101635 <tsc_calibrate+0x17e>

00101655 <tsc_init>:

int
tsc_init(void)
{
  101655:	55                   	push   %ebp
  101656:	57                   	push   %edi
  101657:	56                   	push   %esi
  101658:	53                   	push   %ebx
  101659:	83 ec 0c             	sub    $0xc,%esp
  10165c:	e8 ae ec ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  101661:	81 c3 9f 99 00 00    	add    $0x999f,%ebx
	uint64_t ret;
	int i;

	timer_hw_init();
  101667:	e8 13 fe ff ff       	call   10147f <timer_hw_init>

	tsc_per_ms = 0;
  10166c:	c7 c0 a0 9e 16 00    	mov    $0x169ea0,%eax
  101672:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  101678:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

	/*
	 * XXX: If TSC calibration fails frequently, try to increase the
	 *      upperbound of loop condition, e.g. alternating 3 to 10.
	 */
	for (i = 0; i < 10; i++) {
  10167f:	bd 00 00 00 00       	mov    $0x0,%ebp
  101684:	83 fd 09             	cmp    $0x9,%ebp
  101687:	7f 3e                	jg     1016c7 <tsc_init+0x72>
		ret = tsc_calibrate(CAL_LATCH, CAL_MS, CAL_PIT_LOOPS);
  101689:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  10168e:	ba 0a 00 00 00       	mov    $0xa,%edx
  101693:	b8 9b 2e 00 00       	mov    $0x2e9b,%eax
  101698:	e8 1a fe ff ff       	call   1014b7 <tsc_calibrate>
  10169d:	89 c6                	mov    %eax,%esi
  10169f:	89 d7                	mov    %edx,%edi
		if (ret != ~(uint64_t) 0x0)
  1016a1:	f7 d0                	not    %eax
  1016a3:	f7 d2                	not    %edx
  1016a5:	09 c2                	or     %eax,%edx
  1016a7:	75 1e                	jne    1016c7 <tsc_init+0x72>
			break;
		KERN_DEBUG("[%d] Retry to calibrate TSC.\n", i+1);
  1016a9:	83 c5 01             	add    $0x1,%ebp
  1016ac:	55                   	push   %ebp
  1016ad:	8d 83 3c ad ff ff    	lea    -0x52c4(%ebx),%eax
  1016b3:	50                   	push   %eax
  1016b4:	6a 55                	push   $0x55
  1016b6:	8d 83 2d ad ff ff    	lea    -0x52d3(%ebx),%eax
  1016bc:	50                   	push   %eax
  1016bd:	e8 a1 07 00 00       	call   101e63 <debug_normal>
	for (i = 0; i < 10; i++) {
  1016c2:	83 c4 10             	add    $0x10,%esp
  1016c5:	eb bd                	jmp    101684 <tsc_init+0x2f>
	}

	if (ret == ~(uint64_t) 0x0) {
  1016c7:	89 fa                	mov    %edi,%edx
  1016c9:	f7 d2                	not    %edx
  1016cb:	89 f0                	mov    %esi,%eax
  1016cd:	f7 d0                	not    %eax
  1016cf:	09 c2                	or     %eax,%edx
  1016d1:	74 50                	je     101723 <tsc_init+0xce>
		tsc_per_ms = 1000000;

		timer_hw_init();
		return 1;
	} else {
		tsc_per_ms = ret;
  1016d3:	c7 c0 a0 9e 16 00    	mov    $0x169ea0,%eax
  1016d9:	89 30                	mov    %esi,(%eax)
  1016db:	89 78 04             	mov    %edi,0x4(%eax)
		KERN_DEBUG("TSC freq = %llu Hz.\n", tsc_per_ms*1000);
  1016de:	8b 38                	mov    (%eax),%edi
  1016e0:	8b 68 04             	mov    0x4(%eax),%ebp
  1016e3:	83 ec 0c             	sub    $0xc,%esp
  1016e6:	69 cd e8 03 00 00    	imul   $0x3e8,%ebp,%ecx
  1016ec:	be e8 03 00 00       	mov    $0x3e8,%esi
  1016f1:	89 f8                	mov    %edi,%eax
  1016f3:	f7 e6                	mul    %esi
  1016f5:	01 ca                	add    %ecx,%edx
  1016f7:	52                   	push   %edx
  1016f8:	50                   	push   %eax
  1016f9:	8d 83 8d ad ff ff    	lea    -0x5273(%ebx),%eax
  1016ff:	50                   	push   %eax
  101700:	6a 61                	push   $0x61
  101702:	8d 83 2d ad ff ff    	lea    -0x52d3(%ebx),%eax
  101708:	50                   	push   %eax
  101709:	e8 55 07 00 00       	call   101e63 <debug_normal>

		timer_hw_init();
  10170e:	83 c4 20             	add    $0x20,%esp
  101711:	e8 69 fd ff ff       	call   10147f <timer_hw_init>
		return 0;
  101716:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  10171b:	83 c4 0c             	add    $0xc,%esp
  10171e:	5b                   	pop    %ebx
  10171f:	5e                   	pop    %esi
  101720:	5f                   	pop    %edi
  101721:	5d                   	pop    %ebp
  101722:	c3                   	ret    
		KERN_DEBUG("TSC calibration failed.\n");
  101723:	83 ec 04             	sub    $0x4,%esp
  101726:	8d 83 5a ad ff ff    	lea    -0x52a6(%ebx),%eax
  10172c:	50                   	push   %eax
  10172d:	6a 59                	push   $0x59
  10172f:	8d b3 2d ad ff ff    	lea    -0x52d3(%ebx),%esi
  101735:	56                   	push   %esi
  101736:	e8 28 07 00 00       	call   101e63 <debug_normal>
		KERN_DEBUG("Assume TSC freq = 1 GHz.\n");
  10173b:	83 c4 0c             	add    $0xc,%esp
  10173e:	8d 83 73 ad ff ff    	lea    -0x528d(%ebx),%eax
  101744:	50                   	push   %eax
  101745:	6a 5a                	push   $0x5a
  101747:	56                   	push   %esi
  101748:	e8 16 07 00 00       	call   101e63 <debug_normal>
		tsc_per_ms = 1000000;
  10174d:	c7 c0 a0 9e 16 00    	mov    $0x169ea0,%eax
  101753:	c7 00 40 42 0f 00    	movl   $0xf4240,(%eax)
  101759:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
		timer_hw_init();
  101760:	e8 1a fd ff ff       	call   10147f <timer_hw_init>
		return 1;
  101765:	83 c4 10             	add    $0x10,%esp
  101768:	b8 01 00 00 00       	mov    $0x1,%eax
  10176d:	eb ac                	jmp    10171b <tsc_init+0xc6>

0010176f <delay>:
/*
 * Wait for ms millisecond.
 */
void
delay(uint32_t ms)
{
  10176f:	55                   	push   %ebp
  101770:	57                   	push   %edi
  101771:	56                   	push   %esi
  101772:	53                   	push   %ebx
  101773:	83 ec 1c             	sub    $0x1c,%esp
  101776:	e8 94 eb ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  10177b:	81 c3 85 98 00 00    	add    $0x9885,%ebx
  101781:	8b 6c 24 30          	mov    0x30(%esp),%ebp
	volatile uint64_t ticks = tsc_per_ms * ms;
  101785:	c7 c0 a0 9e 16 00    	mov    $0x169ea0,%eax
  10178b:	8b 30                	mov    (%eax),%esi
  10178d:	8b 78 04             	mov    0x4(%eax),%edi
  101790:	89 f9                	mov    %edi,%ecx
  101792:	0f af cd             	imul   %ebp,%ecx
  101795:	89 e8                	mov    %ebp,%eax
  101797:	f7 e6                	mul    %esi
  101799:	01 ca                	add    %ecx,%edx
  10179b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10179f:	89 54 24 0c          	mov    %edx,0xc(%esp)
	volatile uint64_t start = rdtsc();
  1017a3:	e8 47 10 00 00       	call   1027ef <rdtsc>
  1017a8:	89 04 24             	mov    %eax,(%esp)
  1017ab:	89 54 24 04          	mov    %edx,0x4(%esp)
	while (rdtsc() < start + ticks);
  1017af:	e8 3b 10 00 00       	call   1027ef <rdtsc>
  1017b4:	89 c5                	mov    %eax,%ebp
  1017b6:	89 d1                	mov    %edx,%ecx
  1017b8:	8b 04 24             	mov    (%esp),%eax
  1017bb:	8b 54 24 04          	mov    0x4(%esp),%edx
  1017bf:	8b 74 24 08          	mov    0x8(%esp),%esi
  1017c3:	8b 7c 24 0c          	mov    0xc(%esp),%edi
  1017c7:	01 f0                	add    %esi,%eax
  1017c9:	11 fa                	adc    %edi,%edx
  1017cb:	39 d1                	cmp    %edx,%ecx
  1017cd:	72 e0                	jb     1017af <delay+0x40>
  1017cf:	77 04                	ja     1017d5 <delay+0x66>
  1017d1:	39 c5                	cmp    %eax,%ebp
  1017d3:	72 da                	jb     1017af <delay+0x40>
}
  1017d5:	83 c4 1c             	add    $0x1c,%esp
  1017d8:	5b                   	pop    %ebx
  1017d9:	5e                   	pop    %esi
  1017da:	5f                   	pop    %edi
  1017db:	5d                   	pop    %ebp
  1017dc:	c3                   	ret    

001017dd <udelay>:
/*
 * Wait for us microsecond.
 */
void
udelay(uint32_t us)
{
  1017dd:	55                   	push   %ebp
  1017de:	57                   	push   %edi
  1017df:	56                   	push   %esi
  1017e0:	53                   	push   %ebx
  1017e1:	83 ec 1c             	sub    $0x1c,%esp
  1017e4:	e8 26 eb ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  1017e9:	81 c3 17 98 00 00    	add    $0x9817,%ebx
  1017ef:	8b 74 24 30          	mov    0x30(%esp),%esi
    volatile uint64_t ticks = tsc_per_ms / 1000 * us;
  1017f3:	c7 c0 a0 9e 16 00    	mov    $0x169ea0,%eax
  1017f9:	8b 50 04             	mov    0x4(%eax),%edx
  1017fc:	8b 00                	mov    (%eax),%eax
  1017fe:	6a 00                	push   $0x0
  101800:	68 e8 03 00 00       	push   $0x3e8
  101805:	52                   	push   %edx
  101806:	50                   	push   %eax
  101807:	e8 44 40 00 00       	call   105850 <__udivdi3>
  10180c:	83 c4 10             	add    $0x10,%esp
  10180f:	89 d1                	mov    %edx,%ecx
  101811:	0f af ce             	imul   %esi,%ecx
  101814:	f7 e6                	mul    %esi
  101816:	01 ca                	add    %ecx,%edx
  101818:	89 44 24 08          	mov    %eax,0x8(%esp)
  10181c:	89 54 24 0c          	mov    %edx,0xc(%esp)
    volatile uint64_t start = rdtsc();
  101820:	e8 ca 0f 00 00       	call   1027ef <rdtsc>
  101825:	89 04 24             	mov    %eax,(%esp)
  101828:	89 54 24 04          	mov    %edx,0x4(%esp)
    while (rdtsc() < start + ticks);
  10182c:	e8 be 0f 00 00       	call   1027ef <rdtsc>
  101831:	89 c5                	mov    %eax,%ebp
  101833:	89 d1                	mov    %edx,%ecx
  101835:	8b 04 24             	mov    (%esp),%eax
  101838:	8b 54 24 04          	mov    0x4(%esp),%edx
  10183c:	8b 74 24 08          	mov    0x8(%esp),%esi
  101840:	8b 7c 24 0c          	mov    0xc(%esp),%edi
  101844:	01 f0                	add    %esi,%eax
  101846:	11 fa                	adc    %edi,%edx
  101848:	39 d1                	cmp    %edx,%ecx
  10184a:	72 e0                	jb     10182c <udelay+0x4f>
  10184c:	77 04                	ja     101852 <udelay+0x75>
  10184e:	39 c5                	cmp    %eax,%ebp
  101850:	72 da                	jb     10182c <udelay+0x4f>
}
  101852:	83 c4 1c             	add    $0x1c,%esp
  101855:	5b                   	pop    %ebx
  101856:	5e                   	pop    %esi
  101857:	5f                   	pop    %edi
  101858:	5d                   	pop    %ebp
  101859:	c3                   	ret    
  10185a:	66 90                	xchg   %ax,%ax
  10185c:	66 90                	xchg   %ax,%ax
  10185e:	66 90                	xchg   %ax,%ax

00101860 <Xdivide>:
	jmp _alltraps

.text

/* exceptions  */
TRAPHANDLER_NOEC(Xdivide,	T_DIVIDE)
  101860:	6a 00                	push   $0x0
  101862:	6a 00                	push   $0x0
  101864:	e9 17 01 00 00       	jmp    101980 <_alltraps>
  101869:	90                   	nop

0010186a <Xdebug>:
TRAPHANDLER_NOEC(Xdebug,	T_DEBUG)
  10186a:	6a 00                	push   $0x0
  10186c:	6a 01                	push   $0x1
  10186e:	e9 0d 01 00 00       	jmp    101980 <_alltraps>
  101873:	90                   	nop

00101874 <Xnmi>:
TRAPHANDLER_NOEC(Xnmi,		T_NMI)
  101874:	6a 00                	push   $0x0
  101876:	6a 02                	push   $0x2
  101878:	e9 03 01 00 00       	jmp    101980 <_alltraps>
  10187d:	90                   	nop

0010187e <Xbrkpt>:
TRAPHANDLER_NOEC(Xbrkpt,	T_BRKPT)
  10187e:	6a 00                	push   $0x0
  101880:	6a 03                	push   $0x3
  101882:	e9 f9 00 00 00       	jmp    101980 <_alltraps>
  101887:	90                   	nop

00101888 <Xoflow>:
TRAPHANDLER_NOEC(Xoflow,	T_OFLOW)
  101888:	6a 00                	push   $0x0
  10188a:	6a 04                	push   $0x4
  10188c:	e9 ef 00 00 00       	jmp    101980 <_alltraps>
  101891:	90                   	nop

00101892 <Xbound>:
TRAPHANDLER_NOEC(Xbound,	T_BOUND)
  101892:	6a 00                	push   $0x0
  101894:	6a 05                	push   $0x5
  101896:	e9 e5 00 00 00       	jmp    101980 <_alltraps>
  10189b:	90                   	nop

0010189c <Xillop>:
TRAPHANDLER_NOEC(Xillop,	T_ILLOP)
  10189c:	6a 00                	push   $0x0
  10189e:	6a 06                	push   $0x6
  1018a0:	e9 db 00 00 00       	jmp    101980 <_alltraps>
  1018a5:	90                   	nop

001018a6 <Xdevice>:
TRAPHANDLER_NOEC(Xdevice,	T_DEVICE)
  1018a6:	6a 00                	push   $0x0
  1018a8:	6a 07                	push   $0x7
  1018aa:	e9 d1 00 00 00       	jmp    101980 <_alltraps>
  1018af:	90                   	nop

001018b0 <Xdblflt>:
TRAPHANDLER     (Xdblflt,	T_DBLFLT)
  1018b0:	6a 08                	push   $0x8
  1018b2:	e9 c9 00 00 00       	jmp    101980 <_alltraps>
  1018b7:	90                   	nop

001018b8 <Xcoproc>:
TRAPHANDLER_NOEC(Xcoproc,	T_COPROC)
  1018b8:	6a 00                	push   $0x0
  1018ba:	6a 09                	push   $0x9
  1018bc:	e9 bf 00 00 00       	jmp    101980 <_alltraps>
  1018c1:	90                   	nop

001018c2 <Xtss>:
TRAPHANDLER     (Xtss,		T_TSS)
  1018c2:	6a 0a                	push   $0xa
  1018c4:	e9 b7 00 00 00       	jmp    101980 <_alltraps>
  1018c9:	90                   	nop

001018ca <Xsegnp>:
TRAPHANDLER     (Xsegnp,	T_SEGNP)
  1018ca:	6a 0b                	push   $0xb
  1018cc:	e9 af 00 00 00       	jmp    101980 <_alltraps>
  1018d1:	90                   	nop

001018d2 <Xstack>:
TRAPHANDLER     (Xstack,	T_STACK)
  1018d2:	6a 0c                	push   $0xc
  1018d4:	e9 a7 00 00 00       	jmp    101980 <_alltraps>
  1018d9:	90                   	nop

001018da <Xgpflt>:
TRAPHANDLER     (Xgpflt,	T_GPFLT)
  1018da:	6a 0d                	push   $0xd
  1018dc:	e9 9f 00 00 00       	jmp    101980 <_alltraps>
  1018e1:	90                   	nop

001018e2 <Xpgflt>:
TRAPHANDLER     (Xpgflt,	T_PGFLT)
  1018e2:	6a 0e                	push   $0xe
  1018e4:	e9 97 00 00 00       	jmp    101980 <_alltraps>
  1018e9:	90                   	nop

001018ea <Xres>:
TRAPHANDLER_NOEC(Xres,		T_RES)
  1018ea:	6a 00                	push   $0x0
  1018ec:	6a 0f                	push   $0xf
  1018ee:	e9 8d 00 00 00       	jmp    101980 <_alltraps>
  1018f3:	90                   	nop

001018f4 <Xfperr>:
TRAPHANDLER_NOEC(Xfperr,	T_FPERR)
  1018f4:	6a 00                	push   $0x0
  1018f6:	6a 10                	push   $0x10
  1018f8:	e9 83 00 00 00       	jmp    101980 <_alltraps>
  1018fd:	90                   	nop

001018fe <Xalign>:
TRAPHANDLER     (Xalign,	T_ALIGN)
  1018fe:	6a 11                	push   $0x11
  101900:	eb 7e                	jmp    101980 <_alltraps>

00101902 <Xmchk>:
TRAPHANDLER_NOEC(Xmchk,		T_MCHK)
  101902:	6a 00                	push   $0x0
  101904:	6a 12                	push   $0x12
  101906:	eb 78                	jmp    101980 <_alltraps>

00101908 <Xirq_timer>:

/* ISA interrupts  */
TRAPHANDLER_NOEC(Xirq_timer,	T_IRQ0 + IRQ_TIMER)
  101908:	6a 00                	push   $0x0
  10190a:	6a 20                	push   $0x20
  10190c:	eb 72                	jmp    101980 <_alltraps>

0010190e <Xirq_kbd>:
TRAPHANDLER_NOEC(Xirq_kbd,	T_IRQ0 + IRQ_KBD)
  10190e:	6a 00                	push   $0x0
  101910:	6a 21                	push   $0x21
  101912:	eb 6c                	jmp    101980 <_alltraps>

00101914 <Xirq_slave>:
TRAPHANDLER_NOEC(Xirq_slave,	T_IRQ0 + IRQ_SLAVE)
  101914:	6a 00                	push   $0x0
  101916:	6a 22                	push   $0x22
  101918:	eb 66                	jmp    101980 <_alltraps>

0010191a <Xirq_serial2>:
TRAPHANDLER_NOEC(Xirq_serial2,	T_IRQ0 + IRQ_SERIAL24)
  10191a:	6a 00                	push   $0x0
  10191c:	6a 23                	push   $0x23
  10191e:	eb 60                	jmp    101980 <_alltraps>

00101920 <Xirq_serial1>:
TRAPHANDLER_NOEC(Xirq_serial1,	T_IRQ0 + IRQ_SERIAL13)
  101920:	6a 00                	push   $0x0
  101922:	6a 24                	push   $0x24
  101924:	eb 5a                	jmp    101980 <_alltraps>

00101926 <Xirq_lpt>:
TRAPHANDLER_NOEC(Xirq_lpt,	T_IRQ0 + IRQ_LPT2)
  101926:	6a 00                	push   $0x0
  101928:	6a 25                	push   $0x25
  10192a:	eb 54                	jmp    101980 <_alltraps>

0010192c <Xirq_floppy>:
TRAPHANDLER_NOEC(Xirq_floppy,	T_IRQ0 + IRQ_FLOPPY)
  10192c:	6a 00                	push   $0x0
  10192e:	6a 26                	push   $0x26
  101930:	eb 4e                	jmp    101980 <_alltraps>

00101932 <Xirq_spurious>:
TRAPHANDLER_NOEC(Xirq_spurious,	T_IRQ0 + IRQ_SPURIOUS)
  101932:	6a 00                	push   $0x0
  101934:	6a 27                	push   $0x27
  101936:	eb 48                	jmp    101980 <_alltraps>

00101938 <Xirq_rtc>:
TRAPHANDLER_NOEC(Xirq_rtc,	T_IRQ0 + IRQ_RTC)
  101938:	6a 00                	push   $0x0
  10193a:	6a 28                	push   $0x28
  10193c:	eb 42                	jmp    101980 <_alltraps>

0010193e <Xirq9>:
TRAPHANDLER_NOEC(Xirq9,		T_IRQ0 + 9)
  10193e:	6a 00                	push   $0x0
  101940:	6a 29                	push   $0x29
  101942:	eb 3c                	jmp    101980 <_alltraps>

00101944 <Xirq10>:
TRAPHANDLER_NOEC(Xirq10,	T_IRQ0 + 10)
  101944:	6a 00                	push   $0x0
  101946:	6a 2a                	push   $0x2a
  101948:	eb 36                	jmp    101980 <_alltraps>

0010194a <Xirq11>:
TRAPHANDLER_NOEC(Xirq11,	T_IRQ0 + 11)
  10194a:	6a 00                	push   $0x0
  10194c:	6a 2b                	push   $0x2b
  10194e:	eb 30                	jmp    101980 <_alltraps>

00101950 <Xirq_mouse>:
TRAPHANDLER_NOEC(Xirq_mouse,	T_IRQ0 + IRQ_MOUSE)
  101950:	6a 00                	push   $0x0
  101952:	6a 2c                	push   $0x2c
  101954:	eb 2a                	jmp    101980 <_alltraps>

00101956 <Xirq_coproc>:
TRAPHANDLER_NOEC(Xirq_coproc,	T_IRQ0 + IRQ_COPROCESSOR)
  101956:	6a 00                	push   $0x0
  101958:	6a 2d                	push   $0x2d
  10195a:	eb 24                	jmp    101980 <_alltraps>

0010195c <Xirq_ide1>:
TRAPHANDLER_NOEC(Xirq_ide1,	T_IRQ0 + IRQ_IDE1)
  10195c:	6a 00                	push   $0x0
  10195e:	6a 2e                	push   $0x2e
  101960:	eb 1e                	jmp    101980 <_alltraps>

00101962 <Xirq_ide2>:
TRAPHANDLER_NOEC(Xirq_ide2,	T_IRQ0 + IRQ_IDE2)
  101962:	6a 00                	push   $0x0
  101964:	6a 2f                	push   $0x2f
  101966:	eb 18                	jmp    101980 <_alltraps>

00101968 <Xsyscall>:

/* syscall */
TRAPHANDLER_NOEC(Xsyscall,	T_SYSCALL)
  101968:	6a 00                	push   $0x0
  10196a:	6a 30                	push   $0x30
  10196c:	eb 12                	jmp    101980 <_alltraps>

0010196e <Xdefault>:

/* default */
TRAPHANDLER     (Xdefault,	T_DEFAULT)
  10196e:	68 fe 00 00 00       	push   $0xfe
  101973:	eb 0b                	jmp    101980 <_alltraps>
  101975:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101980 <_alltraps>:

.globl	_alltraps
.type	_alltraps,@function
.p2align 4, 0x90		/* 16-byte alignment, nop filled */
_alltraps:
	cli			# make sure there is no nested trap
  101980:	fa                   	cli    

	cld
  101981:	fc                   	cld    

	# -------------
	# build context
	# -------------
	
	pushl %ds		
  101982:	1e                   	push   %ds
	pushl %es
  101983:	06                   	push   %es
	pushal
  101984:	60                   	pusha  

	# -------------

	movl $CPU_GDT_KDATA,%eax # load kernel's data segment
  101985:	b8 10 00 00 00       	mov    $0x10,%eax
	movw %ax,%ds
  10198a:	8e d8                	mov    %eax,%ds
	movw %ax,%es
  10198c:	8e c0                	mov    %eax,%es

	pushl %esp		# pass pointer to this trapframe
  10198e:	54                   	push   %esp
	call trap		# and call trap (does not return)
  10198f:	e8 9c 3e 00 00       	call   105830 <trap>

1:	hlt			# should never get here; just spin...
  101994:	f4                   	hlt    
  101995:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001019a0 <trap_return>:
  }
}

static void
pmmap_merge(pmmap_list_type *pmmap_list_p)
{
  1019a0:	57                   	push   %edi
  1019a1:	56                   	push   %esi
  1019a2:	53                   	push   %ebx
  1019a3:	83 ec 10             	sub    $0x10,%esp
  1019a6:	e8 64 e9 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  1019ab:	81 c3 55 96 00 00    	add    $0x9655,%ebx
  1019b1:	89 c7                	mov    %eax,%edi
	struct pmmap *slot, *next_slot;
	struct pmmap *last_slot[4] = { NULL, NULL, NULL, NULL };
  1019b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1019ba:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1019c1:	00 
  1019c2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1019c9:	00 
  1019ca:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1019d1:	00 
	int sublist_nr;

	/*
	 * Step 1: Merge overlaped entries in pmmap_list.
	 */
	SLIST_FOREACH(slot, pmmap_list_p, next) {
  1019d2:	8b 30                	mov    (%eax),%esi
  1019d4:	eb 03                	jmp    1019d9 <trap_return+0x39>
  1019d6:	8b 76 0c             	mov    0xc(%esi),%esi
  1019d9:	85 f6                	test   %esi,%esi
  1019db:	74 39                	je     101a16 <trap_return+0x76>
		if ((next_slot = SLIST_NEXT(slot, next)) == NULL)
  1019dd:	8b 46 0c             	mov    0xc(%esi),%eax
  1019e0:	85 c0                	test   %eax,%eax
  1019e2:	74 32                	je     101a16 <trap_return+0x76>
			break;
		if (slot->start <= next_slot->start &&
  1019e4:	8b 10                	mov    (%eax),%edx
  1019e6:	39 16                	cmp    %edx,(%esi)
  1019e8:	77 ec                	ja     1019d6 <trap_return+0x36>
		    slot->end >= next_slot->start &&
  1019ea:	8b 4e 04             	mov    0x4(%esi),%ecx
		if (slot->start <= next_slot->start &&
  1019ed:	39 ca                	cmp    %ecx,%edx
  1019ef:	77 e5                	ja     1019d6 <trap_return+0x36>
		    slot->end >= next_slot->start &&
  1019f1:	8b 50 08             	mov    0x8(%eax),%edx
  1019f4:	39 56 08             	cmp    %edx,0x8(%esi)
  1019f7:	75 dd                	jne    1019d6 <trap_return+0x36>
		    slot->type == next_slot->type) {
			slot->end = max(slot->end, next_slot->end);
  1019f9:	83 ec 08             	sub    $0x8,%esp
  1019fc:	ff 70 04             	pushl  0x4(%eax)
  1019ff:	51                   	push   %ecx
  101a00:	e8 7d 0d 00 00       	call   102782 <max>
  101a05:	89 46 04             	mov    %eax,0x4(%esi)
			SLIST_REMOVE_AFTER(slot, next);
  101a08:	8b 46 0c             	mov    0xc(%esi),%eax
  101a0b:	8b 40 0c             	mov    0xc(%eax),%eax
  101a0e:	89 46 0c             	mov    %eax,0xc(%esi)
  101a11:	83 c4 10             	add    $0x10,%esp
  101a14:	eb c0                	jmp    1019d6 <trap_return+0x36>

	/*
	 * Step 2: Create the specfic lists: pmmap_usable, pmmap_resv,
	 *         pmmap_acpi, pmmap_nvs.
	 */
	SLIST_FOREACH(slot, pmmap_list_p, next) {
  101a16:	8b 37                	mov    (%edi),%esi
  101a18:	eb 41                	jmp    101a5b <trap_return+0xbb>
		sublist_nr = PMMAP_SUBLIST_NR(slot->type); //get memory type number
    	KERN_ASSERT(sublist_nr != -1);
  101a1a:	8d 83 a2 ad ff ff    	lea    -0x525e(%ebx),%eax
  101a20:	50                   	push   %eax
  101a21:	8d 83 b3 ad ff ff    	lea    -0x524d(%ebx),%eax
  101a27:	50                   	push   %eax
  101a28:	6a 63                	push   $0x63
  101a2a:	8d 83 d0 ad ff ff    	lea    -0x5230(%ebx),%eax
  101a30:	50                   	push   %eax
  101a31:	e8 66 04 00 00       	call   101e9c <debug_panic>
  101a36:	83 c4 10             	add    $0x10,%esp
		sublist_nr = PMMAP_SUBLIST_NR(slot->type); //get memory type number
  101a39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101a3e:	eb 05                	jmp    101a45 <trap_return+0xa5>
  101a40:	b8 00 00 00 00       	mov    $0x0,%eax
		if (last_slot[sublist_nr] != NULL)
  101a45:	8b 14 84             	mov    (%esp,%eax,4),%edx
  101a48:	85 d2                	test   %edx,%edx
  101a4a:	74 3f                	je     101a8b <trap_return+0xeb>
			SLIST_INSERT_AFTER(last_slot[sublist_nr], slot,
  101a4c:	8b 4a 10             	mov    0x10(%edx),%ecx
  101a4f:	89 4e 10             	mov    %ecx,0x10(%esi)
  101a52:	89 72 10             	mov    %esi,0x10(%edx)
					   type_next);
		else
			SLIST_INSERT_HEAD(&pmmap_sublist[sublist_nr], slot,
					  type_next);
		last_slot[sublist_nr] = slot;
  101a55:	89 34 84             	mov    %esi,(%esp,%eax,4)
	SLIST_FOREACH(slot, pmmap_list_p, next) {
  101a58:	8b 76 0c             	mov    0xc(%esi),%esi
  101a5b:	85 f6                	test   %esi,%esi
  101a5d:	74 3d                	je     101a9c <trap_return+0xfc>
		sublist_nr = PMMAP_SUBLIST_NR(slot->type); //get memory type number
  101a5f:	8b 46 08             	mov    0x8(%esi),%eax
  101a62:	83 f8 01             	cmp    $0x1,%eax
  101a65:	74 d9                	je     101a40 <trap_return+0xa0>
  101a67:	83 f8 02             	cmp    $0x2,%eax
  101a6a:	74 11                	je     101a7d <trap_return+0xdd>
  101a6c:	83 f8 03             	cmp    $0x3,%eax
  101a6f:	74 13                	je     101a84 <trap_return+0xe4>
  101a71:	83 f8 04             	cmp    $0x4,%eax
  101a74:	75 a4                	jne    101a1a <trap_return+0x7a>
  101a76:	b8 03 00 00 00       	mov    $0x3,%eax
  101a7b:	eb c8                	jmp    101a45 <trap_return+0xa5>
  101a7d:	b8 01 00 00 00       	mov    $0x1,%eax
  101a82:	eb c1                	jmp    101a45 <trap_return+0xa5>
  101a84:	b8 02 00 00 00       	mov    $0x2,%eax
  101a89:	eb ba                	jmp    101a45 <trap_return+0xa5>
			SLIST_INSERT_HEAD(&pmmap_sublist[sublist_nr], slot,
  101a8b:	8d 93 20 d4 01 00    	lea    0x1d420(%ebx),%edx
  101a91:	8b 0c 82             	mov    (%edx,%eax,4),%ecx
  101a94:	89 4e 10             	mov    %ecx,0x10(%esi)
  101a97:	89 34 82             	mov    %esi,(%edx,%eax,4)
  101a9a:	eb b9                	jmp    101a55 <trap_return+0xb5>
	}

}
  101a9c:	83 c4 10             	add    $0x10,%esp
  101a9f:	5b                   	pop    %ebx
  101aa0:	5e                   	pop    %esi
  101aa1:	5f                   	pop    %edi
  101aa2:	c3                   	ret    

00101aa3 <pmmap_alloc_slot>:
{
  101aa3:	e8 d3 f9 ff ff       	call   10147b <__x86.get_pc_thunk.dx>
  101aa8:	81 c2 58 95 00 00    	add    $0x9558,%edx
	if (unlikely(pmmap_slots_next_free == 128))
  101aae:	8b 82 40 de 01 00    	mov    0x1de40(%edx),%eax
  101ab4:	3d 80 00 00 00       	cmp    $0x80,%eax
  101ab9:	74 1b                	je     101ad6 <pmmap_alloc_slot+0x33>
	return &pmmap_slots[pmmap_slots_next_free++];
  101abb:	8d 48 01             	lea    0x1(%eax),%ecx
  101abe:	89 8a 40 de 01 00    	mov    %ecx,0x1de40(%edx)
  101ac4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
  101ac7:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
  101ace:	8d 84 02 40 d4 01 00 	lea    0x1d440(%edx,%eax,1),%eax
  101ad5:	c3                   	ret    
		return NULL;
  101ad6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101adb:	c3                   	ret    

00101adc <pmmap_insert>:
{
  101adc:	55                   	push   %ebp
  101add:	57                   	push   %edi
  101ade:	56                   	push   %esi
  101adf:	53                   	push   %ebx
  101ae0:	83 ec 1c             	sub    $0x1c,%esp
  101ae3:	e8 27 e8 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  101ae8:	81 c3 18 95 00 00    	add    $0x9518,%ebx
  101aee:	89 c5                	mov    %eax,%ebp
  101af0:	89 d6                	mov    %edx,%esi
  101af2:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
	if ((free_slot = pmmap_alloc_slot()) == NULL)
  101af6:	e8 a8 ff ff ff       	call   101aa3 <pmmap_alloc_slot>
  101afb:	89 c7                	mov    %eax,%edi
  101afd:	85 c0                	test   %eax,%eax
  101aff:	74 29                	je     101b2a <pmmap_insert+0x4e>
	free_slot->start = start;
  101b01:	89 37                	mov    %esi,(%edi)
	free_slot->end = end;
  101b03:	8b 44 24 0c          	mov    0xc(%esp),%eax
  101b07:	89 47 04             	mov    %eax,0x4(%edi)
	free_slot->type = type;
  101b0a:	8b 44 24 30          	mov    0x30(%esp),%eax
  101b0e:	89 47 08             	mov    %eax,0x8(%edi)
	SLIST_FOREACH(slot, pmmap_list_p, next) {
  101b11:	8b 4d 00             	mov    0x0(%ebp),%ecx
  101b14:	89 c8                	mov    %ecx,%eax
	last_slot = NULL;
  101b16:	ba 00 00 00 00       	mov    $0x0,%edx
	SLIST_FOREACH(slot, pmmap_list_p, next) {
  101b1b:	85 c0                	test   %eax,%eax
  101b1d:	74 28                	je     101b47 <pmmap_insert+0x6b>
		if (start < slot->start)
  101b1f:	39 30                	cmp    %esi,(%eax)
  101b21:	77 24                	ja     101b47 <pmmap_insert+0x6b>
		last_slot = slot;
  101b23:	89 c2                	mov    %eax,%edx
	SLIST_FOREACH(slot, pmmap_list_p, next) {
  101b25:	8b 40 0c             	mov    0xc(%eax),%eax
  101b28:	eb f1                	jmp    101b1b <pmmap_insert+0x3f>
		KERN_PANIC("More than 128 E820 entries.\n");
  101b2a:	83 ec 04             	sub    $0x4,%esp
  101b2d:	8d 83 e1 ad ff ff    	lea    -0x521f(%ebx),%eax
  101b33:	50                   	push   %eax
  101b34:	6a 30                	push   $0x30
  101b36:	8d 83 d0 ad ff ff    	lea    -0x5230(%ebx),%eax
  101b3c:	50                   	push   %eax
  101b3d:	e8 5a 03 00 00       	call   101e9c <debug_panic>
  101b42:	83 c4 10             	add    $0x10,%esp
  101b45:	eb ba                	jmp    101b01 <pmmap_insert+0x25>
	if (last_slot == NULL)
  101b47:	85 d2                	test   %edx,%edx
  101b49:	74 11                	je     101b5c <pmmap_insert+0x80>
		SLIST_INSERT_AFTER(last_slot, free_slot, next);
  101b4b:	8b 42 0c             	mov    0xc(%edx),%eax
  101b4e:	89 47 0c             	mov    %eax,0xc(%edi)
  101b51:	89 7a 0c             	mov    %edi,0xc(%edx)
}
  101b54:	83 c4 1c             	add    $0x1c,%esp
  101b57:	5b                   	pop    %ebx
  101b58:	5e                   	pop    %esi
  101b59:	5f                   	pop    %edi
  101b5a:	5d                   	pop    %ebp
  101b5b:	c3                   	ret    
		SLIST_INSERT_HEAD(pmmap_list_p, free_slot, next);
  101b5c:	89 4f 0c             	mov    %ecx,0xc(%edi)
  101b5f:	89 7d 00             	mov    %edi,0x0(%ebp)
  101b62:	eb f0                	jmp    101b54 <pmmap_insert+0x78>

00101b64 <pmmap_init>:
	}
}

void
pmmap_init(uintptr_t mbi_addr, pmmap_list_type *pmmap_list_p)
{
  101b64:	55                   	push   %ebp
  101b65:	57                   	push   %edi
  101b66:	56                   	push   %esi
  101b67:	53                   	push   %ebx
  101b68:	83 ec 18             	sub    $0x18,%esp
  101b6b:	e8 9f e7 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  101b70:	81 c3 90 94 00 00    	add    $0x9490,%ebx
  101b76:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
  101b7a:	8b 7c 24 30          	mov    0x30(%esp),%edi
	KERN_INFO("\n");
  101b7e:	8d 83 ab b2 ff ff    	lea    -0x4d55(%ebx),%eax
  101b84:	50                   	push   %eax
  101b85:	e8 b4 02 00 00       	call   101e3e <debug_info>
	KERN_DEBUG("pmmap_init mbi_adr: %d\n", mbi_addr);
  101b8a:	55                   	push   %ebp
  101b8b:	8d 83 fe ad ff ff    	lea    -0x5202(%ebx),%eax
  101b91:	50                   	push   %eax
  101b92:	68 84 00 00 00       	push   $0x84
  101b97:	8d 83 d0 ad ff ff    	lea    -0x5230(%ebx),%eax
  101b9d:	50                   	push   %eax
  101b9e:	e8 c0 02 00 00       	call   101e63 <debug_normal>

	mboot_info_t *mbi = (mboot_info_t *) mbi_addr;
  101ba3:	89 ee                	mov    %ebp,%esi
	mboot_mmap_t *p = (mboot_mmap_t *) mbi->mmap_addr;
  101ba5:	8b 45 30             	mov    0x30(%ebp),%eax

	SLIST_INIT(pmmap_list_p);
  101ba8:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	SLIST_INIT(&pmmap_sublist[PMMAP_USABLE]);
  101bae:	c7 83 20 d4 01 00 00 	movl   $0x0,0x1d420(%ebx)
  101bb5:	00 00 00 
	SLIST_INIT(&pmmap_sublist[PMMAP_RESV]);
  101bb8:	c7 83 24 d4 01 00 00 	movl   $0x0,0x1d424(%ebx)
  101bbf:	00 00 00 
	SLIST_INIT(&pmmap_sublist[PMMAP_ACPI]);
  101bc2:	c7 83 28 d4 01 00 00 	movl   $0x0,0x1d428(%ebx)
  101bc9:	00 00 00 
	SLIST_INIT(&pmmap_sublist[PMMAP_NVS]);
  101bcc:	c7 83 2c d4 01 00 00 	movl   $0x0,0x1d42c(%ebx)
  101bd3:	00 00 00 

	/*
	 * Copy memory map information from multiboot information mbi to pmmap.
	 */
	while ((uintptr_t) p - (uintptr_t) mbi->mmap_addr < mbi->mmap_length) {
  101bd6:	83 c4 20             	add    $0x20,%esp
  101bd9:	eb 18                	jmp    101bf3 <pmmap_init+0x8f>
		else
			start = p->base_addr_low;

		if (p->length_high != 0 ||
		    p->length_low >= 0xffffffff - start)
			end = 0xffffffff;
  101bdb:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
		else
			end = start + p->length_low;

		type = p->type;

		pmmap_insert(pmmap_list_p, start, end, type);
  101be0:	83 ec 0c             	sub    $0xc,%esp
  101be3:	ff 70 14             	pushl  0x14(%eax)
  101be6:	89 f8                	mov    %edi,%eax
  101be8:	e8 ef fe ff ff       	call   101adc <pmmap_insert>
  101bed:	83 c4 10             	add    $0x10,%esp

		next:
			p = (mboot_mmap_t *) (((uint32_t) p) + sizeof(mboot_mmap_t)/* p->size */);
  101bf0:	8d 43 18             	lea    0x18(%ebx),%eax
	while ((uintptr_t) p - (uintptr_t) mbi->mmap_addr < mbi->mmap_length) {
  101bf3:	89 c3                	mov    %eax,%ebx
  101bf5:	89 c2                	mov    %eax,%edx
  101bf7:	2b 56 30             	sub    0x30(%esi),%edx
  101bfa:	3b 56 2c             	cmp    0x2c(%esi),%edx
  101bfd:	73 25                	jae    101c24 <pmmap_init+0xc0>
		if (p->base_addr_high != 0)	/* ignore address above 4G */
  101bff:	83 78 08 00          	cmpl   $0x0,0x8(%eax)
  101c03:	75 eb                	jne    101bf0 <pmmap_init+0x8c>
			start = p->base_addr_low;
  101c05:	8b 50 04             	mov    0x4(%eax),%edx
		if (p->length_high != 0 ||
  101c08:	83 78 10 00          	cmpl   $0x0,0x10(%eax)
  101c0c:	75 cd                	jne    101bdb <pmmap_init+0x77>
		    p->length_low >= 0xffffffff - start)
  101c0e:	8b 48 0c             	mov    0xc(%eax),%ecx
  101c11:	89 d5                	mov    %edx,%ebp
  101c13:	f7 d5                	not    %ebp
		if (p->length_high != 0 ||
  101c15:	39 e9                	cmp    %ebp,%ecx
  101c17:	73 04                	jae    101c1d <pmmap_init+0xb9>
			end = start + p->length_low;
  101c19:	01 d1                	add    %edx,%ecx
  101c1b:	eb c3                	jmp    101be0 <pmmap_init+0x7c>
			end = 0xffffffff;
  101c1d:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  101c22:	eb bc                	jmp    101be0 <pmmap_init+0x7c>
	}

	/* merge overlapped memory regions */
	pmmap_merge(pmmap_list_p);
  101c24:	89 f8                	mov    %edi,%eax
  101c26:	e8 75 fd ff ff       	call   1019a0 <trap_return>
}
  101c2b:	83 c4 0c             	add    $0xc,%esp
  101c2e:	5b                   	pop    %ebx
  101c2f:	5e                   	pop    %esi
  101c30:	5f                   	pop    %edi
  101c31:	5d                   	pop    %ebp
  101c32:	c3                   	ret    

00101c33 <set_cr3>:


void
set_cr3(char **pdir)
{
  101c33:	53                   	push   %ebx
  101c34:	83 ec 14             	sub    $0x14,%esp
  101c37:	e8 d3 e6 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  101c3c:	81 c3 c4 93 00 00    	add    $0x93c4,%ebx
	lcr3((uint32_t) pdir);
  101c42:	ff 74 24 1c          	pushl  0x1c(%esp)
  101c46:	e8 22 0c 00 00       	call   10286d <lcr3>
}
  101c4b:	83 c4 18             	add    $0x18,%esp
  101c4e:	5b                   	pop    %ebx
  101c4f:	c3                   	ret    

00101c50 <enable_paging>:
  *
  * Hint: bit masks are defined in x86.h file.
  */
void
enable_paging(void)
{
  101c50:	53                   	push   %ebx
  101c51:	83 ec 08             	sub    $0x8,%esp
  101c54:	e8 b6 e6 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  101c59:	81 c3 a7 93 00 00    	add    $0x93a7,%ebx
    //TODO
    lcr4(rcr4()|CR4_PGE);
  101c5f:	e8 19 0c 00 00       	call   10287d <rcr4>
  101c64:	83 ec 0c             	sub    $0xc,%esp
  101c67:	0c 80                	or     $0x80,%al
  101c69:	50                   	push   %eax
  101c6a:	e8 06 0c 00 00       	call   102875 <lcr4>

    lcr0(rcr0() | CR0_MP | CR0_NE | CR0_WP | CR0_AM | CR0_PE | CR0_PG & (~(CR0_EM | CR0_TS)));
  101c6f:	e8 f1 0b 00 00       	call   102865 <rcr0>
  101c74:	0d 23 00 05 80       	or     $0x80050023,%eax
  101c79:	89 04 24             	mov    %eax,(%esp)
  101c7c:	e8 dc 0b 00 00       	call   10285d <lcr0>

}
  101c81:	83 c4 18             	add    $0x18,%esp
  101c84:	5b                   	pop    %ebx
  101c85:	c3                   	ret    

00101c86 <memset>:
#include "string.h"
#include "types.h"

void *
memset(void *v, int c, size_t n)
{
  101c86:	57                   	push   %edi
  101c87:	53                   	push   %ebx
  101c88:	8b 7c 24 0c          	mov    0xc(%esp),%edi
  101c8c:	8b 4c 24 14          	mov    0x14(%esp),%ecx
    if (n == 0)
  101c90:	85 c9                	test   %ecx,%ecx
  101c92:	74 14                	je     101ca8 <memset+0x22>
        return v;
    if ((int)v%4 == 0 && n%4 == 0) {
  101c94:	f7 c7 03 00 00 00    	test   $0x3,%edi
  101c9a:	75 05                	jne    101ca1 <memset+0x1b>
  101c9c:	f6 c1 03             	test   $0x3,%cl
  101c9f:	74 0c                	je     101cad <memset+0x27>
        c = (c<<24)|(c<<16)|(c<<8)|c;
        asm volatile("cld; rep stosl\n"
                 :: "D" (v), "a" (c), "c" (n/4)
                 : "cc", "memory");
    } else
        asm volatile("cld; rep stosb\n"
  101ca1:	8b 44 24 10          	mov    0x10(%esp),%eax
  101ca5:	fc                   	cld    
  101ca6:	f3 aa                	rep stos %al,%es:(%edi)
                 :: "D" (v), "a" (c), "c" (n)
                 : "cc", "memory");
    return v;
}
  101ca8:	89 f8                	mov    %edi,%eax
  101caa:	5b                   	pop    %ebx
  101cab:	5f                   	pop    %edi
  101cac:	c3                   	ret    
        c &= 0xFF;
  101cad:	0f b6 44 24 10       	movzbl 0x10(%esp),%eax
        c = (c<<24)|(c<<16)|(c<<8)|c;
  101cb2:	89 c2                	mov    %eax,%edx
  101cb4:	c1 e2 18             	shl    $0x18,%edx
  101cb7:	89 c3                	mov    %eax,%ebx
  101cb9:	c1 e3 10             	shl    $0x10,%ebx
  101cbc:	09 da                	or     %ebx,%edx
  101cbe:	89 c3                	mov    %eax,%ebx
  101cc0:	c1 e3 08             	shl    $0x8,%ebx
  101cc3:	09 da                	or     %ebx,%edx
  101cc5:	09 d0                	or     %edx,%eax
                 :: "D" (v), "a" (c), "c" (n/4)
  101cc7:	c1 e9 02             	shr    $0x2,%ecx
        asm volatile("cld; rep stosl\n"
  101cca:	fc                   	cld    
  101ccb:	f3 ab                	rep stos %eax,%es:(%edi)
  101ccd:	eb d9                	jmp    101ca8 <memset+0x22>

00101ccf <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  101ccf:	57                   	push   %edi
  101cd0:	56                   	push   %esi
  101cd1:	8b 44 24 0c          	mov    0xc(%esp),%eax
  101cd5:	8b 74 24 10          	mov    0x10(%esp),%esi
  101cd9:	8b 4c 24 14          	mov    0x14(%esp),%ecx
    const char *s;
    char *d;

    s = src;
    d = dst;
    if (s < d && s + n > d) {
  101cdd:	39 c6                	cmp    %eax,%esi
  101cdf:	73 36                	jae    101d17 <memmove+0x48>
  101ce1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  101ce4:	39 c2                	cmp    %eax,%edx
  101ce6:	76 2f                	jbe    101d17 <memmove+0x48>
        s += n;
        d += n;
  101ce8:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
        if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  101ceb:	f6 c2 03             	test   $0x3,%dl
  101cee:	75 1b                	jne    101d0b <memmove+0x3c>
  101cf0:	f7 c7 03 00 00 00    	test   $0x3,%edi
  101cf6:	75 13                	jne    101d0b <memmove+0x3c>
  101cf8:	f6 c1 03             	test   $0x3,%cl
  101cfb:	75 0e                	jne    101d0b <memmove+0x3c>
            asm volatile("std; rep movsl\n"
                     :: "D" (d-4), "S" (s-4), "c" (n/4)
  101cfd:	83 ef 04             	sub    $0x4,%edi
  101d00:	8d 72 fc             	lea    -0x4(%edx),%esi
  101d03:	c1 e9 02             	shr    $0x2,%ecx
            asm volatile("std; rep movsl\n"
  101d06:	fd                   	std    
  101d07:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  101d09:	eb 09                	jmp    101d14 <memmove+0x45>
                     : "cc", "memory");
        else
            asm volatile("std; rep movsb\n"
                     :: "D" (d-1), "S" (s-1), "c" (n)
  101d0b:	83 ef 01             	sub    $0x1,%edi
  101d0e:	8d 72 ff             	lea    -0x1(%edx),%esi
            asm volatile("std; rep movsb\n"
  101d11:	fd                   	std    
  101d12:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
                     : "cc", "memory");
        // Some versions of GCC rely on DF being clear
        asm volatile("cld" ::: "cc");
  101d14:	fc                   	cld    
  101d15:	eb 16                	jmp    101d2d <memmove+0x5e>
    } else {
        if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  101d17:	f7 c6 03 00 00 00    	test   $0x3,%esi
  101d1d:	75 09                	jne    101d28 <memmove+0x59>
  101d1f:	a8 03                	test   $0x3,%al
  101d21:	75 05                	jne    101d28 <memmove+0x59>
  101d23:	f6 c1 03             	test   $0x3,%cl
  101d26:	74 08                	je     101d30 <memmove+0x61>
            asm volatile("cld; rep movsl\n"
                     :: "D" (d), "S" (s), "c" (n/4)
                     : "cc", "memory");
        else
            asm volatile("cld; rep movsb\n"
  101d28:	89 c7                	mov    %eax,%edi
  101d2a:	fc                   	cld    
  101d2b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
                     :: "D" (d), "S" (s), "c" (n)
                     : "cc", "memory");
    }
    return dst;
}
  101d2d:	5e                   	pop    %esi
  101d2e:	5f                   	pop    %edi
  101d2f:	c3                   	ret    
                     :: "D" (d), "S" (s), "c" (n/4)
  101d30:	c1 e9 02             	shr    $0x2,%ecx
            asm volatile("cld; rep movsl\n"
  101d33:	89 c7                	mov    %eax,%edi
  101d35:	fc                   	cld    
  101d36:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  101d38:	eb f3                	jmp    101d2d <memmove+0x5e>

00101d3a <memcpy>:

void *
memcpy(void *dst, const void *src, size_t n)
{
	return memmove(dst, src, n);
  101d3a:	ff 74 24 0c          	pushl  0xc(%esp)
  101d3e:	ff 74 24 0c          	pushl  0xc(%esp)
  101d42:	ff 74 24 0c          	pushl  0xc(%esp)
  101d46:	e8 84 ff ff ff       	call   101ccf <memmove>
  101d4b:	83 c4 0c             	add    $0xc,%esp
}
  101d4e:	c3                   	ret    

00101d4f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  101d4f:	53                   	push   %ebx
  101d50:	8b 54 24 08          	mov    0x8(%esp),%edx
  101d54:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
  101d58:	8b 44 24 10          	mov    0x10(%esp),%eax
	while (n > 0 && *p && *p == *q)
  101d5c:	eb 09                	jmp    101d67 <strncmp+0x18>
		n--, p++, q++;
  101d5e:	83 e8 01             	sub    $0x1,%eax
  101d61:	83 c2 01             	add    $0x1,%edx
  101d64:	83 c1 01             	add    $0x1,%ecx
	while (n > 0 && *p && *p == *q)
  101d67:	85 c0                	test   %eax,%eax
  101d69:	74 0b                	je     101d76 <strncmp+0x27>
  101d6b:	0f b6 1a             	movzbl (%edx),%ebx
  101d6e:	84 db                	test   %bl,%bl
  101d70:	74 04                	je     101d76 <strncmp+0x27>
  101d72:	3a 19                	cmp    (%ecx),%bl
  101d74:	74 e8                	je     101d5e <strncmp+0xf>
	if (n == 0)
  101d76:	85 c0                	test   %eax,%eax
  101d78:	74 0a                	je     101d84 <strncmp+0x35>
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  101d7a:	0f b6 02             	movzbl (%edx),%eax
  101d7d:	0f b6 11             	movzbl (%ecx),%edx
  101d80:	29 d0                	sub    %edx,%eax
}
  101d82:	5b                   	pop    %ebx
  101d83:	c3                   	ret    
		return 0;
  101d84:	b8 00 00 00 00       	mov    $0x0,%eax
  101d89:	eb f7                	jmp    101d82 <strncmp+0x33>

00101d8b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  101d8b:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  101d8f:	8b 54 24 08          	mov    0x8(%esp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  101d93:	b8 00 00 00 00       	mov    $0x0,%eax
  101d98:	eb 09                	jmp    101da3 <strnlen+0x18>
		n++;
  101d9a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  101d9d:	83 c1 01             	add    $0x1,%ecx
  101da0:	83 ea 01             	sub    $0x1,%edx
  101da3:	85 d2                	test   %edx,%edx
  101da5:	74 05                	je     101dac <strnlen+0x21>
  101da7:	80 39 00             	cmpb   $0x0,(%ecx)
  101daa:	75 ee                	jne    101d9a <strnlen+0xf>
	return n;
}
  101dac:	f3 c3                	repz ret 

00101dae <strcmp>:

int
strcmp(const char *p, const char *q)
{
  101dae:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  101db2:	8b 54 24 08          	mov    0x8(%esp),%edx
  while (*p && *p == *q)
  101db6:	eb 06                	jmp    101dbe <strcmp+0x10>
    p++, q++;
  101db8:	83 c1 01             	add    $0x1,%ecx
  101dbb:	83 c2 01             	add    $0x1,%edx
  while (*p && *p == *q)
  101dbe:	0f b6 01             	movzbl (%ecx),%eax
  101dc1:	84 c0                	test   %al,%al
  101dc3:	74 04                	je     101dc9 <strcmp+0x1b>
  101dc5:	3a 02                	cmp    (%edx),%al
  101dc7:	74 ef                	je     101db8 <strcmp+0xa>
  return (int) ((unsigned char) *p - (unsigned char) *q);
  101dc9:	0f b6 c0             	movzbl %al,%eax
  101dcc:	0f b6 12             	movzbl (%edx),%edx
  101dcf:	29 d0                	sub    %edx,%eax
}
  101dd1:	c3                   	ret    

00101dd2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  101dd2:	8b 44 24 04          	mov    0x4(%esp),%eax
  101dd6:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
  for (; *s; s++)
  101ddb:	0f b6 10             	movzbl (%eax),%edx
  101dde:	84 d2                	test   %dl,%dl
  101de0:	74 09                	je     101deb <strchr+0x19>
    if (*s == c)
  101de2:	38 ca                	cmp    %cl,%dl
  101de4:	74 0a                	je     101df0 <strchr+0x1e>
  for (; *s; s++)
  101de6:	83 c0 01             	add    $0x1,%eax
  101de9:	eb f0                	jmp    101ddb <strchr+0x9>
      return (char *) s;
  return 0;
  101deb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101df0:	f3 c3                	repz ret 

00101df2 <memzero>:

void *
memzero(void *v, size_t n)
{
	return memset(v, 0, n);
  101df2:	ff 74 24 08          	pushl  0x8(%esp)
  101df6:	6a 00                	push   $0x0
  101df8:	ff 74 24 0c          	pushl  0xc(%esp)
  101dfc:	e8 85 fe ff ff       	call   101c86 <memset>
  101e01:	83 c4 0c             	add    $0xc,%esp
}
  101e04:	c3                   	ret    

00101e05 <debug_trace>:

#define DEBUG_TRACEFRAMES	10

static void
debug_trace(uintptr_t ebp, uintptr_t *eips)
{
  101e05:	56                   	push   %esi
  101e06:	53                   	push   %ebx
  101e07:	89 d6                	mov    %edx,%esi
	int i;
	uintptr_t *frame = (uintptr_t *) ebp;

	for (i = 0; i < DEBUG_TRACEFRAMES && frame; i++) {
  101e09:	b9 00 00 00 00       	mov    $0x0,%ecx
  101e0e:	eb 0b                	jmp    101e1b <debug_trace+0x16>
		eips[i] = frame[1];		/* saved %eip */
  101e10:	8b 50 04             	mov    0x4(%eax),%edx
  101e13:	89 14 8e             	mov    %edx,(%esi,%ecx,4)
		frame = (uintptr_t *) frame[0];	/* saved %ebp */
  101e16:	8b 00                	mov    (%eax),%eax
	for (i = 0; i < DEBUG_TRACEFRAMES && frame; i++) {
  101e18:	83 c1 01             	add    $0x1,%ecx
  101e1b:	83 f9 09             	cmp    $0x9,%ecx
  101e1e:	0f 9e c3             	setle  %bl
  101e21:	85 c0                	test   %eax,%eax
  101e23:	0f 95 c2             	setne  %dl
  101e26:	84 da                	test   %bl,%dl
  101e28:	75 e6                	jne    101e10 <debug_trace+0xb>
  101e2a:	eb 0a                	jmp    101e36 <debug_trace+0x31>
	}
	for (; i < DEBUG_TRACEFRAMES; i++)
		eips[i] = 0;
  101e2c:	c7 04 8e 00 00 00 00 	movl   $0x0,(%esi,%ecx,4)
	for (; i < DEBUG_TRACEFRAMES; i++)
  101e33:	83 c1 01             	add    $0x1,%ecx
  101e36:	83 f9 09             	cmp    $0x9,%ecx
  101e39:	7e f1                	jle    101e2c <debug_trace+0x27>
}
  101e3b:	5b                   	pop    %ebx
  101e3c:	5e                   	pop    %esi
  101e3d:	c3                   	ret    

00101e3e <debug_info>:
{
  101e3e:	53                   	push   %ebx
  101e3f:	83 ec 08             	sub    $0x8,%esp
  101e42:	e8 c8 e4 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  101e47:	81 c3 b9 91 00 00    	add    $0x91b9,%ebx
	va_start(ap, fmt);
  101e4d:	8d 44 24 14          	lea    0x14(%esp),%eax
	vdprintf(fmt, ap);
  101e51:	83 ec 08             	sub    $0x8,%esp
  101e54:	50                   	push   %eax
  101e55:	ff 74 24 1c          	pushl  0x1c(%esp)
  101e59:	e8 72 01 00 00       	call   101fd0 <vdprintf>
}
  101e5e:	83 c4 18             	add    $0x18,%esp
  101e61:	5b                   	pop    %ebx
  101e62:	c3                   	ret    

00101e63 <debug_normal>:
{
  101e63:	53                   	push   %ebx
  101e64:	83 ec 0c             	sub    $0xc,%esp
  101e67:	e8 a3 e4 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  101e6c:	81 c3 94 91 00 00    	add    $0x9194,%ebx
	dprintf("[D] %s:%d: ", file, line);
  101e72:	ff 74 24 18          	pushl  0x18(%esp)
  101e76:	ff 74 24 18          	pushl  0x18(%esp)
  101e7a:	8d 83 16 ae ff ff    	lea    -0x51ea(%ebx),%eax
  101e80:	50                   	push   %eax
  101e81:	e8 a9 01 00 00       	call   10202f <dprintf>
	va_start(ap, fmt);
  101e86:	8d 44 24 2c          	lea    0x2c(%esp),%eax
	vdprintf(fmt, ap);
  101e8a:	83 c4 08             	add    $0x8,%esp
  101e8d:	50                   	push   %eax
  101e8e:	ff 74 24 24          	pushl  0x24(%esp)
  101e92:	e8 39 01 00 00       	call   101fd0 <vdprintf>
}
  101e97:	83 c4 18             	add    $0x18,%esp
  101e9a:	5b                   	pop    %ebx
  101e9b:	c3                   	ret    

00101e9c <debug_panic>:

gcc_noinline void
debug_panic(const char *file, int line, const char *fmt,...)
{
  101e9c:	56                   	push   %esi
  101e9d:	53                   	push   %ebx
  101e9e:	83 ec 38             	sub    $0x38,%esp
  101ea1:	e8 69 e4 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  101ea6:	81 c3 5a 91 00 00    	add    $0x915a,%ebx
	int i;
	uintptr_t eips[DEBUG_TRACEFRAMES];
	va_list ap;

	dprintf("[P] %s:%d: ", file, line);
  101eac:	ff 74 24 48          	pushl  0x48(%esp)
  101eb0:	ff 74 24 48          	pushl  0x48(%esp)
  101eb4:	8d 83 22 ae ff ff    	lea    -0x51de(%ebx),%eax
  101eba:	50                   	push   %eax
  101ebb:	e8 6f 01 00 00       	call   10202f <dprintf>

	va_start(ap, fmt);
  101ec0:	8d 44 24 5c          	lea    0x5c(%esp),%eax
	vdprintf(fmt, ap);
  101ec4:	83 c4 08             	add    $0x8,%esp
  101ec7:	50                   	push   %eax
  101ec8:	ff 74 24 54          	pushl  0x54(%esp)
  101ecc:	e8 ff 00 00 00       	call   101fd0 <vdprintf>

static inline uint32_t __attribute__((always_inline))
read_ebp(void)
{
	uint32_t ebp;
	__asm __volatile("movl %%ebp,%0" : "=rm" (ebp));
  101ed1:	89 e8                	mov    %ebp,%eax
	va_end(ap);

	debug_trace(read_ebp(), eips);
  101ed3:	8d 54 24 18          	lea    0x18(%esp),%edx
  101ed7:	e8 29 ff ff ff       	call   101e05 <debug_trace>
	for (i = 0; i < DEBUG_TRACEFRAMES && eips[i] != 0; i++)
  101edc:	83 c4 10             	add    $0x10,%esp
  101edf:	be 00 00 00 00       	mov    $0x0,%esi
  101ee4:	eb 16                	jmp    101efc <debug_panic+0x60>
		dprintf("\tfrom 0x%08x\n", eips[i]);
  101ee6:	83 ec 08             	sub    $0x8,%esp
  101ee9:	50                   	push   %eax
  101eea:	8d 83 2e ae ff ff    	lea    -0x51d2(%ebx),%eax
  101ef0:	50                   	push   %eax
  101ef1:	e8 39 01 00 00       	call   10202f <dprintf>
	for (i = 0; i < DEBUG_TRACEFRAMES && eips[i] != 0; i++)
  101ef6:	83 c6 01             	add    $0x1,%esi
  101ef9:	83 c4 10             	add    $0x10,%esp
  101efc:	83 fe 09             	cmp    $0x9,%esi
  101eff:	7f 08                	jg     101f09 <debug_panic+0x6d>
  101f01:	8b 44 b4 08          	mov    0x8(%esp,%esi,4),%eax
  101f05:	85 c0                	test   %eax,%eax
  101f07:	75 dd                	jne    101ee6 <debug_panic+0x4a>

	dprintf("Kernel Panic !!!\n");
  101f09:	83 ec 0c             	sub    $0xc,%esp
  101f0c:	8d 83 3c ae ff ff    	lea    -0x51c4(%ebx),%eax
  101f12:	50                   	push   %eax
  101f13:	e8 17 01 00 00       	call   10202f <dprintf>

	//intr_local_disable();
	halt();
  101f18:	e8 d0 08 00 00       	call   1027ed <halt>
}
  101f1d:	83 c4 44             	add    $0x44,%esp
  101f20:	5b                   	pop    %ebx
  101f21:	5e                   	pop    %esi
  101f22:	c3                   	ret    

00101f23 <debug_warn>:

void
debug_warn(const char *file, int line, const char *fmt,...)
{
  101f23:	53                   	push   %ebx
  101f24:	83 ec 0c             	sub    $0xc,%esp
  101f27:	e8 e3 e3 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  101f2c:	81 c3 d4 90 00 00    	add    $0x90d4,%ebx
	dprintf("[W] %s:%d: ", file, line);
  101f32:	ff 74 24 18          	pushl  0x18(%esp)
  101f36:	ff 74 24 18          	pushl  0x18(%esp)
  101f3a:	8d 83 4e ae ff ff    	lea    -0x51b2(%ebx),%eax
  101f40:	50                   	push   %eax
  101f41:	e8 e9 00 00 00       	call   10202f <dprintf>

	va_list ap;
	va_start(ap, fmt);
  101f46:	8d 44 24 2c          	lea    0x2c(%esp),%eax
	vdprintf(fmt, ap);
  101f4a:	83 c4 08             	add    $0x8,%esp
  101f4d:	50                   	push   %eax
  101f4e:	ff 74 24 24          	pushl  0x24(%esp)
  101f52:	e8 79 00 00 00       	call   101fd0 <vdprintf>
	va_end(ap);
}
  101f57:	83 c4 18             	add    $0x18,%esp
  101f5a:	5b                   	pop    %ebx
  101f5b:	c3                   	ret    

00101f5c <cputs>:
    char buf[CONSOLE_BUFFER_SIZE];
};

static void
cputs (const char *str)
{
  101f5c:	56                   	push   %esi
  101f5d:	53                   	push   %ebx
  101f5e:	83 ec 04             	sub    $0x4,%esp
  101f61:	e8 a9 e3 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  101f66:	81 c3 9a 90 00 00    	add    $0x909a,%ebx
  101f6c:	89 c6                	mov    %eax,%esi
    while (*str)
  101f6e:	eb 12                	jmp    101f82 <cputs+0x26>
    {
        cons_putc (*str);
  101f70:	83 ec 0c             	sub    $0xc,%esp
  101f73:	0f be c0             	movsbl %al,%eax
  101f76:	50                   	push   %eax
  101f77:	e8 74 e4 ff ff       	call   1003f0 <cons_putc>
        str += 1;
  101f7c:	83 c6 01             	add    $0x1,%esi
  101f7f:	83 c4 10             	add    $0x10,%esp
    while (*str)
  101f82:	0f b6 06             	movzbl (%esi),%eax
  101f85:	84 c0                	test   %al,%al
  101f87:	75 e7                	jne    101f70 <cputs+0x14>
    }
}
  101f89:	83 c4 04             	add    $0x4,%esp
  101f8c:	5b                   	pop    %ebx
  101f8d:	5e                   	pop    %esi
  101f8e:	c3                   	ret    

00101f8f <putch>:

static void
putch (int ch, struct dprintbuf *b)
{
  101f8f:	53                   	push   %ebx
  101f90:	83 ec 08             	sub    $0x8,%esp
  101f93:	8b 5c 24 14          	mov    0x14(%esp),%ebx
    b->buf[b->idx++] = ch;
  101f97:	8b 13                	mov    (%ebx),%edx
  101f99:	8d 42 01             	lea    0x1(%edx),%eax
  101f9c:	89 03                	mov    %eax,(%ebx)
  101f9e:	8b 4c 24 10          	mov    0x10(%esp),%ecx
  101fa2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
    if (b->idx == CONSOLE_BUFFER_SIZE - 1)
  101fa6:	3d ff 01 00 00       	cmp    $0x1ff,%eax
  101fab:	74 0e                	je     101fbb <putch+0x2c>
    {
        b->buf[b->idx] = 0;
        cputs (b->buf);
        b->idx = 0;
    }
    b->cnt++;
  101fad:	8b 43 04             	mov    0x4(%ebx),%eax
  101fb0:	83 c0 01             	add    $0x1,%eax
  101fb3:	89 43 04             	mov    %eax,0x4(%ebx)
}
  101fb6:	83 c4 08             	add    $0x8,%esp
  101fb9:	5b                   	pop    %ebx
  101fba:	c3                   	ret    
        b->buf[b->idx] = 0;
  101fbb:	c6 44 13 09 00       	movb   $0x0,0x9(%ebx,%edx,1)
        cputs (b->buf);
  101fc0:	8d 43 08             	lea    0x8(%ebx),%eax
  101fc3:	e8 94 ff ff ff       	call   101f5c <cputs>
        b->idx = 0;
  101fc8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  101fce:	eb dd                	jmp    101fad <putch+0x1e>

00101fd0 <vdprintf>:

int
vdprintf (const char *fmt, va_list ap)
{
  101fd0:	53                   	push   %ebx
  101fd1:	81 ec 18 02 00 00    	sub    $0x218,%esp
  101fd7:	e8 33 e3 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  101fdc:	81 c3 24 90 00 00    	add    $0x9024,%ebx
    struct dprintbuf b;

    b.idx = 0;
  101fe2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  101fe9:	00 
    b.cnt = 0;
  101fea:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  101ff1:	00 
    vprintfmt ((void*) putch, &b, fmt, ap);
  101ff2:	ff b4 24 24 02 00 00 	pushl  0x224(%esp)
  101ff9:	ff b4 24 24 02 00 00 	pushl  0x224(%esp)
  102000:	8d 44 24 10          	lea    0x10(%esp),%eax
  102004:	50                   	push   %eax
  102005:	8d 83 8f 6f ff ff    	lea    -0x9071(%ebx),%eax
  10200b:	50                   	push   %eax
  10200c:	e8 6b 01 00 00       	call   10217c <vprintfmt>

    b.buf[b.idx] = 0;
  102011:	8b 44 24 18          	mov    0x18(%esp),%eax
  102015:	c6 44 04 20 00       	movb   $0x0,0x20(%esp,%eax,1)
    cputs (b.buf);
  10201a:	8d 44 24 20          	lea    0x20(%esp),%eax
  10201e:	e8 39 ff ff ff       	call   101f5c <cputs>

    return b.cnt;
}
  102023:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  102027:	81 c4 28 02 00 00    	add    $0x228,%esp
  10202d:	5b                   	pop    %ebx
  10202e:	c3                   	ret    

0010202f <dprintf>:

int
dprintf (const char *fmt, ...)
{
  10202f:	83 ec 0c             	sub    $0xc,%esp
    va_list ap;
    int cnt;

    va_start(ap, fmt);
  102032:	8d 44 24 14          	lea    0x14(%esp),%eax
    cnt = vdprintf (fmt, ap);
  102036:	83 ec 08             	sub    $0x8,%esp
  102039:	50                   	push   %eax
  10203a:	ff 74 24 1c          	pushl  0x1c(%esp)
  10203e:	e8 8d ff ff ff       	call   101fd0 <vdprintf>
    va_end(ap);

    return cnt;
}
  102043:	83 c4 1c             	add    $0x1c,%esp
  102046:	c3                   	ret    

00102047 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(putch_t putch, void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  102047:	55                   	push   %ebp
  102048:	57                   	push   %edi
  102049:	56                   	push   %esi
  10204a:	53                   	push   %ebx
  10204b:	83 ec 2c             	sub    $0x2c,%esp
  10204e:	e8 b8 e2 ff ff       	call   10030b <__x86.get_pc_thunk.cx>
  102053:	81 c1 ad 8f 00 00    	add    $0x8fad,%ecx
  102059:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  10205d:	89 c6                	mov    %eax,%esi
  10205f:	89 d7                	mov    %edx,%edi
  102061:	8b 44 24 40          	mov    0x40(%esp),%eax
  102065:	8b 54 24 44          	mov    0x44(%esp),%edx
  102069:	89 44 24 18          	mov    %eax,0x18(%esp)
  10206d:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  102071:	8b 6c 24 50          	mov    0x50(%esp),%ebp
	/* first recursively print all preceding (more significant) digits */
	if (num >= base) {
  102075:	8b 4c 24 48          	mov    0x48(%esp),%ecx
  102079:	bb 00 00 00 00       	mov    $0x0,%ebx
  10207e:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  102082:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  102086:	39 d3                	cmp    %edx,%ebx
  102088:	72 0a                	jb     102094 <printnum+0x4d>
  10208a:	39 44 24 48          	cmp    %eax,0x48(%esp)
  10208e:	0f 87 82 00 00 00    	ja     102116 <printnum+0xcf>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  102094:	83 ec 0c             	sub    $0xc,%esp
  102097:	55                   	push   %ebp
  102098:	8b 44 24 5c          	mov    0x5c(%esp),%eax
  10209c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  10209f:	53                   	push   %ebx
  1020a0:	ff 74 24 5c          	pushl  0x5c(%esp)
  1020a4:	83 ec 08             	sub    $0x8,%esp
  1020a7:	ff 74 24 34          	pushl  0x34(%esp)
  1020ab:	ff 74 24 34          	pushl  0x34(%esp)
  1020af:	ff 74 24 44          	pushl  0x44(%esp)
  1020b3:	ff 74 24 44          	pushl  0x44(%esp)
  1020b7:	8b 5c 24 3c          	mov    0x3c(%esp),%ebx
  1020bb:	e8 90 37 00 00       	call   105850 <__udivdi3>
  1020c0:	83 c4 18             	add    $0x18,%esp
  1020c3:	52                   	push   %edx
  1020c4:	50                   	push   %eax
  1020c5:	89 fa                	mov    %edi,%edx
  1020c7:	89 f0                	mov    %esi,%eax
  1020c9:	e8 79 ff ff ff       	call   102047 <printnum>
  1020ce:	83 c4 20             	add    $0x20,%esp
  1020d1:	eb 11                	jmp    1020e4 <printnum+0x9d>
	} else {
		/* print any needed pad characters before first digit */
		while (--width > 0)
			putch(padc, putdat);
  1020d3:	83 ec 08             	sub    $0x8,%esp
  1020d6:	57                   	push   %edi
  1020d7:	55                   	push   %ebp
  1020d8:	ff d6                	call   *%esi
  1020da:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  1020dd:	83 eb 01             	sub    $0x1,%ebx
  1020e0:	85 db                	test   %ebx,%ebx
  1020e2:	7f ef                	jg     1020d3 <printnum+0x8c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  1020e4:	ff 74 24 14          	pushl  0x14(%esp)
  1020e8:	ff 74 24 14          	pushl  0x14(%esp)
  1020ec:	ff 74 24 24          	pushl  0x24(%esp)
  1020f0:	ff 74 24 24          	pushl  0x24(%esp)
  1020f4:	8b 6c 24 1c          	mov    0x1c(%esp),%ebp
  1020f8:	89 eb                	mov    %ebp,%ebx
  1020fa:	e8 71 38 00 00       	call   105970 <__umoddi3>
  1020ff:	83 c4 08             	add    $0x8,%esp
  102102:	57                   	push   %edi
  102103:	0f be 84 05 5a ae ff 	movsbl -0x51a6(%ebp,%eax,1),%eax
  10210a:	ff 
  10210b:	50                   	push   %eax
  10210c:	ff d6                	call   *%esi
}
  10210e:	83 c4 3c             	add    $0x3c,%esp
  102111:	5b                   	pop    %ebx
  102112:	5e                   	pop    %esi
  102113:	5f                   	pop    %edi
  102114:	5d                   	pop    %ebp
  102115:	c3                   	ret    
  102116:	8b 5c 24 4c          	mov    0x4c(%esp),%ebx
  10211a:	eb c1                	jmp    1020dd <printnum+0x96>

0010211c <getuint>:
 * depending on the lflag parameter.
 */
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  10211c:	83 fa 01             	cmp    $0x1,%edx
  10211f:	7e 0d                	jle    10212e <getuint+0x12>
		return va_arg(*ap, unsigned long long);
  102121:	8b 10                	mov    (%eax),%edx
  102123:	8d 4a 08             	lea    0x8(%edx),%ecx
  102126:	89 08                	mov    %ecx,(%eax)
  102128:	8b 02                	mov    (%edx),%eax
  10212a:	8b 52 04             	mov    0x4(%edx),%edx
  10212d:	c3                   	ret    
	else if (lflag)
  10212e:	85 d2                	test   %edx,%edx
  102130:	75 0f                	jne    102141 <getuint+0x25>
		return va_arg(*ap, unsigned long);
	else
		return va_arg(*ap, unsigned int);
  102132:	8b 10                	mov    (%eax),%edx
  102134:	8d 4a 04             	lea    0x4(%edx),%ecx
  102137:	89 08                	mov    %ecx,(%eax)
  102139:	8b 02                	mov    (%edx),%eax
  10213b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  102140:	c3                   	ret    
		return va_arg(*ap, unsigned long);
  102141:	8b 10                	mov    (%eax),%edx
  102143:	8d 4a 04             	lea    0x4(%edx),%ecx
  102146:	89 08                	mov    %ecx,(%eax)
  102148:	8b 02                	mov    (%edx),%eax
  10214a:	ba 00 00 00 00       	mov    $0x0,%edx
  10214f:	c3                   	ret    

00102150 <getint>:
 * because of sign extension
 */
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  102150:	83 fa 01             	cmp    $0x1,%edx
  102153:	7e 0d                	jle    102162 <getint+0x12>
		return va_arg(*ap, long long);
  102155:	8b 10                	mov    (%eax),%edx
  102157:	8d 4a 08             	lea    0x8(%edx),%ecx
  10215a:	89 08                	mov    %ecx,(%eax)
  10215c:	8b 02                	mov    (%edx),%eax
  10215e:	8b 52 04             	mov    0x4(%edx),%edx
  102161:	c3                   	ret    
	else if (lflag)
  102162:	85 d2                	test   %edx,%edx
  102164:	75 0b                	jne    102171 <getint+0x21>
		return va_arg(*ap, long);
	else
		return va_arg(*ap, int);
  102166:	8b 10                	mov    (%eax),%edx
  102168:	8d 4a 04             	lea    0x4(%edx),%ecx
  10216b:	89 08                	mov    %ecx,(%eax)
  10216d:	8b 02                	mov    (%edx),%eax
  10216f:	99                   	cltd   
}
  102170:	c3                   	ret    
		return va_arg(*ap, long);
  102171:	8b 10                	mov    (%eax),%edx
  102173:	8d 4a 04             	lea    0x4(%edx),%ecx
  102176:	89 08                	mov    %ecx,(%eax)
  102178:	8b 02                	mov    (%edx),%eax
  10217a:	99                   	cltd   
  10217b:	c3                   	ret    

0010217c <vprintfmt>:

void
vprintfmt(putch_t putch, void *putdat, const char *fmt, va_list ap)
{
  10217c:	55                   	push   %ebp
  10217d:	57                   	push   %edi
  10217e:	56                   	push   %esi
  10217f:	53                   	push   %ebx
  102180:	83 ec 2c             	sub    $0x2c,%esp
  102183:	e8 3a 03 00 00       	call   1024c2 <__x86.get_pc_thunk.ax>
  102188:	05 78 8e 00 00       	add    $0x8e78,%eax
  10218d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102191:	8b 74 24 40          	mov    0x40(%esp),%esi
  102195:	8b 7c 24 44          	mov    0x44(%esp),%edi
  102199:	8b 6c 24 48          	mov    0x48(%esp),%ebp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  10219d:	8d 5d 01             	lea    0x1(%ebp),%ebx
  1021a0:	0f b6 45 00          	movzbl 0x0(%ebp),%eax
  1021a4:	83 f8 25             	cmp    $0x25,%eax
  1021a7:	74 16                	je     1021bf <vprintfmt+0x43>
			if (ch == '\0')
  1021a9:	85 c0                	test   %eax,%eax
  1021ab:	0f 84 09 03 00 00    	je     1024ba <.L27+0x1d>
				return;
			putch(ch, putdat);
  1021b1:	83 ec 08             	sub    $0x8,%esp
  1021b4:	57                   	push   %edi
  1021b5:	50                   	push   %eax
  1021b6:	ff d6                	call   *%esi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  1021b8:	83 c4 10             	add    $0x10,%esp
  1021bb:	89 dd                	mov    %ebx,%ebp
  1021bd:	eb de                	jmp    10219d <vprintfmt+0x21>
		}

		// Process a %-escape sequence
		padc = ' ';
  1021bf:	c6 44 24 17 20       	movb   $0x20,0x17(%esp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
  1021c4:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  1021cb:	00 
		precision = -1;
  1021cc:	c7 44 24 1c ff ff ff 	movl   $0xffffffff,0x1c(%esp)
  1021d3:	ff 
		width = -1;
  1021d4:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
		lflag = 0;
  1021db:	ba 00 00 00 00       	mov    $0x0,%edx
  1021e0:	89 54 24 18          	mov    %edx,0x18(%esp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  1021e4:	8d 6b 01             	lea    0x1(%ebx),%ebp
  1021e7:	0f b6 03             	movzbl (%ebx),%eax
  1021ea:	0f b6 d0             	movzbl %al,%edx
  1021ed:	89 54 24 08          	mov    %edx,0x8(%esp)
  1021f1:	83 e8 23             	sub    $0x23,%eax
  1021f4:	3c 55                	cmp    $0x55,%al
  1021f6:	0f 87 a1 02 00 00    	ja     10249d <.L27>
  1021fc:	0f b6 c0             	movzbl %al,%eax
  1021ff:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  102203:	03 8c 81 74 ae ff ff 	add    -0x518c(%ecx,%eax,4),%ecx
  10220a:	ff e1                	jmp    *%ecx

0010220c <.L25>:
  10220c:	89 eb                	mov    %ebp,%ebx

			// flag to pad on the right
		case '-':
			padc = '-';
  10220e:	c6 44 24 17 2d       	movb   $0x2d,0x17(%esp)
  102213:	eb cf                	jmp    1021e4 <vprintfmt+0x68>

00102215 <.L58>:
		switch (ch = *(unsigned char *) fmt++) {
  102215:	89 eb                	mov    %ebp,%ebx
			goto reswitch;

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  102217:	c6 44 24 17 30       	movb   $0x30,0x17(%esp)
  10221c:	eb c6                	jmp    1021e4 <vprintfmt+0x68>
		switch (ch = *(unsigned char *) fmt++) {
  10221e:	89 eb                	mov    %ebp,%ebx
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  102220:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  102227:	eb bb                	jmp    1021e4 <vprintfmt+0x68>

00102229 <.L59>:
			for (precision = 0; ; ++fmt) {
  102229:	b8 00 00 00 00       	mov    $0x0,%eax
  10222e:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  102232:	8b 54 24 18          	mov    0x18(%esp),%edx
				precision = precision * 10 + ch - '0';
  102236:	8d 1c 80             	lea    (%eax,%eax,4),%ebx
  102239:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
  10223c:	8d 44 01 d0          	lea    -0x30(%ecx,%eax,1),%eax
				ch = *fmt;
  102240:	0f be 4d 00          	movsbl 0x0(%ebp),%ecx
				if (ch < '0' || ch > '9')
  102244:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  102247:	83 fb 09             	cmp    $0x9,%ebx
  10224a:	77 52                	ja     10229e <.L28+0xf>
			for (precision = 0; ; ++fmt) {
  10224c:	83 c5 01             	add    $0x1,%ebp
				precision = precision * 10 + ch - '0';
  10224f:	eb e5                	jmp    102236 <.L59+0xd>

00102251 <.L31>:
			precision = va_arg(ap, int);
  102251:	8b 44 24 4c          	mov    0x4c(%esp),%eax
  102255:	8d 48 04             	lea    0x4(%eax),%ecx
  102258:	89 4c 24 4c          	mov    %ecx,0x4c(%esp)
  10225c:	8b 00                	mov    (%eax),%eax
  10225e:	89 44 24 1c          	mov    %eax,0x1c(%esp)
		switch (ch = *(unsigned char *) fmt++) {
  102262:	89 eb                	mov    %ebp,%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  102264:	83 3c 24 00          	cmpl   $0x0,(%esp)
  102268:	0f 89 76 ff ff ff    	jns    1021e4 <vprintfmt+0x68>
				width = precision, precision = -1;
  10226e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  102272:	89 04 24             	mov    %eax,(%esp)
  102275:	c7 44 24 1c ff ff ff 	movl   $0xffffffff,0x1c(%esp)
  10227c:	ff 
  10227d:	e9 62 ff ff ff       	jmp    1021e4 <vprintfmt+0x68>

00102282 <.L32>:
			if (width < 0)
  102282:	83 3c 24 00          	cmpl   $0x0,(%esp)
  102286:	78 96                	js     10221e <.L58+0x9>
		switch (ch = *(unsigned char *) fmt++) {
  102288:	89 eb                	mov    %ebp,%ebx
  10228a:	e9 55 ff ff ff       	jmp    1021e4 <vprintfmt+0x68>

0010228f <.L28>:
  10228f:	89 eb                	mov    %ebp,%ebx
			altflag = 1;
  102291:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
  102298:	00 
			goto reswitch;
  102299:	e9 46 ff ff ff       	jmp    1021e4 <vprintfmt+0x68>
  10229e:	89 54 24 18          	mov    %edx,0x18(%esp)
  1022a2:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  1022a6:	89 eb                	mov    %ebp,%ebx
  1022a8:	eb ba                	jmp    102264 <.L31+0x13>

001022aa <.L36>:
			goto reswitch;

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  1022aa:	83 44 24 18 01       	addl   $0x1,0x18(%esp)
		switch (ch = *(unsigned char *) fmt++) {
  1022af:	89 eb                	mov    %ebp,%ebx
			goto reswitch;
  1022b1:	e9 2e ff ff ff       	jmp    1021e4 <vprintfmt+0x68>

001022b6 <.L34>:

			// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  1022b6:	8b 44 24 4c          	mov    0x4c(%esp),%eax
  1022ba:	8d 50 04             	lea    0x4(%eax),%edx
  1022bd:	89 54 24 4c          	mov    %edx,0x4c(%esp)
  1022c1:	83 ec 08             	sub    $0x8,%esp
  1022c4:	57                   	push   %edi
  1022c5:	ff 30                	pushl  (%eax)
  1022c7:	ff d6                	call   *%esi
			break;
  1022c9:	83 c4 10             	add    $0x10,%esp
  1022cc:	e9 cc fe ff ff       	jmp    10219d <vprintfmt+0x21>

001022d1 <.L38>:

			// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  1022d1:	8b 44 24 4c          	mov    0x4c(%esp),%eax
  1022d5:	8d 50 04             	lea    0x4(%eax),%edx
  1022d8:	89 54 24 4c          	mov    %edx,0x4c(%esp)
  1022dc:	8b 00                	mov    (%eax),%eax
  1022de:	89 44 24 08          	mov    %eax,0x8(%esp)
  1022e2:	85 c0                	test   %eax,%eax
  1022e4:	74 21                	je     102307 <.L38+0x36>
				p = "(null)";
			if (width > 0 && padc != '-')
  1022e6:	83 3c 24 00          	cmpl   $0x0,(%esp)
  1022ea:	0f 9f c2             	setg   %dl
  1022ed:	80 7c 24 17 2d       	cmpb   $0x2d,0x17(%esp)
  1022f2:	0f 95 c0             	setne  %al
  1022f5:	84 c2                	test   %al,%dl
  1022f7:	75 1e                	jne    102317 <.L38+0x46>
  1022f9:	8b 44 24 08          	mov    0x8(%esp),%eax
  1022fd:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
  102301:	89 6c 24 48          	mov    %ebp,0x48(%esp)
  102305:	eb 71                	jmp    102378 <.L38+0xa7>
				p = "(null)";
  102307:	8b 44 24 04          	mov    0x4(%esp),%eax
  10230b:	8d 80 6b ae ff ff    	lea    -0x5195(%eax),%eax
  102311:	89 44 24 08          	mov    %eax,0x8(%esp)
  102315:	eb cf                	jmp    1022e6 <.L38+0x15>
				for (width -= strnlen(p, precision);
  102317:	83 ec 08             	sub    $0x8,%esp
  10231a:	ff 74 24 24          	pushl  0x24(%esp)
  10231e:	ff 74 24 14          	pushl  0x14(%esp)
  102322:	8b 5c 24 14          	mov    0x14(%esp),%ebx
  102326:	e8 60 fa ff ff       	call   101d8b <strnlen>
  10232b:	29 44 24 10          	sub    %eax,0x10(%esp)
  10232f:	8b 54 24 10          	mov    0x10(%esp),%edx
  102333:	83 c4 10             	add    $0x10,%esp
  102336:	89 d3                	mov    %edx,%ebx
  102338:	eb 12                	jmp    10234c <.L38+0x7b>
				     width > 0;
				     width--)
					putch(padc, putdat);
  10233a:	83 ec 08             	sub    $0x8,%esp
  10233d:	57                   	push   %edi
  10233e:	0f be 44 24 23       	movsbl 0x23(%esp),%eax
  102343:	50                   	push   %eax
  102344:	ff d6                	call   *%esi
				     width--)
  102346:	83 eb 01             	sub    $0x1,%ebx
  102349:	83 c4 10             	add    $0x10,%esp
				for (width -= strnlen(p, precision);
  10234c:	85 db                	test   %ebx,%ebx
  10234e:	7f ea                	jg     10233a <.L38+0x69>
  102350:	89 1c 24             	mov    %ebx,(%esp)
  102353:	8b 44 24 08          	mov    0x8(%esp),%eax
  102357:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
  10235b:	89 6c 24 48          	mov    %ebp,0x48(%esp)
  10235f:	eb 17                	jmp    102378 <.L38+0xa7>
			for (;
			     (ch = *p++) != '\0' &&
				     (precision < 0 || --precision >= 0);
			     width--)
				if (altflag && (ch < ' ' || ch > '~'))
  102361:	83 7c 24 10 00       	cmpl   $0x0,0x10(%esp)
  102366:	75 2f                	jne    102397 <.L38+0xc6>
					putch('?', putdat);
				else
					putch(ch, putdat);
  102368:	83 ec 08             	sub    $0x8,%esp
  10236b:	57                   	push   %edi
  10236c:	50                   	push   %eax
  10236d:	ff d6                	call   *%esi
  10236f:	83 c4 10             	add    $0x10,%esp
			     width--)
  102372:	83 2c 24 01          	subl   $0x1,(%esp)
			     (ch = *p++) != '\0' &&
  102376:	89 e8                	mov    %ebp,%eax
  102378:	8d 68 01             	lea    0x1(%eax),%ebp
  10237b:	0f b6 10             	movzbl (%eax),%edx
  10237e:	0f be c2             	movsbl %dl,%eax
			for (;
  102381:	85 c0                	test   %eax,%eax
  102383:	74 41                	je     1023c6 <.L38+0xf5>
			     (ch = *p++) != '\0' &&
  102385:	85 db                	test   %ebx,%ebx
  102387:	78 d8                	js     102361 <.L38+0x90>
				     (precision < 0 || --precision >= 0);
  102389:	83 eb 01             	sub    $0x1,%ebx
  10238c:	79 d3                	jns    102361 <.L38+0x90>
  10238e:	8b 6c 24 48          	mov    0x48(%esp),%ebp
  102392:	8b 1c 24             	mov    (%esp),%ebx
  102395:	eb 26                	jmp    1023bd <.L38+0xec>
				if (altflag && (ch < ' ' || ch > '~'))
  102397:	0f be d2             	movsbl %dl,%edx
  10239a:	83 ea 20             	sub    $0x20,%edx
  10239d:	83 fa 5e             	cmp    $0x5e,%edx
  1023a0:	76 c6                	jbe    102368 <.L38+0x97>
					putch('?', putdat);
  1023a2:	83 ec 08             	sub    $0x8,%esp
  1023a5:	57                   	push   %edi
  1023a6:	6a 3f                	push   $0x3f
  1023a8:	ff d6                	call   *%esi
  1023aa:	83 c4 10             	add    $0x10,%esp
  1023ad:	eb c3                	jmp    102372 <.L38+0xa1>
			for (; width > 0; width--)
				putch(' ', putdat);
  1023af:	83 ec 08             	sub    $0x8,%esp
  1023b2:	57                   	push   %edi
  1023b3:	6a 20                	push   $0x20
  1023b5:	ff d6                	call   *%esi
			for (; width > 0; width--)
  1023b7:	83 eb 01             	sub    $0x1,%ebx
  1023ba:	83 c4 10             	add    $0x10,%esp
  1023bd:	85 db                	test   %ebx,%ebx
  1023bf:	7f ee                	jg     1023af <.L38+0xde>
  1023c1:	e9 d7 fd ff ff       	jmp    10219d <vprintfmt+0x21>
  1023c6:	8b 1c 24             	mov    (%esp),%ebx
  1023c9:	8b 6c 24 48          	mov    0x48(%esp),%ebp
  1023cd:	eb ee                	jmp    1023bd <.L38+0xec>

001023cf <.L35>:
  1023cf:	8b 54 24 18          	mov    0x18(%esp),%edx
			break;

			// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  1023d3:	8d 44 24 4c          	lea    0x4c(%esp),%eax
  1023d7:	e8 74 fd ff ff       	call   102150 <getint>
			if ((long long) num < 0) {
  1023dc:	89 44 24 08          	mov    %eax,0x8(%esp)
  1023e0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1023e4:	83 7c 24 0c 00       	cmpl   $0x0,0xc(%esp)
  1023e9:	0f 89 94 00 00 00    	jns    102483 <.L40+0x14>
				putch('-', putdat);
  1023ef:	83 ec 08             	sub    $0x8,%esp
  1023f2:	57                   	push   %edi
  1023f3:	6a 2d                	push   $0x2d
  1023f5:	ff d6                	call   *%esi
				num = -(long long) num;
  1023f7:	8b 44 24 18          	mov    0x18(%esp),%eax
  1023fb:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  1023ff:	f7 d8                	neg    %eax
  102401:	83 d2 00             	adc    $0x0,%edx
  102404:	f7 da                	neg    %edx
  102406:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  102409:	bb 0a 00 00 00       	mov    $0xa,%ebx
  10240e:	eb 12                	jmp    102422 <.L39+0x12>

00102410 <.L39>:
  102410:	8b 54 24 18          	mov    0x18(%esp),%edx
			goto number;

			// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  102414:	8d 44 24 4c          	lea    0x4c(%esp),%eax
  102418:	e8 ff fc ff ff       	call   10211c <getuint>
			base = 10;
  10241d:	bb 0a 00 00 00       	mov    $0xa,%ebx
			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  102422:	83 ec 0c             	sub    $0xc,%esp
  102425:	0f be 4c 24 23       	movsbl 0x23(%esp),%ecx
  10242a:	51                   	push   %ecx
  10242b:	ff 74 24 10          	pushl  0x10(%esp)
  10242f:	53                   	push   %ebx
  102430:	52                   	push   %edx
  102431:	50                   	push   %eax
  102432:	89 fa                	mov    %edi,%edx
  102434:	89 f0                	mov    %esi,%eax
  102436:	e8 0c fc ff ff       	call   102047 <printnum>
			break;
  10243b:	83 c4 20             	add    $0x20,%esp
  10243e:	e9 5a fd ff ff       	jmp    10219d <vprintfmt+0x21>

00102443 <.L37>:
			putch('0', putdat);
  102443:	83 ec 08             	sub    $0x8,%esp
  102446:	57                   	push   %edi
  102447:	6a 30                	push   $0x30
  102449:	ff d6                	call   *%esi
			putch('x', putdat);
  10244b:	83 c4 08             	add    $0x8,%esp
  10244e:	57                   	push   %edi
  10244f:	6a 78                	push   $0x78
  102451:	ff d6                	call   *%esi
				(uintptr_t) va_arg(ap, void *);
  102453:	8b 44 24 5c          	mov    0x5c(%esp),%eax
  102457:	8d 50 04             	lea    0x4(%eax),%edx
  10245a:	89 54 24 5c          	mov    %edx,0x5c(%esp)
			num = (unsigned long long)
  10245e:	8b 00                	mov    (%eax),%eax
  102460:	ba 00 00 00 00       	mov    $0x0,%edx
			goto number;
  102465:	83 c4 10             	add    $0x10,%esp
			base = 16;
  102468:	bb 10 00 00 00       	mov    $0x10,%ebx
			goto number;
  10246d:	eb b3                	jmp    102422 <.L39+0x12>

0010246f <.L40>:
  10246f:	8b 54 24 18          	mov    0x18(%esp),%edx
			num = getuint(&ap, lflag);
  102473:	8d 44 24 4c          	lea    0x4c(%esp),%eax
  102477:	e8 a0 fc ff ff       	call   10211c <getuint>
			base = 16;
  10247c:	bb 10 00 00 00       	mov    $0x10,%ebx
  102481:	eb 9f                	jmp    102422 <.L39+0x12>
			base = 10;
  102483:	bb 0a 00 00 00       	mov    $0xa,%ebx
  102488:	eb 98                	jmp    102422 <.L39+0x12>

0010248a <.L30>:
  10248a:	8b 4c 24 08          	mov    0x8(%esp),%ecx

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  10248e:	83 ec 08             	sub    $0x8,%esp
  102491:	57                   	push   %edi
  102492:	51                   	push   %ecx
  102493:	ff d6                	call   *%esi
			break;
  102495:	83 c4 10             	add    $0x10,%esp
  102498:	e9 00 fd ff ff       	jmp    10219d <vprintfmt+0x21>

0010249d <.L27>:

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  10249d:	83 ec 08             	sub    $0x8,%esp
  1024a0:	57                   	push   %edi
  1024a1:	6a 25                	push   $0x25
  1024a3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  1024a5:	83 c4 10             	add    $0x10,%esp
  1024a8:	89 dd                	mov    %ebx,%ebp
  1024aa:	eb 03                	jmp    1024af <.L27+0x12>
  1024ac:	83 ed 01             	sub    $0x1,%ebp
  1024af:	80 7d ff 25          	cmpb   $0x25,-0x1(%ebp)
  1024b3:	75 f7                	jne    1024ac <.L27+0xf>
  1024b5:	e9 e3 fc ff ff       	jmp    10219d <vprintfmt+0x21>
				/* do nothing */;
			break;
		}
	}
}
  1024ba:	83 c4 2c             	add    $0x2c,%esp
  1024bd:	5b                   	pop    %ebx
  1024be:	5e                   	pop    %esi
  1024bf:	5f                   	pop    %edi
  1024c0:	5d                   	pop    %ebp
  1024c1:	c3                   	ret    

001024c2 <__x86.get_pc_thunk.ax>:
  1024c2:	8b 04 24             	mov    (%esp),%eax
  1024c5:	c3                   	ret    

001024c6 <tss_switch>:

segdesc_t gdt_LOC[CPU_GDT_NDESC];
tss_t tss_LOC[64];

void tss_switch(uint32_t pid)
{
  1024c6:	55                   	push   %ebp
  1024c7:	57                   	push   %edi
  1024c8:	56                   	push   %esi
  1024c9:	53                   	push   %ebx
  1024ca:	83 ec 18             	sub    $0x18,%esp
  1024cd:	e8 3d de ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  1024d2:	81 c3 2e 8b 00 00    	add    $0x8b2e,%ebx
	gdt_LOC[CPU_GDT_TSS >> 3] =
		SEGDESC16(STS_T32A,
  1024d8:	69 54 24 2c ec 00 00 	imul   $0xec,0x2c(%esp),%edx
  1024df:	00 
  1024e0:	81 c2 40 b0 1a 00    	add    $0x1ab040,%edx
  1024e6:	89 d1                	mov    %edx,%ecx
  1024e8:	c1 e9 10             	shr    $0x10,%ecx
  1024eb:	89 d6                	mov    %edx,%esi
  1024ed:	c1 ee 18             	shr    $0x18,%esi
	gdt_LOC[CPU_GDT_TSS >> 3] =
  1024f0:	c7 c0 00 b0 1a 00    	mov    $0x1ab000,%eax
  1024f6:	66 c7 40 28 eb 00    	movw   $0xeb,0x28(%eax)
  1024fc:	66 89 50 2a          	mov    %dx,0x2a(%eax)
  102500:	88 48 2c             	mov    %cl,0x2c(%eax)
  102503:	0f b6 50 2d          	movzbl 0x2d(%eax),%edx
  102507:	83 e2 f0             	and    $0xfffffff0,%edx
  10250a:	83 ca 09             	or     $0x9,%edx
  10250d:	83 e2 9f             	and    $0xffffff9f,%edx
  102510:	83 ca 80             	or     $0xffffff80,%edx
  102513:	89 d5                	mov    %edx,%ebp
  102515:	0f b6 48 2e          	movzbl 0x2e(%eax),%ecx
  102519:	83 e1 c0             	and    $0xffffffc0,%ecx
  10251c:	83 c9 40             	or     $0x40,%ecx
  10251f:	83 e1 7f             	and    $0x7f,%ecx
  102522:	88 48 2e             	mov    %cl,0x2e(%eax)
  102525:	89 f1                	mov    %esi,%ecx
  102527:	88 48 2f             	mov    %cl,0x2f(%eax)
			  (uint32_t) (&tss_LOC[pid]), sizeof(tss_t) - 1, 0);
	gdt_LOC[CPU_GDT_TSS >> 3].sd_s = 0;
  10252a:	89 ea                	mov    %ebp,%edx
  10252c:	83 e2 ef             	and    $0xffffffef,%edx
  10252f:	88 50 2d             	mov    %dl,0x2d(%eax)
	ltr(CPU_GDT_TSS);
  102532:	6a 28                	push   $0x28
  102534:	e8 1c 03 00 00       	call   102855 <ltr>
}
  102539:	83 c4 1c             	add    $0x1c,%esp
  10253c:	5b                   	pop    %ebx
  10253d:	5e                   	pop    %esi
  10253e:	5f                   	pop    %edi
  10253f:	5d                   	pop    %ebp
  102540:	c3                   	ret    

00102541 <seg_init>:

void seg_init (void)
{
  102541:	55                   	push   %ebp
  102542:	57                   	push   %edi
  102543:	56                   	push   %esi
  102544:	53                   	push   %ebx
  102545:	83 ec 24             	sub    $0x24,%esp
  102548:	e8 c2 dd ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  10254d:	81 c3 b3 8a 00 00    	add    $0x8ab3,%ebx
	/* clear BSS */
	extern uint8_t end[], edata[];
	memzero (edata, bsp_kstack - edata);
  102553:	c7 c6 00 a0 16 00    	mov    $0x16a000,%esi
  102559:	c7 c0 10 73 12 00    	mov    $0x127310,%eax
  10255f:	89 f2                	mov    %esi,%edx
  102561:	29 c2                	sub    %eax,%edx
  102563:	52                   	push   %edx
  102564:	50                   	push   %eax
  102565:	e8 88 f8 ff ff       	call   101df2 <memzero>
	memzero (bsp_kstack + 4096, end - bsp_kstack - 4096);
  10256a:	c7 c0 20 0c df 00    	mov    $0xdf0c20,%eax
  102570:	2d 00 10 00 00       	sub    $0x1000,%eax
  102575:	29 f0                	sub    %esi,%eax
  102577:	83 c4 08             	add    $0x8,%esp
  10257a:	50                   	push   %eax
  10257b:	8d b6 00 10 00 00    	lea    0x1000(%esi),%esi
  102581:	56                   	push   %esi
  102582:	e8 6b f8 ff ff       	call   101df2 <memzero>

	/* setup GDT */
	gdt_LOC[0] = SEGDESC_NULL
  102587:	c7 c0 00 b0 1a 00    	mov    $0x1ab000,%eax
  10258d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  102593:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	;
	/* 0x08: kernel code */
	gdt_LOC[CPU_GDT_KCODE >> 3] = SEGDESC32(STA_X | STA_R, 0x0, 0xffffffff, 0);
  10259a:	66 c7 40 08 ff ff    	movw   $0xffff,0x8(%eax)
  1025a0:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
  1025a6:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
  1025aa:	0f b6 50 0d          	movzbl 0xd(%eax),%edx
  1025ae:	83 e2 f0             	and    $0xfffffff0,%edx
  1025b1:	83 ca 1a             	or     $0x1a,%edx
  1025b4:	83 e2 9f             	and    $0xffffff9f,%edx
  1025b7:	83 ca 80             	or     $0xffffff80,%edx
  1025ba:	88 50 0d             	mov    %dl,0xd(%eax)
  1025bd:	0f b6 50 0e          	movzbl 0xe(%eax),%edx
  1025c1:	83 ca 0f             	or     $0xf,%edx
  1025c4:	83 e2 cf             	and    $0xffffffcf,%edx
  1025c7:	83 ca c0             	or     $0xffffffc0,%edx
  1025ca:	88 50 0e             	mov    %dl,0xe(%eax)
  1025cd:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
	/* 0x10: kernel data */
	gdt_LOC[CPU_GDT_KDATA >> 3] = SEGDESC32(STA_W, 0x0, 0xffffffff, 0);
  1025d1:	66 c7 40 10 ff ff    	movw   $0xffff,0x10(%eax)
  1025d7:	66 c7 40 12 00 00    	movw   $0x0,0x12(%eax)
  1025dd:	c6 40 14 00          	movb   $0x0,0x14(%eax)
  1025e1:	0f b6 50 15          	movzbl 0x15(%eax),%edx
  1025e5:	83 e2 f0             	and    $0xfffffff0,%edx
  1025e8:	83 ca 12             	or     $0x12,%edx
  1025eb:	83 e2 9f             	and    $0xffffff9f,%edx
  1025ee:	83 ca 80             	or     $0xffffff80,%edx
  1025f1:	88 50 15             	mov    %dl,0x15(%eax)
  1025f4:	0f b6 50 16          	movzbl 0x16(%eax),%edx
  1025f8:	83 ca 0f             	or     $0xf,%edx
  1025fb:	83 e2 cf             	and    $0xffffffcf,%edx
  1025fe:	83 ca c0             	or     $0xffffffc0,%edx
  102601:	88 50 16             	mov    %dl,0x16(%eax)
  102604:	c6 40 17 00          	movb   $0x0,0x17(%eax)
	/* 0x18: user code */
	gdt_LOC[CPU_GDT_UCODE >> 3] = SEGDESC32(STA_X | STA_R, 0x00000000,
  102608:	66 c7 40 18 ff ff    	movw   $0xffff,0x18(%eax)
  10260e:	66 c7 40 1a 00 00    	movw   $0x0,0x1a(%eax)
  102614:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
  102618:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
  10261c:	0f b6 50 1e          	movzbl 0x1e(%eax),%edx
  102620:	83 ca 0f             	or     $0xf,%edx
  102623:	83 e2 cf             	and    $0xffffffcf,%edx
  102626:	83 ca c0             	or     $0xffffffc0,%edx
  102629:	88 50 1e             	mov    %dl,0x1e(%eax)
  10262c:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
		0xffffffff, 3);
	/* 0x20: user data */
	gdt_LOC[CPU_GDT_UDATA >> 3] = SEGDESC32(STA_W, 0x00000000, 0xffffffff, 3);
  102630:	66 c7 40 20 ff ff    	movw   $0xffff,0x20(%eax)
  102636:	66 c7 40 22 00 00    	movw   $0x0,0x22(%eax)
  10263c:	c6 40 24 00          	movb   $0x0,0x24(%eax)
  102640:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
  102644:	0f b6 50 26          	movzbl 0x26(%eax),%edx
  102648:	83 ca 0f             	or     $0xf,%edx
  10264b:	83 e2 cf             	and    $0xffffffcf,%edx
  10264e:	83 ca c0             	or     $0xffffffc0,%edx
  102651:	88 50 26             	mov    %dl,0x26(%eax)
  102654:	c6 40 27 00          	movb   $0x0,0x27(%eax)

	/* setup TSS */
	tss0.ts_esp0 = (uint32_t) bsp_kstack + 4096;
  102658:	89 b3 64 de 01 00    	mov    %esi,0x1de64(%ebx)
	tss0.ts_ss0 = CPU_GDT_KDATA;
  10265e:	66 c7 83 68 de 01 00 	movw   $0x10,0x1de68(%ebx)
  102665:	10 00 
	gdt_LOC[CPU_GDT_TSS >> 3] = SEGDESC16(STS_T32A, (uint32_t) (&tss0),
  102667:	66 c7 40 28 eb 00    	movw   $0xeb,0x28(%eax)
  10266d:	8d b3 60 de 01 00    	lea    0x1de60(%ebx),%esi
  102673:	66 89 70 2a          	mov    %si,0x2a(%eax)
  102677:	89 f2                	mov    %esi,%edx
  102679:	c1 ea 10             	shr    $0x10,%edx
  10267c:	88 50 2c             	mov    %dl,0x2c(%eax)
  10267f:	0f b6 50 2d          	movzbl 0x2d(%eax),%edx
  102683:	83 e2 f0             	and    $0xfffffff0,%edx
  102686:	83 ca 09             	or     $0x9,%edx
  102689:	83 e2 9f             	and    $0xffffff9f,%edx
  10268c:	83 ca 80             	or     $0xffffff80,%edx
  10268f:	89 d5                	mov    %edx,%ebp
  102691:	0f b6 48 2e          	movzbl 0x2e(%eax),%ecx
  102695:	83 e1 c0             	and    $0xffffffc0,%ecx
  102698:	83 c9 40             	or     $0x40,%ecx
  10269b:	83 e1 7f             	and    $0x7f,%ecx
  10269e:	88 48 2e             	mov    %cl,0x2e(%eax)
  1026a1:	c1 ee 18             	shr    $0x18,%esi
  1026a4:	89 f1                	mov    %esi,%ecx
  1026a6:	88 48 2f             	mov    %cl,0x2f(%eax)
		sizeof(tss_t) - 1, 0);
	gdt_LOC[CPU_GDT_TSS >> 3].sd_s = 0;
  1026a9:	89 ea                	mov    %ebp,%edx
  1026ab:	83 e2 ef             	and    $0xffffffef,%edx
  1026ae:	88 50 2d             	mov    %dl,0x2d(%eax)

	pseudodesc_t gdt_desc =
  1026b1:	66 c7 44 24 1a 2f 00 	movw   $0x2f,0x1a(%esp)
  1026b8:	89 44 24 1c          	mov    %eax,0x1c(%esp)
		{ .pd_lim = sizeof(gdt_LOC) - 1, .pd_base = (uint32_t) gdt_LOC };
	asm volatile("lgdt %0" :: "m" (gdt_desc));
  1026bc:	0f 01 54 24 1a       	lgdtl  0x1a(%esp)
	asm volatile("movw %%ax,%%gs" :: "a" (CPU_GDT_KDATA));
  1026c1:	b8 10 00 00 00       	mov    $0x10,%eax
  1026c6:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" :: "a" (CPU_GDT_KDATA));
  1026c8:	8e e0                	mov    %eax,%fs
	asm volatile("movw %%ax,%%es" :: "a" (CPU_GDT_KDATA));
  1026ca:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" :: "a" (CPU_GDT_KDATA));
  1026cc:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" :: "a" (CPU_GDT_KDATA));
  1026ce:	8e d0                	mov    %eax,%ss
	/* reload %cs */
	asm volatile("ljmp %0,$1f\n 1:\n" :: "i" (CPU_GDT_KCODE));
  1026d0:	ea d7 26 10 00 08 00 	ljmp   $0x8,$0x1026d7

	/*
	 * Load a null LDT.
	 */
	lldt (0);
  1026d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1026de:	e8 e7 00 00 00       	call   1027ca <lldt>

	/*
	 * Load the bootstrap TSS.
	 */
	ltr (CPU_GDT_TSS);
  1026e3:	c7 04 24 28 00 00 00 	movl   $0x28,(%esp)
  1026ea:	e8 66 01 00 00       	call   102855 <ltr>

	/*
	 * Load IDT.
	 */
	extern pseudodesc_t idt_pd;
	asm volatile("lidt %0" : : "m" (idt_pd));
  1026ef:	c7 c0 20 b3 10 00    	mov    $0x10b320,%eax
  1026f5:	0f 01 18             	lidtl  (%eax)

	/*
	 * Initialize all TSS structures for processes.
	 */
	unsigned int pid;
	memzero (tss_LOC, sizeof(tss_t) * 64);
  1026f8:	83 c4 08             	add    $0x8,%esp
  1026fb:	68 00 3b 00 00       	push   $0x3b00
  102700:	ff b3 f4 ff ff ff    	pushl  -0xc(%ebx)
  102706:	e8 e7 f6 ff ff       	call   101df2 <memzero>
	memzero (STACK_LOC, sizeof(char) * 64 * 4096);
  10270b:	83 c4 08             	add    $0x8,%esp
  10270e:	68 00 00 04 00       	push   $0x40000
  102713:	ff b3 ec ff ff ff    	pushl  -0x14(%ebx)
  102719:	e8 d4 f6 ff ff       	call   101df2 <memzero>
	for (pid = 0; pid < 64; pid++)
  10271e:	83 c4 10             	add    $0x10,%esp
  102721:	be 00 00 00 00       	mov    $0x0,%esi
  102726:	eb 4d                	jmp    102775 <seg_init+0x234>
	{
		tss_LOC[pid].ts_esp0 = (uint32_t) STACK_LOC[pid] + 4096;
  102728:	89 f0                	mov    %esi,%eax
  10272a:	c1 e0 0c             	shl    $0xc,%eax
  10272d:	81 c0 00 b0 16 00    	add    $0x16b000,%eax
  102733:	05 00 10 00 00       	add    $0x1000,%eax
  102738:	c7 c1 40 b0 1a 00    	mov    $0x1ab040,%ecx
  10273e:	69 d6 ec 00 00 00    	imul   $0xec,%esi,%edx
  102744:	8d 3c 11             	lea    (%ecx,%edx,1),%edi
  102747:	89 47 04             	mov    %eax,0x4(%edi)
		tss_LOC[pid].ts_ss0 = CPU_GDT_KDATA;
  10274a:	66 c7 47 08 10 00    	movw   $0x10,0x8(%edi)
		tss_LOC[pid].ts_iomb = offsetof(tss_t, ts_iopm);
  102750:	66 c7 47 66 68 00    	movw   $0x68,0x66(%edi)
		memzero (tss_LOC[pid].ts_iopm, sizeof(uint8_t) * 128);
  102756:	8d 44 11 68          	lea    0x68(%ecx,%edx,1),%eax
  10275a:	83 ec 08             	sub    $0x8,%esp
  10275d:	68 80 00 00 00       	push   $0x80
  102762:	50                   	push   %eax
  102763:	e8 8a f6 ff ff       	call   101df2 <memzero>
		tss_LOC[pid].ts_iopm[128] = 0xff;
  102768:	c6 87 e8 00 00 00 ff 	movb   $0xff,0xe8(%edi)
	for (pid = 0; pid < 64; pid++)
  10276f:	83 c6 01             	add    $0x1,%esi
  102772:	83 c4 10             	add    $0x10,%esp
  102775:	83 fe 3f             	cmp    $0x3f,%esi
  102778:	76 ae                	jbe    102728 <seg_init+0x1e7>
	}
}
  10277a:	83 c4 1c             	add    $0x1c,%esp
  10277d:	5b                   	pop    %ebx
  10277e:	5e                   	pop    %esi
  10277f:	5f                   	pop    %edi
  102780:	5d                   	pop    %ebp
  102781:	c3                   	ret    

00102782 <max>:
#include "types.h"

uint32_t
max(uint32_t a, uint32_t b)
{
  102782:	8b 54 24 04          	mov    0x4(%esp),%edx
  102786:	8b 44 24 08          	mov    0x8(%esp),%eax
	return (a > b) ? a : b;
  10278a:	39 d0                	cmp    %edx,%eax
  10278c:	0f 42 c2             	cmovb  %edx,%eax
}
  10278f:	c3                   	ret    

00102790 <min>:

uint32_t
min(uint32_t a, uint32_t b)
{
  102790:	8b 54 24 04          	mov    0x4(%esp),%edx
  102794:	8b 44 24 08          	mov    0x8(%esp),%eax
	return (a < b) ? a : b;
  102798:	39 d0                	cmp    %edx,%eax
  10279a:	0f 47 c2             	cmova  %edx,%eax
}
  10279d:	c3                   	ret    

0010279e <rounddown>:

uint32_t
rounddown(uint32_t a, uint32_t n)
{
  10279e:	8b 4c 24 04          	mov    0x4(%esp),%ecx
	return a - a % n;
  1027a2:	89 c8                	mov    %ecx,%eax
  1027a4:	ba 00 00 00 00       	mov    $0x0,%edx
  1027a9:	f7 74 24 08          	divl   0x8(%esp)
  1027ad:	89 c8                	mov    %ecx,%eax
  1027af:	29 d0                	sub    %edx,%eax
}
  1027b1:	c3                   	ret    

001027b2 <roundup>:

uint32_t
roundup(uint32_t a, uint32_t n)
{
  1027b2:	8b 54 24 08          	mov    0x8(%esp),%edx
	return rounddown(a+n-1, n);
  1027b6:	89 d0                	mov    %edx,%eax
  1027b8:	03 44 24 04          	add    0x4(%esp),%eax
  1027bc:	52                   	push   %edx
  1027bd:	83 e8 01             	sub    $0x1,%eax
  1027c0:	50                   	push   %eax
  1027c1:	e8 d8 ff ff ff       	call   10279e <rounddown>
  1027c6:	83 c4 08             	add    $0x8,%esp
}
  1027c9:	c3                   	ret    

001027ca <lldt>:
#include "x86.h"

gcc_inline void
lldt(uint16_t sel)
{
	__asm __volatile("lldt %0" : : "r" (sel));
  1027ca:	8b 44 24 04          	mov    0x4(%esp),%eax
  1027ce:	0f 00 d0             	lldt   %ax
}
  1027d1:	c3                   	ret    

001027d2 <cli>:

gcc_inline void
cli(void)
{
	__asm __volatile("cli":::"memory");
  1027d2:	fa                   	cli    
}
  1027d3:	c3                   	ret    

001027d4 <sti>:

gcc_inline void
sti(void)
{
	__asm __volatile("sti;nop");
  1027d4:	fb                   	sti    
  1027d5:	90                   	nop
}
  1027d6:	c3                   	ret    

001027d7 <rdmsr>:

gcc_inline uint64_t
rdmsr(uint32_t msr)
{
	uint64_t rv;
	__asm __volatile("rdmsr" : "=A" (rv) : "c" (msr));
  1027d7:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  1027db:	0f 32                	rdmsr  
	return rv;
}
  1027dd:	c3                   	ret    

001027de <wrmsr>:

gcc_inline void
wrmsr(uint32_t msr, uint64_t newval)
{
        __asm __volatile("wrmsr" : : "A" (newval), "c" (msr));
  1027de:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  1027e2:	8b 44 24 08          	mov    0x8(%esp),%eax
  1027e6:	8b 54 24 0c          	mov    0xc(%esp),%edx
  1027ea:	0f 30                	wrmsr  
}
  1027ec:	c3                   	ret    

001027ed <halt>:

gcc_inline void
halt(void)
{
	__asm __volatile("hlt");
  1027ed:	f4                   	hlt    
}
  1027ee:	c3                   	ret    

001027ef <rdtsc>:
gcc_inline uint64_t
rdtsc(void)
{
	uint64_t rv;

	__asm __volatile("rdtsc" : "=A" (rv));
  1027ef:	0f 31                	rdtsc  
	return (rv);
}
  1027f1:	c3                   	ret    

001027f2 <enable_sse>:

gcc_inline uint32_t
rcr4(void)
{
	uint32_t cr4;
	__asm __volatile("movl %%cr4,%0" : "=r" (cr4));
  1027f2:	0f 20 e0             	mov    %cr4,%eax
	cr4 = rcr4() | CR4_OSFXSR | CR4_OSXMMEXCPT;
  1027f5:	80 cc 06             	or     $0x6,%ah
	FENCE();
  1027f8:	0f ae f0             	mfence 
	__asm __volatile("movl %0,%%cr4" : : "r" (val));
  1027fb:	0f 22 e0             	mov    %eax,%cr4
	__asm __volatile("movl %%cr0,%0" : "=r" (val));
  1027fe:	0f 20 c0             	mov    %cr0,%eax
	FENCE();
  102801:	0f ae f0             	mfence 
}
  102804:	c3                   	ret    

00102805 <cpuid>:
{
  102805:	55                   	push   %ebp
  102806:	57                   	push   %edi
  102807:	56                   	push   %esi
  102808:	53                   	push   %ebx
  102809:	8b 44 24 14          	mov    0x14(%esp),%eax
  10280d:	8b 7c 24 18          	mov    0x18(%esp),%edi
  102811:	8b 6c 24 1c          	mov    0x1c(%esp),%ebp
  102815:	8b 74 24 24          	mov    0x24(%esp),%esi
	__asm __volatile("cpuid"
  102819:	0f a2                	cpuid  
	if (eaxp)
  10281b:	85 ff                	test   %edi,%edi
  10281d:	74 02                	je     102821 <cpuid+0x1c>
		*eaxp = eax;
  10281f:	89 07                	mov    %eax,(%edi)
	if (ebxp)
  102821:	85 ed                	test   %ebp,%ebp
  102823:	74 03                	je     102828 <cpuid+0x23>
		*ebxp = ebx;
  102825:	89 5d 00             	mov    %ebx,0x0(%ebp)
	if (ecxp)
  102828:	83 7c 24 20 00       	cmpl   $0x0,0x20(%esp)
  10282d:	74 06                	je     102835 <cpuid+0x30>
		*ecxp = ecx;
  10282f:	8b 44 24 20          	mov    0x20(%esp),%eax
  102833:	89 08                	mov    %ecx,(%eax)
	if (edxp)
  102835:	85 f6                	test   %esi,%esi
  102837:	74 02                	je     10283b <cpuid+0x36>
		*edxp = edx;
  102839:	89 16                	mov    %edx,(%esi)
}
  10283b:	5b                   	pop    %ebx
  10283c:	5e                   	pop    %esi
  10283d:	5f                   	pop    %edi
  10283e:	5d                   	pop    %ebp
  10283f:	c3                   	ret    

00102840 <rcr3>:
    __asm __volatile("movl %%cr3,%0" : "=r" (val));
  102840:	0f 20 d8             	mov    %cr3,%eax
}
  102843:	c3                   	ret    

00102844 <outl>:
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
  102844:	8b 54 24 04          	mov    0x4(%esp),%edx
  102848:	8b 44 24 08          	mov    0x8(%esp),%eax
  10284c:	ef                   	out    %eax,(%dx)
}
  10284d:	c3                   	ret    

0010284e <inl>:
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
  10284e:	8b 54 24 04          	mov    0x4(%esp),%edx
  102852:	ed                   	in     (%dx),%eax
}
  102853:	c3                   	ret    

00102854 <smp_wmb>:
}
  102854:	c3                   	ret    

00102855 <ltr>:
	__asm __volatile("ltr %0" : : "r" (sel));
  102855:	8b 44 24 04          	mov    0x4(%esp),%eax
  102859:	0f 00 d8             	ltr    %ax
}
  10285c:	c3                   	ret    

0010285d <lcr0>:
	__asm __volatile("movl %0,%%cr0" : : "r" (val));
  10285d:	8b 44 24 04          	mov    0x4(%esp),%eax
  102861:	0f 22 c0             	mov    %eax,%cr0
}
  102864:	c3                   	ret    

00102865 <rcr0>:
	__asm __volatile("movl %%cr0,%0" : "=r" (val));
  102865:	0f 20 c0             	mov    %cr0,%eax
}
  102868:	c3                   	ret    

00102869 <rcr2>:
	__asm __volatile("movl %%cr2,%0" : "=r" (val));
  102869:	0f 20 d0             	mov    %cr2,%eax
}
  10286c:	c3                   	ret    

0010286d <lcr3>:
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
  10286d:	8b 44 24 04          	mov    0x4(%esp),%eax
  102871:	0f 22 d8             	mov    %eax,%cr3
}
  102874:	c3                   	ret    

00102875 <lcr4>:
	__asm __volatile("movl %0,%%cr4" : : "r" (val));
  102875:	8b 44 24 04          	mov    0x4(%esp),%eax
  102879:	0f 22 e0             	mov    %eax,%cr4
}
  10287c:	c3                   	ret    

0010287d <rcr4>:
	__asm __volatile("movl %%cr4,%0" : "=r" (cr4));
  10287d:	0f 20 e0             	mov    %cr4,%eax
	return cr4;
}
  102880:	c3                   	ret    

00102881 <inb>:

gcc_inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  102881:	8b 54 24 04          	mov    0x4(%esp),%edx
  102885:	ec                   	in     (%dx),%al
	return data;
}
  102886:	c3                   	ret    

00102887 <insl>:

gcc_inline void
insl(int port, void *addr, int cnt)
{
  102887:	57                   	push   %edi
	__asm __volatile("cld\n\trepne\n\tinsl"                 :
  102888:	8b 7c 24 0c          	mov    0xc(%esp),%edi
  10288c:	8b 4c 24 10          	mov    0x10(%esp),%ecx
  102890:	8b 54 24 08          	mov    0x8(%esp),%edx
  102894:	fc                   	cld    
  102895:	f2 6d                	repnz insl (%dx),%es:(%edi)
			 "=D" (addr), "=c" (cnt)                :
			 "d" (port), "0" (addr), "1" (cnt)      :
			 "memory", "cc");
}
  102897:	5f                   	pop    %edi
  102898:	c3                   	ret    

00102899 <outb>:

gcc_inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  102899:	8b 54 24 04          	mov    0x4(%esp),%edx
  10289d:	8b 44 24 08          	mov    0x8(%esp),%eax
  1028a1:	ee                   	out    %al,(%dx)
}
  1028a2:	c3                   	ret    

001028a3 <outsw>:

gcc_inline void
outsw(int port, const void *addr, int cnt)
{
  1028a3:	56                   	push   %esi
	__asm __volatile("cld\n\trepne\n\toutsw"                :
  1028a4:	8b 74 24 0c          	mov    0xc(%esp),%esi
  1028a8:	8b 4c 24 10          	mov    0x10(%esp),%ecx
  1028ac:	8b 54 24 08          	mov    0x8(%esp),%edx
  1028b0:	fc                   	cld    
  1028b1:	f2 66 6f             	repnz outsw %ds:(%esi),(%dx)
			 "=S" (addr), "=c" (cnt)                :
			 "d" (port), "0" (addr), "1" (cnt)      :
			 "cc");
}
  1028b4:	5e                   	pop    %esi
  1028b5:	c3                   	ret    

001028b6 <mon_start_user>:
extern void set_curid(unsigned int);
extern void kctx_switch(unsigned int, unsigned int);

int
mon_start_user (int argc, char **argv, struct Trapframe *tf)
{
  1028b6:	57                   	push   %edi
  1028b7:	56                   	push   %esi
  1028b8:	53                   	push   %ebx
  1028b9:	e8 51 da ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  1028be:	81 c3 42 87 00 00    	add    $0x8742,%ebx
    unsigned int idle_pid;
    idle_pid = proc_create (_binary___obj_user_idle_idle_start, 10000);
  1028c4:	83 ec 08             	sub    $0x8,%esp
  1028c7:	68 10 27 00 00       	push   $0x2710
  1028cc:	ff b3 e4 ff ff ff    	pushl  -0x1c(%ebx)
  1028d2:	e8 29 29 00 00       	call   105200 <proc_create>
  1028d7:	89 c6                	mov    %eax,%esi
    KERN_DEBUG("process idle %d is created.\n", idle_pid);
  1028d9:	50                   	push   %eax
  1028da:	8d 83 cc af ff ff    	lea    -0x5034(%ebx),%eax
  1028e0:	50                   	push   %eax
  1028e1:	6a 2d                	push   $0x2d
  1028e3:	8d bb e9 af ff ff    	lea    -0x5017(%ebx),%edi
  1028e9:	57                   	push   %edi
  1028ea:	e8 74 f5 ff ff       	call   101e63 <debug_normal>

    KERN_INFO("Start user-space ... \n");
  1028ef:	83 c4 14             	add    $0x14,%esp
  1028f2:	8d 83 fc af ff ff    	lea    -0x5004(%ebx),%eax
  1028f8:	50                   	push   %eax
  1028f9:	e8 40 f5 ff ff       	call   101e3e <debug_info>

    tqueue_remove (NUM_IDS, idle_pid);
  1028fe:	83 c4 08             	add    $0x8,%esp
  102901:	56                   	push   %esi
  102902:	6a 40                	push   $0x40
  102904:	e8 97 24 00 00       	call   104da0 <tqueue_remove>
    tcb_set_state (idle_pid, TSTATE_RUN);
  102909:	83 c4 08             	add    $0x8,%esp
  10290c:	6a 01                	push   $0x1
  10290e:	56                   	push   %esi
  10290f:	e8 cc 21 00 00       	call   104ae0 <tcb_set_state>
    set_curid (idle_pid);
  102914:	89 34 24             	mov    %esi,(%esp)
  102917:	e8 b4 27 00 00       	call   1050d0 <set_curid>
    kctx_switch (0, idle_pid);
  10291c:	83 c4 08             	add    $0x8,%esp
  10291f:	56                   	push   %esi
  102920:	6a 00                	push   $0x0
  102922:	e8 99 20 00 00       	call   1049c0 <kctx_switch>

    KERN_PANIC("mon_startuser() should never reach here.\n");
  102927:	83 c4 0c             	add    $0xc,%esp
  10292a:	8d 83 00 b1 ff ff    	lea    -0x4f00(%ebx),%eax
  102930:	50                   	push   %eax
  102931:	6a 36                	push   $0x36
  102933:	57                   	push   %edi
  102934:	e8 63 f5 ff ff       	call   101e9c <debug_panic>
}
  102939:	83 c4 10             	add    $0x10,%esp
  10293c:	5b                   	pop    %ebx
  10293d:	5e                   	pop    %esi
  10293e:	5f                   	pop    %edi
  10293f:	c3                   	ret    

00102940 <mon_help>:

int
mon_help (int argc, char **argv, struct Trapframe *tf)
{
  102940:	56                   	push   %esi
  102941:	53                   	push   %ebx
  102942:	83 ec 04             	sub    $0x4,%esp
  102945:	e8 c5 d9 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  10294a:	81 c3 b6 86 00 00    	add    $0x86b6,%ebx
	int i;

	for (i = 0; i < NCOMMANDS; i++)
  102950:	be 00 00 00 00       	mov    $0x0,%esi
  102955:	eb 30                	jmp    102987 <mon_help+0x47>
		dprintf("%s - %s\n", commands[i].name, commands[i].desc);
  102957:	83 ec 04             	sub    $0x4,%esp
  10295a:	8d 04 36             	lea    (%esi,%esi,1),%eax
  10295d:	8d 0c 30             	lea    (%eax,%esi,1),%ecx
  102960:	8d 14 8d 00 00 00 00 	lea    0x0(,%ecx,4),%edx
  102967:	ff b4 13 c4 ff ff ff 	pushl  -0x3c(%ebx,%edx,1)
  10296e:	ff b4 13 c0 ff ff ff 	pushl  -0x40(%ebx,%edx,1)
  102975:	8d 83 13 b0 ff ff    	lea    -0x4fed(%ebx),%eax
  10297b:	50                   	push   %eax
  10297c:	e8 ae f6 ff ff       	call   10202f <dprintf>
	for (i = 0; i < NCOMMANDS; i++)
  102981:	83 c6 01             	add    $0x1,%esi
  102984:	83 c4 10             	add    $0x10,%esp
  102987:	83 fe 02             	cmp    $0x2,%esi
  10298a:	76 cb                	jbe    102957 <mon_help+0x17>
	return 0;
}
  10298c:	b8 00 00 00 00       	mov    $0x0,%eax
  102991:	83 c4 04             	add    $0x4,%esp
  102994:	5b                   	pop    %ebx
  102995:	5e                   	pop    %esi
  102996:	c3                   	ret    

00102997 <mon_kerninfo>:

int
mon_kerninfo (int argc, char **argv, struct Trapframe *tf)
{
  102997:	57                   	push   %edi
  102998:	56                   	push   %esi
  102999:	53                   	push   %ebx
  10299a:	e8 70 d9 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  10299f:	81 c3 61 86 00 00    	add    $0x8661,%ebx
	extern uint8_t start[], etext[], edata[], end[];

	dprintf("Special kernel symbols:\n");
  1029a5:	83 ec 0c             	sub    $0xc,%esp
  1029a8:	8d 83 1c b0 ff ff    	lea    -0x4fe4(%ebx),%eax
  1029ae:	50                   	push   %eax
  1029af:	e8 7b f6 ff ff       	call   10202f <dprintf>
	dprintf("  start  %08x\n", start);
  1029b4:	83 c4 08             	add    $0x8,%esp
  1029b7:	c7 c7 b4 32 10 00    	mov    $0x1032b4,%edi
  1029bd:	57                   	push   %edi
  1029be:	8d 83 35 b0 ff ff    	lea    -0x4fcb(%ebx),%eax
  1029c4:	50                   	push   %eax
  1029c5:	e8 65 f6 ff ff       	call   10202f <dprintf>
	dprintf("  etext  %08x\n", etext);
  1029ca:	83 c4 08             	add    $0x8,%esp
  1029cd:	ff b3 f0 ff ff ff    	pushl  -0x10(%ebx)
  1029d3:	8d 83 44 b0 ff ff    	lea    -0x4fbc(%ebx),%eax
  1029d9:	50                   	push   %eax
  1029da:	e8 50 f6 ff ff       	call   10202f <dprintf>
	dprintf("  edata  %08x\n", edata);
  1029df:	83 c4 08             	add    $0x8,%esp
  1029e2:	ff b3 e8 ff ff ff    	pushl  -0x18(%ebx)
  1029e8:	8d 83 53 b0 ff ff    	lea    -0x4fad(%ebx),%eax
  1029ee:	50                   	push   %eax
  1029ef:	e8 3b f6 ff ff       	call   10202f <dprintf>
	dprintf("  end    %08x\n", end);
  1029f4:	83 c4 08             	add    $0x8,%esp
  1029f7:	c7 c6 20 0c df 00    	mov    $0xdf0c20,%esi
  1029fd:	56                   	push   %esi
  1029fe:	8d 83 62 b0 ff ff    	lea    -0x4f9e(%ebx),%eax
  102a04:	50                   	push   %eax
  102a05:	e8 25 f6 ff ff       	call   10202f <dprintf>
	dprintf("Kernel executable memory footprint: %dKB\n",
		ROUNDUP(end - start, 1024) / 1024);
  102a0a:	29 fe                	sub    %edi,%esi
  102a0c:	8d 86 ff 03 00 00    	lea    0x3ff(%esi),%eax
  102a12:	89 c1                	mov    %eax,%ecx
  102a14:	c1 f9 1f             	sar    $0x1f,%ecx
  102a17:	c1 e9 16             	shr    $0x16,%ecx
  102a1a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  102a1d:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  102a23:	29 ca                	sub    %ecx,%edx
  102a25:	29 d0                	sub    %edx,%eax
	dprintf("Kernel executable memory footprint: %dKB\n",
  102a27:	83 c4 08             	add    $0x8,%esp
  102a2a:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  102a30:	85 c0                	test   %eax,%eax
  102a32:	0f 49 d0             	cmovns %eax,%edx
  102a35:	c1 fa 0a             	sar    $0xa,%edx
  102a38:	52                   	push   %edx
  102a39:	8d 83 2c b1 ff ff    	lea    -0x4ed4(%ebx),%eax
  102a3f:	50                   	push   %eax
  102a40:	e8 ea f5 ff ff       	call   10202f <dprintf>
	return 0;
  102a45:	83 c4 10             	add    $0x10,%esp
}
  102a48:	b8 00 00 00 00       	mov    $0x0,%eax
  102a4d:	5b                   	pop    %ebx
  102a4e:	5e                   	pop    %esi
  102a4f:	5f                   	pop    %edi
  102a50:	c3                   	ret    

00102a51 <runcmd>:
#define WHITESPACE "\t\r\n "
#define MAXARGS 16

static int
runcmd (char *buf, struct Trapframe *tf)
{
  102a51:	55                   	push   %ebp
  102a52:	57                   	push   %edi
  102a53:	56                   	push   %esi
  102a54:	53                   	push   %ebx
  102a55:	83 ec 5c             	sub    $0x5c,%esp
  102a58:	e8 b2 d8 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  102a5d:	81 c3 a3 85 00 00    	add    $0x85a3,%ebx
  102a63:	89 c6                	mov    %eax,%esi
  102a65:	89 54 24 0c          	mov    %edx,0xc(%esp)
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
  102a69:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  102a70:	00 
	argc = 0;
  102a71:	bf 00 00 00 00       	mov    $0x0,%edi
  102a76:	eb 6d                	jmp    102ae5 <runcmd+0x94>
	while (1)
	{
		// gobble whitespace
		while (*buf && strchr (WHITESPACE, *buf))
  102a78:	83 ec 08             	sub    $0x8,%esp
  102a7b:	0f be c0             	movsbl %al,%eax
  102a7e:	50                   	push   %eax
  102a7f:	8d 83 71 b0 ff ff    	lea    -0x4f8f(%ebx),%eax
  102a85:	50                   	push   %eax
  102a86:	e8 47 f3 ff ff       	call   101dd2 <strchr>
  102a8b:	83 c4 10             	add    $0x10,%esp
  102a8e:	85 c0                	test   %eax,%eax
  102a90:	74 5a                	je     102aec <runcmd+0x9b>
			*buf++ = 0;
  102a92:	c6 06 00             	movb   $0x0,(%esi)
  102a95:	89 fd                	mov    %edi,%ebp
  102a97:	8d 76 01             	lea    0x1(%esi),%esi
  102a9a:	eb 47                	jmp    102ae3 <runcmd+0x92>
			break;

		// save and scan past next arg
		if (argc == MAXARGS - 1)
		{
			dprintf("Too many arguments (max %d)\n", MAXARGS);
  102a9c:	83 ec 08             	sub    $0x8,%esp
  102a9f:	6a 10                	push   $0x10
  102aa1:	8d 83 76 b0 ff ff    	lea    -0x4f8a(%ebx),%eax
  102aa7:	50                   	push   %eax
  102aa8:	e8 82 f5 ff ff       	call   10202f <dprintf>
			return 0;
  102aad:	83 c4 10             	add    $0x10,%esp
  102ab0:	bf 00 00 00 00       	mov    $0x0,%edi
		if (strcmp (argv[0], commands[i].name) == 0)
			return commands[i].func (argc, argv, tf);
	}
	dprintf("Unknown command '%s'\n", argv[0]);
	return 0;
}
  102ab5:	89 f8                	mov    %edi,%eax
  102ab7:	83 c4 5c             	add    $0x5c,%esp
  102aba:	5b                   	pop    %ebx
  102abb:	5e                   	pop    %esi
  102abc:	5f                   	pop    %edi
  102abd:	5d                   	pop    %ebp
  102abe:	c3                   	ret    
			buf++;
  102abf:	83 c6 01             	add    $0x1,%esi
		while (*buf && !strchr (WHITESPACE, *buf))
  102ac2:	0f b6 06             	movzbl (%esi),%eax
  102ac5:	84 c0                	test   %al,%al
  102ac7:	74 1a                	je     102ae3 <runcmd+0x92>
  102ac9:	83 ec 08             	sub    $0x8,%esp
  102acc:	0f be c0             	movsbl %al,%eax
  102acf:	50                   	push   %eax
  102ad0:	8d 83 71 b0 ff ff    	lea    -0x4f8f(%ebx),%eax
  102ad6:	50                   	push   %eax
  102ad7:	e8 f6 f2 ff ff       	call   101dd2 <strchr>
  102adc:	83 c4 10             	add    $0x10,%esp
  102adf:	85 c0                	test   %eax,%eax
  102ae1:	74 dc                	je     102abf <runcmd+0x6e>
			*buf++ = 0;
  102ae3:	89 ef                	mov    %ebp,%edi
		while (*buf && strchr (WHITESPACE, *buf))
  102ae5:	0f b6 06             	movzbl (%esi),%eax
  102ae8:	84 c0                	test   %al,%al
  102aea:	75 8c                	jne    102a78 <runcmd+0x27>
		if (*buf == 0)
  102aec:	80 3e 00             	cmpb   $0x0,(%esi)
  102aef:	74 0e                	je     102aff <runcmd+0xae>
		if (argc == MAXARGS - 1)
  102af1:	83 ff 0f             	cmp    $0xf,%edi
  102af4:	74 a6                	je     102a9c <runcmd+0x4b>
		argv[argc++] = buf;
  102af6:	8d 6f 01             	lea    0x1(%edi),%ebp
  102af9:	89 74 bc 10          	mov    %esi,0x10(%esp,%edi,4)
		while (*buf && !strchr (WHITESPACE, *buf))
  102afd:	eb c3                	jmp    102ac2 <runcmd+0x71>
	argv[argc] = 0;
  102aff:	c7 44 bc 10 00 00 00 	movl   $0x0,0x10(%esp,%edi,4)
  102b06:	00 
	if (argc == 0)
  102b07:	85 ff                	test   %edi,%edi
  102b09:	74 aa                	je     102ab5 <runcmd+0x64>
	for (i = 0; i < NCOMMANDS; i++)
  102b0b:	be 00 00 00 00       	mov    $0x0,%esi
  102b10:	eb 03                	jmp    102b15 <runcmd+0xc4>
  102b12:	83 c6 01             	add    $0x1,%esi
  102b15:	83 fe 02             	cmp    $0x2,%esi
  102b18:	77 4c                	ja     102b66 <runcmd+0x115>
		if (strcmp (argv[0], commands[i].name) == 0)
  102b1a:	83 ec 08             	sub    $0x8,%esp
  102b1d:	8d 14 76             	lea    (%esi,%esi,2),%edx
  102b20:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  102b27:	ff b4 03 c0 ff ff ff 	pushl  -0x40(%ebx,%eax,1)
  102b2e:	ff 74 24 1c          	pushl  0x1c(%esp)
  102b32:	e8 77 f2 ff ff       	call   101dae <strcmp>
  102b37:	83 c4 10             	add    $0x10,%esp
  102b3a:	85 c0                	test   %eax,%eax
  102b3c:	75 d4                	jne    102b12 <runcmd+0xc1>
			return commands[i].func (argc, argv, tf);
  102b3e:	8d 14 76             	lea    (%esi,%esi,2),%edx
  102b41:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  102b48:	83 ec 04             	sub    $0x4,%esp
  102b4b:	ff 74 24 10          	pushl  0x10(%esp)
  102b4f:	8d 54 24 18          	lea    0x18(%esp),%edx
  102b53:	52                   	push   %edx
  102b54:	57                   	push   %edi
  102b55:	ff 94 03 c8 ff ff ff 	call   *-0x38(%ebx,%eax,1)
  102b5c:	89 c7                	mov    %eax,%edi
  102b5e:	83 c4 10             	add    $0x10,%esp
  102b61:	e9 4f ff ff ff       	jmp    102ab5 <runcmd+0x64>
	dprintf("Unknown command '%s'\n", argv[0]);
  102b66:	83 ec 08             	sub    $0x8,%esp
  102b69:	ff 74 24 18          	pushl  0x18(%esp)
  102b6d:	8d 83 93 b0 ff ff    	lea    -0x4f6d(%ebx),%eax
  102b73:	50                   	push   %eax
  102b74:	e8 b6 f4 ff ff       	call   10202f <dprintf>
	return 0;
  102b79:	83 c4 10             	add    $0x10,%esp
  102b7c:	bf 00 00 00 00       	mov    $0x0,%edi
  102b81:	e9 2f ff ff ff       	jmp    102ab5 <runcmd+0x64>

00102b86 <monitor>:

void
monitor (struct Trapframe *tf)
{
  102b86:	57                   	push   %edi
  102b87:	56                   	push   %esi
  102b88:	53                   	push   %ebx
  102b89:	e8 81 d7 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  102b8e:	81 c3 72 84 00 00    	add    $0x8472,%ebx
  102b94:	8b 74 24 10          	mov    0x10(%esp),%esi
	char *buf;

	dprintf("\n****************************************\n\n");
  102b98:	83 ec 0c             	sub    $0xc,%esp
  102b9b:	8d bb 58 b1 ff ff    	lea    -0x4ea8(%ebx),%edi
  102ba1:	57                   	push   %edi
  102ba2:	e8 88 f4 ff ff       	call   10202f <dprintf>
	dprintf("Welcome to the mCertiKOS kernel monitor!\n");
  102ba7:	8d 83 84 b1 ff ff    	lea    -0x4e7c(%ebx),%eax
  102bad:	89 04 24             	mov    %eax,(%esp)
  102bb0:	e8 7a f4 ff ff       	call   10202f <dprintf>
	dprintf("\n****************************************\n\n");
  102bb5:	89 3c 24             	mov    %edi,(%esp)
  102bb8:	e8 72 f4 ff ff       	call   10202f <dprintf>
	dprintf("Type 'help' for a list of commands.\n");
  102bbd:	8d 83 b0 b1 ff ff    	lea    -0x4e50(%ebx),%eax
  102bc3:	89 04 24             	mov    %eax,(%esp)
  102bc6:	e8 64 f4 ff ff       	call   10202f <dprintf>
  102bcb:	83 c4 10             	add    $0x10,%esp

	while (1)
	{
		buf = (char *) readline ("$> ");
  102bce:	83 ec 0c             	sub    $0xc,%esp
  102bd1:	8d 83 a9 b0 ff ff    	lea    -0x4f57(%ebx),%eax
  102bd7:	50                   	push   %eax
  102bd8:	e8 5e d8 ff ff       	call   10043b <readline>
		if (buf != NULL)
  102bdd:	83 c4 10             	add    $0x10,%esp
  102be0:	85 c0                	test   %eax,%eax
  102be2:	74 ea                	je     102bce <monitor+0x48>
			if (runcmd (buf, tf) < 0)
  102be4:	89 f2                	mov    %esi,%edx
  102be6:	e8 66 fe ff ff       	call   102a51 <runcmd>
  102beb:	85 c0                	test   %eax,%eax
  102bed:	79 df                	jns    102bce <monitor+0x48>
				break;
	}
}
  102bef:	5b                   	pop    %ebx
  102bf0:	5e                   	pop    %esi
  102bf1:	5f                   	pop    %edi
  102bf2:	c3                   	ret    

00102bf3 <pt_copyin>:
extern void alloc_page(unsigned int pid, unsigned int vaddr, unsigned int perm);
extern unsigned int get_ptbl_entry_by_va(unsigned int pid, unsigned int vaddr);

size_t
pt_copyin(uint32_t pmap_id, uintptr_t uva, void *kva, size_t len)
{
  102bf3:	55                   	push   %ebp
  102bf4:	57                   	push   %edi
  102bf5:	56                   	push   %esi
  102bf6:	53                   	push   %ebx
  102bf7:	83 ec 1c             	sub    $0x1c,%esp
  102bfa:	e8 10 d7 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  102bff:	81 c3 01 84 00 00    	add    $0x8401,%ebx
  102c05:	8b 7c 24 34          	mov    0x34(%esp),%edi
  102c09:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
	if (!(VM_USERLO <= uva && uva + len <= VM_USERHI))
  102c0d:	81 ff ff ff ff 3f    	cmp    $0x3fffffff,%edi
  102c13:	0f 86 a2 00 00 00    	jbe    102cbb <pt_copyin+0xc8>
  102c19:	8d 04 2f             	lea    (%edi,%ebp,1),%eax
  102c1c:	3d 00 00 00 f0       	cmp    $0xf0000000,%eax
  102c21:	0f 87 a8 00 00 00    	ja     102ccf <pt_copyin+0xdc>
		return 0;

	if ((uintptr_t) kva + len > VM_USERHI)
  102c27:	89 e8                	mov    %ebp,%eax
  102c29:	03 44 24 38          	add    0x38(%esp),%eax
  102c2d:	3d 00 00 00 f0       	cmp    $0xf0000000,%eax
  102c32:	0f 87 a1 00 00 00    	ja     102cd9 <pt_copyin+0xe6>
		return 0;

	size_t copied = 0;
  102c38:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  102c3f:	00 
  102c40:	eb 40                	jmp    102c82 <pt_copyin+0x8f>
		if ((uva_pa & PTE_P) == 0) {
			alloc_page(pmap_id, uva, PTE_P | PTE_U | PTE_W);
			uva_pa = get_ptbl_entry_by_va(pmap_id, uva);
		}

		uva_pa = (uva_pa & 0xfffff000) + (uva % PAGESIZE);
  102c42:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102c47:	89 fa                	mov    %edi,%edx
  102c49:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  102c4f:	09 d0                	or     %edx,%eax

		size_t size = (len < PAGESIZE - uva_pa % PAGESIZE) ?
  102c51:	89 c2                	mov    %eax,%edx
  102c53:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  102c59:	be 00 10 00 00       	mov    $0x1000,%esi
  102c5e:	29 d6                	sub    %edx,%esi
  102c60:	39 ee                	cmp    %ebp,%esi
  102c62:	0f 47 f5             	cmova  %ebp,%esi
			len : PAGESIZE - uva_pa % PAGESIZE;

		memcpy(kva, (void *) uva_pa, size);
  102c65:	83 ec 04             	sub    $0x4,%esp
  102c68:	56                   	push   %esi
  102c69:	50                   	push   %eax
  102c6a:	ff 74 24 44          	pushl  0x44(%esp)
  102c6e:	e8 c7 f0 ff ff       	call   101d3a <memcpy>

		len -= size;
  102c73:	29 f5                	sub    %esi,%ebp
		uva += size;
  102c75:	01 f7                	add    %esi,%edi
		kva += size;
  102c77:	01 74 24 48          	add    %esi,0x48(%esp)
		copied += size;
  102c7b:	01 74 24 1c          	add    %esi,0x1c(%esp)
  102c7f:	83 c4 10             	add    $0x10,%esp
	while (len) {
  102c82:	85 ed                	test   %ebp,%ebp
  102c84:	74 3d                	je     102cc3 <pt_copyin+0xd0>
		uintptr_t uva_pa = get_ptbl_entry_by_va(pmap_id, uva);
  102c86:	83 ec 08             	sub    $0x8,%esp
  102c89:	57                   	push   %edi
  102c8a:	ff 74 24 3c          	pushl  0x3c(%esp)
  102c8e:	e8 5d 13 00 00       	call   103ff0 <get_ptbl_entry_by_va>
		if ((uva_pa & PTE_P) == 0) {
  102c93:	83 c4 10             	add    $0x10,%esp
  102c96:	a8 01                	test   $0x1,%al
  102c98:	75 a8                	jne    102c42 <pt_copyin+0x4f>
			alloc_page(pmap_id, uva, PTE_P | PTE_U | PTE_W);
  102c9a:	83 ec 04             	sub    $0x4,%esp
  102c9d:	6a 07                	push   $0x7
  102c9f:	57                   	push   %edi
  102ca0:	ff 74 24 3c          	pushl  0x3c(%esp)
  102ca4:	e8 57 1b 00 00       	call   104800 <alloc_page>
			uva_pa = get_ptbl_entry_by_va(pmap_id, uva);
  102ca9:	83 c4 08             	add    $0x8,%esp
  102cac:	57                   	push   %edi
  102cad:	ff 74 24 3c          	pushl  0x3c(%esp)
  102cb1:	e8 3a 13 00 00       	call   103ff0 <get_ptbl_entry_by_va>
  102cb6:	83 c4 10             	add    $0x10,%esp
  102cb9:	eb 87                	jmp    102c42 <pt_copyin+0x4f>
		return 0;
  102cbb:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  102cc2:	00 
	}

	return copied;
}
  102cc3:	8b 44 24 0c          	mov    0xc(%esp),%eax
  102cc7:	83 c4 1c             	add    $0x1c,%esp
  102cca:	5b                   	pop    %ebx
  102ccb:	5e                   	pop    %esi
  102ccc:	5f                   	pop    %edi
  102ccd:	5d                   	pop    %ebp
  102cce:	c3                   	ret    
		return 0;
  102ccf:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  102cd6:	00 
  102cd7:	eb ea                	jmp    102cc3 <pt_copyin+0xd0>
		return 0;
  102cd9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  102ce0:	00 
  102ce1:	eb e0                	jmp    102cc3 <pt_copyin+0xd0>

00102ce3 <pt_copyout>:

size_t
pt_copyout(void *kva, uint32_t pmap_id, uintptr_t uva, size_t len)
{
  102ce3:	55                   	push   %ebp
  102ce4:	57                   	push   %edi
  102ce5:	56                   	push   %esi
  102ce6:	53                   	push   %ebx
  102ce7:	83 ec 1c             	sub    $0x1c,%esp
  102cea:	e8 20 d6 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  102cef:	81 c3 11 83 00 00    	add    $0x8311,%ebx
  102cf5:	8b 7c 24 38          	mov    0x38(%esp),%edi
  102cf9:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
	if (!(VM_USERLO <= uva && uva + len <= VM_USERHI))
  102cfd:	81 ff ff ff ff 3f    	cmp    $0x3fffffff,%edi
  102d03:	0f 86 a2 00 00 00    	jbe    102dab <pt_copyout+0xc8>
  102d09:	8d 04 2f             	lea    (%edi,%ebp,1),%eax
  102d0c:	3d 00 00 00 f0       	cmp    $0xf0000000,%eax
  102d11:	0f 87 a8 00 00 00    	ja     102dbf <pt_copyout+0xdc>
		return 0;

	if ((uintptr_t) kva + len > VM_USERHI)
  102d17:	89 e8                	mov    %ebp,%eax
  102d19:	03 44 24 30          	add    0x30(%esp),%eax
  102d1d:	3d 00 00 00 f0       	cmp    $0xf0000000,%eax
  102d22:	0f 87 a1 00 00 00    	ja     102dc9 <pt_copyout+0xe6>
		return 0;

	size_t copied = 0;
  102d28:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  102d2f:	00 
  102d30:	eb 40                	jmp    102d72 <pt_copyout+0x8f>
		if ((uva_pa & PTE_P) == 0) {
			alloc_page(pmap_id, uva, PTE_P | PTE_U | PTE_W);
			uva_pa = get_ptbl_entry_by_va(pmap_id, uva);
		}

		uva_pa = (uva_pa & 0xfffff000) + (uva % PAGESIZE);
  102d32:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102d37:	89 fa                	mov    %edi,%edx
  102d39:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  102d3f:	09 d0                	or     %edx,%eax

		size_t size = (len < PAGESIZE - uva_pa % PAGESIZE) ?
  102d41:	89 c2                	mov    %eax,%edx
  102d43:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  102d49:	be 00 10 00 00       	mov    $0x1000,%esi
  102d4e:	29 d6                	sub    %edx,%esi
  102d50:	39 ee                	cmp    %ebp,%esi
  102d52:	0f 47 f5             	cmova  %ebp,%esi
			len : PAGESIZE - uva_pa % PAGESIZE;

		memcpy((void *) uva_pa, kva, size);
  102d55:	83 ec 04             	sub    $0x4,%esp
  102d58:	56                   	push   %esi
  102d59:	ff 74 24 38          	pushl  0x38(%esp)
  102d5d:	50                   	push   %eax
  102d5e:	e8 d7 ef ff ff       	call   101d3a <memcpy>

		len -= size;
  102d63:	29 f5                	sub    %esi,%ebp
		uva += size;
  102d65:	01 f7                	add    %esi,%edi
		kva += size;
  102d67:	01 74 24 40          	add    %esi,0x40(%esp)
		copied += size;
  102d6b:	01 74 24 1c          	add    %esi,0x1c(%esp)
  102d6f:	83 c4 10             	add    $0x10,%esp
	while (len) {
  102d72:	85 ed                	test   %ebp,%ebp
  102d74:	74 3d                	je     102db3 <pt_copyout+0xd0>
		uintptr_t uva_pa = get_ptbl_entry_by_va(pmap_id, uva);
  102d76:	83 ec 08             	sub    $0x8,%esp
  102d79:	57                   	push   %edi
  102d7a:	ff 74 24 40          	pushl  0x40(%esp)
  102d7e:	e8 6d 12 00 00       	call   103ff0 <get_ptbl_entry_by_va>
		if ((uva_pa & PTE_P) == 0) {
  102d83:	83 c4 10             	add    $0x10,%esp
  102d86:	a8 01                	test   $0x1,%al
  102d88:	75 a8                	jne    102d32 <pt_copyout+0x4f>
			alloc_page(pmap_id, uva, PTE_P | PTE_U | PTE_W);
  102d8a:	83 ec 04             	sub    $0x4,%esp
  102d8d:	6a 07                	push   $0x7
  102d8f:	57                   	push   %edi
  102d90:	ff 74 24 40          	pushl  0x40(%esp)
  102d94:	e8 67 1a 00 00       	call   104800 <alloc_page>
			uva_pa = get_ptbl_entry_by_va(pmap_id, uva);
  102d99:	83 c4 08             	add    $0x8,%esp
  102d9c:	57                   	push   %edi
  102d9d:	ff 74 24 40          	pushl  0x40(%esp)
  102da1:	e8 4a 12 00 00       	call   103ff0 <get_ptbl_entry_by_va>
  102da6:	83 c4 10             	add    $0x10,%esp
  102da9:	eb 87                	jmp    102d32 <pt_copyout+0x4f>
		return 0;
  102dab:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  102db2:	00 
	}

	return copied;
}
  102db3:	8b 44 24 0c          	mov    0xc(%esp),%eax
  102db7:	83 c4 1c             	add    $0x1c,%esp
  102dba:	5b                   	pop    %ebx
  102dbb:	5e                   	pop    %esi
  102dbc:	5f                   	pop    %edi
  102dbd:	5d                   	pop    %ebp
  102dbe:	c3                   	ret    
		return 0;
  102dbf:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  102dc6:	00 
  102dc7:	eb ea                	jmp    102db3 <pt_copyout+0xd0>
		return 0;
  102dc9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  102dd0:	00 
  102dd1:	eb e0                	jmp    102db3 <pt_copyout+0xd0>

00102dd3 <pt_memset>:

size_t
pt_memset(uint32_t pmap_id, uintptr_t va, char c, size_t len)
{
  102dd3:	55                   	push   %ebp
  102dd4:	57                   	push   %edi
  102dd5:	56                   	push   %esi
  102dd6:	53                   	push   %ebx
  102dd7:	83 ec 1c             	sub    $0x1c,%esp
  102dda:	e8 30 d5 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  102ddf:	81 c3 21 82 00 00    	add    $0x8221,%ebx
  102de5:	8b 6c 24 34          	mov    0x34(%esp),%ebp
  102de9:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  102ded:	0f b6 44 24 38       	movzbl 0x38(%esp),%eax
  102df2:	88 44 24 0f          	mov    %al,0xf(%esp)
        size_t set = 0;
  102df6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  102dfd:	00 

	while (len) {
  102dfe:	eb 3e                	jmp    102e3e <pt_memset+0x6b>
		if ((pa & PTE_P) == 0) {
			alloc_page(pmap_id, va, PTE_P | PTE_U | PTE_W);
			pa = get_ptbl_entry_by_va(pmap_id, va);
		}

		pa = (pa & 0xfffff000) + (va % PAGESIZE);
  102e00:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102e05:	89 ea                	mov    %ebp,%edx
  102e07:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  102e0d:	09 d0                	or     %edx,%eax

		size_t size = (len < PAGESIZE - pa % PAGESIZE) ?
  102e0f:	89 c2                	mov    %eax,%edx
  102e11:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  102e17:	be 00 10 00 00       	mov    $0x1000,%esi
  102e1c:	29 d6                	sub    %edx,%esi
  102e1e:	39 fe                	cmp    %edi,%esi
  102e20:	0f 47 f7             	cmova  %edi,%esi
			len : PAGESIZE - pa % PAGESIZE;

		memset((void *) pa, c, size);
  102e23:	83 ec 04             	sub    $0x4,%esp
  102e26:	56                   	push   %esi
  102e27:	0f be 54 24 17       	movsbl 0x17(%esp),%edx
  102e2c:	52                   	push   %edx
  102e2d:	50                   	push   %eax
  102e2e:	e8 53 ee ff ff       	call   101c86 <memset>

		len -= size;
  102e33:	29 f7                	sub    %esi,%edi
		va += size;
  102e35:	01 f5                	add    %esi,%ebp
		set += size;
  102e37:	01 74 24 18          	add    %esi,0x18(%esp)
  102e3b:	83 c4 10             	add    $0x10,%esp
	while (len) {
  102e3e:	85 ff                	test   %edi,%edi
  102e40:	74 35                	je     102e77 <pt_memset+0xa4>
		uintptr_t pa = get_ptbl_entry_by_va(pmap_id, va);
  102e42:	83 ec 08             	sub    $0x8,%esp
  102e45:	55                   	push   %ebp
  102e46:	ff 74 24 3c          	pushl  0x3c(%esp)
  102e4a:	e8 a1 11 00 00       	call   103ff0 <get_ptbl_entry_by_va>
		if ((pa & PTE_P) == 0) {
  102e4f:	83 c4 10             	add    $0x10,%esp
  102e52:	a8 01                	test   $0x1,%al
  102e54:	75 aa                	jne    102e00 <pt_memset+0x2d>
			alloc_page(pmap_id, va, PTE_P | PTE_U | PTE_W);
  102e56:	83 ec 04             	sub    $0x4,%esp
  102e59:	6a 07                	push   $0x7
  102e5b:	55                   	push   %ebp
  102e5c:	ff 74 24 3c          	pushl  0x3c(%esp)
  102e60:	e8 9b 19 00 00       	call   104800 <alloc_page>
			pa = get_ptbl_entry_by_va(pmap_id, va);
  102e65:	83 c4 08             	add    $0x8,%esp
  102e68:	55                   	push   %ebp
  102e69:	ff 74 24 3c          	pushl  0x3c(%esp)
  102e6d:	e8 7e 11 00 00       	call   103ff0 <get_ptbl_entry_by_va>
  102e72:	83 c4 10             	add    $0x10,%esp
  102e75:	eb 89                	jmp    102e00 <pt_memset+0x2d>
	}

	return set;
}
  102e77:	8b 44 24 08          	mov    0x8(%esp),%eax
  102e7b:	83 c4 1c             	add    $0x1c,%esp
  102e7e:	5b                   	pop    %ebx
  102e7f:	5e                   	pop    %esi
  102e80:	5f                   	pop    %edi
  102e81:	5d                   	pop    %ebp
  102e82:	c3                   	ret    

00102e83 <elf_load>:
/*
 * Load elf execution file exe to the virtual address space pmap.
 */
void
elf_load (void *exe_ptr, int pid)
{
  102e83:	55                   	push   %ebp
  102e84:	57                   	push   %edi
  102e85:	56                   	push   %esi
  102e86:	53                   	push   %ebx
  102e87:	83 ec 2c             	sub    $0x2c,%esp
  102e8a:	e8 80 d4 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  102e8f:	81 c3 71 81 00 00    	add    $0x8171,%ebx
  102e95:	8b 74 24 40          	mov    0x40(%esp),%esi
	elfhdr *eh;
	proghdr *ph, *eph;
	sechdr *sh, *esh;
	char *strtab;
	uintptr_t exe = (uintptr_t) exe_ptr;
  102e99:	89 74 24 1c          	mov    %esi,0x1c(%esp)

	eh = (elfhdr *) exe;

	KERN_ASSERT(eh->e_magic == ELF_MAGIC);
  102e9d:	81 3e 7f 45 4c 46    	cmpl   $0x464c457f,(%esi)
  102ea3:	75 3a                	jne    102edf <elf_load+0x5c>
	KERN_ASSERT(eh->e_shstrndx != ELF_SHN_UNDEF);
  102ea5:	66 83 7e 32 00       	cmpw   $0x0,0x32(%esi)
  102eaa:	74 54                	je     102f00 <elf_load+0x7d>

	sh = (sechdr *) ((uintptr_t) eh + eh->e_shoff);
  102eac:	89 f1                	mov    %esi,%ecx
  102eae:	03 4e 20             	add    0x20(%esi),%ecx
	esh = sh + eh->e_shnum;

	strtab = (char *) (exe + sh[eh->e_shstrndx].sh_offset);
  102eb1:	0f b7 46 32          	movzwl 0x32(%esi),%eax
  102eb5:	8d 14 80             	lea    (%eax,%eax,4),%edx
  102eb8:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
	KERN_ASSERT(sh[eh->e_shstrndx].sh_type == ELF_SHT_STRTAB);
  102ebf:	83 7c 01 04 03       	cmpl   $0x3,0x4(%ecx,%eax,1)
  102ec4:	75 5b                	jne    102f21 <elf_load+0x9e>

	ph = (proghdr *) ((uintptr_t) eh + eh->e_phoff);
  102ec6:	89 f2                	mov    %esi,%edx
  102ec8:	03 56 1c             	add    0x1c(%esi),%edx
  102ecb:	89 d5                	mov    %edx,%ebp
	eph = ph + eh->e_phnum;
  102ecd:	0f b7 46 2c          	movzwl 0x2c(%esi),%eax
  102ed1:	c1 e0 05             	shl    $0x5,%eax
  102ed4:	01 d0                	add    %edx,%eax
  102ed6:	89 44 24 14          	mov    %eax,0x14(%esp)

	for (; ph < eph; ph++)
  102eda:	e9 09 01 00 00       	jmp    102fe8 <elf_load+0x165>
	KERN_ASSERT(eh->e_magic == ELF_MAGIC);
  102edf:	8d 83 fd b1 ff ff    	lea    -0x4e03(%ebx),%eax
  102ee5:	50                   	push   %eax
  102ee6:	8d 83 b3 ad ff ff    	lea    -0x524d(%ebx),%eax
  102eec:	50                   	push   %eax
  102eed:	6a 20                	push   $0x20
  102eef:	8d 83 16 b2 ff ff    	lea    -0x4dea(%ebx),%eax
  102ef5:	50                   	push   %eax
  102ef6:	e8 a1 ef ff ff       	call   101e9c <debug_panic>
  102efb:	83 c4 10             	add    $0x10,%esp
  102efe:	eb a5                	jmp    102ea5 <elf_load+0x22>
	KERN_ASSERT(eh->e_shstrndx != ELF_SHN_UNDEF);
  102f00:	8d 83 28 b2 ff ff    	lea    -0x4dd8(%ebx),%eax
  102f06:	50                   	push   %eax
  102f07:	8d 83 b3 ad ff ff    	lea    -0x524d(%ebx),%eax
  102f0d:	50                   	push   %eax
  102f0e:	6a 21                	push   $0x21
  102f10:	8d 83 16 b2 ff ff    	lea    -0x4dea(%ebx),%eax
  102f16:	50                   	push   %eax
  102f17:	e8 80 ef ff ff       	call   101e9c <debug_panic>
  102f1c:	83 c4 10             	add    $0x10,%esp
  102f1f:	eb 8b                	jmp    102eac <elf_load+0x29>
	KERN_ASSERT(sh[eh->e_shstrndx].sh_type == ELF_SHT_STRTAB);
  102f21:	8d 83 48 b2 ff ff    	lea    -0x4db8(%ebx),%eax
  102f27:	50                   	push   %eax
  102f28:	8d 83 b3 ad ff ff    	lea    -0x524d(%ebx),%eax
  102f2e:	50                   	push   %eax
  102f2f:	6a 27                	push   $0x27
  102f31:	8d 83 16 b2 ff ff    	lea    -0x4dea(%ebx),%eax
  102f37:	50                   	push   %eax
  102f38:	e8 5f ef ff ff       	call   101e9c <debug_panic>
  102f3d:	83 c4 10             	add    $0x10,%esp
  102f40:	eb 84                	jmp    102ec6 <elf_load+0x43>
			alloc_page (pid, va, perm);

			if (va < rounddown (zva, PAGESIZE))
			{
				/* copy a complete page */
				pt_copyout ((void *) fa, pid, va, PAGESIZE);
  102f42:	68 00 10 00 00       	push   $0x1000
  102f47:	56                   	push   %esi
  102f48:	55                   	push   %ebp
  102f49:	57                   	push   %edi
  102f4a:	e8 94 fd ff ff       	call   102ce3 <pt_copyout>
  102f4f:	83 c4 10             	add    $0x10,%esp
  102f52:	eb 11                	jmp    102f65 <elf_load+0xe2>
				pt_copyout ((void *) fa, pid, va, zva - va);
			}
			else
			{
				/* zero a page */
				pt_memset (pid, va, 0, PAGESIZE);
  102f54:	68 00 10 00 00       	push   $0x1000
  102f59:	6a 00                	push   $0x0
  102f5b:	56                   	push   %esi
  102f5c:	55                   	push   %ebp
  102f5d:	e8 71 fe ff ff       	call   102dd3 <pt_memset>
  102f62:	83 c4 10             	add    $0x10,%esp
		for (; va < eva; va += PAGESIZE, fa += PAGESIZE)
  102f65:	81 c6 00 10 00 00    	add    $0x1000,%esi
  102f6b:	81 c7 00 10 00 00    	add    $0x1000,%edi
  102f71:	3b 74 24 0c          	cmp    0xc(%esp),%esi
  102f75:	73 6a                	jae    102fe1 <elf_load+0x15e>
			alloc_page (pid, va, perm);
  102f77:	83 ec 04             	sub    $0x4,%esp
  102f7a:	ff 74 24 14          	pushl  0x14(%esp)
  102f7e:	56                   	push   %esi
  102f7f:	55                   	push   %ebp
  102f80:	e8 7b 18 00 00       	call   104800 <alloc_page>
			if (va < rounddown (zva, PAGESIZE))
  102f85:	83 c4 08             	add    $0x8,%esp
  102f88:	68 00 10 00 00       	push   $0x1000
  102f8d:	ff 74 24 14          	pushl  0x14(%esp)
  102f91:	e8 08 f8 ff ff       	call   10279e <rounddown>
  102f96:	83 c4 10             	add    $0x10,%esp
  102f99:	39 f0                	cmp    %esi,%eax
  102f9b:	77 a5                	ja     102f42 <elf_load+0xbf>
			else if (va < zva && ph->p_filesz)
  102f9d:	3b 74 24 08          	cmp    0x8(%esp),%esi
  102fa1:	73 b1                	jae    102f54 <elf_load+0xd1>
  102fa3:	8b 44 24 18          	mov    0x18(%esp),%eax
  102fa7:	83 78 10 00          	cmpl   $0x0,0x10(%eax)
  102fab:	74 a7                	je     102f54 <elf_load+0xd1>
				pt_memset (pid, va, 0, PAGESIZE);
  102fad:	68 00 10 00 00       	push   $0x1000
  102fb2:	6a 00                	push   $0x0
  102fb4:	56                   	push   %esi
  102fb5:	55                   	push   %ebp
  102fb6:	e8 18 fe ff ff       	call   102dd3 <pt_memset>
				pt_copyout ((void *) fa, pid, va, zva - va);
  102fbb:	8b 44 24 18          	mov    0x18(%esp),%eax
  102fbf:	29 f0                	sub    %esi,%eax
  102fc1:	50                   	push   %eax
  102fc2:	56                   	push   %esi
  102fc3:	55                   	push   %ebp
  102fc4:	57                   	push   %edi
  102fc5:	e8 19 fd ff ff       	call   102ce3 <pt_copyout>
  102fca:	83 c4 20             	add    $0x20,%esp
  102fcd:	eb 96                	jmp    102f65 <elf_load+0xe2>
			perm |= PTE_W;
  102fcf:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  102fd6:	00 
  102fd7:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  102fdb:	8b 6c 24 44          	mov    0x44(%esp),%ebp
  102fdf:	eb 90                	jmp    102f71 <elf_load+0xee>
  102fe1:	8b 6c 24 18          	mov    0x18(%esp),%ebp
	for (; ph < eph; ph++)
  102fe5:	83 c5 20             	add    $0x20,%ebp
  102fe8:	3b 6c 24 14          	cmp    0x14(%esp),%ebp
  102fec:	73 6e                	jae    10305c <elf_load+0x1d9>
		if (ph->p_type != ELF_PROG_LOAD)
  102fee:	83 7d 00 01          	cmpl   $0x1,0x0(%ebp)
  102ff2:	75 f1                	jne    102fe5 <elf_load+0x162>
		fa = (uintptr_t) eh + rounddown (ph->p_offset, PAGESIZE);
  102ff4:	83 ec 08             	sub    $0x8,%esp
  102ff7:	68 00 10 00 00       	push   $0x1000
  102ffc:	ff 75 04             	pushl  0x4(%ebp)
  102fff:	e8 9a f7 ff ff       	call   10279e <rounddown>
  103004:	8b 4c 24 2c          	mov    0x2c(%esp),%ecx
  103008:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		va = rounddown (ph->p_va, PAGESIZE);
  10300b:	83 c4 08             	add    $0x8,%esp
  10300e:	68 00 10 00 00       	push   $0x1000
  103013:	ff 75 08             	pushl  0x8(%ebp)
  103016:	e8 83 f7 ff ff       	call   10279e <rounddown>
  10301b:	89 c6                	mov    %eax,%esi
		zva = ph->p_va + ph->p_filesz;
  10301d:	8b 45 08             	mov    0x8(%ebp),%eax
  103020:	89 c1                	mov    %eax,%ecx
  103022:	03 4d 10             	add    0x10(%ebp),%ecx
  103025:	89 4c 24 18          	mov    %ecx,0x18(%esp)
		eva = roundup (ph->p_va + ph->p_memsz, PAGESIZE);
  103029:	03 45 14             	add    0x14(%ebp),%eax
  10302c:	83 c4 08             	add    $0x8,%esp
  10302f:	68 00 10 00 00       	push   $0x1000
  103034:	50                   	push   %eax
  103035:	e8 78 f7 ff ff       	call   1027b2 <roundup>
  10303a:	89 44 24 1c          	mov    %eax,0x1c(%esp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  10303e:	83 c4 10             	add    $0x10,%esp
  103041:	f6 45 18 02          	testb  $0x2,0x18(%ebp)
  103045:	75 88                	jne    102fcf <elf_load+0x14c>
		perm = PTE_U | PTE_P;
  103047:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  10304e:	00 
  10304f:	89 6c 24 18          	mov    %ebp,0x18(%esp)
  103053:	8b 6c 24 44          	mov    0x44(%esp),%ebp
  103057:	e9 15 ff ff ff       	jmp    102f71 <elf_load+0xee>
			}
		}
	}

}
  10305c:	83 c4 2c             	add    $0x2c,%esp
  10305f:	5b                   	pop    %ebx
  103060:	5e                   	pop    %esi
  103061:	5f                   	pop    %edi
  103062:	5d                   	pop    %ebp
  103063:	c3                   	ret    

00103064 <elf_entry>:

uintptr_t
elf_entry (void *exe_ptr)
{
  103064:	56                   	push   %esi
  103065:	53                   	push   %ebx
  103066:	83 ec 04             	sub    $0x4,%esp
  103069:	e8 a1 d2 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  10306e:	81 c3 92 7f 00 00    	add    $0x7f92,%ebx
  103074:	8b 74 24 10          	mov    0x10(%esp),%esi
	uintptr_t exe = (uintptr_t) exe_ptr;
	elfhdr *eh = (elfhdr *) exe;
	KERN_ASSERT(eh->e_magic == ELF_MAGIC);
  103078:	81 3e 7f 45 4c 46    	cmpl   $0x464c457f,(%esi)
  10307e:	74 1f                	je     10309f <elf_entry+0x3b>
  103080:	8d 83 fd b1 ff ff    	lea    -0x4e03(%ebx),%eax
  103086:	50                   	push   %eax
  103087:	8d 83 b3 ad ff ff    	lea    -0x524d(%ebx),%eax
  10308d:	50                   	push   %eax
  10308e:	6a 5b                	push   $0x5b
  103090:	8d 83 16 b2 ff ff    	lea    -0x4dea(%ebx),%eax
  103096:	50                   	push   %eax
  103097:	e8 00 ee ff ff       	call   101e9c <debug_panic>
  10309c:	83 c4 10             	add    $0x10,%esp
	return (uintptr_t) eh->e_entry;
  10309f:	8b 46 18             	mov    0x18(%esi),%eax
}
  1030a2:	83 c4 04             	add    $0x4,%esp
  1030a5:	5b                   	pop    %ebx
  1030a6:	5e                   	pop    %esi
  1030a7:	c3                   	ret    
  1030a8:	66 90                	xchg   %ax,%ax
  1030aa:	66 90                	xchg   %ax,%ax
  1030ac:	66 90                	xchg   %ax,%ax
  1030ae:	66 90                	xchg   %ax,%ax

001030b0 <kern_init>:
    #endif
}

void
kern_init (uintptr_t mbi_addr)
{
  1030b0:	56                   	push   %esi
  1030b1:	53                   	push   %ebx
  1030b2:	e8 58 d2 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  1030b7:	81 c3 49 7f 00 00    	add    $0x7f49,%ebx
  1030bd:	83 ec 14             	sub    $0x14,%esp
    pmmap_list_type pmmap_list;

    devinit();
  1030c0:	e8 fb d7 ff ff       	call   1008c0 <devinit>

    pmmap_init (mbi_addr, &pmmap_list);
  1030c5:	83 ec 08             	sub    $0x8,%esp
  1030c8:	8d 74 24 14          	lea    0x14(%esp),%esi
  1030cc:	56                   	push   %esi
  1030cd:	ff 74 24 2c          	pushl  0x2c(%esp)
  1030d1:	e8 8e ea ff ff       	call   101b64 <pmmap_init>

    pmem_init(&pmmap_list);
  1030d6:	89 34 24             	mov    %esi,(%esp)
    set_pdir_base(0);
    enable_paging();

    thread_init();

    KERN_DEBUG("Kernel initialized.\n");
  1030d9:	8d b3 8a b2 ff ff    	lea    -0x4d76(%ebx),%esi
    pmem_init(&pmmap_list);
  1030df:	e8 dc 03 00 00       	call   1034c0 <pmem_init>
    container_init();
  1030e4:	e8 27 07 00 00       	call   103810 <container_init>
    pdir_init_kern();
  1030e9:	e8 12 14 00 00       	call   104500 <pdir_init_kern>
    set_pdir_base(0);
  1030ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1030f5:	e8 26 0b 00 00       	call   103c20 <set_pdir_base>
    enable_paging();
  1030fa:	e8 51 eb ff ff       	call   101c50 <enable_paging>
    thread_init();
  1030ff:	e8 ec 1f 00 00       	call   1050f0 <thread_init>
    KERN_DEBUG("Kernel initialized.\n");
  103104:	8d 83 75 b2 ff ff    	lea    -0x4d8b(%ebx),%eax
  10310a:	83 c4 0c             	add    $0xc,%esp
  10310d:	50                   	push   %eax
  10310e:	6a 4d                	push   $0x4d
  103110:	56                   	push   %esi
  103111:	e8 4d ed ff ff       	call   101e63 <debug_normal>
    KERN_DEBUG("In kernel main.\n\n");
  103116:	8d 83 9b b2 ff ff    	lea    -0x4d65(%ebx),%eax
  10311c:	83 c4 0c             	add    $0xc,%esp
  10311f:	50                   	push   %eax
  103120:	6a 16                	push   $0x16
  103122:	56                   	push   %esi
  103123:	e8 3b ed ff ff       	call   101e63 <debug_normal>
    dprintf("Testing PKCtxNew ...\n");
  103128:	8d 83 ad b2 ff ff    	lea    -0x4d53(%ebx),%eax
  10312e:	89 04 24             	mov    %eax,(%esp)
  103131:	e8 f9 ee ff ff       	call   10202f <dprintf>
    if(test_PKCtxNew() == 0)
  103136:	e8 75 19 00 00       	call   104ab0 <test_PKCtxNew>
  10313b:	83 c4 10             	add    $0x10,%esp
  10313e:	84 c0                	test   %al,%al
  103140:	0f 85 ea 00 00 00    	jne    103230 <kern_init+0x180>
      dprintf("All tests passed.\n");
  103146:	8d 83 c3 b2 ff ff    	lea    -0x4d3d(%ebx),%eax
  10314c:	83 ec 0c             	sub    $0xc,%esp
  10314f:	50                   	push   %eax
  103150:	e8 da ee ff ff       	call   10202f <dprintf>
  103155:	83 c4 10             	add    $0x10,%esp
    dprintf("\n");
  103158:	8d b3 ab b2 ff ff    	lea    -0x4d55(%ebx),%esi
  10315e:	83 ec 0c             	sub    $0xc,%esp
  103161:	56                   	push   %esi
  103162:	e8 c8 ee ff ff       	call   10202f <dprintf>
    dprintf("Testing PTCBInit ...\n");
  103167:	8d 83 e4 b2 ff ff    	lea    -0x4d1c(%ebx),%eax
  10316d:	89 04 24             	mov    %eax,(%esp)
  103170:	e8 ba ee ff ff       	call   10202f <dprintf>
    if(test_PTCBInit() == 0)
  103175:	e8 26 1b 00 00       	call   104ca0 <test_PTCBInit>
  10317a:	83 c4 10             	add    $0x10,%esp
  10317d:	84 c0                	test   %al,%al
  10317f:	0f 85 eb 00 00 00    	jne    103270 <kern_init+0x1c0>
      dprintf("All tests passed.\n");
  103185:	8d 83 c3 b2 ff ff    	lea    -0x4d3d(%ebx),%eax
  10318b:	83 ec 0c             	sub    $0xc,%esp
  10318e:	50                   	push   %eax
  10318f:	e8 9b ee ff ff       	call   10202f <dprintf>
  103194:	83 c4 10             	add    $0x10,%esp
    dprintf("\n");
  103197:	83 ec 0c             	sub    $0xc,%esp
  10319a:	56                   	push   %esi
  10319b:	e8 8f ee ff ff       	call   10202f <dprintf>
    dprintf("Testing PTQueueInit ...\n");
  1031a0:	8d 83 fa b2 ff ff    	lea    -0x4d06(%ebx),%eax
  1031a6:	89 04 24             	mov    %eax,(%esp)
  1031a9:	e8 81 ee ff ff       	call   10202f <dprintf>
    if(test_PTQueueInit() == 0)
  1031ae:	e8 dd 1e 00 00       	call   105090 <test_PTQueueInit>
  1031b3:	83 c4 10             	add    $0x10,%esp
  1031b6:	84 c0                	test   %al,%al
  1031b8:	0f 85 92 00 00 00    	jne    103250 <kern_init+0x1a0>
      dprintf("All tests passed.\n");
  1031be:	8d 83 c3 b2 ff ff    	lea    -0x4d3d(%ebx),%eax
  1031c4:	83 ec 0c             	sub    $0xc,%esp
  1031c7:	50                   	push   %eax
  1031c8:	e8 62 ee ff ff       	call   10202f <dprintf>
  1031cd:	83 c4 10             	add    $0x10,%esp
    dprintf("\n");
  1031d0:	83 ec 0c             	sub    $0xc,%esp
  1031d3:	56                   	push   %esi
  1031d4:	e8 56 ee ff ff       	call   10202f <dprintf>
    dprintf("Testing PThread ...\n");
  1031d9:	8d 83 13 b3 ff ff    	lea    -0x4ced(%ebx),%eax
  1031df:	89 04 24             	mov    %eax,(%esp)
  1031e2:	e8 48 ee ff ff       	call   10202f <dprintf>
    if(test_PThread() == 0)
  1031e7:	e8 f4 1f 00 00       	call   1051e0 <test_PThread>
  1031ec:	83 c4 10             	add    $0x10,%esp
  1031ef:	84 c0                	test   %al,%al
  1031f1:	0f 84 99 00 00 00    	je     103290 <kern_init+0x1e0>
      dprintf("Test failed.\n");
  1031f7:	8d 83 d6 b2 ff ff    	lea    -0x4d2a(%ebx),%eax
  1031fd:	83 ec 0c             	sub    $0xc,%esp
  103200:	50                   	push   %eax
  103201:	e8 29 ee ff ff       	call   10202f <dprintf>
  103206:	83 c4 10             	add    $0x10,%esp
    dprintf("\n");
  103209:	83 ec 0c             	sub    $0xc,%esp
  10320c:	56                   	push   %esi
  10320d:	e8 1d ee ff ff       	call   10202f <dprintf>
    dprintf("\nTest complete. Please Use Ctrl-a x to exit qemu.");
  103212:	8d 83 28 b3 ff ff    	lea    -0x4cd8(%ebx),%eax
  103218:	89 04 24             	mov    %eax,(%esp)
  10321b:	e8 0f ee ff ff       	call   10202f <dprintf>

    kern_main ();
}
  103220:	83 c4 24             	add    $0x24,%esp
  103223:	5b                   	pop    %ebx
  103224:	5e                   	pop    %esi
  103225:	c3                   	ret    
  103226:	8d 76 00             	lea    0x0(%esi),%esi
  103229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dprintf("Test failed.\n");
  103230:	8d 83 d6 b2 ff ff    	lea    -0x4d2a(%ebx),%eax
  103236:	83 ec 0c             	sub    $0xc,%esp
  103239:	50                   	push   %eax
  10323a:	e8 f0 ed ff ff       	call   10202f <dprintf>
  10323f:	83 c4 10             	add    $0x10,%esp
  103242:	e9 11 ff ff ff       	jmp    103158 <kern_init+0xa8>
  103247:	89 f6                	mov    %esi,%esi
  103249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dprintf("Test failed.\n");
  103250:	8d 83 d6 b2 ff ff    	lea    -0x4d2a(%ebx),%eax
  103256:	83 ec 0c             	sub    $0xc,%esp
  103259:	50                   	push   %eax
  10325a:	e8 d0 ed ff ff       	call   10202f <dprintf>
  10325f:	83 c4 10             	add    $0x10,%esp
  103262:	e9 69 ff ff ff       	jmp    1031d0 <kern_init+0x120>
  103267:	89 f6                	mov    %esi,%esi
  103269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dprintf("Test failed.\n");
  103270:	8d 83 d6 b2 ff ff    	lea    -0x4d2a(%ebx),%eax
  103276:	83 ec 0c             	sub    $0xc,%esp
  103279:	50                   	push   %eax
  10327a:	e8 b0 ed ff ff       	call   10202f <dprintf>
  10327f:	83 c4 10             	add    $0x10,%esp
  103282:	e9 10 ff ff ff       	jmp    103197 <kern_init+0xe7>
  103287:	89 f6                	mov    %esi,%esi
  103289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dprintf("All tests passed.\n");
  103290:	8d 83 c3 b2 ff ff    	lea    -0x4d3d(%ebx),%eax
  103296:	83 ec 0c             	sub    $0xc,%esp
  103299:	50                   	push   %eax
  10329a:	e8 90 ed ff ff       	call   10202f <dprintf>
  10329f:	83 c4 10             	add    $0x10,%esp
  1032a2:	e9 62 ff ff ff       	jmp    103209 <kern_init+0x159>
  1032a7:	90                   	nop
  1032a8:	02 b0 ad 1b 03 00    	add    0x31bad(%eax),%dh
  1032ae:	00 00                	add    %al,(%eax)
  1032b0:	fb                   	sti    
  1032b1:	4f                   	dec    %edi
  1032b2:	52                   	push   %edx
  1032b3:	e4                   	.byte 0xe4

001032b4 <start>:
	.long	CHECKSUM

	/* this is the entry of the kernel */
	.globl	start
start:
	cli
  1032b4:	fa                   	cli    

	/* check whether the bootloader provide multiboot information */
	cmpl    $MULTIBOOT_BOOTLOADER_MAGIC, %eax
  1032b5:	3d 02 b0 ad 2b       	cmp    $0x2badb002,%eax
	jne     spin
  1032ba:	75 27                	jne    1032e3 <spin>
	movl	%ebx, multiboot_ptr
  1032bc:	89 1d e4 32 10 00    	mov    %ebx,0x1032e4

	/* tell BIOS to warmboot next time */
	movw	$0x1234,0x472
  1032c2:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
  1032c9:	34 12 

	/* clear EFLAGS */
	pushl	$0x2
  1032cb:	6a 02                	push   $0x2
	popfl
  1032cd:	9d                   	popf   

	/* prepare the kernel stack  */
	movl	$0x0,%ebp
  1032ce:	bd 00 00 00 00       	mov    $0x0,%ebp
	movl	$(bsp_kstack+4096),%esp
  1032d3:	bc 00 b0 16 00       	mov    $0x16b000,%esp

	/* jump to the C code */
	push	multiboot_ptr
  1032d8:	ff 35 e4 32 10 00    	pushl  0x1032e4
	call	kern_init
  1032de:	e8 cd fd ff ff       	call   1030b0 <kern_init>

001032e3 <spin>:

	/* should not be here */
spin:
	hlt
  1032e3:	f4                   	hlt    

001032e4 <multiboot_ptr>:
  1032e4:	00 00                	add    %al,(%eax)
  1032e6:	00 00                	add    %al,(%eax)
  1032e8:	66 90                	xchg   %ax,%ax
  1032ea:	66 90                	xchg   %ax,%ax
  1032ec:	66 90                	xchg   %ax,%ax
  1032ee:	66 90                	xchg   %ax,%ax

001032f0 <get_nps>:


/** The getter function for NUM_PAGES. */
unsigned int
get_nps(void)
{
  1032f0:	e8 cd f1 ff ff       	call   1024c2 <__x86.get_pc_thunk.ax>
  1032f5:	05 0b 7d 00 00       	add    $0x7d0b,%eax
  return NUM_PAGES;
  1032fa:	8b 80 4c df 01 00    	mov    0x1df4c(%eax),%eax
}
  103300:	c3                   	ret    
  103301:	eb 0d                	jmp    103310 <set_nps>
  103303:	90                   	nop
  103304:	90                   	nop
  103305:	90                   	nop
  103306:	90                   	nop
  103307:	90                   	nop
  103308:	90                   	nop
  103309:	90                   	nop
  10330a:	90                   	nop
  10330b:	90                   	nop
  10330c:	90                   	nop
  10330d:	90                   	nop
  10330e:	90                   	nop
  10330f:	90                   	nop

00103310 <set_nps>:

/** The setter function for NUM_PAGES. */
void
set_nps(unsigned int nps)
{
  NUM_PAGES = nps;
  103310:	8b 54 24 04          	mov    0x4(%esp),%edx
  103314:	e8 a9 f1 ff ff       	call   1024c2 <__x86.get_pc_thunk.ax>
  103319:	05 e7 7c 00 00       	add    $0x7ce7,%eax
  10331e:	89 90 4c df 01 00    	mov    %edx,0x1df4c(%eax)
}
  103324:	c3                   	ret    
  103325:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  103329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103330 <set_authority_allocated>:

void
set_authority_allocated( int page, int authority_val, int allocated_val){
  103330:	e8 8d f1 ff ff       	call   1024c2 <__x86.get_pc_thunk.ax>
  103335:	05 cb 7c 00 00       	add    $0x7ccb,%eax
  10333a:	8b 54 24 04          	mov    0x4(%esp),%edx
  physical_page_info[page].authority=authority_val;
  10333e:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  103342:	c7 c0 40 eb 1a 00    	mov    $0x1aeb40,%eax
  103348:	89 0c d0             	mov    %ecx,(%eax,%edx,8)
  physical_page_info[page].allocated=allocated_val;
  10334b:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
  10334f:	89 4c d0 04          	mov    %ecx,0x4(%eax,%edx,8)
}
  103353:	c3                   	ret    
  103354:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10335a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00103360 <get_authority>:

unsigned int
get_authority(int page)
{
  103360:	e8 5d f1 ff ff       	call   1024c2 <__x86.get_pc_thunk.ax>
  103365:	05 9b 7c 00 00       	add    $0x7c9b,%eax
  return physical_page_info[page].authority;
  10336a:	8b 54 24 04          	mov    0x4(%esp),%edx
  10336e:	c7 c0 40 eb 1a 00    	mov    $0x1aeb40,%eax
  103374:	8b 04 d0             	mov    (%eax,%edx,8),%eax
}
  103377:	c3                   	ret    
  103378:	90                   	nop
  103379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00103380 <get_allocated>:

unsigned int
get_allocated(int page)
{
  103380:	e8 3d f1 ff ff       	call   1024c2 <__x86.get_pc_thunk.ax>
  103385:	05 7b 7c 00 00       	add    $0x7c7b,%eax
  return physical_page_info[page].allocated;
  10338a:	8b 54 24 04          	mov    0x4(%esp),%edx
  10338e:	c7 c0 40 eb 1a 00    	mov    $0x1aeb40,%eax
  103394:	8b 44 d0 04          	mov    0x4(%eax,%edx,8),%eax
  103398:	c3                   	ret    
  103399:	66 90                	xchg   %ax,%ax
  10339b:	66 90                	xchg   %ax,%ax
  10339d:	66 90                	xchg   %ax,%ax
  10339f:	90                   	nop

001033a0 <MATIntro_test1>:
#include <lib/debug.h>
#include "export.h"

int MATIntro_test1()
{
  1033a0:	55                   	push   %ebp
  1033a1:	57                   	push   %edi
  int rn10[] = {1,3,5,6,78,3576,32,8,0,100};
  int i;
  int nps = get_nps();
  1033a2:	bd 01 00 00 00       	mov    $0x1,%ebp
{
  1033a7:	56                   	push   %esi
  1033a8:	53                   	push   %ebx
  1033a9:	e8 61 cf ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  1033ae:	81 c3 52 7c 00 00    	add    $0x7c52,%ebx
  1033b4:	83 ec 4c             	sub    $0x4c,%esp
  int rn10[] = {1,3,5,6,78,3576,32,8,0,100};
  1033b7:	c7 44 24 18 01 00 00 	movl   $0x1,0x18(%esp)
  1033be:	00 
  1033bf:	c7 44 24 1c 03 00 00 	movl   $0x3,0x1c(%esp)
  1033c6:	00 
  1033c7:	8d 74 24 1c          	lea    0x1c(%esp),%esi
  1033cb:	c7 44 24 20 05 00 00 	movl   $0x5,0x20(%esp)
  1033d2:	00 
  1033d3:	c7 44 24 24 06 00 00 	movl   $0x6,0x24(%esp)
  1033da:	00 
  1033db:	8d 7c 24 40          	lea    0x40(%esp),%edi
  1033df:	c7 44 24 28 4e 00 00 	movl   $0x4e,0x28(%esp)
  1033e6:	00 
  1033e7:	c7 44 24 2c f8 0d 00 	movl   $0xdf8,0x2c(%esp)
  1033ee:	00 
  1033ef:	c7 44 24 30 20 00 00 	movl   $0x20,0x30(%esp)
  1033f6:	00 
  1033f7:	c7 44 24 34 08 00 00 	movl   $0x8,0x34(%esp)
  1033fe:	00 
  1033ff:	c7 44 24 38 00 00 00 	movl   $0x0,0x38(%esp)
  103406:	00 
  103407:	c7 44 24 3c 64 00 00 	movl   $0x64,0x3c(%esp)
  10340e:	00 
  int nps = get_nps();
  10340f:	e8 dc fe ff ff       	call   1032f0 <get_nps>
  103414:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103418:	eb 0b                	jmp    103425 <MATIntro_test1+0x85>
  10341a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103420:	8b 2e                	mov    (%esi),%ebp
  103422:	83 c6 04             	add    $0x4,%esi
  for(i = 0; i< 10; i++) {
    set_nps(rn10[i]);
  103425:	83 ec 0c             	sub    $0xc,%esp
  103428:	55                   	push   %ebp
  103429:	e8 e2 fe ff ff       	call   103310 <set_nps>
    if (get_nps() != rn10[i]) {
  10342e:	e8 bd fe ff ff       	call   1032f0 <get_nps>
  103433:	83 c4 10             	add    $0x10,%esp
  103436:	39 c5                	cmp    %eax,%ebp
  103438:	75 2e                	jne    103468 <MATIntro_test1+0xc8>
  for(i = 0; i< 10; i++) {
  10343a:	39 fe                	cmp    %edi,%esi
  10343c:	75 e2                	jne    103420 <MATIntro_test1+0x80>
      set_nps(nps);
      dprintf("test 1 failed.\n");
      return 1;
    }
  }
  set_nps(nps);
  10343e:	83 ec 0c             	sub    $0xc,%esp
  103441:	ff 74 24 18          	pushl  0x18(%esp)
  103445:	e8 c6 fe ff ff       	call   103310 <set_nps>
  dprintf("test 1 passed.\n");
  10344a:	8d 83 6a b3 ff ff    	lea    -0x4c96(%ebx),%eax
  103450:	89 04 24             	mov    %eax,(%esp)
  103453:	e8 d7 eb ff ff       	call   10202f <dprintf>
  return 0;
  103458:	83 c4 10             	add    $0x10,%esp
  10345b:	31 c0                	xor    %eax,%eax
}
  10345d:	83 c4 4c             	add    $0x4c,%esp
  103460:	5b                   	pop    %ebx
  103461:	5e                   	pop    %esi
  103462:	5f                   	pop    %edi
  103463:	5d                   	pop    %ebp
  103464:	c3                   	ret    
  103465:	8d 76 00             	lea    0x0(%esi),%esi
      set_nps(nps);
  103468:	83 ec 0c             	sub    $0xc,%esp
  10346b:	ff 74 24 18          	pushl  0x18(%esp)
  10346f:	e8 9c fe ff ff       	call   103310 <set_nps>
      dprintf("test 1 failed.\n");
  103474:	8d 83 5a b3 ff ff    	lea    -0x4ca6(%ebx),%eax
  10347a:	89 04 24             	mov    %eax,(%esp)
  10347d:	e8 ad eb ff ff       	call   10202f <dprintf>
      return 1;
  103482:	83 c4 10             	add    $0x10,%esp
  103485:	b8 01 00 00 00       	mov    $0x1,%eax
}
  10348a:	83 c4 4c             	add    $0x4c,%esp
  10348d:	5b                   	pop    %ebx
  10348e:	5e                   	pop    %esi
  10348f:	5f                   	pop    %edi
  103490:	5d                   	pop    %ebp
  103491:	c3                   	ret    
  103492:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001034a0 <MATIntro_test_own>:
int MATIntro_test_own()
{
  // TODO (optional)
  // dprintf("own test passed.\n");
  return 0;
}
  1034a0:	31 c0                	xor    %eax,%eax
  1034a2:	c3                   	ret    
  1034a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1034a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001034b0 <test_MATIntro>:

int test_MATIntro()
{
  return MATIntro_test1() + MATIntro_test_own();
  1034b0:	e9 eb fe ff ff       	jmp    1033a0 <MATIntro_test1>
  1034b5:	66 90                	xchg   %ax,%ax
  1034b7:	66 90                	xchg   %ax,%ax
  1034b9:	66 90                	xchg   %ax,%ax
  1034bb:	66 90                	xchg   %ax,%ax
  1034bd:	66 90                	xchg   %ax,%ax
  1034bf:	90                   	nop

001034c0 <pmem_init>:
#define VM_USERLO_PI  (VM_USERLO / PAGESIZE)   // VM_USERLO page index
#define VM_USERHI_PI  (VM_USERHI / PAGESIZE)   // VM_USERHI page index

void
pmem_init(pmmap_list_type *pmmap_list_p)
{
  1034c0:	55                   	push   %ebp
  1034c1:	57                   	push   %edi
  1034c2:	56                   	push   %esi
  1034c3:	53                   	push   %ebx
  1034c4:	e8 46 ce ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  1034c9:	81 c3 37 7b 00 00    	add    $0x7b37,%ebx
  1034cf:	81 ec 7c 09 00 00    	sub    $0x97c,%esp
	calculate the highest available physical page number ( NPS ) from the information in the pmmap list.
	*/
	int entries = 0,i = 0;
	unsigned int memSET[200][3];//start,end,type
	struct pmmap *pm;
	SLIST_FOREACH(pm, pmmap_list_p, next){
  1034d5:	8b 84 24 90 09 00 00 	mov    0x990(%esp),%eax
  1034dc:	8b 00                	mov    (%eax),%eax
  1034de:	85 c0                	test   %eax,%eax
  1034e0:	0f 84 ba 00 00 00    	je     1035a0 <pmem_init+0xe0>
		// use this array to memory the start and end address, also including the type
		memSET[entries][0]=pm->start;
  1034e6:	8b 10                	mov    (%eax),%edx
		memSET[entries][1]=pm->end;
  1034e8:	8b 48 04             	mov    0x4(%eax),%ecx
		memSET[entries][0]=pm->start;
  1034eb:	89 54 24 10          	mov    %edx,0x10(%esp)
		memSET[entries][2]=pm->type;
  1034ef:	8b 50 08             	mov    0x8(%eax),%edx
		// dprintf("start = %u\n", memSET[entries][0]);
		// dprintf("end = %u\n", memSET[entries][1]);
		// dprintf("type = %u\n", memSET[entries][2]);
		entries++;
		if(SLIST_NEXT(pm,next)== NULL){
  1034f2:	8b 40 0c             	mov    0xc(%eax),%eax
		memSET[entries][1]=pm->end;
  1034f5:	89 4c 24 14          	mov    %ecx,0x14(%esp)
		memSET[entries][2]=pm->type;
  1034f9:	89 54 24 18          	mov    %edx,0x18(%esp)
		if(SLIST_NEXT(pm,next)== NULL){
  1034fd:	85 c0                	test   %eax,%eax
  1034ff:	0f 84 03 01 00 00    	je     103608 <pmem_init+0x148>
  103505:	8d 54 24 1c          	lea    0x1c(%esp),%edx
		entries++;
  103509:	be 01 00 00 00       	mov    $0x1,%esi
  10350e:	66 90                	xchg   %ax,%ax
		memSET[entries][0]=pm->start;
  103510:	8b 08                	mov    (%eax),%ecx
		memSET[entries][2]=pm->type;
  103512:	8b 78 08             	mov    0x8(%eax),%edi
		entries++;
  103515:	83 c6 01             	add    $0x1,%esi
  103518:	83 c2 0c             	add    $0xc,%edx
		memSET[entries][0]=pm->start;
  10351b:	89 4a f4             	mov    %ecx,-0xc(%edx)
		memSET[entries][1]=pm->end;
  10351e:	8b 48 04             	mov    0x4(%eax),%ecx
		if(SLIST_NEXT(pm,next)== NULL){
  103521:	8b 40 0c             	mov    0xc(%eax),%eax
		memSET[entries][2]=pm->type;
  103524:	89 7a fc             	mov    %edi,-0x4(%edx)
		memSET[entries][1]=pm->end;
  103527:	89 4a f8             	mov    %ecx,-0x8(%edx)
		if(SLIST_NEXT(pm,next)== NULL){
  10352a:	85 c0                	test   %eax,%eax
  10352c:	75 e2                	jne    103510 <pmem_init+0x50>
			break;
		}
	}
	nps=pm->end/PAGESIZE+1;
	dprintf("entries = %u\n", entries);
  10352e:	8d 83 7a b3 ff ff    	lea    -0x4c86(%ebx),%eax
  103534:	83 ec 08             	sub    $0x8,%esp
	nps=pm->end/PAGESIZE+1;
  103537:	c1 e9 0c             	shr    $0xc,%ecx
	dprintf("entries = %u\n", entries);
  10353a:	56                   	push   %esi
	nps=pm->end/PAGESIZE+1;
  10353b:	8d 79 01             	lea    0x1(%ecx),%edi
	dprintf("nps = %u\n", nps);
	set_nps(nps);

	for (int i = 0; i < nps; ++i){
  10353e:	31 ed                	xor    %ebp,%ebp
	dprintf("entries = %u\n", entries);
  103540:	50                   	push   %eax
  103541:	e8 e9 ea ff ff       	call   10202f <dprintf>
	dprintf("nps = %u\n", nps);
  103546:	58                   	pop    %eax
  103547:	8d 83 88 b3 ff ff    	lea    -0x4c78(%ebx),%eax
  10354d:	5a                   	pop    %edx
  10354e:	57                   	push   %edi
  10354f:	50                   	push   %eax
  103550:	e8 da ea ff ff       	call   10202f <dprintf>
	set_nps(nps);
  103555:	89 3c 24             	mov    %edi,(%esp)
  103558:	e8 b3 fd ff ff       	call   103310 <set_nps>
  10355d:	83 c4 10             	add    $0x10,%esp
  103560:	89 34 24             	mov    %esi,(%esp)
  103563:	89 ee                	mov    %ebp,%esi
  103565:	8d 76 00             	lea    0x0(%esi),%esi
	  	if(i<VM_USERLO_PI||i>VM_USERHI_PI){
  103568:	8d 96 00 00 fc ff    	lea    -0x40000(%esi),%edx
  10356e:	81 fa 00 00 0b 00    	cmp    $0xb0000,%edx
  103574:	76 3a                	jbe    1035b0 <pmem_init+0xf0>
	  		set_authority_allocated(i,1,0);//kernel mode
  103576:	83 ec 04             	sub    $0x4,%esp
  103579:	6a 00                	push   $0x0
  10357b:	6a 01                	push   $0x1
  10357d:	56                   	push   %esi
  10357e:	e8 ad fd ff ff       	call   103330 <set_authority_allocated>
  103583:	83 c4 10             	add    $0x10,%esp
	for (int i = 0; i < nps; ++i){
  103586:	83 c6 01             	add    $0x1,%esi
  103589:	39 f7                	cmp    %esi,%edi
  10358b:	75 db                	jne    103568 <pmem_init+0xa8>
					set_authority_allocated(i,0,0);//unavailablel
				}
			}
		}
	}
}
  10358d:	81 c4 7c 09 00 00    	add    $0x97c,%esp
  103593:	5b                   	pop    %ebx
  103594:	5e                   	pop    %esi
  103595:	5f                   	pop    %edi
  103596:	5d                   	pop    %ebp
  103597:	c3                   	ret    
  103598:	90                   	nop
  103599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	nps=pm->end/PAGESIZE+1;
  1035a0:	a1 04 00 00 00       	mov    0x4,%eax
  1035a5:	0f 0b                	ud2    
  1035a7:	89 f6                	mov    %esi,%esi
  1035a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  1035b0:	89 f0                	mov    %esi,%eax
  1035b2:	8d 54 24 10          	lea    0x10(%esp),%edx
		  	for (int r = 0; r < entries; ++r)
  1035b6:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  1035ba:	c1 e0 0c             	shl    $0xc,%eax
  1035bd:	31 ed                	xor    %ebp,%ebp
  1035bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035c3:	05 ff 0f 00 00       	add    $0xfff,%eax
  1035c8:	89 d7                	mov    %edx,%edi
  1035ca:	89 44 24 08          	mov    %eax,0x8(%esp)
  1035ce:	66 90                	xchg   %ax,%ax
				if (i*PAGESIZE>=memSET[r][0]&&i*PAGESIZE+PAGESIZE-1<memSET[r][1])
  1035d0:	8b 44 24 04          	mov    0x4(%esp),%eax
  1035d4:	39 07                	cmp    %eax,(%edi)
  1035d6:	77 09                	ja     1035e1 <pmem_init+0x121>
  1035d8:	8b 44 24 08          	mov    0x8(%esp),%eax
  1035dc:	39 47 04             	cmp    %eax,0x4(%edi)
  1035df:	77 31                	ja     103612 <pmem_init+0x152>
					set_authority_allocated(i,0,0);//unavailablel
  1035e1:	83 ec 04             	sub    $0x4,%esp
		  	for (int r = 0; r < entries; ++r)
  1035e4:	83 c5 01             	add    $0x1,%ebp
  1035e7:	83 c7 0c             	add    $0xc,%edi
					set_authority_allocated(i,0,0);//unavailablel
  1035ea:	6a 00                	push   $0x0
  1035ec:	6a 00                	push   $0x0
  1035ee:	56                   	push   %esi
  1035ef:	e8 3c fd ff ff       	call   103330 <set_authority_allocated>
		  	for (int r = 0; r < entries; ++r)
  1035f4:	83 c4 10             	add    $0x10,%esp
  1035f7:	3b 2c 24             	cmp    (%esp),%ebp
  1035fa:	75 d4                	jne    1035d0 <pmem_init+0x110>
  1035fc:	8b 7c 24 0c          	mov    0xc(%esp),%edi
  103600:	eb 84                	jmp    103586 <pmem_init+0xc6>
  103602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		entries++;
  103608:	be 01 00 00 00       	mov    $0x1,%esi
  10360d:	e9 1c ff ff ff       	jmp    10352e <pmem_init+0x6e>
					memSET[r][2]==1?set_authority_allocated(i,2,0):set_authority_allocated(i,0,0);
  103612:	8d 54 6d 00          	lea    0x0(%ebp,%ebp,2),%edx
  103616:	8b 7c 24 0c          	mov    0xc(%esp),%edi
  10361a:	83 7c 94 18 01       	cmpl   $0x1,0x18(%esp,%edx,4)
  10361f:	74 15                	je     103636 <pmem_init+0x176>
  103621:	83 ec 04             	sub    $0x4,%esp
  103624:	6a 00                	push   $0x0
  103626:	6a 00                	push   $0x0
  103628:	56                   	push   %esi
  103629:	e8 02 fd ff ff       	call   103330 <set_authority_allocated>
  10362e:	83 c4 10             	add    $0x10,%esp
  103631:	e9 50 ff ff ff       	jmp    103586 <pmem_init+0xc6>
  103636:	83 ec 04             	sub    $0x4,%esp
  103639:	6a 00                	push   $0x0
  10363b:	6a 02                	push   $0x2
  10363d:	56                   	push   %esi
  10363e:	e8 ed fc ff ff       	call   103330 <set_authority_allocated>
  103643:	83 c4 10             	add    $0x10,%esp
  103646:	e9 3b ff ff ff       	jmp    103586 <pmem_init+0xc6>
  10364b:	66 90                	xchg   %ax,%ax
  10364d:	66 90                	xchg   %ax,%ax
  10364f:	90                   	nop

00103650 <MATInit_test1>:
#include <lib/debug.h>
#include <pmm/MATIntro/export.h>

int MATInit_test1()
{
  103650:	53                   	push   %ebx
  103651:	e8 b9 cc ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  103656:	81 c3 aa 79 00 00    	add    $0x79aa,%ebx
  10365c:	83 ec 08             	sub    $0x8,%esp
  int i;
  int nps = get_nps();
  10365f:	e8 8c fc ff ff       	call   1032f0 <get_nps>
  if (nps <= 1000) {
  103664:	3d e8 03 00 00       	cmp    $0x3e8,%eax
  103669:	7e 1d                	jle    103688 <MATInit_test1+0x38>
    dprintf("test 1 failed.\n");
    return 1;
  }

  dprintf("test 1 passed.\n");
  10366b:	8d 83 6a b3 ff ff    	lea    -0x4c96(%ebx),%eax
  103671:	83 ec 0c             	sub    $0xc,%esp
  103674:	50                   	push   %eax
  103675:	e8 b5 e9 ff ff       	call   10202f <dprintf>
  return 0;
  10367a:	83 c4 10             	add    $0x10,%esp
  10367d:	31 c0                	xor    %eax,%eax
}
  10367f:	83 c4 08             	add    $0x8,%esp
  103682:	5b                   	pop    %ebx
  103683:	c3                   	ret    
  103684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dprintf("test 1 failed.\n");
  103688:	8d 83 5a b3 ff ff    	lea    -0x4ca6(%ebx),%eax
  10368e:	83 ec 0c             	sub    $0xc,%esp
  103691:	50                   	push   %eax
  103692:	e8 98 e9 ff ff       	call   10202f <dprintf>
    return 1;
  103697:	83 c4 10             	add    $0x10,%esp
  10369a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  10369f:	83 c4 08             	add    $0x8,%esp
  1036a2:	5b                   	pop    %ebx
  1036a3:	c3                   	ret    
  1036a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1036aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001036b0 <MATInit_test_own>:
int MATInit_test_own()
{
  // TODO (optional)
  // dprintf("own test passed.\n");
  return 0;
}
  1036b0:	31 c0                	xor    %eax,%eax
  1036b2:	c3                   	ret    
  1036b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1036b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001036c0 <test_MATInit>:

int test_MATInit()
{
  return MATInit_test1() + MATInit_test_own();
  1036c0:	eb 8e                	jmp    103650 <MATInit_test1>
  1036c2:	66 90                	xchg   %ax,%ax
  1036c4:	66 90                	xchg   %ax,%ax
  1036c6:	66 90                	xchg   %ax,%ax
  1036c8:	66 90                	xchg   %ax,%ax
  1036ca:	66 90                	xchg   %ax,%ax
  1036cc:	66 90                	xchg   %ax,%ax
  1036ce:	66 90                	xchg   %ax,%ax

001036d0 <palloc>:
#define unallocated 0
#define allocated 1

unsigned int
palloc()
{
  1036d0:	57                   	push   %edi
  1036d1:	56                   	push   %esi
  // TODO
  for (int i = 0x40000000/4096; i < 0xF0000000/4096; ++i)
  1036d2:	be 00 00 04 00       	mov    $0x40000,%esi
{
  1036d7:	53                   	push   %ebx
  1036d8:	e8 32 cc ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  1036dd:	81 c3 23 79 00 00    	add    $0x7923,%ebx
  1036e3:	eb 0e                	jmp    1036f3 <palloc+0x23>
  1036e5:	8d 76 00             	lea    0x0(%esi),%esi
  for (int i = 0x40000000/4096; i < 0xF0000000/4096; ++i)
  1036e8:	83 c6 01             	add    $0x1,%esi
  1036eb:	81 fe 00 00 0f 00    	cmp    $0xf0000,%esi
  1036f1:	74 39                	je     10372c <palloc+0x5c>
  {
    if(get_authority(i)==available && get_allocated(i)==unallocated){
  1036f3:	83 ec 0c             	sub    $0xc,%esp
  1036f6:	89 f7                	mov    %esi,%edi
  1036f8:	56                   	push   %esi
  1036f9:	e8 62 fc ff ff       	call   103360 <get_authority>
  1036fe:	83 c4 10             	add    $0x10,%esp
  103701:	83 f8 02             	cmp    $0x2,%eax
  103704:	75 e2                	jne    1036e8 <palloc+0x18>
  103706:	83 ec 0c             	sub    $0xc,%esp
  103709:	56                   	push   %esi
  10370a:	e8 71 fc ff ff       	call   103380 <get_allocated>
  10370f:	83 c4 10             	add    $0x10,%esp
  103712:	85 c0                	test   %eax,%eax
  103714:	75 d2                	jne    1036e8 <palloc+0x18>
      set_authority_allocated(i,available,allocated);
  103716:	83 ec 04             	sub    $0x4,%esp
  103719:	6a 01                	push   $0x1
  10371b:	6a 02                	push   $0x2
  10371d:	56                   	push   %esi
  10371e:	e8 0d fc ff ff       	call   103330 <set_authority_allocated>
      return i;
  103723:	83 c4 10             	add    $0x10,%esp
    }
  }
  return 0;
}
  103726:	89 f8                	mov    %edi,%eax
  103728:	5b                   	pop    %ebx
  103729:	5e                   	pop    %esi
  10372a:	5f                   	pop    %edi
  10372b:	c3                   	ret    
  return 0;
  10372c:	31 ff                	xor    %edi,%edi
}
  10372e:	89 f8                	mov    %edi,%eax
  103730:	5b                   	pop    %ebx
  103731:	5e                   	pop    %esi
  103732:	5f                   	pop    %edi
  103733:	c3                   	ret    
  103734:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10373a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00103740 <pfree>:
  * Hint: Simple. Check if a page is allocated and to set the allocation status
  *       of a page index.
  */
void
pfree(unsigned int pfree_index)
{
  103740:	56                   	push   %esi
  103741:	53                   	push   %ebx
  103742:	e8 c8 cb ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  103747:	81 c3 b9 78 00 00    	add    $0x78b9,%ebx
  10374d:	83 ec 10             	sub    $0x10,%esp
  103750:	8b 74 24 1c          	mov    0x1c(%esp),%esi
  // TODO
  if(get_allocated(pfree_index)==allocated){
  103754:	56                   	push   %esi
  103755:	e8 26 fc ff ff       	call   103380 <get_allocated>
  10375a:	83 c4 10             	add    $0x10,%esp
  10375d:	83 f8 01             	cmp    $0x1,%eax
  103760:	74 0e                	je     103770 <pfree+0x30>
    set_authority_allocated(pfree_index,get_authority(pfree_index),unallocated);
  }
}
  103762:	83 c4 04             	add    $0x4,%esp
  103765:	5b                   	pop    %ebx
  103766:	5e                   	pop    %esi
  103767:	c3                   	ret    
  103768:	90                   	nop
  103769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    set_authority_allocated(pfree_index,get_authority(pfree_index),unallocated);
  103770:	83 ec 0c             	sub    $0xc,%esp
  103773:	56                   	push   %esi
  103774:	e8 e7 fb ff ff       	call   103360 <get_authority>
  103779:	83 c4 0c             	add    $0xc,%esp
  10377c:	6a 00                	push   $0x0
  10377e:	50                   	push   %eax
  10377f:	56                   	push   %esi
  103780:	e8 ab fb ff ff       	call   103330 <set_authority_allocated>
  103785:	83 c4 10             	add    $0x10,%esp
}
  103788:	83 c4 04             	add    $0x4,%esp
  10378b:	5b                   	pop    %ebx
  10378c:	5e                   	pop    %esi
  10378d:	c3                   	ret    
  10378e:	66 90                	xchg   %ax,%ax

00103790 <MATOp_test1>:
#include <lib/debug.h>
#include <pmm/MATIntro/export.h>
#include "export.h"

int MATOp_test1()
{
  103790:	53                   	push   %ebx
  103791:	e8 79 cb ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  103796:	81 c3 6a 78 00 00    	add    $0x786a,%ebx
  10379c:	83 ec 08             	sub    $0x8,%esp
  int page_index = palloc();
  10379f:	e8 2c ff ff ff       	call   1036d0 <palloc>
  if (page_index < 262144) {
  1037a4:	3d ff ff 03 00       	cmp    $0x3ffff,%eax
  1037a9:	7e 1d                	jle    1037c8 <MATOp_test1+0x38>
    pfree(page_index);
    dprintf("test 1 failed.\n");
    return 1;
  }

  dprintf("test 1 passed.\n");
  1037ab:	8d 83 6a b3 ff ff    	lea    -0x4c96(%ebx),%eax
  1037b1:	83 ec 0c             	sub    $0xc,%esp
  1037b4:	50                   	push   %eax
  1037b5:	e8 75 e8 ff ff       	call   10202f <dprintf>
  return 0;
  1037ba:	83 c4 10             	add    $0x10,%esp
  1037bd:	31 c0                	xor    %eax,%eax
}
  1037bf:	83 c4 08             	add    $0x8,%esp
  1037c2:	5b                   	pop    %ebx
  1037c3:	c3                   	ret    
  1037c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pfree(page_index);
  1037c8:	83 ec 0c             	sub    $0xc,%esp
  1037cb:	50                   	push   %eax
  1037cc:	e8 6f ff ff ff       	call   103740 <pfree>
    dprintf("test 1 failed.\n");
  1037d1:	8d 83 5a b3 ff ff    	lea    -0x4ca6(%ebx),%eax
  1037d7:	89 04 24             	mov    %eax,(%esp)
  1037da:	e8 50 e8 ff ff       	call   10202f <dprintf>
    return 1;
  1037df:	83 c4 10             	add    $0x10,%esp
  1037e2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  1037e7:	83 c4 08             	add    $0x8,%esp
  1037ea:	5b                   	pop    %ebx
  1037eb:	c3                   	ret    
  1037ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001037f0 <MATOp_test_own>:
int MATOp_test_own()
{
  // TODO (optional)
  // dprintf("own test passed.\n");
  return 0;
}
  1037f0:	31 c0                	xor    %eax,%eax
  1037f2:	c3                   	ret    
  1037f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1037f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103800 <test_MATOp>:

int test_MATOp()
{
  return MATOp_test1() + MATOp_test_own();
  103800:	eb 8e                	jmp    103790 <MATOp_test1>
  103802:	66 90                	xchg   %ax,%ax
  103804:	66 90                	xchg   %ax,%ax
  103806:	66 90                	xchg   %ax,%ax
  103808:	66 90                	xchg   %ax,%ax
  10380a:	66 90                	xchg   %ax,%ax
  10380c:	66 90                	xchg   %ax,%ax
  10380e:	66 90                	xchg   %ax,%ax

00103810 <container_init>:
/**
  * Initializes the container data for the root process (the one with index 0).
  * The root process is the one that gets spawned first by the kernel.
  */
void container_init(unsigned int mbi_addr)
{
  103810:	57                   	push   %edi
  unsigned int real_quota;
  real_quota = 0;
  103811:	31 ff                	xor    %edi,%edi
{
  103813:	56                   	push   %esi
    * Hint 1:
    *  - It should be the number of the unallocated pages with the normal permission
    *    in the physical memory data-structure you implemented.
    */
  //TODO
  for (int i = 0; i < get_nps(); ++i)
  103814:	31 f6                	xor    %esi,%esi
{
  103816:	53                   	push   %ebx
  103817:	e8 f3 ca ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  10381c:	81 c3 e4 77 00 00    	add    $0x77e4,%ebx
  for (int i = 0; i < get_nps(); ++i)
  103822:	eb 07                	jmp    10382b <container_init+0x1b>
  103824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  103828:	83 c6 01             	add    $0x1,%esi
  10382b:	e8 c0 fa ff ff       	call   1032f0 <get_nps>
  103830:	39 f0                	cmp    %esi,%eax
  103832:	76 2c                	jbe    103860 <container_init+0x50>
  {
    /* code */
    if (get_authority(i)==available && get_allocated(i)==unallocated)
  103834:	83 ec 0c             	sub    $0xc,%esp
  103837:	56                   	push   %esi
  103838:	e8 23 fb ff ff       	call   103360 <get_authority>
  10383d:	83 c4 10             	add    $0x10,%esp
  103840:	83 f8 02             	cmp    $0x2,%eax
  103843:	75 e3                	jne    103828 <container_init+0x18>
  103845:	83 ec 0c             	sub    $0xc,%esp
  103848:	56                   	push   %esi
  103849:	e8 32 fb ff ff       	call   103380 <get_allocated>
  10384e:	83 c4 10             	add    $0x10,%esp
    {
      /* code */
      real_quota++;
  103851:	83 f8 01             	cmp    $0x1,%eax
  103854:	83 d7 00             	adc    $0x0,%edi
  103857:	eb cf                	jmp    103828 <container_init+0x18>
  103859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  KERN_DEBUG("\nreal quota: %d\n\n", real_quota);
  103860:	8d 83 92 b3 ff ff    	lea    -0x4c6e(%ebx),%eax
  103866:	57                   	push   %edi
  103867:	50                   	push   %eax
  103868:	8d 83 a4 b3 ff ff    	lea    -0x4c5c(%ebx),%eax
  10386e:	6a 41                	push   $0x41
  103870:	50                   	push   %eax
  103871:	e8 ed e5 ff ff       	call   101e63 <debug_normal>
  CONTAINER[0].quota = real_quota;
  CONTAINER[0].usage = 0;
  CONTAINER[0].parent = 0;
  CONTAINER[0].nchildren = 0;
  CONTAINER[0].used = 1;
}
  103876:	83 c4 10             	add    $0x10,%esp
  CONTAINER[0].quota = real_quota;
  103879:	89 bb 60 df 01 00    	mov    %edi,0x1df60(%ebx)
  CONTAINER[0].usage = 0;
  10387f:	c7 83 64 df 01 00 00 	movl   $0x0,0x1df64(%ebx)
  103886:	00 00 00 
  CONTAINER[0].parent = 0;
  103889:	c7 83 68 df 01 00 00 	movl   $0x0,0x1df68(%ebx)
  103890:	00 00 00 
  CONTAINER[0].nchildren = 0;
  103893:	c7 83 6c df 01 00 00 	movl   $0x0,0x1df6c(%ebx)
  10389a:	00 00 00 
  CONTAINER[0].used = 1;
  10389d:	c7 83 70 df 01 00 01 	movl   $0x1,0x1df70(%ebx)
  1038a4:	00 00 00 
}
  1038a7:	5b                   	pop    %ebx
  1038a8:	5e                   	pop    %esi
  1038a9:	5f                   	pop    %edi
  1038aa:	c3                   	ret    
  1038ab:	90                   	nop
  1038ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001038b0 <container_get_parent>:
/** TASK 2:
  * * Get the id of parent process of process # [id]
  * Hint: Simply return the parent field from CONTAINER for process id.
  */
unsigned int container_get_parent(unsigned int id)
{
  1038b0:	8b 44 24 04          	mov    0x4(%esp),%eax
  1038b4:	e8 c2 db ff ff       	call   10147b <__x86.get_pc_thunk.dx>
  1038b9:	81 c2 47 77 00 00    	add    $0x7747,%edx
  // TODO
  return CONTAINER[id].parent;
  1038bf:	8d 04 80             	lea    (%eax,%eax,4),%eax
  1038c2:	8b 84 82 68 df 01 00 	mov    0x1df68(%edx,%eax,4),%eax
}
  1038c9:	c3                   	ret    
  1038ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001038d0 <container_get_nchildren>:

/** TASK 3:
  * * Get the number of children of process # [id]
  */
unsigned int container_get_nchildren(unsigned int id)
{
  1038d0:	8b 44 24 04          	mov    0x4(%esp),%eax
  1038d4:	e8 a2 db ff ff       	call   10147b <__x86.get_pc_thunk.dx>
  1038d9:	81 c2 27 77 00 00    	add    $0x7727,%edx
  // TODO
  return CONTAINER[id].nchildren;
  1038df:	8d 04 80             	lea    (%eax,%eax,4),%eax
  1038e2:	8b 84 82 6c df 01 00 	mov    0x1df6c(%edx,%eax,4),%eax
}
  1038e9:	c3                   	ret    
  1038ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001038f0 <container_get_quota>:

/** TASK 4:
  * * Get the maximum memory quota of process # [id]
  */
unsigned int container_get_quota(unsigned int id)
{
  1038f0:	8b 44 24 04          	mov    0x4(%esp),%eax
  1038f4:	e8 82 db ff ff       	call   10147b <__x86.get_pc_thunk.dx>
  1038f9:	81 c2 07 77 00 00    	add    $0x7707,%edx
  // TODO
  return CONTAINER[id].quota;
  1038ff:	8d 04 80             	lea    (%eax,%eax,4),%eax
  103902:	8b 84 82 60 df 01 00 	mov    0x1df60(%edx,%eax,4),%eax
}
  103909:	c3                   	ret    
  10390a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103910 <container_get_usage>:

/** TASK 5:
  * * Get the current memory usage of process # [id]
  */
unsigned int container_get_usage(unsigned int id)
{
  103910:	8b 44 24 04          	mov    0x4(%esp),%eax
  103914:	e8 62 db ff ff       	call   10147b <__x86.get_pc_thunk.dx>
  103919:	81 c2 e7 76 00 00    	add    $0x76e7,%edx
  // TODO
  return CONTAINER[id].usage;
  10391f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  103922:	8b 84 82 64 df 01 00 	mov    0x1df64(%edx,%eax,4),%eax
}
  103929:	c3                   	ret    
  10392a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103930 <container_can_consume>:
  * * Determine whether the process # [id] can consume extra
  *   [n] pages of memory. If so, return 1, otherwise, return 0.
  * Hint 1: Check the definition of available fields in SContainer data-structure.
  */
unsigned int container_can_consume(unsigned int id, unsigned int n)
{
  103930:	8b 44 24 04          	mov    0x4(%esp),%eax
  103934:	e8 42 db ff ff       	call   10147b <__x86.get_pc_thunk.dx>
  103939:	81 c2 c7 76 00 00    	add    $0x76c7,%edx
  // TODO
  return CONTAINER[id].quota - CONTAINER[id].usage>=n?1:0;
  10393f:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
  103942:	8b 84 8a 60 df 01 00 	mov    0x1df60(%edx,%ecx,4),%eax
  103949:	2b 84 8a 64 df 01 00 	sub    0x1df64(%edx,%ecx,4),%eax
  103950:	3b 44 24 08          	cmp    0x8(%esp),%eax
  103954:	0f 93 c0             	setae  %al
  103957:	0f b6 c0             	movzbl %al,%eax
}
  10395a:	c3                   	ret    
  10395b:	90                   	nop
  10395c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00103960 <container_split>:
/**
 * Dedicates [quota] pages of memory for a new child process.
 * returns the container index for the new child process.
 */
unsigned int container_split(unsigned int id, unsigned int quota)
{
  103960:	55                   	push   %ebp
  103961:	57                   	push   %edi
  103962:	56                   	push   %esi
  103963:	53                   	push   %ebx
  103964:	8b 4c 24 14          	mov    0x14(%esp),%ecx
  103968:	8b 7c 24 18          	mov    0x18(%esp),%edi
  10396c:	e8 aa cb ff ff       	call   10051b <__x86.get_pc_thunk.si>
  103971:	81 c6 8f 76 00 00    	add    $0x768f,%esi
  unsigned int child, nc;

  nc = CONTAINER[id].nchildren;
  103977:	8d 1c 89             	lea    (%ecx,%ecx,4),%ebx
  child = id * MAX_CHILDREN + 1 + nc; //container index for the child process
  10397a:	8d 44 49 01          	lea    0x1(%ecx,%ecx,2),%eax
  nc = CONTAINER[id].nchildren;
  10397e:	c1 e3 02             	shl    $0x2,%ebx
  103981:	8d 94 1e 60 df 01 00 	lea    0x1df60(%esi,%ebx,1),%edx

  CONTAINER[id].quota = CONTAINER[id].quota;
  CONTAINER[id].usage = CONTAINER[id].usage+quota;
  CONTAINER[id].parent = CONTAINER[id].parent;
  CONTAINER[id].nchildren = CONTAINER[id].nchildren+1;
  CONTAINER[id].used = 1;
  103988:	c7 84 33 70 df 01 00 	movl   $0x1,0x1df70(%ebx,%esi,1)
  10398f:	01 00 00 00 
  nc = CONTAINER[id].nchildren;
  103993:	8b 6a 0c             	mov    0xc(%edx),%ebp
  CONTAINER[id].usage = CONTAINER[id].usage+quota;
  103996:	01 7a 04             	add    %edi,0x4(%edx)
  child = id * MAX_CHILDREN + 1 + nc; //container index for the child process
  103999:	01 e8                	add    %ebp,%eax
  CONTAINER[id].nchildren = CONTAINER[id].nchildren+1;
  10399b:	83 c5 01             	add    $0x1,%ebp

  CONTAINER[child].quota = quota;
  10399e:	8d 1c 80             	lea    (%eax,%eax,4),%ebx
  CONTAINER[id].nchildren = CONTAINER[id].nchildren+1;
  1039a1:	89 6a 0c             	mov    %ebp,0xc(%edx)
  CONTAINER[id].used = 1;
  1039a4:	8d 96 60 df 01 00    	lea    0x1df60(%esi),%edx
  CONTAINER[child].quota = quota;
  1039aa:	c1 e3 02             	shl    $0x2,%ebx
  1039ad:	01 da                	add    %ebx,%edx
  CONTAINER[child].usage = 0;
  1039af:	8d 9c 1e 60 df 01 00 	lea    0x1df60(%esi,%ebx,1),%ebx
  CONTAINER[child].quota = quota;
  1039b6:	89 3a                	mov    %edi,(%edx)
  CONTAINER[child].parent = id;
  CONTAINER[child].nchildren = 0;
  CONTAINER[child].used = 1;
  1039b8:	c7 42 10 01 00 00 00 	movl   $0x1,0x10(%edx)
  CONTAINER[child].usage = 0;
  1039bf:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  CONTAINER[child].parent = id;
  1039c6:	89 4b 08             	mov    %ecx,0x8(%ebx)
  CONTAINER[child].nchildren = 0;
  1039c9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

  return child;
}
  1039d0:	5b                   	pop    %ebx
  1039d1:	5e                   	pop    %esi
  1039d2:	5f                   	pop    %edi
  1039d3:	5d                   	pop    %ebp
  1039d4:	c3                   	ret    
  1039d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1039d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001039e0 <container_alloc>:
  * * 1. Allocates one more page for process # [id], given that its usage would not exceed the quota.
  * * 2. Update the contained structure to reflect the container structure should be updated accordingly after the allocation.
  * returns the page index of the allocated page, or 0 in the case of failure.
  */
unsigned int container_alloc(unsigned int id)
{
  1039e0:	56                   	push   %esi
  1039e1:	53                   	push   %ebx
  1039e2:	e8 28 c9 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  1039e7:	81 c3 19 76 00 00    	add    $0x7619,%ebx
  1039ed:	83 ec 04             	sub    $0x4,%esp
  1039f0:	8b 44 24 10          	mov    0x10(%esp),%eax
  /*
   * TODO: implement the function here.
   */
  if (CONTAINER[id].usage+1<=CONTAINER[id].quota)
  1039f4:	8d 14 80             	lea    (%eax,%eax,4),%edx
  1039f7:	31 c0                	xor    %eax,%eax
  1039f9:	c1 e2 02             	shl    $0x2,%edx
  1039fc:	8d b4 13 60 df 01 00 	lea    0x1df60(%ebx,%edx,1),%esi
  103a03:	8b 4e 04             	mov    0x4(%esi),%ecx
  103a06:	3b 8c 13 60 df 01 00 	cmp    0x1df60(%ebx,%edx,1),%ecx
  103a0d:	7d 0b                	jge    103a1a <container_alloc+0x3a>
  {
    /* code */
    CONTAINER[id].usage++;
  103a0f:	83 c1 01             	add    $0x1,%ecx
  103a12:	89 4e 04             	mov    %ecx,0x4(%esi)
    return palloc();
  103a15:	e8 b6 fc ff ff       	call   1036d0 <palloc>
  }
  return 0;
}
  103a1a:	83 c4 04             	add    $0x4,%esp
  103a1d:	5b                   	pop    %ebx
  103a1e:	5e                   	pop    %esi
  103a1f:	c3                   	ret    

00103a20 <container_free>:
  * Hint: You have already implemented functions:
  *  - to check if a page_index is allocated
  *  - to free a page_index in MATOp layer.
  */
void container_free(unsigned int id, unsigned int page_index)
{
  103a20:	53                   	push   %ebx
  103a21:	e8 e9 c8 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  103a26:	81 c3 da 75 00 00    	add    $0x75da,%ebx
  103a2c:	83 ec 08             	sub    $0x8,%esp
  103a2f:	8b 44 24 10          	mov    0x10(%esp),%eax
  // TODO
  if(CONTAINER[id].usage>0){
  103a33:	8d 04 80             	lea    (%eax,%eax,4),%eax
  103a36:	8d 94 83 60 df 01 00 	lea    0x1df60(%ebx,%eax,4),%edx
  103a3d:	8b 42 04             	mov    0x4(%edx),%eax
  103a40:	85 c0                	test   %eax,%eax
  103a42:	7e 15                	jle    103a59 <container_free+0x39>
    CONTAINER[id].usage--;
    pfree(page_index);
  103a44:	83 ec 0c             	sub    $0xc,%esp
    CONTAINER[id].usage--;
  103a47:	83 e8 01             	sub    $0x1,%eax
  103a4a:	89 42 04             	mov    %eax,0x4(%edx)
    pfree(page_index);
  103a4d:	ff 74 24 20          	pushl  0x20(%esp)
  103a51:	e8 ea fc ff ff       	call   103740 <pfree>
  103a56:	83 c4 10             	add    $0x10,%esp
  }
  
}
  103a59:	83 c4 08             	add    $0x8,%esp
  103a5c:	5b                   	pop    %ebx
  103a5d:	c3                   	ret    
  103a5e:	66 90                	xchg   %ax,%ax

00103a60 <MContainer_test1>:
#include <lib/debug.h>
#include "export.h"

int MContainer_test1()
{
  103a60:	53                   	push   %ebx
  103a61:	e8 a9 c8 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  103a66:	81 c3 9a 75 00 00    	add    $0x759a,%ebx
  103a6c:	83 ec 14             	sub    $0x14,%esp
  if (container_get_quota(0) <= 10000) {
  103a6f:	6a 00                	push   $0x0
  103a71:	e8 7a fe ff ff       	call   1038f0 <container_get_quota>
  103a76:	83 c4 10             	add    $0x10,%esp
  103a79:	3d 10 27 00 00       	cmp    $0x2710,%eax
  103a7e:	76 17                	jbe    103a97 <MContainer_test1+0x37>
    dprintf("test 1 failed.\n");
    return 1;
  }
  if (container_can_consume(0, 10000) != 1) {
  103a80:	83 ec 08             	sub    $0x8,%esp
  103a83:	68 10 27 00 00       	push   $0x2710
  103a88:	6a 00                	push   $0x0
  103a8a:	e8 a1 fe ff ff       	call   103930 <container_can_consume>
  103a8f:	83 c4 10             	add    $0x10,%esp
  103a92:	83 f8 01             	cmp    $0x1,%eax
  103a95:	74 21                	je     103ab8 <MContainer_test1+0x58>
    dprintf("test 1 failed.\n");
  103a97:	8d 83 5a b3 ff ff    	lea    -0x4ca6(%ebx),%eax
  103a9d:	83 ec 0c             	sub    $0xc,%esp
  103aa0:	50                   	push   %eax
  103aa1:	e8 89 e5 ff ff       	call   10202f <dprintf>
    return 1;
  103aa6:	83 c4 10             	add    $0x10,%esp
  103aa9:	b8 01 00 00 00       	mov    $0x1,%eax
    dprintf("test 1 failed.\n");
    return 1;
  }
  dprintf("test 1 passed.\n");
  return 0;
}
  103aae:	83 c4 08             	add    $0x8,%esp
  103ab1:	5b                   	pop    %ebx
  103ab2:	c3                   	ret    
  103ab3:	90                   	nop
  103ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (container_can_consume(0, 10000000) != 0) {
  103ab8:	83 ec 08             	sub    $0x8,%esp
  103abb:	68 80 96 98 00       	push   $0x989680
  103ac0:	6a 00                	push   $0x0
  103ac2:	e8 69 fe ff ff       	call   103930 <container_can_consume>
  103ac7:	83 c4 10             	add    $0x10,%esp
  103aca:	85 c0                	test   %eax,%eax
  103acc:	75 c9                	jne    103a97 <MContainer_test1+0x37>
  dprintf("test 1 passed.\n");
  103ace:	8d 83 6a b3 ff ff    	lea    -0x4c96(%ebx),%eax
  103ad4:	83 ec 0c             	sub    $0xc,%esp
  103ad7:	50                   	push   %eax
  103ad8:	e8 52 e5 ff ff       	call   10202f <dprintf>
  103add:	83 c4 10             	add    $0x10,%esp
  return 0;
  103ae0:	31 c0                	xor    %eax,%eax
}
  103ae2:	83 c4 08             	add    $0x8,%esp
  103ae5:	5b                   	pop    %ebx
  103ae6:	c3                   	ret    
  103ae7:	89 f6                	mov    %esi,%esi
  103ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103af0 <MContainer_test2>:


int MContainer_test2()
{
  103af0:	55                   	push   %ebp
  103af1:	57                   	push   %edi
  103af2:	56                   	push   %esi
  103af3:	53                   	push   %ebx
  103af4:	e8 16 c8 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  103af9:	81 c3 07 75 00 00    	add    $0x7507,%ebx
  103aff:	83 ec 18             	sub    $0x18,%esp
  unsigned int old_usage = container_get_usage(0);
  103b02:	6a 00                	push   $0x0
  103b04:	e8 07 fe ff ff       	call   103910 <container_get_usage>
  unsigned int old_nchildren = container_get_nchildren(0);
  103b09:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  unsigned int old_usage = container_get_usage(0);
  103b10:	89 c7                	mov    %eax,%edi
  unsigned int old_nchildren = container_get_nchildren(0);
  103b12:	e8 b9 fd ff ff       	call   1038d0 <container_get_nchildren>
  103b17:	89 c5                	mov    %eax,%ebp
  unsigned int chid = container_split(0, 100);
  103b19:	58                   	pop    %eax
  103b1a:	5a                   	pop    %edx
  103b1b:	6a 64                	push   $0x64
  103b1d:	6a 00                	push   $0x0
  103b1f:	e8 3c fe ff ff       	call   103960 <container_split>
  if (container_get_quota(chid) != 100 || container_get_parent(chid) != 0 ||
  103b24:	89 04 24             	mov    %eax,(%esp)
  unsigned int chid = container_split(0, 100);
  103b27:	89 c6                	mov    %eax,%esi
  if (container_get_quota(chid) != 100 || container_get_parent(chid) != 0 ||
  103b29:	e8 c2 fd ff ff       	call   1038f0 <container_get_quota>
  103b2e:	83 c4 10             	add    $0x10,%esp
  103b31:	83 f8 64             	cmp    $0x64,%eax
  103b34:	74 22                	je     103b58 <MContainer_test2+0x68>
      container_get_usage(chid) != 0 || container_get_nchildren(chid) != 0 ||
      container_get_usage(0) != old_usage + 100 || container_get_nchildren(0) != old_nchildren + 1) {
    dprintf("test 2 failed.\n");
  103b36:	8d 83 c5 b3 ff ff    	lea    -0x4c3b(%ebx),%eax
  103b3c:	83 ec 0c             	sub    $0xc,%esp
  103b3f:	50                   	push   %eax
  103b40:	e8 ea e4 ff ff       	call   10202f <dprintf>
    return 1;
  103b45:	83 c4 10             	add    $0x10,%esp
  103b48:	b8 01 00 00 00       	mov    $0x1,%eax
    dprintf("test 2 failed.\n");
    return 1;
  }
  dprintf("test 2 passed.\n");
  return 0;
}
  103b4d:	83 c4 0c             	add    $0xc,%esp
  103b50:	5b                   	pop    %ebx
  103b51:	5e                   	pop    %esi
  103b52:	5f                   	pop    %edi
  103b53:	5d                   	pop    %ebp
  103b54:	c3                   	ret    
  103b55:	8d 76 00             	lea    0x0(%esi),%esi
  if (container_get_quota(chid) != 100 || container_get_parent(chid) != 0 ||
  103b58:	83 ec 0c             	sub    $0xc,%esp
  103b5b:	56                   	push   %esi
  103b5c:	e8 4f fd ff ff       	call   1038b0 <container_get_parent>
  103b61:	83 c4 10             	add    $0x10,%esp
  103b64:	85 c0                	test   %eax,%eax
  103b66:	75 ce                	jne    103b36 <MContainer_test2+0x46>
      container_get_usage(chid) != 0 || container_get_nchildren(chid) != 0 ||
  103b68:	83 ec 0c             	sub    $0xc,%esp
  103b6b:	56                   	push   %esi
  103b6c:	e8 9f fd ff ff       	call   103910 <container_get_usage>
  if (container_get_quota(chid) != 100 || container_get_parent(chid) != 0 ||
  103b71:	83 c4 10             	add    $0x10,%esp
  103b74:	85 c0                	test   %eax,%eax
  103b76:	75 be                	jne    103b36 <MContainer_test2+0x46>
      container_get_usage(chid) != 0 || container_get_nchildren(chid) != 0 ||
  103b78:	83 ec 0c             	sub    $0xc,%esp
  103b7b:	56                   	push   %esi
  103b7c:	e8 4f fd ff ff       	call   1038d0 <container_get_nchildren>
  103b81:	83 c4 10             	add    $0x10,%esp
  103b84:	85 c0                	test   %eax,%eax
  103b86:	75 ae                	jne    103b36 <MContainer_test2+0x46>
      container_get_usage(0) != old_usage + 100 || container_get_nchildren(0) != old_nchildren + 1) {
  103b88:	83 ec 0c             	sub    $0xc,%esp
  103b8b:	83 c7 64             	add    $0x64,%edi
  103b8e:	6a 00                	push   $0x0
  103b90:	e8 7b fd ff ff       	call   103910 <container_get_usage>
      container_get_usage(chid) != 0 || container_get_nchildren(chid) != 0 ||
  103b95:	83 c4 10             	add    $0x10,%esp
  103b98:	39 f8                	cmp    %edi,%eax
  103b9a:	75 9a                	jne    103b36 <MContainer_test2+0x46>
      container_get_usage(0) != old_usage + 100 || container_get_nchildren(0) != old_nchildren + 1) {
  103b9c:	83 ec 0c             	sub    $0xc,%esp
  103b9f:	83 c5 01             	add    $0x1,%ebp
  103ba2:	6a 00                	push   $0x0
  103ba4:	e8 27 fd ff ff       	call   1038d0 <container_get_nchildren>
  103ba9:	83 c4 10             	add    $0x10,%esp
  103bac:	39 e8                	cmp    %ebp,%eax
  103bae:	75 86                	jne    103b36 <MContainer_test2+0x46>
  container_alloc(chid);
  103bb0:	83 ec 0c             	sub    $0xc,%esp
  103bb3:	56                   	push   %esi
  103bb4:	e8 27 fe ff ff       	call   1039e0 <container_alloc>
  if (container_get_usage(chid) != 1) {
  103bb9:	89 34 24             	mov    %esi,(%esp)
  103bbc:	e8 4f fd ff ff       	call   103910 <container_get_usage>
  103bc1:	83 c4 10             	add    $0x10,%esp
  103bc4:	83 f8 01             	cmp    $0x1,%eax
  103bc7:	0f 85 69 ff ff ff    	jne    103b36 <MContainer_test2+0x46>
  dprintf("test 2 passed.\n");
  103bcd:	8d 83 d5 b3 ff ff    	lea    -0x4c2b(%ebx),%eax
  103bd3:	83 ec 0c             	sub    $0xc,%esp
  103bd6:	50                   	push   %eax
  103bd7:	e8 53 e4 ff ff       	call   10202f <dprintf>
  return 0;
  103bdc:	83 c4 10             	add    $0x10,%esp
  103bdf:	31 c0                	xor    %eax,%eax
  103be1:	e9 67 ff ff ff       	jmp    103b4d <MContainer_test2+0x5d>
  103be6:	8d 76 00             	lea    0x0(%esi),%esi
  103be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103bf0 <MContainer_test_own>:
int MContainer_test_own()
{
  // TODO (optional)
  // dprintf("own test passed.\n");
  return 0;
}
  103bf0:	31 c0                	xor    %eax,%eax
  103bf2:	c3                   	ret    
  103bf3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103c00 <test_MContainer>:

int test_MContainer()
{
  103c00:	53                   	push   %ebx
  103c01:	83 ec 08             	sub    $0x8,%esp
  return MContainer_test1() + MContainer_test2() + MContainer_test_own();
  103c04:	e8 57 fe ff ff       	call   103a60 <MContainer_test1>
  103c09:	89 c3                	mov    %eax,%ebx
  103c0b:	e8 e0 fe ff ff       	call   103af0 <MContainer_test2>
}
  103c10:	83 c4 08             	add    $0x8,%esp
  return MContainer_test1() + MContainer_test2() + MContainer_test_own();
  103c13:	01 d8                	add    %ebx,%eax
}
  103c15:	5b                   	pop    %ebx
  103c16:	c3                   	ret    
  103c17:	66 90                	xchg   %ax,%ax
  103c19:	66 90                	xchg   %ax,%ax
  103c1b:	66 90                	xchg   %ax,%ax
  103c1d:	66 90                	xchg   %ax,%ax
  103c1f:	90                   	nop

00103c20 <set_pdir_base>:

/** TASK 1:
  * * Set the CR3 register with the start address of the page structure for process # [index]
  */
void set_pdir_base(unsigned int index)
{
  103c20:	53                   	push   %ebx
  103c21:	e8 e9 c6 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  103c26:	81 c3 da 73 00 00    	add    $0x73da,%ebx
  103c2c:	83 ec 14             	sub    $0x14,%esp
    // TODO
  set_cr3(PDirPool[index]);
  103c2f:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  103c33:	c1 e0 0c             	shl    $0xc,%eax
  103c36:	81 c0 00 f0 da 00    	add    $0xdaf000,%eax
  103c3c:	50                   	push   %eax
  103c3d:	e8 f1 df ff ff       	call   101c33 <set_cr3>
}
  103c42:	83 c4 18             	add    $0x18,%esp
  103c45:	5b                   	pop    %ebx
  103c46:	c3                   	ret    
  103c47:	89 f6                	mov    %esi,%esi
  103c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103c50 <get_pdir_entry>:
/** TASK 2:
  * * Return the page directory entry # [pde_index] of the process # [proc_index]
  * - This can be used to test whether the page directory entry is mapped
  */
unsigned int get_pdir_entry(unsigned int proc_index, unsigned int pde_index)
{
  103c50:	e8 6d e8 ff ff       	call   1024c2 <__x86.get_pc_thunk.ax>
  103c55:	05 ab 73 00 00       	add    $0x73ab,%eax
    // TODO
    return (unsigned int)PDirPool[proc_index][pde_index];
  103c5a:	c7 c2 00 f0 da 00    	mov    $0xdaf000,%edx
  103c60:	8b 44 24 04          	mov    0x4(%esp),%eax
  103c64:	c1 e0 0a             	shl    $0xa,%eax
  103c67:	03 44 24 08          	add    0x8(%esp),%eax
  103c6b:	8b 04 82             	mov    (%edx,%eax,4),%eax
}
  103c6e:	c3                   	ret    
  103c6f:	90                   	nop

00103c70 <set_pdir_entry>:
  * * Set specified page directory entry with the start address of physical page # [page_index].
  * - You should also set the permissions PTE_P, PTE_W, and PTE_U
  * Hint 1: PT_PERM_PTU is defined for you.
  */
void set_pdir_entry(unsigned int proc_index, unsigned int pde_index, unsigned int page_index)
{
  103c70:	e8 4d e8 ff ff       	call   1024c2 <__x86.get_pc_thunk.ax>
  103c75:	05 8b 73 00 00       	add    $0x738b,%eax
    // TODO
    PDirPool[proc_index][pde_index]=(char *)(page_index<<12|PT_PERM_PTU);
  103c7a:	8b 54 24 0c          	mov    0xc(%esp),%edx
  103c7e:	c7 c1 00 f0 da 00    	mov    $0xdaf000,%ecx
  103c84:	8b 44 24 04          	mov    0x4(%esp),%eax
  103c88:	c1 e2 0c             	shl    $0xc,%edx
  103c8b:	c1 e0 0a             	shl    $0xa,%eax
  103c8e:	03 44 24 08          	add    0x8(%esp),%eax
  103c92:	83 ca 07             	or     $0x7,%edx
  103c95:	89 14 81             	mov    %edx,(%ecx,%eax,4)
}
  103c98:	c3                   	ret    
  103c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00103ca0 <set_pdir_entry_identity>:
  * - You should also set the permissions PTE_P, PTE_W, and PTE_U
  * - This will be used to map the page directory entry to identity page table.
  * Hint 1: Cast the first entry of IDPTbl[pde_index] to char *.
  */
void set_pdir_entry_identity(unsigned int proc_index, unsigned int pde_index)
{
  103ca0:	53                   	push   %ebx
    // TODO
  PDirPool[proc_index][pde_index]=(char *)((unsigned int)IDPTbl[pde_index]|PT_PERM_PTU);
  103ca1:	8b 54 24 08          	mov    0x8(%esp),%edx
{
  103ca5:	8b 44 24 0c          	mov    0xc(%esp),%eax
  103ca9:	e8 61 c6 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  103cae:	81 c3 52 73 00 00    	add    $0x7352,%ebx
  PDirPool[proc_index][pde_index]=(char *)((unsigned int)IDPTbl[pde_index]|PT_PERM_PTU);
  103cb4:	c1 e2 0a             	shl    $0xa,%edx
  103cb7:	01 c2                	add    %eax,%edx
  103cb9:	c1 e0 0c             	shl    $0xc,%eax
  103cbc:	81 c0 00 f0 9a 00    	add    $0x9af000,%eax
  103cc2:	c7 c1 00 f0 da 00    	mov    $0xdaf000,%ecx
  103cc8:	83 c8 07             	or     $0x7,%eax
  103ccb:	89 04 91             	mov    %eax,(%ecx,%edx,4)
}
  103cce:	5b                   	pop    %ebx
  103ccf:	c3                   	ret    

00103cd0 <rmv_pdir_entry>:
  * * Remove specified page directory entry
  * Hint 1: Set the page directory entry to PT_PERM_UP.
  * Hint 2: Don't forget to cast the value to (char *).
  */
void rmv_pdir_entry(unsigned int proc_index, unsigned int pde_index)
{
  103cd0:	e8 ed e7 ff ff       	call   1024c2 <__x86.get_pc_thunk.ax>
  103cd5:	05 2b 73 00 00       	add    $0x732b,%eax
    // TODO
  PDirPool[proc_index][pde_index]=(char *)(PT_PERM_UP);
  103cda:	c7 c2 00 f0 da 00    	mov    $0xdaf000,%edx
  103ce0:	8b 44 24 04          	mov    0x4(%esp),%eax
  103ce4:	c1 e0 0a             	shl    $0xa,%eax
  103ce7:	03 44 24 08          	add    0x8(%esp),%eax
  103ceb:	c7 04 82 00 00 00 00 	movl   $0x0,(%edx,%eax,4)
}
  103cf2:	c3                   	ret    
  103cf3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103d00 <get_ptbl_entry>:
  * Hint 2: Do not forget that the permission info is also stored in the page directory entries.
  *         (You will have to mask out the permission info.)
  * Hint 3: Remember to cast to a pointer before de-referencing an address.
  */
unsigned int get_ptbl_entry(unsigned int proc_index, unsigned int pde_index, unsigned int pte_index)
{
  103d00:	e8 bd e7 ff ff       	call   1024c2 <__x86.get_pc_thunk.ax>
  103d05:	05 fb 72 00 00       	add    $0x72fb,%eax
    // TOD
    return ((unsigned int*)((unsigned int)((unsigned int)(PDirPool[proc_index][pde_index])>>12)<<12))[pte_index];
  103d0a:	c7 c2 00 f0 da 00    	mov    $0xdaf000,%edx
  103d10:	8b 44 24 04          	mov    0x4(%esp),%eax
  103d14:	c1 e0 0a             	shl    $0xa,%eax
  103d17:	03 44 24 08          	add    0x8(%esp),%eax
  103d1b:	8b 04 82             	mov    (%edx,%eax,4),%eax
  103d1e:	8b 54 24 0c          	mov    0xc(%esp),%edx
  103d22:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103d27:	8b 04 90             	mov    (%eax,%edx,4),%eax
}
  103d2a:	c3                   	ret    
  103d2b:	90                   	nop
  103d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00103d30 <set_ptbl_entry>:
  * * Sets specified page table entry with the start address of physical page # [page_index]
  * - You should also set the given permission
  * Hint 1: Same as TASK 6
  */
void set_ptbl_entry(unsigned int proc_index, unsigned int pde_index, unsigned int pte_index, unsigned int page_index, unsigned int perm)
{
  103d30:	e8 8d e7 ff ff       	call   1024c2 <__x86.get_pc_thunk.ax>
  103d35:	05 cb 72 00 00       	add    $0x72cb,%eax
    // TODO
  unsigned int* ptbl_entry=(unsigned int*)((unsigned int)((unsigned int)(PDirPool[proc_index][pde_index])>>12)<<12);
  ptbl_entry[pte_index]=page_index<<12|perm;
  103d3a:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
  unsigned int* ptbl_entry=(unsigned int*)((unsigned int)((unsigned int)(PDirPool[proc_index][pde_index])>>12)<<12);
  103d3e:	c7 c2 00 f0 da 00    	mov    $0xdaf000,%edx
  103d44:	8b 44 24 04          	mov    0x4(%esp),%eax
  103d48:	c1 e0 0a             	shl    $0xa,%eax
  103d4b:	03 44 24 08          	add    0x8(%esp),%eax
  103d4f:	8b 14 82             	mov    (%edx,%eax,4),%edx
  ptbl_entry[pte_index]=page_index<<12|perm;
  103d52:	8b 44 24 10          	mov    0x10(%esp),%eax
  103d56:	c1 e0 0c             	shl    $0xc,%eax
  103d59:	0b 44 24 14          	or     0x14(%esp),%eax
  unsigned int* ptbl_entry=(unsigned int*)((unsigned int)((unsigned int)(PDirPool[proc_index][pde_index])>>12)<<12);
  103d5d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  ptbl_entry[pte_index]=page_index<<12|perm;
  103d63:	89 04 8a             	mov    %eax,(%edx,%ecx,4)

}
  103d66:	c3                   	ret    
  103d67:	89 f6                	mov    %esi,%esi
  103d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103d70 <set_ptbl_entry_identity>:
  * | 4       |    A[1][1]   |
  * | 5       |    A[1][2]   |
  * |---------|--------------|
  */
void set_ptbl_entry_identity(unsigned int pde_index, unsigned int pte_index, unsigned int perm)
{
  103d70:	e8 4d e7 ff ff       	call   1024c2 <__x86.get_pc_thunk.ax>
  103d75:	05 8b 72 00 00       	add    $0x728b,%eax
    // TODO
   unsigned int i=pde_index;
   unsigned int j=pte_index;
   unsigned int num_columns=1024;
   unsigned int size_of_each_entry=4096;
  IDPTbl[pde_index][pte_index]=(i * num_columns + j) * size_of_each_entry|perm;
  103d7a:	c7 c1 00 f0 9a 00    	mov    $0x9af000,%ecx
  103d80:	8b 44 24 04          	mov    0x4(%esp),%eax
  103d84:	c1 e0 0a             	shl    $0xa,%eax
  103d87:	03 44 24 08          	add    0x8(%esp),%eax
  103d8b:	89 c2                	mov    %eax,%edx
  103d8d:	c1 e2 0c             	shl    $0xc,%edx
  103d90:	0b 54 24 0c          	or     0xc(%esp),%edx
  103d94:	89 14 81             	mov    %edx,(%ecx,%eax,4)
}
  103d97:	c3                   	ret    
  103d98:	90                   	nop
  103d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00103da0 <rmv_ptbl_entry>:
  * * Set the specified page table entry to 0
  * Hint 1: Remember that page directory entries also have permissions stored. Mask them out.
  * Hint 2: Remember to cast to a pointer before de-referencing an address.
  */
void rmv_ptbl_entry(unsigned int proc_index, unsigned int pde_index, unsigned int pte_index)
{
  103da0:	e8 1d e7 ff ff       	call   1024c2 <__x86.get_pc_thunk.ax>
  103da5:	05 5b 72 00 00       	add    $0x725b,%eax
    // TODO
  unsigned int* ptbl_entry=(unsigned int*)((unsigned int)((unsigned int)(PDirPool[proc_index][pde_index])>>12)<<12);
  103daa:	c7 c2 00 f0 da 00    	mov    $0xdaf000,%edx
  103db0:	8b 44 24 04          	mov    0x4(%esp),%eax
  103db4:	c1 e0 0a             	shl    $0xa,%eax
  103db7:	03 44 24 08          	add    0x8(%esp),%eax
  103dbb:	8b 04 82             	mov    (%edx,%eax,4),%eax
  ptbl_entry[pte_index]=0;
  103dbe:	8b 54 24 0c          	mov    0xc(%esp),%edx
  unsigned int* ptbl_entry=(unsigned int*)((unsigned int)((unsigned int)(PDirPool[proc_index][pde_index])>>12)<<12);
  103dc2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  ptbl_entry[pte_index]=0;
  103dc7:	c7 04 90 00 00 00 00 	movl   $0x0,(%eax,%edx,4)
}
  103dce:	c3                   	ret    
  103dcf:	90                   	nop

00103dd0 <MPTIntro_test1>:

extern char * PDirPool[NUM_IDS][1024];
extern unsigned int IDPTbl[1024][1024];

int MPTIntro_test1()
{
  103dd0:	53                   	push   %ebx
  103dd1:	e8 39 c5 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  103dd6:	81 c3 2a 72 00 00    	add    $0x722a,%ebx
  103ddc:	83 ec 14             	sub    $0x14,%esp
  set_pdir_base(0);
  103ddf:	6a 00                	push   $0x0
  103de1:	e8 3a fe ff ff       	call   103c20 <set_pdir_base>
  if ((unsigned int)PDirPool[0] != rcr3()) {
  103de6:	e8 55 ea ff ff       	call   102840 <rcr3>
  103deb:	83 c4 10             	add    $0x10,%esp
  103dee:	81 f8 00 f0 da 00    	cmp    $0xdaf000,%eax
  103df4:	74 22                	je     103e18 <MPTIntro_test1+0x48>
    dprintf("test 1 failed.\n");
  103df6:	8d 83 5a b3 ff ff    	lea    -0x4ca6(%ebx),%eax
  103dfc:	83 ec 0c             	sub    $0xc,%esp
  103dff:	50                   	push   %eax
  103e00:	e8 2a e2 ff ff       	call   10202f <dprintf>
    return 1;
  103e05:	83 c4 10             	add    $0x10,%esp
  103e08:	b8 01 00 00 00       	mov    $0x1,%eax
    dprintf("test 1 failed.\n");
    return 1;
  }
  dprintf("test 1 passed.\n");
  return 0;
}
  103e0d:	83 c4 08             	add    $0x8,%esp
  103e10:	5b                   	pop    %ebx
  103e11:	c3                   	ret    
  103e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  set_pdir_entry_identity(1, 1);
  103e18:	83 ec 08             	sub    $0x8,%esp
  103e1b:	6a 01                	push   $0x1
  103e1d:	6a 01                	push   $0x1
  103e1f:	e8 7c fe ff ff       	call   103ca0 <set_pdir_entry_identity>
  set_pdir_entry(1, 2, 100);
  103e24:	83 c4 0c             	add    $0xc,%esp
  103e27:	6a 64                	push   $0x64
  103e29:	6a 02                	push   $0x2
  103e2b:	6a 01                	push   $0x1
  103e2d:	e8 3e fe ff ff       	call   103c70 <set_pdir_entry>
  if (get_pdir_entry(1, 1) != (unsigned int)IDPTbl[1] +   7) {
  103e32:	58                   	pop    %eax
  103e33:	5a                   	pop    %edx
  103e34:	6a 01                	push   $0x1
  103e36:	6a 01                	push   $0x1
  103e38:	e8 13 fe ff ff       	call   103c50 <get_pdir_entry>
  103e3d:	c7 c2 00 f0 9a 00    	mov    $0x9af000,%edx
  103e43:	83 c4 10             	add    $0x10,%esp
  103e46:	81 c2 07 10 00 00    	add    $0x1007,%edx
  103e4c:	39 d0                	cmp    %edx,%eax
  103e4e:	75 a6                	jne    103df6 <MPTIntro_test1+0x26>
  if (get_pdir_entry(1, 2) != 409607) {
  103e50:	83 ec 08             	sub    $0x8,%esp
  103e53:	6a 02                	push   $0x2
  103e55:	6a 01                	push   $0x1
  103e57:	e8 f4 fd ff ff       	call   103c50 <get_pdir_entry>
  103e5c:	83 c4 10             	add    $0x10,%esp
  103e5f:	3d 07 40 06 00       	cmp    $0x64007,%eax
  103e64:	75 90                	jne    103df6 <MPTIntro_test1+0x26>
  rmv_pdir_entry(1, 1);
  103e66:	83 ec 08             	sub    $0x8,%esp
  103e69:	6a 01                	push   $0x1
  103e6b:	6a 01                	push   $0x1
  103e6d:	e8 5e fe ff ff       	call   103cd0 <rmv_pdir_entry>
  rmv_pdir_entry(1, 2);
  103e72:	58                   	pop    %eax
  103e73:	5a                   	pop    %edx
  103e74:	6a 02                	push   $0x2
  103e76:	6a 01                	push   $0x1
  103e78:	e8 53 fe ff ff       	call   103cd0 <rmv_pdir_entry>
  if (get_pdir_entry(1, 1) != 0 || get_pdir_entry(1, 2) != 0) {
  103e7d:	59                   	pop    %ecx
  103e7e:	58                   	pop    %eax
  103e7f:	6a 01                	push   $0x1
  103e81:	6a 01                	push   $0x1
  103e83:	e8 c8 fd ff ff       	call   103c50 <get_pdir_entry>
  103e88:	83 c4 10             	add    $0x10,%esp
  103e8b:	85 c0                	test   %eax,%eax
  103e8d:	0f 85 63 ff ff ff    	jne    103df6 <MPTIntro_test1+0x26>
  103e93:	83 ec 08             	sub    $0x8,%esp
  103e96:	6a 02                	push   $0x2
  103e98:	6a 01                	push   $0x1
  103e9a:	e8 b1 fd ff ff       	call   103c50 <get_pdir_entry>
  103e9f:	83 c4 10             	add    $0x10,%esp
  103ea2:	85 c0                	test   %eax,%eax
  103ea4:	0f 85 4c ff ff ff    	jne    103df6 <MPTIntro_test1+0x26>
  dprintf("test 1 passed.\n");
  103eaa:	8d 83 6a b3 ff ff    	lea    -0x4c96(%ebx),%eax
  103eb0:	83 ec 0c             	sub    $0xc,%esp
  103eb3:	50                   	push   %eax
  103eb4:	e8 76 e1 ff ff       	call   10202f <dprintf>
  103eb9:	83 c4 10             	add    $0x10,%esp
  return 0;
  103ebc:	31 c0                	xor    %eax,%eax
  103ebe:	e9 4a ff ff ff       	jmp    103e0d <MPTIntro_test1+0x3d>
  103ec3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103ed0 <MPTIntro_test2>:

int MPTIntro_test2()
{
  103ed0:	53                   	push   %ebx
  103ed1:	e8 39 c4 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  103ed6:	81 c3 2a 71 00 00    	add    $0x712a,%ebx
  103edc:	83 ec 0c             	sub    $0xc,%esp
  set_pdir_entry(1, 1, 10000);
  103edf:	68 10 27 00 00       	push   $0x2710
  103ee4:	6a 01                	push   $0x1
  103ee6:	6a 01                	push   $0x1
  103ee8:	e8 83 fd ff ff       	call   103c70 <set_pdir_entry>
  set_ptbl_entry(1, 1, 1, 10000, 259);
  103eed:	c7 04 24 03 01 00 00 	movl   $0x103,(%esp)
  103ef4:	68 10 27 00 00       	push   $0x2710
  103ef9:	6a 01                	push   $0x1
  103efb:	6a 01                	push   $0x1
  103efd:	6a 01                	push   $0x1
  103eff:	e8 2c fe ff ff       	call   103d30 <set_ptbl_entry>
  if (get_ptbl_entry(1, 1, 1) != 40960259) {
  103f04:	83 c4 1c             	add    $0x1c,%esp
  103f07:	6a 01                	push   $0x1
  103f09:	6a 01                	push   $0x1
  103f0b:	6a 01                	push   $0x1
  103f0d:	e8 ee fd ff ff       	call   103d00 <get_ptbl_entry>
  103f12:	83 c4 10             	add    $0x10,%esp
  103f15:	3d 03 01 71 02       	cmp    $0x2710103,%eax
  103f1a:	74 24                	je     103f40 <MPTIntro_test2+0x70>
    dprintf("test 2 failed.\n");
  103f1c:	8d 83 c5 b3 ff ff    	lea    -0x4c3b(%ebx),%eax
  103f22:	83 ec 0c             	sub    $0xc,%esp
  103f25:	50                   	push   %eax
  103f26:	e8 04 e1 ff ff       	call   10202f <dprintf>
    return 1;
  103f2b:	83 c4 10             	add    $0x10,%esp
  103f2e:	b8 01 00 00 00       	mov    $0x1,%eax
    return 1;
  }
  rmv_pdir_entry(1, 1);
  dprintf("test 2 passed.\n");
  return 0;
}
  103f33:	83 c4 08             	add    $0x8,%esp
  103f36:	5b                   	pop    %ebx
  103f37:	c3                   	ret    
  103f38:	90                   	nop
  103f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  rmv_ptbl_entry(1, 1, 1);
  103f40:	83 ec 04             	sub    $0x4,%esp
  103f43:	6a 01                	push   $0x1
  103f45:	6a 01                	push   $0x1
  103f47:	6a 01                	push   $0x1
  103f49:	e8 52 fe ff ff       	call   103da0 <rmv_ptbl_entry>
  if (get_ptbl_entry(1, 1, 1) != 0) {
  103f4e:	83 c4 0c             	add    $0xc,%esp
  103f51:	6a 01                	push   $0x1
  103f53:	6a 01                	push   $0x1
  103f55:	6a 01                	push   $0x1
  103f57:	e8 a4 fd ff ff       	call   103d00 <get_ptbl_entry>
  103f5c:	83 c4 10             	add    $0x10,%esp
  103f5f:	85 c0                	test   %eax,%eax
  103f61:	75 b9                	jne    103f1c <MPTIntro_test2+0x4c>
  rmv_pdir_entry(1, 1);
  103f63:	83 ec 08             	sub    $0x8,%esp
  103f66:	6a 01                	push   $0x1
  103f68:	6a 01                	push   $0x1
  103f6a:	e8 61 fd ff ff       	call   103cd0 <rmv_pdir_entry>
  dprintf("test 2 passed.\n");
  103f6f:	8d 83 d5 b3 ff ff    	lea    -0x4c2b(%ebx),%eax
  103f75:	89 04 24             	mov    %eax,(%esp)
  103f78:	e8 b2 e0 ff ff       	call   10202f <dprintf>
  103f7d:	83 c4 10             	add    $0x10,%esp
  103f80:	31 c0                	xor    %eax,%eax
}
  103f82:	83 c4 08             	add    $0x8,%esp
  103f85:	5b                   	pop    %ebx
  103f86:	c3                   	ret    
  103f87:	89 f6                	mov    %esi,%esi
  103f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103f90 <MPTIntro_test_own>:
int MPTIntro_test_own()
{
  // TODO (optional)
  // dprintf("own test passed.\n");
  return 0;
}
  103f90:	31 c0                	xor    %eax,%eax
  103f92:	c3                   	ret    
  103f93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103fa0 <test_MPTIntro>:

int test_MPTIntro()
{
  103fa0:	53                   	push   %ebx
  103fa1:	83 ec 08             	sub    $0x8,%esp
  return MPTIntro_test1() + MPTIntro_test2() + MPTIntro_test_own();
  103fa4:	e8 27 fe ff ff       	call   103dd0 <MPTIntro_test1>
  103fa9:	89 c3                	mov    %eax,%ebx
  103fab:	e8 20 ff ff ff       	call   103ed0 <MPTIntro_test2>
}
  103fb0:	83 c4 08             	add    $0x8,%esp
  return MPTIntro_test1() + MPTIntro_test2() + MPTIntro_test_own();
  103fb3:	01 d8                	add    %ebx,%eax
}
  103fb5:	5b                   	pop    %ebx
  103fb6:	c3                   	ret    
  103fb7:	66 90                	xchg   %ax,%ax
  103fb9:	66 90                	xchg   %ax,%ax
  103fbb:	66 90                	xchg   %ax,%ax
  103fbd:	66 90                	xchg   %ax,%ax
  103fbf:	90                   	nop

00103fc0 <get_pdir_entry_by_va>:
  *         Use the masks defined above. (Do think of what the values are.)
  * Hint 2: Use the appropriate functions in MATIntro layer to 
  *         read the pdir_entry
  */
unsigned int get_pdir_entry_by_va(unsigned int proc_index, unsigned int vaddr)
{
  103fc0:	53                   	push   %ebx
  103fc1:	e8 49 c3 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  103fc6:	81 c3 3a 70 00 00    	add    $0x703a,%ebx
  103fcc:	83 ec 10             	sub    $0x10,%esp
    // TODO
    
  return get_pdir_entry(proc_index,vaddr>>22);
  103fcf:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  103fd3:	c1 e8 16             	shr    $0x16,%eax
  103fd6:	50                   	push   %eax
  103fd7:	ff 74 24 1c          	pushl  0x1c(%esp)
  103fdb:	e8 70 fc ff ff       	call   103c50 <get_pdir_entry>
}
  103fe0:	83 c4 18             	add    $0x18,%esp
  103fe3:	5b                   	pop    %ebx
  103fe4:	c3                   	ret    
  103fe5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  103fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103ff0 <get_ptbl_entry_by_va>:
  * - Return 0 if the mapping does not exist in page directory entry (i.e. pde = 0).
  *
  * Hint 1: Same as TASK 1.
  */
unsigned int get_ptbl_entry_by_va(unsigned int proc_index, unsigned int vaddr)
{
  103ff0:	55                   	push   %ebp
  103ff1:	57                   	push   %edi
  103ff2:	56                   	push   %esi
  103ff3:	53                   	push   %ebx
  103ff4:	e8 16 c3 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  103ff9:	81 c3 07 70 00 00    	add    $0x7007,%ebx
  103fff:	83 ec 14             	sub    $0x14,%esp
  104002:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  104006:	8b 7c 24 28          	mov    0x28(%esp),%edi
  return get_pdir_entry(proc_index,vaddr>>22);
  10400a:	89 f5                	mov    %esi,%ebp
  10400c:	c1 ed 16             	shr    $0x16,%ebp
  10400f:	55                   	push   %ebp
  104010:	57                   	push   %edi
  104011:	e8 3a fc ff ff       	call   103c50 <get_pdir_entry>
    // TODO

    return  get_pdir_entry_by_va(proc_index,vaddr)==0?0:get_ptbl_entry(proc_index,vaddr>>22,(vaddr&0x003ff000)>>12);
  104016:	83 c4 10             	add    $0x10,%esp
  104019:	85 c0                	test   %eax,%eax
  10401b:	74 17                	je     104034 <get_ptbl_entry_by_va+0x44>
  10401d:	c1 ee 0c             	shr    $0xc,%esi
  104020:	83 ec 04             	sub    $0x4,%esp
  104023:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  104029:	56                   	push   %esi
  10402a:	55                   	push   %ebp
  10402b:	57                   	push   %edi
  10402c:	e8 cf fc ff ff       	call   103d00 <get_ptbl_entry>
  104031:	83 c4 10             	add    $0x10,%esp
}         
  104034:	83 c4 0c             	add    $0xc,%esp
  104037:	5b                   	pop    %ebx
  104038:	5e                   	pop    %esi
  104039:	5f                   	pop    %edi
  10403a:	5d                   	pop    %ebp
  10403b:	c3                   	ret    
  10403c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00104040 <rmv_pdir_entry_by_va>:
  * * Remove the page directory entry for the given virtual address
  * Hint 1: Calculate the arguments required by the function(rmv_pdir_entry) in MPTIntro layer
  *         and simply call it.
  */
void rmv_pdir_entry_by_va(unsigned int proc_index, unsigned int vaddr)
{
  104040:	53                   	push   %ebx
  104041:	e8 c9 c2 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  104046:	81 c3 ba 6f 00 00    	add    $0x6fba,%ebx
  10404c:	83 ec 10             	sub    $0x10,%esp
    // TODO
  rmv_pdir_entry(proc_index,vaddr>>22);
  10404f:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  104053:	c1 e8 16             	shr    $0x16,%eax
  104056:	50                   	push   %eax
  104057:	ff 74 24 1c          	pushl  0x1c(%esp)
  10405b:	e8 70 fc ff ff       	call   103cd0 <rmv_pdir_entry>
}
  104060:	83 c4 18             	add    $0x18,%esp
  104063:	5b                   	pop    %ebx
  104064:	c3                   	ret    
  104065:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104070 <rmv_ptbl_entry_by_va>:
/** TASK 4:
  * * Remove the page table entry for the given virtual address
  * Hint 1: Same as TASK 3. Use the correct function.
  */
void rmv_ptbl_entry_by_va(unsigned int proc_index, unsigned int vaddr)
{
  104070:	53                   	push   %ebx
  104071:	e8 99 c2 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  104076:	81 c3 8a 6f 00 00    	add    $0x6f8a,%ebx
  10407c:	83 ec 0c             	sub    $0xc,%esp
  10407f:	8b 44 24 18          	mov    0x18(%esp),%eax
    // TODO
  rmv_ptbl_entry(proc_index,vaddr>>22,(vaddr&0x003ff000)>>12);
  104083:	89 c2                	mov    %eax,%edx
  104085:	c1 e8 16             	shr    $0x16,%eax
  104088:	c1 ea 0c             	shr    $0xc,%edx
  10408b:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  104091:	52                   	push   %edx
  104092:	50                   	push   %eax
  104093:	ff 74 24 1c          	pushl  0x1c(%esp)
  104097:	e8 04 fd ff ff       	call   103da0 <rmv_ptbl_entry>
}
  10409c:	83 c4 18             	add    $0x18,%esp
  10409f:	5b                   	pop    %ebx
  1040a0:	c3                   	ret    
  1040a1:	eb 0d                	jmp    1040b0 <set_pdir_entry_by_va>
  1040a3:	90                   	nop
  1040a4:	90                   	nop
  1040a5:	90                   	nop
  1040a6:	90                   	nop
  1040a7:	90                   	nop
  1040a8:	90                   	nop
  1040a9:	90                   	nop
  1040aa:	90                   	nop
  1040ab:	90                   	nop
  1040ac:	90                   	nop
  1040ad:	90                   	nop
  1040ae:	90                   	nop
  1040af:	90                   	nop

001040b0 <set_pdir_entry_by_va>:
/** TASK 5:
  * * Register the mapping from the virtual address [vaddr] to physical page # [page_index] in the page directory.
  * Hint: Same as TASK 3. Use the correct function.
  */
void set_pdir_entry_by_va(unsigned int proc_index, unsigned int vaddr, unsigned int page_index)
{
  1040b0:	53                   	push   %ebx
  1040b1:	e8 59 c2 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  1040b6:	81 c3 4a 6f 00 00    	add    $0x6f4a,%ebx
  1040bc:	83 ec 0c             	sub    $0xc,%esp
    // TODO
  set_pdir_entry(proc_index,vaddr>>22,page_index);
  1040bf:	ff 74 24 1c          	pushl  0x1c(%esp)
  1040c3:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  1040c7:	c1 e8 16             	shr    $0x16,%eax
  1040ca:	50                   	push   %eax
  1040cb:	ff 74 24 1c          	pushl  0x1c(%esp)
  1040cf:	e8 9c fb ff ff       	call   103c70 <set_pdir_entry>
}   
  1040d4:	83 c4 18             	add    $0x18,%esp
  1040d7:	5b                   	pop    %ebx
  1040d8:	c3                   	ret    
  1040d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001040e0 <set_ptbl_entry_by_va>:
  * * Register the mapping from the virtual address [vaddr] to the physical page # [page_index] with permission [perm]
  * - You do not need to worry about the page directory entry. just map the page table entry.
  * Hint: Same as TASK 3. Use the correct function.
  */
void set_ptbl_entry_by_va(unsigned int proc_index, unsigned int vaddr, unsigned int page_index, unsigned int perm)
{
  1040e0:	53                   	push   %ebx
  1040e1:	e8 29 c2 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  1040e6:	81 c3 1a 6f 00 00    	add    $0x6f1a,%ebx
  1040ec:	83 ec 14             	sub    $0x14,%esp
  1040ef:	8b 44 24 20          	mov    0x20(%esp),%eax
    // TODO
  set_ptbl_entry(proc_index,vaddr>>22,(vaddr&0x003ff000)>>12,page_index,perm);
  1040f3:	ff 74 24 28          	pushl  0x28(%esp)
  1040f7:	ff 74 24 28          	pushl  0x28(%esp)
  1040fb:	89 c2                	mov    %eax,%edx
  1040fd:	c1 e8 16             	shr    $0x16,%eax
  104100:	c1 ea 0c             	shr    $0xc,%edx
  104103:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  104109:	52                   	push   %edx
  10410a:	50                   	push   %eax
  10410b:	ff 74 24 2c          	pushl  0x2c(%esp)
  10410f:	e8 1c fc ff ff       	call   103d30 <set_ptbl_entry>
}
  104114:	83 c4 28             	add    $0x28,%esp
  104117:	5b                   	pop    %ebx
  104118:	c3                   	ret    
  104119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104120 <idptbl_init>:
  * Hint 2: You have already created the functions that deal with IDPTbl. 
  *         Calculate the appropriate permission values as mentioned above 
  *         and call set_ptbl_entry_identity from MATIntro layer.
  */
void idptbl_init(void)
{
  104120:	55                   	push   %ebp
  104121:	57                   	push   %edi
    // TODO
  //container_init();
  //void set_ptbl_entry_identity(unsigned int pde_index, unsigned int pte_index, unsigned int perm)
  for (int i = 0; i < 1024; ++i)
  {
    for (int j = 0; j < 1024; ++j)
  104122:	bf 00 ff ff ff       	mov    $0xffffff00,%edi
{
  104127:	56                   	push   %esi
  104128:	53                   	push   %ebx
  104129:	e8 e1 c1 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  10412e:	81 c3 d2 6e 00 00    	add    $0x6ed2,%ebx
  104134:	83 ec 0c             	sub    $0xc,%esp
  104137:	89 f6                	mov    %esi,%esi
  104139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  104140:	8d af 00 01 00 00    	lea    0x100(%edi),%ebp
    for (int j = 0; j < 1024; ++j)
  104146:	31 f6                	xor    %esi,%esi
  104148:	90                   	nop
  104149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    {
      if(i<0x40000000/4096/1024||i>=0Xf0000000/4096/1024){
  104150:	81 ff bf 02 00 00    	cmp    $0x2bf,%edi
  104156:	77 2d                	ja     104185 <idptbl_init+0x65>
          set_ptbl_entry_identity(i,j,PTE_P|PTE_W|PTE_G);
      }else{
          set_ptbl_entry_identity(i,j,PTE_P|PTE_W);
  104158:	83 ec 04             	sub    $0x4,%esp
  10415b:	6a 03                	push   $0x3
  10415d:	56                   	push   %esi
  10415e:	55                   	push   %ebp
  10415f:	e8 0c fc ff ff       	call   103d70 <set_ptbl_entry_identity>
  104164:	83 c4 10             	add    $0x10,%esp
    for (int j = 0; j < 1024; ++j)
  104167:	83 c6 01             	add    $0x1,%esi
  10416a:	81 fe 00 04 00 00    	cmp    $0x400,%esi
  104170:	75 de                	jne    104150 <idptbl_init+0x30>
  104172:	83 c7 01             	add    $0x1,%edi
  for (int i = 0; i < 1024; ++i)
  104175:	81 ff 00 03 00 00    	cmp    $0x300,%edi
  10417b:	75 c3                	jne    104140 <idptbl_init+0x20>
      }
    }
  }
}
  10417d:	83 c4 0c             	add    $0xc,%esp
  104180:	5b                   	pop    %ebx
  104181:	5e                   	pop    %esi
  104182:	5f                   	pop    %edi
  104183:	5d                   	pop    %ebp
  104184:	c3                   	ret    
          set_ptbl_entry_identity(i,j,PTE_P|PTE_W|PTE_G);
  104185:	50                   	push   %eax
  104186:	68 03 01 00 00       	push   $0x103
  10418b:	56                   	push   %esi
  10418c:	55                   	push   %ebp
  10418d:	e8 de fb ff ff       	call   103d70 <set_ptbl_entry_identity>
  104192:	83 c4 10             	add    $0x10,%esp
  104195:	eb d0                	jmp    104167 <idptbl_init+0x47>
  104197:	66 90                	xchg   %ax,%ax
  104199:	66 90                	xchg   %ax,%ax
  10419b:	66 90                	xchg   %ax,%ax
  10419d:	66 90                	xchg   %ax,%ax
  10419f:	90                   	nop

001041a0 <MPTOp_test1>:
#include <lib/debug.h>
#include "export.h"

int MPTOp_test1()
{
  1041a0:	53                   	push   %ebx
  1041a1:	e8 69 c1 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  1041a6:	81 c3 5a 6e 00 00    	add    $0x6e5a,%ebx
  1041ac:	83 ec 10             	sub    $0x10,%esp
  unsigned int vaddr = 4096*1024*300;
  if (get_ptbl_entry_by_va(10, vaddr) != 0) {
  1041af:	68 00 00 00 4b       	push   $0x4b000000
  1041b4:	6a 0a                	push   $0xa
  1041b6:	e8 35 fe ff ff       	call   103ff0 <get_ptbl_entry_by_va>
  1041bb:	83 c4 10             	add    $0x10,%esp
  1041be:	85 c0                	test   %eax,%eax
  1041c0:	0f 85 ca 00 00 00    	jne    104290 <MPTOp_test1+0xf0>
    dprintf("test 1 failed.\n");
    return 1;
  }
  if (get_pdir_entry_by_va(10, vaddr) != 0) {
  1041c6:	83 ec 08             	sub    $0x8,%esp
  1041c9:	68 00 00 00 4b       	push   $0x4b000000
  1041ce:	6a 0a                	push   $0xa
  1041d0:	e8 eb fd ff ff       	call   103fc0 <get_pdir_entry_by_va>
  1041d5:	83 c4 10             	add    $0x10,%esp
  1041d8:	85 c0                	test   %eax,%eax
  1041da:	0f 85 b0 00 00 00    	jne    104290 <MPTOp_test1+0xf0>
    dprintf("test 1 failed.\n");
    return 1;
  }
  set_pdir_entry_by_va(10, vaddr, 100);
  1041e0:	83 ec 04             	sub    $0x4,%esp
  1041e3:	6a 64                	push   $0x64
  1041e5:	68 00 00 00 4b       	push   $0x4b000000
  1041ea:	6a 0a                	push   $0xa
  1041ec:	e8 bf fe ff ff       	call   1040b0 <set_pdir_entry_by_va>
  set_ptbl_entry_by_va(10, vaddr, 100, 259);
  1041f1:	68 03 01 00 00       	push   $0x103
  1041f6:	6a 64                	push   $0x64
  1041f8:	68 00 00 00 4b       	push   $0x4b000000
  1041fd:	6a 0a                	push   $0xa
  1041ff:	e8 dc fe ff ff       	call   1040e0 <set_ptbl_entry_by_va>
  if (get_ptbl_entry_by_va(10, vaddr) == 0) {
  104204:	83 c4 18             	add    $0x18,%esp
  104207:	68 00 00 00 4b       	push   $0x4b000000
  10420c:	6a 0a                	push   $0xa
  10420e:	e8 dd fd ff ff       	call   103ff0 <get_ptbl_entry_by_va>
  104213:	83 c4 10             	add    $0x10,%esp
  104216:	85 c0                	test   %eax,%eax
  104218:	74 76                	je     104290 <MPTOp_test1+0xf0>
    dprintf("test 1 failed.\n");
    return 1;
  }
  if (get_pdir_entry_by_va(10, vaddr) == 0) {
  10421a:	83 ec 08             	sub    $0x8,%esp
  10421d:	68 00 00 00 4b       	push   $0x4b000000
  104222:	6a 0a                	push   $0xa
  104224:	e8 97 fd ff ff       	call   103fc0 <get_pdir_entry_by_va>
  104229:	83 c4 10             	add    $0x10,%esp
  10422c:	85 c0                	test   %eax,%eax
  10422e:	74 60                	je     104290 <MPTOp_test1+0xf0>
    dprintf("test 1 failed.\n");
    return 1;
  }
  rmv_ptbl_entry_by_va(10, vaddr);
  104230:	83 ec 08             	sub    $0x8,%esp
  104233:	68 00 00 00 4b       	push   $0x4b000000
  104238:	6a 0a                	push   $0xa
  10423a:	e8 31 fe ff ff       	call   104070 <rmv_ptbl_entry_by_va>
  rmv_pdir_entry_by_va(10, vaddr);
  10423f:	58                   	pop    %eax
  104240:	5a                   	pop    %edx
  104241:	68 00 00 00 4b       	push   $0x4b000000
  104246:	6a 0a                	push   $0xa
  104248:	e8 f3 fd ff ff       	call   104040 <rmv_pdir_entry_by_va>
  if (get_ptbl_entry_by_va(10, vaddr) != 0) {
  10424d:	59                   	pop    %ecx
  10424e:	58                   	pop    %eax
  10424f:	68 00 00 00 4b       	push   $0x4b000000
  104254:	6a 0a                	push   $0xa
  104256:	e8 95 fd ff ff       	call   103ff0 <get_ptbl_entry_by_va>
  10425b:	83 c4 10             	add    $0x10,%esp
  10425e:	85 c0                	test   %eax,%eax
  104260:	75 2e                	jne    104290 <MPTOp_test1+0xf0>
    dprintf("test 1 failed.\n");
    return 1;
  }
  if (get_pdir_entry_by_va(10, vaddr) != 0) {
  104262:	83 ec 08             	sub    $0x8,%esp
  104265:	68 00 00 00 4b       	push   $0x4b000000
  10426a:	6a 0a                	push   $0xa
  10426c:	e8 4f fd ff ff       	call   103fc0 <get_pdir_entry_by_va>
  104271:	83 c4 10             	add    $0x10,%esp
  104274:	85 c0                	test   %eax,%eax
  104276:	75 18                	jne    104290 <MPTOp_test1+0xf0>
    dprintf("test 1 failed.\n");
    return 1;
  }
  dprintf("test 1 passed.\n");
  104278:	8d 83 6a b3 ff ff    	lea    -0x4c96(%ebx),%eax
  10427e:	83 ec 0c             	sub    $0xc,%esp
  104281:	50                   	push   %eax
  104282:	e8 a8 dd ff ff       	call   10202f <dprintf>
  104287:	83 c4 10             	add    $0x10,%esp
  return 0;
  10428a:	31 c0                	xor    %eax,%eax
  10428c:	eb 19                	jmp    1042a7 <MPTOp_test1+0x107>
  10428e:	66 90                	xchg   %ax,%ax
    dprintf("test 1 failed.\n");
  104290:	8d 83 5a b3 ff ff    	lea    -0x4ca6(%ebx),%eax
  104296:	83 ec 0c             	sub    $0xc,%esp
  104299:	50                   	push   %eax
  10429a:	e8 90 dd ff ff       	call   10202f <dprintf>
    return 1;
  10429f:	83 c4 10             	add    $0x10,%esp
  1042a2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  1042a7:	83 c4 08             	add    $0x8,%esp
  1042aa:	5b                   	pop    %ebx
  1042ab:	c3                   	ret    
  1042ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001042b0 <MPTOp_test_own>:
int MPTOp_test_own()
{
  // TODO (optional)
  // dprintf("own test passed.\n");
  return 0;
}
  1042b0:	31 c0                	xor    %eax,%eax
  1042b2:	c3                   	ret    
  1042b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1042b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001042c0 <test_MPTOp>:

int test_MPTOp()
{
  return MPTOp_test1() + MPTOp_test_own();
  1042c0:	e9 db fe ff ff       	jmp    1041a0 <MPTOp_test1>
  1042c5:	66 90                	xchg   %ax,%ax
  1042c7:	66 90                	xchg   %ax,%ax
  1042c9:	66 90                	xchg   %ax,%ax
  1042cb:	66 90                	xchg   %ax,%ax
  1042cd:	66 90                	xchg   %ax,%ax
  1042cf:	90                   	nop

001042d0 <alloc_ptbl>:
  * * 3. Clear (set to 0) all the page table entries for this newly mapped page table.
  * * 4. Return the page index of the newly allocated physical page.
  *    In the case when there's no physical page available, it returns 0.
  */
unsigned int alloc_ptbl(unsigned int proc_index, unsigned int vadr)
{
  1042d0:	55                   	push   %ebp
  1042d1:	57                   	push   %edi
  1042d2:	56                   	push   %esi
  1042d3:	53                   	push   %ebx
  1042d4:	e8 36 c0 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  1042d9:	81 c3 27 6d 00 00    	add    $0x6d27,%ebx
  1042df:	83 ec 28             	sub    $0x28,%esp
  1042e2:	8b 7c 24 3c          	mov    0x3c(%esp),%edi
  // TODO
  int page_index=container_alloc(proc_index);
  1042e6:	57                   	push   %edi
  1042e7:	e8 f4 f6 ff ff       	call   1039e0 <container_alloc>
  1042ec:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  if(page_index>0){
  1042f0:	83 c4 10             	add    $0x10,%esp
  1042f3:	85 c0                	test   %eax,%eax
  1042f5:	7e 46                	jle    10433d <alloc_ptbl+0x6d>
    set_pdir_entry_by_va(proc_index,vadr,page_index);
  1042f7:	83 ec 04             	sub    $0x4,%esp
    for (int i = 0; i < 1024; ++i)
  1042fa:	31 ed                	xor    %ebp,%ebp
    set_pdir_entry_by_va(proc_index,vadr,page_index);
  1042fc:	50                   	push   %eax
  1042fd:	ff 74 24 3c          	pushl  0x3c(%esp)
  104301:	57                   	push   %edi
  104302:	e8 a9 fd ff ff       	call   1040b0 <set_pdir_entry_by_va>
    {
      rmv_ptbl_entry(proc_index, vadr>>22, i);
  104307:	8b 74 24 44          	mov    0x44(%esp),%esi
  10430b:	83 c4 10             	add    $0x10,%esp
  10430e:	c1 ee 16             	shr    $0x16,%esi
  104311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104318:	83 ec 04             	sub    $0x4,%esp
  10431b:	55                   	push   %ebp
  10431c:	56                   	push   %esi
    for (int i = 0; i < 1024; ++i)
  10431d:	83 c5 01             	add    $0x1,%ebp
      rmv_ptbl_entry(proc_index, vadr>>22, i);
  104320:	57                   	push   %edi
  104321:	e8 7a fa ff ff       	call   103da0 <rmv_ptbl_entry>
    for (int i = 0; i < 1024; ++i)
  104326:	83 c4 10             	add    $0x10,%esp
  104329:	81 fd 00 04 00 00    	cmp    $0x400,%ebp
  10432f:	75 e7                	jne    104318 <alloc_ptbl+0x48>
    }
    return page_index;
  }else{
    return 0;
  }
}
  104331:	8b 44 24 0c          	mov    0xc(%esp),%eax
  104335:	83 c4 1c             	add    $0x1c,%esp
  104338:	5b                   	pop    %ebx
  104339:	5e                   	pop    %esi
  10433a:	5f                   	pop    %edi
  10433b:	5d                   	pop    %ebp
  10433c:	c3                   	ret    
    return 0;
  10433d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104344:	00 
}
  104345:	8b 44 24 0c          	mov    0xc(%esp),%eax
  104349:	83 c4 1c             	add    $0x1c,%esp
  10434c:	5b                   	pop    %ebx
  10434d:	5e                   	pop    %esi
  10434e:	5f                   	pop    %edi
  10434f:	5d                   	pop    %ebp
  104350:	c3                   	ret    
  104351:	eb 0d                	jmp    104360 <free_ptbl>
  104353:	90                   	nop
  104354:	90                   	nop
  104355:	90                   	nop
  104356:	90                   	nop
  104357:	90                   	nop
  104358:	90                   	nop
  104359:	90                   	nop
  10435a:	90                   	nop
  10435b:	90                   	nop
  10435c:	90                   	nop
  10435d:	90                   	nop
  10435e:	90                   	nop
  10435f:	90                   	nop

00104360 <free_ptbl>:
  * Hint 1: Find the pde corresponding to vadr (MPTOp layer)
  * Hint 2: Remove the pde (MPTOp layer)
  * Hint 3: Use container free
  */
void free_ptbl(unsigned int proc_index, unsigned int vadr)
{
  104360:	57                   	push   %edi
  104361:	56                   	push   %esi
  104362:	53                   	push   %ebx
  104363:	8b 74 24 10          	mov    0x10(%esp),%esi
  104367:	8b 7c 24 14          	mov    0x14(%esp),%edi
  // TODO
  rmv_pdir_entry_by_va(proc_index,vadr);
  10436b:	83 ec 08             	sub    $0x8,%esp
  10436e:	e8 9c bf ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  104373:	81 c3 8d 6c 00 00    	add    $0x6c8d,%ebx
  104379:	57                   	push   %edi
  10437a:	56                   	push   %esi
  10437b:	e8 c0 fc ff ff       	call   104040 <rmv_pdir_entry_by_va>
  container_free(proc_index,get_pdir_entry_by_va(proc_index,vadr));
  104380:	58                   	pop    %eax
  104381:	5a                   	pop    %edx
  104382:	57                   	push   %edi
  104383:	56                   	push   %esi
  104384:	e8 37 fc ff ff       	call   103fc0 <get_pdir_entry_by_va>
  104389:	59                   	pop    %ecx
  10438a:	5f                   	pop    %edi
  10438b:	50                   	push   %eax
  10438c:	56                   	push   %esi
  10438d:	e8 8e f6 ff ff       	call   103a20 <container_free>
}
  104392:	83 c4 10             	add    $0x10,%esp
  104395:	5b                   	pop    %ebx
  104396:	5e                   	pop    %esi
  104397:	5f                   	pop    %edi
  104398:	c3                   	ret    
  104399:	66 90                	xchg   %ax,%ax
  10439b:	66 90                	xchg   %ax,%ax
  10439d:	66 90                	xchg   %ax,%ax
  10439f:	90                   	nop

001043a0 <MPTComm_test1>:
#include <pmm/MContainer/export.h>
#include <vmm/MPTOp/export.h>
#include "export.h"

int MPTComm_test1()
{
  1043a0:	57                   	push   %edi
  1043a1:	56                   	push   %esi
  1043a2:	be 00 ff ff ff       	mov    $0xffffff00,%esi
  1043a7:	53                   	push   %ebx
  1043a8:	e8 62 bf ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  1043ad:	81 c3 53 6c 00 00    	add    $0x6c53,%ebx
  1043b3:	90                   	nop
  1043b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int i;
  for (i = 0; i < 1024; i ++) {     // kernel portion
    if (i < 256 || i >= 960) {      // proc[10], dir[kern], check if identity map
  1043b8:	81 fe bf 02 00 00    	cmp    $0x2bf,%esi
  1043be:	77 23                	ja     1043e3 <MPTComm_test1+0x43>
  1043c0:	83 c6 01             	add    $0x1,%esi
  for (i = 0; i < 1024; i ++) {     // kernel portion
  1043c3:	81 fe 00 03 00 00    	cmp    $0x300,%esi
  1043c9:	75 ed                	jne    1043b8 <MPTComm_test1+0x18>
        dprintf("test 1 failed.\n");
        return 1;
      }
    }
  }
  dprintf("test 1 passed.\n");
  1043cb:	8d 83 6a b3 ff ff    	lea    -0x4c96(%ebx),%eax
  1043d1:	83 ec 0c             	sub    $0xc,%esp
  1043d4:	50                   	push   %eax
  1043d5:	e8 55 dc ff ff       	call   10202f <dprintf>
  return 0;
  1043da:	83 c4 10             	add    $0x10,%esp
  1043dd:	31 c0                	xor    %eax,%eax
}
  1043df:	5b                   	pop    %ebx
  1043e0:	5e                   	pop    %esi
  1043e1:	5f                   	pop    %edi
  1043e2:	c3                   	ret    
  1043e3:	8d be 00 01 00 00    	lea    0x100(%esi),%edi
      if (get_ptbl_entry_by_va(10, i * 4096 * 1024) != i * 4096 * 1024 + 259) {
  1043e9:	50                   	push   %eax
  1043ea:	50                   	push   %eax
  1043eb:	c1 e7 16             	shl    $0x16,%edi
  1043ee:	57                   	push   %edi
  1043ef:	6a 0a                	push   $0xa
  1043f1:	81 c7 03 01 00 00    	add    $0x103,%edi
  1043f7:	e8 f4 fb ff ff       	call   103ff0 <get_ptbl_entry_by_va>
  1043fc:	83 c4 10             	add    $0x10,%esp
  1043ff:	39 f8                	cmp    %edi,%eax
  104401:	74 bd                	je     1043c0 <MPTComm_test1+0x20>
        dprintf("test 1 failed.\n");
  104403:	8d 83 5a b3 ff ff    	lea    -0x4ca6(%ebx),%eax
  104409:	83 ec 0c             	sub    $0xc,%esp
  10440c:	50                   	push   %eax
  10440d:	e8 1d dc ff ff       	call   10202f <dprintf>
        return 1;
  104412:	83 c4 10             	add    $0x10,%esp
  104415:	b8 01 00 00 00       	mov    $0x1,%eax
  10441a:	eb c3                	jmp    1043df <MPTComm_test1+0x3f>
  10441c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00104420 <MPTComm_test2>:

int MPTComm_test2()
{
  104420:	53                   	push   %ebx
  104421:	e8 e9 be ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  104426:	81 c3 da 6b 00 00    	add    $0x6bda,%ebx
  10442c:	83 ec 10             	sub    $0x10,%esp
  unsigned int vaddr = 300 * 4096 * 1024;
  container_split(0, 100);
  10442f:	6a 64                	push   $0x64
  104431:	6a 00                	push   $0x0
  104433:	e8 28 f5 ff ff       	call   103960 <container_split>
  alloc_ptbl(1, vaddr);
  104438:	59                   	pop    %ecx
  104439:	58                   	pop    %eax
  10443a:	68 00 00 00 4b       	push   $0x4b000000
  10443f:	6a 01                	push   $0x1
  104441:	e8 8a fe ff ff       	call   1042d0 <alloc_ptbl>
  if (get_pdir_entry_by_va(1, vaddr) == 0) {
  104446:	58                   	pop    %eax
  104447:	5a                   	pop    %edx
  104448:	68 00 00 00 4b       	push   $0x4b000000
  10444d:	6a 01                	push   $0x1
  10444f:	e8 6c fb ff ff       	call   103fc0 <get_pdir_entry_by_va>
  104454:	83 c4 10             	add    $0x10,%esp
  104457:	85 c0                	test   %eax,%eax
  104459:	74 55                	je     1044b0 <MPTComm_test2+0x90>
    dprintf("test 2 failed.\n");
    return 1;
  }
  if(get_ptbl_entry_by_va(1, vaddr) != 0) {
  10445b:	83 ec 08             	sub    $0x8,%esp
  10445e:	68 00 00 00 4b       	push   $0x4b000000
  104463:	6a 01                	push   $0x1
  104465:	e8 86 fb ff ff       	call   103ff0 <get_ptbl_entry_by_va>
  10446a:	83 c4 10             	add    $0x10,%esp
  10446d:	85 c0                	test   %eax,%eax
  10446f:	75 3f                	jne    1044b0 <MPTComm_test2+0x90>
    dprintf("test 2 failed.\n");
    return 1;
  }
  free_ptbl(1, vaddr);
  104471:	83 ec 08             	sub    $0x8,%esp
  104474:	68 00 00 00 4b       	push   $0x4b000000
  104479:	6a 01                	push   $0x1
  10447b:	e8 e0 fe ff ff       	call   104360 <free_ptbl>
  if (get_pdir_entry_by_va(1, vaddr) != 0) {
  104480:	58                   	pop    %eax
  104481:	5a                   	pop    %edx
  104482:	68 00 00 00 4b       	push   $0x4b000000
  104487:	6a 01                	push   $0x1
  104489:	e8 32 fb ff ff       	call   103fc0 <get_pdir_entry_by_va>
  10448e:	83 c4 10             	add    $0x10,%esp
  104491:	85 c0                	test   %eax,%eax
  104493:	75 1b                	jne    1044b0 <MPTComm_test2+0x90>
    dprintf("test 2 failed.\n");
    return 1;
  }
  dprintf("test 2 passed.\n");
  104495:	8d 83 d5 b3 ff ff    	lea    -0x4c2b(%ebx),%eax
  10449b:	83 ec 0c             	sub    $0xc,%esp
  10449e:	50                   	push   %eax
  10449f:	e8 8b db ff ff       	call   10202f <dprintf>
  1044a4:	83 c4 10             	add    $0x10,%esp
  return 0;
  1044a7:	31 c0                	xor    %eax,%eax
}
  1044a9:	83 c4 08             	add    $0x8,%esp
  1044ac:	5b                   	pop    %ebx
  1044ad:	c3                   	ret    
  1044ae:	66 90                	xchg   %ax,%ax
    dprintf("test 2 failed.\n");
  1044b0:	8d 83 c5 b3 ff ff    	lea    -0x4c3b(%ebx),%eax
  1044b6:	83 ec 0c             	sub    $0xc,%esp
  1044b9:	50                   	push   %eax
  1044ba:	e8 70 db ff ff       	call   10202f <dprintf>
    return 1;
  1044bf:	83 c4 10             	add    $0x10,%esp
  1044c2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  1044c7:	83 c4 08             	add    $0x8,%esp
  1044ca:	5b                   	pop    %ebx
  1044cb:	c3                   	ret    
  1044cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001044d0 <MPTComm_test_own>:
int MPTComm_test_own()
{
  // TODO (optional)
  // dprintf("own test passed.\n");
  return 0;
}
  1044d0:	31 c0                	xor    %eax,%eax
  1044d2:	c3                   	ret    
  1044d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1044d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001044e0 <test_MPTComm>:

int test_MPTComm()
{
  1044e0:	53                   	push   %ebx
  1044e1:	83 ec 08             	sub    $0x8,%esp
  return MPTComm_test1() + MPTComm_test2() + MPTComm_test_own();
  1044e4:	e8 b7 fe ff ff       	call   1043a0 <MPTComm_test1>
  1044e9:	89 c3                	mov    %eax,%ebx
  1044eb:	e8 30 ff ff ff       	call   104420 <MPTComm_test2>
}
  1044f0:	83 c4 08             	add    $0x8,%esp
  return MPTComm_test1() + MPTComm_test2() + MPTComm_test_own();
  1044f3:	01 d8                	add    %ebx,%eax
}
  1044f5:	5b                   	pop    %ebx
  1044f6:	c3                   	ret    
  1044f7:	66 90                	xchg   %ax,%ax
  1044f9:	66 90                	xchg   %ax,%ax
  1044fb:	66 90                	xchg   %ax,%ax
  1044fd:	66 90                	xchg   %ax,%ax
  1044ff:	90                   	nop

00104500 <pdir_init_kern>:
  * Hint 3: Recall which portions are reserved for the kernel and calculate the pde_index.       
  * Hint 4: Recall which function in MPTIntro layer is used to set identity map. (See import.h) 
  * Hint 5: Remove the page directory entry to unmap it.
  */
void pdir_init_kern(void)
{
  104500:	57                   	push   %edi
  104501:	56                   	push   %esi
    idptbl_init();
    for (int i = 0; i < 1024; ++i)
  104502:	31 f6                	xor    %esi,%esi
{
  104504:	53                   	push   %ebx
  104505:	e8 05 be ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  10450a:	81 c3 f6 6a 00 00    	add    $0x6af6,%ebx
    idptbl_init();
  104510:	e8 0b fc ff ff       	call   104120 <idptbl_init>
  104515:	8d 76 00             	lea    0x0(%esi),%esi
    {
      set_pdir_entry_identity(0, i);
  104518:	83 ec 08             	sub    $0x8,%esp
  10451b:	56                   	push   %esi
  10451c:	6a 00                	push   $0x0
    for (int i = 0; i < 1024; ++i)
  10451e:	83 c6 01             	add    $0x1,%esi
      set_pdir_entry_identity(0, i);
  104521:	e8 7a f7 ff ff       	call   103ca0 <set_pdir_entry_identity>
    for (int i = 0; i < 1024; ++i)
  104526:	83 c4 10             	add    $0x10,%esp
  104529:	81 fe 00 04 00 00    	cmp    $0x400,%esi
  10452f:	75 e7                	jne    104518 <pdir_init_kern+0x18>
    }  
    for (int i = 1; i < 64; ++i)
  104531:	bf 01 00 00 00       	mov    $0x1,%edi
  104536:	8d 76 00             	lea    0x0(%esi),%esi
  104539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    {
      for (int j = 0; j < 1024; ++j)
  104540:	31 f6                	xor    %esi,%esi
  104542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      {
        if(j<0x40000000/4096/1024||j>=0Xf0000000/4096/1024){
  104548:	8d 86 00 ff ff ff    	lea    -0x100(%esi),%eax
  10454e:	3d bf 02 00 00       	cmp    $0x2bf,%eax
  104553:	77 24                	ja     104579 <pdir_init_kern+0x79>
          set_pdir_entry_identity(i,j);
        }else{
          rmv_pdir_entry(i,j);
  104555:	83 ec 08             	sub    $0x8,%esp
  104558:	56                   	push   %esi
  104559:	57                   	push   %edi
  10455a:	e8 71 f7 ff ff       	call   103cd0 <rmv_pdir_entry>
  10455f:	83 c4 10             	add    $0x10,%esp
      for (int j = 0; j < 1024; ++j)
  104562:	83 c6 01             	add    $0x1,%esi
  104565:	81 fe 00 04 00 00    	cmp    $0x400,%esi
  10456b:	75 db                	jne    104548 <pdir_init_kern+0x48>
    for (int i = 1; i < 64; ++i)
  10456d:	83 c7 01             	add    $0x1,%edi
  104570:	83 ff 40             	cmp    $0x40,%edi
  104573:	75 cb                	jne    104540 <pdir_init_kern+0x40>
        }
      }
    }
    //TODO
}
  104575:	5b                   	pop    %ebx
  104576:	5e                   	pop    %esi
  104577:	5f                   	pop    %edi
  104578:	c3                   	ret    
          set_pdir_entry_identity(i,j);
  104579:	50                   	push   %eax
  10457a:	50                   	push   %eax
  10457b:	56                   	push   %esi
  10457c:	57                   	push   %edi
  10457d:	e8 1e f7 ff ff       	call   103ca0 <set_pdir_entry_identity>
  104582:	83 c4 10             	add    $0x10,%esp
  104585:	eb db                	jmp    104562 <pdir_init_kern+0x62>
  104587:	89 f6                	mov    %esi,%esi
  104589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104590 <map_page>:
  *         - If there is an error during allocation, return MagicNumber.
  * Hint 3: If you have a valid pde, set the page table entry to new physical page (page_index) and perm.
  * Hint 4: Return the pde index or MagicNumber.
  */
unsigned int map_page(unsigned int proc_index, unsigned int vadr, unsigned int page_index, unsigned int perm)
{   
  104590:	57                   	push   %edi
  104591:	56                   	push   %esi
  104592:	53                   	push   %ebx
  104593:	e8 77 bd ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  104598:	81 c3 68 6a 00 00    	add    $0x6a68,%ebx
  10459e:	83 ec 18             	sub    $0x18,%esp
  1045a1:	8b 74 24 28          	mov    0x28(%esp),%esi
  1045a5:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
  // TODO
  
  if(get_pdir_entry_by_va(proc_index,vadr)>0){
  1045a9:	57                   	push   %edi
  1045aa:	56                   	push   %esi
  1045ab:	e8 10 fa ff ff       	call   103fc0 <get_pdir_entry_by_va>
  1045b0:	83 c4 10             	add    $0x10,%esp
  1045b3:	85 c0                	test   %eax,%eax
  1045b5:	75 39                	jne    1045f0 <map_page+0x60>
    set_ptbl_entry_by_va(proc_index,vadr,page_index,perm);
    return get_pdir_entry_by_va(proc_index,vadr)>>12;
  }else{
    int index=alloc_ptbl(proc_index,vadr);
  1045b7:	83 ec 08             	sub    $0x8,%esp
  1045ba:	57                   	push   %edi
  1045bb:	56                   	push   %esi
  1045bc:	e8 0f fd ff ff       	call   1042d0 <alloc_ptbl>
  1045c1:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    set_ptbl_entry_by_va(proc_index,vadr,page_index,perm);
  1045c5:	ff 74 24 3c          	pushl  0x3c(%esp)
  1045c9:	ff 74 24 3c          	pushl  0x3c(%esp)
  1045cd:	57                   	push   %edi
  1045ce:	56                   	push   %esi
  1045cf:	e8 0c fb ff ff       	call   1040e0 <set_ptbl_entry_by_va>
    return index==0?MagicNumber:index;
  1045d4:	83 c4 20             	add    $0x20,%esp
  1045d7:	8b 44 24 0c          	mov    0xc(%esp),%eax
  1045db:	ba 01 00 10 00       	mov    $0x100001,%edx
  1045e0:	85 c0                	test   %eax,%eax
  1045e2:	0f 44 c2             	cmove  %edx,%eax
  }
}
  1045e5:	83 c4 10             	add    $0x10,%esp
  1045e8:	5b                   	pop    %ebx
  1045e9:	5e                   	pop    %esi
  1045ea:	5f                   	pop    %edi
  1045eb:	c3                   	ret    
  1045ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    set_ptbl_entry_by_va(proc_index,vadr,page_index,perm);
  1045f0:	ff 74 24 2c          	pushl  0x2c(%esp)
  1045f4:	ff 74 24 2c          	pushl  0x2c(%esp)
  1045f8:	57                   	push   %edi
  1045f9:	56                   	push   %esi
  1045fa:	e8 e1 fa ff ff       	call   1040e0 <set_ptbl_entry_by_va>
    return get_pdir_entry_by_va(proc_index,vadr)>>12;
  1045ff:	58                   	pop    %eax
  104600:	5a                   	pop    %edx
  104601:	57                   	push   %edi
  104602:	56                   	push   %esi
  104603:	e8 b8 f9 ff ff       	call   103fc0 <get_pdir_entry_by_va>
  104608:	83 c4 10             	add    $0x10,%esp
  10460b:	c1 e8 0c             	shr    $0xc,%eax
}
  10460e:	83 c4 10             	add    $0x10,%esp
  104611:	5b                   	pop    %ebx
  104612:	5e                   	pop    %esi
  104613:	5f                   	pop    %edi
  104614:	c3                   	ret    
  104615:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104620 <unmap_page>:
  *         - Nothing should be done if the mapping no longer exists.
  * Hint 2: If pte is valid, remove page table entry for vadr.
  * Hint 3: Return the corresponding page table entry.
  */
unsigned int unmap_page(unsigned int proc_index, unsigned int vadr)
{
  104620:	57                   	push   %edi
  104621:	56                   	push   %esi
  104622:	53                   	push   %ebx
  104623:	8b 74 24 10          	mov    0x10(%esp),%esi
  104627:	8b 7c 24 14          	mov    0x14(%esp),%edi
  // TODO
  if(get_ptbl_entry_by_va(proc_index,vadr)!=0){
  10462b:	83 ec 08             	sub    $0x8,%esp
  10462e:	e8 dc bc ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  104633:	81 c3 cd 69 00 00    	add    $0x69cd,%ebx
  104639:	57                   	push   %edi
  10463a:	56                   	push   %esi
  10463b:	e8 b0 f9 ff ff       	call   103ff0 <get_ptbl_entry_by_va>
  104640:	83 c4 10             	add    $0x10,%esp
  104643:	85 c0                	test   %eax,%eax
  104645:	74 0d                	je     104654 <unmap_page+0x34>
    rmv_ptbl_entry_by_va(proc_index, vadr);
  104647:	83 ec 08             	sub    $0x8,%esp
  10464a:	57                   	push   %edi
  10464b:	56                   	push   %esi
  10464c:	e8 1f fa ff ff       	call   104070 <rmv_ptbl_entry_by_va>
  104651:	83 c4 10             	add    $0x10,%esp
  }
  return get_ptbl_entry_by_va(proc_index,vadr);
  104654:	83 ec 08             	sub    $0x8,%esp
  104657:	57                   	push   %edi
  104658:	56                   	push   %esi
  104659:	e8 92 f9 ff ff       	call   103ff0 <get_ptbl_entry_by_va>
  10465e:	83 c4 10             	add    $0x10,%esp
}   
  104661:	5b                   	pop    %ebx
  104662:	5e                   	pop    %esi
  104663:	5f                   	pop    %edi
  104664:	c3                   	ret    
  104665:	66 90                	xchg   %ax,%ax
  104667:	66 90                	xchg   %ax,%ax
  104669:	66 90                	xchg   %ax,%ax
  10466b:	66 90                	xchg   %ax,%ax
  10466d:	66 90                	xchg   %ax,%ax
  10466f:	90                   	nop

00104670 <MPTKern_test1>:
#include <pmm/MContainer/export.h>
#include <vmm/MPTOp/export.h>
#include "export.h"

int MPTKern_test1()
{
  104670:	53                   	push   %ebx
  104671:	e8 99 bc ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  104676:	81 c3 8a 69 00 00    	add    $0x698a,%ebx
  10467c:	83 ec 10             	sub    $0x10,%esp
  unsigned int vaddr = 4096*1024*300;
  container_split(0, 100);
  10467f:	6a 64                	push   $0x64
  104681:	6a 00                	push   $0x0
  104683:	e8 d8 f2 ff ff       	call   103960 <container_split>
  if (get_ptbl_entry_by_va(1, vaddr) != 0) {
  104688:	58                   	pop    %eax
  104689:	5a                   	pop    %edx
  10468a:	68 00 00 00 4b       	push   $0x4b000000
  10468f:	6a 01                	push   $0x1
  104691:	e8 5a f9 ff ff       	call   103ff0 <get_ptbl_entry_by_va>
  104696:	83 c4 10             	add    $0x10,%esp
  104699:	85 c0                	test   %eax,%eax
  10469b:	0f 85 8f 00 00 00    	jne    104730 <MPTKern_test1+0xc0>
    dprintf("test 1 failed.\n");
    return 1;
  }
  if (get_pdir_entry_by_va(1, vaddr) != 0) {
  1046a1:	83 ec 08             	sub    $0x8,%esp
  1046a4:	68 00 00 00 4b       	push   $0x4b000000
  1046a9:	6a 01                	push   $0x1
  1046ab:	e8 10 f9 ff ff       	call   103fc0 <get_pdir_entry_by_va>
  1046b0:	83 c4 10             	add    $0x10,%esp
  1046b3:	85 c0                	test   %eax,%eax
  1046b5:	75 79                	jne    104730 <MPTKern_test1+0xc0>
    dprintf("test 1 failed.\n");
    return 1;
  }
  map_page(1, vaddr, 100, 7);
  1046b7:	6a 07                	push   $0x7
  1046b9:	6a 64                	push   $0x64
  1046bb:	68 00 00 00 4b       	push   $0x4b000000
  1046c0:	6a 01                	push   $0x1
  1046c2:	e8 c9 fe ff ff       	call   104590 <map_page>
  if (get_ptbl_entry_by_va(1, vaddr) == 0) {
  1046c7:	59                   	pop    %ecx
  1046c8:	58                   	pop    %eax
  1046c9:	68 00 00 00 4b       	push   $0x4b000000
  1046ce:	6a 01                	push   $0x1
  1046d0:	e8 1b f9 ff ff       	call   103ff0 <get_ptbl_entry_by_va>
  1046d5:	83 c4 10             	add    $0x10,%esp
  1046d8:	85 c0                	test   %eax,%eax
  1046da:	74 54                	je     104730 <MPTKern_test1+0xc0>
    dprintf("test 1 failed.\n");
    return 1;
  }
  if (get_pdir_entry_by_va(1, vaddr) == 0) {
  1046dc:	83 ec 08             	sub    $0x8,%esp
  1046df:	68 00 00 00 4b       	push   $0x4b000000
  1046e4:	6a 01                	push   $0x1
  1046e6:	e8 d5 f8 ff ff       	call   103fc0 <get_pdir_entry_by_va>
  1046eb:	83 c4 10             	add    $0x10,%esp
  1046ee:	85 c0                	test   %eax,%eax
  1046f0:	74 3e                	je     104730 <MPTKern_test1+0xc0>
    dprintf("test 1 failed.\n");
    return 1;
  }
  unmap_page(1, vaddr);
  1046f2:	83 ec 08             	sub    $0x8,%esp
  1046f5:	68 00 00 00 4b       	push   $0x4b000000
  1046fa:	6a 01                	push   $0x1
  1046fc:	e8 1f ff ff ff       	call   104620 <unmap_page>
  if (get_ptbl_entry_by_va(1, vaddr) != 0) {
  104701:	58                   	pop    %eax
  104702:	5a                   	pop    %edx
  104703:	68 00 00 00 4b       	push   $0x4b000000
  104708:	6a 01                	push   $0x1
  10470a:	e8 e1 f8 ff ff       	call   103ff0 <get_ptbl_entry_by_va>
  10470f:	83 c4 10             	add    $0x10,%esp
  104712:	85 c0                	test   %eax,%eax
  104714:	75 1a                	jne    104730 <MPTKern_test1+0xc0>
    dprintf("test 1 failed.\n");
    return 1;
  }
  dprintf("test 1 passed.\n");
  104716:	8d 83 6a b3 ff ff    	lea    -0x4c96(%ebx),%eax
  10471c:	83 ec 0c             	sub    $0xc,%esp
  10471f:	50                   	push   %eax
  104720:	e8 0a d9 ff ff       	call   10202f <dprintf>
  104725:	83 c4 10             	add    $0x10,%esp
  return 0;
  104728:	31 c0                	xor    %eax,%eax
  10472a:	eb 1b                	jmp    104747 <MPTKern_test1+0xd7>
  10472c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dprintf("test 1 failed.\n");
  104730:	8d 83 5a b3 ff ff    	lea    -0x4ca6(%ebx),%eax
  104736:	83 ec 0c             	sub    $0xc,%esp
  104739:	50                   	push   %eax
  10473a:	e8 f0 d8 ff ff       	call   10202f <dprintf>
    return 1;
  10473f:	83 c4 10             	add    $0x10,%esp
  104742:	b8 01 00 00 00       	mov    $0x1,%eax
}
  104747:	83 c4 08             	add    $0x8,%esp
  10474a:	5b                   	pop    %ebx
  10474b:	c3                   	ret    
  10474c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00104750 <MPTKern_test2>:

int MPTKern_test2()
{
  104750:	56                   	push   %esi
  104751:	53                   	push   %ebx
  104752:	be 00 00 00 40       	mov    $0x40000000,%esi
  104757:	e8 b3 bb ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  10475c:	81 c3 a4 68 00 00    	add    $0x68a4,%ebx
  104762:	83 ec 04             	sub    $0x4,%esp
  104765:	eb 17                	jmp    10477e <MPTKern_test2+0x2e>
  104767:	89 f6                	mov    %esi,%esi
  104769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  104770:	81 c6 00 00 40 00    	add    $0x400000,%esi
  unsigned int i;
  for (i = 256; i < 960; i ++) {
  104776:	81 fe 00 00 00 f0    	cmp    $0xf0000000,%esi
  10477c:	74 32                	je     1047b0 <MPTKern_test2+0x60>
    if (get_ptbl_entry_by_va(0, i * 4096 * 1024L) != i * 4096 * 1024L + 3) {
  10477e:	83 ec 08             	sub    $0x8,%esp
  104781:	56                   	push   %esi
  104782:	6a 00                	push   $0x0
  104784:	e8 67 f8 ff ff       	call   103ff0 <get_ptbl_entry_by_va>
  104789:	8d 56 03             	lea    0x3(%esi),%edx
  10478c:	83 c4 10             	add    $0x10,%esp
  10478f:	39 d0                	cmp    %edx,%eax
  104791:	74 dd                	je     104770 <MPTKern_test2+0x20>
      dprintf("test 2 failed.\n");
  104793:	8d 83 c5 b3 ff ff    	lea    -0x4c3b(%ebx),%eax
  104799:	83 ec 0c             	sub    $0xc,%esp
  10479c:	50                   	push   %eax
  10479d:	e8 8d d8 ff ff       	call   10202f <dprintf>
      return 1;
  1047a2:	83 c4 10             	add    $0x10,%esp
  1047a5:	b8 01 00 00 00       	mov    $0x1,%eax
    }
  }
  dprintf("test 2 passed.\n");
  return 0;
}
  1047aa:	83 c4 04             	add    $0x4,%esp
  1047ad:	5b                   	pop    %ebx
  1047ae:	5e                   	pop    %esi
  1047af:	c3                   	ret    
  dprintf("test 2 passed.\n");
  1047b0:	8d 83 d5 b3 ff ff    	lea    -0x4c2b(%ebx),%eax
  1047b6:	83 ec 0c             	sub    $0xc,%esp
  1047b9:	50                   	push   %eax
  1047ba:	e8 70 d8 ff ff       	call   10202f <dprintf>
  return 0;
  1047bf:	83 c4 10             	add    $0x10,%esp
  1047c2:	31 c0                	xor    %eax,%eax
}
  1047c4:	83 c4 04             	add    $0x4,%esp
  1047c7:	5b                   	pop    %ebx
  1047c8:	5e                   	pop    %esi
  1047c9:	c3                   	ret    
  1047ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001047d0 <MPTKern_test_own>:
int MPTKern_test_own()
{
  // TODO (optional)
  // dprintf("own test passed.\n");
  return 0;
}
  1047d0:	31 c0                	xor    %eax,%eax
  1047d2:	c3                   	ret    
  1047d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1047d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001047e0 <test_MPTKern>:

int test_MPTKern()
{
  1047e0:	53                   	push   %ebx
  1047e1:	83 ec 08             	sub    $0x8,%esp
  return MPTKern_test1() + MPTKern_test2() + MPTKern_test_own();
  1047e4:	e8 87 fe ff ff       	call   104670 <MPTKern_test1>
  1047e9:	89 c3                	mov    %eax,%ebx
  1047eb:	e8 60 ff ff ff       	call   104750 <MPTKern_test2>
}
  1047f0:	83 c4 08             	add    $0x8,%esp
  return MPTKern_test1() + MPTKern_test2() + MPTKern_test_own();
  1047f3:	01 d8                	add    %ebx,%eax
}
  1047f5:	5b                   	pop    %ebx
  1047f6:	c3                   	ret    
  1047f7:	66 90                	xchg   %ax,%ax
  1047f9:	66 90                	xchg   %ax,%ax
  1047fb:	66 90                	xchg   %ax,%ax
  1047fd:	66 90                	xchg   %ax,%ax
  1047ff:	90                   	nop

00104800 <alloc_page>:
  *   - It should return the physical page index registered in the page directory, i.e., the
  *     return value from map_page.
  *   - In the case of error, it should return the MagicNumber.
  */
unsigned int alloc_page (unsigned int proc_index, unsigned int vaddr, unsigned int perm)
{
  104800:	56                   	push   %esi
  104801:	53                   	push   %ebx
  104802:	e8 08 bb ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  104807:	81 c3 f9 67 00 00    	add    $0x67f9,%ebx
  10480d:	83 ec 10             	sub    $0x10,%esp
  104810:	8b 74 24 1c          	mov    0x1c(%esp),%esi
  // TODO
  unsigned int  address_alloc=container_alloc(proc_index);
  104814:	56                   	push   %esi
  104815:	e8 c6 f1 ff ff       	call   1039e0 <container_alloc>
  if (address_alloc==0)
  10481a:	83 c4 10             	add    $0x10,%esp
  10481d:	85 c0                	test   %eax,%eax
  10481f:	74 1f                	je     104840 <alloc_page+0x40>
  {
    return MagicNumber;
  }
  else{
    int index=map_page(proc_index,vaddr,address_alloc,perm);
  104821:	ff 74 24 18          	pushl  0x18(%esp)
  104825:	50                   	push   %eax
  104826:	ff 74 24 1c          	pushl  0x1c(%esp)
  10482a:	56                   	push   %esi
  10482b:	e8 60 fd ff ff       	call   104590 <map_page>
    return index==0?MagicNumber:index;
  104830:	83 c4 10             	add    $0x10,%esp
  104833:	85 c0                	test   %eax,%eax
  104835:	74 09                	je     104840 <alloc_page+0x40>
  }
}
  104837:	83 c4 04             	add    $0x4,%esp
  10483a:	5b                   	pop    %ebx
  10483b:	5e                   	pop    %esi
  10483c:	c3                   	ret    
  10483d:	8d 76 00             	lea    0x0(%esi),%esi
  104840:	83 c4 04             	add    $0x4,%esp
    return MagicNumber;
  104843:	b8 01 00 10 00       	mov    $0x100001,%eax
}
  104848:	5b                   	pop    %ebx
  104849:	5e                   	pop    %esi
  10484a:	c3                   	ret    
  10484b:	90                   	nop
  10484c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00104850 <alloc_mem_quota>:

/**
 * Designate some memory quota for the next child process.
 */
unsigned int alloc_mem_quota (unsigned int id, unsigned int quota)
{
  104850:	53                   	push   %ebx
  104851:	e8 b9 ba ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  104856:	81 c3 aa 67 00 00    	add    $0x67aa,%ebx
  10485c:	83 ec 10             	sub    $0x10,%esp
  unsigned int child;
  child = container_split (id, quota);
  10485f:	ff 74 24 1c          	pushl  0x1c(%esp)
  104863:	ff 74 24 1c          	pushl  0x1c(%esp)
  104867:	e8 f4 f0 ff ff       	call   103960 <container_split>
  return child;
}
  10486c:	83 c4 18             	add    $0x18,%esp
  10486f:	5b                   	pop    %ebx
  104870:	c3                   	ret    
  104871:	66 90                	xchg   %ax,%ax
  104873:	66 90                	xchg   %ax,%ax
  104875:	66 90                	xchg   %ax,%ax
  104877:	66 90                	xchg   %ax,%ax
  104879:	66 90                	xchg   %ax,%ax
  10487b:	66 90                	xchg   %ax,%ax
  10487d:	66 90                	xchg   %ax,%ax
  10487f:	90                   	nop

00104880 <MPTNew_test1>:
#include <vmm/MPTOp/export.h>
#include "export.h"
#include "import.h"

int MPTNew_test1()
{
  104880:	53                   	push   %ebx
  104881:	e8 89 ba ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  104886:	81 c3 7a 67 00 00    	add    $0x677a,%ebx
  10488c:	83 ec 10             	sub    $0x10,%esp
  unsigned int vaddr = 4096*1024*400;
  container_split(0, 100);
  10488f:	6a 64                	push   $0x64
  104891:	6a 00                	push   $0x0
  104893:	e8 c8 f0 ff ff       	call   103960 <container_split>
  if (get_ptbl_entry_by_va(1, vaddr) != 0) {
  104898:	59                   	pop    %ecx
  104899:	58                   	pop    %eax
  10489a:	68 00 00 00 64       	push   $0x64000000
  10489f:	6a 01                	push   $0x1
  1048a1:	e8 4a f7 ff ff       	call   103ff0 <get_ptbl_entry_by_va>
  1048a6:	83 c4 10             	add    $0x10,%esp
  1048a9:	85 c0                	test   %eax,%eax
  1048ab:	75 6b                	jne    104918 <MPTNew_test1+0x98>
    dprintf("test 1 failed.\n");
    return 1;
  }
  if (get_pdir_entry_by_va(1, vaddr) != 0) {
  1048ad:	83 ec 08             	sub    $0x8,%esp
  1048b0:	68 00 00 00 64       	push   $0x64000000
  1048b5:	6a 01                	push   $0x1
  1048b7:	e8 04 f7 ff ff       	call   103fc0 <get_pdir_entry_by_va>
  1048bc:	83 c4 10             	add    $0x10,%esp
  1048bf:	85 c0                	test   %eax,%eax
  1048c1:	75 55                	jne    104918 <MPTNew_test1+0x98>
    dprintf("test 1 failed.\n");
    return 1;
  }
  alloc_page(1, vaddr, 7);
  1048c3:	83 ec 04             	sub    $0x4,%esp
  1048c6:	6a 07                	push   $0x7
  1048c8:	68 00 00 00 64       	push   $0x64000000
  1048cd:	6a 01                	push   $0x1
  1048cf:	e8 2c ff ff ff       	call   104800 <alloc_page>
  if (get_ptbl_entry_by_va(1, vaddr) == 0) {
  1048d4:	58                   	pop    %eax
  1048d5:	5a                   	pop    %edx
  1048d6:	68 00 00 00 64       	push   $0x64000000
  1048db:	6a 01                	push   $0x1
  1048dd:	e8 0e f7 ff ff       	call   103ff0 <get_ptbl_entry_by_va>
  1048e2:	83 c4 10             	add    $0x10,%esp
  1048e5:	85 c0                	test   %eax,%eax
  1048e7:	74 2f                	je     104918 <MPTNew_test1+0x98>
    dprintf("test 1 failed.\n");
    return 1;
  }
  if (get_pdir_entry_by_va(1, vaddr) == 0) {
  1048e9:	83 ec 08             	sub    $0x8,%esp
  1048ec:	68 00 00 00 64       	push   $0x64000000
  1048f1:	6a 01                	push   $0x1
  1048f3:	e8 c8 f6 ff ff       	call   103fc0 <get_pdir_entry_by_va>
  1048f8:	83 c4 10             	add    $0x10,%esp
  1048fb:	85 c0                	test   %eax,%eax
  1048fd:	74 19                	je     104918 <MPTNew_test1+0x98>
    dprintf("test 1 failed.\n");
    return 1;
  }
  dprintf("test 1 passed.\n");
  1048ff:	8d 83 6a b3 ff ff    	lea    -0x4c96(%ebx),%eax
  104905:	83 ec 0c             	sub    $0xc,%esp
  104908:	50                   	push   %eax
  104909:	e8 21 d7 ff ff       	call   10202f <dprintf>
  10490e:	83 c4 10             	add    $0x10,%esp
  return 0;
  104911:	31 c0                	xor    %eax,%eax
  104913:	eb 1a                	jmp    10492f <MPTNew_test1+0xaf>
  104915:	8d 76 00             	lea    0x0(%esi),%esi
    dprintf("test 1 failed.\n");
  104918:	8d 83 5a b3 ff ff    	lea    -0x4ca6(%ebx),%eax
  10491e:	83 ec 0c             	sub    $0xc,%esp
  104921:	50                   	push   %eax
  104922:	e8 08 d7 ff ff       	call   10202f <dprintf>
    return 1;
  104927:	83 c4 10             	add    $0x10,%esp
  10492a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  10492f:	83 c4 08             	add    $0x8,%esp
  104932:	5b                   	pop    %ebx
  104933:	c3                   	ret    
  104934:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10493a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00104940 <MPTNew_test_own>:
int MPTNew_test_own()
{
  // TODO (optional)
  // dprintf("own test passed.\n");
  return 0;
}
  104940:	31 c0                	xor    %eax,%eax
  104942:	c3                   	ret    
  104943:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104950 <test_MPTNew>:

int test_MPTNew()
{
  return MPTNew_test1() + MPTNew_test_own();
  104950:	e9 2b ff ff ff       	jmp    104880 <MPTNew_test1>
  104955:	66 90                	xchg   %ax,%ax
  104957:	66 90                	xchg   %ax,%ax
  104959:	66 90                	xchg   %ax,%ax
  10495b:	66 90                	xchg   %ax,%ax
  10495d:	66 90                	xchg   %ax,%ax
  10495f:	90                   	nop

00104960 <kctx_set_esp>:

//places to save the [NUM_IDS] kernel thread states.
struct kctx kctx_pool[NUM_IDS];

void kctx_set_esp(unsigned int pid, void *esp)
{
  104960:	e8 16 cb ff ff       	call   10147b <__x86.get_pc_thunk.dx>
  104965:	81 c2 9b 66 00 00    	add    $0x669b,%edx
  10496b:	8b 44 24 04          	mov    0x4(%esp),%eax
	kctx_pool[pid].esp = esp;
  10496f:	c7 c1 00 f0 de 00    	mov    $0xdef000,%ecx
  104975:	8b 54 24 08          	mov    0x8(%esp),%edx
  104979:	8d 04 40             	lea    (%eax,%eax,2),%eax
  10497c:	8d 04 c1             	lea    (%ecx,%eax,8),%eax
  10497f:	89 10                	mov    %edx,(%eax)
}
  104981:	c3                   	ret    
  104982:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104990 <kctx_set_eip>:

void kctx_set_eip(unsigned int pid, void *eip)
{
  104990:	e8 e6 ca ff ff       	call   10147b <__x86.get_pc_thunk.dx>
  104995:	81 c2 6b 66 00 00    	add    $0x666b,%edx
  10499b:	8b 44 24 04          	mov    0x4(%esp),%eax
	kctx_pool[pid].eip = eip;
  10499f:	c7 c1 00 f0 de 00    	mov    $0xdef000,%ecx
  1049a5:	8b 54 24 08          	mov    0x8(%esp),%edx
  1049a9:	8d 04 40             	lea    (%eax,%eax,2),%eax
  1049ac:	8d 04 c1             	lea    (%ecx,%eax,8),%eax
  1049af:	89 50 14             	mov    %edx,0x14(%eax)
}
  1049b2:	c3                   	ret    
  1049b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1049b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001049c0 <kctx_switch>:
/**
 * Saves the states for thread # [from_pid] and restores the states
 * for thread # [to_pid].
 */
void kctx_switch(unsigned int from_pid, unsigned int to_pid)
{
  1049c0:	53                   	push   %ebx
  1049c1:	e8 49 b9 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  1049c6:	81 c3 3a 66 00 00    	add    $0x663a,%ebx
  1049cc:	83 ec 10             	sub    $0x10,%esp
  1049cf:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  1049d3:	8b 54 24 18          	mov    0x18(%esp),%edx
	cswitch(&kctx_pool[from_pid], &kctx_pool[to_pid]);
  1049d7:	8d 0c 40             	lea    (%eax,%eax,2),%ecx
  1049da:	c7 c0 00 f0 de 00    	mov    $0xdef000,%eax
  1049e0:	8d 14 52             	lea    (%edx,%edx,2),%edx
  1049e3:	8d 0c c8             	lea    (%eax,%ecx,8),%ecx
  1049e6:	8d 04 d0             	lea    (%eax,%edx,8),%eax
  1049e9:	51                   	push   %ecx
  1049ea:	50                   	push   %eax
  1049eb:	e8 05 00 00 00       	call   1049f5 <cswitch>
}
  1049f0:	83 c4 18             	add    $0x18,%esp
  1049f3:	5b                   	pop    %ebx
  1049f4:	c3                   	ret    

001049f5 <cswitch>:
cswitch:
	/**
	  * The pointer *from is saved to register %eax.
	  * This is the pointer to the kctx structure to be saved.
	  */
	movl	  4(%esp), %eax	
  1049f5:	8b 44 24 04          	mov    0x4(%esp),%eax

	/**
	  * The pointer *to is saved to register %edx.
	  * This is the pointer to the kctx structure to be loaded.
	  */
	movl	  8(%esp), %edx	
  1049f9:	8b 54 24 08          	mov    0x8(%esp),%edx


	/**
	  * The return value is stored in eax. Returns 0.
	  */
	xor     %eax, %eax
  1049fd:	31 c0                	xor    %eax,%eax
	ret
  1049ff:	c3                   	ret    

00104a00 <kctx_new>:
  */
unsigned int kctx_new(void *entry, unsigned int id, unsigned int quota)
{
  // TODO
  return 0;
}
  104a00:	31 c0                	xor    %eax,%eax
  104a02:	c3                   	ret    
  104a03:	66 90                	xchg   %ax,%ax
  104a05:	66 90                	xchg   %ax,%ax
  104a07:	66 90                	xchg   %ax,%ax
  104a09:	66 90                	xchg   %ax,%ax
  104a0b:	66 90                	xchg   %ax,%ax
  104a0d:	66 90                	xchg   %ax,%ax
  104a0f:	90                   	nop

00104a10 <PKCtxNew_test1>:
	void	*eip;
} kctx;
extern kctx kctx_pool[NUM_IDS];

int PKCtxNew_test1()
{
  104a10:	56                   	push   %esi
  104a11:	53                   	push   %ebx
  104a12:	e8 f8 b8 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  104a17:	81 c3 e9 65 00 00    	add    $0x65e9,%ebx
  104a1d:	83 ec 08             	sub    $0x8,%esp
  void * dummy_addr = (void *) 0;
  unsigned int chid = kctx_new(dummy_addr, 0, 1000);
  104a20:	68 e8 03 00 00       	push   $0x3e8
  104a25:	6a 00                	push   $0x0
  104a27:	6a 00                	push   $0x0
  104a29:	e8 d2 ff ff ff       	call   104a00 <kctx_new>
  if (container_get_quota(chid) != 1000) {
  104a2e:	89 04 24             	mov    %eax,(%esp)
  unsigned int chid = kctx_new(dummy_addr, 0, 1000);
  104a31:	89 c6                	mov    %eax,%esi
  if (container_get_quota(chid) != 1000) {
  104a33:	e8 b8 ee ff ff       	call   1038f0 <container_get_quota>
  104a38:	83 c4 10             	add    $0x10,%esp
  104a3b:	3d e8 03 00 00       	cmp    $0x3e8,%eax
  104a40:	75 13                	jne    104a55 <PKCtxNew_test1+0x45>
    dprintf("test 1 failed.\n");
    return 1;
  }

  if (kctx_pool[chid].eip != dummy_addr) {
  104a42:	c7 c2 00 f0 de 00    	mov    $0xdef000,%edx
  104a48:	8d 04 76             	lea    (%esi,%esi,2),%eax
  104a4b:	8d 04 c2             	lea    (%edx,%eax,8),%eax
  104a4e:	8b 48 14             	mov    0x14(%eax),%ecx
  104a51:	85 c9                	test   %ecx,%ecx
  104a53:	74 23                	je     104a78 <PKCtxNew_test1+0x68>
    dprintf("test 1 failed.\n");
  104a55:	8d 83 5a b3 ff ff    	lea    -0x4ca6(%ebx),%eax
  104a5b:	83 ec 0c             	sub    $0xc,%esp
  104a5e:	50                   	push   %eax
  104a5f:	e8 cb d5 ff ff       	call   10202f <dprintf>
    return 1;
  104a64:	83 c4 10             	add    $0x10,%esp
  104a67:	b8 01 00 00 00       	mov    $0x1,%eax
    dprintf("test 1 failed.\n");
    return 1;
  }
  dprintf("test 1 passed.\n");
  return 0;
}
  104a6c:	83 c4 04             	add    $0x4,%esp
  104a6f:	5b                   	pop    %ebx
  104a70:	5e                   	pop    %esi
  104a71:	c3                   	ret    
  104a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  dprintf("test 1 passed.\n");
  104a78:	8d 83 6a b3 ff ff    	lea    -0x4c96(%ebx),%eax
  104a7e:	83 ec 0c             	sub    $0xc,%esp
  104a81:	50                   	push   %eax
  104a82:	e8 a8 d5 ff ff       	call   10202f <dprintf>
  return 0;
  104a87:	83 c4 10             	add    $0x10,%esp
  104a8a:	31 c0                	xor    %eax,%eax
}
  104a8c:	83 c4 04             	add    $0x4,%esp
  104a8f:	5b                   	pop    %ebx
  104a90:	5e                   	pop    %esi
  104a91:	c3                   	ret    
  104a92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104aa0 <PKCtxNew_test_own>:
int PKCtxNew_test_own()
{
  // TODO (optional)
  // dprintf("own test passed.\n");
  return 0;
}
  104aa0:	31 c0                	xor    %eax,%eax
  104aa2:	c3                   	ret    
  104aa3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104ab0 <test_PKCtxNew>:

int test_PKCtxNew()
{
  return PKCtxNew_test1() + PKCtxNew_test_own();
  104ab0:	e9 5b ff ff ff       	jmp    104a10 <PKCtxNew_test1>
  104ab5:	66 90                	xchg   %ax,%ax
  104ab7:	66 90                	xchg   %ax,%ax
  104ab9:	66 90                	xchg   %ax,%ax
  104abb:	66 90                	xchg   %ax,%ax
  104abd:	66 90                	xchg   %ax,%ax
  104abf:	90                   	nop

00104ac0 <tcb_get_state>:

struct TCB TCBPool[NUM_IDS];


unsigned int tcb_get_state(unsigned int pid)
{
  104ac0:	e8 b6 c9 ff ff       	call   10147b <__x86.get_pc_thunk.dx>
  104ac5:	81 c2 3b 65 00 00    	add    $0x653b,%edx
  104acb:	8b 44 24 04          	mov    0x4(%esp),%eax
	return TCBPool[pid].state;
  104acf:	c7 c1 00 f6 de 00    	mov    $0xdef600,%ecx
  104ad5:	8d 04 40             	lea    (%eax,%eax,2),%eax
  104ad8:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  104adb:	8b 00                	mov    (%eax),%eax
}
  104add:	c3                   	ret    
  104ade:	66 90                	xchg   %ax,%ax

00104ae0 <tcb_set_state>:

void tcb_set_state(unsigned int pid, unsigned int state)
{
  104ae0:	e8 96 c9 ff ff       	call   10147b <__x86.get_pc_thunk.dx>
  104ae5:	81 c2 1b 65 00 00    	add    $0x651b,%edx
  104aeb:	8b 44 24 04          	mov    0x4(%esp),%eax
	TCBPool[pid].state = state;
  104aef:	c7 c1 00 f6 de 00    	mov    $0xdef600,%ecx
  104af5:	8b 54 24 08          	mov    0x8(%esp),%edx
  104af9:	8d 04 40             	lea    (%eax,%eax,2),%eax
  104afc:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  104aff:	89 10                	mov    %edx,(%eax)
}
  104b01:	c3                   	ret    
  104b02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104b10 <tcb_get_prev>:

unsigned int tcb_get_prev(unsigned int pid)
{
  104b10:	e8 66 c9 ff ff       	call   10147b <__x86.get_pc_thunk.dx>
  104b15:	81 c2 eb 64 00 00    	add    $0x64eb,%edx
  104b1b:	8b 44 24 04          	mov    0x4(%esp),%eax
	return TCBPool[pid].prev;
  104b1f:	c7 c1 00 f6 de 00    	mov    $0xdef600,%ecx
  104b25:	8d 04 40             	lea    (%eax,%eax,2),%eax
  104b28:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  104b2b:	8b 40 04             	mov    0x4(%eax),%eax
}
  104b2e:	c3                   	ret    
  104b2f:	90                   	nop

00104b30 <tcb_set_prev>:

void tcb_set_prev(unsigned int pid, unsigned int prev_pid)
{
  104b30:	e8 46 c9 ff ff       	call   10147b <__x86.get_pc_thunk.dx>
  104b35:	81 c2 cb 64 00 00    	add    $0x64cb,%edx
  104b3b:	8b 44 24 04          	mov    0x4(%esp),%eax
	TCBPool[pid].prev = prev_pid;
  104b3f:	c7 c1 00 f6 de 00    	mov    $0xdef600,%ecx
  104b45:	8b 54 24 08          	mov    0x8(%esp),%edx
  104b49:	8d 04 40             	lea    (%eax,%eax,2),%eax
  104b4c:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  104b4f:	89 50 04             	mov    %edx,0x4(%eax)
}
  104b52:	c3                   	ret    
  104b53:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104b60 <tcb_get_next>:

unsigned int tcb_get_next(unsigned int pid)
{
  104b60:	e8 16 c9 ff ff       	call   10147b <__x86.get_pc_thunk.dx>
  104b65:	81 c2 9b 64 00 00    	add    $0x649b,%edx
  104b6b:	8b 44 24 04          	mov    0x4(%esp),%eax
	return TCBPool[pid].next;
  104b6f:	c7 c1 00 f6 de 00    	mov    $0xdef600,%ecx
  104b75:	8d 04 40             	lea    (%eax,%eax,2),%eax
  104b78:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  104b7b:	8b 40 08             	mov    0x8(%eax),%eax
}
  104b7e:	c3                   	ret    
  104b7f:	90                   	nop

00104b80 <tcb_set_next>:

void tcb_set_next(unsigned int pid, unsigned int next_pid)
{
  104b80:	e8 f6 c8 ff ff       	call   10147b <__x86.get_pc_thunk.dx>
  104b85:	81 c2 7b 64 00 00    	add    $0x647b,%edx
  104b8b:	8b 44 24 04          	mov    0x4(%esp),%eax
	TCBPool[pid].next = next_pid;
  104b8f:	c7 c1 00 f6 de 00    	mov    $0xdef600,%ecx
  104b95:	8b 54 24 08          	mov    0x8(%esp),%edx
  104b99:	8d 04 40             	lea    (%eax,%eax,2),%eax
  104b9c:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  104b9f:	89 50 08             	mov    %edx,0x8(%eax)
}
  104ba2:	c3                   	ret    
  104ba3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104bb0 <tcb_init_at_id>:

void tcb_init_at_id(unsigned int pid)
{
  104bb0:	e8 c6 c8 ff ff       	call   10147b <__x86.get_pc_thunk.dx>
  104bb5:	81 c2 4b 64 00 00    	add    $0x644b,%edx
  104bbb:	8b 44 24 04          	mov    0x4(%esp),%eax
	TCBPool[pid].state = TSTATE_DEAD;
  104bbf:	c7 c1 00 f6 de 00    	mov    $0xdef600,%ecx
  104bc5:	8d 04 40             	lea    (%eax,%eax,2),%eax
  104bc8:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  104bcb:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
	TCBPool[pid].prev = NUM_IDS;
  104bd1:	c7 40 04 40 00 00 00 	movl   $0x40,0x4(%eax)
	TCBPool[pid].next = NUM_IDS;
  104bd8:	c7 40 08 40 00 00 00 	movl   $0x40,0x8(%eax)
}
  104bdf:	c3                   	ret    

00104be0 <tcb_init>:
  *  - Use function tcb_init_at_id, defined in PTCBIntro.c
  */
void tcb_init(void)
{
  // TODO
}
  104be0:	f3 c3                	repz ret 
  104be2:	66 90                	xchg   %ax,%ax
  104be4:	66 90                	xchg   %ax,%ax
  104be6:	66 90                	xchg   %ax,%ax
  104be8:	66 90                	xchg   %ax,%ax
  104bea:	66 90                	xchg   %ax,%ax
  104bec:	66 90                	xchg   %ax,%ax
  104bee:	66 90                	xchg   %ax,%ax

00104bf0 <PTCBInit_test1>:
#include <lib/thread.h>
#include <thread/PTCBIntro/export.h>
#include "export.h"

int PTCBInit_test1()
{
  104bf0:	56                   	push   %esi
  104bf1:	53                   	push   %ebx
  unsigned int i;
  for (i = 1; i < NUM_IDS; i ++) {
  104bf2:	be 01 00 00 00       	mov    $0x1,%esi
  104bf7:	e8 13 b7 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  104bfc:	81 c3 04 64 00 00    	add    $0x6404,%ebx
{
  104c02:	83 ec 04             	sub    $0x4,%esp
  104c05:	eb 33                	jmp    104c3a <PTCBInit_test1+0x4a>
  104c07:	89 f6                	mov    %esi,%esi
  104c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if (tcb_get_state(i) != TSTATE_DEAD || tcb_get_prev(i) != NUM_IDS || tcb_get_next(i) != NUM_IDS) {
  104c10:	83 ec 0c             	sub    $0xc,%esp
  104c13:	56                   	push   %esi
  104c14:	e8 f7 fe ff ff       	call   104b10 <tcb_get_prev>
  104c19:	83 c4 10             	add    $0x10,%esp
  104c1c:	83 f8 40             	cmp    $0x40,%eax
  104c1f:	75 2a                	jne    104c4b <PTCBInit_test1+0x5b>
  104c21:	83 ec 0c             	sub    $0xc,%esp
  104c24:	56                   	push   %esi
  104c25:	e8 36 ff ff ff       	call   104b60 <tcb_get_next>
  104c2a:	83 c4 10             	add    $0x10,%esp
  104c2d:	83 f8 40             	cmp    $0x40,%eax
  104c30:	75 19                	jne    104c4b <PTCBInit_test1+0x5b>
  for (i = 1; i < NUM_IDS; i ++) {
  104c32:	83 c6 01             	add    $0x1,%esi
  104c35:	83 fe 40             	cmp    $0x40,%esi
  104c38:	74 36                	je     104c70 <PTCBInit_test1+0x80>
    if (tcb_get_state(i) != TSTATE_DEAD || tcb_get_prev(i) != NUM_IDS || tcb_get_next(i) != NUM_IDS) {
  104c3a:	83 ec 0c             	sub    $0xc,%esp
  104c3d:	56                   	push   %esi
  104c3e:	e8 7d fe ff ff       	call   104ac0 <tcb_get_state>
  104c43:	83 c4 10             	add    $0x10,%esp
  104c46:	83 f8 03             	cmp    $0x3,%eax
  104c49:	74 c5                	je     104c10 <PTCBInit_test1+0x20>
      dprintf("test 1 failed.\n");
  104c4b:	8d 83 5a b3 ff ff    	lea    -0x4ca6(%ebx),%eax
  104c51:	83 ec 0c             	sub    $0xc,%esp
  104c54:	50                   	push   %eax
  104c55:	e8 d5 d3 ff ff       	call   10202f <dprintf>
      return 1;
  104c5a:	83 c4 10             	add    $0x10,%esp
  104c5d:	b8 01 00 00 00       	mov    $0x1,%eax
    }
  }
  dprintf("test 1 passed.\n");
  return 0;
}
  104c62:	83 c4 04             	add    $0x4,%esp
  104c65:	5b                   	pop    %ebx
  104c66:	5e                   	pop    %esi
  104c67:	c3                   	ret    
  104c68:	90                   	nop
  104c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  dprintf("test 1 passed.\n");
  104c70:	8d 83 6a b3 ff ff    	lea    -0x4c96(%ebx),%eax
  104c76:	83 ec 0c             	sub    $0xc,%esp
  104c79:	50                   	push   %eax
  104c7a:	e8 b0 d3 ff ff       	call   10202f <dprintf>
  return 0;
  104c7f:	83 c4 10             	add    $0x10,%esp
  104c82:	31 c0                	xor    %eax,%eax
}
  104c84:	83 c4 04             	add    $0x4,%esp
  104c87:	5b                   	pop    %ebx
  104c88:	5e                   	pop    %esi
  104c89:	c3                   	ret    
  104c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104c90 <PTCBInit_test_own>:
int PTCBInit_test_own()
{
  // TODO (optional)
  // dprintf("own test passed.\n");
  return 0;
}
  104c90:	31 c0                	xor    %eax,%eax
  104c92:	c3                   	ret    
  104c93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104ca0 <test_PTCBInit>:

int test_PTCBInit()
{
  return PTCBInit_test1() + PTCBInit_test_own();
  104ca0:	e9 4b ff ff ff       	jmp    104bf0 <PTCBInit_test1>
  104ca5:	66 90                	xchg   %ax,%ax
  104ca7:	66 90                	xchg   %ax,%ax
  104ca9:	66 90                	xchg   %ax,%ax
  104cab:	66 90                	xchg   %ax,%ax
  104cad:	66 90                	xchg   %ax,%ax
  104caf:	90                   	nop

00104cb0 <tqueue_get_head>:
 * and are scheduled in a round-robin manner.
 */
struct TQueue TQueuePool[NUM_IDS + 1];

unsigned int tqueue_get_head(unsigned int chid)
{
  104cb0:	e8 0d d8 ff ff       	call   1024c2 <__x86.get_pc_thunk.ax>
  104cb5:	05 4b 63 00 00       	add    $0x634b,%eax
	return TQueuePool[chid].head;
  104cba:	8b 54 24 04          	mov    0x4(%esp),%edx
  104cbe:	c7 c0 00 f9 de 00    	mov    $0xdef900,%eax
  104cc4:	8b 04 d0             	mov    (%eax,%edx,8),%eax
}
  104cc7:	c3                   	ret    
  104cc8:	90                   	nop
  104cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104cd0 <tqueue_set_head>:

void tqueue_set_head(unsigned int chid, unsigned int head)
{
  104cd0:	e8 ed d7 ff ff       	call   1024c2 <__x86.get_pc_thunk.ax>
  104cd5:	05 2b 63 00 00       	add    $0x632b,%eax
	TQueuePool[chid].head = head;
  104cda:	8b 54 24 04          	mov    0x4(%esp),%edx
  104cde:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  104ce2:	c7 c0 00 f9 de 00    	mov    $0xdef900,%eax
  104ce8:	89 0c d0             	mov    %ecx,(%eax,%edx,8)
}
  104ceb:	c3                   	ret    
  104cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00104cf0 <tqueue_get_tail>:

unsigned int tqueue_get_tail(unsigned int chid)
{
  104cf0:	e8 cd d7 ff ff       	call   1024c2 <__x86.get_pc_thunk.ax>
  104cf5:	05 0b 63 00 00       	add    $0x630b,%eax
	return TQueuePool[chid].tail;
  104cfa:	8b 54 24 04          	mov    0x4(%esp),%edx
  104cfe:	c7 c0 00 f9 de 00    	mov    $0xdef900,%eax
  104d04:	8b 44 d0 04          	mov    0x4(%eax,%edx,8),%eax
}
  104d08:	c3                   	ret    
  104d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104d10 <tqueue_set_tail>:

void tqueue_set_tail(unsigned int chid, unsigned int tail)
{
  104d10:	e8 ad d7 ff ff       	call   1024c2 <__x86.get_pc_thunk.ax>
  104d15:	05 eb 62 00 00       	add    $0x62eb,%eax
	TQueuePool[chid].tail = tail;
  104d1a:	8b 54 24 04          	mov    0x4(%esp),%edx
  104d1e:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  104d22:	c7 c0 00 f9 de 00    	mov    $0xdef900,%eax
  104d28:	89 4c d0 04          	mov    %ecx,0x4(%eax,%edx,8)
}
  104d2c:	c3                   	ret    
  104d2d:	8d 76 00             	lea    0x0(%esi),%esi

00104d30 <tqueue_init_at_id>:

void tqueue_init_at_id(unsigned int chid)
{
  104d30:	e8 8d d7 ff ff       	call   1024c2 <__x86.get_pc_thunk.ax>
  104d35:	05 cb 62 00 00       	add    $0x62cb,%eax
  104d3a:	8b 54 24 04          	mov    0x4(%esp),%edx
	TQueuePool[chid].head = NUM_IDS;
  104d3e:	c7 c0 00 f9 de 00    	mov    $0xdef900,%eax
  104d44:	c7 04 d0 40 00 00 00 	movl   $0x40,(%eax,%edx,8)
	TQueuePool[chid].tail = NUM_IDS;
  104d4b:	c7 44 d0 04 40 00 00 	movl   $0x40,0x4(%eax,%edx,8)
  104d52:	00 
}
  104d53:	c3                   	ret    
  104d54:	66 90                	xchg   %ax,%ax
  104d56:	66 90                	xchg   %ax,%ax
  104d58:	66 90                	xchg   %ax,%ax
  104d5a:	66 90                	xchg   %ax,%ax
  104d5c:	66 90                	xchg   %ax,%ax
  104d5e:	66 90                	xchg   %ax,%ax

00104d60 <tqueue_init>:
  *  Hint 1:
  *  - Remember that there are NUM_IDS + 1 queues. The first NUM_IDS queues are the sleep queues and 
  *    the last queue with id NUM_IDS is the ready queue.
  */
void tqueue_init(void)
{
  104d60:	53                   	push   %ebx
  104d61:	e8 a9 b5 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  104d66:	81 c3 9a 62 00 00    	add    $0x629a,%ebx
  104d6c:	83 ec 08             	sub    $0x8,%esp
  // TODO: define your local variables here.

	tcb_init();
  104d6f:	e8 6c fe ff ff       	call   104be0 <tcb_init>

  // TODO
}
  104d74:	83 c4 08             	add    $0x8,%esp
  104d77:	5b                   	pop    %ebx
  104d78:	c3                   	ret    
  104d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104d80 <tqueue_enqueue>:
  *    3. and the next pointer for #pid should point to NULL (i.e. NUM_IDS)
  */
void tqueue_enqueue(unsigned int chid, unsigned int pid)
{
  // TODO
}
  104d80:	f3 c3                	repz ret 
  104d82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104d90 <tqueue_dequeue>:
  */
unsigned int tqueue_dequeue(unsigned int chid)
{
  // TODO
  return 0;
}
  104d90:	31 c0                	xor    %eax,%eax
  104d92:	c3                   	ret    
  104d93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104da0 <tqueue_remove>:
  104da0:	f3 c3                	repz ret 
  104da2:	66 90                	xchg   %ax,%ax
  104da4:	66 90                	xchg   %ax,%ax
  104da6:	66 90                	xchg   %ax,%ax
  104da8:	66 90                	xchg   %ax,%ax
  104daa:	66 90                	xchg   %ax,%ax
  104dac:	66 90                	xchg   %ax,%ax
  104dae:	66 90                	xchg   %ax,%ax

00104db0 <PTQueueInit_test1>:
#include <thread/PTCBIntro/export.h>
#include <thread/PTQueueIntro/export.h>
#include "export.h"

int PTQueueInit_test1()
{
  104db0:	56                   	push   %esi
  104db1:	53                   	push   %ebx
  unsigned int i;
  for (i = 0; i < NUM_IDS; i ++) {
  104db2:	31 f6                	xor    %esi,%esi
  104db4:	e8 56 b5 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  104db9:	81 c3 47 62 00 00    	add    $0x6247,%ebx
{
  104dbf:	83 ec 04             	sub    $0x4,%esp
  104dc2:	eb 1d                	jmp    104de1 <PTQueueInit_test1+0x31>
  104dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (tqueue_get_head(i) != NUM_IDS || tqueue_get_tail(i) != NUM_IDS) {
  104dc8:	83 ec 0c             	sub    $0xc,%esp
  104dcb:	56                   	push   %esi
  104dcc:	e8 1f ff ff ff       	call   104cf0 <tqueue_get_tail>
  104dd1:	83 c4 10             	add    $0x10,%esp
  104dd4:	83 f8 40             	cmp    $0x40,%eax
  104dd7:	75 19                	jne    104df2 <PTQueueInit_test1+0x42>
  for (i = 0; i < NUM_IDS; i ++) {
  104dd9:	83 c6 01             	add    $0x1,%esi
  104ddc:	83 fe 40             	cmp    $0x40,%esi
  104ddf:	74 2f                	je     104e10 <PTQueueInit_test1+0x60>
    if (tqueue_get_head(i) != NUM_IDS || tqueue_get_tail(i) != NUM_IDS) {
  104de1:	83 ec 0c             	sub    $0xc,%esp
  104de4:	56                   	push   %esi
  104de5:	e8 c6 fe ff ff       	call   104cb0 <tqueue_get_head>
  104dea:	83 c4 10             	add    $0x10,%esp
  104ded:	83 f8 40             	cmp    $0x40,%eax
  104df0:	74 d6                	je     104dc8 <PTQueueInit_test1+0x18>
      dprintf("test 1 failed.\n");
  104df2:	8d 83 5a b3 ff ff    	lea    -0x4ca6(%ebx),%eax
  104df8:	83 ec 0c             	sub    $0xc,%esp
  104dfb:	50                   	push   %eax
  104dfc:	e8 2e d2 ff ff       	call   10202f <dprintf>
      return 1;
  104e01:	83 c4 10             	add    $0x10,%esp
  104e04:	b8 01 00 00 00       	mov    $0x1,%eax
    }
  }
  dprintf("test 1 passed.\n");
  return 0;
}
  104e09:	83 c4 04             	add    $0x4,%esp
  104e0c:	5b                   	pop    %ebx
  104e0d:	5e                   	pop    %esi
  104e0e:	c3                   	ret    
  104e0f:	90                   	nop
  dprintf("test 1 passed.\n");
  104e10:	8d 83 6a b3 ff ff    	lea    -0x4c96(%ebx),%eax
  104e16:	83 ec 0c             	sub    $0xc,%esp
  104e19:	50                   	push   %eax
  104e1a:	e8 10 d2 ff ff       	call   10202f <dprintf>
  return 0;
  104e1f:	83 c4 10             	add    $0x10,%esp
  104e22:	31 c0                	xor    %eax,%eax
}
  104e24:	83 c4 04             	add    $0x4,%esp
  104e27:	5b                   	pop    %ebx
  104e28:	5e                   	pop    %esi
  104e29:	c3                   	ret    
  104e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104e30 <PTQueueInit_test2>:

int PTQueueInit_test2()
{
  104e30:	53                   	push   %ebx
  104e31:	e8 d9 b4 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  104e36:	81 c3 ca 61 00 00    	add    $0x61ca,%ebx
  104e3c:	83 ec 10             	sub    $0x10,%esp
  unsigned int pid;
  tqueue_enqueue(0, 2);
  104e3f:	6a 02                	push   $0x2
  104e41:	6a 00                	push   $0x0
  104e43:	e8 38 ff ff ff       	call   104d80 <tqueue_enqueue>
  tqueue_enqueue(0, 3);
  104e48:	5a                   	pop    %edx
  104e49:	59                   	pop    %ecx
  104e4a:	6a 03                	push   $0x3
  104e4c:	6a 00                	push   $0x0
  104e4e:	e8 2d ff ff ff       	call   104d80 <tqueue_enqueue>
  tqueue_enqueue(0, 4);
  104e53:	58                   	pop    %eax
  104e54:	5a                   	pop    %edx
  104e55:	6a 04                	push   $0x4
  104e57:	6a 00                	push   $0x0
  104e59:	e8 22 ff ff ff       	call   104d80 <tqueue_enqueue>
  if (tcb_get_prev(2) != NUM_IDS || tcb_get_next(2) != 3) {
  104e5e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  104e65:	e8 a6 fc ff ff       	call   104b10 <tcb_get_prev>
  104e6a:	83 c4 10             	add    $0x10,%esp
  104e6d:	83 f8 40             	cmp    $0x40,%eax
  104e70:	74 1e                	je     104e90 <PTQueueInit_test2+0x60>
    dprintf("test 2-a failed.\n");
  104e72:	8d 83 e5 b3 ff ff    	lea    -0x4c1b(%ebx),%eax
  104e78:	83 ec 0c             	sub    $0xc,%esp
  104e7b:	50                   	push   %eax
  104e7c:	e8 ae d1 ff ff       	call   10202f <dprintf>
    return 1;
  104e81:	83 c4 10             	add    $0x10,%esp
  104e84:	b8 01 00 00 00       	mov    $0x1,%eax
    dprintf("test 2-g failed.\n");
    return 1;
  }
  dprintf("test 2 passed.\n");
  return 0;
}
  104e89:	83 c4 08             	add    $0x8,%esp
  104e8c:	5b                   	pop    %ebx
  104e8d:	c3                   	ret    
  104e8e:	66 90                	xchg   %ax,%ax
  if (tcb_get_prev(2) != NUM_IDS || tcb_get_next(2) != 3) {
  104e90:	83 ec 0c             	sub    $0xc,%esp
  104e93:	6a 02                	push   $0x2
  104e95:	e8 c6 fc ff ff       	call   104b60 <tcb_get_next>
  104e9a:	83 c4 10             	add    $0x10,%esp
  104e9d:	83 f8 03             	cmp    $0x3,%eax
  104ea0:	75 d0                	jne    104e72 <PTQueueInit_test2+0x42>
  if (tcb_get_prev(3) != 2 || tcb_get_next(3) != 4) {
  104ea2:	83 ec 0c             	sub    $0xc,%esp
  104ea5:	6a 03                	push   $0x3
  104ea7:	e8 64 fc ff ff       	call   104b10 <tcb_get_prev>
  104eac:	83 c4 10             	add    $0x10,%esp
  104eaf:	83 f8 02             	cmp    $0x2,%eax
  104eb2:	74 1c                	je     104ed0 <PTQueueInit_test2+0xa0>
    dprintf("test 2-b failed.\n");
  104eb4:	8d 83 f7 b3 ff ff    	lea    -0x4c09(%ebx),%eax
  104eba:	83 ec 0c             	sub    $0xc,%esp
  104ebd:	50                   	push   %eax
  104ebe:	e8 6c d1 ff ff       	call   10202f <dprintf>
    return 1;
  104ec3:	83 c4 10             	add    $0x10,%esp
  104ec6:	b8 01 00 00 00       	mov    $0x1,%eax
  104ecb:	eb bc                	jmp    104e89 <PTQueueInit_test2+0x59>
  104ecd:	8d 76 00             	lea    0x0(%esi),%esi
  if (tcb_get_prev(3) != 2 || tcb_get_next(3) != 4) {
  104ed0:	83 ec 0c             	sub    $0xc,%esp
  104ed3:	6a 03                	push   $0x3
  104ed5:	e8 86 fc ff ff       	call   104b60 <tcb_get_next>
  104eda:	83 c4 10             	add    $0x10,%esp
  104edd:	83 f8 04             	cmp    $0x4,%eax
  104ee0:	75 d2                	jne    104eb4 <PTQueueInit_test2+0x84>
  if (tcb_get_prev(4) != 3 || tcb_get_next(4) != NUM_IDS) {
  104ee2:	83 ec 0c             	sub    $0xc,%esp
  104ee5:	6a 04                	push   $0x4
  104ee7:	e8 24 fc ff ff       	call   104b10 <tcb_get_prev>
  104eec:	83 c4 10             	add    $0x10,%esp
  104eef:	83 f8 03             	cmp    $0x3,%eax
  104ef2:	74 1c                	je     104f10 <PTQueueInit_test2+0xe0>
    dprintf("test 2-c failed.\n");
  104ef4:	8d 83 09 b4 ff ff    	lea    -0x4bf7(%ebx),%eax
  104efa:	83 ec 0c             	sub    $0xc,%esp
  104efd:	50                   	push   %eax
  104efe:	e8 2c d1 ff ff       	call   10202f <dprintf>
  104f03:	83 c4 10             	add    $0x10,%esp
    return 1;
  104f06:	b8 01 00 00 00       	mov    $0x1,%eax
  104f0b:	e9 79 ff ff ff       	jmp    104e89 <PTQueueInit_test2+0x59>
  if (tcb_get_prev(4) != 3 || tcb_get_next(4) != NUM_IDS) {
  104f10:	83 ec 0c             	sub    $0xc,%esp
  104f13:	6a 04                	push   $0x4
  104f15:	e8 46 fc ff ff       	call   104b60 <tcb_get_next>
  104f1a:	83 c4 10             	add    $0x10,%esp
  104f1d:	83 f8 40             	cmp    $0x40,%eax
  104f20:	75 d2                	jne    104ef4 <PTQueueInit_test2+0xc4>
  tqueue_remove(0, 3);
  104f22:	50                   	push   %eax
  104f23:	50                   	push   %eax
  104f24:	6a 03                	push   $0x3
  104f26:	6a 00                	push   $0x0
  104f28:	e8 73 fe ff ff       	call   104da0 <tqueue_remove>
  if (tcb_get_prev(2) != NUM_IDS || tcb_get_next(2) != 4) {
  104f2d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  104f34:	e8 d7 fb ff ff       	call   104b10 <tcb_get_prev>
  104f39:	83 c4 10             	add    $0x10,%esp
  104f3c:	83 f8 40             	cmp    $0x40,%eax
  104f3f:	74 1c                	je     104f5d <PTQueueInit_test2+0x12d>
    dprintf("test 2-d failed.\n");
  104f41:	8d 83 1b b4 ff ff    	lea    -0x4be5(%ebx),%eax
  104f47:	83 ec 0c             	sub    $0xc,%esp
  104f4a:	50                   	push   %eax
  104f4b:	e8 df d0 ff ff       	call   10202f <dprintf>
  104f50:	83 c4 10             	add    $0x10,%esp
    return 1;
  104f53:	b8 01 00 00 00       	mov    $0x1,%eax
  104f58:	e9 2c ff ff ff       	jmp    104e89 <PTQueueInit_test2+0x59>
  if (tcb_get_prev(2) != NUM_IDS || tcb_get_next(2) != 4) {
  104f5d:	83 ec 0c             	sub    $0xc,%esp
  104f60:	6a 02                	push   $0x2
  104f62:	e8 f9 fb ff ff       	call   104b60 <tcb_get_next>
  104f67:	83 c4 10             	add    $0x10,%esp
  104f6a:	83 f8 04             	cmp    $0x4,%eax
  104f6d:	75 d2                	jne    104f41 <PTQueueInit_test2+0x111>
  if (tcb_get_prev(3) != NUM_IDS || tcb_get_next(3) != NUM_IDS) {
  104f6f:	83 ec 0c             	sub    $0xc,%esp
  104f72:	6a 03                	push   $0x3
  104f74:	e8 97 fb ff ff       	call   104b10 <tcb_get_prev>
  104f79:	83 c4 10             	add    $0x10,%esp
  104f7c:	83 f8 40             	cmp    $0x40,%eax
  104f7f:	74 1c                	je     104f9d <PTQueueInit_test2+0x16d>
    dprintf("test 2-e failed.\n");
  104f81:	8d 83 2d b4 ff ff    	lea    -0x4bd3(%ebx),%eax
  104f87:	83 ec 0c             	sub    $0xc,%esp
  104f8a:	50                   	push   %eax
  104f8b:	e8 9f d0 ff ff       	call   10202f <dprintf>
  104f90:	83 c4 10             	add    $0x10,%esp
    return 1;
  104f93:	b8 01 00 00 00       	mov    $0x1,%eax
  104f98:	e9 ec fe ff ff       	jmp    104e89 <PTQueueInit_test2+0x59>
  if (tcb_get_prev(3) != NUM_IDS || tcb_get_next(3) != NUM_IDS) {
  104f9d:	83 ec 0c             	sub    $0xc,%esp
  104fa0:	6a 03                	push   $0x3
  104fa2:	e8 b9 fb ff ff       	call   104b60 <tcb_get_next>
  104fa7:	83 c4 10             	add    $0x10,%esp
  104faa:	83 f8 40             	cmp    $0x40,%eax
  104fad:	75 d2                	jne    104f81 <PTQueueInit_test2+0x151>
  if (tcb_get_prev(4) != 2 || tcb_get_next(4) != NUM_IDS) {
  104faf:	83 ec 0c             	sub    $0xc,%esp
  104fb2:	6a 04                	push   $0x4
  104fb4:	e8 57 fb ff ff       	call   104b10 <tcb_get_prev>
  104fb9:	83 c4 10             	add    $0x10,%esp
  104fbc:	83 f8 02             	cmp    $0x2,%eax
  104fbf:	74 1c                	je     104fdd <PTQueueInit_test2+0x1ad>
    dprintf("test 2-f failed.\n");
  104fc1:	8d 83 3f b4 ff ff    	lea    -0x4bc1(%ebx),%eax
  104fc7:	83 ec 0c             	sub    $0xc,%esp
  104fca:	50                   	push   %eax
  104fcb:	e8 5f d0 ff ff       	call   10202f <dprintf>
  104fd0:	83 c4 10             	add    $0x10,%esp
    return 1;
  104fd3:	b8 01 00 00 00       	mov    $0x1,%eax
  104fd8:	e9 ac fe ff ff       	jmp    104e89 <PTQueueInit_test2+0x59>
  if (tcb_get_prev(4) != 2 || tcb_get_next(4) != NUM_IDS) {
  104fdd:	83 ec 0c             	sub    $0xc,%esp
  104fe0:	6a 04                	push   $0x4
  104fe2:	e8 79 fb ff ff       	call   104b60 <tcb_get_next>
  104fe7:	83 c4 10             	add    $0x10,%esp
  104fea:	83 f8 40             	cmp    $0x40,%eax
  104fed:	75 d2                	jne    104fc1 <PTQueueInit_test2+0x191>
  pid = tqueue_dequeue(0);
  104fef:	83 ec 0c             	sub    $0xc,%esp
  104ff2:	6a 00                	push   $0x0
  104ff4:	e8 97 fd ff ff       	call   104d90 <tqueue_dequeue>
  if (pid != 2 || tcb_get_prev(pid) != NUM_IDS || tcb_get_next(pid) != NUM_IDS
  104ff9:	83 c4 10             	add    $0x10,%esp
  104ffc:	83 f8 02             	cmp    $0x2,%eax
  104fff:	74 1c                	je     10501d <PTQueueInit_test2+0x1ed>
    dprintf("test 2-g failed.\n");
  105001:	8d 83 51 b4 ff ff    	lea    -0x4baf(%ebx),%eax
  105007:	83 ec 0c             	sub    $0xc,%esp
  10500a:	50                   	push   %eax
  10500b:	e8 1f d0 ff ff       	call   10202f <dprintf>
  105010:	83 c4 10             	add    $0x10,%esp
    return 1;
  105013:	b8 01 00 00 00       	mov    $0x1,%eax
  105018:	e9 6c fe ff ff       	jmp    104e89 <PTQueueInit_test2+0x59>
  if (pid != 2 || tcb_get_prev(pid) != NUM_IDS || tcb_get_next(pid) != NUM_IDS
  10501d:	83 ec 0c             	sub    $0xc,%esp
  105020:	6a 02                	push   $0x2
  105022:	e8 e9 fa ff ff       	call   104b10 <tcb_get_prev>
  105027:	83 c4 10             	add    $0x10,%esp
  10502a:	83 f8 40             	cmp    $0x40,%eax
  10502d:	75 d2                	jne    105001 <PTQueueInit_test2+0x1d1>
  10502f:	83 ec 0c             	sub    $0xc,%esp
  105032:	6a 02                	push   $0x2
  105034:	e8 27 fb ff ff       	call   104b60 <tcb_get_next>
  105039:	83 c4 10             	add    $0x10,%esp
  10503c:	83 f8 40             	cmp    $0x40,%eax
  10503f:	75 c0                	jne    105001 <PTQueueInit_test2+0x1d1>
   || tqueue_get_head(0) != 4 || tqueue_get_tail(0) != 4) {
  105041:	83 ec 0c             	sub    $0xc,%esp
  105044:	6a 00                	push   $0x0
  105046:	e8 65 fc ff ff       	call   104cb0 <tqueue_get_head>
  10504b:	83 c4 10             	add    $0x10,%esp
  10504e:	83 f8 04             	cmp    $0x4,%eax
  105051:	75 ae                	jne    105001 <PTQueueInit_test2+0x1d1>
  105053:	83 ec 0c             	sub    $0xc,%esp
  105056:	6a 00                	push   $0x0
  105058:	e8 93 fc ff ff       	call   104cf0 <tqueue_get_tail>
  10505d:	83 c4 10             	add    $0x10,%esp
  105060:	83 f8 04             	cmp    $0x4,%eax
  105063:	75 9c                	jne    105001 <PTQueueInit_test2+0x1d1>
  dprintf("test 2 passed.\n");
  105065:	8d 83 d5 b3 ff ff    	lea    -0x4c2b(%ebx),%eax
  10506b:	83 ec 0c             	sub    $0xc,%esp
  10506e:	50                   	push   %eax
  10506f:	e8 bb cf ff ff       	call   10202f <dprintf>
  105074:	83 c4 10             	add    $0x10,%esp
  return 0;
  105077:	31 c0                	xor    %eax,%eax
  105079:	e9 0b fe ff ff       	jmp    104e89 <PTQueueInit_test2+0x59>
  10507e:	66 90                	xchg   %ax,%ax

00105080 <PTQueueInit_test_own>:
int PTQueueInit_test_own()
{
  // TODO (optional)
  // dprintf("own test passed.\n");
  return 0;
}
  105080:	31 c0                	xor    %eax,%eax
  105082:	c3                   	ret    
  105083:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105090 <test_PTQueueInit>:

int test_PTQueueInit()
{
  105090:	53                   	push   %ebx
  105091:	83 ec 08             	sub    $0x8,%esp
  return PTQueueInit_test1() + PTQueueInit_test2() + PTQueueInit_test_own();
  105094:	e8 17 fd ff ff       	call   104db0 <PTQueueInit_test1>
  105099:	89 c3                	mov    %eax,%ebx
  10509b:	e8 90 fd ff ff       	call   104e30 <PTQueueInit_test2>
}
  1050a0:	83 c4 08             	add    $0x8,%esp
  return PTQueueInit_test1() + PTQueueInit_test2() + PTQueueInit_test_own();
  1050a3:	01 d8                	add    %ebx,%eax
}
  1050a5:	5b                   	pop    %ebx
  1050a6:	c3                   	ret    
  1050a7:	66 90                	xchg   %ax,%ax
  1050a9:	66 90                	xchg   %ax,%ax
  1050ab:	66 90                	xchg   %ax,%ax
  1050ad:	66 90                	xchg   %ax,%ax
  1050af:	90                   	nop

001050b0 <get_curid>:
unsigned int CURID;

unsigned int get_curid(void)
{
  1050b0:	e8 0d d4 ff ff       	call   1024c2 <__x86.get_pc_thunk.ax>
  1050b5:	05 4b 5f 00 00       	add    $0x5f4b,%eax
	return CURID;
  1050ba:	c7 c0 08 fb de 00    	mov    $0xdefb08,%eax
  1050c0:	8b 00                	mov    (%eax),%eax
}
  1050c2:	c3                   	ret    
  1050c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1050c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001050d0 <set_curid>:

void set_curid(unsigned int curid)
{
  1050d0:	e8 ed d3 ff ff       	call   1024c2 <__x86.get_pc_thunk.ax>
  1050d5:	05 2b 5f 00 00       	add    $0x5f2b,%eax
	CURID = curid;
  1050da:	8b 54 24 04          	mov    0x4(%esp),%edx
  1050de:	c7 c0 08 fb de 00    	mov    $0xdefb08,%eax
  1050e4:	89 10                	mov    %edx,(%eax)
}
  1050e6:	c3                   	ret    
  1050e7:	66 90                	xchg   %ax,%ax
  1050e9:	66 90                	xchg   %ax,%ax
  1050eb:	66 90                	xchg   %ax,%ax
  1050ed:	66 90                	xchg   %ax,%ax
  1050ef:	90                   	nop

001050f0 <thread_init>:
#include <lib/thread.h>

#include "import.h"

void thread_init(void)
{
  1050f0:	53                   	push   %ebx
  1050f1:	e8 19 b2 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  1050f6:	81 c3 0a 5f 00 00    	add    $0x5f0a,%ebx
  1050fc:	83 ec 08             	sub    $0x8,%esp
	tqueue_init();
  1050ff:	e8 5c fc ff ff       	call   104d60 <tqueue_init>
	set_curid(0);
  105104:	83 ec 0c             	sub    $0xc,%esp
  105107:	6a 00                	push   $0x0
  105109:	e8 c2 ff ff ff       	call   1050d0 <set_curid>
	tcb_set_state(0, TSTATE_RUN);
  10510e:	58                   	pop    %eax
  10510f:	5a                   	pop    %edx
  105110:	6a 01                	push   $0x1
  105112:	6a 00                	push   $0x0
  105114:	e8 c7 f9 ff ff       	call   104ae0 <tcb_set_state>
}
  105119:	83 c4 18             	add    $0x18,%esp
  10511c:	5b                   	pop    %ebx
  10511d:	c3                   	ret    
  10511e:	66 90                	xchg   %ax,%ax

00105120 <thread_spawn>:
  */
unsigned int thread_spawn(void *entry, unsigned int id, unsigned int quota)
{
  // TODO
  return 0;
}
  105120:	31 c0                	xor    %eax,%eax
  105122:	c3                   	ret    
  105123:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105130 <thread_yield>:
  *          i.e. The thread at the head of the ready queue is run next.
  *  Hint 2: If you are the only thread that is ready to run,
  *          do you need to switch to yourself?
  */
void thread_yield(void)
{
  105130:	53                   	push   %ebx
  105131:	e8 d9 b1 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  105136:	81 c3 ca 5e 00 00    	add    $0x5eca,%ebx
  10513c:	83 ec 10             	sub    $0x10,%esp
  if (next != NUM_IDS) {
    // TODO
    // ...

    // This performs the switch.
    kctx_switch(curid, next);
  10513f:	6a 00                	push   $0x0
  105141:	6a 00                	push   $0x0
  105143:	e8 78 f8 ff ff       	call   1049c0 <kctx_switch>
  } 
}
  105148:	83 c4 18             	add    $0x18,%esp
  10514b:	5b                   	pop    %ebx
  10514c:	c3                   	ret    
  10514d:	66 90                	xchg   %ax,%ax
  10514f:	90                   	nop

00105150 <PThread_test1>:
#include <thread/PTCBIntro/export.h>
#include <thread/PTQueueIntro/export.h>
#include "export.h"

int PThread_test1()
{
  105150:	56                   	push   %esi
  105151:	53                   	push   %ebx
  105152:	e8 b8 b1 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  105157:	81 c3 a9 5e 00 00    	add    $0x5ea9,%ebx
  10515d:	83 ec 08             	sub    $0x8,%esp
  void * dummy_addr = (void *) 0;
  unsigned int chid = thread_spawn(dummy_addr, 0, 1000);
  105160:	68 e8 03 00 00       	push   $0x3e8
  105165:	6a 00                	push   $0x0
  105167:	6a 00                	push   $0x0
  105169:	e8 b2 ff ff ff       	call   105120 <thread_spawn>
  if (tcb_get_state(chid) != TSTATE_READY) {
  10516e:	89 04 24             	mov    %eax,(%esp)
  unsigned int chid = thread_spawn(dummy_addr, 0, 1000);
  105171:	89 c6                	mov    %eax,%esi
  if (tcb_get_state(chid) != TSTATE_READY) {
  105173:	e8 48 f9 ff ff       	call   104ac0 <tcb_get_state>
  105178:	83 c4 10             	add    $0x10,%esp
  10517b:	85 c0                	test   %eax,%eax
  10517d:	75 11                	jne    105190 <PThread_test1+0x40>
    dprintf("test 1 failed.\n");
    return 1;
  }
  if (tqueue_get_tail(NUM_IDS) != chid) {
  10517f:	83 ec 0c             	sub    $0xc,%esp
  105182:	6a 40                	push   $0x40
  105184:	e8 67 fb ff ff       	call   104cf0 <tqueue_get_tail>
  105189:	83 c4 10             	add    $0x10,%esp
  10518c:	39 f0                	cmp    %esi,%eax
  10518e:	74 20                	je     1051b0 <PThread_test1+0x60>
    dprintf("test 1 failed.\n");
  105190:	8d 83 5a b3 ff ff    	lea    -0x4ca6(%ebx),%eax
  105196:	83 ec 0c             	sub    $0xc,%esp
  105199:	50                   	push   %eax
  10519a:	e8 90 ce ff ff       	call   10202f <dprintf>
    return 1;
  10519f:	83 c4 10             	add    $0x10,%esp
  1051a2:	b8 01 00 00 00       	mov    $0x1,%eax
    dprintf("test 1 failed.\n");
    return 1;
  }
  dprintf("test 1 passed.\n");
  return 0;
}
  1051a7:	83 c4 04             	add    $0x4,%esp
  1051aa:	5b                   	pop    %ebx
  1051ab:	5e                   	pop    %esi
  1051ac:	c3                   	ret    
  1051ad:	8d 76 00             	lea    0x0(%esi),%esi
  dprintf("test 1 passed.\n");
  1051b0:	8d 83 6a b3 ff ff    	lea    -0x4c96(%ebx),%eax
  1051b6:	83 ec 0c             	sub    $0xc,%esp
  1051b9:	50                   	push   %eax
  1051ba:	e8 70 ce ff ff       	call   10202f <dprintf>
  return 0;
  1051bf:	83 c4 10             	add    $0x10,%esp
  1051c2:	31 c0                	xor    %eax,%eax
}
  1051c4:	83 c4 04             	add    $0x4,%esp
  1051c7:	5b                   	pop    %ebx
  1051c8:	5e                   	pop    %esi
  1051c9:	c3                   	ret    
  1051ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001051d0 <PThread_test_own>:
int PThread_test_own()
{
  // TODO (optional)
  // dprintf("own test passed.\n");
  return 0;
}
  1051d0:	31 c0                	xor    %eax,%eax
  1051d2:	c3                   	ret    
  1051d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1051d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001051e0 <test_PThread>:

int test_PThread()
{
  return PThread_test1() + PThread_test_own();
  1051e0:	e9 6b ff ff ff       	jmp    105150 <PThread_test1>
  1051e5:	66 90                	xchg   %ax,%ax
  1051e7:	66 90                	xchg   %ax,%ax
  1051e9:	66 90                	xchg   %ax,%ax
  1051eb:	66 90                	xchg   %ax,%ax
  1051ed:	66 90                	xchg   %ax,%ax
  1051ef:	90                   	nop

001051f0 <proc_start_user>:
  *     - User context's are stored in uctx_pool.
  */
void proc_start_user(void)
{
	// TODO
}
  1051f0:	f3 c3                	repz ret 
  1051f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1051f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105200 <proc_create>:
  *           - The entry point for the given elf [elf_addr] can be retrieved using 
  *             elf_entry() function defined in elf.c
  *   4. Return: the pid of the new thread. 
  */
unsigned int proc_create(void *elf_addr, unsigned int quota)
{
  105200:	55                   	push   %ebp
  105201:	57                   	push   %edi
  105202:	56                   	push   %esi
  105203:	53                   	push   %ebx
  105204:	e8 06 b1 ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  105209:	81 c3 f7 5d 00 00    	add    $0x5df7,%ebx
  10520f:	83 ec 0c             	sub    $0xc,%esp
  105212:	8b 6c 24 20          	mov    0x20(%esp),%ebp
	  unsigned int pid, id;

    id = get_curid();
  105216:	e8 95 fe ff ff       	call   1050b0 <get_curid>
    pid = thread_spawn((void *) proc_start_user, id, quota);
  10521b:	83 ec 04             	sub    $0x4,%esp
  10521e:	ff 74 24 28          	pushl  0x28(%esp)
  105222:	50                   	push   %eax
  105223:	8d 83 f0 a1 ff ff    	lea    -0x5e10(%ebx),%eax
  105229:	50                   	push   %eax
  10522a:	e8 f1 fe ff ff       	call   105120 <thread_spawn>
  10522f:	89 c7                	mov    %eax,%edi

	  elf_load(elf_addr, pid);
  105231:	58                   	pop    %eax
  105232:	5a                   	pop    %edx
  105233:	57                   	push   %edi
  105234:	55                   	push   %ebp

    uctx_pool[pid].es = CPU_GDT_UDATA | 3;
  105235:	6b f7 44             	imul   $0x44,%edi,%esi
	  elf_load(elf_addr, pid);
  105238:	e8 46 dc ff ff       	call   102e83 <elf_load>
    uctx_pool[pid].es = CPU_GDT_UDATA | 3;
  10523d:	81 c6 20 fb de 00    	add    $0xdefb20,%esi
    uctx_pool[pid].ds = CPU_GDT_UDATA | 3;
  105243:	b8 23 00 00 00       	mov    $0x23,%eax
    uctx_pool[pid].es = CPU_GDT_UDATA | 3;
  105248:	b9 23 00 00 00       	mov    $0x23,%ecx
    uctx_pool[pid].ds = CPU_GDT_UDATA | 3;
  10524d:	66 89 46 24          	mov    %ax,0x24(%esi)
    uctx_pool[pid].cs = CPU_GDT_UCODE | 3;
  105251:	b8 1b 00 00 00       	mov    $0x1b,%eax
    uctx_pool[pid].es = CPU_GDT_UDATA | 3;
  105256:	66 89 4e 20          	mov    %cx,0x20(%esi)
    uctx_pool[pid].cs = CPU_GDT_UCODE | 3;
  10525a:	66 89 46 34          	mov    %ax,0x34(%esi)
    uctx_pool[pid].ss = CPU_GDT_UDATA | 3;
  10525e:	b8 23 00 00 00       	mov    $0x23,%eax
    uctx_pool[pid].esp = VM_USERHI;
  105263:	c7 46 3c 00 00 00 f0 	movl   $0xf0000000,0x3c(%esi)
    uctx_pool[pid].ss = CPU_GDT_UDATA | 3;
  10526a:	66 89 46 40          	mov    %ax,0x40(%esi)
    uctx_pool[pid].eflags = FL_IF;
  10526e:	c7 46 38 00 02 00 00 	movl   $0x200,0x38(%esi)
    uctx_pool[pid].eip = elf_entry(elf_addr);
  105275:	89 2c 24             	mov    %ebp,(%esp)
  105278:	e8 e7 dd ff ff       	call   103064 <elf_entry>
  10527d:	89 46 30             	mov    %eax,0x30(%esi)

	  return pid;
}
  105280:	83 c4 1c             	add    $0x1c,%esp
  105283:	89 f8                	mov    %edi,%eax
  105285:	5b                   	pop    %ebx
  105286:	5e                   	pop    %esi
  105287:	5f                   	pop    %edi
  105288:	5d                   	pop    %ebp
  105289:	c3                   	ret    
  10528a:	66 90                	xchg   %ax,%ax
  10528c:	66 90                	xchg   %ax,%ax
  10528e:	66 90                	xchg   %ax,%ax

00105290 <syscall_get_arg1>:

unsigned int syscall_get_arg1(void)
{
  // TODO
  return 0;
}
  105290:	31 c0                	xor    %eax,%eax
  105292:	c3                   	ret    
  105293:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001052a0 <syscall_get_arg2>:
  1052a0:	31 c0                	xor    %eax,%eax
  1052a2:	c3                   	ret    
  1052a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1052a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001052b0 <syscall_get_arg3>:
  1052b0:	31 c0                	xor    %eax,%eax
  1052b2:	c3                   	ret    
  1052b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1052b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001052c0 <syscall_get_arg4>:
  1052c0:	31 c0                	xor    %eax,%eax
  1052c2:	c3                   	ret    
  1052c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1052c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001052d0 <syscall_get_arg5>:
  1052d0:	31 c0                	xor    %eax,%eax
  1052d2:	c3                   	ret    
  1052d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1052d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001052e0 <syscall_get_arg6>:
  1052e0:	31 c0                	xor    %eax,%eax
  1052e2:	c3                   	ret    
  1052e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1052e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001052f0 <syscall_set_errno>:
  *  - Set the err field of uctx_pool to errno.
  */
void syscall_set_errno(unsigned int errno)
{
  // TODO
}
  1052f0:	f3 c3                	repz ret 
  1052f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1052f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105300 <syscall_set_retval1>:
  105300:	f3 c3                	repz ret 
  105302:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105310 <syscall_set_retval2>:
  105310:	f3 c3                	repz ret 
  105312:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105320 <syscall_set_retval3>:
  105320:	f3 c3                	repz ret 
  105322:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105330 <syscall_set_retval4>:
  105330:	f3 c3                	repz ret 
  105332:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105340 <syscall_set_retval5>:
  105340:	f3 c3                	repz ret 
  105342:	66 90                	xchg   %ax,%ax
  105344:	66 90                	xchg   %ax,%ax
  105346:	66 90                	xchg   %ax,%ax
  105348:	66 90                	xchg   %ax,%ax
  10534a:	66 90                	xchg   %ax,%ax
  10534c:	66 90                	xchg   %ax,%ax
  10534e:	66 90                	xchg   %ax,%ax

00105350 <sys_puts>:
/**
 * Copies a string from user into buffer and prints it to the screen.
 * This is called by the user level "printf" library as a system call.
 */
void sys_puts(void)
{
  105350:	55                   	push   %ebp
  105351:	57                   	push   %edi
  105352:	56                   	push   %esi
  105353:	53                   	push   %ebx
  105354:	e8 b6 af ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  105359:	81 c3 a7 5c 00 00    	add    $0x5ca7,%ebx
  10535f:	83 ec 1c             	sub    $0x1c,%esp
	unsigned int cur_pid;
	unsigned int str_uva, str_len;
	unsigned int remain, cur_pos, nbytes;

	cur_pid = get_curid();
  105362:	e8 49 fd ff ff       	call   1050b0 <get_curid>
  105367:	89 c7                	mov    %eax,%edi
  105369:	89 44 24 04          	mov    %eax,0x4(%esp)
	str_uva = syscall_get_arg2();
  10536d:	e8 2e ff ff ff       	call   1052a0 <syscall_get_arg2>
  105372:	89 c6                	mov    %eax,%esi
	str_len = syscall_get_arg3();
  105374:	e8 37 ff ff ff       	call   1052b0 <syscall_get_arg3>

	if (!(VM_USERLO <= str_uva && str_uva + str_len <= VM_USERHI)) {
  105379:	81 fe ff ff ff 3f    	cmp    $0x3fffffff,%esi
  10537f:	0f 86 ab 00 00 00    	jbe    105430 <sys_puts+0xe0>
  105385:	89 c5                	mov    %eax,%ebp
  105387:	8d 04 06             	lea    (%esi,%eax,1),%eax
  10538a:	3d 00 00 00 f0       	cmp    $0xf0000000,%eax
  10538f:	0f 87 9b 00 00 00    	ja     105430 <sys_puts+0xe0>
			nbytes = remain;
		else
			nbytes = PAGESIZE - 1;

		if (pt_copyin(cur_pid,
			      cur_pos, sys_buf[cur_pid], nbytes) != nbytes) {
  105395:	8d 83 60 e4 01 00    	lea    0x1e460(%ebx),%eax
  10539b:	c1 e7 0c             	shl    $0xc,%edi
  10539e:	01 c7                	add    %eax,%edi
	while (remain) {
  1053a0:	85 ed                	test   %ebp,%ebp
			      cur_pos, sys_buf[cur_pid], nbytes) != nbytes) {
  1053a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
			syscall_set_errno(E_MEM);
			return;
		}

		sys_buf[cur_pid][nbytes] = '\0';
  1053a6:	89 7c 24 08          	mov    %edi,0x8(%esp)
	while (remain) {
  1053aa:	75 52                	jne    1053fe <sys_puts+0xae>
  1053ac:	e9 bc 00 00 00       	jmp    10546d <sys_puts+0x11d>
  1053b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		if (pt_copyin(cur_pid,
  1053b8:	68 ff 0f 00 00       	push   $0xfff
  1053bd:	57                   	push   %edi
  1053be:	56                   	push   %esi
  1053bf:	ff 74 24 10          	pushl  0x10(%esp)
  1053c3:	e8 2b d8 ff ff       	call   102bf3 <pt_copyin>
  1053c8:	83 c4 10             	add    $0x10,%esp
  1053cb:	3d ff 0f 00 00       	cmp    $0xfff,%eax
  1053d0:	75 47                	jne    105419 <sys_puts+0xc9>
		sys_buf[cur_pid][nbytes] = '\0';
  1053d2:	8b 44 24 08          	mov    0x8(%esp),%eax
		KERN_INFO("%s", sys_buf[cur_pid]);
  1053d6:	83 ec 08             	sub    $0x8,%esp

		remain -= nbytes;
		cur_pos += nbytes;
  1053d9:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
		sys_buf[cur_pid][nbytes] = '\0';
  1053df:	c6 80 ff 0f 00 00 00 	movb   $0x0,0xfff(%eax)
		KERN_INFO("%s", sys_buf[cur_pid]);
  1053e6:	8d 83 ae aa ff ff    	lea    -0x5552(%ebx),%eax
  1053ec:	57                   	push   %edi
  1053ed:	50                   	push   %eax
  1053ee:	e8 4b ca ff ff       	call   101e3e <debug_info>
	while (remain) {
  1053f3:	83 c4 10             	add    $0x10,%esp
  1053f6:	81 ed ff 0f 00 00    	sub    $0xfff,%ebp
  1053fc:	74 6f                	je     10546d <sys_puts+0x11d>
		if (remain < PAGESIZE - 1)
  1053fe:	81 fd fe 0f 00 00    	cmp    $0xffe,%ebp
  105404:	77 b2                	ja     1053b8 <sys_puts+0x68>
		if (pt_copyin(cur_pid,
  105406:	55                   	push   %ebp
  105407:	57                   	push   %edi
  105408:	56                   	push   %esi
  105409:	ff 74 24 10          	pushl  0x10(%esp)
  10540d:	e8 e1 d7 ff ff       	call   102bf3 <pt_copyin>
  105412:	83 c4 10             	add    $0x10,%esp
  105415:	39 c5                	cmp    %eax,%ebp
  105417:	74 2f                	je     105448 <sys_puts+0xf8>
			syscall_set_errno(E_MEM);
  105419:	83 ec 0c             	sub    $0xc,%esp
  10541c:	6a 01                	push   $0x1
  10541e:	e8 cd fe ff ff       	call   1052f0 <syscall_set_errno>
			return;
  105423:	83 c4 10             	add    $0x10,%esp
	}

	syscall_set_errno(E_SUCC);
}
  105426:	83 c4 1c             	add    $0x1c,%esp
  105429:	5b                   	pop    %ebx
  10542a:	5e                   	pop    %esi
  10542b:	5f                   	pop    %edi
  10542c:	5d                   	pop    %ebp
  10542d:	c3                   	ret    
  10542e:	66 90                	xchg   %ax,%ax
		syscall_set_errno(E_INVAL_ADDR);
  105430:	83 ec 0c             	sub    $0xc,%esp
  105433:	6a 04                	push   $0x4
  105435:	e8 b6 fe ff ff       	call   1052f0 <syscall_set_errno>
		return;
  10543a:	83 c4 10             	add    $0x10,%esp
}
  10543d:	83 c4 1c             	add    $0x1c,%esp
  105440:	5b                   	pop    %ebx
  105441:	5e                   	pop    %esi
  105442:	5f                   	pop    %edi
  105443:	5d                   	pop    %ebp
  105444:	c3                   	ret    
  105445:	8d 76 00             	lea    0x0(%esi),%esi
		sys_buf[cur_pid][nbytes] = '\0';
  105448:	8b 44 24 04          	mov    0x4(%esp),%eax
		KERN_INFO("%s", sys_buf[cur_pid]);
  10544c:	83 ec 08             	sub    $0x8,%esp
		sys_buf[cur_pid][nbytes] = '\0';
  10544f:	c1 e0 0c             	shl    $0xc,%eax
  105452:	8d 14 28             	lea    (%eax,%ebp,1),%edx
  105455:	8b 44 24 14          	mov    0x14(%esp),%eax
  105459:	c6 04 10 00          	movb   $0x0,(%eax,%edx,1)
		KERN_INFO("%s", sys_buf[cur_pid]);
  10545d:	8d 83 ae aa ff ff    	lea    -0x5552(%ebx),%eax
  105463:	57                   	push   %edi
  105464:	50                   	push   %eax
  105465:	e8 d4 c9 ff ff       	call   101e3e <debug_info>
  10546a:	83 c4 10             	add    $0x10,%esp
	syscall_set_errno(E_SUCC);
  10546d:	83 ec 0c             	sub    $0xc,%esp
  105470:	6a 00                	push   $0x0
  105472:	e8 79 fe ff ff       	call   1052f0 <syscall_set_errno>
  105477:	83 c4 10             	add    $0x10,%esp
  10547a:	eb c1                	jmp    10543d <sys_puts+0xed>
  10547c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105480 <sys_spawn>:
  *  - If successful, retval1 = pid (return value of proc_create()) else NUM_IDS
  */
void sys_spawn(void)
{
  // TODO
}
  105480:	f3 c3                	repz ret 
  105482:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105490 <sys_yield>:
  105490:	f3 c3                	repz ret 
  105492:	66 90                	xchg   %ax,%ax
  105494:	66 90                	xchg   %ax,%ax
  105496:	66 90                	xchg   %ax,%ax
  105498:	66 90                	xchg   %ax,%ax
  10549a:	66 90                	xchg   %ax,%ax
  10549c:	66 90                	xchg   %ax,%ax
  10549e:	66 90                	xchg   %ax,%ax

001054a0 <syscall_dispatch>:
  *   
  */
void syscall_dispatch(void)
{
	// TODO
}
  1054a0:	f3 c3                	repz ret 
  1054a2:	66 90                	xchg   %ax,%ax
  1054a4:	66 90                	xchg   %ax,%ax
  1054a6:	66 90                	xchg   %ax,%ax
  1054a8:	66 90                	xchg   %ax,%ax
  1054aa:	66 90                	xchg   %ax,%ax
  1054ac:	66 90                	xchg   %ax,%ax
  1054ae:	66 90                	xchg   %ax,%ax

001054b0 <default_exception_handler>:
	KERN_DEBUG("\t%08x:\tesp:   \t\t%08x\n", &tf->esp, tf->esp);
	KERN_DEBUG("\t%08x:\tss:    \t\t%08x\n", &tf->ss, tf->ss);
}

void default_exception_handler(void)
{
  1054b0:	55                   	push   %ebp
  1054b1:	57                   	push   %edi
  1054b2:	56                   	push   %esi
  1054b3:	53                   	push   %ebx
  1054b4:	e8 56 ae ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  1054b9:	81 c3 47 5b 00 00    	add    $0x5b47,%ebx
  1054bf:	83 ec 1c             	sub    $0x1c,%esp
	unsigned int cur_pid;

	cur_pid = get_curid();
  1054c2:	e8 e9 fb ff ff       	call   1050b0 <get_curid>
  1054c7:	6b e8 44             	imul   $0x44,%eax,%ebp
	trap_dump(&uctx_pool[cur_pid]);
  1054ca:	c7 c0 20 fb de 00    	mov    $0xdefb20,%eax
	KERN_DEBUG("trapframe at %x\n", base);
  1054d0:	8d bb e8 b5 ff ff    	lea    -0x4a18(%ebx),%edi
	trap_dump(&uctx_pool[cur_pid]);
  1054d6:	8d 74 05 00          	lea    0x0(%ebp,%eax,1),%esi
  1054da:	89 44 24 08          	mov    %eax,0x8(%esp)
	KERN_DEBUG("trapframe at %x\n", base);
  1054de:	8d 83 63 b4 ff ff    	lea    -0x4b9d(%ebx),%eax
  1054e4:	56                   	push   %esi
  1054e5:	50                   	push   %eax
  1054e6:	6a 15                	push   $0x15
  1054e8:	57                   	push   %edi
  1054e9:	e8 75 c9 ff ff       	call   101e63 <debug_normal>
	KERN_DEBUG("\t%08x:\tedi:   \t\t%08x\n", &tf->regs.edi, tf->regs.edi);
  1054ee:	58                   	pop    %eax
  1054ef:	8d 83 74 b4 ff ff    	lea    -0x4b8c(%ebx),%eax
  1054f5:	ff 36                	pushl  (%esi)
  1054f7:	56                   	push   %esi
  1054f8:	50                   	push   %eax
  1054f9:	6a 16                	push   $0x16
  1054fb:	57                   	push   %edi
  1054fc:	e8 62 c9 ff ff       	call   101e63 <debug_normal>
	KERN_DEBUG("\t%08x:\tesi:   \t\t%08x\n", &tf->regs.esi, tf->regs.esi);
  105501:	83 c4 14             	add    $0x14,%esp
  105504:	ff 76 04             	pushl  0x4(%esi)
  105507:	8b 44 24 18          	mov    0x18(%esp),%eax
  10550b:	8d 44 05 04          	lea    0x4(%ebp,%eax,1),%eax
  10550f:	50                   	push   %eax
  105510:	8d 83 8a b4 ff ff    	lea    -0x4b76(%ebx),%eax
  105516:	50                   	push   %eax
  105517:	6a 17                	push   $0x17
  105519:	57                   	push   %edi
  10551a:	e8 44 c9 ff ff       	call   101e63 <debug_normal>
	KERN_DEBUG("\t%08x:\tebp:   \t\t%08x\n", &tf->regs.ebp, tf->regs.ebp);
  10551f:	83 c4 14             	add    $0x14,%esp
  105522:	ff 76 08             	pushl  0x8(%esi)
  105525:	8b 44 24 18          	mov    0x18(%esp),%eax
  105529:	8d 44 05 08          	lea    0x8(%ebp,%eax,1),%eax
  10552d:	50                   	push   %eax
  10552e:	8d 83 a0 b4 ff ff    	lea    -0x4b60(%ebx),%eax
  105534:	50                   	push   %eax
  105535:	6a 18                	push   $0x18
  105537:	57                   	push   %edi
  105538:	e8 26 c9 ff ff       	call   101e63 <debug_normal>
	KERN_DEBUG("\t%08x:\tesp:   \t\t%08x\n", &tf->regs.oesp, tf->regs.oesp);
  10553d:	83 c4 14             	add    $0x14,%esp
  105540:	ff 76 0c             	pushl  0xc(%esi)
  105543:	8b 44 24 18          	mov    0x18(%esp),%eax
  105547:	8d 44 05 0c          	lea    0xc(%ebp,%eax,1),%eax
  10554b:	50                   	push   %eax
  10554c:	8d 83 b6 b4 ff ff    	lea    -0x4b4a(%ebx),%eax
  105552:	50                   	push   %eax
  105553:	89 44 24 24          	mov    %eax,0x24(%esp)
  105557:	6a 19                	push   $0x19
  105559:	57                   	push   %edi
  10555a:	e8 04 c9 ff ff       	call   101e63 <debug_normal>
	KERN_DEBUG("\t%08x:\tebx:   \t\t%08x\n", &tf->regs.ebx, tf->regs.ebx);
  10555f:	83 c4 14             	add    $0x14,%esp
  105562:	ff 76 10             	pushl  0x10(%esi)
  105565:	8b 44 24 18          	mov    0x18(%esp),%eax
  105569:	8d 54 05 10          	lea    0x10(%ebp,%eax,1),%edx
  10556d:	52                   	push   %edx
  10556e:	8d 93 cc b4 ff ff    	lea    -0x4b34(%ebx),%edx
  105574:	52                   	push   %edx
  105575:	6a 1a                	push   $0x1a
  105577:	57                   	push   %edi
  105578:	e8 e6 c8 ff ff       	call   101e63 <debug_normal>
	KERN_DEBUG("\t%08x:\tedx:   \t\t%08x\n", &tf->regs.edx, tf->regs.edx);
  10557d:	83 c4 14             	add    $0x14,%esp
  105580:	ff 76 14             	pushl  0x14(%esi)
  105583:	8b 44 24 18          	mov    0x18(%esp),%eax
  105587:	8d 54 05 14          	lea    0x14(%ebp,%eax,1),%edx
  10558b:	52                   	push   %edx
  10558c:	8d 93 e2 b4 ff ff    	lea    -0x4b1e(%ebx),%edx
  105592:	52                   	push   %edx
  105593:	6a 1b                	push   $0x1b
  105595:	57                   	push   %edi
  105596:	e8 c8 c8 ff ff       	call   101e63 <debug_normal>
	KERN_DEBUG("\t%08x:\tecx:   \t\t%08x\n", &tf->regs.ecx, tf->regs.ecx);
  10559b:	83 c4 14             	add    $0x14,%esp
  10559e:	ff 76 18             	pushl  0x18(%esi)
  1055a1:	8b 44 24 18          	mov    0x18(%esp),%eax
  1055a5:	8d 54 05 18          	lea    0x18(%ebp,%eax,1),%edx
  1055a9:	52                   	push   %edx
  1055aa:	8d 93 f8 b4 ff ff    	lea    -0x4b08(%ebx),%edx
  1055b0:	52                   	push   %edx
  1055b1:	6a 1c                	push   $0x1c
  1055b3:	57                   	push   %edi
  1055b4:	e8 aa c8 ff ff       	call   101e63 <debug_normal>
	KERN_DEBUG("\t%08x:\teax:   \t\t%08x\n", &tf->regs.eax, tf->regs.eax);
  1055b9:	83 c4 14             	add    $0x14,%esp
  1055bc:	ff 76 1c             	pushl  0x1c(%esi)
  1055bf:	8b 44 24 18          	mov    0x18(%esp),%eax
  1055c3:	8d 54 05 1c          	lea    0x1c(%ebp,%eax,1),%edx
  1055c7:	52                   	push   %edx
  1055c8:	8d 93 0e b5 ff ff    	lea    -0x4af2(%ebx),%edx
  1055ce:	52                   	push   %edx
  1055cf:	6a 1d                	push   $0x1d
  1055d1:	57                   	push   %edi
  1055d2:	e8 8c c8 ff ff       	call   101e63 <debug_normal>
	KERN_DEBUG("\t%08x:\tes:    \t\t%08x\n", &tf->es, tf->es);
  1055d7:	0f b7 56 20          	movzwl 0x20(%esi),%edx
  1055db:	83 c4 14             	add    $0x14,%esp
  1055de:	52                   	push   %edx
  1055df:	8b 44 24 18          	mov    0x18(%esp),%eax
  1055e3:	8d 54 05 20          	lea    0x20(%ebp,%eax,1),%edx
  1055e7:	52                   	push   %edx
  1055e8:	8d 93 24 b5 ff ff    	lea    -0x4adc(%ebx),%edx
  1055ee:	52                   	push   %edx
  1055ef:	6a 1e                	push   $0x1e
  1055f1:	57                   	push   %edi
  1055f2:	e8 6c c8 ff ff       	call   101e63 <debug_normal>
	KERN_DEBUG("\t%08x:\tds:    \t\t%08x\n", &tf->ds, tf->ds);
  1055f7:	0f b7 56 24          	movzwl 0x24(%esi),%edx
  1055fb:	83 c4 14             	add    $0x14,%esp
  1055fe:	52                   	push   %edx
  1055ff:	8b 44 24 18          	mov    0x18(%esp),%eax
  105603:	8d 54 05 24          	lea    0x24(%ebp,%eax,1),%edx
  105607:	52                   	push   %edx
  105608:	8d 93 3a b5 ff ff    	lea    -0x4ac6(%ebx),%edx
  10560e:	52                   	push   %edx
  10560f:	6a 1f                	push   $0x1f
  105611:	57                   	push   %edi
  105612:	e8 4c c8 ff ff       	call   101e63 <debug_normal>
	KERN_DEBUG("\t%08x:\ttrapno:\t\t%08x\n", &tf->trapno, tf->trapno);
  105617:	83 c4 14             	add    $0x14,%esp
  10561a:	ff 76 28             	pushl  0x28(%esi)
  10561d:	8b 44 24 18          	mov    0x18(%esp),%eax
  105621:	8d 54 05 28          	lea    0x28(%ebp,%eax,1),%edx
  105625:	52                   	push   %edx
  105626:	8d 93 50 b5 ff ff    	lea    -0x4ab0(%ebx),%edx
  10562c:	52                   	push   %edx
  10562d:	6a 20                	push   $0x20
  10562f:	57                   	push   %edi
  105630:	e8 2e c8 ff ff       	call   101e63 <debug_normal>
	KERN_DEBUG("\t%08x:\terr:   \t\t%08x\n", &tf->err, tf->err);
  105635:	83 c4 14             	add    $0x14,%esp
  105638:	ff 76 2c             	pushl  0x2c(%esi)
  10563b:	8b 44 24 18          	mov    0x18(%esp),%eax
  10563f:	8d 54 05 2c          	lea    0x2c(%ebp,%eax,1),%edx
  105643:	52                   	push   %edx
  105644:	8d 93 66 b5 ff ff    	lea    -0x4a9a(%ebx),%edx
  10564a:	52                   	push   %edx
  10564b:	6a 21                	push   $0x21
  10564d:	57                   	push   %edi
  10564e:	e8 10 c8 ff ff       	call   101e63 <debug_normal>
	KERN_DEBUG("\t%08x:\teip:   \t\t%08x\n", &tf->eip, tf->eip);
  105653:	83 c4 14             	add    $0x14,%esp
  105656:	ff 76 30             	pushl  0x30(%esi)
  105659:	8b 44 24 18          	mov    0x18(%esp),%eax
  10565d:	8d 54 05 30          	lea    0x30(%ebp,%eax,1),%edx
  105661:	52                   	push   %edx
  105662:	8d 93 7c b5 ff ff    	lea    -0x4a84(%ebx),%edx
  105668:	52                   	push   %edx
  105669:	6a 22                	push   $0x22
  10566b:	57                   	push   %edi
  10566c:	e8 f2 c7 ff ff       	call   101e63 <debug_normal>
	KERN_DEBUG("\t%08x:\tcs:    \t\t%08x\n", &tf->cs, tf->cs);
  105671:	0f b7 56 34          	movzwl 0x34(%esi),%edx
  105675:	83 c4 14             	add    $0x14,%esp
  105678:	52                   	push   %edx
  105679:	8b 44 24 18          	mov    0x18(%esp),%eax
  10567d:	8d 54 05 34          	lea    0x34(%ebp,%eax,1),%edx
  105681:	52                   	push   %edx
  105682:	8d 93 92 b5 ff ff    	lea    -0x4a6e(%ebx),%edx
  105688:	52                   	push   %edx
  105689:	6a 23                	push   $0x23
  10568b:	57                   	push   %edi
  10568c:	e8 d2 c7 ff ff       	call   101e63 <debug_normal>
	KERN_DEBUG("\t%08x:\teflags:\t\t%08x\n", &tf->eflags, tf->eflags);
  105691:	83 c4 14             	add    $0x14,%esp
  105694:	ff 76 38             	pushl  0x38(%esi)
  105697:	8b 44 24 18          	mov    0x18(%esp),%eax
  10569b:	8d 54 05 38          	lea    0x38(%ebp,%eax,1),%edx
  10569f:	52                   	push   %edx
  1056a0:	8d 93 a8 b5 ff ff    	lea    -0x4a58(%ebx),%edx
  1056a6:	52                   	push   %edx
  1056a7:	6a 24                	push   $0x24
  1056a9:	57                   	push   %edi
  1056aa:	e8 b4 c7 ff ff       	call   101e63 <debug_normal>
	KERN_DEBUG("\t%08x:\tesp:   \t\t%08x\n", &tf->esp, tf->esp);
  1056af:	83 c4 14             	add    $0x14,%esp
  1056b2:	ff 76 3c             	pushl  0x3c(%esi)
  1056b5:	8b 44 24 18          	mov    0x18(%esp),%eax
  1056b9:	8d 54 05 3c          	lea    0x3c(%ebp,%eax,1),%edx
  1056bd:	52                   	push   %edx
  1056be:	8b 44 24 20          	mov    0x20(%esp),%eax
  1056c2:	50                   	push   %eax
  1056c3:	6a 25                	push   $0x25
  1056c5:	57                   	push   %edi
  1056c6:	e8 98 c7 ff ff       	call   101e63 <debug_normal>
	KERN_DEBUG("\t%08x:\tss:    \t\t%08x\n", &tf->ss, tf->ss);
  1056cb:	0f b7 46 40          	movzwl 0x40(%esi),%eax
  1056cf:	83 c4 14             	add    $0x14,%esp
  1056d2:	50                   	push   %eax
  1056d3:	8b 44 24 18          	mov    0x18(%esp),%eax
  1056d7:	8d 44 05 40          	lea    0x40(%ebp,%eax,1),%eax
  1056db:	50                   	push   %eax
  1056dc:	8d 83 be b5 ff ff    	lea    -0x4a42(%ebx),%eax
  1056e2:	50                   	push   %eax
  1056e3:	6a 26                	push   $0x26
  1056e5:	57                   	push   %edi
  1056e6:	e8 78 c7 ff ff       	call   101e63 <debug_normal>

	KERN_PANIC("Trap %d @ 0x%08x.\n", uctx_pool[cur_pid].trapno, uctx_pool[cur_pid].eip);
  1056eb:	8d 83 d4 b5 ff ff    	lea    -0x4a2c(%ebx),%eax
  1056f1:	83 c4 14             	add    $0x14,%esp
  1056f4:	ff 76 30             	pushl  0x30(%esi)
  1056f7:	ff 76 28             	pushl  0x28(%esi)
  1056fa:	50                   	push   %eax
  1056fb:	6a 30                	push   $0x30
  1056fd:	57                   	push   %edi
  1056fe:	e8 99 c7 ff ff       	call   101e9c <debug_panic>
}
  105703:	83 c4 3c             	add    $0x3c,%esp
  105706:	5b                   	pop    %ebx
  105707:	5e                   	pop    %esi
  105708:	5f                   	pop    %edi
  105709:	5d                   	pop    %ebp
  10570a:	c3                   	ret    
  10570b:	90                   	nop
  10570c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105710 <pgflt_handler>:

void pgflt_handler(void)
{
  105710:	55                   	push   %ebp
  105711:	57                   	push   %edi
  105712:	56                   	push   %esi
  105713:	53                   	push   %ebx
  105714:	e8 f6 ab ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  105719:	81 c3 e7 58 00 00    	add    $0x58e7,%ebx
  10571f:	83 ec 0c             	sub    $0xc,%esp
	unsigned int cur_pid;
	unsigned int errno;
	unsigned int fault_va;
	unsigned int pte_entry;

	cur_pid = get_curid();
  105722:	e8 89 f9 ff ff       	call   1050b0 <get_curid>
  105727:	89 c7                	mov    %eax,%edi
	errno = uctx_pool[cur_pid].err;
  105729:	6b c0 44             	imul   $0x44,%eax,%eax
  10572c:	81 c0 20 fb de 00    	add    $0xdefb20,%eax
  105732:	8b 70 2c             	mov    0x2c(%eax),%esi
	fault_va = rcr2();
  105735:	e8 2f d1 ff ff       	call   102869 <rcr2>
  10573a:	89 c5                	mov    %eax,%ebp
	 */

  //Uncomment this line if you need to see the information of the sequence of page faults occured.
	//KERN_DEBUG("Page fault: VA 0x%08x, errno 0x%08x, process %d, EIP 0x%08x.\n", fault_va, errno, cur_pid, uctx_pool[cur_pid].eip);

	if (errno & PFE_PR) {
  10573c:	f7 c6 01 00 00 00    	test   $0x1,%esi
  105742:	75 24                	jne    105768 <pgflt_handler+0x58>
		KERN_PANIC("Permission denied: va = 0x%08x, errno = 0x%08x.\n", fault_va, errno);
		return;
	}

	if (alloc_page(cur_pid, fault_va, PTE_W | PTE_U | PTE_P) == MagicNumber)
  105744:	83 ec 04             	sub    $0x4,%esp
  105747:	6a 07                	push   $0x7
  105749:	50                   	push   %eax
  10574a:	57                   	push   %edi
  10574b:	e8 b0 f0 ff ff       	call   104800 <alloc_page>
  105750:	83 c4 10             	add    $0x10,%esp
  105753:	3d 01 00 10 00       	cmp    $0x100001,%eax
  105758:	74 36                	je     105790 <pgflt_handler+0x80>
    KERN_PANIC("Page allocation failed: va = 0x%08x, errno = 0x%08x.\n", fault_va, errno);

}
  10575a:	83 c4 0c             	add    $0xc,%esp
  10575d:	5b                   	pop    %ebx
  10575e:	5e                   	pop    %esi
  10575f:	5f                   	pop    %edi
  105760:	5d                   	pop    %ebp
  105761:	c3                   	ret    
  105762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		KERN_PANIC("Permission denied: va = 0x%08x, errno = 0x%08x.\n", fault_va, errno);
  105768:	83 ec 0c             	sub    $0xc,%esp
  10576b:	56                   	push   %esi
  10576c:	50                   	push   %eax
  10576d:	8d 83 10 b6 ff ff    	lea    -0x49f0(%ebx),%eax
  105773:	50                   	push   %eax
  105774:	8d 83 e8 b5 ff ff    	lea    -0x4a18(%ebx),%eax
  10577a:	6a 47                	push   $0x47
  10577c:	50                   	push   %eax
  10577d:	e8 1a c7 ff ff       	call   101e9c <debug_panic>
		return;
  105782:	83 c4 20             	add    $0x20,%esp
}
  105785:	83 c4 0c             	add    $0xc,%esp
  105788:	5b                   	pop    %ebx
  105789:	5e                   	pop    %esi
  10578a:	5f                   	pop    %edi
  10578b:	5d                   	pop    %ebp
  10578c:	c3                   	ret    
  10578d:	8d 76 00             	lea    0x0(%esi),%esi
    KERN_PANIC("Page allocation failed: va = 0x%08x, errno = 0x%08x.\n", fault_va, errno);
  105790:	8d 83 44 b6 ff ff    	lea    -0x49bc(%ebx),%eax
  105796:	83 ec 0c             	sub    $0xc,%esp
  105799:	56                   	push   %esi
  10579a:	55                   	push   %ebp
  10579b:	50                   	push   %eax
  10579c:	8d 83 e8 b5 ff ff    	lea    -0x4a18(%ebx),%eax
  1057a2:	6a 4c                	push   $0x4c
  1057a4:	50                   	push   %eax
  1057a5:	e8 f2 c6 ff ff       	call   101e9c <debug_panic>
  1057aa:	83 c4 20             	add    $0x20,%esp
}
  1057ad:	83 c4 0c             	add    $0xc,%esp
  1057b0:	5b                   	pop    %ebx
  1057b1:	5e                   	pop    %esi
  1057b2:	5f                   	pop    %edi
  1057b3:	5d                   	pop    %ebp
  1057b4:	c3                   	ret    
  1057b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1057b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001057c0 <exception_handler>:

void exception_handler(void)
{
  1057c0:	53                   	push   %ebx
  1057c1:	e8 49 ab ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  1057c6:	81 c3 3a 58 00 00    	add    $0x583a,%ebx
  1057cc:	83 ec 08             	sub    $0x8,%esp
    unsigned int curid, syscall_num; 
  
    curid = get_curid();
  1057cf:	e8 dc f8 ff ff       	call   1050b0 <get_curid>
    syscall_num = uctx_pool[curid].trapno;
  1057d4:	6b c0 44             	imul   $0x44,%eax,%eax
  1057d7:	81 c0 20 fb de 00    	add    $0xdefb20,%eax
  
    switch (syscall_num) {
  1057dd:	83 78 28 0e          	cmpl   $0xe,0x28(%eax)
  1057e1:	74 0d                	je     1057f0 <exception_handler+0x30>
        break;
  
      default: 
        default_exception_handler();
   }
}
  1057e3:	83 c4 08             	add    $0x8,%esp
  1057e6:	5b                   	pop    %ebx
        default_exception_handler();
  1057e7:	e9 c4 fc ff ff       	jmp    1054b0 <default_exception_handler>
  1057ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
  1057f0:	83 c4 08             	add    $0x8,%esp
  1057f3:	5b                   	pop    %ebx
        pgflt_handler();
  1057f4:	e9 17 ff ff ff       	jmp    105710 <pgflt_handler>
  1057f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00105800 <interrupt_handler>:
    intr_eoi ();
    return 0;
}

void interrupt_handler (void)
{
  105800:	53                   	push   %ebx
  105801:	e8 09 ab ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  105806:	81 c3 fa 57 00 00    	add    $0x57fa,%ebx
  10580c:	83 ec 08             	sub    $0x8,%esp
    unsigned int curid, intr;
  
    curid = get_curid();
  10580f:	e8 9c f8 ff ff       	call   1050b0 <get_curid>
    intr = uctx_pool[curid].trapno;
  105814:	6b c0 44             	imul   $0x44,%eax,%eax
  105817:	81 c0 20 fb de 00    	add    $0xdefb20,%eax
  
    // dprintf("interrupt handler: intr = %d", intr);
  
    switch (intr) {
  10581d:	83 78 28 27          	cmpl   $0x27,0x28(%eax)
  105821:	74 05                	je     105828 <interrupt_handler+0x28>
    intr_eoi ();
  105823:	e8 8f b9 ff ff       	call   1011b7 <intr_eoi>
        break;
  
      default:
        default_intr_handler();
  }
}
  105828:	83 c4 08             	add    $0x8,%esp
  10582b:	5b                   	pop    %ebx
  10582c:	c3                   	ret    
  10582d:	8d 76 00             	lea    0x0(%esi),%esi

00105830 <trap>:
  * 
  *  Hint: 
  *  - Please look at _alltraps functions in idt.S
  */
void trap (tf_t *tf)
{
  105830:	53                   	push   %ebx
  105831:	e8 d9 aa ff ff       	call   10030f <__x86.get_pc_thunk.bx>
  105836:	81 c3 ca 57 00 00    	add    $0x57ca,%ebx
  10583c:	83 ec 08             	sub    $0x8,%esp
    // TODO

	  // Trap handled: call proc_start_user() to initiate return from trap.
    proc_start_user (); 
  10583f:	e8 ac f9 ff ff       	call   1051f0 <proc_start_user>
}
  105844:	83 c4 08             	add    $0x8,%esp
  105847:	5b                   	pop    %ebx
  105848:	c3                   	ret    
  105849:	66 90                	xchg   %ax,%ax
  10584b:	66 90                	xchg   %ax,%ax
  10584d:	66 90                	xchg   %ax,%ax
  10584f:	90                   	nop

00105850 <__udivdi3>:
  105850:	55                   	push   %ebp
  105851:	57                   	push   %edi
  105852:	56                   	push   %esi
  105853:	53                   	push   %ebx
  105854:	83 ec 1c             	sub    $0x1c,%esp
  105857:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  10585b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  10585f:	8b 74 24 34          	mov    0x34(%esp),%esi
  105863:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  105867:	85 d2                	test   %edx,%edx
  105869:	75 35                	jne    1058a0 <__udivdi3+0x50>
  10586b:	39 f3                	cmp    %esi,%ebx
  10586d:	0f 87 bd 00 00 00    	ja     105930 <__udivdi3+0xe0>
  105873:	85 db                	test   %ebx,%ebx
  105875:	89 d9                	mov    %ebx,%ecx
  105877:	75 0b                	jne    105884 <__udivdi3+0x34>
  105879:	b8 01 00 00 00       	mov    $0x1,%eax
  10587e:	31 d2                	xor    %edx,%edx
  105880:	f7 f3                	div    %ebx
  105882:	89 c1                	mov    %eax,%ecx
  105884:	31 d2                	xor    %edx,%edx
  105886:	89 f0                	mov    %esi,%eax
  105888:	f7 f1                	div    %ecx
  10588a:	89 c6                	mov    %eax,%esi
  10588c:	89 e8                	mov    %ebp,%eax
  10588e:	89 f7                	mov    %esi,%edi
  105890:	f7 f1                	div    %ecx
  105892:	89 fa                	mov    %edi,%edx
  105894:	83 c4 1c             	add    $0x1c,%esp
  105897:	5b                   	pop    %ebx
  105898:	5e                   	pop    %esi
  105899:	5f                   	pop    %edi
  10589a:	5d                   	pop    %ebp
  10589b:	c3                   	ret    
  10589c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1058a0:	39 f2                	cmp    %esi,%edx
  1058a2:	77 7c                	ja     105920 <__udivdi3+0xd0>
  1058a4:	0f bd fa             	bsr    %edx,%edi
  1058a7:	83 f7 1f             	xor    $0x1f,%edi
  1058aa:	0f 84 98 00 00 00    	je     105948 <__udivdi3+0xf8>
  1058b0:	89 f9                	mov    %edi,%ecx
  1058b2:	b8 20 00 00 00       	mov    $0x20,%eax
  1058b7:	29 f8                	sub    %edi,%eax
  1058b9:	d3 e2                	shl    %cl,%edx
  1058bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  1058bf:	89 c1                	mov    %eax,%ecx
  1058c1:	89 da                	mov    %ebx,%edx
  1058c3:	d3 ea                	shr    %cl,%edx
  1058c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  1058c9:	09 d1                	or     %edx,%ecx
  1058cb:	89 f2                	mov    %esi,%edx
  1058cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1058d1:	89 f9                	mov    %edi,%ecx
  1058d3:	d3 e3                	shl    %cl,%ebx
  1058d5:	89 c1                	mov    %eax,%ecx
  1058d7:	d3 ea                	shr    %cl,%edx
  1058d9:	89 f9                	mov    %edi,%ecx
  1058db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1058df:	d3 e6                	shl    %cl,%esi
  1058e1:	89 eb                	mov    %ebp,%ebx
  1058e3:	89 c1                	mov    %eax,%ecx
  1058e5:	d3 eb                	shr    %cl,%ebx
  1058e7:	09 de                	or     %ebx,%esi
  1058e9:	89 f0                	mov    %esi,%eax
  1058eb:	f7 74 24 08          	divl   0x8(%esp)
  1058ef:	89 d6                	mov    %edx,%esi
  1058f1:	89 c3                	mov    %eax,%ebx
  1058f3:	f7 64 24 0c          	mull   0xc(%esp)
  1058f7:	39 d6                	cmp    %edx,%esi
  1058f9:	72 0c                	jb     105907 <__udivdi3+0xb7>
  1058fb:	89 f9                	mov    %edi,%ecx
  1058fd:	d3 e5                	shl    %cl,%ebp
  1058ff:	39 c5                	cmp    %eax,%ebp
  105901:	73 5d                	jae    105960 <__udivdi3+0x110>
  105903:	39 d6                	cmp    %edx,%esi
  105905:	75 59                	jne    105960 <__udivdi3+0x110>
  105907:	8d 43 ff             	lea    -0x1(%ebx),%eax
  10590a:	31 ff                	xor    %edi,%edi
  10590c:	89 fa                	mov    %edi,%edx
  10590e:	83 c4 1c             	add    $0x1c,%esp
  105911:	5b                   	pop    %ebx
  105912:	5e                   	pop    %esi
  105913:	5f                   	pop    %edi
  105914:	5d                   	pop    %ebp
  105915:	c3                   	ret    
  105916:	8d 76 00             	lea    0x0(%esi),%esi
  105919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  105920:	31 ff                	xor    %edi,%edi
  105922:	31 c0                	xor    %eax,%eax
  105924:	89 fa                	mov    %edi,%edx
  105926:	83 c4 1c             	add    $0x1c,%esp
  105929:	5b                   	pop    %ebx
  10592a:	5e                   	pop    %esi
  10592b:	5f                   	pop    %edi
  10592c:	5d                   	pop    %ebp
  10592d:	c3                   	ret    
  10592e:	66 90                	xchg   %ax,%ax
  105930:	31 ff                	xor    %edi,%edi
  105932:	89 e8                	mov    %ebp,%eax
  105934:	89 f2                	mov    %esi,%edx
  105936:	f7 f3                	div    %ebx
  105938:	89 fa                	mov    %edi,%edx
  10593a:	83 c4 1c             	add    $0x1c,%esp
  10593d:	5b                   	pop    %ebx
  10593e:	5e                   	pop    %esi
  10593f:	5f                   	pop    %edi
  105940:	5d                   	pop    %ebp
  105941:	c3                   	ret    
  105942:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105948:	39 f2                	cmp    %esi,%edx
  10594a:	72 06                	jb     105952 <__udivdi3+0x102>
  10594c:	31 c0                	xor    %eax,%eax
  10594e:	39 eb                	cmp    %ebp,%ebx
  105950:	77 d2                	ja     105924 <__udivdi3+0xd4>
  105952:	b8 01 00 00 00       	mov    $0x1,%eax
  105957:	eb cb                	jmp    105924 <__udivdi3+0xd4>
  105959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105960:	89 d8                	mov    %ebx,%eax
  105962:	31 ff                	xor    %edi,%edi
  105964:	eb be                	jmp    105924 <__udivdi3+0xd4>
  105966:	66 90                	xchg   %ax,%ax
  105968:	66 90                	xchg   %ax,%ax
  10596a:	66 90                	xchg   %ax,%ax
  10596c:	66 90                	xchg   %ax,%ax
  10596e:	66 90                	xchg   %ax,%ax

00105970 <__umoddi3>:
  105970:	55                   	push   %ebp
  105971:	57                   	push   %edi
  105972:	56                   	push   %esi
  105973:	53                   	push   %ebx
  105974:	83 ec 1c             	sub    $0x1c,%esp
  105977:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  10597b:	8b 74 24 30          	mov    0x30(%esp),%esi
  10597f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  105983:	8b 7c 24 38          	mov    0x38(%esp),%edi
  105987:	85 ed                	test   %ebp,%ebp
  105989:	89 f0                	mov    %esi,%eax
  10598b:	89 da                	mov    %ebx,%edx
  10598d:	75 19                	jne    1059a8 <__umoddi3+0x38>
  10598f:	39 df                	cmp    %ebx,%edi
  105991:	0f 86 b1 00 00 00    	jbe    105a48 <__umoddi3+0xd8>
  105997:	f7 f7                	div    %edi
  105999:	89 d0                	mov    %edx,%eax
  10599b:	31 d2                	xor    %edx,%edx
  10599d:	83 c4 1c             	add    $0x1c,%esp
  1059a0:	5b                   	pop    %ebx
  1059a1:	5e                   	pop    %esi
  1059a2:	5f                   	pop    %edi
  1059a3:	5d                   	pop    %ebp
  1059a4:	c3                   	ret    
  1059a5:	8d 76 00             	lea    0x0(%esi),%esi
  1059a8:	39 dd                	cmp    %ebx,%ebp
  1059aa:	77 f1                	ja     10599d <__umoddi3+0x2d>
  1059ac:	0f bd cd             	bsr    %ebp,%ecx
  1059af:	83 f1 1f             	xor    $0x1f,%ecx
  1059b2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  1059b6:	0f 84 b4 00 00 00    	je     105a70 <__umoddi3+0x100>
  1059bc:	b8 20 00 00 00       	mov    $0x20,%eax
  1059c1:	89 c2                	mov    %eax,%edx
  1059c3:	8b 44 24 04          	mov    0x4(%esp),%eax
  1059c7:	29 c2                	sub    %eax,%edx
  1059c9:	89 c1                	mov    %eax,%ecx
  1059cb:	89 f8                	mov    %edi,%eax
  1059cd:	d3 e5                	shl    %cl,%ebp
  1059cf:	89 d1                	mov    %edx,%ecx
  1059d1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1059d5:	d3 e8                	shr    %cl,%eax
  1059d7:	09 c5                	or     %eax,%ebp
  1059d9:	8b 44 24 04          	mov    0x4(%esp),%eax
  1059dd:	89 c1                	mov    %eax,%ecx
  1059df:	d3 e7                	shl    %cl,%edi
  1059e1:	89 d1                	mov    %edx,%ecx
  1059e3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  1059e7:	89 df                	mov    %ebx,%edi
  1059e9:	d3 ef                	shr    %cl,%edi
  1059eb:	89 c1                	mov    %eax,%ecx
  1059ed:	89 f0                	mov    %esi,%eax
  1059ef:	d3 e3                	shl    %cl,%ebx
  1059f1:	89 d1                	mov    %edx,%ecx
  1059f3:	89 fa                	mov    %edi,%edx
  1059f5:	d3 e8                	shr    %cl,%eax
  1059f7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  1059fc:	09 d8                	or     %ebx,%eax
  1059fe:	f7 f5                	div    %ebp
  105a00:	d3 e6                	shl    %cl,%esi
  105a02:	89 d1                	mov    %edx,%ecx
  105a04:	f7 64 24 08          	mull   0x8(%esp)
  105a08:	39 d1                	cmp    %edx,%ecx
  105a0a:	89 c3                	mov    %eax,%ebx
  105a0c:	89 d7                	mov    %edx,%edi
  105a0e:	72 06                	jb     105a16 <__umoddi3+0xa6>
  105a10:	75 0e                	jne    105a20 <__umoddi3+0xb0>
  105a12:	39 c6                	cmp    %eax,%esi
  105a14:	73 0a                	jae    105a20 <__umoddi3+0xb0>
  105a16:	2b 44 24 08          	sub    0x8(%esp),%eax
  105a1a:	19 ea                	sbb    %ebp,%edx
  105a1c:	89 d7                	mov    %edx,%edi
  105a1e:	89 c3                	mov    %eax,%ebx
  105a20:	89 ca                	mov    %ecx,%edx
  105a22:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  105a27:	29 de                	sub    %ebx,%esi
  105a29:	19 fa                	sbb    %edi,%edx
  105a2b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  105a2f:	89 d0                	mov    %edx,%eax
  105a31:	d3 e0                	shl    %cl,%eax
  105a33:	89 d9                	mov    %ebx,%ecx
  105a35:	d3 ee                	shr    %cl,%esi
  105a37:	d3 ea                	shr    %cl,%edx
  105a39:	09 f0                	or     %esi,%eax
  105a3b:	83 c4 1c             	add    $0x1c,%esp
  105a3e:	5b                   	pop    %ebx
  105a3f:	5e                   	pop    %esi
  105a40:	5f                   	pop    %edi
  105a41:	5d                   	pop    %ebp
  105a42:	c3                   	ret    
  105a43:	90                   	nop
  105a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  105a48:	85 ff                	test   %edi,%edi
  105a4a:	89 f9                	mov    %edi,%ecx
  105a4c:	75 0b                	jne    105a59 <__umoddi3+0xe9>
  105a4e:	b8 01 00 00 00       	mov    $0x1,%eax
  105a53:	31 d2                	xor    %edx,%edx
  105a55:	f7 f7                	div    %edi
  105a57:	89 c1                	mov    %eax,%ecx
  105a59:	89 d8                	mov    %ebx,%eax
  105a5b:	31 d2                	xor    %edx,%edx
  105a5d:	f7 f1                	div    %ecx
  105a5f:	89 f0                	mov    %esi,%eax
  105a61:	f7 f1                	div    %ecx
  105a63:	e9 31 ff ff ff       	jmp    105999 <__umoddi3+0x29>
  105a68:	90                   	nop
  105a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105a70:	39 dd                	cmp    %ebx,%ebp
  105a72:	72 08                	jb     105a7c <__umoddi3+0x10c>
  105a74:	39 f7                	cmp    %esi,%edi
  105a76:	0f 87 21 ff ff ff    	ja     10599d <__umoddi3+0x2d>
  105a7c:	89 da                	mov    %ebx,%edx
  105a7e:	89 f0                	mov    %esi,%eax
  105a80:	29 f8                	sub    %edi,%eax
  105a82:	19 ea                	sbb    %ebp,%edx
  105a84:	e9 14 ff ff ff       	jmp    10599d <__umoddi3+0x2d>
