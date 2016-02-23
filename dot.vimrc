
augroup vimrc
	autocmd!
augroup END

let g:email = "aperez@igalia.com"
let g:user  = "Adrian Perez"

" To avoid mistankenly using one for the other, always point to the versioned binaries.
if has('python3')
	let g:python3_host_prog = '/usr/bin/python3'
endif
if has('python')
	let g:python_host_prog = '/usr/bin/python2'
endif

if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd vimrc VimEnter * PlugInstall
endif

"let g:templates_directory = '~/t'

let s:completion_setup = 'lift'

call plug#begin('~/.vim/bundle')
Plug 'tpope/vim-sensible'

if s:completion_setup == 'lift'
	if empty(glob('~aperez/devel/vim-lift'))
		Plug 'aperezdc/vim-lift'
	else
		Plug '~aperez/devel/vim-lift'
	endif
elseif s:completion_setup == 'ycm'
	Plug 'Valloric/YouCompleteMe', { 'do': 'python2 install.py --clang-completer --gocode-completer --system-boost --system-libclang --racer-completer' }
endif

if empty(glob('~aperez/devel/vim-template'))
	Plug 'aperezdc/vim-template'
else
	Plug '~aperez/devel/vim-template'
endif
if empty(glob('~aperez/devel/vim-elrond'))
	Plug 'aperezdc/vim-elrond'
else
	Plug '~/devel/vim-elrond'
endif
if empty(glob('~aperez/devel/hipack-vim'))
	Plug 'aperezdc/hipack-vim', { 'for' : 'hipack' }
else
	Plug '~aperez/devel/hipack-vim', { 'for' : 'hipack' }
endif

Plug 'tpope/vim-endwise'
Plug 'vim-airline/vim-airline-themes' | Plug 'vim-airline/vim-airline'
Plug 'ntpeters/vim-better-whitespace'
Plug 'chrisbra/vim-diff-enhanced'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'gcmt/wildfire.vim'
Plug 'jamessan/vim-gnupg'
Plug 'wting/rust.vim'
Plug 'vim-scripts/a.vim', { 'on': ['A', 'AV', 'AS'] }
Plug 'tyru/caw.vim', { 'on' : '<Plug>(caw:' }
Plug 'ledger/vim-ledger', { 'for' : 'ledger' }
Plug 'vim-scripts/gtk-vim-syntax', { 'for' : ['c', 'cpp'] }
Plug 'othree/yajs.vim', { 'for' : 'javascript' }
Plug 'othree/html5.vim', { 'for' : ['html', 'html.handlebars'] }
Plug 'cespare/vim-toml'
Plug 'plasticboy/vim-markdown'
Plug 'godlygeek/tabular', { 'on' : 'Tabularize' }
Plug 'reedes/vim-pencil'
Plug 'reedes/vim-wheel'
Plug 'reedes/vim-wordy', { 'on' : ['Wordy', 'NextWordy'] }
Plug 'Shougo/vimproc.vim', { 'do' : 'make' } |
			\ Plug 'Shougo/unite.vim' |
			\ Plug 'Shougo/unite-outline' |
			\ Plug 'Shougo/neomru.vim'
Plug 't9md/vim-quickhl', { 'on' : '<Plug>(quickhl-' }
Plug 'airblade/vim-gitgutter', { 'on' : [ '<Plug>GitGutter',
			\ 'GitGutterEnable', 'GitGutterDisable', 'GitGutterToggle' ] }
Plug 'Valloric/ListToggle'
call plug#end()

call unite#custom#profile('default', 'context', {
			\ 'winheight'    : 15,
			\ 'start_insert' : 1,
			\ 'no_split'     : 1,
			\ 'prompt'       : ': ' })
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#custom#source('neomru/file', 'matchers',
			\ ['matcher_project_files', 'matcher_fuzzy'])

syntax on
colorscheme elflord
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
set completeopt-=longest
set infercase
set diffopt+=iwhite
set nobackup
set grepprg=ag\ --noheading\ --nocolor\ --nobreak
set secure
set exrc
set viminfo+=n~/.viminfo
set wildchar=<tab>
set encoding=utf-8
set notitle

if len($DISPLAY) > 0
	set clipboard+=unnamed
endif


if s:completion_setup == 'lift'
    let g:lift#sources = {
				\   '_': ['near', 'omni', 'user', 'syntax'],
				\   'c': ['omni', 'near'],
				\ }
	let g:lift#close_preview_window = 0
	let g:lift#shortcut_single_source = 1
	inoremap <expr><silent><Tab> lift#trigger_completion()
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

set t_Co=16
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


colorscheme elflord
highlight CursorLine NONE
if &t_Co == 256
	highlight CursorLine   ctermbg=235
	highlight CursorLineNr ctermbg=235 ctermfg=246
	highlight LineNr       ctermbg=234 ctermfg=238
	highlight SignColumn   ctermbg=234
	highlight Pmenu        ctermbg=235 ctermfg=white
	highlight PmenuSel     ctermbg=238 ctermfg=white
	highlight PmenuSbar    ctermbg=238
	highlight PmenuThumb   ctermbg=240
	highlight VertSplit    ctermbg=235 ctermfg=235
	highlight StatusLineNC ctermfg=235
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
autocmd vimrc FileType markdown setlocal expandtab tabstop=2 shiftwidth=2
autocmd vimrc FileType objc setlocal expandtab cinoptions+=(0
autocmd vimrc FileType cpp setlocal expandtab cinoptions+=(0
autocmd vimrc FileType c setlocal expandtab cinoptions+=(0
autocmd vimrc FileType d setlocal expandtab cinoptions+=(0


if exists('/usr/share/clang/clang-format.py')
	map  <C-k>      :pyf /usr/share/clang/clang-format.py<cr>
	imap <C-k> <Esc>:pyf /usr/share/clang/clang-format.py<cr>i
endif

" Plugin: GitGutter
let g:gitgutter_enabled = 0
let g:gitgutter_diff_args = '-2'
nmap <silent> <F8> :GitGutterToggle<cr>
imap <silent> <F8> <Esc>:GitGutterToggle<cr>a

" Plugin: caw
let g:caw_no_default_keymappings = 1
nmap <leader>c <Plug>(caw:i:toggle)
xmap <leader>c <Plug>(caw:i:toggle)

" Plugin: Airline
let g:airline_powerline_fonts = 0
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_mode_map = {
			\ '__' : '-', 'n'  : 'N', 'i'  : 'I', 'R'  : 'R',
			\ 'c'  : 'C', 'v'  : 'V', 'V'  : 'V', '' : 'V',
			\ 's'  : 'S', 'S'  : 'S', '' : 'S' }
let g:airline_theme = 'bubblegum'
let g:airline_detect_crypt = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_min_count = 2

" Plugin: Indent Guides
let g:indent_guides_exclude_filetypes = ['help', 'unite', 'qf']
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2
let g:indent_guides_auto_colors = 0
highlight IndentGuidesOdd  ctermbg=234
highlight IndentGuidesEven ctermbg=233

" Plugin: better-whitespace
let g:better_whitespace_filetypes_blacklist = ['help', 'unite', 'qf']

" Plugin: Unite
let g:unite_source_file_mru_limit = 350
nnoremap <silent> <leader>f :<C-u>Unite file_rec/async file/new -buffer-name=Files<cr>
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

" Plugin: YouCompleteMe
if s:completion_setup == 'ycm'
	let g:ycm_min_num_of_chars_for_completion = 3
	let g:ycm_always_populate_location_list = 1
	let g:ycm_key_detailed_diagnostics = '<leader>D'
	let g:ycm_extra_conf_globlist = ['~/devel/*', '/devel/*', '~/pfc/eol/*', '!~/*']

	if &t_Co == 256
		highlight YcmErrorSign   ctermbg=124 ctermfg=9
		highlight YcmWarningSign ctermbg=172 ctermfg=11
		highlight YcmErrorLine   ctermbg=52  ctermfg=15
		highlight YcmWarningLine ctermbg=94  ctermfg=15
	endif

	if !exists('g:ycm_semantic_triggers')
		let g:ycm_semantic_triggers = {}
	endif
	" VimTex integration
	let g:ycm_semantic_triggers.tex = [
				\ 're!\\[A-Za-z]*(ref|cite)[A-Za-z]*([^]]*])?{([^}]*, ?)*'
				\ ]
endif

" Plugin: clang_complete
let g:clang_library_path = '/usr/lib/libclang.so'
let g:clang_make_default_keymappings = 0

" Plugin: vim-clang
let g:clang_c_options   = '-Qunused-arguments -std=gnu99'
let g:clang_cpp_options = '-Qunused-arguments -std=gnu++11 -stdlib=libc++'
let g:clang_auto        = 0

" Plugin: quickhl
nmap <leader>h <Plug>(quickhl-manual-this)
xmap <leader>h <Plug>(quickhl-manual-this)
nmap <leader>H <Plug>(quickhl-manual-reset)
xmap <leader>H <Plug>(quickhl-manual-reset)
nmap <leader>j <Plug>(quickhl-cword-toggle)

" dwm-like window movements
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
