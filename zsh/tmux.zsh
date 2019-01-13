(! [[ $+commands[tmux] ]] ) && return 1

[[ "$TERM_PROGRAM" = 'iTerm.app' ]] && _tmux_iterm_integration='-CC'

if [[ -z "$TMUX" && -z "$EMACS" && -z "$VIM" && -z "$SSH_TTY" ]]; then
  tmux start-server

  if ! tmux has-session 2> /dev/null; then
    for tmux_session in eq cm42
    do
      tmux \
        set-option -g default-shell "/bin/zsh" \; \
        new-session -d -s "$tmux_session" \; \
        set-option -t "$tmux_session" destroy-unattached off &> /dev/null
    done
  fi

  exec tmux $_tmux_iterm_integration attach-session
fi

alias tmux='tmux -2'
alias tmuxa="tmux $_tmux_iterm_integration new-session -A"
alias tmuxl='tmux list-sessions'

