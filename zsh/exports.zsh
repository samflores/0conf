export GIT_AUTHOR_NAME='Samuel Flores'
export GIT_AUTHOR_EMAIL='me@samflor.es'
export GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME
export GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL

# Setup terminal, and turn on colors
# export TERM=xterm-256color-italic
export CLICOLOR=1

# Less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[38;5;246m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[04;33;146m'
export LESS='-R --ignore-case --raw-control-chars'

# Java
[[ -e /usr/libexec/java_home ]] && export JAVA_HOME=$(/usr/libexec/java_home)
export JRUBY_OPTS='-J-XX:+TieredCompilation -J-XX:TieredStopAtLevel=1 -J-noverify'
# export BOOT_JVM_OPTIONS='--add-modules=java.xml.bind'
# export JVM_OPTS='--add-modules=java.xml.bind'

# Compiling stuff on OS X
[[ -e $commands[brew] ]] && export ARCHFLAGS='-arch x86_64'

# Lang && Editor
export LC_COLLATE=C
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
export CLICOLOR='yes'
export PAGER='less'
[[ -e $commands[nvr] ]] && export VISUAL='nvr -s --remote'
[[ -e $commands[nvr] ]] && export GIT_EDITOR='nvr -s -cc split --remote-wait'
[[ ! -e $commands[nvr] ]] && export VISUAL='nvim'
[[ ! -e $commands[nvr] ]] && export GIT_EDITOR='nvim'
export EDITOR=$VISUAL

export NVIM_TUI_ENABLE_TRUE_COLOR=1
export NVIM_TUI_ENABLE_CURSOR_SHAPE=1
export NVIM_LISTEN_ADDRESS=.nvimsocket
export EVENT_NOKQUEUE=1

export PKG_CONFIG_PATH=/usr/local/opt/openssl/lib/pkgconfig
export BAT_THEME="Monokai Extended Light"

export HOST_IP=172.17.0.1
