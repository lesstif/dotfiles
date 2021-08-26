## Detect OS TYPE
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="osx"
elif [[ "$OSTYPE" == "cygwin" ]]; then
    OS="cygwin"
elif [[ "$OSTYPE" == "msys" ]]; then
    OS="msys"
elif [[ "$OSTYPE" == "win32" ]]; then
    OS="win32"
fi

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.bash_extra can be used for other settings you don’t want to commit.
# ~/.*_local is local only files, don't commit.
# ~/.*_${OS} is OS(linux, os x, windows, etc...) dependent files.
INITS="path bash_prompt exports exports_local aliases aliases_${OS} aliases_local functions functions_${OS} functions_local  bash_extra"

for f in $INITS ; do
    file=${HOME}/.${f}
    [ -f "$file" ] && source "$file";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# Add tab completion for many Bash commands
if which brew &> /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
	source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
elif [ -d /etc/bash_completion.d/ ];then        ## RHEL distro    
    for i in /etc/bash_completion.d/*;do
        source $i;
    done
fi;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
	complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;

# export PS1="\[\e[36;1m\]\u@\[\e[32;1m\]\h:\[\e[31;1m\]\w:> \[\e[0m\]" ;

## enable forward search
## http://vaab.blog.kal.fr/2010/11/11/enabling-ctrl-s-for-forward-history-search-in-bash/
stty stop ''

## terminal ls color settings
eval `dircolors $HOME/.dircolors`

## sdk man init
source "/home/lesstif/.sdkman/bin/sdkman-init.sh"
