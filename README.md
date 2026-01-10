# 🚗 Garage Car Positioning System

Precise car positioning system for Home Assistant using dual LD2450 mmWave radar sensors and ESP32-C6.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![ESPHome](https://img.shields.io/badge/ESPHome-2024.1+-green.svg)
![Home Assistant](https://img.shields.io/badge/Home%20Assistant-2024.1+-blue.svg)

## Features

- ✅ **Dual mmWave sensors** for triangulated positioning
- ✅ **Centimeter-level accuracy** for precise parking guidance
- ✅ **ESP32-C6** with native WiFi 6 & Thread/Matter support
- ✅ **Visual parking aid** with LED strip integration
- ✅ **Home Assistant integration** via ESPHome
- ✅ **Temperature/humidity resistant** - perfect for garages

## Hardware Requirements

| Component | Quantity | Notes |
|-----------|----------|-------|
| ESP32-C6 DevKit | 1 | WiFi 6 + BLE 5.0 |
| HiLink LD2450 | 2 | 24GHz mmWave radar |
| WS2812B LED Strip | 1 | Optional - parking guide |
| 5V Power Supply | 1 | 2A minimum |
| Project Enclosure | 1 | 3D printed or purchased |

## Quick Start

1. Clone this repository
2. Copy `esphome/garage-car-sensor.yaml` to your ESPHome directory
3. Update WiFi credentials and sensor positions
4. Flash to ESP32-C6
5. Add to Home Assistant

## Wiring Diagram

