# Deployment Guide

## Firmware Ready for Deployment

The firmware has been successfully compiled and is ready to flash to your ESP32-C6 device.

__Firmware Location:__

```
esphome/.esphome/build/esp32-garage-all-in-one/.pioenvs/esp32-garage-all-in-one/firmware.factory.bin
```

## Deployment Methods

### Method 1: ESPHome Upload (Recommended)

#### USB Upload (First Time / Initial Flash)

1. __Connect ESP32-C6__ to your computer via USB
2. __Put device in bootloader mode__:
   - Hold the BOOT button on the ESP32-C6
   - Press and release the RESET button
   - Release the BOOT button
3. __Run upload command__:

   ```bash
   cd esphome
   esphome upload all-in-one.yaml
   ```

   - Select option `[1]` for USB upload when prompted
   - Or specify port directly: `esphome upload all-in-one.yaml --device /dev/cu.usbmodem31201`

#### Over-The-Air (OTA) Upload (After Initial Flash)

Once the device is on your network, you can update wirelessly:

``` bash
 # Option 1: Activate the venv first            
cd /Volumes/jobd/code/GitHub/garage-car-positioning/esphome
source .venv/bin/activate                                                                                                                                                                         
esphome run all-in-one.yaml

# Option 2: Call it directly (no activation needed) quicker for a one-off flash
cd /Volumes/jobd/code/GitHub/garage-car-positioning/esphome
.venv/bin/esphome run all-in-one.yaml
```

- Select option `[2]` for OTA upload when prompted
- Device must be on the same WiFi network

### Method 2: Manual esptool.py Upload

If ESPHome upload fails, use esptool directly:

```bash
cd esphome/.esphome/build/esp32-garage-all-in-one/.pioenvs/esp32-garage-all-in-one

esptool.py --before default_reset --after hard_reset \
  --baud 115200 --port /dev/cu.usbmodem31201 --chip esp32c6 \
  write_flash -z --flash_size detect \
  0x0 bootloader.bin \
  0x8000 partitions.bin \
  0x9000 ota_data_initial.bin \
  0x10000 firmware.bin
```

__Important__: Put the ESP32-C6 in bootloader mode before running this command.

### Method 3: ESPHome Dashboard (Home Assistant)

1. Open ESPHome dashboard in Home Assistant
2. Find your device: `esp32-garage-all-in-one`
3. Click "INSTALL" or "UPDATE"
4. Select upload method (USB or OTA)
5. Follow the on-screen instructions

## Troubleshooting

### USB Port Busy

If you get "port is busy" error:

1. __Close other programs__ using the serial port:
   - Serial monitors
   - Other ESPHome instances
   - Arduino IDE
   - PlatformIO serial monitor

2. __Check what's using the port__:

   ```bash
   lsof /dev/cu.usbmodem31201
   ```

3. __Kill the process__ if needed:

   ```bash
   kill -9 <PID>
   ```

### Device Not Detected

1. __Check USB connection__ - try a different USB cable/port
2. __Install USB drivers__ if needed (CP2102, CH340, etc.)
3. __Put device in bootloader mode__ manually:
   - Hold BOOT button
   - Press and release RESET
   - Release BOOT button

### OTA Upload Fails

1. __Check WiFi connection__ - device must be on same network
2. __Verify device is online__:

   ```bash
   ping esp32-garage-all-in-one.local
   ```

3. __Use static IP__ if mDNS doesn't work (see configuration)

## Post-Deployment

After successful deployment:

1. __Monitor logs__:

   ```bash
   esphome logs all-in-one.yaml
   ```

2. __Check device status__ in Home Assistant:
   - Device should appear in ESPHome integration
   - All sensors and entities should be available

3. __Calibrate sensors__ (see `docs/calibration.md`):
   - Calibrate car positioning zones
   - Calibrate garage door encoder counts

4. __Test functionality__:
   - Test LD2450 sensors
   - Test garage door control
   - Test LED strip guidance

## Current Status

- ✅ Firmware compiled successfully
- ✅ Ready for deployment
- ⚠️ USB port may need to be freed before upload
- ✅ OTA available if device is already on network

## Next Steps

1. Free USB port if busy (close other serial programs)
2. Put ESP32-C6 in bootloader mode
3. Run upload command
4. Monitor initial boot logs
5. Calibrate sensors
