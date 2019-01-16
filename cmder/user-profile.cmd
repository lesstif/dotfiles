:: use this file to run your own startup commands
:: use  in front of the command to prevent printing the command

:: call "%GIT_INSTALL_ROOT%/cmd/start-ssh-agent.cmd"
:: set "PATH=%CMDER_ROOT%\vendor\whatever;%PATH%"

SET ACE_DIR=D:\devel\ACE_wrappers

:: for CMake
SET CMAKE_MAKE_PROGRAM=mingw32-make
SET CMAKE_C_COMPILER=mingw32-gcc.exe
SET CMAKE_CXX_COMPILER=mingw32-g++.exe

:: for docker
:: SET DOCKER_CERT_PATH="d:\docker\machines\default"
:: SET DOCKER_HOST="tcp://192.168.99.100:2376"
:: SET DOCKER_TLS_VERIFY=1
:: MACHINE_STORAGE_PATH=d:\docker\machine\default
::
:: additional path setting
SET PATH=%PATH%;c:\util\Sysinternals;D:\devel\gradle-2.9\bin;

SET EDITOR=gvim.exe
SET VI=%EDITOR%

SET JAVA_HOME=%HOME%\scoop\apps\oraclejdk8\current
SET PATH=%JAVA_HOME%\bin;%PATH%;

::PHP
::SET PATH=D:\devel\php\php-7.1.14-Win32-VC14-x64;%PATH%;
::SET PATH=D:\devel\php\php-7.2.5-nts-Win32-VC15-x64;%PATH%;

SET GOPATH=d:\github\golang
::SET PATH=d:\devel\golang\bin;%PATH%;
SET GOROOT=%HOME%\scoop\apps\go\current\

:: git ignore
SET CURL_GI=curl.exe -L -s https://www.gitignore.io/api/

:: run another aliases
%SystemRoot%\system32\doskey /listsize=2000 /macrofile=%CMDER_ROOT%\config\user-custom-aliases.cmd
