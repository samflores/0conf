#! /usr/local/bin/zsh

origin=`pwd`

[[ ! -a $origin/vim ]] && mkdir $origin/vim
ln -s $origin/vim ~/.vim
ln -s $origin/vim ~/.nvim
ln -s $origin/vimrc ~/.vimrc
ln -s $origin/vimrc ~/.nvimrc

ln -s $origin/gitconfig ~/.gitconfig
ln -s $origin/gitignore_global ~/.gitignore_global

ln -s $origin/zsh ~/.zsh
ln -s $origin/zshrc ~/.zshrc

ln -s $origin/tmux.conf ~/.tmux.conf

git submodule init
git submodule update

source ~/.zshrc
zsh_recompile
