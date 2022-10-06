
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
set autoindent smarttab
set completeopt=menuone,noinsert
set listchars=trail:·,tab:→\ ,extends:>,precedes:<,nbsp:␣
set foldmethod=marker
set shortmess+=ac
set guifont=JetBrains\ Mono:h11
filetype plugin indent on

set omnifunc=ale#completion#OmniFunc

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:ale_go_golangci_lint_package = 1
let g:ale_go_golangci_lint_options = ''
let g:ale_java_eclipselsp_config_path = '/home/nv/.config/jdtls'
let g:ale_java_eclipselsp_workspace_path = '/home/nv/src'
let g:ale_java_javalsp_executable = '/usr/local/bin/java-language-server'
let g:ale_linters = {
	\   'c': ['clangd', 'clang'],
	\   'go': ['gopls', 'gobuild', 'govet', 'golangci-lint'],
	\   'rust': ['analyzer'],
	\   'python': ['pylsp', 'mypy'],
	\   'typescript': ['cspell', 'deno', 'eslint', 'standard', 'tslint', 'tsserver', 'typecheck', 'xo'],
	\ }
let g:ale_fixers = {
	\   'go': ['goimports'],
	\   'markdown': ['prettier'],
	\   'rust': ['rustfmt'],
	\   'sh': ['shfmt'],
	\ }
let g:jellybeans_use_term_italics = 1
let g:loaded_netrwPlugin = 1
let g:nnn#set_default_mappings = 0
let g:mucomplete#minimum_prefix_length = 0

augroup nord-theme-overrides
	autocmd!
	autocmd ColorScheme nord highlight Normal guibg=#151515
	autocmd ColorScheme nord highlight NonText guibg=#151515
augroup END

augroup vimrc
	autocmd!
	autocmd StdinReadPre * let s:stdin=1
	autocmd BufWritePre *.go,*.rs undojoin | ALEFix
	autocmd VimEnter *
		\ if exists('s:stdin') || !exists(':NnnExplorer') |
		\ elseif isdirectory(@%) |
		\   call nnn#explorer(@%, { 'layout': 'silent' }) |
		\ endif
		" \ elseif @% == '' |
		" \   call nnn#explorer('.', { 'layout': 'silent' }) |
augroup END

set termguicolors
syntax on
color nord

noremap <RightMouse> <LeftMouse>
noremap <LeftDrag> <LeftMouse>
noremap <RightDrag> <LeftMouse>
noremap <MiddleDrag> <LeftMouse>
noremap <2-LeftMouse> <NOP>
noremap <3-LeftMouse> <NOP>
noremap <4-LeftMouse> <NOP>

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
nmap <silent> <Leader>nnn :NnnPicker<Return>
nmap <silent> <Leader>nnd :NnnPicker %:p:h<Return>

nmap <silent> <Leader>s :split<Return>
nmap <silent> <Leader>v :vsplit<Return>

nmap [d <Plug>(ale_prev_wrap)
nmap ]d <Plug>(ale_next_wrap)
nmap [D <Plug>(ale_first)
nmap ]D <Plug>(ale_last)
nmap <Space>f <Plug>(ale_fix)
nmap <Space>k <Plug>(ale_hover)
nmap <Space>r <Plug>(ale_rename)
nmap <Space>a <Plug>(ale_code_action)
nmap <Space>d <Plug>(ale_go_to_definition)
nmap <Space>y <Plug>(ale_go_to_type_definition)
nmap <Space>i <Plug>(ale_go_to_implementation)

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
nmap <Leader>= <Plug>AirlineSelectNextTab
