set nocompatible
filetype off

call plug#begin('~/vimfiles/plugged')
Plug 'altercation/vim-colors-solarized'
Plug 'junegunn/goyo.vim'
Plug 'reedes/vim-pencil'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
call plug#end()

filetype plugin on
filetype indent on
syntax on
syntax enable

if has('gui_running')
  set background=light
  colorscheme solarized
else
  set background=dark
endif

set backspace=indent,eol,start
set guioptions-=m
set guioptions-=T
set guioptions-=r

:imap jj <Esc>
