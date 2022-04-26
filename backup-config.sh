#!/bin/sh
# copy xml config files; 
# always use virsh to edit 
# i.e. 
# virsh edit win11
sudo cp /etc/libvirt/qemu/*.xml ~/src/libvirt-win/etc/libvirt/qemu/.
sudo chmod 644 ~/src/libvirt-win/etc/libvirt/qemu/*
git status
