FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-mxm_wifiex-disable-debugging-messages.patch;patchdir=../.."

KERNEL_MODULE_AUTOLOAD:append = "moal"
KERNEL_MODULE_PROBECONF:append = "moal"
module_conf_moal = "options moal mod_para=nxp/wifi_mod_para.conf"
