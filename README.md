# 🚗 Garage Automation System

A flexible, DIY garage automation project for Home Assistant, featuring precise car positioning and a full-featured smart garage door controller, all powered by ESPHome and the ESP32-C6.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![ESPHome](https://img.shields.io/badge/ESPHome-supported-green.svg)
![Home Assistant](https://img.shields.io/badge/Home%20Assistant-supported-blue.svg)

## Overview

This project provides a comprehensive solution for automating your garage. It can be built as a standalone car positioner, a standalone smart garage door controller, or a combined all-in-one unit.

## Features

- Precise, dual mmWave radar sensors for centimeter-level car positioning.
- Visual parking aid using a WS2812B addressable LED strip.
- Full-featured smart garage door controller.
- High-precision door position tracking with a rotary encoder.
- Powered by the ESP32-C6 with Wi-Fi 6, Thread, and Matter support.
- Seamless integration with Home Assistant using ESPHome.
- Supports multiple build paths:
  - Standalone Car Positioning System
  - Standalone Garage Door Controller
  - Combined All-in-One System

## Getting Started

The full step-by-step guide to building, installing, and configuring the system can be found in our comprehensive installation guide.

➡️ [View the Full Installation Guide](./docs/Installation.md)

## Documentation

All documentation is organized to guide you through the process, from component selection to final setup.

- [Installation Guide](./docs/Installation.md) - The main, step-by-step guide.
- [Bill of Materials (BOM)](./hardware/BOM.md) - Component lists for all three build options.
- [Wiring Diagrams](./hardware/wiring-diagram.md) - Detailed wiring instructions for all three build options.
- [Calibration Guide](./docs/calibration.md) - Instructions for calibrating the sensors and door position.
- [LED Strip Operation](./docs/light-strip-operation.md) - An explanation of the visual parking aid.

## Contributing

Contributions are welcome! This is a community project, and we appreciate any help, from documentation fixes to new features.

Please read our [Contributing Guidelines](./CONTRIBUTING.md) to get started.

## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.
