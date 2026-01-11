# Wiring Diagrams

This document provides wiring connections for the three different implementation options outlined in the Bill of Materials. Choose the diagram that matches your chosen build.

**Note:** Always disconnect power before making any wiring changes.

---

## Option 1: Standalone Car Positioning System

This diagram shows the wiring for a dedicated car positioning system using the ESP32-C6.

| ESP32-C6 Pin | Component           | Component Pin | Notes                                                       |
| :----------- | :------------------ | :------------ | :---------------------------------------------------------- |
| **5V**       | Front LD2450        | VCC           |                                                             |
| **GND**      | Front LD2450        | GND           |                                                             |
| **GPIO16**   | Front LD2450        | TX            | ESP32 RX <- Sensor TX                                       |
| **GPIO17**   | Front LD2450        | RX            | ESP32 TX -> Sensor RX                                       |
| **5V**       | Rear LD2450         | VCC           |                                                             |
| **GND**      | Rear LD2450         | GND           |                                                             |
| **GPIO18**   | Rear LD2450         | TX            | ESP32 RX <- Sensor TX                                       |
| **GPIO19**   | Rear LD2450         | RX            | ESP32 TX -> Sensor RX                                       |
| **5V**       | WS2812B LED Strip   | 5V / VCC      | **Important:** For long strips, use a separate 5V power supply. |
| **GND**      | WS2812B LED Strip   | GND           | Share a common ground with the ESP32.                       |
| **GPIO0**    | WS2812B LED Strip   | Data In (DIN) |                                                             |

---

## Option 2: Standalone Garage Door Controller

This diagram shows the wiring for a dedicated garage door controller using the Shelly Plus 1.

| Shelly Plus 1 Pin  | Component            | Component Pin | Notes                                                                                                    |
| :----------------- | :------------------- | :------------ | :------------------------------------------------------------------------------------------------------- |
| **L & N**          | Mains Power          | Live & Neutral| Power the Shelly itself (e.g., 120V AC or 24-30V DC).                                                    |
| **I & O**          | Garage Opener        | Wall Button   | Connect these "dry contact" terminals in parallel with your opener's wall button. Polarity does not matter. |
| **SW**             | Closed Reed Switch   | Terminal 1    | The other terminal of the reed switch connects to Shelly's 'L' (Live) terminal.                          |
| **GND** (Header)   | Hall Effect Sensor A | GND           | Common ground for both sensors.                                                                          |
| **3.3V** (Header)  | Hall Effect Sensor A | VCC           | Common 3.3V power for both sensors.                                                                      |
| **GPIO25** (Header)| Hall Effect Sensor A | OUT / Signal  | Rotary Encoder Channel A                                                                                 |
| **GND** (Header)   | Hall Effect Sensor B | GND           |                                                                                                          |
| **3.3V** (Header)  | Hall Effect Sensor B | VCC           |                                                                                                          |
| **GPIO26** (Header)| Hall Effect Sensor B | OUT / Signal  | Rotary Encoder Channel B                                                                                 |

---

## Option 3: Combined All-in-One System

This diagram shows the wiring for a single ESP32-C6 controlling all car positioning and garage door components.
***Note:** This wiring corresponds to the initial, pre-refactoring ESPHome configuration. The current repository uses the two-device setup from Options 1 & 2.*

| ESP32-C6 Pin | Component              | Component Pin | Notes                                                       |
| :----------- | :--------------------- | :------------ | :---------------------------------------------------------- |
| **5V**       | Power Distribution     | -             | Provide 5V to all 5V components.                            |
| **3.3V**     | Power Distribution     | -             | Provide 3.3V to all 3.3V components.                        |
| **GND**      | Power Distribution     | -             | Common ground for all components.                           |
| ---          | **Car Positioning**    | ---           | ---                                                         |
| **GPIO16**   | Front LD2450           | TX            |                                                             |
| **GPIO17**   | Front LD2450           | RX            |                                                             |
| **GPIO18**   | Rear LD2450            | TX            |                                                             |
| **GPIO19**   | Rear LD2450            | RX            |                                                             |
| **GPIO0**    | WS2812B LED Strip      | Data In (DIN) |                                                             |
| ---          | **Garage Door Control**| ---           | ---                                                         |
| **GPIO12**   | Relay Module           | IN / Signal   |                                                             |
| -            | Relay Module           | NO & COM      | Wire in parallel to garage opener's wall button.            |
| **GPIO4**    | Closed Reed Switch     | Signal        | Use internal pull-up. Connect other leg to GND.             |
| **GPIO5**    | Hall Effect Sensor A   | OUT / Signal  | Rotary Encoder Channel A                                    |
| **GPIO6**    | Hall Effect Sensor B   | OUT / Signal  | Rotary Encoder Channel B                                    |