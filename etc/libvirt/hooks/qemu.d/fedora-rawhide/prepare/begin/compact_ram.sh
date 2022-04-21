#!/bin/sh
# Configuration variables:
. /etc/libvirt/hooks/kvm.conf

# Finish writing any outstanding writes to disk.
sync
# Tell the kernel to "defragment" memory where possible.
echo Defragment RAM, if possible
echo 1 > /proc/sys/vm/compact_memory
echo Compact completed

# and that's it. I've been finding performance is good with automatic, transparent hugepages.

