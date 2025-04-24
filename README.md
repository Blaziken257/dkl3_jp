# Donkey Kong GB: Dinky Kong & Dixie Kong disassembly

This is a partial diassembly which builds a ROM of Donkey Kong GB: Dinky Kong & Dixie Kong (the Japanese GBC-only version of Donkey Kong Land III). This does not build the retail GB-only English versions.

For ROM hacks, view the following branches:

- `tr_en`: Intended to be an English translation of the game.
- `dkl3_plus`: Bug fixes and enhancements from the original game.

Note that there is already a ROM hack that translates the text to English and contains bug fixes and enhancements (which can be found on RHDN). However, the hack is a **direct edit of the ROM**, making it difficult to maintain. This disassembly intends to recreate the hack from scratch, for documentation purposes, and to make it possible for others to use the hacks as a base.

# Building

To build, you need:

- A retail ROM in `baseroms/dkl3_jp.gbc`. This disassembly does not provide one so you must dump it yourself. The md5sum is `22AFE691095C65F34AEABA3C283B2A9C`
- rgbds. This was built for version 0.9.1 so older versions are unsupported.

The output ROM will be found in `build/dkl3_jp.gbc`.
