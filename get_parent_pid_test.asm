
_get_parent_pid_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
        printf(2, "Failed to create 3rd process.\n");
    }
    exit();
}

int main(int argc, char* argv[]) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
    int forkpid = fork();
  11:	e8 2f 03 00 00       	call   345 <fork>
    if (forkpid > 0) {
  16:	85 c0                	test   %eax,%eax
  18:	7f 1d                	jg     37 <main+0x37>
        wait();
    }
    else if (forkpid == 0) {
  1a:	74 16                	je     32 <main+0x32>
        second();
    }
    else {
        printf(2, "Failed to create 2nd process.\n");
  1c:	50                   	push   %eax
  1d:	50                   	push   %eax
  1e:	68 98 08 00 00       	push   $0x898
  23:	6a 02                	push   $0x2
  25:	e8 d6 04 00 00       	call   500 <printf>
  2a:	83 c4 10             	add    $0x10,%esp
    }
    exit();
  2d:	e8 1b 03 00 00       	call   34d <exit>
        second();
  32:	e8 39 00 00 00       	call   70 <second>
        wait();
  37:	e8 19 03 00 00       	call   355 <wait>
  3c:	eb ef                	jmp    2d <main+0x2d>
  3e:	66 90                	xchg   %ax,%ax

00000040 <third>:
void third() {
  40:	55                   	push   %ebp
  41:	89 e5                	mov    %esp,%ebp
  43:	53                   	push   %ebx
  44:	83 ec 04             	sub    $0x4,%esp
    printf(1, "3rd Process:\n  PID: %d\n  Parent: %d\n", getpid(), get_parent_pid());
  47:	e8 b9 03 00 00       	call   405 <get_parent_pid>
  4c:	89 c3                	mov    %eax,%ebx
  4e:	e8 7a 03 00 00       	call   3cd <getpid>
  53:	53                   	push   %ebx
  54:	50                   	push   %eax
  55:	68 28 08 00 00       	push   $0x828
  5a:	6a 01                	push   $0x1
  5c:	e8 9f 04 00 00       	call   500 <printf>
    exit();
  61:	e8 e7 02 00 00       	call   34d <exit>
  66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  6d:	8d 76 00             	lea    0x0(%esi),%esi

00000070 <second>:
void second() {
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  73:	53                   	push   %ebx
  74:	83 ec 04             	sub    $0x4,%esp
    printf(1, "2nd Process:\n  PID: %d\n  Parent: %d\n", getpid(), get_parent_pid());
  77:	e8 89 03 00 00       	call   405 <get_parent_pid>
  7c:	89 c3                	mov    %eax,%ebx
  7e:	e8 4a 03 00 00       	call   3cd <getpid>
  83:	53                   	push   %ebx
  84:	50                   	push   %eax
  85:	68 50 08 00 00       	push   $0x850
  8a:	6a 01                	push   $0x1
  8c:	e8 6f 04 00 00       	call   500 <printf>
    int forkpid = fork();
  91:	e8 af 02 00 00       	call   345 <fork>
    if (forkpid > 0) {
  96:	83 c4 10             	add    $0x10,%esp
  99:	85 c0                	test   %eax,%eax
  9b:	7f 1d                	jg     ba <second+0x4a>
    else if (forkpid == 0) {
  9d:	74 16                	je     b5 <second+0x45>
        printf(2, "Failed to create 3rd process.\n");
  9f:	50                   	push   %eax
  a0:	50                   	push   %eax
  a1:	68 78 08 00 00       	push   $0x878
  a6:	6a 02                	push   $0x2
  a8:	e8 53 04 00 00       	call   500 <printf>
  ad:	83 c4 10             	add    $0x10,%esp
    exit();
  b0:	e8 98 02 00 00       	call   34d <exit>
        third();
  b5:	e8 86 ff ff ff       	call   40 <third>
        wait();
  ba:	e8 96 02 00 00       	call   355 <wait>
  bf:	eb ef                	jmp    b0 <second+0x40>
  c1:	66 90                	xchg   %ax,%ax
  c3:	66 90                	xchg   %ax,%ax
  c5:	66 90                	xchg   %ax,%ax
  c7:	66 90                	xchg   %ax,%ax
  c9:	66 90                	xchg   %ax,%ax
  cb:	66 90                	xchg   %ax,%ax
  cd:	66 90                	xchg   %ax,%ax
  cf:	90                   	nop

000000d0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  d0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  d1:	31 c0                	xor    %eax,%eax
{
  d3:	89 e5                	mov    %esp,%ebp
  d5:	53                   	push   %ebx
  d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  e0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  e4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  e7:	83 c0 01             	add    $0x1,%eax
  ea:	84 d2                	test   %dl,%dl
  ec:	75 f2                	jne    e0 <strcpy+0x10>
    ;
  return os;
}
  ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  f1:	89 c8                	mov    %ecx,%eax
  f3:	c9                   	leave  
  f4:	c3                   	ret    
  f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000100 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	53                   	push   %ebx
 104:	8b 55 08             	mov    0x8(%ebp),%edx
 107:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 10a:	0f b6 02             	movzbl (%edx),%eax
 10d:	84 c0                	test   %al,%al
 10f:	75 17                	jne    128 <strcmp+0x28>
 111:	eb 3a                	jmp    14d <strcmp+0x4d>
 113:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 117:	90                   	nop
 118:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 11c:	83 c2 01             	add    $0x1,%edx
 11f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 122:	84 c0                	test   %al,%al
 124:	74 1a                	je     140 <strcmp+0x40>
    p++, q++;
 126:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 128:	0f b6 19             	movzbl (%ecx),%ebx
 12b:	38 c3                	cmp    %al,%bl
 12d:	74 e9                	je     118 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 12f:	29 d8                	sub    %ebx,%eax
}
 131:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 134:	c9                   	leave  
 135:	c3                   	ret    
 136:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 13d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 140:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 144:	31 c0                	xor    %eax,%eax
 146:	29 d8                	sub    %ebx,%eax
}
 148:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 14b:	c9                   	leave  
 14c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 14d:	0f b6 19             	movzbl (%ecx),%ebx
 150:	31 c0                	xor    %eax,%eax
 152:	eb db                	jmp    12f <strcmp+0x2f>
 154:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 15b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 15f:	90                   	nop

00000160 <strlen>:

uint
strlen(const char *s)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 166:	80 3a 00             	cmpb   $0x0,(%edx)
 169:	74 15                	je     180 <strlen+0x20>
 16b:	31 c0                	xor    %eax,%eax
 16d:	8d 76 00             	lea    0x0(%esi),%esi
 170:	83 c0 01             	add    $0x1,%eax
 173:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 177:	89 c1                	mov    %eax,%ecx
 179:	75 f5                	jne    170 <strlen+0x10>
    ;
  return n;
}
 17b:	89 c8                	mov    %ecx,%eax
 17d:	5d                   	pop    %ebp
 17e:	c3                   	ret    
 17f:	90                   	nop
  for(n = 0; s[n]; n++)
 180:	31 c9                	xor    %ecx,%ecx
}
 182:	5d                   	pop    %ebp
 183:	89 c8                	mov    %ecx,%eax
 185:	c3                   	ret    
 186:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 18d:	8d 76 00             	lea    0x0(%esi),%esi

00000190 <memset>:

void*
memset(void *dst, int c, uint n)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	57                   	push   %edi
 194:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 197:	8b 4d 10             	mov    0x10(%ebp),%ecx
 19a:	8b 45 0c             	mov    0xc(%ebp),%eax
 19d:	89 d7                	mov    %edx,%edi
 19f:	fc                   	cld    
 1a0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1a2:	8b 7d fc             	mov    -0x4(%ebp),%edi
 1a5:	89 d0                	mov    %edx,%eax
 1a7:	c9                   	leave  
 1a8:	c3                   	ret    
 1a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001b0 <strchr>:

char*
strchr(const char *s, char c)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1ba:	0f b6 10             	movzbl (%eax),%edx
 1bd:	84 d2                	test   %dl,%dl
 1bf:	75 12                	jne    1d3 <strchr+0x23>
 1c1:	eb 1d                	jmp    1e0 <strchr+0x30>
 1c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1c7:	90                   	nop
 1c8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 1cc:	83 c0 01             	add    $0x1,%eax
 1cf:	84 d2                	test   %dl,%dl
 1d1:	74 0d                	je     1e0 <strchr+0x30>
    if(*s == c)
 1d3:	38 d1                	cmp    %dl,%cl
 1d5:	75 f1                	jne    1c8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 1d7:	5d                   	pop    %ebp
 1d8:	c3                   	ret    
 1d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 1e0:	31 c0                	xor    %eax,%eax
}
 1e2:	5d                   	pop    %ebp
 1e3:	c3                   	ret    
 1e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1ef:	90                   	nop

000001f0 <gets>:

char*
gets(char *buf, int max)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	57                   	push   %edi
 1f4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 1f5:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 1f8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 1f9:	31 db                	xor    %ebx,%ebx
{
 1fb:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 1fe:	eb 27                	jmp    227 <gets+0x37>
    cc = read(0, &c, 1);
 200:	83 ec 04             	sub    $0x4,%esp
 203:	6a 01                	push   $0x1
 205:	57                   	push   %edi
 206:	6a 00                	push   $0x0
 208:	e8 58 01 00 00       	call   365 <read>
    if(cc < 1)
 20d:	83 c4 10             	add    $0x10,%esp
 210:	85 c0                	test   %eax,%eax
 212:	7e 1d                	jle    231 <gets+0x41>
      break;
    buf[i++] = c;
 214:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 218:	8b 55 08             	mov    0x8(%ebp),%edx
 21b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 21f:	3c 0a                	cmp    $0xa,%al
 221:	74 1d                	je     240 <gets+0x50>
 223:	3c 0d                	cmp    $0xd,%al
 225:	74 19                	je     240 <gets+0x50>
  for(i=0; i+1 < max; ){
 227:	89 de                	mov    %ebx,%esi
 229:	83 c3 01             	add    $0x1,%ebx
 22c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 22f:	7c cf                	jl     200 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 231:	8b 45 08             	mov    0x8(%ebp),%eax
 234:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 238:	8d 65 f4             	lea    -0xc(%ebp),%esp
 23b:	5b                   	pop    %ebx
 23c:	5e                   	pop    %esi
 23d:	5f                   	pop    %edi
 23e:	5d                   	pop    %ebp
 23f:	c3                   	ret    
  buf[i] = '\0';
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	89 de                	mov    %ebx,%esi
 245:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 249:	8d 65 f4             	lea    -0xc(%ebp),%esp
 24c:	5b                   	pop    %ebx
 24d:	5e                   	pop    %esi
 24e:	5f                   	pop    %edi
 24f:	5d                   	pop    %ebp
 250:	c3                   	ret    
 251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 258:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 25f:	90                   	nop

00000260 <stat>:

int
stat(const char *n, struct stat *st)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	56                   	push   %esi
 264:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 265:	83 ec 08             	sub    $0x8,%esp
 268:	6a 00                	push   $0x0
 26a:	ff 75 08             	push   0x8(%ebp)
 26d:	e8 1b 01 00 00       	call   38d <open>
  if(fd < 0)
 272:	83 c4 10             	add    $0x10,%esp
 275:	85 c0                	test   %eax,%eax
 277:	78 27                	js     2a0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 279:	83 ec 08             	sub    $0x8,%esp
 27c:	ff 75 0c             	push   0xc(%ebp)
 27f:	89 c3                	mov    %eax,%ebx
 281:	50                   	push   %eax
 282:	e8 1e 01 00 00       	call   3a5 <fstat>
  close(fd);
 287:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 28a:	89 c6                	mov    %eax,%esi
  close(fd);
 28c:	e8 e4 00 00 00       	call   375 <close>
  return r;
 291:	83 c4 10             	add    $0x10,%esp
}
 294:	8d 65 f8             	lea    -0x8(%ebp),%esp
 297:	89 f0                	mov    %esi,%eax
 299:	5b                   	pop    %ebx
 29a:	5e                   	pop    %esi
 29b:	5d                   	pop    %ebp
 29c:	c3                   	ret    
 29d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 2a0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2a5:	eb ed                	jmp    294 <stat+0x34>
 2a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ae:	66 90                	xchg   %ax,%ax

000002b0 <atoi>:

int
atoi(const char *s)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	53                   	push   %ebx
 2b4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b7:	0f be 02             	movsbl (%edx),%eax
 2ba:	8d 48 d0             	lea    -0x30(%eax),%ecx
 2bd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 2c0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 2c5:	77 1e                	ja     2e5 <atoi+0x35>
 2c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ce:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 2d0:	83 c2 01             	add    $0x1,%edx
 2d3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 2d6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 2da:	0f be 02             	movsbl (%edx),%eax
 2dd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2e0:	80 fb 09             	cmp    $0x9,%bl
 2e3:	76 eb                	jbe    2d0 <atoi+0x20>
  return n;
}
 2e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2e8:	89 c8                	mov    %ecx,%eax
 2ea:	c9                   	leave  
 2eb:	c3                   	ret    
 2ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002f0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	57                   	push   %edi
 2f4:	8b 45 10             	mov    0x10(%ebp),%eax
 2f7:	8b 55 08             	mov    0x8(%ebp),%edx
 2fa:	56                   	push   %esi
 2fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2fe:	85 c0                	test   %eax,%eax
 300:	7e 13                	jle    315 <memmove+0x25>
 302:	01 d0                	add    %edx,%eax
  dst = vdst;
 304:	89 d7                	mov    %edx,%edi
 306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 30d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 310:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 311:	39 f8                	cmp    %edi,%eax
 313:	75 fb                	jne    310 <memmove+0x20>
  return vdst;
}
 315:	5e                   	pop    %esi
 316:	89 d0                	mov    %edx,%eax
 318:	5f                   	pop    %edi
 319:	5d                   	pop    %ebp
 31a:	c3                   	ret    
 31b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 31f:	90                   	nop

00000320 <srand>:

static uint seed = 1;

void
srand(uint s)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
  seed = s;
 323:	8b 45 08             	mov    0x8(%ebp),%eax
}
 326:	5d                   	pop    %ebp
  seed = s;
 327:	a3 2c 0c 00 00       	mov    %eax,0xc2c
}
 32c:	c3                   	ret    
 32d:	8d 76 00             	lea    0x0(%esi),%esi

00000330 <random>:

uint
random(void)
{
  seed = seed
    * 1103515245
 330:	69 05 2c 0c 00 00 6d 	imul   $0x41c64e6d,0xc2c,%eax
 337:	4e c6 41 
    + 12345
 33a:	05 39 30 00 00       	add    $0x3039,%eax
  seed = seed
 33f:	a3 2c 0c 00 00       	mov    %eax,0xc2c
    % (1 << 31);
  return seed;
}
 344:	c3                   	ret    

00000345 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 345:	b8 01 00 00 00       	mov    $0x1,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <exit>:
SYSCALL(exit)
 34d:	b8 02 00 00 00       	mov    $0x2,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <wait>:
SYSCALL(wait)
 355:	b8 03 00 00 00       	mov    $0x3,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <pipe>:
SYSCALL(pipe)
 35d:	b8 04 00 00 00       	mov    $0x4,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <read>:
SYSCALL(read)
 365:	b8 05 00 00 00       	mov    $0x5,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <write>:
SYSCALL(write)
 36d:	b8 10 00 00 00       	mov    $0x10,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <close>:
SYSCALL(close)
 375:	b8 15 00 00 00       	mov    $0x15,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <kill>:
SYSCALL(kill)
 37d:	b8 06 00 00 00       	mov    $0x6,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <exec>:
SYSCALL(exec)
 385:	b8 07 00 00 00       	mov    $0x7,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <open>:
SYSCALL(open)
 38d:	b8 0f 00 00 00       	mov    $0xf,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <mknod>:
SYSCALL(mknod)
 395:	b8 11 00 00 00       	mov    $0x11,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <unlink>:
SYSCALL(unlink)
 39d:	b8 12 00 00 00       	mov    $0x12,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <fstat>:
SYSCALL(fstat)
 3a5:	b8 08 00 00 00       	mov    $0x8,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <link>:
SYSCALL(link)
 3ad:	b8 13 00 00 00       	mov    $0x13,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <mkdir>:
SYSCALL(mkdir)
 3b5:	b8 14 00 00 00       	mov    $0x14,%eax
 3ba:	cd 40                	int    $0x40
 3bc:	c3                   	ret    

000003bd <chdir>:
SYSCALL(chdir)
 3bd:	b8 09 00 00 00       	mov    $0x9,%eax
 3c2:	cd 40                	int    $0x40
 3c4:	c3                   	ret    

000003c5 <dup>:
SYSCALL(dup)
 3c5:	b8 0a 00 00 00       	mov    $0xa,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	ret    

000003cd <getpid>:
SYSCALL(getpid)
 3cd:	b8 0b 00 00 00       	mov    $0xb,%eax
 3d2:	cd 40                	int    $0x40
 3d4:	c3                   	ret    

000003d5 <sbrk>:
SYSCALL(sbrk)
 3d5:	b8 0c 00 00 00       	mov    $0xc,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	ret    

000003dd <sleep>:
SYSCALL(sleep)
 3dd:	b8 0d 00 00 00       	mov    $0xd,%eax
 3e2:	cd 40                	int    $0x40
 3e4:	c3                   	ret    

000003e5 <uptime>:
SYSCALL(uptime)
 3e5:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ea:	cd 40                	int    $0x40
 3ec:	c3                   	ret    

000003ed <find_largest_prime_factor>:
SYSCALL(find_largest_prime_factor)
 3ed:	b8 16 00 00 00       	mov    $0x16,%eax
 3f2:	cd 40                	int    $0x40
 3f4:	c3                   	ret    

000003f5 <change_file_size>:
SYSCALL(change_file_size)
 3f5:	b8 17 00 00 00       	mov    $0x17,%eax
 3fa:	cd 40                	int    $0x40
 3fc:	c3                   	ret    

000003fd <get_callers>:
SYSCALL(get_callers)
 3fd:	b8 18 00 00 00       	mov    $0x18,%eax
 402:	cd 40                	int    $0x40
 404:	c3                   	ret    

00000405 <get_parent_pid>:
SYSCALL(get_parent_pid)
 405:	b8 19 00 00 00       	mov    $0x19,%eax
 40a:	cd 40                	int    $0x40
 40c:	c3                   	ret    

0000040d <change_scheduling_queue>:
SYSCALL(change_scheduling_queue)
 40d:	b8 1a 00 00 00       	mov    $0x1a,%eax
 412:	cd 40                	int    $0x40
 414:	c3                   	ret    

00000415 <set_bjf_params_process>:
SYSCALL(set_bjf_params_process)
 415:	b8 1c 00 00 00       	mov    $0x1c,%eax
 41a:	cd 40                	int    $0x40
 41c:	c3                   	ret    

0000041d <set_bjf_params_system>:
SYSCALL(set_bjf_params_system)
 41d:	b8 1d 00 00 00       	mov    $0x1d,%eax
 422:	cd 40                	int    $0x40
 424:	c3                   	ret    

00000425 <set_bjf_priority>:
SYSCALL(set_bjf_priority)
 425:	b8 1e 00 00 00       	mov    $0x1e,%eax
 42a:	cd 40                	int    $0x40
 42c:	c3                   	ret    

0000042d <print_process_info>:
SYSCALL(print_process_info)
 42d:	b8 1f 00 00 00       	mov    $0x1f,%eax
 432:	cd 40                	int    $0x40
 434:	c3                   	ret    

00000435 <sem_init>:
SYSCALL(sem_init)
 435:	b8 20 00 00 00       	mov    $0x20,%eax
 43a:	cd 40                	int    $0x40
 43c:	c3                   	ret    

0000043d <sem_acquire>:
SYSCALL(sem_acquire)
 43d:	b8 21 00 00 00       	mov    $0x21,%eax
 442:	cd 40                	int    $0x40
 444:	c3                   	ret    

00000445 <sem_release>:
SYSCALL(sem_release)
 445:	b8 22 00 00 00       	mov    $0x22,%eax
 44a:	cd 40                	int    $0x40
 44c:	c3                   	ret    
 44d:	66 90                	xchg   %ax,%ax
 44f:	90                   	nop

00000450 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	57                   	push   %edi
 454:	56                   	push   %esi
 455:	53                   	push   %ebx
 456:	83 ec 3c             	sub    $0x3c,%esp
 459:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 45c:	89 d1                	mov    %edx,%ecx
{
 45e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 461:	85 d2                	test   %edx,%edx
 463:	0f 89 7f 00 00 00    	jns    4e8 <printint+0x98>
 469:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 46d:	74 79                	je     4e8 <printint+0x98>
    neg = 1;
 46f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 476:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 478:	31 db                	xor    %ebx,%ebx
 47a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 47d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 480:	89 c8                	mov    %ecx,%eax
 482:	31 d2                	xor    %edx,%edx
 484:	89 cf                	mov    %ecx,%edi
 486:	f7 75 c4             	divl   -0x3c(%ebp)
 489:	0f b6 92 18 09 00 00 	movzbl 0x918(%edx),%edx
 490:	89 45 c0             	mov    %eax,-0x40(%ebp)
 493:	89 d8                	mov    %ebx,%eax
 495:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 498:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 49b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 49e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 4a1:	76 dd                	jbe    480 <printint+0x30>
  if(neg)
 4a3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 4a6:	85 c9                	test   %ecx,%ecx
 4a8:	74 0c                	je     4b6 <printint+0x66>
    buf[i++] = '-';
 4aa:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 4af:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 4b1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 4b6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 4b9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 4bd:	eb 07                	jmp    4c6 <printint+0x76>
 4bf:	90                   	nop
    putc(fd, buf[i]);
 4c0:	0f b6 13             	movzbl (%ebx),%edx
 4c3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 4c6:	83 ec 04             	sub    $0x4,%esp
 4c9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 4cc:	6a 01                	push   $0x1
 4ce:	56                   	push   %esi
 4cf:	57                   	push   %edi
 4d0:	e8 98 fe ff ff       	call   36d <write>
  while(--i >= 0)
 4d5:	83 c4 10             	add    $0x10,%esp
 4d8:	39 de                	cmp    %ebx,%esi
 4da:	75 e4                	jne    4c0 <printint+0x70>
}
 4dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4df:	5b                   	pop    %ebx
 4e0:	5e                   	pop    %esi
 4e1:	5f                   	pop    %edi
 4e2:	5d                   	pop    %ebp
 4e3:	c3                   	ret    
 4e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 4e8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 4ef:	eb 87                	jmp    478 <printint+0x28>
 4f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ff:	90                   	nop

00000500 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	57                   	push   %edi
 504:	56                   	push   %esi
 505:	53                   	push   %ebx
 506:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 509:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 50c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 50f:	0f b6 13             	movzbl (%ebx),%edx
 512:	84 d2                	test   %dl,%dl
 514:	74 6a                	je     580 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 516:	8d 45 10             	lea    0x10(%ebp),%eax
 519:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 51c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 51f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 521:	89 45 d0             	mov    %eax,-0x30(%ebp)
 524:	eb 36                	jmp    55c <printf+0x5c>
 526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 52d:	8d 76 00             	lea    0x0(%esi),%esi
 530:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 533:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 538:	83 f8 25             	cmp    $0x25,%eax
 53b:	74 15                	je     552 <printf+0x52>
  write(fd, &c, 1);
 53d:	83 ec 04             	sub    $0x4,%esp
 540:	88 55 e7             	mov    %dl,-0x19(%ebp)
 543:	6a 01                	push   $0x1
 545:	57                   	push   %edi
 546:	56                   	push   %esi
 547:	e8 21 fe ff ff       	call   36d <write>
 54c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 54f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 552:	0f b6 13             	movzbl (%ebx),%edx
 555:	83 c3 01             	add    $0x1,%ebx
 558:	84 d2                	test   %dl,%dl
 55a:	74 24                	je     580 <printf+0x80>
    c = fmt[i] & 0xff;
 55c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 55f:	85 c9                	test   %ecx,%ecx
 561:	74 cd                	je     530 <printf+0x30>
      }
    } else if(state == '%'){
 563:	83 f9 25             	cmp    $0x25,%ecx
 566:	75 ea                	jne    552 <printf+0x52>
      if(c == 'd'){
 568:	83 f8 25             	cmp    $0x25,%eax
 56b:	0f 84 07 01 00 00    	je     678 <printf+0x178>
 571:	83 e8 63             	sub    $0x63,%eax
 574:	83 f8 15             	cmp    $0x15,%eax
 577:	77 17                	ja     590 <printf+0x90>
 579:	ff 24 85 c0 08 00 00 	jmp    *0x8c0(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 580:	8d 65 f4             	lea    -0xc(%ebp),%esp
 583:	5b                   	pop    %ebx
 584:	5e                   	pop    %esi
 585:	5f                   	pop    %edi
 586:	5d                   	pop    %ebp
 587:	c3                   	ret    
 588:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 58f:	90                   	nop
  write(fd, &c, 1);
 590:	83 ec 04             	sub    $0x4,%esp
 593:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 596:	6a 01                	push   $0x1
 598:	57                   	push   %edi
 599:	56                   	push   %esi
 59a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 59e:	e8 ca fd ff ff       	call   36d <write>
        putc(fd, c);
 5a3:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 5a7:	83 c4 0c             	add    $0xc,%esp
 5aa:	88 55 e7             	mov    %dl,-0x19(%ebp)
 5ad:	6a 01                	push   $0x1
 5af:	57                   	push   %edi
 5b0:	56                   	push   %esi
 5b1:	e8 b7 fd ff ff       	call   36d <write>
        putc(fd, c);
 5b6:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5b9:	31 c9                	xor    %ecx,%ecx
 5bb:	eb 95                	jmp    552 <printf+0x52>
 5bd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 5c0:	83 ec 0c             	sub    $0xc,%esp
 5c3:	b9 10 00 00 00       	mov    $0x10,%ecx
 5c8:	6a 00                	push   $0x0
 5ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
 5cd:	8b 10                	mov    (%eax),%edx
 5cf:	89 f0                	mov    %esi,%eax
 5d1:	e8 7a fe ff ff       	call   450 <printint>
        ap++;
 5d6:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 5da:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5dd:	31 c9                	xor    %ecx,%ecx
 5df:	e9 6e ff ff ff       	jmp    552 <printf+0x52>
 5e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 5e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
 5eb:	8b 10                	mov    (%eax),%edx
        ap++;
 5ed:	83 c0 04             	add    $0x4,%eax
 5f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 5f3:	85 d2                	test   %edx,%edx
 5f5:	0f 84 8d 00 00 00    	je     688 <printf+0x188>
        while(*s != 0){
 5fb:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 5fe:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 600:	84 c0                	test   %al,%al
 602:	0f 84 4a ff ff ff    	je     552 <printf+0x52>
 608:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 60b:	89 d3                	mov    %edx,%ebx
 60d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 610:	83 ec 04             	sub    $0x4,%esp
          s++;
 613:	83 c3 01             	add    $0x1,%ebx
 616:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 619:	6a 01                	push   $0x1
 61b:	57                   	push   %edi
 61c:	56                   	push   %esi
 61d:	e8 4b fd ff ff       	call   36d <write>
        while(*s != 0){
 622:	0f b6 03             	movzbl (%ebx),%eax
 625:	83 c4 10             	add    $0x10,%esp
 628:	84 c0                	test   %al,%al
 62a:	75 e4                	jne    610 <printf+0x110>
      state = 0;
 62c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 62f:	31 c9                	xor    %ecx,%ecx
 631:	e9 1c ff ff ff       	jmp    552 <printf+0x52>
 636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 63d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 640:	83 ec 0c             	sub    $0xc,%esp
 643:	b9 0a 00 00 00       	mov    $0xa,%ecx
 648:	6a 01                	push   $0x1
 64a:	e9 7b ff ff ff       	jmp    5ca <printf+0xca>
 64f:	90                   	nop
        putc(fd, *ap);
 650:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 653:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 656:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 658:	6a 01                	push   $0x1
 65a:	57                   	push   %edi
 65b:	56                   	push   %esi
        putc(fd, *ap);
 65c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 65f:	e8 09 fd ff ff       	call   36d <write>
        ap++;
 664:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 668:	83 c4 10             	add    $0x10,%esp
      state = 0;
 66b:	31 c9                	xor    %ecx,%ecx
 66d:	e9 e0 fe ff ff       	jmp    552 <printf+0x52>
 672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 678:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 67b:	83 ec 04             	sub    $0x4,%esp
 67e:	e9 2a ff ff ff       	jmp    5ad <printf+0xad>
 683:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 687:	90                   	nop
          s = "(null)";
 688:	ba b7 08 00 00       	mov    $0x8b7,%edx
        while(*s != 0){
 68d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 690:	b8 28 00 00 00       	mov    $0x28,%eax
 695:	89 d3                	mov    %edx,%ebx
 697:	e9 74 ff ff ff       	jmp    610 <printf+0x110>
 69c:	66 90                	xchg   %ax,%ax
 69e:	66 90                	xchg   %ax,%ax

000006a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6a0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a1:	a1 30 0c 00 00       	mov    0xc30,%eax
{
 6a6:	89 e5                	mov    %esp,%ebp
 6a8:	57                   	push   %edi
 6a9:	56                   	push   %esi
 6aa:	53                   	push   %ebx
 6ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 6ae:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6b8:	89 c2                	mov    %eax,%edx
 6ba:	8b 00                	mov    (%eax),%eax
 6bc:	39 ca                	cmp    %ecx,%edx
 6be:	73 30                	jae    6f0 <free+0x50>
 6c0:	39 c1                	cmp    %eax,%ecx
 6c2:	72 04                	jb     6c8 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c4:	39 c2                	cmp    %eax,%edx
 6c6:	72 f0                	jb     6b8 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6c8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6cb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6ce:	39 f8                	cmp    %edi,%eax
 6d0:	74 30                	je     702 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 6d2:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6d5:	8b 42 04             	mov    0x4(%edx),%eax
 6d8:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 6db:	39 f1                	cmp    %esi,%ecx
 6dd:	74 3a                	je     719 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 6df:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 6e1:	5b                   	pop    %ebx
  freep = p;
 6e2:	89 15 30 0c 00 00    	mov    %edx,0xc30
}
 6e8:	5e                   	pop    %esi
 6e9:	5f                   	pop    %edi
 6ea:	5d                   	pop    %ebp
 6eb:	c3                   	ret    
 6ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f0:	39 c2                	cmp    %eax,%edx
 6f2:	72 c4                	jb     6b8 <free+0x18>
 6f4:	39 c1                	cmp    %eax,%ecx
 6f6:	73 c0                	jae    6b8 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 6f8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6fb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6fe:	39 f8                	cmp    %edi,%eax
 700:	75 d0                	jne    6d2 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 702:	03 70 04             	add    0x4(%eax),%esi
 705:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 708:	8b 02                	mov    (%edx),%eax
 70a:	8b 00                	mov    (%eax),%eax
 70c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 70f:	8b 42 04             	mov    0x4(%edx),%eax
 712:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 715:	39 f1                	cmp    %esi,%ecx
 717:	75 c6                	jne    6df <free+0x3f>
    p->s.size += bp->s.size;
 719:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 71c:	89 15 30 0c 00 00    	mov    %edx,0xc30
    p->s.size += bp->s.size;
 722:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 725:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 728:	89 0a                	mov    %ecx,(%edx)
}
 72a:	5b                   	pop    %ebx
 72b:	5e                   	pop    %esi
 72c:	5f                   	pop    %edi
 72d:	5d                   	pop    %ebp
 72e:	c3                   	ret    
 72f:	90                   	nop

00000730 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 730:	55                   	push   %ebp
 731:	89 e5                	mov    %esp,%ebp
 733:	57                   	push   %edi
 734:	56                   	push   %esi
 735:	53                   	push   %ebx
 736:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 739:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 73c:	8b 3d 30 0c 00 00    	mov    0xc30,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 742:	8d 70 07             	lea    0x7(%eax),%esi
 745:	c1 ee 03             	shr    $0x3,%esi
 748:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 74b:	85 ff                	test   %edi,%edi
 74d:	0f 84 9d 00 00 00    	je     7f0 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 753:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 755:	8b 4a 04             	mov    0x4(%edx),%ecx
 758:	39 f1                	cmp    %esi,%ecx
 75a:	73 6a                	jae    7c6 <malloc+0x96>
 75c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 761:	39 de                	cmp    %ebx,%esi
 763:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 766:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 76d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 770:	eb 17                	jmp    789 <malloc+0x59>
 772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 778:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 77a:	8b 48 04             	mov    0x4(%eax),%ecx
 77d:	39 f1                	cmp    %esi,%ecx
 77f:	73 4f                	jae    7d0 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 781:	8b 3d 30 0c 00 00    	mov    0xc30,%edi
 787:	89 c2                	mov    %eax,%edx
 789:	39 d7                	cmp    %edx,%edi
 78b:	75 eb                	jne    778 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 78d:	83 ec 0c             	sub    $0xc,%esp
 790:	ff 75 e4             	push   -0x1c(%ebp)
 793:	e8 3d fc ff ff       	call   3d5 <sbrk>
  if(p == (char*)-1)
 798:	83 c4 10             	add    $0x10,%esp
 79b:	83 f8 ff             	cmp    $0xffffffff,%eax
 79e:	74 1c                	je     7bc <malloc+0x8c>
  hp->s.size = nu;
 7a0:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 7a3:	83 ec 0c             	sub    $0xc,%esp
 7a6:	83 c0 08             	add    $0x8,%eax
 7a9:	50                   	push   %eax
 7aa:	e8 f1 fe ff ff       	call   6a0 <free>
  return freep;
 7af:	8b 15 30 0c 00 00    	mov    0xc30,%edx
      if((p = morecore(nunits)) == 0)
 7b5:	83 c4 10             	add    $0x10,%esp
 7b8:	85 d2                	test   %edx,%edx
 7ba:	75 bc                	jne    778 <malloc+0x48>
        return 0;
  }
}
 7bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 7bf:	31 c0                	xor    %eax,%eax
}
 7c1:	5b                   	pop    %ebx
 7c2:	5e                   	pop    %esi
 7c3:	5f                   	pop    %edi
 7c4:	5d                   	pop    %ebp
 7c5:	c3                   	ret    
    if(p->s.size >= nunits){
 7c6:	89 d0                	mov    %edx,%eax
 7c8:	89 fa                	mov    %edi,%edx
 7ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 7d0:	39 ce                	cmp    %ecx,%esi
 7d2:	74 4c                	je     820 <malloc+0xf0>
        p->s.size -= nunits;
 7d4:	29 f1                	sub    %esi,%ecx
 7d6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 7d9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 7dc:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 7df:	89 15 30 0c 00 00    	mov    %edx,0xc30
}
 7e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 7e8:	83 c0 08             	add    $0x8,%eax
}
 7eb:	5b                   	pop    %ebx
 7ec:	5e                   	pop    %esi
 7ed:	5f                   	pop    %edi
 7ee:	5d                   	pop    %ebp
 7ef:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 7f0:	c7 05 30 0c 00 00 34 	movl   $0xc34,0xc30
 7f7:	0c 00 00 
    base.s.size = 0;
 7fa:	bf 34 0c 00 00       	mov    $0xc34,%edi
    base.s.ptr = freep = prevp = &base;
 7ff:	c7 05 34 0c 00 00 34 	movl   $0xc34,0xc34
 806:	0c 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 809:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 80b:	c7 05 38 0c 00 00 00 	movl   $0x0,0xc38
 812:	00 00 00 
    if(p->s.size >= nunits){
 815:	e9 42 ff ff ff       	jmp    75c <malloc+0x2c>
 81a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 820:	8b 08                	mov    (%eax),%ecx
 822:	89 0a                	mov    %ecx,(%edx)
 824:	eb b9                	jmp    7df <malloc+0xaf>
