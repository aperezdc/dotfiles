" Thing: Adrian's Vim configuration file. This one is important!
" Author: Adrian Perez de Castro <aperez@igalia.com>
" License: Distributed under terms of the MIT license

if has("vim_starting")
	set nocompatible
	set runtimepath+=~/.vim/bundle/neobundle.vim
endif

" NeoVim needs some trickery to enable Python support
if has("nvim")
	runtime! python_setup.vim
	if $DISPLAY != ''
		set unnamedclip
	endif
endif

let g:email = "aperez@igalia.com"
let g:user  = "Adrian Perez"

" Plugin: CamelCaseMotion
" This plug-in has to be configured before sourcing
map <S-W> <Plug>CamelCaseMotion_w
map <S-B> <Plug>CamelCaseMotion_b
map <S-E> <Plug>CamelCaseMotion_e

call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle "tomtom/pluginstats_vim"

" Choose plug-ins used for code completion.
if has("python")
	NeoBundle 'Valloric/YouCompleteMe',
				\ {'build': {
				\   'unix': './install.sh --clang-completer --system-libclang'
				\ }}
else
	"NeoBundle 'osyo-manga/vim-reunions'
	"NeoBundle 'osyo-manga/vim-marching'
	"NeoBundle 'aperezdc/ccode'
	"NeoBundle 'Rip-Rip/clang_complete',
	"			\ {'build': {
	"			\   'unix': 'make'
	"			\ }}
endif

if has("python")
	NeoBundle 'davidhalter/jedi-vim'
endif

NeoBundle "aperezdc/vim-lift"
NeoBundle 'Shougo/vimproc.vim', {'build': {'unix': 'make'}}
NeoBundle 'nsf/gocode', {'rtp': 'vim/'}
NeoBundle 'aperezdc/vim-template'
NeoBundle 'jamessan/vim-gnupg'
"NeoBundle 'cbracken/vala.vim'
NeoBundle 'juvenn/mustache.vim'
NeoBundle 'vim-scripts/gtk-vim-syntax'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'bling/vim-airline'
"NeoBundle 'tpope/vim-fugitive'
"NeoBundle 'tpope/vim-eunuch'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'ledger/vim-ledger'
NeoBundle 'gcmt/wildfire.vim'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/unite-outline'
NeoBundle 'osyo-manga/unite-quickfix'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'bkad/CamelCaseMotion'
"NeoBundle 'terryma/vim-multiple-cursors'
"NeoBundle 'aperezdc/notmuch-addrlookup-c'
NeoBundle 'othree/xml.vim'
"NeoBundle 'sjl/gundo.vim'
"NeoBundle 'katono/rogue.vim'
NeoBundle 'calebsmith/vim-lambdify'
NeoBundle 'haya14busa/incsearch.vim'
NeoBundle 'godlygeek/tabular'
NeoBundle 'aperezdc/vim-wcfg'
"NeoBundle 'jnurmine/Zenburn'
call neobundle#end()

set tabstop=2				 " Set tabstops to 2 spaces
set smarttab                 " Use smart tabs... we are not as dumb!
set shiftwidth=2			 " Set indentation shift-width to 2 spaces
set autoindent				 " Enable automatic indentation
set copyindent				 " Enable automatic indentation of pasted lines
set incsearch				 " Use incremental search
set smartcase                " No case-sense by default, but on on typing mays.
set nohlsearch				 " Disable search highlighting
set ruler					 " Show line number & column
set laststatus=2			 " Always show a status line
set sidescrolloff=2			 " Keep some context when scrolling
set scrolloff=6				 " The same in vertical :)
set viminfo+=n~/.viminfo	 " Name of the viminfo file
set whichwrap+=[,],<,>		 " Allow arrow keys to wrap lines
set nowrap					 " Don't wrap long lines
set showmode				 " Print the current mode in the last line
set ttyfast             	 " Lots of console stuff that may slow down Vim
set showfulltag			     " Do not show full prototype of tags on completion
set showcmd					 " Show commands as they are typed
set formatoptions+=cqron1 	 " Some useful formatting options
set showmatch				 " Show matching parens
set textwidth=76             " Text is 76 columns wide
set backspace=2              " Backspace always useable in insert mode
set fileformats=unix,mac,dos " Allows automatic line-end detection.
set completeopt+=preview,menuone,longest
set ignorecase
set infercase
set splitbelow
set splitright
set hidden
set diffopt+=iwhite
set nobackup
set tags=tags;/
set nofsync
set nosol
set shortmess+=a
set noshowmode
set grepprg=ag\ --noheading\ --nocolor\ --nobreak
set secure
set exrc
set ttyfast
set undofile                " Save undo's after file closes
set undodir=$HOME/.vim/undo " where to save undo histories
set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo


if has("mouse")
	"set mouse=a
	if has("mouse_sgr")
		set ttymouse=sgr
	endif
endif

if has("linebreak")
	set linebreak 		 	 " Break on `breakat' chars when linewrapping is on.
	set showbreak=+          " Prepend `+' to wrapped lines
endif

if has("folding")
	set foldminlines=5 		 " Don't fold stuff with less lines
	set foldmethod=syntax 	 " Use syntax-aware folding
	set nofoldenable 		 " Don't enable folding by default
endif

if has("wildmenu")
	set wildmenu           	 " Show completions on menu over cmdline
	set wildchar=<TAB>     	 " Navigate wildmenu with tabs
	set wildignore=*.o,*.cm[ioax],*.ppu,*.core,*~,core,#*#
endif

" Plugin: XML
let g:xml_syntax_folding = 1

" Completion
function! s:completion_check_bs()
	let col = col('.') - 1
	return !col || getline('.')[col - 1] =~ '\s'
endfunction

" Simple autocompletion with <TAB>, uses Omni Completion if available,
" falls back to an user/plugin-defined completefunc, or as a last
" resort, to buffer completion.
function! s:simple_tab_completion(prefer_user_complete)
	if pumvisible()
		return "\<C-p>"
	endif
	if s:completion_check_bs()
		return "\<Tab>"
	endif

	if a:prefer_user_complete > 0
		if exists("completefunc") && &completefunc != ""
			return "\<C-x><C-u>"
		elseif exists("omnifunc") && &omnifunc != ""
			return "\<C-x><C-o>"
		endif
	else
		if exists("omnifunc") && &omnifunc != ""
			return "\<C-x><C-o>"
		elseif exists("completefunc") && &completefunc != ""
			return "\<C-x><C-u>"
		endif
	endif
	return "\<C-p>"
endfunction

if neobundle#is_sourced('vim-lift')
	let g:lift#sources = { '_' : ['syntax', 'omni', 'near', 'user'] }
	"let g:lift#close_preview_window = 1
	inoremap <expr> <Tab> lift#trigger_completion()
else
	inoremap <expr> <Tab> <sid>simple_tab_completion(0)
endif

" Plugin: YouCompleteMe
if neobundle#is_sourced('YouCompleteMe')
	let g:ycm_collect_identifiers_from_tags_files = 0
	let g:ycm_seed_identifiers_with_syntax = 1
	let g:ycm_add_preview_to_completeopt = 1
	let g:ycm_auto_trigger = 0
	let g:ycm_min_num_of_chars_for_completion = 6
	let g:ycm_enable_diagnostic_signs = 1
	let g:ycm_extra_conf_globlist = ['/home/aperez/devel/*']
	let g:ycm_filetype_blacklist = { 'unite': 1, 'qf': 1, 'notmuch-folders': 1 }
	let g:ycm_key_invoke_completion = "<C-Space>"
	let g:ycm_key_list_select_completion = ['<CR>']
	" Jump to things using information gathered by YouCompleteMe
	map <C-J> :YcmCompleter GoToDefinitionElseDeclaration<CR>
endif " YouCompleteMe

" Plugin: vim-clang
if neobundle#is_sourced('vim-clang')
	let g:clang_diagsopt="leftabove:6"
endif " vim-clang

" Plugin: clang_complete
if neobundle#is_sourced('clang_complete')
	let g:clang_hl_errors = 0
	let g:clang_complete_macros = 1
	let g:clang_snippets = 1
	let g:clang_snippets_engine = 'clang_complete'
	let g:clang_jumpto_declaration_key = "<leader>d"
	let g:clang_jumpto_declaration_in_preview_key = "<leader>D"
	let g:clang_library_path = "/usr/lib/libclang.so"
endif " clang_complete

" Plugin: Syntastic
if neobundle#is_sourced('syntastic')
	let g:syntastic_error_symbol = '✗'
	let g:syntastic_warning_symbol = '⚠'
	let g:syntastic_style_error_symbol = '»»'
	let g:syntastic_style_warning_symbol = '»'
	let g:syntastic_always_populate_loc_list = 1

	let g:syntastic_python_pylint_args = '--indent-string="    "'

	let g:syntastic_c_compiler = 'clang'
	let g:syntastic_c_compiler_options = ' -std=gnu99'
	let g:syntastic_c_check_header=1
	let g:syntastic_c_auto_refresh_includes=1

	let g:syntastic_cpp_compiler = 'clang++'
	let g:syntastic_cpp_compiler_options = ' -std=c++1y -stdlib=libc++ '
	let g:syntastic_cpp_check_header=1
	let g:syntastic_cpp_auto_refresh_includes=1

	let g:syntastic_objc_compiler = 'clang'
	let g:syntastic_objc_compiler_options = ' -fobjc '
	let g:syntastic_objc_check_header=1
	let g:syntastic_objc_auto_refresh_includes=1

	let g:syntastic_objcpp_compiler = 'clang++'
	let g:syntastic_objcpp_compiler_options = ' -std=c++11y -stdlib=libc++ -fobjc '
	let g:syntastic_objcpp_check_header=1
	let g:syntastic_objcpp_auto_refresh_includes=1
endif " Syntastic

" Plugin: Unite
if neobundle#is_sourced('unite.vim')
	" General settings
	let g:unite_update_time = 200
	let g:unite_enable_start_insert = 1
	let g:unite_source_file_mru_limit = 1000
	call unite#custom#profile('default', 'context', { 'prompt': '% ' })
	call unite#filters#matcher_default#use(['matcher_fuzzy'])

	" Finding files and buffers and things
	if neobundle#is_sourced("vimproc.vim")
		nnoremap <silent> <leader>f :<C-u>Unite file_rec/async file/new -buffer-name=Files<cr>
		nnoremap <silent> <leader>d :<C-u>Unite buffer bookmark file/async -buffer-name=Files\ (misc)<cr>
	else
		nnoremap <silent> <leader>f :<C-u>Unite file_rec file/new -buffer-name=Files<cr>
		nnoremap <silent> <leader>d :<C-u>Unite buffer bookmark file -buffer-name=Files\ (misc)<cr>
	endif
	nnoremap <silent> <leader>F :<C-u>Unite file_rec/git:--cached:--others:--exclude-standard file/new -buffer-name=Files\ (Git)<cr>
	nnoremap <silent> <leader>m :<C-u>Unite neomru/file -buffer-name=MRU\ Files<cr>
	nnoremap <silent> <leader>b :<C-u>Unite buffer -buffer-name=Buffers<cr>
	nnoremap <silent> <leader>J :<C-u>Unite jump -buffer-name=Jump\ Locations<cr>

	" Outline (TagBar-alike)
	nnoremap <silent> <leader>o :<C-u>Unite outline -buffer-name=Outline<cr>
	nnoremap <silent> <leader>O :<C-u>Unite outline -no-split -buffer-name=Outline<cr>

	" QuickFix
	let g:unite_quickfix_is_multiline = 1
	nnoremap <silent> <leader>q :<C-u>Unite location_list quickfix -buffer-name=Location<cr>

	" Fuzzy find in buffer
	nnoremap <silent> <leader><space> :<C-u>Unite line -buffer-name=Search -start-insert -auto-preview -auto-resize<cr>

	" Ag/Ack/Grep
	if executable('ag')
		let g:unite_source_grep_command = 'ag'
		let g:unite_source_grep_default_opts = '-i --line-numbers --nocolor --nogroup --noheading'
		let g:unite_source_grep_recursive_opt = ''
	elseif executable('ack')
		let g:unite_source_grep_command = 'ack'
		let g:unite_source_grep_default_opts = '-i --no-heading --no-color -k -H'
		let g:unite_source_grep_recursive_opt = ''
	endif
	nnoremap <silent> <leader>g :<C-u>Unite grep:. -buffer-name=Find<cr>

	" Open last-used Unite buffer
	nnoremap <silent> <leader>L :<C-u>UniteResume<cr>
endif " unite.vim

" Plugin: Airline
if neobundle#is_sourced('vim-airline')
	let g:airline_powerline_fonts = 0
	if g:airline_powerline_fonts == 0
		let g:airline_left_sep = ''
		let g:airline_right_sep = ''
		let g:airline_symbols = {
					\ 'linenr'     : '◢',
					\ 'branch'     : '≣',
					\ 'paste'      : '⟂',
					\ 'readonly'   : '⚠',
					\ 'whitespace' : '␥',
					\ }
	endif
	let g:airline_mode_map = {
				\ '__' : '-',
				\ 'n'  : 'N',
				\ 'i'  : 'I',
				\ 'R'  : 'R',
				\ 'c'  : 'C',
				\ 'v'  : 'V',
				\ 'V'  : 'V',
				\ '' : 'V',
				\ 's'  : 'S',
				\ 'S'  : 'S',
				\ '' : 'S',
				\ }
	let g:airline_theme = 'bubblegum'
	let g:airline#extensions#tabline#enabled = 1
	let g:airline#extensions#tabline#buffer_min_count = 2
endif " vim-airline

" Plugin: GitGutter
if neobundle#is_sourced('vim-gitgutter')
	let g:gitgutter_sign_column_always = 1
	nmap gh <Plug>GitGutterNextHunk
	nmap gH <Plug>GitGutterPrevHunk
	nmap gs <Plug>GitGutterStageHunk
	nmap gR <Plug>GitGutterRevertHunk
	nmap gd <Plug>GitGutterPreviewHunk
endif

" Plugin: incsearch
if neobundle#is_sourced('incsearch.vim')
	let g:incsearch#consistent_n_direction = 1
	map <Space>   <Plug>(incsearch-forward)
	map <Leader>? <Plug>(incsearch-backward)
	map g/        <Plug>(incsearch-stay)
else
	map <Space>   /
endif " incsearch.vim

" Plugin: Taskwarrior
if neobundle#is_sourced('vim-taskwarrior')
	let g:task_rc_override = 'rc.defaultwidth=999'
endif


" Tune defaults for some particular file types.
autocmd FileType javascript setlocal expandtab
autocmd FileType *html,xml setlocal matchpairs+=<:>
autocmd FileType xhtml,xml let xml_use_xhtml=1
autocmd FileType python setlocal expandtab tabstop=4 shiftwidth=4
autocmd FileType lua setlocal expandtab shiftwidth=2 tabstop=2
autocmd FileType rst setlocal expandtab tabstop=2 shiftwidth=2
autocmd FileType objc setlocal expandtab cinoptions+=(0
autocmd FileType cpp setlocal expandtab cinoptions+=(0
autocmd FileType c setlocal expandtab cinoptions+=(0
autocmd FileType d setlocal expandtab cinoptions+=(0

" Jump to the last edited position in the file being loaded (if available)
" in the ~/.viminfo file, I really love this =)
autocmd BufReadPost *
			\ if line("'\"") > 0 && line("'\"") <= line("$") |
			\		execute "normal g'\"" |
			\ endif

" Set PO mode for POT gettext templates, too.
autocmd BufEnter *.pot
			\ setf po | setlocal fenc=utf8

" Set Python mode for Twisted Application Configuration (.tac) fiels.
autocmd BufReadPost,BufNewFile *.tac setf python

" Add the `a' format option (autoreflow) to plain text files.
autocmd BufReadPost,BufNewFile *.txt,*README*,*TODO*,*HACKING*,*[Rr]eadme*,*[Tt]odo*
			\ setlocal expandtab

" System headers usually are designed to be viewed with 8-space tabs
autocmd BufReadPost /usr/include/* setlocal ts=8 sw=8

" Tup build system
autocmd BufNewFile,BufRead Tupfile,*.tup setf tup

" Use Enter key to navigate help links.
autocmd FileType help nmap <buffer> <Return> <C-]>

" When under xterm and compatible terminals, use titles if available and
" change cursor color depending on active mode.
if &term =~ "xterm" || &term =~ "screen" || &term =~ "tmux"
	if has("title")
		set title
	endif
endif

" Some fixups for Screen, which has those messed up in most versions
if &term =~ "screen"
	map  <silent> [1;5D <C-Left>
	map  <silent> [1;5C <C-Right>
	lmap <silent> [1;5D <C-Left>
	lmap <silent> [1;5C <C-Right>
	imap <silent> [1;5D <C-Left>
	imap <silent> [1;5C <C-Right>
endif

if has("syntax") || has("gui_running")
	syntax on
	if has("gui_running")
		colorscheme twilight
		set guifont=PragmataPro\ 12
		set guifontwide=VL\ Gothic
		set cursorline
	else
		if &term =~ "xterm-256color" || &term =~ "screen-256color" || $COLORTERM =~ "gnome-terminal"
			set t_Co=256
			set t_AB=[48;5;%dm
			set t_AF=[38;5;%dm
			set cursorline
		endif
		if &term =~ "st-256color"
			set t_Co=256
			set cursorline
		endif

		if &t_Co == 256 && neobundle#is_sourced("Zenburn")
			let g:zenburn_high_Contrast = 0
			let g:zenburn_transparent = 1
			colorscheme zenburn
		else
			colorscheme elflord
			highlight CursorLine   NONE
			if &t_Co == 256
				highlight CursorLine   ctermbg=235
				highlight CursorLineNr ctermbg=235 ctermfg=246
				highlight LineNr       ctermbg=234 ctermfg=238
				highlight SignColumn   ctermbg=234
				highlight Pmenu        ctermbg=235 ctermfg=white
				highlight PmenuSel     ctermbg=238 ctermfg=white
				highlight PmenuSbar    ctermbg=238
				highlight PmenuThumb   ctermbg=240
			endif
		endif
	endif

	" Match whitespace at end of lines (which is usually a mistake),
	" but only while not in insert mode, to avoid matches popping in
	" and out while typing.
	highlight WhitespaceEOL ctermbg=red guibg=red
	augroup WhitespaceEOL
		autocmd!
		autocmd InsertEnter * syn clear WhitespaceEOL | syn match WhitespaceEOL excludenl /\s\+\%#\@!$/
		autocmd InsertLeave * syn clear WhitespaceEOL | syn match WhitespaceEOL excludenl /\s\+$/
	augroup END
endif


" Let Vim be picky about syntax, so we are reported of glitches visually.
let c_gnu                = 1
let use_fvwm_2           = 1
let c_space_errors       = 1
let java_space_errors    = 1
let ora_space_errors     = 1
let plsql_space_errors   = 1
let python_space_errors  = 1
let python_highlight_all = 1
let g:sql_type_default   = 'mysql'

" Set up things for UTF-8 text editing by default, if multibyte
" support was compiled in. Let Linux consoles be Latin-1.
if has("multi_byte")
	set encoding=utf-8
	if $TERM == "linux" || $TERM_PROGRAM == "GLterm"
		set termencoding=latin1
	endif
endif

" Autocorrect some usually-mispelled commands
command! -nargs=0 -bang Q q<bang>
command! -bang W write<bang>
command! -nargs=0 -bang Wq wq<bang>

" Saves current position, executes the given expression using :execute
" and sets the cursor in the saved position, so the user thinks cursor
" was not moved at all during an operation.
function ExecuteInPlace(expr)
	let l:linePos = line(".")
	let l:colPos = col(".")
	execute a:expr
	call cursor(l:linePos, l:colPos)
endfunction

" Some commands used to thrash trailing garbage in lines.
command -nargs=0 KillEolLF      call ExecuteInPlace("%s/\\r$//")
command -nargs=0 KillEolSpaces  call ExecuteInPlace("%s/[ \\t]\\+$//")
command -nargs=0 KillEolGarbage call ExecuteInPlace("%s/[ \\t\\r]\\+$//")
command -nargs=0 EolMac2Unix    call ExecuteInPlace("%s/\\r/\\n/g")
command -nargs=0 EolUnix2Mac    call ExecuteInPlace("%s/$/\\r/g")
command -nargs=0 EolUnix2DOS    call ExecuteInPlace("%s/$/\\r\\n/g")

" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Move to the previous/mext buffer
nnoremap H :bprevious<CR>
nnoremap L :bnext<CR>

" Exit swiftly
map __ ZZ

" A bit of commoddity to jump through source files using tags
map <C-T> <C-]>
map <C-P> :pop<CR>

" F2 -> Save file
map  <F2>   :w!<CR>
imap <F2>   <ESC>:w!<CR>a

" F5 -> Compile/build
" F6 -> Show build errors
" F7 -> Previous error
" F8 -> Next error
map  <F5>   :wall!<CR>:make<CR>
map  <F6>   :cl!<CR>
map  <F7>   :cp!<CR>
map  <F8>   :cn!<CR>

" clang-format, see http://clang.llvm.org/docs/ClangFormat.html
if has("python") && executable("clang-format")
	map <C-K> :pyf /usr/share/clang/clang-format.py<CR>
	imap <C-K> <ESC>:pyf /usr/share/clang/clang-format.py<CR>i
endif

filetype plugin indent on

runtime! macros/matchit.vim
NeoBundleCheck

" vim:ts=4:sw=4:fenc=utf-8
