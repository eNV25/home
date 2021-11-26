
if &compatible
	set nocompatible
endif

set hidden
set autowrite
set nobackup nowritebackup
set splitbelow splitright
set modeline modelines=5
set belloff=all
set mouse=a

set nowrap number list ruler noshowmode
set completeopt=menu,noinsert
set listchars=trail:·,tab:→\ ,extends:>,precedes:<,nbsp:␣
set foldmethod=marker
set shortmess+=ac
set autoindent smarttab
filetype plugin indent on

set termguicolors
syntax on
color jellybeans

let g:airline#extensions#tabline#enabled = 1
let g:jellybeans_use_term_italics = 1
let g:asyncomplete_auto_popup = 0
let g:ale_go_golangci_lint_package = 1
let g:ale_go_golangci_lint_options = ''
let g:ale_java_eclipselsp_path = '$HOME/.local/eclipse.jdt.ls'
let g:ale_sh_shfmt_options = ''
let g:ale_linters = {
	\   'go': ['gopls', 'golangci-lint'],
	\   'rust': ['analyzer'],
	\   'c': ['clangd'],
	\   'python': ['pylsp', 'mypy', 'black'],
	\ }
let g:ale_fixers = {
	\   'go': ['goimports'],
	\   'rust': ['rustfmt'],
	\   'markdown': ['prettier'],
	\   'sh': ['shfmt'],
	\ }

packadd minpac

function! Install()
	call minpac#add('mattn/vim-gomod')
	call minpac#add('spolu/dwm.vim')
	call minpac#add('k-takata/minpac', {'type': 'opt'})
endfunction

if exists('g:loaded_minpac')
	call minpac#init({
		\   'package_name': 'plugins',
		\ })
	call Install()
endif

" asyncomplete.vim setup ale autocmd {{{
autocmd User asyncomplete_setup call asyncomplete#register_source(
	\ asyncomplete#sources#ale#get_source_options({
		\   'priority': 10,
		\ }),
	\ )
" }}}

packloadall!

" asyncomplete.vim tab completion maps {{{
function! s:is_prev_space() abort
	let c = col('.') - 1
	return !c || getline('.')[c - 1]  =~ '\s'
endfunction
imap <C-Space> <Plug>(asyncomplete_force_refresh)
inoremap <silent><expr> <Tab> pumvisible() ? '<C-N>' : <SID>is_prev_space() ? '<Tab>' : asyncomplete#force_refresh()
inoremap <expr> <S-Tab> pumvisible() ? '<C-P>' : '<C-H>'
inoremap <expr> <Return> pumvisible() ? asyncomplete#close_popup() : '<Return>'
" }}}

" disable mouse {{{
noremap <RightMouse> <LeftMouse>
noremap <LeftDrag> <LeftMouse>
noremap <RightDrag> <LeftMouse>
noremap <MiddleDrag> <LeftMouse>
noremap <2-LeftMouse> <NOP>
noremap <3-LeftMouse> <NOP>
noremap <4-LeftMouse> <NOP>
" }}}

command! Update call minpac#update()
command! Clean  call minpac#clean()
command! Status call minpac#status()

command! TreeHide if exists(':GuiTreeviewHide') | exe 'GuiTreeviewHide' | else | NERDTreeClose | endif
command! TreeShow if exists(':GuiTreeviewShow') | exe 'GuiTreeviewShow' | else | NERDTreeFocus | endif
command! TreeToggle if exists(':GuiTreeviewToggle') | exe 'GuiTreeviewToggle' | else | NERDTreeToggle | endif

autocmd BufWritePre *.go :ALEFix
autocmd BufEnter go.mod set ft=gomod

nnoremap <C-G> 11<C-G>
nnoremap <silent> <Return> :nohlsearch<Return><Return>

nmap <silent> q :quit<Return>
nmap <silent> ts :TreeShow<Return>
nmap <silent> th :TreeHide<Return>
nmap <silent> tt :TreeToggle<Return>

cabbrev make !make
nmap <Leader>m :make<Return>
nmap <Leader>f <Plug>(ale_fix)
nmap <Leader>l <Plug>(ale_lint)
nmap <Leader>h <Plug>(ale_hover)
nmap <Leader>r <Plug>(ale_rename)
nmap <Leader>n <Plug>(ale_next_wrap)
nmap <Leader>p <Plug>(ale_prev_wrap)
nmap <Leader>a <Plug>(ale_code_action)
nmap <Leader>d <Plug>(ale_go_to_definition)
nmap <Leader>t <Plug>(ale_go_to_type_definition)
nmap <Leader>sd <Plug>(ale_go_to_definition_in_split)
nmap <Leader>vd <Plug>(ale_go_to_definition_in_vsplit)
nmap <Leader>st <Plug>(ale_go_to_type_definition_in_split)
nmap <Leader>vt <Plug>(ale_go_to_type_definition_in_vsplit)
