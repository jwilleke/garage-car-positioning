# Jim Notes

Connect the device via USB

```bash
# [current working directory /Volumes/hd2A/workspaces/github/garage-car-positioning] (Start serial log output from the ESP32-C6.
Shell esphome logs simple-wifi.yaml 

# Check which port your device is on:
ls /dev/cu.usb* | grep -i usb
   ls /dev/cu.usb* | grep -i usb

# Build and upload Code 
esphome upload simple-wifi.yaml --device /dev/cu.usbmodem31201

# Monmitor device logs
esphome logs simple-wifi.yaml   

esphome upload simple-wifi.yaml --device /dev/cu.usbmodem31201 && esphome logs simple-wifi.yaml --device /dev/cu.usbmodem31201



esptool.py --port /dev/cu.usbmodem31201 chip_id 2>&1 | head -100
```

## Network Connectiom

Not picking up IP address

Proposed IP Address 192.168.20.218

```bash
# Device 1

esptool.py --port /dev/cu.usbmodem31201 chip_id 2>&1 | head -100
esptool.py v4.8.1
Serial port /dev/cu.usbmodem31201
Connecting....
Detecting chip type... ESP32-C6
Chip is ESP32-C6 (QFN40) (revision v0.2)
Features: WiFi 6, BT 5, IEEE802.15.4
Crystal is 40MHz
MAC: 98:a3:16:ff:fe:b1:d0:88
BASE MAC: 98:a3:16:b1:d0:88
MAC_EXT: ff:fe
Uploading stub...
Running stub...
Stub running...
Warning: ESP32-C6 has no Chip ID. Reading MAC instead.
MAC: 98:a3:16:ff:fe:b1:d0:88
BASE MAC: 98:a3:16:b1:d0:88
MAC_EXT: ff:fe
Hard resetting via RTS pin...
 
# Device 2
esphome git:(master) ✗ esptool.py --port /dev/cu.usbmodem31201 chip_id 2>&1 | head -100
esptool.py v4.8.1
Serial port /dev/cu.usbmodem31201
Connecting...
Detecting chip type... ESP32-C6
Chip is ESP32-C6 (QFN40) (revision v0.2)
Features: WiFi 6, BT 5, IEEE802.15.4
Crystal is 40MHz
MAC: 98:a3:16:ff:fe:b1:c3:fc
BASE MAC: 98:a3:16:b1:c3:fc
MAC_EXT: ff:fe
Uploading stub...
Running stub...
Stub running...
Warning: ESP32-C6 has no Chip ID. Reading MAC instead.
MAC: 98:a3:16:ff:fe:b1:c3:fc
BASE MAC: 98:a3:16:b1:c3:fc
MAC_EXT: ff:fe
Hard resetting via RTS pin...

```
