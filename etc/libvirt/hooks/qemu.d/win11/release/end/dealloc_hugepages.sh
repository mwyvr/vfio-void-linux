#!/bin/sh
. /etc/libvirt/hooks/kvm.conf

# free memory for host use again
echo 0 > /proc/sys/vm/nr_hugepages

