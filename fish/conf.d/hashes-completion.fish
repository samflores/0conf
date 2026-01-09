function __zdir_complete_tilde_dirs --description 'Complete ~name/... with directories'
    set -l tok (commandline -ct)
    string match -rq '^~[^/]+(/.*)?$' -- $tok; or return 0

    set -l m (string match -r '^~([^/]+)(/.*)?$' -- $tok)
    test (count $m) -ge 2; or return 0

    set -l name $m[2]
    set -l rest ''
    if test (count $m) -ge 3
        set rest $m[3]
    end

    if test -z "$rest" -o "$rest" = "/"
        set -l base (__zdir_get $name 2>/dev/null)
        if test -z "$base"
            for k in $__zdir_keys
                if string match -q -- "$name*" "$k"
                    printf '%s\t%s\n' "~$k/" (__zdir_get $k)
                end
            end
            return 0
        end
    end

    set -l base (__zdir_get $name) 2>/dev/null; or return 0

    set -l rel (string trim -l -c '/' -- $rest)
    set -l rel_dir $rel
    set -l prefix ''

    if string match -q '*/*' -- $rel
        set rel_dir (path dirname -- $rel)
        set prefix (path basename -- $rel)
    else
        set rel_dir ''
        set prefix $rel
    end

    set -l list_dir $base
    if test -n "$rel_dir"
        set list_dir $base/$rel_dir
    end

    test -d "$list_dir"; or return 0

    for d in $list_dir/*/
        test -d "$d"; or continue
        set -l bn (path basename -- (string replace -r '/$' '' -- $d))

        if test -n "$prefix"
            string match -q -- "$prefix*" "$bn"; or continue
        end

        if test -n "$rel_dir"
            echo "~$name/$rel_dir/$bn/"
        else
            echo "~$name/$bn/"
        end
    end
end

for cmd in cd ls e nvim vim cat less rg fd
    complete -c $cmd -f \
        -n "string match -rq '^~[^/]+(/.*)?\$' -- (commandline -ct)" \
        -a "(__zdir_complete_tilde_dirs)"
end

