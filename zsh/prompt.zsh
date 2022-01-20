function git_prompt_info {
  local lref=$(=git symbolic-ref HEAD 2> /dev/null)
  local rref=$(=git for-each-ref --format='%(upstream:short)' $lref 2> /dev/null)
  local gitst="$(=git status 2> /dev/null)"
  local lbranch="${lref#refs/heads/}"
  local rbranch="${rref#origin/}"

  if [[ -f .git/MERGE_HEAD ]]; then
    if [[ ${gitst} =~ "unmerged" ]]; then
      gitstatus=" %{$fg[red]%}unmerged%{$reset_color%}"
    else
      gitstatus=" %{$fg[green]%}merged%{$reset_color%}"
    fi
  elif [[ -n $rref ]]; then
    if [[ ${rbranch} =~ ${lbranch} ]]; then
      local rbranch="🆙"
    fi
    if [[ ${gitst} =~ "Changes to be committed" ]]; then
      gitstatus=" %{$fg[blue]%}${rbranch}🔹"
    elif [[ ${gitst} =~ "use \"git add" ]]; then
      gitstatus=" %{$fg[red]%}${rbranch}🔺"
    elif [[ -n `git checkout HEAD 2> /dev/null | grep ahead` ]]; then
      gitstatus=" %{$fg[yellow]%}${rbranch}🔸"
    else
      gitstatus=" %{$fg[green]%}${rbranch}"
    fi
  else
    gitstatus=""
  fi

  if [[ -n $lref ]]; then
    echo "%{$fg_bold[green]%}${lbranch}$gitstatus%{$reset_color%}"
  fi
}

MODE_CURSOR_VICMD="#D8DEE9 block"
MODE_CURSOR_VIINS="#D8DEE9 blinking bar"
MODE_CURSOR_SEARCH="#D8DEE9 steady underline"

MODE_INDICATOR_PROMPT='λ'
MODE_INDICATOR_VIINS='λ'
MODE_INDICATOR_VICMD=':'
MODE_INDICATOR_REPLACE='!'
MODE_INDICATOR_SEARCH='?'
MODE_INDICATOR_VISUAL='#'
MODE_INDICATOR_VLINE='#'

PROMPT='${PR_BOLD_WHITE}${MODE_INDICATOR_PROMPT}%{${reset_color}%} '
RPROMPT='$(git_prompt_info) %~%<<%{${reset_color}%}'
