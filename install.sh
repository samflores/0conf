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

[[ -f $HOME/.tmux.conf ]] && mv $HOME/.tmux.conf $HOME/tmux.conf.back
[[ -f $target/tmux ]] && rm $target/tmux
[[ -d $target/tmux ]] && mv $target/tmux{,.back}
ln -sf $origin/tmux $target/tmux

[[ -f $target/zsh ]] && rm $target/zsh
[[ -d $target/zsh ]] && mv $target/zsh{,.back}
ln -sf $origin/zsh $target/zsh
ln -sf $target/zsh/{,.}zshrc
ln -sf $target/zsh/{,.}zshenv
ln -sf $target/zsh/{,.}zprofile
