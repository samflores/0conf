# ---- Git identity
set -x GIT_AUTHOR_NAME 'Samuel Flores'
set -x GIT_AUTHOR_EMAIL 'me@samflor.es'
set -x GIT_COMMITTER_NAME $GIT_AUTHOR_NAME
set -x GIT_COMMITTER_EMAIL $GIT_AUTHOR_EMAIL

# ---- time builtin formatting
set -x TIMEFMT "\nreal\t%E\nuser\t%U\nsys\t%S"

# ---- less / pager
set -x LESS_TERMCAP_mb "\e[01;31m"
set -x LESS_TERMCAP_me "\e[0m"
set -x LESS_TERMCAP_se "\e[0m"
set -x LESS_TERMCAP_so "\e[38;5;246m"
set -x LESS_TERMCAP_ue "\e[0m"
set -x LESS_TERMCAP_us "\e[04;33;146m"
set -x LESS '-R --ignore-case --raw-control-chars'
set -x PAGER less

# ---- History
set -U fish_history_max 10000000
set -U fish_history_file ~/.local/share/fish/fish_history

# ---- Java
if test -e /usr/libexec/java_home
    set -x JAVA_HOME (/usr/libexec/java_home)
end

set -x JRUBY_OPTS '-J-XX:+TieredCompilation -J-XX:TieredStopAtLevel=1 -J-noverify'
# set -x BOOT_JVM_OPTIONS '--add-modules=java.xml.bind'
# set -x JVM_OPTS '--add-modules=java.xml.bind'

# ---- Locale
set -x LC_COLLATE C
set -x LANG 'en_US.UTF-8'
set -x LC_ALL 'en_US.UTF-8'

# ---- Editor
alias e nvim
set -x VISUAL nvim
set -x GIT_EDITOR nvim

set -x EDITOR $VISUAL
set -x TERMINAL st

# ---- Neovim / misc
set -x NVIM_TUI_ENABLE_TRUE_COLOR 1
set -x NVIM_TUI_ENABLE_CURSOR_SHAPE 1
set -x EVENT_NOKQUEUE 1
set -x CLICOLOR yes

# ---- Tooling paths
set -x PKG_CONFIG_PATH /usr/local/opt/openssl/lib/pkgconfig
set -x BAT_THEME 'Monokai Extended Light'

set -x HOST_IP 172.17.0.1
set -x DENO_INSTALL $HOME/.deno

set -x BUNDLE_PATH $HOME/.gem/ruby/3.4.0
set -x BUNDLE_CACHE_PATH $HOME/.bundle/cache
set -x BUNDLE_BIN $HOME/.bundle/bin

set -x ANDROID_NDK_ROOT $HOME/Android/Sdk/ndk/27.0.12077973
set -x ANDROID_HOME $HOME/Android/Sdk

set -x ZK_NOTEBOOK_DIR $HOME/Documents/Notes
set -x PASSWORD_STORE_DIR $HOME/.local/share/password-store

# --- Rust
set -gx CARGO_HOME /home/samflores/.local/share/cargo

# --- Pi coding agent
set -gx PI_CODING_AGENT_DIR $HOME/.config/pi/agent

# --- Claude Code
set -gx CLAUDE_CONFIG_DIR $HOME/.config/claude-code
