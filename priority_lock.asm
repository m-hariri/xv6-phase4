
_priority_lock:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
        wait();
}

int main()

{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
    init1();
   6:	e8 d5 01 00 00       	call   1e0 <init1>
    start1();
   b:	e8 f0 01 00 00       	call   200 <start1>
    exit();
  10:	e8 c8 04 00 00       	call   4dd <exit>
  15:	66 90                	xchg   %ax,%ax
  17:	66 90                	xchg   %ax,%ax
  19:	66 90                	xchg   %ax,%ax
  1b:	66 90                	xchg   %ax,%ax
  1d:	66 90                	xchg   %ax,%ax
  1f:	90                   	nop

00000020 <in_remain>:
{
  20:	55                   	push   %ebp
  21:	89 e5                	mov    %esp,%ebp
  23:	53                   	push   %ebx
  24:	83 ec 04             	sub    $0x4,%esp
  27:	8b 5d 08             	mov    0x8(%ebp),%ebx
    int time = random() % 1000;
  2a:	e8 91 04 00 00       	call   4c0 <random>
    ATOMIC(printf(1, "Process %d is in remain section for %d ticks\n", i, time));
  2f:	83 ec 08             	sub    $0x8,%esp
  32:	6a 01                	push   $0x1
  34:	6a 01                	push   $0x1
  36:	e8 92 05 00 00       	call   5cd <sem_acquire>
  3b:	68 90 01 00 00       	push   $0x190
  40:	53                   	push   %ebx
  41:	68 b8 09 00 00       	push   $0x9b8
  46:	6a 01                	push   $0x1
  48:	e8 43 06 00 00       	call   690 <printf>
  4d:	83 c4 14             	add    $0x14,%esp
  50:	6a 01                	push   $0x1
  52:	e8 7e 05 00 00       	call   5d5 <sem_release>
    sleep(time);
  57:	c7 45 08 90 01 00 00 	movl   $0x190,0x8(%ebp)
}
  5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    sleep(time);
  61:	83 c4 10             	add    $0x10,%esp
}
  64:	c9                   	leave  
    sleep(time);
  65:	e9 03 05 00 00       	jmp    56d <sleep>
  6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000070 <in_critical>:
{
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  73:	53                   	push   %ebx
  74:	83 ec 04             	sub    $0x4,%esp
  77:	8b 5d 08             	mov    0x8(%ebp),%ebx
    int time = random() % 1000;
  7a:	e8 41 04 00 00       	call   4c0 <random>
    ATOMIC(printf(1, "Process %d is in critical section for %d ticks\n", i, time));
  7f:	83 ec 08             	sub    $0x8,%esp
  82:	6a 01                	push   $0x1
  84:	6a 01                	push   $0x1
  86:	e8 42 05 00 00       	call   5cd <sem_acquire>
  8b:	68 2c 01 00 00       	push   $0x12c
  90:	53                   	push   %ebx
  91:	68 e8 09 00 00       	push   $0x9e8
  96:	6a 01                	push   $0x1
  98:	e8 f3 05 00 00       	call   690 <printf>
  9d:	83 c4 14             	add    $0x14,%esp
  a0:	6a 01                	push   $0x1
  a2:	e8 2e 05 00 00       	call   5d5 <sem_release>
    sleep(time);
  a7:	c7 45 08 2c 01 00 00 	movl   $0x12c,0x8(%ebp)
}
  ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    sleep(time);
  b1:	83 c4 10             	add    $0x10,%esp
}
  b4:	c9                   	leave  
    sleep(time);
  b5:	e9 b3 04 00 00       	jmp    56d <sleep>
  ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000000c0 <process>:
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	56                   	push   %esi
  c4:	53                   	push   %ebx
  c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  c8:	8b 75 08             	mov    0x8(%ebp),%esi
    set_bjf_priority(pid, pid);
  cb:	83 ec 08             	sub    $0x8,%esp
  ce:	53                   	push   %ebx
  cf:	53                   	push   %ebx
  d0:	e8 e0 04 00 00       	call   5b5 <set_bjf_priority>
    while (m<5)
  d5:	83 c4 10             	add    $0x10,%esp
  d8:	83 3d 68 0e 00 00 04 	cmpl   $0x4,0xe68
  df:	0f 8f f1 00 00 00    	jg     1d6 <process+0x116>
  e5:	8d 76 00             	lea    0x0(%esi),%esi
        ATOMIC(printf(1, "Process %d wants to enter to the critical section\n", pid));
  e8:	83 ec 08             	sub    $0x8,%esp
  eb:	6a 01                	push   $0x1
  ed:	6a 01                	push   $0x1
  ef:	e8 d9 04 00 00       	call   5cd <sem_acquire>
  f4:	83 c4 0c             	add    $0xc,%esp
  f7:	53                   	push   %ebx
  f8:	68 18 0a 00 00       	push   $0xa18
  fd:	6a 01                	push   $0x1
  ff:	e8 8c 05 00 00       	call   690 <printf>
 104:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 10b:	e8 c5 04 00 00       	call   5d5 <sem_release>
        sem_acquire(0,i);
 110:	58                   	pop    %eax
 111:	5a                   	pop    %edx
 112:	56                   	push   %esi
 113:	6a 00                	push   $0x0
 115:	e8 b3 04 00 00       	call   5cd <sem_acquire>
    int time = random() % 1000;
 11a:	e8 a1 03 00 00       	call   4c0 <random>
    ATOMIC(printf(1, "Process %d is in critical section for %d ticks\n", i, time));
 11f:	59                   	pop    %ecx
 120:	58                   	pop    %eax
 121:	6a 01                	push   $0x1
 123:	6a 01                	push   $0x1
 125:	e8 a3 04 00 00       	call   5cd <sem_acquire>
 12a:	68 2c 01 00 00       	push   $0x12c
 12f:	53                   	push   %ebx
 130:	68 e8 09 00 00       	push   $0x9e8
 135:	6a 01                	push   $0x1
 137:	e8 54 05 00 00       	call   690 <printf>
 13c:	83 c4 14             	add    $0x14,%esp
 13f:	6a 01                	push   $0x1
 141:	e8 8f 04 00 00       	call   5d5 <sem_release>
    sleep(time);
 146:	c7 04 24 2c 01 00 00 	movl   $0x12c,(%esp)
 14d:	e8 1b 04 00 00       	call   56d <sleep>
        sem_release(0);
 152:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 159:	e8 77 04 00 00       	call   5d5 <sem_release>
        ATOMIC(printf(1, "Process %d has left critical section\n", pid));
 15e:	58                   	pop    %eax
 15f:	5a                   	pop    %edx
 160:	6a 01                	push   $0x1
 162:	6a 01                	push   $0x1
 164:	e8 64 04 00 00       	call   5cd <sem_acquire>
 169:	83 c4 0c             	add    $0xc,%esp
 16c:	53                   	push   %ebx
 16d:	68 4c 0a 00 00       	push   $0xa4c
 172:	6a 01                	push   $0x1
 174:	e8 17 05 00 00       	call   690 <printf>
 179:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 180:	e8 50 04 00 00       	call   5d5 <sem_release>
    int time = random() % 1000;
 185:	e8 36 03 00 00       	call   4c0 <random>
    ATOMIC(printf(1, "Process %d is in remain section for %d ticks\n", i, time));
 18a:	59                   	pop    %ecx
 18b:	58                   	pop    %eax
 18c:	6a 01                	push   $0x1
 18e:	6a 01                	push   $0x1
 190:	e8 38 04 00 00       	call   5cd <sem_acquire>
 195:	68 90 01 00 00       	push   $0x190
 19a:	53                   	push   %ebx
 19b:	68 b8 09 00 00       	push   $0x9b8
 1a0:	6a 01                	push   $0x1
 1a2:	e8 e9 04 00 00       	call   690 <printf>
 1a7:	83 c4 14             	add    $0x14,%esp
 1aa:	6a 01                	push   $0x1
 1ac:	e8 24 04 00 00       	call   5d5 <sem_release>
    sleep(time);
 1b1:	c7 04 24 90 01 00 00 	movl   $0x190,(%esp)
 1b8:	e8 b0 03 00 00       	call   56d <sleep>
        m++;
 1bd:	a1 68 0e 00 00       	mov    0xe68,%eax
    while (m<5)
 1c2:	83 c4 10             	add    $0x10,%esp
        m++;
 1c5:	83 c0 01             	add    $0x1,%eax
 1c8:	a3 68 0e 00 00       	mov    %eax,0xe68
    while (m<5)
 1cd:	83 f8 04             	cmp    $0x4,%eax
 1d0:	0f 8e 12 ff ff ff    	jle    e8 <process+0x28>
}
 1d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1d9:	5b                   	pop    %ebx
 1da:	5e                   	pop    %esi
 1db:	5d                   	pop    %ebp
 1dc:	c3                   	ret    
 1dd:	8d 76 00             	lea    0x0(%esi),%esi

000001e0 <init1>:
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	83 ec 10             	sub    $0x10,%esp
    sem_init(0, 1);
 1e6:	6a 01                	push   $0x1
 1e8:	6a 00                	push   $0x0
 1ea:	e8 d6 03 00 00       	call   5c5 <sem_init>
    sem_init(MUTEX, 1);
 1ef:	58                   	pop    %eax
 1f0:	5a                   	pop    %edx
 1f1:	6a 01                	push   $0x1
 1f3:	6a 01                	push   $0x1
 1f5:	e8 cb 03 00 00       	call   5c5 <sem_init>
}
 1fa:	83 c4 10             	add    $0x10,%esp
 1fd:	c9                   	leave  
 1fe:	c3                   	ret    
 1ff:	90                   	nop

00000200 <start1>:
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	53                   	push   %ebx
    for (int i = 0; i < PROCESS_NUM; i++)
 204:	31 db                	xor    %ebx,%ebx
{
 206:	83 ec 04             	sub    $0x4,%esp
        if (fork() == 0)
 209:	e8 c7 02 00 00       	call   4d5 <fork>
 20e:	85 c0                	test   %eax,%eax
 210:	74 25                	je     237 <start1+0x37>
    for (int i = 0; i < PROCESS_NUM; i++)
 212:	83 c3 01             	add    $0x1,%ebx
 215:	83 fb 05             	cmp    $0x5,%ebx
 218:	75 ef                	jne    209 <start1+0x9>
        wait();
 21a:	e8 c6 02 00 00       	call   4e5 <wait>
 21f:	e8 c1 02 00 00       	call   4e5 <wait>
 224:	e8 bc 02 00 00       	call   4e5 <wait>
 229:	e8 b7 02 00 00       	call   4e5 <wait>
}
 22e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 231:	c9                   	leave  
        wait();
 232:	e9 ae 02 00 00       	jmp    4e5 <wait>
            srand(getpid());
 237:	e8 21 03 00 00       	call   55d <getpid>
 23c:	83 ec 0c             	sub    $0xc,%esp
 23f:	50                   	push   %eax
 240:	e8 6b 02 00 00       	call   4b0 <srand>
            process(i,getpid());
 245:	e8 13 03 00 00       	call   55d <getpid>
 24a:	5a                   	pop    %edx
 24b:	59                   	pop    %ecx
 24c:	50                   	push   %eax
 24d:	53                   	push   %ebx
 24e:	e8 6d fe ff ff       	call   c0 <process>
            exit();
 253:	e8 85 02 00 00       	call   4dd <exit>
 258:	66 90                	xchg   %ax,%ax
 25a:	66 90                	xchg   %ax,%ax
 25c:	66 90                	xchg   %ax,%ax
 25e:	66 90                	xchg   %ax,%ax

00000260 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 260:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 261:	31 c0                	xor    %eax,%eax
{
 263:	89 e5                	mov    %esp,%ebp
 265:	53                   	push   %ebx
 266:	8b 4d 08             	mov    0x8(%ebp),%ecx
 269:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 26c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 270:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 274:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 277:	83 c0 01             	add    $0x1,%eax
 27a:	84 d2                	test   %dl,%dl
 27c:	75 f2                	jne    270 <strcpy+0x10>
    ;
  return os;
}
 27e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 281:	89 c8                	mov    %ecx,%eax
 283:	c9                   	leave  
 284:	c3                   	ret    
 285:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 28c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000290 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	53                   	push   %ebx
 294:	8b 55 08             	mov    0x8(%ebp),%edx
 297:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 29a:	0f b6 02             	movzbl (%edx),%eax
 29d:	84 c0                	test   %al,%al
 29f:	75 17                	jne    2b8 <strcmp+0x28>
 2a1:	eb 3a                	jmp    2dd <strcmp+0x4d>
 2a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2a7:	90                   	nop
 2a8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 2ac:	83 c2 01             	add    $0x1,%edx
 2af:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 2b2:	84 c0                	test   %al,%al
 2b4:	74 1a                	je     2d0 <strcmp+0x40>
    p++, q++;
 2b6:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 2b8:	0f b6 19             	movzbl (%ecx),%ebx
 2bb:	38 c3                	cmp    %al,%bl
 2bd:	74 e9                	je     2a8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 2bf:	29 d8                	sub    %ebx,%eax
}
 2c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2c4:	c9                   	leave  
 2c5:	c3                   	ret    
 2c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2cd:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 2d0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 2d4:	31 c0                	xor    %eax,%eax
 2d6:	29 d8                	sub    %ebx,%eax
}
 2d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2db:	c9                   	leave  
 2dc:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 2dd:	0f b6 19             	movzbl (%ecx),%ebx
 2e0:	31 c0                	xor    %eax,%eax
 2e2:	eb db                	jmp    2bf <strcmp+0x2f>
 2e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2ef:	90                   	nop

000002f0 <strlen>:

uint
strlen(const char *s)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 2f6:	80 3a 00             	cmpb   $0x0,(%edx)
 2f9:	74 15                	je     310 <strlen+0x20>
 2fb:	31 c0                	xor    %eax,%eax
 2fd:	8d 76 00             	lea    0x0(%esi),%esi
 300:	83 c0 01             	add    $0x1,%eax
 303:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 307:	89 c1                	mov    %eax,%ecx
 309:	75 f5                	jne    300 <strlen+0x10>
    ;
  return n;
}
 30b:	89 c8                	mov    %ecx,%eax
 30d:	5d                   	pop    %ebp
 30e:	c3                   	ret    
 30f:	90                   	nop
  for(n = 0; s[n]; n++)
 310:	31 c9                	xor    %ecx,%ecx
}
 312:	5d                   	pop    %ebp
 313:	89 c8                	mov    %ecx,%eax
 315:	c3                   	ret    
 316:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 31d:	8d 76 00             	lea    0x0(%esi),%esi

00000320 <memset>:

void*
memset(void *dst, int c, uint n)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	57                   	push   %edi
 324:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 327:	8b 4d 10             	mov    0x10(%ebp),%ecx
 32a:	8b 45 0c             	mov    0xc(%ebp),%eax
 32d:	89 d7                	mov    %edx,%edi
 32f:	fc                   	cld    
 330:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 332:	8b 7d fc             	mov    -0x4(%ebp),%edi
 335:	89 d0                	mov    %edx,%eax
 337:	c9                   	leave  
 338:	c3                   	ret    
 339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000340 <strchr>:

char*
strchr(const char *s, char c)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	8b 45 08             	mov    0x8(%ebp),%eax
 346:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 34a:	0f b6 10             	movzbl (%eax),%edx
 34d:	84 d2                	test   %dl,%dl
 34f:	75 12                	jne    363 <strchr+0x23>
 351:	eb 1d                	jmp    370 <strchr+0x30>
 353:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 357:	90                   	nop
 358:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 35c:	83 c0 01             	add    $0x1,%eax
 35f:	84 d2                	test   %dl,%dl
 361:	74 0d                	je     370 <strchr+0x30>
    if(*s == c)
 363:	38 d1                	cmp    %dl,%cl
 365:	75 f1                	jne    358 <strchr+0x18>
      return (char*)s;
  return 0;
}
 367:	5d                   	pop    %ebp
 368:	c3                   	ret    
 369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 370:	31 c0                	xor    %eax,%eax
}
 372:	5d                   	pop    %ebp
 373:	c3                   	ret    
 374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 37b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 37f:	90                   	nop

00000380 <gets>:

char*
gets(char *buf, int max)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	57                   	push   %edi
 384:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 385:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 388:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 389:	31 db                	xor    %ebx,%ebx
{
 38b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 38e:	eb 27                	jmp    3b7 <gets+0x37>
    cc = read(0, &c, 1);
 390:	83 ec 04             	sub    $0x4,%esp
 393:	6a 01                	push   $0x1
 395:	57                   	push   %edi
 396:	6a 00                	push   $0x0
 398:	e8 58 01 00 00       	call   4f5 <read>
    if(cc < 1)
 39d:	83 c4 10             	add    $0x10,%esp
 3a0:	85 c0                	test   %eax,%eax
 3a2:	7e 1d                	jle    3c1 <gets+0x41>
      break;
    buf[i++] = c;
 3a4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3a8:	8b 55 08             	mov    0x8(%ebp),%edx
 3ab:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 3af:	3c 0a                	cmp    $0xa,%al
 3b1:	74 1d                	je     3d0 <gets+0x50>
 3b3:	3c 0d                	cmp    $0xd,%al
 3b5:	74 19                	je     3d0 <gets+0x50>
  for(i=0; i+1 < max; ){
 3b7:	89 de                	mov    %ebx,%esi
 3b9:	83 c3 01             	add    $0x1,%ebx
 3bc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3bf:	7c cf                	jl     390 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 3c1:	8b 45 08             	mov    0x8(%ebp),%eax
 3c4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 3c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3cb:	5b                   	pop    %ebx
 3cc:	5e                   	pop    %esi
 3cd:	5f                   	pop    %edi
 3ce:	5d                   	pop    %ebp
 3cf:	c3                   	ret    
  buf[i] = '\0';
 3d0:	8b 45 08             	mov    0x8(%ebp),%eax
 3d3:	89 de                	mov    %ebx,%esi
 3d5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 3d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3dc:	5b                   	pop    %ebx
 3dd:	5e                   	pop    %esi
 3de:	5f                   	pop    %edi
 3df:	5d                   	pop    %ebp
 3e0:	c3                   	ret    
 3e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ef:	90                   	nop

000003f0 <stat>:

int
stat(const char *n, struct stat *st)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	56                   	push   %esi
 3f4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3f5:	83 ec 08             	sub    $0x8,%esp
 3f8:	6a 00                	push   $0x0
 3fa:	ff 75 08             	push   0x8(%ebp)
 3fd:	e8 1b 01 00 00       	call   51d <open>
  if(fd < 0)
 402:	83 c4 10             	add    $0x10,%esp
 405:	85 c0                	test   %eax,%eax
 407:	78 27                	js     430 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 409:	83 ec 08             	sub    $0x8,%esp
 40c:	ff 75 0c             	push   0xc(%ebp)
 40f:	89 c3                	mov    %eax,%ebx
 411:	50                   	push   %eax
 412:	e8 1e 01 00 00       	call   535 <fstat>
  close(fd);
 417:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 41a:	89 c6                	mov    %eax,%esi
  close(fd);
 41c:	e8 e4 00 00 00       	call   505 <close>
  return r;
 421:	83 c4 10             	add    $0x10,%esp
}
 424:	8d 65 f8             	lea    -0x8(%ebp),%esp
 427:	89 f0                	mov    %esi,%eax
 429:	5b                   	pop    %ebx
 42a:	5e                   	pop    %esi
 42b:	5d                   	pop    %ebp
 42c:	c3                   	ret    
 42d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 430:	be ff ff ff ff       	mov    $0xffffffff,%esi
 435:	eb ed                	jmp    424 <stat+0x34>
 437:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 43e:	66 90                	xchg   %ax,%ax

00000440 <atoi>:

int
atoi(const char *s)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	53                   	push   %ebx
 444:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 447:	0f be 02             	movsbl (%edx),%eax
 44a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 44d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 450:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 455:	77 1e                	ja     475 <atoi+0x35>
 457:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 45e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 460:	83 c2 01             	add    $0x1,%edx
 463:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 466:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 46a:	0f be 02             	movsbl (%edx),%eax
 46d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 470:	80 fb 09             	cmp    $0x9,%bl
 473:	76 eb                	jbe    460 <atoi+0x20>
  return n;
}
 475:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 478:	89 c8                	mov    %ecx,%eax
 47a:	c9                   	leave  
 47b:	c3                   	ret    
 47c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000480 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	57                   	push   %edi
 484:	8b 45 10             	mov    0x10(%ebp),%eax
 487:	8b 55 08             	mov    0x8(%ebp),%edx
 48a:	56                   	push   %esi
 48b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 48e:	85 c0                	test   %eax,%eax
 490:	7e 13                	jle    4a5 <memmove+0x25>
 492:	01 d0                	add    %edx,%eax
  dst = vdst;
 494:	89 d7                	mov    %edx,%edi
 496:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 49d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 4a0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 4a1:	39 f8                	cmp    %edi,%eax
 4a3:	75 fb                	jne    4a0 <memmove+0x20>
  return vdst;
}
 4a5:	5e                   	pop    %esi
 4a6:	89 d0                	mov    %edx,%eax
 4a8:	5f                   	pop    %edi
 4a9:	5d                   	pop    %ebp
 4aa:	c3                   	ret    
 4ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4af:	90                   	nop

000004b0 <srand>:

static uint seed = 1;

void
srand(uint s)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
  seed = s;
 4b3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4b6:	5d                   	pop    %ebp
  seed = s;
 4b7:	a3 64 0e 00 00       	mov    %eax,0xe64
}
 4bc:	c3                   	ret    
 4bd:	8d 76 00             	lea    0x0(%esi),%esi

000004c0 <random>:

uint
random(void)
{
  seed = seed
    * 1103515245
 4c0:	69 05 64 0e 00 00 6d 	imul   $0x41c64e6d,0xe64,%eax
 4c7:	4e c6 41 
    + 12345
 4ca:	05 39 30 00 00       	add    $0x3039,%eax
  seed = seed
 4cf:	a3 64 0e 00 00       	mov    %eax,0xe64
    % (1 << 31);
  return seed;
}
 4d4:	c3                   	ret    

000004d5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4d5:	b8 01 00 00 00       	mov    $0x1,%eax
 4da:	cd 40                	int    $0x40
 4dc:	c3                   	ret    

000004dd <exit>:
SYSCALL(exit)
 4dd:	b8 02 00 00 00       	mov    $0x2,%eax
 4e2:	cd 40                	int    $0x40
 4e4:	c3                   	ret    

000004e5 <wait>:
SYSCALL(wait)
 4e5:	b8 03 00 00 00       	mov    $0x3,%eax
 4ea:	cd 40                	int    $0x40
 4ec:	c3                   	ret    

000004ed <pipe>:
SYSCALL(pipe)
 4ed:	b8 04 00 00 00       	mov    $0x4,%eax
 4f2:	cd 40                	int    $0x40
 4f4:	c3                   	ret    

000004f5 <read>:
SYSCALL(read)
 4f5:	b8 05 00 00 00       	mov    $0x5,%eax
 4fa:	cd 40                	int    $0x40
 4fc:	c3                   	ret    

000004fd <write>:
SYSCALL(write)
 4fd:	b8 10 00 00 00       	mov    $0x10,%eax
 502:	cd 40                	int    $0x40
 504:	c3                   	ret    

00000505 <close>:
SYSCALL(close)
 505:	b8 15 00 00 00       	mov    $0x15,%eax
 50a:	cd 40                	int    $0x40
 50c:	c3                   	ret    

0000050d <kill>:
SYSCALL(kill)
 50d:	b8 06 00 00 00       	mov    $0x6,%eax
 512:	cd 40                	int    $0x40
 514:	c3                   	ret    

00000515 <exec>:
SYSCALL(exec)
 515:	b8 07 00 00 00       	mov    $0x7,%eax
 51a:	cd 40                	int    $0x40
 51c:	c3                   	ret    

0000051d <open>:
SYSCALL(open)
 51d:	b8 0f 00 00 00       	mov    $0xf,%eax
 522:	cd 40                	int    $0x40
 524:	c3                   	ret    

00000525 <mknod>:
SYSCALL(mknod)
 525:	b8 11 00 00 00       	mov    $0x11,%eax
 52a:	cd 40                	int    $0x40
 52c:	c3                   	ret    

0000052d <unlink>:
SYSCALL(unlink)
 52d:	b8 12 00 00 00       	mov    $0x12,%eax
 532:	cd 40                	int    $0x40
 534:	c3                   	ret    

00000535 <fstat>:
SYSCALL(fstat)
 535:	b8 08 00 00 00       	mov    $0x8,%eax
 53a:	cd 40                	int    $0x40
 53c:	c3                   	ret    

0000053d <link>:
SYSCALL(link)
 53d:	b8 13 00 00 00       	mov    $0x13,%eax
 542:	cd 40                	int    $0x40
 544:	c3                   	ret    

00000545 <mkdir>:
SYSCALL(mkdir)
 545:	b8 14 00 00 00       	mov    $0x14,%eax
 54a:	cd 40                	int    $0x40
 54c:	c3                   	ret    

0000054d <chdir>:
SYSCALL(chdir)
 54d:	b8 09 00 00 00       	mov    $0x9,%eax
 552:	cd 40                	int    $0x40
 554:	c3                   	ret    

00000555 <dup>:
SYSCALL(dup)
 555:	b8 0a 00 00 00       	mov    $0xa,%eax
 55a:	cd 40                	int    $0x40
 55c:	c3                   	ret    

0000055d <getpid>:
SYSCALL(getpid)
 55d:	b8 0b 00 00 00       	mov    $0xb,%eax
 562:	cd 40                	int    $0x40
 564:	c3                   	ret    

00000565 <sbrk>:
SYSCALL(sbrk)
 565:	b8 0c 00 00 00       	mov    $0xc,%eax
 56a:	cd 40                	int    $0x40
 56c:	c3                   	ret    

0000056d <sleep>:
SYSCALL(sleep)
 56d:	b8 0d 00 00 00       	mov    $0xd,%eax
 572:	cd 40                	int    $0x40
 574:	c3                   	ret    

00000575 <uptime>:
SYSCALL(uptime)
 575:	b8 0e 00 00 00       	mov    $0xe,%eax
 57a:	cd 40                	int    $0x40
 57c:	c3                   	ret    

0000057d <find_largest_prime_factor>:
SYSCALL(find_largest_prime_factor)
 57d:	b8 16 00 00 00       	mov    $0x16,%eax
 582:	cd 40                	int    $0x40
 584:	c3                   	ret    

00000585 <change_file_size>:
SYSCALL(change_file_size)
 585:	b8 17 00 00 00       	mov    $0x17,%eax
 58a:	cd 40                	int    $0x40
 58c:	c3                   	ret    

0000058d <get_callers>:
SYSCALL(get_callers)
 58d:	b8 18 00 00 00       	mov    $0x18,%eax
 592:	cd 40                	int    $0x40
 594:	c3                   	ret    

00000595 <get_parent_pid>:
SYSCALL(get_parent_pid)
 595:	b8 19 00 00 00       	mov    $0x19,%eax
 59a:	cd 40                	int    $0x40
 59c:	c3                   	ret    

0000059d <change_scheduling_queue>:
SYSCALL(change_scheduling_queue)
 59d:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5a2:	cd 40                	int    $0x40
 5a4:	c3                   	ret    

000005a5 <set_bjf_params_process>:
SYSCALL(set_bjf_params_process)
 5a5:	b8 1c 00 00 00       	mov    $0x1c,%eax
 5aa:	cd 40                	int    $0x40
 5ac:	c3                   	ret    

000005ad <set_bjf_params_system>:
SYSCALL(set_bjf_params_system)
 5ad:	b8 1d 00 00 00       	mov    $0x1d,%eax
 5b2:	cd 40                	int    $0x40
 5b4:	c3                   	ret    

000005b5 <set_bjf_priority>:
SYSCALL(set_bjf_priority)
 5b5:	b8 1e 00 00 00       	mov    $0x1e,%eax
 5ba:	cd 40                	int    $0x40
 5bc:	c3                   	ret    

000005bd <print_process_info>:
SYSCALL(print_process_info)
 5bd:	b8 1f 00 00 00       	mov    $0x1f,%eax
 5c2:	cd 40                	int    $0x40
 5c4:	c3                   	ret    

000005c5 <sem_init>:
SYSCALL(sem_init)
 5c5:	b8 20 00 00 00       	mov    $0x20,%eax
 5ca:	cd 40                	int    $0x40
 5cc:	c3                   	ret    

000005cd <sem_acquire>:
SYSCALL(sem_acquire)
 5cd:	b8 21 00 00 00       	mov    $0x21,%eax
 5d2:	cd 40                	int    $0x40
 5d4:	c3                   	ret    

000005d5 <sem_release>:
SYSCALL(sem_release)
 5d5:	b8 22 00 00 00       	mov    $0x22,%eax
 5da:	cd 40                	int    $0x40
 5dc:	c3                   	ret    
 5dd:	66 90                	xchg   %ax,%ax
 5df:	90                   	nop

000005e0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 5e0:	55                   	push   %ebp
 5e1:	89 e5                	mov    %esp,%ebp
 5e3:	57                   	push   %edi
 5e4:	56                   	push   %esi
 5e5:	53                   	push   %ebx
 5e6:	83 ec 3c             	sub    $0x3c,%esp
 5e9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 5ec:	89 d1                	mov    %edx,%ecx
{
 5ee:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 5f1:	85 d2                	test   %edx,%edx
 5f3:	0f 89 7f 00 00 00    	jns    678 <printint+0x98>
 5f9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 5fd:	74 79                	je     678 <printint+0x98>
    neg = 1;
 5ff:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 606:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 608:	31 db                	xor    %ebx,%ebx
 60a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 60d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 610:	89 c8                	mov    %ecx,%eax
 612:	31 d2                	xor    %edx,%edx
 614:	89 cf                	mov    %ecx,%edi
 616:	f7 75 c4             	divl   -0x3c(%ebp)
 619:	0f b6 92 d4 0a 00 00 	movzbl 0xad4(%edx),%edx
 620:	89 45 c0             	mov    %eax,-0x40(%ebp)
 623:	89 d8                	mov    %ebx,%eax
 625:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 628:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 62b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 62e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 631:	76 dd                	jbe    610 <printint+0x30>
  if(neg)
 633:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 636:	85 c9                	test   %ecx,%ecx
 638:	74 0c                	je     646 <printint+0x66>
    buf[i++] = '-';
 63a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 63f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 641:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 646:	8b 7d b8             	mov    -0x48(%ebp),%edi
 649:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 64d:	eb 07                	jmp    656 <printint+0x76>
 64f:	90                   	nop
    putc(fd, buf[i]);
 650:	0f b6 13             	movzbl (%ebx),%edx
 653:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 656:	83 ec 04             	sub    $0x4,%esp
 659:	88 55 d7             	mov    %dl,-0x29(%ebp)
 65c:	6a 01                	push   $0x1
 65e:	56                   	push   %esi
 65f:	57                   	push   %edi
 660:	e8 98 fe ff ff       	call   4fd <write>
  while(--i >= 0)
 665:	83 c4 10             	add    $0x10,%esp
 668:	39 de                	cmp    %ebx,%esi
 66a:	75 e4                	jne    650 <printint+0x70>
}
 66c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 66f:	5b                   	pop    %ebx
 670:	5e                   	pop    %esi
 671:	5f                   	pop    %edi
 672:	5d                   	pop    %ebp
 673:	c3                   	ret    
 674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 678:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 67f:	eb 87                	jmp    608 <printint+0x28>
 681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 688:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 68f:	90                   	nop

00000690 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 690:	55                   	push   %ebp
 691:	89 e5                	mov    %esp,%ebp
 693:	57                   	push   %edi
 694:	56                   	push   %esi
 695:	53                   	push   %ebx
 696:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 699:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 69c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 69f:	0f b6 13             	movzbl (%ebx),%edx
 6a2:	84 d2                	test   %dl,%dl
 6a4:	74 6a                	je     710 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 6a6:	8d 45 10             	lea    0x10(%ebp),%eax
 6a9:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 6ac:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 6af:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 6b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 6b4:	eb 36                	jmp    6ec <printf+0x5c>
 6b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6bd:	8d 76 00             	lea    0x0(%esi),%esi
 6c0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 6c3:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 6c8:	83 f8 25             	cmp    $0x25,%eax
 6cb:	74 15                	je     6e2 <printf+0x52>
  write(fd, &c, 1);
 6cd:	83 ec 04             	sub    $0x4,%esp
 6d0:	88 55 e7             	mov    %dl,-0x19(%ebp)
 6d3:	6a 01                	push   $0x1
 6d5:	57                   	push   %edi
 6d6:	56                   	push   %esi
 6d7:	e8 21 fe ff ff       	call   4fd <write>
 6dc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 6df:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 6e2:	0f b6 13             	movzbl (%ebx),%edx
 6e5:	83 c3 01             	add    $0x1,%ebx
 6e8:	84 d2                	test   %dl,%dl
 6ea:	74 24                	je     710 <printf+0x80>
    c = fmt[i] & 0xff;
 6ec:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 6ef:	85 c9                	test   %ecx,%ecx
 6f1:	74 cd                	je     6c0 <printf+0x30>
      }
    } else if(state == '%'){
 6f3:	83 f9 25             	cmp    $0x25,%ecx
 6f6:	75 ea                	jne    6e2 <printf+0x52>
      if(c == 'd'){
 6f8:	83 f8 25             	cmp    $0x25,%eax
 6fb:	0f 84 07 01 00 00    	je     808 <printf+0x178>
 701:	83 e8 63             	sub    $0x63,%eax
 704:	83 f8 15             	cmp    $0x15,%eax
 707:	77 17                	ja     720 <printf+0x90>
 709:	ff 24 85 7c 0a 00 00 	jmp    *0xa7c(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 710:	8d 65 f4             	lea    -0xc(%ebp),%esp
 713:	5b                   	pop    %ebx
 714:	5e                   	pop    %esi
 715:	5f                   	pop    %edi
 716:	5d                   	pop    %ebp
 717:	c3                   	ret    
 718:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 71f:	90                   	nop
  write(fd, &c, 1);
 720:	83 ec 04             	sub    $0x4,%esp
 723:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 726:	6a 01                	push   $0x1
 728:	57                   	push   %edi
 729:	56                   	push   %esi
 72a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 72e:	e8 ca fd ff ff       	call   4fd <write>
        putc(fd, c);
 733:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 737:	83 c4 0c             	add    $0xc,%esp
 73a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 73d:	6a 01                	push   $0x1
 73f:	57                   	push   %edi
 740:	56                   	push   %esi
 741:	e8 b7 fd ff ff       	call   4fd <write>
        putc(fd, c);
 746:	83 c4 10             	add    $0x10,%esp
      state = 0;
 749:	31 c9                	xor    %ecx,%ecx
 74b:	eb 95                	jmp    6e2 <printf+0x52>
 74d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 750:	83 ec 0c             	sub    $0xc,%esp
 753:	b9 10 00 00 00       	mov    $0x10,%ecx
 758:	6a 00                	push   $0x0
 75a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 75d:	8b 10                	mov    (%eax),%edx
 75f:	89 f0                	mov    %esi,%eax
 761:	e8 7a fe ff ff       	call   5e0 <printint>
        ap++;
 766:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 76a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 76d:	31 c9                	xor    %ecx,%ecx
 76f:	e9 6e ff ff ff       	jmp    6e2 <printf+0x52>
 774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 778:	8b 45 d0             	mov    -0x30(%ebp),%eax
 77b:	8b 10                	mov    (%eax),%edx
        ap++;
 77d:	83 c0 04             	add    $0x4,%eax
 780:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 783:	85 d2                	test   %edx,%edx
 785:	0f 84 8d 00 00 00    	je     818 <printf+0x188>
        while(*s != 0){
 78b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 78e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 790:	84 c0                	test   %al,%al
 792:	0f 84 4a ff ff ff    	je     6e2 <printf+0x52>
 798:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 79b:	89 d3                	mov    %edx,%ebx
 79d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 7a0:	83 ec 04             	sub    $0x4,%esp
          s++;
 7a3:	83 c3 01             	add    $0x1,%ebx
 7a6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 7a9:	6a 01                	push   $0x1
 7ab:	57                   	push   %edi
 7ac:	56                   	push   %esi
 7ad:	e8 4b fd ff ff       	call   4fd <write>
        while(*s != 0){
 7b2:	0f b6 03             	movzbl (%ebx),%eax
 7b5:	83 c4 10             	add    $0x10,%esp
 7b8:	84 c0                	test   %al,%al
 7ba:	75 e4                	jne    7a0 <printf+0x110>
      state = 0;
 7bc:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 7bf:	31 c9                	xor    %ecx,%ecx
 7c1:	e9 1c ff ff ff       	jmp    6e2 <printf+0x52>
 7c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7cd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 7d0:	83 ec 0c             	sub    $0xc,%esp
 7d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 7d8:	6a 01                	push   $0x1
 7da:	e9 7b ff ff ff       	jmp    75a <printf+0xca>
 7df:	90                   	nop
        putc(fd, *ap);
 7e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 7e3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 7e6:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 7e8:	6a 01                	push   $0x1
 7ea:	57                   	push   %edi
 7eb:	56                   	push   %esi
        putc(fd, *ap);
 7ec:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 7ef:	e8 09 fd ff ff       	call   4fd <write>
        ap++;
 7f4:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 7f8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7fb:	31 c9                	xor    %ecx,%ecx
 7fd:	e9 e0 fe ff ff       	jmp    6e2 <printf+0x52>
 802:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 808:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 80b:	83 ec 04             	sub    $0x4,%esp
 80e:	e9 2a ff ff ff       	jmp    73d <printf+0xad>
 813:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 817:	90                   	nop
          s = "(null)";
 818:	ba 72 0a 00 00       	mov    $0xa72,%edx
        while(*s != 0){
 81d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 820:	b8 28 00 00 00       	mov    $0x28,%eax
 825:	89 d3                	mov    %edx,%ebx
 827:	e9 74 ff ff ff       	jmp    7a0 <printf+0x110>
 82c:	66 90                	xchg   %ax,%ax
 82e:	66 90                	xchg   %ax,%ax

00000830 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 830:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 831:	a1 6c 0e 00 00       	mov    0xe6c,%eax
{
 836:	89 e5                	mov    %esp,%ebp
 838:	57                   	push   %edi
 839:	56                   	push   %esi
 83a:	53                   	push   %ebx
 83b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 83e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 848:	89 c2                	mov    %eax,%edx
 84a:	8b 00                	mov    (%eax),%eax
 84c:	39 ca                	cmp    %ecx,%edx
 84e:	73 30                	jae    880 <free+0x50>
 850:	39 c1                	cmp    %eax,%ecx
 852:	72 04                	jb     858 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 854:	39 c2                	cmp    %eax,%edx
 856:	72 f0                	jb     848 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 858:	8b 73 fc             	mov    -0x4(%ebx),%esi
 85b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 85e:	39 f8                	cmp    %edi,%eax
 860:	74 30                	je     892 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 862:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 865:	8b 42 04             	mov    0x4(%edx),%eax
 868:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 86b:	39 f1                	cmp    %esi,%ecx
 86d:	74 3a                	je     8a9 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 86f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 871:	5b                   	pop    %ebx
  freep = p;
 872:	89 15 6c 0e 00 00    	mov    %edx,0xe6c
}
 878:	5e                   	pop    %esi
 879:	5f                   	pop    %edi
 87a:	5d                   	pop    %ebp
 87b:	c3                   	ret    
 87c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 880:	39 c2                	cmp    %eax,%edx
 882:	72 c4                	jb     848 <free+0x18>
 884:	39 c1                	cmp    %eax,%ecx
 886:	73 c0                	jae    848 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 888:	8b 73 fc             	mov    -0x4(%ebx),%esi
 88b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 88e:	39 f8                	cmp    %edi,%eax
 890:	75 d0                	jne    862 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 892:	03 70 04             	add    0x4(%eax),%esi
 895:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 898:	8b 02                	mov    (%edx),%eax
 89a:	8b 00                	mov    (%eax),%eax
 89c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 89f:	8b 42 04             	mov    0x4(%edx),%eax
 8a2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 8a5:	39 f1                	cmp    %esi,%ecx
 8a7:	75 c6                	jne    86f <free+0x3f>
    p->s.size += bp->s.size;
 8a9:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 8ac:	89 15 6c 0e 00 00    	mov    %edx,0xe6c
    p->s.size += bp->s.size;
 8b2:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 8b5:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 8b8:	89 0a                	mov    %ecx,(%edx)
}
 8ba:	5b                   	pop    %ebx
 8bb:	5e                   	pop    %esi
 8bc:	5f                   	pop    %edi
 8bd:	5d                   	pop    %ebp
 8be:	c3                   	ret    
 8bf:	90                   	nop

000008c0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8c0:	55                   	push   %ebp
 8c1:	89 e5                	mov    %esp,%ebp
 8c3:	57                   	push   %edi
 8c4:	56                   	push   %esi
 8c5:	53                   	push   %ebx
 8c6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8c9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 8cc:	8b 3d 6c 0e 00 00    	mov    0xe6c,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8d2:	8d 70 07             	lea    0x7(%eax),%esi
 8d5:	c1 ee 03             	shr    $0x3,%esi
 8d8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 8db:	85 ff                	test   %edi,%edi
 8dd:	0f 84 9d 00 00 00    	je     980 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 8e5:	8b 4a 04             	mov    0x4(%edx),%ecx
 8e8:	39 f1                	cmp    %esi,%ecx
 8ea:	73 6a                	jae    956 <malloc+0x96>
 8ec:	bb 00 10 00 00       	mov    $0x1000,%ebx
 8f1:	39 de                	cmp    %ebx,%esi
 8f3:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 8f6:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 8fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 900:	eb 17                	jmp    919 <malloc+0x59>
 902:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 908:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 90a:	8b 48 04             	mov    0x4(%eax),%ecx
 90d:	39 f1                	cmp    %esi,%ecx
 90f:	73 4f                	jae    960 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 911:	8b 3d 6c 0e 00 00    	mov    0xe6c,%edi
 917:	89 c2                	mov    %eax,%edx
 919:	39 d7                	cmp    %edx,%edi
 91b:	75 eb                	jne    908 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 91d:	83 ec 0c             	sub    $0xc,%esp
 920:	ff 75 e4             	push   -0x1c(%ebp)
 923:	e8 3d fc ff ff       	call   565 <sbrk>
  if(p == (char*)-1)
 928:	83 c4 10             	add    $0x10,%esp
 92b:	83 f8 ff             	cmp    $0xffffffff,%eax
 92e:	74 1c                	je     94c <malloc+0x8c>
  hp->s.size = nu;
 930:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 933:	83 ec 0c             	sub    $0xc,%esp
 936:	83 c0 08             	add    $0x8,%eax
 939:	50                   	push   %eax
 93a:	e8 f1 fe ff ff       	call   830 <free>
  return freep;
 93f:	8b 15 6c 0e 00 00    	mov    0xe6c,%edx
      if((p = morecore(nunits)) == 0)
 945:	83 c4 10             	add    $0x10,%esp
 948:	85 d2                	test   %edx,%edx
 94a:	75 bc                	jne    908 <malloc+0x48>
        return 0;
  }
}
 94c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 94f:	31 c0                	xor    %eax,%eax
}
 951:	5b                   	pop    %ebx
 952:	5e                   	pop    %esi
 953:	5f                   	pop    %edi
 954:	5d                   	pop    %ebp
 955:	c3                   	ret    
    if(p->s.size >= nunits){
 956:	89 d0                	mov    %edx,%eax
 958:	89 fa                	mov    %edi,%edx
 95a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 960:	39 ce                	cmp    %ecx,%esi
 962:	74 4c                	je     9b0 <malloc+0xf0>
        p->s.size -= nunits;
 964:	29 f1                	sub    %esi,%ecx
 966:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 969:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 96c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 96f:	89 15 6c 0e 00 00    	mov    %edx,0xe6c
}
 975:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 978:	83 c0 08             	add    $0x8,%eax
}
 97b:	5b                   	pop    %ebx
 97c:	5e                   	pop    %esi
 97d:	5f                   	pop    %edi
 97e:	5d                   	pop    %ebp
 97f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 980:	c7 05 6c 0e 00 00 70 	movl   $0xe70,0xe6c
 987:	0e 00 00 
    base.s.size = 0;
 98a:	bf 70 0e 00 00       	mov    $0xe70,%edi
    base.s.ptr = freep = prevp = &base;
 98f:	c7 05 70 0e 00 00 70 	movl   $0xe70,0xe70
 996:	0e 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 999:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 99b:	c7 05 74 0e 00 00 00 	movl   $0x0,0xe74
 9a2:	00 00 00 
    if(p->s.size >= nunits){
 9a5:	e9 42 ff ff ff       	jmp    8ec <malloc+0x2c>
 9aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 9b0:	8b 08                	mov    (%eax),%ecx
 9b2:	89 0a                	mov    %ecx,(%edx)
 9b4:	eb b9                	jmp    96f <malloc+0xaf>
