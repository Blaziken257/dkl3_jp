.PHONY: all clean compare_roms

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

ASM_SRC := $(wildcard game/src/*.asm)
OBJS := $(patsubst game/src/%.asm,$(BUILD_DIR)/game/src/%.o,$(ASM_SRC))

# Default target
all: $(ROM) compare_roms

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

# Ensure ROM depends on assets
$(OBJS): $(2BPP) $(TMAP) $(COLORMAP)

# Clean up build directory
clean:
	@echo "Cleaning..."
	@rm -rf $(BUILD_DIR)
