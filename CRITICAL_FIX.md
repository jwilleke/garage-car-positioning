# Critical Fix: Device Not Booting

## Problem Summary
- Device responds to esptool (hardware OK)
- Firmware uploads successfully
- **BUT**: No logs, no AP, no network connection
- Device appears to crash on boot

## Fix Applied

### Logger Hardware UART Configuration
Added explicit logger configuration for ESP32-C6:

```yaml
logger:
  level: DEBUG
  hardware_uart: USB_SERIAL_JTAG  # ESP32-C6 uses USB Serial JTAG for logging
```

This ensures logs are output to the correct UART on ESP32-C6.

## Next Steps - CRITICAL

### 1. Put Device in Bootloader Mode

**IMPORTANT**: Before uploading, put device in bootloader mode:

1. **Hold BOOT button** on ESP32-C6
2. **Press and release RESET** button (while holding BOOT)
3. **Release BOOT button**
4. Device is now in bootloader mode

### 2. Re-upload Firmware

```bash
cd esphome
esphome upload all-in-one.yaml --device /dev/cu.usbmodem31201
```

Or if prompted:
```bash
esphome upload all-in-one.yaml
# Select option [1] for USB
```

### 3. Immediately Check Logs

Right after upload completes:

```bash
esphome logs all-in-one.yaml --device /dev/cu.usbmodem31201
```

**What to look for:**
- Boot messages
- WiFi connection attempts
- AP starting ("garage-aio")
- Any error messages

### 4. Check for AP

After upload, immediately check for WiFi network:
- **SSID**: `garage-aio`
- **Password**: `Jbsbws12!` (from secrets.yaml)

The AP is set to always be on (`ap_timeout: 0s`), so it should appear immediately if device is running.

## If Still No Response

### Option 1: Try Minimal Test Config

Test with minimal configuration to see if device boots at all:

```bash
cd esphome
esphome upload test-minimal.yaml --device /dev/cu.usbmodem31201
```

This creates a simple AP "test-esp32" with password "test1234". If this works, the issue is with the full configuration.

### Option 2: Check for GPIO Conflicts

GPIO0 is used for LED strip. On some ESP32 boards, GPIO0 can be problematic. If minimal config works, we may need to change the LED strip pin.

### Option 3: Check Power Supply

- Ensure adequate power (5V, 3A+ recommended for all-in-one)
- Try different USB cable
- Check if device has power LED indicators

## Current Configuration Status

✅ Logger hardware UART configured  
✅ AP set to always on (`ap_timeout: 0s`)  
✅ Static IP configured (192.168.20.218)  
✅ Captive portal enabled  
✅ All components configured  

## Most Likely Issue

The device is probably **crashing on boot** due to:
1. Component initialization failure
2. GPIO conflict
3. Power issue
4. Configuration error

The logger fix should help us see what's happening. If we still get no logs after the fix, the crash is happening very early, possibly before logger initializes.

## Diagnostic Command

After re-upload, try this to capture any output:

```bash
# Using screen (if available)
screen /dev/cu.usbmodem31201 115200

# Press Ctrl+A then K to exit
```

This will show raw serial output, which might reveal boot messages even if ESPHome logger isn't working.
