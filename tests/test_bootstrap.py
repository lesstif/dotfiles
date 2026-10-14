"""Bootstrap checks with temporary homes and mocked installers; no host changes."""
import os
from pathlib import Path
import subprocess
import tempfile
import unittest


REPO = Path(__file__).resolve().parents[1]


class BootstrapTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        self.home = self.root / "home"
        self.home.mkdir()
        self.bin = self.root / "bin"
        self.bin.mkdir()
        self.env = dict(os.environ, HOME=str(self.home),
                        PATH=f"{self.bin}:/usr/bin:/bin", LOG=str(self.root / "log"))
        self.command("id", "echo 1000")
        # Use Darwin with mocked brew so main() doesn't depend on host os-release.
        self.command("uname", "echo Darwin")
        self.command("brew", 'echo "brew $*" >> "$LOG"')
        self.command("sudo", 'echo "sudo $*" >> "$LOG"; exit 88')
        self.command("curl", 'echo "curl $*" >> "$LOG"; exit 88')
        self.command("git", '''echo "git $*" >> "$LOG"
if [ "$1" = clone ]; then
  for dest in "$@"; do :; done
  mkdir -p "$dest"
  touch "$dest/oh-my-zsh.sh"
fi''')
        self.command("zsh", ":")
        self.command("chsh", 'echo "chsh $*" >> "$LOG"')
        self.command("chezmoi", '''echo "chezmoi $*" >> "$LOG"
case "$1" in
  source-path) echo "$HOME/.local/share/chezmoi" ;;
  init) mkdir -p "$HOME/.local/share/chezmoi/.git" ;;
esac''')

    def command(self, name, body):
        file = self.bin / name
        file.write_text("#!/bin/sh\n" + body + "\n")
        file.chmod(0o755)

    def run_script(self, *args, script=None):
        if script is None:
            cmd = ["bash", str(REPO / "bootstrap.sh"), *args]
        else:
            cmd = ["bash", "-c", 'source "$1"; ' + script,
                   "test", str(REPO / "bootstrap.sh"), *args]
        return subprocess.run(cmd, env=self.env, capture_output=True, text=True)

    def log(self):
        file = self.root / "log"
        return file.read_text() if file.exists() else ""

    def test_default_initializes_and_reviews_without_applying_or_chsh(self):
        result = self.run_script()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertTrue((self.home / ".oh-my-zsh/oh-my-zsh.sh").exists())
        self.assertIn("chezmoi init https://github.com/lesstif/dotfiles.git", self.log())
        self.assertIn("chezmoi diff", self.log())
        self.assertNotIn("chezmoi apply", self.log())
        self.assertNotIn("chsh", self.log())
        self.assertNotIn("sudo", self.log())
        self.assertNotIn("curl", self.log())
        self.assertFalse((self.home / ".zshrc").exists())

    def test_repeat_preserves_omz_and_source_without_downloading(self):
        self.assertEqual(self.run_script().returncode, 0)
        marker = self.home / ".oh-my-zsh/oh-my-zsh.sh"
        marker.write_text("keep my installation")
        (self.root / "log").unlink()
        result = self.run_script("--apply")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(marker.read_text(), "keep my installation")
        self.assertIn("chezmoi apply", self.log())
        self.assertNotIn("chezmoi init", self.log())
        self.assertNotIn("git clone", self.log())

    def test_invalid_omz_is_preserved_and_prevents_apply(self):
        (self.home / ".oh-my-zsh").mkdir()
        result = self.run_script("--apply")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("not an Oh My Zsh installation", result.stderr)
        self.assertNotIn("chezmoi apply", self.log())

    def test_skip_omz_and_custom_repo(self):
        result = self.run_script("--skip-oh-my-zsh", "--repo", "https://example.com/fork.git")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertFalse((self.home / ".oh-my-zsh").exists())
        self.assertIn("chezmoi init https://example.com/fork.git", self.log())

    def test_invalid_flags_do_nothing(self):
        for args in [("--wat",), ("--repo",)]:
            with self.subTest(args=args):
                self.assertNotEqual(self.run_script(*args).returncode, 0)
                self.assertEqual(self.log(), "")

    def test_windows_rejected_before_installing(self):
        self.command("uname", "echo MINGW64_NT")
        result = self.run_script()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("native PowerShell", result.stderr)
        self.assertEqual(self.log(), "")

    def test_installation_failure_stops_before_dotfiles_apply(self):
        result = self.run_script(script='install_macos() { return 89; }; main --apply')
        self.assertEqual(result.returncode, 89)
        self.assertNotIn("chezmoi apply", self.log())

    def test_init_failure_stops_before_apply(self):
        self.command("chezmoi", '''echo "chezmoi $*" >> "$LOG"
case "$1" in
  source-path) echo "$HOME/.local/share/chezmoi" ;;
  init) exit 77 ;;
esac''')
        result = self.run_script("--apply", "--skip-oh-my-zsh")
        self.assertEqual(result.returncode, 77)
        self.assertNotIn("chezmoi apply", self.log())

    def test_shell_changes_only_when_requested(self):
        # Avoid touching /etc/shells: pretend this Zsh is already registered.
        self.command("grep", "exit 0")
        result = self.run_script("--apply", "--change-shell", "--skip-oh-my-zsh")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn(f"chsh -s {self.bin}/zsh", self.log())
        self.assertNotIn("sudo", self.log())

    def test_root_is_rejected_but_help_still_works(self):
        self.command("id", "echo 0")
        result = self.run_script()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("normal user", result.stderr)
        self.assertEqual(self.run_script("--help").returncode, 0)
        self.assertEqual(self.log(), "")

    def test_arch_uses_full_upgrade_and_no_partial_sync(self):
        result = self.run_script(script='''
command() { if [ "$*" = "-v chezmoi" ]; then return 1; else builtin command "$@"; fi; }
as_root() { printf '%s\\n' "$*" >> "$LOG"; }
install_linux arch
''')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(self.log().strip(), "pacman -Syu --needed git curl zsh chezmoi")

    def test_debian_installs_chezmoi_into_user_bin(self):
        result = self.run_script(script='''
work_dir="$HOME/work"; mkdir "$work_dir"
command() { if [ "$*" = "-v chezmoi" ]; then return 1; else builtin command "$@"; fi; }
as_root() { printf '%s\\n' "$*" >> "$LOG"; }
curl() {
  printf '%s\\n' "$*" >> "$LOG"
  printf 'printf "installer %%s\\\\n" "$*" >> "$LOG"\\n' > "$work_dir/chezmoi.sh"
}
install_linux debian
''')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("apt-get update", self.log())
        self.assertIn("apt-get install -y ca-certificates curl git zsh", self.log())
        self.assertIn(f"installer -b {self.home}/.local/bin", self.log())

    def test_macos_installs_only_missing_tools(self):
        self.command("brew", 'echo "brew $*" >> "$LOG"')
        result = self.run_script(script='''
command() { if [ "$*" = "-v chezmoi" ]; then return 1; else builtin command "$@"; fi; }
install_macos
''')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(self.log().strip(), "brew install chezmoi")


if __name__ == "__main__":
    unittest.main()
