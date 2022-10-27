# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DEPEND=""
RDEPEND="${DEPEND}"

LICENSE="Google-TOS"
SLOT="0"
KEYWORDS="-* arm64 arm"

DEPEND=""
RDEPEND=""

S="${WORKDIR}"

src_install() {
  #insinto "/etc/"
  #doins -r "${FILESDIR}/firmware/"

  insinto "/lib/firmware/"
  doins -r "${FILESDIR}"/firmware/*
}
