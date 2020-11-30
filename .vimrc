" Better % matching for do...end blocks
runtime macros/matchit.vim

set nocompatible
set autochdir
filetype off

call plug#begin('~/vimfiles/plugged')
" Color scheme repo
Plug 'chriskempson/base16-vim'
" Tab formatting. :Tab /{pattern}, e.g. :Tab /=
Plug 'godlygeek/tabular'
" <C-p> file searching
Plug 'ctrlpvim/ctrlp.vim'
" Ruby utilities
Plug 'tpope/vim-rails'
Plug 'tpope/vim-bundler'

" Writing tools
Plug 'junegunn/goyo.vim'
Plug 'reedes/vim-pencil'
call plug#end()

filetype plugin on
filetype indent on
syntax on
syntax enable

if has('gui_running')
  set guifont=Hack:h10
  colorscheme base16-tomorrow-night
else
  set background=dark
endif

set backspace=indent,eol,start
set guioptions-=m
set guioptions-=T
set guioptions-=r

set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

:imap jj <Esc>
