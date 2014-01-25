#!/bin/bash

DOTFILES_ROOT="`pwd`"

function link_file () {
	if [ -s $2 ]
	then
		rm $2
		ln -s $1 $2 
		echo "Linked $1 to $2"
	else
		echo "$2 is not linked"
	fi

}

install_dotfiles () {

  for source in `find $DOTFILES_ROOT -maxdepth 2 -name \*.symlink`
  do
    dest="$HOME/.`basename \"${source%.*}\"`"

    link_file $source $dest

  done

}


install_dotfiles

# Bin Directory
link_file ~/.dotfiles/bin ~/bin

