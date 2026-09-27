#!/usr/bin/env python3
"""Flatten a Bambu Studio preset (resolve `inherits`) so the CLI can load it.
usage: flatten.py <preset.json> <machine|process|filament> > out.json"""
import json, sys, pathlib
SYS = pathlib.Path("/Applications/BambuStudio.app/Contents/Resources/profiles/BBL")

def load(path):
    d = json.loads(pathlib.Path(path).read_text())
    parent = d.get("inherits")
    if not parent:
        return d
    base = load(SYS / kind / f"{parent}.json")
    base.update(d)
    return base

path, kind = sys.argv[1], sys.argv[2]
d = load(path)
d.pop("inherits", None)
d["type"], d["from"] = kind, "User"
d.setdefault("name", pathlib.Path(path).stem)
json.dump(d, sys.stdout, indent=1)
