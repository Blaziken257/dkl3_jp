#!/usr/bin/env python3
import csv
from pathlib import Path

ROM_PATH = "build/dkl3_jp.gbc"
POINTER_START = 0xA8DC
POINTER_END = 0xA953
BANK_NUM = 0x1F
BANK_ROM_OFFSET = BANK_NUM * 0x4000
BANK_BASE = 0x4000

class DKL3_Map_Rip:
    def __init__(self):
        pass
    def load_charmap(self):
        tile_to_char = {}
        chr_set = "あいうえおかきくけこさしすせそたちつてとなにねのはひふへほまみむめもやゆよらりるれろわをんがぎぐげござじずぜぞだでどばびぶべぼっゃゅょアイウカキクケコサシスセタチツテトナノフマミムラリルレロワングゲゴジズダデドバビブボプペポァィォッャュー〜ADGHKORSU!?ザ、上下左右行店赤海辺相丢命水川大穴足元子石雨山森台北失生活湖音向文字目先友役立的毛全部信?竹木?茶来時計力打気何秒オ入力0123456789がぎぱぷモ ニエ"
        tile_to_char = {i: c for i, c in enumerate(chr_set)}
        tile_to_char[0xff] = '\n'
        return tile_to_char

    def read_pointer(self, data, offset, endian="big"):
        return int.from_bytes(data[offset:offset+2], endian)

    def extract_text(self, data, rom_offset, mode="level"):
        if mode == "level":
            found_terminator = False
            vram_index = []
            i = rom_offset
            while not found_terminator:
                b = data[i]
                if b == 0xfe:
                    found_terminator = True
                elif b != 0xff:
                    vram_index.append(b)
                elif b == 0xff:
                    pass
                i += 1
            found_terminator = False
            level_chars = []
            # import pdb;pdb.set_trace()
            # Example: vram_index = [0x00, 0x00, 0x01, 0x02, 0x03, 0x04]
            while not found_terminator:
                ch = data[i]
                if ch == 0xff:
                    found_terminator = True
                else:
                    level_chars.append(ch)
                i += 1
            # import pdb;pdb.set_trace()
            # Example: level_chars = [0x4A, 0x17, 0x0C, 0x01, 0x29] 
            level_name_raw = [" "] * len(vram_index)  # Space is a placeholder
            for i, v in enumerate(vram_index):
                level_chr_raw = level_chars[v]
                level_chr = self.tile_to_char[level_chr_raw] 
                level_name_raw[i] = level_chr
            level_name = "".join(level_name_raw)
        return level_name
        
    def generate_level_names(self):
        
        self.tile_to_char = self.load_charmap()

        with open(ROM_PATH, "rb") as f:
            rom = f.read()

        pointer_count = (POINTER_END - POINTER_START) // 2
        rows = []

        for i in range(pointer_count):
            ptr_offset = POINTER_START + i * 2
            bank_ptr = self.read_pointer(rom, ptr_offset)
            rom_offset = BANK_ROM_OFFSET + (bank_ptr - BANK_BASE)
            try:
                level_name = self.extract_text(rom, rom_offset)
            except IndexError as e:
                print(f"Error reading string #{i} at ROM ${rom_offset:04X}: {e}")
                continue

            # text = "".join(tile_to_char.get(b, f"[{b:02X}]") for b in expanded_tile_bytes)
            rows.append((i, level_name))
        import pdb;pdb.set_trace()

        # Write to CSV
        csv_path = Path('./text/level_names.csv')
        csv_path.parent.mkdir(parents=True, exist_ok=True)
        with open("./text/level_names.csv", "w", newline='', encoding="utf-8") as f:
            writer = csv.writer(f)
            writer.writerow(["ID", "Japanese"])
            writer.writerows(rows)


    # index_list = []
    # i = 0
    # while i < len(data) and data[i] != 0xFE:
    #     index_list.append(data[i])
    #     i += 1

    # if i >= len(data):
    #     raise IndexError("0xFE terminator not found in index list")

    # i += 1  # skip 0xFE

    # char_table = []
    # while i < len(data) and data[i] != 0xFF:
    #     char_table.append(data[i])
    #     i += 1

    # if i >= len(data):
    #     raise IndexError("0xFF terminator not found in char table")

    # # Expand using char table
    # try:
    #     expanded = [char_table[idx] for idx in index_list]
    # except IndexError:
    #     raise IndexError(f"Index in index_list exceeds char_table length: {index_list} vs {char_table}")

    # return expanded

def main():
    x = DKL3_Map_Rip()
    x.generate_level_names()

if __name__ == "__main__":
    main()
