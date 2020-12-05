
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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
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
80100028:	bc 40 c6 10 80       	mov    $0x8010c640,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 c0 30 10 80       	mov    $0x801030c0,%eax
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
80100044:	bb 74 c6 10 80       	mov    $0x8010c674,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 e0 77 10 80       	push   $0x801077e0
80100051:	68 40 c6 10 80       	push   $0x8010c640
80100056:	e8 95 47 00 00       	call   801047f0 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 8c 0d 11 80 3c 	movl   $0x80110d3c,0x80110d8c
80100062:	0d 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 90 0d 11 80 3c 	movl   $0x80110d3c,0x80110d90
8010006c:	0d 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba 3c 0d 11 80       	mov    $0x80110d3c,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 3c 0d 11 80 	movl   $0x80110d3c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 e7 77 10 80       	push   $0x801077e7
80100097:	50                   	push   %eax
80100098:	e8 23 46 00 00       	call   801046c0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 90 0d 11 80       	mov    0x80110d90,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 90 0d 11 80    	mov    %ebx,0x80110d90
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d 3c 0d 11 80       	cmp    $0x80110d3c,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

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
801000df:	68 40 c6 10 80       	push   $0x8010c640
801000e4:	e8 47 48 00 00       	call   80104930 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 90 0d 11 80    	mov    0x80110d90,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 3c 0d 11 80    	cmp    $0x80110d3c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 3c 0d 11 80    	cmp    $0x80110d3c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 8c 0d 11 80    	mov    0x80110d8c,%ebx
80100126:	81 fb 3c 0d 11 80    	cmp    $0x80110d3c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 3c 0d 11 80    	cmp    $0x80110d3c,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
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
8010015d:	68 40 c6 10 80       	push   $0x8010c640
80100162:	e8 89 48 00 00       	call   801049f0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 8e 45 00 00       	call   80104700 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 bd 21 00 00       	call   80102340 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ee 77 10 80       	push   $0x801077ee
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 ed 45 00 00       	call   801047a0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 77 21 00 00       	jmp    80102340 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 ff 77 10 80       	push   $0x801077ff
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 ac 45 00 00       	call   801047a0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 5c 45 00 00       	call   80104760 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
8010020b:	e8 20 47 00 00       	call   80104930 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 90 0d 11 80       	mov    0x80110d90,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 3c 0d 11 80 	movl   $0x80110d3c,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 90 0d 11 80       	mov    0x80110d90,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 90 0d 11 80    	mov    %ebx,0x80110d90
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 40 c6 10 80 	movl   $0x8010c640,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 8f 47 00 00       	jmp    801049f0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 06 78 10 80       	push   $0x80107806
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 fb 16 00 00       	call   80101980 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
8010028c:	e8 9f 46 00 00       	call   80104930 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 20 10 11 80    	mov    0x80111020,%edx
801002a7:	39 15 24 10 11 80    	cmp    %edx,0x80111024
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 a0 b5 10 80       	push   $0x8010b5a0
801002c0:	68 20 10 11 80       	push   $0x80111020
801002c5:	e8 86 40 00 00       	call   80104350 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 20 10 11 80    	mov    0x80111020,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 24 10 11 80    	cmp    0x80111024,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 30 3a 00 00       	call   80103d10 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 a0 b5 10 80       	push   $0x8010b5a0
801002ef:	e8 fc 46 00 00       	call   801049f0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 a4 15 00 00       	call   801018a0 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 20 10 11 80       	mov    %eax,0x80111020
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 a0 0f 11 80 	movsbl -0x7feef060(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 a0 b5 10 80       	push   $0x8010b5a0
8010034d:	e8 9e 46 00 00       	call   801049f0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 46 15 00 00       	call   801018a0 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 20 10 11 80    	mov    %edx,0x80111020
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 d4 b5 10 80 00 	movl   $0x0,0x8010b5d4
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 a2 25 00 00       	call   80102950 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 0d 78 10 80       	push   $0x8010780d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 0f 82 10 80 	movl   $0x8010820f,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 33 44 00 00       	call   80104810 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 21 78 10 80       	push   $0x80107821
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 d8 b5 10 80 01 	movl   $0x1,0x8010b5d8
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d d8 b5 10 80    	mov    0x8010b5d8,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 b1 5f 00 00       	call   801063f0 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 ff 5e 00 00       	call   801063f0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 f3 5e 00 00       	call   801063f0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 e7 5e 00 00       	call   801063f0 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 c7 45 00 00       	call   80104af0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 fa 44 00 00       	call   80104a40 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 25 78 10 80       	push   $0x80107825
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 50 78 10 80 	movzbl -0x7fef87b0(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0){
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 6c 13 00 00       	call   80101980 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
8010061b:	e8 10 43 00 00       	call   80104930 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 a0 b5 10 80       	push   $0x8010b5a0
80100647:	e8 a4 43 00 00       	call   801049f0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 4b 12 00 00       	call   801018a0 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 d4 b5 10 80       	mov    0x8010b5d4,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 a0 b5 10 80       	push   $0x8010b5a0
8010071f:	e8 cc 42 00 00       	call   801049f0 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba 38 78 10 80       	mov    $0x80107838,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 a0 b5 10 80       	push   $0x8010b5a0
801007f0:	e8 3b 41 00 00       	call   80104930 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 3f 78 10 80       	push   $0x8010783f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
80100816:	83 ec 28             	sub    $0x28,%esp
80100819:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010081c:	68 a0 b5 10 80       	push   $0x8010b5a0
80100821:	e8 0a 41 00 00       	call   80104930 <acquire>
  while((c = getc()) >= 0){
80100826:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
80100829:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((c = getc()) >= 0){
80100830:	ff d7                	call   *%edi
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c3                	mov    %eax,%ebx
80100836:	78 70                	js     801008a8 <consoleintr+0x98>
    switch(c){
80100838:	83 fb 10             	cmp    $0x10,%ebx
8010083b:	0f 84 ef 02 00 00    	je     80100b30 <consoleintr+0x320>
80100841:	0f 8e 89 00 00 00    	jle    801008d0 <consoleintr+0xc0>
80100847:	83 fb 16             	cmp    $0x16,%ebx
8010084a:	0f 84 80 01 00 00    	je     801009d0 <consoleintr+0x1c0>
80100850:	0f 8f 0a 01 00 00    	jg     80100960 <consoleintr+0x150>
80100856:	83 fb 15             	cmp    $0x15,%ebx
80100859:	0f 85 8c 00 00 00    	jne    801008eb <consoleintr+0xdb>
      while(input.e != input.w &&
8010085f:	a1 28 10 11 80       	mov    0x80111028,%eax
80100864:	39 05 24 10 11 80    	cmp    %eax,0x80111024
8010086a:	74 c4                	je     80100830 <consoleintr+0x20>
8010086c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100870:	83 e8 01             	sub    $0x1,%eax
80100873:	89 c2                	mov    %eax,%edx
80100875:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100878:	80 ba a0 0f 11 80 0a 	cmpb   $0xa,-0x7feef060(%edx)
8010087f:	74 af                	je     80100830 <consoleintr+0x20>
        input.e--;
80100881:	a3 28 10 11 80       	mov    %eax,0x80111028
        consputc(BACKSPACE);
80100886:	b8 00 01 00 00       	mov    $0x100,%eax
8010088b:	e8 80 fb ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
80100890:	a1 28 10 11 80       	mov    0x80111028,%eax
80100895:	3b 05 24 10 11 80    	cmp    0x80111024,%eax
8010089b:	75 d3                	jne    80100870 <consoleintr+0x60>
  while((c = getc()) >= 0){
8010089d:	ff d7                	call   *%edi
8010089f:	85 c0                	test   %eax,%eax
801008a1:	89 c3                	mov    %eax,%ebx
801008a3:	79 93                	jns    80100838 <consoleintr+0x28>
801008a5:	8d 76 00             	lea    0x0(%esi),%esi
  release(&cons.lock);
801008a8:	83 ec 0c             	sub    $0xc,%esp
801008ab:	68 a0 b5 10 80       	push   $0x8010b5a0
801008b0:	e8 3b 41 00 00       	call   801049f0 <release>
  if(doprocdump) {
801008b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801008b8:	83 c4 10             	add    $0x10,%esp
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 85 7d 02 00 00    	jne    80100b40 <consoleintr+0x330>
}
801008c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801008c6:	5b                   	pop    %ebx
801008c7:	5e                   	pop    %esi
801008c8:	5f                   	pop    %edi
801008c9:	5d                   	pop    %ebp
801008ca:	c3                   	ret    
801008cb:	90                   	nop
801008cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
801008d0:	83 fb 03             	cmp    $0x3,%ebx
801008d3:	0f 84 a7 01 00 00    	je     80100a80 <consoleintr+0x270>
801008d9:	83 fb 08             	cmp    $0x8,%ebx
801008dc:	0f 84 90 00 00 00    	je     80100972 <consoleintr+0x162>
801008e2:	83 fb 02             	cmp    $0x2,%ebx
801008e5:	0f 84 65 02 00 00    	je     80100b50 <consoleintr+0x340>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008eb:	85 db                	test   %ebx,%ebx
801008ed:	0f 84 3d ff ff ff    	je     80100830 <consoleintr+0x20>
801008f3:	a1 28 10 11 80       	mov    0x80111028,%eax
801008f8:	89 c2                	mov    %eax,%edx
801008fa:	2b 15 20 10 11 80    	sub    0x80111020,%edx
80100900:	83 fa 7f             	cmp    $0x7f,%edx
80100903:	0f 87 27 ff ff ff    	ja     80100830 <consoleintr+0x20>
80100909:	8d 50 01             	lea    0x1(%eax),%edx
8010090c:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
8010090f:	83 fb 0d             	cmp    $0xd,%ebx
        input.buf[input.e++ % INPUT_BUF] = c;
80100912:	89 15 28 10 11 80    	mov    %edx,0x80111028
        c = (c == '\r') ? '\n' : c;
80100918:	0f 84 48 02 00 00    	je     80100b66 <consoleintr+0x356>
        input.buf[input.e++ % INPUT_BUF] = c;
8010091e:	88 98 a0 0f 11 80    	mov    %bl,-0x7feef060(%eax)
        consputc(c);
80100924:	89 d8                	mov    %ebx,%eax
80100926:	e8 e5 fa ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010092b:	83 fb 0a             	cmp    $0xa,%ebx
8010092e:	0f 84 2a 01 00 00    	je     80100a5e <consoleintr+0x24e>
80100934:	83 fb 04             	cmp    $0x4,%ebx
80100937:	0f 84 21 01 00 00    	je     80100a5e <consoleintr+0x24e>
8010093d:	a1 20 10 11 80       	mov    0x80111020,%eax
80100942:	83 e8 80             	sub    $0xffffff80,%eax
80100945:	39 05 28 10 11 80    	cmp    %eax,0x80111028
8010094b:	0f 85 df fe ff ff    	jne    80100830 <consoleintr+0x20>
80100951:	e9 0d 01 00 00       	jmp    80100a63 <consoleintr+0x253>
80100956:	8d 76 00             	lea    0x0(%esi),%esi
80100959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    switch(c){
80100960:	83 fb 18             	cmp    $0x18,%ebx
80100963:	0f 84 17 01 00 00    	je     80100a80 <consoleintr+0x270>
80100969:	83 fb 7f             	cmp    $0x7f,%ebx
8010096c:	0f 85 79 ff ff ff    	jne    801008eb <consoleintr+0xdb>
      if(input.e != input.w){
80100972:	a1 28 10 11 80       	mov    0x80111028,%eax
80100977:	3b 05 24 10 11 80    	cmp    0x80111024,%eax
8010097d:	0f 84 ad fe ff ff    	je     80100830 <consoleintr+0x20>
        input.e--;
80100983:	83 e8 01             	sub    $0x1,%eax
80100986:	a3 28 10 11 80       	mov    %eax,0x80111028
        consputc(BACKSPACE);
8010098b:	b8 00 01 00 00       	mov    $0x100,%eax
80100990:	e8 7b fa ff ff       	call   80100410 <consputc>
80100995:	e9 96 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010099a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
801009a0:	a3 28 10 11 80       	mov    %eax,0x80111028
        consputc(BACKSPACE);
801009a5:	b8 00 01 00 00       	mov    $0x100,%eax
801009aa:	e8 61 fa ff ff       	call   80100410 <consputc>
        while(input.e != input.w &&
801009af:	a1 28 10 11 80       	mov    0x80111028,%eax
801009b4:	3b 05 24 10 11 80    	cmp    0x80111024,%eax
801009ba:	74 14                	je     801009d0 <consoleintr+0x1c0>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801009bc:	83 e8 01             	sub    $0x1,%eax
801009bf:	89 c2                	mov    %eax,%edx
801009c1:	83 e2 7f             	and    $0x7f,%edx
        while(input.e != input.w &&
801009c4:	80 ba a0 0f 11 80 0a 	cmpb   $0xa,-0x7feef060(%edx)
801009cb:	75 d3                	jne    801009a0 <consoleintr+0x190>
801009cd:	8d 76 00             	lea    0x0(%esi),%esi
      for (int i = 0; i < saved_buffer_size; i++)
801009d0:	8b 15 80 b5 10 80    	mov    0x8010b580,%edx
801009d6:	31 db                	xor    %ebx,%ebx
801009d8:	85 d2                	test   %edx,%edx
801009da:	7f 40                	jg     80100a1c <consoleintr+0x20c>
801009dc:	e9 4f fe ff ff       	jmp    80100830 <consoleintr+0x20>
801009e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
          input.buf[input.e++ % INPUT_BUF] = c;
801009e8:	88 82 a0 0f 11 80    	mov    %al,-0x7feef060(%edx)
          consputc(c);
801009ee:	e8 1d fa ff ff       	call   80100410 <consputc>
          if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF)
801009f3:	83 fe 0a             	cmp    $0xa,%esi
801009f6:	74 66                	je     80100a5e <consoleintr+0x24e>
801009f8:	83 fe 04             	cmp    $0x4,%esi
801009fb:	74 61                	je     80100a5e <consoleintr+0x24e>
801009fd:	a1 20 10 11 80       	mov    0x80111020,%eax
80100a02:	83 e8 80             	sub    $0xffffff80,%eax
80100a05:	39 05 28 10 11 80    	cmp    %eax,0x80111028
80100a0b:	74 56                	je     80100a63 <consoleintr+0x253>
      for (int i = 0; i < saved_buffer_size; i++)
80100a0d:	83 c3 01             	add    $0x1,%ebx
80100a10:	39 1d 80 b5 10 80    	cmp    %ebx,0x8010b580
80100a16:	0f 8e 14 fe ff ff    	jle    80100830 <consoleintr+0x20>
        c = saved_buf[i];
80100a1c:	0f be b3 40 10 11 80 	movsbl -0x7feeefc0(%ebx),%esi
        if(c != 0 && input.e-input.r < INPUT_BUF)
80100a23:	85 f6                	test   %esi,%esi
        c = saved_buf[i];
80100a25:	89 f0                	mov    %esi,%eax
        if(c != 0 && input.e-input.r < INPUT_BUF)
80100a27:	74 e4                	je     80100a0d <consoleintr+0x1fd>
80100a29:	8b 15 28 10 11 80    	mov    0x80111028,%edx
80100a2f:	89 d1                	mov    %edx,%ecx
80100a31:	2b 0d 20 10 11 80    	sub    0x80111020,%ecx
80100a37:	83 f9 7f             	cmp    $0x7f,%ecx
80100a3a:	77 d1                	ja     80100a0d <consoleintr+0x1fd>
80100a3c:	8d 4a 01             	lea    0x1(%edx),%ecx
80100a3f:	83 e2 7f             	and    $0x7f,%edx
          c = (c == '\r') ? '\n' : c;
80100a42:	83 fe 0d             	cmp    $0xd,%esi
          input.buf[input.e++ % INPUT_BUF] = c;
80100a45:	89 0d 28 10 11 80    	mov    %ecx,0x80111028
          c = (c == '\r') ? '\n' : c;
80100a4b:	75 9b                	jne    801009e8 <consoleintr+0x1d8>
          consputc(c);
80100a4d:	b8 0a 00 00 00       	mov    $0xa,%eax
          input.buf[input.e++ % INPUT_BUF] = c;
80100a52:	c6 82 a0 0f 11 80 0a 	movb   $0xa,-0x7feef060(%edx)
          consputc(c);
80100a59:	e8 b2 f9 ff ff       	call   80100410 <consputc>
80100a5e:	a1 28 10 11 80       	mov    0x80111028,%eax
          wakeup(&input.r);
80100a63:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a66:	a3 24 10 11 80       	mov    %eax,0x80111024
          wakeup(&input.r);
80100a6b:	68 20 10 11 80       	push   $0x80111020
80100a70:	e8 9b 3a 00 00       	call   80104510 <wakeup>
80100a75:	83 c4 10             	add    $0x10,%esp
80100a78:	e9 b3 fd ff ff       	jmp    80100830 <consoleintr+0x20>
80100a7d:	8d 76 00             	lea    0x0(%esi),%esi
      for (int i = 0; i < input.e - input.r ; i++)
80100a80:	a1 20 10 11 80       	mov    0x80111020,%eax
80100a85:	8b 15 28 10 11 80    	mov    0x80111028,%edx
        saved_buf[i] = input.buf[(input.r + i ) % INPUT_BUF];
80100a8b:	89 c6                	mov    %eax,%esi
      for (int i = 0; i < input.e - input.r ; i++)
80100a8d:	89 d1                	mov    %edx,%ecx
        saved_buf[i] = input.buf[(input.r + i ) % INPUT_BUF];
80100a8f:	f7 de                	neg    %esi
      for (int i = 0; i < input.e - input.r ; i++)
80100a91:	29 c1                	sub    %eax,%ecx
80100a93:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100a96:	0f 84 e4 00 00 00    	je     80100b80 <consoleintr+0x370>
80100a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        saved_buf[i] = input.buf[(input.r + i ) % INPUT_BUF];
80100aa0:	89 c1                	mov    %eax,%ecx
80100aa2:	83 e1 7f             	and    $0x7f,%ecx
80100aa5:	0f b6 89 a0 0f 11 80 	movzbl -0x7feef060(%ecx),%ecx
80100aac:	88 8c 06 40 10 11 80 	mov    %cl,-0x7feeefc0(%esi,%eax,1)
80100ab3:	83 c0 01             	add    $0x1,%eax
      for (int i = 0; i < input.e - input.r ; i++)
80100ab6:	39 c2                	cmp    %eax,%edx
80100ab8:	75 e6                	jne    80100aa0 <consoleintr+0x290>
80100aba:	8b 45 e0             	mov    -0x20(%ebp),%eax
      if (c == C('X'))
80100abd:	83 fb 18             	cmp    $0x18,%ebx
      saved_buffer_size = input.e - input.r;
80100ac0:	a3 80 b5 10 80       	mov    %eax,0x8010b580
      if (c == C('X'))
80100ac5:	0f 85 65 fd ff ff    	jne    80100830 <consoleintr+0x20>
        while(input.e != input.w &&
80100acb:	3b 15 24 10 11 80    	cmp    0x80111024,%edx
80100ad1:	0f 84 59 fd ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100ad7:	83 ea 01             	sub    $0x1,%edx
80100ada:	89 d0                	mov    %edx,%eax
80100adc:	83 e0 7f             	and    $0x7f,%eax
        while(input.e != input.w &&
80100adf:	80 b8 a0 0f 11 80 0a 	cmpb   $0xa,-0x7feef060(%eax)
80100ae6:	75 1d                	jne    80100b05 <consoleintr+0x2f5>
80100ae8:	e9 43 fd ff ff       	jmp    80100830 <consoleintr+0x20>
80100aed:	8d 76 00             	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100af0:	8d 50 ff             	lea    -0x1(%eax),%edx
80100af3:	89 d0                	mov    %edx,%eax
80100af5:	83 e0 7f             	and    $0x7f,%eax
        while(input.e != input.w &&
80100af8:	80 b8 a0 0f 11 80 0a 	cmpb   $0xa,-0x7feef060(%eax)
80100aff:	0f 84 2b fd ff ff    	je     80100830 <consoleintr+0x20>
        consputc(BACKSPACE);
80100b05:	b8 00 01 00 00       	mov    $0x100,%eax
        input.e--;
80100b0a:	89 15 28 10 11 80    	mov    %edx,0x80111028
        consputc(BACKSPACE);
80100b10:	e8 fb f8 ff ff       	call   80100410 <consputc>
        while(input.e != input.w &&
80100b15:	a1 28 10 11 80       	mov    0x80111028,%eax
80100b1a:	3b 05 24 10 11 80    	cmp    0x80111024,%eax
80100b20:	75 ce                	jne    80100af0 <consoleintr+0x2e0>
80100b22:	e9 09 fd ff ff       	jmp    80100830 <consoleintr+0x20>
80100b27:	89 f6                	mov    %esi,%esi
80100b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      doprocdump = 1;
80100b30:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
80100b37:	e9 f4 fc ff ff       	jmp    80100830 <consoleintr+0x20>
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80100b40:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b43:	5b                   	pop    %ebx
80100b44:	5e                   	pop    %esi
80100b45:	5f                   	pop    %edi
80100b46:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100b47:	e9 a4 3a 00 00       	jmp    801045f0 <procdump>
80100b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        while(input.e != input.w &&
80100b50:	a1 28 10 11 80       	mov    0x80111028,%eax
80100b55:	3b 05 24 10 11 80    	cmp    0x80111024,%eax
80100b5b:	0f 85 5b fe ff ff    	jne    801009bc <consoleintr+0x1ac>
80100b61:	e9 6a fe ff ff       	jmp    801009d0 <consoleintr+0x1c0>
        input.buf[input.e++ % INPUT_BUF] = c;
80100b66:	c6 80 a0 0f 11 80 0a 	movb   $0xa,-0x7feef060(%eax)
        consputc(c);
80100b6d:	b8 0a 00 00 00       	mov    $0xa,%eax
80100b72:	e8 99 f8 ff ff       	call   80100410 <consputc>
80100b77:	e9 e2 fe ff ff       	jmp    80100a5e <consoleintr+0x24e>
80100b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for (int i = 0; i < input.e - input.r ; i++)
80100b80:	31 c0                	xor    %eax,%eax
80100b82:	e9 36 ff ff ff       	jmp    80100abd <consoleintr+0x2ad>
80100b87:	89 f6                	mov    %esi,%esi
80100b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100b90 <consoleinit>:

void
consoleinit(void)
{
80100b90:	55                   	push   %ebp
80100b91:	89 e5                	mov    %esp,%ebp
80100b93:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100b96:	68 48 78 10 80       	push   $0x80107848
80100b9b:	68 a0 b5 10 80       	push   $0x8010b5a0
80100ba0:	e8 4b 3c 00 00       	call   801047f0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100ba5:	58                   	pop    %eax
80100ba6:	5a                   	pop    %edx
80100ba7:	6a 00                	push   $0x0
80100ba9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100bab:	c7 05 6c 1a 11 80 00 	movl   $0x80100600,0x80111a6c
80100bb2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100bb5:	c7 05 68 1a 11 80 70 	movl   $0x80100270,0x80111a68
80100bbc:	02 10 80 
  cons.locking = 1;
80100bbf:	c7 05 d4 b5 10 80 01 	movl   $0x1,0x8010b5d4
80100bc6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100bc9:	e8 22 19 00 00       	call   801024f0 <ioapicenable>
}
80100bce:	83 c4 10             	add    $0x10,%esp
80100bd1:	c9                   	leave  
80100bd2:	c3                   	ret    
80100bd3:	66 90                	xchg   %ax,%ax
80100bd5:	66 90                	xchg   %ax,%ax
80100bd7:	66 90                	xchg   %ax,%ax
80100bd9:	66 90                	xchg   %ax,%ax
80100bdb:	66 90                	xchg   %ax,%ax
80100bdd:	66 90                	xchg   %ax,%ax
80100bdf:	90                   	nop

80100be0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100be0:	55                   	push   %ebp
80100be1:	89 e5                	mov    %esp,%ebp
80100be3:	57                   	push   %edi
80100be4:	56                   	push   %esi
80100be5:	53                   	push   %ebx
80100be6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100bec:	e8 1f 31 00 00       	call   80103d10 <myproc>
80100bf1:	89 c6                	mov    %eax,%esi

  begin_op();
80100bf3:	e8 c8 21 00 00       	call   80102dc0 <begin_op>

  change_sched_queue(curproc->pid, LOTTERY);
80100bf8:	83 ec 08             	sub    $0x8,%esp
80100bfb:	6a 02                	push   $0x2
80100bfd:	ff 76 10             	pushl  0x10(%esi)
80100c00:	e8 6b 2f 00 00       	call   80103b70 <change_sched_queue>
  set_ticket(curproc->tickets, 1000);
80100c05:	59                   	pop    %ecx
80100c06:	5b                   	pop    %ebx
80100c07:	68 e8 03 00 00       	push   $0x3e8
80100c0c:	ff b6 dc 00 00 00    	pushl  0xdc(%esi)
80100c12:	e8 89 2f 00 00       	call   80103ba0 <set_ticket>

  if((ip = namei(path)) == 0){
80100c17:	5f                   	pop    %edi
80100c18:	ff 75 08             	pushl  0x8(%ebp)
80100c1b:	e8 e0 14 00 00       	call   80102100 <namei>
80100c20:	83 c4 10             	add    $0x10,%esp
80100c23:	85 c0                	test   %eax,%eax
80100c25:	0f 84 b1 01 00 00    	je     80100ddc <exec+0x1fc>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100c2b:	83 ec 0c             	sub    $0xc,%esp
80100c2e:	89 c3                	mov    %eax,%ebx
80100c30:	50                   	push   %eax
80100c31:	e8 6a 0c 00 00       	call   801018a0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100c36:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100c3c:	6a 34                	push   $0x34
80100c3e:	6a 00                	push   $0x0
80100c40:	50                   	push   %eax
80100c41:	53                   	push   %ebx
80100c42:	e8 39 0f 00 00       	call   80101b80 <readi>
80100c47:	83 c4 20             	add    $0x20,%esp
80100c4a:	83 f8 34             	cmp    $0x34,%eax
80100c4d:	74 21                	je     80100c70 <exec+0x90>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100c4f:	83 ec 0c             	sub    $0xc,%esp
80100c52:	53                   	push   %ebx
80100c53:	e8 d8 0e 00 00       	call   80101b30 <iunlockput>
    end_op();
80100c58:	e8 d3 21 00 00       	call   80102e30 <end_op>
80100c5d:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100c60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100c65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c68:	5b                   	pop    %ebx
80100c69:	5e                   	pop    %esi
80100c6a:	5f                   	pop    %edi
80100c6b:	5d                   	pop    %ebp
80100c6c:	c3                   	ret    
80100c6d:	8d 76 00             	lea    0x0(%esi),%esi
  if(elf.magic != ELF_MAGIC)
80100c70:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100c77:	45 4c 46 
80100c7a:	75 d3                	jne    80100c4f <exec+0x6f>
  if((pgdir = setupkvm()) == 0)
80100c7c:	e8 bf 68 00 00       	call   80107540 <setupkvm>
80100c81:	85 c0                	test   %eax,%eax
80100c83:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100c89:	74 c4                	je     80100c4f <exec+0x6f>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c8b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100c92:	00 
80100c93:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100c99:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100c9f:	0f 84 b6 02 00 00    	je     80100f5b <exec+0x37b>
  sz = 0;
80100ca5:	31 c0                	xor    %eax,%eax
80100ca7:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100cad:	31 ff                	xor    %edi,%edi
80100caf:	89 c6                	mov    %eax,%esi
80100cb1:	eb 7f                	jmp    80100d32 <exec+0x152>
80100cb3:	90                   	nop
80100cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100cb8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100cbf:	75 63                	jne    80100d24 <exec+0x144>
    if(ph.memsz < ph.filesz)
80100cc1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100cc7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ccd:	0f 82 86 00 00 00    	jb     80100d59 <exec+0x179>
80100cd3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100cd9:	72 7e                	jb     80100d59 <exec+0x179>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100cdb:	83 ec 04             	sub    $0x4,%esp
80100cde:	50                   	push   %eax
80100cdf:	56                   	push   %esi
80100ce0:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce6:	e8 75 66 00 00       	call   80107360 <allocuvm>
80100ceb:	83 c4 10             	add    $0x10,%esp
80100cee:	85 c0                	test   %eax,%eax
80100cf0:	89 c6                	mov    %eax,%esi
80100cf2:	74 65                	je     80100d59 <exec+0x179>
    if(ph.vaddr % PGSIZE != 0)
80100cf4:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100cfa:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100cff:	75 58                	jne    80100d59 <exec+0x179>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100d01:	83 ec 0c             	sub    $0xc,%esp
80100d04:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100d0a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100d10:	53                   	push   %ebx
80100d11:	50                   	push   %eax
80100d12:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d18:	e8 83 65 00 00       	call   801072a0 <loaduvm>
80100d1d:	83 c4 20             	add    $0x20,%esp
80100d20:	85 c0                	test   %eax,%eax
80100d22:	78 35                	js     80100d59 <exec+0x179>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d24:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100d2b:	83 c7 01             	add    $0x1,%edi
80100d2e:	39 f8                	cmp    %edi,%eax
80100d30:	7e 3d                	jle    80100d6f <exec+0x18f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100d32:	89 f8                	mov    %edi,%eax
80100d34:	6a 20                	push   $0x20
80100d36:	c1 e0 05             	shl    $0x5,%eax
80100d39:	03 85 f0 fe ff ff    	add    -0x110(%ebp),%eax
80100d3f:	50                   	push   %eax
80100d40:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100d46:	50                   	push   %eax
80100d47:	53                   	push   %ebx
80100d48:	e8 33 0e 00 00       	call   80101b80 <readi>
80100d4d:	83 c4 10             	add    $0x10,%esp
80100d50:	83 f8 20             	cmp    $0x20,%eax
80100d53:	0f 84 5f ff ff ff    	je     80100cb8 <exec+0xd8>
    freevm(pgdir);
80100d59:	83 ec 0c             	sub    $0xc,%esp
80100d5c:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d62:	e8 59 67 00 00       	call   801074c0 <freevm>
80100d67:	83 c4 10             	add    $0x10,%esp
80100d6a:	e9 e0 fe ff ff       	jmp    80100c4f <exec+0x6f>
80100d6f:	89 f0                	mov    %esi,%eax
80100d71:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100d77:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d7c:	89 c7                	mov    %eax,%edi
80100d7e:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100d84:	8d 87 00 20 00 00    	lea    0x2000(%edi),%eax
  iunlockput(ip);
80100d8a:	83 ec 0c             	sub    $0xc,%esp
80100d8d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d93:	53                   	push   %ebx
80100d94:	e8 97 0d 00 00       	call   80101b30 <iunlockput>
  end_op();
80100d99:	e8 92 20 00 00       	call   80102e30 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d9e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100da4:	83 c4 0c             	add    $0xc,%esp
80100da7:	50                   	push   %eax
80100da8:	57                   	push   %edi
80100da9:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100daf:	e8 ac 65 00 00       	call   80107360 <allocuvm>
80100db4:	83 c4 10             	add    $0x10,%esp
80100db7:	85 c0                	test   %eax,%eax
80100db9:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100dbf:	75 3a                	jne    80100dfb <exec+0x21b>
    freevm(pgdir);
80100dc1:	83 ec 0c             	sub    $0xc,%esp
80100dc4:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100dca:	e8 f1 66 00 00       	call   801074c0 <freevm>
80100dcf:	83 c4 10             	add    $0x10,%esp
  return -1;
80100dd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dd7:	e9 89 fe ff ff       	jmp    80100c65 <exec+0x85>
    end_op();
80100ddc:	e8 4f 20 00 00       	call   80102e30 <end_op>
    cprintf("exec: fail\n");
80100de1:	83 ec 0c             	sub    $0xc,%esp
80100de4:	68 61 78 10 80       	push   $0x80107861
80100de9:	e8 72 f8 ff ff       	call   80100660 <cprintf>
    return -1;
80100dee:	83 c4 10             	add    $0x10,%esp
80100df1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100df6:	e9 6a fe ff ff       	jmp    80100c65 <exec+0x85>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100dfb:	89 c3                	mov    %eax,%ebx
80100dfd:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100e03:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100e06:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100e08:	50                   	push   %eax
80100e09:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100e0f:	e8 cc 67 00 00       	call   801075e0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100e14:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e17:	83 c4 10             	add    $0x10,%esp
80100e1a:	8b 00                	mov    (%eax),%eax
80100e1c:	85 c0                	test   %eax,%eax
80100e1e:	0f 84 43 01 00 00    	je     80100f67 <exec+0x387>
80100e24:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100e2a:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100e30:	eb 0b                	jmp    80100e3d <exec+0x25d>
80100e32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(argc >= MAXARG)
80100e38:	83 ff 20             	cmp    $0x20,%edi
80100e3b:	74 84                	je     80100dc1 <exec+0x1e1>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e3d:	83 ec 0c             	sub    $0xc,%esp
80100e40:	50                   	push   %eax
80100e41:	e8 1a 3e 00 00       	call   80104c60 <strlen>
80100e46:	f7 d0                	not    %eax
80100e48:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e4d:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e4e:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e51:	ff 34 b8             	pushl  (%eax,%edi,4)
80100e54:	e8 07 3e 00 00       	call   80104c60 <strlen>
80100e59:	83 c0 01             	add    $0x1,%eax
80100e5c:	50                   	push   %eax
80100e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e60:	ff 34 b8             	pushl  (%eax,%edi,4)
80100e63:	53                   	push   %ebx
80100e64:	56                   	push   %esi
80100e65:	e8 d6 68 00 00       	call   80107740 <copyout>
80100e6a:	83 c4 20             	add    $0x20,%esp
80100e6d:	85 c0                	test   %eax,%eax
80100e6f:	0f 88 4c ff ff ff    	js     80100dc1 <exec+0x1e1>
  for(argc = 0; argv[argc]; argc++) {
80100e75:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100e78:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100e7f:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100e82:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100e88:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100e8b:	85 c0                	test   %eax,%eax
80100e8d:	75 a9                	jne    80100e38 <exec+0x258>
80100e8f:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e95:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100e9c:	89 da                	mov    %ebx,%edx
  ustack[3+argc] = 0;
80100e9e:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100ea5:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ea9:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100eb0:	ff ff ff 
  ustack[1] = argc;
80100eb3:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100eb9:	29 c2                	sub    %eax,%edx
  sp -= (3+argc+1) * 4;
80100ebb:	83 c0 0c             	add    $0xc,%eax
80100ebe:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ec0:	50                   	push   %eax
80100ec1:	51                   	push   %ecx
80100ec2:	53                   	push   %ebx
80100ec3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ec9:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ecf:	e8 6c 68 00 00       	call   80107740 <copyout>
80100ed4:	83 c4 10             	add    $0x10,%esp
80100ed7:	85 c0                	test   %eax,%eax
80100ed9:	0f 88 e2 fe ff ff    	js     80100dc1 <exec+0x1e1>
  for(last=s=path; *s; s++)
80100edf:	8b 45 08             	mov    0x8(%ebp),%eax
80100ee2:	0f b6 00             	movzbl (%eax),%eax
80100ee5:	84 c0                	test   %al,%al
80100ee7:	74 17                	je     80100f00 <exec+0x320>
80100ee9:	8b 55 08             	mov    0x8(%ebp),%edx
80100eec:	89 d1                	mov    %edx,%ecx
80100eee:	83 c1 01             	add    $0x1,%ecx
80100ef1:	3c 2f                	cmp    $0x2f,%al
80100ef3:	0f b6 01             	movzbl (%ecx),%eax
80100ef6:	0f 44 d1             	cmove  %ecx,%edx
80100ef9:	84 c0                	test   %al,%al
80100efb:	75 f1                	jne    80100eee <exec+0x30e>
80100efd:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100f00:	50                   	push   %eax
80100f01:	8d 46 6c             	lea    0x6c(%esi),%eax
80100f04:	6a 10                	push   $0x10
80100f06:	ff 75 08             	pushl  0x8(%ebp)
80100f09:	50                   	push   %eax
80100f0a:	e8 11 3d 00 00       	call   80104c20 <safestrcpy>
  oldpgdir = curproc->pgdir;
80100f0f:	8b 46 04             	mov    0x4(%esi),%eax
  curproc->tf->eip = elf.entry;  // main
80100f12:	8b 56 18             	mov    0x18(%esi),%edx
  oldpgdir = curproc->pgdir;
80100f15:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  curproc->pgdir = pgdir;
80100f1b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100f21:	89 46 04             	mov    %eax,0x4(%esi)
  curproc->sz = sz;
80100f24:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100f2a:	89 06                	mov    %eax,(%esi)
  curproc->tf->eip = elf.entry;  // main
80100f2c:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
80100f32:	89 4a 38             	mov    %ecx,0x38(%edx)
  curproc->tf->esp = sp;
80100f35:	8b 56 18             	mov    0x18(%esi),%edx
80100f38:	89 5a 44             	mov    %ebx,0x44(%edx)
  switchuvm(curproc);
80100f3b:	89 34 24             	mov    %esi,(%esp)
80100f3e:	e8 cd 61 00 00       	call   80107110 <switchuvm>
  freevm(oldpgdir);
80100f43:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100f49:	89 04 24             	mov    %eax,(%esp)
80100f4c:	e8 6f 65 00 00       	call   801074c0 <freevm>
  return 0;
80100f51:	83 c4 10             	add    $0x10,%esp
80100f54:	31 c0                	xor    %eax,%eax
80100f56:	e9 0a fd ff ff       	jmp    80100c65 <exec+0x85>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100f5b:	31 ff                	xor    %edi,%edi
80100f5d:	b8 00 20 00 00       	mov    $0x2000,%eax
80100f62:	e9 23 fe ff ff       	jmp    80100d8a <exec+0x1aa>
  for(argc = 0; argv[argc]; argc++) {
80100f67:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80100f6d:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100f73:	e9 1d ff ff ff       	jmp    80100e95 <exec+0x2b5>
80100f78:	66 90                	xchg   %ax,%ax
80100f7a:	66 90                	xchg   %ax,%ax
80100f7c:	66 90                	xchg   %ax,%ax
80100f7e:	66 90                	xchg   %ax,%ax

80100f80 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f80:	55                   	push   %ebp
80100f81:	89 e5                	mov    %esp,%ebp
80100f83:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100f86:	68 6d 78 10 80       	push   $0x8010786d
80100f8b:	68 c0 10 11 80       	push   $0x801110c0
80100f90:	e8 5b 38 00 00       	call   801047f0 <initlock>
}
80100f95:	83 c4 10             	add    $0x10,%esp
80100f98:	c9                   	leave  
80100f99:	c3                   	ret    
80100f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100fa0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100fa0:	55                   	push   %ebp
80100fa1:	89 e5                	mov    %esp,%ebp
80100fa3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fa4:	bb f4 10 11 80       	mov    $0x801110f4,%ebx
{
80100fa9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100fac:	68 c0 10 11 80       	push   $0x801110c0
80100fb1:	e8 7a 39 00 00       	call   80104930 <acquire>
80100fb6:	83 c4 10             	add    $0x10,%esp
80100fb9:	eb 10                	jmp    80100fcb <filealloc+0x2b>
80100fbb:	90                   	nop
80100fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fc0:	83 c3 18             	add    $0x18,%ebx
80100fc3:	81 fb 54 1a 11 80    	cmp    $0x80111a54,%ebx
80100fc9:	73 25                	jae    80100ff0 <filealloc+0x50>
    if(f->ref == 0){
80100fcb:	8b 43 04             	mov    0x4(%ebx),%eax
80100fce:	85 c0                	test   %eax,%eax
80100fd0:	75 ee                	jne    80100fc0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100fd2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100fd5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100fdc:	68 c0 10 11 80       	push   $0x801110c0
80100fe1:	e8 0a 3a 00 00       	call   801049f0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100fe6:	89 d8                	mov    %ebx,%eax
      return f;
80100fe8:	83 c4 10             	add    $0x10,%esp
}
80100feb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fee:	c9                   	leave  
80100fef:	c3                   	ret    
  release(&ftable.lock);
80100ff0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ff3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ff5:	68 c0 10 11 80       	push   $0x801110c0
80100ffa:	e8 f1 39 00 00       	call   801049f0 <release>
}
80100fff:	89 d8                	mov    %ebx,%eax
  return 0;
80101001:	83 c4 10             	add    $0x10,%esp
}
80101004:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101007:	c9                   	leave  
80101008:	c3                   	ret    
80101009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101010 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101010:	55                   	push   %ebp
80101011:	89 e5                	mov    %esp,%ebp
80101013:	53                   	push   %ebx
80101014:	83 ec 10             	sub    $0x10,%esp
80101017:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010101a:	68 c0 10 11 80       	push   $0x801110c0
8010101f:	e8 0c 39 00 00       	call   80104930 <acquire>
  if(f->ref < 1)
80101024:	8b 43 04             	mov    0x4(%ebx),%eax
80101027:	83 c4 10             	add    $0x10,%esp
8010102a:	85 c0                	test   %eax,%eax
8010102c:	7e 1a                	jle    80101048 <filedup+0x38>
    panic("filedup");
  f->ref++;
8010102e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101031:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101034:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80101037:	68 c0 10 11 80       	push   $0x801110c0
8010103c:	e8 af 39 00 00       	call   801049f0 <release>
  return f;
}
80101041:	89 d8                	mov    %ebx,%eax
80101043:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101046:	c9                   	leave  
80101047:	c3                   	ret    
    panic("filedup");
80101048:	83 ec 0c             	sub    $0xc,%esp
8010104b:	68 74 78 10 80       	push   $0x80107874
80101050:	e8 3b f3 ff ff       	call   80100390 <panic>
80101055:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101060 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101060:	55                   	push   %ebp
80101061:	89 e5                	mov    %esp,%ebp
80101063:	57                   	push   %edi
80101064:	56                   	push   %esi
80101065:	53                   	push   %ebx
80101066:	83 ec 28             	sub    $0x28,%esp
80101069:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010106c:	68 c0 10 11 80       	push   $0x801110c0
80101071:	e8 ba 38 00 00       	call   80104930 <acquire>
  if(f->ref < 1)
80101076:	8b 43 04             	mov    0x4(%ebx),%eax
80101079:	83 c4 10             	add    $0x10,%esp
8010107c:	85 c0                	test   %eax,%eax
8010107e:	0f 8e 9b 00 00 00    	jle    8010111f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80101084:	83 e8 01             	sub    $0x1,%eax
80101087:	85 c0                	test   %eax,%eax
80101089:	89 43 04             	mov    %eax,0x4(%ebx)
8010108c:	74 1a                	je     801010a8 <fileclose+0x48>
    release(&ftable.lock);
8010108e:	c7 45 08 c0 10 11 80 	movl   $0x801110c0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80101095:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101098:	5b                   	pop    %ebx
80101099:	5e                   	pop    %esi
8010109a:	5f                   	pop    %edi
8010109b:	5d                   	pop    %ebp
    release(&ftable.lock);
8010109c:	e9 4f 39 00 00       	jmp    801049f0 <release>
801010a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
801010a8:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
801010ac:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
801010ae:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
801010b1:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
801010b4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
801010ba:	88 45 e7             	mov    %al,-0x19(%ebp)
801010bd:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
801010c0:	68 c0 10 11 80       	push   $0x801110c0
  ff = *f;
801010c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
801010c8:	e8 23 39 00 00       	call   801049f0 <release>
  if(ff.type == FD_PIPE)
801010cd:	83 c4 10             	add    $0x10,%esp
801010d0:	83 ff 01             	cmp    $0x1,%edi
801010d3:	74 13                	je     801010e8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
801010d5:	83 ff 02             	cmp    $0x2,%edi
801010d8:	74 26                	je     80101100 <fileclose+0xa0>
}
801010da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010dd:	5b                   	pop    %ebx
801010de:	5e                   	pop    %esi
801010df:	5f                   	pop    %edi
801010e0:	5d                   	pop    %ebp
801010e1:	c3                   	ret    
801010e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
801010e8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801010ec:	83 ec 08             	sub    $0x8,%esp
801010ef:	53                   	push   %ebx
801010f0:	56                   	push   %esi
801010f1:	e8 7a 24 00 00       	call   80103570 <pipeclose>
801010f6:	83 c4 10             	add    $0x10,%esp
801010f9:	eb df                	jmp    801010da <fileclose+0x7a>
801010fb:	90                   	nop
801010fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80101100:	e8 bb 1c 00 00       	call   80102dc0 <begin_op>
    iput(ff.ip);
80101105:	83 ec 0c             	sub    $0xc,%esp
80101108:	ff 75 e0             	pushl  -0x20(%ebp)
8010110b:	e8 c0 08 00 00       	call   801019d0 <iput>
    end_op();
80101110:	83 c4 10             	add    $0x10,%esp
}
80101113:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101116:	5b                   	pop    %ebx
80101117:	5e                   	pop    %esi
80101118:	5f                   	pop    %edi
80101119:	5d                   	pop    %ebp
    end_op();
8010111a:	e9 11 1d 00 00       	jmp    80102e30 <end_op>
    panic("fileclose");
8010111f:	83 ec 0c             	sub    $0xc,%esp
80101122:	68 7c 78 10 80       	push   $0x8010787c
80101127:	e8 64 f2 ff ff       	call   80100390 <panic>
8010112c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101130 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101130:	55                   	push   %ebp
80101131:	89 e5                	mov    %esp,%ebp
80101133:	53                   	push   %ebx
80101134:	83 ec 04             	sub    $0x4,%esp
80101137:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010113a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010113d:	75 31                	jne    80101170 <filestat+0x40>
    ilock(f->ip);
8010113f:	83 ec 0c             	sub    $0xc,%esp
80101142:	ff 73 10             	pushl  0x10(%ebx)
80101145:	e8 56 07 00 00       	call   801018a0 <ilock>
    stati(f->ip, st);
8010114a:	58                   	pop    %eax
8010114b:	5a                   	pop    %edx
8010114c:	ff 75 0c             	pushl  0xc(%ebp)
8010114f:	ff 73 10             	pushl  0x10(%ebx)
80101152:	e8 f9 09 00 00       	call   80101b50 <stati>
    iunlock(f->ip);
80101157:	59                   	pop    %ecx
80101158:	ff 73 10             	pushl  0x10(%ebx)
8010115b:	e8 20 08 00 00       	call   80101980 <iunlock>
    return 0;
80101160:	83 c4 10             	add    $0x10,%esp
80101163:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80101165:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101168:	c9                   	leave  
80101169:	c3                   	ret    
8010116a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80101170:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101175:	eb ee                	jmp    80101165 <filestat+0x35>
80101177:	89 f6                	mov    %esi,%esi
80101179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101180 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	57                   	push   %edi
80101184:	56                   	push   %esi
80101185:	53                   	push   %ebx
80101186:	83 ec 0c             	sub    $0xc,%esp
80101189:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010118c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010118f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101192:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101196:	74 60                	je     801011f8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101198:	8b 03                	mov    (%ebx),%eax
8010119a:	83 f8 01             	cmp    $0x1,%eax
8010119d:	74 41                	je     801011e0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010119f:	83 f8 02             	cmp    $0x2,%eax
801011a2:	75 5b                	jne    801011ff <fileread+0x7f>
    ilock(f->ip);
801011a4:	83 ec 0c             	sub    $0xc,%esp
801011a7:	ff 73 10             	pushl  0x10(%ebx)
801011aa:	e8 f1 06 00 00       	call   801018a0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801011af:	57                   	push   %edi
801011b0:	ff 73 14             	pushl  0x14(%ebx)
801011b3:	56                   	push   %esi
801011b4:	ff 73 10             	pushl  0x10(%ebx)
801011b7:	e8 c4 09 00 00       	call   80101b80 <readi>
801011bc:	83 c4 20             	add    $0x20,%esp
801011bf:	85 c0                	test   %eax,%eax
801011c1:	89 c6                	mov    %eax,%esi
801011c3:	7e 03                	jle    801011c8 <fileread+0x48>
      f->off += r;
801011c5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801011c8:	83 ec 0c             	sub    $0xc,%esp
801011cb:	ff 73 10             	pushl  0x10(%ebx)
801011ce:	e8 ad 07 00 00       	call   80101980 <iunlock>
    return r;
801011d3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801011d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011d9:	89 f0                	mov    %esi,%eax
801011db:	5b                   	pop    %ebx
801011dc:	5e                   	pop    %esi
801011dd:	5f                   	pop    %edi
801011de:	5d                   	pop    %ebp
801011df:	c3                   	ret    
    return piperead(f->pipe, addr, n);
801011e0:	8b 43 0c             	mov    0xc(%ebx),%eax
801011e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011e9:	5b                   	pop    %ebx
801011ea:	5e                   	pop    %esi
801011eb:	5f                   	pop    %edi
801011ec:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801011ed:	e9 2e 25 00 00       	jmp    80103720 <piperead>
801011f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801011f8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801011fd:	eb d7                	jmp    801011d6 <fileread+0x56>
  panic("fileread");
801011ff:	83 ec 0c             	sub    $0xc,%esp
80101202:	68 86 78 10 80       	push   $0x80107886
80101207:	e8 84 f1 ff ff       	call   80100390 <panic>
8010120c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101210 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101210:	55                   	push   %ebp
80101211:	89 e5                	mov    %esp,%ebp
80101213:	57                   	push   %edi
80101214:	56                   	push   %esi
80101215:	53                   	push   %ebx
80101216:	83 ec 1c             	sub    $0x1c,%esp
80101219:	8b 75 08             	mov    0x8(%ebp),%esi
8010121c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010121f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101223:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101226:	8b 45 10             	mov    0x10(%ebp),%eax
80101229:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010122c:	0f 84 aa 00 00 00    	je     801012dc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101232:	8b 06                	mov    (%esi),%eax
80101234:	83 f8 01             	cmp    $0x1,%eax
80101237:	0f 84 c3 00 00 00    	je     80101300 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010123d:	83 f8 02             	cmp    $0x2,%eax
80101240:	0f 85 d9 00 00 00    	jne    8010131f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101246:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101249:	31 ff                	xor    %edi,%edi
    while(i < n){
8010124b:	85 c0                	test   %eax,%eax
8010124d:	7f 34                	jg     80101283 <filewrite+0x73>
8010124f:	e9 9c 00 00 00       	jmp    801012f0 <filewrite+0xe0>
80101254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101258:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010125b:	83 ec 0c             	sub    $0xc,%esp
8010125e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101261:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101264:	e8 17 07 00 00       	call   80101980 <iunlock>
      end_op();
80101269:	e8 c2 1b 00 00       	call   80102e30 <end_op>
8010126e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101271:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101274:	39 c3                	cmp    %eax,%ebx
80101276:	0f 85 96 00 00 00    	jne    80101312 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010127c:	01 df                	add    %ebx,%edi
    while(i < n){
8010127e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101281:	7e 6d                	jle    801012f0 <filewrite+0xe0>
      int n1 = n - i;
80101283:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101286:	b8 00 06 00 00       	mov    $0x600,%eax
8010128b:	29 fb                	sub    %edi,%ebx
8010128d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101293:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101296:	e8 25 1b 00 00       	call   80102dc0 <begin_op>
      ilock(f->ip);
8010129b:	83 ec 0c             	sub    $0xc,%esp
8010129e:	ff 76 10             	pushl  0x10(%esi)
801012a1:	e8 fa 05 00 00       	call   801018a0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801012a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012a9:	53                   	push   %ebx
801012aa:	ff 76 14             	pushl  0x14(%esi)
801012ad:	01 f8                	add    %edi,%eax
801012af:	50                   	push   %eax
801012b0:	ff 76 10             	pushl  0x10(%esi)
801012b3:	e8 c8 09 00 00       	call   80101c80 <writei>
801012b8:	83 c4 20             	add    $0x20,%esp
801012bb:	85 c0                	test   %eax,%eax
801012bd:	7f 99                	jg     80101258 <filewrite+0x48>
      iunlock(f->ip);
801012bf:	83 ec 0c             	sub    $0xc,%esp
801012c2:	ff 76 10             	pushl  0x10(%esi)
801012c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801012c8:	e8 b3 06 00 00       	call   80101980 <iunlock>
      end_op();
801012cd:	e8 5e 1b 00 00       	call   80102e30 <end_op>
      if(r < 0)
801012d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801012d5:	83 c4 10             	add    $0x10,%esp
801012d8:	85 c0                	test   %eax,%eax
801012da:	74 98                	je     80101274 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801012dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801012df:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801012e4:	89 f8                	mov    %edi,%eax
801012e6:	5b                   	pop    %ebx
801012e7:	5e                   	pop    %esi
801012e8:	5f                   	pop    %edi
801012e9:	5d                   	pop    %ebp
801012ea:	c3                   	ret    
801012eb:	90                   	nop
801012ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801012f0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801012f3:	75 e7                	jne    801012dc <filewrite+0xcc>
}
801012f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012f8:	89 f8                	mov    %edi,%eax
801012fa:	5b                   	pop    %ebx
801012fb:	5e                   	pop    %esi
801012fc:	5f                   	pop    %edi
801012fd:	5d                   	pop    %ebp
801012fe:	c3                   	ret    
801012ff:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101300:	8b 46 0c             	mov    0xc(%esi),%eax
80101303:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101306:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101309:	5b                   	pop    %ebx
8010130a:	5e                   	pop    %esi
8010130b:	5f                   	pop    %edi
8010130c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010130d:	e9 fe 22 00 00       	jmp    80103610 <pipewrite>
        panic("short filewrite");
80101312:	83 ec 0c             	sub    $0xc,%esp
80101315:	68 8f 78 10 80       	push   $0x8010788f
8010131a:	e8 71 f0 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010131f:	83 ec 0c             	sub    $0xc,%esp
80101322:	68 95 78 10 80       	push   $0x80107895
80101327:	e8 64 f0 ff ff       	call   80100390 <panic>
8010132c:	66 90                	xchg   %ax,%ax
8010132e:	66 90                	xchg   %ax,%ax

80101330 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101330:	55                   	push   %ebp
80101331:	89 e5                	mov    %esp,%ebp
80101333:	56                   	push   %esi
80101334:	53                   	push   %ebx
80101335:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101337:	c1 ea 0c             	shr    $0xc,%edx
8010133a:	03 15 d8 1a 11 80    	add    0x80111ad8,%edx
80101340:	83 ec 08             	sub    $0x8,%esp
80101343:	52                   	push   %edx
80101344:	50                   	push   %eax
80101345:	e8 86 ed ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010134a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010134c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010134f:	ba 01 00 00 00       	mov    $0x1,%edx
80101354:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101357:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010135d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101360:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101362:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101367:	85 d1                	test   %edx,%ecx
80101369:	74 25                	je     80101390 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010136b:	f7 d2                	not    %edx
8010136d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010136f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101372:	21 ca                	and    %ecx,%edx
80101374:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101378:	56                   	push   %esi
80101379:	e8 12 1c 00 00       	call   80102f90 <log_write>
  brelse(bp);
8010137e:	89 34 24             	mov    %esi,(%esp)
80101381:	e8 5a ee ff ff       	call   801001e0 <brelse>
}
80101386:	83 c4 10             	add    $0x10,%esp
80101389:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010138c:	5b                   	pop    %ebx
8010138d:	5e                   	pop    %esi
8010138e:	5d                   	pop    %ebp
8010138f:	c3                   	ret    
    panic("freeing free block");
80101390:	83 ec 0c             	sub    $0xc,%esp
80101393:	68 9f 78 10 80       	push   $0x8010789f
80101398:	e8 f3 ef ff ff       	call   80100390 <panic>
8010139d:	8d 76 00             	lea    0x0(%esi),%esi

801013a0 <balloc>:
{
801013a0:	55                   	push   %ebp
801013a1:	89 e5                	mov    %esp,%ebp
801013a3:	57                   	push   %edi
801013a4:	56                   	push   %esi
801013a5:	53                   	push   %ebx
801013a6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801013a9:	8b 0d c0 1a 11 80    	mov    0x80111ac0,%ecx
{
801013af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801013b2:	85 c9                	test   %ecx,%ecx
801013b4:	0f 84 87 00 00 00    	je     80101441 <balloc+0xa1>
801013ba:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801013c1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801013c4:	83 ec 08             	sub    $0x8,%esp
801013c7:	89 f0                	mov    %esi,%eax
801013c9:	c1 f8 0c             	sar    $0xc,%eax
801013cc:	03 05 d8 1a 11 80    	add    0x80111ad8,%eax
801013d2:	50                   	push   %eax
801013d3:	ff 75 d8             	pushl  -0x28(%ebp)
801013d6:	e8 f5 ec ff ff       	call   801000d0 <bread>
801013db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013de:	a1 c0 1a 11 80       	mov    0x80111ac0,%eax
801013e3:	83 c4 10             	add    $0x10,%esp
801013e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801013e9:	31 c0                	xor    %eax,%eax
801013eb:	eb 2f                	jmp    8010141c <balloc+0x7c>
801013ed:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801013f0:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801013f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801013f5:	bb 01 00 00 00       	mov    $0x1,%ebx
801013fa:	83 e1 07             	and    $0x7,%ecx
801013fd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801013ff:	89 c1                	mov    %eax,%ecx
80101401:	c1 f9 03             	sar    $0x3,%ecx
80101404:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101409:	85 df                	test   %ebx,%edi
8010140b:	89 fa                	mov    %edi,%edx
8010140d:	74 41                	je     80101450 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010140f:	83 c0 01             	add    $0x1,%eax
80101412:	83 c6 01             	add    $0x1,%esi
80101415:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010141a:	74 05                	je     80101421 <balloc+0x81>
8010141c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010141f:	77 cf                	ja     801013f0 <balloc+0x50>
    brelse(bp);
80101421:	83 ec 0c             	sub    $0xc,%esp
80101424:	ff 75 e4             	pushl  -0x1c(%ebp)
80101427:	e8 b4 ed ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010142c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101433:	83 c4 10             	add    $0x10,%esp
80101436:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101439:	39 05 c0 1a 11 80    	cmp    %eax,0x80111ac0
8010143f:	77 80                	ja     801013c1 <balloc+0x21>
  panic("balloc: out of blocks");
80101441:	83 ec 0c             	sub    $0xc,%esp
80101444:	68 b2 78 10 80       	push   $0x801078b2
80101449:	e8 42 ef ff ff       	call   80100390 <panic>
8010144e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101450:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101453:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101456:	09 da                	or     %ebx,%edx
80101458:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010145c:	57                   	push   %edi
8010145d:	e8 2e 1b 00 00       	call   80102f90 <log_write>
        brelse(bp);
80101462:	89 3c 24             	mov    %edi,(%esp)
80101465:	e8 76 ed ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010146a:	58                   	pop    %eax
8010146b:	5a                   	pop    %edx
8010146c:	56                   	push   %esi
8010146d:	ff 75 d8             	pushl  -0x28(%ebp)
80101470:	e8 5b ec ff ff       	call   801000d0 <bread>
80101475:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101477:	8d 40 5c             	lea    0x5c(%eax),%eax
8010147a:	83 c4 0c             	add    $0xc,%esp
8010147d:	68 00 02 00 00       	push   $0x200
80101482:	6a 00                	push   $0x0
80101484:	50                   	push   %eax
80101485:	e8 b6 35 00 00       	call   80104a40 <memset>
  log_write(bp);
8010148a:	89 1c 24             	mov    %ebx,(%esp)
8010148d:	e8 fe 1a 00 00       	call   80102f90 <log_write>
  brelse(bp);
80101492:	89 1c 24             	mov    %ebx,(%esp)
80101495:	e8 46 ed ff ff       	call   801001e0 <brelse>
}
8010149a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010149d:	89 f0                	mov    %esi,%eax
8010149f:	5b                   	pop    %ebx
801014a0:	5e                   	pop    %esi
801014a1:	5f                   	pop    %edi
801014a2:	5d                   	pop    %ebp
801014a3:	c3                   	ret    
801014a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801014b0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801014b0:	55                   	push   %ebp
801014b1:	89 e5                	mov    %esp,%ebp
801014b3:	57                   	push   %edi
801014b4:	56                   	push   %esi
801014b5:	53                   	push   %ebx
801014b6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801014b8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014ba:	bb 14 1b 11 80       	mov    $0x80111b14,%ebx
{
801014bf:	83 ec 28             	sub    $0x28,%esp
801014c2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801014c5:	68 e0 1a 11 80       	push   $0x80111ae0
801014ca:	e8 61 34 00 00       	call   80104930 <acquire>
801014cf:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014d5:	eb 17                	jmp    801014ee <iget+0x3e>
801014d7:	89 f6                	mov    %esi,%esi
801014d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801014e0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014e6:	81 fb 34 37 11 80    	cmp    $0x80113734,%ebx
801014ec:	73 22                	jae    80101510 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801014ee:	8b 4b 08             	mov    0x8(%ebx),%ecx
801014f1:	85 c9                	test   %ecx,%ecx
801014f3:	7e 04                	jle    801014f9 <iget+0x49>
801014f5:	39 3b                	cmp    %edi,(%ebx)
801014f7:	74 4f                	je     80101548 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801014f9:	85 f6                	test   %esi,%esi
801014fb:	75 e3                	jne    801014e0 <iget+0x30>
801014fd:	85 c9                	test   %ecx,%ecx
801014ff:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101502:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101508:	81 fb 34 37 11 80    	cmp    $0x80113734,%ebx
8010150e:	72 de                	jb     801014ee <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101510:	85 f6                	test   %esi,%esi
80101512:	74 5b                	je     8010156f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101514:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101517:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101519:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010151c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101523:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010152a:	68 e0 1a 11 80       	push   $0x80111ae0
8010152f:	e8 bc 34 00 00       	call   801049f0 <release>

  return ip;
80101534:	83 c4 10             	add    $0x10,%esp
}
80101537:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010153a:	89 f0                	mov    %esi,%eax
8010153c:	5b                   	pop    %ebx
8010153d:	5e                   	pop    %esi
8010153e:	5f                   	pop    %edi
8010153f:	5d                   	pop    %ebp
80101540:	c3                   	ret    
80101541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101548:	39 53 04             	cmp    %edx,0x4(%ebx)
8010154b:	75 ac                	jne    801014f9 <iget+0x49>
      release(&icache.lock);
8010154d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101550:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101553:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101555:	68 e0 1a 11 80       	push   $0x80111ae0
      ip->ref++;
8010155a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010155d:	e8 8e 34 00 00       	call   801049f0 <release>
      return ip;
80101562:	83 c4 10             	add    $0x10,%esp
}
80101565:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101568:	89 f0                	mov    %esi,%eax
8010156a:	5b                   	pop    %ebx
8010156b:	5e                   	pop    %esi
8010156c:	5f                   	pop    %edi
8010156d:	5d                   	pop    %ebp
8010156e:	c3                   	ret    
    panic("iget: no inodes");
8010156f:	83 ec 0c             	sub    $0xc,%esp
80101572:	68 c8 78 10 80       	push   $0x801078c8
80101577:	e8 14 ee ff ff       	call   80100390 <panic>
8010157c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101580 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101580:	55                   	push   %ebp
80101581:	89 e5                	mov    %esp,%ebp
80101583:	57                   	push   %edi
80101584:	56                   	push   %esi
80101585:	53                   	push   %ebx
80101586:	89 c6                	mov    %eax,%esi
80101588:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010158b:	83 fa 0b             	cmp    $0xb,%edx
8010158e:	77 18                	ja     801015a8 <bmap+0x28>
80101590:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101593:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101596:	85 db                	test   %ebx,%ebx
80101598:	74 76                	je     80101610 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010159a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010159d:	89 d8                	mov    %ebx,%eax
8010159f:	5b                   	pop    %ebx
801015a0:	5e                   	pop    %esi
801015a1:	5f                   	pop    %edi
801015a2:	5d                   	pop    %ebp
801015a3:	c3                   	ret    
801015a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
801015a8:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
801015ab:	83 fb 7f             	cmp    $0x7f,%ebx
801015ae:	0f 87 90 00 00 00    	ja     80101644 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
801015b4:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
801015ba:	8b 00                	mov    (%eax),%eax
801015bc:	85 d2                	test   %edx,%edx
801015be:	74 70                	je     80101630 <bmap+0xb0>
    bp = bread(ip->dev, addr);
801015c0:	83 ec 08             	sub    $0x8,%esp
801015c3:	52                   	push   %edx
801015c4:	50                   	push   %eax
801015c5:	e8 06 eb ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801015ca:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801015ce:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801015d1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801015d3:	8b 1a                	mov    (%edx),%ebx
801015d5:	85 db                	test   %ebx,%ebx
801015d7:	75 1d                	jne    801015f6 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801015d9:	8b 06                	mov    (%esi),%eax
801015db:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801015de:	e8 bd fd ff ff       	call   801013a0 <balloc>
801015e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801015e6:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801015e9:	89 c3                	mov    %eax,%ebx
801015eb:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801015ed:	57                   	push   %edi
801015ee:	e8 9d 19 00 00       	call   80102f90 <log_write>
801015f3:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801015f6:	83 ec 0c             	sub    $0xc,%esp
801015f9:	57                   	push   %edi
801015fa:	e8 e1 eb ff ff       	call   801001e0 <brelse>
801015ff:	83 c4 10             	add    $0x10,%esp
}
80101602:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101605:	89 d8                	mov    %ebx,%eax
80101607:	5b                   	pop    %ebx
80101608:	5e                   	pop    %esi
80101609:	5f                   	pop    %edi
8010160a:	5d                   	pop    %ebp
8010160b:	c3                   	ret    
8010160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101610:	8b 00                	mov    (%eax),%eax
80101612:	e8 89 fd ff ff       	call   801013a0 <balloc>
80101617:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010161a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010161d:	89 c3                	mov    %eax,%ebx
}
8010161f:	89 d8                	mov    %ebx,%eax
80101621:	5b                   	pop    %ebx
80101622:	5e                   	pop    %esi
80101623:	5f                   	pop    %edi
80101624:	5d                   	pop    %ebp
80101625:	c3                   	ret    
80101626:	8d 76 00             	lea    0x0(%esi),%esi
80101629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101630:	e8 6b fd ff ff       	call   801013a0 <balloc>
80101635:	89 c2                	mov    %eax,%edx
80101637:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010163d:	8b 06                	mov    (%esi),%eax
8010163f:	e9 7c ff ff ff       	jmp    801015c0 <bmap+0x40>
  panic("bmap: out of range");
80101644:	83 ec 0c             	sub    $0xc,%esp
80101647:	68 d8 78 10 80       	push   $0x801078d8
8010164c:	e8 3f ed ff ff       	call   80100390 <panic>
80101651:	eb 0d                	jmp    80101660 <readsb>
80101653:	90                   	nop
80101654:	90                   	nop
80101655:	90                   	nop
80101656:	90                   	nop
80101657:	90                   	nop
80101658:	90                   	nop
80101659:	90                   	nop
8010165a:	90                   	nop
8010165b:	90                   	nop
8010165c:	90                   	nop
8010165d:	90                   	nop
8010165e:	90                   	nop
8010165f:	90                   	nop

80101660 <readsb>:
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	56                   	push   %esi
80101664:	53                   	push   %ebx
80101665:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101668:	83 ec 08             	sub    $0x8,%esp
8010166b:	6a 01                	push   $0x1
8010166d:	ff 75 08             	pushl  0x8(%ebp)
80101670:	e8 5b ea ff ff       	call   801000d0 <bread>
80101675:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101677:	8d 40 5c             	lea    0x5c(%eax),%eax
8010167a:	83 c4 0c             	add    $0xc,%esp
8010167d:	6a 1c                	push   $0x1c
8010167f:	50                   	push   %eax
80101680:	56                   	push   %esi
80101681:	e8 6a 34 00 00       	call   80104af0 <memmove>
  brelse(bp);
80101686:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101689:	83 c4 10             	add    $0x10,%esp
}
8010168c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010168f:	5b                   	pop    %ebx
80101690:	5e                   	pop    %esi
80101691:	5d                   	pop    %ebp
  brelse(bp);
80101692:	e9 49 eb ff ff       	jmp    801001e0 <brelse>
80101697:	89 f6                	mov    %esi,%esi
80101699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801016a0 <iinit>:
{
801016a0:	55                   	push   %ebp
801016a1:	89 e5                	mov    %esp,%ebp
801016a3:	53                   	push   %ebx
801016a4:	bb 20 1b 11 80       	mov    $0x80111b20,%ebx
801016a9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801016ac:	68 eb 78 10 80       	push   $0x801078eb
801016b1:	68 e0 1a 11 80       	push   $0x80111ae0
801016b6:	e8 35 31 00 00       	call   801047f0 <initlock>
801016bb:	83 c4 10             	add    $0x10,%esp
801016be:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801016c0:	83 ec 08             	sub    $0x8,%esp
801016c3:	68 f2 78 10 80       	push   $0x801078f2
801016c8:	53                   	push   %ebx
801016c9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801016cf:	e8 ec 2f 00 00       	call   801046c0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801016d4:	83 c4 10             	add    $0x10,%esp
801016d7:	81 fb 40 37 11 80    	cmp    $0x80113740,%ebx
801016dd:	75 e1                	jne    801016c0 <iinit+0x20>
  readsb(dev, &sb);
801016df:	83 ec 08             	sub    $0x8,%esp
801016e2:	68 c0 1a 11 80       	push   $0x80111ac0
801016e7:	ff 75 08             	pushl  0x8(%ebp)
801016ea:	e8 71 ff ff ff       	call   80101660 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801016ef:	ff 35 d8 1a 11 80    	pushl  0x80111ad8
801016f5:	ff 35 d4 1a 11 80    	pushl  0x80111ad4
801016fb:	ff 35 d0 1a 11 80    	pushl  0x80111ad0
80101701:	ff 35 cc 1a 11 80    	pushl  0x80111acc
80101707:	ff 35 c8 1a 11 80    	pushl  0x80111ac8
8010170d:	ff 35 c4 1a 11 80    	pushl  0x80111ac4
80101713:	ff 35 c0 1a 11 80    	pushl  0x80111ac0
80101719:	68 58 79 10 80       	push   $0x80107958
8010171e:	e8 3d ef ff ff       	call   80100660 <cprintf>
}
80101723:	83 c4 30             	add    $0x30,%esp
80101726:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101729:	c9                   	leave  
8010172a:	c3                   	ret    
8010172b:	90                   	nop
8010172c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101730 <ialloc>:
{
80101730:	55                   	push   %ebp
80101731:	89 e5                	mov    %esp,%ebp
80101733:	57                   	push   %edi
80101734:	56                   	push   %esi
80101735:	53                   	push   %ebx
80101736:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101739:	83 3d c8 1a 11 80 01 	cmpl   $0x1,0x80111ac8
{
80101740:	8b 45 0c             	mov    0xc(%ebp),%eax
80101743:	8b 75 08             	mov    0x8(%ebp),%esi
80101746:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101749:	0f 86 91 00 00 00    	jbe    801017e0 <ialloc+0xb0>
8010174f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101754:	eb 21                	jmp    80101777 <ialloc+0x47>
80101756:	8d 76 00             	lea    0x0(%esi),%esi
80101759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101760:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101763:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101766:	57                   	push   %edi
80101767:	e8 74 ea ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010176c:	83 c4 10             	add    $0x10,%esp
8010176f:	39 1d c8 1a 11 80    	cmp    %ebx,0x80111ac8
80101775:	76 69                	jbe    801017e0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101777:	89 d8                	mov    %ebx,%eax
80101779:	83 ec 08             	sub    $0x8,%esp
8010177c:	c1 e8 03             	shr    $0x3,%eax
8010177f:	03 05 d4 1a 11 80    	add    0x80111ad4,%eax
80101785:	50                   	push   %eax
80101786:	56                   	push   %esi
80101787:	e8 44 e9 ff ff       	call   801000d0 <bread>
8010178c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010178e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101790:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101793:	83 e0 07             	and    $0x7,%eax
80101796:	c1 e0 06             	shl    $0x6,%eax
80101799:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010179d:	66 83 39 00          	cmpw   $0x0,(%ecx)
801017a1:	75 bd                	jne    80101760 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801017a3:	83 ec 04             	sub    $0x4,%esp
801017a6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801017a9:	6a 40                	push   $0x40
801017ab:	6a 00                	push   $0x0
801017ad:	51                   	push   %ecx
801017ae:	e8 8d 32 00 00       	call   80104a40 <memset>
      dip->type = type;
801017b3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801017b7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801017ba:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801017bd:	89 3c 24             	mov    %edi,(%esp)
801017c0:	e8 cb 17 00 00       	call   80102f90 <log_write>
      brelse(bp);
801017c5:	89 3c 24             	mov    %edi,(%esp)
801017c8:	e8 13 ea ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801017cd:	83 c4 10             	add    $0x10,%esp
}
801017d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801017d3:	89 da                	mov    %ebx,%edx
801017d5:	89 f0                	mov    %esi,%eax
}
801017d7:	5b                   	pop    %ebx
801017d8:	5e                   	pop    %esi
801017d9:	5f                   	pop    %edi
801017da:	5d                   	pop    %ebp
      return iget(dev, inum);
801017db:	e9 d0 fc ff ff       	jmp    801014b0 <iget>
  panic("ialloc: no inodes");
801017e0:	83 ec 0c             	sub    $0xc,%esp
801017e3:	68 f8 78 10 80       	push   $0x801078f8
801017e8:	e8 a3 eb ff ff       	call   80100390 <panic>
801017ed:	8d 76 00             	lea    0x0(%esi),%esi

801017f0 <iupdate>:
{
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	56                   	push   %esi
801017f4:	53                   	push   %ebx
801017f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017f8:	83 ec 08             	sub    $0x8,%esp
801017fb:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017fe:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101801:	c1 e8 03             	shr    $0x3,%eax
80101804:	03 05 d4 1a 11 80    	add    0x80111ad4,%eax
8010180a:	50                   	push   %eax
8010180b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010180e:	e8 bd e8 ff ff       	call   801000d0 <bread>
80101813:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101815:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101818:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010181c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010181f:	83 e0 07             	and    $0x7,%eax
80101822:	c1 e0 06             	shl    $0x6,%eax
80101825:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101829:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010182c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101830:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101833:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101837:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010183b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010183f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101843:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101847:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010184a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010184d:	6a 34                	push   $0x34
8010184f:	53                   	push   %ebx
80101850:	50                   	push   %eax
80101851:	e8 9a 32 00 00       	call   80104af0 <memmove>
  log_write(bp);
80101856:	89 34 24             	mov    %esi,(%esp)
80101859:	e8 32 17 00 00       	call   80102f90 <log_write>
  brelse(bp);
8010185e:	89 75 08             	mov    %esi,0x8(%ebp)
80101861:	83 c4 10             	add    $0x10,%esp
}
80101864:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101867:	5b                   	pop    %ebx
80101868:	5e                   	pop    %esi
80101869:	5d                   	pop    %ebp
  brelse(bp);
8010186a:	e9 71 e9 ff ff       	jmp    801001e0 <brelse>
8010186f:	90                   	nop

80101870 <idup>:
{
80101870:	55                   	push   %ebp
80101871:	89 e5                	mov    %esp,%ebp
80101873:	53                   	push   %ebx
80101874:	83 ec 10             	sub    $0x10,%esp
80101877:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010187a:	68 e0 1a 11 80       	push   $0x80111ae0
8010187f:	e8 ac 30 00 00       	call   80104930 <acquire>
  ip->ref++;
80101884:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101888:	c7 04 24 e0 1a 11 80 	movl   $0x80111ae0,(%esp)
8010188f:	e8 5c 31 00 00       	call   801049f0 <release>
}
80101894:	89 d8                	mov    %ebx,%eax
80101896:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101899:	c9                   	leave  
8010189a:	c3                   	ret    
8010189b:	90                   	nop
8010189c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018a0 <ilock>:
{
801018a0:	55                   	push   %ebp
801018a1:	89 e5                	mov    %esp,%ebp
801018a3:	56                   	push   %esi
801018a4:	53                   	push   %ebx
801018a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801018a8:	85 db                	test   %ebx,%ebx
801018aa:	0f 84 b7 00 00 00    	je     80101967 <ilock+0xc7>
801018b0:	8b 53 08             	mov    0x8(%ebx),%edx
801018b3:	85 d2                	test   %edx,%edx
801018b5:	0f 8e ac 00 00 00    	jle    80101967 <ilock+0xc7>
  acquiresleep(&ip->lock);
801018bb:	8d 43 0c             	lea    0xc(%ebx),%eax
801018be:	83 ec 0c             	sub    $0xc,%esp
801018c1:	50                   	push   %eax
801018c2:	e8 39 2e 00 00       	call   80104700 <acquiresleep>
  if(ip->valid == 0){
801018c7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801018ca:	83 c4 10             	add    $0x10,%esp
801018cd:	85 c0                	test   %eax,%eax
801018cf:	74 0f                	je     801018e0 <ilock+0x40>
}
801018d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018d4:	5b                   	pop    %ebx
801018d5:	5e                   	pop    %esi
801018d6:	5d                   	pop    %ebp
801018d7:	c3                   	ret    
801018d8:	90                   	nop
801018d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018e0:	8b 43 04             	mov    0x4(%ebx),%eax
801018e3:	83 ec 08             	sub    $0x8,%esp
801018e6:	c1 e8 03             	shr    $0x3,%eax
801018e9:	03 05 d4 1a 11 80    	add    0x80111ad4,%eax
801018ef:	50                   	push   %eax
801018f0:	ff 33                	pushl  (%ebx)
801018f2:	e8 d9 e7 ff ff       	call   801000d0 <bread>
801018f7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801018f9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018fc:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801018ff:	83 e0 07             	and    $0x7,%eax
80101902:	c1 e0 06             	shl    $0x6,%eax
80101905:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101909:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010190c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010190f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101913:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101917:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010191b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010191f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101923:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101927:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010192b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010192e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101931:	6a 34                	push   $0x34
80101933:	50                   	push   %eax
80101934:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101937:	50                   	push   %eax
80101938:	e8 b3 31 00 00       	call   80104af0 <memmove>
    brelse(bp);
8010193d:	89 34 24             	mov    %esi,(%esp)
80101940:	e8 9b e8 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101945:	83 c4 10             	add    $0x10,%esp
80101948:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010194d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101954:	0f 85 77 ff ff ff    	jne    801018d1 <ilock+0x31>
      panic("ilock: no type");
8010195a:	83 ec 0c             	sub    $0xc,%esp
8010195d:	68 10 79 10 80       	push   $0x80107910
80101962:	e8 29 ea ff ff       	call   80100390 <panic>
    panic("ilock");
80101967:	83 ec 0c             	sub    $0xc,%esp
8010196a:	68 0a 79 10 80       	push   $0x8010790a
8010196f:	e8 1c ea ff ff       	call   80100390 <panic>
80101974:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010197a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101980 <iunlock>:
{
80101980:	55                   	push   %ebp
80101981:	89 e5                	mov    %esp,%ebp
80101983:	56                   	push   %esi
80101984:	53                   	push   %ebx
80101985:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101988:	85 db                	test   %ebx,%ebx
8010198a:	74 28                	je     801019b4 <iunlock+0x34>
8010198c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010198f:	83 ec 0c             	sub    $0xc,%esp
80101992:	56                   	push   %esi
80101993:	e8 08 2e 00 00       	call   801047a0 <holdingsleep>
80101998:	83 c4 10             	add    $0x10,%esp
8010199b:	85 c0                	test   %eax,%eax
8010199d:	74 15                	je     801019b4 <iunlock+0x34>
8010199f:	8b 43 08             	mov    0x8(%ebx),%eax
801019a2:	85 c0                	test   %eax,%eax
801019a4:	7e 0e                	jle    801019b4 <iunlock+0x34>
  releasesleep(&ip->lock);
801019a6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801019a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801019ac:	5b                   	pop    %ebx
801019ad:	5e                   	pop    %esi
801019ae:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801019af:	e9 ac 2d 00 00       	jmp    80104760 <releasesleep>
    panic("iunlock");
801019b4:	83 ec 0c             	sub    $0xc,%esp
801019b7:	68 1f 79 10 80       	push   $0x8010791f
801019bc:	e8 cf e9 ff ff       	call   80100390 <panic>
801019c1:	eb 0d                	jmp    801019d0 <iput>
801019c3:	90                   	nop
801019c4:	90                   	nop
801019c5:	90                   	nop
801019c6:	90                   	nop
801019c7:	90                   	nop
801019c8:	90                   	nop
801019c9:	90                   	nop
801019ca:	90                   	nop
801019cb:	90                   	nop
801019cc:	90                   	nop
801019cd:	90                   	nop
801019ce:	90                   	nop
801019cf:	90                   	nop

801019d0 <iput>:
{
801019d0:	55                   	push   %ebp
801019d1:	89 e5                	mov    %esp,%ebp
801019d3:	57                   	push   %edi
801019d4:	56                   	push   %esi
801019d5:	53                   	push   %ebx
801019d6:	83 ec 28             	sub    $0x28,%esp
801019d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801019dc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801019df:	57                   	push   %edi
801019e0:	e8 1b 2d 00 00       	call   80104700 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801019e5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801019e8:	83 c4 10             	add    $0x10,%esp
801019eb:	85 d2                	test   %edx,%edx
801019ed:	74 07                	je     801019f6 <iput+0x26>
801019ef:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801019f4:	74 32                	je     80101a28 <iput+0x58>
  releasesleep(&ip->lock);
801019f6:	83 ec 0c             	sub    $0xc,%esp
801019f9:	57                   	push   %edi
801019fa:	e8 61 2d 00 00       	call   80104760 <releasesleep>
  acquire(&icache.lock);
801019ff:	c7 04 24 e0 1a 11 80 	movl   $0x80111ae0,(%esp)
80101a06:	e8 25 2f 00 00       	call   80104930 <acquire>
  ip->ref--;
80101a0b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101a0f:	83 c4 10             	add    $0x10,%esp
80101a12:	c7 45 08 e0 1a 11 80 	movl   $0x80111ae0,0x8(%ebp)
}
80101a19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a1c:	5b                   	pop    %ebx
80101a1d:	5e                   	pop    %esi
80101a1e:	5f                   	pop    %edi
80101a1f:	5d                   	pop    %ebp
  release(&icache.lock);
80101a20:	e9 cb 2f 00 00       	jmp    801049f0 <release>
80101a25:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101a28:	83 ec 0c             	sub    $0xc,%esp
80101a2b:	68 e0 1a 11 80       	push   $0x80111ae0
80101a30:	e8 fb 2e 00 00       	call   80104930 <acquire>
    int r = ip->ref;
80101a35:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101a38:	c7 04 24 e0 1a 11 80 	movl   $0x80111ae0,(%esp)
80101a3f:	e8 ac 2f 00 00       	call   801049f0 <release>
    if(r == 1){
80101a44:	83 c4 10             	add    $0x10,%esp
80101a47:	83 fe 01             	cmp    $0x1,%esi
80101a4a:	75 aa                	jne    801019f6 <iput+0x26>
80101a4c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101a52:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101a55:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101a58:	89 cf                	mov    %ecx,%edi
80101a5a:	eb 0b                	jmp    80101a67 <iput+0x97>
80101a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a60:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101a63:	39 fe                	cmp    %edi,%esi
80101a65:	74 19                	je     80101a80 <iput+0xb0>
    if(ip->addrs[i]){
80101a67:	8b 16                	mov    (%esi),%edx
80101a69:	85 d2                	test   %edx,%edx
80101a6b:	74 f3                	je     80101a60 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101a6d:	8b 03                	mov    (%ebx),%eax
80101a6f:	e8 bc f8 ff ff       	call   80101330 <bfree>
      ip->addrs[i] = 0;
80101a74:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101a7a:	eb e4                	jmp    80101a60 <iput+0x90>
80101a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101a80:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101a86:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a89:	85 c0                	test   %eax,%eax
80101a8b:	75 33                	jne    80101ac0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101a8d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101a90:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101a97:	53                   	push   %ebx
80101a98:	e8 53 fd ff ff       	call   801017f0 <iupdate>
      ip->type = 0;
80101a9d:	31 c0                	xor    %eax,%eax
80101a9f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101aa3:	89 1c 24             	mov    %ebx,(%esp)
80101aa6:	e8 45 fd ff ff       	call   801017f0 <iupdate>
      ip->valid = 0;
80101aab:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101ab2:	83 c4 10             	add    $0x10,%esp
80101ab5:	e9 3c ff ff ff       	jmp    801019f6 <iput+0x26>
80101aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101ac0:	83 ec 08             	sub    $0x8,%esp
80101ac3:	50                   	push   %eax
80101ac4:	ff 33                	pushl  (%ebx)
80101ac6:	e8 05 e6 ff ff       	call   801000d0 <bread>
80101acb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101ad1:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101ad4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101ad7:	8d 70 5c             	lea    0x5c(%eax),%esi
80101ada:	83 c4 10             	add    $0x10,%esp
80101add:	89 cf                	mov    %ecx,%edi
80101adf:	eb 0e                	jmp    80101aef <iput+0x11f>
80101ae1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ae8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
80101aeb:	39 fe                	cmp    %edi,%esi
80101aed:	74 0f                	je     80101afe <iput+0x12e>
      if(a[j])
80101aef:	8b 16                	mov    (%esi),%edx
80101af1:	85 d2                	test   %edx,%edx
80101af3:	74 f3                	je     80101ae8 <iput+0x118>
        bfree(ip->dev, a[j]);
80101af5:	8b 03                	mov    (%ebx),%eax
80101af7:	e8 34 f8 ff ff       	call   80101330 <bfree>
80101afc:	eb ea                	jmp    80101ae8 <iput+0x118>
    brelse(bp);
80101afe:	83 ec 0c             	sub    $0xc,%esp
80101b01:	ff 75 e4             	pushl  -0x1c(%ebp)
80101b04:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b07:	e8 d4 e6 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101b0c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101b12:	8b 03                	mov    (%ebx),%eax
80101b14:	e8 17 f8 ff ff       	call   80101330 <bfree>
    ip->addrs[NDIRECT] = 0;
80101b19:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101b20:	00 00 00 
80101b23:	83 c4 10             	add    $0x10,%esp
80101b26:	e9 62 ff ff ff       	jmp    80101a8d <iput+0xbd>
80101b2b:	90                   	nop
80101b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101b30 <iunlockput>:
{
80101b30:	55                   	push   %ebp
80101b31:	89 e5                	mov    %esp,%ebp
80101b33:	53                   	push   %ebx
80101b34:	83 ec 10             	sub    $0x10,%esp
80101b37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101b3a:	53                   	push   %ebx
80101b3b:	e8 40 fe ff ff       	call   80101980 <iunlock>
  iput(ip);
80101b40:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101b43:	83 c4 10             	add    $0x10,%esp
}
80101b46:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101b49:	c9                   	leave  
  iput(ip);
80101b4a:	e9 81 fe ff ff       	jmp    801019d0 <iput>
80101b4f:	90                   	nop

80101b50 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101b50:	55                   	push   %ebp
80101b51:	89 e5                	mov    %esp,%ebp
80101b53:	8b 55 08             	mov    0x8(%ebp),%edx
80101b56:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101b59:	8b 0a                	mov    (%edx),%ecx
80101b5b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101b5e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101b61:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101b64:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101b68:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101b6b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101b6f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101b73:	8b 52 58             	mov    0x58(%edx),%edx
80101b76:	89 50 10             	mov    %edx,0x10(%eax)
}
80101b79:	5d                   	pop    %ebp
80101b7a:	c3                   	ret    
80101b7b:	90                   	nop
80101b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101b80 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101b80:	55                   	push   %ebp
80101b81:	89 e5                	mov    %esp,%ebp
80101b83:	57                   	push   %edi
80101b84:	56                   	push   %esi
80101b85:	53                   	push   %ebx
80101b86:	83 ec 1c             	sub    $0x1c,%esp
80101b89:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b8f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b92:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b97:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101b9a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b9d:	8b 75 10             	mov    0x10(%ebp),%esi
80101ba0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ba3:	0f 84 a7 00 00 00    	je     80101c50 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ba9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bac:	8b 40 58             	mov    0x58(%eax),%eax
80101baf:	39 c6                	cmp    %eax,%esi
80101bb1:	0f 87 ba 00 00 00    	ja     80101c71 <readi+0xf1>
80101bb7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101bba:	89 f9                	mov    %edi,%ecx
80101bbc:	01 f1                	add    %esi,%ecx
80101bbe:	0f 82 ad 00 00 00    	jb     80101c71 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101bc4:	89 c2                	mov    %eax,%edx
80101bc6:	29 f2                	sub    %esi,%edx
80101bc8:	39 c8                	cmp    %ecx,%eax
80101bca:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bcd:	31 ff                	xor    %edi,%edi
80101bcf:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101bd1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bd4:	74 6c                	je     80101c42 <readi+0xc2>
80101bd6:	8d 76 00             	lea    0x0(%esi),%esi
80101bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101be0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101be3:	89 f2                	mov    %esi,%edx
80101be5:	c1 ea 09             	shr    $0x9,%edx
80101be8:	89 d8                	mov    %ebx,%eax
80101bea:	e8 91 f9 ff ff       	call   80101580 <bmap>
80101bef:	83 ec 08             	sub    $0x8,%esp
80101bf2:	50                   	push   %eax
80101bf3:	ff 33                	pushl  (%ebx)
80101bf5:	e8 d6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bfa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bfd:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101bff:	89 f0                	mov    %esi,%eax
80101c01:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c06:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c0b:	83 c4 0c             	add    $0xc,%esp
80101c0e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101c10:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101c14:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101c17:	29 fb                	sub    %edi,%ebx
80101c19:	39 d9                	cmp    %ebx,%ecx
80101c1b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101c1e:	53                   	push   %ebx
80101c1f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c20:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101c22:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c25:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101c27:	e8 c4 2e 00 00       	call   80104af0 <memmove>
    brelse(bp);
80101c2c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101c2f:	89 14 24             	mov    %edx,(%esp)
80101c32:	e8 a9 e5 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c37:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101c3a:	83 c4 10             	add    $0x10,%esp
80101c3d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101c40:	77 9e                	ja     80101be0 <readi+0x60>
  }
  return n;
80101c42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101c45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c48:	5b                   	pop    %ebx
80101c49:	5e                   	pop    %esi
80101c4a:	5f                   	pop    %edi
80101c4b:	5d                   	pop    %ebp
80101c4c:	c3                   	ret    
80101c4d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101c50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c54:	66 83 f8 09          	cmp    $0x9,%ax
80101c58:	77 17                	ja     80101c71 <readi+0xf1>
80101c5a:	8b 04 c5 60 1a 11 80 	mov    -0x7feee5a0(,%eax,8),%eax
80101c61:	85 c0                	test   %eax,%eax
80101c63:	74 0c                	je     80101c71 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101c65:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c6b:	5b                   	pop    %ebx
80101c6c:	5e                   	pop    %esi
80101c6d:	5f                   	pop    %edi
80101c6e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101c6f:	ff e0                	jmp    *%eax
      return -1;
80101c71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c76:	eb cd                	jmp    80101c45 <readi+0xc5>
80101c78:	90                   	nop
80101c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c80 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101c80:	55                   	push   %ebp
80101c81:	89 e5                	mov    %esp,%ebp
80101c83:	57                   	push   %edi
80101c84:	56                   	push   %esi
80101c85:	53                   	push   %ebx
80101c86:	83 ec 1c             	sub    $0x1c,%esp
80101c89:	8b 45 08             	mov    0x8(%ebp),%eax
80101c8c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101c8f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c92:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c97:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101c9a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c9d:	8b 75 10             	mov    0x10(%ebp),%esi
80101ca0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101ca3:	0f 84 b7 00 00 00    	je     80101d60 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101ca9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cac:	39 70 58             	cmp    %esi,0x58(%eax)
80101caf:	0f 82 eb 00 00 00    	jb     80101da0 <writei+0x120>
80101cb5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101cb8:	31 d2                	xor    %edx,%edx
80101cba:	89 f8                	mov    %edi,%eax
80101cbc:	01 f0                	add    %esi,%eax
80101cbe:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101cc1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101cc6:	0f 87 d4 00 00 00    	ja     80101da0 <writei+0x120>
80101ccc:	85 d2                	test   %edx,%edx
80101cce:	0f 85 cc 00 00 00    	jne    80101da0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cd4:	85 ff                	test   %edi,%edi
80101cd6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101cdd:	74 72                	je     80101d51 <writei+0xd1>
80101cdf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ce0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ce3:	89 f2                	mov    %esi,%edx
80101ce5:	c1 ea 09             	shr    $0x9,%edx
80101ce8:	89 f8                	mov    %edi,%eax
80101cea:	e8 91 f8 ff ff       	call   80101580 <bmap>
80101cef:	83 ec 08             	sub    $0x8,%esp
80101cf2:	50                   	push   %eax
80101cf3:	ff 37                	pushl  (%edi)
80101cf5:	e8 d6 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101cfa:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101cfd:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d00:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101d02:	89 f0                	mov    %esi,%eax
80101d04:	b9 00 02 00 00       	mov    $0x200,%ecx
80101d09:	83 c4 0c             	add    $0xc,%esp
80101d0c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101d11:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101d13:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101d17:	39 d9                	cmp    %ebx,%ecx
80101d19:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101d1c:	53                   	push   %ebx
80101d1d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d20:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101d22:	50                   	push   %eax
80101d23:	e8 c8 2d 00 00       	call   80104af0 <memmove>
    log_write(bp);
80101d28:	89 3c 24             	mov    %edi,(%esp)
80101d2b:	e8 60 12 00 00       	call   80102f90 <log_write>
    brelse(bp);
80101d30:	89 3c 24             	mov    %edi,(%esp)
80101d33:	e8 a8 e4 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d38:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101d3b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101d3e:	83 c4 10             	add    $0x10,%esp
80101d41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d44:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101d47:	77 97                	ja     80101ce0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101d49:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d4c:	3b 70 58             	cmp    0x58(%eax),%esi
80101d4f:	77 37                	ja     80101d88 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101d51:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101d54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d57:	5b                   	pop    %ebx
80101d58:	5e                   	pop    %esi
80101d59:	5f                   	pop    %edi
80101d5a:	5d                   	pop    %ebp
80101d5b:	c3                   	ret    
80101d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101d60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101d64:	66 83 f8 09          	cmp    $0x9,%ax
80101d68:	77 36                	ja     80101da0 <writei+0x120>
80101d6a:	8b 04 c5 64 1a 11 80 	mov    -0x7feee59c(,%eax,8),%eax
80101d71:	85 c0                	test   %eax,%eax
80101d73:	74 2b                	je     80101da0 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101d75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101d78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d7b:	5b                   	pop    %ebx
80101d7c:	5e                   	pop    %esi
80101d7d:	5f                   	pop    %edi
80101d7e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101d7f:	ff e0                	jmp    *%eax
80101d81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101d88:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101d8b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101d8e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101d91:	50                   	push   %eax
80101d92:	e8 59 fa ff ff       	call   801017f0 <iupdate>
80101d97:	83 c4 10             	add    $0x10,%esp
80101d9a:	eb b5                	jmp    80101d51 <writei+0xd1>
80101d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101da0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101da5:	eb ad                	jmp    80101d54 <writei+0xd4>
80101da7:	89 f6                	mov    %esi,%esi
80101da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101db0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101db0:	55                   	push   %ebp
80101db1:	89 e5                	mov    %esp,%ebp
80101db3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101db6:	6a 0e                	push   $0xe
80101db8:	ff 75 0c             	pushl  0xc(%ebp)
80101dbb:	ff 75 08             	pushl  0x8(%ebp)
80101dbe:	e8 9d 2d 00 00       	call   80104b60 <strncmp>
}
80101dc3:	c9                   	leave  
80101dc4:	c3                   	ret    
80101dc5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101dd0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101dd0:	55                   	push   %ebp
80101dd1:	89 e5                	mov    %esp,%ebp
80101dd3:	57                   	push   %edi
80101dd4:	56                   	push   %esi
80101dd5:	53                   	push   %ebx
80101dd6:	83 ec 1c             	sub    $0x1c,%esp
80101dd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101ddc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101de1:	0f 85 85 00 00 00    	jne    80101e6c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101de7:	8b 53 58             	mov    0x58(%ebx),%edx
80101dea:	31 ff                	xor    %edi,%edi
80101dec:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101def:	85 d2                	test   %edx,%edx
80101df1:	74 3e                	je     80101e31 <dirlookup+0x61>
80101df3:	90                   	nop
80101df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101df8:	6a 10                	push   $0x10
80101dfa:	57                   	push   %edi
80101dfb:	56                   	push   %esi
80101dfc:	53                   	push   %ebx
80101dfd:	e8 7e fd ff ff       	call   80101b80 <readi>
80101e02:	83 c4 10             	add    $0x10,%esp
80101e05:	83 f8 10             	cmp    $0x10,%eax
80101e08:	75 55                	jne    80101e5f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101e0a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e0f:	74 18                	je     80101e29 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101e11:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e14:	83 ec 04             	sub    $0x4,%esp
80101e17:	6a 0e                	push   $0xe
80101e19:	50                   	push   %eax
80101e1a:	ff 75 0c             	pushl  0xc(%ebp)
80101e1d:	e8 3e 2d 00 00       	call   80104b60 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101e22:	83 c4 10             	add    $0x10,%esp
80101e25:	85 c0                	test   %eax,%eax
80101e27:	74 17                	je     80101e40 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e29:	83 c7 10             	add    $0x10,%edi
80101e2c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e2f:	72 c7                	jb     80101df8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101e31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101e34:	31 c0                	xor    %eax,%eax
}
80101e36:	5b                   	pop    %ebx
80101e37:	5e                   	pop    %esi
80101e38:	5f                   	pop    %edi
80101e39:	5d                   	pop    %ebp
80101e3a:	c3                   	ret    
80101e3b:	90                   	nop
80101e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101e40:	8b 45 10             	mov    0x10(%ebp),%eax
80101e43:	85 c0                	test   %eax,%eax
80101e45:	74 05                	je     80101e4c <dirlookup+0x7c>
        *poff = off;
80101e47:	8b 45 10             	mov    0x10(%ebp),%eax
80101e4a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101e4c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101e50:	8b 03                	mov    (%ebx),%eax
80101e52:	e8 59 f6 ff ff       	call   801014b0 <iget>
}
80101e57:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e5a:	5b                   	pop    %ebx
80101e5b:	5e                   	pop    %esi
80101e5c:	5f                   	pop    %edi
80101e5d:	5d                   	pop    %ebp
80101e5e:	c3                   	ret    
      panic("dirlookup read");
80101e5f:	83 ec 0c             	sub    $0xc,%esp
80101e62:	68 39 79 10 80       	push   $0x80107939
80101e67:	e8 24 e5 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101e6c:	83 ec 0c             	sub    $0xc,%esp
80101e6f:	68 27 79 10 80       	push   $0x80107927
80101e74:	e8 17 e5 ff ff       	call   80100390 <panic>
80101e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e80 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101e80:	55                   	push   %ebp
80101e81:	89 e5                	mov    %esp,%ebp
80101e83:	57                   	push   %edi
80101e84:	56                   	push   %esi
80101e85:	53                   	push   %ebx
80101e86:	89 cf                	mov    %ecx,%edi
80101e88:	89 c3                	mov    %eax,%ebx
80101e8a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101e8d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101e90:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101e93:	0f 84 67 01 00 00    	je     80102000 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101e99:	e8 72 1e 00 00       	call   80103d10 <myproc>
  acquire(&icache.lock);
80101e9e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101ea1:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101ea4:	68 e0 1a 11 80       	push   $0x80111ae0
80101ea9:	e8 82 2a 00 00       	call   80104930 <acquire>
  ip->ref++;
80101eae:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101eb2:	c7 04 24 e0 1a 11 80 	movl   $0x80111ae0,(%esp)
80101eb9:	e8 32 2b 00 00       	call   801049f0 <release>
80101ebe:	83 c4 10             	add    $0x10,%esp
80101ec1:	eb 08                	jmp    80101ecb <namex+0x4b>
80101ec3:	90                   	nop
80101ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ec8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ecb:	0f b6 03             	movzbl (%ebx),%eax
80101ece:	3c 2f                	cmp    $0x2f,%al
80101ed0:	74 f6                	je     80101ec8 <namex+0x48>
  if(*path == 0)
80101ed2:	84 c0                	test   %al,%al
80101ed4:	0f 84 ee 00 00 00    	je     80101fc8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101eda:	0f b6 03             	movzbl (%ebx),%eax
80101edd:	3c 2f                	cmp    $0x2f,%al
80101edf:	0f 84 b3 00 00 00    	je     80101f98 <namex+0x118>
80101ee5:	84 c0                	test   %al,%al
80101ee7:	89 da                	mov    %ebx,%edx
80101ee9:	75 09                	jne    80101ef4 <namex+0x74>
80101eeb:	e9 a8 00 00 00       	jmp    80101f98 <namex+0x118>
80101ef0:	84 c0                	test   %al,%al
80101ef2:	74 0a                	je     80101efe <namex+0x7e>
    path++;
80101ef4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101ef7:	0f b6 02             	movzbl (%edx),%eax
80101efa:	3c 2f                	cmp    $0x2f,%al
80101efc:	75 f2                	jne    80101ef0 <namex+0x70>
80101efe:	89 d1                	mov    %edx,%ecx
80101f00:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101f02:	83 f9 0d             	cmp    $0xd,%ecx
80101f05:	0f 8e 91 00 00 00    	jle    80101f9c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101f0b:	83 ec 04             	sub    $0x4,%esp
80101f0e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f11:	6a 0e                	push   $0xe
80101f13:	53                   	push   %ebx
80101f14:	57                   	push   %edi
80101f15:	e8 d6 2b 00 00       	call   80104af0 <memmove>
    path++;
80101f1a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101f1d:	83 c4 10             	add    $0x10,%esp
    path++;
80101f20:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101f22:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101f25:	75 11                	jne    80101f38 <namex+0xb8>
80101f27:	89 f6                	mov    %esi,%esi
80101f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101f30:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f33:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101f36:	74 f8                	je     80101f30 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101f38:	83 ec 0c             	sub    $0xc,%esp
80101f3b:	56                   	push   %esi
80101f3c:	e8 5f f9 ff ff       	call   801018a0 <ilock>
    if(ip->type != T_DIR){
80101f41:	83 c4 10             	add    $0x10,%esp
80101f44:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101f49:	0f 85 91 00 00 00    	jne    80101fe0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101f4f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f52:	85 d2                	test   %edx,%edx
80101f54:	74 09                	je     80101f5f <namex+0xdf>
80101f56:	80 3b 00             	cmpb   $0x0,(%ebx)
80101f59:	0f 84 b7 00 00 00    	je     80102016 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101f5f:	83 ec 04             	sub    $0x4,%esp
80101f62:	6a 00                	push   $0x0
80101f64:	57                   	push   %edi
80101f65:	56                   	push   %esi
80101f66:	e8 65 fe ff ff       	call   80101dd0 <dirlookup>
80101f6b:	83 c4 10             	add    $0x10,%esp
80101f6e:	85 c0                	test   %eax,%eax
80101f70:	74 6e                	je     80101fe0 <namex+0x160>
  iunlock(ip);
80101f72:	83 ec 0c             	sub    $0xc,%esp
80101f75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101f78:	56                   	push   %esi
80101f79:	e8 02 fa ff ff       	call   80101980 <iunlock>
  iput(ip);
80101f7e:	89 34 24             	mov    %esi,(%esp)
80101f81:	e8 4a fa ff ff       	call   801019d0 <iput>
80101f86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101f89:	83 c4 10             	add    $0x10,%esp
80101f8c:	89 c6                	mov    %eax,%esi
80101f8e:	e9 38 ff ff ff       	jmp    80101ecb <namex+0x4b>
80101f93:	90                   	nop
80101f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101f98:	89 da                	mov    %ebx,%edx
80101f9a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101f9c:	83 ec 04             	sub    $0x4,%esp
80101f9f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101fa2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101fa5:	51                   	push   %ecx
80101fa6:	53                   	push   %ebx
80101fa7:	57                   	push   %edi
80101fa8:	e8 43 2b 00 00       	call   80104af0 <memmove>
    name[len] = 0;
80101fad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101fb0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101fb3:	83 c4 10             	add    $0x10,%esp
80101fb6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101fba:	89 d3                	mov    %edx,%ebx
80101fbc:	e9 61 ff ff ff       	jmp    80101f22 <namex+0xa2>
80101fc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101fc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101fcb:	85 c0                	test   %eax,%eax
80101fcd:	75 5d                	jne    8010202c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101fcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fd2:	89 f0                	mov    %esi,%eax
80101fd4:	5b                   	pop    %ebx
80101fd5:	5e                   	pop    %esi
80101fd6:	5f                   	pop    %edi
80101fd7:	5d                   	pop    %ebp
80101fd8:	c3                   	ret    
80101fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101fe0:	83 ec 0c             	sub    $0xc,%esp
80101fe3:	56                   	push   %esi
80101fe4:	e8 97 f9 ff ff       	call   80101980 <iunlock>
  iput(ip);
80101fe9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101fec:	31 f6                	xor    %esi,%esi
  iput(ip);
80101fee:	e8 dd f9 ff ff       	call   801019d0 <iput>
      return 0;
80101ff3:	83 c4 10             	add    $0x10,%esp
}
80101ff6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ff9:	89 f0                	mov    %esi,%eax
80101ffb:	5b                   	pop    %ebx
80101ffc:	5e                   	pop    %esi
80101ffd:	5f                   	pop    %edi
80101ffe:	5d                   	pop    %ebp
80101fff:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80102000:	ba 01 00 00 00       	mov    $0x1,%edx
80102005:	b8 01 00 00 00       	mov    $0x1,%eax
8010200a:	e8 a1 f4 ff ff       	call   801014b0 <iget>
8010200f:	89 c6                	mov    %eax,%esi
80102011:	e9 b5 fe ff ff       	jmp    80101ecb <namex+0x4b>
      iunlock(ip);
80102016:	83 ec 0c             	sub    $0xc,%esp
80102019:	56                   	push   %esi
8010201a:	e8 61 f9 ff ff       	call   80101980 <iunlock>
      return ip;
8010201f:	83 c4 10             	add    $0x10,%esp
}
80102022:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102025:	89 f0                	mov    %esi,%eax
80102027:	5b                   	pop    %ebx
80102028:	5e                   	pop    %esi
80102029:	5f                   	pop    %edi
8010202a:	5d                   	pop    %ebp
8010202b:	c3                   	ret    
    iput(ip);
8010202c:	83 ec 0c             	sub    $0xc,%esp
8010202f:	56                   	push   %esi
    return 0;
80102030:	31 f6                	xor    %esi,%esi
    iput(ip);
80102032:	e8 99 f9 ff ff       	call   801019d0 <iput>
    return 0;
80102037:	83 c4 10             	add    $0x10,%esp
8010203a:	eb 93                	jmp    80101fcf <namex+0x14f>
8010203c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102040 <dirlink>:
{
80102040:	55                   	push   %ebp
80102041:	89 e5                	mov    %esp,%ebp
80102043:	57                   	push   %edi
80102044:	56                   	push   %esi
80102045:	53                   	push   %ebx
80102046:	83 ec 20             	sub    $0x20,%esp
80102049:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010204c:	6a 00                	push   $0x0
8010204e:	ff 75 0c             	pushl  0xc(%ebp)
80102051:	53                   	push   %ebx
80102052:	e8 79 fd ff ff       	call   80101dd0 <dirlookup>
80102057:	83 c4 10             	add    $0x10,%esp
8010205a:	85 c0                	test   %eax,%eax
8010205c:	75 67                	jne    801020c5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010205e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102061:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102064:	85 ff                	test   %edi,%edi
80102066:	74 29                	je     80102091 <dirlink+0x51>
80102068:	31 ff                	xor    %edi,%edi
8010206a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010206d:	eb 09                	jmp    80102078 <dirlink+0x38>
8010206f:	90                   	nop
80102070:	83 c7 10             	add    $0x10,%edi
80102073:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102076:	73 19                	jae    80102091 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102078:	6a 10                	push   $0x10
8010207a:	57                   	push   %edi
8010207b:	56                   	push   %esi
8010207c:	53                   	push   %ebx
8010207d:	e8 fe fa ff ff       	call   80101b80 <readi>
80102082:	83 c4 10             	add    $0x10,%esp
80102085:	83 f8 10             	cmp    $0x10,%eax
80102088:	75 4e                	jne    801020d8 <dirlink+0x98>
    if(de.inum == 0)
8010208a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010208f:	75 df                	jne    80102070 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102091:	8d 45 da             	lea    -0x26(%ebp),%eax
80102094:	83 ec 04             	sub    $0x4,%esp
80102097:	6a 0e                	push   $0xe
80102099:	ff 75 0c             	pushl  0xc(%ebp)
8010209c:	50                   	push   %eax
8010209d:	e8 1e 2b 00 00       	call   80104bc0 <strncpy>
  de.inum = inum;
801020a2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020a5:	6a 10                	push   $0x10
801020a7:	57                   	push   %edi
801020a8:	56                   	push   %esi
801020a9:	53                   	push   %ebx
  de.inum = inum;
801020aa:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020ae:	e8 cd fb ff ff       	call   80101c80 <writei>
801020b3:	83 c4 20             	add    $0x20,%esp
801020b6:	83 f8 10             	cmp    $0x10,%eax
801020b9:	75 2a                	jne    801020e5 <dirlink+0xa5>
  return 0;
801020bb:	31 c0                	xor    %eax,%eax
}
801020bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020c0:	5b                   	pop    %ebx
801020c1:	5e                   	pop    %esi
801020c2:	5f                   	pop    %edi
801020c3:	5d                   	pop    %ebp
801020c4:	c3                   	ret    
    iput(ip);
801020c5:	83 ec 0c             	sub    $0xc,%esp
801020c8:	50                   	push   %eax
801020c9:	e8 02 f9 ff ff       	call   801019d0 <iput>
    return -1;
801020ce:	83 c4 10             	add    $0x10,%esp
801020d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020d6:	eb e5                	jmp    801020bd <dirlink+0x7d>
      panic("dirlink read");
801020d8:	83 ec 0c             	sub    $0xc,%esp
801020db:	68 48 79 10 80       	push   $0x80107948
801020e0:	e8 ab e2 ff ff       	call   80100390 <panic>
    panic("dirlink");
801020e5:	83 ec 0c             	sub    $0xc,%esp
801020e8:	68 e2 7f 10 80       	push   $0x80107fe2
801020ed:	e8 9e e2 ff ff       	call   80100390 <panic>
801020f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102100 <namei>:

struct inode*
namei(char *path)
{
80102100:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102101:	31 d2                	xor    %edx,%edx
{
80102103:	89 e5                	mov    %esp,%ebp
80102105:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102108:	8b 45 08             	mov    0x8(%ebp),%eax
8010210b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010210e:	e8 6d fd ff ff       	call   80101e80 <namex>
}
80102113:	c9                   	leave  
80102114:	c3                   	ret    
80102115:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102120 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102120:	55                   	push   %ebp
  return namex(path, 1, name);
80102121:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102126:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102128:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010212b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010212e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010212f:	e9 4c fd ff ff       	jmp    80101e80 <namex>
80102134:	66 90                	xchg   %ax,%ax
80102136:	66 90                	xchg   %ax,%ax
80102138:	66 90                	xchg   %ax,%ax
8010213a:	66 90                	xchg   %ax,%ax
8010213c:	66 90                	xchg   %ax,%ax
8010213e:	66 90                	xchg   %ax,%ax

80102140 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102140:	55                   	push   %ebp
80102141:	89 e5                	mov    %esp,%ebp
80102143:	57                   	push   %edi
80102144:	56                   	push   %esi
80102145:	53                   	push   %ebx
80102146:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102149:	85 c0                	test   %eax,%eax
8010214b:	0f 84 b4 00 00 00    	je     80102205 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102151:	8b 58 08             	mov    0x8(%eax),%ebx
80102154:	89 c6                	mov    %eax,%esi
80102156:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
8010215c:	0f 87 96 00 00 00    	ja     801021f8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102162:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102167:	89 f6                	mov    %esi,%esi
80102169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102170:	89 ca                	mov    %ecx,%edx
80102172:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102173:	83 e0 c0             	and    $0xffffffc0,%eax
80102176:	3c 40                	cmp    $0x40,%al
80102178:	75 f6                	jne    80102170 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010217a:	31 ff                	xor    %edi,%edi
8010217c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102181:	89 f8                	mov    %edi,%eax
80102183:	ee                   	out    %al,(%dx)
80102184:	b8 01 00 00 00       	mov    $0x1,%eax
80102189:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010218e:	ee                   	out    %al,(%dx)
8010218f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102194:	89 d8                	mov    %ebx,%eax
80102196:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102197:	89 d8                	mov    %ebx,%eax
80102199:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010219e:	c1 f8 08             	sar    $0x8,%eax
801021a1:	ee                   	out    %al,(%dx)
801021a2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801021a7:	89 f8                	mov    %edi,%eax
801021a9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801021aa:	0f b6 46 04          	movzbl 0x4(%esi),%eax
801021ae:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021b3:	c1 e0 04             	shl    $0x4,%eax
801021b6:	83 e0 10             	and    $0x10,%eax
801021b9:	83 c8 e0             	or     $0xffffffe0,%eax
801021bc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801021bd:	f6 06 04             	testb  $0x4,(%esi)
801021c0:	75 16                	jne    801021d8 <idestart+0x98>
801021c2:	b8 20 00 00 00       	mov    $0x20,%eax
801021c7:	89 ca                	mov    %ecx,%edx
801021c9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801021ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021cd:	5b                   	pop    %ebx
801021ce:	5e                   	pop    %esi
801021cf:	5f                   	pop    %edi
801021d0:	5d                   	pop    %ebp
801021d1:	c3                   	ret    
801021d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021d8:	b8 30 00 00 00       	mov    $0x30,%eax
801021dd:	89 ca                	mov    %ecx,%edx
801021df:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801021e0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801021e5:	83 c6 5c             	add    $0x5c,%esi
801021e8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021ed:	fc                   	cld    
801021ee:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801021f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021f3:	5b                   	pop    %ebx
801021f4:	5e                   	pop    %esi
801021f5:	5f                   	pop    %edi
801021f6:	5d                   	pop    %ebp
801021f7:	c3                   	ret    
    panic("incorrect blockno");
801021f8:	83 ec 0c             	sub    $0xc,%esp
801021fb:	68 b4 79 10 80       	push   $0x801079b4
80102200:	e8 8b e1 ff ff       	call   80100390 <panic>
    panic("idestart");
80102205:	83 ec 0c             	sub    $0xc,%esp
80102208:	68 ab 79 10 80       	push   $0x801079ab
8010220d:	e8 7e e1 ff ff       	call   80100390 <panic>
80102212:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102220 <ideinit>:
{
80102220:	55                   	push   %ebp
80102221:	89 e5                	mov    %esp,%ebp
80102223:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102226:	68 c6 79 10 80       	push   $0x801079c6
8010222b:	68 00 b6 10 80       	push   $0x8010b600
80102230:	e8 bb 25 00 00       	call   801047f0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102235:	58                   	pop    %eax
80102236:	a1 00 3e 11 80       	mov    0x80113e00,%eax
8010223b:	5a                   	pop    %edx
8010223c:	83 e8 01             	sub    $0x1,%eax
8010223f:	50                   	push   %eax
80102240:	6a 0e                	push   $0xe
80102242:	e8 a9 02 00 00       	call   801024f0 <ioapicenable>
80102247:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010224a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010224f:	90                   	nop
80102250:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102251:	83 e0 c0             	and    $0xffffffc0,%eax
80102254:	3c 40                	cmp    $0x40,%al
80102256:	75 f8                	jne    80102250 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102258:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010225d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102262:	ee                   	out    %al,(%dx)
80102263:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102268:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010226d:	eb 06                	jmp    80102275 <ideinit+0x55>
8010226f:	90                   	nop
  for(i=0; i<1000; i++){
80102270:	83 e9 01             	sub    $0x1,%ecx
80102273:	74 0f                	je     80102284 <ideinit+0x64>
80102275:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102276:	84 c0                	test   %al,%al
80102278:	74 f6                	je     80102270 <ideinit+0x50>
      havedisk1 = 1;
8010227a:	c7 05 e0 b5 10 80 01 	movl   $0x1,0x8010b5e0
80102281:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102284:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102289:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010228e:	ee                   	out    %al,(%dx)
}
8010228f:	c9                   	leave  
80102290:	c3                   	ret    
80102291:	eb 0d                	jmp    801022a0 <ideintr>
80102293:	90                   	nop
80102294:	90                   	nop
80102295:	90                   	nop
80102296:	90                   	nop
80102297:	90                   	nop
80102298:	90                   	nop
80102299:	90                   	nop
8010229a:	90                   	nop
8010229b:	90                   	nop
8010229c:	90                   	nop
8010229d:	90                   	nop
8010229e:	90                   	nop
8010229f:	90                   	nop

801022a0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801022a0:	55                   	push   %ebp
801022a1:	89 e5                	mov    %esp,%ebp
801022a3:	57                   	push   %edi
801022a4:	56                   	push   %esi
801022a5:	53                   	push   %ebx
801022a6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801022a9:	68 00 b6 10 80       	push   $0x8010b600
801022ae:	e8 7d 26 00 00       	call   80104930 <acquire>

  if((b = idequeue) == 0){
801022b3:	8b 1d e4 b5 10 80    	mov    0x8010b5e4,%ebx
801022b9:	83 c4 10             	add    $0x10,%esp
801022bc:	85 db                	test   %ebx,%ebx
801022be:	74 67                	je     80102327 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801022c0:	8b 43 58             	mov    0x58(%ebx),%eax
801022c3:	a3 e4 b5 10 80       	mov    %eax,0x8010b5e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801022c8:	8b 3b                	mov    (%ebx),%edi
801022ca:	f7 c7 04 00 00 00    	test   $0x4,%edi
801022d0:	75 31                	jne    80102303 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022d2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022d7:	89 f6                	mov    %esi,%esi
801022d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801022e0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022e1:	89 c6                	mov    %eax,%esi
801022e3:	83 e6 c0             	and    $0xffffffc0,%esi
801022e6:	89 f1                	mov    %esi,%ecx
801022e8:	80 f9 40             	cmp    $0x40,%cl
801022eb:	75 f3                	jne    801022e0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801022ed:	a8 21                	test   $0x21,%al
801022ef:	75 12                	jne    80102303 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801022f1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801022f4:	b9 80 00 00 00       	mov    $0x80,%ecx
801022f9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022fe:	fc                   	cld    
801022ff:	f3 6d                	rep insl (%dx),%es:(%edi)
80102301:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102303:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102306:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102309:	89 f9                	mov    %edi,%ecx
8010230b:	83 c9 02             	or     $0x2,%ecx
8010230e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102310:	53                   	push   %ebx
80102311:	e8 fa 21 00 00       	call   80104510 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102316:	a1 e4 b5 10 80       	mov    0x8010b5e4,%eax
8010231b:	83 c4 10             	add    $0x10,%esp
8010231e:	85 c0                	test   %eax,%eax
80102320:	74 05                	je     80102327 <ideintr+0x87>
    idestart(idequeue);
80102322:	e8 19 fe ff ff       	call   80102140 <idestart>
    release(&idelock);
80102327:	83 ec 0c             	sub    $0xc,%esp
8010232a:	68 00 b6 10 80       	push   $0x8010b600
8010232f:	e8 bc 26 00 00       	call   801049f0 <release>

  release(&idelock);
}
80102334:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102337:	5b                   	pop    %ebx
80102338:	5e                   	pop    %esi
80102339:	5f                   	pop    %edi
8010233a:	5d                   	pop    %ebp
8010233b:	c3                   	ret    
8010233c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102340 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102340:	55                   	push   %ebp
80102341:	89 e5                	mov    %esp,%ebp
80102343:	53                   	push   %ebx
80102344:	83 ec 10             	sub    $0x10,%esp
80102347:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010234a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010234d:	50                   	push   %eax
8010234e:	e8 4d 24 00 00       	call   801047a0 <holdingsleep>
80102353:	83 c4 10             	add    $0x10,%esp
80102356:	85 c0                	test   %eax,%eax
80102358:	0f 84 c6 00 00 00    	je     80102424 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010235e:	8b 03                	mov    (%ebx),%eax
80102360:	83 e0 06             	and    $0x6,%eax
80102363:	83 f8 02             	cmp    $0x2,%eax
80102366:	0f 84 ab 00 00 00    	je     80102417 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010236c:	8b 53 04             	mov    0x4(%ebx),%edx
8010236f:	85 d2                	test   %edx,%edx
80102371:	74 0d                	je     80102380 <iderw+0x40>
80102373:	a1 e0 b5 10 80       	mov    0x8010b5e0,%eax
80102378:	85 c0                	test   %eax,%eax
8010237a:	0f 84 b1 00 00 00    	je     80102431 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102380:	83 ec 0c             	sub    $0xc,%esp
80102383:	68 00 b6 10 80       	push   $0x8010b600
80102388:	e8 a3 25 00 00       	call   80104930 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010238d:	8b 15 e4 b5 10 80    	mov    0x8010b5e4,%edx
80102393:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102396:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010239d:	85 d2                	test   %edx,%edx
8010239f:	75 09                	jne    801023aa <iderw+0x6a>
801023a1:	eb 6d                	jmp    80102410 <iderw+0xd0>
801023a3:	90                   	nop
801023a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023a8:	89 c2                	mov    %eax,%edx
801023aa:	8b 42 58             	mov    0x58(%edx),%eax
801023ad:	85 c0                	test   %eax,%eax
801023af:	75 f7                	jne    801023a8 <iderw+0x68>
801023b1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801023b4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801023b6:	39 1d e4 b5 10 80    	cmp    %ebx,0x8010b5e4
801023bc:	74 42                	je     80102400 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023be:	8b 03                	mov    (%ebx),%eax
801023c0:	83 e0 06             	and    $0x6,%eax
801023c3:	83 f8 02             	cmp    $0x2,%eax
801023c6:	74 23                	je     801023eb <iderw+0xab>
801023c8:	90                   	nop
801023c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801023d0:	83 ec 08             	sub    $0x8,%esp
801023d3:	68 00 b6 10 80       	push   $0x8010b600
801023d8:	53                   	push   %ebx
801023d9:	e8 72 1f 00 00       	call   80104350 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023de:	8b 03                	mov    (%ebx),%eax
801023e0:	83 c4 10             	add    $0x10,%esp
801023e3:	83 e0 06             	and    $0x6,%eax
801023e6:	83 f8 02             	cmp    $0x2,%eax
801023e9:	75 e5                	jne    801023d0 <iderw+0x90>
  }


  release(&idelock);
801023eb:	c7 45 08 00 b6 10 80 	movl   $0x8010b600,0x8(%ebp)
}
801023f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023f5:	c9                   	leave  
  release(&idelock);
801023f6:	e9 f5 25 00 00       	jmp    801049f0 <release>
801023fb:	90                   	nop
801023fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102400:	89 d8                	mov    %ebx,%eax
80102402:	e8 39 fd ff ff       	call   80102140 <idestart>
80102407:	eb b5                	jmp    801023be <iderw+0x7e>
80102409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102410:	ba e4 b5 10 80       	mov    $0x8010b5e4,%edx
80102415:	eb 9d                	jmp    801023b4 <iderw+0x74>
    panic("iderw: nothing to do");
80102417:	83 ec 0c             	sub    $0xc,%esp
8010241a:	68 e0 79 10 80       	push   $0x801079e0
8010241f:	e8 6c df ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102424:	83 ec 0c             	sub    $0xc,%esp
80102427:	68 ca 79 10 80       	push   $0x801079ca
8010242c:	e8 5f df ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102431:	83 ec 0c             	sub    $0xc,%esp
80102434:	68 f5 79 10 80       	push   $0x801079f5
80102439:	e8 52 df ff ff       	call   80100390 <panic>
8010243e:	66 90                	xchg   %ax,%ax

80102440 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102440:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102441:	c7 05 34 37 11 80 00 	movl   $0xfec00000,0x80113734
80102448:	00 c0 fe 
{
8010244b:	89 e5                	mov    %esp,%ebp
8010244d:	56                   	push   %esi
8010244e:	53                   	push   %ebx
  ioapic->reg = reg;
8010244f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102456:	00 00 00 
  return ioapic->data;
80102459:	a1 34 37 11 80       	mov    0x80113734,%eax
8010245e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102461:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102467:	8b 0d 34 37 11 80    	mov    0x80113734,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010246d:	0f b6 15 60 38 11 80 	movzbl 0x80113860,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102474:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102477:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010247a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010247d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102480:	39 c2                	cmp    %eax,%edx
80102482:	74 16                	je     8010249a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102484:	83 ec 0c             	sub    $0xc,%esp
80102487:	68 14 7a 10 80       	push   $0x80107a14
8010248c:	e8 cf e1 ff ff       	call   80100660 <cprintf>
80102491:	8b 0d 34 37 11 80    	mov    0x80113734,%ecx
80102497:	83 c4 10             	add    $0x10,%esp
8010249a:	83 c3 21             	add    $0x21,%ebx
{
8010249d:	ba 10 00 00 00       	mov    $0x10,%edx
801024a2:	b8 20 00 00 00       	mov    $0x20,%eax
801024a7:	89 f6                	mov    %esi,%esi
801024a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801024b0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801024b2:	8b 0d 34 37 11 80    	mov    0x80113734,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801024b8:	89 c6                	mov    %eax,%esi
801024ba:	81 ce 00 00 01 00    	or     $0x10000,%esi
801024c0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024c3:	89 71 10             	mov    %esi,0x10(%ecx)
801024c6:	8d 72 01             	lea    0x1(%edx),%esi
801024c9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801024cc:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801024ce:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801024d0:	8b 0d 34 37 11 80    	mov    0x80113734,%ecx
801024d6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801024dd:	75 d1                	jne    801024b0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801024df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024e2:	5b                   	pop    %ebx
801024e3:	5e                   	pop    %esi
801024e4:	5d                   	pop    %ebp
801024e5:	c3                   	ret    
801024e6:	8d 76 00             	lea    0x0(%esi),%esi
801024e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024f0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801024f0:	55                   	push   %ebp
  ioapic->reg = reg;
801024f1:	8b 0d 34 37 11 80    	mov    0x80113734,%ecx
{
801024f7:	89 e5                	mov    %esp,%ebp
801024f9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801024fc:	8d 50 20             	lea    0x20(%eax),%edx
801024ff:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102503:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102505:	8b 0d 34 37 11 80    	mov    0x80113734,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010250b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010250e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102511:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102514:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102516:	a1 34 37 11 80       	mov    0x80113734,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010251b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010251e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102521:	5d                   	pop    %ebp
80102522:	c3                   	ret    
80102523:	66 90                	xchg   %ax,%ax
80102525:	66 90                	xchg   %ax,%ax
80102527:	66 90                	xchg   %ax,%ax
80102529:	66 90                	xchg   %ax,%ax
8010252b:	66 90                	xchg   %ax,%ax
8010252d:	66 90                	xchg   %ax,%ax
8010252f:	90                   	nop

80102530 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102530:	55                   	push   %ebp
80102531:	89 e5                	mov    %esp,%ebp
80102533:	53                   	push   %ebx
80102534:	83 ec 04             	sub    $0x4,%esp
80102537:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010253a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102540:	75 70                	jne    801025b2 <kfree+0x82>
80102542:	81 fb a8 83 11 80    	cmp    $0x801183a8,%ebx
80102548:	72 68                	jb     801025b2 <kfree+0x82>
8010254a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102550:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102555:	77 5b                	ja     801025b2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102557:	83 ec 04             	sub    $0x4,%esp
8010255a:	68 00 10 00 00       	push   $0x1000
8010255f:	6a 01                	push   $0x1
80102561:	53                   	push   %ebx
80102562:	e8 d9 24 00 00       	call   80104a40 <memset>

  if(kmem.use_lock)
80102567:	8b 15 74 37 11 80    	mov    0x80113774,%edx
8010256d:	83 c4 10             	add    $0x10,%esp
80102570:	85 d2                	test   %edx,%edx
80102572:	75 2c                	jne    801025a0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102574:	a1 78 37 11 80       	mov    0x80113778,%eax
80102579:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010257b:	a1 74 37 11 80       	mov    0x80113774,%eax
  kmem.freelist = r;
80102580:	89 1d 78 37 11 80    	mov    %ebx,0x80113778
  if(kmem.use_lock)
80102586:	85 c0                	test   %eax,%eax
80102588:	75 06                	jne    80102590 <kfree+0x60>
    release(&kmem.lock);
}
8010258a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010258d:	c9                   	leave  
8010258e:	c3                   	ret    
8010258f:	90                   	nop
    release(&kmem.lock);
80102590:	c7 45 08 40 37 11 80 	movl   $0x80113740,0x8(%ebp)
}
80102597:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010259a:	c9                   	leave  
    release(&kmem.lock);
8010259b:	e9 50 24 00 00       	jmp    801049f0 <release>
    acquire(&kmem.lock);
801025a0:	83 ec 0c             	sub    $0xc,%esp
801025a3:	68 40 37 11 80       	push   $0x80113740
801025a8:	e8 83 23 00 00       	call   80104930 <acquire>
801025ad:	83 c4 10             	add    $0x10,%esp
801025b0:	eb c2                	jmp    80102574 <kfree+0x44>
    panic("kfree");
801025b2:	83 ec 0c             	sub    $0xc,%esp
801025b5:	68 46 7a 10 80       	push   $0x80107a46
801025ba:	e8 d1 dd ff ff       	call   80100390 <panic>
801025bf:	90                   	nop

801025c0 <freerange>:
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	56                   	push   %esi
801025c4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025c5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801025cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025dd:	39 de                	cmp    %ebx,%esi
801025df:	72 23                	jb     80102604 <freerange+0x44>
801025e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025e8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801025ee:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025f7:	50                   	push   %eax
801025f8:	e8 33 ff ff ff       	call   80102530 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025fd:	83 c4 10             	add    $0x10,%esp
80102600:	39 f3                	cmp    %esi,%ebx
80102602:	76 e4                	jbe    801025e8 <freerange+0x28>
}
80102604:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102607:	5b                   	pop    %ebx
80102608:	5e                   	pop    %esi
80102609:	5d                   	pop    %ebp
8010260a:	c3                   	ret    
8010260b:	90                   	nop
8010260c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102610 <kinit1>:
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	56                   	push   %esi
80102614:	53                   	push   %ebx
80102615:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102618:	83 ec 08             	sub    $0x8,%esp
8010261b:	68 4c 7a 10 80       	push   $0x80107a4c
80102620:	68 40 37 11 80       	push   $0x80113740
80102625:	e8 c6 21 00 00       	call   801047f0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010262a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010262d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102630:	c7 05 74 37 11 80 00 	movl   $0x0,0x80113774
80102637:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010263a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102640:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102646:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010264c:	39 de                	cmp    %ebx,%esi
8010264e:	72 1c                	jb     8010266c <kinit1+0x5c>
    kfree(p);
80102650:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102656:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102659:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010265f:	50                   	push   %eax
80102660:	e8 cb fe ff ff       	call   80102530 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102665:	83 c4 10             	add    $0x10,%esp
80102668:	39 de                	cmp    %ebx,%esi
8010266a:	73 e4                	jae    80102650 <kinit1+0x40>
}
8010266c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010266f:	5b                   	pop    %ebx
80102670:	5e                   	pop    %esi
80102671:	5d                   	pop    %ebp
80102672:	c3                   	ret    
80102673:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102680 <kinit2>:
{
80102680:	55                   	push   %ebp
80102681:	89 e5                	mov    %esp,%ebp
80102683:	56                   	push   %esi
80102684:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102685:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102688:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010268b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102691:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102697:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010269d:	39 de                	cmp    %ebx,%esi
8010269f:	72 23                	jb     801026c4 <kinit2+0x44>
801026a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801026a8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801026ae:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026b7:	50                   	push   %eax
801026b8:	e8 73 fe ff ff       	call   80102530 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026bd:	83 c4 10             	add    $0x10,%esp
801026c0:	39 de                	cmp    %ebx,%esi
801026c2:	73 e4                	jae    801026a8 <kinit2+0x28>
  kmem.use_lock = 1;
801026c4:	c7 05 74 37 11 80 01 	movl   $0x1,0x80113774
801026cb:	00 00 00 
}
801026ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026d1:	5b                   	pop    %ebx
801026d2:	5e                   	pop    %esi
801026d3:	5d                   	pop    %ebp
801026d4:	c3                   	ret    
801026d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026e0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801026e0:	a1 74 37 11 80       	mov    0x80113774,%eax
801026e5:	85 c0                	test   %eax,%eax
801026e7:	75 1f                	jne    80102708 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801026e9:	a1 78 37 11 80       	mov    0x80113778,%eax
  if(r)
801026ee:	85 c0                	test   %eax,%eax
801026f0:	74 0e                	je     80102700 <kalloc+0x20>
    kmem.freelist = r->next;
801026f2:	8b 10                	mov    (%eax),%edx
801026f4:	89 15 78 37 11 80    	mov    %edx,0x80113778
801026fa:	c3                   	ret    
801026fb:	90                   	nop
801026fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102700:	f3 c3                	repz ret 
80102702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102708:	55                   	push   %ebp
80102709:	89 e5                	mov    %esp,%ebp
8010270b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010270e:	68 40 37 11 80       	push   $0x80113740
80102713:	e8 18 22 00 00       	call   80104930 <acquire>
  r = kmem.freelist;
80102718:	a1 78 37 11 80       	mov    0x80113778,%eax
  if(r)
8010271d:	83 c4 10             	add    $0x10,%esp
80102720:	8b 15 74 37 11 80    	mov    0x80113774,%edx
80102726:	85 c0                	test   %eax,%eax
80102728:	74 08                	je     80102732 <kalloc+0x52>
    kmem.freelist = r->next;
8010272a:	8b 08                	mov    (%eax),%ecx
8010272c:	89 0d 78 37 11 80    	mov    %ecx,0x80113778
  if(kmem.use_lock)
80102732:	85 d2                	test   %edx,%edx
80102734:	74 16                	je     8010274c <kalloc+0x6c>
    release(&kmem.lock);
80102736:	83 ec 0c             	sub    $0xc,%esp
80102739:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010273c:	68 40 37 11 80       	push   $0x80113740
80102741:	e8 aa 22 00 00       	call   801049f0 <release>
  return (char*)r;
80102746:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102749:	83 c4 10             	add    $0x10,%esp
}
8010274c:	c9                   	leave  
8010274d:	c3                   	ret    
8010274e:	66 90                	xchg   %ax,%ax

80102750 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102750:	ba 64 00 00 00       	mov    $0x64,%edx
80102755:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102756:	a8 01                	test   $0x1,%al
80102758:	0f 84 c2 00 00 00    	je     80102820 <kbdgetc+0xd0>
8010275e:	ba 60 00 00 00       	mov    $0x60,%edx
80102763:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102764:	0f b6 d0             	movzbl %al,%edx
80102767:	8b 0d 34 b6 10 80    	mov    0x8010b634,%ecx

  if(data == 0xE0){
8010276d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102773:	0f 84 7f 00 00 00    	je     801027f8 <kbdgetc+0xa8>
{
80102779:	55                   	push   %ebp
8010277a:	89 e5                	mov    %esp,%ebp
8010277c:	53                   	push   %ebx
8010277d:	89 cb                	mov    %ecx,%ebx
8010277f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102782:	84 c0                	test   %al,%al
80102784:	78 4a                	js     801027d0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102786:	85 db                	test   %ebx,%ebx
80102788:	74 09                	je     80102793 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010278a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010278d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102790:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102793:	0f b6 82 80 7b 10 80 	movzbl -0x7fef8480(%edx),%eax
8010279a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010279c:	0f b6 82 80 7a 10 80 	movzbl -0x7fef8580(%edx),%eax
801027a3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801027a5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801027a7:	89 0d 34 b6 10 80    	mov    %ecx,0x8010b634
  c = charcode[shift & (CTL | SHIFT)][data];
801027ad:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801027b0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801027b3:	8b 04 85 60 7a 10 80 	mov    -0x7fef85a0(,%eax,4),%eax
801027ba:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801027be:	74 31                	je     801027f1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801027c0:	8d 50 9f             	lea    -0x61(%eax),%edx
801027c3:	83 fa 19             	cmp    $0x19,%edx
801027c6:	77 40                	ja     80102808 <kbdgetc+0xb8>
      c += 'A' - 'a';
801027c8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801027cb:	5b                   	pop    %ebx
801027cc:	5d                   	pop    %ebp
801027cd:	c3                   	ret    
801027ce:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801027d0:	83 e0 7f             	and    $0x7f,%eax
801027d3:	85 db                	test   %ebx,%ebx
801027d5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801027d8:	0f b6 82 80 7b 10 80 	movzbl -0x7fef8480(%edx),%eax
801027df:	83 c8 40             	or     $0x40,%eax
801027e2:	0f b6 c0             	movzbl %al,%eax
801027e5:	f7 d0                	not    %eax
801027e7:	21 c1                	and    %eax,%ecx
    return 0;
801027e9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801027eb:	89 0d 34 b6 10 80    	mov    %ecx,0x8010b634
}
801027f1:	5b                   	pop    %ebx
801027f2:	5d                   	pop    %ebp
801027f3:	c3                   	ret    
801027f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801027f8:	83 c9 40             	or     $0x40,%ecx
    return 0;
801027fb:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801027fd:	89 0d 34 b6 10 80    	mov    %ecx,0x8010b634
    return 0;
80102803:	c3                   	ret    
80102804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102808:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010280b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010280e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010280f:	83 f9 1a             	cmp    $0x1a,%ecx
80102812:	0f 42 c2             	cmovb  %edx,%eax
}
80102815:	5d                   	pop    %ebp
80102816:	c3                   	ret    
80102817:	89 f6                	mov    %esi,%esi
80102819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102820:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102825:	c3                   	ret    
80102826:	8d 76 00             	lea    0x0(%esi),%esi
80102829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102830 <kbdintr>:

void
kbdintr(void)
{
80102830:	55                   	push   %ebp
80102831:	89 e5                	mov    %esp,%ebp
80102833:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102836:	68 50 27 10 80       	push   $0x80102750
8010283b:	e8 d0 df ff ff       	call   80100810 <consoleintr>
}
80102840:	83 c4 10             	add    $0x10,%esp
80102843:	c9                   	leave  
80102844:	c3                   	ret    
80102845:	66 90                	xchg   %ax,%ax
80102847:	66 90                	xchg   %ax,%ax
80102849:	66 90                	xchg   %ax,%ax
8010284b:	66 90                	xchg   %ax,%ax
8010284d:	66 90                	xchg   %ax,%ax
8010284f:	90                   	nop

80102850 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102850:	a1 7c 37 11 80       	mov    0x8011377c,%eax
{
80102855:	55                   	push   %ebp
80102856:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102858:	85 c0                	test   %eax,%eax
8010285a:	0f 84 c8 00 00 00    	je     80102928 <lapicinit+0xd8>
  lapic[index] = value;
80102860:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102867:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010286a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010286d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102874:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102877:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010287a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102881:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102884:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102887:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010288e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102891:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102894:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010289b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010289e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028a1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801028a8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028ab:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801028ae:	8b 50 30             	mov    0x30(%eax),%edx
801028b1:	c1 ea 10             	shr    $0x10,%edx
801028b4:	80 fa 03             	cmp    $0x3,%dl
801028b7:	77 77                	ja     80102930 <lapicinit+0xe0>
  lapic[index] = value;
801028b9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801028c0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028c6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028cd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028d3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028da:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028dd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028e0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028e7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028ea:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ed:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801028f4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028f7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028fa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102901:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102904:	8b 50 20             	mov    0x20(%eax),%edx
80102907:	89 f6                	mov    %esi,%esi
80102909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102910:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102916:	80 e6 10             	and    $0x10,%dh
80102919:	75 f5                	jne    80102910 <lapicinit+0xc0>
  lapic[index] = value;
8010291b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102922:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102925:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102928:	5d                   	pop    %ebp
80102929:	c3                   	ret    
8010292a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102930:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102937:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010293a:	8b 50 20             	mov    0x20(%eax),%edx
8010293d:	e9 77 ff ff ff       	jmp    801028b9 <lapicinit+0x69>
80102942:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102950 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102950:	8b 15 7c 37 11 80    	mov    0x8011377c,%edx
{
80102956:	55                   	push   %ebp
80102957:	31 c0                	xor    %eax,%eax
80102959:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010295b:	85 d2                	test   %edx,%edx
8010295d:	74 06                	je     80102965 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010295f:	8b 42 20             	mov    0x20(%edx),%eax
80102962:	c1 e8 18             	shr    $0x18,%eax
}
80102965:	5d                   	pop    %ebp
80102966:	c3                   	ret    
80102967:	89 f6                	mov    %esi,%esi
80102969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102970 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102970:	a1 7c 37 11 80       	mov    0x8011377c,%eax
{
80102975:	55                   	push   %ebp
80102976:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102978:	85 c0                	test   %eax,%eax
8010297a:	74 0d                	je     80102989 <lapiceoi+0x19>
  lapic[index] = value;
8010297c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102983:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102986:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102989:	5d                   	pop    %ebp
8010298a:	c3                   	ret    
8010298b:	90                   	nop
8010298c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102990 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102990:	55                   	push   %ebp
80102991:	89 e5                	mov    %esp,%ebp
}
80102993:	5d                   	pop    %ebp
80102994:	c3                   	ret    
80102995:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801029a0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801029a0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029a1:	b8 0f 00 00 00       	mov    $0xf,%eax
801029a6:	ba 70 00 00 00       	mov    $0x70,%edx
801029ab:	89 e5                	mov    %esp,%ebp
801029ad:	53                   	push   %ebx
801029ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801029b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801029b4:	ee                   	out    %al,(%dx)
801029b5:	b8 0a 00 00 00       	mov    $0xa,%eax
801029ba:	ba 71 00 00 00       	mov    $0x71,%edx
801029bf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801029c0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801029c2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801029c5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801029cb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801029cd:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
801029d0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
801029d3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801029d5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801029d8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801029de:	a1 7c 37 11 80       	mov    0x8011377c,%eax
801029e3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029e9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029ec:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801029f3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029f6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029f9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102a00:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a03:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a06:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a0c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a0f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a15:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a18:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a1e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a21:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a27:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102a2a:	5b                   	pop    %ebx
80102a2b:	5d                   	pop    %ebp
80102a2c:	c3                   	ret    
80102a2d:	8d 76 00             	lea    0x0(%esi),%esi

80102a30 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102a30:	55                   	push   %ebp
80102a31:	b8 0b 00 00 00       	mov    $0xb,%eax
80102a36:	ba 70 00 00 00       	mov    $0x70,%edx
80102a3b:	89 e5                	mov    %esp,%ebp
80102a3d:	57                   	push   %edi
80102a3e:	56                   	push   %esi
80102a3f:	53                   	push   %ebx
80102a40:	83 ec 4c             	sub    $0x4c,%esp
80102a43:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a44:	ba 71 00 00 00       	mov    $0x71,%edx
80102a49:	ec                   	in     (%dx),%al
80102a4a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102a52:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a55:	8d 76 00             	lea    0x0(%esi),%esi
80102a58:	31 c0                	xor    %eax,%eax
80102a5a:	89 da                	mov    %ebx,%edx
80102a5c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a5d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a62:	89 ca                	mov    %ecx,%edx
80102a64:	ec                   	in     (%dx),%al
80102a65:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a68:	89 da                	mov    %ebx,%edx
80102a6a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a6f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a70:	89 ca                	mov    %ecx,%edx
80102a72:	ec                   	in     (%dx),%al
80102a73:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a76:	89 da                	mov    %ebx,%edx
80102a78:	b8 04 00 00 00       	mov    $0x4,%eax
80102a7d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a7e:	89 ca                	mov    %ecx,%edx
80102a80:	ec                   	in     (%dx),%al
80102a81:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a84:	89 da                	mov    %ebx,%edx
80102a86:	b8 07 00 00 00       	mov    $0x7,%eax
80102a8b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8c:	89 ca                	mov    %ecx,%edx
80102a8e:	ec                   	in     (%dx),%al
80102a8f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a92:	89 da                	mov    %ebx,%edx
80102a94:	b8 08 00 00 00       	mov    $0x8,%eax
80102a99:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9a:	89 ca                	mov    %ecx,%edx
80102a9c:	ec                   	in     (%dx),%al
80102a9d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a9f:	89 da                	mov    %ebx,%edx
80102aa1:	b8 09 00 00 00       	mov    $0x9,%eax
80102aa6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa7:	89 ca                	mov    %ecx,%edx
80102aa9:	ec                   	in     (%dx),%al
80102aaa:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aac:	89 da                	mov    %ebx,%edx
80102aae:	b8 0a 00 00 00       	mov    $0xa,%eax
80102ab3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab4:	89 ca                	mov    %ecx,%edx
80102ab6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102ab7:	84 c0                	test   %al,%al
80102ab9:	78 9d                	js     80102a58 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102abb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102abf:	89 fa                	mov    %edi,%edx
80102ac1:	0f b6 fa             	movzbl %dl,%edi
80102ac4:	89 f2                	mov    %esi,%edx
80102ac6:	0f b6 f2             	movzbl %dl,%esi
80102ac9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102acc:	89 da                	mov    %ebx,%edx
80102ace:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102ad1:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102ad4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102ad8:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102adb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102adf:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102ae2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102ae6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102ae9:	31 c0                	xor    %eax,%eax
80102aeb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aec:	89 ca                	mov    %ecx,%edx
80102aee:	ec                   	in     (%dx),%al
80102aef:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102af2:	89 da                	mov    %ebx,%edx
80102af4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102af7:	b8 02 00 00 00       	mov    $0x2,%eax
80102afc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102afd:	89 ca                	mov    %ecx,%edx
80102aff:	ec                   	in     (%dx),%al
80102b00:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b03:	89 da                	mov    %ebx,%edx
80102b05:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102b08:	b8 04 00 00 00       	mov    $0x4,%eax
80102b0d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b0e:	89 ca                	mov    %ecx,%edx
80102b10:	ec                   	in     (%dx),%al
80102b11:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b14:	89 da                	mov    %ebx,%edx
80102b16:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102b19:	b8 07 00 00 00       	mov    $0x7,%eax
80102b1e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b1f:	89 ca                	mov    %ecx,%edx
80102b21:	ec                   	in     (%dx),%al
80102b22:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b25:	89 da                	mov    %ebx,%edx
80102b27:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102b2a:	b8 08 00 00 00       	mov    $0x8,%eax
80102b2f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b30:	89 ca                	mov    %ecx,%edx
80102b32:	ec                   	in     (%dx),%al
80102b33:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b36:	89 da                	mov    %ebx,%edx
80102b38:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b3b:	b8 09 00 00 00       	mov    $0x9,%eax
80102b40:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b41:	89 ca                	mov    %ecx,%edx
80102b43:	ec                   	in     (%dx),%al
80102b44:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b47:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b4d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b50:	6a 18                	push   $0x18
80102b52:	50                   	push   %eax
80102b53:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b56:	50                   	push   %eax
80102b57:	e8 34 1f 00 00       	call   80104a90 <memcmp>
80102b5c:	83 c4 10             	add    $0x10,%esp
80102b5f:	85 c0                	test   %eax,%eax
80102b61:	0f 85 f1 fe ff ff    	jne    80102a58 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b67:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b6b:	75 78                	jne    80102be5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b6d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b70:	89 c2                	mov    %eax,%edx
80102b72:	83 e0 0f             	and    $0xf,%eax
80102b75:	c1 ea 04             	shr    $0x4,%edx
80102b78:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b7b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b7e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b81:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b84:	89 c2                	mov    %eax,%edx
80102b86:	83 e0 0f             	and    $0xf,%eax
80102b89:	c1 ea 04             	shr    $0x4,%edx
80102b8c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b8f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b92:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b95:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b98:	89 c2                	mov    %eax,%edx
80102b9a:	83 e0 0f             	and    $0xf,%eax
80102b9d:	c1 ea 04             	shr    $0x4,%edx
80102ba0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ba3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ba6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102ba9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bac:	89 c2                	mov    %eax,%edx
80102bae:	83 e0 0f             	and    $0xf,%eax
80102bb1:	c1 ea 04             	shr    $0x4,%edx
80102bb4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bb7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bba:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102bbd:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bc0:	89 c2                	mov    %eax,%edx
80102bc2:	83 e0 0f             	and    $0xf,%eax
80102bc5:	c1 ea 04             	shr    $0x4,%edx
80102bc8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bcb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bce:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102bd1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bd4:	89 c2                	mov    %eax,%edx
80102bd6:	83 e0 0f             	and    $0xf,%eax
80102bd9:	c1 ea 04             	shr    $0x4,%edx
80102bdc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bdf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102be2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102be5:	8b 75 08             	mov    0x8(%ebp),%esi
80102be8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102beb:	89 06                	mov    %eax,(%esi)
80102bed:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102bf0:	89 46 04             	mov    %eax,0x4(%esi)
80102bf3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102bf6:	89 46 08             	mov    %eax,0x8(%esi)
80102bf9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bfc:	89 46 0c             	mov    %eax,0xc(%esi)
80102bff:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c02:	89 46 10             	mov    %eax,0x10(%esi)
80102c05:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c08:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102c0b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102c12:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c15:	5b                   	pop    %ebx
80102c16:	5e                   	pop    %esi
80102c17:	5f                   	pop    %edi
80102c18:	5d                   	pop    %ebp
80102c19:	c3                   	ret    
80102c1a:	66 90                	xchg   %ax,%ax
80102c1c:	66 90                	xchg   %ax,%ax
80102c1e:	66 90                	xchg   %ax,%ax

80102c20 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c20:	8b 0d c8 37 11 80    	mov    0x801137c8,%ecx
80102c26:	85 c9                	test   %ecx,%ecx
80102c28:	0f 8e 8a 00 00 00    	jle    80102cb8 <install_trans+0x98>
{
80102c2e:	55                   	push   %ebp
80102c2f:	89 e5                	mov    %esp,%ebp
80102c31:	57                   	push   %edi
80102c32:	56                   	push   %esi
80102c33:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102c34:	31 db                	xor    %ebx,%ebx
{
80102c36:	83 ec 0c             	sub    $0xc,%esp
80102c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c40:	a1 b4 37 11 80       	mov    0x801137b4,%eax
80102c45:	83 ec 08             	sub    $0x8,%esp
80102c48:	01 d8                	add    %ebx,%eax
80102c4a:	83 c0 01             	add    $0x1,%eax
80102c4d:	50                   	push   %eax
80102c4e:	ff 35 c4 37 11 80    	pushl  0x801137c4
80102c54:	e8 77 d4 ff ff       	call   801000d0 <bread>
80102c59:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c5b:	58                   	pop    %eax
80102c5c:	5a                   	pop    %edx
80102c5d:	ff 34 9d cc 37 11 80 	pushl  -0x7feec834(,%ebx,4)
80102c64:	ff 35 c4 37 11 80    	pushl  0x801137c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c6a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c6d:	e8 5e d4 ff ff       	call   801000d0 <bread>
80102c72:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c74:	8d 47 5c             	lea    0x5c(%edi),%eax
80102c77:	83 c4 0c             	add    $0xc,%esp
80102c7a:	68 00 02 00 00       	push   $0x200
80102c7f:	50                   	push   %eax
80102c80:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c83:	50                   	push   %eax
80102c84:	e8 67 1e 00 00       	call   80104af0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c89:	89 34 24             	mov    %esi,(%esp)
80102c8c:	e8 0f d5 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102c91:	89 3c 24             	mov    %edi,(%esp)
80102c94:	e8 47 d5 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102c99:	89 34 24             	mov    %esi,(%esp)
80102c9c:	e8 3f d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ca1:	83 c4 10             	add    $0x10,%esp
80102ca4:	39 1d c8 37 11 80    	cmp    %ebx,0x801137c8
80102caa:	7f 94                	jg     80102c40 <install_trans+0x20>
  }
}
80102cac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102caf:	5b                   	pop    %ebx
80102cb0:	5e                   	pop    %esi
80102cb1:	5f                   	pop    %edi
80102cb2:	5d                   	pop    %ebp
80102cb3:	c3                   	ret    
80102cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cb8:	f3 c3                	repz ret 
80102cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102cc0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	56                   	push   %esi
80102cc4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102cc5:	83 ec 08             	sub    $0x8,%esp
80102cc8:	ff 35 b4 37 11 80    	pushl  0x801137b4
80102cce:	ff 35 c4 37 11 80    	pushl  0x801137c4
80102cd4:	e8 f7 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102cd9:	8b 1d c8 37 11 80    	mov    0x801137c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102cdf:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ce2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102ce4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102ce6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102ce9:	7e 16                	jle    80102d01 <write_head+0x41>
80102ceb:	c1 e3 02             	shl    $0x2,%ebx
80102cee:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102cf0:	8b 8a cc 37 11 80    	mov    -0x7feec834(%edx),%ecx
80102cf6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102cfa:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102cfd:	39 da                	cmp    %ebx,%edx
80102cff:	75 ef                	jne    80102cf0 <write_head+0x30>
  }
  bwrite(buf);
80102d01:	83 ec 0c             	sub    $0xc,%esp
80102d04:	56                   	push   %esi
80102d05:	e8 96 d4 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102d0a:	89 34 24             	mov    %esi,(%esp)
80102d0d:	e8 ce d4 ff ff       	call   801001e0 <brelse>
}
80102d12:	83 c4 10             	add    $0x10,%esp
80102d15:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102d18:	5b                   	pop    %ebx
80102d19:	5e                   	pop    %esi
80102d1a:	5d                   	pop    %ebp
80102d1b:	c3                   	ret    
80102d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102d20 <initlog>:
{
80102d20:	55                   	push   %ebp
80102d21:	89 e5                	mov    %esp,%ebp
80102d23:	53                   	push   %ebx
80102d24:	83 ec 2c             	sub    $0x2c,%esp
80102d27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102d2a:	68 80 7c 10 80       	push   $0x80107c80
80102d2f:	68 80 37 11 80       	push   $0x80113780
80102d34:	e8 b7 1a 00 00       	call   801047f0 <initlock>
  readsb(dev, &sb);
80102d39:	58                   	pop    %eax
80102d3a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d3d:	5a                   	pop    %edx
80102d3e:	50                   	push   %eax
80102d3f:	53                   	push   %ebx
80102d40:	e8 1b e9 ff ff       	call   80101660 <readsb>
  log.size = sb.nlog;
80102d45:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102d4b:	59                   	pop    %ecx
  log.dev = dev;
80102d4c:	89 1d c4 37 11 80    	mov    %ebx,0x801137c4
  log.size = sb.nlog;
80102d52:	89 15 b8 37 11 80    	mov    %edx,0x801137b8
  log.start = sb.logstart;
80102d58:	a3 b4 37 11 80       	mov    %eax,0x801137b4
  struct buf *buf = bread(log.dev, log.start);
80102d5d:	5a                   	pop    %edx
80102d5e:	50                   	push   %eax
80102d5f:	53                   	push   %ebx
80102d60:	e8 6b d3 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102d65:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102d68:	83 c4 10             	add    $0x10,%esp
80102d6b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102d6d:	89 1d c8 37 11 80    	mov    %ebx,0x801137c8
  for (i = 0; i < log.lh.n; i++) {
80102d73:	7e 1c                	jle    80102d91 <initlog+0x71>
80102d75:	c1 e3 02             	shl    $0x2,%ebx
80102d78:	31 d2                	xor    %edx,%edx
80102d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102d80:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102d84:	83 c2 04             	add    $0x4,%edx
80102d87:	89 8a c8 37 11 80    	mov    %ecx,-0x7feec838(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102d8d:	39 d3                	cmp    %edx,%ebx
80102d8f:	75 ef                	jne    80102d80 <initlog+0x60>
  brelse(buf);
80102d91:	83 ec 0c             	sub    $0xc,%esp
80102d94:	50                   	push   %eax
80102d95:	e8 46 d4 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d9a:	e8 81 fe ff ff       	call   80102c20 <install_trans>
  log.lh.n = 0;
80102d9f:	c7 05 c8 37 11 80 00 	movl   $0x0,0x801137c8
80102da6:	00 00 00 
  write_head(); // clear the log
80102da9:	e8 12 ff ff ff       	call   80102cc0 <write_head>
}
80102dae:	83 c4 10             	add    $0x10,%esp
80102db1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102db4:	c9                   	leave  
80102db5:	c3                   	ret    
80102db6:	8d 76 00             	lea    0x0(%esi),%esi
80102db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102dc0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102dc0:	55                   	push   %ebp
80102dc1:	89 e5                	mov    %esp,%ebp
80102dc3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102dc6:	68 80 37 11 80       	push   $0x80113780
80102dcb:	e8 60 1b 00 00       	call   80104930 <acquire>
80102dd0:	83 c4 10             	add    $0x10,%esp
80102dd3:	eb 18                	jmp    80102ded <begin_op+0x2d>
80102dd5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102dd8:	83 ec 08             	sub    $0x8,%esp
80102ddb:	68 80 37 11 80       	push   $0x80113780
80102de0:	68 80 37 11 80       	push   $0x80113780
80102de5:	e8 66 15 00 00       	call   80104350 <sleep>
80102dea:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102ded:	a1 c0 37 11 80       	mov    0x801137c0,%eax
80102df2:	85 c0                	test   %eax,%eax
80102df4:	75 e2                	jne    80102dd8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102df6:	a1 bc 37 11 80       	mov    0x801137bc,%eax
80102dfb:	8b 15 c8 37 11 80    	mov    0x801137c8,%edx
80102e01:	83 c0 01             	add    $0x1,%eax
80102e04:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102e07:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102e0a:	83 fa 1e             	cmp    $0x1e,%edx
80102e0d:	7f c9                	jg     80102dd8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102e0f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102e12:	a3 bc 37 11 80       	mov    %eax,0x801137bc
      release(&log.lock);
80102e17:	68 80 37 11 80       	push   $0x80113780
80102e1c:	e8 cf 1b 00 00       	call   801049f0 <release>
      break;
    }
  }
}
80102e21:	83 c4 10             	add    $0x10,%esp
80102e24:	c9                   	leave  
80102e25:	c3                   	ret    
80102e26:	8d 76 00             	lea    0x0(%esi),%esi
80102e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102e30 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e30:	55                   	push   %ebp
80102e31:	89 e5                	mov    %esp,%ebp
80102e33:	57                   	push   %edi
80102e34:	56                   	push   %esi
80102e35:	53                   	push   %ebx
80102e36:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e39:	68 80 37 11 80       	push   $0x80113780
80102e3e:	e8 ed 1a 00 00       	call   80104930 <acquire>
  log.outstanding -= 1;
80102e43:	a1 bc 37 11 80       	mov    0x801137bc,%eax
  if(log.committing)
80102e48:	8b 35 c0 37 11 80    	mov    0x801137c0,%esi
80102e4e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e51:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102e54:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102e56:	89 1d bc 37 11 80    	mov    %ebx,0x801137bc
  if(log.committing)
80102e5c:	0f 85 1a 01 00 00    	jne    80102f7c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102e62:	85 db                	test   %ebx,%ebx
80102e64:	0f 85 ee 00 00 00    	jne    80102f58 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e6a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102e6d:	c7 05 c0 37 11 80 01 	movl   $0x1,0x801137c0
80102e74:	00 00 00 
  release(&log.lock);
80102e77:	68 80 37 11 80       	push   $0x80113780
80102e7c:	e8 6f 1b 00 00       	call   801049f0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e81:	8b 0d c8 37 11 80    	mov    0x801137c8,%ecx
80102e87:	83 c4 10             	add    $0x10,%esp
80102e8a:	85 c9                	test   %ecx,%ecx
80102e8c:	0f 8e 85 00 00 00    	jle    80102f17 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e92:	a1 b4 37 11 80       	mov    0x801137b4,%eax
80102e97:	83 ec 08             	sub    $0x8,%esp
80102e9a:	01 d8                	add    %ebx,%eax
80102e9c:	83 c0 01             	add    $0x1,%eax
80102e9f:	50                   	push   %eax
80102ea0:	ff 35 c4 37 11 80    	pushl  0x801137c4
80102ea6:	e8 25 d2 ff ff       	call   801000d0 <bread>
80102eab:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ead:	58                   	pop    %eax
80102eae:	5a                   	pop    %edx
80102eaf:	ff 34 9d cc 37 11 80 	pushl  -0x7feec834(,%ebx,4)
80102eb6:	ff 35 c4 37 11 80    	pushl  0x801137c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102ebc:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ebf:	e8 0c d2 ff ff       	call   801000d0 <bread>
80102ec4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ec6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102ec9:	83 c4 0c             	add    $0xc,%esp
80102ecc:	68 00 02 00 00       	push   $0x200
80102ed1:	50                   	push   %eax
80102ed2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ed5:	50                   	push   %eax
80102ed6:	e8 15 1c 00 00       	call   80104af0 <memmove>
    bwrite(to);  // write the log
80102edb:	89 34 24             	mov    %esi,(%esp)
80102ede:	e8 bd d2 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102ee3:	89 3c 24             	mov    %edi,(%esp)
80102ee6:	e8 f5 d2 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102eeb:	89 34 24             	mov    %esi,(%esp)
80102eee:	e8 ed d2 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ef3:	83 c4 10             	add    $0x10,%esp
80102ef6:	3b 1d c8 37 11 80    	cmp    0x801137c8,%ebx
80102efc:	7c 94                	jl     80102e92 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102efe:	e8 bd fd ff ff       	call   80102cc0 <write_head>
    install_trans(); // Now install writes to home locations
80102f03:	e8 18 fd ff ff       	call   80102c20 <install_trans>
    log.lh.n = 0;
80102f08:	c7 05 c8 37 11 80 00 	movl   $0x0,0x801137c8
80102f0f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f12:	e8 a9 fd ff ff       	call   80102cc0 <write_head>
    acquire(&log.lock);
80102f17:	83 ec 0c             	sub    $0xc,%esp
80102f1a:	68 80 37 11 80       	push   $0x80113780
80102f1f:	e8 0c 1a 00 00       	call   80104930 <acquire>
    wakeup(&log);
80102f24:	c7 04 24 80 37 11 80 	movl   $0x80113780,(%esp)
    log.committing = 0;
80102f2b:	c7 05 c0 37 11 80 00 	movl   $0x0,0x801137c0
80102f32:	00 00 00 
    wakeup(&log);
80102f35:	e8 d6 15 00 00       	call   80104510 <wakeup>
    release(&log.lock);
80102f3a:	c7 04 24 80 37 11 80 	movl   $0x80113780,(%esp)
80102f41:	e8 aa 1a 00 00       	call   801049f0 <release>
80102f46:	83 c4 10             	add    $0x10,%esp
}
80102f49:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f4c:	5b                   	pop    %ebx
80102f4d:	5e                   	pop    %esi
80102f4e:	5f                   	pop    %edi
80102f4f:	5d                   	pop    %ebp
80102f50:	c3                   	ret    
80102f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102f58:	83 ec 0c             	sub    $0xc,%esp
80102f5b:	68 80 37 11 80       	push   $0x80113780
80102f60:	e8 ab 15 00 00       	call   80104510 <wakeup>
  release(&log.lock);
80102f65:	c7 04 24 80 37 11 80 	movl   $0x80113780,(%esp)
80102f6c:	e8 7f 1a 00 00       	call   801049f0 <release>
80102f71:	83 c4 10             	add    $0x10,%esp
}
80102f74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f77:	5b                   	pop    %ebx
80102f78:	5e                   	pop    %esi
80102f79:	5f                   	pop    %edi
80102f7a:	5d                   	pop    %ebp
80102f7b:	c3                   	ret    
    panic("log.committing");
80102f7c:	83 ec 0c             	sub    $0xc,%esp
80102f7f:	68 84 7c 10 80       	push   $0x80107c84
80102f84:	e8 07 d4 ff ff       	call   80100390 <panic>
80102f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f90 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f90:	55                   	push   %ebp
80102f91:	89 e5                	mov    %esp,%ebp
80102f93:	53                   	push   %ebx
80102f94:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f97:	8b 15 c8 37 11 80    	mov    0x801137c8,%edx
{
80102f9d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fa0:	83 fa 1d             	cmp    $0x1d,%edx
80102fa3:	0f 8f 9d 00 00 00    	jg     80103046 <log_write+0xb6>
80102fa9:	a1 b8 37 11 80       	mov    0x801137b8,%eax
80102fae:	83 e8 01             	sub    $0x1,%eax
80102fb1:	39 c2                	cmp    %eax,%edx
80102fb3:	0f 8d 8d 00 00 00    	jge    80103046 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102fb9:	a1 bc 37 11 80       	mov    0x801137bc,%eax
80102fbe:	85 c0                	test   %eax,%eax
80102fc0:	0f 8e 8d 00 00 00    	jle    80103053 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102fc6:	83 ec 0c             	sub    $0xc,%esp
80102fc9:	68 80 37 11 80       	push   $0x80113780
80102fce:	e8 5d 19 00 00       	call   80104930 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102fd3:	8b 0d c8 37 11 80    	mov    0x801137c8,%ecx
80102fd9:	83 c4 10             	add    $0x10,%esp
80102fdc:	83 f9 00             	cmp    $0x0,%ecx
80102fdf:	7e 57                	jle    80103038 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fe1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102fe4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fe6:	3b 15 cc 37 11 80    	cmp    0x801137cc,%edx
80102fec:	75 0b                	jne    80102ff9 <log_write+0x69>
80102fee:	eb 38                	jmp    80103028 <log_write+0x98>
80102ff0:	39 14 85 cc 37 11 80 	cmp    %edx,-0x7feec834(,%eax,4)
80102ff7:	74 2f                	je     80103028 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102ff9:	83 c0 01             	add    $0x1,%eax
80102ffc:	39 c1                	cmp    %eax,%ecx
80102ffe:	75 f0                	jne    80102ff0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103000:	89 14 85 cc 37 11 80 	mov    %edx,-0x7feec834(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103007:	83 c0 01             	add    $0x1,%eax
8010300a:	a3 c8 37 11 80       	mov    %eax,0x801137c8
  b->flags |= B_DIRTY; // prevent eviction
8010300f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103012:	c7 45 08 80 37 11 80 	movl   $0x80113780,0x8(%ebp)
}
80103019:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010301c:	c9                   	leave  
  release(&log.lock);
8010301d:	e9 ce 19 00 00       	jmp    801049f0 <release>
80103022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103028:	89 14 85 cc 37 11 80 	mov    %edx,-0x7feec834(,%eax,4)
8010302f:	eb de                	jmp    8010300f <log_write+0x7f>
80103031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103038:	8b 43 08             	mov    0x8(%ebx),%eax
8010303b:	a3 cc 37 11 80       	mov    %eax,0x801137cc
  if (i == log.lh.n)
80103040:	75 cd                	jne    8010300f <log_write+0x7f>
80103042:	31 c0                	xor    %eax,%eax
80103044:	eb c1                	jmp    80103007 <log_write+0x77>
    panic("too big a transaction");
80103046:	83 ec 0c             	sub    $0xc,%esp
80103049:	68 93 7c 10 80       	push   $0x80107c93
8010304e:	e8 3d d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103053:	83 ec 0c             	sub    $0xc,%esp
80103056:	68 a9 7c 10 80       	push   $0x80107ca9
8010305b:	e8 30 d3 ff ff       	call   80100390 <panic>

80103060 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103060:	55                   	push   %ebp
80103061:	89 e5                	mov    %esp,%ebp
80103063:	53                   	push   %ebx
80103064:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103067:	e8 84 0c 00 00       	call   80103cf0 <cpuid>
8010306c:	89 c3                	mov    %eax,%ebx
8010306e:	e8 7d 0c 00 00       	call   80103cf0 <cpuid>
80103073:	83 ec 04             	sub    $0x4,%esp
80103076:	53                   	push   %ebx
80103077:	50                   	push   %eax
80103078:	68 c4 7c 10 80       	push   $0x80107cc4
8010307d:	e8 de d5 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103082:	e8 79 2f 00 00       	call   80106000 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103087:	e8 e4 0b 00 00       	call   80103c70 <mycpu>
8010308c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010308e:	b8 01 00 00 00       	mov    $0x1,%eax
80103093:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010309a:	e8 d1 0f 00 00       	call   80104070 <scheduler>
8010309f:	90                   	nop

801030a0 <mpenter>:
{
801030a0:	55                   	push   %ebp
801030a1:	89 e5                	mov    %esp,%ebp
801030a3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801030a6:	e8 45 40 00 00       	call   801070f0 <switchkvm>
  seginit();
801030ab:	e8 b0 3f 00 00       	call   80107060 <seginit>
  lapicinit();
801030b0:	e8 9b f7 ff ff       	call   80102850 <lapicinit>
  mpmain();
801030b5:	e8 a6 ff ff ff       	call   80103060 <mpmain>
801030ba:	66 90                	xchg   %ax,%ax
801030bc:	66 90                	xchg   %ax,%ax
801030be:	66 90                	xchg   %ax,%ax

801030c0 <main>:
{
801030c0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801030c4:	83 e4 f0             	and    $0xfffffff0,%esp
801030c7:	ff 71 fc             	pushl  -0x4(%ecx)
801030ca:	55                   	push   %ebp
801030cb:	89 e5                	mov    %esp,%ebp
801030cd:	53                   	push   %ebx
801030ce:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801030cf:	83 ec 08             	sub    $0x8,%esp
801030d2:	68 00 00 40 80       	push   $0x80400000
801030d7:	68 a8 83 11 80       	push   $0x801183a8
801030dc:	e8 2f f5 ff ff       	call   80102610 <kinit1>
  kvmalloc();      // kernel page table
801030e1:	e8 da 44 00 00       	call   801075c0 <kvmalloc>
  mpinit();        // detect other processors
801030e6:	e8 75 01 00 00       	call   80103260 <mpinit>
  lapicinit();     // interrupt controller
801030eb:	e8 60 f7 ff ff       	call   80102850 <lapicinit>
  seginit();       // segment descriptors
801030f0:	e8 6b 3f 00 00       	call   80107060 <seginit>
  picinit();       // disable pic
801030f5:	e8 46 03 00 00       	call   80103440 <picinit>
  ioapicinit();    // another interrupt controller
801030fa:	e8 41 f3 ff ff       	call   80102440 <ioapicinit>
  consoleinit();   // console hardware
801030ff:	e8 8c da ff ff       	call   80100b90 <consoleinit>
  uartinit();      // serial port
80103104:	e8 27 32 00 00       	call   80106330 <uartinit>
  pinit();         // process table
80103109:	e8 42 0b 00 00       	call   80103c50 <pinit>
  tvinit();        // trap vectors
8010310e:	e8 6d 2e 00 00       	call   80105f80 <tvinit>
  binit();         // buffer cache
80103113:	e8 28 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103118:	e8 63 de ff ff       	call   80100f80 <fileinit>
  ideinit();       // disk 
8010311d:	e8 fe f0 ff ff       	call   80102220 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103122:	83 c4 0c             	add    $0xc,%esp
80103125:	68 8a 00 00 00       	push   $0x8a
8010312a:	68 ec b4 10 80       	push   $0x8010b4ec
8010312f:	68 00 70 00 80       	push   $0x80007000
80103134:	e8 b7 19 00 00       	call   80104af0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103139:	69 05 00 3e 11 80 b0 	imul   $0xb0,0x80113e00,%eax
80103140:	00 00 00 
80103143:	83 c4 10             	add    $0x10,%esp
80103146:	05 80 38 11 80       	add    $0x80113880,%eax
8010314b:	3d 80 38 11 80       	cmp    $0x80113880,%eax
80103150:	76 71                	jbe    801031c3 <main+0x103>
80103152:	bb 80 38 11 80       	mov    $0x80113880,%ebx
80103157:	89 f6                	mov    %esi,%esi
80103159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80103160:	e8 0b 0b 00 00       	call   80103c70 <mycpu>
80103165:	39 d8                	cmp    %ebx,%eax
80103167:	74 41                	je     801031aa <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103169:	e8 72 f5 ff ff       	call   801026e0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010316e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80103173:	c7 05 f8 6f 00 80 a0 	movl   $0x801030a0,0x80006ff8
8010317a:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010317d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80103184:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103187:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010318c:	0f b6 03             	movzbl (%ebx),%eax
8010318f:	83 ec 08             	sub    $0x8,%esp
80103192:	68 00 70 00 00       	push   $0x7000
80103197:	50                   	push   %eax
80103198:	e8 03 f8 ff ff       	call   801029a0 <lapicstartap>
8010319d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801031a0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801031a6:	85 c0                	test   %eax,%eax
801031a8:	74 f6                	je     801031a0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
801031aa:	69 05 00 3e 11 80 b0 	imul   $0xb0,0x80113e00,%eax
801031b1:	00 00 00 
801031b4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801031ba:	05 80 38 11 80       	add    $0x80113880,%eax
801031bf:	39 c3                	cmp    %eax,%ebx
801031c1:	72 9d                	jb     80103160 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801031c3:	83 ec 08             	sub    $0x8,%esp
801031c6:	68 00 00 00 8e       	push   $0x8e000000
801031cb:	68 00 00 40 80       	push   $0x80400000
801031d0:	e8 ab f4 ff ff       	call   80102680 <kinit2>
  userinit();      // first user process
801031d5:	e8 66 0b 00 00       	call   80103d40 <userinit>
  mpmain();        // finish this processor's setup
801031da:	e8 81 fe ff ff       	call   80103060 <mpmain>
801031df:	90                   	nop

801031e0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031e0:	55                   	push   %ebp
801031e1:	89 e5                	mov    %esp,%ebp
801031e3:	57                   	push   %edi
801031e4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031e5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031eb:	53                   	push   %ebx
  e = addr+len;
801031ec:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031ef:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031f2:	39 de                	cmp    %ebx,%esi
801031f4:	72 10                	jb     80103206 <mpsearch1+0x26>
801031f6:	eb 50                	jmp    80103248 <mpsearch1+0x68>
801031f8:	90                   	nop
801031f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103200:	39 fb                	cmp    %edi,%ebx
80103202:	89 fe                	mov    %edi,%esi
80103204:	76 42                	jbe    80103248 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103206:	83 ec 04             	sub    $0x4,%esp
80103209:	8d 7e 10             	lea    0x10(%esi),%edi
8010320c:	6a 04                	push   $0x4
8010320e:	68 d8 7c 10 80       	push   $0x80107cd8
80103213:	56                   	push   %esi
80103214:	e8 77 18 00 00       	call   80104a90 <memcmp>
80103219:	83 c4 10             	add    $0x10,%esp
8010321c:	85 c0                	test   %eax,%eax
8010321e:	75 e0                	jne    80103200 <mpsearch1+0x20>
80103220:	89 f1                	mov    %esi,%ecx
80103222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103228:	0f b6 11             	movzbl (%ecx),%edx
8010322b:	83 c1 01             	add    $0x1,%ecx
8010322e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103230:	39 f9                	cmp    %edi,%ecx
80103232:	75 f4                	jne    80103228 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103234:	84 c0                	test   %al,%al
80103236:	75 c8                	jne    80103200 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103238:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010323b:	89 f0                	mov    %esi,%eax
8010323d:	5b                   	pop    %ebx
8010323e:	5e                   	pop    %esi
8010323f:	5f                   	pop    %edi
80103240:	5d                   	pop    %ebp
80103241:	c3                   	ret    
80103242:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103248:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010324b:	31 f6                	xor    %esi,%esi
}
8010324d:	89 f0                	mov    %esi,%eax
8010324f:	5b                   	pop    %ebx
80103250:	5e                   	pop    %esi
80103251:	5f                   	pop    %edi
80103252:	5d                   	pop    %ebp
80103253:	c3                   	ret    
80103254:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010325a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103260 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103260:	55                   	push   %ebp
80103261:	89 e5                	mov    %esp,%ebp
80103263:	57                   	push   %edi
80103264:	56                   	push   %esi
80103265:	53                   	push   %ebx
80103266:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103269:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103270:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103277:	c1 e0 08             	shl    $0x8,%eax
8010327a:	09 d0                	or     %edx,%eax
8010327c:	c1 e0 04             	shl    $0x4,%eax
8010327f:	85 c0                	test   %eax,%eax
80103281:	75 1b                	jne    8010329e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103283:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010328a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103291:	c1 e0 08             	shl    $0x8,%eax
80103294:	09 d0                	or     %edx,%eax
80103296:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103299:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010329e:	ba 00 04 00 00       	mov    $0x400,%edx
801032a3:	e8 38 ff ff ff       	call   801031e0 <mpsearch1>
801032a8:	85 c0                	test   %eax,%eax
801032aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801032ad:	0f 84 3d 01 00 00    	je     801033f0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801032b6:	8b 58 04             	mov    0x4(%eax),%ebx
801032b9:	85 db                	test   %ebx,%ebx
801032bb:	0f 84 4f 01 00 00    	je     80103410 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032c1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801032c7:	83 ec 04             	sub    $0x4,%esp
801032ca:	6a 04                	push   $0x4
801032cc:	68 f5 7c 10 80       	push   $0x80107cf5
801032d1:	56                   	push   %esi
801032d2:	e8 b9 17 00 00       	call   80104a90 <memcmp>
801032d7:	83 c4 10             	add    $0x10,%esp
801032da:	85 c0                	test   %eax,%eax
801032dc:	0f 85 2e 01 00 00    	jne    80103410 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801032e2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801032e9:	3c 01                	cmp    $0x1,%al
801032eb:	0f 95 c2             	setne  %dl
801032ee:	3c 04                	cmp    $0x4,%al
801032f0:	0f 95 c0             	setne  %al
801032f3:	20 c2                	and    %al,%dl
801032f5:	0f 85 15 01 00 00    	jne    80103410 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801032fb:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103302:	66 85 ff             	test   %di,%di
80103305:	74 1a                	je     80103321 <mpinit+0xc1>
80103307:	89 f0                	mov    %esi,%eax
80103309:	01 f7                	add    %esi,%edi
  sum = 0;
8010330b:	31 d2                	xor    %edx,%edx
8010330d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103310:	0f b6 08             	movzbl (%eax),%ecx
80103313:	83 c0 01             	add    $0x1,%eax
80103316:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103318:	39 c7                	cmp    %eax,%edi
8010331a:	75 f4                	jne    80103310 <mpinit+0xb0>
8010331c:	84 d2                	test   %dl,%dl
8010331e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103321:	85 f6                	test   %esi,%esi
80103323:	0f 84 e7 00 00 00    	je     80103410 <mpinit+0x1b0>
80103329:	84 d2                	test   %dl,%dl
8010332b:	0f 85 df 00 00 00    	jne    80103410 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103331:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103337:	a3 7c 37 11 80       	mov    %eax,0x8011377c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010333c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103343:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103349:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010334e:	01 d6                	add    %edx,%esi
80103350:	39 c6                	cmp    %eax,%esi
80103352:	76 23                	jbe    80103377 <mpinit+0x117>
    switch(*p){
80103354:	0f b6 10             	movzbl (%eax),%edx
80103357:	80 fa 04             	cmp    $0x4,%dl
8010335a:	0f 87 ca 00 00 00    	ja     8010342a <mpinit+0x1ca>
80103360:	ff 24 95 1c 7d 10 80 	jmp    *-0x7fef82e4(,%edx,4)
80103367:	89 f6                	mov    %esi,%esi
80103369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103370:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103373:	39 c6                	cmp    %eax,%esi
80103375:	77 dd                	ja     80103354 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103377:	85 db                	test   %ebx,%ebx
80103379:	0f 84 9e 00 00 00    	je     8010341d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010337f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103382:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103386:	74 15                	je     8010339d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103388:	b8 70 00 00 00       	mov    $0x70,%eax
8010338d:	ba 22 00 00 00       	mov    $0x22,%edx
80103392:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103393:	ba 23 00 00 00       	mov    $0x23,%edx
80103398:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103399:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010339c:	ee                   	out    %al,(%dx)
  }
}
8010339d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033a0:	5b                   	pop    %ebx
801033a1:	5e                   	pop    %esi
801033a2:	5f                   	pop    %edi
801033a3:	5d                   	pop    %ebp
801033a4:	c3                   	ret    
801033a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801033a8:	8b 0d 00 3e 11 80    	mov    0x80113e00,%ecx
801033ae:	83 f9 07             	cmp    $0x7,%ecx
801033b1:	7f 19                	jg     801033cc <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033b3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801033b7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801033bd:	83 c1 01             	add    $0x1,%ecx
801033c0:	89 0d 00 3e 11 80    	mov    %ecx,0x80113e00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033c6:	88 97 80 38 11 80    	mov    %dl,-0x7feec780(%edi)
      p += sizeof(struct mpproc);
801033cc:	83 c0 14             	add    $0x14,%eax
      continue;
801033cf:	e9 7c ff ff ff       	jmp    80103350 <mpinit+0xf0>
801033d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801033d8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801033dc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801033df:	88 15 60 38 11 80    	mov    %dl,0x80113860
      continue;
801033e5:	e9 66 ff ff ff       	jmp    80103350 <mpinit+0xf0>
801033ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801033f0:	ba 00 00 01 00       	mov    $0x10000,%edx
801033f5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801033fa:	e8 e1 fd ff ff       	call   801031e0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033ff:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103401:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103404:	0f 85 a9 fe ff ff    	jne    801032b3 <mpinit+0x53>
8010340a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103410:	83 ec 0c             	sub    $0xc,%esp
80103413:	68 dd 7c 10 80       	push   $0x80107cdd
80103418:	e8 73 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010341d:	83 ec 0c             	sub    $0xc,%esp
80103420:	68 fc 7c 10 80       	push   $0x80107cfc
80103425:	e8 66 cf ff ff       	call   80100390 <panic>
      ismp = 0;
8010342a:	31 db                	xor    %ebx,%ebx
8010342c:	e9 26 ff ff ff       	jmp    80103357 <mpinit+0xf7>
80103431:	66 90                	xchg   %ax,%ax
80103433:	66 90                	xchg   %ax,%ax
80103435:	66 90                	xchg   %ax,%ax
80103437:	66 90                	xchg   %ax,%ax
80103439:	66 90                	xchg   %ax,%ax
8010343b:	66 90                	xchg   %ax,%ax
8010343d:	66 90                	xchg   %ax,%ax
8010343f:	90                   	nop

80103440 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103440:	55                   	push   %ebp
80103441:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103446:	ba 21 00 00 00       	mov    $0x21,%edx
8010344b:	89 e5                	mov    %esp,%ebp
8010344d:	ee                   	out    %al,(%dx)
8010344e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103453:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103454:	5d                   	pop    %ebp
80103455:	c3                   	ret    
80103456:	66 90                	xchg   %ax,%ax
80103458:	66 90                	xchg   %ax,%ax
8010345a:	66 90                	xchg   %ax,%ax
8010345c:	66 90                	xchg   %ax,%ax
8010345e:	66 90                	xchg   %ax,%ax

80103460 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103460:	55                   	push   %ebp
80103461:	89 e5                	mov    %esp,%ebp
80103463:	57                   	push   %edi
80103464:	56                   	push   %esi
80103465:	53                   	push   %ebx
80103466:	83 ec 0c             	sub    $0xc,%esp
80103469:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010346c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010346f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103475:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010347b:	e8 20 db ff ff       	call   80100fa0 <filealloc>
80103480:	85 c0                	test   %eax,%eax
80103482:	89 03                	mov    %eax,(%ebx)
80103484:	74 22                	je     801034a8 <pipealloc+0x48>
80103486:	e8 15 db ff ff       	call   80100fa0 <filealloc>
8010348b:	85 c0                	test   %eax,%eax
8010348d:	89 06                	mov    %eax,(%esi)
8010348f:	74 3f                	je     801034d0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103491:	e8 4a f2 ff ff       	call   801026e0 <kalloc>
80103496:	85 c0                	test   %eax,%eax
80103498:	89 c7                	mov    %eax,%edi
8010349a:	75 54                	jne    801034f0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010349c:	8b 03                	mov    (%ebx),%eax
8010349e:	85 c0                	test   %eax,%eax
801034a0:	75 34                	jne    801034d6 <pipealloc+0x76>
801034a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
801034a8:	8b 06                	mov    (%esi),%eax
801034aa:	85 c0                	test   %eax,%eax
801034ac:	74 0c                	je     801034ba <pipealloc+0x5a>
    fileclose(*f1);
801034ae:	83 ec 0c             	sub    $0xc,%esp
801034b1:	50                   	push   %eax
801034b2:	e8 a9 db ff ff       	call   80101060 <fileclose>
801034b7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801034ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801034bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801034c2:	5b                   	pop    %ebx
801034c3:	5e                   	pop    %esi
801034c4:	5f                   	pop    %edi
801034c5:	5d                   	pop    %ebp
801034c6:	c3                   	ret    
801034c7:	89 f6                	mov    %esi,%esi
801034c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801034d0:	8b 03                	mov    (%ebx),%eax
801034d2:	85 c0                	test   %eax,%eax
801034d4:	74 e4                	je     801034ba <pipealloc+0x5a>
    fileclose(*f0);
801034d6:	83 ec 0c             	sub    $0xc,%esp
801034d9:	50                   	push   %eax
801034da:	e8 81 db ff ff       	call   80101060 <fileclose>
  if(*f1)
801034df:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801034e1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801034e4:	85 c0                	test   %eax,%eax
801034e6:	75 c6                	jne    801034ae <pipealloc+0x4e>
801034e8:	eb d0                	jmp    801034ba <pipealloc+0x5a>
801034ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801034f0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801034f3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801034fa:	00 00 00 
  p->writeopen = 1;
801034fd:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103504:	00 00 00 
  p->nwrite = 0;
80103507:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010350e:	00 00 00 
  p->nread = 0;
80103511:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103518:	00 00 00 
  initlock(&p->lock, "pipe");
8010351b:	68 30 7d 10 80       	push   $0x80107d30
80103520:	50                   	push   %eax
80103521:	e8 ca 12 00 00       	call   801047f0 <initlock>
  (*f0)->type = FD_PIPE;
80103526:	8b 03                	mov    (%ebx),%eax
  return 0;
80103528:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010352b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103531:	8b 03                	mov    (%ebx),%eax
80103533:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103537:	8b 03                	mov    (%ebx),%eax
80103539:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010353d:	8b 03                	mov    (%ebx),%eax
8010353f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103542:	8b 06                	mov    (%esi),%eax
80103544:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010354a:	8b 06                	mov    (%esi),%eax
8010354c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103550:	8b 06                	mov    (%esi),%eax
80103552:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103556:	8b 06                	mov    (%esi),%eax
80103558:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010355b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010355e:	31 c0                	xor    %eax,%eax
}
80103560:	5b                   	pop    %ebx
80103561:	5e                   	pop    %esi
80103562:	5f                   	pop    %edi
80103563:	5d                   	pop    %ebp
80103564:	c3                   	ret    
80103565:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103570 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103570:	55                   	push   %ebp
80103571:	89 e5                	mov    %esp,%ebp
80103573:	56                   	push   %esi
80103574:	53                   	push   %ebx
80103575:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103578:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010357b:	83 ec 0c             	sub    $0xc,%esp
8010357e:	53                   	push   %ebx
8010357f:	e8 ac 13 00 00       	call   80104930 <acquire>
  if(writable){
80103584:	83 c4 10             	add    $0x10,%esp
80103587:	85 f6                	test   %esi,%esi
80103589:	74 45                	je     801035d0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010358b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103591:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103594:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010359b:	00 00 00 
    wakeup(&p->nread);
8010359e:	50                   	push   %eax
8010359f:	e8 6c 0f 00 00       	call   80104510 <wakeup>
801035a4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801035a7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801035ad:	85 d2                	test   %edx,%edx
801035af:	75 0a                	jne    801035bb <pipeclose+0x4b>
801035b1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801035b7:	85 c0                	test   %eax,%eax
801035b9:	74 35                	je     801035f0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801035bb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035c1:	5b                   	pop    %ebx
801035c2:	5e                   	pop    %esi
801035c3:	5d                   	pop    %ebp
    release(&p->lock);
801035c4:	e9 27 14 00 00       	jmp    801049f0 <release>
801035c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801035d0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801035d6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801035d9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035e0:	00 00 00 
    wakeup(&p->nwrite);
801035e3:	50                   	push   %eax
801035e4:	e8 27 0f 00 00       	call   80104510 <wakeup>
801035e9:	83 c4 10             	add    $0x10,%esp
801035ec:	eb b9                	jmp    801035a7 <pipeclose+0x37>
801035ee:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801035f0:	83 ec 0c             	sub    $0xc,%esp
801035f3:	53                   	push   %ebx
801035f4:	e8 f7 13 00 00       	call   801049f0 <release>
    kfree((char*)p);
801035f9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035fc:	83 c4 10             	add    $0x10,%esp
}
801035ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103602:	5b                   	pop    %ebx
80103603:	5e                   	pop    %esi
80103604:	5d                   	pop    %ebp
    kfree((char*)p);
80103605:	e9 26 ef ff ff       	jmp    80102530 <kfree>
8010360a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103610 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103610:	55                   	push   %ebp
80103611:	89 e5                	mov    %esp,%ebp
80103613:	57                   	push   %edi
80103614:	56                   	push   %esi
80103615:	53                   	push   %ebx
80103616:	83 ec 28             	sub    $0x28,%esp
80103619:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010361c:	53                   	push   %ebx
8010361d:	e8 0e 13 00 00       	call   80104930 <acquire>
  for(i = 0; i < n; i++){
80103622:	8b 45 10             	mov    0x10(%ebp),%eax
80103625:	83 c4 10             	add    $0x10,%esp
80103628:	85 c0                	test   %eax,%eax
8010362a:	0f 8e c9 00 00 00    	jle    801036f9 <pipewrite+0xe9>
80103630:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103633:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103639:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010363f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103642:	03 4d 10             	add    0x10(%ebp),%ecx
80103645:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103648:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010364e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103654:	39 d0                	cmp    %edx,%eax
80103656:	75 71                	jne    801036c9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103658:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010365e:	85 c0                	test   %eax,%eax
80103660:	74 4e                	je     801036b0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103662:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103668:	eb 3a                	jmp    801036a4 <pipewrite+0x94>
8010366a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103670:	83 ec 0c             	sub    $0xc,%esp
80103673:	57                   	push   %edi
80103674:	e8 97 0e 00 00       	call   80104510 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103679:	5a                   	pop    %edx
8010367a:	59                   	pop    %ecx
8010367b:	53                   	push   %ebx
8010367c:	56                   	push   %esi
8010367d:	e8 ce 0c 00 00       	call   80104350 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103682:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103688:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010368e:	83 c4 10             	add    $0x10,%esp
80103691:	05 00 02 00 00       	add    $0x200,%eax
80103696:	39 c2                	cmp    %eax,%edx
80103698:	75 36                	jne    801036d0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010369a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801036a0:	85 c0                	test   %eax,%eax
801036a2:	74 0c                	je     801036b0 <pipewrite+0xa0>
801036a4:	e8 67 06 00 00       	call   80103d10 <myproc>
801036a9:	8b 40 24             	mov    0x24(%eax),%eax
801036ac:	85 c0                	test   %eax,%eax
801036ae:	74 c0                	je     80103670 <pipewrite+0x60>
        release(&p->lock);
801036b0:	83 ec 0c             	sub    $0xc,%esp
801036b3:	53                   	push   %ebx
801036b4:	e8 37 13 00 00       	call   801049f0 <release>
        return -1;
801036b9:	83 c4 10             	add    $0x10,%esp
801036bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801036c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036c4:	5b                   	pop    %ebx
801036c5:	5e                   	pop    %esi
801036c6:	5f                   	pop    %edi
801036c7:	5d                   	pop    %ebp
801036c8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036c9:	89 c2                	mov    %eax,%edx
801036cb:	90                   	nop
801036cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036d0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801036d3:	8d 42 01             	lea    0x1(%edx),%eax
801036d6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036dc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801036e2:	83 c6 01             	add    $0x1,%esi
801036e5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801036e9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036ec:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036ef:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036f3:	0f 85 4f ff ff ff    	jne    80103648 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036f9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036ff:	83 ec 0c             	sub    $0xc,%esp
80103702:	50                   	push   %eax
80103703:	e8 08 0e 00 00       	call   80104510 <wakeup>
  release(&p->lock);
80103708:	89 1c 24             	mov    %ebx,(%esp)
8010370b:	e8 e0 12 00 00       	call   801049f0 <release>
  return n;
80103710:	83 c4 10             	add    $0x10,%esp
80103713:	8b 45 10             	mov    0x10(%ebp),%eax
80103716:	eb a9                	jmp    801036c1 <pipewrite+0xb1>
80103718:	90                   	nop
80103719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103720 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103720:	55                   	push   %ebp
80103721:	89 e5                	mov    %esp,%ebp
80103723:	57                   	push   %edi
80103724:	56                   	push   %esi
80103725:	53                   	push   %ebx
80103726:	83 ec 18             	sub    $0x18,%esp
80103729:	8b 75 08             	mov    0x8(%ebp),%esi
8010372c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010372f:	56                   	push   %esi
80103730:	e8 fb 11 00 00       	call   80104930 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103735:	83 c4 10             	add    $0x10,%esp
80103738:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010373e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103744:	75 6a                	jne    801037b0 <piperead+0x90>
80103746:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010374c:	85 db                	test   %ebx,%ebx
8010374e:	0f 84 c4 00 00 00    	je     80103818 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103754:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010375a:	eb 2d                	jmp    80103789 <piperead+0x69>
8010375c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103760:	83 ec 08             	sub    $0x8,%esp
80103763:	56                   	push   %esi
80103764:	53                   	push   %ebx
80103765:	e8 e6 0b 00 00       	call   80104350 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010376a:	83 c4 10             	add    $0x10,%esp
8010376d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103773:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103779:	75 35                	jne    801037b0 <piperead+0x90>
8010377b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103781:	85 d2                	test   %edx,%edx
80103783:	0f 84 8f 00 00 00    	je     80103818 <piperead+0xf8>
    if(myproc()->killed){
80103789:	e8 82 05 00 00       	call   80103d10 <myproc>
8010378e:	8b 48 24             	mov    0x24(%eax),%ecx
80103791:	85 c9                	test   %ecx,%ecx
80103793:	74 cb                	je     80103760 <piperead+0x40>
      release(&p->lock);
80103795:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103798:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010379d:	56                   	push   %esi
8010379e:	e8 4d 12 00 00       	call   801049f0 <release>
      return -1;
801037a3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801037a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037a9:	89 d8                	mov    %ebx,%eax
801037ab:	5b                   	pop    %ebx
801037ac:	5e                   	pop    %esi
801037ad:	5f                   	pop    %edi
801037ae:	5d                   	pop    %ebp
801037af:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037b0:	8b 45 10             	mov    0x10(%ebp),%eax
801037b3:	85 c0                	test   %eax,%eax
801037b5:	7e 61                	jle    80103818 <piperead+0xf8>
    if(p->nread == p->nwrite)
801037b7:	31 db                	xor    %ebx,%ebx
801037b9:	eb 13                	jmp    801037ce <piperead+0xae>
801037bb:	90                   	nop
801037bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037c0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801037c6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801037cc:	74 1f                	je     801037ed <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801037ce:	8d 41 01             	lea    0x1(%ecx),%eax
801037d1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801037d7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801037dd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801037e2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037e5:	83 c3 01             	add    $0x1,%ebx
801037e8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801037eb:	75 d3                	jne    801037c0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801037ed:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801037f3:	83 ec 0c             	sub    $0xc,%esp
801037f6:	50                   	push   %eax
801037f7:	e8 14 0d 00 00       	call   80104510 <wakeup>
  release(&p->lock);
801037fc:	89 34 24             	mov    %esi,(%esp)
801037ff:	e8 ec 11 00 00       	call   801049f0 <release>
  return i;
80103804:	83 c4 10             	add    $0x10,%esp
}
80103807:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010380a:	89 d8                	mov    %ebx,%eax
8010380c:	5b                   	pop    %ebx
8010380d:	5e                   	pop    %esi
8010380e:	5f                   	pop    %edi
8010380f:	5d                   	pop    %ebp
80103810:	c3                   	ret    
80103811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103818:	31 db                	xor    %ebx,%ebx
8010381a:	eb d1                	jmp    801037ed <piperead+0xcd>
8010381c:	66 90                	xchg   %ax,%ax
8010381e:	66 90                	xchg   %ax,%ax

80103820 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103824:	bb 54 3e 11 80       	mov    $0x80113e54,%ebx
{
80103829:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010382c:	68 20 3e 11 80       	push   $0x80113e20
80103831:	e8 fa 10 00 00       	call   80104930 <acquire>
80103836:	83 c4 10             	add    $0x10,%esp
80103839:	eb 17                	jmp    80103852 <allocproc+0x32>
8010383b:	90                   	nop
8010383c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103840:	81 c3 f4 00 00 00    	add    $0xf4,%ebx
80103846:	81 fb 54 7b 11 80    	cmp    $0x80117b54,%ebx
8010384c:	0f 83 8e 00 00 00    	jae    801038e0 <allocproc+0xc0>
    if(p->state == UNUSED)
80103852:	8b 43 0c             	mov    0xc(%ebx),%eax
80103855:	85 c0                	test   %eax,%eax
80103857:	75 e7                	jne    80103840 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103859:	a1 7c b0 10 80       	mov    0x8010b07c,%eax

  release(&ptable.lock);
8010385e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103861:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103868:	8d 50 01             	lea    0x1(%eax),%edx
8010386b:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
8010386e:	68 20 3e 11 80       	push   $0x80113e20
  p->pid = nextpid++;
80103873:	89 15 7c b0 10 80    	mov    %edx,0x8010b07c
  release(&ptable.lock);
80103879:	e8 72 11 00 00       	call   801049f0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010387e:	e8 5d ee ff ff       	call   801026e0 <kalloc>
80103883:	83 c4 10             	add    $0x10,%esp
80103886:	85 c0                	test   %eax,%eax
80103888:	89 43 08             	mov    %eax,0x8(%ebx)
8010388b:	74 6c                	je     801038f9 <allocproc+0xd9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010388d:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103893:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103896:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010389b:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010389e:	c7 40 14 6f 5f 10 80 	movl   $0x80105f6f,0x14(%eax)
  p->context = (struct context*)sp;
801038a5:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801038a8:	6a 14                	push   $0x14
801038aa:	6a 00                	push   $0x0
801038ac:	50                   	push   %eax
801038ad:	e8 8e 11 00 00       	call   80104a40 <memset>
  p->context->eip = (uint)forkret;
801038b2:	8b 43 1c             	mov    0x1c(%ebx),%eax
  // this changes are for sched algorithms
  p->tickets = 10;
  p->sched_queue = LOTTERY;


  return p;
801038b5:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801038b8:	c7 40 10 10 39 10 80 	movl   $0x80103910,0x10(%eax)
  p->tickets = 10;
801038bf:	c7 83 dc 00 00 00 0a 	movl   $0xa,0xdc(%ebx)
801038c6:	00 00 00 
  p->sched_queue = LOTTERY;
801038c9:	c7 83 d8 00 00 00 02 	movl   $0x2,0xd8(%ebx)
801038d0:	00 00 00 
}
801038d3:	89 d8                	mov    %ebx,%eax
801038d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038d8:	c9                   	leave  
801038d9:	c3                   	ret    
801038da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801038e0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801038e3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801038e5:	68 20 3e 11 80       	push   $0x80113e20
801038ea:	e8 01 11 00 00       	call   801049f0 <release>
}
801038ef:	89 d8                	mov    %ebx,%eax
  return 0;
801038f1:	83 c4 10             	add    $0x10,%esp
}
801038f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038f7:	c9                   	leave  
801038f8:	c3                   	ret    
    p->state = UNUSED;
801038f9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103900:	31 db                	xor    %ebx,%ebx
80103902:	eb cf                	jmp    801038d3 <allocproc+0xb3>
80103904:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010390a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103910 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103916:	68 20 3e 11 80       	push   $0x80113e20
8010391b:	e8 d0 10 00 00       	call   801049f0 <release>

  if (first) {
80103920:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103925:	83 c4 10             	add    $0x10,%esp
80103928:	85 c0                	test   %eax,%eax
8010392a:	75 04                	jne    80103930 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010392c:	c9                   	leave  
8010392d:	c3                   	ret    
8010392e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103930:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103933:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010393a:	00 00 00 
    iinit(ROOTDEV);
8010393d:	6a 01                	push   $0x1
8010393f:	e8 5c dd ff ff       	call   801016a0 <iinit>
    initlog(ROOTDEV);
80103944:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010394b:	e8 d0 f3 ff ff       	call   80102d20 <initlog>
80103950:	83 c4 10             	add    $0x10,%esp
}
80103953:	c9                   	leave  
80103954:	c3                   	ret    
80103955:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103960 <set_all_zero>:
{
80103960:	55                   	push   %ebp
80103961:	b9 d0 3e 11 80       	mov    $0x80113ed0,%ecx
80103966:	89 e5                	mov    %esp,%ebp
80103968:	90                   	nop
80103969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103970:	8d 51 5c             	lea    0x5c(%ecx),%edx
80103973:	89 c8                	mov    %ecx,%eax
80103975:	8d 76 00             	lea    0x0(%esi),%esi
      ptable.proc[i].syscalls[j] = 0;
80103978:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010397e:	83 c0 04             	add    $0x4,%eax
    for(int j=0;j<23;j++)
80103981:	39 d0                	cmp    %edx,%eax
80103983:	75 f3                	jne    80103978 <set_all_zero+0x18>
80103985:	81 c1 f4 00 00 00    	add    $0xf4,%ecx
  for(int i=0;i<NPROC;i++)
8010398b:	81 f9 d0 7b 11 80    	cmp    $0x80117bd0,%ecx
80103991:	75 dd                	jne    80103970 <set_all_zero+0x10>
}
80103993:	5d                   	pop    %ebp
80103994:	c3                   	ret    
80103995:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801039a0 <set_state>:
void set_state(int _state){ ptable.state = _state;}
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	8b 45 08             	mov    0x8(%ebp),%eax
801039a6:	5d                   	pop    %ebp
801039a7:	a3 54 7b 11 80       	mov    %eax,0x80117b54
801039ac:	c3                   	ret    
801039ad:	8d 76 00             	lea    0x0(%esi),%esi

801039b0 <show_syscalls>:
  if (ptable.state == 0){
801039b0:	8b 15 54 7b 11 80    	mov    0x80117b54,%edx
801039b6:	b9 d0 3e 11 80       	mov    $0x80113ed0,%ecx
801039bb:	85 d2                	test   %edx,%edx
801039bd:	0f 84 93 00 00 00    	je     80103a56 <show_syscalls+0xa6>
{
801039c3:	55                   	push   %ebp
801039c4:	89 e5                	mov    %esp,%ebp
801039c6:	56                   	push   %esi
801039c7:	31 f6                	xor    %esi,%esi
801039c9:	53                   	push   %ebx
801039ca:	eb 12                	jmp    801039de <show_syscalls+0x2e>
801039cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039d0:	81 c6 f4 00 00 00    	add    $0xf4,%esi
  for(int i=0;i<NPROC;i++)
801039d6:	81 fe 00 3d 00 00    	cmp    $0x3d00,%esi
801039dc:	74 5d                	je     80103a3b <show_syscalls+0x8b>
    if(ptable.proc[i].pid == 0)
801039de:	8b 86 64 3e 11 80    	mov    -0x7feec19c(%esi),%eax
801039e4:	85 c0                	test   %eax,%eax
801039e6:	74 e8                	je     801039d0 <show_syscalls+0x20>
    cprintf("%s: %d\n",ptable.proc[i].name);
801039e8:	8d 86 c0 3e 11 80    	lea    -0x7feec140(%esi),%eax
801039ee:	83 ec 08             	sub    $0x8,%esp
801039f1:	31 db                	xor    %ebx,%ebx
801039f3:	50                   	push   %eax
801039f4:	68 35 7d 10 80       	push   $0x80107d35
801039f9:	e8 62 cc ff ff       	call   80100660 <cprintf>
801039fe:	83 c4 10             	add    $0x10,%esp
80103a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      cprintf("%s: %d\n",syscall_names[j], ptable.proc[i].syscalls[j]);
80103a08:	83 ec 04             	sub    $0x4,%esp
80103a0b:	ff b4 1e d0 3e 11 80 	pushl  -0x7feec130(%esi,%ebx,1)
80103a12:	ff b3 20 b0 10 80    	pushl  -0x7fef4fe0(%ebx)
80103a18:	68 35 7d 10 80       	push   $0x80107d35
80103a1d:	83 c3 04             	add    $0x4,%ebx
80103a20:	e8 3b cc ff ff       	call   80100660 <cprintf>
    for(int j=0;j<23;j++)
80103a25:	83 c4 10             	add    $0x10,%esp
80103a28:	83 fb 5c             	cmp    $0x5c,%ebx
80103a2b:	75 db                	jne    80103a08 <show_syscalls+0x58>
80103a2d:	81 c6 f4 00 00 00    	add    $0xf4,%esi
  for(int i=0;i<NPROC;i++)
80103a33:	81 fe 00 3d 00 00    	cmp    $0x3d00,%esi
80103a39:	75 a3                	jne    801039de <show_syscalls+0x2e>
}
80103a3b:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a3e:	5b                   	pop    %ebx
80103a3f:	5e                   	pop    %esi
80103a40:	5d                   	pop    %ebp
80103a41:	c3                   	ret    
80103a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a48:	81 c1 f4 00 00 00    	add    $0xf4,%ecx
  for(int i=0;i<NPROC;i++)
80103a4e:	81 f9 d0 7b 11 80    	cmp    $0x80117bd0,%ecx
80103a54:	74 19                	je     80103a6f <show_syscalls+0xbf>
80103a56:	8d 51 5c             	lea    0x5c(%ecx),%edx
{
80103a59:	89 c8                	mov    %ecx,%eax
80103a5b:	90                   	nop
80103a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ptable.proc[i].syscalls[j] = 0;
80103a60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103a66:	83 c0 04             	add    $0x4,%eax
    for(int j=0;j<23;j++)
80103a69:	39 d0                	cmp    %edx,%eax
80103a6b:	75 f3                	jne    80103a60 <show_syscalls+0xb0>
80103a6d:	eb d9                	jmp    80103a48 <show_syscalls+0x98>
80103a6f:	f3 c3                	repz ret 
80103a71:	eb 0d                	jmp    80103a80 <show_children>
80103a73:	90                   	nop
80103a74:	90                   	nop
80103a75:	90                   	nop
80103a76:	90                   	nop
80103a77:	90                   	nop
80103a78:	90                   	nop
80103a79:	90                   	nop
80103a7a:	90                   	nop
80103a7b:	90                   	nop
80103a7c:	90                   	nop
80103a7d:	90                   	nop
80103a7e:	90                   	nop
80103a7f:	90                   	nop

80103a80 <show_children>:
{
80103a80:	55                   	push   %ebp
  int have_children = 0;
80103a81:	31 d2                	xor    %edx,%edx
{
80103a83:	89 e5                	mov    %esp,%ebp
80103a85:	56                   	push   %esi
80103a86:	53                   	push   %ebx
80103a87:	8b 75 08             	mov    0x8(%ebp),%esi
80103a8a:	bb 64 3e 11 80       	mov    $0x80113e64,%ebx
80103a8f:	eb 15                	jmp    80103aa6 <show_children+0x26>
80103a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a98:	81 c3 f4 00 00 00    	add    $0xf4,%ebx
  for(int i=0;i<NPROC;i++)
80103a9e:	81 fb 64 7b 11 80    	cmp    $0x80117b64,%ebx
80103aa4:	74 2d                	je     80103ad3 <show_children+0x53>
    if(ptable.proc[i].parent->pid == parent_pid)
80103aa6:	8b 43 04             	mov    0x4(%ebx),%eax
80103aa9:	39 70 10             	cmp    %esi,0x10(%eax)
80103aac:	75 ea                	jne    80103a98 <show_children+0x18>
      cprintf("%d",ptable.proc[i].pid);
80103aae:	83 ec 08             	sub    $0x8,%esp
80103ab1:	ff 33                	pushl  (%ebx)
80103ab3:	81 c3 f4 00 00 00    	add    $0xf4,%ebx
80103ab9:	68 3d 7d 10 80       	push   $0x80107d3d
80103abe:	e8 9d cb ff ff       	call   80100660 <cprintf>
80103ac3:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i<NPROC;i++)
80103ac6:	81 fb 64 7b 11 80    	cmp    $0x80117b64,%ebx
      have_children = 1;
80103acc:	ba 01 00 00 00       	mov    $0x1,%edx
  for(int i=0;i<NPROC;i++)
80103ad1:	75 d3                	jne    80103aa6 <show_children+0x26>
  if(have_children)
80103ad3:	85 d2                	test   %edx,%edx
80103ad5:	75 07                	jne    80103ade <show_children+0x5e>
}
80103ad7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ada:	5b                   	pop    %ebx
80103adb:	5e                   	pop    %esi
80103adc:	5d                   	pop    %ebp
80103add:	c3                   	ret    
    cprintf("\n");
80103ade:	c7 45 08 0f 82 10 80 	movl   $0x8010820f,0x8(%ebp)
}
80103ae5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ae8:	5b                   	pop    %ebx
80103ae9:	5e                   	pop    %esi
80103aea:	5d                   	pop    %ebp
    cprintf("\n");
80103aeb:	e9 70 cb ff ff       	jmp    80100660 <cprintf>

80103af0 <show_grandchildren>:
{
80103af0:	55                   	push   %ebp
  int have_children = 0;
80103af1:	31 d2                	xor    %edx,%edx
{
80103af3:	89 e5                	mov    %esp,%ebp
80103af5:	56                   	push   %esi
80103af6:	53                   	push   %ebx
80103af7:	8b 75 08             	mov    0x8(%ebp),%esi
80103afa:	bb 64 3e 11 80       	mov    $0x80113e64,%ebx
80103aff:	eb 15                	jmp    80103b16 <show_grandchildren+0x26>
80103b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b08:	81 c3 f4 00 00 00    	add    $0xf4,%ebx
  for(int i=0;i<NPROC;i++)
80103b0e:	81 fb 64 7b 11 80    	cmp    $0x80117b64,%ebx
80103b14:	74 3a                	je     80103b50 <show_grandchildren+0x60>
    if(ptable.proc[i].parent->pid == parent_pid)
80103b16:	8b 43 04             	mov    0x4(%ebx),%eax
80103b19:	39 70 10             	cmp    %esi,0x10(%eax)
80103b1c:	75 ea                	jne    80103b08 <show_grandchildren+0x18>
      cprintf("%d",ptable.proc[i].pid);
80103b1e:	83 ec 08             	sub    $0x8,%esp
80103b21:	ff 33                	pushl  (%ebx)
80103b23:	81 c3 f4 00 00 00    	add    $0xf4,%ebx
80103b29:	68 3d 7d 10 80       	push   $0x80107d3d
80103b2e:	e8 2d cb ff ff       	call   80100660 <cprintf>
      show_grandchildren(ptable.proc[i].pid);
80103b33:	58                   	pop    %eax
80103b34:	ff b3 0c ff ff ff    	pushl  -0xf4(%ebx)
80103b3a:	e8 b1 ff ff ff       	call   80103af0 <show_grandchildren>
80103b3f:	83 c4 10             	add    $0x10,%esp
  for(int i=0;i<NPROC;i++)
80103b42:	81 fb 64 7b 11 80    	cmp    $0x80117b64,%ebx
      have_children = 1;
80103b48:	ba 01 00 00 00       	mov    $0x1,%edx
  for(int i=0;i<NPROC;i++)
80103b4d:	75 c7                	jne    80103b16 <show_grandchildren+0x26>
80103b4f:	90                   	nop
  if(have_children)
80103b50:	85 d2                	test   %edx,%edx
80103b52:	75 07                	jne    80103b5b <show_grandchildren+0x6b>
}
80103b54:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b57:	5b                   	pop    %ebx
80103b58:	5e                   	pop    %esi
80103b59:	5d                   	pop    %ebp
80103b5a:	c3                   	ret    
    cprintf("\n");
80103b5b:	c7 45 08 0f 82 10 80 	movl   $0x8010820f,0x8(%ebp)
}
80103b62:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b65:	5b                   	pop    %ebx
80103b66:	5e                   	pop    %esi
80103b67:	5d                   	pop    %ebp
    cprintf("\n");
80103b68:	e9 f3 ca ff ff       	jmp    80100660 <cprintf>
80103b6d:	8d 76 00             	lea    0x0(%esi),%esi

80103b70 <change_sched_queue>:
{
80103b70:	55                   	push   %ebp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b71:	b8 54 3e 11 80       	mov    $0x80113e54,%eax
{
80103b76:	89 e5                	mov    %esp,%ebp
80103b78:	8b 55 08             	mov    0x8(%ebp),%edx
80103b7b:	eb 0f                	jmp    80103b8c <change_sched_queue+0x1c>
80103b7d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b80:	05 f4 00 00 00       	add    $0xf4,%eax
80103b85:	3d 54 7b 11 80       	cmp    $0x80117b54,%eax
80103b8a:	73 0e                	jae    80103b9a <change_sched_queue+0x2a>
    if(p->pid == pid)
80103b8c:	39 50 10             	cmp    %edx,0x10(%eax)
80103b8f:	75 ef                	jne    80103b80 <change_sched_queue+0x10>
      p->sched_queue = dst_queue;
80103b91:	8b 55 0c             	mov    0xc(%ebp),%edx
80103b94:	89 90 d8 00 00 00    	mov    %edx,0xd8(%eax)
}
80103b9a:	5d                   	pop    %ebp
80103b9b:	c3                   	ret    
80103b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ba0 <set_ticket>:
{
80103ba0:	55                   	push   %ebp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ba1:	b8 54 3e 11 80       	mov    $0x80113e54,%eax
{
80103ba6:	89 e5                	mov    %esp,%ebp
80103ba8:	8b 55 08             	mov    0x8(%ebp),%edx
80103bab:	eb 0f                	jmp    80103bbc <set_ticket+0x1c>
80103bad:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bb0:	05 f4 00 00 00       	add    $0xf4,%eax
80103bb5:	3d 54 7b 11 80       	cmp    $0x80117b54,%eax
80103bba:	73 0e                	jae    80103bca <set_ticket+0x2a>
    if(p->pid == pid)
80103bbc:	39 50 10             	cmp    %edx,0x10(%eax)
80103bbf:	75 ef                	jne    80103bb0 <set_ticket+0x10>
      p->tickets = tickets;
80103bc1:	8b 55 0c             	mov    0xc(%ebp),%edx
80103bc4:	89 90 dc 00 00 00    	mov    %edx,0xdc(%eax)
}
80103bca:	5d                   	pop    %ebp
80103bcb:	c3                   	ret    
80103bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103bd0 <set_ratio_process>:
{
80103bd0:	55                   	push   %ebp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bd1:	b8 54 3e 11 80       	mov    $0x80113e54,%eax
{
80103bd6:	89 e5                	mov    %esp,%ebp
80103bd8:	8b 55 08             	mov    0x8(%ebp),%edx
80103bdb:	eb 0f                	jmp    80103bec <set_ratio_process+0x1c>
80103bdd:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103be0:	05 f4 00 00 00       	add    $0xf4,%eax
80103be5:	3d 54 7b 11 80       	cmp    $0x80117b54,%eax
80103bea:	73 20                	jae    80103c0c <set_ratio_process+0x3c>
    if(p->pid == pid)
80103bec:	39 50 10             	cmp    %edx,0x10(%eax)
80103bef:	75 ef                	jne    80103be0 <set_ratio_process+0x10>
      p->priority_ratio = priority_ratio;
80103bf1:	8b 55 0c             	mov    0xc(%ebp),%edx
80103bf4:	89 90 e8 00 00 00    	mov    %edx,0xe8(%eax)
      p->arrival_time_ratio = arrival_time_ratio;
80103bfa:	8b 55 10             	mov    0x10(%ebp),%edx
80103bfd:	89 90 ec 00 00 00    	mov    %edx,0xec(%eax)
      p->executed_cycle_ratio = executed_cycle_ratio;
80103c03:	8b 55 14             	mov    0x14(%ebp),%edx
80103c06:	89 90 f0 00 00 00    	mov    %edx,0xf0(%eax)
}
80103c0c:	5d                   	pop    %ebp
80103c0d:	c3                   	ret    
80103c0e:	66 90                	xchg   %ax,%ax

80103c10 <set_ratio_system>:
{
80103c10:	55                   	push   %ebp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c11:	b8 54 3e 11 80       	mov    $0x80113e54,%eax
{
80103c16:	89 e5                	mov    %esp,%ebp
80103c18:	53                   	push   %ebx
80103c19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103c1c:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103c1f:	8b 55 10             	mov    0x10(%ebp),%edx
80103c22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(p->pid > 0)
80103c28:	83 78 10 00          	cmpl   $0x0,0x10(%eax)
80103c2c:	7e 12                	jle    80103c40 <set_ratio_system+0x30>
      p->priority_ratio = priority_ratio;
80103c2e:	89 98 e8 00 00 00    	mov    %ebx,0xe8(%eax)
      p->arrival_time_ratio = arrival_time_ratio;
80103c34:	89 88 ec 00 00 00    	mov    %ecx,0xec(%eax)
      p->executed_cycle_ratio = executed_cycle_ratio;
80103c3a:	89 90 f0 00 00 00    	mov    %edx,0xf0(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c40:	05 f4 00 00 00       	add    $0xf4,%eax
80103c45:	3d 54 7b 11 80       	cmp    $0x80117b54,%eax
80103c4a:	72 dc                	jb     80103c28 <set_ratio_system+0x18>
}
80103c4c:	5b                   	pop    %ebx
80103c4d:	5d                   	pop    %ebp
80103c4e:	c3                   	ret    
80103c4f:	90                   	nop

80103c50 <pinit>:
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103c56:	68 40 7d 10 80       	push   $0x80107d40
80103c5b:	68 20 3e 11 80       	push   $0x80113e20
80103c60:	e8 8b 0b 00 00       	call   801047f0 <initlock>
}
80103c65:	83 c4 10             	add    $0x10,%esp
80103c68:	c9                   	leave  
80103c69:	c3                   	ret    
80103c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c70 <mycpu>:
{
80103c70:	55                   	push   %ebp
80103c71:	89 e5                	mov    %esp,%ebp
80103c73:	56                   	push   %esi
80103c74:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c75:	9c                   	pushf  
80103c76:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103c77:	f6 c4 02             	test   $0x2,%ah
80103c7a:	75 5e                	jne    80103cda <mycpu+0x6a>
  apicid = lapicid();
80103c7c:	e8 cf ec ff ff       	call   80102950 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103c81:	8b 35 00 3e 11 80    	mov    0x80113e00,%esi
80103c87:	85 f6                	test   %esi,%esi
80103c89:	7e 42                	jle    80103ccd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103c8b:	0f b6 15 80 38 11 80 	movzbl 0x80113880,%edx
80103c92:	39 d0                	cmp    %edx,%eax
80103c94:	74 30                	je     80103cc6 <mycpu+0x56>
80103c96:	b9 30 39 11 80       	mov    $0x80113930,%ecx
  for (i = 0; i < ncpu; ++i) {
80103c9b:	31 d2                	xor    %edx,%edx
80103c9d:	8d 76 00             	lea    0x0(%esi),%esi
80103ca0:	83 c2 01             	add    $0x1,%edx
80103ca3:	39 f2                	cmp    %esi,%edx
80103ca5:	74 26                	je     80103ccd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103ca7:	0f b6 19             	movzbl (%ecx),%ebx
80103caa:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103cb0:	39 c3                	cmp    %eax,%ebx
80103cb2:	75 ec                	jne    80103ca0 <mycpu+0x30>
80103cb4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103cba:	05 80 38 11 80       	add    $0x80113880,%eax
}
80103cbf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cc2:	5b                   	pop    %ebx
80103cc3:	5e                   	pop    %esi
80103cc4:	5d                   	pop    %ebp
80103cc5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103cc6:	b8 80 38 11 80       	mov    $0x80113880,%eax
      return &cpus[i];
80103ccb:	eb f2                	jmp    80103cbf <mycpu+0x4f>
  panic("unknown apicid\n");
80103ccd:	83 ec 0c             	sub    $0xc,%esp
80103cd0:	68 47 7d 10 80       	push   $0x80107d47
80103cd5:	e8 b6 c6 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103cda:	83 ec 0c             	sub    $0xc,%esp
80103cdd:	68 8c 7e 10 80       	push   $0x80107e8c
80103ce2:	e8 a9 c6 ff ff       	call   80100390 <panic>
80103ce7:	89 f6                	mov    %esi,%esi
80103ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103cf0 <cpuid>:
cpuid() {
80103cf0:	55                   	push   %ebp
80103cf1:	89 e5                	mov    %esp,%ebp
80103cf3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103cf6:	e8 75 ff ff ff       	call   80103c70 <mycpu>
80103cfb:	2d 80 38 11 80       	sub    $0x80113880,%eax
}
80103d00:	c9                   	leave  
  return mycpu()-cpus;
80103d01:	c1 f8 04             	sar    $0x4,%eax
80103d04:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103d0a:	c3                   	ret    
80103d0b:	90                   	nop
80103d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103d10 <myproc>:
myproc(void) {
80103d10:	55                   	push   %ebp
80103d11:	89 e5                	mov    %esp,%ebp
80103d13:	53                   	push   %ebx
80103d14:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103d17:	e8 44 0b 00 00       	call   80104860 <pushcli>
  c = mycpu();
80103d1c:	e8 4f ff ff ff       	call   80103c70 <mycpu>
  p = c->proc;
80103d21:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d27:	e8 74 0b 00 00       	call   801048a0 <popcli>
}
80103d2c:	83 c4 04             	add    $0x4,%esp
80103d2f:	89 d8                	mov    %ebx,%eax
80103d31:	5b                   	pop    %ebx
80103d32:	5d                   	pop    %ebp
80103d33:	c3                   	ret    
80103d34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103d3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103d40 <userinit>:
{
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	53                   	push   %ebx
80103d44:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103d47:	e8 d4 fa ff ff       	call   80103820 <allocproc>
80103d4c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103d4e:	a3 38 b6 10 80       	mov    %eax,0x8010b638
  if((p->pgdir = setupkvm()) == 0)
80103d53:	e8 e8 37 00 00       	call   80107540 <setupkvm>
80103d58:	85 c0                	test   %eax,%eax
80103d5a:	89 43 04             	mov    %eax,0x4(%ebx)
80103d5d:	0f 84 bd 00 00 00    	je     80103e20 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103d63:	83 ec 04             	sub    $0x4,%esp
80103d66:	68 2c 00 00 00       	push   $0x2c
80103d6b:	68 c0 b4 10 80       	push   $0x8010b4c0
80103d70:	50                   	push   %eax
80103d71:	e8 aa 34 00 00       	call   80107220 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103d76:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103d79:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103d7f:	6a 4c                	push   $0x4c
80103d81:	6a 00                	push   $0x0
80103d83:	ff 73 18             	pushl  0x18(%ebx)
80103d86:	e8 b5 0c 00 00       	call   80104a40 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103d8b:	8b 43 18             	mov    0x18(%ebx),%eax
80103d8e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103d93:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103d98:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103d9b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103d9f:	8b 43 18             	mov    0x18(%ebx),%eax
80103da2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103da6:	8b 43 18             	mov    0x18(%ebx),%eax
80103da9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103dad:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103db1:	8b 43 18             	mov    0x18(%ebx),%eax
80103db4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103db8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103dbc:	8b 43 18             	mov    0x18(%ebx),%eax
80103dbf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103dc6:	8b 43 18             	mov    0x18(%ebx),%eax
80103dc9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103dd0:	8b 43 18             	mov    0x18(%ebx),%eax
80103dd3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103dda:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103ddd:	6a 10                	push   $0x10
80103ddf:	68 70 7d 10 80       	push   $0x80107d70
80103de4:	50                   	push   %eax
80103de5:	e8 36 0e 00 00       	call   80104c20 <safestrcpy>
  p->cwd = namei("/");
80103dea:	c7 04 24 79 7d 10 80 	movl   $0x80107d79,(%esp)
80103df1:	e8 0a e3 ff ff       	call   80102100 <namei>
80103df6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103df9:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
80103e00:	e8 2b 0b 00 00       	call   80104930 <acquire>
  p->state = RUNNABLE;
80103e05:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103e0c:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
80103e13:	e8 d8 0b 00 00       	call   801049f0 <release>
}
80103e18:	83 c4 10             	add    $0x10,%esp
80103e1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e1e:	c9                   	leave  
80103e1f:	c3                   	ret    
    panic("userinit: out of memory?");
80103e20:	83 ec 0c             	sub    $0xc,%esp
80103e23:	68 57 7d 10 80       	push   $0x80107d57
80103e28:	e8 63 c5 ff ff       	call   80100390 <panic>
80103e2d:	8d 76 00             	lea    0x0(%esi),%esi

80103e30 <growproc>:
{
80103e30:	55                   	push   %ebp
80103e31:	89 e5                	mov    %esp,%ebp
80103e33:	56                   	push   %esi
80103e34:	53                   	push   %ebx
80103e35:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103e38:	e8 23 0a 00 00       	call   80104860 <pushcli>
  c = mycpu();
80103e3d:	e8 2e fe ff ff       	call   80103c70 <mycpu>
  p = c->proc;
80103e42:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e48:	e8 53 0a 00 00       	call   801048a0 <popcli>
  if(n > 0){
80103e4d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103e50:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103e52:	7f 1c                	jg     80103e70 <growproc+0x40>
  } else if(n < 0){
80103e54:	75 3a                	jne    80103e90 <growproc+0x60>
  switchuvm(curproc);
80103e56:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103e59:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103e5b:	53                   	push   %ebx
80103e5c:	e8 af 32 00 00       	call   80107110 <switchuvm>
  return 0;
80103e61:	83 c4 10             	add    $0x10,%esp
80103e64:	31 c0                	xor    %eax,%eax
}
80103e66:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e69:	5b                   	pop    %ebx
80103e6a:	5e                   	pop    %esi
80103e6b:	5d                   	pop    %ebp
80103e6c:	c3                   	ret    
80103e6d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103e70:	83 ec 04             	sub    $0x4,%esp
80103e73:	01 c6                	add    %eax,%esi
80103e75:	56                   	push   %esi
80103e76:	50                   	push   %eax
80103e77:	ff 73 04             	pushl  0x4(%ebx)
80103e7a:	e8 e1 34 00 00       	call   80107360 <allocuvm>
80103e7f:	83 c4 10             	add    $0x10,%esp
80103e82:	85 c0                	test   %eax,%eax
80103e84:	75 d0                	jne    80103e56 <growproc+0x26>
      return -1;
80103e86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e8b:	eb d9                	jmp    80103e66 <growproc+0x36>
80103e8d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103e90:	83 ec 04             	sub    $0x4,%esp
80103e93:	01 c6                	add    %eax,%esi
80103e95:	56                   	push   %esi
80103e96:	50                   	push   %eax
80103e97:	ff 73 04             	pushl  0x4(%ebx)
80103e9a:	e8 f1 35 00 00       	call   80107490 <deallocuvm>
80103e9f:	83 c4 10             	add    $0x10,%esp
80103ea2:	85 c0                	test   %eax,%eax
80103ea4:	75 b0                	jne    80103e56 <growproc+0x26>
80103ea6:	eb de                	jmp    80103e86 <growproc+0x56>
80103ea8:	90                   	nop
80103ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103eb0 <fork>:
{
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	57                   	push   %edi
80103eb4:	56                   	push   %esi
80103eb5:	53                   	push   %ebx
80103eb6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103eb9:	e8 a2 09 00 00       	call   80104860 <pushcli>
  c = mycpu();
80103ebe:	e8 ad fd ff ff       	call   80103c70 <mycpu>
  p = c->proc;
80103ec3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ec9:	e8 d2 09 00 00       	call   801048a0 <popcli>
  if((np = allocproc()) == 0){
80103ece:	e8 4d f9 ff ff       	call   80103820 <allocproc>
80103ed3:	85 c0                	test   %eax,%eax
80103ed5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103ed8:	0f 84 b7 00 00 00    	je     80103f95 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103ede:	83 ec 08             	sub    $0x8,%esp
80103ee1:	ff 33                	pushl  (%ebx)
80103ee3:	ff 73 04             	pushl  0x4(%ebx)
80103ee6:	89 c7                	mov    %eax,%edi
80103ee8:	e8 23 37 00 00       	call   80107610 <copyuvm>
80103eed:	83 c4 10             	add    $0x10,%esp
80103ef0:	85 c0                	test   %eax,%eax
80103ef2:	89 47 04             	mov    %eax,0x4(%edi)
80103ef5:	0f 84 a1 00 00 00    	je     80103f9c <fork+0xec>
  np->sz = curproc->sz;
80103efb:	8b 03                	mov    (%ebx),%eax
80103efd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103f00:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103f02:	89 59 14             	mov    %ebx,0x14(%ecx)
80103f05:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103f07:	8b 79 18             	mov    0x18(%ecx),%edi
80103f0a:	8b 73 18             	mov    0x18(%ebx),%esi
80103f0d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103f12:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103f14:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103f16:	8b 40 18             	mov    0x18(%eax),%eax
80103f19:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103f20:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103f24:	85 c0                	test   %eax,%eax
80103f26:	74 13                	je     80103f3b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103f28:	83 ec 0c             	sub    $0xc,%esp
80103f2b:	50                   	push   %eax
80103f2c:	e8 df d0 ff ff       	call   80101010 <filedup>
80103f31:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103f34:	83 c4 10             	add    $0x10,%esp
80103f37:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103f3b:	83 c6 01             	add    $0x1,%esi
80103f3e:	83 fe 10             	cmp    $0x10,%esi
80103f41:	75 dd                	jne    80103f20 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103f43:	83 ec 0c             	sub    $0xc,%esp
80103f46:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f49:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103f4c:	e8 1f d9 ff ff       	call   80101870 <idup>
80103f51:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f54:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103f57:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f5a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103f5d:	6a 10                	push   $0x10
80103f5f:	53                   	push   %ebx
80103f60:	50                   	push   %eax
80103f61:	e8 ba 0c 00 00       	call   80104c20 <safestrcpy>
  pid = np->pid;
80103f66:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103f69:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
80103f70:	e8 bb 09 00 00       	call   80104930 <acquire>
  np->state = RUNNABLE;
80103f75:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103f7c:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
80103f83:	e8 68 0a 00 00       	call   801049f0 <release>
  return pid;
80103f88:	83 c4 10             	add    $0x10,%esp
}
80103f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f8e:	89 d8                	mov    %ebx,%eax
80103f90:	5b                   	pop    %ebx
80103f91:	5e                   	pop    %esi
80103f92:	5f                   	pop    %edi
80103f93:	5d                   	pop    %ebp
80103f94:	c3                   	ret    
    return -1;
80103f95:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103f9a:	eb ef                	jmp    80103f8b <fork+0xdb>
    kfree(np->kstack);
80103f9c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103f9f:	83 ec 0c             	sub    $0xc,%esp
80103fa2:	ff 73 08             	pushl  0x8(%ebx)
80103fa5:	e8 86 e5 ff ff       	call   80102530 <kfree>
    np->kstack = 0;
80103faa:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103fb1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103fb8:	83 c4 10             	add    $0x10,%esp
80103fbb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103fc0:	eb c9                	jmp    80103f8b <fork+0xdb>
80103fc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fd0 <generate_random_ticket>:
  random_ticket = (13780810*ticks + 13780825*ticks + 13790629*ticks) % mod;
80103fd0:	69 05 a0 83 11 80 48 	imul   $0x276fc48,0x801183a0,%eax
80103fd7:	fc 76 02 
{
80103fda:	55                   	push   %ebp
  random_ticket = (13780810*ticks + 13780825*ticks + 13790629*ticks) % mod;
80103fdb:	31 d2                	xor    %edx,%edx
{
80103fdd:	89 e5                	mov    %esp,%ebp
  random_ticket = (13780810*ticks + 13780825*ticks + 13790629*ticks) % mod;
80103fdf:	f7 75 08             	divl   0x8(%ebp)
}
80103fe2:	5d                   	pop    %ebp
80103fe3:	89 d0                	mov    %edx,%eax
80103fe5:	c3                   	ret    
80103fe6:	8d 76 00             	lea    0x0(%esi),%esi
80103fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ff0 <lottery_scheduler>:
{
80103ff0:	55                   	push   %ebp
  int sum_tickets = 1;
80103ff1:	b9 01 00 00 00       	mov    $0x1,%ecx
  for(p = ptable.proc ; p < &ptable.proc[NPROC]; p++)
80103ff6:	b8 54 3e 11 80       	mov    $0x80113e54,%eax
{
80103ffb:	89 e5                	mov    %esp,%ebp
80103ffd:	8d 76 00             	lea    0x0(%esi),%esi
    if(p->state != RUNNABLE || p->sched_queue != LOTTERY)
80104000:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104004:	75 0f                	jne    80104015 <lottery_scheduler+0x25>
80104006:	83 b8 d8 00 00 00 02 	cmpl   $0x2,0xd8(%eax)
8010400d:	75 06                	jne    80104015 <lottery_scheduler+0x25>
    sum_tickets += p->tickets;
8010400f:	03 88 dc 00 00 00    	add    0xdc(%eax),%ecx
  for(p = ptable.proc ; p < &ptable.proc[NPROC]; p++)
80104015:	05 f4 00 00 00       	add    $0xf4,%eax
8010401a:	3d 54 7b 11 80       	cmp    $0x80117b54,%eax
8010401f:	72 df                	jb     80104000 <lottery_scheduler+0x10>
  random_ticket = (13780810*ticks + 13780825*ticks + 13790629*ticks) % mod;
80104021:	69 05 a0 83 11 80 48 	imul   $0x276fc48,0x801183a0,%eax
80104028:	fc 76 02 
8010402b:	31 d2                	xor    %edx,%edx
8010402d:	f7 f1                	div    %ecx
  for(p = ptable.proc ; p < &ptable.proc[NPROC]; p++)
8010402f:	b8 54 3e 11 80       	mov    $0x80113e54,%eax
80104034:	eb 16                	jmp    8010404c <lottery_scheduler+0x5c>
80104036:	8d 76 00             	lea    0x0(%esi),%esi
80104039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104040:	05 f4 00 00 00       	add    $0xf4,%eax
80104045:	3d 54 7b 11 80       	cmp    $0x80117b54,%eax
8010404a:	73 1b                	jae    80104067 <lottery_scheduler+0x77>
    if(p->state != RUNNABLE || p->sched_queue != LOTTERY)
8010404c:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104050:	75 ee                	jne    80104040 <lottery_scheduler+0x50>
80104052:	83 b8 d8 00 00 00 02 	cmpl   $0x2,0xd8(%eax)
80104059:	75 e5                	jne    80104040 <lottery_scheduler+0x50>
    random_ticket -= p->tickets;
8010405b:	2b 90 dc 00 00 00    	sub    0xdc(%eax),%edx
    if (random_ticket <= 0)
80104061:	85 d2                	test   %edx,%edx
80104063:	7f db                	jg     80104040 <lottery_scheduler+0x50>
}
80104065:	5d                   	pop    %ebp
80104066:	c3                   	ret    
  return 0;
80104067:	31 c0                	xor    %eax,%eax
}
80104069:	5d                   	pop    %ebp
8010406a:	c3                   	ret    
8010406b:	90                   	nop
8010406c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104070 <scheduler>:
{
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	57                   	push   %edi
80104074:	56                   	push   %esi
80104075:	53                   	push   %ebx
80104076:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80104079:	e8 f2 fb ff ff       	call   80103c70 <mycpu>
8010407e:	8d 78 04             	lea    0x4(%eax),%edi
80104081:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80104083:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010408a:	00 00 00 
8010408d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104090:	fb                   	sti    
    acquire(&ptable.lock);
80104091:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104094:	bb 54 3e 11 80       	mov    $0x80113e54,%ebx
    acquire(&ptable.lock);
80104099:	68 20 3e 11 80       	push   $0x80113e20
8010409e:	e8 8d 08 00 00       	call   80104930 <acquire>
801040a3:	83 c4 10             	add    $0x10,%esp
801040a6:	8d 76 00             	lea    0x0(%esi),%esi
801040a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
801040b0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801040b4:	75 33                	jne    801040e9 <scheduler+0x79>
      switchuvm(p);
801040b6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
801040b9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801040bf:	53                   	push   %ebx
801040c0:	e8 4b 30 00 00       	call   80107110 <switchuvm>
      swtch(&(c->scheduler), p->context);
801040c5:	58                   	pop    %eax
801040c6:	5a                   	pop    %edx
801040c7:	ff 73 1c             	pushl  0x1c(%ebx)
801040ca:	57                   	push   %edi
      p->state = RUNNING;
801040cb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
801040d2:	e8 a4 0b 00 00       	call   80104c7b <swtch>
      switchkvm();
801040d7:	e8 14 30 00 00       	call   801070f0 <switchkvm>
      c->proc = 0;
801040dc:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801040e3:	00 00 00 
801040e6:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040e9:	81 c3 f4 00 00 00    	add    $0xf4,%ebx
801040ef:	81 fb 54 7b 11 80    	cmp    $0x80117b54,%ebx
801040f5:	72 b9                	jb     801040b0 <scheduler+0x40>
    release(&ptable.lock);
801040f7:	83 ec 0c             	sub    $0xc,%esp
801040fa:	68 20 3e 11 80       	push   $0x80113e20
801040ff:	e8 ec 08 00 00       	call   801049f0 <release>
    sti();
80104104:	83 c4 10             	add    $0x10,%esp
80104107:	eb 87                	jmp    80104090 <scheduler+0x20>
80104109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104110 <sched>:
{
80104110:	55                   	push   %ebp
80104111:	89 e5                	mov    %esp,%ebp
80104113:	56                   	push   %esi
80104114:	53                   	push   %ebx
  pushcli();
80104115:	e8 46 07 00 00       	call   80104860 <pushcli>
  c = mycpu();
8010411a:	e8 51 fb ff ff       	call   80103c70 <mycpu>
  p = c->proc;
8010411f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104125:	e8 76 07 00 00       	call   801048a0 <popcli>
  if(!holding(&ptable.lock))
8010412a:	83 ec 0c             	sub    $0xc,%esp
8010412d:	68 20 3e 11 80       	push   $0x80113e20
80104132:	e8 c9 07 00 00       	call   80104900 <holding>
80104137:	83 c4 10             	add    $0x10,%esp
8010413a:	85 c0                	test   %eax,%eax
8010413c:	74 4f                	je     8010418d <sched+0x7d>
  if(mycpu()->ncli != 1)
8010413e:	e8 2d fb ff ff       	call   80103c70 <mycpu>
80104143:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010414a:	75 68                	jne    801041b4 <sched+0xa4>
  if(p->state == RUNNING)
8010414c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104150:	74 55                	je     801041a7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104152:	9c                   	pushf  
80104153:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104154:	f6 c4 02             	test   $0x2,%ah
80104157:	75 41                	jne    8010419a <sched+0x8a>
  intena = mycpu()->intena;
80104159:	e8 12 fb ff ff       	call   80103c70 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010415e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104161:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104167:	e8 04 fb ff ff       	call   80103c70 <mycpu>
8010416c:	83 ec 08             	sub    $0x8,%esp
8010416f:	ff 70 04             	pushl  0x4(%eax)
80104172:	53                   	push   %ebx
80104173:	e8 03 0b 00 00       	call   80104c7b <swtch>
  mycpu()->intena = intena;
80104178:	e8 f3 fa ff ff       	call   80103c70 <mycpu>
}
8010417d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104180:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104186:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104189:	5b                   	pop    %ebx
8010418a:	5e                   	pop    %esi
8010418b:	5d                   	pop    %ebp
8010418c:	c3                   	ret    
    panic("sched ptable.lock");
8010418d:	83 ec 0c             	sub    $0xc,%esp
80104190:	68 7b 7d 10 80       	push   $0x80107d7b
80104195:	e8 f6 c1 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010419a:	83 ec 0c             	sub    $0xc,%esp
8010419d:	68 a7 7d 10 80       	push   $0x80107da7
801041a2:	e8 e9 c1 ff ff       	call   80100390 <panic>
    panic("sched running");
801041a7:	83 ec 0c             	sub    $0xc,%esp
801041aa:	68 99 7d 10 80       	push   $0x80107d99
801041af:	e8 dc c1 ff ff       	call   80100390 <panic>
    panic("sched locks");
801041b4:	83 ec 0c             	sub    $0xc,%esp
801041b7:	68 8d 7d 10 80       	push   $0x80107d8d
801041bc:	e8 cf c1 ff ff       	call   80100390 <panic>
801041c1:	eb 0d                	jmp    801041d0 <exit>
801041c3:	90                   	nop
801041c4:	90                   	nop
801041c5:	90                   	nop
801041c6:	90                   	nop
801041c7:	90                   	nop
801041c8:	90                   	nop
801041c9:	90                   	nop
801041ca:	90                   	nop
801041cb:	90                   	nop
801041cc:	90                   	nop
801041cd:	90                   	nop
801041ce:	90                   	nop
801041cf:	90                   	nop

801041d0 <exit>:
{
801041d0:	55                   	push   %ebp
801041d1:	89 e5                	mov    %esp,%ebp
801041d3:	57                   	push   %edi
801041d4:	56                   	push   %esi
801041d5:	53                   	push   %ebx
801041d6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801041d9:	e8 82 06 00 00       	call   80104860 <pushcli>
  c = mycpu();
801041de:	e8 8d fa ff ff       	call   80103c70 <mycpu>
  p = c->proc;
801041e3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801041e9:	e8 b2 06 00 00       	call   801048a0 <popcli>
  if(curproc == initproc)
801041ee:	39 35 38 b6 10 80    	cmp    %esi,0x8010b638
801041f4:	8d 5e 28             	lea    0x28(%esi),%ebx
801041f7:	8d 7e 68             	lea    0x68(%esi),%edi
801041fa:	0f 84 f1 00 00 00    	je     801042f1 <exit+0x121>
    if(curproc->ofile[fd]){
80104200:	8b 03                	mov    (%ebx),%eax
80104202:	85 c0                	test   %eax,%eax
80104204:	74 12                	je     80104218 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104206:	83 ec 0c             	sub    $0xc,%esp
80104209:	50                   	push   %eax
8010420a:	e8 51 ce ff ff       	call   80101060 <fileclose>
      curproc->ofile[fd] = 0;
8010420f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104215:	83 c4 10             	add    $0x10,%esp
80104218:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
8010421b:	39 fb                	cmp    %edi,%ebx
8010421d:	75 e1                	jne    80104200 <exit+0x30>
  begin_op();
8010421f:	e8 9c eb ff ff       	call   80102dc0 <begin_op>
  iput(curproc->cwd);
80104224:	83 ec 0c             	sub    $0xc,%esp
80104227:	ff 76 68             	pushl  0x68(%esi)
8010422a:	e8 a1 d7 ff ff       	call   801019d0 <iput>
  end_op();
8010422f:	e8 fc eb ff ff       	call   80102e30 <end_op>
  curproc->cwd = 0;
80104234:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
8010423b:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
80104242:	e8 e9 06 00 00       	call   80104930 <acquire>
  wakeup1(curproc->parent);
80104247:	8b 56 14             	mov    0x14(%esi),%edx
8010424a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010424d:	b8 54 3e 11 80       	mov    $0x80113e54,%eax
80104252:	eb 10                	jmp    80104264 <exit+0x94>
80104254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104258:	05 f4 00 00 00       	add    $0xf4,%eax
8010425d:	3d 54 7b 11 80       	cmp    $0x80117b54,%eax
80104262:	73 1e                	jae    80104282 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80104264:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104268:	75 ee                	jne    80104258 <exit+0x88>
8010426a:	3b 50 20             	cmp    0x20(%eax),%edx
8010426d:	75 e9                	jne    80104258 <exit+0x88>
      p->state = RUNNABLE;
8010426f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104276:	05 f4 00 00 00       	add    $0xf4,%eax
8010427b:	3d 54 7b 11 80       	cmp    $0x80117b54,%eax
80104280:	72 e2                	jb     80104264 <exit+0x94>
      p->parent = initproc;
80104282:	8b 0d 38 b6 10 80    	mov    0x8010b638,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104288:	ba 54 3e 11 80       	mov    $0x80113e54,%edx
8010428d:	eb 0f                	jmp    8010429e <exit+0xce>
8010428f:	90                   	nop
80104290:	81 c2 f4 00 00 00    	add    $0xf4,%edx
80104296:	81 fa 54 7b 11 80    	cmp    $0x80117b54,%edx
8010429c:	73 3a                	jae    801042d8 <exit+0x108>
    if(p->parent == curproc){
8010429e:	39 72 14             	cmp    %esi,0x14(%edx)
801042a1:	75 ed                	jne    80104290 <exit+0xc0>
      if(p->state == ZOMBIE)
801042a3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801042a7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801042aa:	75 e4                	jne    80104290 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042ac:	b8 54 3e 11 80       	mov    $0x80113e54,%eax
801042b1:	eb 11                	jmp    801042c4 <exit+0xf4>
801042b3:	90                   	nop
801042b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042b8:	05 f4 00 00 00       	add    $0xf4,%eax
801042bd:	3d 54 7b 11 80       	cmp    $0x80117b54,%eax
801042c2:	73 cc                	jae    80104290 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
801042c4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801042c8:	75 ee                	jne    801042b8 <exit+0xe8>
801042ca:	3b 48 20             	cmp    0x20(%eax),%ecx
801042cd:	75 e9                	jne    801042b8 <exit+0xe8>
      p->state = RUNNABLE;
801042cf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801042d6:	eb e0                	jmp    801042b8 <exit+0xe8>
  curproc->state = ZOMBIE;
801042d8:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801042df:	e8 2c fe ff ff       	call   80104110 <sched>
  panic("zombie exit");
801042e4:	83 ec 0c             	sub    $0xc,%esp
801042e7:	68 c8 7d 10 80       	push   $0x80107dc8
801042ec:	e8 9f c0 ff ff       	call   80100390 <panic>
    panic("init exiting");
801042f1:	83 ec 0c             	sub    $0xc,%esp
801042f4:	68 bb 7d 10 80       	push   $0x80107dbb
801042f9:	e8 92 c0 ff ff       	call   80100390 <panic>
801042fe:	66 90                	xchg   %ax,%ax

80104300 <yield>:
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	53                   	push   %ebx
80104304:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104307:	68 20 3e 11 80       	push   $0x80113e20
8010430c:	e8 1f 06 00 00       	call   80104930 <acquire>
  pushcli();
80104311:	e8 4a 05 00 00       	call   80104860 <pushcli>
  c = mycpu();
80104316:	e8 55 f9 ff ff       	call   80103c70 <mycpu>
  p = c->proc;
8010431b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104321:	e8 7a 05 00 00       	call   801048a0 <popcli>
  myproc()->state = RUNNABLE;
80104326:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010432d:	e8 de fd ff ff       	call   80104110 <sched>
  release(&ptable.lock);
80104332:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
80104339:	e8 b2 06 00 00       	call   801049f0 <release>
}
8010433e:	83 c4 10             	add    $0x10,%esp
80104341:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104344:	c9                   	leave  
80104345:	c3                   	ret    
80104346:	8d 76 00             	lea    0x0(%esi),%esi
80104349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104350 <sleep>:
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	57                   	push   %edi
80104354:	56                   	push   %esi
80104355:	53                   	push   %ebx
80104356:	83 ec 0c             	sub    $0xc,%esp
80104359:	8b 7d 08             	mov    0x8(%ebp),%edi
8010435c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010435f:	e8 fc 04 00 00       	call   80104860 <pushcli>
  c = mycpu();
80104364:	e8 07 f9 ff ff       	call   80103c70 <mycpu>
  p = c->proc;
80104369:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010436f:	e8 2c 05 00 00       	call   801048a0 <popcli>
  if(p == 0)
80104374:	85 db                	test   %ebx,%ebx
80104376:	0f 84 87 00 00 00    	je     80104403 <sleep+0xb3>
  if(lk == 0)
8010437c:	85 f6                	test   %esi,%esi
8010437e:	74 76                	je     801043f6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104380:	81 fe 20 3e 11 80    	cmp    $0x80113e20,%esi
80104386:	74 50                	je     801043d8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104388:	83 ec 0c             	sub    $0xc,%esp
8010438b:	68 20 3e 11 80       	push   $0x80113e20
80104390:	e8 9b 05 00 00       	call   80104930 <acquire>
    release(lk);
80104395:	89 34 24             	mov    %esi,(%esp)
80104398:	e8 53 06 00 00       	call   801049f0 <release>
  p->chan = chan;
8010439d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801043a0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801043a7:	e8 64 fd ff ff       	call   80104110 <sched>
  p->chan = 0;
801043ac:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801043b3:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
801043ba:	e8 31 06 00 00       	call   801049f0 <release>
    acquire(lk);
801043bf:	89 75 08             	mov    %esi,0x8(%ebp)
801043c2:	83 c4 10             	add    $0x10,%esp
}
801043c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043c8:	5b                   	pop    %ebx
801043c9:	5e                   	pop    %esi
801043ca:	5f                   	pop    %edi
801043cb:	5d                   	pop    %ebp
    acquire(lk);
801043cc:	e9 5f 05 00 00       	jmp    80104930 <acquire>
801043d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801043d8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801043db:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801043e2:	e8 29 fd ff ff       	call   80104110 <sched>
  p->chan = 0;
801043e7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801043ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043f1:	5b                   	pop    %ebx
801043f2:	5e                   	pop    %esi
801043f3:	5f                   	pop    %edi
801043f4:	5d                   	pop    %ebp
801043f5:	c3                   	ret    
    panic("sleep without lk");
801043f6:	83 ec 0c             	sub    $0xc,%esp
801043f9:	68 da 7d 10 80       	push   $0x80107dda
801043fe:	e8 8d bf ff ff       	call   80100390 <panic>
    panic("sleep");
80104403:	83 ec 0c             	sub    $0xc,%esp
80104406:	68 d4 7d 10 80       	push   $0x80107dd4
8010440b:	e8 80 bf ff ff       	call   80100390 <panic>

80104410 <wait>:
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	56                   	push   %esi
80104414:	53                   	push   %ebx
  pushcli();
80104415:	e8 46 04 00 00       	call   80104860 <pushcli>
  c = mycpu();
8010441a:	e8 51 f8 ff ff       	call   80103c70 <mycpu>
  p = c->proc;
8010441f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104425:	e8 76 04 00 00       	call   801048a0 <popcli>
  acquire(&ptable.lock);
8010442a:	83 ec 0c             	sub    $0xc,%esp
8010442d:	68 20 3e 11 80       	push   $0x80113e20
80104432:	e8 f9 04 00 00       	call   80104930 <acquire>
80104437:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010443a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010443c:	bb 54 3e 11 80       	mov    $0x80113e54,%ebx
80104441:	eb 13                	jmp    80104456 <wait+0x46>
80104443:	90                   	nop
80104444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104448:	81 c3 f4 00 00 00    	add    $0xf4,%ebx
8010444e:	81 fb 54 7b 11 80    	cmp    $0x80117b54,%ebx
80104454:	73 1e                	jae    80104474 <wait+0x64>
      if(p->parent != curproc)
80104456:	39 73 14             	cmp    %esi,0x14(%ebx)
80104459:	75 ed                	jne    80104448 <wait+0x38>
      if(p->state == ZOMBIE){
8010445b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010445f:	74 37                	je     80104498 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104461:	81 c3 f4 00 00 00    	add    $0xf4,%ebx
      havekids = 1;
80104467:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010446c:	81 fb 54 7b 11 80    	cmp    $0x80117b54,%ebx
80104472:	72 e2                	jb     80104456 <wait+0x46>
    if(!havekids || curproc->killed){
80104474:	85 c0                	test   %eax,%eax
80104476:	74 76                	je     801044ee <wait+0xde>
80104478:	8b 46 24             	mov    0x24(%esi),%eax
8010447b:	85 c0                	test   %eax,%eax
8010447d:	75 6f                	jne    801044ee <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010447f:	83 ec 08             	sub    $0x8,%esp
80104482:	68 20 3e 11 80       	push   $0x80113e20
80104487:	56                   	push   %esi
80104488:	e8 c3 fe ff ff       	call   80104350 <sleep>
    havekids = 0;
8010448d:	83 c4 10             	add    $0x10,%esp
80104490:	eb a8                	jmp    8010443a <wait+0x2a>
80104492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104498:	83 ec 0c             	sub    $0xc,%esp
8010449b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
8010449e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801044a1:	e8 8a e0 ff ff       	call   80102530 <kfree>
        freevm(p->pgdir);
801044a6:	5a                   	pop    %edx
801044a7:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801044aa:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801044b1:	e8 0a 30 00 00       	call   801074c0 <freevm>
        release(&ptable.lock);
801044b6:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
        p->pid = 0;
801044bd:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801044c4:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801044cb:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801044cf:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801044d6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801044dd:	e8 0e 05 00 00       	call   801049f0 <release>
        return pid;
801044e2:	83 c4 10             	add    $0x10,%esp
}
801044e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044e8:	89 f0                	mov    %esi,%eax
801044ea:	5b                   	pop    %ebx
801044eb:	5e                   	pop    %esi
801044ec:	5d                   	pop    %ebp
801044ed:	c3                   	ret    
      release(&ptable.lock);
801044ee:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801044f1:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801044f6:	68 20 3e 11 80       	push   $0x80113e20
801044fb:	e8 f0 04 00 00       	call   801049f0 <release>
      return -1;
80104500:	83 c4 10             	add    $0x10,%esp
80104503:	eb e0                	jmp    801044e5 <wait+0xd5>
80104505:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104510 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	53                   	push   %ebx
80104514:	83 ec 10             	sub    $0x10,%esp
80104517:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010451a:	68 20 3e 11 80       	push   $0x80113e20
8010451f:	e8 0c 04 00 00       	call   80104930 <acquire>
80104524:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104527:	b8 54 3e 11 80       	mov    $0x80113e54,%eax
8010452c:	eb 0e                	jmp    8010453c <wakeup+0x2c>
8010452e:	66 90                	xchg   %ax,%ax
80104530:	05 f4 00 00 00       	add    $0xf4,%eax
80104535:	3d 54 7b 11 80       	cmp    $0x80117b54,%eax
8010453a:	73 1e                	jae    8010455a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010453c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104540:	75 ee                	jne    80104530 <wakeup+0x20>
80104542:	3b 58 20             	cmp    0x20(%eax),%ebx
80104545:	75 e9                	jne    80104530 <wakeup+0x20>
      p->state = RUNNABLE;
80104547:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010454e:	05 f4 00 00 00       	add    $0xf4,%eax
80104553:	3d 54 7b 11 80       	cmp    $0x80117b54,%eax
80104558:	72 e2                	jb     8010453c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010455a:	c7 45 08 20 3e 11 80 	movl   $0x80113e20,0x8(%ebp)
}
80104561:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104564:	c9                   	leave  
  release(&ptable.lock);
80104565:	e9 86 04 00 00       	jmp    801049f0 <release>
8010456a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104570 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	53                   	push   %ebx
80104574:	83 ec 10             	sub    $0x10,%esp
80104577:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010457a:	68 20 3e 11 80       	push   $0x80113e20
8010457f:	e8 ac 03 00 00       	call   80104930 <acquire>
80104584:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104587:	b8 54 3e 11 80       	mov    $0x80113e54,%eax
8010458c:	eb 0e                	jmp    8010459c <kill+0x2c>
8010458e:	66 90                	xchg   %ax,%ax
80104590:	05 f4 00 00 00       	add    $0xf4,%eax
80104595:	3d 54 7b 11 80       	cmp    $0x80117b54,%eax
8010459a:	73 34                	jae    801045d0 <kill+0x60>
    if(p->pid == pid){
8010459c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010459f:	75 ef                	jne    80104590 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801045a1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801045a5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801045ac:	75 07                	jne    801045b5 <kill+0x45>
        p->state = RUNNABLE;
801045ae:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801045b5:	83 ec 0c             	sub    $0xc,%esp
801045b8:	68 20 3e 11 80       	push   $0x80113e20
801045bd:	e8 2e 04 00 00       	call   801049f0 <release>
      return 0;
801045c2:	83 c4 10             	add    $0x10,%esp
801045c5:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801045c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045ca:	c9                   	leave  
801045cb:	c3                   	ret    
801045cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801045d0:	83 ec 0c             	sub    $0xc,%esp
801045d3:	68 20 3e 11 80       	push   $0x80113e20
801045d8:	e8 13 04 00 00       	call   801049f0 <release>
  return -1;
801045dd:	83 c4 10             	add    $0x10,%esp
801045e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801045e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045e8:	c9                   	leave  
801045e9:	c3                   	ret    
801045ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045f0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	57                   	push   %edi
801045f4:	56                   	push   %esi
801045f5:	53                   	push   %ebx
801045f6:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045f9:	bb 54 3e 11 80       	mov    $0x80113e54,%ebx
{
801045fe:	83 ec 3c             	sub    $0x3c,%esp
80104601:	eb 27                	jmp    8010462a <procdump+0x3a>
80104603:	90                   	nop
80104604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104608:	83 ec 0c             	sub    $0xc,%esp
8010460b:	68 0f 82 10 80       	push   $0x8010820f
80104610:	e8 4b c0 ff ff       	call   80100660 <cprintf>
80104615:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104618:	81 c3 f4 00 00 00    	add    $0xf4,%ebx
8010461e:	81 fb 54 7b 11 80    	cmp    $0x80117b54,%ebx
80104624:	0f 83 86 00 00 00    	jae    801046b0 <procdump+0xc0>
    if(p->state == UNUSED)
8010462a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010462d:	85 c0                	test   %eax,%eax
8010462f:	74 e7                	je     80104618 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104631:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104634:	ba eb 7d 10 80       	mov    $0x80107deb,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104639:	77 11                	ja     8010464c <procdump+0x5c>
8010463b:	8b 14 85 b4 7e 10 80 	mov    -0x7fef814c(,%eax,4),%edx
      state = "???";
80104642:	b8 eb 7d 10 80       	mov    $0x80107deb,%eax
80104647:	85 d2                	test   %edx,%edx
80104649:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010464c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010464f:	50                   	push   %eax
80104650:	52                   	push   %edx
80104651:	ff 73 10             	pushl  0x10(%ebx)
80104654:	68 ef 7d 10 80       	push   $0x80107def
80104659:	e8 02 c0 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010465e:	83 c4 10             	add    $0x10,%esp
80104661:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104665:	75 a1                	jne    80104608 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104667:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010466a:	83 ec 08             	sub    $0x8,%esp
8010466d:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104670:	50                   	push   %eax
80104671:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104674:	8b 40 0c             	mov    0xc(%eax),%eax
80104677:	83 c0 08             	add    $0x8,%eax
8010467a:	50                   	push   %eax
8010467b:	e8 90 01 00 00       	call   80104810 <getcallerpcs>
80104680:	83 c4 10             	add    $0x10,%esp
80104683:	90                   	nop
80104684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104688:	8b 17                	mov    (%edi),%edx
8010468a:	85 d2                	test   %edx,%edx
8010468c:	0f 84 76 ff ff ff    	je     80104608 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104692:	83 ec 08             	sub    $0x8,%esp
80104695:	83 c7 04             	add    $0x4,%edi
80104698:	52                   	push   %edx
80104699:	68 21 78 10 80       	push   $0x80107821
8010469e:	e8 bd bf ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801046a3:	83 c4 10             	add    $0x10,%esp
801046a6:	39 fe                	cmp    %edi,%esi
801046a8:	75 de                	jne    80104688 <procdump+0x98>
801046aa:	e9 59 ff ff ff       	jmp    80104608 <procdump+0x18>
801046af:	90                   	nop
  }
}
801046b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046b3:	5b                   	pop    %ebx
801046b4:	5e                   	pop    %esi
801046b5:	5f                   	pop    %edi
801046b6:	5d                   	pop    %ebp
801046b7:	c3                   	ret    
801046b8:	66 90                	xchg   %ax,%ax
801046ba:	66 90                	xchg   %ax,%ax
801046bc:	66 90                	xchg   %ax,%ax
801046be:	66 90                	xchg   %ax,%ax

801046c0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	53                   	push   %ebx
801046c4:	83 ec 0c             	sub    $0xc,%esp
801046c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801046ca:	68 cc 7e 10 80       	push   $0x80107ecc
801046cf:	8d 43 04             	lea    0x4(%ebx),%eax
801046d2:	50                   	push   %eax
801046d3:	e8 18 01 00 00       	call   801047f0 <initlock>
  lk->name = name;
801046d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801046db:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801046e1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801046e4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801046eb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801046ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046f1:	c9                   	leave  
801046f2:	c3                   	ret    
801046f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801046f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104700 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	56                   	push   %esi
80104704:	53                   	push   %ebx
80104705:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104708:	83 ec 0c             	sub    $0xc,%esp
8010470b:	8d 73 04             	lea    0x4(%ebx),%esi
8010470e:	56                   	push   %esi
8010470f:	e8 1c 02 00 00       	call   80104930 <acquire>
  while (lk->locked) {
80104714:	8b 13                	mov    (%ebx),%edx
80104716:	83 c4 10             	add    $0x10,%esp
80104719:	85 d2                	test   %edx,%edx
8010471b:	74 16                	je     80104733 <acquiresleep+0x33>
8010471d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104720:	83 ec 08             	sub    $0x8,%esp
80104723:	56                   	push   %esi
80104724:	53                   	push   %ebx
80104725:	e8 26 fc ff ff       	call   80104350 <sleep>
  while (lk->locked) {
8010472a:	8b 03                	mov    (%ebx),%eax
8010472c:	83 c4 10             	add    $0x10,%esp
8010472f:	85 c0                	test   %eax,%eax
80104731:	75 ed                	jne    80104720 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104733:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104739:	e8 d2 f5 ff ff       	call   80103d10 <myproc>
8010473e:	8b 40 10             	mov    0x10(%eax),%eax
80104741:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104744:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104747:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010474a:	5b                   	pop    %ebx
8010474b:	5e                   	pop    %esi
8010474c:	5d                   	pop    %ebp
  release(&lk->lk);
8010474d:	e9 9e 02 00 00       	jmp    801049f0 <release>
80104752:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104760 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	56                   	push   %esi
80104764:	53                   	push   %ebx
80104765:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104768:	83 ec 0c             	sub    $0xc,%esp
8010476b:	8d 73 04             	lea    0x4(%ebx),%esi
8010476e:	56                   	push   %esi
8010476f:	e8 bc 01 00 00       	call   80104930 <acquire>
  lk->locked = 0;
80104774:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010477a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104781:	89 1c 24             	mov    %ebx,(%esp)
80104784:	e8 87 fd ff ff       	call   80104510 <wakeup>
  release(&lk->lk);
80104789:	89 75 08             	mov    %esi,0x8(%ebp)
8010478c:	83 c4 10             	add    $0x10,%esp
}
8010478f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104792:	5b                   	pop    %ebx
80104793:	5e                   	pop    %esi
80104794:	5d                   	pop    %ebp
  release(&lk->lk);
80104795:	e9 56 02 00 00       	jmp    801049f0 <release>
8010479a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047a0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	57                   	push   %edi
801047a4:	56                   	push   %esi
801047a5:	53                   	push   %ebx
801047a6:	31 ff                	xor    %edi,%edi
801047a8:	83 ec 18             	sub    $0x18,%esp
801047ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801047ae:	8d 73 04             	lea    0x4(%ebx),%esi
801047b1:	56                   	push   %esi
801047b2:	e8 79 01 00 00       	call   80104930 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801047b7:	8b 03                	mov    (%ebx),%eax
801047b9:	83 c4 10             	add    $0x10,%esp
801047bc:	85 c0                	test   %eax,%eax
801047be:	74 13                	je     801047d3 <holdingsleep+0x33>
801047c0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801047c3:	e8 48 f5 ff ff       	call   80103d10 <myproc>
801047c8:	39 58 10             	cmp    %ebx,0x10(%eax)
801047cb:	0f 94 c0             	sete   %al
801047ce:	0f b6 c0             	movzbl %al,%eax
801047d1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801047d3:	83 ec 0c             	sub    $0xc,%esp
801047d6:	56                   	push   %esi
801047d7:	e8 14 02 00 00       	call   801049f0 <release>
  return r;
}
801047dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047df:	89 f8                	mov    %edi,%eax
801047e1:	5b                   	pop    %ebx
801047e2:	5e                   	pop    %esi
801047e3:	5f                   	pop    %edi
801047e4:	5d                   	pop    %ebp
801047e5:	c3                   	ret    
801047e6:	66 90                	xchg   %ax,%ax
801047e8:	66 90                	xchg   %ax,%ax
801047ea:	66 90                	xchg   %ax,%ax
801047ec:	66 90                	xchg   %ax,%ax
801047ee:	66 90                	xchg   %ax,%ax

801047f0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801047f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801047f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801047ff:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104802:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104809:	5d                   	pop    %ebp
8010480a:	c3                   	ret    
8010480b:	90                   	nop
8010480c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104810 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104810:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104811:	31 d2                	xor    %edx,%edx
{
80104813:	89 e5                	mov    %esp,%ebp
80104815:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104816:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104819:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010481c:	83 e8 08             	sub    $0x8,%eax
8010481f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104820:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104826:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010482c:	77 1a                	ja     80104848 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010482e:	8b 58 04             	mov    0x4(%eax),%ebx
80104831:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104834:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104837:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104839:	83 fa 0a             	cmp    $0xa,%edx
8010483c:	75 e2                	jne    80104820 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010483e:	5b                   	pop    %ebx
8010483f:	5d                   	pop    %ebp
80104840:	c3                   	ret    
80104841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104848:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010484b:	83 c1 28             	add    $0x28,%ecx
8010484e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104850:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104856:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104859:	39 c1                	cmp    %eax,%ecx
8010485b:	75 f3                	jne    80104850 <getcallerpcs+0x40>
}
8010485d:	5b                   	pop    %ebx
8010485e:	5d                   	pop    %ebp
8010485f:	c3                   	ret    

80104860 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	53                   	push   %ebx
80104864:	83 ec 04             	sub    $0x4,%esp
80104867:	9c                   	pushf  
80104868:	5b                   	pop    %ebx
  asm volatile("cli");
80104869:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010486a:	e8 01 f4 ff ff       	call   80103c70 <mycpu>
8010486f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104875:	85 c0                	test   %eax,%eax
80104877:	75 11                	jne    8010488a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104879:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010487f:	e8 ec f3 ff ff       	call   80103c70 <mycpu>
80104884:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010488a:	e8 e1 f3 ff ff       	call   80103c70 <mycpu>
8010488f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104896:	83 c4 04             	add    $0x4,%esp
80104899:	5b                   	pop    %ebx
8010489a:	5d                   	pop    %ebp
8010489b:	c3                   	ret    
8010489c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048a0 <popcli>:

void
popcli(void)
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801048a6:	9c                   	pushf  
801048a7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801048a8:	f6 c4 02             	test   $0x2,%ah
801048ab:	75 35                	jne    801048e2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801048ad:	e8 be f3 ff ff       	call   80103c70 <mycpu>
801048b2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801048b9:	78 34                	js     801048ef <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801048bb:	e8 b0 f3 ff ff       	call   80103c70 <mycpu>
801048c0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801048c6:	85 d2                	test   %edx,%edx
801048c8:	74 06                	je     801048d0 <popcli+0x30>
    sti();
}
801048ca:	c9                   	leave  
801048cb:	c3                   	ret    
801048cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801048d0:	e8 9b f3 ff ff       	call   80103c70 <mycpu>
801048d5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801048db:	85 c0                	test   %eax,%eax
801048dd:	74 eb                	je     801048ca <popcli+0x2a>
  asm volatile("sti");
801048df:	fb                   	sti    
}
801048e0:	c9                   	leave  
801048e1:	c3                   	ret    
    panic("popcli - interruptible");
801048e2:	83 ec 0c             	sub    $0xc,%esp
801048e5:	68 d7 7e 10 80       	push   $0x80107ed7
801048ea:	e8 a1 ba ff ff       	call   80100390 <panic>
    panic("popcli");
801048ef:	83 ec 0c             	sub    $0xc,%esp
801048f2:	68 ee 7e 10 80       	push   $0x80107eee
801048f7:	e8 94 ba ff ff       	call   80100390 <panic>
801048fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104900 <holding>:
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	56                   	push   %esi
80104904:	53                   	push   %ebx
80104905:	8b 75 08             	mov    0x8(%ebp),%esi
80104908:	31 db                	xor    %ebx,%ebx
  pushcli();
8010490a:	e8 51 ff ff ff       	call   80104860 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010490f:	8b 06                	mov    (%esi),%eax
80104911:	85 c0                	test   %eax,%eax
80104913:	74 10                	je     80104925 <holding+0x25>
80104915:	8b 5e 08             	mov    0x8(%esi),%ebx
80104918:	e8 53 f3 ff ff       	call   80103c70 <mycpu>
8010491d:	39 c3                	cmp    %eax,%ebx
8010491f:	0f 94 c3             	sete   %bl
80104922:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104925:	e8 76 ff ff ff       	call   801048a0 <popcli>
}
8010492a:	89 d8                	mov    %ebx,%eax
8010492c:	5b                   	pop    %ebx
8010492d:	5e                   	pop    %esi
8010492e:	5d                   	pop    %ebp
8010492f:	c3                   	ret    

80104930 <acquire>:
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	56                   	push   %esi
80104934:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104935:	e8 26 ff ff ff       	call   80104860 <pushcli>
  if(holding(lk))
8010493a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010493d:	83 ec 0c             	sub    $0xc,%esp
80104940:	53                   	push   %ebx
80104941:	e8 ba ff ff ff       	call   80104900 <holding>
80104946:	83 c4 10             	add    $0x10,%esp
80104949:	85 c0                	test   %eax,%eax
8010494b:	0f 85 83 00 00 00    	jne    801049d4 <acquire+0xa4>
80104951:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104953:	ba 01 00 00 00       	mov    $0x1,%edx
80104958:	eb 09                	jmp    80104963 <acquire+0x33>
8010495a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104960:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104963:	89 d0                	mov    %edx,%eax
80104965:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104968:	85 c0                	test   %eax,%eax
8010496a:	75 f4                	jne    80104960 <acquire+0x30>
  __sync_synchronize();
8010496c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104971:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104974:	e8 f7 f2 ff ff       	call   80103c70 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104979:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010497c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010497f:	89 e8                	mov    %ebp,%eax
80104981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104988:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010498e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104994:	77 1a                	ja     801049b0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104996:	8b 48 04             	mov    0x4(%eax),%ecx
80104999:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
8010499c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
8010499f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801049a1:	83 fe 0a             	cmp    $0xa,%esi
801049a4:	75 e2                	jne    80104988 <acquire+0x58>
}
801049a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049a9:	5b                   	pop    %ebx
801049aa:	5e                   	pop    %esi
801049ab:	5d                   	pop    %ebp
801049ac:	c3                   	ret    
801049ad:	8d 76 00             	lea    0x0(%esi),%esi
801049b0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
801049b3:	83 c2 28             	add    $0x28,%edx
801049b6:	8d 76 00             	lea    0x0(%esi),%esi
801049b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
801049c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801049c6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801049c9:	39 d0                	cmp    %edx,%eax
801049cb:	75 f3                	jne    801049c0 <acquire+0x90>
}
801049cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049d0:	5b                   	pop    %ebx
801049d1:	5e                   	pop    %esi
801049d2:	5d                   	pop    %ebp
801049d3:	c3                   	ret    
    panic("acquire");
801049d4:	83 ec 0c             	sub    $0xc,%esp
801049d7:	68 f5 7e 10 80       	push   $0x80107ef5
801049dc:	e8 af b9 ff ff       	call   80100390 <panic>
801049e1:	eb 0d                	jmp    801049f0 <release>
801049e3:	90                   	nop
801049e4:	90                   	nop
801049e5:	90                   	nop
801049e6:	90                   	nop
801049e7:	90                   	nop
801049e8:	90                   	nop
801049e9:	90                   	nop
801049ea:	90                   	nop
801049eb:	90                   	nop
801049ec:	90                   	nop
801049ed:	90                   	nop
801049ee:	90                   	nop
801049ef:	90                   	nop

801049f0 <release>:
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	53                   	push   %ebx
801049f4:	83 ec 10             	sub    $0x10,%esp
801049f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801049fa:	53                   	push   %ebx
801049fb:	e8 00 ff ff ff       	call   80104900 <holding>
80104a00:	83 c4 10             	add    $0x10,%esp
80104a03:	85 c0                	test   %eax,%eax
80104a05:	74 22                	je     80104a29 <release+0x39>
  lk->pcs[0] = 0;
80104a07:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104a0e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104a15:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104a1a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104a20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a23:	c9                   	leave  
  popcli();
80104a24:	e9 77 fe ff ff       	jmp    801048a0 <popcli>
    panic("release");
80104a29:	83 ec 0c             	sub    $0xc,%esp
80104a2c:	68 fd 7e 10 80       	push   $0x80107efd
80104a31:	e8 5a b9 ff ff       	call   80100390 <panic>
80104a36:	66 90                	xchg   %ax,%ax
80104a38:	66 90                	xchg   %ax,%ax
80104a3a:	66 90                	xchg   %ax,%ax
80104a3c:	66 90                	xchg   %ax,%ax
80104a3e:	66 90                	xchg   %ax,%ax

80104a40 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	57                   	push   %edi
80104a44:	53                   	push   %ebx
80104a45:	8b 55 08             	mov    0x8(%ebp),%edx
80104a48:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104a4b:	f6 c2 03             	test   $0x3,%dl
80104a4e:	75 05                	jne    80104a55 <memset+0x15>
80104a50:	f6 c1 03             	test   $0x3,%cl
80104a53:	74 13                	je     80104a68 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104a55:	89 d7                	mov    %edx,%edi
80104a57:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a5a:	fc                   	cld    
80104a5b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104a5d:	5b                   	pop    %ebx
80104a5e:	89 d0                	mov    %edx,%eax
80104a60:	5f                   	pop    %edi
80104a61:	5d                   	pop    %ebp
80104a62:	c3                   	ret    
80104a63:	90                   	nop
80104a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104a68:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104a6c:	c1 e9 02             	shr    $0x2,%ecx
80104a6f:	89 f8                	mov    %edi,%eax
80104a71:	89 fb                	mov    %edi,%ebx
80104a73:	c1 e0 18             	shl    $0x18,%eax
80104a76:	c1 e3 10             	shl    $0x10,%ebx
80104a79:	09 d8                	or     %ebx,%eax
80104a7b:	09 f8                	or     %edi,%eax
80104a7d:	c1 e7 08             	shl    $0x8,%edi
80104a80:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104a82:	89 d7                	mov    %edx,%edi
80104a84:	fc                   	cld    
80104a85:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104a87:	5b                   	pop    %ebx
80104a88:	89 d0                	mov    %edx,%eax
80104a8a:	5f                   	pop    %edi
80104a8b:	5d                   	pop    %ebp
80104a8c:	c3                   	ret    
80104a8d:	8d 76 00             	lea    0x0(%esi),%esi

80104a90 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	57                   	push   %edi
80104a94:	56                   	push   %esi
80104a95:	53                   	push   %ebx
80104a96:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104a99:	8b 75 08             	mov    0x8(%ebp),%esi
80104a9c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104a9f:	85 db                	test   %ebx,%ebx
80104aa1:	74 29                	je     80104acc <memcmp+0x3c>
    if(*s1 != *s2)
80104aa3:	0f b6 16             	movzbl (%esi),%edx
80104aa6:	0f b6 0f             	movzbl (%edi),%ecx
80104aa9:	38 d1                	cmp    %dl,%cl
80104aab:	75 2b                	jne    80104ad8 <memcmp+0x48>
80104aad:	b8 01 00 00 00       	mov    $0x1,%eax
80104ab2:	eb 14                	jmp    80104ac8 <memcmp+0x38>
80104ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ab8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104abc:	83 c0 01             	add    $0x1,%eax
80104abf:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104ac4:	38 ca                	cmp    %cl,%dl
80104ac6:	75 10                	jne    80104ad8 <memcmp+0x48>
  while(n-- > 0){
80104ac8:	39 d8                	cmp    %ebx,%eax
80104aca:	75 ec                	jne    80104ab8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104acc:	5b                   	pop    %ebx
  return 0;
80104acd:	31 c0                	xor    %eax,%eax
}
80104acf:	5e                   	pop    %esi
80104ad0:	5f                   	pop    %edi
80104ad1:	5d                   	pop    %ebp
80104ad2:	c3                   	ret    
80104ad3:	90                   	nop
80104ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104ad8:	0f b6 c2             	movzbl %dl,%eax
}
80104adb:	5b                   	pop    %ebx
      return *s1 - *s2;
80104adc:	29 c8                	sub    %ecx,%eax
}
80104ade:	5e                   	pop    %esi
80104adf:	5f                   	pop    %edi
80104ae0:	5d                   	pop    %ebp
80104ae1:	c3                   	ret    
80104ae2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104af0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	56                   	push   %esi
80104af4:	53                   	push   %ebx
80104af5:	8b 45 08             	mov    0x8(%ebp),%eax
80104af8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104afb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104afe:	39 c3                	cmp    %eax,%ebx
80104b00:	73 26                	jae    80104b28 <memmove+0x38>
80104b02:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104b05:	39 c8                	cmp    %ecx,%eax
80104b07:	73 1f                	jae    80104b28 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104b09:	85 f6                	test   %esi,%esi
80104b0b:	8d 56 ff             	lea    -0x1(%esi),%edx
80104b0e:	74 0f                	je     80104b1f <memmove+0x2f>
      *--d = *--s;
80104b10:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104b14:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104b17:	83 ea 01             	sub    $0x1,%edx
80104b1a:	83 fa ff             	cmp    $0xffffffff,%edx
80104b1d:	75 f1                	jne    80104b10 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104b1f:	5b                   	pop    %ebx
80104b20:	5e                   	pop    %esi
80104b21:	5d                   	pop    %ebp
80104b22:	c3                   	ret    
80104b23:	90                   	nop
80104b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104b28:	31 d2                	xor    %edx,%edx
80104b2a:	85 f6                	test   %esi,%esi
80104b2c:	74 f1                	je     80104b1f <memmove+0x2f>
80104b2e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104b30:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104b34:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104b37:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104b3a:	39 d6                	cmp    %edx,%esi
80104b3c:	75 f2                	jne    80104b30 <memmove+0x40>
}
80104b3e:	5b                   	pop    %ebx
80104b3f:	5e                   	pop    %esi
80104b40:	5d                   	pop    %ebp
80104b41:	c3                   	ret    
80104b42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b50 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104b53:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104b54:	eb 9a                	jmp    80104af0 <memmove>
80104b56:	8d 76 00             	lea    0x0(%esi),%esi
80104b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b60 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	57                   	push   %edi
80104b64:	56                   	push   %esi
80104b65:	8b 7d 10             	mov    0x10(%ebp),%edi
80104b68:	53                   	push   %ebx
80104b69:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104b6c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104b6f:	85 ff                	test   %edi,%edi
80104b71:	74 2f                	je     80104ba2 <strncmp+0x42>
80104b73:	0f b6 01             	movzbl (%ecx),%eax
80104b76:	0f b6 1e             	movzbl (%esi),%ebx
80104b79:	84 c0                	test   %al,%al
80104b7b:	74 37                	je     80104bb4 <strncmp+0x54>
80104b7d:	38 c3                	cmp    %al,%bl
80104b7f:	75 33                	jne    80104bb4 <strncmp+0x54>
80104b81:	01 f7                	add    %esi,%edi
80104b83:	eb 13                	jmp    80104b98 <strncmp+0x38>
80104b85:	8d 76 00             	lea    0x0(%esi),%esi
80104b88:	0f b6 01             	movzbl (%ecx),%eax
80104b8b:	84 c0                	test   %al,%al
80104b8d:	74 21                	je     80104bb0 <strncmp+0x50>
80104b8f:	0f b6 1a             	movzbl (%edx),%ebx
80104b92:	89 d6                	mov    %edx,%esi
80104b94:	38 d8                	cmp    %bl,%al
80104b96:	75 1c                	jne    80104bb4 <strncmp+0x54>
    n--, p++, q++;
80104b98:	8d 56 01             	lea    0x1(%esi),%edx
80104b9b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104b9e:	39 fa                	cmp    %edi,%edx
80104ba0:	75 e6                	jne    80104b88 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104ba2:	5b                   	pop    %ebx
    return 0;
80104ba3:	31 c0                	xor    %eax,%eax
}
80104ba5:	5e                   	pop    %esi
80104ba6:	5f                   	pop    %edi
80104ba7:	5d                   	pop    %ebp
80104ba8:	c3                   	ret    
80104ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bb0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104bb4:	29 d8                	sub    %ebx,%eax
}
80104bb6:	5b                   	pop    %ebx
80104bb7:	5e                   	pop    %esi
80104bb8:	5f                   	pop    %edi
80104bb9:	5d                   	pop    %ebp
80104bba:	c3                   	ret    
80104bbb:	90                   	nop
80104bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104bc0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	56                   	push   %esi
80104bc4:	53                   	push   %ebx
80104bc5:	8b 45 08             	mov    0x8(%ebp),%eax
80104bc8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104bcb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104bce:	89 c2                	mov    %eax,%edx
80104bd0:	eb 19                	jmp    80104beb <strncpy+0x2b>
80104bd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104bd8:	83 c3 01             	add    $0x1,%ebx
80104bdb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104bdf:	83 c2 01             	add    $0x1,%edx
80104be2:	84 c9                	test   %cl,%cl
80104be4:	88 4a ff             	mov    %cl,-0x1(%edx)
80104be7:	74 09                	je     80104bf2 <strncpy+0x32>
80104be9:	89 f1                	mov    %esi,%ecx
80104beb:	85 c9                	test   %ecx,%ecx
80104bed:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104bf0:	7f e6                	jg     80104bd8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104bf2:	31 c9                	xor    %ecx,%ecx
80104bf4:	85 f6                	test   %esi,%esi
80104bf6:	7e 17                	jle    80104c0f <strncpy+0x4f>
80104bf8:	90                   	nop
80104bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104c00:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104c04:	89 f3                	mov    %esi,%ebx
80104c06:	83 c1 01             	add    $0x1,%ecx
80104c09:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104c0b:	85 db                	test   %ebx,%ebx
80104c0d:	7f f1                	jg     80104c00 <strncpy+0x40>
  return os;
}
80104c0f:	5b                   	pop    %ebx
80104c10:	5e                   	pop    %esi
80104c11:	5d                   	pop    %ebp
80104c12:	c3                   	ret    
80104c13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c20 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	56                   	push   %esi
80104c24:	53                   	push   %ebx
80104c25:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104c28:	8b 45 08             	mov    0x8(%ebp),%eax
80104c2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104c2e:	85 c9                	test   %ecx,%ecx
80104c30:	7e 26                	jle    80104c58 <safestrcpy+0x38>
80104c32:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104c36:	89 c1                	mov    %eax,%ecx
80104c38:	eb 17                	jmp    80104c51 <safestrcpy+0x31>
80104c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104c40:	83 c2 01             	add    $0x1,%edx
80104c43:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104c47:	83 c1 01             	add    $0x1,%ecx
80104c4a:	84 db                	test   %bl,%bl
80104c4c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104c4f:	74 04                	je     80104c55 <safestrcpy+0x35>
80104c51:	39 f2                	cmp    %esi,%edx
80104c53:	75 eb                	jne    80104c40 <safestrcpy+0x20>
    ;
  *s = 0;
80104c55:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104c58:	5b                   	pop    %ebx
80104c59:	5e                   	pop    %esi
80104c5a:	5d                   	pop    %ebp
80104c5b:	c3                   	ret    
80104c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c60 <strlen>:

int
strlen(const char *s)
{
80104c60:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104c61:	31 c0                	xor    %eax,%eax
{
80104c63:	89 e5                	mov    %esp,%ebp
80104c65:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104c68:	80 3a 00             	cmpb   $0x0,(%edx)
80104c6b:	74 0c                	je     80104c79 <strlen+0x19>
80104c6d:	8d 76 00             	lea    0x0(%esi),%esi
80104c70:	83 c0 01             	add    $0x1,%eax
80104c73:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104c77:	75 f7                	jne    80104c70 <strlen+0x10>
    ;
  return n;
}
80104c79:	5d                   	pop    %ebp
80104c7a:	c3                   	ret    

80104c7b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104c7b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104c7f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104c83:	55                   	push   %ebp
  pushl %ebx
80104c84:	53                   	push   %ebx
  pushl %esi
80104c85:	56                   	push   %esi
  pushl %edi
80104c86:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104c87:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104c89:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104c8b:	5f                   	pop    %edi
  popl %esi
80104c8c:	5e                   	pop    %esi
  popl %ebx
80104c8d:	5b                   	pop    %ebx
  popl %ebp
80104c8e:	5d                   	pop    %ebp
  ret
80104c8f:	c3                   	ret    

80104c90 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	53                   	push   %ebx
80104c94:	83 ec 04             	sub    $0x4,%esp
80104c97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104c9a:	e8 71 f0 ff ff       	call   80103d10 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c9f:	8b 00                	mov    (%eax),%eax
80104ca1:	39 d8                	cmp    %ebx,%eax
80104ca3:	76 1b                	jbe    80104cc0 <fetchint+0x30>
80104ca5:	8d 53 04             	lea    0x4(%ebx),%edx
80104ca8:	39 d0                	cmp    %edx,%eax
80104caa:	72 14                	jb     80104cc0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104cac:	8b 45 0c             	mov    0xc(%ebp),%eax
80104caf:	8b 13                	mov    (%ebx),%edx
80104cb1:	89 10                	mov    %edx,(%eax)
  return 0;
80104cb3:	31 c0                	xor    %eax,%eax
}
80104cb5:	83 c4 04             	add    $0x4,%esp
80104cb8:	5b                   	pop    %ebx
80104cb9:	5d                   	pop    %ebp
80104cba:	c3                   	ret    
80104cbb:	90                   	nop
80104cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104cc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cc5:	eb ee                	jmp    80104cb5 <fetchint+0x25>
80104cc7:	89 f6                	mov    %esi,%esi
80104cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cd0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	53                   	push   %ebx
80104cd4:	83 ec 04             	sub    $0x4,%esp
80104cd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104cda:	e8 31 f0 ff ff       	call   80103d10 <myproc>

  if(addr >= curproc->sz)
80104cdf:	39 18                	cmp    %ebx,(%eax)
80104ce1:	76 29                	jbe    80104d0c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104ce3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104ce6:	89 da                	mov    %ebx,%edx
80104ce8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104cea:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104cec:	39 c3                	cmp    %eax,%ebx
80104cee:	73 1c                	jae    80104d0c <fetchstr+0x3c>
    if(*s == 0)
80104cf0:	80 3b 00             	cmpb   $0x0,(%ebx)
80104cf3:	75 10                	jne    80104d05 <fetchstr+0x35>
80104cf5:	eb 39                	jmp    80104d30 <fetchstr+0x60>
80104cf7:	89 f6                	mov    %esi,%esi
80104cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104d00:	80 3a 00             	cmpb   $0x0,(%edx)
80104d03:	74 1b                	je     80104d20 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104d05:	83 c2 01             	add    $0x1,%edx
80104d08:	39 d0                	cmp    %edx,%eax
80104d0a:	77 f4                	ja     80104d00 <fetchstr+0x30>
    return -1;
80104d0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104d11:	83 c4 04             	add    $0x4,%esp
80104d14:	5b                   	pop    %ebx
80104d15:	5d                   	pop    %ebp
80104d16:	c3                   	ret    
80104d17:	89 f6                	mov    %esi,%esi
80104d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104d20:	83 c4 04             	add    $0x4,%esp
80104d23:	89 d0                	mov    %edx,%eax
80104d25:	29 d8                	sub    %ebx,%eax
80104d27:	5b                   	pop    %ebx
80104d28:	5d                   	pop    %ebp
80104d29:	c3                   	ret    
80104d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104d30:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104d32:	eb dd                	jmp    80104d11 <fetchstr+0x41>
80104d34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104d40 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	56                   	push   %esi
80104d44:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d45:	e8 c6 ef ff ff       	call   80103d10 <myproc>
80104d4a:	8b 40 18             	mov    0x18(%eax),%eax
80104d4d:	8b 55 08             	mov    0x8(%ebp),%edx
80104d50:	8b 40 44             	mov    0x44(%eax),%eax
80104d53:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104d56:	e8 b5 ef ff ff       	call   80103d10 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d5b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d5d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d60:	39 c6                	cmp    %eax,%esi
80104d62:	73 1c                	jae    80104d80 <argint+0x40>
80104d64:	8d 53 08             	lea    0x8(%ebx),%edx
80104d67:	39 d0                	cmp    %edx,%eax
80104d69:	72 15                	jb     80104d80 <argint+0x40>
  *ip = *(int*)(addr);
80104d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d6e:	8b 53 04             	mov    0x4(%ebx),%edx
80104d71:	89 10                	mov    %edx,(%eax)
  return 0;
80104d73:	31 c0                	xor    %eax,%eax
}
80104d75:	5b                   	pop    %ebx
80104d76:	5e                   	pop    %esi
80104d77:	5d                   	pop    %ebp
80104d78:	c3                   	ret    
80104d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104d80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d85:	eb ee                	jmp    80104d75 <argint+0x35>
80104d87:	89 f6                	mov    %esi,%esi
80104d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d90 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	56                   	push   %esi
80104d94:	53                   	push   %ebx
80104d95:	83 ec 10             	sub    $0x10,%esp
80104d98:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104d9b:	e8 70 ef ff ff       	call   80103d10 <myproc>
80104da0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104da2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104da5:	83 ec 08             	sub    $0x8,%esp
80104da8:	50                   	push   %eax
80104da9:	ff 75 08             	pushl  0x8(%ebp)
80104dac:	e8 8f ff ff ff       	call   80104d40 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104db1:	83 c4 10             	add    $0x10,%esp
80104db4:	85 c0                	test   %eax,%eax
80104db6:	78 28                	js     80104de0 <argptr+0x50>
80104db8:	85 db                	test   %ebx,%ebx
80104dba:	78 24                	js     80104de0 <argptr+0x50>
80104dbc:	8b 16                	mov    (%esi),%edx
80104dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dc1:	39 c2                	cmp    %eax,%edx
80104dc3:	76 1b                	jbe    80104de0 <argptr+0x50>
80104dc5:	01 c3                	add    %eax,%ebx
80104dc7:	39 da                	cmp    %ebx,%edx
80104dc9:	72 15                	jb     80104de0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104dcb:	8b 55 0c             	mov    0xc(%ebp),%edx
80104dce:	89 02                	mov    %eax,(%edx)
  return 0;
80104dd0:	31 c0                	xor    %eax,%eax
}
80104dd2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dd5:	5b                   	pop    %ebx
80104dd6:	5e                   	pop    %esi
80104dd7:	5d                   	pop    %ebp
80104dd8:	c3                   	ret    
80104dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104de0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104de5:	eb eb                	jmp    80104dd2 <argptr+0x42>
80104de7:	89 f6                	mov    %esi,%esi
80104de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104df0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104df0:	55                   	push   %ebp
80104df1:	89 e5                	mov    %esp,%ebp
80104df3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104df6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104df9:	50                   	push   %eax
80104dfa:	ff 75 08             	pushl  0x8(%ebp)
80104dfd:	e8 3e ff ff ff       	call   80104d40 <argint>
80104e02:	83 c4 10             	add    $0x10,%esp
80104e05:	85 c0                	test   %eax,%eax
80104e07:	78 17                	js     80104e20 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104e09:	83 ec 08             	sub    $0x8,%esp
80104e0c:	ff 75 0c             	pushl  0xc(%ebp)
80104e0f:	ff 75 f4             	pushl  -0xc(%ebp)
80104e12:	e8 b9 fe ff ff       	call   80104cd0 <fetchstr>
80104e17:	83 c4 10             	add    $0x10,%esp
}
80104e1a:	c9                   	leave  
80104e1b:	c3                   	ret    
80104e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104e20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e25:	c9                   	leave  
80104e26:	c3                   	ret    
80104e27:	89 f6                	mov    %esi,%esi
80104e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e30 <syscall>:
[SYS_set_ratio_system] sys_set_ratio_system,
};

void
syscall(void)
{
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
80104e33:	56                   	push   %esi
80104e34:	53                   	push   %ebx
80104e35:	83 ec 10             	sub    $0x10,%esp
  int num;
  struct proc *curproc = myproc();
80104e38:	e8 d3 ee ff ff       	call   80103d10 <myproc>
80104e3d:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104e3f:	8b 40 18             	mov    0x18(%eax),%eax
80104e42:	8b 70 1c             	mov    0x1c(%eax),%esi
  if(num==SYS_reverse_number)
80104e45:	83 fe 16             	cmp    $0x16,%esi
80104e48:	74 56                	je     80104ea0 <syscall+0x70>
    int rev_arg;
    argint(0,&rev_arg);
    curproc->tf->oesp = rev_arg;
  }

  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104e4a:	8d 46 ff             	lea    -0x1(%esi),%eax
80104e4d:	83 f8 1d             	cmp    $0x1d,%eax
80104e50:	77 26                	ja     80104e78 <syscall+0x48>
80104e52:	8b 04 b5 40 7f 10 80 	mov    -0x7fef80c0(,%esi,4),%eax
80104e59:	85 c0                	test   %eax,%eax
80104e5b:	74 1b                	je     80104e78 <syscall+0x48>
    curproc->tf->eax = syscalls[num]();
80104e5d:	ff d0                	call   *%eax
80104e5f:	8b 53 18             	mov    0x18(%ebx),%edx
80104e62:	89 42 1c             	mov    %eax,0x1c(%edx)
    curproc->syscalls[num-1] += 1;
80104e65:	83 44 b3 78 01       	addl   $0x1,0x78(%ebx,%esi,4)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104e6a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e6d:	5b                   	pop    %ebx
80104e6e:	5e                   	pop    %esi
80104e6f:	5d                   	pop    %ebp
80104e70:	c3                   	ret    
80104e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            curproc->pid, curproc->name, num);
80104e78:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104e7b:	56                   	push   %esi
80104e7c:	50                   	push   %eax
80104e7d:	ff 73 10             	pushl  0x10(%ebx)
80104e80:	68 05 7f 10 80       	push   $0x80107f05
80104e85:	e8 d6 b7 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104e8a:	8b 43 18             	mov    0x18(%ebx),%eax
80104e8d:	83 c4 10             	add    $0x10,%esp
80104e90:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104e97:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e9a:	5b                   	pop    %ebx
80104e9b:	5e                   	pop    %esi
80104e9c:	5d                   	pop    %ebp
80104e9d:	c3                   	ret    
80104e9e:	66 90                	xchg   %ax,%ax
    argint(0,&rev_arg);
80104ea0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ea3:	83 ec 08             	sub    $0x8,%esp
80104ea6:	50                   	push   %eax
80104ea7:	6a 00                	push   $0x0
80104ea9:	e8 92 fe ff ff       	call   80104d40 <argint>
    curproc->tf->oesp = rev_arg;
80104eae:	8b 43 18             	mov    0x18(%ebx),%eax
80104eb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104eb4:	83 c4 10             	add    $0x10,%esp
    curproc->tf->oesp = rev_arg;
80104eb7:	89 50 0c             	mov    %edx,0xc(%eax)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104eba:	b8 60 5c 10 80       	mov    $0x80105c60,%eax
80104ebf:	eb 9c                	jmp    80104e5d <syscall+0x2d>
80104ec1:	66 90                	xchg   %ax,%ax
80104ec3:	66 90                	xchg   %ax,%ax
80104ec5:	66 90                	xchg   %ax,%ax
80104ec7:	66 90                	xchg   %ax,%ax
80104ec9:	66 90                	xchg   %ax,%ax
80104ecb:	66 90                	xchg   %ax,%ax
80104ecd:	66 90                	xchg   %ax,%ax
80104ecf:	90                   	nop

80104ed0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ed0:	55                   	push   %ebp
80104ed1:	89 e5                	mov    %esp,%ebp
80104ed3:	57                   	push   %edi
80104ed4:	56                   	push   %esi
80104ed5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104ed6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104ed9:	83 ec 34             	sub    $0x34,%esp
80104edc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104edf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104ee2:	56                   	push   %esi
80104ee3:	50                   	push   %eax
{
80104ee4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104ee7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104eea:	e8 31 d2 ff ff       	call   80102120 <nameiparent>
80104eef:	83 c4 10             	add    $0x10,%esp
80104ef2:	85 c0                	test   %eax,%eax
80104ef4:	0f 84 46 01 00 00    	je     80105040 <create+0x170>
    return 0;
  ilock(dp);
80104efa:	83 ec 0c             	sub    $0xc,%esp
80104efd:	89 c3                	mov    %eax,%ebx
80104eff:	50                   	push   %eax
80104f00:	e8 9b c9 ff ff       	call   801018a0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104f05:	83 c4 0c             	add    $0xc,%esp
80104f08:	6a 00                	push   $0x0
80104f0a:	56                   	push   %esi
80104f0b:	53                   	push   %ebx
80104f0c:	e8 bf ce ff ff       	call   80101dd0 <dirlookup>
80104f11:	83 c4 10             	add    $0x10,%esp
80104f14:	85 c0                	test   %eax,%eax
80104f16:	89 c7                	mov    %eax,%edi
80104f18:	74 36                	je     80104f50 <create+0x80>
    iunlockput(dp);
80104f1a:	83 ec 0c             	sub    $0xc,%esp
80104f1d:	53                   	push   %ebx
80104f1e:	e8 0d cc ff ff       	call   80101b30 <iunlockput>
    ilock(ip);
80104f23:	89 3c 24             	mov    %edi,(%esp)
80104f26:	e8 75 c9 ff ff       	call   801018a0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104f2b:	83 c4 10             	add    $0x10,%esp
80104f2e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104f33:	0f 85 97 00 00 00    	jne    80104fd0 <create+0x100>
80104f39:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104f3e:	0f 85 8c 00 00 00    	jne    80104fd0 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104f44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f47:	89 f8                	mov    %edi,%eax
80104f49:	5b                   	pop    %ebx
80104f4a:	5e                   	pop    %esi
80104f4b:	5f                   	pop    %edi
80104f4c:	5d                   	pop    %ebp
80104f4d:	c3                   	ret    
80104f4e:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
80104f50:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104f54:	83 ec 08             	sub    $0x8,%esp
80104f57:	50                   	push   %eax
80104f58:	ff 33                	pushl  (%ebx)
80104f5a:	e8 d1 c7 ff ff       	call   80101730 <ialloc>
80104f5f:	83 c4 10             	add    $0x10,%esp
80104f62:	85 c0                	test   %eax,%eax
80104f64:	89 c7                	mov    %eax,%edi
80104f66:	0f 84 e8 00 00 00    	je     80105054 <create+0x184>
  ilock(ip);
80104f6c:	83 ec 0c             	sub    $0xc,%esp
80104f6f:	50                   	push   %eax
80104f70:	e8 2b c9 ff ff       	call   801018a0 <ilock>
  ip->major = major;
80104f75:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104f79:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104f7d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104f81:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104f85:	b8 01 00 00 00       	mov    $0x1,%eax
80104f8a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104f8e:	89 3c 24             	mov    %edi,(%esp)
80104f91:	e8 5a c8 ff ff       	call   801017f0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104f96:	83 c4 10             	add    $0x10,%esp
80104f99:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104f9e:	74 50                	je     80104ff0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104fa0:	83 ec 04             	sub    $0x4,%esp
80104fa3:	ff 77 04             	pushl  0x4(%edi)
80104fa6:	56                   	push   %esi
80104fa7:	53                   	push   %ebx
80104fa8:	e8 93 d0 ff ff       	call   80102040 <dirlink>
80104fad:	83 c4 10             	add    $0x10,%esp
80104fb0:	85 c0                	test   %eax,%eax
80104fb2:	0f 88 8f 00 00 00    	js     80105047 <create+0x177>
  iunlockput(dp);
80104fb8:	83 ec 0c             	sub    $0xc,%esp
80104fbb:	53                   	push   %ebx
80104fbc:	e8 6f cb ff ff       	call   80101b30 <iunlockput>
  return ip;
80104fc1:	83 c4 10             	add    $0x10,%esp
}
80104fc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fc7:	89 f8                	mov    %edi,%eax
80104fc9:	5b                   	pop    %ebx
80104fca:	5e                   	pop    %esi
80104fcb:	5f                   	pop    %edi
80104fcc:	5d                   	pop    %ebp
80104fcd:	c3                   	ret    
80104fce:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104fd0:	83 ec 0c             	sub    $0xc,%esp
80104fd3:	57                   	push   %edi
    return 0;
80104fd4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104fd6:	e8 55 cb ff ff       	call   80101b30 <iunlockput>
    return 0;
80104fdb:	83 c4 10             	add    $0x10,%esp
}
80104fde:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fe1:	89 f8                	mov    %edi,%eax
80104fe3:	5b                   	pop    %ebx
80104fe4:	5e                   	pop    %esi
80104fe5:	5f                   	pop    %edi
80104fe6:	5d                   	pop    %ebp
80104fe7:	c3                   	ret    
80104fe8:	90                   	nop
80104fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104ff0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104ff5:	83 ec 0c             	sub    $0xc,%esp
80104ff8:	53                   	push   %ebx
80104ff9:	e8 f2 c7 ff ff       	call   801017f0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104ffe:	83 c4 0c             	add    $0xc,%esp
80105001:	ff 77 04             	pushl  0x4(%edi)
80105004:	68 d8 7f 10 80       	push   $0x80107fd8
80105009:	57                   	push   %edi
8010500a:	e8 31 d0 ff ff       	call   80102040 <dirlink>
8010500f:	83 c4 10             	add    $0x10,%esp
80105012:	85 c0                	test   %eax,%eax
80105014:	78 1c                	js     80105032 <create+0x162>
80105016:	83 ec 04             	sub    $0x4,%esp
80105019:	ff 73 04             	pushl  0x4(%ebx)
8010501c:	68 d7 7f 10 80       	push   $0x80107fd7
80105021:	57                   	push   %edi
80105022:	e8 19 d0 ff ff       	call   80102040 <dirlink>
80105027:	83 c4 10             	add    $0x10,%esp
8010502a:	85 c0                	test   %eax,%eax
8010502c:	0f 89 6e ff ff ff    	jns    80104fa0 <create+0xd0>
      panic("create dots");
80105032:	83 ec 0c             	sub    $0xc,%esp
80105035:	68 cb 7f 10 80       	push   $0x80107fcb
8010503a:	e8 51 b3 ff ff       	call   80100390 <panic>
8010503f:	90                   	nop
    return 0;
80105040:	31 ff                	xor    %edi,%edi
80105042:	e9 fd fe ff ff       	jmp    80104f44 <create+0x74>
    panic("create: dirlink");
80105047:	83 ec 0c             	sub    $0xc,%esp
8010504a:	68 da 7f 10 80       	push   $0x80107fda
8010504f:	e8 3c b3 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105054:	83 ec 0c             	sub    $0xc,%esp
80105057:	68 bc 7f 10 80       	push   $0x80107fbc
8010505c:	e8 2f b3 ff ff       	call   80100390 <panic>
80105061:	eb 0d                	jmp    80105070 <argfd.constprop.0>
80105063:	90                   	nop
80105064:	90                   	nop
80105065:	90                   	nop
80105066:	90                   	nop
80105067:	90                   	nop
80105068:	90                   	nop
80105069:	90                   	nop
8010506a:	90                   	nop
8010506b:	90                   	nop
8010506c:	90                   	nop
8010506d:	90                   	nop
8010506e:	90                   	nop
8010506f:	90                   	nop

80105070 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	56                   	push   %esi
80105074:	53                   	push   %ebx
80105075:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105077:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010507a:	89 d6                	mov    %edx,%esi
8010507c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010507f:	50                   	push   %eax
80105080:	6a 00                	push   $0x0
80105082:	e8 b9 fc ff ff       	call   80104d40 <argint>
80105087:	83 c4 10             	add    $0x10,%esp
8010508a:	85 c0                	test   %eax,%eax
8010508c:	78 2a                	js     801050b8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010508e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105092:	77 24                	ja     801050b8 <argfd.constprop.0+0x48>
80105094:	e8 77 ec ff ff       	call   80103d10 <myproc>
80105099:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010509c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801050a0:	85 c0                	test   %eax,%eax
801050a2:	74 14                	je     801050b8 <argfd.constprop.0+0x48>
  if(pfd)
801050a4:	85 db                	test   %ebx,%ebx
801050a6:	74 02                	je     801050aa <argfd.constprop.0+0x3a>
    *pfd = fd;
801050a8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
801050aa:	89 06                	mov    %eax,(%esi)
  return 0;
801050ac:	31 c0                	xor    %eax,%eax
}
801050ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050b1:	5b                   	pop    %ebx
801050b2:	5e                   	pop    %esi
801050b3:	5d                   	pop    %ebp
801050b4:	c3                   	ret    
801050b5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801050b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050bd:	eb ef                	jmp    801050ae <argfd.constprop.0+0x3e>
801050bf:	90                   	nop

801050c0 <sys_dup>:
{
801050c0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801050c1:	31 c0                	xor    %eax,%eax
{
801050c3:	89 e5                	mov    %esp,%ebp
801050c5:	56                   	push   %esi
801050c6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801050c7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801050ca:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801050cd:	e8 9e ff ff ff       	call   80105070 <argfd.constprop.0>
801050d2:	85 c0                	test   %eax,%eax
801050d4:	78 42                	js     80105118 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
801050d6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801050d9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801050db:	e8 30 ec ff ff       	call   80103d10 <myproc>
801050e0:	eb 0e                	jmp    801050f0 <sys_dup+0x30>
801050e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801050e8:	83 c3 01             	add    $0x1,%ebx
801050eb:	83 fb 10             	cmp    $0x10,%ebx
801050ee:	74 28                	je     80105118 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
801050f0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801050f4:	85 d2                	test   %edx,%edx
801050f6:	75 f0                	jne    801050e8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
801050f8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801050fc:	83 ec 0c             	sub    $0xc,%esp
801050ff:	ff 75 f4             	pushl  -0xc(%ebp)
80105102:	e8 09 bf ff ff       	call   80101010 <filedup>
  return fd;
80105107:	83 c4 10             	add    $0x10,%esp
}
8010510a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010510d:	89 d8                	mov    %ebx,%eax
8010510f:	5b                   	pop    %ebx
80105110:	5e                   	pop    %esi
80105111:	5d                   	pop    %ebp
80105112:	c3                   	ret    
80105113:	90                   	nop
80105114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105118:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010511b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105120:	89 d8                	mov    %ebx,%eax
80105122:	5b                   	pop    %ebx
80105123:	5e                   	pop    %esi
80105124:	5d                   	pop    %ebp
80105125:	c3                   	ret    
80105126:	8d 76 00             	lea    0x0(%esi),%esi
80105129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105130 <sys_read>:
{
80105130:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105131:	31 c0                	xor    %eax,%eax
{
80105133:	89 e5                	mov    %esp,%ebp
80105135:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105138:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010513b:	e8 30 ff ff ff       	call   80105070 <argfd.constprop.0>
80105140:	85 c0                	test   %eax,%eax
80105142:	78 4c                	js     80105190 <sys_read+0x60>
80105144:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105147:	83 ec 08             	sub    $0x8,%esp
8010514a:	50                   	push   %eax
8010514b:	6a 02                	push   $0x2
8010514d:	e8 ee fb ff ff       	call   80104d40 <argint>
80105152:	83 c4 10             	add    $0x10,%esp
80105155:	85 c0                	test   %eax,%eax
80105157:	78 37                	js     80105190 <sys_read+0x60>
80105159:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010515c:	83 ec 04             	sub    $0x4,%esp
8010515f:	ff 75 f0             	pushl  -0x10(%ebp)
80105162:	50                   	push   %eax
80105163:	6a 01                	push   $0x1
80105165:	e8 26 fc ff ff       	call   80104d90 <argptr>
8010516a:	83 c4 10             	add    $0x10,%esp
8010516d:	85 c0                	test   %eax,%eax
8010516f:	78 1f                	js     80105190 <sys_read+0x60>
  return fileread(f, p, n);
80105171:	83 ec 04             	sub    $0x4,%esp
80105174:	ff 75 f0             	pushl  -0x10(%ebp)
80105177:	ff 75 f4             	pushl  -0xc(%ebp)
8010517a:	ff 75 ec             	pushl  -0x14(%ebp)
8010517d:	e8 fe bf ff ff       	call   80101180 <fileread>
80105182:	83 c4 10             	add    $0x10,%esp
}
80105185:	c9                   	leave  
80105186:	c3                   	ret    
80105187:	89 f6                	mov    %esi,%esi
80105189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105190:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105195:	c9                   	leave  
80105196:	c3                   	ret    
80105197:	89 f6                	mov    %esi,%esi
80105199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051a0 <sys_write>:
{
801051a0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051a1:	31 c0                	xor    %eax,%eax
{
801051a3:	89 e5                	mov    %esp,%ebp
801051a5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051a8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801051ab:	e8 c0 fe ff ff       	call   80105070 <argfd.constprop.0>
801051b0:	85 c0                	test   %eax,%eax
801051b2:	78 4c                	js     80105200 <sys_write+0x60>
801051b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051b7:	83 ec 08             	sub    $0x8,%esp
801051ba:	50                   	push   %eax
801051bb:	6a 02                	push   $0x2
801051bd:	e8 7e fb ff ff       	call   80104d40 <argint>
801051c2:	83 c4 10             	add    $0x10,%esp
801051c5:	85 c0                	test   %eax,%eax
801051c7:	78 37                	js     80105200 <sys_write+0x60>
801051c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051cc:	83 ec 04             	sub    $0x4,%esp
801051cf:	ff 75 f0             	pushl  -0x10(%ebp)
801051d2:	50                   	push   %eax
801051d3:	6a 01                	push   $0x1
801051d5:	e8 b6 fb ff ff       	call   80104d90 <argptr>
801051da:	83 c4 10             	add    $0x10,%esp
801051dd:	85 c0                	test   %eax,%eax
801051df:	78 1f                	js     80105200 <sys_write+0x60>
  return filewrite(f, p, n);
801051e1:	83 ec 04             	sub    $0x4,%esp
801051e4:	ff 75 f0             	pushl  -0x10(%ebp)
801051e7:	ff 75 f4             	pushl  -0xc(%ebp)
801051ea:	ff 75 ec             	pushl  -0x14(%ebp)
801051ed:	e8 1e c0 ff ff       	call   80101210 <filewrite>
801051f2:	83 c4 10             	add    $0x10,%esp
}
801051f5:	c9                   	leave  
801051f6:	c3                   	ret    
801051f7:	89 f6                	mov    %esi,%esi
801051f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105200:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105205:	c9                   	leave  
80105206:	c3                   	ret    
80105207:	89 f6                	mov    %esi,%esi
80105209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105210 <sys_close>:
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105216:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105219:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010521c:	e8 4f fe ff ff       	call   80105070 <argfd.constprop.0>
80105221:	85 c0                	test   %eax,%eax
80105223:	78 2b                	js     80105250 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105225:	e8 e6 ea ff ff       	call   80103d10 <myproc>
8010522a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010522d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105230:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105237:	00 
  fileclose(f);
80105238:	ff 75 f4             	pushl  -0xc(%ebp)
8010523b:	e8 20 be ff ff       	call   80101060 <fileclose>
  return 0;
80105240:	83 c4 10             	add    $0x10,%esp
80105243:	31 c0                	xor    %eax,%eax
}
80105245:	c9                   	leave  
80105246:	c3                   	ret    
80105247:	89 f6                	mov    %esi,%esi
80105249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105250:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105255:	c9                   	leave  
80105256:	c3                   	ret    
80105257:	89 f6                	mov    %esi,%esi
80105259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105260 <sys_fstat>:
{
80105260:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105261:	31 c0                	xor    %eax,%eax
{
80105263:	89 e5                	mov    %esp,%ebp
80105265:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105268:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010526b:	e8 00 fe ff ff       	call   80105070 <argfd.constprop.0>
80105270:	85 c0                	test   %eax,%eax
80105272:	78 2c                	js     801052a0 <sys_fstat+0x40>
80105274:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105277:	83 ec 04             	sub    $0x4,%esp
8010527a:	6a 14                	push   $0x14
8010527c:	50                   	push   %eax
8010527d:	6a 01                	push   $0x1
8010527f:	e8 0c fb ff ff       	call   80104d90 <argptr>
80105284:	83 c4 10             	add    $0x10,%esp
80105287:	85 c0                	test   %eax,%eax
80105289:	78 15                	js     801052a0 <sys_fstat+0x40>
  return filestat(f, st);
8010528b:	83 ec 08             	sub    $0x8,%esp
8010528e:	ff 75 f4             	pushl  -0xc(%ebp)
80105291:	ff 75 f0             	pushl  -0x10(%ebp)
80105294:	e8 97 be ff ff       	call   80101130 <filestat>
80105299:	83 c4 10             	add    $0x10,%esp
}
8010529c:	c9                   	leave  
8010529d:	c3                   	ret    
8010529e:	66 90                	xchg   %ax,%ax
    return -1;
801052a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052a5:	c9                   	leave  
801052a6:	c3                   	ret    
801052a7:	89 f6                	mov    %esi,%esi
801052a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052b0 <sys_link>:
{
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
801052b3:	57                   	push   %edi
801052b4:	56                   	push   %esi
801052b5:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801052b6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801052b9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801052bc:	50                   	push   %eax
801052bd:	6a 00                	push   $0x0
801052bf:	e8 2c fb ff ff       	call   80104df0 <argstr>
801052c4:	83 c4 10             	add    $0x10,%esp
801052c7:	85 c0                	test   %eax,%eax
801052c9:	0f 88 fb 00 00 00    	js     801053ca <sys_link+0x11a>
801052cf:	8d 45 d0             	lea    -0x30(%ebp),%eax
801052d2:	83 ec 08             	sub    $0x8,%esp
801052d5:	50                   	push   %eax
801052d6:	6a 01                	push   $0x1
801052d8:	e8 13 fb ff ff       	call   80104df0 <argstr>
801052dd:	83 c4 10             	add    $0x10,%esp
801052e0:	85 c0                	test   %eax,%eax
801052e2:	0f 88 e2 00 00 00    	js     801053ca <sys_link+0x11a>
  begin_op();
801052e8:	e8 d3 da ff ff       	call   80102dc0 <begin_op>
  if((ip = namei(old)) == 0){
801052ed:	83 ec 0c             	sub    $0xc,%esp
801052f0:	ff 75 d4             	pushl  -0x2c(%ebp)
801052f3:	e8 08 ce ff ff       	call   80102100 <namei>
801052f8:	83 c4 10             	add    $0x10,%esp
801052fb:	85 c0                	test   %eax,%eax
801052fd:	89 c3                	mov    %eax,%ebx
801052ff:	0f 84 ea 00 00 00    	je     801053ef <sys_link+0x13f>
  ilock(ip);
80105305:	83 ec 0c             	sub    $0xc,%esp
80105308:	50                   	push   %eax
80105309:	e8 92 c5 ff ff       	call   801018a0 <ilock>
  if(ip->type == T_DIR){
8010530e:	83 c4 10             	add    $0x10,%esp
80105311:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105316:	0f 84 bb 00 00 00    	je     801053d7 <sys_link+0x127>
  ip->nlink++;
8010531c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105321:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105324:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105327:	53                   	push   %ebx
80105328:	e8 c3 c4 ff ff       	call   801017f0 <iupdate>
  iunlock(ip);
8010532d:	89 1c 24             	mov    %ebx,(%esp)
80105330:	e8 4b c6 ff ff       	call   80101980 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105335:	58                   	pop    %eax
80105336:	5a                   	pop    %edx
80105337:	57                   	push   %edi
80105338:	ff 75 d0             	pushl  -0x30(%ebp)
8010533b:	e8 e0 cd ff ff       	call   80102120 <nameiparent>
80105340:	83 c4 10             	add    $0x10,%esp
80105343:	85 c0                	test   %eax,%eax
80105345:	89 c6                	mov    %eax,%esi
80105347:	74 5b                	je     801053a4 <sys_link+0xf4>
  ilock(dp);
80105349:	83 ec 0c             	sub    $0xc,%esp
8010534c:	50                   	push   %eax
8010534d:	e8 4e c5 ff ff       	call   801018a0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105352:	83 c4 10             	add    $0x10,%esp
80105355:	8b 03                	mov    (%ebx),%eax
80105357:	39 06                	cmp    %eax,(%esi)
80105359:	75 3d                	jne    80105398 <sys_link+0xe8>
8010535b:	83 ec 04             	sub    $0x4,%esp
8010535e:	ff 73 04             	pushl  0x4(%ebx)
80105361:	57                   	push   %edi
80105362:	56                   	push   %esi
80105363:	e8 d8 cc ff ff       	call   80102040 <dirlink>
80105368:	83 c4 10             	add    $0x10,%esp
8010536b:	85 c0                	test   %eax,%eax
8010536d:	78 29                	js     80105398 <sys_link+0xe8>
  iunlockput(dp);
8010536f:	83 ec 0c             	sub    $0xc,%esp
80105372:	56                   	push   %esi
80105373:	e8 b8 c7 ff ff       	call   80101b30 <iunlockput>
  iput(ip);
80105378:	89 1c 24             	mov    %ebx,(%esp)
8010537b:	e8 50 c6 ff ff       	call   801019d0 <iput>
  end_op();
80105380:	e8 ab da ff ff       	call   80102e30 <end_op>
  return 0;
80105385:	83 c4 10             	add    $0x10,%esp
80105388:	31 c0                	xor    %eax,%eax
}
8010538a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010538d:	5b                   	pop    %ebx
8010538e:	5e                   	pop    %esi
8010538f:	5f                   	pop    %edi
80105390:	5d                   	pop    %ebp
80105391:	c3                   	ret    
80105392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105398:	83 ec 0c             	sub    $0xc,%esp
8010539b:	56                   	push   %esi
8010539c:	e8 8f c7 ff ff       	call   80101b30 <iunlockput>
    goto bad;
801053a1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801053a4:	83 ec 0c             	sub    $0xc,%esp
801053a7:	53                   	push   %ebx
801053a8:	e8 f3 c4 ff ff       	call   801018a0 <ilock>
  ip->nlink--;
801053ad:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801053b2:	89 1c 24             	mov    %ebx,(%esp)
801053b5:	e8 36 c4 ff ff       	call   801017f0 <iupdate>
  iunlockput(ip);
801053ba:	89 1c 24             	mov    %ebx,(%esp)
801053bd:	e8 6e c7 ff ff       	call   80101b30 <iunlockput>
  end_op();
801053c2:	e8 69 da ff ff       	call   80102e30 <end_op>
  return -1;
801053c7:	83 c4 10             	add    $0x10,%esp
}
801053ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801053cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053d2:	5b                   	pop    %ebx
801053d3:	5e                   	pop    %esi
801053d4:	5f                   	pop    %edi
801053d5:	5d                   	pop    %ebp
801053d6:	c3                   	ret    
    iunlockput(ip);
801053d7:	83 ec 0c             	sub    $0xc,%esp
801053da:	53                   	push   %ebx
801053db:	e8 50 c7 ff ff       	call   80101b30 <iunlockput>
    end_op();
801053e0:	e8 4b da ff ff       	call   80102e30 <end_op>
    return -1;
801053e5:	83 c4 10             	add    $0x10,%esp
801053e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053ed:	eb 9b                	jmp    8010538a <sys_link+0xda>
    end_op();
801053ef:	e8 3c da ff ff       	call   80102e30 <end_op>
    return -1;
801053f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053f9:	eb 8f                	jmp    8010538a <sys_link+0xda>
801053fb:	90                   	nop
801053fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105400 <sys_unlink>:
{
80105400:	55                   	push   %ebp
80105401:	89 e5                	mov    %esp,%ebp
80105403:	57                   	push   %edi
80105404:	56                   	push   %esi
80105405:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105406:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105409:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010540c:	50                   	push   %eax
8010540d:	6a 00                	push   $0x0
8010540f:	e8 dc f9 ff ff       	call   80104df0 <argstr>
80105414:	83 c4 10             	add    $0x10,%esp
80105417:	85 c0                	test   %eax,%eax
80105419:	0f 88 77 01 00 00    	js     80105596 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
8010541f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105422:	e8 99 d9 ff ff       	call   80102dc0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105427:	83 ec 08             	sub    $0x8,%esp
8010542a:	53                   	push   %ebx
8010542b:	ff 75 c0             	pushl  -0x40(%ebp)
8010542e:	e8 ed cc ff ff       	call   80102120 <nameiparent>
80105433:	83 c4 10             	add    $0x10,%esp
80105436:	85 c0                	test   %eax,%eax
80105438:	89 c6                	mov    %eax,%esi
8010543a:	0f 84 60 01 00 00    	je     801055a0 <sys_unlink+0x1a0>
  ilock(dp);
80105440:	83 ec 0c             	sub    $0xc,%esp
80105443:	50                   	push   %eax
80105444:	e8 57 c4 ff ff       	call   801018a0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105449:	58                   	pop    %eax
8010544a:	5a                   	pop    %edx
8010544b:	68 d8 7f 10 80       	push   $0x80107fd8
80105450:	53                   	push   %ebx
80105451:	e8 5a c9 ff ff       	call   80101db0 <namecmp>
80105456:	83 c4 10             	add    $0x10,%esp
80105459:	85 c0                	test   %eax,%eax
8010545b:	0f 84 03 01 00 00    	je     80105564 <sys_unlink+0x164>
80105461:	83 ec 08             	sub    $0x8,%esp
80105464:	68 d7 7f 10 80       	push   $0x80107fd7
80105469:	53                   	push   %ebx
8010546a:	e8 41 c9 ff ff       	call   80101db0 <namecmp>
8010546f:	83 c4 10             	add    $0x10,%esp
80105472:	85 c0                	test   %eax,%eax
80105474:	0f 84 ea 00 00 00    	je     80105564 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010547a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010547d:	83 ec 04             	sub    $0x4,%esp
80105480:	50                   	push   %eax
80105481:	53                   	push   %ebx
80105482:	56                   	push   %esi
80105483:	e8 48 c9 ff ff       	call   80101dd0 <dirlookup>
80105488:	83 c4 10             	add    $0x10,%esp
8010548b:	85 c0                	test   %eax,%eax
8010548d:	89 c3                	mov    %eax,%ebx
8010548f:	0f 84 cf 00 00 00    	je     80105564 <sys_unlink+0x164>
  ilock(ip);
80105495:	83 ec 0c             	sub    $0xc,%esp
80105498:	50                   	push   %eax
80105499:	e8 02 c4 ff ff       	call   801018a0 <ilock>
  if(ip->nlink < 1)
8010549e:	83 c4 10             	add    $0x10,%esp
801054a1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801054a6:	0f 8e 10 01 00 00    	jle    801055bc <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801054ac:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054b1:	74 6d                	je     80105520 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801054b3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801054b6:	83 ec 04             	sub    $0x4,%esp
801054b9:	6a 10                	push   $0x10
801054bb:	6a 00                	push   $0x0
801054bd:	50                   	push   %eax
801054be:	e8 7d f5 ff ff       	call   80104a40 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054c3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801054c6:	6a 10                	push   $0x10
801054c8:	ff 75 c4             	pushl  -0x3c(%ebp)
801054cb:	50                   	push   %eax
801054cc:	56                   	push   %esi
801054cd:	e8 ae c7 ff ff       	call   80101c80 <writei>
801054d2:	83 c4 20             	add    $0x20,%esp
801054d5:	83 f8 10             	cmp    $0x10,%eax
801054d8:	0f 85 eb 00 00 00    	jne    801055c9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
801054de:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054e3:	0f 84 97 00 00 00    	je     80105580 <sys_unlink+0x180>
  iunlockput(dp);
801054e9:	83 ec 0c             	sub    $0xc,%esp
801054ec:	56                   	push   %esi
801054ed:	e8 3e c6 ff ff       	call   80101b30 <iunlockput>
  ip->nlink--;
801054f2:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801054f7:	89 1c 24             	mov    %ebx,(%esp)
801054fa:	e8 f1 c2 ff ff       	call   801017f0 <iupdate>
  iunlockput(ip);
801054ff:	89 1c 24             	mov    %ebx,(%esp)
80105502:	e8 29 c6 ff ff       	call   80101b30 <iunlockput>
  end_op();
80105507:	e8 24 d9 ff ff       	call   80102e30 <end_op>
  return 0;
8010550c:	83 c4 10             	add    $0x10,%esp
8010550f:	31 c0                	xor    %eax,%eax
}
80105511:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105514:	5b                   	pop    %ebx
80105515:	5e                   	pop    %esi
80105516:	5f                   	pop    %edi
80105517:	5d                   	pop    %ebp
80105518:	c3                   	ret    
80105519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105520:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105524:	76 8d                	jbe    801054b3 <sys_unlink+0xb3>
80105526:	bf 20 00 00 00       	mov    $0x20,%edi
8010552b:	eb 0f                	jmp    8010553c <sys_unlink+0x13c>
8010552d:	8d 76 00             	lea    0x0(%esi),%esi
80105530:	83 c7 10             	add    $0x10,%edi
80105533:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105536:	0f 83 77 ff ff ff    	jae    801054b3 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010553c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010553f:	6a 10                	push   $0x10
80105541:	57                   	push   %edi
80105542:	50                   	push   %eax
80105543:	53                   	push   %ebx
80105544:	e8 37 c6 ff ff       	call   80101b80 <readi>
80105549:	83 c4 10             	add    $0x10,%esp
8010554c:	83 f8 10             	cmp    $0x10,%eax
8010554f:	75 5e                	jne    801055af <sys_unlink+0x1af>
    if(de.inum != 0)
80105551:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105556:	74 d8                	je     80105530 <sys_unlink+0x130>
    iunlockput(ip);
80105558:	83 ec 0c             	sub    $0xc,%esp
8010555b:	53                   	push   %ebx
8010555c:	e8 cf c5 ff ff       	call   80101b30 <iunlockput>
    goto bad;
80105561:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105564:	83 ec 0c             	sub    $0xc,%esp
80105567:	56                   	push   %esi
80105568:	e8 c3 c5 ff ff       	call   80101b30 <iunlockput>
  end_op();
8010556d:	e8 be d8 ff ff       	call   80102e30 <end_op>
  return -1;
80105572:	83 c4 10             	add    $0x10,%esp
80105575:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010557a:	eb 95                	jmp    80105511 <sys_unlink+0x111>
8010557c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105580:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105585:	83 ec 0c             	sub    $0xc,%esp
80105588:	56                   	push   %esi
80105589:	e8 62 c2 ff ff       	call   801017f0 <iupdate>
8010558e:	83 c4 10             	add    $0x10,%esp
80105591:	e9 53 ff ff ff       	jmp    801054e9 <sys_unlink+0xe9>
    return -1;
80105596:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010559b:	e9 71 ff ff ff       	jmp    80105511 <sys_unlink+0x111>
    end_op();
801055a0:	e8 8b d8 ff ff       	call   80102e30 <end_op>
    return -1;
801055a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055aa:	e9 62 ff ff ff       	jmp    80105511 <sys_unlink+0x111>
      panic("isdirempty: readi");
801055af:	83 ec 0c             	sub    $0xc,%esp
801055b2:	68 fc 7f 10 80       	push   $0x80107ffc
801055b7:	e8 d4 ad ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801055bc:	83 ec 0c             	sub    $0xc,%esp
801055bf:	68 ea 7f 10 80       	push   $0x80107fea
801055c4:	e8 c7 ad ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801055c9:	83 ec 0c             	sub    $0xc,%esp
801055cc:	68 0e 80 10 80       	push   $0x8010800e
801055d1:	e8 ba ad ff ff       	call   80100390 <panic>
801055d6:	8d 76 00             	lea    0x0(%esi),%esi
801055d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055e0 <sys_open>:

int
sys_open(void)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	57                   	push   %edi
801055e4:	56                   	push   %esi
801055e5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801055e6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801055e9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801055ec:	50                   	push   %eax
801055ed:	6a 00                	push   $0x0
801055ef:	e8 fc f7 ff ff       	call   80104df0 <argstr>
801055f4:	83 c4 10             	add    $0x10,%esp
801055f7:	85 c0                	test   %eax,%eax
801055f9:	0f 88 1d 01 00 00    	js     8010571c <sys_open+0x13c>
801055ff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105602:	83 ec 08             	sub    $0x8,%esp
80105605:	50                   	push   %eax
80105606:	6a 01                	push   $0x1
80105608:	e8 33 f7 ff ff       	call   80104d40 <argint>
8010560d:	83 c4 10             	add    $0x10,%esp
80105610:	85 c0                	test   %eax,%eax
80105612:	0f 88 04 01 00 00    	js     8010571c <sys_open+0x13c>
    return -1;

  begin_op();
80105618:	e8 a3 d7 ff ff       	call   80102dc0 <begin_op>

  if(omode & O_CREATE){
8010561d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105621:	0f 85 a9 00 00 00    	jne    801056d0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105627:	83 ec 0c             	sub    $0xc,%esp
8010562a:	ff 75 e0             	pushl  -0x20(%ebp)
8010562d:	e8 ce ca ff ff       	call   80102100 <namei>
80105632:	83 c4 10             	add    $0x10,%esp
80105635:	85 c0                	test   %eax,%eax
80105637:	89 c6                	mov    %eax,%esi
80105639:	0f 84 b2 00 00 00    	je     801056f1 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
8010563f:	83 ec 0c             	sub    $0xc,%esp
80105642:	50                   	push   %eax
80105643:	e8 58 c2 ff ff       	call   801018a0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105648:	83 c4 10             	add    $0x10,%esp
8010564b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105650:	0f 84 aa 00 00 00    	je     80105700 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105656:	e8 45 b9 ff ff       	call   80100fa0 <filealloc>
8010565b:	85 c0                	test   %eax,%eax
8010565d:	89 c7                	mov    %eax,%edi
8010565f:	0f 84 a6 00 00 00    	je     8010570b <sys_open+0x12b>
  struct proc *curproc = myproc();
80105665:	e8 a6 e6 ff ff       	call   80103d10 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010566a:	31 db                	xor    %ebx,%ebx
8010566c:	eb 0e                	jmp    8010567c <sys_open+0x9c>
8010566e:	66 90                	xchg   %ax,%ax
80105670:	83 c3 01             	add    $0x1,%ebx
80105673:	83 fb 10             	cmp    $0x10,%ebx
80105676:	0f 84 ac 00 00 00    	je     80105728 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010567c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105680:	85 d2                	test   %edx,%edx
80105682:	75 ec                	jne    80105670 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105684:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105687:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010568b:	56                   	push   %esi
8010568c:	e8 ef c2 ff ff       	call   80101980 <iunlock>
  end_op();
80105691:	e8 9a d7 ff ff       	call   80102e30 <end_op>

  f->type = FD_INODE;
80105696:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010569c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010569f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801056a2:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801056a5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801056ac:	89 d0                	mov    %edx,%eax
801056ae:	f7 d0                	not    %eax
801056b0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056b3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801056b6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056b9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801056bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056c0:	89 d8                	mov    %ebx,%eax
801056c2:	5b                   	pop    %ebx
801056c3:	5e                   	pop    %esi
801056c4:	5f                   	pop    %edi
801056c5:	5d                   	pop    %ebp
801056c6:	c3                   	ret    
801056c7:	89 f6                	mov    %esi,%esi
801056c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
801056d0:	83 ec 0c             	sub    $0xc,%esp
801056d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801056d6:	31 c9                	xor    %ecx,%ecx
801056d8:	6a 00                	push   $0x0
801056da:	ba 02 00 00 00       	mov    $0x2,%edx
801056df:	e8 ec f7 ff ff       	call   80104ed0 <create>
    if(ip == 0){
801056e4:	83 c4 10             	add    $0x10,%esp
801056e7:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
801056e9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801056eb:	0f 85 65 ff ff ff    	jne    80105656 <sys_open+0x76>
      end_op();
801056f1:	e8 3a d7 ff ff       	call   80102e30 <end_op>
      return -1;
801056f6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801056fb:	eb c0                	jmp    801056bd <sys_open+0xdd>
801056fd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105700:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105703:	85 c9                	test   %ecx,%ecx
80105705:	0f 84 4b ff ff ff    	je     80105656 <sys_open+0x76>
    iunlockput(ip);
8010570b:	83 ec 0c             	sub    $0xc,%esp
8010570e:	56                   	push   %esi
8010570f:	e8 1c c4 ff ff       	call   80101b30 <iunlockput>
    end_op();
80105714:	e8 17 d7 ff ff       	call   80102e30 <end_op>
    return -1;
80105719:	83 c4 10             	add    $0x10,%esp
8010571c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105721:	eb 9a                	jmp    801056bd <sys_open+0xdd>
80105723:	90                   	nop
80105724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105728:	83 ec 0c             	sub    $0xc,%esp
8010572b:	57                   	push   %edi
8010572c:	e8 2f b9 ff ff       	call   80101060 <fileclose>
80105731:	83 c4 10             	add    $0x10,%esp
80105734:	eb d5                	jmp    8010570b <sys_open+0x12b>
80105736:	8d 76 00             	lea    0x0(%esi),%esi
80105739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105740 <sys_mkdir>:

int
sys_mkdir(void)
{
80105740:	55                   	push   %ebp
80105741:	89 e5                	mov    %esp,%ebp
80105743:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105746:	e8 75 d6 ff ff       	call   80102dc0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010574b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010574e:	83 ec 08             	sub    $0x8,%esp
80105751:	50                   	push   %eax
80105752:	6a 00                	push   $0x0
80105754:	e8 97 f6 ff ff       	call   80104df0 <argstr>
80105759:	83 c4 10             	add    $0x10,%esp
8010575c:	85 c0                	test   %eax,%eax
8010575e:	78 30                	js     80105790 <sys_mkdir+0x50>
80105760:	83 ec 0c             	sub    $0xc,%esp
80105763:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105766:	31 c9                	xor    %ecx,%ecx
80105768:	6a 00                	push   $0x0
8010576a:	ba 01 00 00 00       	mov    $0x1,%edx
8010576f:	e8 5c f7 ff ff       	call   80104ed0 <create>
80105774:	83 c4 10             	add    $0x10,%esp
80105777:	85 c0                	test   %eax,%eax
80105779:	74 15                	je     80105790 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010577b:	83 ec 0c             	sub    $0xc,%esp
8010577e:	50                   	push   %eax
8010577f:	e8 ac c3 ff ff       	call   80101b30 <iunlockput>
  end_op();
80105784:	e8 a7 d6 ff ff       	call   80102e30 <end_op>
  return 0;
80105789:	83 c4 10             	add    $0x10,%esp
8010578c:	31 c0                	xor    %eax,%eax
}
8010578e:	c9                   	leave  
8010578f:	c3                   	ret    
    end_op();
80105790:	e8 9b d6 ff ff       	call   80102e30 <end_op>
    return -1;
80105795:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010579a:	c9                   	leave  
8010579b:	c3                   	ret    
8010579c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057a0 <sys_mknod>:

int
sys_mknod(void)
{
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
801057a3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801057a6:	e8 15 d6 ff ff       	call   80102dc0 <begin_op>
  if((argstr(0, &path)) < 0 ||
801057ab:	8d 45 ec             	lea    -0x14(%ebp),%eax
801057ae:	83 ec 08             	sub    $0x8,%esp
801057b1:	50                   	push   %eax
801057b2:	6a 00                	push   $0x0
801057b4:	e8 37 f6 ff ff       	call   80104df0 <argstr>
801057b9:	83 c4 10             	add    $0x10,%esp
801057bc:	85 c0                	test   %eax,%eax
801057be:	78 60                	js     80105820 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801057c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057c3:	83 ec 08             	sub    $0x8,%esp
801057c6:	50                   	push   %eax
801057c7:	6a 01                	push   $0x1
801057c9:	e8 72 f5 ff ff       	call   80104d40 <argint>
  if((argstr(0, &path)) < 0 ||
801057ce:	83 c4 10             	add    $0x10,%esp
801057d1:	85 c0                	test   %eax,%eax
801057d3:	78 4b                	js     80105820 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801057d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057d8:	83 ec 08             	sub    $0x8,%esp
801057db:	50                   	push   %eax
801057dc:	6a 02                	push   $0x2
801057de:	e8 5d f5 ff ff       	call   80104d40 <argint>
     argint(1, &major) < 0 ||
801057e3:	83 c4 10             	add    $0x10,%esp
801057e6:	85 c0                	test   %eax,%eax
801057e8:	78 36                	js     80105820 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801057ea:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801057ee:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
801057f1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
801057f5:	ba 03 00 00 00       	mov    $0x3,%edx
801057fa:	50                   	push   %eax
801057fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801057fe:	e8 cd f6 ff ff       	call   80104ed0 <create>
80105803:	83 c4 10             	add    $0x10,%esp
80105806:	85 c0                	test   %eax,%eax
80105808:	74 16                	je     80105820 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010580a:	83 ec 0c             	sub    $0xc,%esp
8010580d:	50                   	push   %eax
8010580e:	e8 1d c3 ff ff       	call   80101b30 <iunlockput>
  end_op();
80105813:	e8 18 d6 ff ff       	call   80102e30 <end_op>
  return 0;
80105818:	83 c4 10             	add    $0x10,%esp
8010581b:	31 c0                	xor    %eax,%eax
}
8010581d:	c9                   	leave  
8010581e:	c3                   	ret    
8010581f:	90                   	nop
    end_op();
80105820:	e8 0b d6 ff ff       	call   80102e30 <end_op>
    return -1;
80105825:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010582a:	c9                   	leave  
8010582b:	c3                   	ret    
8010582c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105830 <sys_chdir>:

int
sys_chdir(void)
{
80105830:	55                   	push   %ebp
80105831:	89 e5                	mov    %esp,%ebp
80105833:	56                   	push   %esi
80105834:	53                   	push   %ebx
80105835:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105838:	e8 d3 e4 ff ff       	call   80103d10 <myproc>
8010583d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010583f:	e8 7c d5 ff ff       	call   80102dc0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105844:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105847:	83 ec 08             	sub    $0x8,%esp
8010584a:	50                   	push   %eax
8010584b:	6a 00                	push   $0x0
8010584d:	e8 9e f5 ff ff       	call   80104df0 <argstr>
80105852:	83 c4 10             	add    $0x10,%esp
80105855:	85 c0                	test   %eax,%eax
80105857:	78 77                	js     801058d0 <sys_chdir+0xa0>
80105859:	83 ec 0c             	sub    $0xc,%esp
8010585c:	ff 75 f4             	pushl  -0xc(%ebp)
8010585f:	e8 9c c8 ff ff       	call   80102100 <namei>
80105864:	83 c4 10             	add    $0x10,%esp
80105867:	85 c0                	test   %eax,%eax
80105869:	89 c3                	mov    %eax,%ebx
8010586b:	74 63                	je     801058d0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010586d:	83 ec 0c             	sub    $0xc,%esp
80105870:	50                   	push   %eax
80105871:	e8 2a c0 ff ff       	call   801018a0 <ilock>
  if(ip->type != T_DIR){
80105876:	83 c4 10             	add    $0x10,%esp
80105879:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010587e:	75 30                	jne    801058b0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105880:	83 ec 0c             	sub    $0xc,%esp
80105883:	53                   	push   %ebx
80105884:	e8 f7 c0 ff ff       	call   80101980 <iunlock>
  iput(curproc->cwd);
80105889:	58                   	pop    %eax
8010588a:	ff 76 68             	pushl  0x68(%esi)
8010588d:	e8 3e c1 ff ff       	call   801019d0 <iput>
  end_op();
80105892:	e8 99 d5 ff ff       	call   80102e30 <end_op>
  curproc->cwd = ip;
80105897:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010589a:	83 c4 10             	add    $0x10,%esp
8010589d:	31 c0                	xor    %eax,%eax
}
8010589f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801058a2:	5b                   	pop    %ebx
801058a3:	5e                   	pop    %esi
801058a4:	5d                   	pop    %ebp
801058a5:	c3                   	ret    
801058a6:	8d 76 00             	lea    0x0(%esi),%esi
801058a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
801058b0:	83 ec 0c             	sub    $0xc,%esp
801058b3:	53                   	push   %ebx
801058b4:	e8 77 c2 ff ff       	call   80101b30 <iunlockput>
    end_op();
801058b9:	e8 72 d5 ff ff       	call   80102e30 <end_op>
    return -1;
801058be:	83 c4 10             	add    $0x10,%esp
801058c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058c6:	eb d7                	jmp    8010589f <sys_chdir+0x6f>
801058c8:	90                   	nop
801058c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801058d0:	e8 5b d5 ff ff       	call   80102e30 <end_op>
    return -1;
801058d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058da:	eb c3                	jmp    8010589f <sys_chdir+0x6f>
801058dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058e0 <sys_exec>:

int
sys_exec(void)
{
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	57                   	push   %edi
801058e4:	56                   	push   %esi
801058e5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801058e6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801058ec:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801058f2:	50                   	push   %eax
801058f3:	6a 00                	push   $0x0
801058f5:	e8 f6 f4 ff ff       	call   80104df0 <argstr>
801058fa:	83 c4 10             	add    $0x10,%esp
801058fd:	85 c0                	test   %eax,%eax
801058ff:	0f 88 87 00 00 00    	js     8010598c <sys_exec+0xac>
80105905:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010590b:	83 ec 08             	sub    $0x8,%esp
8010590e:	50                   	push   %eax
8010590f:	6a 01                	push   $0x1
80105911:	e8 2a f4 ff ff       	call   80104d40 <argint>
80105916:	83 c4 10             	add    $0x10,%esp
80105919:	85 c0                	test   %eax,%eax
8010591b:	78 6f                	js     8010598c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010591d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105923:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105926:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105928:	68 80 00 00 00       	push   $0x80
8010592d:	6a 00                	push   $0x0
8010592f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105935:	50                   	push   %eax
80105936:	e8 05 f1 ff ff       	call   80104a40 <memset>
8010593b:	83 c4 10             	add    $0x10,%esp
8010593e:	eb 2c                	jmp    8010596c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105940:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105946:	85 c0                	test   %eax,%eax
80105948:	74 56                	je     801059a0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010594a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105950:	83 ec 08             	sub    $0x8,%esp
80105953:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105956:	52                   	push   %edx
80105957:	50                   	push   %eax
80105958:	e8 73 f3 ff ff       	call   80104cd0 <fetchstr>
8010595d:	83 c4 10             	add    $0x10,%esp
80105960:	85 c0                	test   %eax,%eax
80105962:	78 28                	js     8010598c <sys_exec+0xac>
  for(i=0;; i++){
80105964:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105967:	83 fb 20             	cmp    $0x20,%ebx
8010596a:	74 20                	je     8010598c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010596c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105972:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105979:	83 ec 08             	sub    $0x8,%esp
8010597c:	57                   	push   %edi
8010597d:	01 f0                	add    %esi,%eax
8010597f:	50                   	push   %eax
80105980:	e8 0b f3 ff ff       	call   80104c90 <fetchint>
80105985:	83 c4 10             	add    $0x10,%esp
80105988:	85 c0                	test   %eax,%eax
8010598a:	79 b4                	jns    80105940 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010598c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010598f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105994:	5b                   	pop    %ebx
80105995:	5e                   	pop    %esi
80105996:	5f                   	pop    %edi
80105997:	5d                   	pop    %ebp
80105998:	c3                   	ret    
80105999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801059a0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801059a6:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
801059a9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801059b0:	00 00 00 00 
  return exec(path, argv);
801059b4:	50                   	push   %eax
801059b5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801059bb:	e8 20 b2 ff ff       	call   80100be0 <exec>
801059c0:	83 c4 10             	add    $0x10,%esp
}
801059c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059c6:	5b                   	pop    %ebx
801059c7:	5e                   	pop    %esi
801059c8:	5f                   	pop    %edi
801059c9:	5d                   	pop    %ebp
801059ca:	c3                   	ret    
801059cb:	90                   	nop
801059cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059d0 <sys_pipe>:

int
sys_pipe(void)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	57                   	push   %edi
801059d4:	56                   	push   %esi
801059d5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801059d6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801059d9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801059dc:	6a 08                	push   $0x8
801059de:	50                   	push   %eax
801059df:	6a 00                	push   $0x0
801059e1:	e8 aa f3 ff ff       	call   80104d90 <argptr>
801059e6:	83 c4 10             	add    $0x10,%esp
801059e9:	85 c0                	test   %eax,%eax
801059eb:	0f 88 ae 00 00 00    	js     80105a9f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801059f1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801059f4:	83 ec 08             	sub    $0x8,%esp
801059f7:	50                   	push   %eax
801059f8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801059fb:	50                   	push   %eax
801059fc:	e8 5f da ff ff       	call   80103460 <pipealloc>
80105a01:	83 c4 10             	add    $0x10,%esp
80105a04:	85 c0                	test   %eax,%eax
80105a06:	0f 88 93 00 00 00    	js     80105a9f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105a0c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105a0f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105a11:	e8 fa e2 ff ff       	call   80103d10 <myproc>
80105a16:	eb 10                	jmp    80105a28 <sys_pipe+0x58>
80105a18:	90                   	nop
80105a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105a20:	83 c3 01             	add    $0x1,%ebx
80105a23:	83 fb 10             	cmp    $0x10,%ebx
80105a26:	74 60                	je     80105a88 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105a28:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105a2c:	85 f6                	test   %esi,%esi
80105a2e:	75 f0                	jne    80105a20 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105a30:	8d 73 08             	lea    0x8(%ebx),%esi
80105a33:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105a37:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105a3a:	e8 d1 e2 ff ff       	call   80103d10 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105a3f:	31 d2                	xor    %edx,%edx
80105a41:	eb 0d                	jmp    80105a50 <sys_pipe+0x80>
80105a43:	90                   	nop
80105a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a48:	83 c2 01             	add    $0x1,%edx
80105a4b:	83 fa 10             	cmp    $0x10,%edx
80105a4e:	74 28                	je     80105a78 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105a50:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105a54:	85 c9                	test   %ecx,%ecx
80105a56:	75 f0                	jne    80105a48 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105a58:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105a5c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a5f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105a61:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a64:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105a67:	31 c0                	xor    %eax,%eax
}
80105a69:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a6c:	5b                   	pop    %ebx
80105a6d:	5e                   	pop    %esi
80105a6e:	5f                   	pop    %edi
80105a6f:	5d                   	pop    %ebp
80105a70:	c3                   	ret    
80105a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105a78:	e8 93 e2 ff ff       	call   80103d10 <myproc>
80105a7d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105a84:	00 
80105a85:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105a88:	83 ec 0c             	sub    $0xc,%esp
80105a8b:	ff 75 e0             	pushl  -0x20(%ebp)
80105a8e:	e8 cd b5 ff ff       	call   80101060 <fileclose>
    fileclose(wf);
80105a93:	58                   	pop    %eax
80105a94:	ff 75 e4             	pushl  -0x1c(%ebp)
80105a97:	e8 c4 b5 ff ff       	call   80101060 <fileclose>
    return -1;
80105a9c:	83 c4 10             	add    $0x10,%esp
80105a9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aa4:	eb c3                	jmp    80105a69 <sys_pipe+0x99>
80105aa6:	66 90                	xchg   %ax,%ax
80105aa8:	66 90                	xchg   %ax,%ax
80105aaa:	66 90                	xchg   %ax,%ax
80105aac:	66 90                	xchg   %ax,%ax
80105aae:	66 90                	xchg   %ax,%ax

80105ab0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105ab3:	5d                   	pop    %ebp
  return fork();
80105ab4:	e9 f7 e3 ff ff       	jmp    80103eb0 <fork>
80105ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ac0 <sys_exit>:

int
sys_exit(void)
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105ac6:	e8 05 e7 ff ff       	call   801041d0 <exit>
  return 0;  // not reached
}
80105acb:	31 c0                	xor    %eax,%eax
80105acd:	c9                   	leave  
80105ace:	c3                   	ret    
80105acf:	90                   	nop

80105ad0 <sys_wait>:

int
sys_wait(void)
{
80105ad0:	55                   	push   %ebp
80105ad1:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105ad3:	5d                   	pop    %ebp
  return wait();
80105ad4:	e9 37 e9 ff ff       	jmp    80104410 <wait>
80105ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ae0 <sys_kill>:

int
sys_kill(void)
{
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
80105ae3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105ae6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ae9:	50                   	push   %eax
80105aea:	6a 00                	push   $0x0
80105aec:	e8 4f f2 ff ff       	call   80104d40 <argint>
80105af1:	83 c4 10             	add    $0x10,%esp
80105af4:	85 c0                	test   %eax,%eax
80105af6:	78 18                	js     80105b10 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105af8:	83 ec 0c             	sub    $0xc,%esp
80105afb:	ff 75 f4             	pushl  -0xc(%ebp)
80105afe:	e8 6d ea ff ff       	call   80104570 <kill>
80105b03:	83 c4 10             	add    $0x10,%esp
}
80105b06:	c9                   	leave  
80105b07:	c3                   	ret    
80105b08:	90                   	nop
80105b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105b10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b15:	c9                   	leave  
80105b16:	c3                   	ret    
80105b17:	89 f6                	mov    %esi,%esi
80105b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b20 <sys_getpid>:

int
sys_getpid(void)
{
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105b26:	e8 e5 e1 ff ff       	call   80103d10 <myproc>
80105b2b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105b2e:	c9                   	leave  
80105b2f:	c3                   	ret    

80105b30 <sys_sbrk>:

int
sys_sbrk(void)
{
80105b30:	55                   	push   %ebp
80105b31:	89 e5                	mov    %esp,%ebp
80105b33:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105b34:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105b37:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105b3a:	50                   	push   %eax
80105b3b:	6a 00                	push   $0x0
80105b3d:	e8 fe f1 ff ff       	call   80104d40 <argint>
80105b42:	83 c4 10             	add    $0x10,%esp
80105b45:	85 c0                	test   %eax,%eax
80105b47:	78 27                	js     80105b70 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105b49:	e8 c2 e1 ff ff       	call   80103d10 <myproc>
  if(growproc(n) < 0)
80105b4e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105b51:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105b53:	ff 75 f4             	pushl  -0xc(%ebp)
80105b56:	e8 d5 e2 ff ff       	call   80103e30 <growproc>
80105b5b:	83 c4 10             	add    $0x10,%esp
80105b5e:	85 c0                	test   %eax,%eax
80105b60:	78 0e                	js     80105b70 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105b62:	89 d8                	mov    %ebx,%eax
80105b64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b67:	c9                   	leave  
80105b68:	c3                   	ret    
80105b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105b70:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b75:	eb eb                	jmp    80105b62 <sys_sbrk+0x32>
80105b77:	89 f6                	mov    %esi,%esi
80105b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b80 <sys_sleep>:

int
sys_sleep(void)
{
80105b80:	55                   	push   %ebp
80105b81:	89 e5                	mov    %esp,%ebp
80105b83:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105b84:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105b87:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105b8a:	50                   	push   %eax
80105b8b:	6a 00                	push   $0x0
80105b8d:	e8 ae f1 ff ff       	call   80104d40 <argint>
80105b92:	83 c4 10             	add    $0x10,%esp
80105b95:	85 c0                	test   %eax,%eax
80105b97:	0f 88 8a 00 00 00    	js     80105c27 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105b9d:	83 ec 0c             	sub    $0xc,%esp
80105ba0:	68 60 7b 11 80       	push   $0x80117b60
80105ba5:	e8 86 ed ff ff       	call   80104930 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105baa:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105bad:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105bb0:	8b 1d a0 83 11 80    	mov    0x801183a0,%ebx
  while(ticks - ticks0 < n){
80105bb6:	85 d2                	test   %edx,%edx
80105bb8:	75 27                	jne    80105be1 <sys_sleep+0x61>
80105bba:	eb 54                	jmp    80105c10 <sys_sleep+0x90>
80105bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105bc0:	83 ec 08             	sub    $0x8,%esp
80105bc3:	68 60 7b 11 80       	push   $0x80117b60
80105bc8:	68 a0 83 11 80       	push   $0x801183a0
80105bcd:	e8 7e e7 ff ff       	call   80104350 <sleep>
  while(ticks - ticks0 < n){
80105bd2:	a1 a0 83 11 80       	mov    0x801183a0,%eax
80105bd7:	83 c4 10             	add    $0x10,%esp
80105bda:	29 d8                	sub    %ebx,%eax
80105bdc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105bdf:	73 2f                	jae    80105c10 <sys_sleep+0x90>
    if(myproc()->killed){
80105be1:	e8 2a e1 ff ff       	call   80103d10 <myproc>
80105be6:	8b 40 24             	mov    0x24(%eax),%eax
80105be9:	85 c0                	test   %eax,%eax
80105beb:	74 d3                	je     80105bc0 <sys_sleep+0x40>
      release(&tickslock);
80105bed:	83 ec 0c             	sub    $0xc,%esp
80105bf0:	68 60 7b 11 80       	push   $0x80117b60
80105bf5:	e8 f6 ed ff ff       	call   801049f0 <release>
      return -1;
80105bfa:	83 c4 10             	add    $0x10,%esp
80105bfd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105c02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c05:	c9                   	leave  
80105c06:	c3                   	ret    
80105c07:	89 f6                	mov    %esi,%esi
80105c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105c10:	83 ec 0c             	sub    $0xc,%esp
80105c13:	68 60 7b 11 80       	push   $0x80117b60
80105c18:	e8 d3 ed ff ff       	call   801049f0 <release>
  return 0;
80105c1d:	83 c4 10             	add    $0x10,%esp
80105c20:	31 c0                	xor    %eax,%eax
}
80105c22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c25:	c9                   	leave  
80105c26:	c3                   	ret    
    return -1;
80105c27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c2c:	eb f4                	jmp    80105c22 <sys_sleep+0xa2>
80105c2e:	66 90                	xchg   %ax,%ax

80105c30 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105c30:	55                   	push   %ebp
80105c31:	89 e5                	mov    %esp,%ebp
80105c33:	53                   	push   %ebx
80105c34:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105c37:	68 60 7b 11 80       	push   $0x80117b60
80105c3c:	e8 ef ec ff ff       	call   80104930 <acquire>
  xticks = ticks;
80105c41:	8b 1d a0 83 11 80    	mov    0x801183a0,%ebx
  release(&tickslock);
80105c47:	c7 04 24 60 7b 11 80 	movl   $0x80117b60,(%esp)
80105c4e:	e8 9d ed ff ff       	call   801049f0 <release>
  return xticks;
}
80105c53:	89 d8                	mov    %ebx,%eax
80105c55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c58:	c9                   	leave  
80105c59:	c3                   	ret    
80105c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105c60 <sys_reverse_number>:

int 
sys_reverse_number(void)
{
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	56                   	push   %esi
80105c64:	53                   	push   %ebx
  struct proc *curproc = myproc();
80105c65:	e8 a6 e0 ff ff       	call   80103d10 <myproc>
  int number = curproc->tf->edx;
80105c6a:	8b 40 18             	mov    0x18(%eax),%eax
80105c6d:	8b 48 14             	mov    0x14(%eax),%ecx
  int reverse =0;
80105c70:	31 c0                	xor    %eax,%eax

  while(number > 0) 
80105c72:	85 c9                	test   %ecx,%ecx
80105c74:	7e 24                	jle    80105c9a <sys_reverse_number+0x3a>
    { 
        reverse = reverse*10 + number%10; 
80105c76:	be cd cc cc cc       	mov    $0xcccccccd,%esi
80105c7b:	90                   	nop
80105c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c80:	8d 1c 80             	lea    (%eax,%eax,4),%ebx
80105c83:	89 c8                	mov    %ecx,%eax
80105c85:	f7 e6                	mul    %esi
80105c87:	c1 ea 03             	shr    $0x3,%edx
80105c8a:	8d 04 92             	lea    (%edx,%edx,4),%eax
80105c8d:	01 c0                	add    %eax,%eax
80105c8f:	29 c1                	sub    %eax,%ecx
  while(number > 0) 
80105c91:	85 d2                	test   %edx,%edx
        reverse = reverse*10 + number%10; 
80105c93:	8d 04 59             	lea    (%ecx,%ebx,2),%eax
        number = number/10; 
80105c96:	89 d1                	mov    %edx,%ecx
  while(number > 0) 
80105c98:	75 e6                	jne    80105c80 <sys_reverse_number+0x20>
    } 
    cprintf("Reverse number is : %d\n",reverse);
80105c9a:	83 ec 08             	sub    $0x8,%esp
80105c9d:	50                   	push   %eax
80105c9e:	68 1d 80 10 80       	push   $0x8010801d
80105ca3:	e8 b8 a9 ff ff       	call   80100660 <cprintf>
    return 1; 
}
80105ca8:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105cab:	b8 01 00 00 00       	mov    $0x1,%eax
80105cb0:	5b                   	pop    %ebx
80105cb1:	5e                   	pop    %esi
80105cb2:	5d                   	pop    %ebp
80105cb3:	c3                   	ret    
80105cb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105cba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105cc0 <sys_trace_syscalls>:

int 
sys_trace_syscalls(void)
{
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
80105cc3:	53                   	push   %ebx
80105cc4:	83 ec 14             	sub    $0x14,%esp
  int state;
  struct proc *curproc = myproc();
80105cc7:	e8 44 e0 ff ff       	call   80103d10 <myproc>
80105ccc:	89 c3                	mov    %eax,%ebx

  if(argint(0, &state) < 0)
80105cce:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cd1:	83 ec 08             	sub    $0x8,%esp
80105cd4:	50                   	push   %eax
80105cd5:	6a 00                	push   $0x0
80105cd7:	e8 64 f0 ff ff       	call   80104d40 <argint>
80105cdc:	83 c4 10             	add    $0x10,%esp
80105cdf:	85 c0                	test   %eax,%eax
80105ce1:	78 3d                	js     80105d20 <sys_trace_syscalls+0x60>
    return -1;
  if(curproc->pid == 2)
80105ce3:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80105ce7:	74 1f                	je     80105d08 <sys_trace_syscalls+0x48>
  {
    show_syscalls();
  }
  else
  set_state(state);
80105ce9:	83 ec 0c             	sub    $0xc,%esp
80105cec:	ff 75 f4             	pushl  -0xc(%ebp)
80105cef:	e8 ac dc ff ff       	call   801039a0 <set_state>
80105cf4:	83 c4 10             	add    $0x10,%esp

  return 1;
80105cf7:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105cfc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105cff:	c9                   	leave  
80105d00:	c3                   	ret    
80105d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    show_syscalls();
80105d08:	e8 a3 dc ff ff       	call   801039b0 <show_syscalls>
  return 1;
80105d0d:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105d12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d15:	c9                   	leave  
80105d16:	c3                   	ret    
80105d17:	89 f6                	mov    %esi,%esi
80105d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105d20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d25:	eb d5                	jmp    80105cfc <sys_trace_syscalls+0x3c>
80105d27:	89 f6                	mov    %esi,%esi
80105d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d30 <sys_get_children>:

int 
sys_get_children(void)
{
80105d30:	55                   	push   %ebp
80105d31:	89 e5                	mov    %esp,%ebp
80105d33:	83 ec 20             	sub    $0x20,%esp
  int parent_id;

  if(argint(0, &parent_id) < 0)
80105d36:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d39:	50                   	push   %eax
80105d3a:	6a 00                	push   $0x0
80105d3c:	e8 ff ef ff ff       	call   80104d40 <argint>
80105d41:	83 c4 10             	add    $0x10,%esp
80105d44:	85 c0                	test   %eax,%eax
80105d46:	78 18                	js     80105d60 <sys_get_children+0x30>
    return -1;
  show_children(parent_id);
80105d48:	83 ec 0c             	sub    $0xc,%esp
80105d4b:	ff 75 f4             	pushl  -0xc(%ebp)
80105d4e:	e8 2d dd ff ff       	call   80103a80 <show_children>
  return 1;
80105d53:	83 c4 10             	add    $0x10,%esp
80105d56:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105d5b:	c9                   	leave  
80105d5c:	c3                   	ret    
80105d5d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105d60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d65:	c9                   	leave  
80105d66:	c3                   	ret    
80105d67:	89 f6                	mov    %esi,%esi
80105d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d70 <sys_get_grandchildren>:

int 
sys_get_grandchildren(void)
{
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
80105d73:	83 ec 20             	sub    $0x20,%esp
  int parent_id;

  if(argint(0, &parent_id) < 0)
80105d76:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d79:	50                   	push   %eax
80105d7a:	6a 00                	push   $0x0
80105d7c:	e8 bf ef ff ff       	call   80104d40 <argint>
80105d81:	83 c4 10             	add    $0x10,%esp
80105d84:	85 c0                	test   %eax,%eax
80105d86:	78 18                	js     80105da0 <sys_get_grandchildren+0x30>
    return -1;
  show_grandchildren(parent_id);
80105d88:	83 ec 0c             	sub    $0xc,%esp
80105d8b:	ff 75 f4             	pushl  -0xc(%ebp)
80105d8e:	e8 5d dd ff ff       	call   80103af0 <show_grandchildren>
  return 1;
80105d93:	83 c4 10             	add    $0x10,%esp
80105d96:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105d9b:	c9                   	leave  
80105d9c:	c3                   	ret    
80105d9d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105da0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105da5:	c9                   	leave  
80105da6:	c3                   	ret    
80105da7:	89 f6                	mov    %esi,%esi
80105da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105db0 <sys_getpid_parent>:

int
sys_getpid_parent(void)
{
80105db0:	55                   	push   %ebp
80105db1:	89 e5                	mov    %esp,%ebp
80105db3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->parent->pid;
80105db6:	e8 55 df ff ff       	call   80103d10 <myproc>
80105dbb:	8b 40 14             	mov    0x14(%eax),%eax
80105dbe:	8b 40 10             	mov    0x10(%eax),%eax
}
80105dc1:	c9                   	leave  
80105dc2:	c3                   	ret    
80105dc3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105dd0 <sys_change_queue>:

int 
sys_change_queue(void)
{
80105dd0:	55                   	push   %ebp
80105dd1:	89 e5                	mov    %esp,%ebp
80105dd3:	83 ec 20             	sub    $0x20,%esp
  int pid;
  int dst_queue;

  if(argint(0, &pid) < 0)
80105dd6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105dd9:	50                   	push   %eax
80105dda:	6a 00                	push   $0x0
80105ddc:	e8 5f ef ff ff       	call   80104d40 <argint>
80105de1:	83 c4 10             	add    $0x10,%esp
80105de4:	85 c0                	test   %eax,%eax
80105de6:	78 30                	js     80105e18 <sys_change_queue+0x48>
    return -1;

  if(argint(1, &dst_queue) < 0)
80105de8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105deb:	83 ec 08             	sub    $0x8,%esp
80105dee:	50                   	push   %eax
80105def:	6a 01                	push   $0x1
80105df1:	e8 4a ef ff ff       	call   80104d40 <argint>
80105df6:	83 c4 10             	add    $0x10,%esp
80105df9:	85 c0                	test   %eax,%eax
80105dfb:	78 1b                	js     80105e18 <sys_change_queue+0x48>
    return -1;
  
  change_sched_queue(pid, dst_queue);
80105dfd:	83 ec 08             	sub    $0x8,%esp
80105e00:	ff 75 f4             	pushl  -0xc(%ebp)
80105e03:	ff 75 f0             	pushl  -0x10(%ebp)
80105e06:	e8 65 dd ff ff       	call   80103b70 <change_sched_queue>
  return 1;
80105e0b:	83 c4 10             	add    $0x10,%esp
80105e0e:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105e13:	c9                   	leave  
80105e14:	c3                   	ret    
80105e15:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105e18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e1d:	c9                   	leave  
80105e1e:	c3                   	ret    
80105e1f:	90                   	nop

80105e20 <sys_set_ticket>:

int 
sys_set_ticket(void)
{
80105e20:	55                   	push   %ebp
80105e21:	89 e5                	mov    %esp,%ebp
80105e23:	83 ec 20             	sub    $0x20,%esp
  int pid;
  int tickets;

  if(argint(0, &pid) < 0)
80105e26:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e29:	50                   	push   %eax
80105e2a:	6a 00                	push   $0x0
80105e2c:	e8 0f ef ff ff       	call   80104d40 <argint>
80105e31:	83 c4 10             	add    $0x10,%esp
80105e34:	85 c0                	test   %eax,%eax
80105e36:	78 30                	js     80105e68 <sys_set_ticket+0x48>
    return -1;

  if(argint(1, &tickets) < 0)
80105e38:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e3b:	83 ec 08             	sub    $0x8,%esp
80105e3e:	50                   	push   %eax
80105e3f:	6a 01                	push   $0x1
80105e41:	e8 fa ee ff ff       	call   80104d40 <argint>
80105e46:	83 c4 10             	add    $0x10,%esp
80105e49:	85 c0                	test   %eax,%eax
80105e4b:	78 1b                	js     80105e68 <sys_set_ticket+0x48>
    return -1;
  
  set_ticket(pid, tickets);
80105e4d:	83 ec 08             	sub    $0x8,%esp
80105e50:	ff 75 f4             	pushl  -0xc(%ebp)
80105e53:	ff 75 f0             	pushl  -0x10(%ebp)
80105e56:	e8 45 dd ff ff       	call   80103ba0 <set_ticket>
  return 1;
80105e5b:	83 c4 10             	add    $0x10,%esp
80105e5e:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105e63:	c9                   	leave  
80105e64:	c3                   	ret    
80105e65:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105e68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e6d:	c9                   	leave  
80105e6e:	c3                   	ret    
80105e6f:	90                   	nop

80105e70 <sys_set_ratio_process>:

int 
sys_set_ratio_process(void)
{
80105e70:	55                   	push   %ebp
80105e71:	89 e5                	mov    %esp,%ebp
80105e73:	83 ec 20             	sub    $0x20,%esp
  int pid;
  int priority_ratio;
  int arrival_time_ratio;
  int executed_cycle_ratio;

  if(argint(0, &pid) < 0)
80105e76:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105e79:	50                   	push   %eax
80105e7a:	6a 00                	push   $0x0
80105e7c:	e8 bf ee ff ff       	call   80104d40 <argint>
80105e81:	83 c4 10             	add    $0x10,%esp
80105e84:	85 c0                	test   %eax,%eax
80105e86:	78 60                	js     80105ee8 <sys_set_ratio_process+0x78>
    return -1;

  if(argint(1, &priority_ratio) < 0)
80105e88:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e8b:	83 ec 08             	sub    $0x8,%esp
80105e8e:	50                   	push   %eax
80105e8f:	6a 01                	push   $0x1
80105e91:	e8 aa ee ff ff       	call   80104d40 <argint>
80105e96:	83 c4 10             	add    $0x10,%esp
80105e99:	85 c0                	test   %eax,%eax
80105e9b:	78 4b                	js     80105ee8 <sys_set_ratio_process+0x78>
    return -1;

  if(argint(2, &arrival_time_ratio) < 0)
80105e9d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ea0:	83 ec 08             	sub    $0x8,%esp
80105ea3:	50                   	push   %eax
80105ea4:	6a 02                	push   $0x2
80105ea6:	e8 95 ee ff ff       	call   80104d40 <argint>
80105eab:	83 c4 10             	add    $0x10,%esp
80105eae:	85 c0                	test   %eax,%eax
80105eb0:	78 36                	js     80105ee8 <sys_set_ratio_process+0x78>
    return -1;

  if(argint(3, &executed_cycle_ratio) < 0)
80105eb2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105eb5:	83 ec 08             	sub    $0x8,%esp
80105eb8:	50                   	push   %eax
80105eb9:	6a 03                	push   $0x3
80105ebb:	e8 80 ee ff ff       	call   80104d40 <argint>
80105ec0:	83 c4 10             	add    $0x10,%esp
80105ec3:	85 c0                	test   %eax,%eax
80105ec5:	78 21                	js     80105ee8 <sys_set_ratio_process+0x78>
    return -1;
  
  set_ratio_process(pid, priority_ratio, arrival_time_ratio, executed_cycle_ratio);
80105ec7:	ff 75 f4             	pushl  -0xc(%ebp)
80105eca:	ff 75 f0             	pushl  -0x10(%ebp)
80105ecd:	ff 75 ec             	pushl  -0x14(%ebp)
80105ed0:	ff 75 e8             	pushl  -0x18(%ebp)
80105ed3:	e8 f8 dc ff ff       	call   80103bd0 <set_ratio_process>
  return 1;
80105ed8:	83 c4 10             	add    $0x10,%esp
80105edb:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105ee0:	c9                   	leave  
80105ee1:	c3                   	ret    
80105ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105ee8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105eed:	c9                   	leave  
80105eee:	c3                   	ret    
80105eef:	90                   	nop

80105ef0 <sys_set_ratio_system>:

int 
sys_set_ratio_system(void)
{
80105ef0:	55                   	push   %ebp
80105ef1:	89 e5                	mov    %esp,%ebp
80105ef3:	83 ec 20             	sub    $0x20,%esp
  int priority_ratio;
  int arrival_time_ratio;
  int executed_cycle_ratio;

  if(argint(0, &priority_ratio) < 0)
80105ef6:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105ef9:	50                   	push   %eax
80105efa:	6a 00                	push   $0x0
80105efc:	e8 3f ee ff ff       	call   80104d40 <argint>
80105f01:	83 c4 10             	add    $0x10,%esp
80105f04:	85 c0                	test   %eax,%eax
80105f06:	78 48                	js     80105f50 <sys_set_ratio_system+0x60>
    return -1;

  if(argint(1, &arrival_time_ratio) < 0)
80105f08:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f0b:	83 ec 08             	sub    $0x8,%esp
80105f0e:	50                   	push   %eax
80105f0f:	6a 01                	push   $0x1
80105f11:	e8 2a ee ff ff       	call   80104d40 <argint>
80105f16:	83 c4 10             	add    $0x10,%esp
80105f19:	85 c0                	test   %eax,%eax
80105f1b:	78 33                	js     80105f50 <sys_set_ratio_system+0x60>
    return -1;

  if(argint(2, &executed_cycle_ratio) < 0)
80105f1d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f20:	83 ec 08             	sub    $0x8,%esp
80105f23:	50                   	push   %eax
80105f24:	6a 02                	push   $0x2
80105f26:	e8 15 ee ff ff       	call   80104d40 <argint>
80105f2b:	83 c4 10             	add    $0x10,%esp
80105f2e:	85 c0                	test   %eax,%eax
80105f30:	78 1e                	js     80105f50 <sys_set_ratio_system+0x60>
    return -1;
  
  set_ratio_system(priority_ratio, arrival_time_ratio, executed_cycle_ratio);
80105f32:	83 ec 04             	sub    $0x4,%esp
80105f35:	ff 75 f4             	pushl  -0xc(%ebp)
80105f38:	ff 75 f0             	pushl  -0x10(%ebp)
80105f3b:	ff 75 ec             	pushl  -0x14(%ebp)
80105f3e:	e8 cd dc ff ff       	call   80103c10 <set_ratio_system>
  return 1;
80105f43:	83 c4 10             	add    $0x10,%esp
80105f46:	b8 01 00 00 00       	mov    $0x1,%eax
80105f4b:	c9                   	leave  
80105f4c:	c3                   	ret    
80105f4d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f55:	c9                   	leave  
80105f56:	c3                   	ret    

80105f57 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105f57:	1e                   	push   %ds
  pushl %es
80105f58:	06                   	push   %es
  pushl %fs
80105f59:	0f a0                	push   %fs
  pushl %gs
80105f5b:	0f a8                	push   %gs
  pushal
80105f5d:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105f5e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105f62:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105f64:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105f66:	54                   	push   %esp
  call trap
80105f67:	e8 c4 00 00 00       	call   80106030 <trap>
  addl $4, %esp
80105f6c:	83 c4 04             	add    $0x4,%esp

80105f6f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105f6f:	61                   	popa   
  popl %gs
80105f70:	0f a9                	pop    %gs
  popl %fs
80105f72:	0f a1                	pop    %fs
  popl %es
80105f74:	07                   	pop    %es
  popl %ds
80105f75:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105f76:	83 c4 08             	add    $0x8,%esp
  iret
80105f79:	cf                   	iret   
80105f7a:	66 90                	xchg   %ax,%ax
80105f7c:	66 90                	xchg   %ax,%ax
80105f7e:	66 90                	xchg   %ax,%ax

80105f80 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105f80:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105f81:	31 c0                	xor    %eax,%eax
{
80105f83:	89 e5                	mov    %esp,%ebp
80105f85:	83 ec 08             	sub    $0x8,%esp
80105f88:	90                   	nop
80105f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105f90:	8b 14 85 80 b0 10 80 	mov    -0x7fef4f80(,%eax,4),%edx
80105f97:	c7 04 c5 a2 7b 11 80 	movl   $0x8e000008,-0x7fee845e(,%eax,8)
80105f9e:	08 00 00 8e 
80105fa2:	66 89 14 c5 a0 7b 11 	mov    %dx,-0x7fee8460(,%eax,8)
80105fa9:	80 
80105faa:	c1 ea 10             	shr    $0x10,%edx
80105fad:	66 89 14 c5 a6 7b 11 	mov    %dx,-0x7fee845a(,%eax,8)
80105fb4:	80 
  for(i = 0; i < 256; i++)
80105fb5:	83 c0 01             	add    $0x1,%eax
80105fb8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105fbd:	75 d1                	jne    80105f90 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105fbf:	a1 80 b1 10 80       	mov    0x8010b180,%eax

  initlock(&tickslock, "time");
80105fc4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105fc7:	c7 05 a2 7d 11 80 08 	movl   $0xef000008,0x80117da2
80105fce:	00 00 ef 
  initlock(&tickslock, "time");
80105fd1:	68 50 7e 10 80       	push   $0x80107e50
80105fd6:	68 60 7b 11 80       	push   $0x80117b60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105fdb:	66 a3 a0 7d 11 80    	mov    %ax,0x80117da0
80105fe1:	c1 e8 10             	shr    $0x10,%eax
80105fe4:	66 a3 a6 7d 11 80    	mov    %ax,0x80117da6
  initlock(&tickslock, "time");
80105fea:	e8 01 e8 ff ff       	call   801047f0 <initlock>
}
80105fef:	83 c4 10             	add    $0x10,%esp
80105ff2:	c9                   	leave  
80105ff3:	c3                   	ret    
80105ff4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105ffa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106000 <idtinit>:

void
idtinit(void)
{
80106000:	55                   	push   %ebp
  pd[0] = size-1;
80106001:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106006:	89 e5                	mov    %esp,%ebp
80106008:	83 ec 10             	sub    $0x10,%esp
8010600b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010600f:	b8 a0 7b 11 80       	mov    $0x80117ba0,%eax
80106014:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106018:	c1 e8 10             	shr    $0x10,%eax
8010601b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010601f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106022:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106025:	c9                   	leave  
80106026:	c3                   	ret    
80106027:	89 f6                	mov    %esi,%esi
80106029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106030 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106030:	55                   	push   %ebp
80106031:	89 e5                	mov    %esp,%ebp
80106033:	57                   	push   %edi
80106034:	56                   	push   %esi
80106035:	53                   	push   %ebx
80106036:	83 ec 1c             	sub    $0x1c,%esp
80106039:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010603c:	8b 47 30             	mov    0x30(%edi),%eax
8010603f:	83 f8 40             	cmp    $0x40,%eax
80106042:	0f 84 f0 00 00 00    	je     80106138 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106048:	83 e8 20             	sub    $0x20,%eax
8010604b:	83 f8 1f             	cmp    $0x1f,%eax
8010604e:	77 10                	ja     80106060 <trap+0x30>
80106050:	ff 24 85 d8 80 10 80 	jmp    *-0x7fef7f28(,%eax,4)
80106057:	89 f6                	mov    %esi,%esi
80106059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106060:	e8 ab dc ff ff       	call   80103d10 <myproc>
80106065:	85 c0                	test   %eax,%eax
80106067:	8b 5f 38             	mov    0x38(%edi),%ebx
8010606a:	0f 84 14 02 00 00    	je     80106284 <trap+0x254>
80106070:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106074:	0f 84 0a 02 00 00    	je     80106284 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010607a:	0f 20 d1             	mov    %cr2,%ecx
8010607d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106080:	e8 6b dc ff ff       	call   80103cf0 <cpuid>
80106085:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106088:	8b 47 34             	mov    0x34(%edi),%eax
8010608b:	8b 77 30             	mov    0x30(%edi),%esi
8010608e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106091:	e8 7a dc ff ff       	call   80103d10 <myproc>
80106096:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106099:	e8 72 dc ff ff       	call   80103d10 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010609e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801060a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801060a4:	51                   	push   %ecx
801060a5:	53                   	push   %ebx
801060a6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
801060a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801060aa:	ff 75 e4             	pushl  -0x1c(%ebp)
801060ad:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801060ae:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801060b1:	52                   	push   %edx
801060b2:	ff 70 10             	pushl  0x10(%eax)
801060b5:	68 94 80 10 80       	push   $0x80108094
801060ba:	e8 a1 a5 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801060bf:	83 c4 20             	add    $0x20,%esp
801060c2:	e8 49 dc ff ff       	call   80103d10 <myproc>
801060c7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060ce:	e8 3d dc ff ff       	call   80103d10 <myproc>
801060d3:	85 c0                	test   %eax,%eax
801060d5:	74 1d                	je     801060f4 <trap+0xc4>
801060d7:	e8 34 dc ff ff       	call   80103d10 <myproc>
801060dc:	8b 50 24             	mov    0x24(%eax),%edx
801060df:	85 d2                	test   %edx,%edx
801060e1:	74 11                	je     801060f4 <trap+0xc4>
801060e3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801060e7:	83 e0 03             	and    $0x3,%eax
801060ea:	66 83 f8 03          	cmp    $0x3,%ax
801060ee:	0f 84 4c 01 00 00    	je     80106240 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801060f4:	e8 17 dc ff ff       	call   80103d10 <myproc>
801060f9:	85 c0                	test   %eax,%eax
801060fb:	74 0b                	je     80106108 <trap+0xd8>
801060fd:	e8 0e dc ff ff       	call   80103d10 <myproc>
80106102:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106106:	74 68                	je     80106170 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106108:	e8 03 dc ff ff       	call   80103d10 <myproc>
8010610d:	85 c0                	test   %eax,%eax
8010610f:	74 19                	je     8010612a <trap+0xfa>
80106111:	e8 fa db ff ff       	call   80103d10 <myproc>
80106116:	8b 40 24             	mov    0x24(%eax),%eax
80106119:	85 c0                	test   %eax,%eax
8010611b:	74 0d                	je     8010612a <trap+0xfa>
8010611d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106121:	83 e0 03             	and    $0x3,%eax
80106124:	66 83 f8 03          	cmp    $0x3,%ax
80106128:	74 37                	je     80106161 <trap+0x131>
    exit();
}
8010612a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010612d:	5b                   	pop    %ebx
8010612e:	5e                   	pop    %esi
8010612f:	5f                   	pop    %edi
80106130:	5d                   	pop    %ebp
80106131:	c3                   	ret    
80106132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80106138:	e8 d3 db ff ff       	call   80103d10 <myproc>
8010613d:	8b 58 24             	mov    0x24(%eax),%ebx
80106140:	85 db                	test   %ebx,%ebx
80106142:	0f 85 e8 00 00 00    	jne    80106230 <trap+0x200>
    myproc()->tf = tf;
80106148:	e8 c3 db ff ff       	call   80103d10 <myproc>
8010614d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106150:	e8 db ec ff ff       	call   80104e30 <syscall>
    if(myproc()->killed)
80106155:	e8 b6 db ff ff       	call   80103d10 <myproc>
8010615a:	8b 48 24             	mov    0x24(%eax),%ecx
8010615d:	85 c9                	test   %ecx,%ecx
8010615f:	74 c9                	je     8010612a <trap+0xfa>
}
80106161:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106164:	5b                   	pop    %ebx
80106165:	5e                   	pop    %esi
80106166:	5f                   	pop    %edi
80106167:	5d                   	pop    %ebp
      exit();
80106168:	e9 63 e0 ff ff       	jmp    801041d0 <exit>
8010616d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106170:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106174:	75 92                	jne    80106108 <trap+0xd8>
    yield();
80106176:	e8 85 e1 ff ff       	call   80104300 <yield>
8010617b:	eb 8b                	jmp    80106108 <trap+0xd8>
8010617d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80106180:	e8 6b db ff ff       	call   80103cf0 <cpuid>
80106185:	85 c0                	test   %eax,%eax
80106187:	0f 84 c3 00 00 00    	je     80106250 <trap+0x220>
    lapiceoi();
8010618d:	e8 de c7 ff ff       	call   80102970 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106192:	e8 79 db ff ff       	call   80103d10 <myproc>
80106197:	85 c0                	test   %eax,%eax
80106199:	0f 85 38 ff ff ff    	jne    801060d7 <trap+0xa7>
8010619f:	e9 50 ff ff ff       	jmp    801060f4 <trap+0xc4>
801061a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801061a8:	e8 83 c6 ff ff       	call   80102830 <kbdintr>
    lapiceoi();
801061ad:	e8 be c7 ff ff       	call   80102970 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061b2:	e8 59 db ff ff       	call   80103d10 <myproc>
801061b7:	85 c0                	test   %eax,%eax
801061b9:	0f 85 18 ff ff ff    	jne    801060d7 <trap+0xa7>
801061bf:	e9 30 ff ff ff       	jmp    801060f4 <trap+0xc4>
801061c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
801061c8:	e8 53 02 00 00       	call   80106420 <uartintr>
    lapiceoi();
801061cd:	e8 9e c7 ff ff       	call   80102970 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061d2:	e8 39 db ff ff       	call   80103d10 <myproc>
801061d7:	85 c0                	test   %eax,%eax
801061d9:	0f 85 f8 fe ff ff    	jne    801060d7 <trap+0xa7>
801061df:	e9 10 ff ff ff       	jmp    801060f4 <trap+0xc4>
801061e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801061e8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801061ec:	8b 77 38             	mov    0x38(%edi),%esi
801061ef:	e8 fc da ff ff       	call   80103cf0 <cpuid>
801061f4:	56                   	push   %esi
801061f5:	53                   	push   %ebx
801061f6:	50                   	push   %eax
801061f7:	68 3c 80 10 80       	push   $0x8010803c
801061fc:	e8 5f a4 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106201:	e8 6a c7 ff ff       	call   80102970 <lapiceoi>
    break;
80106206:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106209:	e8 02 db ff ff       	call   80103d10 <myproc>
8010620e:	85 c0                	test   %eax,%eax
80106210:	0f 85 c1 fe ff ff    	jne    801060d7 <trap+0xa7>
80106216:	e9 d9 fe ff ff       	jmp    801060f4 <trap+0xc4>
8010621b:	90                   	nop
8010621c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80106220:	e8 7b c0 ff ff       	call   801022a0 <ideintr>
80106225:	e9 63 ff ff ff       	jmp    8010618d <trap+0x15d>
8010622a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106230:	e8 9b df ff ff       	call   801041d0 <exit>
80106235:	e9 0e ff ff ff       	jmp    80106148 <trap+0x118>
8010623a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106240:	e8 8b df ff ff       	call   801041d0 <exit>
80106245:	e9 aa fe ff ff       	jmp    801060f4 <trap+0xc4>
8010624a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106250:	83 ec 0c             	sub    $0xc,%esp
80106253:	68 60 7b 11 80       	push   $0x80117b60
80106258:	e8 d3 e6 ff ff       	call   80104930 <acquire>
      wakeup(&ticks);
8010625d:	c7 04 24 a0 83 11 80 	movl   $0x801183a0,(%esp)
      ticks++;
80106264:	83 05 a0 83 11 80 01 	addl   $0x1,0x801183a0
      wakeup(&ticks);
8010626b:	e8 a0 e2 ff ff       	call   80104510 <wakeup>
      release(&tickslock);
80106270:	c7 04 24 60 7b 11 80 	movl   $0x80117b60,(%esp)
80106277:	e8 74 e7 ff ff       	call   801049f0 <release>
8010627c:	83 c4 10             	add    $0x10,%esp
8010627f:	e9 09 ff ff ff       	jmp    8010618d <trap+0x15d>
80106284:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106287:	e8 64 da ff ff       	call   80103cf0 <cpuid>
8010628c:	83 ec 0c             	sub    $0xc,%esp
8010628f:	56                   	push   %esi
80106290:	53                   	push   %ebx
80106291:	50                   	push   %eax
80106292:	ff 77 30             	pushl  0x30(%edi)
80106295:	68 60 80 10 80       	push   $0x80108060
8010629a:	e8 c1 a3 ff ff       	call   80100660 <cprintf>
      panic("trap");
8010629f:	83 c4 14             	add    $0x14,%esp
801062a2:	68 35 80 10 80       	push   $0x80108035
801062a7:	e8 e4 a0 ff ff       	call   80100390 <panic>
801062ac:	66 90                	xchg   %ax,%ax
801062ae:	66 90                	xchg   %ax,%ax

801062b0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801062b0:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
{
801062b5:	55                   	push   %ebp
801062b6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801062b8:	85 c0                	test   %eax,%eax
801062ba:	74 1c                	je     801062d8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801062bc:	ba fd 03 00 00       	mov    $0x3fd,%edx
801062c1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801062c2:	a8 01                	test   $0x1,%al
801062c4:	74 12                	je     801062d8 <uartgetc+0x28>
801062c6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062cb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801062cc:	0f b6 c0             	movzbl %al,%eax
}
801062cf:	5d                   	pop    %ebp
801062d0:	c3                   	ret    
801062d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801062d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062dd:	5d                   	pop    %ebp
801062de:	c3                   	ret    
801062df:	90                   	nop

801062e0 <uartputc.part.0>:
uartputc(int c)
801062e0:	55                   	push   %ebp
801062e1:	89 e5                	mov    %esp,%ebp
801062e3:	57                   	push   %edi
801062e4:	56                   	push   %esi
801062e5:	53                   	push   %ebx
801062e6:	89 c7                	mov    %eax,%edi
801062e8:	bb 80 00 00 00       	mov    $0x80,%ebx
801062ed:	be fd 03 00 00       	mov    $0x3fd,%esi
801062f2:	83 ec 0c             	sub    $0xc,%esp
801062f5:	eb 1b                	jmp    80106312 <uartputc.part.0+0x32>
801062f7:	89 f6                	mov    %esi,%esi
801062f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106300:	83 ec 0c             	sub    $0xc,%esp
80106303:	6a 0a                	push   $0xa
80106305:	e8 86 c6 ff ff       	call   80102990 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010630a:	83 c4 10             	add    $0x10,%esp
8010630d:	83 eb 01             	sub    $0x1,%ebx
80106310:	74 07                	je     80106319 <uartputc.part.0+0x39>
80106312:	89 f2                	mov    %esi,%edx
80106314:	ec                   	in     (%dx),%al
80106315:	a8 20                	test   $0x20,%al
80106317:	74 e7                	je     80106300 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106319:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010631e:	89 f8                	mov    %edi,%eax
80106320:	ee                   	out    %al,(%dx)
}
80106321:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106324:	5b                   	pop    %ebx
80106325:	5e                   	pop    %esi
80106326:	5f                   	pop    %edi
80106327:	5d                   	pop    %ebp
80106328:	c3                   	ret    
80106329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106330 <uartinit>:
{
80106330:	55                   	push   %ebp
80106331:	31 c9                	xor    %ecx,%ecx
80106333:	89 c8                	mov    %ecx,%eax
80106335:	89 e5                	mov    %esp,%ebp
80106337:	57                   	push   %edi
80106338:	56                   	push   %esi
80106339:	53                   	push   %ebx
8010633a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010633f:	89 da                	mov    %ebx,%edx
80106341:	83 ec 0c             	sub    $0xc,%esp
80106344:	ee                   	out    %al,(%dx)
80106345:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010634a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010634f:	89 fa                	mov    %edi,%edx
80106351:	ee                   	out    %al,(%dx)
80106352:	b8 0c 00 00 00       	mov    $0xc,%eax
80106357:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010635c:	ee                   	out    %al,(%dx)
8010635d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106362:	89 c8                	mov    %ecx,%eax
80106364:	89 f2                	mov    %esi,%edx
80106366:	ee                   	out    %al,(%dx)
80106367:	b8 03 00 00 00       	mov    $0x3,%eax
8010636c:	89 fa                	mov    %edi,%edx
8010636e:	ee                   	out    %al,(%dx)
8010636f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106374:	89 c8                	mov    %ecx,%eax
80106376:	ee                   	out    %al,(%dx)
80106377:	b8 01 00 00 00       	mov    $0x1,%eax
8010637c:	89 f2                	mov    %esi,%edx
8010637e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010637f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106384:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106385:	3c ff                	cmp    $0xff,%al
80106387:	74 5a                	je     801063e3 <uartinit+0xb3>
  uart = 1;
80106389:	c7 05 3c b6 10 80 01 	movl   $0x1,0x8010b63c
80106390:	00 00 00 
80106393:	89 da                	mov    %ebx,%edx
80106395:	ec                   	in     (%dx),%al
80106396:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010639b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010639c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010639f:	bb 58 81 10 80       	mov    $0x80108158,%ebx
  ioapicenable(IRQ_COM1, 0);
801063a4:	6a 00                	push   $0x0
801063a6:	6a 04                	push   $0x4
801063a8:	e8 43 c1 ff ff       	call   801024f0 <ioapicenable>
801063ad:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801063b0:	b8 78 00 00 00       	mov    $0x78,%eax
801063b5:	eb 13                	jmp    801063ca <uartinit+0x9a>
801063b7:	89 f6                	mov    %esi,%esi
801063b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801063c0:	83 c3 01             	add    $0x1,%ebx
801063c3:	0f be 03             	movsbl (%ebx),%eax
801063c6:	84 c0                	test   %al,%al
801063c8:	74 19                	je     801063e3 <uartinit+0xb3>
  if(!uart)
801063ca:	8b 15 3c b6 10 80    	mov    0x8010b63c,%edx
801063d0:	85 d2                	test   %edx,%edx
801063d2:	74 ec                	je     801063c0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
801063d4:	83 c3 01             	add    $0x1,%ebx
801063d7:	e8 04 ff ff ff       	call   801062e0 <uartputc.part.0>
801063dc:	0f be 03             	movsbl (%ebx),%eax
801063df:	84 c0                	test   %al,%al
801063e1:	75 e7                	jne    801063ca <uartinit+0x9a>
}
801063e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063e6:	5b                   	pop    %ebx
801063e7:	5e                   	pop    %esi
801063e8:	5f                   	pop    %edi
801063e9:	5d                   	pop    %ebp
801063ea:	c3                   	ret    
801063eb:	90                   	nop
801063ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801063f0 <uartputc>:
  if(!uart)
801063f0:	8b 15 3c b6 10 80    	mov    0x8010b63c,%edx
{
801063f6:	55                   	push   %ebp
801063f7:	89 e5                	mov    %esp,%ebp
  if(!uart)
801063f9:	85 d2                	test   %edx,%edx
{
801063fb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801063fe:	74 10                	je     80106410 <uartputc+0x20>
}
80106400:	5d                   	pop    %ebp
80106401:	e9 da fe ff ff       	jmp    801062e0 <uartputc.part.0>
80106406:	8d 76 00             	lea    0x0(%esi),%esi
80106409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106410:	5d                   	pop    %ebp
80106411:	c3                   	ret    
80106412:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106420 <uartintr>:

void
uartintr(void)
{
80106420:	55                   	push   %ebp
80106421:	89 e5                	mov    %esp,%ebp
80106423:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106426:	68 b0 62 10 80       	push   $0x801062b0
8010642b:	e8 e0 a3 ff ff       	call   80100810 <consoleintr>
}
80106430:	83 c4 10             	add    $0x10,%esp
80106433:	c9                   	leave  
80106434:	c3                   	ret    

80106435 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106435:	6a 00                	push   $0x0
  pushl $0
80106437:	6a 00                	push   $0x0
  jmp alltraps
80106439:	e9 19 fb ff ff       	jmp    80105f57 <alltraps>

8010643e <vector1>:
.globl vector1
vector1:
  pushl $0
8010643e:	6a 00                	push   $0x0
  pushl $1
80106440:	6a 01                	push   $0x1
  jmp alltraps
80106442:	e9 10 fb ff ff       	jmp    80105f57 <alltraps>

80106447 <vector2>:
.globl vector2
vector2:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $2
80106449:	6a 02                	push   $0x2
  jmp alltraps
8010644b:	e9 07 fb ff ff       	jmp    80105f57 <alltraps>

80106450 <vector3>:
.globl vector3
vector3:
  pushl $0
80106450:	6a 00                	push   $0x0
  pushl $3
80106452:	6a 03                	push   $0x3
  jmp alltraps
80106454:	e9 fe fa ff ff       	jmp    80105f57 <alltraps>

80106459 <vector4>:
.globl vector4
vector4:
  pushl $0
80106459:	6a 00                	push   $0x0
  pushl $4
8010645b:	6a 04                	push   $0x4
  jmp alltraps
8010645d:	e9 f5 fa ff ff       	jmp    80105f57 <alltraps>

80106462 <vector5>:
.globl vector5
vector5:
  pushl $0
80106462:	6a 00                	push   $0x0
  pushl $5
80106464:	6a 05                	push   $0x5
  jmp alltraps
80106466:	e9 ec fa ff ff       	jmp    80105f57 <alltraps>

8010646b <vector6>:
.globl vector6
vector6:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $6
8010646d:	6a 06                	push   $0x6
  jmp alltraps
8010646f:	e9 e3 fa ff ff       	jmp    80105f57 <alltraps>

80106474 <vector7>:
.globl vector7
vector7:
  pushl $0
80106474:	6a 00                	push   $0x0
  pushl $7
80106476:	6a 07                	push   $0x7
  jmp alltraps
80106478:	e9 da fa ff ff       	jmp    80105f57 <alltraps>

8010647d <vector8>:
.globl vector8
vector8:
  pushl $8
8010647d:	6a 08                	push   $0x8
  jmp alltraps
8010647f:	e9 d3 fa ff ff       	jmp    80105f57 <alltraps>

80106484 <vector9>:
.globl vector9
vector9:
  pushl $0
80106484:	6a 00                	push   $0x0
  pushl $9
80106486:	6a 09                	push   $0x9
  jmp alltraps
80106488:	e9 ca fa ff ff       	jmp    80105f57 <alltraps>

8010648d <vector10>:
.globl vector10
vector10:
  pushl $10
8010648d:	6a 0a                	push   $0xa
  jmp alltraps
8010648f:	e9 c3 fa ff ff       	jmp    80105f57 <alltraps>

80106494 <vector11>:
.globl vector11
vector11:
  pushl $11
80106494:	6a 0b                	push   $0xb
  jmp alltraps
80106496:	e9 bc fa ff ff       	jmp    80105f57 <alltraps>

8010649b <vector12>:
.globl vector12
vector12:
  pushl $12
8010649b:	6a 0c                	push   $0xc
  jmp alltraps
8010649d:	e9 b5 fa ff ff       	jmp    80105f57 <alltraps>

801064a2 <vector13>:
.globl vector13
vector13:
  pushl $13
801064a2:	6a 0d                	push   $0xd
  jmp alltraps
801064a4:	e9 ae fa ff ff       	jmp    80105f57 <alltraps>

801064a9 <vector14>:
.globl vector14
vector14:
  pushl $14
801064a9:	6a 0e                	push   $0xe
  jmp alltraps
801064ab:	e9 a7 fa ff ff       	jmp    80105f57 <alltraps>

801064b0 <vector15>:
.globl vector15
vector15:
  pushl $0
801064b0:	6a 00                	push   $0x0
  pushl $15
801064b2:	6a 0f                	push   $0xf
  jmp alltraps
801064b4:	e9 9e fa ff ff       	jmp    80105f57 <alltraps>

801064b9 <vector16>:
.globl vector16
vector16:
  pushl $0
801064b9:	6a 00                	push   $0x0
  pushl $16
801064bb:	6a 10                	push   $0x10
  jmp alltraps
801064bd:	e9 95 fa ff ff       	jmp    80105f57 <alltraps>

801064c2 <vector17>:
.globl vector17
vector17:
  pushl $17
801064c2:	6a 11                	push   $0x11
  jmp alltraps
801064c4:	e9 8e fa ff ff       	jmp    80105f57 <alltraps>

801064c9 <vector18>:
.globl vector18
vector18:
  pushl $0
801064c9:	6a 00                	push   $0x0
  pushl $18
801064cb:	6a 12                	push   $0x12
  jmp alltraps
801064cd:	e9 85 fa ff ff       	jmp    80105f57 <alltraps>

801064d2 <vector19>:
.globl vector19
vector19:
  pushl $0
801064d2:	6a 00                	push   $0x0
  pushl $19
801064d4:	6a 13                	push   $0x13
  jmp alltraps
801064d6:	e9 7c fa ff ff       	jmp    80105f57 <alltraps>

801064db <vector20>:
.globl vector20
vector20:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $20
801064dd:	6a 14                	push   $0x14
  jmp alltraps
801064df:	e9 73 fa ff ff       	jmp    80105f57 <alltraps>

801064e4 <vector21>:
.globl vector21
vector21:
  pushl $0
801064e4:	6a 00                	push   $0x0
  pushl $21
801064e6:	6a 15                	push   $0x15
  jmp alltraps
801064e8:	e9 6a fa ff ff       	jmp    80105f57 <alltraps>

801064ed <vector22>:
.globl vector22
vector22:
  pushl $0
801064ed:	6a 00                	push   $0x0
  pushl $22
801064ef:	6a 16                	push   $0x16
  jmp alltraps
801064f1:	e9 61 fa ff ff       	jmp    80105f57 <alltraps>

801064f6 <vector23>:
.globl vector23
vector23:
  pushl $0
801064f6:	6a 00                	push   $0x0
  pushl $23
801064f8:	6a 17                	push   $0x17
  jmp alltraps
801064fa:	e9 58 fa ff ff       	jmp    80105f57 <alltraps>

801064ff <vector24>:
.globl vector24
vector24:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $24
80106501:	6a 18                	push   $0x18
  jmp alltraps
80106503:	e9 4f fa ff ff       	jmp    80105f57 <alltraps>

80106508 <vector25>:
.globl vector25
vector25:
  pushl $0
80106508:	6a 00                	push   $0x0
  pushl $25
8010650a:	6a 19                	push   $0x19
  jmp alltraps
8010650c:	e9 46 fa ff ff       	jmp    80105f57 <alltraps>

80106511 <vector26>:
.globl vector26
vector26:
  pushl $0
80106511:	6a 00                	push   $0x0
  pushl $26
80106513:	6a 1a                	push   $0x1a
  jmp alltraps
80106515:	e9 3d fa ff ff       	jmp    80105f57 <alltraps>

8010651a <vector27>:
.globl vector27
vector27:
  pushl $0
8010651a:	6a 00                	push   $0x0
  pushl $27
8010651c:	6a 1b                	push   $0x1b
  jmp alltraps
8010651e:	e9 34 fa ff ff       	jmp    80105f57 <alltraps>

80106523 <vector28>:
.globl vector28
vector28:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $28
80106525:	6a 1c                	push   $0x1c
  jmp alltraps
80106527:	e9 2b fa ff ff       	jmp    80105f57 <alltraps>

8010652c <vector29>:
.globl vector29
vector29:
  pushl $0
8010652c:	6a 00                	push   $0x0
  pushl $29
8010652e:	6a 1d                	push   $0x1d
  jmp alltraps
80106530:	e9 22 fa ff ff       	jmp    80105f57 <alltraps>

80106535 <vector30>:
.globl vector30
vector30:
  pushl $0
80106535:	6a 00                	push   $0x0
  pushl $30
80106537:	6a 1e                	push   $0x1e
  jmp alltraps
80106539:	e9 19 fa ff ff       	jmp    80105f57 <alltraps>

8010653e <vector31>:
.globl vector31
vector31:
  pushl $0
8010653e:	6a 00                	push   $0x0
  pushl $31
80106540:	6a 1f                	push   $0x1f
  jmp alltraps
80106542:	e9 10 fa ff ff       	jmp    80105f57 <alltraps>

80106547 <vector32>:
.globl vector32
vector32:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $32
80106549:	6a 20                	push   $0x20
  jmp alltraps
8010654b:	e9 07 fa ff ff       	jmp    80105f57 <alltraps>

80106550 <vector33>:
.globl vector33
vector33:
  pushl $0
80106550:	6a 00                	push   $0x0
  pushl $33
80106552:	6a 21                	push   $0x21
  jmp alltraps
80106554:	e9 fe f9 ff ff       	jmp    80105f57 <alltraps>

80106559 <vector34>:
.globl vector34
vector34:
  pushl $0
80106559:	6a 00                	push   $0x0
  pushl $34
8010655b:	6a 22                	push   $0x22
  jmp alltraps
8010655d:	e9 f5 f9 ff ff       	jmp    80105f57 <alltraps>

80106562 <vector35>:
.globl vector35
vector35:
  pushl $0
80106562:	6a 00                	push   $0x0
  pushl $35
80106564:	6a 23                	push   $0x23
  jmp alltraps
80106566:	e9 ec f9 ff ff       	jmp    80105f57 <alltraps>

8010656b <vector36>:
.globl vector36
vector36:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $36
8010656d:	6a 24                	push   $0x24
  jmp alltraps
8010656f:	e9 e3 f9 ff ff       	jmp    80105f57 <alltraps>

80106574 <vector37>:
.globl vector37
vector37:
  pushl $0
80106574:	6a 00                	push   $0x0
  pushl $37
80106576:	6a 25                	push   $0x25
  jmp alltraps
80106578:	e9 da f9 ff ff       	jmp    80105f57 <alltraps>

8010657d <vector38>:
.globl vector38
vector38:
  pushl $0
8010657d:	6a 00                	push   $0x0
  pushl $38
8010657f:	6a 26                	push   $0x26
  jmp alltraps
80106581:	e9 d1 f9 ff ff       	jmp    80105f57 <alltraps>

80106586 <vector39>:
.globl vector39
vector39:
  pushl $0
80106586:	6a 00                	push   $0x0
  pushl $39
80106588:	6a 27                	push   $0x27
  jmp alltraps
8010658a:	e9 c8 f9 ff ff       	jmp    80105f57 <alltraps>

8010658f <vector40>:
.globl vector40
vector40:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $40
80106591:	6a 28                	push   $0x28
  jmp alltraps
80106593:	e9 bf f9 ff ff       	jmp    80105f57 <alltraps>

80106598 <vector41>:
.globl vector41
vector41:
  pushl $0
80106598:	6a 00                	push   $0x0
  pushl $41
8010659a:	6a 29                	push   $0x29
  jmp alltraps
8010659c:	e9 b6 f9 ff ff       	jmp    80105f57 <alltraps>

801065a1 <vector42>:
.globl vector42
vector42:
  pushl $0
801065a1:	6a 00                	push   $0x0
  pushl $42
801065a3:	6a 2a                	push   $0x2a
  jmp alltraps
801065a5:	e9 ad f9 ff ff       	jmp    80105f57 <alltraps>

801065aa <vector43>:
.globl vector43
vector43:
  pushl $0
801065aa:	6a 00                	push   $0x0
  pushl $43
801065ac:	6a 2b                	push   $0x2b
  jmp alltraps
801065ae:	e9 a4 f9 ff ff       	jmp    80105f57 <alltraps>

801065b3 <vector44>:
.globl vector44
vector44:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $44
801065b5:	6a 2c                	push   $0x2c
  jmp alltraps
801065b7:	e9 9b f9 ff ff       	jmp    80105f57 <alltraps>

801065bc <vector45>:
.globl vector45
vector45:
  pushl $0
801065bc:	6a 00                	push   $0x0
  pushl $45
801065be:	6a 2d                	push   $0x2d
  jmp alltraps
801065c0:	e9 92 f9 ff ff       	jmp    80105f57 <alltraps>

801065c5 <vector46>:
.globl vector46
vector46:
  pushl $0
801065c5:	6a 00                	push   $0x0
  pushl $46
801065c7:	6a 2e                	push   $0x2e
  jmp alltraps
801065c9:	e9 89 f9 ff ff       	jmp    80105f57 <alltraps>

801065ce <vector47>:
.globl vector47
vector47:
  pushl $0
801065ce:	6a 00                	push   $0x0
  pushl $47
801065d0:	6a 2f                	push   $0x2f
  jmp alltraps
801065d2:	e9 80 f9 ff ff       	jmp    80105f57 <alltraps>

801065d7 <vector48>:
.globl vector48
vector48:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $48
801065d9:	6a 30                	push   $0x30
  jmp alltraps
801065db:	e9 77 f9 ff ff       	jmp    80105f57 <alltraps>

801065e0 <vector49>:
.globl vector49
vector49:
  pushl $0
801065e0:	6a 00                	push   $0x0
  pushl $49
801065e2:	6a 31                	push   $0x31
  jmp alltraps
801065e4:	e9 6e f9 ff ff       	jmp    80105f57 <alltraps>

801065e9 <vector50>:
.globl vector50
vector50:
  pushl $0
801065e9:	6a 00                	push   $0x0
  pushl $50
801065eb:	6a 32                	push   $0x32
  jmp alltraps
801065ed:	e9 65 f9 ff ff       	jmp    80105f57 <alltraps>

801065f2 <vector51>:
.globl vector51
vector51:
  pushl $0
801065f2:	6a 00                	push   $0x0
  pushl $51
801065f4:	6a 33                	push   $0x33
  jmp alltraps
801065f6:	e9 5c f9 ff ff       	jmp    80105f57 <alltraps>

801065fb <vector52>:
.globl vector52
vector52:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $52
801065fd:	6a 34                	push   $0x34
  jmp alltraps
801065ff:	e9 53 f9 ff ff       	jmp    80105f57 <alltraps>

80106604 <vector53>:
.globl vector53
vector53:
  pushl $0
80106604:	6a 00                	push   $0x0
  pushl $53
80106606:	6a 35                	push   $0x35
  jmp alltraps
80106608:	e9 4a f9 ff ff       	jmp    80105f57 <alltraps>

8010660d <vector54>:
.globl vector54
vector54:
  pushl $0
8010660d:	6a 00                	push   $0x0
  pushl $54
8010660f:	6a 36                	push   $0x36
  jmp alltraps
80106611:	e9 41 f9 ff ff       	jmp    80105f57 <alltraps>

80106616 <vector55>:
.globl vector55
vector55:
  pushl $0
80106616:	6a 00                	push   $0x0
  pushl $55
80106618:	6a 37                	push   $0x37
  jmp alltraps
8010661a:	e9 38 f9 ff ff       	jmp    80105f57 <alltraps>

8010661f <vector56>:
.globl vector56
vector56:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $56
80106621:	6a 38                	push   $0x38
  jmp alltraps
80106623:	e9 2f f9 ff ff       	jmp    80105f57 <alltraps>

80106628 <vector57>:
.globl vector57
vector57:
  pushl $0
80106628:	6a 00                	push   $0x0
  pushl $57
8010662a:	6a 39                	push   $0x39
  jmp alltraps
8010662c:	e9 26 f9 ff ff       	jmp    80105f57 <alltraps>

80106631 <vector58>:
.globl vector58
vector58:
  pushl $0
80106631:	6a 00                	push   $0x0
  pushl $58
80106633:	6a 3a                	push   $0x3a
  jmp alltraps
80106635:	e9 1d f9 ff ff       	jmp    80105f57 <alltraps>

8010663a <vector59>:
.globl vector59
vector59:
  pushl $0
8010663a:	6a 00                	push   $0x0
  pushl $59
8010663c:	6a 3b                	push   $0x3b
  jmp alltraps
8010663e:	e9 14 f9 ff ff       	jmp    80105f57 <alltraps>

80106643 <vector60>:
.globl vector60
vector60:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $60
80106645:	6a 3c                	push   $0x3c
  jmp alltraps
80106647:	e9 0b f9 ff ff       	jmp    80105f57 <alltraps>

8010664c <vector61>:
.globl vector61
vector61:
  pushl $0
8010664c:	6a 00                	push   $0x0
  pushl $61
8010664e:	6a 3d                	push   $0x3d
  jmp alltraps
80106650:	e9 02 f9 ff ff       	jmp    80105f57 <alltraps>

80106655 <vector62>:
.globl vector62
vector62:
  pushl $0
80106655:	6a 00                	push   $0x0
  pushl $62
80106657:	6a 3e                	push   $0x3e
  jmp alltraps
80106659:	e9 f9 f8 ff ff       	jmp    80105f57 <alltraps>

8010665e <vector63>:
.globl vector63
vector63:
  pushl $0
8010665e:	6a 00                	push   $0x0
  pushl $63
80106660:	6a 3f                	push   $0x3f
  jmp alltraps
80106662:	e9 f0 f8 ff ff       	jmp    80105f57 <alltraps>

80106667 <vector64>:
.globl vector64
vector64:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $64
80106669:	6a 40                	push   $0x40
  jmp alltraps
8010666b:	e9 e7 f8 ff ff       	jmp    80105f57 <alltraps>

80106670 <vector65>:
.globl vector65
vector65:
  pushl $0
80106670:	6a 00                	push   $0x0
  pushl $65
80106672:	6a 41                	push   $0x41
  jmp alltraps
80106674:	e9 de f8 ff ff       	jmp    80105f57 <alltraps>

80106679 <vector66>:
.globl vector66
vector66:
  pushl $0
80106679:	6a 00                	push   $0x0
  pushl $66
8010667b:	6a 42                	push   $0x42
  jmp alltraps
8010667d:	e9 d5 f8 ff ff       	jmp    80105f57 <alltraps>

80106682 <vector67>:
.globl vector67
vector67:
  pushl $0
80106682:	6a 00                	push   $0x0
  pushl $67
80106684:	6a 43                	push   $0x43
  jmp alltraps
80106686:	e9 cc f8 ff ff       	jmp    80105f57 <alltraps>

8010668b <vector68>:
.globl vector68
vector68:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $68
8010668d:	6a 44                	push   $0x44
  jmp alltraps
8010668f:	e9 c3 f8 ff ff       	jmp    80105f57 <alltraps>

80106694 <vector69>:
.globl vector69
vector69:
  pushl $0
80106694:	6a 00                	push   $0x0
  pushl $69
80106696:	6a 45                	push   $0x45
  jmp alltraps
80106698:	e9 ba f8 ff ff       	jmp    80105f57 <alltraps>

8010669d <vector70>:
.globl vector70
vector70:
  pushl $0
8010669d:	6a 00                	push   $0x0
  pushl $70
8010669f:	6a 46                	push   $0x46
  jmp alltraps
801066a1:	e9 b1 f8 ff ff       	jmp    80105f57 <alltraps>

801066a6 <vector71>:
.globl vector71
vector71:
  pushl $0
801066a6:	6a 00                	push   $0x0
  pushl $71
801066a8:	6a 47                	push   $0x47
  jmp alltraps
801066aa:	e9 a8 f8 ff ff       	jmp    80105f57 <alltraps>

801066af <vector72>:
.globl vector72
vector72:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $72
801066b1:	6a 48                	push   $0x48
  jmp alltraps
801066b3:	e9 9f f8 ff ff       	jmp    80105f57 <alltraps>

801066b8 <vector73>:
.globl vector73
vector73:
  pushl $0
801066b8:	6a 00                	push   $0x0
  pushl $73
801066ba:	6a 49                	push   $0x49
  jmp alltraps
801066bc:	e9 96 f8 ff ff       	jmp    80105f57 <alltraps>

801066c1 <vector74>:
.globl vector74
vector74:
  pushl $0
801066c1:	6a 00                	push   $0x0
  pushl $74
801066c3:	6a 4a                	push   $0x4a
  jmp alltraps
801066c5:	e9 8d f8 ff ff       	jmp    80105f57 <alltraps>

801066ca <vector75>:
.globl vector75
vector75:
  pushl $0
801066ca:	6a 00                	push   $0x0
  pushl $75
801066cc:	6a 4b                	push   $0x4b
  jmp alltraps
801066ce:	e9 84 f8 ff ff       	jmp    80105f57 <alltraps>

801066d3 <vector76>:
.globl vector76
vector76:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $76
801066d5:	6a 4c                	push   $0x4c
  jmp alltraps
801066d7:	e9 7b f8 ff ff       	jmp    80105f57 <alltraps>

801066dc <vector77>:
.globl vector77
vector77:
  pushl $0
801066dc:	6a 00                	push   $0x0
  pushl $77
801066de:	6a 4d                	push   $0x4d
  jmp alltraps
801066e0:	e9 72 f8 ff ff       	jmp    80105f57 <alltraps>

801066e5 <vector78>:
.globl vector78
vector78:
  pushl $0
801066e5:	6a 00                	push   $0x0
  pushl $78
801066e7:	6a 4e                	push   $0x4e
  jmp alltraps
801066e9:	e9 69 f8 ff ff       	jmp    80105f57 <alltraps>

801066ee <vector79>:
.globl vector79
vector79:
  pushl $0
801066ee:	6a 00                	push   $0x0
  pushl $79
801066f0:	6a 4f                	push   $0x4f
  jmp alltraps
801066f2:	e9 60 f8 ff ff       	jmp    80105f57 <alltraps>

801066f7 <vector80>:
.globl vector80
vector80:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $80
801066f9:	6a 50                	push   $0x50
  jmp alltraps
801066fb:	e9 57 f8 ff ff       	jmp    80105f57 <alltraps>

80106700 <vector81>:
.globl vector81
vector81:
  pushl $0
80106700:	6a 00                	push   $0x0
  pushl $81
80106702:	6a 51                	push   $0x51
  jmp alltraps
80106704:	e9 4e f8 ff ff       	jmp    80105f57 <alltraps>

80106709 <vector82>:
.globl vector82
vector82:
  pushl $0
80106709:	6a 00                	push   $0x0
  pushl $82
8010670b:	6a 52                	push   $0x52
  jmp alltraps
8010670d:	e9 45 f8 ff ff       	jmp    80105f57 <alltraps>

80106712 <vector83>:
.globl vector83
vector83:
  pushl $0
80106712:	6a 00                	push   $0x0
  pushl $83
80106714:	6a 53                	push   $0x53
  jmp alltraps
80106716:	e9 3c f8 ff ff       	jmp    80105f57 <alltraps>

8010671b <vector84>:
.globl vector84
vector84:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $84
8010671d:	6a 54                	push   $0x54
  jmp alltraps
8010671f:	e9 33 f8 ff ff       	jmp    80105f57 <alltraps>

80106724 <vector85>:
.globl vector85
vector85:
  pushl $0
80106724:	6a 00                	push   $0x0
  pushl $85
80106726:	6a 55                	push   $0x55
  jmp alltraps
80106728:	e9 2a f8 ff ff       	jmp    80105f57 <alltraps>

8010672d <vector86>:
.globl vector86
vector86:
  pushl $0
8010672d:	6a 00                	push   $0x0
  pushl $86
8010672f:	6a 56                	push   $0x56
  jmp alltraps
80106731:	e9 21 f8 ff ff       	jmp    80105f57 <alltraps>

80106736 <vector87>:
.globl vector87
vector87:
  pushl $0
80106736:	6a 00                	push   $0x0
  pushl $87
80106738:	6a 57                	push   $0x57
  jmp alltraps
8010673a:	e9 18 f8 ff ff       	jmp    80105f57 <alltraps>

8010673f <vector88>:
.globl vector88
vector88:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $88
80106741:	6a 58                	push   $0x58
  jmp alltraps
80106743:	e9 0f f8 ff ff       	jmp    80105f57 <alltraps>

80106748 <vector89>:
.globl vector89
vector89:
  pushl $0
80106748:	6a 00                	push   $0x0
  pushl $89
8010674a:	6a 59                	push   $0x59
  jmp alltraps
8010674c:	e9 06 f8 ff ff       	jmp    80105f57 <alltraps>

80106751 <vector90>:
.globl vector90
vector90:
  pushl $0
80106751:	6a 00                	push   $0x0
  pushl $90
80106753:	6a 5a                	push   $0x5a
  jmp alltraps
80106755:	e9 fd f7 ff ff       	jmp    80105f57 <alltraps>

8010675a <vector91>:
.globl vector91
vector91:
  pushl $0
8010675a:	6a 00                	push   $0x0
  pushl $91
8010675c:	6a 5b                	push   $0x5b
  jmp alltraps
8010675e:	e9 f4 f7 ff ff       	jmp    80105f57 <alltraps>

80106763 <vector92>:
.globl vector92
vector92:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $92
80106765:	6a 5c                	push   $0x5c
  jmp alltraps
80106767:	e9 eb f7 ff ff       	jmp    80105f57 <alltraps>

8010676c <vector93>:
.globl vector93
vector93:
  pushl $0
8010676c:	6a 00                	push   $0x0
  pushl $93
8010676e:	6a 5d                	push   $0x5d
  jmp alltraps
80106770:	e9 e2 f7 ff ff       	jmp    80105f57 <alltraps>

80106775 <vector94>:
.globl vector94
vector94:
  pushl $0
80106775:	6a 00                	push   $0x0
  pushl $94
80106777:	6a 5e                	push   $0x5e
  jmp alltraps
80106779:	e9 d9 f7 ff ff       	jmp    80105f57 <alltraps>

8010677e <vector95>:
.globl vector95
vector95:
  pushl $0
8010677e:	6a 00                	push   $0x0
  pushl $95
80106780:	6a 5f                	push   $0x5f
  jmp alltraps
80106782:	e9 d0 f7 ff ff       	jmp    80105f57 <alltraps>

80106787 <vector96>:
.globl vector96
vector96:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $96
80106789:	6a 60                	push   $0x60
  jmp alltraps
8010678b:	e9 c7 f7 ff ff       	jmp    80105f57 <alltraps>

80106790 <vector97>:
.globl vector97
vector97:
  pushl $0
80106790:	6a 00                	push   $0x0
  pushl $97
80106792:	6a 61                	push   $0x61
  jmp alltraps
80106794:	e9 be f7 ff ff       	jmp    80105f57 <alltraps>

80106799 <vector98>:
.globl vector98
vector98:
  pushl $0
80106799:	6a 00                	push   $0x0
  pushl $98
8010679b:	6a 62                	push   $0x62
  jmp alltraps
8010679d:	e9 b5 f7 ff ff       	jmp    80105f57 <alltraps>

801067a2 <vector99>:
.globl vector99
vector99:
  pushl $0
801067a2:	6a 00                	push   $0x0
  pushl $99
801067a4:	6a 63                	push   $0x63
  jmp alltraps
801067a6:	e9 ac f7 ff ff       	jmp    80105f57 <alltraps>

801067ab <vector100>:
.globl vector100
vector100:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $100
801067ad:	6a 64                	push   $0x64
  jmp alltraps
801067af:	e9 a3 f7 ff ff       	jmp    80105f57 <alltraps>

801067b4 <vector101>:
.globl vector101
vector101:
  pushl $0
801067b4:	6a 00                	push   $0x0
  pushl $101
801067b6:	6a 65                	push   $0x65
  jmp alltraps
801067b8:	e9 9a f7 ff ff       	jmp    80105f57 <alltraps>

801067bd <vector102>:
.globl vector102
vector102:
  pushl $0
801067bd:	6a 00                	push   $0x0
  pushl $102
801067bf:	6a 66                	push   $0x66
  jmp alltraps
801067c1:	e9 91 f7 ff ff       	jmp    80105f57 <alltraps>

801067c6 <vector103>:
.globl vector103
vector103:
  pushl $0
801067c6:	6a 00                	push   $0x0
  pushl $103
801067c8:	6a 67                	push   $0x67
  jmp alltraps
801067ca:	e9 88 f7 ff ff       	jmp    80105f57 <alltraps>

801067cf <vector104>:
.globl vector104
vector104:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $104
801067d1:	6a 68                	push   $0x68
  jmp alltraps
801067d3:	e9 7f f7 ff ff       	jmp    80105f57 <alltraps>

801067d8 <vector105>:
.globl vector105
vector105:
  pushl $0
801067d8:	6a 00                	push   $0x0
  pushl $105
801067da:	6a 69                	push   $0x69
  jmp alltraps
801067dc:	e9 76 f7 ff ff       	jmp    80105f57 <alltraps>

801067e1 <vector106>:
.globl vector106
vector106:
  pushl $0
801067e1:	6a 00                	push   $0x0
  pushl $106
801067e3:	6a 6a                	push   $0x6a
  jmp alltraps
801067e5:	e9 6d f7 ff ff       	jmp    80105f57 <alltraps>

801067ea <vector107>:
.globl vector107
vector107:
  pushl $0
801067ea:	6a 00                	push   $0x0
  pushl $107
801067ec:	6a 6b                	push   $0x6b
  jmp alltraps
801067ee:	e9 64 f7 ff ff       	jmp    80105f57 <alltraps>

801067f3 <vector108>:
.globl vector108
vector108:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $108
801067f5:	6a 6c                	push   $0x6c
  jmp alltraps
801067f7:	e9 5b f7 ff ff       	jmp    80105f57 <alltraps>

801067fc <vector109>:
.globl vector109
vector109:
  pushl $0
801067fc:	6a 00                	push   $0x0
  pushl $109
801067fe:	6a 6d                	push   $0x6d
  jmp alltraps
80106800:	e9 52 f7 ff ff       	jmp    80105f57 <alltraps>

80106805 <vector110>:
.globl vector110
vector110:
  pushl $0
80106805:	6a 00                	push   $0x0
  pushl $110
80106807:	6a 6e                	push   $0x6e
  jmp alltraps
80106809:	e9 49 f7 ff ff       	jmp    80105f57 <alltraps>

8010680e <vector111>:
.globl vector111
vector111:
  pushl $0
8010680e:	6a 00                	push   $0x0
  pushl $111
80106810:	6a 6f                	push   $0x6f
  jmp alltraps
80106812:	e9 40 f7 ff ff       	jmp    80105f57 <alltraps>

80106817 <vector112>:
.globl vector112
vector112:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $112
80106819:	6a 70                	push   $0x70
  jmp alltraps
8010681b:	e9 37 f7 ff ff       	jmp    80105f57 <alltraps>

80106820 <vector113>:
.globl vector113
vector113:
  pushl $0
80106820:	6a 00                	push   $0x0
  pushl $113
80106822:	6a 71                	push   $0x71
  jmp alltraps
80106824:	e9 2e f7 ff ff       	jmp    80105f57 <alltraps>

80106829 <vector114>:
.globl vector114
vector114:
  pushl $0
80106829:	6a 00                	push   $0x0
  pushl $114
8010682b:	6a 72                	push   $0x72
  jmp alltraps
8010682d:	e9 25 f7 ff ff       	jmp    80105f57 <alltraps>

80106832 <vector115>:
.globl vector115
vector115:
  pushl $0
80106832:	6a 00                	push   $0x0
  pushl $115
80106834:	6a 73                	push   $0x73
  jmp alltraps
80106836:	e9 1c f7 ff ff       	jmp    80105f57 <alltraps>

8010683b <vector116>:
.globl vector116
vector116:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $116
8010683d:	6a 74                	push   $0x74
  jmp alltraps
8010683f:	e9 13 f7 ff ff       	jmp    80105f57 <alltraps>

80106844 <vector117>:
.globl vector117
vector117:
  pushl $0
80106844:	6a 00                	push   $0x0
  pushl $117
80106846:	6a 75                	push   $0x75
  jmp alltraps
80106848:	e9 0a f7 ff ff       	jmp    80105f57 <alltraps>

8010684d <vector118>:
.globl vector118
vector118:
  pushl $0
8010684d:	6a 00                	push   $0x0
  pushl $118
8010684f:	6a 76                	push   $0x76
  jmp alltraps
80106851:	e9 01 f7 ff ff       	jmp    80105f57 <alltraps>

80106856 <vector119>:
.globl vector119
vector119:
  pushl $0
80106856:	6a 00                	push   $0x0
  pushl $119
80106858:	6a 77                	push   $0x77
  jmp alltraps
8010685a:	e9 f8 f6 ff ff       	jmp    80105f57 <alltraps>

8010685f <vector120>:
.globl vector120
vector120:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $120
80106861:	6a 78                	push   $0x78
  jmp alltraps
80106863:	e9 ef f6 ff ff       	jmp    80105f57 <alltraps>

80106868 <vector121>:
.globl vector121
vector121:
  pushl $0
80106868:	6a 00                	push   $0x0
  pushl $121
8010686a:	6a 79                	push   $0x79
  jmp alltraps
8010686c:	e9 e6 f6 ff ff       	jmp    80105f57 <alltraps>

80106871 <vector122>:
.globl vector122
vector122:
  pushl $0
80106871:	6a 00                	push   $0x0
  pushl $122
80106873:	6a 7a                	push   $0x7a
  jmp alltraps
80106875:	e9 dd f6 ff ff       	jmp    80105f57 <alltraps>

8010687a <vector123>:
.globl vector123
vector123:
  pushl $0
8010687a:	6a 00                	push   $0x0
  pushl $123
8010687c:	6a 7b                	push   $0x7b
  jmp alltraps
8010687e:	e9 d4 f6 ff ff       	jmp    80105f57 <alltraps>

80106883 <vector124>:
.globl vector124
vector124:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $124
80106885:	6a 7c                	push   $0x7c
  jmp alltraps
80106887:	e9 cb f6 ff ff       	jmp    80105f57 <alltraps>

8010688c <vector125>:
.globl vector125
vector125:
  pushl $0
8010688c:	6a 00                	push   $0x0
  pushl $125
8010688e:	6a 7d                	push   $0x7d
  jmp alltraps
80106890:	e9 c2 f6 ff ff       	jmp    80105f57 <alltraps>

80106895 <vector126>:
.globl vector126
vector126:
  pushl $0
80106895:	6a 00                	push   $0x0
  pushl $126
80106897:	6a 7e                	push   $0x7e
  jmp alltraps
80106899:	e9 b9 f6 ff ff       	jmp    80105f57 <alltraps>

8010689e <vector127>:
.globl vector127
vector127:
  pushl $0
8010689e:	6a 00                	push   $0x0
  pushl $127
801068a0:	6a 7f                	push   $0x7f
  jmp alltraps
801068a2:	e9 b0 f6 ff ff       	jmp    80105f57 <alltraps>

801068a7 <vector128>:
.globl vector128
vector128:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $128
801068a9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801068ae:	e9 a4 f6 ff ff       	jmp    80105f57 <alltraps>

801068b3 <vector129>:
.globl vector129
vector129:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $129
801068b5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801068ba:	e9 98 f6 ff ff       	jmp    80105f57 <alltraps>

801068bf <vector130>:
.globl vector130
vector130:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $130
801068c1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801068c6:	e9 8c f6 ff ff       	jmp    80105f57 <alltraps>

801068cb <vector131>:
.globl vector131
vector131:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $131
801068cd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801068d2:	e9 80 f6 ff ff       	jmp    80105f57 <alltraps>

801068d7 <vector132>:
.globl vector132
vector132:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $132
801068d9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801068de:	e9 74 f6 ff ff       	jmp    80105f57 <alltraps>

801068e3 <vector133>:
.globl vector133
vector133:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $133
801068e5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801068ea:	e9 68 f6 ff ff       	jmp    80105f57 <alltraps>

801068ef <vector134>:
.globl vector134
vector134:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $134
801068f1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801068f6:	e9 5c f6 ff ff       	jmp    80105f57 <alltraps>

801068fb <vector135>:
.globl vector135
vector135:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $135
801068fd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106902:	e9 50 f6 ff ff       	jmp    80105f57 <alltraps>

80106907 <vector136>:
.globl vector136
vector136:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $136
80106909:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010690e:	e9 44 f6 ff ff       	jmp    80105f57 <alltraps>

80106913 <vector137>:
.globl vector137
vector137:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $137
80106915:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010691a:	e9 38 f6 ff ff       	jmp    80105f57 <alltraps>

8010691f <vector138>:
.globl vector138
vector138:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $138
80106921:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106926:	e9 2c f6 ff ff       	jmp    80105f57 <alltraps>

8010692b <vector139>:
.globl vector139
vector139:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $139
8010692d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106932:	e9 20 f6 ff ff       	jmp    80105f57 <alltraps>

80106937 <vector140>:
.globl vector140
vector140:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $140
80106939:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010693e:	e9 14 f6 ff ff       	jmp    80105f57 <alltraps>

80106943 <vector141>:
.globl vector141
vector141:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $141
80106945:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010694a:	e9 08 f6 ff ff       	jmp    80105f57 <alltraps>

8010694f <vector142>:
.globl vector142
vector142:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $142
80106951:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106956:	e9 fc f5 ff ff       	jmp    80105f57 <alltraps>

8010695b <vector143>:
.globl vector143
vector143:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $143
8010695d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106962:	e9 f0 f5 ff ff       	jmp    80105f57 <alltraps>

80106967 <vector144>:
.globl vector144
vector144:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $144
80106969:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010696e:	e9 e4 f5 ff ff       	jmp    80105f57 <alltraps>

80106973 <vector145>:
.globl vector145
vector145:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $145
80106975:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010697a:	e9 d8 f5 ff ff       	jmp    80105f57 <alltraps>

8010697f <vector146>:
.globl vector146
vector146:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $146
80106981:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106986:	e9 cc f5 ff ff       	jmp    80105f57 <alltraps>

8010698b <vector147>:
.globl vector147
vector147:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $147
8010698d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106992:	e9 c0 f5 ff ff       	jmp    80105f57 <alltraps>

80106997 <vector148>:
.globl vector148
vector148:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $148
80106999:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010699e:	e9 b4 f5 ff ff       	jmp    80105f57 <alltraps>

801069a3 <vector149>:
.globl vector149
vector149:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $149
801069a5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801069aa:	e9 a8 f5 ff ff       	jmp    80105f57 <alltraps>

801069af <vector150>:
.globl vector150
vector150:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $150
801069b1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801069b6:	e9 9c f5 ff ff       	jmp    80105f57 <alltraps>

801069bb <vector151>:
.globl vector151
vector151:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $151
801069bd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801069c2:	e9 90 f5 ff ff       	jmp    80105f57 <alltraps>

801069c7 <vector152>:
.globl vector152
vector152:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $152
801069c9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801069ce:	e9 84 f5 ff ff       	jmp    80105f57 <alltraps>

801069d3 <vector153>:
.globl vector153
vector153:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $153
801069d5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801069da:	e9 78 f5 ff ff       	jmp    80105f57 <alltraps>

801069df <vector154>:
.globl vector154
vector154:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $154
801069e1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801069e6:	e9 6c f5 ff ff       	jmp    80105f57 <alltraps>

801069eb <vector155>:
.globl vector155
vector155:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $155
801069ed:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801069f2:	e9 60 f5 ff ff       	jmp    80105f57 <alltraps>

801069f7 <vector156>:
.globl vector156
vector156:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $156
801069f9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801069fe:	e9 54 f5 ff ff       	jmp    80105f57 <alltraps>

80106a03 <vector157>:
.globl vector157
vector157:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $157
80106a05:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106a0a:	e9 48 f5 ff ff       	jmp    80105f57 <alltraps>

80106a0f <vector158>:
.globl vector158
vector158:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $158
80106a11:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106a16:	e9 3c f5 ff ff       	jmp    80105f57 <alltraps>

80106a1b <vector159>:
.globl vector159
vector159:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $159
80106a1d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106a22:	e9 30 f5 ff ff       	jmp    80105f57 <alltraps>

80106a27 <vector160>:
.globl vector160
vector160:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $160
80106a29:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106a2e:	e9 24 f5 ff ff       	jmp    80105f57 <alltraps>

80106a33 <vector161>:
.globl vector161
vector161:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $161
80106a35:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106a3a:	e9 18 f5 ff ff       	jmp    80105f57 <alltraps>

80106a3f <vector162>:
.globl vector162
vector162:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $162
80106a41:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106a46:	e9 0c f5 ff ff       	jmp    80105f57 <alltraps>

80106a4b <vector163>:
.globl vector163
vector163:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $163
80106a4d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106a52:	e9 00 f5 ff ff       	jmp    80105f57 <alltraps>

80106a57 <vector164>:
.globl vector164
vector164:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $164
80106a59:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106a5e:	e9 f4 f4 ff ff       	jmp    80105f57 <alltraps>

80106a63 <vector165>:
.globl vector165
vector165:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $165
80106a65:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106a6a:	e9 e8 f4 ff ff       	jmp    80105f57 <alltraps>

80106a6f <vector166>:
.globl vector166
vector166:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $166
80106a71:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106a76:	e9 dc f4 ff ff       	jmp    80105f57 <alltraps>

80106a7b <vector167>:
.globl vector167
vector167:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $167
80106a7d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106a82:	e9 d0 f4 ff ff       	jmp    80105f57 <alltraps>

80106a87 <vector168>:
.globl vector168
vector168:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $168
80106a89:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106a8e:	e9 c4 f4 ff ff       	jmp    80105f57 <alltraps>

80106a93 <vector169>:
.globl vector169
vector169:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $169
80106a95:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106a9a:	e9 b8 f4 ff ff       	jmp    80105f57 <alltraps>

80106a9f <vector170>:
.globl vector170
vector170:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $170
80106aa1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106aa6:	e9 ac f4 ff ff       	jmp    80105f57 <alltraps>

80106aab <vector171>:
.globl vector171
vector171:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $171
80106aad:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106ab2:	e9 a0 f4 ff ff       	jmp    80105f57 <alltraps>

80106ab7 <vector172>:
.globl vector172
vector172:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $172
80106ab9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106abe:	e9 94 f4 ff ff       	jmp    80105f57 <alltraps>

80106ac3 <vector173>:
.globl vector173
vector173:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $173
80106ac5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106aca:	e9 88 f4 ff ff       	jmp    80105f57 <alltraps>

80106acf <vector174>:
.globl vector174
vector174:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $174
80106ad1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106ad6:	e9 7c f4 ff ff       	jmp    80105f57 <alltraps>

80106adb <vector175>:
.globl vector175
vector175:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $175
80106add:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106ae2:	e9 70 f4 ff ff       	jmp    80105f57 <alltraps>

80106ae7 <vector176>:
.globl vector176
vector176:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $176
80106ae9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106aee:	e9 64 f4 ff ff       	jmp    80105f57 <alltraps>

80106af3 <vector177>:
.globl vector177
vector177:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $177
80106af5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106afa:	e9 58 f4 ff ff       	jmp    80105f57 <alltraps>

80106aff <vector178>:
.globl vector178
vector178:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $178
80106b01:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106b06:	e9 4c f4 ff ff       	jmp    80105f57 <alltraps>

80106b0b <vector179>:
.globl vector179
vector179:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $179
80106b0d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106b12:	e9 40 f4 ff ff       	jmp    80105f57 <alltraps>

80106b17 <vector180>:
.globl vector180
vector180:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $180
80106b19:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106b1e:	e9 34 f4 ff ff       	jmp    80105f57 <alltraps>

80106b23 <vector181>:
.globl vector181
vector181:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $181
80106b25:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106b2a:	e9 28 f4 ff ff       	jmp    80105f57 <alltraps>

80106b2f <vector182>:
.globl vector182
vector182:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $182
80106b31:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106b36:	e9 1c f4 ff ff       	jmp    80105f57 <alltraps>

80106b3b <vector183>:
.globl vector183
vector183:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $183
80106b3d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106b42:	e9 10 f4 ff ff       	jmp    80105f57 <alltraps>

80106b47 <vector184>:
.globl vector184
vector184:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $184
80106b49:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106b4e:	e9 04 f4 ff ff       	jmp    80105f57 <alltraps>

80106b53 <vector185>:
.globl vector185
vector185:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $185
80106b55:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106b5a:	e9 f8 f3 ff ff       	jmp    80105f57 <alltraps>

80106b5f <vector186>:
.globl vector186
vector186:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $186
80106b61:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106b66:	e9 ec f3 ff ff       	jmp    80105f57 <alltraps>

80106b6b <vector187>:
.globl vector187
vector187:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $187
80106b6d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106b72:	e9 e0 f3 ff ff       	jmp    80105f57 <alltraps>

80106b77 <vector188>:
.globl vector188
vector188:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $188
80106b79:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106b7e:	e9 d4 f3 ff ff       	jmp    80105f57 <alltraps>

80106b83 <vector189>:
.globl vector189
vector189:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $189
80106b85:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106b8a:	e9 c8 f3 ff ff       	jmp    80105f57 <alltraps>

80106b8f <vector190>:
.globl vector190
vector190:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $190
80106b91:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106b96:	e9 bc f3 ff ff       	jmp    80105f57 <alltraps>

80106b9b <vector191>:
.globl vector191
vector191:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $191
80106b9d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106ba2:	e9 b0 f3 ff ff       	jmp    80105f57 <alltraps>

80106ba7 <vector192>:
.globl vector192
vector192:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $192
80106ba9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106bae:	e9 a4 f3 ff ff       	jmp    80105f57 <alltraps>

80106bb3 <vector193>:
.globl vector193
vector193:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $193
80106bb5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106bba:	e9 98 f3 ff ff       	jmp    80105f57 <alltraps>

80106bbf <vector194>:
.globl vector194
vector194:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $194
80106bc1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106bc6:	e9 8c f3 ff ff       	jmp    80105f57 <alltraps>

80106bcb <vector195>:
.globl vector195
vector195:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $195
80106bcd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106bd2:	e9 80 f3 ff ff       	jmp    80105f57 <alltraps>

80106bd7 <vector196>:
.globl vector196
vector196:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $196
80106bd9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106bde:	e9 74 f3 ff ff       	jmp    80105f57 <alltraps>

80106be3 <vector197>:
.globl vector197
vector197:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $197
80106be5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106bea:	e9 68 f3 ff ff       	jmp    80105f57 <alltraps>

80106bef <vector198>:
.globl vector198
vector198:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $198
80106bf1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106bf6:	e9 5c f3 ff ff       	jmp    80105f57 <alltraps>

80106bfb <vector199>:
.globl vector199
vector199:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $199
80106bfd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106c02:	e9 50 f3 ff ff       	jmp    80105f57 <alltraps>

80106c07 <vector200>:
.globl vector200
vector200:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $200
80106c09:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106c0e:	e9 44 f3 ff ff       	jmp    80105f57 <alltraps>

80106c13 <vector201>:
.globl vector201
vector201:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $201
80106c15:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106c1a:	e9 38 f3 ff ff       	jmp    80105f57 <alltraps>

80106c1f <vector202>:
.globl vector202
vector202:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $202
80106c21:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106c26:	e9 2c f3 ff ff       	jmp    80105f57 <alltraps>

80106c2b <vector203>:
.globl vector203
vector203:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $203
80106c2d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106c32:	e9 20 f3 ff ff       	jmp    80105f57 <alltraps>

80106c37 <vector204>:
.globl vector204
vector204:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $204
80106c39:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106c3e:	e9 14 f3 ff ff       	jmp    80105f57 <alltraps>

80106c43 <vector205>:
.globl vector205
vector205:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $205
80106c45:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106c4a:	e9 08 f3 ff ff       	jmp    80105f57 <alltraps>

80106c4f <vector206>:
.globl vector206
vector206:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $206
80106c51:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106c56:	e9 fc f2 ff ff       	jmp    80105f57 <alltraps>

80106c5b <vector207>:
.globl vector207
vector207:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $207
80106c5d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106c62:	e9 f0 f2 ff ff       	jmp    80105f57 <alltraps>

80106c67 <vector208>:
.globl vector208
vector208:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $208
80106c69:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106c6e:	e9 e4 f2 ff ff       	jmp    80105f57 <alltraps>

80106c73 <vector209>:
.globl vector209
vector209:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $209
80106c75:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106c7a:	e9 d8 f2 ff ff       	jmp    80105f57 <alltraps>

80106c7f <vector210>:
.globl vector210
vector210:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $210
80106c81:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106c86:	e9 cc f2 ff ff       	jmp    80105f57 <alltraps>

80106c8b <vector211>:
.globl vector211
vector211:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $211
80106c8d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106c92:	e9 c0 f2 ff ff       	jmp    80105f57 <alltraps>

80106c97 <vector212>:
.globl vector212
vector212:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $212
80106c99:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106c9e:	e9 b4 f2 ff ff       	jmp    80105f57 <alltraps>

80106ca3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $213
80106ca5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106caa:	e9 a8 f2 ff ff       	jmp    80105f57 <alltraps>

80106caf <vector214>:
.globl vector214
vector214:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $214
80106cb1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106cb6:	e9 9c f2 ff ff       	jmp    80105f57 <alltraps>

80106cbb <vector215>:
.globl vector215
vector215:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $215
80106cbd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106cc2:	e9 90 f2 ff ff       	jmp    80105f57 <alltraps>

80106cc7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $216
80106cc9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106cce:	e9 84 f2 ff ff       	jmp    80105f57 <alltraps>

80106cd3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $217
80106cd5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106cda:	e9 78 f2 ff ff       	jmp    80105f57 <alltraps>

80106cdf <vector218>:
.globl vector218
vector218:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $218
80106ce1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106ce6:	e9 6c f2 ff ff       	jmp    80105f57 <alltraps>

80106ceb <vector219>:
.globl vector219
vector219:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $219
80106ced:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106cf2:	e9 60 f2 ff ff       	jmp    80105f57 <alltraps>

80106cf7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $220
80106cf9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106cfe:	e9 54 f2 ff ff       	jmp    80105f57 <alltraps>

80106d03 <vector221>:
.globl vector221
vector221:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $221
80106d05:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106d0a:	e9 48 f2 ff ff       	jmp    80105f57 <alltraps>

80106d0f <vector222>:
.globl vector222
vector222:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $222
80106d11:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106d16:	e9 3c f2 ff ff       	jmp    80105f57 <alltraps>

80106d1b <vector223>:
.globl vector223
vector223:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $223
80106d1d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106d22:	e9 30 f2 ff ff       	jmp    80105f57 <alltraps>

80106d27 <vector224>:
.globl vector224
vector224:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $224
80106d29:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106d2e:	e9 24 f2 ff ff       	jmp    80105f57 <alltraps>

80106d33 <vector225>:
.globl vector225
vector225:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $225
80106d35:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106d3a:	e9 18 f2 ff ff       	jmp    80105f57 <alltraps>

80106d3f <vector226>:
.globl vector226
vector226:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $226
80106d41:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106d46:	e9 0c f2 ff ff       	jmp    80105f57 <alltraps>

80106d4b <vector227>:
.globl vector227
vector227:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $227
80106d4d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106d52:	e9 00 f2 ff ff       	jmp    80105f57 <alltraps>

80106d57 <vector228>:
.globl vector228
vector228:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $228
80106d59:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106d5e:	e9 f4 f1 ff ff       	jmp    80105f57 <alltraps>

80106d63 <vector229>:
.globl vector229
vector229:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $229
80106d65:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106d6a:	e9 e8 f1 ff ff       	jmp    80105f57 <alltraps>

80106d6f <vector230>:
.globl vector230
vector230:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $230
80106d71:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106d76:	e9 dc f1 ff ff       	jmp    80105f57 <alltraps>

80106d7b <vector231>:
.globl vector231
vector231:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $231
80106d7d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106d82:	e9 d0 f1 ff ff       	jmp    80105f57 <alltraps>

80106d87 <vector232>:
.globl vector232
vector232:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $232
80106d89:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106d8e:	e9 c4 f1 ff ff       	jmp    80105f57 <alltraps>

80106d93 <vector233>:
.globl vector233
vector233:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $233
80106d95:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106d9a:	e9 b8 f1 ff ff       	jmp    80105f57 <alltraps>

80106d9f <vector234>:
.globl vector234
vector234:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $234
80106da1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106da6:	e9 ac f1 ff ff       	jmp    80105f57 <alltraps>

80106dab <vector235>:
.globl vector235
vector235:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $235
80106dad:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106db2:	e9 a0 f1 ff ff       	jmp    80105f57 <alltraps>

80106db7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $236
80106db9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106dbe:	e9 94 f1 ff ff       	jmp    80105f57 <alltraps>

80106dc3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $237
80106dc5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106dca:	e9 88 f1 ff ff       	jmp    80105f57 <alltraps>

80106dcf <vector238>:
.globl vector238
vector238:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $238
80106dd1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106dd6:	e9 7c f1 ff ff       	jmp    80105f57 <alltraps>

80106ddb <vector239>:
.globl vector239
vector239:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $239
80106ddd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106de2:	e9 70 f1 ff ff       	jmp    80105f57 <alltraps>

80106de7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $240
80106de9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106dee:	e9 64 f1 ff ff       	jmp    80105f57 <alltraps>

80106df3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $241
80106df5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106dfa:	e9 58 f1 ff ff       	jmp    80105f57 <alltraps>

80106dff <vector242>:
.globl vector242
vector242:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $242
80106e01:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106e06:	e9 4c f1 ff ff       	jmp    80105f57 <alltraps>

80106e0b <vector243>:
.globl vector243
vector243:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $243
80106e0d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106e12:	e9 40 f1 ff ff       	jmp    80105f57 <alltraps>

80106e17 <vector244>:
.globl vector244
vector244:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $244
80106e19:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106e1e:	e9 34 f1 ff ff       	jmp    80105f57 <alltraps>

80106e23 <vector245>:
.globl vector245
vector245:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $245
80106e25:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106e2a:	e9 28 f1 ff ff       	jmp    80105f57 <alltraps>

80106e2f <vector246>:
.globl vector246
vector246:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $246
80106e31:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106e36:	e9 1c f1 ff ff       	jmp    80105f57 <alltraps>

80106e3b <vector247>:
.globl vector247
vector247:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $247
80106e3d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106e42:	e9 10 f1 ff ff       	jmp    80105f57 <alltraps>

80106e47 <vector248>:
.globl vector248
vector248:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $248
80106e49:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106e4e:	e9 04 f1 ff ff       	jmp    80105f57 <alltraps>

80106e53 <vector249>:
.globl vector249
vector249:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $249
80106e55:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106e5a:	e9 f8 f0 ff ff       	jmp    80105f57 <alltraps>

80106e5f <vector250>:
.globl vector250
vector250:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $250
80106e61:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106e66:	e9 ec f0 ff ff       	jmp    80105f57 <alltraps>

80106e6b <vector251>:
.globl vector251
vector251:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $251
80106e6d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106e72:	e9 e0 f0 ff ff       	jmp    80105f57 <alltraps>

80106e77 <vector252>:
.globl vector252
vector252:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $252
80106e79:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106e7e:	e9 d4 f0 ff ff       	jmp    80105f57 <alltraps>

80106e83 <vector253>:
.globl vector253
vector253:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $253
80106e85:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106e8a:	e9 c8 f0 ff ff       	jmp    80105f57 <alltraps>

80106e8f <vector254>:
.globl vector254
vector254:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $254
80106e91:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106e96:	e9 bc f0 ff ff       	jmp    80105f57 <alltraps>

80106e9b <vector255>:
.globl vector255
vector255:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $255
80106e9d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106ea2:	e9 b0 f0 ff ff       	jmp    80105f57 <alltraps>
80106ea7:	66 90                	xchg   %ax,%ax
80106ea9:	66 90                	xchg   %ax,%ax
80106eab:	66 90                	xchg   %ax,%ax
80106ead:	66 90                	xchg   %ax,%ax
80106eaf:	90                   	nop

80106eb0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106eb0:	55                   	push   %ebp
80106eb1:	89 e5                	mov    %esp,%ebp
80106eb3:	57                   	push   %edi
80106eb4:	56                   	push   %esi
80106eb5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106eb6:	89 d3                	mov    %edx,%ebx
{
80106eb8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106eba:	c1 eb 16             	shr    $0x16,%ebx
80106ebd:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106ec0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106ec3:	8b 06                	mov    (%esi),%eax
80106ec5:	a8 01                	test   $0x1,%al
80106ec7:	74 27                	je     80106ef0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ec9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ece:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106ed4:	c1 ef 0a             	shr    $0xa,%edi
}
80106ed7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106eda:	89 fa                	mov    %edi,%edx
80106edc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106ee2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106ee5:	5b                   	pop    %ebx
80106ee6:	5e                   	pop    %esi
80106ee7:	5f                   	pop    %edi
80106ee8:	5d                   	pop    %ebp
80106ee9:	c3                   	ret    
80106eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106ef0:	85 c9                	test   %ecx,%ecx
80106ef2:	74 2c                	je     80106f20 <walkpgdir+0x70>
80106ef4:	e8 e7 b7 ff ff       	call   801026e0 <kalloc>
80106ef9:	85 c0                	test   %eax,%eax
80106efb:	89 c3                	mov    %eax,%ebx
80106efd:	74 21                	je     80106f20 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106eff:	83 ec 04             	sub    $0x4,%esp
80106f02:	68 00 10 00 00       	push   $0x1000
80106f07:	6a 00                	push   $0x0
80106f09:	50                   	push   %eax
80106f0a:	e8 31 db ff ff       	call   80104a40 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106f0f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f15:	83 c4 10             	add    $0x10,%esp
80106f18:	83 c8 07             	or     $0x7,%eax
80106f1b:	89 06                	mov    %eax,(%esi)
80106f1d:	eb b5                	jmp    80106ed4 <walkpgdir+0x24>
80106f1f:	90                   	nop
}
80106f20:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106f23:	31 c0                	xor    %eax,%eax
}
80106f25:	5b                   	pop    %ebx
80106f26:	5e                   	pop    %esi
80106f27:	5f                   	pop    %edi
80106f28:	5d                   	pop    %ebp
80106f29:	c3                   	ret    
80106f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f30 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106f30:	55                   	push   %ebp
80106f31:	89 e5                	mov    %esp,%ebp
80106f33:	57                   	push   %edi
80106f34:	56                   	push   %esi
80106f35:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106f36:	89 d3                	mov    %edx,%ebx
80106f38:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106f3e:	83 ec 1c             	sub    $0x1c,%esp
80106f41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106f44:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106f48:	8b 7d 08             	mov    0x8(%ebp),%edi
80106f4b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f50:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106f53:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f56:	29 df                	sub    %ebx,%edi
80106f58:	83 c8 01             	or     $0x1,%eax
80106f5b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106f5e:	eb 15                	jmp    80106f75 <mappages+0x45>
    if(*pte & PTE_P)
80106f60:	f6 00 01             	testb  $0x1,(%eax)
80106f63:	75 45                	jne    80106faa <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106f65:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106f68:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106f6b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106f6d:	74 31                	je     80106fa0 <mappages+0x70>
      break;
    a += PGSIZE;
80106f6f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106f75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f78:	b9 01 00 00 00       	mov    $0x1,%ecx
80106f7d:	89 da                	mov    %ebx,%edx
80106f7f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106f82:	e8 29 ff ff ff       	call   80106eb0 <walkpgdir>
80106f87:	85 c0                	test   %eax,%eax
80106f89:	75 d5                	jne    80106f60 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f93:	5b                   	pop    %ebx
80106f94:	5e                   	pop    %esi
80106f95:	5f                   	pop    %edi
80106f96:	5d                   	pop    %ebp
80106f97:	c3                   	ret    
80106f98:	90                   	nop
80106f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fa0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106fa3:	31 c0                	xor    %eax,%eax
}
80106fa5:	5b                   	pop    %ebx
80106fa6:	5e                   	pop    %esi
80106fa7:	5f                   	pop    %edi
80106fa8:	5d                   	pop    %ebp
80106fa9:	c3                   	ret    
      panic("remap");
80106faa:	83 ec 0c             	sub    $0xc,%esp
80106fad:	68 60 81 10 80       	push   $0x80108160
80106fb2:	e8 d9 93 ff ff       	call   80100390 <panic>
80106fb7:	89 f6                	mov    %esi,%esi
80106fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106fc0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106fc0:	55                   	push   %ebp
80106fc1:	89 e5                	mov    %esp,%ebp
80106fc3:	57                   	push   %edi
80106fc4:	56                   	push   %esi
80106fc5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106fc6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106fcc:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106fce:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106fd4:	83 ec 1c             	sub    $0x1c,%esp
80106fd7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106fda:	39 d3                	cmp    %edx,%ebx
80106fdc:	73 66                	jae    80107044 <deallocuvm.part.0+0x84>
80106fde:	89 d6                	mov    %edx,%esi
80106fe0:	eb 3d                	jmp    8010701f <deallocuvm.part.0+0x5f>
80106fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106fe8:	8b 10                	mov    (%eax),%edx
80106fea:	f6 c2 01             	test   $0x1,%dl
80106fed:	74 26                	je     80107015 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106fef:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106ff5:	74 58                	je     8010704f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106ff7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106ffa:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107000:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80107003:	52                   	push   %edx
80107004:	e8 27 b5 ff ff       	call   80102530 <kfree>
      *pte = 0;
80107009:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010700c:	83 c4 10             	add    $0x10,%esp
8010700f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107015:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010701b:	39 f3                	cmp    %esi,%ebx
8010701d:	73 25                	jae    80107044 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010701f:	31 c9                	xor    %ecx,%ecx
80107021:	89 da                	mov    %ebx,%edx
80107023:	89 f8                	mov    %edi,%eax
80107025:	e8 86 fe ff ff       	call   80106eb0 <walkpgdir>
    if(!pte)
8010702a:	85 c0                	test   %eax,%eax
8010702c:	75 ba                	jne    80106fe8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010702e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107034:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010703a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107040:	39 f3                	cmp    %esi,%ebx
80107042:	72 db                	jb     8010701f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80107044:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107047:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010704a:	5b                   	pop    %ebx
8010704b:	5e                   	pop    %esi
8010704c:	5f                   	pop    %edi
8010704d:	5d                   	pop    %ebp
8010704e:	c3                   	ret    
        panic("kfree");
8010704f:	83 ec 0c             	sub    $0xc,%esp
80107052:	68 46 7a 10 80       	push   $0x80107a46
80107057:	e8 34 93 ff ff       	call   80100390 <panic>
8010705c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107060 <seginit>:
{
80107060:	55                   	push   %ebp
80107061:	89 e5                	mov    %esp,%ebp
80107063:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107066:	e8 85 cc ff ff       	call   80103cf0 <cpuid>
8010706b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107071:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107076:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010707a:	c7 80 f8 38 11 80 ff 	movl   $0xffff,-0x7feec708(%eax)
80107081:	ff 00 00 
80107084:	c7 80 fc 38 11 80 00 	movl   $0xcf9a00,-0x7feec704(%eax)
8010708b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010708e:	c7 80 00 39 11 80 ff 	movl   $0xffff,-0x7feec700(%eax)
80107095:	ff 00 00 
80107098:	c7 80 04 39 11 80 00 	movl   $0xcf9200,-0x7feec6fc(%eax)
8010709f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801070a2:	c7 80 08 39 11 80 ff 	movl   $0xffff,-0x7feec6f8(%eax)
801070a9:	ff 00 00 
801070ac:	c7 80 0c 39 11 80 00 	movl   $0xcffa00,-0x7feec6f4(%eax)
801070b3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801070b6:	c7 80 10 39 11 80 ff 	movl   $0xffff,-0x7feec6f0(%eax)
801070bd:	ff 00 00 
801070c0:	c7 80 14 39 11 80 00 	movl   $0xcff200,-0x7feec6ec(%eax)
801070c7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801070ca:	05 f0 38 11 80       	add    $0x801138f0,%eax
  pd[1] = (uint)p;
801070cf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801070d3:	c1 e8 10             	shr    $0x10,%eax
801070d6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801070da:	8d 45 f2             	lea    -0xe(%ebp),%eax
801070dd:	0f 01 10             	lgdtl  (%eax)
}
801070e0:	c9                   	leave  
801070e1:	c3                   	ret    
801070e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070f0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801070f0:	a1 a4 83 11 80       	mov    0x801183a4,%eax
{
801070f5:	55                   	push   %ebp
801070f6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801070f8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801070fd:	0f 22 d8             	mov    %eax,%cr3
}
80107100:	5d                   	pop    %ebp
80107101:	c3                   	ret    
80107102:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107110 <switchuvm>:
{
80107110:	55                   	push   %ebp
80107111:	89 e5                	mov    %esp,%ebp
80107113:	57                   	push   %edi
80107114:	56                   	push   %esi
80107115:	53                   	push   %ebx
80107116:	83 ec 1c             	sub    $0x1c,%esp
80107119:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010711c:	85 db                	test   %ebx,%ebx
8010711e:	0f 84 cb 00 00 00    	je     801071ef <switchuvm+0xdf>
  if(p->kstack == 0)
80107124:	8b 43 08             	mov    0x8(%ebx),%eax
80107127:	85 c0                	test   %eax,%eax
80107129:	0f 84 da 00 00 00    	je     80107209 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010712f:	8b 43 04             	mov    0x4(%ebx),%eax
80107132:	85 c0                	test   %eax,%eax
80107134:	0f 84 c2 00 00 00    	je     801071fc <switchuvm+0xec>
  pushcli();
8010713a:	e8 21 d7 ff ff       	call   80104860 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010713f:	e8 2c cb ff ff       	call   80103c70 <mycpu>
80107144:	89 c6                	mov    %eax,%esi
80107146:	e8 25 cb ff ff       	call   80103c70 <mycpu>
8010714b:	89 c7                	mov    %eax,%edi
8010714d:	e8 1e cb ff ff       	call   80103c70 <mycpu>
80107152:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107155:	83 c7 08             	add    $0x8,%edi
80107158:	e8 13 cb ff ff       	call   80103c70 <mycpu>
8010715d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107160:	83 c0 08             	add    $0x8,%eax
80107163:	ba 67 00 00 00       	mov    $0x67,%edx
80107168:	c1 e8 18             	shr    $0x18,%eax
8010716b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107172:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107179:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010717f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107184:	83 c1 08             	add    $0x8,%ecx
80107187:	c1 e9 10             	shr    $0x10,%ecx
8010718a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107190:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107195:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010719c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
801071a1:	e8 ca ca ff ff       	call   80103c70 <mycpu>
801071a6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801071ad:	e8 be ca ff ff       	call   80103c70 <mycpu>
801071b2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801071b6:	8b 73 08             	mov    0x8(%ebx),%esi
801071b9:	e8 b2 ca ff ff       	call   80103c70 <mycpu>
801071be:	81 c6 00 10 00 00    	add    $0x1000,%esi
801071c4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801071c7:	e8 a4 ca ff ff       	call   80103c70 <mycpu>
801071cc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801071d0:	b8 28 00 00 00       	mov    $0x28,%eax
801071d5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801071d8:	8b 43 04             	mov    0x4(%ebx),%eax
801071db:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801071e0:	0f 22 d8             	mov    %eax,%cr3
}
801071e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071e6:	5b                   	pop    %ebx
801071e7:	5e                   	pop    %esi
801071e8:	5f                   	pop    %edi
801071e9:	5d                   	pop    %ebp
  popcli();
801071ea:	e9 b1 d6 ff ff       	jmp    801048a0 <popcli>
    panic("switchuvm: no process");
801071ef:	83 ec 0c             	sub    $0xc,%esp
801071f2:	68 66 81 10 80       	push   $0x80108166
801071f7:	e8 94 91 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801071fc:	83 ec 0c             	sub    $0xc,%esp
801071ff:	68 91 81 10 80       	push   $0x80108191
80107204:	e8 87 91 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107209:	83 ec 0c             	sub    $0xc,%esp
8010720c:	68 7c 81 10 80       	push   $0x8010817c
80107211:	e8 7a 91 ff ff       	call   80100390 <panic>
80107216:	8d 76 00             	lea    0x0(%esi),%esi
80107219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107220 <inituvm>:
{
80107220:	55                   	push   %ebp
80107221:	89 e5                	mov    %esp,%ebp
80107223:	57                   	push   %edi
80107224:	56                   	push   %esi
80107225:	53                   	push   %ebx
80107226:	83 ec 1c             	sub    $0x1c,%esp
80107229:	8b 75 10             	mov    0x10(%ebp),%esi
8010722c:	8b 45 08             	mov    0x8(%ebp),%eax
8010722f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80107232:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107238:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010723b:	77 49                	ja     80107286 <inituvm+0x66>
  mem = kalloc();
8010723d:	e8 9e b4 ff ff       	call   801026e0 <kalloc>
  memset(mem, 0, PGSIZE);
80107242:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107245:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107247:	68 00 10 00 00       	push   $0x1000
8010724c:	6a 00                	push   $0x0
8010724e:	50                   	push   %eax
8010724f:	e8 ec d7 ff ff       	call   80104a40 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107254:	58                   	pop    %eax
80107255:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010725b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107260:	5a                   	pop    %edx
80107261:	6a 06                	push   $0x6
80107263:	50                   	push   %eax
80107264:	31 d2                	xor    %edx,%edx
80107266:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107269:	e8 c2 fc ff ff       	call   80106f30 <mappages>
  memmove(mem, init, sz);
8010726e:	89 75 10             	mov    %esi,0x10(%ebp)
80107271:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107274:	83 c4 10             	add    $0x10,%esp
80107277:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010727a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010727d:	5b                   	pop    %ebx
8010727e:	5e                   	pop    %esi
8010727f:	5f                   	pop    %edi
80107280:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107281:	e9 6a d8 ff ff       	jmp    80104af0 <memmove>
    panic("inituvm: more than a page");
80107286:	83 ec 0c             	sub    $0xc,%esp
80107289:	68 a5 81 10 80       	push   $0x801081a5
8010728e:	e8 fd 90 ff ff       	call   80100390 <panic>
80107293:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801072a0 <loaduvm>:
{
801072a0:	55                   	push   %ebp
801072a1:	89 e5                	mov    %esp,%ebp
801072a3:	57                   	push   %edi
801072a4:	56                   	push   %esi
801072a5:	53                   	push   %ebx
801072a6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
801072a9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801072b0:	0f 85 91 00 00 00    	jne    80107347 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
801072b6:	8b 75 18             	mov    0x18(%ebp),%esi
801072b9:	31 db                	xor    %ebx,%ebx
801072bb:	85 f6                	test   %esi,%esi
801072bd:	75 1a                	jne    801072d9 <loaduvm+0x39>
801072bf:	eb 6f                	jmp    80107330 <loaduvm+0x90>
801072c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072c8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801072ce:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801072d4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801072d7:	76 57                	jbe    80107330 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801072d9:	8b 55 0c             	mov    0xc(%ebp),%edx
801072dc:	8b 45 08             	mov    0x8(%ebp),%eax
801072df:	31 c9                	xor    %ecx,%ecx
801072e1:	01 da                	add    %ebx,%edx
801072e3:	e8 c8 fb ff ff       	call   80106eb0 <walkpgdir>
801072e8:	85 c0                	test   %eax,%eax
801072ea:	74 4e                	je     8010733a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
801072ec:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801072ee:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
801072f1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801072f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801072fb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107301:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107304:	01 d9                	add    %ebx,%ecx
80107306:	05 00 00 00 80       	add    $0x80000000,%eax
8010730b:	57                   	push   %edi
8010730c:	51                   	push   %ecx
8010730d:	50                   	push   %eax
8010730e:	ff 75 10             	pushl  0x10(%ebp)
80107311:	e8 6a a8 ff ff       	call   80101b80 <readi>
80107316:	83 c4 10             	add    $0x10,%esp
80107319:	39 f8                	cmp    %edi,%eax
8010731b:	74 ab                	je     801072c8 <loaduvm+0x28>
}
8010731d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107320:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107325:	5b                   	pop    %ebx
80107326:	5e                   	pop    %esi
80107327:	5f                   	pop    %edi
80107328:	5d                   	pop    %ebp
80107329:	c3                   	ret    
8010732a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107330:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107333:	31 c0                	xor    %eax,%eax
}
80107335:	5b                   	pop    %ebx
80107336:	5e                   	pop    %esi
80107337:	5f                   	pop    %edi
80107338:	5d                   	pop    %ebp
80107339:	c3                   	ret    
      panic("loaduvm: address should exist");
8010733a:	83 ec 0c             	sub    $0xc,%esp
8010733d:	68 bf 81 10 80       	push   $0x801081bf
80107342:	e8 49 90 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107347:	83 ec 0c             	sub    $0xc,%esp
8010734a:	68 60 82 10 80       	push   $0x80108260
8010734f:	e8 3c 90 ff ff       	call   80100390 <panic>
80107354:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010735a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107360 <allocuvm>:
{
80107360:	55                   	push   %ebp
80107361:	89 e5                	mov    %esp,%ebp
80107363:	57                   	push   %edi
80107364:	56                   	push   %esi
80107365:	53                   	push   %ebx
80107366:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107369:	8b 7d 10             	mov    0x10(%ebp),%edi
8010736c:	85 ff                	test   %edi,%edi
8010736e:	0f 88 8e 00 00 00    	js     80107402 <allocuvm+0xa2>
  if(newsz < oldsz)
80107374:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107377:	0f 82 93 00 00 00    	jb     80107410 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
8010737d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107380:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107386:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010738c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010738f:	0f 86 7e 00 00 00    	jbe    80107413 <allocuvm+0xb3>
80107395:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107398:	8b 7d 08             	mov    0x8(%ebp),%edi
8010739b:	eb 42                	jmp    801073df <allocuvm+0x7f>
8010739d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
801073a0:	83 ec 04             	sub    $0x4,%esp
801073a3:	68 00 10 00 00       	push   $0x1000
801073a8:	6a 00                	push   $0x0
801073aa:	50                   	push   %eax
801073ab:	e8 90 d6 ff ff       	call   80104a40 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801073b0:	58                   	pop    %eax
801073b1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801073b7:	b9 00 10 00 00       	mov    $0x1000,%ecx
801073bc:	5a                   	pop    %edx
801073bd:	6a 06                	push   $0x6
801073bf:	50                   	push   %eax
801073c0:	89 da                	mov    %ebx,%edx
801073c2:	89 f8                	mov    %edi,%eax
801073c4:	e8 67 fb ff ff       	call   80106f30 <mappages>
801073c9:	83 c4 10             	add    $0x10,%esp
801073cc:	85 c0                	test   %eax,%eax
801073ce:	78 50                	js     80107420 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
801073d0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801073d6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801073d9:	0f 86 81 00 00 00    	jbe    80107460 <allocuvm+0x100>
    mem = kalloc();
801073df:	e8 fc b2 ff ff       	call   801026e0 <kalloc>
    if(mem == 0){
801073e4:	85 c0                	test   %eax,%eax
    mem = kalloc();
801073e6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801073e8:	75 b6                	jne    801073a0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801073ea:	83 ec 0c             	sub    $0xc,%esp
801073ed:	68 dd 81 10 80       	push   $0x801081dd
801073f2:	e8 69 92 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
801073f7:	83 c4 10             	add    $0x10,%esp
801073fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801073fd:	39 45 10             	cmp    %eax,0x10(%ebp)
80107400:	77 6e                	ja     80107470 <allocuvm+0x110>
}
80107402:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107405:	31 ff                	xor    %edi,%edi
}
80107407:	89 f8                	mov    %edi,%eax
80107409:	5b                   	pop    %ebx
8010740a:	5e                   	pop    %esi
8010740b:	5f                   	pop    %edi
8010740c:	5d                   	pop    %ebp
8010740d:	c3                   	ret    
8010740e:	66 90                	xchg   %ax,%ax
    return oldsz;
80107410:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107413:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107416:	89 f8                	mov    %edi,%eax
80107418:	5b                   	pop    %ebx
80107419:	5e                   	pop    %esi
8010741a:	5f                   	pop    %edi
8010741b:	5d                   	pop    %ebp
8010741c:	c3                   	ret    
8010741d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107420:	83 ec 0c             	sub    $0xc,%esp
80107423:	68 f5 81 10 80       	push   $0x801081f5
80107428:	e8 33 92 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
8010742d:	83 c4 10             	add    $0x10,%esp
80107430:	8b 45 0c             	mov    0xc(%ebp),%eax
80107433:	39 45 10             	cmp    %eax,0x10(%ebp)
80107436:	76 0d                	jbe    80107445 <allocuvm+0xe5>
80107438:	89 c1                	mov    %eax,%ecx
8010743a:	8b 55 10             	mov    0x10(%ebp),%edx
8010743d:	8b 45 08             	mov    0x8(%ebp),%eax
80107440:	e8 7b fb ff ff       	call   80106fc0 <deallocuvm.part.0>
      kfree(mem);
80107445:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107448:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010744a:	56                   	push   %esi
8010744b:	e8 e0 b0 ff ff       	call   80102530 <kfree>
      return 0;
80107450:	83 c4 10             	add    $0x10,%esp
}
80107453:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107456:	89 f8                	mov    %edi,%eax
80107458:	5b                   	pop    %ebx
80107459:	5e                   	pop    %esi
8010745a:	5f                   	pop    %edi
8010745b:	5d                   	pop    %ebp
8010745c:	c3                   	ret    
8010745d:	8d 76 00             	lea    0x0(%esi),%esi
80107460:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107463:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107466:	5b                   	pop    %ebx
80107467:	89 f8                	mov    %edi,%eax
80107469:	5e                   	pop    %esi
8010746a:	5f                   	pop    %edi
8010746b:	5d                   	pop    %ebp
8010746c:	c3                   	ret    
8010746d:	8d 76 00             	lea    0x0(%esi),%esi
80107470:	89 c1                	mov    %eax,%ecx
80107472:	8b 55 10             	mov    0x10(%ebp),%edx
80107475:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107478:	31 ff                	xor    %edi,%edi
8010747a:	e8 41 fb ff ff       	call   80106fc0 <deallocuvm.part.0>
8010747f:	eb 92                	jmp    80107413 <allocuvm+0xb3>
80107481:	eb 0d                	jmp    80107490 <deallocuvm>
80107483:	90                   	nop
80107484:	90                   	nop
80107485:	90                   	nop
80107486:	90                   	nop
80107487:	90                   	nop
80107488:	90                   	nop
80107489:	90                   	nop
8010748a:	90                   	nop
8010748b:	90                   	nop
8010748c:	90                   	nop
8010748d:	90                   	nop
8010748e:	90                   	nop
8010748f:	90                   	nop

80107490 <deallocuvm>:
{
80107490:	55                   	push   %ebp
80107491:	89 e5                	mov    %esp,%ebp
80107493:	8b 55 0c             	mov    0xc(%ebp),%edx
80107496:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107499:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010749c:	39 d1                	cmp    %edx,%ecx
8010749e:	73 10                	jae    801074b0 <deallocuvm+0x20>
}
801074a0:	5d                   	pop    %ebp
801074a1:	e9 1a fb ff ff       	jmp    80106fc0 <deallocuvm.part.0>
801074a6:	8d 76 00             	lea    0x0(%esi),%esi
801074a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801074b0:	89 d0                	mov    %edx,%eax
801074b2:	5d                   	pop    %ebp
801074b3:	c3                   	ret    
801074b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801074ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801074c0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801074c0:	55                   	push   %ebp
801074c1:	89 e5                	mov    %esp,%ebp
801074c3:	57                   	push   %edi
801074c4:	56                   	push   %esi
801074c5:	53                   	push   %ebx
801074c6:	83 ec 0c             	sub    $0xc,%esp
801074c9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801074cc:	85 f6                	test   %esi,%esi
801074ce:	74 59                	je     80107529 <freevm+0x69>
801074d0:	31 c9                	xor    %ecx,%ecx
801074d2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801074d7:	89 f0                	mov    %esi,%eax
801074d9:	e8 e2 fa ff ff       	call   80106fc0 <deallocuvm.part.0>
801074de:	89 f3                	mov    %esi,%ebx
801074e0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801074e6:	eb 0f                	jmp    801074f7 <freevm+0x37>
801074e8:	90                   	nop
801074e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074f0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801074f3:	39 fb                	cmp    %edi,%ebx
801074f5:	74 23                	je     8010751a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801074f7:	8b 03                	mov    (%ebx),%eax
801074f9:	a8 01                	test   $0x1,%al
801074fb:	74 f3                	je     801074f0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801074fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107502:	83 ec 0c             	sub    $0xc,%esp
80107505:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107508:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010750d:	50                   	push   %eax
8010750e:	e8 1d b0 ff ff       	call   80102530 <kfree>
80107513:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107516:	39 fb                	cmp    %edi,%ebx
80107518:	75 dd                	jne    801074f7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010751a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010751d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107520:	5b                   	pop    %ebx
80107521:	5e                   	pop    %esi
80107522:	5f                   	pop    %edi
80107523:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107524:	e9 07 b0 ff ff       	jmp    80102530 <kfree>
    panic("freevm: no pgdir");
80107529:	83 ec 0c             	sub    $0xc,%esp
8010752c:	68 11 82 10 80       	push   $0x80108211
80107531:	e8 5a 8e ff ff       	call   80100390 <panic>
80107536:	8d 76 00             	lea    0x0(%esi),%esi
80107539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107540 <setupkvm>:
{
80107540:	55                   	push   %ebp
80107541:	89 e5                	mov    %esp,%ebp
80107543:	56                   	push   %esi
80107544:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107545:	e8 96 b1 ff ff       	call   801026e0 <kalloc>
8010754a:	85 c0                	test   %eax,%eax
8010754c:	89 c6                	mov    %eax,%esi
8010754e:	74 42                	je     80107592 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107550:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107553:	bb 80 b4 10 80       	mov    $0x8010b480,%ebx
  memset(pgdir, 0, PGSIZE);
80107558:	68 00 10 00 00       	push   $0x1000
8010755d:	6a 00                	push   $0x0
8010755f:	50                   	push   %eax
80107560:	e8 db d4 ff ff       	call   80104a40 <memset>
80107565:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107568:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010756b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010756e:	83 ec 08             	sub    $0x8,%esp
80107571:	8b 13                	mov    (%ebx),%edx
80107573:	ff 73 0c             	pushl  0xc(%ebx)
80107576:	50                   	push   %eax
80107577:	29 c1                	sub    %eax,%ecx
80107579:	89 f0                	mov    %esi,%eax
8010757b:	e8 b0 f9 ff ff       	call   80106f30 <mappages>
80107580:	83 c4 10             	add    $0x10,%esp
80107583:	85 c0                	test   %eax,%eax
80107585:	78 19                	js     801075a0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107587:	83 c3 10             	add    $0x10,%ebx
8010758a:	81 fb c0 b4 10 80    	cmp    $0x8010b4c0,%ebx
80107590:	75 d6                	jne    80107568 <setupkvm+0x28>
}
80107592:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107595:	89 f0                	mov    %esi,%eax
80107597:	5b                   	pop    %ebx
80107598:	5e                   	pop    %esi
80107599:	5d                   	pop    %ebp
8010759a:	c3                   	ret    
8010759b:	90                   	nop
8010759c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
801075a0:	83 ec 0c             	sub    $0xc,%esp
801075a3:	56                   	push   %esi
      return 0;
801075a4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801075a6:	e8 15 ff ff ff       	call   801074c0 <freevm>
      return 0;
801075ab:	83 c4 10             	add    $0x10,%esp
}
801075ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801075b1:	89 f0                	mov    %esi,%eax
801075b3:	5b                   	pop    %ebx
801075b4:	5e                   	pop    %esi
801075b5:	5d                   	pop    %ebp
801075b6:	c3                   	ret    
801075b7:	89 f6                	mov    %esi,%esi
801075b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801075c0 <kvmalloc>:
{
801075c0:	55                   	push   %ebp
801075c1:	89 e5                	mov    %esp,%ebp
801075c3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801075c6:	e8 75 ff ff ff       	call   80107540 <setupkvm>
801075cb:	a3 a4 83 11 80       	mov    %eax,0x801183a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801075d0:	05 00 00 00 80       	add    $0x80000000,%eax
801075d5:	0f 22 d8             	mov    %eax,%cr3
}
801075d8:	c9                   	leave  
801075d9:	c3                   	ret    
801075da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801075e0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801075e0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801075e1:	31 c9                	xor    %ecx,%ecx
{
801075e3:	89 e5                	mov    %esp,%ebp
801075e5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801075e8:	8b 55 0c             	mov    0xc(%ebp),%edx
801075eb:	8b 45 08             	mov    0x8(%ebp),%eax
801075ee:	e8 bd f8 ff ff       	call   80106eb0 <walkpgdir>
  if(pte == 0)
801075f3:	85 c0                	test   %eax,%eax
801075f5:	74 05                	je     801075fc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801075f7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801075fa:	c9                   	leave  
801075fb:	c3                   	ret    
    panic("clearpteu");
801075fc:	83 ec 0c             	sub    $0xc,%esp
801075ff:	68 22 82 10 80       	push   $0x80108222
80107604:	e8 87 8d ff ff       	call   80100390 <panic>
80107609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107610 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107610:	55                   	push   %ebp
80107611:	89 e5                	mov    %esp,%ebp
80107613:	57                   	push   %edi
80107614:	56                   	push   %esi
80107615:	53                   	push   %ebx
80107616:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107619:	e8 22 ff ff ff       	call   80107540 <setupkvm>
8010761e:	85 c0                	test   %eax,%eax
80107620:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107623:	0f 84 9f 00 00 00    	je     801076c8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107629:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010762c:	85 c9                	test   %ecx,%ecx
8010762e:	0f 84 94 00 00 00    	je     801076c8 <copyuvm+0xb8>
80107634:	31 ff                	xor    %edi,%edi
80107636:	eb 4a                	jmp    80107682 <copyuvm+0x72>
80107638:	90                   	nop
80107639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107640:	83 ec 04             	sub    $0x4,%esp
80107643:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107649:	68 00 10 00 00       	push   $0x1000
8010764e:	53                   	push   %ebx
8010764f:	50                   	push   %eax
80107650:	e8 9b d4 ff ff       	call   80104af0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107655:	58                   	pop    %eax
80107656:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010765c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107661:	5a                   	pop    %edx
80107662:	ff 75 e4             	pushl  -0x1c(%ebp)
80107665:	50                   	push   %eax
80107666:	89 fa                	mov    %edi,%edx
80107668:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010766b:	e8 c0 f8 ff ff       	call   80106f30 <mappages>
80107670:	83 c4 10             	add    $0x10,%esp
80107673:	85 c0                	test   %eax,%eax
80107675:	78 61                	js     801076d8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107677:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010767d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107680:	76 46                	jbe    801076c8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107682:	8b 45 08             	mov    0x8(%ebp),%eax
80107685:	31 c9                	xor    %ecx,%ecx
80107687:	89 fa                	mov    %edi,%edx
80107689:	e8 22 f8 ff ff       	call   80106eb0 <walkpgdir>
8010768e:	85 c0                	test   %eax,%eax
80107690:	74 61                	je     801076f3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107692:	8b 00                	mov    (%eax),%eax
80107694:	a8 01                	test   $0x1,%al
80107696:	74 4e                	je     801076e6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107698:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010769a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
8010769f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
801076a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801076a8:	e8 33 b0 ff ff       	call   801026e0 <kalloc>
801076ad:	85 c0                	test   %eax,%eax
801076af:	89 c6                	mov    %eax,%esi
801076b1:	75 8d                	jne    80107640 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801076b3:	83 ec 0c             	sub    $0xc,%esp
801076b6:	ff 75 e0             	pushl  -0x20(%ebp)
801076b9:	e8 02 fe ff ff       	call   801074c0 <freevm>
  return 0;
801076be:	83 c4 10             	add    $0x10,%esp
801076c1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801076c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801076cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076ce:	5b                   	pop    %ebx
801076cf:	5e                   	pop    %esi
801076d0:	5f                   	pop    %edi
801076d1:	5d                   	pop    %ebp
801076d2:	c3                   	ret    
801076d3:	90                   	nop
801076d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801076d8:	83 ec 0c             	sub    $0xc,%esp
801076db:	56                   	push   %esi
801076dc:	e8 4f ae ff ff       	call   80102530 <kfree>
      goto bad;
801076e1:	83 c4 10             	add    $0x10,%esp
801076e4:	eb cd                	jmp    801076b3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801076e6:	83 ec 0c             	sub    $0xc,%esp
801076e9:	68 46 82 10 80       	push   $0x80108246
801076ee:	e8 9d 8c ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801076f3:	83 ec 0c             	sub    $0xc,%esp
801076f6:	68 2c 82 10 80       	push   $0x8010822c
801076fb:	e8 90 8c ff ff       	call   80100390 <panic>

80107700 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107700:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107701:	31 c9                	xor    %ecx,%ecx
{
80107703:	89 e5                	mov    %esp,%ebp
80107705:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107708:	8b 55 0c             	mov    0xc(%ebp),%edx
8010770b:	8b 45 08             	mov    0x8(%ebp),%eax
8010770e:	e8 9d f7 ff ff       	call   80106eb0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107713:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107715:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107716:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107718:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010771d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107720:	05 00 00 00 80       	add    $0x80000000,%eax
80107725:	83 fa 05             	cmp    $0x5,%edx
80107728:	ba 00 00 00 00       	mov    $0x0,%edx
8010772d:	0f 45 c2             	cmovne %edx,%eax
}
80107730:	c3                   	ret    
80107731:	eb 0d                	jmp    80107740 <copyout>
80107733:	90                   	nop
80107734:	90                   	nop
80107735:	90                   	nop
80107736:	90                   	nop
80107737:	90                   	nop
80107738:	90                   	nop
80107739:	90                   	nop
8010773a:	90                   	nop
8010773b:	90                   	nop
8010773c:	90                   	nop
8010773d:	90                   	nop
8010773e:	90                   	nop
8010773f:	90                   	nop

80107740 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107740:	55                   	push   %ebp
80107741:	89 e5                	mov    %esp,%ebp
80107743:	57                   	push   %edi
80107744:	56                   	push   %esi
80107745:	53                   	push   %ebx
80107746:	83 ec 1c             	sub    $0x1c,%esp
80107749:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010774c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010774f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107752:	85 db                	test   %ebx,%ebx
80107754:	75 40                	jne    80107796 <copyout+0x56>
80107756:	eb 70                	jmp    801077c8 <copyout+0x88>
80107758:	90                   	nop
80107759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107760:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107763:	89 f1                	mov    %esi,%ecx
80107765:	29 d1                	sub    %edx,%ecx
80107767:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010776d:	39 d9                	cmp    %ebx,%ecx
8010776f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107772:	29 f2                	sub    %esi,%edx
80107774:	83 ec 04             	sub    $0x4,%esp
80107777:	01 d0                	add    %edx,%eax
80107779:	51                   	push   %ecx
8010777a:	57                   	push   %edi
8010777b:	50                   	push   %eax
8010777c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010777f:	e8 6c d3 ff ff       	call   80104af0 <memmove>
    len -= n;
    buf += n;
80107784:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107787:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010778a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107790:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107792:	29 cb                	sub    %ecx,%ebx
80107794:	74 32                	je     801077c8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107796:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107798:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010779b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010779e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801077a4:	56                   	push   %esi
801077a5:	ff 75 08             	pushl  0x8(%ebp)
801077a8:	e8 53 ff ff ff       	call   80107700 <uva2ka>
    if(pa0 == 0)
801077ad:	83 c4 10             	add    $0x10,%esp
801077b0:	85 c0                	test   %eax,%eax
801077b2:	75 ac                	jne    80107760 <copyout+0x20>
  }
  return 0;
}
801077b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801077b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801077bc:	5b                   	pop    %ebx
801077bd:	5e                   	pop    %esi
801077be:	5f                   	pop    %edi
801077bf:	5d                   	pop    %ebp
801077c0:	c3                   	ret    
801077c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801077cb:	31 c0                	xor    %eax,%eax
}
801077cd:	5b                   	pop    %ebx
801077ce:	5e                   	pop    %esi
801077cf:	5f                   	pop    %edi
801077d0:	5d                   	pop    %ebp
801077d1:	c3                   	ret    
