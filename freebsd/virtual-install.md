# RENAME THIS TO VM EXPERIMENTS
# FreeBSD VM on Linux

Configured a basic machine, ignoring my passthrough GPU and NIC.

Personally, I'm running CURRENT. Beware, but it's not too risky compared to others.

The "bootonly" ISO is enough; the xz compressed version can be decompressed as:

    xz -d FreeBSD-14.0-CURRENT-amd64-20211230-b406897911e-252039-bootonly.iso.xz
https://download.freebsd.org/snapshots/amd64/amd64/ISO-IMAGES/14.0/
https://www.freebsd.org/where/

## Base Install

    pkg install sudo, neovim



First, fix your keyboard; tcsh is a decent shell but needs to be in vimode; in
~/.cshrc in an appropriate place:

    bindkeys -v



## Virt Manager

sudo pkg install dbus  
sudo sysrc dbus_enable="YES"

## Xorg

sudo pkg install xorg-minimal xrdb libXft 

roboto
picom
dunst
nitrogen


cd /usr/ports/x11-wm/dwm  
sudo make extract  
cd work

https://artnoi.wordpress.com/2019/08/06/freebsd-x230-dwm/

fetchsnap the ports collection
cd x11-wm/dwm
make extract
copy/edit config.h as needed



https://nudesystems.com/install-freebsd-with-xfce-and-nvidia-drivers/

https://nudesystems.com/how-to-fix-no-screen-found-xorg-error-on-freebsd/

    Section "Device"
        Identifier     "nvidia"
        Driver         "nvidia"
        BusID          "PCI:3:0:0"
    EndSection


## Void Linux

Love their documentation; clean. Mostly helpful.
https://docs.voidlinux.org/installation/index.html

PCI 7...

Installed xfce edition to take a quick look; for some reason could never get barrierc kkll
to connect. Bizarre. 

Also, curl isn't on the default system, which prevented my nvim auto-install. FYI.

Liked the install; their runit system takes a bit of getting used to.

Pros:

- detected / supported my Realtek 2.6gb adapter out of the box (FreeBSD did not, but had a driver)
- install process overall clean; 
- no issues with VM at any point; Q35/OVMF definition
- very fast boot into XFCE; install uses ncurses system familiar to BSD users

## Artix Linux

Messier web presence.

So far a great end result though.

No entry for America/Vancouver

https://www.youtube.com/watch?v=nCc_4fSYzRA



artools-chroot - now artix-chroot

run basestrap - include image




other packages to add:

    man
    linux-headers
    nvidia nvidia-dkms



Post install tasks:

1. ln -s /usr/share/zoneinfo/...  /etc/localtime
2. nvim /etc/locale.gen - pick
3. locale-gen
4. edit locale.conf - LANG=en_CA.UTF-8
5. 

Install connman and optionally a front-end:
:q

 pacman -S connman-openrc connman-gtk (or cmst for Qt-based DEs)
 rc-update add connmand

Add your ethernet interface to config, what is it?
    ip -s link

    Add:

    config_eth0="dhcp"


## Making your passed-through GPU be the default device for system boot/console

When running a VM without say a Spice Server/emulated VGA, your system *must*
boot to the graphical environment or you'll have no control. By default, on my
system, nvidia cards do not do this.

Resources:
https://passthroughpo.st/explaining-csm-efifboff-setting-boot-gpu-manually/
https://www.techpowerup.com/vgabios/

Let's try.

### Determine your card's ROM version
nvidia-smi -q | grep BIOS 
    VBIOS Version                         : 90.16.42.00.BC

    or, without a tool:

    cat /proc/driver/nvidia/gpus/0000\:0a\:00.0/information
cat: '/proc/driver/nvidia/gpus/0000:0a:00.0/information': No such file or directory

cat /proc/driver/nvidia/gpus/0000\:07\:00.0/
information  power        registry     
[mw@thumper ~]$ cat /proc/driver/nvidia/gpus/0000\:07\:00.0/information 
Model: 		NVIDIA GeForce GTX 1660 SUPER
IRQ:   		58
GPU UUID: 	GPU-4c7d7902-25c4-8456-a90c-1505e82394a2
Video BIOS: 	90.16.42.00.bc
Bus Type: 	PCIe
DMA Size: 	47 bits
DMA Mask: 	0x7fffffffffff
Bus Location: 	0000:07:00.0
Device Minor: 	0
GPU Excluded:	No

                     






