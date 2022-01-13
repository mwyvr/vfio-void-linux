#!/bin/sh
source /etc/libvirt/hooks/kvm.conf

## Enable CPU governor on-demand mode
for file in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; 
do 
	echo "ondemand" > $file; 
done

