set nocompatible

if !isdirectory(expand('~/.vim/bundle/dein.vim'))
	!mkdir -p ~/.vim/bundle && git clone https://github.com/Shougo/dein.vim ~/.vim/bundle/dein.vim
endif

set runtimepath+=~/.vim/bundle/dein.vim

let s:local_plugs = []

function! s:plug(name, ...)
    let dirname = fnamemodify(a:name, ':t')
    let path = expand('~/devel/' . dirname)
    let opts = len(a:000) > 0 ? a:1 : {}
    if isdirectory(path)
        call add(s:local_plugs, dirname)
    else
        call dein#add(a:name, opts)
    endif
endfunction

call dein#begin('~/.vim/bundle', [expand('<sfile>')])
call s:plug('tpope/vim-sensible', {'if': '!has("nvim")'})
call s:plug('tpope/vim-fugitive')
call s:plug('tpope/vim-commentary')
call s:plug('tpope/vim-characterize')
call s:plug('tpope/vim-eunuch')
call s:plug('tpope/vim-sleuth')
call s:plug('tpope/vim-surround')
call s:plug('justinmk/vim-dirvish')

call s:plug('aperezdc/vim-elrond', {'merged': 0})
call s:plug('aperezdc/vim-lining')
call s:plug('aperezdc/vim-template')
call s:plug('aperezdc/hipack-vim')

call s:plug('ledger/vim-ledger')
call s:plug('cespare/vim-toml')

call s:plug('junegunn/fzf', {'merged': 0})
call s:plug('junegunn/fzf.vim', {'merged': 0})

if has('nvim')
    call s:plug('Shougo/deoplete.nvim')
    call s:plug('Shougo/neco-vim')
    call s:plug('Shougo/neco-syntax')
    call s:plug('Shougo/neoinclude.vim')
    call s:plug('zchee/deoplete-jedi')
    call s:plug('zchee/deoplete-clang')
    call s:plug('zchee/deoplete-zsh')
    call s:plug('carlitux/deoplete-ternjs')
else
    if v:version < 800
        call s:plug('aperezdc/vim-lift')
    else
        call s:plug('maralla/completor.vim', {'build': 'make js'})
    endif
endif

if !dein#tap('completor.vim')
    call s:plug('racer-rust/vim-racer')
endif

call s:plug('romainl/vim-qf')
call s:plug('romainl/vim-qlist')
call s:plug('yssl/QFEnter')
call s:plug('mhinz/vim-grepper')
call s:plug('tpope/vim-repeat')
call s:plug('pbrisbin/vim-mkdir')
call s:plug('wellle/targets.vim')
call s:plug('indentpython')
call s:plug('a.vim')
call s:plug('ConradIrwin/vim-bracketed-paste')
call s:plug('jamessan/vim-gnupg')
call s:plug('wting/rust.vim')
" call s:plug('haya14busa/incsearch.vim')
" call s:plug('haya14busa/incsearch-fuzzy.vim')
call s:plug('junegunn/vim-easy-align')
call s:plug('Shougo/dein.vim')

call s:plug('vim-pandoc/vim-pandoc')
call s:plug('vim-pandoc/vim-pandoc-syntax')
call s:plug('thirtythreeforty/lessspace.vim')

if len(s:local_plugs)
    call dein#local('~/devel', {'frozen': 1}, s:local_plugs)
endif
unlet s:local_plugs
delfunction s:plug

call dein#add('/usr/share/myrddin/vim', {
            \ 'name': 'myrddin.vim',
            \ 'if': isdirectory('/usr/share/myrddin/vim'),
            \ 'frozen': 1 })

call dein#end()
if dein#check_install()
    call dein#install()
endif

set nobomb
set exrc
set secure
set hidden
set nohlsearch
set ignorecase
set smartcase
set infercase
set linebreak
set tabstop=4
set shiftwidth=4
set textwidth=78
set colorcolumn=81
set encoding=utf-8
set titlelen=0
set titlestring=[%t]%m
set nowrap
set whichwrap+=[,],<,>
set wildmode=longest,list:longest,full
set wildignore+=*.o,*.a,a.out
set sessionoptions-=options

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

if dein#tap('vim-elrond')
    colorscheme elrond
else
    colorscheme elflord
endif

if executable('rg')
	set grepprg=rg\ --vimgrep
elseif executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor\ --ignore-case\ --column
    set grepformat=%f:%l:%c:%m,%f:%l:%m
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

command! -nargs=0 -bang Q q<bang>
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

" Try to show cursorline only in windows which have focus.
autocmd vimrc WinEnter,FocusGained * set cursorline
autocmd vimrc WinLeave,FocusLost * set nocursorline

" Open location/quickfix window whenever a command is executed and the
" list gets populated with at least one valid location.
autocmd vimrc QuickFixCmdPost [^l]* cwindow
autocmd vimrc QuickFixCmdPost    l* lwindow

" Select whatever has just been pasted or read with :read!
nnoremap gV `[V`]

" Switch between the current and the last visited buffer.
nnoremap <silent> <S-Tab> :b#<cr>

" Make . work with visually selected lines
vnoremap . :norm.<cr>

" Alt-{arrow} for window movements
nnoremap <silent> <M-Left>  <C-w>h
nnoremap <silent> <M-Down>  <C-w>j
nnoremap <silent> <M-Up>    <C-w>k
nnoremap <silent> <M-Right> <C-w>l

" Manually re-format a paragraph of text
nnoremap <silent> Q gwip

" For coherency with C/D
cmap Y y$

" Forgot root?
if executable('doas')
    cmap w!! w !doas tee % > /dev/null
elseif executable('sudo')
    cmap w!! w !sudo tee % > /dev/null
endif

" Works with the default Vim Markdown support files
let g:markdown_fenced_languages = ['html', 'c', 'lua', 'bash=sh']

let g:email = 'aperez@igalia.com'
let g:user  = 'Adrian Perez'

" Plugin: racer
if executable('racer')
	let g:racer_cmd = 'racer'
endif

" Plugin: fzf
if dein#tap('fzf.vim')
    let g:fzf_buffers_jump = 0
    nnoremap <silent> <Leader>f :<C-u>Files<cr>
    nnoremap <silent> <Leader>F :<C-u>GitFiles<cr>
    nnoremap <silent> <Leader>m :<C-u>History<cr>
    nnoremap <silent> <Leader>b :<C-u>Buffers<cr>
    nnoremap <silent> <Leader><F1> :<C-u>Helptags<cr>
elseif dein#tap('denite.nvim')
    call denite#custom#source('_', 'matchers', ['matcher_fuzzy'])
    call denite#custom#source('file_mru', 'converters', ['converter_relative_word'])

    call denite#custom#alias('source', 'file_rec/git', 'file_rec')
    call denite#custom#var('file_rec/git', 'command', 
                \ ['git', 'ls-files', '-co', '--exclude-standard'])

    if executable('rg')
        call denite#custom#var('file_rec', 'command', ['rg', '--files'])
        call denite#custom#var('grep', 'command', ['rg'])
        call denite#custom#var('grep', 'recursive_opts', [])
        call denite#custom#var('grep', 'final_opts', [])
        call denite#custom#var('grep', 'separator', ['--'])
        call denite#custom#var('greo', 'default_opts', ['--vimgrep', '--no-heading'])
    endif

    nnoremap <silent> <Leader>b :<C-u>Denite buffer<cr>
    nnoremap <silent> <Leader>m :<C-u>Denite file_mru<cr>
    nnoremap <silent> <Leader>f :<C-u>Denite file_rec<cr>
    nnoremap <silent> <Leader>F :<C-u>Denite file_rec/git<cr>
endif

nmap <C-A-p> <leader>f
nmap <C-A-m> <leader>m
nmap <C-A-b> <leader>b

if dein#tap('vim-lift')
    " Plugin: Lift
    inoremap <expr> <Tab>  lift#trigger_completion()
    inoremap <expr> <Esc>  pumvisible() ? "\<C-e>" : "\<Esc>"
    inoremap <expr> <CR>   pumvisible() ? "\<C-y>" : "\<CR>"
    inoremap <expr> <Down> pumvisible() ? "\<C-n>" : "\<Down>"
    inoremap <expr> <Up>   pumvisible() ? "\<C-p>" : "\<Up>"
    inoremap <expr> <C-d>  pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
    inoremap <expr> <C-u>  pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"
else
    function! s:completor_tab(direction, or_keys)
        if pumvisible()
            if a:direction < 0
                return "\<C-p>"
            else
                return "\<C-n>"
            endif
        else
            return a:or_keys
        endif
    endfunction
    inoremap <expr> <Tab>   <SID>completor_tab(1, "\<Tab>")
    inoremap <expr> <S-Tab> <SID>completor_tab(-1, "\<S-Tab>")

    if dein#tap('completor.vim')
        let g:completor_python_binary = '/usr/bin/python3'
        let g:completor_racer_binary = '/usr/bin/racer'
        let g:completor_clang_binary = '/usr/bin/clang'
        let g:completor_node_binary = '/usr/bin/node'
        let g:completor_disable_ultisnips = 1
        let g:completor_min_chars = 3
    elseif dein#tap('deoplete.nvim')
        let g:deoplete#enable_at_startup = 1
        call deoplete#custom#set('buffer', 'min_pattern_length', 3)
        if dein#tap('deoplete-clang')
            let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
            let g:deoplete#sources#clang#clang_header = '/usr/lib/clang'
        endif
    endif
endif

" Plugin: insearch + insearch-fuzzy
map <Space>  <Plug>(incsearch-forward)
map /        <Plug>(incsearch-forward)
map ?        <Plug>(incsearch-backward)
map g/       <Plug>(incsearch-stay)
map z<Space> <Plug>(incsearch-fuzzyspell-/)
map z/       <Plug>(incsearch-fuzzyspell-/)
map z?       <Plug>(incsearch-fuzzyspell-?)
map zg/      <Plug>(incsearch-fuzzyspell-stay)

highlight Flashy term=reverse cterm=reverse

" Plugin: expand-region
map <CR>        <Plug>(expand_region_expand)
map <Backspace> <Plug>(expand_region_shrink)

" Plugin: Grepper
let g:grepper = {
            \   'tools': ['rg', 'git', 'grep'],
            \   'simple_prompt': 1
            \ }
nmap gs  <Plug>(GrepperOperator)
xmap gs  <Plug>(GrepperOperator)
nnoremap <leader>* :Grepper -tool rg -cword -noprompt<cr>
nnoremap <leader>g :Grepper -tool rg<cr>
nnoremap <leader>G :Grepper -tool git<cr>

" Plugin: qf
nmap <F5>   <Plug>QfSwitch
nmap <F6>   <Plug>QfCtoggle
nmap <F7>   <Plug>QfCprevious
nmap <F8>   <Plug>QfCnext
nmap <C-F6> <Plug>QfLtoggle
nmap <C-F7> <Plug>QfLprevious
nmap <C-F8> <Plug>QfLnext
