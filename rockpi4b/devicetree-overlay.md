
# IMPORTANT - READ THIS

This procedure is being kept as notes; it DOES NOT WORK. The rock pi 4b with the OS image I used cannot use overlays like this.

See devicetree-blob.md instead.

# See above

# Seriously, look above

# Background

A device tree overlay is necessary since Linux kernel version 5.11 due to the following change, which forces the OTG port to only work in host mode:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi?id=e12f67fe83446432ef16704c22ec23bd1dbcd094

A device tree overlay (dtbo) can be compiled from a source file (dts) to force the "dr_mode" property to one of "host", "peripheral", or "otg".

To make a device tree overlay function for a Rock PI 4b, pay attention to the post made by "bartsch" on the radxa forums:
https://forum.radxa.com/t/usb-otg-not-working-properly-rockpi-4b/9562/8

The full device tree overlay (version 1 format) is as follows (modified `dr_mode` to `otg`):
```
/dts-v1/;
/plugin/;

/ {
    compatible = "rockchip,rk3399";
    fragment@0 {
      target = <&usbdrd_dwc3_0>;
      __overlay__ {
        dr_mode = "otg";
      };
    };
};
```

This explicitly sets the "dr_mode" property for the "dwc3" driver.

# Procedure

## 1. Preparation

Install the device tree compiler if you don't have it:
```
sudo apt-get update
sudo apt-get install device-tree-compiler
sudo apt-get install wget
```

Make a directory and change your working directory to it:
```
mkdir ~/dts
cd ~/dts
```
Create a text file called `otg-overlay.dts` with the contents of the file from the "Background" section above.

## 2. Compilation

Compile it into a .dtbo file:
```
dtc -I dts -O dtb -o otg.dtbo otg-overlay.dts
```

## 3. Installation / activation

Consult the documentation Radxa provides if needed to determine where to put the overlay, and how to enable it:
https://wiki.radxa.com/Rockpi4/hardware/devtree_overlays

### 3.1 /boot/hw_intfc.conf

Run these commands if `/boot/hw_intfc.conf` does not exist:
```
wget https://raw.githubusercontent.com/radxa/kernel/00fccd37c63cd51b2ae9b3af965f975c561674b1/arch/arm64/boot/dts/rockchip/overlays-rockpi4/hw_intfc.conf && sudo chown root:root hw_intfc.conf && sudo mv hw_intfc.conf /boot
```

### 3.2 /boot/overlays/

Run these commands if /boot/overlays/ does not exist:
```
sudo mkdir /boot/overlays
```

### 3.3 Copy dtbo to overlays:

Run the following commands to get
```
cd ~/dts/
sudo chown root:root otg.dtbo
sudo mv otg.dtbo /boot/overlays/otg.dtbo
```

### 3.4 Activate the overlay

You'll need to modify `/boot/hw_intfc.conf` by adding a line:
```
sudo bash -c "echo -e '\n# Change dwc3 dr_mode to "otg"\nintfc:dtoverlay=otg\n' >> /boot/hw_intfc.conf"
```

## 4. Reboot

Now you just need to reboot to apply settings; be sure you're okay with shutting down the system, and run the following command (or just power cycle however you usually do):
```
sudo reboot now
```
