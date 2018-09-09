" Author: Adrian Perez de Castro <aperez@igalia.com>
" License: MIT

if exists('g:loaded_plugx')
	finish
endif
let g:loaded_plugx = 1

let s:save_cpo = &cpo
set cpo&vim

let s:string_type = type('')
let s:dict_type = type({})

function s:plugx(repo, ...)
	if a:0 > 2
		echohl ErrorMsg
		echom '[plugx] Invalid number of arguments: ' . (a:0 + 1)
		echohl None
		return
	endif

	let localpath = ''
	let opts = {}

	if a:0 > 0
		if a:0 == 2
			let localpath = a:000[0]
			let opts = a:000[1]
		elseif type(a:000[0]) == s:string_type
			let localpath = a:000[0]
		elseif type(a:000[0]) == s:dict_type
			let opts = a:000[0]
		else
			echoerr '[plugx] Expected string or dict for parameter #2'
			return
		endif
	endif

	if localpath ==# ''
		" No local directory, pass along options to vim-plug directly.
		return plug#(a:repo, opts)
	endif

	let plugname = fnamemodify(a:repo, ':t')
	let dirname = fnamemodify(localpath, ':t')
	if dirname !=# plugname
		echoerr '[plugx] Plugin names do not match:' plugname '/' dirname
		return
	endif

	let path = fnamemodify(localpath, ':p')
	if isdirectory(path)
		" Ensure that local plugins are always marked as frozen.
		let opts.frozen = 1
		call plug#(path, opts)
	else
		call plug#(a:repo, opts)
	endif
endfunction

function Have(name)
	return has_key(g:, 'plugs') && has_key(get(g:, 'plugs'), a:name)
endfunction


if filereadable(expand('~/.vim/plug.vim'))
	source ~/.vim/plug.vim
	command! -nargs=+ -bar Plugin call s:plugx(<args>)
	command -nargs=0 PluginBegin call plug#begin('~/.vim/bundle')
	command -nargs=0 PluginEnd call plug#end()
else
	function s:noop(...)
	endfunction

	command -nargs=0 PluginEnd call s:noop()
	command -nargs=0 PluginBegin call s:noop()
	command -nargs=+ -bar Plugin call s:noop(<args>)

	function s:plugfetch()
		!curl -fLo ~/.vim/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	endfunction

	command -nargs=0 PlugUpgrade call s:plugfetch()
	echom '[plug-bootstrap] Use :PlugUpgrade to install vim-plug'
endif

let &cpo = s:save_cpo
unlet s:save_cpo
