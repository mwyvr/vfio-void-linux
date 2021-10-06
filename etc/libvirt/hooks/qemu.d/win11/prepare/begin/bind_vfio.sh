#!/bin/bash

## Load the config file
source /etc/libvirt/hooks/kvm.conf
echo conf loaded

## Load vfio
echo modprobe vfio
modprobe vfio
echo modprobe vfio_iommu_type1
modprobe vfio_iommu_type1
echo modprobe vfio_pci
modprobe vfio_pci

# unload nvidia
modprobe -r nvidia-drm
modprobe -r nvidia

## Unbind gpu and bind to vfio
echo virsh nodedev-detach $VIRSH_GPU_VIDEO
virsh nodedev-detach $VIRSH_GPU_VIDEO
echo virsh nodedev-detach $VIRSH_GPU_AUDIO
virsh nodedev-detach $VIRSH_GPU_AUDIO
echo virsh nodedev-detach $VIRSH_GPU_USB
virsh nodedev-detach $VIRSH_GPU_USB
echo virsh nodedev-detach $VIRSH_GPU_SERIAL
virsh nodedev-detach $VIRSH_GPU_SERIAL

## Unbind ssd from nvme and bind to vfio
# echo virsh nodedev-detach $VIRSH_NVME_SSD
# virsh nodedev-detach $VIRSH_NVME_SSD
# one of two nics
#echo virsh nodedev-detach $VIRSH_REALTEK_NIC
#virsh nodedev-detach $VIRSH_REALTEK_NIC

