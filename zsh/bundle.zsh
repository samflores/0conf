### Added by Zinit's installer
if [[ ! -f $ZDOTDIR/zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/zinit" && command chmod g-rwX "$ZDOTDIR/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$ZDOTDIR/zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$ZDOTDIR/zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

zinit snippet https://gist.githubusercontent.com/hightemp/5071909/raw/

zinit wait lucid for \
  atinit"zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  atload"bindkey '^[[A' history-substring-search-up" \
  atload"bindkey '^[[B' history-substring-search-down" \
  atload"bindkey -M vicmd k history-substring-search-up" \
  atload"bindkey -M vicmd j history-substring-search-down" \
    zsh-users/zsh-history-substring-search \
  atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
    zsh-users/zsh-completions \
  softmoth/zsh-vim-mode \
  mdumitru/fancy-ctrl-z \
  atload"bindkey '^ ' fuck-command-line" \
    laggardkernel/zsh-thefuck \
  samflores/docker-aliases \
  samflores/git-aliases \
  samflores/rails-aliases \
  MichaelAquilina/zsh-you-should-use \
