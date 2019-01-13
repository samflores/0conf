# To see the key combo you want to use just do:
# cat > /dev/null
# And press it

bindkey -v
# Better searching in command mode
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd '/' history-incremental-search-forward

# Beginning search with arrow keys
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd "k" history-substring-search-up
bindkey -M vicmd "j" history-substring-search-down

autoload edit-command-line
zle -N edit-command-line

# # Easier, more vim-like editor opening
# bindkey -M vicmd v edit-command-line

# `v` is already mapped to visual mode, so we need to use a different key to open Vim
# bindkey -M vicmd "^V" edit-command-line

export KEYTIMEOUT=1
