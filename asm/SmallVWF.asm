 ; Telefang 2 Speed 8x8 font hack by Spikeman

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

; =======================
;  Jumps and other fixes
; =======================

.org 0x8136A0E ; routine that puts a character to the map
    ldr r2, =printChar+1    ; r2 is best variable to use for jump
    bx r2
    
.pool
    
.org 0x8136A22
    nop         ; stop tile incrementing on its own
    
.org 0x8136A2E
    ldr r3, =endString+1
    bx r3
.pool

; =============================
;  Jumps and fixes for numbers
; =============================

.org 0x8135958 ; prints first digit in a number
    ;add r0,r6,r0    ; r0 = number, r6 = 0x12BD - attribute for "0" with the right palette
    ;strh r0,[r4]    ; r4 = current vram address
    ;add r4,#2       ; increment tile
    ;mov r0,r7
    ;mov r1,#0x0A
    ldr r6, =printNum1+1
    bx r6
.pool

.org 0x8135970
    ldr r6, =printNum2+1
    bx r6
.pool

.org 0x813597E
    ldr r6, =printNumEnd+1
    bx r6
.pool

.org 0x8136B52
    ldr r6, =printNum4+1
    bx r6
.pool

.org 0x8136B14
    push r4-r7,r14      ; change this to push r7 as well so printNum3 can be reused
.org 0x8136B1A
    ldr r5,[sp,0x14]    ; add 4 to each of these to compensate for r7
    ldr r0,[sp,0x18]

.org 0x8136B60
    ldr r6, =printNumEnd+1
    bx r6
.pool

; =================
;  Actual VWF code
; =================
    
.org 0x87f3b00 ; should be free space to put code (might change if other VWF routine is extended)
.area 0x87f3c50 - 0x87f3b00 ; make sure this doesnt overflow into FixStatsMenu code
printNum1:
    ; r0 is the digit to print
    bl printNum
    mov lr,r1
    
    ldr r1, [printNum1_returnAddr]
    bx r1
    
printNum2:
    bl printNum
    mov lr,r1
    
    ldr r1, [printNum2_returnAddr]
    bx r1
    
; routine for 2 digit number printing, I'm sure all these printNums can be combined somehow
printNum4:
    bl printNum
    mov lr,r1
    
    ; overwritten code
    ;mov r0,r7     ; in printNum
    mov r1,#0x0A   ; this DOESNT happen on return
    
    ldr r3, [printNum4_returnAddr]  ; since r1 is set to 0A, r3 should always be overwritten in call after return
    bx r3
    
; print last char and return, used in two places
printNumEnd:
    bl printNum
    ;mov lr,r1  ; irrelevant
    
    ; end of string - reset overflow
    ldrb r4,[r2]    ; r2 = 3000000
    add r4,r4,#1
    strb r4,[r2]
    mov r4, #0
    strb r4,[r2,#1]
    
    ; overwritten code
    pop r4-r7
    pop r0
    bx r0   ; return from original routine
    
printNum:
    mov r1,0x60     ; zero character in font is 0x60
    add r1,r0,r1
    mov r0,#8       ; stack offset
    push lr
    bl putChar      ; pretty sure r2 isn't used before being overwritten, if not wrap this in push/pop
    
    mov r0,#0xE2    ; overwritten code
    lsl r0,r0,#8
    add r1,r1,r0    ; add 0xE200, 0xE000 = black palette, 0x200 = vram offset
    strh r1,[r4]    ; print tile, r4 = current vram
    
    ; overwritten code
    mov r0,r7   ; doesnt happen in printNumEnd, but doesn't matter - it's overwritten
    pop r1      ; store lr in r1, since its free in all cases
    mov pc,lr
    
printChar:
    push lr
    mov r0, #0x0C       ; stack offset
    bl putChar

    mov r0,#0x80    ; overwritten code
    lsl r0,r0,#2
    add r1,r1,r0    ; r1 = char value
    and r1,r6       ; r1 = final tile value
    ldrh r2,[r3]    ; r2 = last attrib value - used to get palette
    
    pop r0
    mov lr,r0

    ldr r0, [returnAddr]    ; r0 overwritten upon return
    bx r0

putChar:
    ; r1 is the character to be drawn
    ; this routine prints the character to vram and returns the correct tile
    ; the game stores the returned value in the proper place in the tilemap

    ; r0 = stack offset for vram address, see note on hackyness in below code

    ldr r2,[tileCount]
    push r2-r7
    mov r6,r0       ;save stack offset
    mov r3,r2
    ldr r2,=smallFont
    ldrb r4,[r3]    ; r4 = tile count
    ldr r5,=widthTable
    ldrb r5,[r5,r1] ; get width
    mov r0,0x20
    mul r1,r0
    add r1,r1,r2    ; r1 is address of char in ROM
    mul r0,r4       ; r0 = VRAM offset
    ldr r2,[freeVRAM]
    add r2,r2,r0    ; r2 = VRAM address, r0 is free
    
    ;mov r5,#5       ; width table lookup will go here
    ldrb r7,[r3,#1] ; get overflow
    add r0,r7,r5
    cmp r0,#8
    ble NoOverflow  ; blt NoOverflow - this messed up when characters were 8 wide
    mov r5,#8
    sub r0,r0,r5
    add r4,r4,#1    ; increment tile count
    strb r4,[r3]
    ; ldrb r5,[r3,#3] ; stack offset - 0x08 for numbers, 0x0c for other menu, this is pretty hacky - change eventually
    ; r6 shouldn't be changed
    mov r5,sp
    ldr r4,[r5,r6] ; increment tilemap address
    add r4,r4,#2
    str r4,[r5,r6]
NoOverflow:
    strb r0,[r3,#1]
    
    lsl r0,r7,2     ;r0 = shift amount (<<2 because 4bpp)
    mov r4,#0x20
    add r3,r2,r4    ; r3 = overflow tile addr (this is kind of out of place, but it's a nice optimization)
    sub r4,r4,r0    ;r4 = background shift amount
    
    mov r5,#0       ; copy font data to vram
putLoop:
    ldr r6,[r1,r5]
    ldr r7,[r2,r5]
    lsl r6,r0
    lsl r7,r4
    lsr r7,r4
    orr r6,r7
    str r6,[r2,r5]
    
    ldr r6,[r1,r5]
    ldr r7,[r3,r5]
    lsr r6,r4
    lsr r7,r0
    lsl r7,r0
    orr r6,r7
    str r6,[r3,r5]
    
    add r5,r5,#4
    cmp r5,#0x20
    blt putLoop
    
    pop r2-r7
    ldrb r1,[r2]    ; r1 is tile number, original code will add 0x200
    ;add r1,r1,#1
    ;strb r1,[r3]    ; this will make it start on the second tile, so the background can use the space
    
    mov pc,lr        ; return, pray that lr isn't used
    
.align 4
returnAddr: .word 0x08136A18+1   ;.word 0x81369FC+1
printNum1_returnAddr: .word 0x8135960+1
printNum2_returnAddr: .word 0x8135978+1
printNum4_returnAddr: .word 0x8136B5C+1
tileCount:  .word 0x03000000     ; surprisingly this WRAM is usable, 03000001 will be overflow
freeVRAM:   .word 0x06008000     ; VRAM to load tiles into  (0x0600C000 is extra but wont work because bg base)
.pool

; replace the end of the string printing routine so we can reset the overflow to zero
; also increment the tile counter so each string starts on a fresh tile
endString:
    mov r3,#3
    lsl r3,r3,#0x18 ;set r3 to 0x03000000
    ldrb r4,[r3]
    add r4,r4,#1
    strb r4,[r3]
    mov r4, #0
    strb r4,[r3,#1]

    ;original code, don't bother jumping back, just end the routine
    add sp,#4
    pop r3,r4
    mov r8,r3
    mov r9,r4
    pop r4-r7
    pop r0
    bx r0
.endarea

.org 0x87FE850 ; note this extends past the end of the rom, this will overwrite menu gfx if nofont version isnt used
smallFont:
.incbin asm/bin/smallFont_vwf.bin   ;smallFont.bin
widthTable:
.incbin asm/bin/smallWidthTable.bin

.close

 ; make sure to leave an empty line at the end
