if filereadable(expand('~/.vimrc'))
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
