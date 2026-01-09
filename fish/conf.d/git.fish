type -q git; or exit 0

# ---- General
set -g _git_log_medium_format '%C(bold)Commit:%C(reset) %C(green)%H%C(red)%d%n%C(bold)Author:%C(reset) %C(cyan)%an <%ae>%n%C(bold)Date:%C(reset)   %C(blue)%ai (%ar)%C(reset)%n%+B'
set -g _git_log_oneline_format '%C(green)%h%C(reset) %s%C(red)%d%C(reset)'
set -g _git_log_fullgraph_format '%C(green)%h%C(reset) %<|(50,trunc)%s %C(bold blue)<%an>%C(reset) %C(yellow)(%cd)%C(reset)%C(auto)%d%C(reset)%n'
set -g _git_log_brief_format '%C(green)%h%C(reset) %s%n%C(blue)(%ar by %an)%C(red)%d%C(reset)%n'

alias g git

# ---- Branch - gb<action>
alias gb  'git branch'
alias gbc 'git checkout -b'
alias gbl 'git branch -v'
alias gbL 'git branch -av'
alias gbx 'git branch -d'
alias gbX 'git branch -D'
alias gbm 'git branch -m'
alias gbM 'git branch -M'
alias gbs 'git show-branch'
alias gbS 'git show-branch -a'

# ---- Commit - gc<action>
alias gc  'git commit --verbose'
alias gca 'git commit --verbose --all'
alias gcm 'git commit --message'
alias gco 'git checkout'
alias gcO 'git checkout --patch'
alias gcf 'git commit --amend --reuse-message HEAD'
alias gcF 'git commit --verbose --amend'
alias gcp 'git cherry-pick --ff'
alias gcP 'git cherry-pick --no-commit'
alias gcr 'git revert'
alias gcR 'git reset HEAD^'
alias gcs 'git show'
alias gcl 'git-commit-lost'

# ---- Conflict - gC<action>
function gCl
    git status | sed -n 's/^.*both [a-z]*ed: *//p'
end

function gCa
    git add (gCl)
end

function gCe
    git mergetool (gCl)
end

alias gCo 'git checkout --ours --'
function gCO
    gCo (gCl)
end

alias gCt 'git checkout --theirs --'
function gCT
    gCt (gCl)
end

# ---- Data - gd<action>
alias gd  'git ls-files'
alias gdc 'git ls-files --cached'
alias gdx 'git ls-files --deleted'
alias gdm 'git ls-files --modified'
alias gdu 'git ls-files --other --exclude-standard'
alias gdk 'git ls-files --killed'

function gdi
    git status --porcelain --short --ignored | sed -n 's/^!! //p'
end

# ---- Fetch - gf<action>
alias gf  'git fetch'
alias gfc 'git clone'
alias gfm 'git pull'
alias gfr 'git pull --rebase'

# ---- Grep - gg<action>
alias gg  'git grep'
alias ggi 'git grep --ignore-case'
alias ggl 'git grep --files-with-matches'
alias ggL 'git grep --files-without-matches'
alias ggv 'git grep --invert-match'
alias ggw 'git grep --word-regexp'

# ---- Index - gi<action>
alias gia 'git add'
alias giA 'git add --patch'
alias giu 'git add --update'
alias gid 'git diff --no-ext-diff --cached'
alias giD 'git diff --no-ext-diff --cached --word-diff'
alias gir 'git reset'
alias giR 'git reset --patch'
alias gix 'git rm -r --cached'
alias giX 'git rm -rf --cached'

# ---- Log - gl<action>
function gl
    git log --topo-order --pretty=format:"$_git_log_medium_format" $argv
end

function gls
    git log --topo-order --stat --pretty=format:"$_git_log_medium_format" $argv
end

function gld
    git log --topo-order --stat --patch --full-diff --pretty=format:"$_git_log_medium_format" $argv
end

function glo
    git log --topo-order --pretty=format:"$_git_log_oneline_format" $argv
end

function glg
    git log --topo-order --all --graph --pretty=format:"$_git_log_oneline_format" $argv
end

function glb
    git log --topo-order --pretty=format:"$_git_log_brief_format" $argv
end

alias glc 'git shortlog --summary --numbered'

# ---- Merge - gm<action>
alias gm  'git merge'
alias gmC 'git merge --no-commit'
alias gmF 'git merge --no-ff'
alias gma 'git merge --abort'
alias gmt 'git mergetool'

# ---- Push - gp<action>
alias gp  'git push'
alias gpf 'git push --force'
alias gpa 'git push --all'
alias gpA 'git push --all && git push --tags'
alias gpt 'git push --tags'

function gpc
    set -l b (git-branch-current 2>/dev/null)
    test -n "$b"; and git push --set-upstream origin $b
end

function gpp
    set -l b (git-branch-current 2>/dev/null)
    test -n "$b"; or return 1
    git pull origin $b; and git push origin $b
end

# ---- Rebase - gr<action>
alias gr  'git rebase'
alias gra 'git rebase --abort'
alias grc 'git rebase --continue'
alias gri 'git rebase --interactive'
alias grs 'git rebase --skip'

# ---- Remote - gR<action>
alias gR  'git remote'
alias gRl 'git remote --verbose'
alias gRa 'git remote add'
alias gRx 'git remote rm'
alias gRm 'git remote rename'
alias gRu 'git remote update'
alias gRp 'git remote prune'
alias gRs 'git remote show'
alias gRb 'git-hub-browse'

# ---- Stash - gs<action>
alias gs  'git stash'
alias gsa 'git stash apply'
alias gsx 'git stash drop'
alias gsX 'git-stash-clear-interactive'
alias gsl 'git stash list'
alias gsL 'git-stash-dropped'
alias gsd 'git stash show --patch --stat'
alias gsp 'git stash pop'
alias gsr 'git-stash-recover'
alias gss 'git stash save --include-untracked'
alias gsS 'git stash save --patch --no-keep-index'
alias gsw 'git stash save --include-untracked --keep-index'

# ---- Submodule - gS<action>
alias gS  'git submodule'
alias gSa 'git submodule add'
alias gSf 'git submodule foreach'
alias gSi 'git submodule init'
alias gSI 'git submodule update --init --recursive'
alias gSl 'git submodule status'
alias gSm 'git-submodule-move'
alias gSs 'git submodule sync'
alias gSu 'git submodule foreach git pull origin master'
alias gSx 'git-submodule-remove'

# ---- Working Copy - gw<action>
alias gws 'git status --short'
alias gwS 'git status'
alias gwd 'git diff --no-ext-diff'
alias gwD 'git diff --no-ext-diff --word-diff'
alias gwr 'git reset --soft'
alias gwR 'git reset --hard'
alias gwc 'git clean -n'
alias gwC 'git clean -f'
alias gwx 'git rm -r'
alias gwX 'git rm -rf'

