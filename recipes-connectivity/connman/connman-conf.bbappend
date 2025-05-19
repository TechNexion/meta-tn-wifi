FILESEXTRAPATHS:prepend := "${THISDIR}/connman-conf:"

SRC_URI += " \
   file://settings \
   file://main.conf \
"

FILES:${PN} += "${localstatedir}/* ${sysconfdir}/*"

do_install:append() {
    install -d ${D}${localstatedir}/lib/connman
    install -m 0644 ${UNPACKDIR}/settings ${D}${localstatedir}/lib/connman

    install -d ${D}${sysconfdir}/connman
    install -m 0644 ${S}/main.conf ${D}${sysconfdir}/connman
}
