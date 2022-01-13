#!/bin/sh
source /etc/libvirt/hooks/kvm.conf

virsh nodedev-reattach $VIRSH_NVME_SSD
virsh nodedev-reattach $VIRSH_REALTEK_NIC

# see stopped/end/... for scripts to run after vm is completely shutdown,
# including xrandr to turn monitor back on.

