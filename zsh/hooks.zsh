if [[ -n $TMUX ]]; then
  escseq() { printf "\033Ptmux;\033\033]$1\007\033\\" }
else
  escseq() { printf "\033]$1\007" }
fi

if [[ -n $ITERM_PROFILE && -o login ]]; then
  before_cmd_executes() { escseq "133;C" }
  after_cmd_executes() {
    escseq "133;D;$1"
    escseq "1337;RemoteHost=$USER@$(hostname -f)"
    escseq "1337;CurrentDir=$PWD"
  }
  escseq "1337;ShellIntegrationVersion=1"
  after_cmd_executes 0
else
  before_cmd_executes() { }
  after_cmd_executes() { }
fi

precmd() {
  if [[ -n "$TMUX" ]]; then
    tmux setenv "$(tmux display -p 'TMUX_PWD_#D')" "$PWD"
  fi
}

function chpwd() {
  [[ -r $PWD/.zsh_config ]] && source $PWD/.zsh_config
  [[ -f Cargo.toml && -f ~/.cargo/env ]] && source ~/.cargo/env

  if [[ -d ./env && -d ./env/bin/activate ]] ; then
    [[ -e $commands[deactivate] ]] && deactivate && echo 'Previous environment deactivated'
    source ./env/bin/activate && echo 'Environment activated'
  fi
  if [[ -x ./manage.py && -d ./.env && -e $commands[envdir] ]] ; then
    djx() { envdir .env ./manage.py $* }
  elif [[ -e $functions[djx] ]] ; then
    unset -f djx
  fi
}
