#!/bin/bash
# Caution  Things change.

# Set the base directory
BASE_DIR="/Volumes/hd2A/workspaces/github/garage-car-positioning"

# Create directory structure
mkdir -p "$BASE_DIR"/{esphome,home-assistant,hardware/3d-prints,docs/images}

cd "$BASE_DIR"

# Initialize git
git init

# Create .gitignore
cat > .gitignore << 'EOF'
# Secrets
secrets.yaml
.secrets/

# ESPHome
.esphome/
**/.pioenvs/
**/.piolibdeps/

# Python
__pycache__/
*.py[cod]
.venv/
venv/

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Build artifacts
*.bin
*.elf
EOF

# Create LICENSE
cat > LICENSE << 'EOF'
MIT License

Copyright (c) 2024

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF

# Create README.md
cat > README.md << 'EOF'
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
EOF

# Create ESPHome configuration
cat > esphome/garage-car-sensor.yaml << 'EOF'
substitutions:
  device_name: garage-car-sensor
  friendly_name: "Garage Car Sensor"
  
  # Target parking zone (adjust after calibration)
  target_y_min: "1800"
  target_y_max: "2200"
  target_x_tolerance: "300"

esphome:
  name: ${device_name}
  friendly_name: ${friendly_name}
  platformio_options:
    board_build.flash_mode: dio

esp32:
  board: esp32-c6-devkitc-1
  variant: esp32c6
  framework:
    type: esp-idf
    version: recommended

logger:
  level: DEBUG

api:
  encryption:
    key: !secret api_encryption_key

ota:
  - platform: esphome
    password: !secret ota_password

wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password
  ap:
    ssid: "${device_name}-AP"
    password: !secret ap_password

captive_portal:

uart:
  - id: uart_ld2450_front
    rx_pin: GPIO16
    tx_pin: GPIO17
    baud_rate: 256000
    
  - id: uart_ld2450_rear
    rx_pin: GPIO18
    tx_pin: GPIO19
    baud_rate: 256000

ld2450:
  - id: ld2450_front
    uart_id: uart_ld2450_front
    throttle: 500ms
    
  - id: ld2450_rear
    uart_id: uart_ld2450_rear
    throttle: 500ms

sensor:
  - platform: ld2450
    ld2450_id: ld2450_front
    target_count:
      name: "Front Sensor Target Count"
    target_1:
      x:
        name: "Front Target X"
        id: front_x
      y:
        name: "Front Target Y"
        id: front_y
      distance:
        name: "Front Target Distance"
        id: front_distance

  - platform: ld2450
    ld2450_id: ld2450_rear
    target_count:
      name: "Rear Sensor Target Count"
    target_1:
      x:
        name: "Rear Target X"
        id: rear_x
      y:
        name: "Rear Target Y"
        id: rear_y
      distance:
        name: "Rear Target Distance"
        id: rear_distance

  - platform: template
    name: "Car Center X Position"
    id: car_center_x
    unit_of_measurement: "mm"
    lambda: |-
      if (id(front_x).state != 0 && id(rear_x).state != 0) {
        return (id(front_x).state + id(rear_x).state) / 2.0;
      }
      return 0;
    update_interval: 500ms

  - platform: template
    name: "Car Center Y Position"
    id: car_center_y
    unit_of_measurement: "mm"
    lambda: |-
      if (id(front_y).state != 0 && id(rear_y).state != 0) {
        return (id(front_y).state + id(rear_y).state) / 2.0;
      }
      return 0;
    update_interval: 500ms

binary_sensor:
  - platform: template
    name: "Car Detected"
    id: car_detected
    device_class: occupancy
    lambda: |-
      return (id(front_distance).state > 100) || (id(rear_distance).state > 100);
    filters:
      - delayed_on: 1s
      - delayed_off: 5s

  - platform: template
    name: "Car Correctly Parked"
    id: car_correctly_parked
    device_class: occupancy
    lambda: |-
      float y = id(car_center_y).state;
      float x = abs(id(car_center_x).state);
      bool y_ok = (y >= ${target_y_min}) && (y <= ${target_y_max});
      bool x_ok = x <= ${target_x_tolerance};
      return id(car_detected).state && y_ok && x_ok;

text_sensor:
  - platform: template
    name: "Parking Guidance"
    lambda: |-
      if (!id(car_detected).state) {
        return {"No car detected"};
      }
      if (id(car_correctly_parked).state) {
        return {"✅ Perfect!"};
      }
      float y = id(car_center_y).state;
      float target = (${target_y_min} + ${target_y_max}) / 2.0;
      if (y < target - 100) return {"⬆️ Move FORWARD"};
      if (y > target + 100) return {"⬇️ Move BACK"};
      return {"🔄 Minor adjustment"};
    update_interval: 500ms

button:
  - platform: restart
    name: "Restart"
EOF

# Create BOM
cat > hardware/BOM.md << 'EOF'
# Bill of Materials (BOM)

## Required Components

| # | Component | Qty | Est. Price |
|---|-----------|-----|------------|
| 1 | ESP32-C6-DevKitC-1 | 1 | $8-12 |
| 2 | HiLink LD2450 24GHz Radar | 2 | $6-10 each |
| 3 | 5V 2A Power Supply | 1 | $5-8 |
| 4 | JST-XH 4-Pin Connectors | 4 | $2 |
| 5 | 22AWG Hookup Wire | 1m | $2 |
| 6 | Project Enclosure (IP65) | 1 | $5-10 |

## Optional Components

| # | Component | Qty | Notes |
|---|-----------|-----|-------|
| 7 | WS2812B LED Strip (30/m) | 1m | Visual parking guide |
| 8 | 1000µF Capacitor | 1 | LED strip protection |

**Total Estimated Cost**: $30-50
EOF

# Create wiring diagram
cat > hardware/wiring-diagram.md << 'EOF'
# Wiring Diagram

## ESP32-C6 Connections

