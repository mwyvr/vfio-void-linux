# Linux As A Guest

## XML

xxx insert link(s) to template xml

## NVIDIA XOrg Configuration

In `/etc/X11/xorg.conf.d/10-nvidiahack.conf` add:

    # Overcomes problem with Xorg/xrandr not utilizing the nvidia GPU despite detecing it.
    # PrimaryGPU seems to be the key parameter.
    # This is the only Xorg configuration needed.
    Section "OutputClass"
        Identifier  "nvidia"
        MatchDriver "nvidia-drm"
        Driver      "nvidia"
        Option      "PrimaryGPU" "yes"
    EndSection

