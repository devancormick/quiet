#!/usr/bin/env python3
"""One-shot rebrand of the copied Lockdown project -> Quiet.
Ordered text replacements over an allowlist of text files, then path renames.
Excludes LICENSE.md (keep GPL), Cartfile* (keep confirmedcode dep URLs),
and *.xcframework / binary content."""
import os, sys

ROOT = "/Users/administrator/Downloads/github/devan/supervpn/Quiet"

# Ordered content replacements (longest / most-specific first).
CONTENT = [
    ("com.confirmed.lockdown", "com.example.quiet"),  # sub-bundle ids
    ("com.confirmed",          "com.example.quiet"),  # base id + group.com.confirmed
    ("lockdownprivacy",        "example"),            # support domain
    ("confirmedvpn",           "example"),            # legacy domain
    ("lockdownhq",             "example"),            # legacy domain
    ("LockdowniOS",            "Quiet"),              # project/source-folder name
    ("Lockdown",               "Quiet"),              # everything else (targets/classes/strings)
    ("Confirmed",              "Quiet"),              # company name / copyright
]
# Filename-only renames (no domain/bundle tokens).
RENAME = [("LockdowniOS", "Quiet"), ("Lockdown", "Quiet"), ("Confirmed", "Quiet")]

TEXT_EXT = {
    ".swift", ".h", ".m", ".mm", ".c", ".cpp", ".plist", ".entitlements",
    ".storyboard", ".xib", ".strings", ".stringsdict", ".pbxproj", ".xcscheme",
    ".xcworkspacedata", ".xcsettings", ".json", ".md", ".toml", ".modulemap",
    ".xcprivacy", ".gpx", ".txt", ".yml", ".yaml", ".rb", ".plist",
}
TEXT_NAMES = {"Podfile", "Credits", "dnscrypt-proxy.toml", "contents.xcworkspacedata"}
SKIP_NAMES = {"LICENSE.md", "Cartfile", "Cartfile.resolved"}

def is_text(path):
    base = os.path.basename(path)
    if base in SKIP_NAMES:
        return False
    if base in TEXT_NAMES:
        return True
    return os.path.splitext(path)[1] in TEXT_EXT

def apply_content(s):
    for a, b in CONTENT:
        s = s.replace(a, b)
    return s

def rename_base(name):
    for a, b in RENAME:
        name = name.replace(a, b)
    return name

# --- pass 1: content ---
files_changed = 0
total_subs = 0
for dirpath, dirnames, filenames in os.walk(ROOT):
    if ".xcframework" in dirpath:
        continue
    for fn in filenames:
        p = os.path.join(dirpath, fn)
        if not is_text(p):
            continue
        try:
            with open(p, "rb") as f:
                raw = f.read()
            if b"\x00" in raw[:8192]:
                continue  # binary safety net
            s = raw.decode("utf-8")
        except (UnicodeDecodeError, OSError):
            continue
        ns = apply_content(s)
        if ns != s:
            subs = sum(s.count(a) for a, _ in CONTENT)  # approx
            files_changed += 1
            total_subs += subs
            with open(p, "w", encoding="utf-8") as f:
                f.write(ns)

# --- pass 2: renames (bottom-up so children renamed before parents) ---
renamed = 0
for dirpath, dirnames, filenames in os.walk(ROOT, topdown=False):
    if ".xcframework" in dirpath:
        continue
    for name in filenames + dirnames:
        if name in SKIP_NAMES:
            continue
        new = rename_base(name)
        if new != name:
            src = os.path.join(dirpath, name)
            dst = os.path.join(dirpath, new)
            if os.path.exists(src) and not os.path.exists(dst):
                os.rename(src, dst)
                renamed += 1

print(f"content: {files_changed} files modified (~{total_subs} token hits)")
print(f"renamed: {renamed} files/dirs")
