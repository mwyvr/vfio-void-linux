#!/bin/sh
. /etc/libvirt/hooks/kvm.conf
# (just for good measure in case I start to use hugepages again)
sysctl vm.nr_hugepages=0
# Finish writing any outstanding writes to disk.
sync
# Tell the kernel to "defragment" memory where possible.
echo Defragment RAM, if possible
echo 1 > /proc/sys/vm/compact_memory
echo Compact completed

