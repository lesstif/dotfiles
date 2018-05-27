#  scoop install script

Write-Host "install scooop"

# $ErrorActionPreference = 'silentlycontinue'
set-executionpolicy remotesigned -s currentuser
iex (new-object net.webclient).downloadstring('https://get.scoop.sh')

Write-Host "add new bucket...."
scoop bucket add extras
scoop bucket add versions
scoop bucket add java
scoop bucket add nerd-fonts

Write-Host "install sudo for admin rights"
scoop install sudo

Write-Host "============================================================="
Write-Host "====== Installling development package  ====================="
scoop install git sourcetree

Write-Host "============================================================="
Write-Host "================ Installing utility ================"
scoop install 7zip notepadplusplus ctags slack

Write-Host "============================================================="
Write-Host "================ Installing GNUWin32 ================"
scoop install grep file sed which 

Write-Host "================ vim ================"
& .\vim-install.ps1

scoop install openssl sysinternals procexp 

Write-Host "============================================================="
Write-Host "====== Installling JAVA package  ============================"
& .\java-install.ps1

Write-Host "============================================================="
Write-Host "====== Installling PHP package  ============================="

& .\php-install.ps1

Write-Host "============================================================="
Write-Host "====== Installling Python package  =========================="
scoop install python 
# python35 python34

Write-Host "============================================================="
Write-Host "====== Installling Ruby package  ============================"
scoop install ruby

Write-Host "============================================================="
Write-Host "====== Installling Golang package  =========================="
scoop install go

Write-Host "============================================================="
Write-Host "====== Installling nodejs package  =========================="
scoop install nodejs # nodejs9 nodejs8 nodejs7 nodejs6
scoop install gulp-cli 

Write-Host "============================================================="
Write-Host "====== Installling font   package  =========================="
sudo scoop install firacode-nf SourceCodePro-NF
sudo scoop install nanum-coding
 
Write-Host "============================================================="
Write-Host "====== Installling Network Util package  ===================="
scoop install curl wget putty ssh-copy-id filezilla ngrok

Write-Host "============================================================="
Write-Host "====== Installling DBMS package ============================="
scoop install mysql 
scoop install heidisql
