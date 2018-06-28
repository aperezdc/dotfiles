zplug zplug/zplug, hook-build:'zplug --self-manage'
zplug chrissicool/zsh-256color
zplug kyanagi/faster-vcs-info, as:command, use:'VCS_INFO_*', lazy:true
zplug jreese/zsh-titles
zplug RobSis/zsh-completion-generator
zplug RobSis/zsh-reentry-hook
# zplug zsh-users/zsh-syntax-highlighting, defer:2
zplug caarlos0/zsh-open-pr
zplug zdharma/fast-syntax-highlighting
zplug zsh-users/zsh-completions
zplug Tarrasch/zsh-autoenv
zplug k4rthik/git-cal, as:command

if [[ -d ~/devel/virtualz ]] ; then
	zplug "~/devel/virtualz", from:local
else
	zplug 'aperezdc/virtualz'
fi
if [[ -d ~/devel/rockz ]] ; then
	zplug "~/devel/rockz", from:local
else
	zplug 'aperezdc/rockz'
fi
if [[ -d ~/devel/zsh-notes ]] ; then
	zplug "~/devel/zsh-notes", from:local
else
	zplug 'aperezdc/zsh-notes'
fi

# if [[ -d ~/devel/zsh-fzy ]] ; then
# 	zplug "~/devel/zsh-fzy", from:local
# else
# 	zplug 'aperezdc/zsh-fzy'
# fi
