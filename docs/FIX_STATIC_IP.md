# Fix: Device Not Getting IP Address

## Problem

Device connects to WiFi but never obtains an IP address from DHCP server.

## Solution: Configure Static IP

I've updated the configuration to use a static IP address. You need to customize the values for your network.

## Step 1: Find Your Network Information

### In Unifi Console

1. **Find Gateway IP** (Router IP):
   - Go to **Settings** → **Networks**
   - Find your network (the one "SWIT2" uses)
   - Look for **Gateway IP/Subnet** (usually `192.168.1.1` or `192.168.68.1`)

2. **Find Available IP Address**:
   - Go to **Clients** or **Insights** → **DHCP Leases**
   - Find an IP that's NOT in use
   - Or use an IP outside your DHCP range (e.g., if DHCP is 192.168.68.100-200, use 192.168.68.50)

3. **Find Subnet Mask**:
   - Usually `255.255.255.0` for home networks
   - Check in **Settings** → **Networks** → Your network

## Step 2: Update Configuration

Edit `esphome/all-in-one.yaml` and update these values:

```yaml
wifi:
  manual_ip:
    static_ip: 192.168.68.100  # <-- Your chosen available IP
    gateway: 192.168.68.1      # <-- Your router/gateway IP
    subnet: 255.255.255.0      # <-- Your subnet mask
    dns1: 192.168.68.1         # <-- Usually same as gateway
    dns2: 8.8.8.8              # Google DNS backup
```

**Example values** (update for your network):

- If gateway is `192.168.1.1`: Use `192.168.1.100` for static_ip
- If gateway is `192.168.68.1`: Use `192.168.68.100` for static_ip
- If gateway is `10.0.0.1`: Use `10.0.0.100` for static_ip

## Step 3: Re-upload Firmware

After updating the IP configuration:

```bash
cd esphome
esphome upload all-in-one.yaml
# Select option [1] for USB upload
```

## Step 4: Verify Connection

After upload, check:

1. **In Unifi Console**:
   - Go to **Clients**
   - Look for device with the static IP you configured
   - Should show as "esp32-garage-all-in-one" or MAC address `98:a3:16:b1:c3:fc`

2. **Ping the device**:

   ```bash
   ping 192.168.68.100  # Use your static IP
   ```

3. **Check Home Assistant**:
   - Device should appear in ESPHome integration
   - Accessible at the static IP

## Common Network Ranges

- **192.168.1.x** - Gateway usually `192.168.1.1`
- **192.168.68.x** - Gateway usually `192.168.68.1` (common in Unifi)
- **10.0.0.x** - Gateway usually `10.0.0.1`
- **172.16.x.x** - Less common for home networks

## Troubleshooting

### Still Not Connecting?

1. **Check IP is available**:
   - Ping the IP: `ping 192.168.68.100`
   - If it responds, IP is in use - choose different IP

2. **Check Gateway is correct**:
   - From Unifi Console, verify the exact gateway IP
   - Must match your network's gateway

3. **Check Subnet Mask**:
   - Most home networks use `255.255.255.0`
   - Verify in Unifi Console

4. **Check Firewall Rules**:
   - In Unifi Console, check if firewall is blocking the device
   - May need to allow device on network

5. **Try Different IP**:
   - If one IP doesn't work, try another in the same range
   - Make sure it's outside DHCP range

## Alternative: Reserve IP in DHCP

Instead of static IP, you can reserve an IP in Unifi:

1. Go to **Clients** in Unifi Console
2. Find device by MAC: `98:a3:16:b1:c3:fc`
3. Click device → **Configure** → **Use Fixed IP Address**
4. Assign an IP
5. Remove `manual_ip` from configuration (let DHCP handle it)

This way the device uses DHCP but always gets the same IP.

## Current Configuration

The configuration file has been updated with placeholder values. You MUST update them for your network before re-uploading!
