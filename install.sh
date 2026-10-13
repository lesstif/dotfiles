#!/usr/bin/env bash
# Operate on this checkout; no Stow, package downloads, or implicit backups.
set -euo pipefail
repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if ! command -v chezmoi >/dev/null 2>&1; then
  echo "Install chezmoi first (see README.md)." >&2
  exit 1
fi
case "${1:-diff}" in
  diff|apply) action="${1:-diff}" ;;
  *) echo "Usage: $0 [diff|apply]" >&2; exit 2 ;;
esac
exec chezmoi --source "$repo_dir" "$action"
