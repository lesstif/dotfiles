@ECHO OFF

set WGET=wget --no-check-certificate --content-disposition

%WGET% https://www.bandisoft.com/bandizip/dl.php?web

REM Source code Pro
%WGET% https://github.com/adobe-fonts/source-code-pro/archive/2.030R-ro/1.050R-it.zip

REM firacode font
%WGET% https://github.com/tonsky/FiraCode/releases/download/1.205/FiraCode_1.205.zip

REM nanum coding
%WGET% https://github.com/naver/nanumfont/releases/download/VER2.5/NanumGothicCoding-2.5.zip

REM nanum font
%WGET% http://appdown.naver.com/naver/font/NanumFont/setup/NanumFontSetup_TTF_BARUNGOTHIC_hangeulcamp.exe

REM Total commander
%WGET% https://totalcommander.ch/win/tcmd912x32_64.exe

REM https://github.com/mailhog/MailHog/
%WGET% https://github.com/mailhog/MailHog/releases/download/v1.0.0/MailHog_windows_amd64.exe
