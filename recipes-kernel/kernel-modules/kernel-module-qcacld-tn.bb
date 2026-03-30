# Copyright 2022 TechNexion Ltd.
SUMMARY = "QCACLD driver for QCA9377-based BD-SDMAC module"
LICENSE = "ISC"
LIC_FILES_CHKSUM = "file://${S}/CORE/HDD/src/wlan_hdd_main.c;beginline=1;endline=21;md5=b7f10cf73d37777b9ab8bacb6b162452"

inherit module

SRCREV = "181b380126102b9d6aeb5fa31de6d8cb1735b8ab"

SRC_URI = "git://github.com/TechNexion/qcacld-2.0.git;protocol=https;branch=${SRCBRANCH} \
"
SRCBRANCH = "tn-CNSS.LEA.NRT_3.1"

EXTRA_OEMAKE:append = " CONFIG_CLD_HL_SDIO_CORE=y"
EXTRA_OEMAKE:append = " TARGET_BUILD_VARIANT=user"
EXTRA_OEMAKE:append = " CONFIG_P2P_INTERFACE=y"

COMPATIBLE_MACHINE = "(imx-nxp-bsp)"

addtask export_sources after do_patch before do_configure
do_export_sources[depends] += "virtual/kernel:do_shared_workdir"

do_export_sources() {
    # some kernel versions have issues with stdarg.h and compatibility with
    # the sysroot and libc-headers/uapi. If we include the file directly from
    # the kernel source (STAGING_KERNEL_DIR) we get conflicting types on many
    # structures, due to kernel .h files being found before libc .h files.
    # if we grab just this one file from the source, and put it into our
    # file structure, everything holds together
    install ${STAGING_KERNEL_DIR}/include/linux/stdarg.h  ${S}/CORE/VOSS/inc
}
