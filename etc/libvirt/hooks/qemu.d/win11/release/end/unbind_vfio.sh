#!/bin/sh
source /etc/libvirt/hooks/kvm.conf

virsh nodedev-reattach $VIRSH_NVME_SSD
virsh nodedev-reattach $VIRSH_REALTEK_NIC

