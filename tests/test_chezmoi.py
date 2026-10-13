"""Integration tests in temporary homes; never apply to the developer's home."""
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


REPO = Path(__file__).resolve().parents[1]
CHEZMOI = os.environ.get("CHEZMOI_BIN") or shutil.which("chezmoi")


@unittest.skipUnless(CHEZMOI and shutil.which("zsh"), "chezmoi and zsh are required")
class DotfilesTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        self.home = self.root / "home"
        self.home.mkdir()
        self.config = self.root / "chezmoi.toml"
        self.config.write_text("")

    def chezmoi(self, *args, data=None, check=True):
        cmd = [CHEZMOI, "--source", str(REPO), "--destination", str(self.home),
               "--config", str(self.config), "--persistent-state", str(self.root / "state"),
               "--cache", str(self.root / "cache"), "--no-tty"]
        if data is not None:
            cmd += ["--override-data", json.dumps(data)]
        return subprocess.run(cmd + list(args), capture_output=True, text=True, check=check)

    def shell(self, script, *, login=False, path="/usr/bin:/bin"):
        # HOME is changed only in the child process, to exercise actual Zsh startup.
        env = {"HOME": str(self.home), "ZDOTDIR": str(self.home), "PATH": path,
               "TERM": "xterm", "LC_ALL": "C"}
        return subprocess.run(["zsh", "-d", "-lic" if login else "-ic", script],
                              env=env, capture_output=True, text=True, check=True)

    def test_apply_is_idempotent_and_only_deploys_managed_files(self):
        self.chezmoi("apply")
        first = (self.home / ".zshrc").read_bytes()
        self.chezmoi("apply")
        self.assertEqual(first, (self.home / ".zshrc").read_bytes())
        self.chezmoi("verify")
        self.assertEqual("", self.chezmoi("diff").stdout)
        self.assertFalse((self.home / "install.sh").exists())
        self.assertFalse((self.home / "bash").exists())
        self.assertFalse((self.home / ".macos").exists())
        self.assertTrue((self.home / ".gitignore_global").is_file())

    def test_linux_startup_preserves_paths_and_ignores_local_files(self):
        (self.home / ".aliases_local").write_text("print LOCAL_FILE_WAS_LOADED\n")
        inherited = self.root / "inherited"
        inherited.mkdir()
        self.chezmoi("apply", data={"chezmoi": {"os": "linux"}})
        for login in (False, True):
            result = self.shell('print -r -- $PATH; alias ls; ls -d .', login=login,
                                path=f"{inherited}:/usr/bin:/bin:/usr/bin")
            self.assertEqual("", result.stderr)
            self.assertNotIn("LOCAL_FILE_WAS_LOADED", result.stdout)
            self.assertIn(str(inherited), result.stdout.splitlines()[0].split(":"))
            entries = result.stdout.splitlines()[0].split(":")
            self.assertEqual(len(entries), len(set(entries)))
            self.assertIn("ls --color=auto", result.stdout)
            self.assertNotIn("gls", result.stdout)

    def test_machine_config_overrides_defaults_and_runtime_paths(self):
        custom = self.root / "machine tools"
        custom.mkdir()
        (self.home / ".nvm").mkdir()
        (self.home / ".nvm/nvm.sh").write_text('export PATH="/runtime/bin:$PATH"\n')
        self.config.write_text(f'''[data.shell]
theme = "custom"
plugins = ["git"]
extra_path = [{json.dumps(str(custom))}]
[data.shell.env]
EDITOR = "nvim"
TEST_LITERAL = "$(touch /should-not-execute)"
[data.shell.aliases]
ls = "ls -F"
[data.git]
email = "work@example.com"
''')
        self.chezmoi("apply")
        rc = (self.home / ".zshrc").read_text()
        self.assertIn("custom", rc)
        self.assertNotIn("'docker'", rc)
        result = self.shell('print -r -- $path[1] $EDITOR $TEST_LITERAL; alias ls')
        self.assertEqual("", result.stderr)
        self.assertIn(str(custom), result.stdout.splitlines()[0])
        self.assertIn("nvim $(touch /should-not-execute)", result.stdout)
        self.assertIn("ls -F", result.stdout)
        result = subprocess.run(["git", "config", "--file", str(self.home / ".gitconfig"),
                                 "user.email"], capture_output=True, text=True, check=True)
        self.assertEqual("work@example.com\n", result.stdout)

    def test_personal_aliases_override_framework_aliases(self):
        omz = self.home / ".oh-my-zsh"
        omz.mkdir()
        (omz / "oh-my-zsh.sh").write_text("alias ls='framework-ls'\nalias vi='framework-vi'\n")
        self.chezmoi("apply")
        result = self.shell('alias vi; alias ls; source "$HOME/.zshrc"; alias vi')
        self.assertEqual("", result.stderr)
        self.assertNotIn("framework-", result.stdout)
        self.assertIn("vim", result.stdout)

    def test_false_and_empty_machine_values_override_defaults(self):
        for directory, filename in ((".oh-my-zsh", "oh-my-zsh.sh"),
                                    (".nvm", "nvm.sh"), (".sdkman/bin", "sdkman-init.sh")):
            target = self.home / directory
            target.mkdir(parents=True)
            (target / filename).write_text("print SHOULD_NOT_BE_LOADED\n")
        self.config.write_text('''[data.shell]
use_oh_my_zsh = false
use_nvm = false
use_sdkman = false
plugins = []
''')
        self.chezmoi("apply")
        result = self.shell("print clean")
        self.assertEqual("clean\n", result.stdout)
        self.assertEqual("", result.stderr)
        rc = (self.home / ".zshrc").read_text()
        self.assertNotIn('source "$ZSH/oh-my-zsh.sh"', rc)
        self.assertNotIn('source "$NVM_DIR/nvm.sh"', rc)
        self.assertNotIn('source "$SDKMAN_DIR/bin/sdkman-init.sh"', rc)

    def test_restored_aliases_and_colors_load_after_framework(self):
        omz = self.home / ".oh-my-zsh"
        omz.mkdir()
        (omz / "oh-my-zsh.sh").write_text("export LS_COLORS=framework-colors\n")
        self.chezmoi("apply")
        self.assertTrue((self.home / ".aliases").is_file())
        self.assertTrue((self.home / ".dircolors").is_file())
        result = self.shell("alias week; alias wpdf; alias gi-java; print -r -- $LS_COLORS")
        self.assertEqual("", result.stderr)
        self.assertIn("date +%V", result.stdout)
        self.assertIn("wkhtmltopdf", result.stdout)
        self.assertIn("eclipse,java", result.stdout)
        self.assertIn("di=34", result.stdout)
        self.assertNotIn("framework-colors", result.stdout)

    def test_machine_environment_overrides_framework_environment(self):
        omz = self.home / ".oh-my-zsh"
        omz.mkdir()
        (omz / "oh-my-zsh.sh").write_text("export EDITOR=framework-editor\n")
        self.config.write_text('[data.shell.env]\nEDITOR = "nvim"\n')
        self.chezmoi("apply")
        self.assertEqual("nvim\n", self.shell("print -r -- $EDITOR").stdout)

    def test_install_wrapper_is_independent_of_working_directory(self):
        bindir = self.root / "bin"
        bindir.mkdir()
        fake = bindir / "chezmoi"
        fake.write_text('#!/bin/sh\nprintf "%s\\n" "$@"\n')
        fake.chmod(0o755)
        env = dict(os.environ, PATH=f"{bindir}:/usr/bin:/bin")
        result = subprocess.run(["bash", str(REPO / "install.sh"), "apply"],
                                cwd=self.root, env=env, capture_output=True, text=True,
                                check=True)
        self.assertEqual(["--source", str(REPO), "apply"], result.stdout.splitlines())
        result = subprocess.run(["bash", str(REPO / "install.sh"), "-u"],
                                cwd=self.root, env=env, capture_output=True, text=True)
        self.assertEqual(2, result.returncode)

    def test_gls_is_used_when_installed(self):
        bindir = self.root / "bin"
        bindir.mkdir()
        gls = bindir / "gls"
        gls.write_text('#!/bin/sh\nprintf "gls invoked\\n"\n')
        gls.chmod(0o755)
        self.chezmoi("apply")
        result = self.shell("ls -d .", path=f"{bindir}:/usr/bin:/bin")
        self.assertIn("gls invoked", result.stdout)

    def test_bsd_ls_fallback(self):
        bindir = self.root / "bin"
        bindir.mkdir()
        ls = bindir / "ls"
        ls.write_text('#!/bin/sh\ncase "$1" in --color=*) exit 1;; esac\nprintf "%s\\n" "$1"\n')
        ls.chmod(0o755)
        self.chezmoi("apply")
        self.assertIn("-G", self.shell("ls -d .", path=f"{bindir}:/usr/bin:/bin").stdout)

    def test_macos_templates_parse_and_git_config_is_portable(self):
        self.chezmoi("apply", data={"chezmoi": {"os": "darwin"}})
        rc = (self.home / ".zshrc").read_text()
        self.assertIn("/opt/homebrew/bin", rc)
        self.assertIn("pbcopy", rc)
        subprocess.run(["zsh", "-n", str(self.home / ".zshrc")], check=True)
        gitconfig = (self.home / ".gitconfig").read_text()
        self.assertIn("~/.gitignore_global", gitconfig)
        self.assertNotIn("/Users/lesstif", gitconfig)
        self.assertIn("[mergetool", gitconfig)
        self.chezmoi("apply", data={"chezmoi": {"os": "linux"}})
        self.assertNotIn("[mergetool", (self.home / ".gitconfig").read_text())

    def test_noninteractive_shell_does_not_initialize_tools(self):
        (self.home / ".nvm").mkdir()
        (self.home / ".nvm/nvm.sh").write_text("print RUNTIME_LOADED\n")
        self.chezmoi("apply")
        result = subprocess.run(["zsh", "-d", "-c", "print clean"],
                                env={"HOME": str(self.home), "ZDOTDIR": str(self.home),
                                     "PATH": "/usr/bin:/bin"}, capture_output=True, text=True,
                                check=True)
        self.assertEqual("clean\n", result.stdout)
        self.assertEqual("", result.stderr)

    def test_invalid_environment_keys_are_rejected(self):
        for key in ("PATH", "HOME", "INVALID-KEY"):
            result = self.chezmoi("apply", data={"shell": {"env": {key: "value"}}}, check=False)
            self.assertNotEqual(0, result.returncode)
            self.assertIn("invalid or reserved", result.stderr)


if __name__ == "__main__":
    unittest.main()
