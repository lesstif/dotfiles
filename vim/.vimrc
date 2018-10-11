" Vim
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"             for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc

" for Vundle. 
" git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
" vim +PluginInstall +qall


"==== language setting
set langmenu=en_US.UTF-8
language messages en_US.UTF-8

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" TODO: this may not be in the correct place. It is intended to allow overriding <Leader>.
" source ~/.vimrc.before if it exists.
if filereadable(expand("~/.vimrc.before"))
  source ~/.vimrc.before
endif

" ================ General Config ====================
"set number                      "Line numbers are good
set backspace=indent,eol,start  "Allow backspace in insert mode
set history=1000                "Store lots of :cmdline history
set showcmd                     "Show incomplete cmds down the bottom
set showmode                    "Show current mode down the bottom
set gcr=a:blinkon0              "Disable cursor blink
set visualbell                  "No sounds
set noerrorbells                 " turn off beep bells
set autoread                    "Reload files changed outside vim

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

"turn on syntax highlighting
syntax on

" Change leader to a comma because the backslash is too far away
" That means all \x commands turn into ,x
" The mapleader has to be set before vundle starts loading all
" the plugins.
let mapleader=","

" =============== Vundle Initialization ===============
" This loads all the plugins specified in ~/.vim/vundles.vim
" Use Vundle plugin to manage all other plugins
if filereadable(expand("~/.vim/vundles.vim"))
  source ~/.vim/vundles.vim
endif
au BufNewFile,BufRead *.vundle set filetype=vim

" ================ Turn Off Swap Files ==============

set noswapfile
set nobackup
set nowb

" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
" Only works all the time.
if has('persistent_undo') 
    let myUndoDir=expand('~'). '/.vim/backups'
    
    if !isdirectory(myUndoDir)
        call mkdir(myUndoDir, "p")
    endif

    set undodir=&myUndoDir
    set undofile
endif

" ================ Indentation ======================
set autoindent
set smartindent
set smarttab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab

" Auto indent pasted text
nnoremap p p=`]<C-o>
nnoremap P P=`]<C-o>

filetype plugin on
filetype indent on

" Display tabs and trailing spaces visually
"set list listchars=tab:\ \ ,trail:·

set nowrap       "Don't wrap lines
set linebreak    "Wrap lines at convenient points

" ================ Folds ============================

set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

" ================ Completion =======================

set wildmode=list:longest
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=*.class,*.jar,*.war
set wildignore+=*.zip,*.tgz,*.tar,*.gz,*.tar.gz

" ================ Scrolling ========================

set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" ================ Search ===========================

set incsearch       " Find the next match as we type the search
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital


" ================= Language and Encoding =============
set encoding=utf-8
set fileencodings=utf-8,cp949 "Default encoding is UTF8 and korea

" =================== screen size restore ===================
if has("gui_running")
  function! ScreenFilename()
    if has('win32')
      return $HOME.'\.vimsize'
    else
      return $HOME.'/.vimsize'
    endif
  endfunction

  function! ScreenRestore()
    " Restore window size (columns and lines) and position
    " from values stored in vimsize file.
    " Must set font first so columns and lines are based on font size.
    let f = ScreenFilename()
    if has("gui_running") && g:screen_size_restore_pos && filereadable(f)
      let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
      for line in readfile(f)
        let sizepos = split(line)
        if len(sizepos) == 5 && sizepos[0] == vim_instance
          silent! execute "set columns=".sizepos[1]." lines=".sizepos[2]
          silent! execute "winpos ".sizepos[3]." ".sizepos[4]
          return
        endif
      endfor
    endif
  endfunction

  function! ScreenSave()
    " Save window size and position.
    if has("gui_running") && g:screen_size_restore_pos
      let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
      let data = vim_instance . ' ' . &columns . ' ' . &lines . ' ' .
            \ (getwinposx()<0?0:getwinposx()) . ' ' .
            \ (getwinposy()<0?0:getwinposy())
      let f = ScreenFilename()
      if filereadable(f)
        let lines = readfile(f)
        call filter(lines, "v:val !~ '^" . vim_instance . "\\>'")
        call add(lines, data)
      else
        let lines = [data]
      endif
      call writefile(lines, f)
    endif
  endfunction

  if !exists('g:screen_size_restore_pos')
    let g:screen_size_restore_pos = 1
  endif
  if !exists('g:screen_size_by_vim_instance')
    let g:screen_size_by_vim_instance = 1
  endif

  autocmd VimEnter * if g:screen_size_restore_pos == 1 | call ScreenRestore() | endif
  autocmd VimLeavePre * if g:screen_size_restore_pos == 1 | call ScreenSave() | endif
endif

if has("win32")

else
    " unix or mac
    "set termencoding=utf-8
    "set termencoding=euc-kr
endif    

"############# Input mode =================================
set esckeys			  " allow usage of cursor keys within insert mode
"set highlight=8r,db,es,hs,mb,Mr,nu,rs,sr,tb,vr,ws

set noinsertmode	" start in normal mode
set autowrite		" on saves a lot of trouble

set bs=2		" allow backspacing over everything in insert mode
set   iskeyword=@,48-57,_,192-255,-,.	"add the dash & the dot as "letters" to "words"
set joinspaces
"set cindent
"set laststatus=2

set magic
set modeline
set modelines=1
" source $VIM/mswin.vim

set path=.,,~/.P/vim,~/.P/vim/syntax,~/.P/vim/source,$VIM/syntax/

"set report=0
set ruler

set showmatch

set nostartofline

" Set the colors for vim on "xterm"
" if &term=="xterm"
"  set t_Co=8
"  set t_AB=[%?%p1%{8}%<%t%p1%{40}%+%e%p1%{92}%+%;%dm
"  set t_AF=[%?%p1%{8}%<%t%p1%{30}%+%e%p1%{82}%+%;%dm
"endif
"       t_vb:  terminal's visual bell - turned off to make Vim quiet!
"       Please use this as to not annoy cow-orkers in the same room.
"       Thankyou!  :-)
" set   t_vb=

" ABbreviations
" Abbreviations for some important numbers:
  iab YLog /* <C-J> $Log:$ <C-J> */
  iab YId  #ifdef RCSID <C-J> static const char rcsid[] = "$Id:$"; <C-J> <Left><Left>#endif
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
" Example: 14:28
"
  iab YDATE   <C-R>=strftime("%y%m%d %T")<CR>
" Example: 971027 12:00:00
"
  iab Ydate <C-R>=strftime("%a %b %d %T %Z %Y")<CR>
  iab CTime <C-R>=strftime("%Y %b %d %T ")<CR>
" Example: Tue Dec 16 12:07:00 CET 1997
"
map Q gq
iab	inckude include
iab swtich switch
iab onclude include
iab okclude include 
cab init :e $VIM/_vimrc
"확장자가 cpp, html 이면 오작동   
"cab cpp :source $VIMRUNTIME/syntax/cpp.vim
"cab html :source $VIMRUNTIME/syntax/html.vim

set nocompatible              " be iMproved, required
filetype off                  " required

" ### Vundule
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
 
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
 
" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}
 
Plugin 'tpope/vim-surround'

Plugin 'altercation/vim-colors-solarized'
Plugin 'bling/vim-airline'
Plugin 'scrooloose/syntastic'

Plugin 'junegunn/vim-easy-align'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

"set background=dark
colorscheme solarized
set background=light
let g:solarized_termcolors= 256
let g:solarized_contrast  = "high"


" Look for the file in the current directory, then south until you reach home.
set tags=tags;$HOME


" Forcing Syntax Coloring for files with odd extensions
" http://vim.wikia.com/wiki/Forcing_Syntax_Coloring_for_files_with_odd_extensions
autocmd BufNewFile,BufRead .alias* set syntax=bash
autocmd BufNewFile,BufRead .export* set syntax=bash

"set guifont=*
"let g:airline_powerline_fonts = 1
