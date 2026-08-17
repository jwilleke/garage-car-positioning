# Debug: Device Not on Network and No AP Visible

## Current Situation

- Device not appearing on Unifi network
- AP "garage-aio" not visible
- Device may not be booting or stuck

## Immediate Diagnostic Steps

### Step 1: Check USB Connection and Logs

The device MUST be connected via USB to check what's happening:

```bash
cd esphome
esphome logs all-in-one.yaml --device /dev/cu.usbmodem31201
```

__What to look for:__

- Device booting messages
- WiFi connection attempts
- Error messages
- AP starting messages

### Step 2: Verify Device is Powering On

- Check if device LED is on (if it has one)
- Verify USB connection is stable
- Try different USB cable/port

### Step 3: Check if Firmware is Running

If logs show nothing, the device may not be booting:

- Try pressing RESET button on ESP32-C6
- Check if logs appear after reset
- Verify firmware was uploaded correctly

## Possible Issues

### Issue 1: Device Not Booting

__Symptoms:__

- No logs via USB
- No AP visible
- No activity

__Solutions:__

1. Press RESET button on ESP32-C6
2. Check USB connection
3. Re-upload firmware if needed

### Issue 2: WiFi Stuck in Connection Loop

__Symptoms:__

- Logs show repeated connection attempts
- Never times out to start AP
- No AP visible

__Solutions:__

1. Reduce `reboot_timeout` (already set to 5min)
2. Check WiFi credentials are correct
3. Verify 2.4GHz network is available

### Issue 3: AP Not Starting

__Symptoms:__

- Device connects to WiFi but no IP
- AP should start but doesn't

__Solutions:__

1. Force AP to always be available (see below)
2. Check `ap_timeout` setting
3. Verify AP password is correct

## Configuration Changes Made

I've updated the configuration:

- Reduced `reboot_timeout` to 5min (faster AP fallback)
- Added `ap_timeout: 1min` (AP stays available)

## Force AP to Always Be Available

If you want the AP to always broadcast (even when connected), we can add:

```yaml
wifi:
  ap:
    ssid: "garage-aio"
    password: !secret ap_password
    ap_timeout: 0s  # 0 = always on
```

This makes the AP always available, which is useful for debugging but uses more power.

## Next Steps

1. __Connect USB and check logs__ - This is critical to see what's happening
2. __Press RESET button__ - May help if device is stuck
3. __Check if device appears in Unifi__ - Even without IP, it might show as "connecting"
4. __Try re-uploading firmware__ - If logs show nothing, firmware may be corrupted

## Quick Test: Force AP Mode

To test if AP works, we can temporarily disable WiFi to force AP:

```yaml
wifi:
  # ssid: !secret wifi_ssid  # Comment out to force AP
  # password: !secret wifi_password
  ap:
    ssid: "garage-aio"
    password: !secret ap_password
    ap_timeout: 0s  # Always on
```

This will force the device to always broadcast the AP. Good for testing, but remove after debugging.

## Critical: Get USB Logs

__The most important step is to check USB logs__ to see what the device is actually doing. Without logs, we're guessing.

Run:

```bash
cd esphome
esphome logs all-in-one.yaml --device /dev/cu.usbmodem31201
```

And share what you see (or don't see).
