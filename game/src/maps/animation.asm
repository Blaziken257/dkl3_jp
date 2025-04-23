include "registers.inc"

SECTION "Map Animation Routine", ROM0[$125D]
    ld   a, $05
    ld   [REG_MBC5_ROMBANK], a
    call MapAnimCallback

SECTION "Map Animation Callback", ROMX[$4910], BANK[$05]
MapAnimCallback:
; The subroutine to animate maps is still present in the Japanese version, but was reduced to a "ret" instruction.
; This has its origins in a Japanese prototype, part of the September 2020 Gigaleak, where there wasn't enough ROM space for this.
; (The Japanese prototype was still 512 KB, and added Japanese names to the credits, which are in the same bank. For whatever reason,
; even though the final Japanese version was doubled to 1 MB, the missing code wasn't restored!)
; A similar situation exists with the Time Attack screen.
; The Japanese prototype has the dummied code at 5:483E, and is called from 0:12A8-12AF.
    ret
