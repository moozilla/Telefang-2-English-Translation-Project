 ; Telefang 2 Speed 8x8 font hack by Spikeman
 ; -- this is the hacked routine before the VWF was added, saved for posterity

.gba				; Set the architecture to GBA
.open "rom/output.gba",0x08000000		; Open input.gba for output.
					; 0x08000000 will be used as the
					; header size
					
.macro adr,destReg,Address
here:
	.if (here & 2) != 0
		add destReg, r15, (Address-here)-2
	.else
		add destReg, r15, (Address-here)
	.endif
.endmacro

.org 0x8136A0E ; routine that puts a character to the map
    ldr r2, =putChar+1    ; r2 is best variable to use for jump
    bx r2
    
.pool
    
.org 0x87f3a00 ; should be free space to put code
putChar:
    push r3-r5
    
    ldr r2,=smallFont
    ldr r3,[tileCount]
    ldrb r4,[r3]    ; r4 = tile count
    mov r0,0x20
    mul r1,r0
    add r1,r1,r2    ; r1 is address of char in ROM
    mul r0,r4       ; r0 = VRAM offset
    ldr r2,[freeVRAM]
    add r2,r2,r0    ; r2 = VRAM address, r0 is free
    
    mov r5,#0       ; copy font data to vram
putLoop:
    ldr r0,[r1]
    str r0,[r2]     ; no dma because vwf will do stuff here
    add r1,r1,#4
    add r2,r2,#4
    add r5,r5,#1
    cmp r5,#8
    blt putLoop

    mov r1,r4       ;ldrb r1,[r3]    ; r1 is tile number, original code will add 0x200
    add r0,r1,#1    ; don't touch r1 after this
    strb r0,[r3]    ; increment tile count - VWF will do this differently
    ;add r1,r1,#1
    ;strb r1,[r3]    ; this will make it start on the second tile, so the background can use the space
    
    pop r3-r5
    
    mov r0,#0x80    ; overwritten code
    lsl r0,r0,#2
    add r1,r1,r0    ; r1 = char value
    ;and r1,r6       ; r1 = final tile value
    ldrh r2,[r3]    ; r2 = last attrib value - used to get palette

    ldr r0, [returnAddr]    ; r0 overwritten upon return
    bx r0
    
.align 4
returnAddr: .word 0x08136A18+1   ;.word 0x81369FC+1
tileCount:  .word 0x03000000     ; surprisingly this WRAM is usable
freeVRAM:   .word 0x06008000     ; VRAM to load tiles into  (0x0600C000 is extra but wont work because bg base)
.pool

.org 0x87FE850 ; note this extends past the end of the rom, this will overwrite menu gfx if nofont version isnt used
smallFont:
.incbin asm/bin/smallFont.bin

.close

 ; make sure to leave an empty line at the end
