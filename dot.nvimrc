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
Plugin 'seblj/nvim-echo-diagnostics'
Plugin 'ibhagwan/fzf-lua', { 'branch': 'main' }
Plugin 'j-hui/fidget.nvim'

Plugin 'docunext/closetag.vim', { 'for': ['html', 'xml'] }
Plugin 'ledger/vim-ledger'
Plugin 'justinmk/vim-dirvish'
Plugin 'nelstrom/vim-visual-star-search'
Plugin 'pbrisbin/vim-mkdir'
Plugin 'fcpg/vim-shore'
Plugin 'lluchs/vim-wren'
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

set completeopt=longest,menu,menuone
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
if !isdirectory(expand('~/.cache/nvim/undo'))
	call system('mkdir -p ' . shellescape(expand('~/.cache/nvim/undo')))
endif
set undodir=~/.cache/nvim/undo
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

" Plugin: fzf-lua  {{{1
if Have('fzf-lua')
    nnoremap <silent> <leader>f    <cmd>FzfLua files<cr>
    nnoremap <silent> <leader>F    <cmd>FzfLua git_files<cr>
    nnoremap <silent> <leader>m    <cmd>FzfLua oldfiles<cr>
    nnoremap <silent> <leader>b    <cmd>FzfLua buffers<cr>
    nnoremap <silent> <leader>t    <cmd>FzfLua builtin<cr>
    nnoremap <silent> <leader><F1> <cmd>FzfLua help_tags<cr>
    nnoremap <silent> <leader>R    <cmd>FzfLua resume<cr>
    nmap <C-A-p>  <leader>f
    nmap <C-A-g>  <leader>F
    nmap <A-cr>   <leader>m
    nmap <C-A-b>  <leader>b
    nmap <F12>    <leader>b
    nmap <C-A-cr> <leader>t
endif
" 1}}}

" Plugin: shore  {{{1
let g:shore_stayonfront = 1
" 1}}}


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

		local use_fzf_lua, _ = pcall(require, "fzf-lua")
		if use_fzf_lua then
			local key_action_map = {
				gd = "typedefs",
				gR = "references",
				gi = "implementations",
				la = "code_actions",
				ld = "document_diagnostics",
				ls = "document_symbols",
				Wd = "workspace_diagnostics",
				Ws = "workspace_symbols",
			}
			for keys, action in pairs(key_action_map) do
				set_keymap("n", keys, "<cmd>FzfLua lsp_" .. action .. "<cr>", opts)
			end
		else
			set_keymap("n", "gT", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
			set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
			set_keymap("n", "gR", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
			set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
		end
		set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
		set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
		set_keymap("i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)

		set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
		set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
		set_keymap("n", "sd", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
		set_keymap("n", "fd", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

		set_option("formatexpr", "v:lua.vim.lsp.formatexpr()")
		set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
	end

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	local has_cmp_lsp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
	if has_cmp_lsp then
		capabilities = cmp_lsp.default_capabilities()
	end

	local lspc = require "lspconfig"

	--[[
	lspc.ccls.setup {
		on_attach = lsp_attach,
		capabilities = capabilities,
		cmd = {"ccls", "-v=0"},
	}
	]]

	lspc.clangd.setup {
		on_attach = lsp_attach,
		capabilities = capabilities,
		cmd = {"clangd", "--background-index", "--enable-config", "--completion-style=detailed", "-j=2", "--log=error"},
		init_options = {
			clangdFileStatus =  true,
		},
	}

	lspc.serve_d.setup {on_attach = lsp_attach, capabilities = capabilities}
	lspc.pyright.setup {on_attach = lsp_attach, capabilities = capabilities}
	lspc.cmake.setup {on_attach = lsp_attach, capabilities = capabilities}
	lspc.prosemd_lsp.setup {on_attach = lsp_attach, capabilities = capabilities}

	lspc.lua_ls.setup {
		on_attach = lsp_attach,
		capabilities = capabilities,
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

" Plugin: cmp + fallback  {{{1
if Have('nvim-cmp')
lua <<EOS
	local has_words_before = function()
		local line, col = unpack(vim.api.nvim_win_get_cursor(0))
		return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
	end

	local cmp = require "cmp"
	cmp.setup {
		completion = {
			-- autocomplete = false,
			keyword_length = 3,
		},
		mapping = {
			["<Tab>"] = cmp.mapping(function(fallback)
				if not cmp.select_next_item() then
					if vim.bo.buftype ~= "prompt" and has_words_before() then
						cmp.complete()
					else
						fallback()
					end
				end
			end, {"i", "s"}),

			["<S-Tab>"] = cmp.mapping(function()
				if not cmp.select_prev_item() then
					if vim.bo.buftype ~= "prompt" and has_words_before() then
						cmp.complete()
					else
						fallback()
					end
				end
			end, {"i", "s"}),

			["<CR>"] = cmp.mapping {
				i = cmp.mapping.confirm {
					behavior = cmp.ConfirmBehavior.Replace,
					select = false,
				},
				c = function(fallback)
					if cmp.visible() then
						cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
					else
						fallback()
					end
				end,
			},
		},
		sources = cmp.config.sources({
			{ name = "nvim_lsp_signature_help" },
			{ name = "nvim_lsp" },
			{ name = "zsh" },
			{ name = "path" },
		}, {
			{ name = "buffer" },
		}),
		view = {
			entries = {
				name = "custom",
				selection_order = "near_cursor",
			},
		},
	}

	--[[
	for _, cmd_type in ipairs {"/", "?"} do
		cmp.setup.cmdline(cmd_type, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "nvim_lsp_document_symbol" },
				{ name = "cmdline_history" },
			})
		})
	end
	for _, cmd_type in ipairs {":", "@"} do
		cmp.setup.cmdline(cmd_type, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "cmdline_history" },
				{ name = "cmdline" },
			})
		})
	end
	]]

	-- Zsh completion
	local has_cmp_zsh, cmp_zsh = pcall(require, "cmp_zsh")
	if has_cmp_zsh then
		cmp_zsh.setup {
			filetypes = {"zsh"},
		}
	end
EOS
else
	function! s:check_backspace() abort
		let l:column = col('.') - 1
		return !l:column || getline('.')[l:column - 1] =~# '\s'
	endfunction

	set completeopt=longest,menu

	function! s:trigger_completion() abort
		if &omnifunc !=# ''
			return "\<C-x>\<C-o>"
		elseif &completefunc !=# ''
			return "\<C-x>\<C-u>"
		else
			return "\<C-x>\<C-p>"
		endif
	endfunction

	inoremap <silent><expr> <S-Tab>
				\ pumvisible() ? "\<C-p>" : "\<C-h>"

	inoremap <silent><expr> <Tab>
				\ pumvisible() ? "\<C-n>" :
				\ <sid>check_backspace() ? "\<Tab>" : "\<C-n>"

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

if Have("fidget.nvim")
	lua require "fidget".setup()
endif

" vim:set fdm=marker:
