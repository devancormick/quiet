# Architecture Notes — DNS-level ad blocking on iOS

These notes summarize how two open-source iOS ad/tracker blockers implement
on-device DNS blocking. They exist so the production feature can be built
**fresh** against Apple's permissively-licensed `NetworkExtension` APIs, using
these GPL projects as architecture reference only.

> Both reference projects are GPL. We only **read** them to learn the structure
> and we only **run a rebranded local copy** for the demo (GPL permits private
> modification + use). We do not ship their code.

---

## The core idea (shared by both projects, and by Apple's own sample)

iOS has no public "block this domain everywhere" API. Every system-wide content
blocker works the same way:

1. The app installs a **VPN configuration** (a `NETunnelProviderManager`). On
   iOS a Packet Tunnel is the only way for a 3rd-party app to see and filter all
   network traffic system-wide. The user must approve the VPN profile once.
2. A **Packet Tunnel Network Extension** (`NEPacketTunnelProvider`) runs in a
   separate process. It captures the device's DNS queries and answers them
   itself via a **local DNS resolver/proxy bound to `127.0.0.1`**.
3. For each DNS query, the extension checks the domain against a **blocklist**.
   - On the list → return `NXDOMAIN` / `0.0.0.0` (the ad/tracker never loads).
   - Not on the list → forward upstream and return the real answer.
4. The app and the extension can't share memory, so they communicate through an
   **App Group** shared container (shared files + a shared `UserDefaults`
   suite). The app writes the blocklist + settings; the extension reads them.

This is "DNS-level" blocking: it blocks by hostname before a connection is made,
so it works inside **all apps**, not just Safari. It does not inspect packet
payloads and is not a real upstream VPN — the "server" is the phone itself.

---

## Lockdown (confirmedcode/Lockdown-iOS) — our working base for the demo

Lockdown has **two** independent features. We only use the first.

### 1. "Firewall" mode — local, on-device, no backend  ✅ this is the demo
- **App side:** [`FirewallController.swift`](reference/lockdown/FirewallController.swift)
  - `static let shared` singleton wraps a single `NETunnelProviderManager`.
  - `setEnabled(_:)` loads/creates the manager, sets `isEnabled` +
    `isOnDemandEnabled`, installs an `NEOnDemandRuleConnect` (so the tunnel
    auto-starts on any network), then `saveToPreferences` → `startVPNTunnel()`.
  - There is **no remote server**: `protocolConfiguration.serverAddress` is just
    a human-readable label (`"Lockdown Configuration"`). The tunnel terminates
    on-device.
  - It even pokes a dummy `https://nonexistant_invalid_url` request to force the
    on-demand tunnel to spin up immediately.
- **Extension side:** [`Lockdown Tunnel/PacketTunnelProvider.swift`](<reference/lockdown/Lockdown Tunnel/PacketTunnelProvider.swift>)
  (target `LockdownTunnel`, an `NEPacketTunnelProvider`):
  - Starts a local **DNSCrypt-proxy** (vendored `Dnscryptproxy.xcframework`) at
    `127.0.0.1` for DNS, and a local **`GCDHTTPProxyServer`** (from NEKit) at
    `127.0.0.1:9090`.
  - `var latestBlockedDomains = getAllBlockedDomains()` — loads the combined
    blocklist at launch; connections to blocked domains are dropped.
  - `let groupContainer = "group.com.confirmed"` — reads the blocklist/settings
    the app wrote into the shared App Group container.
- **Blocklist assembly:** [`FirewallUtilities.swift`](reference/lockdown/FirewallUtilities.swift)
  + `WhitelistUtilities.swift` build the effective set from curated lists
  (ads, trackers, etc.) plus the user's custom domains, stored in the App Group.
- **Dependencies:** CocoaPods (`PromiseKit`, `KeychainAccess`, UI pods…) +
  Carthage (`confirmedcode/NEKit`, `CocoaLumberjack`, `CocoaAsyncSocket`,
  `Resolver`) + the prebuilt `Dnscryptproxy.xcframework`.

### 2. "Secure Tunnel" mode — paid, remote VPN  ❌ not used
- A real VPN to Confirmed's servers. Per the upstream README it **requires a
  production App Store receipt** and is unavailable in local builds. We never
  touch it; the demo only needs Firewall mode, which runs fully offline.

### Targets in the Xcode project
`Lockdown` (main app) · `LockdownTunnel` (packet-tunnel NE — the blocker) ·
`Lockdown Blocker` (Safari content blocker) · `Lockdown VPN Widget` /
`Lockdown Firewall Widget` / `LockdownFirewallWidget` (widgets) · `LockdownTests`.
UI is UIKit, storyboard-driven (`LockdowniOS/Base.lproj/Main.storyboard`,
`HomeViewController.swift`).

---

## AdGuard for iOS (AdguardTeam/AdguardForiOS) — reference only

Same architecture, different DNS engine (their native `DnsLibs`):
- [`AdGuardSDK/.../DNS/PacketTunnelProvider/PacketTunnelProvider.swift`](reference/adguard/AdGuardSDK/AdGuardSDK/DNS/PacketTunnelProvider/) —
  the `NEPacketTunnelProvider`.
- `DnsProxy.swift` / `AGDnsProxy+Extension.swift` wrap **`AGDnsProxy`** (a C/C++
  library) that does the actual DNS filtering and supports DoH/DoT/DoQ
  upstreams.
- `DnsProxyConfiguration*.swift` assemble upstreams + filter rule lists.
- `PacketTunnelSettingsProvider.swift` configures the tunnel's
  `NEPacketTunnelNetworkSettings` (sets `127.0.0.1` as the DNS server so all
  queries are routed into the extension).
- App ↔ extension settings pass through an App Group, same as Lockdown.
- Blocklists are expressed as **DNS filter rules** (AdGuard/`hosts` syntax)
  rather than a flat domain set.

**Takeaway for a production build:** start from Apple's `NEPacketTunnelProvider`
sample (permissive license), set `127.0.0.1` as the tunnel DNS, and drop in a
DNS-filtering core. Options that avoid GPL: Apple's built-in
`NEDNSProxyProvider`, a permissively-licensed resolver, or AdGuard's `DnsLibs`
(check its specific license per use). The app/extension/App-Group skeleton and
the blocklist-update flow are the parts worth modeling on these projects.

---

## What the local demo proves to the client
Tapping "Protection on" installs the VPN profile and starts the on-device packet
tunnel; loading an ad-heavy page then shows ads/trackers failing to resolve —
all without sending traffic to any server we run. That is the exact mechanism a
production feature in the client's own app would use, built natively so it stays
fully theirs and free of GPL obligations.
