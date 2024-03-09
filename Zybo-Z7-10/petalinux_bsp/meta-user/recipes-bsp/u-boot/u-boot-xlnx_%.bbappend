SRC_URI:append = " file://platform-top.h"
SRC_URI += " file://0001-alow-to-read-mac-address-from-SPI-flash-OTP.patch"
SRC_URI += " file://ethernet_spi.cfg"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
