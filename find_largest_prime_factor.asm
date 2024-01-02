
_find_largest_prime_factor:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    );

    return result;
}

int main(int argc, char* argv[]) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
    if (argc != 2) {
   f:	83 39 02             	cmpl   $0x2,(%ecx)
int main(int argc, char* argv[]) {
  12:	8b 41 04             	mov    0x4(%ecx),%eax
    if (argc != 2) {
  15:	74 13                	je     2a <main+0x2a>
        printf(2, "usage: find_largest_prime_factor <number>\n");
  17:	53                   	push   %ebx
  18:	53                   	push   %ebx
  19:	68 f8 07 00 00       	push   $0x7f8
  1e:	6a 02                	push   $0x2
  20:	e8 ab 04 00 00       	call   4d0 <printf>
        exit();
  25:	e8 f3 02 00 00       	call   31d <exit>
    }

    int num = atoi(argv[1]);
  2a:	83 ec 0c             	sub    $0xc,%esp
  2d:	ff 70 04             	push   0x4(%eax)
  30:	e8 4b 02 00 00       	call   280 <atoi>
    asm volatile(
  35:	89 db                	mov    %ebx,%ebx
  37:	89 c3                	mov    %eax,%ebx
    int result = find_largest_prime_factor();
  39:	e8 7f 03 00 00       	call   3bd <find_largest_prime_factor>
    asm volatile(
  3e:	89 db                	mov    %ebx,%ebx

    int result = flpf_syscall(num);
    if (result == -1) {
  40:	83 c4 10             	add    $0x10,%esp
  43:	83 f8 ff             	cmp    $0xffffffff,%eax
  46:	74 16                	je     5e <main+0x5e>
        printf(2, "Number should be greater than 1.\n");
    }
    else {
        printf(1, "%d\n", result);
  48:	52                   	push   %edx
  49:	50                   	push   %eax
  4a:	68 46 08 00 00       	push   $0x846
  4f:	6a 01                	push   $0x1
  51:	e8 7a 04 00 00       	call   4d0 <printf>
  56:	83 c4 10             	add    $0x10,%esp
    }

    exit();
  59:	e8 bf 02 00 00       	call   31d <exit>
        printf(2, "Number should be greater than 1.\n");
  5e:	51                   	push   %ecx
  5f:	51                   	push   %ecx
  60:	68 24 08 00 00       	push   $0x824
  65:	6a 02                	push   $0x2
  67:	e8 64 04 00 00       	call   4d0 <printf>
  6c:	83 c4 10             	add    $0x10,%esp
  6f:	eb e8                	jmp    59 <main+0x59>
  71:	66 90                	xchg   %ax,%ax
  73:	66 90                	xchg   %ax,%ax
  75:	66 90                	xchg   %ax,%ax
  77:	66 90                	xchg   %ax,%ax
  79:	66 90                	xchg   %ax,%ax
  7b:	66 90                	xchg   %ax,%ax
  7d:	66 90                	xchg   %ax,%ax
  7f:	90                   	nop

00000080 <flpf_syscall>:
int flpf_syscall(int num) {
  80:	55                   	push   %ebp
  81:	89 e5                	mov    %esp,%ebp
  83:	53                   	push   %ebx
  84:	83 ec 04             	sub    $0x4,%esp
    asm volatile(
  87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8a:	89 db                	mov    %ebx,%ebx
  8c:	89 db                	mov    %ebx,%ebx
    int result = find_largest_prime_factor();
  8e:	e8 2a 03 00 00       	call   3bd <find_largest_prime_factor>
    asm volatile(
  93:	89 db                	mov    %ebx,%ebx
}
  95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  98:	c9                   	leave  
  99:	c3                   	ret    
  9a:	66 90                	xchg   %ax,%ax
  9c:	66 90                	xchg   %ax,%ax
  9e:	66 90                	xchg   %ax,%ax

000000a0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  a0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  a1:	31 c0                	xor    %eax,%eax
{
  a3:	89 e5                	mov    %esp,%ebp
  a5:	53                   	push   %ebx
  a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  b0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  b4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  b7:	83 c0 01             	add    $0x1,%eax
  ba:	84 d2                	test   %dl,%dl
  bc:	75 f2                	jne    b0 <strcpy+0x10>
    ;
  return os;
}
  be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  c1:	89 c8                	mov    %ecx,%eax
  c3:	c9                   	leave  
  c4:	c3                   	ret    
  c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000000d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d0:	55                   	push   %ebp
  d1:	89 e5                	mov    %esp,%ebp
  d3:	53                   	push   %ebx
  d4:	8b 55 08             	mov    0x8(%ebp),%edx
  d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  da:	0f b6 02             	movzbl (%edx),%eax
  dd:	84 c0                	test   %al,%al
  df:	75 17                	jne    f8 <strcmp+0x28>
  e1:	eb 3a                	jmp    11d <strcmp+0x4d>
  e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  e7:	90                   	nop
  e8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
  ec:	83 c2 01             	add    $0x1,%edx
  ef:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
  f2:	84 c0                	test   %al,%al
  f4:	74 1a                	je     110 <strcmp+0x40>
    p++, q++;
  f6:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
  f8:	0f b6 19             	movzbl (%ecx),%ebx
  fb:	38 c3                	cmp    %al,%bl
  fd:	74 e9                	je     e8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  ff:	29 d8                	sub    %ebx,%eax
}
 101:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 104:	c9                   	leave  
 105:	c3                   	ret    
 106:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 10d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 110:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 114:	31 c0                	xor    %eax,%eax
 116:	29 d8                	sub    %ebx,%eax
}
 118:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 11b:	c9                   	leave  
 11c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 11d:	0f b6 19             	movzbl (%ecx),%ebx
 120:	31 c0                	xor    %eax,%eax
 122:	eb db                	jmp    ff <strcmp+0x2f>
 124:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 12b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 12f:	90                   	nop

00000130 <strlen>:

uint
strlen(const char *s)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 136:	80 3a 00             	cmpb   $0x0,(%edx)
 139:	74 15                	je     150 <strlen+0x20>
 13b:	31 c0                	xor    %eax,%eax
 13d:	8d 76 00             	lea    0x0(%esi),%esi
 140:	83 c0 01             	add    $0x1,%eax
 143:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 147:	89 c1                	mov    %eax,%ecx
 149:	75 f5                	jne    140 <strlen+0x10>
    ;
  return n;
}
 14b:	89 c8                	mov    %ecx,%eax
 14d:	5d                   	pop    %ebp
 14e:	c3                   	ret    
 14f:	90                   	nop
  for(n = 0; s[n]; n++)
 150:	31 c9                	xor    %ecx,%ecx
}
 152:	5d                   	pop    %ebp
 153:	89 c8                	mov    %ecx,%eax
 155:	c3                   	ret    
 156:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 15d:	8d 76 00             	lea    0x0(%esi),%esi

00000160 <memset>:

void*
memset(void *dst, int c, uint n)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	57                   	push   %edi
 164:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 167:	8b 4d 10             	mov    0x10(%ebp),%ecx
 16a:	8b 45 0c             	mov    0xc(%ebp),%eax
 16d:	89 d7                	mov    %edx,%edi
 16f:	fc                   	cld    
 170:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 172:	8b 7d fc             	mov    -0x4(%ebp),%edi
 175:	89 d0                	mov    %edx,%eax
 177:	c9                   	leave  
 178:	c3                   	ret    
 179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000180 <strchr>:

char*
strchr(const char *s, char c)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	8b 45 08             	mov    0x8(%ebp),%eax
 186:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 18a:	0f b6 10             	movzbl (%eax),%edx
 18d:	84 d2                	test   %dl,%dl
 18f:	75 12                	jne    1a3 <strchr+0x23>
 191:	eb 1d                	jmp    1b0 <strchr+0x30>
 193:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 197:	90                   	nop
 198:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 19c:	83 c0 01             	add    $0x1,%eax
 19f:	84 d2                	test   %dl,%dl
 1a1:	74 0d                	je     1b0 <strchr+0x30>
    if(*s == c)
 1a3:	38 d1                	cmp    %dl,%cl
 1a5:	75 f1                	jne    198 <strchr+0x18>
      return (char*)s;
  return 0;
}
 1a7:	5d                   	pop    %ebp
 1a8:	c3                   	ret    
 1a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 1b0:	31 c0                	xor    %eax,%eax
}
 1b2:	5d                   	pop    %ebp
 1b3:	c3                   	ret    
 1b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1bf:	90                   	nop

000001c0 <gets>:

char*
gets(char *buf, int max)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	57                   	push   %edi
 1c4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 1c5:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 1c8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 1c9:	31 db                	xor    %ebx,%ebx
{
 1cb:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 1ce:	eb 27                	jmp    1f7 <gets+0x37>
    cc = read(0, &c, 1);
 1d0:	83 ec 04             	sub    $0x4,%esp
 1d3:	6a 01                	push   $0x1
 1d5:	57                   	push   %edi
 1d6:	6a 00                	push   $0x0
 1d8:	e8 58 01 00 00       	call   335 <read>
    if(cc < 1)
 1dd:	83 c4 10             	add    $0x10,%esp
 1e0:	85 c0                	test   %eax,%eax
 1e2:	7e 1d                	jle    201 <gets+0x41>
      break;
    buf[i++] = c;
 1e4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1e8:	8b 55 08             	mov    0x8(%ebp),%edx
 1eb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1ef:	3c 0a                	cmp    $0xa,%al
 1f1:	74 1d                	je     210 <gets+0x50>
 1f3:	3c 0d                	cmp    $0xd,%al
 1f5:	74 19                	je     210 <gets+0x50>
  for(i=0; i+1 < max; ){
 1f7:	89 de                	mov    %ebx,%esi
 1f9:	83 c3 01             	add    $0x1,%ebx
 1fc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1ff:	7c cf                	jl     1d0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 201:	8b 45 08             	mov    0x8(%ebp),%eax
 204:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 208:	8d 65 f4             	lea    -0xc(%ebp),%esp
 20b:	5b                   	pop    %ebx
 20c:	5e                   	pop    %esi
 20d:	5f                   	pop    %edi
 20e:	5d                   	pop    %ebp
 20f:	c3                   	ret    
  buf[i] = '\0';
 210:	8b 45 08             	mov    0x8(%ebp),%eax
 213:	89 de                	mov    %ebx,%esi
 215:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 219:	8d 65 f4             	lea    -0xc(%ebp),%esp
 21c:	5b                   	pop    %ebx
 21d:	5e                   	pop    %esi
 21e:	5f                   	pop    %edi
 21f:	5d                   	pop    %ebp
 220:	c3                   	ret    
 221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 22f:	90                   	nop

00000230 <stat>:

int
stat(const char *n, struct stat *st)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	56                   	push   %esi
 234:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 235:	83 ec 08             	sub    $0x8,%esp
 238:	6a 00                	push   $0x0
 23a:	ff 75 08             	push   0x8(%ebp)
 23d:	e8 1b 01 00 00       	call   35d <open>
  if(fd < 0)
 242:	83 c4 10             	add    $0x10,%esp
 245:	85 c0                	test   %eax,%eax
 247:	78 27                	js     270 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 249:	83 ec 08             	sub    $0x8,%esp
 24c:	ff 75 0c             	push   0xc(%ebp)
 24f:	89 c3                	mov    %eax,%ebx
 251:	50                   	push   %eax
 252:	e8 1e 01 00 00       	call   375 <fstat>
  close(fd);
 257:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 25a:	89 c6                	mov    %eax,%esi
  close(fd);
 25c:	e8 e4 00 00 00       	call   345 <close>
  return r;
 261:	83 c4 10             	add    $0x10,%esp
}
 264:	8d 65 f8             	lea    -0x8(%ebp),%esp
 267:	89 f0                	mov    %esi,%eax
 269:	5b                   	pop    %ebx
 26a:	5e                   	pop    %esi
 26b:	5d                   	pop    %ebp
 26c:	c3                   	ret    
 26d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 270:	be ff ff ff ff       	mov    $0xffffffff,%esi
 275:	eb ed                	jmp    264 <stat+0x34>
 277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 27e:	66 90                	xchg   %ax,%ax

00000280 <atoi>:

int
atoi(const char *s)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	53                   	push   %ebx
 284:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 287:	0f be 02             	movsbl (%edx),%eax
 28a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 28d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 290:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 295:	77 1e                	ja     2b5 <atoi+0x35>
 297:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 29e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 2a0:	83 c2 01             	add    $0x1,%edx
 2a3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 2a6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 2aa:	0f be 02             	movsbl (%edx),%eax
 2ad:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2b0:	80 fb 09             	cmp    $0x9,%bl
 2b3:	76 eb                	jbe    2a0 <atoi+0x20>
  return n;
}
 2b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2b8:	89 c8                	mov    %ecx,%eax
 2ba:	c9                   	leave  
 2bb:	c3                   	ret    
 2bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002c0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	57                   	push   %edi
 2c4:	8b 45 10             	mov    0x10(%ebp),%eax
 2c7:	8b 55 08             	mov    0x8(%ebp),%edx
 2ca:	56                   	push   %esi
 2cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ce:	85 c0                	test   %eax,%eax
 2d0:	7e 13                	jle    2e5 <memmove+0x25>
 2d2:	01 d0                	add    %edx,%eax
  dst = vdst;
 2d4:	89 d7                	mov    %edx,%edi
 2d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2dd:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 2e0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2e1:	39 f8                	cmp    %edi,%eax
 2e3:	75 fb                	jne    2e0 <memmove+0x20>
  return vdst;
}
 2e5:	5e                   	pop    %esi
 2e6:	89 d0                	mov    %edx,%eax
 2e8:	5f                   	pop    %edi
 2e9:	5d                   	pop    %ebp
 2ea:	c3                   	ret    
 2eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2ef:	90                   	nop

000002f0 <srand>:

static uint seed = 1;

void
srand(uint s)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
  seed = s;
 2f3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2f6:	5d                   	pop    %ebp
  seed = s;
 2f7:	a3 b0 0b 00 00       	mov    %eax,0xbb0
}
 2fc:	c3                   	ret    
 2fd:	8d 76 00             	lea    0x0(%esi),%esi

00000300 <random>:

uint
random(void)
{
  seed = seed
    * 1103515245
 300:	69 05 b0 0b 00 00 6d 	imul   $0x41c64e6d,0xbb0,%eax
 307:	4e c6 41 
    + 12345
 30a:	05 39 30 00 00       	add    $0x3039,%eax
  seed = seed
 30f:	a3 b0 0b 00 00       	mov    %eax,0xbb0
    % (1 << 31);
  return seed;
}
 314:	c3                   	ret    

00000315 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 315:	b8 01 00 00 00       	mov    $0x1,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <exit>:
SYSCALL(exit)
 31d:	b8 02 00 00 00       	mov    $0x2,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <wait>:
SYSCALL(wait)
 325:	b8 03 00 00 00       	mov    $0x3,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <pipe>:
SYSCALL(pipe)
 32d:	b8 04 00 00 00       	mov    $0x4,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <read>:
SYSCALL(read)
 335:	b8 05 00 00 00       	mov    $0x5,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <write>:
SYSCALL(write)
 33d:	b8 10 00 00 00       	mov    $0x10,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <close>:
SYSCALL(close)
 345:	b8 15 00 00 00       	mov    $0x15,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <kill>:
SYSCALL(kill)
 34d:	b8 06 00 00 00       	mov    $0x6,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <exec>:
SYSCALL(exec)
 355:	b8 07 00 00 00       	mov    $0x7,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <open>:
SYSCALL(open)
 35d:	b8 0f 00 00 00       	mov    $0xf,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <mknod>:
SYSCALL(mknod)
 365:	b8 11 00 00 00       	mov    $0x11,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <unlink>:
SYSCALL(unlink)
 36d:	b8 12 00 00 00       	mov    $0x12,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <fstat>:
SYSCALL(fstat)
 375:	b8 08 00 00 00       	mov    $0x8,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <link>:
SYSCALL(link)
 37d:	b8 13 00 00 00       	mov    $0x13,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <mkdir>:
SYSCALL(mkdir)
 385:	b8 14 00 00 00       	mov    $0x14,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <chdir>:
SYSCALL(chdir)
 38d:	b8 09 00 00 00       	mov    $0x9,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <dup>:
SYSCALL(dup)
 395:	b8 0a 00 00 00       	mov    $0xa,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <getpid>:
SYSCALL(getpid)
 39d:	b8 0b 00 00 00       	mov    $0xb,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <sbrk>:
SYSCALL(sbrk)
 3a5:	b8 0c 00 00 00       	mov    $0xc,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <sleep>:
SYSCALL(sleep)
 3ad:	b8 0d 00 00 00       	mov    $0xd,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <uptime>:
SYSCALL(uptime)
 3b5:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ba:	cd 40                	int    $0x40
 3bc:	c3                   	ret    

000003bd <find_largest_prime_factor>:
SYSCALL(find_largest_prime_factor)
 3bd:	b8 16 00 00 00       	mov    $0x16,%eax
 3c2:	cd 40                	int    $0x40
 3c4:	c3                   	ret    

000003c5 <change_file_size>:
SYSCALL(change_file_size)
 3c5:	b8 17 00 00 00       	mov    $0x17,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	ret    

000003cd <get_callers>:
SYSCALL(get_callers)
 3cd:	b8 18 00 00 00       	mov    $0x18,%eax
 3d2:	cd 40                	int    $0x40
 3d4:	c3                   	ret    

000003d5 <get_parent_pid>:
SYSCALL(get_parent_pid)
 3d5:	b8 19 00 00 00       	mov    $0x19,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	ret    

000003dd <change_scheduling_queue>:
SYSCALL(change_scheduling_queue)
 3dd:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3e2:	cd 40                	int    $0x40
 3e4:	c3                   	ret    

000003e5 <set_bjf_params_process>:
SYSCALL(set_bjf_params_process)
 3e5:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3ea:	cd 40                	int    $0x40
 3ec:	c3                   	ret    

000003ed <set_bjf_params_system>:
SYSCALL(set_bjf_params_system)
 3ed:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3f2:	cd 40                	int    $0x40
 3f4:	c3                   	ret    

000003f5 <set_bjf_priority>:
SYSCALL(set_bjf_priority)
 3f5:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3fa:	cd 40                	int    $0x40
 3fc:	c3                   	ret    

000003fd <print_process_info>:
SYSCALL(print_process_info)
 3fd:	b8 1f 00 00 00       	mov    $0x1f,%eax
 402:	cd 40                	int    $0x40
 404:	c3                   	ret    

00000405 <sem_init>:
SYSCALL(sem_init)
 405:	b8 20 00 00 00       	mov    $0x20,%eax
 40a:	cd 40                	int    $0x40
 40c:	c3                   	ret    

0000040d <sem_acquire>:
SYSCALL(sem_acquire)
 40d:	b8 21 00 00 00       	mov    $0x21,%eax
 412:	cd 40                	int    $0x40
 414:	c3                   	ret    

00000415 <sem_release>:
SYSCALL(sem_release)
 415:	b8 22 00 00 00       	mov    $0x22,%eax
 41a:	cd 40                	int    $0x40
 41c:	c3                   	ret    
 41d:	66 90                	xchg   %ax,%ax
 41f:	90                   	nop

00000420 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	57                   	push   %edi
 424:	56                   	push   %esi
 425:	53                   	push   %ebx
 426:	83 ec 3c             	sub    $0x3c,%esp
 429:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 42c:	89 d1                	mov    %edx,%ecx
{
 42e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 431:	85 d2                	test   %edx,%edx
 433:	0f 89 7f 00 00 00    	jns    4b8 <printint+0x98>
 439:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 43d:	74 79                	je     4b8 <printint+0x98>
    neg = 1;
 43f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 446:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 448:	31 db                	xor    %ebx,%ebx
 44a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 44d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 450:	89 c8                	mov    %ecx,%eax
 452:	31 d2                	xor    %edx,%edx
 454:	89 cf                	mov    %ecx,%edi
 456:	f7 75 c4             	divl   -0x3c(%ebp)
 459:	0f b6 92 ac 08 00 00 	movzbl 0x8ac(%edx),%edx
 460:	89 45 c0             	mov    %eax,-0x40(%ebp)
 463:	89 d8                	mov    %ebx,%eax
 465:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 468:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 46b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 46e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 471:	76 dd                	jbe    450 <printint+0x30>
  if(neg)
 473:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 476:	85 c9                	test   %ecx,%ecx
 478:	74 0c                	je     486 <printint+0x66>
    buf[i++] = '-';
 47a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 47f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 481:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 486:	8b 7d b8             	mov    -0x48(%ebp),%edi
 489:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 48d:	eb 07                	jmp    496 <printint+0x76>
 48f:	90                   	nop
    putc(fd, buf[i]);
 490:	0f b6 13             	movzbl (%ebx),%edx
 493:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 496:	83 ec 04             	sub    $0x4,%esp
 499:	88 55 d7             	mov    %dl,-0x29(%ebp)
 49c:	6a 01                	push   $0x1
 49e:	56                   	push   %esi
 49f:	57                   	push   %edi
 4a0:	e8 98 fe ff ff       	call   33d <write>
  while(--i >= 0)
 4a5:	83 c4 10             	add    $0x10,%esp
 4a8:	39 de                	cmp    %ebx,%esi
 4aa:	75 e4                	jne    490 <printint+0x70>
}
 4ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4af:	5b                   	pop    %ebx
 4b0:	5e                   	pop    %esi
 4b1:	5f                   	pop    %edi
 4b2:	5d                   	pop    %ebp
 4b3:	c3                   	ret    
 4b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 4b8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 4bf:	eb 87                	jmp    448 <printint+0x28>
 4c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4cf:	90                   	nop

000004d0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4d0:	55                   	push   %ebp
 4d1:	89 e5                	mov    %esp,%ebp
 4d3:	57                   	push   %edi
 4d4:	56                   	push   %esi
 4d5:	53                   	push   %ebx
 4d6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 4dc:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 4df:	0f b6 13             	movzbl (%ebx),%edx
 4e2:	84 d2                	test   %dl,%dl
 4e4:	74 6a                	je     550 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 4e6:	8d 45 10             	lea    0x10(%ebp),%eax
 4e9:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 4ec:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 4ef:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 4f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 4f4:	eb 36                	jmp    52c <printf+0x5c>
 4f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4fd:	8d 76 00             	lea    0x0(%esi),%esi
 500:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 503:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 508:	83 f8 25             	cmp    $0x25,%eax
 50b:	74 15                	je     522 <printf+0x52>
  write(fd, &c, 1);
 50d:	83 ec 04             	sub    $0x4,%esp
 510:	88 55 e7             	mov    %dl,-0x19(%ebp)
 513:	6a 01                	push   $0x1
 515:	57                   	push   %edi
 516:	56                   	push   %esi
 517:	e8 21 fe ff ff       	call   33d <write>
 51c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 51f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 522:	0f b6 13             	movzbl (%ebx),%edx
 525:	83 c3 01             	add    $0x1,%ebx
 528:	84 d2                	test   %dl,%dl
 52a:	74 24                	je     550 <printf+0x80>
    c = fmt[i] & 0xff;
 52c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 52f:	85 c9                	test   %ecx,%ecx
 531:	74 cd                	je     500 <printf+0x30>
      }
    } else if(state == '%'){
 533:	83 f9 25             	cmp    $0x25,%ecx
 536:	75 ea                	jne    522 <printf+0x52>
      if(c == 'd'){
 538:	83 f8 25             	cmp    $0x25,%eax
 53b:	0f 84 07 01 00 00    	je     648 <printf+0x178>
 541:	83 e8 63             	sub    $0x63,%eax
 544:	83 f8 15             	cmp    $0x15,%eax
 547:	77 17                	ja     560 <printf+0x90>
 549:	ff 24 85 54 08 00 00 	jmp    *0x854(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 550:	8d 65 f4             	lea    -0xc(%ebp),%esp
 553:	5b                   	pop    %ebx
 554:	5e                   	pop    %esi
 555:	5f                   	pop    %edi
 556:	5d                   	pop    %ebp
 557:	c3                   	ret    
 558:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 55f:	90                   	nop
  write(fd, &c, 1);
 560:	83 ec 04             	sub    $0x4,%esp
 563:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 566:	6a 01                	push   $0x1
 568:	57                   	push   %edi
 569:	56                   	push   %esi
 56a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 56e:	e8 ca fd ff ff       	call   33d <write>
        putc(fd, c);
 573:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 577:	83 c4 0c             	add    $0xc,%esp
 57a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 57d:	6a 01                	push   $0x1
 57f:	57                   	push   %edi
 580:	56                   	push   %esi
 581:	e8 b7 fd ff ff       	call   33d <write>
        putc(fd, c);
 586:	83 c4 10             	add    $0x10,%esp
      state = 0;
 589:	31 c9                	xor    %ecx,%ecx
 58b:	eb 95                	jmp    522 <printf+0x52>
 58d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 590:	83 ec 0c             	sub    $0xc,%esp
 593:	b9 10 00 00 00       	mov    $0x10,%ecx
 598:	6a 00                	push   $0x0
 59a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 59d:	8b 10                	mov    (%eax),%edx
 59f:	89 f0                	mov    %esi,%eax
 5a1:	e8 7a fe ff ff       	call   420 <printint>
        ap++;
 5a6:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 5aa:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5ad:	31 c9                	xor    %ecx,%ecx
 5af:	e9 6e ff ff ff       	jmp    522 <printf+0x52>
 5b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 5b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
 5bb:	8b 10                	mov    (%eax),%edx
        ap++;
 5bd:	83 c0 04             	add    $0x4,%eax
 5c0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 5c3:	85 d2                	test   %edx,%edx
 5c5:	0f 84 8d 00 00 00    	je     658 <printf+0x188>
        while(*s != 0){
 5cb:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 5ce:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 5d0:	84 c0                	test   %al,%al
 5d2:	0f 84 4a ff ff ff    	je     522 <printf+0x52>
 5d8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 5db:	89 d3                	mov    %edx,%ebx
 5dd:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 5e0:	83 ec 04             	sub    $0x4,%esp
          s++;
 5e3:	83 c3 01             	add    $0x1,%ebx
 5e6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5e9:	6a 01                	push   $0x1
 5eb:	57                   	push   %edi
 5ec:	56                   	push   %esi
 5ed:	e8 4b fd ff ff       	call   33d <write>
        while(*s != 0){
 5f2:	0f b6 03             	movzbl (%ebx),%eax
 5f5:	83 c4 10             	add    $0x10,%esp
 5f8:	84 c0                	test   %al,%al
 5fa:	75 e4                	jne    5e0 <printf+0x110>
      state = 0;
 5fc:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 5ff:	31 c9                	xor    %ecx,%ecx
 601:	e9 1c ff ff ff       	jmp    522 <printf+0x52>
 606:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 60d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 610:	83 ec 0c             	sub    $0xc,%esp
 613:	b9 0a 00 00 00       	mov    $0xa,%ecx
 618:	6a 01                	push   $0x1
 61a:	e9 7b ff ff ff       	jmp    59a <printf+0xca>
 61f:	90                   	nop
        putc(fd, *ap);
 620:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 623:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 626:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 628:	6a 01                	push   $0x1
 62a:	57                   	push   %edi
 62b:	56                   	push   %esi
        putc(fd, *ap);
 62c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 62f:	e8 09 fd ff ff       	call   33d <write>
        ap++;
 634:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 638:	83 c4 10             	add    $0x10,%esp
      state = 0;
 63b:	31 c9                	xor    %ecx,%ecx
 63d:	e9 e0 fe ff ff       	jmp    522 <printf+0x52>
 642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 648:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 64b:	83 ec 04             	sub    $0x4,%esp
 64e:	e9 2a ff ff ff       	jmp    57d <printf+0xad>
 653:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 657:	90                   	nop
          s = "(null)";
 658:	ba 4a 08 00 00       	mov    $0x84a,%edx
        while(*s != 0){
 65d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 660:	b8 28 00 00 00       	mov    $0x28,%eax
 665:	89 d3                	mov    %edx,%ebx
 667:	e9 74 ff ff ff       	jmp    5e0 <printf+0x110>
 66c:	66 90                	xchg   %ax,%ax
 66e:	66 90                	xchg   %ax,%ax

00000670 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 670:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 671:	a1 b4 0b 00 00       	mov    0xbb4,%eax
{
 676:	89 e5                	mov    %esp,%ebp
 678:	57                   	push   %edi
 679:	56                   	push   %esi
 67a:	53                   	push   %ebx
 67b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 67e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 688:	89 c2                	mov    %eax,%edx
 68a:	8b 00                	mov    (%eax),%eax
 68c:	39 ca                	cmp    %ecx,%edx
 68e:	73 30                	jae    6c0 <free+0x50>
 690:	39 c1                	cmp    %eax,%ecx
 692:	72 04                	jb     698 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 694:	39 c2                	cmp    %eax,%edx
 696:	72 f0                	jb     688 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 698:	8b 73 fc             	mov    -0x4(%ebx),%esi
 69b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 69e:	39 f8                	cmp    %edi,%eax
 6a0:	74 30                	je     6d2 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 6a2:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6a5:	8b 42 04             	mov    0x4(%edx),%eax
 6a8:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 6ab:	39 f1                	cmp    %esi,%ecx
 6ad:	74 3a                	je     6e9 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 6af:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 6b1:	5b                   	pop    %ebx
  freep = p;
 6b2:	89 15 b4 0b 00 00    	mov    %edx,0xbb4
}
 6b8:	5e                   	pop    %esi
 6b9:	5f                   	pop    %edi
 6ba:	5d                   	pop    %ebp
 6bb:	c3                   	ret    
 6bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c0:	39 c2                	cmp    %eax,%edx
 6c2:	72 c4                	jb     688 <free+0x18>
 6c4:	39 c1                	cmp    %eax,%ecx
 6c6:	73 c0                	jae    688 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 6c8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6cb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6ce:	39 f8                	cmp    %edi,%eax
 6d0:	75 d0                	jne    6a2 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 6d2:	03 70 04             	add    0x4(%eax),%esi
 6d5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6d8:	8b 02                	mov    (%edx),%eax
 6da:	8b 00                	mov    (%eax),%eax
 6dc:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 6df:	8b 42 04             	mov    0x4(%edx),%eax
 6e2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 6e5:	39 f1                	cmp    %esi,%ecx
 6e7:	75 c6                	jne    6af <free+0x3f>
    p->s.size += bp->s.size;
 6e9:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 6ec:	89 15 b4 0b 00 00    	mov    %edx,0xbb4
    p->s.size += bp->s.size;
 6f2:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 6f5:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 6f8:	89 0a                	mov    %ecx,(%edx)
}
 6fa:	5b                   	pop    %ebx
 6fb:	5e                   	pop    %esi
 6fc:	5f                   	pop    %edi
 6fd:	5d                   	pop    %ebp
 6fe:	c3                   	ret    
 6ff:	90                   	nop

00000700 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 700:	55                   	push   %ebp
 701:	89 e5                	mov    %esp,%ebp
 703:	57                   	push   %edi
 704:	56                   	push   %esi
 705:	53                   	push   %ebx
 706:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 709:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 70c:	8b 3d b4 0b 00 00    	mov    0xbb4,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 712:	8d 70 07             	lea    0x7(%eax),%esi
 715:	c1 ee 03             	shr    $0x3,%esi
 718:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 71b:	85 ff                	test   %edi,%edi
 71d:	0f 84 9d 00 00 00    	je     7c0 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 723:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 725:	8b 4a 04             	mov    0x4(%edx),%ecx
 728:	39 f1                	cmp    %esi,%ecx
 72a:	73 6a                	jae    796 <malloc+0x96>
 72c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 731:	39 de                	cmp    %ebx,%esi
 733:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 736:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 73d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 740:	eb 17                	jmp    759 <malloc+0x59>
 742:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 748:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 74a:	8b 48 04             	mov    0x4(%eax),%ecx
 74d:	39 f1                	cmp    %esi,%ecx
 74f:	73 4f                	jae    7a0 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 751:	8b 3d b4 0b 00 00    	mov    0xbb4,%edi
 757:	89 c2                	mov    %eax,%edx
 759:	39 d7                	cmp    %edx,%edi
 75b:	75 eb                	jne    748 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 75d:	83 ec 0c             	sub    $0xc,%esp
 760:	ff 75 e4             	push   -0x1c(%ebp)
 763:	e8 3d fc ff ff       	call   3a5 <sbrk>
  if(p == (char*)-1)
 768:	83 c4 10             	add    $0x10,%esp
 76b:	83 f8 ff             	cmp    $0xffffffff,%eax
 76e:	74 1c                	je     78c <malloc+0x8c>
  hp->s.size = nu;
 770:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 773:	83 ec 0c             	sub    $0xc,%esp
 776:	83 c0 08             	add    $0x8,%eax
 779:	50                   	push   %eax
 77a:	e8 f1 fe ff ff       	call   670 <free>
  return freep;
 77f:	8b 15 b4 0b 00 00    	mov    0xbb4,%edx
      if((p = morecore(nunits)) == 0)
 785:	83 c4 10             	add    $0x10,%esp
 788:	85 d2                	test   %edx,%edx
 78a:	75 bc                	jne    748 <malloc+0x48>
        return 0;
  }
}
 78c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 78f:	31 c0                	xor    %eax,%eax
}
 791:	5b                   	pop    %ebx
 792:	5e                   	pop    %esi
 793:	5f                   	pop    %edi
 794:	5d                   	pop    %ebp
 795:	c3                   	ret    
    if(p->s.size >= nunits){
 796:	89 d0                	mov    %edx,%eax
 798:	89 fa                	mov    %edi,%edx
 79a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 7a0:	39 ce                	cmp    %ecx,%esi
 7a2:	74 4c                	je     7f0 <malloc+0xf0>
        p->s.size -= nunits;
 7a4:	29 f1                	sub    %esi,%ecx
 7a6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 7a9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 7ac:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 7af:	89 15 b4 0b 00 00    	mov    %edx,0xbb4
}
 7b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 7b8:	83 c0 08             	add    $0x8,%eax
}
 7bb:	5b                   	pop    %ebx
 7bc:	5e                   	pop    %esi
 7bd:	5f                   	pop    %edi
 7be:	5d                   	pop    %ebp
 7bf:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 7c0:	c7 05 b4 0b 00 00 b8 	movl   $0xbb8,0xbb4
 7c7:	0b 00 00 
    base.s.size = 0;
 7ca:	bf b8 0b 00 00       	mov    $0xbb8,%edi
    base.s.ptr = freep = prevp = &base;
 7cf:	c7 05 b8 0b 00 00 b8 	movl   $0xbb8,0xbb8
 7d6:	0b 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 7db:	c7 05 bc 0b 00 00 00 	movl   $0x0,0xbbc
 7e2:	00 00 00 
    if(p->s.size >= nunits){
 7e5:	e9 42 ff ff ff       	jmp    72c <malloc+0x2c>
 7ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 7f0:	8b 08                	mov    (%eax),%ecx
 7f2:	89 0a                	mov    %ecx,(%edx)
 7f4:	eb b9                	jmp    7af <malloc+0xaf>
