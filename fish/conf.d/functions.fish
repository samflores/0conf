function mkcd --description 'mkdir -p DIR and cd into it'
    if test -n "$argv[1]"
        mkdir -p -- "$argv[1]" and cd -- "$argv[1]"
    end
end

function find-exec --description 'find files matching pattern and exec a command (default: file)'
    set -l needle $argv[1]
    set -l cmd file
    if test (count $argv) -ge 2
        set cmd $argv[2]
    end

    find . -type f -iname "*$needle*" -exec $cmd '{}' \;
end

function psu --description 'ps for user (default: $USER) with pid,cpu,mem,command'
    set -l u $USER
    if test -n "$argv[1]"
        set u $argv[1]
    end

    set -l extra
    if test (count $argv) -ge 2
        set extra $argv[2..-1]
    end

    ps -U "$u" -o 'pid,%cpu,%mem,command' $extra
end

function extract --description 'Extract common archive formats'
    set -l f $argv[1]
    echo "Extracting $f ..."

    if test -f "$f"
        switch $f
            case '*.tar.bz2' '*.tbz2'
                tar xjf -- "$f"
            case '*.tar.gz' '*.tgz'
                tar xzf -- "$f"
            case '*.tar'
                tar xf -- "$f"
            case '*.bz2'
                bunzip2 -- "$f"
            case '*.gz'
                gunzip -- "$f"
            case '*.rar'
                unrar x -- "$f"
            case '*.zip'
                unzip -- "$f"
            case '*.Z'
                uncompress -- "$f"
            case '*.7z'
                7z x -- "$f"
            case '*'
                echo "'$f' cannot be extracted via extract()"
        end
    else
        echo "'$f' is not a valid file"
    end
end

function __magic_enter --description 'On empty enter, show git status (short) if in repo'
    set -l buf (commandline)

    if test -z "$buf"
        if git rev-parse --is-inside-work-tree >/dev/null 2>&1
            echo
            git status --short
        end
    end

    commandline -f execute
end

bind \r __magic_enter
bind -M insert \r __magic_enter

function wttr --description 'Weather via wttr.in (default: Teresina)'
    set -l city Teresina
    if test -n "$argv[1]"
        set city $argv[1]
    end

    set -l request "wttr.in/$city?Q0m"
    if test (tput cols) -lt 125
        set request "$request""n"
    end

    set -l lang (string replace -r '_.*$' '' -- $LANG)

    curl -H "Accept-Language: $lang" --compressed "$request"
end

function _e --description 'Run nvim as root with explicit XDG dirs'
    set -l config_home /home/samflores/.config
    set -l data_home /home/samflores/.local/share

    doas env XDG_CONFIG_HOME="$config_home" XDG_DATA_HOME="$data_home" nvim $argv
end
