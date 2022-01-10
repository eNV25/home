
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
let g:asyncomplete_auto_popup = 0
let g:ale_go_golangci_lint_package = 1
let g:ale_go_golangci_lint_options = ''
let g:ale_java_eclipselsp_path = '$HOME/.local/eclipse.jdt.ls'
let g:ale_sh_shfmt_options = ''
let g:ale_linters = {
	\     'go': ['gopls', 'golangci-lint'],
	\     'rust': ['analyzer'],
	\     'c': ['clangd'],
	\     'python': ['pylsp', 'mypy', 'black'],
	\ }
let g:ale_fixers = {
	\     'go': ['goimports'],
	\     'rust': ['rustfmt'],
	\     'markdown': ['prettier'],
	\     'sh': ['shfmt'],
	\ }
let g:jellybeans_use_term_italics = 1
let g:nnn#set_default_mappings = 0
let g:loaded_netrwPlugin = 1

packadd minpac

function! Install()
	call minpac#add('mattn/vim-gomod')
	call minpac#add('spolu/dwm.vim')
	call minpac#add('mcchrish/nnn.vim')
	call minpac#add('k-takata/minpac', {'type': 'opt'})
endfunction

if exists('g:loaded_minpac')
	call minpac#init({
		\     'package_name': 'plugins',
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

autocmd BufEnter go.mod set ft=gomod
autocmd StdinReadPre * let s:std_in=1
autocmd BufWritePre *.go,*.rs if exists(':ALEFix') | ALEFix | endif
autocmd VimEnter *
	\ if @% == '' && !exists('s:std_in') && exists(':NnnExplorer') |
	\     call nnn#explorer('.', { 'layout': 'silent' }) | only |
	\ endif

nnoremap <C-G> 11<C-G>
nnoremap <silent> <Return> :nohlsearch<Return><Return>

cabbrev make !make
nmap <silent> q :quit<Return>
nmap <silent> <Leader>m :make<Return>
nmap <silent> <Leader>nnn :NnnPicker<CR>
nmap <silent> <Leader>nnd :NnnPicker %:p:h<CR>


nmap <Leader>af <Plug>(ale_fix)
nmap <Leader>al <Plug>(ale_lint)
nmap <Leader>ah <Plug>(ale_hover)
nmap <Leader>ar <Plug>(ale_rename)
nmap <Leader>an <Plug>(ale_next_wrap)
nmap <Leader>ap <Plug>(ale_prev_wrap)
nmap <Leader>aa <Plug>(ale_code_action)
nmap <Leader>ad <Plug>(ale_go_to_definition)
nmap <Leader>at <Plug>(ale_go_to_type_definition)
nmap <Leader>sd <Plug>(ale_go_to_definition_in_split)
nmap <Leader>vd <Plug>(ale_go_to_definition_in_vsplit)
nmap <Leader>st <Plug>(ale_go_to_type_definition_in_split)
nmap <Leader>vt <Plug>(ale_go_to_type_definition_in_vsplit)

