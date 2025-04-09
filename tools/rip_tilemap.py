#!/usr/bin/env python3
import sys
import struct

# import pdb;pdb.set_trace()
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

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python3 rip_tilemap.py <rom_file> <bank> <offset>", file=sys.stderr)
        sys.exit(1)

    rom_path = sys.argv[1]
    bank = int(sys.argv[2], 0)
    offset = int(sys.argv[3], 0)

    rip_tilemap(rom_path, bank, offset)
