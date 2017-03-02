#! /bin/bash

for dirpath in ${HOME}/.local/bin ${HOME}/.dotfiles/bin ; do
	if [[ -d ${dirpath} ]] ; then
		PATH="$PATH:${dirpath}"
	fi
done

if [[ $- == *i* ]] ; then

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	if [[ ${EUID} == 0 ]] ; then
		PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
	else
		PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
	fi

	if ls --version && ls --version | grep GNU ; then
		alias ls='ls --color=auto -F'
	else
		# In BSD systems, usually setting this makes "ls" use colors
		export CLICOLOR=1
		export LSCOLORS=ExGxFxdxCxDxDxhbabacae
		if [[ $(type -pt colorls) = file ]] ; then
			alias ls='colorls -F'
		else
			alias ls='ls -F'
		fi
	fi &> /dev/null

	if grep --version && grep --version | grep GNU ; then
		alias grep='grep --colour=auto'
	fi &> /dev/null
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
fi


# Aliases!
alias vi='vim'
alias view='vim -R'
alias -- '+'=pushd
alias -- '-'=popd
alias -- '..'='cd ..'

case $TERM in
	# Unicode for the masses!
	xterm* | uxterm* | gnome-terminal | urxvt*)
		LANG=en_US.UTF-8
	;;
esac

for editor in nvim vim vi e3vi ; do
	if [[ $(type -pt ${editor}) = file ]] ; then
		EDITOR=${editor}
		break
	fi
done

export GPG_TTY=$(tty)
if [[ $(type -pt gpg-connect-agent) = file ]] ; then
	gpg-connect-agent -q updatestartuptty /bye > /dev/null
fi

export PATH EDITOR
if [[ $(type -pt systemctl) == file ]] ; then
	systemctl --user import-environment PATH EDITOR LANG
fi

if [[ -r /usr/share/fzf/key-bindings.bash ]] ; then
	source /usr/share/fzf/key-bindings.bash
fi

fi # Interactive shell
