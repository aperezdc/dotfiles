#! /bin/zsh
if [[ $- = *i* && -r ~/.zsh/rc.zsh ]] ; then
	set -e
	source ~/.zsh/rc.zsh
	set +e
fi
