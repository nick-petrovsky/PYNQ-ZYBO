SRC_URI:append = " file://platform-top.h"
SRC_URI += " file://ethernet.cfg"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
