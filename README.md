# dot files

Linux와 Window, OS X 용 닷파일.

# Windows 설치

먼저 패키지 매니저인 scoop 을 설치하기 위해 파워셀 기동

```sh
powershell 
```

파워쉘 프롬프트에서 scoop 을 설치하기 위한 정책 변경(미실행시 scoop 이 설치 안 되니 주의)

```sh
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
```

scoop 설치
```sh
iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
```

이제 scoop 으로 패키지 설치
```sh
powershell -file scoop-install-package.ps1
sudo powershell -file font-install.ps1
```

# 설정

## GNU stow 설치

### Ubuntu

```sh
sudo apt-get install stow
```

### OS X

```sh
brew install stow
```
    
### RHEL/CentOS

```sh
sudo yum install stow
```

### 직접 설치(Amazon Lunux 등)

```sh 
wget http://ftp.gnu.org/gnu/stow/stow-2.2.2.tar.bz2 
tar xjvf stow-2.2.2.tar.bz2 
cd stow-2.2.2/ 
./configure && make install
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


## 저장소 복제

```sh
git clone https://github.com/lesstif/dotfiles.git && cd dotfiles
```

# dotfiles 설치

설치하려면 dotfiles 서브 폴더에서 stow 실행

## vim 설치

```sh
cd dotfiles
stow vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
```

## bash 설치

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

## 삭제

stow -D 옵션 사용

```sh
stow -D bash
```

## 전체 dotfile 설치

```sh
for i in apprc bash git readline vim zsh;do
    stow $i;
done    
```

# 참고 자료
* [MANAGING DOTFILES WITH GNU STOW](https://taihen.org/managing-dotfiles-with-gnu-stow/)

# 참고 저장소

* [Awesome dotfiles](https://github.com/webpro/awesome-dotfiles)
* [Mathias Bynens’ dotfiles](https://github.com/mathiasbynens/dotfiles)
* [xero’s dotfiles are managed with GNU Stow.](https://github.com/xero/dotfiles)
* [Software Installation, Configuration and Preferences for Springload](https://github.com/springload/dotfiles)

