set nocompatible
filetype off

call plug#begin('~/vimfiles/plugged')
Plug 'altercation/vim-colors-solarized'
Plug 'junegunn/goyo.vim'
Plug 'reedes/vim-pencil'
call plug#end()

filetype plugin on
filetype indent on
syntax on
syntax enable

set backspace=indent,eol,start
set guioptions-=m
set guioptions-=T
set guioptions-=r

:imap jj <Esc>
