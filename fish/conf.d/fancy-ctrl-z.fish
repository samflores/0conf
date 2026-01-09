function __fancy_ctrl_z --description 'Ctrl-Z toggles: if prompt is empty, bring last job to foreground'
    if test -z (commandline)
        fg 2>/dev/null
        commandline -f repaint
        return
    end

    commandline -f pushline
    commandline -f clear-screen
end

bind \cz __fancy_ctrl_z
bind -M insert \cz __fancy_ctrl_z
