# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Read: AGENTS.md and related files.

## Project Summary

DIY garage automation system using an ESP32-C6 microcontroller with ESPHome firmware, integrated with Home Assistant. Provides car positioning via dual LD2450 mmWave radar sensors with a WS2812B LED parking aid, and smart garage door control via rotary encoder position tracking.

Three build configurations exist in `esphome/`:

- `garage-car-sensor.yaml` — standalone car positioning
- `esp32-garage-door.yaml` — standalone door controller
- `all-in-one.yaml` — combined system (primary config)

## Build Commands

This is an ESPHome project, not a traditional software project. Use ESPHome CLI:

```bash
esphome config esphome/all-in-one.yaml     # Validate YAML configuration
esphome compile esphome/all-in-one.yaml     # Compile firmware
esphome upload esphome/all-in-one.yaml      # Flash to ESP32-C6
esphome logs esphome/all-in-one.yaml        # Monitor serial/network logs
```

Replace `all-in-one.yaml` with the appropriate config for other build options.

A `secrets.yaml` file is required in `esphome/` with: `wifi_ssid`, `wifi_password`, `ap_password`, `ota_password`, `api_encryption_key`.

## Architecture

**Firmware layer** (`esphome/`): YAML configs define sensors, actuators, and logic using ESPHome's component model with C++ lambda functions for custom calculations.

**Data flow — car positioning**: LD2450 front/rear sensors (UART at 256000 baud) → raw X/Y/distance readings → template sensors compute car center position → binary sensors determine `car_detected` and `car_correctly_parked` → LED strip color reflects parking status.

**Data flow — garage door**: Hall effect encoder sensors (GPIO2/3) → pulse counting → door position percentage → Home Assistant cover entity. Reed switch (GPIO1) detects closed state. Relay (GPIO10) triggers door opener.

**Home Assistant integration** (`home-assistant/`): Contains example automations, dashboard cards, and templates that consume ESPHome entities.

**Key substitutions** in `all-in-one.yaml` control behavior:

- `target_y_min`/`target_y_max`: parking zone Y range (mm)
- `target_x_tolerance`: acceptable X deviation (mm)
- `garage_door_full_open_counts`: encoder pulses for full open
- `num_leds`: LED strip length

**GPIO assignments** (ESP32-C6): GPIO0 (LEDs), GPIO1 (door switch), GPIO2-3 (encoder), GPIO10 (relay), GPIO16-17 (front radar UART), GPIO18-19 (rear radar UART).

## Conventions

- Follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) for commit messages.
- Markdown uses ATX-style headings, 2-space indentation for lists, and allows inline HTML (see `.markdownlint.json`).
- Documentation lives in `docs/` with hardware specs in `docs/hardware/`.
- Utility scripts in `utility/` (setup, upload, log viewing, encoder calculations).
