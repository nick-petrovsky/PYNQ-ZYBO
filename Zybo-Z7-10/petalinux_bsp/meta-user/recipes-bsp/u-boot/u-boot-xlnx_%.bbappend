SRC_URI:append = " file://platform-top.h"
SRC_URI += " file://0002-allow-to-read-mac-address-from-SPI-flash.patch"
SRC_URI += " file://ethernet_spi.cfg"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
