#!/bin/sh
# Backup:
# - libvirt VM xml config files; always use virsh to edit i.e. virsh edit win11
# - libvirt hook files
# - dracut conf for wabbit machine
sudo cp /etc/libvirt/qemu/*.xml ~/src/libvirt-win/etc/libvirt/qemu/.
sudo cp -r /etc/dracut.conf.d ~/src/libvirt-win/etc/.
sudo chmod 644 ~/src/libvirt-win/etc/libvirt/qemu/*
git status
