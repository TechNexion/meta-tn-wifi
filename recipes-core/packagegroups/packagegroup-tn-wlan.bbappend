# QCA
PACKAGES:remove:qca = "linux-firmware-qca"
RDEPENDS:${PN}:append:qca = " linux-firmware-qca-tn"
# BRCM
PACKAGES:remove:brcm = "linux-firmware-brcm"
RDEPENDS:${PN}:append:brcm = " linux-firmware-brcm-tn"
# ATH10K
PACKAGES:remove:ath-pci = "linux-firmware-ath10k"
RDEPENDS:${PN}:append:ath-pci = " linux-firmware-ath10k-tn"

# Extra Kernel Modules
RDEPENDS:${PN}:append = " ${@bb.utils.contains('COMBINED_FEATURES', 'wifi', 'kernel-module-qcacld-tn', '', d)}"
