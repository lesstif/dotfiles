;= @echo off
;= rem Call DOSKEY and use this file as the macrofile
;= %SystemRoot%\system32\doskey /listsize=1000 /macrofile=%0%
;= rem In batch mode, jump to the end of the file
;= goto:eof
;= Add aliases below here
e.=explorer .
gl=git log --oneline --all --graph --decorate  $*
pwd=cd
clear=cls
history=cat "%CMDER_ROOT%\config\.history"
unalias=alias /d 
vi=START/B gvim $*
cmderr=cd /d "%CMDER_ROOT%"
dp=dir $t pwd  
;= utility & convinience command
ll=ls --color --show-control-char $*


;=openssl=D:\util\openssl-win32\openssl.exe $*

;= env & config
;= doskey doesn't support nested alias. :(
ar=alias/reload $t %SystemRoot%\system32\doskey /listsize=2000 /macrofile=%CMDER_ROOT%\config\user-custom-aliases.cmd
reload=alias/reload $t %SystemRoot%\system32\doskey /listsize=2000 /macrofile=%CMDER_ROOT%\config\user-custom-aliases.cmd
qal=gvim "%CMDER_ROOT%\config\user-aliases.cmd" $t alias/reload $t %SystemRoot%\system32\doskey /listsize=2000 /macrofile=%CMDER_ROOT%\config\user-custom-aliases.cmd
qal2=gvim "%CMDER_ROOT%\config\user-custom-aliases.cmd" $t alias/reload $t %SystemRoot%\system32\doskey /listsize=2000 /macrofile=%CMDER_ROOT%\config\user-custom-aliases.cmd
sett=gvim "%CMDER_ROOT%\config\user-profile.cmd" 

;= vim
vimrc=START/B gvim %HOME%\scoop\apps\vim\current\_vimrc
virc=START/B gvim %HOME%\scoop\apps\vim\current\_vimrc

;=
eh=gvim %SystemRoot%\System32\drivers\etc\hosts

;= develop tools
ant=d:\devel\apache-ant-1.9.1\bin\ant.bat $*
;= valet="%APPDATA%"\Composer\vendor\bin\valet.bat  $*

;==
security-best-practice=pushd . $t cd /d %HOME%\Code\security-best-practices $t gitbook serve $t popd

;=
;=npm %ProgramFiles%\nodejs\npm.cmd npm --no-bin-links $*

;= develoption
;=JDK설정
;=jdk4 set JAVA_HOME=d:\devel\java\j2sdk1.4.2_19 $t set PATH=%JAVA_HOME%\bin;%PATH%
;=jdk5 set JAVA_HOME=d:\devel\java\jdk1.5.0_22 $t set PATH=%JAVA_HOME%\bin;%PATH%
;=jdk6=set JAVA_HOME=d:\devel\java\jdk1.6.0_45 $t set PATH=%JAVA_HOME%\bin;%PATH%
jdk7=set JAVA_HOME=d:\devel\java\jdk1.7.0_80 $t set PATH=%JAVA_HOME%\bin;%PATH%
jdk8=set JAVA_HOME=d:\devel\java\jdk1.8.0_131 $t set PATH=%JAVA_HOME%\bin;%PATH%

;= mvn=d:\devel\maven\apache-maven-3.3.9\bin\mvn.cmd $*
;= mvn33=d:\devel\maven\apache-maven-3.3.9\bin\mvn.cmd $*
;= mvn32=d:\devel\maven\apache-maven-3.2.5\bin\mvn.bat $*
;= mvn3=d:\devel\maven\apache-maven-3.0.4\bin\mvn.bat $*

;= laravel homestead
up=c:\util\vmware-homestead.bat up
halt=c:\util\vmware-homestead.bat halt

php56=c:\devel\php\php-5.6.30-Win32-VC11-x64\php.exe $*
php70=c:\devel\php\php-7.0.23-Win32-VC14-x64\php.exe $*
php71=c:\devel\php\php-7.1.14-Win32-VC14-x64\php.exe $*
php72=c:\devel\php\php-7.2.7-Win32-VC15-x64\php.exe $*

php-xdebug=c:\devel\php\php-7.2.7-xdebug\php.exe $*
;= php=c:\devel\php\php-7.2.7-Win32-VC15-x64\php.exe $*

phps=php -S 0.0.0.0:8000

lumen=%AppData%\Composer\vendor\bin\lumen.bat $*
envoy=%AppData%\Composer\vendor\bin\envoy.bat $*
php-cs-fixer=%AppData%\Composer\vendor\bin\php-cs-fixer.bat $*

art=php artisan $*
please=php please $*
ple=php please $*

;= Visual Studio shell
9vcvars32="%ProgramFiles%\Microsoft Visual Studio 9.0\VC\bin\vcvars32.bat"
10vcvars32="%ProgramFiles%\Microsoft Visual Studio 10.0\VC\bin\vcvars32.bat"
14vcvars32="%ProgramFiles%\Microsoft Visual Studio 14.0\VC\bin\vcvars32.bat"

vc=14vcvars32

mysql="%ProgramFiles%\MySQL\MySQL Server 5.7\bin\mysql.exe" "--defaults-file=%ProgramFiles%\MySQL\MySQL Server 5.7\my.ini"  $*

;=cmake d:\devel\cmake\cmake-3.4.2-win32-x86\bin\cmake.exe
cmake=d:\devel\cmake\cmake-3.6.1-win32-x86\bin\cmake.exe $*

scriptella=d:\devel\scriptella-1.1\bin\scriptella.bat

;=Ruby
useruby=echo "Setting Ruby Interpreter" $t set RUBY_HOME=d:\devel\jruby-1.5.1 $t set PATH=%RUBY_HOME%\bin;%PATH%
usejruby=echo "Setting Java Ruby Interpreter" $t set RUBY_HOME=d:\devel\Ruby187 $t set PATH=%RUBY_HOME%\bin;%PATH%

;=Utility
flyway=d:\util\flyway-3.2.1\flyway.cmd
flywaywn=d:\util\flyway-3.0\flyway.cmd -configFile=conf/flyway-wnwin.properties
flyway2=d:\util\flyway-2.3.1-no-clean-target\flyway.cmd

;= httpie
h=http --follow

;= html2pdf
wimage=wkhtmltoimage.exe $*
wimg=wkhtmltoimage $*
wpdf=wkhtmltopdf.exe $*

;= ffmpeg
;= ffplay="D:\util\ffmpeg-4.0-win64-static\bin\ffplay.exe"
;= ffprobe="D:\util\ffmpeg-4.0-win64-static\bin\ffprobe.exe"

;=
code=cd/d "%HOME%"\code

;=go
go=d:\devel\golang\go-1.9.1\bin\go.exe
godoc=d:\devel\golang\go-1.9.1\bin\godoc.exe
gofmt=d:\devel\golang\go-1.9.1\bin\gofmt.exe
dep=d:\devel\golang\go-1.9.1\bin\dep.exe

;=git ignore
gi=%CURL_GI%/$* -o .gitignore
gilist=%CURL_GI%/list
gidefault=%CURL_GI%/vim,windows,osx,linux -o .gitignore
giall=%CURL_GI%/vim,java,php,windows,osx,linux,eclipse,intellij,maven,gradle,phpstorm,laravel,composer  -o .gitignore
gijava=%CURL_GI%/vim,java,windows,osx,linux,eclipse,intellij,maven,gradle  -o .gitignore
giphp=%CURL_GI%/vim,php,windows,osx,linux,phpstorm,laravel,composer  -o gitignore

;= for headless chrome
chrome="%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" $*
hchrome="%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" --headless $*

;=
redis-cli="%ProgramFiles%\Redis\redis-cli.exe" $*
laravel="%HOME%\scoop\apps\composer\current\home\vendor\bin\laravel.bat" $*  


