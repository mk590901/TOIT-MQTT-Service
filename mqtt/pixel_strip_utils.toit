import gpio
import pixel_strip show PixelStrip

pin := gpio.Pin 48
strip := PixelStrip.uart 1 --pin=pin

set_and_reset_color number/int red/int green/int blue/int :
  r := ByteArray 1; g := ByteArray 1; b := ByteArray 1
  number.repeat :
    r[0] = red; g[0] = green; b[0] = blue
    strip.output r g b
    sleep --ms=100
    r[0] = 0; g[0] = 0; b[0] = 0
    strip.output r g b
    sleep --ms=100

set_color red/int green/int blue/int :
  r := ByteArray 1; g := ByteArray 1; b := ByteArray 1
  r[0] = red; g[0] = green; b[0] = blue
  strip.output r g b
  sleep --ms=100

blink number/int red/int green/int blue/int :
  task::
    set_and_reset_color number red green blue

blink_and_set_color number/int red/int green/int blue/int :
  task::
    set_and_reset_color number red green blue
    set_color red green blue

color red/int green/int blue/int :
  task::
    set_color red green blue
