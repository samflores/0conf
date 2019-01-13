(! [[ $+commands[tmate] && $ITERM_PROFILE = 'tmate' ]] ) && return 1

_tmate_sock='/tmp/tmate.sock'
alias tm='tmate -S $_tmate_sock'
alias tma="tmate $_tmate_iterm_integration new-session -A"
alias tml='tmate list-sessions'
alias tmssh="tmate display -p '#{tmate_ssh}'"
alias tmsshro="tmate display -p '#{tmate_ssh_ro}'"
alias tmweb="tmate display -p '#{tmate_web}'"

[[ "$TERM_PROGRAM" = 'iTerm.app' ]] && _tmux_iterm_integration='-CC'

if [[ -z "$TMUX" && -z "$EMACS" && -z "$VIM" && -z "$SSH_TTY" ]]; then
  if ! tmate has-session 2> /dev/null; then
    tmux_session='default'
    tmate \
      -S $_tmate_sock \
      new-session -d -s "$tmux_session" \; \
      set-option -t "$tmux_session" destroy-unattached off &> /dev/null
    # new-session -d -s "default" \; set-option -t "default" destroy-unattached off &> /dev/null
  fi

  exec tmate -S $_tmate_sock $_tmux_iterm_integration attach-session
fi


