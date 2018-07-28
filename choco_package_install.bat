@ECHO OFF

echo Administrative permissions required. Detecting permissions...
echo.

net session >nul 2>&1
if %errorLevel% == 0 (
    echo Success: Administrative permissions confirmed.
) else (
    echo Failure: Current permissions inadequate. 
    echo Exiting....
    goto exitScript
)

@ECHO ON

REM setting choco installation path
REM set ChocolateyInstall=d:\devel\choco

REM install choco
@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin


REM install package
REM 

REM utility
choco install chocolatey-core.extension -y
REM choco install 7zip -y
REM choco install sysinternals -y
REM choco install procexp -y
 
REM editor
REM choco install vim -y
REM choco install ctags -y
REM  
REM network-util
REM choco install curl -y
REM choco install putty -y
REM choco install filezilla -y

REM develop package
REM choco install git -y
REM choco install nodejs -y
REM choco install gulp-cli -y
REM choco install python -y
REM choco install ruby -y
REM choco install heidisql -y 
REM choco install php -y
REM choco install php --version 7.0.23 -y
choco install mysql -y

REM Font
choco install d2codingfont -y
choco install sourcecodepro -y
choco install firacode -y
choco install hackfont -y

:exitScript
exit /b

