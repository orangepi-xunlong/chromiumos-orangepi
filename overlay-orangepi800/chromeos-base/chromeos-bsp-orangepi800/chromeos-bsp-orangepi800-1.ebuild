EAPI=5

DESCRIPTION="OrangePi800 BSP package (meta package to pull in driver/tool dependencies)"

inherit systemd cros-audio-configs udev

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* arm64 arm"
IUSE="systemd"
USE="bt_deprecated_tools"

DEPEND="
  >=chromeos-base/tty-0.0.1-r99
  >=chromeos-base/chromeos-bsp-baseboard-gru-0.0.3
"

RDEPEND="
  $DEPEND
  net-misc/rsync
  net-wireless/bluez
  sys-boot/rockchip-uboot
"

S="${WORKDIR}"

src_install() {
  insinto /etc/init
  doins "${FILESDIR}/upstart/sdio-hciattach.conf"

  # Install mapping for brightness controls
  insinto "/etc/udev/hwdb.d"
  doins "${FILESDIR}"/hwdb/*

  # Install Bluetooth ID override.
  insinto "/etc/bluetooth"
  doins "${FILESDIR}"/bluetooth/main.conf

  exeinto "/usr/bin"
  doexe "${FILESDIR}"/bluetooth/brcm_patchram_plus

  exeinto "/usr/bin"
  doexe "${FILESDIR}"/bluetooth/hciattach_opi

  insinto "/usr/share/chromeos-assets"
  doins -r "${FILESDIR}/wallpaper"

  insinto "/usr/share/power_manager/board_specific"
  doins "${FILESDIR}"/powerd_prefs/*

  # Install audio config files
  local audio_config_dir="${FILESDIR}/audio-config"
  install_audio_configs orangepi800 "${audio_config_dir}"

  # Install additional scripts
  exeinto "/usr/bin"
  doexe "${FILESDIR}"/scripts/*
}
