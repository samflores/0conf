# ---- Simple aliases
alias ri 'ri -Tf ansi'
alias vi nvim
alias rb ruby
alias mx 'tmux -2 new-session -A -s work'
alias o rifle

# ---- Interactive picker
alias 'e.' 'e (fd --type file --color=always | sk -m --ansi)'

# ---- ls / eza family
alias ls 'eza --color=auto'
alias l  'eza -1A'
alias ll 'eza -lh'
alias lr 'll -R'
alias la 'll -A'
alias lm 'la | $PAGER'
alias lx 'll -XB'
alias lk 'll -Sr'
alias lt 'll -tr'
alias lc 'lt -c'
alias lu 'lt -u'

# ---- Network / utils
alias ifconfig 'ip address show'
alias tree 'eza --tree'

# ---- doas shortcut
abbr --add --global _ doas
abbr --add --global sudo doas

# ---- Directory stack
alias po popd
alias pu pushd

# ---- type
alias type 'type -a'

# ---- top
alias top 'btop'
