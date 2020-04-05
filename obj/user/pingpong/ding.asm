
obj/user/pingpong/ding:     file format elf32-i386


Disassembly of section .text:

40000000 <_start>:
_start:
	/*
	 * If there are arguments on the stack, then the current stack will not
	 * be aligned to a nice big power-of-two boundary/
	 */
	testl	$0x0fffffff, %esp
40000000:	f7 c4 ff ff ff 0f    	test   $0xfffffff,%esp
	jnz	args_exist
40000006:	75 04                	jne    4000000c <args_exist>

40000008 <noargs>:

noargs:
	/* If no arguments are on the stack, push two dummy zero. */
	pushl	$0
40000008:	6a 00                	push   $0x0
	pushl	$0
4000000a:	6a 00                	push   $0x0

4000000c <args_exist>:

args_exist:
	/* Jump to the C part. */
	call	main
4000000c:	e8 50 0b 00 00       	call   40000b61 <main>

	/* When returning, push the return value on the stack. */
	pushl	%eax
40000011:	50                   	push   %eax

40000012 <spin>:
spin:
	/*
	 * TODO: replace yield with exit
	 */
	call	yield
40000012:	e8 b8 07 00 00       	call   400007cf <yield>
	jmp	spin
40000017:	eb f9                	jmp    40000012 <spin>

40000019 <debug>:
#include <stdarg.h>
#include <stdio.h>

void
debug(const char *file, int line, const char *fmt, ...)
{
40000019:	53                   	push   %ebx
4000001a:	83 ec 0c             	sub    $0xc,%esp
4000001d:	e8 a7 00 00 00       	call   400000c9 <__x86.get_pc_thunk.bx>
40000022:	81 c3 de 2f 00 00    	add    $0x2fde,%ebx
	va_list ap;
	va_start(ap, fmt);
	printf("[D] %s:%d: ", file, line);
40000028:	ff 74 24 18          	pushl  0x18(%esp)
4000002c:	ff 74 24 18          	pushl  0x18(%esp)
40000030:	8d 83 3c de ff ff    	lea    -0x21c4(%ebx),%eax
40000036:	50                   	push   %eax
40000037:	e8 b6 01 00 00       	call   400001f2 <printf>
	vcprintf(fmt, ap);
4000003c:	83 c4 08             	add    $0x8,%esp
4000003f:	8d 44 24 24          	lea    0x24(%esp),%eax
40000043:	50                   	push   %eax
40000044:	ff 74 24 24          	pushl  0x24(%esp)
40000048:	e8 44 01 00 00       	call   40000191 <vcprintf>
	va_end(ap);
}
4000004d:	83 c4 18             	add    $0x18,%esp
40000050:	5b                   	pop    %ebx
40000051:	c3                   	ret    

40000052 <warn>:

void
warn(const char *file, int line, const char *fmt, ...)
{
40000052:	53                   	push   %ebx
40000053:	83 ec 0c             	sub    $0xc,%esp
40000056:	e8 6e 00 00 00       	call   400000c9 <__x86.get_pc_thunk.bx>
4000005b:	81 c3 a5 2f 00 00    	add    $0x2fa5,%ebx
	va_list ap;
	va_start(ap, fmt);
	printf("[W] %s:%d: ", file, line);
40000061:	ff 74 24 18          	pushl  0x18(%esp)
40000065:	ff 74 24 18          	pushl  0x18(%esp)
40000069:	8d 83 48 de ff ff    	lea    -0x21b8(%ebx),%eax
4000006f:	50                   	push   %eax
40000070:	e8 7d 01 00 00       	call   400001f2 <printf>
	vcprintf(fmt, ap);
40000075:	83 c4 08             	add    $0x8,%esp
40000078:	8d 44 24 24          	lea    0x24(%esp),%eax
4000007c:	50                   	push   %eax
4000007d:	ff 74 24 24          	pushl  0x24(%esp)
40000081:	e8 0b 01 00 00       	call   40000191 <vcprintf>
	va_end(ap);
}
40000086:	83 c4 18             	add    $0x18,%esp
40000089:	5b                   	pop    %ebx
4000008a:	c3                   	ret    

4000008b <panic>:

void
panic(const char *file, int line, const char *fmt, ...)
{
4000008b:	53                   	push   %ebx
4000008c:	83 ec 0c             	sub    $0xc,%esp
4000008f:	e8 35 00 00 00       	call   400000c9 <__x86.get_pc_thunk.bx>
40000094:	81 c3 6c 2f 00 00    	add    $0x2f6c,%ebx
	va_list ap;
	va_start(ap, fmt);
	printf("[P] %s:%d: ", file, line);
4000009a:	ff 74 24 18          	pushl  0x18(%esp)
4000009e:	ff 74 24 18          	pushl  0x18(%esp)
400000a2:	8d 83 54 de ff ff    	lea    -0x21ac(%ebx),%eax
400000a8:	50                   	push   %eax
400000a9:	e8 44 01 00 00       	call   400001f2 <printf>
	vcprintf(fmt, ap);
400000ae:	83 c4 08             	add    $0x8,%esp
400000b1:	8d 44 24 24          	lea    0x24(%esp),%eax
400000b5:	50                   	push   %eax
400000b6:	ff 74 24 24          	pushl  0x24(%esp)
400000ba:	e8 d2 00 00 00       	call   40000191 <vcprintf>
400000bf:	83 c4 10             	add    $0x10,%esp
	va_end(ap);

	while (1)
		yield();
400000c2:	e8 08 07 00 00       	call   400007cf <yield>
400000c7:	eb f9                	jmp    400000c2 <panic+0x37>

400000c9 <__x86.get_pc_thunk.bx>:
400000c9:	8b 1c 24             	mov    (%esp),%ebx
400000cc:	c3                   	ret    

400000cd <atoi>:
#include <stdlib.h>

int
atoi(const char *buf, int *i)
{
400000cd:	55                   	push   %ebp
400000ce:	57                   	push   %edi
400000cf:	56                   	push   %esi
400000d0:	53                   	push   %ebx
400000d1:	83 ec 04             	sub    $0x4,%esp
400000d4:	8b 44 24 18          	mov    0x18(%esp),%eax
400000d8:	89 04 24             	mov    %eax,(%esp)
	int loc = 0;
	int numstart = 0;
	int acc = 0;
	int negative = 0;
	if (buf[loc] == '+')
400000db:	0f b6 00             	movzbl (%eax),%eax
400000de:	3c 2b                	cmp    $0x2b,%al
400000e0:	74 17                	je     400000f9 <atoi+0x2c>
		loc++;
	else if (buf[loc] == '-') {
400000e2:	3c 2d                	cmp    $0x2d,%al
400000e4:	74 1f                	je     40000105 <atoi+0x38>
	int negative = 0;
400000e6:	bf 00 00 00 00       	mov    $0x0,%edi
	int loc = 0;
400000eb:	be 00 00 00 00       	mov    $0x0,%esi
		negative = 1;
		loc++;
	}
	numstart = loc;
	// no grab the numbers
	while ('0' <= buf[loc] && buf[loc] <= '9') {
400000f0:	89 f0                	mov    %esi,%eax
	int acc = 0;
400000f2:	b9 00 00 00 00       	mov    $0x0,%ecx
	while ('0' <= buf[loc] && buf[loc] <= '9') {
400000f7:	eb 29                	jmp    40000122 <atoi+0x55>
	int negative = 0;
400000f9:	bf 00 00 00 00       	mov    $0x0,%edi
		loc++;
400000fe:	be 01 00 00 00       	mov    $0x1,%esi
40000103:	eb eb                	jmp    400000f0 <atoi+0x23>
		negative = 1;
40000105:	bf 01 00 00 00       	mov    $0x1,%edi
		loc++;
4000010a:	be 01 00 00 00       	mov    $0x1,%esi
4000010f:	eb df                	jmp    400000f0 <atoi+0x23>
		acc = acc*10 + (buf[loc]-'0');
40000111:	8d 2c 89             	lea    (%ecx,%ecx,4),%ebp
40000114:	8d 4c 2d 00          	lea    0x0(%ebp,%ebp,1),%ecx
40000118:	0f be d2             	movsbl %dl,%edx
4000011b:	8d 4c 0a d0          	lea    -0x30(%edx,%ecx,1),%ecx
		loc++;
4000011f:	83 c0 01             	add    $0x1,%eax
	while ('0' <= buf[loc] && buf[loc] <= '9') {
40000122:	8b 1c 24             	mov    (%esp),%ebx
40000125:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
40000129:	8d 6a d0             	lea    -0x30(%edx),%ebp
4000012c:	89 eb                	mov    %ebp,%ebx
4000012e:	80 fb 09             	cmp    $0x9,%bl
40000131:	76 de                	jbe    40000111 <atoi+0x44>
	}
	if (numstart == loc) {
40000133:	39 c6                	cmp    %eax,%esi
40000135:	74 14                	je     4000014b <atoi+0x7e>
		// no numbers have actually been scanned
		return 0;
	}
	if (negative)
40000137:	85 ff                	test   %edi,%edi
40000139:	74 02                	je     4000013d <atoi+0x70>
		acc = - acc;
4000013b:	f7 d9                	neg    %ecx
	*i = acc;
4000013d:	8b 54 24 1c          	mov    0x1c(%esp),%edx
40000141:	89 0a                	mov    %ecx,(%edx)
	return loc;
}
40000143:	83 c4 04             	add    $0x4,%esp
40000146:	5b                   	pop    %ebx
40000147:	5e                   	pop    %esi
40000148:	5f                   	pop    %edi
40000149:	5d                   	pop    %ebp
4000014a:	c3                   	ret    
		return 0;
4000014b:	b8 00 00 00 00       	mov    $0x0,%eax
40000150:	eb f1                	jmp    40000143 <atoi+0x76>

40000152 <putch>:
	char buf[MAX_BUF];
};

static void
putch(int ch, struct printbuf *b)
{
40000152:	53                   	push   %ebx
40000153:	8b 54 24 0c          	mov    0xc(%esp),%edx
	b->buf[b->idx++] = ch;
40000157:	8b 02                	mov    (%edx),%eax
40000159:	8d 48 01             	lea    0x1(%eax),%ecx
4000015c:	89 0a                	mov    %ecx,(%edx)
4000015e:	0f b6 5c 24 08       	movzbl 0x8(%esp),%ebx
40000163:	88 5c 02 08          	mov    %bl,0x8(%edx,%eax,1)
	if (b->idx == MAX_BUF-1) {
40000167:	81 f9 ff 0f 00 00    	cmp    $0xfff,%ecx
4000016d:	74 0b                	je     4000017a <putch+0x28>
		b->buf[b->idx] = 0;
		puts(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
4000016f:	8b 42 04             	mov    0x4(%edx),%eax
40000172:	83 c0 01             	add    $0x1,%eax
40000175:	89 42 04             	mov    %eax,0x4(%edx)
}
40000178:	5b                   	pop    %ebx
40000179:	c3                   	ret    
		b->buf[b->idx] = 0;
4000017a:	c6 44 02 09 00       	movb   $0x0,0x9(%edx,%eax,1)
		puts(b->buf, b->idx);
4000017f:	8d 5a 08             	lea    0x8(%edx),%ebx
  */

static gcc_inline void
sys_puts(const char *s, size_t len)
{
	asm volatile("int %0" :
40000182:	b8 00 00 00 00       	mov    $0x0,%eax
40000187:	cd 30                	int    $0x30
		b->idx = 0;
40000189:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
4000018f:	eb de                	jmp    4000016f <putch+0x1d>

40000191 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
40000191:	53                   	push   %ebx
40000192:	81 ec 18 10 00 00    	sub    $0x1018,%esp
40000198:	e8 2c ff ff ff       	call   400000c9 <__x86.get_pc_thunk.bx>
4000019d:	81 c3 63 2e 00 00    	add    $0x2e63,%ebx
	struct printbuf b;

	b.idx = 0;
400001a3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
400001aa:	00 
	b.cnt = 0;
400001ab:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
400001b2:	00 
	vprintfmt((void*)putch, &b, fmt, ap);
400001b3:	ff b4 24 24 10 00 00 	pushl  0x1024(%esp)
400001ba:	ff b4 24 24 10 00 00 	pushl  0x1024(%esp)
400001c1:	8d 44 24 10          	lea    0x10(%esp),%eax
400001c5:	50                   	push   %eax
400001c6:	8d 83 52 d1 ff ff    	lea    -0x2eae(%ebx),%eax
400001cc:	50                   	push   %eax
400001cd:	e8 8b 01 00 00       	call   4000035d <vprintfmt>

	b.buf[b.idx] = 0;
400001d2:	8b 4c 24 18          	mov    0x18(%esp),%ecx
400001d6:	c6 44 0c 20 00       	movb   $0x0,0x20(%esp,%ecx,1)
400001db:	8d 5c 24 20          	lea    0x20(%esp),%ebx
400001df:	b8 00 00 00 00       	mov    $0x0,%eax
400001e4:	cd 30                	int    $0x30
	puts(b.buf, b.idx);

	return b.cnt;
}
400001e6:	8b 44 24 1c          	mov    0x1c(%esp),%eax
400001ea:	81 c4 28 10 00 00    	add    $0x1028,%esp
400001f0:	5b                   	pop    %ebx
400001f1:	c3                   	ret    

400001f2 <printf>:

int
printf(const char *fmt, ...)
{
400001f2:	83 ec 14             	sub    $0x14,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
400001f5:	8d 44 24 1c          	lea    0x1c(%esp),%eax
400001f9:	50                   	push   %eax
400001fa:	ff 74 24 1c          	pushl  0x1c(%esp)
400001fe:	e8 8e ff ff ff       	call   40000191 <vcprintf>
	va_end(ap);

	return cnt;
}
40000203:	83 c4 1c             	add    $0x1c,%esp
40000206:	c3                   	ret    

40000207 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
40000207:	55                   	push   %ebp
40000208:	57                   	push   %edi
40000209:	56                   	push   %esi
4000020a:	53                   	push   %ebx
4000020b:	83 ec 2c             	sub    $0x2c,%esp
4000020e:	e8 b2 05 00 00       	call   400007c5 <__x86.get_pc_thunk.cx>
40000213:	81 c1 ed 2d 00 00    	add    $0x2ded,%ecx
40000219:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
4000021d:	89 c6                	mov    %eax,%esi
4000021f:	89 d7                	mov    %edx,%edi
40000221:	8b 44 24 40          	mov    0x40(%esp),%eax
40000225:	8b 54 24 44          	mov    0x44(%esp),%edx
40000229:	89 44 24 18          	mov    %eax,0x18(%esp)
4000022d:	89 54 24 1c          	mov    %edx,0x1c(%esp)
40000231:	8b 6c 24 50          	mov    0x50(%esp),%ebp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
40000235:	8b 4c 24 48          	mov    0x48(%esp),%ecx
40000239:	bb 00 00 00 00       	mov    $0x0,%ebx
4000023e:	89 4c 24 10          	mov    %ecx,0x10(%esp)
40000242:	89 5c 24 14          	mov    %ebx,0x14(%esp)
40000246:	39 d3                	cmp    %edx,%ebx
40000248:	72 0a                	jb     40000254 <printnum+0x4d>
4000024a:	39 44 24 48          	cmp    %eax,0x48(%esp)
4000024e:	0f 87 82 00 00 00    	ja     400002d6 <printnum+0xcf>
		printnum(putch, putdat, num / base, base, width - 1, padc);
40000254:	83 ec 0c             	sub    $0xc,%esp
40000257:	55                   	push   %ebp
40000258:	8b 44 24 5c          	mov    0x5c(%esp),%eax
4000025c:	8d 58 ff             	lea    -0x1(%eax),%ebx
4000025f:	53                   	push   %ebx
40000260:	ff 74 24 5c          	pushl  0x5c(%esp)
40000264:	83 ec 08             	sub    $0x8,%esp
40000267:	ff 74 24 34          	pushl  0x34(%esp)
4000026b:	ff 74 24 34          	pushl  0x34(%esp)
4000026f:	ff 74 24 44          	pushl  0x44(%esp)
40000273:	ff 74 24 44          	pushl  0x44(%esp)
40000277:	8b 5c 24 3c          	mov    0x3c(%esp),%ebx
4000027b:	e8 80 09 00 00       	call   40000c00 <__udivdi3>
40000280:	83 c4 18             	add    $0x18,%esp
40000283:	52                   	push   %edx
40000284:	50                   	push   %eax
40000285:	89 fa                	mov    %edi,%edx
40000287:	89 f0                	mov    %esi,%eax
40000289:	e8 79 ff ff ff       	call   40000207 <printnum>
4000028e:	83 c4 20             	add    $0x20,%esp
40000291:	eb 11                	jmp    400002a4 <printnum+0x9d>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
40000293:	83 ec 08             	sub    $0x8,%esp
40000296:	57                   	push   %edi
40000297:	55                   	push   %ebp
40000298:	ff d6                	call   *%esi
4000029a:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
4000029d:	83 eb 01             	sub    $0x1,%ebx
400002a0:	85 db                	test   %ebx,%ebx
400002a2:	7f ef                	jg     40000293 <printnum+0x8c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
400002a4:	ff 74 24 14          	pushl  0x14(%esp)
400002a8:	ff 74 24 14          	pushl  0x14(%esp)
400002ac:	ff 74 24 24          	pushl  0x24(%esp)
400002b0:	ff 74 24 24          	pushl  0x24(%esp)
400002b4:	8b 6c 24 1c          	mov    0x1c(%esp),%ebp
400002b8:	89 eb                	mov    %ebp,%ebx
400002ba:	e8 61 0a 00 00       	call   40000d20 <__umoddi3>
400002bf:	83 c4 08             	add    $0x8,%esp
400002c2:	57                   	push   %edi
400002c3:	0f be 84 05 60 de ff 	movsbl -0x21a0(%ebp,%eax,1),%eax
400002ca:	ff 
400002cb:	50                   	push   %eax
400002cc:	ff d6                	call   *%esi
}
400002ce:	83 c4 3c             	add    $0x3c,%esp
400002d1:	5b                   	pop    %ebx
400002d2:	5e                   	pop    %esi
400002d3:	5f                   	pop    %edi
400002d4:	5d                   	pop    %ebp
400002d5:	c3                   	ret    
400002d6:	8b 5c 24 4c          	mov    0x4c(%esp),%ebx
400002da:	eb c1                	jmp    4000029d <printnum+0x96>

400002dc <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
400002dc:	83 fa 01             	cmp    $0x1,%edx
400002df:	7e 0d                	jle    400002ee <getuint+0x12>
		return va_arg(*ap, unsigned long long);
400002e1:	8b 08                	mov    (%eax),%ecx
400002e3:	8d 51 08             	lea    0x8(%ecx),%edx
400002e6:	89 10                	mov    %edx,(%eax)
400002e8:	8b 01                	mov    (%ecx),%eax
400002ea:	8b 51 04             	mov    0x4(%ecx),%edx
400002ed:	c3                   	ret    
	else if (lflag)
400002ee:	85 d2                	test   %edx,%edx
400002f0:	75 0f                	jne    40000301 <getuint+0x25>
		return va_arg(*ap, unsigned long);
	else
		return va_arg(*ap, unsigned int);
400002f2:	8b 08                	mov    (%eax),%ecx
400002f4:	8d 51 04             	lea    0x4(%ecx),%edx
400002f7:	89 10                	mov    %edx,(%eax)
400002f9:	8b 01                	mov    (%ecx),%eax
400002fb:	ba 00 00 00 00       	mov    $0x0,%edx
}
40000300:	c3                   	ret    
		return va_arg(*ap, unsigned long);
40000301:	8b 08                	mov    (%eax),%ecx
40000303:	8d 51 04             	lea    0x4(%ecx),%edx
40000306:	89 10                	mov    %edx,(%eax)
40000308:	8b 01                	mov    (%ecx),%eax
4000030a:	ba 00 00 00 00       	mov    $0x0,%edx
4000030f:	c3                   	ret    

40000310 <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
40000310:	83 fa 01             	cmp    $0x1,%edx
40000313:	7e 0d                	jle    40000322 <getint+0x12>
		return va_arg(*ap, long long);
40000315:	8b 08                	mov    (%eax),%ecx
40000317:	8d 51 08             	lea    0x8(%ecx),%edx
4000031a:	89 10                	mov    %edx,(%eax)
4000031c:	8b 01                	mov    (%ecx),%eax
4000031e:	8b 51 04             	mov    0x4(%ecx),%edx
40000321:	c3                   	ret    
	else if (lflag)
40000322:	85 d2                	test   %edx,%edx
40000324:	75 0b                	jne    40000331 <getint+0x21>
		return va_arg(*ap, long);
	else
		return va_arg(*ap, int);
40000326:	8b 08                	mov    (%eax),%ecx
40000328:	8d 51 04             	lea    0x4(%ecx),%edx
4000032b:	89 10                	mov    %edx,(%eax)
4000032d:	8b 01                	mov    (%ecx),%eax
4000032f:	99                   	cltd   
}
40000330:	c3                   	ret    
		return va_arg(*ap, long);
40000331:	8b 08                	mov    (%eax),%ecx
40000333:	8d 51 04             	lea    0x4(%ecx),%edx
40000336:	89 10                	mov    %edx,(%eax)
40000338:	8b 01                	mov    (%ecx),%eax
4000033a:	99                   	cltd   
4000033b:	c3                   	ret    

4000033c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
4000033c:	8b 44 24 08          	mov    0x8(%esp),%eax
	b->cnt++;
40000340:	8b 48 08             	mov    0x8(%eax),%ecx
40000343:	8d 51 01             	lea    0x1(%ecx),%edx
40000346:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
40000349:	8b 10                	mov    (%eax),%edx
4000034b:	3b 50 04             	cmp    0x4(%eax),%edx
4000034e:	73 0b                	jae    4000035b <sprintputch+0x1f>
		*b->buf++ = ch;
40000350:	8d 4a 01             	lea    0x1(%edx),%ecx
40000353:	89 08                	mov    %ecx,(%eax)
40000355:	8b 44 24 04          	mov    0x4(%esp),%eax
40000359:	88 02                	mov    %al,(%edx)
}
4000035b:	f3 c3                	repz ret 

4000035d <vprintfmt>:
{
4000035d:	55                   	push   %ebp
4000035e:	57                   	push   %edi
4000035f:	56                   	push   %esi
40000360:	53                   	push   %ebx
40000361:	83 ec 2c             	sub    $0x2c,%esp
40000364:	e8 54 04 00 00       	call   400007bd <__x86.get_pc_thunk.ax>
40000369:	05 97 2c 00 00       	add    $0x2c97,%eax
4000036e:	89 44 24 04          	mov    %eax,0x4(%esp)
40000372:	8b 74 24 40          	mov    0x40(%esp),%esi
40000376:	8b 7c 24 44          	mov    0x44(%esp),%edi
4000037a:	8b 6c 24 48          	mov    0x48(%esp),%ebp
		while ((ch = *(unsigned char *) fmt++) != '%') {
4000037e:	8d 5d 01             	lea    0x1(%ebp),%ebx
40000381:	0f b6 45 00          	movzbl 0x0(%ebp),%eax
40000385:	83 f8 25             	cmp    $0x25,%eax
40000388:	74 16                	je     400003a0 <vprintfmt+0x43>
			if (ch == '\0')
4000038a:	85 c0                	test   %eax,%eax
4000038c:	0f 84 31 03 00 00    	je     400006c3 <.L29+0x1c>
			putch(ch, putdat);
40000392:	83 ec 08             	sub    $0x8,%esp
40000395:	57                   	push   %edi
40000396:	50                   	push   %eax
40000397:	ff d6                	call   *%esi
		while ((ch = *(unsigned char *) fmt++) != '%') {
40000399:	83 c4 10             	add    $0x10,%esp
4000039c:	89 dd                	mov    %ebx,%ebp
4000039e:	eb de                	jmp    4000037e <vprintfmt+0x21>
		padc = ' ';
400003a0:	c6 44 24 17 20       	movb   $0x20,0x17(%esp)
		altflag = 0;
400003a5:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
400003ac:	00 
		precision = -1;
400003ad:	c7 44 24 1c ff ff ff 	movl   $0xffffffff,0x1c(%esp)
400003b4:	ff 
		width = -1;
400003b5:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
		lflag = 0;
400003bc:	ba 00 00 00 00       	mov    $0x0,%edx
400003c1:	89 54 24 18          	mov    %edx,0x18(%esp)
		switch (ch = *(unsigned char *) fmt++) {
400003c5:	8d 6b 01             	lea    0x1(%ebx),%ebp
400003c8:	0f b6 03             	movzbl (%ebx),%eax
400003cb:	0f b6 d0             	movzbl %al,%edx
400003ce:	89 54 24 08          	mov    %edx,0x8(%esp)
400003d2:	83 e8 23             	sub    $0x23,%eax
400003d5:	3c 55                	cmp    $0x55,%al
400003d7:	0f 87 ca 02 00 00    	ja     400006a7 <.L29>
400003dd:	0f b6 c0             	movzbl %al,%eax
400003e0:	8b 4c 24 04          	mov    0x4(%esp),%ecx
400003e4:	03 8c 81 78 de ff ff 	add    -0x2188(%ecx,%eax,4),%ecx
400003eb:	ff e1                	jmp    *%ecx

400003ed <.L27>:
400003ed:	89 eb                	mov    %ebp,%ebx
			padc = '-';
400003ef:	c6 44 24 17 2d       	movb   $0x2d,0x17(%esp)
400003f4:	eb cf                	jmp    400003c5 <vprintfmt+0x68>

400003f6 <.L61>:
		switch (ch = *(unsigned char *) fmt++) {
400003f6:	89 eb                	mov    %ebp,%ebx
			padc = '0';
400003f8:	c6 44 24 17 30       	movb   $0x30,0x17(%esp)
400003fd:	eb c6                	jmp    400003c5 <vprintfmt+0x68>
		switch (ch = *(unsigned char *) fmt++) {
400003ff:	89 eb                	mov    %ebp,%ebx
				width = 0;
40000401:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
40000408:	eb bb                	jmp    400003c5 <vprintfmt+0x68>

4000040a <.L62>:
			for (precision = 0; ; ++fmt) {
4000040a:	b8 00 00 00 00       	mov    $0x0,%eax
4000040f:	8b 4c 24 08          	mov    0x8(%esp),%ecx
40000413:	8b 54 24 18          	mov    0x18(%esp),%edx
				precision = precision * 10 + ch - '0';
40000417:	8d 1c 80             	lea    (%eax,%eax,4),%ebx
4000041a:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
4000041d:	8d 44 01 d0          	lea    -0x30(%ecx,%eax,1),%eax
				ch = *fmt;
40000421:	0f be 4d 00          	movsbl 0x0(%ebp),%ecx
				if (ch < '0' || ch > '9')
40000425:	8d 59 d0             	lea    -0x30(%ecx),%ebx
40000428:	83 fb 09             	cmp    $0x9,%ebx
4000042b:	77 53                	ja     40000480 <.L30+0xf>
			for (precision = 0; ; ++fmt) {
4000042d:	83 c5 01             	add    $0x1,%ebp
				precision = precision * 10 + ch - '0';
40000430:	eb e5                	jmp    40000417 <.L62+0xd>

40000432 <.L33>:
			precision = va_arg(ap, int);
40000432:	8b 44 24 4c          	mov    0x4c(%esp),%eax
40000436:	83 c0 04             	add    $0x4,%eax
40000439:	89 44 24 4c          	mov    %eax,0x4c(%esp)
4000043d:	8b 40 fc             	mov    -0x4(%eax),%eax
40000440:	89 44 24 1c          	mov    %eax,0x1c(%esp)
		switch (ch = *(unsigned char *) fmt++) {
40000444:	89 eb                	mov    %ebp,%ebx
			if (width < 0)
40000446:	83 3c 24 00          	cmpl   $0x0,(%esp)
4000044a:	0f 89 75 ff ff ff    	jns    400003c5 <vprintfmt+0x68>
				width = precision, precision = -1;
40000450:	8b 44 24 1c          	mov    0x1c(%esp),%eax
40000454:	89 04 24             	mov    %eax,(%esp)
40000457:	c7 44 24 1c ff ff ff 	movl   $0xffffffff,0x1c(%esp)
4000045e:	ff 
4000045f:	e9 61 ff ff ff       	jmp    400003c5 <vprintfmt+0x68>

40000464 <.L34>:
			if (width < 0)
40000464:	83 3c 24 00          	cmpl   $0x0,(%esp)
40000468:	78 95                	js     400003ff <.L61+0x9>
		switch (ch = *(unsigned char *) fmt++) {
4000046a:	89 eb                	mov    %ebp,%ebx
4000046c:	e9 54 ff ff ff       	jmp    400003c5 <vprintfmt+0x68>

40000471 <.L30>:
40000471:	89 eb                	mov    %ebp,%ebx
			altflag = 1;
40000473:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
4000047a:	00 
			goto reswitch;
4000047b:	e9 45 ff ff ff       	jmp    400003c5 <vprintfmt+0x68>
40000480:	89 54 24 18          	mov    %edx,0x18(%esp)
40000484:	89 44 24 1c          	mov    %eax,0x1c(%esp)
40000488:	89 eb                	mov    %ebp,%ebx
4000048a:	eb ba                	jmp    40000446 <.L33+0x14>

4000048c <.L38>:
			lflag++;
4000048c:	83 44 24 18 01       	addl   $0x1,0x18(%esp)
		switch (ch = *(unsigned char *) fmt++) {
40000491:	89 eb                	mov    %ebp,%ebx
			goto reswitch;
40000493:	e9 2d ff ff ff       	jmp    400003c5 <vprintfmt+0x68>

40000498 <.L36>:
			putch(va_arg(ap, int), putdat);
40000498:	8b 44 24 4c          	mov    0x4c(%esp),%eax
4000049c:	83 c0 04             	add    $0x4,%eax
4000049f:	89 44 24 4c          	mov    %eax,0x4c(%esp)
400004a3:	83 ec 08             	sub    $0x8,%esp
400004a6:	57                   	push   %edi
400004a7:	ff 70 fc             	pushl  -0x4(%eax)
400004aa:	ff d6                	call   *%esi
			break;
400004ac:	83 c4 10             	add    $0x10,%esp
400004af:	e9 ca fe ff ff       	jmp    4000037e <vprintfmt+0x21>

400004b4 <.L41>:
			if ((p = va_arg(ap, char *)) == NULL)
400004b4:	8b 44 24 4c          	mov    0x4c(%esp),%eax
400004b8:	83 c0 04             	add    $0x4,%eax
400004bb:	89 44 24 4c          	mov    %eax,0x4c(%esp)
400004bf:	8b 40 fc             	mov    -0x4(%eax),%eax
400004c2:	89 44 24 08          	mov    %eax,0x8(%esp)
400004c6:	85 c0                	test   %eax,%eax
400004c8:	74 21                	je     400004eb <.L41+0x37>
			if (width > 0 && padc != '-')
400004ca:	83 3c 24 00          	cmpl   $0x0,(%esp)
400004ce:	0f 9f c2             	setg   %dl
400004d1:	80 7c 24 17 2d       	cmpb   $0x2d,0x17(%esp)
400004d6:	0f 95 c0             	setne  %al
400004d9:	84 c2                	test   %al,%dl
400004db:	75 1e                	jne    400004fb <.L41+0x47>
400004dd:	8b 44 24 08          	mov    0x8(%esp),%eax
400004e1:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
400004e5:	89 6c 24 48          	mov    %ebp,0x48(%esp)
400004e9:	eb 71                	jmp    4000055c <.L41+0xa8>
				p = "(null)";
400004eb:	8b 44 24 04          	mov    0x4(%esp),%eax
400004ef:	8d 80 71 de ff ff    	lea    -0x218f(%eax),%eax
400004f5:	89 44 24 08          	mov    %eax,0x8(%esp)
400004f9:	eb cf                	jmp    400004ca <.L41+0x16>
				for (width -= strnlen(p, precision); width > 0; width--)
400004fb:	83 ec 08             	sub    $0x8,%esp
400004fe:	ff 74 24 24          	pushl  0x24(%esp)
40000502:	ff 74 24 14          	pushl  0x14(%esp)
40000506:	8b 5c 24 14          	mov    0x14(%esp),%ebx
4000050a:	e8 da 02 00 00       	call   400007e9 <strnlen>
4000050f:	29 44 24 10          	sub    %eax,0x10(%esp)
40000513:	8b 54 24 10          	mov    0x10(%esp),%edx
40000517:	83 c4 10             	add    $0x10,%esp
4000051a:	89 d3                	mov    %edx,%ebx
4000051c:	eb 12                	jmp    40000530 <.L41+0x7c>
					putch(padc, putdat);
4000051e:	83 ec 08             	sub    $0x8,%esp
40000521:	57                   	push   %edi
40000522:	0f be 44 24 23       	movsbl 0x23(%esp),%eax
40000527:	50                   	push   %eax
40000528:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
4000052a:	83 eb 01             	sub    $0x1,%ebx
4000052d:	83 c4 10             	add    $0x10,%esp
40000530:	85 db                	test   %ebx,%ebx
40000532:	7f ea                	jg     4000051e <.L41+0x6a>
40000534:	89 1c 24             	mov    %ebx,(%esp)
40000537:	8b 44 24 08          	mov    0x8(%esp),%eax
4000053b:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
4000053f:	89 6c 24 48          	mov    %ebp,0x48(%esp)
40000543:	eb 17                	jmp    4000055c <.L41+0xa8>
				if (altflag && (ch < ' ' || ch > '~'))
40000545:	83 7c 24 10 00       	cmpl   $0x0,0x10(%esp)
4000054a:	75 2f                	jne    4000057b <.L41+0xc7>
					putch(ch, putdat);
4000054c:	83 ec 08             	sub    $0x8,%esp
4000054f:	57                   	push   %edi
40000550:	50                   	push   %eax
40000551:	ff d6                	call   *%esi
40000553:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
40000556:	83 2c 24 01          	subl   $0x1,(%esp)
4000055a:	89 e8                	mov    %ebp,%eax
4000055c:	8d 68 01             	lea    0x1(%eax),%ebp
4000055f:	0f b6 10             	movzbl (%eax),%edx
40000562:	0f be c2             	movsbl %dl,%eax
40000565:	85 c0                	test   %eax,%eax
40000567:	74 2a                	je     40000593 <.L41+0xdf>
40000569:	85 db                	test   %ebx,%ebx
4000056b:	78 d8                	js     40000545 <.L41+0x91>
4000056d:	83 eb 01             	sub    $0x1,%ebx
40000570:	79 d3                	jns    40000545 <.L41+0x91>
40000572:	8b 6c 24 48          	mov    0x48(%esp),%ebp
40000576:	8b 1c 24             	mov    (%esp),%ebx
40000579:	eb 1f                	jmp    4000059a <.L41+0xe6>
				if (altflag && (ch < ' ' || ch > '~'))
4000057b:	0f be d2             	movsbl %dl,%edx
4000057e:	83 ea 20             	sub    $0x20,%edx
40000581:	83 fa 5e             	cmp    $0x5e,%edx
40000584:	76 c6                	jbe    4000054c <.L41+0x98>
					putch('?', putdat);
40000586:	83 ec 08             	sub    $0x8,%esp
40000589:	57                   	push   %edi
4000058a:	6a 3f                	push   $0x3f
4000058c:	ff d6                	call   *%esi
4000058e:	83 c4 10             	add    $0x10,%esp
40000591:	eb c3                	jmp    40000556 <.L41+0xa2>
40000593:	8b 1c 24             	mov    (%esp),%ebx
40000596:	8b 6c 24 48          	mov    0x48(%esp),%ebp
			for (; width > 0; width--)
4000059a:	85 db                	test   %ebx,%ebx
4000059c:	0f 8e dc fd ff ff    	jle    4000037e <vprintfmt+0x21>
				putch(' ', putdat);
400005a2:	83 ec 08             	sub    $0x8,%esp
400005a5:	57                   	push   %edi
400005a6:	6a 20                	push   $0x20
400005a8:	ff d6                	call   *%esi
			for (; width > 0; width--)
400005aa:	83 eb 01             	sub    $0x1,%ebx
400005ad:	83 c4 10             	add    $0x10,%esp
400005b0:	eb e8                	jmp    4000059a <.L41+0xe6>

400005b2 <.L37>:
400005b2:	8b 54 24 18          	mov    0x18(%esp),%edx
			num = getint(&ap, lflag);
400005b6:	8d 44 24 4c          	lea    0x4c(%esp),%eax
400005ba:	e8 51 fd ff ff       	call   40000310 <getint>
			if ((long long) num < 0) {
400005bf:	89 44 24 08          	mov    %eax,0x8(%esp)
400005c3:	89 54 24 0c          	mov    %edx,0xc(%esp)
400005c7:	83 7c 24 0c 00       	cmpl   $0x0,0xc(%esp)
400005cc:	0f 89 b8 00 00 00    	jns    4000068a <.L43+0x17>
				putch('-', putdat);
400005d2:	83 ec 08             	sub    $0x8,%esp
400005d5:	57                   	push   %edi
400005d6:	6a 2d                	push   $0x2d
400005d8:	ff d6                	call   *%esi
				num = -(long long) num;
400005da:	8b 44 24 18          	mov    0x18(%esp),%eax
400005de:	8b 54 24 1c          	mov    0x1c(%esp),%edx
400005e2:	f7 d8                	neg    %eax
400005e4:	83 d2 00             	adc    $0x0,%edx
400005e7:	f7 da                	neg    %edx
400005e9:	83 c4 10             	add    $0x10,%esp
			base = 10;
400005ec:	bb 0a 00 00 00       	mov    $0xa,%ebx
400005f1:	eb 12                	jmp    40000605 <.L42+0x12>

400005f3 <.L42>:
400005f3:	8b 54 24 18          	mov    0x18(%esp),%edx
			num = getuint(&ap, lflag);
400005f7:	8d 44 24 4c          	lea    0x4c(%esp),%eax
400005fb:	e8 dc fc ff ff       	call   400002dc <getuint>
			base = 10;
40000600:	bb 0a 00 00 00       	mov    $0xa,%ebx
			printnum(putch, putdat, num, base, width, padc);
40000605:	83 ec 0c             	sub    $0xc,%esp
40000608:	0f be 4c 24 23       	movsbl 0x23(%esp),%ecx
4000060d:	51                   	push   %ecx
4000060e:	ff 74 24 10          	pushl  0x10(%esp)
40000612:	53                   	push   %ebx
40000613:	52                   	push   %edx
40000614:	50                   	push   %eax
40000615:	89 fa                	mov    %edi,%edx
40000617:	89 f0                	mov    %esi,%eax
40000619:	e8 e9 fb ff ff       	call   40000207 <printnum>
			break;
4000061e:	83 c4 20             	add    $0x20,%esp
40000621:	e9 58 fd ff ff       	jmp    4000037e <vprintfmt+0x21>

40000626 <.L39>:
			putch('X', putdat);
40000626:	83 ec 08             	sub    $0x8,%esp
40000629:	57                   	push   %edi
4000062a:	6a 58                	push   $0x58
4000062c:	ff d6                	call   *%esi
			putch('X', putdat);
4000062e:	83 c4 08             	add    $0x8,%esp
40000631:	57                   	push   %edi
40000632:	6a 58                	push   $0x58
40000634:	ff d6                	call   *%esi
			putch('X', putdat);
40000636:	83 c4 08             	add    $0x8,%esp
40000639:	57                   	push   %edi
4000063a:	6a 58                	push   $0x58
4000063c:	ff d6                	call   *%esi
			break;
4000063e:	83 c4 10             	add    $0x10,%esp
40000641:	e9 38 fd ff ff       	jmp    4000037e <vprintfmt+0x21>

40000646 <.L40>:
			putch('0', putdat);
40000646:	83 ec 08             	sub    $0x8,%esp
40000649:	57                   	push   %edi
4000064a:	6a 30                	push   $0x30
4000064c:	ff d6                	call   *%esi
			putch('x', putdat);
4000064e:	83 c4 08             	add    $0x8,%esp
40000651:	57                   	push   %edi
40000652:	6a 78                	push   $0x78
40000654:	ff d6                	call   *%esi
				(uintptr_t) va_arg(ap, void *);
40000656:	8b 44 24 5c          	mov    0x5c(%esp),%eax
4000065a:	83 c0 04             	add    $0x4,%eax
4000065d:	89 44 24 5c          	mov    %eax,0x5c(%esp)
			num = (unsigned long long)
40000661:	8b 40 fc             	mov    -0x4(%eax),%eax
40000664:	ba 00 00 00 00       	mov    $0x0,%edx
			goto number;
40000669:	83 c4 10             	add    $0x10,%esp
			base = 16;
4000066c:	bb 10 00 00 00       	mov    $0x10,%ebx
			goto number;
40000671:	eb 92                	jmp    40000605 <.L42+0x12>

40000673 <.L43>:
40000673:	8b 54 24 18          	mov    0x18(%esp),%edx
			num = getuint(&ap, lflag);
40000677:	8d 44 24 4c          	lea    0x4c(%esp),%eax
4000067b:	e8 5c fc ff ff       	call   400002dc <getuint>
			base = 16;
40000680:	bb 10 00 00 00       	mov    $0x10,%ebx
40000685:	e9 7b ff ff ff       	jmp    40000605 <.L42+0x12>
			base = 10;
4000068a:	bb 0a 00 00 00       	mov    $0xa,%ebx
4000068f:	e9 71 ff ff ff       	jmp    40000605 <.L42+0x12>

40000694 <.L32>:
40000694:	8b 4c 24 08          	mov    0x8(%esp),%ecx
			putch(ch, putdat);
40000698:	83 ec 08             	sub    $0x8,%esp
4000069b:	57                   	push   %edi
4000069c:	51                   	push   %ecx
4000069d:	ff d6                	call   *%esi
			break;
4000069f:	83 c4 10             	add    $0x10,%esp
400006a2:	e9 d7 fc ff ff       	jmp    4000037e <vprintfmt+0x21>

400006a7 <.L29>:
			putch('%', putdat);
400006a7:	83 ec 08             	sub    $0x8,%esp
400006aa:	57                   	push   %edi
400006ab:	6a 25                	push   $0x25
400006ad:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
400006af:	83 c4 10             	add    $0x10,%esp
400006b2:	89 dd                	mov    %ebx,%ebp
400006b4:	80 7d ff 25          	cmpb   $0x25,-0x1(%ebp)
400006b8:	0f 84 c0 fc ff ff    	je     4000037e <vprintfmt+0x21>
400006be:	83 ed 01             	sub    $0x1,%ebp
400006c1:	eb f1                	jmp    400006b4 <.L29+0xd>
}
400006c3:	83 c4 2c             	add    $0x2c,%esp
400006c6:	5b                   	pop    %ebx
400006c7:	5e                   	pop    %esi
400006c8:	5f                   	pop    %edi
400006c9:	5d                   	pop    %ebp
400006ca:	c3                   	ret    

400006cb <printfmt>:
{
400006cb:	83 ec 0c             	sub    $0xc,%esp
	vprintfmt(putch, putdat, fmt, ap);
400006ce:	8d 44 24 1c          	lea    0x1c(%esp),%eax
400006d2:	50                   	push   %eax
400006d3:	ff 74 24 1c          	pushl  0x1c(%esp)
400006d7:	ff 74 24 1c          	pushl  0x1c(%esp)
400006db:	ff 74 24 1c          	pushl  0x1c(%esp)
400006df:	e8 79 fc ff ff       	call   4000035d <vprintfmt>
}
400006e4:	83 c4 1c             	add    $0x1c,%esp
400006e7:	c3                   	ret    

400006e8 <vsprintf>:

int
vsprintf(char *buf, const char *fmt, va_list ap)
{
400006e8:	83 ec 1c             	sub    $0x1c,%esp
400006eb:	e8 cd 00 00 00       	call   400007bd <__x86.get_pc_thunk.ax>
400006f0:	05 10 29 00 00       	add    $0x2910,%eax
	//assert(buf != NULL);
	struct sprintbuf b = {buf, (char*)(intptr_t)~0, 0};
400006f5:	8b 54 24 20          	mov    0x20(%esp),%edx
400006f9:	89 54 24 04          	mov    %edx,0x4(%esp)
400006fd:	c7 44 24 08 ff ff ff 	movl   $0xffffffff,0x8(%esp)
40000704:	ff 
40000705:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
4000070c:	00 

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
4000070d:	ff 74 24 28          	pushl  0x28(%esp)
40000711:	ff 74 24 28          	pushl  0x28(%esp)
40000715:	8d 54 24 0c          	lea    0xc(%esp),%edx
40000719:	52                   	push   %edx
4000071a:	8d 80 3c d3 ff ff    	lea    -0x2cc4(%eax),%eax
40000720:	50                   	push   %eax
40000721:	e8 37 fc ff ff       	call   4000035d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
40000726:	8b 44 24 14          	mov    0x14(%esp),%eax
4000072a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
}
4000072d:	8b 44 24 1c          	mov    0x1c(%esp),%eax
40000731:	83 c4 2c             	add    $0x2c,%esp
40000734:	c3                   	ret    

40000735 <sprintf>:

int
sprintf(char *buf, const char *fmt, ...)
{
40000735:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsprintf(buf, fmt, ap);
40000738:	8d 44 24 1c          	lea    0x1c(%esp),%eax
4000073c:	50                   	push   %eax
4000073d:	ff 74 24 1c          	pushl  0x1c(%esp)
40000741:	ff 74 24 1c          	pushl  0x1c(%esp)
40000745:	e8 9e ff ff ff       	call   400006e8 <vsprintf>
	va_end(ap);

	return rc;
}
4000074a:	83 c4 1c             	add    $0x1c,%esp
4000074d:	c3                   	ret    

4000074e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
4000074e:	83 ec 1c             	sub    $0x1c,%esp
40000751:	e8 6b 00 00 00       	call   400007c1 <__x86.get_pc_thunk.dx>
40000756:	81 c2 aa 28 00 00    	add    $0x28aa,%edx
4000075c:	8b 44 24 20          	mov    0x20(%esp),%eax
	//assert(buf != NULL && n > 0);
	struct sprintbuf b = {buf, buf+n-1, 0};
40000760:	89 44 24 04          	mov    %eax,0x4(%esp)
40000764:	8b 4c 24 24          	mov    0x24(%esp),%ecx
40000768:	8d 44 08 ff          	lea    -0x1(%eax,%ecx,1),%eax
4000076c:	89 44 24 08          	mov    %eax,0x8(%esp)
40000770:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
40000777:	00 

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
40000778:	ff 74 24 2c          	pushl  0x2c(%esp)
4000077c:	ff 74 24 2c          	pushl  0x2c(%esp)
40000780:	8d 44 24 0c          	lea    0xc(%esp),%eax
40000784:	50                   	push   %eax
40000785:	8d 82 3c d3 ff ff    	lea    -0x2cc4(%edx),%eax
4000078b:	50                   	push   %eax
4000078c:	e8 cc fb ff ff       	call   4000035d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
40000791:	8b 44 24 14          	mov    0x14(%esp),%eax
40000795:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
}
40000798:	8b 44 24 1c          	mov    0x1c(%esp),%eax
4000079c:	83 c4 2c             	add    $0x2c,%esp
4000079f:	c3                   	ret    

400007a0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
400007a0:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
400007a3:	8d 44 24 1c          	lea    0x1c(%esp),%eax
400007a7:	50                   	push   %eax
400007a8:	ff 74 24 1c          	pushl  0x1c(%esp)
400007ac:	ff 74 24 1c          	pushl  0x1c(%esp)
400007b0:	ff 74 24 1c          	pushl  0x1c(%esp)
400007b4:	e8 95 ff ff ff       	call   4000074e <vsnprintf>
	va_end(ap);

	return rc;
}
400007b9:	83 c4 1c             	add    $0x1c,%esp
400007bc:	c3                   	ret    

400007bd <__x86.get_pc_thunk.ax>:
400007bd:	8b 04 24             	mov    (%esp),%eax
400007c0:	c3                   	ret    

400007c1 <__x86.get_pc_thunk.dx>:
400007c1:	8b 14 24             	mov    (%esp),%edx
400007c4:	c3                   	ret    

400007c5 <__x86.get_pc_thunk.cx>:
400007c5:	8b 0c 24             	mov    (%esp),%ecx
400007c8:	c3                   	ret    

400007c9 <spawn>:

pid_t
spawn(uintptr_t exec, unsigned int quota)
{
	return sys_spawn(exec, quota);
}
400007c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
400007ce:	c3                   	ret    

400007cf <yield>:

void
yield(void)
{
	sys_yield();
}
400007cf:	f3 c3                	repz ret 

400007d1 <strlen>:
#include <string.h>
#include <types.h>

int
strlen(const char *s)
{
400007d1:	8b 54 24 04          	mov    0x4(%esp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
400007d5:	b8 00 00 00 00       	mov    $0x0,%eax
400007da:	eb 06                	jmp    400007e2 <strlen+0x11>
		n++;
400007dc:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
400007df:	83 c2 01             	add    $0x1,%edx
400007e2:	80 3a 00             	cmpb   $0x0,(%edx)
400007e5:	75 f5                	jne    400007dc <strlen+0xb>
	return n;
}
400007e7:	f3 c3                	repz ret 

400007e9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
400007e9:	8b 4c 24 04          	mov    0x4(%esp),%ecx
400007ed:	8b 54 24 08          	mov    0x8(%esp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
400007f1:	b8 00 00 00 00       	mov    $0x0,%eax
400007f6:	eb 09                	jmp    40000801 <strnlen+0x18>
		n++;
400007f8:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
400007fb:	83 c1 01             	add    $0x1,%ecx
400007fe:	83 ea 01             	sub    $0x1,%edx
40000801:	85 d2                	test   %edx,%edx
40000803:	74 05                	je     4000080a <strnlen+0x21>
40000805:	80 39 00             	cmpb   $0x0,(%ecx)
40000808:	75 ee                	jne    400007f8 <strnlen+0xf>
	return n;
}
4000080a:	f3 c3                	repz ret 

4000080c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
4000080c:	53                   	push   %ebx
4000080d:	8b 44 24 08          	mov    0x8(%esp),%eax
40000811:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
40000815:	89 c2                	mov    %eax,%edx
40000817:	0f b6 19             	movzbl (%ecx),%ebx
4000081a:	88 1a                	mov    %bl,(%edx)
4000081c:	8d 52 01             	lea    0x1(%edx),%edx
4000081f:	8d 49 01             	lea    0x1(%ecx),%ecx
40000822:	84 db                	test   %bl,%bl
40000824:	75 f1                	jne    40000817 <strcpy+0xb>
		/* do nothing */;
	return ret;
}
40000826:	5b                   	pop    %ebx
40000827:	c3                   	ret    

40000828 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size)
{
40000828:	55                   	push   %ebp
40000829:	57                   	push   %edi
4000082a:	56                   	push   %esi
4000082b:	53                   	push   %ebx
4000082c:	8b 6c 24 14          	mov    0x14(%esp),%ebp
40000830:	8b 5c 24 18          	mov    0x18(%esp),%ebx
40000834:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
40000838:	89 e9                	mov    %ebp,%ecx
4000083a:	ba 00 00 00 00       	mov    $0x0,%edx
4000083f:	eb 05                	jmp    40000846 <strncpy+0x1e>
40000841:	83 c2 01             	add    $0x1,%edx
		*dst++ = *src;
40000844:	89 f1                	mov    %esi,%ecx
	for (i = 0; i < size; i++) {
40000846:	39 fa                	cmp    %edi,%edx
40000848:	73 12                	jae    4000085c <strncpy+0x34>
		*dst++ = *src;
4000084a:	8d 71 01             	lea    0x1(%ecx),%esi
4000084d:	0f b6 03             	movzbl (%ebx),%eax
40000850:	88 01                	mov    %al,(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
40000852:	80 3b 00             	cmpb   $0x0,(%ebx)
40000855:	74 ea                	je     40000841 <strncpy+0x19>
			src++;
40000857:	83 c3 01             	add    $0x1,%ebx
4000085a:	eb e5                	jmp    40000841 <strncpy+0x19>
	}
	return ret;
}
4000085c:	89 e8                	mov    %ebp,%eax
4000085e:	5b                   	pop    %ebx
4000085f:	5e                   	pop    %esi
40000860:	5f                   	pop    %edi
40000861:	5d                   	pop    %ebp
40000862:	c3                   	ret    

40000863 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
40000863:	56                   	push   %esi
40000864:	53                   	push   %ebx
40000865:	8b 74 24 0c          	mov    0xc(%esp),%esi
40000869:	8b 4c 24 10          	mov    0x10(%esp),%ecx
4000086d:	8b 54 24 14          	mov    0x14(%esp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
40000871:	85 d2                	test   %edx,%edx
40000873:	74 04                	je     40000879 <strlcpy+0x16>
40000875:	89 f0                	mov    %esi,%eax
40000877:	eb 0c                	jmp    40000885 <strlcpy+0x22>
40000879:	89 f0                	mov    %esi,%eax
4000087b:	eb 17                	jmp    40000894 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
4000087d:	83 c1 01             	add    $0x1,%ecx
40000880:	88 18                	mov    %bl,(%eax)
40000882:	8d 40 01             	lea    0x1(%eax),%eax
		while (--size > 0 && *src != '\0')
40000885:	83 ea 01             	sub    $0x1,%edx
40000888:	74 07                	je     40000891 <strlcpy+0x2e>
4000088a:	0f b6 19             	movzbl (%ecx),%ebx
4000088d:	84 db                	test   %bl,%bl
4000088f:	75 ec                	jne    4000087d <strlcpy+0x1a>
		*dst = '\0';
40000891:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
40000894:	29 f0                	sub    %esi,%eax
}
40000896:	5b                   	pop    %ebx
40000897:	5e                   	pop    %esi
40000898:	c3                   	ret    

40000899 <strcmp>:

int
strcmp(const char *p, const char *q)
{
40000899:	8b 4c 24 04          	mov    0x4(%esp),%ecx
4000089d:	8b 54 24 08          	mov    0x8(%esp),%edx
	while (*p && *p == *q)
400008a1:	eb 06                	jmp    400008a9 <strcmp+0x10>
		p++, q++;
400008a3:	83 c1 01             	add    $0x1,%ecx
400008a6:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
400008a9:	0f b6 01             	movzbl (%ecx),%eax
400008ac:	84 c0                	test   %al,%al
400008ae:	74 04                	je     400008b4 <strcmp+0x1b>
400008b0:	3a 02                	cmp    (%edx),%al
400008b2:	74 ef                	je     400008a3 <strcmp+0xa>
	return (int) ((unsigned char) *p - (unsigned char) *q);
400008b4:	0f b6 c0             	movzbl %al,%eax
400008b7:	0f b6 12             	movzbl (%edx),%edx
400008ba:	29 d0                	sub    %edx,%eax
}
400008bc:	c3                   	ret    

400008bd <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
400008bd:	53                   	push   %ebx
400008be:	8b 54 24 08          	mov    0x8(%esp),%edx
400008c2:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
400008c6:	8b 44 24 10          	mov    0x10(%esp),%eax
	while (n > 0 && *p && *p == *q)
400008ca:	eb 09                	jmp    400008d5 <strncmp+0x18>
		n--, p++, q++;
400008cc:	83 e8 01             	sub    $0x1,%eax
400008cf:	83 c2 01             	add    $0x1,%edx
400008d2:	83 c1 01             	add    $0x1,%ecx
	while (n > 0 && *p && *p == *q)
400008d5:	85 c0                	test   %eax,%eax
400008d7:	74 0b                	je     400008e4 <strncmp+0x27>
400008d9:	0f b6 1a             	movzbl (%edx),%ebx
400008dc:	84 db                	test   %bl,%bl
400008de:	74 04                	je     400008e4 <strncmp+0x27>
400008e0:	3a 19                	cmp    (%ecx),%bl
400008e2:	74 e8                	je     400008cc <strncmp+0xf>
	if (n == 0)
400008e4:	85 c0                	test   %eax,%eax
400008e6:	74 0a                	je     400008f2 <strncmp+0x35>
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
400008e8:	0f b6 02             	movzbl (%edx),%eax
400008eb:	0f b6 11             	movzbl (%ecx),%edx
400008ee:	29 d0                	sub    %edx,%eax
}
400008f0:	5b                   	pop    %ebx
400008f1:	c3                   	ret    
		return 0;
400008f2:	b8 00 00 00 00       	mov    $0x0,%eax
400008f7:	eb f7                	jmp    400008f0 <strncmp+0x33>

400008f9 <strchr>:

char *
strchr(const char *s, char c)
{
400008f9:	8b 44 24 04          	mov    0x4(%esp),%eax
400008fd:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
	for (; *s; s++)
40000902:	0f b6 10             	movzbl (%eax),%edx
40000905:	84 d2                	test   %dl,%dl
40000907:	74 09                	je     40000912 <strchr+0x19>
		if (*s == c)
40000909:	38 ca                	cmp    %cl,%dl
4000090b:	74 0a                	je     40000917 <strchr+0x1e>
	for (; *s; s++)
4000090d:	83 c0 01             	add    $0x1,%eax
40000910:	eb f0                	jmp    40000902 <strchr+0x9>
			return (char *) s;
	return 0;
40000912:	b8 00 00 00 00       	mov    $0x0,%eax
}
40000917:	f3 c3                	repz ret 

40000919 <strfind>:

char *
strfind(const char *s, char c)
{
40000919:	8b 44 24 04          	mov    0x4(%esp),%eax
4000091d:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
	for (; *s; s++)
40000922:	0f b6 10             	movzbl (%eax),%edx
40000925:	84 d2                	test   %dl,%dl
40000927:	74 09                	je     40000932 <strfind+0x19>
		if (*s == c)
40000929:	38 ca                	cmp    %cl,%dl
4000092b:	74 05                	je     40000932 <strfind+0x19>
	for (; *s; s++)
4000092d:	83 c0 01             	add    $0x1,%eax
40000930:	eb f0                	jmp    40000922 <strfind+0x9>
			break;
	return (char *) s;
}
40000932:	f3 c3                	repz ret 

40000934 <strtol>:


long
strtol(const char *s, char **endptr, int base)
{
40000934:	55                   	push   %ebp
40000935:	57                   	push   %edi
40000936:	56                   	push   %esi
40000937:	53                   	push   %ebx
40000938:	83 ec 04             	sub    $0x4,%esp
4000093b:	8b 4c 24 18          	mov    0x18(%esp),%ecx
4000093f:	8b 74 24 1c          	mov    0x1c(%esp),%esi
40000943:	8b 44 24 20          	mov    0x20(%esp),%eax
40000947:	89 04 24             	mov    %eax,(%esp)
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
4000094a:	eb 03                	jmp    4000094f <strtol+0x1b>
		s++;
4000094c:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
4000094f:	0f b6 01             	movzbl (%ecx),%eax
40000952:	3c 20                	cmp    $0x20,%al
40000954:	0f 94 c3             	sete   %bl
40000957:	3c 09                	cmp    $0x9,%al
40000959:	0f 94 c2             	sete   %dl
4000095c:	08 d3                	or     %dl,%bl
4000095e:	75 ec                	jne    4000094c <strtol+0x18>

	// plus/minus sign
	if (*s == '+')
40000960:	3c 2b                	cmp    $0x2b,%al
40000962:	74 3f                	je     400009a3 <strtol+0x6f>
		s++;
	else if (*s == '-')
40000964:	3c 2d                	cmp    $0x2d,%al
40000966:	74 45                	je     400009ad <strtol+0x79>
	int neg = 0;
40000968:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
4000096d:	8b 04 24             	mov    (%esp),%eax
40000970:	85 c0                	test   %eax,%eax
40000972:	0f 94 c2             	sete   %dl
40000975:	83 f8 10             	cmp    $0x10,%eax
40000978:	0f 94 c0             	sete   %al
4000097b:	08 c2                	or     %al,%dl
4000097d:	74 05                	je     40000984 <strtol+0x50>
4000097f:	80 39 30             	cmpb   $0x30,(%ecx)
40000982:	74 33                	je     400009b7 <strtol+0x83>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
40000984:	83 3c 24 00          	cmpl   $0x0,(%esp)
40000988:	75 05                	jne    4000098f <strtol+0x5b>
4000098a:	80 39 30             	cmpb   $0x30,(%ecx)
4000098d:	74 3a                	je     400009c9 <strtol+0x95>
		s++, base = 8;
	else if (base == 0)
4000098f:	83 3c 24 00          	cmpl   $0x0,(%esp)
40000993:	75 07                	jne    4000099c <strtol+0x68>
		base = 10;
40000995:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
4000099c:	b8 00 00 00 00       	mov    $0x0,%eax
400009a1:	eb 51                	jmp    400009f4 <strtol+0xc0>
		s++;
400009a3:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
400009a6:	bf 00 00 00 00       	mov    $0x0,%edi
400009ab:	eb c0                	jmp    4000096d <strtol+0x39>
		s++, neg = 1;
400009ad:	83 c1 01             	add    $0x1,%ecx
400009b0:	bf 01 00 00 00       	mov    $0x1,%edi
400009b5:	eb b6                	jmp    4000096d <strtol+0x39>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
400009b7:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
400009bb:	75 c7                	jne    40000984 <strtol+0x50>
		s += 2, base = 16;
400009bd:	83 c1 02             	add    $0x2,%ecx
400009c0:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
400009c7:	eb d3                	jmp    4000099c <strtol+0x68>
		s++, base = 8;
400009c9:	83 c1 01             	add    $0x1,%ecx
400009cc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
400009d3:	eb c7                	jmp    4000099c <strtol+0x68>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
400009d5:	8d 6a 9f             	lea    -0x61(%edx),%ebp
400009d8:	89 eb                	mov    %ebp,%ebx
400009da:	80 fb 19             	cmp    $0x19,%bl
400009dd:	77 2a                	ja     40000a09 <strtol+0xd5>
			dig = *s - 'a' + 10;
400009df:	0f be d2             	movsbl %dl,%edx
400009e2:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
400009e5:	8b 1c 24             	mov    (%esp),%ebx
400009e8:	39 da                	cmp    %ebx,%edx
400009ea:	7d 2f                	jge    40000a1b <strtol+0xe7>
			break;
		s++, val = (val * base) + dig;
400009ec:	83 c1 01             	add    $0x1,%ecx
400009ef:	0f af c3             	imul   %ebx,%eax
400009f2:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
400009f4:	0f b6 11             	movzbl (%ecx),%edx
400009f7:	8d 6a d0             	lea    -0x30(%edx),%ebp
400009fa:	89 eb                	mov    %ebp,%ebx
400009fc:	80 fb 09             	cmp    $0x9,%bl
400009ff:	77 d4                	ja     400009d5 <strtol+0xa1>
			dig = *s - '0';
40000a01:	0f be d2             	movsbl %dl,%edx
40000a04:	83 ea 30             	sub    $0x30,%edx
40000a07:	eb dc                	jmp    400009e5 <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
40000a09:	8d 6a bf             	lea    -0x41(%edx),%ebp
40000a0c:	89 eb                	mov    %ebp,%ebx
40000a0e:	80 fb 19             	cmp    $0x19,%bl
40000a11:	77 08                	ja     40000a1b <strtol+0xe7>
			dig = *s - 'A' + 10;
40000a13:	0f be d2             	movsbl %dl,%edx
40000a16:	83 ea 37             	sub    $0x37,%edx
40000a19:	eb ca                	jmp    400009e5 <strtol+0xb1>
		// we don't properly detect overflow!
	}

	if (endptr)
40000a1b:	85 f6                	test   %esi,%esi
40000a1d:	74 02                	je     40000a21 <strtol+0xed>
		*endptr = (char *) s;
40000a1f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
40000a21:	85 ff                	test   %edi,%edi
40000a23:	74 02                	je     40000a27 <strtol+0xf3>
40000a25:	f7 d8                	neg    %eax
}
40000a27:	83 c4 04             	add    $0x4,%esp
40000a2a:	5b                   	pop    %ebx
40000a2b:	5e                   	pop    %esi
40000a2c:	5f                   	pop    %edi
40000a2d:	5d                   	pop    %ebp
40000a2e:	c3                   	ret    

40000a2f <memset>:

void *
memset(void *v, int c, size_t n)
{
40000a2f:	57                   	push   %edi
40000a30:	53                   	push   %ebx
40000a31:	8b 7c 24 0c          	mov    0xc(%esp),%edi
40000a35:	8b 4c 24 14          	mov    0x14(%esp),%ecx
	if (n == 0)
40000a39:	85 c9                	test   %ecx,%ecx
40000a3b:	74 14                	je     40000a51 <memset+0x22>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
40000a3d:	f7 c7 03 00 00 00    	test   $0x3,%edi
40000a43:	75 05                	jne    40000a4a <memset+0x1b>
40000a45:	f6 c1 03             	test   $0x3,%cl
40000a48:	74 0c                	je     40000a56 <memset+0x27>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
40000a4a:	8b 44 24 10          	mov    0x10(%esp),%eax
40000a4e:	fc                   	cld    
40000a4f:	f3 aa                	rep stos %al,%es:(%edi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
}
40000a51:	89 f8                	mov    %edi,%eax
40000a53:	5b                   	pop    %ebx
40000a54:	5f                   	pop    %edi
40000a55:	c3                   	ret    
		c &= 0xFF;
40000a56:	0f b6 44 24 10       	movzbl 0x10(%esp),%eax
		c = (c<<24)|(c<<16)|(c<<8)|c;
40000a5b:	89 c2                	mov    %eax,%edx
40000a5d:	c1 e2 18             	shl    $0x18,%edx
40000a60:	89 c3                	mov    %eax,%ebx
40000a62:	c1 e3 10             	shl    $0x10,%ebx
40000a65:	09 da                	or     %ebx,%edx
40000a67:	89 c3                	mov    %eax,%ebx
40000a69:	c1 e3 08             	shl    $0x8,%ebx
40000a6c:	09 da                	or     %ebx,%edx
40000a6e:	09 d0                	or     %edx,%eax
			     :: "D" (v), "a" (c), "c" (n/4)
40000a70:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
40000a73:	fc                   	cld    
40000a74:	f3 ab                	rep stos %eax,%es:(%edi)
40000a76:	eb d9                	jmp    40000a51 <memset+0x22>

40000a78 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
40000a78:	57                   	push   %edi
40000a79:	56                   	push   %esi
40000a7a:	8b 44 24 0c          	mov    0xc(%esp),%eax
40000a7e:	8b 74 24 10          	mov    0x10(%esp),%esi
40000a82:	8b 4c 24 14          	mov    0x14(%esp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
40000a86:	39 c6                	cmp    %eax,%esi
40000a88:	73 36                	jae    40000ac0 <memmove+0x48>
40000a8a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
40000a8d:	39 c2                	cmp    %eax,%edx
40000a8f:	76 2f                	jbe    40000ac0 <memmove+0x48>
		s += n;
		d += n;
40000a91:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
40000a94:	f6 c2 03             	test   $0x3,%dl
40000a97:	75 1b                	jne    40000ab4 <memmove+0x3c>
40000a99:	f7 c7 03 00 00 00    	test   $0x3,%edi
40000a9f:	75 13                	jne    40000ab4 <memmove+0x3c>
40000aa1:	f6 c1 03             	test   $0x3,%cl
40000aa4:	75 0e                	jne    40000ab4 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4)
40000aa6:	83 ef 04             	sub    $0x4,%edi
40000aa9:	8d 72 fc             	lea    -0x4(%edx),%esi
40000aac:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
40000aaf:	fd                   	std    
40000ab0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
40000ab2:	eb 09                	jmp    40000abd <memmove+0x45>
				     : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n)
40000ab4:	83 ef 01             	sub    $0x1,%edi
40000ab7:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
40000aba:	fd                   	std    
40000abb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				     : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
40000abd:	fc                   	cld    
40000abe:	eb 16                	jmp    40000ad6 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
40000ac0:	f7 c6 03 00 00 00    	test   $0x3,%esi
40000ac6:	75 09                	jne    40000ad1 <memmove+0x59>
40000ac8:	a8 03                	test   $0x3,%al
40000aca:	75 05                	jne    40000ad1 <memmove+0x59>
40000acc:	f6 c1 03             	test   $0x3,%cl
40000acf:	74 08                	je     40000ad9 <memmove+0x61>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4)
				     : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
40000ad1:	89 c7                	mov    %eax,%edi
40000ad3:	fc                   	cld    
40000ad4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				     :: "D" (d), "S" (s), "c" (n)
				     : "cc", "memory");
	}
	return dst;
}
40000ad6:	5e                   	pop    %esi
40000ad7:	5f                   	pop    %edi
40000ad8:	c3                   	ret    
				     :: "D" (d), "S" (s), "c" (n/4)
40000ad9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
40000adc:	89 c7                	mov    %eax,%edi
40000ade:	fc                   	cld    
40000adf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
40000ae1:	eb f3                	jmp    40000ad6 <memmove+0x5e>

40000ae3 <memcpy>:

void *
memcpy(void *dst, const void *src, size_t n)
{
	return memmove(dst, src, n);
40000ae3:	ff 74 24 0c          	pushl  0xc(%esp)
40000ae7:	ff 74 24 0c          	pushl  0xc(%esp)
40000aeb:	ff 74 24 0c          	pushl  0xc(%esp)
40000aef:	e8 84 ff ff ff       	call   40000a78 <memmove>
40000af4:	83 c4 0c             	add    $0xc,%esp
}
40000af7:	c3                   	ret    

40000af8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
40000af8:	56                   	push   %esi
40000af9:	53                   	push   %ebx
40000afa:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
40000afe:	8b 54 24 10          	mov    0x10(%esp),%edx
40000b02:	8b 44 24 14          	mov    0x14(%esp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
40000b06:	8d 70 ff             	lea    -0x1(%eax),%esi
40000b09:	85 c0                	test   %eax,%eax
40000b0b:	74 1c                	je     40000b29 <memcmp+0x31>
		if (*s1 != *s2)
40000b0d:	0f b6 01             	movzbl (%ecx),%eax
40000b10:	0f b6 1a             	movzbl (%edx),%ebx
40000b13:	38 d8                	cmp    %bl,%al
40000b15:	75 0a                	jne    40000b21 <memcmp+0x29>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
40000b17:	83 c1 01             	add    $0x1,%ecx
40000b1a:	83 c2 01             	add    $0x1,%edx
	while (n-- > 0) {
40000b1d:	89 f0                	mov    %esi,%eax
40000b1f:	eb e5                	jmp    40000b06 <memcmp+0xe>
			return (int) *s1 - (int) *s2;
40000b21:	0f b6 c0             	movzbl %al,%eax
40000b24:	0f b6 db             	movzbl %bl,%ebx
40000b27:	29 d8                	sub    %ebx,%eax
	}

	return 0;
}
40000b29:	5b                   	pop    %ebx
40000b2a:	5e                   	pop    %esi
40000b2b:	c3                   	ret    

40000b2c <memchr>:

void *
memchr(const void *s, int c, size_t n)
{
40000b2c:	8b 44 24 04          	mov    0x4(%esp),%eax
40000b30:	8b 4c 24 08          	mov    0x8(%esp),%ecx
	const void *ends = (const char *) s + n;
40000b34:	89 c2                	mov    %eax,%edx
40000b36:	03 54 24 0c          	add    0xc(%esp),%edx
	for (; s < ends; s++)
40000b3a:	39 d0                	cmp    %edx,%eax
40000b3c:	73 09                	jae    40000b47 <memchr+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
40000b3e:	38 08                	cmp    %cl,(%eax)
40000b40:	74 0a                	je     40000b4c <memchr+0x20>
	for (; s < ends; s++)
40000b42:	83 c0 01             	add    $0x1,%eax
40000b45:	eb f3                	jmp    40000b3a <memchr+0xe>
			return (void *) s;
	return NULL;
40000b47:	b8 00 00 00 00       	mov    $0x0,%eax
}
40000b4c:	f3 c3                	repz ret 

40000b4e <memzero>:

void *
memzero(void *v, size_t n)
{
	return memset(v, 0, n);
40000b4e:	ff 74 24 08          	pushl  0x8(%esp)
40000b52:	6a 00                	push   $0x0
40000b54:	ff 74 24 0c          	pushl  0xc(%esp)
40000b58:	e8 d2 fe ff ff       	call   40000a2f <memset>
40000b5d:	83 c4 0c             	add    $0xc,%esp
}
40000b60:	c3                   	ret    

40000b61 <main>:
#include <proc.h>
#include <stdio.h>
#include <syscall.h>

int main (int argc, char **argv)
{
40000b61:	8d 4c 24 04          	lea    0x4(%esp),%ecx
40000b65:	83 e4 f0             	and    $0xfffffff0,%esp
40000b68:	ff 71 fc             	pushl  -0x4(%ecx)
40000b6b:	55                   	push   %ebp
40000b6c:	89 e5                	mov    %esp,%ebp
40000b6e:	53                   	push   %ebx
40000b6f:	51                   	push   %ecx
40000b70:	e8 54 f5 ff ff       	call   400000c9 <__x86.get_pc_thunk.bx>
40000b75:	81 c3 8b 24 00 00    	add    $0x248b,%ebx
    printf("ding started.\n");
40000b7b:	83 ec 0c             	sub    $0xc,%esp
40000b7e:	8d 83 d0 df ff ff    	lea    -0x2030(%ebx),%eax
40000b84:	50                   	push   %eax
40000b85:	e8 68 f6 ff ff       	call   400001f2 <printf>
    unsigned int val = 300;
    unsigned int *addr = (unsigned int *)0xe0000000;
    printf("ding: the value at address %x: %d\n", addr, *addr);
40000b8a:	83 c4 0c             	add    $0xc,%esp
40000b8d:	ff 35 00 00 00 e0    	pushl  0xe0000000
40000b93:	68 00 00 00 e0       	push   $0xe0000000
40000b98:	8d 83 e0 df ff ff    	lea    -0x2020(%ebx),%eax
40000b9e:	50                   	push   %eax
40000b9f:	e8 4e f6 ff ff       	call   400001f2 <printf>
    printf("ding: writing the value %d to the address %x\n", val, addr);
40000ba4:	83 c4 0c             	add    $0xc,%esp
40000ba7:	68 00 00 00 e0       	push   $0xe0000000
40000bac:	68 2c 01 00 00       	push   $0x12c
40000bb1:	8d 83 04 e0 ff ff    	lea    -0x1ffc(%ebx),%eax
40000bb7:	50                   	push   %eax
40000bb8:	e8 35 f6 ff ff       	call   400001f2 <printf>
    *addr = val;
40000bbd:	c7 05 00 00 00 e0 2c 	movl   $0x12c,0xe0000000
40000bc4:	01 00 00 
    yield();
40000bc7:	e8 03 fc ff ff       	call   400007cf <yield>
    printf("ding: the new value at address %x: %d\n", addr, *addr);
40000bcc:	83 c4 0c             	add    $0xc,%esp
40000bcf:	ff 35 00 00 00 e0    	pushl  0xe0000000
40000bd5:	68 00 00 00 e0       	push   $0xe0000000
40000bda:	8d 83 34 e0 ff ff    	lea    -0x1fcc(%ebx),%eax
40000be0:	50                   	push   %eax
40000be1:	e8 0c f6 ff ff       	call   400001f2 <printf>
40000be6:	83 c4 10             	add    $0x10,%esp

    return 0;
}
40000be9:	b8 00 00 00 00       	mov    $0x0,%eax
40000bee:	8d 65 f8             	lea    -0x8(%ebp),%esp
40000bf1:	59                   	pop    %ecx
40000bf2:	5b                   	pop    %ebx
40000bf3:	5d                   	pop    %ebp
40000bf4:	8d 61 fc             	lea    -0x4(%ecx),%esp
40000bf7:	c3                   	ret    
40000bf8:	66 90                	xchg   %ax,%ax
40000bfa:	66 90                	xchg   %ax,%ax
40000bfc:	66 90                	xchg   %ax,%ax
40000bfe:	66 90                	xchg   %ax,%ax

40000c00 <__udivdi3>:
40000c00:	55                   	push   %ebp
40000c01:	57                   	push   %edi
40000c02:	56                   	push   %esi
40000c03:	53                   	push   %ebx
40000c04:	83 ec 1c             	sub    $0x1c,%esp
40000c07:	8b 54 24 3c          	mov    0x3c(%esp),%edx
40000c0b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
40000c0f:	8b 74 24 34          	mov    0x34(%esp),%esi
40000c13:	8b 5c 24 38          	mov    0x38(%esp),%ebx
40000c17:	85 d2                	test   %edx,%edx
40000c19:	75 35                	jne    40000c50 <__udivdi3+0x50>
40000c1b:	39 f3                	cmp    %esi,%ebx
40000c1d:	0f 87 bd 00 00 00    	ja     40000ce0 <__udivdi3+0xe0>
40000c23:	85 db                	test   %ebx,%ebx
40000c25:	89 d9                	mov    %ebx,%ecx
40000c27:	75 0b                	jne    40000c34 <__udivdi3+0x34>
40000c29:	b8 01 00 00 00       	mov    $0x1,%eax
40000c2e:	31 d2                	xor    %edx,%edx
40000c30:	f7 f3                	div    %ebx
40000c32:	89 c1                	mov    %eax,%ecx
40000c34:	31 d2                	xor    %edx,%edx
40000c36:	89 f0                	mov    %esi,%eax
40000c38:	f7 f1                	div    %ecx
40000c3a:	89 c6                	mov    %eax,%esi
40000c3c:	89 e8                	mov    %ebp,%eax
40000c3e:	89 f7                	mov    %esi,%edi
40000c40:	f7 f1                	div    %ecx
40000c42:	89 fa                	mov    %edi,%edx
40000c44:	83 c4 1c             	add    $0x1c,%esp
40000c47:	5b                   	pop    %ebx
40000c48:	5e                   	pop    %esi
40000c49:	5f                   	pop    %edi
40000c4a:	5d                   	pop    %ebp
40000c4b:	c3                   	ret    
40000c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000c50:	39 f2                	cmp    %esi,%edx
40000c52:	77 7c                	ja     40000cd0 <__udivdi3+0xd0>
40000c54:	0f bd fa             	bsr    %edx,%edi
40000c57:	83 f7 1f             	xor    $0x1f,%edi
40000c5a:	0f 84 98 00 00 00    	je     40000cf8 <__udivdi3+0xf8>
40000c60:	89 f9                	mov    %edi,%ecx
40000c62:	b8 20 00 00 00       	mov    $0x20,%eax
40000c67:	29 f8                	sub    %edi,%eax
40000c69:	d3 e2                	shl    %cl,%edx
40000c6b:	89 54 24 08          	mov    %edx,0x8(%esp)
40000c6f:	89 c1                	mov    %eax,%ecx
40000c71:	89 da                	mov    %ebx,%edx
40000c73:	d3 ea                	shr    %cl,%edx
40000c75:	8b 4c 24 08          	mov    0x8(%esp),%ecx
40000c79:	09 d1                	or     %edx,%ecx
40000c7b:	89 f2                	mov    %esi,%edx
40000c7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
40000c81:	89 f9                	mov    %edi,%ecx
40000c83:	d3 e3                	shl    %cl,%ebx
40000c85:	89 c1                	mov    %eax,%ecx
40000c87:	d3 ea                	shr    %cl,%edx
40000c89:	89 f9                	mov    %edi,%ecx
40000c8b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
40000c8f:	d3 e6                	shl    %cl,%esi
40000c91:	89 eb                	mov    %ebp,%ebx
40000c93:	89 c1                	mov    %eax,%ecx
40000c95:	d3 eb                	shr    %cl,%ebx
40000c97:	09 de                	or     %ebx,%esi
40000c99:	89 f0                	mov    %esi,%eax
40000c9b:	f7 74 24 08          	divl   0x8(%esp)
40000c9f:	89 d6                	mov    %edx,%esi
40000ca1:	89 c3                	mov    %eax,%ebx
40000ca3:	f7 64 24 0c          	mull   0xc(%esp)
40000ca7:	39 d6                	cmp    %edx,%esi
40000ca9:	72 0c                	jb     40000cb7 <__udivdi3+0xb7>
40000cab:	89 f9                	mov    %edi,%ecx
40000cad:	d3 e5                	shl    %cl,%ebp
40000caf:	39 c5                	cmp    %eax,%ebp
40000cb1:	73 5d                	jae    40000d10 <__udivdi3+0x110>
40000cb3:	39 d6                	cmp    %edx,%esi
40000cb5:	75 59                	jne    40000d10 <__udivdi3+0x110>
40000cb7:	8d 43 ff             	lea    -0x1(%ebx),%eax
40000cba:	31 ff                	xor    %edi,%edi
40000cbc:	89 fa                	mov    %edi,%edx
40000cbe:	83 c4 1c             	add    $0x1c,%esp
40000cc1:	5b                   	pop    %ebx
40000cc2:	5e                   	pop    %esi
40000cc3:	5f                   	pop    %edi
40000cc4:	5d                   	pop    %ebp
40000cc5:	c3                   	ret    
40000cc6:	8d 76 00             	lea    0x0(%esi),%esi
40000cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
40000cd0:	31 ff                	xor    %edi,%edi
40000cd2:	31 c0                	xor    %eax,%eax
40000cd4:	89 fa                	mov    %edi,%edx
40000cd6:	83 c4 1c             	add    $0x1c,%esp
40000cd9:	5b                   	pop    %ebx
40000cda:	5e                   	pop    %esi
40000cdb:	5f                   	pop    %edi
40000cdc:	5d                   	pop    %ebp
40000cdd:	c3                   	ret    
40000cde:	66 90                	xchg   %ax,%ax
40000ce0:	31 ff                	xor    %edi,%edi
40000ce2:	89 e8                	mov    %ebp,%eax
40000ce4:	89 f2                	mov    %esi,%edx
40000ce6:	f7 f3                	div    %ebx
40000ce8:	89 fa                	mov    %edi,%edx
40000cea:	83 c4 1c             	add    $0x1c,%esp
40000ced:	5b                   	pop    %ebx
40000cee:	5e                   	pop    %esi
40000cef:	5f                   	pop    %edi
40000cf0:	5d                   	pop    %ebp
40000cf1:	c3                   	ret    
40000cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000cf8:	39 f2                	cmp    %esi,%edx
40000cfa:	72 06                	jb     40000d02 <__udivdi3+0x102>
40000cfc:	31 c0                	xor    %eax,%eax
40000cfe:	39 eb                	cmp    %ebp,%ebx
40000d00:	77 d2                	ja     40000cd4 <__udivdi3+0xd4>
40000d02:	b8 01 00 00 00       	mov    $0x1,%eax
40000d07:	eb cb                	jmp    40000cd4 <__udivdi3+0xd4>
40000d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000d10:	89 d8                	mov    %ebx,%eax
40000d12:	31 ff                	xor    %edi,%edi
40000d14:	eb be                	jmp    40000cd4 <__udivdi3+0xd4>
40000d16:	66 90                	xchg   %ax,%ax
40000d18:	66 90                	xchg   %ax,%ax
40000d1a:	66 90                	xchg   %ax,%ax
40000d1c:	66 90                	xchg   %ax,%ax
40000d1e:	66 90                	xchg   %ax,%ax

40000d20 <__umoddi3>:
40000d20:	55                   	push   %ebp
40000d21:	57                   	push   %edi
40000d22:	56                   	push   %esi
40000d23:	53                   	push   %ebx
40000d24:	83 ec 1c             	sub    $0x1c,%esp
40000d27:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
40000d2b:	8b 74 24 30          	mov    0x30(%esp),%esi
40000d2f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
40000d33:	8b 7c 24 38          	mov    0x38(%esp),%edi
40000d37:	85 ed                	test   %ebp,%ebp
40000d39:	89 f0                	mov    %esi,%eax
40000d3b:	89 da                	mov    %ebx,%edx
40000d3d:	75 19                	jne    40000d58 <__umoddi3+0x38>
40000d3f:	39 df                	cmp    %ebx,%edi
40000d41:	0f 86 b1 00 00 00    	jbe    40000df8 <__umoddi3+0xd8>
40000d47:	f7 f7                	div    %edi
40000d49:	89 d0                	mov    %edx,%eax
40000d4b:	31 d2                	xor    %edx,%edx
40000d4d:	83 c4 1c             	add    $0x1c,%esp
40000d50:	5b                   	pop    %ebx
40000d51:	5e                   	pop    %esi
40000d52:	5f                   	pop    %edi
40000d53:	5d                   	pop    %ebp
40000d54:	c3                   	ret    
40000d55:	8d 76 00             	lea    0x0(%esi),%esi
40000d58:	39 dd                	cmp    %ebx,%ebp
40000d5a:	77 f1                	ja     40000d4d <__umoddi3+0x2d>
40000d5c:	0f bd cd             	bsr    %ebp,%ecx
40000d5f:	83 f1 1f             	xor    $0x1f,%ecx
40000d62:	89 4c 24 04          	mov    %ecx,0x4(%esp)
40000d66:	0f 84 b4 00 00 00    	je     40000e20 <__umoddi3+0x100>
40000d6c:	b8 20 00 00 00       	mov    $0x20,%eax
40000d71:	89 c2                	mov    %eax,%edx
40000d73:	8b 44 24 04          	mov    0x4(%esp),%eax
40000d77:	29 c2                	sub    %eax,%edx
40000d79:	89 c1                	mov    %eax,%ecx
40000d7b:	89 f8                	mov    %edi,%eax
40000d7d:	d3 e5                	shl    %cl,%ebp
40000d7f:	89 d1                	mov    %edx,%ecx
40000d81:	89 54 24 0c          	mov    %edx,0xc(%esp)
40000d85:	d3 e8                	shr    %cl,%eax
40000d87:	09 c5                	or     %eax,%ebp
40000d89:	8b 44 24 04          	mov    0x4(%esp),%eax
40000d8d:	89 c1                	mov    %eax,%ecx
40000d8f:	d3 e7                	shl    %cl,%edi
40000d91:	89 d1                	mov    %edx,%ecx
40000d93:	89 7c 24 08          	mov    %edi,0x8(%esp)
40000d97:	89 df                	mov    %ebx,%edi
40000d99:	d3 ef                	shr    %cl,%edi
40000d9b:	89 c1                	mov    %eax,%ecx
40000d9d:	89 f0                	mov    %esi,%eax
40000d9f:	d3 e3                	shl    %cl,%ebx
40000da1:	89 d1                	mov    %edx,%ecx
40000da3:	89 fa                	mov    %edi,%edx
40000da5:	d3 e8                	shr    %cl,%eax
40000da7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
40000dac:	09 d8                	or     %ebx,%eax
40000dae:	f7 f5                	div    %ebp
40000db0:	d3 e6                	shl    %cl,%esi
40000db2:	89 d1                	mov    %edx,%ecx
40000db4:	f7 64 24 08          	mull   0x8(%esp)
40000db8:	39 d1                	cmp    %edx,%ecx
40000dba:	89 c3                	mov    %eax,%ebx
40000dbc:	89 d7                	mov    %edx,%edi
40000dbe:	72 06                	jb     40000dc6 <__umoddi3+0xa6>
40000dc0:	75 0e                	jne    40000dd0 <__umoddi3+0xb0>
40000dc2:	39 c6                	cmp    %eax,%esi
40000dc4:	73 0a                	jae    40000dd0 <__umoddi3+0xb0>
40000dc6:	2b 44 24 08          	sub    0x8(%esp),%eax
40000dca:	19 ea                	sbb    %ebp,%edx
40000dcc:	89 d7                	mov    %edx,%edi
40000dce:	89 c3                	mov    %eax,%ebx
40000dd0:	89 ca                	mov    %ecx,%edx
40000dd2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
40000dd7:	29 de                	sub    %ebx,%esi
40000dd9:	19 fa                	sbb    %edi,%edx
40000ddb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
40000ddf:	89 d0                	mov    %edx,%eax
40000de1:	d3 e0                	shl    %cl,%eax
40000de3:	89 d9                	mov    %ebx,%ecx
40000de5:	d3 ee                	shr    %cl,%esi
40000de7:	d3 ea                	shr    %cl,%edx
40000de9:	09 f0                	or     %esi,%eax
40000deb:	83 c4 1c             	add    $0x1c,%esp
40000dee:	5b                   	pop    %ebx
40000def:	5e                   	pop    %esi
40000df0:	5f                   	pop    %edi
40000df1:	5d                   	pop    %ebp
40000df2:	c3                   	ret    
40000df3:	90                   	nop
40000df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000df8:	85 ff                	test   %edi,%edi
40000dfa:	89 f9                	mov    %edi,%ecx
40000dfc:	75 0b                	jne    40000e09 <__umoddi3+0xe9>
40000dfe:	b8 01 00 00 00       	mov    $0x1,%eax
40000e03:	31 d2                	xor    %edx,%edx
40000e05:	f7 f7                	div    %edi
40000e07:	89 c1                	mov    %eax,%ecx
40000e09:	89 d8                	mov    %ebx,%eax
40000e0b:	31 d2                	xor    %edx,%edx
40000e0d:	f7 f1                	div    %ecx
40000e0f:	89 f0                	mov    %esi,%eax
40000e11:	f7 f1                	div    %ecx
40000e13:	e9 31 ff ff ff       	jmp    40000d49 <__umoddi3+0x29>
40000e18:	90                   	nop
40000e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000e20:	39 dd                	cmp    %ebx,%ebp
40000e22:	72 08                	jb     40000e2c <__umoddi3+0x10c>
40000e24:	39 f7                	cmp    %esi,%edi
40000e26:	0f 87 21 ff ff ff    	ja     40000d4d <__umoddi3+0x2d>
40000e2c:	89 da                	mov    %ebx,%edx
40000e2e:	89 f0                	mov    %esi,%eax
40000e30:	29 f8                	sub    %edi,%eax
40000e32:	19 ea                	sbb    %ebp,%edx
40000e34:	e9 14 ff ff ff       	jmp    40000d4d <__umoddi3+0x2d>
