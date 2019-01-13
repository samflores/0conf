source /usr/share/zsh/scripts/zplug/init.zsh

zplug 'zsh-users/zsh-syntax-highlighting'
zplug 'zsh-users/zsh-history-substring-search'
zplug 'zsh-users/zsh-autosuggestions'
zplug 'zsh-users/zsh-completions'
zplug 'softmoth/zsh-vim-mode'
zplug 'webyneter/docker-aliases'
zplug 'mdumitru/fancy-ctrl-z'
zplug 'MichaelAquilina/zsh-you-should-use'

if ! zplug check; then
  zplug install
fi

zplug load
