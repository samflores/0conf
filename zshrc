source ~/.zsh/colors.zsh
source ~/.zsh/setopt.zsh
source ~/.zsh/exports.zsh
source ~/.zsh/prompt.zsh
source ~/.zsh/completion.zsh
source ~/.zsh/aliases.zsh
source ~/.zsh/bindkeys.zsh
source ~/.zsh/functions.zsh
source ~/.zsh/history.zsh
source ~/.zsh/zsh_hooks.zsh
source ~/.zsh/path.zsh
source ~/.zsh/tmux.zsh

# Externals
source ~/.zsh/syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/history-substring-search/zsh-history-substring-search.zsh

# chruby
[[ $+commands[chruby-exec] ]] && \
  source "${commands[chruby-exec]:h:h}/share/chruby/chruby.sh" && \
  alias chrb=chruby && \
  chruby 2.2.3

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
