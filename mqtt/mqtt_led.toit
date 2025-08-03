import mqtt
import monitor
import encoding.json
import .pixel_strip_utils

CLIENT-ID ::= "toit-subscribe"

HOST  ::= "broker.hivemq.com" // "test.mosquitto.org" //"broker.hivemq.com"
TOPIC ::= "hsm_v2/topic"
OUT_TOPIC ::= "hsm_in/topic"

client := ?

latch ::= monitor.Latch //  Monitor for sync

publish client/mqtt.Client message :
  task::
    try :
      e := catch --trace=false :    
        client.publish OUT_TOPIC message
      if e :
        exceptionWasDetected "Publish Exception" e.stringify
    finally :


exceptionWasDetected place/string exception/string -> none :
  print "$place: $exception"

connect host/string client_id/string -> any : //mqtt.Client :

  error/bool := false
  client_ := null

  set_color 255 255 0 //  YELLOW -> indicate app start

  try :

    e := catch --trace=false :
//  Create MQTT-client 
      client_ = mqtt.Client --host=host --routes={
        TOPIC: :: | topic payload |
          print "Received: $topic: $payload.to-string-non-throwing"
          processing topic payload
      }

//  Connect to broker
      client_.start --client-id=client_id
        --on-error=:: print "Client error: $it"
    if e :
      error = true
      exceptionWasDetected "Connect Exception" e.stringify

  finally :
    if error :
      set_color 255 0 0   //  RED -> indicate app error
      print "Connected to MQTT broker $host failed"
    else :
      set_color 0 255 0   //  GREEN -> indicate connection ok
      print "Connected to MQTT broker $host"
    return client_  

main :

  client = connect HOST CLIENT-ID
  if client == null :
    print "======= App exit because fatal error ======="
    exit 0

// Wait ending signal
  latch.get

  sleep --ms=500
// Disconnect
  client.close
  print "Disconnected from MQTT broker $HOST"
  blink 5 0 204 0

processing topic/string payload/ByteArray -> none :

  r/int := 0
  g/int := 0
  b/int := 0
  command/string := ""
  decoded/string := ""

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
    blink_and_set_color 5 r g b
    print ("Blink and publish RGB[$r $g $b]...")
