#! /bin/zsh

origin=`pwd`
target=$XDG_CONFIG_HOME

[[ -f $target/nvim ]] && rm $target/nvim
[[ -d $target/nvim ]] && mv $target/nvim{,.back}
ln -sf $origin/nvim $target/nvim
