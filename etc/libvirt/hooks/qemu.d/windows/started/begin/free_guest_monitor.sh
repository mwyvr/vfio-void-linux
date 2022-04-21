#!/bin/sh
. /etc/libvirt/hooks/kvm.conf

# Passing through the DISPLAY variable in this way to be consistent, as it's
# not in the runuser environment needed for some commands.
# runuser $RUNAS -c "DISPLAY=$HOST_DISPLAY $XRANDRPROG --output $GUEST_MONITOR --off"

# Once vm started, monitor will autosense feed coming from dedicated NVIDIA gpu

# Instead of a blind "killall barriers", this avoids an error condition if
# barriers not running; this is a useful pattern for other commands, as libvirt
# will abort the start command (and rewind the prepare actions) on errors,
# which is what we want especially given we allocate 32GB (or whatever N
# amount) of RAM in another script. Failure in any one leads to the shutdown
# scripts being run.
# if test -n "`pidof barriers`"; then kill -9 `pidof barriers`; fi

# As user, start barrier keyboard and mouse sharing daemon; client installed on VM
# runuser $RUNAS -c "DISPLAY=$HOST_DISPLAY /usr/bin/barriers --no-tray --address $HOST_IP:24800 --name $HOST_NAME --disable-crypto -c /home/$RUNAS/.config/barrier/barrier.conf"

