---
name: bambu-studio
description: Slice models and send prints to a Bambu Lab P1S with no GUI. Use when asked to slice an STL/3MF, estimate print time or filament, or start a print.
---

# Bambu Studio, headless

```sh
B=/Applications/BambuStudio.app/Contents/MacOS/BambuStudio
P=/Applications/BambuStudio.app/Contents/Resources/profiles/BBL
U=~/Library/Application\ Support/BambuStudio/user/<id>   # user presets
```

## Slice

```sh
$B --debug 1 --orient 1 --arrange 1 \
  --load-settings "$P/machine/Bambu Lab P1S 0.4 nozzle.json;$P/process/0.20mm Standard @BBL X1C.json" \
  --load-filaments "$P/filament/Bambu PLA Basic @BBL X1C.json" \
  --slice 0 --outputdir "$PWD/out" --export-3mf part.gcode.3mf "$PWD/part.stl"
```

- Use absolute paths. Relative ones fail on 3MF export.
- P1S uses the `@BBL X1C` process and filament profiles.
- Check `out/result.json` (`return_code` 0). Time and grams are in the header of `out/plate_1.gcode`.
- `--export-png 0` renders a plate preview.

## User presets

User presets only store diffs and have no `type`, so the CLI rejects them. Flatten first:

```sh
./flatten.py "$U/process/<name>.json" process > proc.json
./flatten.py "$U/filament/<name>.json" filament > fil.json
```

## Print (LAN)

Printer needs LAN Only + Developer Mode on. Get IP, access code and serial from the printer screen. Keep them in env vars, never in this repo.

```python
import os, bambulabs_api as bl  # pip install bambulabs_api
p = bl.Printer(os.environ["BAMBU_IP"], os.environ["BAMBU_ACCESS_CODE"], os.environ["BAMBU_SERIAL"])
p.connect()
with open("out/part.gcode.3mf", "rb") as f:
    p.upload_file(f, "part.gcode.3mf")
p.start_print("part.gcode.3mf", 1, use_ams=True, ams_mapping=[0])
```

Ask before you start a print. Check the plate is clear.
