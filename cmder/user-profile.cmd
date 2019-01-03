:: use this file to run your own startup commands
:: use  in front of the command to prevent printing the command

:: call "%GIT_INSTALL_ROOT%/cmd/start-ssh-agent.cmd"
:: set "PATH=%CMDER_ROOT%\vendor\whatever;%PATH%"

SET ACE_DIR=D:\devel\ACE_wrappers

SET EDITOR="gvim.exe"

:: for CMake
SET CMAKE_MAKE_PROGRAM=mingw32-make
SET CMAKE_C_COMPILER=mingw32-gcc.exe
SET CMAKE_CXX_COMPILER=mingw32-g++.exe

:: for docker
SET DOCKER_CERT_PATH="d:\docker\machines\default"
SET DOCKER_HOST="tcp://192.168.99.100:2376"
SET DOCKER_TLS_VERIFY=1
:: MACHINE_STORAGE_PATH=d:\docker\machine\default
::
SET PATH=%PATH%;c:\util\Sysinternals;D:\devel\gradle-2.9\bin;

:: load another aliases
%SystemRoot%\system32\doskey /listsize=1000 /macrofile=%CMDER_ROOT%\config\user-custom-aliases.cmd
