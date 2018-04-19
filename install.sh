#!/usr/bin/env bash

force=0
uninst=0

PARAM="fu";

while getopts $PARAM opt; do
    case $opt in
        f)
            force=1;
            ;;
        u)
            uninst=1;
            ;;
    esac
done

DIRS="apprc bash git readline vim zsh"

if [ $uninst -eq 1 ];then
    for i in ${DIRS}; do
        echo "uninstall $i";
        stow -D $i;
    done
elif [ ! -d "$HOME/dotfiles" ] || [ $force ]; then
    echo "Installing dotfiles for the first time"
    if [ ! -d "$HOME/dotfiles" ];then
        git clone https://github.com/lesstif/dotfiles "$HOME/dotfiles"
    fi

    cd "$HOME/dotfiles"

    # install GNU stow

    ## Ubuntu 
    #### sudo apt-get install stow

    ## OS X
    #### brew install stow

    ## Cent OS
    ##### sudo yum install stow

    ## backup
    $BD="$HOME/old-dotfiles"
    if [ ! -d "$BD" ] ; then
        mkdir $BD;
    fi 
   
    mv .bash* $BD;
    mv .vimrc* $BD;
    mv .inputrc $BD;
    mv .editrc $BD;
    mv .aliases $BD;

    for i in ${DIRS}; do
        echo "install $i";
        stow $i;
    done

    ## install vim Bundle
    echo "install vim plugins"
    if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ];then
        git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    fi
    vim +PluginInstall +qall
else
    echo "dotfiles is already installed. running with -f options."
fi
