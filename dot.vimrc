set nocompatible
set nobomb
set exrc
set secure
set hidden
set ignorecase
set smartcase
set infercase
set linebreak
set tabstop=4
set shiftwidth=4
set encoding=utf-8
set titlelen=0
set titlestring=[%t]%m
set whichwrap+=[,],<,>

if len($DISPLAY)
	set clipboard+=unnamed
endif

filetype indent plugin on
syntax on

if filereadable(expand('~/.vim/bundle/unbundle/plugin/unbundle.vim'))
    runtime bundle/unbundle/plugin/unbundle.vim
endif

augroup vimrc
    autocmd!
augroup END

colorscheme elrond

if executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor\ --ignore-case\ --column
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

function! s:StripTrailingWhitespace()
    if !&binary && &filetype != 'diff'
        normal mz
        normal Hmy
        %s/\s+$//e
        normal 'yz<CR>
        normal `z
    endif
endfunction

command! -bar StripTrailingWhitespace silent call <SID>StripTrailingWhitespace()

if &term =~ "screen"
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

command! -nargs=0 -bang Q q<bang>
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

if exists('*fugitive#detect')
	autocmd vimrc FileType dirvish call fugitive#detect(@%)
endif
autocmd vimrc FileType dirvish keeppatterns g@\v/\.[^\/]+/?$@d

autocmd vimrc FileType help wincmd L

" dwm-like window movements
if has('nvim')
	nnoremap <silent> <BS>  <C-w>h
	nnoremap <silent> <NL>  <C-w>j
else
	nnoremap <silent> <C-h> <C-w>h
	nnoremap <silent> <C-j> <C-w>j
endif
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-l> <C-w>l

" Manually re-format a paragraph of text
nnoremap <silent> Q gwip

" Works with the default Vim Markdown support files
let g:markdown_fenced_languages = ['html', 'c', 'lua', 'bash=sh']

let g:email = 'aperez@igalia.com'
let g:user  = 'Adrian Perez'

" Plugin: racer
if executable('racer')
	let g:racer_cmd = 'racer'
endif

" Plugin: fzf
let g:fzf_buffers_jump = 0
nnoremap <silent> <Leader>f :<C-u>Files<cr>
nnoremap <silent> <Leader>F :<C-u>GitFiles<cr>
nnoremap <silent> <Leader>m :<C-u>History<cr>
nnoremap <silent> <Leader>b :<C-u>Buffers<cr>
nnoremap <silent> <Leader><F1> :<C-u>Helptags<cr>
nmap <C-A-p> <leader>f
nmap <C-A-m> <leader>m
nmap <C-A-b> <leader>b
