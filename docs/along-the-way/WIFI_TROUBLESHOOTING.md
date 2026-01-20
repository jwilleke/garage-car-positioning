# WiFi Connection Troubleshooting

## Issue: Device Not Appearing on Network

If your ESP32-C6 device is not connecting to your Unifi network, follow these steps:

## Common Causes

### 1. WiFi Band Compatibility ⚠️ **MOST COMMON**

**ESP32-C6 only supports 2.4GHz WiFi**, not 5GHz!

**Check your Unifi network:**

- Ensure your SSID "SWIT2" broadcasts on **2.4GHz**
- If you have separate 2.4GHz and 5GHz networks, use the 2.4GHz one
- In Unifi Console, check if "SWIT2" is configured for 2.4GHz band

**Solution**: Create or use a 2.4GHz-only network, or ensure your network broadcasts both bands with the same SSID.

### 2. WiFi Security Settings

ESP32-C6 supports:

- ✅ WPA2 (most common)
- ✅ WPA3 (if supported)
- ❌ WPA Enterprise (not supported)
- ❌ WEP (deprecated, not recommended)

**Check Unifi Console:**

- Security: Should be WPA2 or WPA3
- Not WPA Enterprise

### 3. WiFi Credentials

Verify your `secrets.yaml`:

```yaml
wifi_ssid: "SWIT2"  # Must match exactly (case-sensitive)
wifi_password: "Abc123......"  # Must be correct
```

**Common issues:**

- Extra spaces
- Case sensitivity
- Special characters not properly escaped

### 4. DHCP Issues

If DHCP is not working, use a static IP:

1. Find an available IP on your network (check Unifi Console)
2. Find your gateway IP (usually router IP)
3. Uncomment and configure in `all-in-one.yaml`:

```yaml
wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password
  manual_ip:
    static_ip: 192.168.1.100  # Change to available IP
    gateway: 192.168.1.1      # Your router's IP
    subnet: 255.255.255.0
```

### 5. Network Isolation / VLAN

If your Unifi network has:

- Client isolation enabled
- VLAN isolation
- Firewall rules blocking devices

**Solution**: Temporarily disable isolation or add the device to a trusted network.

## Diagnostic Steps

### Step 1: Check USB Logs

Connect via USB and check what's happening:

```bash
cd esphome
esphome logs all-in-one.yaml --device /dev/cu.usbmodem31201
```

Look for:

- `[WiFi] Connecting to 'SWIT2'...`
- `[WiFi] Connected!`
- `[WiFi] IP Address: 192.168.x.x`
- Or error messages like:
  - `[WiFi] Connection failed`
  - `[WiFi] Authentication failed`
  - `[WiFi] No AP found`

### Step 2: Check Access Point Mode

If WiFi fails, the device should create an access point:

- SSID: `esp32-garage-all-in-one-AP`
- Password: From `secrets.yaml` (`ap_password`)

**Connect to the AP** and use the captive portal to configure WiFi.

### Step 3: Verify Network Settings in Unifi

1. **Check 2.4GHz is enabled** for SSID "SWIT2"
2. **Check security settings** (WPA2/WPA3)
3. **Check DHCP pool** - ensure IPs are available
4. **Check firewall rules** - ensure new devices can connect
5. **Check if device appears** in "Clients" even if not fully connected

### Step 4: Test with Static IP

If DHCP is the issue, configure static IP:

1. Find available IP (e.g., 192.168.1.100)
2. Update `all-in-one.yaml` with manual_ip
3. Re-upload firmware
4. Check if device appears with that IP

## Quick Fixes to Try

### Fix 1: Enable Access Point Mode (Already Enabled)

The device should automatically create an AP if WiFi fails. Look for:

- WiFi network: `esp32-garage-all-in-one-AP`
- Connect and use captive portal

### Fix 2: Add WiFi Fast Connect

Add to `all-in-one.yaml`:

```yaml
wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password
  fast_connect: true  # Skip full scan, connect faster
  ap:
    ssid: "${device_name}-AP"
    password: !secret ap_password
```

### Fix 3: Add Power Save Mode

```yaml
wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password
  power_save_mode: none  # Disable power saving for better connection
```

### Fix 4: Increase Reboot Timeout

```yaml
wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password
  reboot_timeout: 10min  # Give more time to connect
```

## Recommended Configuration Update

Add these WiFi improvements to help with connection:

```yaml
wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password
  fast_connect: true
  power_save_mode: none
  reboot_timeout: 10min
  ap:
    ssid: "${device_name}-AP"
    password: !secret ap_password
  # Uncomment if DHCP issues:
  # manual_ip:
  #   static_ip: 192.168.1.100
  #   gateway: 192.168.1.1
  #   subnet: 255.255.255.0
```

## Next Steps

1. **Check USB logs** to see exact error
2. **Verify 2.4GHz network** in Unifi Console
3. **Check for AP mode** - look for `esp32-garage-all-in-one-AP` network
4. **Try static IP** if DHCP is the issue
5. **Update WiFi config** with improvements above
