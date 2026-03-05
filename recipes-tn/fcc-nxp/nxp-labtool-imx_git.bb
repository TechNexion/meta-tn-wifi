# Copyright (C) 2026 TechNexion Ltd.

SUMMARY = "TechNexion NXP labtool"
DESCRIPTION = "Wifi FCC native app for TechNexion NXP WIFI modules"
LICENSE = "CLOSED"
SECTION = "app"
LIC_FILES_CHKSUM = ""

SRCBRANCH = "labtool_native_2.0.0.41.0-18.80.3.p27.6"
NXP_LABTOOL_SRC = "git://gitlab.com/technexion-imx/mfgbridge.git;protocol=https;user=oauth2:${PA_TOKEN}"

SRC_URI = "${NXP_LABTOOL_SRC};protocol=ssh;branch=${SRCBRANCH} "

PV = "1.0+git"
SRCREV = "c1944d13539526207a6778f0d50abe9d3d37a039"

inherit features_check
REQUIRED_DISTRO_FEATURES = "systemd fcc-nxp-labtool-imx "

DEPENDS += "virtual/kernel bluez5 linux-libc-headers kernel-module-nxp-wlan"
RDEPENDS:${PN} = "bluez5 kernel-module-nxp-wlan"

S = "${WORKDIR}/git"

FILES:${PN} += " ${sysconfdir}/nxp-labconf/* "

INCLUDE_PATH = " -I${STAGING_INCDIR}"
BUILD_FLAG = ""

EXTRA_OEMAKE = " \
    CC='${CC}' \
    CXX='${CXX}' \
    CFLAGS='${CFLAGS} ${INCLUDE_PATH} ${BUILD_FLAG}' \
    CXXFLAGS='${CXXFLAGS} ${INCLUDE_PATH} ${BUILD_FLAG}' \
    LDFLAGS='${LDFLAGS} -lbluetooth' \
    KERNELDIR='${STAGING_KERNEL_DIR}' \
    DRVR_STACK='-lbluetooth' \
"

do_configure () {
	:
}

do_compile () {
	oe_runmake
}

LAB_CONF_DIR = "${sysconfdir}/nxp-labconf"
NXP_DUT_API_DIR = "${S}/DutApiWiFiBt"
do_install () {
	install -d ${D}${bindir}
	if [ -f "${S}/labtool" ]; then
		install -m 0755 ${S}/labtool ${D}${bindir}
	else
		bbfatal "Binary NXP labtool not found in ${S}. Check build log."
	fi

	install -d ${D}${LAB_CONF_DIR}
	install -m 0644 ${NXP_DUT_API_DIR}/Reference_SetUpFile/IW612/SetUp.ini ${D}${LAB_CONF_DIR}
	install -m 0644 ${NXP_DUT_API_DIR}/*.bin           ${D}${LAB_CONF_DIR}
	install -m 0644 ${NXP_DUT_API_DIR}/*.conf          ${D}${LAB_CONF_DIR}
	install -m 0644 ${NXP_DUT_API_DIR}/TF_Config_*.txt ${D}${LAB_CONF_DIR}
}

do_install:append() {
	if [ -z "${SERIAL_BLUETOOTH}" ] ; then
		bbfatal "Not define SERIAL_BLUETOOTH"
		return
	fi

	baudrate=`echo "${SERIAL_BLUETOOTH}" | cut -d';' -f1`
	devicename=`echo "${SERIAL_BLUETOOTH}" | cut -d';' -f2`
	sed -i "s#^RAWUR_PORT = .*#RAWUR_PORT = /dev/${devicename}#" ${D}${LAB_CONF_DIR}/SetUp.ini
	sed -i "s#^RAWUR_BAUDRATE = .*#RAWUR_BAUDRATE = ${baudrate}#" ${D}${LAB_CONF_DIR}/SetUp.ini
}
