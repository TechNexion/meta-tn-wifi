# Copyright (C) 2026 TechNexion Ltd.
SUMMARY = "WiFi FCC kernel device tree patch file for TechNexion NXP module"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

FCC_PATCH = "file://0001-arm64-dts-imx95-edm-disable-in-kernel-bluetooth-bind.patch"

# SRC_URI:append = " ${FCC_PATCH}"
SRC_URI:append = " ${@bb.utils.contains('DISTRO_FEATURES', 'fcc-nxp-labtool-imx', '${FCC_PATCH}', '', d)}"