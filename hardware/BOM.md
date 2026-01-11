# Bill of Materials (BOM)

This document provides a comprehensive list of components required for both the Garage Car Positioning System and the Garage Door Opener.

---

## 🚗 Garage Car Positioning System

These components are essential for detecting the car's position in the garage and providing visual feedback.

| Component             | Quantity | Notes                                       |
| :-------------------- | :------- | :------------------------------------------ |
| ESP32-C6 DevKit       | 1        | Core microcontroller (Wifi 6, BLE)          |
| HiLink LD2450 mmWave Radar | 2        | For precise car positioning (X, Y)          |
| WS2812B LED Strip     | 1        | Optional visual parking aid                 |
| 5V Power Supply       | 1        | 2A minimum, for ESP32 and LED strip         |
| Jumper Wires (M/F, F/F) | Assorted | For connecting modules to ESP32             |

---

## 🚪 Garage Door Opener

These components are required for controlling the garage door and accurately tracking its open/closed position.

| Component                     | Quantity | Notes                                       |
| :---------------------------- | :------- | :------------------------------------------ |
| Single-channel 3.3V Opto-isolated Relay | 1        | To simulate a button press on the garage door opener |
| Magnetic Reed Switch          | 2        | One for "Closed" state, one for "Open" state. (Current ESPHome config uses only the 'closed' switch, but two are recommended for full open/closed state detection as per the planning document.) |
| Hall Effect Sensors (e.g., SS49E) | 2        | For building the custom magnetic rotary encoder. |
| Neodymium Magnets             | Assorted | Small magnets for the rotary encoder's sprocket/shaft. |
| Jumper Wires (M/F, F/F)       | Assorted | For connecting modules to ESP32             |
| Project Box or 3D-Printed Enclosure | 1        | Optional, for housing components safely     |

---