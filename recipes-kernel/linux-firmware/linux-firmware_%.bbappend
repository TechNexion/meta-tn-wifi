# Copyright 2017-2022 NXP

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

IMX_FIRMWARE_SRC ?= "git://github.com/nxp-imx/imx-firmware.git;protocol=https"
SRCBRANCH_imx-firmware = "lf-6.6.23_2.0.0"
SRC_URI += " \
    ${IMX_FIRMWARE_SRC};branch=${SRCBRANCH_imx-firmware};destsuffix=imx-firmware;name=imx-firmware \
"

SRCREV_imx-firmware = "7e038c6afba3118bcee91608764ac3c633bce0c4"

SRCREV_FORMAT = "default_imx-firmware"

do_install:append () {
    # Install NXP Connectivity
    install -d ${D}${nonarch_base_libdir}/firmware/nxp
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/wifi_mod_para.conf    ${D}${nonarch_base_libdir}/firmware/nxp

    # Install NXP Connectivity IW416 firmware
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_IW416_SD/sdioiw416_wlan_v0.bin      ${D}${nonarch_base_libdir}/firmware/nxp
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_IW416_SD/sdiouartiw416_combo_v0.bin ${D}${nonarch_base_libdir}/firmware/nxp
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_IW416_SD/uartiw416_bt_v0.bin        ${D}${nonarch_base_libdir}/firmware/nxp

    # Install NXP Connectivity IW612 firmware
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_IW612_SD/sduart_nw61x_v1.bin.se ${D}${nonarch_base_libdir}/firmware/nxp
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_IW612_SD/sd_w61x_v1.bin.se      ${D}${nonarch_base_libdir}/firmware/nxp
    install -m 0644 ${WORKDIR}/imx-firmware/nxp/FwImage_IW612_SD/uartspi_n61x_v1.bin.se ${D}${nonarch_base_libdir}/firmware/nxp
}

# Use the latest version of sdma firmware in firmware-imx
PACKAGES =+ " ${PN}-nxpiw416-sdio"
PACKAGES =+ " ${PN}-nxpiw612-sdio"

FILES:${PN}-nxpiw416-sdio = " \
       ${nonarch_base_libdir}/firmware/nxp/* \
"

FILES:${PN}-nxpiw612-sdio = " \
       ${nonarch_base_libdir}/firmware/nxp/* \
"
