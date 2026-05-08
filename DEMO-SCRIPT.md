# DEMO-SCRIPT.md — showing Quiet to the client

A tight, ~3-minute live demo of system-wide DNS ad blocking on a real iPhone.
Do the one-time setup in [`MANUAL-STEPS.md`](MANUAL-STEPS.md) first, and **dry-run
it once** before the meeting.

## Before they're watching
- iPhone is **built to and trusted**, Quiet installed, Protection currently
  **Off**.
- Pick a reliably ad-heavy test page in Safari (a news/recipe/sports site you've
  already confirmed shows lots of ads).
- Optional: open **Settings ▸ General ▸ VPN & Device Management** once so you can
  show the profile later.

## The 5 steps

1. **Open Quiet.** One calm screen: the app name, a big power button, and
   "Tap to block ads and trackers across every app." Frame it: *"This blocks ads
   in every app on the phone, system-wide — not just the browser."*

2. **Show the 'before'.** With Protection **Off**, load the ad-heavy page in
   Safari. Let the ads render. *"This is the page today."*

3. **Tap Protection on.** iOS prompts **"Quiet would like to add VPN
   configurations"** → **Allow** + authenticate (Face ID / passcode). The button
   fills blue and the status reads **"Blocking ads."** Explain: *"That's a local,
   on-device DNS firewall starting up — nothing is being routed to any server we
   run; the phone is filtering its own DNS."*

4. **Show the 'after'.** Fully reload the same page (or open a second ad-heavy
   site). Ad slots are empty / trackers don't load. Point at the same regions
   that had ads a moment ago. The home screen also shows a running
   **"connections blocked"** count.

5. **Prove it's real & system-wide.** Open the VPN profile under **Settings ▸
   VPN & Device Management** to show the active configuration, then open a
   *different* app with ads to show blocking isn't Safari-only. Toggle Protection
   **off** and reload to show the ads come back — the contrast sells it.

## The honest framing to close with
> "This is a working proof of concept of the DNS-blocking approach, built on an
> open-source foundation so I could show you the real mechanism quickly. The
> production version for *your* app I'd build natively against Apple's
> NetworkExtension APIs, so it stays fully yours and carries no open-source
> licensing obligations."

## If something misbehaves
- **VPN won't enable / nothing blocks:** confirm you're on a **real device**
  (never the Simulator) and that you tapped **Allow** on the VPN prompt.
- **Ads still show:** hard-reload (some assets cache); try a fresh ad-heavy site;
  confirm the status says "Blocking ads," not "Starting…".
- **Toggle errors out:** the blocklist may be empty — background and reopen the
  app once (it seeds default lists on launch), then retry.
