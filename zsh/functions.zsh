function mkcd {
  [[ -n "$1" ]] && mkdir -p "$1" && builtin cd "$1"
}

function find-exec {
  find . -type f -iname "*${1:-}*" -exec "${2:-file}" '{}' \;
}

function psu {
  ps -U "${1:-$LOGNAME}" -o 'pid,%cpu,%mem,command' "${(@)argv[2,-1]}"
}

function zsh_recompile {
  autoload -U zrecompile
  rm -f $ZDOTDIR/*.zwc
  [[ -f $ZDOTDIR/.zshrc ]] && zrecompile -p $ZDOTDIR/.zshrc
  [[ -f $ZDOTDIR/.zshrc.zwc.old ]] && rm -f $ZDOTDIR/.zshrc.zwc.old

  for f in $ZDOTDIR/**/*.zsh; do
    [[ -f $f ]] && zrecompile -p $f
    [[ -f $f.zwc.old ]] && rm -f $f.zwc.old
  done

  [[ -f ~/.zcompdump ]] && zrecompile -p ~/.zcompdump
  [[ -f ~/.zcompdump.zwc.old ]] && rm -f ~/.zcompdump.zwc.old

  source $ZDOTDIR/.zshrc
}

function open-vim-with-nvr {
  [ ! $(nvr --serverlist|rg "$(pwd) ]/.nvim") ] && rm -f "$(pwd)/.nvim"
  nvr -s --servername "$(pwd)/.nvim" $*
}

function extract {
  echo Extracting $1 ...
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1  ;;
      *.tar.gz)    tar xzf $1  ;;
      *.bz2)       bunzip2 $1  ;;
      *.rar)       unrar x $1    ;;
      *.gz)        gunzip $1   ;;
      *.tar)       tar xf $1   ;;
      *.tbz2)      tar xjf $1  ;;
      *.tgz)       tar xzf $1  ;;
      *.zip)       unzip $1   ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1  ;;
      *)        echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Detect empty enter, execute git status if in git dir
function magic-enter () {
  if [[ -z $BUFFER ]]; then
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
      echo -ne '\n'
      git status --short
    fi
    zle accept-line
  else
    zle accept-line
  fi
}
zle -N magic-enter
bindkey "^M" magic-enter

function wttr() {
  local request="wttr.in/${1-Teresina}?Q0m"
  [ "$(tput cols)" -lt 125 ] && request+='n'
  curl -H "Accept-Language: ${LANG%_*}" --compressed "$request"
}
