# mkimage -C none -A arm -T script -d boot.cmd boot.scr

setenv fdtfile rockchip/rk3399-orangepi-800.dtb

# Detect bootdevice
if test "${devtype}${devnum}" = "mmc0"; then
  setenv bootdevice mmcblk0 # SD
elif test "${devtype}${devnum}" = "mmc1"; then
  setenv bootdevice mmcblk1 # SDHCI
fi

setenv bootdevice mmcblk1

echo "FDT: ${fdtfile}"
echo "Bootdevice: ${bootdevice}"

if test -e ${devtype} ${devnum}:${distro_bootpart} ${prefix}/first-b.txt; then
  echo "Found ${prefix}/first-b.txt, trying ROOT-B first"
  setenv prefix /boot
  setenv distro_bootpart 5
  setenv bootdevice_part 5
  run boot_extlinux
fi

# Scan ROOT-A
setenv prefix /boot/
setenv distro_bootpart 3
setenv bootdevice_part 3
run boot_extlinux

# Scan ROOT-B
setenv prefix /boot
setenv distro_bootpart 5
setenv bootdevice_part 5
run boot_extlinux
