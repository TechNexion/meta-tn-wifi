FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

LIC_FILES_CHKSUM = "file://COPYING;md5=12f884d2ae1ff87c09e5b7ccc2c4ca7e \
                    file://COPYING.LIB;md5=fb504b67c50331fc78734fed90fb0e09 \
                    file://src/main.c;beginline=1;endline=24;md5=0ad83ca0dc37ab08af448777c581e7ac"

SRC_URI[md5sum] = "bc07c802e95d4ee29d99f4f82c5abcf6"
SRC_URI[sha256sum] = "2565a4d48354b576e6ad92e25b54ed66808296581c8abb80587051f9993d96d4"

# Add patches for QCA modules with Qca6174 and Qca9377-3 chips
SRC_URI = "${KERNELORG_MIRROR}/linux/bluetooth/bluez-5.65.tar.xz \
           file://init \
           file://run-ptest \
           ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', '', 'file://0001-Allow-using-obexd-without-systemd-in-the-user-sessio.patch', d)} \
           file://0001-tests-add-a-target-for-building-tests-without-runnin.patch \
           file://0001-test-gatt-Fix-hung-issue.patch \
           file://0001-bluetooth-Add-bluetooth-support-for-QCA6174-chip.patch \
           file://0002-hciattach-set-flag-to-enable-HCI-reset-on-init.patch \
           file://0003-hciattach-instead-of-strlcpy-with-strncpy-to-avoid-r.patch \
           file://0004-Add-support-for-Tufello-1.1-SOC.patch \
           file://0005-bluetooth-Add-support-for-multi-baud-rate.patch \
           file://0006-gobex-increase-the-obex-default-abort-timeout-value.patch \
           file://0007-MLK-23858-profiles-audio-increased-the-MTU-size-to-M.patch \
           file://0008-gobex-add-a-workaround-patch-for-canceling-obex-tran.patch \
           file://0001-hciattach_rome-do-not-override-module-MAC-address.patch \
           file://0002-hciattach_rome-set-IBS-to-disable-and-PCM-to-slave-b.patch \
           file://0003-hciattach_rome-load-3.2-version-of-firmware-by-defau.patch \
           file://0004-hciattach_rome-fix-baud-rate-synchronization-issue.patch \
           file://0001-hciattach_rome-use-the-same-firmware-path.patch \
"

S = "${WORKDIR}/bluez-5.65"

PACKAGECONFIG[manpages] = "--enable-manpages,--disable-manpages,python3-docutils-native"

