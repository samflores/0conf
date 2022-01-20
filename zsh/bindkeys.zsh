# To see the key combo you want to use just do:
# cat > /dev/null
# And press it

bindkey -v

# Better searching in command mode
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd '/' history-incremental-search-forward

# Easier, more vim-like editor opening
bindkey -M vicmd v edit-command-line

autoload edit-command-line
zle -N edit-command-line

export KEYTIMEOUT=1
