#!/bin/sh
. /etc/libvirt/hooks/kvm.conf

# Note, second gpu (a nvidia) never bound to host.

# one of two nics; Intel stays with host
echo $VIRSH_REALTEK_NIC
virsh nodedev-detach $VIRSH_REALTEK_NIC
