set -g __zdir_keys
set -g __zdir_paths

function __zdir_set --description 'Set mapping key -> path (overwrite if key exists)'
    set -l key $argv[1]
    set -l path $argv[2]

    test -n "$key"; or return 1
    test -n "$path"; or return 1

    for i in (seq (count $__zdir_keys))
        if test "$__zdir_keys[$i]" = "$key"
            set -g __zdir_paths[$i] $path
            return 0
        end
    end

    set -ag __zdir_keys $key
    set -ag __zdir_paths $path
end

function __zdir_get --description 'Get mapping key -> path; prints path; returns 0 if found'
    set -l key $argv[1]
    for i in (seq (count $__zdir_keys))
        if test "$__zdir_keys[$i]" = "$key"
            echo $__zdir_paths[$i]
            return 0
        end
    end
    return 1
end

function __zdir_refresh --description 'Refresh ~name directory mappings'
    set -g __zdir_keys
    set -g __zdir_paths

    set -l root $HOME/Code
    if set -q ZDIR_ROOT
        set root $ZDIR_ROOT
    end

    set -l stack_root $root/stack-development
    if set -q ZDIR_STACK_ROOT
        set stack_root $ZDIR_STACK_ROOT
    end

    # 0) Root mapping: ~code -> $root
    set -l root_key code
    set -q ZDIR_ROOT_KEY; and set root_key $ZDIR_ROOT_KEY
    __zdir_set $root_key $root

    # 1) $root/* -> ~<dirname>
    for d in $root/*/
        test -d "$d"; or continue

        set -l p (string replace -r '/$' '' -- $d)
        set -l dir (basename -- $p)

        __zdir_set $dir $p
    end

    # 2) $stack_root/* -> ~<dirname> with stack- stripped (e.g. stack-api -> api)
    for d in $stack_root/*/
        test -d "$d"; or continue

        set -l p (string replace -r '/$' '' -- $d)
        set -l dir (basename -- $p)
        set -l name $dir

        if string match -q 'stack-*' -- $dir
            set name (string replace -r '^stack-' '' -- $dir)
        end

        __zdir_set $name $p
    end
end

function __zdir_expand --description 'Expand ~name[/...] using mapping'
    set -l tok $argv[1]

    string match -rq '^~[^/]+(/.*)?$' -- $tok; or return 1

    set -l m (string match -r '^~([^/]+)(/.*)?$' -- $tok)
    test (count $m) -ge 2; or return 1

    set -l name $m[2]
    set -l rest ''
    if test (count $m) -ge 3
        set rest $m[3]
    end

    set -l base (__zdir_get $name); or return 1
    test -n "$base"; or return 1

    echo $base$rest
end

abbr --erase __zdir_tilde 2>/dev/null
abbr --add __zdir_tilde \
    --global \
    --position anywhere \
    --regex '^~[^/]+(/.*)?$' \
    --function __zdir_expand

__zdir_refresh
