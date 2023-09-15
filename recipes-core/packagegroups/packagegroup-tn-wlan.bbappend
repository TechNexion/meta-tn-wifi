# QCA
PACKAGES_remove_qca = "linux-firmware-qca"
RDEPENDS_${PN}_append_qca = " linux-firmware-qca-tn"

# Extra Kernel Modules
RDEPENDS_${PN}_append = " ${@bb.utils.contains('COMBINED_FEATURES', 'wifi', 'kernel-module-qcacld-tn', '', d)}"
