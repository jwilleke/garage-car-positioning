# Project Overview

This is a DIY garage automation system that uses an ESP32-C6 microcontroller to provide car positioning and garage door control. The system is designed to be flexible, with three different build options: a standalone car positioning system, a standalone garage door controller, or a combined all-in-one system.

The car positioning system uses two mmWave radar sensors to provide centimeter-level accuracy in detecting a car's position. A WS2812B addressable LED strip provides a visual parking aid.

The garage door controller uses a rotary encoder to track the door's position and a relay to control the garage door opener.

The system is powered by ESPHome and integrates seamlessly with Home Assistant.

## Building and Running

This project is based on ESPHome, so there is no traditional "build" process. Instead, you will need to:

1. **Set up ESPHome:** If you haven't already, you will need to set up ESPHome. This is typically done as a Home Assistant add-on.
2. **Configure ESPHome:**
    * Create a new ESPHome device.
    * Copy the contents of `esphome/garage-car-sensor.yaml` or `esphome/esp32-garage-door.yaml` (or a combination of both for the all-in-one system) into the ESPHome editor for your device.
    * Create a `secrets.yaml` file in your ESPHome configuration directory (if you don't already have one) and add the following secrets, replacing the placeholder values with your own:

        ```yaml
        wifi_ssid: "YOUR_WIFI_SSID"
        wifi_password: "YOUR_WIFI_PASSWORD"
        ap_password: "YOUR_AP_PASSWORD"
        ota_password: "YOUR_OTA_PASSWORD"
        api_encryption_key: "YOUR_API_ENCRYPTION_KEY"
        ```

3. **Flash the ESP32-C6:**
    * Connect the ESP32-C6 to your computer.
    * Click "Install" in the ESPHome UI and select "Plug into this computer".
    * ESPHome will then compile the firmware and flash it to the ESP32-C6.

## Development Conventions

* **ESPHome:** The core logic of the project is defined in YAML files in the `esphome/` directory. These files are used to configure the ESP32-C6.
* **Home Assistant:** The system is designed to be used with Home Assistant. The `home-assistant/` directory contains example configurations for automations and dashboards.
* **Hardware:** The `hardware/` directory contains the bill of materials (BOM) and wiring diagrams for the different build options.
* **Documentation:** The `docs/` directory contains detailed documentation on the project, including installation, calibration, and light strip operation.
