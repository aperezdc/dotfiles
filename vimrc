" If you prefer the old-style vim functionalty, add 'runtime! vimrc_example.vim'
" Or better yet, read /usr/share/vim/vim72/vimrc_example.vim or the vim manual
" and configure vim to your own liking!

"    ___ ___                      ___ ___ __ __
"   |   Y   .-----.--------.-----|   Y   |__|  |_
"   |.  1   |  _  |        |  -__|.  1  /|  |   _|
"   |.  _   |_____|__|__|__|_____|.  _  \|__|____|
"   |:  |   |                    |:  |   \
"   |::.|:. |  Set-up ~yourself  |::.| .  )
"   `--- ---'                    `--- ---'
"
"   Vim configuration file. This one is important!
"

let g:email = "aperez@igalia.com"
let g:user  = "Adrian Perez"

" Set options {{{1
set nocompatible			 " Use advanced features not found in Vi
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
set nottyfast             	 " Lots of console stuff that may slow down Vim
set noshowfulltag			 " Do not show full prototype of tags on completion
set showcmd					 " Show commands as they are typed
set formatoptions+=cqron1 	 " Some useful formatting options
set showmatch				 " Show matching parens
set textwidth=76             " Text is 76 columns wide
set backspace=2              " Backspace always useable in insert mode
set fileformats=unix,mac,dos " Allows automatic line-end detection.
set grepprg=grep\ -nH\ $*    " Make grep always print the file name.
set ignorecase
set infercase
set lazyredraw
set hidden
set diffopt+=iwhite
set nobackup
set tags=tags;/
set nofsync
set nosol


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
	"set foldminlines=5 		 " Don't fold stuff with less lines
	set foldmethod=indent 	 " Use syntax-aware folding
	set nofoldenable 		 " Don't enable automatic folding!
endif

if has("wildmenu")
	set wildmenu           	 " Show completions on menu over cmdline
	set wildchar=<TAB>     	 " Navigate wildmenu with tabs

	" Ignore backups and misc files for wilcompletion
	set wildignore=*.o,*.cm[ioax],*.ppu,*.core,*~,core,#*#
endif

" Configure DetectIndent plugin }}}1{{{1

let g:detectindent_preferred_expandtab = 1
let g:detectindent_preferred_indent    = 4

" Configure file-explorer }}}1{{{1

let g:explVertical     = 1       " Split windows in vertical.
let g:explSplitRight   = 1       " Put new opened windows at right.
let g:explWinSize      = 80      " New windows are 80 columns wide.
let g:explDetailedHelp = 0       " We don't need detailed help.
let g:explSortBy       = 'name'  " Sort files by their names.
let g:explDirsFirst    = 0       " Mix files and directories.

" Hide some kinds of files in file-explorer windows.
let g:explHideFiles  = '^\.,\.gz,\.exe,\.o,\.cm[oxia],\.zip,\.bz2'

" Options for the SVN-Command plugin    }}}1{{{1

let SVNCommandEdit = 'split'        " Split instead of opening a new buffer.
let SVNCommandEnableBufferSetup = 1 " Set per-buffer SVNRevision/SVNBranch

" Some folding/unfolding misc mappings  }}}1{{{1

if has("folding")
	map , zj
	"map m zk
	map - za
	map _ zA
	"map ; zi
	"map <CR> za
	"map <C-v> zA
endif

" Filetyping and autocommands  }}}1{{{1
filetype indent plugin on

if has("autocmd")
	" Tune defaults for some particular file types.
	autocmd FileType *html,xml setlocal matchpairs+=<:>
	autocmd FileType xhtml,xml let xml_use_xhtml=1
	autocmd FileType html setlocal filetype=xml | let xml_use_xhtml=1
	autocmd FileType python setlocal expandtab tabstop=4 shiftwidth=4
	autocmd FileType bzr setlocal expandtab
	autocmd FileType rst setlocal expandtab tabstop=2 shiftwidth=2
	autocmd FileType objc setlocal expandtab tabstop=4 shiftwidth=4 cinoptions+=(0
	autocmd FileType cpp setlocal expandtab tabstop=4 shiftwidth=4 cinoptions+=(0
	autocmd FileType c setlocal expandtab tabstop=4 shiftwidth=4 cinoptions+=(0

	"autocmd FileType c setlocal expandtab cinoptions+=t0(0{1s>2sn-1s^-1s
	"autocmd FileType cpp setlocal expandtab cinoptions+=t0(0{1s>2sn-1s^-1s
	"autocmd FileType objc setlocal expandtab cinoptions+=t0(0{1s>2sn-1s^-1s

	" Java 'tuning'. {{{
	autocmd FileType java setlocal errorformat=
				\%-G%.%#build.xml:%.%#,
				\%-G%.%#warning:\ %.%#,
				\%-G%\\C%.%#EXPECTED%.%#,
				\%f:%l:\ %#%m,
				\C:%f:%l:\ %m,
				\%DEntering:\ %f\ %\\=,
				\%ECaused\ by:%[%^:]%#:%\\=\ %\\=%m,
				\%ERoot\ cause:%[%^:]%#:%\\=\ %\\=%m,
				\%Ecom.%[%^:]%#:%\\=\ %\\=%m,
				\%Eorg.%[%^:]%#:%\\=\ %\\=%m,
				\%Ejava.%[%^:]%#:%\\=\ %\\=%m,
				\%Ejunit.%[%^:]%#:%\\=\ %\\=%m,
				\%-Z%\\C\ at\ com.mypkg.%.%#.test%[A-Z]%.%#(%f:%l)\ %\\=,
				\%-Z%\\C\ at\ com.mypkg.%.%#.setUp(%f:%l)\ %\\=,
				\%-Z%\\C\ at\ com.mypkg.%.%#.tearDown(%f:%l)\ %\\=,
				\%-Z%^\ %#%$,
				\%-C%.%#,
				\%-G%.%#

	" Define abbreviations for Java™ mode.
	autocmd FileType java
				\ iab Jmain public static void main(String [] args)|
				\ iab const- private static final|
				\ iab const+ public static final|
				\ iab cls- private class|
				\ iab cls+ public class|
				\ iab bool boolean|
				\ iab unsigned int
	" }}}
	" TeX error mode. {{{
	" (Note: this is *cumbersome*.)
	"
	autocmd FileType tex setlocal makeprg=
				\\pdflatex\ \\\\nonstopmode\ \\\\input\\{%} |
				\ setlocal errorformat=
				\%E!\ LaTeX\ %trror:\ %m,
				\%E!\ %m,
				\%+WLaTeX\ %.%#Warning:\ %.%#line\ %l%.%#,
				\%+W%.%#\ at\ lines\ %l--%*\\d,
				\%WLaTeX\ %.%#Warning:\ %m,
				\%Cl.%l\ %m,
				\%+C\ \ %m.,
				\%+C%.%#-%.%#,
				\%+C%.%#[]%.%#,
				\%+C[]%.%#,
				\%+C%.%#%[{}\\]%.%#,
				\%+C<%.%#>%.%#,
				\%C\ \ %m,
				\%-GSee\ the\ LaTeX%m,
				\%-GType\ \ H\ <return>%m,
				\%-G\ ...%.%#,
				\%-G%.%#\ (C)\ %.%#,
				\%-G(see\ the\ transcript%.%#),
				\%-G\\s%#,
				\%+O(%f)%r,
				\%+P(%f%r,
				\%+P\ %\\=(%f%r,
				\%+P%*[^()](%f%r,
				\%+P[%\\d%[^()]%#(%f%r,
				\%+Q)%r,
				\%+Q%*[^()])%r,
				\%+Q[%\\d%*[^()])%r
	" }}}

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

	" Use Enter key to navigate help links.
	autocmd FileType help nmap <buffer> <Return> <C-]>
endif

" Syntax highlighting (bwahahaha!)   }}}1{{{1
if has("syntax") || has("gui_running")
	syntax on
	if has("gui_running")
		colorscheme torte
	else
		colorscheme elflord
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


" Change colors of completion popup for Vim 7.
highlight Pmenu      ctermbg=grey ctermfg=black
highlight PmenuSel   cterm=bold,reverse ctermbg=black ctermfg=yellow
highlight PmenuSbar  ctermbg=blue
highlight PmenuThumb ctermfg=lightblue

" When under xterm and compatible terminals, use titles if available and
" change cursor color depending on active mode.
if &term =~ "xterm"
	if has("title")
		set title
	endif
	"if exists("&t_SI")
	"	let &t_SI = "\<Esc>]12;lightgoldenrod\x7"
	"	let &t_EI = "\<Esc>]12;grey80\x7"
	"endif
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

" Multibyte support   }}}1{{{1
" Set up things for UTF-8 text editing by default, if multibyte
" support was compiled in. Let Linux consoles be Latin-1.
if has("multi_byte")
	set encoding=utf-8
	if $TERM == "linux" || $TERM_PROGRAM == "GLterm"
		set termencoding=latin1
	endif
endif


" Functions and Commands   }}}1{{{1
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

" Encode and decode some (spanish) HTML entities. {{{2

function DecodeEntities()
	let l:rowPos = line(".")
	let l:colPos = col(".")

	" Lowercase accented vowels.
	silent! execute "%s/&aacute;/á/g"
	silent! execute "%s/&eacute;/é/g"
	silent! execute "%s/&iacute;/í/g"
	silent! execute "%s/&oacute;/ó/g"
	silent! execute "%s/&uacute;/ú/g"
	" Uppercase accented vowels.
	silent! execute "%s/&Aacute;/Á/g"
	silent! execute "%s/&Eacute;/É/g"
	silent! execute "%s/&Iacute;/Í/g"
	silent! execute "%s/&Oacute;/Ó/g"
	silent! execute "%s/&Uacute;/Ú/g"
	" Some other characters
	silent! execute "%s/&ntilde;/ñ/g"
	silent! execute "%s/&Ntilde;/Ñ/g"
	silent! execute "%s/&quot;/\""

	call cursor(l:rowPos, l:colPos)
endfunction

function EncodeEntities()
	let l:rowPos = line(".")
	let l:colPos = col(".")

	" Lowercase accented vowels.
	silent! execute "%s/á/&aacute;/g"
	silent! execute "%s/é/&eacute;/g"
	silent! execute "%s/í/&iacute;/g"
	silent! execute "%s/ó/&oacute;/g"
	silent! execute "%s/ú/&uacute;/g"
	" Uppercase accented vowels.
	silent! execute "%s/Á/&Aacute;/g"
	silent! execute "%s/É/&Eacute;/g"
	silent! execute "%s/Í/&Iacute;/g"
	silent! execute "%s/Ó/&Oacute;/g"
	silent! execute "%s/Ú/&Uacute;/g"
	" Some other characters
	silent! execute "%s/ñ/&ntilde;/g"
	silent! execute "%s/Ñ/&Ntilde;/g"
	silent! execute "%s/\"/&quot;"

	call cursor(l:rowPos, l:colPos)
endfunction

" }}}2

map __ ZZ

" A bit of commoddity to jump through source files using tags!
map <C-T> <C-]>
map <C-P> :pop<CR>

" }}}1 Autocomplete with <TAB> (AJ) {{{1

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

let g:OmniCpp_MayCompleteScope = 1

" This one works in Gnome-Terminal map omnicomplete in insert mode
imap     <NL>    <C-X><C-O>

if has("autocmd") && exists("+omnifunc")
	autocmd FileType *
				\ if &omnifunc == "" |
				\ 	setlocal omnifunc=syntaxcomplete#Complete |
				\ endif
endif


" }}}1 Python documentation {{{1

command -nargs=1 PyHelp :call ShowPyDoc("<args>")
function ShowPyDoc(module)
	:execute ":new"
	:execute ":read ! pydoc " . a:module
	:execute ":0"
	setlocal readonly buftype=nowrite filetype=man
endfunction

" }}}1 Key Mappings {{{1

" Start searching with spacebar.
map <Space> /

" Easy navegation for multiple loaded buffers.
map <C-n> :bnext<CR>
map <C-b> :bprev<CR>

" Go to next unfilled field of a RFC822 message.
map! <C-g> <ESC>/: ?$<ESC>A

" F2 -> Save file
map  <F2>   :w!<CR>
imap <F2>   <ESC>:w!<CR>a

" Shift+F2 -> Enable doxygen mode.
map <silent> <S-F2> :runtime syntax/doxygen.vim<CR>


" F3 -> Toggle line numbers
map  <F3>   :set nu!<CR>
imap <F3>   <ESC>:set nu!<CR>i

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

map  <C-S-Left>  <ESC>:bprev<CR>
map  <C-S-Right> <ESC>:bnext<CR>

map <silent> <F9>  :previous!<CR>
map <silent> <F10> :next!<CR>

"inoremap <silent> <F11> :call VimCommanderToggle()<CR>

" F12 -> Save all and exit
map  <F12>  :xa!<CR>
map! <F12>  <ESC>:xa!<CR>

" Map Ctrl-Fxx key combos so they do activate buffers.
map <C-F1>  :buffer 1<cr>
map <C-F2>  :buffer 2<cr>
map <C-F3>  :buffer 3<cr>
map <C-F4>  :buffer 4<cr>
map <C-F5>  :buffer 5<cr>
map <C-F6>  :buffer 6<cr>
map <C-F7>  :buffer 7<cr>
map <C-F8>  :buffer 8<cr>
map <C-F9>  :buffer 9<cr>

" }}}1

runtime! macros/matchit.vim

" vim:ts=4:sw=4:foldmethod=marker:foldenable:foldminlines=1:fenc=utf-8
