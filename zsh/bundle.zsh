### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust \
    jeffreytse/zsh-vi-mode

### End of Zinit's installer chunk

zinit depth"1" wait lucid for \
  atinit"zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
  atload"bindkey '^[[A' history-substring-search-up" \
  atload"bindkey '^[[B' history-substring-search-down" \
  atload"bindkey -M vicmd k history-substring-search-up" \
  atload"bindkey -M vicmd j history-substring-search-down" \
    zsh-users/zsh-history-substring-search \
  blockf atpull'zinit creinstall -q .' \
    zsh-users/zsh-completions \
  mdumitru/fancy-ctrl-z \
  atload"bindkey '^ ' fuck-command-line" \
    laggardkernel/zsh-thefuck \
  MichaelAquilina/zsh-you-should-use \
  samflores/docker-aliases \
  samflores/git-aliases \
  samflores/rails-aliases
