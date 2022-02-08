" Disable some built-in plug-ins which I never use.
let g:loaded_2html_plugin = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_logipat = 1
let g:loaded_vimballPlugin = 1

augroup vimrc
	autocmd!
augroup END

source ~/.vim/plugx.vim

PluginBegin
Plugin 'aperezdc/vim-elrond', '~/devel/vim-elrond'
Plugin 'aperezdc/vim-lining', '~/devel/vim-lining'
Plugin 'aperezdc/vim-template', '~/devel/vim-template'
Plugin 'nvim-lua/popup.nvim'
Plugin 'nvim-lua/plenary.nvim'
Plugin 'nvim-telescope/telescope.nvim'
Plugin 'gbrlsnchs/telescope-lsp-handlers.nvim'
Plugin 'seblj/nvim-echo-diagnostics'
Plugin 'hrsh7th/nvim-compe'
Plugin 'mfussenegger/nvim-lint'
Plugin 'tamago324/compe-zsh'
Plugin 'docunext/closetag.vim', { 'for': ['html', 'xml'] }
Plugin 'ledger/vim-ledger'
Plugin 'justinmk/vim-dirvish'
Plugin 'nelstrom/vim-visual-star-search'
Plugin 'pbrisbin/vim-mkdir'
Plugin 'fcpg/vim-shore'
Plugin 'lluchs/vim-wren'
Plugin 'sgur/vim-editorconfig'
Plugin 'sheerun/vim-polyglot'
Plugin 'tmux-plugins/vim-tmux'
" Plugin 'roxma/vim-tmux-clipboard'
Plugin 'weakish/rcshell.vim'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-scripts/a.vim'
Plugin 'rhysd/clever-f.vim'
Plugin 'janet-lang/janet.vim'
Plugin 'neovim/nvim-lspconfig'
Plugin 'folke/lsp-colors.nvim'
Plugin 'mhinz/vim-grepper'
Plugin 'janet-lang/janet.vim'
Plugin 'kergoth/vim-bitbake'
PluginEnd

colorscheme elrond
filetype indent plugin on
syntax on

set completeopt=menuone,noselect
set clipboard+=unnamedplus
set exrc
set shiftwidth=4
set tabstop=4
set hidden
set incsearch
set inccommand=nosplit
set breakindent
set updatetime=250
set smartcase
set ignorecase
set noinfercase
set nohlsearch
set linebreak
set textwidth=78
set colorcolumn=81
set encoding=utf-8
set scrolloff=3
set sidescrolloff=5
set nowrap
set whichwrap+=[,],<,>
set wildignore+=*.o,*.a,a.out
set shortmess+=c
set ruler
set timeout           " for mappings
set timeoutlen=1000   " default value
set ttimeout          " for key codes
set ttimeoutlen=10    " unnoticeable small value
set guicursor=

if !has('nvim')
	set ttymouse=sgr
endif

if executable('rg')
	set grepprg=rg\ -S\ --no-heading\ --vimgrep
	if Have('ack.vim')
		let g:ackprg = 'rg -S --no-heading --vimgrep'
		let g:ack_use_cword_for_empty_search = 1
	endif
endif

" Persistent undo!
if !isdirectory(expand('~/.cache/vim/undo'))
	call system('mkdir -p ' . shellescape(expand('~/.cache/vim/undo')))
endif
set undodir=~/.cache/vim/undo
set undofile

for mapmode in ['n', 'vnore', 'i', 'c', 'l', 't']
	execute mapmode.'map <silent> [1;5A <C-Up>'
	execute mapmode.'map <silent> [1;5B <C-Down>'
	execute mapmode.'map <silent> [1;5C <C-Right>'
	execute mapmode.'map <silent> [1;5D <C-Left>'
	execute mapmode.'map <silent> [1;3A <M-Up>'
	execute mapmode.'map <silent> [1;3B <M-Down>'
	execute mapmode.'map <silent> [1;3C <M-Right>'
	execute mapmode.'map <silent> [1;3D <M-Left>'
endfor
unlet mapmode

" Cannot live without these.
command! -nargs=0 -bang Q q<bang>
command! -nargs=0 -bang W w<bang>
command! -nargs=0 -bang Wq wq<bang>
command! -nargs=0 B b#

" Convenience mappings.
map <C-t> <C-]>
map <C-p> :pop<cr>
map <Space> /
map __ ZZ

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
vnoremap < <gv
vnoremap > >gv

nnoremap H :bprevious<CR>
nnoremap L :bnext<CR>

" Highlight word below the cursor.
" https://stackoverflow.com/questions/6876850/how-to-highlight-all-occurrences-of-a-word-in-vim-on-double-clicking
nnoremap <silent> <leader>+ :execute 'highlight DoubleClick ctermbg=green ctermfg=black<bar>match DoubleClick /\V\<'.escape(expand('<cword>'), '\').'\>/'<cr>
nnoremap <silent> <leader>- :match none<cr>

" Manually re-format a paragraph of text
nnoremap <silent> Q gwip

" See https://stackoverflow.com/questions/1444322/how-can-i-close-a-buffer-without-closing-the-window#8585343
map <silent> <leader>q :bp<bar>sp<bar>bn<bar>bd<CR>

" Make . work with visually selected lines
vnoremap . :norm.<cr>

" Make <C-u> and <C-w> generate new undolist entries.
" Tip from: http://vim.wikia.com/wiki/Recover_from_accidental_Ctrl-U
inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>

" Alt+{arrow} for window movements
nnoremap <silent> <M-Left>  <C-w><C-h>
nnoremap <silent> <M-Down>  <C-w><C-j>
nnoremap <silent> <M-Up>    <C-w><C-k>
nnoremap <silent> <M-Right> <C-w><C-l>

" Always make n/N search forward/backwar, regardless of the last search type.
" From https://github.com/mhinz/vim-galore
nnoremap <expr> n 'Nn'[v:searchforward]
nnoremap <expr> N 'nN'[v:searchforward]

" Make <C-n> and <C-p> respect already-typed content in command mode.
" From https://github.com/mhinz/vim-galore
cnoremap <c-n> <down>
cnoremap <c-p> <up>

" https://vim.fandom.com/wiki/Make_C-Left_C-Right_behave_as_in_Windows
nnoremap <C-Left>  b
nnoremap <C-Right> w
nnoremap <C-Up>    [[
nnoremap <C-Down>  ]]

" Jump to the last edited position in the file being loaded (if available)
autocmd vimrc BufReadPost *
	\ if line("'\"") > 0 && line("'\"") <= line("$") |
	\       execute "normal g'\"" |
	\ endif

" Make it easier to use :terminal
if exists(':terminal')
	" Entering/Leaving terminal buffers changes from/to insert mode automatically.
	autocmd vimrc BufEnter term://* startinsert
	autocmd vimrc BufLeave term://* stopinsert

	" Allow using Alt+{arrow} to navigate *also* out from terminal buffers.
	tnoremap <silent> <M-Left>  <C-\><C-n><C-w><C-h>
	tnoremap <silent> <M-Down>  <C-\><C-n><C-w><C-j>
	tnoremap <silent> <M-Up>    <C-\><C-n><C-w><C-k>
	tnoremap <silent> <M-Right> <C-\><C-n><C-w><C-l>

	" Make Ctrl-Shift-q exit insert mode.
	tnoremap <silent> <C-S-q>   <C-\><C-n>
endif

" Ctrl-C does not trigger InsertLeave, remap it through Escape.
inoremap <C-c> <Esc>

" Alternate mapping for increasing/decreasing numbers.
nnoremap <S-Up>   <C-x>
nnoremap <S-Down> <C-a>

" Open location/quickfix window whenever a command is executed and the
" list gets populated with at least one valid location.
autocmd vimrc QuickFixCmdPost [^l]* cwindow
autocmd vimrc QuickFixCmdPost    l* lwindow

" Plugin: templates (probably others as well)  {{{1
let g:user = 'Adrian Perez de Castro'
let g:email = 'aperez@igalia.com'
" 1}}}

" Plugin: nvim-hardline  {{{1
if Have('nvim-hardline')
lua <<EOS
	require("hardline").setup {theme = "default"}
EOS
endif
" 1}}}

" Plugin: editorconfig  {{{1
let g:editorconfig_blacklist = {
	\ 	'filetype': ['git.*', 'fugitive']
	\ }
" }}}1

" Plugin: shore  {{{1
let g:shore_stayonfront = 1
" 1}}}

" Plugin: telescope {{{1
if Have('telescope.nvim')
	nnoremap <silent> <leader>f    <cmd>Telescope find_files<cr>
	nnoremap <silent> <leader>F    <cmd>Telescope git_files<cr>
	nnoremap <silent> <leader>m    <cmd>Telescope oldfiles<cr>
	nnoremap <silent> <leader>b    <cmd>Telescope buffers<cr>
	nnoremap <silent> <leader>t    <cmd>Telescope builtin<cr>
	nnoremap <silent> <leader><F1> <cmd>Telescope help_tags<cr>
	nmap <C-A-p>  <leader>f
	nmap <C-A-g>  <leader>F
	nmap <A-cr>   <leader>m
	nmap <C-A-b>  <leader>b
	nmap <F12>    <leader>b
	nmap <C-A-cr> <leader>t
lua <<EOS
require("telescope").setup {
	defaults = {
		previewer = false,
	},
	extensions = {
		lsp_handlers = {
			code_action = {
					telescope = require("telescope.themes").get_dropdown {},
				},
			},
		},
	}
EOS
	if Have('telescope-lsp-handlers.nvim')
		lua require('telescope').load_extension('lsp_handlers')
	endif
endif " 1}}}

" Plugin: vale  {{{1
if Have('nvim-lint')
	autocmd vimrc BufWritePost <buffer> lua require("lint").try_lint()
endif
" 1}}}

lua <<EOS
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    signs = true,
    update_in_insert = false,
  }
)
EOS

" Plugin: lspconfig  {{{1
if Have('nvim-lspconfig')
lua <<EOS
	local lsp_attach = function (client, bufnr)
		local set_keymap = function (...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
		local set_option = function (...) vim.api.nvim_buf_set_option(bufnr, ...) end
		local opts = {noremap = true, silent = true}

		local use_telescope, _ = pcall(require, "telescope")
		if use_telescope then
			set_keymap("n", "gT", "<cmd>Telescope lsp_type_definitions<CR>", opts)
			set_keymap("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
			set_keymap("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
			set_keymap("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
			set_keymap("n", "la", "<cmd>Telescope lsp_code_actions<CR>", opts)
			set_keymap("n", "ld", "<cmd>Telescope lsp_document_diagnostics<CR>", opts)
			set_keymap("n", "ls", "<cmd>Telescope lsp_document_symbols<CR>", opts)
			set_keymap("n", "Wd", "<cmd>Telescope lsp_workspace_diagnostics<CR>", opts)
			set_keymap("n", "Ws", "<cmd>Telescope lsp_workspace_symbols<CR>", opts)
		else
			set_keymap("n", "gT", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
			set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
			set_keymap("n", "gR", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
			set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
		end
		set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
		set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
		set_keymap("i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)

		set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
		set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
		set_keymap("n", "sd", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
		set_keymap("n", "fd", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)

		set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
	end

	local lspc = require "lspconfig"
	-- lspc.clangd.setup {on_attach = lsp_attach}
	-- lspc.ccls.setup {on_attach = lsp_attach, cmd = {"ccls", "-v=0"}}
	lspc.clangd.setup {
		on_attach = lsp_attach,
		cmd = {"clangd", "--background-index", "--enable-config", "--completion-style=detailed", "-j=2", "--log=error"},
		init_options = {
			clangdFileStatus =  true,
		},
	}

	lspc.serve_d.setup {on_attach = lsp_attach}
	lspc.pyright.setup {on_attach = lsp_attach}
	-- lspc.jedi_language_server.setup {on_attach = lsp_attach}

	lspc.cmake.setup {on_attach = lsp_attach}

	lspc.sumneko_lua.setup {
		on_attach = lsp_attach,
		cmd = {"lua-language-server"},
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
					path = (function ()
						local rtp = vim.split(package.path, ";")
						table.insert(rtp, "lua/?.lua")
						table.insert(rtp, "lua/?/init.lua")
						return rtp
					end)(),
				},
				diagnostics = {
					globals = {"vim"},
				},
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
				},
				telemetry = {
					enable = false,
				},
			},
		},
	}
EOS
endif
" 1}}}

" Plugin: compe + fallback  {{{1
if Have('nvim-compe')
lua <<EOS
	local compe = require "compe"
	compe.setup {
		autocomplete = false,
		min_length = 3,
		source = {
			path = true,
			buffer = true,
			calc = false,
			nvim_lsp = true,
			nvim_lua = true,
			vsnip = false,
			ultisnips = false,
			luasnip = false,
			emoji = false,
			spell = false,
			zsh = true,
		},
	}

	local t = function(str)
	  return vim.api.nvim_replace_termcodes(str, true, true, true)
	end

	local check_back_space = function()
		local col = vim.fn.col('.') - 1
		return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
	end

	-- Use (s-)tab to:
	--- move to prev/next item in completion menuone
	--- jump to prev/next snippet's placeholder
	_G.tab_complete = function()
	  if vim.fn.pumvisible() == 1 then
		return t "<C-n>"
	  -- elseif vim.fn['vsnip#available'](1) == 1 then
	  --  return t "<Plug>(vsnip-expand-or-jump)"
	  elseif check_back_space() then
		return t "<Tab>"
	  else
		return vim.fn['compe#complete']()
	  end
	end
	_G.s_tab_complete = function()
	  if vim.fn.pumvisible() == 1 then
		return t "<C-p>"
	  -- elseif vim.fn['vsnip#jumpable'](-1) == 1 then
	  --  return t "<Plug>(vsnip-jump-prev)"
	  else
		-- If <S-Tab> is not working in your terminal, change it to <C-h>
		return t "<S-Tab>"
	  end
	end

	vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
	vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
	vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
	vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
	vim.api.nvim_set_keymap("i", "<CR>", "compe#confirm('<CR>')", {expr = true, noremap = true})
	vim.api.nvim_set_keymap("i", "<C-e>", "compe#close('<C-e>')", {expr = true, noremap = true})
	vim.api.nvim_set_keymap("i", "<C-f>", "compe#scroll({'delta': +4})", {expr = true, noremap = true})
	vim.api.nvim_set_keymap("i", "<C-d>", "compe#scroll({'delta': -4})", {expr = true, noremap = true})
EOS
else
	function! s:check_backspace() abort
		let l:column = col('.') - 1
		return !l:column || getline('.')[l:column - 1] =~# '\s'
	endfunction

	function! s:trigger_completion() abort
		if &omnifunc !=# ''
			let b:complete_p = 0
			return "\<C-x>\<C-o>"
		elseif &completefunc !=# ''
			let b:complete_p = 1
			return "\<C-x>\<C-u>"
		else
			let b:complete_p = 1
			return "\<C-x>\<C-p>"
		endif
	endfunction

	inoremap <silent><expr> <S-Tab>
				\ pumvisible() ? "\<C-p>" : "\<C-h>"

	inoremap <silent><expr> <Tab>
				\ pumvisible() ? (get(b:, 'complete_p', 1) ? "\<C-p>" : "\<C-n>") :
				\ <sid>check_backspace() ? "\<Tab>" :
				\ "\<C-p>"

	inoremap <silent><expr> <C-Space>
				\ <sid>trigger_completion()
	inoremap <silent><expr> <CR>
				\ pumvisible() ? "\<C-y>" : "\<CR>"
endif
" 1}}}

" Plugin: lsp-colors {{{1
if Have('lsp-colors.nvim')
lua <<EOS
	require("lsp-colors").setup({
	  Error = "#db4b4b",
	  Warning = "#e0af68",
	  Information = "#0db9d7",
	  Hint = "#10B981"
	})
EOS
endif " 1}}}

" Plugin: grepper {{{1
if Have('vim-grepper')
	let g:grepper = {
				\   'dir': 'repo,filecwd,cwd',
				\ }
	nnoremap <leader>* :Grepper -cword -noprompt<cr>
endif " 1}}}

" vim:set fdm=marker:
