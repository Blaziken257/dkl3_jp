INCLUDE "registers.inc"

SECTION "Title Screen Tiles", ROMX[$4001], BANK[$23]
TitleScreen::
    INCBIN "build/gfx/tilesets/dkl3_j_title.2bpp"

SECTION "Title Screen Tilemap", ROMX[$5001], BANK[$23]
title_screen_tilemap:
    db $20, $20 ; Width, height (in tiles)
    INCBIN "build/gfx/tilemaps/title_tmap.tmap"
