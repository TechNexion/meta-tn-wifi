# Copyright (C) 2020 TechNexion Ltd.

SUMMARY = "TechNexion QCA Qcmbr"
DESCRIPTION = "Qcmbr of QDART client for TechNexion QCA WIFI modules"
SECTION = "app"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://notice.txt;md5=912c8fae0926ab3ef757331fc96b5d70"

SRCBRANCH = "master"
TN_QDART_WIFI_TOOL_SRC = "git://gitlab.com/technexion-imx/qcmbr.git;protocol=https;user=oauth2:${PA_TOKEN}"
SRC_URI = "${TN_QDART_WIFI_TOOL_SRC};branch=${SRCBRANCH} \
           file://fcc-qcmbr.service \
           file://20-wired.network \
           file://wlan.conf \
"
SRCREV = "570a678057d101b8fca52a6388949be21ccf42b2"

inherit features_check
REQUIRED_DISTRO_FEATURES = "systemd fcc-qca"

S = "${WORKDIR}/git"

FILES:${PN} += " ${sbindir}/Qcmbr \
                 ${systemd_unitdir}/system/fcc-qcmbr.service \
                 ${sysconfdir}/systemd/network/20-wired.network \
                 ${sysconfdir}/modprobe.d/wlan.conf \
"

do_check() {
    if [ -z "${PA_TOKEN}" ]; then
        bberror "Download QCA Qcmbr tool requires personal access token (Please contact TechNexion: sales@technexion.com)"
    fi
}

addtask check before do_fetch

do_install() {
    install -d "${D}${sbindir}"
    install -m 0755 ${S}/Qcmbr "${D}${sbindir}"

    install -d ${D}${systemd_unitdir}/system/
    install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants/
    install -m 0644 ${WORKDIR}/fcc-qcmbr.service ${D}${systemd_unitdir}/system/
    # enable the service
    ln -sf ${systemd_unitdir}/system/fcc-qcmbr.service \
            ${D}${sysconfdir}/systemd/system/multi-user.target.wants/fcc-qcmbr.service

    install -d ${D}${sysconfdir}/systemd/network/
    install -m 0644 ${WORKDIR}/20-wired.network ${D}${sysconfdir}/systemd/network/
    install -d ${D}${sysconfdir}/modprobe.d/
    install -m 0644 ${WORKDIR}/wlan.conf ${D}${sysconfdir}/modprobe.d/
}
