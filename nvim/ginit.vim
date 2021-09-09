set ch=2		" Make command line two lines high

set mousehide		" Hide the mouse when typing text

GuiScrollBar 1
GuiFont JetBrains\ Mono:h16

" set initial window size
" set lines=50 columns=150
source $VIMRUNTIME/mswin.vim

" Paste with middle mouse click
vmap <LeftRelease> "*ygv

" Paste with <Shift> + <Insert>
imap <S-Insert> <C-R>*

set encoding=utf-8
behave mswin
"
"set sessionoptions+=resize,winpos,winsize,blank,buffers,curdir,folds,help,options,tabpages
" set sessionoptions+=resize,winpos
" autocmd VIMEnter * :source $VIMRUNTIME/session.vim
" autocmd VIMLeave * :mksession! $VIMRUNTIME/session.vim
"


