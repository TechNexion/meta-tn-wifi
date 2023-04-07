FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# Add patches for QCA modules with Qca6174 and Qca9377-3 chips
SRC_URI += " \
            file://0001-hciattach_rome-do-not-override-module-MAC-address.patch \
            file://0002-hciattach_rome-set-IBS-to-disable-and-PCM-to-slave-b.patch \
            file://0003-hciattach_rome-load-3.2-version-of-firmware-by-defau.patch \
            file://0004-hciattach_rome-fix-baud-rate-synchronization-issue.patch \
            file://0001-hciattach_rome-use-the-same-firmware-path.patch \
            file://serial-btattach@.service \
            file://serial-btattach@.timer \
            file://btattach.sh \
"

# As this package is tied to systemd, only build it when we're also building systemd.
inherit features_check
REQUIRED_DISTRO_FEATURES = "systemd"

do_install:append() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'fcc', 'false', 'true', d)}; then
        if [ ! -z "${SERIAL_BLUETOOTH}" ] ; then
                default_baudrate=`echo "${SERIAL_BLUETOOTH}" | sed 's/\;.*//'`
                install -d ${D}/opt/btattach/
                install -d ${D}${systemd_unitdir}/system/
                install -d ${D}${sysconfdir}/systemd/system/timers.target.wants/
                install -m 0755 ${WORKDIR}/btattach.sh ${D}/opt/btattach/
                install -m 0644 ${WORKDIR}/serial-btattach@.service ${D}${systemd_unitdir}/system/
                install -m 0644 ${WORKDIR}/serial-btattach@.timer ${D}${systemd_unitdir}/system/
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

FILES:${PN} += "/opt"
