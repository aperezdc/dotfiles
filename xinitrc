# vim:ft=sh

cwd=$(pwd)

if [ -r ~/.Xresources ] ; then
	xrdb -merge ~/.Xresources
fi

# Ensure needed directories are created
mkdir -p ~/.xinit/run ~/.xinit/svc ~/.xinit/log
cd ~/.xinit

# Now for the logging FIFO
if [ ! -p run/log.fifo ] ; then
	rm -f   run/log.fifo
	mkfifo  run/log.fifo
fi

# Start logger and make all processes log to the FIFO
dmon -p run/log.pid -e cat run/log.fifo -- drlog -t log

# We always want D-Bus, and it is terribly painful to launch it using DMon
eval "$(dbus-launch --exit-with-session --sh-syntax)"
sleep 1

eval "$(gnome-keyring-daemon --start --daemonize)"
export GNOME_KEYRING_CONTROL SSH_AUTH_SOCK GPG_AGENT_INFO GNOME_KEYRING_PID

service ()
{
	local svcname=${S:-$(basename "$1")}
	echo -n "Starting ${svcname} ("
	dmon -e -p "run/${svcname}.pid" "$@" -- dlog run/log.fifo
	echo "$(< run/${svcname}.pid))"
	echo "  dmon -e -p run/${svcname}.pid $* -- dlog run/log.fifo"
}

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

trap cleanup INT QUIT TERM EXIT

# We want to run Pulseaudio as soon as possible right away, so it registers
# itself in the X11 root window, and the GNOME settings daemon picks it up.
pulseaudio --check && pulseaudio --kill
start-pulseaudio-x11

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


cd "${cwd}"
dmon -s -e -n -1 "${WM:-dwm}" -- dlog ~/.xinit/run/log.fifo

