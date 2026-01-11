# Bill of Materials (BOM)

This document provides a comprehensive list of components for three different implementation options. Choose the option that best fits your needs.

---

## Option 1: Standalone Car Positioning System

A complete system focused only on detecting a car's position and providing visual LED feedback. This is the simplest build.

| Component                  | Quantity | Notes                               |
| :------------------------- | :------- | :---------------------------------- |
| ESP32-C6 DevKit            | 1        | Core microcontroller (Wifi 6, BLE)  |
| HiLink LD2450 mmWave Radar | 2        | For precise car positioning (X, Y)  |
| WS2812B LED Strip          | 1        | Optional visual parking aid         |
| 5V Power Supply            | 1        | 2A minimum, for ESP32 and LED strip |
| Jumper Wires               | Assorted | For connecting modules to ESP32     |
| Project Box / Enclosure    | 1        | Optional, for housing components    |

---

## Option 2: Standalone Garage Door Controller

A robust, dedicated system for controlling the garage door, built around a Shelly Plus 1 for safety and simplicity.

| Component                                       | Quantity | Notes                                                         |
| :---------------------------------------------- | :------- | :------------------------------------------------------------ |
| Shelly Plus 1                                   | 1        | Core controller with integrated relay.                        |
| Magnetic Reed Switch                            | 1        | For the "Closed" state sensor. Connects to Shelly's SW input. |
| Hall Effect Proximity Sensors (e.g., NJK-5002C) | 2        | For building the custom magnetic rotary encoder.              |
| Neodymium Magnets                               | Assorted | Small magnets for the rotary encoder's sprocket/shaft.        |
| Jumper Wires                                    | Assorted | For connecting sensors to Shelly's expansion header.          |

---

## Option 3: Combined All-in-One System

A single, advanced system that performs **both** car positioning and garage door control using one powerful ESP32-C6 microcontroller. This is a more complex build requiring more wiring to a single device.

| Component                                       | Quantity | Notes                                                         |
| :---------------------------------------------- | :------- | :------------------------------------------------------------ |
| **Controller & Power**                          |          |                                                               |
| ESP32-C6 DevKit                                 | 1        | Core microcontroller to run both systems                      |
| 5V Power Supply                                 | 1        | 3A or higher recommended for combined load                    |
| **Car Positioning Parts**                       |          |                                                               |
| HiLink LD2450 mmWave Radar                      | 2        | For precise car positioning (X, Y)                            |
| WS2812B LED Strip                               | 1        | Optional visual parking aid                                   |
| **Garage Door Parts**                           |          |                                                               |
| Single-channel 3.3V Relay                       | 1        | To simulate a button press on the opener                      |
| Magnetic Reed Switch                            | 1        | For the "Closed" state sensor                                 |
| Hall Effect Proximity Sensors (e.g., NJK-5002C) | 2        | For building the custom magnetic rotary encoder.              |
| Neodymium Magnets                               | Assorted | Small magnets for the rotary encoder's sprocket/shaft.        |
| **Misc**                                        |          |                                                               |
| Jumper Wires                                    | Assorted | For connecting all modules to the ESP32                       |
| Project Box / Enclosure                         | 1        | Optional, larger size may be needed                           |
