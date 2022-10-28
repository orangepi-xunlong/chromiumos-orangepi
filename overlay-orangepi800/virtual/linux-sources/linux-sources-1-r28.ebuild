# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Chrome OS Kernel virtual package"
HOMEPAGE="http://src.chromium.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE_KERNEL_VERS=(
	orangepi-kernel	
)
IUSE="${IUSE_KERNEL_VERS[*]}"
REQUIRED_USE="^^ ( ${IUSE_KERNEL_VERS[*]} )"

RDEPEND="
	orangepi-kernel? ( sys-kernel/orangepi-kernel )
"
