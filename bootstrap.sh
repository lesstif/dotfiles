#!/usr/bin/env bash
# Explicit first-install setup; never invoked by shell startup or chezmoi apply.
# Compatible with macOS's system Bash 3.2.
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: bash bootstrap.sh [--apply] [--change-shell] [--skip-oh-my-zsh]
                         [--repo URL]

Install Git, curl, Zsh, chezmoi and Oh My Zsh on macOS, Ubuntu/Debian or Arch.
Initialize lesstif/dotfiles if chezmoi has no Git source, then show chezmoi diff.
Existing chezmoi sources and Oh My Zsh installations are retained, not updated.

  --apply             Apply dotfiles instead of only showing the diff.
  --change-shell      Also change the login shell to Zsh (may request a password).
  --skip-oh-my-zsh    Use the dotfiles' built-in prompt/completion instead.
  --repo URL          Repository to initialize on a fresh machine.
  -h, --help          Show this help.
EOF
}

die() { printf 'bootstrap: %s\n' "$*" >&2; exit 1; }
log() { printf '\n==> %s\n' "$*"; }

as_root() {
  command -v sudo >/dev/null 2>&1 || die 'sudo is required for system packages.'
  sudo "$@"
}

install_macos() {
  # Homebrew may already be installed but absent from a fresh shell's PATH.
  if ! command -v brew >/dev/null 2>&1; then
    if [ -x /opt/homebrew/bin/brew ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x /usr/local/bin/brew ]; then
      eval "$(/usr/local/bin/brew shellenv)"
    else
      log 'Installing Homebrew'
      curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh \
        -o "$work_dir/homebrew.sh"
      /bin/bash "$work_dir/homebrew.sh"
      if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      elif [ -x /usr/local/bin/brew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
      else
        die 'Homebrew installation did not produce a brew executable.'
      fi
    fi
  fi
  local packages=() tool
  for tool in git curl zsh chezmoi; do
    if ! command -v "$tool" >/dev/null 2>&1; then packages+=("$tool"); fi
  done
  if [ "${#packages[@]}" -gt 0 ]; then brew install "${packages[@]}"; fi
}

install_linux() {
  local distro="$1" tool missing=0
  for tool in git curl zsh chezmoi; do
    if ! command -v "$tool" >/dev/null 2>&1; then missing=1; fi
  done
  if [ "$missing" -eq 0 ]; then return; fi
  case "$distro" in
    ubuntu|debian)
      as_root apt-get update
      as_root apt-get install -y ca-certificates curl git zsh
      if ! command -v chezmoi >/dev/null 2>&1; then
        # Use the upstream installer: distro repositories may not carry chezmoi.
        curl -fsSL https://get.chezmoi.io -o "$work_dir/chezmoi.sh"
        sh "$work_dir/chezmoi.sh" -b "$HOME/.local/bin"
      fi
      ;;
    arch)
      # Never perform a partial Arch upgrade with pacman -Sy.
      as_root pacman -Syu --needed git curl zsh chezmoi
      ;;
    *) die "Unsupported Linux distribution: $distro" ;;
  esac
}

install_oh_my_zsh() {
  local omz_dir="$HOME/.oh-my-zsh"
  if [ -f "$omz_dir/oh-my-zsh.sh" ]; then
    log 'Keeping existing Oh My Zsh'
  elif [ -e "$omz_dir" ] || [ -L "$omz_dir" ]; then
    die "$omz_dir exists but is not an Oh My Zsh installation; inspect it first."
  else
    log 'Installing Oh My Zsh without changing .zshrc or the login shell'
    git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$work_dir/oh-my-zsh"
    mv "$work_dir/oh-my-zsh" "$omz_dir"
  fi
}

change_login_shell() {
  local zsh_path
  zsh_path="$(command -v zsh)"
  if ! grep -Fxq "$zsh_path" /etc/shells; then
    log "Registering $zsh_path in /etc/shells"
    printf '%s\n' "$zsh_path" | as_root tee -a /etc/shells >/dev/null
  fi
  chsh -s "$zsh_path"
}

main() {
  local apply=0 change_shell=0 install_omz=1
  local repo_url=https://github.com/lesstif/dotfiles.git platform distro source_dir tool
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --apply) apply=1 ;;
      --change-shell) change_shell=1 ;;
      --skip-oh-my-zsh) install_omz=0 ;;
      --repo)
        [ "$#" -ge 2 ] && [ -n "$2" ] || die '--repo requires a URL.'
        repo_url="$2"; shift ;;
      -h|--help) usage; return ;;
      *) usage >&2; die "Unknown argument: $1" ;;
    esac
    shift
  done
  [ "$(id -u)" -ne 0 ] || die 'Run as your normal user, without sudo.'
  platform="$(uname -s)"
  case "$platform" in
    Darwin) ;;
    Linux)
      [ -r /etc/os-release ] || die 'Cannot detect Linux distribution.'
      distro="$(. /etc/os-release; printf '%s' "$ID")"
      case "$distro" in ubuntu|debian|arch) ;; *) die "Unsupported Linux distribution: $distro" ;; esac
      ;;
    *) die "Unsupported platform: $platform. Windows uses native PowerShell, not Zsh." ;;
  esac
  export PATH="$HOME/.local/bin:$PATH"
  work_dir="$(mktemp -d)"
  trap 'rm -rf -- "$work_dir"' EXIT
  log 'Preparing required tools (system package installation may request sudo)'
  if [ "$platform" = Darwin ]; then install_macos; else install_linux "$distro"; fi
  for tool in git curl zsh chezmoi; do
    command -v "$tool" >/dev/null 2>&1 || die "$tool is still missing after installation."
  done
  if [ "$install_omz" -eq 1 ]; then install_oh_my_zsh; fi
  source_dir="$(chezmoi source-path)"
  if [ ! -d "$source_dir/.git" ] && [ ! -f "$source_dir/.git" ]; then
    log "Initializing $repo_url"
    chezmoi init "$repo_url"
  else
    log "Keeping existing chezmoi source: $source_dir"
  fi
  if [ "$apply" -eq 1 ]; then chezmoi apply; else chezmoi diff; fi
  if [ "$change_shell" -eq 1 ]; then change_login_shell; fi
  log 'Setup complete'
  if [ "$apply" -eq 0 ]; then
    # PATH changes in this child shell do not propagate to the caller.
    printf 'Review the diff, then run: %q apply\n' "$(command -v chezmoi)"
  fi
  printf 'After applying, open a new terminal or run: exec zsh -l\n'
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then main "$@"; fi
