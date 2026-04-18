# QuickShell Noctalia-inspired Config Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build a QuickShell config (on upstream quickshell 0.2.1) that looks Noctalia-inspired — detached pill-shaped bar, slide-out control center, centered OSDs — while skipping wallpaper/idle/lock/notifications/launcher UI (handled elsewhere).

**Architecture:** Singleton services own state; bar widgets and panels read from singletons. Theme is a singleton reading a state file. External state for `theme` and `dnd` lives under `~/.local/state/quickshell/`. Niri IPC via the existing custom `Niri 0.1` QML module.

**Tech Stack:** QuickShell 0.2.1 (upstream, Gentoo GURU), QtQuick, Nerd Font (`MonaspiceAr Nerd Font Mono`), gypsum palette. External binaries: `brightnessctl`, `bluetoothctl`, `iwctl`, `wpctl`, `drmenu`.

**Verification model:** no test harness. "Verify" means launching `qs -p quickshell/shell.qml`, confirming it loads with no errors in console, and eyeballing the result. Each task ends with a commit.

**Reference:** `docs/plans/2026-04-18-quickshell-noctalia-design.md`

---

## Task 1: Theme scaffolding — Theme + ThemeState singletons

**Files:**
- Create: `quickshell/theme/Theme.qml`
- Create: `quickshell/theme/ThemeState.qml`
- Create: `quickshell/qmldir` (registers the singletons)

**Step 1: Create the state directory at runtime**

`ThemeState` must create `~/.local/state/quickshell/` on first run if missing. Use `Quickshell.Io.FileView` to read/write `theme` file, fall back to `"dark"` if missing.

**Step 2: Write `quickshell/theme/Theme.qml`**

```qml
pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root
    property bool dark: ThemeState.dark

    // Palette — gypsum
    readonly property color bg:      dark ? "#0E1415" : "#F7F7F7"
    readonly property color bgAlt:   dark ? "#1A1F20" : "#F0F0F0"
    readonly property color surface: dark ? "#293334" : "#E0E0E0"
    readonly property color fg:      dark ? "#CECECE" : "#000000"
    readonly property color fgDim:   dark ? "#708B8D" : "#777777"
    readonly property color accent:  dark ? "#71ADE7" : "#325CC0"
    readonly property color ok:      dark ? "#95CB82" : "#448C27"
    readonly property color warn:    dark ? "#CD974B" : "#FFBC5D"
    readonly property color err:     dark ? "#CC3333" : "#AA3731"
    readonly property color border:  dark ? "#1A1F20" : "#E0E0E0"

    // Geometry
    readonly property int barHeight:   28
    readonly property int pillRadius:  10
    readonly property int pillPadding: 8
    readonly property int widgetGap:   6
    readonly property int outerMargin: 8

    // Type
    readonly property string fontFamily: "MonaspiceAr Nerd Font Mono"
    readonly property int fontSize:  12
    readonly property int iconSize:  14
}
```

**Step 3: Write `quickshell/theme/ThemeState.qml`**

```qml
pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property bool dark: true

    readonly property string stateDir: Qt.resolvedUrl(Quickshell.env("HOME") + "/.local/state/quickshell/").toString().replace("file://", "")
    readonly property string statePath: stateDir + "theme"

    function toggle() {
        dark = !dark
        writeProc.running = true
    }

    Process {
        id: ensureDir
        command: ["mkdir", "-p", root.stateDir]
        running: true
    }

    Process {
        id: readProc
        command: ["sh", "-c", "cat '" + root.statePath + "' 2>/dev/null || echo dark"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.dark = (this.text.trim() !== "light")
        }
    }

    Process {
        id: writeProc
        command: ["sh", "-c", "echo " + (root.dark ? "dark" : "light") + " > '" + root.statePath + "'"]
    }
}
```

**Step 4: Write `quickshell/qmldir`**

```
module quickshell
singleton Theme 1.0 theme/Theme.qml
singleton ThemeState 1.0 theme/ThemeState.qml
```

**Step 5: Verify**

Run: `qs -p quickshell/shell.qml 2>&1 | head -30`
Expected: shell loads (no qmldir-related errors about Theme/ThemeState). Existing bar still renders.

**Step 6: Commit**

```bash
git add quickshell/qmldir quickshell/theme/
git commit -m "QuickShell: add Theme and ThemeState singletons"
```

---

## Task 2: Rewrite Icons.qml to Nerd Font glyphs

**Files:**
- Modify: `quickshell/utils/Icons.qml`

**Context:** current file maps to Material Symbols *names*. Rewrite to Nerd Font (Mdi + Fa) *glyph strings*. Keep the same property names so callers aren't affected.

**Step 1: Replace the file**

Key icons to provide (property names preserved where already used):

- `weatherIcons`: WTTR-code → Nerd Font weather glyphs (󰖙 sunny, 󰖐 partly cloudy, 󰖑 cloudy, 󰖑 fog, 󰖗 rain, 󰖘 heavy rain, 󰖓 thunder, 󰖘 snow, etc. — full mapping in implementation)
- `categoryIcons`: Desktop category → Nerd Font glyph
- New: `systemIcons` with keys used by bar/panels/OSDs:
  - `volume`, `volumeMute`, `mic`, `micMute`
  - `bluetoothOn`, `bluetoothOff`
  - `wifiOn`, `wifiOff`, `wifiLow`, `wifiMid`, `wifiHigh`
  - `batteryFull`, `batteryMid`, `batteryLow`, `batteryCharging`
  - `brightness`, `media`, `play`, `pause`, `prev`, `next`
  - `dndOn`, `dndOff`, `tray`, `launcher`, `theme`, `notifications`, `settings`

**Step 2: Verify**

Run: `qs -p quickshell/shell.qml 2>&1 | head -20`
Expected: no errors.

**Step 3: Commit**

```bash
git add quickshell/utils/Icons.qml
git commit -m "QuickShell: rewrite Icons.qml to Nerd Font glyphs"
```

---

## Task 3: Directory skeleton + qmldir entries

**Files:**
- Create (empty placeholder qml files, one per future widget/service/panel/OSD), so subsequent tasks can edit them
- Modify: `quickshell/qmldir` to register only singletons; bar/panel/osd files will be imported by relative path

**Step 1: Make directories**

```bash
mkdir -p quickshell/services quickshell/bar/widgets quickshell/panels quickshell/osd
```

**Step 2: Skip — don't pre-create empty qml files**

Rationale: QuickShell parses every qml file on reload; creating empty stubs risks import errors. Create each file in the task that fills it.

**Step 3: Commit**

No commit needed; no tracked changes yet.

---

## Task 4: services/Brightness.qml

**Files:**
- Create: `quickshell/services/Brightness.qml`
- Modify: `quickshell/qmldir`

**Step 1: Implement**

Singleton exposing `percent` (0–100 int). Runs `brightnessctl -m` on a 2-second timer and on demand via `refresh()`. Provides `set(percent)` calling `brightnessctl set <n>%`.

```qml
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property int percent: 0

    function refresh() { readProc.running = true }
    function set(p) {
        setProc.command = ["brightnessctl", "set", Math.max(1, Math.min(100, p)) + "%"]
        setProc.running = true
        Qt.callLater(refresh)
    }

    Process {
        id: readProc
        command: ["sh", "-c", "brightnessctl -m | cut -d, -f4 | tr -d '%'"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.percent = parseInt(this.text.trim()) || 0
        }
    }
    Process { id: setProc }
    Timer { interval: 2000; running: true; repeat: true; onTriggered: readProc.running = true }
}
```

**Step 2: Register in `quickshell/qmldir`**

```
singleton Brightness 1.0 services/Brightness.qml
```

**Step 3: Verify**

Run: `qs -p quickshell/shell.qml 2>&1 | head -20`
Expected: loads.

**Step 4: Commit**

```bash
git add quickshell/services/Brightness.qml quickshell/qmldir
git commit -m "QuickShell: add Brightness service"
```

---

## Task 5: services/Network.qml (iwctl-backed, read-only)

**Files:**
- Create: `quickshell/services/Network.qml`
- Modify: `quickshell/qmldir`

**Step 1: Implement**

Singleton exposing `connected` (bool), `ssid` (string), `signal` (0–100 int estimate from dBm). Polls `iwctl station <device> show` every 5 seconds. Device discovered once via `iwctl device list`.

Parse signal from `RSSI` line (dBm). Map: -50 or better → 100, -60 → 75, -70 → 50, -80 → 25, worse → 0.

**Step 2: Register in qmldir**

```
singleton Network 1.0 services/Network.qml
```

**Step 3: Verify**

Run: `qs -p quickshell/shell.qml 2>&1 | head -20`
Expected: loads.

**Step 4: Commit**

```bash
git add quickshell/services/Network.qml quickshell/qmldir
git commit -m "QuickShell: add Network service (iwctl, read-only)"
```

---

## Task 6: services/Bluetooth.qml

**Files:**
- Create: `quickshell/services/Bluetooth.qml`
- Modify: `quickshell/qmldir`

**Step 1: Implement**

Singleton exposing `powered` (bool), `connectedDevice` (string, optional). Polls `bluetoothctl show` every 5 seconds. Provides `toggle()` calling `bluetoothctl power on/off`.

**Step 2: Register in qmldir**

**Step 3: Verify**

**Step 4: Commit**

```bash
git add quickshell/services/Bluetooth.qml quickshell/qmldir
git commit -m "QuickShell: add Bluetooth service"
```

---

## Task 7: services/Audio.qml — migrate to Quickshell.Services.Pipewire

**Files:**
- Modify: `quickshell/services/Audio.qml`
- Modify: `quickshell/qmldir`

**Context:** existing file shells out to `wpctl`/`pactl`. Replace with `Quickshell.Services.Pipewire` for observable state (default sink volume, mute; default source mute). Keep a thin `setVolume(p)`/`setMuted(b)`/`setMicMuted(b)` API.

**Step 1: Rewrite as singleton** exposing `volume` (0–100), `muted`, `micMuted`.

**Step 2: Register in qmldir as singleton (if not already)**

**Step 3: Verify**

Play audio; confirm `volume`/`muted` reflect reality. Toggle mic in another way, confirm `micMuted` follows.

**Step 4: Commit**

```bash
git add quickshell/services/Audio.qml quickshell/qmldir
git commit -m "QuickShell: migrate Audio service to Pipewire"
```

---

## Task 8: services/Battery.qml

**Files:**
- Create: `quickshell/services/Battery.qml`
- Modify: `quickshell/qmldir`

**Step 1: Implement** via `Quickshell.Services.UPower`. Expose `present`, `percent`, `charging`. If no battery (desktop), `present = false`.

**Step 2: Register in qmldir**

**Step 3: Verify**

**Step 4: Commit**

```bash
git add quickshell/services/Battery.qml quickshell/qmldir
git commit -m "QuickShell: add Battery service"
```

---

## Task 9: services/Media.qml

**Files:**
- Create: `quickshell/services/Media.qml`
- Modify: `quickshell/qmldir`

**Step 1: Implement** as facade over `Quickshell.Services.Mpris`. Expose `active` (bool — true when any player present), `title`, `artist`, `art` (url), `playing` (bool). Methods: `playPause()`, `next()`, `prev()`. Pick the first non-paused player, fallback to first player.

**Step 2: Register in qmldir**

**Step 3: Verify**

Start a media player (e.g. `mpv file.mp3`); confirm `active` true and metadata populates.

**Step 4: Commit**

```bash
git add quickshell/services/Media.qml quickshell/qmldir
git commit -m "QuickShell: add Media service (MPRIS facade)"
```

---

## Task 10: services/Dnd.qml

**Files:**
- Create: `quickshell/services/Dnd.qml`
- Modify: `quickshell/qmldir`

**Step 1: Implement** like ThemeState — read/write `~/.local/state/quickshell/dnd`, expose `enabled` bool, `toggle()` method.

**Step 2: Register in qmldir**

**Step 3: Verify**

**Step 4: Commit**

```bash
git add quickshell/services/Dnd.qml quickshell/qmldir
git commit -m "QuickShell: add DND service (local state)"
```

---

## Task 11: bar/Bar.qml — three-pill scaffold

**Files:**
- Create: `quickshell/bar/Bar.qml`
- Modify: `quickshell/shell.qml` (replace inline bar layout with `Bar { screen: modelData }`)

**Step 1: Write `Bar.qml`**

- `PanelWindow` with top/left/right anchors, `implicitHeight: Theme.barHeight + 2*Theme.outerMargin`, transparent background.
- Three `Rectangle`s (left/center/right) with `Theme.bg` fill, radius `Theme.pillRadius`, padded by `Theme.outerMargin` from window edges. Each contains a `RowLayout` with `spacing: Theme.widgetGap`.
- Expose a `screen` property.
- Delegate widget placement to empty `Loader` stubs for now (add one placeholder `Text { text: "·" }` per pill so they render).

**Step 2: Simplify `shell.qml`**

Replace the inline RowLayouts with `Bar { modelData: modelData }`. Keep `ShellRoot` + `Variants`.

**Step 3: Verify**

Run: `qs -p quickshell/shell.qml`
Expected: three rounded pills visible on the bar, themed bg.

**Step 4: Commit**

```bash
git add quickshell/bar/Bar.qml quickshell/shell.qml
git commit -m "QuickShell: three-pill bar scaffold with Theme"
```

---

## Task 12: Port bar/Workspaces.qml to Theme

**Files:**
- Modify: `quickshell/bar/Workspaces.qml`
- Modify: `quickshell/bar/Bar.qml` (mount Workspaces in left pill)

**Step 1:** replace hardcoded colors with `Theme.*`, use `Theme.fontFamily`/`Theme.fontSize`. Keep existing Niri integration.

**Step 2:** mount in `Bar.qml` left pill.

**Step 3: Verify**

**Step 4: Commit**

```bash
git add quickshell/bar/Workspaces.qml quickshell/bar/Bar.qml
git commit -m "QuickShell: port Workspaces widget to Theme"
```

---

## Task 13: bar/widgets/ActiveWindow.qml

**Files:**
- Create: `quickshell/bar/widgets/ActiveWindow.qml`
- Modify: `quickshell/bar/Bar.qml`

**Step 1:** use the `Niri` object (already in scope in `Bar`) to read focused window title. Truncate to ~60 chars with ellipsis. `Theme.fg` color.

**Step 2:** mount in left pill after Workspaces.

**Step 3: Verify**

**Step 4: Commit**

```bash
git add quickshell/bar/widgets/ActiveWindow.qml quickshell/bar/Bar.qml
git commit -m "QuickShell: add ActiveWindow widget"
```

---

## Task 14: bar/widgets/Clock.qml

**Files:**
- Create: `quickshell/bar/widgets/Clock.qml`
- Modify: `quickshell/bar/Bar.qml`

**Step 1:** move clock logic out of `shell.qml`, into a widget using `Theme`.

**Step 2:** mount in center pill.

**Step 3: Verify**

**Step 4: Commit**

```bash
git add quickshell/bar/widgets/Clock.qml quickshell/bar/Bar.qml
git commit -m "QuickShell: extract Clock widget"
```

---

## Task 15: bar/widgets/MediaMini.qml

**Files:**
- Create: `quickshell/bar/widgets/MediaMini.qml`
- Modify: `quickshell/bar/Bar.qml`

**Step 1:** uses `Media` service. When `!Media.active`: render just the media icon dimmed. When active: icon + truncated title (max 30 chars). Scroll → `Media.next()` / `Media.prev()`. Click → `Media.playPause()`.

**Step 2:** mount in center pill after Clock.

**Step 3: Verify**

**Step 4: Commit**

```bash
git add quickshell/bar/widgets/MediaMini.qml quickshell/bar/Bar.qml
git commit -m "QuickShell: add MediaMini widget"
```

---

## Task 16: Port bar/Audio.qml → bar/widgets/Volume.qml + Mic.qml

**Files:**
- Create: `quickshell/bar/widgets/Volume.qml`
- Create: `quickshell/bar/widgets/Mic.qml`
- Delete: `quickshell/bar/Audio.qml`
- Modify: `quickshell/bar/Bar.qml`

**Step 1: Volume widget** — icon (`volume` / `volumeMute`) + `Audio.volume`%. Scroll adjusts ±5. Click on icon toggles mute.

**Step 2: Mic widget** — icon (`mic` / `micMute`). Click toggles mic mute. Dimmed when muted.

**Step 3:** mount both in right pill; delete old `Audio.qml`.

**Step 4: Verify**

**Step 5: Commit**

```bash
git add -A quickshell/bar/
git commit -m "QuickShell: split Audio widget into Volume and Mic"
```

---

## Task 17: Port bar/Bluetooth.qml and bar/Network.qml

**Files:**
- Modify: `quickshell/bar/Bluetooth.qml` → move to `quickshell/bar/widgets/Bluetooth.qml`
- Modify: `quickshell/bar/Network.qml` → move to `quickshell/bar/widgets/Network.qml`
- Modify: `quickshell/bar/Bar.qml`

**Step 1: Bluetooth widget** — icon (`bluetoothOn` / `bluetoothOff`) from `Bluetooth.powered`. Click → opens ControlCenter (stubbed for now; fill in Task 23).

**Step 2: Network widget** — icon (`wifiOff` / `wifiLow/Mid/High`) from `Network.connected` + `Network.signal`. Click → opens ControlCenter (stub).

**Step 3:** mount in right pill.

**Step 4: Verify**

**Step 5: Commit**

```bash
git add -A quickshell/bar/
git commit -m "QuickShell: port Bluetooth and Network widgets"
```

---

## Task 18: bar/widgets/Brightness.qml

**Files:**
- Create: `quickshell/bar/widgets/Brightness.qml`
- Modify: `quickshell/bar/Bar.qml`

**Step 1:** icon + `Brightness.percent`%. Scroll adjusts ±5 via `Brightness.set(...)`.

**Step 2:** mount in right pill (before Bluetooth).

**Step 3: Verify**

**Step 4: Commit**

```bash
git add quickshell/bar/widgets/Brightness.qml quickshell/bar/Bar.qml
git commit -m "QuickShell: add Brightness widget"
```

---

## Task 19: Port bar/Power.qml → bar/widgets/Battery.qml

**Files:**
- Create: `quickshell/bar/widgets/Battery.qml`
- Delete: `quickshell/bar/Power.qml`
- Modify: `quickshell/bar/Bar.qml`

**Step 1:** icon based on `Battery.percent` + `Battery.charging`. Text shows percent. Hidden when `!Battery.present`.

**Step 2:** mount in right pill.

**Step 3: Verify**

**Step 4: Commit**

```bash
git add -A quickshell/bar/
git commit -m "QuickShell: port Power widget to Battery"
```

---

## Task 20: Port bar/Tray.qml + TrayItem.qml

**Files:**
- Move: `quickshell/bar/Tray.qml` → `quickshell/bar/widgets/Tray.qml`
- Move: `quickshell/bar/TrayItem.qml` → `quickshell/bar/widgets/TrayItem.qml`
- Modify: `quickshell/bar/Bar.qml` (uncomment tray mount)

**Step 1:** use `Quickshell.Services.SystemTray`. Render icon per item, handle click (activate) and right-click (context menu).

**Step 2:** mount in right pill, leftmost.

**Step 3: Verify**

With at least one tray-producing app running (e.g. `blueman-applet`), confirm icon appears.

**Step 4: Commit**

```bash
git add -A quickshell/bar/
git commit -m "QuickShell: enable Tray widget via SystemTray service"
```

---

## Task 21: bar/widgets/Launcher.qml + ThemeToggle.qml + NotificationHistory.qml stub

**Files:**
- Create: `quickshell/bar/widgets/Launcher.qml`
- Create: `quickshell/bar/widgets/ThemeToggle.qml`
- Create: `quickshell/bar/widgets/NotificationHistory.qml`
- Modify: `quickshell/bar/Bar.qml`

**Step 1: Launcher** — icon button; click spawns `drmenu` via `Process`.

**Step 2: ThemeToggle** — icon button (sun/moon per `Theme.dark`); click calls `ThemeState.toggle()`.

**Step 3: NotificationHistory** — icon button; stub with no-op click + a tooltip "coming later".

**Step 4:** mount all three in right pill (ThemeToggle last).

**Step 5: Verify**

Click Launcher → `drmenu` opens. Click ThemeToggle → theme flips; kill and restart shell → theme persisted.

**Step 6: Commit**

```bash
git add -A quickshell/bar/
git commit -m "QuickShell: add Launcher, ThemeToggle, NotificationHistory widgets"
```

---

## Task 22: bar/widgets/ControlCenterButton.qml

**Files:**
- Create: `quickshell/bar/widgets/ControlCenterButton.qml`
- Modify: `quickshell/bar/Bar.qml`

**Step 1:** icon-only button; click toggles a screen-level property (`controlCenterOpen`) on the shell root. Add that property in Task 23 when the panel lands; for now it can just toggle a local bool and log.

**Step 2:** mount in right pill.

**Step 3: Verify**

**Step 4: Commit**

```bash
git add quickshell/bar/widgets/ControlCenterButton.qml quickshell/bar/Bar.qml
git commit -m "QuickShell: add ControlCenterButton widget"
```

---

## Task 23: panels/ControlCenter.qml — scaffold

**Files:**
- Create: `quickshell/panels/ControlCenter.qml`
- Modify: `quickshell/shell.qml` (mount per-screen, add `controlCenterOpen` state, anchor top-right)
- Modify: `quickshell/bar/widgets/ControlCenterButton.qml` (wire to that property)
- Modify: `quickshell/bar/widgets/Bluetooth.qml`, `Network.qml` (open the panel on click)

**Step 1: Scaffold the panel**

- `PanelWindow` anchored top + right. ~360×~320.
- Visibility bound to `shell.controlCenterOpen`.
- 200ms slide/fade animation via `Behavior on opacity` + `Behavior on y`.
- Background `Theme.bg`, 1px `Theme.border`, radius 12.
- Click-outside dismiss: a full-screen transparent `PanelWindow` layer underneath (`Quickshell.exclusiveZone = 0`) that captures clicks and closes the panel.
- Empty `ColumnLayout` inside for now.

**Step 2:** wire bar buttons.

**Step 3: Verify**

Click ControlCenterButton → panel slides in. Click outside → panel dismisses. Click Bluetooth/Network widgets → panel opens.

**Step 4: Commit**

```bash
git add quickshell/panels/ControlCenter.qml quickshell/shell.qml quickshell/bar/widgets/
git commit -m "QuickShell: add ControlCenter panel scaffold"
```

---

## Task 24: ControlCenter — toggle row (WiFi, Bluetooth, Mic, DND)

**Files:**
- Modify: `quickshell/panels/ControlCenter.qml`

**Step 1:** inside a dedicated `ToggleRow` sub-component file if it grows; otherwise inline. 4× 56×56 buttons.

- **WiFi**: active iff `Network.connected`. Click: no-op (read-only per design), but still shows state.
- **Bluetooth**: active iff `Bluetooth.powered`. Click: `Bluetooth.toggle()`.
- **Mic**: active iff `!Audio.micMuted`. Click: `Audio.setMicMuted(!Audio.micMuted)`.
- **DND**: active iff `Dnd.enabled`. Click: `Dnd.toggle()`.

Active style: `Theme.accent` bg + `Theme.bg` icon + `Theme.fg` label. Inactive: `Theme.surface` bg + `Theme.fgDim` icon + `Theme.fgDim` label. Label under icon, 10px.

**Step 2: Verify**

Each toggle shows correct initial state and reacts to clicks.

**Step 3: Commit**

```bash
git add quickshell/panels/ControlCenter.qml
git commit -m "QuickShell: ControlCenter toggle row"
```

---

## Task 25: ControlCenter — volume & brightness sliders

**Files:**
- Modify: `quickshell/panels/ControlCenter.qml`

**Step 1: Volume slider** — icon + `Slider` (0–100) bound to `Audio.volume`, `onMoved: Audio.setVolume(value)`. Track `Theme.surface`, fill `Theme.accent`. Click icon → mute.

**Step 2: Brightness slider** — same pattern with `Brightness.percent` / `Brightness.set()`.

**Step 3: Verify**

**Step 4: Commit**

```bash
git add quickshell/panels/ControlCenter.qml
git commit -m "QuickShell: ControlCenter volume and brightness sliders"
```

---

## Task 26: ControlCenter — media card

**Files:**
- Modify: `quickshell/panels/ControlCenter.qml`

**Step 1:** full-width 72px card. Visible iff `Media.active`.

- Left: 56×56 `Image { source: Media.art }` with fallback music-note glyph on `Theme.surface` when art empty.
- Middle: two stacked Text (title bold, artist dim), elided.
- Right: three icon buttons (prev, play/pause, next).

**Step 2: Verify**

With a player open: card shows art/title/artist; controls work. Without a player: card hidden, panel shrinks.

**Step 3: Commit**

```bash
git add quickshell/panels/ControlCenter.qml
git commit -m "QuickShell: ControlCenter media card"
```

---

## Task 27: osd/Osd.qml — shared OSD window

**Files:**
- Create: `quickshell/osd/Osd.qml`
- Modify: `quickshell/shell.qml` (mount once per screen)

**Step 1: Scaffold**

- `PanelWindow` anchored bottom, horizontally centered. 180×56. `Theme.bg`, radius 10, 1px `Theme.border`.
- Properties: `iconGlyph`, `valuePercent` (int, -1 → hide bar), `label` (string, used for mic mute).
- Visibility: bound to `visible` property. `Timer` auto-hides 1500ms after `show()`.
- Fade: 150ms opacity transition on visibility change.
- `ready` bool, flips true 500ms after Component.onCompleted to suppress initial OSDs.

**Step 2: Verify**

Manually trigger from the shell console (bind a keymap or call `show()` via a test button temporarily). Confirm appearance and auto-hide.

**Step 3: Commit**

```bash
git add quickshell/osd/Osd.qml quickshell/shell.qml
git commit -m "QuickShell: shared OSD window scaffold"
```

---

## Task 28: Volume, Mic, Brightness OSDs

**Files:**
- Create: `quickshell/osd/Trigger.qml` (singleton wiring — optional if inline suffices)
- Modify: `quickshell/osd/Osd.qml` (subscribe to services)

**Step 1:** inside Osd.qml, add `Connections` objects:

- `Audio.onVolumeChanged`: populate icon + percent, call `show()`. Skip if `!ready`.
- `Audio.onMutedChanged`: same with muted icon. Skip if `!ready`.
- `Audio.onMicMutedChanged`: label-only ("Muted" / "Unmuted") + mic icon. Skip if `!ready`.
- `Brightness.onPercentChanged`: icon + percent. Skip if `!ready`.

New change replaces current OSD (just overwrites properties and calls `show()` again, restarting the timer).

**Step 2: Verify**

Change volume via keybind → volume OSD appears 1.5s. Same for mic mute and brightness. No OSD flashes on shell startup.

**Step 3: Commit**

```bash
git add quickshell/osd/
git commit -m "QuickShell: wire Volume/Mic/Brightness OSDs"
```

---

## Task 29: Polish pass

**Files:** touch-ups across the shell.

**Step 1:** audit remaining hardcoded colors/fonts → replace with `Theme.*`.

**Step 2:** verify all hover states (bar widgets, panel buttons) have a subtle feedback (bg → `Theme.bgAlt`).

**Step 3:** verify icon alignment & pixel rounding in all pills (no half-pixel seams).

**Step 4:** run `qs -p quickshell/shell.qml 2>&1 | tee /tmp/qs.log`; confirm no warnings.

**Step 5: Commit**

```bash
git add -A quickshell/
git commit -m "QuickShell: polish pass — theming, hovers, alignment"
```

---

## Task 30: Wire Niri keybinds for Volume/Brightness (optional, separate commit)

**Files:**
- Modify: `niri/bindings.kdl`

Only if needed — ensure Volume/Brightness/Mic keybinds in Niri already exist and call `wpctl`/`brightnessctl`. No QuickShell changes — the OSDs react to the state change regardless of who changed it.

**Verify and commit only if diff is non-empty.**

---

## Done

Final verification:

1. `qs -p quickshell/shell.qml` — no warnings
2. All bar widgets functional
3. ControlCenter opens/closes, all toggles + sliders + media card work
4. OSDs appear on volume/mic/brightness changes, not on startup
5. Theme toggle persists across restarts
