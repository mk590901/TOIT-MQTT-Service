# ESP32 LED RGB MQTT Service

Below is a small application in the Toit (https://toit.io/) language, allowing you to control the RGB LED on the __ESP32-S3-WROOM__ board via the __MQTT broker__ using a third-party application.

## Background

Toit has two built-in modules that provide control of the PGB LED and data exchange via the MQTT layer:
* The __pixel-strip__ package allows you to control the LED.
* The __mqtt__ package provides __MQTT__ support, simplifies connecting to brokers, publishing and subscribing to topics. The module is optimized for working with limited __ESP32__ resources.

## Brief description of the application

1) When the application starts, an mqtt client is created, a connection to the broker is started, and a subscription to the topic is performed. This step is accompanied by a small visual effect: upon successful connection and subscription, the LED turns green.
   
2) Control commands are transmitted by subscription in the form of json strings. There are only two of them:
   * color change: _{"color":{"r":255,"g":152,"b":0}}_
   * application end: _{"cmd":"stop"}_

3) Upon receiving the commands are executed. The color change is accompanied by a flashing of the LED of the received palette. Exiting the application is accompanied by an exit from  the message receiving cycle and a five-fold flashing. Any command is accompanied by a kind of confirmation or acknowledge: sending the received command to the sender.

## Application management

> Installing packages:

```
micrcx@micrcx-desktop:~/toit/mqtt$ jag pkg install github.com/toitware/mqtt@v2
Info: Package 'github.com/toitware/mqtt@2.13.1' installed with name 'mqtt'
```

```
micrcx@micrcx-desktop:~/toit/mqtt$ jag pkg install github.com/toitware/toit-pixel-strip@v0.3
Info: Package 'github.com/toitware/toit-pixel-strip@0.3.0' installed with name 'pixel_strip'
```

> Loading the application:

```
micrcx@micrcx-desktop:~/toit/mqtt$ jag run mqtt_rgb_led.toit
Running 'mqtt_rgb_led.toit' on 'polished-bill' ...
Success: Sent 99KB code to 'polished-bill' in 2.79s
```

> Monitoring:

```
micrcx@micrcx-desktop:~/toit/mqtt$ jag monitor
Starting serial monitor of port '/dev/ttyACM0' ...
ESP-ROM:esp32s3-20210327
Build:Mar 27 2021
rst:0x1 (POWERON),boot:0x8 (SPI_FAST_FLASH_BOOT)
SPIWP:0xee
mode:DIO, clock div:1
load:0x3fce2810,len:0xdc
load:0x403c8700,len:0x4
load:0x403c8704,len:0xa08
load:0x403cb700,len:0x257c
entry 0x403c8854
E (325) quad_psram: PSRAM ID read error: 0x00ffffff, PSRAM chip not found or not supported, or wrong PSRAM line mode
E (325) esp_psram: PSRAM enabled but initialization failed. Bailing out.
[toit] INFO: starting <v2.0.0-alpha.184>
[toit] DEBUG: clearing RTC memory: invalid checksum
[toit] INFO: running on ESP32S3 - revision 0.2
[wifi] DEBUG: connecting
E (3791) wifi:Association refused too many times, max allowed 1
[wifi] WARN: connect failed {reason: unknown reason (208)}
[wifi] DEBUG: closing
[jaguar] WARN: running Jaguar failed due to 'CONNECT_FAILED: unknown reason (208)' (1/3)
[wifi] DEBUG: connecting
E (6631) wifi:Association refused too many times, max allowed 1
[wifi] WARN: connect failed {reason: unknown reason (208)}
[wifi] DEBUG: closing
[jaguar] WARN: running Jaguar failed due to 'CONNECT_FAILED: unknown reason (208)' (2/3)
[wifi] DEBUG: connecting
[wifi] DEBUG: connected
[wifi] INFO: network address dynamically assigned through dhcp {ip: 192.168.1.228}
[wifi] INFO: dns server address dynamically assigned through dhcp {ip: [192.168.1.1]}
[jaguar.http] INFO: running Jaguar device 'polished-bill' (id: 'aab31f83-5d56-484b-b125-2a1f9c0035d2') on 'http://192.168.1.228:9000'
[jaguar] INFO: program c5daa302-44e4-ee62-8364-5717f5512150 started
DEBUG: connected to broker
DEBUG: connection established
Connected to MQTT broker broker.hivemq.com
Received message on 'hsm_v2/topic': {"color":{"r":244,"g":67,"b":54}}
hasColor->true hasCmd->false
Blink and publish RGB[244 67 54]...
Received message on 'hsm_v2/topic': {"color":{"r":156,"g":39,"b":176}}
hasColor->true hasCmd->false
Blink and publish RGB[156 39 176]...
Received message on 'hsm_v2/topic': {"color":{"r":255,"g":152,"b":0}}
hasColor->true hasCmd->false
Blink and publish RGB[255 152 0]...
Received message on 'hsm_v2/topic': {"color":{"r":76,"g":175,"b":80}}
hasColor->true hasCmd->false
Blink and publish RGB[76 175 80]...
Received message on 'hsm_v2/topic': {"color":{"r":33,"g":150,"b":243}}
hasColor->true hasCmd->false
Blink and publish RGB[33 150 243]...
Received message on 'hsm_v2/topic': {"color":{"r":0,"g":188,"b":212}}
hasColor->true hasCmd->false
Blink and publish RGB[0 188 212]...
Received message on 'hsm_v2/topic': {"color":{"r":233,"g":30,"b":99}}
hasColor->true hasCmd->false
Blink and publish RGB[233 30 99]...
Received message on 'hsm_v2/topic': {"color":{"r":255,"g":235,"b":59}}
hasColor->true hasCmd->false
Blink and publish RGB[255 235 59]...
Received message on 'hsm_v2/topic': {"cmd":"stop"}
hasColor->false hasCmd->true
Stopping app...
Disconnected from MQTT broker broker.hivemq.com
DEBUG: closing connection {reason: null}
[jaguar] INFO: program c5daa302-44e4-ee62-8364-5717f5512150 stopped
```

## Movies

Below are two movies:

1) Flutter application via that changes colors on the board. Everything is very simple there: you need to press the __Start__ button and after a successful connection to the broker (two green icons - a sign of a successful connection and subscription) you can select a color for the RGB LED. With a slight delay, the color of the ring at the bottom of the screen changes. The reason for the delay: the reverse passage of the command from the ESP32-S3 to the application. You can also interrupt the application on the ESP32-S3 by pressing the Stop ESP32-S3 button. If you want to continue your exercises, then load the application onto the chip using the __jag__ command _jag run mqtt_rgb_led.toit_.
   
2) Live lideo of the  reflection of interaction application 1) with the __ESP32-S3-WROOM__ board.
