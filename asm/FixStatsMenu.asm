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

; translate some strings - do this differently later
.org 0x809D758
    .byte 0x22, 0x0C, 0x01, 0x17    ; Claw
.org 0x809D5E0
    .byte 0x25, 0x09, 0x12, 0x05, 0x02, 0x01, 0x0C, 0x0C    ; Fireball
.org 0x809D5D0
    .byte 0x7C, 0x7C, 0x7C, 0x7C    ; ????
.org 0x809DD50
    .byte 0x2D, 0x0F, 0x12, 0x0D, 0x01, 0x0C    ; Normal
.org 0x809DD58
    .byte 0x25, 0x0C, 0x01, 0x0D, 0x05          ; Flame
.org 0x809DD98
    .byte 0x7C, 0x7C, 0x7C, 0x7C   ; ????
.org 0x809D3A8
    .byte 0x2C, 0x05, 0x01, 0x04, 0x1F, 0x17, 0x13    ; Meadows = Grassland
.org 0x809D3E0
    .byte 0x22, 0x01, 0x12, 0x05, 0x06, 0x12, 0x05, 0x05    ; Carefree
.org 0x809D4B8
    .byte 0x33, 0x01, 0x0B, 0x05, 0x04, 0x01, 0x0D, 0x01 ; Takedama = Takedama Forest
    
.org 0x8136680
    ldr r1, =printTitles+1
    bx r1
.pool

;.org 0x8136A38  ; this is free because of SmallVWF
;    bl 0x813698C

; This routine will print the previous hardcoded menu titles
.org 0x87f3c00  ; may get overwritten if too much more is added to SmallVWF
printTitles:
    mov r3,#3
    lsl r3,r3,#0x18         ; set r3 to 0x03000000 (tile counter in vwf)
    mov r1,#1
    str r1,[r3]             ; initialize tile counter to 1 and overflow to 0
    
    push r0-r7 
    
    ldr r0,=string1
    mov r1, #0              ; string # - 0 because I'm using base as a pointer
    mov r2, #8              ; length of strings in block 
    str r2, [sp]            ; these overwrite r0-r2 but they aren't important
    mov r2, #2              ; map #?
    str r2, [sp, #4]
    mov r2, #1              ; palette - 1 is title palette E is normal
    str r2, [sp, #8]
    mov r2, #0x11           ; x ?
    mov r3, #0              ; y ?
    bl printStr
    
    ldr r0,=string2
    mov r1, #0              ; "Personality"
    mov r2, #11             ; length
    str r2, [sp]
    mov r2, #2
    str r2, [sp, #4]
    mov r2, #1              ; palette
    str r2, [sp, #8]
    mov r2, #0x11           ; x
    mov r3, #3              ; y
    bl printStr
    
    ldr r0,=string3
    mov r1, #0              ; "Birthplace"
    mov r2, #10             ; length
    str r2, [sp]
    mov r2, #2
    str r2, [sp, #4]
    mov r2, #1              ; palette
    str r2, [sp, #8]
    mov r2, #0x11           ; x
    mov r3, #6              ; y
    bl printStr
    
    ldr r0,=string4
    mov r1, #0              ; "Attacks"
    mov r2, #7              ; length
    str r2, [sp]
    mov r2, #2
    str r2, [sp, #4]
    mov r2, #1              ; palette
    str r2, [sp, #8]
    mov r2, #0x11           ; x
    mov r3, #9              ; y
    bl printStr
    
    ldr r0,=string5
    mov r1, #0              ; "Stats   "
    mov r2, #8              ; length
    str r2, [sp]
    mov r2, #2
    str r2, [sp, #4]
    mov r2, #1              ; palette
    str r2, [sp, #8]
    mov r2, #0x4            ; x
    mov r3, #0xE            ; y
    bl printStr
    
    ldr r0,=string6
    mov r1, #0              ; "Speed   "
    mov r2, #8              ; length
    str r2, [sp]
    mov r2, #2
    str r2, [sp, #4]
    mov r2, #0x0E           ; palette - black
    str r2, [sp, #8]
    mov r2, #0x0E           ; x - was originally 0F, might need to adjust
    mov r3, #0x0F           ; y
    bl printStr
    
    ldr r0,=string4
    mov r1, #0              ; "Attack"
    mov r2, #6              ; length
    str r2, [sp]
    mov r2, #2
    str r2, [sp, #4]
    mov r2, #0x0E           ; palette - black
    str r2, [sp, #8]
    mov r2, #0x0E           ; x
    mov r3, #0x10           ; y
    bl printStr
    
    ldr r0,=string8
    mov r1, #0              ; "Defense"
    mov r2, #7              ; length
    str r2, [sp]
    mov r2, #2
    str r2, [sp, #4]
    mov r2, #0x0E           ; palette - black
    str r2, [sp, #8]
    mov r2, #0x0E           ; x
    mov r3, #0x11           ; y
    bl printStr
    
    ldr r0,=string9
    mov r1, #0              ; "Special"
    mov r2, #7              ; length
    str r2, [sp]
    mov r2, #2
    str r2, [sp, #4]
    mov r2, #0x0E           ; palette - black
    str r2, [sp, #8]
    mov r2, #0x0E           ; x
    mov r3, #0x12           ; y
    bl printStr
    
    ldr r0,=stringA
    mov r1, #0              ; "--" goes before attack types
    mov r2, #2              ; length
    str r2, [sp]
    mov r2, #2
    str r2, [sp, #4]
    mov r2, #0x0E           ; palette - black
    str r2, [sp, #8]
    mov r2, #0x17           ; x
    mov r3, #0x0A           ; y
    bl printStr
    
    ldr r0,=stringA
    mov r1, #0              ; "--" goes before attack types
    mov r2, #2              ; length
    str r2, [sp]
    mov r2, #2
    str r2, [sp, #4]
    mov r2, #0x0E           ; palette - black
    str r2, [sp, #8]
    mov r2, #0x17           ; x
    mov r3, #0x0B           ; y
    bl printStr
    
    ldr r0,=stringA
    mov r1, #0              ; "--" goes before attack types
    mov r2, #2              ; length
    str r2, [sp]
    mov r2, #2
    str r2, [sp, #4]
    mov r2, #0x0E           ; palette - black
    str r2, [sp, #8]
    mov r2, #0x17           ; x
    mov r3, #0x0C           ; y
    bl printStr
    
    ldr r0,=stringA
    mov r1, #0              ; "--" goes before attack types
    mov r2, #2              ; length
    str r2, [sp]
    mov r2, #2
    str r2, [sp, #4]
    mov r2, #0x0E           ; palette - black
    str r2, [sp, #8]
    mov r2, #0x17           ; x
    mov r3, #0x0D           ; y
    bl printStr
    
    ldr r0,=string2_1
    mov r1, #0              ; "Status"
    mov r2, #6              ; length
    str r2, [sp]
    mov r2, #3              ; bg3
    str r2, [sp, #4]
    mov r2, #0x01           ; palette
    str r2, [sp, #8]
    mov r2, #0x11           ; x
    mov r3, #0x00           ; y
    bl printStr
    
    ldr r0,=string2_2
    mov r1, #0              ; "Equipped Item"
    mov r2, #13             ; length
    str r2, [sp]
    mov r2, #3              ; bg3
    str r2, [sp, #4]
    mov r2, #0x01           ; palette 
    str r2, [sp, #8]
    mov r2, #0x11           ; x
    mov r3, #0x04           ; y
    bl printStr
    
    ldr r0,=string2_3
    mov r1, #0              ; "Friend"
    mov r2, #6              ; length
    str r2, [sp]
    mov r2, #3              ; bg3
    str r2, [sp, #4]
    mov r2, #0x01           ; palette
    str r2, [sp, #8]
    mov r2, #0x11           ; x
    mov r3, #0x08           ; y
    bl printStr
    
    ldr r0,=string2_4
    mov r1, #0              ; "Name"
    mov r2, #4              ; length
    str r2, [sp]
    mov r2, #3              ; bg3
    str r2, [sp, #4]
    mov r2, #0x01           ; palette
    str r2, [sp, #8]
    mov r2, #0x0F           ; x
    mov r3, #0x09           ; y
    bl printStr
    
    ldr r0,=string1
    mov r1, #0              ; "Type    "
    mov r2, #8              ; length
    str r2, [sp]
    mov r2, #3              ; bg3
    str r2, [sp, #4]
    mov r2, #0x01           ; palette
    str r2, [sp, #8]
    mov r2, #0x0F           ; x
    mov r3, #0x0C           ; y
    bl printStr
    
    pop r0-r7

    ldrh r0,[r0]            ; original code
    str r6,[sp]
    mov r1,r9
    mov r2,#0x12

    ldr r3, [returnAddr]    ; r0 overwritten upon return
    bx r3
    
printStr:   
    mov r6,lr               ; r6 is saved
    ldr r5, =callReturn+1
    mov lr,r5               ; store return address
    ldr r5, =0x813698C+1    ; call 0x813698C, hack because bl is out of range
    bx r5
callReturn:
    mov pc,r6
    
.align 4
returnAddr: .word 0x08136688+1
.pool
string1:
    .byte 0x33, 0x19, 0x10, 0x05, 0xF0, 0xF0, 0xF0, 0xF0 ; Type (spaces for trash)
string2:
    .byte 0x2F, 0x05, 0x12, 0x13, 0x0F, 0x0E, 0x01, 0x0C, 0x09, 0x14, 0x19 ; Personality
string3:
    .byte 0x21, 0x09, 0x12, 0x14, 0x08, 0x10, 0x0C, 0x01, 0x03, 0x05    ; Birthplace
string4:
    .byte 0x20, 0x14, 0x14, 0x01, 0x03, 0x0B, 0x13  ; Attacks
string5:
    .byte 0x32, 0x14, 0x01, 0x14, 0x13, 0xF0, 0xF0, 0xF0  ; Stats
string6:
    .byte 0x32, 0x10, 0x05, 0x05, 0x04, 0xF0, 0xF0, 0xF0  ; Speed
;string7:
    ;.byte 0x20, 0x14, 0x14, 0x01, 0x03, 0x0B ; Attack - use string 4
string8:
    .byte 0x23, 0x05, 0x06, 0x05, 0x0E, 0x13, 0x05 ; Defense
string9:
    .byte 0x32, 0x10, 0x05, 0x03, 0x09, 0x01, 0x0C ; Special
stringA:
    .byte 0x73, 0x73  ; --
string2_1:
    .byte 0x32, 0x14, 0x01, 0x14, 0x15, 0x13    ; Status
string2_2:
    .byte 0x24, 0x11, 0x15, 0x09, 0x10, 0x10, 0x05, 0x04, 0xF0, 0x28, 0x14, 0x04, 0x0D ; Equipped Item
string2_3:
    .byte 0x25, 0x12, 0x09, 0x05, 0x0E, 0x04    ; Friend
string2_4:
    .byte 0x2D, 0x01, 0x0D, 0x05    ; Name
;string2_5:
    ; use string1 for Type
    
.close

 ; make sure to leave an empty line at the end
