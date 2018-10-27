" vim:foldmethod=marker:

set nocompatible

" Disable some built-in plug-ins which I never use.
let g:loaded_2html_plugin = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_logipat = 1
let g:loaded_vimballPlugin = 1

augroup vimrc
	autocmd!
augroup END

iabbrev :shrug: ¯\_(ツ)_/¯
iabbrev :tableflip: (╯°□°）╯彡┻━┻


" Section: Plugins  {{{1
source ~/.vim/plugx.vim

PluginBegin
if !has('nvim')
	Plugin 'tpope/vim-sensible'
	Plugin 'ConradIrwin/vim-bracketed-paste'
endif
Plugin 'aperezdc/vim-elrond', '~/devel/vim-elrond'
Plugin 'aperezdc/vim-lining', '~/devel/vim-lining'
Plugin 'aperezdc/vim-template', '~/devel/vim-template'
" Plugin 'aperezdc/vim-lift', '~/devel/vim-lift'
if has('nvim')
	Plugin 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
	Plugin 'Shougo/deoplete.nvim'
	Plugin 'roxma/nvim-yarp'
	Plugin 'roxma/vim-hug-neovim-rpc'
endif
Plugin 'wellle/tmux-complete.vim'
Plugin 'zchee/deoplete-zsh'
Plugin 'Shougo/neco-vim'
Plugin 'bounceme/remote-viewer'
Plugin 'docunext/closetag.vim', { 'for': ['html', 'xml'] }
Plugin 'fcpg/vim-shore'
if executable('fzf')
	Plugin 'junegunn/fzf'
else
	Plugin 'junegunn/fzf', { 'do': './install --all' }
endif
" Plugin 'natebosch/vim-lsc'
if has('nvim') && (executable('rustup') || executable('cargo'))
	Plugin 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'make release' }
endif
Plugin 'junegunn/fzf.vim'
Plugin 'justinmk/vim-dirvish'
Plugin 'ledger/vim-ledger'
Plugin 'mhinz/vim-grepper'
Plugin 'pbrisbin/vim-mkdir'
Plugin 'romainl/vim-qf'
Plugin 'romainl/vim-qlist'
Plugin 'sgur/vim-editorconfig'
Plugin 'sheerun/vim-polyglot'
Plugin 'tmux-plugins/vim-tmux'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-eunuch'
Plugin 'tpope/vim-fugitive'
" Plugin 'unblevable/quick-scope'
Plugin 'vim-scripts/a.vim'
Plugin 'wellle/visual-split.vim'
Plugin 'vim-pandoc/vim-pandoc-syntax'
Plugin 'yssl/QFEnter'
PluginEnd  " 1}}}

" Section: Options  {{{1
set complete=.,w,b,u,i,d,t
set completeopt-=preview
set completeopt-=menuone
set completeopt+=longest
set shiftwidth=4
set tabstop=4
set nobomb
set exrc
set hidden
set incsearch
set smartcase
set ignorecase
set noinfercase
set nohlsearch
set linebreak
set textwidth=78
set colorcolumn=81
set encoding=utf-8
set scrolloff=3
set sidescrolloff=5
set nowrap
set whichwrap+=[,],<,>                                                                                                                                                                
set wildignore+=*.o,*.a,a.out                                                    
set shortmess+=c
" set showmode
" set statusline=%<\ %f\ %m%r%y%w%=\ L:\ \%l\/\%L\ C:\ \%c\ 
set ruler
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

filetype indent plugin on
syntax on

if executable('rg')
	set grepprg=rg\ --vimgrep
endif
" 1}}}

inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

if Have('vim-elrond')
	colorscheme elrond
else
	colorscheme elflord
endif


" Section: Terminal shenanigans  {{{1
if &term =~# '^screen' || &term =~# '^tmux' || &term ==# 'linux'
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
" 1}}}

" Section: Mappings  {{{1
" Cannot live without these.
command! -nargs=0 -bang Q q<bang>
command! -nargs=0 -bang W w<bang>
command! -nargs=0 -bang Wq wq<bang>
command! -nargs=0 B b#

" Convenience mappings.
map <C-t> <C-]>
map <C-p> :pop<cr>
map <Space> /

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
vnoremap < <gv
vnoremap > >gv

nnoremap H :bprevious<CR>
nnoremap L :bnext<CR>

" Manually re-format a paragraph of text
nnoremap <silent> Q gwip

" See https://stackoverflow.com/questions/1444322/how-can-i-close-a-buffer-without-closing-the-window#8585343
map <silent> <leader>q :bp<bar>sp<bar>bn<bar>bd<CR>

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
	\       execute "normal g'\"" |
	\ endif

" Make it easier to use :terminal
if exists(':terminal')
    " Entering/Leaving terminal buffers changes from/to insert mode automatically.
    autocmd vimrc BufEnter term://* startinsert
    autocmd vimrc BufLeave term://* stopinsert

    " Allow using Alt+{arrow} to navigate *also* out from terminal buffers.
    tnoremap <silent> <M-Left>  <C-\><C-n><C-w><C-h>
    tnoremap <silent> <M-Down>  <C-\><C-n><C-w><C-j>
    tnoremap <silent> <M-Up>    <C-\><C-n><C-w><C-k>
    tnoremap <silent> <M-Right> <C-\><C-n><C-w><C-l>
endif
" 1}}}

" Per-filetype settings
autocmd vimrc BufReadPost Config.in setlocal filetype=kconfig
autocmd vimrc FileType mkdc,markdown setlocal expandtab tabstop=2 shiftwidth=2 conceallevel=2
autocmd vimrc FileType yaml setlocal tabstop=2 shiftwidth=2 expandtab
autocmd vimrc FileType dirvish call fugitive#detect(@%)

" Open location/quickfix window whenever a command is executed and the
" list gets populated with at least one valid location.
autocmd vimrc QuickFixCmdPost [^l]* cwindow
autocmd vimrc QuickFixCmdPost    l* lwindow

" Plugin: templates (probably others as well)  {{{1
let g:user = 'Adrian Perez de Castro'
let g:email = 'aperez@igalia.com'
" 1}}}

" Plugin: editorconfig  {{{1
let g:editorconfig_blacklist = {
	\ 	'filetype': ['git.*', 'fugitive']
	\ }
" }}}1

" Plugin: shore  {{{1
let g:shore_stayonfront = 1
" 1}}}

" Section: Fuzzy finders galore  {{{1
if Have('vim-picker')
	" Plugin: picker
	nmap <unique> <Leader>f    <Plug>PickerEdit
	nmap <unique> <Leader>b    <Plug>PickerBuffer
	nmap <unique> <Leader><F1> <Plug>PickerHelp
elseif Have('fzf.vim')
	" Plugin: fzf
	nnoremap <silent> <Leader>f :<C-u>Files<cr>
	nnoremap <silent> <Leader>F :<C-u>GitFiles<cr>
	nnoremap <silent> <Leader>m :<C-u>History<cr>
	nnoremap <silent> <Leader>b :<C-u>Buffers<cr>
	nnoremap <silent> <Leader><F1> :<C-u>Helptags<cr>
endif

nmap <C-A-p> <leader>f
nmap <C-A-m> <leader>m
nmap <C-A-b> <leader>b
nmap <F12>   <leader>b
" 1}}}

" Plugin: VimCompletesMe  {{{1
if Have('VimCompletesMe')
	if Have('vim-lift') || Have('vim-ucf')
		let b:vcm_tab_complete = 'user'
	else
		function! s:update_vcm_settings()
			if &omnifunc !=# ''
				let b:vcm_tab_complete = 'omni'
			elseif &completefunc !=# ''
				let b:vcm_tab_complete = 'user'
			elseif exists('b:vcm_tab_complete')
				unlet b:vcm_tab_complete
			endif
		endfunction
		autocmd vimrc FileType * call s:update_vcm_settings()
	endif
endif " 1}}}

" Plugin: Deoplete  {{{1
if Have('deoplete.nvim')
	let g:deoplete#enable_at_startup = v:true
	call deoplete#custom#option({
				\   'auto_complete_delay': 250,
				\   'min_pattern_length': 3,
				\   'smart_case': v:true,
				\ })

	call deoplete#custom#source('_', 'converters', ['converter_remove_paren'])

	function! s:check_back_space() abort
		let col = col('.') - 1
		return !col || getline('.')[col - 1] =~ '\s'
	endfunction

	inoremap <silent><expr> <Tab>
				\ pumvisible() ? "\<C-n>" : <sid>check_back_space() ? "\<Tab>" : deoplete#mappings#manual_complete()
	inoremap <silent><expr> <S-Tab>
				\ pumvisible() ? "\<C-p>" : "\<S-Tab>"
endif
" 1}}}

" Utilities: Language Servers support  {{{1
function! s:lsp(langs, ...)
	let aidx = 0
	while aidx < a:0
		let program = a:000[l:aidx + 0]
		let cmdlist = a:000[l:aidx + 1]
		if executable(program)
			if len(cmdlist) == 0
				let cmdlist = [program]
			endif
			for lang in a:langs
				call s:lsp_set_server(lang, cmdlist)
			endfor
			return
		endif
		let aidx += 2
	endwhile
endfunction

function! s:cmdlist_to_string(cmdlist)
	let cmd = ''
	let rest = 0
	for item in a:cmdlist
		if rest
			let cmd .= ' '
		else
			let rest = 1
		endif
		let cmd .= shellescape(item)
	endfor
	return cmd
endfunction

function! s:lsp_set_server(lang, cmd)
endfunction
" 1}}}

" Plugin: lsc  {{{1
if Have('vim-lsc')
	let g:lsc_server_commands = {}
	let g:lsc_auto_map = v:false
	let g:lsc_enable_autocomplete = v:false
	function! s:lsp_set_server(lang, cmd)
		let g:lsc_server_commands[a:lang] = {
					\   'name': a:lang,
					\   'command': s:cmdlist_to_string(a:cmd),
					\   'suppress_stderr': v:true,
					\ }
		execute 'autocmd vimrc FileType ' . a:lang .
					\ ' setlocal omnifunc=lsc#complete#complete'
	endfunction

	if Have('vim-lining')
		let s:lsc_lining_item = {}
		function s:lsc_lining_item.format(item, active)
			let status = LSCServerStatus()
			return (a:active && status !=# '') ? status : ''
		endfunction
		call lining#right(s:lsc_lining_item)
	endif
endif " 1}}}

" Plugin: LanguageClient-neovim  {{{1
if Have('LanguageClient-neovim')
	let g:LanguageClient_autoStart = v:true
	let g:LanguageClient_serverCommands = {}
	function! s:lsp_set_server(lang, cmd)
		let g:LanguageClient_serverCommands[a:lang] = a:cmd
		execute 'autocmd vimrc FileType ' . a:lang .
					\ ' setlocal omnifunc=LanguageClient#complete'
					\ ' formatexpr=LanguageClient#textDocument_rangeFormatting_sync'
	endfunction

	if Have('vim-lining')
		let s:LanguageClient_lining_item = {}
		function s:LanguageClient_lining_item.format(item, active)
			return a:active ? (LanguageClient#serverStatus() ? 'busy' : 'idle') : ''
		endfunction
		call lining#right(s:LanguageClient_lining_item)
	endif

	if Have('VimCompletesMe')
		autocmd! vimrc User LanguageClientStarted setlocal omnifunc=LanguageClient#complete | call s:update_vcm_settings()
		autocmd! vimrc User LanguageClientStopped setlocal omnifunc= | call s:update_vcm_settings()
	endif
endif " 1}}}

" Plugin: grepper  {{{1
if Have('vim-grepper')
	let s:tools = ['grep']
	if executable('git') | let s:tools = ['git'] + s:tools | endif
	if executable('rg')  | let s:tools = ['rg' ] + s:tools | endif
	let g:grepper = {
				\ 'dir': 'repo,file',
				\ 'tools': s:tools,
				\ 'simple_prompt': 1,
				\ 'quickfix': 0,
				\ }
	unlet s:tools

	nmap gs  <Plug>(GrepperOperator)
	xmap gs  <Plug>(GrepperOperator)
	nnoremap <leader>* :Grepper -tool rg -cword -noprompt<cr>
	nnoremap <leader>g :Grepper -tool rg<cr>
	nnoremap <leader>G :Grepper -tool git<cr>
endif " 1}}}

call s:lsp(['c', 'cpp', 'objc'], 'ccls', ['ccls', '--init={"cacheDirectory":"/home/aperez/.cache/ccls"}', '--log-file=/dev/null'], 'clangd', [])
" call s:lsp(['c', 'cpp'], 'clangd', [])
call s:lsp(['d'], 'serve-d', [])
call s:lsp(['lua'], 'lua-lsp', [])
call s:lsp(['python'], 'pyls', [])
call s:lsp(['rust'], 'rls', [], 'rustup', ['rustup', 'run', 'rls'])
