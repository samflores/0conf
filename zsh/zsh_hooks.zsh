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

