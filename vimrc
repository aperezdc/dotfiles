" Thing: Adrian's Vim configuration file. This one is important!
" Author: Adrian Perez de Castro <aperez@igalia.com>
" License: Distributed under terms of the MIT license

if has("vim_starting")
	set nocompatible
	set runtimepath+=~/.vim/bundle/neobundle.vim
endif
filetype indent plugin on

let g:email = "aperez@igalia.com"
let g:user  = "Adrian Perez"

" CamelCaseMotion has to be configured before sourcing
map <S-W> <Plug>CamelCaseMotion_w
map <S-B> <Plug>CamelCaseMotion_b
map <S-E> <Plug>CamelCaseMotion_e

call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'
if has("python")
	NeoBundle 'Valloric/YouCompleteMe',
				\ {'build': {
				\   'unix': './install.sh --clang-completer --system-libclang'
				\ }}
endif
NeoBundle 'nsf/gocode', {'rtp': 'vim/'}
NeoBundle 'aperezdc/vim-template'
NeoBundle 'jamessan/vim-gnupg'
NeoBundle 'jayferd/ragel.vim'
NeoBundle 'juvenn/mustache.vim'
NeoBundle 'vim-scripts/gtk-vim-syntax'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'tpope/vim-surround'
NeoBundle 'bling/vim-airline'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'ledger/vim-ledger'
NeoBundle 'gcmt/wildfire.vim'
NeoBundle 'Shougo/vimproc.vim', {'build': {'unix': 'make'}}
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/unite-help'
NeoBundle 'Shougo/unite-outline'
NeoBundle 'osyo-manga/unite-quickfix'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/CamelCaseMotion'
NeoBundle 'terryma/vim-multiple-cursors'
NeoBundle 'Raimondi/delimitMate'
NeoBundle 'rainux/vim-vala'
NeoBundle 'othree/xml.vim'
NeoBundle 'sjl/gundo.vim'
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
set noshowfulltag			 " Do not show full prototype of tags on completion
set showcmd					 " Show commands as they are typed
set formatoptions+=cqron1 	 " Some useful formatting options
set showmatch				 " Show matching parens
set textwidth=76             " Text is 76 columns wide
set backspace=2              " Backspace always useable in insert mode
set fileformats=unix,mac,dos " Allows automatic line-end detection.
set ignorecase
set infercase
set lazyredraw
set hidden
set diffopt+=iwhite
set nobackup
set tags=tags;/
set nofsync
set nosol
set shortmess+=a
set noshowmode
set grepprg=ag\ --noheading\ --nocolor\ --nobreak

if has("cscope")
	set cscopetag                " Use cscope for tags, too.
	set cscopetagorder=0         " Prefer cscope over tags.
	set nocsverb
	if filereadable("cscope.out")
		cs add cscope.out
	elseif $CSCOPE_DB != ""
		cs add $CSCOPE_DB
	endif
	set csverb
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

" Plugin: DetectIndent
let g:detectindent_preferred_expandtab = 1
let g:detectindent_preferred_indent    = 4

" Plugin: YouCompleteMe
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_add_preview_to_completeopt = 1
"let g:ycm_min_num_of_chars_for_completion = 3
"let g:ycm_autoclose_preview_window_after_completion = 0
"let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_extra_conf_globlist = ['/home/aperez/devel/*']
let g:ycm_filetype_blacklist = { 'unite': 1 }

" Plugin: Syntastic
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

" Unite: General settings
let g:unite_update_time = 200
let g:unite_enable_start_insert = 1
let g:unite_source_file_mru_limit = 1000
call unite#custom#profile('default', 'context', { 'prompt': '% ' })
call unite#filters#matcher_default#use(['matcher_fuzzy'])

" Unite: Emulate CtrlP
nnoremap <silent> <C-p> :<C-u>Unite file_rec/async -buffer-name=Files<cr>
nnoremap <silent> <leader>f :<C-u>Unite file_rec/async file/new -buffer-name=Files<cr>
nnoremap <silent> <leader>F :<C-u>Unite file_rec/git:--cached:--others:--exclude-standard file/new -buffer-name=Files\ (Git)<cr>
nnoremap <silent> <leader>d :<C-u>Unite buffer bookmark file/async -buffer-name=Files\ (misc)<cr>
nnoremap <silent> <leader>m :<C-u>Unite neomru/file -buffer-name=MRU\ Files<cr>
nnoremap <silent> <leader>b :<C-u>Unite buffer -buffer-name=Buffers<cr>
nnoremap <silent> <leader>J :<C-u>Unite jump -buffer-name=Jump\ Locations<cr>

" Unite: Outline (TagBar-alike)
nnoremap <silent> <leader>o :<C-u>Unite outline -buffer-name=Outline<cr>
nnoremap <silent> <leader>O :<C-u>Unite outline -no-split -buffer-name=Outline<cr>

" Unite: QuickFix
let g:unite_quickfix_is_multiline = 1
nnoremap <silent> <leader>q :<C-u>Unite location_list quickfix -buffer-name=Location<cr>

" Unite: Ag/Ack/Grep
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

" Unite: Open last-used Unite buffer
nnoremap <silent> <leader>L :<C-u>UniteResume<cr>

" Plugin: Airline
let g:airline_powerline_fonts = 1
"let g:airline_left_sep = '▒'
"let g:airline_right_sep = '▒'
"let g:airline_left_sep = ''
"let g:airline_right_sep = ''
let g:airline_theme = 'powerlineish'

" Plugin: GitGutter
let g:gitgutter_sign_column_always = 1
nmap gh <Plug>GitGutterNextHunk
nmap gH <Plug>GitGutterPrevHunk
nmap gs <Plug>GitGutterStageHunk
nmap gR <Plug>GitGutterRevertHunk
nmap gd <Plug>GitGutterPreviewHunk

" End of configuration for (most) plug-ins

if has("folding")
	map , zj
	"map m zk
	map - za
	map _ zA
	"map ; zi
	"map <CR> za
	"map <C-v> zA
endif

if has("autocmd")
	" Tune defaults for some particular file types.
	autocmd FileType *html,xml setlocal matchpairs+=<:>
	autocmd FileType xhtml,xml let xml_use_xhtml=1
	autocmd FileType python setlocal expandtab tabstop=4 shiftwidth=4
	autocmd FileType bzr setlocal expandtab
	autocmd FileType lua setlocal expandtab shiftwidth=2 tabstop=2
	autocmd FileType rst setlocal expandtab tabstop=2 shiftwidth=2
	autocmd FileType objc setlocal expandtab tabstop=4 shiftwidth=4 cinoptions+=(0
	autocmd FileType cpp setlocal expandtab tabstop=4 shiftwidth=4 cinoptions+=(0
	autocmd FileType c setlocal expandtab tabstop=4 shiftwidth=4 cinoptions+=(0
	autocmd FileType d setlocal expandtab tabstop=4 shiftwidth=4 cinoptions+=(0

	"autocmd FileType c setlocal expandtab cinoptions+=t0(0{1s>2sn-1s^-1s
	"autocmd FileType cpp setlocal expandtab cinoptions+=t0(0{1s>2sn-1s^-1s
	"autocmd FileType objc setlocal expandtab cinoptions+=t0(0{1s>2sn-1s^-1s

	" Define abbreviations for Java™ mode.
	autocmd FileType java
				\ iab Jmain public static void main(String [] args)|
				\ iab const- private static final|
				\ iab const+ public static final|
				\ iab cls- private class|
				\ iab cls+ public class|
				\ iab bool boolean|
				\ iab unsigned int

	" Jump to the last edited position in the file being loaded (if available)
	" in the ~/.viminfo file, I really love this =)
	autocmd BufReadPost *
				\ if line("'\"") > 0 && line("'\"") <= line("$") |
				\		execute "normal g'\"" |
				\ endif

	" Set ChangeLog mode for GNU Arch revision logs.
	autocmd BufReadPost *++log.*
				\ setf changelog |
				\ setlocal formatoptions+=a

	" Set QML mode
	autocmd BufReadPost,BufNewFile *.qml
				\ setf qml

	" Set XML mode for Zope 3.x ZCML configuration files.
	autocmd BufReadPost,BufNewFile *.zcml
				\ setf xml | setlocal expandtab ts=4 sw=2

	" Set XHTML mode for Zope Page Templates (ZPT).
	autocmd BufReadPost,BufNewFile *.pt,*.zpt
				\ setf xml | setlocal expandtab ts=4 sw=2 | let xml_use_xhtml=1

	" Set JSP mode for .jspx and .jspf file suffixes.
	autocmd BufReadPost,BufNewFile *.jsp*
				\ setf xml | setlocal expandtab ts=4 sw=2

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

	" Linux sources, kernel-style with 8 spaces per tab
	autocmd BufReadPost,BufNewFile /usr/src/linux* setlocal ts=8 sw=8

	" Mail editing.
	autocmd BufNewFile,BufReadPost *etpan*
				\ setlocal ft=mail fo+=a2 ts=4 sw=4 fenc=latin1
	autocmd BufReadPost,BufNewFile ~/[mM]ail*/* setf mail |
				\ setlocal fo+=2 sw=4 ts=4 fenc=latin1

	" Tup build system
	autocmd BufNewFile,BufRead Tupfile,*.tup
				\ setf tup

	" Use Enter key to navigate help links.
	autocmd FileType help nmap <buffer> <Return> <C-]>

	" Make ESC return to command mode faster while in edit mode
	if ! has('gui_running')
		set ttimeoutlen=10
		augroup FastEscape
			autocmd!
			au InsertEnter * set timeoutlen=0
			au InsertLeave * set timeoutlen=1000
		augroup END
	endif
	
endif

" Some more highlighting stuff. The first one matches whitespace at end of
" lines (we don't really like them) and the second one matches tabs, so we
" are aware of them visually ;-)
highlight WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/

highlight Tabs cterm=underline,bold term=bold,underline ctermfg=darkgrey

let g:using2match = 0
highlight WideColumns ctermbg=grey ctermfg=black guibg=grey

function <SID>Toggle2Match()
	if g:using2match == 0
		2match Tabs /\t\+/
		let g:using2match = 1
		echo "2match - Highlighting tabs"
	else
		if g:using2match == 1
			2match WideColumns /\%>80v.\+/
			let g:using2match = 2
			echo "2match - Highlighting long lines"
		else
			2match
			let g:using2match = 0
			echo "2match - disabled"
		endif
	endif
endfunction

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
		colorscheme elflord

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

		highlight CursorLine   NONE
		highlight CursorLine   ctermbg=235
		highlight CursorLineNr ctermbg=235 ctermfg=246
		highlight LineNr       ctermbg=234 ctermfg=238
		highlight SignColumn   ctermbg=234
	endif
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

" Checks wether a given path is readable and sources it as a Vim script.
" Very useful to load scripts only when available.
function <SID>SourceIfAvailable(path)
	if filereadable(expand(a:path))
		execute "source " . expand(a:path)
	endif
endfunction

" Command that loads the doxygen syntax file.
command! -nargs=0 Doxygen
			\ call <SID>SourceIfAvailable($VIMRUNTIME . "/../vimfiles/syntax/doxygen.vim")

" Some commands used to thrash trailing garbage in lines.
command -nargs=0 KillEolLF      call ExecuteInPlace("%s/\\r$//")
command -nargs=0 KillEolSpaces  call ExecuteInPlace("%s/[ \\t]\\+$//")
command -nargs=0 KillEolGarbage call ExecuteInPlace("%s/[ \\t\\r]\\+$//")
command -nargs=0 EolMac2Unix    call ExecuteInPlace("%s/\\r/\\n/g")
command -nargs=0 EolUnix2Mac    call ExecuteInPlace("%s/$/\\r/g")
command -nargs=0 EolUnix2DOS    call ExecuteInPlace("%s/$/\\r\\n/g")

" Exit swiftly
map __ ZZ

" A bit of commoddity to jump through source files using tags
map <C-J> :YcmCompleter GoToDefinitionElseDeclaration<CR>
map <C-T> <C-]>
map <C-S-T> :pop<CR>

" Autocomplete with <TAB> (AJ)
function InsertTabWrapper()
	let col = col('.') - 1
	if !col || getline('.')[col - 1] !~ '\k'
		return "\<tab>"
	else
		return "\<c-p>"
	endif
endfunction
inoremap <Tab>   <C-R>=InsertTabWrapper()<CR>
inoremap <S-Tab> <C-P>

" Start searching with spacebar.
map <Space> /

" F2 -> Save file
map  <F2>   :w!<CR>
imap <F2>   <ESC>:w!<CR>a

" F3 -> Toggle line numbers
nnoremap <F3> :NumbersToggle<CR>

" F4 -> Toggle secondary matches
map  <silent> <F4>   :call <SID>Toggle2Match()<CR>
imap <silent> <F4>   :call <SID>Toggle2Match()<CR>

" F5 -> Compile/build
" F6 -> Show build errors
" F7 -> Previous error
" F8 -> Next error
map  <F5>   :wall!<CR>:make<CR>
imap <F5>   <ESC>:wall!<CR>:make<CR>i
map  <F6>   :cl!<CR>
map  <F7>   :cp!<CR>
map  <F8>   :cn!<CR>

map <silent> <F9>  :previous!<CR>
map <silent> <F10> :next!<CR>

" clang-format, see http://clang.llvm.org/docs/ClangFormat.html
map <C-K> :pyf /usr/share/clang/clang-format.py<CR>
imap <C-K> <ESC>:pyf /usr/share/clang/clang-format.py<CR>i

runtime! macros/matchit.vim
NeoBundleCheck

" vim:ts=4:sw=4:fenc=utf-8
