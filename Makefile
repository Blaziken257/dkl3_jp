.PHONY: all clean

BASE_DIR := baserom
BUILD_DIR := build
ROM_NAME := dkl3_jp
PATCH_ROM_NAME = dkl3_en
ROM := $(BUILD_DIR)/$(PATCH_ROM_NAME).gbc
BASEROM := $(BASE_DIR)/$(ROM_NAME).gbc

TILESETS := dkl3_title splash dmg charset
TILEMAPS := title splash dmg
COLORMAPS := title splash

# Paths to source graphics
PNG_FILES := $(foreach t,$(TILESETS),gfx/tilesets/$(t).png)
2BPP_FILES := $(foreach t,$(TILESETS),$(BUILD_DIR)/gfx/tilesets/$(t).2bpp)

CSV_TMAP_FILES := $(foreach t,$(TILEMAPS),gfx/tilemaps/$(t)_tmap.csv)
TMAP_FILES := $(foreach t,$(TILEMAPS),$(BUILD_DIR)/gfx/tilemaps/$(t)_tmap.tmap)

CSV_COLORMAP_FILES := $(foreach c,$(COLORMAPS),gfx/colormaps/$(c)_color_tmap.csv)
COLORMAP_FILES := $(foreach c,$(COLORMAPS),$(BUILD_DIR)/gfx/colormaps/$(c)_color_tmap.tmap)
	
ASM_SRC := $(wildcard game/src/*.asm)
OBJS := $(patsubst game/src/%.asm,$(BUILD_DIR)/game/src/%.o,$(ASM_SRC))

# Rule for building the final ROM
$(ROM): $(OBJS)
	@echo "Linking ROM"
	rgblink -n $(ROM:.gbc=.sym) -m $(ROM:.gbc=.map) -O $(BASEROM) -o $@ $^
	rgbfix -v -C -k 01 -l 0x33 -m 0x1B -p 0 -n 0 -r 2 -t "DONKEY KONG" -i "AD3J" $@
	@echo "Built $@"

$(BUILD_DIR)/game/src/%.o: game/src/%.asm
	@mkdir -p $(dir $@)
	rgbasm -o $@ $<

# Convert .png to .2bpp
$(BUILD_DIR)/gfx/tilesets/%.2bpp: gfx/tilesets/%.png
	@mkdir -p $(dir $@)
	rgbgfx $< -o $@

# Convert tilemap .csv to .tmap
$(BUILD_DIR)/gfx/tilemaps/%_tmap.tmap: gfx/tilemaps/%_tmap.csv tools/build_tilemap.py
	@mkdir -p $(dir $@)
	python3 tools/build_tilemap.py $< > $@

# Convert colormap .csv to .tmap
$(BUILD_DIR)/gfx/colormaps/%_color_tmap.tmap: gfx/colormaps/%_color_tmap.csv tools/build_tilemap.py
	@mkdir -p $(dir $@)
	python3 tools/build_tilemap.py $< > $@

# Ensure ROM depends on assets
$(OBJS): $(2BPP_FILES) $(TMAP_FILES) $(COLORMAP_FILES)

# Clean up build directory
clean:
	@echo "Cleaning..."
	@rm -rf $(BUILD_DIR)
