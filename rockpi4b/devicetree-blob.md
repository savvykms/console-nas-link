# Background

This procedure is a rough method I used to set up OTG on a Rock Pi 4B, which supposedly supports USB "superspeed" over the OTG port (a USB 3.0 type A connector in this case). This procedure was tested with a very specific configuration without any real applications in place; use this at your own risk. It may not work for you properly.

# Pre-requisites:
Stock image of "rockpi-4b-ubuntu-focal-server-arm64-20220506-0241-gpt.img" burned to an SD card or another bootable media setup on a Rock Pi 4B SBC. Basic knowledge of command line interfaces and their uses in editing plain text files, moving files, and filesystem permissions is highly recommended.

# Procedure

Install the device tree compiler if you don't have it:
```
sudo apt-get update
sudo apt-get install device-tree-compiler
```

Make a work directory:
```
mkdir ~/dts
cd ~/dts
```

Backup existing device tree blob:
```
sudo cp /boot/dtbs/5.10.103+/rockchip/rk3399-rock-pi-4b.dtb /boot/dtbs/5.10.103+/rockchip/rk3399-rock-pi-4b.dtb.backup
```

Copy existing device tree blob to our work directory (and make an extra backup):
```
sudo cp /boot/dtbs/5.10.103+/rockchip/rk3399-rock-pi-4b.dtb ~/dts
cp rk3399-rock-pi-4b.dtb rk3399-rock-pi-4b.dtb.backup
```

Obtain device tree source file:
```
dtc -I dtb -O dts -o rk3399-rock-pi-4b.dts rk3399-rock-pi-4b.dtb
```

Change `dr_mode` for `usb@fe800000` from `otg` to `peripheral`:
```
sed -ri 's/dr_mode = "otg";/dr_mode = "peripheral";/' rk3399-rock-pi-4b.dts
```

Compile a new device tree blob:
```
dtc -I dts -O dtb -o rk3399-rock-pi-4b-mod.dtb rk3399-rock-pi-4b.dts
```

Deploy new device tree blob:
```
sudo chown root:root rk3399-rock-pi-4b-mod.dtb
sudo mv rk3399-rock-pi-4b-mod.dtb /boot/dtbs/5.10.103+/rockchip/rk3399-rock-pi-4b.dtb
```

You may want to preserve console history by exiting your shell or another means at this point, in case you have issues.

Reboot:
```
sudo reboot now
```

# Verification

After a reboot, the following should show "peripheral":
```
cat /proc/device-tree/usb@fe800000/usb@fe800000/dr_mode; echo
```

After connecting to a host as a peripheral, the following should return "super-speed":
```
cat /sys/class/udc/fe800000.usb/current_speed
```

If it does not, make sure you have a quality cable
