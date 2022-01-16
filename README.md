# libvirt-win
My libvirt / qemu config for a Linux host, Windows 11 guest, with some possibly helpful libvirt hook scripts.

## tl;dr

IMO Windows runs better in as a VM on Linux; I get bare-metal-enough
performance that I can do photo editing in Photoshop and Lightroom, and play
some games (very rarely), in the vm.

## Hardware Config

    * Board: Gigabyte X570 AORUS MASTER, BIOS F35b 09/06/2021
    * Intel (for host) and Realtek NICs
    * CPU: AMD Ryzen 7 3800X 8-Core Processor
    * Mem: 62GB (32GB allocated dynamically to VM as hugepages)
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

A snippet from the libvirt hook "started begin" [script](https://github.com/solutionroute/libvirt-win/blob/main/etc/libvirt/hooks/qemu.d/win11/started/begin/free_guest_monitor.sh):

    if test -n "`pidof barriers`"; then killall -9 barriers; fi

    # As user, start barrier keyboard and mouse sharing daemon; client installed on VM
    runuser $RUNAS -c "DISPLAY=$HOST_DISPLAY /usr/bin/barriers --no-tray --address $HOST_IP:24800 \
      --name $HOST_NAME --disable-crypto --disable-client-cert-checking \
      -c /home/$RUNAS/.config/barrier/barrier.conf"

## Audio

Via `pulseaudio` - see the bottom of the VM definition in `win11.xml` for the relevant
mods, and you'll likely need to check the VM is starting up as you/user 1000 or what have
you, rather than root. 

## Drop in use of my hooks

I've generalized my setup with a few variables in `kvm.conf`; you may find dropping these in
may work for you with just a little tweaking.

    # clone this repo, somewhere
    cd ~
    git clone https://github.com/solutionroute/libvirt-win.git

    # link to the hooks directory in the appropriate libvirt
    # path for your system
    cd /etc/libvirt
    sudo ln -s ~/libvirt-win/etc/libvirt/hooks .

Tune as required. You end up with a tree structure that looks like this:

     |-hooks
       |---kvm.conf                         - customization variables
       |---qemu.d
       |-----win11                          - vm definition
       |-------prepare
       |---------begin                      - alloc resources for the guest vm
                    alloc_hugepages.sh 
                    bind_vfio.sh
                    cpu_mode_performance.sh
       |-------started                      - occurs after the vm has successfully started up
       |---------begin
                    free_guest_monitor.sh
       |-------release
       |---------end
                    cpu_mode_ondemand.sh    - these give resources back to the linux host
                    dealloc_hugepages.sh  
                    unbind_vfio.sh
       |-------stopped
                    take_back_monitor.sh
       |---------end
       |-qemu                               - master script libvirt calls


It's important that commands within your hook scripts:

a) run as the appropriate user; I've used `runuser`.

b) don't fail with an error; this will cause startup to halt and the release
scripts to be called. You'll see some tests in the scripts to avoid simple
failures like "killall somethingnotrunning".

*Testing tip*: you can run your hook scripts one by one from the command line in this manner:

    /etc/libvirt/hooks/qemu win11 start begin

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

TBH I found setting this up on a new Arch system was the easiest and cleanest;
I'm not sure that's so much an Arch thing as it was I'd been through this before
on Debian and had a better understanding of how things hung together now.

Like many things Linux, Arch documentation comes up often in searches online
and for good reason. This essential reading that can take you all the way to
the end:

* The Arch wiki, of course. [PCI passthrough via OVMF](https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF)
* [libvirt hooks](https://libvirt.org/hooks.html) documentation.
* From my Debian days, guides from [Heiko Sieger](https://www.heiko-sieger.info/running-windows-10-on-linux-using-kvm-with-vga-passthrough/)
  and [Bryan Steiner](https://github.com/bryansteiner/gpu-passthrough-tutorial).

Much of what needs to be done will be similar on any system, with the main differences
being how to pass blacklist or vfio bind instructions to the system at bot time.
