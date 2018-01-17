# dot files

Linux와 Window, OS X 용 닷파일.

# 설정

1. GNU stow 설치

    ```sh
    sudo apt-get install stow
    ```

    ```sh
    brew install stow
    ```
    
    ```sh
    sudo yum install stow
    ```

1. 저장소 복제

    ```sh
    git clone https://github.com/lesstif/dotfiles.git && cd dotfiles
    ```

# 설치

## 전체 dotfile 설치

```sh
sh -s install.sh
for i in apprc bash git readline vim zsh;do
    stow $i;
done    
```

## 개별 설치

설치하려면 dotfiles 서브 폴더에서 stow 실행

### vim 설치

```sh
cd dotfiles
stow vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
```

### bash 설치

```sh
stow bash
```

bash 를 설치한 후에는 PATH 변수 설정은 *.path* 에 설정 

```sh
PATH=$PATH:/my/new/path
PATH=$PATH:/opt/prog/bin
export PATH
```

- 커밋되지 않기를 원하는 설정이 있을 경우 *.bash_extra* 에 작성
- 다른 계정에 설치하려면 -t 옵션 사용. 아래는 root 폴더에 설치

```sh
sudo stow bash -t /root
```

### 삭제

stow -D 옵션 사용

```sh
stow -D bash
```


# 참고 자료
* [MANAGING DOTFILES WITH GNU STOW](https://taihen.org/managing-dotfiles-with-gnu-stow/)

# 참고 저장소

* [Awesome dotfiles](https://github.com/webpro/awesome-dotfiles)
* [Mathias Bynens’ dotfiles](https://github.com/mathiasbynens/dotfiles)
* [xero’s dotfiles are managed with GNU Stow.](https://github.com/xero/dotfiles)
* [Software Installation, Configuration and Preferences for Springload](https://github.com/springload/dotfiles)

