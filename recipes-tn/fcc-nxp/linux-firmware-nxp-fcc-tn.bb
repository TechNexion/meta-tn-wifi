# Copyright (C) 2020 TechNexion Ltd.

SUMMARY = "WiFi FCC firmware files for TechNexion NXP module"
SECTION = "kernel"
LICENSE = "Proprietary"
LICENSE_FLAGS = "commercial_tn"
LIC_FILES_CHKSUM = "\
    file://COPYING;md5=e6e222793e083fc8e78f018829febddd \
"

SRCBRANCH = "master"
TN_NXP_FCC_FIRMWARE_SRC = "git://gitlab.com/technexion-imx/nxp_fcc_firmware.git;protocol=https;user=oauth2:${PA_TOKEN}"
SRC_URI = "${TN_NXP_FCC_FIRMWARE_SRC};branch=${SRCBRANCH}"
SRCREV = "3001a1455be7cdf3cb38508e794fa0e6c011188e"

do_check() {
    if [ -z "${PA_TOKEN}" ]; then
        bberror "Download NXP FCC Firmware requires personal access token (Please contact TechNexion: sales@technexion.com)"
    fi
}

addtask check before do_fetch

S = "${WORKDIR}/git"

do_install() {
    install -d ${D}${nonarch_base_libdir}/firmware/nxp
    install -m 0644 ${S}/sdio8978_uart_combo.bin ${D}${nonarch_base_libdir}/firmware/nxp
}

FILES:${PN}-dbg += "${nonarch_base_libdir}/firmware/.debug"
FILES:${PN} += "${nonarch_base_libdir}/firmware"

COMPATIBLE_MACHINE = "(imx-nxp-bsp)"
