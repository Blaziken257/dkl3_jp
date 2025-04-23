INCLUDE "registers.inc"
INCLUDE "macros.asm"

; Code to animate world maps, which is missing in the Japanese version
; (a holdover from the Japanese Sep. 2020 Gigaleak prototype, which didn't have enough ROM space to fit it).
; This actually takes the code present in the retail English version (starts at 5:614A there), including quirks like
; redundant "and" instructions, and ports it over here.
; All world maps are animated.

DEF wCurrentWorld EQU $FFAD
DEF wFrameCounter EQU $DE9E
DEF wMapAnimCounter EQU $DF8B

; Repoint the dummied subroutine to a new, empty bank, since there's ample empty space in the Japanese retail ROM
; (The prototype English ROM, retail English ROMs, and Japanese prototype ROM were all 512KB,
; but the retail Japanese ROM was doubled to 1MB).
SECTION "Map Animation Routine", ROM0[$125D]
    ld   a, $25
    ld   [REG_MBC5_ROMBANK], a
    call MapAnimCallback

SECTION "Map Animation Callback", ROMX[$4000], BANK[$25]
MapAnimCallback:
    ldh  a, [wCurrentWorld] ; ffad
    ld   hl, .MapTable
    add  a
    ld   c, a
    ld   b, 0
    add  hl, bc
    ldi  a, [hl]
    ld   l, [hl]
    ld   h, a
    jp   hl

.MapTable:
    dwbe MapAnim_Codswallop
    dwbe MapAnim_PrimatePlains
    dwbe MapAnim_Blackforest
    dwbe MapAnim_GreatLakes
    dwbe MapAnim_TinCanValley
    dwbe MapAnim_LostWorld
    dwbe MapAnim_NorthernKremisphere

SECTION "Map Animation - Cape Codswallop", ROMX[$401C], BANK[$25]
MapAnim_Codswallop:
    ld   a, [wFrameCounter]  ; DE9E
    and  $07
    and  a  ; Likely redundant since both of these and instructions, depending on the value,
            ; either set the z flag, or unset it. This was present in the original English version.
            ; This happens in other places as well.
            ; Eventually, this can be optimized in the future.
    jp   nz, .afterMillAnim

    ld   hl, wMapAnimCounter ; DF8B
    ld   a, [hl]
    inc  a
    cp   3
    jp   c, .storeNewCounter
    xor  a

.storeNewCounter:
    ld   [hl], a
    sla  a
    sla  a
    sla  a
    sla  a
    ld   b, 0
    ld   c, a
    ld   hl, $4F24
    add  hl, bc
    ld   d, $1F
    ld   bc, $9290
    ld   e, 1
    call $3309

    ld   b, 0
    ld   c, $30
    add  hl, bc
    ld   bc, $9370
    ld   e, 1
    ld   d, $1F
    call $3309

    ld   b, 0
    ld   c, $30
    add  hl, bc
    ld   bc, $9490
    ld   e, 1
    ld   d, $1F
    call $3311

.afterMillAnim:
    ld   bc, $8AA0
    ld   de, $8B70
    call MapAnim_SheepyShop
    call MapAnim_Water

    ld   a, [wFrameCounter]  ; DE9E
    and  $03
    cp   2
    jp   nz, .skipCrank
    call $3690
    ld   c, 0
    and  $03
    cp   1
    jp   nz, .skipOffset
    ld   c, $20

.skipOffset:
    ld   b, 0
    ld   hl, $5174
    add  hl, bc
    ld   bc, $9390
    ld   e, 1
    ld   d, $1F
    call $3309

    ld   b, 0
    ld   c, $10
    add  hl, bc
    ld   bc, $94C0
    ld   e, 1
    ld   d, $1F
    call $3311

.skipCrank:
    ret  

SECTION "Map Animation - Northern Kremisphere", ROMX[$41C5], BANK[$25]
MapAnim_NorthernKremisphere:
    jp   MapAnim_Water

SECTION "Map Animation - Primate Plains", ROMX[$40AC], BANK[$25]
MapAnim_PrimatePlains:
    ld   a, [wFrameCounter]
    and  3
    cp   2
    jp   nz, .PrimateLabel2
    call $3690
    ld   c, 0
    and  3
    cp   1
    jp   nz, .PrimateLabel1
    ld   c, $40

; TODO: Clarify labels
.PrimateLabel1:
    ld   b, 0
    ld   hl, $51B4
    add  hl, bc
    ld   bc, $9490
    ld   e, 2
    ld   d, $1F
    call $3309
    ld   b, 0
    ld   c, $20
    add  hl, bc
    ld   bc, $9550
    ld   e, 2
    ld   d, $1F
    call $3309

.PrimateLabel2:
    ld   a, [wFrameCounter]
    and  7
    and  a
    jp   nz, .PrimateLabel4
    ld   hl, wMapAnimCounter
    ld   a, [hl]
    inc  a
    cp   3
    jp   c, .PrimateLabel3
    xor  a

.PrimateLabel3:
    ld   [hl],a
    sla  a
    sla  a
    sla  a
    sla  a
    ld   b, 0
    ld   c, a
    ld   hl, $5274
    add  hl, bc
    ld   d, $1F
    ld   bc, $9400
    ld   e, 1
    call $3309
    ld   b, 0
    ld   c, $30
    add  hl, bc
    ld   bc, $94F0
    ld   e, 1
    ld   d, $1F
    call $3309
    ld   b, 0
    ld   c, $30
    add  hl, bc
    ld   bc, $95E0
    ld   e, 1
    ld   d, $1F
    call $3311

.PrimateLabel4:
    ld   a, [wFrameCounter]
    and  3
    and  a
    jp   nz, .PrimateLabel5
    call $3690
    ld   c, 0
    and  $0F
    cp   7
    jp   nz, .PrimateLabel6
    ld   c, $20

.PrimateLabel6:
    ld   b, 0
    ld   hl, $5304
    add  hl, bc
    ld   bc, $88E0
    ld   e, 2
    ld   d, $1F
    call $3309

.PrimateLabel5:
    jp   MapAnim_Water

SECTION "Map Animation - Blackforest Plateau", ROMX[$4159], BANK[$25]
MapAnim_Blackforest:
    ld   bc, $9550
    call MapAnim_Wrinkly
    ld   a, [wFrameCounter]
    and  3
    and  a
    jp   nz, $4195
    call $3690
    ld   c, 0
    and  $0F
    cp   7
    jp   nz, .BlackforestLabel
    ld   c, $30

.BlackforestLabel:
    ld   b, 0
    ld   hl, $5344
    add  hl, bc
    ld   bc, $9410
    ld   e, 2
    ld   d, $1F
    call $3309
    ld   b, 0
    ld   c, $20
    add  hl, bc
    ld   bc, $94E0
    ld   e, 1
    ld   d, $1F
    call $3309
    ld   bc, $88B0
    ld   de, $89D0
    call $422D
    jp   MapAnim_Water

SECTION "Map Animation - Great Ape Lakes", ROMX[$41A1], BANK[$25]
MapAnim_GreatLakes:
    ld   bc, $94E0
    ld   de, $95A0
    call MapAnim_Waterfall
    ld   bc, $8910
    call MapAnim_Wrinkly
    ld   bc, $8B00
    ld   de, $8B50
    call MapAnim_SheepyShop
    ld   bc, $9540
    ld   de, $95D0
    call MapAnim_FactorySmoke
    jp   MapAnim_Water

SECTION "Map Animation - The Lost World", ROMX[$41C8], BANK[$25]
MapAnim_LostWorld:
    ld   bc, $89B0
    ld   de, $89E0
    call MapAnim_SheepyShop
    ld   bc, $88E0
    call MapAnim_Wrinkly
    ld   bc, $92F0
    ld   de, $9370
    jp   MapAnim_FactorySmoke

SECTION "Map Animation - Tin Can Valley", ROMX[$41E0], BANK[$25]
MapAnim_TinCanValley:
    ld   bc, $9540
    ld   de, $9610
    call MapAnim_Waterfall
    ld   bc, $8BE0
    ld   de, $8CE0
    call MapAnim_SheepyShop
    ld   bc, $8C60
    call MapAnim_Wrinkly
    ld   bc, $9520
    ld   de, $95D0
    call MapAnim_FactorySmoke
    ; Slides into the water animation

SECTION "Map Animation - Waterfall", ROMX[$422D], BANK[$25]
MapAnim_Waterfall:
    ld   a, [wFrameCounter]
    and  7
    and  a
    ret  nz
    push de
    push bc
    ld   hl, wMapAnimCounter
    ld   a, [hl]
    inc  a
    cp   3
    jp   c, .WaterfallLabel
    xor  a

.WaterfallLabel:
    ld   [hl], a
    sla  a
    sla  a
    sla  a
    sla  a
    sla  a
    ld   b, 0
    ld   c, a
    ld   hl, $53A4
    add  hl, bc
    ld   d, $1F
    pop  bc
    ld   e, 1
    call $3309
    ld   b, 0
    ld   c, $10
    add  hl, bc
    pop  bc
    ld   e, 1
    ld   d, $1F
    jp   $3309

SECTION "Map Animation - Water", ROMX[$4201], BANK[$25]
MapAnim_Water:
    ld   hl, $DF8C
    ld   a, [hl]
    inc  a
    cp   12
    jp   nz, .WaterLabel1
    inc  hl
    inc  [hl]
    dec  hl
    xor  a

.WaterLabel1:
    ldi  [hl], a
    ld   a, [hl]
    and  3
    ld   hl, $5034
    ld   b, 0
    ld   c, $50

.WaterLabel2:
    and  a
    jp   z, .WaterLabel3
    dec  a
    add  hl, bc
    jp   .WaterLabel2

.WaterLabel3:
    ld   bc, $9010
    ld   e, 5
    ld   d, $1F
    jp   $3311


SECTION "Map Animation - Wrinkly Refuge", ROMX[$4268], BANK[$25]
MapAnim_Wrinkly:
    ld   a, [wFrameCounter]
    and  a, 3
    cp   a, 2
    ret  nz
    push bc
    call $3690
    ld   c, 0
    and  a, 3
    cp   a, 1
    jp   nz, .WrinklyLabel
    ld   c, $20

.WrinklyLabel:
    ld   b, 0
    ld   hl, $5234
    add  hl, bc
    pop  bc
    ld   e, 2
    ld   d, $1F
    jp   $3309

SECTION "Map Animation - Sheepy Shop", ROMX[$428D], BANK[$25]
MapAnim_SheepyShop:
    ld   a, [wFrameCounter]
    and  3
    and  a
    ret  nz
    push de
    push bc
    call $3690
    ld   c, 0
    and  $0F
    cp   7
    jp   nz, .SheepyLabel
    ld   c, $40

.SheepyLabel:
    ld   b, 0
    ld   hl, $4FB4
    add  hl, bc
    pop  bc
    ld   e, 2
    ld   d, $1F
    call $3309
    ld   b, 0
    ld   c, $20
    add  hl, bc
    pop  bc
    ld   e, $02
    ld   d, $1F
    jp   $3311
  
SECTION "Map Animation - Factory Smoke", ROMX[$42BF], BANK[$25]
MapAnim_FactorySmoke:
    push de
    push bc
    ld   c, 0
    ld   a, [wFrameCounter]
    and  $10
    jp   nz, .FactoryLabel
    ld   c, $30

.FactoryLabel:
    ld   b, 0
    ld   hl, $46EC
    add  hl, bc
    pop  bc
    ld   e, 1
    ld   d, $1F
    call $3309
    ld   b, 0
    ld   c, $10
    add  hl, bc
    pop  bc
    ld   e, 2
    ld   d, $1F
    jp   $3309
