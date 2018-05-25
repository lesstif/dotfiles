#  scoop install script

set-executionpolicy remotesigned -s currentuser
iex (new-object net.webclient).downloadstring('https://get.scoop.sh')

# add new bucket
scoop bucket add extras
scoop bucket add versions
scoop bucket add java

REM font install need admin rights.
scoop bucket add nerd-fonts

REM install sudo for admin rights
scoop install sudo

REM ======================================
REM ================ Util ================
scoop install 7zip vim notepadplusplus ctags 
scoop install openssl sysinternals procexp 

REM copy _vimrc to %HOME%\_vimrc

REM ====================================
REM ====== DEVEL   =====================
scoop install git 

REM Java
scoop install oraclejdk8 oraclejdk9 maven ant gradle

REM PHP
scoop install php php71 php70 php56 composer
REM scoop install php-xdebug

REM python
scoop install python python35 python34

REM ruby
scoop install ruby

REM go
scoop install go

REM nodejs
scoop install nodejs nodejs9 nodejs8 nodejs7 nodejs6
scoop install gulp-cli 

REM font
sudo scoop install firacode-nf SourceCodePro-NF
sudo scoop install nanum-coding
 
REM network-util
scoop install curl 
scoop install putty 
scoop install filezilla 

REM ======================================================
REM DBMS
scoop install mysql 
scoop install heidisql  
