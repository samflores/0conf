function __fish_git_prompt_info
    command git rev-parse --is-inside-work-tree >/dev/null 2>&1; or return

    set -l lref (command git symbolic-ref HEAD 2>/dev/null)
    set -l lbranch (string replace 'refs/heads/' '' -- $lref)

    set -l rref (command git for-each-ref --format='%(upstream:short)' $lref 2>/dev/null)
    set -l rbranch (string replace 'origin/' '' -- $rref)

    set -l gitst (command git status --porcelain=1 --branch 2>/dev/null)

    set -l gitstatus ''

    if test -f .git/MERGE_HEAD
        if string match -q '*UU*' -- $gitst
            set gitstatus (set_color red)' unmerged'
        else
            set gitstatus (set_color green)' merged'
        end
    else if test -n "$rref"
        if test "$rbranch" = "$lbranch"
            set rbranch '🆙'
        end

        if string match -q '*A *' -- $gitst
            set gitstatus (set_color blue)" $rbranch🔹"
        else if string match -q '* M*' -- $gitst
            set gitstatus (set_color red)" $rbranch🔺"
        else if string match -q '*ahead*' -- $gitst
            set gitstatus (set_color yellow)" $rbranch🔸"
        else
            set gitstatus (set_color green)" $rbranch"
        end
    end

    echo (set_color --bold green)$lbranch$gitstatus(set_color normal)
end

function fish_prompt
    set -l indicator 'λ'

    switch $fish_bind_mode
        case default
            set indicator ':'
        case insert
            set indicator 'λ'
        case replace_one
            set indicator '!'
        case visual
            set indicator '#'
    end

    printf '%s%s%s ' (set_color white) $indicator (set_color normal)
end

function fish_right_prompt
    set -l git (__fish_git_prompt_info)
    set -l pwd (prompt_pwd)

    if test -n "$git"
        printf '%s %s%s%s' \
            $git \
            (set_color --bold white) \
            $pwd \
            (set_color normal)
    else
        printf '%s%s%s' \
            (set_color --bold white) \
            $pwd \
            (set_color normal)
    end
end

function fish_mode_prompt
    # prints nothing
end
