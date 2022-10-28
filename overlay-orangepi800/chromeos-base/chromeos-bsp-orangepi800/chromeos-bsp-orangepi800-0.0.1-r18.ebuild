EAPI=5

DESCRIPTION="Orange Pi 800 BSP package (meta package to pull in driver/tool dependencies)"

inherit appid cros-audio-configs udev

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* arm64 arm"
IUSE="
	systemd 
	bluetooth"

DEPEND="
  >=chromeos-base/tty-0.0.1-r99
  >=chromeos-base/chromeos-bsp-baseboard-gru-0.0.3
"

RDEPEND="
  $DEPEND
  net-misc/rsync
  x11-drivers/mali-rules
  sys-boot/u-boot-orangepi
"

S="${WORKDIR}"

src_install() {
  doappid "{564AC308-CBD5-485D-9EF5-EB97DBB5F264}" "CHROMEBOOK"

  insinto /etc/init
  doins "${FILESDIR}/upstart/sdio-hciattach.conf"

  exeinto "/usr/bin"
  doexe "${FILESDIR}"/bluetooth/hciattach_opi

  insinto "/lib/firmware/"
  doins -r "${FILESDIR}"/firmware/*

  # Install audio config files
  local audio_config_dir="${FILESDIR}/audio-config"
  install_audio_configs kevin "${audio_config_dir}"

  # Install additional scripts
  exeinto "/usr/bin"
  doexe "${FILESDIR}"/scripts/*
}
