#! /usr/local/bin/zsh

origin=`pwd`

[[ ! -a $origin/vim ]] && mkdir $origin/vim
ln -s $origin/vim ~/.vim
[[ -d ~/.config && ! -a ~/.config/nvim ]] && ln -s $origin/nvm ~/.config/nvim
ln -s $origin/vimrc ~/.vimrc

ln -s $origin/gitconfig ~/.gitconfig
ln -s $origin/gitignore_global ~/.gitignore_global

ln -s $origin/zsh ~/.zsh
ln -s $origin/zshrc ~/.zshrc
ln -s $origin/zshenv ~/.zshenv

ln -s $origin/tmux.conf ~/.tmux.conf

source ~/.zshrc
zsh_recompile
