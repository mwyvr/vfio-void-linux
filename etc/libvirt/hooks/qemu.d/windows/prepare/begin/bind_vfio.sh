#!/bin/sh
. /etc/libvirt/hooks/kvm.conf

# Note: NVIDIA GPU is bound to vfio at boot for GPU passthrough; An AMD Radeon
# card serves the linix host, driving both monitors when a VM is not running.
# See started | end for script that shuts off that feed.

# one of two nics; Intel stays with host
echo $VIRSH_REALTEK_NIC
virsh nodedev-detach $VIRSH_REALTEK_NIC

# This drive is dedicated to a Windows install and could boot from it directly.
# Passing through the nvme, as with GPUs, performs *much* better.
virsh nodedev-detach $VIRSH_NVME_SSD

