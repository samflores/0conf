if [ -x /usr/libexec/path_helper ]; then
    PATH=''
    eval `/usr/libexec/path_helper -s`
fi

typeset -U path
path=(~/bin(N)
      /Applications/Kitematic\ \(Beta\).app/Contents/Resources/app/resources
      $JAVA_HOME/bin(N)
      /usr/local/share/npm/bin(N)
      /usr/local/sbin 
      /usr/local/bin
      /sbin
      /bin
      $path)
export PATH

