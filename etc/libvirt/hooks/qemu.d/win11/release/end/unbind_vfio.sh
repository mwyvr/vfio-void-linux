#!/bin/bash

## Load the config file
source /etc/libvirt/hooks/kvm.conf

## Unbind gpu from vfio and bind to nvidia
virsh nodedev-reattach $VIRSH_GPU_VIDEO
virsh nodedev-reattach $VIRSH_GPU_AUDIO
virsh nodedev-reattach $VIRSH_GPU_USB
virsh nodedev-reattach $VIRSH_GPU_SERIAL
## Unbind ssd from vfio and bind to nvme
# virsh nodedev-reattach $VIRSH_NVME_SSD
# 2nd nic
# virsh nodedev-reattach $VIRSH_REALTEK_NIC


## Unload vfio
modprobe -r vfio_pci
modprobe -r vfio_iommu_type1
modprobe -r vfio

# restart nvidia
modprobe nvidia
modprobe nvidia_modeset
modprobe nvidia_uvm
modprobe nvidia_drm

# you'll need to restart the graphical.target to get the second display back
