@ECHO ON

REM setting choco installation path
REM set ChocolateyInstall=d:\devel\choco

REM install choco
@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin


REM install package
REM 

REM utility
choco install chocolatey-core.extension -y
choco install 7zip -y
choco install sysinternals -y
choco install procexp -y

REM editor
choco install vim -y
choco install ctags -y
 
REM network-util
choco install curl -y
choco install putty -y
choco install filezilla -y

REM develop package
choco install git -y
choco install nodejs -y
choco install gulp-cli -y
choco install python -y
choco install ruby -y
choco install heidisql -y 
choco install php -y
REM choco install php --version 7.0.23 -y
choco install mysql -y
