#!/usr/bin/env python3
"""Add QuietTheme.swift + QuietHomeViewController.swift to the Quiet app target
by inserting sibling entries next to AppDelegate.swift in all four pbxproj
sections (PBXBuildFile, PBXFileReference, group children, Sources phase).
Anchoring on a known in-target file keeps us in the right target/group/phase."""
import os, re, secrets, sys

PBX = "/Users/administrator/Downloads/github/devan/supervpn/Quiet/Quiet.xcodeproj/project.pbxproj"
src = open(PBX).read()

def uid():
    while True:
        u = secrets.token_hex(12).upper()
        if u not in src:
            return u

NEW = [("QuietTheme.swift", uid(), uid()),
       ("QuietHomeViewController.swift", uid(), uid())]

# Anchor strings (stripped) keyed to AppDelegate.swift's four entries.
ADEL_BUILD = "A1141A151F46230500F54698"  # PBXBuildFile uuid
ADEL_REF   = "A1141A141F46230500F54698"  # PBXFileReference uuid

anchors = {
    f"{ADEL_BUILD} /* AppDelegate.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {ADEL_REF} /* AppDelegate.swift */; }};":
        [f"{b} /* {n} in Sources */ = {{isa = PBXBuildFile; fileRef = {r} /* {n} */; }};" for n, r, b in NEW],
    f"{ADEL_REF} /* AppDelegate.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = AppDelegate.swift; sourceTree = \"<group>\"; }};":
        [f"{r} /* {n} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = {n}; sourceTree = \"<group>\"; }};" for n, r, b in NEW],
    f"{ADEL_REF} /* AppDelegate.swift */,":
        [f"{r} /* {n} */," for n, r, b in NEW],
    f"{ADEL_BUILD} /* AppDelegate.swift in Sources */,":
        [f"{b} /* {n} in Sources */," for n, r, b in NEW],
}

out, hits = [], 0
for line in src.splitlines(keepends=True):
    out.append(line)
    key = line.strip()
    if key in anchors:
        hits += 1
        indent = line[:len(line) - len(line.lstrip())]
        nl = "\n" if line.endswith("\n") else ""
        for new_line in anchors[key]:
            out.append(f"{indent}{new_line}{nl}")

if hits != 4:
    sys.exit(f"ERROR: expected 4 anchor hits, got {hits}; aborting (no write)")

open(PBX, "w").write("".join(out))
print("inserted 2 files at 4 anchor points each. UUIDs:")
for n, r, b in NEW:
    print(f"  {n}: ref={r} build={b}")
