
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


if empty(glob('~/.config/nvim/autoload/plug.vim'))
	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd vimrc VimEnter * PlugInstall
endif


let s:completion_setup = 'ycm'

call plug#begin('~/.config/nvim/bundle')
Plug 'tpope/vim-sensible'

if s:completion_setup == 'lift'
	Plug '~/devel/vim-lift'
elseif s:completion_setup == 'deoplete'
	Plug 'Shougo/deoplete.nvim'
	Plug 'Shougo/neco-vim'
	Plug 'Shougo/neco-syntax'
	Plug 'Shougo/neoinclude.vim'
elseif s:completion_setup == 'ycm'
	Plug 'Valloric/YouCompleteMe', { 'do': 'python2 install.py --clang-completer --gocode-completer --system-boost --system-libclang' }
endif

Plug '~/devel/vim-template'
Plug '~/devel/hipack-vim', { 'for' : 'hipack' }
Plug 'tpope/vim-endwise'
Plug 'bling/vim-airline'
Plug 'ntpeters/vim-better-whitespace'
Plug 'chrisbra/vim-diff-enhanced'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'gcmt/wildfire.vim'
Plug 'jamessan/vim-gnupg'
Plug 'wting/rust.vim'
Plug 'racer-rust/vim-racer'
Plug 'tyru/current-func-info.vim'
Plug 'lervag/vimtex'
Plug 'vim-scripts/a.vim', { 'on': ['A', 'AV', 'AS'] }
Plug 'tyru/caw.vim', { 'on' : '<Plug>(caw:' }
Plug 'ledger/vim-ledger', { 'for' : 'ledger' }
Plug 'vim-scripts/gtk-vim-syntax', { 'for' : ['c', 'cpp'] }
Plug 'othree/yajs.vim', { 'for' : 'javascript' }
Plug 'othree/html5.vim', { 'for' : ['html', 'html.handlebars'] }
Plug 'cespare/vim-toml'
Plug 'plasticboy/vim-markdown'
Plug 'xolox/vim-misc' |
			\ Plug 'xolox/vim-lua-ftplugin'
Plug 'godlygeek/tabular', { 'on' : 'Tabularize' }
Plug 'junegunn/goyo.vim', { 'on' : 'Goyo' }
Plug 'reedes/vim-pencil'
Plug 'reedes/vim-wheel'
Plug 'reedes/vim-wordy', { 'on' : ['Wordy', 'NextWordy'] }
Plug 'Shougo/vimproc.vim', { 'do': 'make' } |
			\ Plug 'Shougo/unite.vim' |
			\ Plug 'Shougo/unite-outline' |
			\ Plug 'Shougo/neomru.vim'
Plug 't9md/vim-quickhl', { 'on' : '<Plug>(quickhl-' }
Plug 'airblade/vim-gitgutter', { 'on' : [ '<Plug>GitGutter',
			\ 'GitGutterEnable', 'GitGutterDisable', 'GitGutterToggle' ] }
Plug 'Valloric/ListToggle'
Plug 'sjl/splice.vim', { 'on' : 'SpliceInit' }
call plug#end()

" Add system-wide Vim files directory, if it exists
if isdirectory('/usr/share/vim/vimfiles')
	set runtimepath+=/usr/share/vim/vimfiles
endif

call unite#custom#profile('default', 'context', {
			\ 'winheight'       : 15,
			\ 'start_insert'    : 1,
			\ 'no_split'        : 1,
			\ 'prompt'          : ': ',
			\ })
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#custom#source('neomru/file', 'matchers',
			\ ['matcher_project_files', 'matcher_fuzzy'])

syntax on
filetype indent plugin on

set nobomb
set smartcase
set cursorline
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
set undodir=~/.nvim/undo
set undofile
set lazyredraw
set listchars=tab:↹·,extends:⇉,precedes:⇇,nbsp:␠,trail:␠,nbsp:␣
set linebreak                   " break on what looks like boundaries
set showbreak=↳\                " shown at the start of a wrapped line
set mouse=a

if len($DISPLAY) > 0
	set clipboard+=unnamed
endif


if exists('g:loaded_lift_plugin') && s:completion_setup == 'lift'
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

		inoremap <expr><silent><Tab> <sid>simple_tab_completion(0)
	elseif s:completion_setup == 'deoplete'
		inoremap <expr><silent><Tab> pumvisible() ? "\<C-n>" :
			\ (<sid>completion_check_bs() ? "\<Tab>" : deoplete#mappings#manual_complete())
	endif
endif


if $TERM =~ "^screen"
    map  <silent> [1;5D <C-Left>
    map  <silent> [1;5C <C-Right>
    lmap <silent> [1;5D <C-Left>
    lmap <silent> [1;5C <C-Right>
    imap <silent> [1;5D <C-Left>
    imap <silent> [1;5C <C-Right>

    " pretend this is xterm.  it probably is anyway, but if term is left as
    " 'screen', vim doesn't understand ctrl-arrow.
 "    if &term == "screen-256color"
	" set term=xterm-256color
 "    else
	" set term=xterm
 "    endif

    " gotta set these *last*, since `set term` resets everything
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
    set cursorline
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

" Make double Ctrl-t exit insert mode in terminals.
tnoremap <C-t><C-t> <C-\><C-n>


" Jump to the last edited position in the file being loaded (if available)
autocmd vimrc BufReadPost *
			\ if line("'\"") > 0 && line("'\"") <= line("$") |
			\		execute "normal g'\"" |
			\ endif
autocmd vimrc FileType mkdc,markdown setlocal expandtab tabstop=2 shiftwidth=2
autocmd vimrc FileType objc setlocal expandtab cinoptions+=(0
autocmd vimrc FileType cpp setlocal expandtab cinoptions+=(0
autocmd vimrc FileType c setlocal expandtab cinoptions+=(0
autocmd vimrc FileType d setlocal expandtab cinoptions+=(0


if exists('/usr/share/clang/clang-format.py')
	map  <C-k>      :pyf /usr/share/clang/clang-format.py<cr>
	imap <C-k> <Esc>:pyf /usr/share/clang/clang-format.py<cr>i
endif

" Plugin: pencil
nmap <silent> <F10> :PencilToggle<CR>
imap <silent> <F10> <Esc>:PencilToggle<CR>a
nmap <silent> <C-i> :PencilToggle<CR>a

" Plugin: GitGutter
let g:gitgutter_enabled = 0
let g:gitgutter_diff_args = '-w'
nmap <silent> <F8> :GitGutterToggle<cr>
imap <silent> <F8> <Esc>:GitGutterToggle<cr>a

" Plugin: caw
let g:caw_no_default_keymappings = 1
nmap <leader>c <Plug>(caw:i:toggle)
xmap <leader>c <Plug>(caw:i:toggle)

" Plugin: Airline
let g:airline_powerline_fonts = 1
" let g:airline_left_sep = ''
" let g:airline_right_sep = ''
" let g:airline_mode_map = {
" 			\ '__' : '-', 'n'  : 'N', 'i'  : 'I', 'R'  : 'R',
" 			\ 'c'  : 'C', 'v'  : 'V', 'V'  : 'V', '' : 'V',
" 			\ 's'  : 'S', 'S'  : 'S', '' : 'S' }
let g:airline_theme = 'bubblegum'
let g:airline_detect_crypt = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_min_count = 2
let g:airline_section_x = '%{PencilMode()}%{cfi#format(" · %s()", "")}'

" Plugin: Indent Guides
let g:indent_guides_exclude_filetypes = ['help', 'unite', 'qf']
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 1
let g:indent_guides_auto_colors = 0
highlight IndentGuidesOdd  ctermbg=black
highlight IndentGuidesEven ctermbg=233

" Plugin: better-whitespace
let g:better_whitespace_filetypes_blacklist = ['help', 'unite', 'qf']

" Plugin: Unite
let g:unite_source_file_mru_limit = 350
nnoremap <silent> <leader>f :<C-u>Unite file_rec/neovim file/new -buffer-name=Files<cr>
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

" Plugin: vim-lua-ftplugin
let g:lua_check_syntax = 0
let g:lua_complete_omni = 1
let g:lua_complete_dynamic = 0

" Plugin: deoplete
if s:completion_setup == 'deoplete'
	let g:deoplete#enable_at_startup = 1
	let g:deoplete#auto_completion_start_length = 3

	" inoremap <expr><C-Space> deoplete#mappings#manual_complete()
	" inoremap <expr><Nul> deoplete#mappings#manual_complete()
	inoremap <expr><C-y> deoplete#mappings#close_popup()
	inoremap <expr><C-e> deoplete#mappings#cancel_popup()
	inoremap <expr><C-h> deoplete#mappings#smart_close_popup()."\<C-h>"
	inoremap <expr><BS>  deoplete#mappings#smart_close_popup()."\<C-h>"
	inoremap <expr> '    pumvisible() ? deoplete#mappings#close_popup() : "'"
	inoremap <expr> "    pumvisible() ? deoplete#mappings#close_popup() : '"'

	" Make deoplete provide completions from vim-lua-ftplugin
	if !exists('g:deoplete#omni#functions')
		let g:deoplete#omni#functions = {}
	endif
	let g:deoplete#omni#functions.lua = 'xolox#lua#omnifunc'
	"let g:deoplete#omni#functions.lua = 'xolox#lua#completefunc'
	let g:lua_define_completion_mappings = 0
endif

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

" Plugin: quickhl
nmap <leader>h <Plug>(quickhl-manual-this)
xmap <leader>h <Plug>(quickhl-manual-this)
nmap <leader>H <Plug>(quickhl-manual-reset)
xmap <leader>H <Plug>(quickhl-manual-reset)
nmap <leader>j <Plug>(quickhl-cword-toggle)

" Plugin: racer
let g:racer_cmd = '/usr/bin/racer'
let $RUST_SRC_PATH = '/usr/src/rust/src'

" Plugin: Markdown
let g:vim_markdown_folding_disabled = 1

" Plugin: vimtex
let g:vimtex_fold_enabled = 0
let g:vimtex_syntax_minted = [
			\ { 'lang': 'c', 'environments': ['ccode'] },
			\ { 'lang': 'lua', 'environments': ['luacode'] },
			\ ]

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