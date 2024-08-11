if [ -x /usr/libexec/path_helper ]; then
    PATH=''
    eval `/usr/libexec/path_helper -s`
fi

# export PATH=""
typeset -U path
path=(
      $HOME/.gem/ruby/3.2.0/bin/
      $HOME/.gem/ruby/3.3.0/bin/
      $HOME/.gem/ruby/3.1.0/bin/
      $HOME/.yarn/bin
      $HOME/.config/yarn/global/node_modules/.bin
      $HOME/.local/bin
      $HOME/.local/share/cargo/bin
      $HOME/.local/share/go/bin
      $HOME/.local/flutter/bin
      $HOME/.cargo/bin
      $HOME/.yarn/bin
      $DENO_INSTALL/bin
      $ANDROID_SDK_ROOT/platform-tools
      $ANDROID_SDK_ROOT/tools/bin
      $JAVA_HOME/bin
      ~/bin(N)
      /usr/local/sbin
      /usr/local/bin
      /sbin
      /bin
      $path)
export PATH
