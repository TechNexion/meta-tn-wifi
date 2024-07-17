FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

IMX_FIRMWARE_SRC ?= "git://github.com/NXP/imx-firmware.git;protocol=https"
SRCBRANCH_imx-firmware = "lf-6.6.23_2.0.0"
SRCREV_imx-firmware = "7e038c6afba3118bcee91608764ac3c633bce0c4"

SRC_URI += " \
            file://0001-FwImage-wifi_mod_para.conf-disable-power-saving-for-.patch;patchdir=${WORKDIR}/imx-firmware \
            file://0002-FwImage-wifi_mod_para.conf-disable-WIFIDIRECT-interf.patch;patchdir=${WORKDIR}/imx-firmware \
            ${@bb.utils.contains('DISTRO_FEATURES', 'fcc-nxp', 'file://0003-FwImage-wifi_mod_para.conf-enable-mfg-mode-for-IW416.patch;patchdir=${WORKDIR}/imx-firmware', '',d)} \
"
