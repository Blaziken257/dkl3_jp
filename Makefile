.PHONY: all clean

BASE_DIR := baserom
BUILD_DIR := build
ROM_NAME := dkl3_jp
PATCH_ROM_NAME = dkl3_en
ROM := $(BUILD_DIR)/$(PATCH_ROM_NAME).gbc
BASEROM := $(BASE_DIR)/$(ROM_NAME).gbc

PNG := gfx/tilesets/dkl3_title.png
2BPP := $(BUILD_DIR)/gfx/tilesets/dkl3_title.2bpp
CSV := gfx/tilemaps/title_tmap.csv
CSV_COLORMAP := gfx/colormaps/title_color_tmap.csv
TMAP := $(BUILD_DIR)/gfx/tilemaps/title_tmap.tmap
COLORMAP := $(BUILD_DIR)/gfx/colormaps/title_color_tmap.tmap

# Splash screen assets
SPLASH_PNG := gfx/tilesets/splash.png
SPLASH_2BPP := $(BUILD_DIR)/gfx/tilesets/splash.2bpp
SPLASH_CSV := gfx/tilemaps/splash_tmap.csv
SPLASH_COLORMAP_CSV := gfx/colormaps/splash_color_tmap.csv
SPLASH_TMAP := $(BUILD_DIR)/gfx/tilemaps/splash_tmap.tmap
SPLASH_COLORMAP := $(BUILD_DIR)/gfx/colormaps/splash_color_tmap.tmap

# Splash screen assets
SPLASH_PNG := gfx/tilesets/splash.png
SPLASH_2BPP := $(BUILD_DIR)/gfx/tilesets/splash.2bpp
SPLASH_CSV := gfx/tilemaps/splash_tmap.csv
SPLASH_COLORMAP_CSV := gfx/colormaps/splash_color_tmap.csv
SPLASH_TMAP := $(BUILD_DIR)/gfx/tilemaps/splash_tmap.tmap
SPLASH_COLORMAP := $(BUILD_DIR)/gfx/colormaps/splash_color_tmap.tmap

DMG_PNG := gfx/tilesets/dmg.png
DMG_2BPP := $(BUILD_DIR)/gfx/tilesets/dmg.2bpp
DMG_CSV := gfx/tilemaps/dmg_tmap.csv
DMG_TMAP := $(BUILD_DIR)/gfx/tilemaps/dmg_tmap.tmap
	
ASM_SRC := $(wildcard game/src/*.asm)
OBJS := $(patsubst game/src/%.asm,$(BUILD_DIR)/game/src/%.o,$(ASM_SRC))

# Rule for building the final ROM
$(ROM): $(OBJS)
	@echo "Linking ROM"
	rgblink -n $(ROM:.gbc=.sym) -m $(ROM:.gbc=.map) -O $(BASEROM) -o $@ $^
	rgbfix -v -C -k 01 -l 0x33 -m 0x1B -p 0 -n 0 -r 2 -t "DONKEY KONG" -i "AD3J" $@
	@echo "Built $@"

# Assemble .asm into .o
$(BUILD_DIR)/game/src/%.o: game/src/%.asm
	@mkdir -p $(dir $@)
	rgbasm $< -o $@

# Convert PNG to 2bpp
$(2BPP): $(PNG)
	@mkdir -p $(dir $@)
	rgbgfx $< -o $@

# Convert CSV to .tmap
$(TMAP): $(CSV) tools/build_tilemap.py
	@mkdir -p $(dir $@)
	python3 tools/build_tilemap.py $< > $@

# Convert CSV to .tmap
$(COLORMAP): $(CSV_COLORMAP) tools/build_tilemap.py
	@mkdir -p $(dir $@)
	python3 tools/build_tilemap.py $< > $@

$(SPLASH_2BPP): $(SPLASH_PNG)
	@mkdir -p $(dir $@)
	rgbgfx $< -o $@

$(SPLASH_TMAP): $(SPLASH_CSV) tools/build_tilemap.py
	@mkdir -p $(dir $@)
	python3 tools/build_tilemap.py $< > $@

$(SPLASH_COLORMAP): $(SPLASH_COLORMAP_CSV) tools/build_tilemap.py
	@mkdir -p $(dir $@)
	python3 tools/build_tilemap.py $< > $@

$(DMG_2BPP): $(DMG_PNG)
	@mkdir -p $(dir $@)
	rgbgfx $< -o $@

$(DMG_TMAP): $(DMG_CSV) tools/build_tilemap.py
	@mkdir -p $(dir $@)
	python3 tools/build_tilemap.py $< > $@

# Ensure ROM depends on assets
$(OBJS): $(2BPP) $(TMAP) $(COLORMAP) $(SPLASH_2BPP) $(SPLASH_TMAP) $(SPLASH_COLORMAP) $(DMG_2BPP) $(DMG_TMAP)

# Clean up build directory
clean:
	@echo "Cleaning..."
	@rm -rf $(BUILD_DIR)
