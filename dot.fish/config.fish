set fisher_home ~/.local/share/fisherman
set fisher_config ~/.config/fisherman
source $fisher_home/config.fish

if test -d ~/.local/bin
	set -x PATH ~/.local/bin $PATH
end

if test -x /usr/bin/python
	if python -c 'import virtualfish' ^ /dev/null
		eval (python -m virtualfish)
	end
end
