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

See [BOM](./hardware/BOM.md)

## Quick Start

1. Clone this repository
2. Copy `esphome/garage-car-sensor.yaml` to your ESPHome directory
3. Update WiFi credentials and sensor positions
4. Flash to ESP32-C6
5. Add to Home Assistant

## Documentation

- [Installation Guide](docs/installation.md)
- [Calibration Guide](docs/calibration.md)
- [Bill of Materials](hardware/BOM.md)
- [Wiring Diagram](hardware/wiring-diagram.md)

## License

MIT License - See [LICENSE](LICENSE) for details.
