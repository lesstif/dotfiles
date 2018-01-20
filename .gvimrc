" vimrc file: $VIM/_vimrc
SQWR
" source $VIM/_vimrc.org
source $VIM/.vimrc

set antialias " MacVim: smooth fonts.
if has("gui_running")
  if has("gui_gtk2") || has("gui_gtk3")
    set guifont=Courier\ New\ 14
  elseif has("gui_kde")
    set guifont=Courier\ New/11/-1/5/50/0/0/0/1/0
  elseif has("x11")
    set guifont=-*-courier-medium-r-normal-*-*-180-*-*-m-*-*
  else
    " OS X
    "set guifont=Menlo:h14
    "set guifont=Menlo\ Regular\ for\ Powerline:h16
    set guifont=Source\ Code\ Pro:h16 
    set guifontwide=NanumGothicCoding:h16
  endif
endif

"set bdlay=100
"set backspace=indent,eol,start

"
" geometry setting
"winpos 0 0

"
" Use the Solarized Dark theme
set background=dark
colorscheme solarized

" Disable MacVim's new-tab functionality
"macm File.New\ Tab key=<nop>
"
" Toggle fullscreen
nmap <D-CR> :set invfu<CR>
