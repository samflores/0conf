#!/usr/bin/env bash
#
# 0conf installer. Picks modules to link into $XDG_CONFIG_HOME and
# warns about missing runtime dependencies. Does NOT install anything.

set -u

origin="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target="${XDG_CONFIG_HOME:-$HOME/.config}"

# Module name → source dir (relative to repo).
declare -A SRC=(
    [nvim]="nvim"
    [fish]="fish"
    [tmux]="tmux"
    [niri]="niri"
    [hypr]="hypr"
    [mako]="mako"
    [stasis]="stasis"
    [swaylock]="swaylock"
    [quickshell]="quickshell"
    [ghostty]="ghostty"
    [fontconfig]="fontconfig"
    [git]="gitconfig"
    [pi]="pi"
    [eww]="eww"
    [rofi]="rofi"
    [kitty]="kitty"
    [zsh]="zsh"
    [qutebrowser]="qutebrowser"
)

# Default selection.
DEFAULTS=(nvim fish tmux niri quickshell ghostty fontconfig git pi stasis swaylock)

# Runtime dependency map. Missing deps are warned, never installed.
declare -A DEPS=(
    [nvim]="nvim"
    [fish]="fish eza fzf"
    [tmux]="tmux sesh"
    [niri]="niri grim slurp satty jq wlsunset awww"
    [hypr]="hyprpaper hypridle hyprlock"
    [stasis]="stasis"
    [swaylock]="swaylock"
    [mako]="mako"
    [quickshell]="qs brightnessctl bluetoothctl iwctl wpctl"
    [ghostty]="ghostty"
    [fontconfig]=""
    [git]="git gh git-lfs"
    [pi]="pi"
    [eww]="eww"
    [rofi]="rofi"
    [kitty]="kitty"
    [zsh]="zsh"
    [qutebrowser]="qutebrowser"
)

ALL_MODULES=("${!SRC[@]}")

usage() {
    cat <<EOF
usage: $0 [options] [modules...]

Symlinks modules into \$XDG_CONFIG_HOME (or \$HOME for some) and warns
about missing runtime dependencies. Does NOT install dependencies.

Modules (pass by name):
  $(printf '%s\n' "${ALL_MODULES[@]}" | sort | tr '\n' ' ')

Options:
  -a, --all           Install every module.
  -d, --defaults      Install the default set (${DEFAULTS[*]}).
  -i, --interactive   Pick with gum (default when no args given).
  -n, --dry-run       Print actions, don't touch disk.
  -h, --help          This help.
EOF
}

have() { command -v "$1" >/dev/null 2>&1; }

check_deps() {
    local module="$1"
    local deps="${DEPS[$module]:-}"
    [[ -z "$deps" ]] && return
    local missing=()
    for d in $deps; do
        have "$d" || missing+=("$d")
    done
    if (( ${#missing[@]} > 0 )); then
        printf '  \033[33m! missing:\033[0m %s\n' "${missing[*]}"
    fi
}

link_to() {
    local src="$1" dst="$2"
    if [[ "$DRY" == 1 ]]; then
        printf '  \033[36mwould link\033[0m %s -> %s\n' "$dst" "$src"
        return
    fi
    if [[ -L "$dst" ]]; then
        rm "$dst"
    elif [[ -e "$dst" ]]; then
        mv "$dst" "${dst}.back"
        printf '  \033[33mbacked up\033[0m %s -> %s.back\n' "$dst" "$dst"
    fi
    ln -sf "$src" "$dst"
    printf '  \033[32mlinked\033[0m %s -> %s\n' "$dst" "$src"
}

install_module() {
    local module="$1"
    local src="$origin/${SRC[$module]}"

    if [[ ! -d "$src" && ! -f "$src" ]]; then
        printf '\033[31m! %s: source %s not found, skipping\033[0m\n' "$module" "$src"
        return
    fi

    printf '\033[1m== %s ==\033[0m\n' "$module"

    case "$module" in
        git)
            link_to "$origin/gitconfig" "$HOME/.gitconfig"
            link_to "$origin/gitignore_global" "$HOME/.gitignore_global"
            ;;
        zsh)
            link_to "$src" "$target/zsh"
            if [[ "$DRY" != 1 ]]; then
                ln -sf "$target/zsh/zshrc" "$HOME/.zshrc"
                ln -sf "$target/zsh/zshenv" "$HOME/.zshenv"
                ln -sf "$target/zsh/zprofile" "$HOME/.zprofile"
                printf '  \033[32mlinked\033[0m ~/.zshrc, ~/.zshenv, ~/.zprofile\n'
            fi
            ;;
        *)
            link_to "$src" "$target/$module"
            ;;
    esac

    check_deps "$module"
}

# ---- arg parsing ----

MODE=""
DRY=0
MODULES=()

while (( $# > 0 )); do
    case "$1" in
        -a|--all)          MODE="all" ;;
        -d|--defaults)     MODE="defaults" ;;
        -i|--interactive)  MODE="interactive" ;;
        -n|--dry-run)      DRY=1 ;;
        -h|--help)         usage; exit 0 ;;
        --) shift; while (( $# > 0 )); do MODULES+=("$1"); shift; done ;;
        -*) printf 'unknown option: %s\n' "$1" >&2; usage; exit 1 ;;
        *)  MODULES+=("$1") ;;
    esac
    shift
done

# Resolve final module list.
if (( ${#MODULES[@]} > 0 )); then
    :
elif [[ "$MODE" == "all" ]]; then
    MODULES=("${ALL_MODULES[@]}")
elif [[ "$MODE" == "defaults" ]]; then
    MODULES=("${DEFAULTS[@]}")
else
    if ! have gum; then
        printf 'gum not installed; falling back to defaults.\n' >&2
        printf '(use --all, --defaults, or pass module names)\n' >&2
        MODULES=("${DEFAULTS[@]}")
    else
        declare -A in_defaults=()
        for m in "${DEFAULTS[@]}"; do in_defaults[$m]=1; done
        selected_flags=()
        for m in "${ALL_MODULES[@]}"; do
            [[ ${in_defaults[$m]:-} == 1 ]] && selected_flags+=(--selected "$m")
        done
        mapfile -t MODULES < <(
            printf '%s\n' "${ALL_MODULES[@]}" | sort |
            gum choose --no-limit \
                --height "${#ALL_MODULES[@]}" \
                --header "Pick modules (space to toggle, enter to confirm)" \
                "${selected_flags[@]}"
        )
        (( ${#MODULES[@]} == 0 )) && { echo "Nothing selected."; exit 0; }
    fi
fi

# Validate.
for m in "${MODULES[@]}"; do
    if [[ -z "${SRC[$m]:-}" ]]; then
        printf 'unknown module: %s\n' "$m" >&2
        exit 1
    fi
done

for m in "${MODULES[@]}"; do
    install_module "$m"
done

printf '\n\033[1mdone.\033[0m\n'
