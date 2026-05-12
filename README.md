# 0conf

My dotfiles.

## Modules

| Module       | What                                                       |
| ------------ | ---------------------------------------------------------- |
| `nvim`       | Neovim config                                              |
| `fish`       | Fish shell                                                 |
| `zsh`        | Zsh shell (`.zshrc`, `.zshenv`, `.zprofile`)               |
| `tmux`       | tmux + sesh                                                |
| `niri`       | Niri scrollable-tile compositor                            |
| `hypr`       | Hyprland (legacy; superseded by niri)                      |
| `quickshell` | Quickshell bar + notification daemon (Google Calendar widget needs `gcalcli`, see below) |
| `mako`       | Mako notification daemon                                   |
| `stasis`     | Idle daemon (replaces hypridle)                            |
| `swaylock`   | Screen locker (replaces hyprlock)                          |
| `ghostty`    | Ghostty terminal                                           |
| `kitty`      | Kitty terminal                                             |
| `rofi`       | Rofi launcher                                              |
| `eww`        | Eww widgets                                                |
| `fontconfig` | Font config                                                |
| `git`        | `~/.gitconfig` + `~/.gitignore_global`                     |
| `qutebrowser`| qutebrowser                                                |
| `pi`         | `pi` CLI config                                            |
| `greetd`     | greetd + niri-based greeter (system-wide; install as root) |

`awww` is used as the wallpaper tool (replaces hyprpaper).

## Install

`install.sh` symlinks selected modules into `$XDG_CONFIG_HOME` (or `$HOME` for some) and warns about missing runtime deps. It does **not** install dependencies.

```sh
./install.sh                  # interactive picker (gum) or defaults
./install.sh --defaults       # default set
./install.sh --all            # everything
./install.sh nvim fish tmux   # named modules
./install.sh --dry-run ...    # print actions, touch nothing
```

Defaults: `nvim fish tmux niri quickshell ghostty fontconfig git pi stasis swaylock`.

The interactive picker uses [gum](https://github.com/charmbracelet/gum) for the module checklist and the wallpaper chooser. If `gum` isn't on `$PATH`, the installer falls back to the default set (and a numbered prompt for the wallpaper).

Existing files at the target are backed up to `<path>.back`; existing symlinks are replaced.

`greetd` is not symlinked automatically — the installer prints the `sudo ln` commands to run.

## Google Calendar widget (optional)

The Quickshell calendar widget reads events through [`gcalcli`](https://github.com/insanum/gcalcli). It's optional — without it, the panel just shows an empty events section.

### One-time OAuth client

Each user needs their own Google OAuth client (gcalcli 4.x no longer ships a bundled one).

1. https://console.cloud.google.com → New Project → name it anything (e.g. `qs-calendar`).
2. **APIs & Services → Library** → enable **Google Calendar API**.
3. **OAuth consent screen** → User type **External** → fill app name, support email, developer email → **Save and Continue** through Scopes (no entries) and Test Users (add every Google account email you'll authenticate). Leave the app in **Testing** mode.
4. **Credentials → Create Credentials → OAuth client ID** → Application type **Desktop app** → save. Copy the **Client ID** and **Client secret**.

One client can authenticate multiple Google accounts — just add each account's email under Test Users.

### Per-account setup

`gcalcli` data is stored under `~/.config/0conf/gcal/accounts/<alias>/`. Both `$GCALCLI_CONFIG` and `$XDG_DATA_HOME` must be set on every gcalcli call so the per-account config, OAuth token, and cache stay isolated.

For each Google account you want in the widget:

```fish
# Pick a short alias per account (e.g. work, personal).
set alias work

mkdir -p ~/.config/0conf/gcal/accounts/$alias
printf '[auth]\nclient-id = "<CLIENT_ID>"\n' \
    > ~/.config/0conf/gcal/accounts/$alias/config.toml

env GCALCLI_CONFIG=$HOME/.config/0conf/gcal/accounts/$alias \
    XDG_DATA_HOME=$HOME/.config/0conf/gcal/accounts/$alias \
    gcalcli --client-secret '<CLIENT_SECRET>' init

# Verify:
env GCALCLI_CONFIG=$HOME/.config/0conf/gcal/accounts/$alias \
    XDG_DATA_HOME=$HOME/.config/0conf/gcal/accounts/$alias \
    gcalcli list
```

`init` opens a browser for OAuth — sign in with the matching account.

### Widget config

Edit `~/.config/0conf/gcal/settings.json`:

```json
{
  "refresh_interval_minutes": 10,
  "lookahead_days": 7,
  "accounts": [
    { "alias": "work",     "label": "Work",     "color": "#82cfff", "calendars": [] },
    { "alias": "personal", "label": "Personal", "color": "#ff7eb6", "calendars": [] }
  ]
}
```

Empty `calendars` = show all calendars from that account. Use the CALENDARS picker in the panel (or edit the file directly) to filter.

## License

[WTFPL](LICENSE).

