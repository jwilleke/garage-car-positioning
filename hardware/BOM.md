# Bill of Materials (BOM)

This document provides a comprehensive list of components for three different implementation options, all using the ESP32-C6 as the core microcontroller.

## Option 1: Standalone Car Positioning System

Standalone Car Positioning System focused only on detecting a car's position and providing visual LED feedback.

| Component | Quantity | Notes | URL |
| ---- | ---- | ---- |
| ESP32-C6 DevKit | 1 | Core microcontroller (Wifi 6, BLE) | [ESP32-C6-DevKitC-1-N8 Development Board](https://www.amazon.com/dp/B0BRMSDR4R?ref=ppx_yo2ov_dt_b_fed_asin_title&th=1) |
| HiLink LD2450 mmWave Radar | 2 | For precise car positioning (X, Y) | [HiLetgo 2pcs NJK-5002C](https://www.amazon.com/dp/B01MZYYCLH?ref=ppx_yo2ov_dt_b_fed_asin_title) |
| WS2812B LED Strip | 1 | Optional visual parking aid | [WS2812B LED Strip](https://www.amazon.com/SEZO-Individually-Addressable-Programmable-Non-Waterproof/dp/B097BWJGYK/)
| 5V Power Supply | 1 | 2A minimum | TBD |
| Jumper Wires | Assorted | For connecting modules | TBD |
| Project Box / Enclosure | 1 | Optional, for housing components | TBD |

## Option 2: Standalone Garage Door Controller

A robust, dedicated system for controlling the garage door.

| Component | Quantity | Notes | URL |
| ---- | ---- | ---- | ---- |
| ESP32-C6 DevKit | 1 | Core microcontroller (Wifi 6, BLE) | [ESP32-C6-DevKitC-1-N8 Development Board](https://www.amazon.com/dp/B0BRMSDR4R?ref=ppx_yo2ov_dt_b_fed_asin_title&th=1) |
| Magnetic Reed Switch | 1 | For the "Closed" state sensor | Already Had |
| Hall Effect Proximity Sensors (e.g., NJK-5002C) | 2 | For building the custom magnetic rotary encoder. | [NJK-5002C](https://www.amazon.com/dp/B01MZYYCLH?ref=ppx_yo2ov_dt_b_fed_asin_title) |
| Neodymium Magnets | Assorted | Small magnets for the rotary encoder's sprocket/shaft. | Already had |
| 5V Power Supply | 1 | 1A minimum | Already had |
| Jumper Wires | Assorted | For connecting modules | Already had |
| Project Box / Enclosure | 1 | Optional, for housing components | TBD |

## Option 3: Combined All-in-One System

A single, advanced system that performs **both** car positioning and garage door control **use one powerful ESP32-C6 microcontroller**.

### Controller & Power

| Component | Quantity | Notes | URL |
| ---- | ---- | ---- | ---- |
| ESP32-C6 DevKit | 1 | Core microcontroller to run both systems | [ESP32-C6-DevKitC-1-N8 Development Board](https://www.amazon.com/dp/B0BRMSDR4R?ref=ppx_yo2ov_dt_b_fed_asin_title&th=1) |
| 5V Power Supply | 1 | 3A or higher recommended for combined load | TBD |

### Car Positioning Parts

| Component | Quantity | Notes | URL |
| ---- | ---- | ---- | ---- |
| HiLink LD2450 mmWave Radar | 2 | For precise car positioning (X, Y) | [JMT HLK-LD2450 24GHz](https://www.amazon.com/dp/B0CGNMCTRC?ref=ppx_yo2ov_dt_b_fed_asin_title&th=1) |
| WS2812B LED Strip | 1 | Optional visual parking aid | [WS2812B LED Strip](https://www.amazon.com/SEZO-Individually-Addressable-Programmable-Non-Waterproof/dp/B097BWJGYK/) |

### Garage Door Parts

| Component | Quantity | Notes | URL |
| ---- | ---- | ---- | ---- |
| Single-channel 3.3V Relay | 1 | To simulate a button press on the opener | [1 Channel DC 3V / 3.3V Relay](https://www.amazon.com/DiGiYes-Channel-Optocoupler-Isolated-Control/dp/B0CZ3T8116/) |
| Magnetic Reed Switch | 1 | For the "Closed" state sensor | Already had |
| Hall Effect Proximity Sensors (e.g., NJK-5002C) | 2 | For building the custom magnetic rotary encoder. | [NJK-5002C](https://www.amazon.com/dp/B01MZYYCLH?ref=ppx_yo2ov_dt_b_fed_asin_title) |
| Neodymium Magnets | Assorted | Small magnets for the rotary encoder's sprocket/shaft. | Already had |

#### Misc

| Component | Quantity | Notes | URL |
| ---- | ---- | ---- | ---- |
| Jumper Wires | Assorted | For connecting all modules to the ESP32 | Already had |
| Project Box / Enclosure | 1 | Optional, larger size may be needed | TBD |

## ESP32-C6 DevKit full docunmnetation

[ESP32-C6 DevKit full docunmnetation](https://docs.espressif.com/projects/esp-dev-kits/en/latest/esp32c6/esp32-c6-devkitc-1/index.html)

## LD2450

- LD2450 Ra·dar Module: A Trajectory Module, which can achieve real-time tracking of the position of the moving target in the detection area, and output the distance, angle and speed information of the moving target in the area through the serial port.
- Using Scenes: It is mainly used in common indoor scenes, such as home, office and hotel, to realize the positioning and tracking of moving people.
- Detection Angle : Azimuth ± 60° / Tilt ± 35°. Angle Accuracy : 2° ~ 20°.
- Detection Distance : Max Sensing Distance 8m. Distance Defense Rate : 0.75m. Distance Measurement Accuracy : 0.15m.
- Data Format : Serial ASCIl output. Modulation Mode: FMCW. Sweep Bandwidth: 250MHz (CE/FCC compliant). Frequency: 24G-24.25GHz.
- The Serial Port baud rate is 256000. 1 stop bit, no parity bit. Package: Default 1.5mmx4Pin Female.
- Warm Tips: The serial port tool and the host tool can not be used at the same time.
