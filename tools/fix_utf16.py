#!/usr/bin/env python3
"""Catch text files the UTF-8 pass skipped (UTF-16/BOM) and rebrand them too."""
import os, codecs

ROOT = "/Users/administrator/Downloads/github/devan/supervpn/Quiet"
CONTENT = [
    ("com.confirmed.lockdown", "com.example.quiet"),
    ("com.confirmed",          "com.example.quiet"),
    ("lockdownprivacy",        "example"),
    ("confirmedvpn",           "example"),
    ("lockdownhq",             "example"),
    ("LockdowniOS",            "Quiet"),
    ("Lockdown",               "Quiet"),
    ("Confirmed",              "Quiet"),
]
TEXT_EXT = {".strings", ".stringsdict", ".plist", ".storyboard", ".xib",
            ".swift", ".h", ".m", ".json", ".xcscheme", ".pbxproj"}
SKIP = {"LICENSE.md", "Cartfile", "Cartfile.resolved"}

def detect(raw):
    if raw.startswith(codecs.BOM_UTF16_LE): return "utf-16"  # has BOM
    if raw.startswith(codecs.BOM_UTF16_BE): return "utf-16"
    # heuristic: lots of interleaved nulls -> utf-16 LE without BOM
    if len(raw) > 1 and raw[1:512:2].count(0) > raw[0:512:2].count(0):
        return "utf-16-le"
    return None

changed = 0
for dp, _, fns in os.walk(ROOT):
    if ".xcframework" in dp:
        continue
    for fn in fns:
        if fn in SKIP or os.path.splitext(fn)[1] not in TEXT_EXT:
            continue
        p = os.path.join(dp, fn)
        with open(p, "rb") as f:
            raw = f.read()
        try:
            raw.decode("utf-8")
            continue  # already handled by utf-8 pass
        except UnicodeDecodeError:
            pass
        enc = detect(raw)
        if not enc:
            continue
        try:
            s = raw.decode(enc)
        except UnicodeDecodeError:
            continue
        ns = s
        for a, b in CONTENT:
            ns = ns.replace(a, b)
        if ns != s:
            # re-encode as UTF-16 (Apple .strings convention) with BOM
            with open(p, "wb") as f:
                f.write(ns.encode("utf-16"))
            changed += 1
            print("fixed:", os.path.relpath(p, ROOT))

print(f"total UTF-16 files rebranded: {changed}")
