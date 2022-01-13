# libvirt-win
My libvirt / qemu config for a Linux host, Win 11 guest, with some possibly helpful libvirt hook scripts.

## tl;dr

IMO Windows runs better in as a VM on Linux; I get bare-metal-enough
performance that I can do photo editing in Photoshop and Lightroom, and play
some games (very rarely), in the vm.

## Hardware Config

    * Board: Gigabyte X570 AORUS MASTER, BIOS F35b 09/06/2021; Intel and Realtek NICs on the motherboard
    * CPU: AMD Ryzen 7 3800X 8-Core Processor
    * Mem: 62Gi
    * Host GPU: Radeon RX 5600 OEM/5600 XT / 5700/5700 XT
    * Guest GPU: GeForce GTX 1660 SUPER
    * Host SSD: Sabrent Rocket 1TB (Phison Electronics Corporation E16 PCIe4 NVMe)
    * Guest SSD: Sabrent Rocket 1TB (Phison Electronics Corporation E16 PCIe4 NVMe)

## GPU, NVME and NIC Passthrough

I'm currently passing through dynamically the guest NVME drive and Realtek NIC.
The GPU I'm binding to `vfio` drivers at boot. Various Linux flavours deal with
that in their own way.

I have in the past dynamically bound and unbound NVIDIA drivers but honeslty
don't need the second GPU to run two Linux screens, mostly running terminals
and VS Code. Perhaps I'll change that if I reinstall Steam...

## Mouse and Keyboard Sharing with barrier

[Barrier](https://github.com/debauchee/barrier) is available on any reasonable
Linux distribution. It's a terrific keyboard and mouse sharing solution
(supports copy and paste between the various machines/cross OS) that doesn't
require using hot keys - just move your mouse across your virtual screen that
you define with a few drag and drop operations. A `barrierc` client runs on my
laptop and the Windows VM while my Arch desktop runs the `barriers` daemon.

A snippet from the libvirt hook script:

## Drop in use of my hooks

I've tried to generalize my setup with a few variables in `kvm.conf`; If you
have not already implemented your own libvirt hooks, the drop in method may
work for you:

    # clone this repo, somewhere
    cd ~
    git clone https://github.com/solutionroute/libvirt-win.git

    # link to the hooks directory in the appropriate libvirt
    # path for your system
    cd /etc/libvirt
    sudo ln -s ~/libvirt-win/etc/libvirt/hooks .

Tune as required.

## Define your win11 guest

Assuming you've got a "win11" qemu vm defined, you are all set to go. Here's a
link to my [win11.xml](https://github.com/solutionroute/libvirt-win/blob/main/etc/libvirt/qemu/win11.xml)
in case you find it useful. 

If you aren't there yet, create one using `virt-manager`.

## Starting the guest vm (Win 11)

The hook scripts will unbind my NVME drive I've dedicated to VMs, and the
Realtek network interface; once Windows as started, `xrandr` shuts off output
from my AMD GPU to the monitor I'm also feeding from my NVIDIA GPU (dedicated
to VMs).

    virsh start win11

## Stopping the guest vm

Either shut it down within Windows or:

    virsh shutdown win11

    # sometimes need
    virsh shutdown win11 --mode ACPI

    # and if still no joy and for some reason can't access the VM (lost
    # keyboard sharing?). Not recommended as a practice.
    virsh destroy win11

## Helpful references

IMO it's helpful to create a test vm or two first, before diving in deep with
PCI passthrough and libvirt hook scripts. Perhaps create a throwaway vm using
the gui `virt-manager`.


Becoming familiar with `pci` and GPU passthrough, if this is new to you. There
are a number of blogs and articles out there to guide users of Debian based
systems.

* https://passthroughpo.st/gpu-debian/ and other pages therein.
* [Creating a Windows 10 VM on the AMD Ryzen...](https://www.heiko-sieger.info/creating-a-windows-10-vm-on-the-amd-ryzen-9-3900x-using-qemu-4-0-and-vga-passthrough/)

TBH I found setting this up on a new Arch system was the easiest and cleanest;
but I'd had a working system on Debian before. 

Like many things Linux, Arch documentation comes up often in searches online
and for good reason. This essential reading that can take you all the way to
the end:

* The Arch wiki, of course. [PCI passthrough via OVMF](https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF)
* [libvirt hooks](https://libvirt.org/hooks.html) documentation.
