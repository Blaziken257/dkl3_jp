INCLUDE "registers.inc"

DEF FILE_1 EQU $A000
DEF FILE_2 EQU $A050
DEF FILE_3 EQU $A0A0

SECTION "Main - Load Saves", ROM0[$0160]
MainSaves::
    ld a, BANK(LoadSaves)
    ld [REG_MBC5_ROMBANK], a
    call LoadSaves
    
SECTION "Load Saves", ROMX[$75A7], BANK[$3]
LoadSaves::
    ld hl, FILE_1
    call CheckFile
    ld hl, FILE_2
    call CheckFile
    ld hl, FILE_3
    
CheckFile::
    push hl
    call VerifyChecksum
    jr z, .ValidFile
    inc h                ; Checksum of first block fails. Check second block.
    call VerifyChecksum
    jr nz, .CheckThirdBlock
    pop  bc              ; Bugfix: Pop and push bc BEFORE calling CopyFile!
    push bc              ; This also means remove these instructions at the start of CopyFile.
    call CopyFile        ; Copy from second (valid) block to first block
                         ; Bugfix: CopyFile now pops the address for the currently corrupted copy as the destination address
    jr .ValidFile
    
.CheckThirdBlock
    inc h               ; Checksum of second block fails. Check third and final block.
    call VerifyChecksum
    jr nz, .EraseFile
    pop  bc              ; Same bugfix applies here
    push bc
    call CopyFile        ; Copy from third (valid) block to first block
                         ; Bugfix: CopyFile now pops the address for the currently corrupted copy as the destination address
    jr .ValidFile
    
.EraseFile
    pop hl              ; Checksum of all three blocks fail. Erase the file. This is actually implemented properly!
    push hl
    ld a, $0A
    ld [REG_MBC5_SRAMENABLE], a
    xor a
    ld e, $50
.EraseLoop
    ldi [hl], a
    dec e
    jr nz, .EraseLoop
    xor a
    ld [REG_MBC5_SRAMENABLE], a
    
.ValidFile
    pop hl              ; Checksum of one of the blocks is valid, and a valid block has previously been copied to block 1 (if necessary).
    push hl
    ld b, h
    inc b
    ld c, l
    call CopyFile        ; Copy from valid block 1 to block 2
    pop hl
    ld b, h
    ld c, l
    inc b
    inc b               ; Copy from valid block 1 to block 3
    jp CopyFile         ; Moved to empty space, since this entire fix requires more bytes
    nop  ; Since CopyFile was moved elsewhere, fill the original space with zeros
    nop  
    nop  
    nop  
    nop  
    nop  
    nop  
    nop  
    nop  
    nop  
    nop  
    nop  
    nop  


; Need a section (unlike the original ROM since this subroutine was moved to empty space
; to accommodate that the bugfix requires extra space)
SECTION "Copy File", ROMX[$7A00], BANK[$3]
CopyFile::               ; Buggy in both DKL2 and DKL3 because the stack was pushed and popped in the wrong order.
                         ; pop bc; push bc were removed below from English patch to fix copying bug, and moved to precede call CopyFile
                         ; REMOVED pop bc and push bc instructions; now these appear before a call when necessary
    ld a, $0A
    ld [REG_MBC5_SRAMENABLE], a
    ld e, $50
.CopyFileLoop
    ldi a, [hl]
    ld [bc], a
    inc bc
    dec e
    jr nz, .CopyFileLoop
    xor a
    ld [REG_MBC5_SRAMENABLE], a
    ret  

; Same location as in original ROM
SECTION "Verify Checksum", ROMX[$7605], BANK[$3]
VerifyChecksum::
    push hl
    ld a, $0A
    ld [REG_MBC5_SRAMENABLE], a
    ldi a, [hl]
    ld b, a
    ldi a, [hl]
    ld c, a
    push bc
    ld b, $00
    ld e, $4E
    xor a
.ChecksumLoop
    add [hl]
    jr nc, .Overflow_8bit
    inc b
.Overflow_8bit
    inc hl
    dec e
    jr nz, .ChecksumLoop
    ld c, a
    xor a
    ld [REG_MBC5_SRAMENABLE], a
    pop hl
    ld a, h
    cp b
    jr z, .HighByteMatch
    pop hl
    ret  
.HighByteMatch
    ld a, l
    cp c
    pop hl
    ret  
