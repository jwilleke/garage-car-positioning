# Jim Notes

Connect the device via USB

```bash
# [current working directory /Volumes/hd2A/workspaces/github/garage-car-positioning] (Start serial log output from the ESP32-C6.
Shell esphome logs simple-wifi.yaml 


esptool.py --port /dev/cu.usbmodem31201 chip_id 2>&1 | head -50
```

## Network Connectiom

Not picking up IP address

Proposed IP Address 192.168.20.218
