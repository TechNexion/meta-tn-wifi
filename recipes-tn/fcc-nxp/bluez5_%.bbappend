
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " file://main.conf"

python () {
    if bb.utils.contains('DISTRO_FEATURES', 'fcc-nxp-labtool-imx', True, False, d):
        d.appendVarFlag('do_install', 'postfuncs', ' install_fcc_custom_bluez5_conf')
}

install_fcc_custom_bluez5_conf() {
    install -d ${D}${sysconfdir}/bluetooth/
    bbnote "Applying custom FCC main.conf"
    install -m 0644 ${S}/sources-unpack/main.conf ${D}${sysconfdir}/bluetooth/
}
