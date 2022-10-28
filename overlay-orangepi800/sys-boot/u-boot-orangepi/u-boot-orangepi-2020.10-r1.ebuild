EAPI=5

VARIANT="orangepi800"

DESCRIPTION="Rockchip U-boot"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* arm64 arm"

DEPEND=""
RDEPEND=""

S="${WORKDIR}"

src_compile() {
	mkimage -O linux -T script -C none -a 0 -e 0 \
		-n "boot" -d "${FILESDIR}/boot.cmd" "boot.scr" || die
}

src_install() {
	dd if="${FILESDIR}/u-boot-orangepi800-merged.bin" of="${S}/bootloader.bin" skip=64

	insinto /boot
	doins boot.scr
	doins bootloader.bin
}
