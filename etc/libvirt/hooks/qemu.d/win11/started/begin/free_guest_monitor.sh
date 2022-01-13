#!/bin/sh
source /etc/libvirt/hooks/kvm.conf

# Passing through the DISPLAY variable in this way as it's not in the runuser
# environment Once vm started, monitor will autosense feed coming from
# dedicated NVIDIA

runuser $RUNAS -c "DISPLAY=$HOST_DISPLAY xrandr --output $GUEST_MONITOR --off"

# Instead of a blind killall barriers, this avoids an error condition if
# barriers not running; this is a useful pattern for other commands, as libvirt
# will abort the start command (and rewind the prepare actions) on errors,
# which is what we want especially given we allocate 32GB (or whatever N
# amount) of RAM in another script. Failure in any one leads to the shutdown
# scripts being run.
if test -n "`pidof barriers`"; then killall -9 barriers; fi

# Start barrier keyboard and mouse sharing daemon; client installed on VM
runuser $RUNAS -c "DISPLAY=$DISPLAY /usr/bin/barriers --no-tray --address $HOST_IP:24800 --name $HOST_NAME --disable-crypto --disable-client-cert-checking -c /home/$RUNAS/.config/barrier/barrier.conf"

