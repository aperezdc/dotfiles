# The following lines were added by compinstall
zstyle :compinstall filename '/home/aperez/.zshrc'

if [[ -d ~/.zsh/functions ]] ; then
	fpath=( ${fpath} ~/.zsh/functions )
fi

autoload -Uz compinit
compinit

if [[ -x /usr/bin/clyde && -x /usr/bin/pacman ]] ; then
	compdef clyde=pacman
fi

# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=${HISTSIZE}
setopt appendhistory extendedglob
unsetopt beep nomatch
bindkey -e
# End of lines configured by zsh-newuser-install

# Extra functionality
autoload -U zmv

# Initialize colors.
autoload -U colors
colors

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
	     pushd_ignore_dups auto_param_keys hist_ignore_all_dups \
	     mark_dirs cdablevars interactive_comments glob_complete \
	     print_eight_bit always_to_end glob warn_create_global \
	     hash_list_all correct hash_cmds hash_dirs hash_executables_only \
	     auto_continue check_jobs
unsetopt menu_complete auto_remove_slash auto_menu list_ambiguous \
	     pushd_to_home

# Make completion faster: use cache and do not do partial matches
[[ -d ~/.zsh/cache ]] && mkdir -p ~/.zsh/cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' accept-exact '*(N)'

zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BNo matching %b%d'

# Prevent CVS files from being matched
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'
zstyle ':completion:*:cd:*' noignore-parents noparent pwd

# Bring up ${LS_COLORS}
if [ -x /usr/bin/dircolors ] ; then
	if [ -r "${HOME}/.dir_colors" ] ; then
		eval $(dircolors -b "${HOME}/.dir_colors")
	elif [ -r /etc/DIRCOLORS ] ; then
		eval $(dircolors -b /etc/DIRCOLORS)
	else
		eval $(dircolors)
	fi
fi

if [ "${LS_COLORS}" ] ; then
	zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
	unsetopt list_types
else
	zstyle ':completion:*' list-colors ""
	setopt list_types
fi

# Some fine-tuning
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' list-prompt "%BMatch %m (%p)%b"
zstyle ':completion:*' menu yes=long select=2 interactive
zstyle ':completion:*:processes' command 'ps -au$USER -o pid,user,args'
zstyle ':completion:*:processes-names' command 'ps -au$USER -o command'
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' '*?.old'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:killall:*' force-list always
zstyle ':completion:*:kill:*' force-list always


FMT_BRANCH="%{$fg[cyan]%}%b%u%c%{$fg[default]%}" # e.g. master¹²
FMT_ACTION="·%{$fg[green]%}%a%{$fg[default]%}"   # e.g. (rebase)

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git hg bzr svn
zstyle ':vcs_info:bzr:prompt:*' use-simple true
zstyle ':vcs_info:*:prompt:*' check-for-changes true
zstyle ':vcs_info:*:prompt:*' unstagedstr   "%B%{$fg[cyan]%}¹%{$fg[default]%}%b"
zstyle ':vcs_info:*:prompt:*' stagedstr     "%B%{$fg[cyan]%}²%{$fg[default]%}%b"
zstyle ':vcs_info:*:prompt:*' actionformats "${FMT_BRANCH}${FMT_ACTION} "
zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH} "
zstyle ':vcs_info:*:prompt:*' nvcsformats   ""

# Workaround for the Git file names completion, which can be very
# slow for # large repositories (e.g. the Linux kernel sources).
# Source: http://www.zsh.org/mla/workers/2011/msg00502.html

# map alt-, to complete files
zle -C complete-files complete-word _generic
zstyle ':completion:complete-files:*' completer _files
bindkey '^[,' complete-files

# Disable Git automatic file completion -- it is slow.
#__git_files(){}


case ${TERM} in
	screen* | xterm* | gnome-terminal)
		function precmd {
			vcs_info 'prompt'
			print -Pn "\e]0;%n@%m: %~\a"
		}
	;;
	*)
		function precmd {
			vcs_info 'prompt'
		}
	;;
esac

if [[ ${COLORTERM} = gnome-terminal || ${COLORTERM} = drop-down-terminal || -n ${VTE_VERSION} ]] ; then
	export TERM='xterm-256color'
fi

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
PROMPT=$'%{%B%(!.$fg[red].$fg[green])%}%m%{%b%}${zsh_chroot_info}${zsh_jhbuild_info} ${vcs_info_msg_0_}%{%B$fg[blue]%}%1~ %{%(?.$fg[blue].%B$fg[red])%}%# %{%b%k%f%}'

# Devtodo
#
if [[ -x /usr/bin/devtodo ]] ; then
	function cd {
		if builtin cd "$@" ; then
			devtodo --summary --timeout 30
		fi
	}
	function pushd {
		if builtin pushd "$@" ; then
			devtodo --summary --timeout 30
		fi
	}
	function popd {
		if builtin popd "$@" ; then
			devtodo --summary --timeout 30
		fi
	}
	devtodo --summary --timeout 30
fi

# Aliases
alias -- '-'=popd
alias -- '+'=pushd
alias -- '..'='cd ..'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias clip='xclip -selection clipboard'
alias sprunge='curl -s -S -F "sprunge=<-" http://sprunge.us'

# Golang environment and binaries directory
if [[ -x /usr/bin/go && -d ${HOME}/go ]] ; then
	export GOPATH="${HOME}/go"
	PATH="${PATH}:${HOME}/go/bin"
fi

# Local binaries directory
if [[ -d ${HOME}/.local/bin ]] ; then
	PATH="${PATH}:${HOME}/.local/bin"
fi

if [[ -d /home/aperez/devel/WebKit/Tools/Scripts ]] ; then
	PATH="$PATH:/home/aperez/devel/WebKit/Tools/Scripts"
fi

# Python startup file
if [ -r "${HOME}/.startup.py" ] ; then
	export PYTHONSTARTUP="${HOME}/.startup.py"
fi

# Python virtualenvwrapper
if [ -r /usr/bin/virtualenvwrapper.sh ] ; then
	export WORKON_HOME=~/.venv.d
	#export VIRTUALENV_DISTRIBUTE=1
	if [ ! -d "${WORKON_HOME}" ] ; then
		mkdir -p "${WORKON_HOME}"
	fi
	# Prefer the lazy-loaded version of the script
	if [ -r /usr/bin/virtualenvwrapper_lazy.sh ] ; then
		. /usr/bin/virtualenvwrapper_lazy.sh
	else
		. /usr/bin/virtualenvwrapper.sh
	fi
fi

export EMAIL='aperez@igalia.com'
export NAME='Adrian Perez'
export CCACHE_COMPRESS=1

for i in vim zile nano pico ; do
	i=$(whence -p vim)
	if [[ -x ${i} ]] ; then
		export EDITOR=${i}
		break
	fi
done

if [[ -x /usr/bin/ccache ]] ; then
	if [[ -d /usr/lib/ccache/bin ]] ; then
		PATH="/usr/lib/ccache/bin:$PATH"
	fi
	if [[ -d /home/devel/.ccache ]] ; then
		export CCACHE_DIR=/home/devel/.ccache
	fi
fi

# Mark exports
export PATH


if [[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] ; then
	ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
	source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=magenta,bold'
	ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=magenta,bold'
	ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=magenta,bold'
	ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=cyan'
	ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=cyan'
	ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=magenta'
	ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=red,bold'
	ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=yellow,bold'
	ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=bold'
	ZSH_HIGHLIGHT_STYLES[unknown-token]='bg=brown'
	ZSH_HIGHLIGHT_STYLES[precommand]='fg=yellow,bold,underline'
	ZSH_HIGHLIGHT_STYLES[function]='fg=yellow,bold'
	ZSH_HIGHLIGHT_STYLES[globbing]='fg=cyan,bold'
	ZSH_HIGHLIGHT_STYLES[command]='fg=yellow,bold'
	ZSH_HIGHLIGHT_STYLES[builtin]='fg=yellow,bold'
	ZSH_HIGHLIGHT_STYLES[alias]='fg=yellow,bold'
	#ZSH_HIGHLIGHT_STYLES[path]='fg=underline'
fi

if [[ -d ~/.dotfiles/deer ]] ; then
	source ~/.dotfiles/deer/deer
fi
