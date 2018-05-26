## copy vimrc file to $HOME
Copy-Item -Path ./vim/.vimrc -Destination $env:USERPROFILE/_vimrc
Copy-Item -Path ./vim/.gvimrc -Destination $env:USERPROFILE/_gvimrc 

# check vundle directory whether already exist
$Vundle_DIR = "$env:Userprofile/.vim/bundle/Vundle.vim"

if(!(Test-Path -Path $Vundle_DIR )){
    $vundle_install = "git clone https://github.com/VundleVim/Vundle.vim.git $Vundle_DIR"
    iex -ErrorAction SilentlyContinue $vundle_install
}

$vim_run = 'vim +PluginInstall +qall'
iex $vim_run

