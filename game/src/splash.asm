INCLUDE "registers.inc"

SECTION "Splash Screen Tiles", ROMX[$4001], BANK[$24]
SplashScreen::
    INCBIN "build/gfx/tilesets/splash.2bpp"

SECTION "Splash Screen Tilemap", ROMX[$5001], BANK[$24]
splash_screen_tilemap:
    db $20, $20 ; Width, height (in tiles)
    INCBIN "build/gfx/tilemaps/splash_tmap.tmap"

SECTION "Splash Screen Colormap", ROMX[$5403], BANK[$24]
splash_screen_colormap:
    db $20, $20 ; Width, height (in tiles)
    INCBIN "build/gfx/colormaps/splash_color_tmap.tmap"

