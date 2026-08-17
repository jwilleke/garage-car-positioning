# Emergency Diagnostics: No Response from Device

## Symptoms

- ❌ No WiFi connection
- ❌ No AP visible ("garage-aio")
- ❌ No USB logs
- ❌ Device appears dead/unresponsive

## Critical Checks

### 1. Hardware Verification

__Power:__

- ✅ Is USB cable connected securely?
- ✅ Try different USB cable
- ✅ Try different USB port
- ✅ Check if computer recognizes USB device: `ls /dev/cu.usbmodem*`

__Device:__

- ✅ Press RESET button on ESP32-C6
- ✅ Check for any LED indicators
- ✅ Verify device is getting power

### 2. USB Connection Test

Test if device is detected:

```bash
# Check if port exists
ls -la /dev/cu.usbmodem*

# Try to read chip ID
esptool.py --port /dev/cu.usbmodem31201 chip_id

# If that fails, try with different baud rate
esptool.py --port /dev/cu.usbmodem31201 --baud 115200 chip_id
```

__If esptool can't connect:__

- Device may not be in bootloader mode
- USB driver issue
- Hardware problem

### 3. Bootloader Mode Test

Put device in bootloader mode manually:

1. __Hold BOOT button__ on ESP32-C6
2. __Press and release RESET__ button (while holding BOOT)
3. __Release BOOT button__
4. Try esptool again

### 4. Minimal Test Configuration

If device responds but firmware isn't working, try a minimal config to test:

Create `esphome/test-minimal.yaml`:

```yaml
esphome:
  name: test-esp32
  platform: ESP32

esp32:
  board: esp32-c6-devkitc-1
  variant: esp32c6
  framework:
    type: esp-idf

wifi:
  ap:
    ssid: "test-esp32"
    password: "test1234"

logger:
api:
```

This minimal config should at least create an AP. If this works, the issue is with the full configuration.

### 5. Re-flash Firmware

If device is detected but not working:

```bash
cd esphome
esphome upload all-in-one.yaml --device /dev/cu.usbmodem31201
```

__Important:__ Put device in bootloader mode first (BOOT + RESET)

### 6. Check for Boot Loop

If device keeps resetting:

- Check power supply (may need more current)
- Check for short circuits
- Verify all connections

### 7. Serial Monitor Alternative

Try using a serial monitor directly:

```bash
# Using screen
screen /dev/cu.usbmodem31201 115200

# Or using minicom
minicom -D /dev/cu.usbmodem31201 -b 115200

# Or using cu
cu -l /dev/cu.usbmodem31201 -s 115200
```

Press Ctrl+A then K to exit screen.

## Possible Causes

### 1. Firmware Corruption

- __Solution:__ Re-upload firmware
- Put in bootloader mode first

### 2. Power Issues

- __Symptoms:__ Device resets randomly
- __Solution:__ Use better USB cable, check power supply

### 3. Hardware Problem

- __Symptoms:__ No response at all
- __Solution:__ Check connections, try different device

### 4. USB Driver Issue

- __Symptoms:__ Port not detected
- __Solution:__ Install/update USB drivers (CP2102, CH340, etc.)

### 5. Boot Loop

- __Symptoms:__ Device resets continuously
- __Solution:__ Check logs for error, may need to fix configuration

## Step-by-Step Recovery

1. __Verify USB connection:__

   ```bash
   ls /dev/cu.usbmodem*
   ```

2. __Test device communication:__

   ```bash
   esptool.py --port /dev/cu.usbmodem31201 chip_id
   ```

3. __If device responds:__
   - Put in bootloader mode
   - Re-upload firmware
   - Check logs immediately after upload

4. __If device doesn't respond:__
   - Check hardware connections
   - Try different USB cable/port
   - Verify device isn't damaged

5. __After re-upload:__
   - Immediately check for AP "garage-aio"
   - Check USB logs
   - Verify device appears on network

## Quick Test Commands

```bash
# 1. Check port exists
ls /dev/cu.usbmodem*

# 2. Test device communication
esptool.py --port /dev/cu.usbmodem31201 chip_id

# 3. Read flash (verify firmware is there)
esptool.py --port /dev/cu.usbmodem31201 read_flash 0x0 0x1000 flash_dump.bin

# 4. Try serial monitor
screen /dev/cu.usbmodem31201 115200
```

## Next Steps

1. __First:__ Verify USB connection and device detection
2. __Second:__ Test with esptool to see if device responds
3. __Third:__ If device responds, re-upload firmware
4. __Fourth:__ If device doesn't respond, check hardware

The fact that there are NO logs suggests either:

- Device isn't booting at all
- USB connection issue
- Firmware corruption
- Hardware problem

We need to establish basic communication first before troubleshooting WiFi/AP issues.
