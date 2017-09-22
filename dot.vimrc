set nocompatible
let s:completion = 'vcm'

" Disable some built-in plugins that I never use.
let g:loaded_2html_plugin = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_logipat = 1
let g:loaded_netrwPlugin = 1
let g:loaded_vimballPlugin = 1


if !isdirectory(expand('~/.vim/bundle/vim-plug'))
	!mkdir -p ~/.vim/bundle && git clone https://github.com/junegunn/vim-plug ~/.vim/bundle/vim-plug
endif
source ~/.vim/bundle/vim-plug/plug.vim

function! s:plug_local(repo, path, ...)
	if a:0 > 1
		echohl ErrorMsg
		echom '[plug-local] Invalid number of arguments (2..3)'
		echohl None
		return
	endif

	let plugname = fnamemodify(a:repo, ':t')
	let dirname = fnamemodify(a:path, ':t')
	if dirname !=# plugname
		echohl ErrorMsg
		echom '[plug-local] Plugin names do not match: '.plugname.' / '.dirname
		echohl None
		return
	endif

	let opts = len(a:000) > 0 ? a:1 : {}
	let path = fnamemodify(a:path, ':p')
	if isdirectory(path)
		" Ensure that local plugins are always marked as frozen.
		let opts.frozen = 1
		call plug#(path, opts)
	else
		call plug#(a:repo, opts)
	endif
endfunction
command! -nargs=+ -bar PlugLocal call s:plug_local(<args>)

function! s:tap(name)
	return has_key(g:plugs, a:name)
endfunction


augroup vimrc
    autocmd!
augroup END

call plug#begin('~/.vim/bundle')
if !has('nvim')
	Plug 'tpope/vim-sensible'
	Plug 'ConradIrwin/vim-bracketed-paste'
endif

Plug 'junegunn/vim-plug'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'sgur/vim-editorconfig'
Plug 'aperezdc/vim-elrond'
PlugLocal 'aperezdc/vim-lining', '~/devel/vim-lining'
PlugLocal 'aperezdc/vim-template', '~/devel/vim-template'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'romainl/vim-qf'
Plug 'romainl/vim-qlist'
Plug 'justinmk/vim-dirvish'
Plug 'yssl/QFEnter'
Plug 'pbrisbin/vim-mkdir'
Plug 'vim-scripts/a.vim'
Plug 'jamessan/vim-gnupg'
Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' }
Plug 'mhinz/vim-grepper'
Plug 'vim-scripts/indentpython'
Plug 'docunext/closetag.vim'
PlugLocal 'aperezdc/hipack-vim', '~/devel/hipack-vim'
Plug 'wting/rust.vim'
Plug 'vmchale/ion-vim'
Plug 'cespare/vim-toml'
Plug 'ledger/vim-ledger'
Plug 'vim-pandoc/vim-pandoc' | Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'Shougo/echodoc.vim'

if !has('nvim') && v:version < 800 && s:completion !=# 'lift' && s:completion !=# 'mu'
	let s:completion = 'lift'
endif

if s:completion ==# 'lsp'
	Plug 'prabirshrestha/asyncomplete.vim'
	Plug 'prabirshrestha/asyncomplete-buffer.vim'
	Plug 'yami-beta/asyncomplete-omni.vim'
	Plug 'Shougo/neco-syntax' | Plug 'prabirshrestha/asyncomplete-necosyntax.vim'
	Plug 'Shougo/neco-vim' | Plug 'prabirshrestha/asyncomplete-necovim.vim'
	Plug 'prabirshrestha/async.vim'
	Plug 'prabirshrestha/vim-lsp'
	Plug 'prabirshrestha/asyncomplete-lsp.vim'
elseif s:completion ==# 'vcm'
    Plug 'ajh17/vimcompletesme'
elseif s:completion ==# 'lift'
	PlugLocal 'aperezdc/vim-lift', '~/devel/vim-lift'
elseif s:completion ==# 'mu'
	Plug 'lifepillar/vim-mucomplete'
endif

if s:completion !=# 'lsp' && has('nvim')
	Plug 'autozimu/LanguageClient-neovim'
endif

call plug#end()

" Options
set nobomb
set exrc
set secure
set hidden
set incsearch
set nohlsearch
set ignorecase
set smartcase
set noinfercase
set linebreak
set tabstop=4
set shiftwidth=4
set textwidth=78
set colorcolumn=81
set encoding=utf-8
set titlelen=0
set titlestring=[%t]%m
set scrolloff=3
set sidescroll=5
set nowrap
set whichwrap+=[,],<,>
set wildignore+=*.o,*.a,a.out
set sessionoptions+=options
set completeopt+=menu,menuone,noselect,longest
set complete-=t
set shortmess+=c
set belloff+=ctrlg
set synmaxcol=250
set timeout           " for mappings
set timeoutlen=1000   " default value
set ttimeout          " for key codes
set ttimeoutlen=10    " unnoticeable small value

" Persistent undo!
if !isdirectory(expand('~/.cache/vim/undo'))
    call system('mkdir -p ' . shellescape(expand('~/.cache/vim/undo')))
endif
set undodir=~/.cache/vim/undo
set undofile

if len($DISPLAY)
    set clipboard+=unnamed
endif

filetype indent plugin on
syntax on

augroup vimrc
    autocmd!
augroup END

if s:tap('vim-elrond')
	colorscheme elrond
else
	colorscheme elflord
endif

if executable('rg')
    set grepprg=rg\ --vimgrep
endif

function! s:StripTrailingWhitespace()
    if !&binary && &filetype != 'diff'
	let l = line('.')
	let c = col('.')
	%s/\s\+$//e
	call cursor(l, c)
    endif
endfunction

command! -bar StripTrailingWhitespace silent call <SID>StripTrailingWhitespace()

if &term =~# '^screen' || &term =~# '^tmux'
    map  <silent> [1;5D <C-Left>
    map  <silent> [1;5C <C-Right>
    lmap <silent> [1;5D <C-Left>
    lmap <silent> [1;5C <C-Right>
    imap <silent> [1;5D <C-Left>
    imap <silent> [1;5C <C-Right>

    set t_ts=k
    set t_fs=\
    set t_Co=16
endif

" For some reason Vim does not recognize these sequences, so we need to
" map them manually. Ugh.
if !has('nvim')
	map  <silent> [1;3D <M-Left>
	map  <silent> [1;3C <M-Right>
	map  <silent> [1;3A <M-Up>
	map  <silent> [1;3B <M-Down>
	lmap <silent> [1;3D <M-Left>
	lmap <silent> [1;3C <M-Right>
	lmap <silent> [1;3A <M-Up>
	lmap <silent> [1;3B <M-Down>
endif

if $TERM =~ "tmux-256color" || $TERM =~ "xterm-256color" || $TERM =~ "screen-256color" || $TERM =~ "xterm-termite" || $TERM =~ "gnome-256color" || $COLORTERM =~ "gnome-terminal"
    set t_Co=256
    set t_AB=[48;5;%dm
    set t_AF=[38;5;%dm
    set t_ZH=[3m
    set t_ZR=[23m
else
    if $TERM =~ "st-256color"
        set t_Co=256
    endif
endif

" Configure Vim I-beam/underline cursor for insert/replace mode.
" From http://vim.wikia.com/wiki/Change_cursor_shape_in_different_modes
if !has('nvim')
	if empty($TMUX)
		let &t_SI = "\<Esc>[6 q"
		let &t_SR = "\<Esc>[4 q"
		let &t_EI = "\<Esc>[2 q"
	else
		let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>[6 q\<Esc>\\"
		let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>[4 q\<Esc>\\"
		let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>[2 q\<Esc>\\"
	endif
endif

if has('multi_byte') && &encoding ==# 'utf-8'
	autocmd vimrc InsertEnter * set listchars-=trail:⣿
	autocmd vimrc InsertLeave * set listchars+=trail:⣿
else
	autocmd vimrc InsertEnter * set listchars-=trail:·
	autocmd vimrc InsertLeave * set listchars+=trail:·
endif

" Dynamically enable/disable cursorline for the active window only.
" if &t_Co >= 256
" 	autocmd vimrc InsertLeave,WinEnter * set cursorline
" 	autocmd vimrc InsertEnter,WinLeave * set nocursorline
" endif

command! -nargs=0 -bang Q q<bang>
command! -nargs=0 -bang W w<bang>
command! -nargs=0 -bang Wq wq<bang>

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
vnoremap < <gv
vnoremap > >gv

nnoremap H :bprevious<CR>
nnoremap L :bnext<CR>

map <C-t> <C-]>
map <C-p> :pop<cr>
map __ ZZ
map <Space> /

" Do not close the window/split when deleting a buffer.
if s:tap('vim-sayonara')
	map <silent> <leader>q :Sayonara!<CR>
	map <silent> <leader>Q :Sayonara<CR>
	nnoremap gS :Sayonara!<CR>
	nnoremap gs :Sayonara<CR>
	cnoremap :q :Sayonara
else
	" See https://stackoverflow.com/questions/1444322/how-can-i-close-a-buffer-without-closing-the-window#8585343
	map <leader>q :bp<bar>sp<bar>bn<bar>bd<CR>
endif

" Always make n/N search forward/backwar, regardless of the last search type.
" From https://github.com/mhinz/vim-galore
nnoremap <expr> n 'Nn'[v:searchforward]
nnoremap <expr> N 'nN'[v:searchforward]

" Make <C-n> and <C-p> respect already-typed content in command mode.
" From https://github.com/mhinz/vim-galore
cnoremap <c-n> <down>
cnoremap <c-p> <up>

" Jump to the last edited position in the file being loaded (if available)
autocmd vimrc BufReadPost *
	    \ if line("'\"") > 0 && line("'\"") <= line("$") |
	    \		execute "normal g'\"" |
	    \ endif

" Readjust split-windows when Vim is resized
autocmd vimrc VimResized * :wincmd =

" Per-filetype settings
autocmd vimrc FileType mkdc,markdown setlocal expandtab tabstop=2 shiftwidth=2
autocmd vimrc FileType yaml setlocal tabstop=2 shiftwidth=2 expandtab
autocmd vimrc FileType objc setlocal expandtab cinoptions+=(0
autocmd vimrc FileType cpp setlocal expandtab cinoptions+=(0
autocmd vimrc FileType lua setlocal expandtab tabstop=3 shiftwidth=3
autocmd vimrc FileType c setlocal expandtab cinoptions+=(0
autocmd vimrc FileType d setlocal expandtab cinoptions+=(0

autocmd vimrc FileType dirvish call fugitive#detect(@%)
autocmd vimrc FileType dirvish keeppatterns g@\v/\.[^\/]+/?$@d

autocmd vimrc FileType help wincmd L
autocmd vimrc FileType git wincmd L | wincmd x
" Open location/quickfix window whenever a command is executed and the
" list gets populated with at least one valid location.
autocmd vimrc QuickFixCmdPost [^l]* cwindow
autocmd vimrc QuickFixCmdPost    l* lwindow

" Make . work with visually selected lines
vnoremap . :norm.<cr>

" Make <C-u> and <C-w> generate new undolist entries.
" Tip from: http://vim.wikia.com/wiki/Recover_from_accidental_Ctrl-U
inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>

" Alt+{arrow} for window movements
nnoremap <silent> <M-Left>  <C-w><C-h>
nnoremap <silent> <M-Down>  <C-w><C-j>
nnoremap <silent> <M-Up>    <C-w><C-k>
nnoremap <silent> <M-Right> <C-w><C-l>

" Manually re-format a paragraph of text
nnoremap <silent> Q gwip

" Forgot root?
if executable('doas')
    cmap w!! w !doas tee % > /dev/null
elseif executable('sudo')
    cmap w!! w !sudo tee % > /dev/null
endif

" In NeoVim, make it easier to use :terminal
if has('nvim')
    " Entering/Leaving terminal buffers changes from/to insert mode automatically.
    autocmd vimrc BufEnter term://* startinsert
    autocmd vimrc BufLeave term://* stopinsert

    " Allow using Alt+{arrow} to navigate *also* out from terminal buffers.
    tnoremap <silent> <M-Left>  <C-\><C-n><C-w><C-h>
    tnoremap <silent> <M-Down>  <C-\><C-n><C-w><C-j>
    tnoremap <silent> <M-Up>    <C-\><C-n><C-w><C-k>
    tnoremap <silent> <M-Right> <C-\><C-n><C-w><C-l>
endif

let g:email = 'aperez@igalia.com'
let g:user  = 'Adrian Perez'

" Plugin: fzf
if s:tap('fzf.vim')
	nnoremap <silent> <Leader>f :<C-u>Files<cr>
	nnoremap <silent> <Leader>F :<C-u>GitFiles<cr>
	nnoremap <silent> <Leader>m :<C-u>History<cr>
	nnoremap <silent> <Leader>b :<C-u>Buffers<cr>
	nnoremap <silent> <Leader><F1> :<C-u>Helptags<cr>
	nnoremap <silent> <F12> :<C-u>Buffers<cr>

	nmap <C-A-p> <leader>f
	nmap <C-A-m> <leader>m
	nmap <C-A-b> <leader>b
endif

" Plugin: qf
if s:tap('vim-qf')
	nmap <F5>   <Plug>QfSwitch
	nmap <F6>   <Plug>QfCtoggle
	nmap <F7>   <Plug>QfCprevious
	nmap <F8>   <Plug>QfCnext
	nmap <C-F6> <Plug>QfLtoggle
	nmap <C-F7> <Plug>QfLprevious
	nmap <C-F8> <Plug>QfLnext
endif

" Plugin: EditorConfig
if s:tap('vim-editorconfig')
	let g:editorconfig_blacklist = {
				\   'filetype': [ 'git.*', 'fugitive' ]
				\ }
endif

" Plugin: Lift
if s:tap('vim-lift')
    inoremap <expr> <Tab>  lift#trigger_completion()
    inoremap <expr> <Esc>  pumvisible() ? "\<C-e>" : "\<Esc>"
    inoremap <expr> <CR>   pumvisible() ? "\<C-y>" : "\<CR>"
    inoremap <expr> <Down> pumvisible() ? "\<C-n>" : "\<Down>"
    inoremap <expr> <Up>   pumvisible() ? "\<C-p>" : "\<Up>"
    inoremap <expr> <C-d>  pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
    inoremap <expr> <C-u>  pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"
endif

" Plugin: mucomplete
if s:tap('vim-mucomplete')
	set completeopt+=menuone,noinsert

	let g:mucomplete#buffer_relative_paths = 1
	let g:mucomplete#enable_auto_at_startup = 1

	inoremap <expr> <C-e> mucomplete#popup_exit("\<C-e>")
	inoremap <expr> <C-y> mucomplete#popup_exit("\<C-y>")
	inoremap <expr>  <CR> mucomplete#popup_exit("\<CR>")

	" Disable include completion and chain it from mucomplete
	set complete-=i

	let g:mucomplete#chains = {
				\   'default': ['user', 'omni', 'keyn', 'c-n', 'path'],
				\   'vim': ['path', 'cmd', 'keyn'],
				\ }
	let g:mucomplete#chains.c = g:mucomplete#chains.default
	call add(g:mucomplete#chains.c, 'incl')
	call add(g:mucomplete#chains.c, 'defs')
	let g:mucomplete#chains.cpp = g:mucomplete#chains.c
endif

" Plugin: asyncomplete
if s:tap('asyncomplete.vim')
	let g:asyncomplete_auto_popup = 1

	function s:check_backspace() abort
		let ccc = col('.')
		return !ccc || getline('.')[ccc-1] =~ '\s'
	endfunction

	inoremap <silent><expr> <Tab>
				\ pumvisible() ? "\<C-n>" :
				\ <sid>check_backspace() ? "\<Tab>" :
				\ asyncomplete#force_refresh()
	inoremap <expr> <S-Tab>
				\ pumvisible() ? "\<C-p>" : "\<C-h>"

	if s:tap('asyncomplete-buffer.vim')
		autocmd vimrc User asyncomplete_setup
					\ call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
					\ 'name': 'buffer',
					\ 'priority': 10,
					\ 'whitelist': ['*'],
					\ 'blacklist': [],
					\ 'completor': function('asyncomplete#sources#buffer#completor'),
					\ }))
	endif
	if s:tap('asyncomplete-necovim.vim')
		autocmd vimrc User asyncomplete_setup
					\ call asyncomplete#register_source(asyncomplete#sources#necovim#get_source_options({
					\ 'name': 'necovim',
					\ 'priority': 30,
					\ 'whitelist': ['vim'],
					\ 'completor': function('asyncomplete#sources#necovim#completor'),
					\ }))
	endif
	if s:tap('asyncomplete-omni.vim')
		autocmd vimrc User asyncomplete_setup
					\ call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
					\ 'name': 'omni',
					\ 'priority': 20,
					\ 'whitelist': ['*'],
					\ 'completor': function('asyncomplete#sources#omni#completor')
					\ }))
	endif
	if s:tap('asyncomplete-necosyntax.vim')
		autocmd vimrc User asyncomplete_setup
					\ call asyncomplete#register_source(asyncomplete#sources#necosyntax#get_source_options({
					\ 'name': 'necosyntax',
					\ 'whitelist': ['*'],
					\ 'completor': function('asyncomplete#sources#necosyntax#completor'),
					\ }))
	endif
endif

" Plugin: Grepper
if s:tap('vim-grepper')
	let g:grepper = {
				\   'tools': ['rg', 'git', 'grep'],
				\   'simple_prompt': 1
				\ }
	nmap gs  <Plug>(GrepperOperator)
	xmap gs  <Plug>(GrepperOperator)
	nnoremap <leader>* :Grepper -tool rg -cword -noprompt<cr>
	nnoremap <leader>g :Grepper -tool rg<cr>
	nnoremap <leader>G :Grepper -tool git<cr>
endif


" Plugin: vim-lsp
if s:tap('vim-lsp')
	" let g:lsp_log_file = '/tmp/aperez-vim-lsp.log'
	let g:lsp_log_file = ''
	let g:lsp_async_completion = 1

	if executable('pyls')
					" \ 'root_uri': { server_info->lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'setup.py') },
		autocmd vimrc User lsp_setup call lsp#register_server({
					\ 'name': 'pyls',
					\ 'cmd': { server_info->['pyls'] },
					\ 'whitelist': ['python'],
					\ })
		autocmd vimrc FileType python setlocal omnifunc=lsp#complete
	endif

	if executable('rls') && executable('rustup')
					" \ 'root_uri': { server_info->lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'Cargo.toml') },
		let $RUST_SRC_PATH = fnamemodify(system('rustup run nightly rustup which cargo'), ':h:h')
					\ . '/lib/rustlib/src/rust/src'
		autocmd vimrc User lsp_setup call lsp#register_server({
					\ 'name': 'rls',
					\ 'cmd': { server_info->['rustup', 'run', 'nightly', 'rls'] },
					\ 'whitelist': ['rust'],
					\ })
		autocmd vimrc FileType rust setlocal omnifunc=lsp#complete
	endif

	if executable('clangd')
					" \ 'root_uri': { server_info->lsp#utils#find_nearest_parent_directory(lsp#utils#get_buffer_path(), '.git') },
		autocmd vimrc User lsp_setup call lsp#register_server({
					\ 'name': 'clangd',
					\ 'cmd': { server_info->['clangd'] },
					\ 'whitelist': ['c', 'cpp'],
					\ })
		autocmd vimrc FileType c,cpp setlocal omnifunc=lsp#complete
	endif

	" https://github.com/Alloyed/lua-lsp
	if executable('lua-lsp')
		autocmd vimrc User lsp_setup call lsp#register_server({
					\ 'name': 'lualsp',
					\ 'cmd': { server_info->['lua-lsp'] },
					\ 'root_uri': { server_info->lsp#utils#find_nearest_parent_directory(lsp#utils#get_buffer_path(), '.git') },
					\ 'whitelist': ['lua'],
					\ })
		autocmd vimrc FileType lua setlocal omnifunc=lsp#complete
	endif
endif


if s:tap('nvim-langserver-shim')
	let g:langserver_executables = {}
	if executable('clangd')
		let g:langserver_executables.c = {
					\ 'name': 'clangd',
					\ 'cmd': ['clangd'],
					\ }
		let g:langserver_executables.cpp = g:langserver_executables.c
	endif
	if executable('lua-lsp')
		let g:langserver_executables.lua = {
					\ 'name': 'lua-lsp',
					\ 'cmd': ['lua-lsp'],
					\ }
	endif
	if executable('rls') && executable('rustup')
		let g:langserver_executables.rust = {
					\ 'name': 'rls',
					\ 'cmd': ['rustup', 'run', 'nightly', 'rls'],
					\ }
	endif
endif


" Plugin: LanguageClient-neovim
if s:tap('LanguageClient-neovim')
	let g:LanguageClient_autoStart = 1
	let g:LanguageClient_serverCommands = {}
	if executable('rls') && executable('rustup')
		let g:LanguageClient_serverCommands.rust =
					\ ['rustup', 'run', 'nightly', 'rls']
		autocmd vimrc FileType rust setlocal
					\ omnifunc=LanguageClient#complete
					\ signcolumn=yes
	endif
	if executable('clangd')
		let g:LanguageClient_serverCommands.c = ['clangd']
		let g:LanguageClient_serverCommands.cpp = ['clangd']
		autocmd vimrc FileType c,cpp setlocal
					\ omnifunc=LanguageClient#complete
					\ signcolumn=yes
	endif
	if executable('lua-lsp')
		let g:LanguageClient_serverCommands.lua = ['lua-lsp']
		autocmd vimrc FileType lua setlocal
					\ omnifunc=LanguageClient#complete
					\ signcolumn=yes
	endif
endif

if s:tap('echodoc.vim')
	let g:echodoc#enable_at_startup = 1
	if s:tap('vim-lining')
		let g:lining#showmode = 0
	endif
	set noshowmode
endif


" Plugin: pandoc
if s:tap('vim-pandoc')
	function! PandocXdgOpen(file)
		return 'xdg-open ' . shellescape(expand(a:file, ':p'))
	endfunction

	let g:pandoc#command#custom_open = 'PandocXdgOpen'
	let g:pandoc#command#latex_engine = 'pdflatex'
	let g:pandoc#keyboard#sections#header_style = 's'
	let g:pandoc#keyboard#wrap_cursor = 1
	let g:pandoc#folding#level = 1
endif
