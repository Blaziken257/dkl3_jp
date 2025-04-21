include "registers.inc"

SECTION "Map Animation Routine", ROM0[$125D]
    ld   a, $05
    ld   [REG_MBC5_ROMBANK], a
    call MapAnimCallback

SECTION "Map Animation Callback", ROMX[$4910], BANK[$05]
MapAnimCallback:
; The subroutine to animate maps is still present in the Japanese version, but was reduced to a "ret" instruction.
; This has its origins in a Japanese prototype, part of the September 2020 Gigaleak, where there wasn't enough ROM space for this.
; (The Japanese prototype was still 512 KB, and expanded credits, which are in the same bank. For whatever reason, even though the final
; Japanese version was doubled to 1 MB, the missing code wasn't restored!)
    ret
