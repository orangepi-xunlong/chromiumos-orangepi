# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_REPO="https://github.com/orangepi-xunlong"
CROS_WORKON_COMMIT="e0c5dcfa377c722012f8fd2d227dd61984b325ed"
CROS_WORKON_EGIT_BRANCH="orange-pi-5.10-rk3399-cros"
CROS_WORKON_PROJECT="linux-orangepi"
CROS_WORKON_LOCALNAME="linux-kernel"
CROS_WORKON_INCREMENTAL_BUILD="1"

# This must be inherited *after* EGIT/CROS_WORKON variables defined
inherit cros-workon cros-kernel2

DEPEND="!sys-kernel/chromeos-kernel-4_4"
RDEPEND="${DEPEND}"

HOMEPAGE="https://www.chromium.org/chromium-os/chromiumos-design-docs/chromium-os-kernel"
DESCRIPTION="Chrome OS Linux Kernel 5.10"
KEYWORDS="*"

# Change the following (commented out) number to the next prime number
# when you change "cros-kernel2.eclass" to work around http://crbug.com/220902
#
# NOTE: There's nothing magic keeping this number prime but you just need to
# make _any_ change to this file.  ...so why not keep it prime?
#
# Don't forget to update the comment in _all_ chromeos-kernel-x_x-9999.ebuild
# files (!!!)
#
# The coolest prime number is: 173

src_install() {
  local kernel_dir=$(cros-workon_get_build_dir)
  local kernel_arch=${CHROMEOS_KERNEL_ARCH:-$(tc-arch-kernel)}
  local kernel_release=$(kernelrelease)
  local kernel_version=$(kmake -s kernelversion)

  info "Install /boot/"
        dodir /boot
        kmake INSTALL_PATH="${D}/boot" install

  info "Install /usr/lib/debug/boot/"
        insinto /usr/lib/debug/boot
        doins "$(cros-workon_get_build_dir)/vmlinux"

  info "Install /lib/modules/"
  kmake INSTALL_MOD_PATH="${D}" INSTALL_MOD_STRIP="magic" \
    STRIP="$(eclass_dir)/strip_splitdebug" \
    modules_install

  info "Install /boot/dtbs/"
        kmake INSTALL_DTBS_PATH="${D}/boot/dtbs/$(kernelrelease)" dtbs_install

  info "Install ${D}/boot/extlinux.conf"
  cat > "${kernel_dir}/extlinux.conf" <<EOF
menu title Boot Menu
timeout 20
#default rockchip-${kernel_release}-debug

label dev-${kernel_version}-rockchip-dev
    kernel /boot/vmlinuz-${kernel_version}-rockchip-dev
    devicetreedir /boot/dtbs/${kernel_version}-rockchip-dev
    append earlyprintk console=ttyS2,1500000n8 rw root=/dev/\${bootdevice}p\${bootdevice_part} rootfstype=ext4 init=/sbin/init rootwait cros_debug loglevel=2 dm_verity.error_behavior=3 dm_verity.max_bios=-1 dm_verity.dev_wait=0 dm="1 vroot none ro 1,0 2539520 verity payload=/dev/\${bootdevice}p\${bootdevice_part} hashtree=HASH_DEV hashstart=2539520 alg=sha1 root_hexdigest=a1910fbe4a24a30d19a49b85d2889776251e54e3 salt=c520b38f1057e5bef0aa64c00cd0d2e50662e22bf19771278921f90a35fd616d" vt.global_cursor_default=0 ethaddr=\${ethaddr} serial=\${serial#}

label rockchip-${kernel_release}-debug
    kernel /boot/vmlinuz-${kernel_release}
    devicetreedir /boot/dtbs/${kernel_release}
    append earlyprintk console=ttyS2,1500000n8 rw root=/dev/\${bootdevice}p\${bootdevice_part} rootfstype=ext4 init=/sbin/init rootwait cros_debug loglevel=2 dm_verity.error_behavior=3 dm_verity.max_bios=-1 dm_verity.dev_wait=0 dm="1 vroot none ro 1,0 2539520 verity payload=/dev/\${bootdevice}p\${bootdevice_part} hashtree=HASH_DEV hashstart=2539520 alg=sha1 root_hexdigest=a1910fbe4a24a30d19a49b85d2889776251e54e3 salt=c520b38f1057e5bef0aa64c00cd0d2e50662e22bf19771278921f90a35fd616d" vt.global_cursor_default=0 ethaddr=\${ethaddr} serial=\${serial#}

label rockchip-${kernel_release}
    kernel /boot/vmlinuz-${kernel_release}
    devicetreedir /boot/dtbs/${kernel_release}
    append earlyprintk console=ttyS2,1500000n8 ro root=/dev/\${bootdevice}p\${bootdevice_part} rootfstype=ext4 init=/sbin/init rootwait loglevel=2 dm_verity.error_behavior=3 dm_verity.max_bios=-1 dm_verity.dev_wait=0 dm="1 vroot none ro 1,0 2539520 verity payload=/dev/\${bootdevice}p\${bootdevice_part} hashtree=HASH_DEV hashstart=2539520 alg=sha1 root_hexdigest=a1910fbe4a24a30d19a49b85d2889776251e54e3 salt=c520b38f1057e5bef0aa64c00cd0d2e50662e22bf19771278921f90a35fd616d" vt.global_cursor_default=0 ethaddr=\${ethaddr} serial=\${serial#}
EOF

  insinto "/boot/extlinux"
  doins "${kernel_dir}/extlinux.conf"
}
