#!/bin/sh
. /etc/libvirt/hooks/kvm.conf

# Return CPU governor to the baseline: "schedutil"
for file in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; 
do 
	echo "schedutil" > $file; 
done

