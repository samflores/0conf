function __he_last_cmd
    history --max=1
end

function __he_bangbang --description 'Expand !! -> previous command'
    set -l last (__he_last_cmd)
    test -n "$last"; or return 1
    echo $last
end

function __he_last_arg --description 'Expand !$ -> last argument of previous command'
    set -l last (__he_last_cmd)
    test -n "$last"; or return 1

    set -l parts (string split ' ' -- $last)
    test (count $parts) -ge 2; or return 1
    echo $parts[-1]
end

function __he_first_arg --description 'Expand !^ -> first argument of previous command'
    set -l last (__he_last_cmd)
    test -n "$last"; or return 1

    set -l parts (string split ' ' -- $last)
    test (count $parts) -ge 2; or return 1
    echo $parts[2]
end

function __he_all_args --description 'Expand !* -> all arguments of previous command'
    set -l last (__he_last_cmd)
    test -n "$last"; or return 1

    set -l parts (string split ' ' -- $last)
    test (count $parts) -ge 2; or return 1
    echo (string join ' ' -- $parts[2..-1])
end

abbr --erase __he_bangbang 2>/dev/null
abbr --erase __he_last_arg 2>/dev/null
abbr --erase __he_first_arg 2>/dev/null
abbr --erase __he_all_args 2>/dev/null

abbr --add __he_bangbang  --global --regex '^\!\!$' --function __he_bangbang
abbr --add __he_last_arg  --global --regex '^\!\$$' --function __he_last_arg
abbr --add __he_first_arg --global --regex '^\!\^$'  --function __he_first_arg
abbr --add __he_all_args  --global --regex '^\!\*$'  --function __he_all_args

