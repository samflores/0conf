# chruby
[[ $+commands[chruby-exec] ]] && \
  source "${commands[chruby-exec]:h:h}/share/chruby/chruby.sh" && \
  source "${commands[chruby-exec]:h:h}/share/chruby/auto.sh" && \
  alias chrb=chruby && \
  chruby 2.4.3


