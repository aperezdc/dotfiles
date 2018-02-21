let s:completion = 'mu'
let s:completion_extras = 0


"------- No user-serviceable parts below -----------------------------------

set nocompatible

if !has('nvim')
	let s:completion_extras = 0  " NeoVim is needed for LanguageClient
	if v:version < 800
		let s:completion = ''    " µcomplete needs Vim8 or NeoVim
	endif
endif


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
Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }
Plug 'vim-scripts/indentpython', { 'for': 'python' }
Plug 'docunext/closetag.vim', { 'for': ['html', 'xml'] }
PlugLocal 'aperezdc/hipack-vim', '~/devel/hipack-vim'
Plug 'wting/rust.vim'
Plug 'vmchale/ion-vim'
Plug 'cespare/vim-toml'
Plug 'ledger/vim-ledger'

if s:completion ==# 'mu'
	Plug 'lifepillar/vim-mucomplete'
endif
if s:completion_extras
	Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }
	Plug 'Shougo/echodoc.vim'
endif

call plug#end()

unlet s:completion
unlet s:completion_extras


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
set lazyredraw
set nowrap
set whichwrap+=[,],<,>
set wildignore+=*.o,*.a,a.out
set wildmode=full
set sessionoptions+=options
set complete-=t
set shortmess+=c
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

if $TERM =~ "xterm-256color" || $TERM =~ "screen-256color" || $TERM =~ "xterm-termite" || $TERM =~ "gnome-256color" || $COLORTERM =~ "gnome-terminal"
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
if !has('nvim') && exists('&t_SR')
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
command! -nargs=0 B b#

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


function! s:check_backspace() abort
	let l:column = col('.') - 1
	return !l:column || getline('.')[l:column - 1] =~ '\s'
endfunction


" Plugin: mucomplete
if s:tap('vim-mucomplete')
	set completeopt+=menuone
	if v:version > 704 || (v:version == 704 && has('patch1753'))
		let g:mucomplete#enable_auto_at_startup = 0
		set completeopt+=noinsert,noselect
	else
		" Automatic completion needs support for noinsert/noselect.
		let g:mucomplete#enable_auto_at_startup = 0
	endif

	let g:mucomplete#buffer_relative_paths = 1


	" Disable include completion and chain it from mucomplete
	set complete-=i
	set shortmess+=c
	set completeopt+=longest,menuone

	let g:mucomplete#chains = {
				\   'default': ['omni', 'user', 'keyp', 'c-n', 'path'],
				\   'vim': ['path', 'cmd', 'keyn'],
				\ }
	let g:mucomplete#chains.c = g:mucomplete#chains.default
	call add(g:mucomplete#chains.c, 'incl')
	call add(g:mucomplete#chains.c, 'defs')
	let g:mucomplete#chains.cpp = g:mucomplete#chains.c
else
	" Simple fall-back to have <Tab> mapped to something sensible.
	inoremap <expr> <Tab> pumvisible() ? "\<C-p>" : <sid>check_backspace() ? "\<Tab>" : "\<C-x>\<C-p>\<C-p>"
	set completeopt+=longest,menuone
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
