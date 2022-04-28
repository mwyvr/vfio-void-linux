#!/bin/sh
. /etc/libvirt/hooks/kvm.conf

# Once stopped, turn amu gpu feed back on; dwm will detect this.
runuser -l $RUNAS -c "DISPLAY=$HOST_DISPLAY xrandr --output $GUEST_MONITOR --auto --right-of $HOST_MONITOR"

# don't need barrier keyboard and mouse sharing any more
if test -n "`pidof barriers`"; then pkill barriers; fi
