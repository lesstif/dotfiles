" KwangSeob's vimrc
" $Header: /export/home/lesstif/.vimrc,v 1.1 1999-7-13 16:11:24+09 lesstif Exp $
" To use it, copy it to
" 	for Unix :  ~/.vimrc
"   Windows : $VIM\_vimrc
" Use the Solarized Dark theme
set background=dark
colorscheme solarized
let g:solarized_termtrans=1


if &t_Co > 2
	syntax on
endif

set  nohlsearch

"Default encoding 
set encoding=UTF-8
set fileencoding=UTF-8
set fileencodings=ucs-bom,UTF-8,cp949


iab	3include #include
iab 3inckude #include 
cab sem set makeprg=cc\ -v\ -o\ #<\ %
cab cpp so /usr/local/share/vim/vim57/syntax/cpp.vim
set sw=4
set incsearch
set nowrapscan " 검색할 때 문서의 끝에서 다시 처음으로 돌아가지 않는다.
set noerrorbells        " turn off beep bells
set esckeys			" allow usage of cursor keys within insert mode
"set highlight=8r,db,es,hs,mb,Mr,nu,rs,sr,tb,vr,ws
set ignorecase	" ignore the case in search patterns? NO!
set noinsertmode	" start in normal mode
set autoindent	" off as I usually do not write code.
set autowrite		" on saves a lot of trouble
set nocompatible	" Use Vim defaults (much better!)
set bs=2		" allow backspacing over everything in insert mode
set ai			" always set autoindenting on
set tw=79		" always limit the width of text to 78
set backup		" keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set   iskeyword=@,48-57,_,192-255,-,.	"add the dash & the dot as "letters" to "words"
set joinspaces
set cindent
set laststatus=2
set visualbell
set magic
set modeline
set modelines=1
"set number
set path=.,,~/.P/vim,~/.P/vim/syntax,~/.P/vim/source,$VIM/syntax/
"set report=0
set ruler  "화면 우측 하단에 현재 커서의 위치(줄,칸)를 보여준다.
set showcmd	" Show current uncompleted command
set showmatch
set showmode
set nostartofline
set tabstop=4

" Set the colors for vim on "xterm"
if &term=="xterm"
  set t_Co=32
  set t_ABet t_AF==se use this as to not annoy cow-orkers in the same room.
"       Thankyou!  :-)
  set   t_vb=

" ABbreviations
" Abbreviations for some important numbers:
  iab YDesc /* <<프로그램 DESCRIPTION>> <C-J><C-J><Left> 프로그램명 : <C-J><Left>프로그램 구분 : <C-J> 작성자 : <C-J> 프로그램 개요: <C-J> */ <Up><Up><Up><Up><Up><Up>
  iab YLog /* <C-J> $Log:$ <C-J> */
  iab YId #ifndef lint <C-J> static const char cvsid[] = "$Id:$"; <C-J> <Left><Left>#endif
  iab Ypi 3.1415926535897932384626433832795028841972
  iab Ye  2.7182818284590452353602874713526624977573
  iab Yalpha abcdefghijklmnopqrstuvwxyz
  iab YALPHA ABCDEFGHIJKLMNOPQRSTUVWXYZ
  iab Ydigit 1234567890
  iab charcter character
  iab charcters characters
  iab exmaple example
  iab shoudl should
  iab seperate separate
  iab teh the
  iab Ytime <C-R>=strftime("%H:%M")<CR>
  iab YDate <C-R>=strftime("%H:%M")<CR>
  iab Ydate <C-R>=strftime("%H:%M")<CR>
" Example: 14:28
"
  iab YDATE   <C-R>=strftime("%y%m%d %T")<CR>
" Example: 971027 12:00:00
"
  iab YDate <C-R>=strftime("%a %b %d %T %Z %Y")<CR>
" Example: Tue Dec 16 12:07:00 CET 1997
"
map Q gq
iab	inckude include
iab swtich switch
iab onclude include
iab okclude include 
cab init :e $HOME/.vimrc

" === Emacs Style Key mapping =======
cnoremap <C-A> <Home>
cnoremap <C-F> <Right>
cnoremap <C-B> <Left>
cnoremap <ESC>b <S-Left>
cnoremap <ESC>f <S-Right>
cnoremap <ESC><C-H> <C-W>
map <C-F9> :make
map <F5> :!aaa
"map &|/**/
n CC()
let file=buffer_name(1)
let cmd="cc "  . file
return cmd
endfunction

augroup cprog
  " Remove all cprog autocommands
  au!

  " When starting to edit a file:
  "   For *.c and *.h files set formatting of comments and set C-indenting on.
  "   For other files switch it off.
  "   Don't change the order, it's important that the line with * comes first.
  autocmd BufRead *       set formatoptions=tcql nocindent comments&
  autocmd BufRead *.pc,*.c,*.C,*.cpp,*.i,*.cc,*.h set formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://
  autocmd BufRead *.buf so $VIMRUNTIME/syntax/sql.vim
  autocmd BufRead *.php3,*.php,*.inc  so $VIMRUNTIME/syntax/php.vim
  autocmd BufRead *.java,*.jav set sw=2 ts=2 cindent autoindent 
  autocmd BufRead *.wml so $VIMSUNTIME/syntax/wml.vim
	
augroup END

" Java setting
au BufNewFile,BufReadPost *.java set makeprg=jikes\ -nowarn\ -Xstdout\ +E\ %
au BufNewFile,BufReadPost *.java set errorformat=%f:%l:%c:%*\\d:%*\\d:%*\\s%m 

augroup gzip
  " Remove all gzip autocommands
  au!

  " Enable editing of gzipped files
  "	  read:	set binary mode before reading the file
  "		uncompress text in buffer after reading
  "	 write:	compress file after writing
  "	append:	uncompress file, append, compress file
  autocmd BufReadPre,FileReadPre	*.gz set bin
  autocmd BufReadPost,FileReadPost	*.gz '[,']!gunzip
  autocmd BufReadPost,FileReadPost	*.gz set nobin
  autocmd BufReadPost,FileReadPost	*.gz execute ":doautocmd BufReadPost " . expand("%:r")

  autocmd BufWritePost,FileWritePost	*.gz !mv <afile> <afile>:r
  autocmd BufWritePost,FileWritePost	*.gz !gzip <afile>:r

  autocmd FileAppendPre			*.gz !gunzip <afile>
  autocmd FileAppendPre			*.gz !mv <afile>:r <afile>
  autocmd FileAppendPost		*.gz !mv <afile> <afile>:r
  autocmd FileAppendPost		*.gz !gzip <afile>:r
augroup END

augroup bz2
  " Remove all bzip autocommands
  au!

  autocmd BufReadPre,FileReadPre	*.bz2 set bin
  autocmd BufReadPost,FileReadPost	*.bz2 '[,']!bzip2 -d
  autocmd BufReadPost,FileReadPost	*.bz2 set nobin
  autocmd BufReadPost,FileReadPost	*.bz2 execute ":doautocmd BufReadPost " . expand("%:r")

  autocmd BufWritePost,FileWritePost	*.bz2 !mv <afile> <afile>:r
  autocmd BufWritePost,FileWritePost	*.bz2 !gzip <afile>:r

  autocmd FileAppendPre			*.bz2 !bzip2 -d <afile>
  autocmd FileAppendPre			*.bz2 !mv <afile>:r <afile>
  autocmd FileAppendPost		*.bz2 !mv <afile> <afile>:r
  autocmd FileAppendPost		*.bz2 !bzip2 <afile>:r
augroup END

