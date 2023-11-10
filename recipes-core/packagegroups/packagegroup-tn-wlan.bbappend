# QCA
PACKAGES_remove_qca = "linux-firmware-qca"
RDEPENDS_${PN}_append_qca = " ${@bb.utils.contains('COMBINED_FEATURES', 'wifi', 'linux-firmware-qca-tn', '', d)}"

# Extra Kernel Modules
RDEPENDS_${PN}_append = " ${@bb.utils.contains('COMBINED_FEATURES', 'wifi', 'kernel-module-qcacld-tn', '', d)}"
RDEPENDS_${PN}_append = " ${@bb.utils.contains('MACHINE_FEATURES', 'nxpiw416-sdio', 'linux-firmware-nxpiw416-sdio', '', d)}"
RDEPENDS_${PN}_append = " ${@bb.utils.contains('MACHINE_FEATURES', 'nxpiw416-sdio', 'kernel-module-nxp-wlan', '', d)}"
RDEPENDS_${PN}_append = " ${@bb.utils.contains('MACHINE_FEATURES', 'nxpiw612-sdio', 'linux-firmware-nxpiw612-sdio', '', d)}"
RDEPENDS_${PN}_append = " ${@bb.utils.contains('MACHINE_FEATURES', 'nxpiw612-sdio', 'kernel-module-nxp-wlan', '', d)}"