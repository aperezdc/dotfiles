let g:python3_host_prog = '/usr/bin/python3'
let g:python_host_prog = '/usr/bin/python2'

if has('nvim') && filereadable(expand('~/.nvimrc'))
	source ~/.nvimrc
elseif filereadable(expand('~/.vimrc'))
	source ~/.vimrc
else
	" Minimal configuration
	set incsearch
	set smartcase
	set ignorecase
	set infercase
	cmap W w
	map <Space> /
	map __ ZZ
	syntax on
	filetype indent plugin on
	colorscheme elflord
endif
