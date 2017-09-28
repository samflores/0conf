if (( ! $+commands[tmux] )); then
  return 1
fi

[[ "$TERM_PROGRAM" = 'iTerm.app' ]] && _tmux_iterm_integration='-CC'

if [[ -z "$TMUX" && -z "$EMACS" && -z "$VIM" && -z "$SSH_TTY" ]]; then
  # tmux start-server

  if ! tmux has-session 2> /dev/null; then
    tmux_session='default'
    tmux \
      new-session -d -s "$tmux_session" \; \
      set-option -t "$tmux_session" destroy-unattached off &> /dev/null \
    # tmux new-session -d -s "default" \; set-option -t "default" destroy-unattached off &> /dev/null
  fi

  exec tmux $_tmux_iterm_integration attach-session
fi

alias tmux='tmux -2'
alias tmuxa="tmux $_tmux_iterm_integration new-session -A"
alias tmuxl='tmux list-sessions'

