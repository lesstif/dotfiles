#!/usr/bin/env bash

if [ ! -d "$HOME/.yadr" ]; then
    echo "Installing YADR for the first time"
    git clone https://github.com/lesstif/dotfiles "$HOME/dotfiles"
    cd "$HOME/dotfiles"
    [ "$1" = "ask" ] && export ASK="true"
    
    # check GNU stow
#    stow 
    D="vim bash zsh"
    for i in ${D}; do
        echo "install $i";
    done

    ## install vim Bundle
    echo git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
else
    echo "YADR is already installed"
fi
