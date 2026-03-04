# ESPHome Configuration Reference

Overview of all firmware configs in `esphome/` and the shared package architecture.

---

## Flashing

### Standard workflow (OTA — device on WiFi)

No USB required. Device must be reachable on the network.

```bash
cd esphome
esphome run all-in-one.yaml
```

`run` compiles, flashes via OTA, then streams logs. This is the normal update path.

### Validate or compile only

```bash
esphome config all-in-one.yaml    # YAML validation only — fast, no compile
esphome compile all-in-one.yaml   # Compile only, no flash
esphome logs all-in-one.yaml      # Stream logs from running device
```

### USB flash (first flash or WiFi unavailable)

Put the board in bootloader mode first:

1. Hold `BOOT`
2. Press + release `RESET` (while holding BOOT)
3. Release `BOOT`

Then run the utility script:

```bash
utility/UPLOAD_NOW.sh
```

Or manually:

```bash
cd esphome
esphome run all-in-one.yaml --device /dev/cu.usbmodem31201
```

---

## Build Configs

Three production configs exist, each targeting a different hardware build path. All use the shared `packages/` directory — see [Package Architecture](#package-architecture) below.

### `all-in-one.yaml` — Primary Config

Combines car positioning and garage door control on a single ESP32-C6. This is the primary maintained config and the source of truth for all shared logic.

- Includes all three packages: `base`, `car_sensor`, `garage_door`
- Contains only substitutions and WiFi config — all logic lives in packages
- See [Installation.md](Installation.md) for full setup

### `car-positioning.yaml` — Standalone Car Sensor

Car positioning only — no garage door control.

- Includes `base` and `car_sensor` packages
- See [car-positioning-guide.md](car-positioning-guide.md)

### `garage-door.yaml` — Standalone Door Controller

Garage door control only — no radar sensors or LED strip.

- Includes `base` and `garage_door` packages
- See [garage-door-guide.md](garage-door-guide.md)

### `ha-builder.yaml` — Home Assistant ESPHome Builder

Identical to `all-in-one.yaml` but uses `github://` package references instead of local `!include`. Paste this file into the ESPHome Builder add-on in Home Assistant — packages are pulled directly from the public GitHub repo, no file copying required.

➡️ [github.com/jwilleke/garage-car-positioning](https://github.com/jwilleke/garage-car-positioning)

Required entries in HA's `secrets.yaml`:

```yaml
wifi_ssid: "your-ssid"
wifi_password: "your-wifi-password"
ap_password: "your-ap-password"
ota_password: "your-ota-password"
api_encryption_key: "your-32-byte-base64-key"
```

---

## Test Config

### `test-minimal.yaml` — Hardware Bring-Up

Bare-minimum ESP32-C6 config for initial board validation. No sensors, no API key, open AP only. Used to confirm the board boots and WiFi AP is reachable before flashing production firmware.

Not intended for production use.

---

## Package Architecture

All shared firmware logic lives in `esphome/packages/`. Configs compose behavior by declaring which packages to include.

```
esphome/
  all-in-one.yaml          ← substitutions + wifi only
  car-positioning.yaml     ← substitutions + wifi only
  garage-door.yaml         ← substitutions + wifi only
  test-minimal.yaml        ← hardware bring-up only
  packages/
    base.yaml              ← ESP32 board, logger, API, OTA, web server, system sensors
    car-sensor.yaml        ← LD2450 radar, LED strip, parking guidance, danger zone
    garage-door.yaml       ← rotary encoder, relay, cover entity, position tracking
```

### `packages/base.yaml`

Shared by all production configs. Provides:

- ESP32-C6 board and IDF framework config
- Logger (compile-time DEBUG, runtime WARN on boot)
- API (`id: garage_api`) with reboot watchdog — reboots after 15 min with no HA client
- OTA, captive portal, web server with sorting groups (Car/Door/Config/Diagnostic)
- System sensors: boot count, uptime, reset reason, firmware version, MAC address
- Log level select and API watchdog switch

### `packages/car-sensor.yaml`

Car positioning subsystem. Requires substitutions:

| Substitution | Description |
| --- | --- |
| `ld2450_front_rx/tx_pin` | UART pins for ceiling-mounted sensor |
| `ld2450_rear_rx/tx_pin` | UART pins for wall-mounted sensor |
| `led_strip_pin` | WS2812B data pin |
| `num_leds` | LED strip length |
| `front_target_y_min/max` | Ceiling-to-car Y range (in) |
| `front_target_x_tolerance` | Max lateral offset (in) |
| `rear_target_y_min/max` | Parking depth from back wall (in) |
| `person_max_distance` | Max distance to classify as person (in) |
| `danger_zone_distance` | Danger zone radius (in) |

Provides: dual LD2450 radar (T1 + T2 targets), car detection, person detection, danger zone alert, parking guidance text sensor, LED auto mode, LED effects.

### `packages/garage-door.yaml`

Garage door subsystem. Requires substitutions:

| Substitution | Description |
| --- | --- |
| `garage_door_relay_pin` | Relay GPIO |
| `garage_door_closed_switch_pin` | Reed switch GPIO |
| `garage_door_encoder_a_pin` | Rotary encoder A GPIO |
| `garage_door_encoder_b_pin` | Rotary encoder B GPIO |
| `garage_door_full_open_counts` | Encoder counts at full open — **must calibrate** |

Provides: rotary encoder position tracking (resolution 4), relay with configurable pulse duration, closed switch, door position %, door status text sensor, `cover` entity for Home Assistant, reset encoder button.

> Calibrating `garage_door_full_open_counts`: flash firmware, open the door fully, read `Garage Door - Encoder Counts` from the HA diagnostic panel or web UI, then update the substitution and reflash.
