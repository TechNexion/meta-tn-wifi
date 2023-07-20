FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
            file://0001-FwImage-wifi_mod_para.conf-disable-power-saving-for-.patch;patchdir=${WORKDIR}/imx-firmware \
            file://0002-FwImage-wifi_mod_para.conf-disable-WIFIDIRECT-interf.patch;patchdir=${WORKDIR}/imx-firmware \
            ${@bb.utils.contains('DISTRO_FEATURES', 'fcc-nxp', 'file://0003-FwImage-wifi_mod_para.conf-enable-mfg-mode-for-IW416.patch;patchdir=${WORKDIR}/imx-firmware', '',d)} \
"
