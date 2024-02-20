# PYNQ 3.0.1 for retaired Digilent Zybo  (2023 update)

This repo provides an attempt to port PYNQ for the old Zybo board. Unlike other tutorials, this implementation provides a newer image v3.0.1 and the correct ethernet MAC address. I attempted to add complementary remarks and thoughts regarding installation of Xilinx tools on headless (i.e using a text-mode terminal only) Linux-based machine. 

## Requrements

* A ubuntu 20.04 machine or VM.
* A storage partition with at least 300 GB of available data space.

## Prebuild image

[Lastest release](https://github.com/nick-petrovsky/PYNQ-ZYBO/releases/tag/v0.1.0)

The image is compressed with ZX archive. [BalenaEtcher](https://balenaetcher.org/) can be used for direct SD flashing without unpacking.

* Fixed volatile ethernet MAC (base bitstream is flashed on boot)
* Fixed HAVAGE daemon systemd service file (/lib/systemd/system/haveged.service)
* Simple Device tree with MIO btns and leds
  
## Install & build

0. Install fresh VM with Ubuntu 20.04 server

```bash
$ lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 20.04.6 LTS
Release:        20.04
Codename:       focal
```

1. Copy or download Xilinx distributions (Vivado 2022.1 and Petalinux 2022.1)

```bash
$ cp /nfs/upload/Xilinx/petalinux-v2022.1-04191534-installer.run .
$ cp /nfs/upload/Xilinx/Xilinx_Unified_2022.1_0420_0327.tar.gz .
```

2. Reconfigure Dash to Bash

```bash
$ sudo dpkg-reconfigure dash
```

3. Configure environment

Download PetaLinux environment configuration script: https://support.xilinx.com/s/article/73296?language=en_US

```bash
$ sudo dpkg --add-architexture i386
$ chmod 755 ./plnx-env-setup.sh
$ sudo ./plnx-env-setup.sh
```

4. Install Petalinux

```bash
$ mkdir ${HOME}/petalinux
$ chmod 755 ./petalinux-v2022.1-04191534-installer.run
$ ./petalinux-v2022.1-04191534-installer.run ./petalinux
```

5. Unpack and install Vivado in batch mode

During configgen select *1.Vivado*

```bash
$ tar xvf Xilinx_Unified_2022.1_0420_0327.tar.gz
$ cd Xilinx_Unified_2022.1_0420_0327
$ sudo ./installLibs.sh
$ ./xsetup -b ConfigGen
```

For non-gui setup switch off 'Shortcuts' and 'File associations' in `${HOME}/.Xilinx/install_config.txt`:
```bash
$ sed -i -e 's/CreateProgramGroupShortcuts=1/CreateProgramGroupShortcuts=0/g' \
-e 's/CreateShortcutsForAllUsers=1/CreateShortcutsForAllUsers=0/g' \
-e 's/CreateDesktopShortcuts=1/CreateDesktopShortcuts=0/g' \
-e 's/CreateFileAssociation=1/CreateFileAssociation=0/g' \
${HOME}/.Xilinx/install_config.txt
```

Install Vivado in batch-mode

```bash
$ sudo ./xsetup --agree XilinxEULA,3rdPartyEULA -b Install -c /home/${HOME}/.Xilinx/install_config.txt
```

## Build PYNQ image

6. Clone PYNQ and this repo

Clone PYNQ (https://pynq.readthedocs.io/en/latest/pynq_sd_card.html at this point we skip Vagrant)

```bash
$ mkdir ${HOME}/git-projects/
$ cd ${HOME}/git-projects/
$ git clone https://github.com/Xilinx/PYNQ.git
$ git clone https://github.com/nick-petrovsky/PYNQ-ZYBO.git
```

At time of writing working PYNQ commit is `de6b6fc3`, 1 commit after `tag v3.0.1`

```bash
$ cd ${HOME}/git-projects/PYNQ
$ git checkout de6b6fc3
```

7. [Optional] Download prebuild images for speeding up the build process [3]

```bash
$ wget https://bit.ly/pynq_arm_v3_1 -O ${HOME}/git-projects/PYNQ/sdbuild/prebuilt/pynq_rootfs.arm.tar.gz
$ wget https://bit.ly/pynq_sdist_v3_0_1 -O ${HOME}/git-projects/PYNQ/sdbuild/prebuilt/pynq_sdist.tar.gz
$ ls -lah ${HOME}/git-projects/PYNQ/sdbuild/prebuilt/ 
total 1.9G
drwxrwxr-x  2 user user 4.0K Dec 21 23:16 .
drwxrwxr-x 10 user user 4.0K Dec 23 13:25 ..
-rw-rw-r--  1 user user    0 Dec  3 13:09 .keep
-rw-rw-r--  1 user user 1.9G Dec 21 23:16 pynq_rootfs.arm.tar.gz
-rw-rw-r--  1 user user  61M Dec 21 23:16 pynq_sdist.tar.gz 
$ md5sum ${HOME}/git-projects/PYNQ/sdbuild/prebuilt/pynq_rootfs.arm.tar.gz 
b52dca2d35be25414a80f6a9e766f5af
$ md5sum ${HOME}/git-projects/PYNQ/sdbuild/prebuilt/pynq_sdist.tar.gz 
397df84345b2d7321b78d31ad14c4e0b 
```

If you plan to build for ZynqMP boards also:

```bash
$ wget https://bit.ly/pynq_aarch64_v3_0_1 -O ${HOME}/git-projects/PYNQ/sdbuild/prebuilt/pynq_rootfs.aarch64.tar.gz
```

8. Build PYNQ image and boot files for Zybo board 

Setup build env:
```bash
$ source ${HOME}/petalinux/settings.sh
$ source /tools/Xilinx/Vivado/2022.1/settings64.sh
$ source /tools/Xilinx/Vitis/2022.1/settings64.sh
```

Somewhy PYNQ referes `base.bit` file from `BOARDDIR` but do not build it automatically, so

```bash
$ cd ${HOME}/git-projects/PYNQ-ZYBO/Zybo
$ make
```

```bash
$ cd ${HOME}/git-projects/PYNQ
$ time make BOARDDIR=${HOME}/git-projects/PYNQ-ZYBO BOARDS=Zybo
```

Successful build requires approximately 40 minutes with pre-existing dependencies on an 8-core machine.

Usefull command if you plan to rebuild just kernel (approx 10 min):
```bash
$ time make boot_files BOARDDIR=${HOME}/git-projects/PYNQ-ZYBO BOARDS=Zybo
```

9. Flash SD card according manual https://pynq.readthedocs.io/en/v3.0.0/appendix/sdcard.html#writing-the-sd-card

```bash
$ ls -lah ${HOME}/git-projects/PYNQ/sdbuild/output/Zybo-3.0.1.img
```

10. [Optional] Volatile ethernet MAC address

Zybo board requires I2C0 wires through PL for EEPROM access (ethernet MAC and audio codec ssm2603 control). That's why PL have to be configured during boot for reading such values. Unfortunately, there is not way to include `base. Bit` file into `BOOT.bin` according behaviour `petalinux-package --boot` [page 26 of UG1157] while FPGA MANAGER is enabled. Forums suggest just to disable such option without loosing driver support. Seems that PYNQ makefiles property `FPGA_MANAGER_Zybo: = 0` is relevant, but unfortunately it affects final device tree and includes `pynq_zocl_intc_zynq.dtsi` with `axi_intc_0: interrupt-controller@70000000` perverts Linux kernel from normal boot. If you know better solution pull-requests are welcome. 

Possibly custom U-BOOT script that flashing FPGA and storing the MAC address in env is a more elegant solution.

I have decided to repack `BOOT.BIN` as my current solution. 

```bash
$ mkdir ${HOME}/git-projects/boot
$ cd ${HOME}/git-projects/boot
$ cp ${HOME}/git-projects/PYNQ/sdbuild/build/Zybo/petalinux_project/images/linux/bootgen.bif .
```
Add bitstream to `bootgen.bif`, put *absolute path* to your files:

```
the_ROM_image:
{
        [bootloader] /home/user/git-projects/PYNQ/sdbuild/build/Zybo/petalinux_project/images/linux/zynq_fsbl.elf
        /home/user/git-projects/PYNQ-ZYBO/Zybo/base/base.bit
        /home/user/git-projects/PYNQ/sdbuild/build/Zybo/petalinux_project/images/linux/u-boot.elf
        [load=0x00100000] /home/user/git-projects/PYNQ/sdbuild/build/Zybo/petalinux_project/images/linux/system.dtb

}
```

After building the `BOOT.BIN`, update it on the SD card.

```bash
$ rm /media/user/PYNQ/BOOT.BIN
$ cp ${HOME}/git-projects/boot/BOOT.BIN /media/user/PYNQ/BOOT.BIN
```

Unmount media and test it under u-boot, where `00fa: 80 80 80 80 80 80    ......` will be MAC of specific board:

```
Zynq> i2c dev 0
Setting bus to 0
Zynq> i2c probe
Valid chip addresses: 1A 50
Zynq> i2c md 50 fa 6
00fa: 80 80 80 80 80 80    ......
Zynq>
```

It can't find the reason why PL have to be unconfigured while FPGA MANAGER is enabled. Zybo is working without any problems in my situation and reconfiguring PL is also working.

## Known issues

1. If HAVEGE service slowing down the boot process. Add following options to `/etc/default/haveged`

```bash
# Configuration file for haveged

# Options to pass to haveged:
DAEMON_ARGS="-w 1024 -d16"
```

Patch following options in systemd file `/lib/systemd/system/haveged.service`

```bash
-SystemCallFilter=@basic-io @file-system @io-event @network-io @signal
-SystemCallFilter=arch_prctl brk ioctl mprotect sysinfo
+SystemCallFilter=@system-service
+SystemCallFilter=~@mount
+SystemCallErrorNumber=EPERM
```

References:
[1] - https://discuss.pynq.io/t/pynq-2-7-for-zybo-z7/4124
[2] - https://support.xilinx.com/s/article/73296?language=en_US
[3] - http://www.pynq.io/board.html
