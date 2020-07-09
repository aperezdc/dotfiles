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
" Plugin 'wellle/tmux-complete.vim'
Plugin 'bounceme/remote-viewer'
Plugin 'docunext/closetag.vim', { 'for': ['html', 'xml'] }
Plugin 'IngoHeimbach/neco-vim'
Plugin 'fcpg/vim-shore'
if executable('fzf')
	Plugin 'junegunn/fzf'
else
	Plugin 'junegunn/fzf', { 'do': './install --all' }
endif
Plugin 'dense-analysis/ale'
Plugin 'junegunn/fzf.vim'
Plugin 'justinmk/vim-dirvish'
Plugin 'ledger/vim-ledger'
Plugin 'nelstrom/vim-visual-star-search'
Plugin 'lluchs/vim-wren'
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
Plugin 'vim-scripts/a.vim'
Plugin 'vim-pandoc/vim-pandoc-syntax'
Plugin 'yssl/QFEnter'
Plugin 'ziglang/zig.vim'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
PluginEnd  " 1}}}

" Section: Options  {{{1
set clipboard+=unnamedplus
set completeopt=menu,longest
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
set ruler
set timeout           " for mappings
set timeoutlen=1000   " default value
set ttimeout          " for key codes
set ttimeoutlen=10    " unnoticeable small value
set guicursor=

if !has('nvim')
	set ttymouse=sgr
endif

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

if Have('vim-elrond')
	colorscheme elrond
else
	colorscheme elflord
endif


" Section: Terminal shenanigans  {{{1
for mapmode in ['n', 'vnore', 'i', 'c', 'l', 't']
	execute mapmode.'map <silent> [1;5A <C-Up>'
	execute mapmode.'map <silent> [1;5B <C-Down>'
	execute mapmode.'map <silent> [1;5C <C-Right>'
	execute mapmode.'map <silent> [1;5D <C-Left>'
	execute mapmode.'map <silent> [1;3A <M-Up>'
	execute mapmode.'map <silent> [1;3B <M-Down>'
	execute mapmode.'map <silent> [1;3C <M-Right>'
	execute mapmode.'map <silent> [1;3D <M-Left>'
endfor
unlet mapmode

if &term =~# '^screen' || &term =~# '^tmux' || &term ==# 'linux'
    set t_ts=k
    set t_fs=\
    set t_Co=16
endif

if $TERM ==# 'tmux-256color' || $TERM ==# 'xterm-256color' || $TERM ==# 'screen-256color' || $TERM ==# 'xterm-termite' || $TERM ==# 'gnome-256color' || $TERM ==# 'fbterm' || $COLORTERM ==# 'gnome-terminal'
    set t_Co=256
    set t_AB=[48;5;%dm
    set t_AF=[38;5;%dm
    set t_ZH=[3m
    set t_ZR=[23m
else
    if $TERM =~# 'st-256color'
        set t_Co=256
    endif
endif

" Configure Vim I-beam/underline cursor for insert/replace mode.
" From http://vim.wikia.com/wiki/Change_cursor_shape_in_different_modes
" if !has('nvim') && exists('&t_SR')
" 	if empty($TMUX)
" 		let &t_SI = "\<Esc>[6 q"
" 		let &t_SR = "\<Esc>[4 q"
" 		let &t_EI = "\<Esc>[2 q"
" 	else
" 		let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>[6 q\<Esc>\\"
" 		let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>[4 q\<Esc>\\"
" 		let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>[2 q\<Esc>\\"
" 	endif
" endif
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
map __ ZZ

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
vnoremap < <gv
vnoremap > >gv

nnoremap H :bprevious<CR>
nnoremap L :bnext<CR>

" Highlight word below the cursor.
" https://stackoverflow.com/questions/6876850/how-to-highlight-all-occurrences-of-a-word-in-vim-on-double-clicking
nnoremap <silent> <leader>+ :execute 'highlight DoubleClick ctermbg=green ctermfg=black<bar>match DoubleClick /\V\<'.escape(expand('<cword>'), '\').'\>/'<cr>
nnoremap <silent> <leader>- :match none<cr>

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

" https://vim.fandom.com/wiki/Make_C-Left_C-Right_behave_as_in_Windows
nnoremap <C-Left>  b
nnoremap <C-Right> w
nnoremap <C-Up>    [[
nnoremap <C-Down>  ]]

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

    " Make Ctrl-Shift-q exit insert mode.
    tnoremap <silent> <C-S-q>   <C-\><C-n>
endif

" Ctrl-C does not trigger InsertLeave, remap it through Escape.
inoremap <C-c> <Esc>

" Alternate mapping for increasing/decreasing numbers.
nnoremap <S-Up>   <C-x>
nnoremap <S-Down> <C-a>

" 1}}}

" Per-filetype settings
autocmd vimrc BufReadPost,BufNewFile *.bst setlocal filetype=yaml
autocmd vimrc BufReadPost Config.in setlocal filetype=kconfig
autocmd vimrc FileType scheme setlocal tabstop=2 shiftwidth=2 expandtab
autocmd vimrc FileType meson setlocal tabstop=4 shiftwidth=4 noexpandtab
autocmd vimrc FileType yaml setlocal tabstop=2 shiftwidth=2 expandtab
autocmd vimrc FileType dirvish call FugitiveDetect(@%)
autocmd vimrc FileType help wincmd L
autocmd vimrc FileType git wincmd L | wincmd x

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

" Plugin: markdown  {{{1
if Have('vim-markdown')
	let g:vim_markdown_folding_disabled = 1
	let g:vim_markdown_override_foldtext = 0
	let g:vim_markdown_conceal_code_blocks = 0
	let g:vim_markdown_fromtmatter = 1
	let g:vim_markdown_strikethrough = 1
	let g:vim_markdown_new_list_item_indent = 2
endif " 1}}}

" Plugin: polyglot  {{{1
if Have('vim-polyglot')
	let g:polyglot_disabled = ['markdown']
endif " 1}}}

" Plugin: shore  {{{1
let g:shore_stayonfront = 1
" 1}}}

" Plugin: fzf  {{{1
if Have('fzf.vim')
	nnoremap <silent> <Leader>f :<C-u>Files<cr>
	nnoremap <silent> <Leader>F :<C-u>GitFiles<cr>
	nnoremap <silent> <Leader>m :<C-u>History<cr>
	nnoremap <silent> <Leader>b :<C-u>Buffers<cr>
	nnoremap <silent> <Leader><F1> :<C-u>Helptags<cr>
	nmap <C-A-p> <leader>f
	nmap <C-A-g> <leader>F
	nmap <C-A-m> <leader>m
	nmap <C-A-b> <leader>b
	nmap <F12>   <leader>b
endif

" 1}}}

" Tab-completion  {{{1
function! s:check_backspace() abort
	let l:column = col('.') - 1
	return !l:column || getline('.')[l:column - 1] =~# '\s'
endfunction

function! s:trigger_completion() abort
	if &omnifunc !=# ''
		let b:complete_p = 0
		return "\<C-x>\<C-o>"
	elseif &completefunc !=# ''
		let b:complete_p = 1
		return "\<C-x>\<C-u>"
	else
		let b:complete_p = 1
		return "\<C-x>\<C-p>"
	endif
endfunction

inoremap <silent><expr> <Tab>
			\ pumvisible() ? (get(b:, 'complete_p', 1) ? "\<C-p>" : "\<C-n>") :
			\ <sid>check_backspace() ? "\<Tab>" :
			\ "\<C-p>"
inoremap <silent><expr> <C-Space>
			\ <sid>trigger_completion()
inoremap <silent><expr> <CR>
			\ pumvisible() ? "\<C-y>" : "\<CR>"

inoremap <silent><expr> <S-Tab>
			\ pumvisible() ? "\<C-n>" : "\<C-h>"
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

" Plugin: ale  {{{1
if Have('ale')
	" set completeopt=menu,menuone,preview,noselect,noinsert
	let g:ale_echo_msg_format = '[%linter%] %code: %%s'
	let g:ale_completion_enabled = 0
	let g:ale_set_quickfix = 0
	let g:ale_set_loclist = 0
	let g:ale_set_balloons = 0

	let s:c_cpp_linters = ['flawfinder']
	" let s:c_cpp_linters = ['clangtidy', 'flawfinder']
	" for program in ['ccls', 'clangd', 'clang', 'gcc']
	for program in ['clangd', 'ccls', 'clang', 'gcc']
		if executable(program)
			call insert(s:c_cpp_linters, program)
			break
		endif
	endfor

	let g:ale_linters = {
				\ 'c': s:c_cpp_linters, 'cpp': s:c_cpp_linters,
				\ }
	unlet s:c_cpp_linters

	nmap <silent> <C-k>      <Plug>(ale_previous_wrap)
	nmap <silent> <C-j>      <Plug>(ale_next_wrap)
	nmap <silent> <Leader>d  <Plug>(ale_detail)
	nmap <silent> <Leader>h  <Plug>(ale_hover)
	nmap <silent> <Leader>D  <Plug>(ale_go_to_definition)
	nmap <silent> <Leader>r  <Plug>(ale_find_references)
	nmap <silent> <Leader>x  <Plug>(ale_fix)
	imap <silent> <C-Space>  <Plug>(ale_complete)

	if Have('vim-lining')
		function s:linting_done()
			let buffer = bufnr('')
			return get(g:, 'ale_enabled')
						\ && getbufvar(buffer, 'ale_linted', 0)
						\ && !ale#engine#IsCheckingBuffer(buffer)
		endfunction

		let s:ale_lining_warnings_item = {}
		function s:ale_lining_warnings_item.format(item, active)
			if a:active && s:linting_done()
				let counts = ale#statusline#Count(bufnr(''))
				let warnings = counts.total - counts.error - counts.style_error
				if warnings > 0
					return warnings
				endif
			endif
			return ''
		endfunction
		call lining#right(s:ale_lining_warnings_item, 'Warn')

		let s:ale_lining_errors_item = {}
		function s:ale_lining_errors_item.format(item, active)
			if a:active && s:linting_done()
				let counts = ale#statusline#Count(bufnr(''))
				let errors = counts.error + counts.style_error
				if errors > 0
					return errors
				endif
			endif
			return ''
		endfunction
		call lining#right(s:ale_lining_errors_item, 'Error')

		let s:ale_status_item = {}
		function s:ale_status_item.format(item, active)
			return (a:active && ale#engine#IsCheckingBuffer(bufnr(''))) ? 'linting' : ''
		endfunction
		call lining#right(s:ale_status_item)

		autocmd vimrc User ALEJobStarted call lining#refresh()
		autocmd vimrc User ALELintPost   call lining#refresh()
		autocmd vimrc User ALEFixPost    call lining#refresh()
	endif
endif " 1}}}

" Plugin: grepper  {{{1
if Have('vim-grepper')
	let s:tools = ['grep']
	if executable('git') | call insert(s:tools, 'git') | endif
	if executable('rg')  | call insert(s:tools, 'rg' ) | endif
	let g:grepper = {
				\ 'dir': 'repo,file',
				\ 'tools': s:tools,
				\ 'simple_prompt': 1,
				\ 'quickfix': 0,
				\ 'prompt_quote': 1,
				\ }
	unlet s:tools

	nmap gs  <Plug>(GrepperOperator)
	xmap gs  <Plug>(GrepperOperator)
	nnoremap <leader>* :Grepper -tool rg -cword -noprompt<cr>
	nnoremap <leader>g :Grepper -tool rg<cr>
	nnoremap <leader>G :Grepper -tool git<cr>
endif " 1}}}

" vim:foldmethod=marker:
