set -gx PATH /bin /usr/bin /usr/sbin /sbin $PATH

fish_add_path -g \
    $HOME/.ghcup/bin \
    $HOME/.bundle/bin \
    $HOME/.yarn/bin \
    $HOME/.config/yarn/global/node_modules/.bin \
    $HOME/.local/bin \
    $HOME/.local/share/nvim/mason/bin/ \
    $HOME/.local/share/cargo/bin \
    $HOME/.local/share/go/bin \
    $HOME/.local/flutter/bin \
    $HOME/.cargo/bin \
    $HOME/bin \
    $DENO_INSTALL/bin \
    $ANDROID_SDK_ROOT/platform-tools \
    $ANDROID_SDK_ROOT/tools/bin \
    $JAVA_HOME/bin

