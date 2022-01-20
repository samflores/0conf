export GIT_AUTHOR_NAME='Samuel Flores'
export GIT_AUTHOR_EMAIL='me@samflor.es'
export GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME
export GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL

export TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S'

# Less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[38;5;246m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[04;33;146m'
export LESS='-R --ignore-case --raw-control-chars'

# History
export HISTSIZE=10000000
export SAVEHIST=10000000
export HISTFILE=$ZDOTDIR/.zsh_history

# Java
[[ -e /usr/libexec/java_home ]] && export JAVA_HOME=$(/usr/libexec/java_home)
export JRUBY_OPTS='-J-XX:+TieredCompilation -J-XX:TieredStopAtLevel=1 -J-noverify'
# export BOOT_JVM_OPTIONS='--add-modules=java.xml.bind'
# export JVM_OPTS='--add-modules=java.xml.bind'

# Lang && Editor
export LC_COLLATE=C
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
export CLICOLOR='yes'
export PAGER='less'
[[ -e $commands[nvr] ]] && 
  alias e='open-vim-with-nvr' &&
  export VISUAL='nvr -s --servername "$(pwd)/.nvim" --remote' &&
  export GIT_EDITOR='nvr -s -cc split --servername "$(pwd)/.nvim" --remote-wait'
[[ ! -e $commands[nvr] ]] &&
  alias e='nvim' &&
  export VISUAL='nvim' &&
  export GIT_EDITOR='nvim'
export EDITOR=$VISUAL
export TERMINAL=st

export NVIM_TUI_ENABLE_TRUE_COLOR=1
export NVIM_TUI_ENABLE_CURSOR_SHAPE=1
export EVENT_NOKQUEUE=1

export PKG_CONFIG_PATH=/usr/local/opt/openssl/lib/pkgconfig
export BAT_THEME="Monokai Extended Light"

export HOST_IP=172.17.0.1

export DENO_INSTALL="/home/samflores/.deno"
