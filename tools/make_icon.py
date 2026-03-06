#!/usr/bin/env python3
"""Generate a placeholder AppIcon set with pure stdlib (no Pillow):
solid accent rounded square (iOS masks corners) + clean white shield glyph.
Renders every size in the appiconset Contents.json."""
import json, os, sys, struct, zlib

ACCENT = (46, 111, 242)   # #2E6FF2
WHITE = (255, 255, 255)

def quad(p0, p1, p2, steps=18):
    pts = []
    for i in range(1, steps + 1):
        t = i / steps
        mt = 1 - t
        x = mt*mt*p0[0] + 2*mt*t*p1[0] + t*t*p2[0]
        y = mt*mt*p0[1] + 2*mt*t*p1[1] + t*t*p2[1]
        pts.append((x, y))
    return pts

def shield_polygon(n):
    # unit shield, y-down; map into a centered box
    boxW, boxH = 0.46*n, 0.54*n
    ox, oy = (n-boxW)/2, (n-boxH)/2 - 0.01*n
    def m(ux, uy):
        return (ox + ux*boxW, oy + uy*boxH)
    poly = [m(0.5,0.02), m(1.0,0.20), m(1.0,0.55)]
    poly += quad(m(1.0,0.55), m(1.0,0.86), m(0.5,1.0))
    poly += quad(m(0.5,1.0), m(0.0,0.86), m(0.0,0.55))
    poly += [m(0.0,0.20)]
    return poly

def render_rgb(n):
    poly = shield_polygon(n)
    edges = list(zip(poly, poly[1:] + poly[:1]))
    rows = []
    for y in range(n):
        yc = y + 0.5
        xs = []
        for (x0, y0), (x1, y1) in edges:
            if (y0 <= yc < y1) or (y1 <= yc < y0):
                xs.append(x0 + (yc - y0) * (x1 - x0) / (y1 - y0))
        xs.sort()
        row = bytearray()
        for c in ACCENT:
            pass
        # build a flat accent row, then paint white spans
        row = bytearray(ACCENT * n)
        for i in range(0, len(xs) - 1, 2):
            a = max(0, int(round(xs[i])))
            b = min(n, int(round(xs[i+1])))
            for x in range(a, b):
                row[x*3:x*3+3] = bytes(WHITE)
        rows.append(bytes(row))
    return rows

def write_png(path, n):
    rows = render_rgb(n)
    raw = bytearray()
    for r in rows:
        raw.append(0)        # filter type 0
        raw.extend(r)
    comp = zlib.compress(bytes(raw), 9)
    def chunk(typ, data):
        c = struct.pack(">I", len(data)) + typ + data
        return c + struct.pack(">I", zlib.crc32(typ + data) & 0xffffffff)
    ihdr = struct.pack(">IIBBBBB", n, n, 8, 2, 0, 0, 0)  # 8-bit, color type 2 (RGB)
    with open(path, "wb") as f:
        f.write(b"\x89PNG\r\n\x1a\n")
        f.write(chunk(b"IHDR", ihdr))
        f.write(chunk(b"IDAT", comp))
        f.write(chunk(b"IEND", b""))

def px(size, scale):
    pt = float(size.split("x")[0])
    sc = float(scale.replace("x", ""))
    return int(round(pt * sc))

icon_dir = sys.argv[1]
meta = json.load(open(os.path.join(icon_dir, "Contents.json")))
done = set()
for e in meta["images"]:
    fn = e.get("filename")
    if not fn or fn in done:
        continue
    done.add(fn)
    n = px(e["size"], e["scale"])
    if n > 0:
        write_png(os.path.join(icon_dir, fn), n)
print(f"rendered {len(done)} icon pngs into {icon_dir}")
