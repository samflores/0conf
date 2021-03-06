if [ -x /usr/libexec/path_helper ]; then
    PATH=''
    eval `/usr/libexec/path_helper -s`
fi

typeset -U path
path=(~/bin(N)
      ~/.local/bin(N)
      $JAVA_HOME/bin(N)
      /usr/local/sbin 
      /usr/local/bin
      /sbin
      /bin
      $path)
export PATH

