import gpio
import pixel_strip show PixelStrip
import mqtt
import monitor
import encoding.json

CLIENT-ID ::= "toit-subscribe"

HOST ::= "broker.hivemq.com"
TOPIC ::= "hsm_v2/topic"
OUT_TOPIC ::= "hsm_in/topic"

latch ::= monitor.Latch //  Monitor for sync

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

color red/int green/int blue/int :
  task::
    set_color red green blue

publish client/mqtt.Client message :
  task::
    client.publish OUT_TOPIC message

main:

  set_color 255 255 0 //  YELLOW -> indicate app start

//  Create MQTT-client  

  client := mqtt.Client --host=HOST
  
//  Connect to broker

  client.start --client-id=CLIENT-ID
      --on-error=:: print "Client error: $it"

  print "Connected to MQTT broker $HOST"

  set_color 0 255 0 //  GREEN -> indicate app connected

//  Subscribe to topic

  r/int := 0
  g/int := 0
  b/int := 0
  command/string := ""
  decoded/string := ""

  client.subscribe TOPIC:: | topic/string payload/ByteArray |
    
    decoded = payload.to_string
    
    print "Received message on '$topic': $decoded"

    map := json.parse decoded

    hasColor := map.contains "color"
    hasCmd := map.contains "cmd"

    print ("hasColor->$hasColor hasCmd->$hasCmd");

    if hasColor :
      color := map["color"]
      r = color["r"]
      g = color["g"]
      b = color["b"]
      
    if hasCmd :
      command = map["cmd"]

    if (hasCmd and command == "stop") :
      latch.set true
      print ("Stopping app...")
    else :
      publish client decoded
      blink 5 r g b
      print ("Blink and publish RGB[$r $g $b]...")

// Wait ending signal
  latch.get
  publish client decoded
  sleep --ms=500
// Disconnect
  client.close
  print "Disconnected from MQTT broker $HOST"
  blink 5 0 204 0


