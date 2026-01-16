# Deployment Guide

## Firmware Ready for Deployment

The firmware has been successfully compiled and is ready to flash to your ESP32-C6 device.

**Firmware Location:**

```
esphome/.esphome/build/esp32-garage-all-in-one/.pioenvs/esp32-garage-all-in-one/firmware.factory.bin
```

## Deployment Methods

### Method 1: ESPHome Upload (Recommended)

#### USB Upload (First Time / Initial Flash)

1. **Connect ESP32-C6** to your computer via USB
2. **Put device in bootloader mode**:
   - Hold the BOOT button on the ESP32-C6
   - Press and release the RESET button
   - Release the BOOT button
3. **Run upload command**:

   ```bash
   cd esphome
   esphome upload all-in-one.yaml
   ```

   - Select option `[1]` for USB upload when prompted
   - Or specify port directly: `esphome upload all-in-one.yaml --device /dev/cu.usbmodem31201`

#### Over-The-Air (OTA) Upload (After Initial Flash)

Once the device is on your network, you can update wirelessly:

```bash
cd esphome
esphome upload all-in-one.yaml
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

**Important**: Put the ESP32-C6 in bootloader mode before running this command.

### Method 3: ESPHome Dashboard (Home Assistant)

1. Open ESPHome dashboard in Home Assistant
2. Find your device: `esp32-garage-all-in-one`
3. Click "INSTALL" or "UPDATE"
4. Select upload method (USB or OTA)
5. Follow the on-screen instructions

## Troubleshooting

### USB Port Busy

If you get "port is busy" error:

1. **Close other programs** using the serial port:
   - Serial monitors
   - Other ESPHome instances
   - Arduino IDE
   - PlatformIO serial monitor

2. **Check what's using the port**:

   ```bash
   lsof /dev/cu.usbmodem31201
   ```

3. **Kill the process** if needed:

   ```bash
   kill -9 <PID>
   ```

### Device Not Detected

1. **Check USB connection** - try a different USB cable/port
2. **Install USB drivers** if needed (CP2102, CH340, etc.)
3. **Put device in bootloader mode** manually:
   - Hold BOOT button
   - Press and release RESET
   - Release BOOT button

### OTA Upload Fails

1. **Check WiFi connection** - device must be on same network
2. **Verify device is online**:

   ```bash
   ping esp32-garage-all-in-one.local
   ```

3. **Use static IP** if mDNS doesn't work (see configuration)

## Post-Deployment

After successful deployment:

1. **Monitor logs**:

   ```bash
   esphome logs all-in-one.yaml
   ```

2. **Check device status** in Home Assistant:
   - Device should appear in ESPHome integration
   - All sensors and entities should be available

3. **Calibrate sensors** (see `docs/calibration.md`):
   - Calibrate car positioning zones
   - Calibrate garage door encoder counts

4. **Test functionality**:
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
