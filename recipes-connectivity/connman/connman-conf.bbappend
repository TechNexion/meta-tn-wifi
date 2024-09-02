FILESEXTRAPATHS:prepend := "${THISDIR}/connman-conf:"

SRC_URI += " \
   file://settings \
"

FILES:${PN} += "${localstatedir}/*"

do_install:append() {
    install -d ${D}${localstatedir}/lib/connman
    install -m 0644 ${WORKDIR}/settings ${D}${localstatedir}/lib/connman
}
