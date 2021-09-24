## dot files

Linux와 OS X 용 닷파일. Windows 용은 [dotfiles-windows](https://github.com/lesstif/dotfiles-windows) 참고

## 사전 준비

### GNU stow

[GNU stow](https://www.gnu.org/software/stow/) 가 필요하며 ansible playbook 에서 설치함.
수동 설치일 경우 직접 다운로드후 설치

### ansible 설치

automation 도구인 ansible 설치

```bash
pip install ansible
```

설치 확인

```bash
ansible --version
```

## ansible 로 dotfiles 설치

1. ansible playbook 저장소 복제

    ```sh
    git clone https://github.com/lesstif/ansible-playbooks.git
    cd ansible-playbooks
    ```

2. playbook 실행

    ```sh
    ansible-playbook install-dotfiles.yml
    ```

## 수동으로 dotfiles 설치

1. 저장소 복제

    ```sh
    git clone https://github.com/lesstif/dotfiles.git && cd dotfiles
    ```

1. dotfiles 설치

    ```sh
    bash install.sh

1. commit 되지 않기를 원하는 설정 파일이 있을 경우 *.bash_extra* 에 작성

1. 다른 계정에 설치하려면 -t 옵션 사용. 아래는 root 폴더에 설치

    ```sh
    sudo stow bash -t /root
    ```

### stow 실행 에러 

"Can't locate Clone/Choose.pm in @INC" 와 같이 perl 모듈이 없다고 실행되지 않을때 모듈 설치  

root 로 CPAN 모듈 실행

```sh
perl -MCPAN -e shell
```

CPAN 프롬프트에서 없다고 하는 모듈 설치

```sh
install Clone::Choose
install Hash::Merge
```

## dotfile 삭제

1. stow -D 옵션 사용해서 삭제

    ```sh
    stow -D bash
    ```

1. 전체 dotfile 삭제

    ```sh
    for i in apprc bash git readline vim zsh;do
        stow -D $i;
    done    
    ```

## 참고 자료
* [MANAGING DOTFILES WITH GNU STOW](https://taihen.org/managing-dotfiles-with-gnu-stow/)

## 참고 저장소

* [Awesome dotfiles](https://github.com/webpro/awesome-dotfiles)
* [Mathias Bynens’ dotfiles](https://github.com/mathiasbynens/dotfiles)
* [xero’s dotfiles are managed with GNU Stow.](https://github.com/xero/dotfiles)
* [Software Installation, Configuration and Preferences for Springload](https://github.com/springload/dotfiles)

