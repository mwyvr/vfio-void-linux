#!/bin/sh
source /etc/libvirt/hooks/kvm.conf

# Note: NVIDIA GPU is bound to vfio at boot for GPU passthrough; An AMD Radeon
# card serves the linix host, driving both monitors when a VM is not running.
# See started | end for script that shuts off that feed.

# one of two nics; Intel stays with host
virsh nodedev-detach $VIRSH_REALTEK_NIC

# no physical drive passed through at this time
