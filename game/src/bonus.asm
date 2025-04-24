INCLUDE "registers.inc"
INCLUDE "constants.asm"
; RAM addresses
DEF wStageType EQU $C5ED
DEF wBonusTimer EQU $C5EE
DEF wBonusObjCounter EQU $C5EF ; Stars/enemies
DEF wSoundEffect EQU $DF57

; Level/bonus stage IDS
DEF M_Bonus_FindToken EQU 0
DEF M_Bonus_CollectStars EQU 1
DEF M_Bonus_Bash_Baddies EQU 2
DEF M_WarpArea EQU 3
DEF M_LevelAfterBonus EQU 254 ; Normal level after leaving bonus stage
DEF M_LevelNormal EQU 255

; TODO: Banana collecting code seems to start at 0:208F

SECTION "Banana/Star Collected", ROM0[$2149]
BananaCollected:
    ld   a, [wStageType]
    cp   M_Bonus_CollectStars ; Check if stage type is Collect the Stars
    ; (Note that this checking is different from DKL2, which checks if not FF. This means that no Collect the Stars stages in that game have enemies
    ; This was addressed in DKL3, and no longer has a bug where collecting bananas after losing a bonus can trigger a Kremkoin chime)
    jr   nz, .NotStarBonus ; Seems to affect when a Bonus Coin can appear (since they're only meant to appear in bonus stages)
    ld   hl, wBonusObjCounter ; If stage type == Collect the Stars, then check if star/enemy counter is 0 
    ld   a, [hl]
    and  a ; If not 0, decrement
    jr   z, .NotStarBonus
    sub  1 ; Would be more efficient to use dec a here
    daa  
    ld   [hl], a
    and  a
    jr   nz, .NotStarBonus
    ld   a, $0E ; If bonus object counter transitions from 1 to 0, play Bonus Coin chime (same as extra life sound effect)
    ld   [wSoundEffect], a
.NotStarBonus:
    ld   hl, BANANA_COUNTER
    ; TODO: Move the HRAM bytes into a separate file!!
    ld   a, [hl]
    cp   $99 ; 99 bananas; game uses BCDs frequently
    jr   nz, .100bananas
    xor  a
    ld   [hl], a
    ld   hl, LIFE_COUNTER
    ld   a, [hl]
    inc  a
    jr   z, $2103
    ld   [hl], a
    jr   $2103
.100bananas:
    add  1 ; Would be more efficient to use inc a here
    daa  
    ld   [hl], a
    jr   $2103

; TODO: Enemy code seems to start at 0:2581

SECTION "Enemy Defeated", ROM0[$259C]
EnemyDefeated:
    ld   l, e
    ld   e, l
    ld   a, l ; hl = C100 + sprite * 2
    add  $17
    ld   l, a ; hl = C100 + sprite * 2 + 0x17
    bit  4, [hl] ; Unsure what this check does; sprite defeated/disappeared?
    ld   l, e
    jr   z, $25C4 ; If check doesn't match, skip rest of code
    ld   a, [wStageType] ; Check if stage type == Collect the Stars
; BUG: Losing a bonus stage (or soft-resetting during one) doesn't reset the enemy/star counter.
; This means that defeating an enemy in either situation will decrement the counter.
; Once it reaches zero, the Bonus Coin chime sound effect will play.
; A fix would involve checking if the stage type != Bash the Baddies!
;
; A similar bug exists in the English version of DKL2, but differs in two ways:
; 1. The bug ALSO exists when collecting bananas
; 2. The bug DOESN'T exist after soft-resetting during a bonus stage.
; DKL2 checks if stage type != $FF when defeating an enemy or collecting a banana in a main level, but after leaving a bonus stage, stage type is $FE.
; The Japanese version of DKL2 resets the star/enemy counter ($C5F9 in that game) to 0 when losing a bonus stage, but this fix didn't make it in any version of DKL3.
;
; All versions of DKL2 also has a quirk where this check (stage type != $FF) makes it so that Collect the Stars stages don't have enemies,
; and that Destroy them All stages don't have stars.
; Since these checks differ in DKL3, this issue is not present in this game.
    cp   M_Bonus_CollectStars 
    jr   z, $25E9 ; If current stage type != Collect the Stars, skip rest of code
    ld   a, [wBonusObjCounter] ; Otherwise, check if star (banana) / enemy counter is 0
    and  a 
    jr   z, $25E9 ; If counter is zero, skip rest of code
    sub  1 ; Would be more efficient to use dec a here
    daa  
    ld   [wBonusObjCounter], a ; If not zero, decrement
    and  a
    jr   nz, $25E9
    ld   a, $0E ; If bonus object counter transitions from 1 to 0, play Bonus Coin chime (same as extra life sound effect)
    ld   [wSoundEffect], a
    jr   $25E9 

; 25E9 seems irrelevant to bonus stuff