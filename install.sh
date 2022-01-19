#! /bin/zsh

origin=`pwd`
target=$XDG_CONFIG_HOME

[[ -f $target/nvim ]] && rm $target/nvim
[[ -d $target/nvim ]] && mv $target/nvim{,.back}
ln -sf $origin/nvim $target/nvim

[[ -f $HOME/.gitconfig ]] && mv $HOME/.gitconfig $HOME/gitconfig.back
ln -sf $origin/gitconfig $HOME/.gitconfig

[[ -f $HOME/.global_gitignore ]] && mv $HOME/.global_gitignore $HOME/global_gitignore.back
ln -sf $origin/gitignore_global $HOME/.gitignore_global
