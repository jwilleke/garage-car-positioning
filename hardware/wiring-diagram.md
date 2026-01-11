# Wiring Diagram

This document provides the wiring connections for the ESP32-C6 DevKit to the various components for both the car positioning system and the garage door opener.

**Note:** Always disconnect power before making any wiring changes.

---

## 🚗 Garage Car Positioning System

This system uses two LD2450 radar sensors for positioning and a WS2812B LED strip for visual guidance.

### Connections Table

| ESP32-C6 Pin | Component              | Component Pin | Notes                                           |
| :----------- | :--------------------- | :------------ | :---------------------------------------------- |
| **5V**       | Front LD2450           | VCC           |                                                 |
| **GND**      | Front LD2450           | GND           |                                                 |
| **GPIO16**   | Front LD2450           | TX            | ESP32 RX <- Sensor TX                           |
| **GPIO17**   | Front LD2450           | RX            | ESP32 TX -> Sensor RX                           |
| **5V**       | Rear LD2450            | VCC           |                                                 |
| **GND**      | Rear LD2450            | GND           |                                                 |
| **GPIO18**   | Rear LD2450            | TX            | ESP32 RX <- Sensor TX                           |
| **GPIO19**   | Rear LD2450            | RX            | ESP32 TX -> Sensor RX                           |
| **5V**       | WS2812B LED Strip      | 5V / VCC      | **Important:** For long strips, use a separate 5V power supply. |
| **GND**      | WS2812B LED Strip      | GND           | Share a common ground with the ESP32.           |
| **GPIO0**    | WS2812B LED Strip      | Data In (DIN) |                                                 |

---

## 🚪 Garage Door Opener

This system uses a relay to control the door, a reed switch to detect the closed state, and a custom rotary encoder for position tracking.

### Connections Table

| ESP32-C6 Pin | Component              | Component Pin | Notes                                           |
| :----------- | :--------------------- | :------------ | :---------------------------------------------- |
| **3.3V**     | Relay Module           | VCC           |                                                 |
| **GND**      | Relay Module           | GND           |                                                 |
| **GPIO12**   | Relay Module           | IN / Signal   |                                                 |
| -            | Relay Module           | NO & COM      | Wire these in parallel to your garage opener's wall button terminals. Polarity does not matter. |
| **GND**      | Closed Reed Switch     | Terminal 1    |                                                 |
| **GPIO4**    | Closed Reed Switch     | Terminal 2    | The internal pull-up resistor is used.          |
| **3.3V**     | Hall Effect Sensor A   | VCC           | Rotary Encoder Sensor A                         |
| **GND**      | Hall Effect Sensor A   | GND           |                                                 |
| **GPIO5**    | Hall Effect Sensor A   | OUT / Signal  |                                                 |
| **3.3V**     | Hall Effect Sensor B   | VCC           | Rotary Encoder Sensor B                         |
| **GND**      | Hall Effect Sensor B   | GND           |                                                 |
| **GPIO6**    | Hall Effect Sensor B   | OUT / Signal  |                                                 |