
if &compatible
	set nocompatible
endif

packadd minpac

function! Install()
	call minpac#add('airblade/vim-gitgutter')
	call minpac#add('arcticicestudio/nord-vim')
	call minpac#add('direnv/direnv.vim')
	call minpac#add('dense-analysis/ale')
	call minpac#add('editorconfig/editorconfig-vim')
	call minpac#add('farmergreg/vim-lastplace')
	call minpac#add('fladson/vim-kitty')
	call minpac#add('nanotech/jellybeans.vim')
	call minpac#add('mattn/vim-gomod')
	call minpac#add('mcchrish/nnn.vim')
	call minpac#add('michaeljsmith/vim-indent-object')
	call minpac#add('sbdchd/neoformat')
	call minpac#add('prabirshrestha/asyncomplete.vim')
	call minpac#add('rickhowe/diffchar.vim')
	call minpac#add('tpope/vim-commentary')
	call minpac#add('tpope/vim-eunuch')
	call minpac#add('tpope/vim-fugitive')
	call minpac#add('tpope/vim-repeat')
	call minpac#add('tpope/vim-sleuth')
	call minpac#add('tpope/vim-surround')
	call minpac#add('vim-airline/vim-airline')
	call minpac#add('vim-airline/vim-airline-themes')
	call minpac#add('zigford/vim-powershell')
	call minpac#add('k-takata/minpac', { 'type': 'opt' })
endfunction

if exists('g:loaded_minpac')
	call minpac#init({
		\   'package_name': 'plugins',
		\ })
	call Install()
endif

set hidden
set autowrite
set nobackup nowritebackup
set splitbelow splitright
set modeline modelines=5
set belloff=all
set mouse=a

set nowrap number list ruler noshowmode
set autoindent smarttab
set completeopt=menu,noinsert
set listchars=trail:·,tab:→\ ,extends:>,precedes:<,nbsp:␣
set foldmethod=marker
set shortmess+=ac
set guifont=JetBrains\ Mono:h11
filetype plugin indent on

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:asyncomplete_auto_popup = 0
let g:ale_go_golangci_lint_package = 1
let g:ale_go_golangci_lint_options = ''
let g:ale_java_eclipselsp_config_path = '/home/nv/.config/jdtls'
let g:ale_java_eclipselsp_workspace_path = '/home/nv/src'
let g:ale_java_javalsp_executable = '/usr/local/bin/java-language-server'
let g:ale_sh_shfmt_options = ''
let g:shfmt_opt = ''
let g:ale_linters = {
	\   'c': ['clangd', 'clang'],
	\   'go': ['gopls', 'gobuild', 'govet', 'golangci-lint'],
	\   'rust': ['analyzer'],
	\   'python': ['pylsp', 'mypy'],
	\   'typescript': ['cspell', '_deno', 'eslint', 'standard', 'tslint', 'tsserver', 'typecheck', 'xo'],
	\ }
let g:ale_fixers = {
	\   'go': ['goimports'],
	\   'markdown': ['prettier'],
	\   'rust': ['rustfmt'],
	\   'sh': ['shfmt'],
	\ }
let g:rust_analyzer_config = {
	\   'rust-analyzer.cargo.features': 'all',
	\   'rust-analyzer.checkOnSave.features': 'all',
	\ }
let g:jellybeans_use_term_italics = 1
let g:nnn#set_default_mappings = 0
let g:loaded_netrwPlugin = 1

augroup nord-theme-overrides
	autocmd!
	autocmd ColorScheme nord highlight Normal guibg=#151515
	autocmd ColorScheme nord highlight NonText guibg=#151515
augroup END

set termguicolors
syntax on
color nord

augroup vimrc
	autocmd!
	autocmd BufEnter go.mod setl ft=gomod
	autocmd StdinReadPre * let s:std_in=1
	autocmd BufWritePre *.go,*.rs undojoin | Neoformat
	autocmd VimEnter *
		\ if exists('s:stdin') || !exists(':NnnExplorer') |
		\ elseif isdirectory(@%) |
		\   call nnn#explorer(@%, { 'layout': 'silent' }) |
		\ endif
		" \ elseif @% == '' |
		" \   call nnn#explorer('.', { 'layout': 'silent' }) |
augroup END

command! Update call minpac#update()
command! Clean  call minpac#clean()
command! Status call minpac#status()

" asyncomplete.vim setup autocmd {{{
augroup asyncomplete_setup
	autocmd!
	autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#ale#get_source_options({
		\   'priority': 10,
		\ }))
augroup END
" }}}

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

nnoremap <C-G> 11<C-G>
nnoremap <silent> <Return> :nohlsearch<Return><Return>

cabbrev W w
cabbrev Wq wq
cabbrev WQ wq
cabbrev Wqa wqa
cabbrev WQa wqa
cabbrev WQA wqa
cabbrev make !make
nmap <silent> q :quit<Return>
nmap <silent> <Leader>m :make<Return>
nmap <silent> <Leader>f :Neoformat<Return>
nmap <silent> <Leader>nnn :NnnPicker<CR>
nmap <silent> <Leader>nnd :NnnPicker %:p:h<CR>

nmap <silent> <Leader>s :split<CR>
nmap <silent> <Leader>v :vsplit<CR>

nmap <Leader>af <Plug>(ale_fix)
nmap <Leader>al <Plug>(ale_lint)
nmap <Leader>ah <Plug>(ale_hover)
nmap <Leader>ar <Plug>(ale_rename)
nmap <Leader>an <Plug>(ale_next_wrap)
nmap <Leader>ap <Plug>(ale_prev_wrap)
nmap <Leader>aa <Plug>(ale_code_action)
nmap <Leader>ad <Plug>(ale_go_to_definition)
nmap <Leader>at <Plug>(ale_go_to_type_definition)

nmap <Leader>1 <Plug>AirlineSelectTab1
nmap <Leader>2 <Plug>AirlineSelectTab2
nmap <Leader>3 <Plug>AirlineSelectTab3
nmap <Leader>4 <Plug>AirlineSelectTab4
nmap <Leader>5 <Plug>AirlineSelectTab5
nmap <Leader>6 <Plug>AirlineSelectTab6
nmap <Leader>7 <Plug>AirlineSelectTab7
nmap <Leader>8 <Plug>AirlineSelectTab8
nmap <Leader>9 <Plug>AirlineSelectTab9
nmap <Leader>- <Plug>AirlineSelectPrevTab
nmap <Leader>+ <Plug>AirlineSelectNextTab

