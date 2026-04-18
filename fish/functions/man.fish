function man --description "wrap the 'man' manual page opener to use color in formatting"
  # based on this group of settings and explanation for them:
  # http://boredzo.org/blog/archives/2016-08-15/colorized-man-pages-understood-and-customized
  # converted to Fish shell syntax thanks to this page:
  # http://askubuntu.com/questions/522599/how-to-get-color-man-pages-under-fish-shell/650192

  set -x LESS_TERMCAP_mb (printf "\033[01;31m")  
  set -x LESS_TERMCAP_md (printf "\033[01;31m")  
  set -x LESS_TERMCAP_me (printf "\033[0m")  
  set -x LESS_TERMCAP_se (printf "\033[0m")  
  set -x LESS_TERMCAP_so (printf "\033[01;44;33m")  
  set -x LESS_TERMCAP_ue (printf "\033[0m")  
  set -x LESS_TERMCAP_us (printf "\033[01;32m")  

  # start of underline:
  #set -x LESS_TERMCAP_us (set_color --underline)
  # end of underline:
  #set -x LESS_TERMCAP_ue (set_color normal)
  # (no change – I like the default)

  command man $argv
end
