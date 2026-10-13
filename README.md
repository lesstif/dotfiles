# dotfiles: Zsh + chezmoi

macOS와 Linux용 설정입니다. Zsh를 기준으로 chezmoi가 실제 설정 파일을 생성합니다.
기존 Stow/Bash 파일은 참고·복구용으로 보존합니다.

## 구조와 우선순위

`.chezmoiroot`가 `chezmoi/`를 배포 원본으로 지정합니다. 저장소 최상위의
Bash, Windows, Brewfile, `.macos`, 옛 설치 스크립트는 배포하지 않습니다.

Zsh 환경과 함수는 항목별 템플릿을 하나의 `.zshrc`로 합칩니다.
별칭은 chezmoi가 생성한 `.aliases`를 한 번만 명시적으로 읽습니다.
`.exports`, `.functions` 또는 `*_local` 파일은 읽지 않습니다.

| 원본 | 역할 |
| --- | --- |
| `chezmoi/.chezmoidata.toml` | 공통 기본값 |
| `.chezmoitemplates/zsh/environment.zsh.tmpl` | 기본 환경변수와 중복 없는 PATH |
| `.chezmoitemplates/zsh/framework.zsh.tmpl` | Oh My Zsh 또는 기본 완성·프롬프트 |
| `.chezmoitemplates/zsh/runtimes.zsh.tmpl` | 설치된 nvm·SDKMAN의 선택적 초기화 |
| `.chezmoitemplates/zsh/commands.zsh.tmpl` | 함수·색상 초기화·별칭 로딩, 마지막으로 기기별 값 |
| `chezmoi/dot_aliases.tmpl` | 기존 공통 별칭과 OS별 별칭 |
| `chezmoi/dot_dircolors` | GNU ls 색상표 |
| `~/.config/chezmoi/chezmoi.toml` | 해당 컴퓨터의 데이터; Git에 넣지 않음 |

위 템플릿 경로는 `chezmoi/`를 기준으로 합니다.
로딩 순서는 **환경 → 프레임워크 → 런타임 → 사용자 명령 → 기기별 값**입니다.
설정값은 공통 기본값 → OS별 설정 → 기기별 값 순으로 우선합니다.
사용자 별칭은 Oh My Zsh 이후에 정의하므로 플러그인 별칭보다 우선합니다.

PATH는 상속받은 항목을 유지하고 Zsh의 `path` 배열로 중복을 제거합니다.
기기별 `extra_path`가 가장 앞에 오고, 사용자 도구 경로, macOS의 Homebrew
경로, 상속된 경로가 이어집니다. 런타임이 PATH를 바꾸더라도 `extra_path`는
다시 맨 앞에 배치합니다. 오래된 Python 2.7/3.5·Java 고정 경로는 생성하지 않습니다.

`.zshenv`와 `.zprofile`은 최소 파일입니다. 비대화형 셸은 도구를 초기화하지
않고 호출한 프로세스의 환경을 상속합니다. 자동화에서 특정 도구가 필요하면
해당 프로세스의 PATH나 절대경로를 명시하세요.

## 설치

먼저 Zsh와 chezmoi를 설치합니다.

```sh
# macOS
brew install chezmoi zsh

# Arch Linux
sudo pacman -S chezmoi zsh
```

Ubuntu 등 다른 환경의 chezmoi 설치는 [공식 안내](https://www.chezmoi.io/install/)를
참고하세요. 기본 셸 변경은 필요할 때 `chsh -s "$(command -v zsh)"`로 합니다.
설정 배포 자체는 기본 셸을 변경하거나 패키지를 설치하지 않습니다.

새 컴퓨터에서는 다음처럼 설정을 받아 확인하고 적용합니다.

```sh
chezmoi init https://github.com/lesstif/dotfiles.git
chezmoi diff
chezmoi apply
exec zsh -l
```

이미 이 저장소를 복제했다면 체크아웃 안에서 다음처럼 사용할 수 있습니다.
`install.sh`는 현재 체크아웃을 사용하므로 다른 폴더에서 호출해도 동작합니다.

```sh
bash install.sh          # diff만 표시
bash install.sh apply    # 설정 적용
```

이 체크아웃 방식은 chezmoi의 기본 원본 위치를 변경하지 않습니다. 이후에도
`install.sh`를 사용하거나, `chezmoi edit-config`에서 최상위에
`sourceDir = "/absolute/path/to/dotfiles"`를 지정한 뒤 일반 chezmoi 명령을 사용하세요.

Oh My Zsh는 기존 `~/.oh-my-zsh`가 있으면 사용합니다. 없으면 기본 프롬프트와
완성 기능으로 시작합니다. nvm·SDKMAN도 설치된 초기화 파일이 있을 때만
읽습니다. 셸을 시작하면서 다운로드하거나 ssh-agent를 생성하지 않습니다.

Git, Neovim, Ghostty, tmux, screen, readline 설정도 함께 배포합니다.
Ghostty는 공통 XDG 경로인 `~/.config/ghostty/config`를 사용합니다. macOS의
기존 `~/Library/Application Support/com.mitchellh.ghostty/config`도 있으면
별도로 백업하고 내용을 통합하세요. 양쪽 파일의 설정이 중복되지 않게 합니다.
Neovim은 0.12 이상을 기준으로 합니다. Treesitter는 `main`의 새 API를 사용하며,
C 컴파일러와 tree-sitter CLI 0.26.1 이상이 필요합니다. 파서 설치는 비동기로
실행되므로 첫 설치가 끝난 뒤 파일을 다시 열면 구문 강조가 적용됩니다.
Neovim 플러그인 설치는 lazy.nvim 설정이 담당합니다.
Vundle이 필요한 옛 Vim 설정과 기타 설치 스크립트는 자동으로 배포·실행하지 않습니다.

## 기기별 설정

`chezmoi edit-config`로 로컬 설정 파일을 열고, 기존 `sourceDir` 등의 항목은
그대로 둔 채 아래 데이터를 추가합니다. 필요한 키만 지정하면 나머지는
저장소 기본값을 사용합니다. 변경 후 `chezmoi diff`와 `chezmoi apply`로 반영합니다.

```toml
[data.shell]
theme = "robbyrussell"
plugins = ["git", "docker"]
extra_path = ["/absolute/path/to/custom/bin"]
use_oh_my_zsh = true
use_nvm = true
use_sdkman = false

[data.shell.env]
EDITOR = "nvim"
VISUAL = "nvim"
ANSIBLE_INVENTORY = "/absolute/path/to/ansible_hosts"

[data.shell.aliases]
lv = "tail -f /absolute/path/to/application.log"

[data.git]
name = "KwangSeob Jeong"
email = "your-work-email@example.com"
```

`extra_path`에는 절대경로를 지정합니다. `$HOME`이나 `~`를 문자열 안에서
확장하지 않습니다. `shell.env`는 문자열 환경변수에 사용합니다.
PATH, HOME, ZDOTDIR와 도구 초기화 경로 등은 예약된 키이며,
PATH는 `extra_path`로 조정합니다. 플러그인과 경로 목록은 지정한 배열로 교체됩니다.
비밀정보는 공개 저장소에 넣지 말고 필요하면 chezmoi의 암호화·secret 연동을
사용하세요. 로컬 데이터로 생성한 환경변수도 `.zshrc`에는 평문으로 기록됩니다.

## Stow에서 이전

1. 현재 파일을 링크 대상의 내용까지 백업합니다. 특히 `.zshrc`, `.zshenv`,
   `.zprofile`, `.gitconfig`, `.config/nvim`, Ghostty와 `*_local` 파일을 확인하세요.
2. `*_local`의 값을 위 `[data.shell]` 등에 옮깁니다. 추가 함수는
   `commands.zsh.tmpl`에 명시적으로 정의합니다. 옛 로컬 파일은 남아 있어도
   새 Zsh 설정에서는 읽지 않습니다.
3. `chezmoi diff`로 생성될 설정을 확인합니다.
4. **기존 Stow 체크아웃**에서 이전할 패키지의 링크를 해제합니다.

   ```sh
   stow --dir "$HOME/dotfiles" --target "$HOME" -D zsh git nvim ghostty apprc readline
   ```

   기존 체크아웃 위치가 다르면 `--dir`을 변경하세요. 위 명령은 해당 패키지들을
   Stow로 설치한 경우의 예시입니다. 패키지 내 이전 대상이 아닌 파일(curl/wget
   설정 등)도 링크가 해제되므로 필요하면 개별적으로 chezmoi에 추가하거나 복원합니다.
5. `chezmoi apply` 후 새 터미널에서 확인합니다.

Bash는 새 구조의 의존성이 아닙니다. 기존 `.aliases`의 공통 명령은
`dot_aliases.tmpl`에 옮겼고, macOS 명령은 macOS에서만 생성합니다.
로그 경로는 `MY_WAS`·`CONFLUENCE_DIR` 환경변수로 조정할 수 있습니다.
`install.sh.mac`, `.macos`, 예전 Brewfile은 이번 설치에 사용하지 않습니다.

## 일상적인 변경

Zsh 생성 결과 대신 `chezmoi/.chezmoitemplates/zsh/`의 원본을 수정합니다.
별칭은 `chezmoi/dot_aliases.tmpl`, 색상표는 `chezmoi/dot_dircolors`를 수정합니다.
이 경로들은 저장소 최상위를 기준으로 합니다.

```sh
chezmoi cd
# 템플릿 원본 수정; Git으로 commit/push
chezmoi diff
chezmoi apply
```

다른 컴퓨터에서는 `chezmoi update`로 가져와 적용할 수 있습니다.
Git 등 일반 파일은 `chezmoi edit ~/.gitconfig`로도 편집할 수 있습니다.

## 검증

chezmoi, Zsh, Git, Python 3을 준비하고 실행합니다.

```sh
python3 -m unittest discover -s tests -v
```

테스트는 임시 홈에서 적용·재적용의 일치, Linux 로그인·비로그인 기동,
PATH 유지·중복 제거, 기기 데이터와 프레임워크보다 우선하는 사용자 설정,
GNU/BSD `ls`, 비대화형 기동, macOS 생성 결과의 구문을 확인합니다.
macOS 실기기와 외부 플러그인의 실제 호환성은 별도 확인이 필요합니다.
