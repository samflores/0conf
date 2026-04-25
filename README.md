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
| `quickshell` | Quickshell bar + notification daemon                       |
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

## License

[WTFPL](LICENSE).

