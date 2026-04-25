# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.2] - 2026-04-25

### Changed

- Renamed garage door relay switch entity from `Garage Door - Open / Close` to `Garage Door - Toggle` to better reflect momentary-relay behavior. HA `cover.garage_door` remains the proper open/close control surface.

### Migration

- After flashing, Home Assistant will register a new `switch.garage_door_toggle` entity. The old `switch.garage_door_open_close` becomes orphaned and should be removed manually via Settings → Devices & Services → ESPHome → garage device.

## [0.2.1] - 2026-04-24

### Added

- Enabled `ble_presence` binary sensor in `packages/tesla-ble.yaml` for Tesla Blue Moon (MAC `0c:0a:df:b3:ae:13`) with `delayed_on` / `delayed_off` filters to debounce intermittent BLE advertising.
- `blue_moon_ble_mac` added to required-secrets comment in `ha-builder.yaml`.

### Notes

- Part of jwilleke/mjs-ha#1 (Tesla approach detection, Layer 1 Phase 2).

## [0.2.0] - 2026-04-24

### Added

- New `esphome/packages/tesla-ble.yaml` package: passive `esp32_ble_tracker` (100% duty cycle) plus passive `bluetooth_proxy` for BLE proximity detection.
- `tesla_ble` package included in `all-in-one.yaml`.
- `blue_moon_ble_mac` placeholder in `secrets.yaml.example`.

### Notes

- `ble_presence` binary sensor stub left commented in this release pending Blue Moon MAC discovery (enabled in 0.2.1).
- Part of jwilleke/mjs-ha#1 (Tesla approach detection, Layer 1 Phase 1).

## [0.1.1] - 2026-02-15

### Added

- ESPHome packages structure to reduce code duplication
  - `packages/base.yaml` - common ESP32-C6 config
  - `packages/car-sensor.yaml` - LD2450 and LED logic
  - `packages/garage-door.yaml` - encoder and relay
- Portal sections via naming prefixes (Car Position, Garage Door, System)
- LED scan animations for parking guidance
  - Move Forward (Blue Scan)
  - Move Forward Minor (Cyan Scan)
  - Move Back (Orange Scan)
  - Move Back Minor (Yellow Scan)
- Person detection with red flash alert
- `secrets.yaml.example` template
- Firmware version display in web portal
- SEMVER versioning (VERSION file, CHANGELOG.md)

### Fixed

- Broken `esp32_rmt` platform in car-positioning.yaml (now `esp32_rmt_led_strip`)
- `Color()` wrapper in LED lambdas
- X=0 validity check (now uses distance > 0)
- NaN guards in parking logic
- Typos in simple-wifi.yaml

### Changed

- Reduced main config files by ~80% via packages
- `ap_timeout` from 0s to 1min in production configs
- Added `restore_mode: ALWAYS_OFF` to relay and LED strip

## [0.1.0] - 2026-01-19

### Added

- Initial ESPHome configurations
- Dual LD2450 mmWave radar support
- WS2812B LED strip parking guidance
- Garage door encoder position tracking
- Hall effect sensor support
- Reed switch door detection
- Relay control for garage door opener

[Unreleased]: https://github.com/jwilleke/garage-car-positioning/compare/v0.2.2...HEAD
[0.2.2]: https://github.com/jwilleke/garage-car-positioning/compare/v0.2.1...v0.2.2
[0.2.1]: https://github.com/jwilleke/garage-car-positioning/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/jwilleke/garage-car-positioning/compare/v0.1.1...v0.2.0
[0.1.1]: https://github.com/jwilleke/garage-car-positioning/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/jwilleke/garage-car-positioning/releases/tag/v0.1.0
