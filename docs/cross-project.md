# Cross-Project: ESPHome Firmware ↔ Home Assistant

## Related Project

**Home Assistant config:** `/Volumes/jobd/code/GitHub/mjs-ha`
GitHub: <https://github.com/jwilleke/mjs-ha>

The HA project contains Node-RED flows and HA config that consume entities published by this firmware.

## Entity IDs Exposed by This Firmware

Device name: `esp32-garage-all-in-one` → HA entity prefix: `garage_all_in_one_`

### Garage Door

| Entity | Type | Description |
|---|---|---|
| `cover.garage_all_in_one_garage_door` | cover | Main garage door control (open/close/stop) |
| `sensor.garage_all_in_one_garage_door_position` | sensor | Door position 0–100% |
| `sensor.garage_all_in_one_garage_door_status` | text_sensor | "Closed" or "Open X%" |
| `binary_sensor.garage_all_in_one_garage_door_closed_switch` | binary_sensor | Reed switch — TRUE = door open |
| `switch.garage_all_in_one_garage_door_open_close` | switch | Relay trigger (momentary) |
| `number.garage_all_in_one_garage_door_full_open_counts` | number | Encoder calibration (runtime) |
| `number.garage_all_in_one_garage_door_relay_pulse_ms` | number | Relay pulse duration (runtime) |

### Car Positioning

| Entity | Type | Description |
|---|---|---|
| `binary_sensor.garage_all_in_one_car_detected` | binary_sensor | Car present in garage |
| `binary_sensor.garage_all_in_one_car_correctly_parked` | binary_sensor | Car in target zone |
| `sensor.garage_all_in_one_car_position_parking_guidance` | text_sensor | Parking direction text |
| `light.garage_all_in_one_car_position_led_strip` | light | WS2812B LED strip |

### System

| Entity | Type | Description |
|---|---|---|
| `sensor.garage_all_in_one_system_uptime` | sensor | Device uptime |
| `binary_sensor.garage_all_in_one_person_in_danger_zone` | binary_sensor | Person near car |

## Coordination Rules

- Any rename of an entity `name:` field in this firmware changes the HA entity ID — update Node-RED flows and HA automations in `mjs-ha` before or immediately after flashing
- The `cover.garage_all_in_one_garage_door` entity is the primary control surface — prefer it over the raw relay switch
- After flashing new firmware, run `sync-from-homeassistant.sh` in `mjs-ha` and check `overview.md` for unavailable entities

## Current Sync State

Last updated: 2026-04-29

- Firmware version: v0.2.4
- Active issue: [#13](https://github.com/jwilleke/garage-car-positioning/issues/13) — encoder position tracking broken, fix planned (single-channel pulse counter replacing rotary_encoder)
- No HA entity renames pending
- Node-RED flows in `mjs-ha` that use garage entities: unknown — search `flows.pretty.json` for `garage_all_in_one`
