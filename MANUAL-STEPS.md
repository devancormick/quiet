# MANUAL-STEPS.md — what an agent can't do; a human must

The rebrand and code changes are done. The remaining steps require Apple
software, an Apple account, and a physical device. They cannot be automated.

---

## 0. Install the full Xcode (this machine only had Command Line Tools)

The automated build could **not** be attempted because this machine has only the
Command Line Tools, not the full Xcode app:

```
$ xcodebuild -version
xcode-select: error: tool 'xcodebuild' requires Xcode, but active developer
directory '/Library/Developer/CommandLineTools' is a command line tools instance
```

`xcodebuild`, the iOS SDK, and the Simulator (`simctl`) are all unavailable
without it. Fix:

1. Install **Xcode** from the Mac App Store (several GB).
2. Point the toolchain at it and accept the license:
   ```bash
   sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
   sudo xcodebuild -license accept
   ```

## 1. Install the dependency managers (also not present here)

```bash
sudo gem install cocoapods       # `pod` was not installed on this machine
brew install carthage            # or: see https://github.com/Carthage/Carthage
```

## 2. Resolve dependencies & open the workspace

```bash
cd Quiet
pod install
carthage update --no-use-binaries --platform iOS   # ./wcarthage on older Xcode
open Quiet.xcworkspace            # NOT Quiet.xcodeproj
```

The `Quiet` and `QuietTunnel` Podfile targets already match the renamed Xcode
targets, so `pod install` should attach cleanly.

## 3. Signing — set your Development Team (the part only your Apple ID can do)

In Xcode → for **each** of these targets → **Signing & Capabilities**:

- `Quiet` (main app)
- `QuietTunnel` (the packet-tunnel network extension)
- the widget/today/blocker extensions you intend to run

Do the following on each:

1. Add your **Apple ID** (Xcode ▸ Settings ▸ Accounts) and select your **Team**.
2. Let Xcode "Automatically manage signing." It will need to **register the new
   bundle IDs** (`com.example.quiet`, `com.example.quiet.QuietTunnel`, …) on your
   account. Change the prefix from `com.example.quiet` to something you own if
   `com.example` collides.

## 4. Capabilities / entitlements (require a **paid** Apple Developer account)

The on-device VPN needs entitlements that the **free** Apple ID cannot enable —
you must be enrolled in the paid **Apple Developer Program ($99/yr)**:

- **Network Extensions** → enable **Packet Tunnel Provider** on `Quiet` and
  `QuietTunnel`.
- **Personal VPN**.
- **App Groups** → both targets must share the **same** group
  (`group.com.example.quiet` is already set in the entitlements; just confirm
  it's registered/checked on your account).
- Keychain Sharing (already configured) if you keep the account features.

If a build fails only on signing/entitlements/Team, that is expected at this
stage — it is not a code problem.

## 5. Run on a **real iPhone** (not the Simulator)

The packet-tunnel VPN **does not run in the iOS Simulator**, so the ad-blocking
can only be demonstrated on a physical device:

1. Plug in an iPhone, select it as the run destination, run the `Quiet` scheme.
2. On first toggle, iOS shows **"Quiet would like to add VPN configurations"** —
   tap **Allow** and authenticate. This is the one-time VPN-profile approval.
3. The profile appears under **Settings ▸ General ▸ VPN & Device Management**.

---

## Known residual items (optional polish, none block the demo)

- **Internal names still say "lockdown"/"confirmed":** non-user-facing only —
  e.g. Swift variable names (`lockdownBlockedDomains`), `UserDefaults` keys
  (`"lockdown_domains"`, kept consistent across app + extension), API field
  names, the `.confirmedBlue` color constant, and the **`lockdown://` URL
  scheme** used by the widgets. The widgets aren't part of the demo flow (the
  app boots straight into `QuietHomeViewController`). Rename later only if you
  ship the widgets; keep app + extension in sync if you touch the keys.
- **Leftover brand art:** the original Lockdown shield art lives in a few unused
  image sets (renamed to `quiet_icon*`); the demo screen doesn't display them.
  Swap the PNGs if you wire the old screens back in.
- **`LICENSE.md` / `Cartfile`** were intentionally left as-is (GPL compliance;
  valid `confirmedcode/*` dependency URLs).
- **Build debugging:** Lockdown is an older codebase (deployment target was 13.0,
  Swift/Carthage pinned). Expect a few modern-Xcode fixes (deprecated APIs,
  Carthage build flags). These are normal and unrelated to the rebrand.
