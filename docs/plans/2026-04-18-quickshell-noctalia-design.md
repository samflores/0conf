# QuickShell: Noctalia-inspired config (design)

Date: 2026-04-18

## Goal

A QuickShell config that borrows Noctalia's look — detached pill-shaped
bar, slide-out control center, centered OSDs — while running on
**upstream QuickShell** (no fork) and **skipping** features already
handled elsewhere in this dotfiles repo: wallpaper (hyprpaper), idle
(hypridle), lock (hyprlock), notifications (existing external daemon),
launcher UI (`drmenu`).

## Scope

**In:**
- Restyled bar with pill segments (left/center/right), Nerd Font icons, gypsum palette
- Bar widgets: workspaces, active window, clock, media mini, mic, volume, bluetooth, network, tray (working), notification-history indicator, brightness, battery, launcher button, theme toggle
- Control center panel (top-right, slide-in): wifi/bluetooth/mic/DND toggles, volume + brightness sliders, media card (MPRIS)
- OSDs: volume, mic mute, brightness
- Light/dark theme toggle with persistence
- `Icons.qml` rewritten to Nerd Font glyphs

**Out (delegated):**
- Wallpaper, idle, lock, notifications, launcher UI

## Architecture

```
quickshell/
  shell.qml                    # root, Variants per screen
  theme/
    Theme.qml                  # Singleton: palette + geometry + fonts
    ThemeState.qml             # Singleton: dark bool, persists to state file
  utils/
    Icons.qml                  # Nerd Font glyph map (rewritten)
  services/
    Audio.qml                  # existing, adapted to use Quickshell.Services.Pipewire
    Brightness.qml             # brightnessctl wrapper
    Network.qml                # nmcli wrapper
    Bluetooth.qml              # bluetoothctl wrapper
    Media.qml                  # Quickshell.Services.Mpris facade
    Battery.qml                # Quickshell.Services.UPower facade
    Dnd.qml                    # local bool, persists to state file
  bar/
    Bar.qml                    # three-pill layout
    widgets/
      Workspaces.qml  ActiveWindow.qml  Clock.qml  MediaMini.qml
      Mic.qml  Volume.qml  Bluetooth.qml  Network.qml
      Tray.qml  TrayItem.qml  NotificationHistory.qml
      Brightness.qml  Battery.qml  Launcher.qml  ThemeToggle.qml
      ControlCenterButton.qml
  panels/
    ControlCenter.qml
  osd/
    Osd.qml  VolumeOsd.qml  BrightnessOsd.qml  MicOsd.qml
```

Services are QML singletons exposing observable state. Widgets and
panels read from singletons; they do not shell out directly.

OSDs subscribe to service value-change signals.

## Theme

Palette pulled from `gypsum/lua/gypsum/palette.lua` (`M.dark` + `M.light`).

**Dark** — bg `#0E1415`, bgAlt `#1A1F20`, surface `#293334`,
fg `#CECECE`, fgDim `#708B8D`, accent `#71ADE7`, ok `#95CB82`,
warn `#CD974B`, err `#CC3333`, border `#1A1F20`.

**Light** — bg `#F7F7F7`, bgAlt `#F0F0F0`, surface `#E0E0E0`,
fg `#000000`, fgDim `#777777`, accent `#325CC0`, ok `#448C27`,
warn `#FFBC5D`, err `#AA3731`, border `#E0E0E0`.

**Geometry:** bar height 28, pill radius 10, pill padding 8, widget
gap 6, outer margin 8.

**Typography:** `MonaspiceAr Nerd Font Mono`, text 12px, icons 14px.

**Persistence:** `~/.local/state/quickshell/theme` holds one line
(`dark` | `light`). `ThemeState` reads on startup, writes on toggle.

## Bar

Three floating pills per screen:

- **Left pill**: Workspaces · ActiveWindow
- **Center pill**: Clock · MediaMini (MediaMini collapses to icon when no player)
- **Right pill**: Tray · NotificationHistory · Mic · Volume · Brightness · Battery · Bluetooth · Network · ControlCenterButton · Launcher · ThemeToggle

**Widget idiom:** icon + optional value text (`󰕾 65%`). Color encodes
state (muted → dim, error → err). Scroll on Volume/Brightness adjusts;
click on Mic toggles mute; click on Network/Bluetooth opens control
center; click on Launcher spawns `drmenu`; click on ThemeToggle flips
theme; click on ControlCenterButton toggles the panel.

## Control center

`PanelWindow` anchored top-right, below bar. ~360×~320px, rounded
(radius 12), `Theme.bg`, 1px `Theme.border`. 200ms slide-in
(opacity + y translate).

Contents top-to-bottom:

1. **Toggle row**: WiFi · Bluetooth · Mic · DND. 4× 56×56 rounded
   squares. Active → accent bg; inactive → surface bg.
2. **Volume slider**: icon + horizontal slider + %. Scroll works.
   Click icon → mute.
3. **Brightness slider**: sun icon + slider + %.
4. **Media card** (hidden when no MPRIS player): 72px tall, album art +
   title/artist + prev/play-pause/next controls.

Dismiss: click outside, Esc, or re-click the bar button.

## OSDs

Shared 180×56 rounded popup, centered horizontally, ~20% from bottom.
Icon + progress bar (or mute label).

Subscribes to Audio/Brightness/Mic services. Shows for 1.5s, fades out
(150ms). Only one visible at a time — a new change replaces whatever's
showing. A "ready" flag suppresses OSDs for ~500ms after shell startup
to avoid initial-value spam.

## External dependencies

Built-in QuickShell services: Mpris, SystemTray, Pipewire, UPower.

Shelled out via `Quickshell.Io.Process`: `brightnessctl`, `nmcli`,
`bluetoothctl`, `wpctl`, `drmenu`.

Niri IPC via the existing custom `Niri 0.1` QML module (workspaces +
active window).

## State files

`~/.local/state/quickshell/`:

- `theme` — `dark` or `light`
- `dnd` — `on` or `off`

Plain text, one line each.

## Out of scope (explicitly)

- Wallpaper handling (hyprpaper)
- Idle handling (hypridle)
- Lock screen (hyprlock)
- Notification toasts (external daemon: mako/dunst)
- Launcher UI (`drmenu` runs as subprocess)
- Calendar popout, notification history panel, per-toggle submenus
  (wifi network list, bluetooth device picker) — deferred
- DND integration with a notification daemon — local bool for now,
  wire to `makoctl`/`dunstctl` later
