INCLUDE "registers.inc"

DEF FILE_1 EQU $A000
DEF FILE_2 EQU $A050
DEF FILE_3 EQU $A0A0

SECTION "Main", ROM0[$0150]
Main::
    ld sp, $DFFF
    cp $11
    ld a, BANK(DMG_ERR_MSG)
    ld [REG_MBC5_ROMBANK], a
    jp nz, DMG_ERR_MSG


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
    call CopyFile        ; Copy from second (valid) block to first block
                         ; BUG: CopyFile pops the return address as the destination address
    jr .ValidFile
    
.CheckThirdBlock
    inc h               ; Checksum of second block fails. Check third and final block.
    call VerifyChecksum
    jr nz, .EraseFile
    call CopyFile        ; Copy from third (valid) block to first block
                         ; BUG: CopyFile pops the return address as the destination address
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
    
CopyFile::               ; Originally buggy in both DKL2 and DKL3 because the stack was pushed and popped in the wrong order.
                         ; pop bc; push bc were removed below from patch to fix copying bug, and moved to precede call CopyFile
    pop bc               
    push bc              ; BUG: This subroutine was intended to use hl as the source address and bc as the destination address, but instead, bc is the return address of this subroutine. Therefore, if a file is corrupted, but a backup copy has a valid checksum, this subroutine that was intended to recover a corrupted save does nothing!
                         ; This bug also exists in DKL2.
                         ; To fix this, remove the push bc/pop bc in this subroutine and place it before every call of CopyFile.
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

SECTION "DMG error message", ROMX[$6C47], BANK[$23]
DMG_ERR_MSG::
; Stubbed for now
