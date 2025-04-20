#!/usr/bin/env python3
import argparse

def rip_tilemap(filename, bank, offset):
    rom_offset = (bank * 0x4000) + (offset if offset < 0x4000 else offset - 0x4000)
    
    with open(filename, "rb") as f:
        f.seek(rom_offset)

        width = f.read(1)[0]
        height = f.read(1)[0]
        tile_count = width * height
        tilemap = f.read(tile_count)

    for y in range(height):
        row = tilemap[y * width:(y + 1) * width]
        print(",".join(str(tile) for tile in row))

def main():
    parser = argparse.ArgumentParser(description="Extract a tilemap from a Game Boy ROM.")
    parser.add_argument("rom_file", help="Path to the ROM file")
    parser.add_argument("bank", type=lambda x: int(x, 0), help="Bank number (e.g., 0x1F)")
    parser.add_argument("offset", type=lambda x: int(x, 0), help="Offset within the bank")

    args = parser.parse_args()

    rip_tilemap(args.rom_file, args.bank, args.offset)

if __name__ == "__main__":
    main()

# Recommended usage (example): python3 tools/rip_tilemap.py "rom.gbc" 0x21 0x4001 > gfx/tilemaps/tilemap.csv