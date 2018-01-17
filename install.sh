#!/usr/bin/env bash

if [ ! -d "$HOME/dotfiles" ]; then
    echo "Installing dotfiles for the first time"
    git clone https://github.com/lesstif/dotfiles "$HOME/dotfiles"
    cd "$HOME/"
    [ "$1" = "ask" ] && export ASK="true"
    
    # install GNU stow

    ## Ubuntu 
    #### sudo apt-get install stow

    ## OS X
    #### brew install stow

    ## Cent OS
    ##### sudo yum install stow

    D="apprc bash git readline vim zsh"
    for i in ${D}; do
        echo "install $i";
        stow $i;
    done

    ## install vim Bundle
    echo "install vim plugins"
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
else
    echo "dotfiles is already installed"
fi
