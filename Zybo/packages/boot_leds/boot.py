#!/bin/env python3.8

from time import sleep
from pynq.overlays.base import BaseOverlay

base = BaseOverlay("base.bit")

leds = [base.leds[i] for i in range(4)]

# Toggle board LEDs leaving small LEDs lit
for i in range(8):
    [l.off() for l in leds]
    sleep(.2)
    [l.on() for l in leds]
    sleep(.2)

