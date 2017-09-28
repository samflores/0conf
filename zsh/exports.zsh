export GIT_AUTHOR_NAME='Samuel Flores'
export GIT_AUTHOR_EMAIL='me@samflor.es'
export GIT_COMMITTER_NAME='$GIT_AUTHOR_NAME'
export GIT_COMMITTER_EMAIL='$GIT_AUTHOR_EMAIL'

# Setup terminal, and turn on colors
export TERM=xterm-256color-italic
export CLICOLOR=1

# Enable color in grep
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='3;33'

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

# Compiling stuff on OS X
[[ -e $commands[brew] ]] && export ARCHFLAGS='-arch x86_64'

# Lang && Editor
export LC_COLLATE=C
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
export CLICOLOR='yes'
export PAGER='less'
export VISUAL='nvim'
export EDITOR=$VISUAL

export NVIM_TUI_ENABLE_TRUE_COLOR=1
export NVIM_TUI_ENABLE_CURSOR_SHAPE=1
export NVIM_LISTEN_ADDRESS=.nvimsocket 
export EVENT_NOKQUEUE=1

