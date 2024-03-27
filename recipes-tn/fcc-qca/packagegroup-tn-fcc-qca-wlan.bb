# Copyright (C) 2020 TechNexion Ltd.
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "Detemine Correct TechNexion's WIFI FCC firmware and drivers"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302 \
                    file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

inherit packagegroup

PACKAGES:remove:brcm = "linux-firmware-brcm"
PACKAGES:remove:ath-pci = "linux-firmware-ath10k"
PACKAGES:remove:qca = "linux-firmware-qca"
RDEPENDS:${PN}:append = " linux-firmware-qca-fcc-tn"

# Extra Kernel Modules
RDEPENDS:${PN}:append = " ${@bb.utils.contains('COMBINED_FEATURES', 'wifi', 'kernel-module-qcacld-tn', '',d)}"
