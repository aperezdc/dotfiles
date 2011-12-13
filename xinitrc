# vim:ft=sh

# If ConsoleKit is installed, relaunch ourselves under its control. This
# means that some additional permissions will be granted because the user
# will be connected to a “seat” (e.g. ability to suspend the machine or
# to mount removable USB devices).
#
if [[ -z ${__XINIT_CK_SESSION} && -x /usr/bin/ck-launch-session ]]
then
	export __XINIT_CK_SESSION=1
	exec /usr/bin/ck-launch-session /bin/bash ~/.xinitrc
else
	unset __XINIT_CK_SESSION
fi

# Choose a reasonable web browser. The list of options is in order of
# preference. If none of them is found, the BROWSER environment variable
# is left untouched.
#
for browser in chromium-browser chromium epiphany firefox ; do
	if type -P "${browser}" ; then
		export BROWSER=${browser}
		break
	fi
done &> /dev/null

if [ -r ~/.Xresources ] ; then
	xrdb -merge ~/.Xresources
fi

# Ensure needed directories are created. Save the current working directory
# to be used later to launch the window manager under it.
#
cwd=$(pwd)
mkdir -p ~/.xinit/run ~/.xinit/svc ~/.xinit/log
cd ~/.xinit

# Start logger process. Later on all processes are launched so they log
# their messages to the FIFO, being then picked up by this.
#
if [ ! -p run/log.fifo ] ; then
	rm -f   run/log.fifo
	mkfifo  run/log.fifo
fi
dmon -p run/log.pid -e cat run/log.fifo -- drlog -t log

# We always want D-Bus, and it is terribly painful to launch it using DMon.
# A little delay is added, so it has time to properly start
#
# XXX Making an arbitrary delay is error-prone.
#
eval "$(dbus-launch --exit-with-session --sh-syntax)"
sleep 0.5

# Same for gnome-keyring-daemon. It would have been much better to make it
# run under DMon.
#
eval "$(gnome-keyring-daemon --start --daemonize)"
export GNOME_KEYRING_CONTROL SSH_AUTH_SOCK GPG_AGENT_INFO GNOME_KEYRING_PID

# Usage: [S=name] service path/to/daemon [daemon-arguments...]
#
# Launches a service using dmon, redirecting stderr to stdout, storing a PID
# file under ~/.xinit/run/<name>.pid, and connecting the output to the log
# pipe at ~/.xinit/run/log.fifo
#
# If the service name is not specified, the base name of the daemon is used.
#
service ()
{
	local svcname=${S:-$(basename "$1")}
	echo -n "Starting ${svcname} ("
	dmon -e -p "run/${svcname}.pid" "$@" -- dlog run/log.fifo
	echo "$(< run/${svcname}.pid))"
	echo "  dmon -e -p run/${svcname}.pid $* -- dlog run/log.fifo"
}

# Cleans up all running processes that were launched with the service()
# function above. SIGTERM is sent to the controlling dmon processes,
# which in turn will forward it to the daemon and wait for it to die.
#
cleanup () {
	cd ~/.xinit
	local pid pidfile svcname
	for pidfile in run/*.pid ; do
		pid=$(< "${pidfile}")
		svcname=${pidfile%.pid}
		svcname=${svcname#run/}
		echo "Killing ${svcname} (${pid})"
		kill -0 "${pid}" && kill "${pid}"
		rm -f "${pidfile}"
	done
}

# For whatever reason the script finishes, call cleanup() to kill daemons.
#
trap cleanup INT QUIT TERM EXIT

# We want to run Pulseaudio as soon as possible right away, so it registers
# itself in the X11 root window, and the GNOME settings daemon picks it up.
#
pulseaudio --check && pulseaudio --kill
start-pulseaudio-x11

# Launch a number of services...
#
service /usr/lib/gnome-settings-daemon/gnome-settings-daemon
service gnome-screensaver --no-daemon
service bluetooth-applet
service nm-applet
service mpd --no-daemon --stderr
mpc -q pause
service scmpc --foreground
service trayer --heighttype pixel --height 18 --widthtype request \
       --edge top --align right --margin 57 --SetDockType true
S=dwm-status service --interval 30 sh -c 'xsetroot -name "$(date +%H:%M)"'

# Last, but not least, restore the previously-saved working directory and
# use DMon also to launch the window manager. The “-1” flag (run once) is
# passsed so it is not restarted on a proper, user-requested finalization.
# Flag “-n” is used so the process is not detached to background, making
# it so the session will be closed once this instance of DMon exits.
#
cd "${cwd}"
dmon -s -e -n -1 "${WM:-dwm}" -- dlog ~/.xinit/run/log.fifo

