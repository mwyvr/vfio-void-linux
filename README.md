# vfio-void-linux
My kvm / vfio / libvirt / qemu config for a Void Linux host, Windows 11 guest.

Hook scripts are useful for other
Linux guests if dedicating the entire second display to them.

## tl;dr

IMO Windows runs better in as a VM on Linux; I get bare-metal-enough
performance that I can do photo editing in Photoshop and Lightroom, and play
some games (very rarely), in the vm.

## Hardware Config

    * Board: Gigabyte X570 AORUS MASTER, BIOS F35b 09/06/2021
    * Intel (for host) and Realtek (passed through) NICs
    * CPU: AMD Ryzen 7 3800X 8-Core Processor
    * Mem: 62GB (32GB allocated dynamically to VM as transparent hugepages)
    * Host GPU: Radeon RX 5600 OEM/5600 XT / 5700/5700 XT
    * Guest GPU: GeForce GTX 1660 SUPER
    * Host SSD: Sabrent Rocket 1TB (Phison Electronics Corporation E16 PCIe4 NVMe)
    * Guest SSD: (for Windows only) Sabrent Rocket 1TB (Phison Electronics Corporation E16 PCIe4 NVMe)

## Mouse and Keyboard Sharing with barrier

[Barrier](https://github.com/debauchee/barrier) `barriers` runs as a server (started and stopped in 
the hook scripts); allows for transparent mouse and clipboard use between the host and guest; you
can even add a non-VM client like a laptop or other desktops if you like.

## Audio

Via `pipewire` - see the top and bottom of the VM definition in `windows.xml` for the relevant
incantation; in your `qemu.conf` set user=<YOU>.

## Hooks

I've generalized my setup with a few variables in `kvm.conf`; you may find dropping these in
may work for you with just a little tweaking. 
   
There's also https://github.com/PassthroughPOST/VFIO-Tools/blob/master/libvirt_hooks/hooks/switch_displays.sh linked
appropriately to have `ddcutil` switch the display inputs between host->guest and back to host when the VM shuts down. That in combination with `xrandr` sets my dwm displays back to normal, achieving "starting Windows like an X app" convenience.

Some assembly will be required:

    # clone this repo, somewhere
    cd ~
    git clone https://github.com/solutionroute/libvirt-win.git

    # link to the hooks directory in the appropriate libvirt
    # path for your system
    cd /etc/libvirt
    sudo ln -s ~/libvirt-win/etc/libvirt/hooks .



It's important that commands within your hook scripts don't fail with an error; this will cause startup to halt and the release
scripts to be called.
   
*Testing tip*: you can run your hook scripts one by one from the command line in this manner:

    /etc/libvirt/hooks/qemu windows start begin

