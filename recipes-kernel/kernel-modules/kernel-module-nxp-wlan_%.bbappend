FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRCBRANCH = "lf-6.6.23_2.0.0"
SRCREV = "88372772badbf30152b3ad12ae251dc567095cab"
SRC_URI += "file://0001-mxm_wifiex-disable-debugging-messages.patch"

S = "${WORKDIR}/git"

KERNEL_MODULE_AUTOLOAD:append = "moal"
KERNEL_MODULE_PROBECONF:append = "moal"
module_conf_moal = "options moal mod_para=nxp/wifi_mod_para.conf"
