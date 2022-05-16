# Overview

This repo exists to house some random scripts I wrote to attempt hooking arbitrary block storage within a Raspberry pi 4B 8GB via the Linux USB gadget subsystem in a somewhat-reliable way, with the eventual goal of supporting multiple iSCSI mounts exposed via multiple usb gadget setups.

I actually got this working for media storage, but the Raspberry pi 4B models are limited in USB superspeed (e.g. 3.1, 5gbps/10gbps at a hardware level). This prevents it being used as game storage. That said, a file on a USB-connected hard drive was successfully exposed, so in theory iSCSI or other mounts could totally be used for screenshots, recordings, etc. for an Xbox One, thus enabling recordings to be easily published to common off the shelf NAS products.

# Disclaimer

I have not made this project production-ready, properly documented it, anticipated all edge cases, or otherwise expended an iota of proper effort to make this consumable by others reliably. *Use at your own risk.*

# Requirements

I've only run this on a Raspberry Pi 4B 8GB; it's quite possible this could be run on something else.
The script requires root permissions to handle mounting and unmounting filesystems / enabling kernel modules.
This is built for Linux, to be run on a host supporting USB device mode - most computers are not capable of this, nor USB chipsets. Additionally, support for the USB gadget subsystem must be present.

## Raspberry pi device tree overlay

You should edit /boot/config.txt and add/edit a line to match as follows:
```
dtoverlay=dwc2,dr_mode=peripheral
```

This is how to get device tree to run the USB chip in device mode versus host mode

# Installation

I don't have a real procedure for this; I was running Raspbian Buster with files deployed roughly as follows:

## Install the script

Place the shell script where you want it; I decided on /root (root's home dir) for various reasons:

## Modify the script

Change the `file` variable towards the top of the script; I didn't bother parameterizing it properly.

## Set the file permissions for the script

Run the following command, or one like it (ensuring path is correct), to ensure the script is executable by root:
```
sudo chmod u+x /root/console-nas-link.sh
```

## For systemd

Assuming you're using systemd, follow these instructions to handle installation of a systemd unit (the .service file)

### Edit the systemd unit

You should edit the systemd unit if you installed the shell script somewhere other than /roota, to ensure it is referenced correctly. To accomplish this, locate references to /root/console-nas-link.sh and customize as needed

### Install the systemd unit

Place the systemd unit at the following path:
```
/etc/systemd/system/console-nas-link.service
```

### For autostart

To ensure the service is started at boot, run the following command:
```
sudo systemctl enable console-nas-link
```

### Operations

To start it:
```
sudo systemctl start console-nas-link
```

To stop it:
```
sudo systemctl stop console-nas-link
```
## Manually

For testing, closer control, or alternative orchestration, executing the shell script directly is possible; simply modify the path if needed depending on where you installed it when invoking, and do so with root privileges (as root or via `sudo`).

To see current status:
```
sudo /root/console-nas-link.sh status
```

To start:
```
sudo /root/console-nas-link.sh start
```

To stop:
```
sudo /root/console-nas-link.sh stop
```
