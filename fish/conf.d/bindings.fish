bind -M insert \ce accept-autosuggestion

function __pager_next_or_default
    if commandline --paging-mode
        commandline -f forward-char
    else
        down-or-search
    end
end

function __pager_prev_or_default
    if commandline --paging-mode
        commandline -f backward-char
    else
        up-or-search
    end
end

function __pager_accept_or_autosuggest
    if commandline --paging-mode
        commandline -f cancel
    else
        commandline -f accept-autosuggestion
    end
end

# Default keymap
bind \cn __pager_next_or_default
bind \cp __pager_prev_or_default
bind \cy __pager_accept_or_autosuggest

# Vi insert mode too
bind -M insert \cn __pager_next_or_default
bind -M insert \cp __pager_prev_or_default
bind -M insert \cy __pager_accept_or_autosuggest
