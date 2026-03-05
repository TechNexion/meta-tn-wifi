# Copyright (C) 2020-2026 TechNexion Ltd.

SUMMARY = "WiFi FCC firmware files for TechNexion NXP module config file"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " file://wifi_mod_para.conf"

python () {
    if bb.utils.contains('DISTRO_FEATURES', 'fcc-nxp-labtool-imx', True, False, d):
        d.appendVarFlag('do_install', 'postfuncs', ' install_fcc_custom_wifi_conf')
}

install_fcc_custom_wifi_conf() {
    install -d ${D}${nonarch_base_libdir}/firmware/nxp/
    bbnote "Applying custom FCC Bluez5 main.conf from meta-tn-wifi"
    install -m 0644 ${WORKDIR}/sources-unpack/wifi_mod_para.conf ${D}${nonarch_base_libdir}/firmware/nxp/
}