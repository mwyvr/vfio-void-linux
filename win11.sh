#!/usr/bin/bash
if [ $XDG_SESSION_TYPE != "tty" ]; then
	echo "win11.sh must be run from a tty (ctrl-alt-F3)"
	echo "(be sure to have shut down all work in the graphical environment)"
	exit 1
else
	DEFAULT_TARGET=`systemctl get-default`
	# In my case, gdm; Will likely state "graphical.target"
	echo Stopping $DEFAULT_TARGET
	sudo systemctl isolate multi-user.target
	echo Starting win11 vm
	virsh start win11
	echo Starting $DEFAULT_TARGET
	sudo systemctl isolate $DEFAULT_TARGET
fi

