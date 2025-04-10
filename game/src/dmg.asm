INCLUDE "registers.inc"

SECTION "DMG Screen Tiles", ROMX[$5845], BANK[$23]
DMGScreen::
    INCBIN "build/gfx/tilesets/dmg.2bpp"

SECTION "DMG Screen Tilemap", ROMX[$6845], BANK[$23]
dmg_screen_tilemap:
    db $20, $20 ; Width, height (in tiles)
    INCBIN "build/gfx/tilemaps/dmg_tmap.tmap"

; Since this is DMG only, there is no colormap!