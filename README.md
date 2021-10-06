# vfio
My libvirt config, Pop OS (Ubuntu/Debian derived) host, Windows 11 guest OS

## Hardware Config

My relevant hardware from `dmesg`, `free -h` and `lspci -nnv`:

    * Board: Gigabyte X570 AORUS MASTER, BIOS F35b 09/06/2021
    * CPU: AMD Ryzen 7 3800X 8-Core Processor
    * Mem: 62Gi
    * Host GPU: Radeon RX 5600 OEM/5600 XT / 5700/5700 XT
    * Guest GPU: GeForce GTX 1660 SUPER
    * Host SSD: Sabrent Rocket 1TB (Phison Electronics Corporation E16 PCIe4 NVMe)
    * Guest SSD: Sabrent Rocket 1TB (Phison Electronics Corporation E16 PCIe4 NVMe)

## Starting the guest vm (Win 11)

`win11.sh` must be run from a `tty` console; this could be made a systemd
service but I prefer having to switch to a non-graphical terminal as it reminds
me I'm going to lose any open screens in my Linux desktop.

## Stopping the guest vm

Shut down windows as normal or from the host via:

    virsh shutdown win11 --mode acpi

I've not yet found a way to get my `gdm` desktop / X to resense the once again
available NVIDIA card other than to restart it from the command line, or log out and back in.

    sudo systemctl restart display-manager
