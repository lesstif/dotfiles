#!/usr/bin/env bash

## check whether stow installed.
STOW="stow-2.3.1"

URL="http://ftp.gnu.org/gnu/stow/${STOW}.tar.gz"

if ! command -v "stow" &> /dev/null; then 
    echo "stow not found."
    echo "downloading from $URL now..";
    wget $URL;
    tar zxvf ${STOW}.tar.gz;
    cd ${STOW};
    ./configure && make;

    echo "";
    echo "YOU MUST RUN \"make install\" COMMAND AS ROOT";
    exit 0;
fi;


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
    BD=${HOME}/old-dotfiles
    if [ ! -d "$BD" ] ; then
        mkdir $BD;
    fi

    mv ~/.bash* $BD;
    mv ~/.vimrc* $BD;
    mv ~/.inputrc $BD;
    mv ~/.editrc $BD;
    mv ~/.aliases $BD;

    for i in ${DIRS}; do
        echo "install $i";
        stow $i;
    done
else
    echo "dotfiles is already installed. running with -f options."
fi

## install vim Bundle
if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ];then
    echo "install vim plugins"
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
## ignore error
vim -E -s -u ~/.vimrc +PluginInstall +qall

## install curl
CURL=$(which curl)
if [ ! -x ${CURL} ];then
    echo "curl not found";
    echo "running 'yum install curl' or 'apt install curl'";
fi;

## install nvm 
if [ ! -d "$HOME/.nvm" ];then
    echo "install node version manager"
    unalias curl
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash
fi

