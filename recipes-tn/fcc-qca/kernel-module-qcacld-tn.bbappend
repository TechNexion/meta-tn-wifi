EXTRA_OEMAKE:append = " ${@bb.utils.contains('DISTRO_FEATURES', 'fcc-qca', 'CONFIG_LINUX_QCMBR=y', '', d)}"
