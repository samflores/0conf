set -g __history_ignore_cmds \
    '^pass$' \
    '^gpg$' \
    '^1password$'

function __history_ignore_preexec --on-event fish_preexec
    set -l cmd (string split ' ' -- $argv[1])[1]

    for pattern in $__history_ignore_cmds
        if string match -rq -- $pattern $cmd
            set -g __history_ignore_was_private $fish_private_mode
            set -g fish_private_mode 1
            return
        end
    end
end

function __history_ignore_postexec --on-event fish_postexec
    if set -q __history_ignore_was_private
        set -g fish_private_mode $__history_ignore_was_private
        set -e __history_ignore_was_private
    end
end
