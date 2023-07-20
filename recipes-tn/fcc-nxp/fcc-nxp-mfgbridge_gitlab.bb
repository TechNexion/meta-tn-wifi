# Copyright (C) 2020 TechNexion Ltd.

SUMMARY = "TechNexion NXP mfgbridge"
DESCRIPTION = "mfgbridge server for TechNexion NXP WIFI modules"
SECTION = "app"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://bridge/load.sh;md5=e1403c4257571d153675a942a4f89b40"

SRCBRANCH = "1.0.0.13-16.80.21.p51"
TN_NXP_WIFI_TOOL_SRC = "git://gitlab.com/technexion-imx/mfgbridge.git;protocol=https;user=oauth2:${PA_TOKEN}"
SRC_URI = "${TN_NXP_WIFI_TOOL_SRC};branch=${SRCBRANCH} \
           file://fcc-bt@.timer \
           file://fcc-bt@.service \
           file://fcc-mfgbridge.service \
           file://20-wired.network \
           file://main.conf \
"
SRCREV = "5d77a9dcaebf6fcbf27b03bc69189aec39167011"

inherit features_check
REQUIRED_DISTRO_FEATURES = "systemd fcc-nxp"

S = "${WORKDIR}/git"

DEPENDS:append = "bluez5"
RDEPENDS:${PN} = "bluez5"

FILES:${PN} += " ${sbindir}/mfgbridge \
                 ${sbindir}/bridge_init.conf \
                 ${systemd_unitdir}/system/fcc-bt@.timer \
                 ${systemd_unitdir}/system/fcc-bt@.service \
                 ${systemd_unitdir}/system/fcc-mfgbridge.service \
                 ${sysconfdir}/systemd/network/20-wired.network \
                 ${sysconfdir}/bluetooth/main.conf \
"

do_check() {
    if [ -z "${PA_TOKEN}" ]; then
        bberror "Download NXP mfgbridge tool requires personal access token (Please contact TechNexion: sales@technexion.com)"
    fi
}

addtask check before do_fetch

INSANE_SKIP:${PN} = "ldflags"
INSANE_SKIP:${PN}-dev = "ldflags"
#CFLAGS += "-Wl,--no-undefined -L${RECIPE_SYSROOT}${nonarch_libdir}"

#do_compile() {
#    cp -r ${RECIPE_SYSROOT}/${includedir}/bluetooth ${S}
#    oe_runmake build
#}

do_install() {
    ttydev=`echo "${SERIAL_BLUETOOTH}" | sed -e 's/^[0-9]*\;//' -e 's/\;.*//'`
    default_baudrate=`echo "${SERIAL_BLUETOOTH}" | sed 's/\;.*//'`
    install -d "${D}${sbindir}"
    install -m 0755 ${S}/bridge/mfgbridge "${D}${sbindir}"
    install -m 0644 ${S}/bridge/bridge_init.conf "${D}${sbindir}"
    sed -i -e s/ttyS0/$ttydev/g ${D}${sbindir}/bridge_init.conf

    install -d ${D}${systemd_unitdir}/system/
    install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants/
    install -d ${D}${sysconfdir}/systemd/system/timers.target.wants/
    install -m 0644 ${WORKDIR}/fcc-mfgbridge.service ${D}${systemd_unitdir}/system/
    install -m 0644 ${WORKDIR}/fcc-bt@.service ${D}${systemd_unitdir}/system/
    install -m 0644 ${WORKDIR}/fcc-bt@.timer ${D}${systemd_unitdir}/system/
    sed -i -e s/\@BAUDRATE\@/$default_baudrate/g ${D}${systemd_unitdir}/system/fcc-bt@.service
    # enable the services
    ln -sf ${systemd_unitdir}/system/fcc-mfgbridge.service \
            ${D}${sysconfdir}/systemd/system/multi-user.target.wants/fcc-mfgbridge.service
    ln -sf ${systemd_unitdir}/system/fcc-bt@.timer \
            ${D}${sysconfdir}/systemd/system/timers.target.wants/fcc-bt@$ttydev.timer

    install -d ${D}${sysconfdir}/systemd/network/
    install -m 0644 ${WORKDIR}/20-wired.network ${D}${sysconfdir}/systemd/network/
    install -d ${D}${sysconfdir}/bluetooth/
    install -m 0644 ${WORKDIR}/main.conf ${D}${sysconfdir}/bluetooth/
}
