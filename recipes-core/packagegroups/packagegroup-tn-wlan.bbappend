# QCA
PACKAGES:remove:qca = "linux-firmware-qca"
RDEPENDS:${PN}:append:qca = " ${@bb.utils.contains('COMBINED_FEATURES', 'wifi', 'linux-firmware-qca-tn', '', d)}"

# Extra Kernel Modules
RDEPENDS:${PN}:append = " ${@bb.utils.contains('COMBINED_FEATURES', 'wifi', 'kernel-module-qcacld-tn', '', d)}"
RDEPENDS:${PN}:append = " ${@bb.utils.contains('MACHINE_FEATURES', 'nxpiw416-sdio', 'linux-firmware-nxpiw416-sdio', '', d)}"
RDEPENDS:${PN}:append = " ${@bb.utils.contains('MACHINE_FEATURES', 'nxpiw416-sdio', 'kernel-module-nxp-wlan', '', d)}"
RDEPENDS:${PN}:append = " ${@bb.utils.contains('MACHINE_FEATURES', 'nxpiw612-sdio', 'linux-firmware-nxpiw612-sdio', '', d)}"
RDEPENDS:${PN}:append = " ${@bb.utils.contains('MACHINE_FEATURES', 'nxpiw612-sdio', 'kernel-module-nxp-wlan', '', d)}"