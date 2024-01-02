
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 50 8a 13 80       	mov    $0x80138a50,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 10 37 10 80       	mov    $0x80103710,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 c5 10 80       	mov    $0x8010c554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 20 8a 10 80       	push   $0x80108a20
80100051:	68 20 c5 10 80       	push   $0x8010c520
80100056:	e8 a5 55 00 00       	call   80105600 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c 0c 11 80       	mov    $0x80110c1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c 0c 11 80 1c 	movl   $0x80110c1c,0x80110c6c
8010006a:	0c 11 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 0c 11 80 1c 	movl   $0x80110c1c,0x80110c70
80100074:	0c 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c 0c 11 80 	movl   $0x80110c1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 8a 10 80       	push   $0x80108a27
80100097:	50                   	push   %eax
80100098:	e8 23 54 00 00       	call   801054c0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 0c 11 80       	mov    0x80110c70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 0c 11 80    	mov    %ebx,0x80110c70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 09 11 80    	cmp    $0x801109c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 c5 10 80       	push   $0x8010c520
801000e4:	e8 e7 56 00 00       	call   801057d0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 0c 11 80    	mov    0x80110c70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c 0c 11 80    	mov    0x80110c6c,%ebx
80100126:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 c5 10 80       	push   $0x8010c520
80100162:	e8 09 56 00 00       	call   80105770 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 8e 53 00 00       	call   80105500 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 ff 27 00 00       	call   80102990 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 2e 8a 10 80       	push   $0x80108a2e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 ed 53 00 00       	call   801055b0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 b7 27 00 00       	jmp    80102990 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 3f 8a 10 80       	push   $0x80108a3f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 ac 53 00 00       	call   801055b0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 4c 53 00 00       	call   80105560 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010021b:	e8 b0 55 00 00       	call   801057d0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 0c 11 80       	mov    0x80110c70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c 0c 11 80 	movl   $0x80110c1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 0c 11 80       	mov    0x80110c70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 0c 11 80    	mov    %ebx,0x80110c70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 c5 10 80 	movl   $0x8010c520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 ff 54 00 00       	jmp    80105770 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 46 8a 10 80       	push   $0x80108a46
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 97 1b 00 00       	call   80101e30 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 40 17 11 80 	movl   $0x80111740,(%esp)
801002a0:	e8 2b 55 00 00       	call   801057d0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 20 17 11 80       	mov    0x80111720,%eax
801002b5:	3b 05 24 17 11 80    	cmp    0x80111724,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 40 17 11 80       	push   $0x80111740
801002c8:	68 20 17 11 80       	push   $0x80111720
801002cd:	e8 2e 48 00 00       	call   80104b00 <sleep>
    while(input.r == input.w){
801002d2:	a1 20 17 11 80       	mov    0x80111720,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 24 17 11 80    	cmp    0x80111724,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 a9 3d 00 00       	call   80104090 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 40 17 11 80       	push   $0x80111740
801002f6:	e8 75 54 00 00       	call   80105770 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 4c 1a 00 00       	call   80101d50 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 20 17 11 80    	mov    %edx,0x80111720
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a a0 16 11 80 	movsbl -0x7feee960(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 40 17 11 80       	push   $0x80111740
8010034c:	e8 1f 54 00 00       	call   80105770 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 f6 19 00 00       	call   80101d50 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 20 17 11 80       	mov    %eax,0x80111720
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 74 17 11 80 00 	movl   $0x0,0x80111774
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 02 2c 00 00       	call   80102fa0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 4d 8a 10 80       	push   $0x80108a4d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 eb 94 10 80 	movl   $0x801094eb,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 53 52 00 00       	call   80105620 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 61 8a 10 80       	push   $0x80108a61
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 78 17 11 80 01 	movl   $0x1,0x80111778
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 61 6f 00 00       	call   80107380 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 76 6e 00 00       	call   80107380 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 6a 6e 00 00       	call   80107380 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 5e 6e 00 00       	call   80107380 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 da 53 00 00       	call   80105930 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 25 53 00 00       	call   80105890 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 65 8a 10 80       	push   $0x80108a65
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 8c 18 00 00       	call   80101e30 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 40 17 11 80 	movl   $0x80111740,(%esp)
801005ab:	e8 20 52 00 00       	call   801057d0 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 78 17 11 80    	mov    0x80111778,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 40 17 11 80       	push   $0x80111740
801005e4:	e8 87 51 00 00       	call   80105770 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 5e 17 00 00       	call   80101d50 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 e0 8a 10 80 	movzbl -0x7fef7520(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 78 17 11 80    	mov    0x80111778,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 74 17 11 80       	mov    0x80111774,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 78 17 11 80    	mov    0x80111778,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 78 17 11 80    	mov    0x80111778,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 78 17 11 80       	mov    0x80111778,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 40 17 11 80       	push   $0x80111740
801007e8:	e8 e3 4f 00 00       	call   801057d0 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 78 17 11 80    	mov    0x80111778,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 78 17 11 80    	mov    0x80111778,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf 78 8a 10 80       	mov    $0x80108a78,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 40 17 11 80       	push   $0x80111740
8010085b:	e8 10 4f 00 00       	call   80105770 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 7f 8a 10 80       	push   $0x80108a7f
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consputs>:
consputs(const char* s){
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	56                   	push   %esi
80100884:	53                   	push   %ebx
80100885:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100888:	8d b3 80 00 00 00    	lea    0x80(%ebx),%esi
  for(int i = 0; i < INPUT_BUF && (s[i]); ++i){
8010088e:	80 3b 00             	cmpb   $0x0,(%ebx)
80100891:	74 3c                	je     801008cf <consputs+0x4f>
    input.buf[input.e++ % INPUT_BUF] = s[i];
80100893:	a1 28 17 11 80       	mov    0x80111728,%eax
80100898:	8d 50 01             	lea    0x1(%eax),%edx
8010089b:	83 e0 7f             	and    $0x7f,%eax
8010089e:	89 15 28 17 11 80    	mov    %edx,0x80111728
801008a4:	0f b6 13             	movzbl (%ebx),%edx
801008a7:	88 90 a0 16 11 80    	mov    %dl,-0x7feee960(%eax)
  if(panicked){
801008ad:	a1 78 17 11 80       	mov    0x80111778,%eax
801008b2:	85 c0                	test   %eax,%eax
801008b4:	74 0a                	je     801008c0 <consputs+0x40>
801008b6:	fa                   	cli    
    for(;;)
801008b7:	eb fe                	jmp    801008b7 <consputs+0x37>
801008b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(s[i]);
801008c0:	0f be c2             	movsbl %dl,%eax
  for(int i = 0; i < INPUT_BUF && (s[i]); ++i){
801008c3:	83 c3 01             	add    $0x1,%ebx
801008c6:	e8 35 fb ff ff       	call   80100400 <consputc.part.0>
801008cb:	39 f3                	cmp    %esi,%ebx
801008cd:	75 bf                	jne    8010088e <consputs+0xe>
}
801008cf:	5b                   	pop    %ebx
801008d0:	5e                   	pop    %esi
801008d1:	5d                   	pop    %ebp
801008d2:	c3                   	ret    
801008d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801008da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801008e0 <consclear>:
  while(input.e != input.w &&
801008e0:	a1 28 17 11 80       	mov    0x80111728,%eax
801008e5:	3b 05 24 17 11 80    	cmp    0x80111724,%eax
801008eb:	74 44                	je     80100931 <consclear+0x51>
consclear(){
801008ed:	55                   	push   %ebp
801008ee:	89 e5                	mov    %esp,%ebp
801008f0:	83 ec 08             	sub    $0x8,%esp
        input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f3:	83 e8 01             	sub    $0x1,%eax
801008f6:	89 c2                	mov    %eax,%edx
801008f8:	83 e2 7f             	and    $0x7f,%edx
  while(input.e != input.w &&
801008fb:	80 ba a0 16 11 80 0a 	cmpb   $0xa,-0x7feee960(%edx)
80100902:	74 2b                	je     8010092f <consclear+0x4f>
    input.e--;
80100904:	a3 28 17 11 80       	mov    %eax,0x80111728
  if(panicked){
80100909:	a1 78 17 11 80       	mov    0x80111778,%eax
8010090e:	85 c0                	test   %eax,%eax
80100910:	74 06                	je     80100918 <consclear+0x38>
80100912:	fa                   	cli    
    for(;;)
80100913:	eb fe                	jmp    80100913 <consclear+0x33>
80100915:	8d 76 00             	lea    0x0(%esi),%esi
80100918:	b8 00 01 00 00       	mov    $0x100,%eax
8010091d:	e8 de fa ff ff       	call   80100400 <consputc.part.0>
  while(input.e != input.w &&
80100922:	a1 28 17 11 80       	mov    0x80111728,%eax
80100927:	3b 05 24 17 11 80    	cmp    0x80111724,%eax
8010092d:	75 c4                	jne    801008f3 <consclear+0x13>
}
8010092f:	c9                   	leave  
80100930:	c3                   	ret    
80100931:	c3                   	ret    
80100932:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100940 <revstr>:
{
80100940:	55                   	push   %ebp
80100941:	89 e5                	mov    %esp,%ebp
80100943:	56                   	push   %esi
  int i = 0, j = len - 1;
80100944:	8b 45 0c             	mov    0xc(%ebp),%eax
{
80100947:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010094a:	53                   	push   %ebx
  int i = 0, j = len - 1;
8010094b:	83 e8 01             	sub    $0x1,%eax
  while (i < j) {
8010094e:	85 c0                	test   %eax,%eax
80100950:	7e 20                	jle    80100972 <revstr+0x32>
  int i = 0, j = len - 1;
80100952:	31 d2                	xor    %edx,%edx
80100954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    char tmp = src[i];
80100958:	0f b6 34 11          	movzbl (%ecx,%edx,1),%esi
    src[i] = src[j];
8010095c:	0f b6 1c 01          	movzbl (%ecx,%eax,1),%ebx
80100960:	88 1c 11             	mov    %bl,(%ecx,%edx,1)
    src[j] = tmp;
80100963:	89 f3                	mov    %esi,%ebx
    i++;
80100965:	83 c2 01             	add    $0x1,%edx
    src[j] = tmp;
80100968:	88 1c 01             	mov    %bl,(%ecx,%eax,1)
    j--;
8010096b:	83 e8 01             	sub    $0x1,%eax
  while (i < j) {
8010096e:	39 c2                	cmp    %eax,%edx
80100970:	7c e6                	jl     80100958 <revstr+0x18>
}
80100972:	5b                   	pop    %ebx
80100973:	5e                   	pop    %esi
80100974:	5d                   	pop    %ebp
80100975:	c3                   	ret    
80100976:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097d:	8d 76 00             	lea    0x0(%esi),%esi

80100980 <consoleintr>:
{
80100980:	55                   	push   %ebp
80100981:	89 e5                	mov    %esp,%ebp
80100983:	57                   	push   %edi
80100984:	56                   	push   %esi
80100985:	53                   	push   %ebx
80100986:	81 ec a8 00 00 00    	sub    $0xa8,%esp
8010098c:	8b 45 08             	mov    0x8(%ebp),%eax
  acquire(&cons.lock);
8010098f:	68 40 17 11 80       	push   $0x80111740
{
80100994:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  acquire(&cons.lock);
8010099a:	e8 31 4e 00 00       	call   801057d0 <acquire>
  while((c = getc()) >= 0){
8010099f:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
801009a2:	c7 85 5c ff ff ff 00 	movl   $0x0,-0xa4(%ebp)
801009a9:	00 00 00 
  while((c = getc()) >= 0){
801009ac:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801009b2:	ff d0                	call   *%eax
801009b4:	89 c3                	mov    %eax,%ebx
801009b6:	85 c0                	test   %eax,%eax
801009b8:	0f 88 02 01 00 00    	js     80100ac0 <consoleintr+0x140>
    switch(c){
801009be:	83 fb 1b             	cmp    $0x1b,%ebx
801009c1:	7f 1d                	jg     801009e0 <consoleintr+0x60>
801009c3:	83 fb 07             	cmp    $0x7,%ebx
801009c6:	0f 8e 04 03 00 00    	jle    80100cd0 <consoleintr+0x350>
801009cc:	8d 43 f8             	lea    -0x8(%ebx),%eax
801009cf:	83 f8 13             	cmp    $0x13,%eax
801009d2:	0f 87 00 03 00 00    	ja     80100cd8 <consoleintr+0x358>
801009d8:	ff 24 85 90 8a 10 80 	jmp    *-0x7fef7570(,%eax,4)
801009df:	90                   	nop
801009e0:	83 fb 7f             	cmp    $0x7f,%ebx
801009e3:	0f 84 f7 01 00 00    	je     80100be0 <consoleintr+0x260>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009e9:	a1 28 17 11 80       	mov    0x80111728,%eax
801009ee:	89 c2                	mov    %eax,%edx
801009f0:	2b 15 20 17 11 80    	sub    0x80111720,%edx
801009f6:	83 fa 7f             	cmp    $0x7f,%edx
801009f9:	77 b1                	ja     801009ac <consoleintr+0x2c>
  if(panicked){
801009fb:	8b 0d 78 17 11 80    	mov    0x80111778,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
80100a01:	8d 50 01             	lea    0x1(%eax),%edx
80100a04:	83 e0 7f             	and    $0x7f,%eax
80100a07:	89 15 28 17 11 80    	mov    %edx,0x80111728
80100a0d:	88 98 a0 16 11 80    	mov    %bl,-0x7feee960(%eax)
  if(panicked){
80100a13:	85 c9                	test   %ecx,%ecx
80100a15:	0f 85 84 04 00 00    	jne    80100e9f <consoleintr+0x51f>
80100a1b:	89 d8                	mov    %ebx,%eax
80100a1d:	e8 de f9 ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a22:	83 fb 0a             	cmp    $0xa,%ebx
80100a25:	0f 84 f7 02 00 00    	je     80100d22 <consoleintr+0x3a2>
80100a2b:	83 fb 04             	cmp    $0x4,%ebx
80100a2e:	0f 84 ee 02 00 00    	je     80100d22 <consoleintr+0x3a2>
80100a34:	a1 20 17 11 80       	mov    0x80111720,%eax
80100a39:	83 e8 80             	sub    $0xffffff80,%eax
80100a3c:	39 05 28 17 11 80    	cmp    %eax,0x80111728
80100a42:	0f 85 64 ff ff ff    	jne    801009ac <consoleintr+0x2c>
80100a48:	e9 da 02 00 00       	jmp    80100d27 <consoleintr+0x3a7>
80100a4d:	8d 76 00             	lea    0x0(%esi),%esi
      if((c = getc()) == 91){
80100a50:	8b bd 64 ff ff ff    	mov    -0x9c(%ebp),%edi
80100a56:	ff d7                	call   *%edi
80100a58:	89 c3                	mov    %eax,%ebx
80100a5a:	83 f8 5b             	cmp    $0x5b,%eax
80100a5d:	0f 85 3d 02 00 00    	jne    80100ca0 <consoleintr+0x320>
        if((c = getc()) == ARROW_UP){
80100a63:	ff d7                	call   *%edi
80100a65:	89 c3                	mov    %eax,%ebx
80100a67:	83 f8 41             	cmp    $0x41,%eax
80100a6a:	0f 84 c8 04 00 00    	je     80100f38 <consoleintr+0x5b8>
        else if (c == ARROW_DOWN){
80100a70:	83 f8 42             	cmp    $0x42,%eax
80100a73:	0f 84 2f 04 00 00    	je     80100ea8 <consoleintr+0x528>
          input.buf[input.e++ % INPUT_BUF] = 27;
80100a79:	a1 28 17 11 80       	mov    0x80111728,%eax
  if(panicked){
80100a7e:	8b 3d 78 17 11 80    	mov    0x80111778,%edi
          input.buf[input.e++ % INPUT_BUF] = 27;
80100a84:	8d 50 01             	lea    0x1(%eax),%edx
80100a87:	83 e0 7f             	and    $0x7f,%eax
80100a8a:	89 15 28 17 11 80    	mov    %edx,0x80111728
80100a90:	c6 80 a0 16 11 80 1b 	movb   $0x1b,-0x7feee960(%eax)
  if(panicked){
80100a97:	85 ff                	test   %edi,%edi
80100a99:	0f 84 66 04 00 00    	je     80100f05 <consoleintr+0x585>
80100a9f:	fa                   	cli    
    for(;;)
80100aa0:	eb fe                	jmp    80100aa0 <consoleintr+0x120>
80100aa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      consclear();
80100aa8:	e8 33 fe ff ff       	call   801008e0 <consclear>
  while((c = getc()) >= 0){
80100aad:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80100ab3:	ff d0                	call   *%eax
80100ab5:	89 c3                	mov    %eax,%ebx
80100ab7:	85 c0                	test   %eax,%eax
80100ab9:	0f 89 ff fe ff ff    	jns    801009be <consoleintr+0x3e>
80100abf:	90                   	nop
  release(&cons.lock);
80100ac0:	83 ec 0c             	sub    $0xc,%esp
80100ac3:	68 40 17 11 80       	push   $0x80111740
80100ac8:	e8 a3 4c 00 00       	call   80105770 <release>
  if(doprocdump) {
80100acd:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
80100ad3:	83 c4 10             	add    $0x10,%esp
80100ad6:	85 d2                	test   %edx,%edx
80100ad8:	0f 85 a2 03 00 00    	jne    80100e80 <consoleintr+0x500>
}
80100ade:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ae1:	5b                   	pop    %ebx
80100ae2:	5e                   	pop    %esi
80100ae3:	5f                   	pop    %edi
80100ae4:	5d                   	pop    %ebp
80100ae5:	c3                   	ret    
80100ae6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aed:	8d 76 00             	lea    0x0(%esi),%esi
  for(int i = 0; i < input.e - input.w; ++i){
80100af0:	8b 3d 28 17 11 80    	mov    0x80111728,%edi
80100af6:	8b 15 24 17 11 80    	mov    0x80111724,%edx
  int j = 0;
80100afc:	31 c9                	xor    %ecx,%ecx
  for(int i = 0; i < input.e - input.w; ++i){
80100afe:	39 fa                	cmp    %edi,%edx
80100b00:	74 2b                	je     80100b2d <consoleintr+0x1ad>
80100b02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    int idx = (input.w + i) % INPUT_BUF;
80100b08:	89 d0                	mov    %edx,%eax
80100b0a:	83 e0 7f             	and    $0x7f,%eax
    if(input.buf[idx] >= '0' && input.buf[idx] <= '9'){
80100b0d:	0f b6 80 a0 16 11 80 	movzbl -0x7feee960(%eax),%eax
80100b14:	8d 58 d0             	lea    -0x30(%eax),%ebx
80100b17:	80 fb 09             	cmp    $0x9,%bl
80100b1a:	76 0a                	jbe    80100b26 <consoleintr+0x1a6>
    cmd[j++] = input.buf[idx];
80100b1c:	88 84 0d 68 ff ff ff 	mov    %al,-0x98(%ebp,%ecx,1)
80100b23:	83 c1 01             	add    $0x1,%ecx
  for(int i = 0; i < input.e - input.w; ++i){
80100b26:	83 c2 01             	add    $0x1,%edx
80100b29:	39 d7                	cmp    %edx,%edi
80100b2b:	75 db                	jne    80100b08 <consoleintr+0x188>
  cmd[j] = '\0';
80100b2d:	c6 84 0d 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%ecx,1)
80100b34:	00 
  consclear();
80100b35:	e8 a6 fd ff ff       	call   801008e0 <consclear>
  consputs(cmd);
80100b3a:	83 ec 0c             	sub    $0xc,%esp
80100b3d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80100b43:	50                   	push   %eax
80100b44:	e8 37 fd ff ff       	call   80100880 <consputs>
}
80100b49:	83 c4 10             	add    $0x10,%esp
80100b4c:	e9 5b fe ff ff       	jmp    801009ac <consoleintr+0x2c>
80100b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!hist.is_suggestion_used){
80100b58:	a1 0c 16 11 80       	mov    0x8011160c,%eax
80100b5d:	85 c0                	test   %eax,%eax
80100b5f:	0f 84 e3 02 00 00    	je     80100e48 <consoleintr+0x4c8>
  int suggested_cmd = get_suggestion(hist.original_cmd, hist.original_cmd_size);
80100b65:	a1 90 16 11 80       	mov    0x80111690,%eax
  for(int i = 0; i < HIST_SIZE; ++i){
80100b6a:	31 ff                	xor    %edi,%edi
  int suggested_cmd = get_suggestion(hist.original_cmd, hist.original_cmd_size);
80100b6c:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  for(int i = 0; i < HIST_SIZE; ++i){
80100b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    int idx = (i + hist.last_used_idx) % HIST_SIZE;
80100b78:	8b 1d 04 16 11 80    	mov    0x80111604,%ebx
80100b7e:	b8 89 88 88 88       	mov    $0x88888889,%eax
    if(strncmp(cmd, hist.cmd_buf[idx], cmd_size) == 0){
80100b83:	83 ec 04             	sub    $0x4,%esp
80100b86:	ff b5 60 ff ff ff    	push   -0xa0(%ebp)
    int idx = (i + hist.last_used_idx) % HIST_SIZE;
80100b8c:	01 fb                	add    %edi,%ebx
80100b8e:	f7 e3                	mul    %ebx
80100b90:	89 d6                	mov    %edx,%esi
80100b92:	c1 ee 03             	shr    $0x3,%esi
80100b95:	89 f0                	mov    %esi,%eax
80100b97:	c1 e0 04             	shl    $0x4,%eax
80100b9a:	29 f0                	sub    %esi,%eax
80100b9c:	89 de                	mov    %ebx,%esi
80100b9e:	29 c6                	sub    %eax,%esi
    if(strncmp(cmd, hist.cmd_buf[idx], cmd_size) == 0){
80100ba0:	89 f3                	mov    %esi,%ebx
80100ba2:	c1 e3 07             	shl    $0x7,%ebx
80100ba5:	81 c3 84 0e 11 80    	add    $0x80110e84,%ebx
80100bab:	53                   	push   %ebx
80100bac:	68 10 16 11 80       	push   $0x80111610
80100bb1:	e8 ea 4d 00 00       	call   801059a0 <strncmp>
80100bb6:	83 c4 10             	add    $0x10,%esp
80100bb9:	85 c0                	test   %eax,%eax
80100bbb:	0f 84 47 02 00 00    	je     80100e08 <consoleintr+0x488>
  for(int i = 0; i < HIST_SIZE; ++i){
80100bc1:	83 c7 01             	add    $0x1,%edi
80100bc4:	83 ff 0f             	cmp    $0xf,%edi
80100bc7:	75 af                	jne    80100b78 <consoleintr+0x1f8>
  if(panicked){
80100bc9:	a1 78 17 11 80       	mov    0x80111778,%eax
80100bce:	85 c0                	test   %eax,%eax
80100bd0:	0f 84 ba 02 00 00    	je     80100e90 <consoleintr+0x510>
80100bd6:	fa                   	cli    
    for(;;)
80100bd7:	eb fe                	jmp    80100bd7 <consoleintr+0x257>
80100bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100be0:	a1 28 17 11 80       	mov    0x80111728,%eax
80100be5:	3b 05 24 17 11 80    	cmp    0x80111724,%eax
80100beb:	0f 84 bb fd ff ff    	je     801009ac <consoleintr+0x2c>
        input.e--;
80100bf1:	83 e8 01             	sub    $0x1,%eax
80100bf4:	a3 28 17 11 80       	mov    %eax,0x80111728
  if(panicked){
80100bf9:	a1 78 17 11 80       	mov    0x80111778,%eax
80100bfe:	85 c0                	test   %eax,%eax
80100c00:	0f 84 22 02 00 00    	je     80100e28 <consoleintr+0x4a8>
80100c06:	fa                   	cli    
    for(;;)
80100c07:	eb fe                	jmp    80100c07 <consoleintr+0x287>
80100c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  memmove(cmd, input.buf + input.w, input.e - input.w);
80100c10:	a1 24 17 11 80       	mov    0x80111724,%eax
80100c15:	8b 15 28 17 11 80    	mov    0x80111728,%edx
80100c1b:	83 ec 04             	sub    $0x4,%esp
80100c1e:	8d 9d 68 ff ff ff    	lea    -0x98(%ebp),%ebx
80100c24:	29 c2                	sub    %eax,%edx
80100c26:	05 a0 16 11 80       	add    $0x801116a0,%eax
80100c2b:	52                   	push   %edx
80100c2c:	50                   	push   %eax
80100c2d:	53                   	push   %ebx
80100c2e:	e8 fd 4c 00 00       	call   80105930 <memmove>
  cmd[input.e - input.w] = '\0';
80100c33:	a1 28 17 11 80       	mov    0x80111728,%eax
  while (i < j) {
80100c38:	83 c4 10             	add    $0x10,%esp
  int i = 0, j = len - 1;
80100c3b:	31 c9                	xor    %ecx,%ecx
  cmd[input.e - input.w] = '\0';
80100c3d:	2b 05 24 17 11 80    	sub    0x80111724,%eax
80100c43:	c6 84 05 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%eax,1)
80100c4a:	00 
  int i = 0, j = len - 1;
80100c4b:	83 e8 01             	sub    $0x1,%eax
  while (i < j) {
80100c4e:	85 c0                	test   %eax,%eax
80100c50:	7e 20                	jle    80100c72 <consoleintr+0x2f2>
80100c52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    char tmp = src[i];
80100c58:	0f b6 3c 0b          	movzbl (%ebx,%ecx,1),%edi
    src[i] = src[j];
80100c5c:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
80100c60:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
    src[j] = tmp;
80100c63:	89 fa                	mov    %edi,%edx
    i++;
80100c65:	83 c1 01             	add    $0x1,%ecx
    src[j] = tmp;
80100c68:	88 14 03             	mov    %dl,(%ebx,%eax,1)
    j--;
80100c6b:	83 e8 01             	sub    $0x1,%eax
  while (i < j) {
80100c6e:	39 c1                	cmp    %eax,%ecx
80100c70:	7c e6                	jl     80100c58 <consoleintr+0x2d8>
    consclear();
80100c72:	e8 69 fc ff ff       	call   801008e0 <consclear>
    consputs(hist.cmd_buf[suggested_cmd]);
80100c77:	83 ec 0c             	sub    $0xc,%esp
80100c7a:	53                   	push   %ebx
80100c7b:	e8 00 fc ff ff       	call   80100880 <consputs>
80100c80:	83 c4 10             	add    $0x10,%esp
80100c83:	e9 24 fd ff ff       	jmp    801009ac <consoleintr+0x2c>
80100c88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c8f:	90                   	nop
    switch(c){
80100c90:	c7 85 5c ff ff ff 01 	movl   $0x1,-0xa4(%ebp)
80100c97:	00 00 00 
80100c9a:	e9 0d fd ff ff       	jmp    801009ac <consoleintr+0x2c>
80100c9f:	90                   	nop
        input.buf[input.e++ % INPUT_BUF] = 27;
80100ca0:	a1 28 17 11 80       	mov    0x80111728,%eax
  if(panicked){
80100ca5:	8b 0d 78 17 11 80    	mov    0x80111778,%ecx
        input.buf[input.e++ % INPUT_BUF] = 27;
80100cab:	8d 50 01             	lea    0x1(%eax),%edx
80100cae:	83 e0 7f             	and    $0x7f,%eax
80100cb1:	89 15 28 17 11 80    	mov    %edx,0x80111728
80100cb7:	c6 80 a0 16 11 80 1b 	movb   $0x1b,-0x7feee960(%eax)
  if(panicked){
80100cbe:	85 c9                	test   %ecx,%ecx
80100cc0:	0f 85 5a 01 00 00    	jne    80100e20 <consoleintr+0x4a0>
80100cc6:	b8 1b 00 00 00       	mov    $0x1b,%eax
80100ccb:	e8 30 f7 ff ff       	call   80100400 <consputc.part.0>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100cd0:	85 db                	test   %ebx,%ebx
80100cd2:	0f 84 d4 fc ff ff    	je     801009ac <consoleintr+0x2c>
80100cd8:	a1 28 17 11 80       	mov    0x80111728,%eax
80100cdd:	89 c2                	mov    %eax,%edx
80100cdf:	2b 15 20 17 11 80    	sub    0x80111720,%edx
80100ce5:	83 fa 7f             	cmp    $0x7f,%edx
80100ce8:	0f 87 be fc ff ff    	ja     801009ac <consoleintr+0x2c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100cee:	8d 50 01             	lea    0x1(%eax),%edx
  if(panicked){
80100cf1:	8b 0d 78 17 11 80    	mov    0x80111778,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
80100cf7:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100cfa:	83 fb 0d             	cmp    $0xd,%ebx
80100cfd:	0f 85 04 fd ff ff    	jne    80100a07 <consoleintr+0x87>
        input.buf[input.e++ % INPUT_BUF] = c;
80100d03:	89 15 28 17 11 80    	mov    %edx,0x80111728
80100d09:	c6 80 a0 16 11 80 0a 	movb   $0xa,-0x7feee960(%eax)
  if(panicked){
80100d10:	85 c9                	test   %ecx,%ecx
80100d12:	0f 85 87 01 00 00    	jne    80100e9f <consoleintr+0x51f>
80100d18:	b8 0a 00 00 00       	mov    $0xa,%eax
80100d1d:	e8 de f6 ff ff       	call   80100400 <consputc.part.0>
  if(input.e - input.w == 1)
80100d22:	a1 28 17 11 80       	mov    0x80111728,%eax
80100d27:	89 c2                	mov    %eax,%edx
80100d29:	2b 15 24 17 11 80    	sub    0x80111724,%edx
80100d2f:	83 fa 01             	cmp    $0x1,%edx
80100d32:	0f 84 b2 00 00 00    	je     80100dea <consoleintr+0x46a>
  memset(hist.cmd_buf[hist.queue_idx], 0, INPUT_BUF);
80100d38:	a1 80 0e 11 80       	mov    0x80110e80,%eax
80100d3d:	83 ec 04             	sub    $0x4,%esp
80100d40:	68 80 00 00 00       	push   $0x80
80100d45:	c1 e0 07             	shl    $0x7,%eax
80100d48:	6a 00                	push   $0x0
80100d4a:	05 84 0e 11 80       	add    $0x80110e84,%eax
80100d4f:	50                   	push   %eax
80100d50:	e8 3b 4b 00 00       	call   80105890 <memset>
          input.e - input.w - 1);
80100d55:	a1 24 17 11 80       	mov    0x80111724,%eax
  memmove(hist.cmd_buf[hist.queue_idx],
80100d5a:	83 c4 0c             	add    $0xc,%esp
80100d5d:	89 c2                	mov    %eax,%edx
80100d5f:	05 a0 16 11 80       	add    $0x801116a0,%eax
80100d64:	f7 d2                	not    %edx
80100d66:	03 15 28 17 11 80    	add    0x80111728,%edx
80100d6c:	52                   	push   %edx
80100d6d:	50                   	push   %eax
80100d6e:	a1 80 0e 11 80       	mov    0x80110e80,%eax
80100d73:	c1 e0 07             	shl    $0x7,%eax
80100d76:	05 84 0e 11 80       	add    $0x80110e84,%eax
80100d7b:	50                   	push   %eax
80100d7c:	e8 af 4b 00 00       	call   80105930 <memmove>
  hist.queue_idx = (hist.queue_idx + 1) % HIST_SIZE;
80100d81:	a1 80 0e 11 80       	mov    0x80110e80,%eax
  memset(hist.original_cmd, 0, INPUT_BUF);
80100d86:	83 c4 0c             	add    $0xc,%esp
  hist.is_suggestion_used = 0;
80100d89:	c7 05 0c 16 11 80 00 	movl   $0x0,0x8011160c
80100d90:	00 00 00 
  memset(hist.original_cmd, 0, INPUT_BUF);
80100d93:	68 80 00 00 00       	push   $0x80
  hist.queue_idx = (hist.queue_idx + 1) % HIST_SIZE;
80100d98:	8d 48 01             	lea    0x1(%eax),%ecx
80100d9b:	b8 89 88 88 88       	mov    $0x88888889,%eax
  memset(hist.original_cmd, 0, INPUT_BUF);
80100da0:	6a 00                	push   $0x0
  hist.queue_idx = (hist.queue_idx + 1) % HIST_SIZE;
80100da2:	f7 e1                	mul    %ecx
  memset(hist.original_cmd, 0, INPUT_BUF);
80100da4:	68 10 16 11 80       	push   $0x80111610
  hist.last_used_idx = 0;
80100da9:	c7 05 04 16 11 80 00 	movl   $0x0,0x80111604
80100db0:	00 00 00 
  hist.queue_idx = (hist.queue_idx + 1) % HIST_SIZE;
80100db3:	c1 ea 03             	shr    $0x3,%edx
80100db6:	89 d0                	mov    %edx,%eax
80100db8:	c1 e0 04             	shl    $0x4,%eax
80100dbb:	29 d0                	sub    %edx,%eax
80100dbd:	29 c1                	sub    %eax,%ecx
  hist.total_count++;
80100dbf:	a1 94 16 11 80       	mov    0x80111694,%eax
  hist.queue_idx = (hist.queue_idx + 1) % HIST_SIZE;
80100dc4:	89 0d 80 0e 11 80    	mov    %ecx,0x80110e80
  hist.total_count++;
80100dca:	83 c0 01             	add    $0x1,%eax
  hist.last_arrow_idx = hist.queue_idx;
80100dcd:	89 0d 08 16 11 80    	mov    %ecx,0x80111608
  hist.total_count++;
80100dd3:	a3 94 16 11 80       	mov    %eax,0x80111694
  hist.last_arrow_total = hist.total_count;
80100dd8:	a3 98 16 11 80       	mov    %eax,0x80111698
  memset(hist.original_cmd, 0, INPUT_BUF);
80100ddd:	e8 ae 4a 00 00       	call   80105890 <memset>
          input.w = input.e;
80100de2:	a1 28 17 11 80       	mov    0x80111728,%eax
80100de7:	83 c4 10             	add    $0x10,%esp
          wakeup(&input.r);
80100dea:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100ded:	a3 24 17 11 80       	mov    %eax,0x80111724
          wakeup(&input.r);
80100df2:	68 20 17 11 80       	push   $0x80111720
80100df7:	e8 c4 3d 00 00       	call   80104bc0 <wakeup>
80100dfc:	83 c4 10             	add    $0x10,%esp
80100dff:	e9 a8 fb ff ff       	jmp    801009ac <consoleintr+0x2c>
80100e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hist.is_suggestion_used = 1;
80100e08:	c7 05 0c 16 11 80 01 	movl   $0x1,0x8011160c
80100e0f:	00 00 00 
    hist.last_used_idx = suggested_cmd + 1;
80100e12:	8d 56 01             	lea    0x1(%esi),%edx
80100e15:	89 15 04 16 11 80    	mov    %edx,0x80111604
80100e1b:	e9 52 fe ff ff       	jmp    80100c72 <consoleintr+0x2f2>
80100e20:	fa                   	cli    
    for(;;)
80100e21:	eb fe                	jmp    80100e21 <consoleintr+0x4a1>
80100e23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e27:	90                   	nop
80100e28:	b8 00 01 00 00       	mov    $0x100,%eax
80100e2d:	e8 ce f5 ff ff       	call   80100400 <consputc.part.0>
        hist.is_suggestion_used = 0;
80100e32:	c7 05 0c 16 11 80 00 	movl   $0x0,0x8011160c
80100e39:	00 00 00 
80100e3c:	e9 6b fb ff ff       	jmp    801009ac <consoleintr+0x2c>
80100e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    hist.original_cmd_size = input.e - input.w;
80100e48:	a1 24 17 11 80       	mov    0x80111724,%eax
80100e4d:	8b 15 28 17 11 80    	mov    0x80111728,%edx
    memmove(hist.original_cmd, input.buf + input.w, hist.original_cmd_size);
80100e53:	83 ec 04             	sub    $0x4,%esp
    hist.original_cmd_size = input.e - input.w;
80100e56:	29 c2                	sub    %eax,%edx
    memmove(hist.original_cmd, input.buf + input.w, hist.original_cmd_size);
80100e58:	05 a0 16 11 80       	add    $0x801116a0,%eax
80100e5d:	52                   	push   %edx
80100e5e:	50                   	push   %eax
80100e5f:	68 10 16 11 80       	push   $0x80111610
    hist.original_cmd_size = input.e - input.w;
80100e64:	89 15 90 16 11 80    	mov    %edx,0x80111690
    memmove(hist.original_cmd, input.buf + input.w, hist.original_cmd_size);
80100e6a:	e8 c1 4a 00 00       	call   80105930 <memmove>
80100e6f:	83 c4 10             	add    $0x10,%esp
80100e72:	e9 ee fc ff ff       	jmp    80100b65 <consoleintr+0x1e5>
80100e77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100e7e:	66 90                	xchg   %ax,%ax
}
80100e80:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e83:	5b                   	pop    %ebx
80100e84:	5e                   	pop    %esi
80100e85:	5f                   	pop    %edi
80100e86:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100e87:	e9 44 3e 00 00       	jmp    80104cd0 <procdump>
80100e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e90:	b8 07 00 00 00       	mov    $0x7,%eax
80100e95:	e8 66 f5 ff ff       	call   80100400 <consputc.part.0>
80100e9a:	e9 0d fb ff ff       	jmp    801009ac <consoleintr+0x2c>
80100e9f:	fa                   	cli    
    for(;;)
80100ea0:	eb fe                	jmp    80100ea0 <consoleintr+0x520>
80100ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(hist.last_arrow_total < hist.total_count){
80100ea8:	a1 98 16 11 80       	mov    0x80111698,%eax
80100ead:	3b 05 94 16 11 80    	cmp    0x80111694,%eax
80100eb3:	0f 8d a7 00 00 00    	jge    80100f60 <consoleintr+0x5e0>
    hist.last_arrow_total++;
80100eb9:	83 c0 01             	add    $0x1,%eax
80100ebc:	a3 98 16 11 80       	mov    %eax,0x80111698
    hist.last_arrow_idx = (hist.last_arrow_idx + 1) % HIST_SIZE;
80100ec1:	a1 08 16 11 80       	mov    0x80111608,%eax
80100ec6:	8d 48 01             	lea    0x1(%eax),%ecx
80100ec9:	b8 89 88 88 88       	mov    $0x88888889,%eax
80100ece:	f7 e1                	mul    %ecx
80100ed0:	c1 ea 03             	shr    $0x3,%edx
80100ed3:	89 d0                	mov    %edx,%eax
80100ed5:	c1 e0 04             	shl    $0x4,%eax
80100ed8:	29 d0                	sub    %edx,%eax
80100eda:	29 c1                	sub    %eax,%ecx
80100edc:	89 0d 08 16 11 80    	mov    %ecx,0x80111608
    consclear();
80100ee2:	e8 f9 f9 ff ff       	call   801008e0 <consclear>
    consputs(hist.cmd_buf[hist.last_arrow_idx]);
80100ee7:	a1 08 16 11 80       	mov    0x80111608,%eax
80100eec:	83 ec 0c             	sub    $0xc,%esp
80100eef:	c1 e0 07             	shl    $0x7,%eax
80100ef2:	05 84 0e 11 80       	add    $0x80110e84,%eax
80100ef7:	50                   	push   %eax
80100ef8:	e8 83 f9 ff ff       	call   80100880 <consputs>
80100efd:	83 c4 10             	add    $0x10,%esp
80100f00:	e9 a7 fa ff ff       	jmp    801009ac <consoleintr+0x2c>
80100f05:	b8 1b 00 00 00       	mov    $0x1b,%eax
80100f0a:	e8 f1 f4 ff ff       	call   80100400 <consputc.part.0>
          input.buf[input.e++ % INPUT_BUF] = 91;
80100f0f:	a1 28 17 11 80       	mov    0x80111728,%eax
  if(panicked){
80100f14:	8b 35 78 17 11 80    	mov    0x80111778,%esi
          input.buf[input.e++ % INPUT_BUF] = 91;
80100f1a:	8d 50 01             	lea    0x1(%eax),%edx
80100f1d:	83 e0 7f             	and    $0x7f,%eax
80100f20:	89 15 28 17 11 80    	mov    %edx,0x80111728
80100f26:	c6 80 a0 16 11 80 5b 	movb   $0x5b,-0x7feee960(%eax)
  if(panicked){
80100f2d:	85 f6                	test   %esi,%esi
80100f2f:	74 3f                	je     80100f70 <consoleintr+0x5f0>
80100f31:	fa                   	cli    
    for(;;)
80100f32:	eb fe                	jmp    80100f32 <consoleintr+0x5b2>
80100f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(hist.last_arrow_total > 0 &&
80100f38:	a1 98 16 11 80       	mov    0x80111698,%eax
80100f3d:	85 c0                	test   %eax,%eax
80100f3f:	7e 0d                	jle    80100f4e <consoleintr+0x5ce>
     hist.last_arrow_total > hist.total_count - HIST_SIZE){
80100f41:	8b 3d 94 16 11 80    	mov    0x80111694,%edi
80100f47:	8d 57 f2             	lea    -0xe(%edi),%edx
  if(hist.last_arrow_total > 0 &&
80100f4a:	39 d0                	cmp    %edx,%eax
80100f4c:	7d 31                	jge    80100f7f <consoleintr+0x5ff>
  if(panicked){
80100f4e:	a1 78 17 11 80       	mov    0x80111778,%eax
80100f53:	85 c0                	test   %eax,%eax
80100f55:	0f 84 35 ff ff ff    	je     80100e90 <consoleintr+0x510>
80100f5b:	fa                   	cli    
    for(;;)
80100f5c:	eb fe                	jmp    80100f5c <consoleintr+0x5dc>
80100f5e:	66 90                	xchg   %ax,%ax
  if(panicked){
80100f60:	a1 78 17 11 80       	mov    0x80111778,%eax
80100f65:	85 c0                	test   %eax,%eax
80100f67:	0f 84 23 ff ff ff    	je     80100e90 <consoleintr+0x510>
80100f6d:	fa                   	cli    
    for(;;)
80100f6e:	eb fe                	jmp    80100f6e <consoleintr+0x5ee>
80100f70:	b8 5b 00 00 00       	mov    $0x5b,%eax
80100f75:	e8 86 f4 ff ff       	call   80100400 <consputc.part.0>
80100f7a:	e9 51 fd ff ff       	jmp    80100cd0 <consoleintr+0x350>
    hist.last_arrow_total--;
80100f7f:	83 e8 01             	sub    $0x1,%eax
80100f82:	a3 98 16 11 80       	mov    %eax,0x80111698
    hist.last_arrow_idx = (hist.last_arrow_idx - 1 + HIST_SIZE) % HIST_SIZE;
80100f87:	a1 08 16 11 80       	mov    0x80111608,%eax
80100f8c:	8d 48 0e             	lea    0xe(%eax),%ecx
80100f8f:	b8 89 88 88 88       	mov    $0x88888889,%eax
80100f94:	f7 e1                	mul    %ecx
80100f96:	89 d0                	mov    %edx,%eax
80100f98:	c1 e8 03             	shr    $0x3,%eax
80100f9b:	89 c2                	mov    %eax,%edx
80100f9d:	c1 e2 04             	shl    $0x4,%edx
80100fa0:	29 c2                	sub    %eax,%edx
80100fa2:	29 d1                	sub    %edx,%ecx
80100fa4:	e9 33 ff ff ff       	jmp    80100edc <consoleintr+0x55c>
80100fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100fb0 <consoleinit>:

void
consoleinit(void)
{
80100fb0:	55                   	push   %ebp
80100fb1:	89 e5                	mov    %esp,%ebp
80100fb3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100fb6:	68 88 8a 10 80       	push   $0x80108a88
80100fbb:	68 40 17 11 80       	push   $0x80111740
80100fc0:	e8 3b 46 00 00       	call   80105600 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100fc5:	58                   	pop    %eax
80100fc6:	5a                   	pop    %edx
80100fc7:	6a 00                	push   $0x0
80100fc9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100fcb:	c7 05 2c 21 11 80 90 	movl   $0x80100590,0x8011212c
80100fd2:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100fd5:	c7 05 28 21 11 80 80 	movl   $0x80100280,0x80112128
80100fdc:	02 10 80 
  cons.locking = 1;
80100fdf:	c7 05 74 17 11 80 01 	movl   $0x1,0x80111774
80100fe6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100fe9:	e8 42 1b 00 00       	call   80102b30 <ioapicenable>
}
80100fee:	83 c4 10             	add    $0x10,%esp
80100ff1:	c9                   	leave  
80100ff2:	c3                   	ret    
80100ff3:	66 90                	xchg   %ax,%ax
80100ff5:	66 90                	xchg   %ax,%ax
80100ff7:	66 90                	xchg   %ax,%ax
80100ff9:	66 90                	xchg   %ax,%ax
80100ffb:	66 90                	xchg   %ax,%ax
80100ffd:	66 90                	xchg   %ax,%ax
80100fff:	90                   	nop

80101000 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80101000:	55                   	push   %ebp
80101001:	89 e5                	mov    %esp,%ebp
80101003:	57                   	push   %edi
80101004:	56                   	push   %esi
80101005:	53                   	push   %ebx
80101006:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
8010100c:	e8 7f 30 00 00       	call   80104090 <myproc>
80101011:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80101017:	e8 f4 23 00 00       	call   80103410 <begin_op>

  if((ip = namei(path)) == 0){
8010101c:	83 ec 0c             	sub    $0xc,%esp
8010101f:	ff 75 08             	push   0x8(%ebp)
80101022:	e8 29 17 00 00       	call   80102750 <namei>
80101027:	83 c4 10             	add    $0x10,%esp
8010102a:	85 c0                	test   %eax,%eax
8010102c:	0f 84 02 03 00 00    	je     80101334 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80101032:	83 ec 0c             	sub    $0xc,%esp
80101035:	89 c3                	mov    %eax,%ebx
80101037:	50                   	push   %eax
80101038:	e8 13 0d 00 00       	call   80101d50 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
8010103d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80101043:	6a 34                	push   $0x34
80101045:	6a 00                	push   $0x0
80101047:	50                   	push   %eax
80101048:	53                   	push   %ebx
80101049:	e8 12 10 00 00       	call   80102060 <readi>
8010104e:	83 c4 20             	add    $0x20,%esp
80101051:	83 f8 34             	cmp    $0x34,%eax
80101054:	74 22                	je     80101078 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80101056:	83 ec 0c             	sub    $0xc,%esp
80101059:	53                   	push   %ebx
8010105a:	e8 81 0f 00 00       	call   80101fe0 <iunlockput>
    end_op();
8010105f:	e8 1c 24 00 00       	call   80103480 <end_op>
80101064:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80101067:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010106c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010106f:	5b                   	pop    %ebx
80101070:	5e                   	pop    %esi
80101071:	5f                   	pop    %edi
80101072:	5d                   	pop    %ebp
80101073:	c3                   	ret    
80101074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80101078:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
8010107f:	45 4c 46 
80101082:	75 d2                	jne    80101056 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80101084:	e8 27 75 00 00       	call   801085b0 <setupkvm>
80101089:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
8010108f:	85 c0                	test   %eax,%eax
80101091:	74 c3                	je     80101056 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101093:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
8010109a:	00 
8010109b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
801010a1:	0f 84 ac 02 00 00    	je     80101353 <exec+0x353>
  sz = 0;
801010a7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
801010ae:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801010b1:	31 ff                	xor    %edi,%edi
801010b3:	e9 8e 00 00 00       	jmp    80101146 <exec+0x146>
801010b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010bf:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
801010c0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
801010c7:	75 6c                	jne    80101135 <exec+0x135>
    if(ph.memsz < ph.filesz)
801010c9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
801010cf:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
801010d5:	0f 82 87 00 00 00    	jb     80101162 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
801010db:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
801010e1:	72 7f                	jb     80101162 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
801010e3:	83 ec 04             	sub    $0x4,%esp
801010e6:	50                   	push   %eax
801010e7:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
801010ed:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801010f3:	e8 d8 72 00 00       	call   801083d0 <allocuvm>
801010f8:	83 c4 10             	add    $0x10,%esp
801010fb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101101:	85 c0                	test   %eax,%eax
80101103:	74 5d                	je     80101162 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80101105:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
8010110b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80101110:	75 50                	jne    80101162 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80101112:	83 ec 0c             	sub    $0xc,%esp
80101115:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
8010111b:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80101121:	53                   	push   %ebx
80101122:	50                   	push   %eax
80101123:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101129:	e8 b2 71 00 00       	call   801082e0 <loaduvm>
8010112e:	83 c4 20             	add    $0x20,%esp
80101131:	85 c0                	test   %eax,%eax
80101133:	78 2d                	js     80101162 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101135:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
8010113c:	83 c7 01             	add    $0x1,%edi
8010113f:	83 c6 20             	add    $0x20,%esi
80101142:	39 f8                	cmp    %edi,%eax
80101144:	7e 3a                	jle    80101180 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80101146:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
8010114c:	6a 20                	push   $0x20
8010114e:	56                   	push   %esi
8010114f:	50                   	push   %eax
80101150:	53                   	push   %ebx
80101151:	e8 0a 0f 00 00       	call   80102060 <readi>
80101156:	83 c4 10             	add    $0x10,%esp
80101159:	83 f8 20             	cmp    $0x20,%eax
8010115c:	0f 84 5e ff ff ff    	je     801010c0 <exec+0xc0>
    freevm(pgdir);
80101162:	83 ec 0c             	sub    $0xc,%esp
80101165:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
8010116b:	e8 c0 73 00 00       	call   80108530 <freevm>
  if(ip){
80101170:	83 c4 10             	add    $0x10,%esp
80101173:	e9 de fe ff ff       	jmp    80101056 <exec+0x56>
80101178:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010117f:	90                   	nop
  sz = PGROUNDUP(sz);
80101180:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80101186:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
8010118c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101192:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80101198:	83 ec 0c             	sub    $0xc,%esp
8010119b:	53                   	push   %ebx
8010119c:	e8 3f 0e 00 00       	call   80101fe0 <iunlockput>
  end_op();
801011a1:	e8 da 22 00 00       	call   80103480 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
801011a6:	83 c4 0c             	add    $0xc,%esp
801011a9:	56                   	push   %esi
801011aa:	57                   	push   %edi
801011ab:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
801011b1:	57                   	push   %edi
801011b2:	e8 19 72 00 00       	call   801083d0 <allocuvm>
801011b7:	83 c4 10             	add    $0x10,%esp
801011ba:	89 c6                	mov    %eax,%esi
801011bc:	85 c0                	test   %eax,%eax
801011be:	0f 84 94 00 00 00    	je     80101258 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
801011c4:	83 ec 08             	sub    $0x8,%esp
801011c7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
801011cd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
801011cf:	50                   	push   %eax
801011d0:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
801011d1:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
801011d3:	e8 78 74 00 00       	call   80108650 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
801011d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801011db:	83 c4 10             	add    $0x10,%esp
801011de:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
801011e4:	8b 00                	mov    (%eax),%eax
801011e6:	85 c0                	test   %eax,%eax
801011e8:	0f 84 8b 00 00 00    	je     80101279 <exec+0x279>
801011ee:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
801011f4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
801011fa:	eb 23                	jmp    8010121f <exec+0x21f>
801011fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101200:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80101203:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
8010120a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
8010120d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80101213:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80101216:	85 c0                	test   %eax,%eax
80101218:	74 59                	je     80101273 <exec+0x273>
    if(argc >= MAXARG)
8010121a:	83 ff 20             	cmp    $0x20,%edi
8010121d:	74 39                	je     80101258 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010121f:	83 ec 0c             	sub    $0xc,%esp
80101222:	50                   	push   %eax
80101223:	e8 68 48 00 00       	call   80105a90 <strlen>
80101228:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010122a:	58                   	pop    %eax
8010122b:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010122e:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101231:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101234:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101237:	e8 54 48 00 00       	call   80105a90 <strlen>
8010123c:	83 c0 01             	add    $0x1,%eax
8010123f:	50                   	push   %eax
80101240:	8b 45 0c             	mov    0xc(%ebp),%eax
80101243:	ff 34 b8             	push   (%eax,%edi,4)
80101246:	53                   	push   %ebx
80101247:	56                   	push   %esi
80101248:	e8 d3 75 00 00       	call   80108820 <copyout>
8010124d:	83 c4 20             	add    $0x20,%esp
80101250:	85 c0                	test   %eax,%eax
80101252:	79 ac                	jns    80101200 <exec+0x200>
80101254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80101258:	83 ec 0c             	sub    $0xc,%esp
8010125b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101261:	e8 ca 72 00 00       	call   80108530 <freevm>
80101266:	83 c4 10             	add    $0x10,%esp
  return -1;
80101269:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010126e:	e9 f9 fd ff ff       	jmp    8010106c <exec+0x6c>
80101273:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101279:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80101280:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80101282:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80101289:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010128d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
8010128f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80101292:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80101298:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
8010129a:	50                   	push   %eax
8010129b:	52                   	push   %edx
8010129c:	53                   	push   %ebx
8010129d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
801012a3:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
801012aa:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801012ad:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801012b3:	e8 68 75 00 00       	call   80108820 <copyout>
801012b8:	83 c4 10             	add    $0x10,%esp
801012bb:	85 c0                	test   %eax,%eax
801012bd:	78 99                	js     80101258 <exec+0x258>
  for(last=s=path; *s; s++)
801012bf:	8b 45 08             	mov    0x8(%ebp),%eax
801012c2:	8b 55 08             	mov    0x8(%ebp),%edx
801012c5:	0f b6 00             	movzbl (%eax),%eax
801012c8:	84 c0                	test   %al,%al
801012ca:	74 13                	je     801012df <exec+0x2df>
801012cc:	89 d1                	mov    %edx,%ecx
801012ce:	66 90                	xchg   %ax,%ax
      last = s+1;
801012d0:	83 c1 01             	add    $0x1,%ecx
801012d3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
801012d5:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
801012d8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
801012db:	84 c0                	test   %al,%al
801012dd:	75 f1                	jne    801012d0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
801012df:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
801012e5:	83 ec 04             	sub    $0x4,%esp
801012e8:	6a 10                	push   $0x10
801012ea:	89 f8                	mov    %edi,%eax
801012ec:	52                   	push   %edx
801012ed:	83 c0 6c             	add    $0x6c,%eax
801012f0:	50                   	push   %eax
801012f1:	e8 5a 47 00 00       	call   80105a50 <safestrcpy>
  curproc->pgdir = pgdir;
801012f6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
801012fc:	89 f8                	mov    %edi,%eax
801012fe:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80101301:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80101303:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80101306:	89 c1                	mov    %eax,%ecx
80101308:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
8010130e:	8b 40 18             	mov    0x18(%eax),%eax
80101311:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80101314:	8b 41 18             	mov    0x18(%ecx),%eax
80101317:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
8010131a:	89 0c 24             	mov    %ecx,(%esp)
8010131d:	e8 2e 6e 00 00       	call   80108150 <switchuvm>
  freevm(oldpgdir);
80101322:	89 3c 24             	mov    %edi,(%esp)
80101325:	e8 06 72 00 00       	call   80108530 <freevm>
  return 0;
8010132a:	83 c4 10             	add    $0x10,%esp
8010132d:	31 c0                	xor    %eax,%eax
8010132f:	e9 38 fd ff ff       	jmp    8010106c <exec+0x6c>
    end_op();
80101334:	e8 47 21 00 00       	call   80103480 <end_op>
    cprintf("exec: fail\n");
80101339:	83 ec 0c             	sub    $0xc,%esp
8010133c:	68 f1 8a 10 80       	push   $0x80108af1
80101341:	e8 5a f3 ff ff       	call   801006a0 <cprintf>
    return -1;
80101346:	83 c4 10             	add    $0x10,%esp
80101349:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010134e:	e9 19 fd ff ff       	jmp    8010106c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101353:	be 00 20 00 00       	mov    $0x2000,%esi
80101358:	31 ff                	xor    %edi,%edi
8010135a:	e9 39 fe ff ff       	jmp    80101198 <exec+0x198>
8010135f:	90                   	nop

80101360 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80101366:	68 fd 8a 10 80       	push   $0x80108afd
8010136b:	68 80 17 11 80       	push   $0x80111780
80101370:	e8 8b 42 00 00       	call   80105600 <initlock>
}
80101375:	83 c4 10             	add    $0x10,%esp
80101378:	c9                   	leave  
80101379:	c3                   	ret    
8010137a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101380 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101380:	55                   	push   %ebp
80101381:	89 e5                	mov    %esp,%ebp
80101383:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101384:	bb b4 17 11 80       	mov    $0x801117b4,%ebx
{
80101389:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
8010138c:	68 80 17 11 80       	push   $0x80111780
80101391:	e8 3a 44 00 00       	call   801057d0 <acquire>
80101396:	83 c4 10             	add    $0x10,%esp
80101399:	eb 10                	jmp    801013ab <filealloc+0x2b>
8010139b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010139f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801013a0:	83 c3 18             	add    $0x18,%ebx
801013a3:	81 fb 14 21 11 80    	cmp    $0x80112114,%ebx
801013a9:	74 25                	je     801013d0 <filealloc+0x50>
    if(f->ref == 0){
801013ab:	8b 43 04             	mov    0x4(%ebx),%eax
801013ae:	85 c0                	test   %eax,%eax
801013b0:	75 ee                	jne    801013a0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
801013b2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
801013b5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
801013bc:	68 80 17 11 80       	push   $0x80111780
801013c1:	e8 aa 43 00 00       	call   80105770 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
801013c6:	89 d8                	mov    %ebx,%eax
      return f;
801013c8:	83 c4 10             	add    $0x10,%esp
}
801013cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013ce:	c9                   	leave  
801013cf:	c3                   	ret    
  release(&ftable.lock);
801013d0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801013d3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
801013d5:	68 80 17 11 80       	push   $0x80111780
801013da:	e8 91 43 00 00       	call   80105770 <release>
}
801013df:	89 d8                	mov    %ebx,%eax
  return 0;
801013e1:	83 c4 10             	add    $0x10,%esp
}
801013e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013e7:	c9                   	leave  
801013e8:	c3                   	ret    
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801013f0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801013f0:	55                   	push   %ebp
801013f1:	89 e5                	mov    %esp,%ebp
801013f3:	53                   	push   %ebx
801013f4:	83 ec 10             	sub    $0x10,%esp
801013f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
801013fa:	68 80 17 11 80       	push   $0x80111780
801013ff:	e8 cc 43 00 00       	call   801057d0 <acquire>
  if(f->ref < 1)
80101404:	8b 43 04             	mov    0x4(%ebx),%eax
80101407:	83 c4 10             	add    $0x10,%esp
8010140a:	85 c0                	test   %eax,%eax
8010140c:	7e 1a                	jle    80101428 <filedup+0x38>
    panic("filedup");
  f->ref++;
8010140e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101411:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101414:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80101417:	68 80 17 11 80       	push   $0x80111780
8010141c:	e8 4f 43 00 00       	call   80105770 <release>
  return f;
}
80101421:	89 d8                	mov    %ebx,%eax
80101423:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101426:	c9                   	leave  
80101427:	c3                   	ret    
    panic("filedup");
80101428:	83 ec 0c             	sub    $0xc,%esp
8010142b:	68 04 8b 10 80       	push   $0x80108b04
80101430:	e8 4b ef ff ff       	call   80100380 <panic>
80101435:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010143c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101440 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	57                   	push   %edi
80101444:	56                   	push   %esi
80101445:	53                   	push   %ebx
80101446:	83 ec 28             	sub    $0x28,%esp
80101449:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010144c:	68 80 17 11 80       	push   $0x80111780
80101451:	e8 7a 43 00 00       	call   801057d0 <acquire>
  if(f->ref < 1)
80101456:	8b 53 04             	mov    0x4(%ebx),%edx
80101459:	83 c4 10             	add    $0x10,%esp
8010145c:	85 d2                	test   %edx,%edx
8010145e:	0f 8e a5 00 00 00    	jle    80101509 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101464:	83 ea 01             	sub    $0x1,%edx
80101467:	89 53 04             	mov    %edx,0x4(%ebx)
8010146a:	75 44                	jne    801014b0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
8010146c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101470:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101473:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101475:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010147b:	8b 73 0c             	mov    0xc(%ebx),%esi
8010147e:	88 45 e7             	mov    %al,-0x19(%ebp)
80101481:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101484:	68 80 17 11 80       	push   $0x80111780
  ff = *f;
80101489:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
8010148c:	e8 df 42 00 00       	call   80105770 <release>

  if(ff.type == FD_PIPE)
80101491:	83 c4 10             	add    $0x10,%esp
80101494:	83 ff 01             	cmp    $0x1,%edi
80101497:	74 57                	je     801014f0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80101499:	83 ff 02             	cmp    $0x2,%edi
8010149c:	74 2a                	je     801014c8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010149e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a1:	5b                   	pop    %ebx
801014a2:	5e                   	pop    %esi
801014a3:	5f                   	pop    %edi
801014a4:	5d                   	pop    %ebp
801014a5:	c3                   	ret    
801014a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014ad:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
801014b0:	c7 45 08 80 17 11 80 	movl   $0x80111780,0x8(%ebp)
}
801014b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014ba:	5b                   	pop    %ebx
801014bb:	5e                   	pop    %esi
801014bc:	5f                   	pop    %edi
801014bd:	5d                   	pop    %ebp
    release(&ftable.lock);
801014be:	e9 ad 42 00 00       	jmp    80105770 <release>
801014c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801014c7:	90                   	nop
    begin_op();
801014c8:	e8 43 1f 00 00       	call   80103410 <begin_op>
    iput(ff.ip);
801014cd:	83 ec 0c             	sub    $0xc,%esp
801014d0:	ff 75 e0             	push   -0x20(%ebp)
801014d3:	e8 a8 09 00 00       	call   80101e80 <iput>
    end_op();
801014d8:	83 c4 10             	add    $0x10,%esp
}
801014db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014de:	5b                   	pop    %ebx
801014df:	5e                   	pop    %esi
801014e0:	5f                   	pop    %edi
801014e1:	5d                   	pop    %ebp
    end_op();
801014e2:	e9 99 1f 00 00       	jmp    80103480 <end_op>
801014e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014ee:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
801014f0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801014f4:	83 ec 08             	sub    $0x8,%esp
801014f7:	53                   	push   %ebx
801014f8:	56                   	push   %esi
801014f9:	e8 e2 26 00 00       	call   80103be0 <pipeclose>
801014fe:	83 c4 10             	add    $0x10,%esp
}
80101501:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101504:	5b                   	pop    %ebx
80101505:	5e                   	pop    %esi
80101506:	5f                   	pop    %edi
80101507:	5d                   	pop    %ebp
80101508:	c3                   	ret    
    panic("fileclose");
80101509:	83 ec 0c             	sub    $0xc,%esp
8010150c:	68 0c 8b 10 80       	push   $0x80108b0c
80101511:	e8 6a ee ff ff       	call   80100380 <panic>
80101516:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010151d:	8d 76 00             	lea    0x0(%esi),%esi

80101520 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	53                   	push   %ebx
80101524:	83 ec 04             	sub    $0x4,%esp
80101527:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010152a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010152d:	75 31                	jne    80101560 <filestat+0x40>
    ilock(f->ip);
8010152f:	83 ec 0c             	sub    $0xc,%esp
80101532:	ff 73 10             	push   0x10(%ebx)
80101535:	e8 16 08 00 00       	call   80101d50 <ilock>
    stati(f->ip, st);
8010153a:	58                   	pop    %eax
8010153b:	5a                   	pop    %edx
8010153c:	ff 75 0c             	push   0xc(%ebp)
8010153f:	ff 73 10             	push   0x10(%ebx)
80101542:	e8 e9 0a 00 00       	call   80102030 <stati>
    iunlock(f->ip);
80101547:	59                   	pop    %ecx
80101548:	ff 73 10             	push   0x10(%ebx)
8010154b:	e8 e0 08 00 00       	call   80101e30 <iunlock>
    return 0;
  }
  return -1;
}
80101550:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101553:	83 c4 10             	add    $0x10,%esp
80101556:	31 c0                	xor    %eax,%eax
}
80101558:	c9                   	leave  
80101559:	c3                   	ret    
8010155a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101560:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101563:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101568:	c9                   	leave  
80101569:	c3                   	ret    
8010156a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101570 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101570:	55                   	push   %ebp
80101571:	89 e5                	mov    %esp,%ebp
80101573:	57                   	push   %edi
80101574:	56                   	push   %esi
80101575:	53                   	push   %ebx
80101576:	83 ec 0c             	sub    $0xc,%esp
80101579:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010157c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010157f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101582:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101586:	74 60                	je     801015e8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101588:	8b 03                	mov    (%ebx),%eax
8010158a:	83 f8 01             	cmp    $0x1,%eax
8010158d:	74 41                	je     801015d0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010158f:	83 f8 02             	cmp    $0x2,%eax
80101592:	75 5b                	jne    801015ef <fileread+0x7f>
    ilock(f->ip);
80101594:	83 ec 0c             	sub    $0xc,%esp
80101597:	ff 73 10             	push   0x10(%ebx)
8010159a:	e8 b1 07 00 00       	call   80101d50 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010159f:	57                   	push   %edi
801015a0:	ff 73 14             	push   0x14(%ebx)
801015a3:	56                   	push   %esi
801015a4:	ff 73 10             	push   0x10(%ebx)
801015a7:	e8 b4 0a 00 00       	call   80102060 <readi>
801015ac:	83 c4 20             	add    $0x20,%esp
801015af:	89 c6                	mov    %eax,%esi
801015b1:	85 c0                	test   %eax,%eax
801015b3:	7e 03                	jle    801015b8 <fileread+0x48>
      f->off += r;
801015b5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801015b8:	83 ec 0c             	sub    $0xc,%esp
801015bb:	ff 73 10             	push   0x10(%ebx)
801015be:	e8 6d 08 00 00       	call   80101e30 <iunlock>
    return r;
801015c3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801015c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015c9:	89 f0                	mov    %esi,%eax
801015cb:	5b                   	pop    %ebx
801015cc:	5e                   	pop    %esi
801015cd:	5f                   	pop    %edi
801015ce:	5d                   	pop    %ebp
801015cf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
801015d0:	8b 43 0c             	mov    0xc(%ebx),%eax
801015d3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801015d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015d9:	5b                   	pop    %ebx
801015da:	5e                   	pop    %esi
801015db:	5f                   	pop    %edi
801015dc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801015dd:	e9 9e 27 00 00       	jmp    80103d80 <piperead>
801015e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801015e8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801015ed:	eb d7                	jmp    801015c6 <fileread+0x56>
  panic("fileread");
801015ef:	83 ec 0c             	sub    $0xc,%esp
801015f2:	68 16 8b 10 80       	push   $0x80108b16
801015f7:	e8 84 ed ff ff       	call   80100380 <panic>
801015fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101600 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101600:	55                   	push   %ebp
80101601:	89 e5                	mov    %esp,%ebp
80101603:	57                   	push   %edi
80101604:	56                   	push   %esi
80101605:	53                   	push   %ebx
80101606:	83 ec 1c             	sub    $0x1c,%esp
80101609:	8b 45 0c             	mov    0xc(%ebp),%eax
8010160c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010160f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101612:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101615:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101619:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010161c:	0f 84 bd 00 00 00    	je     801016df <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
80101622:	8b 03                	mov    (%ebx),%eax
80101624:	83 f8 01             	cmp    $0x1,%eax
80101627:	0f 84 bf 00 00 00    	je     801016ec <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010162d:	83 f8 02             	cmp    $0x2,%eax
80101630:	0f 85 c8 00 00 00    	jne    801016fe <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101636:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101639:	31 f6                	xor    %esi,%esi
    while(i < n){
8010163b:	85 c0                	test   %eax,%eax
8010163d:	7f 30                	jg     8010166f <filewrite+0x6f>
8010163f:	e9 94 00 00 00       	jmp    801016d8 <filewrite+0xd8>
80101644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101648:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010164b:	83 ec 0c             	sub    $0xc,%esp
8010164e:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101651:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101654:	e8 d7 07 00 00       	call   80101e30 <iunlock>
      end_op();
80101659:	e8 22 1e 00 00       	call   80103480 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010165e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101661:	83 c4 10             	add    $0x10,%esp
80101664:	39 c7                	cmp    %eax,%edi
80101666:	75 5c                	jne    801016c4 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101668:	01 fe                	add    %edi,%esi
    while(i < n){
8010166a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010166d:	7e 69                	jle    801016d8 <filewrite+0xd8>
      int n1 = n - i;
8010166f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101672:	b8 00 06 00 00       	mov    $0x600,%eax
80101677:	29 f7                	sub    %esi,%edi
80101679:	39 c7                	cmp    %eax,%edi
8010167b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010167e:	e8 8d 1d 00 00       	call   80103410 <begin_op>
      ilock(f->ip);
80101683:	83 ec 0c             	sub    $0xc,%esp
80101686:	ff 73 10             	push   0x10(%ebx)
80101689:	e8 c2 06 00 00       	call   80101d50 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010168e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101691:	57                   	push   %edi
80101692:	ff 73 14             	push   0x14(%ebx)
80101695:	01 f0                	add    %esi,%eax
80101697:	50                   	push   %eax
80101698:	ff 73 10             	push   0x10(%ebx)
8010169b:	e8 c0 0a 00 00       	call   80102160 <writei>
801016a0:	83 c4 20             	add    $0x20,%esp
801016a3:	85 c0                	test   %eax,%eax
801016a5:	7f a1                	jg     80101648 <filewrite+0x48>
      iunlock(f->ip);
801016a7:	83 ec 0c             	sub    $0xc,%esp
801016aa:	ff 73 10             	push   0x10(%ebx)
801016ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801016b0:	e8 7b 07 00 00       	call   80101e30 <iunlock>
      end_op();
801016b5:	e8 c6 1d 00 00       	call   80103480 <end_op>
      if(r < 0)
801016ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801016bd:	83 c4 10             	add    $0x10,%esp
801016c0:	85 c0                	test   %eax,%eax
801016c2:	75 1b                	jne    801016df <filewrite+0xdf>
        panic("short filewrite");
801016c4:	83 ec 0c             	sub    $0xc,%esp
801016c7:	68 1f 8b 10 80       	push   $0x80108b1f
801016cc:	e8 af ec ff ff       	call   80100380 <panic>
801016d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801016d8:	89 f0                	mov    %esi,%eax
801016da:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
801016dd:	74 05                	je     801016e4 <filewrite+0xe4>
801016df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801016e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016e7:	5b                   	pop    %ebx
801016e8:	5e                   	pop    %esi
801016e9:	5f                   	pop    %edi
801016ea:	5d                   	pop    %ebp
801016eb:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801016ec:	8b 43 0c             	mov    0xc(%ebx),%eax
801016ef:	89 45 08             	mov    %eax,0x8(%ebp)
}
801016f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016f5:	5b                   	pop    %ebx
801016f6:	5e                   	pop    %esi
801016f7:	5f                   	pop    %edi
801016f8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801016f9:	e9 82 25 00 00       	jmp    80103c80 <pipewrite>
  panic("filewrite");
801016fe:	83 ec 0c             	sub    $0xc,%esp
80101701:	68 25 8b 10 80       	push   $0x80108b25
80101706:	e8 75 ec ff ff       	call   80100380 <panic>
8010170b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010170f:	90                   	nop

80101710 <filechangesize>:

int
filechangesize(struct file *f, int n)
{
80101710:	55                   	push   %ebp
80101711:	89 e5                	mov    %esp,%ebp
80101713:	56                   	push   %esi
80101714:	53                   	push   %ebx
80101715:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;

  if(f->writable == 0)
80101718:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
8010171c:	74 52                	je     80101770 <filechangesize+0x60>
    return -1;
  if(f->type == FD_INODE){
8010171e:	83 3b 02             	cmpl   $0x2,(%ebx)
80101721:	75 54                	jne    80101777 <filechangesize+0x67>
    begin_op();
80101723:	e8 e8 1c 00 00       	call   80103410 <begin_op>
    ilock(f->ip);
80101728:	83 ec 0c             	sub    $0xc,%esp
8010172b:	ff 73 10             	push   0x10(%ebx)
8010172e:	e8 1d 06 00 00       	call   80101d50 <ilock>
    if ((r = changesize(f->ip, n)) > 0)
80101733:	58                   	pop    %eax
80101734:	5a                   	pop    %edx
80101735:	ff 75 0c             	push   0xc(%ebp)
80101738:	ff 73 10             	push   0x10(%ebx)
8010173b:	e8 50 0b 00 00       	call   80102290 <changesize>
80101740:	83 c4 10             	add    $0x10,%esp
80101743:	89 c6                	mov    %eax,%esi
80101745:	85 c0                	test   %eax,%eax
80101747:	7e 03                	jle    8010174c <filechangesize+0x3c>
      f->off = r;
80101749:	89 43 14             	mov    %eax,0x14(%ebx)
    iunlock(f->ip);
8010174c:	83 ec 0c             	sub    $0xc,%esp
8010174f:	ff 73 10             	push   0x10(%ebx)
80101752:	e8 d9 06 00 00       	call   80101e30 <iunlock>
    end_op();
80101757:	e8 24 1d 00 00       	call   80103480 <end_op>
    return r;
8010175c:	83 c4 10             	add    $0x10,%esp
  }
  panic("filechangesize");
}
8010175f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101762:	89 f0                	mov    %esi,%eax
80101764:	5b                   	pop    %ebx
80101765:	5e                   	pop    %esi
80101766:	5d                   	pop    %ebp
80101767:	c3                   	ret    
80101768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010176f:	90                   	nop
    return -1;
80101770:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101775:	eb e8                	jmp    8010175f <filechangesize+0x4f>
  panic("filechangesize");
80101777:	83 ec 0c             	sub    $0xc,%esp
8010177a:	68 2f 8b 10 80       	push   $0x80108b2f
8010177f:	e8 fc eb ff ff       	call   80100380 <panic>
80101784:	66 90                	xchg   %ax,%ax
80101786:	66 90                	xchg   %ax,%ax
80101788:	66 90                	xchg   %ax,%ax
8010178a:	66 90                	xchg   %ax,%ax
8010178c:	66 90                	xchg   %ax,%ax
8010178e:	66 90                	xchg   %ax,%ax

80101790 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101790:	55                   	push   %ebp
80101791:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101793:	89 d0                	mov    %edx,%eax
80101795:	c1 e8 0c             	shr    $0xc,%eax
80101798:	03 05 ec 3d 11 80    	add    0x80113dec,%eax
{
8010179e:	89 e5                	mov    %esp,%ebp
801017a0:	56                   	push   %esi
801017a1:	53                   	push   %ebx
801017a2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801017a4:	83 ec 08             	sub    $0x8,%esp
801017a7:	50                   	push   %eax
801017a8:	51                   	push   %ecx
801017a9:	e8 22 e9 ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801017ae:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801017b0:	c1 fb 03             	sar    $0x3,%ebx
801017b3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801017b6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801017b8:	83 e1 07             	and    $0x7,%ecx
801017bb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801017c0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801017c6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801017c8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801017cd:	85 c1                	test   %eax,%ecx
801017cf:	74 23                	je     801017f4 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801017d1:	f7 d0                	not    %eax
  log_write(bp);
801017d3:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801017d6:	21 c8                	and    %ecx,%eax
801017d8:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
801017dc:	56                   	push   %esi
801017dd:	e8 0e 1e 00 00       	call   801035f0 <log_write>
  brelse(bp);
801017e2:	89 34 24             	mov    %esi,(%esp)
801017e5:	e8 06 ea ff ff       	call   801001f0 <brelse>
}
801017ea:	83 c4 10             	add    $0x10,%esp
801017ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017f0:	5b                   	pop    %ebx
801017f1:	5e                   	pop    %esi
801017f2:	5d                   	pop    %ebp
801017f3:	c3                   	ret    
    panic("freeing free block");
801017f4:	83 ec 0c             	sub    $0xc,%esp
801017f7:	68 3e 8b 10 80       	push   $0x80108b3e
801017fc:	e8 7f eb ff ff       	call   80100380 <panic>
80101801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101808:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010180f:	90                   	nop

80101810 <balloc>:
{
80101810:	55                   	push   %ebp
80101811:	89 e5                	mov    %esp,%ebp
80101813:	57                   	push   %edi
80101814:	56                   	push   %esi
80101815:	53                   	push   %ebx
80101816:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101819:	8b 0d d4 3d 11 80    	mov    0x80113dd4,%ecx
{
8010181f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101822:	85 c9                	test   %ecx,%ecx
80101824:	0f 84 87 00 00 00    	je     801018b1 <balloc+0xa1>
8010182a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101831:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101834:	83 ec 08             	sub    $0x8,%esp
80101837:	89 f0                	mov    %esi,%eax
80101839:	c1 f8 0c             	sar    $0xc,%eax
8010183c:	03 05 ec 3d 11 80    	add    0x80113dec,%eax
80101842:	50                   	push   %eax
80101843:	ff 75 d8             	push   -0x28(%ebp)
80101846:	e8 85 e8 ff ff       	call   801000d0 <bread>
8010184b:	83 c4 10             	add    $0x10,%esp
8010184e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101851:	a1 d4 3d 11 80       	mov    0x80113dd4,%eax
80101856:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101859:	31 c0                	xor    %eax,%eax
8010185b:	eb 2f                	jmp    8010188c <balloc+0x7c>
8010185d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101860:	89 c1                	mov    %eax,%ecx
80101862:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101867:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010186a:	83 e1 07             	and    $0x7,%ecx
8010186d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010186f:	89 c1                	mov    %eax,%ecx
80101871:	c1 f9 03             	sar    $0x3,%ecx
80101874:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101879:	89 fa                	mov    %edi,%edx
8010187b:	85 df                	test   %ebx,%edi
8010187d:	74 41                	je     801018c0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010187f:	83 c0 01             	add    $0x1,%eax
80101882:	83 c6 01             	add    $0x1,%esi
80101885:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010188a:	74 05                	je     80101891 <balloc+0x81>
8010188c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010188f:	77 cf                	ja     80101860 <balloc+0x50>
    brelse(bp);
80101891:	83 ec 0c             	sub    $0xc,%esp
80101894:	ff 75 e4             	push   -0x1c(%ebp)
80101897:	e8 54 e9 ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010189c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801018a3:	83 c4 10             	add    $0x10,%esp
801018a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801018a9:	39 05 d4 3d 11 80    	cmp    %eax,0x80113dd4
801018af:	77 80                	ja     80101831 <balloc+0x21>
  panic("balloc: out of blocks");
801018b1:	83 ec 0c             	sub    $0xc,%esp
801018b4:	68 51 8b 10 80       	push   $0x80108b51
801018b9:	e8 c2 ea ff ff       	call   80100380 <panic>
801018be:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801018c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801018c3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801018c6:	09 da                	or     %ebx,%edx
801018c8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801018cc:	57                   	push   %edi
801018cd:	e8 1e 1d 00 00       	call   801035f0 <log_write>
        brelse(bp);
801018d2:	89 3c 24             	mov    %edi,(%esp)
801018d5:	e8 16 e9 ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801018da:	58                   	pop    %eax
801018db:	5a                   	pop    %edx
801018dc:	56                   	push   %esi
801018dd:	ff 75 d8             	push   -0x28(%ebp)
801018e0:	e8 eb e7 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801018e5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801018e8:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801018ea:	8d 40 5c             	lea    0x5c(%eax),%eax
801018ed:	68 00 02 00 00       	push   $0x200
801018f2:	6a 00                	push   $0x0
801018f4:	50                   	push   %eax
801018f5:	e8 96 3f 00 00       	call   80105890 <memset>
  log_write(bp);
801018fa:	89 1c 24             	mov    %ebx,(%esp)
801018fd:	e8 ee 1c 00 00       	call   801035f0 <log_write>
  brelse(bp);
80101902:	89 1c 24             	mov    %ebx,(%esp)
80101905:	e8 e6 e8 ff ff       	call   801001f0 <brelse>
}
8010190a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010190d:	89 f0                	mov    %esi,%eax
8010190f:	5b                   	pop    %ebx
80101910:	5e                   	pop    %esi
80101911:	5f                   	pop    %edi
80101912:	5d                   	pop    %ebp
80101913:	c3                   	ret    
80101914:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010191b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010191f:	90                   	nop

80101920 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	57                   	push   %edi
80101924:	89 c7                	mov    %eax,%edi
80101926:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101927:	31 f6                	xor    %esi,%esi
{
80101929:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010192a:	bb b4 21 11 80       	mov    $0x801121b4,%ebx
{
8010192f:	83 ec 28             	sub    $0x28,%esp
80101932:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101935:	68 80 21 11 80       	push   $0x80112180
8010193a:	e8 91 3e 00 00       	call   801057d0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010193f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101942:	83 c4 10             	add    $0x10,%esp
80101945:	eb 1b                	jmp    80101962 <iget+0x42>
80101947:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010194e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101950:	39 3b                	cmp    %edi,(%ebx)
80101952:	74 6c                	je     801019c0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101954:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010195a:	81 fb d4 3d 11 80    	cmp    $0x80113dd4,%ebx
80101960:	73 26                	jae    80101988 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101962:	8b 43 08             	mov    0x8(%ebx),%eax
80101965:	85 c0                	test   %eax,%eax
80101967:	7f e7                	jg     80101950 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101969:	85 f6                	test   %esi,%esi
8010196b:	75 e7                	jne    80101954 <iget+0x34>
8010196d:	85 c0                	test   %eax,%eax
8010196f:	75 76                	jne    801019e7 <iget+0xc7>
80101971:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101973:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101979:	81 fb d4 3d 11 80    	cmp    $0x80113dd4,%ebx
8010197f:	72 e1                	jb     80101962 <iget+0x42>
80101981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101988:	85 f6                	test   %esi,%esi
8010198a:	74 79                	je     80101a05 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010198c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010198f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101991:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101994:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010199b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801019a2:	68 80 21 11 80       	push   $0x80112180
801019a7:	e8 c4 3d 00 00       	call   80105770 <release>

  return ip;
801019ac:	83 c4 10             	add    $0x10,%esp
}
801019af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019b2:	89 f0                	mov    %esi,%eax
801019b4:	5b                   	pop    %ebx
801019b5:	5e                   	pop    %esi
801019b6:	5f                   	pop    %edi
801019b7:	5d                   	pop    %ebp
801019b8:	c3                   	ret    
801019b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801019c0:	39 53 04             	cmp    %edx,0x4(%ebx)
801019c3:	75 8f                	jne    80101954 <iget+0x34>
      release(&icache.lock);
801019c5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801019c8:	83 c0 01             	add    $0x1,%eax
      return ip;
801019cb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801019cd:	68 80 21 11 80       	push   $0x80112180
      ip->ref++;
801019d2:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801019d5:	e8 96 3d 00 00       	call   80105770 <release>
      return ip;
801019da:	83 c4 10             	add    $0x10,%esp
}
801019dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019e0:	89 f0                	mov    %esi,%eax
801019e2:	5b                   	pop    %ebx
801019e3:	5e                   	pop    %esi
801019e4:	5f                   	pop    %edi
801019e5:	5d                   	pop    %ebp
801019e6:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801019e7:	81 c3 90 00 00 00    	add    $0x90,%ebx
801019ed:	81 fb d4 3d 11 80    	cmp    $0x80113dd4,%ebx
801019f3:	73 10                	jae    80101a05 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801019f5:	8b 43 08             	mov    0x8(%ebx),%eax
801019f8:	85 c0                	test   %eax,%eax
801019fa:	0f 8f 50 ff ff ff    	jg     80101950 <iget+0x30>
80101a00:	e9 68 ff ff ff       	jmp    8010196d <iget+0x4d>
    panic("iget: no inodes");
80101a05:	83 ec 0c             	sub    $0xc,%esp
80101a08:	68 67 8b 10 80       	push   $0x80108b67
80101a0d:	e8 6e e9 ff ff       	call   80100380 <panic>
80101a12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a20 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101a20:	55                   	push   %ebp
80101a21:	89 e5                	mov    %esp,%ebp
80101a23:	57                   	push   %edi
80101a24:	56                   	push   %esi
80101a25:	89 c6                	mov    %eax,%esi
80101a27:	53                   	push   %ebx
80101a28:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101a2b:	83 fa 0b             	cmp    $0xb,%edx
80101a2e:	0f 86 8c 00 00 00    	jbe    80101ac0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101a34:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101a37:	83 fb 7f             	cmp    $0x7f,%ebx
80101a3a:	0f 87 a2 00 00 00    	ja     80101ae2 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101a40:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101a46:	85 c0                	test   %eax,%eax
80101a48:	74 5e                	je     80101aa8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101a4a:	83 ec 08             	sub    $0x8,%esp
80101a4d:	50                   	push   %eax
80101a4e:	ff 36                	push   (%esi)
80101a50:	e8 7b e6 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101a55:	83 c4 10             	add    $0x10,%esp
80101a58:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
80101a5c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
80101a5e:	8b 3b                	mov    (%ebx),%edi
80101a60:	85 ff                	test   %edi,%edi
80101a62:	74 1c                	je     80101a80 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101a64:	83 ec 0c             	sub    $0xc,%esp
80101a67:	52                   	push   %edx
80101a68:	e8 83 e7 ff ff       	call   801001f0 <brelse>
80101a6d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101a70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a73:	89 f8                	mov    %edi,%eax
80101a75:	5b                   	pop    %ebx
80101a76:	5e                   	pop    %esi
80101a77:	5f                   	pop    %edi
80101a78:	5d                   	pop    %ebp
80101a79:	c3                   	ret    
80101a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101a80:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101a83:	8b 06                	mov    (%esi),%eax
80101a85:	e8 86 fd ff ff       	call   80101810 <balloc>
      log_write(bp);
80101a8a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101a8d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101a90:	89 03                	mov    %eax,(%ebx)
80101a92:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101a94:	52                   	push   %edx
80101a95:	e8 56 1b 00 00       	call   801035f0 <log_write>
80101a9a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101a9d:	83 c4 10             	add    $0x10,%esp
80101aa0:	eb c2                	jmp    80101a64 <bmap+0x44>
80101aa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101aa8:	8b 06                	mov    (%esi),%eax
80101aaa:	e8 61 fd ff ff       	call   80101810 <balloc>
80101aaf:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101ab5:	eb 93                	jmp    80101a4a <bmap+0x2a>
80101ab7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101abe:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101ac0:	8d 5a 14             	lea    0x14(%edx),%ebx
80101ac3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101ac7:	85 ff                	test   %edi,%edi
80101ac9:	75 a5                	jne    80101a70 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101acb:	8b 00                	mov    (%eax),%eax
80101acd:	e8 3e fd ff ff       	call   80101810 <balloc>
80101ad2:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101ad6:	89 c7                	mov    %eax,%edi
}
80101ad8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101adb:	5b                   	pop    %ebx
80101adc:	89 f8                	mov    %edi,%eax
80101ade:	5e                   	pop    %esi
80101adf:	5f                   	pop    %edi
80101ae0:	5d                   	pop    %ebp
80101ae1:	c3                   	ret    
  panic("bmap: out of range");
80101ae2:	83 ec 0c             	sub    $0xc,%esp
80101ae5:	68 77 8b 10 80       	push   $0x80108b77
80101aea:	e8 91 e8 ff ff       	call   80100380 <panic>
80101aef:	90                   	nop

80101af0 <readsb>:
{
80101af0:	55                   	push   %ebp
80101af1:	89 e5                	mov    %esp,%ebp
80101af3:	56                   	push   %esi
80101af4:	53                   	push   %ebx
80101af5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101af8:	83 ec 08             	sub    $0x8,%esp
80101afb:	6a 01                	push   $0x1
80101afd:	ff 75 08             	push   0x8(%ebp)
80101b00:	e8 cb e5 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101b05:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101b08:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101b0a:	8d 40 5c             	lea    0x5c(%eax),%eax
80101b0d:	6a 1c                	push   $0x1c
80101b0f:	50                   	push   %eax
80101b10:	56                   	push   %esi
80101b11:	e8 1a 3e 00 00       	call   80105930 <memmove>
  brelse(bp);
80101b16:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101b19:	83 c4 10             	add    $0x10,%esp
}
80101b1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b1f:	5b                   	pop    %ebx
80101b20:	5e                   	pop    %esi
80101b21:	5d                   	pop    %ebp
  brelse(bp);
80101b22:	e9 c9 e6 ff ff       	jmp    801001f0 <brelse>
80101b27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b2e:	66 90                	xchg   %ax,%ax

80101b30 <iinit>:
{
80101b30:	55                   	push   %ebp
80101b31:	89 e5                	mov    %esp,%ebp
80101b33:	53                   	push   %ebx
80101b34:	bb c0 21 11 80       	mov    $0x801121c0,%ebx
80101b39:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101b3c:	68 8a 8b 10 80       	push   $0x80108b8a
80101b41:	68 80 21 11 80       	push   $0x80112180
80101b46:	e8 b5 3a 00 00       	call   80105600 <initlock>
  for(i = 0; i < NINODE; i++) {
80101b4b:	83 c4 10             	add    $0x10,%esp
80101b4e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101b50:	83 ec 08             	sub    $0x8,%esp
80101b53:	68 91 8b 10 80       	push   $0x80108b91
80101b58:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101b59:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
80101b5f:	e8 5c 39 00 00       	call   801054c0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101b64:	83 c4 10             	add    $0x10,%esp
80101b67:	81 fb e0 3d 11 80    	cmp    $0x80113de0,%ebx
80101b6d:	75 e1                	jne    80101b50 <iinit+0x20>
  bp = bread(dev, 1);
80101b6f:	83 ec 08             	sub    $0x8,%esp
80101b72:	6a 01                	push   $0x1
80101b74:	ff 75 08             	push   0x8(%ebp)
80101b77:	e8 54 e5 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101b7c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101b7f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101b81:	8d 40 5c             	lea    0x5c(%eax),%eax
80101b84:	6a 1c                	push   $0x1c
80101b86:	50                   	push   %eax
80101b87:	68 d4 3d 11 80       	push   $0x80113dd4
80101b8c:	e8 9f 3d 00 00       	call   80105930 <memmove>
  brelse(bp);
80101b91:	89 1c 24             	mov    %ebx,(%esp)
80101b94:	e8 57 e6 ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101b99:	ff 35 ec 3d 11 80    	push   0x80113dec
80101b9f:	ff 35 e8 3d 11 80    	push   0x80113de8
80101ba5:	ff 35 e4 3d 11 80    	push   0x80113de4
80101bab:	ff 35 e0 3d 11 80    	push   0x80113de0
80101bb1:	ff 35 dc 3d 11 80    	push   0x80113ddc
80101bb7:	ff 35 d8 3d 11 80    	push   0x80113dd8
80101bbd:	ff 35 d4 3d 11 80    	push   0x80113dd4
80101bc3:	68 f4 8b 10 80       	push   $0x80108bf4
80101bc8:	e8 d3 ea ff ff       	call   801006a0 <cprintf>
}
80101bcd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101bd0:	83 c4 30             	add    $0x30,%esp
80101bd3:	c9                   	leave  
80101bd4:	c3                   	ret    
80101bd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101be0 <ialloc>:
{
80101be0:	55                   	push   %ebp
80101be1:	89 e5                	mov    %esp,%ebp
80101be3:	57                   	push   %edi
80101be4:	56                   	push   %esi
80101be5:	53                   	push   %ebx
80101be6:	83 ec 1c             	sub    $0x1c,%esp
80101be9:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101bec:	83 3d dc 3d 11 80 01 	cmpl   $0x1,0x80113ddc
{
80101bf3:	8b 75 08             	mov    0x8(%ebp),%esi
80101bf6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101bf9:	0f 86 91 00 00 00    	jbe    80101c90 <ialloc+0xb0>
80101bff:	bf 01 00 00 00       	mov    $0x1,%edi
80101c04:	eb 21                	jmp    80101c27 <ialloc+0x47>
80101c06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c0d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101c10:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101c13:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101c16:	53                   	push   %ebx
80101c17:	e8 d4 e5 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101c1c:	83 c4 10             	add    $0x10,%esp
80101c1f:	3b 3d dc 3d 11 80    	cmp    0x80113ddc,%edi
80101c25:	73 69                	jae    80101c90 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101c27:	89 f8                	mov    %edi,%eax
80101c29:	83 ec 08             	sub    $0x8,%esp
80101c2c:	c1 e8 03             	shr    $0x3,%eax
80101c2f:	03 05 e8 3d 11 80    	add    0x80113de8,%eax
80101c35:	50                   	push   %eax
80101c36:	56                   	push   %esi
80101c37:	e8 94 e4 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
80101c3c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
80101c3f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101c41:	89 f8                	mov    %edi,%eax
80101c43:	83 e0 07             	and    $0x7,%eax
80101c46:	c1 e0 06             	shl    $0x6,%eax
80101c49:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101c4d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101c51:	75 bd                	jne    80101c10 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101c53:	83 ec 04             	sub    $0x4,%esp
80101c56:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101c59:	6a 40                	push   $0x40
80101c5b:	6a 00                	push   $0x0
80101c5d:	51                   	push   %ecx
80101c5e:	e8 2d 3c 00 00       	call   80105890 <memset>
      dip->type = type;
80101c63:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101c67:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101c6a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101c6d:	89 1c 24             	mov    %ebx,(%esp)
80101c70:	e8 7b 19 00 00       	call   801035f0 <log_write>
      brelse(bp);
80101c75:	89 1c 24             	mov    %ebx,(%esp)
80101c78:	e8 73 e5 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80101c7d:	83 c4 10             	add    $0x10,%esp
}
80101c80:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101c83:	89 fa                	mov    %edi,%edx
}
80101c85:	5b                   	pop    %ebx
      return iget(dev, inum);
80101c86:	89 f0                	mov    %esi,%eax
}
80101c88:	5e                   	pop    %esi
80101c89:	5f                   	pop    %edi
80101c8a:	5d                   	pop    %ebp
      return iget(dev, inum);
80101c8b:	e9 90 fc ff ff       	jmp    80101920 <iget>
  panic("ialloc: no inodes");
80101c90:	83 ec 0c             	sub    $0xc,%esp
80101c93:	68 97 8b 10 80       	push   $0x80108b97
80101c98:	e8 e3 e6 ff ff       	call   80100380 <panic>
80101c9d:	8d 76 00             	lea    0x0(%esi),%esi

80101ca0 <iupdate>:
{
80101ca0:	55                   	push   %ebp
80101ca1:	89 e5                	mov    %esp,%ebp
80101ca3:	56                   	push   %esi
80101ca4:	53                   	push   %ebx
80101ca5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101ca8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101cab:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101cae:	83 ec 08             	sub    $0x8,%esp
80101cb1:	c1 e8 03             	shr    $0x3,%eax
80101cb4:	03 05 e8 3d 11 80    	add    0x80113de8,%eax
80101cba:	50                   	push   %eax
80101cbb:	ff 73 a4             	push   -0x5c(%ebx)
80101cbe:	e8 0d e4 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101cc3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101cc7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101cca:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101ccc:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101ccf:	83 e0 07             	and    $0x7,%eax
80101cd2:	c1 e0 06             	shl    $0x6,%eax
80101cd5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101cd9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101cdc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101ce0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101ce3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101ce7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101ceb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101cef:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101cf3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101cf7:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101cfa:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101cfd:	6a 34                	push   $0x34
80101cff:	53                   	push   %ebx
80101d00:	50                   	push   %eax
80101d01:	e8 2a 3c 00 00       	call   80105930 <memmove>
  log_write(bp);
80101d06:	89 34 24             	mov    %esi,(%esp)
80101d09:	e8 e2 18 00 00       	call   801035f0 <log_write>
  brelse(bp);
80101d0e:	89 75 08             	mov    %esi,0x8(%ebp)
80101d11:	83 c4 10             	add    $0x10,%esp
}
80101d14:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d17:	5b                   	pop    %ebx
80101d18:	5e                   	pop    %esi
80101d19:	5d                   	pop    %ebp
  brelse(bp);
80101d1a:	e9 d1 e4 ff ff       	jmp    801001f0 <brelse>
80101d1f:	90                   	nop

80101d20 <idup>:
{
80101d20:	55                   	push   %ebp
80101d21:	89 e5                	mov    %esp,%ebp
80101d23:	53                   	push   %ebx
80101d24:	83 ec 10             	sub    $0x10,%esp
80101d27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101d2a:	68 80 21 11 80       	push   $0x80112180
80101d2f:	e8 9c 3a 00 00       	call   801057d0 <acquire>
  ip->ref++;
80101d34:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101d38:	c7 04 24 80 21 11 80 	movl   $0x80112180,(%esp)
80101d3f:	e8 2c 3a 00 00       	call   80105770 <release>
}
80101d44:	89 d8                	mov    %ebx,%eax
80101d46:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101d49:	c9                   	leave  
80101d4a:	c3                   	ret    
80101d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d4f:	90                   	nop

80101d50 <ilock>:
{
80101d50:	55                   	push   %ebp
80101d51:	89 e5                	mov    %esp,%ebp
80101d53:	56                   	push   %esi
80101d54:	53                   	push   %ebx
80101d55:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101d58:	85 db                	test   %ebx,%ebx
80101d5a:	0f 84 b7 00 00 00    	je     80101e17 <ilock+0xc7>
80101d60:	8b 53 08             	mov    0x8(%ebx),%edx
80101d63:	85 d2                	test   %edx,%edx
80101d65:	0f 8e ac 00 00 00    	jle    80101e17 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101d6b:	83 ec 0c             	sub    $0xc,%esp
80101d6e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101d71:	50                   	push   %eax
80101d72:	e8 89 37 00 00       	call   80105500 <acquiresleep>
  if(ip->valid == 0){
80101d77:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101d7a:	83 c4 10             	add    $0x10,%esp
80101d7d:	85 c0                	test   %eax,%eax
80101d7f:	74 0f                	je     80101d90 <ilock+0x40>
}
80101d81:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d84:	5b                   	pop    %ebx
80101d85:	5e                   	pop    %esi
80101d86:	5d                   	pop    %ebp
80101d87:	c3                   	ret    
80101d88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d8f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101d90:	8b 43 04             	mov    0x4(%ebx),%eax
80101d93:	83 ec 08             	sub    $0x8,%esp
80101d96:	c1 e8 03             	shr    $0x3,%eax
80101d99:	03 05 e8 3d 11 80    	add    0x80113de8,%eax
80101d9f:	50                   	push   %eax
80101da0:	ff 33                	push   (%ebx)
80101da2:	e8 29 e3 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101da7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101daa:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101dac:	8b 43 04             	mov    0x4(%ebx),%eax
80101daf:	83 e0 07             	and    $0x7,%eax
80101db2:	c1 e0 06             	shl    $0x6,%eax
80101db5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101db9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101dbc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101dbf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101dc3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101dc7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101dcb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101dcf:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101dd3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101dd7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101ddb:	8b 50 fc             	mov    -0x4(%eax),%edx
80101dde:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101de1:	6a 34                	push   $0x34
80101de3:	50                   	push   %eax
80101de4:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101de7:	50                   	push   %eax
80101de8:	e8 43 3b 00 00       	call   80105930 <memmove>
    brelse(bp);
80101ded:	89 34 24             	mov    %esi,(%esp)
80101df0:	e8 fb e3 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101df5:	83 c4 10             	add    $0x10,%esp
80101df8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101dfd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101e04:	0f 85 77 ff ff ff    	jne    80101d81 <ilock+0x31>
      panic("ilock: no type");
80101e0a:	83 ec 0c             	sub    $0xc,%esp
80101e0d:	68 af 8b 10 80       	push   $0x80108baf
80101e12:	e8 69 e5 ff ff       	call   80100380 <panic>
    panic("ilock");
80101e17:	83 ec 0c             	sub    $0xc,%esp
80101e1a:	68 a9 8b 10 80       	push   $0x80108ba9
80101e1f:	e8 5c e5 ff ff       	call   80100380 <panic>
80101e24:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e2f:	90                   	nop

80101e30 <iunlock>:
{
80101e30:	55                   	push   %ebp
80101e31:	89 e5                	mov    %esp,%ebp
80101e33:	56                   	push   %esi
80101e34:	53                   	push   %ebx
80101e35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e38:	85 db                	test   %ebx,%ebx
80101e3a:	74 28                	je     80101e64 <iunlock+0x34>
80101e3c:	83 ec 0c             	sub    $0xc,%esp
80101e3f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101e42:	56                   	push   %esi
80101e43:	e8 68 37 00 00       	call   801055b0 <holdingsleep>
80101e48:	83 c4 10             	add    $0x10,%esp
80101e4b:	85 c0                	test   %eax,%eax
80101e4d:	74 15                	je     80101e64 <iunlock+0x34>
80101e4f:	8b 43 08             	mov    0x8(%ebx),%eax
80101e52:	85 c0                	test   %eax,%eax
80101e54:	7e 0e                	jle    80101e64 <iunlock+0x34>
  releasesleep(&ip->lock);
80101e56:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101e59:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101e5c:	5b                   	pop    %ebx
80101e5d:	5e                   	pop    %esi
80101e5e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101e5f:	e9 fc 36 00 00       	jmp    80105560 <releasesleep>
    panic("iunlock");
80101e64:	83 ec 0c             	sub    $0xc,%esp
80101e67:	68 be 8b 10 80       	push   $0x80108bbe
80101e6c:	e8 0f e5 ff ff       	call   80100380 <panic>
80101e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e7f:	90                   	nop

80101e80 <iput>:
{
80101e80:	55                   	push   %ebp
80101e81:	89 e5                	mov    %esp,%ebp
80101e83:	57                   	push   %edi
80101e84:	56                   	push   %esi
80101e85:	53                   	push   %ebx
80101e86:	83 ec 28             	sub    $0x28,%esp
80101e89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101e8c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101e8f:	57                   	push   %edi
80101e90:	e8 6b 36 00 00       	call   80105500 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101e95:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101e98:	83 c4 10             	add    $0x10,%esp
80101e9b:	85 d2                	test   %edx,%edx
80101e9d:	74 07                	je     80101ea6 <iput+0x26>
80101e9f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101ea4:	74 32                	je     80101ed8 <iput+0x58>
  releasesleep(&ip->lock);
80101ea6:	83 ec 0c             	sub    $0xc,%esp
80101ea9:	57                   	push   %edi
80101eaa:	e8 b1 36 00 00       	call   80105560 <releasesleep>
  acquire(&icache.lock);
80101eaf:	c7 04 24 80 21 11 80 	movl   $0x80112180,(%esp)
80101eb6:	e8 15 39 00 00       	call   801057d0 <acquire>
  ip->ref--;
80101ebb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101ebf:	83 c4 10             	add    $0x10,%esp
80101ec2:	c7 45 08 80 21 11 80 	movl   $0x80112180,0x8(%ebp)
}
80101ec9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ecc:	5b                   	pop    %ebx
80101ecd:	5e                   	pop    %esi
80101ece:	5f                   	pop    %edi
80101ecf:	5d                   	pop    %ebp
  release(&icache.lock);
80101ed0:	e9 9b 38 00 00       	jmp    80105770 <release>
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101ed8:	83 ec 0c             	sub    $0xc,%esp
80101edb:	68 80 21 11 80       	push   $0x80112180
80101ee0:	e8 eb 38 00 00       	call   801057d0 <acquire>
    int r = ip->ref;
80101ee5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101ee8:	c7 04 24 80 21 11 80 	movl   $0x80112180,(%esp)
80101eef:	e8 7c 38 00 00       	call   80105770 <release>
    if(r == 1){
80101ef4:	83 c4 10             	add    $0x10,%esp
80101ef7:	83 fe 01             	cmp    $0x1,%esi
80101efa:	75 aa                	jne    80101ea6 <iput+0x26>
80101efc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101f02:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101f05:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101f08:	89 cf                	mov    %ecx,%edi
80101f0a:	eb 0b                	jmp    80101f17 <iput+0x97>
80101f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101f10:	83 c6 04             	add    $0x4,%esi
80101f13:	39 fe                	cmp    %edi,%esi
80101f15:	74 19                	je     80101f30 <iput+0xb0>
    if(ip->addrs[i]){
80101f17:	8b 16                	mov    (%esi),%edx
80101f19:	85 d2                	test   %edx,%edx
80101f1b:	74 f3                	je     80101f10 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101f1d:	8b 03                	mov    (%ebx),%eax
80101f1f:	e8 6c f8 ff ff       	call   80101790 <bfree>
      ip->addrs[i] = 0;
80101f24:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101f2a:	eb e4                	jmp    80101f10 <iput+0x90>
80101f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101f30:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101f36:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101f39:	85 c0                	test   %eax,%eax
80101f3b:	75 2d                	jne    80101f6a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101f3d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101f40:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101f47:	53                   	push   %ebx
80101f48:	e8 53 fd ff ff       	call   80101ca0 <iupdate>
      ip->type = 0;
80101f4d:	31 c0                	xor    %eax,%eax
80101f4f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101f53:	89 1c 24             	mov    %ebx,(%esp)
80101f56:	e8 45 fd ff ff       	call   80101ca0 <iupdate>
      ip->valid = 0;
80101f5b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101f62:	83 c4 10             	add    $0x10,%esp
80101f65:	e9 3c ff ff ff       	jmp    80101ea6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101f6a:	83 ec 08             	sub    $0x8,%esp
80101f6d:	50                   	push   %eax
80101f6e:	ff 33                	push   (%ebx)
80101f70:	e8 5b e1 ff ff       	call   801000d0 <bread>
80101f75:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101f78:	83 c4 10             	add    $0x10,%esp
80101f7b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101f81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101f84:	8d 70 5c             	lea    0x5c(%eax),%esi
80101f87:	89 cf                	mov    %ecx,%edi
80101f89:	eb 0c                	jmp    80101f97 <iput+0x117>
80101f8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f8f:	90                   	nop
80101f90:	83 c6 04             	add    $0x4,%esi
80101f93:	39 f7                	cmp    %esi,%edi
80101f95:	74 0f                	je     80101fa6 <iput+0x126>
      if(a[j])
80101f97:	8b 16                	mov    (%esi),%edx
80101f99:	85 d2                	test   %edx,%edx
80101f9b:	74 f3                	je     80101f90 <iput+0x110>
        bfree(ip->dev, a[j]);
80101f9d:	8b 03                	mov    (%ebx),%eax
80101f9f:	e8 ec f7 ff ff       	call   80101790 <bfree>
80101fa4:	eb ea                	jmp    80101f90 <iput+0x110>
    brelse(bp);
80101fa6:	83 ec 0c             	sub    $0xc,%esp
80101fa9:	ff 75 e4             	push   -0x1c(%ebp)
80101fac:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101faf:	e8 3c e2 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101fb4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101fba:	8b 03                	mov    (%ebx),%eax
80101fbc:	e8 cf f7 ff ff       	call   80101790 <bfree>
    ip->addrs[NDIRECT] = 0;
80101fc1:	83 c4 10             	add    $0x10,%esp
80101fc4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101fcb:	00 00 00 
80101fce:	e9 6a ff ff ff       	jmp    80101f3d <iput+0xbd>
80101fd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101fe0 <iunlockput>:
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	56                   	push   %esi
80101fe4:	53                   	push   %ebx
80101fe5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fe8:	85 db                	test   %ebx,%ebx
80101fea:	74 34                	je     80102020 <iunlockput+0x40>
80101fec:	83 ec 0c             	sub    $0xc,%esp
80101fef:	8d 73 0c             	lea    0xc(%ebx),%esi
80101ff2:	56                   	push   %esi
80101ff3:	e8 b8 35 00 00       	call   801055b0 <holdingsleep>
80101ff8:	83 c4 10             	add    $0x10,%esp
80101ffb:	85 c0                	test   %eax,%eax
80101ffd:	74 21                	je     80102020 <iunlockput+0x40>
80101fff:	8b 43 08             	mov    0x8(%ebx),%eax
80102002:	85 c0                	test   %eax,%eax
80102004:	7e 1a                	jle    80102020 <iunlockput+0x40>
  releasesleep(&ip->lock);
80102006:	83 ec 0c             	sub    $0xc,%esp
80102009:	56                   	push   %esi
8010200a:	e8 51 35 00 00       	call   80105560 <releasesleep>
  iput(ip);
8010200f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80102012:	83 c4 10             	add    $0x10,%esp
}
80102015:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102018:	5b                   	pop    %ebx
80102019:	5e                   	pop    %esi
8010201a:	5d                   	pop    %ebp
  iput(ip);
8010201b:	e9 60 fe ff ff       	jmp    80101e80 <iput>
    panic("iunlock");
80102020:	83 ec 0c             	sub    $0xc,%esp
80102023:	68 be 8b 10 80       	push   $0x80108bbe
80102028:	e8 53 e3 ff ff       	call   80100380 <panic>
8010202d:	8d 76 00             	lea    0x0(%esi),%esi

80102030 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80102030:	55                   	push   %ebp
80102031:	89 e5                	mov    %esp,%ebp
80102033:	8b 55 08             	mov    0x8(%ebp),%edx
80102036:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80102039:	8b 0a                	mov    (%edx),%ecx
8010203b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010203e:	8b 4a 04             	mov    0x4(%edx),%ecx
80102041:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80102044:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80102048:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010204b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010204f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80102053:	8b 52 58             	mov    0x58(%edx),%edx
80102056:	89 50 10             	mov    %edx,0x10(%eax)
}
80102059:	5d                   	pop    %ebp
8010205a:	c3                   	ret    
8010205b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010205f:	90                   	nop

80102060 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80102060:	55                   	push   %ebp
80102061:	89 e5                	mov    %esp,%ebp
80102063:	57                   	push   %edi
80102064:	56                   	push   %esi
80102065:	53                   	push   %ebx
80102066:	83 ec 1c             	sub    $0x1c,%esp
80102069:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010206c:	8b 45 08             	mov    0x8(%ebp),%eax
8010206f:	8b 75 10             	mov    0x10(%ebp),%esi
80102072:	89 7d e0             	mov    %edi,-0x20(%ebp)
80102075:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102078:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
8010207d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102080:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80102083:	0f 84 a7 00 00 00    	je     80102130 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80102089:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010208c:	8b 40 58             	mov    0x58(%eax),%eax
8010208f:	39 c6                	cmp    %eax,%esi
80102091:	0f 87 ba 00 00 00    	ja     80102151 <readi+0xf1>
80102097:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010209a:	31 c9                	xor    %ecx,%ecx
8010209c:	89 da                	mov    %ebx,%edx
8010209e:	01 f2                	add    %esi,%edx
801020a0:	0f 92 c1             	setb   %cl
801020a3:	89 cf                	mov    %ecx,%edi
801020a5:	0f 82 a6 00 00 00    	jb     80102151 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801020ab:	89 c1                	mov    %eax,%ecx
801020ad:	29 f1                	sub    %esi,%ecx
801020af:	39 d0                	cmp    %edx,%eax
801020b1:	0f 43 cb             	cmovae %ebx,%ecx
801020b4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801020b7:	85 c9                	test   %ecx,%ecx
801020b9:	74 67                	je     80102122 <readi+0xc2>
801020bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020bf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020c0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801020c3:	89 f2                	mov    %esi,%edx
801020c5:	c1 ea 09             	shr    $0x9,%edx
801020c8:	89 d8                	mov    %ebx,%eax
801020ca:	e8 51 f9 ff ff       	call   80101a20 <bmap>
801020cf:	83 ec 08             	sub    $0x8,%esp
801020d2:	50                   	push   %eax
801020d3:	ff 33                	push   (%ebx)
801020d5:	e8 f6 df ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801020da:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801020dd:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020e2:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801020e4:	89 f0                	mov    %esi,%eax
801020e6:	25 ff 01 00 00       	and    $0x1ff,%eax
801020eb:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801020ed:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801020f0:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
801020f2:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801020f6:	39 d9                	cmp    %ebx,%ecx
801020f8:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801020fb:	83 c4 0c             	add    $0xc,%esp
801020fe:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801020ff:	01 df                	add    %ebx,%edi
80102101:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80102103:	50                   	push   %eax
80102104:	ff 75 e0             	push   -0x20(%ebp)
80102107:	e8 24 38 00 00       	call   80105930 <memmove>
    brelse(bp);
8010210c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010210f:	89 14 24             	mov    %edx,(%esp)
80102112:	e8 d9 e0 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102117:	01 5d e0             	add    %ebx,-0x20(%ebp)
8010211a:	83 c4 10             	add    $0x10,%esp
8010211d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80102120:	77 9e                	ja     801020c0 <readi+0x60>
  }
  return n;
80102122:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80102125:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102128:	5b                   	pop    %ebx
80102129:	5e                   	pop    %esi
8010212a:	5f                   	pop    %edi
8010212b:	5d                   	pop    %ebp
8010212c:	c3                   	ret    
8010212d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102130:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102134:	66 83 f8 09          	cmp    $0x9,%ax
80102138:	77 17                	ja     80102151 <readi+0xf1>
8010213a:	8b 04 c5 20 21 11 80 	mov    -0x7feedee0(,%eax,8),%eax
80102141:	85 c0                	test   %eax,%eax
80102143:	74 0c                	je     80102151 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80102145:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102148:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010214b:	5b                   	pop    %ebx
8010214c:	5e                   	pop    %esi
8010214d:	5f                   	pop    %edi
8010214e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
8010214f:	ff e0                	jmp    *%eax
      return -1;
80102151:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102156:	eb cd                	jmp    80102125 <readi+0xc5>
80102158:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010215f:	90                   	nop

80102160 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102160:	55                   	push   %ebp
80102161:	89 e5                	mov    %esp,%ebp
80102163:	57                   	push   %edi
80102164:	56                   	push   %esi
80102165:	53                   	push   %ebx
80102166:	83 ec 1c             	sub    $0x1c,%esp
80102169:	8b 45 08             	mov    0x8(%ebp),%eax
8010216c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010216f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102172:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80102177:	89 75 dc             	mov    %esi,-0x24(%ebp)
8010217a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010217d:	8b 75 10             	mov    0x10(%ebp),%esi
80102180:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80102183:	0f 84 b7 00 00 00    	je     80102240 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80102189:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010218c:	3b 70 58             	cmp    0x58(%eax),%esi
8010218f:	0f 87 e7 00 00 00    	ja     8010227c <writei+0x11c>
80102195:	8b 7d e0             	mov    -0x20(%ebp),%edi
80102198:	31 d2                	xor    %edx,%edx
8010219a:	89 f8                	mov    %edi,%eax
8010219c:	01 f0                	add    %esi,%eax
8010219e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
801021a1:	3d 00 18 01 00       	cmp    $0x11800,%eax
801021a6:	0f 87 d0 00 00 00    	ja     8010227c <writei+0x11c>
801021ac:	85 d2                	test   %edx,%edx
801021ae:	0f 85 c8 00 00 00    	jne    8010227c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801021b4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801021bb:	85 ff                	test   %edi,%edi
801021bd:	74 72                	je     80102231 <writei+0xd1>
801021bf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801021c0:	8b 7d d8             	mov    -0x28(%ebp),%edi
801021c3:	89 f2                	mov    %esi,%edx
801021c5:	c1 ea 09             	shr    $0x9,%edx
801021c8:	89 f8                	mov    %edi,%eax
801021ca:	e8 51 f8 ff ff       	call   80101a20 <bmap>
801021cf:	83 ec 08             	sub    $0x8,%esp
801021d2:	50                   	push   %eax
801021d3:	ff 37                	push   (%edi)
801021d5:	e8 f6 de ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801021da:	b9 00 02 00 00       	mov    $0x200,%ecx
801021df:	8b 5d e0             	mov    -0x20(%ebp),%ebx
801021e2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801021e5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
801021e7:	89 f0                	mov    %esi,%eax
801021e9:	25 ff 01 00 00       	and    $0x1ff,%eax
801021ee:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
801021f0:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801021f4:	39 d9                	cmp    %ebx,%ecx
801021f6:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
801021f9:	83 c4 0c             	add    $0xc,%esp
801021fc:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801021fd:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
801021ff:	ff 75 dc             	push   -0x24(%ebp)
80102202:	50                   	push   %eax
80102203:	e8 28 37 00 00       	call   80105930 <memmove>
    log_write(bp);
80102208:	89 3c 24             	mov    %edi,(%esp)
8010220b:	e8 e0 13 00 00       	call   801035f0 <log_write>
    brelse(bp);
80102210:	89 3c 24             	mov    %edi,(%esp)
80102213:	e8 d8 df ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102218:	01 5d e4             	add    %ebx,-0x1c(%ebp)
8010221b:	83 c4 10             	add    $0x10,%esp
8010221e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102221:	01 5d dc             	add    %ebx,-0x24(%ebp)
80102224:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80102227:	77 97                	ja     801021c0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80102229:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010222c:	3b 70 58             	cmp    0x58(%eax),%esi
8010222f:	77 37                	ja     80102268 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80102231:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80102234:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102237:	5b                   	pop    %ebx
80102238:	5e                   	pop    %esi
80102239:	5f                   	pop    %edi
8010223a:	5d                   	pop    %ebp
8010223b:	c3                   	ret    
8010223c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102240:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102244:	66 83 f8 09          	cmp    $0x9,%ax
80102248:	77 32                	ja     8010227c <writei+0x11c>
8010224a:	8b 04 c5 24 21 11 80 	mov    -0x7feededc(,%eax,8),%eax
80102251:	85 c0                	test   %eax,%eax
80102253:	74 27                	je     8010227c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80102255:	89 55 10             	mov    %edx,0x10(%ebp)
}
80102258:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010225b:	5b                   	pop    %ebx
8010225c:	5e                   	pop    %esi
8010225d:	5f                   	pop    %edi
8010225e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
8010225f:	ff e0                	jmp    *%eax
80102261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80102268:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
8010226b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
8010226e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80102271:	50                   	push   %eax
80102272:	e8 29 fa ff ff       	call   80101ca0 <iupdate>
80102277:	83 c4 10             	add    $0x10,%esp
8010227a:	eb b5                	jmp    80102231 <writei+0xd1>
      return -1;
8010227c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102281:	eb b1                	jmp    80102234 <writei+0xd4>
80102283:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010228a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102290 <changesize>:

int
changesize(struct inode *ip, uint size)
{
80102290:	55                   	push   %ebp
80102291:	89 e5                	mov    %esp,%ebp
80102293:	57                   	push   %edi
80102294:	56                   	push   %esi
80102295:	53                   	push   %ebx
80102296:	83 ec 1c             	sub    $0x1c,%esp
  uint n, off, tot, m;
  struct buf *bp;

  if (ip->type != T_FILE)
80102299:	8b 45 08             	mov    0x8(%ebp),%eax
8010229c:	66 83 78 50 02       	cmpw   $0x2,0x50(%eax)
801022a1:	0f 85 b6 00 00 00    	jne    8010235d <changesize+0xcd>
    return -1;
  if (size > ip->size) {
801022a7:	8b 70 58             	mov    0x58(%eax),%esi
801022aa:	3b 75 0c             	cmp    0xc(%ebp),%esi
801022ad:	0f 82 9d 00 00 00    	jb     80102350 <changesize+0xc0>
    off = ip->size;
  } else {
    n = ip->size - size;
    off = size;
  }
  for(tot=0; tot<n; tot+=m, off+=m){
801022b3:	2b 75 0c             	sub    0xc(%ebp),%esi
801022b6:	89 75 e0             	mov    %esi,-0x20(%ebp)
801022b9:	74 73                	je     8010232e <changesize+0x9e>
801022bb:	8b 75 0c             	mov    0xc(%ebp),%esi
801022be:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801022c5:	8d 76 00             	lea    0x0(%esi),%esi
      bp = bread(ip->dev, bmap(ip, off/BSIZE));
801022c8:	89 f2                	mov    %esi,%edx
801022ca:	8b 45 08             	mov    0x8(%ebp),%eax
801022cd:	c1 ea 09             	shr    $0x9,%edx
801022d0:	e8 4b f7 ff ff       	call   80101a20 <bmap>
801022d5:	83 ec 08             	sub    $0x8,%esp
801022d8:	50                   	push   %eax
801022d9:	8b 45 08             	mov    0x8(%ebp),%eax
801022dc:	ff 30                	push   (%eax)
801022de:	e8 ed dd ff ff       	call   801000d0 <bread>
      m = min(n - tot, BSIZE - off%BSIZE);
801022e3:	b9 00 02 00 00       	mov    $0x200,%ecx
801022e8:	8b 5d e0             	mov    -0x20(%ebp),%ebx
801022eb:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
      bp = bread(ip->dev, bmap(ip, off/BSIZE));
801022ee:	89 c7                	mov    %eax,%edi
      m = min(n - tot, BSIZE - off%BSIZE);
801022f0:	89 f0                	mov    %esi,%eax
801022f2:	25 ff 01 00 00       	and    $0x1ff,%eax
801022f7:	29 c1                	sub    %eax,%ecx
      memset(bp->data + off%BSIZE, 0, m);
801022f9:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
      m = min(n - tot, BSIZE - off%BSIZE);
801022fd:	39 d9                	cmp    %ebx,%ecx
801022ff:	0f 46 d9             	cmovbe %ecx,%ebx
      memset(bp->data + off%BSIZE, 0, m);
80102302:	83 c4 0c             	add    $0xc,%esp
80102305:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m){
80102306:	01 de                	add    %ebx,%esi
      memset(bp->data + off%BSIZE, 0, m);
80102308:	6a 00                	push   $0x0
8010230a:	50                   	push   %eax
8010230b:	e8 80 35 00 00       	call   80105890 <memset>
      log_write(bp);
80102310:	89 3c 24             	mov    %edi,(%esp)
80102313:	e8 d8 12 00 00       	call   801035f0 <log_write>
      brelse(bp);
80102318:	89 3c 24             	mov    %edi,(%esp)
8010231b:	e8 d0 de ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m){
80102320:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80102323:	83 c4 10             	add    $0x10,%esp
80102326:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102329:	3b 45 e0             	cmp    -0x20(%ebp),%eax
8010232c:	72 9a                	jb     801022c8 <changesize+0x38>
  }
  ip->size = size;
8010232e:	8b 45 08             	mov    0x8(%ebp),%eax
80102331:	8b 75 0c             	mov    0xc(%ebp),%esi
  iupdate(ip);
80102334:	83 ec 0c             	sub    $0xc,%esp
  ip->size = size;
80102337:	89 70 58             	mov    %esi,0x58(%eax)
  iupdate(ip);
8010233a:	50                   	push   %eax
8010233b:	e8 60 f9 ff ff       	call   80101ca0 <iupdate>
  return size;
80102340:	8b 45 0c             	mov    0xc(%ebp),%eax
80102343:	83 c4 10             	add    $0x10,%esp
}
80102346:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102349:	5b                   	pop    %ebx
8010234a:	5e                   	pop    %esi
8010234b:	5f                   	pop    %edi
8010234c:	5d                   	pop    %ebp
8010234d:	c3                   	ret    
8010234e:	66 90                	xchg   %ax,%ax
    n = size - ip->size;
80102350:	8b 45 0c             	mov    0xc(%ebp),%eax
80102353:	29 f0                	sub    %esi,%eax
80102355:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m){
80102358:	e9 61 ff ff ff       	jmp    801022be <changesize+0x2e>
    return -1;
8010235d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102362:	eb e2                	jmp    80102346 <changesize+0xb6>
80102364:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010236b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010236f:	90                   	nop

80102370 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102370:	55                   	push   %ebp
80102371:	89 e5                	mov    %esp,%ebp
80102373:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80102376:	6a 0e                	push   $0xe
80102378:	ff 75 0c             	push   0xc(%ebp)
8010237b:	ff 75 08             	push   0x8(%ebp)
8010237e:	e8 1d 36 00 00       	call   801059a0 <strncmp>
}
80102383:	c9                   	leave  
80102384:	c3                   	ret    
80102385:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010238c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102390 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102390:	55                   	push   %ebp
80102391:	89 e5                	mov    %esp,%ebp
80102393:	57                   	push   %edi
80102394:	56                   	push   %esi
80102395:	53                   	push   %ebx
80102396:	83 ec 1c             	sub    $0x1c,%esp
80102399:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010239c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801023a1:	0f 85 85 00 00 00    	jne    8010242c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801023a7:	8b 53 58             	mov    0x58(%ebx),%edx
801023aa:	31 ff                	xor    %edi,%edi
801023ac:	8d 75 d8             	lea    -0x28(%ebp),%esi
801023af:	85 d2                	test   %edx,%edx
801023b1:	74 3e                	je     801023f1 <dirlookup+0x61>
801023b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023b7:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023b8:	6a 10                	push   $0x10
801023ba:	57                   	push   %edi
801023bb:	56                   	push   %esi
801023bc:	53                   	push   %ebx
801023bd:	e8 9e fc ff ff       	call   80102060 <readi>
801023c2:	83 c4 10             	add    $0x10,%esp
801023c5:	83 f8 10             	cmp    $0x10,%eax
801023c8:	75 55                	jne    8010241f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
801023ca:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801023cf:	74 18                	je     801023e9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
801023d1:	83 ec 04             	sub    $0x4,%esp
801023d4:	8d 45 da             	lea    -0x26(%ebp),%eax
801023d7:	6a 0e                	push   $0xe
801023d9:	50                   	push   %eax
801023da:	ff 75 0c             	push   0xc(%ebp)
801023dd:	e8 be 35 00 00       	call   801059a0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
801023e2:	83 c4 10             	add    $0x10,%esp
801023e5:	85 c0                	test   %eax,%eax
801023e7:	74 17                	je     80102400 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
801023e9:	83 c7 10             	add    $0x10,%edi
801023ec:	3b 7b 58             	cmp    0x58(%ebx),%edi
801023ef:	72 c7                	jb     801023b8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
801023f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801023f4:	31 c0                	xor    %eax,%eax
}
801023f6:	5b                   	pop    %ebx
801023f7:	5e                   	pop    %esi
801023f8:	5f                   	pop    %edi
801023f9:	5d                   	pop    %ebp
801023fa:	c3                   	ret    
801023fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023ff:	90                   	nop
      if(poff)
80102400:	8b 45 10             	mov    0x10(%ebp),%eax
80102403:	85 c0                	test   %eax,%eax
80102405:	74 05                	je     8010240c <dirlookup+0x7c>
        *poff = off;
80102407:	8b 45 10             	mov    0x10(%ebp),%eax
8010240a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
8010240c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80102410:	8b 03                	mov    (%ebx),%eax
80102412:	e8 09 f5 ff ff       	call   80101920 <iget>
}
80102417:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010241a:	5b                   	pop    %ebx
8010241b:	5e                   	pop    %esi
8010241c:	5f                   	pop    %edi
8010241d:	5d                   	pop    %ebp
8010241e:	c3                   	ret    
      panic("dirlookup read");
8010241f:	83 ec 0c             	sub    $0xc,%esp
80102422:	68 d8 8b 10 80       	push   $0x80108bd8
80102427:	e8 54 df ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
8010242c:	83 ec 0c             	sub    $0xc,%esp
8010242f:	68 c6 8b 10 80       	push   $0x80108bc6
80102434:	e8 47 df ff ff       	call   80100380 <panic>
80102439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102440 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102440:	55                   	push   %ebp
80102441:	89 e5                	mov    %esp,%ebp
80102443:	57                   	push   %edi
80102444:	56                   	push   %esi
80102445:	53                   	push   %ebx
80102446:	89 c3                	mov    %eax,%ebx
80102448:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010244b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
8010244e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102451:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80102454:	0f 84 64 01 00 00    	je     801025be <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010245a:	e8 31 1c 00 00       	call   80104090 <myproc>
  acquire(&icache.lock);
8010245f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80102462:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102465:	68 80 21 11 80       	push   $0x80112180
8010246a:	e8 61 33 00 00       	call   801057d0 <acquire>
  ip->ref++;
8010246f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102473:	c7 04 24 80 21 11 80 	movl   $0x80112180,(%esp)
8010247a:	e8 f1 32 00 00       	call   80105770 <release>
8010247f:	83 c4 10             	add    $0x10,%esp
80102482:	eb 07                	jmp    8010248b <namex+0x4b>
80102484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102488:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010248b:	0f b6 03             	movzbl (%ebx),%eax
8010248e:	3c 2f                	cmp    $0x2f,%al
80102490:	74 f6                	je     80102488 <namex+0x48>
  if(*path == 0)
80102492:	84 c0                	test   %al,%al
80102494:	0f 84 06 01 00 00    	je     801025a0 <namex+0x160>
  while(*path != '/' && *path != 0)
8010249a:	0f b6 03             	movzbl (%ebx),%eax
8010249d:	84 c0                	test   %al,%al
8010249f:	0f 84 10 01 00 00    	je     801025b5 <namex+0x175>
801024a5:	89 df                	mov    %ebx,%edi
801024a7:	3c 2f                	cmp    $0x2f,%al
801024a9:	0f 84 06 01 00 00    	je     801025b5 <namex+0x175>
801024af:	90                   	nop
801024b0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
801024b4:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
801024b7:	3c 2f                	cmp    $0x2f,%al
801024b9:	74 04                	je     801024bf <namex+0x7f>
801024bb:	84 c0                	test   %al,%al
801024bd:	75 f1                	jne    801024b0 <namex+0x70>
  len = path - s;
801024bf:	89 f8                	mov    %edi,%eax
801024c1:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
801024c3:	83 f8 0d             	cmp    $0xd,%eax
801024c6:	0f 8e ac 00 00 00    	jle    80102578 <namex+0x138>
    memmove(name, s, DIRSIZ);
801024cc:	83 ec 04             	sub    $0x4,%esp
801024cf:	6a 0e                	push   $0xe
801024d1:	53                   	push   %ebx
    path++;
801024d2:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
801024d4:	ff 75 e4             	push   -0x1c(%ebp)
801024d7:	e8 54 34 00 00       	call   80105930 <memmove>
801024dc:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
801024df:	80 3f 2f             	cmpb   $0x2f,(%edi)
801024e2:	75 0c                	jne    801024f0 <namex+0xb0>
801024e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801024e8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
801024eb:	80 3b 2f             	cmpb   $0x2f,(%ebx)
801024ee:	74 f8                	je     801024e8 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
801024f0:	83 ec 0c             	sub    $0xc,%esp
801024f3:	56                   	push   %esi
801024f4:	e8 57 f8 ff ff       	call   80101d50 <ilock>
    if(ip->type != T_DIR){
801024f9:	83 c4 10             	add    $0x10,%esp
801024fc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102501:	0f 85 cd 00 00 00    	jne    801025d4 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80102507:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010250a:	85 c0                	test   %eax,%eax
8010250c:	74 09                	je     80102517 <namex+0xd7>
8010250e:	80 3b 00             	cmpb   $0x0,(%ebx)
80102511:	0f 84 22 01 00 00    	je     80102639 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102517:	83 ec 04             	sub    $0x4,%esp
8010251a:	6a 00                	push   $0x0
8010251c:	ff 75 e4             	push   -0x1c(%ebp)
8010251f:	56                   	push   %esi
80102520:	e8 6b fe ff ff       	call   80102390 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102525:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80102528:	83 c4 10             	add    $0x10,%esp
8010252b:	89 c7                	mov    %eax,%edi
8010252d:	85 c0                	test   %eax,%eax
8010252f:	0f 84 e1 00 00 00    	je     80102616 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102535:	83 ec 0c             	sub    $0xc,%esp
80102538:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010253b:	52                   	push   %edx
8010253c:	e8 6f 30 00 00       	call   801055b0 <holdingsleep>
80102541:	83 c4 10             	add    $0x10,%esp
80102544:	85 c0                	test   %eax,%eax
80102546:	0f 84 30 01 00 00    	je     8010267c <namex+0x23c>
8010254c:	8b 56 08             	mov    0x8(%esi),%edx
8010254f:	85 d2                	test   %edx,%edx
80102551:	0f 8e 25 01 00 00    	jle    8010267c <namex+0x23c>
  releasesleep(&ip->lock);
80102557:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010255a:	83 ec 0c             	sub    $0xc,%esp
8010255d:	52                   	push   %edx
8010255e:	e8 fd 2f 00 00       	call   80105560 <releasesleep>
  iput(ip);
80102563:	89 34 24             	mov    %esi,(%esp)
80102566:	89 fe                	mov    %edi,%esi
80102568:	e8 13 f9 ff ff       	call   80101e80 <iput>
8010256d:	83 c4 10             	add    $0x10,%esp
80102570:	e9 16 ff ff ff       	jmp    8010248b <namex+0x4b>
80102575:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80102578:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010257b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
8010257e:	83 ec 04             	sub    $0x4,%esp
80102581:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102584:	50                   	push   %eax
80102585:	53                   	push   %ebx
    name[len] = 0;
80102586:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80102588:	ff 75 e4             	push   -0x1c(%ebp)
8010258b:	e8 a0 33 00 00       	call   80105930 <memmove>
    name[len] = 0;
80102590:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102593:	83 c4 10             	add    $0x10,%esp
80102596:	c6 02 00             	movb   $0x0,(%edx)
80102599:	e9 41 ff ff ff       	jmp    801024df <namex+0x9f>
8010259e:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801025a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801025a3:	85 c0                	test   %eax,%eax
801025a5:	0f 85 be 00 00 00    	jne    80102669 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
801025ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025ae:	89 f0                	mov    %esi,%eax
801025b0:	5b                   	pop    %ebx
801025b1:	5e                   	pop    %esi
801025b2:	5f                   	pop    %edi
801025b3:	5d                   	pop    %ebp
801025b4:	c3                   	ret    
  while(*path != '/' && *path != 0)
801025b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801025b8:	89 df                	mov    %ebx,%edi
801025ba:	31 c0                	xor    %eax,%eax
801025bc:	eb c0                	jmp    8010257e <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
801025be:	ba 01 00 00 00       	mov    $0x1,%edx
801025c3:	b8 01 00 00 00       	mov    $0x1,%eax
801025c8:	e8 53 f3 ff ff       	call   80101920 <iget>
801025cd:	89 c6                	mov    %eax,%esi
801025cf:	e9 b7 fe ff ff       	jmp    8010248b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801025d4:	83 ec 0c             	sub    $0xc,%esp
801025d7:	8d 5e 0c             	lea    0xc(%esi),%ebx
801025da:	53                   	push   %ebx
801025db:	e8 d0 2f 00 00       	call   801055b0 <holdingsleep>
801025e0:	83 c4 10             	add    $0x10,%esp
801025e3:	85 c0                	test   %eax,%eax
801025e5:	0f 84 91 00 00 00    	je     8010267c <namex+0x23c>
801025eb:	8b 46 08             	mov    0x8(%esi),%eax
801025ee:	85 c0                	test   %eax,%eax
801025f0:	0f 8e 86 00 00 00    	jle    8010267c <namex+0x23c>
  releasesleep(&ip->lock);
801025f6:	83 ec 0c             	sub    $0xc,%esp
801025f9:	53                   	push   %ebx
801025fa:	e8 61 2f 00 00       	call   80105560 <releasesleep>
  iput(ip);
801025ff:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102602:	31 f6                	xor    %esi,%esi
  iput(ip);
80102604:	e8 77 f8 ff ff       	call   80101e80 <iput>
      return 0;
80102609:	83 c4 10             	add    $0x10,%esp
}
8010260c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010260f:	89 f0                	mov    %esi,%eax
80102611:	5b                   	pop    %ebx
80102612:	5e                   	pop    %esi
80102613:	5f                   	pop    %edi
80102614:	5d                   	pop    %ebp
80102615:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102616:	83 ec 0c             	sub    $0xc,%esp
80102619:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010261c:	52                   	push   %edx
8010261d:	e8 8e 2f 00 00       	call   801055b0 <holdingsleep>
80102622:	83 c4 10             	add    $0x10,%esp
80102625:	85 c0                	test   %eax,%eax
80102627:	74 53                	je     8010267c <namex+0x23c>
80102629:	8b 4e 08             	mov    0x8(%esi),%ecx
8010262c:	85 c9                	test   %ecx,%ecx
8010262e:	7e 4c                	jle    8010267c <namex+0x23c>
  releasesleep(&ip->lock);
80102630:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102633:	83 ec 0c             	sub    $0xc,%esp
80102636:	52                   	push   %edx
80102637:	eb c1                	jmp    801025fa <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102639:	83 ec 0c             	sub    $0xc,%esp
8010263c:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010263f:	53                   	push   %ebx
80102640:	e8 6b 2f 00 00       	call   801055b0 <holdingsleep>
80102645:	83 c4 10             	add    $0x10,%esp
80102648:	85 c0                	test   %eax,%eax
8010264a:	74 30                	je     8010267c <namex+0x23c>
8010264c:	8b 7e 08             	mov    0x8(%esi),%edi
8010264f:	85 ff                	test   %edi,%edi
80102651:	7e 29                	jle    8010267c <namex+0x23c>
  releasesleep(&ip->lock);
80102653:	83 ec 0c             	sub    $0xc,%esp
80102656:	53                   	push   %ebx
80102657:	e8 04 2f 00 00       	call   80105560 <releasesleep>
}
8010265c:	83 c4 10             	add    $0x10,%esp
}
8010265f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102662:	89 f0                	mov    %esi,%eax
80102664:	5b                   	pop    %ebx
80102665:	5e                   	pop    %esi
80102666:	5f                   	pop    %edi
80102667:	5d                   	pop    %ebp
80102668:	c3                   	ret    
    iput(ip);
80102669:	83 ec 0c             	sub    $0xc,%esp
8010266c:	56                   	push   %esi
    return 0;
8010266d:	31 f6                	xor    %esi,%esi
    iput(ip);
8010266f:	e8 0c f8 ff ff       	call   80101e80 <iput>
    return 0;
80102674:	83 c4 10             	add    $0x10,%esp
80102677:	e9 2f ff ff ff       	jmp    801025ab <namex+0x16b>
    panic("iunlock");
8010267c:	83 ec 0c             	sub    $0xc,%esp
8010267f:	68 be 8b 10 80       	push   $0x80108bbe
80102684:	e8 f7 dc ff ff       	call   80100380 <panic>
80102689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102690 <dirlink>:
{
80102690:	55                   	push   %ebp
80102691:	89 e5                	mov    %esp,%ebp
80102693:	57                   	push   %edi
80102694:	56                   	push   %esi
80102695:	53                   	push   %ebx
80102696:	83 ec 20             	sub    $0x20,%esp
80102699:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010269c:	6a 00                	push   $0x0
8010269e:	ff 75 0c             	push   0xc(%ebp)
801026a1:	53                   	push   %ebx
801026a2:	e8 e9 fc ff ff       	call   80102390 <dirlookup>
801026a7:	83 c4 10             	add    $0x10,%esp
801026aa:	85 c0                	test   %eax,%eax
801026ac:	75 67                	jne    80102715 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
801026ae:	8b 7b 58             	mov    0x58(%ebx),%edi
801026b1:	8d 75 d8             	lea    -0x28(%ebp),%esi
801026b4:	85 ff                	test   %edi,%edi
801026b6:	74 29                	je     801026e1 <dirlink+0x51>
801026b8:	31 ff                	xor    %edi,%edi
801026ba:	8d 75 d8             	lea    -0x28(%ebp),%esi
801026bd:	eb 09                	jmp    801026c8 <dirlink+0x38>
801026bf:	90                   	nop
801026c0:	83 c7 10             	add    $0x10,%edi
801026c3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801026c6:	73 19                	jae    801026e1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801026c8:	6a 10                	push   $0x10
801026ca:	57                   	push   %edi
801026cb:	56                   	push   %esi
801026cc:	53                   	push   %ebx
801026cd:	e8 8e f9 ff ff       	call   80102060 <readi>
801026d2:	83 c4 10             	add    $0x10,%esp
801026d5:	83 f8 10             	cmp    $0x10,%eax
801026d8:	75 4e                	jne    80102728 <dirlink+0x98>
    if(de.inum == 0)
801026da:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801026df:	75 df                	jne    801026c0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
801026e1:	83 ec 04             	sub    $0x4,%esp
801026e4:	8d 45 da             	lea    -0x26(%ebp),%eax
801026e7:	6a 0e                	push   $0xe
801026e9:	ff 75 0c             	push   0xc(%ebp)
801026ec:	50                   	push   %eax
801026ed:	e8 fe 32 00 00       	call   801059f0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801026f2:	6a 10                	push   $0x10
  de.inum = inum;
801026f4:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801026f7:	57                   	push   %edi
801026f8:	56                   	push   %esi
801026f9:	53                   	push   %ebx
  de.inum = inum;
801026fa:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801026fe:	e8 5d fa ff ff       	call   80102160 <writei>
80102703:	83 c4 20             	add    $0x20,%esp
80102706:	83 f8 10             	cmp    $0x10,%eax
80102709:	75 2a                	jne    80102735 <dirlink+0xa5>
  return 0;
8010270b:	31 c0                	xor    %eax,%eax
}
8010270d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102710:	5b                   	pop    %ebx
80102711:	5e                   	pop    %esi
80102712:	5f                   	pop    %edi
80102713:	5d                   	pop    %ebp
80102714:	c3                   	ret    
    iput(ip);
80102715:	83 ec 0c             	sub    $0xc,%esp
80102718:	50                   	push   %eax
80102719:	e8 62 f7 ff ff       	call   80101e80 <iput>
    return -1;
8010271e:	83 c4 10             	add    $0x10,%esp
80102721:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102726:	eb e5                	jmp    8010270d <dirlink+0x7d>
      panic("dirlink read");
80102728:	83 ec 0c             	sub    $0xc,%esp
8010272b:	68 e7 8b 10 80       	push   $0x80108be7
80102730:	e8 4b dc ff ff       	call   80100380 <panic>
    panic("dirlink");
80102735:	83 ec 0c             	sub    $0xc,%esp
80102738:	68 d2 92 10 80       	push   $0x801092d2
8010273d:	e8 3e dc ff ff       	call   80100380 <panic>
80102742:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102750 <namei>:

struct inode*
namei(char *path)
{
80102750:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102751:	31 d2                	xor    %edx,%edx
{
80102753:	89 e5                	mov    %esp,%ebp
80102755:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102758:	8b 45 08             	mov    0x8(%ebp),%eax
8010275b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010275e:	e8 dd fc ff ff       	call   80102440 <namex>
}
80102763:	c9                   	leave  
80102764:	c3                   	ret    
80102765:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102770 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102770:	55                   	push   %ebp
  return namex(path, 1, name);
80102771:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102776:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102778:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010277b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010277e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010277f:	e9 bc fc ff ff       	jmp    80102440 <namex>
80102784:	66 90                	xchg   %ax,%ax
80102786:	66 90                	xchg   %ax,%ax
80102788:	66 90                	xchg   %ax,%ax
8010278a:	66 90                	xchg   %ax,%ax
8010278c:	66 90                	xchg   %ax,%ax
8010278e:	66 90                	xchg   %ax,%ax

80102790 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102790:	55                   	push   %ebp
80102791:	89 e5                	mov    %esp,%ebp
80102793:	57                   	push   %edi
80102794:	56                   	push   %esi
80102795:	53                   	push   %ebx
80102796:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102799:	85 c0                	test   %eax,%eax
8010279b:	0f 84 b4 00 00 00    	je     80102855 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801027a1:	8b 70 08             	mov    0x8(%eax),%esi
801027a4:	89 c3                	mov    %eax,%ebx
801027a6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801027ac:	0f 87 96 00 00 00    	ja     80102848 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027b2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801027b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027be:	66 90                	xchg   %ax,%ax
801027c0:	89 ca                	mov    %ecx,%edx
801027c2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801027c3:	83 e0 c0             	and    $0xffffffc0,%eax
801027c6:	3c 40                	cmp    $0x40,%al
801027c8:	75 f6                	jne    801027c0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027ca:	31 ff                	xor    %edi,%edi
801027cc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801027d1:	89 f8                	mov    %edi,%eax
801027d3:	ee                   	out    %al,(%dx)
801027d4:	b8 01 00 00 00       	mov    $0x1,%eax
801027d9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801027de:	ee                   	out    %al,(%dx)
801027df:	ba f3 01 00 00       	mov    $0x1f3,%edx
801027e4:	89 f0                	mov    %esi,%eax
801027e6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801027e7:	89 f0                	mov    %esi,%eax
801027e9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801027ee:	c1 f8 08             	sar    $0x8,%eax
801027f1:	ee                   	out    %al,(%dx)
801027f2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801027f7:	89 f8                	mov    %edi,%eax
801027f9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801027fa:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801027fe:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102803:	c1 e0 04             	shl    $0x4,%eax
80102806:	83 e0 10             	and    $0x10,%eax
80102809:	83 c8 e0             	or     $0xffffffe0,%eax
8010280c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010280d:	f6 03 04             	testb  $0x4,(%ebx)
80102810:	75 16                	jne    80102828 <idestart+0x98>
80102812:	b8 20 00 00 00       	mov    $0x20,%eax
80102817:	89 ca                	mov    %ecx,%edx
80102819:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010281a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010281d:	5b                   	pop    %ebx
8010281e:	5e                   	pop    %esi
8010281f:	5f                   	pop    %edi
80102820:	5d                   	pop    %ebp
80102821:	c3                   	ret    
80102822:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102828:	b8 30 00 00 00       	mov    $0x30,%eax
8010282d:	89 ca                	mov    %ecx,%edx
8010282f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102830:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102835:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102838:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010283d:	fc                   	cld    
8010283e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102840:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102843:	5b                   	pop    %ebx
80102844:	5e                   	pop    %esi
80102845:	5f                   	pop    %edi
80102846:	5d                   	pop    %ebp
80102847:	c3                   	ret    
    panic("incorrect blockno");
80102848:	83 ec 0c             	sub    $0xc,%esp
8010284b:	68 50 8c 10 80       	push   $0x80108c50
80102850:	e8 2b db ff ff       	call   80100380 <panic>
    panic("idestart");
80102855:	83 ec 0c             	sub    $0xc,%esp
80102858:	68 47 8c 10 80       	push   $0x80108c47
8010285d:	e8 1e db ff ff       	call   80100380 <panic>
80102862:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102870 <ideinit>:
{
80102870:	55                   	push   %ebp
80102871:	89 e5                	mov    %esp,%ebp
80102873:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102876:	68 62 8c 10 80       	push   $0x80108c62
8010287b:	68 20 3e 11 80       	push   $0x80113e20
80102880:	e8 7b 2d 00 00       	call   80105600 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102885:	58                   	pop    %eax
80102886:	a1 a4 3f 11 80       	mov    0x80113fa4,%eax
8010288b:	5a                   	pop    %edx
8010288c:	83 e8 01             	sub    $0x1,%eax
8010288f:	50                   	push   %eax
80102890:	6a 0e                	push   $0xe
80102892:	e8 99 02 00 00       	call   80102b30 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102897:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010289f:	90                   	nop
801028a0:	ec                   	in     (%dx),%al
801028a1:	83 e0 c0             	and    $0xffffffc0,%eax
801028a4:	3c 40                	cmp    $0x40,%al
801028a6:	75 f8                	jne    801028a0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801028ad:	ba f6 01 00 00       	mov    $0x1f6,%edx
801028b2:	ee                   	out    %al,(%dx)
801028b3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028b8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801028bd:	eb 06                	jmp    801028c5 <ideinit+0x55>
801028bf:	90                   	nop
  for(i=0; i<1000; i++){
801028c0:	83 e9 01             	sub    $0x1,%ecx
801028c3:	74 0f                	je     801028d4 <ideinit+0x64>
801028c5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801028c6:	84 c0                	test   %al,%al
801028c8:	74 f6                	je     801028c0 <ideinit+0x50>
      havedisk1 = 1;
801028ca:	c7 05 00 3e 11 80 01 	movl   $0x1,0x80113e00
801028d1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801028d9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801028de:	ee                   	out    %al,(%dx)
}
801028df:	c9                   	leave  
801028e0:	c3                   	ret    
801028e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ef:	90                   	nop

801028f0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801028f0:	55                   	push   %ebp
801028f1:	89 e5                	mov    %esp,%ebp
801028f3:	57                   	push   %edi
801028f4:	56                   	push   %esi
801028f5:	53                   	push   %ebx
801028f6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801028f9:	68 20 3e 11 80       	push   $0x80113e20
801028fe:	e8 cd 2e 00 00       	call   801057d0 <acquire>

  if((b = idequeue) == 0){
80102903:	8b 1d 04 3e 11 80    	mov    0x80113e04,%ebx
80102909:	83 c4 10             	add    $0x10,%esp
8010290c:	85 db                	test   %ebx,%ebx
8010290e:	74 63                	je     80102973 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102910:	8b 43 58             	mov    0x58(%ebx),%eax
80102913:	a3 04 3e 11 80       	mov    %eax,0x80113e04

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102918:	8b 33                	mov    (%ebx),%esi
8010291a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102920:	75 2f                	jne    80102951 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102922:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010292e:	66 90                	xchg   %ax,%ax
80102930:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102931:	89 c1                	mov    %eax,%ecx
80102933:	83 e1 c0             	and    $0xffffffc0,%ecx
80102936:	80 f9 40             	cmp    $0x40,%cl
80102939:	75 f5                	jne    80102930 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010293b:	a8 21                	test   $0x21,%al
8010293d:	75 12                	jne    80102951 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010293f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102942:	b9 80 00 00 00       	mov    $0x80,%ecx
80102947:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010294c:	fc                   	cld    
8010294d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010294f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102951:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102954:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102957:	83 ce 02             	or     $0x2,%esi
8010295a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010295c:	53                   	push   %ebx
8010295d:	e8 5e 22 00 00       	call   80104bc0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102962:	a1 04 3e 11 80       	mov    0x80113e04,%eax
80102967:	83 c4 10             	add    $0x10,%esp
8010296a:	85 c0                	test   %eax,%eax
8010296c:	74 05                	je     80102973 <ideintr+0x83>
    idestart(idequeue);
8010296e:	e8 1d fe ff ff       	call   80102790 <idestart>
    release(&idelock);
80102973:	83 ec 0c             	sub    $0xc,%esp
80102976:	68 20 3e 11 80       	push   $0x80113e20
8010297b:	e8 f0 2d 00 00       	call   80105770 <release>

  release(&idelock);
}
80102980:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102983:	5b                   	pop    %ebx
80102984:	5e                   	pop    %esi
80102985:	5f                   	pop    %edi
80102986:	5d                   	pop    %ebp
80102987:	c3                   	ret    
80102988:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010298f:	90                   	nop

80102990 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102990:	55                   	push   %ebp
80102991:	89 e5                	mov    %esp,%ebp
80102993:	53                   	push   %ebx
80102994:	83 ec 10             	sub    $0x10,%esp
80102997:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010299a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010299d:	50                   	push   %eax
8010299e:	e8 0d 2c 00 00       	call   801055b0 <holdingsleep>
801029a3:	83 c4 10             	add    $0x10,%esp
801029a6:	85 c0                	test   %eax,%eax
801029a8:	0f 84 c3 00 00 00    	je     80102a71 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801029ae:	8b 03                	mov    (%ebx),%eax
801029b0:	83 e0 06             	and    $0x6,%eax
801029b3:	83 f8 02             	cmp    $0x2,%eax
801029b6:	0f 84 a8 00 00 00    	je     80102a64 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801029bc:	8b 53 04             	mov    0x4(%ebx),%edx
801029bf:	85 d2                	test   %edx,%edx
801029c1:	74 0d                	je     801029d0 <iderw+0x40>
801029c3:	a1 00 3e 11 80       	mov    0x80113e00,%eax
801029c8:	85 c0                	test   %eax,%eax
801029ca:	0f 84 87 00 00 00    	je     80102a57 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801029d0:	83 ec 0c             	sub    $0xc,%esp
801029d3:	68 20 3e 11 80       	push   $0x80113e20
801029d8:	e8 f3 2d 00 00       	call   801057d0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801029dd:	a1 04 3e 11 80       	mov    0x80113e04,%eax
  b->qnext = 0;
801029e2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801029e9:	83 c4 10             	add    $0x10,%esp
801029ec:	85 c0                	test   %eax,%eax
801029ee:	74 60                	je     80102a50 <iderw+0xc0>
801029f0:	89 c2                	mov    %eax,%edx
801029f2:	8b 40 58             	mov    0x58(%eax),%eax
801029f5:	85 c0                	test   %eax,%eax
801029f7:	75 f7                	jne    801029f0 <iderw+0x60>
801029f9:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801029fc:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801029fe:	39 1d 04 3e 11 80    	cmp    %ebx,0x80113e04
80102a04:	74 3a                	je     80102a40 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a06:	8b 03                	mov    (%ebx),%eax
80102a08:	83 e0 06             	and    $0x6,%eax
80102a0b:	83 f8 02             	cmp    $0x2,%eax
80102a0e:	74 1b                	je     80102a2b <iderw+0x9b>
    sleep(b, &idelock);
80102a10:	83 ec 08             	sub    $0x8,%esp
80102a13:	68 20 3e 11 80       	push   $0x80113e20
80102a18:	53                   	push   %ebx
80102a19:	e8 e2 20 00 00       	call   80104b00 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a1e:	8b 03                	mov    (%ebx),%eax
80102a20:	83 c4 10             	add    $0x10,%esp
80102a23:	83 e0 06             	and    $0x6,%eax
80102a26:	83 f8 02             	cmp    $0x2,%eax
80102a29:	75 e5                	jne    80102a10 <iderw+0x80>
  }


  release(&idelock);
80102a2b:	c7 45 08 20 3e 11 80 	movl   $0x80113e20,0x8(%ebp)
}
80102a32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a35:	c9                   	leave  
  release(&idelock);
80102a36:	e9 35 2d 00 00       	jmp    80105770 <release>
80102a3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a3f:	90                   	nop
    idestart(b);
80102a40:	89 d8                	mov    %ebx,%eax
80102a42:	e8 49 fd ff ff       	call   80102790 <idestart>
80102a47:	eb bd                	jmp    80102a06 <iderw+0x76>
80102a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102a50:	ba 04 3e 11 80       	mov    $0x80113e04,%edx
80102a55:	eb a5                	jmp    801029fc <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102a57:	83 ec 0c             	sub    $0xc,%esp
80102a5a:	68 91 8c 10 80       	push   $0x80108c91
80102a5f:	e8 1c d9 ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80102a64:	83 ec 0c             	sub    $0xc,%esp
80102a67:	68 7c 8c 10 80       	push   $0x80108c7c
80102a6c:	e8 0f d9 ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80102a71:	83 ec 0c             	sub    $0xc,%esp
80102a74:	68 66 8c 10 80       	push   $0x80108c66
80102a79:	e8 02 d9 ff ff       	call   80100380 <panic>
80102a7e:	66 90                	xchg   %ax,%ax

80102a80 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102a80:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102a81:	c7 05 54 3e 11 80 00 	movl   $0xfec00000,0x80113e54
80102a88:	00 c0 fe 
{
80102a8b:	89 e5                	mov    %esp,%ebp
80102a8d:	56                   	push   %esi
80102a8e:	53                   	push   %ebx
  ioapic->reg = reg;
80102a8f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102a96:	00 00 00 
  return ioapic->data;
80102a99:	8b 15 54 3e 11 80    	mov    0x80113e54,%edx
80102a9f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102aa2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102aa8:	8b 0d 54 3e 11 80    	mov    0x80113e54,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102aae:	0f b6 15 a0 3f 11 80 	movzbl 0x80113fa0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102ab5:	c1 ee 10             	shr    $0x10,%esi
80102ab8:	89 f0                	mov    %esi,%eax
80102aba:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80102abd:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102ac0:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102ac3:	39 c2                	cmp    %eax,%edx
80102ac5:	74 16                	je     80102add <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102ac7:	83 ec 0c             	sub    $0xc,%esp
80102aca:	68 b0 8c 10 80       	push   $0x80108cb0
80102acf:	e8 cc db ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102ad4:	8b 0d 54 3e 11 80    	mov    0x80113e54,%ecx
80102ada:	83 c4 10             	add    $0x10,%esp
80102add:	83 c6 21             	add    $0x21,%esi
{
80102ae0:	ba 10 00 00 00       	mov    $0x10,%edx
80102ae5:	b8 20 00 00 00       	mov    $0x20,%eax
80102aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102af0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102af2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102af4:	8b 0d 54 3e 11 80    	mov    0x80113e54,%ecx
  for(i = 0; i <= maxintr; i++){
80102afa:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102afd:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102b03:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102b06:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102b09:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102b0c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102b0e:	8b 0d 54 3e 11 80    	mov    0x80113e54,%ecx
80102b14:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80102b1b:	39 f0                	cmp    %esi,%eax
80102b1d:	75 d1                	jne    80102af0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102b1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b22:	5b                   	pop    %ebx
80102b23:	5e                   	pop    %esi
80102b24:	5d                   	pop    %ebp
80102b25:	c3                   	ret    
80102b26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b2d:	8d 76 00             	lea    0x0(%esi),%esi

80102b30 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102b30:	55                   	push   %ebp
  ioapic->reg = reg;
80102b31:	8b 0d 54 3e 11 80    	mov    0x80113e54,%ecx
{
80102b37:	89 e5                	mov    %esp,%ebp
80102b39:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102b3c:	8d 50 20             	lea    0x20(%eax),%edx
80102b3f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102b43:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102b45:	8b 0d 54 3e 11 80    	mov    0x80113e54,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b4b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102b4e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b51:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102b54:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102b56:	a1 54 3e 11 80       	mov    0x80113e54,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b5b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102b5e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102b61:	5d                   	pop    %ebp
80102b62:	c3                   	ret    
80102b63:	66 90                	xchg   %ax,%ax
80102b65:	66 90                	xchg   %ax,%ax
80102b67:	66 90                	xchg   %ax,%ax
80102b69:	66 90                	xchg   %ax,%ax
80102b6b:	66 90                	xchg   %ax,%ax
80102b6d:	66 90                	xchg   %ax,%ax
80102b6f:	90                   	nop

80102b70 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102b70:	55                   	push   %ebp
80102b71:	89 e5                	mov    %esp,%ebp
80102b73:	53                   	push   %ebx
80102b74:	83 ec 04             	sub    $0x4,%esp
80102b77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102b7a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102b80:	75 76                	jne    80102bf8 <kfree+0x88>
80102b82:	81 fb 50 8a 13 80    	cmp    $0x80138a50,%ebx
80102b88:	72 6e                	jb     80102bf8 <kfree+0x88>
80102b8a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102b90:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102b95:	77 61                	ja     80102bf8 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b97:	83 ec 04             	sub    $0x4,%esp
80102b9a:	68 00 10 00 00       	push   $0x1000
80102b9f:	6a 01                	push   $0x1
80102ba1:	53                   	push   %ebx
80102ba2:	e8 e9 2c 00 00       	call   80105890 <memset>

  if(kmem.use_lock)
80102ba7:	8b 15 94 3e 11 80    	mov    0x80113e94,%edx
80102bad:	83 c4 10             	add    $0x10,%esp
80102bb0:	85 d2                	test   %edx,%edx
80102bb2:	75 1c                	jne    80102bd0 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102bb4:	a1 98 3e 11 80       	mov    0x80113e98,%eax
80102bb9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102bbb:	a1 94 3e 11 80       	mov    0x80113e94,%eax
  kmem.freelist = r;
80102bc0:	89 1d 98 3e 11 80    	mov    %ebx,0x80113e98
  if(kmem.use_lock)
80102bc6:	85 c0                	test   %eax,%eax
80102bc8:	75 1e                	jne    80102be8 <kfree+0x78>
    release(&kmem.lock);
}
80102bca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bcd:	c9                   	leave  
80102bce:	c3                   	ret    
80102bcf:	90                   	nop
    acquire(&kmem.lock);
80102bd0:	83 ec 0c             	sub    $0xc,%esp
80102bd3:	68 60 3e 11 80       	push   $0x80113e60
80102bd8:	e8 f3 2b 00 00       	call   801057d0 <acquire>
80102bdd:	83 c4 10             	add    $0x10,%esp
80102be0:	eb d2                	jmp    80102bb4 <kfree+0x44>
80102be2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102be8:	c7 45 08 60 3e 11 80 	movl   $0x80113e60,0x8(%ebp)
}
80102bef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bf2:	c9                   	leave  
    release(&kmem.lock);
80102bf3:	e9 78 2b 00 00       	jmp    80105770 <release>
    panic("kfree");
80102bf8:	83 ec 0c             	sub    $0xc,%esp
80102bfb:	68 e2 8c 10 80       	push   $0x80108ce2
80102c00:	e8 7b d7 ff ff       	call   80100380 <panic>
80102c05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102c10 <freerange>:
{
80102c10:	55                   	push   %ebp
80102c11:	89 e5                	mov    %esp,%ebp
80102c13:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102c14:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102c17:	8b 75 0c             	mov    0xc(%ebp),%esi
80102c1a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102c1b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102c21:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c27:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102c2d:	39 de                	cmp    %ebx,%esi
80102c2f:	72 23                	jb     80102c54 <freerange+0x44>
80102c31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102c38:	83 ec 0c             	sub    $0xc,%esp
80102c3b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c41:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102c47:	50                   	push   %eax
80102c48:	e8 23 ff ff ff       	call   80102b70 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c4d:	83 c4 10             	add    $0x10,%esp
80102c50:	39 f3                	cmp    %esi,%ebx
80102c52:	76 e4                	jbe    80102c38 <freerange+0x28>
}
80102c54:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c57:	5b                   	pop    %ebx
80102c58:	5e                   	pop    %esi
80102c59:	5d                   	pop    %ebp
80102c5a:	c3                   	ret    
80102c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c5f:	90                   	nop

80102c60 <kinit2>:
{
80102c60:	55                   	push   %ebp
80102c61:	89 e5                	mov    %esp,%ebp
80102c63:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102c64:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102c67:	8b 75 0c             	mov    0xc(%ebp),%esi
80102c6a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102c6b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102c71:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c77:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102c7d:	39 de                	cmp    %ebx,%esi
80102c7f:	72 23                	jb     80102ca4 <kinit2+0x44>
80102c81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102c88:	83 ec 0c             	sub    $0xc,%esp
80102c8b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c91:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102c97:	50                   	push   %eax
80102c98:	e8 d3 fe ff ff       	call   80102b70 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c9d:	83 c4 10             	add    $0x10,%esp
80102ca0:	39 de                	cmp    %ebx,%esi
80102ca2:	73 e4                	jae    80102c88 <kinit2+0x28>
  kmem.use_lock = 1;
80102ca4:	c7 05 94 3e 11 80 01 	movl   $0x1,0x80113e94
80102cab:	00 00 00 
}
80102cae:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102cb1:	5b                   	pop    %ebx
80102cb2:	5e                   	pop    %esi
80102cb3:	5d                   	pop    %ebp
80102cb4:	c3                   	ret    
80102cb5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102cc0 <kinit1>:
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	56                   	push   %esi
80102cc4:	53                   	push   %ebx
80102cc5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102cc8:	83 ec 08             	sub    $0x8,%esp
80102ccb:	68 e8 8c 10 80       	push   $0x80108ce8
80102cd0:	68 60 3e 11 80       	push   $0x80113e60
80102cd5:	e8 26 29 00 00       	call   80105600 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102cda:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102cdd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102ce0:	c7 05 94 3e 11 80 00 	movl   $0x0,0x80113e94
80102ce7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102cea:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102cf0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102cf6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102cfc:	39 de                	cmp    %ebx,%esi
80102cfe:	72 1c                	jb     80102d1c <kinit1+0x5c>
    kfree(p);
80102d00:	83 ec 0c             	sub    $0xc,%esp
80102d03:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d09:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102d0f:	50                   	push   %eax
80102d10:	e8 5b fe ff ff       	call   80102b70 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d15:	83 c4 10             	add    $0x10,%esp
80102d18:	39 de                	cmp    %ebx,%esi
80102d1a:	73 e4                	jae    80102d00 <kinit1+0x40>
}
80102d1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102d1f:	5b                   	pop    %ebx
80102d20:	5e                   	pop    %esi
80102d21:	5d                   	pop    %ebp
80102d22:	c3                   	ret    
80102d23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102d30 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102d30:	a1 94 3e 11 80       	mov    0x80113e94,%eax
80102d35:	85 c0                	test   %eax,%eax
80102d37:	75 1f                	jne    80102d58 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102d39:	a1 98 3e 11 80       	mov    0x80113e98,%eax
  if(r)
80102d3e:	85 c0                	test   %eax,%eax
80102d40:	74 0e                	je     80102d50 <kalloc+0x20>
    kmem.freelist = r->next;
80102d42:	8b 10                	mov    (%eax),%edx
80102d44:	89 15 98 3e 11 80    	mov    %edx,0x80113e98
  if(kmem.use_lock)
80102d4a:	c3                   	ret    
80102d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d4f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102d50:	c3                   	ret    
80102d51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102d58:	55                   	push   %ebp
80102d59:	89 e5                	mov    %esp,%ebp
80102d5b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102d5e:	68 60 3e 11 80       	push   $0x80113e60
80102d63:	e8 68 2a 00 00       	call   801057d0 <acquire>
  r = kmem.freelist;
80102d68:	a1 98 3e 11 80       	mov    0x80113e98,%eax
  if(kmem.use_lock)
80102d6d:	8b 15 94 3e 11 80    	mov    0x80113e94,%edx
  if(r)
80102d73:	83 c4 10             	add    $0x10,%esp
80102d76:	85 c0                	test   %eax,%eax
80102d78:	74 08                	je     80102d82 <kalloc+0x52>
    kmem.freelist = r->next;
80102d7a:	8b 08                	mov    (%eax),%ecx
80102d7c:	89 0d 98 3e 11 80    	mov    %ecx,0x80113e98
  if(kmem.use_lock)
80102d82:	85 d2                	test   %edx,%edx
80102d84:	74 16                	je     80102d9c <kalloc+0x6c>
    release(&kmem.lock);
80102d86:	83 ec 0c             	sub    $0xc,%esp
80102d89:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102d8c:	68 60 3e 11 80       	push   $0x80113e60
80102d91:	e8 da 29 00 00       	call   80105770 <release>
  return (char*)r;
80102d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102d99:	83 c4 10             	add    $0x10,%esp
}
80102d9c:	c9                   	leave  
80102d9d:	c3                   	ret    
80102d9e:	66 90                	xchg   %ax,%ax

80102da0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102da0:	ba 64 00 00 00       	mov    $0x64,%edx
80102da5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102da6:	a8 01                	test   $0x1,%al
80102da8:	0f 84 c2 00 00 00    	je     80102e70 <kbdgetc+0xd0>
{
80102dae:	55                   	push   %ebp
80102daf:	ba 60 00 00 00       	mov    $0x60,%edx
80102db4:	89 e5                	mov    %esp,%ebp
80102db6:	53                   	push   %ebx
80102db7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102db8:	8b 1d 9c 3e 11 80    	mov    0x80113e9c,%ebx
  data = inb(KBDATAP);
80102dbe:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102dc1:	3c e0                	cmp    $0xe0,%al
80102dc3:	74 5b                	je     80102e20 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102dc5:	89 da                	mov    %ebx,%edx
80102dc7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
80102dca:	84 c0                	test   %al,%al
80102dcc:	78 62                	js     80102e30 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102dce:	85 d2                	test   %edx,%edx
80102dd0:	74 09                	je     80102ddb <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102dd2:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102dd5:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102dd8:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80102ddb:	0f b6 91 20 8e 10 80 	movzbl -0x7fef71e0(%ecx),%edx
  shift ^= togglecode[data];
80102de2:	0f b6 81 20 8d 10 80 	movzbl -0x7fef72e0(%ecx),%eax
  shift |= shiftcode[data];
80102de9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102deb:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102ded:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
80102def:	89 15 9c 3e 11 80    	mov    %edx,0x80113e9c
  c = charcode[shift & (CTL | SHIFT)][data];
80102df5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102df8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102dfb:	8b 04 85 00 8d 10 80 	mov    -0x7fef7300(,%eax,4),%eax
80102e02:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102e06:	74 0b                	je     80102e13 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102e08:	8d 50 9f             	lea    -0x61(%eax),%edx
80102e0b:	83 fa 19             	cmp    $0x19,%edx
80102e0e:	77 48                	ja     80102e58 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102e10:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102e13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e16:	c9                   	leave  
80102e17:	c3                   	ret    
80102e18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e1f:	90                   	nop
    shift |= E0ESC;
80102e20:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102e23:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102e25:	89 1d 9c 3e 11 80    	mov    %ebx,0x80113e9c
}
80102e2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e2e:	c9                   	leave  
80102e2f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102e30:	83 e0 7f             	and    $0x7f,%eax
80102e33:	85 d2                	test   %edx,%edx
80102e35:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102e38:	0f b6 81 20 8e 10 80 	movzbl -0x7fef71e0(%ecx),%eax
80102e3f:	83 c8 40             	or     $0x40,%eax
80102e42:	0f b6 c0             	movzbl %al,%eax
80102e45:	f7 d0                	not    %eax
80102e47:	21 d8                	and    %ebx,%eax
}
80102e49:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
80102e4c:	a3 9c 3e 11 80       	mov    %eax,0x80113e9c
    return 0;
80102e51:	31 c0                	xor    %eax,%eax
}
80102e53:	c9                   	leave  
80102e54:	c3                   	ret    
80102e55:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102e58:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102e5b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102e5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e61:	c9                   	leave  
      c += 'a' - 'A';
80102e62:	83 f9 1a             	cmp    $0x1a,%ecx
80102e65:	0f 42 c2             	cmovb  %edx,%eax
}
80102e68:	c3                   	ret    
80102e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102e70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102e75:	c3                   	ret    
80102e76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e7d:	8d 76 00             	lea    0x0(%esi),%esi

80102e80 <kbdintr>:

void
kbdintr(void)
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102e86:	68 a0 2d 10 80       	push   $0x80102da0
80102e8b:	e8 f0 da ff ff       	call   80100980 <consoleintr>
}
80102e90:	83 c4 10             	add    $0x10,%esp
80102e93:	c9                   	leave  
80102e94:	c3                   	ret    
80102e95:	66 90                	xchg   %ax,%ax
80102e97:	66 90                	xchg   %ax,%ax
80102e99:	66 90                	xchg   %ax,%ax
80102e9b:	66 90                	xchg   %ax,%ax
80102e9d:	66 90                	xchg   %ax,%ax
80102e9f:	90                   	nop

80102ea0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102ea0:	a1 a0 3e 11 80       	mov    0x80113ea0,%eax
80102ea5:	85 c0                	test   %eax,%eax
80102ea7:	0f 84 cb 00 00 00    	je     80102f78 <lapicinit+0xd8>
  lapic[index] = value;
80102ead:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102eb4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102eb7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102eba:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102ec1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ec4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ec7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102ece:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102ed1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ed4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102edb:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102ede:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ee1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102ee8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102eeb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102eee:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102ef5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102ef8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102efb:	8b 50 30             	mov    0x30(%eax),%edx
80102efe:	c1 ea 10             	shr    $0x10,%edx
80102f01:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102f07:	75 77                	jne    80102f80 <lapicinit+0xe0>
  lapic[index] = value;
80102f09:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102f10:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f13:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f16:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102f1d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f20:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f23:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102f2a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f2d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f30:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102f37:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f3a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f3d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102f44:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f47:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f4a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102f51:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102f54:	8b 50 20             	mov    0x20(%eax),%edx
80102f57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f5e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102f60:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102f66:	80 e6 10             	and    $0x10,%dh
80102f69:	75 f5                	jne    80102f60 <lapicinit+0xc0>
  lapic[index] = value;
80102f6b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102f72:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f75:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102f78:	c3                   	ret    
80102f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102f80:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102f87:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102f8a:	8b 50 20             	mov    0x20(%eax),%edx
}
80102f8d:	e9 77 ff ff ff       	jmp    80102f09 <lapicinit+0x69>
80102f92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102fa0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102fa0:	a1 a0 3e 11 80       	mov    0x80113ea0,%eax
80102fa5:	85 c0                	test   %eax,%eax
80102fa7:	74 07                	je     80102fb0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102fa9:	8b 40 20             	mov    0x20(%eax),%eax
80102fac:	c1 e8 18             	shr    $0x18,%eax
80102faf:	c3                   	ret    
    return 0;
80102fb0:	31 c0                	xor    %eax,%eax
}
80102fb2:	c3                   	ret    
80102fb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102fc0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102fc0:	a1 a0 3e 11 80       	mov    0x80113ea0,%eax
80102fc5:	85 c0                	test   %eax,%eax
80102fc7:	74 0d                	je     80102fd6 <lapiceoi+0x16>
  lapic[index] = value;
80102fc9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102fd0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102fd3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102fd6:	c3                   	ret    
80102fd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fde:	66 90                	xchg   %ax,%ax

80102fe0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102fe0:	c3                   	ret    
80102fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fe8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fef:	90                   	nop

80102ff0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102ff0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ff1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102ff6:	ba 70 00 00 00       	mov    $0x70,%edx
80102ffb:	89 e5                	mov    %esp,%ebp
80102ffd:	53                   	push   %ebx
80102ffe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103001:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103004:	ee                   	out    %al,(%dx)
80103005:	b8 0a 00 00 00       	mov    $0xa,%eax
8010300a:	ba 71 00 00 00       	mov    $0x71,%edx
8010300f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80103010:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103012:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80103015:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010301b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010301d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80103020:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80103022:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80103025:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80103028:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010302e:	a1 a0 3e 11 80       	mov    0x80113ea0,%eax
80103033:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103039:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010303c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80103043:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103046:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103049:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80103050:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103053:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103056:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010305c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010305f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103065:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103068:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010306e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103071:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103077:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010307a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010307d:	c9                   	leave  
8010307e:	c3                   	ret    
8010307f:	90                   	nop

80103080 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103080:	55                   	push   %ebp
80103081:	b8 0b 00 00 00       	mov    $0xb,%eax
80103086:	ba 70 00 00 00       	mov    $0x70,%edx
8010308b:	89 e5                	mov    %esp,%ebp
8010308d:	57                   	push   %edi
8010308e:	56                   	push   %esi
8010308f:	53                   	push   %ebx
80103090:	83 ec 4c             	sub    $0x4c,%esp
80103093:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103094:	ba 71 00 00 00       	mov    $0x71,%edx
80103099:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010309a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010309d:	bb 70 00 00 00       	mov    $0x70,%ebx
801030a2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801030a5:	8d 76 00             	lea    0x0(%esi),%esi
801030a8:	31 c0                	xor    %eax,%eax
801030aa:	89 da                	mov    %ebx,%edx
801030ac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030ad:	b9 71 00 00 00       	mov    $0x71,%ecx
801030b2:	89 ca                	mov    %ecx,%edx
801030b4:	ec                   	in     (%dx),%al
801030b5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030b8:	89 da                	mov    %ebx,%edx
801030ba:	b8 02 00 00 00       	mov    $0x2,%eax
801030bf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030c0:	89 ca                	mov    %ecx,%edx
801030c2:	ec                   	in     (%dx),%al
801030c3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030c6:	89 da                	mov    %ebx,%edx
801030c8:	b8 04 00 00 00       	mov    $0x4,%eax
801030cd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030ce:	89 ca                	mov    %ecx,%edx
801030d0:	ec                   	in     (%dx),%al
801030d1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030d4:	89 da                	mov    %ebx,%edx
801030d6:	b8 07 00 00 00       	mov    $0x7,%eax
801030db:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030dc:	89 ca                	mov    %ecx,%edx
801030de:	ec                   	in     (%dx),%al
801030df:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030e2:	89 da                	mov    %ebx,%edx
801030e4:	b8 08 00 00 00       	mov    $0x8,%eax
801030e9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030ea:	89 ca                	mov    %ecx,%edx
801030ec:	ec                   	in     (%dx),%al
801030ed:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030ef:	89 da                	mov    %ebx,%edx
801030f1:	b8 09 00 00 00       	mov    $0x9,%eax
801030f6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030f7:	89 ca                	mov    %ecx,%edx
801030f9:	ec                   	in     (%dx),%al
801030fa:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030fc:	89 da                	mov    %ebx,%edx
801030fe:	b8 0a 00 00 00       	mov    $0xa,%eax
80103103:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103104:	89 ca                	mov    %ecx,%edx
80103106:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80103107:	84 c0                	test   %al,%al
80103109:	78 9d                	js     801030a8 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010310b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010310f:	89 fa                	mov    %edi,%edx
80103111:	0f b6 fa             	movzbl %dl,%edi
80103114:	89 f2                	mov    %esi,%edx
80103116:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103119:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
8010311d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103120:	89 da                	mov    %ebx,%edx
80103122:	89 7d c8             	mov    %edi,-0x38(%ebp)
80103125:	89 45 bc             	mov    %eax,-0x44(%ebp)
80103128:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
8010312c:	89 75 cc             	mov    %esi,-0x34(%ebp)
8010312f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80103132:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80103136:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103139:	31 c0                	xor    %eax,%eax
8010313b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010313c:	89 ca                	mov    %ecx,%edx
8010313e:	ec                   	in     (%dx),%al
8010313f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103142:	89 da                	mov    %ebx,%edx
80103144:	89 45 d0             	mov    %eax,-0x30(%ebp)
80103147:	b8 02 00 00 00       	mov    $0x2,%eax
8010314c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010314d:	89 ca                	mov    %ecx,%edx
8010314f:	ec                   	in     (%dx),%al
80103150:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103153:	89 da                	mov    %ebx,%edx
80103155:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103158:	b8 04 00 00 00       	mov    $0x4,%eax
8010315d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010315e:	89 ca                	mov    %ecx,%edx
80103160:	ec                   	in     (%dx),%al
80103161:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103164:	89 da                	mov    %ebx,%edx
80103166:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103169:	b8 07 00 00 00       	mov    $0x7,%eax
8010316e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010316f:	89 ca                	mov    %ecx,%edx
80103171:	ec                   	in     (%dx),%al
80103172:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103175:	89 da                	mov    %ebx,%edx
80103177:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010317a:	b8 08 00 00 00       	mov    $0x8,%eax
8010317f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103180:	89 ca                	mov    %ecx,%edx
80103182:	ec                   	in     (%dx),%al
80103183:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103186:	89 da                	mov    %ebx,%edx
80103188:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010318b:	b8 09 00 00 00       	mov    $0x9,%eax
80103190:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103191:	89 ca                	mov    %ecx,%edx
80103193:	ec                   	in     (%dx),%al
80103194:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103197:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010319a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010319d:	8d 45 d0             	lea    -0x30(%ebp),%eax
801031a0:	6a 18                	push   $0x18
801031a2:	50                   	push   %eax
801031a3:	8d 45 b8             	lea    -0x48(%ebp),%eax
801031a6:	50                   	push   %eax
801031a7:	e8 34 27 00 00       	call   801058e0 <memcmp>
801031ac:	83 c4 10             	add    $0x10,%esp
801031af:	85 c0                	test   %eax,%eax
801031b1:	0f 85 f1 fe ff ff    	jne    801030a8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801031b7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
801031bb:	75 78                	jne    80103235 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801031bd:	8b 45 b8             	mov    -0x48(%ebp),%eax
801031c0:	89 c2                	mov    %eax,%edx
801031c2:	83 e0 0f             	and    $0xf,%eax
801031c5:	c1 ea 04             	shr    $0x4,%edx
801031c8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031cb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031ce:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801031d1:	8b 45 bc             	mov    -0x44(%ebp),%eax
801031d4:	89 c2                	mov    %eax,%edx
801031d6:	83 e0 0f             	and    $0xf,%eax
801031d9:	c1 ea 04             	shr    $0x4,%edx
801031dc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031df:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031e2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801031e5:	8b 45 c0             	mov    -0x40(%ebp),%eax
801031e8:	89 c2                	mov    %eax,%edx
801031ea:	83 e0 0f             	and    $0xf,%eax
801031ed:	c1 ea 04             	shr    $0x4,%edx
801031f0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031f3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031f6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801031f9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801031fc:	89 c2                	mov    %eax,%edx
801031fe:	83 e0 0f             	and    $0xf,%eax
80103201:	c1 ea 04             	shr    $0x4,%edx
80103204:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103207:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010320a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010320d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103210:	89 c2                	mov    %eax,%edx
80103212:	83 e0 0f             	and    $0xf,%eax
80103215:	c1 ea 04             	shr    $0x4,%edx
80103218:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010321b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010321e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103221:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103224:	89 c2                	mov    %eax,%edx
80103226:	83 e0 0f             	and    $0xf,%eax
80103229:	c1 ea 04             	shr    $0x4,%edx
8010322c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010322f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103232:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80103235:	8b 75 08             	mov    0x8(%ebp),%esi
80103238:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010323b:	89 06                	mov    %eax,(%esi)
8010323d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103240:	89 46 04             	mov    %eax,0x4(%esi)
80103243:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103246:	89 46 08             	mov    %eax,0x8(%esi)
80103249:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010324c:	89 46 0c             	mov    %eax,0xc(%esi)
8010324f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103252:	89 46 10             	mov    %eax,0x10(%esi)
80103255:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103258:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
8010325b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80103262:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103265:	5b                   	pop    %ebx
80103266:	5e                   	pop    %esi
80103267:	5f                   	pop    %edi
80103268:	5d                   	pop    %ebp
80103269:	c3                   	ret    
8010326a:	66 90                	xchg   %ax,%ax
8010326c:	66 90                	xchg   %ax,%ax
8010326e:	66 90                	xchg   %ax,%ax

80103270 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103270:	8b 0d 08 3f 11 80    	mov    0x80113f08,%ecx
80103276:	85 c9                	test   %ecx,%ecx
80103278:	0f 8e 8a 00 00 00    	jle    80103308 <install_trans+0x98>
{
8010327e:	55                   	push   %ebp
8010327f:	89 e5                	mov    %esp,%ebp
80103281:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103282:	31 ff                	xor    %edi,%edi
{
80103284:	56                   	push   %esi
80103285:	53                   	push   %ebx
80103286:	83 ec 0c             	sub    $0xc,%esp
80103289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103290:	a1 f4 3e 11 80       	mov    0x80113ef4,%eax
80103295:	83 ec 08             	sub    $0x8,%esp
80103298:	01 f8                	add    %edi,%eax
8010329a:	83 c0 01             	add    $0x1,%eax
8010329d:	50                   	push   %eax
8010329e:	ff 35 04 3f 11 80    	push   0x80113f04
801032a4:	e8 27 ce ff ff       	call   801000d0 <bread>
801032a9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801032ab:	58                   	pop    %eax
801032ac:	5a                   	pop    %edx
801032ad:	ff 34 bd 0c 3f 11 80 	push   -0x7feec0f4(,%edi,4)
801032b4:	ff 35 04 3f 11 80    	push   0x80113f04
  for (tail = 0; tail < log.lh.n; tail++) {
801032ba:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801032bd:	e8 0e ce ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801032c2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801032c5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801032c7:	8d 46 5c             	lea    0x5c(%esi),%eax
801032ca:	68 00 02 00 00       	push   $0x200
801032cf:	50                   	push   %eax
801032d0:	8d 43 5c             	lea    0x5c(%ebx),%eax
801032d3:	50                   	push   %eax
801032d4:	e8 57 26 00 00       	call   80105930 <memmove>
    bwrite(dbuf);  // write dst to disk
801032d9:	89 1c 24             	mov    %ebx,(%esp)
801032dc:	e8 cf ce ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
801032e1:	89 34 24             	mov    %esi,(%esp)
801032e4:	e8 07 cf ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
801032e9:	89 1c 24             	mov    %ebx,(%esp)
801032ec:	e8 ff ce ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801032f1:	83 c4 10             	add    $0x10,%esp
801032f4:	39 3d 08 3f 11 80    	cmp    %edi,0x80113f08
801032fa:	7f 94                	jg     80103290 <install_trans+0x20>
  }
}
801032fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032ff:	5b                   	pop    %ebx
80103300:	5e                   	pop    %esi
80103301:	5f                   	pop    %edi
80103302:	5d                   	pop    %ebp
80103303:	c3                   	ret    
80103304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103308:	c3                   	ret    
80103309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103310 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103310:	55                   	push   %ebp
80103311:	89 e5                	mov    %esp,%ebp
80103313:	53                   	push   %ebx
80103314:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103317:	ff 35 f4 3e 11 80    	push   0x80113ef4
8010331d:	ff 35 04 3f 11 80    	push   0x80113f04
80103323:	e8 a8 cd ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103328:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010332b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010332d:	a1 08 3f 11 80       	mov    0x80113f08,%eax
80103332:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103335:	85 c0                	test   %eax,%eax
80103337:	7e 19                	jle    80103352 <write_head+0x42>
80103339:	31 d2                	xor    %edx,%edx
8010333b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010333f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80103340:	8b 0c 95 0c 3f 11 80 	mov    -0x7feec0f4(,%edx,4),%ecx
80103347:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010334b:	83 c2 01             	add    $0x1,%edx
8010334e:	39 d0                	cmp    %edx,%eax
80103350:	75 ee                	jne    80103340 <write_head+0x30>
  }
  bwrite(buf);
80103352:	83 ec 0c             	sub    $0xc,%esp
80103355:	53                   	push   %ebx
80103356:	e8 55 ce ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010335b:	89 1c 24             	mov    %ebx,(%esp)
8010335e:	e8 8d ce ff ff       	call   801001f0 <brelse>
}
80103363:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103366:	83 c4 10             	add    $0x10,%esp
80103369:	c9                   	leave  
8010336a:	c3                   	ret    
8010336b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010336f:	90                   	nop

80103370 <initlog>:
{
80103370:	55                   	push   %ebp
80103371:	89 e5                	mov    %esp,%ebp
80103373:	53                   	push   %ebx
80103374:	83 ec 2c             	sub    $0x2c,%esp
80103377:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010337a:	68 20 8f 10 80       	push   $0x80108f20
8010337f:	68 c0 3e 11 80       	push   $0x80113ec0
80103384:	e8 77 22 00 00       	call   80105600 <initlock>
  readsb(dev, &sb);
80103389:	58                   	pop    %eax
8010338a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010338d:	5a                   	pop    %edx
8010338e:	50                   	push   %eax
8010338f:	53                   	push   %ebx
80103390:	e8 5b e7 ff ff       	call   80101af0 <readsb>
  log.start = sb.logstart;
80103395:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80103398:	59                   	pop    %ecx
  log.dev = dev;
80103399:	89 1d 04 3f 11 80    	mov    %ebx,0x80113f04
  log.size = sb.nlog;
8010339f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
801033a2:	a3 f4 3e 11 80       	mov    %eax,0x80113ef4
  log.size = sb.nlog;
801033a7:	89 15 f8 3e 11 80    	mov    %edx,0x80113ef8
  struct buf *buf = bread(log.dev, log.start);
801033ad:	5a                   	pop    %edx
801033ae:	50                   	push   %eax
801033af:	53                   	push   %ebx
801033b0:	e8 1b cd ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
801033b5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
801033b8:	8b 58 5c             	mov    0x5c(%eax),%ebx
801033bb:	89 1d 08 3f 11 80    	mov    %ebx,0x80113f08
  for (i = 0; i < log.lh.n; i++) {
801033c1:	85 db                	test   %ebx,%ebx
801033c3:	7e 1d                	jle    801033e2 <initlog+0x72>
801033c5:	31 d2                	xor    %edx,%edx
801033c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ce:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
801033d0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
801033d4:	89 0c 95 0c 3f 11 80 	mov    %ecx,-0x7feec0f4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801033db:	83 c2 01             	add    $0x1,%edx
801033de:	39 d3                	cmp    %edx,%ebx
801033e0:	75 ee                	jne    801033d0 <initlog+0x60>
  brelse(buf);
801033e2:	83 ec 0c             	sub    $0xc,%esp
801033e5:	50                   	push   %eax
801033e6:	e8 05 ce ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801033eb:	e8 80 fe ff ff       	call   80103270 <install_trans>
  log.lh.n = 0;
801033f0:	c7 05 08 3f 11 80 00 	movl   $0x0,0x80113f08
801033f7:	00 00 00 
  write_head(); // clear the log
801033fa:	e8 11 ff ff ff       	call   80103310 <write_head>
}
801033ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103402:	83 c4 10             	add    $0x10,%esp
80103405:	c9                   	leave  
80103406:	c3                   	ret    
80103407:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010340e:	66 90                	xchg   %ax,%ax

80103410 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103410:	55                   	push   %ebp
80103411:	89 e5                	mov    %esp,%ebp
80103413:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103416:	68 c0 3e 11 80       	push   $0x80113ec0
8010341b:	e8 b0 23 00 00       	call   801057d0 <acquire>
80103420:	83 c4 10             	add    $0x10,%esp
80103423:	eb 18                	jmp    8010343d <begin_op+0x2d>
80103425:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103428:	83 ec 08             	sub    $0x8,%esp
8010342b:	68 c0 3e 11 80       	push   $0x80113ec0
80103430:	68 c0 3e 11 80       	push   $0x80113ec0
80103435:	e8 c6 16 00 00       	call   80104b00 <sleep>
8010343a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010343d:	a1 00 3f 11 80       	mov    0x80113f00,%eax
80103442:	85 c0                	test   %eax,%eax
80103444:	75 e2                	jne    80103428 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103446:	a1 fc 3e 11 80       	mov    0x80113efc,%eax
8010344b:	8b 15 08 3f 11 80    	mov    0x80113f08,%edx
80103451:	83 c0 01             	add    $0x1,%eax
80103454:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103457:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010345a:	83 fa 1e             	cmp    $0x1e,%edx
8010345d:	7f c9                	jg     80103428 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010345f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103462:	a3 fc 3e 11 80       	mov    %eax,0x80113efc
      release(&log.lock);
80103467:	68 c0 3e 11 80       	push   $0x80113ec0
8010346c:	e8 ff 22 00 00       	call   80105770 <release>
      break;
    }
  }
}
80103471:	83 c4 10             	add    $0x10,%esp
80103474:	c9                   	leave  
80103475:	c3                   	ret    
80103476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010347d:	8d 76 00             	lea    0x0(%esi),%esi

80103480 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103480:	55                   	push   %ebp
80103481:	89 e5                	mov    %esp,%ebp
80103483:	57                   	push   %edi
80103484:	56                   	push   %esi
80103485:	53                   	push   %ebx
80103486:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103489:	68 c0 3e 11 80       	push   $0x80113ec0
8010348e:	e8 3d 23 00 00       	call   801057d0 <acquire>
  log.outstanding -= 1;
80103493:	a1 fc 3e 11 80       	mov    0x80113efc,%eax
  if(log.committing)
80103498:	8b 35 00 3f 11 80    	mov    0x80113f00,%esi
8010349e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801034a1:	8d 58 ff             	lea    -0x1(%eax),%ebx
801034a4:	89 1d fc 3e 11 80    	mov    %ebx,0x80113efc
  if(log.committing)
801034aa:	85 f6                	test   %esi,%esi
801034ac:	0f 85 22 01 00 00    	jne    801035d4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
801034b2:	85 db                	test   %ebx,%ebx
801034b4:	0f 85 f6 00 00 00    	jne    801035b0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
801034ba:	c7 05 00 3f 11 80 01 	movl   $0x1,0x80113f00
801034c1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801034c4:	83 ec 0c             	sub    $0xc,%esp
801034c7:	68 c0 3e 11 80       	push   $0x80113ec0
801034cc:	e8 9f 22 00 00       	call   80105770 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801034d1:	8b 0d 08 3f 11 80    	mov    0x80113f08,%ecx
801034d7:	83 c4 10             	add    $0x10,%esp
801034da:	85 c9                	test   %ecx,%ecx
801034dc:	7f 42                	jg     80103520 <end_op+0xa0>
    acquire(&log.lock);
801034de:	83 ec 0c             	sub    $0xc,%esp
801034e1:	68 c0 3e 11 80       	push   $0x80113ec0
801034e6:	e8 e5 22 00 00       	call   801057d0 <acquire>
    wakeup(&log);
801034eb:	c7 04 24 c0 3e 11 80 	movl   $0x80113ec0,(%esp)
    log.committing = 0;
801034f2:	c7 05 00 3f 11 80 00 	movl   $0x0,0x80113f00
801034f9:	00 00 00 
    wakeup(&log);
801034fc:	e8 bf 16 00 00       	call   80104bc0 <wakeup>
    release(&log.lock);
80103501:	c7 04 24 c0 3e 11 80 	movl   $0x80113ec0,(%esp)
80103508:	e8 63 22 00 00       	call   80105770 <release>
8010350d:	83 c4 10             	add    $0x10,%esp
}
80103510:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103513:	5b                   	pop    %ebx
80103514:	5e                   	pop    %esi
80103515:	5f                   	pop    %edi
80103516:	5d                   	pop    %ebp
80103517:	c3                   	ret    
80103518:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010351f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103520:	a1 f4 3e 11 80       	mov    0x80113ef4,%eax
80103525:	83 ec 08             	sub    $0x8,%esp
80103528:	01 d8                	add    %ebx,%eax
8010352a:	83 c0 01             	add    $0x1,%eax
8010352d:	50                   	push   %eax
8010352e:	ff 35 04 3f 11 80    	push   0x80113f04
80103534:	e8 97 cb ff ff       	call   801000d0 <bread>
80103539:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010353b:	58                   	pop    %eax
8010353c:	5a                   	pop    %edx
8010353d:	ff 34 9d 0c 3f 11 80 	push   -0x7feec0f4(,%ebx,4)
80103544:	ff 35 04 3f 11 80    	push   0x80113f04
  for (tail = 0; tail < log.lh.n; tail++) {
8010354a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010354d:	e8 7e cb ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103552:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103555:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103557:	8d 40 5c             	lea    0x5c(%eax),%eax
8010355a:	68 00 02 00 00       	push   $0x200
8010355f:	50                   	push   %eax
80103560:	8d 46 5c             	lea    0x5c(%esi),%eax
80103563:	50                   	push   %eax
80103564:	e8 c7 23 00 00       	call   80105930 <memmove>
    bwrite(to);  // write the log
80103569:	89 34 24             	mov    %esi,(%esp)
8010356c:	e8 3f cc ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103571:	89 3c 24             	mov    %edi,(%esp)
80103574:	e8 77 cc ff ff       	call   801001f0 <brelse>
    brelse(to);
80103579:	89 34 24             	mov    %esi,(%esp)
8010357c:	e8 6f cc ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103581:	83 c4 10             	add    $0x10,%esp
80103584:	3b 1d 08 3f 11 80    	cmp    0x80113f08,%ebx
8010358a:	7c 94                	jl     80103520 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010358c:	e8 7f fd ff ff       	call   80103310 <write_head>
    install_trans(); // Now install writes to home locations
80103591:	e8 da fc ff ff       	call   80103270 <install_trans>
    log.lh.n = 0;
80103596:	c7 05 08 3f 11 80 00 	movl   $0x0,0x80113f08
8010359d:	00 00 00 
    write_head();    // Erase the transaction from the log
801035a0:	e8 6b fd ff ff       	call   80103310 <write_head>
801035a5:	e9 34 ff ff ff       	jmp    801034de <end_op+0x5e>
801035aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801035b0:	83 ec 0c             	sub    $0xc,%esp
801035b3:	68 c0 3e 11 80       	push   $0x80113ec0
801035b8:	e8 03 16 00 00       	call   80104bc0 <wakeup>
  release(&log.lock);
801035bd:	c7 04 24 c0 3e 11 80 	movl   $0x80113ec0,(%esp)
801035c4:	e8 a7 21 00 00       	call   80105770 <release>
801035c9:	83 c4 10             	add    $0x10,%esp
}
801035cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035cf:	5b                   	pop    %ebx
801035d0:	5e                   	pop    %esi
801035d1:	5f                   	pop    %edi
801035d2:	5d                   	pop    %ebp
801035d3:	c3                   	ret    
    panic("log.committing");
801035d4:	83 ec 0c             	sub    $0xc,%esp
801035d7:	68 24 8f 10 80       	push   $0x80108f24
801035dc:	e8 9f cd ff ff       	call   80100380 <panic>
801035e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035ef:	90                   	nop

801035f0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801035f0:	55                   	push   %ebp
801035f1:	89 e5                	mov    %esp,%ebp
801035f3:	53                   	push   %ebx
801035f4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801035f7:	8b 15 08 3f 11 80    	mov    0x80113f08,%edx
{
801035fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103600:	83 fa 1d             	cmp    $0x1d,%edx
80103603:	0f 8f 85 00 00 00    	jg     8010368e <log_write+0x9e>
80103609:	a1 f8 3e 11 80       	mov    0x80113ef8,%eax
8010360e:	83 e8 01             	sub    $0x1,%eax
80103611:	39 c2                	cmp    %eax,%edx
80103613:	7d 79                	jge    8010368e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103615:	a1 fc 3e 11 80       	mov    0x80113efc,%eax
8010361a:	85 c0                	test   %eax,%eax
8010361c:	7e 7d                	jle    8010369b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010361e:	83 ec 0c             	sub    $0xc,%esp
80103621:	68 c0 3e 11 80       	push   $0x80113ec0
80103626:	e8 a5 21 00 00       	call   801057d0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010362b:	8b 15 08 3f 11 80    	mov    0x80113f08,%edx
80103631:	83 c4 10             	add    $0x10,%esp
80103634:	85 d2                	test   %edx,%edx
80103636:	7e 4a                	jle    80103682 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103638:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010363b:	31 c0                	xor    %eax,%eax
8010363d:	eb 08                	jmp    80103647 <log_write+0x57>
8010363f:	90                   	nop
80103640:	83 c0 01             	add    $0x1,%eax
80103643:	39 c2                	cmp    %eax,%edx
80103645:	74 29                	je     80103670 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103647:	39 0c 85 0c 3f 11 80 	cmp    %ecx,-0x7feec0f4(,%eax,4)
8010364e:	75 f0                	jne    80103640 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103650:	89 0c 85 0c 3f 11 80 	mov    %ecx,-0x7feec0f4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103657:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010365a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010365d:	c7 45 08 c0 3e 11 80 	movl   $0x80113ec0,0x8(%ebp)
}
80103664:	c9                   	leave  
  release(&log.lock);
80103665:	e9 06 21 00 00       	jmp    80105770 <release>
8010366a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103670:	89 0c 95 0c 3f 11 80 	mov    %ecx,-0x7feec0f4(,%edx,4)
    log.lh.n++;
80103677:	83 c2 01             	add    $0x1,%edx
8010367a:	89 15 08 3f 11 80    	mov    %edx,0x80113f08
80103680:	eb d5                	jmp    80103657 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80103682:	8b 43 08             	mov    0x8(%ebx),%eax
80103685:	a3 0c 3f 11 80       	mov    %eax,0x80113f0c
  if (i == log.lh.n)
8010368a:	75 cb                	jne    80103657 <log_write+0x67>
8010368c:	eb e9                	jmp    80103677 <log_write+0x87>
    panic("too big a transaction");
8010368e:	83 ec 0c             	sub    $0xc,%esp
80103691:	68 33 8f 10 80       	push   $0x80108f33
80103696:	e8 e5 cc ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010369b:	83 ec 0c             	sub    $0xc,%esp
8010369e:	68 49 8f 10 80       	push   $0x80108f49
801036a3:	e8 d8 cc ff ff       	call   80100380 <panic>
801036a8:	66 90                	xchg   %ax,%ax
801036aa:	66 90                	xchg   %ax,%ax
801036ac:	66 90                	xchg   %ax,%ax
801036ae:	66 90                	xchg   %ax,%ax

801036b0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801036b0:	55                   	push   %ebp
801036b1:	89 e5                	mov    %esp,%ebp
801036b3:	53                   	push   %ebx
801036b4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801036b7:	e8 b4 09 00 00       	call   80104070 <cpuid>
801036bc:	89 c3                	mov    %eax,%ebx
801036be:	e8 ad 09 00 00       	call   80104070 <cpuid>
801036c3:	83 ec 04             	sub    $0x4,%esp
801036c6:	53                   	push   %ebx
801036c7:	50                   	push   %eax
801036c8:	68 64 8f 10 80       	push   $0x80108f64
801036cd:	e8 ce cf ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
801036d2:	e8 c9 38 00 00       	call   80106fa0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801036d7:	e8 34 09 00 00       	call   80104010 <mycpu>
801036dc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801036de:	b8 01 00 00 00       	mov    $0x1,%eax
801036e3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801036ea:	e8 51 0f 00 00       	call   80104640 <scheduler>
801036ef:	90                   	nop

801036f0 <mpenter>:
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801036f6:	e8 45 4a 00 00       	call   80108140 <switchkvm>
  seginit();
801036fb:	e8 b0 49 00 00       	call   801080b0 <seginit>
  lapicinit();
80103700:	e8 9b f7 ff ff       	call   80102ea0 <lapicinit>
  mpmain();
80103705:	e8 a6 ff ff ff       	call   801036b0 <mpmain>
8010370a:	66 90                	xchg   %ax,%ax
8010370c:	66 90                	xchg   %ax,%ax
8010370e:	66 90                	xchg   %ax,%ax

80103710 <main>:
{
80103710:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103714:	83 e4 f0             	and    $0xfffffff0,%esp
80103717:	ff 71 fc             	push   -0x4(%ecx)
8010371a:	55                   	push   %ebp
8010371b:	89 e5                	mov    %esp,%ebp
8010371d:	53                   	push   %ebx
8010371e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010371f:	83 ec 08             	sub    $0x8,%esp
80103722:	68 00 00 40 80       	push   $0x80400000
80103727:	68 50 8a 13 80       	push   $0x80138a50
8010372c:	e8 8f f5 ff ff       	call   80102cc0 <kinit1>
  kvmalloc();      // kernel page table
80103731:	e8 fa 4e 00 00       	call   80108630 <kvmalloc>
  mpinit();        // detect other processors
80103736:	e8 85 01 00 00       	call   801038c0 <mpinit>
  lapicinit();     // interrupt controller
8010373b:	e8 60 f7 ff ff       	call   80102ea0 <lapicinit>
  seginit();       // segment descriptors
80103740:	e8 6b 49 00 00       	call   801080b0 <seginit>
  picinit();       // disable pic
80103745:	e8 76 03 00 00       	call   80103ac0 <picinit>
  ioapicinit();    // another interrupt controller
8010374a:	e8 31 f3 ff ff       	call   80102a80 <ioapicinit>
  consoleinit();   // console hardware
8010374f:	e8 5c d8 ff ff       	call   80100fb0 <consoleinit>
  uartinit();      // serial port
80103754:	e8 47 3b 00 00       	call   801072a0 <uartinit>
  pinit();         // process table
80103759:	e8 92 08 00 00       	call   80103ff0 <pinit>
  tvinit();        // trap vectors
8010375e:	e8 bd 37 00 00       	call   80106f20 <tvinit>
  binit();         // buffer cache
80103763:	e8 d8 c8 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103768:	e8 f3 db ff ff       	call   80101360 <fileinit>
  ideinit();       // disk 
8010376d:	e8 fe f0 ff ff       	call   80102870 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103772:	83 c4 0c             	add    $0xc,%esp
80103775:	68 8a 00 00 00       	push   $0x8a
8010377a:	68 8c c4 10 80       	push   $0x8010c48c
8010377f:	68 00 70 00 80       	push   $0x80007000
80103784:	e8 a7 21 00 00       	call   80105930 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103789:	83 c4 10             	add    $0x10,%esp
8010378c:	69 05 a4 3f 11 80 b0 	imul   $0xb0,0x80113fa4,%eax
80103793:	00 00 00 
80103796:	05 c0 3f 11 80       	add    $0x80113fc0,%eax
8010379b:	3d c0 3f 11 80       	cmp    $0x80113fc0,%eax
801037a0:	76 7e                	jbe    80103820 <main+0x110>
801037a2:	bb c0 3f 11 80       	mov    $0x80113fc0,%ebx
801037a7:	eb 20                	jmp    801037c9 <main+0xb9>
801037a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037b0:	69 05 a4 3f 11 80 b0 	imul   $0xb0,0x80113fa4,%eax
801037b7:	00 00 00 
801037ba:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801037c0:	05 c0 3f 11 80       	add    $0x80113fc0,%eax
801037c5:	39 c3                	cmp    %eax,%ebx
801037c7:	73 57                	jae    80103820 <main+0x110>
    if(c == mycpu())  // We've started already.
801037c9:	e8 42 08 00 00       	call   80104010 <mycpu>
801037ce:	39 c3                	cmp    %eax,%ebx
801037d0:	74 de                	je     801037b0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801037d2:	e8 59 f5 ff ff       	call   80102d30 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801037d7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801037da:	c7 05 f8 6f 00 80 f0 	movl   $0x801036f0,0x80006ff8
801037e1:	36 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801037e4:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
801037eb:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801037ee:	05 00 10 00 00       	add    $0x1000,%eax
801037f3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801037f8:	0f b6 03             	movzbl (%ebx),%eax
801037fb:	68 00 70 00 00       	push   $0x7000
80103800:	50                   	push   %eax
80103801:	e8 ea f7 ff ff       	call   80102ff0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103806:	83 c4 10             	add    $0x10,%esp
80103809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103810:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103816:	85 c0                	test   %eax,%eax
80103818:	74 f6                	je     80103810 <main+0x100>
8010381a:	eb 94                	jmp    801037b0 <main+0xa0>
8010381c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103820:	83 ec 08             	sub    $0x8,%esp
80103823:	68 00 00 00 8e       	push   $0x8e000000
80103828:	68 00 00 40 80       	push   $0x80400000
8010382d:	e8 2e f4 ff ff       	call   80102c60 <kinit2>
  userinit();      // first user process
80103832:	e8 89 08 00 00       	call   801040c0 <userinit>
  mpmain();        // finish this processor's setup
80103837:	e8 74 fe ff ff       	call   801036b0 <mpmain>
8010383c:	66 90                	xchg   %ax,%ax
8010383e:	66 90                	xchg   %ax,%ax

80103840 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	57                   	push   %edi
80103844:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103845:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010384b:	53                   	push   %ebx
  e = addr+len;
8010384c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010384f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103852:	39 de                	cmp    %ebx,%esi
80103854:	72 10                	jb     80103866 <mpsearch1+0x26>
80103856:	eb 50                	jmp    801038a8 <mpsearch1+0x68>
80103858:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010385f:	90                   	nop
80103860:	89 fe                	mov    %edi,%esi
80103862:	39 fb                	cmp    %edi,%ebx
80103864:	76 42                	jbe    801038a8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103866:	83 ec 04             	sub    $0x4,%esp
80103869:	8d 7e 10             	lea    0x10(%esi),%edi
8010386c:	6a 04                	push   $0x4
8010386e:	68 78 8f 10 80       	push   $0x80108f78
80103873:	56                   	push   %esi
80103874:	e8 67 20 00 00       	call   801058e0 <memcmp>
80103879:	83 c4 10             	add    $0x10,%esp
8010387c:	85 c0                	test   %eax,%eax
8010387e:	75 e0                	jne    80103860 <mpsearch1+0x20>
80103880:	89 f2                	mov    %esi,%edx
80103882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103888:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010388b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010388e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103890:	39 fa                	cmp    %edi,%edx
80103892:	75 f4                	jne    80103888 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103894:	84 c0                	test   %al,%al
80103896:	75 c8                	jne    80103860 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010389b:	89 f0                	mov    %esi,%eax
8010389d:	5b                   	pop    %ebx
8010389e:	5e                   	pop    %esi
8010389f:	5f                   	pop    %edi
801038a0:	5d                   	pop    %ebp
801038a1:	c3                   	ret    
801038a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801038a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801038ab:	31 f6                	xor    %esi,%esi
}
801038ad:	5b                   	pop    %ebx
801038ae:	89 f0                	mov    %esi,%eax
801038b0:	5e                   	pop    %esi
801038b1:	5f                   	pop    %edi
801038b2:	5d                   	pop    %ebp
801038b3:	c3                   	ret    
801038b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038bf:	90                   	nop

801038c0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	57                   	push   %edi
801038c4:	56                   	push   %esi
801038c5:	53                   	push   %ebx
801038c6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801038c9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801038d0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801038d7:	c1 e0 08             	shl    $0x8,%eax
801038da:	09 d0                	or     %edx,%eax
801038dc:	c1 e0 04             	shl    $0x4,%eax
801038df:	75 1b                	jne    801038fc <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801038e1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801038e8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801038ef:	c1 e0 08             	shl    $0x8,%eax
801038f2:	09 d0                	or     %edx,%eax
801038f4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801038f7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801038fc:	ba 00 04 00 00       	mov    $0x400,%edx
80103901:	e8 3a ff ff ff       	call   80103840 <mpsearch1>
80103906:	89 c3                	mov    %eax,%ebx
80103908:	85 c0                	test   %eax,%eax
8010390a:	0f 84 40 01 00 00    	je     80103a50 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103910:	8b 73 04             	mov    0x4(%ebx),%esi
80103913:	85 f6                	test   %esi,%esi
80103915:	0f 84 25 01 00 00    	je     80103a40 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010391b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010391e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103924:	6a 04                	push   $0x4
80103926:	68 7d 8f 10 80       	push   $0x80108f7d
8010392b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010392c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010392f:	e8 ac 1f 00 00       	call   801058e0 <memcmp>
80103934:	83 c4 10             	add    $0x10,%esp
80103937:	85 c0                	test   %eax,%eax
80103939:	0f 85 01 01 00 00    	jne    80103a40 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010393f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103946:	3c 01                	cmp    $0x1,%al
80103948:	74 08                	je     80103952 <mpinit+0x92>
8010394a:	3c 04                	cmp    $0x4,%al
8010394c:	0f 85 ee 00 00 00    	jne    80103a40 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
80103952:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103959:	66 85 d2             	test   %dx,%dx
8010395c:	74 22                	je     80103980 <mpinit+0xc0>
8010395e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103961:	89 f0                	mov    %esi,%eax
  sum = 0;
80103963:	31 d2                	xor    %edx,%edx
80103965:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103968:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010396f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103972:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103974:	39 c7                	cmp    %eax,%edi
80103976:	75 f0                	jne    80103968 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103978:	84 d2                	test   %dl,%dl
8010397a:	0f 85 c0 00 00 00    	jne    80103a40 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103980:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103986:	a3 a0 3e 11 80       	mov    %eax,0x80113ea0
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010398b:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103992:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80103998:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010399d:	03 55 e4             	add    -0x1c(%ebp),%edx
801039a0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801039a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039a7:	90                   	nop
801039a8:	39 d0                	cmp    %edx,%eax
801039aa:	73 15                	jae    801039c1 <mpinit+0x101>
    switch(*p){
801039ac:	0f b6 08             	movzbl (%eax),%ecx
801039af:	80 f9 02             	cmp    $0x2,%cl
801039b2:	74 4c                	je     80103a00 <mpinit+0x140>
801039b4:	77 3a                	ja     801039f0 <mpinit+0x130>
801039b6:	84 c9                	test   %cl,%cl
801039b8:	74 56                	je     80103a10 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801039ba:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801039bd:	39 d0                	cmp    %edx,%eax
801039bf:	72 eb                	jb     801039ac <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801039c1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801039c4:	85 f6                	test   %esi,%esi
801039c6:	0f 84 d9 00 00 00    	je     80103aa5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801039cc:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801039d0:	74 15                	je     801039e7 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801039d2:	b8 70 00 00 00       	mov    $0x70,%eax
801039d7:	ba 22 00 00 00       	mov    $0x22,%edx
801039dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801039dd:	ba 23 00 00 00       	mov    $0x23,%edx
801039e2:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801039e3:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801039e6:	ee                   	out    %al,(%dx)
  }
}
801039e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039ea:	5b                   	pop    %ebx
801039eb:	5e                   	pop    %esi
801039ec:	5f                   	pop    %edi
801039ed:	5d                   	pop    %ebp
801039ee:	c3                   	ret    
801039ef:	90                   	nop
    switch(*p){
801039f0:	83 e9 03             	sub    $0x3,%ecx
801039f3:	80 f9 01             	cmp    $0x1,%cl
801039f6:	76 c2                	jbe    801039ba <mpinit+0xfa>
801039f8:	31 f6                	xor    %esi,%esi
801039fa:	eb ac                	jmp    801039a8 <mpinit+0xe8>
801039fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103a00:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103a04:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103a07:	88 0d a0 3f 11 80    	mov    %cl,0x80113fa0
      continue;
80103a0d:	eb 99                	jmp    801039a8 <mpinit+0xe8>
80103a0f:	90                   	nop
      if(ncpu < NCPU) {
80103a10:	8b 0d a4 3f 11 80    	mov    0x80113fa4,%ecx
80103a16:	83 f9 07             	cmp    $0x7,%ecx
80103a19:	7f 19                	jg     80103a34 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103a1b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103a21:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103a25:	83 c1 01             	add    $0x1,%ecx
80103a28:	89 0d a4 3f 11 80    	mov    %ecx,0x80113fa4
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103a2e:	88 9f c0 3f 11 80    	mov    %bl,-0x7feec040(%edi)
      p += sizeof(struct mpproc);
80103a34:	83 c0 14             	add    $0x14,%eax
      continue;
80103a37:	e9 6c ff ff ff       	jmp    801039a8 <mpinit+0xe8>
80103a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103a40:	83 ec 0c             	sub    $0xc,%esp
80103a43:	68 82 8f 10 80       	push   $0x80108f82
80103a48:	e8 33 c9 ff ff       	call   80100380 <panic>
80103a4d:	8d 76 00             	lea    0x0(%esi),%esi
{
80103a50:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103a55:	eb 13                	jmp    80103a6a <mpinit+0x1aa>
80103a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a5e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103a60:	89 f3                	mov    %esi,%ebx
80103a62:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103a68:	74 d6                	je     80103a40 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103a6a:	83 ec 04             	sub    $0x4,%esp
80103a6d:	8d 73 10             	lea    0x10(%ebx),%esi
80103a70:	6a 04                	push   $0x4
80103a72:	68 78 8f 10 80       	push   $0x80108f78
80103a77:	53                   	push   %ebx
80103a78:	e8 63 1e 00 00       	call   801058e0 <memcmp>
80103a7d:	83 c4 10             	add    $0x10,%esp
80103a80:	85 c0                	test   %eax,%eax
80103a82:	75 dc                	jne    80103a60 <mpinit+0x1a0>
80103a84:	89 da                	mov    %ebx,%edx
80103a86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a8d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103a90:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103a93:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103a96:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103a98:	39 d6                	cmp    %edx,%esi
80103a9a:	75 f4                	jne    80103a90 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103a9c:	84 c0                	test   %al,%al
80103a9e:	75 c0                	jne    80103a60 <mpinit+0x1a0>
80103aa0:	e9 6b fe ff ff       	jmp    80103910 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103aa5:	83 ec 0c             	sub    $0xc,%esp
80103aa8:	68 9c 8f 10 80       	push   $0x80108f9c
80103aad:	e8 ce c8 ff ff       	call   80100380 <panic>
80103ab2:	66 90                	xchg   %ax,%ax
80103ab4:	66 90                	xchg   %ax,%ax
80103ab6:	66 90                	xchg   %ax,%ax
80103ab8:	66 90                	xchg   %ax,%ax
80103aba:	66 90                	xchg   %ax,%ax
80103abc:	66 90                	xchg   %ax,%ax
80103abe:	66 90                	xchg   %ax,%ax

80103ac0 <picinit>:
80103ac0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ac5:	ba 21 00 00 00       	mov    $0x21,%edx
80103aca:	ee                   	out    %al,(%dx)
80103acb:	ba a1 00 00 00       	mov    $0xa1,%edx
80103ad0:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103ad1:	c3                   	ret    
80103ad2:	66 90                	xchg   %ax,%ax
80103ad4:	66 90                	xchg   %ax,%ax
80103ad6:	66 90                	xchg   %ax,%ax
80103ad8:	66 90                	xchg   %ax,%ax
80103ada:	66 90                	xchg   %ax,%ax
80103adc:	66 90                	xchg   %ax,%ax
80103ade:	66 90                	xchg   %ax,%ax

80103ae0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	57                   	push   %edi
80103ae4:	56                   	push   %esi
80103ae5:	53                   	push   %ebx
80103ae6:	83 ec 0c             	sub    $0xc,%esp
80103ae9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103aec:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103aef:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103af5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103afb:	e8 80 d8 ff ff       	call   80101380 <filealloc>
80103b00:	89 03                	mov    %eax,(%ebx)
80103b02:	85 c0                	test   %eax,%eax
80103b04:	0f 84 a8 00 00 00    	je     80103bb2 <pipealloc+0xd2>
80103b0a:	e8 71 d8 ff ff       	call   80101380 <filealloc>
80103b0f:	89 06                	mov    %eax,(%esi)
80103b11:	85 c0                	test   %eax,%eax
80103b13:	0f 84 87 00 00 00    	je     80103ba0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103b19:	e8 12 f2 ff ff       	call   80102d30 <kalloc>
80103b1e:	89 c7                	mov    %eax,%edi
80103b20:	85 c0                	test   %eax,%eax
80103b22:	0f 84 b0 00 00 00    	je     80103bd8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103b28:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103b2f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103b32:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103b35:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103b3c:	00 00 00 
  p->nwrite = 0;
80103b3f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103b46:	00 00 00 
  p->nread = 0;
80103b49:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103b50:	00 00 00 
  initlock(&p->lock, "pipe");
80103b53:	68 bb 8f 10 80       	push   $0x80108fbb
80103b58:	50                   	push   %eax
80103b59:	e8 a2 1a 00 00       	call   80105600 <initlock>
  (*f0)->type = FD_PIPE;
80103b5e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103b60:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103b63:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103b69:	8b 03                	mov    (%ebx),%eax
80103b6b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103b6f:	8b 03                	mov    (%ebx),%eax
80103b71:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103b75:	8b 03                	mov    (%ebx),%eax
80103b77:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103b7a:	8b 06                	mov    (%esi),%eax
80103b7c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103b82:	8b 06                	mov    (%esi),%eax
80103b84:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103b88:	8b 06                	mov    (%esi),%eax
80103b8a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103b8e:	8b 06                	mov    (%esi),%eax
80103b90:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103b93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103b96:	31 c0                	xor    %eax,%eax
}
80103b98:	5b                   	pop    %ebx
80103b99:	5e                   	pop    %esi
80103b9a:	5f                   	pop    %edi
80103b9b:	5d                   	pop    %ebp
80103b9c:	c3                   	ret    
80103b9d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103ba0:	8b 03                	mov    (%ebx),%eax
80103ba2:	85 c0                	test   %eax,%eax
80103ba4:	74 1e                	je     80103bc4 <pipealloc+0xe4>
    fileclose(*f0);
80103ba6:	83 ec 0c             	sub    $0xc,%esp
80103ba9:	50                   	push   %eax
80103baa:	e8 91 d8 ff ff       	call   80101440 <fileclose>
80103baf:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103bb2:	8b 06                	mov    (%esi),%eax
80103bb4:	85 c0                	test   %eax,%eax
80103bb6:	74 0c                	je     80103bc4 <pipealloc+0xe4>
    fileclose(*f1);
80103bb8:	83 ec 0c             	sub    $0xc,%esp
80103bbb:	50                   	push   %eax
80103bbc:	e8 7f d8 ff ff       	call   80101440 <fileclose>
80103bc1:	83 c4 10             	add    $0x10,%esp
}
80103bc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103bc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103bcc:	5b                   	pop    %ebx
80103bcd:	5e                   	pop    %esi
80103bce:	5f                   	pop    %edi
80103bcf:	5d                   	pop    %ebp
80103bd0:	c3                   	ret    
80103bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103bd8:	8b 03                	mov    (%ebx),%eax
80103bda:	85 c0                	test   %eax,%eax
80103bdc:	75 c8                	jne    80103ba6 <pipealloc+0xc6>
80103bde:	eb d2                	jmp    80103bb2 <pipealloc+0xd2>

80103be0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	56                   	push   %esi
80103be4:	53                   	push   %ebx
80103be5:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103be8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103beb:	83 ec 0c             	sub    $0xc,%esp
80103bee:	53                   	push   %ebx
80103bef:	e8 dc 1b 00 00       	call   801057d0 <acquire>
  if(writable){
80103bf4:	83 c4 10             	add    $0x10,%esp
80103bf7:	85 f6                	test   %esi,%esi
80103bf9:	74 65                	je     80103c60 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
80103bfb:	83 ec 0c             	sub    $0xc,%esp
80103bfe:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103c04:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103c0b:	00 00 00 
    wakeup(&p->nread);
80103c0e:	50                   	push   %eax
80103c0f:	e8 ac 0f 00 00       	call   80104bc0 <wakeup>
80103c14:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103c17:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103c1d:	85 d2                	test   %edx,%edx
80103c1f:	75 0a                	jne    80103c2b <pipeclose+0x4b>
80103c21:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103c27:	85 c0                	test   %eax,%eax
80103c29:	74 15                	je     80103c40 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103c2b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103c2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c31:	5b                   	pop    %ebx
80103c32:	5e                   	pop    %esi
80103c33:	5d                   	pop    %ebp
    release(&p->lock);
80103c34:	e9 37 1b 00 00       	jmp    80105770 <release>
80103c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103c40:	83 ec 0c             	sub    $0xc,%esp
80103c43:	53                   	push   %ebx
80103c44:	e8 27 1b 00 00       	call   80105770 <release>
    kfree((char*)p);
80103c49:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103c4c:	83 c4 10             	add    $0x10,%esp
}
80103c4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c52:	5b                   	pop    %ebx
80103c53:	5e                   	pop    %esi
80103c54:	5d                   	pop    %ebp
    kfree((char*)p);
80103c55:	e9 16 ef ff ff       	jmp    80102b70 <kfree>
80103c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103c60:	83 ec 0c             	sub    $0xc,%esp
80103c63:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103c69:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103c70:	00 00 00 
    wakeup(&p->nwrite);
80103c73:	50                   	push   %eax
80103c74:	e8 47 0f 00 00       	call   80104bc0 <wakeup>
80103c79:	83 c4 10             	add    $0x10,%esp
80103c7c:	eb 99                	jmp    80103c17 <pipeclose+0x37>
80103c7e:	66 90                	xchg   %ax,%ax

80103c80 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	57                   	push   %edi
80103c84:	56                   	push   %esi
80103c85:	53                   	push   %ebx
80103c86:	83 ec 28             	sub    $0x28,%esp
80103c89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103c8c:	53                   	push   %ebx
80103c8d:	e8 3e 1b 00 00       	call   801057d0 <acquire>
  for(i = 0; i < n; i++){
80103c92:	8b 45 10             	mov    0x10(%ebp),%eax
80103c95:	83 c4 10             	add    $0x10,%esp
80103c98:	85 c0                	test   %eax,%eax
80103c9a:	0f 8e c0 00 00 00    	jle    80103d60 <pipewrite+0xe0>
80103ca0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ca3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103ca9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103caf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103cb2:	03 45 10             	add    0x10(%ebp),%eax
80103cb5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103cb8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103cbe:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103cc4:	89 ca                	mov    %ecx,%edx
80103cc6:	05 00 02 00 00       	add    $0x200,%eax
80103ccb:	39 c1                	cmp    %eax,%ecx
80103ccd:	74 3f                	je     80103d0e <pipewrite+0x8e>
80103ccf:	eb 67                	jmp    80103d38 <pipewrite+0xb8>
80103cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103cd8:	e8 b3 03 00 00       	call   80104090 <myproc>
80103cdd:	8b 48 24             	mov    0x24(%eax),%ecx
80103ce0:	85 c9                	test   %ecx,%ecx
80103ce2:	75 34                	jne    80103d18 <pipewrite+0x98>
      wakeup(&p->nread);
80103ce4:	83 ec 0c             	sub    $0xc,%esp
80103ce7:	57                   	push   %edi
80103ce8:	e8 d3 0e 00 00       	call   80104bc0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103ced:	58                   	pop    %eax
80103cee:	5a                   	pop    %edx
80103cef:	53                   	push   %ebx
80103cf0:	56                   	push   %esi
80103cf1:	e8 0a 0e 00 00       	call   80104b00 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103cf6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103cfc:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103d02:	83 c4 10             	add    $0x10,%esp
80103d05:	05 00 02 00 00       	add    $0x200,%eax
80103d0a:	39 c2                	cmp    %eax,%edx
80103d0c:	75 2a                	jne    80103d38 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103d0e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103d14:	85 c0                	test   %eax,%eax
80103d16:	75 c0                	jne    80103cd8 <pipewrite+0x58>
        release(&p->lock);
80103d18:	83 ec 0c             	sub    $0xc,%esp
80103d1b:	53                   	push   %ebx
80103d1c:	e8 4f 1a 00 00       	call   80105770 <release>
        return -1;
80103d21:	83 c4 10             	add    $0x10,%esp
80103d24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d2c:	5b                   	pop    %ebx
80103d2d:	5e                   	pop    %esi
80103d2e:	5f                   	pop    %edi
80103d2f:	5d                   	pop    %ebp
80103d30:	c3                   	ret    
80103d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103d38:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103d3b:	8d 4a 01             	lea    0x1(%edx),%ecx
80103d3e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103d44:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103d4a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
80103d4d:	83 c6 01             	add    $0x1,%esi
80103d50:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103d53:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103d57:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103d5a:	0f 85 58 ff ff ff    	jne    80103cb8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103d60:	83 ec 0c             	sub    $0xc,%esp
80103d63:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103d69:	50                   	push   %eax
80103d6a:	e8 51 0e 00 00       	call   80104bc0 <wakeup>
  release(&p->lock);
80103d6f:	89 1c 24             	mov    %ebx,(%esp)
80103d72:	e8 f9 19 00 00       	call   80105770 <release>
  return n;
80103d77:	8b 45 10             	mov    0x10(%ebp),%eax
80103d7a:	83 c4 10             	add    $0x10,%esp
80103d7d:	eb aa                	jmp    80103d29 <pipewrite+0xa9>
80103d7f:	90                   	nop

80103d80 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103d80:	55                   	push   %ebp
80103d81:	89 e5                	mov    %esp,%ebp
80103d83:	57                   	push   %edi
80103d84:	56                   	push   %esi
80103d85:	53                   	push   %ebx
80103d86:	83 ec 18             	sub    $0x18,%esp
80103d89:	8b 75 08             	mov    0x8(%ebp),%esi
80103d8c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103d8f:	56                   	push   %esi
80103d90:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103d96:	e8 35 1a 00 00       	call   801057d0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103d9b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103da1:	83 c4 10             	add    $0x10,%esp
80103da4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103daa:	74 2f                	je     80103ddb <piperead+0x5b>
80103dac:	eb 37                	jmp    80103de5 <piperead+0x65>
80103dae:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103db0:	e8 db 02 00 00       	call   80104090 <myproc>
80103db5:	8b 48 24             	mov    0x24(%eax),%ecx
80103db8:	85 c9                	test   %ecx,%ecx
80103dba:	0f 85 80 00 00 00    	jne    80103e40 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103dc0:	83 ec 08             	sub    $0x8,%esp
80103dc3:	56                   	push   %esi
80103dc4:	53                   	push   %ebx
80103dc5:	e8 36 0d 00 00       	call   80104b00 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103dca:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103dd0:	83 c4 10             	add    $0x10,%esp
80103dd3:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103dd9:	75 0a                	jne    80103de5 <piperead+0x65>
80103ddb:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103de1:	85 c0                	test   %eax,%eax
80103de3:	75 cb                	jne    80103db0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103de5:	8b 55 10             	mov    0x10(%ebp),%edx
80103de8:	31 db                	xor    %ebx,%ebx
80103dea:	85 d2                	test   %edx,%edx
80103dec:	7f 20                	jg     80103e0e <piperead+0x8e>
80103dee:	eb 2c                	jmp    80103e1c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103df0:	8d 48 01             	lea    0x1(%eax),%ecx
80103df3:	25 ff 01 00 00       	and    $0x1ff,%eax
80103df8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103dfe:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103e03:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103e06:	83 c3 01             	add    $0x1,%ebx
80103e09:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103e0c:	74 0e                	je     80103e1c <piperead+0x9c>
    if(p->nread == p->nwrite)
80103e0e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103e14:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103e1a:	75 d4                	jne    80103df0 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103e1c:	83 ec 0c             	sub    $0xc,%esp
80103e1f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103e25:	50                   	push   %eax
80103e26:	e8 95 0d 00 00       	call   80104bc0 <wakeup>
  release(&p->lock);
80103e2b:	89 34 24             	mov    %esi,(%esp)
80103e2e:	e8 3d 19 00 00       	call   80105770 <release>
  return i;
80103e33:	83 c4 10             	add    $0x10,%esp
}
80103e36:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e39:	89 d8                	mov    %ebx,%eax
80103e3b:	5b                   	pop    %ebx
80103e3c:	5e                   	pop    %esi
80103e3d:	5f                   	pop    %edi
80103e3e:	5d                   	pop    %ebp
80103e3f:	c3                   	ret    
      release(&p->lock);
80103e40:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103e43:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103e48:	56                   	push   %esi
80103e49:	e8 22 19 00 00       	call   80105770 <release>
      return -1;
80103e4e:	83 c4 10             	add    $0x10,%esp
}
80103e51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e54:	89 d8                	mov    %ebx,%eax
80103e56:	5b                   	pop    %ebx
80103e57:	5e                   	pop    %esi
80103e58:	5f                   	pop    %edi
80103e59:	5d                   	pop    %ebp
80103e5a:	c3                   	ret    
80103e5b:	66 90                	xchg   %ax,%ax
80103e5d:	66 90                	xchg   %ax,%ax
80103e5f:	90                   	nop

80103e60 <wakeup1>:
static void
wakeup1(void *chan)
{
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e60:	ba 94 6b 13 80       	mov    $0x80136b94,%edx
80103e65:	eb 17                	jmp    80103e7e <wakeup1+0x1e>
80103e67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e6e:	66 90                	xchg   %ax,%ax
80103e70:	81 c2 a0 00 00 00    	add    $0xa0,%edx
80103e76:	81 fa d4 71 13 80    	cmp    $0x801371d4,%edx
80103e7c:	74 20                	je     80103e9e <wakeup1+0x3e>
    if (p->state == SLEEPING && p->chan == chan)
80103e7e:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103e82:	75 ec                	jne    80103e70 <wakeup1+0x10>
80103e84:	39 42 20             	cmp    %eax,0x20(%edx)
80103e87:	75 e7                	jne    80103e70 <wakeup1+0x10>
      p->state = RUNNABLE;
80103e89:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e90:	81 c2 a0 00 00 00    	add    $0xa0,%edx
80103e96:	81 fa d4 71 13 80    	cmp    $0x801371d4,%edx
80103e9c:	75 e0                	jne    80103e7e <wakeup1+0x1e>
}
80103e9e:	c3                   	ret    
80103e9f:	90                   	nop

80103ea0 <allocproc>:
{
80103ea0:	55                   	push   %ebp
80103ea1:	89 e5                	mov    %esp,%ebp
80103ea3:	53                   	push   %ebx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ea4:	bb 94 6b 13 80       	mov    $0x80136b94,%ebx
{
80103ea9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103eac:	68 60 6b 13 80       	push   $0x80136b60
80103eb1:	e8 1a 19 00 00       	call   801057d0 <acquire>
80103eb6:	83 c4 10             	add    $0x10,%esp
80103eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (p->state == UNUSED)
80103ec0:	8b 43 0c             	mov    0xc(%ebx),%eax
80103ec3:	85 c0                	test   %eax,%eax
80103ec5:	74 29                	je     80103ef0 <allocproc+0x50>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ec7:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80103ecd:	81 fb d4 71 13 80    	cmp    $0x801371d4,%ebx
80103ed3:	75 eb                	jne    80103ec0 <allocproc+0x20>
  release(&ptable.lock);
80103ed5:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103ed8:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103eda:	68 60 6b 13 80       	push   $0x80136b60
80103edf:	e8 8c 18 00 00       	call   80105770 <release>
  return 0;
80103ee4:	83 c4 10             	add    $0x10,%esp
}
80103ee7:	89 d8                	mov    %ebx,%eax
80103ee9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103eec:	c9                   	leave  
80103eed:	c3                   	ret    
80103eee:	66 90                	xchg   %ax,%ax
  p->pid = nextpid++;
80103ef0:	a1 04 c0 10 80       	mov    0x8010c004,%eax
  release(&ptable.lock);
80103ef5:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103ef8:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103eff:	89 43 10             	mov    %eax,0x10(%ebx)
80103f02:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103f05:	68 60 6b 13 80       	push   $0x80136b60
  p->pid = nextpid++;
80103f0a:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  release(&ptable.lock);
80103f10:	e8 5b 18 00 00       	call   80105770 <release>
  if ((p->kstack = kalloc()) == 0)
80103f15:	e8 16 ee ff ff       	call   80102d30 <kalloc>
80103f1a:	83 c4 10             	add    $0x10,%esp
80103f1d:	89 43 08             	mov    %eax,0x8(%ebx)
80103f20:	85 c0                	test   %eax,%eax
80103f22:	74 6e                	je     80103f92 <allocproc+0xf2>
  sp -= sizeof *p->tf;
80103f24:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  memset(p->context, 0, sizeof *p->context);
80103f2a:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103f2d:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103f32:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint *)sp = (uint)trapret;
80103f35:	c7 40 14 0f 6f 10 80 	movl   $0x80106f0f,0x14(%eax)
  p->context = (struct context *)sp;
80103f3c:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103f3f:	6a 14                	push   $0x14
80103f41:	6a 00                	push   $0x0
80103f43:	50                   	push   %eax
80103f44:	e8 47 19 00 00       	call   80105890 <memset>
  p->context->eip = (uint)forkret;
80103f49:	8b 43 1c             	mov    0x1c(%ebx),%eax
  memset(&p->schedule_status, 0, sizeof(p->schedule_status));
80103f4c:	83 c4 0c             	add    $0xc,%esp
  p->context->eip = (uint)forkret;
80103f4f:	c7 40 10 a0 3f 10 80 	movl   $0x80103fa0,0x10(%eax)
  memset(&p->schedule_status, 0, sizeof(p->schedule_status));
80103f56:	8d 43 7c             	lea    0x7c(%ebx),%eax
80103f59:	6a 24                	push   $0x24
80103f5b:	6a 00                	push   $0x0
80103f5d:	50                   	push   %eax
80103f5e:	e8 2d 19 00 00       	call   80105890 <memset>
  p->schedule_status.queue_id = UNSET;
80103f63:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
}
80103f6a:	89 d8                	mov    %ebx,%eax
  return p;
80103f6c:	83 c4 10             	add    $0x10,%esp
  p->schedule_status.priority = BJF_PRIORITY_DEF;
80103f6f:	c7 83 88 00 00 00 03 	movl   $0x3,0x88(%ebx)
80103f76:	00 00 00 
  p->schedule_status.priority_ratio = 1;
80103f79:	d9 e8                	fld1   
80103f7b:	d9 93 8c 00 00 00    	fsts   0x8c(%ebx)
  p->schedule_status.arrival_time_ratio = 1;
80103f81:	d9 93 94 00 00 00    	fsts   0x94(%ebx)
  p->schedule_status.executed_cycle_ratio = 1;
80103f87:	d9 9b 9c 00 00 00    	fstps  0x9c(%ebx)
}
80103f8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f90:	c9                   	leave  
80103f91:	c3                   	ret    
    p->state = UNUSED;
80103f92:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103f99:	31 db                	xor    %ebx,%ebx
80103f9b:	e9 47 ff ff ff       	jmp    80103ee7 <allocproc+0x47>

80103fa0 <forkret>:
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	83 ec 14             	sub    $0x14,%esp
  release(&ptable.lock);
80103fa6:	68 60 6b 13 80       	push   $0x80136b60
80103fab:	e8 c0 17 00 00       	call   80105770 <release>
  if (first)
80103fb0:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80103fb5:	83 c4 10             	add    $0x10,%esp
80103fb8:	85 c0                	test   %eax,%eax
80103fba:	75 04                	jne    80103fc0 <forkret+0x20>
}
80103fbc:	c9                   	leave  
80103fbd:	c3                   	ret    
80103fbe:	66 90                	xchg   %ax,%ax
    first = 0;
80103fc0:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
80103fc7:	00 00 00 
    iinit(ROOTDEV);
80103fca:	83 ec 0c             	sub    $0xc,%esp
80103fcd:	6a 01                	push   $0x1
80103fcf:	e8 5c db ff ff       	call   80101b30 <iinit>
    initlog(ROOTDEV);
80103fd4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103fdb:	e8 90 f3 ff ff       	call   80103370 <initlog>
}
80103fe0:	83 c4 10             	add    $0x10,%esp
80103fe3:	c9                   	leave  
80103fe4:	c3                   	ret    
80103fe5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ff0 <pinit>:
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103ff6:	68 c0 8f 10 80       	push   $0x80108fc0
80103ffb:	68 60 6b 13 80       	push   $0x80136b60
80104000:	e8 fb 15 00 00       	call   80105600 <initlock>
}
80104005:	83 c4 10             	add    $0x10,%esp
80104008:	c9                   	leave  
80104009:	c3                   	ret    
8010400a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104010 <mycpu>:
{
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	56                   	push   %esi
80104014:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104015:	9c                   	pushf  
80104016:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80104017:	f6 c4 02             	test   $0x2,%ah
8010401a:	75 46                	jne    80104062 <mycpu+0x52>
  apicid = lapicid();
8010401c:	e8 7f ef ff ff       	call   80102fa0 <lapicid>
  for (i = 0; i < ncpu; ++i)
80104021:	8b 35 a4 3f 11 80    	mov    0x80113fa4,%esi
80104027:	85 f6                	test   %esi,%esi
80104029:	7e 2a                	jle    80104055 <mycpu+0x45>
8010402b:	31 d2                	xor    %edx,%edx
8010402d:	eb 08                	jmp    80104037 <mycpu+0x27>
8010402f:	90                   	nop
80104030:	83 c2 01             	add    $0x1,%edx
80104033:	39 f2                	cmp    %esi,%edx
80104035:	74 1e                	je     80104055 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80104037:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010403d:	0f b6 99 c0 3f 11 80 	movzbl -0x7feec040(%ecx),%ebx
80104044:	39 c3                	cmp    %eax,%ebx
80104046:	75 e8                	jne    80104030 <mycpu+0x20>
}
80104048:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010404b:	8d 81 c0 3f 11 80    	lea    -0x7feec040(%ecx),%eax
}
80104051:	5b                   	pop    %ebx
80104052:	5e                   	pop    %esi
80104053:	5d                   	pop    %ebp
80104054:	c3                   	ret    
  panic("unknown apicid\n");
80104055:	83 ec 0c             	sub    $0xc,%esp
80104058:	68 c7 8f 10 80       	push   $0x80108fc7
8010405d:	e8 1e c3 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80104062:	83 ec 0c             	sub    $0xc,%esp
80104065:	68 c4 90 10 80       	push   $0x801090c4
8010406a:	e8 11 c3 ff ff       	call   80100380 <panic>
8010406f:	90                   	nop

80104070 <cpuid>:
{
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	83 ec 08             	sub    $0x8,%esp
  return mycpu() - cpus;
80104076:	e8 95 ff ff ff       	call   80104010 <mycpu>
}
8010407b:	c9                   	leave  
  return mycpu() - cpus;
8010407c:	2d c0 3f 11 80       	sub    $0x80113fc0,%eax
80104081:	c1 f8 04             	sar    $0x4,%eax
80104084:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010408a:	c3                   	ret    
8010408b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010408f:	90                   	nop

80104090 <myproc>:
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
80104093:	53                   	push   %ebx
80104094:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104097:	e8 e4 15 00 00       	call   80105680 <pushcli>
  c = mycpu();
8010409c:	e8 6f ff ff ff       	call   80104010 <mycpu>
  p = c->proc;
801040a1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040a7:	e8 24 16 00 00       	call   801056d0 <popcli>
}
801040ac:	89 d8                	mov    %ebx,%eax
801040ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040b1:	c9                   	leave  
801040b2:	c3                   	ret    
801040b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801040c0 <userinit>:
{
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
801040c3:	56                   	push   %esi
801040c4:	53                   	push   %ebx
  p = allocproc();
801040c5:	e8 d6 fd ff ff       	call   80103ea0 <allocproc>
801040ca:	89 c3                	mov    %eax,%ebx
  initproc = p;
801040cc:	a3 d4 71 13 80       	mov    %eax,0x801371d4
  if ((p->pgdir = setupkvm()) == 0)
801040d1:	e8 da 44 00 00       	call   801085b0 <setupkvm>
801040d6:	89 43 04             	mov    %eax,0x4(%ebx)
801040d9:	85 c0                	test   %eax,%eax
801040db:	0f 84 1e 01 00 00    	je     801041ff <userinit+0x13f>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801040e1:	83 ec 04             	sub    $0x4,%esp
801040e4:	68 2c 00 00 00       	push   $0x2c
801040e9:	68 60 c4 10 80       	push   $0x8010c460
801040ee:	50                   	push   %eax
801040ef:	e8 6c 41 00 00       	call   80108260 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801040f4:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801040f7:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801040fd:	6a 4c                	push   $0x4c
801040ff:	6a 00                	push   $0x0
80104101:	ff 73 18             	push   0x18(%ebx)
80104104:	e8 87 17 00 00       	call   80105890 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104109:	8b 43 18             	mov    0x18(%ebx),%eax
8010410c:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104111:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104114:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104119:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010411d:	8b 43 18             	mov    0x18(%ebx),%eax
80104120:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104124:	8b 43 18             	mov    0x18(%ebx),%eax
80104127:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010412b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010412f:	8b 43 18             	mov    0x18(%ebx),%eax
80104132:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104136:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010413a:	8b 43 18             	mov    0x18(%ebx),%eax
8010413d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104144:	8b 43 18             	mov    0x18(%ebx),%eax
80104147:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0; // beginning of initcode.S
8010414e:	8b 43 18             	mov    0x18(%ebx),%eax
80104151:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104158:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010415b:	6a 10                	push   $0x10
8010415d:	68 f0 8f 10 80       	push   $0x80108ff0
80104162:	50                   	push   %eax
80104163:	e8 e8 18 00 00       	call   80105a50 <safestrcpy>
  p->cwd = namei("/");
80104168:	c7 04 24 f9 8f 10 80 	movl   $0x80108ff9,(%esp)
8010416f:	e8 dc e5 ff ff       	call   80102750 <namei>
80104174:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80104177:	c7 04 24 60 6b 13 80 	movl   $0x80136b60,(%esp)
8010417e:	e8 4d 16 00 00       	call   801057d0 <acquire>
  p->state = RUNNABLE;
80104183:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
8010418a:	c7 04 24 60 6b 13 80 	movl   $0x80136b60,(%esp)
80104191:	e8 da 15 00 00       	call   80105770 <release>
  change_queue(p->pid, UNSET);
80104196:	8b 5b 10             	mov    0x10(%ebx),%ebx
  struct proc *p;
  int old_queue = -1;

  if (new_queue == UNSET)
  {
    if (pid == 1)
80104199:	83 c4 10             	add    $0x10,%esp
8010419c:	83 fb 01             	cmp    $0x1,%ebx
8010419f:	74 57                	je     801041f8 <userinit+0x138>
      new_queue = ROUND_ROBIN;
    else if (pid > 1)
801041a1:	7e 3e                	jle    801041e1 <userinit+0x121>
      new_queue = LCFS;
801041a3:	be 02 00 00 00       	mov    $0x2,%esi
    else
      return -1;
  }

  acquire(&ptable.lock);
801041a8:	83 ec 0c             	sub    $0xc,%esp
801041ab:	68 60 6b 13 80       	push   $0x80136b60
801041b0:	e8 1b 16 00 00       	call   801057d0 <acquire>
801041b5:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041b8:	b8 94 6b 13 80       	mov    $0x80136b94,%eax
801041bd:	8d 76 00             	lea    0x0(%esi),%esi
  {
    if (p->pid == pid)
801041c0:	3b 58 10             	cmp    0x10(%eax),%ebx
801041c3:	74 2b                	je     801041f0 <userinit+0x130>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041c5:	05 a0 00 00 00       	add    $0xa0,%eax
801041ca:	3d d4 71 13 80       	cmp    $0x801371d4,%eax
801041cf:	75 ef                	jne    801041c0 <userinit+0x100>
      old_queue = p->schedule_status.queue_id;
      p->schedule_status.queue_id = new_queue;
      break;
    }
  }
  release(&ptable.lock);
801041d1:	83 ec 0c             	sub    $0xc,%esp
801041d4:	68 60 6b 13 80       	push   $0x80136b60
801041d9:	e8 92 15 00 00       	call   80105770 <release>
  return old_queue;
801041de:	83 c4 10             	add    $0x10,%esp
}
801041e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041e4:	5b                   	pop    %ebx
801041e5:	5e                   	pop    %esi
801041e6:	5d                   	pop    %ebp
801041e7:	c3                   	ret    
801041e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041ef:	90                   	nop
      p->schedule_status.queue_id = new_queue;
801041f0:	89 70 7c             	mov    %esi,0x7c(%eax)
      break;
801041f3:	eb dc                	jmp    801041d1 <userinit+0x111>
801041f5:	8d 76 00             	lea    0x0(%esi),%esi
      new_queue = ROUND_ROBIN;
801041f8:	be 01 00 00 00       	mov    $0x1,%esi
801041fd:	eb a9                	jmp    801041a8 <userinit+0xe8>
    panic("userinit: out of memory?");
801041ff:	83 ec 0c             	sub    $0xc,%esp
80104202:	68 d7 8f 10 80       	push   $0x80108fd7
80104207:	e8 74 c1 ff ff       	call   80100380 <panic>
8010420c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104210 <growproc>:
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	56                   	push   %esi
80104214:	53                   	push   %ebx
80104215:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80104218:	e8 63 14 00 00       	call   80105680 <pushcli>
  c = mycpu();
8010421d:	e8 ee fd ff ff       	call   80104010 <mycpu>
  p = c->proc;
80104222:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104228:	e8 a3 14 00 00       	call   801056d0 <popcli>
  sz = curproc->sz;
8010422d:	8b 03                	mov    (%ebx),%eax
  if (n > 0)
8010422f:	85 f6                	test   %esi,%esi
80104231:	7f 1d                	jg     80104250 <growproc+0x40>
  else if (n < 0)
80104233:	75 3b                	jne    80104270 <growproc+0x60>
  switchuvm(curproc);
80104235:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80104238:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010423a:	53                   	push   %ebx
8010423b:	e8 10 3f 00 00       	call   80108150 <switchuvm>
  return 0;
80104240:	83 c4 10             	add    $0x10,%esp
80104243:	31 c0                	xor    %eax,%eax
}
80104245:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104248:	5b                   	pop    %ebx
80104249:	5e                   	pop    %esi
8010424a:	5d                   	pop    %ebp
8010424b:	c3                   	ret    
8010424c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104250:	83 ec 04             	sub    $0x4,%esp
80104253:	01 c6                	add    %eax,%esi
80104255:	56                   	push   %esi
80104256:	50                   	push   %eax
80104257:	ff 73 04             	push   0x4(%ebx)
8010425a:	e8 71 41 00 00       	call   801083d0 <allocuvm>
8010425f:	83 c4 10             	add    $0x10,%esp
80104262:	85 c0                	test   %eax,%eax
80104264:	75 cf                	jne    80104235 <growproc+0x25>
      return -1;
80104266:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010426b:	eb d8                	jmp    80104245 <growproc+0x35>
8010426d:	8d 76 00             	lea    0x0(%esi),%esi
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104270:	83 ec 04             	sub    $0x4,%esp
80104273:	01 c6                	add    %eax,%esi
80104275:	56                   	push   %esi
80104276:	50                   	push   %eax
80104277:	ff 73 04             	push   0x4(%ebx)
8010427a:	e8 81 42 00 00       	call   80108500 <deallocuvm>
8010427f:	83 c4 10             	add    $0x10,%esp
80104282:	85 c0                	test   %eax,%eax
80104284:	75 af                	jne    80104235 <growproc+0x25>
80104286:	eb de                	jmp    80104266 <growproc+0x56>
80104288:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010428f:	90                   	nop

80104290 <fork>:
{
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	57                   	push   %edi
80104294:	56                   	push   %esi
80104295:	53                   	push   %ebx
80104296:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104299:	e8 e2 13 00 00       	call   80105680 <pushcli>
  c = mycpu();
8010429e:	e8 6d fd ff ff       	call   80104010 <mycpu>
  p = c->proc;
801042a3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042a9:	e8 22 14 00 00       	call   801056d0 <popcli>
  if ((np = allocproc()) == 0)
801042ae:	e8 ed fb ff ff       	call   80103ea0 <allocproc>
801042b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801042b6:	85 c0                	test   %eax,%eax
801042b8:	0f 84 41 01 00 00    	je     801043ff <fork+0x16f>
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
801042be:	83 ec 08             	sub    $0x8,%esp
801042c1:	ff 33                	push   (%ebx)
801042c3:	89 c7                	mov    %eax,%edi
801042c5:	ff 73 04             	push   0x4(%ebx)
801042c8:	e8 d3 43 00 00       	call   801086a0 <copyuvm>
801042cd:	83 c4 10             	add    $0x10,%esp
801042d0:	89 47 04             	mov    %eax,0x4(%edi)
801042d3:	85 c0                	test   %eax,%eax
801042d5:	0f 84 2b 01 00 00    	je     80104406 <fork+0x176>
  np->sz = curproc->sz;
801042db:	8b 03                	mov    (%ebx),%eax
801042dd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801042e0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
801042e2:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
801042e5:	89 c8                	mov    %ecx,%eax
801042e7:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801042ea:	b9 13 00 00 00       	mov    $0x13,%ecx
801042ef:	8b 73 18             	mov    0x18(%ebx),%esi
801042f2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for (i = 0; i < NOFILE; i++)
801042f4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801042f6:	8b 40 18             	mov    0x18(%eax),%eax
801042f9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if (curproc->ofile[i])
80104300:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104304:	85 c0                	test   %eax,%eax
80104306:	74 13                	je     8010431b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104308:	83 ec 0c             	sub    $0xc,%esp
8010430b:	50                   	push   %eax
8010430c:	e8 df d0 ff ff       	call   801013f0 <filedup>
80104311:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104314:	83 c4 10             	add    $0x10,%esp
80104317:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for (i = 0; i < NOFILE; i++)
8010431b:	83 c6 01             	add    $0x1,%esi
8010431e:	83 fe 10             	cmp    $0x10,%esi
80104321:	75 dd                	jne    80104300 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80104323:	83 ec 0c             	sub    $0xc,%esp
80104326:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104329:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
8010432c:	e8 ef d9 ff ff       	call   80101d20 <idup>
80104331:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104334:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104337:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010433a:	8d 47 6c             	lea    0x6c(%edi),%eax
8010433d:	6a 10                	push   $0x10
8010433f:	53                   	push   %ebx
80104340:	50                   	push   %eax
80104341:	e8 0a 17 00 00       	call   80105a50 <safestrcpy>
  pid = np->pid;
80104346:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104349:	c7 04 24 60 6b 13 80 	movl   $0x80136b60,(%esp)
80104350:	e8 7b 14 00 00       	call   801057d0 <acquire>
  np->state = RUNNABLE;
80104355:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  acquire(&tickslock);
8010435c:	c7 04 24 00 72 13 80 	movl   $0x80137200,(%esp)
80104363:	e8 68 14 00 00       	call   801057d0 <acquire>
  np->schedule_status.last_run = ticks;
80104368:	a1 e0 71 13 80       	mov    0x801371e0,%eax
8010436d:	89 87 84 00 00 00    	mov    %eax,0x84(%edi)
  np->schedule_status.arrival_time = ticks;
80104373:	89 87 90 00 00 00    	mov    %eax,0x90(%edi)
  release(&tickslock);
80104379:	c7 04 24 00 72 13 80 	movl   $0x80137200,(%esp)
80104380:	e8 eb 13 00 00       	call   80105770 <release>
  release(&ptable.lock);
80104385:	c7 04 24 60 6b 13 80 	movl   $0x80136b60,(%esp)
8010438c:	e8 df 13 00 00       	call   80105770 <release>
  change_queue(np->pid, UNSET);
80104391:	8b 7f 10             	mov    0x10(%edi),%edi
    if (pid == 1)
80104394:	83 c4 10             	add    $0x10,%esp
80104397:	83 ff 01             	cmp    $0x1,%edi
8010439a:	74 5c                	je     801043f8 <fork+0x168>
    else if (pid > 1)
8010439c:	7e 43                	jle    801043e1 <fork+0x151>
      new_queue = LCFS;
8010439e:	be 02 00 00 00       	mov    $0x2,%esi
  acquire(&ptable.lock);
801043a3:	83 ec 0c             	sub    $0xc,%esp
801043a6:	68 60 6b 13 80       	push   $0x80136b60
801043ab:	e8 20 14 00 00       	call   801057d0 <acquire>
801043b0:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043b3:	b8 94 6b 13 80       	mov    $0x80136b94,%eax
801043b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043bf:	90                   	nop
    if (p->pid == pid)
801043c0:	3b 78 10             	cmp    0x10(%eax),%edi
801043c3:	74 2b                	je     801043f0 <fork+0x160>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043c5:	05 a0 00 00 00       	add    $0xa0,%eax
801043ca:	3d d4 71 13 80       	cmp    $0x801371d4,%eax
801043cf:	75 ef                	jne    801043c0 <fork+0x130>
  release(&ptable.lock);
801043d1:	83 ec 0c             	sub    $0xc,%esp
801043d4:	68 60 6b 13 80       	push   $0x80136b60
801043d9:	e8 92 13 00 00       	call   80105770 <release>
  return old_queue;
801043de:	83 c4 10             	add    $0x10,%esp
}
801043e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043e4:	89 d8                	mov    %ebx,%eax
801043e6:	5b                   	pop    %ebx
801043e7:	5e                   	pop    %esi
801043e8:	5f                   	pop    %edi
801043e9:	5d                   	pop    %ebp
801043ea:	c3                   	ret    
801043eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043ef:	90                   	nop
      p->schedule_status.queue_id = new_queue;
801043f0:	89 70 7c             	mov    %esi,0x7c(%eax)
      break;
801043f3:	eb dc                	jmp    801043d1 <fork+0x141>
801043f5:	8d 76 00             	lea    0x0(%esi),%esi
      new_queue = ROUND_ROBIN;
801043f8:	be 01 00 00 00       	mov    $0x1,%esi
801043fd:	eb a4                	jmp    801043a3 <fork+0x113>
    return -1;
801043ff:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104404:	eb db                	jmp    801043e1 <fork+0x151>
    kfree(np->kstack);
80104406:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104409:	83 ec 0c             	sub    $0xc,%esp
8010440c:	ff 73 08             	push   0x8(%ebx)
8010440f:	e8 5c e7 ff ff       	call   80102b70 <kfree>
    np->kstack = 0;
80104414:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
8010441b:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
8010441e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104425:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010442a:	eb b5                	jmp    801043e1 <fork+0x151>
8010442c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104430 <ageprocs>:
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	57                   	push   %edi
80104434:	56                   	push   %esi
80104435:	53                   	push   %ebx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104436:	bb 94 6b 13 80       	mov    $0x80136b94,%ebx
{
8010443b:	83 ec 18             	sub    $0x18,%esp
8010443e:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&ptable.lock);
80104441:	68 60 6b 13 80       	push   $0x80136b60
80104446:	e8 85 13 00 00       	call   801057d0 <acquire>
8010444b:	83 c4 10             	add    $0x10,%esp
8010444e:	eb 0e                	jmp    8010445e <ageprocs+0x2e>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104450:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80104456:	81 fb d4 71 13 80    	cmp    $0x801371d4,%ebx
8010445c:	74 7d                	je     801044db <ageprocs+0xab>
    if (p->state == RUNNABLE && p->schedule_status.queue_id != ROUND_ROBIN)
8010445e:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104462:	75 ec                	jne    80104450 <ageprocs+0x20>
80104464:	83 7b 7c 01          	cmpl   $0x1,0x7c(%ebx)
80104468:	74 e6                	je     80104450 <ageprocs+0x20>
      if (osTicks - p->schedule_status.last_run > AGING_THRESHOLD)
8010446a:	89 f0                	mov    %esi,%eax
8010446c:	2b 83 84 00 00 00    	sub    0x84(%ebx),%eax
80104472:	3d 40 1f 00 00       	cmp    $0x1f40,%eax
80104477:	7e d7                	jle    80104450 <ageprocs+0x20>
        release(&ptable.lock);
80104479:	83 ec 0c             	sub    $0xc,%esp
8010447c:	68 60 6b 13 80       	push   $0x80136b60
80104481:	e8 ea 12 00 00       	call   80105770 <release>
  acquire(&ptable.lock);
80104486:	c7 04 24 60 6b 13 80 	movl   $0x80136b60,(%esp)
        change_queue(p->pid, ROUND_ROBIN);
8010448d:	8b 7b 10             	mov    0x10(%ebx),%edi
  acquire(&ptable.lock);
80104490:	e8 3b 13 00 00       	call   801057d0 <acquire>
80104495:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104498:	b8 94 6b 13 80       	mov    $0x80136b94,%eax
8010449d:	8d 76 00             	lea    0x0(%esi),%esi
    if (p->pid == pid)
801044a0:	3b 78 10             	cmp    0x10(%eax),%edi
801044a3:	74 4b                	je     801044f0 <ageprocs+0xc0>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044a5:	05 a0 00 00 00       	add    $0xa0,%eax
801044aa:	3d d4 71 13 80       	cmp    $0x801371d4,%eax
801044af:	75 ef                	jne    801044a0 <ageprocs+0x70>
  release(&ptable.lock);
801044b1:	83 ec 0c             	sub    $0xc,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044b4:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
  release(&ptable.lock);
801044ba:	68 60 6b 13 80       	push   $0x80136b60
801044bf:	e8 ac 12 00 00       	call   80105770 <release>
        acquire(&ptable.lock);
801044c4:	c7 04 24 60 6b 13 80 	movl   $0x80136b60,(%esp)
801044cb:	e8 00 13 00 00       	call   801057d0 <acquire>
801044d0:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044d3:	81 fb d4 71 13 80    	cmp    $0x801371d4,%ebx
801044d9:	75 83                	jne    8010445e <ageprocs+0x2e>
  release(&ptable.lock);
801044db:	c7 45 08 60 6b 13 80 	movl   $0x80136b60,0x8(%ebp)
}
801044e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044e5:	5b                   	pop    %ebx
801044e6:	5e                   	pop    %esi
801044e7:	5f                   	pop    %edi
801044e8:	5d                   	pop    %ebp
  release(&ptable.lock);
801044e9:	e9 82 12 00 00       	jmp    80105770 <release>
801044ee:	66 90                	xchg   %ax,%ax
      p->schedule_status.queue_id = new_queue;
801044f0:	c7 40 7c 01 00 00 00 	movl   $0x1,0x7c(%eax)
      break;
801044f7:	eb b8                	jmp    801044b1 <ageprocs+0x81>
801044f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104500 <roundrobin>:
{
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	53                   	push   %ebx
      i = 0;
80104504:	31 db                	xor    %ebx,%ebx
{
80104506:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int i = lastScheduledIdx;
80104509:	89 c8                	mov    %ecx,%eax
8010450b:	eb 07                	jmp    80104514 <roundrobin+0x14>
8010450d:	8d 76 00             	lea    0x0(%esi),%esi
    if (i == lastScheduledIdx)
80104510:	39 c8                	cmp    %ecx,%eax
80104512:	74 34                	je     80104548 <roundrobin+0x48>
    i++;
80104514:	83 c0 01             	add    $0x1,%eax
      i = 0;
80104517:	83 f8 0a             	cmp    $0xa,%eax
8010451a:	0f 4d c3             	cmovge %ebx,%eax
    if (p->state == RUNNABLE && p->schedule_status.queue_id == ROUND_ROBIN)
8010451d:	8d 14 80             	lea    (%eax,%eax,4),%edx
80104520:	c1 e2 05             	shl    $0x5,%edx
80104523:	83 ba a0 6b 13 80 03 	cmpl   $0x3,-0x7fec9460(%edx)
8010452a:	75 e4                	jne    80104510 <roundrobin+0x10>
8010452c:	8d 54 80 05          	lea    0x5(%eax,%eax,4),%edx
80104530:	c1 e2 05             	shl    $0x5,%edx
80104533:	83 ba 70 6b 13 80 01 	cmpl   $0x1,-0x7fec9490(%edx)
8010453a:	75 d4                	jne    80104510 <roundrobin+0x10>
}
8010453c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010453f:	c9                   	leave  
80104540:	c3                   	ret    
80104541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104548:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010454b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104550:	c9                   	leave  
80104551:	c3                   	ret    
80104552:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104560 <bestjobfirst>:
{
80104560:	d9 05 b4 91 10 80    	flds   0x801091b4
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104566:	b8 94 6b 13 80       	mov    $0x80136b94,%eax
  struct proc *result = 0;
8010456b:	31 d2                	xor    %edx,%edx
8010456d:	8d 76 00             	lea    0x0(%esi),%esi
    if (p->state != RUNNABLE || p->schedule_status.queue_id != BJF)
80104570:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104574:	75 52                	jne    801045c8 <bestjobfirst+0x68>
80104576:	83 78 7c 03          	cmpl   $0x3,0x7c(%eax)
8010457a:	75 4c                	jne    801045c8 <bestjobfirst+0x68>
  return p->schedule_status.priority * p->schedule_status.priority_ratio +
8010457c:	db 80 88 00 00 00    	fildl  0x88(%eax)
80104582:	d8 88 8c 00 00 00    	fmuls  0x8c(%eax)
         p->schedule_status.arrival_time * p->schedule_status.arrival_time_ratio +
80104588:	db 80 90 00 00 00    	fildl  0x90(%eax)
8010458e:	d8 88 94 00 00 00    	fmuls  0x94(%eax)
  return p->schedule_status.priority * p->schedule_status.priority_ratio +
80104594:	de c1                	faddp  %st,%st(1)
         p->schedule_status.executed_cycle * p->schedule_status.executed_cycle_ratio;
80104596:	d9 80 98 00 00 00    	flds   0x98(%eax)
8010459c:	d8 88 9c 00 00 00    	fmuls  0x9c(%eax)
         p->schedule_status.arrival_time * p->schedule_status.arrival_time_ratio +
801045a2:	de c1                	faddp  %st,%st(1)
    if (result == 0 || rank < minrank)
801045a4:	85 d2                	test   %edx,%edx
801045a6:	74 10                	je     801045b8 <bestjobfirst+0x58>
801045a8:	d9 c9                	fxch   %st(1)
801045aa:	db f1                	fcomi  %st(1),%st
801045ac:	76 12                	jbe    801045c0 <bestjobfirst+0x60>
801045ae:	dd d8                	fstp   %st(0)
801045b0:	eb 08                	jmp    801045ba <bestjobfirst+0x5a>
801045b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045b8:	dd d9                	fstp   %st(1)
801045ba:	89 c2                	mov    %eax,%edx
801045bc:	eb 0a                	jmp    801045c8 <bestjobfirst+0x68>
801045be:	66 90                	xchg   %ax,%ax
801045c0:	dd d9                	fstp   %st(1)
801045c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045c8:	05 a0 00 00 00       	add    $0xa0,%eax
801045cd:	3d d4 71 13 80       	cmp    $0x801371d4,%eax
801045d2:	75 9c                	jne    80104570 <bestjobfirst+0x10>
801045d4:	dd d8                	fstp   %st(0)
}
801045d6:	89 d0                	mov    %edx,%eax
801045d8:	c3                   	ret    
801045d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801045e0 <lcfs>:
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045e0:	b8 94 6b 13 80       	mov    $0x80136b94,%eax
  float max_arrival_time = 0;
801045e5:	d9 ee                	fldz   
  struct proc *resultt = 0;
801045e7:	31 d2                	xor    %edx,%edx
801045e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (p->state != RUNNABLE || p->schedule_status.queue_id != LCFS)
801045f0:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801045f4:	75 32                	jne    80104628 <lcfs+0x48>
801045f6:	83 78 7c 02          	cmpl   $0x2,0x7c(%eax)
801045fa:	75 2c                	jne    80104628 <lcfs+0x48>
    float arrival_time = p->schedule_status.arrival_time;
801045fc:	db 80 90 00 00 00    	fildl  0x90(%eax)
    if (resultt == 0 || arrival_time > max_arrival_time)
80104602:	85 d2                	test   %edx,%edx
80104604:	74 0a                	je     80104610 <lcfs+0x30>
80104606:	db f1                	fcomi  %st(1),%st
80104608:	76 16                	jbe    80104620 <lcfs+0x40>
8010460a:	dd d9                	fstp   %st(1)
8010460c:	eb 04                	jmp    80104612 <lcfs+0x32>
8010460e:	66 90                	xchg   %ax,%ax
80104610:	dd d9                	fstp   %st(1)
80104612:	89 c2                	mov    %eax,%edx
80104614:	eb 12                	jmp    80104628 <lcfs+0x48>
80104616:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010461d:	8d 76 00             	lea    0x0(%esi),%esi
80104620:	dd d8                	fstp   %st(0)
80104622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104628:	05 a0 00 00 00       	add    $0xa0,%eax
8010462d:	3d d4 71 13 80       	cmp    $0x801371d4,%eax
80104632:	75 bc                	jne    801045f0 <lcfs+0x10>
80104634:	dd d8                	fstp   %st(0)
}
80104636:	89 d0                	mov    %edx,%eax
80104638:	c3                   	ret    
80104639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104640 <scheduler>:
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	57                   	push   %edi
      i = 0;
80104644:	31 ff                	xor    %edi,%edi
{
80104646:	56                   	push   %esi
  int lastScheduledIdx = NPROC - 1;
80104647:	be 09 00 00 00       	mov    $0x9,%esi
{
8010464c:	53                   	push   %ebx
8010464d:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80104650:	e8 bb f9 ff ff       	call   80104010 <mycpu>
  srand(ticks);
80104655:	83 ec 0c             	sub    $0xc,%esp
  c->proc = 0;
80104658:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010465f:	00 00 00 
  struct cpu *c = mycpu();
80104662:	89 c3                	mov    %eax,%ebx
  srand(ticks);
80104664:	ff 35 e0 71 13 80    	push   0x801371e0
8010466a:	e8 91 2d 00 00       	call   80107400 <srand>
8010466f:	8d 43 04             	lea    0x4(%ebx),%eax
80104672:	83 c4 10             	add    $0x10,%esp
80104675:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104678:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010467f:	90                   	nop
  asm volatile("sti");
80104680:	fb                   	sti    
    acquire(&ptable.lock);
80104681:	83 ec 0c             	sub    $0xc,%esp
80104684:	68 60 6b 13 80       	push   $0x80136b60
80104689:	e8 42 11 00 00       	call   801057d0 <acquire>
8010468e:	83 c4 10             	add    $0x10,%esp
80104691:	89 f0                	mov    %esi,%eax
80104693:	eb 0b                	jmp    801046a0 <scheduler+0x60>
80104695:	8d 76 00             	lea    0x0(%esi),%esi
    if (i == lastScheduledIdx)
80104698:	39 c6                	cmp    %eax,%esi
8010469a:	0f 84 a0 00 00 00    	je     80104740 <scheduler+0x100>
    i++;
801046a0:	83 c0 01             	add    $0x1,%eax
      i = 0;
801046a3:	83 f8 0a             	cmp    $0xa,%eax
801046a6:	0f 4d c7             	cmovge %edi,%eax
    if (p->state == RUNNABLE && p->schedule_status.queue_id == ROUND_ROBIN)
801046a9:	8d 14 80             	lea    (%eax,%eax,4),%edx
801046ac:	c1 e2 05             	shl    $0x5,%edx
801046af:	83 ba a0 6b 13 80 03 	cmpl   $0x3,-0x7fec9460(%edx)
801046b6:	75 e0                	jne    80104698 <scheduler+0x58>
801046b8:	8d 4c 80 05          	lea    0x5(%eax,%eax,4),%ecx
801046bc:	c1 e1 05             	shl    $0x5,%ecx
801046bf:	83 b9 70 6b 13 80 01 	cmpl   $0x1,-0x7fec9490(%ecx)
801046c6:	75 d0                	jne    80104698 <scheduler+0x58>
    if (idx == -1)
801046c8:	83 f8 ff             	cmp    $0xffffffff,%eax
801046cb:	74 73                	je     80104740 <scheduler+0x100>
      p = &ptable.proc[idx];
801046cd:	81 c2 94 6b 13 80    	add    $0x80136b94,%edx
801046d3:	89 c6                	mov    %eax,%esi
    switchuvm(p);
801046d5:	83 ec 0c             	sub    $0xc,%esp
    c->proc = p;
801046d8:	89 93 ac 00 00 00    	mov    %edx,0xac(%ebx)
    switchuvm(p);
801046de:	52                   	push   %edx
801046df:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801046e2:	e8 69 3a 00 00       	call   80108150 <switchuvm>
    p->state = RUNNING;
801046e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    p->schedule_status.executed_cycle += 0.1f;
801046ea:	d9 05 b8 91 10 80    	flds   0x801091b8
    p->schedule_status.last_run = ticks;
801046f0:	a1 e0 71 13 80       	mov    0x801371e0,%eax
    p->schedule_status.executed_cycle += 0.1f;
801046f5:	d8 82 98 00 00 00    	fadds  0x98(%edx)
    p->state = RUNNING;
801046fb:	c7 42 0c 04 00 00 00 	movl   $0x4,0xc(%edx)
    p->schedule_status.last_run = ticks;
80104702:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
    p->schedule_status.executed_cycle += 0.1f;
80104708:	d9 9a 98 00 00 00    	fstps  0x98(%edx)
    swtch(&(c->scheduler), p->context);
8010470e:	58                   	pop    %eax
8010470f:	59                   	pop    %ecx
80104710:	ff 72 1c             	push   0x1c(%edx)
80104713:	ff 75 e0             	push   -0x20(%ebp)
80104716:	e8 90 13 00 00       	call   80105aab <swtch>
    switchkvm();
8010471b:	e8 20 3a 00 00       	call   80108140 <switchkvm>
    c->proc = 0;
80104720:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80104727:	00 00 00 
    release(&ptable.lock);
8010472a:	c7 04 24 60 6b 13 80 	movl   $0x80136b60,(%esp)
80104731:	e8 3a 10 00 00       	call   80105770 <release>
80104736:	83 c4 10             	add    $0x10,%esp
80104739:	e9 42 ff ff ff       	jmp    80104680 <scheduler+0x40>
8010473e:	66 90                	xchg   %ax,%ax
80104740:	d9 ee                	fldz   
80104742:	31 d2                	xor    %edx,%edx
80104744:	b8 94 6b 13 80       	mov    $0x80136b94,%eax
80104749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (p->state != RUNNABLE || p->schedule_status.queue_id != LCFS)
80104750:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104754:	75 32                	jne    80104788 <scheduler+0x148>
80104756:	83 78 7c 02          	cmpl   $0x2,0x7c(%eax)
8010475a:	75 2c                	jne    80104788 <scheduler+0x148>
    float arrival_time = p->schedule_status.arrival_time;
8010475c:	db 80 90 00 00 00    	fildl  0x90(%eax)
    if (resultt == 0 || arrival_time > max_arrival_time)
80104762:	85 d2                	test   %edx,%edx
80104764:	74 0a                	je     80104770 <scheduler+0x130>
80104766:	db f1                	fcomi  %st(1),%st
80104768:	76 16                	jbe    80104780 <scheduler+0x140>
8010476a:	dd d9                	fstp   %st(1)
8010476c:	eb 04                	jmp    80104772 <scheduler+0x132>
8010476e:	66 90                	xchg   %ax,%ax
80104770:	dd d9                	fstp   %st(1)
80104772:	89 c2                	mov    %eax,%edx
80104774:	eb 12                	jmp    80104788 <scheduler+0x148>
80104776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010477d:	8d 76 00             	lea    0x0(%esi),%esi
80104780:	dd d8                	fstp   %st(0)
80104782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104788:	05 a0 00 00 00       	add    $0xa0,%eax
8010478d:	3d d4 71 13 80       	cmp    $0x801371d4,%eax
80104792:	75 bc                	jne    80104750 <scheduler+0x110>
80104794:	dd d8                	fstp   %st(0)
      if (p == NULL)
80104796:	85 d2                	test   %edx,%edx
80104798:	0f 85 37 ff ff ff    	jne    801046d5 <scheduler+0x95>
        p = bestjobfirst();
8010479e:	e8 bd fd ff ff       	call   80104560 <bestjobfirst>
801047a3:	89 c2                	mov    %eax,%edx
        if (p == NULL)
801047a5:	85 c0                	test   %eax,%eax
801047a7:	0f 85 28 ff ff ff    	jne    801046d5 <scheduler+0x95>
          release(&ptable.lock);
801047ad:	83 ec 0c             	sub    $0xc,%esp
801047b0:	68 60 6b 13 80       	push   $0x80136b60
801047b5:	e8 b6 0f 00 00       	call   80105770 <release>
          continue;
801047ba:	83 c4 10             	add    $0x10,%esp
801047bd:	e9 be fe ff ff       	jmp    80104680 <scheduler+0x40>
801047c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801047d0 <sched>:
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	56                   	push   %esi
801047d4:	53                   	push   %ebx
  pushcli();
801047d5:	e8 a6 0e 00 00       	call   80105680 <pushcli>
  c = mycpu();
801047da:	e8 31 f8 ff ff       	call   80104010 <mycpu>
  p = c->proc;
801047df:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801047e5:	e8 e6 0e 00 00       	call   801056d0 <popcli>
  if (!holding(&ptable.lock))
801047ea:	83 ec 0c             	sub    $0xc,%esp
801047ed:	68 60 6b 13 80       	push   $0x80136b60
801047f2:	e8 39 0f 00 00       	call   80105730 <holding>
801047f7:	83 c4 10             	add    $0x10,%esp
801047fa:	85 c0                	test   %eax,%eax
801047fc:	74 4f                	je     8010484d <sched+0x7d>
  if (mycpu()->ncli != 1)
801047fe:	e8 0d f8 ff ff       	call   80104010 <mycpu>
80104803:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010480a:	75 68                	jne    80104874 <sched+0xa4>
  if (p->state == RUNNING)
8010480c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104810:	74 55                	je     80104867 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104812:	9c                   	pushf  
80104813:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80104814:	f6 c4 02             	test   $0x2,%ah
80104817:	75 41                	jne    8010485a <sched+0x8a>
  intena = mycpu()->intena;
80104819:	e8 f2 f7 ff ff       	call   80104010 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010481e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104821:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104827:	e8 e4 f7 ff ff       	call   80104010 <mycpu>
8010482c:	83 ec 08             	sub    $0x8,%esp
8010482f:	ff 70 04             	push   0x4(%eax)
80104832:	53                   	push   %ebx
80104833:	e8 73 12 00 00       	call   80105aab <swtch>
  mycpu()->intena = intena;
80104838:	e8 d3 f7 ff ff       	call   80104010 <mycpu>
}
8010483d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104840:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104846:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104849:	5b                   	pop    %ebx
8010484a:	5e                   	pop    %esi
8010484b:	5d                   	pop    %ebp
8010484c:	c3                   	ret    
    panic("sched ptable.lock");
8010484d:	83 ec 0c             	sub    $0xc,%esp
80104850:	68 fb 8f 10 80       	push   $0x80108ffb
80104855:	e8 26 bb ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010485a:	83 ec 0c             	sub    $0xc,%esp
8010485d:	68 27 90 10 80       	push   $0x80109027
80104862:	e8 19 bb ff ff       	call   80100380 <panic>
    panic("sched running");
80104867:	83 ec 0c             	sub    $0xc,%esp
8010486a:	68 19 90 10 80       	push   $0x80109019
8010486f:	e8 0c bb ff ff       	call   80100380 <panic>
    panic("sched locks");
80104874:	83 ec 0c             	sub    $0xc,%esp
80104877:	68 0d 90 10 80       	push   $0x8010900d
8010487c:	e8 ff ba ff ff       	call   80100380 <panic>
80104881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104888:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010488f:	90                   	nop

80104890 <exit>:
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	57                   	push   %edi
80104894:	56                   	push   %esi
80104895:	53                   	push   %ebx
80104896:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104899:	e8 f2 f7 ff ff       	call   80104090 <myproc>
  if (curproc == initproc)
8010489e:	39 05 d4 71 13 80    	cmp    %eax,0x801371d4
801048a4:	0f 84 af 00 00 00    	je     80104959 <exit+0xc9>
801048aa:	89 c6                	mov    %eax,%esi
801048ac:	8d 58 28             	lea    0x28(%eax),%ebx
801048af:	8d 78 68             	lea    0x68(%eax),%edi
801048b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (curproc->ofile[fd])
801048b8:	8b 03                	mov    (%ebx),%eax
801048ba:	85 c0                	test   %eax,%eax
801048bc:	74 12                	je     801048d0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
801048be:	83 ec 0c             	sub    $0xc,%esp
801048c1:	50                   	push   %eax
801048c2:	e8 79 cb ff ff       	call   80101440 <fileclose>
      curproc->ofile[fd] = 0;
801048c7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801048cd:	83 c4 10             	add    $0x10,%esp
  for (fd = 0; fd < NOFILE; fd++)
801048d0:	83 c3 04             	add    $0x4,%ebx
801048d3:	39 fb                	cmp    %edi,%ebx
801048d5:	75 e1                	jne    801048b8 <exit+0x28>
  begin_op();
801048d7:	e8 34 eb ff ff       	call   80103410 <begin_op>
  iput(curproc->cwd);
801048dc:	83 ec 0c             	sub    $0xc,%esp
801048df:	ff 76 68             	push   0x68(%esi)
801048e2:	e8 99 d5 ff ff       	call   80101e80 <iput>
  end_op();
801048e7:	e8 94 eb ff ff       	call   80103480 <end_op>
  curproc->cwd = 0;
801048ec:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
801048f3:	c7 04 24 60 6b 13 80 	movl   $0x80136b60,(%esp)
801048fa:	e8 d1 0e 00 00       	call   801057d0 <acquire>
  wakeup1(curproc->parent);
801048ff:	8b 46 14             	mov    0x14(%esi),%eax
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104902:	b9 94 6b 13 80       	mov    $0x80136b94,%ecx
  wakeup1(curproc->parent);
80104907:	e8 54 f5 ff ff       	call   80103e60 <wakeup1>
8010490c:	83 c4 10             	add    $0x10,%esp
8010490f:	eb 15                	jmp    80104926 <exit+0x96>
80104911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104918:	81 c1 a0 00 00 00    	add    $0xa0,%ecx
8010491e:	81 f9 d4 71 13 80    	cmp    $0x801371d4,%ecx
80104924:	74 1a                	je     80104940 <exit+0xb0>
    if (p->parent == curproc)
80104926:	39 71 14             	cmp    %esi,0x14(%ecx)
80104929:	75 ed                	jne    80104918 <exit+0x88>
      p->parent = initproc;
8010492b:	a1 d4 71 13 80       	mov    0x801371d4,%eax
      if (p->state == ZOMBIE)
80104930:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
      p->parent = initproc;
80104934:	89 41 14             	mov    %eax,0x14(%ecx)
      if (p->state == ZOMBIE)
80104937:	75 df                	jne    80104918 <exit+0x88>
        wakeup1(initproc);
80104939:	e8 22 f5 ff ff       	call   80103e60 <wakeup1>
8010493e:	eb d8                	jmp    80104918 <exit+0x88>
  curproc->state = ZOMBIE;
80104940:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80104947:	e8 84 fe ff ff       	call   801047d0 <sched>
  panic("zombie exit");
8010494c:	83 ec 0c             	sub    $0xc,%esp
8010494f:	68 48 90 10 80       	push   $0x80109048
80104954:	e8 27 ba ff ff       	call   80100380 <panic>
    panic("init exiting");
80104959:	83 ec 0c             	sub    $0xc,%esp
8010495c:	68 3b 90 10 80       	push   $0x8010903b
80104961:	e8 1a ba ff ff       	call   80100380 <panic>
80104966:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010496d:	8d 76 00             	lea    0x0(%esi),%esi

80104970 <wait>:
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	56                   	push   %esi
80104974:	53                   	push   %ebx
  pushcli();
80104975:	e8 06 0d 00 00       	call   80105680 <pushcli>
  c = mycpu();
8010497a:	e8 91 f6 ff ff       	call   80104010 <mycpu>
  p = c->proc;
8010497f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104985:	e8 46 0d 00 00       	call   801056d0 <popcli>
  acquire(&ptable.lock);
8010498a:	83 ec 0c             	sub    $0xc,%esp
8010498d:	68 60 6b 13 80       	push   $0x80136b60
80104992:	e8 39 0e 00 00       	call   801057d0 <acquire>
80104997:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010499a:	31 c0                	xor    %eax,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010499c:	bb 94 6b 13 80       	mov    $0x80136b94,%ebx
801049a1:	eb 13                	jmp    801049b6 <wait+0x46>
801049a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049a7:	90                   	nop
801049a8:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
801049ae:	81 fb d4 71 13 80    	cmp    $0x801371d4,%ebx
801049b4:	74 1e                	je     801049d4 <wait+0x64>
      if (p->parent != curproc)
801049b6:	39 73 14             	cmp    %esi,0x14(%ebx)
801049b9:	75 ed                	jne    801049a8 <wait+0x38>
      if (p->state == ZOMBIE)
801049bb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801049bf:	74 5f                	je     80104a20 <wait+0xb0>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049c1:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
      havekids = 1;
801049c7:	b8 01 00 00 00       	mov    $0x1,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049cc:	81 fb d4 71 13 80    	cmp    $0x801371d4,%ebx
801049d2:	75 e2                	jne    801049b6 <wait+0x46>
    if (!havekids || curproc->killed)
801049d4:	85 c0                	test   %eax,%eax
801049d6:	0f 84 9a 00 00 00    	je     80104a76 <wait+0x106>
801049dc:	8b 46 24             	mov    0x24(%esi),%eax
801049df:	85 c0                	test   %eax,%eax
801049e1:	0f 85 8f 00 00 00    	jne    80104a76 <wait+0x106>
  pushcli();
801049e7:	e8 94 0c 00 00       	call   80105680 <pushcli>
  c = mycpu();
801049ec:	e8 1f f6 ff ff       	call   80104010 <mycpu>
  p = c->proc;
801049f1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801049f7:	e8 d4 0c 00 00       	call   801056d0 <popcli>
  if (p == 0)
801049fc:	85 db                	test   %ebx,%ebx
801049fe:	0f 84 90 00 00 00    	je     80104a94 <wait+0x124>
  p->chan = chan;
80104a04:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104a07:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104a0e:	e8 bd fd ff ff       	call   801047d0 <sched>
  p->chan = 0;
80104a13:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104a1a:	e9 7b ff ff ff       	jmp    8010499a <wait+0x2a>
80104a1f:	90                   	nop
        kfree(p->kstack);
80104a20:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104a23:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104a26:	ff 73 08             	push   0x8(%ebx)
80104a29:	e8 42 e1 ff ff       	call   80102b70 <kfree>
        p->kstack = 0;
80104a2e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104a35:	5a                   	pop    %edx
80104a36:	ff 73 04             	push   0x4(%ebx)
80104a39:	e8 f2 3a 00 00       	call   80108530 <freevm>
        p->pid = 0;
80104a3e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104a45:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104a4c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104a50:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104a57:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104a5e:	c7 04 24 60 6b 13 80 	movl   $0x80136b60,(%esp)
80104a65:	e8 06 0d 00 00       	call   80105770 <release>
        return pid;
80104a6a:	83 c4 10             	add    $0x10,%esp
}
80104a6d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a70:	89 f0                	mov    %esi,%eax
80104a72:	5b                   	pop    %ebx
80104a73:	5e                   	pop    %esi
80104a74:	5d                   	pop    %ebp
80104a75:	c3                   	ret    
      release(&ptable.lock);
80104a76:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104a79:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104a7e:	68 60 6b 13 80       	push   $0x80136b60
80104a83:	e8 e8 0c 00 00       	call   80105770 <release>
      return -1;
80104a88:	83 c4 10             	add    $0x10,%esp
}
80104a8b:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a8e:	89 f0                	mov    %esi,%eax
80104a90:	5b                   	pop    %ebx
80104a91:	5e                   	pop    %esi
80104a92:	5d                   	pop    %ebp
80104a93:	c3                   	ret    
    panic("sleep");
80104a94:	83 ec 0c             	sub    $0xc,%esp
80104a97:	68 54 90 10 80       	push   $0x80109054
80104a9c:	e8 df b8 ff ff       	call   80100380 <panic>
80104aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aaf:	90                   	nop

80104ab0 <yield>:
{
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	53                   	push   %ebx
80104ab4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock); // DOC: yieldlock
80104ab7:	68 60 6b 13 80       	push   $0x80136b60
80104abc:	e8 0f 0d 00 00       	call   801057d0 <acquire>
  pushcli();
80104ac1:	e8 ba 0b 00 00       	call   80105680 <pushcli>
  c = mycpu();
80104ac6:	e8 45 f5 ff ff       	call   80104010 <mycpu>
  p = c->proc;
80104acb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104ad1:	e8 fa 0b 00 00       	call   801056d0 <popcli>
  myproc()->state = RUNNABLE;
80104ad6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104add:	e8 ee fc ff ff       	call   801047d0 <sched>
  release(&ptable.lock);
80104ae2:	c7 04 24 60 6b 13 80 	movl   $0x80136b60,(%esp)
80104ae9:	e8 82 0c 00 00       	call   80105770 <release>
}
80104aee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104af1:	83 c4 10             	add    $0x10,%esp
80104af4:	c9                   	leave  
80104af5:	c3                   	ret    
80104af6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104afd:	8d 76 00             	lea    0x0(%esi),%esi

80104b00 <sleep>:
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	57                   	push   %edi
80104b04:	56                   	push   %esi
80104b05:	53                   	push   %ebx
80104b06:	83 ec 0c             	sub    $0xc,%esp
80104b09:	8b 7d 08             	mov    0x8(%ebp),%edi
80104b0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104b0f:	e8 6c 0b 00 00       	call   80105680 <pushcli>
  c = mycpu();
80104b14:	e8 f7 f4 ff ff       	call   80104010 <mycpu>
  p = c->proc;
80104b19:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104b1f:	e8 ac 0b 00 00       	call   801056d0 <popcli>
  if (p == 0)
80104b24:	85 db                	test   %ebx,%ebx
80104b26:	0f 84 87 00 00 00    	je     80104bb3 <sleep+0xb3>
  if (lk == 0)
80104b2c:	85 f6                	test   %esi,%esi
80104b2e:	74 76                	je     80104ba6 <sleep+0xa6>
  if (lk != &ptable.lock)
80104b30:	81 fe 60 6b 13 80    	cmp    $0x80136b60,%esi
80104b36:	74 50                	je     80104b88 <sleep+0x88>
    acquire(&ptable.lock); // DOC: sleeplock1
80104b38:	83 ec 0c             	sub    $0xc,%esp
80104b3b:	68 60 6b 13 80       	push   $0x80136b60
80104b40:	e8 8b 0c 00 00       	call   801057d0 <acquire>
    release(lk);
80104b45:	89 34 24             	mov    %esi,(%esp)
80104b48:	e8 23 0c 00 00       	call   80105770 <release>
  p->chan = chan;
80104b4d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104b50:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104b57:	e8 74 fc ff ff       	call   801047d0 <sched>
  p->chan = 0;
80104b5c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104b63:	c7 04 24 60 6b 13 80 	movl   $0x80136b60,(%esp)
80104b6a:	e8 01 0c 00 00       	call   80105770 <release>
    acquire(lk);
80104b6f:	89 75 08             	mov    %esi,0x8(%ebp)
80104b72:	83 c4 10             	add    $0x10,%esp
}
80104b75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b78:	5b                   	pop    %ebx
80104b79:	5e                   	pop    %esi
80104b7a:	5f                   	pop    %edi
80104b7b:	5d                   	pop    %ebp
    acquire(lk);
80104b7c:	e9 4f 0c 00 00       	jmp    801057d0 <acquire>
80104b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104b88:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104b8b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104b92:	e8 39 fc ff ff       	call   801047d0 <sched>
  p->chan = 0;
80104b97:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104b9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ba1:	5b                   	pop    %ebx
80104ba2:	5e                   	pop    %esi
80104ba3:	5f                   	pop    %edi
80104ba4:	5d                   	pop    %ebp
80104ba5:	c3                   	ret    
    panic("sleep without lk");
80104ba6:	83 ec 0c             	sub    $0xc,%esp
80104ba9:	68 5a 90 10 80       	push   $0x8010905a
80104bae:	e8 cd b7 ff ff       	call   80100380 <panic>
    panic("sleep");
80104bb3:	83 ec 0c             	sub    $0xc,%esp
80104bb6:	68 54 90 10 80       	push   $0x80109054
80104bbb:	e8 c0 b7 ff ff       	call   80100380 <panic>

80104bc0 <wakeup>:
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	53                   	push   %ebx
80104bc4:	83 ec 10             	sub    $0x10,%esp
80104bc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104bca:	68 60 6b 13 80       	push   $0x80136b60
80104bcf:	e8 fc 0b 00 00       	call   801057d0 <acquire>
80104bd4:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104bd7:	b8 94 6b 13 80       	mov    $0x80136b94,%eax
80104bdc:	eb 0e                	jmp    80104bec <wakeup+0x2c>
80104bde:	66 90                	xchg   %ax,%ax
80104be0:	05 a0 00 00 00       	add    $0xa0,%eax
80104be5:	3d d4 71 13 80       	cmp    $0x801371d4,%eax
80104bea:	74 1e                	je     80104c0a <wakeup+0x4a>
    if (p->state == SLEEPING && p->chan == chan)
80104bec:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104bf0:	75 ee                	jne    80104be0 <wakeup+0x20>
80104bf2:	3b 58 20             	cmp    0x20(%eax),%ebx
80104bf5:	75 e9                	jne    80104be0 <wakeup+0x20>
      p->state = RUNNABLE;
80104bf7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104bfe:	05 a0 00 00 00       	add    $0xa0,%eax
80104c03:	3d d4 71 13 80       	cmp    $0x801371d4,%eax
80104c08:	75 e2                	jne    80104bec <wakeup+0x2c>
  release(&ptable.lock);
80104c0a:	c7 45 08 60 6b 13 80 	movl   $0x80136b60,0x8(%ebp)
}
80104c11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c14:	c9                   	leave  
  release(&ptable.lock);
80104c15:	e9 56 0b 00 00       	jmp    80105770 <release>
80104c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c20 <wakeupproc>:
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	53                   	push   %ebx
80104c24:	83 ec 10             	sub    $0x10,%esp
80104c27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104c2a:	68 60 6b 13 80       	push   $0x80136b60
80104c2f:	e8 9c 0b 00 00       	call   801057d0 <acquire>
  p->state = RUNNABLE;
80104c34:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80104c3b:	83 c4 10             	add    $0x10,%esp
}
80104c3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&ptable.lock);
80104c41:	c7 45 08 60 6b 13 80 	movl   $0x80136b60,0x8(%ebp)
}
80104c48:	c9                   	leave  
  release(&ptable.lock);
80104c49:	e9 22 0b 00 00       	jmp    80105770 <release>
80104c4e:	66 90                	xchg   %ax,%ax

80104c50 <kill>:
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	53                   	push   %ebx
80104c54:	83 ec 10             	sub    $0x10,%esp
80104c57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104c5a:	68 60 6b 13 80       	push   $0x80136b60
80104c5f:	e8 6c 0b 00 00       	call   801057d0 <acquire>
80104c64:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c67:	b8 94 6b 13 80       	mov    $0x80136b94,%eax
80104c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (p->pid == pid)
80104c70:	39 58 10             	cmp    %ebx,0x10(%eax)
80104c73:	74 2b                	je     80104ca0 <kill+0x50>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c75:	05 a0 00 00 00       	add    $0xa0,%eax
80104c7a:	3d d4 71 13 80       	cmp    $0x801371d4,%eax
80104c7f:	75 ef                	jne    80104c70 <kill+0x20>
  release(&ptable.lock);
80104c81:	83 ec 0c             	sub    $0xc,%esp
80104c84:	68 60 6b 13 80       	push   $0x80136b60
80104c89:	e8 e2 0a 00 00       	call   80105770 <release>
}
80104c8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104c91:	83 c4 10             	add    $0x10,%esp
80104c94:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c99:	c9                   	leave  
80104c9a:	c3                   	ret    
80104c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c9f:	90                   	nop
      if (p->state == SLEEPING)
80104ca0:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104ca4:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if (p->state == SLEEPING)
80104cab:	75 07                	jne    80104cb4 <kill+0x64>
        p->state = RUNNABLE;
80104cad:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104cb4:	83 ec 0c             	sub    $0xc,%esp
80104cb7:	68 60 6b 13 80       	push   $0x80136b60
80104cbc:	e8 af 0a 00 00       	call   80105770 <release>
}
80104cc1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104cc4:	83 c4 10             	add    $0x10,%esp
80104cc7:	31 c0                	xor    %eax,%eax
}
80104cc9:	c9                   	leave  
80104cca:	c3                   	ret    
80104ccb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ccf:	90                   	nop

80104cd0 <procdump>:
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	57                   	push   %edi
80104cd4:	56                   	push   %esi
80104cd5:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104cd8:	53                   	push   %ebx
80104cd9:	bb 00 6c 13 80       	mov    $0x80136c00,%ebx
80104cde:	83 ec 3c             	sub    $0x3c,%esp
80104ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (p->state == UNUSED)
80104ce8:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104ceb:	85 c0                	test   %eax,%eax
80104ced:	74 43                	je     80104d32 <procdump+0x62>
      state = "???";
80104cef:	ba 6b 90 10 80       	mov    $0x8010906b,%edx
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104cf4:	83 f8 05             	cmp    $0x5,%eax
80104cf7:	77 11                	ja     80104d0a <procdump+0x3a>
80104cf9:	8b 14 85 9c 91 10 80 	mov    -0x7fef6e64(,%eax,4),%edx
      state = "???";
80104d00:	b8 6b 90 10 80       	mov    $0x8010906b,%eax
80104d05:	85 d2                	test   %edx,%edx
80104d07:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104d0a:	53                   	push   %ebx
80104d0b:	52                   	push   %edx
80104d0c:	ff 73 a4             	push   -0x5c(%ebx)
80104d0f:	68 6f 90 10 80       	push   $0x8010906f
80104d14:	e8 87 b9 ff ff       	call   801006a0 <cprintf>
    if (p->state == SLEEPING)
80104d19:	83 c4 10             	add    $0x10,%esp
80104d1c:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104d20:	74 2e                	je     80104d50 <procdump+0x80>
    cprintf("\n");
80104d22:	83 ec 0c             	sub    $0xc,%esp
80104d25:	68 eb 94 10 80       	push   $0x801094eb
80104d2a:	e8 71 b9 ff ff       	call   801006a0 <cprintf>
80104d2f:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d32:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
80104d38:	81 fb 40 72 13 80    	cmp    $0x80137240,%ebx
80104d3e:	75 a8                	jne    80104ce8 <procdump+0x18>
}
80104d40:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d43:	5b                   	pop    %ebx
80104d44:	5e                   	pop    %esi
80104d45:	5f                   	pop    %edi
80104d46:	5d                   	pop    %ebp
80104d47:	c3                   	ret    
80104d48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d4f:	90                   	nop
      getcallerpcs((uint *)p->context->ebp + 2, pc);
80104d50:	83 ec 08             	sub    $0x8,%esp
80104d53:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104d56:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104d59:	50                   	push   %eax
80104d5a:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104d5d:	8b 40 0c             	mov    0xc(%eax),%eax
80104d60:	83 c0 08             	add    $0x8,%eax
80104d63:	50                   	push   %eax
80104d64:	e8 b7 08 00 00       	call   80105620 <getcallerpcs>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80104d69:	83 c4 10             	add    $0x10,%esp
80104d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d70:	8b 07                	mov    (%edi),%eax
80104d72:	85 c0                	test   %eax,%eax
80104d74:	74 ac                	je     80104d22 <procdump+0x52>
        cprintf(" %p", pc[i]);
80104d76:	83 ec 08             	sub    $0x8,%esp
      for (i = 0; i < 10 && pc[i] != 0; i++)
80104d79:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
80104d7c:	50                   	push   %eax
80104d7d:	68 61 8a 10 80       	push   $0x80108a61
80104d82:	e8 19 b9 ff ff       	call   801006a0 <cprintf>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80104d87:	83 c4 10             	add    $0x10,%esp
80104d8a:	39 fe                	cmp    %edi,%esi
80104d8c:	75 e2                	jne    80104d70 <procdump+0xa0>
80104d8e:	eb 92                	jmp    80104d22 <procdump+0x52>

80104d90 <push_p_hist>:
{
80104d90:	55                   	push   %ebp
  int cur_size = p_hist[syscall_number].size % PROC_HIST_SIZE;
80104d91:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
{
80104d96:	89 e5                	mov    %esp,%ebp
80104d98:	56                   	push   %esi
80104d99:	53                   	push   %ebx
80104d9a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  int cur_size = p_hist[syscall_number].size % PROC_HIST_SIZE;
80104d9d:	69 f3 a4 0f 00 00    	imul   $0xfa4,%ebx,%esi
  p_hist[syscall_number].pids[cur_size] = pid;
80104da3:	69 db e9 03 00 00    	imul   $0x3e9,%ebx,%ebx
  int cur_size = p_hist[syscall_number].size % PROC_HIST_SIZE;
80104da9:	8b 8e 80 57 11 80    	mov    -0x7feea880(%esi),%ecx
80104daf:	89 c8                	mov    %ecx,%eax
80104db1:	f7 ea                	imul   %edx
80104db3:	89 c8                	mov    %ecx,%eax
80104db5:	c1 f8 1f             	sar    $0x1f,%eax
80104db8:	c1 fa 06             	sar    $0x6,%edx
80104dbb:	29 c2                	sub    %eax,%edx
80104dbd:	89 c8                	mov    %ecx,%eax
  ++(p_hist[syscall_number].size);
80104dbf:	83 c1 01             	add    $0x1,%ecx
  int cur_size = p_hist[syscall_number].size % PROC_HIST_SIZE;
80104dc2:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
  ++(p_hist[syscall_number].size);
80104dc8:	89 8e 80 57 11 80    	mov    %ecx,-0x7feea880(%esi)
  int cur_size = p_hist[syscall_number].size % PROC_HIST_SIZE;
80104dce:	29 d0                	sub    %edx,%eax
  p_hist[syscall_number].pids[cur_size] = pid;
80104dd0:	01 c3                	add    %eax,%ebx
80104dd2:	8b 45 08             	mov    0x8(%ebp),%eax
80104dd5:	89 04 9d e0 47 11 80 	mov    %eax,-0x7feeb820(,%ebx,4)
}
80104ddc:	5b                   	pop    %ebx
80104ddd:	5e                   	pop    %esi
80104dde:	5d                   	pop    %ebp
80104ddf:	c3                   	ret    

80104de0 <get_callers>:
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	57                   	push   %edi
80104de4:	56                   	push   %esi
80104de5:	53                   	push   %ebx
80104de6:	83 ec 0c             	sub    $0xc,%esp
80104de9:	8b 75 08             	mov    0x8(%ebp),%esi
  int limit = p_hist[syscall_number].size;
80104dec:	69 c6 a4 0f 00 00    	imul   $0xfa4,%esi,%eax
80104df2:	8b 88 80 57 11 80    	mov    -0x7feea880(%eax),%ecx
  if (limit == 0)
80104df8:	85 c9                	test   %ecx,%ecx
80104dfa:	0f 84 a0 00 00 00    	je     80104ea0 <get_callers+0xc0>
  int i = (limit > PROC_HIST_SIZE) ? limit % PROC_HIST_SIZE : 0;
80104e00:	89 c8                	mov    %ecx,%eax
80104e02:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
80104e07:	f7 ea                	imul   %edx
80104e09:	89 c8                	mov    %ecx,%eax
80104e0b:	c1 f8 1f             	sar    $0x1f,%eax
80104e0e:	c1 fa 06             	sar    $0x6,%edx
80104e11:	89 d3                	mov    %edx,%ebx
80104e13:	31 d2                	xor    %edx,%edx
80104e15:	29 c3                	sub    %eax,%ebx
80104e17:	89 d7                	mov    %edx,%edi
80104e19:	69 c3 e8 03 00 00    	imul   $0x3e8,%ebx,%eax
80104e1f:	89 cb                	mov    %ecx,%ebx
80104e21:	29 c3                	sub    %eax,%ebx
80104e23:	81 f9 e9 03 00 00    	cmp    $0x3e9,%ecx
80104e29:	0f 4d fb             	cmovge %ebx,%edi
    cprintf("%d", p_hist[syscall_number].pids[i]);
80104e2c:	69 f6 e9 03 00 00    	imul   $0x3e9,%esi,%esi
80104e32:	eb 14                	jmp    80104e48 <get_callers+0x68>
80104e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf(", ");
80104e38:	83 ec 0c             	sub    $0xc,%esp
80104e3b:	68 7b 90 10 80       	push   $0x8010907b
80104e40:	e8 5b b8 ff ff       	call   801006a0 <cprintf>
    cprintf("%d", p_hist[syscall_number].pids[i]);
80104e45:	83 c4 10             	add    $0x10,%esp
80104e48:	83 ec 08             	sub    $0x8,%esp
80104e4b:	8d 04 3e             	lea    (%esi,%edi,1),%eax
80104e4e:	ff 34 85 e0 47 11 80 	push   -0x7feeb820(,%eax,4)
80104e55:	68 78 90 10 80       	push   $0x80109078
80104e5a:	e8 41 b8 ff ff       	call   801006a0 <cprintf>
    i = (i + 1) % PROC_HIST_SIZE;
80104e5f:	8d 4f 01             	lea    0x1(%edi),%ecx
80104e62:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    if (i == limit)
80104e67:	83 c4 10             	add    $0x10,%esp
    i = (i + 1) % PROC_HIST_SIZE;
80104e6a:	f7 e9                	imul   %ecx
80104e6c:	89 c8                	mov    %ecx,%eax
80104e6e:	c1 f8 1f             	sar    $0x1f,%eax
80104e71:	c1 fa 06             	sar    $0x6,%edx
80104e74:	29 c2                	sub    %eax,%edx
80104e76:	69 c2 e8 03 00 00    	imul   $0x3e8,%edx,%eax
80104e7c:	29 c1                	sub    %eax,%ecx
80104e7e:	89 cf                	mov    %ecx,%edi
    if (i == limit)
80104e80:	39 d9                	cmp    %ebx,%ecx
80104e82:	75 b4                	jne    80104e38 <get_callers+0x58>
  cprintf("\n");
80104e84:	c7 45 08 eb 94 10 80 	movl   $0x801094eb,0x8(%ebp)
}
80104e8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e8e:	5b                   	pop    %ebx
80104e8f:	5e                   	pop    %esi
80104e90:	5f                   	pop    %edi
80104e91:	5d                   	pop    %ebp
  cprintf("\n");
80104e92:	e9 09 b8 ff ff       	jmp    801006a0 <cprintf>
80104e97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e9e:	66 90                	xchg   %ax,%ax
    cprintf("No process has called system call number %d.\n", syscall_number);
80104ea0:	83 ec 08             	sub    $0x8,%esp
80104ea3:	56                   	push   %esi
80104ea4:	68 ec 90 10 80       	push   $0x801090ec
80104ea9:	e8 f2 b7 ff ff       	call   801006a0 <cprintf>
    return;
80104eae:	83 c4 10             	add    $0x10,%esp
}
80104eb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104eb4:	5b                   	pop    %ebx
80104eb5:	5e                   	pop    %esi
80104eb6:	5f                   	pop    %edi
80104eb7:	5d                   	pop    %ebp
80104eb8:	c3                   	ret    
80104eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ec0 <change_queue>:
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	56                   	push   %esi
80104ec4:	8b 75 0c             	mov    0xc(%ebp),%esi
80104ec7:	53                   	push   %ebx
80104ec8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (new_queue == UNSET)
80104ecb:	85 f6                	test   %esi,%esi
80104ecd:	75 0c                	jne    80104edb <change_queue+0x1b>
    if (pid == 1)
80104ecf:	83 fb 01             	cmp    $0x1,%ebx
80104ed2:	74 4c                	je     80104f20 <change_queue+0x60>
    else if (pid > 1)
80104ed4:	7e 62                	jle    80104f38 <change_queue+0x78>
      new_queue = LCFS;
80104ed6:	be 02 00 00 00       	mov    $0x2,%esi
  acquire(&ptable.lock);
80104edb:	83 ec 0c             	sub    $0xc,%esp
80104ede:	68 60 6b 13 80       	push   $0x80136b60
80104ee3:	e8 e8 08 00 00       	call   801057d0 <acquire>
80104ee8:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104eeb:	b8 94 6b 13 80       	mov    $0x80136b94,%eax
    if (p->pid == pid)
80104ef0:	39 58 10             	cmp    %ebx,0x10(%eax)
80104ef3:	74 3b                	je     80104f30 <change_queue+0x70>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ef5:	05 a0 00 00 00       	add    $0xa0,%eax
80104efa:	3d d4 71 13 80       	cmp    $0x801371d4,%eax
80104eff:	75 ef                	jne    80104ef0 <change_queue+0x30>
  int old_queue = -1;
80104f01:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  release(&ptable.lock);
80104f06:	83 ec 0c             	sub    $0xc,%esp
80104f09:	68 60 6b 13 80       	push   $0x80136b60
80104f0e:	e8 5d 08 00 00       	call   80105770 <release>
  return old_queue;
80104f13:	83 c4 10             	add    $0x10,%esp
}
80104f16:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f19:	89 d8                	mov    %ebx,%eax
80104f1b:	5b                   	pop    %ebx
80104f1c:	5e                   	pop    %esi
80104f1d:	5d                   	pop    %ebp
80104f1e:	c3                   	ret    
80104f1f:	90                   	nop
      new_queue = ROUND_ROBIN;
80104f20:	be 01 00 00 00       	mov    $0x1,%esi
80104f25:	eb b4                	jmp    80104edb <change_queue+0x1b>
80104f27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f2e:	66 90                	xchg   %ax,%ax
      old_queue = p->schedule_status.queue_id;
80104f30:	8b 58 7c             	mov    0x7c(%eax),%ebx
      p->schedule_status.queue_id = new_queue;
80104f33:	89 70 7c             	mov    %esi,0x7c(%eax)
      break;
80104f36:	eb ce                	jmp    80104f06 <change_queue+0x46>
      return -1;
80104f38:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104f3d:	eb d7                	jmp    80104f16 <change_queue+0x56>
80104f3f:	90                   	nop

80104f40 <set_bjf_params_process>:

int set_bjf_params_process(int pid, float priority_ratio, float arrival_time_ratio, float executed_cycles_ratio)
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	53                   	push   %ebx
80104f44:	83 ec 10             	sub    $0x10,%esp
80104f47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104f4a:	68 60 6b 13 80       	push   $0x80136b60
80104f4f:	e8 7c 08 00 00       	call   801057d0 <acquire>
80104f54:	83 c4 10             	add    $0x10,%esp
  struct proc *p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f57:	b8 94 6b 13 80       	mov    $0x80136b94,%eax
80104f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  {
    if (p->pid == pid)
80104f60:	39 58 10             	cmp    %ebx,0x10(%eax)
80104f63:	74 2b                	je     80104f90 <set_bjf_params_process+0x50>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f65:	05 a0 00 00 00       	add    $0xa0,%eax
80104f6a:	3d d4 71 13 80       	cmp    $0x801371d4,%eax
80104f6f:	75 ef                	jne    80104f60 <set_bjf_params_process+0x20>
      p->schedule_status.executed_cycle_ratio = executed_cycles_ratio;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104f71:	83 ec 0c             	sub    $0xc,%esp
80104f74:	68 60 6b 13 80       	push   $0x80136b60
80104f79:	e8 f2 07 00 00       	call   80105770 <release>
  return -1;
}
80104f7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104f81:	83 c4 10             	add    $0x10,%esp
80104f84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f89:	c9                   	leave  
80104f8a:	c3                   	ret    
80104f8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f8f:	90                   	nop
      p->schedule_status.priority_ratio = priority_ratio;
80104f90:	d9 45 0c             	flds   0xc(%ebp)
      release(&ptable.lock);
80104f93:	83 ec 0c             	sub    $0xc,%esp
      p->schedule_status.priority_ratio = priority_ratio;
80104f96:	d9 98 8c 00 00 00    	fstps  0x8c(%eax)
      p->schedule_status.arrival_time_ratio = arrival_time_ratio;
80104f9c:	d9 45 10             	flds   0x10(%ebp)
80104f9f:	d9 98 94 00 00 00    	fstps  0x94(%eax)
      p->schedule_status.executed_cycle_ratio = executed_cycles_ratio;
80104fa5:	d9 45 14             	flds   0x14(%ebp)
80104fa8:	d9 98 9c 00 00 00    	fstps  0x9c(%eax)
      release(&ptable.lock);
80104fae:	68 60 6b 13 80       	push   $0x80136b60
80104fb3:	e8 b8 07 00 00       	call   80105770 <release>
}
80104fb8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104fbb:	83 c4 10             	add    $0x10,%esp
80104fbe:	31 c0                	xor    %eax,%eax
}
80104fc0:	c9                   	leave  
80104fc1:	c3                   	ret    
80104fc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104fd0 <set_bjf_params_system>:

void set_bjf_params_system(float priority_ratio, float arrival_time_ratio, float executed_cycles_ratio)
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	83 ec 24             	sub    $0x24,%esp
80104fd6:	d9 45 08             	flds   0x8(%ebp)
  acquire(&ptable.lock);
80104fd9:	68 60 6b 13 80       	push   $0x80136b60
{
80104fde:	d9 5d ec             	fstps  -0x14(%ebp)
80104fe1:	d9 45 0c             	flds   0xc(%ebp)
80104fe4:	d9 5d f0             	fstps  -0x10(%ebp)
80104fe7:	d9 45 10             	flds   0x10(%ebp)
80104fea:	d9 5d f4             	fstps  -0xc(%ebp)
  acquire(&ptable.lock);
80104fed:	e8 de 07 00 00       	call   801057d0 <acquire>
  struct proc *p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ff2:	d9 45 ec             	flds   -0x14(%ebp)
80104ff5:	d9 45 f0             	flds   -0x10(%ebp)
  acquire(&ptable.lock);
80104ff8:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ffb:	d9 45 f4             	flds   -0xc(%ebp)
80104ffe:	d9 ca                	fxch   %st(2)
80105000:	b8 94 6b 13 80       	mov    $0x80136b94,%eax
80105005:	eb 0d                	jmp    80105014 <set_bjf_params_system+0x44>
80105007:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010500e:	66 90                	xchg   %ax,%ax
80105010:	d9 ca                	fxch   %st(2)
80105012:	d9 c9                	fxch   %st(1)
  {
    p->schedule_status.priority_ratio = priority_ratio;
80105014:	d9 90 8c 00 00 00    	fsts   0x8c(%eax)
8010501a:	d9 c9                	fxch   %st(1)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010501c:	05 a0 00 00 00       	add    $0xa0,%eax
    p->schedule_status.arrival_time_ratio = arrival_time_ratio;
80105021:	d9 50 f4             	fsts   -0xc(%eax)
80105024:	d9 ca                	fxch   %st(2)
    p->schedule_status.executed_cycle_ratio = executed_cycles_ratio;
80105026:	d9 50 fc             	fsts   -0x4(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105029:	3d d4 71 13 80       	cmp    $0x801371d4,%eax
8010502e:	75 e0                	jne    80105010 <set_bjf_params_system+0x40>
80105030:	dd d8                	fstp   %st(0)
80105032:	dd d8                	fstp   %st(0)
80105034:	dd d8                	fstp   %st(0)
  }
  release(&ptable.lock);
80105036:	c7 45 08 60 6b 13 80 	movl   $0x80136b60,0x8(%ebp)
}
8010503d:	c9                   	leave  
  release(&ptable.lock);
8010503e:	e9 2d 07 00 00       	jmp    80105770 <release>
80105043:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010504a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105050 <set_bjf_priority>:

int set_bjf_priority(int pid, int priority)
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	53                   	push   %ebx
80105054:	83 ec 10             	sub    $0x10,%esp
80105057:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010505a:	68 60 6b 13 80       	push   $0x80136b60
8010505f:	e8 6c 07 00 00       	call   801057d0 <acquire>
80105064:	83 c4 10             	add    $0x10,%esp
  struct proc *p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105067:	b8 94 6b 13 80       	mov    $0x80136b94,%eax
8010506c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  {
    if (p->pid == pid)
80105070:	39 58 10             	cmp    %ebx,0x10(%eax)
80105073:	74 2b                	je     801050a0 <set_bjf_priority+0x50>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105075:	05 a0 00 00 00       	add    $0xa0,%eax
8010507a:	3d d4 71 13 80       	cmp    $0x801371d4,%eax
8010507f:	75 ef                	jne    80105070 <set_bjf_priority+0x20>
      p->schedule_status.priority = priority;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80105081:	83 ec 0c             	sub    $0xc,%esp
80105084:	68 60 6b 13 80       	push   $0x80136b60
80105089:	e8 e2 06 00 00       	call   80105770 <release>
  return -1;
}
8010508e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80105091:	83 c4 10             	add    $0x10,%esp
80105094:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105099:	c9                   	leave  
8010509a:	c3                   	ret    
8010509b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010509f:	90                   	nop
      p->schedule_status.priority = priority;
801050a0:	8b 55 0c             	mov    0xc(%ebp),%edx
      release(&ptable.lock);
801050a3:	83 ec 0c             	sub    $0xc,%esp
      p->schedule_status.priority = priority;
801050a6:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
      release(&ptable.lock);
801050ac:	68 60 6b 13 80       	push   $0x80136b60
801050b1:	e8 ba 06 00 00       	call   80105770 <release>
}
801050b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801050b9:	83 c4 10             	add    $0x10,%esp
801050bc:	31 c0                	xor    %eax,%eax
}
801050be:	c9                   	leave  
801050bf:	c3                   	ret    

801050c0 <semaphore_init>:


struct semaphore sems[NSEMS];

void semaphore_init(struct semaphore *sem, int value, char *name)
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	53                   	push   %ebx
801050c4:	83 ec 0c             	sub    $0xc,%esp
801050c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  sem->value = value;
801050ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801050cd:	89 03                	mov    %eax,(%ebx)
  initlock(&sem->lk, "semaphore");
801050cf:	8d 43 04             	lea    0x4(%ebx),%eax
801050d2:	68 7e 90 10 80       	push   $0x8010907e
801050d7:	50                   	push   %eax
801050d8:	e8 23 05 00 00       	call   80105600 <initlock>
  memset(sem->waiting, 0, sizeof(sem->waiting));
801050dd:	83 c4 0c             	add    $0xc,%esp
801050e0:	8d 43 38             	lea    0x38(%ebx),%eax
801050e3:	6a 28                	push   $0x28
801050e5:	6a 00                	push   $0x0
801050e7:	50                   	push   %eax
801050e8:	e8 a3 07 00 00       	call   80105890 <memset>
  sem->wfirst = 0;
  sem->wlast = 0;
  sem->name = name;
801050ed:	8b 45 10             	mov    0x10(%ebp),%eax
  sem->wfirst = 0;
801050f0:	c7 43 60 00 00 00 00 	movl   $0x0,0x60(%ebx)
}
801050f7:	83 c4 10             	add    $0x10,%esp
  sem->wlast = 0;
801050fa:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)
  sem->name = name;
80105101:	89 43 68             	mov    %eax,0x68(%ebx)
}
80105104:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105107:	c9                   	leave  
80105108:	c3                   	ret    
80105109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105110 <semaphore_release>:
 
  release(&sem->lk);
}

void semaphore_release(struct semaphore *sem)
{
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	57                   	push   %edi
80105114:	56                   	push   %esi
80105115:	53                   	push   %ebx
80105116:	83 ec 18             	sub    $0x18,%esp
80105119:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&sem->lk);
8010511c:	8d 73 04             	lea    0x4(%ebx),%esi
8010511f:	56                   	push   %esi
80105120:	e8 ab 06 00 00       	call   801057d0 <acquire>
  ++sem->value;
80105125:	8b 03                	mov    (%ebx),%eax
  if (sem->value <= 0)
80105127:	83 c4 10             	add    $0x10,%esp
  ++sem->value;
8010512a:	83 c0 01             	add    $0x1,%eax
8010512d:	89 03                	mov    %eax,(%ebx)
  if (sem->value <= 0)
8010512f:	85 c0                	test   %eax,%eax
80105131:	7e 15                	jle    80105148 <semaphore_release+0x38>
    wakeupproc(sem->waiting[sem->wfirst]);
    sem->waiting[sem->wfirst] = 0;
    sem->wfirst = (sem->wfirst + 1) % NELEM(sem->waiting);
  }
  
  release(&sem->lk);
80105133:	89 75 08             	mov    %esi,0x8(%ebp)
}
80105136:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105139:	5b                   	pop    %ebx
8010513a:	5e                   	pop    %esi
8010513b:	5f                   	pop    %edi
8010513c:	5d                   	pop    %ebp
  release(&sem->lk);
8010513d:	e9 2e 06 00 00       	jmp    80105770 <release>
80105142:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeupproc(sem->waiting[sem->wfirst]);
80105148:	8b 43 60             	mov    0x60(%ebx),%eax
  acquire(&ptable.lock);
8010514b:	83 ec 0c             	sub    $0xc,%esp
    wakeupproc(sem->waiting[sem->wfirst]);
8010514e:	8b 7c 83 38          	mov    0x38(%ebx,%eax,4),%edi
  acquire(&ptable.lock);
80105152:	68 60 6b 13 80       	push   $0x80136b60
80105157:	e8 74 06 00 00       	call   801057d0 <acquire>
  p->state = RUNNABLE;
8010515c:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80105163:	c7 04 24 60 6b 13 80 	movl   $0x80136b60,(%esp)
8010516a:	e8 01 06 00 00       	call   80105770 <release>
    sem->waiting[sem->wfirst] = 0;
8010516f:	8b 4b 60             	mov    0x60(%ebx),%ecx
    sem->wfirst = (sem->wfirst + 1) % NELEM(sem->waiting);
80105172:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80105177:	83 c4 10             	add    $0x10,%esp
    sem->waiting[sem->wfirst] = 0;
8010517a:	c7 44 8b 38 00 00 00 	movl   $0x0,0x38(%ebx,%ecx,4)
80105181:	00 
    sem->wfirst = (sem->wfirst + 1) % NELEM(sem->waiting);
80105182:	83 c1 01             	add    $0x1,%ecx
80105185:	89 c8                	mov    %ecx,%eax
80105187:	f7 e2                	mul    %edx
80105189:	c1 ea 03             	shr    $0x3,%edx
8010518c:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010518f:	01 c0                	add    %eax,%eax
80105191:	29 c1                	sub    %eax,%ecx
80105193:	89 4b 60             	mov    %ecx,0x60(%ebx)
  release(&sem->lk);
80105196:	89 75 08             	mov    %esi,0x8(%ebp)
}
80105199:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010519c:	5b                   	pop    %ebx
8010519d:	5e                   	pop    %esi
8010519e:	5f                   	pop    %edi
8010519f:	5d                   	pop    %ebp
  release(&sem->lk);
801051a0:	e9 cb 05 00 00       	jmp    80105770 <release>
801051a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051b0 <sem_init>:



void sem_init(int id, int value)
{
801051b0:	55                   	push   %ebp
801051b1:	89 e5                	mov    %esp,%ebp
801051b3:	56                   	push   %esi
801051b4:	53                   	push   %ebx
  sem->value = value;
801051b5:	6b 5d 08 6c          	imul   $0x6c,0x8(%ebp),%ebx
801051b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  initlock(&sem->lk, "semaphore");
801051bc:	83 ec 08             	sub    $0x8,%esp
  sem->value = value;
801051bf:	89 83 40 45 11 80    	mov    %eax,-0x7feebac0(%ebx)
  initlock(&sem->lk, "semaphore");
801051c5:	8d 83 44 45 11 80    	lea    -0x7feebabc(%ebx),%eax
  sem->value = value;
801051cb:	8d b3 40 45 11 80    	lea    -0x7feebac0(%ebx),%esi
  initlock(&sem->lk, "semaphore");
801051d1:	68 7e 90 10 80       	push   $0x8010907e
  memset(sem->waiting, 0, sizeof(sem->waiting));
801051d6:	81 c3 78 45 11 80    	add    $0x80114578,%ebx
  initlock(&sem->lk, "semaphore");
801051dc:	50                   	push   %eax
801051dd:	e8 1e 04 00 00       	call   80105600 <initlock>
  memset(sem->waiting, 0, sizeof(sem->waiting));
801051e2:	83 c4 0c             	add    $0xc,%esp
801051e5:	6a 28                	push   $0x28
801051e7:	6a 00                	push   $0x0
801051e9:	53                   	push   %ebx
801051ea:	e8 a1 06 00 00       	call   80105890 <memset>
  sem->wfirst = 0;
801051ef:	c7 46 60 00 00 00 00 	movl   $0x0,0x60(%esi)
  semaphore_init(&sems[id], value, "semaphore");
}
801051f6:	83 c4 10             	add    $0x10,%esp
  sem->wlast = 0;
801051f9:	c7 46 64 00 00 00 00 	movl   $0x0,0x64(%esi)
  sem->name = name;
80105200:	c7 46 68 7e 90 10 80 	movl   $0x8010907e,0x68(%esi)
}
80105207:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010520a:	5b                   	pop    %ebx
8010520b:	5e                   	pop    %esi
8010520c:	5d                   	pop    %ebp
8010520d:	c3                   	ret    
8010520e:	66 90                	xchg   %ax,%ax

80105210 <sem_release>:
{
  semaphore_acquire(&sems[id], prio);
}

void sem_release(int id)
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
  semaphore_release(&sems[id]);
80105213:	6b 45 08 6c          	imul   $0x6c,0x8(%ebp),%eax
80105217:	05 40 45 11 80       	add    $0x80114540,%eax
8010521c:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010521f:	5d                   	pop    %ebp
  semaphore_release(&sems[id]);
80105220:	e9 eb fe ff ff       	jmp    80105110 <semaphore_release>
80105225:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010522c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105230 <print_process_info>:

void print_process_info()
{
80105230:	55                   	push   %ebp
80105231:	89 e5                	mov    %esp,%ebp
80105233:	57                   	push   %edi
80105234:	56                   	push   %esi

    cprintf("%s", p->name);
    printspaces(columns[0] - strlen(p->name));

    cprintf("%d", p->pid);
    printspaces(columns[1] - digitcount(p->pid));
80105235:	be 08 00 00 00       	mov    $0x8,%esi
{
8010523a:	53                   	push   %ebx
8010523b:	bb 00 6c 13 80       	mov    $0x80136c00,%ebx
80105240:	83 ec 18             	sub    $0x18,%esp
  cprintf("Process_Name    PID     State    Prio   Place\n"
80105243:	68 1c 91 10 80       	push   $0x8010911c
80105248:	e8 53 b4 ff ff       	call   801006a0 <cprintf>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010524d:	83 c4 10             	add    $0x10,%esp
    if (p->state == UNUSED)
80105250:	8b 43 a0             	mov    -0x60(%ebx),%eax
80105253:	85 c0                	test   %eax,%eax
80105255:	0f 84 e9 00 00 00    	je     80105344 <print_process_info+0x114>
      state = "???";
8010525b:	bf 6b 90 10 80       	mov    $0x8010906b,%edi
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105260:	83 f8 05             	cmp    $0x5,%eax
80105263:	77 11                	ja     80105276 <print_process_info+0x46>
80105265:	8b 3c 85 84 91 10 80 	mov    -0x7fef6e7c(,%eax,4),%edi
      state = "???";
8010526c:	b8 6b 90 10 80       	mov    $0x8010906b,%eax
80105271:	85 ff                	test   %edi,%edi
80105273:	0f 44 f8             	cmove  %eax,%edi
    cprintf("%s", p->name);
80105276:	83 ec 08             	sub    $0x8,%esp
80105279:	53                   	push   %ebx
8010527a:	68 75 90 10 80       	push   $0x80109075
8010527f:	e8 1c b4 ff ff       	call   801006a0 <cprintf>
    printspaces(columns[0] - strlen(p->name));
80105284:	89 1c 24             	mov    %ebx,(%esp)
80105287:	e8 04 08 00 00       	call   80105a90 <strlen>
8010528c:	89 c1                	mov    %eax,%ecx
8010528e:	b8 10 00 00 00       	mov    $0x10,%eax
80105293:	29 c8                	sub    %ecx,%eax
80105295:	89 04 24             	mov    %eax,(%esp)
80105298:	e8 d3 21 00 00       	call   80107470 <printspaces>
    cprintf("%d", p->pid);
8010529d:	58                   	pop    %eax
8010529e:	5a                   	pop    %edx
8010529f:	ff 73 a4             	push   -0x5c(%ebx)
801052a2:	68 78 90 10 80       	push   $0x80109078
801052a7:	e8 f4 b3 ff ff       	call   801006a0 <cprintf>
    printspaces(columns[1] - digitcount(p->pid));
801052ac:	59                   	pop    %ecx
801052ad:	ff 73 a4             	push   -0x5c(%ebx)
801052b0:	e8 7b 21 00 00       	call   80107430 <digitcount>
801052b5:	89 c1                	mov    %eax,%ecx
801052b7:	89 f0                	mov    %esi,%eax
801052b9:	29 c8                	sub    %ecx,%eax
801052bb:	89 04 24             	mov    %eax,(%esp)
801052be:	e8 ad 21 00 00       	call   80107470 <printspaces>

    cprintf("%s", state);
801052c3:	58                   	pop    %eax
801052c4:	5a                   	pop    %edx
801052c5:	57                   	push   %edi
801052c6:	68 75 90 10 80       	push   $0x80109075
801052cb:	e8 d0 b3 ff ff       	call   801006a0 <cprintf>
    printspaces(columns[2] - strlen(state));
801052d0:	89 3c 24             	mov    %edi,(%esp)
801052d3:	e8 b8 07 00 00       	call   80105a90 <strlen>
801052d8:	89 c2                	mov    %eax,%edx
801052da:	b8 09 00 00 00       	mov    $0x9,%eax
801052df:	29 d0                	sub    %edx,%eax
801052e1:	89 04 24             	mov    %eax,(%esp)
801052e4:	e8 87 21 00 00       	call   80107470 <printspaces>

    cprintf("%d", p->schedule_status.priority);
801052e9:	59                   	pop    %ecx
801052ea:	5f                   	pop    %edi
801052eb:	ff 73 1c             	push   0x1c(%ebx)
801052ee:	68 78 90 10 80       	push   $0x80109078
801052f3:	e8 a8 b3 ff ff       	call   801006a0 <cprintf>
    printspaces(columns[3] - digitcount(p->schedule_status.priority));
801052f8:	58                   	pop    %eax
801052f9:	ff 73 1c             	push   0x1c(%ebx)
801052fc:	e8 2f 21 00 00       	call   80107430 <digitcount>
80105301:	89 c2                	mov    %eax,%edx
80105303:	89 f0                	mov    %esi,%eax
80105305:	29 d0                	sub    %edx,%eax
80105307:	89 04 24             	mov    %eax,(%esp)
8010530a:	e8 61 21 00 00       	call   80107470 <printspaces>

    cprintf("%d", (int)p->schedule_status.place);
8010530f:	58                   	pop    %eax
80105310:	5a                   	pop    %edx
80105311:	ff 73 14             	push   0x14(%ebx)
80105314:	68 78 90 10 80       	push   $0x80109078
80105319:	e8 82 b3 ff ff       	call   801006a0 <cprintf>
    printspaces(columns[4] - digitcount((int)p->schedule_status.place));
8010531e:	59                   	pop    %ecx
8010531f:	ff 73 14             	push   0x14(%ebx)
80105322:	e8 09 21 00 00       	call   80107430 <digitcount>
80105327:	89 c2                	mov    %eax,%edx
80105329:	89 f0                	mov    %esi,%eax
8010532b:	29 d0                	sub    %edx,%eax
8010532d:	89 04 24             	mov    %eax,(%esp)
80105330:	e8 3b 21 00 00       	call   80107470 <printspaces>

    cprintf("\n");
80105335:	c7 04 24 eb 94 10 80 	movl   $0x801094eb,(%esp)
8010533c:	e8 5f b3 ff ff       	call   801006a0 <cprintf>
80105341:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105344:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
8010534a:	81 fb 40 72 13 80    	cmp    $0x80137240,%ebx
80105350:	0f 85 fa fe ff ff    	jne    80105250 <print_process_info+0x20>
  }
80105356:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105359:	5b                   	pop    %ebx
8010535a:	5e                   	pop    %esi
8010535b:	5f                   	pop    %edi
8010535c:	5d                   	pop    %ebp
8010535d:	c3                   	ret    
8010535e:	66 90                	xchg   %ax,%ax

80105360 <semaphore_acquire>:
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	57                   	push   %edi
80105364:	56                   	push   %esi
80105365:	53                   	push   %ebx
80105366:	83 ec 38             	sub    $0x38,%esp
80105369:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&sem->lk);
8010536c:	8d 43 04             	lea    0x4(%ebx),%eax
8010536f:	50                   	push   %eax
80105370:	89 45 d8             	mov    %eax,-0x28(%ebp)
80105373:	e8 58 04 00 00       	call   801057d0 <acquire>
  --sem->value;
80105378:	8b 03                	mov    (%ebx),%eax
  if (sem->value < 0)
8010537a:	83 c4 10             	add    $0x10,%esp
  --sem->value;
8010537d:	83 e8 01             	sub    $0x1,%eax
80105380:	89 03                	mov    %eax,(%ebx)
  if (sem->value < 0)
80105382:	85 c0                	test   %eax,%eax
80105384:	78 1a                	js     801053a0 <semaphore_acquire+0x40>
  release(&sem->lk);
80105386:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105389:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010538c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010538f:	5b                   	pop    %ebx
80105390:	5e                   	pop    %esi
80105391:	5f                   	pop    %edi
80105392:	5d                   	pop    %ebp
  release(&sem->lk);
80105393:	e9 d8 03 00 00       	jmp    80105770 <release>
80105398:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010539f:	90                   	nop
    sem->waiting[sem->wlast] = myproc();
801053a0:	8b 73 64             	mov    0x64(%ebx),%esi
  pushcli();
801053a3:	e8 d8 02 00 00       	call   80105680 <pushcli>
  c = mycpu();
801053a8:	e8 63 ec ff ff       	call   80104010 <mycpu>
  p = c->proc;
801053ad:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
801053b3:	e8 18 03 00 00       	call   801056d0 <popcli>
    sem->wlast = (sem->wlast + 1) % NELEM(sem->waiting);
801053b8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
    sem->waiting[sem->wlast] = myproc();
801053bd:	89 7c b3 38          	mov    %edi,0x38(%ebx,%esi,4)
    sem->wlast = (sem->wlast + 1) % NELEM(sem->waiting);
801053c1:	8b 43 64             	mov    0x64(%ebx),%eax
801053c4:	8d 48 01             	lea    0x1(%eax),%ecx
801053c7:	89 c8                	mov    %ecx,%eax
801053c9:	f7 e2                	mul    %edx
801053cb:	c1 ea 03             	shr    $0x3,%edx
801053ce:	8d 04 92             	lea    (%edx,%edx,4),%eax
    for (int i = sem->wfirst; i < sem->wlast - 1; i++)
801053d1:	8b 53 60             	mov    0x60(%ebx),%edx
    sem->wlast = (sem->wlast + 1) % NELEM(sem->waiting);
801053d4:	01 c0                	add    %eax,%eax
801053d6:	29 c1                	sub    %eax,%ecx
    for (int i = sem->wfirst; i < sem->wlast - 1; i++)
801053d8:	8d 79 ff             	lea    -0x1(%ecx),%edi
    sem->wlast = (sem->wlast + 1) % NELEM(sem->waiting);
801053db:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801053de:	89 4b 64             	mov    %ecx,0x64(%ebx)
    for (int i = sem->wfirst; i < sem->wlast - 1; i++)
801053e1:	89 7d dc             	mov    %edi,-0x24(%ebp)
801053e4:	39 d7                	cmp    %edx,%edi
801053e6:	7e 4d                	jle    80105435 <semaphore_acquire+0xd5>
801053e8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
801053eb:	8d 74 93 3c          	lea    0x3c(%ebx,%edx,4),%esi
801053ef:	8d 7c 8b 38          	lea    0x38(%ebx,%ecx,4),%edi
801053f3:	89 d3                	mov    %edx,%ebx
801053f5:	8d 76 00             	lea    0x0(%esi),%esi
      for (int j = i + 1; j < sem->wlast; j++)
801053f8:	83 c3 01             	add    $0x1,%ebx
801053fb:	39 5d e0             	cmp    %ebx,-0x20(%ebp)
801053fe:	7e 2a                	jle    8010542a <semaphore_acquire+0xca>
80105400:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80105403:	89 f0                	mov    %esi,%eax
80105405:	8d 76 00             	lea    0x0(%esi),%esi
        if (sem->waiting[i]->schedule_status.priority < sem->waiting[j]->schedule_status.priority)
80105408:	8b 08                	mov    (%eax),%ecx
8010540a:	8b 56 fc             	mov    -0x4(%esi),%edx
8010540d:	8b 99 88 00 00 00    	mov    0x88(%ecx),%ebx
80105413:	39 9a 88 00 00 00    	cmp    %ebx,0x88(%edx)
80105419:	7d 05                	jge    80105420 <semaphore_acquire+0xc0>
          sem->waiting[i] = sem->waiting[j];
8010541b:	89 4e fc             	mov    %ecx,-0x4(%esi)
          sem->waiting[j] = temp;
8010541e:	89 10                	mov    %edx,(%eax)
      for (int j = i + 1; j < sem->wlast; j++)
80105420:	83 c0 04             	add    $0x4,%eax
80105423:	39 c7                	cmp    %eax,%edi
80105425:	75 e1                	jne    80105408 <semaphore_acquire+0xa8>
80105427:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    for (int i = sem->wfirst; i < sem->wlast - 1; i++)
8010542a:	83 c6 04             	add    $0x4,%esi
8010542d:	39 5d dc             	cmp    %ebx,-0x24(%ebp)
80105430:	75 c6                	jne    801053f8 <semaphore_acquire+0x98>
80105432:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
    for (int i = 0; i < sem->wlast; i++)
80105435:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80105438:	85 c9                	test   %ecx,%ecx
8010543a:	74 32                	je     8010546e <semaphore_acquire+0x10e>
8010543c:	31 f6                	xor    %esi,%esi
8010543e:	66 90                	xchg   %ax,%ax
      acquire(&ptable.lock);
80105440:	83 ec 0c             	sub    $0xc,%esp
80105443:	68 60 6b 13 80       	push   $0x80136b60
80105448:	e8 83 03 00 00       	call   801057d0 <acquire>
      sem->waiting[i]->schedule_status.place =  i;
8010544d:	8b 44 b3 38          	mov    0x38(%ebx,%esi,4),%eax
80105451:	89 b0 80 00 00 00    	mov    %esi,0x80(%eax)
    for (int i = 0; i < sem->wlast; i++)
80105457:	83 c6 01             	add    $0x1,%esi
      release(&ptable.lock);
8010545a:	c7 04 24 60 6b 13 80 	movl   $0x80136b60,(%esp)
80105461:	e8 0a 03 00 00       	call   80105770 <release>
    for (int i = 0; i < sem->wlast; i++)
80105466:	83 c4 10             	add    $0x10,%esp
80105469:	39 73 64             	cmp    %esi,0x64(%ebx)
8010546c:	7f d2                	jg     80105440 <semaphore_acquire+0xe0>
    acquire(&ptable.lock);
8010546e:	83 ec 0c             	sub    $0xc,%esp
80105471:	68 60 6b 13 80       	push   $0x80136b60
80105476:	e8 55 03 00 00       	call   801057d0 <acquire>
    print_process_info();
8010547b:	e8 b0 fd ff ff       	call   80105230 <print_process_info>
    release(&ptable.lock);
80105480:	c7 04 24 60 6b 13 80 	movl   $0x80136b60,(%esp)
80105487:	e8 e4 02 00 00       	call   80105770 <release>
    sleep(sem, &sem->lk);
8010548c:	58                   	pop    %eax
8010548d:	5a                   	pop    %edx
8010548e:	ff 75 d8             	push   -0x28(%ebp)
80105491:	53                   	push   %ebx
80105492:	e8 69 f6 ff ff       	call   80104b00 <sleep>
80105497:	83 c4 10             	add    $0x10,%esp
8010549a:	e9 e7 fe ff ff       	jmp    80105386 <semaphore_acquire+0x26>
8010549f:	90                   	nop

801054a0 <sem_acquire>:
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
  semaphore_acquire(&sems[id], prio);
801054a3:	6b 45 08 6c          	imul   $0x6c,0x8(%ebp),%eax
801054a7:	05 40 45 11 80       	add    $0x80114540,%eax
801054ac:	89 45 08             	mov    %eax,0x8(%ebp)
}
801054af:	5d                   	pop    %ebp
  semaphore_acquire(&sems[id], prio);
801054b0:	e9 ab fe ff ff       	jmp    80105360 <semaphore_acquire>
801054b5:	66 90                	xchg   %ax,%ax
801054b7:	66 90                	xchg   %ax,%ax
801054b9:	66 90                	xchg   %ax,%ax
801054bb:	66 90                	xchg   %ax,%ax
801054bd:	66 90                	xchg   %ax,%ax
801054bf:	90                   	nop

801054c0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801054c0:	55                   	push   %ebp
801054c1:	89 e5                	mov    %esp,%ebp
801054c3:	53                   	push   %ebx
801054c4:	83 ec 0c             	sub    $0xc,%esp
801054c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801054ca:	68 bc 91 10 80       	push   $0x801091bc
801054cf:	8d 43 04             	lea    0x4(%ebx),%eax
801054d2:	50                   	push   %eax
801054d3:	e8 28 01 00 00       	call   80105600 <initlock>
  lk->name = name;
801054d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801054db:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801054e1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801054e4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801054eb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801054ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801054f1:	c9                   	leave  
801054f2:	c3                   	ret    
801054f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105500 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	56                   	push   %esi
80105504:	53                   	push   %ebx
80105505:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105508:	8d 73 04             	lea    0x4(%ebx),%esi
8010550b:	83 ec 0c             	sub    $0xc,%esp
8010550e:	56                   	push   %esi
8010550f:	e8 bc 02 00 00       	call   801057d0 <acquire>
  while (lk->locked) {
80105514:	8b 13                	mov    (%ebx),%edx
80105516:	83 c4 10             	add    $0x10,%esp
80105519:	85 d2                	test   %edx,%edx
8010551b:	74 16                	je     80105533 <acquiresleep+0x33>
8010551d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80105520:	83 ec 08             	sub    $0x8,%esp
80105523:	56                   	push   %esi
80105524:	53                   	push   %ebx
80105525:	e8 d6 f5 ff ff       	call   80104b00 <sleep>
  while (lk->locked) {
8010552a:	8b 03                	mov    (%ebx),%eax
8010552c:	83 c4 10             	add    $0x10,%esp
8010552f:	85 c0                	test   %eax,%eax
80105531:	75 ed                	jne    80105520 <acquiresleep+0x20>
  }
  lk->locked = 1;
80105533:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80105539:	e8 52 eb ff ff       	call   80104090 <myproc>
8010553e:	8b 40 10             	mov    0x10(%eax),%eax
80105541:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80105544:	89 75 08             	mov    %esi,0x8(%ebp)
}
80105547:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010554a:	5b                   	pop    %ebx
8010554b:	5e                   	pop    %esi
8010554c:	5d                   	pop    %ebp
  release(&lk->lk);
8010554d:	e9 1e 02 00 00       	jmp    80105770 <release>
80105552:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105560 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	57                   	push   %edi
80105564:	56                   	push   %esi
80105565:	53                   	push   %ebx
80105566:	83 ec 18             	sub    $0x18,%esp
80105569:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010556c:	8d 73 04             	lea    0x4(%ebx),%esi
8010556f:	56                   	push   %esi
80105570:	e8 5b 02 00 00       	call   801057d0 <acquire>

  if (lk->pid != myproc()->pid) {
80105575:	8b 7b 3c             	mov    0x3c(%ebx),%edi
80105578:	e8 13 eb ff ff       	call   80104090 <myproc>
8010557d:	83 c4 10             	add    $0x10,%esp
80105580:	3b 78 10             	cmp    0x10(%eax),%edi
80105583:	75 19                	jne    8010559e <releasesleep+0x3e>
    return;
  }

  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
80105585:	83 ec 0c             	sub    $0xc,%esp
  lk->locked = 0;
80105588:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010558e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80105595:	53                   	push   %ebx
80105596:	e8 25 f6 ff ff       	call   80104bc0 <wakeup>
  release(&lk->lk);
8010559b:	83 c4 10             	add    $0x10,%esp
8010559e:	89 75 08             	mov    %esi,0x8(%ebp)
}
801055a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055a4:	5b                   	pop    %ebx
801055a5:	5e                   	pop    %esi
801055a6:	5f                   	pop    %edi
801055a7:	5d                   	pop    %ebp
  release(&lk->lk);
801055a8:	e9 c3 01 00 00       	jmp    80105770 <release>
801055ad:	8d 76 00             	lea    0x0(%esi),%esi

801055b0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	57                   	push   %edi
801055b4:	31 ff                	xor    %edi,%edi
801055b6:	56                   	push   %esi
801055b7:	53                   	push   %ebx
801055b8:	83 ec 18             	sub    $0x18,%esp
801055bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801055be:	8d 73 04             	lea    0x4(%ebx),%esi
801055c1:	56                   	push   %esi
801055c2:	e8 09 02 00 00       	call   801057d0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801055c7:	8b 03                	mov    (%ebx),%eax
801055c9:	83 c4 10             	add    $0x10,%esp
801055cc:	85 c0                	test   %eax,%eax
801055ce:	75 18                	jne    801055e8 <holdingsleep+0x38>
  release(&lk->lk);
801055d0:	83 ec 0c             	sub    $0xc,%esp
801055d3:	56                   	push   %esi
801055d4:	e8 97 01 00 00       	call   80105770 <release>
  return r;
}
801055d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055dc:	89 f8                	mov    %edi,%eax
801055de:	5b                   	pop    %ebx
801055df:	5e                   	pop    %esi
801055e0:	5f                   	pop    %edi
801055e1:	5d                   	pop    %ebp
801055e2:	c3                   	ret    
801055e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055e7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
801055e8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801055eb:	e8 a0 ea ff ff       	call   80104090 <myproc>
801055f0:	39 58 10             	cmp    %ebx,0x10(%eax)
801055f3:	0f 94 c0             	sete   %al
801055f6:	0f b6 c0             	movzbl %al,%eax
801055f9:	89 c7                	mov    %eax,%edi
801055fb:	eb d3                	jmp    801055d0 <holdingsleep+0x20>
801055fd:	66 90                	xchg   %ax,%ax
801055ff:	90                   	nop

80105600 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105600:	55                   	push   %ebp
80105601:	89 e5                	mov    %esp,%ebp
80105603:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80105606:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80105609:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010560f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80105612:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105619:	5d                   	pop    %ebp
8010561a:	c3                   	ret    
8010561b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010561f:	90                   	nop

80105620 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105620:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105621:	31 d2                	xor    %edx,%edx
{
80105623:	89 e5                	mov    %esp,%ebp
80105625:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80105626:	8b 45 08             	mov    0x8(%ebp),%eax
{
80105629:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010562c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010562f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105630:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80105636:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010563c:	77 1a                	ja     80105658 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010563e:	8b 58 04             	mov    0x4(%eax),%ebx
80105641:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80105644:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80105647:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105649:	83 fa 0a             	cmp    $0xa,%edx
8010564c:	75 e2                	jne    80105630 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010564e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105651:	c9                   	leave  
80105652:	c3                   	ret    
80105653:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105657:	90                   	nop
  for(; i < 10; i++)
80105658:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010565b:	8d 51 28             	lea    0x28(%ecx),%edx
8010565e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105660:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105666:	83 c0 04             	add    $0x4,%eax
80105669:	39 d0                	cmp    %edx,%eax
8010566b:	75 f3                	jne    80105660 <getcallerpcs+0x40>
}
8010566d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105670:	c9                   	leave  
80105671:	c3                   	ret    
80105672:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105680 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	53                   	push   %ebx
80105684:	83 ec 04             	sub    $0x4,%esp
80105687:	9c                   	pushf  
80105688:	5b                   	pop    %ebx
  asm volatile("cli");
80105689:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010568a:	e8 81 e9 ff ff       	call   80104010 <mycpu>
8010568f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105695:	85 c0                	test   %eax,%eax
80105697:	74 17                	je     801056b0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80105699:	e8 72 e9 ff ff       	call   80104010 <mycpu>
8010569e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801056a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056a8:	c9                   	leave  
801056a9:	c3                   	ret    
801056aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801056b0:	e8 5b e9 ff ff       	call   80104010 <mycpu>
801056b5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801056bb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801056c1:	eb d6                	jmp    80105699 <pushcli+0x19>
801056c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801056d0 <popcli>:

void
popcli(void)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801056d6:	9c                   	pushf  
801056d7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801056d8:	f6 c4 02             	test   $0x2,%ah
801056db:	75 35                	jne    80105712 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801056dd:	e8 2e e9 ff ff       	call   80104010 <mycpu>
801056e2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801056e9:	78 34                	js     8010571f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801056eb:	e8 20 e9 ff ff       	call   80104010 <mycpu>
801056f0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801056f6:	85 d2                	test   %edx,%edx
801056f8:	74 06                	je     80105700 <popcli+0x30>
    sti();
}
801056fa:	c9                   	leave  
801056fb:	c3                   	ret    
801056fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105700:	e8 0b e9 ff ff       	call   80104010 <mycpu>
80105705:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010570b:	85 c0                	test   %eax,%eax
8010570d:	74 eb                	je     801056fa <popcli+0x2a>
  asm volatile("sti");
8010570f:	fb                   	sti    
}
80105710:	c9                   	leave  
80105711:	c3                   	ret    
    panic("popcli - interruptible");
80105712:	83 ec 0c             	sub    $0xc,%esp
80105715:	68 c7 91 10 80       	push   $0x801091c7
8010571a:	e8 61 ac ff ff       	call   80100380 <panic>
    panic("popcli");
8010571f:	83 ec 0c             	sub    $0xc,%esp
80105722:	68 de 91 10 80       	push   $0x801091de
80105727:	e8 54 ac ff ff       	call   80100380 <panic>
8010572c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105730 <holding>:
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	56                   	push   %esi
80105734:	53                   	push   %ebx
80105735:	8b 75 08             	mov    0x8(%ebp),%esi
80105738:	31 db                	xor    %ebx,%ebx
  pushcli();
8010573a:	e8 41 ff ff ff       	call   80105680 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010573f:	8b 06                	mov    (%esi),%eax
80105741:	85 c0                	test   %eax,%eax
80105743:	75 0b                	jne    80105750 <holding+0x20>
  popcli();
80105745:	e8 86 ff ff ff       	call   801056d0 <popcli>
}
8010574a:	89 d8                	mov    %ebx,%eax
8010574c:	5b                   	pop    %ebx
8010574d:	5e                   	pop    %esi
8010574e:	5d                   	pop    %ebp
8010574f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80105750:	8b 5e 08             	mov    0x8(%esi),%ebx
80105753:	e8 b8 e8 ff ff       	call   80104010 <mycpu>
80105758:	39 c3                	cmp    %eax,%ebx
8010575a:	0f 94 c3             	sete   %bl
  popcli();
8010575d:	e8 6e ff ff ff       	call   801056d0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80105762:	0f b6 db             	movzbl %bl,%ebx
}
80105765:	89 d8                	mov    %ebx,%eax
80105767:	5b                   	pop    %ebx
80105768:	5e                   	pop    %esi
80105769:	5d                   	pop    %ebp
8010576a:	c3                   	ret    
8010576b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010576f:	90                   	nop

80105770 <release>:
{
80105770:	55                   	push   %ebp
80105771:	89 e5                	mov    %esp,%ebp
80105773:	56                   	push   %esi
80105774:	53                   	push   %ebx
80105775:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80105778:	e8 03 ff ff ff       	call   80105680 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010577d:	8b 03                	mov    (%ebx),%eax
8010577f:	85 c0                	test   %eax,%eax
80105781:	75 15                	jne    80105798 <release+0x28>
  popcli();
80105783:	e8 48 ff ff ff       	call   801056d0 <popcli>
    panic("release");
80105788:	83 ec 0c             	sub    $0xc,%esp
8010578b:	68 e5 91 10 80       	push   $0x801091e5
80105790:	e8 eb ab ff ff       	call   80100380 <panic>
80105795:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80105798:	8b 73 08             	mov    0x8(%ebx),%esi
8010579b:	e8 70 e8 ff ff       	call   80104010 <mycpu>
801057a0:	39 c6                	cmp    %eax,%esi
801057a2:	75 df                	jne    80105783 <release+0x13>
  popcli();
801057a4:	e8 27 ff ff ff       	call   801056d0 <popcli>
  lk->pcs[0] = 0;
801057a9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801057b0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801057b7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801057bc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801057c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057c5:	5b                   	pop    %ebx
801057c6:	5e                   	pop    %esi
801057c7:	5d                   	pop    %ebp
  popcli();
801057c8:	e9 03 ff ff ff       	jmp    801056d0 <popcli>
801057cd:	8d 76 00             	lea    0x0(%esi),%esi

801057d0 <acquire>:
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	53                   	push   %ebx
801057d4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801057d7:	e8 a4 fe ff ff       	call   80105680 <pushcli>
  if(holding(lk))
801057dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801057df:	e8 9c fe ff ff       	call   80105680 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801057e4:	8b 03                	mov    (%ebx),%eax
801057e6:	85 c0                	test   %eax,%eax
801057e8:	75 7e                	jne    80105868 <acquire+0x98>
  popcli();
801057ea:	e8 e1 fe ff ff       	call   801056d0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801057ef:	b9 01 00 00 00       	mov    $0x1,%ecx
801057f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
801057f8:	8b 55 08             	mov    0x8(%ebp),%edx
801057fb:	89 c8                	mov    %ecx,%eax
801057fd:	f0 87 02             	lock xchg %eax,(%edx)
80105800:	85 c0                	test   %eax,%eax
80105802:	75 f4                	jne    801057f8 <acquire+0x28>
  __sync_synchronize();
80105804:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105809:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010580c:	e8 ff e7 ff ff       	call   80104010 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80105811:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80105814:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80105816:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80105819:	31 c0                	xor    %eax,%eax
8010581b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010581f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105820:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80105826:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010582c:	77 1a                	ja     80105848 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010582e:	8b 5a 04             	mov    0x4(%edx),%ebx
80105831:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80105835:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80105838:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010583a:	83 f8 0a             	cmp    $0xa,%eax
8010583d:	75 e1                	jne    80105820 <acquire+0x50>
}
8010583f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105842:	c9                   	leave  
80105843:	c3                   	ret    
80105844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80105848:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010584c:	8d 51 34             	lea    0x34(%ecx),%edx
8010584f:	90                   	nop
    pcs[i] = 0;
80105850:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105856:	83 c0 04             	add    $0x4,%eax
80105859:	39 c2                	cmp    %eax,%edx
8010585b:	75 f3                	jne    80105850 <acquire+0x80>
}
8010585d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105860:	c9                   	leave  
80105861:	c3                   	ret    
80105862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80105868:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010586b:	e8 a0 e7 ff ff       	call   80104010 <mycpu>
80105870:	39 c3                	cmp    %eax,%ebx
80105872:	0f 85 72 ff ff ff    	jne    801057ea <acquire+0x1a>
  popcli();
80105878:	e8 53 fe ff ff       	call   801056d0 <popcli>
    panic("acquire");
8010587d:	83 ec 0c             	sub    $0xc,%esp
80105880:	68 ed 91 10 80       	push   $0x801091ed
80105885:	e8 f6 aa ff ff       	call   80100380 <panic>
8010588a:	66 90                	xchg   %ax,%ax
8010588c:	66 90                	xchg   %ax,%ax
8010588e:	66 90                	xchg   %ax,%ax

80105890 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105890:	55                   	push   %ebp
80105891:	89 e5                	mov    %esp,%ebp
80105893:	57                   	push   %edi
80105894:	8b 55 08             	mov    0x8(%ebp),%edx
80105897:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010589a:	53                   	push   %ebx
8010589b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010589e:	89 d7                	mov    %edx,%edi
801058a0:	09 cf                	or     %ecx,%edi
801058a2:	83 e7 03             	and    $0x3,%edi
801058a5:	75 29                	jne    801058d0 <memset+0x40>
    c &= 0xFF;
801058a7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801058aa:	c1 e0 18             	shl    $0x18,%eax
801058ad:	89 fb                	mov    %edi,%ebx
801058af:	c1 e9 02             	shr    $0x2,%ecx
801058b2:	c1 e3 10             	shl    $0x10,%ebx
801058b5:	09 d8                	or     %ebx,%eax
801058b7:	09 f8                	or     %edi,%eax
801058b9:	c1 e7 08             	shl    $0x8,%edi
801058bc:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801058be:	89 d7                	mov    %edx,%edi
801058c0:	fc                   	cld    
801058c1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801058c3:	5b                   	pop    %ebx
801058c4:	89 d0                	mov    %edx,%eax
801058c6:	5f                   	pop    %edi
801058c7:	5d                   	pop    %ebp
801058c8:	c3                   	ret    
801058c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801058d0:	89 d7                	mov    %edx,%edi
801058d2:	fc                   	cld    
801058d3:	f3 aa                	rep stos %al,%es:(%edi)
801058d5:	5b                   	pop    %ebx
801058d6:	89 d0                	mov    %edx,%eax
801058d8:	5f                   	pop    %edi
801058d9:	5d                   	pop    %ebp
801058da:	c3                   	ret    
801058db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058df:	90                   	nop

801058e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	56                   	push   %esi
801058e4:	8b 75 10             	mov    0x10(%ebp),%esi
801058e7:	8b 55 08             	mov    0x8(%ebp),%edx
801058ea:	53                   	push   %ebx
801058eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801058ee:	85 f6                	test   %esi,%esi
801058f0:	74 2e                	je     80105920 <memcmp+0x40>
801058f2:	01 c6                	add    %eax,%esi
801058f4:	eb 14                	jmp    8010590a <memcmp+0x2a>
801058f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058fd:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80105900:	83 c0 01             	add    $0x1,%eax
80105903:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80105906:	39 f0                	cmp    %esi,%eax
80105908:	74 16                	je     80105920 <memcmp+0x40>
    if(*s1 != *s2)
8010590a:	0f b6 0a             	movzbl (%edx),%ecx
8010590d:	0f b6 18             	movzbl (%eax),%ebx
80105910:	38 d9                	cmp    %bl,%cl
80105912:	74 ec                	je     80105900 <memcmp+0x20>
      return *s1 - *s2;
80105914:	0f b6 c1             	movzbl %cl,%eax
80105917:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80105919:	5b                   	pop    %ebx
8010591a:	5e                   	pop    %esi
8010591b:	5d                   	pop    %ebp
8010591c:	c3                   	ret    
8010591d:	8d 76 00             	lea    0x0(%esi),%esi
80105920:	5b                   	pop    %ebx
  return 0;
80105921:	31 c0                	xor    %eax,%eax
}
80105923:	5e                   	pop    %esi
80105924:	5d                   	pop    %ebp
80105925:	c3                   	ret    
80105926:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010592d:	8d 76 00             	lea    0x0(%esi),%esi

80105930 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105930:	55                   	push   %ebp
80105931:	89 e5                	mov    %esp,%ebp
80105933:	57                   	push   %edi
80105934:	8b 55 08             	mov    0x8(%ebp),%edx
80105937:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010593a:	56                   	push   %esi
8010593b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010593e:	39 d6                	cmp    %edx,%esi
80105940:	73 26                	jae    80105968 <memmove+0x38>
80105942:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80105945:	39 fa                	cmp    %edi,%edx
80105947:	73 1f                	jae    80105968 <memmove+0x38>
80105949:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010594c:	85 c9                	test   %ecx,%ecx
8010594e:	74 0c                	je     8010595c <memmove+0x2c>
      *--d = *--s;
80105950:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80105954:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80105957:	83 e8 01             	sub    $0x1,%eax
8010595a:	73 f4                	jae    80105950 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010595c:	5e                   	pop    %esi
8010595d:	89 d0                	mov    %edx,%eax
8010595f:	5f                   	pop    %edi
80105960:	5d                   	pop    %ebp
80105961:	c3                   	ret    
80105962:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80105968:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010596b:	89 d7                	mov    %edx,%edi
8010596d:	85 c9                	test   %ecx,%ecx
8010596f:	74 eb                	je     8010595c <memmove+0x2c>
80105971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105978:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105979:	39 c6                	cmp    %eax,%esi
8010597b:	75 fb                	jne    80105978 <memmove+0x48>
}
8010597d:	5e                   	pop    %esi
8010597e:	89 d0                	mov    %edx,%eax
80105980:	5f                   	pop    %edi
80105981:	5d                   	pop    %ebp
80105982:	c3                   	ret    
80105983:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010598a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105990 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80105990:	eb 9e                	jmp    80105930 <memmove>
80105992:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801059a0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801059a0:	55                   	push   %ebp
801059a1:	89 e5                	mov    %esp,%ebp
801059a3:	56                   	push   %esi
801059a4:	8b 75 10             	mov    0x10(%ebp),%esi
801059a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801059aa:	53                   	push   %ebx
801059ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
801059ae:	85 f6                	test   %esi,%esi
801059b0:	74 2e                	je     801059e0 <strncmp+0x40>
801059b2:	01 d6                	add    %edx,%esi
801059b4:	eb 18                	jmp    801059ce <strncmp+0x2e>
801059b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059bd:	8d 76 00             	lea    0x0(%esi),%esi
801059c0:	38 d8                	cmp    %bl,%al
801059c2:	75 14                	jne    801059d8 <strncmp+0x38>
    n--, p++, q++;
801059c4:	83 c2 01             	add    $0x1,%edx
801059c7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801059ca:	39 f2                	cmp    %esi,%edx
801059cc:	74 12                	je     801059e0 <strncmp+0x40>
801059ce:	0f b6 01             	movzbl (%ecx),%eax
801059d1:	0f b6 1a             	movzbl (%edx),%ebx
801059d4:	84 c0                	test   %al,%al
801059d6:	75 e8                	jne    801059c0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801059d8:	29 d8                	sub    %ebx,%eax
}
801059da:	5b                   	pop    %ebx
801059db:	5e                   	pop    %esi
801059dc:	5d                   	pop    %ebp
801059dd:	c3                   	ret    
801059de:	66 90                	xchg   %ax,%ax
801059e0:	5b                   	pop    %ebx
    return 0;
801059e1:	31 c0                	xor    %eax,%eax
}
801059e3:	5e                   	pop    %esi
801059e4:	5d                   	pop    %ebp
801059e5:	c3                   	ret    
801059e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ed:	8d 76 00             	lea    0x0(%esi),%esi

801059f0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	57                   	push   %edi
801059f4:	56                   	push   %esi
801059f5:	8b 75 08             	mov    0x8(%ebp),%esi
801059f8:	53                   	push   %ebx
801059f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801059fc:	89 f0                	mov    %esi,%eax
801059fe:	eb 15                	jmp    80105a15 <strncpy+0x25>
80105a00:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105a04:	8b 7d 0c             	mov    0xc(%ebp),%edi
80105a07:	83 c0 01             	add    $0x1,%eax
80105a0a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80105a0e:	88 50 ff             	mov    %dl,-0x1(%eax)
80105a11:	84 d2                	test   %dl,%dl
80105a13:	74 09                	je     80105a1e <strncpy+0x2e>
80105a15:	89 cb                	mov    %ecx,%ebx
80105a17:	83 e9 01             	sub    $0x1,%ecx
80105a1a:	85 db                	test   %ebx,%ebx
80105a1c:	7f e2                	jg     80105a00 <strncpy+0x10>
    ;
  while(n-- > 0)
80105a1e:	89 c2                	mov    %eax,%edx
80105a20:	85 c9                	test   %ecx,%ecx
80105a22:	7e 17                	jle    80105a3b <strncpy+0x4b>
80105a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105a28:	83 c2 01             	add    $0x1,%edx
80105a2b:	89 c1                	mov    %eax,%ecx
80105a2d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80105a31:	29 d1                	sub    %edx,%ecx
80105a33:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80105a37:	85 c9                	test   %ecx,%ecx
80105a39:	7f ed                	jg     80105a28 <strncpy+0x38>
  return os;
}
80105a3b:	5b                   	pop    %ebx
80105a3c:	89 f0                	mov    %esi,%eax
80105a3e:	5e                   	pop    %esi
80105a3f:	5f                   	pop    %edi
80105a40:	5d                   	pop    %ebp
80105a41:	c3                   	ret    
80105a42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a50 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	56                   	push   %esi
80105a54:	8b 55 10             	mov    0x10(%ebp),%edx
80105a57:	8b 75 08             	mov    0x8(%ebp),%esi
80105a5a:	53                   	push   %ebx
80105a5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105a5e:	85 d2                	test   %edx,%edx
80105a60:	7e 25                	jle    80105a87 <safestrcpy+0x37>
80105a62:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80105a66:	89 f2                	mov    %esi,%edx
80105a68:	eb 16                	jmp    80105a80 <safestrcpy+0x30>
80105a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105a70:	0f b6 08             	movzbl (%eax),%ecx
80105a73:	83 c0 01             	add    $0x1,%eax
80105a76:	83 c2 01             	add    $0x1,%edx
80105a79:	88 4a ff             	mov    %cl,-0x1(%edx)
80105a7c:	84 c9                	test   %cl,%cl
80105a7e:	74 04                	je     80105a84 <safestrcpy+0x34>
80105a80:	39 d8                	cmp    %ebx,%eax
80105a82:	75 ec                	jne    80105a70 <safestrcpy+0x20>
    ;
  *s = 0;
80105a84:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105a87:	89 f0                	mov    %esi,%eax
80105a89:	5b                   	pop    %ebx
80105a8a:	5e                   	pop    %esi
80105a8b:	5d                   	pop    %ebp
80105a8c:	c3                   	ret    
80105a8d:	8d 76 00             	lea    0x0(%esi),%esi

80105a90 <strlen>:

int
strlen(const char *s)
{
80105a90:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105a91:	31 c0                	xor    %eax,%eax
{
80105a93:	89 e5                	mov    %esp,%ebp
80105a95:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105a98:	80 3a 00             	cmpb   $0x0,(%edx)
80105a9b:	74 0c                	je     80105aa9 <strlen+0x19>
80105a9d:	8d 76 00             	lea    0x0(%esi),%esi
80105aa0:	83 c0 01             	add    $0x1,%eax
80105aa3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105aa7:	75 f7                	jne    80105aa0 <strlen+0x10>
    ;
  return n;
}
80105aa9:	5d                   	pop    %ebp
80105aaa:	c3                   	ret    

80105aab <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105aab:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105aaf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105ab3:	55                   	push   %ebp
  pushl %ebx
80105ab4:	53                   	push   %ebx
  pushl %esi
80105ab5:	56                   	push   %esi
  pushl %edi
80105ab6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105ab7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105ab9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105abb:	5f                   	pop    %edi
  popl %esi
80105abc:	5e                   	pop    %esi
  popl %ebx
80105abd:	5b                   	pop    %ebx
  popl %ebp
80105abe:	5d                   	pop    %ebp
  ret
80105abf:	c3                   	ret    

80105ac0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	53                   	push   %ebx
80105ac4:	83 ec 04             	sub    $0x4,%esp
80105ac7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80105aca:	e8 c1 e5 ff ff       	call   80104090 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105acf:	8b 00                	mov    (%eax),%eax
80105ad1:	39 d8                	cmp    %ebx,%eax
80105ad3:	76 1b                	jbe    80105af0 <fetchint+0x30>
80105ad5:	8d 53 04             	lea    0x4(%ebx),%edx
80105ad8:	39 d0                	cmp    %edx,%eax
80105ada:	72 14                	jb     80105af0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105adc:	8b 45 0c             	mov    0xc(%ebp),%eax
80105adf:	8b 13                	mov    (%ebx),%edx
80105ae1:	89 10                	mov    %edx,(%eax)
  return 0;
80105ae3:	31 c0                	xor    %eax,%eax
}
80105ae5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ae8:	c9                   	leave  
80105ae9:	c3                   	ret    
80105aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105af0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105af5:	eb ee                	jmp    80105ae5 <fetchint+0x25>
80105af7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105afe:	66 90                	xchg   %ax,%ax

80105b00 <fetchfloat>:

// Fetch the float at addr from the current process.
int
fetchfloat(uint addr, float *fp)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	53                   	push   %ebx
80105b04:	83 ec 04             	sub    $0x4,%esp
80105b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80105b0a:	e8 81 e5 ff ff       	call   80104090 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105b0f:	8b 00                	mov    (%eax),%eax
80105b11:	39 d8                	cmp    %ebx,%eax
80105b13:	76 1b                	jbe    80105b30 <fetchfloat+0x30>
80105b15:	8d 53 04             	lea    0x4(%ebx),%edx
80105b18:	39 d0                	cmp    %edx,%eax
80105b1a:	72 14                	jb     80105b30 <fetchfloat+0x30>
    return -1;
  *fp = *(float*)(addr);
80105b1c:	d9 03                	flds   (%ebx)
80105b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b21:	d9 18                	fstps  (%eax)
  return 0;
80105b23:	31 c0                	xor    %eax,%eax
}
80105b25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b28:	c9                   	leave  
80105b29:	c3                   	ret    
80105b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105b30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b35:	eb ee                	jmp    80105b25 <fetchfloat+0x25>
80105b37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b3e:	66 90                	xchg   %ax,%ax

80105b40 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105b40:	55                   	push   %ebp
80105b41:	89 e5                	mov    %esp,%ebp
80105b43:	53                   	push   %ebx
80105b44:	83 ec 04             	sub    $0x4,%esp
80105b47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80105b4a:	e8 41 e5 ff ff       	call   80104090 <myproc>

  if(addr >= curproc->sz)
80105b4f:	39 18                	cmp    %ebx,(%eax)
80105b51:	76 2d                	jbe    80105b80 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80105b53:	8b 55 0c             	mov    0xc(%ebp),%edx
80105b56:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105b58:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80105b5a:	39 d3                	cmp    %edx,%ebx
80105b5c:	73 22                	jae    80105b80 <fetchstr+0x40>
80105b5e:	89 d8                	mov    %ebx,%eax
80105b60:	eb 0d                	jmp    80105b6f <fetchstr+0x2f>
80105b62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105b68:	83 c0 01             	add    $0x1,%eax
80105b6b:	39 c2                	cmp    %eax,%edx
80105b6d:	76 11                	jbe    80105b80 <fetchstr+0x40>
    if(*s == 0)
80105b6f:	80 38 00             	cmpb   $0x0,(%eax)
80105b72:	75 f4                	jne    80105b68 <fetchstr+0x28>
      return s - *pp;
80105b74:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105b76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b79:	c9                   	leave  
80105b7a:	c3                   	ret    
80105b7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b7f:	90                   	nop
80105b80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105b83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b88:	c9                   	leave  
80105b89:	c3                   	ret    
80105b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b90 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105b90:	55                   	push   %ebp
80105b91:	89 e5                	mov    %esp,%ebp
80105b93:	56                   	push   %esi
80105b94:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105b95:	e8 f6 e4 ff ff       	call   80104090 <myproc>
80105b9a:	8b 55 08             	mov    0x8(%ebp),%edx
80105b9d:	8b 40 18             	mov    0x18(%eax),%eax
80105ba0:	8b 40 44             	mov    0x44(%eax),%eax
80105ba3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105ba6:	e8 e5 e4 ff ff       	call   80104090 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105bab:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105bae:	8b 00                	mov    (%eax),%eax
80105bb0:	39 c6                	cmp    %eax,%esi
80105bb2:	73 1c                	jae    80105bd0 <argint+0x40>
80105bb4:	8d 53 08             	lea    0x8(%ebx),%edx
80105bb7:	39 d0                	cmp    %edx,%eax
80105bb9:	72 15                	jb     80105bd0 <argint+0x40>
  *ip = *(int*)(addr);
80105bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
80105bbe:	8b 53 04             	mov    0x4(%ebx),%edx
80105bc1:	89 10                	mov    %edx,(%eax)
  return 0;
80105bc3:	31 c0                	xor    %eax,%eax
}
80105bc5:	5b                   	pop    %ebx
80105bc6:	5e                   	pop    %esi
80105bc7:	5d                   	pop    %ebp
80105bc8:	c3                   	ret    
80105bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105bd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105bd5:	eb ee                	jmp    80105bc5 <argint+0x35>
80105bd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bde:	66 90                	xchg   %ax,%ax

80105be0 <argfloat>:

int
argfloat(int n, float *fp)
{
80105be0:	55                   	push   %ebp
80105be1:	89 e5                	mov    %esp,%ebp
80105be3:	56                   	push   %esi
80105be4:	53                   	push   %ebx
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
80105be5:	e8 a6 e4 ff ff       	call   80104090 <myproc>
80105bea:	8b 55 08             	mov    0x8(%ebp),%edx
80105bed:	8b 40 18             	mov    0x18(%eax),%eax
80105bf0:	8b 40 44             	mov    0x44(%eax),%eax
80105bf3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105bf6:	e8 95 e4 ff ff       	call   80104090 <myproc>
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
80105bfb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105bfe:	8b 00                	mov    (%eax),%eax
80105c00:	39 c6                	cmp    %eax,%esi
80105c02:	73 1c                	jae    80105c20 <argfloat+0x40>
80105c04:	8d 53 08             	lea    0x8(%ebx),%edx
80105c07:	39 d0                	cmp    %edx,%eax
80105c09:	72 15                	jb     80105c20 <argfloat+0x40>
  *fp = *(float*)(addr);
80105c0b:	d9 43 04             	flds   0x4(%ebx)
80105c0e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c11:	d9 18                	fstps  (%eax)
  return 0;
80105c13:	31 c0                	xor    %eax,%eax
}
80105c15:	5b                   	pop    %ebx
80105c16:	5e                   	pop    %esi
80105c17:	5d                   	pop    %ebp
80105c18:	c3                   	ret    
80105c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105c20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
80105c25:	eb ee                	jmp    80105c15 <argfloat+0x35>
80105c27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c2e:	66 90                	xchg   %ax,%ax

80105c30 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105c30:	55                   	push   %ebp
80105c31:	89 e5                	mov    %esp,%ebp
80105c33:	57                   	push   %edi
80105c34:	56                   	push   %esi
80105c35:	53                   	push   %ebx
80105c36:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80105c39:	e8 52 e4 ff ff       	call   80104090 <myproc>
80105c3e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105c40:	e8 4b e4 ff ff       	call   80104090 <myproc>
80105c45:	8b 55 08             	mov    0x8(%ebp),%edx
80105c48:	8b 40 18             	mov    0x18(%eax),%eax
80105c4b:	8b 40 44             	mov    0x44(%eax),%eax
80105c4e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105c51:	e8 3a e4 ff ff       	call   80104090 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105c56:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105c59:	8b 00                	mov    (%eax),%eax
80105c5b:	39 c7                	cmp    %eax,%edi
80105c5d:	73 31                	jae    80105c90 <argptr+0x60>
80105c5f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80105c62:	39 c8                	cmp    %ecx,%eax
80105c64:	72 2a                	jb     80105c90 <argptr+0x60>

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105c66:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80105c69:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105c6c:	85 d2                	test   %edx,%edx
80105c6e:	78 20                	js     80105c90 <argptr+0x60>
80105c70:	8b 16                	mov    (%esi),%edx
80105c72:	39 c2                	cmp    %eax,%edx
80105c74:	76 1a                	jbe    80105c90 <argptr+0x60>
80105c76:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105c79:	01 c3                	add    %eax,%ebx
80105c7b:	39 da                	cmp    %ebx,%edx
80105c7d:	72 11                	jb     80105c90 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80105c7f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105c82:	89 02                	mov    %eax,(%edx)
  return 0;
80105c84:	31 c0                	xor    %eax,%eax
}
80105c86:	83 c4 0c             	add    $0xc,%esp
80105c89:	5b                   	pop    %ebx
80105c8a:	5e                   	pop    %esi
80105c8b:	5f                   	pop    %edi
80105c8c:	5d                   	pop    %ebp
80105c8d:	c3                   	ret    
80105c8e:	66 90                	xchg   %ax,%ax
    return -1;
80105c90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c95:	eb ef                	jmp    80105c86 <argptr+0x56>
80105c97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c9e:	66 90                	xchg   %ax,%ax

80105ca0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105ca0:	55                   	push   %ebp
80105ca1:	89 e5                	mov    %esp,%ebp
80105ca3:	56                   	push   %esi
80105ca4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105ca5:	e8 e6 e3 ff ff       	call   80104090 <myproc>
80105caa:	8b 55 08             	mov    0x8(%ebp),%edx
80105cad:	8b 40 18             	mov    0x18(%eax),%eax
80105cb0:	8b 40 44             	mov    0x44(%eax),%eax
80105cb3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105cb6:	e8 d5 e3 ff ff       	call   80104090 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105cbb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105cbe:	8b 00                	mov    (%eax),%eax
80105cc0:	39 c6                	cmp    %eax,%esi
80105cc2:	73 44                	jae    80105d08 <argstr+0x68>
80105cc4:	8d 53 08             	lea    0x8(%ebx),%edx
80105cc7:	39 d0                	cmp    %edx,%eax
80105cc9:	72 3d                	jb     80105d08 <argstr+0x68>
  *ip = *(int*)(addr);
80105ccb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80105cce:	e8 bd e3 ff ff       	call   80104090 <myproc>
  if(addr >= curproc->sz)
80105cd3:	3b 18                	cmp    (%eax),%ebx
80105cd5:	73 31                	jae    80105d08 <argstr+0x68>
  *pp = (char*)addr;
80105cd7:	8b 55 0c             	mov    0xc(%ebp),%edx
80105cda:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105cdc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80105cde:	39 d3                	cmp    %edx,%ebx
80105ce0:	73 26                	jae    80105d08 <argstr+0x68>
80105ce2:	89 d8                	mov    %ebx,%eax
80105ce4:	eb 11                	jmp    80105cf7 <argstr+0x57>
80105ce6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ced:	8d 76 00             	lea    0x0(%esi),%esi
80105cf0:	83 c0 01             	add    $0x1,%eax
80105cf3:	39 c2                	cmp    %eax,%edx
80105cf5:	76 11                	jbe    80105d08 <argstr+0x68>
    if(*s == 0)
80105cf7:	80 38 00             	cmpb   $0x0,(%eax)
80105cfa:	75 f4                	jne    80105cf0 <argstr+0x50>
      return s - *pp;
80105cfc:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80105cfe:	5b                   	pop    %ebx
80105cff:	5e                   	pop    %esi
80105d00:	5d                   	pop    %ebp
80105d01:	c3                   	ret    
80105d02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105d08:	5b                   	pop    %ebx
    return -1;
80105d09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d0e:	5e                   	pop    %esi
80105d0f:	5d                   	pop    %ebp
80105d10:	c3                   	ret    
80105d11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d1f:	90                   	nop

80105d20 <syscall>:
[SYS_sem_release]               sys_sem_release,
};

void
syscall(void)
{
80105d20:	55                   	push   %ebp
80105d21:	89 e5                	mov    %esp,%ebp
80105d23:	56                   	push   %esi
80105d24:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80105d25:	e8 66 e3 ff ff       	call   80104090 <myproc>
80105d2a:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105d2c:	8b 40 18             	mov    0x18(%eax),%eax
80105d2f:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105d32:	8d 50 ff             	lea    -0x1(%eax),%edx
80105d35:	83 fa 21             	cmp    $0x21,%edx
80105d38:	77 2e                	ja     80105d68 <syscall+0x48>
80105d3a:	8b 34 85 20 92 10 80 	mov    -0x7fef6de0(,%eax,4),%esi
80105d41:	85 f6                	test   %esi,%esi
80105d43:	74 23                	je     80105d68 <syscall+0x48>
    push_p_hist(curproc->pid, num);
80105d45:	83 ec 08             	sub    $0x8,%esp
80105d48:	50                   	push   %eax
80105d49:	ff 73 10             	push   0x10(%ebx)
80105d4c:	e8 3f f0 ff ff       	call   80104d90 <push_p_hist>
    curproc->tf->eax = syscalls[num]();
80105d51:	ff d6                	call   *%esi
80105d53:	83 c4 10             	add    $0x10,%esp
80105d56:	89 c2                	mov    %eax,%edx
80105d58:	8b 43 18             	mov    0x18(%ebx),%eax
80105d5b:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105d5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d61:	5b                   	pop    %ebx
80105d62:	5e                   	pop    %esi
80105d63:	5d                   	pop    %ebp
80105d64:	c3                   	ret    
80105d65:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105d68:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105d69:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105d6c:	50                   	push   %eax
80105d6d:	ff 73 10             	push   0x10(%ebx)
80105d70:	68 f5 91 10 80       	push   $0x801091f5
80105d75:	e8 26 a9 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80105d7a:	8b 43 18             	mov    0x18(%ebx),%eax
80105d7d:	83 c4 10             	add    $0x10,%esp
80105d80:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105d87:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d8a:	5b                   	pop    %ebx
80105d8b:	5e                   	pop    %esi
80105d8c:	5d                   	pop    %ebp
80105d8d:	c3                   	ret    
80105d8e:	66 90                	xchg   %ax,%ax

80105d90 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105d90:	55                   	push   %ebp
80105d91:	89 e5                	mov    %esp,%ebp
80105d93:	57                   	push   %edi
80105d94:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105d95:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105d98:	53                   	push   %ebx
80105d99:	83 ec 34             	sub    $0x34,%esp
80105d9c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80105d9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105da2:	57                   	push   %edi
80105da3:	50                   	push   %eax
{
80105da4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105da7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105daa:	e8 c1 c9 ff ff       	call   80102770 <nameiparent>
80105daf:	83 c4 10             	add    $0x10,%esp
80105db2:	85 c0                	test   %eax,%eax
80105db4:	0f 84 46 01 00 00    	je     80105f00 <create+0x170>
    return 0;
  ilock(dp);
80105dba:	83 ec 0c             	sub    $0xc,%esp
80105dbd:	89 c3                	mov    %eax,%ebx
80105dbf:	50                   	push   %eax
80105dc0:	e8 8b bf ff ff       	call   80101d50 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105dc5:	83 c4 0c             	add    $0xc,%esp
80105dc8:	6a 00                	push   $0x0
80105dca:	57                   	push   %edi
80105dcb:	53                   	push   %ebx
80105dcc:	e8 bf c5 ff ff       	call   80102390 <dirlookup>
80105dd1:	83 c4 10             	add    $0x10,%esp
80105dd4:	89 c6                	mov    %eax,%esi
80105dd6:	85 c0                	test   %eax,%eax
80105dd8:	74 56                	je     80105e30 <create+0xa0>
    iunlockput(dp);
80105dda:	83 ec 0c             	sub    $0xc,%esp
80105ddd:	53                   	push   %ebx
80105dde:	e8 fd c1 ff ff       	call   80101fe0 <iunlockput>
    ilock(ip);
80105de3:	89 34 24             	mov    %esi,(%esp)
80105de6:	e8 65 bf ff ff       	call   80101d50 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105deb:	83 c4 10             	add    $0x10,%esp
80105dee:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105df3:	75 1b                	jne    80105e10 <create+0x80>
80105df5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80105dfa:	75 14                	jne    80105e10 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105dfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105dff:	89 f0                	mov    %esi,%eax
80105e01:	5b                   	pop    %ebx
80105e02:	5e                   	pop    %esi
80105e03:	5f                   	pop    %edi
80105e04:	5d                   	pop    %ebp
80105e05:	c3                   	ret    
80105e06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e0d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105e10:	83 ec 0c             	sub    $0xc,%esp
80105e13:	56                   	push   %esi
    return 0;
80105e14:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105e16:	e8 c5 c1 ff ff       	call   80101fe0 <iunlockput>
    return 0;
80105e1b:	83 c4 10             	add    $0x10,%esp
}
80105e1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e21:	89 f0                	mov    %esi,%eax
80105e23:	5b                   	pop    %ebx
80105e24:	5e                   	pop    %esi
80105e25:	5f                   	pop    %edi
80105e26:	5d                   	pop    %ebp
80105e27:	c3                   	ret    
80105e28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e2f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105e30:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105e34:	83 ec 08             	sub    $0x8,%esp
80105e37:	50                   	push   %eax
80105e38:	ff 33                	push   (%ebx)
80105e3a:	e8 a1 bd ff ff       	call   80101be0 <ialloc>
80105e3f:	83 c4 10             	add    $0x10,%esp
80105e42:	89 c6                	mov    %eax,%esi
80105e44:	85 c0                	test   %eax,%eax
80105e46:	0f 84 cd 00 00 00    	je     80105f19 <create+0x189>
  ilock(ip);
80105e4c:	83 ec 0c             	sub    $0xc,%esp
80105e4f:	50                   	push   %eax
80105e50:	e8 fb be ff ff       	call   80101d50 <ilock>
  ip->major = major;
80105e55:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105e59:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80105e5d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105e61:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105e65:	b8 01 00 00 00       	mov    $0x1,%eax
80105e6a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80105e6e:	89 34 24             	mov    %esi,(%esp)
80105e71:	e8 2a be ff ff       	call   80101ca0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105e76:	83 c4 10             	add    $0x10,%esp
80105e79:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105e7e:	74 30                	je     80105eb0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105e80:	83 ec 04             	sub    $0x4,%esp
80105e83:	ff 76 04             	push   0x4(%esi)
80105e86:	57                   	push   %edi
80105e87:	53                   	push   %ebx
80105e88:	e8 03 c8 ff ff       	call   80102690 <dirlink>
80105e8d:	83 c4 10             	add    $0x10,%esp
80105e90:	85 c0                	test   %eax,%eax
80105e92:	78 78                	js     80105f0c <create+0x17c>
  iunlockput(dp);
80105e94:	83 ec 0c             	sub    $0xc,%esp
80105e97:	53                   	push   %ebx
80105e98:	e8 43 c1 ff ff       	call   80101fe0 <iunlockput>
  return ip;
80105e9d:	83 c4 10             	add    $0x10,%esp
}
80105ea0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ea3:	89 f0                	mov    %esi,%eax
80105ea5:	5b                   	pop    %ebx
80105ea6:	5e                   	pop    %esi
80105ea7:	5f                   	pop    %edi
80105ea8:	5d                   	pop    %ebp
80105ea9:	c3                   	ret    
80105eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105eb0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105eb3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105eb8:	53                   	push   %ebx
80105eb9:	e8 e2 bd ff ff       	call   80101ca0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105ebe:	83 c4 0c             	add    $0xc,%esp
80105ec1:	ff 76 04             	push   0x4(%esi)
80105ec4:	68 c8 92 10 80       	push   $0x801092c8
80105ec9:	56                   	push   %esi
80105eca:	e8 c1 c7 ff ff       	call   80102690 <dirlink>
80105ecf:	83 c4 10             	add    $0x10,%esp
80105ed2:	85 c0                	test   %eax,%eax
80105ed4:	78 18                	js     80105eee <create+0x15e>
80105ed6:	83 ec 04             	sub    $0x4,%esp
80105ed9:	ff 73 04             	push   0x4(%ebx)
80105edc:	68 c7 92 10 80       	push   $0x801092c7
80105ee1:	56                   	push   %esi
80105ee2:	e8 a9 c7 ff ff       	call   80102690 <dirlink>
80105ee7:	83 c4 10             	add    $0x10,%esp
80105eea:	85 c0                	test   %eax,%eax
80105eec:	79 92                	jns    80105e80 <create+0xf0>
      panic("create dots");
80105eee:	83 ec 0c             	sub    $0xc,%esp
80105ef1:	68 bb 92 10 80       	push   $0x801092bb
80105ef6:	e8 85 a4 ff ff       	call   80100380 <panic>
80105efb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105eff:	90                   	nop
}
80105f00:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105f03:	31 f6                	xor    %esi,%esi
}
80105f05:	5b                   	pop    %ebx
80105f06:	89 f0                	mov    %esi,%eax
80105f08:	5e                   	pop    %esi
80105f09:	5f                   	pop    %edi
80105f0a:	5d                   	pop    %ebp
80105f0b:	c3                   	ret    
    panic("create: dirlink");
80105f0c:	83 ec 0c             	sub    $0xc,%esp
80105f0f:	68 ca 92 10 80       	push   $0x801092ca
80105f14:	e8 67 a4 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80105f19:	83 ec 0c             	sub    $0xc,%esp
80105f1c:	68 ac 92 10 80       	push   $0x801092ac
80105f21:	e8 5a a4 ff ff       	call   80100380 <panic>
80105f26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f2d:	8d 76 00             	lea    0x0(%esi),%esi

80105f30 <sys_dup>:
{
80105f30:	55                   	push   %ebp
80105f31:	89 e5                	mov    %esp,%ebp
80105f33:	56                   	push   %esi
80105f34:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105f35:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105f38:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105f3b:	50                   	push   %eax
80105f3c:	6a 00                	push   $0x0
80105f3e:	e8 4d fc ff ff       	call   80105b90 <argint>
80105f43:	83 c4 10             	add    $0x10,%esp
80105f46:	85 c0                	test   %eax,%eax
80105f48:	78 36                	js     80105f80 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105f4a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105f4e:	77 30                	ja     80105f80 <sys_dup+0x50>
80105f50:	e8 3b e1 ff ff       	call   80104090 <myproc>
80105f55:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f58:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80105f5c:	85 f6                	test   %esi,%esi
80105f5e:	74 20                	je     80105f80 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105f60:	e8 2b e1 ff ff       	call   80104090 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105f65:	31 db                	xor    %ebx,%ebx
80105f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f6e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105f70:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105f74:	85 d2                	test   %edx,%edx
80105f76:	74 18                	je     80105f90 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105f78:	83 c3 01             	add    $0x1,%ebx
80105f7b:	83 fb 10             	cmp    $0x10,%ebx
80105f7e:	75 f0                	jne    80105f70 <sys_dup+0x40>
}
80105f80:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105f83:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105f88:	89 d8                	mov    %ebx,%eax
80105f8a:	5b                   	pop    %ebx
80105f8b:	5e                   	pop    %esi
80105f8c:	5d                   	pop    %ebp
80105f8d:	c3                   	ret    
80105f8e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105f90:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105f93:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105f97:	56                   	push   %esi
80105f98:	e8 53 b4 ff ff       	call   801013f0 <filedup>
  return fd;
80105f9d:	83 c4 10             	add    $0x10,%esp
}
80105fa0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105fa3:	89 d8                	mov    %ebx,%eax
80105fa5:	5b                   	pop    %ebx
80105fa6:	5e                   	pop    %esi
80105fa7:	5d                   	pop    %ebp
80105fa8:	c3                   	ret    
80105fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105fb0 <sys_read>:
{
80105fb0:	55                   	push   %ebp
80105fb1:	89 e5                	mov    %esp,%ebp
80105fb3:	56                   	push   %esi
80105fb4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105fb5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105fb8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105fbb:	53                   	push   %ebx
80105fbc:	6a 00                	push   $0x0
80105fbe:	e8 cd fb ff ff       	call   80105b90 <argint>
80105fc3:	83 c4 10             	add    $0x10,%esp
80105fc6:	85 c0                	test   %eax,%eax
80105fc8:	78 5e                	js     80106028 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105fca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105fce:	77 58                	ja     80106028 <sys_read+0x78>
80105fd0:	e8 bb e0 ff ff       	call   80104090 <myproc>
80105fd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105fd8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80105fdc:	85 f6                	test   %esi,%esi
80105fde:	74 48                	je     80106028 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105fe0:	83 ec 08             	sub    $0x8,%esp
80105fe3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105fe6:	50                   	push   %eax
80105fe7:	6a 02                	push   $0x2
80105fe9:	e8 a2 fb ff ff       	call   80105b90 <argint>
80105fee:	83 c4 10             	add    $0x10,%esp
80105ff1:	85 c0                	test   %eax,%eax
80105ff3:	78 33                	js     80106028 <sys_read+0x78>
80105ff5:	83 ec 04             	sub    $0x4,%esp
80105ff8:	ff 75 f0             	push   -0x10(%ebp)
80105ffb:	53                   	push   %ebx
80105ffc:	6a 01                	push   $0x1
80105ffe:	e8 2d fc ff ff       	call   80105c30 <argptr>
80106003:	83 c4 10             	add    $0x10,%esp
80106006:	85 c0                	test   %eax,%eax
80106008:	78 1e                	js     80106028 <sys_read+0x78>
  return fileread(f, p, n);
8010600a:	83 ec 04             	sub    $0x4,%esp
8010600d:	ff 75 f0             	push   -0x10(%ebp)
80106010:	ff 75 f4             	push   -0xc(%ebp)
80106013:	56                   	push   %esi
80106014:	e8 57 b5 ff ff       	call   80101570 <fileread>
80106019:	83 c4 10             	add    $0x10,%esp
}
8010601c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010601f:	5b                   	pop    %ebx
80106020:	5e                   	pop    %esi
80106021:	5d                   	pop    %ebp
80106022:	c3                   	ret    
80106023:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106027:	90                   	nop
    return -1;
80106028:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010602d:	eb ed                	jmp    8010601c <sys_read+0x6c>
8010602f:	90                   	nop

80106030 <sys_write>:
{
80106030:	55                   	push   %ebp
80106031:	89 e5                	mov    %esp,%ebp
80106033:	56                   	push   %esi
80106034:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106035:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80106038:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010603b:	53                   	push   %ebx
8010603c:	6a 00                	push   $0x0
8010603e:	e8 4d fb ff ff       	call   80105b90 <argint>
80106043:	83 c4 10             	add    $0x10,%esp
80106046:	85 c0                	test   %eax,%eax
80106048:	78 5e                	js     801060a8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010604a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010604e:	77 58                	ja     801060a8 <sys_write+0x78>
80106050:	e8 3b e0 ff ff       	call   80104090 <myproc>
80106055:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106058:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010605c:	85 f6                	test   %esi,%esi
8010605e:	74 48                	je     801060a8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106060:	83 ec 08             	sub    $0x8,%esp
80106063:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106066:	50                   	push   %eax
80106067:	6a 02                	push   $0x2
80106069:	e8 22 fb ff ff       	call   80105b90 <argint>
8010606e:	83 c4 10             	add    $0x10,%esp
80106071:	85 c0                	test   %eax,%eax
80106073:	78 33                	js     801060a8 <sys_write+0x78>
80106075:	83 ec 04             	sub    $0x4,%esp
80106078:	ff 75 f0             	push   -0x10(%ebp)
8010607b:	53                   	push   %ebx
8010607c:	6a 01                	push   $0x1
8010607e:	e8 ad fb ff ff       	call   80105c30 <argptr>
80106083:	83 c4 10             	add    $0x10,%esp
80106086:	85 c0                	test   %eax,%eax
80106088:	78 1e                	js     801060a8 <sys_write+0x78>
  return filewrite(f, p, n);
8010608a:	83 ec 04             	sub    $0x4,%esp
8010608d:	ff 75 f0             	push   -0x10(%ebp)
80106090:	ff 75 f4             	push   -0xc(%ebp)
80106093:	56                   	push   %esi
80106094:	e8 67 b5 ff ff       	call   80101600 <filewrite>
80106099:	83 c4 10             	add    $0x10,%esp
}
8010609c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010609f:	5b                   	pop    %ebx
801060a0:	5e                   	pop    %esi
801060a1:	5d                   	pop    %ebp
801060a2:	c3                   	ret    
801060a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801060a7:	90                   	nop
    return -1;
801060a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060ad:	eb ed                	jmp    8010609c <sys_write+0x6c>
801060af:	90                   	nop

801060b0 <sys_close>:
{
801060b0:	55                   	push   %ebp
801060b1:	89 e5                	mov    %esp,%ebp
801060b3:	56                   	push   %esi
801060b4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801060b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801060b8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801060bb:	50                   	push   %eax
801060bc:	6a 00                	push   $0x0
801060be:	e8 cd fa ff ff       	call   80105b90 <argint>
801060c3:	83 c4 10             	add    $0x10,%esp
801060c6:	85 c0                	test   %eax,%eax
801060c8:	78 3e                	js     80106108 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801060ca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801060ce:	77 38                	ja     80106108 <sys_close+0x58>
801060d0:	e8 bb df ff ff       	call   80104090 <myproc>
801060d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801060d8:	8d 5a 08             	lea    0x8(%edx),%ebx
801060db:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
801060df:	85 f6                	test   %esi,%esi
801060e1:	74 25                	je     80106108 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
801060e3:	e8 a8 df ff ff       	call   80104090 <myproc>
  fileclose(f);
801060e8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801060eb:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
801060f2:	00 
  fileclose(f);
801060f3:	56                   	push   %esi
801060f4:	e8 47 b3 ff ff       	call   80101440 <fileclose>
  return 0;
801060f9:	83 c4 10             	add    $0x10,%esp
801060fc:	31 c0                	xor    %eax,%eax
}
801060fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106101:	5b                   	pop    %ebx
80106102:	5e                   	pop    %esi
80106103:	5d                   	pop    %ebp
80106104:	c3                   	ret    
80106105:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106108:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010610d:	eb ef                	jmp    801060fe <sys_close+0x4e>
8010610f:	90                   	nop

80106110 <sys_fstat>:
{
80106110:	55                   	push   %ebp
80106111:	89 e5                	mov    %esp,%ebp
80106113:	56                   	push   %esi
80106114:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106115:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80106118:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010611b:	53                   	push   %ebx
8010611c:	6a 00                	push   $0x0
8010611e:	e8 6d fa ff ff       	call   80105b90 <argint>
80106123:	83 c4 10             	add    $0x10,%esp
80106126:	85 c0                	test   %eax,%eax
80106128:	78 46                	js     80106170 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010612a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010612e:	77 40                	ja     80106170 <sys_fstat+0x60>
80106130:	e8 5b df ff ff       	call   80104090 <myproc>
80106135:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106138:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010613c:	85 f6                	test   %esi,%esi
8010613e:	74 30                	je     80106170 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106140:	83 ec 04             	sub    $0x4,%esp
80106143:	6a 14                	push   $0x14
80106145:	53                   	push   %ebx
80106146:	6a 01                	push   $0x1
80106148:	e8 e3 fa ff ff       	call   80105c30 <argptr>
8010614d:	83 c4 10             	add    $0x10,%esp
80106150:	85 c0                	test   %eax,%eax
80106152:	78 1c                	js     80106170 <sys_fstat+0x60>
  return filestat(f, st);
80106154:	83 ec 08             	sub    $0x8,%esp
80106157:	ff 75 f4             	push   -0xc(%ebp)
8010615a:	56                   	push   %esi
8010615b:	e8 c0 b3 ff ff       	call   80101520 <filestat>
80106160:	83 c4 10             	add    $0x10,%esp
}
80106163:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106166:	5b                   	pop    %ebx
80106167:	5e                   	pop    %esi
80106168:	5d                   	pop    %ebp
80106169:	c3                   	ret    
8010616a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80106170:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106175:	eb ec                	jmp    80106163 <sys_fstat+0x53>
80106177:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010617e:	66 90                	xchg   %ax,%ax

80106180 <sys_link>:
{
80106180:	55                   	push   %ebp
80106181:	89 e5                	mov    %esp,%ebp
80106183:	57                   	push   %edi
80106184:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106185:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80106188:	53                   	push   %ebx
80106189:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010618c:	50                   	push   %eax
8010618d:	6a 00                	push   $0x0
8010618f:	e8 0c fb ff ff       	call   80105ca0 <argstr>
80106194:	83 c4 10             	add    $0x10,%esp
80106197:	85 c0                	test   %eax,%eax
80106199:	0f 88 fb 00 00 00    	js     8010629a <sys_link+0x11a>
8010619f:	83 ec 08             	sub    $0x8,%esp
801061a2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801061a5:	50                   	push   %eax
801061a6:	6a 01                	push   $0x1
801061a8:	e8 f3 fa ff ff       	call   80105ca0 <argstr>
801061ad:	83 c4 10             	add    $0x10,%esp
801061b0:	85 c0                	test   %eax,%eax
801061b2:	0f 88 e2 00 00 00    	js     8010629a <sys_link+0x11a>
  begin_op();
801061b8:	e8 53 d2 ff ff       	call   80103410 <begin_op>
  if((ip = namei(old)) == 0){
801061bd:	83 ec 0c             	sub    $0xc,%esp
801061c0:	ff 75 d4             	push   -0x2c(%ebp)
801061c3:	e8 88 c5 ff ff       	call   80102750 <namei>
801061c8:	83 c4 10             	add    $0x10,%esp
801061cb:	89 c3                	mov    %eax,%ebx
801061cd:	85 c0                	test   %eax,%eax
801061cf:	0f 84 e4 00 00 00    	je     801062b9 <sys_link+0x139>
  ilock(ip);
801061d5:	83 ec 0c             	sub    $0xc,%esp
801061d8:	50                   	push   %eax
801061d9:	e8 72 bb ff ff       	call   80101d50 <ilock>
  if(ip->type == T_DIR){
801061de:	83 c4 10             	add    $0x10,%esp
801061e1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801061e6:	0f 84 b5 00 00 00    	je     801062a1 <sys_link+0x121>
  iupdate(ip);
801061ec:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801061ef:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801061f4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801061f7:	53                   	push   %ebx
801061f8:	e8 a3 ba ff ff       	call   80101ca0 <iupdate>
  iunlock(ip);
801061fd:	89 1c 24             	mov    %ebx,(%esp)
80106200:	e8 2b bc ff ff       	call   80101e30 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80106205:	58                   	pop    %eax
80106206:	5a                   	pop    %edx
80106207:	57                   	push   %edi
80106208:	ff 75 d0             	push   -0x30(%ebp)
8010620b:	e8 60 c5 ff ff       	call   80102770 <nameiparent>
80106210:	83 c4 10             	add    $0x10,%esp
80106213:	89 c6                	mov    %eax,%esi
80106215:	85 c0                	test   %eax,%eax
80106217:	74 5b                	je     80106274 <sys_link+0xf4>
  ilock(dp);
80106219:	83 ec 0c             	sub    $0xc,%esp
8010621c:	50                   	push   %eax
8010621d:	e8 2e bb ff ff       	call   80101d50 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80106222:	8b 03                	mov    (%ebx),%eax
80106224:	83 c4 10             	add    $0x10,%esp
80106227:	39 06                	cmp    %eax,(%esi)
80106229:	75 3d                	jne    80106268 <sys_link+0xe8>
8010622b:	83 ec 04             	sub    $0x4,%esp
8010622e:	ff 73 04             	push   0x4(%ebx)
80106231:	57                   	push   %edi
80106232:	56                   	push   %esi
80106233:	e8 58 c4 ff ff       	call   80102690 <dirlink>
80106238:	83 c4 10             	add    $0x10,%esp
8010623b:	85 c0                	test   %eax,%eax
8010623d:	78 29                	js     80106268 <sys_link+0xe8>
  iunlockput(dp);
8010623f:	83 ec 0c             	sub    $0xc,%esp
80106242:	56                   	push   %esi
80106243:	e8 98 bd ff ff       	call   80101fe0 <iunlockput>
  iput(ip);
80106248:	89 1c 24             	mov    %ebx,(%esp)
8010624b:	e8 30 bc ff ff       	call   80101e80 <iput>
  end_op();
80106250:	e8 2b d2 ff ff       	call   80103480 <end_op>
  return 0;
80106255:	83 c4 10             	add    $0x10,%esp
80106258:	31 c0                	xor    %eax,%eax
}
8010625a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010625d:	5b                   	pop    %ebx
8010625e:	5e                   	pop    %esi
8010625f:	5f                   	pop    %edi
80106260:	5d                   	pop    %ebp
80106261:	c3                   	ret    
80106262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80106268:	83 ec 0c             	sub    $0xc,%esp
8010626b:	56                   	push   %esi
8010626c:	e8 6f bd ff ff       	call   80101fe0 <iunlockput>
    goto bad;
80106271:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80106274:	83 ec 0c             	sub    $0xc,%esp
80106277:	53                   	push   %ebx
80106278:	e8 d3 ba ff ff       	call   80101d50 <ilock>
  ip->nlink--;
8010627d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80106282:	89 1c 24             	mov    %ebx,(%esp)
80106285:	e8 16 ba ff ff       	call   80101ca0 <iupdate>
  iunlockput(ip);
8010628a:	89 1c 24             	mov    %ebx,(%esp)
8010628d:	e8 4e bd ff ff       	call   80101fe0 <iunlockput>
  end_op();
80106292:	e8 e9 d1 ff ff       	call   80103480 <end_op>
  return -1;
80106297:	83 c4 10             	add    $0x10,%esp
8010629a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010629f:	eb b9                	jmp    8010625a <sys_link+0xda>
    iunlockput(ip);
801062a1:	83 ec 0c             	sub    $0xc,%esp
801062a4:	53                   	push   %ebx
801062a5:	e8 36 bd ff ff       	call   80101fe0 <iunlockput>
    end_op();
801062aa:	e8 d1 d1 ff ff       	call   80103480 <end_op>
    return -1;
801062af:	83 c4 10             	add    $0x10,%esp
801062b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062b7:	eb a1                	jmp    8010625a <sys_link+0xda>
    end_op();
801062b9:	e8 c2 d1 ff ff       	call   80103480 <end_op>
    return -1;
801062be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062c3:	eb 95                	jmp    8010625a <sys_link+0xda>
801062c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801062d0 <sys_unlink>:
{
801062d0:	55                   	push   %ebp
801062d1:	89 e5                	mov    %esp,%ebp
801062d3:	57                   	push   %edi
801062d4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801062d5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801062d8:	53                   	push   %ebx
801062d9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801062dc:	50                   	push   %eax
801062dd:	6a 00                	push   $0x0
801062df:	e8 bc f9 ff ff       	call   80105ca0 <argstr>
801062e4:	83 c4 10             	add    $0x10,%esp
801062e7:	85 c0                	test   %eax,%eax
801062e9:	0f 88 7a 01 00 00    	js     80106469 <sys_unlink+0x199>
  begin_op();
801062ef:	e8 1c d1 ff ff       	call   80103410 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801062f4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801062f7:	83 ec 08             	sub    $0x8,%esp
801062fa:	53                   	push   %ebx
801062fb:	ff 75 c0             	push   -0x40(%ebp)
801062fe:	e8 6d c4 ff ff       	call   80102770 <nameiparent>
80106303:	83 c4 10             	add    $0x10,%esp
80106306:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80106309:	85 c0                	test   %eax,%eax
8010630b:	0f 84 62 01 00 00    	je     80106473 <sys_unlink+0x1a3>
  ilock(dp);
80106311:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80106314:	83 ec 0c             	sub    $0xc,%esp
80106317:	57                   	push   %edi
80106318:	e8 33 ba ff ff       	call   80101d50 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010631d:	58                   	pop    %eax
8010631e:	5a                   	pop    %edx
8010631f:	68 c8 92 10 80       	push   $0x801092c8
80106324:	53                   	push   %ebx
80106325:	e8 46 c0 ff ff       	call   80102370 <namecmp>
8010632a:	83 c4 10             	add    $0x10,%esp
8010632d:	85 c0                	test   %eax,%eax
8010632f:	0f 84 fb 00 00 00    	je     80106430 <sys_unlink+0x160>
80106335:	83 ec 08             	sub    $0x8,%esp
80106338:	68 c7 92 10 80       	push   $0x801092c7
8010633d:	53                   	push   %ebx
8010633e:	e8 2d c0 ff ff       	call   80102370 <namecmp>
80106343:	83 c4 10             	add    $0x10,%esp
80106346:	85 c0                	test   %eax,%eax
80106348:	0f 84 e2 00 00 00    	je     80106430 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010634e:	83 ec 04             	sub    $0x4,%esp
80106351:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80106354:	50                   	push   %eax
80106355:	53                   	push   %ebx
80106356:	57                   	push   %edi
80106357:	e8 34 c0 ff ff       	call   80102390 <dirlookup>
8010635c:	83 c4 10             	add    $0x10,%esp
8010635f:	89 c3                	mov    %eax,%ebx
80106361:	85 c0                	test   %eax,%eax
80106363:	0f 84 c7 00 00 00    	je     80106430 <sys_unlink+0x160>
  ilock(ip);
80106369:	83 ec 0c             	sub    $0xc,%esp
8010636c:	50                   	push   %eax
8010636d:	e8 de b9 ff ff       	call   80101d50 <ilock>
  if(ip->nlink < 1)
80106372:	83 c4 10             	add    $0x10,%esp
80106375:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010637a:	0f 8e 1c 01 00 00    	jle    8010649c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106380:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106385:	8d 7d d8             	lea    -0x28(%ebp),%edi
80106388:	74 66                	je     801063f0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010638a:	83 ec 04             	sub    $0x4,%esp
8010638d:	6a 10                	push   $0x10
8010638f:	6a 00                	push   $0x0
80106391:	57                   	push   %edi
80106392:	e8 f9 f4 ff ff       	call   80105890 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106397:	6a 10                	push   $0x10
80106399:	ff 75 c4             	push   -0x3c(%ebp)
8010639c:	57                   	push   %edi
8010639d:	ff 75 b4             	push   -0x4c(%ebp)
801063a0:	e8 bb bd ff ff       	call   80102160 <writei>
801063a5:	83 c4 20             	add    $0x20,%esp
801063a8:	83 f8 10             	cmp    $0x10,%eax
801063ab:	0f 85 de 00 00 00    	jne    8010648f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
801063b1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801063b6:	0f 84 94 00 00 00    	je     80106450 <sys_unlink+0x180>
  iunlockput(dp);
801063bc:	83 ec 0c             	sub    $0xc,%esp
801063bf:	ff 75 b4             	push   -0x4c(%ebp)
801063c2:	e8 19 bc ff ff       	call   80101fe0 <iunlockput>
  ip->nlink--;
801063c7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801063cc:	89 1c 24             	mov    %ebx,(%esp)
801063cf:	e8 cc b8 ff ff       	call   80101ca0 <iupdate>
  iunlockput(ip);
801063d4:	89 1c 24             	mov    %ebx,(%esp)
801063d7:	e8 04 bc ff ff       	call   80101fe0 <iunlockput>
  end_op();
801063dc:	e8 9f d0 ff ff       	call   80103480 <end_op>
  return 0;
801063e1:	83 c4 10             	add    $0x10,%esp
801063e4:	31 c0                	xor    %eax,%eax
}
801063e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063e9:	5b                   	pop    %ebx
801063ea:	5e                   	pop    %esi
801063eb:	5f                   	pop    %edi
801063ec:	5d                   	pop    %ebp
801063ed:	c3                   	ret    
801063ee:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801063f0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801063f4:	76 94                	jbe    8010638a <sys_unlink+0xba>
801063f6:	be 20 00 00 00       	mov    $0x20,%esi
801063fb:	eb 0b                	jmp    80106408 <sys_unlink+0x138>
801063fd:	8d 76 00             	lea    0x0(%esi),%esi
80106400:	83 c6 10             	add    $0x10,%esi
80106403:	3b 73 58             	cmp    0x58(%ebx),%esi
80106406:	73 82                	jae    8010638a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106408:	6a 10                	push   $0x10
8010640a:	56                   	push   %esi
8010640b:	57                   	push   %edi
8010640c:	53                   	push   %ebx
8010640d:	e8 4e bc ff ff       	call   80102060 <readi>
80106412:	83 c4 10             	add    $0x10,%esp
80106415:	83 f8 10             	cmp    $0x10,%eax
80106418:	75 68                	jne    80106482 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010641a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010641f:	74 df                	je     80106400 <sys_unlink+0x130>
    iunlockput(ip);
80106421:	83 ec 0c             	sub    $0xc,%esp
80106424:	53                   	push   %ebx
80106425:	e8 b6 bb ff ff       	call   80101fe0 <iunlockput>
    goto bad;
8010642a:	83 c4 10             	add    $0x10,%esp
8010642d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80106430:	83 ec 0c             	sub    $0xc,%esp
80106433:	ff 75 b4             	push   -0x4c(%ebp)
80106436:	e8 a5 bb ff ff       	call   80101fe0 <iunlockput>
  end_op();
8010643b:	e8 40 d0 ff ff       	call   80103480 <end_op>
  return -1;
80106440:	83 c4 10             	add    $0x10,%esp
80106443:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106448:	eb 9c                	jmp    801063e6 <sys_unlink+0x116>
8010644a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80106450:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80106453:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80106456:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010645b:	50                   	push   %eax
8010645c:	e8 3f b8 ff ff       	call   80101ca0 <iupdate>
80106461:	83 c4 10             	add    $0x10,%esp
80106464:	e9 53 ff ff ff       	jmp    801063bc <sys_unlink+0xec>
    return -1;
80106469:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010646e:	e9 73 ff ff ff       	jmp    801063e6 <sys_unlink+0x116>
    end_op();
80106473:	e8 08 d0 ff ff       	call   80103480 <end_op>
    return -1;
80106478:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010647d:	e9 64 ff ff ff       	jmp    801063e6 <sys_unlink+0x116>
      panic("isdirempty: readi");
80106482:	83 ec 0c             	sub    $0xc,%esp
80106485:	68 ec 92 10 80       	push   $0x801092ec
8010648a:	e8 f1 9e ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010648f:	83 ec 0c             	sub    $0xc,%esp
80106492:	68 fe 92 10 80       	push   $0x801092fe
80106497:	e8 e4 9e ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010649c:	83 ec 0c             	sub    $0xc,%esp
8010649f:	68 da 92 10 80       	push   $0x801092da
801064a4:	e8 d7 9e ff ff       	call   80100380 <panic>
801064a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801064b0 <sys_open>:

int
sys_open(void)
{
801064b0:	55                   	push   %ebp
801064b1:	89 e5                	mov    %esp,%ebp
801064b3:	57                   	push   %edi
801064b4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801064b5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801064b8:	53                   	push   %ebx
801064b9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801064bc:	50                   	push   %eax
801064bd:	6a 00                	push   $0x0
801064bf:	e8 dc f7 ff ff       	call   80105ca0 <argstr>
801064c4:	83 c4 10             	add    $0x10,%esp
801064c7:	85 c0                	test   %eax,%eax
801064c9:	0f 88 8e 00 00 00    	js     8010655d <sys_open+0xad>
801064cf:	83 ec 08             	sub    $0x8,%esp
801064d2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801064d5:	50                   	push   %eax
801064d6:	6a 01                	push   $0x1
801064d8:	e8 b3 f6 ff ff       	call   80105b90 <argint>
801064dd:	83 c4 10             	add    $0x10,%esp
801064e0:	85 c0                	test   %eax,%eax
801064e2:	78 79                	js     8010655d <sys_open+0xad>
    return -1;

  begin_op();
801064e4:	e8 27 cf ff ff       	call   80103410 <begin_op>

  if(omode & O_CREATE){
801064e9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801064ed:	75 79                	jne    80106568 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801064ef:	83 ec 0c             	sub    $0xc,%esp
801064f2:	ff 75 e0             	push   -0x20(%ebp)
801064f5:	e8 56 c2 ff ff       	call   80102750 <namei>
801064fa:	83 c4 10             	add    $0x10,%esp
801064fd:	89 c6                	mov    %eax,%esi
801064ff:	85 c0                	test   %eax,%eax
80106501:	0f 84 7e 00 00 00    	je     80106585 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80106507:	83 ec 0c             	sub    $0xc,%esp
8010650a:	50                   	push   %eax
8010650b:	e8 40 b8 ff ff       	call   80101d50 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106510:	83 c4 10             	add    $0x10,%esp
80106513:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80106518:	0f 84 c2 00 00 00    	je     801065e0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010651e:	e8 5d ae ff ff       	call   80101380 <filealloc>
80106523:	89 c7                	mov    %eax,%edi
80106525:	85 c0                	test   %eax,%eax
80106527:	74 23                	je     8010654c <sys_open+0x9c>
  struct proc *curproc = myproc();
80106529:	e8 62 db ff ff       	call   80104090 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010652e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80106530:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106534:	85 d2                	test   %edx,%edx
80106536:	74 60                	je     80106598 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80106538:	83 c3 01             	add    $0x1,%ebx
8010653b:	83 fb 10             	cmp    $0x10,%ebx
8010653e:	75 f0                	jne    80106530 <sys_open+0x80>
    if(f)
      fileclose(f);
80106540:	83 ec 0c             	sub    $0xc,%esp
80106543:	57                   	push   %edi
80106544:	e8 f7 ae ff ff       	call   80101440 <fileclose>
80106549:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010654c:	83 ec 0c             	sub    $0xc,%esp
8010654f:	56                   	push   %esi
80106550:	e8 8b ba ff ff       	call   80101fe0 <iunlockput>
    end_op();
80106555:	e8 26 cf ff ff       	call   80103480 <end_op>
    return -1;
8010655a:	83 c4 10             	add    $0x10,%esp
8010655d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106562:	eb 6d                	jmp    801065d1 <sys_open+0x121>
80106564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80106568:	83 ec 0c             	sub    $0xc,%esp
8010656b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010656e:	31 c9                	xor    %ecx,%ecx
80106570:	ba 02 00 00 00       	mov    $0x2,%edx
80106575:	6a 00                	push   $0x0
80106577:	e8 14 f8 ff ff       	call   80105d90 <create>
    if(ip == 0){
8010657c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010657f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80106581:	85 c0                	test   %eax,%eax
80106583:	75 99                	jne    8010651e <sys_open+0x6e>
      end_op();
80106585:	e8 f6 ce ff ff       	call   80103480 <end_op>
      return -1;
8010658a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010658f:	eb 40                	jmp    801065d1 <sys_open+0x121>
80106591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80106598:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010659b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010659f:	56                   	push   %esi
801065a0:	e8 8b b8 ff ff       	call   80101e30 <iunlock>
  end_op();
801065a5:	e8 d6 ce ff ff       	call   80103480 <end_op>

  f->type = FD_INODE;
801065aa:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801065b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801065b3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801065b6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801065b9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801065bb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801065c2:	f7 d0                	not    %eax
801065c4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801065c7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801065ca:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801065cd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801065d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065d4:	89 d8                	mov    %ebx,%eax
801065d6:	5b                   	pop    %ebx
801065d7:	5e                   	pop    %esi
801065d8:	5f                   	pop    %edi
801065d9:	5d                   	pop    %ebp
801065da:	c3                   	ret    
801065db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801065df:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801065e0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801065e3:	85 c9                	test   %ecx,%ecx
801065e5:	0f 84 33 ff ff ff    	je     8010651e <sys_open+0x6e>
801065eb:	e9 5c ff ff ff       	jmp    8010654c <sys_open+0x9c>

801065f0 <sys_change_file_size>:

int
sys_change_file_size(void)
{
801065f0:	55                   	push   %ebp
801065f1:	89 e5                	mov    %esp,%ebp
801065f3:	56                   	push   %esi
801065f4:	53                   	push   %ebx
  char *path;
  int n, r;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &n) < 0)
801065f5:	8d 45 f0             	lea    -0x10(%ebp),%eax
{
801065f8:	83 ec 18             	sub    $0x18,%esp
  if(argstr(0, &path) < 0 || argint(1, &n) < 0)
801065fb:	50                   	push   %eax
801065fc:	6a 00                	push   $0x0
801065fe:	e8 9d f6 ff ff       	call   80105ca0 <argstr>
80106603:	83 c4 10             	add    $0x10,%esp
80106606:	85 c0                	test   %eax,%eax
80106608:	0f 88 92 00 00 00    	js     801066a0 <sys_change_file_size+0xb0>
8010660e:	83 ec 08             	sub    $0x8,%esp
80106611:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106614:	50                   	push   %eax
80106615:	6a 01                	push   $0x1
80106617:	e8 74 f5 ff ff       	call   80105b90 <argint>
8010661c:	83 c4 10             	add    $0x10,%esp
8010661f:	85 c0                	test   %eax,%eax
80106621:	78 7d                	js     801066a0 <sys_change_file_size+0xb0>
    return -1;

  // open file
  begin_op();
80106623:	e8 e8 cd ff ff       	call   80103410 <begin_op>

  ip = create(path, T_FILE, 0, 0);
80106628:	83 ec 0c             	sub    $0xc,%esp
8010662b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010662e:	31 c9                	xor    %ecx,%ecx
80106630:	6a 00                	push   $0x0
80106632:	ba 02 00 00 00       	mov    $0x2,%edx
80106637:	e8 54 f7 ff ff       	call   80105d90 <create>
  if(ip == 0){
8010663c:	83 c4 10             	add    $0x10,%esp
  ip = create(path, T_FILE, 0, 0);
8010663f:	89 c6                	mov    %eax,%esi
  if(ip == 0){
80106641:	85 c0                	test   %eax,%eax
80106643:	74 53                	je     80106698 <sys_change_file_size+0xa8>
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0){
80106645:	e8 36 ad ff ff       	call   80101380 <filealloc>
8010664a:	89 c3                	mov    %eax,%ebx
8010664c:	85 c0                	test   %eax,%eax
8010664e:	74 57                	je     801066a7 <sys_change_file_size+0xb7>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106650:	83 ec 0c             	sub    $0xc,%esp
80106653:	56                   	push   %esi
80106654:	e8 d7 b7 ff ff       	call   80101e30 <iunlock>
  end_op();
80106659:	e8 22 ce ff ff       	call   80103480 <end_op>

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = 1;
8010665e:	b8 01 01 00 00       	mov    $0x101,%eax
  f->ip = ip;
80106663:	89 73 10             	mov    %esi,0x10(%ebx)
  f->type = FD_INODE;
80106666:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->off = 0;
8010666c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = 1;
80106673:	66 89 43 08          	mov    %ax,0x8(%ebx)
  f->writable = 1;

  r = filechangesize(f, n);
80106677:	5a                   	pop    %edx
80106678:	59                   	pop    %ecx
80106679:	ff 75 f4             	push   -0xc(%ebp)
8010667c:	53                   	push   %ebx
8010667d:	e8 8e b0 ff ff       	call   80101710 <filechangesize>
  fileclose(f);
80106682:	89 1c 24             	mov    %ebx,(%esp)
  r = filechangesize(f, n);
80106685:	89 c6                	mov    %eax,%esi
  fileclose(f);
80106687:	e8 b4 ad ff ff       	call   80101440 <fileclose>
  return r;
8010668c:	83 c4 10             	add    $0x10,%esp
}
8010668f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106692:	89 f0                	mov    %esi,%eax
80106694:	5b                   	pop    %ebx
80106695:	5e                   	pop    %esi
80106696:	5d                   	pop    %ebp
80106697:	c3                   	ret    
    end_op();
80106698:	e8 e3 cd ff ff       	call   80103480 <end_op>
8010669d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801066a0:	be ff ff ff ff       	mov    $0xffffffff,%esi
801066a5:	eb e8                	jmp    8010668f <sys_change_file_size+0x9f>
    iunlockput(ip);
801066a7:	83 ec 0c             	sub    $0xc,%esp
801066aa:	56                   	push   %esi
    return -1;
801066ab:	be ff ff ff ff       	mov    $0xffffffff,%esi
    iunlockput(ip);
801066b0:	e8 2b b9 ff ff       	call   80101fe0 <iunlockput>
    end_op();
801066b5:	e8 c6 cd ff ff       	call   80103480 <end_op>
    return -1;
801066ba:	83 c4 10             	add    $0x10,%esp
801066bd:	eb d0                	jmp    8010668f <sys_change_file_size+0x9f>
801066bf:	90                   	nop

801066c0 <sys_mkdir>:

int
sys_mkdir(void)
{
801066c0:	55                   	push   %ebp
801066c1:	89 e5                	mov    %esp,%ebp
801066c3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801066c6:	e8 45 cd ff ff       	call   80103410 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801066cb:	83 ec 08             	sub    $0x8,%esp
801066ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
801066d1:	50                   	push   %eax
801066d2:	6a 00                	push   $0x0
801066d4:	e8 c7 f5 ff ff       	call   80105ca0 <argstr>
801066d9:	83 c4 10             	add    $0x10,%esp
801066dc:	85 c0                	test   %eax,%eax
801066de:	78 30                	js     80106710 <sys_mkdir+0x50>
801066e0:	83 ec 0c             	sub    $0xc,%esp
801066e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066e6:	31 c9                	xor    %ecx,%ecx
801066e8:	ba 01 00 00 00       	mov    $0x1,%edx
801066ed:	6a 00                	push   $0x0
801066ef:	e8 9c f6 ff ff       	call   80105d90 <create>
801066f4:	83 c4 10             	add    $0x10,%esp
801066f7:	85 c0                	test   %eax,%eax
801066f9:	74 15                	je     80106710 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801066fb:	83 ec 0c             	sub    $0xc,%esp
801066fe:	50                   	push   %eax
801066ff:	e8 dc b8 ff ff       	call   80101fe0 <iunlockput>
  end_op();
80106704:	e8 77 cd ff ff       	call   80103480 <end_op>
  return 0;
80106709:	83 c4 10             	add    $0x10,%esp
8010670c:	31 c0                	xor    %eax,%eax
}
8010670e:	c9                   	leave  
8010670f:	c3                   	ret    
    end_op();
80106710:	e8 6b cd ff ff       	call   80103480 <end_op>
    return -1;
80106715:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010671a:	c9                   	leave  
8010671b:	c3                   	ret    
8010671c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106720 <sys_mknod>:

int
sys_mknod(void)
{
80106720:	55                   	push   %ebp
80106721:	89 e5                	mov    %esp,%ebp
80106723:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106726:	e8 e5 cc ff ff       	call   80103410 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010672b:	83 ec 08             	sub    $0x8,%esp
8010672e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106731:	50                   	push   %eax
80106732:	6a 00                	push   $0x0
80106734:	e8 67 f5 ff ff       	call   80105ca0 <argstr>
80106739:	83 c4 10             	add    $0x10,%esp
8010673c:	85 c0                	test   %eax,%eax
8010673e:	78 60                	js     801067a0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80106740:	83 ec 08             	sub    $0x8,%esp
80106743:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106746:	50                   	push   %eax
80106747:	6a 01                	push   $0x1
80106749:	e8 42 f4 ff ff       	call   80105b90 <argint>
  if((argstr(0, &path)) < 0 ||
8010674e:	83 c4 10             	add    $0x10,%esp
80106751:	85 c0                	test   %eax,%eax
80106753:	78 4b                	js     801067a0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80106755:	83 ec 08             	sub    $0x8,%esp
80106758:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010675b:	50                   	push   %eax
8010675c:	6a 02                	push   $0x2
8010675e:	e8 2d f4 ff ff       	call   80105b90 <argint>
     argint(1, &major) < 0 ||
80106763:	83 c4 10             	add    $0x10,%esp
80106766:	85 c0                	test   %eax,%eax
80106768:	78 36                	js     801067a0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010676a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010676e:	83 ec 0c             	sub    $0xc,%esp
80106771:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80106775:	ba 03 00 00 00       	mov    $0x3,%edx
8010677a:	50                   	push   %eax
8010677b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010677e:	e8 0d f6 ff ff       	call   80105d90 <create>
     argint(2, &minor) < 0 ||
80106783:	83 c4 10             	add    $0x10,%esp
80106786:	85 c0                	test   %eax,%eax
80106788:	74 16                	je     801067a0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010678a:	83 ec 0c             	sub    $0xc,%esp
8010678d:	50                   	push   %eax
8010678e:	e8 4d b8 ff ff       	call   80101fe0 <iunlockput>
  end_op();
80106793:	e8 e8 cc ff ff       	call   80103480 <end_op>
  return 0;
80106798:	83 c4 10             	add    $0x10,%esp
8010679b:	31 c0                	xor    %eax,%eax
}
8010679d:	c9                   	leave  
8010679e:	c3                   	ret    
8010679f:	90                   	nop
    end_op();
801067a0:	e8 db cc ff ff       	call   80103480 <end_op>
    return -1;
801067a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801067aa:	c9                   	leave  
801067ab:	c3                   	ret    
801067ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801067b0 <sys_chdir>:

int
sys_chdir(void)
{
801067b0:	55                   	push   %ebp
801067b1:	89 e5                	mov    %esp,%ebp
801067b3:	56                   	push   %esi
801067b4:	53                   	push   %ebx
801067b5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801067b8:	e8 d3 d8 ff ff       	call   80104090 <myproc>
801067bd:	89 c6                	mov    %eax,%esi

  begin_op();
801067bf:	e8 4c cc ff ff       	call   80103410 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801067c4:	83 ec 08             	sub    $0x8,%esp
801067c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801067ca:	50                   	push   %eax
801067cb:	6a 00                	push   $0x0
801067cd:	e8 ce f4 ff ff       	call   80105ca0 <argstr>
801067d2:	83 c4 10             	add    $0x10,%esp
801067d5:	85 c0                	test   %eax,%eax
801067d7:	78 77                	js     80106850 <sys_chdir+0xa0>
801067d9:	83 ec 0c             	sub    $0xc,%esp
801067dc:	ff 75 f4             	push   -0xc(%ebp)
801067df:	e8 6c bf ff ff       	call   80102750 <namei>
801067e4:	83 c4 10             	add    $0x10,%esp
801067e7:	89 c3                	mov    %eax,%ebx
801067e9:	85 c0                	test   %eax,%eax
801067eb:	74 63                	je     80106850 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801067ed:	83 ec 0c             	sub    $0xc,%esp
801067f0:	50                   	push   %eax
801067f1:	e8 5a b5 ff ff       	call   80101d50 <ilock>
  if(ip->type != T_DIR){
801067f6:	83 c4 10             	add    $0x10,%esp
801067f9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801067fe:	75 30                	jne    80106830 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106800:	83 ec 0c             	sub    $0xc,%esp
80106803:	53                   	push   %ebx
80106804:	e8 27 b6 ff ff       	call   80101e30 <iunlock>
  iput(curproc->cwd);
80106809:	58                   	pop    %eax
8010680a:	ff 76 68             	push   0x68(%esi)
8010680d:	e8 6e b6 ff ff       	call   80101e80 <iput>
  end_op();
80106812:	e8 69 cc ff ff       	call   80103480 <end_op>
  curproc->cwd = ip;
80106817:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010681a:	83 c4 10             	add    $0x10,%esp
8010681d:	31 c0                	xor    %eax,%eax
}
8010681f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106822:	5b                   	pop    %ebx
80106823:	5e                   	pop    %esi
80106824:	5d                   	pop    %ebp
80106825:	c3                   	ret    
80106826:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010682d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80106830:	83 ec 0c             	sub    $0xc,%esp
80106833:	53                   	push   %ebx
80106834:	e8 a7 b7 ff ff       	call   80101fe0 <iunlockput>
    end_op();
80106839:	e8 42 cc ff ff       	call   80103480 <end_op>
    return -1;
8010683e:	83 c4 10             	add    $0x10,%esp
80106841:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106846:	eb d7                	jmp    8010681f <sys_chdir+0x6f>
80106848:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010684f:	90                   	nop
    end_op();
80106850:	e8 2b cc ff ff       	call   80103480 <end_op>
    return -1;
80106855:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010685a:	eb c3                	jmp    8010681f <sys_chdir+0x6f>
8010685c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106860 <sys_exec>:

int
sys_exec(void)
{
80106860:	55                   	push   %ebp
80106861:	89 e5                	mov    %esp,%ebp
80106863:	57                   	push   %edi
80106864:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106865:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010686b:	53                   	push   %ebx
8010686c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106872:	50                   	push   %eax
80106873:	6a 00                	push   $0x0
80106875:	e8 26 f4 ff ff       	call   80105ca0 <argstr>
8010687a:	83 c4 10             	add    $0x10,%esp
8010687d:	85 c0                	test   %eax,%eax
8010687f:	0f 88 87 00 00 00    	js     8010690c <sys_exec+0xac>
80106885:	83 ec 08             	sub    $0x8,%esp
80106888:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010688e:	50                   	push   %eax
8010688f:	6a 01                	push   $0x1
80106891:	e8 fa f2 ff ff       	call   80105b90 <argint>
80106896:	83 c4 10             	add    $0x10,%esp
80106899:	85 c0                	test   %eax,%eax
8010689b:	78 6f                	js     8010690c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010689d:	83 ec 04             	sub    $0x4,%esp
801068a0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
801068a6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801068a8:	68 80 00 00 00       	push   $0x80
801068ad:	6a 00                	push   $0x0
801068af:	56                   	push   %esi
801068b0:	e8 db ef ff ff       	call   80105890 <memset>
801068b5:	83 c4 10             	add    $0x10,%esp
801068b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068bf:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801068c0:	83 ec 08             	sub    $0x8,%esp
801068c3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801068c9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801068d0:	50                   	push   %eax
801068d1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801068d7:	01 f8                	add    %edi,%eax
801068d9:	50                   	push   %eax
801068da:	e8 e1 f1 ff ff       	call   80105ac0 <fetchint>
801068df:	83 c4 10             	add    $0x10,%esp
801068e2:	85 c0                	test   %eax,%eax
801068e4:	78 26                	js     8010690c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801068e6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801068ec:	85 c0                	test   %eax,%eax
801068ee:	74 30                	je     80106920 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801068f0:	83 ec 08             	sub    $0x8,%esp
801068f3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801068f6:	52                   	push   %edx
801068f7:	50                   	push   %eax
801068f8:	e8 43 f2 ff ff       	call   80105b40 <fetchstr>
801068fd:	83 c4 10             	add    $0x10,%esp
80106900:	85 c0                	test   %eax,%eax
80106902:	78 08                	js     8010690c <sys_exec+0xac>
  for(i=0;; i++){
80106904:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80106907:	83 fb 20             	cmp    $0x20,%ebx
8010690a:	75 b4                	jne    801068c0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010690c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010690f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106914:	5b                   	pop    %ebx
80106915:	5e                   	pop    %esi
80106916:	5f                   	pop    %edi
80106917:	5d                   	pop    %ebp
80106918:	c3                   	ret    
80106919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80106920:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106927:	00 00 00 00 
  return exec(path, argv);
8010692b:	83 ec 08             	sub    $0x8,%esp
8010692e:	56                   	push   %esi
8010692f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80106935:	e8 c6 a6 ff ff       	call   80101000 <exec>
8010693a:	83 c4 10             	add    $0x10,%esp
}
8010693d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106940:	5b                   	pop    %ebx
80106941:	5e                   	pop    %esi
80106942:	5f                   	pop    %edi
80106943:	5d                   	pop    %ebp
80106944:	c3                   	ret    
80106945:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010694c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106950 <sys_pipe>:

int
sys_pipe(void)
{
80106950:	55                   	push   %ebp
80106951:	89 e5                	mov    %esp,%ebp
80106953:	57                   	push   %edi
80106954:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106955:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106958:	53                   	push   %ebx
80106959:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010695c:	6a 08                	push   $0x8
8010695e:	50                   	push   %eax
8010695f:	6a 00                	push   $0x0
80106961:	e8 ca f2 ff ff       	call   80105c30 <argptr>
80106966:	83 c4 10             	add    $0x10,%esp
80106969:	85 c0                	test   %eax,%eax
8010696b:	78 4a                	js     801069b7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010696d:	83 ec 08             	sub    $0x8,%esp
80106970:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106973:	50                   	push   %eax
80106974:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106977:	50                   	push   %eax
80106978:	e8 63 d1 ff ff       	call   80103ae0 <pipealloc>
8010697d:	83 c4 10             	add    $0x10,%esp
80106980:	85 c0                	test   %eax,%eax
80106982:	78 33                	js     801069b7 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106984:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80106987:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80106989:	e8 02 d7 ff ff       	call   80104090 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010698e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80106990:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80106994:	85 f6                	test   %esi,%esi
80106996:	74 28                	je     801069c0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80106998:	83 c3 01             	add    $0x1,%ebx
8010699b:	83 fb 10             	cmp    $0x10,%ebx
8010699e:	75 f0                	jne    80106990 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801069a0:	83 ec 0c             	sub    $0xc,%esp
801069a3:	ff 75 e0             	push   -0x20(%ebp)
801069a6:	e8 95 aa ff ff       	call   80101440 <fileclose>
    fileclose(wf);
801069ab:	58                   	pop    %eax
801069ac:	ff 75 e4             	push   -0x1c(%ebp)
801069af:	e8 8c aa ff ff       	call   80101440 <fileclose>
    return -1;
801069b4:	83 c4 10             	add    $0x10,%esp
801069b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069bc:	eb 53                	jmp    80106a11 <sys_pipe+0xc1>
801069be:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801069c0:	8d 73 08             	lea    0x8(%ebx),%esi
801069c3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801069c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801069ca:	e8 c1 d6 ff ff       	call   80104090 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801069cf:	31 d2                	xor    %edx,%edx
801069d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801069d8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801069dc:	85 c9                	test   %ecx,%ecx
801069de:	74 20                	je     80106a00 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
801069e0:	83 c2 01             	add    $0x1,%edx
801069e3:	83 fa 10             	cmp    $0x10,%edx
801069e6:	75 f0                	jne    801069d8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
801069e8:	e8 a3 d6 ff ff       	call   80104090 <myproc>
801069ed:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801069f4:	00 
801069f5:	eb a9                	jmp    801069a0 <sys_pipe+0x50>
801069f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069fe:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106a00:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80106a04:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106a07:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106a09:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106a0c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80106a0f:	31 c0                	xor    %eax,%eax
}
80106a11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a14:	5b                   	pop    %ebx
80106a15:	5e                   	pop    %esi
80106a16:	5f                   	pop    %edi
80106a17:	5d                   	pop    %ebp
80106a18:	c3                   	ret    
80106a19:	66 90                	xchg   %ax,%ax
80106a1b:	66 90                	xchg   %ax,%ax
80106a1d:	66 90                	xchg   %ax,%ax
80106a1f:	90                   	nop

80106a20 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80106a20:	e9 6b d8 ff ff       	jmp    80104290 <fork>
80106a25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106a30 <sys_exit>:
}

int
sys_exit(void)
{
80106a30:	55                   	push   %ebp
80106a31:	89 e5                	mov    %esp,%ebp
80106a33:	83 ec 08             	sub    $0x8,%esp
  exit();
80106a36:	e8 55 de ff ff       	call   80104890 <exit>
  return 0;  // not reached
}
80106a3b:	31 c0                	xor    %eax,%eax
80106a3d:	c9                   	leave  
80106a3e:	c3                   	ret    
80106a3f:	90                   	nop

80106a40 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80106a40:	e9 2b df ff ff       	jmp    80104970 <wait>
80106a45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106a50 <sys_kill>:
}

int
sys_kill(void)
{
80106a50:	55                   	push   %ebp
80106a51:	89 e5                	mov    %esp,%ebp
80106a53:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106a56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a59:	50                   	push   %eax
80106a5a:	6a 00                	push   $0x0
80106a5c:	e8 2f f1 ff ff       	call   80105b90 <argint>
80106a61:	83 c4 10             	add    $0x10,%esp
80106a64:	85 c0                	test   %eax,%eax
80106a66:	78 18                	js     80106a80 <sys_kill+0x30>
    return -1;
  return kill(pid);
80106a68:	83 ec 0c             	sub    $0xc,%esp
80106a6b:	ff 75 f4             	push   -0xc(%ebp)
80106a6e:	e8 dd e1 ff ff       	call   80104c50 <kill>
80106a73:	83 c4 10             	add    $0x10,%esp
}
80106a76:	c9                   	leave  
80106a77:	c3                   	ret    
80106a78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a7f:	90                   	nop
80106a80:	c9                   	leave  
    return -1;
80106a81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106a86:	c3                   	ret    
80106a87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a8e:	66 90                	xchg   %ax,%ax

80106a90 <sys_getpid>:

int
sys_getpid(void)
{
80106a90:	55                   	push   %ebp
80106a91:	89 e5                	mov    %esp,%ebp
80106a93:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106a96:	e8 f5 d5 ff ff       	call   80104090 <myproc>
80106a9b:	8b 40 10             	mov    0x10(%eax),%eax
}
80106a9e:	c9                   	leave  
80106a9f:	c3                   	ret    

80106aa0 <sys_sbrk>:

int
sys_sbrk(void)
{
80106aa0:	55                   	push   %ebp
80106aa1:	89 e5                	mov    %esp,%ebp
80106aa3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106aa4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106aa7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80106aaa:	50                   	push   %eax
80106aab:	6a 00                	push   $0x0
80106aad:	e8 de f0 ff ff       	call   80105b90 <argint>
80106ab2:	83 c4 10             	add    $0x10,%esp
80106ab5:	85 c0                	test   %eax,%eax
80106ab7:	78 27                	js     80106ae0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106ab9:	e8 d2 d5 ff ff       	call   80104090 <myproc>
  if(growproc(n) < 0)
80106abe:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106ac1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106ac3:	ff 75 f4             	push   -0xc(%ebp)
80106ac6:	e8 45 d7 ff ff       	call   80104210 <growproc>
80106acb:	83 c4 10             	add    $0x10,%esp
80106ace:	85 c0                	test   %eax,%eax
80106ad0:	78 0e                	js     80106ae0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106ad2:	89 d8                	mov    %ebx,%eax
80106ad4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106ad7:	c9                   	leave  
80106ad8:	c3                   	ret    
80106ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106ae0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106ae5:	eb eb                	jmp    80106ad2 <sys_sbrk+0x32>
80106ae7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106aee:	66 90                	xchg   %ax,%ax

80106af0 <sys_sleep>:

int
sys_sleep(void)
{
80106af0:	55                   	push   %ebp
80106af1:	89 e5                	mov    %esp,%ebp
80106af3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106af4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106af7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80106afa:	50                   	push   %eax
80106afb:	6a 00                	push   $0x0
80106afd:	e8 8e f0 ff ff       	call   80105b90 <argint>
80106b02:	83 c4 10             	add    $0x10,%esp
80106b05:	85 c0                	test   %eax,%eax
80106b07:	0f 88 8a 00 00 00    	js     80106b97 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80106b0d:	83 ec 0c             	sub    $0xc,%esp
80106b10:	68 00 72 13 80       	push   $0x80137200
80106b15:	e8 b6 ec ff ff       	call   801057d0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106b1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80106b1d:	8b 1d e0 71 13 80    	mov    0x801371e0,%ebx
  while(ticks - ticks0 < n){
80106b23:	83 c4 10             	add    $0x10,%esp
80106b26:	85 d2                	test   %edx,%edx
80106b28:	75 27                	jne    80106b51 <sys_sleep+0x61>
80106b2a:	eb 54                	jmp    80106b80 <sys_sleep+0x90>
80106b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106b30:	83 ec 08             	sub    $0x8,%esp
80106b33:	68 00 72 13 80       	push   $0x80137200
80106b38:	68 e0 71 13 80       	push   $0x801371e0
80106b3d:	e8 be df ff ff       	call   80104b00 <sleep>
  while(ticks - ticks0 < n){
80106b42:	a1 e0 71 13 80       	mov    0x801371e0,%eax
80106b47:	83 c4 10             	add    $0x10,%esp
80106b4a:	29 d8                	sub    %ebx,%eax
80106b4c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80106b4f:	73 2f                	jae    80106b80 <sys_sleep+0x90>
    if(myproc()->killed){
80106b51:	e8 3a d5 ff ff       	call   80104090 <myproc>
80106b56:	8b 40 24             	mov    0x24(%eax),%eax
80106b59:	85 c0                	test   %eax,%eax
80106b5b:	74 d3                	je     80106b30 <sys_sleep+0x40>
      release(&tickslock);
80106b5d:	83 ec 0c             	sub    $0xc,%esp
80106b60:	68 00 72 13 80       	push   $0x80137200
80106b65:	e8 06 ec ff ff       	call   80105770 <release>
  }
  release(&tickslock);
  return 0;
}
80106b6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80106b6d:	83 c4 10             	add    $0x10,%esp
80106b70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b75:	c9                   	leave  
80106b76:	c3                   	ret    
80106b77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b7e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106b80:	83 ec 0c             	sub    $0xc,%esp
80106b83:	68 00 72 13 80       	push   $0x80137200
80106b88:	e8 e3 eb ff ff       	call   80105770 <release>
  return 0;
80106b8d:	83 c4 10             	add    $0x10,%esp
80106b90:	31 c0                	xor    %eax,%eax
}
80106b92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106b95:	c9                   	leave  
80106b96:	c3                   	ret    
    return -1;
80106b97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b9c:	eb f4                	jmp    80106b92 <sys_sleep+0xa2>
80106b9e:	66 90                	xchg   %ax,%ax

80106ba0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106ba0:	55                   	push   %ebp
80106ba1:	89 e5                	mov    %esp,%ebp
80106ba3:	53                   	push   %ebx
80106ba4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106ba7:	68 00 72 13 80       	push   $0x80137200
80106bac:	e8 1f ec ff ff       	call   801057d0 <acquire>
  xticks = ticks;
80106bb1:	8b 1d e0 71 13 80    	mov    0x801371e0,%ebx
  release(&tickslock);
80106bb7:	c7 04 24 00 72 13 80 	movl   $0x80137200,(%esp)
80106bbe:	e8 ad eb ff ff       	call   80105770 <release>
  return xticks;
}
80106bc3:	89 d8                	mov    %ebx,%eax
80106bc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106bc8:	c9                   	leave  
80106bc9:	c3                   	ret    
80106bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106bd0 <sys_get_callers>:

int
sys_get_callers(void) {
80106bd0:	55                   	push   %ebp
80106bd1:	89 e5                	mov    %esp,%ebp
80106bd3:	83 ec 20             	sub    $0x20,%esp
  int sys_call_number;
  if(argint(0, &sys_call_number) < 0)
80106bd6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106bd9:	50                   	push   %eax
80106bda:	6a 00                	push   $0x0
80106bdc:	e8 af ef ff ff       	call   80105b90 <argint>
80106be1:	83 c4 10             	add    $0x10,%esp
80106be4:	85 c0                	test   %eax,%eax
80106be6:	78 18                	js     80106c00 <sys_get_callers+0x30>
    return -1;

  get_callers(sys_call_number);
80106be8:	83 ec 0c             	sub    $0xc,%esp
80106beb:	ff 75 f4             	push   -0xc(%ebp)
80106bee:	e8 ed e1 ff ff       	call   80104de0 <get_callers>
  return 0;
80106bf3:	83 c4 10             	add    $0x10,%esp
80106bf6:	31 c0                	xor    %eax,%eax
}
80106bf8:	c9                   	leave  
80106bf9:	c3                   	ret    
80106bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c00:	c9                   	leave  
    return -1;
80106c01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c06:	c3                   	ret    
80106c07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c0e:	66 90                	xchg   %ax,%ax

80106c10 <sys_get_parent_pid>:

int
sys_get_parent_pid(void)
{
80106c10:	55                   	push   %ebp
80106c11:	89 e5                	mov    %esp,%ebp
80106c13:	83 ec 08             	sub    $0x8,%esp
  return myproc()->parent->pid;
80106c16:	e8 75 d4 ff ff       	call   80104090 <myproc>
80106c1b:	8b 40 14             	mov    0x14(%eax),%eax
80106c1e:	8b 40 10             	mov    0x10(%eax),%eax
}
80106c21:	c9                   	leave  
80106c22:	c3                   	ret    
80106c23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c30 <sys_change_scheduling_queue>:

int
sys_change_scheduling_queue(void)
{
80106c30:	55                   	push   %ebp
80106c31:	89 e5                	mov    %esp,%ebp
80106c33:	83 ec 20             	sub    $0x20,%esp
  int queue_number, pid;
  if(argint(0, &pid) < 0 || argint(1, &queue_number) < 0)
80106c36:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c39:	50                   	push   %eax
80106c3a:	6a 00                	push   $0x0
80106c3c:	e8 4f ef ff ff       	call   80105b90 <argint>
80106c41:	83 c4 10             	add    $0x10,%esp
80106c44:	85 c0                	test   %eax,%eax
80106c46:	78 38                	js     80106c80 <sys_change_scheduling_queue+0x50>
80106c48:	83 ec 08             	sub    $0x8,%esp
80106c4b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106c4e:	50                   	push   %eax
80106c4f:	6a 01                	push   $0x1
80106c51:	e8 3a ef ff ff       	call   80105b90 <argint>
80106c56:	83 c4 10             	add    $0x10,%esp
80106c59:	85 c0                	test   %eax,%eax
80106c5b:	78 23                	js     80106c80 <sys_change_scheduling_queue+0x50>
    return -1;

  if(queue_number < ROUND_ROBIN || queue_number > BJF)
80106c5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106c60:	8d 50 ff             	lea    -0x1(%eax),%edx
80106c63:	83 fa 02             	cmp    $0x2,%edx
80106c66:	77 18                	ja     80106c80 <sys_change_scheduling_queue+0x50>
    return -1;

  return change_queue(pid, queue_number);
80106c68:	83 ec 08             	sub    $0x8,%esp
80106c6b:	50                   	push   %eax
80106c6c:	ff 75 f4             	push   -0xc(%ebp)
80106c6f:	e8 4c e2 ff ff       	call   80104ec0 <change_queue>
80106c74:	83 c4 10             	add    $0x10,%esp
}
80106c77:	c9                   	leave  
80106c78:	c3                   	ret    
80106c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c80:	c9                   	leave  
    return -1;
80106c81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c86:	c3                   	ret    
80106c87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c8e:	66 90                	xchg   %ax,%ax

80106c90 <sys_set_bjf_params_process>:


int
sys_set_bjf_params_process(void)
{
80106c90:	55                   	push   %ebp
80106c91:	89 e5                	mov    %esp,%ebp
80106c93:	83 ec 20             	sub    $0x20,%esp
  int pid;
  float priority_ratio, arrival_time_ratio, executed_cycle_ratio;
  if(argint(0, &pid) < 0 ||
80106c96:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106c99:	50                   	push   %eax
80106c9a:	6a 00                	push   $0x0
80106c9c:	e8 ef ee ff ff       	call   80105b90 <argint>
80106ca1:	83 c4 10             	add    $0x10,%esp
80106ca4:	85 c0                	test   %eax,%eax
80106ca6:	78 58                	js     80106d00 <sys_set_bjf_params_process+0x70>
     argfloat(1, &priority_ratio) < 0 ||
80106ca8:	83 ec 08             	sub    $0x8,%esp
80106cab:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106cae:	50                   	push   %eax
80106caf:	6a 01                	push   $0x1
80106cb1:	e8 2a ef ff ff       	call   80105be0 <argfloat>
  if(argint(0, &pid) < 0 ||
80106cb6:	83 c4 10             	add    $0x10,%esp
80106cb9:	85 c0                	test   %eax,%eax
80106cbb:	78 43                	js     80106d00 <sys_set_bjf_params_process+0x70>
     argfloat(2, &arrival_time_ratio) < 0 ||
80106cbd:	83 ec 08             	sub    $0x8,%esp
80106cc0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106cc3:	50                   	push   %eax
80106cc4:	6a 02                	push   $0x2
80106cc6:	e8 15 ef ff ff       	call   80105be0 <argfloat>
     argfloat(1, &priority_ratio) < 0 ||
80106ccb:	83 c4 10             	add    $0x10,%esp
80106cce:	85 c0                	test   %eax,%eax
80106cd0:	78 2e                	js     80106d00 <sys_set_bjf_params_process+0x70>
     argfloat(3, &executed_cycle_ratio) < 0){
80106cd2:	83 ec 08             	sub    $0x8,%esp
80106cd5:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106cd8:	50                   	push   %eax
80106cd9:	6a 03                	push   $0x3
80106cdb:	e8 00 ef ff ff       	call   80105be0 <argfloat>
     argfloat(2, &arrival_time_ratio) < 0 ||
80106ce0:	83 c4 10             	add    $0x10,%esp
80106ce3:	85 c0                	test   %eax,%eax
80106ce5:	78 19                	js     80106d00 <sys_set_bjf_params_process+0x70>
    return -1;
  }

  return set_bjf_params_process(pid, priority_ratio, arrival_time_ratio, executed_cycle_ratio);
80106ce7:	ff 75 f4             	push   -0xc(%ebp)
80106cea:	ff 75 f0             	push   -0x10(%ebp)
80106ced:	ff 75 ec             	push   -0x14(%ebp)
80106cf0:	ff 75 e8             	push   -0x18(%ebp)
80106cf3:	e8 48 e2 ff ff       	call   80104f40 <set_bjf_params_process>
80106cf8:	83 c4 10             	add    $0x10,%esp
}
80106cfb:	c9                   	leave  
80106cfc:	c3                   	ret    
80106cfd:	8d 76 00             	lea    0x0(%esi),%esi
80106d00:	c9                   	leave  
    return -1;
80106d01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d06:	c3                   	ret    
80106d07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d0e:	66 90                	xchg   %ax,%ax

80106d10 <sys_set_bjf_params_system>:

int
sys_set_bjf_params_system(void)
{
80106d10:	55                   	push   %ebp
80106d11:	89 e5                	mov    %esp,%ebp
80106d13:	83 ec 20             	sub    $0x20,%esp
  int pid;
  float priority_ratio, arrival_time_ratio, executed_cycle_ratio;
  if(argint(0, &pid) < 0 ||
80106d16:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106d19:	50                   	push   %eax
80106d1a:	6a 00                	push   $0x0
80106d1c:	e8 6f ee ff ff       	call   80105b90 <argint>
80106d21:	83 c4 10             	add    $0x10,%esp
80106d24:	85 c0                	test   %eax,%eax
80106d26:	78 58                	js     80106d80 <sys_set_bjf_params_system+0x70>
     argfloat(1, &priority_ratio) < 0 ||
80106d28:	83 ec 08             	sub    $0x8,%esp
80106d2b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106d2e:	50                   	push   %eax
80106d2f:	6a 01                	push   $0x1
80106d31:	e8 aa ee ff ff       	call   80105be0 <argfloat>
  if(argint(0, &pid) < 0 ||
80106d36:	83 c4 10             	add    $0x10,%esp
80106d39:	85 c0                	test   %eax,%eax
80106d3b:	78 43                	js     80106d80 <sys_set_bjf_params_system+0x70>
     argfloat(2, &arrival_time_ratio) < 0 ||
80106d3d:	83 ec 08             	sub    $0x8,%esp
80106d40:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106d43:	50                   	push   %eax
80106d44:	6a 02                	push   $0x2
80106d46:	e8 95 ee ff ff       	call   80105be0 <argfloat>
     argfloat(1, &priority_ratio) < 0 ||
80106d4b:	83 c4 10             	add    $0x10,%esp
80106d4e:	85 c0                	test   %eax,%eax
80106d50:	78 2e                	js     80106d80 <sys_set_bjf_params_system+0x70>
     argfloat(3, &executed_cycle_ratio) < 0){
80106d52:	83 ec 08             	sub    $0x8,%esp
80106d55:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106d58:	50                   	push   %eax
80106d59:	6a 03                	push   $0x3
80106d5b:	e8 80 ee ff ff       	call   80105be0 <argfloat>
     argfloat(2, &arrival_time_ratio) < 0 ||
80106d60:	83 c4 10             	add    $0x10,%esp
80106d63:	85 c0                	test   %eax,%eax
80106d65:	78 19                	js     80106d80 <sys_set_bjf_params_system+0x70>
    return -1;
  }

  set_bjf_params_system(priority_ratio, arrival_time_ratio, executed_cycle_ratio);
80106d67:	83 ec 04             	sub    $0x4,%esp
80106d6a:	ff 75 f4             	push   -0xc(%ebp)
80106d6d:	ff 75 f0             	push   -0x10(%ebp)
80106d70:	ff 75 ec             	push   -0x14(%ebp)
80106d73:	e8 58 e2 ff ff       	call   80104fd0 <set_bjf_params_system>
  return 0;
80106d78:	83 c4 10             	add    $0x10,%esp
80106d7b:	31 c0                	xor    %eax,%eax
}
80106d7d:	c9                   	leave  
80106d7e:	c3                   	ret    
80106d7f:	90                   	nop
80106d80:	c9                   	leave  
    return -1;
80106d81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d86:	c3                   	ret    
80106d87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d8e:	66 90                	xchg   %ax,%ax

80106d90 <sys_set_bjf_priority>:

int
sys_set_bjf_priority(void)
{
80106d90:	55                   	push   %ebp
80106d91:	89 e5                	mov    %esp,%ebp
80106d93:	83 ec 20             	sub    $0x20,%esp
  int pid, priority;
  if(argint(0, &pid) < 0 || argint(1, &priority) < 0)
80106d96:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106d99:	50                   	push   %eax
80106d9a:	6a 00                	push   $0x0
80106d9c:	e8 ef ed ff ff       	call   80105b90 <argint>
80106da1:	83 c4 10             	add    $0x10,%esp
80106da4:	85 c0                	test   %eax,%eax
80106da6:	78 38                	js     80106de0 <sys_set_bjf_priority+0x50>
80106da8:	83 ec 08             	sub    $0x8,%esp
80106dab:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106dae:	50                   	push   %eax
80106daf:	6a 01                	push   $0x1
80106db1:	e8 da ed ff ff       	call   80105b90 <argint>
80106db6:	83 c4 10             	add    $0x10,%esp
80106db9:	85 c0                	test   %eax,%eax
80106dbb:	78 23                	js     80106de0 <sys_set_bjf_priority+0x50>
    return -1;

  if(priority < BJF_PRIORITY_MIN || priority > BJF_PRIORITY_MAX)
80106dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106dc0:	8d 50 ff             	lea    -0x1(%eax),%edx
80106dc3:	83 fa 13             	cmp    $0x13,%edx
80106dc6:	77 18                	ja     80106de0 <sys_set_bjf_priority+0x50>
    return -1;

  return set_bjf_priority(pid, priority);
80106dc8:	83 ec 08             	sub    $0x8,%esp
80106dcb:	50                   	push   %eax
80106dcc:	ff 75 f0             	push   -0x10(%ebp)
80106dcf:	e8 7c e2 ff ff       	call   80105050 <set_bjf_priority>
80106dd4:	83 c4 10             	add    $0x10,%esp
}
80106dd7:	c9                   	leave  
80106dd8:	c3                   	ret    
80106dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106de0:	c9                   	leave  
    return -1;
80106de1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106de6:	c3                   	ret    
80106de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dee:	66 90                	xchg   %ax,%ax

80106df0 <sys_print_process_info>:

int
sys_print_process_info(void)
{
80106df0:	55                   	push   %ebp
80106df1:	89 e5                	mov    %esp,%ebp
80106df3:	83 ec 08             	sub    $0x8,%esp
  print_process_info();
80106df6:	e8 35 e4 ff ff       	call   80105230 <print_process_info>
  return 0;
}
80106dfb:	31 c0                	xor    %eax,%eax
80106dfd:	c9                   	leave  
80106dfe:	c3                   	ret    
80106dff:	90                   	nop

80106e00 <sys_sem_init>:

int
sys_sem_init(void)
{
80106e00:	55                   	push   %ebp
80106e01:	89 e5                	mov    %esp,%ebp
80106e03:	83 ec 20             	sub    $0x20,%esp
  int sem_id, value;
  if(argint(0, &sem_id) < 0 || argint(1, &value) < 0)
80106e06:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106e09:	50                   	push   %eax
80106e0a:	6a 00                	push   $0x0
80106e0c:	e8 7f ed ff ff       	call   80105b90 <argint>
80106e11:	83 c4 10             	add    $0x10,%esp
80106e14:	85 c0                	test   %eax,%eax
80106e16:	78 38                	js     80106e50 <sys_sem_init+0x50>
80106e18:	83 ec 08             	sub    $0x8,%esp
80106e1b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106e1e:	50                   	push   %eax
80106e1f:	6a 01                	push   $0x1
80106e21:	e8 6a ed ff ff       	call   80105b90 <argint>
80106e26:	83 c4 10             	add    $0x10,%esp
80106e29:	85 c0                	test   %eax,%eax
80106e2b:	78 23                	js     80106e50 <sys_sem_init+0x50>
    return -1;

  if(sem_id < 0 || sem_id >= NSEMS)
80106e2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106e30:	83 f8 05             	cmp    $0x5,%eax
80106e33:	77 1b                	ja     80106e50 <sys_sem_init+0x50>
    return -1;

  sem_init(sem_id, value);
80106e35:	83 ec 08             	sub    $0x8,%esp
80106e38:	ff 75 f4             	push   -0xc(%ebp)
80106e3b:	50                   	push   %eax
80106e3c:	e8 6f e3 ff ff       	call   801051b0 <sem_init>
  return 0;
80106e41:	83 c4 10             	add    $0x10,%esp
80106e44:	31 c0                	xor    %eax,%eax
}
80106e46:	c9                   	leave  
80106e47:	c3                   	ret    
80106e48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e4f:	90                   	nop
80106e50:	c9                   	leave  
    return -1;
80106e51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e56:	c3                   	ret    
80106e57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e5e:	66 90                	xchg   %ax,%ax

80106e60 <sys_sem_acquire>:

int
sys_sem_acquire(void)
{
80106e60:	55                   	push   %ebp
80106e61:	89 e5                	mov    %esp,%ebp
80106e63:	83 ec 20             	sub    $0x20,%esp
  int sem_id, prio;
  if(argint(0, &sem_id) < 0 || argint(1, &prio) < 0)
80106e66:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106e69:	50                   	push   %eax
80106e6a:	6a 00                	push   $0x0
80106e6c:	e8 1f ed ff ff       	call   80105b90 <argint>
80106e71:	83 c4 10             	add    $0x10,%esp
80106e74:	85 c0                	test   %eax,%eax
80106e76:	78 38                	js     80106eb0 <sys_sem_acquire+0x50>
80106e78:	83 ec 08             	sub    $0x8,%esp
80106e7b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106e7e:	50                   	push   %eax
80106e7f:	6a 01                	push   $0x1
80106e81:	e8 0a ed ff ff       	call   80105b90 <argint>
80106e86:	83 c4 10             	add    $0x10,%esp
80106e89:	85 c0                	test   %eax,%eax
80106e8b:	78 23                	js     80106eb0 <sys_sem_acquire+0x50>
    return -1;

  if(sem_id < 0 || sem_id >= NSEMS)
80106e8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106e90:	83 f8 05             	cmp    $0x5,%eax
80106e93:	77 1b                	ja     80106eb0 <sys_sem_acquire+0x50>
    return -1;

  sem_acquire(sem_id, prio);
80106e95:	83 ec 08             	sub    $0x8,%esp
80106e98:	ff 75 f4             	push   -0xc(%ebp)
80106e9b:	50                   	push   %eax
80106e9c:	e8 ff e5 ff ff       	call   801054a0 <sem_acquire>
  return 0;
80106ea1:	83 c4 10             	add    $0x10,%esp
80106ea4:	31 c0                	xor    %eax,%eax
}
80106ea6:	c9                   	leave  
80106ea7:	c3                   	ret    
80106ea8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106eaf:	90                   	nop
80106eb0:	c9                   	leave  
    return -1;
80106eb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106eb6:	c3                   	ret    
80106eb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ebe:	66 90                	xchg   %ax,%ax

80106ec0 <sys_sem_release>:

int
sys_sem_release(void)
{
80106ec0:	55                   	push   %ebp
80106ec1:	89 e5                	mov    %esp,%ebp
80106ec3:	83 ec 20             	sub    $0x20,%esp
  int sem_id;
  if(argint(0, &sem_id) < 0)
80106ec6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106ec9:	50                   	push   %eax
80106eca:	6a 00                	push   $0x0
80106ecc:	e8 bf ec ff ff       	call   80105b90 <argint>
80106ed1:	83 c4 10             	add    $0x10,%esp
80106ed4:	85 c0                	test   %eax,%eax
80106ed6:	78 18                	js     80106ef0 <sys_sem_release+0x30>
    return -1;

  if(sem_id < 0 || sem_id >= NSEMS)
80106ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106edb:	83 f8 05             	cmp    $0x5,%eax
80106ede:	77 10                	ja     80106ef0 <sys_sem_release+0x30>
    return -1;

  sem_release(sem_id);
80106ee0:	83 ec 0c             	sub    $0xc,%esp
80106ee3:	50                   	push   %eax
80106ee4:	e8 27 e3 ff ff       	call   80105210 <sem_release>
  return 0;
80106ee9:	83 c4 10             	add    $0x10,%esp
80106eec:	31 c0                	xor    %eax,%eax
}
80106eee:	c9                   	leave  
80106eef:	c3                   	ret    
80106ef0:	c9                   	leave  
    return -1;
80106ef1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ef6:	c3                   	ret    

80106ef7 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106ef7:	1e                   	push   %ds
  pushl %es
80106ef8:	06                   	push   %es
  pushl %fs
80106ef9:	0f a0                	push   %fs
  pushl %gs
80106efb:	0f a8                	push   %gs
  pushal
80106efd:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106efe:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106f02:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106f04:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106f06:	54                   	push   %esp
  call trap
80106f07:	e8 c4 00 00 00       	call   80106fd0 <trap>
  addl $4, %esp
80106f0c:	83 c4 04             	add    $0x4,%esp

80106f0f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106f0f:	61                   	popa   
  popl %gs
80106f10:	0f a9                	pop    %gs
  popl %fs
80106f12:	0f a1                	pop    %fs
  popl %es
80106f14:	07                   	pop    %es
  popl %ds
80106f15:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106f16:	83 c4 08             	add    $0x8,%esp
  iret
80106f19:	cf                   	iret   
80106f1a:	66 90                	xchg   %ax,%ax
80106f1c:	66 90                	xchg   %ax,%ax
80106f1e:	66 90                	xchg   %ax,%ax

80106f20 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106f20:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106f21:	31 c0                	xor    %eax,%eax
{
80106f23:	89 e5                	mov    %esp,%ebp
80106f25:	83 ec 08             	sub    $0x8,%esp
80106f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f2f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106f30:	8b 14 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%edx
80106f37:	c7 04 c5 42 72 13 80 	movl   $0x8e000008,-0x7fec8dbe(,%eax,8)
80106f3e:	08 00 00 8e 
80106f42:	66 89 14 c5 40 72 13 	mov    %dx,-0x7fec8dc0(,%eax,8)
80106f49:	80 
80106f4a:	c1 ea 10             	shr    $0x10,%edx
80106f4d:	66 89 14 c5 46 72 13 	mov    %dx,-0x7fec8dba(,%eax,8)
80106f54:	80 
  for(i = 0; i < 256; i++)
80106f55:	83 c0 01             	add    $0x1,%eax
80106f58:	3d 00 01 00 00       	cmp    $0x100,%eax
80106f5d:	75 d1                	jne    80106f30 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80106f5f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106f62:	a1 0c c1 10 80       	mov    0x8010c10c,%eax
80106f67:	c7 05 42 74 13 80 08 	movl   $0xef000008,0x80137442
80106f6e:	00 00 ef 
  initlock(&tickslock, "time");
80106f71:	68 0d 93 10 80       	push   $0x8010930d
80106f76:	68 00 72 13 80       	push   $0x80137200
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106f7b:	66 a3 40 74 13 80    	mov    %ax,0x80137440
80106f81:	c1 e8 10             	shr    $0x10,%eax
80106f84:	66 a3 46 74 13 80    	mov    %ax,0x80137446
  initlock(&tickslock, "time");
80106f8a:	e8 71 e6 ff ff       	call   80105600 <initlock>
}
80106f8f:	83 c4 10             	add    $0x10,%esp
80106f92:	c9                   	leave  
80106f93:	c3                   	ret    
80106f94:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f9f:	90                   	nop

80106fa0 <idtinit>:

void
idtinit(void)
{
80106fa0:	55                   	push   %ebp
  pd[0] = size-1;
80106fa1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106fa6:	89 e5                	mov    %esp,%ebp
80106fa8:	83 ec 10             	sub    $0x10,%esp
80106fab:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106faf:	b8 40 72 13 80       	mov    $0x80137240,%eax
80106fb4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106fb8:	c1 e8 10             	shr    $0x10,%eax
80106fbb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106fbf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106fc2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106fc5:	c9                   	leave  
80106fc6:	c3                   	ret    
80106fc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fce:	66 90                	xchg   %ax,%ax

80106fd0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106fd0:	55                   	push   %ebp
80106fd1:	89 e5                	mov    %esp,%ebp
80106fd3:	57                   	push   %edi
80106fd4:	56                   	push   %esi
80106fd5:	53                   	push   %ebx
80106fd6:	83 ec 1c             	sub    $0x1c,%esp
80106fd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106fdc:	8b 43 30             	mov    0x30(%ebx),%eax
80106fdf:	83 f8 40             	cmp    $0x40,%eax
80106fe2:	0f 84 68 01 00 00    	je     80107150 <trap+0x180>
      exit();
    return;
  }

  int osTicks;
  switch (tf->trapno)
80106fe8:	83 e8 20             	sub    $0x20,%eax
80106feb:	83 f8 1f             	cmp    $0x1f,%eax
80106fee:	0f 87 8c 00 00 00    	ja     80107080 <trap+0xb0>
80106ff4:	ff 24 85 b4 93 10 80 	jmp    *-0x7fef6c4c(,%eax,4)
80106ffb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106fff:	90                   	nop
      ageprocs(osTicks);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80107000:	e8 eb b8 ff ff       	call   801028f0 <ideintr>
    lapiceoi();
80107005:	e8 b6 bf ff ff       	call   80102fc0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010700a:	e8 81 d0 ff ff       	call   80104090 <myproc>
8010700f:	85 c0                	test   %eax,%eax
80107011:	74 1d                	je     80107030 <trap+0x60>
80107013:	e8 78 d0 ff ff       	call   80104090 <myproc>
80107018:	8b 50 24             	mov    0x24(%eax),%edx
8010701b:	85 d2                	test   %edx,%edx
8010701d:	74 11                	je     80107030 <trap+0x60>
8010701f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80107023:	83 e0 03             	and    $0x3,%eax
80107026:	66 83 f8 03          	cmp    $0x3,%ax
8010702a:	0f 84 f0 01 00 00    	je     80107220 <trap+0x250>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80107030:	e8 5b d0 ff ff       	call   80104090 <myproc>
80107035:	85 c0                	test   %eax,%eax
80107037:	74 0f                	je     80107048 <trap+0x78>
80107039:	e8 52 d0 ff ff       	call   80104090 <myproc>
8010703e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80107042:	0f 84 b8 00 00 00    	je     80107100 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107048:	e8 43 d0 ff ff       	call   80104090 <myproc>
8010704d:	85 c0                	test   %eax,%eax
8010704f:	74 1d                	je     8010706e <trap+0x9e>
80107051:	e8 3a d0 ff ff       	call   80104090 <myproc>
80107056:	8b 40 24             	mov    0x24(%eax),%eax
80107059:	85 c0                	test   %eax,%eax
8010705b:	74 11                	je     8010706e <trap+0x9e>
8010705d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80107061:	83 e0 03             	and    $0x3,%eax
80107064:	66 83 f8 03          	cmp    $0x3,%ax
80107068:	0f 84 0f 01 00 00    	je     8010717d <trap+0x1ad>
    exit();
}
8010706e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107071:	5b                   	pop    %ebx
80107072:	5e                   	pop    %esi
80107073:	5f                   	pop    %edi
80107074:	5d                   	pop    %ebp
80107075:	c3                   	ret    
80107076:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010707d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80107080:	e8 0b d0 ff ff       	call   80104090 <myproc>
80107085:	8b 7b 38             	mov    0x38(%ebx),%edi
80107088:	85 c0                	test   %eax,%eax
8010708a:	0f 84 aa 01 00 00    	je     8010723a <trap+0x26a>
80107090:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80107094:	0f 84 a0 01 00 00    	je     8010723a <trap+0x26a>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010709a:	0f 20 d1             	mov    %cr2,%ecx
8010709d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801070a0:	e8 cb cf ff ff       	call   80104070 <cpuid>
801070a5:	8b 73 30             	mov    0x30(%ebx),%esi
801070a8:	89 45 dc             	mov    %eax,-0x24(%ebp)
801070ab:	8b 43 34             	mov    0x34(%ebx),%eax
801070ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
801070b1:	e8 da cf ff ff       	call   80104090 <myproc>
801070b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801070b9:	e8 d2 cf ff ff       	call   80104090 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801070be:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801070c1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801070c4:	51                   	push   %ecx
801070c5:	57                   	push   %edi
801070c6:	52                   	push   %edx
801070c7:	ff 75 e4             	push   -0x1c(%ebp)
801070ca:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801070cb:	8b 75 e0             	mov    -0x20(%ebp),%esi
801070ce:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801070d1:	56                   	push   %esi
801070d2:	ff 70 10             	push   0x10(%eax)
801070d5:	68 70 93 10 80       	push   $0x80109370
801070da:	e8 c1 95 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
801070df:	83 c4 20             	add    $0x20,%esp
801070e2:	e8 a9 cf ff ff       	call   80104090 <myproc>
801070e7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801070ee:	e8 9d cf ff ff       	call   80104090 <myproc>
801070f3:	85 c0                	test   %eax,%eax
801070f5:	0f 85 18 ff ff ff    	jne    80107013 <trap+0x43>
801070fb:	e9 30 ff ff ff       	jmp    80107030 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80107100:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80107104:	0f 85 3e ff ff ff    	jne    80107048 <trap+0x78>
    yield();
8010710a:	e8 a1 d9 ff ff       	call   80104ab0 <yield>
8010710f:	e9 34 ff ff ff       	jmp    80107048 <trap+0x78>
80107114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107118:	8b 7b 38             	mov    0x38(%ebx),%edi
8010711b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010711f:	e8 4c cf ff ff       	call   80104070 <cpuid>
80107124:	57                   	push   %edi
80107125:	56                   	push   %esi
80107126:	50                   	push   %eax
80107127:	68 18 93 10 80       	push   $0x80109318
8010712c:	e8 6f 95 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80107131:	e8 8a be ff ff       	call   80102fc0 <lapiceoi>
    break;
80107136:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107139:	e8 52 cf ff ff       	call   80104090 <myproc>
8010713e:	85 c0                	test   %eax,%eax
80107140:	0f 85 cd fe ff ff    	jne    80107013 <trap+0x43>
80107146:	e9 e5 fe ff ff       	jmp    80107030 <trap+0x60>
8010714b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010714f:	90                   	nop
    if(myproc()->killed)
80107150:	e8 3b cf ff ff       	call   80104090 <myproc>
80107155:	8b 70 24             	mov    0x24(%eax),%esi
80107158:	85 f6                	test   %esi,%esi
8010715a:	0f 85 d0 00 00 00    	jne    80107230 <trap+0x260>
    myproc()->tf = tf;
80107160:	e8 2b cf ff ff       	call   80104090 <myproc>
80107165:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80107168:	e8 b3 eb ff ff       	call   80105d20 <syscall>
    if(myproc()->killed)
8010716d:	e8 1e cf ff ff       	call   80104090 <myproc>
80107172:	8b 48 24             	mov    0x24(%eax),%ecx
80107175:	85 c9                	test   %ecx,%ecx
80107177:	0f 84 f1 fe ff ff    	je     8010706e <trap+0x9e>
}
8010717d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107180:	5b                   	pop    %ebx
80107181:	5e                   	pop    %esi
80107182:	5f                   	pop    %edi
80107183:	5d                   	pop    %ebp
      exit();
80107184:	e9 07 d7 ff ff       	jmp    80104890 <exit>
80107189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80107190:	e8 4b 02 00 00       	call   801073e0 <uartintr>
    lapiceoi();
80107195:	e8 26 be ff ff       	call   80102fc0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010719a:	e8 f1 ce ff ff       	call   80104090 <myproc>
8010719f:	85 c0                	test   %eax,%eax
801071a1:	0f 85 6c fe ff ff    	jne    80107013 <trap+0x43>
801071a7:	e9 84 fe ff ff       	jmp    80107030 <trap+0x60>
801071ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801071b0:	e8 cb bc ff ff       	call   80102e80 <kbdintr>
    lapiceoi();
801071b5:	e8 06 be ff ff       	call   80102fc0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801071ba:	e8 d1 ce ff ff       	call   80104090 <myproc>
801071bf:	85 c0                	test   %eax,%eax
801071c1:	0f 85 4c fe ff ff    	jne    80107013 <trap+0x43>
801071c7:	e9 64 fe ff ff       	jmp    80107030 <trap+0x60>
801071cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
801071d0:	e8 9b ce ff ff       	call   80104070 <cpuid>
801071d5:	85 c0                	test   %eax,%eax
801071d7:	0f 85 28 fe ff ff    	jne    80107005 <trap+0x35>
      acquire(&tickslock);
801071dd:	83 ec 0c             	sub    $0xc,%esp
801071e0:	68 00 72 13 80       	push   $0x80137200
801071e5:	e8 e6 e5 ff ff       	call   801057d0 <acquire>
      ticks++;
801071ea:	a1 e0 71 13 80       	mov    0x801371e0,%eax
      wakeup(&ticks);
801071ef:	c7 04 24 e0 71 13 80 	movl   $0x801371e0,(%esp)
      ticks++;
801071f6:	8d 70 01             	lea    0x1(%eax),%esi
801071f9:	89 35 e0 71 13 80    	mov    %esi,0x801371e0
      wakeup(&ticks);
801071ff:	e8 bc d9 ff ff       	call   80104bc0 <wakeup>
      release(&tickslock);
80107204:	c7 04 24 00 72 13 80 	movl   $0x80137200,(%esp)
8010720b:	e8 60 e5 ff ff       	call   80105770 <release>
      ageprocs(osTicks);
80107210:	89 34 24             	mov    %esi,(%esp)
80107213:	e8 18 d2 ff ff       	call   80104430 <ageprocs>
80107218:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010721b:	e9 e5 fd ff ff       	jmp    80107005 <trap+0x35>
    exit();
80107220:	e8 6b d6 ff ff       	call   80104890 <exit>
80107225:	e9 06 fe ff ff       	jmp    80107030 <trap+0x60>
8010722a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80107230:	e8 5b d6 ff ff       	call   80104890 <exit>
80107235:	e9 26 ff ff ff       	jmp    80107160 <trap+0x190>
8010723a:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010723d:	e8 2e ce ff ff       	call   80104070 <cpuid>
80107242:	83 ec 0c             	sub    $0xc,%esp
80107245:	56                   	push   %esi
80107246:	57                   	push   %edi
80107247:	50                   	push   %eax
80107248:	ff 73 30             	push   0x30(%ebx)
8010724b:	68 3c 93 10 80       	push   $0x8010933c
80107250:	e8 4b 94 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80107255:	83 c4 14             	add    $0x14,%esp
80107258:	68 12 93 10 80       	push   $0x80109312
8010725d:	e8 1e 91 ff ff       	call   80100380 <panic>
80107262:	66 90                	xchg   %ax,%ax
80107264:	66 90                	xchg   %ax,%ax
80107266:	66 90                	xchg   %ax,%ax
80107268:	66 90                	xchg   %ax,%ax
8010726a:	66 90                	xchg   %ax,%ax
8010726c:	66 90                	xchg   %ax,%ax
8010726e:	66 90                	xchg   %ax,%ax

80107270 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80107270:	a1 40 7a 13 80       	mov    0x80137a40,%eax
80107275:	85 c0                	test   %eax,%eax
80107277:	74 17                	je     80107290 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107279:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010727e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010727f:	a8 01                	test   $0x1,%al
80107281:	74 0d                	je     80107290 <uartgetc+0x20>
80107283:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107288:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80107289:	0f b6 c0             	movzbl %al,%eax
8010728c:	c3                   	ret    
8010728d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80107290:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107295:	c3                   	ret    
80107296:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010729d:	8d 76 00             	lea    0x0(%esi),%esi

801072a0 <uartinit>:
{
801072a0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801072a1:	31 c9                	xor    %ecx,%ecx
801072a3:	89 c8                	mov    %ecx,%eax
801072a5:	89 e5                	mov    %esp,%ebp
801072a7:	57                   	push   %edi
801072a8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801072ad:	56                   	push   %esi
801072ae:	89 fa                	mov    %edi,%edx
801072b0:	53                   	push   %ebx
801072b1:	83 ec 1c             	sub    $0x1c,%esp
801072b4:	ee                   	out    %al,(%dx)
801072b5:	be fb 03 00 00       	mov    $0x3fb,%esi
801072ba:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801072bf:	89 f2                	mov    %esi,%edx
801072c1:	ee                   	out    %al,(%dx)
801072c2:	b8 0c 00 00 00       	mov    $0xc,%eax
801072c7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801072cc:	ee                   	out    %al,(%dx)
801072cd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801072d2:	89 c8                	mov    %ecx,%eax
801072d4:	89 da                	mov    %ebx,%edx
801072d6:	ee                   	out    %al,(%dx)
801072d7:	b8 03 00 00 00       	mov    $0x3,%eax
801072dc:	89 f2                	mov    %esi,%edx
801072de:	ee                   	out    %al,(%dx)
801072df:	ba fc 03 00 00       	mov    $0x3fc,%edx
801072e4:	89 c8                	mov    %ecx,%eax
801072e6:	ee                   	out    %al,(%dx)
801072e7:	b8 01 00 00 00       	mov    $0x1,%eax
801072ec:	89 da                	mov    %ebx,%edx
801072ee:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801072ef:	ba fd 03 00 00       	mov    $0x3fd,%edx
801072f4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801072f5:	3c ff                	cmp    $0xff,%al
801072f7:	74 78                	je     80107371 <uartinit+0xd1>
  uart = 1;
801072f9:	c7 05 40 7a 13 80 01 	movl   $0x1,0x80137a40
80107300:	00 00 00 
80107303:	89 fa                	mov    %edi,%edx
80107305:	ec                   	in     (%dx),%al
80107306:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010730b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010730c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010730f:	bf 34 94 10 80       	mov    $0x80109434,%edi
80107314:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80107319:	6a 00                	push   $0x0
8010731b:	6a 04                	push   $0x4
8010731d:	e8 0e b8 ff ff       	call   80102b30 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80107322:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80107326:	83 c4 10             	add    $0x10,%esp
80107329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80107330:	a1 40 7a 13 80       	mov    0x80137a40,%eax
80107335:	bb 80 00 00 00       	mov    $0x80,%ebx
8010733a:	85 c0                	test   %eax,%eax
8010733c:	75 14                	jne    80107352 <uartinit+0xb2>
8010733e:	eb 23                	jmp    80107363 <uartinit+0xc3>
    microdelay(10);
80107340:	83 ec 0c             	sub    $0xc,%esp
80107343:	6a 0a                	push   $0xa
80107345:	e8 96 bc ff ff       	call   80102fe0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010734a:	83 c4 10             	add    $0x10,%esp
8010734d:	83 eb 01             	sub    $0x1,%ebx
80107350:	74 07                	je     80107359 <uartinit+0xb9>
80107352:	89 f2                	mov    %esi,%edx
80107354:	ec                   	in     (%dx),%al
80107355:	a8 20                	test   $0x20,%al
80107357:	74 e7                	je     80107340 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107359:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010735d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107362:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80107363:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80107367:	83 c7 01             	add    $0x1,%edi
8010736a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010736d:	84 c0                	test   %al,%al
8010736f:	75 bf                	jne    80107330 <uartinit+0x90>
}
80107371:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107374:	5b                   	pop    %ebx
80107375:	5e                   	pop    %esi
80107376:	5f                   	pop    %edi
80107377:	5d                   	pop    %ebp
80107378:	c3                   	ret    
80107379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107380 <uartputc>:
  if(!uart)
80107380:	a1 40 7a 13 80       	mov    0x80137a40,%eax
80107385:	85 c0                	test   %eax,%eax
80107387:	74 47                	je     801073d0 <uartputc+0x50>
{
80107389:	55                   	push   %ebp
8010738a:	89 e5                	mov    %esp,%ebp
8010738c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010738d:	be fd 03 00 00       	mov    $0x3fd,%esi
80107392:	53                   	push   %ebx
80107393:	bb 80 00 00 00       	mov    $0x80,%ebx
80107398:	eb 18                	jmp    801073b2 <uartputc+0x32>
8010739a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801073a0:	83 ec 0c             	sub    $0xc,%esp
801073a3:	6a 0a                	push   $0xa
801073a5:	e8 36 bc ff ff       	call   80102fe0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801073aa:	83 c4 10             	add    $0x10,%esp
801073ad:	83 eb 01             	sub    $0x1,%ebx
801073b0:	74 07                	je     801073b9 <uartputc+0x39>
801073b2:	89 f2                	mov    %esi,%edx
801073b4:	ec                   	in     (%dx),%al
801073b5:	a8 20                	test   $0x20,%al
801073b7:	74 e7                	je     801073a0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801073b9:	8b 45 08             	mov    0x8(%ebp),%eax
801073bc:	ba f8 03 00 00       	mov    $0x3f8,%edx
801073c1:	ee                   	out    %al,(%dx)
}
801073c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801073c5:	5b                   	pop    %ebx
801073c6:	5e                   	pop    %esi
801073c7:	5d                   	pop    %ebp
801073c8:	c3                   	ret    
801073c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073d0:	c3                   	ret    
801073d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073df:	90                   	nop

801073e0 <uartintr>:

void
uartintr(void)
{
801073e0:	55                   	push   %ebp
801073e1:	89 e5                	mov    %esp,%ebp
801073e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801073e6:	68 70 72 10 80       	push   $0x80107270
801073eb:	e8 90 95 ff ff       	call   80100980 <consoleintr>
}
801073f0:	83 c4 10             	add    $0x10,%esp
801073f3:	c9                   	leave  
801073f4:	c3                   	ret    
801073f5:	66 90                	xchg   %ax,%ax
801073f7:	66 90                	xchg   %ax,%ax
801073f9:	66 90                	xchg   %ax,%ax
801073fb:	66 90                	xchg   %ax,%ax
801073fd:	66 90                	xchg   %ax,%ax
801073ff:	90                   	nop

80107400 <srand>:

static uint seed = 1;

void
srand(uint s)
{
80107400:	55                   	push   %ebp
80107401:	89 e5                	mov    %esp,%ebp
  seed = s;
80107403:	8b 45 08             	mov    0x8(%ebp),%eax
}
80107406:	5d                   	pop    %ebp
  seed = s;
80107407:	a3 08 c0 10 80       	mov    %eax,0x8010c008
}
8010740c:	c3                   	ret    
8010740d:	8d 76 00             	lea    0x0(%esi),%esi

80107410 <rand>:

uint
rand(void)
{
  seed = seed
    * 1103515245
80107410:	69 05 08 c0 10 80 6d 	imul   $0x41c64e6d,0x8010c008,%eax
80107417:	4e c6 41 
    + 12345
8010741a:	05 39 30 00 00       	add    $0x3039,%eax
  seed = seed
8010741f:	a3 08 c0 10 80       	mov    %eax,0x8010c008
    % (1 << 31);
  return seed;
}
80107424:	c3                   	ret    
80107425:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010742c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107430 <digitcount>:

int
digitcount(int num)
{
80107430:	55                   	push   %ebp
80107431:	89 e5                	mov    %esp,%ebp
80107433:	56                   	push   %esi
80107434:	8b 4d 08             	mov    0x8(%ebp),%ecx
80107437:	53                   	push   %ebx
80107438:	bb 01 00 00 00       	mov    $0x1,%ebx
  if(num == 0) return 1;
8010743d:	85 c9                	test   %ecx,%ecx
8010743f:	74 24                	je     80107465 <digitcount+0x35>
  int count = 0;
80107441:	31 db                	xor    %ebx,%ebx
  while(num){
    num /= 10;
80107443:	be 67 66 66 66       	mov    $0x66666667,%esi
80107448:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010744f:	90                   	nop
80107450:	89 c8                	mov    %ecx,%eax
    ++count;
80107452:	83 c3 01             	add    $0x1,%ebx
    num /= 10;
80107455:	f7 ee                	imul   %esi
80107457:	89 c8                	mov    %ecx,%eax
80107459:	c1 f8 1f             	sar    $0x1f,%eax
8010745c:	c1 fa 02             	sar    $0x2,%edx
  while(num){
8010745f:	89 d1                	mov    %edx,%ecx
80107461:	29 c1                	sub    %eax,%ecx
80107463:	75 eb                	jne    80107450 <digitcount+0x20>
  }
  return count;
}
80107465:	89 d8                	mov    %ebx,%eax
80107467:	5b                   	pop    %ebx
80107468:	5e                   	pop    %esi
80107469:	5d                   	pop    %ebp
8010746a:	c3                   	ret    
8010746b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010746f:	90                   	nop

80107470 <printspaces>:

void
printspaces(int count)
{
80107470:	55                   	push   %ebp
80107471:	89 e5                	mov    %esp,%ebp
80107473:	56                   	push   %esi
80107474:	8b 75 08             	mov    0x8(%ebp),%esi
80107477:	53                   	push   %ebx
  for(int i = 0; i < count; ++i)
80107478:	85 f6                	test   %esi,%esi
8010747a:	7e 1b                	jle    80107497 <printspaces+0x27>
8010747c:	31 db                	xor    %ebx,%ebx
8010747e:	66 90                	xchg   %ax,%ax
    cprintf(" ");
80107480:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80107483:	83 c3 01             	add    $0x1,%ebx
    cprintf(" ");
80107486:	68 c2 90 10 80       	push   $0x801090c2
8010748b:	e8 10 92 ff ff       	call   801006a0 <cprintf>
  for(int i = 0; i < count; ++i)
80107490:	83 c4 10             	add    $0x10,%esp
80107493:	39 de                	cmp    %ebx,%esi
80107495:	75 e9                	jne    80107480 <printspaces+0x10>
}
80107497:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010749a:	5b                   	pop    %ebx
8010749b:	5e                   	pop    %esi
8010749c:	5d                   	pop    %ebp
8010749d:	c3                   	ret    

8010749e <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
8010749e:	6a 00                	push   $0x0
  pushl $0
801074a0:	6a 00                	push   $0x0
  jmp alltraps
801074a2:	e9 50 fa ff ff       	jmp    80106ef7 <alltraps>

801074a7 <vector1>:
.globl vector1
vector1:
  pushl $0
801074a7:	6a 00                	push   $0x0
  pushl $1
801074a9:	6a 01                	push   $0x1
  jmp alltraps
801074ab:	e9 47 fa ff ff       	jmp    80106ef7 <alltraps>

801074b0 <vector2>:
.globl vector2
vector2:
  pushl $0
801074b0:	6a 00                	push   $0x0
  pushl $2
801074b2:	6a 02                	push   $0x2
  jmp alltraps
801074b4:	e9 3e fa ff ff       	jmp    80106ef7 <alltraps>

801074b9 <vector3>:
.globl vector3
vector3:
  pushl $0
801074b9:	6a 00                	push   $0x0
  pushl $3
801074bb:	6a 03                	push   $0x3
  jmp alltraps
801074bd:	e9 35 fa ff ff       	jmp    80106ef7 <alltraps>

801074c2 <vector4>:
.globl vector4
vector4:
  pushl $0
801074c2:	6a 00                	push   $0x0
  pushl $4
801074c4:	6a 04                	push   $0x4
  jmp alltraps
801074c6:	e9 2c fa ff ff       	jmp    80106ef7 <alltraps>

801074cb <vector5>:
.globl vector5
vector5:
  pushl $0
801074cb:	6a 00                	push   $0x0
  pushl $5
801074cd:	6a 05                	push   $0x5
  jmp alltraps
801074cf:	e9 23 fa ff ff       	jmp    80106ef7 <alltraps>

801074d4 <vector6>:
.globl vector6
vector6:
  pushl $0
801074d4:	6a 00                	push   $0x0
  pushl $6
801074d6:	6a 06                	push   $0x6
  jmp alltraps
801074d8:	e9 1a fa ff ff       	jmp    80106ef7 <alltraps>

801074dd <vector7>:
.globl vector7
vector7:
  pushl $0
801074dd:	6a 00                	push   $0x0
  pushl $7
801074df:	6a 07                	push   $0x7
  jmp alltraps
801074e1:	e9 11 fa ff ff       	jmp    80106ef7 <alltraps>

801074e6 <vector8>:
.globl vector8
vector8:
  pushl $8
801074e6:	6a 08                	push   $0x8
  jmp alltraps
801074e8:	e9 0a fa ff ff       	jmp    80106ef7 <alltraps>

801074ed <vector9>:
.globl vector9
vector9:
  pushl $0
801074ed:	6a 00                	push   $0x0
  pushl $9
801074ef:	6a 09                	push   $0x9
  jmp alltraps
801074f1:	e9 01 fa ff ff       	jmp    80106ef7 <alltraps>

801074f6 <vector10>:
.globl vector10
vector10:
  pushl $10
801074f6:	6a 0a                	push   $0xa
  jmp alltraps
801074f8:	e9 fa f9 ff ff       	jmp    80106ef7 <alltraps>

801074fd <vector11>:
.globl vector11
vector11:
  pushl $11
801074fd:	6a 0b                	push   $0xb
  jmp alltraps
801074ff:	e9 f3 f9 ff ff       	jmp    80106ef7 <alltraps>

80107504 <vector12>:
.globl vector12
vector12:
  pushl $12
80107504:	6a 0c                	push   $0xc
  jmp alltraps
80107506:	e9 ec f9 ff ff       	jmp    80106ef7 <alltraps>

8010750b <vector13>:
.globl vector13
vector13:
  pushl $13
8010750b:	6a 0d                	push   $0xd
  jmp alltraps
8010750d:	e9 e5 f9 ff ff       	jmp    80106ef7 <alltraps>

80107512 <vector14>:
.globl vector14
vector14:
  pushl $14
80107512:	6a 0e                	push   $0xe
  jmp alltraps
80107514:	e9 de f9 ff ff       	jmp    80106ef7 <alltraps>

80107519 <vector15>:
.globl vector15
vector15:
  pushl $0
80107519:	6a 00                	push   $0x0
  pushl $15
8010751b:	6a 0f                	push   $0xf
  jmp alltraps
8010751d:	e9 d5 f9 ff ff       	jmp    80106ef7 <alltraps>

80107522 <vector16>:
.globl vector16
vector16:
  pushl $0
80107522:	6a 00                	push   $0x0
  pushl $16
80107524:	6a 10                	push   $0x10
  jmp alltraps
80107526:	e9 cc f9 ff ff       	jmp    80106ef7 <alltraps>

8010752b <vector17>:
.globl vector17
vector17:
  pushl $17
8010752b:	6a 11                	push   $0x11
  jmp alltraps
8010752d:	e9 c5 f9 ff ff       	jmp    80106ef7 <alltraps>

80107532 <vector18>:
.globl vector18
vector18:
  pushl $0
80107532:	6a 00                	push   $0x0
  pushl $18
80107534:	6a 12                	push   $0x12
  jmp alltraps
80107536:	e9 bc f9 ff ff       	jmp    80106ef7 <alltraps>

8010753b <vector19>:
.globl vector19
vector19:
  pushl $0
8010753b:	6a 00                	push   $0x0
  pushl $19
8010753d:	6a 13                	push   $0x13
  jmp alltraps
8010753f:	e9 b3 f9 ff ff       	jmp    80106ef7 <alltraps>

80107544 <vector20>:
.globl vector20
vector20:
  pushl $0
80107544:	6a 00                	push   $0x0
  pushl $20
80107546:	6a 14                	push   $0x14
  jmp alltraps
80107548:	e9 aa f9 ff ff       	jmp    80106ef7 <alltraps>

8010754d <vector21>:
.globl vector21
vector21:
  pushl $0
8010754d:	6a 00                	push   $0x0
  pushl $21
8010754f:	6a 15                	push   $0x15
  jmp alltraps
80107551:	e9 a1 f9 ff ff       	jmp    80106ef7 <alltraps>

80107556 <vector22>:
.globl vector22
vector22:
  pushl $0
80107556:	6a 00                	push   $0x0
  pushl $22
80107558:	6a 16                	push   $0x16
  jmp alltraps
8010755a:	e9 98 f9 ff ff       	jmp    80106ef7 <alltraps>

8010755f <vector23>:
.globl vector23
vector23:
  pushl $0
8010755f:	6a 00                	push   $0x0
  pushl $23
80107561:	6a 17                	push   $0x17
  jmp alltraps
80107563:	e9 8f f9 ff ff       	jmp    80106ef7 <alltraps>

80107568 <vector24>:
.globl vector24
vector24:
  pushl $0
80107568:	6a 00                	push   $0x0
  pushl $24
8010756a:	6a 18                	push   $0x18
  jmp alltraps
8010756c:	e9 86 f9 ff ff       	jmp    80106ef7 <alltraps>

80107571 <vector25>:
.globl vector25
vector25:
  pushl $0
80107571:	6a 00                	push   $0x0
  pushl $25
80107573:	6a 19                	push   $0x19
  jmp alltraps
80107575:	e9 7d f9 ff ff       	jmp    80106ef7 <alltraps>

8010757a <vector26>:
.globl vector26
vector26:
  pushl $0
8010757a:	6a 00                	push   $0x0
  pushl $26
8010757c:	6a 1a                	push   $0x1a
  jmp alltraps
8010757e:	e9 74 f9 ff ff       	jmp    80106ef7 <alltraps>

80107583 <vector27>:
.globl vector27
vector27:
  pushl $0
80107583:	6a 00                	push   $0x0
  pushl $27
80107585:	6a 1b                	push   $0x1b
  jmp alltraps
80107587:	e9 6b f9 ff ff       	jmp    80106ef7 <alltraps>

8010758c <vector28>:
.globl vector28
vector28:
  pushl $0
8010758c:	6a 00                	push   $0x0
  pushl $28
8010758e:	6a 1c                	push   $0x1c
  jmp alltraps
80107590:	e9 62 f9 ff ff       	jmp    80106ef7 <alltraps>

80107595 <vector29>:
.globl vector29
vector29:
  pushl $0
80107595:	6a 00                	push   $0x0
  pushl $29
80107597:	6a 1d                	push   $0x1d
  jmp alltraps
80107599:	e9 59 f9 ff ff       	jmp    80106ef7 <alltraps>

8010759e <vector30>:
.globl vector30
vector30:
  pushl $0
8010759e:	6a 00                	push   $0x0
  pushl $30
801075a0:	6a 1e                	push   $0x1e
  jmp alltraps
801075a2:	e9 50 f9 ff ff       	jmp    80106ef7 <alltraps>

801075a7 <vector31>:
.globl vector31
vector31:
  pushl $0
801075a7:	6a 00                	push   $0x0
  pushl $31
801075a9:	6a 1f                	push   $0x1f
  jmp alltraps
801075ab:	e9 47 f9 ff ff       	jmp    80106ef7 <alltraps>

801075b0 <vector32>:
.globl vector32
vector32:
  pushl $0
801075b0:	6a 00                	push   $0x0
  pushl $32
801075b2:	6a 20                	push   $0x20
  jmp alltraps
801075b4:	e9 3e f9 ff ff       	jmp    80106ef7 <alltraps>

801075b9 <vector33>:
.globl vector33
vector33:
  pushl $0
801075b9:	6a 00                	push   $0x0
  pushl $33
801075bb:	6a 21                	push   $0x21
  jmp alltraps
801075bd:	e9 35 f9 ff ff       	jmp    80106ef7 <alltraps>

801075c2 <vector34>:
.globl vector34
vector34:
  pushl $0
801075c2:	6a 00                	push   $0x0
  pushl $34
801075c4:	6a 22                	push   $0x22
  jmp alltraps
801075c6:	e9 2c f9 ff ff       	jmp    80106ef7 <alltraps>

801075cb <vector35>:
.globl vector35
vector35:
  pushl $0
801075cb:	6a 00                	push   $0x0
  pushl $35
801075cd:	6a 23                	push   $0x23
  jmp alltraps
801075cf:	e9 23 f9 ff ff       	jmp    80106ef7 <alltraps>

801075d4 <vector36>:
.globl vector36
vector36:
  pushl $0
801075d4:	6a 00                	push   $0x0
  pushl $36
801075d6:	6a 24                	push   $0x24
  jmp alltraps
801075d8:	e9 1a f9 ff ff       	jmp    80106ef7 <alltraps>

801075dd <vector37>:
.globl vector37
vector37:
  pushl $0
801075dd:	6a 00                	push   $0x0
  pushl $37
801075df:	6a 25                	push   $0x25
  jmp alltraps
801075e1:	e9 11 f9 ff ff       	jmp    80106ef7 <alltraps>

801075e6 <vector38>:
.globl vector38
vector38:
  pushl $0
801075e6:	6a 00                	push   $0x0
  pushl $38
801075e8:	6a 26                	push   $0x26
  jmp alltraps
801075ea:	e9 08 f9 ff ff       	jmp    80106ef7 <alltraps>

801075ef <vector39>:
.globl vector39
vector39:
  pushl $0
801075ef:	6a 00                	push   $0x0
  pushl $39
801075f1:	6a 27                	push   $0x27
  jmp alltraps
801075f3:	e9 ff f8 ff ff       	jmp    80106ef7 <alltraps>

801075f8 <vector40>:
.globl vector40
vector40:
  pushl $0
801075f8:	6a 00                	push   $0x0
  pushl $40
801075fa:	6a 28                	push   $0x28
  jmp alltraps
801075fc:	e9 f6 f8 ff ff       	jmp    80106ef7 <alltraps>

80107601 <vector41>:
.globl vector41
vector41:
  pushl $0
80107601:	6a 00                	push   $0x0
  pushl $41
80107603:	6a 29                	push   $0x29
  jmp alltraps
80107605:	e9 ed f8 ff ff       	jmp    80106ef7 <alltraps>

8010760a <vector42>:
.globl vector42
vector42:
  pushl $0
8010760a:	6a 00                	push   $0x0
  pushl $42
8010760c:	6a 2a                	push   $0x2a
  jmp alltraps
8010760e:	e9 e4 f8 ff ff       	jmp    80106ef7 <alltraps>

80107613 <vector43>:
.globl vector43
vector43:
  pushl $0
80107613:	6a 00                	push   $0x0
  pushl $43
80107615:	6a 2b                	push   $0x2b
  jmp alltraps
80107617:	e9 db f8 ff ff       	jmp    80106ef7 <alltraps>

8010761c <vector44>:
.globl vector44
vector44:
  pushl $0
8010761c:	6a 00                	push   $0x0
  pushl $44
8010761e:	6a 2c                	push   $0x2c
  jmp alltraps
80107620:	e9 d2 f8 ff ff       	jmp    80106ef7 <alltraps>

80107625 <vector45>:
.globl vector45
vector45:
  pushl $0
80107625:	6a 00                	push   $0x0
  pushl $45
80107627:	6a 2d                	push   $0x2d
  jmp alltraps
80107629:	e9 c9 f8 ff ff       	jmp    80106ef7 <alltraps>

8010762e <vector46>:
.globl vector46
vector46:
  pushl $0
8010762e:	6a 00                	push   $0x0
  pushl $46
80107630:	6a 2e                	push   $0x2e
  jmp alltraps
80107632:	e9 c0 f8 ff ff       	jmp    80106ef7 <alltraps>

80107637 <vector47>:
.globl vector47
vector47:
  pushl $0
80107637:	6a 00                	push   $0x0
  pushl $47
80107639:	6a 2f                	push   $0x2f
  jmp alltraps
8010763b:	e9 b7 f8 ff ff       	jmp    80106ef7 <alltraps>

80107640 <vector48>:
.globl vector48
vector48:
  pushl $0
80107640:	6a 00                	push   $0x0
  pushl $48
80107642:	6a 30                	push   $0x30
  jmp alltraps
80107644:	e9 ae f8 ff ff       	jmp    80106ef7 <alltraps>

80107649 <vector49>:
.globl vector49
vector49:
  pushl $0
80107649:	6a 00                	push   $0x0
  pushl $49
8010764b:	6a 31                	push   $0x31
  jmp alltraps
8010764d:	e9 a5 f8 ff ff       	jmp    80106ef7 <alltraps>

80107652 <vector50>:
.globl vector50
vector50:
  pushl $0
80107652:	6a 00                	push   $0x0
  pushl $50
80107654:	6a 32                	push   $0x32
  jmp alltraps
80107656:	e9 9c f8 ff ff       	jmp    80106ef7 <alltraps>

8010765b <vector51>:
.globl vector51
vector51:
  pushl $0
8010765b:	6a 00                	push   $0x0
  pushl $51
8010765d:	6a 33                	push   $0x33
  jmp alltraps
8010765f:	e9 93 f8 ff ff       	jmp    80106ef7 <alltraps>

80107664 <vector52>:
.globl vector52
vector52:
  pushl $0
80107664:	6a 00                	push   $0x0
  pushl $52
80107666:	6a 34                	push   $0x34
  jmp alltraps
80107668:	e9 8a f8 ff ff       	jmp    80106ef7 <alltraps>

8010766d <vector53>:
.globl vector53
vector53:
  pushl $0
8010766d:	6a 00                	push   $0x0
  pushl $53
8010766f:	6a 35                	push   $0x35
  jmp alltraps
80107671:	e9 81 f8 ff ff       	jmp    80106ef7 <alltraps>

80107676 <vector54>:
.globl vector54
vector54:
  pushl $0
80107676:	6a 00                	push   $0x0
  pushl $54
80107678:	6a 36                	push   $0x36
  jmp alltraps
8010767a:	e9 78 f8 ff ff       	jmp    80106ef7 <alltraps>

8010767f <vector55>:
.globl vector55
vector55:
  pushl $0
8010767f:	6a 00                	push   $0x0
  pushl $55
80107681:	6a 37                	push   $0x37
  jmp alltraps
80107683:	e9 6f f8 ff ff       	jmp    80106ef7 <alltraps>

80107688 <vector56>:
.globl vector56
vector56:
  pushl $0
80107688:	6a 00                	push   $0x0
  pushl $56
8010768a:	6a 38                	push   $0x38
  jmp alltraps
8010768c:	e9 66 f8 ff ff       	jmp    80106ef7 <alltraps>

80107691 <vector57>:
.globl vector57
vector57:
  pushl $0
80107691:	6a 00                	push   $0x0
  pushl $57
80107693:	6a 39                	push   $0x39
  jmp alltraps
80107695:	e9 5d f8 ff ff       	jmp    80106ef7 <alltraps>

8010769a <vector58>:
.globl vector58
vector58:
  pushl $0
8010769a:	6a 00                	push   $0x0
  pushl $58
8010769c:	6a 3a                	push   $0x3a
  jmp alltraps
8010769e:	e9 54 f8 ff ff       	jmp    80106ef7 <alltraps>

801076a3 <vector59>:
.globl vector59
vector59:
  pushl $0
801076a3:	6a 00                	push   $0x0
  pushl $59
801076a5:	6a 3b                	push   $0x3b
  jmp alltraps
801076a7:	e9 4b f8 ff ff       	jmp    80106ef7 <alltraps>

801076ac <vector60>:
.globl vector60
vector60:
  pushl $0
801076ac:	6a 00                	push   $0x0
  pushl $60
801076ae:	6a 3c                	push   $0x3c
  jmp alltraps
801076b0:	e9 42 f8 ff ff       	jmp    80106ef7 <alltraps>

801076b5 <vector61>:
.globl vector61
vector61:
  pushl $0
801076b5:	6a 00                	push   $0x0
  pushl $61
801076b7:	6a 3d                	push   $0x3d
  jmp alltraps
801076b9:	e9 39 f8 ff ff       	jmp    80106ef7 <alltraps>

801076be <vector62>:
.globl vector62
vector62:
  pushl $0
801076be:	6a 00                	push   $0x0
  pushl $62
801076c0:	6a 3e                	push   $0x3e
  jmp alltraps
801076c2:	e9 30 f8 ff ff       	jmp    80106ef7 <alltraps>

801076c7 <vector63>:
.globl vector63
vector63:
  pushl $0
801076c7:	6a 00                	push   $0x0
  pushl $63
801076c9:	6a 3f                	push   $0x3f
  jmp alltraps
801076cb:	e9 27 f8 ff ff       	jmp    80106ef7 <alltraps>

801076d0 <vector64>:
.globl vector64
vector64:
  pushl $0
801076d0:	6a 00                	push   $0x0
  pushl $64
801076d2:	6a 40                	push   $0x40
  jmp alltraps
801076d4:	e9 1e f8 ff ff       	jmp    80106ef7 <alltraps>

801076d9 <vector65>:
.globl vector65
vector65:
  pushl $0
801076d9:	6a 00                	push   $0x0
  pushl $65
801076db:	6a 41                	push   $0x41
  jmp alltraps
801076dd:	e9 15 f8 ff ff       	jmp    80106ef7 <alltraps>

801076e2 <vector66>:
.globl vector66
vector66:
  pushl $0
801076e2:	6a 00                	push   $0x0
  pushl $66
801076e4:	6a 42                	push   $0x42
  jmp alltraps
801076e6:	e9 0c f8 ff ff       	jmp    80106ef7 <alltraps>

801076eb <vector67>:
.globl vector67
vector67:
  pushl $0
801076eb:	6a 00                	push   $0x0
  pushl $67
801076ed:	6a 43                	push   $0x43
  jmp alltraps
801076ef:	e9 03 f8 ff ff       	jmp    80106ef7 <alltraps>

801076f4 <vector68>:
.globl vector68
vector68:
  pushl $0
801076f4:	6a 00                	push   $0x0
  pushl $68
801076f6:	6a 44                	push   $0x44
  jmp alltraps
801076f8:	e9 fa f7 ff ff       	jmp    80106ef7 <alltraps>

801076fd <vector69>:
.globl vector69
vector69:
  pushl $0
801076fd:	6a 00                	push   $0x0
  pushl $69
801076ff:	6a 45                	push   $0x45
  jmp alltraps
80107701:	e9 f1 f7 ff ff       	jmp    80106ef7 <alltraps>

80107706 <vector70>:
.globl vector70
vector70:
  pushl $0
80107706:	6a 00                	push   $0x0
  pushl $70
80107708:	6a 46                	push   $0x46
  jmp alltraps
8010770a:	e9 e8 f7 ff ff       	jmp    80106ef7 <alltraps>

8010770f <vector71>:
.globl vector71
vector71:
  pushl $0
8010770f:	6a 00                	push   $0x0
  pushl $71
80107711:	6a 47                	push   $0x47
  jmp alltraps
80107713:	e9 df f7 ff ff       	jmp    80106ef7 <alltraps>

80107718 <vector72>:
.globl vector72
vector72:
  pushl $0
80107718:	6a 00                	push   $0x0
  pushl $72
8010771a:	6a 48                	push   $0x48
  jmp alltraps
8010771c:	e9 d6 f7 ff ff       	jmp    80106ef7 <alltraps>

80107721 <vector73>:
.globl vector73
vector73:
  pushl $0
80107721:	6a 00                	push   $0x0
  pushl $73
80107723:	6a 49                	push   $0x49
  jmp alltraps
80107725:	e9 cd f7 ff ff       	jmp    80106ef7 <alltraps>

8010772a <vector74>:
.globl vector74
vector74:
  pushl $0
8010772a:	6a 00                	push   $0x0
  pushl $74
8010772c:	6a 4a                	push   $0x4a
  jmp alltraps
8010772e:	e9 c4 f7 ff ff       	jmp    80106ef7 <alltraps>

80107733 <vector75>:
.globl vector75
vector75:
  pushl $0
80107733:	6a 00                	push   $0x0
  pushl $75
80107735:	6a 4b                	push   $0x4b
  jmp alltraps
80107737:	e9 bb f7 ff ff       	jmp    80106ef7 <alltraps>

8010773c <vector76>:
.globl vector76
vector76:
  pushl $0
8010773c:	6a 00                	push   $0x0
  pushl $76
8010773e:	6a 4c                	push   $0x4c
  jmp alltraps
80107740:	e9 b2 f7 ff ff       	jmp    80106ef7 <alltraps>

80107745 <vector77>:
.globl vector77
vector77:
  pushl $0
80107745:	6a 00                	push   $0x0
  pushl $77
80107747:	6a 4d                	push   $0x4d
  jmp alltraps
80107749:	e9 a9 f7 ff ff       	jmp    80106ef7 <alltraps>

8010774e <vector78>:
.globl vector78
vector78:
  pushl $0
8010774e:	6a 00                	push   $0x0
  pushl $78
80107750:	6a 4e                	push   $0x4e
  jmp alltraps
80107752:	e9 a0 f7 ff ff       	jmp    80106ef7 <alltraps>

80107757 <vector79>:
.globl vector79
vector79:
  pushl $0
80107757:	6a 00                	push   $0x0
  pushl $79
80107759:	6a 4f                	push   $0x4f
  jmp alltraps
8010775b:	e9 97 f7 ff ff       	jmp    80106ef7 <alltraps>

80107760 <vector80>:
.globl vector80
vector80:
  pushl $0
80107760:	6a 00                	push   $0x0
  pushl $80
80107762:	6a 50                	push   $0x50
  jmp alltraps
80107764:	e9 8e f7 ff ff       	jmp    80106ef7 <alltraps>

80107769 <vector81>:
.globl vector81
vector81:
  pushl $0
80107769:	6a 00                	push   $0x0
  pushl $81
8010776b:	6a 51                	push   $0x51
  jmp alltraps
8010776d:	e9 85 f7 ff ff       	jmp    80106ef7 <alltraps>

80107772 <vector82>:
.globl vector82
vector82:
  pushl $0
80107772:	6a 00                	push   $0x0
  pushl $82
80107774:	6a 52                	push   $0x52
  jmp alltraps
80107776:	e9 7c f7 ff ff       	jmp    80106ef7 <alltraps>

8010777b <vector83>:
.globl vector83
vector83:
  pushl $0
8010777b:	6a 00                	push   $0x0
  pushl $83
8010777d:	6a 53                	push   $0x53
  jmp alltraps
8010777f:	e9 73 f7 ff ff       	jmp    80106ef7 <alltraps>

80107784 <vector84>:
.globl vector84
vector84:
  pushl $0
80107784:	6a 00                	push   $0x0
  pushl $84
80107786:	6a 54                	push   $0x54
  jmp alltraps
80107788:	e9 6a f7 ff ff       	jmp    80106ef7 <alltraps>

8010778d <vector85>:
.globl vector85
vector85:
  pushl $0
8010778d:	6a 00                	push   $0x0
  pushl $85
8010778f:	6a 55                	push   $0x55
  jmp alltraps
80107791:	e9 61 f7 ff ff       	jmp    80106ef7 <alltraps>

80107796 <vector86>:
.globl vector86
vector86:
  pushl $0
80107796:	6a 00                	push   $0x0
  pushl $86
80107798:	6a 56                	push   $0x56
  jmp alltraps
8010779a:	e9 58 f7 ff ff       	jmp    80106ef7 <alltraps>

8010779f <vector87>:
.globl vector87
vector87:
  pushl $0
8010779f:	6a 00                	push   $0x0
  pushl $87
801077a1:	6a 57                	push   $0x57
  jmp alltraps
801077a3:	e9 4f f7 ff ff       	jmp    80106ef7 <alltraps>

801077a8 <vector88>:
.globl vector88
vector88:
  pushl $0
801077a8:	6a 00                	push   $0x0
  pushl $88
801077aa:	6a 58                	push   $0x58
  jmp alltraps
801077ac:	e9 46 f7 ff ff       	jmp    80106ef7 <alltraps>

801077b1 <vector89>:
.globl vector89
vector89:
  pushl $0
801077b1:	6a 00                	push   $0x0
  pushl $89
801077b3:	6a 59                	push   $0x59
  jmp alltraps
801077b5:	e9 3d f7 ff ff       	jmp    80106ef7 <alltraps>

801077ba <vector90>:
.globl vector90
vector90:
  pushl $0
801077ba:	6a 00                	push   $0x0
  pushl $90
801077bc:	6a 5a                	push   $0x5a
  jmp alltraps
801077be:	e9 34 f7 ff ff       	jmp    80106ef7 <alltraps>

801077c3 <vector91>:
.globl vector91
vector91:
  pushl $0
801077c3:	6a 00                	push   $0x0
  pushl $91
801077c5:	6a 5b                	push   $0x5b
  jmp alltraps
801077c7:	e9 2b f7 ff ff       	jmp    80106ef7 <alltraps>

801077cc <vector92>:
.globl vector92
vector92:
  pushl $0
801077cc:	6a 00                	push   $0x0
  pushl $92
801077ce:	6a 5c                	push   $0x5c
  jmp alltraps
801077d0:	e9 22 f7 ff ff       	jmp    80106ef7 <alltraps>

801077d5 <vector93>:
.globl vector93
vector93:
  pushl $0
801077d5:	6a 00                	push   $0x0
  pushl $93
801077d7:	6a 5d                	push   $0x5d
  jmp alltraps
801077d9:	e9 19 f7 ff ff       	jmp    80106ef7 <alltraps>

801077de <vector94>:
.globl vector94
vector94:
  pushl $0
801077de:	6a 00                	push   $0x0
  pushl $94
801077e0:	6a 5e                	push   $0x5e
  jmp alltraps
801077e2:	e9 10 f7 ff ff       	jmp    80106ef7 <alltraps>

801077e7 <vector95>:
.globl vector95
vector95:
  pushl $0
801077e7:	6a 00                	push   $0x0
  pushl $95
801077e9:	6a 5f                	push   $0x5f
  jmp alltraps
801077eb:	e9 07 f7 ff ff       	jmp    80106ef7 <alltraps>

801077f0 <vector96>:
.globl vector96
vector96:
  pushl $0
801077f0:	6a 00                	push   $0x0
  pushl $96
801077f2:	6a 60                	push   $0x60
  jmp alltraps
801077f4:	e9 fe f6 ff ff       	jmp    80106ef7 <alltraps>

801077f9 <vector97>:
.globl vector97
vector97:
  pushl $0
801077f9:	6a 00                	push   $0x0
  pushl $97
801077fb:	6a 61                	push   $0x61
  jmp alltraps
801077fd:	e9 f5 f6 ff ff       	jmp    80106ef7 <alltraps>

80107802 <vector98>:
.globl vector98
vector98:
  pushl $0
80107802:	6a 00                	push   $0x0
  pushl $98
80107804:	6a 62                	push   $0x62
  jmp alltraps
80107806:	e9 ec f6 ff ff       	jmp    80106ef7 <alltraps>

8010780b <vector99>:
.globl vector99
vector99:
  pushl $0
8010780b:	6a 00                	push   $0x0
  pushl $99
8010780d:	6a 63                	push   $0x63
  jmp alltraps
8010780f:	e9 e3 f6 ff ff       	jmp    80106ef7 <alltraps>

80107814 <vector100>:
.globl vector100
vector100:
  pushl $0
80107814:	6a 00                	push   $0x0
  pushl $100
80107816:	6a 64                	push   $0x64
  jmp alltraps
80107818:	e9 da f6 ff ff       	jmp    80106ef7 <alltraps>

8010781d <vector101>:
.globl vector101
vector101:
  pushl $0
8010781d:	6a 00                	push   $0x0
  pushl $101
8010781f:	6a 65                	push   $0x65
  jmp alltraps
80107821:	e9 d1 f6 ff ff       	jmp    80106ef7 <alltraps>

80107826 <vector102>:
.globl vector102
vector102:
  pushl $0
80107826:	6a 00                	push   $0x0
  pushl $102
80107828:	6a 66                	push   $0x66
  jmp alltraps
8010782a:	e9 c8 f6 ff ff       	jmp    80106ef7 <alltraps>

8010782f <vector103>:
.globl vector103
vector103:
  pushl $0
8010782f:	6a 00                	push   $0x0
  pushl $103
80107831:	6a 67                	push   $0x67
  jmp alltraps
80107833:	e9 bf f6 ff ff       	jmp    80106ef7 <alltraps>

80107838 <vector104>:
.globl vector104
vector104:
  pushl $0
80107838:	6a 00                	push   $0x0
  pushl $104
8010783a:	6a 68                	push   $0x68
  jmp alltraps
8010783c:	e9 b6 f6 ff ff       	jmp    80106ef7 <alltraps>

80107841 <vector105>:
.globl vector105
vector105:
  pushl $0
80107841:	6a 00                	push   $0x0
  pushl $105
80107843:	6a 69                	push   $0x69
  jmp alltraps
80107845:	e9 ad f6 ff ff       	jmp    80106ef7 <alltraps>

8010784a <vector106>:
.globl vector106
vector106:
  pushl $0
8010784a:	6a 00                	push   $0x0
  pushl $106
8010784c:	6a 6a                	push   $0x6a
  jmp alltraps
8010784e:	e9 a4 f6 ff ff       	jmp    80106ef7 <alltraps>

80107853 <vector107>:
.globl vector107
vector107:
  pushl $0
80107853:	6a 00                	push   $0x0
  pushl $107
80107855:	6a 6b                	push   $0x6b
  jmp alltraps
80107857:	e9 9b f6 ff ff       	jmp    80106ef7 <alltraps>

8010785c <vector108>:
.globl vector108
vector108:
  pushl $0
8010785c:	6a 00                	push   $0x0
  pushl $108
8010785e:	6a 6c                	push   $0x6c
  jmp alltraps
80107860:	e9 92 f6 ff ff       	jmp    80106ef7 <alltraps>

80107865 <vector109>:
.globl vector109
vector109:
  pushl $0
80107865:	6a 00                	push   $0x0
  pushl $109
80107867:	6a 6d                	push   $0x6d
  jmp alltraps
80107869:	e9 89 f6 ff ff       	jmp    80106ef7 <alltraps>

8010786e <vector110>:
.globl vector110
vector110:
  pushl $0
8010786e:	6a 00                	push   $0x0
  pushl $110
80107870:	6a 6e                	push   $0x6e
  jmp alltraps
80107872:	e9 80 f6 ff ff       	jmp    80106ef7 <alltraps>

80107877 <vector111>:
.globl vector111
vector111:
  pushl $0
80107877:	6a 00                	push   $0x0
  pushl $111
80107879:	6a 6f                	push   $0x6f
  jmp alltraps
8010787b:	e9 77 f6 ff ff       	jmp    80106ef7 <alltraps>

80107880 <vector112>:
.globl vector112
vector112:
  pushl $0
80107880:	6a 00                	push   $0x0
  pushl $112
80107882:	6a 70                	push   $0x70
  jmp alltraps
80107884:	e9 6e f6 ff ff       	jmp    80106ef7 <alltraps>

80107889 <vector113>:
.globl vector113
vector113:
  pushl $0
80107889:	6a 00                	push   $0x0
  pushl $113
8010788b:	6a 71                	push   $0x71
  jmp alltraps
8010788d:	e9 65 f6 ff ff       	jmp    80106ef7 <alltraps>

80107892 <vector114>:
.globl vector114
vector114:
  pushl $0
80107892:	6a 00                	push   $0x0
  pushl $114
80107894:	6a 72                	push   $0x72
  jmp alltraps
80107896:	e9 5c f6 ff ff       	jmp    80106ef7 <alltraps>

8010789b <vector115>:
.globl vector115
vector115:
  pushl $0
8010789b:	6a 00                	push   $0x0
  pushl $115
8010789d:	6a 73                	push   $0x73
  jmp alltraps
8010789f:	e9 53 f6 ff ff       	jmp    80106ef7 <alltraps>

801078a4 <vector116>:
.globl vector116
vector116:
  pushl $0
801078a4:	6a 00                	push   $0x0
  pushl $116
801078a6:	6a 74                	push   $0x74
  jmp alltraps
801078a8:	e9 4a f6 ff ff       	jmp    80106ef7 <alltraps>

801078ad <vector117>:
.globl vector117
vector117:
  pushl $0
801078ad:	6a 00                	push   $0x0
  pushl $117
801078af:	6a 75                	push   $0x75
  jmp alltraps
801078b1:	e9 41 f6 ff ff       	jmp    80106ef7 <alltraps>

801078b6 <vector118>:
.globl vector118
vector118:
  pushl $0
801078b6:	6a 00                	push   $0x0
  pushl $118
801078b8:	6a 76                	push   $0x76
  jmp alltraps
801078ba:	e9 38 f6 ff ff       	jmp    80106ef7 <alltraps>

801078bf <vector119>:
.globl vector119
vector119:
  pushl $0
801078bf:	6a 00                	push   $0x0
  pushl $119
801078c1:	6a 77                	push   $0x77
  jmp alltraps
801078c3:	e9 2f f6 ff ff       	jmp    80106ef7 <alltraps>

801078c8 <vector120>:
.globl vector120
vector120:
  pushl $0
801078c8:	6a 00                	push   $0x0
  pushl $120
801078ca:	6a 78                	push   $0x78
  jmp alltraps
801078cc:	e9 26 f6 ff ff       	jmp    80106ef7 <alltraps>

801078d1 <vector121>:
.globl vector121
vector121:
  pushl $0
801078d1:	6a 00                	push   $0x0
  pushl $121
801078d3:	6a 79                	push   $0x79
  jmp alltraps
801078d5:	e9 1d f6 ff ff       	jmp    80106ef7 <alltraps>

801078da <vector122>:
.globl vector122
vector122:
  pushl $0
801078da:	6a 00                	push   $0x0
  pushl $122
801078dc:	6a 7a                	push   $0x7a
  jmp alltraps
801078de:	e9 14 f6 ff ff       	jmp    80106ef7 <alltraps>

801078e3 <vector123>:
.globl vector123
vector123:
  pushl $0
801078e3:	6a 00                	push   $0x0
  pushl $123
801078e5:	6a 7b                	push   $0x7b
  jmp alltraps
801078e7:	e9 0b f6 ff ff       	jmp    80106ef7 <alltraps>

801078ec <vector124>:
.globl vector124
vector124:
  pushl $0
801078ec:	6a 00                	push   $0x0
  pushl $124
801078ee:	6a 7c                	push   $0x7c
  jmp alltraps
801078f0:	e9 02 f6 ff ff       	jmp    80106ef7 <alltraps>

801078f5 <vector125>:
.globl vector125
vector125:
  pushl $0
801078f5:	6a 00                	push   $0x0
  pushl $125
801078f7:	6a 7d                	push   $0x7d
  jmp alltraps
801078f9:	e9 f9 f5 ff ff       	jmp    80106ef7 <alltraps>

801078fe <vector126>:
.globl vector126
vector126:
  pushl $0
801078fe:	6a 00                	push   $0x0
  pushl $126
80107900:	6a 7e                	push   $0x7e
  jmp alltraps
80107902:	e9 f0 f5 ff ff       	jmp    80106ef7 <alltraps>

80107907 <vector127>:
.globl vector127
vector127:
  pushl $0
80107907:	6a 00                	push   $0x0
  pushl $127
80107909:	6a 7f                	push   $0x7f
  jmp alltraps
8010790b:	e9 e7 f5 ff ff       	jmp    80106ef7 <alltraps>

80107910 <vector128>:
.globl vector128
vector128:
  pushl $0
80107910:	6a 00                	push   $0x0
  pushl $128
80107912:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107917:	e9 db f5 ff ff       	jmp    80106ef7 <alltraps>

8010791c <vector129>:
.globl vector129
vector129:
  pushl $0
8010791c:	6a 00                	push   $0x0
  pushl $129
8010791e:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107923:	e9 cf f5 ff ff       	jmp    80106ef7 <alltraps>

80107928 <vector130>:
.globl vector130
vector130:
  pushl $0
80107928:	6a 00                	push   $0x0
  pushl $130
8010792a:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010792f:	e9 c3 f5 ff ff       	jmp    80106ef7 <alltraps>

80107934 <vector131>:
.globl vector131
vector131:
  pushl $0
80107934:	6a 00                	push   $0x0
  pushl $131
80107936:	68 83 00 00 00       	push   $0x83
  jmp alltraps
8010793b:	e9 b7 f5 ff ff       	jmp    80106ef7 <alltraps>

80107940 <vector132>:
.globl vector132
vector132:
  pushl $0
80107940:	6a 00                	push   $0x0
  pushl $132
80107942:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107947:	e9 ab f5 ff ff       	jmp    80106ef7 <alltraps>

8010794c <vector133>:
.globl vector133
vector133:
  pushl $0
8010794c:	6a 00                	push   $0x0
  pushl $133
8010794e:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107953:	e9 9f f5 ff ff       	jmp    80106ef7 <alltraps>

80107958 <vector134>:
.globl vector134
vector134:
  pushl $0
80107958:	6a 00                	push   $0x0
  pushl $134
8010795a:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010795f:	e9 93 f5 ff ff       	jmp    80106ef7 <alltraps>

80107964 <vector135>:
.globl vector135
vector135:
  pushl $0
80107964:	6a 00                	push   $0x0
  pushl $135
80107966:	68 87 00 00 00       	push   $0x87
  jmp alltraps
8010796b:	e9 87 f5 ff ff       	jmp    80106ef7 <alltraps>

80107970 <vector136>:
.globl vector136
vector136:
  pushl $0
80107970:	6a 00                	push   $0x0
  pushl $136
80107972:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107977:	e9 7b f5 ff ff       	jmp    80106ef7 <alltraps>

8010797c <vector137>:
.globl vector137
vector137:
  pushl $0
8010797c:	6a 00                	push   $0x0
  pushl $137
8010797e:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107983:	e9 6f f5 ff ff       	jmp    80106ef7 <alltraps>

80107988 <vector138>:
.globl vector138
vector138:
  pushl $0
80107988:	6a 00                	push   $0x0
  pushl $138
8010798a:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010798f:	e9 63 f5 ff ff       	jmp    80106ef7 <alltraps>

80107994 <vector139>:
.globl vector139
vector139:
  pushl $0
80107994:	6a 00                	push   $0x0
  pushl $139
80107996:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
8010799b:	e9 57 f5 ff ff       	jmp    80106ef7 <alltraps>

801079a0 <vector140>:
.globl vector140
vector140:
  pushl $0
801079a0:	6a 00                	push   $0x0
  pushl $140
801079a2:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801079a7:	e9 4b f5 ff ff       	jmp    80106ef7 <alltraps>

801079ac <vector141>:
.globl vector141
vector141:
  pushl $0
801079ac:	6a 00                	push   $0x0
  pushl $141
801079ae:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801079b3:	e9 3f f5 ff ff       	jmp    80106ef7 <alltraps>

801079b8 <vector142>:
.globl vector142
vector142:
  pushl $0
801079b8:	6a 00                	push   $0x0
  pushl $142
801079ba:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801079bf:	e9 33 f5 ff ff       	jmp    80106ef7 <alltraps>

801079c4 <vector143>:
.globl vector143
vector143:
  pushl $0
801079c4:	6a 00                	push   $0x0
  pushl $143
801079c6:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801079cb:	e9 27 f5 ff ff       	jmp    80106ef7 <alltraps>

801079d0 <vector144>:
.globl vector144
vector144:
  pushl $0
801079d0:	6a 00                	push   $0x0
  pushl $144
801079d2:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801079d7:	e9 1b f5 ff ff       	jmp    80106ef7 <alltraps>

801079dc <vector145>:
.globl vector145
vector145:
  pushl $0
801079dc:	6a 00                	push   $0x0
  pushl $145
801079de:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801079e3:	e9 0f f5 ff ff       	jmp    80106ef7 <alltraps>

801079e8 <vector146>:
.globl vector146
vector146:
  pushl $0
801079e8:	6a 00                	push   $0x0
  pushl $146
801079ea:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801079ef:	e9 03 f5 ff ff       	jmp    80106ef7 <alltraps>

801079f4 <vector147>:
.globl vector147
vector147:
  pushl $0
801079f4:	6a 00                	push   $0x0
  pushl $147
801079f6:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801079fb:	e9 f7 f4 ff ff       	jmp    80106ef7 <alltraps>

80107a00 <vector148>:
.globl vector148
vector148:
  pushl $0
80107a00:	6a 00                	push   $0x0
  pushl $148
80107a02:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107a07:	e9 eb f4 ff ff       	jmp    80106ef7 <alltraps>

80107a0c <vector149>:
.globl vector149
vector149:
  pushl $0
80107a0c:	6a 00                	push   $0x0
  pushl $149
80107a0e:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107a13:	e9 df f4 ff ff       	jmp    80106ef7 <alltraps>

80107a18 <vector150>:
.globl vector150
vector150:
  pushl $0
80107a18:	6a 00                	push   $0x0
  pushl $150
80107a1a:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107a1f:	e9 d3 f4 ff ff       	jmp    80106ef7 <alltraps>

80107a24 <vector151>:
.globl vector151
vector151:
  pushl $0
80107a24:	6a 00                	push   $0x0
  pushl $151
80107a26:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107a2b:	e9 c7 f4 ff ff       	jmp    80106ef7 <alltraps>

80107a30 <vector152>:
.globl vector152
vector152:
  pushl $0
80107a30:	6a 00                	push   $0x0
  pushl $152
80107a32:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107a37:	e9 bb f4 ff ff       	jmp    80106ef7 <alltraps>

80107a3c <vector153>:
.globl vector153
vector153:
  pushl $0
80107a3c:	6a 00                	push   $0x0
  pushl $153
80107a3e:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107a43:	e9 af f4 ff ff       	jmp    80106ef7 <alltraps>

80107a48 <vector154>:
.globl vector154
vector154:
  pushl $0
80107a48:	6a 00                	push   $0x0
  pushl $154
80107a4a:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107a4f:	e9 a3 f4 ff ff       	jmp    80106ef7 <alltraps>

80107a54 <vector155>:
.globl vector155
vector155:
  pushl $0
80107a54:	6a 00                	push   $0x0
  pushl $155
80107a56:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107a5b:	e9 97 f4 ff ff       	jmp    80106ef7 <alltraps>

80107a60 <vector156>:
.globl vector156
vector156:
  pushl $0
80107a60:	6a 00                	push   $0x0
  pushl $156
80107a62:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107a67:	e9 8b f4 ff ff       	jmp    80106ef7 <alltraps>

80107a6c <vector157>:
.globl vector157
vector157:
  pushl $0
80107a6c:	6a 00                	push   $0x0
  pushl $157
80107a6e:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107a73:	e9 7f f4 ff ff       	jmp    80106ef7 <alltraps>

80107a78 <vector158>:
.globl vector158
vector158:
  pushl $0
80107a78:	6a 00                	push   $0x0
  pushl $158
80107a7a:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107a7f:	e9 73 f4 ff ff       	jmp    80106ef7 <alltraps>

80107a84 <vector159>:
.globl vector159
vector159:
  pushl $0
80107a84:	6a 00                	push   $0x0
  pushl $159
80107a86:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107a8b:	e9 67 f4 ff ff       	jmp    80106ef7 <alltraps>

80107a90 <vector160>:
.globl vector160
vector160:
  pushl $0
80107a90:	6a 00                	push   $0x0
  pushl $160
80107a92:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107a97:	e9 5b f4 ff ff       	jmp    80106ef7 <alltraps>

80107a9c <vector161>:
.globl vector161
vector161:
  pushl $0
80107a9c:	6a 00                	push   $0x0
  pushl $161
80107a9e:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107aa3:	e9 4f f4 ff ff       	jmp    80106ef7 <alltraps>

80107aa8 <vector162>:
.globl vector162
vector162:
  pushl $0
80107aa8:	6a 00                	push   $0x0
  pushl $162
80107aaa:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107aaf:	e9 43 f4 ff ff       	jmp    80106ef7 <alltraps>

80107ab4 <vector163>:
.globl vector163
vector163:
  pushl $0
80107ab4:	6a 00                	push   $0x0
  pushl $163
80107ab6:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107abb:	e9 37 f4 ff ff       	jmp    80106ef7 <alltraps>

80107ac0 <vector164>:
.globl vector164
vector164:
  pushl $0
80107ac0:	6a 00                	push   $0x0
  pushl $164
80107ac2:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107ac7:	e9 2b f4 ff ff       	jmp    80106ef7 <alltraps>

80107acc <vector165>:
.globl vector165
vector165:
  pushl $0
80107acc:	6a 00                	push   $0x0
  pushl $165
80107ace:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107ad3:	e9 1f f4 ff ff       	jmp    80106ef7 <alltraps>

80107ad8 <vector166>:
.globl vector166
vector166:
  pushl $0
80107ad8:	6a 00                	push   $0x0
  pushl $166
80107ada:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107adf:	e9 13 f4 ff ff       	jmp    80106ef7 <alltraps>

80107ae4 <vector167>:
.globl vector167
vector167:
  pushl $0
80107ae4:	6a 00                	push   $0x0
  pushl $167
80107ae6:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107aeb:	e9 07 f4 ff ff       	jmp    80106ef7 <alltraps>

80107af0 <vector168>:
.globl vector168
vector168:
  pushl $0
80107af0:	6a 00                	push   $0x0
  pushl $168
80107af2:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107af7:	e9 fb f3 ff ff       	jmp    80106ef7 <alltraps>

80107afc <vector169>:
.globl vector169
vector169:
  pushl $0
80107afc:	6a 00                	push   $0x0
  pushl $169
80107afe:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107b03:	e9 ef f3 ff ff       	jmp    80106ef7 <alltraps>

80107b08 <vector170>:
.globl vector170
vector170:
  pushl $0
80107b08:	6a 00                	push   $0x0
  pushl $170
80107b0a:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107b0f:	e9 e3 f3 ff ff       	jmp    80106ef7 <alltraps>

80107b14 <vector171>:
.globl vector171
vector171:
  pushl $0
80107b14:	6a 00                	push   $0x0
  pushl $171
80107b16:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107b1b:	e9 d7 f3 ff ff       	jmp    80106ef7 <alltraps>

80107b20 <vector172>:
.globl vector172
vector172:
  pushl $0
80107b20:	6a 00                	push   $0x0
  pushl $172
80107b22:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107b27:	e9 cb f3 ff ff       	jmp    80106ef7 <alltraps>

80107b2c <vector173>:
.globl vector173
vector173:
  pushl $0
80107b2c:	6a 00                	push   $0x0
  pushl $173
80107b2e:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107b33:	e9 bf f3 ff ff       	jmp    80106ef7 <alltraps>

80107b38 <vector174>:
.globl vector174
vector174:
  pushl $0
80107b38:	6a 00                	push   $0x0
  pushl $174
80107b3a:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107b3f:	e9 b3 f3 ff ff       	jmp    80106ef7 <alltraps>

80107b44 <vector175>:
.globl vector175
vector175:
  pushl $0
80107b44:	6a 00                	push   $0x0
  pushl $175
80107b46:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107b4b:	e9 a7 f3 ff ff       	jmp    80106ef7 <alltraps>

80107b50 <vector176>:
.globl vector176
vector176:
  pushl $0
80107b50:	6a 00                	push   $0x0
  pushl $176
80107b52:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107b57:	e9 9b f3 ff ff       	jmp    80106ef7 <alltraps>

80107b5c <vector177>:
.globl vector177
vector177:
  pushl $0
80107b5c:	6a 00                	push   $0x0
  pushl $177
80107b5e:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107b63:	e9 8f f3 ff ff       	jmp    80106ef7 <alltraps>

80107b68 <vector178>:
.globl vector178
vector178:
  pushl $0
80107b68:	6a 00                	push   $0x0
  pushl $178
80107b6a:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107b6f:	e9 83 f3 ff ff       	jmp    80106ef7 <alltraps>

80107b74 <vector179>:
.globl vector179
vector179:
  pushl $0
80107b74:	6a 00                	push   $0x0
  pushl $179
80107b76:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107b7b:	e9 77 f3 ff ff       	jmp    80106ef7 <alltraps>

80107b80 <vector180>:
.globl vector180
vector180:
  pushl $0
80107b80:	6a 00                	push   $0x0
  pushl $180
80107b82:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107b87:	e9 6b f3 ff ff       	jmp    80106ef7 <alltraps>

80107b8c <vector181>:
.globl vector181
vector181:
  pushl $0
80107b8c:	6a 00                	push   $0x0
  pushl $181
80107b8e:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107b93:	e9 5f f3 ff ff       	jmp    80106ef7 <alltraps>

80107b98 <vector182>:
.globl vector182
vector182:
  pushl $0
80107b98:	6a 00                	push   $0x0
  pushl $182
80107b9a:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107b9f:	e9 53 f3 ff ff       	jmp    80106ef7 <alltraps>

80107ba4 <vector183>:
.globl vector183
vector183:
  pushl $0
80107ba4:	6a 00                	push   $0x0
  pushl $183
80107ba6:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107bab:	e9 47 f3 ff ff       	jmp    80106ef7 <alltraps>

80107bb0 <vector184>:
.globl vector184
vector184:
  pushl $0
80107bb0:	6a 00                	push   $0x0
  pushl $184
80107bb2:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107bb7:	e9 3b f3 ff ff       	jmp    80106ef7 <alltraps>

80107bbc <vector185>:
.globl vector185
vector185:
  pushl $0
80107bbc:	6a 00                	push   $0x0
  pushl $185
80107bbe:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107bc3:	e9 2f f3 ff ff       	jmp    80106ef7 <alltraps>

80107bc8 <vector186>:
.globl vector186
vector186:
  pushl $0
80107bc8:	6a 00                	push   $0x0
  pushl $186
80107bca:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107bcf:	e9 23 f3 ff ff       	jmp    80106ef7 <alltraps>

80107bd4 <vector187>:
.globl vector187
vector187:
  pushl $0
80107bd4:	6a 00                	push   $0x0
  pushl $187
80107bd6:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107bdb:	e9 17 f3 ff ff       	jmp    80106ef7 <alltraps>

80107be0 <vector188>:
.globl vector188
vector188:
  pushl $0
80107be0:	6a 00                	push   $0x0
  pushl $188
80107be2:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107be7:	e9 0b f3 ff ff       	jmp    80106ef7 <alltraps>

80107bec <vector189>:
.globl vector189
vector189:
  pushl $0
80107bec:	6a 00                	push   $0x0
  pushl $189
80107bee:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107bf3:	e9 ff f2 ff ff       	jmp    80106ef7 <alltraps>

80107bf8 <vector190>:
.globl vector190
vector190:
  pushl $0
80107bf8:	6a 00                	push   $0x0
  pushl $190
80107bfa:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107bff:	e9 f3 f2 ff ff       	jmp    80106ef7 <alltraps>

80107c04 <vector191>:
.globl vector191
vector191:
  pushl $0
80107c04:	6a 00                	push   $0x0
  pushl $191
80107c06:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107c0b:	e9 e7 f2 ff ff       	jmp    80106ef7 <alltraps>

80107c10 <vector192>:
.globl vector192
vector192:
  pushl $0
80107c10:	6a 00                	push   $0x0
  pushl $192
80107c12:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107c17:	e9 db f2 ff ff       	jmp    80106ef7 <alltraps>

80107c1c <vector193>:
.globl vector193
vector193:
  pushl $0
80107c1c:	6a 00                	push   $0x0
  pushl $193
80107c1e:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107c23:	e9 cf f2 ff ff       	jmp    80106ef7 <alltraps>

80107c28 <vector194>:
.globl vector194
vector194:
  pushl $0
80107c28:	6a 00                	push   $0x0
  pushl $194
80107c2a:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107c2f:	e9 c3 f2 ff ff       	jmp    80106ef7 <alltraps>

80107c34 <vector195>:
.globl vector195
vector195:
  pushl $0
80107c34:	6a 00                	push   $0x0
  pushl $195
80107c36:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107c3b:	e9 b7 f2 ff ff       	jmp    80106ef7 <alltraps>

80107c40 <vector196>:
.globl vector196
vector196:
  pushl $0
80107c40:	6a 00                	push   $0x0
  pushl $196
80107c42:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107c47:	e9 ab f2 ff ff       	jmp    80106ef7 <alltraps>

80107c4c <vector197>:
.globl vector197
vector197:
  pushl $0
80107c4c:	6a 00                	push   $0x0
  pushl $197
80107c4e:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107c53:	e9 9f f2 ff ff       	jmp    80106ef7 <alltraps>

80107c58 <vector198>:
.globl vector198
vector198:
  pushl $0
80107c58:	6a 00                	push   $0x0
  pushl $198
80107c5a:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107c5f:	e9 93 f2 ff ff       	jmp    80106ef7 <alltraps>

80107c64 <vector199>:
.globl vector199
vector199:
  pushl $0
80107c64:	6a 00                	push   $0x0
  pushl $199
80107c66:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107c6b:	e9 87 f2 ff ff       	jmp    80106ef7 <alltraps>

80107c70 <vector200>:
.globl vector200
vector200:
  pushl $0
80107c70:	6a 00                	push   $0x0
  pushl $200
80107c72:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107c77:	e9 7b f2 ff ff       	jmp    80106ef7 <alltraps>

80107c7c <vector201>:
.globl vector201
vector201:
  pushl $0
80107c7c:	6a 00                	push   $0x0
  pushl $201
80107c7e:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107c83:	e9 6f f2 ff ff       	jmp    80106ef7 <alltraps>

80107c88 <vector202>:
.globl vector202
vector202:
  pushl $0
80107c88:	6a 00                	push   $0x0
  pushl $202
80107c8a:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107c8f:	e9 63 f2 ff ff       	jmp    80106ef7 <alltraps>

80107c94 <vector203>:
.globl vector203
vector203:
  pushl $0
80107c94:	6a 00                	push   $0x0
  pushl $203
80107c96:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107c9b:	e9 57 f2 ff ff       	jmp    80106ef7 <alltraps>

80107ca0 <vector204>:
.globl vector204
vector204:
  pushl $0
80107ca0:	6a 00                	push   $0x0
  pushl $204
80107ca2:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107ca7:	e9 4b f2 ff ff       	jmp    80106ef7 <alltraps>

80107cac <vector205>:
.globl vector205
vector205:
  pushl $0
80107cac:	6a 00                	push   $0x0
  pushl $205
80107cae:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107cb3:	e9 3f f2 ff ff       	jmp    80106ef7 <alltraps>

80107cb8 <vector206>:
.globl vector206
vector206:
  pushl $0
80107cb8:	6a 00                	push   $0x0
  pushl $206
80107cba:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107cbf:	e9 33 f2 ff ff       	jmp    80106ef7 <alltraps>

80107cc4 <vector207>:
.globl vector207
vector207:
  pushl $0
80107cc4:	6a 00                	push   $0x0
  pushl $207
80107cc6:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107ccb:	e9 27 f2 ff ff       	jmp    80106ef7 <alltraps>

80107cd0 <vector208>:
.globl vector208
vector208:
  pushl $0
80107cd0:	6a 00                	push   $0x0
  pushl $208
80107cd2:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107cd7:	e9 1b f2 ff ff       	jmp    80106ef7 <alltraps>

80107cdc <vector209>:
.globl vector209
vector209:
  pushl $0
80107cdc:	6a 00                	push   $0x0
  pushl $209
80107cde:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107ce3:	e9 0f f2 ff ff       	jmp    80106ef7 <alltraps>

80107ce8 <vector210>:
.globl vector210
vector210:
  pushl $0
80107ce8:	6a 00                	push   $0x0
  pushl $210
80107cea:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107cef:	e9 03 f2 ff ff       	jmp    80106ef7 <alltraps>

80107cf4 <vector211>:
.globl vector211
vector211:
  pushl $0
80107cf4:	6a 00                	push   $0x0
  pushl $211
80107cf6:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107cfb:	e9 f7 f1 ff ff       	jmp    80106ef7 <alltraps>

80107d00 <vector212>:
.globl vector212
vector212:
  pushl $0
80107d00:	6a 00                	push   $0x0
  pushl $212
80107d02:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107d07:	e9 eb f1 ff ff       	jmp    80106ef7 <alltraps>

80107d0c <vector213>:
.globl vector213
vector213:
  pushl $0
80107d0c:	6a 00                	push   $0x0
  pushl $213
80107d0e:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107d13:	e9 df f1 ff ff       	jmp    80106ef7 <alltraps>

80107d18 <vector214>:
.globl vector214
vector214:
  pushl $0
80107d18:	6a 00                	push   $0x0
  pushl $214
80107d1a:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107d1f:	e9 d3 f1 ff ff       	jmp    80106ef7 <alltraps>

80107d24 <vector215>:
.globl vector215
vector215:
  pushl $0
80107d24:	6a 00                	push   $0x0
  pushl $215
80107d26:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107d2b:	e9 c7 f1 ff ff       	jmp    80106ef7 <alltraps>

80107d30 <vector216>:
.globl vector216
vector216:
  pushl $0
80107d30:	6a 00                	push   $0x0
  pushl $216
80107d32:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107d37:	e9 bb f1 ff ff       	jmp    80106ef7 <alltraps>

80107d3c <vector217>:
.globl vector217
vector217:
  pushl $0
80107d3c:	6a 00                	push   $0x0
  pushl $217
80107d3e:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107d43:	e9 af f1 ff ff       	jmp    80106ef7 <alltraps>

80107d48 <vector218>:
.globl vector218
vector218:
  pushl $0
80107d48:	6a 00                	push   $0x0
  pushl $218
80107d4a:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107d4f:	e9 a3 f1 ff ff       	jmp    80106ef7 <alltraps>

80107d54 <vector219>:
.globl vector219
vector219:
  pushl $0
80107d54:	6a 00                	push   $0x0
  pushl $219
80107d56:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107d5b:	e9 97 f1 ff ff       	jmp    80106ef7 <alltraps>

80107d60 <vector220>:
.globl vector220
vector220:
  pushl $0
80107d60:	6a 00                	push   $0x0
  pushl $220
80107d62:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107d67:	e9 8b f1 ff ff       	jmp    80106ef7 <alltraps>

80107d6c <vector221>:
.globl vector221
vector221:
  pushl $0
80107d6c:	6a 00                	push   $0x0
  pushl $221
80107d6e:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107d73:	e9 7f f1 ff ff       	jmp    80106ef7 <alltraps>

80107d78 <vector222>:
.globl vector222
vector222:
  pushl $0
80107d78:	6a 00                	push   $0x0
  pushl $222
80107d7a:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107d7f:	e9 73 f1 ff ff       	jmp    80106ef7 <alltraps>

80107d84 <vector223>:
.globl vector223
vector223:
  pushl $0
80107d84:	6a 00                	push   $0x0
  pushl $223
80107d86:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107d8b:	e9 67 f1 ff ff       	jmp    80106ef7 <alltraps>

80107d90 <vector224>:
.globl vector224
vector224:
  pushl $0
80107d90:	6a 00                	push   $0x0
  pushl $224
80107d92:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107d97:	e9 5b f1 ff ff       	jmp    80106ef7 <alltraps>

80107d9c <vector225>:
.globl vector225
vector225:
  pushl $0
80107d9c:	6a 00                	push   $0x0
  pushl $225
80107d9e:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107da3:	e9 4f f1 ff ff       	jmp    80106ef7 <alltraps>

80107da8 <vector226>:
.globl vector226
vector226:
  pushl $0
80107da8:	6a 00                	push   $0x0
  pushl $226
80107daa:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107daf:	e9 43 f1 ff ff       	jmp    80106ef7 <alltraps>

80107db4 <vector227>:
.globl vector227
vector227:
  pushl $0
80107db4:	6a 00                	push   $0x0
  pushl $227
80107db6:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107dbb:	e9 37 f1 ff ff       	jmp    80106ef7 <alltraps>

80107dc0 <vector228>:
.globl vector228
vector228:
  pushl $0
80107dc0:	6a 00                	push   $0x0
  pushl $228
80107dc2:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107dc7:	e9 2b f1 ff ff       	jmp    80106ef7 <alltraps>

80107dcc <vector229>:
.globl vector229
vector229:
  pushl $0
80107dcc:	6a 00                	push   $0x0
  pushl $229
80107dce:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107dd3:	e9 1f f1 ff ff       	jmp    80106ef7 <alltraps>

80107dd8 <vector230>:
.globl vector230
vector230:
  pushl $0
80107dd8:	6a 00                	push   $0x0
  pushl $230
80107dda:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107ddf:	e9 13 f1 ff ff       	jmp    80106ef7 <alltraps>

80107de4 <vector231>:
.globl vector231
vector231:
  pushl $0
80107de4:	6a 00                	push   $0x0
  pushl $231
80107de6:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107deb:	e9 07 f1 ff ff       	jmp    80106ef7 <alltraps>

80107df0 <vector232>:
.globl vector232
vector232:
  pushl $0
80107df0:	6a 00                	push   $0x0
  pushl $232
80107df2:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107df7:	e9 fb f0 ff ff       	jmp    80106ef7 <alltraps>

80107dfc <vector233>:
.globl vector233
vector233:
  pushl $0
80107dfc:	6a 00                	push   $0x0
  pushl $233
80107dfe:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107e03:	e9 ef f0 ff ff       	jmp    80106ef7 <alltraps>

80107e08 <vector234>:
.globl vector234
vector234:
  pushl $0
80107e08:	6a 00                	push   $0x0
  pushl $234
80107e0a:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107e0f:	e9 e3 f0 ff ff       	jmp    80106ef7 <alltraps>

80107e14 <vector235>:
.globl vector235
vector235:
  pushl $0
80107e14:	6a 00                	push   $0x0
  pushl $235
80107e16:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107e1b:	e9 d7 f0 ff ff       	jmp    80106ef7 <alltraps>

80107e20 <vector236>:
.globl vector236
vector236:
  pushl $0
80107e20:	6a 00                	push   $0x0
  pushl $236
80107e22:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107e27:	e9 cb f0 ff ff       	jmp    80106ef7 <alltraps>

80107e2c <vector237>:
.globl vector237
vector237:
  pushl $0
80107e2c:	6a 00                	push   $0x0
  pushl $237
80107e2e:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107e33:	e9 bf f0 ff ff       	jmp    80106ef7 <alltraps>

80107e38 <vector238>:
.globl vector238
vector238:
  pushl $0
80107e38:	6a 00                	push   $0x0
  pushl $238
80107e3a:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107e3f:	e9 b3 f0 ff ff       	jmp    80106ef7 <alltraps>

80107e44 <vector239>:
.globl vector239
vector239:
  pushl $0
80107e44:	6a 00                	push   $0x0
  pushl $239
80107e46:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107e4b:	e9 a7 f0 ff ff       	jmp    80106ef7 <alltraps>

80107e50 <vector240>:
.globl vector240
vector240:
  pushl $0
80107e50:	6a 00                	push   $0x0
  pushl $240
80107e52:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107e57:	e9 9b f0 ff ff       	jmp    80106ef7 <alltraps>

80107e5c <vector241>:
.globl vector241
vector241:
  pushl $0
80107e5c:	6a 00                	push   $0x0
  pushl $241
80107e5e:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107e63:	e9 8f f0 ff ff       	jmp    80106ef7 <alltraps>

80107e68 <vector242>:
.globl vector242
vector242:
  pushl $0
80107e68:	6a 00                	push   $0x0
  pushl $242
80107e6a:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107e6f:	e9 83 f0 ff ff       	jmp    80106ef7 <alltraps>

80107e74 <vector243>:
.globl vector243
vector243:
  pushl $0
80107e74:	6a 00                	push   $0x0
  pushl $243
80107e76:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107e7b:	e9 77 f0 ff ff       	jmp    80106ef7 <alltraps>

80107e80 <vector244>:
.globl vector244
vector244:
  pushl $0
80107e80:	6a 00                	push   $0x0
  pushl $244
80107e82:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107e87:	e9 6b f0 ff ff       	jmp    80106ef7 <alltraps>

80107e8c <vector245>:
.globl vector245
vector245:
  pushl $0
80107e8c:	6a 00                	push   $0x0
  pushl $245
80107e8e:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107e93:	e9 5f f0 ff ff       	jmp    80106ef7 <alltraps>

80107e98 <vector246>:
.globl vector246
vector246:
  pushl $0
80107e98:	6a 00                	push   $0x0
  pushl $246
80107e9a:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107e9f:	e9 53 f0 ff ff       	jmp    80106ef7 <alltraps>

80107ea4 <vector247>:
.globl vector247
vector247:
  pushl $0
80107ea4:	6a 00                	push   $0x0
  pushl $247
80107ea6:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107eab:	e9 47 f0 ff ff       	jmp    80106ef7 <alltraps>

80107eb0 <vector248>:
.globl vector248
vector248:
  pushl $0
80107eb0:	6a 00                	push   $0x0
  pushl $248
80107eb2:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107eb7:	e9 3b f0 ff ff       	jmp    80106ef7 <alltraps>

80107ebc <vector249>:
.globl vector249
vector249:
  pushl $0
80107ebc:	6a 00                	push   $0x0
  pushl $249
80107ebe:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107ec3:	e9 2f f0 ff ff       	jmp    80106ef7 <alltraps>

80107ec8 <vector250>:
.globl vector250
vector250:
  pushl $0
80107ec8:	6a 00                	push   $0x0
  pushl $250
80107eca:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107ecf:	e9 23 f0 ff ff       	jmp    80106ef7 <alltraps>

80107ed4 <vector251>:
.globl vector251
vector251:
  pushl $0
80107ed4:	6a 00                	push   $0x0
  pushl $251
80107ed6:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107edb:	e9 17 f0 ff ff       	jmp    80106ef7 <alltraps>

80107ee0 <vector252>:
.globl vector252
vector252:
  pushl $0
80107ee0:	6a 00                	push   $0x0
  pushl $252
80107ee2:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107ee7:	e9 0b f0 ff ff       	jmp    80106ef7 <alltraps>

80107eec <vector253>:
.globl vector253
vector253:
  pushl $0
80107eec:	6a 00                	push   $0x0
  pushl $253
80107eee:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107ef3:	e9 ff ef ff ff       	jmp    80106ef7 <alltraps>

80107ef8 <vector254>:
.globl vector254
vector254:
  pushl $0
80107ef8:	6a 00                	push   $0x0
  pushl $254
80107efa:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107eff:	e9 f3 ef ff ff       	jmp    80106ef7 <alltraps>

80107f04 <vector255>:
.globl vector255
vector255:
  pushl $0
80107f04:	6a 00                	push   $0x0
  pushl $255
80107f06:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107f0b:	e9 e7 ef ff ff       	jmp    80106ef7 <alltraps>

80107f10 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107f10:	55                   	push   %ebp
80107f11:	89 e5                	mov    %esp,%ebp
80107f13:	57                   	push   %edi
80107f14:	56                   	push   %esi
80107f15:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107f16:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80107f1c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107f22:	83 ec 1c             	sub    $0x1c,%esp
80107f25:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107f28:	39 d3                	cmp    %edx,%ebx
80107f2a:	73 49                	jae    80107f75 <deallocuvm.part.0+0x65>
80107f2c:	89 c7                	mov    %eax,%edi
80107f2e:	eb 0c                	jmp    80107f3c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107f30:	83 c0 01             	add    $0x1,%eax
80107f33:	c1 e0 16             	shl    $0x16,%eax
80107f36:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107f38:	39 da                	cmp    %ebx,%edx
80107f3a:	76 39                	jbe    80107f75 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80107f3c:	89 d8                	mov    %ebx,%eax
80107f3e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107f41:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80107f44:	f6 c1 01             	test   $0x1,%cl
80107f47:	74 e7                	je     80107f30 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80107f49:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107f4b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107f51:	c1 ee 0a             	shr    $0xa,%esi
80107f54:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80107f5a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80107f61:	85 f6                	test   %esi,%esi
80107f63:	74 cb                	je     80107f30 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80107f65:	8b 06                	mov    (%esi),%eax
80107f67:	a8 01                	test   $0x1,%al
80107f69:	75 15                	jne    80107f80 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80107f6b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107f71:	39 da                	cmp    %ebx,%edx
80107f73:	77 c7                	ja     80107f3c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107f75:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107f78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f7b:	5b                   	pop    %ebx
80107f7c:	5e                   	pop    %esi
80107f7d:	5f                   	pop    %edi
80107f7e:	5d                   	pop    %ebp
80107f7f:	c3                   	ret    
      if(pa == 0)
80107f80:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f85:	74 25                	je     80107fac <deallocuvm.part.0+0x9c>
      kfree(v);
80107f87:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80107f8a:	05 00 00 00 80       	add    $0x80000000,%eax
80107f8f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107f92:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80107f98:	50                   	push   %eax
80107f99:	e8 d2 ab ff ff       	call   80102b70 <kfree>
      *pte = 0;
80107f9e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80107fa4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107fa7:	83 c4 10             	add    $0x10,%esp
80107faa:	eb 8c                	jmp    80107f38 <deallocuvm.part.0+0x28>
        panic("kfree");
80107fac:	83 ec 0c             	sub    $0xc,%esp
80107faf:	68 e2 8c 10 80       	push   $0x80108ce2
80107fb4:	e8 c7 83 ff ff       	call   80100380 <panic>
80107fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107fc0 <mappages>:
{
80107fc0:	55                   	push   %ebp
80107fc1:	89 e5                	mov    %esp,%ebp
80107fc3:	57                   	push   %edi
80107fc4:	56                   	push   %esi
80107fc5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107fc6:	89 d3                	mov    %edx,%ebx
80107fc8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80107fce:	83 ec 1c             	sub    $0x1c,%esp
80107fd1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107fd4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107fd8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107fdd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107fe0:	8b 45 08             	mov    0x8(%ebp),%eax
80107fe3:	29 d8                	sub    %ebx,%eax
80107fe5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107fe8:	eb 3d                	jmp    80108027 <mappages+0x67>
80107fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107ff0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107ff2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107ff7:	c1 ea 0a             	shr    $0xa,%edx
80107ffa:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80108000:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108007:	85 c0                	test   %eax,%eax
80108009:	74 75                	je     80108080 <mappages+0xc0>
    if(*pte & PTE_P)
8010800b:	f6 00 01             	testb  $0x1,(%eax)
8010800e:	0f 85 86 00 00 00    	jne    8010809a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80108014:	0b 75 0c             	or     0xc(%ebp),%esi
80108017:	83 ce 01             	or     $0x1,%esi
8010801a:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010801c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
8010801f:	74 6f                	je     80108090 <mappages+0xd0>
    a += PGSIZE;
80108021:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80108027:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
8010802a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010802d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80108030:	89 d8                	mov    %ebx,%eax
80108032:	c1 e8 16             	shr    $0x16,%eax
80108035:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80108038:	8b 07                	mov    (%edi),%eax
8010803a:	a8 01                	test   $0x1,%al
8010803c:	75 b2                	jne    80107ff0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010803e:	e8 ed ac ff ff       	call   80102d30 <kalloc>
80108043:	85 c0                	test   %eax,%eax
80108045:	74 39                	je     80108080 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80108047:	83 ec 04             	sub    $0x4,%esp
8010804a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010804d:	68 00 10 00 00       	push   $0x1000
80108052:	6a 00                	push   $0x0
80108054:	50                   	push   %eax
80108055:	e8 36 d8 ff ff       	call   80105890 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010805a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
8010805d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80108060:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80108066:	83 c8 07             	or     $0x7,%eax
80108069:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010806b:	89 d8                	mov    %ebx,%eax
8010806d:	c1 e8 0a             	shr    $0xa,%eax
80108070:	25 fc 0f 00 00       	and    $0xffc,%eax
80108075:	01 d0                	add    %edx,%eax
80108077:	eb 92                	jmp    8010800b <mappages+0x4b>
80108079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80108080:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108083:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108088:	5b                   	pop    %ebx
80108089:	5e                   	pop    %esi
8010808a:	5f                   	pop    %edi
8010808b:	5d                   	pop    %ebp
8010808c:	c3                   	ret    
8010808d:	8d 76 00             	lea    0x0(%esi),%esi
80108090:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108093:	31 c0                	xor    %eax,%eax
}
80108095:	5b                   	pop    %ebx
80108096:	5e                   	pop    %esi
80108097:	5f                   	pop    %edi
80108098:	5d                   	pop    %ebp
80108099:	c3                   	ret    
      panic("remap");
8010809a:	83 ec 0c             	sub    $0xc,%esp
8010809d:	68 3c 94 10 80       	push   $0x8010943c
801080a2:	e8 d9 82 ff ff       	call   80100380 <panic>
801080a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801080ae:	66 90                	xchg   %ax,%ax

801080b0 <seginit>:
{
801080b0:	55                   	push   %ebp
801080b1:	89 e5                	mov    %esp,%ebp
801080b3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801080b6:	e8 b5 bf ff ff       	call   80104070 <cpuid>
  pd[0] = size-1;
801080bb:	ba 2f 00 00 00       	mov    $0x2f,%edx
801080c0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801080c6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801080ca:	c7 80 38 40 11 80 ff 	movl   $0xffff,-0x7feebfc8(%eax)
801080d1:	ff 00 00 
801080d4:	c7 80 3c 40 11 80 00 	movl   $0xcf9a00,-0x7feebfc4(%eax)
801080db:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801080de:	c7 80 40 40 11 80 ff 	movl   $0xffff,-0x7feebfc0(%eax)
801080e5:	ff 00 00 
801080e8:	c7 80 44 40 11 80 00 	movl   $0xcf9200,-0x7feebfbc(%eax)
801080ef:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801080f2:	c7 80 48 40 11 80 ff 	movl   $0xffff,-0x7feebfb8(%eax)
801080f9:	ff 00 00 
801080fc:	c7 80 4c 40 11 80 00 	movl   $0xcffa00,-0x7feebfb4(%eax)
80108103:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80108106:	c7 80 50 40 11 80 ff 	movl   $0xffff,-0x7feebfb0(%eax)
8010810d:	ff 00 00 
80108110:	c7 80 54 40 11 80 00 	movl   $0xcff200,-0x7feebfac(%eax)
80108117:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010811a:	05 30 40 11 80       	add    $0x80114030,%eax
  pd[1] = (uint)p;
8010811f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80108123:	c1 e8 10             	shr    $0x10,%eax
80108126:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010812a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010812d:	0f 01 10             	lgdtl  (%eax)
}
80108130:	c9                   	leave  
80108131:	c3                   	ret    
80108132:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108140 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108140:	a1 44 7a 13 80       	mov    0x80137a44,%eax
80108145:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010814a:	0f 22 d8             	mov    %eax,%cr3
}
8010814d:	c3                   	ret    
8010814e:	66 90                	xchg   %ax,%ax

80108150 <switchuvm>:
{
80108150:	55                   	push   %ebp
80108151:	89 e5                	mov    %esp,%ebp
80108153:	57                   	push   %edi
80108154:	56                   	push   %esi
80108155:	53                   	push   %ebx
80108156:	83 ec 1c             	sub    $0x1c,%esp
80108159:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010815c:	85 f6                	test   %esi,%esi
8010815e:	0f 84 cb 00 00 00    	je     8010822f <switchuvm+0xdf>
  if(p->kstack == 0)
80108164:	8b 46 08             	mov    0x8(%esi),%eax
80108167:	85 c0                	test   %eax,%eax
80108169:	0f 84 da 00 00 00    	je     80108249 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010816f:	8b 46 04             	mov    0x4(%esi),%eax
80108172:	85 c0                	test   %eax,%eax
80108174:	0f 84 c2 00 00 00    	je     8010823c <switchuvm+0xec>
  pushcli();
8010817a:	e8 01 d5 ff ff       	call   80105680 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010817f:	e8 8c be ff ff       	call   80104010 <mycpu>
80108184:	89 c3                	mov    %eax,%ebx
80108186:	e8 85 be ff ff       	call   80104010 <mycpu>
8010818b:	89 c7                	mov    %eax,%edi
8010818d:	e8 7e be ff ff       	call   80104010 <mycpu>
80108192:	83 c7 08             	add    $0x8,%edi
80108195:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108198:	e8 73 be ff ff       	call   80104010 <mycpu>
8010819d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801081a0:	ba 67 00 00 00       	mov    $0x67,%edx
801081a5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801081ac:	83 c0 08             	add    $0x8,%eax
801081af:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801081b6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801081bb:	83 c1 08             	add    $0x8,%ecx
801081be:	c1 e8 18             	shr    $0x18,%eax
801081c1:	c1 e9 10             	shr    $0x10,%ecx
801081c4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801081ca:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801081d0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801081d5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801081dc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801081e1:	e8 2a be ff ff       	call   80104010 <mycpu>
801081e6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801081ed:	e8 1e be ff ff       	call   80104010 <mycpu>
801081f2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801081f6:	8b 5e 08             	mov    0x8(%esi),%ebx
801081f9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801081ff:	e8 0c be ff ff       	call   80104010 <mycpu>
80108204:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80108207:	e8 04 be ff ff       	call   80104010 <mycpu>
8010820c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80108210:	b8 28 00 00 00       	mov    $0x28,%eax
80108215:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80108218:	8b 46 04             	mov    0x4(%esi),%eax
8010821b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108220:	0f 22 d8             	mov    %eax,%cr3
}
80108223:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108226:	5b                   	pop    %ebx
80108227:	5e                   	pop    %esi
80108228:	5f                   	pop    %edi
80108229:	5d                   	pop    %ebp
  popcli();
8010822a:	e9 a1 d4 ff ff       	jmp    801056d0 <popcli>
    panic("switchuvm: no process");
8010822f:	83 ec 0c             	sub    $0xc,%esp
80108232:	68 42 94 10 80       	push   $0x80109442
80108237:	e8 44 81 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
8010823c:	83 ec 0c             	sub    $0xc,%esp
8010823f:	68 6d 94 10 80       	push   $0x8010946d
80108244:	e8 37 81 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80108249:	83 ec 0c             	sub    $0xc,%esp
8010824c:	68 58 94 10 80       	push   $0x80109458
80108251:	e8 2a 81 ff ff       	call   80100380 <panic>
80108256:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010825d:	8d 76 00             	lea    0x0(%esi),%esi

80108260 <inituvm>:
{
80108260:	55                   	push   %ebp
80108261:	89 e5                	mov    %esp,%ebp
80108263:	57                   	push   %edi
80108264:	56                   	push   %esi
80108265:	53                   	push   %ebx
80108266:	83 ec 1c             	sub    $0x1c,%esp
80108269:	8b 45 0c             	mov    0xc(%ebp),%eax
8010826c:	8b 75 10             	mov    0x10(%ebp),%esi
8010826f:	8b 7d 08             	mov    0x8(%ebp),%edi
80108272:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80108275:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010827b:	77 4b                	ja     801082c8 <inituvm+0x68>
  mem = kalloc();
8010827d:	e8 ae aa ff ff       	call   80102d30 <kalloc>
  memset(mem, 0, PGSIZE);
80108282:	83 ec 04             	sub    $0x4,%esp
80108285:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010828a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010828c:	6a 00                	push   $0x0
8010828e:	50                   	push   %eax
8010828f:	e8 fc d5 ff ff       	call   80105890 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80108294:	58                   	pop    %eax
80108295:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010829b:	5a                   	pop    %edx
8010829c:	6a 06                	push   $0x6
8010829e:	b9 00 10 00 00       	mov    $0x1000,%ecx
801082a3:	31 d2                	xor    %edx,%edx
801082a5:	50                   	push   %eax
801082a6:	89 f8                	mov    %edi,%eax
801082a8:	e8 13 fd ff ff       	call   80107fc0 <mappages>
  memmove(mem, init, sz);
801082ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801082b0:	89 75 10             	mov    %esi,0x10(%ebp)
801082b3:	83 c4 10             	add    $0x10,%esp
801082b6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801082b9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801082bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801082bf:	5b                   	pop    %ebx
801082c0:	5e                   	pop    %esi
801082c1:	5f                   	pop    %edi
801082c2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801082c3:	e9 68 d6 ff ff       	jmp    80105930 <memmove>
    panic("inituvm: more than a page");
801082c8:	83 ec 0c             	sub    $0xc,%esp
801082cb:	68 81 94 10 80       	push   $0x80109481
801082d0:	e8 ab 80 ff ff       	call   80100380 <panic>
801082d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801082dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801082e0 <loaduvm>:
{
801082e0:	55                   	push   %ebp
801082e1:	89 e5                	mov    %esp,%ebp
801082e3:	57                   	push   %edi
801082e4:	56                   	push   %esi
801082e5:	53                   	push   %ebx
801082e6:	83 ec 1c             	sub    $0x1c,%esp
801082e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801082ec:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
801082ef:	a9 ff 0f 00 00       	test   $0xfff,%eax
801082f4:	0f 85 bb 00 00 00    	jne    801083b5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
801082fa:	01 f0                	add    %esi,%eax
801082fc:	89 f3                	mov    %esi,%ebx
801082fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108301:	8b 45 14             	mov    0x14(%ebp),%eax
80108304:	01 f0                	add    %esi,%eax
80108306:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80108309:	85 f6                	test   %esi,%esi
8010830b:	0f 84 87 00 00 00    	je     80108398 <loaduvm+0xb8>
80108311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80108318:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
8010831b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010831e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80108320:	89 c2                	mov    %eax,%edx
80108322:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80108325:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80108328:	f6 c2 01             	test   $0x1,%dl
8010832b:	75 13                	jne    80108340 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010832d:	83 ec 0c             	sub    $0xc,%esp
80108330:	68 9b 94 10 80       	push   $0x8010949b
80108335:	e8 46 80 ff ff       	call   80100380 <panic>
8010833a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80108340:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108343:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80108349:	25 fc 0f 00 00       	and    $0xffc,%eax
8010834e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108355:	85 c0                	test   %eax,%eax
80108357:	74 d4                	je     8010832d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80108359:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010835b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010835e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80108363:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80108368:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010836e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108371:	29 d9                	sub    %ebx,%ecx
80108373:	05 00 00 00 80       	add    $0x80000000,%eax
80108378:	57                   	push   %edi
80108379:	51                   	push   %ecx
8010837a:	50                   	push   %eax
8010837b:	ff 75 10             	push   0x10(%ebp)
8010837e:	e8 dd 9c ff ff       	call   80102060 <readi>
80108383:	83 c4 10             	add    $0x10,%esp
80108386:	39 f8                	cmp    %edi,%eax
80108388:	75 1e                	jne    801083a8 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010838a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80108390:	89 f0                	mov    %esi,%eax
80108392:	29 d8                	sub    %ebx,%eax
80108394:	39 c6                	cmp    %eax,%esi
80108396:	77 80                	ja     80108318 <loaduvm+0x38>
}
80108398:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010839b:	31 c0                	xor    %eax,%eax
}
8010839d:	5b                   	pop    %ebx
8010839e:	5e                   	pop    %esi
8010839f:	5f                   	pop    %edi
801083a0:	5d                   	pop    %ebp
801083a1:	c3                   	ret    
801083a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801083a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801083ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801083b0:	5b                   	pop    %ebx
801083b1:	5e                   	pop    %esi
801083b2:	5f                   	pop    %edi
801083b3:	5d                   	pop    %ebp
801083b4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
801083b5:	83 ec 0c             	sub    $0xc,%esp
801083b8:	68 3c 95 10 80       	push   $0x8010953c
801083bd:	e8 be 7f ff ff       	call   80100380 <panic>
801083c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801083c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801083d0 <allocuvm>:
{
801083d0:	55                   	push   %ebp
801083d1:	89 e5                	mov    %esp,%ebp
801083d3:	57                   	push   %edi
801083d4:	56                   	push   %esi
801083d5:	53                   	push   %ebx
801083d6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801083d9:	8b 45 10             	mov    0x10(%ebp),%eax
{
801083dc:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801083df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801083e2:	85 c0                	test   %eax,%eax
801083e4:	0f 88 b6 00 00 00    	js     801084a0 <allocuvm+0xd0>
  if(newsz < oldsz)
801083ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801083ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801083f0:	0f 82 9a 00 00 00    	jb     80108490 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801083f6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801083fc:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80108402:	39 75 10             	cmp    %esi,0x10(%ebp)
80108405:	77 44                	ja     8010844b <allocuvm+0x7b>
80108407:	e9 87 00 00 00       	jmp    80108493 <allocuvm+0xc3>
8010840c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80108410:	83 ec 04             	sub    $0x4,%esp
80108413:	68 00 10 00 00       	push   $0x1000
80108418:	6a 00                	push   $0x0
8010841a:	50                   	push   %eax
8010841b:	e8 70 d4 ff ff       	call   80105890 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80108420:	58                   	pop    %eax
80108421:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80108427:	5a                   	pop    %edx
80108428:	6a 06                	push   $0x6
8010842a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010842f:	89 f2                	mov    %esi,%edx
80108431:	50                   	push   %eax
80108432:	89 f8                	mov    %edi,%eax
80108434:	e8 87 fb ff ff       	call   80107fc0 <mappages>
80108439:	83 c4 10             	add    $0x10,%esp
8010843c:	85 c0                	test   %eax,%eax
8010843e:	78 78                	js     801084b8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80108440:	81 c6 00 10 00 00    	add    $0x1000,%esi
80108446:	39 75 10             	cmp    %esi,0x10(%ebp)
80108449:	76 48                	jbe    80108493 <allocuvm+0xc3>
    mem = kalloc();
8010844b:	e8 e0 a8 ff ff       	call   80102d30 <kalloc>
80108450:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80108452:	85 c0                	test   %eax,%eax
80108454:	75 ba                	jne    80108410 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80108456:	83 ec 0c             	sub    $0xc,%esp
80108459:	68 b9 94 10 80       	push   $0x801094b9
8010845e:	e8 3d 82 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80108463:	8b 45 0c             	mov    0xc(%ebp),%eax
80108466:	83 c4 10             	add    $0x10,%esp
80108469:	39 45 10             	cmp    %eax,0x10(%ebp)
8010846c:	74 32                	je     801084a0 <allocuvm+0xd0>
8010846e:	8b 55 10             	mov    0x10(%ebp),%edx
80108471:	89 c1                	mov    %eax,%ecx
80108473:	89 f8                	mov    %edi,%eax
80108475:	e8 96 fa ff ff       	call   80107f10 <deallocuvm.part.0>
      return 0;
8010847a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80108481:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108484:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108487:	5b                   	pop    %ebx
80108488:	5e                   	pop    %esi
80108489:	5f                   	pop    %edi
8010848a:	5d                   	pop    %ebp
8010848b:	c3                   	ret    
8010848c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80108490:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80108493:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108496:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108499:	5b                   	pop    %ebx
8010849a:	5e                   	pop    %esi
8010849b:	5f                   	pop    %edi
8010849c:	5d                   	pop    %ebp
8010849d:	c3                   	ret    
8010849e:	66 90                	xchg   %ax,%ax
    return 0;
801084a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801084a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801084aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801084ad:	5b                   	pop    %ebx
801084ae:	5e                   	pop    %esi
801084af:	5f                   	pop    %edi
801084b0:	5d                   	pop    %ebp
801084b1:	c3                   	ret    
801084b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801084b8:	83 ec 0c             	sub    $0xc,%esp
801084bb:	68 d1 94 10 80       	push   $0x801094d1
801084c0:	e8 db 81 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801084c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801084c8:	83 c4 10             	add    $0x10,%esp
801084cb:	39 45 10             	cmp    %eax,0x10(%ebp)
801084ce:	74 0c                	je     801084dc <allocuvm+0x10c>
801084d0:	8b 55 10             	mov    0x10(%ebp),%edx
801084d3:	89 c1                	mov    %eax,%ecx
801084d5:	89 f8                	mov    %edi,%eax
801084d7:	e8 34 fa ff ff       	call   80107f10 <deallocuvm.part.0>
      kfree(mem);
801084dc:	83 ec 0c             	sub    $0xc,%esp
801084df:	53                   	push   %ebx
801084e0:	e8 8b a6 ff ff       	call   80102b70 <kfree>
      return 0;
801084e5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801084ec:	83 c4 10             	add    $0x10,%esp
}
801084ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801084f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801084f5:	5b                   	pop    %ebx
801084f6:	5e                   	pop    %esi
801084f7:	5f                   	pop    %edi
801084f8:	5d                   	pop    %ebp
801084f9:	c3                   	ret    
801084fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108500 <deallocuvm>:
{
80108500:	55                   	push   %ebp
80108501:	89 e5                	mov    %esp,%ebp
80108503:	8b 55 0c             	mov    0xc(%ebp),%edx
80108506:	8b 4d 10             	mov    0x10(%ebp),%ecx
80108509:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010850c:	39 d1                	cmp    %edx,%ecx
8010850e:	73 10                	jae    80108520 <deallocuvm+0x20>
}
80108510:	5d                   	pop    %ebp
80108511:	e9 fa f9 ff ff       	jmp    80107f10 <deallocuvm.part.0>
80108516:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010851d:	8d 76 00             	lea    0x0(%esi),%esi
80108520:	89 d0                	mov    %edx,%eax
80108522:	5d                   	pop    %ebp
80108523:	c3                   	ret    
80108524:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010852b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010852f:	90                   	nop

80108530 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108530:	55                   	push   %ebp
80108531:	89 e5                	mov    %esp,%ebp
80108533:	57                   	push   %edi
80108534:	56                   	push   %esi
80108535:	53                   	push   %ebx
80108536:	83 ec 0c             	sub    $0xc,%esp
80108539:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010853c:	85 f6                	test   %esi,%esi
8010853e:	74 59                	je     80108599 <freevm+0x69>
  if(newsz >= oldsz)
80108540:	31 c9                	xor    %ecx,%ecx
80108542:	ba 00 00 00 80       	mov    $0x80000000,%edx
80108547:	89 f0                	mov    %esi,%eax
80108549:	89 f3                	mov    %esi,%ebx
8010854b:	e8 c0 f9 ff ff       	call   80107f10 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108550:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80108556:	eb 0f                	jmp    80108567 <freevm+0x37>
80108558:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010855f:	90                   	nop
80108560:	83 c3 04             	add    $0x4,%ebx
80108563:	39 df                	cmp    %ebx,%edi
80108565:	74 23                	je     8010858a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80108567:	8b 03                	mov    (%ebx),%eax
80108569:	a8 01                	test   $0x1,%al
8010856b:	74 f3                	je     80108560 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010856d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80108572:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108575:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108578:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010857d:	50                   	push   %eax
8010857e:	e8 ed a5 ff ff       	call   80102b70 <kfree>
80108583:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108586:	39 df                	cmp    %ebx,%edi
80108588:	75 dd                	jne    80108567 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010858a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010858d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108590:	5b                   	pop    %ebx
80108591:	5e                   	pop    %esi
80108592:	5f                   	pop    %edi
80108593:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80108594:	e9 d7 a5 ff ff       	jmp    80102b70 <kfree>
    panic("freevm: no pgdir");
80108599:	83 ec 0c             	sub    $0xc,%esp
8010859c:	68 ed 94 10 80       	push   $0x801094ed
801085a1:	e8 da 7d ff ff       	call   80100380 <panic>
801085a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801085ad:	8d 76 00             	lea    0x0(%esi),%esi

801085b0 <setupkvm>:
{
801085b0:	55                   	push   %ebp
801085b1:	89 e5                	mov    %esp,%ebp
801085b3:	56                   	push   %esi
801085b4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801085b5:	e8 76 a7 ff ff       	call   80102d30 <kalloc>
801085ba:	89 c6                	mov    %eax,%esi
801085bc:	85 c0                	test   %eax,%eax
801085be:	74 42                	je     80108602 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801085c0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801085c3:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
801085c8:	68 00 10 00 00       	push   $0x1000
801085cd:	6a 00                	push   $0x0
801085cf:	50                   	push   %eax
801085d0:	e8 bb d2 ff ff       	call   80105890 <memset>
801085d5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801085d8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801085db:	83 ec 08             	sub    $0x8,%esp
801085de:	8b 4b 08             	mov    0x8(%ebx),%ecx
801085e1:	ff 73 0c             	push   0xc(%ebx)
801085e4:	8b 13                	mov    (%ebx),%edx
801085e6:	50                   	push   %eax
801085e7:	29 c1                	sub    %eax,%ecx
801085e9:	89 f0                	mov    %esi,%eax
801085eb:	e8 d0 f9 ff ff       	call   80107fc0 <mappages>
801085f0:	83 c4 10             	add    $0x10,%esp
801085f3:	85 c0                	test   %eax,%eax
801085f5:	78 19                	js     80108610 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801085f7:	83 c3 10             	add    $0x10,%ebx
801085fa:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80108600:	75 d6                	jne    801085d8 <setupkvm+0x28>
}
80108602:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108605:	89 f0                	mov    %esi,%eax
80108607:	5b                   	pop    %ebx
80108608:	5e                   	pop    %esi
80108609:	5d                   	pop    %ebp
8010860a:	c3                   	ret    
8010860b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010860f:	90                   	nop
      freevm(pgdir);
80108610:	83 ec 0c             	sub    $0xc,%esp
80108613:	56                   	push   %esi
      return 0;
80108614:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80108616:	e8 15 ff ff ff       	call   80108530 <freevm>
      return 0;
8010861b:	83 c4 10             	add    $0x10,%esp
}
8010861e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108621:	89 f0                	mov    %esi,%eax
80108623:	5b                   	pop    %ebx
80108624:	5e                   	pop    %esi
80108625:	5d                   	pop    %ebp
80108626:	c3                   	ret    
80108627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010862e:	66 90                	xchg   %ax,%ax

80108630 <kvmalloc>:
{
80108630:	55                   	push   %ebp
80108631:	89 e5                	mov    %esp,%ebp
80108633:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108636:	e8 75 ff ff ff       	call   801085b0 <setupkvm>
8010863b:	a3 44 7a 13 80       	mov    %eax,0x80137a44
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108640:	05 00 00 00 80       	add    $0x80000000,%eax
80108645:	0f 22 d8             	mov    %eax,%cr3
}
80108648:	c9                   	leave  
80108649:	c3                   	ret    
8010864a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108650 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108650:	55                   	push   %ebp
80108651:	89 e5                	mov    %esp,%ebp
80108653:	83 ec 08             	sub    $0x8,%esp
80108656:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80108659:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010865c:	89 c1                	mov    %eax,%ecx
8010865e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80108661:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80108664:	f6 c2 01             	test   $0x1,%dl
80108667:	75 17                	jne    80108680 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80108669:	83 ec 0c             	sub    $0xc,%esp
8010866c:	68 fe 94 10 80       	push   $0x801094fe
80108671:	e8 0a 7d ff ff       	call   80100380 <panic>
80108676:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010867d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80108680:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108683:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80108689:	25 fc 0f 00 00       	and    $0xffc,%eax
8010868e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80108695:	85 c0                	test   %eax,%eax
80108697:	74 d0                	je     80108669 <clearpteu+0x19>
  *pte &= ~PTE_U;
80108699:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010869c:	c9                   	leave  
8010869d:	c3                   	ret    
8010869e:	66 90                	xchg   %ax,%ax

801086a0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801086a0:	55                   	push   %ebp
801086a1:	89 e5                	mov    %esp,%ebp
801086a3:	57                   	push   %edi
801086a4:	56                   	push   %esi
801086a5:	53                   	push   %ebx
801086a6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801086a9:	e8 02 ff ff ff       	call   801085b0 <setupkvm>
801086ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
801086b1:	85 c0                	test   %eax,%eax
801086b3:	0f 84 bd 00 00 00    	je     80108776 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801086b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801086bc:	85 c9                	test   %ecx,%ecx
801086be:	0f 84 b2 00 00 00    	je     80108776 <copyuvm+0xd6>
801086c4:	31 f6                	xor    %esi,%esi
801086c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801086cd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801086d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801086d3:	89 f0                	mov    %esi,%eax
801086d5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801086d8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801086db:	a8 01                	test   $0x1,%al
801086dd:	75 11                	jne    801086f0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801086df:	83 ec 0c             	sub    $0xc,%esp
801086e2:	68 08 95 10 80       	push   $0x80109508
801086e7:	e8 94 7c ff ff       	call   80100380 <panic>
801086ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801086f0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801086f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801086f7:	c1 ea 0a             	shr    $0xa,%edx
801086fa:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80108700:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108707:	85 c0                	test   %eax,%eax
80108709:	74 d4                	je     801086df <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010870b:	8b 00                	mov    (%eax),%eax
8010870d:	a8 01                	test   $0x1,%al
8010870f:	0f 84 9f 00 00 00    	je     801087b4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80108715:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80108717:	25 ff 0f 00 00       	and    $0xfff,%eax
8010871c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010871f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80108725:	e8 06 a6 ff ff       	call   80102d30 <kalloc>
8010872a:	89 c3                	mov    %eax,%ebx
8010872c:	85 c0                	test   %eax,%eax
8010872e:	74 64                	je     80108794 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108730:	83 ec 04             	sub    $0x4,%esp
80108733:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80108739:	68 00 10 00 00       	push   $0x1000
8010873e:	57                   	push   %edi
8010873f:	50                   	push   %eax
80108740:	e8 eb d1 ff ff       	call   80105930 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108745:	58                   	pop    %eax
80108746:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010874c:	5a                   	pop    %edx
8010874d:	ff 75 e4             	push   -0x1c(%ebp)
80108750:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108755:	89 f2                	mov    %esi,%edx
80108757:	50                   	push   %eax
80108758:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010875b:	e8 60 f8 ff ff       	call   80107fc0 <mappages>
80108760:	83 c4 10             	add    $0x10,%esp
80108763:	85 c0                	test   %eax,%eax
80108765:	78 21                	js     80108788 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80108767:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010876d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80108770:	0f 87 5a ff ff ff    	ja     801086d0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80108776:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108779:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010877c:	5b                   	pop    %ebx
8010877d:	5e                   	pop    %esi
8010877e:	5f                   	pop    %edi
8010877f:	5d                   	pop    %ebp
80108780:	c3                   	ret    
80108781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80108788:	83 ec 0c             	sub    $0xc,%esp
8010878b:	53                   	push   %ebx
8010878c:	e8 df a3 ff ff       	call   80102b70 <kfree>
      goto bad;
80108791:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80108794:	83 ec 0c             	sub    $0xc,%esp
80108797:	ff 75 e0             	push   -0x20(%ebp)
8010879a:	e8 91 fd ff ff       	call   80108530 <freevm>
  return 0;
8010879f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801087a6:	83 c4 10             	add    $0x10,%esp
}
801087a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801087ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801087af:	5b                   	pop    %ebx
801087b0:	5e                   	pop    %esi
801087b1:	5f                   	pop    %edi
801087b2:	5d                   	pop    %ebp
801087b3:	c3                   	ret    
      panic("copyuvm: page not present");
801087b4:	83 ec 0c             	sub    $0xc,%esp
801087b7:	68 22 95 10 80       	push   $0x80109522
801087bc:	e8 bf 7b ff ff       	call   80100380 <panic>
801087c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801087c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801087cf:	90                   	nop

801087d0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801087d0:	55                   	push   %ebp
801087d1:	89 e5                	mov    %esp,%ebp
801087d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801087d6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801087d9:	89 c1                	mov    %eax,%ecx
801087db:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801087de:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801087e1:	f6 c2 01             	test   $0x1,%dl
801087e4:	0f 84 00 01 00 00    	je     801088ea <uva2ka.cold>
  return &pgtab[PTX(va)];
801087ea:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801087ed:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801087f3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801087f4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801087f9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80108800:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108802:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80108807:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010880a:	05 00 00 00 80       	add    $0x80000000,%eax
8010880f:	83 fa 05             	cmp    $0x5,%edx
80108812:	ba 00 00 00 00       	mov    $0x0,%edx
80108817:	0f 45 c2             	cmovne %edx,%eax
}
8010881a:	c3                   	ret    
8010881b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010881f:	90                   	nop

80108820 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108820:	55                   	push   %ebp
80108821:	89 e5                	mov    %esp,%ebp
80108823:	57                   	push   %edi
80108824:	56                   	push   %esi
80108825:	53                   	push   %ebx
80108826:	83 ec 0c             	sub    $0xc,%esp
80108829:	8b 75 14             	mov    0x14(%ebp),%esi
8010882c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010882f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108832:	85 f6                	test   %esi,%esi
80108834:	75 51                	jne    80108887 <copyout+0x67>
80108836:	e9 a5 00 00 00       	jmp    801088e0 <copyout+0xc0>
8010883b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010883f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80108840:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80108846:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010884c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80108852:	74 75                	je     801088c9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80108854:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80108856:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80108859:	29 c3                	sub    %eax,%ebx
8010885b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108861:	39 f3                	cmp    %esi,%ebx
80108863:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80108866:	29 f8                	sub    %edi,%eax
80108868:	83 ec 04             	sub    $0x4,%esp
8010886b:	01 c1                	add    %eax,%ecx
8010886d:	53                   	push   %ebx
8010886e:	52                   	push   %edx
8010886f:	51                   	push   %ecx
80108870:	e8 bb d0 ff ff       	call   80105930 <memmove>
    len -= n;
    buf += n;
80108875:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80108878:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010887e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80108881:	01 da                	add    %ebx,%edx
  while(len > 0){
80108883:	29 de                	sub    %ebx,%esi
80108885:	74 59                	je     801088e0 <copyout+0xc0>
  if(*pde & PTE_P){
80108887:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010888a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010888c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010888e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80108891:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80108897:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010889a:	f6 c1 01             	test   $0x1,%cl
8010889d:	0f 84 4e 00 00 00    	je     801088f1 <copyout.cold>
  return &pgtab[PTX(va)];
801088a3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801088a5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801088ab:	c1 eb 0c             	shr    $0xc,%ebx
801088ae:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801088b4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801088bb:	89 d9                	mov    %ebx,%ecx
801088bd:	83 e1 05             	and    $0x5,%ecx
801088c0:	83 f9 05             	cmp    $0x5,%ecx
801088c3:	0f 84 77 ff ff ff    	je     80108840 <copyout+0x20>
  }
  return 0;
}
801088c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801088cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801088d1:	5b                   	pop    %ebx
801088d2:	5e                   	pop    %esi
801088d3:	5f                   	pop    %edi
801088d4:	5d                   	pop    %ebp
801088d5:	c3                   	ret    
801088d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801088dd:	8d 76 00             	lea    0x0(%esi),%esi
801088e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801088e3:	31 c0                	xor    %eax,%eax
}
801088e5:	5b                   	pop    %ebx
801088e6:	5e                   	pop    %esi
801088e7:	5f                   	pop    %edi
801088e8:	5d                   	pop    %ebp
801088e9:	c3                   	ret    

801088ea <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801088ea:	a1 00 00 00 00       	mov    0x0,%eax
801088ef:	0f 0b                	ud2    

801088f1 <copyout.cold>:
801088f1:	a1 00 00 00 00       	mov    0x0,%eax
801088f6:	0f 0b                	ud2    
801088f8:	66 90                	xchg   %ax,%ax
801088fa:	66 90                	xchg   %ax,%ax
801088fc:	66 90                	xchg   %ax,%ax
801088fe:	66 90                	xchg   %ax,%ax

80108900 <sys_find_largest_prime_factor>:

    if (n > 4) return n;
    return largest;
}

int sys_find_largest_prime_factor(void) {
80108900:	55                   	push   %ebp
80108901:	89 e5                	mov    %esp,%ebp
80108903:	57                   	push   %edi
80108904:	56                   	push   %esi
80108905:	53                   	push   %ebx
80108906:	83 ec 0c             	sub    $0xc,%esp
    return largest_prime_factor(myproc()->tf->ebx);
80108909:	e8 82 b7 ff ff       	call   80104090 <myproc>
8010890e:	8b 40 18             	mov    0x18(%eax),%eax
80108911:	8b 48 10             	mov    0x10(%eax),%ecx
    if (n <= 1) return -1;
80108914:	83 f9 01             	cmp    $0x1,%ecx
80108917:	0f 8e dd 00 00 00    	jle    801089fa <sys_find_largest_prime_factor+0xfa>
    if (n % 2 == 0) {
8010891d:	f6 c1 01             	test   $0x1,%cl
80108920:	75 15                	jne    80108937 <sys_find_largest_prime_factor+0x37>
80108922:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        do { n /= 2; } while (n % 2 == 0);
80108928:	89 c8                	mov    %ecx,%eax
8010892a:	c1 e8 1f             	shr    $0x1f,%eax
8010892d:	01 c8                	add    %ecx,%eax
8010892f:	89 c1                	mov    %eax,%ecx
80108931:	d1 f9                	sar    %ecx
80108933:	a8 02                	test   $0x2,%al
80108935:	74 f1                	je     80108928 <sys_find_largest_prime_factor+0x28>
    if (n % 3 == 0) {
80108937:	69 c1 ab aa aa aa    	imul   $0xaaaaaaab,%ecx,%eax
        do { n /= 3; } while (n % 3 == 0);
8010893d:	bb 56 55 55 55       	mov    $0x55555556,%ebx
80108942:	05 aa aa aa 2a       	add    $0x2aaaaaaa,%eax
    if (n % 3 == 0) {
80108947:	3d 54 55 55 55       	cmp    $0x55555554,%eax
8010894c:	76 22                	jbe    80108970 <sys_find_largest_prime_factor+0x70>
8010894e:	bf 02 00 00 00       	mov    $0x2,%edi
    for (int i = 5; i * i <= n; i += 6) {
80108953:	bb 05 00 00 00       	mov    $0x5,%ebx
80108958:	83 f9 18             	cmp    $0x18,%ecx
8010895b:	7f 5b                	jg     801089b8 <sys_find_largest_prime_factor+0xb8>
8010895d:	8d 76 00             	lea    0x0(%esi),%esi
    if (n > 4) return n;
80108960:	83 f9 05             	cmp    $0x5,%ecx
80108963:	0f 4d f9             	cmovge %ecx,%edi
}
80108966:	83 c4 0c             	add    $0xc,%esp
80108969:	89 f8                	mov    %edi,%eax
8010896b:	5b                   	pop    %ebx
8010896c:	5e                   	pop    %esi
8010896d:	5f                   	pop    %edi
8010896e:	5d                   	pop    %ebp
8010896f:	c3                   	ret    
        do { n /= 3; } while (n % 3 == 0);
80108970:	89 c8                	mov    %ecx,%eax
80108972:	f7 eb                	imul   %ebx
80108974:	89 c8                	mov    %ecx,%eax
80108976:	c1 f8 1f             	sar    $0x1f,%eax
80108979:	29 c2                	sub    %eax,%edx
8010897b:	69 c2 ab aa aa aa    	imul   $0xaaaaaaab,%edx,%eax
80108981:	89 d1                	mov    %edx,%ecx
80108983:	05 aa aa aa 2a       	add    $0x2aaaaaaa,%eax
80108988:	3d 54 55 55 55       	cmp    $0x55555554,%eax
8010898d:	76 e1                	jbe    80108970 <sys_find_largest_prime_factor+0x70>
        largest = 3;
8010898f:	bf 03 00 00 00       	mov    $0x3,%edi
    for (int i = 5; i * i <= n; i += 6) {
80108994:	bb 05 00 00 00       	mov    $0x5,%ebx
80108999:	83 f9 18             	cmp    $0x18,%ecx
8010899c:	7f 1a                	jg     801089b8 <sys_find_largest_prime_factor+0xb8>
8010899e:	eb c0                	jmp    80108960 <sys_find_largest_prime_factor+0x60>
        if (n % (i + 2) == 0) {
801089a0:	89 c8                	mov    %ecx,%eax
801089a2:	8d 73 02             	lea    0x2(%ebx),%esi
801089a5:	99                   	cltd   
801089a6:	f7 fe                	idiv   %esi
801089a8:	85 d2                	test   %edx,%edx
801089aa:	74 3c                	je     801089e8 <sys_find_largest_prime_factor+0xe8>
    for (int i = 5; i * i <= n; i += 6) {
801089ac:	83 c3 06             	add    $0x6,%ebx
801089af:	89 d8                	mov    %ebx,%eax
801089b1:	0f af c3             	imul   %ebx,%eax
801089b4:	39 c8                	cmp    %ecx,%eax
801089b6:	7f a8                	jg     80108960 <sys_find_largest_prime_factor+0x60>
        if (n % i == 0) {
801089b8:	89 c8                	mov    %ecx,%eax
801089ba:	99                   	cltd   
801089bb:	f7 fb                	idiv   %ebx
801089bd:	85 d2                	test   %edx,%edx
801089bf:	75 df                	jne    801089a0 <sys_find_largest_prime_factor+0xa0>
801089c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            do { n /= i; } while (n % i == 0);
801089c8:	89 c8                	mov    %ecx,%eax
801089ca:	99                   	cltd   
801089cb:	f7 fb                	idiv   %ebx
801089cd:	99                   	cltd   
801089ce:	89 c1                	mov    %eax,%ecx
801089d0:	f7 fb                	idiv   %ebx
801089d2:	85 d2                	test   %edx,%edx
801089d4:	74 f2                	je     801089c8 <sys_find_largest_prime_factor+0xc8>
        if (n % (i + 2) == 0) {
801089d6:	89 c8                	mov    %ecx,%eax
801089d8:	8d 73 02             	lea    0x2(%ebx),%esi
801089db:	89 df                	mov    %ebx,%edi
801089dd:	99                   	cltd   
801089de:	f7 fe                	idiv   %esi
801089e0:	85 d2                	test   %edx,%edx
801089e2:	75 c8                	jne    801089ac <sys_find_largest_prime_factor+0xac>
801089e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            do { n /= i + 2; } while (n % (i + 2) == 0);
801089e8:	89 c8                	mov    %ecx,%eax
801089ea:	99                   	cltd   
801089eb:	f7 fe                	idiv   %esi
801089ed:	99                   	cltd   
801089ee:	89 c1                	mov    %eax,%ecx
801089f0:	f7 fe                	idiv   %esi
801089f2:	85 d2                	test   %edx,%edx
801089f4:	74 f2                	je     801089e8 <sys_find_largest_prime_factor+0xe8>
            largest = i + 2;
801089f6:	89 f7                	mov    %esi,%edi
801089f8:	eb b2                	jmp    801089ac <sys_find_largest_prime_factor+0xac>
    if (n <= 1) return -1;
801089fa:	bf ff ff ff ff       	mov    $0xffffffff,%edi
    return largest_prime_factor(myproc()->tf->ebx);
801089ff:	e9 62 ff ff ff       	jmp    80108966 <sys_find_largest_prime_factor+0x66>
