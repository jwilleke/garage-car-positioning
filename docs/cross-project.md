# Cross-Project: ESPHome Firmware ↔ Home Assistant

## Related Project

**Home Assistant config:** `/Volumes/jobd/code/GitHub/mjs-ha`
GitHub: <https://github.com/jwilleke/mjs-ha>

## Responsibility Split

| Concern | Firmware (this repo) | HA / mjs-ha |
|---|---|---|
| Garage door control | Relay, encoder position, cover entity | Node-RED flows consume cover entity |
| Car positioning | LD2450 radar sensors, LED strip | Consume parking sensors for notifications |
| BLE scanning | Passive scan, forward ALL advertisements + RSSI to HA | Identify devices by MAC, detect approach/departure via RSSI trends |
| Notifications | — | Node-RED "Garage" flow triggers on entity state changes |

**BLE design principle:** Firmware is fully MAC-agnostic. `esp32_ble_tracker` + `bluetooth_proxy` forward every BLE advertisement (RSSI included) to HA. HA configures which MACs to track and determines approach/departure. No BLE device knowledge lives in firmware.

## Entity IDs Exposed by This Firmware

Device name: `esp32-garage-all-in-one` → HA entity prefix: `garage_all_in_one_`

### Garage Door

| Entity | Type | Description |
|---|---|---|
| `cover.garage_all_in_one_garage_door` | cover | Primary control — open/close/stop |
| `sensor.garage_all_in_one_garage_door_position` | sensor | Door position 0–100% |
| `sensor.garage_all_in_one_garage_door_status` | text_sensor | "Closed" or "Open X%" |
| `binary_sensor.garage_all_in_one_garage_door_closed_switch` | binary_sensor | Reed switch — TRUE = door open |
| `switch.garage_all_in_one_garage_door_toggle` | switch | Raw relay trigger (prefer cover entity) |
| `number.garage_all_in_one_garage_door_full_open_counts` | number | Encoder calibration (adjustable from HA) |
| `number.garage_all_in_one_garage_door_relay_pulse_ms` | number | Relay pulse duration (adjustable from HA) |

### Car Positioning

| Entity | Type | Description |
|---|---|---|
| `binary_sensor.garage_all_in_one_car_position_vehicle_detected` | binary_sensor | Car present in garage |
| `binary_sensor.garage_all_in_one_car_position_correctly_parked` | binary_sensor | Car in target zone |
| `binary_sensor.garage_all_in_one_car_position_person_in_danger_zone` | binary_sensor | Person near car |
| `sensor.garage_all_in_one_car_position_parking_guidance` | text_sensor | Parking direction text |
| `light.garage_all_in_one_car_position_led_strip` | light | WS2812B LED strip (auto-managed by firmware) |

### BLE

No firmware-level BLE entity. The `bluetooth_proxy` forwards all raw BLE advertisements to HA.
HA surfaces nearby BLE devices (with RSSI) in Settings → Devices & Services → Bluetooth.
mjs-ha handles device identification and approach/departure logic.

### System

| Entity | Type | Description |
|---|---|---|
| `sensor.garage_all_in_one_system_uptime` | sensor | Device uptime |
| `sensor.garage_all_in_one_system_firmware_version` | text_sensor | Firmware version string |

## Coordination Rules

- Entity `name:` renames in firmware change HA entity IDs — update Node-RED flows in mjs-ha before or immediately after flashing
- `cover.garage_all_in_one_garage_door` is the primary control surface — prefer it over the raw relay switch
- After flashing, run `sync-from-homeassistant.sh` in mjs-ha and check `overview.md` for unavailable entities
- BLE device MACs are configured in mjs-ha only — never in firmware

## Current Sync State

Last updated: 2026-04-29

- Firmware: v0.2.5 — needs OTA flash (v0.2.4 currently running)
- Issue #13 (encoder): flashed and functional — **hardware verification pending**: open door fully and confirm `Garage Door - Encoder Counts` climbs 0→37; adjust `full_open_counts` from HA if needed
- Issue #11 (BLE): complete — firmware MAC-agnostic; `bluetooth_proxy` forwarding all BLE + RSSI to HA
- Entity removed: `binary_sensor.garage_all_in_one_tesla_blue_moon_approaching` / `target_approaching` — gone since v0.2.4 flash
- mjs-ha action needed: configure target BLE MAC(s) in HA Bluetooth integration or Node-RED for approach/departure detection
