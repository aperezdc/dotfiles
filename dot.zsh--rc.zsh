#! /bin/zsh

stty -ixon -ixoff

# https://www.johnhawthorn.com/2012/09/vi-escape-delays/
KEYTIMEOUT=1

# The following lines were added by compinstall
zstyle :compinstall filename '/home/aperez/.zshrc'

if [[ -r ~/devel/zz-top/everything.zsh ]] ; then
	source ~/devel/zz-top/everything.zsh
elif [[ -r ~/.zsh/zz-top/everything.zsh ]] ; then
	source ~/.zsh/zz-top/everything.zsh
else
	function zz-top {
		[[ ${1:-} != --loco ]]
	}
	function zz-top-setup {
		mkdir -p ~/.zsh
		git clone https://github.com/aperezdc/zz-top ~/.zsh/zz-top
	}
	echo 'zz-top not available, use zz-top-setup'
fi

zz-top chrissicool/zsh-256color
zz-top jreese/zsh-titles
zz-top RobSis/zsh-completion-generator
zz-top RobSis/zsh-reentry-hook
zz-top zdharma/fast-syntax-highlighting
zz-top zsh-users/zsh-history-substring-search
zz-top zsh-users/zsh-completions
zz-top zsh-users/zsh-autosuggestions
zz-top aperezdc/zsh-fzy --local ~/devel/zsh-fzy
zz-top aperezdc/zsh-notes --local ~/devel/zsh-notes
zz-top aperezdc/virtualz --local ~/devel/virtualz
zz-top aperezdc/rockz --local ~/devel/rockz
zz-top Tarrasch/zsh-autoenv


if [[ ! -d ~/.tmux/plugins/tpm ]] ; then
	echo "tpm not available, set it up with 'tpm-install' (needs Git and Internet access)"
	tpm-install () {
		mkdir -p ~/.tmux/plugins
		git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
		echo "not (re)start tmux and use 'C-b I' to install configured plugins"
		unfunction tpm-install
	}
fi

autoload -Uz compinit
compinit


function cmd-completion () {
	local name=$1
	shift
	local binpath=$(whence "${name}")
	local compfile="${HOME}/.zsh/functions/_${name}"

	compdef "_${name}" "${name}"

	# Check whether the program exists and is executable. Otherwise skip.
	if [[ -z ${binpath} || ! -x ${binpath} ]] ; then
		return
	fi

	# No need to update the completion file if it already exists and it's
	# newer than the binary for which the completions are being generated.
	if [[ -d ~/.zsh/functions && -r ${compfile} && ${compfile} -nt ${binpath} ]] ; then
		return
	fi

	# Generate.
	echo ">> Updating completion: ${binpath} $* → ${compfile})"
	mkdir -p ~/.zsh/functions
	"${binpath}" "$@" > "${compfile}"
}

cmd-completion rustup completions zsh
cmd-completion csview completion zsh
cmd-completion gh completion --shell zsh

unfunction cmd-completion  # Not needed anymore

if [[ -d ~/.zsh/functions ]] ; then
	fpath=( ~/.zsh/functions ${fpath} )
	autoload -Uz ~/.zsh/functions/*(:t)
fi

# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=${HISTSIZE}
setopt appendhistory extendedglob inc_append_history share_history \
	hist_reduce_blanks hist_ignore_space extended_history \
	hist_no_store hist_ignore_dups hist_expire_dups_first \
	hist_find_no_dups hist_ignore_all_dups nomatch
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install

# Extra functionality
autoload -U zmv

# Initialize colors.
autoload -U colors
colors

# Command line editing in $EDITOR
autoload edit-command-line && zle -N edit-command-line
bindkey '\ee' edit-command-line

# Use Alt-M to copy words other from the last from the previous line
autoload -Uz copy-earlier-word
zle -N copy-earlier-word
bindkey '\em' copy-earlier-word

# Make Escape put Zle in Vi command mode, even when in Emacs mode
bindkey '^[' vi-cmd-mode

# Make transpose-word smarter, by understanding shell escapes
autoload -Uz transpose-words-match
zstyle ':zle:transpose-words' word-style shell
zle -N transpose-words transpose-words-match


# zsh-fzy
if zz-top --loco zsh-fzy ; then
	zstyle ':fzy:*' lines 18
	zstyle ':fzy:file' command fd --type f
	zstyle ':fzy:cd'   command fd --type d
	bindkey '^F' fzy-cd-widget
	bindkey '^T' fzy-file-widget
	bindkey '^R' fzy-history-widget
	bindkey '^P' fzy-proc-widget
fi

# zsh-notes
if zz-top --loco zsh-notes ; then
	bindkey '^N' notes-edit-widget
	zstyle :notes:widget once yes
	if whence -p sk ; then
		zstyle :notes:widget picker skim
	elif whence -p fzf ; then
		zstyle :notes:widget picker fzf
	else
		zstyle :notes:widget picker fzy
	fi
	if whence -p lowdown ; then
		zstyle :notes:widget:preview enabled yes
		zstyle :notes:widget:preview command lowdown -Tterm
	elif whence -p mdcat ; then
		zstyle :notes:widget:preview enabled yes
		zstyle :notes:widget:preview command mdcat -l
	fi
fi &> /dev/null

# Bind Ctrl-Left and Ctrl-Right key sequences, and AvPag/RePag for history
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "\e[5~" history-search-backward
bindkey "\e[6~" history-search-forward

# Make AvPag/RePag work in long menu selection lists
zmodload -i zsh/complist
bindkey -M menuselect "\e[5~" backward-word
bindkey -M menuselect "\e[6~" forward-word
bindkey -M menuselect "\e"    send-break
bindkey -M menuselect '^F'    accept-and-infer-next-history
bindkey -M menuselect '/'     accept-and-infer-next-history
bindkey -M menuselect '^?'    undo
bindkey -M menuselect ' '     accept-and-hold
bindkey -M menuselect '*'     history-incremental-search-forward
bindkey -M menuselect '^C'    send-break


# Bind Delete/Begin/End for Zsh setups that do not include those by default
# (screen, tmux, rxvt...)
bindkey "^[OH"  beginning-of-line
bindkey "^[[H"  beginning-of-line
bindkey "^A"    beginning-of-line
bindkey "[1~" beginning-of-line
bindkey "^[OF"  end-of-line
bindkey "^[[F"  end-of-line
bindkey "^E"    end-of-line
bindkey "[4~" end-of-line
bindkey "^[[3~" delete-char

# Set a bunch of options :-)
setopt prompt_subst pushd_silent auto_param_slash auto_list \
	hist_reduce_blanks auto_remove_slash chase_dots \
	pushd_ignore_dups auto_param_keys \
	mark_dirs cdablevars interactive_comments glob_complete \
	print_eight_bit always_to_end glob no_warn_create_global \
	hash_list_all hash_cmds hash_dirs hash_executables_only \
	auto_continue check_jobs complete_in_word rc_quotes \
	complete_aliases
unsetopt auto_remove_slash list_ambiguous pushd_to_home

# Correct things, but not too aggressively for certain commands
setopt correct
alias ':'='nocorrect :'
alias mv='nocorrect mv'
alias man='nocorrect man'
alias sudo='nocorrect sudo'
alias exec='nocorrect exec'
alias mkdir='nocorrect mkdir'

# Bring up ${LS_COLORS}
if [ -x /usr/bin/dircolors ] ; then
	local dircolors_TERM=${TERM}
	if [[ ${TERM} = xterm-termite || ${TERM} = alacritty ]] ; then
		dircolors_TERM=xterm-color
	fi
	if [ -r "${HOME}/.dir_colors" ] ; then
		eval $(TERM=${dircolors_TERM} dircolors -b "${HOME}/.dir_colors")
	elif [ -r /etc/DIRCOLORS ] ; then
		eval $(TERM=${dircolors_TERM} dircolors -b /etc/DIRCOLORS)
	else
		eval $(TERM=${dircolors_TERM} dircolors)
	fi
fi

# Make completion faster: use cache and do not do partial matches
[[ -d ~/.zsh/cache ]] && mkdir -p ~/.zsh/cache
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' insert-tab pending=1
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' accept-exact-dirs true
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' special-dirs ..

# Fuzzy completion
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*' matcher-list '' \
	'm:{a-z\-}={A-Z\_}' \
	'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
	'r:[[:ascii:]]||[[:ascii:]]=** r:|=* m:{a-z\-}={A-Z\_}'
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/5))numeric)'
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BNo matching %b%d'

# Prevent CVS files from being matched
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS' '*.py[cod]' '__pycache__'
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'
zstyle ':completion:*:cd:*' noignore-parents noparent pwd

zstyle ':completion:*:processes' command 'ps -au$USER -o pid,user,args'
zstyle ':completion:*:processes-names' command 'ps -au$USER -o command'
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' '*?.old'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:killall:*' force-list always
zstyle ':completion:*:kill:*' force-list always

if [[ -n ${LS_COLORS} ]] ; then
	zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
	unsetopt list_types
else
	zstyle ':completion:*' list-colors ""
	setopt list_types
fi

FMT_BRANCH="%{$fg[cyan]%}%b%u%c%{$fg[default]%}" # e.g. master¹²
FMT_ACTION="·%{$fg[green]%}%a%{$fg[default]%}"   # e.g. (rebase)

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git hg bzr svn
zstyle ':vcs_info:bzr:prompt:*' use-simple true
zstyle ':vcs_info:*:prompt:*' check-for-changes true
zstyle ':vcs_info:*:prompt:*' unstagedstr   "%B%{$fg[cyan]%}+%{$fg[default]%}%b"
zstyle ':vcs_info:*:prompt:*' stagedstr     "%B%{$fg[cyan]%}=%{$fg[default]%}%b"
zstyle ':vcs_info:*:prompt:*' actionformats "${FMT_BRANCH}${FMT_ACTION} "
zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH} "
zstyle ':vcs_info:*:prompt:*' nvcsformats   ""

# Workaround for the Git file names completion, which can be very
# slow for # large repositories (e.g. the Linux kernel sources).
# Source: http://www.zsh.org/mla/workers/2011/msg00502.html

# map alt-, to complete files
# zle -C complete-files complete-word _generic
# zstyle ':completion:complete-files:*' completer _files
# bindkey '^[,' complete-files

# Tab completion
# bindkey '^i' complete-word              # tab to do menu
# bindkey "\e[Z" reverse-menu-complete    # shift-tab to reverse menu

# Up/down arrow.
# I want shared history for ^R, but I don't want another shell's activity to
# mess with up/down.  This does that.
if zz-top --loco zsh-history-substring-search ; then
	down-line-or-local-history() {
		zle set-local-history 1
		zle history-substring-search-down
		zle set-local-history 0
	}
	up-line-or-local-history() {
		zle set-local-history 1
		zle history-substring-search-up
		zle set-local-history 0
	}
else
	down-line-or-local-history() {
		zle set-local-history 1
		zle down-line-or-history
		zle set-local-history 0
	}
	up-line-or-local-history() {
		zle set-local-history 1
		zle up-line-or-history
		zle set-local-history 0
	}
fi
zle -N down-line-or-local-history
zle -N up-line-or-local-history

bindkey "\e[A" up-line-or-local-history
bindkey "\eOA" up-line-or-local-history
bindkey "\e[B" down-line-or-local-history
bindkey "\eOB" down-line-or-local-history

# Search in history using the current input as prefix
[[ -n "${key[PageUp]}"   ]] && bindkey "${key[PageUp]}"   history-beginning-search-backward
[[ -n "${key[PageDown]}" ]] && bindkey "${key[PageDown]}" history-beginning-search-forward

# Quote stuff that looks like URLs automatically.
autoload -U url-quote-magic
zstyle ':urlglobber' url-other-schema ftp git gopher http https magnet
zstyle ':url-quote-magic:*' url-metas '*?[]^(|)~#='  # dropped { }

# Disable Git automatic file completion -- it is slow.
#__git_files(){}

REAL_TERM=${TERM}
if [[ -n ${TMUX} ]] ; then
	local tmp=$(tmux show-environment -g TERM 2> /dev/null)
	if [[ -n ${tmp} ]] ; then
		REAL_TERM=${tmp:5}
	fi
fi

# Workaround for handling TERM variable in multiple tmux sessions properly from
# http://sourceforge.net/p/tmux/mailman/message/32751663/ by Nicholas Marriott.
if [[ -n ${TMUX} && -n ${commands[tmux]} ]];then
	case ${REAL_TERM} in
		*256color | xterm-termite | alacritty)
			if infocmp tmux-256color &> /dev/null ; then
				TERM=tmux-256color
			else
				TERM=screen-256color
			fi
			;;
		fbterm)
			TERM=screen-256color
			;;
		*)
			if infocmp tmux &> /dev/null ; then
				TERM=tmux
			else
				TERM=screen
			fi
			;;
	esac
fi

# Disable bracketed paste in terminals which won't gobble unrecognized
# escapes. This fixes the trailing characters in prompts in some *BSD
# consoles. Info: http://www.zsh.org/mla/users/2015/msg01055.html
if [[ ${REAL_TERM} = cons* || -z $(printf '%s %q' ${(kv)terminfo[(R)*[0-9](#c4)[hl]]}) ]] ; then
	unset zle_bracketed_paste
fi

function precmd_vcs_info_prompt {
	vcs_info prompt
}
precmd_functions+=(precmd_vcs_info_prompt)

# Have Zsh report the times used by commands. Also, use this value to determine
# when to emit a bell to the terminal, so it does not beep so often.
REPORTTIME=5

function precmd_bell {
	if [[ ${TTYIDLE} -gt $(( REPORTTIME * 6 )) ]] ; then
		printf '\a'
	fi
}
precmd_functions+=(precmd_bell)

case ${REAL_TERM} in
	xterm* | gnome*)
		function precmd_xterm_title {
			print -Pn "\e]0;%n@%m: %~\a"
		}
		precmd_functions+=(precmd_xterm_title)
		function preexec_xterm_title {
			print -Pn "\e]0;$HOST: ${(q)1//(#m)[$'\000-\037\177-']/${(q)MATCH}}\a"
		}
		preexec_functions+=(preexec_xterm_title)
		;;
	st | st-256color)
		# See: http://git.suckless.org/st/plain/FAQ
		tput smkx
		;;
esac

if [[ -r /etc/profile.d/vte.sh ]] ; then
	TERM=${REAL_TERM} source /etc/profile.d/vte.sh
fi
if [[ ${TERM} = screen* ]] ; then
	tput smkx  # SRSLY?
fi

unset REAL_TERM

# Put the prefix of the jhbuild environment in the prompt
zsh_jhbuild_info=''
if [[ -n ${JHBUILD_PREFIX} ]] ; then
	zsh_jhbuild_info=" %{$fg[green]%}jhbuild%{%b%}:%{$fg[magenta]%}${JHBUILD_PREFIX}%{%b%}"
fi

# Try to detect whether inside a chroot and add it to the prompt
zsh_chroot_info=''
if [[ -n ${DEBIAN_CHROOT} ]] ; then
	zsh_chroot_info=${DEBIAN_CHROOT}
elif [[ -n ${CHROOT_NAME} ]] ; then
	zsh_chroot_info=${CHROOT_NAME}
elif [[ -n ${CHROOT} ]] ; then
	zsh_chroot_info=${CHROOT}
fi

if [[ -n ${zsh_chroot_info} ]] ; then
	zsh_chroot_info=" %{$fg[green]%}chroot%{%b%}:%{$fg[magenta]%}${zsh_chroot_info}%{%b%}"
fi

# Final PROMPT setting
PROMPT=$'%{%B%(!.$fg[red].$fg[green])%}%m%{%b%}${zsh_chroot_info}${zsh_jhbuild_info} %{$fg[magenta]%}${VIRTUAL_ENV_NAME:+py:${VIRTUAL_ENV_NAME} }${ROCK_ENV_NAME:+lua:${ROCK_ENV_NAME} }%{$reset_color%}${vcs_info_msg_0_}%{%B$fg[blue]%}%1~ %{%(?.$fg[blue].%B$fg[red])%}%# %{%b%k%f%}'

# Don't count common path separators as word characters
WORDCHARS=${WORDCHARS//[&.;\/]}

# Don't glob with find or wget
for command in find wget curl; alias ${command}="noglob ${command}"

# Aliases
alias -- '-'=popd
alias -- '+'=pushd
alias -- '..'='cd ..'
alias clip='xclip -selection clipboard'
alias sprunge='curl -s -S -F "sprunge=<-" http://sprunge.us'

if grep --version && grep --version | grep GNU ; then
	alias grep='grep --color=auto'
fi &> /dev/null

if ls --version && ls --version | grep GNU ; then
	alias ls='ls --color=auto -F'
else
	# In BSD systems, usually setting this makes "ls" user colors.
	export CLICOLOR=1
	export LSCOLORS=ExGxFxdxCxDxDxhbabacae
	if whence -p colorls ; then
		alias ls='colorls -F'
	else
		alias ls='ls -F'
	fi
fi &> /dev/null

meteo () {
	curl -s "http://meteo.connectical.com/$1"
}

# Golang environment and binaries directory
if [[ -x /usr/bin/go && -d ${HOME}/go ]] ; then
	export GOPATH="${HOME}/go"
	path=( "${GOPATH}/bin" "${path[@]}" )
fi

if [[ -x /usr/bin/rustc ]] ; then
	export RUSTFLAGS='-C target-cpu=native'
fi

# Rust/Cargo binaries directory
if [[ -d ${HOME}/.cargo/bin ]] ; then
	path=( "${HOME}/.cargo/bin" "${path[@]}" )
fi

# Local binaries directory
for dirpath in ${HOME}/.local/bin ${HOME}/.dotfiles/bin ; do
	if [[ -d ${dirpath} ]] ; then
		path=( "${dirpath}" "${path[@]}" )
	fi
done

# Python startup file
if [ -r "${HOME}/.startup.py" ] ; then
	export PYTHONSTARTUP="${HOME}/.startup.py"
fi

export EMAIL='aperez@igalia.com'
export NAME='Adrian Perez'

for i in nvim vim e3vi vi zile nano pico ; do
	i=$(whence -p "${i}")
	if [[ -x ${i} ]] ; then
		export EDITOR=${i}
		break
	fi
done
if [[ ${EDITOR} = */nvim || ${EDITOR} = */vim ]] ; then
	alias vi="${EDITOR}"
	alias view="${EDITOR} -R"
	alias vimdiff="${EDITOR} -d"
fi

for i in less most more ; do
	i=$(whence -p "${i}")
	if [[ -x ${i} ]] ; then
		export PAGER=${i}
		# Setup lesspipe colorizer.
		if [[ ${i##*/} = less && ${LESSOPEN} = *lesspipe* && -x $(whence -p pygmentize) ]] ; then
			export LESSCOLORIZER=pygmentize
		fi
		break
	fi
done

if [[ ${PAGER} = */less ]] ; then
	export LESS=RSMF
fi


if [[ -x /usr/bin/ccache ]] ; then
	if [[ -d /usr/lib/ccache/bin ]] ; then
		path=( /usr/lib/ccache/bin "${path[@]}" )
	fi
	if [[ -d /home/devel/.ccache ]] ; then
		export CCACHE_DIR=/home/devel/.ccache
	fi
fi

# Settings for zsh-completion-generator
GENCOMPL_PY=python2

# VirtualZ settings
if [[ -d /devel/.virtualenvs ]] ; then
	VIRTUALZ_HOME=/devel/.virtualenvs
fi

# Syntax highlighting settings. Set those only if the plugin has been
# loaded successfully, otherwise assigning to the associate array will
# cause errors and the shell will exit during startup.
if zz-top --loco fast-syntax-highlighting && [[ ${FAST_HIGHLIGHT:+set} = set ]]
then
	FAST_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=magenta,bold'
	FAST_HIGHLIGHT_STYLES[double-quoted-argument]='fg=magenta,bold'
	FAST_HIGHLIGHT_STYLES[single-quoted-argument]='fg=magenta,bold'
	FAST_HIGHLIGHT_STYLES[single-hyphen-option]='fg=cyan'
	FAST_HIGHLIGHT_STYLES[double-hyphen-option]='fg=cyan'
	FAST_HIGHLIGHT_STYLES[back-quoted-argument]='fg=magenta'
	FAST_HIGHLIGHT_STYLES[commandseparator]='fg=red,bold'
	FAST_HIGHLIGHT_STYLES[hashed-command]='fg=yellow,bold'
	FAST_HIGHLIGHT_STYLES[reserved-word]='fg=bold'
	FAST_HIGHLIGHT_STYLES[unknown-token]='bg=brown'
	FAST_HIGHLIGHT_STYLES[precommand]='fg=yellow,bold,underline'
	FAST_HIGHLIGHT_STYLES[function]='fg=yellow,bold'
	FAST_HIGHLIGHT_STYLES[globbing]='fg=cyan,bold'
	FAST_HIGHLIGHT_STYLES[command]='fg=yellow,bold'
	FAST_HIGHLIGHT_STYLES[builtin]='fg=yellow,bold'
	FAST_HIGHLIGHT_STYLES[alias]='fg=yellow,bold'
	FAST_HIGHLIGHT_STYLES[path]='fg=underline'
fi

if zz-top --loco zsh-autosuggestions
then
	if [[ ${TERM} != xterm-termite && ${TERM} != *-256color ]]
	then
		ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=black,bold
	fi
	ZSH_AUTOSUGGEST_STRATEGY=(history completion)
fi

if zz-top --loco zsh-fzy ; then
	:	
elif [[ -r /usr/share/skim/key-bindings.zsh ]] ; then
	source /usr/share/skim/key-bindings.zsh
	SKIM_DEFAULT_OPTIONS='--reverse'
elif [[ -r /etc/profile.d/fzf.zsh ]] ; then
	source /etc/profile.d/fzf.zsh
	FZF_DEFAULT_OPTS='--reverse --inline-info'
elif [[ -r /usr/share/fzf/key-bindings.zsh ]] ; then
	source /usr/share/fzf/key-bindings.zsh
	FZF_DEFAULT_OPTS='--reverse --inline-info'
fi

if [[ -S ~/.mpd/socket ]] ; then
	export MPD_HOST="${HOME}/.mpd/socket"
else
	unset MPD_HOST
fi

if whence -p systemctl &> /dev/null ; then
	systemctl --user import-environment PATH EDITOR LANG
fi

export GPG_TTY=$(tty)
if whence -p gpg-connect-agent &> /dev/null ; then
	gpg-connect-agent -q updatestartuptty /bye > /dev/null
fi
