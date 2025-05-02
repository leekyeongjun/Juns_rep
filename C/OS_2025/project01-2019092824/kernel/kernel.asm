
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	64013103          	ld	sp,1600(sp) # 8000b640 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	04a000ef          	jal	80000060 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000022:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000026:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002a:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    8000002e:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000032:	577d                	li	a4,-1
    80000034:	177e                	slli	a4,a4,0x3f
    80000036:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80000038:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003c:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000040:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000044:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    80000048:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004c:	000f4737          	lui	a4,0xf4
    80000050:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000054:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000056:	14d79073          	csrw	stimecmp,a5
}
    8000005a:	6422                	ld	s0,8(sp)
    8000005c:	0141                	addi	sp,sp,16
    8000005e:	8082                	ret

0000000080000060 <start>:
{
    80000060:	1141                	addi	sp,sp,-16
    80000062:	e406                	sd	ra,8(sp)
    80000064:	e022                	sd	s0,0(sp)
    80000066:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000006c:	7779                	lui	a4,0xffffe
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd9bd7>
    80000072:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000074:	6705                	lui	a4,0x1
    80000076:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000007c:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000080:	00001797          	auipc	a5,0x1
    80000084:	de278793          	addi	a5,a5,-542 # 80000e62 <main>
    80000088:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000008c:	4781                	li	a5,0
    8000008e:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000092:	67c1                	lui	a5,0x10
    80000094:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80000096:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009a:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000009e:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000a2:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000a6:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000aa:	57fd                	li	a5,-1
    800000ac:	83a9                	srli	a5,a5,0xa
    800000ae:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b2:	47bd                	li	a5,15
    800000b4:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000b8:	f65ff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000bc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c4:	30200073          	mret
}
    800000c8:	60a2                	ld	ra,8(sp)
    800000ca:	6402                	ld	s0,0(sp)
    800000cc:	0141                	addi	sp,sp,16
    800000ce:	8082                	ret

00000000800000d0 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d0:	715d                	addi	sp,sp,-80
    800000d2:	e486                	sd	ra,72(sp)
    800000d4:	e0a2                	sd	s0,64(sp)
    800000d6:	f84a                	sd	s2,48(sp)
    800000d8:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800000da:	04c05263          	blez	a2,8000011e <consolewrite+0x4e>
    800000de:	fc26                	sd	s1,56(sp)
    800000e0:	f44e                	sd	s3,40(sp)
    800000e2:	f052                	sd	s4,32(sp)
    800000e4:	ec56                	sd	s5,24(sp)
    800000e6:	8a2a                	mv	s4,a0
    800000e8:	84ae                	mv	s1,a1
    800000ea:	89b2                	mv	s3,a2
    800000ec:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800000ee:	5afd                	li	s5,-1
    800000f0:	4685                	li	a3,1
    800000f2:	8626                	mv	a2,s1
    800000f4:	85d2                	mv	a1,s4
    800000f6:	fbf40513          	addi	a0,s0,-65
    800000fa:	7bb010ef          	jal	800020b4 <either_copyin>
    800000fe:	03550263          	beq	a0,s5,80000122 <consolewrite+0x52>
      break;
    uartputc(c);
    80000102:	fbf44503          	lbu	a0,-65(s0)
    80000106:	035000ef          	jal	8000093a <uartputc>
  for(i = 0; i < n; i++){
    8000010a:	2905                	addiw	s2,s2,1
    8000010c:	0485                	addi	s1,s1,1
    8000010e:	ff2991e3          	bne	s3,s2,800000f0 <consolewrite+0x20>
    80000112:	894e                	mv	s2,s3
    80000114:	74e2                	ld	s1,56(sp)
    80000116:	79a2                	ld	s3,40(sp)
    80000118:	7a02                	ld	s4,32(sp)
    8000011a:	6ae2                	ld	s5,24(sp)
    8000011c:	a039                	j	8000012a <consolewrite+0x5a>
    8000011e:	4901                	li	s2,0
    80000120:	a029                	j	8000012a <consolewrite+0x5a>
    80000122:	74e2                	ld	s1,56(sp)
    80000124:	79a2                	ld	s3,40(sp)
    80000126:	7a02                	ld	s4,32(sp)
    80000128:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    8000012a:	854a                	mv	a0,s2
    8000012c:	60a6                	ld	ra,72(sp)
    8000012e:	6406                	ld	s0,64(sp)
    80000130:	7942                	ld	s2,48(sp)
    80000132:	6161                	addi	sp,sp,80
    80000134:	8082                	ret

0000000080000136 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000136:	711d                	addi	sp,sp,-96
    80000138:	ec86                	sd	ra,88(sp)
    8000013a:	e8a2                	sd	s0,80(sp)
    8000013c:	e4a6                	sd	s1,72(sp)
    8000013e:	e0ca                	sd	s2,64(sp)
    80000140:	fc4e                	sd	s3,56(sp)
    80000142:	f852                	sd	s4,48(sp)
    80000144:	f456                	sd	s5,40(sp)
    80000146:	f05a                	sd	s6,32(sp)
    80000148:	1080                	addi	s0,sp,96
    8000014a:	8aaa                	mv	s5,a0
    8000014c:	8a2e                	mv	s4,a1
    8000014e:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000150:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000154:	00013517          	auipc	a0,0x13
    80000158:	55c50513          	addi	a0,a0,1372 # 800136b0 <cons>
    8000015c:	299000ef          	jal	80000bf4 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000160:	00013497          	auipc	s1,0x13
    80000164:	55048493          	addi	s1,s1,1360 # 800136b0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000168:	00013917          	auipc	s2,0x13
    8000016c:	5e090913          	addi	s2,s2,1504 # 80013748 <cons+0x98>
  while(n > 0){
    80000170:	0b305d63          	blez	s3,8000022a <consoleread+0xf4>
    while(cons.r == cons.w){
    80000174:	0984a783          	lw	a5,152(s1)
    80000178:	09c4a703          	lw	a4,156(s1)
    8000017c:	0af71263          	bne	a4,a5,80000220 <consoleread+0xea>
      if(killed(myproc())){
    80000180:	7ae010ef          	jal	8000192e <myproc>
    80000184:	5c3010ef          	jal	80001f46 <killed>
    80000188:	e12d                	bnez	a0,800001ea <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    8000018a:	85a6                	mv	a1,s1
    8000018c:	854a                	mv	a0,s2
    8000018e:	381010ef          	jal	80001d0e <sleep>
    while(cons.r == cons.w){
    80000192:	0984a783          	lw	a5,152(s1)
    80000196:	09c4a703          	lw	a4,156(s1)
    8000019a:	fef703e3          	beq	a4,a5,80000180 <consoleread+0x4a>
    8000019e:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001a0:	00013717          	auipc	a4,0x13
    800001a4:	51070713          	addi	a4,a4,1296 # 800136b0 <cons>
    800001a8:	0017869b          	addiw	a3,a5,1
    800001ac:	08d72c23          	sw	a3,152(a4)
    800001b0:	07f7f693          	andi	a3,a5,127
    800001b4:	9736                	add	a4,a4,a3
    800001b6:	01874703          	lbu	a4,24(a4)
    800001ba:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800001be:	4691                	li	a3,4
    800001c0:	04db8663          	beq	s7,a3,8000020c <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800001c4:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001c8:	4685                	li	a3,1
    800001ca:	faf40613          	addi	a2,s0,-81
    800001ce:	85d2                	mv	a1,s4
    800001d0:	8556                	mv	a0,s5
    800001d2:	699010ef          	jal	8000206a <either_copyout>
    800001d6:	57fd                	li	a5,-1
    800001d8:	04f50863          	beq	a0,a5,80000228 <consoleread+0xf2>
      break;

    dst++;
    800001dc:	0a05                	addi	s4,s4,1
    --n;
    800001de:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    800001e0:	47a9                	li	a5,10
    800001e2:	04fb8d63          	beq	s7,a5,8000023c <consoleread+0x106>
    800001e6:	6be2                	ld	s7,24(sp)
    800001e8:	b761                	j	80000170 <consoleread+0x3a>
        release(&cons.lock);
    800001ea:	00013517          	auipc	a0,0x13
    800001ee:	4c650513          	addi	a0,a0,1222 # 800136b0 <cons>
    800001f2:	29b000ef          	jal	80000c8c <release>
        return -1;
    800001f6:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    800001f8:	60e6                	ld	ra,88(sp)
    800001fa:	6446                	ld	s0,80(sp)
    800001fc:	64a6                	ld	s1,72(sp)
    800001fe:	6906                	ld	s2,64(sp)
    80000200:	79e2                	ld	s3,56(sp)
    80000202:	7a42                	ld	s4,48(sp)
    80000204:	7aa2                	ld	s5,40(sp)
    80000206:	7b02                	ld	s6,32(sp)
    80000208:	6125                	addi	sp,sp,96
    8000020a:	8082                	ret
      if(n < target){
    8000020c:	0009871b          	sext.w	a4,s3
    80000210:	01677a63          	bgeu	a4,s6,80000224 <consoleread+0xee>
        cons.r--;
    80000214:	00013717          	auipc	a4,0x13
    80000218:	52f72a23          	sw	a5,1332(a4) # 80013748 <cons+0x98>
    8000021c:	6be2                	ld	s7,24(sp)
    8000021e:	a031                	j	8000022a <consoleread+0xf4>
    80000220:	ec5e                	sd	s7,24(sp)
    80000222:	bfbd                	j	800001a0 <consoleread+0x6a>
    80000224:	6be2                	ld	s7,24(sp)
    80000226:	a011                	j	8000022a <consoleread+0xf4>
    80000228:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    8000022a:	00013517          	auipc	a0,0x13
    8000022e:	48650513          	addi	a0,a0,1158 # 800136b0 <cons>
    80000232:	25b000ef          	jal	80000c8c <release>
  return target - n;
    80000236:	413b053b          	subw	a0,s6,s3
    8000023a:	bf7d                	j	800001f8 <consoleread+0xc2>
    8000023c:	6be2                	ld	s7,24(sp)
    8000023e:	b7f5                	j	8000022a <consoleread+0xf4>

0000000080000240 <consputc>:
{
    80000240:	1141                	addi	sp,sp,-16
    80000242:	e406                	sd	ra,8(sp)
    80000244:	e022                	sd	s0,0(sp)
    80000246:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000248:	10000793          	li	a5,256
    8000024c:	00f50863          	beq	a0,a5,8000025c <consputc+0x1c>
    uartputc_sync(c);
    80000250:	604000ef          	jal	80000854 <uartputc_sync>
}
    80000254:	60a2                	ld	ra,8(sp)
    80000256:	6402                	ld	s0,0(sp)
    80000258:	0141                	addi	sp,sp,16
    8000025a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000025c:	4521                	li	a0,8
    8000025e:	5f6000ef          	jal	80000854 <uartputc_sync>
    80000262:	02000513          	li	a0,32
    80000266:	5ee000ef          	jal	80000854 <uartputc_sync>
    8000026a:	4521                	li	a0,8
    8000026c:	5e8000ef          	jal	80000854 <uartputc_sync>
    80000270:	b7d5                	j	80000254 <consputc+0x14>

0000000080000272 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80000272:	1101                	addi	sp,sp,-32
    80000274:	ec06                	sd	ra,24(sp)
    80000276:	e822                	sd	s0,16(sp)
    80000278:	e426                	sd	s1,8(sp)
    8000027a:	1000                	addi	s0,sp,32
    8000027c:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000027e:	00013517          	auipc	a0,0x13
    80000282:	43250513          	addi	a0,a0,1074 # 800136b0 <cons>
    80000286:	16f000ef          	jal	80000bf4 <acquire>

  switch(c){
    8000028a:	47d5                	li	a5,21
    8000028c:	08f48f63          	beq	s1,a5,8000032a <consoleintr+0xb8>
    80000290:	0297c563          	blt	a5,s1,800002ba <consoleintr+0x48>
    80000294:	47a1                	li	a5,8
    80000296:	0ef48463          	beq	s1,a5,8000037e <consoleintr+0x10c>
    8000029a:	47c1                	li	a5,16
    8000029c:	10f49563          	bne	s1,a5,800003a6 <consoleintr+0x134>
      setschedmode(1);
    }else{
      setschedmode(0);
    }
    */
    procdump();
    800002a0:	65f010ef          	jal	800020fe <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002a4:	00013517          	auipc	a0,0x13
    800002a8:	40c50513          	addi	a0,a0,1036 # 800136b0 <cons>
    800002ac:	1e1000ef          	jal	80000c8c <release>
}
    800002b0:	60e2                	ld	ra,24(sp)
    800002b2:	6442                	ld	s0,16(sp)
    800002b4:	64a2                	ld	s1,8(sp)
    800002b6:	6105                	addi	sp,sp,32
    800002b8:	8082                	ret
  switch(c){
    800002ba:	07f00793          	li	a5,127
    800002be:	0cf48063          	beq	s1,a5,8000037e <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002c2:	00013717          	auipc	a4,0x13
    800002c6:	3ee70713          	addi	a4,a4,1006 # 800136b0 <cons>
    800002ca:	0a072783          	lw	a5,160(a4)
    800002ce:	09872703          	lw	a4,152(a4)
    800002d2:	9f99                	subw	a5,a5,a4
    800002d4:	07f00713          	li	a4,127
    800002d8:	fcf766e3          	bltu	a4,a5,800002a4 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    800002dc:	47b5                	li	a5,13
    800002de:	0cf48763          	beq	s1,a5,800003ac <consoleintr+0x13a>
      consputc(c);
    800002e2:	8526                	mv	a0,s1
    800002e4:	f5dff0ef          	jal	80000240 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800002e8:	00013797          	auipc	a5,0x13
    800002ec:	3c878793          	addi	a5,a5,968 # 800136b0 <cons>
    800002f0:	0a07a683          	lw	a3,160(a5)
    800002f4:	0016871b          	addiw	a4,a3,1
    800002f8:	0007061b          	sext.w	a2,a4
    800002fc:	0ae7a023          	sw	a4,160(a5)
    80000300:	07f6f693          	andi	a3,a3,127
    80000304:	97b6                	add	a5,a5,a3
    80000306:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000030a:	47a9                	li	a5,10
    8000030c:	0cf48563          	beq	s1,a5,800003d6 <consoleintr+0x164>
    80000310:	4791                	li	a5,4
    80000312:	0cf48263          	beq	s1,a5,800003d6 <consoleintr+0x164>
    80000316:	00013797          	auipc	a5,0x13
    8000031a:	4327a783          	lw	a5,1074(a5) # 80013748 <cons+0x98>
    8000031e:	9f1d                	subw	a4,a4,a5
    80000320:	08000793          	li	a5,128
    80000324:	f8f710e3          	bne	a4,a5,800002a4 <consoleintr+0x32>
    80000328:	a07d                	j	800003d6 <consoleintr+0x164>
    8000032a:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000032c:	00013717          	auipc	a4,0x13
    80000330:	38470713          	addi	a4,a4,900 # 800136b0 <cons>
    80000334:	0a072783          	lw	a5,160(a4)
    80000338:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000033c:	00013497          	auipc	s1,0x13
    80000340:	37448493          	addi	s1,s1,884 # 800136b0 <cons>
    while(cons.e != cons.w &&
    80000344:	4929                	li	s2,10
    80000346:	02f70863          	beq	a4,a5,80000376 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000034a:	37fd                	addiw	a5,a5,-1
    8000034c:	07f7f713          	andi	a4,a5,127
    80000350:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80000352:	01874703          	lbu	a4,24(a4)
    80000356:	03270263          	beq	a4,s2,8000037a <consoleintr+0x108>
      cons.e--;
    8000035a:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    8000035e:	10000513          	li	a0,256
    80000362:	edfff0ef          	jal	80000240 <consputc>
    while(cons.e != cons.w &&
    80000366:	0a04a783          	lw	a5,160(s1)
    8000036a:	09c4a703          	lw	a4,156(s1)
    8000036e:	fcf71ee3          	bne	a4,a5,8000034a <consoleintr+0xd8>
    80000372:	6902                	ld	s2,0(sp)
    80000374:	bf05                	j	800002a4 <consoleintr+0x32>
    80000376:	6902                	ld	s2,0(sp)
    80000378:	b735                	j	800002a4 <consoleintr+0x32>
    8000037a:	6902                	ld	s2,0(sp)
    8000037c:	b725                	j	800002a4 <consoleintr+0x32>
    if(cons.e != cons.w){
    8000037e:	00013717          	auipc	a4,0x13
    80000382:	33270713          	addi	a4,a4,818 # 800136b0 <cons>
    80000386:	0a072783          	lw	a5,160(a4)
    8000038a:	09c72703          	lw	a4,156(a4)
    8000038e:	f0f70be3          	beq	a4,a5,800002a4 <consoleintr+0x32>
      cons.e--;
    80000392:	37fd                	addiw	a5,a5,-1
    80000394:	00013717          	auipc	a4,0x13
    80000398:	3af72e23          	sw	a5,956(a4) # 80013750 <cons+0xa0>
      consputc(BACKSPACE);
    8000039c:	10000513          	li	a0,256
    800003a0:	ea1ff0ef          	jal	80000240 <consputc>
    800003a4:	b701                	j	800002a4 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003a6:	ee048fe3          	beqz	s1,800002a4 <consoleintr+0x32>
    800003aa:	bf21                	j	800002c2 <consoleintr+0x50>
      consputc(c);
    800003ac:	4529                	li	a0,10
    800003ae:	e93ff0ef          	jal	80000240 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003b2:	00013797          	auipc	a5,0x13
    800003b6:	2fe78793          	addi	a5,a5,766 # 800136b0 <cons>
    800003ba:	0a07a703          	lw	a4,160(a5)
    800003be:	0017069b          	addiw	a3,a4,1
    800003c2:	0006861b          	sext.w	a2,a3
    800003c6:	0ad7a023          	sw	a3,160(a5)
    800003ca:	07f77713          	andi	a4,a4,127
    800003ce:	97ba                	add	a5,a5,a4
    800003d0:	4729                	li	a4,10
    800003d2:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800003d6:	00013797          	auipc	a5,0x13
    800003da:	36c7ab23          	sw	a2,886(a5) # 8001374c <cons+0x9c>
        wakeup(&cons.r);
    800003de:	00013517          	auipc	a0,0x13
    800003e2:	36a50513          	addi	a0,a0,874 # 80013748 <cons+0x98>
    800003e6:	175010ef          	jal	80001d5a <wakeup>
    800003ea:	bd6d                	j	800002a4 <consoleintr+0x32>

00000000800003ec <consoleinit>:

void
consoleinit(void)
{
    800003ec:	1141                	addi	sp,sp,-16
    800003ee:	e406                	sd	ra,8(sp)
    800003f0:	e022                	sd	s0,0(sp)
    800003f2:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800003f4:	00008597          	auipc	a1,0x8
    800003f8:	c0c58593          	addi	a1,a1,-1012 # 80008000 <etext>
    800003fc:	00013517          	auipc	a0,0x13
    80000400:	2b450513          	addi	a0,a0,692 # 800136b0 <cons>
    80000404:	770000ef          	jal	80000b74 <initlock>

  uartinit();
    80000408:	3f4000ef          	jal	800007fc <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000040c:	00023797          	auipc	a5,0x23
    80000410:	68478793          	addi	a5,a5,1668 # 80023a90 <devsw>
    80000414:	00000717          	auipc	a4,0x0
    80000418:	d2270713          	addi	a4,a4,-734 # 80000136 <consoleread>
    8000041c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000041e:	00000717          	auipc	a4,0x0
    80000422:	cb270713          	addi	a4,a4,-846 # 800000d0 <consolewrite>
    80000426:	ef98                	sd	a4,24(a5)
}
    80000428:	60a2                	ld	ra,8(sp)
    8000042a:	6402                	ld	s0,0(sp)
    8000042c:	0141                	addi	sp,sp,16
    8000042e:	8082                	ret

0000000080000430 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000430:	7179                	addi	sp,sp,-48
    80000432:	f406                	sd	ra,40(sp)
    80000434:	f022                	sd	s0,32(sp)
    80000436:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80000438:	c219                	beqz	a2,8000043e <printint+0xe>
    8000043a:	08054063          	bltz	a0,800004ba <printint+0x8a>
    x = -xx;
  else
    x = xx;
    8000043e:	4881                	li	a7,0
    80000440:	fd040693          	addi	a3,s0,-48

  i = 0;
    80000444:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80000446:	00008617          	auipc	a2,0x8
    8000044a:	3fa60613          	addi	a2,a2,1018 # 80008840 <digits>
    8000044e:	883e                	mv	a6,a5
    80000450:	2785                	addiw	a5,a5,1
    80000452:	02b57733          	remu	a4,a0,a1
    80000456:	9732                	add	a4,a4,a2
    80000458:	00074703          	lbu	a4,0(a4)
    8000045c:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80000460:	872a                	mv	a4,a0
    80000462:	02b55533          	divu	a0,a0,a1
    80000466:	0685                	addi	a3,a3,1
    80000468:	feb773e3          	bgeu	a4,a1,8000044e <printint+0x1e>

  if(sign)
    8000046c:	00088a63          	beqz	a7,80000480 <printint+0x50>
    buf[i++] = '-';
    80000470:	1781                	addi	a5,a5,-32
    80000472:	97a2                	add	a5,a5,s0
    80000474:	02d00713          	li	a4,45
    80000478:	fee78823          	sb	a4,-16(a5)
    8000047c:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    80000480:	02f05963          	blez	a5,800004b2 <printint+0x82>
    80000484:	ec26                	sd	s1,24(sp)
    80000486:	e84a                	sd	s2,16(sp)
    80000488:	fd040713          	addi	a4,s0,-48
    8000048c:	00f704b3          	add	s1,a4,a5
    80000490:	fff70913          	addi	s2,a4,-1
    80000494:	993e                	add	s2,s2,a5
    80000496:	37fd                	addiw	a5,a5,-1
    80000498:	1782                	slli	a5,a5,0x20
    8000049a:	9381                	srli	a5,a5,0x20
    8000049c:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800004a0:	fff4c503          	lbu	a0,-1(s1)
    800004a4:	d9dff0ef          	jal	80000240 <consputc>
  while(--i >= 0)
    800004a8:	14fd                	addi	s1,s1,-1
    800004aa:	ff249be3          	bne	s1,s2,800004a0 <printint+0x70>
    800004ae:	64e2                	ld	s1,24(sp)
    800004b0:	6942                	ld	s2,16(sp)
}
    800004b2:	70a2                	ld	ra,40(sp)
    800004b4:	7402                	ld	s0,32(sp)
    800004b6:	6145                	addi	sp,sp,48
    800004b8:	8082                	ret
    x = -xx;
    800004ba:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800004be:	4885                	li	a7,1
    x = -xx;
    800004c0:	b741                	j	80000440 <printint+0x10>

00000000800004c2 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800004c2:	7155                	addi	sp,sp,-208
    800004c4:	e506                	sd	ra,136(sp)
    800004c6:	e122                	sd	s0,128(sp)
    800004c8:	f0d2                	sd	s4,96(sp)
    800004ca:	0900                	addi	s0,sp,144
    800004cc:	8a2a                	mv	s4,a0
    800004ce:	e40c                	sd	a1,8(s0)
    800004d0:	e810                	sd	a2,16(s0)
    800004d2:	ec14                	sd	a3,24(s0)
    800004d4:	f018                	sd	a4,32(s0)
    800004d6:	f41c                	sd	a5,40(s0)
    800004d8:	03043823          	sd	a6,48(s0)
    800004dc:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800004e0:	00013797          	auipc	a5,0x13
    800004e4:	2907a783          	lw	a5,656(a5) # 80013770 <pr+0x18>
    800004e8:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800004ec:	e3a1                	bnez	a5,8000052c <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800004ee:	00840793          	addi	a5,s0,8
    800004f2:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800004f6:	00054503          	lbu	a0,0(a0)
    800004fa:	26050763          	beqz	a0,80000768 <printf+0x2a6>
    800004fe:	fca6                	sd	s1,120(sp)
    80000500:	f8ca                	sd	s2,112(sp)
    80000502:	f4ce                	sd	s3,104(sp)
    80000504:	ecd6                	sd	s5,88(sp)
    80000506:	e8da                	sd	s6,80(sp)
    80000508:	e0e2                	sd	s8,64(sp)
    8000050a:	fc66                	sd	s9,56(sp)
    8000050c:	f86a                	sd	s10,48(sp)
    8000050e:	f46e                	sd	s11,40(sp)
    80000510:	4981                	li	s3,0
    if(cx != '%'){
    80000512:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80000516:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    8000051a:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000051e:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80000522:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80000526:	07000d93          	li	s11,112
    8000052a:	a815                	j	8000055e <printf+0x9c>
    acquire(&pr.lock);
    8000052c:	00013517          	auipc	a0,0x13
    80000530:	22c50513          	addi	a0,a0,556 # 80013758 <pr>
    80000534:	6c0000ef          	jal	80000bf4 <acquire>
  va_start(ap, fmt);
    80000538:	00840793          	addi	a5,s0,8
    8000053c:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000540:	000a4503          	lbu	a0,0(s4)
    80000544:	fd4d                	bnez	a0,800004fe <printf+0x3c>
    80000546:	a481                	j	80000786 <printf+0x2c4>
      consputc(cx);
    80000548:	cf9ff0ef          	jal	80000240 <consputc>
      continue;
    8000054c:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000054e:	0014899b          	addiw	s3,s1,1
    80000552:	013a07b3          	add	a5,s4,s3
    80000556:	0007c503          	lbu	a0,0(a5)
    8000055a:	1e050b63          	beqz	a0,80000750 <printf+0x28e>
    if(cx != '%'){
    8000055e:	ff5515e3          	bne	a0,s5,80000548 <printf+0x86>
    i++;
    80000562:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80000566:	009a07b3          	add	a5,s4,s1
    8000056a:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    8000056e:	1e090163          	beqz	s2,80000750 <printf+0x28e>
    80000572:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80000576:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80000578:	c789                	beqz	a5,80000582 <printf+0xc0>
    8000057a:	009a0733          	add	a4,s4,s1
    8000057e:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80000582:	03690763          	beq	s2,s6,800005b0 <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    80000586:	05890163          	beq	s2,s8,800005c8 <printf+0x106>
    } else if(c0 == 'u'){
    8000058a:	0d990b63          	beq	s2,s9,80000660 <printf+0x19e>
    } else if(c0 == 'x'){
    8000058e:	13a90163          	beq	s2,s10,800006b0 <printf+0x1ee>
    } else if(c0 == 'p'){
    80000592:	13b90b63          	beq	s2,s11,800006c8 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    80000596:	07300793          	li	a5,115
    8000059a:	16f90a63          	beq	s2,a5,8000070e <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    8000059e:	1b590463          	beq	s2,s5,80000746 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800005a2:	8556                	mv	a0,s5
    800005a4:	c9dff0ef          	jal	80000240 <consputc>
      consputc(c0);
    800005a8:	854a                	mv	a0,s2
    800005aa:	c97ff0ef          	jal	80000240 <consputc>
    800005ae:	b745                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    800005b0:	f8843783          	ld	a5,-120(s0)
    800005b4:	00878713          	addi	a4,a5,8
    800005b8:	f8e43423          	sd	a4,-120(s0)
    800005bc:	4605                	li	a2,1
    800005be:	45a9                	li	a1,10
    800005c0:	4388                	lw	a0,0(a5)
    800005c2:	e6fff0ef          	jal	80000430 <printint>
    800005c6:	b761                	j	8000054e <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    800005c8:	03678663          	beq	a5,s6,800005f4 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005cc:	05878263          	beq	a5,s8,80000610 <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    800005d0:	0b978463          	beq	a5,s9,80000678 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    800005d4:	fda797e3          	bne	a5,s10,800005a2 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    800005d8:	f8843783          	ld	a5,-120(s0)
    800005dc:	00878713          	addi	a4,a5,8
    800005e0:	f8e43423          	sd	a4,-120(s0)
    800005e4:	4601                	li	a2,0
    800005e6:	45c1                	li	a1,16
    800005e8:	6388                	ld	a0,0(a5)
    800005ea:	e47ff0ef          	jal	80000430 <printint>
      i += 1;
    800005ee:	0029849b          	addiw	s1,s3,2
    800005f2:	bfb1                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800005f4:	f8843783          	ld	a5,-120(s0)
    800005f8:	00878713          	addi	a4,a5,8
    800005fc:	f8e43423          	sd	a4,-120(s0)
    80000600:	4605                	li	a2,1
    80000602:	45a9                	li	a1,10
    80000604:	6388                	ld	a0,0(a5)
    80000606:	e2bff0ef          	jal	80000430 <printint>
      i += 1;
    8000060a:	0029849b          	addiw	s1,s3,2
    8000060e:	b781                	j	8000054e <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80000610:	06400793          	li	a5,100
    80000614:	02f68863          	beq	a3,a5,80000644 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80000618:	07500793          	li	a5,117
    8000061c:	06f68c63          	beq	a3,a5,80000694 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80000620:	07800793          	li	a5,120
    80000624:	f6f69fe3          	bne	a3,a5,800005a2 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80000628:	f8843783          	ld	a5,-120(s0)
    8000062c:	00878713          	addi	a4,a5,8
    80000630:	f8e43423          	sd	a4,-120(s0)
    80000634:	4601                	li	a2,0
    80000636:	45c1                	li	a1,16
    80000638:	6388                	ld	a0,0(a5)
    8000063a:	df7ff0ef          	jal	80000430 <printint>
      i += 2;
    8000063e:	0039849b          	addiw	s1,s3,3
    80000642:	b731                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80000644:	f8843783          	ld	a5,-120(s0)
    80000648:	00878713          	addi	a4,a5,8
    8000064c:	f8e43423          	sd	a4,-120(s0)
    80000650:	4605                	li	a2,1
    80000652:	45a9                	li	a1,10
    80000654:	6388                	ld	a0,0(a5)
    80000656:	ddbff0ef          	jal	80000430 <printint>
      i += 2;
    8000065a:	0039849b          	addiw	s1,s3,3
    8000065e:	bdc5                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    80000660:	f8843783          	ld	a5,-120(s0)
    80000664:	00878713          	addi	a4,a5,8
    80000668:	f8e43423          	sd	a4,-120(s0)
    8000066c:	4601                	li	a2,0
    8000066e:	45a9                	li	a1,10
    80000670:	4388                	lw	a0,0(a5)
    80000672:	dbfff0ef          	jal	80000430 <printint>
    80000676:	bde1                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80000678:	f8843783          	ld	a5,-120(s0)
    8000067c:	00878713          	addi	a4,a5,8
    80000680:	f8e43423          	sd	a4,-120(s0)
    80000684:	4601                	li	a2,0
    80000686:	45a9                	li	a1,10
    80000688:	6388                	ld	a0,0(a5)
    8000068a:	da7ff0ef          	jal	80000430 <printint>
      i += 1;
    8000068e:	0029849b          	addiw	s1,s3,2
    80000692:	bd75                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80000694:	f8843783          	ld	a5,-120(s0)
    80000698:	00878713          	addi	a4,a5,8
    8000069c:	f8e43423          	sd	a4,-120(s0)
    800006a0:	4601                	li	a2,0
    800006a2:	45a9                	li	a1,10
    800006a4:	6388                	ld	a0,0(a5)
    800006a6:	d8bff0ef          	jal	80000430 <printint>
      i += 2;
    800006aa:	0039849b          	addiw	s1,s3,3
    800006ae:	b545                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    800006b0:	f8843783          	ld	a5,-120(s0)
    800006b4:	00878713          	addi	a4,a5,8
    800006b8:	f8e43423          	sd	a4,-120(s0)
    800006bc:	4601                	li	a2,0
    800006be:	45c1                	li	a1,16
    800006c0:	4388                	lw	a0,0(a5)
    800006c2:	d6fff0ef          	jal	80000430 <printint>
    800006c6:	b561                	j	8000054e <printf+0x8c>
    800006c8:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    800006ca:	f8843783          	ld	a5,-120(s0)
    800006ce:	00878713          	addi	a4,a5,8
    800006d2:	f8e43423          	sd	a4,-120(s0)
    800006d6:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006da:	03000513          	li	a0,48
    800006de:	b63ff0ef          	jal	80000240 <consputc>
  consputc('x');
    800006e2:	07800513          	li	a0,120
    800006e6:	b5bff0ef          	jal	80000240 <consputc>
    800006ea:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006ec:	00008b97          	auipc	s7,0x8
    800006f0:	154b8b93          	addi	s7,s7,340 # 80008840 <digits>
    800006f4:	03c9d793          	srli	a5,s3,0x3c
    800006f8:	97de                	add	a5,a5,s7
    800006fa:	0007c503          	lbu	a0,0(a5)
    800006fe:	b43ff0ef          	jal	80000240 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80000702:	0992                	slli	s3,s3,0x4
    80000704:	397d                	addiw	s2,s2,-1
    80000706:	fe0917e3          	bnez	s2,800006f4 <printf+0x232>
    8000070a:	6ba6                	ld	s7,72(sp)
    8000070c:	b589                	j	8000054e <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    8000070e:	f8843783          	ld	a5,-120(s0)
    80000712:	00878713          	addi	a4,a5,8
    80000716:	f8e43423          	sd	a4,-120(s0)
    8000071a:	0007b903          	ld	s2,0(a5)
    8000071e:	00090d63          	beqz	s2,80000738 <printf+0x276>
      for(; *s; s++)
    80000722:	00094503          	lbu	a0,0(s2)
    80000726:	e20504e3          	beqz	a0,8000054e <printf+0x8c>
        consputc(*s);
    8000072a:	b17ff0ef          	jal	80000240 <consputc>
      for(; *s; s++)
    8000072e:	0905                	addi	s2,s2,1
    80000730:	00094503          	lbu	a0,0(s2)
    80000734:	f97d                	bnez	a0,8000072a <printf+0x268>
    80000736:	bd21                	j	8000054e <printf+0x8c>
        s = "(null)";
    80000738:	00008917          	auipc	s2,0x8
    8000073c:	8d090913          	addi	s2,s2,-1840 # 80008008 <etext+0x8>
      for(; *s; s++)
    80000740:	02800513          	li	a0,40
    80000744:	b7dd                	j	8000072a <printf+0x268>
      consputc('%');
    80000746:	02500513          	li	a0,37
    8000074a:	af7ff0ef          	jal	80000240 <consputc>
    8000074e:	b501                	j	8000054e <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    80000750:	f7843783          	ld	a5,-136(s0)
    80000754:	e385                	bnez	a5,80000774 <printf+0x2b2>
    80000756:	74e6                	ld	s1,120(sp)
    80000758:	7946                	ld	s2,112(sp)
    8000075a:	79a6                	ld	s3,104(sp)
    8000075c:	6ae6                	ld	s5,88(sp)
    8000075e:	6b46                	ld	s6,80(sp)
    80000760:	6c06                	ld	s8,64(sp)
    80000762:	7ce2                	ld	s9,56(sp)
    80000764:	7d42                	ld	s10,48(sp)
    80000766:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    80000768:	4501                	li	a0,0
    8000076a:	60aa                	ld	ra,136(sp)
    8000076c:	640a                	ld	s0,128(sp)
    8000076e:	7a06                	ld	s4,96(sp)
    80000770:	6169                	addi	sp,sp,208
    80000772:	8082                	ret
    80000774:	74e6                	ld	s1,120(sp)
    80000776:	7946                	ld	s2,112(sp)
    80000778:	79a6                	ld	s3,104(sp)
    8000077a:	6ae6                	ld	s5,88(sp)
    8000077c:	6b46                	ld	s6,80(sp)
    8000077e:	6c06                	ld	s8,64(sp)
    80000780:	7ce2                	ld	s9,56(sp)
    80000782:	7d42                	ld	s10,48(sp)
    80000784:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80000786:	00013517          	auipc	a0,0x13
    8000078a:	fd250513          	addi	a0,a0,-46 # 80013758 <pr>
    8000078e:	4fe000ef          	jal	80000c8c <release>
    80000792:	bfd9                	j	80000768 <printf+0x2a6>

0000000080000794 <panic>:

void
panic(char *s)
{
    80000794:	1101                	addi	sp,sp,-32
    80000796:	ec06                	sd	ra,24(sp)
    80000798:	e822                	sd	s0,16(sp)
    8000079a:	e426                	sd	s1,8(sp)
    8000079c:	1000                	addi	s0,sp,32
    8000079e:	84aa                	mv	s1,a0
  pr.locking = 0;
    800007a0:	00013797          	auipc	a5,0x13
    800007a4:	fc07a823          	sw	zero,-48(a5) # 80013770 <pr+0x18>
  printf("panic: ");
    800007a8:	00008517          	auipc	a0,0x8
    800007ac:	87050513          	addi	a0,a0,-1936 # 80008018 <etext+0x18>
    800007b0:	d13ff0ef          	jal	800004c2 <printf>
  printf("%s\n", s);
    800007b4:	85a6                	mv	a1,s1
    800007b6:	00008517          	auipc	a0,0x8
    800007ba:	86a50513          	addi	a0,a0,-1942 # 80008020 <etext+0x20>
    800007be:	d05ff0ef          	jal	800004c2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800007c2:	4785                	li	a5,1
    800007c4:	0000b717          	auipc	a4,0xb
    800007c8:	e8f72e23          	sw	a5,-356(a4) # 8000b660 <panicked>
  for(;;)
    800007cc:	a001                	j	800007cc <panic+0x38>

00000000800007ce <printfinit>:
    ;
}

void
printfinit(void)
{
    800007ce:	1101                	addi	sp,sp,-32
    800007d0:	ec06                	sd	ra,24(sp)
    800007d2:	e822                	sd	s0,16(sp)
    800007d4:	e426                	sd	s1,8(sp)
    800007d6:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800007d8:	00013497          	auipc	s1,0x13
    800007dc:	f8048493          	addi	s1,s1,-128 # 80013758 <pr>
    800007e0:	00008597          	auipc	a1,0x8
    800007e4:	84858593          	addi	a1,a1,-1976 # 80008028 <etext+0x28>
    800007e8:	8526                	mv	a0,s1
    800007ea:	38a000ef          	jal	80000b74 <initlock>
  pr.locking = 1;
    800007ee:	4785                	li	a5,1
    800007f0:	cc9c                	sw	a5,24(s1)
}
    800007f2:	60e2                	ld	ra,24(sp)
    800007f4:	6442                	ld	s0,16(sp)
    800007f6:	64a2                	ld	s1,8(sp)
    800007f8:	6105                	addi	sp,sp,32
    800007fa:	8082                	ret

00000000800007fc <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007fc:	1141                	addi	sp,sp,-16
    800007fe:	e406                	sd	ra,8(sp)
    80000800:	e022                	sd	s0,0(sp)
    80000802:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80000804:	100007b7          	lui	a5,0x10000
    80000808:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000080c:	10000737          	lui	a4,0x10000
    80000810:	f8000693          	li	a3,-128
    80000814:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000818:	468d                	li	a3,3
    8000081a:	10000637          	lui	a2,0x10000
    8000081e:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000822:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000826:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000082a:	10000737          	lui	a4,0x10000
    8000082e:	461d                	li	a2,7
    80000830:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80000834:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000838:	00007597          	auipc	a1,0x7
    8000083c:	7f858593          	addi	a1,a1,2040 # 80008030 <etext+0x30>
    80000840:	00013517          	auipc	a0,0x13
    80000844:	f3850513          	addi	a0,a0,-200 # 80013778 <uart_tx_lock>
    80000848:	32c000ef          	jal	80000b74 <initlock>
}
    8000084c:	60a2                	ld	ra,8(sp)
    8000084e:	6402                	ld	s0,0(sp)
    80000850:	0141                	addi	sp,sp,16
    80000852:	8082                	ret

0000000080000854 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000854:	1101                	addi	sp,sp,-32
    80000856:	ec06                	sd	ra,24(sp)
    80000858:	e822                	sd	s0,16(sp)
    8000085a:	e426                	sd	s1,8(sp)
    8000085c:	1000                	addi	s0,sp,32
    8000085e:	84aa                	mv	s1,a0
  push_off();
    80000860:	354000ef          	jal	80000bb4 <push_off>

  if(panicked){
    80000864:	0000b797          	auipc	a5,0xb
    80000868:	dfc7a783          	lw	a5,-516(a5) # 8000b660 <panicked>
    8000086c:	e795                	bnez	a5,80000898 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000086e:	10000737          	lui	a4,0x10000
    80000872:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000874:	00074783          	lbu	a5,0(a4)
    80000878:	0207f793          	andi	a5,a5,32
    8000087c:	dfe5                	beqz	a5,80000874 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    8000087e:	0ff4f513          	zext.b	a0,s1
    80000882:	100007b7          	lui	a5,0x10000
    80000886:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000088a:	3ae000ef          	jal	80000c38 <pop_off>
}
    8000088e:	60e2                	ld	ra,24(sp)
    80000890:	6442                	ld	s0,16(sp)
    80000892:	64a2                	ld	s1,8(sp)
    80000894:	6105                	addi	sp,sp,32
    80000896:	8082                	ret
    for(;;)
    80000898:	a001                	j	80000898 <uartputc_sync+0x44>

000000008000089a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000089a:	0000b797          	auipc	a5,0xb
    8000089e:	dce7b783          	ld	a5,-562(a5) # 8000b668 <uart_tx_r>
    800008a2:	0000b717          	auipc	a4,0xb
    800008a6:	dce73703          	ld	a4,-562(a4) # 8000b670 <uart_tx_w>
    800008aa:	08f70263          	beq	a4,a5,8000092e <uartstart+0x94>
{
    800008ae:	7139                	addi	sp,sp,-64
    800008b0:	fc06                	sd	ra,56(sp)
    800008b2:	f822                	sd	s0,48(sp)
    800008b4:	f426                	sd	s1,40(sp)
    800008b6:	f04a                	sd	s2,32(sp)
    800008b8:	ec4e                	sd	s3,24(sp)
    800008ba:	e852                	sd	s4,16(sp)
    800008bc:	e456                	sd	s5,8(sp)
    800008be:	e05a                	sd	s6,0(sp)
    800008c0:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008c2:	10000937          	lui	s2,0x10000
    800008c6:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008c8:	00013a97          	auipc	s5,0x13
    800008cc:	eb0a8a93          	addi	s5,s5,-336 # 80013778 <uart_tx_lock>
    uart_tx_r += 1;
    800008d0:	0000b497          	auipc	s1,0xb
    800008d4:	d9848493          	addi	s1,s1,-616 # 8000b668 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008d8:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008dc:	0000b997          	auipc	s3,0xb
    800008e0:	d9498993          	addi	s3,s3,-620 # 8000b670 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008e4:	00094703          	lbu	a4,0(s2)
    800008e8:	02077713          	andi	a4,a4,32
    800008ec:	c71d                	beqz	a4,8000091a <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008ee:	01f7f713          	andi	a4,a5,31
    800008f2:	9756                	add	a4,a4,s5
    800008f4:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800008f8:	0785                	addi	a5,a5,1
    800008fa:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800008fc:	8526                	mv	a0,s1
    800008fe:	45c010ef          	jal	80001d5a <wakeup>
    WriteReg(THR, c);
    80000902:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80000906:	609c                	ld	a5,0(s1)
    80000908:	0009b703          	ld	a4,0(s3)
    8000090c:	fcf71ce3          	bne	a4,a5,800008e4 <uartstart+0x4a>
      ReadReg(ISR);
    80000910:	100007b7          	lui	a5,0x10000
    80000914:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000916:	0007c783          	lbu	a5,0(a5)
  }
}
    8000091a:	70e2                	ld	ra,56(sp)
    8000091c:	7442                	ld	s0,48(sp)
    8000091e:	74a2                	ld	s1,40(sp)
    80000920:	7902                	ld	s2,32(sp)
    80000922:	69e2                	ld	s3,24(sp)
    80000924:	6a42                	ld	s4,16(sp)
    80000926:	6aa2                	ld	s5,8(sp)
    80000928:	6b02                	ld	s6,0(sp)
    8000092a:	6121                	addi	sp,sp,64
    8000092c:	8082                	ret
      ReadReg(ISR);
    8000092e:	100007b7          	lui	a5,0x10000
    80000932:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000934:	0007c783          	lbu	a5,0(a5)
      return;
    80000938:	8082                	ret

000000008000093a <uartputc>:
{
    8000093a:	7179                	addi	sp,sp,-48
    8000093c:	f406                	sd	ra,40(sp)
    8000093e:	f022                	sd	s0,32(sp)
    80000940:	ec26                	sd	s1,24(sp)
    80000942:	e84a                	sd	s2,16(sp)
    80000944:	e44e                	sd	s3,8(sp)
    80000946:	e052                	sd	s4,0(sp)
    80000948:	1800                	addi	s0,sp,48
    8000094a:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000094c:	00013517          	auipc	a0,0x13
    80000950:	e2c50513          	addi	a0,a0,-468 # 80013778 <uart_tx_lock>
    80000954:	2a0000ef          	jal	80000bf4 <acquire>
  if(panicked){
    80000958:	0000b797          	auipc	a5,0xb
    8000095c:	d087a783          	lw	a5,-760(a5) # 8000b660 <panicked>
    80000960:	efbd                	bnez	a5,800009de <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000962:	0000b717          	auipc	a4,0xb
    80000966:	d0e73703          	ld	a4,-754(a4) # 8000b670 <uart_tx_w>
    8000096a:	0000b797          	auipc	a5,0xb
    8000096e:	cfe7b783          	ld	a5,-770(a5) # 8000b668 <uart_tx_r>
    80000972:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000976:	00013997          	auipc	s3,0x13
    8000097a:	e0298993          	addi	s3,s3,-510 # 80013778 <uart_tx_lock>
    8000097e:	0000b497          	auipc	s1,0xb
    80000982:	cea48493          	addi	s1,s1,-790 # 8000b668 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000986:	0000b917          	auipc	s2,0xb
    8000098a:	cea90913          	addi	s2,s2,-790 # 8000b670 <uart_tx_w>
    8000098e:	00e79d63          	bne	a5,a4,800009a8 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000992:	85ce                	mv	a1,s3
    80000994:	8526                	mv	a0,s1
    80000996:	378010ef          	jal	80001d0e <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000099a:	00093703          	ld	a4,0(s2)
    8000099e:	609c                	ld	a5,0(s1)
    800009a0:	02078793          	addi	a5,a5,32
    800009a4:	fee787e3          	beq	a5,a4,80000992 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800009a8:	00013497          	auipc	s1,0x13
    800009ac:	dd048493          	addi	s1,s1,-560 # 80013778 <uart_tx_lock>
    800009b0:	01f77793          	andi	a5,a4,31
    800009b4:	97a6                	add	a5,a5,s1
    800009b6:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009ba:	0705                	addi	a4,a4,1
    800009bc:	0000b797          	auipc	a5,0xb
    800009c0:	cae7ba23          	sd	a4,-844(a5) # 8000b670 <uart_tx_w>
  uartstart();
    800009c4:	ed7ff0ef          	jal	8000089a <uartstart>
  release(&uart_tx_lock);
    800009c8:	8526                	mv	a0,s1
    800009ca:	2c2000ef          	jal	80000c8c <release>
}
    800009ce:	70a2                	ld	ra,40(sp)
    800009d0:	7402                	ld	s0,32(sp)
    800009d2:	64e2                	ld	s1,24(sp)
    800009d4:	6942                	ld	s2,16(sp)
    800009d6:	69a2                	ld	s3,8(sp)
    800009d8:	6a02                	ld	s4,0(sp)
    800009da:	6145                	addi	sp,sp,48
    800009dc:	8082                	ret
    for(;;)
    800009de:	a001                	j	800009de <uartputc+0xa4>

00000000800009e0 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009e0:	1141                	addi	sp,sp,-16
    800009e2:	e422                	sd	s0,8(sp)
    800009e4:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009e6:	100007b7          	lui	a5,0x10000
    800009ea:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800009ec:	0007c783          	lbu	a5,0(a5)
    800009f0:	8b85                	andi	a5,a5,1
    800009f2:	cb81                	beqz	a5,80000a02 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800009f4:	100007b7          	lui	a5,0x10000
    800009f8:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009fc:	6422                	ld	s0,8(sp)
    800009fe:	0141                	addi	sp,sp,16
    80000a00:	8082                	ret
    return -1;
    80000a02:	557d                	li	a0,-1
    80000a04:	bfe5                	j	800009fc <uartgetc+0x1c>

0000000080000a06 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000a06:	1101                	addi	sp,sp,-32
    80000a08:	ec06                	sd	ra,24(sp)
    80000a0a:	e822                	sd	s0,16(sp)
    80000a0c:	e426                	sd	s1,8(sp)
    80000a0e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a10:	54fd                	li	s1,-1
    80000a12:	a019                	j	80000a18 <uartintr+0x12>
      break;
    consoleintr(c);
    80000a14:	85fff0ef          	jal	80000272 <consoleintr>
    int c = uartgetc();
    80000a18:	fc9ff0ef          	jal	800009e0 <uartgetc>
    if(c == -1)
    80000a1c:	fe951ce3          	bne	a0,s1,80000a14 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a20:	00013497          	auipc	s1,0x13
    80000a24:	d5848493          	addi	s1,s1,-680 # 80013778 <uart_tx_lock>
    80000a28:	8526                	mv	a0,s1
    80000a2a:	1ca000ef          	jal	80000bf4 <acquire>
  uartstart();
    80000a2e:	e6dff0ef          	jal	8000089a <uartstart>
  release(&uart_tx_lock);
    80000a32:	8526                	mv	a0,s1
    80000a34:	258000ef          	jal	80000c8c <release>
}
    80000a38:	60e2                	ld	ra,24(sp)
    80000a3a:	6442                	ld	s0,16(sp)
    80000a3c:	64a2                	ld	s1,8(sp)
    80000a3e:	6105                	addi	sp,sp,32
    80000a40:	8082                	ret

0000000080000a42 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a42:	1101                	addi	sp,sp,-32
    80000a44:	ec06                	sd	ra,24(sp)
    80000a46:	e822                	sd	s0,16(sp)
    80000a48:	e426                	sd	s1,8(sp)
    80000a4a:	e04a                	sd	s2,0(sp)
    80000a4c:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a4e:	03451793          	slli	a5,a0,0x34
    80000a52:	e7a9                	bnez	a5,80000a9c <kfree+0x5a>
    80000a54:	84aa                	mv	s1,a0
    80000a56:	00024797          	auipc	a5,0x24
    80000a5a:	1d278793          	addi	a5,a5,466 # 80024c28 <end>
    80000a5e:	02f56f63          	bltu	a0,a5,80000a9c <kfree+0x5a>
    80000a62:	47c5                	li	a5,17
    80000a64:	07ee                	slli	a5,a5,0x1b
    80000a66:	02f57b63          	bgeu	a0,a5,80000a9c <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a6a:	6605                	lui	a2,0x1
    80000a6c:	4585                	li	a1,1
    80000a6e:	25a000ef          	jal	80000cc8 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a72:	00013917          	auipc	s2,0x13
    80000a76:	d3e90913          	addi	s2,s2,-706 # 800137b0 <kmem>
    80000a7a:	854a                	mv	a0,s2
    80000a7c:	178000ef          	jal	80000bf4 <acquire>
  r->next = kmem.freelist;
    80000a80:	01893783          	ld	a5,24(s2)
    80000a84:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a86:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a8a:	854a                	mv	a0,s2
    80000a8c:	200000ef          	jal	80000c8c <release>
}
    80000a90:	60e2                	ld	ra,24(sp)
    80000a92:	6442                	ld	s0,16(sp)
    80000a94:	64a2                	ld	s1,8(sp)
    80000a96:	6902                	ld	s2,0(sp)
    80000a98:	6105                	addi	sp,sp,32
    80000a9a:	8082                	ret
    panic("kfree");
    80000a9c:	00007517          	auipc	a0,0x7
    80000aa0:	59c50513          	addi	a0,a0,1436 # 80008038 <etext+0x38>
    80000aa4:	cf1ff0ef          	jal	80000794 <panic>

0000000080000aa8 <freerange>:
{
    80000aa8:	7179                	addi	sp,sp,-48
    80000aaa:	f406                	sd	ra,40(sp)
    80000aac:	f022                	sd	s0,32(sp)
    80000aae:	ec26                	sd	s1,24(sp)
    80000ab0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ab2:	6785                	lui	a5,0x1
    80000ab4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ab8:	00e504b3          	add	s1,a0,a4
    80000abc:	777d                	lui	a4,0xfffff
    80000abe:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ac0:	94be                	add	s1,s1,a5
    80000ac2:	0295e263          	bltu	a1,s1,80000ae6 <freerange+0x3e>
    80000ac6:	e84a                	sd	s2,16(sp)
    80000ac8:	e44e                	sd	s3,8(sp)
    80000aca:	e052                	sd	s4,0(sp)
    80000acc:	892e                	mv	s2,a1
    kfree(p);
    80000ace:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ad0:	6985                	lui	s3,0x1
    kfree(p);
    80000ad2:	01448533          	add	a0,s1,s4
    80000ad6:	f6dff0ef          	jal	80000a42 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ada:	94ce                	add	s1,s1,s3
    80000adc:	fe997be3          	bgeu	s2,s1,80000ad2 <freerange+0x2a>
    80000ae0:	6942                	ld	s2,16(sp)
    80000ae2:	69a2                	ld	s3,8(sp)
    80000ae4:	6a02                	ld	s4,0(sp)
}
    80000ae6:	70a2                	ld	ra,40(sp)
    80000ae8:	7402                	ld	s0,32(sp)
    80000aea:	64e2                	ld	s1,24(sp)
    80000aec:	6145                	addi	sp,sp,48
    80000aee:	8082                	ret

0000000080000af0 <kinit>:
{
    80000af0:	1141                	addi	sp,sp,-16
    80000af2:	e406                	sd	ra,8(sp)
    80000af4:	e022                	sd	s0,0(sp)
    80000af6:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000af8:	00007597          	auipc	a1,0x7
    80000afc:	54858593          	addi	a1,a1,1352 # 80008040 <etext+0x40>
    80000b00:	00013517          	auipc	a0,0x13
    80000b04:	cb050513          	addi	a0,a0,-848 # 800137b0 <kmem>
    80000b08:	06c000ef          	jal	80000b74 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b0c:	45c5                	li	a1,17
    80000b0e:	05ee                	slli	a1,a1,0x1b
    80000b10:	00024517          	auipc	a0,0x24
    80000b14:	11850513          	addi	a0,a0,280 # 80024c28 <end>
    80000b18:	f91ff0ef          	jal	80000aa8 <freerange>
}
    80000b1c:	60a2                	ld	ra,8(sp)
    80000b1e:	6402                	ld	s0,0(sp)
    80000b20:	0141                	addi	sp,sp,16
    80000b22:	8082                	ret

0000000080000b24 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b24:	1101                	addi	sp,sp,-32
    80000b26:	ec06                	sd	ra,24(sp)
    80000b28:	e822                	sd	s0,16(sp)
    80000b2a:	e426                	sd	s1,8(sp)
    80000b2c:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b2e:	00013497          	auipc	s1,0x13
    80000b32:	c8248493          	addi	s1,s1,-894 # 800137b0 <kmem>
    80000b36:	8526                	mv	a0,s1
    80000b38:	0bc000ef          	jal	80000bf4 <acquire>
  r = kmem.freelist;
    80000b3c:	6c84                	ld	s1,24(s1)
  if(r)
    80000b3e:	c485                	beqz	s1,80000b66 <kalloc+0x42>
    kmem.freelist = r->next;
    80000b40:	609c                	ld	a5,0(s1)
    80000b42:	00013517          	auipc	a0,0x13
    80000b46:	c6e50513          	addi	a0,a0,-914 # 800137b0 <kmem>
    80000b4a:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b4c:	140000ef          	jal	80000c8c <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b50:	6605                	lui	a2,0x1
    80000b52:	4595                	li	a1,5
    80000b54:	8526                	mv	a0,s1
    80000b56:	172000ef          	jal	80000cc8 <memset>
  return (void*)r;
}
    80000b5a:	8526                	mv	a0,s1
    80000b5c:	60e2                	ld	ra,24(sp)
    80000b5e:	6442                	ld	s0,16(sp)
    80000b60:	64a2                	ld	s1,8(sp)
    80000b62:	6105                	addi	sp,sp,32
    80000b64:	8082                	ret
  release(&kmem.lock);
    80000b66:	00013517          	auipc	a0,0x13
    80000b6a:	c4a50513          	addi	a0,a0,-950 # 800137b0 <kmem>
    80000b6e:	11e000ef          	jal	80000c8c <release>
  if(r)
    80000b72:	b7e5                	j	80000b5a <kalloc+0x36>

0000000080000b74 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b74:	1141                	addi	sp,sp,-16
    80000b76:	e422                	sd	s0,8(sp)
    80000b78:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b7a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b7c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b80:	00053823          	sd	zero,16(a0)
}
    80000b84:	6422                	ld	s0,8(sp)
    80000b86:	0141                	addi	sp,sp,16
    80000b88:	8082                	ret

0000000080000b8a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b8a:	411c                	lw	a5,0(a0)
    80000b8c:	e399                	bnez	a5,80000b92 <holding+0x8>
    80000b8e:	4501                	li	a0,0
  return r;
}
    80000b90:	8082                	ret
{
    80000b92:	1101                	addi	sp,sp,-32
    80000b94:	ec06                	sd	ra,24(sp)
    80000b96:	e822                	sd	s0,16(sp)
    80000b98:	e426                	sd	s1,8(sp)
    80000b9a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b9c:	6904                	ld	s1,16(a0)
    80000b9e:	575000ef          	jal	80001912 <mycpu>
    80000ba2:	40a48533          	sub	a0,s1,a0
    80000ba6:	00153513          	seqz	a0,a0
}
    80000baa:	60e2                	ld	ra,24(sp)
    80000bac:	6442                	ld	s0,16(sp)
    80000bae:	64a2                	ld	s1,8(sp)
    80000bb0:	6105                	addi	sp,sp,32
    80000bb2:	8082                	ret

0000000080000bb4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bb4:	1101                	addi	sp,sp,-32
    80000bb6:	ec06                	sd	ra,24(sp)
    80000bb8:	e822                	sd	s0,16(sp)
    80000bba:	e426                	sd	s1,8(sp)
    80000bbc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bbe:	100024f3          	csrr	s1,sstatus
    80000bc2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bc6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bc8:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000bcc:	547000ef          	jal	80001912 <mycpu>
    80000bd0:	5d3c                	lw	a5,120(a0)
    80000bd2:	cb99                	beqz	a5,80000be8 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bd4:	53f000ef          	jal	80001912 <mycpu>
    80000bd8:	5d3c                	lw	a5,120(a0)
    80000bda:	2785                	addiw	a5,a5,1
    80000bdc:	dd3c                	sw	a5,120(a0)
}
    80000bde:	60e2                	ld	ra,24(sp)
    80000be0:	6442                	ld	s0,16(sp)
    80000be2:	64a2                	ld	s1,8(sp)
    80000be4:	6105                	addi	sp,sp,32
    80000be6:	8082                	ret
    mycpu()->intena = old;
    80000be8:	52b000ef          	jal	80001912 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bec:	8085                	srli	s1,s1,0x1
    80000bee:	8885                	andi	s1,s1,1
    80000bf0:	dd64                	sw	s1,124(a0)
    80000bf2:	b7cd                	j	80000bd4 <push_off+0x20>

0000000080000bf4 <acquire>:
{
    80000bf4:	1101                	addi	sp,sp,-32
    80000bf6:	ec06                	sd	ra,24(sp)
    80000bf8:	e822                	sd	s0,16(sp)
    80000bfa:	e426                	sd	s1,8(sp)
    80000bfc:	1000                	addi	s0,sp,32
    80000bfe:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c00:	fb5ff0ef          	jal	80000bb4 <push_off>
  if(holding(lk))
    80000c04:	8526                	mv	a0,s1
    80000c06:	f85ff0ef          	jal	80000b8a <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c0a:	4705                	li	a4,1
  if(holding(lk))
    80000c0c:	e105                	bnez	a0,80000c2c <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c0e:	87ba                	mv	a5,a4
    80000c10:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c14:	2781                	sext.w	a5,a5
    80000c16:	ffe5                	bnez	a5,80000c0e <acquire+0x1a>
  __sync_synchronize();
    80000c18:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000c1c:	4f7000ef          	jal	80001912 <mycpu>
    80000c20:	e888                	sd	a0,16(s1)
}
    80000c22:	60e2                	ld	ra,24(sp)
    80000c24:	6442                	ld	s0,16(sp)
    80000c26:	64a2                	ld	s1,8(sp)
    80000c28:	6105                	addi	sp,sp,32
    80000c2a:	8082                	ret
    panic("acquire");
    80000c2c:	00007517          	auipc	a0,0x7
    80000c30:	41c50513          	addi	a0,a0,1052 # 80008048 <etext+0x48>
    80000c34:	b61ff0ef          	jal	80000794 <panic>

0000000080000c38 <pop_off>:

void
pop_off(void)
{
    80000c38:	1141                	addi	sp,sp,-16
    80000c3a:	e406                	sd	ra,8(sp)
    80000c3c:	e022                	sd	s0,0(sp)
    80000c3e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c40:	4d3000ef          	jal	80001912 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c44:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c48:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c4a:	e78d                	bnez	a5,80000c74 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c4c:	5d3c                	lw	a5,120(a0)
    80000c4e:	02f05963          	blez	a5,80000c80 <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80000c52:	37fd                	addiw	a5,a5,-1
    80000c54:	0007871b          	sext.w	a4,a5
    80000c58:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c5a:	eb09                	bnez	a4,80000c6c <pop_off+0x34>
    80000c5c:	5d7c                	lw	a5,124(a0)
    80000c5e:	c799                	beqz	a5,80000c6c <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c60:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c64:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c68:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c6c:	60a2                	ld	ra,8(sp)
    80000c6e:	6402                	ld	s0,0(sp)
    80000c70:	0141                	addi	sp,sp,16
    80000c72:	8082                	ret
    panic("pop_off - interruptible");
    80000c74:	00007517          	auipc	a0,0x7
    80000c78:	3dc50513          	addi	a0,a0,988 # 80008050 <etext+0x50>
    80000c7c:	b19ff0ef          	jal	80000794 <panic>
    panic("pop_off");
    80000c80:	00007517          	auipc	a0,0x7
    80000c84:	3e850513          	addi	a0,a0,1000 # 80008068 <etext+0x68>
    80000c88:	b0dff0ef          	jal	80000794 <panic>

0000000080000c8c <release>:
{
    80000c8c:	1101                	addi	sp,sp,-32
    80000c8e:	ec06                	sd	ra,24(sp)
    80000c90:	e822                	sd	s0,16(sp)
    80000c92:	e426                	sd	s1,8(sp)
    80000c94:	1000                	addi	s0,sp,32
    80000c96:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c98:	ef3ff0ef          	jal	80000b8a <holding>
    80000c9c:	c105                	beqz	a0,80000cbc <release+0x30>
  lk->cpu = 0;
    80000c9e:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000ca2:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000ca6:	0310000f          	fence	rw,w
    80000caa:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000cae:	f8bff0ef          	jal	80000c38 <pop_off>
}
    80000cb2:	60e2                	ld	ra,24(sp)
    80000cb4:	6442                	ld	s0,16(sp)
    80000cb6:	64a2                	ld	s1,8(sp)
    80000cb8:	6105                	addi	sp,sp,32
    80000cba:	8082                	ret
    panic("release");
    80000cbc:	00007517          	auipc	a0,0x7
    80000cc0:	3b450513          	addi	a0,a0,948 # 80008070 <etext+0x70>
    80000cc4:	ad1ff0ef          	jal	80000794 <panic>

0000000080000cc8 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cc8:	1141                	addi	sp,sp,-16
    80000cca:	e422                	sd	s0,8(sp)
    80000ccc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cce:	ca19                	beqz	a2,80000ce4 <memset+0x1c>
    80000cd0:	87aa                	mv	a5,a0
    80000cd2:	1602                	slli	a2,a2,0x20
    80000cd4:	9201                	srli	a2,a2,0x20
    80000cd6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000cda:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000cde:	0785                	addi	a5,a5,1
    80000ce0:	fee79de3          	bne	a5,a4,80000cda <memset+0x12>
  }
  return dst;
}
    80000ce4:	6422                	ld	s0,8(sp)
    80000ce6:	0141                	addi	sp,sp,16
    80000ce8:	8082                	ret

0000000080000cea <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cea:	1141                	addi	sp,sp,-16
    80000cec:	e422                	sd	s0,8(sp)
    80000cee:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cf0:	ca05                	beqz	a2,80000d20 <memcmp+0x36>
    80000cf2:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000cf6:	1682                	slli	a3,a3,0x20
    80000cf8:	9281                	srli	a3,a3,0x20
    80000cfa:	0685                	addi	a3,a3,1
    80000cfc:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000cfe:	00054783          	lbu	a5,0(a0)
    80000d02:	0005c703          	lbu	a4,0(a1)
    80000d06:	00e79863          	bne	a5,a4,80000d16 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d0a:	0505                	addi	a0,a0,1
    80000d0c:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d0e:	fed518e3          	bne	a0,a3,80000cfe <memcmp+0x14>
  }

  return 0;
    80000d12:	4501                	li	a0,0
    80000d14:	a019                	j	80000d1a <memcmp+0x30>
      return *s1 - *s2;
    80000d16:	40e7853b          	subw	a0,a5,a4
}
    80000d1a:	6422                	ld	s0,8(sp)
    80000d1c:	0141                	addi	sp,sp,16
    80000d1e:	8082                	ret
  return 0;
    80000d20:	4501                	li	a0,0
    80000d22:	bfe5                	j	80000d1a <memcmp+0x30>

0000000080000d24 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d24:	1141                	addi	sp,sp,-16
    80000d26:	e422                	sd	s0,8(sp)
    80000d28:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d2a:	c205                	beqz	a2,80000d4a <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d2c:	02a5e263          	bltu	a1,a0,80000d50 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d30:	1602                	slli	a2,a2,0x20
    80000d32:	9201                	srli	a2,a2,0x20
    80000d34:	00c587b3          	add	a5,a1,a2
{
    80000d38:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d3a:	0585                	addi	a1,a1,1
    80000d3c:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffda3d9>
    80000d3e:	fff5c683          	lbu	a3,-1(a1)
    80000d42:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d46:	feb79ae3          	bne	a5,a1,80000d3a <memmove+0x16>

  return dst;
}
    80000d4a:	6422                	ld	s0,8(sp)
    80000d4c:	0141                	addi	sp,sp,16
    80000d4e:	8082                	ret
  if(s < d && s + n > d){
    80000d50:	02061693          	slli	a3,a2,0x20
    80000d54:	9281                	srli	a3,a3,0x20
    80000d56:	00d58733          	add	a4,a1,a3
    80000d5a:	fce57be3          	bgeu	a0,a4,80000d30 <memmove+0xc>
    d += n;
    80000d5e:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d60:	fff6079b          	addiw	a5,a2,-1
    80000d64:	1782                	slli	a5,a5,0x20
    80000d66:	9381                	srli	a5,a5,0x20
    80000d68:	fff7c793          	not	a5,a5
    80000d6c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d6e:	177d                	addi	a4,a4,-1
    80000d70:	16fd                	addi	a3,a3,-1
    80000d72:	00074603          	lbu	a2,0(a4)
    80000d76:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d7a:	fef71ae3          	bne	a4,a5,80000d6e <memmove+0x4a>
    80000d7e:	b7f1                	j	80000d4a <memmove+0x26>

0000000080000d80 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d80:	1141                	addi	sp,sp,-16
    80000d82:	e406                	sd	ra,8(sp)
    80000d84:	e022                	sd	s0,0(sp)
    80000d86:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d88:	f9dff0ef          	jal	80000d24 <memmove>
}
    80000d8c:	60a2                	ld	ra,8(sp)
    80000d8e:	6402                	ld	s0,0(sp)
    80000d90:	0141                	addi	sp,sp,16
    80000d92:	8082                	ret

0000000080000d94 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d94:	1141                	addi	sp,sp,-16
    80000d96:	e422                	sd	s0,8(sp)
    80000d98:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000d9a:	ce11                	beqz	a2,80000db6 <strncmp+0x22>
    80000d9c:	00054783          	lbu	a5,0(a0)
    80000da0:	cf89                	beqz	a5,80000dba <strncmp+0x26>
    80000da2:	0005c703          	lbu	a4,0(a1)
    80000da6:	00f71a63          	bne	a4,a5,80000dba <strncmp+0x26>
    n--, p++, q++;
    80000daa:	367d                	addiw	a2,a2,-1
    80000dac:	0505                	addi	a0,a0,1
    80000dae:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000db0:	f675                	bnez	a2,80000d9c <strncmp+0x8>
  if(n == 0)
    return 0;
    80000db2:	4501                	li	a0,0
    80000db4:	a801                	j	80000dc4 <strncmp+0x30>
    80000db6:	4501                	li	a0,0
    80000db8:	a031                	j	80000dc4 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000dba:	00054503          	lbu	a0,0(a0)
    80000dbe:	0005c783          	lbu	a5,0(a1)
    80000dc2:	9d1d                	subw	a0,a0,a5
}
    80000dc4:	6422                	ld	s0,8(sp)
    80000dc6:	0141                	addi	sp,sp,16
    80000dc8:	8082                	ret

0000000080000dca <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000dca:	1141                	addi	sp,sp,-16
    80000dcc:	e422                	sd	s0,8(sp)
    80000dce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000dd0:	87aa                	mv	a5,a0
    80000dd2:	86b2                	mv	a3,a2
    80000dd4:	367d                	addiw	a2,a2,-1
    80000dd6:	02d05563          	blez	a3,80000e00 <strncpy+0x36>
    80000dda:	0785                	addi	a5,a5,1
    80000ddc:	0005c703          	lbu	a4,0(a1)
    80000de0:	fee78fa3          	sb	a4,-1(a5)
    80000de4:	0585                	addi	a1,a1,1
    80000de6:	f775                	bnez	a4,80000dd2 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000de8:	873e                	mv	a4,a5
    80000dea:	9fb5                	addw	a5,a5,a3
    80000dec:	37fd                	addiw	a5,a5,-1
    80000dee:	00c05963          	blez	a2,80000e00 <strncpy+0x36>
    *s++ = 0;
    80000df2:	0705                	addi	a4,a4,1
    80000df4:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000df8:	40e786bb          	subw	a3,a5,a4
    80000dfc:	fed04be3          	bgtz	a3,80000df2 <strncpy+0x28>
  return os;
}
    80000e00:	6422                	ld	s0,8(sp)
    80000e02:	0141                	addi	sp,sp,16
    80000e04:	8082                	ret

0000000080000e06 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e06:	1141                	addi	sp,sp,-16
    80000e08:	e422                	sd	s0,8(sp)
    80000e0a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e0c:	02c05363          	blez	a2,80000e32 <safestrcpy+0x2c>
    80000e10:	fff6069b          	addiw	a3,a2,-1
    80000e14:	1682                	slli	a3,a3,0x20
    80000e16:	9281                	srli	a3,a3,0x20
    80000e18:	96ae                	add	a3,a3,a1
    80000e1a:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e1c:	00d58963          	beq	a1,a3,80000e2e <safestrcpy+0x28>
    80000e20:	0585                	addi	a1,a1,1
    80000e22:	0785                	addi	a5,a5,1
    80000e24:	fff5c703          	lbu	a4,-1(a1)
    80000e28:	fee78fa3          	sb	a4,-1(a5)
    80000e2c:	fb65                	bnez	a4,80000e1c <safestrcpy+0x16>
    ;
  *s = 0;
    80000e2e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e32:	6422                	ld	s0,8(sp)
    80000e34:	0141                	addi	sp,sp,16
    80000e36:	8082                	ret

0000000080000e38 <strlen>:

int
strlen(const char *s)
{
    80000e38:	1141                	addi	sp,sp,-16
    80000e3a:	e422                	sd	s0,8(sp)
    80000e3c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e3e:	00054783          	lbu	a5,0(a0)
    80000e42:	cf91                	beqz	a5,80000e5e <strlen+0x26>
    80000e44:	0505                	addi	a0,a0,1
    80000e46:	87aa                	mv	a5,a0
    80000e48:	86be                	mv	a3,a5
    80000e4a:	0785                	addi	a5,a5,1
    80000e4c:	fff7c703          	lbu	a4,-1(a5)
    80000e50:	ff65                	bnez	a4,80000e48 <strlen+0x10>
    80000e52:	40a6853b          	subw	a0,a3,a0
    80000e56:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000e58:	6422                	ld	s0,8(sp)
    80000e5a:	0141                	addi	sp,sp,16
    80000e5c:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e5e:	4501                	li	a0,0
    80000e60:	bfe5                	j	80000e58 <strlen+0x20>

0000000080000e62 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e62:	1141                	addi	sp,sp,-16
    80000e64:	e406                	sd	ra,8(sp)
    80000e66:	e022                	sd	s0,0(sp)
    80000e68:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e6a:	299000ef          	jal	80001902 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e6e:	0000b717          	auipc	a4,0xb
    80000e72:	80a70713          	addi	a4,a4,-2038 # 8000b678 <started>
  if(cpuid() == 0){
    80000e76:	c51d                	beqz	a0,80000ea4 <main+0x42>
    while(started == 0)
    80000e78:	431c                	lw	a5,0(a4)
    80000e7a:	2781                	sext.w	a5,a5
    80000e7c:	dff5                	beqz	a5,80000e78 <main+0x16>
      ;
    __sync_synchronize();
    80000e7e:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000e82:	281000ef          	jal	80001902 <cpuid>
    80000e86:	85aa                	mv	a1,a0
    80000e88:	00007517          	auipc	a0,0x7
    80000e8c:	21050513          	addi	a0,a0,528 # 80008098 <etext+0x98>
    80000e90:	e32ff0ef          	jal	800004c2 <printf>
    kvminithart();    // turn on paging
    80000e94:	080000ef          	jal	80000f14 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000e98:	4fb010ef          	jal	80002b92 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000e9c:	3ad040ef          	jal	80005a48 <plicinithart>
  }

  scheduler();        
    80000ea0:	05b010ef          	jal	800026fa <scheduler>
    consoleinit();
    80000ea4:	d48ff0ef          	jal	800003ec <consoleinit>
    printfinit();
    80000ea8:	927ff0ef          	jal	800007ce <printfinit>
    printf("\n");
    80000eac:	00007517          	auipc	a0,0x7
    80000eb0:	1cc50513          	addi	a0,a0,460 # 80008078 <etext+0x78>
    80000eb4:	e0eff0ef          	jal	800004c2 <printf>
    printf("xv6 kernel is booting\n");
    80000eb8:	00007517          	auipc	a0,0x7
    80000ebc:	1c850513          	addi	a0,a0,456 # 80008080 <etext+0x80>
    80000ec0:	e02ff0ef          	jal	800004c2 <printf>
    printf("\n");
    80000ec4:	00007517          	auipc	a0,0x7
    80000ec8:	1b450513          	addi	a0,a0,436 # 80008078 <etext+0x78>
    80000ecc:	df6ff0ef          	jal	800004c2 <printf>
    kinit();         // physical page allocator
    80000ed0:	c21ff0ef          	jal	80000af0 <kinit>
    kvminit();       // create kernel page table
    80000ed4:	2ca000ef          	jal	8000119e <kvminit>
    kvminithart();   // turn on paging
    80000ed8:	03c000ef          	jal	80000f14 <kvminithart>
    procinit();      // process table
    80000edc:	123000ef          	jal	800017fe <procinit>
    trapinit();      // trap vectors
    80000ee0:	48f010ef          	jal	80002b6e <trapinit>
    trapinithart();  // install kernel trap vector
    80000ee4:	4af010ef          	jal	80002b92 <trapinithart>
    plicinit();      // set up interrupt controller
    80000ee8:	347040ef          	jal	80005a2e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000eec:	35d040ef          	jal	80005a48 <plicinithart>
    binit();         // buffer cache
    80000ef0:	304020ef          	jal	800031f4 <binit>
    iinit();         // inode table
    80000ef4:	0f7020ef          	jal	800037ea <iinit>
    fileinit();      // file table
    80000ef8:	6a2030ef          	jal	8000459a <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000efc:	43d040ef          	jal	80005b38 <virtio_disk_init>
    userinit();      // first user process
    80000f00:	497000ef          	jal	80001b96 <userinit>
    __sync_synchronize();
    80000f04:	0330000f          	fence	rw,rw
    started = 1;
    80000f08:	4785                	li	a5,1
    80000f0a:	0000a717          	auipc	a4,0xa
    80000f0e:	76f72723          	sw	a5,1902(a4) # 8000b678 <started>
    80000f12:	b779                	j	80000ea0 <main+0x3e>

0000000080000f14 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f14:	1141                	addi	sp,sp,-16
    80000f16:	e422                	sd	s0,8(sp)
    80000f18:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f1a:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f1e:	0000a797          	auipc	a5,0xa
    80000f22:	7627b783          	ld	a5,1890(a5) # 8000b680 <kernel_pagetable>
    80000f26:	83b1                	srli	a5,a5,0xc
    80000f28:	577d                	li	a4,-1
    80000f2a:	177e                	slli	a4,a4,0x3f
    80000f2c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f2e:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000f32:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f36:	6422                	ld	s0,8(sp)
    80000f38:	0141                	addi	sp,sp,16
    80000f3a:	8082                	ret

0000000080000f3c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f3c:	7139                	addi	sp,sp,-64
    80000f3e:	fc06                	sd	ra,56(sp)
    80000f40:	f822                	sd	s0,48(sp)
    80000f42:	f426                	sd	s1,40(sp)
    80000f44:	f04a                	sd	s2,32(sp)
    80000f46:	ec4e                	sd	s3,24(sp)
    80000f48:	e852                	sd	s4,16(sp)
    80000f4a:	e456                	sd	s5,8(sp)
    80000f4c:	e05a                	sd	s6,0(sp)
    80000f4e:	0080                	addi	s0,sp,64
    80000f50:	84aa                	mv	s1,a0
    80000f52:	89ae                	mv	s3,a1
    80000f54:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000f56:	57fd                	li	a5,-1
    80000f58:	83e9                	srli	a5,a5,0x1a
    80000f5a:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000f5c:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000f5e:	02b7fc63          	bgeu	a5,a1,80000f96 <walk+0x5a>
    panic("walk");
    80000f62:	00007517          	auipc	a0,0x7
    80000f66:	14e50513          	addi	a0,a0,334 # 800080b0 <etext+0xb0>
    80000f6a:	82bff0ef          	jal	80000794 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000f6e:	060a8263          	beqz	s5,80000fd2 <walk+0x96>
    80000f72:	bb3ff0ef          	jal	80000b24 <kalloc>
    80000f76:	84aa                	mv	s1,a0
    80000f78:	c139                	beqz	a0,80000fbe <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000f7a:	6605                	lui	a2,0x1
    80000f7c:	4581                	li	a1,0
    80000f7e:	d4bff0ef          	jal	80000cc8 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000f82:	00c4d793          	srli	a5,s1,0xc
    80000f86:	07aa                	slli	a5,a5,0xa
    80000f88:	0017e793          	ori	a5,a5,1
    80000f8c:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000f90:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffda3cf>
    80000f92:	036a0063          	beq	s4,s6,80000fb2 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f96:	0149d933          	srl	s2,s3,s4
    80000f9a:	1ff97913          	andi	s2,s2,511
    80000f9e:	090e                	slli	s2,s2,0x3
    80000fa0:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000fa2:	00093483          	ld	s1,0(s2)
    80000fa6:	0014f793          	andi	a5,s1,1
    80000faa:	d3f1                	beqz	a5,80000f6e <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000fac:	80a9                	srli	s1,s1,0xa
    80000fae:	04b2                	slli	s1,s1,0xc
    80000fb0:	b7c5                	j	80000f90 <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000fb2:	00c9d513          	srli	a0,s3,0xc
    80000fb6:	1ff57513          	andi	a0,a0,511
    80000fba:	050e                	slli	a0,a0,0x3
    80000fbc:	9526                	add	a0,a0,s1
}
    80000fbe:	70e2                	ld	ra,56(sp)
    80000fc0:	7442                	ld	s0,48(sp)
    80000fc2:	74a2                	ld	s1,40(sp)
    80000fc4:	7902                	ld	s2,32(sp)
    80000fc6:	69e2                	ld	s3,24(sp)
    80000fc8:	6a42                	ld	s4,16(sp)
    80000fca:	6aa2                	ld	s5,8(sp)
    80000fcc:	6b02                	ld	s6,0(sp)
    80000fce:	6121                	addi	sp,sp,64
    80000fd0:	8082                	ret
        return 0;
    80000fd2:	4501                	li	a0,0
    80000fd4:	b7ed                	j	80000fbe <walk+0x82>

0000000080000fd6 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000fd6:	57fd                	li	a5,-1
    80000fd8:	83e9                	srli	a5,a5,0x1a
    80000fda:	00b7f463          	bgeu	a5,a1,80000fe2 <walkaddr+0xc>
    return 0;
    80000fde:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000fe0:	8082                	ret
{
    80000fe2:	1141                	addi	sp,sp,-16
    80000fe4:	e406                	sd	ra,8(sp)
    80000fe6:	e022                	sd	s0,0(sp)
    80000fe8:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000fea:	4601                	li	a2,0
    80000fec:	f51ff0ef          	jal	80000f3c <walk>
  if(pte == 0)
    80000ff0:	c105                	beqz	a0,80001010 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000ff2:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000ff4:	0117f693          	andi	a3,a5,17
    80000ff8:	4745                	li	a4,17
    return 0;
    80000ffa:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000ffc:	00e68663          	beq	a3,a4,80001008 <walkaddr+0x32>
}
    80001000:	60a2                	ld	ra,8(sp)
    80001002:	6402                	ld	s0,0(sp)
    80001004:	0141                	addi	sp,sp,16
    80001006:	8082                	ret
  pa = PTE2PA(*pte);
    80001008:	83a9                	srli	a5,a5,0xa
    8000100a:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000100e:	bfcd                	j	80001000 <walkaddr+0x2a>
    return 0;
    80001010:	4501                	li	a0,0
    80001012:	b7fd                	j	80001000 <walkaddr+0x2a>

0000000080001014 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001014:	715d                	addi	sp,sp,-80
    80001016:	e486                	sd	ra,72(sp)
    80001018:	e0a2                	sd	s0,64(sp)
    8000101a:	fc26                	sd	s1,56(sp)
    8000101c:	f84a                	sd	s2,48(sp)
    8000101e:	f44e                	sd	s3,40(sp)
    80001020:	f052                	sd	s4,32(sp)
    80001022:	ec56                	sd	s5,24(sp)
    80001024:	e85a                	sd	s6,16(sp)
    80001026:	e45e                	sd	s7,8(sp)
    80001028:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000102a:	03459793          	slli	a5,a1,0x34
    8000102e:	e7a9                	bnez	a5,80001078 <mappages+0x64>
    80001030:	8aaa                	mv	s5,a0
    80001032:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80001034:	03461793          	slli	a5,a2,0x34
    80001038:	e7b1                	bnez	a5,80001084 <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    8000103a:	ca39                	beqz	a2,80001090 <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    8000103c:	77fd                	lui	a5,0xfffff
    8000103e:	963e                	add	a2,a2,a5
    80001040:	00b609b3          	add	s3,a2,a1
  a = va;
    80001044:	892e                	mv	s2,a1
    80001046:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000104a:	6b85                	lui	s7,0x1
    8000104c:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80001050:	4605                	li	a2,1
    80001052:	85ca                	mv	a1,s2
    80001054:	8556                	mv	a0,s5
    80001056:	ee7ff0ef          	jal	80000f3c <walk>
    8000105a:	c539                	beqz	a0,800010a8 <mappages+0x94>
    if(*pte & PTE_V)
    8000105c:	611c                	ld	a5,0(a0)
    8000105e:	8b85                	andi	a5,a5,1
    80001060:	ef95                	bnez	a5,8000109c <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001062:	80b1                	srli	s1,s1,0xc
    80001064:	04aa                	slli	s1,s1,0xa
    80001066:	0164e4b3          	or	s1,s1,s6
    8000106a:	0014e493          	ori	s1,s1,1
    8000106e:	e104                	sd	s1,0(a0)
    if(a == last)
    80001070:	05390863          	beq	s2,s3,800010c0 <mappages+0xac>
    a += PGSIZE;
    80001074:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001076:	bfd9                	j	8000104c <mappages+0x38>
    panic("mappages: va not aligned");
    80001078:	00007517          	auipc	a0,0x7
    8000107c:	04050513          	addi	a0,a0,64 # 800080b8 <etext+0xb8>
    80001080:	f14ff0ef          	jal	80000794 <panic>
    panic("mappages: size not aligned");
    80001084:	00007517          	auipc	a0,0x7
    80001088:	05450513          	addi	a0,a0,84 # 800080d8 <etext+0xd8>
    8000108c:	f08ff0ef          	jal	80000794 <panic>
    panic("mappages: size");
    80001090:	00007517          	auipc	a0,0x7
    80001094:	06850513          	addi	a0,a0,104 # 800080f8 <etext+0xf8>
    80001098:	efcff0ef          	jal	80000794 <panic>
      panic("mappages: remap");
    8000109c:	00007517          	auipc	a0,0x7
    800010a0:	06c50513          	addi	a0,a0,108 # 80008108 <etext+0x108>
    800010a4:	ef0ff0ef          	jal	80000794 <panic>
      return -1;
    800010a8:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010aa:	60a6                	ld	ra,72(sp)
    800010ac:	6406                	ld	s0,64(sp)
    800010ae:	74e2                	ld	s1,56(sp)
    800010b0:	7942                	ld	s2,48(sp)
    800010b2:	79a2                	ld	s3,40(sp)
    800010b4:	7a02                	ld	s4,32(sp)
    800010b6:	6ae2                	ld	s5,24(sp)
    800010b8:	6b42                	ld	s6,16(sp)
    800010ba:	6ba2                	ld	s7,8(sp)
    800010bc:	6161                	addi	sp,sp,80
    800010be:	8082                	ret
  return 0;
    800010c0:	4501                	li	a0,0
    800010c2:	b7e5                	j	800010aa <mappages+0x96>

00000000800010c4 <kvmmap>:
{
    800010c4:	1141                	addi	sp,sp,-16
    800010c6:	e406                	sd	ra,8(sp)
    800010c8:	e022                	sd	s0,0(sp)
    800010ca:	0800                	addi	s0,sp,16
    800010cc:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800010ce:	86b2                	mv	a3,a2
    800010d0:	863e                	mv	a2,a5
    800010d2:	f43ff0ef          	jal	80001014 <mappages>
    800010d6:	e509                	bnez	a0,800010e0 <kvmmap+0x1c>
}
    800010d8:	60a2                	ld	ra,8(sp)
    800010da:	6402                	ld	s0,0(sp)
    800010dc:	0141                	addi	sp,sp,16
    800010de:	8082                	ret
    panic("kvmmap");
    800010e0:	00007517          	auipc	a0,0x7
    800010e4:	03850513          	addi	a0,a0,56 # 80008118 <etext+0x118>
    800010e8:	eacff0ef          	jal	80000794 <panic>

00000000800010ec <kvmmake>:
{
    800010ec:	1101                	addi	sp,sp,-32
    800010ee:	ec06                	sd	ra,24(sp)
    800010f0:	e822                	sd	s0,16(sp)
    800010f2:	e426                	sd	s1,8(sp)
    800010f4:	e04a                	sd	s2,0(sp)
    800010f6:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800010f8:	a2dff0ef          	jal	80000b24 <kalloc>
    800010fc:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800010fe:	6605                	lui	a2,0x1
    80001100:	4581                	li	a1,0
    80001102:	bc7ff0ef          	jal	80000cc8 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001106:	4719                	li	a4,6
    80001108:	6685                	lui	a3,0x1
    8000110a:	10000637          	lui	a2,0x10000
    8000110e:	100005b7          	lui	a1,0x10000
    80001112:	8526                	mv	a0,s1
    80001114:	fb1ff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001118:	4719                	li	a4,6
    8000111a:	6685                	lui	a3,0x1
    8000111c:	10001637          	lui	a2,0x10001
    80001120:	100015b7          	lui	a1,0x10001
    80001124:	8526                	mv	a0,s1
    80001126:	f9fff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    8000112a:	4719                	li	a4,6
    8000112c:	040006b7          	lui	a3,0x4000
    80001130:	0c000637          	lui	a2,0xc000
    80001134:	0c0005b7          	lui	a1,0xc000
    80001138:	8526                	mv	a0,s1
    8000113a:	f8bff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000113e:	00007917          	auipc	s2,0x7
    80001142:	ec290913          	addi	s2,s2,-318 # 80008000 <etext>
    80001146:	4729                	li	a4,10
    80001148:	80007697          	auipc	a3,0x80007
    8000114c:	eb868693          	addi	a3,a3,-328 # 8000 <_entry-0x7fff8000>
    80001150:	4605                	li	a2,1
    80001152:	067e                	slli	a2,a2,0x1f
    80001154:	85b2                	mv	a1,a2
    80001156:	8526                	mv	a0,s1
    80001158:	f6dff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000115c:	46c5                	li	a3,17
    8000115e:	06ee                	slli	a3,a3,0x1b
    80001160:	4719                	li	a4,6
    80001162:	412686b3          	sub	a3,a3,s2
    80001166:	864a                	mv	a2,s2
    80001168:	85ca                	mv	a1,s2
    8000116a:	8526                	mv	a0,s1
    8000116c:	f59ff0ef          	jal	800010c4 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001170:	4729                	li	a4,10
    80001172:	6685                	lui	a3,0x1
    80001174:	00006617          	auipc	a2,0x6
    80001178:	e8c60613          	addi	a2,a2,-372 # 80007000 <_trampoline>
    8000117c:	040005b7          	lui	a1,0x4000
    80001180:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001182:	05b2                	slli	a1,a1,0xc
    80001184:	8526                	mv	a0,s1
    80001186:	f3fff0ef          	jal	800010c4 <kvmmap>
  proc_mapstacks(kpgtbl);
    8000118a:	8526                	mv	a0,s1
    8000118c:	5da000ef          	jal	80001766 <proc_mapstacks>
}
    80001190:	8526                	mv	a0,s1
    80001192:	60e2                	ld	ra,24(sp)
    80001194:	6442                	ld	s0,16(sp)
    80001196:	64a2                	ld	s1,8(sp)
    80001198:	6902                	ld	s2,0(sp)
    8000119a:	6105                	addi	sp,sp,32
    8000119c:	8082                	ret

000000008000119e <kvminit>:
{
    8000119e:	1141                	addi	sp,sp,-16
    800011a0:	e406                	sd	ra,8(sp)
    800011a2:	e022                	sd	s0,0(sp)
    800011a4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800011a6:	f47ff0ef          	jal	800010ec <kvmmake>
    800011aa:	0000a797          	auipc	a5,0xa
    800011ae:	4ca7bb23          	sd	a0,1238(a5) # 8000b680 <kernel_pagetable>
}
    800011b2:	60a2                	ld	ra,8(sp)
    800011b4:	6402                	ld	s0,0(sp)
    800011b6:	0141                	addi	sp,sp,16
    800011b8:	8082                	ret

00000000800011ba <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800011ba:	715d                	addi	sp,sp,-80
    800011bc:	e486                	sd	ra,72(sp)
    800011be:	e0a2                	sd	s0,64(sp)
    800011c0:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800011c2:	03459793          	slli	a5,a1,0x34
    800011c6:	e39d                	bnez	a5,800011ec <uvmunmap+0x32>
    800011c8:	f84a                	sd	s2,48(sp)
    800011ca:	f44e                	sd	s3,40(sp)
    800011cc:	f052                	sd	s4,32(sp)
    800011ce:	ec56                	sd	s5,24(sp)
    800011d0:	e85a                	sd	s6,16(sp)
    800011d2:	e45e                	sd	s7,8(sp)
    800011d4:	8a2a                	mv	s4,a0
    800011d6:	892e                	mv	s2,a1
    800011d8:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011da:	0632                	slli	a2,a2,0xc
    800011dc:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800011e0:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011e2:	6b05                	lui	s6,0x1
    800011e4:	0735ff63          	bgeu	a1,s3,80001262 <uvmunmap+0xa8>
    800011e8:	fc26                	sd	s1,56(sp)
    800011ea:	a0a9                	j	80001234 <uvmunmap+0x7a>
    800011ec:	fc26                	sd	s1,56(sp)
    800011ee:	f84a                	sd	s2,48(sp)
    800011f0:	f44e                	sd	s3,40(sp)
    800011f2:	f052                	sd	s4,32(sp)
    800011f4:	ec56                	sd	s5,24(sp)
    800011f6:	e85a                	sd	s6,16(sp)
    800011f8:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800011fa:	00007517          	auipc	a0,0x7
    800011fe:	f2650513          	addi	a0,a0,-218 # 80008120 <etext+0x120>
    80001202:	d92ff0ef          	jal	80000794 <panic>
      panic("uvmunmap: walk");
    80001206:	00007517          	auipc	a0,0x7
    8000120a:	f3250513          	addi	a0,a0,-206 # 80008138 <etext+0x138>
    8000120e:	d86ff0ef          	jal	80000794 <panic>
      panic("uvmunmap: not mapped");
    80001212:	00007517          	auipc	a0,0x7
    80001216:	f3650513          	addi	a0,a0,-202 # 80008148 <etext+0x148>
    8000121a:	d7aff0ef          	jal	80000794 <panic>
      panic("uvmunmap: not a leaf");
    8000121e:	00007517          	auipc	a0,0x7
    80001222:	f4250513          	addi	a0,a0,-190 # 80008160 <etext+0x160>
    80001226:	d6eff0ef          	jal	80000794 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    8000122a:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000122e:	995a                	add	s2,s2,s6
    80001230:	03397863          	bgeu	s2,s3,80001260 <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001234:	4601                	li	a2,0
    80001236:	85ca                	mv	a1,s2
    80001238:	8552                	mv	a0,s4
    8000123a:	d03ff0ef          	jal	80000f3c <walk>
    8000123e:	84aa                	mv	s1,a0
    80001240:	d179                	beqz	a0,80001206 <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    80001242:	6108                	ld	a0,0(a0)
    80001244:	00157793          	andi	a5,a0,1
    80001248:	d7e9                	beqz	a5,80001212 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000124a:	3ff57793          	andi	a5,a0,1023
    8000124e:	fd7788e3          	beq	a5,s7,8000121e <uvmunmap+0x64>
    if(do_free){
    80001252:	fc0a8ce3          	beqz	s5,8000122a <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    80001256:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001258:	0532                	slli	a0,a0,0xc
    8000125a:	fe8ff0ef          	jal	80000a42 <kfree>
    8000125e:	b7f1                	j	8000122a <uvmunmap+0x70>
    80001260:	74e2                	ld	s1,56(sp)
    80001262:	7942                	ld	s2,48(sp)
    80001264:	79a2                	ld	s3,40(sp)
    80001266:	7a02                	ld	s4,32(sp)
    80001268:	6ae2                	ld	s5,24(sp)
    8000126a:	6b42                	ld	s6,16(sp)
    8000126c:	6ba2                	ld	s7,8(sp)
  }
}
    8000126e:	60a6                	ld	ra,72(sp)
    80001270:	6406                	ld	s0,64(sp)
    80001272:	6161                	addi	sp,sp,80
    80001274:	8082                	ret

0000000080001276 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001276:	1101                	addi	sp,sp,-32
    80001278:	ec06                	sd	ra,24(sp)
    8000127a:	e822                	sd	s0,16(sp)
    8000127c:	e426                	sd	s1,8(sp)
    8000127e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001280:	8a5ff0ef          	jal	80000b24 <kalloc>
    80001284:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001286:	c509                	beqz	a0,80001290 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001288:	6605                	lui	a2,0x1
    8000128a:	4581                	li	a1,0
    8000128c:	a3dff0ef          	jal	80000cc8 <memset>
  return pagetable;
}
    80001290:	8526                	mv	a0,s1
    80001292:	60e2                	ld	ra,24(sp)
    80001294:	6442                	ld	s0,16(sp)
    80001296:	64a2                	ld	s1,8(sp)
    80001298:	6105                	addi	sp,sp,32
    8000129a:	8082                	ret

000000008000129c <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000129c:	7179                	addi	sp,sp,-48
    8000129e:	f406                	sd	ra,40(sp)
    800012a0:	f022                	sd	s0,32(sp)
    800012a2:	ec26                	sd	s1,24(sp)
    800012a4:	e84a                	sd	s2,16(sp)
    800012a6:	e44e                	sd	s3,8(sp)
    800012a8:	e052                	sd	s4,0(sp)
    800012aa:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800012ac:	6785                	lui	a5,0x1
    800012ae:	04f67063          	bgeu	a2,a5,800012ee <uvmfirst+0x52>
    800012b2:	8a2a                	mv	s4,a0
    800012b4:	89ae                	mv	s3,a1
    800012b6:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800012b8:	86dff0ef          	jal	80000b24 <kalloc>
    800012bc:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800012be:	6605                	lui	a2,0x1
    800012c0:	4581                	li	a1,0
    800012c2:	a07ff0ef          	jal	80000cc8 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800012c6:	4779                	li	a4,30
    800012c8:	86ca                	mv	a3,s2
    800012ca:	6605                	lui	a2,0x1
    800012cc:	4581                	li	a1,0
    800012ce:	8552                	mv	a0,s4
    800012d0:	d45ff0ef          	jal	80001014 <mappages>
  memmove(mem, src, sz);
    800012d4:	8626                	mv	a2,s1
    800012d6:	85ce                	mv	a1,s3
    800012d8:	854a                	mv	a0,s2
    800012da:	a4bff0ef          	jal	80000d24 <memmove>
}
    800012de:	70a2                	ld	ra,40(sp)
    800012e0:	7402                	ld	s0,32(sp)
    800012e2:	64e2                	ld	s1,24(sp)
    800012e4:	6942                	ld	s2,16(sp)
    800012e6:	69a2                	ld	s3,8(sp)
    800012e8:	6a02                	ld	s4,0(sp)
    800012ea:	6145                	addi	sp,sp,48
    800012ec:	8082                	ret
    panic("uvmfirst: more than a page");
    800012ee:	00007517          	auipc	a0,0x7
    800012f2:	e8a50513          	addi	a0,a0,-374 # 80008178 <etext+0x178>
    800012f6:	c9eff0ef          	jal	80000794 <panic>

00000000800012fa <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800012fa:	1101                	addi	sp,sp,-32
    800012fc:	ec06                	sd	ra,24(sp)
    800012fe:	e822                	sd	s0,16(sp)
    80001300:	e426                	sd	s1,8(sp)
    80001302:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001304:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001306:	00b67d63          	bgeu	a2,a1,80001320 <uvmdealloc+0x26>
    8000130a:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000130c:	6785                	lui	a5,0x1
    8000130e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001310:	00f60733          	add	a4,a2,a5
    80001314:	76fd                	lui	a3,0xfffff
    80001316:	8f75                	and	a4,a4,a3
    80001318:	97ae                	add	a5,a5,a1
    8000131a:	8ff5                	and	a5,a5,a3
    8000131c:	00f76863          	bltu	a4,a5,8000132c <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001320:	8526                	mv	a0,s1
    80001322:	60e2                	ld	ra,24(sp)
    80001324:	6442                	ld	s0,16(sp)
    80001326:	64a2                	ld	s1,8(sp)
    80001328:	6105                	addi	sp,sp,32
    8000132a:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000132c:	8f99                	sub	a5,a5,a4
    8000132e:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001330:	4685                	li	a3,1
    80001332:	0007861b          	sext.w	a2,a5
    80001336:	85ba                	mv	a1,a4
    80001338:	e83ff0ef          	jal	800011ba <uvmunmap>
    8000133c:	b7d5                	j	80001320 <uvmdealloc+0x26>

000000008000133e <uvmalloc>:
  if(newsz < oldsz)
    8000133e:	08b66f63          	bltu	a2,a1,800013dc <uvmalloc+0x9e>
{
    80001342:	7139                	addi	sp,sp,-64
    80001344:	fc06                	sd	ra,56(sp)
    80001346:	f822                	sd	s0,48(sp)
    80001348:	ec4e                	sd	s3,24(sp)
    8000134a:	e852                	sd	s4,16(sp)
    8000134c:	e456                	sd	s5,8(sp)
    8000134e:	0080                	addi	s0,sp,64
    80001350:	8aaa                	mv	s5,a0
    80001352:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001354:	6785                	lui	a5,0x1
    80001356:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001358:	95be                	add	a1,a1,a5
    8000135a:	77fd                	lui	a5,0xfffff
    8000135c:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001360:	08c9f063          	bgeu	s3,a2,800013e0 <uvmalloc+0xa2>
    80001364:	f426                	sd	s1,40(sp)
    80001366:	f04a                	sd	s2,32(sp)
    80001368:	e05a                	sd	s6,0(sp)
    8000136a:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000136c:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001370:	fb4ff0ef          	jal	80000b24 <kalloc>
    80001374:	84aa                	mv	s1,a0
    if(mem == 0){
    80001376:	c515                	beqz	a0,800013a2 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001378:	6605                	lui	a2,0x1
    8000137a:	4581                	li	a1,0
    8000137c:	94dff0ef          	jal	80000cc8 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001380:	875a                	mv	a4,s6
    80001382:	86a6                	mv	a3,s1
    80001384:	6605                	lui	a2,0x1
    80001386:	85ca                	mv	a1,s2
    80001388:	8556                	mv	a0,s5
    8000138a:	c8bff0ef          	jal	80001014 <mappages>
    8000138e:	e915                	bnez	a0,800013c2 <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001390:	6785                	lui	a5,0x1
    80001392:	993e                	add	s2,s2,a5
    80001394:	fd496ee3          	bltu	s2,s4,80001370 <uvmalloc+0x32>
  return newsz;
    80001398:	8552                	mv	a0,s4
    8000139a:	74a2                	ld	s1,40(sp)
    8000139c:	7902                	ld	s2,32(sp)
    8000139e:	6b02                	ld	s6,0(sp)
    800013a0:	a811                	j	800013b4 <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    800013a2:	864e                	mv	a2,s3
    800013a4:	85ca                	mv	a1,s2
    800013a6:	8556                	mv	a0,s5
    800013a8:	f53ff0ef          	jal	800012fa <uvmdealloc>
      return 0;
    800013ac:	4501                	li	a0,0
    800013ae:	74a2                	ld	s1,40(sp)
    800013b0:	7902                	ld	s2,32(sp)
    800013b2:	6b02                	ld	s6,0(sp)
}
    800013b4:	70e2                	ld	ra,56(sp)
    800013b6:	7442                	ld	s0,48(sp)
    800013b8:	69e2                	ld	s3,24(sp)
    800013ba:	6a42                	ld	s4,16(sp)
    800013bc:	6aa2                	ld	s5,8(sp)
    800013be:	6121                	addi	sp,sp,64
    800013c0:	8082                	ret
      kfree(mem);
    800013c2:	8526                	mv	a0,s1
    800013c4:	e7eff0ef          	jal	80000a42 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800013c8:	864e                	mv	a2,s3
    800013ca:	85ca                	mv	a1,s2
    800013cc:	8556                	mv	a0,s5
    800013ce:	f2dff0ef          	jal	800012fa <uvmdealloc>
      return 0;
    800013d2:	4501                	li	a0,0
    800013d4:	74a2                	ld	s1,40(sp)
    800013d6:	7902                	ld	s2,32(sp)
    800013d8:	6b02                	ld	s6,0(sp)
    800013da:	bfe9                	j	800013b4 <uvmalloc+0x76>
    return oldsz;
    800013dc:	852e                	mv	a0,a1
}
    800013de:	8082                	ret
  return newsz;
    800013e0:	8532                	mv	a0,a2
    800013e2:	bfc9                	j	800013b4 <uvmalloc+0x76>

00000000800013e4 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800013e4:	7179                	addi	sp,sp,-48
    800013e6:	f406                	sd	ra,40(sp)
    800013e8:	f022                	sd	s0,32(sp)
    800013ea:	ec26                	sd	s1,24(sp)
    800013ec:	e84a                	sd	s2,16(sp)
    800013ee:	e44e                	sd	s3,8(sp)
    800013f0:	e052                	sd	s4,0(sp)
    800013f2:	1800                	addi	s0,sp,48
    800013f4:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800013f6:	84aa                	mv	s1,a0
    800013f8:	6905                	lui	s2,0x1
    800013fa:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800013fc:	4985                	li	s3,1
    800013fe:	a819                	j	80001414 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001400:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001402:	00c79513          	slli	a0,a5,0xc
    80001406:	fdfff0ef          	jal	800013e4 <freewalk>
      pagetable[i] = 0;
    8000140a:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000140e:	04a1                	addi	s1,s1,8
    80001410:	01248f63          	beq	s1,s2,8000142e <freewalk+0x4a>
    pte_t pte = pagetable[i];
    80001414:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001416:	00f7f713          	andi	a4,a5,15
    8000141a:	ff3703e3          	beq	a4,s3,80001400 <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000141e:	8b85                	andi	a5,a5,1
    80001420:	d7fd                	beqz	a5,8000140e <freewalk+0x2a>
      panic("freewalk: leaf");
    80001422:	00007517          	auipc	a0,0x7
    80001426:	d7650513          	addi	a0,a0,-650 # 80008198 <etext+0x198>
    8000142a:	b6aff0ef          	jal	80000794 <panic>
    }
  }
  kfree((void*)pagetable);
    8000142e:	8552                	mv	a0,s4
    80001430:	e12ff0ef          	jal	80000a42 <kfree>
}
    80001434:	70a2                	ld	ra,40(sp)
    80001436:	7402                	ld	s0,32(sp)
    80001438:	64e2                	ld	s1,24(sp)
    8000143a:	6942                	ld	s2,16(sp)
    8000143c:	69a2                	ld	s3,8(sp)
    8000143e:	6a02                	ld	s4,0(sp)
    80001440:	6145                	addi	sp,sp,48
    80001442:	8082                	ret

0000000080001444 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001444:	1101                	addi	sp,sp,-32
    80001446:	ec06                	sd	ra,24(sp)
    80001448:	e822                	sd	s0,16(sp)
    8000144a:	e426                	sd	s1,8(sp)
    8000144c:	1000                	addi	s0,sp,32
    8000144e:	84aa                	mv	s1,a0
  if(sz > 0)
    80001450:	e989                	bnez	a1,80001462 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001452:	8526                	mv	a0,s1
    80001454:	f91ff0ef          	jal	800013e4 <freewalk>
}
    80001458:	60e2                	ld	ra,24(sp)
    8000145a:	6442                	ld	s0,16(sp)
    8000145c:	64a2                	ld	s1,8(sp)
    8000145e:	6105                	addi	sp,sp,32
    80001460:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001462:	6785                	lui	a5,0x1
    80001464:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001466:	95be                	add	a1,a1,a5
    80001468:	4685                	li	a3,1
    8000146a:	00c5d613          	srli	a2,a1,0xc
    8000146e:	4581                	li	a1,0
    80001470:	d4bff0ef          	jal	800011ba <uvmunmap>
    80001474:	bff9                	j	80001452 <uvmfree+0xe>

0000000080001476 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001476:	c65d                	beqz	a2,80001524 <uvmcopy+0xae>
{
    80001478:	715d                	addi	sp,sp,-80
    8000147a:	e486                	sd	ra,72(sp)
    8000147c:	e0a2                	sd	s0,64(sp)
    8000147e:	fc26                	sd	s1,56(sp)
    80001480:	f84a                	sd	s2,48(sp)
    80001482:	f44e                	sd	s3,40(sp)
    80001484:	f052                	sd	s4,32(sp)
    80001486:	ec56                	sd	s5,24(sp)
    80001488:	e85a                	sd	s6,16(sp)
    8000148a:	e45e                	sd	s7,8(sp)
    8000148c:	0880                	addi	s0,sp,80
    8000148e:	8b2a                	mv	s6,a0
    80001490:	8aae                	mv	s5,a1
    80001492:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001494:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001496:	4601                	li	a2,0
    80001498:	85ce                	mv	a1,s3
    8000149a:	855a                	mv	a0,s6
    8000149c:	aa1ff0ef          	jal	80000f3c <walk>
    800014a0:	c121                	beqz	a0,800014e0 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    800014a2:	6118                	ld	a4,0(a0)
    800014a4:	00177793          	andi	a5,a4,1
    800014a8:	c3b1                	beqz	a5,800014ec <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    800014aa:	00a75593          	srli	a1,a4,0xa
    800014ae:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800014b2:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800014b6:	e6eff0ef          	jal	80000b24 <kalloc>
    800014ba:	892a                	mv	s2,a0
    800014bc:	c129                	beqz	a0,800014fe <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800014be:	6605                	lui	a2,0x1
    800014c0:	85de                	mv	a1,s7
    800014c2:	863ff0ef          	jal	80000d24 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800014c6:	8726                	mv	a4,s1
    800014c8:	86ca                	mv	a3,s2
    800014ca:	6605                	lui	a2,0x1
    800014cc:	85ce                	mv	a1,s3
    800014ce:	8556                	mv	a0,s5
    800014d0:	b45ff0ef          	jal	80001014 <mappages>
    800014d4:	e115                	bnez	a0,800014f8 <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    800014d6:	6785                	lui	a5,0x1
    800014d8:	99be                	add	s3,s3,a5
    800014da:	fb49eee3          	bltu	s3,s4,80001496 <uvmcopy+0x20>
    800014de:	a805                	j	8000150e <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    800014e0:	00007517          	auipc	a0,0x7
    800014e4:	cc850513          	addi	a0,a0,-824 # 800081a8 <etext+0x1a8>
    800014e8:	aacff0ef          	jal	80000794 <panic>
      panic("uvmcopy: page not present");
    800014ec:	00007517          	auipc	a0,0x7
    800014f0:	cdc50513          	addi	a0,a0,-804 # 800081c8 <etext+0x1c8>
    800014f4:	aa0ff0ef          	jal	80000794 <panic>
      kfree(mem);
    800014f8:	854a                	mv	a0,s2
    800014fa:	d48ff0ef          	jal	80000a42 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800014fe:	4685                	li	a3,1
    80001500:	00c9d613          	srli	a2,s3,0xc
    80001504:	4581                	li	a1,0
    80001506:	8556                	mv	a0,s5
    80001508:	cb3ff0ef          	jal	800011ba <uvmunmap>
  return -1;
    8000150c:	557d                	li	a0,-1
}
    8000150e:	60a6                	ld	ra,72(sp)
    80001510:	6406                	ld	s0,64(sp)
    80001512:	74e2                	ld	s1,56(sp)
    80001514:	7942                	ld	s2,48(sp)
    80001516:	79a2                	ld	s3,40(sp)
    80001518:	7a02                	ld	s4,32(sp)
    8000151a:	6ae2                	ld	s5,24(sp)
    8000151c:	6b42                	ld	s6,16(sp)
    8000151e:	6ba2                	ld	s7,8(sp)
    80001520:	6161                	addi	sp,sp,80
    80001522:	8082                	ret
  return 0;
    80001524:	4501                	li	a0,0
}
    80001526:	8082                	ret

0000000080001528 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001528:	1141                	addi	sp,sp,-16
    8000152a:	e406                	sd	ra,8(sp)
    8000152c:	e022                	sd	s0,0(sp)
    8000152e:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001530:	4601                	li	a2,0
    80001532:	a0bff0ef          	jal	80000f3c <walk>
  if(pte == 0)
    80001536:	c901                	beqz	a0,80001546 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001538:	611c                	ld	a5,0(a0)
    8000153a:	9bbd                	andi	a5,a5,-17
    8000153c:	e11c                	sd	a5,0(a0)
}
    8000153e:	60a2                	ld	ra,8(sp)
    80001540:	6402                	ld	s0,0(sp)
    80001542:	0141                	addi	sp,sp,16
    80001544:	8082                	ret
    panic("uvmclear");
    80001546:	00007517          	auipc	a0,0x7
    8000154a:	ca250513          	addi	a0,a0,-862 # 800081e8 <etext+0x1e8>
    8000154e:	a46ff0ef          	jal	80000794 <panic>

0000000080001552 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80001552:	cad1                	beqz	a3,800015e6 <copyout+0x94>
{
    80001554:	711d                	addi	sp,sp,-96
    80001556:	ec86                	sd	ra,88(sp)
    80001558:	e8a2                	sd	s0,80(sp)
    8000155a:	e4a6                	sd	s1,72(sp)
    8000155c:	fc4e                	sd	s3,56(sp)
    8000155e:	f456                	sd	s5,40(sp)
    80001560:	f05a                	sd	s6,32(sp)
    80001562:	ec5e                	sd	s7,24(sp)
    80001564:	1080                	addi	s0,sp,96
    80001566:	8baa                	mv	s7,a0
    80001568:	8aae                	mv	s5,a1
    8000156a:	8b32                	mv	s6,a2
    8000156c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000156e:	74fd                	lui	s1,0xfffff
    80001570:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80001572:	57fd                	li	a5,-1
    80001574:	83e9                	srli	a5,a5,0x1a
    80001576:	0697ea63          	bltu	a5,s1,800015ea <copyout+0x98>
    8000157a:	e0ca                	sd	s2,64(sp)
    8000157c:	f852                	sd	s4,48(sp)
    8000157e:	e862                	sd	s8,16(sp)
    80001580:	e466                	sd	s9,8(sp)
    80001582:	e06a                	sd	s10,0(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80001584:	4cd5                	li	s9,21
    80001586:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80001588:	8c3e                	mv	s8,a5
    8000158a:	a025                	j	800015b2 <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    8000158c:	83a9                	srli	a5,a5,0xa
    8000158e:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001590:	409a8533          	sub	a0,s5,s1
    80001594:	0009061b          	sext.w	a2,s2
    80001598:	85da                	mv	a1,s6
    8000159a:	953e                	add	a0,a0,a5
    8000159c:	f88ff0ef          	jal	80000d24 <memmove>

    len -= n;
    800015a0:	412989b3          	sub	s3,s3,s2
    src += n;
    800015a4:	9b4a                	add	s6,s6,s2
  while(len > 0){
    800015a6:	02098963          	beqz	s3,800015d8 <copyout+0x86>
    if(va0 >= MAXVA)
    800015aa:	054c6263          	bltu	s8,s4,800015ee <copyout+0x9c>
    800015ae:	84d2                	mv	s1,s4
    800015b0:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    800015b2:	4601                	li	a2,0
    800015b4:	85a6                	mv	a1,s1
    800015b6:	855e                	mv	a0,s7
    800015b8:	985ff0ef          	jal	80000f3c <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800015bc:	c121                	beqz	a0,800015fc <copyout+0xaa>
    800015be:	611c                	ld	a5,0(a0)
    800015c0:	0157f713          	andi	a4,a5,21
    800015c4:	05971b63          	bne	a4,s9,8000161a <copyout+0xc8>
    n = PGSIZE - (dstva - va0);
    800015c8:	01a48a33          	add	s4,s1,s10
    800015cc:	415a0933          	sub	s2,s4,s5
    if(n > len)
    800015d0:	fb29fee3          	bgeu	s3,s2,8000158c <copyout+0x3a>
    800015d4:	894e                	mv	s2,s3
    800015d6:	bf5d                	j	8000158c <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    800015d8:	4501                	li	a0,0
    800015da:	6906                	ld	s2,64(sp)
    800015dc:	7a42                	ld	s4,48(sp)
    800015de:	6c42                	ld	s8,16(sp)
    800015e0:	6ca2                	ld	s9,8(sp)
    800015e2:	6d02                	ld	s10,0(sp)
    800015e4:	a015                	j	80001608 <copyout+0xb6>
    800015e6:	4501                	li	a0,0
}
    800015e8:	8082                	ret
      return -1;
    800015ea:	557d                	li	a0,-1
    800015ec:	a831                	j	80001608 <copyout+0xb6>
    800015ee:	557d                	li	a0,-1
    800015f0:	6906                	ld	s2,64(sp)
    800015f2:	7a42                	ld	s4,48(sp)
    800015f4:	6c42                	ld	s8,16(sp)
    800015f6:	6ca2                	ld	s9,8(sp)
    800015f8:	6d02                	ld	s10,0(sp)
    800015fa:	a039                	j	80001608 <copyout+0xb6>
      return -1;
    800015fc:	557d                	li	a0,-1
    800015fe:	6906                	ld	s2,64(sp)
    80001600:	7a42                	ld	s4,48(sp)
    80001602:	6c42                	ld	s8,16(sp)
    80001604:	6ca2                	ld	s9,8(sp)
    80001606:	6d02                	ld	s10,0(sp)
}
    80001608:	60e6                	ld	ra,88(sp)
    8000160a:	6446                	ld	s0,80(sp)
    8000160c:	64a6                	ld	s1,72(sp)
    8000160e:	79e2                	ld	s3,56(sp)
    80001610:	7aa2                	ld	s5,40(sp)
    80001612:	7b02                	ld	s6,32(sp)
    80001614:	6be2                	ld	s7,24(sp)
    80001616:	6125                	addi	sp,sp,96
    80001618:	8082                	ret
      return -1;
    8000161a:	557d                	li	a0,-1
    8000161c:	6906                	ld	s2,64(sp)
    8000161e:	7a42                	ld	s4,48(sp)
    80001620:	6c42                	ld	s8,16(sp)
    80001622:	6ca2                	ld	s9,8(sp)
    80001624:	6d02                	ld	s10,0(sp)
    80001626:	b7cd                	j	80001608 <copyout+0xb6>

0000000080001628 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001628:	c6a5                	beqz	a3,80001690 <copyin+0x68>
{
    8000162a:	715d                	addi	sp,sp,-80
    8000162c:	e486                	sd	ra,72(sp)
    8000162e:	e0a2                	sd	s0,64(sp)
    80001630:	fc26                	sd	s1,56(sp)
    80001632:	f84a                	sd	s2,48(sp)
    80001634:	f44e                	sd	s3,40(sp)
    80001636:	f052                	sd	s4,32(sp)
    80001638:	ec56                	sd	s5,24(sp)
    8000163a:	e85a                	sd	s6,16(sp)
    8000163c:	e45e                	sd	s7,8(sp)
    8000163e:	e062                	sd	s8,0(sp)
    80001640:	0880                	addi	s0,sp,80
    80001642:	8b2a                	mv	s6,a0
    80001644:	8a2e                	mv	s4,a1
    80001646:	8c32                	mv	s8,a2
    80001648:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    8000164a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000164c:	6a85                	lui	s5,0x1
    8000164e:	a00d                	j	80001670 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001650:	018505b3          	add	a1,a0,s8
    80001654:	0004861b          	sext.w	a2,s1
    80001658:	412585b3          	sub	a1,a1,s2
    8000165c:	8552                	mv	a0,s4
    8000165e:	ec6ff0ef          	jal	80000d24 <memmove>

    len -= n;
    80001662:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001666:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001668:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000166c:	02098063          	beqz	s3,8000168c <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80001670:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001674:	85ca                	mv	a1,s2
    80001676:	855a                	mv	a0,s6
    80001678:	95fff0ef          	jal	80000fd6 <walkaddr>
    if(pa0 == 0)
    8000167c:	cd01                	beqz	a0,80001694 <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    8000167e:	418904b3          	sub	s1,s2,s8
    80001682:	94d6                	add	s1,s1,s5
    if(n > len)
    80001684:	fc99f6e3          	bgeu	s3,s1,80001650 <copyin+0x28>
    80001688:	84ce                	mv	s1,s3
    8000168a:	b7d9                	j	80001650 <copyin+0x28>
  }
  return 0;
    8000168c:	4501                	li	a0,0
    8000168e:	a021                	j	80001696 <copyin+0x6e>
    80001690:	4501                	li	a0,0
}
    80001692:	8082                	ret
      return -1;
    80001694:	557d                	li	a0,-1
}
    80001696:	60a6                	ld	ra,72(sp)
    80001698:	6406                	ld	s0,64(sp)
    8000169a:	74e2                	ld	s1,56(sp)
    8000169c:	7942                	ld	s2,48(sp)
    8000169e:	79a2                	ld	s3,40(sp)
    800016a0:	7a02                	ld	s4,32(sp)
    800016a2:	6ae2                	ld	s5,24(sp)
    800016a4:	6b42                	ld	s6,16(sp)
    800016a6:	6ba2                	ld	s7,8(sp)
    800016a8:	6c02                	ld	s8,0(sp)
    800016aa:	6161                	addi	sp,sp,80
    800016ac:	8082                	ret

00000000800016ae <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800016ae:	c6dd                	beqz	a3,8000175c <copyinstr+0xae>
{
    800016b0:	715d                	addi	sp,sp,-80
    800016b2:	e486                	sd	ra,72(sp)
    800016b4:	e0a2                	sd	s0,64(sp)
    800016b6:	fc26                	sd	s1,56(sp)
    800016b8:	f84a                	sd	s2,48(sp)
    800016ba:	f44e                	sd	s3,40(sp)
    800016bc:	f052                	sd	s4,32(sp)
    800016be:	ec56                	sd	s5,24(sp)
    800016c0:	e85a                	sd	s6,16(sp)
    800016c2:	e45e                	sd	s7,8(sp)
    800016c4:	0880                	addi	s0,sp,80
    800016c6:	8a2a                	mv	s4,a0
    800016c8:	8b2e                	mv	s6,a1
    800016ca:	8bb2                	mv	s7,a2
    800016cc:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    800016ce:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800016d0:	6985                	lui	s3,0x1
    800016d2:	a825                	j	8000170a <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800016d4:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800016d8:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800016da:	37fd                	addiw	a5,a5,-1
    800016dc:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800016e0:	60a6                	ld	ra,72(sp)
    800016e2:	6406                	ld	s0,64(sp)
    800016e4:	74e2                	ld	s1,56(sp)
    800016e6:	7942                	ld	s2,48(sp)
    800016e8:	79a2                	ld	s3,40(sp)
    800016ea:	7a02                	ld	s4,32(sp)
    800016ec:	6ae2                	ld	s5,24(sp)
    800016ee:	6b42                	ld	s6,16(sp)
    800016f0:	6ba2                	ld	s7,8(sp)
    800016f2:	6161                	addi	sp,sp,80
    800016f4:	8082                	ret
    800016f6:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    800016fa:	9742                	add	a4,a4,a6
      --max;
    800016fc:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80001700:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80001704:	04e58463          	beq	a1,a4,8000174c <copyinstr+0x9e>
{
    80001708:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    8000170a:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    8000170e:	85a6                	mv	a1,s1
    80001710:	8552                	mv	a0,s4
    80001712:	8c5ff0ef          	jal	80000fd6 <walkaddr>
    if(pa0 == 0)
    80001716:	cd0d                	beqz	a0,80001750 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80001718:	417486b3          	sub	a3,s1,s7
    8000171c:	96ce                	add	a3,a3,s3
    if(n > max)
    8000171e:	00d97363          	bgeu	s2,a3,80001724 <copyinstr+0x76>
    80001722:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80001724:	955e                	add	a0,a0,s7
    80001726:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80001728:	c695                	beqz	a3,80001754 <copyinstr+0xa6>
    8000172a:	87da                	mv	a5,s6
    8000172c:	885a                	mv	a6,s6
      if(*p == '\0'){
    8000172e:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80001732:	96da                	add	a3,a3,s6
    80001734:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001736:	00f60733          	add	a4,a2,a5
    8000173a:	00074703          	lbu	a4,0(a4)
    8000173e:	db59                	beqz	a4,800016d4 <copyinstr+0x26>
        *dst = *p;
    80001740:	00e78023          	sb	a4,0(a5)
      dst++;
    80001744:	0785                	addi	a5,a5,1
    while(n > 0){
    80001746:	fed797e3          	bne	a5,a3,80001734 <copyinstr+0x86>
    8000174a:	b775                	j	800016f6 <copyinstr+0x48>
    8000174c:	4781                	li	a5,0
    8000174e:	b771                	j	800016da <copyinstr+0x2c>
      return -1;
    80001750:	557d                	li	a0,-1
    80001752:	b779                	j	800016e0 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80001754:	6b85                	lui	s7,0x1
    80001756:	9ba6                	add	s7,s7,s1
    80001758:	87da                	mv	a5,s6
    8000175a:	b77d                	j	80001708 <copyinstr+0x5a>
  int got_null = 0;
    8000175c:	4781                	li	a5,0
  if(got_null){
    8000175e:	37fd                	addiw	a5,a5,-1
    80001760:	0007851b          	sext.w	a0,a5
}
    80001764:	8082                	ret

0000000080001766 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001766:	7139                	addi	sp,sp,-64
    80001768:	fc06                	sd	ra,56(sp)
    8000176a:	f822                	sd	s0,48(sp)
    8000176c:	f426                	sd	s1,40(sp)
    8000176e:	f04a                	sd	s2,32(sp)
    80001770:	ec4e                	sd	s3,24(sp)
    80001772:	e852                	sd	s4,16(sp)
    80001774:	e456                	sd	s5,8(sp)
    80001776:	e05a                	sd	s6,0(sp)
    80001778:	0080                	addi	s0,sp,64
    8000177a:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    8000177c:	00012497          	auipc	s1,0x12
    80001780:	4cc48493          	addi	s1,s1,1228 # 80013c48 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001784:	8b26                	mv	s6,s1
    80001786:	ff4df937          	lui	s2,0xff4df
    8000178a:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b9d95>
    8000178e:	0936                	slli	s2,s2,0xd
    80001790:	6f590913          	addi	s2,s2,1781
    80001794:	0936                	slli	s2,s2,0xd
    80001796:	bd390913          	addi	s2,s2,-1069
    8000179a:	0932                	slli	s2,s2,0xc
    8000179c:	7a790913          	addi	s2,s2,1959
    800017a0:	040009b7          	lui	s3,0x4000
    800017a4:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800017a6:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800017a8:	00018a97          	auipc	s5,0x18
    800017ac:	0a0a8a93          	addi	s5,s5,160 # 80019848 <tickslock>
    char *pa = kalloc();
    800017b0:	b74ff0ef          	jal	80000b24 <kalloc>
    800017b4:	862a                	mv	a2,a0
    if(pa == 0)
    800017b6:	cd15                	beqz	a0,800017f2 <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    800017b8:	416485b3          	sub	a1,s1,s6
    800017bc:	8591                	srai	a1,a1,0x4
    800017be:	032585b3          	mul	a1,a1,s2
    800017c2:	2585                	addiw	a1,a1,1
    800017c4:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017c8:	4719                	li	a4,6
    800017ca:	6685                	lui	a3,0x1
    800017cc:	40b985b3          	sub	a1,s3,a1
    800017d0:	8552                	mv	a0,s4
    800017d2:	8f3ff0ef          	jal	800010c4 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017d6:	17048493          	addi	s1,s1,368
    800017da:	fd549be3          	bne	s1,s5,800017b0 <proc_mapstacks+0x4a>
  }
}
    800017de:	70e2                	ld	ra,56(sp)
    800017e0:	7442                	ld	s0,48(sp)
    800017e2:	74a2                	ld	s1,40(sp)
    800017e4:	7902                	ld	s2,32(sp)
    800017e6:	69e2                	ld	s3,24(sp)
    800017e8:	6a42                	ld	s4,16(sp)
    800017ea:	6aa2                	ld	s5,8(sp)
    800017ec:	6b02                	ld	s6,0(sp)
    800017ee:	6121                	addi	sp,sp,64
    800017f0:	8082                	ret
      panic("kalloc");
    800017f2:	00007517          	auipc	a0,0x7
    800017f6:	a0650513          	addi	a0,a0,-1530 # 800081f8 <etext+0x1f8>
    800017fa:	f9bfe0ef          	jal	80000794 <panic>

00000000800017fe <procinit>:

// initialize the proc table.
void
procinit(void)
{
    800017fe:	715d                	addi	sp,sp,-80
    80001800:	e486                	sd	ra,72(sp)
    80001802:	e0a2                	sd	s0,64(sp)
    80001804:	fc26                	sd	s1,56(sp)
    80001806:	f84a                	sd	s2,48(sp)
    80001808:	f44e                	sd	s3,40(sp)
    8000180a:	f052                	sd	s4,32(sp)
    8000180c:	ec56                	sd	s5,24(sp)
    8000180e:	e85a                	sd	s6,16(sp)
    80001810:	e45e                	sd	s7,8(sp)
    80001812:	0880                	addi	s0,sp,80
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001814:	00007597          	auipc	a1,0x7
    80001818:	9ec58593          	addi	a1,a1,-1556 # 80008200 <etext+0x200>
    8000181c:	00012517          	auipc	a0,0x12
    80001820:	fb450513          	addi	a0,a0,-76 # 800137d0 <pid_lock>
    80001824:	b50ff0ef          	jal	80000b74 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001828:	00007597          	auipc	a1,0x7
    8000182c:	9e058593          	addi	a1,a1,-1568 # 80008208 <etext+0x208>
    80001830:	00012517          	auipc	a0,0x12
    80001834:	fb850513          	addi	a0,a0,-72 # 800137e8 <wait_lock>
    80001838:	b3cff0ef          	jal	80000b74 <initlock>
  initlock(&schedmode_lock, "schedmode_lock");
    8000183c:	00007597          	auipc	a1,0x7
    80001840:	9dc58593          	addi	a1,a1,-1572 # 80008218 <etext+0x218>
    80001844:	00012517          	auipc	a0,0x12
    80001848:	fbc50513          	addi	a0,a0,-68 # 80013800 <schedmode_lock>
    8000184c:	b28ff0ef          	jal	80000b74 <initlock>
  initlock(&yieldpid_lock, "yieldpid_lock");
    80001850:	00007597          	auipc	a1,0x7
    80001854:	9d858593          	addi	a1,a1,-1576 # 80008228 <etext+0x228>
    80001858:	00012517          	auipc	a0,0x12
    8000185c:	fc050513          	addi	a0,a0,-64 # 80013818 <yieldpid_lock>
    80001860:	b14ff0ef          	jal	80000b74 <initlock>
  initlock(&lastpid_lock, "lastpid_lock");
    80001864:	00007597          	auipc	a1,0x7
    80001868:	9d458593          	addi	a1,a1,-1580 # 80008238 <etext+0x238>
    8000186c:	00012517          	auipc	a0,0x12
    80001870:	fc450513          	addi	a0,a0,-60 # 80013830 <lastpid_lock>
    80001874:	b00ff0ef          	jal	80000b74 <initlock>

  for(p = proc; p < &proc[NPROC]; p++) {
    80001878:	00012497          	auipc	s1,0x12
    8000187c:	3d048493          	addi	s1,s1,976 # 80013c48 <proc>
      initlock(&p->lock, "proc");
    80001880:	00007b97          	auipc	s7,0x7
    80001884:	9c8b8b93          	addi	s7,s7,-1592 # 80008248 <etext+0x248>
      p->state = UNUSED;
      p->qnum = FCFSMODE;
    80001888:	597d                	li	s2,-1
      p->tq = FCFSMODE;
      p->priority = FCFSMODE;
      p->kstack = KSTACK((int) (p - proc));
    8000188a:	8b26                	mv	s6,s1
    8000188c:	ff4df9b7          	lui	s3,0xff4df
    80001890:	9bd98993          	addi	s3,s3,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b9d95>
    80001894:	09b6                	slli	s3,s3,0xd
    80001896:	6f598993          	addi	s3,s3,1781
    8000189a:	09b6                	slli	s3,s3,0xd
    8000189c:	bd398993          	addi	s3,s3,-1069
    800018a0:	09b2                	slli	s3,s3,0xc
    800018a2:	7a798993          	addi	s3,s3,1959
    800018a6:	04000a37          	lui	s4,0x4000
    800018aa:	1a7d                	addi	s4,s4,-1 # 3ffffff <_entry-0x7c000001>
    800018ac:	0a32                	slli	s4,s4,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800018ae:	00018a97          	auipc	s5,0x18
    800018b2:	f9aa8a93          	addi	s5,s5,-102 # 80019848 <tickslock>
      initlock(&p->lock, "proc");
    800018b6:	85de                	mv	a1,s7
    800018b8:	8526                	mv	a0,s1
    800018ba:	abaff0ef          	jal	80000b74 <initlock>
      p->state = UNUSED;
    800018be:	0004ac23          	sw	zero,24(s1)
      p->qnum = FCFSMODE;
    800018c2:	0324ac23          	sw	s2,56(s1)
      p->tq = FCFSMODE;
    800018c6:	0324aa23          	sw	s2,52(s1)
      p->priority = FCFSMODE;
    800018ca:	0324ae23          	sw	s2,60(s1)
      p->kstack = KSTACK((int) (p - proc));
    800018ce:	416487b3          	sub	a5,s1,s6
    800018d2:	8791                	srai	a5,a5,0x4
    800018d4:	033787b3          	mul	a5,a5,s3
    800018d8:	2785                	addiw	a5,a5,1
    800018da:	00d7979b          	slliw	a5,a5,0xd
    800018de:	40fa07b3          	sub	a5,s4,a5
    800018e2:	e4bc                	sd	a5,72(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800018e4:	17048493          	addi	s1,s1,368
    800018e8:	fd5497e3          	bne	s1,s5,800018b6 <procinit+0xb8>
  }
}
    800018ec:	60a6                	ld	ra,72(sp)
    800018ee:	6406                	ld	s0,64(sp)
    800018f0:	74e2                	ld	s1,56(sp)
    800018f2:	7942                	ld	s2,48(sp)
    800018f4:	79a2                	ld	s3,40(sp)
    800018f6:	7a02                	ld	s4,32(sp)
    800018f8:	6ae2                	ld	s5,24(sp)
    800018fa:	6b42                	ld	s6,16(sp)
    800018fc:	6ba2                	ld	s7,8(sp)
    800018fe:	6161                	addi	sp,sp,80
    80001900:	8082                	ret

0000000080001902 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001902:	1141                	addi	sp,sp,-16
    80001904:	e422                	sd	s0,8(sp)
    80001906:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001908:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    8000190a:	2501                	sext.w	a0,a0
    8000190c:	6422                	ld	s0,8(sp)
    8000190e:	0141                	addi	sp,sp,16
    80001910:	8082                	ret

0000000080001912 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001912:	1141                	addi	sp,sp,-16
    80001914:	e422                	sd	s0,8(sp)
    80001916:	0800                	addi	s0,sp,16
    80001918:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    8000191a:	2781                	sext.w	a5,a5
    8000191c:	079e                	slli	a5,a5,0x7
  return c;
}
    8000191e:	00012517          	auipc	a0,0x12
    80001922:	f2a50513          	addi	a0,a0,-214 # 80013848 <cpus>
    80001926:	953e                	add	a0,a0,a5
    80001928:	6422                	ld	s0,8(sp)
    8000192a:	0141                	addi	sp,sp,16
    8000192c:	8082                	ret

000000008000192e <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    8000192e:	1101                	addi	sp,sp,-32
    80001930:	ec06                	sd	ra,24(sp)
    80001932:	e822                	sd	s0,16(sp)
    80001934:	e426                	sd	s1,8(sp)
    80001936:	1000                	addi	s0,sp,32
  push_off();
    80001938:	a7cff0ef          	jal	80000bb4 <push_off>
    8000193c:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    8000193e:	2781                	sext.w	a5,a5
    80001940:	079e                	slli	a5,a5,0x7
    80001942:	00012717          	auipc	a4,0x12
    80001946:	e8e70713          	addi	a4,a4,-370 # 800137d0 <pid_lock>
    8000194a:	97ba                	add	a5,a5,a4
    8000194c:	7fa4                	ld	s1,120(a5)
  pop_off();
    8000194e:	aeaff0ef          	jal	80000c38 <pop_off>
  return p;
}
    80001952:	8526                	mv	a0,s1
    80001954:	60e2                	ld	ra,24(sp)
    80001956:	6442                	ld	s0,16(sp)
    80001958:	64a2                	ld	s1,8(sp)
    8000195a:	6105                	addi	sp,sp,32
    8000195c:	8082                	ret

000000008000195e <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000195e:	1141                	addi	sp,sp,-16
    80001960:	e406                	sd	ra,8(sp)
    80001962:	e022                	sd	s0,0(sp)
    80001964:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001966:	fc9ff0ef          	jal	8000192e <myproc>
    8000196a:	b22ff0ef          	jal	80000c8c <release>

  if (first) {
    8000196e:	0000a797          	auipc	a5,0xa
    80001972:	c827a783          	lw	a5,-894(a5) # 8000b5f0 <first.1>
    80001976:	e799                	bnez	a5,80001984 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80001978:	232010ef          	jal	80002baa <usertrapret>
}
    8000197c:	60a2                	ld	ra,8(sp)
    8000197e:	6402                	ld	s0,0(sp)
    80001980:	0141                	addi	sp,sp,16
    80001982:	8082                	ret
    fsinit(ROOTDEV);
    80001984:	4505                	li	a0,1
    80001986:	5f9010ef          	jal	8000377e <fsinit>
    first = 0;
    8000198a:	0000a797          	auipc	a5,0xa
    8000198e:	c607a323          	sw	zero,-922(a5) # 8000b5f0 <first.1>
    __sync_synchronize();
    80001992:	0330000f          	fence	rw,rw
    80001996:	b7cd                	j	80001978 <forkret+0x1a>

0000000080001998 <allocpid>:
{
    80001998:	1101                	addi	sp,sp,-32
    8000199a:	ec06                	sd	ra,24(sp)
    8000199c:	e822                	sd	s0,16(sp)
    8000199e:	e426                	sd	s1,8(sp)
    800019a0:	e04a                	sd	s2,0(sp)
    800019a2:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800019a4:	00012917          	auipc	s2,0x12
    800019a8:	e2c90913          	addi	s2,s2,-468 # 800137d0 <pid_lock>
    800019ac:	854a                	mv	a0,s2
    800019ae:	a46ff0ef          	jal	80000bf4 <acquire>
  pid = nextpid;
    800019b2:	0000a797          	auipc	a5,0xa
    800019b6:	c4278793          	addi	a5,a5,-958 # 8000b5f4 <nextpid>
    800019ba:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800019bc:	0014871b          	addiw	a4,s1,1
    800019c0:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800019c2:	854a                	mv	a0,s2
    800019c4:	ac8ff0ef          	jal	80000c8c <release>
}
    800019c8:	8526                	mv	a0,s1
    800019ca:	60e2                	ld	ra,24(sp)
    800019cc:	6442                	ld	s0,16(sp)
    800019ce:	64a2                	ld	s1,8(sp)
    800019d0:	6902                	ld	s2,0(sp)
    800019d2:	6105                	addi	sp,sp,32
    800019d4:	8082                	ret

00000000800019d6 <proc_pagetable>:
{
    800019d6:	1101                	addi	sp,sp,-32
    800019d8:	ec06                	sd	ra,24(sp)
    800019da:	e822                	sd	s0,16(sp)
    800019dc:	e426                	sd	s1,8(sp)
    800019de:	e04a                	sd	s2,0(sp)
    800019e0:	1000                	addi	s0,sp,32
    800019e2:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800019e4:	893ff0ef          	jal	80001276 <uvmcreate>
    800019e8:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800019ea:	cd05                	beqz	a0,80001a22 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800019ec:	4729                	li	a4,10
    800019ee:	00005697          	auipc	a3,0x5
    800019f2:	61268693          	addi	a3,a3,1554 # 80007000 <_trampoline>
    800019f6:	6605                	lui	a2,0x1
    800019f8:	040005b7          	lui	a1,0x4000
    800019fc:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800019fe:	05b2                	slli	a1,a1,0xc
    80001a00:	e14ff0ef          	jal	80001014 <mappages>
    80001a04:	02054663          	bltz	a0,80001a30 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001a08:	4719                	li	a4,6
    80001a0a:	06093683          	ld	a3,96(s2)
    80001a0e:	6605                	lui	a2,0x1
    80001a10:	020005b7          	lui	a1,0x2000
    80001a14:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a16:	05b6                	slli	a1,a1,0xd
    80001a18:	8526                	mv	a0,s1
    80001a1a:	dfaff0ef          	jal	80001014 <mappages>
    80001a1e:	00054f63          	bltz	a0,80001a3c <proc_pagetable+0x66>
}
    80001a22:	8526                	mv	a0,s1
    80001a24:	60e2                	ld	ra,24(sp)
    80001a26:	6442                	ld	s0,16(sp)
    80001a28:	64a2                	ld	s1,8(sp)
    80001a2a:	6902                	ld	s2,0(sp)
    80001a2c:	6105                	addi	sp,sp,32
    80001a2e:	8082                	ret
    uvmfree(pagetable, 0);
    80001a30:	4581                	li	a1,0
    80001a32:	8526                	mv	a0,s1
    80001a34:	a11ff0ef          	jal	80001444 <uvmfree>
    return 0;
    80001a38:	4481                	li	s1,0
    80001a3a:	b7e5                	j	80001a22 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a3c:	4681                	li	a3,0
    80001a3e:	4605                	li	a2,1
    80001a40:	040005b7          	lui	a1,0x4000
    80001a44:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a46:	05b2                	slli	a1,a1,0xc
    80001a48:	8526                	mv	a0,s1
    80001a4a:	f70ff0ef          	jal	800011ba <uvmunmap>
    uvmfree(pagetable, 0);
    80001a4e:	4581                	li	a1,0
    80001a50:	8526                	mv	a0,s1
    80001a52:	9f3ff0ef          	jal	80001444 <uvmfree>
    return 0;
    80001a56:	4481                	li	s1,0
    80001a58:	b7e9                	j	80001a22 <proc_pagetable+0x4c>

0000000080001a5a <proc_freepagetable>:
{
    80001a5a:	1101                	addi	sp,sp,-32
    80001a5c:	ec06                	sd	ra,24(sp)
    80001a5e:	e822                	sd	s0,16(sp)
    80001a60:	e426                	sd	s1,8(sp)
    80001a62:	e04a                	sd	s2,0(sp)
    80001a64:	1000                	addi	s0,sp,32
    80001a66:	84aa                	mv	s1,a0
    80001a68:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a6a:	4681                	li	a3,0
    80001a6c:	4605                	li	a2,1
    80001a6e:	040005b7          	lui	a1,0x4000
    80001a72:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a74:	05b2                	slli	a1,a1,0xc
    80001a76:	f44ff0ef          	jal	800011ba <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001a7a:	4681                	li	a3,0
    80001a7c:	4605                	li	a2,1
    80001a7e:	020005b7          	lui	a1,0x2000
    80001a82:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a84:	05b6                	slli	a1,a1,0xd
    80001a86:	8526                	mv	a0,s1
    80001a88:	f32ff0ef          	jal	800011ba <uvmunmap>
  uvmfree(pagetable, sz);
    80001a8c:	85ca                	mv	a1,s2
    80001a8e:	8526                	mv	a0,s1
    80001a90:	9b5ff0ef          	jal	80001444 <uvmfree>
}
    80001a94:	60e2                	ld	ra,24(sp)
    80001a96:	6442                	ld	s0,16(sp)
    80001a98:	64a2                	ld	s1,8(sp)
    80001a9a:	6902                	ld	s2,0(sp)
    80001a9c:	6105                	addi	sp,sp,32
    80001a9e:	8082                	ret

0000000080001aa0 <freeproc>:
{
    80001aa0:	1101                	addi	sp,sp,-32
    80001aa2:	ec06                	sd	ra,24(sp)
    80001aa4:	e822                	sd	s0,16(sp)
    80001aa6:	e426                	sd	s1,8(sp)
    80001aa8:	1000                	addi	s0,sp,32
    80001aaa:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001aac:	7128                	ld	a0,96(a0)
    80001aae:	c119                	beqz	a0,80001ab4 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001ab0:	f93fe0ef          	jal	80000a42 <kfree>
  p->trapframe = 0;
    80001ab4:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    80001ab8:	6ca8                	ld	a0,88(s1)
    80001aba:	c501                	beqz	a0,80001ac2 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001abc:	68ac                	ld	a1,80(s1)
    80001abe:	f9dff0ef          	jal	80001a5a <proc_freepagetable>
  p->pagetable = 0;
    80001ac2:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80001ac6:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    80001aca:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001ace:	0404b023          	sd	zero,64(s1)
  p->name[0] = 0;
    80001ad2:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001ad6:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001ada:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001ade:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001ae2:	0004ac23          	sw	zero,24(s1)
}
    80001ae6:	60e2                	ld	ra,24(sp)
    80001ae8:	6442                	ld	s0,16(sp)
    80001aea:	64a2                	ld	s1,8(sp)
    80001aec:	6105                	addi	sp,sp,32
    80001aee:	8082                	ret

0000000080001af0 <allocproc>:
{
    80001af0:	1101                	addi	sp,sp,-32
    80001af2:	ec06                	sd	ra,24(sp)
    80001af4:	e822                	sd	s0,16(sp)
    80001af6:	e426                	sd	s1,8(sp)
    80001af8:	e04a                	sd	s2,0(sp)
    80001afa:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001afc:	00012497          	auipc	s1,0x12
    80001b00:	14c48493          	addi	s1,s1,332 # 80013c48 <proc>
    80001b04:	00018917          	auipc	s2,0x18
    80001b08:	d4490913          	addi	s2,s2,-700 # 80019848 <tickslock>
    acquire(&p->lock);
    80001b0c:	8526                	mv	a0,s1
    80001b0e:	8e6ff0ef          	jal	80000bf4 <acquire>
    if(p->state == UNUSED) {
    80001b12:	4c9c                	lw	a5,24(s1)
    80001b14:	cb91                	beqz	a5,80001b28 <allocproc+0x38>
      release(&p->lock);
    80001b16:	8526                	mv	a0,s1
    80001b18:	974ff0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b1c:	17048493          	addi	s1,s1,368
    80001b20:	ff2496e3          	bne	s1,s2,80001b0c <allocproc+0x1c>
  return 0;
    80001b24:	4481                	li	s1,0
    80001b26:	a089                	j	80001b68 <allocproc+0x78>
  p->pid = allocpid();
    80001b28:	e71ff0ef          	jal	80001998 <allocpid>
    80001b2c:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001b2e:	4785                	li	a5,1
    80001b30:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001b32:	ff3fe0ef          	jal	80000b24 <kalloc>
    80001b36:	892a                	mv	s2,a0
    80001b38:	f0a8                	sd	a0,96(s1)
    80001b3a:	cd15                	beqz	a0,80001b76 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001b3c:	8526                	mv	a0,s1
    80001b3e:	e99ff0ef          	jal	800019d6 <proc_pagetable>
    80001b42:	892a                	mv	s2,a0
    80001b44:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    80001b46:	c121                	beqz	a0,80001b86 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001b48:	07000613          	li	a2,112
    80001b4c:	4581                	li	a1,0
    80001b4e:	06848513          	addi	a0,s1,104
    80001b52:	976ff0ef          	jal	80000cc8 <memset>
  p->context.ra = (uint64)forkret;
    80001b56:	00000797          	auipc	a5,0x0
    80001b5a:	e0878793          	addi	a5,a5,-504 # 8000195e <forkret>
    80001b5e:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001b60:	64bc                	ld	a5,72(s1)
    80001b62:	6705                	lui	a4,0x1
    80001b64:	97ba                	add	a5,a5,a4
    80001b66:	f8bc                	sd	a5,112(s1)
}
    80001b68:	8526                	mv	a0,s1
    80001b6a:	60e2                	ld	ra,24(sp)
    80001b6c:	6442                	ld	s0,16(sp)
    80001b6e:	64a2                	ld	s1,8(sp)
    80001b70:	6902                	ld	s2,0(sp)
    80001b72:	6105                	addi	sp,sp,32
    80001b74:	8082                	ret
    freeproc(p);
    80001b76:	8526                	mv	a0,s1
    80001b78:	f29ff0ef          	jal	80001aa0 <freeproc>
    release(&p->lock);
    80001b7c:	8526                	mv	a0,s1
    80001b7e:	90eff0ef          	jal	80000c8c <release>
    return 0;
    80001b82:	84ca                	mv	s1,s2
    80001b84:	b7d5                	j	80001b68 <allocproc+0x78>
    freeproc(p);
    80001b86:	8526                	mv	a0,s1
    80001b88:	f19ff0ef          	jal	80001aa0 <freeproc>
    release(&p->lock);
    80001b8c:	8526                	mv	a0,s1
    80001b8e:	8feff0ef          	jal	80000c8c <release>
    return 0;
    80001b92:	84ca                	mv	s1,s2
    80001b94:	bfd1                	j	80001b68 <allocproc+0x78>

0000000080001b96 <userinit>:
{
    80001b96:	1101                	addi	sp,sp,-32
    80001b98:	ec06                	sd	ra,24(sp)
    80001b9a:	e822                	sd	s0,16(sp)
    80001b9c:	e426                	sd	s1,8(sp)
    80001b9e:	1000                	addi	s0,sp,32
  p = allocproc();
    80001ba0:	f51ff0ef          	jal	80001af0 <allocproc>
    80001ba4:	84aa                	mv	s1,a0
  initproc = p;
    80001ba6:	0000a797          	auipc	a5,0xa
    80001baa:	aea7b923          	sd	a0,-1294(a5) # 8000b698 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001bae:	03400613          	li	a2,52
    80001bb2:	0000a597          	auipc	a1,0xa
    80001bb6:	a4e58593          	addi	a1,a1,-1458 # 8000b600 <initcode>
    80001bba:	6d28                	ld	a0,88(a0)
    80001bbc:	ee0ff0ef          	jal	8000129c <uvmfirst>
  p->sz = PGSIZE;
    80001bc0:	6785                	lui	a5,0x1
    80001bc2:	e8bc                	sd	a5,80(s1)
  p->trapframe->epc = 0;      // user program counter
    80001bc4:	70b8                	ld	a4,96(s1)
    80001bc6:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001bca:	70b8                	ld	a4,96(s1)
    80001bcc:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001bce:	4641                	li	a2,16
    80001bd0:	00006597          	auipc	a1,0x6
    80001bd4:	68058593          	addi	a1,a1,1664 # 80008250 <etext+0x250>
    80001bd8:	16048513          	addi	a0,s1,352
    80001bdc:	a2aff0ef          	jal	80000e06 <safestrcpy>
  p->cwd = namei("/");
    80001be0:	00006517          	auipc	a0,0x6
    80001be4:	68050513          	addi	a0,a0,1664 # 80008260 <etext+0x260>
    80001be8:	4a4020ef          	jal	8000408c <namei>
    80001bec:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80001bf0:	478d                	li	a5,3
    80001bf2:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001bf4:	8526                	mv	a0,s1
    80001bf6:	896ff0ef          	jal	80000c8c <release>
}
    80001bfa:	60e2                	ld	ra,24(sp)
    80001bfc:	6442                	ld	s0,16(sp)
    80001bfe:	64a2                	ld	s1,8(sp)
    80001c00:	6105                	addi	sp,sp,32
    80001c02:	8082                	ret

0000000080001c04 <growproc>:
{
    80001c04:	1101                	addi	sp,sp,-32
    80001c06:	ec06                	sd	ra,24(sp)
    80001c08:	e822                	sd	s0,16(sp)
    80001c0a:	e426                	sd	s1,8(sp)
    80001c0c:	e04a                	sd	s2,0(sp)
    80001c0e:	1000                	addi	s0,sp,32
    80001c10:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001c12:	d1dff0ef          	jal	8000192e <myproc>
    80001c16:	84aa                	mv	s1,a0
  sz = p->sz;
    80001c18:	692c                	ld	a1,80(a0)
  if(n > 0){
    80001c1a:	01204c63          	bgtz	s2,80001c32 <growproc+0x2e>
  } else if(n < 0){
    80001c1e:	02094463          	bltz	s2,80001c46 <growproc+0x42>
  p->sz = sz;
    80001c22:	e8ac                	sd	a1,80(s1)
  return 0;
    80001c24:	4501                	li	a0,0
}
    80001c26:	60e2                	ld	ra,24(sp)
    80001c28:	6442                	ld	s0,16(sp)
    80001c2a:	64a2                	ld	s1,8(sp)
    80001c2c:	6902                	ld	s2,0(sp)
    80001c2e:	6105                	addi	sp,sp,32
    80001c30:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001c32:	4691                	li	a3,4
    80001c34:	00b90633          	add	a2,s2,a1
    80001c38:	6d28                	ld	a0,88(a0)
    80001c3a:	f04ff0ef          	jal	8000133e <uvmalloc>
    80001c3e:	85aa                	mv	a1,a0
    80001c40:	f16d                	bnez	a0,80001c22 <growproc+0x1e>
      return -1;
    80001c42:	557d                	li	a0,-1
    80001c44:	b7cd                	j	80001c26 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001c46:	00b90633          	add	a2,s2,a1
    80001c4a:	6d28                	ld	a0,88(a0)
    80001c4c:	eaeff0ef          	jal	800012fa <uvmdealloc>
    80001c50:	85aa                	mv	a1,a0
    80001c52:	bfc1                	j	80001c22 <growproc+0x1e>

0000000080001c54 <sched>:
{
    80001c54:	7179                	addi	sp,sp,-48
    80001c56:	f406                	sd	ra,40(sp)
    80001c58:	f022                	sd	s0,32(sp)
    80001c5a:	ec26                	sd	s1,24(sp)
    80001c5c:	e84a                	sd	s2,16(sp)
    80001c5e:	e44e                	sd	s3,8(sp)
    80001c60:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001c62:	ccdff0ef          	jal	8000192e <myproc>
    80001c66:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001c68:	f23fe0ef          	jal	80000b8a <holding>
    80001c6c:	c92d                	beqz	a0,80001cde <sched+0x8a>
    80001c6e:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001c70:	2781                	sext.w	a5,a5
    80001c72:	079e                	slli	a5,a5,0x7
    80001c74:	00012717          	auipc	a4,0x12
    80001c78:	b5c70713          	addi	a4,a4,-1188 # 800137d0 <pid_lock>
    80001c7c:	97ba                	add	a5,a5,a4
    80001c7e:	0f07a703          	lw	a4,240(a5) # 10f0 <_entry-0x7fffef10>
    80001c82:	4785                	li	a5,1
    80001c84:	06f71363          	bne	a4,a5,80001cea <sched+0x96>
  if(p->state == RUNNING)
    80001c88:	4c98                	lw	a4,24(s1)
    80001c8a:	4791                	li	a5,4
    80001c8c:	06f70563          	beq	a4,a5,80001cf6 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c90:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001c94:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001c96:	e7b5                	bnez	a5,80001d02 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c98:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001c9a:	00012917          	auipc	s2,0x12
    80001c9e:	b3690913          	addi	s2,s2,-1226 # 800137d0 <pid_lock>
    80001ca2:	2781                	sext.w	a5,a5
    80001ca4:	079e                	slli	a5,a5,0x7
    80001ca6:	97ca                	add	a5,a5,s2
    80001ca8:	0f47a983          	lw	s3,244(a5)
    80001cac:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001cae:	2781                	sext.w	a5,a5
    80001cb0:	079e                	slli	a5,a5,0x7
    80001cb2:	00012597          	auipc	a1,0x12
    80001cb6:	b9e58593          	addi	a1,a1,-1122 # 80013850 <cpus+0x8>
    80001cba:	95be                	add	a1,a1,a5
    80001cbc:	06848513          	addi	a0,s1,104
    80001cc0:	645000ef          	jal	80002b04 <swtch>
    80001cc4:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001cc6:	2781                	sext.w	a5,a5
    80001cc8:	079e                	slli	a5,a5,0x7
    80001cca:	993e                	add	s2,s2,a5
    80001ccc:	0f392a23          	sw	s3,244(s2)
}
    80001cd0:	70a2                	ld	ra,40(sp)
    80001cd2:	7402                	ld	s0,32(sp)
    80001cd4:	64e2                	ld	s1,24(sp)
    80001cd6:	6942                	ld	s2,16(sp)
    80001cd8:	69a2                	ld	s3,8(sp)
    80001cda:	6145                	addi	sp,sp,48
    80001cdc:	8082                	ret
    panic("sched p->lock");
    80001cde:	00006517          	auipc	a0,0x6
    80001ce2:	58a50513          	addi	a0,a0,1418 # 80008268 <etext+0x268>
    80001ce6:	aaffe0ef          	jal	80000794 <panic>
    panic("sched locks");
    80001cea:	00006517          	auipc	a0,0x6
    80001cee:	58e50513          	addi	a0,a0,1422 # 80008278 <etext+0x278>
    80001cf2:	aa3fe0ef          	jal	80000794 <panic>
    panic("sched running");
    80001cf6:	00006517          	auipc	a0,0x6
    80001cfa:	59250513          	addi	a0,a0,1426 # 80008288 <etext+0x288>
    80001cfe:	a97fe0ef          	jal	80000794 <panic>
    panic("sched interruptible");
    80001d02:	00006517          	auipc	a0,0x6
    80001d06:	59650513          	addi	a0,a0,1430 # 80008298 <etext+0x298>
    80001d0a:	a8bfe0ef          	jal	80000794 <panic>

0000000080001d0e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001d0e:	7179                	addi	sp,sp,-48
    80001d10:	f406                	sd	ra,40(sp)
    80001d12:	f022                	sd	s0,32(sp)
    80001d14:	ec26                	sd	s1,24(sp)
    80001d16:	e84a                	sd	s2,16(sp)
    80001d18:	e44e                	sd	s3,8(sp)
    80001d1a:	1800                	addi	s0,sp,48
    80001d1c:	89aa                	mv	s3,a0
    80001d1e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001d20:	c0fff0ef          	jal	8000192e <myproc>
    80001d24:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001d26:	ecffe0ef          	jal	80000bf4 <acquire>
  release(lk);
    80001d2a:	854a                	mv	a0,s2
    80001d2c:	f61fe0ef          	jal	80000c8c <release>

  // Go to sleep.
  p->chan = chan;
    80001d30:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001d34:	4789                	li	a5,2
    80001d36:	cc9c                	sw	a5,24(s1)

  sched();
    80001d38:	f1dff0ef          	jal	80001c54 <sched>

  // Tidy up.
  p->chan = 0;
    80001d3c:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001d40:	8526                	mv	a0,s1
    80001d42:	f4bfe0ef          	jal	80000c8c <release>
  acquire(lk);
    80001d46:	854a                	mv	a0,s2
    80001d48:	eadfe0ef          	jal	80000bf4 <acquire>
}
    80001d4c:	70a2                	ld	ra,40(sp)
    80001d4e:	7402                	ld	s0,32(sp)
    80001d50:	64e2                	ld	s1,24(sp)
    80001d52:	6942                	ld	s2,16(sp)
    80001d54:	69a2                	ld	s3,8(sp)
    80001d56:	6145                	addi	sp,sp,48
    80001d58:	8082                	ret

0000000080001d5a <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001d5a:	7139                	addi	sp,sp,-64
    80001d5c:	fc06                	sd	ra,56(sp)
    80001d5e:	f822                	sd	s0,48(sp)
    80001d60:	f426                	sd	s1,40(sp)
    80001d62:	f04a                	sd	s2,32(sp)
    80001d64:	ec4e                	sd	s3,24(sp)
    80001d66:	e852                	sd	s4,16(sp)
    80001d68:	e456                	sd	s5,8(sp)
    80001d6a:	0080                	addi	s0,sp,64
    80001d6c:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001d6e:	00012497          	auipc	s1,0x12
    80001d72:	eda48493          	addi	s1,s1,-294 # 80013c48 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001d76:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001d78:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001d7a:	00018917          	auipc	s2,0x18
    80001d7e:	ace90913          	addi	s2,s2,-1330 # 80019848 <tickslock>
    80001d82:	a801                	j	80001d92 <wakeup+0x38>
      }
      release(&p->lock);
    80001d84:	8526                	mv	a0,s1
    80001d86:	f07fe0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001d8a:	17048493          	addi	s1,s1,368
    80001d8e:	03248263          	beq	s1,s2,80001db2 <wakeup+0x58>
    if(p != myproc()){
    80001d92:	b9dff0ef          	jal	8000192e <myproc>
    80001d96:	fea48ae3          	beq	s1,a0,80001d8a <wakeup+0x30>
      acquire(&p->lock);
    80001d9a:	8526                	mv	a0,s1
    80001d9c:	e59fe0ef          	jal	80000bf4 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001da0:	4c9c                	lw	a5,24(s1)
    80001da2:	ff3791e3          	bne	a5,s3,80001d84 <wakeup+0x2a>
    80001da6:	709c                	ld	a5,32(s1)
    80001da8:	fd479ee3          	bne	a5,s4,80001d84 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001dac:	0154ac23          	sw	s5,24(s1)
    80001db0:	bfd1                	j	80001d84 <wakeup+0x2a>
    }
  }
}
    80001db2:	70e2                	ld	ra,56(sp)
    80001db4:	7442                	ld	s0,48(sp)
    80001db6:	74a2                	ld	s1,40(sp)
    80001db8:	7902                	ld	s2,32(sp)
    80001dba:	69e2                	ld	s3,24(sp)
    80001dbc:	6a42                	ld	s4,16(sp)
    80001dbe:	6aa2                	ld	s5,8(sp)
    80001dc0:	6121                	addi	sp,sp,64
    80001dc2:	8082                	ret

0000000080001dc4 <reparent>:
{
    80001dc4:	7179                	addi	sp,sp,-48
    80001dc6:	f406                	sd	ra,40(sp)
    80001dc8:	f022                	sd	s0,32(sp)
    80001dca:	ec26                	sd	s1,24(sp)
    80001dcc:	e84a                	sd	s2,16(sp)
    80001dce:	e44e                	sd	s3,8(sp)
    80001dd0:	e052                	sd	s4,0(sp)
    80001dd2:	1800                	addi	s0,sp,48
    80001dd4:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001dd6:	00012497          	auipc	s1,0x12
    80001dda:	e7248493          	addi	s1,s1,-398 # 80013c48 <proc>
      pp->parent = initproc;
    80001dde:	0000aa17          	auipc	s4,0xa
    80001de2:	8baa0a13          	addi	s4,s4,-1862 # 8000b698 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001de6:	00018997          	auipc	s3,0x18
    80001dea:	a6298993          	addi	s3,s3,-1438 # 80019848 <tickslock>
    80001dee:	a029                	j	80001df8 <reparent+0x34>
    80001df0:	17048493          	addi	s1,s1,368
    80001df4:	01348b63          	beq	s1,s3,80001e0a <reparent+0x46>
    if(pp->parent == p){
    80001df8:	60bc                	ld	a5,64(s1)
    80001dfa:	ff279be3          	bne	a5,s2,80001df0 <reparent+0x2c>
      pp->parent = initproc;
    80001dfe:	000a3503          	ld	a0,0(s4)
    80001e02:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    80001e04:	f57ff0ef          	jal	80001d5a <wakeup>
    80001e08:	b7e5                	j	80001df0 <reparent+0x2c>
}
    80001e0a:	70a2                	ld	ra,40(sp)
    80001e0c:	7402                	ld	s0,32(sp)
    80001e0e:	64e2                	ld	s1,24(sp)
    80001e10:	6942                	ld	s2,16(sp)
    80001e12:	69a2                	ld	s3,8(sp)
    80001e14:	6a02                	ld	s4,0(sp)
    80001e16:	6145                	addi	sp,sp,48
    80001e18:	8082                	ret

0000000080001e1a <exit>:
{
    80001e1a:	7179                	addi	sp,sp,-48
    80001e1c:	f406                	sd	ra,40(sp)
    80001e1e:	f022                	sd	s0,32(sp)
    80001e20:	ec26                	sd	s1,24(sp)
    80001e22:	e84a                	sd	s2,16(sp)
    80001e24:	e44e                	sd	s3,8(sp)
    80001e26:	e052                	sd	s4,0(sp)
    80001e28:	1800                	addi	s0,sp,48
    80001e2a:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001e2c:	b03ff0ef          	jal	8000192e <myproc>
    80001e30:	89aa                	mv	s3,a0
  if(p == initproc)
    80001e32:	0000a797          	auipc	a5,0xa
    80001e36:	8667b783          	ld	a5,-1946(a5) # 8000b698 <initproc>
    80001e3a:	0d850493          	addi	s1,a0,216
    80001e3e:	15850913          	addi	s2,a0,344
    80001e42:	00a79f63          	bne	a5,a0,80001e60 <exit+0x46>
    panic("init exiting");
    80001e46:	00006517          	auipc	a0,0x6
    80001e4a:	46a50513          	addi	a0,a0,1130 # 800082b0 <etext+0x2b0>
    80001e4e:	947fe0ef          	jal	80000794 <panic>
      fileclose(f);
    80001e52:	011020ef          	jal	80004662 <fileclose>
      p->ofile[fd] = 0;
    80001e56:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001e5a:	04a1                	addi	s1,s1,8
    80001e5c:	01248563          	beq	s1,s2,80001e66 <exit+0x4c>
    if(p->ofile[fd]){
    80001e60:	6088                	ld	a0,0(s1)
    80001e62:	f965                	bnez	a0,80001e52 <exit+0x38>
    80001e64:	bfdd                	j	80001e5a <exit+0x40>
  begin_op();
    80001e66:	3e2020ef          	jal	80004248 <begin_op>
  iput(p->cwd);
    80001e6a:	1589b503          	ld	a0,344(s3)
    80001e6e:	4c7010ef          	jal	80003b34 <iput>
  end_op();
    80001e72:	440020ef          	jal	800042b2 <end_op>
  p->cwd = 0;
    80001e76:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    80001e7a:	00012497          	auipc	s1,0x12
    80001e7e:	96e48493          	addi	s1,s1,-1682 # 800137e8 <wait_lock>
    80001e82:	8526                	mv	a0,s1
    80001e84:	d71fe0ef          	jal	80000bf4 <acquire>
  reparent(p);
    80001e88:	854e                	mv	a0,s3
    80001e8a:	f3bff0ef          	jal	80001dc4 <reparent>
  wakeup(p->parent);
    80001e8e:	0409b503          	ld	a0,64(s3)
    80001e92:	ec9ff0ef          	jal	80001d5a <wakeup>
  acquire(&p->lock);
    80001e96:	854e                	mv	a0,s3
    80001e98:	d5dfe0ef          	jal	80000bf4 <acquire>
  p->xstate = status;
    80001e9c:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001ea0:	4795                	li	a5,5
    80001ea2:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001ea6:	8526                	mv	a0,s1
    80001ea8:	de5fe0ef          	jal	80000c8c <release>
  sched();
    80001eac:	da9ff0ef          	jal	80001c54 <sched>
  panic("zombie exit");
    80001eb0:	00006517          	auipc	a0,0x6
    80001eb4:	41050513          	addi	a0,a0,1040 # 800082c0 <etext+0x2c0>
    80001eb8:	8ddfe0ef          	jal	80000794 <panic>

0000000080001ebc <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001ebc:	7179                	addi	sp,sp,-48
    80001ebe:	f406                	sd	ra,40(sp)
    80001ec0:	f022                	sd	s0,32(sp)
    80001ec2:	ec26                	sd	s1,24(sp)
    80001ec4:	e84a                	sd	s2,16(sp)
    80001ec6:	e44e                	sd	s3,8(sp)
    80001ec8:	1800                	addi	s0,sp,48
    80001eca:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001ecc:	00012497          	auipc	s1,0x12
    80001ed0:	d7c48493          	addi	s1,s1,-644 # 80013c48 <proc>
    80001ed4:	00018997          	auipc	s3,0x18
    80001ed8:	97498993          	addi	s3,s3,-1676 # 80019848 <tickslock>
    acquire(&p->lock);
    80001edc:	8526                	mv	a0,s1
    80001ede:	d17fe0ef          	jal	80000bf4 <acquire>
    if(p->pid == pid){
    80001ee2:	589c                	lw	a5,48(s1)
    80001ee4:	01278b63          	beq	a5,s2,80001efa <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001ee8:	8526                	mv	a0,s1
    80001eea:	da3fe0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001eee:	17048493          	addi	s1,s1,368
    80001ef2:	ff3495e3          	bne	s1,s3,80001edc <kill+0x20>
  }
  return -1;
    80001ef6:	557d                	li	a0,-1
    80001ef8:	a819                	j	80001f0e <kill+0x52>
      p->killed = 1;
    80001efa:	4785                	li	a5,1
    80001efc:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001efe:	4c98                	lw	a4,24(s1)
    80001f00:	4789                	li	a5,2
    80001f02:	00f70d63          	beq	a4,a5,80001f1c <kill+0x60>
      release(&p->lock);
    80001f06:	8526                	mv	a0,s1
    80001f08:	d85fe0ef          	jal	80000c8c <release>
      return 0;
    80001f0c:	4501                	li	a0,0
}
    80001f0e:	70a2                	ld	ra,40(sp)
    80001f10:	7402                	ld	s0,32(sp)
    80001f12:	64e2                	ld	s1,24(sp)
    80001f14:	6942                	ld	s2,16(sp)
    80001f16:	69a2                	ld	s3,8(sp)
    80001f18:	6145                	addi	sp,sp,48
    80001f1a:	8082                	ret
        p->state = RUNNABLE;
    80001f1c:	478d                	li	a5,3
    80001f1e:	cc9c                	sw	a5,24(s1)
    80001f20:	b7dd                	j	80001f06 <kill+0x4a>

0000000080001f22 <setkilled>:

void
setkilled(struct proc *p)
{
    80001f22:	1101                	addi	sp,sp,-32
    80001f24:	ec06                	sd	ra,24(sp)
    80001f26:	e822                	sd	s0,16(sp)
    80001f28:	e426                	sd	s1,8(sp)
    80001f2a:	1000                	addi	s0,sp,32
    80001f2c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001f2e:	cc7fe0ef          	jal	80000bf4 <acquire>
  p->killed = 1;
    80001f32:	4785                	li	a5,1
    80001f34:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001f36:	8526                	mv	a0,s1
    80001f38:	d55fe0ef          	jal	80000c8c <release>
}
    80001f3c:	60e2                	ld	ra,24(sp)
    80001f3e:	6442                	ld	s0,16(sp)
    80001f40:	64a2                	ld	s1,8(sp)
    80001f42:	6105                	addi	sp,sp,32
    80001f44:	8082                	ret

0000000080001f46 <killed>:

int
killed(struct proc *p)
{
    80001f46:	1101                	addi	sp,sp,-32
    80001f48:	ec06                	sd	ra,24(sp)
    80001f4a:	e822                	sd	s0,16(sp)
    80001f4c:	e426                	sd	s1,8(sp)
    80001f4e:	e04a                	sd	s2,0(sp)
    80001f50:	1000                	addi	s0,sp,32
    80001f52:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001f54:	ca1fe0ef          	jal	80000bf4 <acquire>
  k = p->killed;
    80001f58:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001f5c:	8526                	mv	a0,s1
    80001f5e:	d2ffe0ef          	jal	80000c8c <release>
  return k;
}
    80001f62:	854a                	mv	a0,s2
    80001f64:	60e2                	ld	ra,24(sp)
    80001f66:	6442                	ld	s0,16(sp)
    80001f68:	64a2                	ld	s1,8(sp)
    80001f6a:	6902                	ld	s2,0(sp)
    80001f6c:	6105                	addi	sp,sp,32
    80001f6e:	8082                	ret

0000000080001f70 <wait>:
{
    80001f70:	715d                	addi	sp,sp,-80
    80001f72:	e486                	sd	ra,72(sp)
    80001f74:	e0a2                	sd	s0,64(sp)
    80001f76:	fc26                	sd	s1,56(sp)
    80001f78:	f84a                	sd	s2,48(sp)
    80001f7a:	f44e                	sd	s3,40(sp)
    80001f7c:	f052                	sd	s4,32(sp)
    80001f7e:	ec56                	sd	s5,24(sp)
    80001f80:	e85a                	sd	s6,16(sp)
    80001f82:	e45e                	sd	s7,8(sp)
    80001f84:	e062                	sd	s8,0(sp)
    80001f86:	0880                	addi	s0,sp,80
    80001f88:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001f8a:	9a5ff0ef          	jal	8000192e <myproc>
    80001f8e:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001f90:	00012517          	auipc	a0,0x12
    80001f94:	85850513          	addi	a0,a0,-1960 # 800137e8 <wait_lock>
    80001f98:	c5dfe0ef          	jal	80000bf4 <acquire>
    havekids = 0;
    80001f9c:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001f9e:	4a15                	li	s4,5
        havekids = 1;
    80001fa0:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001fa2:	00018997          	auipc	s3,0x18
    80001fa6:	8a698993          	addi	s3,s3,-1882 # 80019848 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001faa:	00012c17          	auipc	s8,0x12
    80001fae:	83ec0c13          	addi	s8,s8,-1986 # 800137e8 <wait_lock>
    80001fb2:	a871                	j	8000204e <wait+0xde>
          pid = pp->pid;
    80001fb4:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001fb8:	000b0c63          	beqz	s6,80001fd0 <wait+0x60>
    80001fbc:	4691                	li	a3,4
    80001fbe:	02c48613          	addi	a2,s1,44
    80001fc2:	85da                	mv	a1,s6
    80001fc4:	05893503          	ld	a0,88(s2)
    80001fc8:	d8aff0ef          	jal	80001552 <copyout>
    80001fcc:	02054b63          	bltz	a0,80002002 <wait+0x92>
          freeproc(pp);
    80001fd0:	8526                	mv	a0,s1
    80001fd2:	acfff0ef          	jal	80001aa0 <freeproc>
          release(&pp->lock);
    80001fd6:	8526                	mv	a0,s1
    80001fd8:	cb5fe0ef          	jal	80000c8c <release>
          release(&wait_lock);
    80001fdc:	00012517          	auipc	a0,0x12
    80001fe0:	80c50513          	addi	a0,a0,-2036 # 800137e8 <wait_lock>
    80001fe4:	ca9fe0ef          	jal	80000c8c <release>
}
    80001fe8:	854e                	mv	a0,s3
    80001fea:	60a6                	ld	ra,72(sp)
    80001fec:	6406                	ld	s0,64(sp)
    80001fee:	74e2                	ld	s1,56(sp)
    80001ff0:	7942                	ld	s2,48(sp)
    80001ff2:	79a2                	ld	s3,40(sp)
    80001ff4:	7a02                	ld	s4,32(sp)
    80001ff6:	6ae2                	ld	s5,24(sp)
    80001ff8:	6b42                	ld	s6,16(sp)
    80001ffa:	6ba2                	ld	s7,8(sp)
    80001ffc:	6c02                	ld	s8,0(sp)
    80001ffe:	6161                	addi	sp,sp,80
    80002000:	8082                	ret
            release(&pp->lock);
    80002002:	8526                	mv	a0,s1
    80002004:	c89fe0ef          	jal	80000c8c <release>
            release(&wait_lock);
    80002008:	00011517          	auipc	a0,0x11
    8000200c:	7e050513          	addi	a0,a0,2016 # 800137e8 <wait_lock>
    80002010:	c7dfe0ef          	jal	80000c8c <release>
            return -1;
    80002014:	59fd                	li	s3,-1
    80002016:	bfc9                	j	80001fe8 <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002018:	17048493          	addi	s1,s1,368
    8000201c:	03348063          	beq	s1,s3,8000203c <wait+0xcc>
      if(pp->parent == p){
    80002020:	60bc                	ld	a5,64(s1)
    80002022:	ff279be3          	bne	a5,s2,80002018 <wait+0xa8>
        acquire(&pp->lock);
    80002026:	8526                	mv	a0,s1
    80002028:	bcdfe0ef          	jal	80000bf4 <acquire>
        if(pp->state == ZOMBIE){
    8000202c:	4c9c                	lw	a5,24(s1)
    8000202e:	f94783e3          	beq	a5,s4,80001fb4 <wait+0x44>
        release(&pp->lock);
    80002032:	8526                	mv	a0,s1
    80002034:	c59fe0ef          	jal	80000c8c <release>
        havekids = 1;
    80002038:	8756                	mv	a4,s5
    8000203a:	bff9                	j	80002018 <wait+0xa8>
    if(!havekids || killed(p)){
    8000203c:	cf19                	beqz	a4,8000205a <wait+0xea>
    8000203e:	854a                	mv	a0,s2
    80002040:	f07ff0ef          	jal	80001f46 <killed>
    80002044:	e919                	bnez	a0,8000205a <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002046:	85e2                	mv	a1,s8
    80002048:	854a                	mv	a0,s2
    8000204a:	cc5ff0ef          	jal	80001d0e <sleep>
    havekids = 0;
    8000204e:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002050:	00012497          	auipc	s1,0x12
    80002054:	bf848493          	addi	s1,s1,-1032 # 80013c48 <proc>
    80002058:	b7e1                	j	80002020 <wait+0xb0>
      release(&wait_lock);
    8000205a:	00011517          	auipc	a0,0x11
    8000205e:	78e50513          	addi	a0,a0,1934 # 800137e8 <wait_lock>
    80002062:	c2bfe0ef          	jal	80000c8c <release>
      return -1;
    80002066:	59fd                	li	s3,-1
    80002068:	b741                	j	80001fe8 <wait+0x78>

000000008000206a <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000206a:	7179                	addi	sp,sp,-48
    8000206c:	f406                	sd	ra,40(sp)
    8000206e:	f022                	sd	s0,32(sp)
    80002070:	ec26                	sd	s1,24(sp)
    80002072:	e84a                	sd	s2,16(sp)
    80002074:	e44e                	sd	s3,8(sp)
    80002076:	e052                	sd	s4,0(sp)
    80002078:	1800                	addi	s0,sp,48
    8000207a:	84aa                	mv	s1,a0
    8000207c:	892e                	mv	s2,a1
    8000207e:	89b2                	mv	s3,a2
    80002080:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002082:	8adff0ef          	jal	8000192e <myproc>
  if(user_dst){
    80002086:	cc99                	beqz	s1,800020a4 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80002088:	86d2                	mv	a3,s4
    8000208a:	864e                	mv	a2,s3
    8000208c:	85ca                	mv	a1,s2
    8000208e:	6d28                	ld	a0,88(a0)
    80002090:	cc2ff0ef          	jal	80001552 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002094:	70a2                	ld	ra,40(sp)
    80002096:	7402                	ld	s0,32(sp)
    80002098:	64e2                	ld	s1,24(sp)
    8000209a:	6942                	ld	s2,16(sp)
    8000209c:	69a2                	ld	s3,8(sp)
    8000209e:	6a02                	ld	s4,0(sp)
    800020a0:	6145                	addi	sp,sp,48
    800020a2:	8082                	ret
    memmove((char *)dst, src, len);
    800020a4:	000a061b          	sext.w	a2,s4
    800020a8:	85ce                	mv	a1,s3
    800020aa:	854a                	mv	a0,s2
    800020ac:	c79fe0ef          	jal	80000d24 <memmove>
    return 0;
    800020b0:	8526                	mv	a0,s1
    800020b2:	b7cd                	j	80002094 <either_copyout+0x2a>

00000000800020b4 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800020b4:	7179                	addi	sp,sp,-48
    800020b6:	f406                	sd	ra,40(sp)
    800020b8:	f022                	sd	s0,32(sp)
    800020ba:	ec26                	sd	s1,24(sp)
    800020bc:	e84a                	sd	s2,16(sp)
    800020be:	e44e                	sd	s3,8(sp)
    800020c0:	e052                	sd	s4,0(sp)
    800020c2:	1800                	addi	s0,sp,48
    800020c4:	892a                	mv	s2,a0
    800020c6:	84ae                	mv	s1,a1
    800020c8:	89b2                	mv	s3,a2
    800020ca:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800020cc:	863ff0ef          	jal	8000192e <myproc>
  if(user_src){
    800020d0:	cc99                	beqz	s1,800020ee <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800020d2:	86d2                	mv	a3,s4
    800020d4:	864e                	mv	a2,s3
    800020d6:	85ca                	mv	a1,s2
    800020d8:	6d28                	ld	a0,88(a0)
    800020da:	d4eff0ef          	jal	80001628 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800020de:	70a2                	ld	ra,40(sp)
    800020e0:	7402                	ld	s0,32(sp)
    800020e2:	64e2                	ld	s1,24(sp)
    800020e4:	6942                	ld	s2,16(sp)
    800020e6:	69a2                	ld	s3,8(sp)
    800020e8:	6a02                	ld	s4,0(sp)
    800020ea:	6145                	addi	sp,sp,48
    800020ec:	8082                	ret
    memmove(dst, (char*)src, len);
    800020ee:	000a061b          	sext.w	a2,s4
    800020f2:	85ce                	mv	a1,s3
    800020f4:	854a                	mv	a0,s2
    800020f6:	c2ffe0ef          	jal	80000d24 <memmove>
    return 0;
    800020fa:	8526                	mv	a0,s1
    800020fc:	b7cd                	j	800020de <either_copyin+0x2a>

00000000800020fe <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800020fe:	711d                	addi	sp,sp,-96
    80002100:	ec86                	sd	ra,88(sp)
    80002102:	e8a2                	sd	s0,80(sp)
    80002104:	e4a6                	sd	s1,72(sp)
    80002106:	e0ca                	sd	s2,64(sp)
    80002108:	fc4e                	sd	s3,56(sp)
    8000210a:	f852                	sd	s4,48(sp)
    8000210c:	f456                	sd	s5,40(sp)
    8000210e:	f05a                	sd	s6,32(sp)
    80002110:	ec5e                	sd	s7,24(sp)
    80002112:	e862                	sd	s8,16(sp)
    80002114:	e466                	sd	s9,8(sp)
    80002116:	1080                	addi	s0,sp,96
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002118:	00006517          	auipc	a0,0x6
    8000211c:	f6050513          	addi	a0,a0,-160 # 80008078 <etext+0x78>
    80002120:	ba2fe0ef          	jal	800004c2 <printf>
  printf("ticks : %d\n", ticks);
    80002124:	00009597          	auipc	a1,0x9
    80002128:	57c5a583          	lw	a1,1404(a1) # 8000b6a0 <ticks>
    8000212c:	00006517          	auipc	a0,0x6
    80002130:	1ac50513          	addi	a0,a0,428 # 800082d8 <etext+0x2d8>
    80002134:	b8efe0ef          	jal	800004c2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002138:	00012497          	auipc	s1,0x12
    8000213c:	b1048493          	addi	s1,s1,-1264 # 80013c48 <proc>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002140:	4a95                	li	s5,5
      state = states[p->state];
    else
      state = "???";
    80002142:	00006a17          	auipc	s4,0x6
    80002146:	18ea0a13          	addi	s4,s4,398 # 800082d0 <etext+0x2d0>
    printf("PID : %d | State : %s | Queue : %d | Priority : %d | TQ : %d/%d ", p->pid, state, p->qnum, p->priority, p->tq, TIMEQUANTUM(p->qnum));
    8000214a:	4905                	li	s2,1
    8000214c:	00006b97          	auipc	s7,0x6
    80002150:	19cb8b93          	addi	s7,s7,412 # 800082e8 <etext+0x2e8>
    printf("\n");
    80002154:	00006b17          	auipc	s6,0x6
    80002158:	f24b0b13          	addi	s6,s6,-220 # 80008078 <etext+0x78>
    printf("PID : %d | State : %s | Queue : %d | Priority : %d | TQ : %d/%d ", p->pid, state, p->qnum, p->priority, p->tq, TIMEQUANTUM(p->qnum));
    8000215c:	4c8d                	li	s9,3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000215e:	00006c17          	auipc	s8,0x6
    80002162:	6fac0c13          	addi	s8,s8,1786 # 80008858 <states.0>
  for(p = proc; p < &proc[NPROC]; p++){
    80002166:	00017997          	auipc	s3,0x17
    8000216a:	6e298993          	addi	s3,s3,1762 # 80019848 <tickslock>
    8000216e:	a829                	j	80002188 <procdump+0x8a>
      state = "???";
    80002170:	8652                	mv	a2,s4
    80002172:	a03d                	j	800021a0 <procdump+0xa2>
    printf("PID : %d | State : %s | Queue : %d | Priority : %d | TQ : %d/%d ", p->pid, state, p->qnum, p->priority, p->tq, TIMEQUANTUM(p->qnum));
    80002174:	855e                	mv	a0,s7
    80002176:	b4cfe0ef          	jal	800004c2 <printf>
    printf("\n");
    8000217a:	855a                	mv	a0,s6
    8000217c:	b46fe0ef          	jal	800004c2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002180:	17048493          	addi	s1,s1,368
    80002184:	03348d63          	beq	s1,s3,800021be <procdump+0xc0>
    if(p->state == UNUSED)
    80002188:	4c9c                	lw	a5,24(s1)
    8000218a:	dbfd                	beqz	a5,80002180 <procdump+0x82>
      state = "???";
    8000218c:	8652                	mv	a2,s4
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000218e:	00fae963          	bltu	s5,a5,800021a0 <procdump+0xa2>
    80002192:	02079713          	slli	a4,a5,0x20
    80002196:	01d75793          	srli	a5,a4,0x1d
    8000219a:	97e2                	add	a5,a5,s8
    8000219c:	6390                	ld	a2,0(a5)
    8000219e:	da69                	beqz	a2,80002170 <procdump+0x72>
    printf("PID : %d | State : %s | Queue : %d | Priority : %d | TQ : %d/%d ", p->pid, state, p->qnum, p->priority, p->tq, TIMEQUANTUM(p->qnum));
    800021a0:	588c                	lw	a1,48(s1)
    800021a2:	5c94                	lw	a3,56(s1)
    800021a4:	5cd8                	lw	a4,60(s1)
    800021a6:	58dc                	lw	a5,52(s1)
    800021a8:	884a                	mv	a6,s2
    800021aa:	d6e9                	beqz	a3,80002174 <procdump+0x76>
    800021ac:	8866                	mv	a6,s9
    800021ae:	fd2683e3          	beq	a3,s2,80002174 <procdump+0x76>
    800021b2:	4509                	li	a0,2
    800021b4:	587d                	li	a6,-1
    800021b6:	faa69fe3          	bne	a3,a0,80002174 <procdump+0x76>
    800021ba:	8856                	mv	a6,s5
    800021bc:	bf65                	j	80002174 <procdump+0x76>
  }
}
    800021be:	60e6                	ld	ra,88(sp)
    800021c0:	6446                	ld	s0,80(sp)
    800021c2:	64a6                	ld	s1,72(sp)
    800021c4:	6906                	ld	s2,64(sp)
    800021c6:	79e2                	ld	s3,56(sp)
    800021c8:	7a42                	ld	s4,48(sp)
    800021ca:	7aa2                	ld	s5,40(sp)
    800021cc:	7b02                	ld	s6,32(sp)
    800021ce:	6be2                	ld	s7,24(sp)
    800021d0:	6c42                	ld	s8,16(sp)
    800021d2:	6ca2                	ld	s9,8(sp)
    800021d4:	6125                	addi	sp,sp,96
    800021d6:	8082                	ret

00000000800021d8 <procinfo>:


void
procinfo(struct proc *p)
{
    800021d8:	1141                	addi	sp,sp,-16
    800021da:	e406                	sd	ra,8(sp)
    800021dc:	e022                	sd	s0,0(sp)
    800021de:	0800                	addi	s0,sp,16
  printf("ticks = %d, pid = %d, name =  %s \n", ticks, p->pid, p->name);
    800021e0:	16050693          	addi	a3,a0,352
    800021e4:	5910                	lw	a2,48(a0)
    800021e6:	00009597          	auipc	a1,0x9
    800021ea:	4ba5a583          	lw	a1,1210(a1) # 8000b6a0 <ticks>
    800021ee:	00006517          	auipc	a0,0x6
    800021f2:	14250513          	addi	a0,a0,322 # 80008330 <etext+0x330>
    800021f6:	accfe0ef          	jal	800004c2 <printf>
}
    800021fa:	60a2                	ld	ra,8(sp)
    800021fc:	6402                	ld	s0,0(sp)
    800021fe:	0141                	addi	sp,sp,16
    80002200:	8082                	ret

0000000080002202 <schedmode>:

// 0 : FCFS
// 1 : MLFQ
int
schedmode(void)
{
    80002202:	1101                	addi	sp,sp,-32
    80002204:	ec06                	sd	ra,24(sp)
    80002206:	e822                	sd	s0,16(sp)
    80002208:	e426                	sd	s1,8(sp)
    8000220a:	e04a                	sd	s2,0(sp)
    8000220c:	1000                	addi	s0,sp,32
  int mode;
  acquire(&schedmode_lock);
    8000220e:	00011497          	auipc	s1,0x11
    80002212:	5f248493          	addi	s1,s1,1522 # 80013800 <schedmode_lock>
    80002216:	8526                	mv	a0,s1
    80002218:	9ddfe0ef          	jal	80000bf4 <acquire>
  mode = scheduler_mode;
    8000221c:	00009917          	auipc	s2,0x9
    80002220:	47492903          	lw	s2,1140(s2) # 8000b690 <scheduler_mode>
  release(&schedmode_lock);
    80002224:	8526                	mv	a0,s1
    80002226:	a67fe0ef          	jal	80000c8c <release>
  return mode;
}
    8000222a:	854a                	mv	a0,s2
    8000222c:	60e2                	ld	ra,24(sp)
    8000222e:	6442                	ld	s0,16(sp)
    80002230:	64a2                	ld	s1,8(sp)
    80002232:	6902                	ld	s2,0(sp)
    80002234:	6105                	addi	sp,sp,32
    80002236:	8082                	ret

0000000080002238 <fork>:
{
    80002238:	7139                	addi	sp,sp,-64
    8000223a:	fc06                	sd	ra,56(sp)
    8000223c:	f822                	sd	s0,48(sp)
    8000223e:	f04a                	sd	s2,32(sp)
    80002240:	e456                	sd	s5,8(sp)
    80002242:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80002244:	eeaff0ef          	jal	8000192e <myproc>
    80002248:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000224a:	8a7ff0ef          	jal	80001af0 <allocproc>
    8000224e:	10050963          	beqz	a0,80002360 <fork+0x128>
    80002252:	ec4e                	sd	s3,24(sp)
    80002254:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80002256:	050ab603          	ld	a2,80(s5)
    8000225a:	6d2c                	ld	a1,88(a0)
    8000225c:	058ab503          	ld	a0,88(s5)
    80002260:	a16ff0ef          	jal	80001476 <uvmcopy>
    80002264:	04054a63          	bltz	a0,800022b8 <fork+0x80>
    80002268:	f426                	sd	s1,40(sp)
    8000226a:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    8000226c:	050ab783          	ld	a5,80(s5)
    80002270:	04f9b823          	sd	a5,80(s3)
  *(np->trapframe) = *(p->trapframe);
    80002274:	060ab683          	ld	a3,96(s5)
    80002278:	87b6                	mv	a5,a3
    8000227a:	0609b703          	ld	a4,96(s3)
    8000227e:	12068693          	addi	a3,a3,288
    80002282:	0007b803          	ld	a6,0(a5)
    80002286:	6788                	ld	a0,8(a5)
    80002288:	6b8c                	ld	a1,16(a5)
    8000228a:	6f90                	ld	a2,24(a5)
    8000228c:	01073023          	sd	a6,0(a4)
    80002290:	e708                	sd	a0,8(a4)
    80002292:	eb0c                	sd	a1,16(a4)
    80002294:	ef10                	sd	a2,24(a4)
    80002296:	02078793          	addi	a5,a5,32
    8000229a:	02070713          	addi	a4,a4,32
    8000229e:	fed792e3          	bne	a5,a3,80002282 <fork+0x4a>
  np->trapframe->a0 = 0;
    800022a2:	0609b783          	ld	a5,96(s3)
    800022a6:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800022aa:	0d8a8493          	addi	s1,s5,216
    800022ae:	0d898913          	addi	s2,s3,216
    800022b2:	158a8a13          	addi	s4,s5,344
    800022b6:	a831                	j	800022d2 <fork+0x9a>
    freeproc(np);
    800022b8:	854e                	mv	a0,s3
    800022ba:	fe6ff0ef          	jal	80001aa0 <freeproc>
    release(&np->lock);
    800022be:	854e                	mv	a0,s3
    800022c0:	9cdfe0ef          	jal	80000c8c <release>
    return -1;
    800022c4:	597d                	li	s2,-1
    800022c6:	69e2                	ld	s3,24(sp)
    800022c8:	a051                	j	8000234c <fork+0x114>
  for(i = 0; i < NOFILE; i++)
    800022ca:	04a1                	addi	s1,s1,8
    800022cc:	0921                	addi	s2,s2,8
    800022ce:	01448963          	beq	s1,s4,800022e0 <fork+0xa8>
    if(p->ofile[i])
    800022d2:	6088                	ld	a0,0(s1)
    800022d4:	d97d                	beqz	a0,800022ca <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    800022d6:	346020ef          	jal	8000461c <filedup>
    800022da:	00a93023          	sd	a0,0(s2)
    800022de:	b7f5                	j	800022ca <fork+0x92>
  np->cwd = idup(p->cwd);
    800022e0:	158ab503          	ld	a0,344(s5)
    800022e4:	698010ef          	jal	8000397c <idup>
    800022e8:	14a9bc23          	sd	a0,344(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800022ec:	4641                	li	a2,16
    800022ee:	160a8593          	addi	a1,s5,352
    800022f2:	16098513          	addi	a0,s3,352
    800022f6:	b11fe0ef          	jal	80000e06 <safestrcpy>
  pid = np->pid;
    800022fa:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    800022fe:	854e                	mv	a0,s3
    80002300:	98dfe0ef          	jal	80000c8c <release>
  acquire(&wait_lock);
    80002304:	00011497          	auipc	s1,0x11
    80002308:	4e448493          	addi	s1,s1,1252 # 800137e8 <wait_lock>
    8000230c:	8526                	mv	a0,s1
    8000230e:	8e7fe0ef          	jal	80000bf4 <acquire>
  np->parent = p;
    80002312:	0559b023          	sd	s5,64(s3)
  release(&wait_lock);
    80002316:	8526                	mv	a0,s1
    80002318:	975fe0ef          	jal	80000c8c <release>
  int mode = schedmode();
    8000231c:	ee7ff0ef          	jal	80002202 <schedmode>
    80002320:	84aa                	mv	s1,a0
  acquire(&np->lock);
    80002322:	854e                	mv	a0,s3
    80002324:	8d1fe0ef          	jal	80000bf4 <acquire>
  if(mode == 0){
    80002328:	c88d                	beqz	s1,8000235a <fork+0x122>
    8000232a:	4781                	li	a5,0
    8000232c:	470d                	li	a4,3
    np->qnum = FCFSMODE;
    8000232e:	02f9ac23          	sw	a5,56(s3)
    np->tq = FCFSMODE;
    80002332:	02f9aa23          	sw	a5,52(s3)
    np->priority = FCFSMODE;
    80002336:	02e9ae23          	sw	a4,60(s3)
  np->state = RUNNABLE;
    8000233a:	478d                	li	a5,3
    8000233c:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80002340:	854e                	mv	a0,s3
    80002342:	94bfe0ef          	jal	80000c8c <release>
  return pid;
    80002346:	74a2                	ld	s1,40(sp)
    80002348:	69e2                	ld	s3,24(sp)
    8000234a:	6a42                	ld	s4,16(sp)
}
    8000234c:	854a                	mv	a0,s2
    8000234e:	70e2                	ld	ra,56(sp)
    80002350:	7442                	ld	s0,48(sp)
    80002352:	7902                	ld	s2,32(sp)
    80002354:	6aa2                	ld	s5,8(sp)
    80002356:	6121                	addi	sp,sp,64
    80002358:	8082                	ret
    8000235a:	57fd                	li	a5,-1
    8000235c:	577d                	li	a4,-1
    8000235e:	bfc1                	j	8000232e <fork+0xf6>
    return -1;
    80002360:	597d                	li	s2,-1
    80002362:	b7ed                	j	8000234c <fork+0x114>

0000000080002364 <mlfqmode>:

// 0 : FCFS
// 1 : MLFQ
int
mlfqmode(void){
    80002364:	7179                	addi	sp,sp,-48
    80002366:	f406                	sd	ra,40(sp)
    80002368:	f022                	sd	s0,32(sp)
    8000236a:	ec26                	sd	s1,24(sp)
    8000236c:	e84a                	sd	s2,16(sp)
    8000236e:	e44e                	sd	s3,8(sp)
    80002370:	1800                	addi	s0,sp,48
  acquire(&schedmode_lock);
    80002372:	00011517          	auipc	a0,0x11
    80002376:	48e50513          	addi	a0,a0,1166 # 80013800 <schedmode_lock>
    8000237a:	87bfe0ef          	jal	80000bf4 <acquire>
  if(scheduler_mode == 1){
    8000237e:	00009717          	auipc	a4,0x9
    80002382:	31272703          	lw	a4,786(a4) # 8000b690 <scheduler_mode>
    80002386:	4785                	li	a5,1
    return -1;
  }

  // FCFS -> MLFQ
  // Move all processes to the first queue
  for(struct proc *p = proc; p <= &proc[NPROC];){
    80002388:	00012497          	auipc	s1,0x12
    8000238c:	8c048493          	addi	s1,s1,-1856 # 80013c48 <proc>
    acquire(&p->lock);
    p->qnum = 0;
    p->tq = 0;
    p->priority = 3;
    80002390:	498d                	li	s3,3
  for(struct proc *p = proc; p <= &proc[NPROC];){
    80002392:	00017917          	auipc	s2,0x17
    80002396:	62690913          	addi	s2,s2,1574 # 800199b8 <bcache+0x158>
  if(scheduler_mode == 1){
    8000239a:	04f70763          	beq	a4,a5,800023e8 <mlfqmode+0x84>
    acquire(&p->lock);
    8000239e:	8526                	mv	a0,s1
    800023a0:	855fe0ef          	jal	80000bf4 <acquire>
    p->qnum = 0;
    800023a4:	0204ac23          	sw	zero,56(s1)
    p->tq = 0;
    800023a8:	0204aa23          	sw	zero,52(s1)
    p->priority = 3;
    800023ac:	0334ae23          	sw	s3,60(s1)
    release(&p->lock);
    800023b0:	8526                	mv	a0,s1
    800023b2:	8dbfe0ef          	jal	80000c8c <release>
    p++;
    800023b6:	17048493          	addi	s1,s1,368
  for(struct proc *p = proc; p <= &proc[NPROC];){
    800023ba:	ff2492e3          	bne	s1,s2,8000239e <mlfqmode+0x3a>
  }
  scheduler_mode = 1;
    800023be:	4785                	li	a5,1
    800023c0:	00009717          	auipc	a4,0x9
    800023c4:	2cf72823          	sw	a5,720(a4) # 8000b690 <scheduler_mode>
  resetticks();
    800023c8:	2a5000ef          	jal	80002e6c <resetticks>
  release(&schedmode_lock);
    800023cc:	00011517          	auipc	a0,0x11
    800023d0:	43450513          	addi	a0,a0,1076 # 80013800 <schedmode_lock>
    800023d4:	8b9fe0ef          	jal	80000c8c <release>
  return 0;
    800023d8:	4501                	li	a0,0
}
    800023da:	70a2                	ld	ra,40(sp)
    800023dc:	7402                	ld	s0,32(sp)
    800023de:	64e2                	ld	s1,24(sp)
    800023e0:	6942                	ld	s2,16(sp)
    800023e2:	69a2                	ld	s3,8(sp)
    800023e4:	6145                	addi	sp,sp,48
    800023e6:	8082                	ret
    release(&schedmode_lock);
    800023e8:	00011517          	auipc	a0,0x11
    800023ec:	41850513          	addi	a0,a0,1048 # 80013800 <schedmode_lock>
    800023f0:	89dfe0ef          	jal	80000c8c <release>
    return -1;
    800023f4:	557d                	li	a0,-1
    800023f6:	b7d5                	j	800023da <mlfqmode+0x76>

00000000800023f8 <fcfsmode>:

int
fcfsmode(void){
    800023f8:	7179                	addi	sp,sp,-48
    800023fa:	f406                	sd	ra,40(sp)
    800023fc:	f022                	sd	s0,32(sp)
    800023fe:	ec26                	sd	s1,24(sp)
    80002400:	e84a                	sd	s2,16(sp)
    80002402:	e44e                	sd	s3,8(sp)
    80002404:	1800                	addi	s0,sp,48
  acquire(&schedmode_lock);
    80002406:	00011517          	auipc	a0,0x11
    8000240a:	3fa50513          	addi	a0,a0,1018 # 80013800 <schedmode_lock>
    8000240e:	fe6fe0ef          	jal	80000bf4 <acquire>
  if(scheduler_mode == 0){
    80002412:	00009797          	auipc	a5,0x9
    80002416:	27e7a783          	lw	a5,638(a5) # 8000b690 <scheduler_mode>
    return -1;
  }

  // MLFQ -> FCFS
  // Initialize all processes to FCFS
  for(struct proc *p = proc; p <= &proc[NPROC];){
    8000241a:	00012497          	auipc	s1,0x12
    8000241e:	82e48493          	addi	s1,s1,-2002 # 80013c48 <proc>
    acquire(&p->lock);
    p->qnum = FCFSMODE;
    80002422:	597d                	li	s2,-1
  for(struct proc *p = proc; p <= &proc[NPROC];){
    80002424:	00017997          	auipc	s3,0x17
    80002428:	59498993          	addi	s3,s3,1428 # 800199b8 <bcache+0x158>
  if(scheduler_mode == 0){
    8000242c:	c7a9                	beqz	a5,80002476 <fcfsmode+0x7e>
    acquire(&p->lock);
    8000242e:	8526                	mv	a0,s1
    80002430:	fc4fe0ef          	jal	80000bf4 <acquire>
    p->qnum = FCFSMODE;
    80002434:	0324ac23          	sw	s2,56(s1)
    p->tq = FCFSMODE;
    80002438:	0324aa23          	sw	s2,52(s1)
    p->priority = FCFSMODE;
    8000243c:	0324ae23          	sw	s2,60(s1)
    release(&p->lock);
    80002440:	8526                	mv	a0,s1
    80002442:	84bfe0ef          	jal	80000c8c <release>
    p++;
    80002446:	17048493          	addi	s1,s1,368
  for(struct proc *p = proc; p <= &proc[NPROC];){
    8000244a:	ff3492e3          	bne	s1,s3,8000242e <fcfsmode+0x36>
  }

  scheduler_mode = 0;
    8000244e:	00009797          	auipc	a5,0x9
    80002452:	2407a123          	sw	zero,578(a5) # 8000b690 <scheduler_mode>
  resetticks();
    80002456:	217000ef          	jal	80002e6c <resetticks>
  release(&schedmode_lock);
    8000245a:	00011517          	auipc	a0,0x11
    8000245e:	3a650513          	addi	a0,a0,934 # 80013800 <schedmode_lock>
    80002462:	82bfe0ef          	jal	80000c8c <release>
  return 0;
    80002466:	4501                	li	a0,0
}
    80002468:	70a2                	ld	ra,40(sp)
    8000246a:	7402                	ld	s0,32(sp)
    8000246c:	64e2                	ld	s1,24(sp)
    8000246e:	6942                	ld	s2,16(sp)
    80002470:	69a2                	ld	s3,8(sp)
    80002472:	6145                	addi	sp,sp,48
    80002474:	8082                	ret
    release(&schedmode_lock);
    80002476:	00011517          	auipc	a0,0x11
    8000247a:	38a50513          	addi	a0,a0,906 # 80013800 <schedmode_lock>
    8000247e:	80ffe0ef          	jal	80000c8c <release>
    return -1;
    80002482:	557d                	li	a0,-1
    80002484:	b7d5                	j	80002468 <fcfsmode+0x70>

0000000080002486 <setschedmode>:
// Deprecated
// 0 : FCFS
// 1 : MLFQ
int
setschedmode(int mode)
{
    80002486:	7139                	addi	sp,sp,-64
    80002488:	fc06                	sd	ra,56(sp)
    8000248a:	f822                	sd	s0,48(sp)
    8000248c:	e456                	sd	s5,8(sp)
    8000248e:	0080                	addi	s0,sp,64
    80002490:	8aaa                	mv	s5,a0

  acquire(&schedmode_lock);
    80002492:	00011517          	auipc	a0,0x11
    80002496:	36e50513          	addi	a0,a0,878 # 80013800 <schedmode_lock>
    8000249a:	f5afe0ef          	jal	80000bf4 <acquire>
  if(mode == scheduler_mode){
    8000249e:	00009797          	auipc	a5,0x9
    800024a2:	1f27a783          	lw	a5,498(a5) # 8000b690 <scheduler_mode>
    800024a6:	07578563          	beq	a5,s5,80002510 <setschedmode+0x8a>
    800024aa:	f426                	sd	s1,40(sp)
    800024ac:	f04a                	sd	s2,32(sp)
    800024ae:	ec4e                	sd	s3,24(sp)
    release(&schedmode_lock);

    return -1;
  }else{

    if(mode == 0){
    800024b0:	060a9863          	bnez	s5,80002520 <setschedmode+0x9a>
      // MLFQ -> FCFS
      // Initialize all processes to FCFS
      for(struct proc *p = proc; p <= &proc[NPROC];){
    800024b4:	00011497          	auipc	s1,0x11
    800024b8:	79448493          	addi	s1,s1,1940 # 80013c48 <proc>
        acquire(&p->lock);
        p->qnum = FCFSMODE;
    800024bc:	597d                	li	s2,-1
      for(struct proc *p = proc; p <= &proc[NPROC];){
    800024be:	00017997          	auipc	s3,0x17
    800024c2:	4fa98993          	addi	s3,s3,1274 # 800199b8 <bcache+0x158>
        acquire(&p->lock);
    800024c6:	8526                	mv	a0,s1
    800024c8:	f2cfe0ef          	jal	80000bf4 <acquire>
        p->qnum = FCFSMODE;
    800024cc:	0324ac23          	sw	s2,56(s1)
        p->tq = FCFSMODE;
    800024d0:	0324aa23          	sw	s2,52(s1)
        p->priority = FCFSMODE;
    800024d4:	0324ae23          	sw	s2,60(s1)
        release(&p->lock);
    800024d8:	8526                	mv	a0,s1
    800024da:	fb2fe0ef          	jal	80000c8c <release>
        p++;
    800024de:	17048493          	addi	s1,s1,368
      for(struct proc *p = proc; p <= &proc[NPROC];){
    800024e2:	ff3492e3          	bne	s1,s3,800024c6 <setschedmode+0x40>
        release(&p->lock);
        p++;
      }
    }

    scheduler_mode = mode;
    800024e6:	00009797          	auipc	a5,0x9
    800024ea:	1b57a523          	sw	s5,426(a5) # 8000b690 <scheduler_mode>
    resetticks();
    800024ee:	17f000ef          	jal	80002e6c <resetticks>
    release(&schedmode_lock);
    800024f2:	00011517          	auipc	a0,0x11
    800024f6:	30e50513          	addi	a0,a0,782 # 80013800 <schedmode_lock>
    800024fa:	f92fe0ef          	jal	80000c8c <release>
    return 0;
    800024fe:	4501                	li	a0,0
    80002500:	74a2                	ld	s1,40(sp)
    80002502:	7902                	ld	s2,32(sp)
    80002504:	69e2                	ld	s3,24(sp)
  }
}
    80002506:	70e2                	ld	ra,56(sp)
    80002508:	7442                	ld	s0,48(sp)
    8000250a:	6aa2                	ld	s5,8(sp)
    8000250c:	6121                	addi	sp,sp,64
    8000250e:	8082                	ret
    release(&schedmode_lock);
    80002510:	00011517          	auipc	a0,0x11
    80002514:	2f050513          	addi	a0,a0,752 # 80013800 <schedmode_lock>
    80002518:	f74fe0ef          	jal	80000c8c <release>
    return -1;
    8000251c:	557d                	li	a0,-1
    8000251e:	b7e5                	j	80002506 <setschedmode+0x80>
    80002520:	e852                	sd	s4,16(sp)
      for(struct proc *p = proc; p <= &proc[NPROC];){
    80002522:	00011497          	auipc	s1,0x11
    80002526:	72648493          	addi	s1,s1,1830 # 80013c48 <proc>
        p->tq = TQ_Q0;
    8000252a:	4a05                	li	s4,1
        p->priority = 3;
    8000252c:	498d                	li	s3,3
      for(struct proc *p = proc; p <= &proc[NPROC];){
    8000252e:	00017917          	auipc	s2,0x17
    80002532:	48a90913          	addi	s2,s2,1162 # 800199b8 <bcache+0x158>
        acquire(&p->lock);
    80002536:	8526                	mv	a0,s1
    80002538:	ebcfe0ef          	jal	80000bf4 <acquire>
        p->qnum = 0;
    8000253c:	0204ac23          	sw	zero,56(s1)
        p->tq = TQ_Q0;
    80002540:	0344aa23          	sw	s4,52(s1)
        p->priority = 3;
    80002544:	0334ae23          	sw	s3,60(s1)
        release(&p->lock);
    80002548:	8526                	mv	a0,s1
    8000254a:	f42fe0ef          	jal	80000c8c <release>
        p++;
    8000254e:	17048493          	addi	s1,s1,368
      for(struct proc *p = proc; p <= &proc[NPROC];){
    80002552:	ff2492e3          	bne	s1,s2,80002536 <setschedmode+0xb0>
    80002556:	6a42                	ld	s4,16(sp)
    80002558:	b779                	j	800024e6 <setschedmode+0x60>

000000008000255a <yieldp>:

// 0 : nothing yielded voluntarily 
// else : pid of the process that yielded on a syscall
int
yieldp(void) 
{
    8000255a:	1101                	addi	sp,sp,-32
    8000255c:	ec06                	sd	ra,24(sp)
    8000255e:	e822                	sd	s0,16(sp)
    80002560:	e426                	sd	s1,8(sp)
    80002562:	e04a                	sd	s2,0(sp)
    80002564:	1000                	addi	s0,sp,32
  int pid;
  acquire(&yieldpid_lock);
    80002566:	00011497          	auipc	s1,0x11
    8000256a:	2b248493          	addi	s1,s1,690 # 80013818 <yieldpid_lock>
    8000256e:	8526                	mv	a0,s1
    80002570:	e84fe0ef          	jal	80000bf4 <acquire>
  pid = yieldpid;
    80002574:	00009917          	auipc	s2,0x9
    80002578:	11892903          	lw	s2,280(s2) # 8000b68c <yieldpid>
  release(&yieldpid_lock);
    8000257c:	8526                	mv	a0,s1
    8000257e:	f0efe0ef          	jal	80000c8c <release>
  return pid;
}
    80002582:	854a                	mv	a0,s2
    80002584:	60e2                	ld	ra,24(sp)
    80002586:	6442                	ld	s0,16(sp)
    80002588:	64a2                	ld	s1,8(sp)
    8000258a:	6902                	ld	s2,0(sp)
    8000258c:	6105                	addi	sp,sp,32
    8000258e:	8082                	ret

0000000080002590 <setyieldpid>:

// 0 : default(no yield)
// else : pid of the process that yielded on a syscall
int
setyieldpid(int pid) 
{
    80002590:	7179                	addi	sp,sp,-48
    80002592:	f406                	sd	ra,40(sp)
    80002594:	f022                	sd	s0,32(sp)
    80002596:	ec26                	sd	s1,24(sp)
    80002598:	e84a                	sd	s2,16(sp)
    8000259a:	e44e                	sd	s3,8(sp)
    8000259c:	1800                	addi	s0,sp,48
    8000259e:	84aa                	mv	s1,a0
  acquire(&yieldpid_lock);
    800025a0:	00011997          	auipc	s3,0x11
    800025a4:	27898993          	addi	s3,s3,632 # 80013818 <yieldpid_lock>
    800025a8:	854e                	mv	a0,s3
    800025aa:	e4afe0ef          	jal	80000bf4 <acquire>
  yieldpid = pid;
    800025ae:	00009917          	auipc	s2,0x9
    800025b2:	0de90913          	addi	s2,s2,222 # 8000b68c <yieldpid>
    800025b6:	00992023          	sw	s1,0(s2)
  release(&yieldpid_lock);
    800025ba:	854e                	mv	a0,s3
    800025bc:	ed0fe0ef          	jal	80000c8c <release>
  return yieldpid;
}
    800025c0:	00092503          	lw	a0,0(s2)
    800025c4:	70a2                	ld	ra,40(sp)
    800025c6:	7402                	ld	s0,32(sp)
    800025c8:	64e2                	ld	s1,24(sp)
    800025ca:	6942                	ld	s2,16(sp)
    800025cc:	69a2                	ld	s3,8(sp)
    800025ce:	6145                	addi	sp,sp,48
    800025d0:	8082                	ret

00000000800025d2 <lastp>:

// returns lastpid
int
lastp(void){
    800025d2:	1101                	addi	sp,sp,-32
    800025d4:	ec06                	sd	ra,24(sp)
    800025d6:	e822                	sd	s0,16(sp)
    800025d8:	e426                	sd	s1,8(sp)
    800025da:	e04a                	sd	s2,0(sp)
    800025dc:	1000                	addi	s0,sp,32
  int pid;
  acquire(&lastpid_lock);
    800025de:	00011497          	auipc	s1,0x11
    800025e2:	25248493          	addi	s1,s1,594 # 80013830 <lastpid_lock>
    800025e6:	8526                	mv	a0,s1
    800025e8:	e0cfe0ef          	jal	80000bf4 <acquire>
  pid = lastpid;
    800025ec:	00009917          	auipc	s2,0x9
    800025f0:	09c92903          	lw	s2,156(s2) # 8000b688 <lastpid>
  release(&lastpid_lock);
    800025f4:	8526                	mv	a0,s1
    800025f6:	e96fe0ef          	jal	80000c8c <release>
  return pid;
}
    800025fa:	854a                	mv	a0,s2
    800025fc:	60e2                	ld	ra,24(sp)
    800025fe:	6442                	ld	s0,16(sp)
    80002600:	64a2                	ld	s1,8(sp)
    80002602:	6902                	ld	s2,0(sp)
    80002604:	6105                	addi	sp,sp,32
    80002606:	8082                	ret

0000000080002608 <setlastpid>:


// when yield is called, lastpid stores the pid of the process which called yield
int
setlastpid(int pid) 
{
    80002608:	7179                	addi	sp,sp,-48
    8000260a:	f406                	sd	ra,40(sp)
    8000260c:	f022                	sd	s0,32(sp)
    8000260e:	ec26                	sd	s1,24(sp)
    80002610:	e84a                	sd	s2,16(sp)
    80002612:	e44e                	sd	s3,8(sp)
    80002614:	1800                	addi	s0,sp,48
    80002616:	84aa                	mv	s1,a0
  acquire(&lastpid_lock);
    80002618:	00011997          	auipc	s3,0x11
    8000261c:	21898993          	addi	s3,s3,536 # 80013830 <lastpid_lock>
    80002620:	854e                	mv	a0,s3
    80002622:	dd2fe0ef          	jal	80000bf4 <acquire>
  lastpid = pid;
    80002626:	00009917          	auipc	s2,0x9
    8000262a:	06290913          	addi	s2,s2,98 # 8000b688 <lastpid>
    8000262e:	00992023          	sw	s1,0(s2)
  release(&lastpid_lock);
    80002632:	854e                	mv	a0,s3
    80002634:	e58fe0ef          	jal	80000c8c <release>
  return lastpid;
}
    80002638:	00092503          	lw	a0,0(s2)
    8000263c:	70a2                	ld	ra,40(sp)
    8000263e:	7402                	ld	s0,32(sp)
    80002640:	64e2                	ld	s1,24(sp)
    80002642:	6942                	ld	s2,16(sp)
    80002644:	69a2                	ld	s3,8(sp)
    80002646:	6145                	addi	sp,sp,48
    80002648:	8082                	ret

000000008000264a <yield>:
{
    8000264a:	1101                	addi	sp,sp,-32
    8000264c:	ec06                	sd	ra,24(sp)
    8000264e:	e822                	sd	s0,16(sp)
    80002650:	e426                	sd	s1,8(sp)
    80002652:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002654:	adaff0ef          	jal	8000192e <myproc>
    80002658:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000265a:	d9afe0ef          	jal	80000bf4 <acquire>
  if(schedmode() == 1){
    8000265e:	ba5ff0ef          	jal	80002202 <schedmode>
    80002662:	4785                	li	a5,1
    80002664:	00f50e63          	beq	a0,a5,80002680 <yield+0x36>
  p->state = RUNNABLE;
    80002668:	478d                	li	a5,3
    8000266a:	cc9c                	sw	a5,24(s1)
  sched();
    8000266c:	de8ff0ef          	jal	80001c54 <sched>
  release(&p->lock);
    80002670:	8526                	mv	a0,s1
    80002672:	e1afe0ef          	jal	80000c8c <release>
}
    80002676:	60e2                	ld	ra,24(sp)
    80002678:	6442                	ld	s0,16(sp)
    8000267a:	64a2                	ld	s1,8(sp)
    8000267c:	6105                	addi	sp,sp,32
    8000267e:	8082                	ret
    int nexttq = (p -> tq) + 1;
    80002680:	58dc                	lw	a5,52(s1)
    80002682:	2785                	addiw	a5,a5,1
    if(nexttq >= TIMEQUANTUM(p->qnum)){
    80002684:	5c98                	lw	a4,56(s1)
    80002686:	cb09                	beqz	a4,80002698 <yield+0x4e>
    80002688:	4685                	li	a3,1
    8000268a:	450d                	li	a0,3
    8000268c:	00d70663          	beq	a4,a3,80002698 <yield+0x4e>
    80002690:	4689                	li	a3,2
    80002692:	557d                	li	a0,-1
    80002694:	00d70d63          	beq	a4,a3,800026ae <yield+0x64>
    80002698:	872a                	mv	a4,a0
    8000269a:	0007869b          	sext.w	a3,a5
    8000269e:	00a6d363          	bge	a3,a0,800026a4 <yield+0x5a>
    800026a2:	873e                	mv	a4,a5
    800026a4:	d8d8                	sw	a4,52(s1)
    setlastpid(p->pid);
    800026a6:	5888                	lw	a0,48(s1)
    800026a8:	f61ff0ef          	jal	80002608 <setlastpid>
    800026ac:	bf75                	j	80002668 <yield+0x1e>
    if(nexttq >= TIMEQUANTUM(p->qnum)){
    800026ae:	4515                	li	a0,5
    800026b0:	b7e5                	j	80002698 <yield+0x4e>

00000000800026b2 <demoteproc>:

// demote the process to the next queue
// only used in scheduler() because it assumes that the process is already in the lock
int
demoteproc(struct proc * p){
    800026b2:	1141                	addi	sp,sp,-16
    800026b4:	e422                	sd	s0,8(sp)
    800026b6:	0800                	addi	s0,sp,16
  if(p->qnum == 0){
    800026b8:	5d1c                	lw	a5,56(a0)
    800026ba:	eb89                	bnez	a5,800026cc <demoteproc+0x1a>
    p->qnum = 1;
    800026bc:	4785                	li	a5,1
    800026be:	dd1c                	sw	a5,56(a0)

  }else{
    return -1;
  }

  p->tq = 0;
    800026c0:	02052a23          	sw	zero,52(a0)
  return 0;
    800026c4:	4501                	li	a0,0
}
    800026c6:	6422                	ld	s0,8(sp)
    800026c8:	0141                	addi	sp,sp,16
    800026ca:	8082                	ret
  }else if(p->qnum == 1){
    800026cc:	4705                	li	a4,1
    800026ce:	00e78f63          	beq	a5,a4,800026ec <demoteproc+0x3a>
  }else if(p->qnum == 2){
    800026d2:	4709                	li	a4,2
    800026d4:	02e79163          	bne	a5,a4,800026f6 <demoteproc+0x44>
    int newpriority = (p->priority) - 1;
    800026d8:	5d5c                	lw	a5,60(a0)
    800026da:	37fd                	addiw	a5,a5,-1
    800026dc:	0007871b          	sext.w	a4,a5
      p->priority = 0;
    800026e0:	fff74713          	not	a4,a4
    800026e4:	977d                	srai	a4,a4,0x3f
    800026e6:	8ff9                	and	a5,a5,a4
    800026e8:	dd5c                	sw	a5,60(a0)
    800026ea:	bfd9                	j	800026c0 <demoteproc+0xe>
    p->qnum = 2;
    800026ec:	4789                	li	a5,2
    800026ee:	dd1c                	sw	a5,56(a0)
    p->priority = 3;
    800026f0:	478d                	li	a5,3
    800026f2:	dd5c                	sw	a5,60(a0)
    800026f4:	b7f1                	j	800026c0 <demoteproc+0xe>
    return -1;
    800026f6:	557d                	li	a0,-1
    800026f8:	b7f9                	j	800026c6 <demoteproc+0x14>

00000000800026fa <scheduler>:
{
    800026fa:	711d                	addi	sp,sp,-96
    800026fc:	ec86                	sd	ra,88(sp)
    800026fe:	e8a2                	sd	s0,80(sp)
    80002700:	e4a6                	sd	s1,72(sp)
    80002702:	e0ca                	sd	s2,64(sp)
    80002704:	fc4e                	sd	s3,56(sp)
    80002706:	f852                	sd	s4,48(sp)
    80002708:	f456                	sd	s5,40(sp)
    8000270a:	f05a                	sd	s6,32(sp)
    8000270c:	ec5e                	sd	s7,24(sp)
    8000270e:	e862                	sd	s8,16(sp)
    80002710:	e466                	sd	s9,8(sp)
    80002712:	1080                	addi	s0,sp,96
    80002714:	8792                	mv	a5,tp
  int id = r_tp();
    80002716:	2781                	sext.w	a5,a5
  c->proc = 0;
    80002718:	00779a93          	slli	s5,a5,0x7
    8000271c:	00011717          	auipc	a4,0x11
    80002720:	0b470713          	addi	a4,a4,180 # 800137d0 <pid_lock>
    80002724:	9756                	add	a4,a4,s5
    80002726:	06073c23          	sd	zero,120(a4)
          swtch(&c->context, &mlfq_select->context);
    8000272a:	00011717          	auipc	a4,0x11
    8000272e:	12670713          	addi	a4,a4,294 # 80013850 <cpus+0x8>
    80002732:	9aba                	add	s5,s5,a4
        if(ticks == 50){
    80002734:	00009b97          	auipc	s7,0x9
    80002738:	f6cb8b93          	addi	s7,s7,-148 # 8000b6a0 <ticks>
    8000273c:	03200b13          	li	s6,50
        for(p = proc; p < &proc[NPROC];) {
    80002740:	00017917          	auipc	s2,0x17
    80002744:	10890913          	addi	s2,s2,264 # 80019848 <tickslock>
          c -> proc = mlfq_select;
    80002748:	079e                	slli	a5,a5,0x7
    8000274a:	00011a17          	auipc	s4,0x11
    8000274e:	086a0a13          	addi	s4,s4,134 # 800137d0 <pid_lock>
    80002752:	9a3e                	add	s4,s4,a5
    80002754:	a2f1                	j	80002920 <scheduler+0x226>
            if(p->pid != yieldp()){
    80002756:	0304ac83          	lw	s9,48(s1)
    8000275a:	e01ff0ef          	jal	8000255a <yieldp>
    8000275e:	04ac9c63          	bne	s9,a0,800027b6 <scheduler+0xbc>
        c->proc = 0;
    80002762:	060a3c23          	sd	zero,120(s4)
        release(&p->lock);     
    80002766:	854e                	mv	a0,s3
    80002768:	d24fe0ef          	jal	80000c8c <release>
          p++;
    8000276c:	17048493          	addi	s1,s1,368
        if(schedmode() != 0){
    80002770:	a93ff0ef          	jal	80002202 <schedmode>
    80002774:	1a051663          	bnez	a0,80002920 <scheduler+0x226>
      for(p = proc; p < &proc[NPROC];) {
    80002778:	0524fc63          	bgeu	s1,s2,800027d0 <scheduler+0xd6>
        acquire(&p->lock);
    8000277c:	89a6                	mv	s3,s1
    8000277e:	8526                	mv	a0,s1
    80002780:	c74fe0ef          	jal	80000bf4 <acquire>
        if(p->state == RUNNABLE) {
    80002784:	4c9c                	lw	a5,24(s1)
    80002786:	fd879ee3          	bne	a5,s8,80002762 <scheduler+0x68>
          if(yieldp() == 0){ // if nothing voluntarily yielded
    8000278a:	dd1ff0ef          	jal	8000255a <yieldp>
    8000278e:	f561                	bnez	a0,80002756 <scheduler+0x5c>
            fcfs_select -> state = RUNNING;
    80002790:	4791                	li	a5,4
    80002792:	cc9c                	sw	a5,24(s1)
            c -> proc = fcfs_select;
    80002794:	069a3c23          	sd	s1,120(s4)
            swtch(&c->context, &fcfs_select->context);
    80002798:	06848593          	addi	a1,s1,104
    8000279c:	8556                	mv	a0,s5
    8000279e:	366000ef          	jal	80002b04 <swtch>
        c->proc = 0;
    800027a2:	060a3c23          	sd	zero,120(s4)
        release(&p->lock);     
    800027a6:	854e                	mv	a0,s3
    800027a8:	ce4fe0ef          	jal	80000c8c <release>
          p = proc;
    800027ac:	00011497          	auipc	s1,0x11
    800027b0:	49c48493          	addi	s1,s1,1180 # 80013c48 <proc>
    800027b4:	bf75                	j	80002770 <scheduler+0x76>
              fcfs_select -> state = RUNNING;
    800027b6:	4791                	li	a5,4
    800027b8:	cc9c                	sw	a5,24(s1)
              c -> proc = fcfs_select;
    800027ba:	069a3c23          	sd	s1,120(s4)
              setyieldpid(0); // We handled this, so reset it
    800027be:	4501                	li	a0,0
    800027c0:	dd1ff0ef          	jal	80002590 <setyieldpid>
              swtch(&c->context, &fcfs_select->context);
    800027c4:	06848593          	addi	a1,s1,104
    800027c8:	8556                	mv	a0,s5
    800027ca:	33a000ef          	jal	80002b04 <swtch>
    800027ce:	bfd1                	j	800027a2 <scheduler+0xa8>
    800027d0:	4485                	li	s1,1
    800027d2:	aa35                	j	8000290e <scheduler+0x214>
        if(ticks == 50){
    800027d4:	000ba783          	lw	a5,0(s7)
    800027d8:	01678963          	beq	a5,s6,800027ea <scheduler+0xf0>
          for(p = proc; p < &proc[NPROC];) {
    800027dc:	00011497          	auipc	s1,0x11
    800027e0:	46c48493          	addi	s1,s1,1132 # 80013c48 <proc>
          if(p->pid == lastp() && p->state == RUNNABLE && p->tq < TIMEQUANTUM(p->qnum)){
    800027e4:	4c0d                	li	s8,3
    800027e6:	4c85                	li	s9,1
    800027e8:	a0b9                	j	80002836 <scheduler+0x13c>
          for(p = proc; p < &proc[NPROC];) {
    800027ea:	00011497          	auipc	s1,0x11
    800027ee:	45e48493          	addi	s1,s1,1118 # 80013c48 <proc>
            if(p->state == RUNNABLE){
    800027f2:	498d                	li	s3,3
    800027f4:	a801                	j	80002804 <scheduler+0x10a>
            release(&p->lock);
    800027f6:	8526                	mv	a0,s1
    800027f8:	c94fe0ef          	jal	80000c8c <release>
            p++;
    800027fc:	17048493          	addi	s1,s1,368
          for(p = proc; p < &proc[NPROC];) {
    80002800:	01248f63          	beq	s1,s2,8000281e <scheduler+0x124>
            acquire(&p->lock);
    80002804:	8526                	mv	a0,s1
    80002806:	beefe0ef          	jal	80000bf4 <acquire>
            if(p->state == RUNNABLE){
    8000280a:	4c9c                	lw	a5,24(s1)
    8000280c:	ff3795e3          	bne	a5,s3,800027f6 <scheduler+0xfc>
              p->qnum = 0;
    80002810:	0204ac23          	sw	zero,56(s1)
              p->tq = 0;
    80002814:	0204aa23          	sw	zero,52(s1)
              p->priority = 3;
    80002818:	0334ae23          	sw	s3,60(s1)
    8000281c:	bfe9                	j	800027f6 <scheduler+0xfc>
          resetticks();
    8000281e:	64e000ef          	jal	80002e6c <resetticks>
    80002822:	bf6d                	j	800027dc <scheduler+0xe2>
          if(p->pid == lastp() && p->state == RUNNABLE && p->tq < TIMEQUANTUM(p->qnum)){
    80002824:	0cf6c463          	blt	a3,a5,800028ec <scheduler+0x1f2>
          release(&p->lock);
    80002828:	8526                	mv	a0,s1
    8000282a:	c62fe0ef          	jal	80000c8c <release>
          p++;
    8000282e:	17048493          	addi	s1,s1,368
        for(p = proc; p < &proc[NPROC];) {
    80002832:	03248b63          	beq	s1,s2,80002868 <scheduler+0x16e>
          acquire(&p->lock);
    80002836:	8526                	mv	a0,s1
    80002838:	bbcfe0ef          	jal	80000bf4 <acquire>
          if(p->pid == lastp() && p->state == RUNNABLE && p->tq < TIMEQUANTUM(p->qnum)){
    8000283c:	0304a983          	lw	s3,48(s1)
    80002840:	d93ff0ef          	jal	800025d2 <lastp>
    80002844:	fea992e3          	bne	s3,a0,80002828 <scheduler+0x12e>
    80002848:	4c9c                	lw	a5,24(s1)
    8000284a:	fd879fe3          	bne	a5,s8,80002828 <scheduler+0x12e>
    8000284e:	58d4                	lw	a3,52(s1)
    80002850:	5c98                	lw	a4,56(s1)
    80002852:	87e6                	mv	a5,s9
    80002854:	db61                	beqz	a4,80002824 <scheduler+0x12a>
    80002856:	87e2                	mv	a5,s8
    80002858:	fd9706e3          	beq	a4,s9,80002824 <scheduler+0x12a>
    8000285c:	4609                	li	a2,2
    8000285e:	57fd                	li	a5,-1
    80002860:	fcc712e3          	bne	a4,a2,80002824 <scheduler+0x12a>
    80002864:	4795                	li	a5,5
    80002866:	bf7d                	j	80002824 <scheduler+0x12a>
          for(p = proc; p < &proc[NPROC];) {
    80002868:	00011497          	auipc	s1,0x11
    8000286c:	3e048493          	addi	s1,s1,992 # 80013c48 <proc>
            if(p->pid == lastp() && p->state == RUNNABLE && p->tq >= TIMEQUANTUM(p->qnum)){
    80002870:	4c0d                	li	s8,3
    80002872:	4c85                	li	s9,1
    80002874:	a811                	j	80002888 <scheduler+0x18e>
    80002876:	04f6d263          	bge	a3,a5,800028ba <scheduler+0x1c0>
            release(&p->lock);
    8000287a:	8526                	mv	a0,s1
    8000287c:	c10fe0ef          	jal	80000c8c <release>
            p++;
    80002880:	17048493          	addi	s1,s1,368
          for(p = proc; p < &proc[NPROC];) {
    80002884:	03248f63          	beq	s1,s2,800028c2 <scheduler+0x1c8>
            acquire(&p->lock);
    80002888:	8526                	mv	a0,s1
    8000288a:	b6afe0ef          	jal	80000bf4 <acquire>
            if(p->pid == lastp() && p->state == RUNNABLE && p->tq >= TIMEQUANTUM(p->qnum)){
    8000288e:	0304a983          	lw	s3,48(s1)
    80002892:	d41ff0ef          	jal	800025d2 <lastp>
    80002896:	fea992e3          	bne	s3,a0,8000287a <scheduler+0x180>
    8000289a:	4c9c                	lw	a5,24(s1)
    8000289c:	fd879fe3          	bne	a5,s8,8000287a <scheduler+0x180>
    800028a0:	58d4                	lw	a3,52(s1)
    800028a2:	5c98                	lw	a4,56(s1)
    800028a4:	87e6                	mv	a5,s9
    800028a6:	db61                	beqz	a4,80002876 <scheduler+0x17c>
    800028a8:	87e2                	mv	a5,s8
    800028aa:	fd9706e3          	beq	a4,s9,80002876 <scheduler+0x17c>
    800028ae:	4609                	li	a2,2
    800028b0:	57fd                	li	a5,-1
    800028b2:	fcc712e3          	bne	a4,a2,80002876 <scheduler+0x17c>
    800028b6:	4795                	li	a5,5
    800028b8:	bf7d                	j	80002876 <scheduler+0x17c>
              demoteproc(p);
    800028ba:	8526                	mv	a0,s1
    800028bc:	df7ff0ef          	jal	800026b2 <demoteproc>
    800028c0:	bf6d                	j	8000287a <scheduler+0x180>
          for(p = proc; p < &proc[NPROC];) {
    800028c2:	00011497          	auipc	s1,0x11
    800028c6:	38648493          	addi	s1,s1,902 # 80013c48 <proc>
            if(p->state == RUNNABLE && p->qnum == 0) {
    800028ca:	498d                	li	s3,3
    800028cc:	a801                	j	800028dc <scheduler+0x1e2>
            release(&p->lock);
    800028ce:	8526                	mv	a0,s1
    800028d0:	bbcfe0ef          	jal	80000c8c <release>
            p++;
    800028d4:	17048493          	addi	s1,s1,368
          for(p = proc; p < &proc[NPROC];) {
    800028d8:	07248463          	beq	s1,s2,80002940 <scheduler+0x246>
            acquire(&p->lock);
    800028dc:	8526                	mv	a0,s1
    800028de:	b16fe0ef          	jal	80000bf4 <acquire>
            if(p->state == RUNNABLE && p->qnum == 0) {
    800028e2:	4c9c                	lw	a5,24(s1)
    800028e4:	ff3795e3          	bne	a5,s3,800028ce <scheduler+0x1d4>
    800028e8:	5c9c                	lw	a5,56(s1)
    800028ea:	f3f5                	bnez	a5,800028ce <scheduler+0x1d4>
          mlfq_select -> state = RUNNING;
    800028ec:	4791                	li	a5,4
    800028ee:	cc9c                	sw	a5,24(s1)
          c -> proc = mlfq_select;
    800028f0:	069a3c23          	sd	s1,120(s4)
          swtch(&c->context, &mlfq_select->context);
    800028f4:	06848593          	addi	a1,s1,104
    800028f8:	8556                	mv	a0,s5
    800028fa:	20a000ef          	jal	80002b04 <swtch>
          c->proc = 0;
    800028fe:	060a3c23          	sd	zero,120(s4)
          release(&mlfq_select->lock);
    80002902:	8526                	mv	a0,s1
    80002904:	b88fe0ef          	jal	80000c8c <release>
          found = 1;
    80002908:	4485                	li	s1,1
        if(schedmode() != 1){
    8000290a:	8f9ff0ef          	jal	80002202 <schedmode>
    if(found == 0) {
    8000290e:	e889                	bnez	s1,80002920 <scheduler+0x226>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002910:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002914:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002918:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    8000291c:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002920:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002924:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002928:	10079073          	csrw	sstatus,a5
    if(schedmode() == 0){
    8000292c:	8d7ff0ef          	jal	80002202 <schedmode>
    80002930:	ea0512e3          	bnez	a0,800027d4 <scheduler+0xda>
      for(p = proc; p < &proc[NPROC];) {
    80002934:	00011497          	auipc	s1,0x11
    80002938:	31448493          	addi	s1,s1,788 # 80013c48 <proc>
        if(p->state == RUNNABLE) {
    8000293c:	4c0d                	li	s8,3
    8000293e:	bd3d                	j	8000277c <scheduler+0x82>
          for(p = proc; p < &proc[NPROC];) {
    80002940:	00011497          	auipc	s1,0x11
    80002944:	30848493          	addi	s1,s1,776 # 80013c48 <proc>
            if(p->state == RUNNABLE && p->qnum == 1) {
    80002948:	498d                	li	s3,3
    8000294a:	4c05                	li	s8,1
    8000294c:	a801                	j	8000295c <scheduler+0x262>
            release(&p->lock);
    8000294e:	8526                	mv	a0,s1
    80002950:	b3cfe0ef          	jal	80000c8c <release>
            p++;
    80002954:	17048493          	addi	s1,s1,368
          for(p = proc; p < &proc[NPROC];) {
    80002958:	01248c63          	beq	s1,s2,80002970 <scheduler+0x276>
            acquire(&p->lock);
    8000295c:	8526                	mv	a0,s1
    8000295e:	a96fe0ef          	jal	80000bf4 <acquire>
            if(p->state == RUNNABLE && p->qnum == 1) {
    80002962:	4c9c                	lw	a5,24(s1)
    80002964:	ff3795e3          	bne	a5,s3,8000294e <scheduler+0x254>
    80002968:	5c9c                	lw	a5,56(s1)
    8000296a:	ff8792e3          	bne	a5,s8,8000294e <scheduler+0x254>
    8000296e:	bfbd                	j	800028ec <scheduler+0x1f2>
          for(p = proc; p < &proc[NPROC];) {
    80002970:	00011497          	auipc	s1,0x11
    80002974:	2d848493          	addi	s1,s1,728 # 80013c48 <proc>
            if(p->state == RUNNABLE && p->qnum == 2 && p->priority == 3 ) {
    80002978:	4c0d                	li	s8,3
    8000297a:	4c8d                	li	s9,3
    8000297c:	1c82                	slli	s9,s9,0x20
    8000297e:	0c89                	addi	s9,s9,2
          for(p = proc; p < &proc[NPROC];) {
    80002980:	00017997          	auipc	s3,0x17
    80002984:	ec898993          	addi	s3,s3,-312 # 80019848 <tickslock>
    80002988:	a801                	j	80002998 <scheduler+0x29e>
            release(&p->lock);
    8000298a:	8526                	mv	a0,s1
    8000298c:	b00fe0ef          	jal	80000c8c <release>
            p++;
    80002990:	17048493          	addi	s1,s1,368
          for(p = proc; p < &proc[NPROC];) {
    80002994:	01348c63          	beq	s1,s3,800029ac <scheduler+0x2b2>
            acquire(&p->lock);
    80002998:	8526                	mv	a0,s1
    8000299a:	a5afe0ef          	jal	80000bf4 <acquire>
            if(p->state == RUNNABLE && p->qnum == 2 && p->priority == 3 ) {
    8000299e:	4c9c                	lw	a5,24(s1)
    800029a0:	ff8795e3          	bne	a5,s8,8000298a <scheduler+0x290>
    800029a4:	7c9c                	ld	a5,56(s1)
    800029a6:	ff9792e3          	bne	a5,s9,8000298a <scheduler+0x290>
    800029aa:	b789                	j	800028ec <scheduler+0x1f2>
          for(p = proc; p < &proc[NPROC];) {
    800029ac:	00011497          	auipc	s1,0x11
    800029b0:	29c48493          	addi	s1,s1,668 # 80013c48 <proc>
            if(p->state == RUNNABLE && p->qnum == 2 && p->priority == 2 ) {
    800029b4:	4c8d                	li	s9,3
    800029b6:	4985                	li	s3,1
    800029b8:	1986                	slli	s3,s3,0x21
    800029ba:	0989                	addi	s3,s3,2
          for(p = proc; p < &proc[NPROC];) {
    800029bc:	00017c17          	auipc	s8,0x17
    800029c0:	e8cc0c13          	addi	s8,s8,-372 # 80019848 <tickslock>
    800029c4:	a801                	j	800029d4 <scheduler+0x2da>
            release(&p->lock);
    800029c6:	8526                	mv	a0,s1
    800029c8:	ac4fe0ef          	jal	80000c8c <release>
            p++;
    800029cc:	17048493          	addi	s1,s1,368
          for(p = proc; p < &proc[NPROC];) {
    800029d0:	01848c63          	beq	s1,s8,800029e8 <scheduler+0x2ee>
            acquire(&p->lock);
    800029d4:	8526                	mv	a0,s1
    800029d6:	a1efe0ef          	jal	80000bf4 <acquire>
            if(p->state == RUNNABLE && p->qnum == 2 && p->priority == 2 ) {
    800029da:	4c9c                	lw	a5,24(s1)
    800029dc:	ff9795e3          	bne	a5,s9,800029c6 <scheduler+0x2cc>
    800029e0:	7c9c                	ld	a5,56(s1)
    800029e2:	ff3792e3          	bne	a5,s3,800029c6 <scheduler+0x2cc>
    800029e6:	b719                	j	800028ec <scheduler+0x1f2>
          for(p = proc; p < &proc[NPROC];) {
    800029e8:	00011497          	auipc	s1,0x11
    800029ec:	26048493          	addi	s1,s1,608 # 80013c48 <proc>
            if(p->state == RUNNABLE && p->qnum == 2 && p->priority == 1) {
    800029f0:	4c8d                	li	s9,3
    800029f2:	4985                	li	s3,1
    800029f4:	1982                	slli	s3,s3,0x20
    800029f6:	0989                	addi	s3,s3,2
          for(p = proc; p < &proc[NPROC];) {
    800029f8:	00017c17          	auipc	s8,0x17
    800029fc:	e50c0c13          	addi	s8,s8,-432 # 80019848 <tickslock>
    80002a00:	a801                	j	80002a10 <scheduler+0x316>
            release(&p->lock);
    80002a02:	8526                	mv	a0,s1
    80002a04:	a88fe0ef          	jal	80000c8c <release>
            p++;
    80002a08:	17048493          	addi	s1,s1,368
          for(p = proc; p < &proc[NPROC];) {
    80002a0c:	01848c63          	beq	s1,s8,80002a24 <scheduler+0x32a>
            acquire(&p->lock);
    80002a10:	8526                	mv	a0,s1
    80002a12:	9e2fe0ef          	jal	80000bf4 <acquire>
            if(p->state == RUNNABLE && p->qnum == 2 && p->priority == 1) {
    80002a16:	4c9c                	lw	a5,24(s1)
    80002a18:	ff9795e3          	bne	a5,s9,80002a02 <scheduler+0x308>
    80002a1c:	7c9c                	ld	a5,56(s1)
    80002a1e:	ff3792e3          	bne	a5,s3,80002a02 <scheduler+0x308>
    80002a22:	b5e9                	j	800028ec <scheduler+0x1f2>
          for(p = proc; p < &proc[NPROC];) {
    80002a24:	00011497          	auipc	s1,0x11
    80002a28:	22448493          	addi	s1,s1,548 # 80013c48 <proc>
            if(p->state == RUNNABLE && p->qnum == 2 && p->priority == 0) {
    80002a2c:	4c8d                	li	s9,3
    80002a2e:	4c09                	li	s8,2
          for(p = proc; p < &proc[NPROC];) {
    80002a30:	00017997          	auipc	s3,0x17
    80002a34:	e1898993          	addi	s3,s3,-488 # 80019848 <tickslock>
    80002a38:	a801                	j	80002a48 <scheduler+0x34e>
            release(&p->lock);
    80002a3a:	8526                	mv	a0,s1
    80002a3c:	a50fe0ef          	jal	80000c8c <release>
            p++;
    80002a40:	17048493          	addi	s1,s1,368
          for(p = proc; p < &proc[NPROC];) {
    80002a44:	01348c63          	beq	s1,s3,80002a5c <scheduler+0x362>
            acquire(&p->lock);
    80002a48:	8526                	mv	a0,s1
    80002a4a:	9aafe0ef          	jal	80000bf4 <acquire>
            if(p->state == RUNNABLE && p->qnum == 2 && p->priority == 0) {
    80002a4e:	4c9c                	lw	a5,24(s1)
    80002a50:	ff9795e3          	bne	a5,s9,80002a3a <scheduler+0x340>
    80002a54:	7c9c                	ld	a5,56(s1)
    80002a56:	ff8792e3          	bne	a5,s8,80002a3a <scheduler+0x340>
    80002a5a:	bd49                	j	800028ec <scheduler+0x1f2>
    int found = 0;
    80002a5c:	4481                	li	s1,0
    80002a5e:	b575                	j	8000290a <scheduler+0x210>

0000000080002a60 <getlev>:


int
getlev(struct proc *p){
    80002a60:	1101                	addi	sp,sp,-32
    80002a62:	ec06                	sd	ra,24(sp)
    80002a64:	e822                	sd	s0,16(sp)
    80002a66:	e426                	sd	s1,8(sp)
    80002a68:	e04a                	sd	s2,0(sp)
    80002a6a:	1000                	addi	s0,sp,32
    80002a6c:	84aa                	mv	s1,a0
  int mode = schedmode();
    80002a6e:	f94ff0ef          	jal	80002202 <schedmode>
  int lev;
  if(mode == 1){
    80002a72:	4785                	li	a5,1
    lev = p->qnum;
    release(&p->lock);
    return lev;
  }

  return 99;
    80002a74:	06300913          	li	s2,99
  if(mode == 1){
    80002a78:	00f50963          	beq	a0,a5,80002a8a <getlev+0x2a>
}
    80002a7c:	854a                	mv	a0,s2
    80002a7e:	60e2                	ld	ra,24(sp)
    80002a80:	6442                	ld	s0,16(sp)
    80002a82:	64a2                	ld	s1,8(sp)
    80002a84:	6902                	ld	s2,0(sp)
    80002a86:	6105                	addi	sp,sp,32
    80002a88:	8082                	ret
    acquire(&p->lock);
    80002a8a:	8526                	mv	a0,s1
    80002a8c:	968fe0ef          	jal	80000bf4 <acquire>
    lev = p->qnum;
    80002a90:	0384a903          	lw	s2,56(s1)
    release(&p->lock);
    80002a94:	8526                	mv	a0,s1
    80002a96:	9f6fe0ef          	jal	80000c8c <release>
    return lev;
    80002a9a:	b7cd                	j	80002a7c <getlev+0x1c>

0000000080002a9c <setpriority>:

int
setpriority(int pid, int np){

  if(np < 0 || np > 3){
    80002a9c:	478d                	li	a5,3
    80002a9e:	06b7e163          	bltu	a5,a1,80002b00 <setpriority+0x64>
setpriority(int pid, int np){
    80002aa2:	7179                	addi	sp,sp,-48
    80002aa4:	f406                	sd	ra,40(sp)
    80002aa6:	f022                	sd	s0,32(sp)
    80002aa8:	ec26                	sd	s1,24(sp)
    80002aaa:	e84a                	sd	s2,16(sp)
    80002aac:	e44e                	sd	s3,8(sp)
    80002aae:	e052                	sd	s4,0(sp)
    80002ab0:	1800                	addi	s0,sp,48
    80002ab2:	892a                	mv	s2,a0
    80002ab4:	8a2e                	mv	s4,a1
    return -2;
    // invalid priority
  }

  struct proc *p;
  for(p = proc; p < &proc[NPROC];){
    80002ab6:	00011497          	auipc	s1,0x11
    80002aba:	19248493          	addi	s1,s1,402 # 80013c48 <proc>
    80002abe:	00017997          	auipc	s3,0x17
    80002ac2:	d8a98993          	addi	s3,s3,-630 # 80019848 <tickslock>
    acquire(&p->lock);
    80002ac6:	8526                	mv	a0,s1
    80002ac8:	92cfe0ef          	jal	80000bf4 <acquire>
    if(p->pid == pid){ 
    80002acc:	589c                	lw	a5,48(s1)
    80002ace:	01278b63          	beq	a5,s2,80002ae4 <setpriority+0x48>
      p->priority = np; 
      release(&p->lock);  
      return 0;
    }
    release(&p->lock);
    80002ad2:	8526                	mv	a0,s1
    80002ad4:	9b8fe0ef          	jal	80000c8c <release>
    p++;
    80002ad8:	17048493          	addi	s1,s1,368
  for(p = proc; p < &proc[NPROC];){
    80002adc:	ff3495e3          	bne	s1,s3,80002ac6 <setpriority+0x2a>
  }

  return -1;
    80002ae0:	557d                	li	a0,-1
    80002ae2:	a039                	j	80002af0 <setpriority+0x54>
      p->priority = np; 
    80002ae4:	0344ae23          	sw	s4,60(s1)
      release(&p->lock);  
    80002ae8:	8526                	mv	a0,s1
    80002aea:	9a2fe0ef          	jal	80000c8c <release>
      return 0;
    80002aee:	4501                	li	a0,0
  // not found

    80002af0:	70a2                	ld	ra,40(sp)
    80002af2:	7402                	ld	s0,32(sp)
    80002af4:	64e2                	ld	s1,24(sp)
    80002af6:	6942                	ld	s2,16(sp)
    80002af8:	69a2                	ld	s3,8(sp)
    80002afa:	6a02                	ld	s4,0(sp)
    80002afc:	6145                	addi	sp,sp,48
    80002afe:	8082                	ret
    return -2;
    80002b00:	5579                	li	a0,-2
    80002b02:	8082                	ret

0000000080002b04 <swtch>:
    80002b04:	00153023          	sd	ra,0(a0)
    80002b08:	00253423          	sd	sp,8(a0)
    80002b0c:	e900                	sd	s0,16(a0)
    80002b0e:	ed04                	sd	s1,24(a0)
    80002b10:	03253023          	sd	s2,32(a0)
    80002b14:	03353423          	sd	s3,40(a0)
    80002b18:	03453823          	sd	s4,48(a0)
    80002b1c:	03553c23          	sd	s5,56(a0)
    80002b20:	05653023          	sd	s6,64(a0)
    80002b24:	05753423          	sd	s7,72(a0)
    80002b28:	05853823          	sd	s8,80(a0)
    80002b2c:	05953c23          	sd	s9,88(a0)
    80002b30:	07a53023          	sd	s10,96(a0)
    80002b34:	07b53423          	sd	s11,104(a0)
    80002b38:	0005b083          	ld	ra,0(a1)
    80002b3c:	0085b103          	ld	sp,8(a1)
    80002b40:	6980                	ld	s0,16(a1)
    80002b42:	6d84                	ld	s1,24(a1)
    80002b44:	0205b903          	ld	s2,32(a1)
    80002b48:	0285b983          	ld	s3,40(a1)
    80002b4c:	0305ba03          	ld	s4,48(a1)
    80002b50:	0385ba83          	ld	s5,56(a1)
    80002b54:	0405bb03          	ld	s6,64(a1)
    80002b58:	0485bb83          	ld	s7,72(a1)
    80002b5c:	0505bc03          	ld	s8,80(a1)
    80002b60:	0585bc83          	ld	s9,88(a1)
    80002b64:	0605bd03          	ld	s10,96(a1)
    80002b68:	0685bd83          	ld	s11,104(a1)
    80002b6c:	8082                	ret

0000000080002b6e <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002b6e:	1141                	addi	sp,sp,-16
    80002b70:	e406                	sd	ra,8(sp)
    80002b72:	e022                	sd	s0,0(sp)
    80002b74:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002b76:	00006597          	auipc	a1,0x6
    80002b7a:	81258593          	addi	a1,a1,-2030 # 80008388 <etext+0x388>
    80002b7e:	00017517          	auipc	a0,0x17
    80002b82:	cca50513          	addi	a0,a0,-822 # 80019848 <tickslock>
    80002b86:	feffd0ef          	jal	80000b74 <initlock>
}
    80002b8a:	60a2                	ld	ra,8(sp)
    80002b8c:	6402                	ld	s0,0(sp)
    80002b8e:	0141                	addi	sp,sp,16
    80002b90:	8082                	ret

0000000080002b92 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002b92:	1141                	addi	sp,sp,-16
    80002b94:	e422                	sd	s0,8(sp)
    80002b96:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002b98:	00003797          	auipc	a5,0x3
    80002b9c:	e3878793          	addi	a5,a5,-456 # 800059d0 <kernelvec>
    80002ba0:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002ba4:	6422                	ld	s0,8(sp)
    80002ba6:	0141                	addi	sp,sp,16
    80002ba8:	8082                	ret

0000000080002baa <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002baa:	1141                	addi	sp,sp,-16
    80002bac:	e406                	sd	ra,8(sp)
    80002bae:	e022                	sd	s0,0(sp)
    80002bb0:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002bb2:	d7dfe0ef          	jal	8000192e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002bb6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002bba:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002bbc:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002bc0:	00004697          	auipc	a3,0x4
    80002bc4:	44068693          	addi	a3,a3,1088 # 80007000 <_trampoline>
    80002bc8:	00004717          	auipc	a4,0x4
    80002bcc:	43870713          	addi	a4,a4,1080 # 80007000 <_trampoline>
    80002bd0:	8f15                	sub	a4,a4,a3
    80002bd2:	040007b7          	lui	a5,0x4000
    80002bd6:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002bd8:	07b2                	slli	a5,a5,0xc
    80002bda:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002bdc:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002be0:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002be2:	18002673          	csrr	a2,satp
    80002be6:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002be8:	7130                	ld	a2,96(a0)
    80002bea:	6538                	ld	a4,72(a0)
    80002bec:	6585                	lui	a1,0x1
    80002bee:	972e                	add	a4,a4,a1
    80002bf0:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002bf2:	7138                	ld	a4,96(a0)
    80002bf4:	00000617          	auipc	a2,0x0
    80002bf8:	11060613          	addi	a2,a2,272 # 80002d04 <usertrap>
    80002bfc:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002bfe:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002c00:	8612                	mv	a2,tp
    80002c02:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c04:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002c08:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002c0c:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002c10:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002c14:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002c16:	6f18                	ld	a4,24(a4)
    80002c18:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002c1c:	6d28                	ld	a0,88(a0)
    80002c1e:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002c20:	00004717          	auipc	a4,0x4
    80002c24:	47c70713          	addi	a4,a4,1148 # 8000709c <userret>
    80002c28:	8f15                	sub	a4,a4,a3
    80002c2a:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002c2c:	577d                	li	a4,-1
    80002c2e:	177e                	slli	a4,a4,0x3f
    80002c30:	8d59                	or	a0,a0,a4
    80002c32:	9782                	jalr	a5
}
    80002c34:	60a2                	ld	ra,8(sp)
    80002c36:	6402                	ld	s0,0(sp)
    80002c38:	0141                	addi	sp,sp,16
    80002c3a:	8082                	ret

0000000080002c3c <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002c3c:	1101                	addi	sp,sp,-32
    80002c3e:	ec06                	sd	ra,24(sp)
    80002c40:	e822                	sd	s0,16(sp)
    80002c42:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80002c44:	cbffe0ef          	jal	80001902 <cpuid>
    80002c48:	cd11                	beqz	a0,80002c64 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80002c4a:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80002c4e:	000f4737          	lui	a4,0xf4
    80002c52:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80002c56:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80002c58:	14d79073          	csrw	stimecmp,a5
}
    80002c5c:	60e2                	ld	ra,24(sp)
    80002c5e:	6442                	ld	s0,16(sp)
    80002c60:	6105                	addi	sp,sp,32
    80002c62:	8082                	ret
    80002c64:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    80002c66:	00017497          	auipc	s1,0x17
    80002c6a:	be248493          	addi	s1,s1,-1054 # 80019848 <tickslock>
    80002c6e:	8526                	mv	a0,s1
    80002c70:	f85fd0ef          	jal	80000bf4 <acquire>
    ticks++;
    80002c74:	00009517          	auipc	a0,0x9
    80002c78:	a2c50513          	addi	a0,a0,-1492 # 8000b6a0 <ticks>
    80002c7c:	411c                	lw	a5,0(a0)
    80002c7e:	2785                	addiw	a5,a5,1
    80002c80:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80002c82:	8d8ff0ef          	jal	80001d5a <wakeup>
    release(&tickslock);
    80002c86:	8526                	mv	a0,s1
    80002c88:	804fe0ef          	jal	80000c8c <release>
    80002c8c:	64a2                	ld	s1,8(sp)
    80002c8e:	bf75                	j	80002c4a <clockintr+0xe>

0000000080002c90 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002c90:	1101                	addi	sp,sp,-32
    80002c92:	ec06                	sd	ra,24(sp)
    80002c94:	e822                	sd	s0,16(sp)
    80002c96:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002c98:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80002c9c:	57fd                	li	a5,-1
    80002c9e:	17fe                	slli	a5,a5,0x3f
    80002ca0:	07a5                	addi	a5,a5,9
    80002ca2:	00f70c63          	beq	a4,a5,80002cba <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80002ca6:	57fd                	li	a5,-1
    80002ca8:	17fe                	slli	a5,a5,0x3f
    80002caa:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80002cac:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80002cae:	04f70763          	beq	a4,a5,80002cfc <devintr+0x6c>
  }
}
    80002cb2:	60e2                	ld	ra,24(sp)
    80002cb4:	6442                	ld	s0,16(sp)
    80002cb6:	6105                	addi	sp,sp,32
    80002cb8:	8082                	ret
    80002cba:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002cbc:	5c1020ef          	jal	80005a7c <plic_claim>
    80002cc0:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002cc2:	47a9                	li	a5,10
    80002cc4:	00f50963          	beq	a0,a5,80002cd6 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80002cc8:	4785                	li	a5,1
    80002cca:	00f50963          	beq	a0,a5,80002cdc <devintr+0x4c>
    return 1;
    80002cce:	4505                	li	a0,1
    } else if(irq){
    80002cd0:	e889                	bnez	s1,80002ce2 <devintr+0x52>
    80002cd2:	64a2                	ld	s1,8(sp)
    80002cd4:	bff9                	j	80002cb2 <devintr+0x22>
      uartintr();
    80002cd6:	d31fd0ef          	jal	80000a06 <uartintr>
    if(irq)
    80002cda:	a819                	j	80002cf0 <devintr+0x60>
      virtio_disk_intr();
    80002cdc:	266030ef          	jal	80005f42 <virtio_disk_intr>
    if(irq)
    80002ce0:	a801                	j	80002cf0 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80002ce2:	85a6                	mv	a1,s1
    80002ce4:	00005517          	auipc	a0,0x5
    80002ce8:	6ac50513          	addi	a0,a0,1708 # 80008390 <etext+0x390>
    80002cec:	fd6fd0ef          	jal	800004c2 <printf>
      plic_complete(irq);
    80002cf0:	8526                	mv	a0,s1
    80002cf2:	5ab020ef          	jal	80005a9c <plic_complete>
    return 1;
    80002cf6:	4505                	li	a0,1
    80002cf8:	64a2                	ld	s1,8(sp)
    80002cfa:	bf65                	j	80002cb2 <devintr+0x22>
    clockintr();
    80002cfc:	f41ff0ef          	jal	80002c3c <clockintr>
    return 2;
    80002d00:	4509                	li	a0,2
    80002d02:	bf45                	j	80002cb2 <devintr+0x22>

0000000080002d04 <usertrap>:
{
    80002d04:	1101                	addi	sp,sp,-32
    80002d06:	ec06                	sd	ra,24(sp)
    80002d08:	e822                	sd	s0,16(sp)
    80002d0a:	e426                	sd	s1,8(sp)
    80002d0c:	e04a                	sd	s2,0(sp)
    80002d0e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d10:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002d14:	1007f793          	andi	a5,a5,256
    80002d18:	ef85                	bnez	a5,80002d50 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002d1a:	00003797          	auipc	a5,0x3
    80002d1e:	cb678793          	addi	a5,a5,-842 # 800059d0 <kernelvec>
    80002d22:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002d26:	c09fe0ef          	jal	8000192e <myproc>
    80002d2a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002d2c:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d2e:	14102773          	csrr	a4,sepc
    80002d32:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002d34:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002d38:	47a1                	li	a5,8
    80002d3a:	02f70163          	beq	a4,a5,80002d5c <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    80002d3e:	f53ff0ef          	jal	80002c90 <devintr>
    80002d42:	892a                	mv	s2,a0
    80002d44:	c135                	beqz	a0,80002da8 <usertrap+0xa4>
  if(killed(p))
    80002d46:	8526                	mv	a0,s1
    80002d48:	9feff0ef          	jal	80001f46 <killed>
    80002d4c:	cd1d                	beqz	a0,80002d8a <usertrap+0x86>
    80002d4e:	a81d                	j	80002d84 <usertrap+0x80>
    panic("usertrap: not from user mode");
    80002d50:	00005517          	auipc	a0,0x5
    80002d54:	66050513          	addi	a0,a0,1632 # 800083b0 <etext+0x3b0>
    80002d58:	a3dfd0ef          	jal	80000794 <panic>
    if(killed(p))
    80002d5c:	9eaff0ef          	jal	80001f46 <killed>
    80002d60:	e121                	bnez	a0,80002da0 <usertrap+0x9c>
    p->trapframe->epc += 4;
    80002d62:	70b8                	ld	a4,96(s1)
    80002d64:	6f1c                	ld	a5,24(a4)
    80002d66:	0791                	addi	a5,a5,4
    80002d68:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d6a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002d6e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002d72:	10079073          	csrw	sstatus,a5
    syscall();
    80002d76:	278000ef          	jal	80002fee <syscall>
  if(killed(p))
    80002d7a:	8526                	mv	a0,s1
    80002d7c:	9caff0ef          	jal	80001f46 <killed>
    80002d80:	c901                	beqz	a0,80002d90 <usertrap+0x8c>
    80002d82:	4901                	li	s2,0
    exit(-1);
    80002d84:	557d                	li	a0,-1
    80002d86:	894ff0ef          	jal	80001e1a <exit>
  if(which_dev == 2){
    80002d8a:	4789                	li	a5,2
    80002d8c:	04f90563          	beq	s2,a5,80002dd6 <usertrap+0xd2>
  usertrapret();
    80002d90:	e1bff0ef          	jal	80002baa <usertrapret>
}
    80002d94:	60e2                	ld	ra,24(sp)
    80002d96:	6442                	ld	s0,16(sp)
    80002d98:	64a2                	ld	s1,8(sp)
    80002d9a:	6902                	ld	s2,0(sp)
    80002d9c:	6105                	addi	sp,sp,32
    80002d9e:	8082                	ret
      exit(-1);
    80002da0:	557d                	li	a0,-1
    80002da2:	878ff0ef          	jal	80001e1a <exit>
    80002da6:	bf75                	j	80002d62 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002da8:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002dac:	5890                	lw	a2,48(s1)
    80002dae:	00005517          	auipc	a0,0x5
    80002db2:	62250513          	addi	a0,a0,1570 # 800083d0 <etext+0x3d0>
    80002db6:	f0cfd0ef          	jal	800004c2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002dba:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002dbe:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002dc2:	00005517          	auipc	a0,0x5
    80002dc6:	63e50513          	addi	a0,a0,1598 # 80008400 <etext+0x400>
    80002dca:	ef8fd0ef          	jal	800004c2 <printf>
    setkilled(p);
    80002dce:	8526                	mv	a0,s1
    80002dd0:	952ff0ef          	jal	80001f22 <setkilled>
    80002dd4:	b75d                	j	80002d7a <usertrap+0x76>
    yield();
    80002dd6:	875ff0ef          	jal	8000264a <yield>
    80002dda:	bf5d                	j	80002d90 <usertrap+0x8c>

0000000080002ddc <kerneltrap>:
{
    80002ddc:	7179                	addi	sp,sp,-48
    80002dde:	f406                	sd	ra,40(sp)
    80002de0:	f022                	sd	s0,32(sp)
    80002de2:	ec26                	sd	s1,24(sp)
    80002de4:	e84a                	sd	s2,16(sp)
    80002de6:	e44e                	sd	s3,8(sp)
    80002de8:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002dea:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002dee:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002df2:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002df6:	1004f793          	andi	a5,s1,256
    80002dfa:	c795                	beqz	a5,80002e26 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002dfc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002e00:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002e02:	eb85                	bnez	a5,80002e32 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80002e04:	e8dff0ef          	jal	80002c90 <devintr>
    80002e08:	c91d                	beqz	a0,80002e3e <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80002e0a:	4789                	li	a5,2
    80002e0c:	04f50a63          	beq	a0,a5,80002e60 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002e10:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002e14:	10049073          	csrw	sstatus,s1
}
    80002e18:	70a2                	ld	ra,40(sp)
    80002e1a:	7402                	ld	s0,32(sp)
    80002e1c:	64e2                	ld	s1,24(sp)
    80002e1e:	6942                	ld	s2,16(sp)
    80002e20:	69a2                	ld	s3,8(sp)
    80002e22:	6145                	addi	sp,sp,48
    80002e24:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002e26:	00005517          	auipc	a0,0x5
    80002e2a:	60250513          	addi	a0,a0,1538 # 80008428 <etext+0x428>
    80002e2e:	967fd0ef          	jal	80000794 <panic>
    panic("kerneltrap: interrupts enabled");
    80002e32:	00005517          	auipc	a0,0x5
    80002e36:	61e50513          	addi	a0,a0,1566 # 80008450 <etext+0x450>
    80002e3a:	95bfd0ef          	jal	80000794 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002e3e:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002e42:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002e46:	85ce                	mv	a1,s3
    80002e48:	00005517          	auipc	a0,0x5
    80002e4c:	62850513          	addi	a0,a0,1576 # 80008470 <etext+0x470>
    80002e50:	e72fd0ef          	jal	800004c2 <printf>
    panic("kerneltrap");
    80002e54:	00005517          	auipc	a0,0x5
    80002e58:	64450513          	addi	a0,a0,1604 # 80008498 <etext+0x498>
    80002e5c:	939fd0ef          	jal	80000794 <panic>
  if(which_dev == 2 && myproc() != 0)
    80002e60:	acffe0ef          	jal	8000192e <myproc>
    80002e64:	d555                	beqz	a0,80002e10 <kerneltrap+0x34>
    yield();
    80002e66:	fe4ff0ef          	jal	8000264a <yield>
    80002e6a:	b75d                	j	80002e10 <kerneltrap+0x34>

0000000080002e6c <resetticks>:

// reset ticks
void
resetticks(void)
{
    80002e6c:	1101                	addi	sp,sp,-32
    80002e6e:	ec06                	sd	ra,24(sp)
    80002e70:	e822                	sd	s0,16(sp)
    80002e72:	e426                	sd	s1,8(sp)
    80002e74:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002e76:	00017497          	auipc	s1,0x17
    80002e7a:	9d248493          	addi	s1,s1,-1582 # 80019848 <tickslock>
    80002e7e:	8526                	mv	a0,s1
    80002e80:	d75fd0ef          	jal	80000bf4 <acquire>
  ticks = 0;
    80002e84:	00009797          	auipc	a5,0x9
    80002e88:	8007ae23          	sw	zero,-2020(a5) # 8000b6a0 <ticks>
  release(&tickslock);
    80002e8c:	8526                	mv	a0,s1
    80002e8e:	dfffd0ef          	jal	80000c8c <release>
    80002e92:	60e2                	ld	ra,24(sp)
    80002e94:	6442                	ld	s0,16(sp)
    80002e96:	64a2                	ld	s1,8(sp)
    80002e98:	6105                	addi	sp,sp,32
    80002e9a:	8082                	ret

0000000080002e9c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002e9c:	1101                	addi	sp,sp,-32
    80002e9e:	ec06                	sd	ra,24(sp)
    80002ea0:	e822                	sd	s0,16(sp)
    80002ea2:	e426                	sd	s1,8(sp)
    80002ea4:	1000                	addi	s0,sp,32
    80002ea6:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002ea8:	a87fe0ef          	jal	8000192e <myproc>
  switch (n) {
    80002eac:	4795                	li	a5,5
    80002eae:	0497e163          	bltu	a5,s1,80002ef0 <argraw+0x54>
    80002eb2:	048a                	slli	s1,s1,0x2
    80002eb4:	00006717          	auipc	a4,0x6
    80002eb8:	9d470713          	addi	a4,a4,-1580 # 80008888 <states.0+0x30>
    80002ebc:	94ba                	add	s1,s1,a4
    80002ebe:	409c                	lw	a5,0(s1)
    80002ec0:	97ba                	add	a5,a5,a4
    80002ec2:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002ec4:	713c                	ld	a5,96(a0)
    80002ec6:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002ec8:	60e2                	ld	ra,24(sp)
    80002eca:	6442                	ld	s0,16(sp)
    80002ecc:	64a2                	ld	s1,8(sp)
    80002ece:	6105                	addi	sp,sp,32
    80002ed0:	8082                	ret
    return p->trapframe->a1;
    80002ed2:	713c                	ld	a5,96(a0)
    80002ed4:	7fa8                	ld	a0,120(a5)
    80002ed6:	bfcd                	j	80002ec8 <argraw+0x2c>
    return p->trapframe->a2;
    80002ed8:	713c                	ld	a5,96(a0)
    80002eda:	63c8                	ld	a0,128(a5)
    80002edc:	b7f5                	j	80002ec8 <argraw+0x2c>
    return p->trapframe->a3;
    80002ede:	713c                	ld	a5,96(a0)
    80002ee0:	67c8                	ld	a0,136(a5)
    80002ee2:	b7dd                	j	80002ec8 <argraw+0x2c>
    return p->trapframe->a4;
    80002ee4:	713c                	ld	a5,96(a0)
    80002ee6:	6bc8                	ld	a0,144(a5)
    80002ee8:	b7c5                	j	80002ec8 <argraw+0x2c>
    return p->trapframe->a5;
    80002eea:	713c                	ld	a5,96(a0)
    80002eec:	6fc8                	ld	a0,152(a5)
    80002eee:	bfe9                	j	80002ec8 <argraw+0x2c>
  panic("argraw");
    80002ef0:	00005517          	auipc	a0,0x5
    80002ef4:	5b850513          	addi	a0,a0,1464 # 800084a8 <etext+0x4a8>
    80002ef8:	89dfd0ef          	jal	80000794 <panic>

0000000080002efc <fetchaddr>:
{
    80002efc:	1101                	addi	sp,sp,-32
    80002efe:	ec06                	sd	ra,24(sp)
    80002f00:	e822                	sd	s0,16(sp)
    80002f02:	e426                	sd	s1,8(sp)
    80002f04:	e04a                	sd	s2,0(sp)
    80002f06:	1000                	addi	s0,sp,32
    80002f08:	84aa                	mv	s1,a0
    80002f0a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002f0c:	a23fe0ef          	jal	8000192e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002f10:	693c                	ld	a5,80(a0)
    80002f12:	02f4f663          	bgeu	s1,a5,80002f3e <fetchaddr+0x42>
    80002f16:	00848713          	addi	a4,s1,8
    80002f1a:	02e7e463          	bltu	a5,a4,80002f42 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002f1e:	46a1                	li	a3,8
    80002f20:	8626                	mv	a2,s1
    80002f22:	85ca                	mv	a1,s2
    80002f24:	6d28                	ld	a0,88(a0)
    80002f26:	f02fe0ef          	jal	80001628 <copyin>
    80002f2a:	00a03533          	snez	a0,a0
    80002f2e:	40a00533          	neg	a0,a0
}
    80002f32:	60e2                	ld	ra,24(sp)
    80002f34:	6442                	ld	s0,16(sp)
    80002f36:	64a2                	ld	s1,8(sp)
    80002f38:	6902                	ld	s2,0(sp)
    80002f3a:	6105                	addi	sp,sp,32
    80002f3c:	8082                	ret
    return -1;
    80002f3e:	557d                	li	a0,-1
    80002f40:	bfcd                	j	80002f32 <fetchaddr+0x36>
    80002f42:	557d                	li	a0,-1
    80002f44:	b7fd                	j	80002f32 <fetchaddr+0x36>

0000000080002f46 <fetchstr>:
{
    80002f46:	7179                	addi	sp,sp,-48
    80002f48:	f406                	sd	ra,40(sp)
    80002f4a:	f022                	sd	s0,32(sp)
    80002f4c:	ec26                	sd	s1,24(sp)
    80002f4e:	e84a                	sd	s2,16(sp)
    80002f50:	e44e                	sd	s3,8(sp)
    80002f52:	1800                	addi	s0,sp,48
    80002f54:	892a                	mv	s2,a0
    80002f56:	84ae                	mv	s1,a1
    80002f58:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002f5a:	9d5fe0ef          	jal	8000192e <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002f5e:	86ce                	mv	a3,s3
    80002f60:	864a                	mv	a2,s2
    80002f62:	85a6                	mv	a1,s1
    80002f64:	6d28                	ld	a0,88(a0)
    80002f66:	f48fe0ef          	jal	800016ae <copyinstr>
    80002f6a:	00054c63          	bltz	a0,80002f82 <fetchstr+0x3c>
  return strlen(buf);
    80002f6e:	8526                	mv	a0,s1
    80002f70:	ec9fd0ef          	jal	80000e38 <strlen>
}
    80002f74:	70a2                	ld	ra,40(sp)
    80002f76:	7402                	ld	s0,32(sp)
    80002f78:	64e2                	ld	s1,24(sp)
    80002f7a:	6942                	ld	s2,16(sp)
    80002f7c:	69a2                	ld	s3,8(sp)
    80002f7e:	6145                	addi	sp,sp,48
    80002f80:	8082                	ret
    return -1;
    80002f82:	557d                	li	a0,-1
    80002f84:	bfc5                	j	80002f74 <fetchstr+0x2e>

0000000080002f86 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002f86:	1101                	addi	sp,sp,-32
    80002f88:	ec06                	sd	ra,24(sp)
    80002f8a:	e822                	sd	s0,16(sp)
    80002f8c:	e426                	sd	s1,8(sp)
    80002f8e:	1000                	addi	s0,sp,32
    80002f90:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002f92:	f0bff0ef          	jal	80002e9c <argraw>
    80002f96:	c088                	sw	a0,0(s1)
}
    80002f98:	60e2                	ld	ra,24(sp)
    80002f9a:	6442                	ld	s0,16(sp)
    80002f9c:	64a2                	ld	s1,8(sp)
    80002f9e:	6105                	addi	sp,sp,32
    80002fa0:	8082                	ret

0000000080002fa2 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002fa2:	1101                	addi	sp,sp,-32
    80002fa4:	ec06                	sd	ra,24(sp)
    80002fa6:	e822                	sd	s0,16(sp)
    80002fa8:	e426                	sd	s1,8(sp)
    80002faa:	1000                	addi	s0,sp,32
    80002fac:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002fae:	eefff0ef          	jal	80002e9c <argraw>
    80002fb2:	e088                	sd	a0,0(s1)
}
    80002fb4:	60e2                	ld	ra,24(sp)
    80002fb6:	6442                	ld	s0,16(sp)
    80002fb8:	64a2                	ld	s1,8(sp)
    80002fba:	6105                	addi	sp,sp,32
    80002fbc:	8082                	ret

0000000080002fbe <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002fbe:	7179                	addi	sp,sp,-48
    80002fc0:	f406                	sd	ra,40(sp)
    80002fc2:	f022                	sd	s0,32(sp)
    80002fc4:	ec26                	sd	s1,24(sp)
    80002fc6:	e84a                	sd	s2,16(sp)
    80002fc8:	1800                	addi	s0,sp,48
    80002fca:	84ae                	mv	s1,a1
    80002fcc:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002fce:	fd840593          	addi	a1,s0,-40
    80002fd2:	fd1ff0ef          	jal	80002fa2 <argaddr>
  return fetchstr(addr, buf, max);
    80002fd6:	864a                	mv	a2,s2
    80002fd8:	85a6                	mv	a1,s1
    80002fda:	fd843503          	ld	a0,-40(s0)
    80002fde:	f69ff0ef          	jal	80002f46 <fetchstr>
}
    80002fe2:	70a2                	ld	ra,40(sp)
    80002fe4:	7402                	ld	s0,32(sp)
    80002fe6:	64e2                	ld	s1,24(sp)
    80002fe8:	6942                	ld	s2,16(sp)
    80002fea:	6145                	addi	sp,sp,48
    80002fec:	8082                	ret

0000000080002fee <syscall>:
[SYS_setpriority] sys_setpriority,
};

void
syscall(void)
{
    80002fee:	1101                	addi	sp,sp,-32
    80002ff0:	ec06                	sd	ra,24(sp)
    80002ff2:	e822                	sd	s0,16(sp)
    80002ff4:	e426                	sd	s1,8(sp)
    80002ff6:	e04a                	sd	s2,0(sp)
    80002ff8:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002ffa:	935fe0ef          	jal	8000192e <myproc>
    80002ffe:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80003000:	06053903          	ld	s2,96(a0)
    80003004:	0a893783          	ld	a5,168(s2)
    80003008:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000300c:	37fd                	addiw	a5,a5,-1
    8000300e:	4765                	li	a4,25
    80003010:	00f76f63          	bltu	a4,a5,8000302e <syscall+0x40>
    80003014:	00369713          	slli	a4,a3,0x3
    80003018:	00006797          	auipc	a5,0x6
    8000301c:	88878793          	addi	a5,a5,-1912 # 800088a0 <syscalls>
    80003020:	97ba                	add	a5,a5,a4
    80003022:	639c                	ld	a5,0(a5)
    80003024:	c789                	beqz	a5,8000302e <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80003026:	9782                	jalr	a5
    80003028:	06a93823          	sd	a0,112(s2)
    8000302c:	a829                	j	80003046 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000302e:	16048613          	addi	a2,s1,352
    80003032:	588c                	lw	a1,48(s1)
    80003034:	00005517          	auipc	a0,0x5
    80003038:	47c50513          	addi	a0,a0,1148 # 800084b0 <etext+0x4b0>
    8000303c:	c86fd0ef          	jal	800004c2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80003040:	70bc                	ld	a5,96(s1)
    80003042:	577d                	li	a4,-1
    80003044:	fbb8                	sd	a4,112(a5)
  }
}
    80003046:	60e2                	ld	ra,24(sp)
    80003048:	6442                	ld	s0,16(sp)
    8000304a:	64a2                	ld	s1,8(sp)
    8000304c:	6902                	ld	s2,0(sp)
    8000304e:	6105                	addi	sp,sp,32
    80003050:	8082                	ret

0000000080003052 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80003052:	1101                	addi	sp,sp,-32
    80003054:	ec06                	sd	ra,24(sp)
    80003056:	e822                	sd	s0,16(sp)
    80003058:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000305a:	fec40593          	addi	a1,s0,-20
    8000305e:	4501                	li	a0,0
    80003060:	f27ff0ef          	jal	80002f86 <argint>
  exit(n);
    80003064:	fec42503          	lw	a0,-20(s0)
    80003068:	db3fe0ef          	jal	80001e1a <exit>
  return 0;  // not reached
}
    8000306c:	4501                	li	a0,0
    8000306e:	60e2                	ld	ra,24(sp)
    80003070:	6442                	ld	s0,16(sp)
    80003072:	6105                	addi	sp,sp,32
    80003074:	8082                	ret

0000000080003076 <sys_getpid>:

uint64
sys_getpid(void)
{
    80003076:	1141                	addi	sp,sp,-16
    80003078:	e406                	sd	ra,8(sp)
    8000307a:	e022                	sd	s0,0(sp)
    8000307c:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000307e:	8b1fe0ef          	jal	8000192e <myproc>
}
    80003082:	5908                	lw	a0,48(a0)
    80003084:	60a2                	ld	ra,8(sp)
    80003086:	6402                	ld	s0,0(sp)
    80003088:	0141                	addi	sp,sp,16
    8000308a:	8082                	ret

000000008000308c <sys_fork>:

uint64
sys_fork(void)
{
    8000308c:	1141                	addi	sp,sp,-16
    8000308e:	e406                	sd	ra,8(sp)
    80003090:	e022                	sd	s0,0(sp)
    80003092:	0800                	addi	s0,sp,16
  return fork();
    80003094:	9a4ff0ef          	jal	80002238 <fork>
}
    80003098:	60a2                	ld	ra,8(sp)
    8000309a:	6402                	ld	s0,0(sp)
    8000309c:	0141                	addi	sp,sp,16
    8000309e:	8082                	ret

00000000800030a0 <sys_wait>:

uint64
sys_wait(void)
{
    800030a0:	1101                	addi	sp,sp,-32
    800030a2:	ec06                	sd	ra,24(sp)
    800030a4:	e822                	sd	s0,16(sp)
    800030a6:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800030a8:	fe840593          	addi	a1,s0,-24
    800030ac:	4501                	li	a0,0
    800030ae:	ef5ff0ef          	jal	80002fa2 <argaddr>
  return wait(p);
    800030b2:	fe843503          	ld	a0,-24(s0)
    800030b6:	ebbfe0ef          	jal	80001f70 <wait>
}
    800030ba:	60e2                	ld	ra,24(sp)
    800030bc:	6442                	ld	s0,16(sp)
    800030be:	6105                	addi	sp,sp,32
    800030c0:	8082                	ret

00000000800030c2 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800030c2:	7179                	addi	sp,sp,-48
    800030c4:	f406                	sd	ra,40(sp)
    800030c6:	f022                	sd	s0,32(sp)
    800030c8:	ec26                	sd	s1,24(sp)
    800030ca:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800030cc:	fdc40593          	addi	a1,s0,-36
    800030d0:	4501                	li	a0,0
    800030d2:	eb5ff0ef          	jal	80002f86 <argint>
  addr = myproc()->sz;
    800030d6:	859fe0ef          	jal	8000192e <myproc>
    800030da:	6924                	ld	s1,80(a0)
  if(growproc(n) < 0)
    800030dc:	fdc42503          	lw	a0,-36(s0)
    800030e0:	b25fe0ef          	jal	80001c04 <growproc>
    800030e4:	00054863          	bltz	a0,800030f4 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    800030e8:	8526                	mv	a0,s1
    800030ea:	70a2                	ld	ra,40(sp)
    800030ec:	7402                	ld	s0,32(sp)
    800030ee:	64e2                	ld	s1,24(sp)
    800030f0:	6145                	addi	sp,sp,48
    800030f2:	8082                	ret
    return -1;
    800030f4:	54fd                	li	s1,-1
    800030f6:	bfcd                	j	800030e8 <sys_sbrk+0x26>

00000000800030f8 <sys_sleep>:

uint64
sys_sleep(void)
{
    800030f8:	7139                	addi	sp,sp,-64
    800030fa:	fc06                	sd	ra,56(sp)
    800030fc:	f822                	sd	s0,48(sp)
    800030fe:	f04a                	sd	s2,32(sp)
    80003100:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80003102:	fcc40593          	addi	a1,s0,-52
    80003106:	4501                	li	a0,0
    80003108:	e7fff0ef          	jal	80002f86 <argint>
  if(n < 0)
    8000310c:	fcc42783          	lw	a5,-52(s0)
    80003110:	0607c763          	bltz	a5,8000317e <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80003114:	00016517          	auipc	a0,0x16
    80003118:	73450513          	addi	a0,a0,1844 # 80019848 <tickslock>
    8000311c:	ad9fd0ef          	jal	80000bf4 <acquire>
  ticks0 = ticks;
    80003120:	00008917          	auipc	s2,0x8
    80003124:	58092903          	lw	s2,1408(s2) # 8000b6a0 <ticks>
  while(ticks - ticks0 < n){
    80003128:	fcc42783          	lw	a5,-52(s0)
    8000312c:	cf8d                	beqz	a5,80003166 <sys_sleep+0x6e>
    8000312e:	f426                	sd	s1,40(sp)
    80003130:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80003132:	00016997          	auipc	s3,0x16
    80003136:	71698993          	addi	s3,s3,1814 # 80019848 <tickslock>
    8000313a:	00008497          	auipc	s1,0x8
    8000313e:	56648493          	addi	s1,s1,1382 # 8000b6a0 <ticks>
    if(killed(myproc())){
    80003142:	fecfe0ef          	jal	8000192e <myproc>
    80003146:	e01fe0ef          	jal	80001f46 <killed>
    8000314a:	ed0d                	bnez	a0,80003184 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    8000314c:	85ce                	mv	a1,s3
    8000314e:	8526                	mv	a0,s1
    80003150:	bbffe0ef          	jal	80001d0e <sleep>
  while(ticks - ticks0 < n){
    80003154:	409c                	lw	a5,0(s1)
    80003156:	412787bb          	subw	a5,a5,s2
    8000315a:	fcc42703          	lw	a4,-52(s0)
    8000315e:	fee7e2e3          	bltu	a5,a4,80003142 <sys_sleep+0x4a>
    80003162:	74a2                	ld	s1,40(sp)
    80003164:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80003166:	00016517          	auipc	a0,0x16
    8000316a:	6e250513          	addi	a0,a0,1762 # 80019848 <tickslock>
    8000316e:	b1ffd0ef          	jal	80000c8c <release>
  return 0;
    80003172:	4501                	li	a0,0
}
    80003174:	70e2                	ld	ra,56(sp)
    80003176:	7442                	ld	s0,48(sp)
    80003178:	7902                	ld	s2,32(sp)
    8000317a:	6121                	addi	sp,sp,64
    8000317c:	8082                	ret
    n = 0;
    8000317e:	fc042623          	sw	zero,-52(s0)
    80003182:	bf49                	j	80003114 <sys_sleep+0x1c>
      release(&tickslock);
    80003184:	00016517          	auipc	a0,0x16
    80003188:	6c450513          	addi	a0,a0,1732 # 80019848 <tickslock>
    8000318c:	b01fd0ef          	jal	80000c8c <release>
      return -1;
    80003190:	557d                	li	a0,-1
    80003192:	74a2                	ld	s1,40(sp)
    80003194:	69e2                	ld	s3,24(sp)
    80003196:	bff9                	j	80003174 <sys_sleep+0x7c>

0000000080003198 <sys_kill>:

uint64
sys_kill(void)
{
    80003198:	1101                	addi	sp,sp,-32
    8000319a:	ec06                	sd	ra,24(sp)
    8000319c:	e822                	sd	s0,16(sp)
    8000319e:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800031a0:	fec40593          	addi	a1,s0,-20
    800031a4:	4501                	li	a0,0
    800031a6:	de1ff0ef          	jal	80002f86 <argint>
  return kill(pid);
    800031aa:	fec42503          	lw	a0,-20(s0)
    800031ae:	d0ffe0ef          	jal	80001ebc <kill>
}
    800031b2:	60e2                	ld	ra,24(sp)
    800031b4:	6442                	ld	s0,16(sp)
    800031b6:	6105                	addi	sp,sp,32
    800031b8:	8082                	ret

00000000800031ba <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800031ba:	1101                	addi	sp,sp,-32
    800031bc:	ec06                	sd	ra,24(sp)
    800031be:	e822                	sd	s0,16(sp)
    800031c0:	e426                	sd	s1,8(sp)
    800031c2:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800031c4:	00016517          	auipc	a0,0x16
    800031c8:	68450513          	addi	a0,a0,1668 # 80019848 <tickslock>
    800031cc:	a29fd0ef          	jal	80000bf4 <acquire>
  xticks = ticks;
    800031d0:	00008497          	auipc	s1,0x8
    800031d4:	4d04a483          	lw	s1,1232(s1) # 8000b6a0 <ticks>
  release(&tickslock);
    800031d8:	00016517          	auipc	a0,0x16
    800031dc:	67050513          	addi	a0,a0,1648 # 80019848 <tickslock>
    800031e0:	aadfd0ef          	jal	80000c8c <release>
  return xticks;
}
    800031e4:	02049513          	slli	a0,s1,0x20
    800031e8:	9101                	srli	a0,a0,0x20
    800031ea:	60e2                	ld	ra,24(sp)
    800031ec:	6442                	ld	s0,16(sp)
    800031ee:	64a2                	ld	s1,8(sp)
    800031f0:	6105                	addi	sp,sp,32
    800031f2:	8082                	ret

00000000800031f4 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800031f4:	7179                	addi	sp,sp,-48
    800031f6:	f406                	sd	ra,40(sp)
    800031f8:	f022                	sd	s0,32(sp)
    800031fa:	ec26                	sd	s1,24(sp)
    800031fc:	e84a                	sd	s2,16(sp)
    800031fe:	e44e                	sd	s3,8(sp)
    80003200:	e052                	sd	s4,0(sp)
    80003202:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003204:	00005597          	auipc	a1,0x5
    80003208:	2cc58593          	addi	a1,a1,716 # 800084d0 <etext+0x4d0>
    8000320c:	00016517          	auipc	a0,0x16
    80003210:	65450513          	addi	a0,a0,1620 # 80019860 <bcache>
    80003214:	961fd0ef          	jal	80000b74 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003218:	0001e797          	auipc	a5,0x1e
    8000321c:	64878793          	addi	a5,a5,1608 # 80021860 <bcache+0x8000>
    80003220:	0001f717          	auipc	a4,0x1f
    80003224:	8a870713          	addi	a4,a4,-1880 # 80021ac8 <bcache+0x8268>
    80003228:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000322c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003230:	00016497          	auipc	s1,0x16
    80003234:	64848493          	addi	s1,s1,1608 # 80019878 <bcache+0x18>
    b->next = bcache.head.next;
    80003238:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000323a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000323c:	00005a17          	auipc	s4,0x5
    80003240:	29ca0a13          	addi	s4,s4,668 # 800084d8 <etext+0x4d8>
    b->next = bcache.head.next;
    80003244:	2b893783          	ld	a5,696(s2)
    80003248:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000324a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000324e:	85d2                	mv	a1,s4
    80003250:	01048513          	addi	a0,s1,16
    80003254:	248010ef          	jal	8000449c <initsleeplock>
    bcache.head.next->prev = b;
    80003258:	2b893783          	ld	a5,696(s2)
    8000325c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000325e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003262:	45848493          	addi	s1,s1,1112
    80003266:	fd349fe3          	bne	s1,s3,80003244 <binit+0x50>
  }
}
    8000326a:	70a2                	ld	ra,40(sp)
    8000326c:	7402                	ld	s0,32(sp)
    8000326e:	64e2                	ld	s1,24(sp)
    80003270:	6942                	ld	s2,16(sp)
    80003272:	69a2                	ld	s3,8(sp)
    80003274:	6a02                	ld	s4,0(sp)
    80003276:	6145                	addi	sp,sp,48
    80003278:	8082                	ret

000000008000327a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000327a:	7179                	addi	sp,sp,-48
    8000327c:	f406                	sd	ra,40(sp)
    8000327e:	f022                	sd	s0,32(sp)
    80003280:	ec26                	sd	s1,24(sp)
    80003282:	e84a                	sd	s2,16(sp)
    80003284:	e44e                	sd	s3,8(sp)
    80003286:	1800                	addi	s0,sp,48
    80003288:	892a                	mv	s2,a0
    8000328a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000328c:	00016517          	auipc	a0,0x16
    80003290:	5d450513          	addi	a0,a0,1492 # 80019860 <bcache>
    80003294:	961fd0ef          	jal	80000bf4 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003298:	0001f497          	auipc	s1,0x1f
    8000329c:	8804b483          	ld	s1,-1920(s1) # 80021b18 <bcache+0x82b8>
    800032a0:	0001f797          	auipc	a5,0x1f
    800032a4:	82878793          	addi	a5,a5,-2008 # 80021ac8 <bcache+0x8268>
    800032a8:	02f48b63          	beq	s1,a5,800032de <bread+0x64>
    800032ac:	873e                	mv	a4,a5
    800032ae:	a021                	j	800032b6 <bread+0x3c>
    800032b0:	68a4                	ld	s1,80(s1)
    800032b2:	02e48663          	beq	s1,a4,800032de <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    800032b6:	449c                	lw	a5,8(s1)
    800032b8:	ff279ce3          	bne	a5,s2,800032b0 <bread+0x36>
    800032bc:	44dc                	lw	a5,12(s1)
    800032be:	ff3799e3          	bne	a5,s3,800032b0 <bread+0x36>
      b->refcnt++;
    800032c2:	40bc                	lw	a5,64(s1)
    800032c4:	2785                	addiw	a5,a5,1
    800032c6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800032c8:	00016517          	auipc	a0,0x16
    800032cc:	59850513          	addi	a0,a0,1432 # 80019860 <bcache>
    800032d0:	9bdfd0ef          	jal	80000c8c <release>
      acquiresleep(&b->lock);
    800032d4:	01048513          	addi	a0,s1,16
    800032d8:	1fa010ef          	jal	800044d2 <acquiresleep>
      return b;
    800032dc:	a889                	j	8000332e <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800032de:	0001f497          	auipc	s1,0x1f
    800032e2:	8324b483          	ld	s1,-1998(s1) # 80021b10 <bcache+0x82b0>
    800032e6:	0001e797          	auipc	a5,0x1e
    800032ea:	7e278793          	addi	a5,a5,2018 # 80021ac8 <bcache+0x8268>
    800032ee:	00f48863          	beq	s1,a5,800032fe <bread+0x84>
    800032f2:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800032f4:	40bc                	lw	a5,64(s1)
    800032f6:	cb91                	beqz	a5,8000330a <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800032f8:	64a4                	ld	s1,72(s1)
    800032fa:	fee49de3          	bne	s1,a4,800032f4 <bread+0x7a>
  panic("bget: no buffers");
    800032fe:	00005517          	auipc	a0,0x5
    80003302:	1e250513          	addi	a0,a0,482 # 800084e0 <etext+0x4e0>
    80003306:	c8efd0ef          	jal	80000794 <panic>
      b->dev = dev;
    8000330a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000330e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003312:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003316:	4785                	li	a5,1
    80003318:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000331a:	00016517          	auipc	a0,0x16
    8000331e:	54650513          	addi	a0,a0,1350 # 80019860 <bcache>
    80003322:	96bfd0ef          	jal	80000c8c <release>
      acquiresleep(&b->lock);
    80003326:	01048513          	addi	a0,s1,16
    8000332a:	1a8010ef          	jal	800044d2 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000332e:	409c                	lw	a5,0(s1)
    80003330:	cb89                	beqz	a5,80003342 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003332:	8526                	mv	a0,s1
    80003334:	70a2                	ld	ra,40(sp)
    80003336:	7402                	ld	s0,32(sp)
    80003338:	64e2                	ld	s1,24(sp)
    8000333a:	6942                	ld	s2,16(sp)
    8000333c:	69a2                	ld	s3,8(sp)
    8000333e:	6145                	addi	sp,sp,48
    80003340:	8082                	ret
    virtio_disk_rw(b, 0);
    80003342:	4581                	li	a1,0
    80003344:	8526                	mv	a0,s1
    80003346:	1eb020ef          	jal	80005d30 <virtio_disk_rw>
    b->valid = 1;
    8000334a:	4785                	li	a5,1
    8000334c:	c09c                	sw	a5,0(s1)
  return b;
    8000334e:	b7d5                	j	80003332 <bread+0xb8>

0000000080003350 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003350:	1101                	addi	sp,sp,-32
    80003352:	ec06                	sd	ra,24(sp)
    80003354:	e822                	sd	s0,16(sp)
    80003356:	e426                	sd	s1,8(sp)
    80003358:	1000                	addi	s0,sp,32
    8000335a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000335c:	0541                	addi	a0,a0,16
    8000335e:	1f2010ef          	jal	80004550 <holdingsleep>
    80003362:	c911                	beqz	a0,80003376 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003364:	4585                	li	a1,1
    80003366:	8526                	mv	a0,s1
    80003368:	1c9020ef          	jal	80005d30 <virtio_disk_rw>
}
    8000336c:	60e2                	ld	ra,24(sp)
    8000336e:	6442                	ld	s0,16(sp)
    80003370:	64a2                	ld	s1,8(sp)
    80003372:	6105                	addi	sp,sp,32
    80003374:	8082                	ret
    panic("bwrite");
    80003376:	00005517          	auipc	a0,0x5
    8000337a:	18250513          	addi	a0,a0,386 # 800084f8 <etext+0x4f8>
    8000337e:	c16fd0ef          	jal	80000794 <panic>

0000000080003382 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003382:	1101                	addi	sp,sp,-32
    80003384:	ec06                	sd	ra,24(sp)
    80003386:	e822                	sd	s0,16(sp)
    80003388:	e426                	sd	s1,8(sp)
    8000338a:	e04a                	sd	s2,0(sp)
    8000338c:	1000                	addi	s0,sp,32
    8000338e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003390:	01050913          	addi	s2,a0,16
    80003394:	854a                	mv	a0,s2
    80003396:	1ba010ef          	jal	80004550 <holdingsleep>
    8000339a:	c135                	beqz	a0,800033fe <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    8000339c:	854a                	mv	a0,s2
    8000339e:	17a010ef          	jal	80004518 <releasesleep>

  acquire(&bcache.lock);
    800033a2:	00016517          	auipc	a0,0x16
    800033a6:	4be50513          	addi	a0,a0,1214 # 80019860 <bcache>
    800033aa:	84bfd0ef          	jal	80000bf4 <acquire>
  b->refcnt--;
    800033ae:	40bc                	lw	a5,64(s1)
    800033b0:	37fd                	addiw	a5,a5,-1
    800033b2:	0007871b          	sext.w	a4,a5
    800033b6:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800033b8:	e71d                	bnez	a4,800033e6 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800033ba:	68b8                	ld	a4,80(s1)
    800033bc:	64bc                	ld	a5,72(s1)
    800033be:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800033c0:	68b8                	ld	a4,80(s1)
    800033c2:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800033c4:	0001e797          	auipc	a5,0x1e
    800033c8:	49c78793          	addi	a5,a5,1180 # 80021860 <bcache+0x8000>
    800033cc:	2b87b703          	ld	a4,696(a5)
    800033d0:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800033d2:	0001e717          	auipc	a4,0x1e
    800033d6:	6f670713          	addi	a4,a4,1782 # 80021ac8 <bcache+0x8268>
    800033da:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800033dc:	2b87b703          	ld	a4,696(a5)
    800033e0:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800033e2:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800033e6:	00016517          	auipc	a0,0x16
    800033ea:	47a50513          	addi	a0,a0,1146 # 80019860 <bcache>
    800033ee:	89ffd0ef          	jal	80000c8c <release>
}
    800033f2:	60e2                	ld	ra,24(sp)
    800033f4:	6442                	ld	s0,16(sp)
    800033f6:	64a2                	ld	s1,8(sp)
    800033f8:	6902                	ld	s2,0(sp)
    800033fa:	6105                	addi	sp,sp,32
    800033fc:	8082                	ret
    panic("brelse");
    800033fe:	00005517          	auipc	a0,0x5
    80003402:	10250513          	addi	a0,a0,258 # 80008500 <etext+0x500>
    80003406:	b8efd0ef          	jal	80000794 <panic>

000000008000340a <bpin>:

void
bpin(struct buf *b) {
    8000340a:	1101                	addi	sp,sp,-32
    8000340c:	ec06                	sd	ra,24(sp)
    8000340e:	e822                	sd	s0,16(sp)
    80003410:	e426                	sd	s1,8(sp)
    80003412:	1000                	addi	s0,sp,32
    80003414:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003416:	00016517          	auipc	a0,0x16
    8000341a:	44a50513          	addi	a0,a0,1098 # 80019860 <bcache>
    8000341e:	fd6fd0ef          	jal	80000bf4 <acquire>
  b->refcnt++;
    80003422:	40bc                	lw	a5,64(s1)
    80003424:	2785                	addiw	a5,a5,1
    80003426:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003428:	00016517          	auipc	a0,0x16
    8000342c:	43850513          	addi	a0,a0,1080 # 80019860 <bcache>
    80003430:	85dfd0ef          	jal	80000c8c <release>
}
    80003434:	60e2                	ld	ra,24(sp)
    80003436:	6442                	ld	s0,16(sp)
    80003438:	64a2                	ld	s1,8(sp)
    8000343a:	6105                	addi	sp,sp,32
    8000343c:	8082                	ret

000000008000343e <bunpin>:

void
bunpin(struct buf *b) {
    8000343e:	1101                	addi	sp,sp,-32
    80003440:	ec06                	sd	ra,24(sp)
    80003442:	e822                	sd	s0,16(sp)
    80003444:	e426                	sd	s1,8(sp)
    80003446:	1000                	addi	s0,sp,32
    80003448:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000344a:	00016517          	auipc	a0,0x16
    8000344e:	41650513          	addi	a0,a0,1046 # 80019860 <bcache>
    80003452:	fa2fd0ef          	jal	80000bf4 <acquire>
  b->refcnt--;
    80003456:	40bc                	lw	a5,64(s1)
    80003458:	37fd                	addiw	a5,a5,-1
    8000345a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000345c:	00016517          	auipc	a0,0x16
    80003460:	40450513          	addi	a0,a0,1028 # 80019860 <bcache>
    80003464:	829fd0ef          	jal	80000c8c <release>
}
    80003468:	60e2                	ld	ra,24(sp)
    8000346a:	6442                	ld	s0,16(sp)
    8000346c:	64a2                	ld	s1,8(sp)
    8000346e:	6105                	addi	sp,sp,32
    80003470:	8082                	ret

0000000080003472 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003472:	1101                	addi	sp,sp,-32
    80003474:	ec06                	sd	ra,24(sp)
    80003476:	e822                	sd	s0,16(sp)
    80003478:	e426                	sd	s1,8(sp)
    8000347a:	e04a                	sd	s2,0(sp)
    8000347c:	1000                	addi	s0,sp,32
    8000347e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003480:	00d5d59b          	srliw	a1,a1,0xd
    80003484:	0001f797          	auipc	a5,0x1f
    80003488:	ab87a783          	lw	a5,-1352(a5) # 80021f3c <sb+0x1c>
    8000348c:	9dbd                	addw	a1,a1,a5
    8000348e:	dedff0ef          	jal	8000327a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003492:	0074f713          	andi	a4,s1,7
    80003496:	4785                	li	a5,1
    80003498:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000349c:	14ce                	slli	s1,s1,0x33
    8000349e:	90d9                	srli	s1,s1,0x36
    800034a0:	00950733          	add	a4,a0,s1
    800034a4:	05874703          	lbu	a4,88(a4)
    800034a8:	00e7f6b3          	and	a3,a5,a4
    800034ac:	c29d                	beqz	a3,800034d2 <bfree+0x60>
    800034ae:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800034b0:	94aa                	add	s1,s1,a0
    800034b2:	fff7c793          	not	a5,a5
    800034b6:	8f7d                	and	a4,a4,a5
    800034b8:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800034bc:	711000ef          	jal	800043cc <log_write>
  brelse(bp);
    800034c0:	854a                	mv	a0,s2
    800034c2:	ec1ff0ef          	jal	80003382 <brelse>
}
    800034c6:	60e2                	ld	ra,24(sp)
    800034c8:	6442                	ld	s0,16(sp)
    800034ca:	64a2                	ld	s1,8(sp)
    800034cc:	6902                	ld	s2,0(sp)
    800034ce:	6105                	addi	sp,sp,32
    800034d0:	8082                	ret
    panic("freeing free block");
    800034d2:	00005517          	auipc	a0,0x5
    800034d6:	03650513          	addi	a0,a0,54 # 80008508 <etext+0x508>
    800034da:	abafd0ef          	jal	80000794 <panic>

00000000800034de <balloc>:
{
    800034de:	711d                	addi	sp,sp,-96
    800034e0:	ec86                	sd	ra,88(sp)
    800034e2:	e8a2                	sd	s0,80(sp)
    800034e4:	e4a6                	sd	s1,72(sp)
    800034e6:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800034e8:	0001f797          	auipc	a5,0x1f
    800034ec:	a3c7a783          	lw	a5,-1476(a5) # 80021f24 <sb+0x4>
    800034f0:	0e078f63          	beqz	a5,800035ee <balloc+0x110>
    800034f4:	e0ca                	sd	s2,64(sp)
    800034f6:	fc4e                	sd	s3,56(sp)
    800034f8:	f852                	sd	s4,48(sp)
    800034fa:	f456                	sd	s5,40(sp)
    800034fc:	f05a                	sd	s6,32(sp)
    800034fe:	ec5e                	sd	s7,24(sp)
    80003500:	e862                	sd	s8,16(sp)
    80003502:	e466                	sd	s9,8(sp)
    80003504:	8baa                	mv	s7,a0
    80003506:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003508:	0001fb17          	auipc	s6,0x1f
    8000350c:	a18b0b13          	addi	s6,s6,-1512 # 80021f20 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003510:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003512:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003514:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003516:	6c89                	lui	s9,0x2
    80003518:	a0b5                	j	80003584 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000351a:	97ca                	add	a5,a5,s2
    8000351c:	8e55                	or	a2,a2,a3
    8000351e:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003522:	854a                	mv	a0,s2
    80003524:	6a9000ef          	jal	800043cc <log_write>
        brelse(bp);
    80003528:	854a                	mv	a0,s2
    8000352a:	e59ff0ef          	jal	80003382 <brelse>
  bp = bread(dev, bno);
    8000352e:	85a6                	mv	a1,s1
    80003530:	855e                	mv	a0,s7
    80003532:	d49ff0ef          	jal	8000327a <bread>
    80003536:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003538:	40000613          	li	a2,1024
    8000353c:	4581                	li	a1,0
    8000353e:	05850513          	addi	a0,a0,88
    80003542:	f86fd0ef          	jal	80000cc8 <memset>
  log_write(bp);
    80003546:	854a                	mv	a0,s2
    80003548:	685000ef          	jal	800043cc <log_write>
  brelse(bp);
    8000354c:	854a                	mv	a0,s2
    8000354e:	e35ff0ef          	jal	80003382 <brelse>
}
    80003552:	6906                	ld	s2,64(sp)
    80003554:	79e2                	ld	s3,56(sp)
    80003556:	7a42                	ld	s4,48(sp)
    80003558:	7aa2                	ld	s5,40(sp)
    8000355a:	7b02                	ld	s6,32(sp)
    8000355c:	6be2                	ld	s7,24(sp)
    8000355e:	6c42                	ld	s8,16(sp)
    80003560:	6ca2                	ld	s9,8(sp)
}
    80003562:	8526                	mv	a0,s1
    80003564:	60e6                	ld	ra,88(sp)
    80003566:	6446                	ld	s0,80(sp)
    80003568:	64a6                	ld	s1,72(sp)
    8000356a:	6125                	addi	sp,sp,96
    8000356c:	8082                	ret
    brelse(bp);
    8000356e:	854a                	mv	a0,s2
    80003570:	e13ff0ef          	jal	80003382 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003574:	015c87bb          	addw	a5,s9,s5
    80003578:	00078a9b          	sext.w	s5,a5
    8000357c:	004b2703          	lw	a4,4(s6)
    80003580:	04eaff63          	bgeu	s5,a4,800035de <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80003584:	41fad79b          	sraiw	a5,s5,0x1f
    80003588:	0137d79b          	srliw	a5,a5,0x13
    8000358c:	015787bb          	addw	a5,a5,s5
    80003590:	40d7d79b          	sraiw	a5,a5,0xd
    80003594:	01cb2583          	lw	a1,28(s6)
    80003598:	9dbd                	addw	a1,a1,a5
    8000359a:	855e                	mv	a0,s7
    8000359c:	cdfff0ef          	jal	8000327a <bread>
    800035a0:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800035a2:	004b2503          	lw	a0,4(s6)
    800035a6:	000a849b          	sext.w	s1,s5
    800035aa:	8762                	mv	a4,s8
    800035ac:	fca4f1e3          	bgeu	s1,a0,8000356e <balloc+0x90>
      m = 1 << (bi % 8);
    800035b0:	00777693          	andi	a3,a4,7
    800035b4:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800035b8:	41f7579b          	sraiw	a5,a4,0x1f
    800035bc:	01d7d79b          	srliw	a5,a5,0x1d
    800035c0:	9fb9                	addw	a5,a5,a4
    800035c2:	4037d79b          	sraiw	a5,a5,0x3
    800035c6:	00f90633          	add	a2,s2,a5
    800035ca:	05864603          	lbu	a2,88(a2)
    800035ce:	00c6f5b3          	and	a1,a3,a2
    800035d2:	d5a1                	beqz	a1,8000351a <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800035d4:	2705                	addiw	a4,a4,1
    800035d6:	2485                	addiw	s1,s1,1
    800035d8:	fd471ae3          	bne	a4,s4,800035ac <balloc+0xce>
    800035dc:	bf49                	j	8000356e <balloc+0x90>
    800035de:	6906                	ld	s2,64(sp)
    800035e0:	79e2                	ld	s3,56(sp)
    800035e2:	7a42                	ld	s4,48(sp)
    800035e4:	7aa2                	ld	s5,40(sp)
    800035e6:	7b02                	ld	s6,32(sp)
    800035e8:	6be2                	ld	s7,24(sp)
    800035ea:	6c42                	ld	s8,16(sp)
    800035ec:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    800035ee:	00005517          	auipc	a0,0x5
    800035f2:	f3250513          	addi	a0,a0,-206 # 80008520 <etext+0x520>
    800035f6:	ecdfc0ef          	jal	800004c2 <printf>
  return 0;
    800035fa:	4481                	li	s1,0
    800035fc:	b79d                	j	80003562 <balloc+0x84>

00000000800035fe <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800035fe:	7179                	addi	sp,sp,-48
    80003600:	f406                	sd	ra,40(sp)
    80003602:	f022                	sd	s0,32(sp)
    80003604:	ec26                	sd	s1,24(sp)
    80003606:	e84a                	sd	s2,16(sp)
    80003608:	e44e                	sd	s3,8(sp)
    8000360a:	1800                	addi	s0,sp,48
    8000360c:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000360e:	47ad                	li	a5,11
    80003610:	02b7e663          	bltu	a5,a1,8000363c <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80003614:	02059793          	slli	a5,a1,0x20
    80003618:	01e7d593          	srli	a1,a5,0x1e
    8000361c:	00b504b3          	add	s1,a0,a1
    80003620:	0504a903          	lw	s2,80(s1)
    80003624:	06091a63          	bnez	s2,80003698 <bmap+0x9a>
      addr = balloc(ip->dev);
    80003628:	4108                	lw	a0,0(a0)
    8000362a:	eb5ff0ef          	jal	800034de <balloc>
    8000362e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003632:	06090363          	beqz	s2,80003698 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80003636:	0524a823          	sw	s2,80(s1)
    8000363a:	a8b9                	j	80003698 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000363c:	ff45849b          	addiw	s1,a1,-12
    80003640:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003644:	0ff00793          	li	a5,255
    80003648:	06e7ee63          	bltu	a5,a4,800036c4 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000364c:	08052903          	lw	s2,128(a0)
    80003650:	00091d63          	bnez	s2,8000366a <bmap+0x6c>
      addr = balloc(ip->dev);
    80003654:	4108                	lw	a0,0(a0)
    80003656:	e89ff0ef          	jal	800034de <balloc>
    8000365a:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000365e:	02090d63          	beqz	s2,80003698 <bmap+0x9a>
    80003662:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003664:	0929a023          	sw	s2,128(s3)
    80003668:	a011                	j	8000366c <bmap+0x6e>
    8000366a:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    8000366c:	85ca                	mv	a1,s2
    8000366e:	0009a503          	lw	a0,0(s3)
    80003672:	c09ff0ef          	jal	8000327a <bread>
    80003676:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003678:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000367c:	02049713          	slli	a4,s1,0x20
    80003680:	01e75593          	srli	a1,a4,0x1e
    80003684:	00b784b3          	add	s1,a5,a1
    80003688:	0004a903          	lw	s2,0(s1)
    8000368c:	00090e63          	beqz	s2,800036a8 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003690:	8552                	mv	a0,s4
    80003692:	cf1ff0ef          	jal	80003382 <brelse>
    return addr;
    80003696:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003698:	854a                	mv	a0,s2
    8000369a:	70a2                	ld	ra,40(sp)
    8000369c:	7402                	ld	s0,32(sp)
    8000369e:	64e2                	ld	s1,24(sp)
    800036a0:	6942                	ld	s2,16(sp)
    800036a2:	69a2                	ld	s3,8(sp)
    800036a4:	6145                	addi	sp,sp,48
    800036a6:	8082                	ret
      addr = balloc(ip->dev);
    800036a8:	0009a503          	lw	a0,0(s3)
    800036ac:	e33ff0ef          	jal	800034de <balloc>
    800036b0:	0005091b          	sext.w	s2,a0
      if(addr){
    800036b4:	fc090ee3          	beqz	s2,80003690 <bmap+0x92>
        a[bn] = addr;
    800036b8:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800036bc:	8552                	mv	a0,s4
    800036be:	50f000ef          	jal	800043cc <log_write>
    800036c2:	b7f9                	j	80003690 <bmap+0x92>
    800036c4:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800036c6:	00005517          	auipc	a0,0x5
    800036ca:	e7250513          	addi	a0,a0,-398 # 80008538 <etext+0x538>
    800036ce:	8c6fd0ef          	jal	80000794 <panic>

00000000800036d2 <iget>:
{
    800036d2:	7179                	addi	sp,sp,-48
    800036d4:	f406                	sd	ra,40(sp)
    800036d6:	f022                	sd	s0,32(sp)
    800036d8:	ec26                	sd	s1,24(sp)
    800036da:	e84a                	sd	s2,16(sp)
    800036dc:	e44e                	sd	s3,8(sp)
    800036de:	e052                	sd	s4,0(sp)
    800036e0:	1800                	addi	s0,sp,48
    800036e2:	89aa                	mv	s3,a0
    800036e4:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800036e6:	0001f517          	auipc	a0,0x1f
    800036ea:	85a50513          	addi	a0,a0,-1958 # 80021f40 <itable>
    800036ee:	d06fd0ef          	jal	80000bf4 <acquire>
  empty = 0;
    800036f2:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800036f4:	0001f497          	auipc	s1,0x1f
    800036f8:	86448493          	addi	s1,s1,-1948 # 80021f58 <itable+0x18>
    800036fc:	00020697          	auipc	a3,0x20
    80003700:	2ec68693          	addi	a3,a3,748 # 800239e8 <log>
    80003704:	a039                	j	80003712 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003706:	02090963          	beqz	s2,80003738 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000370a:	08848493          	addi	s1,s1,136
    8000370e:	02d48863          	beq	s1,a3,8000373e <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003712:	449c                	lw	a5,8(s1)
    80003714:	fef059e3          	blez	a5,80003706 <iget+0x34>
    80003718:	4098                	lw	a4,0(s1)
    8000371a:	ff3716e3          	bne	a4,s3,80003706 <iget+0x34>
    8000371e:	40d8                	lw	a4,4(s1)
    80003720:	ff4713e3          	bne	a4,s4,80003706 <iget+0x34>
      ip->ref++;
    80003724:	2785                	addiw	a5,a5,1
    80003726:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003728:	0001f517          	auipc	a0,0x1f
    8000372c:	81850513          	addi	a0,a0,-2024 # 80021f40 <itable>
    80003730:	d5cfd0ef          	jal	80000c8c <release>
      return ip;
    80003734:	8926                	mv	s2,s1
    80003736:	a02d                	j	80003760 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003738:	fbe9                	bnez	a5,8000370a <iget+0x38>
      empty = ip;
    8000373a:	8926                	mv	s2,s1
    8000373c:	b7f9                	j	8000370a <iget+0x38>
  if(empty == 0)
    8000373e:	02090a63          	beqz	s2,80003772 <iget+0xa0>
  ip->dev = dev;
    80003742:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003746:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000374a:	4785                	li	a5,1
    8000374c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003750:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003754:	0001e517          	auipc	a0,0x1e
    80003758:	7ec50513          	addi	a0,a0,2028 # 80021f40 <itable>
    8000375c:	d30fd0ef          	jal	80000c8c <release>
}
    80003760:	854a                	mv	a0,s2
    80003762:	70a2                	ld	ra,40(sp)
    80003764:	7402                	ld	s0,32(sp)
    80003766:	64e2                	ld	s1,24(sp)
    80003768:	6942                	ld	s2,16(sp)
    8000376a:	69a2                	ld	s3,8(sp)
    8000376c:	6a02                	ld	s4,0(sp)
    8000376e:	6145                	addi	sp,sp,48
    80003770:	8082                	ret
    panic("iget: no inodes");
    80003772:	00005517          	auipc	a0,0x5
    80003776:	dde50513          	addi	a0,a0,-546 # 80008550 <etext+0x550>
    8000377a:	81afd0ef          	jal	80000794 <panic>

000000008000377e <fsinit>:
fsinit(int dev) {
    8000377e:	7179                	addi	sp,sp,-48
    80003780:	f406                	sd	ra,40(sp)
    80003782:	f022                	sd	s0,32(sp)
    80003784:	ec26                	sd	s1,24(sp)
    80003786:	e84a                	sd	s2,16(sp)
    80003788:	e44e                	sd	s3,8(sp)
    8000378a:	1800                	addi	s0,sp,48
    8000378c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000378e:	4585                	li	a1,1
    80003790:	aebff0ef          	jal	8000327a <bread>
    80003794:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003796:	0001e997          	auipc	s3,0x1e
    8000379a:	78a98993          	addi	s3,s3,1930 # 80021f20 <sb>
    8000379e:	02000613          	li	a2,32
    800037a2:	05850593          	addi	a1,a0,88
    800037a6:	854e                	mv	a0,s3
    800037a8:	d7cfd0ef          	jal	80000d24 <memmove>
  brelse(bp);
    800037ac:	8526                	mv	a0,s1
    800037ae:	bd5ff0ef          	jal	80003382 <brelse>
  if(sb.magic != FSMAGIC)
    800037b2:	0009a703          	lw	a4,0(s3)
    800037b6:	102037b7          	lui	a5,0x10203
    800037ba:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800037be:	02f71063          	bne	a4,a5,800037de <fsinit+0x60>
  initlog(dev, &sb);
    800037c2:	0001e597          	auipc	a1,0x1e
    800037c6:	75e58593          	addi	a1,a1,1886 # 80021f20 <sb>
    800037ca:	854a                	mv	a0,s2
    800037cc:	1f9000ef          	jal	800041c4 <initlog>
}
    800037d0:	70a2                	ld	ra,40(sp)
    800037d2:	7402                	ld	s0,32(sp)
    800037d4:	64e2                	ld	s1,24(sp)
    800037d6:	6942                	ld	s2,16(sp)
    800037d8:	69a2                	ld	s3,8(sp)
    800037da:	6145                	addi	sp,sp,48
    800037dc:	8082                	ret
    panic("invalid file system");
    800037de:	00005517          	auipc	a0,0x5
    800037e2:	d8250513          	addi	a0,a0,-638 # 80008560 <etext+0x560>
    800037e6:	faffc0ef          	jal	80000794 <panic>

00000000800037ea <iinit>:
{
    800037ea:	7179                	addi	sp,sp,-48
    800037ec:	f406                	sd	ra,40(sp)
    800037ee:	f022                	sd	s0,32(sp)
    800037f0:	ec26                	sd	s1,24(sp)
    800037f2:	e84a                	sd	s2,16(sp)
    800037f4:	e44e                	sd	s3,8(sp)
    800037f6:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800037f8:	00005597          	auipc	a1,0x5
    800037fc:	d8058593          	addi	a1,a1,-640 # 80008578 <etext+0x578>
    80003800:	0001e517          	auipc	a0,0x1e
    80003804:	74050513          	addi	a0,a0,1856 # 80021f40 <itable>
    80003808:	b6cfd0ef          	jal	80000b74 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000380c:	0001e497          	auipc	s1,0x1e
    80003810:	75c48493          	addi	s1,s1,1884 # 80021f68 <itable+0x28>
    80003814:	00020997          	auipc	s3,0x20
    80003818:	1e498993          	addi	s3,s3,484 # 800239f8 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000381c:	00005917          	auipc	s2,0x5
    80003820:	d6490913          	addi	s2,s2,-668 # 80008580 <etext+0x580>
    80003824:	85ca                	mv	a1,s2
    80003826:	8526                	mv	a0,s1
    80003828:	475000ef          	jal	8000449c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000382c:	08848493          	addi	s1,s1,136
    80003830:	ff349ae3          	bne	s1,s3,80003824 <iinit+0x3a>
}
    80003834:	70a2                	ld	ra,40(sp)
    80003836:	7402                	ld	s0,32(sp)
    80003838:	64e2                	ld	s1,24(sp)
    8000383a:	6942                	ld	s2,16(sp)
    8000383c:	69a2                	ld	s3,8(sp)
    8000383e:	6145                	addi	sp,sp,48
    80003840:	8082                	ret

0000000080003842 <ialloc>:
{
    80003842:	7139                	addi	sp,sp,-64
    80003844:	fc06                	sd	ra,56(sp)
    80003846:	f822                	sd	s0,48(sp)
    80003848:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    8000384a:	0001e717          	auipc	a4,0x1e
    8000384e:	6e272703          	lw	a4,1762(a4) # 80021f2c <sb+0xc>
    80003852:	4785                	li	a5,1
    80003854:	06e7f063          	bgeu	a5,a4,800038b4 <ialloc+0x72>
    80003858:	f426                	sd	s1,40(sp)
    8000385a:	f04a                	sd	s2,32(sp)
    8000385c:	ec4e                	sd	s3,24(sp)
    8000385e:	e852                	sd	s4,16(sp)
    80003860:	e456                	sd	s5,8(sp)
    80003862:	e05a                	sd	s6,0(sp)
    80003864:	8aaa                	mv	s5,a0
    80003866:	8b2e                	mv	s6,a1
    80003868:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000386a:	0001ea17          	auipc	s4,0x1e
    8000386e:	6b6a0a13          	addi	s4,s4,1718 # 80021f20 <sb>
    80003872:	00495593          	srli	a1,s2,0x4
    80003876:	018a2783          	lw	a5,24(s4)
    8000387a:	9dbd                	addw	a1,a1,a5
    8000387c:	8556                	mv	a0,s5
    8000387e:	9fdff0ef          	jal	8000327a <bread>
    80003882:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003884:	05850993          	addi	s3,a0,88
    80003888:	00f97793          	andi	a5,s2,15
    8000388c:	079a                	slli	a5,a5,0x6
    8000388e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003890:	00099783          	lh	a5,0(s3)
    80003894:	cb9d                	beqz	a5,800038ca <ialloc+0x88>
    brelse(bp);
    80003896:	aedff0ef          	jal	80003382 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000389a:	0905                	addi	s2,s2,1
    8000389c:	00ca2703          	lw	a4,12(s4)
    800038a0:	0009079b          	sext.w	a5,s2
    800038a4:	fce7e7e3          	bltu	a5,a4,80003872 <ialloc+0x30>
    800038a8:	74a2                	ld	s1,40(sp)
    800038aa:	7902                	ld	s2,32(sp)
    800038ac:	69e2                	ld	s3,24(sp)
    800038ae:	6a42                	ld	s4,16(sp)
    800038b0:	6aa2                	ld	s5,8(sp)
    800038b2:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800038b4:	00005517          	auipc	a0,0x5
    800038b8:	cd450513          	addi	a0,a0,-812 # 80008588 <etext+0x588>
    800038bc:	c07fc0ef          	jal	800004c2 <printf>
  return 0;
    800038c0:	4501                	li	a0,0
}
    800038c2:	70e2                	ld	ra,56(sp)
    800038c4:	7442                	ld	s0,48(sp)
    800038c6:	6121                	addi	sp,sp,64
    800038c8:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800038ca:	04000613          	li	a2,64
    800038ce:	4581                	li	a1,0
    800038d0:	854e                	mv	a0,s3
    800038d2:	bf6fd0ef          	jal	80000cc8 <memset>
      dip->type = type;
    800038d6:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800038da:	8526                	mv	a0,s1
    800038dc:	2f1000ef          	jal	800043cc <log_write>
      brelse(bp);
    800038e0:	8526                	mv	a0,s1
    800038e2:	aa1ff0ef          	jal	80003382 <brelse>
      return iget(dev, inum);
    800038e6:	0009059b          	sext.w	a1,s2
    800038ea:	8556                	mv	a0,s5
    800038ec:	de7ff0ef          	jal	800036d2 <iget>
    800038f0:	74a2                	ld	s1,40(sp)
    800038f2:	7902                	ld	s2,32(sp)
    800038f4:	69e2                	ld	s3,24(sp)
    800038f6:	6a42                	ld	s4,16(sp)
    800038f8:	6aa2                	ld	s5,8(sp)
    800038fa:	6b02                	ld	s6,0(sp)
    800038fc:	b7d9                	j	800038c2 <ialloc+0x80>

00000000800038fe <iupdate>:
{
    800038fe:	1101                	addi	sp,sp,-32
    80003900:	ec06                	sd	ra,24(sp)
    80003902:	e822                	sd	s0,16(sp)
    80003904:	e426                	sd	s1,8(sp)
    80003906:	e04a                	sd	s2,0(sp)
    80003908:	1000                	addi	s0,sp,32
    8000390a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000390c:	415c                	lw	a5,4(a0)
    8000390e:	0047d79b          	srliw	a5,a5,0x4
    80003912:	0001e597          	auipc	a1,0x1e
    80003916:	6265a583          	lw	a1,1574(a1) # 80021f38 <sb+0x18>
    8000391a:	9dbd                	addw	a1,a1,a5
    8000391c:	4108                	lw	a0,0(a0)
    8000391e:	95dff0ef          	jal	8000327a <bread>
    80003922:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003924:	05850793          	addi	a5,a0,88
    80003928:	40d8                	lw	a4,4(s1)
    8000392a:	8b3d                	andi	a4,a4,15
    8000392c:	071a                	slli	a4,a4,0x6
    8000392e:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003930:	04449703          	lh	a4,68(s1)
    80003934:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003938:	04649703          	lh	a4,70(s1)
    8000393c:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003940:	04849703          	lh	a4,72(s1)
    80003944:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003948:	04a49703          	lh	a4,74(s1)
    8000394c:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003950:	44f8                	lw	a4,76(s1)
    80003952:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003954:	03400613          	li	a2,52
    80003958:	05048593          	addi	a1,s1,80
    8000395c:	00c78513          	addi	a0,a5,12
    80003960:	bc4fd0ef          	jal	80000d24 <memmove>
  log_write(bp);
    80003964:	854a                	mv	a0,s2
    80003966:	267000ef          	jal	800043cc <log_write>
  brelse(bp);
    8000396a:	854a                	mv	a0,s2
    8000396c:	a17ff0ef          	jal	80003382 <brelse>
}
    80003970:	60e2                	ld	ra,24(sp)
    80003972:	6442                	ld	s0,16(sp)
    80003974:	64a2                	ld	s1,8(sp)
    80003976:	6902                	ld	s2,0(sp)
    80003978:	6105                	addi	sp,sp,32
    8000397a:	8082                	ret

000000008000397c <idup>:
{
    8000397c:	1101                	addi	sp,sp,-32
    8000397e:	ec06                	sd	ra,24(sp)
    80003980:	e822                	sd	s0,16(sp)
    80003982:	e426                	sd	s1,8(sp)
    80003984:	1000                	addi	s0,sp,32
    80003986:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003988:	0001e517          	auipc	a0,0x1e
    8000398c:	5b850513          	addi	a0,a0,1464 # 80021f40 <itable>
    80003990:	a64fd0ef          	jal	80000bf4 <acquire>
  ip->ref++;
    80003994:	449c                	lw	a5,8(s1)
    80003996:	2785                	addiw	a5,a5,1
    80003998:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000399a:	0001e517          	auipc	a0,0x1e
    8000399e:	5a650513          	addi	a0,a0,1446 # 80021f40 <itable>
    800039a2:	aeafd0ef          	jal	80000c8c <release>
}
    800039a6:	8526                	mv	a0,s1
    800039a8:	60e2                	ld	ra,24(sp)
    800039aa:	6442                	ld	s0,16(sp)
    800039ac:	64a2                	ld	s1,8(sp)
    800039ae:	6105                	addi	sp,sp,32
    800039b0:	8082                	ret

00000000800039b2 <ilock>:
{
    800039b2:	1101                	addi	sp,sp,-32
    800039b4:	ec06                	sd	ra,24(sp)
    800039b6:	e822                	sd	s0,16(sp)
    800039b8:	e426                	sd	s1,8(sp)
    800039ba:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800039bc:	cd19                	beqz	a0,800039da <ilock+0x28>
    800039be:	84aa                	mv	s1,a0
    800039c0:	451c                	lw	a5,8(a0)
    800039c2:	00f05c63          	blez	a5,800039da <ilock+0x28>
  acquiresleep(&ip->lock);
    800039c6:	0541                	addi	a0,a0,16
    800039c8:	30b000ef          	jal	800044d2 <acquiresleep>
  if(ip->valid == 0){
    800039cc:	40bc                	lw	a5,64(s1)
    800039ce:	cf89                	beqz	a5,800039e8 <ilock+0x36>
}
    800039d0:	60e2                	ld	ra,24(sp)
    800039d2:	6442                	ld	s0,16(sp)
    800039d4:	64a2                	ld	s1,8(sp)
    800039d6:	6105                	addi	sp,sp,32
    800039d8:	8082                	ret
    800039da:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800039dc:	00005517          	auipc	a0,0x5
    800039e0:	bc450513          	addi	a0,a0,-1084 # 800085a0 <etext+0x5a0>
    800039e4:	db1fc0ef          	jal	80000794 <panic>
    800039e8:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800039ea:	40dc                	lw	a5,4(s1)
    800039ec:	0047d79b          	srliw	a5,a5,0x4
    800039f0:	0001e597          	auipc	a1,0x1e
    800039f4:	5485a583          	lw	a1,1352(a1) # 80021f38 <sb+0x18>
    800039f8:	9dbd                	addw	a1,a1,a5
    800039fa:	4088                	lw	a0,0(s1)
    800039fc:	87fff0ef          	jal	8000327a <bread>
    80003a00:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003a02:	05850593          	addi	a1,a0,88
    80003a06:	40dc                	lw	a5,4(s1)
    80003a08:	8bbd                	andi	a5,a5,15
    80003a0a:	079a                	slli	a5,a5,0x6
    80003a0c:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003a0e:	00059783          	lh	a5,0(a1)
    80003a12:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003a16:	00259783          	lh	a5,2(a1)
    80003a1a:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003a1e:	00459783          	lh	a5,4(a1)
    80003a22:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003a26:	00659783          	lh	a5,6(a1)
    80003a2a:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003a2e:	459c                	lw	a5,8(a1)
    80003a30:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003a32:	03400613          	li	a2,52
    80003a36:	05b1                	addi	a1,a1,12
    80003a38:	05048513          	addi	a0,s1,80
    80003a3c:	ae8fd0ef          	jal	80000d24 <memmove>
    brelse(bp);
    80003a40:	854a                	mv	a0,s2
    80003a42:	941ff0ef          	jal	80003382 <brelse>
    ip->valid = 1;
    80003a46:	4785                	li	a5,1
    80003a48:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003a4a:	04449783          	lh	a5,68(s1)
    80003a4e:	c399                	beqz	a5,80003a54 <ilock+0xa2>
    80003a50:	6902                	ld	s2,0(sp)
    80003a52:	bfbd                	j	800039d0 <ilock+0x1e>
      panic("ilock: no type");
    80003a54:	00005517          	auipc	a0,0x5
    80003a58:	b5450513          	addi	a0,a0,-1196 # 800085a8 <etext+0x5a8>
    80003a5c:	d39fc0ef          	jal	80000794 <panic>

0000000080003a60 <iunlock>:
{
    80003a60:	1101                	addi	sp,sp,-32
    80003a62:	ec06                	sd	ra,24(sp)
    80003a64:	e822                	sd	s0,16(sp)
    80003a66:	e426                	sd	s1,8(sp)
    80003a68:	e04a                	sd	s2,0(sp)
    80003a6a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003a6c:	c505                	beqz	a0,80003a94 <iunlock+0x34>
    80003a6e:	84aa                	mv	s1,a0
    80003a70:	01050913          	addi	s2,a0,16
    80003a74:	854a                	mv	a0,s2
    80003a76:	2db000ef          	jal	80004550 <holdingsleep>
    80003a7a:	cd09                	beqz	a0,80003a94 <iunlock+0x34>
    80003a7c:	449c                	lw	a5,8(s1)
    80003a7e:	00f05b63          	blez	a5,80003a94 <iunlock+0x34>
  releasesleep(&ip->lock);
    80003a82:	854a                	mv	a0,s2
    80003a84:	295000ef          	jal	80004518 <releasesleep>
}
    80003a88:	60e2                	ld	ra,24(sp)
    80003a8a:	6442                	ld	s0,16(sp)
    80003a8c:	64a2                	ld	s1,8(sp)
    80003a8e:	6902                	ld	s2,0(sp)
    80003a90:	6105                	addi	sp,sp,32
    80003a92:	8082                	ret
    panic("iunlock");
    80003a94:	00005517          	auipc	a0,0x5
    80003a98:	b2450513          	addi	a0,a0,-1244 # 800085b8 <etext+0x5b8>
    80003a9c:	cf9fc0ef          	jal	80000794 <panic>

0000000080003aa0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003aa0:	7179                	addi	sp,sp,-48
    80003aa2:	f406                	sd	ra,40(sp)
    80003aa4:	f022                	sd	s0,32(sp)
    80003aa6:	ec26                	sd	s1,24(sp)
    80003aa8:	e84a                	sd	s2,16(sp)
    80003aaa:	e44e                	sd	s3,8(sp)
    80003aac:	1800                	addi	s0,sp,48
    80003aae:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003ab0:	05050493          	addi	s1,a0,80
    80003ab4:	08050913          	addi	s2,a0,128
    80003ab8:	a021                	j	80003ac0 <itrunc+0x20>
    80003aba:	0491                	addi	s1,s1,4
    80003abc:	01248b63          	beq	s1,s2,80003ad2 <itrunc+0x32>
    if(ip->addrs[i]){
    80003ac0:	408c                	lw	a1,0(s1)
    80003ac2:	dde5                	beqz	a1,80003aba <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003ac4:	0009a503          	lw	a0,0(s3)
    80003ac8:	9abff0ef          	jal	80003472 <bfree>
      ip->addrs[i] = 0;
    80003acc:	0004a023          	sw	zero,0(s1)
    80003ad0:	b7ed                	j	80003aba <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003ad2:	0809a583          	lw	a1,128(s3)
    80003ad6:	ed89                	bnez	a1,80003af0 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003ad8:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003adc:	854e                	mv	a0,s3
    80003ade:	e21ff0ef          	jal	800038fe <iupdate>
}
    80003ae2:	70a2                	ld	ra,40(sp)
    80003ae4:	7402                	ld	s0,32(sp)
    80003ae6:	64e2                	ld	s1,24(sp)
    80003ae8:	6942                	ld	s2,16(sp)
    80003aea:	69a2                	ld	s3,8(sp)
    80003aec:	6145                	addi	sp,sp,48
    80003aee:	8082                	ret
    80003af0:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003af2:	0009a503          	lw	a0,0(s3)
    80003af6:	f84ff0ef          	jal	8000327a <bread>
    80003afa:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003afc:	05850493          	addi	s1,a0,88
    80003b00:	45850913          	addi	s2,a0,1112
    80003b04:	a021                	j	80003b0c <itrunc+0x6c>
    80003b06:	0491                	addi	s1,s1,4
    80003b08:	01248963          	beq	s1,s2,80003b1a <itrunc+0x7a>
      if(a[j])
    80003b0c:	408c                	lw	a1,0(s1)
    80003b0e:	dde5                	beqz	a1,80003b06 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80003b10:	0009a503          	lw	a0,0(s3)
    80003b14:	95fff0ef          	jal	80003472 <bfree>
    80003b18:	b7fd                	j	80003b06 <itrunc+0x66>
    brelse(bp);
    80003b1a:	8552                	mv	a0,s4
    80003b1c:	867ff0ef          	jal	80003382 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003b20:	0809a583          	lw	a1,128(s3)
    80003b24:	0009a503          	lw	a0,0(s3)
    80003b28:	94bff0ef          	jal	80003472 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003b2c:	0809a023          	sw	zero,128(s3)
    80003b30:	6a02                	ld	s4,0(sp)
    80003b32:	b75d                	j	80003ad8 <itrunc+0x38>

0000000080003b34 <iput>:
{
    80003b34:	1101                	addi	sp,sp,-32
    80003b36:	ec06                	sd	ra,24(sp)
    80003b38:	e822                	sd	s0,16(sp)
    80003b3a:	e426                	sd	s1,8(sp)
    80003b3c:	1000                	addi	s0,sp,32
    80003b3e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003b40:	0001e517          	auipc	a0,0x1e
    80003b44:	40050513          	addi	a0,a0,1024 # 80021f40 <itable>
    80003b48:	8acfd0ef          	jal	80000bf4 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003b4c:	4498                	lw	a4,8(s1)
    80003b4e:	4785                	li	a5,1
    80003b50:	02f70063          	beq	a4,a5,80003b70 <iput+0x3c>
  ip->ref--;
    80003b54:	449c                	lw	a5,8(s1)
    80003b56:	37fd                	addiw	a5,a5,-1
    80003b58:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003b5a:	0001e517          	auipc	a0,0x1e
    80003b5e:	3e650513          	addi	a0,a0,998 # 80021f40 <itable>
    80003b62:	92afd0ef          	jal	80000c8c <release>
}
    80003b66:	60e2                	ld	ra,24(sp)
    80003b68:	6442                	ld	s0,16(sp)
    80003b6a:	64a2                	ld	s1,8(sp)
    80003b6c:	6105                	addi	sp,sp,32
    80003b6e:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003b70:	40bc                	lw	a5,64(s1)
    80003b72:	d3ed                	beqz	a5,80003b54 <iput+0x20>
    80003b74:	04a49783          	lh	a5,74(s1)
    80003b78:	fff1                	bnez	a5,80003b54 <iput+0x20>
    80003b7a:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003b7c:	01048913          	addi	s2,s1,16
    80003b80:	854a                	mv	a0,s2
    80003b82:	151000ef          	jal	800044d2 <acquiresleep>
    release(&itable.lock);
    80003b86:	0001e517          	auipc	a0,0x1e
    80003b8a:	3ba50513          	addi	a0,a0,954 # 80021f40 <itable>
    80003b8e:	8fefd0ef          	jal	80000c8c <release>
    itrunc(ip);
    80003b92:	8526                	mv	a0,s1
    80003b94:	f0dff0ef          	jal	80003aa0 <itrunc>
    ip->type = 0;
    80003b98:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003b9c:	8526                	mv	a0,s1
    80003b9e:	d61ff0ef          	jal	800038fe <iupdate>
    ip->valid = 0;
    80003ba2:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003ba6:	854a                	mv	a0,s2
    80003ba8:	171000ef          	jal	80004518 <releasesleep>
    acquire(&itable.lock);
    80003bac:	0001e517          	auipc	a0,0x1e
    80003bb0:	39450513          	addi	a0,a0,916 # 80021f40 <itable>
    80003bb4:	840fd0ef          	jal	80000bf4 <acquire>
    80003bb8:	6902                	ld	s2,0(sp)
    80003bba:	bf69                	j	80003b54 <iput+0x20>

0000000080003bbc <iunlockput>:
{
    80003bbc:	1101                	addi	sp,sp,-32
    80003bbe:	ec06                	sd	ra,24(sp)
    80003bc0:	e822                	sd	s0,16(sp)
    80003bc2:	e426                	sd	s1,8(sp)
    80003bc4:	1000                	addi	s0,sp,32
    80003bc6:	84aa                	mv	s1,a0
  iunlock(ip);
    80003bc8:	e99ff0ef          	jal	80003a60 <iunlock>
  iput(ip);
    80003bcc:	8526                	mv	a0,s1
    80003bce:	f67ff0ef          	jal	80003b34 <iput>
}
    80003bd2:	60e2                	ld	ra,24(sp)
    80003bd4:	6442                	ld	s0,16(sp)
    80003bd6:	64a2                	ld	s1,8(sp)
    80003bd8:	6105                	addi	sp,sp,32
    80003bda:	8082                	ret

0000000080003bdc <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003bdc:	1141                	addi	sp,sp,-16
    80003bde:	e422                	sd	s0,8(sp)
    80003be0:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003be2:	411c                	lw	a5,0(a0)
    80003be4:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003be6:	415c                	lw	a5,4(a0)
    80003be8:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003bea:	04451783          	lh	a5,68(a0)
    80003bee:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003bf2:	04a51783          	lh	a5,74(a0)
    80003bf6:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003bfa:	04c56783          	lwu	a5,76(a0)
    80003bfe:	e99c                	sd	a5,16(a1)
}
    80003c00:	6422                	ld	s0,8(sp)
    80003c02:	0141                	addi	sp,sp,16
    80003c04:	8082                	ret

0000000080003c06 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003c06:	457c                	lw	a5,76(a0)
    80003c08:	0ed7eb63          	bltu	a5,a3,80003cfe <readi+0xf8>
{
    80003c0c:	7159                	addi	sp,sp,-112
    80003c0e:	f486                	sd	ra,104(sp)
    80003c10:	f0a2                	sd	s0,96(sp)
    80003c12:	eca6                	sd	s1,88(sp)
    80003c14:	e0d2                	sd	s4,64(sp)
    80003c16:	fc56                	sd	s5,56(sp)
    80003c18:	f85a                	sd	s6,48(sp)
    80003c1a:	f45e                	sd	s7,40(sp)
    80003c1c:	1880                	addi	s0,sp,112
    80003c1e:	8b2a                	mv	s6,a0
    80003c20:	8bae                	mv	s7,a1
    80003c22:	8a32                	mv	s4,a2
    80003c24:	84b6                	mv	s1,a3
    80003c26:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003c28:	9f35                	addw	a4,a4,a3
    return 0;
    80003c2a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003c2c:	0cd76063          	bltu	a4,a3,80003cec <readi+0xe6>
    80003c30:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003c32:	00e7f463          	bgeu	a5,a4,80003c3a <readi+0x34>
    n = ip->size - off;
    80003c36:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003c3a:	080a8f63          	beqz	s5,80003cd8 <readi+0xd2>
    80003c3e:	e8ca                	sd	s2,80(sp)
    80003c40:	f062                	sd	s8,32(sp)
    80003c42:	ec66                	sd	s9,24(sp)
    80003c44:	e86a                	sd	s10,16(sp)
    80003c46:	e46e                	sd	s11,8(sp)
    80003c48:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003c4a:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003c4e:	5c7d                	li	s8,-1
    80003c50:	a80d                	j	80003c82 <readi+0x7c>
    80003c52:	020d1d93          	slli	s11,s10,0x20
    80003c56:	020ddd93          	srli	s11,s11,0x20
    80003c5a:	05890613          	addi	a2,s2,88
    80003c5e:	86ee                	mv	a3,s11
    80003c60:	963a                	add	a2,a2,a4
    80003c62:	85d2                	mv	a1,s4
    80003c64:	855e                	mv	a0,s7
    80003c66:	c04fe0ef          	jal	8000206a <either_copyout>
    80003c6a:	05850763          	beq	a0,s8,80003cb8 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003c6e:	854a                	mv	a0,s2
    80003c70:	f12ff0ef          	jal	80003382 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003c74:	013d09bb          	addw	s3,s10,s3
    80003c78:	009d04bb          	addw	s1,s10,s1
    80003c7c:	9a6e                	add	s4,s4,s11
    80003c7e:	0559f763          	bgeu	s3,s5,80003ccc <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80003c82:	00a4d59b          	srliw	a1,s1,0xa
    80003c86:	855a                	mv	a0,s6
    80003c88:	977ff0ef          	jal	800035fe <bmap>
    80003c8c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003c90:	c5b1                	beqz	a1,80003cdc <readi+0xd6>
    bp = bread(ip->dev, addr);
    80003c92:	000b2503          	lw	a0,0(s6)
    80003c96:	de4ff0ef          	jal	8000327a <bread>
    80003c9a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003c9c:	3ff4f713          	andi	a4,s1,1023
    80003ca0:	40ec87bb          	subw	a5,s9,a4
    80003ca4:	413a86bb          	subw	a3,s5,s3
    80003ca8:	8d3e                	mv	s10,a5
    80003caa:	2781                	sext.w	a5,a5
    80003cac:	0006861b          	sext.w	a2,a3
    80003cb0:	faf671e3          	bgeu	a2,a5,80003c52 <readi+0x4c>
    80003cb4:	8d36                	mv	s10,a3
    80003cb6:	bf71                	j	80003c52 <readi+0x4c>
      brelse(bp);
    80003cb8:	854a                	mv	a0,s2
    80003cba:	ec8ff0ef          	jal	80003382 <brelse>
      tot = -1;
    80003cbe:	59fd                	li	s3,-1
      break;
    80003cc0:	6946                	ld	s2,80(sp)
    80003cc2:	7c02                	ld	s8,32(sp)
    80003cc4:	6ce2                	ld	s9,24(sp)
    80003cc6:	6d42                	ld	s10,16(sp)
    80003cc8:	6da2                	ld	s11,8(sp)
    80003cca:	a831                	j	80003ce6 <readi+0xe0>
    80003ccc:	6946                	ld	s2,80(sp)
    80003cce:	7c02                	ld	s8,32(sp)
    80003cd0:	6ce2                	ld	s9,24(sp)
    80003cd2:	6d42                	ld	s10,16(sp)
    80003cd4:	6da2                	ld	s11,8(sp)
    80003cd6:	a801                	j	80003ce6 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003cd8:	89d6                	mv	s3,s5
    80003cda:	a031                	j	80003ce6 <readi+0xe0>
    80003cdc:	6946                	ld	s2,80(sp)
    80003cde:	7c02                	ld	s8,32(sp)
    80003ce0:	6ce2                	ld	s9,24(sp)
    80003ce2:	6d42                	ld	s10,16(sp)
    80003ce4:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003ce6:	0009851b          	sext.w	a0,s3
    80003cea:	69a6                	ld	s3,72(sp)
}
    80003cec:	70a6                	ld	ra,104(sp)
    80003cee:	7406                	ld	s0,96(sp)
    80003cf0:	64e6                	ld	s1,88(sp)
    80003cf2:	6a06                	ld	s4,64(sp)
    80003cf4:	7ae2                	ld	s5,56(sp)
    80003cf6:	7b42                	ld	s6,48(sp)
    80003cf8:	7ba2                	ld	s7,40(sp)
    80003cfa:	6165                	addi	sp,sp,112
    80003cfc:	8082                	ret
    return 0;
    80003cfe:	4501                	li	a0,0
}
    80003d00:	8082                	ret

0000000080003d02 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003d02:	457c                	lw	a5,76(a0)
    80003d04:	10d7e063          	bltu	a5,a3,80003e04 <writei+0x102>
{
    80003d08:	7159                	addi	sp,sp,-112
    80003d0a:	f486                	sd	ra,104(sp)
    80003d0c:	f0a2                	sd	s0,96(sp)
    80003d0e:	e8ca                	sd	s2,80(sp)
    80003d10:	e0d2                	sd	s4,64(sp)
    80003d12:	fc56                	sd	s5,56(sp)
    80003d14:	f85a                	sd	s6,48(sp)
    80003d16:	f45e                	sd	s7,40(sp)
    80003d18:	1880                	addi	s0,sp,112
    80003d1a:	8aaa                	mv	s5,a0
    80003d1c:	8bae                	mv	s7,a1
    80003d1e:	8a32                	mv	s4,a2
    80003d20:	8936                	mv	s2,a3
    80003d22:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003d24:	00e687bb          	addw	a5,a3,a4
    80003d28:	0ed7e063          	bltu	a5,a3,80003e08 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003d2c:	00043737          	lui	a4,0x43
    80003d30:	0cf76e63          	bltu	a4,a5,80003e0c <writei+0x10a>
    80003d34:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003d36:	0a0b0f63          	beqz	s6,80003df4 <writei+0xf2>
    80003d3a:	eca6                	sd	s1,88(sp)
    80003d3c:	f062                	sd	s8,32(sp)
    80003d3e:	ec66                	sd	s9,24(sp)
    80003d40:	e86a                	sd	s10,16(sp)
    80003d42:	e46e                	sd	s11,8(sp)
    80003d44:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003d46:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003d4a:	5c7d                	li	s8,-1
    80003d4c:	a825                	j	80003d84 <writei+0x82>
    80003d4e:	020d1d93          	slli	s11,s10,0x20
    80003d52:	020ddd93          	srli	s11,s11,0x20
    80003d56:	05848513          	addi	a0,s1,88
    80003d5a:	86ee                	mv	a3,s11
    80003d5c:	8652                	mv	a2,s4
    80003d5e:	85de                	mv	a1,s7
    80003d60:	953a                	add	a0,a0,a4
    80003d62:	b52fe0ef          	jal	800020b4 <either_copyin>
    80003d66:	05850a63          	beq	a0,s8,80003dba <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003d6a:	8526                	mv	a0,s1
    80003d6c:	660000ef          	jal	800043cc <log_write>
    brelse(bp);
    80003d70:	8526                	mv	a0,s1
    80003d72:	e10ff0ef          	jal	80003382 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003d76:	013d09bb          	addw	s3,s10,s3
    80003d7a:	012d093b          	addw	s2,s10,s2
    80003d7e:	9a6e                	add	s4,s4,s11
    80003d80:	0569f063          	bgeu	s3,s6,80003dc0 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80003d84:	00a9559b          	srliw	a1,s2,0xa
    80003d88:	8556                	mv	a0,s5
    80003d8a:	875ff0ef          	jal	800035fe <bmap>
    80003d8e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003d92:	c59d                	beqz	a1,80003dc0 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80003d94:	000aa503          	lw	a0,0(s5)
    80003d98:	ce2ff0ef          	jal	8000327a <bread>
    80003d9c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003d9e:	3ff97713          	andi	a4,s2,1023
    80003da2:	40ec87bb          	subw	a5,s9,a4
    80003da6:	413b06bb          	subw	a3,s6,s3
    80003daa:	8d3e                	mv	s10,a5
    80003dac:	2781                	sext.w	a5,a5
    80003dae:	0006861b          	sext.w	a2,a3
    80003db2:	f8f67ee3          	bgeu	a2,a5,80003d4e <writei+0x4c>
    80003db6:	8d36                	mv	s10,a3
    80003db8:	bf59                	j	80003d4e <writei+0x4c>
      brelse(bp);
    80003dba:	8526                	mv	a0,s1
    80003dbc:	dc6ff0ef          	jal	80003382 <brelse>
  }

  if(off > ip->size)
    80003dc0:	04caa783          	lw	a5,76(s5)
    80003dc4:	0327fa63          	bgeu	a5,s2,80003df8 <writei+0xf6>
    ip->size = off;
    80003dc8:	052aa623          	sw	s2,76(s5)
    80003dcc:	64e6                	ld	s1,88(sp)
    80003dce:	7c02                	ld	s8,32(sp)
    80003dd0:	6ce2                	ld	s9,24(sp)
    80003dd2:	6d42                	ld	s10,16(sp)
    80003dd4:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003dd6:	8556                	mv	a0,s5
    80003dd8:	b27ff0ef          	jal	800038fe <iupdate>

  return tot;
    80003ddc:	0009851b          	sext.w	a0,s3
    80003de0:	69a6                	ld	s3,72(sp)
}
    80003de2:	70a6                	ld	ra,104(sp)
    80003de4:	7406                	ld	s0,96(sp)
    80003de6:	6946                	ld	s2,80(sp)
    80003de8:	6a06                	ld	s4,64(sp)
    80003dea:	7ae2                	ld	s5,56(sp)
    80003dec:	7b42                	ld	s6,48(sp)
    80003dee:	7ba2                	ld	s7,40(sp)
    80003df0:	6165                	addi	sp,sp,112
    80003df2:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003df4:	89da                	mv	s3,s6
    80003df6:	b7c5                	j	80003dd6 <writei+0xd4>
    80003df8:	64e6                	ld	s1,88(sp)
    80003dfa:	7c02                	ld	s8,32(sp)
    80003dfc:	6ce2                	ld	s9,24(sp)
    80003dfe:	6d42                	ld	s10,16(sp)
    80003e00:	6da2                	ld	s11,8(sp)
    80003e02:	bfd1                	j	80003dd6 <writei+0xd4>
    return -1;
    80003e04:	557d                	li	a0,-1
}
    80003e06:	8082                	ret
    return -1;
    80003e08:	557d                	li	a0,-1
    80003e0a:	bfe1                	j	80003de2 <writei+0xe0>
    return -1;
    80003e0c:	557d                	li	a0,-1
    80003e0e:	bfd1                	j	80003de2 <writei+0xe0>

0000000080003e10 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003e10:	1141                	addi	sp,sp,-16
    80003e12:	e406                	sd	ra,8(sp)
    80003e14:	e022                	sd	s0,0(sp)
    80003e16:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003e18:	4639                	li	a2,14
    80003e1a:	f7bfc0ef          	jal	80000d94 <strncmp>
}
    80003e1e:	60a2                	ld	ra,8(sp)
    80003e20:	6402                	ld	s0,0(sp)
    80003e22:	0141                	addi	sp,sp,16
    80003e24:	8082                	ret

0000000080003e26 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003e26:	7139                	addi	sp,sp,-64
    80003e28:	fc06                	sd	ra,56(sp)
    80003e2a:	f822                	sd	s0,48(sp)
    80003e2c:	f426                	sd	s1,40(sp)
    80003e2e:	f04a                	sd	s2,32(sp)
    80003e30:	ec4e                	sd	s3,24(sp)
    80003e32:	e852                	sd	s4,16(sp)
    80003e34:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003e36:	04451703          	lh	a4,68(a0)
    80003e3a:	4785                	li	a5,1
    80003e3c:	00f71a63          	bne	a4,a5,80003e50 <dirlookup+0x2a>
    80003e40:	892a                	mv	s2,a0
    80003e42:	89ae                	mv	s3,a1
    80003e44:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e46:	457c                	lw	a5,76(a0)
    80003e48:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003e4a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e4c:	e39d                	bnez	a5,80003e72 <dirlookup+0x4c>
    80003e4e:	a095                	j	80003eb2 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80003e50:	00004517          	auipc	a0,0x4
    80003e54:	77050513          	addi	a0,a0,1904 # 800085c0 <etext+0x5c0>
    80003e58:	93dfc0ef          	jal	80000794 <panic>
      panic("dirlookup read");
    80003e5c:	00004517          	auipc	a0,0x4
    80003e60:	77c50513          	addi	a0,a0,1916 # 800085d8 <etext+0x5d8>
    80003e64:	931fc0ef          	jal	80000794 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e68:	24c1                	addiw	s1,s1,16
    80003e6a:	04c92783          	lw	a5,76(s2)
    80003e6e:	04f4f163          	bgeu	s1,a5,80003eb0 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e72:	4741                	li	a4,16
    80003e74:	86a6                	mv	a3,s1
    80003e76:	fc040613          	addi	a2,s0,-64
    80003e7a:	4581                	li	a1,0
    80003e7c:	854a                	mv	a0,s2
    80003e7e:	d89ff0ef          	jal	80003c06 <readi>
    80003e82:	47c1                	li	a5,16
    80003e84:	fcf51ce3          	bne	a0,a5,80003e5c <dirlookup+0x36>
    if(de.inum == 0)
    80003e88:	fc045783          	lhu	a5,-64(s0)
    80003e8c:	dff1                	beqz	a5,80003e68 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80003e8e:	fc240593          	addi	a1,s0,-62
    80003e92:	854e                	mv	a0,s3
    80003e94:	f7dff0ef          	jal	80003e10 <namecmp>
    80003e98:	f961                	bnez	a0,80003e68 <dirlookup+0x42>
      if(poff)
    80003e9a:	000a0463          	beqz	s4,80003ea2 <dirlookup+0x7c>
        *poff = off;
    80003e9e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003ea2:	fc045583          	lhu	a1,-64(s0)
    80003ea6:	00092503          	lw	a0,0(s2)
    80003eaa:	829ff0ef          	jal	800036d2 <iget>
    80003eae:	a011                	j	80003eb2 <dirlookup+0x8c>
  return 0;
    80003eb0:	4501                	li	a0,0
}
    80003eb2:	70e2                	ld	ra,56(sp)
    80003eb4:	7442                	ld	s0,48(sp)
    80003eb6:	74a2                	ld	s1,40(sp)
    80003eb8:	7902                	ld	s2,32(sp)
    80003eba:	69e2                	ld	s3,24(sp)
    80003ebc:	6a42                	ld	s4,16(sp)
    80003ebe:	6121                	addi	sp,sp,64
    80003ec0:	8082                	ret

0000000080003ec2 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003ec2:	711d                	addi	sp,sp,-96
    80003ec4:	ec86                	sd	ra,88(sp)
    80003ec6:	e8a2                	sd	s0,80(sp)
    80003ec8:	e4a6                	sd	s1,72(sp)
    80003eca:	e0ca                	sd	s2,64(sp)
    80003ecc:	fc4e                	sd	s3,56(sp)
    80003ece:	f852                	sd	s4,48(sp)
    80003ed0:	f456                	sd	s5,40(sp)
    80003ed2:	f05a                	sd	s6,32(sp)
    80003ed4:	ec5e                	sd	s7,24(sp)
    80003ed6:	e862                	sd	s8,16(sp)
    80003ed8:	e466                	sd	s9,8(sp)
    80003eda:	1080                	addi	s0,sp,96
    80003edc:	84aa                	mv	s1,a0
    80003ede:	8b2e                	mv	s6,a1
    80003ee0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003ee2:	00054703          	lbu	a4,0(a0)
    80003ee6:	02f00793          	li	a5,47
    80003eea:	00f70e63          	beq	a4,a5,80003f06 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003eee:	a41fd0ef          	jal	8000192e <myproc>
    80003ef2:	15853503          	ld	a0,344(a0)
    80003ef6:	a87ff0ef          	jal	8000397c <idup>
    80003efa:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003efc:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003f00:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003f02:	4b85                	li	s7,1
    80003f04:	a871                	j	80003fa0 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80003f06:	4585                	li	a1,1
    80003f08:	4505                	li	a0,1
    80003f0a:	fc8ff0ef          	jal	800036d2 <iget>
    80003f0e:	8a2a                	mv	s4,a0
    80003f10:	b7f5                	j	80003efc <namex+0x3a>
      iunlockput(ip);
    80003f12:	8552                	mv	a0,s4
    80003f14:	ca9ff0ef          	jal	80003bbc <iunlockput>
      return 0;
    80003f18:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003f1a:	8552                	mv	a0,s4
    80003f1c:	60e6                	ld	ra,88(sp)
    80003f1e:	6446                	ld	s0,80(sp)
    80003f20:	64a6                	ld	s1,72(sp)
    80003f22:	6906                	ld	s2,64(sp)
    80003f24:	79e2                	ld	s3,56(sp)
    80003f26:	7a42                	ld	s4,48(sp)
    80003f28:	7aa2                	ld	s5,40(sp)
    80003f2a:	7b02                	ld	s6,32(sp)
    80003f2c:	6be2                	ld	s7,24(sp)
    80003f2e:	6c42                	ld	s8,16(sp)
    80003f30:	6ca2                	ld	s9,8(sp)
    80003f32:	6125                	addi	sp,sp,96
    80003f34:	8082                	ret
      iunlock(ip);
    80003f36:	8552                	mv	a0,s4
    80003f38:	b29ff0ef          	jal	80003a60 <iunlock>
      return ip;
    80003f3c:	bff9                	j	80003f1a <namex+0x58>
      iunlockput(ip);
    80003f3e:	8552                	mv	a0,s4
    80003f40:	c7dff0ef          	jal	80003bbc <iunlockput>
      return 0;
    80003f44:	8a4e                	mv	s4,s3
    80003f46:	bfd1                	j	80003f1a <namex+0x58>
  len = path - s;
    80003f48:	40998633          	sub	a2,s3,s1
    80003f4c:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003f50:	099c5063          	bge	s8,s9,80003fd0 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80003f54:	4639                	li	a2,14
    80003f56:	85a6                	mv	a1,s1
    80003f58:	8556                	mv	a0,s5
    80003f5a:	dcbfc0ef          	jal	80000d24 <memmove>
    80003f5e:	84ce                	mv	s1,s3
  while(*path == '/')
    80003f60:	0004c783          	lbu	a5,0(s1)
    80003f64:	01279763          	bne	a5,s2,80003f72 <namex+0xb0>
    path++;
    80003f68:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003f6a:	0004c783          	lbu	a5,0(s1)
    80003f6e:	ff278de3          	beq	a5,s2,80003f68 <namex+0xa6>
    ilock(ip);
    80003f72:	8552                	mv	a0,s4
    80003f74:	a3fff0ef          	jal	800039b2 <ilock>
    if(ip->type != T_DIR){
    80003f78:	044a1783          	lh	a5,68(s4)
    80003f7c:	f9779be3          	bne	a5,s7,80003f12 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80003f80:	000b0563          	beqz	s6,80003f8a <namex+0xc8>
    80003f84:	0004c783          	lbu	a5,0(s1)
    80003f88:	d7dd                	beqz	a5,80003f36 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003f8a:	4601                	li	a2,0
    80003f8c:	85d6                	mv	a1,s5
    80003f8e:	8552                	mv	a0,s4
    80003f90:	e97ff0ef          	jal	80003e26 <dirlookup>
    80003f94:	89aa                	mv	s3,a0
    80003f96:	d545                	beqz	a0,80003f3e <namex+0x7c>
    iunlockput(ip);
    80003f98:	8552                	mv	a0,s4
    80003f9a:	c23ff0ef          	jal	80003bbc <iunlockput>
    ip = next;
    80003f9e:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003fa0:	0004c783          	lbu	a5,0(s1)
    80003fa4:	01279763          	bne	a5,s2,80003fb2 <namex+0xf0>
    path++;
    80003fa8:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003faa:	0004c783          	lbu	a5,0(s1)
    80003fae:	ff278de3          	beq	a5,s2,80003fa8 <namex+0xe6>
  if(*path == 0)
    80003fb2:	cb8d                	beqz	a5,80003fe4 <namex+0x122>
  while(*path != '/' && *path != 0)
    80003fb4:	0004c783          	lbu	a5,0(s1)
    80003fb8:	89a6                	mv	s3,s1
  len = path - s;
    80003fba:	4c81                	li	s9,0
    80003fbc:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003fbe:	01278963          	beq	a5,s2,80003fd0 <namex+0x10e>
    80003fc2:	d3d9                	beqz	a5,80003f48 <namex+0x86>
    path++;
    80003fc4:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003fc6:	0009c783          	lbu	a5,0(s3)
    80003fca:	ff279ce3          	bne	a5,s2,80003fc2 <namex+0x100>
    80003fce:	bfad                	j	80003f48 <namex+0x86>
    memmove(name, s, len);
    80003fd0:	2601                	sext.w	a2,a2
    80003fd2:	85a6                	mv	a1,s1
    80003fd4:	8556                	mv	a0,s5
    80003fd6:	d4ffc0ef          	jal	80000d24 <memmove>
    name[len] = 0;
    80003fda:	9cd6                	add	s9,s9,s5
    80003fdc:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003fe0:	84ce                	mv	s1,s3
    80003fe2:	bfbd                	j	80003f60 <namex+0x9e>
  if(nameiparent){
    80003fe4:	f20b0be3          	beqz	s6,80003f1a <namex+0x58>
    iput(ip);
    80003fe8:	8552                	mv	a0,s4
    80003fea:	b4bff0ef          	jal	80003b34 <iput>
    return 0;
    80003fee:	4a01                	li	s4,0
    80003ff0:	b72d                	j	80003f1a <namex+0x58>

0000000080003ff2 <dirlink>:
{
    80003ff2:	7139                	addi	sp,sp,-64
    80003ff4:	fc06                	sd	ra,56(sp)
    80003ff6:	f822                	sd	s0,48(sp)
    80003ff8:	f04a                	sd	s2,32(sp)
    80003ffa:	ec4e                	sd	s3,24(sp)
    80003ffc:	e852                	sd	s4,16(sp)
    80003ffe:	0080                	addi	s0,sp,64
    80004000:	892a                	mv	s2,a0
    80004002:	8a2e                	mv	s4,a1
    80004004:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004006:	4601                	li	a2,0
    80004008:	e1fff0ef          	jal	80003e26 <dirlookup>
    8000400c:	e535                	bnez	a0,80004078 <dirlink+0x86>
    8000400e:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004010:	04c92483          	lw	s1,76(s2)
    80004014:	c48d                	beqz	s1,8000403e <dirlink+0x4c>
    80004016:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004018:	4741                	li	a4,16
    8000401a:	86a6                	mv	a3,s1
    8000401c:	fc040613          	addi	a2,s0,-64
    80004020:	4581                	li	a1,0
    80004022:	854a                	mv	a0,s2
    80004024:	be3ff0ef          	jal	80003c06 <readi>
    80004028:	47c1                	li	a5,16
    8000402a:	04f51b63          	bne	a0,a5,80004080 <dirlink+0x8e>
    if(de.inum == 0)
    8000402e:	fc045783          	lhu	a5,-64(s0)
    80004032:	c791                	beqz	a5,8000403e <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004034:	24c1                	addiw	s1,s1,16
    80004036:	04c92783          	lw	a5,76(s2)
    8000403a:	fcf4efe3          	bltu	s1,a5,80004018 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    8000403e:	4639                	li	a2,14
    80004040:	85d2                	mv	a1,s4
    80004042:	fc240513          	addi	a0,s0,-62
    80004046:	d85fc0ef          	jal	80000dca <strncpy>
  de.inum = inum;
    8000404a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000404e:	4741                	li	a4,16
    80004050:	86a6                	mv	a3,s1
    80004052:	fc040613          	addi	a2,s0,-64
    80004056:	4581                	li	a1,0
    80004058:	854a                	mv	a0,s2
    8000405a:	ca9ff0ef          	jal	80003d02 <writei>
    8000405e:	1541                	addi	a0,a0,-16
    80004060:	00a03533          	snez	a0,a0
    80004064:	40a00533          	neg	a0,a0
    80004068:	74a2                	ld	s1,40(sp)
}
    8000406a:	70e2                	ld	ra,56(sp)
    8000406c:	7442                	ld	s0,48(sp)
    8000406e:	7902                	ld	s2,32(sp)
    80004070:	69e2                	ld	s3,24(sp)
    80004072:	6a42                	ld	s4,16(sp)
    80004074:	6121                	addi	sp,sp,64
    80004076:	8082                	ret
    iput(ip);
    80004078:	abdff0ef          	jal	80003b34 <iput>
    return -1;
    8000407c:	557d                	li	a0,-1
    8000407e:	b7f5                	j	8000406a <dirlink+0x78>
      panic("dirlink read");
    80004080:	00004517          	auipc	a0,0x4
    80004084:	56850513          	addi	a0,a0,1384 # 800085e8 <etext+0x5e8>
    80004088:	f0cfc0ef          	jal	80000794 <panic>

000000008000408c <namei>:

struct inode*
namei(char *path)
{
    8000408c:	1101                	addi	sp,sp,-32
    8000408e:	ec06                	sd	ra,24(sp)
    80004090:	e822                	sd	s0,16(sp)
    80004092:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004094:	fe040613          	addi	a2,s0,-32
    80004098:	4581                	li	a1,0
    8000409a:	e29ff0ef          	jal	80003ec2 <namex>
}
    8000409e:	60e2                	ld	ra,24(sp)
    800040a0:	6442                	ld	s0,16(sp)
    800040a2:	6105                	addi	sp,sp,32
    800040a4:	8082                	ret

00000000800040a6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800040a6:	1141                	addi	sp,sp,-16
    800040a8:	e406                	sd	ra,8(sp)
    800040aa:	e022                	sd	s0,0(sp)
    800040ac:	0800                	addi	s0,sp,16
    800040ae:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800040b0:	4585                	li	a1,1
    800040b2:	e11ff0ef          	jal	80003ec2 <namex>
}
    800040b6:	60a2                	ld	ra,8(sp)
    800040b8:	6402                	ld	s0,0(sp)
    800040ba:	0141                	addi	sp,sp,16
    800040bc:	8082                	ret

00000000800040be <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800040be:	1101                	addi	sp,sp,-32
    800040c0:	ec06                	sd	ra,24(sp)
    800040c2:	e822                	sd	s0,16(sp)
    800040c4:	e426                	sd	s1,8(sp)
    800040c6:	e04a                	sd	s2,0(sp)
    800040c8:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800040ca:	00020917          	auipc	s2,0x20
    800040ce:	91e90913          	addi	s2,s2,-1762 # 800239e8 <log>
    800040d2:	01892583          	lw	a1,24(s2)
    800040d6:	02892503          	lw	a0,40(s2)
    800040da:	9a0ff0ef          	jal	8000327a <bread>
    800040de:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800040e0:	02c92603          	lw	a2,44(s2)
    800040e4:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800040e6:	00c05f63          	blez	a2,80004104 <write_head+0x46>
    800040ea:	00020717          	auipc	a4,0x20
    800040ee:	92e70713          	addi	a4,a4,-1746 # 80023a18 <log+0x30>
    800040f2:	87aa                	mv	a5,a0
    800040f4:	060a                	slli	a2,a2,0x2
    800040f6:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800040f8:	4314                	lw	a3,0(a4)
    800040fa:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800040fc:	0711                	addi	a4,a4,4
    800040fe:	0791                	addi	a5,a5,4
    80004100:	fec79ce3          	bne	a5,a2,800040f8 <write_head+0x3a>
  }
  bwrite(buf);
    80004104:	8526                	mv	a0,s1
    80004106:	a4aff0ef          	jal	80003350 <bwrite>
  brelse(buf);
    8000410a:	8526                	mv	a0,s1
    8000410c:	a76ff0ef          	jal	80003382 <brelse>
}
    80004110:	60e2                	ld	ra,24(sp)
    80004112:	6442                	ld	s0,16(sp)
    80004114:	64a2                	ld	s1,8(sp)
    80004116:	6902                	ld	s2,0(sp)
    80004118:	6105                	addi	sp,sp,32
    8000411a:	8082                	ret

000000008000411c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000411c:	00020797          	auipc	a5,0x20
    80004120:	8f87a783          	lw	a5,-1800(a5) # 80023a14 <log+0x2c>
    80004124:	08f05f63          	blez	a5,800041c2 <install_trans+0xa6>
{
    80004128:	7139                	addi	sp,sp,-64
    8000412a:	fc06                	sd	ra,56(sp)
    8000412c:	f822                	sd	s0,48(sp)
    8000412e:	f426                	sd	s1,40(sp)
    80004130:	f04a                	sd	s2,32(sp)
    80004132:	ec4e                	sd	s3,24(sp)
    80004134:	e852                	sd	s4,16(sp)
    80004136:	e456                	sd	s5,8(sp)
    80004138:	e05a                	sd	s6,0(sp)
    8000413a:	0080                	addi	s0,sp,64
    8000413c:	8b2a                	mv	s6,a0
    8000413e:	00020a97          	auipc	s5,0x20
    80004142:	8daa8a93          	addi	s5,s5,-1830 # 80023a18 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004146:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004148:	00020997          	auipc	s3,0x20
    8000414c:	8a098993          	addi	s3,s3,-1888 # 800239e8 <log>
    80004150:	a829                	j	8000416a <install_trans+0x4e>
    brelse(lbuf);
    80004152:	854a                	mv	a0,s2
    80004154:	a2eff0ef          	jal	80003382 <brelse>
    brelse(dbuf);
    80004158:	8526                	mv	a0,s1
    8000415a:	a28ff0ef          	jal	80003382 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000415e:	2a05                	addiw	s4,s4,1
    80004160:	0a91                	addi	s5,s5,4
    80004162:	02c9a783          	lw	a5,44(s3)
    80004166:	04fa5463          	bge	s4,a5,800041ae <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000416a:	0189a583          	lw	a1,24(s3)
    8000416e:	014585bb          	addw	a1,a1,s4
    80004172:	2585                	addiw	a1,a1,1
    80004174:	0289a503          	lw	a0,40(s3)
    80004178:	902ff0ef          	jal	8000327a <bread>
    8000417c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000417e:	000aa583          	lw	a1,0(s5)
    80004182:	0289a503          	lw	a0,40(s3)
    80004186:	8f4ff0ef          	jal	8000327a <bread>
    8000418a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000418c:	40000613          	li	a2,1024
    80004190:	05890593          	addi	a1,s2,88
    80004194:	05850513          	addi	a0,a0,88
    80004198:	b8dfc0ef          	jal	80000d24 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000419c:	8526                	mv	a0,s1
    8000419e:	9b2ff0ef          	jal	80003350 <bwrite>
    if(recovering == 0)
    800041a2:	fa0b18e3          	bnez	s6,80004152 <install_trans+0x36>
      bunpin(dbuf);
    800041a6:	8526                	mv	a0,s1
    800041a8:	a96ff0ef          	jal	8000343e <bunpin>
    800041ac:	b75d                	j	80004152 <install_trans+0x36>
}
    800041ae:	70e2                	ld	ra,56(sp)
    800041b0:	7442                	ld	s0,48(sp)
    800041b2:	74a2                	ld	s1,40(sp)
    800041b4:	7902                	ld	s2,32(sp)
    800041b6:	69e2                	ld	s3,24(sp)
    800041b8:	6a42                	ld	s4,16(sp)
    800041ba:	6aa2                	ld	s5,8(sp)
    800041bc:	6b02                	ld	s6,0(sp)
    800041be:	6121                	addi	sp,sp,64
    800041c0:	8082                	ret
    800041c2:	8082                	ret

00000000800041c4 <initlog>:
{
    800041c4:	7179                	addi	sp,sp,-48
    800041c6:	f406                	sd	ra,40(sp)
    800041c8:	f022                	sd	s0,32(sp)
    800041ca:	ec26                	sd	s1,24(sp)
    800041cc:	e84a                	sd	s2,16(sp)
    800041ce:	e44e                	sd	s3,8(sp)
    800041d0:	1800                	addi	s0,sp,48
    800041d2:	892a                	mv	s2,a0
    800041d4:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800041d6:	00020497          	auipc	s1,0x20
    800041da:	81248493          	addi	s1,s1,-2030 # 800239e8 <log>
    800041de:	00004597          	auipc	a1,0x4
    800041e2:	41a58593          	addi	a1,a1,1050 # 800085f8 <etext+0x5f8>
    800041e6:	8526                	mv	a0,s1
    800041e8:	98dfc0ef          	jal	80000b74 <initlock>
  log.start = sb->logstart;
    800041ec:	0149a583          	lw	a1,20(s3)
    800041f0:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800041f2:	0109a783          	lw	a5,16(s3)
    800041f6:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800041f8:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800041fc:	854a                	mv	a0,s2
    800041fe:	87cff0ef          	jal	8000327a <bread>
  log.lh.n = lh->n;
    80004202:	4d30                	lw	a2,88(a0)
    80004204:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004206:	00c05f63          	blez	a2,80004224 <initlog+0x60>
    8000420a:	87aa                	mv	a5,a0
    8000420c:	00020717          	auipc	a4,0x20
    80004210:	80c70713          	addi	a4,a4,-2036 # 80023a18 <log+0x30>
    80004214:	060a                	slli	a2,a2,0x2
    80004216:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80004218:	4ff4                	lw	a3,92(a5)
    8000421a:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000421c:	0791                	addi	a5,a5,4
    8000421e:	0711                	addi	a4,a4,4
    80004220:	fec79ce3          	bne	a5,a2,80004218 <initlog+0x54>
  brelse(buf);
    80004224:	95eff0ef          	jal	80003382 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004228:	4505                	li	a0,1
    8000422a:	ef3ff0ef          	jal	8000411c <install_trans>
  log.lh.n = 0;
    8000422e:	0001f797          	auipc	a5,0x1f
    80004232:	7e07a323          	sw	zero,2022(a5) # 80023a14 <log+0x2c>
  write_head(); // clear the log
    80004236:	e89ff0ef          	jal	800040be <write_head>
}
    8000423a:	70a2                	ld	ra,40(sp)
    8000423c:	7402                	ld	s0,32(sp)
    8000423e:	64e2                	ld	s1,24(sp)
    80004240:	6942                	ld	s2,16(sp)
    80004242:	69a2                	ld	s3,8(sp)
    80004244:	6145                	addi	sp,sp,48
    80004246:	8082                	ret

0000000080004248 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004248:	1101                	addi	sp,sp,-32
    8000424a:	ec06                	sd	ra,24(sp)
    8000424c:	e822                	sd	s0,16(sp)
    8000424e:	e426                	sd	s1,8(sp)
    80004250:	e04a                	sd	s2,0(sp)
    80004252:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004254:	0001f517          	auipc	a0,0x1f
    80004258:	79450513          	addi	a0,a0,1940 # 800239e8 <log>
    8000425c:	999fc0ef          	jal	80000bf4 <acquire>
  while(1){
    if(log.committing){
    80004260:	0001f497          	auipc	s1,0x1f
    80004264:	78848493          	addi	s1,s1,1928 # 800239e8 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004268:	4979                	li	s2,30
    8000426a:	a029                	j	80004274 <begin_op+0x2c>
      sleep(&log, &log.lock);
    8000426c:	85a6                	mv	a1,s1
    8000426e:	8526                	mv	a0,s1
    80004270:	a9ffd0ef          	jal	80001d0e <sleep>
    if(log.committing){
    80004274:	50dc                	lw	a5,36(s1)
    80004276:	fbfd                	bnez	a5,8000426c <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004278:	5098                	lw	a4,32(s1)
    8000427a:	2705                	addiw	a4,a4,1
    8000427c:	0027179b          	slliw	a5,a4,0x2
    80004280:	9fb9                	addw	a5,a5,a4
    80004282:	0017979b          	slliw	a5,a5,0x1
    80004286:	54d4                	lw	a3,44(s1)
    80004288:	9fb5                	addw	a5,a5,a3
    8000428a:	00f95763          	bge	s2,a5,80004298 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000428e:	85a6                	mv	a1,s1
    80004290:	8526                	mv	a0,s1
    80004292:	a7dfd0ef          	jal	80001d0e <sleep>
    80004296:	bff9                	j	80004274 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80004298:	0001f517          	auipc	a0,0x1f
    8000429c:	75050513          	addi	a0,a0,1872 # 800239e8 <log>
    800042a0:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800042a2:	9ebfc0ef          	jal	80000c8c <release>
      break;
    }
  }
}
    800042a6:	60e2                	ld	ra,24(sp)
    800042a8:	6442                	ld	s0,16(sp)
    800042aa:	64a2                	ld	s1,8(sp)
    800042ac:	6902                	ld	s2,0(sp)
    800042ae:	6105                	addi	sp,sp,32
    800042b0:	8082                	ret

00000000800042b2 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800042b2:	7139                	addi	sp,sp,-64
    800042b4:	fc06                	sd	ra,56(sp)
    800042b6:	f822                	sd	s0,48(sp)
    800042b8:	f426                	sd	s1,40(sp)
    800042ba:	f04a                	sd	s2,32(sp)
    800042bc:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800042be:	0001f497          	auipc	s1,0x1f
    800042c2:	72a48493          	addi	s1,s1,1834 # 800239e8 <log>
    800042c6:	8526                	mv	a0,s1
    800042c8:	92dfc0ef          	jal	80000bf4 <acquire>
  log.outstanding -= 1;
    800042cc:	509c                	lw	a5,32(s1)
    800042ce:	37fd                	addiw	a5,a5,-1
    800042d0:	0007891b          	sext.w	s2,a5
    800042d4:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800042d6:	50dc                	lw	a5,36(s1)
    800042d8:	ef9d                	bnez	a5,80004316 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    800042da:	04091763          	bnez	s2,80004328 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    800042de:	0001f497          	auipc	s1,0x1f
    800042e2:	70a48493          	addi	s1,s1,1802 # 800239e8 <log>
    800042e6:	4785                	li	a5,1
    800042e8:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800042ea:	8526                	mv	a0,s1
    800042ec:	9a1fc0ef          	jal	80000c8c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800042f0:	54dc                	lw	a5,44(s1)
    800042f2:	04f04b63          	bgtz	a5,80004348 <end_op+0x96>
    acquire(&log.lock);
    800042f6:	0001f497          	auipc	s1,0x1f
    800042fa:	6f248493          	addi	s1,s1,1778 # 800239e8 <log>
    800042fe:	8526                	mv	a0,s1
    80004300:	8f5fc0ef          	jal	80000bf4 <acquire>
    log.committing = 0;
    80004304:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004308:	8526                	mv	a0,s1
    8000430a:	a51fd0ef          	jal	80001d5a <wakeup>
    release(&log.lock);
    8000430e:	8526                	mv	a0,s1
    80004310:	97dfc0ef          	jal	80000c8c <release>
}
    80004314:	a025                	j	8000433c <end_op+0x8a>
    80004316:	ec4e                	sd	s3,24(sp)
    80004318:	e852                	sd	s4,16(sp)
    8000431a:	e456                	sd	s5,8(sp)
    panic("log.committing");
    8000431c:	00004517          	auipc	a0,0x4
    80004320:	2e450513          	addi	a0,a0,740 # 80008600 <etext+0x600>
    80004324:	c70fc0ef          	jal	80000794 <panic>
    wakeup(&log);
    80004328:	0001f497          	auipc	s1,0x1f
    8000432c:	6c048493          	addi	s1,s1,1728 # 800239e8 <log>
    80004330:	8526                	mv	a0,s1
    80004332:	a29fd0ef          	jal	80001d5a <wakeup>
  release(&log.lock);
    80004336:	8526                	mv	a0,s1
    80004338:	955fc0ef          	jal	80000c8c <release>
}
    8000433c:	70e2                	ld	ra,56(sp)
    8000433e:	7442                	ld	s0,48(sp)
    80004340:	74a2                	ld	s1,40(sp)
    80004342:	7902                	ld	s2,32(sp)
    80004344:	6121                	addi	sp,sp,64
    80004346:	8082                	ret
    80004348:	ec4e                	sd	s3,24(sp)
    8000434a:	e852                	sd	s4,16(sp)
    8000434c:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000434e:	0001fa97          	auipc	s5,0x1f
    80004352:	6caa8a93          	addi	s5,s5,1738 # 80023a18 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004356:	0001fa17          	auipc	s4,0x1f
    8000435a:	692a0a13          	addi	s4,s4,1682 # 800239e8 <log>
    8000435e:	018a2583          	lw	a1,24(s4)
    80004362:	012585bb          	addw	a1,a1,s2
    80004366:	2585                	addiw	a1,a1,1
    80004368:	028a2503          	lw	a0,40(s4)
    8000436c:	f0ffe0ef          	jal	8000327a <bread>
    80004370:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004372:	000aa583          	lw	a1,0(s5)
    80004376:	028a2503          	lw	a0,40(s4)
    8000437a:	f01fe0ef          	jal	8000327a <bread>
    8000437e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004380:	40000613          	li	a2,1024
    80004384:	05850593          	addi	a1,a0,88
    80004388:	05848513          	addi	a0,s1,88
    8000438c:	999fc0ef          	jal	80000d24 <memmove>
    bwrite(to);  // write the log
    80004390:	8526                	mv	a0,s1
    80004392:	fbffe0ef          	jal	80003350 <bwrite>
    brelse(from);
    80004396:	854e                	mv	a0,s3
    80004398:	febfe0ef          	jal	80003382 <brelse>
    brelse(to);
    8000439c:	8526                	mv	a0,s1
    8000439e:	fe5fe0ef          	jal	80003382 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800043a2:	2905                	addiw	s2,s2,1
    800043a4:	0a91                	addi	s5,s5,4
    800043a6:	02ca2783          	lw	a5,44(s4)
    800043aa:	faf94ae3          	blt	s2,a5,8000435e <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800043ae:	d11ff0ef          	jal	800040be <write_head>
    install_trans(0); // Now install writes to home locations
    800043b2:	4501                	li	a0,0
    800043b4:	d69ff0ef          	jal	8000411c <install_trans>
    log.lh.n = 0;
    800043b8:	0001f797          	auipc	a5,0x1f
    800043bc:	6407ae23          	sw	zero,1628(a5) # 80023a14 <log+0x2c>
    write_head();    // Erase the transaction from the log
    800043c0:	cffff0ef          	jal	800040be <write_head>
    800043c4:	69e2                	ld	s3,24(sp)
    800043c6:	6a42                	ld	s4,16(sp)
    800043c8:	6aa2                	ld	s5,8(sp)
    800043ca:	b735                	j	800042f6 <end_op+0x44>

00000000800043cc <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800043cc:	1101                	addi	sp,sp,-32
    800043ce:	ec06                	sd	ra,24(sp)
    800043d0:	e822                	sd	s0,16(sp)
    800043d2:	e426                	sd	s1,8(sp)
    800043d4:	e04a                	sd	s2,0(sp)
    800043d6:	1000                	addi	s0,sp,32
    800043d8:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800043da:	0001f917          	auipc	s2,0x1f
    800043de:	60e90913          	addi	s2,s2,1550 # 800239e8 <log>
    800043e2:	854a                	mv	a0,s2
    800043e4:	811fc0ef          	jal	80000bf4 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800043e8:	02c92603          	lw	a2,44(s2)
    800043ec:	47f5                	li	a5,29
    800043ee:	06c7c363          	blt	a5,a2,80004454 <log_write+0x88>
    800043f2:	0001f797          	auipc	a5,0x1f
    800043f6:	6127a783          	lw	a5,1554(a5) # 80023a04 <log+0x1c>
    800043fa:	37fd                	addiw	a5,a5,-1
    800043fc:	04f65c63          	bge	a2,a5,80004454 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004400:	0001f797          	auipc	a5,0x1f
    80004404:	6087a783          	lw	a5,1544(a5) # 80023a08 <log+0x20>
    80004408:	04f05c63          	blez	a5,80004460 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000440c:	4781                	li	a5,0
    8000440e:	04c05f63          	blez	a2,8000446c <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004412:	44cc                	lw	a1,12(s1)
    80004414:	0001f717          	auipc	a4,0x1f
    80004418:	60470713          	addi	a4,a4,1540 # 80023a18 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000441c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000441e:	4314                	lw	a3,0(a4)
    80004420:	04b68663          	beq	a3,a1,8000446c <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80004424:	2785                	addiw	a5,a5,1
    80004426:	0711                	addi	a4,a4,4
    80004428:	fef61be3          	bne	a2,a5,8000441e <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000442c:	0621                	addi	a2,a2,8
    8000442e:	060a                	slli	a2,a2,0x2
    80004430:	0001f797          	auipc	a5,0x1f
    80004434:	5b878793          	addi	a5,a5,1464 # 800239e8 <log>
    80004438:	97b2                	add	a5,a5,a2
    8000443a:	44d8                	lw	a4,12(s1)
    8000443c:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000443e:	8526                	mv	a0,s1
    80004440:	fcbfe0ef          	jal	8000340a <bpin>
    log.lh.n++;
    80004444:	0001f717          	auipc	a4,0x1f
    80004448:	5a470713          	addi	a4,a4,1444 # 800239e8 <log>
    8000444c:	575c                	lw	a5,44(a4)
    8000444e:	2785                	addiw	a5,a5,1
    80004450:	d75c                	sw	a5,44(a4)
    80004452:	a80d                	j	80004484 <log_write+0xb8>
    panic("too big a transaction");
    80004454:	00004517          	auipc	a0,0x4
    80004458:	1bc50513          	addi	a0,a0,444 # 80008610 <etext+0x610>
    8000445c:	b38fc0ef          	jal	80000794 <panic>
    panic("log_write outside of trans");
    80004460:	00004517          	auipc	a0,0x4
    80004464:	1c850513          	addi	a0,a0,456 # 80008628 <etext+0x628>
    80004468:	b2cfc0ef          	jal	80000794 <panic>
  log.lh.block[i] = b->blockno;
    8000446c:	00878693          	addi	a3,a5,8
    80004470:	068a                	slli	a3,a3,0x2
    80004472:	0001f717          	auipc	a4,0x1f
    80004476:	57670713          	addi	a4,a4,1398 # 800239e8 <log>
    8000447a:	9736                	add	a4,a4,a3
    8000447c:	44d4                	lw	a3,12(s1)
    8000447e:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004480:	faf60fe3          	beq	a2,a5,8000443e <log_write+0x72>
  }
  release(&log.lock);
    80004484:	0001f517          	auipc	a0,0x1f
    80004488:	56450513          	addi	a0,a0,1380 # 800239e8 <log>
    8000448c:	801fc0ef          	jal	80000c8c <release>
}
    80004490:	60e2                	ld	ra,24(sp)
    80004492:	6442                	ld	s0,16(sp)
    80004494:	64a2                	ld	s1,8(sp)
    80004496:	6902                	ld	s2,0(sp)
    80004498:	6105                	addi	sp,sp,32
    8000449a:	8082                	ret

000000008000449c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000449c:	1101                	addi	sp,sp,-32
    8000449e:	ec06                	sd	ra,24(sp)
    800044a0:	e822                	sd	s0,16(sp)
    800044a2:	e426                	sd	s1,8(sp)
    800044a4:	e04a                	sd	s2,0(sp)
    800044a6:	1000                	addi	s0,sp,32
    800044a8:	84aa                	mv	s1,a0
    800044aa:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800044ac:	00004597          	auipc	a1,0x4
    800044b0:	19c58593          	addi	a1,a1,412 # 80008648 <etext+0x648>
    800044b4:	0521                	addi	a0,a0,8
    800044b6:	ebefc0ef          	jal	80000b74 <initlock>
  lk->name = name;
    800044ba:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800044be:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800044c2:	0204a423          	sw	zero,40(s1)
}
    800044c6:	60e2                	ld	ra,24(sp)
    800044c8:	6442                	ld	s0,16(sp)
    800044ca:	64a2                	ld	s1,8(sp)
    800044cc:	6902                	ld	s2,0(sp)
    800044ce:	6105                	addi	sp,sp,32
    800044d0:	8082                	ret

00000000800044d2 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800044d2:	1101                	addi	sp,sp,-32
    800044d4:	ec06                	sd	ra,24(sp)
    800044d6:	e822                	sd	s0,16(sp)
    800044d8:	e426                	sd	s1,8(sp)
    800044da:	e04a                	sd	s2,0(sp)
    800044dc:	1000                	addi	s0,sp,32
    800044de:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800044e0:	00850913          	addi	s2,a0,8
    800044e4:	854a                	mv	a0,s2
    800044e6:	f0efc0ef          	jal	80000bf4 <acquire>
  while (lk->locked) {
    800044ea:	409c                	lw	a5,0(s1)
    800044ec:	c799                	beqz	a5,800044fa <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    800044ee:	85ca                	mv	a1,s2
    800044f0:	8526                	mv	a0,s1
    800044f2:	81dfd0ef          	jal	80001d0e <sleep>
  while (lk->locked) {
    800044f6:	409c                	lw	a5,0(s1)
    800044f8:	fbfd                	bnez	a5,800044ee <acquiresleep+0x1c>
  }
  lk->locked = 1;
    800044fa:	4785                	li	a5,1
    800044fc:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800044fe:	c30fd0ef          	jal	8000192e <myproc>
    80004502:	591c                	lw	a5,48(a0)
    80004504:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004506:	854a                	mv	a0,s2
    80004508:	f84fc0ef          	jal	80000c8c <release>
}
    8000450c:	60e2                	ld	ra,24(sp)
    8000450e:	6442                	ld	s0,16(sp)
    80004510:	64a2                	ld	s1,8(sp)
    80004512:	6902                	ld	s2,0(sp)
    80004514:	6105                	addi	sp,sp,32
    80004516:	8082                	ret

0000000080004518 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004518:	1101                	addi	sp,sp,-32
    8000451a:	ec06                	sd	ra,24(sp)
    8000451c:	e822                	sd	s0,16(sp)
    8000451e:	e426                	sd	s1,8(sp)
    80004520:	e04a                	sd	s2,0(sp)
    80004522:	1000                	addi	s0,sp,32
    80004524:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004526:	00850913          	addi	s2,a0,8
    8000452a:	854a                	mv	a0,s2
    8000452c:	ec8fc0ef          	jal	80000bf4 <acquire>
  lk->locked = 0;
    80004530:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004534:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004538:	8526                	mv	a0,s1
    8000453a:	821fd0ef          	jal	80001d5a <wakeup>
  release(&lk->lk);
    8000453e:	854a                	mv	a0,s2
    80004540:	f4cfc0ef          	jal	80000c8c <release>
}
    80004544:	60e2                	ld	ra,24(sp)
    80004546:	6442                	ld	s0,16(sp)
    80004548:	64a2                	ld	s1,8(sp)
    8000454a:	6902                	ld	s2,0(sp)
    8000454c:	6105                	addi	sp,sp,32
    8000454e:	8082                	ret

0000000080004550 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004550:	7179                	addi	sp,sp,-48
    80004552:	f406                	sd	ra,40(sp)
    80004554:	f022                	sd	s0,32(sp)
    80004556:	ec26                	sd	s1,24(sp)
    80004558:	e84a                	sd	s2,16(sp)
    8000455a:	1800                	addi	s0,sp,48
    8000455c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000455e:	00850913          	addi	s2,a0,8
    80004562:	854a                	mv	a0,s2
    80004564:	e90fc0ef          	jal	80000bf4 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004568:	409c                	lw	a5,0(s1)
    8000456a:	ef81                	bnez	a5,80004582 <holdingsleep+0x32>
    8000456c:	4481                	li	s1,0
  release(&lk->lk);
    8000456e:	854a                	mv	a0,s2
    80004570:	f1cfc0ef          	jal	80000c8c <release>
  return r;
}
    80004574:	8526                	mv	a0,s1
    80004576:	70a2                	ld	ra,40(sp)
    80004578:	7402                	ld	s0,32(sp)
    8000457a:	64e2                	ld	s1,24(sp)
    8000457c:	6942                	ld	s2,16(sp)
    8000457e:	6145                	addi	sp,sp,48
    80004580:	8082                	ret
    80004582:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004584:	0284a983          	lw	s3,40(s1)
    80004588:	ba6fd0ef          	jal	8000192e <myproc>
    8000458c:	5904                	lw	s1,48(a0)
    8000458e:	413484b3          	sub	s1,s1,s3
    80004592:	0014b493          	seqz	s1,s1
    80004596:	69a2                	ld	s3,8(sp)
    80004598:	bfd9                	j	8000456e <holdingsleep+0x1e>

000000008000459a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000459a:	1141                	addi	sp,sp,-16
    8000459c:	e406                	sd	ra,8(sp)
    8000459e:	e022                	sd	s0,0(sp)
    800045a0:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800045a2:	00004597          	auipc	a1,0x4
    800045a6:	0b658593          	addi	a1,a1,182 # 80008658 <etext+0x658>
    800045aa:	0001f517          	auipc	a0,0x1f
    800045ae:	58650513          	addi	a0,a0,1414 # 80023b30 <ftable>
    800045b2:	dc2fc0ef          	jal	80000b74 <initlock>
}
    800045b6:	60a2                	ld	ra,8(sp)
    800045b8:	6402                	ld	s0,0(sp)
    800045ba:	0141                	addi	sp,sp,16
    800045bc:	8082                	ret

00000000800045be <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800045be:	1101                	addi	sp,sp,-32
    800045c0:	ec06                	sd	ra,24(sp)
    800045c2:	e822                	sd	s0,16(sp)
    800045c4:	e426                	sd	s1,8(sp)
    800045c6:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800045c8:	0001f517          	auipc	a0,0x1f
    800045cc:	56850513          	addi	a0,a0,1384 # 80023b30 <ftable>
    800045d0:	e24fc0ef          	jal	80000bf4 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800045d4:	0001f497          	auipc	s1,0x1f
    800045d8:	57448493          	addi	s1,s1,1396 # 80023b48 <ftable+0x18>
    800045dc:	00020717          	auipc	a4,0x20
    800045e0:	50c70713          	addi	a4,a4,1292 # 80024ae8 <disk>
    if(f->ref == 0){
    800045e4:	40dc                	lw	a5,4(s1)
    800045e6:	cf89                	beqz	a5,80004600 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800045e8:	02848493          	addi	s1,s1,40
    800045ec:	fee49ce3          	bne	s1,a4,800045e4 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800045f0:	0001f517          	auipc	a0,0x1f
    800045f4:	54050513          	addi	a0,a0,1344 # 80023b30 <ftable>
    800045f8:	e94fc0ef          	jal	80000c8c <release>
  return 0;
    800045fc:	4481                	li	s1,0
    800045fe:	a809                	j	80004610 <filealloc+0x52>
      f->ref = 1;
    80004600:	4785                	li	a5,1
    80004602:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004604:	0001f517          	auipc	a0,0x1f
    80004608:	52c50513          	addi	a0,a0,1324 # 80023b30 <ftable>
    8000460c:	e80fc0ef          	jal	80000c8c <release>
}
    80004610:	8526                	mv	a0,s1
    80004612:	60e2                	ld	ra,24(sp)
    80004614:	6442                	ld	s0,16(sp)
    80004616:	64a2                	ld	s1,8(sp)
    80004618:	6105                	addi	sp,sp,32
    8000461a:	8082                	ret

000000008000461c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000461c:	1101                	addi	sp,sp,-32
    8000461e:	ec06                	sd	ra,24(sp)
    80004620:	e822                	sd	s0,16(sp)
    80004622:	e426                	sd	s1,8(sp)
    80004624:	1000                	addi	s0,sp,32
    80004626:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004628:	0001f517          	auipc	a0,0x1f
    8000462c:	50850513          	addi	a0,a0,1288 # 80023b30 <ftable>
    80004630:	dc4fc0ef          	jal	80000bf4 <acquire>
  if(f->ref < 1)
    80004634:	40dc                	lw	a5,4(s1)
    80004636:	02f05063          	blez	a5,80004656 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    8000463a:	2785                	addiw	a5,a5,1
    8000463c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000463e:	0001f517          	auipc	a0,0x1f
    80004642:	4f250513          	addi	a0,a0,1266 # 80023b30 <ftable>
    80004646:	e46fc0ef          	jal	80000c8c <release>
  return f;
}
    8000464a:	8526                	mv	a0,s1
    8000464c:	60e2                	ld	ra,24(sp)
    8000464e:	6442                	ld	s0,16(sp)
    80004650:	64a2                	ld	s1,8(sp)
    80004652:	6105                	addi	sp,sp,32
    80004654:	8082                	ret
    panic("filedup");
    80004656:	00004517          	auipc	a0,0x4
    8000465a:	00a50513          	addi	a0,a0,10 # 80008660 <etext+0x660>
    8000465e:	936fc0ef          	jal	80000794 <panic>

0000000080004662 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004662:	7139                	addi	sp,sp,-64
    80004664:	fc06                	sd	ra,56(sp)
    80004666:	f822                	sd	s0,48(sp)
    80004668:	f426                	sd	s1,40(sp)
    8000466a:	0080                	addi	s0,sp,64
    8000466c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000466e:	0001f517          	auipc	a0,0x1f
    80004672:	4c250513          	addi	a0,a0,1218 # 80023b30 <ftable>
    80004676:	d7efc0ef          	jal	80000bf4 <acquire>
  if(f->ref < 1)
    8000467a:	40dc                	lw	a5,4(s1)
    8000467c:	04f05a63          	blez	a5,800046d0 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80004680:	37fd                	addiw	a5,a5,-1
    80004682:	0007871b          	sext.w	a4,a5
    80004686:	c0dc                	sw	a5,4(s1)
    80004688:	04e04e63          	bgtz	a4,800046e4 <fileclose+0x82>
    8000468c:	f04a                	sd	s2,32(sp)
    8000468e:	ec4e                	sd	s3,24(sp)
    80004690:	e852                	sd	s4,16(sp)
    80004692:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004694:	0004a903          	lw	s2,0(s1)
    80004698:	0094ca83          	lbu	s5,9(s1)
    8000469c:	0104ba03          	ld	s4,16(s1)
    800046a0:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800046a4:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800046a8:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800046ac:	0001f517          	auipc	a0,0x1f
    800046b0:	48450513          	addi	a0,a0,1156 # 80023b30 <ftable>
    800046b4:	dd8fc0ef          	jal	80000c8c <release>

  if(ff.type == FD_PIPE){
    800046b8:	4785                	li	a5,1
    800046ba:	04f90063          	beq	s2,a5,800046fa <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800046be:	3979                	addiw	s2,s2,-2
    800046c0:	4785                	li	a5,1
    800046c2:	0527f563          	bgeu	a5,s2,8000470c <fileclose+0xaa>
    800046c6:	7902                	ld	s2,32(sp)
    800046c8:	69e2                	ld	s3,24(sp)
    800046ca:	6a42                	ld	s4,16(sp)
    800046cc:	6aa2                	ld	s5,8(sp)
    800046ce:	a00d                	j	800046f0 <fileclose+0x8e>
    800046d0:	f04a                	sd	s2,32(sp)
    800046d2:	ec4e                	sd	s3,24(sp)
    800046d4:	e852                	sd	s4,16(sp)
    800046d6:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800046d8:	00004517          	auipc	a0,0x4
    800046dc:	f9050513          	addi	a0,a0,-112 # 80008668 <etext+0x668>
    800046e0:	8b4fc0ef          	jal	80000794 <panic>
    release(&ftable.lock);
    800046e4:	0001f517          	auipc	a0,0x1f
    800046e8:	44c50513          	addi	a0,a0,1100 # 80023b30 <ftable>
    800046ec:	da0fc0ef          	jal	80000c8c <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800046f0:	70e2                	ld	ra,56(sp)
    800046f2:	7442                	ld	s0,48(sp)
    800046f4:	74a2                	ld	s1,40(sp)
    800046f6:	6121                	addi	sp,sp,64
    800046f8:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800046fa:	85d6                	mv	a1,s5
    800046fc:	8552                	mv	a0,s4
    800046fe:	336000ef          	jal	80004a34 <pipeclose>
    80004702:	7902                	ld	s2,32(sp)
    80004704:	69e2                	ld	s3,24(sp)
    80004706:	6a42                	ld	s4,16(sp)
    80004708:	6aa2                	ld	s5,8(sp)
    8000470a:	b7dd                	j	800046f0 <fileclose+0x8e>
    begin_op();
    8000470c:	b3dff0ef          	jal	80004248 <begin_op>
    iput(ff.ip);
    80004710:	854e                	mv	a0,s3
    80004712:	c22ff0ef          	jal	80003b34 <iput>
    end_op();
    80004716:	b9dff0ef          	jal	800042b2 <end_op>
    8000471a:	7902                	ld	s2,32(sp)
    8000471c:	69e2                	ld	s3,24(sp)
    8000471e:	6a42                	ld	s4,16(sp)
    80004720:	6aa2                	ld	s5,8(sp)
    80004722:	b7f9                	j	800046f0 <fileclose+0x8e>

0000000080004724 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004724:	715d                	addi	sp,sp,-80
    80004726:	e486                	sd	ra,72(sp)
    80004728:	e0a2                	sd	s0,64(sp)
    8000472a:	fc26                	sd	s1,56(sp)
    8000472c:	f44e                	sd	s3,40(sp)
    8000472e:	0880                	addi	s0,sp,80
    80004730:	84aa                	mv	s1,a0
    80004732:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004734:	9fafd0ef          	jal	8000192e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004738:	409c                	lw	a5,0(s1)
    8000473a:	37f9                	addiw	a5,a5,-2
    8000473c:	4705                	li	a4,1
    8000473e:	04f76063          	bltu	a4,a5,8000477e <filestat+0x5a>
    80004742:	f84a                	sd	s2,48(sp)
    80004744:	892a                	mv	s2,a0
    ilock(f->ip);
    80004746:	6c88                	ld	a0,24(s1)
    80004748:	a6aff0ef          	jal	800039b2 <ilock>
    stati(f->ip, &st);
    8000474c:	fb840593          	addi	a1,s0,-72
    80004750:	6c88                	ld	a0,24(s1)
    80004752:	c8aff0ef          	jal	80003bdc <stati>
    iunlock(f->ip);
    80004756:	6c88                	ld	a0,24(s1)
    80004758:	b08ff0ef          	jal	80003a60 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000475c:	46e1                	li	a3,24
    8000475e:	fb840613          	addi	a2,s0,-72
    80004762:	85ce                	mv	a1,s3
    80004764:	05893503          	ld	a0,88(s2)
    80004768:	debfc0ef          	jal	80001552 <copyout>
    8000476c:	41f5551b          	sraiw	a0,a0,0x1f
    80004770:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004772:	60a6                	ld	ra,72(sp)
    80004774:	6406                	ld	s0,64(sp)
    80004776:	74e2                	ld	s1,56(sp)
    80004778:	79a2                	ld	s3,40(sp)
    8000477a:	6161                	addi	sp,sp,80
    8000477c:	8082                	ret
  return -1;
    8000477e:	557d                	li	a0,-1
    80004780:	bfcd                	j	80004772 <filestat+0x4e>

0000000080004782 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004782:	7179                	addi	sp,sp,-48
    80004784:	f406                	sd	ra,40(sp)
    80004786:	f022                	sd	s0,32(sp)
    80004788:	e84a                	sd	s2,16(sp)
    8000478a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000478c:	00854783          	lbu	a5,8(a0)
    80004790:	cfd1                	beqz	a5,8000482c <fileread+0xaa>
    80004792:	ec26                	sd	s1,24(sp)
    80004794:	e44e                	sd	s3,8(sp)
    80004796:	84aa                	mv	s1,a0
    80004798:	89ae                	mv	s3,a1
    8000479a:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    8000479c:	411c                	lw	a5,0(a0)
    8000479e:	4705                	li	a4,1
    800047a0:	04e78363          	beq	a5,a4,800047e6 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800047a4:	470d                	li	a4,3
    800047a6:	04e78763          	beq	a5,a4,800047f4 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800047aa:	4709                	li	a4,2
    800047ac:	06e79a63          	bne	a5,a4,80004820 <fileread+0x9e>
    ilock(f->ip);
    800047b0:	6d08                	ld	a0,24(a0)
    800047b2:	a00ff0ef          	jal	800039b2 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800047b6:	874a                	mv	a4,s2
    800047b8:	5094                	lw	a3,32(s1)
    800047ba:	864e                	mv	a2,s3
    800047bc:	4585                	li	a1,1
    800047be:	6c88                	ld	a0,24(s1)
    800047c0:	c46ff0ef          	jal	80003c06 <readi>
    800047c4:	892a                	mv	s2,a0
    800047c6:	00a05563          	blez	a0,800047d0 <fileread+0x4e>
      f->off += r;
    800047ca:	509c                	lw	a5,32(s1)
    800047cc:	9fa9                	addw	a5,a5,a0
    800047ce:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800047d0:	6c88                	ld	a0,24(s1)
    800047d2:	a8eff0ef          	jal	80003a60 <iunlock>
    800047d6:	64e2                	ld	s1,24(sp)
    800047d8:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800047da:	854a                	mv	a0,s2
    800047dc:	70a2                	ld	ra,40(sp)
    800047de:	7402                	ld	s0,32(sp)
    800047e0:	6942                	ld	s2,16(sp)
    800047e2:	6145                	addi	sp,sp,48
    800047e4:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800047e6:	6908                	ld	a0,16(a0)
    800047e8:	388000ef          	jal	80004b70 <piperead>
    800047ec:	892a                	mv	s2,a0
    800047ee:	64e2                	ld	s1,24(sp)
    800047f0:	69a2                	ld	s3,8(sp)
    800047f2:	b7e5                	j	800047da <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800047f4:	02451783          	lh	a5,36(a0)
    800047f8:	03079693          	slli	a3,a5,0x30
    800047fc:	92c1                	srli	a3,a3,0x30
    800047fe:	4725                	li	a4,9
    80004800:	02d76863          	bltu	a4,a3,80004830 <fileread+0xae>
    80004804:	0792                	slli	a5,a5,0x4
    80004806:	0001f717          	auipc	a4,0x1f
    8000480a:	28a70713          	addi	a4,a4,650 # 80023a90 <devsw>
    8000480e:	97ba                	add	a5,a5,a4
    80004810:	639c                	ld	a5,0(a5)
    80004812:	c39d                	beqz	a5,80004838 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80004814:	4505                	li	a0,1
    80004816:	9782                	jalr	a5
    80004818:	892a                	mv	s2,a0
    8000481a:	64e2                	ld	s1,24(sp)
    8000481c:	69a2                	ld	s3,8(sp)
    8000481e:	bf75                	j	800047da <fileread+0x58>
    panic("fileread");
    80004820:	00004517          	auipc	a0,0x4
    80004824:	e5850513          	addi	a0,a0,-424 # 80008678 <etext+0x678>
    80004828:	f6dfb0ef          	jal	80000794 <panic>
    return -1;
    8000482c:	597d                	li	s2,-1
    8000482e:	b775                	j	800047da <fileread+0x58>
      return -1;
    80004830:	597d                	li	s2,-1
    80004832:	64e2                	ld	s1,24(sp)
    80004834:	69a2                	ld	s3,8(sp)
    80004836:	b755                	j	800047da <fileread+0x58>
    80004838:	597d                	li	s2,-1
    8000483a:	64e2                	ld	s1,24(sp)
    8000483c:	69a2                	ld	s3,8(sp)
    8000483e:	bf71                	j	800047da <fileread+0x58>

0000000080004840 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004840:	00954783          	lbu	a5,9(a0)
    80004844:	10078b63          	beqz	a5,8000495a <filewrite+0x11a>
{
    80004848:	715d                	addi	sp,sp,-80
    8000484a:	e486                	sd	ra,72(sp)
    8000484c:	e0a2                	sd	s0,64(sp)
    8000484e:	f84a                	sd	s2,48(sp)
    80004850:	f052                	sd	s4,32(sp)
    80004852:	e85a                	sd	s6,16(sp)
    80004854:	0880                	addi	s0,sp,80
    80004856:	892a                	mv	s2,a0
    80004858:	8b2e                	mv	s6,a1
    8000485a:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    8000485c:	411c                	lw	a5,0(a0)
    8000485e:	4705                	li	a4,1
    80004860:	02e78763          	beq	a5,a4,8000488e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004864:	470d                	li	a4,3
    80004866:	02e78863          	beq	a5,a4,80004896 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000486a:	4709                	li	a4,2
    8000486c:	0ce79c63          	bne	a5,a4,80004944 <filewrite+0x104>
    80004870:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004872:	0ac05863          	blez	a2,80004922 <filewrite+0xe2>
    80004876:	fc26                	sd	s1,56(sp)
    80004878:	ec56                	sd	s5,24(sp)
    8000487a:	e45e                	sd	s7,8(sp)
    8000487c:	e062                	sd	s8,0(sp)
    int i = 0;
    8000487e:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80004880:	6b85                	lui	s7,0x1
    80004882:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004886:	6c05                	lui	s8,0x1
    80004888:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    8000488c:	a8b5                	j	80004908 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    8000488e:	6908                	ld	a0,16(a0)
    80004890:	1fc000ef          	jal	80004a8c <pipewrite>
    80004894:	a04d                	j	80004936 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004896:	02451783          	lh	a5,36(a0)
    8000489a:	03079693          	slli	a3,a5,0x30
    8000489e:	92c1                	srli	a3,a3,0x30
    800048a0:	4725                	li	a4,9
    800048a2:	0ad76e63          	bltu	a4,a3,8000495e <filewrite+0x11e>
    800048a6:	0792                	slli	a5,a5,0x4
    800048a8:	0001f717          	auipc	a4,0x1f
    800048ac:	1e870713          	addi	a4,a4,488 # 80023a90 <devsw>
    800048b0:	97ba                	add	a5,a5,a4
    800048b2:	679c                	ld	a5,8(a5)
    800048b4:	c7dd                	beqz	a5,80004962 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    800048b6:	4505                	li	a0,1
    800048b8:	9782                	jalr	a5
    800048ba:	a8b5                	j	80004936 <filewrite+0xf6>
      if(n1 > max)
    800048bc:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800048c0:	989ff0ef          	jal	80004248 <begin_op>
      ilock(f->ip);
    800048c4:	01893503          	ld	a0,24(s2)
    800048c8:	8eaff0ef          	jal	800039b2 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800048cc:	8756                	mv	a4,s5
    800048ce:	02092683          	lw	a3,32(s2)
    800048d2:	01698633          	add	a2,s3,s6
    800048d6:	4585                	li	a1,1
    800048d8:	01893503          	ld	a0,24(s2)
    800048dc:	c26ff0ef          	jal	80003d02 <writei>
    800048e0:	84aa                	mv	s1,a0
    800048e2:	00a05763          	blez	a0,800048f0 <filewrite+0xb0>
        f->off += r;
    800048e6:	02092783          	lw	a5,32(s2)
    800048ea:	9fa9                	addw	a5,a5,a0
    800048ec:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800048f0:	01893503          	ld	a0,24(s2)
    800048f4:	96cff0ef          	jal	80003a60 <iunlock>
      end_op();
    800048f8:	9bbff0ef          	jal	800042b2 <end_op>

      if(r != n1){
    800048fc:	029a9563          	bne	s5,s1,80004926 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    80004900:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004904:	0149da63          	bge	s3,s4,80004918 <filewrite+0xd8>
      int n1 = n - i;
    80004908:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    8000490c:	0004879b          	sext.w	a5,s1
    80004910:	fafbd6e3          	bge	s7,a5,800048bc <filewrite+0x7c>
    80004914:	84e2                	mv	s1,s8
    80004916:	b75d                	j	800048bc <filewrite+0x7c>
    80004918:	74e2                	ld	s1,56(sp)
    8000491a:	6ae2                	ld	s5,24(sp)
    8000491c:	6ba2                	ld	s7,8(sp)
    8000491e:	6c02                	ld	s8,0(sp)
    80004920:	a039                	j	8000492e <filewrite+0xee>
    int i = 0;
    80004922:	4981                	li	s3,0
    80004924:	a029                	j	8000492e <filewrite+0xee>
    80004926:	74e2                	ld	s1,56(sp)
    80004928:	6ae2                	ld	s5,24(sp)
    8000492a:	6ba2                	ld	s7,8(sp)
    8000492c:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    8000492e:	033a1c63          	bne	s4,s3,80004966 <filewrite+0x126>
    80004932:	8552                	mv	a0,s4
    80004934:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004936:	60a6                	ld	ra,72(sp)
    80004938:	6406                	ld	s0,64(sp)
    8000493a:	7942                	ld	s2,48(sp)
    8000493c:	7a02                	ld	s4,32(sp)
    8000493e:	6b42                	ld	s6,16(sp)
    80004940:	6161                	addi	sp,sp,80
    80004942:	8082                	ret
    80004944:	fc26                	sd	s1,56(sp)
    80004946:	f44e                	sd	s3,40(sp)
    80004948:	ec56                	sd	s5,24(sp)
    8000494a:	e45e                	sd	s7,8(sp)
    8000494c:	e062                	sd	s8,0(sp)
    panic("filewrite");
    8000494e:	00004517          	auipc	a0,0x4
    80004952:	d3a50513          	addi	a0,a0,-710 # 80008688 <etext+0x688>
    80004956:	e3ffb0ef          	jal	80000794 <panic>
    return -1;
    8000495a:	557d                	li	a0,-1
}
    8000495c:	8082                	ret
      return -1;
    8000495e:	557d                	li	a0,-1
    80004960:	bfd9                	j	80004936 <filewrite+0xf6>
    80004962:	557d                	li	a0,-1
    80004964:	bfc9                	j	80004936 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    80004966:	557d                	li	a0,-1
    80004968:	79a2                	ld	s3,40(sp)
    8000496a:	b7f1                	j	80004936 <filewrite+0xf6>

000000008000496c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000496c:	7179                	addi	sp,sp,-48
    8000496e:	f406                	sd	ra,40(sp)
    80004970:	f022                	sd	s0,32(sp)
    80004972:	ec26                	sd	s1,24(sp)
    80004974:	e052                	sd	s4,0(sp)
    80004976:	1800                	addi	s0,sp,48
    80004978:	84aa                	mv	s1,a0
    8000497a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000497c:	0005b023          	sd	zero,0(a1)
    80004980:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004984:	c3bff0ef          	jal	800045be <filealloc>
    80004988:	e088                	sd	a0,0(s1)
    8000498a:	c549                	beqz	a0,80004a14 <pipealloc+0xa8>
    8000498c:	c33ff0ef          	jal	800045be <filealloc>
    80004990:	00aa3023          	sd	a0,0(s4)
    80004994:	cd25                	beqz	a0,80004a0c <pipealloc+0xa0>
    80004996:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004998:	98cfc0ef          	jal	80000b24 <kalloc>
    8000499c:	892a                	mv	s2,a0
    8000499e:	c12d                	beqz	a0,80004a00 <pipealloc+0x94>
    800049a0:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800049a2:	4985                	li	s3,1
    800049a4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800049a8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800049ac:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800049b0:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800049b4:	00004597          	auipc	a1,0x4
    800049b8:	ce458593          	addi	a1,a1,-796 # 80008698 <etext+0x698>
    800049bc:	9b8fc0ef          	jal	80000b74 <initlock>
  (*f0)->type = FD_PIPE;
    800049c0:	609c                	ld	a5,0(s1)
    800049c2:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800049c6:	609c                	ld	a5,0(s1)
    800049c8:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800049cc:	609c                	ld	a5,0(s1)
    800049ce:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800049d2:	609c                	ld	a5,0(s1)
    800049d4:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800049d8:	000a3783          	ld	a5,0(s4)
    800049dc:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800049e0:	000a3783          	ld	a5,0(s4)
    800049e4:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800049e8:	000a3783          	ld	a5,0(s4)
    800049ec:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800049f0:	000a3783          	ld	a5,0(s4)
    800049f4:	0127b823          	sd	s2,16(a5)
  return 0;
    800049f8:	4501                	li	a0,0
    800049fa:	6942                	ld	s2,16(sp)
    800049fc:	69a2                	ld	s3,8(sp)
    800049fe:	a01d                	j	80004a24 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004a00:	6088                	ld	a0,0(s1)
    80004a02:	c119                	beqz	a0,80004a08 <pipealloc+0x9c>
    80004a04:	6942                	ld	s2,16(sp)
    80004a06:	a029                	j	80004a10 <pipealloc+0xa4>
    80004a08:	6942                	ld	s2,16(sp)
    80004a0a:	a029                	j	80004a14 <pipealloc+0xa8>
    80004a0c:	6088                	ld	a0,0(s1)
    80004a0e:	c10d                	beqz	a0,80004a30 <pipealloc+0xc4>
    fileclose(*f0);
    80004a10:	c53ff0ef          	jal	80004662 <fileclose>
  if(*f1)
    80004a14:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004a18:	557d                	li	a0,-1
  if(*f1)
    80004a1a:	c789                	beqz	a5,80004a24 <pipealloc+0xb8>
    fileclose(*f1);
    80004a1c:	853e                	mv	a0,a5
    80004a1e:	c45ff0ef          	jal	80004662 <fileclose>
  return -1;
    80004a22:	557d                	li	a0,-1
}
    80004a24:	70a2                	ld	ra,40(sp)
    80004a26:	7402                	ld	s0,32(sp)
    80004a28:	64e2                	ld	s1,24(sp)
    80004a2a:	6a02                	ld	s4,0(sp)
    80004a2c:	6145                	addi	sp,sp,48
    80004a2e:	8082                	ret
  return -1;
    80004a30:	557d                	li	a0,-1
    80004a32:	bfcd                	j	80004a24 <pipealloc+0xb8>

0000000080004a34 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004a34:	1101                	addi	sp,sp,-32
    80004a36:	ec06                	sd	ra,24(sp)
    80004a38:	e822                	sd	s0,16(sp)
    80004a3a:	e426                	sd	s1,8(sp)
    80004a3c:	e04a                	sd	s2,0(sp)
    80004a3e:	1000                	addi	s0,sp,32
    80004a40:	84aa                	mv	s1,a0
    80004a42:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004a44:	9b0fc0ef          	jal	80000bf4 <acquire>
  if(writable){
    80004a48:	02090763          	beqz	s2,80004a76 <pipeclose+0x42>
    pi->writeopen = 0;
    80004a4c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004a50:	21848513          	addi	a0,s1,536
    80004a54:	b06fd0ef          	jal	80001d5a <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004a58:	2204b783          	ld	a5,544(s1)
    80004a5c:	e785                	bnez	a5,80004a84 <pipeclose+0x50>
    release(&pi->lock);
    80004a5e:	8526                	mv	a0,s1
    80004a60:	a2cfc0ef          	jal	80000c8c <release>
    kfree((char*)pi);
    80004a64:	8526                	mv	a0,s1
    80004a66:	fddfb0ef          	jal	80000a42 <kfree>
  } else
    release(&pi->lock);
}
    80004a6a:	60e2                	ld	ra,24(sp)
    80004a6c:	6442                	ld	s0,16(sp)
    80004a6e:	64a2                	ld	s1,8(sp)
    80004a70:	6902                	ld	s2,0(sp)
    80004a72:	6105                	addi	sp,sp,32
    80004a74:	8082                	ret
    pi->readopen = 0;
    80004a76:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004a7a:	21c48513          	addi	a0,s1,540
    80004a7e:	adcfd0ef          	jal	80001d5a <wakeup>
    80004a82:	bfd9                	j	80004a58 <pipeclose+0x24>
    release(&pi->lock);
    80004a84:	8526                	mv	a0,s1
    80004a86:	a06fc0ef          	jal	80000c8c <release>
}
    80004a8a:	b7c5                	j	80004a6a <pipeclose+0x36>

0000000080004a8c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004a8c:	711d                	addi	sp,sp,-96
    80004a8e:	ec86                	sd	ra,88(sp)
    80004a90:	e8a2                	sd	s0,80(sp)
    80004a92:	e4a6                	sd	s1,72(sp)
    80004a94:	e0ca                	sd	s2,64(sp)
    80004a96:	fc4e                	sd	s3,56(sp)
    80004a98:	f852                	sd	s4,48(sp)
    80004a9a:	f456                	sd	s5,40(sp)
    80004a9c:	1080                	addi	s0,sp,96
    80004a9e:	84aa                	mv	s1,a0
    80004aa0:	8aae                	mv	s5,a1
    80004aa2:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004aa4:	e8bfc0ef          	jal	8000192e <myproc>
    80004aa8:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004aaa:	8526                	mv	a0,s1
    80004aac:	948fc0ef          	jal	80000bf4 <acquire>
  while(i < n){
    80004ab0:	0b405a63          	blez	s4,80004b64 <pipewrite+0xd8>
    80004ab4:	f05a                	sd	s6,32(sp)
    80004ab6:	ec5e                	sd	s7,24(sp)
    80004ab8:	e862                	sd	s8,16(sp)
  int i = 0;
    80004aba:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004abc:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004abe:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004ac2:	21c48b93          	addi	s7,s1,540
    80004ac6:	a81d                	j	80004afc <pipewrite+0x70>
      release(&pi->lock);
    80004ac8:	8526                	mv	a0,s1
    80004aca:	9c2fc0ef          	jal	80000c8c <release>
      return -1;
    80004ace:	597d                	li	s2,-1
    80004ad0:	7b02                	ld	s6,32(sp)
    80004ad2:	6be2                	ld	s7,24(sp)
    80004ad4:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004ad6:	854a                	mv	a0,s2
    80004ad8:	60e6                	ld	ra,88(sp)
    80004ada:	6446                	ld	s0,80(sp)
    80004adc:	64a6                	ld	s1,72(sp)
    80004ade:	6906                	ld	s2,64(sp)
    80004ae0:	79e2                	ld	s3,56(sp)
    80004ae2:	7a42                	ld	s4,48(sp)
    80004ae4:	7aa2                	ld	s5,40(sp)
    80004ae6:	6125                	addi	sp,sp,96
    80004ae8:	8082                	ret
      wakeup(&pi->nread);
    80004aea:	8562                	mv	a0,s8
    80004aec:	a6efd0ef          	jal	80001d5a <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004af0:	85a6                	mv	a1,s1
    80004af2:	855e                	mv	a0,s7
    80004af4:	a1afd0ef          	jal	80001d0e <sleep>
  while(i < n){
    80004af8:	05495b63          	bge	s2,s4,80004b4e <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    80004afc:	2204a783          	lw	a5,544(s1)
    80004b00:	d7e1                	beqz	a5,80004ac8 <pipewrite+0x3c>
    80004b02:	854e                	mv	a0,s3
    80004b04:	c42fd0ef          	jal	80001f46 <killed>
    80004b08:	f161                	bnez	a0,80004ac8 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004b0a:	2184a783          	lw	a5,536(s1)
    80004b0e:	21c4a703          	lw	a4,540(s1)
    80004b12:	2007879b          	addiw	a5,a5,512
    80004b16:	fcf70ae3          	beq	a4,a5,80004aea <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004b1a:	4685                	li	a3,1
    80004b1c:	01590633          	add	a2,s2,s5
    80004b20:	faf40593          	addi	a1,s0,-81
    80004b24:	0589b503          	ld	a0,88(s3)
    80004b28:	b01fc0ef          	jal	80001628 <copyin>
    80004b2c:	03650e63          	beq	a0,s6,80004b68 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004b30:	21c4a783          	lw	a5,540(s1)
    80004b34:	0017871b          	addiw	a4,a5,1
    80004b38:	20e4ae23          	sw	a4,540(s1)
    80004b3c:	1ff7f793          	andi	a5,a5,511
    80004b40:	97a6                	add	a5,a5,s1
    80004b42:	faf44703          	lbu	a4,-81(s0)
    80004b46:	00e78c23          	sb	a4,24(a5)
      i++;
    80004b4a:	2905                	addiw	s2,s2,1
    80004b4c:	b775                	j	80004af8 <pipewrite+0x6c>
    80004b4e:	7b02                	ld	s6,32(sp)
    80004b50:	6be2                	ld	s7,24(sp)
    80004b52:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80004b54:	21848513          	addi	a0,s1,536
    80004b58:	a02fd0ef          	jal	80001d5a <wakeup>
  release(&pi->lock);
    80004b5c:	8526                	mv	a0,s1
    80004b5e:	92efc0ef          	jal	80000c8c <release>
  return i;
    80004b62:	bf95                	j	80004ad6 <pipewrite+0x4a>
  int i = 0;
    80004b64:	4901                	li	s2,0
    80004b66:	b7fd                	j	80004b54 <pipewrite+0xc8>
    80004b68:	7b02                	ld	s6,32(sp)
    80004b6a:	6be2                	ld	s7,24(sp)
    80004b6c:	6c42                	ld	s8,16(sp)
    80004b6e:	b7dd                	j	80004b54 <pipewrite+0xc8>

0000000080004b70 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004b70:	715d                	addi	sp,sp,-80
    80004b72:	e486                	sd	ra,72(sp)
    80004b74:	e0a2                	sd	s0,64(sp)
    80004b76:	fc26                	sd	s1,56(sp)
    80004b78:	f84a                	sd	s2,48(sp)
    80004b7a:	f44e                	sd	s3,40(sp)
    80004b7c:	f052                	sd	s4,32(sp)
    80004b7e:	ec56                	sd	s5,24(sp)
    80004b80:	0880                	addi	s0,sp,80
    80004b82:	84aa                	mv	s1,a0
    80004b84:	892e                	mv	s2,a1
    80004b86:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004b88:	da7fc0ef          	jal	8000192e <myproc>
    80004b8c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004b8e:	8526                	mv	a0,s1
    80004b90:	864fc0ef          	jal	80000bf4 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004b94:	2184a703          	lw	a4,536(s1)
    80004b98:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004b9c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004ba0:	02f71563          	bne	a4,a5,80004bca <piperead+0x5a>
    80004ba4:	2244a783          	lw	a5,548(s1)
    80004ba8:	cb85                	beqz	a5,80004bd8 <piperead+0x68>
    if(killed(pr)){
    80004baa:	8552                	mv	a0,s4
    80004bac:	b9afd0ef          	jal	80001f46 <killed>
    80004bb0:	ed19                	bnez	a0,80004bce <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004bb2:	85a6                	mv	a1,s1
    80004bb4:	854e                	mv	a0,s3
    80004bb6:	958fd0ef          	jal	80001d0e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004bba:	2184a703          	lw	a4,536(s1)
    80004bbe:	21c4a783          	lw	a5,540(s1)
    80004bc2:	fef701e3          	beq	a4,a5,80004ba4 <piperead+0x34>
    80004bc6:	e85a                	sd	s6,16(sp)
    80004bc8:	a809                	j	80004bda <piperead+0x6a>
    80004bca:	e85a                	sd	s6,16(sp)
    80004bcc:	a039                	j	80004bda <piperead+0x6a>
      release(&pi->lock);
    80004bce:	8526                	mv	a0,s1
    80004bd0:	8bcfc0ef          	jal	80000c8c <release>
      return -1;
    80004bd4:	59fd                	li	s3,-1
    80004bd6:	a8b1                	j	80004c32 <piperead+0xc2>
    80004bd8:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004bda:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004bdc:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004bde:	05505263          	blez	s5,80004c22 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80004be2:	2184a783          	lw	a5,536(s1)
    80004be6:	21c4a703          	lw	a4,540(s1)
    80004bea:	02f70c63          	beq	a4,a5,80004c22 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004bee:	0017871b          	addiw	a4,a5,1
    80004bf2:	20e4ac23          	sw	a4,536(s1)
    80004bf6:	1ff7f793          	andi	a5,a5,511
    80004bfa:	97a6                	add	a5,a5,s1
    80004bfc:	0187c783          	lbu	a5,24(a5)
    80004c00:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004c04:	4685                	li	a3,1
    80004c06:	fbf40613          	addi	a2,s0,-65
    80004c0a:	85ca                	mv	a1,s2
    80004c0c:	058a3503          	ld	a0,88(s4)
    80004c10:	943fc0ef          	jal	80001552 <copyout>
    80004c14:	01650763          	beq	a0,s6,80004c22 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004c18:	2985                	addiw	s3,s3,1
    80004c1a:	0905                	addi	s2,s2,1
    80004c1c:	fd3a93e3          	bne	s5,s3,80004be2 <piperead+0x72>
    80004c20:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004c22:	21c48513          	addi	a0,s1,540
    80004c26:	934fd0ef          	jal	80001d5a <wakeup>
  release(&pi->lock);
    80004c2a:	8526                	mv	a0,s1
    80004c2c:	860fc0ef          	jal	80000c8c <release>
    80004c30:	6b42                	ld	s6,16(sp)
  return i;
}
    80004c32:	854e                	mv	a0,s3
    80004c34:	60a6                	ld	ra,72(sp)
    80004c36:	6406                	ld	s0,64(sp)
    80004c38:	74e2                	ld	s1,56(sp)
    80004c3a:	7942                	ld	s2,48(sp)
    80004c3c:	79a2                	ld	s3,40(sp)
    80004c3e:	7a02                	ld	s4,32(sp)
    80004c40:	6ae2                	ld	s5,24(sp)
    80004c42:	6161                	addi	sp,sp,80
    80004c44:	8082                	ret

0000000080004c46 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004c46:	1141                	addi	sp,sp,-16
    80004c48:	e422                	sd	s0,8(sp)
    80004c4a:	0800                	addi	s0,sp,16
    80004c4c:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004c4e:	8905                	andi	a0,a0,1
    80004c50:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004c52:	8b89                	andi	a5,a5,2
    80004c54:	c399                	beqz	a5,80004c5a <flags2perm+0x14>
      perm |= PTE_W;
    80004c56:	00456513          	ori	a0,a0,4
    return perm;
}
    80004c5a:	6422                	ld	s0,8(sp)
    80004c5c:	0141                	addi	sp,sp,16
    80004c5e:	8082                	ret

0000000080004c60 <exec>:

int
exec(char *path, char **argv)
{
    80004c60:	df010113          	addi	sp,sp,-528
    80004c64:	20113423          	sd	ra,520(sp)
    80004c68:	20813023          	sd	s0,512(sp)
    80004c6c:	ffa6                	sd	s1,504(sp)
    80004c6e:	fbca                	sd	s2,496(sp)
    80004c70:	0c00                	addi	s0,sp,528
    80004c72:	892a                	mv	s2,a0
    80004c74:	dea43c23          	sd	a0,-520(s0)
    80004c78:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004c7c:	cb3fc0ef          	jal	8000192e <myproc>
    80004c80:	84aa                	mv	s1,a0

  begin_op();
    80004c82:	dc6ff0ef          	jal	80004248 <begin_op>

  if((ip = namei(path)) == 0){
    80004c86:	854a                	mv	a0,s2
    80004c88:	c04ff0ef          	jal	8000408c <namei>
    80004c8c:	c931                	beqz	a0,80004ce0 <exec+0x80>
    80004c8e:	f3d2                	sd	s4,480(sp)
    80004c90:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004c92:	d21fe0ef          	jal	800039b2 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004c96:	04000713          	li	a4,64
    80004c9a:	4681                	li	a3,0
    80004c9c:	e5040613          	addi	a2,s0,-432
    80004ca0:	4581                	li	a1,0
    80004ca2:	8552                	mv	a0,s4
    80004ca4:	f63fe0ef          	jal	80003c06 <readi>
    80004ca8:	04000793          	li	a5,64
    80004cac:	00f51a63          	bne	a0,a5,80004cc0 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004cb0:	e5042703          	lw	a4,-432(s0)
    80004cb4:	464c47b7          	lui	a5,0x464c4
    80004cb8:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004cbc:	02f70663          	beq	a4,a5,80004ce8 <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004cc0:	8552                	mv	a0,s4
    80004cc2:	efbfe0ef          	jal	80003bbc <iunlockput>
    end_op();
    80004cc6:	decff0ef          	jal	800042b2 <end_op>
  }
  return -1;
    80004cca:	557d                	li	a0,-1
    80004ccc:	7a1e                	ld	s4,480(sp)
}
    80004cce:	20813083          	ld	ra,520(sp)
    80004cd2:	20013403          	ld	s0,512(sp)
    80004cd6:	74fe                	ld	s1,504(sp)
    80004cd8:	795e                	ld	s2,496(sp)
    80004cda:	21010113          	addi	sp,sp,528
    80004cde:	8082                	ret
    end_op();
    80004ce0:	dd2ff0ef          	jal	800042b2 <end_op>
    return -1;
    80004ce4:	557d                	li	a0,-1
    80004ce6:	b7e5                	j	80004cce <exec+0x6e>
    80004ce8:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004cea:	8526                	mv	a0,s1
    80004cec:	cebfc0ef          	jal	800019d6 <proc_pagetable>
    80004cf0:	8b2a                	mv	s6,a0
    80004cf2:	2c050b63          	beqz	a0,80004fc8 <exec+0x368>
    80004cf6:	f7ce                	sd	s3,488(sp)
    80004cf8:	efd6                	sd	s5,472(sp)
    80004cfa:	e7de                	sd	s7,456(sp)
    80004cfc:	e3e2                	sd	s8,448(sp)
    80004cfe:	ff66                	sd	s9,440(sp)
    80004d00:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004d02:	e7042d03          	lw	s10,-400(s0)
    80004d06:	e8845783          	lhu	a5,-376(s0)
    80004d0a:	12078963          	beqz	a5,80004e3c <exec+0x1dc>
    80004d0e:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004d10:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004d12:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004d14:	6c85                	lui	s9,0x1
    80004d16:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004d1a:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004d1e:	6a85                	lui	s5,0x1
    80004d20:	a085                	j	80004d80 <exec+0x120>
      panic("loadseg: address should exist");
    80004d22:	00004517          	auipc	a0,0x4
    80004d26:	97e50513          	addi	a0,a0,-1666 # 800086a0 <etext+0x6a0>
    80004d2a:	a6bfb0ef          	jal	80000794 <panic>
    if(sz - i < PGSIZE)
    80004d2e:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004d30:	8726                	mv	a4,s1
    80004d32:	012c06bb          	addw	a3,s8,s2
    80004d36:	4581                	li	a1,0
    80004d38:	8552                	mv	a0,s4
    80004d3a:	ecdfe0ef          	jal	80003c06 <readi>
    80004d3e:	2501                	sext.w	a0,a0
    80004d40:	24a49a63          	bne	s1,a0,80004f94 <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80004d44:	012a893b          	addw	s2,s5,s2
    80004d48:	03397363          	bgeu	s2,s3,80004d6e <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80004d4c:	02091593          	slli	a1,s2,0x20
    80004d50:	9181                	srli	a1,a1,0x20
    80004d52:	95de                	add	a1,a1,s7
    80004d54:	855a                	mv	a0,s6
    80004d56:	a80fc0ef          	jal	80000fd6 <walkaddr>
    80004d5a:	862a                	mv	a2,a0
    if(pa == 0)
    80004d5c:	d179                	beqz	a0,80004d22 <exec+0xc2>
    if(sz - i < PGSIZE)
    80004d5e:	412984bb          	subw	s1,s3,s2
    80004d62:	0004879b          	sext.w	a5,s1
    80004d66:	fcfcf4e3          	bgeu	s9,a5,80004d2e <exec+0xce>
    80004d6a:	84d6                	mv	s1,s5
    80004d6c:	b7c9                	j	80004d2e <exec+0xce>
    sz = sz1;
    80004d6e:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004d72:	2d85                	addiw	s11,s11,1
    80004d74:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80004d78:	e8845783          	lhu	a5,-376(s0)
    80004d7c:	08fdd063          	bge	s11,a5,80004dfc <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004d80:	2d01                	sext.w	s10,s10
    80004d82:	03800713          	li	a4,56
    80004d86:	86ea                	mv	a3,s10
    80004d88:	e1840613          	addi	a2,s0,-488
    80004d8c:	4581                	li	a1,0
    80004d8e:	8552                	mv	a0,s4
    80004d90:	e77fe0ef          	jal	80003c06 <readi>
    80004d94:	03800793          	li	a5,56
    80004d98:	1cf51663          	bne	a0,a5,80004f64 <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80004d9c:	e1842783          	lw	a5,-488(s0)
    80004da0:	4705                	li	a4,1
    80004da2:	fce798e3          	bne	a5,a4,80004d72 <exec+0x112>
    if(ph.memsz < ph.filesz)
    80004da6:	e4043483          	ld	s1,-448(s0)
    80004daa:	e3843783          	ld	a5,-456(s0)
    80004dae:	1af4ef63          	bltu	s1,a5,80004f6c <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004db2:	e2843783          	ld	a5,-472(s0)
    80004db6:	94be                	add	s1,s1,a5
    80004db8:	1af4ee63          	bltu	s1,a5,80004f74 <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80004dbc:	df043703          	ld	a4,-528(s0)
    80004dc0:	8ff9                	and	a5,a5,a4
    80004dc2:	1a079d63          	bnez	a5,80004f7c <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004dc6:	e1c42503          	lw	a0,-484(s0)
    80004dca:	e7dff0ef          	jal	80004c46 <flags2perm>
    80004dce:	86aa                	mv	a3,a0
    80004dd0:	8626                	mv	a2,s1
    80004dd2:	85ca                	mv	a1,s2
    80004dd4:	855a                	mv	a0,s6
    80004dd6:	d68fc0ef          	jal	8000133e <uvmalloc>
    80004dda:	e0a43423          	sd	a0,-504(s0)
    80004dde:	1a050363          	beqz	a0,80004f84 <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004de2:	e2843b83          	ld	s7,-472(s0)
    80004de6:	e2042c03          	lw	s8,-480(s0)
    80004dea:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004dee:	00098463          	beqz	s3,80004df6 <exec+0x196>
    80004df2:	4901                	li	s2,0
    80004df4:	bfa1                	j	80004d4c <exec+0xec>
    sz = sz1;
    80004df6:	e0843903          	ld	s2,-504(s0)
    80004dfa:	bfa5                	j	80004d72 <exec+0x112>
    80004dfc:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004dfe:	8552                	mv	a0,s4
    80004e00:	dbdfe0ef          	jal	80003bbc <iunlockput>
  end_op();
    80004e04:	caeff0ef          	jal	800042b2 <end_op>
  p = myproc();
    80004e08:	b27fc0ef          	jal	8000192e <myproc>
    80004e0c:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004e0e:	05053c83          	ld	s9,80(a0)
  sz = PGROUNDUP(sz);
    80004e12:	6985                	lui	s3,0x1
    80004e14:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004e16:	99ca                	add	s3,s3,s2
    80004e18:	77fd                	lui	a5,0xfffff
    80004e1a:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004e1e:	4691                	li	a3,4
    80004e20:	6609                	lui	a2,0x2
    80004e22:	964e                	add	a2,a2,s3
    80004e24:	85ce                	mv	a1,s3
    80004e26:	855a                	mv	a0,s6
    80004e28:	d16fc0ef          	jal	8000133e <uvmalloc>
    80004e2c:	892a                	mv	s2,a0
    80004e2e:	e0a43423          	sd	a0,-504(s0)
    80004e32:	e519                	bnez	a0,80004e40 <exec+0x1e0>
  if(pagetable)
    80004e34:	e1343423          	sd	s3,-504(s0)
    80004e38:	4a01                	li	s4,0
    80004e3a:	aab1                	j	80004f96 <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004e3c:	4901                	li	s2,0
    80004e3e:	b7c1                	j	80004dfe <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004e40:	75f9                	lui	a1,0xffffe
    80004e42:	95aa                	add	a1,a1,a0
    80004e44:	855a                	mv	a0,s6
    80004e46:	ee2fc0ef          	jal	80001528 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004e4a:	7bfd                	lui	s7,0xfffff
    80004e4c:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004e4e:	e0043783          	ld	a5,-512(s0)
    80004e52:	6388                	ld	a0,0(a5)
    80004e54:	cd39                	beqz	a0,80004eb2 <exec+0x252>
    80004e56:	e9040993          	addi	s3,s0,-368
    80004e5a:	f9040c13          	addi	s8,s0,-112
    80004e5e:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004e60:	fd9fb0ef          	jal	80000e38 <strlen>
    80004e64:	0015079b          	addiw	a5,a0,1
    80004e68:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004e6c:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004e70:	11796e63          	bltu	s2,s7,80004f8c <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004e74:	e0043d03          	ld	s10,-512(s0)
    80004e78:	000d3a03          	ld	s4,0(s10)
    80004e7c:	8552                	mv	a0,s4
    80004e7e:	fbbfb0ef          	jal	80000e38 <strlen>
    80004e82:	0015069b          	addiw	a3,a0,1
    80004e86:	8652                	mv	a2,s4
    80004e88:	85ca                	mv	a1,s2
    80004e8a:	855a                	mv	a0,s6
    80004e8c:	ec6fc0ef          	jal	80001552 <copyout>
    80004e90:	10054063          	bltz	a0,80004f90 <exec+0x330>
    ustack[argc] = sp;
    80004e94:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004e98:	0485                	addi	s1,s1,1
    80004e9a:	008d0793          	addi	a5,s10,8
    80004e9e:	e0f43023          	sd	a5,-512(s0)
    80004ea2:	008d3503          	ld	a0,8(s10)
    80004ea6:	c909                	beqz	a0,80004eb8 <exec+0x258>
    if(argc >= MAXARG)
    80004ea8:	09a1                	addi	s3,s3,8
    80004eaa:	fb899be3          	bne	s3,s8,80004e60 <exec+0x200>
  ip = 0;
    80004eae:	4a01                	li	s4,0
    80004eb0:	a0dd                	j	80004f96 <exec+0x336>
  sp = sz;
    80004eb2:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004eb6:	4481                	li	s1,0
  ustack[argc] = 0;
    80004eb8:	00349793          	slli	a5,s1,0x3
    80004ebc:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffda368>
    80004ec0:	97a2                	add	a5,a5,s0
    80004ec2:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004ec6:	00148693          	addi	a3,s1,1
    80004eca:	068e                	slli	a3,a3,0x3
    80004ecc:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004ed0:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004ed4:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004ed8:	f5796ee3          	bltu	s2,s7,80004e34 <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004edc:	e9040613          	addi	a2,s0,-368
    80004ee0:	85ca                	mv	a1,s2
    80004ee2:	855a                	mv	a0,s6
    80004ee4:	e6efc0ef          	jal	80001552 <copyout>
    80004ee8:	0e054263          	bltz	a0,80004fcc <exec+0x36c>
  p->trapframe->a1 = sp;
    80004eec:	060ab783          	ld	a5,96(s5) # 1060 <_entry-0x7fffefa0>
    80004ef0:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004ef4:	df843783          	ld	a5,-520(s0)
    80004ef8:	0007c703          	lbu	a4,0(a5)
    80004efc:	cf11                	beqz	a4,80004f18 <exec+0x2b8>
    80004efe:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004f00:	02f00693          	li	a3,47
    80004f04:	a039                	j	80004f12 <exec+0x2b2>
      last = s+1;
    80004f06:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004f0a:	0785                	addi	a5,a5,1
    80004f0c:	fff7c703          	lbu	a4,-1(a5)
    80004f10:	c701                	beqz	a4,80004f18 <exec+0x2b8>
    if(*s == '/')
    80004f12:	fed71ce3          	bne	a4,a3,80004f0a <exec+0x2aa>
    80004f16:	bfc5                	j	80004f06 <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004f18:	4641                	li	a2,16
    80004f1a:	df843583          	ld	a1,-520(s0)
    80004f1e:	160a8513          	addi	a0,s5,352
    80004f22:	ee5fb0ef          	jal	80000e06 <safestrcpy>
  oldpagetable = p->pagetable;
    80004f26:	058ab503          	ld	a0,88(s5)
  p->pagetable = pagetable;
    80004f2a:	056abc23          	sd	s6,88(s5)
  p->sz = sz;
    80004f2e:	e0843783          	ld	a5,-504(s0)
    80004f32:	04fab823          	sd	a5,80(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004f36:	060ab783          	ld	a5,96(s5)
    80004f3a:	e6843703          	ld	a4,-408(s0)
    80004f3e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004f40:	060ab783          	ld	a5,96(s5)
    80004f44:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004f48:	85e6                	mv	a1,s9
    80004f4a:	b11fc0ef          	jal	80001a5a <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004f4e:	0004851b          	sext.w	a0,s1
    80004f52:	79be                	ld	s3,488(sp)
    80004f54:	7a1e                	ld	s4,480(sp)
    80004f56:	6afe                	ld	s5,472(sp)
    80004f58:	6b5e                	ld	s6,464(sp)
    80004f5a:	6bbe                	ld	s7,456(sp)
    80004f5c:	6c1e                	ld	s8,448(sp)
    80004f5e:	7cfa                	ld	s9,440(sp)
    80004f60:	7d5a                	ld	s10,432(sp)
    80004f62:	b3b5                	j	80004cce <exec+0x6e>
    80004f64:	e1243423          	sd	s2,-504(s0)
    80004f68:	7dba                	ld	s11,424(sp)
    80004f6a:	a035                	j	80004f96 <exec+0x336>
    80004f6c:	e1243423          	sd	s2,-504(s0)
    80004f70:	7dba                	ld	s11,424(sp)
    80004f72:	a015                	j	80004f96 <exec+0x336>
    80004f74:	e1243423          	sd	s2,-504(s0)
    80004f78:	7dba                	ld	s11,424(sp)
    80004f7a:	a831                	j	80004f96 <exec+0x336>
    80004f7c:	e1243423          	sd	s2,-504(s0)
    80004f80:	7dba                	ld	s11,424(sp)
    80004f82:	a811                	j	80004f96 <exec+0x336>
    80004f84:	e1243423          	sd	s2,-504(s0)
    80004f88:	7dba                	ld	s11,424(sp)
    80004f8a:	a031                	j	80004f96 <exec+0x336>
  ip = 0;
    80004f8c:	4a01                	li	s4,0
    80004f8e:	a021                	j	80004f96 <exec+0x336>
    80004f90:	4a01                	li	s4,0
  if(pagetable)
    80004f92:	a011                	j	80004f96 <exec+0x336>
    80004f94:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004f96:	e0843583          	ld	a1,-504(s0)
    80004f9a:	855a                	mv	a0,s6
    80004f9c:	abffc0ef          	jal	80001a5a <proc_freepagetable>
  return -1;
    80004fa0:	557d                	li	a0,-1
  if(ip){
    80004fa2:	000a1b63          	bnez	s4,80004fb8 <exec+0x358>
    80004fa6:	79be                	ld	s3,488(sp)
    80004fa8:	7a1e                	ld	s4,480(sp)
    80004faa:	6afe                	ld	s5,472(sp)
    80004fac:	6b5e                	ld	s6,464(sp)
    80004fae:	6bbe                	ld	s7,456(sp)
    80004fb0:	6c1e                	ld	s8,448(sp)
    80004fb2:	7cfa                	ld	s9,440(sp)
    80004fb4:	7d5a                	ld	s10,432(sp)
    80004fb6:	bb21                	j	80004cce <exec+0x6e>
    80004fb8:	79be                	ld	s3,488(sp)
    80004fba:	6afe                	ld	s5,472(sp)
    80004fbc:	6b5e                	ld	s6,464(sp)
    80004fbe:	6bbe                	ld	s7,456(sp)
    80004fc0:	6c1e                	ld	s8,448(sp)
    80004fc2:	7cfa                	ld	s9,440(sp)
    80004fc4:	7d5a                	ld	s10,432(sp)
    80004fc6:	b9ed                	j	80004cc0 <exec+0x60>
    80004fc8:	6b5e                	ld	s6,464(sp)
    80004fca:	b9dd                	j	80004cc0 <exec+0x60>
  sz = sz1;
    80004fcc:	e0843983          	ld	s3,-504(s0)
    80004fd0:	b595                	j	80004e34 <exec+0x1d4>

0000000080004fd2 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004fd2:	7179                	addi	sp,sp,-48
    80004fd4:	f406                	sd	ra,40(sp)
    80004fd6:	f022                	sd	s0,32(sp)
    80004fd8:	ec26                	sd	s1,24(sp)
    80004fda:	e84a                	sd	s2,16(sp)
    80004fdc:	1800                	addi	s0,sp,48
    80004fde:	892e                	mv	s2,a1
    80004fe0:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004fe2:	fdc40593          	addi	a1,s0,-36
    80004fe6:	fa1fd0ef          	jal	80002f86 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004fea:	fdc42703          	lw	a4,-36(s0)
    80004fee:	47bd                	li	a5,15
    80004ff0:	02e7e963          	bltu	a5,a4,80005022 <argfd+0x50>
    80004ff4:	93bfc0ef          	jal	8000192e <myproc>
    80004ff8:	fdc42703          	lw	a4,-36(s0)
    80004ffc:	01a70793          	addi	a5,a4,26
    80005000:	078e                	slli	a5,a5,0x3
    80005002:	953e                	add	a0,a0,a5
    80005004:	651c                	ld	a5,8(a0)
    80005006:	c385                	beqz	a5,80005026 <argfd+0x54>
    return -1;
  if(pfd)
    80005008:	00090463          	beqz	s2,80005010 <argfd+0x3e>
    *pfd = fd;
    8000500c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005010:	4501                	li	a0,0
  if(pf)
    80005012:	c091                	beqz	s1,80005016 <argfd+0x44>
    *pf = f;
    80005014:	e09c                	sd	a5,0(s1)
}
    80005016:	70a2                	ld	ra,40(sp)
    80005018:	7402                	ld	s0,32(sp)
    8000501a:	64e2                	ld	s1,24(sp)
    8000501c:	6942                	ld	s2,16(sp)
    8000501e:	6145                	addi	sp,sp,48
    80005020:	8082                	ret
    return -1;
    80005022:	557d                	li	a0,-1
    80005024:	bfcd                	j	80005016 <argfd+0x44>
    80005026:	557d                	li	a0,-1
    80005028:	b7fd                	j	80005016 <argfd+0x44>

000000008000502a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000502a:	1101                	addi	sp,sp,-32
    8000502c:	ec06                	sd	ra,24(sp)
    8000502e:	e822                	sd	s0,16(sp)
    80005030:	e426                	sd	s1,8(sp)
    80005032:	1000                	addi	s0,sp,32
    80005034:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005036:	8f9fc0ef          	jal	8000192e <myproc>
    8000503a:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000503c:	0d850793          	addi	a5,a0,216
    80005040:	4501                	li	a0,0
    80005042:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005044:	6398                	ld	a4,0(a5)
    80005046:	cb19                	beqz	a4,8000505c <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80005048:	2505                	addiw	a0,a0,1
    8000504a:	07a1                	addi	a5,a5,8
    8000504c:	fed51ce3          	bne	a0,a3,80005044 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005050:	557d                	li	a0,-1
}
    80005052:	60e2                	ld	ra,24(sp)
    80005054:	6442                	ld	s0,16(sp)
    80005056:	64a2                	ld	s1,8(sp)
    80005058:	6105                	addi	sp,sp,32
    8000505a:	8082                	ret
      p->ofile[fd] = f;
    8000505c:	01a50793          	addi	a5,a0,26
    80005060:	078e                	slli	a5,a5,0x3
    80005062:	963e                	add	a2,a2,a5
    80005064:	e604                	sd	s1,8(a2)
      return fd;
    80005066:	b7f5                	j	80005052 <fdalloc+0x28>

0000000080005068 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005068:	715d                	addi	sp,sp,-80
    8000506a:	e486                	sd	ra,72(sp)
    8000506c:	e0a2                	sd	s0,64(sp)
    8000506e:	fc26                	sd	s1,56(sp)
    80005070:	f84a                	sd	s2,48(sp)
    80005072:	f44e                	sd	s3,40(sp)
    80005074:	ec56                	sd	s5,24(sp)
    80005076:	e85a                	sd	s6,16(sp)
    80005078:	0880                	addi	s0,sp,80
    8000507a:	8b2e                	mv	s6,a1
    8000507c:	89b2                	mv	s3,a2
    8000507e:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005080:	fb040593          	addi	a1,s0,-80
    80005084:	822ff0ef          	jal	800040a6 <nameiparent>
    80005088:	84aa                	mv	s1,a0
    8000508a:	10050a63          	beqz	a0,8000519e <create+0x136>
    return 0;

  ilock(dp);
    8000508e:	925fe0ef          	jal	800039b2 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005092:	4601                	li	a2,0
    80005094:	fb040593          	addi	a1,s0,-80
    80005098:	8526                	mv	a0,s1
    8000509a:	d8dfe0ef          	jal	80003e26 <dirlookup>
    8000509e:	8aaa                	mv	s5,a0
    800050a0:	c129                	beqz	a0,800050e2 <create+0x7a>
    iunlockput(dp);
    800050a2:	8526                	mv	a0,s1
    800050a4:	b19fe0ef          	jal	80003bbc <iunlockput>
    ilock(ip);
    800050a8:	8556                	mv	a0,s5
    800050aa:	909fe0ef          	jal	800039b2 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800050ae:	4789                	li	a5,2
    800050b0:	02fb1463          	bne	s6,a5,800050d8 <create+0x70>
    800050b4:	044ad783          	lhu	a5,68(s5)
    800050b8:	37f9                	addiw	a5,a5,-2
    800050ba:	17c2                	slli	a5,a5,0x30
    800050bc:	93c1                	srli	a5,a5,0x30
    800050be:	4705                	li	a4,1
    800050c0:	00f76c63          	bltu	a4,a5,800050d8 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800050c4:	8556                	mv	a0,s5
    800050c6:	60a6                	ld	ra,72(sp)
    800050c8:	6406                	ld	s0,64(sp)
    800050ca:	74e2                	ld	s1,56(sp)
    800050cc:	7942                	ld	s2,48(sp)
    800050ce:	79a2                	ld	s3,40(sp)
    800050d0:	6ae2                	ld	s5,24(sp)
    800050d2:	6b42                	ld	s6,16(sp)
    800050d4:	6161                	addi	sp,sp,80
    800050d6:	8082                	ret
    iunlockput(ip);
    800050d8:	8556                	mv	a0,s5
    800050da:	ae3fe0ef          	jal	80003bbc <iunlockput>
    return 0;
    800050de:	4a81                	li	s5,0
    800050e0:	b7d5                	j	800050c4 <create+0x5c>
    800050e2:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    800050e4:	85da                	mv	a1,s6
    800050e6:	4088                	lw	a0,0(s1)
    800050e8:	f5afe0ef          	jal	80003842 <ialloc>
    800050ec:	8a2a                	mv	s4,a0
    800050ee:	cd15                	beqz	a0,8000512a <create+0xc2>
  ilock(ip);
    800050f0:	8c3fe0ef          	jal	800039b2 <ilock>
  ip->major = major;
    800050f4:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800050f8:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800050fc:	4905                	li	s2,1
    800050fe:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80005102:	8552                	mv	a0,s4
    80005104:	ffafe0ef          	jal	800038fe <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005108:	032b0763          	beq	s6,s2,80005136 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    8000510c:	004a2603          	lw	a2,4(s4)
    80005110:	fb040593          	addi	a1,s0,-80
    80005114:	8526                	mv	a0,s1
    80005116:	eddfe0ef          	jal	80003ff2 <dirlink>
    8000511a:	06054563          	bltz	a0,80005184 <create+0x11c>
  iunlockput(dp);
    8000511e:	8526                	mv	a0,s1
    80005120:	a9dfe0ef          	jal	80003bbc <iunlockput>
  return ip;
    80005124:	8ad2                	mv	s5,s4
    80005126:	7a02                	ld	s4,32(sp)
    80005128:	bf71                	j	800050c4 <create+0x5c>
    iunlockput(dp);
    8000512a:	8526                	mv	a0,s1
    8000512c:	a91fe0ef          	jal	80003bbc <iunlockput>
    return 0;
    80005130:	8ad2                	mv	s5,s4
    80005132:	7a02                	ld	s4,32(sp)
    80005134:	bf41                	j	800050c4 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005136:	004a2603          	lw	a2,4(s4)
    8000513a:	00003597          	auipc	a1,0x3
    8000513e:	58658593          	addi	a1,a1,1414 # 800086c0 <etext+0x6c0>
    80005142:	8552                	mv	a0,s4
    80005144:	eaffe0ef          	jal	80003ff2 <dirlink>
    80005148:	02054e63          	bltz	a0,80005184 <create+0x11c>
    8000514c:	40d0                	lw	a2,4(s1)
    8000514e:	00003597          	auipc	a1,0x3
    80005152:	57a58593          	addi	a1,a1,1402 # 800086c8 <etext+0x6c8>
    80005156:	8552                	mv	a0,s4
    80005158:	e9bfe0ef          	jal	80003ff2 <dirlink>
    8000515c:	02054463          	bltz	a0,80005184 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80005160:	004a2603          	lw	a2,4(s4)
    80005164:	fb040593          	addi	a1,s0,-80
    80005168:	8526                	mv	a0,s1
    8000516a:	e89fe0ef          	jal	80003ff2 <dirlink>
    8000516e:	00054b63          	bltz	a0,80005184 <create+0x11c>
    dp->nlink++;  // for ".."
    80005172:	04a4d783          	lhu	a5,74(s1)
    80005176:	2785                	addiw	a5,a5,1
    80005178:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000517c:	8526                	mv	a0,s1
    8000517e:	f80fe0ef          	jal	800038fe <iupdate>
    80005182:	bf71                	j	8000511e <create+0xb6>
  ip->nlink = 0;
    80005184:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80005188:	8552                	mv	a0,s4
    8000518a:	f74fe0ef          	jal	800038fe <iupdate>
  iunlockput(ip);
    8000518e:	8552                	mv	a0,s4
    80005190:	a2dfe0ef          	jal	80003bbc <iunlockput>
  iunlockput(dp);
    80005194:	8526                	mv	a0,s1
    80005196:	a27fe0ef          	jal	80003bbc <iunlockput>
  return 0;
    8000519a:	7a02                	ld	s4,32(sp)
    8000519c:	b725                	j	800050c4 <create+0x5c>
    return 0;
    8000519e:	8aaa                	mv	s5,a0
    800051a0:	b715                	j	800050c4 <create+0x5c>

00000000800051a2 <sys_dup>:
{
    800051a2:	7179                	addi	sp,sp,-48
    800051a4:	f406                	sd	ra,40(sp)
    800051a6:	f022                	sd	s0,32(sp)
    800051a8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800051aa:	fd840613          	addi	a2,s0,-40
    800051ae:	4581                	li	a1,0
    800051b0:	4501                	li	a0,0
    800051b2:	e21ff0ef          	jal	80004fd2 <argfd>
    return -1;
    800051b6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800051b8:	02054363          	bltz	a0,800051de <sys_dup+0x3c>
    800051bc:	ec26                	sd	s1,24(sp)
    800051be:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800051c0:	fd843903          	ld	s2,-40(s0)
    800051c4:	854a                	mv	a0,s2
    800051c6:	e65ff0ef          	jal	8000502a <fdalloc>
    800051ca:	84aa                	mv	s1,a0
    return -1;
    800051cc:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800051ce:	00054d63          	bltz	a0,800051e8 <sys_dup+0x46>
  filedup(f);
    800051d2:	854a                	mv	a0,s2
    800051d4:	c48ff0ef          	jal	8000461c <filedup>
  return fd;
    800051d8:	87a6                	mv	a5,s1
    800051da:	64e2                	ld	s1,24(sp)
    800051dc:	6942                	ld	s2,16(sp)
}
    800051de:	853e                	mv	a0,a5
    800051e0:	70a2                	ld	ra,40(sp)
    800051e2:	7402                	ld	s0,32(sp)
    800051e4:	6145                	addi	sp,sp,48
    800051e6:	8082                	ret
    800051e8:	64e2                	ld	s1,24(sp)
    800051ea:	6942                	ld	s2,16(sp)
    800051ec:	bfcd                	j	800051de <sys_dup+0x3c>

00000000800051ee <sys_read>:
{
    800051ee:	7179                	addi	sp,sp,-48
    800051f0:	f406                	sd	ra,40(sp)
    800051f2:	f022                	sd	s0,32(sp)
    800051f4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800051f6:	fd840593          	addi	a1,s0,-40
    800051fa:	4505                	li	a0,1
    800051fc:	da7fd0ef          	jal	80002fa2 <argaddr>
  argint(2, &n);
    80005200:	fe440593          	addi	a1,s0,-28
    80005204:	4509                	li	a0,2
    80005206:	d81fd0ef          	jal	80002f86 <argint>
  if(argfd(0, 0, &f) < 0)
    8000520a:	fe840613          	addi	a2,s0,-24
    8000520e:	4581                	li	a1,0
    80005210:	4501                	li	a0,0
    80005212:	dc1ff0ef          	jal	80004fd2 <argfd>
    80005216:	87aa                	mv	a5,a0
    return -1;
    80005218:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000521a:	0007ca63          	bltz	a5,8000522e <sys_read+0x40>
  return fileread(f, p, n);
    8000521e:	fe442603          	lw	a2,-28(s0)
    80005222:	fd843583          	ld	a1,-40(s0)
    80005226:	fe843503          	ld	a0,-24(s0)
    8000522a:	d58ff0ef          	jal	80004782 <fileread>
}
    8000522e:	70a2                	ld	ra,40(sp)
    80005230:	7402                	ld	s0,32(sp)
    80005232:	6145                	addi	sp,sp,48
    80005234:	8082                	ret

0000000080005236 <sys_write>:
{
    80005236:	7179                	addi	sp,sp,-48
    80005238:	f406                	sd	ra,40(sp)
    8000523a:	f022                	sd	s0,32(sp)
    8000523c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000523e:	fd840593          	addi	a1,s0,-40
    80005242:	4505                	li	a0,1
    80005244:	d5ffd0ef          	jal	80002fa2 <argaddr>
  argint(2, &n);
    80005248:	fe440593          	addi	a1,s0,-28
    8000524c:	4509                	li	a0,2
    8000524e:	d39fd0ef          	jal	80002f86 <argint>
  if(argfd(0, 0, &f) < 0)
    80005252:	fe840613          	addi	a2,s0,-24
    80005256:	4581                	li	a1,0
    80005258:	4501                	li	a0,0
    8000525a:	d79ff0ef          	jal	80004fd2 <argfd>
    8000525e:	87aa                	mv	a5,a0
    return -1;
    80005260:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005262:	0007ca63          	bltz	a5,80005276 <sys_write+0x40>
  return filewrite(f, p, n);
    80005266:	fe442603          	lw	a2,-28(s0)
    8000526a:	fd843583          	ld	a1,-40(s0)
    8000526e:	fe843503          	ld	a0,-24(s0)
    80005272:	dceff0ef          	jal	80004840 <filewrite>
}
    80005276:	70a2                	ld	ra,40(sp)
    80005278:	7402                	ld	s0,32(sp)
    8000527a:	6145                	addi	sp,sp,48
    8000527c:	8082                	ret

000000008000527e <sys_close>:
{
    8000527e:	1101                	addi	sp,sp,-32
    80005280:	ec06                	sd	ra,24(sp)
    80005282:	e822                	sd	s0,16(sp)
    80005284:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005286:	fe040613          	addi	a2,s0,-32
    8000528a:	fec40593          	addi	a1,s0,-20
    8000528e:	4501                	li	a0,0
    80005290:	d43ff0ef          	jal	80004fd2 <argfd>
    return -1;
    80005294:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005296:	02054063          	bltz	a0,800052b6 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    8000529a:	e94fc0ef          	jal	8000192e <myproc>
    8000529e:	fec42783          	lw	a5,-20(s0)
    800052a2:	07e9                	addi	a5,a5,26
    800052a4:	078e                	slli	a5,a5,0x3
    800052a6:	953e                	add	a0,a0,a5
    800052a8:	00053423          	sd	zero,8(a0)
  fileclose(f);
    800052ac:	fe043503          	ld	a0,-32(s0)
    800052b0:	bb2ff0ef          	jal	80004662 <fileclose>
  return 0;
    800052b4:	4781                	li	a5,0
}
    800052b6:	853e                	mv	a0,a5
    800052b8:	60e2                	ld	ra,24(sp)
    800052ba:	6442                	ld	s0,16(sp)
    800052bc:	6105                	addi	sp,sp,32
    800052be:	8082                	ret

00000000800052c0 <sys_fstat>:
{
    800052c0:	1101                	addi	sp,sp,-32
    800052c2:	ec06                	sd	ra,24(sp)
    800052c4:	e822                	sd	s0,16(sp)
    800052c6:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800052c8:	fe040593          	addi	a1,s0,-32
    800052cc:	4505                	li	a0,1
    800052ce:	cd5fd0ef          	jal	80002fa2 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800052d2:	fe840613          	addi	a2,s0,-24
    800052d6:	4581                	li	a1,0
    800052d8:	4501                	li	a0,0
    800052da:	cf9ff0ef          	jal	80004fd2 <argfd>
    800052de:	87aa                	mv	a5,a0
    return -1;
    800052e0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800052e2:	0007c863          	bltz	a5,800052f2 <sys_fstat+0x32>
  return filestat(f, st);
    800052e6:	fe043583          	ld	a1,-32(s0)
    800052ea:	fe843503          	ld	a0,-24(s0)
    800052ee:	c36ff0ef          	jal	80004724 <filestat>
}
    800052f2:	60e2                	ld	ra,24(sp)
    800052f4:	6442                	ld	s0,16(sp)
    800052f6:	6105                	addi	sp,sp,32
    800052f8:	8082                	ret

00000000800052fa <sys_link>:
{
    800052fa:	7169                	addi	sp,sp,-304
    800052fc:	f606                	sd	ra,296(sp)
    800052fe:	f222                	sd	s0,288(sp)
    80005300:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005302:	08000613          	li	a2,128
    80005306:	ed040593          	addi	a1,s0,-304
    8000530a:	4501                	li	a0,0
    8000530c:	cb3fd0ef          	jal	80002fbe <argstr>
    return -1;
    80005310:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005312:	0c054e63          	bltz	a0,800053ee <sys_link+0xf4>
    80005316:	08000613          	li	a2,128
    8000531a:	f5040593          	addi	a1,s0,-176
    8000531e:	4505                	li	a0,1
    80005320:	c9ffd0ef          	jal	80002fbe <argstr>
    return -1;
    80005324:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005326:	0c054463          	bltz	a0,800053ee <sys_link+0xf4>
    8000532a:	ee26                	sd	s1,280(sp)
  begin_op();
    8000532c:	f1dfe0ef          	jal	80004248 <begin_op>
  if((ip = namei(old)) == 0){
    80005330:	ed040513          	addi	a0,s0,-304
    80005334:	d59fe0ef          	jal	8000408c <namei>
    80005338:	84aa                	mv	s1,a0
    8000533a:	c53d                	beqz	a0,800053a8 <sys_link+0xae>
  ilock(ip);
    8000533c:	e76fe0ef          	jal	800039b2 <ilock>
  if(ip->type == T_DIR){
    80005340:	04449703          	lh	a4,68(s1)
    80005344:	4785                	li	a5,1
    80005346:	06f70663          	beq	a4,a5,800053b2 <sys_link+0xb8>
    8000534a:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    8000534c:	04a4d783          	lhu	a5,74(s1)
    80005350:	2785                	addiw	a5,a5,1
    80005352:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005356:	8526                	mv	a0,s1
    80005358:	da6fe0ef          	jal	800038fe <iupdate>
  iunlock(ip);
    8000535c:	8526                	mv	a0,s1
    8000535e:	f02fe0ef          	jal	80003a60 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005362:	fd040593          	addi	a1,s0,-48
    80005366:	f5040513          	addi	a0,s0,-176
    8000536a:	d3dfe0ef          	jal	800040a6 <nameiparent>
    8000536e:	892a                	mv	s2,a0
    80005370:	cd21                	beqz	a0,800053c8 <sys_link+0xce>
  ilock(dp);
    80005372:	e40fe0ef          	jal	800039b2 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005376:	00092703          	lw	a4,0(s2)
    8000537a:	409c                	lw	a5,0(s1)
    8000537c:	04f71363          	bne	a4,a5,800053c2 <sys_link+0xc8>
    80005380:	40d0                	lw	a2,4(s1)
    80005382:	fd040593          	addi	a1,s0,-48
    80005386:	854a                	mv	a0,s2
    80005388:	c6bfe0ef          	jal	80003ff2 <dirlink>
    8000538c:	02054b63          	bltz	a0,800053c2 <sys_link+0xc8>
  iunlockput(dp);
    80005390:	854a                	mv	a0,s2
    80005392:	82bfe0ef          	jal	80003bbc <iunlockput>
  iput(ip);
    80005396:	8526                	mv	a0,s1
    80005398:	f9cfe0ef          	jal	80003b34 <iput>
  end_op();
    8000539c:	f17fe0ef          	jal	800042b2 <end_op>
  return 0;
    800053a0:	4781                	li	a5,0
    800053a2:	64f2                	ld	s1,280(sp)
    800053a4:	6952                	ld	s2,272(sp)
    800053a6:	a0a1                	j	800053ee <sys_link+0xf4>
    end_op();
    800053a8:	f0bfe0ef          	jal	800042b2 <end_op>
    return -1;
    800053ac:	57fd                	li	a5,-1
    800053ae:	64f2                	ld	s1,280(sp)
    800053b0:	a83d                	j	800053ee <sys_link+0xf4>
    iunlockput(ip);
    800053b2:	8526                	mv	a0,s1
    800053b4:	809fe0ef          	jal	80003bbc <iunlockput>
    end_op();
    800053b8:	efbfe0ef          	jal	800042b2 <end_op>
    return -1;
    800053bc:	57fd                	li	a5,-1
    800053be:	64f2                	ld	s1,280(sp)
    800053c0:	a03d                	j	800053ee <sys_link+0xf4>
    iunlockput(dp);
    800053c2:	854a                	mv	a0,s2
    800053c4:	ff8fe0ef          	jal	80003bbc <iunlockput>
  ilock(ip);
    800053c8:	8526                	mv	a0,s1
    800053ca:	de8fe0ef          	jal	800039b2 <ilock>
  ip->nlink--;
    800053ce:	04a4d783          	lhu	a5,74(s1)
    800053d2:	37fd                	addiw	a5,a5,-1
    800053d4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800053d8:	8526                	mv	a0,s1
    800053da:	d24fe0ef          	jal	800038fe <iupdate>
  iunlockput(ip);
    800053de:	8526                	mv	a0,s1
    800053e0:	fdcfe0ef          	jal	80003bbc <iunlockput>
  end_op();
    800053e4:	ecffe0ef          	jal	800042b2 <end_op>
  return -1;
    800053e8:	57fd                	li	a5,-1
    800053ea:	64f2                	ld	s1,280(sp)
    800053ec:	6952                	ld	s2,272(sp)
}
    800053ee:	853e                	mv	a0,a5
    800053f0:	70b2                	ld	ra,296(sp)
    800053f2:	7412                	ld	s0,288(sp)
    800053f4:	6155                	addi	sp,sp,304
    800053f6:	8082                	ret

00000000800053f8 <sys_unlink>:
{
    800053f8:	7151                	addi	sp,sp,-240
    800053fa:	f586                	sd	ra,232(sp)
    800053fc:	f1a2                	sd	s0,224(sp)
    800053fe:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005400:	08000613          	li	a2,128
    80005404:	f3040593          	addi	a1,s0,-208
    80005408:	4501                	li	a0,0
    8000540a:	bb5fd0ef          	jal	80002fbe <argstr>
    8000540e:	16054063          	bltz	a0,8000556e <sys_unlink+0x176>
    80005412:	eda6                	sd	s1,216(sp)
  begin_op();
    80005414:	e35fe0ef          	jal	80004248 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005418:	fb040593          	addi	a1,s0,-80
    8000541c:	f3040513          	addi	a0,s0,-208
    80005420:	c87fe0ef          	jal	800040a6 <nameiparent>
    80005424:	84aa                	mv	s1,a0
    80005426:	c945                	beqz	a0,800054d6 <sys_unlink+0xde>
  ilock(dp);
    80005428:	d8afe0ef          	jal	800039b2 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000542c:	00003597          	auipc	a1,0x3
    80005430:	29458593          	addi	a1,a1,660 # 800086c0 <etext+0x6c0>
    80005434:	fb040513          	addi	a0,s0,-80
    80005438:	9d9fe0ef          	jal	80003e10 <namecmp>
    8000543c:	10050e63          	beqz	a0,80005558 <sys_unlink+0x160>
    80005440:	00003597          	auipc	a1,0x3
    80005444:	28858593          	addi	a1,a1,648 # 800086c8 <etext+0x6c8>
    80005448:	fb040513          	addi	a0,s0,-80
    8000544c:	9c5fe0ef          	jal	80003e10 <namecmp>
    80005450:	10050463          	beqz	a0,80005558 <sys_unlink+0x160>
    80005454:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005456:	f2c40613          	addi	a2,s0,-212
    8000545a:	fb040593          	addi	a1,s0,-80
    8000545e:	8526                	mv	a0,s1
    80005460:	9c7fe0ef          	jal	80003e26 <dirlookup>
    80005464:	892a                	mv	s2,a0
    80005466:	0e050863          	beqz	a0,80005556 <sys_unlink+0x15e>
  ilock(ip);
    8000546a:	d48fe0ef          	jal	800039b2 <ilock>
  if(ip->nlink < 1)
    8000546e:	04a91783          	lh	a5,74(s2)
    80005472:	06f05763          	blez	a5,800054e0 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005476:	04491703          	lh	a4,68(s2)
    8000547a:	4785                	li	a5,1
    8000547c:	06f70963          	beq	a4,a5,800054ee <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80005480:	4641                	li	a2,16
    80005482:	4581                	li	a1,0
    80005484:	fc040513          	addi	a0,s0,-64
    80005488:	841fb0ef          	jal	80000cc8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000548c:	4741                	li	a4,16
    8000548e:	f2c42683          	lw	a3,-212(s0)
    80005492:	fc040613          	addi	a2,s0,-64
    80005496:	4581                	li	a1,0
    80005498:	8526                	mv	a0,s1
    8000549a:	869fe0ef          	jal	80003d02 <writei>
    8000549e:	47c1                	li	a5,16
    800054a0:	08f51b63          	bne	a0,a5,80005536 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    800054a4:	04491703          	lh	a4,68(s2)
    800054a8:	4785                	li	a5,1
    800054aa:	08f70d63          	beq	a4,a5,80005544 <sys_unlink+0x14c>
  iunlockput(dp);
    800054ae:	8526                	mv	a0,s1
    800054b0:	f0cfe0ef          	jal	80003bbc <iunlockput>
  ip->nlink--;
    800054b4:	04a95783          	lhu	a5,74(s2)
    800054b8:	37fd                	addiw	a5,a5,-1
    800054ba:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800054be:	854a                	mv	a0,s2
    800054c0:	c3efe0ef          	jal	800038fe <iupdate>
  iunlockput(ip);
    800054c4:	854a                	mv	a0,s2
    800054c6:	ef6fe0ef          	jal	80003bbc <iunlockput>
  end_op();
    800054ca:	de9fe0ef          	jal	800042b2 <end_op>
  return 0;
    800054ce:	4501                	li	a0,0
    800054d0:	64ee                	ld	s1,216(sp)
    800054d2:	694e                	ld	s2,208(sp)
    800054d4:	a849                	j	80005566 <sys_unlink+0x16e>
    end_op();
    800054d6:	dddfe0ef          	jal	800042b2 <end_op>
    return -1;
    800054da:	557d                	li	a0,-1
    800054dc:	64ee                	ld	s1,216(sp)
    800054de:	a061                	j	80005566 <sys_unlink+0x16e>
    800054e0:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    800054e2:	00003517          	auipc	a0,0x3
    800054e6:	1ee50513          	addi	a0,a0,494 # 800086d0 <etext+0x6d0>
    800054ea:	aaafb0ef          	jal	80000794 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800054ee:	04c92703          	lw	a4,76(s2)
    800054f2:	02000793          	li	a5,32
    800054f6:	f8e7f5e3          	bgeu	a5,a4,80005480 <sys_unlink+0x88>
    800054fa:	e5ce                	sd	s3,200(sp)
    800054fc:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005500:	4741                	li	a4,16
    80005502:	86ce                	mv	a3,s3
    80005504:	f1840613          	addi	a2,s0,-232
    80005508:	4581                	li	a1,0
    8000550a:	854a                	mv	a0,s2
    8000550c:	efafe0ef          	jal	80003c06 <readi>
    80005510:	47c1                	li	a5,16
    80005512:	00f51c63          	bne	a0,a5,8000552a <sys_unlink+0x132>
    if(de.inum != 0)
    80005516:	f1845783          	lhu	a5,-232(s0)
    8000551a:	efa1                	bnez	a5,80005572 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000551c:	29c1                	addiw	s3,s3,16
    8000551e:	04c92783          	lw	a5,76(s2)
    80005522:	fcf9efe3          	bltu	s3,a5,80005500 <sys_unlink+0x108>
    80005526:	69ae                	ld	s3,200(sp)
    80005528:	bfa1                	j	80005480 <sys_unlink+0x88>
      panic("isdirempty: readi");
    8000552a:	00003517          	auipc	a0,0x3
    8000552e:	1be50513          	addi	a0,a0,446 # 800086e8 <etext+0x6e8>
    80005532:	a62fb0ef          	jal	80000794 <panic>
    80005536:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80005538:	00003517          	auipc	a0,0x3
    8000553c:	1c850513          	addi	a0,a0,456 # 80008700 <etext+0x700>
    80005540:	a54fb0ef          	jal	80000794 <panic>
    dp->nlink--;
    80005544:	04a4d783          	lhu	a5,74(s1)
    80005548:	37fd                	addiw	a5,a5,-1
    8000554a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000554e:	8526                	mv	a0,s1
    80005550:	baefe0ef          	jal	800038fe <iupdate>
    80005554:	bfa9                	j	800054ae <sys_unlink+0xb6>
    80005556:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80005558:	8526                	mv	a0,s1
    8000555a:	e62fe0ef          	jal	80003bbc <iunlockput>
  end_op();
    8000555e:	d55fe0ef          	jal	800042b2 <end_op>
  return -1;
    80005562:	557d                	li	a0,-1
    80005564:	64ee                	ld	s1,216(sp)
}
    80005566:	70ae                	ld	ra,232(sp)
    80005568:	740e                	ld	s0,224(sp)
    8000556a:	616d                	addi	sp,sp,240
    8000556c:	8082                	ret
    return -1;
    8000556e:	557d                	li	a0,-1
    80005570:	bfdd                	j	80005566 <sys_unlink+0x16e>
    iunlockput(ip);
    80005572:	854a                	mv	a0,s2
    80005574:	e48fe0ef          	jal	80003bbc <iunlockput>
    goto bad;
    80005578:	694e                	ld	s2,208(sp)
    8000557a:	69ae                	ld	s3,200(sp)
    8000557c:	bff1                	j	80005558 <sys_unlink+0x160>

000000008000557e <sys_open>:

uint64
sys_open(void)
{
    8000557e:	7131                	addi	sp,sp,-192
    80005580:	fd06                	sd	ra,184(sp)
    80005582:	f922                	sd	s0,176(sp)
    80005584:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005586:	f4c40593          	addi	a1,s0,-180
    8000558a:	4505                	li	a0,1
    8000558c:	9fbfd0ef          	jal	80002f86 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005590:	08000613          	li	a2,128
    80005594:	f5040593          	addi	a1,s0,-176
    80005598:	4501                	li	a0,0
    8000559a:	a25fd0ef          	jal	80002fbe <argstr>
    8000559e:	87aa                	mv	a5,a0
    return -1;
    800055a0:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800055a2:	0a07c263          	bltz	a5,80005646 <sys_open+0xc8>
    800055a6:	f526                	sd	s1,168(sp)

  begin_op();
    800055a8:	ca1fe0ef          	jal	80004248 <begin_op>

  if(omode & O_CREATE){
    800055ac:	f4c42783          	lw	a5,-180(s0)
    800055b0:	2007f793          	andi	a5,a5,512
    800055b4:	c3d5                	beqz	a5,80005658 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    800055b6:	4681                	li	a3,0
    800055b8:	4601                	li	a2,0
    800055ba:	4589                	li	a1,2
    800055bc:	f5040513          	addi	a0,s0,-176
    800055c0:	aa9ff0ef          	jal	80005068 <create>
    800055c4:	84aa                	mv	s1,a0
    if(ip == 0){
    800055c6:	c541                	beqz	a0,8000564e <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800055c8:	04449703          	lh	a4,68(s1)
    800055cc:	478d                	li	a5,3
    800055ce:	00f71763          	bne	a4,a5,800055dc <sys_open+0x5e>
    800055d2:	0464d703          	lhu	a4,70(s1)
    800055d6:	47a5                	li	a5,9
    800055d8:	0ae7ed63          	bltu	a5,a4,80005692 <sys_open+0x114>
    800055dc:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800055de:	fe1fe0ef          	jal	800045be <filealloc>
    800055e2:	892a                	mv	s2,a0
    800055e4:	c179                	beqz	a0,800056aa <sys_open+0x12c>
    800055e6:	ed4e                	sd	s3,152(sp)
    800055e8:	a43ff0ef          	jal	8000502a <fdalloc>
    800055ec:	89aa                	mv	s3,a0
    800055ee:	0a054a63          	bltz	a0,800056a2 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800055f2:	04449703          	lh	a4,68(s1)
    800055f6:	478d                	li	a5,3
    800055f8:	0cf70263          	beq	a4,a5,800056bc <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800055fc:	4789                	li	a5,2
    800055fe:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005602:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005606:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    8000560a:	f4c42783          	lw	a5,-180(s0)
    8000560e:	0017c713          	xori	a4,a5,1
    80005612:	8b05                	andi	a4,a4,1
    80005614:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005618:	0037f713          	andi	a4,a5,3
    8000561c:	00e03733          	snez	a4,a4
    80005620:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005624:	4007f793          	andi	a5,a5,1024
    80005628:	c791                	beqz	a5,80005634 <sys_open+0xb6>
    8000562a:	04449703          	lh	a4,68(s1)
    8000562e:	4789                	li	a5,2
    80005630:	08f70d63          	beq	a4,a5,800056ca <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    80005634:	8526                	mv	a0,s1
    80005636:	c2afe0ef          	jal	80003a60 <iunlock>
  end_op();
    8000563a:	c79fe0ef          	jal	800042b2 <end_op>

  return fd;
    8000563e:	854e                	mv	a0,s3
    80005640:	74aa                	ld	s1,168(sp)
    80005642:	790a                	ld	s2,160(sp)
    80005644:	69ea                	ld	s3,152(sp)
}
    80005646:	70ea                	ld	ra,184(sp)
    80005648:	744a                	ld	s0,176(sp)
    8000564a:	6129                	addi	sp,sp,192
    8000564c:	8082                	ret
      end_op();
    8000564e:	c65fe0ef          	jal	800042b2 <end_op>
      return -1;
    80005652:	557d                	li	a0,-1
    80005654:	74aa                	ld	s1,168(sp)
    80005656:	bfc5                	j	80005646 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    80005658:	f5040513          	addi	a0,s0,-176
    8000565c:	a31fe0ef          	jal	8000408c <namei>
    80005660:	84aa                	mv	s1,a0
    80005662:	c11d                	beqz	a0,80005688 <sys_open+0x10a>
    ilock(ip);
    80005664:	b4efe0ef          	jal	800039b2 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005668:	04449703          	lh	a4,68(s1)
    8000566c:	4785                	li	a5,1
    8000566e:	f4f71de3          	bne	a4,a5,800055c8 <sys_open+0x4a>
    80005672:	f4c42783          	lw	a5,-180(s0)
    80005676:	d3bd                	beqz	a5,800055dc <sys_open+0x5e>
      iunlockput(ip);
    80005678:	8526                	mv	a0,s1
    8000567a:	d42fe0ef          	jal	80003bbc <iunlockput>
      end_op();
    8000567e:	c35fe0ef          	jal	800042b2 <end_op>
      return -1;
    80005682:	557d                	li	a0,-1
    80005684:	74aa                	ld	s1,168(sp)
    80005686:	b7c1                	j	80005646 <sys_open+0xc8>
      end_op();
    80005688:	c2bfe0ef          	jal	800042b2 <end_op>
      return -1;
    8000568c:	557d                	li	a0,-1
    8000568e:	74aa                	ld	s1,168(sp)
    80005690:	bf5d                	j	80005646 <sys_open+0xc8>
    iunlockput(ip);
    80005692:	8526                	mv	a0,s1
    80005694:	d28fe0ef          	jal	80003bbc <iunlockput>
    end_op();
    80005698:	c1bfe0ef          	jal	800042b2 <end_op>
    return -1;
    8000569c:	557d                	li	a0,-1
    8000569e:	74aa                	ld	s1,168(sp)
    800056a0:	b75d                	j	80005646 <sys_open+0xc8>
      fileclose(f);
    800056a2:	854a                	mv	a0,s2
    800056a4:	fbffe0ef          	jal	80004662 <fileclose>
    800056a8:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800056aa:	8526                	mv	a0,s1
    800056ac:	d10fe0ef          	jal	80003bbc <iunlockput>
    end_op();
    800056b0:	c03fe0ef          	jal	800042b2 <end_op>
    return -1;
    800056b4:	557d                	li	a0,-1
    800056b6:	74aa                	ld	s1,168(sp)
    800056b8:	790a                	ld	s2,160(sp)
    800056ba:	b771                	j	80005646 <sys_open+0xc8>
    f->type = FD_DEVICE;
    800056bc:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    800056c0:	04649783          	lh	a5,70(s1)
    800056c4:	02f91223          	sh	a5,36(s2)
    800056c8:	bf3d                	j	80005606 <sys_open+0x88>
    itrunc(ip);
    800056ca:	8526                	mv	a0,s1
    800056cc:	bd4fe0ef          	jal	80003aa0 <itrunc>
    800056d0:	b795                	j	80005634 <sys_open+0xb6>

00000000800056d2 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800056d2:	7175                	addi	sp,sp,-144
    800056d4:	e506                	sd	ra,136(sp)
    800056d6:	e122                	sd	s0,128(sp)
    800056d8:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800056da:	b6ffe0ef          	jal	80004248 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800056de:	08000613          	li	a2,128
    800056e2:	f7040593          	addi	a1,s0,-144
    800056e6:	4501                	li	a0,0
    800056e8:	8d7fd0ef          	jal	80002fbe <argstr>
    800056ec:	02054363          	bltz	a0,80005712 <sys_mkdir+0x40>
    800056f0:	4681                	li	a3,0
    800056f2:	4601                	li	a2,0
    800056f4:	4585                	li	a1,1
    800056f6:	f7040513          	addi	a0,s0,-144
    800056fa:	96fff0ef          	jal	80005068 <create>
    800056fe:	c911                	beqz	a0,80005712 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005700:	cbcfe0ef          	jal	80003bbc <iunlockput>
  end_op();
    80005704:	baffe0ef          	jal	800042b2 <end_op>
  return 0;
    80005708:	4501                	li	a0,0
}
    8000570a:	60aa                	ld	ra,136(sp)
    8000570c:	640a                	ld	s0,128(sp)
    8000570e:	6149                	addi	sp,sp,144
    80005710:	8082                	ret
    end_op();
    80005712:	ba1fe0ef          	jal	800042b2 <end_op>
    return -1;
    80005716:	557d                	li	a0,-1
    80005718:	bfcd                	j	8000570a <sys_mkdir+0x38>

000000008000571a <sys_mknod>:

uint64
sys_mknod(void)
{
    8000571a:	7135                	addi	sp,sp,-160
    8000571c:	ed06                	sd	ra,152(sp)
    8000571e:	e922                	sd	s0,144(sp)
    80005720:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005722:	b27fe0ef          	jal	80004248 <begin_op>
  argint(1, &major);
    80005726:	f6c40593          	addi	a1,s0,-148
    8000572a:	4505                	li	a0,1
    8000572c:	85bfd0ef          	jal	80002f86 <argint>
  argint(2, &minor);
    80005730:	f6840593          	addi	a1,s0,-152
    80005734:	4509                	li	a0,2
    80005736:	851fd0ef          	jal	80002f86 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000573a:	08000613          	li	a2,128
    8000573e:	f7040593          	addi	a1,s0,-144
    80005742:	4501                	li	a0,0
    80005744:	87bfd0ef          	jal	80002fbe <argstr>
    80005748:	02054563          	bltz	a0,80005772 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000574c:	f6841683          	lh	a3,-152(s0)
    80005750:	f6c41603          	lh	a2,-148(s0)
    80005754:	458d                	li	a1,3
    80005756:	f7040513          	addi	a0,s0,-144
    8000575a:	90fff0ef          	jal	80005068 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000575e:	c911                	beqz	a0,80005772 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005760:	c5cfe0ef          	jal	80003bbc <iunlockput>
  end_op();
    80005764:	b4ffe0ef          	jal	800042b2 <end_op>
  return 0;
    80005768:	4501                	li	a0,0
}
    8000576a:	60ea                	ld	ra,152(sp)
    8000576c:	644a                	ld	s0,144(sp)
    8000576e:	610d                	addi	sp,sp,160
    80005770:	8082                	ret
    end_op();
    80005772:	b41fe0ef          	jal	800042b2 <end_op>
    return -1;
    80005776:	557d                	li	a0,-1
    80005778:	bfcd                	j	8000576a <sys_mknod+0x50>

000000008000577a <sys_chdir>:

uint64
sys_chdir(void)
{
    8000577a:	7135                	addi	sp,sp,-160
    8000577c:	ed06                	sd	ra,152(sp)
    8000577e:	e922                	sd	s0,144(sp)
    80005780:	e14a                	sd	s2,128(sp)
    80005782:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005784:	9aafc0ef          	jal	8000192e <myproc>
    80005788:	892a                	mv	s2,a0
  
  begin_op();
    8000578a:	abffe0ef          	jal	80004248 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000578e:	08000613          	li	a2,128
    80005792:	f6040593          	addi	a1,s0,-160
    80005796:	4501                	li	a0,0
    80005798:	827fd0ef          	jal	80002fbe <argstr>
    8000579c:	04054363          	bltz	a0,800057e2 <sys_chdir+0x68>
    800057a0:	e526                	sd	s1,136(sp)
    800057a2:	f6040513          	addi	a0,s0,-160
    800057a6:	8e7fe0ef          	jal	8000408c <namei>
    800057aa:	84aa                	mv	s1,a0
    800057ac:	c915                	beqz	a0,800057e0 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800057ae:	a04fe0ef          	jal	800039b2 <ilock>
  if(ip->type != T_DIR){
    800057b2:	04449703          	lh	a4,68(s1)
    800057b6:	4785                	li	a5,1
    800057b8:	02f71963          	bne	a4,a5,800057ea <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800057bc:	8526                	mv	a0,s1
    800057be:	aa2fe0ef          	jal	80003a60 <iunlock>
  iput(p->cwd);
    800057c2:	15893503          	ld	a0,344(s2)
    800057c6:	b6efe0ef          	jal	80003b34 <iput>
  end_op();
    800057ca:	ae9fe0ef          	jal	800042b2 <end_op>
  p->cwd = ip;
    800057ce:	14993c23          	sd	s1,344(s2)
  return 0;
    800057d2:	4501                	li	a0,0
    800057d4:	64aa                	ld	s1,136(sp)
}
    800057d6:	60ea                	ld	ra,152(sp)
    800057d8:	644a                	ld	s0,144(sp)
    800057da:	690a                	ld	s2,128(sp)
    800057dc:	610d                	addi	sp,sp,160
    800057de:	8082                	ret
    800057e0:	64aa                	ld	s1,136(sp)
    end_op();
    800057e2:	ad1fe0ef          	jal	800042b2 <end_op>
    return -1;
    800057e6:	557d                	li	a0,-1
    800057e8:	b7fd                	j	800057d6 <sys_chdir+0x5c>
    iunlockput(ip);
    800057ea:	8526                	mv	a0,s1
    800057ec:	bd0fe0ef          	jal	80003bbc <iunlockput>
    end_op();
    800057f0:	ac3fe0ef          	jal	800042b2 <end_op>
    return -1;
    800057f4:	557d                	li	a0,-1
    800057f6:	64aa                	ld	s1,136(sp)
    800057f8:	bff9                	j	800057d6 <sys_chdir+0x5c>

00000000800057fa <sys_exec>:

uint64
sys_exec(void)
{
    800057fa:	7121                	addi	sp,sp,-448
    800057fc:	ff06                	sd	ra,440(sp)
    800057fe:	fb22                	sd	s0,432(sp)
    80005800:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005802:	e4840593          	addi	a1,s0,-440
    80005806:	4505                	li	a0,1
    80005808:	f9afd0ef          	jal	80002fa2 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000580c:	08000613          	li	a2,128
    80005810:	f5040593          	addi	a1,s0,-176
    80005814:	4501                	li	a0,0
    80005816:	fa8fd0ef          	jal	80002fbe <argstr>
    8000581a:	87aa                	mv	a5,a0
    return -1;
    8000581c:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000581e:	0c07c463          	bltz	a5,800058e6 <sys_exec+0xec>
    80005822:	f726                	sd	s1,424(sp)
    80005824:	f34a                	sd	s2,416(sp)
    80005826:	ef4e                	sd	s3,408(sp)
    80005828:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    8000582a:	10000613          	li	a2,256
    8000582e:	4581                	li	a1,0
    80005830:	e5040513          	addi	a0,s0,-432
    80005834:	c94fb0ef          	jal	80000cc8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005838:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    8000583c:	89a6                	mv	s3,s1
    8000583e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005840:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005844:	00391513          	slli	a0,s2,0x3
    80005848:	e4040593          	addi	a1,s0,-448
    8000584c:	e4843783          	ld	a5,-440(s0)
    80005850:	953e                	add	a0,a0,a5
    80005852:	eaafd0ef          	jal	80002efc <fetchaddr>
    80005856:	02054663          	bltz	a0,80005882 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    8000585a:	e4043783          	ld	a5,-448(s0)
    8000585e:	c3a9                	beqz	a5,800058a0 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005860:	ac4fb0ef          	jal	80000b24 <kalloc>
    80005864:	85aa                	mv	a1,a0
    80005866:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000586a:	cd01                	beqz	a0,80005882 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000586c:	6605                	lui	a2,0x1
    8000586e:	e4043503          	ld	a0,-448(s0)
    80005872:	ed4fd0ef          	jal	80002f46 <fetchstr>
    80005876:	00054663          	bltz	a0,80005882 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    8000587a:	0905                	addi	s2,s2,1
    8000587c:	09a1                	addi	s3,s3,8
    8000587e:	fd4913e3          	bne	s2,s4,80005844 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005882:	f5040913          	addi	s2,s0,-176
    80005886:	6088                	ld	a0,0(s1)
    80005888:	c931                	beqz	a0,800058dc <sys_exec+0xe2>
    kfree(argv[i]);
    8000588a:	9b8fb0ef          	jal	80000a42 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000588e:	04a1                	addi	s1,s1,8
    80005890:	ff249be3          	bne	s1,s2,80005886 <sys_exec+0x8c>
  return -1;
    80005894:	557d                	li	a0,-1
    80005896:	74ba                	ld	s1,424(sp)
    80005898:	791a                	ld	s2,416(sp)
    8000589a:	69fa                	ld	s3,408(sp)
    8000589c:	6a5a                	ld	s4,400(sp)
    8000589e:	a0a1                	j	800058e6 <sys_exec+0xec>
      argv[i] = 0;
    800058a0:	0009079b          	sext.w	a5,s2
    800058a4:	078e                	slli	a5,a5,0x3
    800058a6:	fd078793          	addi	a5,a5,-48
    800058aa:	97a2                	add	a5,a5,s0
    800058ac:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800058b0:	e5040593          	addi	a1,s0,-432
    800058b4:	f5040513          	addi	a0,s0,-176
    800058b8:	ba8ff0ef          	jal	80004c60 <exec>
    800058bc:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800058be:	f5040993          	addi	s3,s0,-176
    800058c2:	6088                	ld	a0,0(s1)
    800058c4:	c511                	beqz	a0,800058d0 <sys_exec+0xd6>
    kfree(argv[i]);
    800058c6:	97cfb0ef          	jal	80000a42 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800058ca:	04a1                	addi	s1,s1,8
    800058cc:	ff349be3          	bne	s1,s3,800058c2 <sys_exec+0xc8>
  return ret;
    800058d0:	854a                	mv	a0,s2
    800058d2:	74ba                	ld	s1,424(sp)
    800058d4:	791a                	ld	s2,416(sp)
    800058d6:	69fa                	ld	s3,408(sp)
    800058d8:	6a5a                	ld	s4,400(sp)
    800058da:	a031                	j	800058e6 <sys_exec+0xec>
  return -1;
    800058dc:	557d                	li	a0,-1
    800058de:	74ba                	ld	s1,424(sp)
    800058e0:	791a                	ld	s2,416(sp)
    800058e2:	69fa                	ld	s3,408(sp)
    800058e4:	6a5a                	ld	s4,400(sp)
}
    800058e6:	70fa                	ld	ra,440(sp)
    800058e8:	745a                	ld	s0,432(sp)
    800058ea:	6139                	addi	sp,sp,448
    800058ec:	8082                	ret

00000000800058ee <sys_pipe>:

uint64
sys_pipe(void)
{
    800058ee:	7139                	addi	sp,sp,-64
    800058f0:	fc06                	sd	ra,56(sp)
    800058f2:	f822                	sd	s0,48(sp)
    800058f4:	f426                	sd	s1,40(sp)
    800058f6:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800058f8:	836fc0ef          	jal	8000192e <myproc>
    800058fc:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800058fe:	fd840593          	addi	a1,s0,-40
    80005902:	4501                	li	a0,0
    80005904:	e9efd0ef          	jal	80002fa2 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005908:	fc840593          	addi	a1,s0,-56
    8000590c:	fd040513          	addi	a0,s0,-48
    80005910:	85cff0ef          	jal	8000496c <pipealloc>
    return -1;
    80005914:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005916:	0a054463          	bltz	a0,800059be <sys_pipe+0xd0>
  fd0 = -1;
    8000591a:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000591e:	fd043503          	ld	a0,-48(s0)
    80005922:	f08ff0ef          	jal	8000502a <fdalloc>
    80005926:	fca42223          	sw	a0,-60(s0)
    8000592a:	08054163          	bltz	a0,800059ac <sys_pipe+0xbe>
    8000592e:	fc843503          	ld	a0,-56(s0)
    80005932:	ef8ff0ef          	jal	8000502a <fdalloc>
    80005936:	fca42023          	sw	a0,-64(s0)
    8000593a:	06054063          	bltz	a0,8000599a <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000593e:	4691                	li	a3,4
    80005940:	fc440613          	addi	a2,s0,-60
    80005944:	fd843583          	ld	a1,-40(s0)
    80005948:	6ca8                	ld	a0,88(s1)
    8000594a:	c09fb0ef          	jal	80001552 <copyout>
    8000594e:	00054e63          	bltz	a0,8000596a <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005952:	4691                	li	a3,4
    80005954:	fc040613          	addi	a2,s0,-64
    80005958:	fd843583          	ld	a1,-40(s0)
    8000595c:	0591                	addi	a1,a1,4
    8000595e:	6ca8                	ld	a0,88(s1)
    80005960:	bf3fb0ef          	jal	80001552 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005964:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005966:	04055c63          	bgez	a0,800059be <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    8000596a:	fc442783          	lw	a5,-60(s0)
    8000596e:	07e9                	addi	a5,a5,26
    80005970:	078e                	slli	a5,a5,0x3
    80005972:	97a6                	add	a5,a5,s1
    80005974:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005978:	fc042783          	lw	a5,-64(s0)
    8000597c:	07e9                	addi	a5,a5,26
    8000597e:	078e                	slli	a5,a5,0x3
    80005980:	94be                	add	s1,s1,a5
    80005982:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80005986:	fd043503          	ld	a0,-48(s0)
    8000598a:	cd9fe0ef          	jal	80004662 <fileclose>
    fileclose(wf);
    8000598e:	fc843503          	ld	a0,-56(s0)
    80005992:	cd1fe0ef          	jal	80004662 <fileclose>
    return -1;
    80005996:	57fd                	li	a5,-1
    80005998:	a01d                	j	800059be <sys_pipe+0xd0>
    if(fd0 >= 0)
    8000599a:	fc442783          	lw	a5,-60(s0)
    8000599e:	0007c763          	bltz	a5,800059ac <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    800059a2:	07e9                	addi	a5,a5,26
    800059a4:	078e                	slli	a5,a5,0x3
    800059a6:	97a6                	add	a5,a5,s1
    800059a8:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    800059ac:	fd043503          	ld	a0,-48(s0)
    800059b0:	cb3fe0ef          	jal	80004662 <fileclose>
    fileclose(wf);
    800059b4:	fc843503          	ld	a0,-56(s0)
    800059b8:	cabfe0ef          	jal	80004662 <fileclose>
    return -1;
    800059bc:	57fd                	li	a5,-1
}
    800059be:	853e                	mv	a0,a5
    800059c0:	70e2                	ld	ra,56(sp)
    800059c2:	7442                	ld	s0,48(sp)
    800059c4:	74a2                	ld	s1,40(sp)
    800059c6:	6121                	addi	sp,sp,64
    800059c8:	8082                	ret
    800059ca:	0000                	unimp
    800059cc:	0000                	unimp
	...

00000000800059d0 <kernelvec>:
    800059d0:	7111                	addi	sp,sp,-256
    800059d2:	e006                	sd	ra,0(sp)
    800059d4:	e40a                	sd	sp,8(sp)
    800059d6:	e80e                	sd	gp,16(sp)
    800059d8:	ec12                	sd	tp,24(sp)
    800059da:	f016                	sd	t0,32(sp)
    800059dc:	f41a                	sd	t1,40(sp)
    800059de:	f81e                	sd	t2,48(sp)
    800059e0:	e4aa                	sd	a0,72(sp)
    800059e2:	e8ae                	sd	a1,80(sp)
    800059e4:	ecb2                	sd	a2,88(sp)
    800059e6:	f0b6                	sd	a3,96(sp)
    800059e8:	f4ba                	sd	a4,104(sp)
    800059ea:	f8be                	sd	a5,112(sp)
    800059ec:	fcc2                	sd	a6,120(sp)
    800059ee:	e146                	sd	a7,128(sp)
    800059f0:	edf2                	sd	t3,216(sp)
    800059f2:	f1f6                	sd	t4,224(sp)
    800059f4:	f5fa                	sd	t5,232(sp)
    800059f6:	f9fe                	sd	t6,240(sp)
    800059f8:	be4fd0ef          	jal	80002ddc <kerneltrap>
    800059fc:	6082                	ld	ra,0(sp)
    800059fe:	6122                	ld	sp,8(sp)
    80005a00:	61c2                	ld	gp,16(sp)
    80005a02:	7282                	ld	t0,32(sp)
    80005a04:	7322                	ld	t1,40(sp)
    80005a06:	73c2                	ld	t2,48(sp)
    80005a08:	6526                	ld	a0,72(sp)
    80005a0a:	65c6                	ld	a1,80(sp)
    80005a0c:	6666                	ld	a2,88(sp)
    80005a0e:	7686                	ld	a3,96(sp)
    80005a10:	7726                	ld	a4,104(sp)
    80005a12:	77c6                	ld	a5,112(sp)
    80005a14:	7866                	ld	a6,120(sp)
    80005a16:	688a                	ld	a7,128(sp)
    80005a18:	6e6e                	ld	t3,216(sp)
    80005a1a:	7e8e                	ld	t4,224(sp)
    80005a1c:	7f2e                	ld	t5,232(sp)
    80005a1e:	7fce                	ld	t6,240(sp)
    80005a20:	6111                	addi	sp,sp,256
    80005a22:	10200073          	sret
	...

0000000080005a2e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005a2e:	1141                	addi	sp,sp,-16
    80005a30:	e422                	sd	s0,8(sp)
    80005a32:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005a34:	0c0007b7          	lui	a5,0xc000
    80005a38:	4705                	li	a4,1
    80005a3a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005a3c:	0c0007b7          	lui	a5,0xc000
    80005a40:	c3d8                	sw	a4,4(a5)
}
    80005a42:	6422                	ld	s0,8(sp)
    80005a44:	0141                	addi	sp,sp,16
    80005a46:	8082                	ret

0000000080005a48 <plicinithart>:

void
plicinithart(void)
{
    80005a48:	1141                	addi	sp,sp,-16
    80005a4a:	e406                	sd	ra,8(sp)
    80005a4c:	e022                	sd	s0,0(sp)
    80005a4e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005a50:	eb3fb0ef          	jal	80001902 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005a54:	0085171b          	slliw	a4,a0,0x8
    80005a58:	0c0027b7          	lui	a5,0xc002
    80005a5c:	97ba                	add	a5,a5,a4
    80005a5e:	40200713          	li	a4,1026
    80005a62:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005a66:	00d5151b          	slliw	a0,a0,0xd
    80005a6a:	0c2017b7          	lui	a5,0xc201
    80005a6e:	97aa                	add	a5,a5,a0
    80005a70:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005a74:	60a2                	ld	ra,8(sp)
    80005a76:	6402                	ld	s0,0(sp)
    80005a78:	0141                	addi	sp,sp,16
    80005a7a:	8082                	ret

0000000080005a7c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005a7c:	1141                	addi	sp,sp,-16
    80005a7e:	e406                	sd	ra,8(sp)
    80005a80:	e022                	sd	s0,0(sp)
    80005a82:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005a84:	e7ffb0ef          	jal	80001902 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005a88:	00d5151b          	slliw	a0,a0,0xd
    80005a8c:	0c2017b7          	lui	a5,0xc201
    80005a90:	97aa                	add	a5,a5,a0
  return irq;
}
    80005a92:	43c8                	lw	a0,4(a5)
    80005a94:	60a2                	ld	ra,8(sp)
    80005a96:	6402                	ld	s0,0(sp)
    80005a98:	0141                	addi	sp,sp,16
    80005a9a:	8082                	ret

0000000080005a9c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005a9c:	1101                	addi	sp,sp,-32
    80005a9e:	ec06                	sd	ra,24(sp)
    80005aa0:	e822                	sd	s0,16(sp)
    80005aa2:	e426                	sd	s1,8(sp)
    80005aa4:	1000                	addi	s0,sp,32
    80005aa6:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005aa8:	e5bfb0ef          	jal	80001902 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005aac:	00d5151b          	slliw	a0,a0,0xd
    80005ab0:	0c2017b7          	lui	a5,0xc201
    80005ab4:	97aa                	add	a5,a5,a0
    80005ab6:	c3c4                	sw	s1,4(a5)
}
    80005ab8:	60e2                	ld	ra,24(sp)
    80005aba:	6442                	ld	s0,16(sp)
    80005abc:	64a2                	ld	s1,8(sp)
    80005abe:	6105                	addi	sp,sp,32
    80005ac0:	8082                	ret

0000000080005ac2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005ac2:	1141                	addi	sp,sp,-16
    80005ac4:	e406                	sd	ra,8(sp)
    80005ac6:	e022                	sd	s0,0(sp)
    80005ac8:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005aca:	479d                	li	a5,7
    80005acc:	04a7ca63          	blt	a5,a0,80005b20 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005ad0:	0001f797          	auipc	a5,0x1f
    80005ad4:	01878793          	addi	a5,a5,24 # 80024ae8 <disk>
    80005ad8:	97aa                	add	a5,a5,a0
    80005ada:	0187c783          	lbu	a5,24(a5)
    80005ade:	e7b9                	bnez	a5,80005b2c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005ae0:	00451693          	slli	a3,a0,0x4
    80005ae4:	0001f797          	auipc	a5,0x1f
    80005ae8:	00478793          	addi	a5,a5,4 # 80024ae8 <disk>
    80005aec:	6398                	ld	a4,0(a5)
    80005aee:	9736                	add	a4,a4,a3
    80005af0:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005af4:	6398                	ld	a4,0(a5)
    80005af6:	9736                	add	a4,a4,a3
    80005af8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005afc:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005b00:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005b04:	97aa                	add	a5,a5,a0
    80005b06:	4705                	li	a4,1
    80005b08:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005b0c:	0001f517          	auipc	a0,0x1f
    80005b10:	ff450513          	addi	a0,a0,-12 # 80024b00 <disk+0x18>
    80005b14:	a46fc0ef          	jal	80001d5a <wakeup>
}
    80005b18:	60a2                	ld	ra,8(sp)
    80005b1a:	6402                	ld	s0,0(sp)
    80005b1c:	0141                	addi	sp,sp,16
    80005b1e:	8082                	ret
    panic("free_desc 1");
    80005b20:	00003517          	auipc	a0,0x3
    80005b24:	bf050513          	addi	a0,a0,-1040 # 80008710 <etext+0x710>
    80005b28:	c6dfa0ef          	jal	80000794 <panic>
    panic("free_desc 2");
    80005b2c:	00003517          	auipc	a0,0x3
    80005b30:	bf450513          	addi	a0,a0,-1036 # 80008720 <etext+0x720>
    80005b34:	c61fa0ef          	jal	80000794 <panic>

0000000080005b38 <virtio_disk_init>:
{
    80005b38:	1101                	addi	sp,sp,-32
    80005b3a:	ec06                	sd	ra,24(sp)
    80005b3c:	e822                	sd	s0,16(sp)
    80005b3e:	e426                	sd	s1,8(sp)
    80005b40:	e04a                	sd	s2,0(sp)
    80005b42:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005b44:	00003597          	auipc	a1,0x3
    80005b48:	bec58593          	addi	a1,a1,-1044 # 80008730 <etext+0x730>
    80005b4c:	0001f517          	auipc	a0,0x1f
    80005b50:	0c450513          	addi	a0,a0,196 # 80024c10 <disk+0x128>
    80005b54:	820fb0ef          	jal	80000b74 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005b58:	100017b7          	lui	a5,0x10001
    80005b5c:	4398                	lw	a4,0(a5)
    80005b5e:	2701                	sext.w	a4,a4
    80005b60:	747277b7          	lui	a5,0x74727
    80005b64:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005b68:	18f71063          	bne	a4,a5,80005ce8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005b6c:	100017b7          	lui	a5,0x10001
    80005b70:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80005b72:	439c                	lw	a5,0(a5)
    80005b74:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005b76:	4709                	li	a4,2
    80005b78:	16e79863          	bne	a5,a4,80005ce8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005b7c:	100017b7          	lui	a5,0x10001
    80005b80:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80005b82:	439c                	lw	a5,0(a5)
    80005b84:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005b86:	16e79163          	bne	a5,a4,80005ce8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005b8a:	100017b7          	lui	a5,0x10001
    80005b8e:	47d8                	lw	a4,12(a5)
    80005b90:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005b92:	554d47b7          	lui	a5,0x554d4
    80005b96:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005b9a:	14f71763          	bne	a4,a5,80005ce8 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005b9e:	100017b7          	lui	a5,0x10001
    80005ba2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005ba6:	4705                	li	a4,1
    80005ba8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005baa:	470d                	li	a4,3
    80005bac:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005bae:	10001737          	lui	a4,0x10001
    80005bb2:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005bb4:	c7ffe737          	lui	a4,0xc7ffe
    80005bb8:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd9b37>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005bbc:	8ef9                	and	a3,a3,a4
    80005bbe:	10001737          	lui	a4,0x10001
    80005bc2:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005bc4:	472d                	li	a4,11
    80005bc6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005bc8:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80005bcc:	439c                	lw	a5,0(a5)
    80005bce:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005bd2:	8ba1                	andi	a5,a5,8
    80005bd4:	12078063          	beqz	a5,80005cf4 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005bd8:	100017b7          	lui	a5,0x10001
    80005bdc:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005be0:	100017b7          	lui	a5,0x10001
    80005be4:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005be8:	439c                	lw	a5,0(a5)
    80005bea:	2781                	sext.w	a5,a5
    80005bec:	10079a63          	bnez	a5,80005d00 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005bf0:	100017b7          	lui	a5,0x10001
    80005bf4:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005bf8:	439c                	lw	a5,0(a5)
    80005bfa:	2781                	sext.w	a5,a5
  if(max == 0)
    80005bfc:	10078863          	beqz	a5,80005d0c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80005c00:	471d                	li	a4,7
    80005c02:	10f77b63          	bgeu	a4,a5,80005d18 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80005c06:	f1ffa0ef          	jal	80000b24 <kalloc>
    80005c0a:	0001f497          	auipc	s1,0x1f
    80005c0e:	ede48493          	addi	s1,s1,-290 # 80024ae8 <disk>
    80005c12:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005c14:	f11fa0ef          	jal	80000b24 <kalloc>
    80005c18:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80005c1a:	f0bfa0ef          	jal	80000b24 <kalloc>
    80005c1e:	87aa                	mv	a5,a0
    80005c20:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005c22:	6088                	ld	a0,0(s1)
    80005c24:	10050063          	beqz	a0,80005d24 <virtio_disk_init+0x1ec>
    80005c28:	0001f717          	auipc	a4,0x1f
    80005c2c:	ec873703          	ld	a4,-312(a4) # 80024af0 <disk+0x8>
    80005c30:	0e070a63          	beqz	a4,80005d24 <virtio_disk_init+0x1ec>
    80005c34:	0e078863          	beqz	a5,80005d24 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80005c38:	6605                	lui	a2,0x1
    80005c3a:	4581                	li	a1,0
    80005c3c:	88cfb0ef          	jal	80000cc8 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005c40:	0001f497          	auipc	s1,0x1f
    80005c44:	ea848493          	addi	s1,s1,-344 # 80024ae8 <disk>
    80005c48:	6605                	lui	a2,0x1
    80005c4a:	4581                	li	a1,0
    80005c4c:	6488                	ld	a0,8(s1)
    80005c4e:	87afb0ef          	jal	80000cc8 <memset>
  memset(disk.used, 0, PGSIZE);
    80005c52:	6605                	lui	a2,0x1
    80005c54:	4581                	li	a1,0
    80005c56:	6888                	ld	a0,16(s1)
    80005c58:	870fb0ef          	jal	80000cc8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005c5c:	100017b7          	lui	a5,0x10001
    80005c60:	4721                	li	a4,8
    80005c62:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005c64:	4098                	lw	a4,0(s1)
    80005c66:	100017b7          	lui	a5,0x10001
    80005c6a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005c6e:	40d8                	lw	a4,4(s1)
    80005c70:	100017b7          	lui	a5,0x10001
    80005c74:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005c78:	649c                	ld	a5,8(s1)
    80005c7a:	0007869b          	sext.w	a3,a5
    80005c7e:	10001737          	lui	a4,0x10001
    80005c82:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005c86:	9781                	srai	a5,a5,0x20
    80005c88:	10001737          	lui	a4,0x10001
    80005c8c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005c90:	689c                	ld	a5,16(s1)
    80005c92:	0007869b          	sext.w	a3,a5
    80005c96:	10001737          	lui	a4,0x10001
    80005c9a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005c9e:	9781                	srai	a5,a5,0x20
    80005ca0:	10001737          	lui	a4,0x10001
    80005ca4:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005ca8:	10001737          	lui	a4,0x10001
    80005cac:	4785                	li	a5,1
    80005cae:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005cb0:	00f48c23          	sb	a5,24(s1)
    80005cb4:	00f48ca3          	sb	a5,25(s1)
    80005cb8:	00f48d23          	sb	a5,26(s1)
    80005cbc:	00f48da3          	sb	a5,27(s1)
    80005cc0:	00f48e23          	sb	a5,28(s1)
    80005cc4:	00f48ea3          	sb	a5,29(s1)
    80005cc8:	00f48f23          	sb	a5,30(s1)
    80005ccc:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005cd0:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005cd4:	100017b7          	lui	a5,0x10001
    80005cd8:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80005cdc:	60e2                	ld	ra,24(sp)
    80005cde:	6442                	ld	s0,16(sp)
    80005ce0:	64a2                	ld	s1,8(sp)
    80005ce2:	6902                	ld	s2,0(sp)
    80005ce4:	6105                	addi	sp,sp,32
    80005ce6:	8082                	ret
    panic("could not find virtio disk");
    80005ce8:	00003517          	auipc	a0,0x3
    80005cec:	a5850513          	addi	a0,a0,-1448 # 80008740 <etext+0x740>
    80005cf0:	aa5fa0ef          	jal	80000794 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005cf4:	00003517          	auipc	a0,0x3
    80005cf8:	a6c50513          	addi	a0,a0,-1428 # 80008760 <etext+0x760>
    80005cfc:	a99fa0ef          	jal	80000794 <panic>
    panic("virtio disk should not be ready");
    80005d00:	00003517          	auipc	a0,0x3
    80005d04:	a8050513          	addi	a0,a0,-1408 # 80008780 <etext+0x780>
    80005d08:	a8dfa0ef          	jal	80000794 <panic>
    panic("virtio disk has no queue 0");
    80005d0c:	00003517          	auipc	a0,0x3
    80005d10:	a9450513          	addi	a0,a0,-1388 # 800087a0 <etext+0x7a0>
    80005d14:	a81fa0ef          	jal	80000794 <panic>
    panic("virtio disk max queue too short");
    80005d18:	00003517          	auipc	a0,0x3
    80005d1c:	aa850513          	addi	a0,a0,-1368 # 800087c0 <etext+0x7c0>
    80005d20:	a75fa0ef          	jal	80000794 <panic>
    panic("virtio disk kalloc");
    80005d24:	00003517          	auipc	a0,0x3
    80005d28:	abc50513          	addi	a0,a0,-1348 # 800087e0 <etext+0x7e0>
    80005d2c:	a69fa0ef          	jal	80000794 <panic>

0000000080005d30 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005d30:	7159                	addi	sp,sp,-112
    80005d32:	f486                	sd	ra,104(sp)
    80005d34:	f0a2                	sd	s0,96(sp)
    80005d36:	eca6                	sd	s1,88(sp)
    80005d38:	e8ca                	sd	s2,80(sp)
    80005d3a:	e4ce                	sd	s3,72(sp)
    80005d3c:	e0d2                	sd	s4,64(sp)
    80005d3e:	fc56                	sd	s5,56(sp)
    80005d40:	f85a                	sd	s6,48(sp)
    80005d42:	f45e                	sd	s7,40(sp)
    80005d44:	f062                	sd	s8,32(sp)
    80005d46:	ec66                	sd	s9,24(sp)
    80005d48:	1880                	addi	s0,sp,112
    80005d4a:	8a2a                	mv	s4,a0
    80005d4c:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005d4e:	00c52c83          	lw	s9,12(a0)
    80005d52:	001c9c9b          	slliw	s9,s9,0x1
    80005d56:	1c82                	slli	s9,s9,0x20
    80005d58:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005d5c:	0001f517          	auipc	a0,0x1f
    80005d60:	eb450513          	addi	a0,a0,-332 # 80024c10 <disk+0x128>
    80005d64:	e91fa0ef          	jal	80000bf4 <acquire>
  for(int i = 0; i < 3; i++){
    80005d68:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005d6a:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005d6c:	0001fb17          	auipc	s6,0x1f
    80005d70:	d7cb0b13          	addi	s6,s6,-644 # 80024ae8 <disk>
  for(int i = 0; i < 3; i++){
    80005d74:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005d76:	0001fc17          	auipc	s8,0x1f
    80005d7a:	e9ac0c13          	addi	s8,s8,-358 # 80024c10 <disk+0x128>
    80005d7e:	a8b9                	j	80005ddc <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80005d80:	00fb0733          	add	a4,s6,a5
    80005d84:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80005d88:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005d8a:	0207c563          	bltz	a5,80005db4 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80005d8e:	2905                	addiw	s2,s2,1
    80005d90:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005d92:	05590963          	beq	s2,s5,80005de4 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80005d96:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005d98:	0001f717          	auipc	a4,0x1f
    80005d9c:	d5070713          	addi	a4,a4,-688 # 80024ae8 <disk>
    80005da0:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005da2:	01874683          	lbu	a3,24(a4)
    80005da6:	fee9                	bnez	a3,80005d80 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80005da8:	2785                	addiw	a5,a5,1
    80005daa:	0705                	addi	a4,a4,1
    80005dac:	fe979be3          	bne	a5,s1,80005da2 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005db0:	57fd                	li	a5,-1
    80005db2:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005db4:	01205d63          	blez	s2,80005dce <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005db8:	f9042503          	lw	a0,-112(s0)
    80005dbc:	d07ff0ef          	jal	80005ac2 <free_desc>
      for(int j = 0; j < i; j++)
    80005dc0:	4785                	li	a5,1
    80005dc2:	0127d663          	bge	a5,s2,80005dce <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005dc6:	f9442503          	lw	a0,-108(s0)
    80005dca:	cf9ff0ef          	jal	80005ac2 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005dce:	85e2                	mv	a1,s8
    80005dd0:	0001f517          	auipc	a0,0x1f
    80005dd4:	d3050513          	addi	a0,a0,-720 # 80024b00 <disk+0x18>
    80005dd8:	f37fb0ef          	jal	80001d0e <sleep>
  for(int i = 0; i < 3; i++){
    80005ddc:	f9040613          	addi	a2,s0,-112
    80005de0:	894e                	mv	s2,s3
    80005de2:	bf55                	j	80005d96 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005de4:	f9042503          	lw	a0,-112(s0)
    80005de8:	00451693          	slli	a3,a0,0x4

  if(write)
    80005dec:	0001f797          	auipc	a5,0x1f
    80005df0:	cfc78793          	addi	a5,a5,-772 # 80024ae8 <disk>
    80005df4:	00a50713          	addi	a4,a0,10
    80005df8:	0712                	slli	a4,a4,0x4
    80005dfa:	973e                	add	a4,a4,a5
    80005dfc:	01703633          	snez	a2,s7
    80005e00:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005e02:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005e06:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005e0a:	6398                	ld	a4,0(a5)
    80005e0c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005e0e:	0a868613          	addi	a2,a3,168
    80005e12:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005e14:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005e16:	6390                	ld	a2,0(a5)
    80005e18:	00d605b3          	add	a1,a2,a3
    80005e1c:	4741                	li	a4,16
    80005e1e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005e20:	4805                	li	a6,1
    80005e22:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005e26:	f9442703          	lw	a4,-108(s0)
    80005e2a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005e2e:	0712                	slli	a4,a4,0x4
    80005e30:	963a                	add	a2,a2,a4
    80005e32:	058a0593          	addi	a1,s4,88
    80005e36:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005e38:	0007b883          	ld	a7,0(a5)
    80005e3c:	9746                	add	a4,a4,a7
    80005e3e:	40000613          	li	a2,1024
    80005e42:	c710                	sw	a2,8(a4)
  if(write)
    80005e44:	001bb613          	seqz	a2,s7
    80005e48:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005e4c:	00166613          	ori	a2,a2,1
    80005e50:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005e54:	f9842583          	lw	a1,-104(s0)
    80005e58:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005e5c:	00250613          	addi	a2,a0,2
    80005e60:	0612                	slli	a2,a2,0x4
    80005e62:	963e                	add	a2,a2,a5
    80005e64:	577d                	li	a4,-1
    80005e66:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005e6a:	0592                	slli	a1,a1,0x4
    80005e6c:	98ae                	add	a7,a7,a1
    80005e6e:	03068713          	addi	a4,a3,48
    80005e72:	973e                	add	a4,a4,a5
    80005e74:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005e78:	6398                	ld	a4,0(a5)
    80005e7a:	972e                	add	a4,a4,a1
    80005e7c:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005e80:	4689                	li	a3,2
    80005e82:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005e86:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005e8a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80005e8e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005e92:	6794                	ld	a3,8(a5)
    80005e94:	0026d703          	lhu	a4,2(a3)
    80005e98:	8b1d                	andi	a4,a4,7
    80005e9a:	0706                	slli	a4,a4,0x1
    80005e9c:	96ba                	add	a3,a3,a4
    80005e9e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005ea2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005ea6:	6798                	ld	a4,8(a5)
    80005ea8:	00275783          	lhu	a5,2(a4)
    80005eac:	2785                	addiw	a5,a5,1
    80005eae:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005eb2:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005eb6:	100017b7          	lui	a5,0x10001
    80005eba:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005ebe:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005ec2:	0001f917          	auipc	s2,0x1f
    80005ec6:	d4e90913          	addi	s2,s2,-690 # 80024c10 <disk+0x128>
  while(b->disk == 1) {
    80005eca:	4485                	li	s1,1
    80005ecc:	01079a63          	bne	a5,a6,80005ee0 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005ed0:	85ca                	mv	a1,s2
    80005ed2:	8552                	mv	a0,s4
    80005ed4:	e3bfb0ef          	jal	80001d0e <sleep>
  while(b->disk == 1) {
    80005ed8:	004a2783          	lw	a5,4(s4)
    80005edc:	fe978ae3          	beq	a5,s1,80005ed0 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80005ee0:	f9042903          	lw	s2,-112(s0)
    80005ee4:	00290713          	addi	a4,s2,2
    80005ee8:	0712                	slli	a4,a4,0x4
    80005eea:	0001f797          	auipc	a5,0x1f
    80005eee:	bfe78793          	addi	a5,a5,-1026 # 80024ae8 <disk>
    80005ef2:	97ba                	add	a5,a5,a4
    80005ef4:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005ef8:	0001f997          	auipc	s3,0x1f
    80005efc:	bf098993          	addi	s3,s3,-1040 # 80024ae8 <disk>
    80005f00:	00491713          	slli	a4,s2,0x4
    80005f04:	0009b783          	ld	a5,0(s3)
    80005f08:	97ba                	add	a5,a5,a4
    80005f0a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005f0e:	854a                	mv	a0,s2
    80005f10:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005f14:	bafff0ef          	jal	80005ac2 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005f18:	8885                	andi	s1,s1,1
    80005f1a:	f0fd                	bnez	s1,80005f00 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005f1c:	0001f517          	auipc	a0,0x1f
    80005f20:	cf450513          	addi	a0,a0,-780 # 80024c10 <disk+0x128>
    80005f24:	d69fa0ef          	jal	80000c8c <release>
}
    80005f28:	70a6                	ld	ra,104(sp)
    80005f2a:	7406                	ld	s0,96(sp)
    80005f2c:	64e6                	ld	s1,88(sp)
    80005f2e:	6946                	ld	s2,80(sp)
    80005f30:	69a6                	ld	s3,72(sp)
    80005f32:	6a06                	ld	s4,64(sp)
    80005f34:	7ae2                	ld	s5,56(sp)
    80005f36:	7b42                	ld	s6,48(sp)
    80005f38:	7ba2                	ld	s7,40(sp)
    80005f3a:	7c02                	ld	s8,32(sp)
    80005f3c:	6ce2                	ld	s9,24(sp)
    80005f3e:	6165                	addi	sp,sp,112
    80005f40:	8082                	ret

0000000080005f42 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005f42:	1101                	addi	sp,sp,-32
    80005f44:	ec06                	sd	ra,24(sp)
    80005f46:	e822                	sd	s0,16(sp)
    80005f48:	e426                	sd	s1,8(sp)
    80005f4a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005f4c:	0001f497          	auipc	s1,0x1f
    80005f50:	b9c48493          	addi	s1,s1,-1124 # 80024ae8 <disk>
    80005f54:	0001f517          	auipc	a0,0x1f
    80005f58:	cbc50513          	addi	a0,a0,-836 # 80024c10 <disk+0x128>
    80005f5c:	c99fa0ef          	jal	80000bf4 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005f60:	100017b7          	lui	a5,0x10001
    80005f64:	53b8                	lw	a4,96(a5)
    80005f66:	8b0d                	andi	a4,a4,3
    80005f68:	100017b7          	lui	a5,0x10001
    80005f6c:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005f6e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005f72:	689c                	ld	a5,16(s1)
    80005f74:	0204d703          	lhu	a4,32(s1)
    80005f78:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005f7c:	04f70663          	beq	a4,a5,80005fc8 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80005f80:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005f84:	6898                	ld	a4,16(s1)
    80005f86:	0204d783          	lhu	a5,32(s1)
    80005f8a:	8b9d                	andi	a5,a5,7
    80005f8c:	078e                	slli	a5,a5,0x3
    80005f8e:	97ba                	add	a5,a5,a4
    80005f90:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005f92:	00278713          	addi	a4,a5,2
    80005f96:	0712                	slli	a4,a4,0x4
    80005f98:	9726                	add	a4,a4,s1
    80005f9a:	01074703          	lbu	a4,16(a4)
    80005f9e:	e321                	bnez	a4,80005fde <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005fa0:	0789                	addi	a5,a5,2
    80005fa2:	0792                	slli	a5,a5,0x4
    80005fa4:	97a6                	add	a5,a5,s1
    80005fa6:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005fa8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005fac:	daffb0ef          	jal	80001d5a <wakeup>

    disk.used_idx += 1;
    80005fb0:	0204d783          	lhu	a5,32(s1)
    80005fb4:	2785                	addiw	a5,a5,1
    80005fb6:	17c2                	slli	a5,a5,0x30
    80005fb8:	93c1                	srli	a5,a5,0x30
    80005fba:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005fbe:	6898                	ld	a4,16(s1)
    80005fc0:	00275703          	lhu	a4,2(a4)
    80005fc4:	faf71ee3          	bne	a4,a5,80005f80 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005fc8:	0001f517          	auipc	a0,0x1f
    80005fcc:	c4850513          	addi	a0,a0,-952 # 80024c10 <disk+0x128>
    80005fd0:	cbdfa0ef          	jal	80000c8c <release>
}
    80005fd4:	60e2                	ld	ra,24(sp)
    80005fd6:	6442                	ld	s0,16(sp)
    80005fd8:	64a2                	ld	s1,8(sp)
    80005fda:	6105                	addi	sp,sp,32
    80005fdc:	8082                	ret
      panic("virtio_disk_intr status");
    80005fde:	00003517          	auipc	a0,0x3
    80005fe2:	81a50513          	addi	a0,a0,-2022 # 800087f8 <etext+0x7f8>
    80005fe6:	faefa0ef          	jal	80000794 <panic>

0000000080005fea <sys_yield>:
#include "proc.h"
#include "defs.h"


void
sys_yield(void){
    80005fea:	1141                	addi	sp,sp,-16
    80005fec:	e406                	sd	ra,8(sp)
    80005fee:	e022                	sd	s0,0(sp)
    80005ff0:	0800                	addi	s0,sp,16
    setyieldpid(myproc()->pid);
    80005ff2:	93dfb0ef          	jal	8000192e <myproc>
    80005ff6:	5908                	lw	a0,48(a0)
    80005ff8:	d98fc0ef          	jal	80002590 <setyieldpid>
    yield();
    80005ffc:	e4efc0ef          	jal	8000264a <yield>
    return;
}
    80006000:	60a2                	ld	ra,8(sp)
    80006002:	6402                	ld	s0,0(sp)
    80006004:	0141                	addi	sp,sp,16
    80006006:	8082                	ret

0000000080006008 <sys_fcfsmode>:


int
sys_fcfsmode(void){
    80006008:	1141                	addi	sp,sp,-16
    8000600a:	e406                	sd	ra,8(sp)
    8000600c:	e022                	sd	s0,0(sp)
    8000600e:	0800                	addi	s0,sp,16
    if(fcfsmode() == -1){
    80006010:	be8fc0ef          	jal	800023f8 <fcfsmode>
    80006014:	57fd                	li	a5,-1
    80006016:	00f50b63          	beq	a0,a5,8000602c <sys_fcfsmode+0x24>
        //printf("The mode is already fcfs\n");
        return -1;
    }
    printf("The mode is now FCFS\n");
    8000601a:	00002517          	auipc	a0,0x2
    8000601e:	7f650513          	addi	a0,a0,2038 # 80008810 <etext+0x810>
    80006022:	ca0fa0ef          	jal	800004c2 <printf>
    yield();
    80006026:	e24fc0ef          	jal	8000264a <yield>
    return 0;
    8000602a:	4501                	li	a0,0
}
    8000602c:	60a2                	ld	ra,8(sp)
    8000602e:	6402                	ld	s0,0(sp)
    80006030:	0141                	addi	sp,sp,16
    80006032:	8082                	ret

0000000080006034 <sys_mlfqmode>:

int
sys_mlfqmode(void){
    80006034:	1141                	addi	sp,sp,-16
    80006036:	e406                	sd	ra,8(sp)
    80006038:	e022                	sd	s0,0(sp)
    8000603a:	0800                	addi	s0,sp,16
    if(mlfqmode() == -1){
    8000603c:	b28fc0ef          	jal	80002364 <mlfqmode>
    80006040:	57fd                	li	a5,-1
    80006042:	00f50b63          	beq	a0,a5,80006058 <sys_mlfqmode+0x24>
        //printf("The mode is already mlfq\n");
        return -1;
    }
    printf("The mode is now MLFQ\n");
    80006046:	00002517          	auipc	a0,0x2
    8000604a:	7e250513          	addi	a0,a0,2018 # 80008828 <etext+0x828>
    8000604e:	c74fa0ef          	jal	800004c2 <printf>
    yield();
    80006052:	df8fc0ef          	jal	8000264a <yield>
    return 0;
    80006056:	4501                	li	a0,0
}
    80006058:	60a2                	ld	ra,8(sp)
    8000605a:	6402                	ld	s0,0(sp)
    8000605c:	0141                	addi	sp,sp,16
    8000605e:	8082                	ret

0000000080006060 <sys_getlev>:

int
sys_getlev(void){
    80006060:	1141                	addi	sp,sp,-16
    80006062:	e406                	sd	ra,8(sp)
    80006064:	e022                	sd	s0,0(sp)
    80006066:	0800                	addi	s0,sp,16
    struct proc *p = myproc();
    80006068:	8c7fb0ef          	jal	8000192e <myproc>
    int lev = getlev(p);
    8000606c:	9f5fc0ef          	jal	80002a60 <getlev>
    return lev;
}
    80006070:	60a2                	ld	ra,8(sp)
    80006072:	6402                	ld	s0,0(sp)
    80006074:	0141                	addi	sp,sp,16
    80006076:	8082                	ret

0000000080006078 <sys_setpriority>:

int
sys_setpriority(void){
    80006078:	1101                	addi	sp,sp,-32
    8000607a:	ec06                	sd	ra,24(sp)
    8000607c:	e822                	sd	s0,16(sp)
    8000607e:	1000                	addi	s0,sp,32
    int pid, np;
    argint(0, &pid);
    80006080:	fec40593          	addi	a1,s0,-20
    80006084:	4501                	li	a0,0
    80006086:	f01fc0ef          	jal	80002f86 <argint>
    argint(1, &np);
    8000608a:	fe840593          	addi	a1,s0,-24
    8000608e:	4505                	li	a0,1
    80006090:	ef7fc0ef          	jal	80002f86 <argint>
    
    return setpriority(pid, np);
    80006094:	fe842583          	lw	a1,-24(s0)
    80006098:	fec42503          	lw	a0,-20(s0)
    8000609c:	a01fc0ef          	jal	80002a9c <setpriority>
}
    800060a0:	60e2                	ld	ra,24(sp)
    800060a2:	6442                	ld	s0,16(sp)
    800060a4:	6105                	addi	sp,sp,32
    800060a6:	8082                	ret
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
