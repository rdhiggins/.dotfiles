#!/bin/bash


function link_file {
	[[ -s $2 ]] &&rm $2
	ln -s $1 $2 
}


# Bash config
link_file ~/.dotfiles/bash/bashrc ~/.bashrc
link_file ~/.dotfiles/bash/bash_profile ~/.bash_profile

# Zsh config
link_file ~/.dotfiles/zsh/zshrc ~/.zshrc

# Bin Directory
link_file ~/.dotfiles/bin ~/bin

# Git Config
link_file ~/.dotfiles/git/gitconfig ~/.gitconfig
link_file ~/.dotfiles/git/gitignore_global ~/.gitignore_global
