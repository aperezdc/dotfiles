
augroup vimrc
	autocmd!
augroup END

if &shell =~# 'fish$'
    set shell=sh
endif

let g:email = "aperez@igalia.com"
let g:user  = "Adrian Perez"

" To avoid mistankenly using one for the other, always point to the versioned binaries.
if has('python3')
	let g:python3_host_prog = '/usr/bin/python3'
endif
if has('python')
	let g:python_host_prog = '/usr/bin/python2'
endif

let s:plug_path = has('nvim')
			\ ? '~/.config/nvim/autoload/plug.vim'
			\ : '~/.vim/autoload/plug.vim'
let s:plug_bundle_path = has('nvim')
			\ ? '~/.config/nvim/bundle'
			\ : '~/.vim/bundle'

if empty(glob(s:plug_path))
	execute 'silent !curl -fLo ' . s:plug_path . ' --create-dirs ' .
				\ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	execute 'source ' . s:plug_path
	if has(':PlugInstall')
		PlugInstall
	else
		echom 'PlugInstall: Please close and re-open Vim'
		finish
	endif
endif

"let g:templates_directory = '~/t'

let s:completion_setup = 'neocomplete'

call plug#begin(s:plug_bundle_path)
Plug 'tpope/vim-sensible'

if s:completion_setup == 'lift'
	if empty(glob('~aperez/devel/vim-lift'))
		Plug 'aperezdc/vim-lift'
	else
		Plug '~aperez/devel/vim-lift'
	endif
	Plug 'davidhalter/jedi-vim', { 'for' : 'python' }
	Plug 'racer-rust/vim-racer', { 'for' : 'rust' }
elseif s:completion_setup == 'neocomplete'
	" Load jedi-vim before deoplete-jedi
	Plug 'racer-rust/vim-racer', { 'for' : 'rust' }

	if has('nvim')
		Plug 'Shougo/deoplete.nvim'
		Plug 'zchee/deoplete-jedi', { 'for' : 'python' } |
					\ Plug 'davidhalter/jedi-vim', { 'for' : 'python' }
	else
		Plug 'Shougo/neocomplete.vim'
	endif

	Plug 'Shougo/context_filetype.vim'
	Plug 'Shougo/neco-syntax'
	Plug 'Shougo/neco-vim'
	Plug 'Shougo/neoinclude.vim'
elseif s:completion_setup == 'vcm'
	Plug 'ajh17/vimcompletesme'
	Plug 'davidhalter/jedi-vim', { 'for' : 'python' }
	Plug 'racer-rust/vim-racer', { 'for' : 'rust' }
elseif s:completion_setup == 'ycm'
	Plug 'Valloric/YouCompleteMe', { 'do': 'python2 install.py --clang-completer --gocode-completer --system-boost --system-libclang --racer-completer' }
elseif s:completion_setup == 'simple'
	Plug 'davidhalter/jedi-vim', { 'for' : 'python' }
	Plug 'racer-rust/vim-racer', { 'for' : 'rust' }
endif

if empty(glob('~aperez/devel/vim-template'))
	Plug 'aperezdc/vim-template'
else
	Plug '~aperez/devel/vim-template'
endif
if empty(glob('~aperez/devel/vim-lining'))
	Plug 'aperezdc/vim-lining'
else
	Plug '~aperez/devel/vim-lining'
endif
if empty(glob('~aperez/devel/vim-elrond'))
	Plug 'aperezdc/vim-elrond'
else
	Plug '~aperez/devel/vim-elrond'
endif
if empty(glob('~aperez/devel/hipack-vim'))
	Plug 'aperezdc/hipack-vim'
else
	Plug '~aperez/devel/hipack-vim'
endif

if !empty(glob('~aperez/devel/urbit/extras/hoon.vim'))
	Plug '~aperez/devel/urbit/extras/hoon.vim'
endif

Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'ntpeters/vim-better-whitespace'
Plug 'chrisbra/vim-diff-enhanced'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'gcmt/wildfire.vim'
Plug 'jamessan/vim-gnupg'
Plug 'wting/rust.vim'
Plug 'dag/vim-fish'
"Plug 'lervag/vimtex'
Plug 'vim-scripts/rcshell.vim'
Plug 'vim-scripts/FastFold'
Plug 'vim-scripts/a.vim', { 'on': ['A', 'AV', 'AS'] }
Plug 'tyru/caw.vim', { 'on' : '<Plug>(caw:' }
Plug 'ledger/vim-ledger', { 'for' : 'ledger' }
Plug 'vim-scripts/gtk-vim-syntax', { 'for' : ['c', 'cpp'] }
Plug 'othree/yajs.vim', { 'for' : 'javascript' }
Plug 'othree/html5.vim'
Plug 'mustache/vim-mustache-handlebars'
Plug 'cespare/vim-toml'
Plug 'godlygeek/tabular', { 'on' : 'Tabularize' }
Plug 'reedes/vim-wordy', { 'on' : ['Wordy', 'NextWordy'] }
" Plug 'Shougo/vimproc.vim', { 'do' : 'make' } |
" 			\ Plug 'Shougo/unite.vim' |
" 			\ Plug 'Shougo/unite-outline' |
" 			\ Plug 'Shougo/neomru.vim'
Plug 'junegunn/fzf' | Plug 'junegunn/fzf.vim'
Plug 't9md/vim-quickhl', { 'on' : '<Plug>(quickhl-' }
Plug 'airblade/vim-gitgutter'
" Plug 'Valloric/ListToggle'
call plug#end()

unlet s:plug_path
unlet s:plug_bundle_path

function! s:plug_loaded(name)
	return has_key(g:, 'plugs') && has_key(g:plugs, a:name)
endfunction


" Add system-wide Vim files directory, if it exists
if isdirectory('/usr/share/vim/vimfiles')
	set runtimepath+=/usr/share/vim/vimfiles
endif

syntax on
colorscheme elrond
filetype indent plugin on

set nobomb
set smartcase
set ignorecase
set tabstop=4
set shiftwidth=4
set copyindent
set nohlsearch
set whichwrap+=[,],<,>
set nowrap
set showmode
set textwidth=78
set fileformats=unix,mac,dos
" set completeopt=longest,menu,menuone,preview,noinsert
set completeopt=menu,preview
set hidden
set infercase
set diffopt+=iwhite
set nobackup
set grepprg=ag\ --noheading\ --nocolor\ --nobreak
set secure
set exrc
set wildchar=<tab>
set encoding=utf-8
set listchars=tab:↹·,extends:⇉,precedes:⇇,nbsp:␠,trail:␠,nbsp:␣
set linebreak                   " break on what looks like boundaries
set showbreak=↳\                " shown at the start of a wrapped line

if has('nvim')
	set undodir=~/.nvim/undo
	set undofile

	" Make double Ctrl-t exit insert mode in terminals.
	tnoremap <C-t><C-t> <C-\><C-n>
else
	set viminfo+=n~/.viminfo
endif

if len($DISPLAY) > 0
	set clipboard+=unnamed
endif


if s:completion_setup == 'lift' && s:plug_loaded('vim-lift')
    let g:lift#sources = {
				\   '_': ['near', 'omni', 'user', 'syntax'],
				\   'c': ['omni', 'near'],
				\ }
	let g:lift#close_preview_window = 0
	let g:lift#shortcut_single_source = 1
	inoremap <expr><silent><Tab> lift#trigger_completion()
elseif s:completion_setup == 'vcm' && s:plug_loaded('vimcompletesme')
	set completeopt+=longest
else
	function! s:completion_check_bs()
		let l:col = col('.') - 1
		return !l:col || getline('.')[l:col - 1] =~ '\s'
	endfunction

	if s:completion_setup == 'simple'
		function! s:simple_tab_completion(prefer_user_complete)
			if pumvisible()
				return "\<C-n>"
			endif
			if s:completion_check_bs()
				return "\<Tab>"
			endif

			if a:prefer_user_complete == 0
				if len(&completefunc) > 0
					return "\<C-x>\<C-u>"
				elseif len(&omnifunc) > 0
					return "\<C-x>\<C-o>"
				endif
			else
				if len(&omnifunc) > 0
					return "\<C-x>\<C-o>"
				elseif len(&completefunc) > 0
					return "\<C-x>\<C-u>"
				endif
			endif

			return "\<C-n>"
		endfunction

		inoremap <expr> <Tab> <sid>simple_tab_completion(0)
	endif
endif


if &term =~ "screen"
	map  <silent> [1;5D <C-Left>
	map  <silent> [1;5C <C-Right>
	lmap <silent> [1;5D <C-Left>
	lmap <silent> [1;5C <C-Right>
	imap <silent> [1;5D <C-Left>
	imap <silent> [1;5C <C-Right>

	set t_ts=k
	set t_fs=\
endif

if $TERM =~ "xterm-256color" || $TERM =~ "screen-256color" || $TERM =~ "xterm-termite" || $TERM =~ "gnome-256color" || $COLORTERM =~ "gnome-terminal"
	set t_Co=256
	set t_AB=[48;5;%dm
	set t_AF=[38;5;%dm
	set cursorline
else
	if $TERM =~ "st-256color"
		set t_Co=256
		set cursorline
	endif
endif


command! -nargs=0 -bang Q q<bang>
command! -bang W write<bang>
command! -nargs=0 -bang Wq wq<bang>

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

nnoremap H :bprevious<CR>
nnoremap L :bnext<CR>

map <Space> /
map <C-t> <C-]>
map <C-p> :pop<cr>
map __ ZZ


" Jump to the last edited position in the file being loaded (if available)
autocmd vimrc BufReadPost *
			\ if line("'\"") > 0 && line("'\"") <= line("$") |
			\		execute "normal g'\"" |
			\ endif
autocmd vimrc FileType mkdc,markdown setlocal expandtab tabstop=2 shiftwidth=2
autocmd vimrc FileType yaml setlocal tabstop=2 shiftwidth=2
autocmd vimrc FileType objc setlocal expandtab cinoptions+=(0
autocmd vimrc FileType cpp setlocal expandtab cinoptions+=(0
autocmd vimrc FileType lua setlocal expandtab tabstop=3 shiftwidth=3
autocmd vimrc FileType c setlocal expandtab cinoptions+=(0
autocmd vimrc FileType d setlocal expandtab cinoptions+=(0


if exists('/usr/share/clang/clang-format.py')
	map  <C-k>      :pyf /usr/share/clang/clang-format.py<cr>
	imap <C-k> <Esc>:pyf /usr/share/clang/clang-format.py<cr>i
endif

" Plugin: GitGutter
if s:plug_loaded('vim-gitgutter')
	" let g:gitgutter_enabled = 0
	let g:gitgutter_diff_args = '-w -2'
	nmap <silent> <F8> :GitGutterToggle<cr>
	imap <silent> <F8> <Esc>:GitGutterToggle<cr>a
endif

" Plugin: caw
if s:plug_loaded('caw.vim')
	let g:caw_no_default_keymappings = 1
	nmap <leader>c <Plug>(caw:tildepos:toggle)
	xmap <leader>c <Plug>(caw:tildepos:toggle)
endif

" Plugin: better-whitespace
if s:plug_loaded('vim-better-whitespace')
	let g:better_whitespace_filetypes_blacklist = ['help', 'unite', 'qf']
endif

" Plugin: Unite
if s:plug_loaded('unite.vim')
	let g:unite_source_file_mru_limit = 350

	call unite#custom#profile('default', 'context', {
				\ 'winheight'    : 15,
				\ 'start_insert' : 1,
				\ 'no_split'     : 1,
				\ 'prompt'          : ': ',
				\ })
	call unite#filters#matcher_default#use(['matcher_fuzzy'])
	call unite#custom#source('neomru/file', 'matchers',
				\ ['matcher_project_files', 'matcher_fuzzy'])

	if has('nvim')
		nnoremap <silent> <leader>f :<C-u>Unite file_rec/neovim file/new -buffer-name=Files<cr>
	else
		nnoremap <silent> <leader>f :<C-u>Unite file_rec/async file/new -buffer-name=Files<cr>
	endif
	nnoremap <silent> <leader>d :<C-u>Unite buffer bookmark file/async -buffer-name=Files\ (misc)<cr>
	nnoremap <silent> <leader>F :<C-u>Unite file_rec/git:--cached:--others:--exclude-standard file/new -buffer-name=Files\ (Git)<cr>
	nnoremap <silent> <leader>m :<C-u>Unite neomru/file -buffer-name=MRU\ Files<cr>
	nnoremap <silent> <leader>b :<C-u>Unite buffer -buffer-name=Buffers<cr>
	nnoremap <silent> <leader>J :<C-u>Unite jump -buffer-name=Jump\ Locations<cr>
	nnoremap <silent> <leader>o :<C-u>Unite outline -buffer-name=Outline<cr>
	nnoremap <silent> <leader>O :<C-u>Unite outline -no-split -buffer-name=Outline<cr>
	nmap <C-A-p> <leader>f
	nmap <C-A-m> <leader>m

	if executable('pt')
		let g:unite_source_grep_command = 'pt'
		let g:unite_source_grep_default_opts = '--nogroup --nocolor'
		let g:unite_source_grep_recursive_opt = ''
		let g:unite_source_grep_encoding = 'utf-8'
	elseif executable('ag')
		let g:unite_source_grep_command = 'ag'
		let g:unite_source_grep_default_opts = '-i --vimgrep --ignore .hg --ignore .git --ignore .svn --ignore .bzr'
		let g:unite_source_grep_recursive_opt = ''
	elseif executable('ack')
		let g:unite_source_grep_command = 'ack'
		let g:unite_source_grep_default_opts = '-i --no-heading --no-color -k -H'
		let g:unite_source_grep_recursive_opt = ''
	endif

	nnoremap <silent> <leader>g :<C-u>Unite grep:. -buffer-name=Find<cr>
	nnoremap <silent> <leader>L :<C-u>UniteResume<cr>
endif

" Plugin: fzf.vim
if s:plug_loaded('fzf.vim')
	nnoremap <silent> <Leader>f :<C-u>Files<cr>
	nnoremap <silent> <Leader>F :<C-u>GitFiles<cr>
	nnoremap <silent> <Leader>m :<C-u>History<cr>
	nnoremap <silent> <Leader>b :<C-u>Buffers<cr>
	nnoremap <silent> <Leader><F1> :<C-u>Helptags<cr>
	nmap <C-A-p> <leader>f
	nmap <C-A-m> <leader>m
endif

" Plugin: neocomplete
if s:completion_setup == 'neocomplete' && s:plug_loaded('neocomplete.vim')
	let g:neocomplete#enable_at_startup = 1
	let g:neocomplete#enable_ignore_case = 1
	let g:neocomplete#enable_smart_case = 0
	let g:neocomplete#disable_auto_complete = 0
	let g:neocomplete#auto_completion_start_length = 4
	let g:neocomplete#manual_completion_start_length = 2
	let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

	if !exists('g:neocomplete#keyword_patterns')
		let g:neocomplete#keyword_patterns = {}
	endif
	let g:neocomplete#keyword_patterns['default'] = '\h\w*'

	function! s:cr_neocomplete()
		return pumvisible() ? "\<C-y>" : "\<CR>"
	endfunction

	inoremap <silent><CR> <C-r>=<sid>cr_neocomplete()<CR>

	function! s:completion_tab_neocomplete()
		if pumvisible()
			return "\<C-n>"
		endif
		if s:completion_check_bs()
			return "\<Tab>"
		endif
		return neocomplete#start_manual_complete()
	endfunction

	inoremap <silent><expr><Tab> <sid>completion_tab_neocomplete()
	inoremap <expr><C-g> neocomplete#undo_completion()
	inoremap <expr><C-l> neocomplete#complete_common_string()
	inoremap <expr><C-h> neocomplete#smart_close_popup() . "\<C-h>"
	inoremap <expr><BS>  neocomplete#smart_close_popup() . "\<C-h>"
elseif s:completion_setup == 'neocomplete' && s:plug_loaded('deoplete.nvim')
	let g:deoplete#enable_at_startup = 1
	let g:deoplete#auto_completion_start_length = 4
	let g:deoplete#enable_ignore_case = 1
	let g:deoplete#enable_smart_case = 0

	" inoremap <expr><C-Space> deoplete#mappings#manual_complete()
	" inoremap <expr><Nul> deoplete#mappings#manual_complete()
	inoremap <expr><C-y> deoplete#mappings#close_popup()
	inoremap <expr><C-e> deoplete#mappings#cancel_popup()
	inoremap <expr><C-g> deoplete#mappings#undo_completion()
	inoremap <expr><C-h> deoplete#mappings#smart_close_popup()."\<C-h>"
	inoremap <expr><BS>  deoplete#mappings#smart_close_popup()."\<C-h>"
	inoremap <expr><silent><Tab> pumvisible() ? "\<C-n>" :
		\ (<sid>completion_check_bs() ? "\<Tab>" : deoplete#mappings#manual_complete())
	" inoremap <expr><CR>  deoplete#mappings#close_popup()."\<CR>"
	" inoremap <expr> '    pumvisible() ? deoplete#mappings#close_popup()."'" : "'"
	" inoremap <expr> "    pumvisible() ? deoplete#mappings#close_popup().'"' : '"'
endif

" Plugin: YouCompleteMe
if s:completion_setup == 'ycm'
	let g:ycm_min_num_of_chars_for_completion = 3
	let g:ycm_always_populate_location_list = 1
	let g:ycm_key_detailed_diagnostics = '<leader>D'
	let g:ycm_extra_conf_globlist = ['~/devel/*', '/devel/*', '~/pfc/eol/*', '!~/*']
	let g:ycm_rust_src_path = '/usr/src/rust/src'

	if &t_Co == 256
		highlight YcmErrorSign   ctermbg=124 ctermfg=9
		highlight YcmWarningSign ctermbg=172 ctermfg=11
		highlight YcmErrorLine   ctermbg=52  ctermfg=15
		highlight YcmWarningLine ctermbg=94  ctermfg=15
	endif

	if !exists('g:ycm_semantic_triggers')
		let g:ycm_semantic_triggers = {}
	endif
endif

" Plugin: eighties
if s:plug_loaded('vim-eighties')
	let g:eighties_enabled = 1
	let g:eighties_compute = 1
	let g:eighties_extra_width = 5
	let g:eighties_minimum_width = 80
endif

" Plugin: quickhl
if s:plug_loaded('vim-quickhl')
	nmap <leader>h <Plug>(quickhl-manual-this)
	xmap <leader>h <Plug>(quickhl-manual-this)
	nmap <leader>H <Plug>(quickhl-manual-reset)
	xmap <leader>H <Plug>(quickhl-manual-reset)
	nmap <leader>j <Plug>(quickhl-cword-toggle)
endif

" Plugin: diff-enhanced
if s:plug_loaded('vim-diff-enhanced')
	let &diffexpr='EnhancedDiff#Diff("git diff", "--diff-algorithm=patience")'
endif

" Show "git diff --cached" in split window when committing changes.
function! s:SplitGitDiffCached()
    vnew
    silent 0read! git diff --cached --no-color
    silent file! git-diff-cached
    setlocal filetype=git buftype=nowrite nobuflisted noswapfile nomodifiable
    " Go to the top of the buffer: always shown diff from the beginning
    execute ':1'
    wincmd r | wincmd p
    autocmd QuitPre <buffer> wincmd w | wincmd q
    " Convert the split into an horizontal one in not-so-wide terminals.
    if &columns < 140
		wincmd K
    endif
endfunction
autocmd vimrc FileType gitcommit call s:SplitGitDiffCached()

" dwm-like window movements
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" Manually re-format a paragraph of text
nnoremap <silent> Q gwip
