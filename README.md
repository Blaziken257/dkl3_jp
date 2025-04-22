# Donkey Kong GB: Dinky Kong & Dixie Kong disassembly

This is a partial diassembly which builds a ROM of Donkey Kong GB: Dinky Kong & Dixie Kong (the Japanese GBC-only version of Donkey Kong Land III) with bug fixes and enhancements. This does not build the retail GB-only English versions.

This is a work in progress; while there is already an English patch of the game that contains bug fixes and enhancements, it is a direct ROM edit, so this aims to have a proper disassembly of the patch.

This branch does not changes related to translating the text; see the `tr_en` branch for that.

# Building

To build, you need:

- A retail ROM in `baseroms/baserom_dkl3_jp.gbc`. This disassembly does not provide one so you must dump it yourself. The md5sum is `22AFE691095C65F34AEABA3C283B2A9C`
- rgbds. This was built for version 0.9.1 so older versions are unsupported.

The output ROM will be found in `build/dkl3_plus.gbc`.
