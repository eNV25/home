
if &compatible
	set nocompatible
endif

set hidden
set autowrite
set nobackup nowritebackup
set splitbelow splitright
set belloff=all
set mouse=a
set shortmess+=ac
filetype plugin indent on

let g:jellybeans_overrides = {
	\   'background': {
	\     'ctermbg': 'NONE',
	\     '256ctermbg': 'NONE',
	\     'guibg': 'NONE',
	\   },
	\ }

syntax on
colorscheme jellybeans

noremap <RightMouse> <LeftMouse>
noremap <LeftDrag> <LeftMouse>
noremap <RightDrag> <LeftMouse>
noremap <MiddleDrag> <LeftMouse>
noremap <2-LeftMouse> <NOP>
noremap <3-LeftMouse> <NOP>
noremap <4-LeftMouse> <NOP>

nnoremap <silent> q :quit<Return>
nnoremap <C-G> 11<C-G>
nnoremap <Return> :nohlsearch<Return><Return>

" vim: ft=vim
