FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

do_install:append:mx9-nxp-bsp () {
    if [ -e "${D}${sysconfdir}/modprobe.d/blacklist.conf" ]; then
        sed -i '/^blacklist btnxpuart$/d' ${D}${sysconfdir}/modprobe.d/blacklist.conf
    fi
}
