// Generates a placeholder app icon set: solid accent rounded square (iOS masks
// the corners) with a clean white shield glyph. Renders every size declared in
// the AppIcon.appiconset Contents.json. Uses CoreGraphics + ImageIO (no Xcode).
import Foundation
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers

let accent = (r: 46.0/255.0, g: 111.0/255.0, b: 242.0/255.0)   // #2E6FF2
let iconDir = CommandLine.arguments[1]
let contentsURL = URL(fileURLWithPath: iconDir).appendingPathComponent("Contents.json")

func px(forSize s: String, scale: String) -> Int {
    let pt = Double(s.split(separator: "x").first.map(String.init) ?? "0") ?? 0
    let sc = Double(scale.replacingOccurrences(of: "x", with: "")) ?? 1
    return Int((pt * sc).rounded())
}

func shieldPath(in rect: CGRect) -> CGPath {
    // unit shield (y down 0=top..1=bottom), mapped into rect (CG y is up)
    let pts: [(CGFloat, CGFloat)] = [(0.5,0.02),(1.0,0.20),(1.0,0.55),(0.5,1.0),(0.0,0.55),(0.0,0.20)]
    func map(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        CGPoint(x: rect.minX + x*rect.width, y: rect.minY + (1-y)*rect.height)
    }
    let p = CGMutablePath()
    p.move(to: map(pts[0].0, pts[0].1))
    p.addLine(to: map(pts[1].0, pts[1].1))
    p.addLine(to: map(pts[2].0, pts[2].1))
    p.addQuadCurve(to: map(pts[3].0, pts[3].1), control: map(1.0, 0.86))
    p.addQuadCurve(to: map(pts[4].0, pts[4].1), control: map(0.0, 0.86))
    p.addLine(to: map(pts[5].0, pts[5].1))
    p.closeSubpath()
    return p
}

func render(_ n: Int) -> CGImage? {
    let cs = CGColorSpaceCreateDeviceRGB()
    guard let ctx = CGContext(data: nil, width: n, height: n, bitsPerComponent: 8,
                              bytesPerRow: 0, space: cs,
                              bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue) else { return nil }
    // opaque accent background (full bleed; iOS applies the rounded mask)
    ctx.setFillColor(red: accent.r, green: accent.g, blue: accent.b, alpha: 1)
    ctx.fill(CGRect(x: 0, y: 0, width: n, height: n))
    // centered white shield
    let s = CGFloat(n)
    let boxW = s * 0.46, boxH = s * 0.54
    let rect = CGRect(x: (s-boxW)/2, y: (s-boxH)/2 - s*0.01, width: boxW, height: boxH)
    ctx.addPath(shieldPath(in: rect))
    ctx.setFillColor(red: 1, green: 1, blue: 1, alpha: 1)
    ctx.fillPath()
    return ctx.makeImage()
}

func writePNG(_ img: CGImage, to url: URL) {
    guard let dest = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil) else { return }
    CGImageDestinationAddImage(dest, img, nil)
    CGImageDestinationFinalize(dest)
}

let data = try Data(contentsOf: contentsURL)
let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
let images = json["images"] as! [[String: Any]]
var done = Set<String>()
for entry in images {
    guard let fn = entry["filename"] as? String,
          let size = entry["size"] as? String,
          let scale = entry["scale"] as? String else { continue }
    if done.contains(fn) { continue }
    done.insert(fn)
    let n = px(forSize: size, scale: scale)
    guard n > 0, let img = render(n) else { continue }
    writePNG(img, to: URL(fileURLWithPath: iconDir).appendingPathComponent(fn))
}
print("rendered \(done.count) icon pngs into \(iconDir)")
