@ECHO OFF

ECHO run powsshell and paste below command on powershell prompt &
ECHO set-executionpolicy remotesigned -s currentuser &
ECHO iex (new-object net.webclient).downloadstring('https://get.scoop.sh')

REM add new bucket
scoop bucket add nerd-fonts
scoop bucket add extras

REM install font

REM utility
scoop install 7zip
scoop install openssl
scoop install sysinternals 
scoop install procexp 

REM font
scoop install firacode-nf
scoop install SourceCodePro-NF

REM editor
scoop install vim 
scoop install ctags 
 
REM network-util
scoop install curl 
scoop install putty 
scoop install filezilla 

REM develop package
scoop install git 
scoop install nodejs 
scoop install gulp-cli 
scoop install python 
scoop install ruby 
scoop install heidisql  
scoop install php 

REM scoop install php --version 7.0.23 
scoop install mysql 
