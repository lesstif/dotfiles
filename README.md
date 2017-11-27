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

설치하려면 dotfiles 서브 폴더에서 stow 실행

## bash 설치

```sh
stow bash
```

다른 계정에 설치하려면 -t 옵션 사용. 아래는 root 폴더에 설치

```sh
sudo stow bash -t /root
```

## 삭제

stow -D 옵션 사용

```sh
stow -D bash
```

##

## 참고 자료
* [MANAGING DOTFILES WITH GNU STOW](https://taihen.org/managing-dotfiles-with-gnu-stow/)

# 참고 저장소

* [Awesome dotfiles](https://github.com/webpro/awesome-dotfiles)
* [Mathias Bynens’ dotfiles](https://github.com/mathiasbynens/dotfiles)
* [xero’s dotfiles are managed with GNU Stow.](https://github.com/xero/dotfiles)
* [Software Installation, Configuration and Preferences for Springload](https://github.com/springload/dotfiles)

