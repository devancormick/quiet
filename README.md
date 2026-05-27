# Quiet — DNS ad-blocking demo (proof of concept)

**Quiet** is a local, on-device **proof of concept** that demonstrates
system-wide, DNS-level ad & tracker blocking on iOS — the kind of feature you'd
add to a privacy app. Tapping **Protection on** installs an on-device VPN
profile and starts a packet-tunnel network extension that answers DNS queries
locally and drops the ones on its blocklist, so ads and trackers fail to load
**inside every app, not just Safari**. No traffic is sent to any server we run.

This is a demo meant to run on a developer's own device to show the approach to
a prospective client. **It is not meant to be shipped to the App Store.**

> Accent color `#2E6FF2` · App name **Quiet** · Bundle prefix `com.example.quiet`

---

## What's in this repo

```
.
├── Quiet/              # the rebranded iOS app (Xcode project)
│   ├── Quiet.xcworkspace      # open THIS after `pod install`
│   ├── Quiet.xcodeproj
│   ├── Quiet/                 # main app source (incl. QuietHomeViewController.swift, QuietTheme.swift)
│   ├── Quiet Tunnel/          # packet-tunnel network extension = the DNS blocker
│   └── Podfile / Cartfile     # dependencies
├── reference/          # READ-ONLY upstreams, for architecture study
│   ├── lockdown/       # confirmedcode/Lockdown-iOS
│   └── adguard/        # AdguardTeam/AdguardForiOS
├── NOTES.md            # how DNS blocking works in both projects
├── MANUAL-STEPS.md     # the Apple-account / signing / build steps only a human can do
└── DEMO-SCRIPT.md      # 5-step script for showing the client
```

The `reference/` folder is for learning only — the app does **not** build from
it. The buildable project is `Quiet/`.

---

## What was rebranded from Lockdown → Quiet

- Xcode project, workspace, all targets, schemes, and source folders renamed.
- Bundle IDs → `com.example.quiet*`; App Group → `group.com.example.quiet`
  (relationship between app and extension preserved).
- Every user-facing "Lockdown"/"Confirmed" string, support URL, and email
  replaced; app display name set to **Quiet**.
- New placeholder **app icon** (white shield on accent blue) and an
  `AccentColor` asset generated.
- A new minimal, calm home screen (`QuietHomeViewController`) — one large
  Protection toggle + status line — set as the app's root, bypassing the
  original tab-bar/upsell flow.

`Cartfile` was intentionally left untouched (the `confirmedcode/*` dependency
URLs must stay valid). A handful of **internal, non-user-facing** identifiers
(variable names, UserDefaults keys, the `lockdown://` widget URL scheme) still
contain the old name — see [`MANUAL-STEPS.md`](MANUAL-STEPS.md).

---

## How to open & run

You need a **Mac with the full Xcode app** (not just Command Line Tools),
**CocoaPods**, and **Carthage**. Then:

```bash
cd Quiet
pod install
carthage update --no-use-binaries --platform iOS   # or ./wcarthage update ... on older Xcode
open Quiet.xcworkspace
```

Running the actual blocking requires a paid Apple Developer account, the
Network Extension entitlements, and a **real iPhone** (the packet tunnel does
not function in the Simulator). Those human-only steps are in
[`MANUAL-STEPS.md`](MANUAL-STEPS.md). To present it, follow
[`DEMO-SCRIPT.md`](DEMO-SCRIPT.md).
