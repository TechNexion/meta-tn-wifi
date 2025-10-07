FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

PV = "5.75"
SRC_URI[sha256sum] = "988cb3c4551f6e3a667708a578f5ca9f93fc896508f98f08709be4f8ab033c2f"
SRC_URI:remove = "file://0001-gdbus-define-MAX_INPUT-for-musl.patch \
           file://0001-shared-ad-fix-std-c23-build-failure.patch \
           file://0002-shared-shell-fix-std-c23-build-failure.patch \
           file://0003-shared-gatt-helpers-fix-std-c23-build-failure.patch \
           "
SRC_URI += " file://0001-configure.ac-Fix-disable-cups.patch "
PACKAGECONFIG[asha-profiles] = ""

# Add patches for QCA modules with Qca6174 and Qca9377-3 chips
QCA_SRC_URI = " \
            file://0001-bluetooth-Add-bluetooth-support-for-QCA6174-chip.patch \
            file://0002-hciattach-set-flag-to-enable-HCI-reset-on-init.patch \
            file://0003-hciattach-instead-of-strlcpy-with-strncpy-to-avoid-r.patch \
            file://0004-Add-support-for-Tufello-1.1-SOC.patch \
            file://0005-bluetooth-Add-support-for-multi-baud-rate.patch \
            file://0001-hciattach_rome-do-not-override-module-MAC-address.patch \
            file://0002-hciattach_rome-set-IBS-to-disable-and-PCM-to-slave-b.patch \
            file://0003-hciattach_rome-load-3.2-version-of-firmware-by-defau.patch \
            file://0004-hciattach_rome-fix-baud-rate-synchronization-issue.patch \
            file://0001-hciattach_rome-use-the-same-firmware-path.patch \
            file://0001-hciattach_rome-fix-implicit-declaration-error-on-sty.patch \
            file://serial-btattach@.service \
            file://serial-btattach@.timer \
            file://btattach.sh \
"

QCA_SRC_URI:mx9-nxp-bsp = ""

SRC_URI:append = "${QCA_SRC_URI}"

# As this package is tied to systemd, only build it when we're also building systemd.
inherit features_check
REQUIRED_DISTRO_FEATURES = "systemd"

install_btservice() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'fcc-qca', 'false', bb.utils.contains('DISTRO_FEATURES', 'fcc-nxp', 'false', 'true', d), d)}; then
        if [ ! -z "${SERIAL_BLUETOOTH}" ] ; then
                default_baudrate=`echo "${SERIAL_BLUETOOTH}" | sed 's/\;.*//'`
                install -d ${D}/opt/btattach/
                install -d ${D}${systemd_unitdir}/system/
                install -d ${D}${sysconfdir}/systemd/system/timers.target.wants/
                install -m 0755 ${UNPACKDIR}/btattach.sh ${D}/opt/btattach/
                install -m 0644 ${UNPACKDIR}/serial-btattach@.service ${D}${systemd_unitdir}/system/
                install -m 0644 ${UNPACKDIR}/serial-btattach@.timer ${D}${systemd_unitdir}/system/
                sed -i -e s/\@BAUDRATE\@/$default_baudrate/g ${D}/opt/btattach/btattach.sh

                tmp="${SERIAL_BLUETOOTH}"
                for entry in $tmp ; do
                        baudrate=`echo $entry | sed 's/\;.*//'`
                        ttydev=`echo $entry | sed -e 's/^[0-9]*\;//' -e 's/\;.*//'`
                        # for the non-default baudrate
                        if [ "$baudrate" != "$default_baudrate" ] ; then
                                sed -i -e s/\@BAUDRATE\@/$baudrate/g ${D}/opt/btattach/btattach.sh
                        fi
                        # enable the timer service
                        ln -sf ${systemd_unitdir}/system/serial-btattach@.timer \
                                ${D}${sysconfdir}/systemd/system/timers.target.wants/serial-btattach@$ttydev.timer
                done
        fi
    fi
}

do_install:append() {
        install_btservice
}

do_install:remove:mx9-nxp-bsp() {
        install_btservice
}

FILES:${PN} += "/opt"
