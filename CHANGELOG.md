# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

- Broken `esp32_rmt` platform in garage-car-sensor.yaml (now `esp32_rmt_led_strip`)
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

[Unreleased]: https://github.com/jwilleke/garage-car-positioning/compare/v0.1.1...HEAD
[0.1.1]: https://github.com/jwilleke/garage-car-positioning/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/jwilleke/garage-car-positioning/releases/tag/v0.1.0
