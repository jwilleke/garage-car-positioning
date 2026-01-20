# Wiring Diagrams

This document provides wiring connections for the three different implementation options, all using the ESP32-C6 as the core microcontroller.

**Note:** Always disconnect power before making any wiring changes.

**Important:** GPIO 4, 5, 6, 7 are JTAG pins on ESP32-C6 and cause interrupt instability. Use GPIO 1, 2, 3 (LP pins) instead. See [ESP32-C6 DevKit.md](./ESP32-C6%20DevKit.md) for details.

See [BOM](./hardware/BOM.md)

## Option 1: Standalone Car Positioning System

This diagram shows the wiring for a dedicated car positioning system using an ESP32-C6.

| ESP32-C6 Pin | Component | Component Pin | Notes |
| ---- | ---- | ---- | ---- |
| 5V | Front LD2450 | VCC | |
| GND | Front LD2450 | GND | |
| GPIO16 | Front LD2450 | TX | ESP32 RX <- Sensor TX |
| GPIO17 | Front LD2450 | RX | ESP32 TX -> Sensor RX |
| 5V | Rear LD2450 | VCC | |
| GND | Rear LD2450 | GND | |
| GPIO18 | Rear LD2450 | TX | ESP32 RX <- Sensor TX |
| GPIO19 | Rear LD2450 | RX | ESP32 TX -> Sensor RX |
| 5V | WS2812B LED Strip | 5V / VCC | **Important:** For long strips, use a separate 5V power supply. |
| GND | WS2812B LED Strip | GND | Share a common ground with the ESP32. |
| GPIO0 | WS2812B LED Strip | Data In (DIN) | |

## Option 2: Standalone Garage Door Controller

This diagram shows the wiring for a dedicated garage door controller using an ESP32-C6.

| ESP32-C6 Pin | Component | Component Pin | Notes |
| ---- | ---- | ---- | ---- |
| 5V | Power Distribution | - | Provide 5V to all 5V components. |
| 3.3V | Power Distribution | - | Provide 3.3V to all 3.3V components. |
| GND | Power Distribution | - | Common ground for all components. |
| GPIO10 | Relay Module | IN / Signal | |
| - | Relay Module | NO & COM | Wire in parallel to garage opener's wall button. |
| GPIO1 | Closed Reed Switch | Signal | Use internal pull-up. Connect other leg to GND. |
| GPIO2 | Hall Effect Sensor A | OUT / Signal (black wire) | Rotary Encoder Channel A |
| GPIO3 | Hall Effect Sensor B | OUT / Signal (black wire) | Rotary Encoder Channel B |

## Option 3: Combined All-in-One System

This diagram shows the wiring for a single ESP32-C6 controlling all car positioning and garage door components.

| ESP32-C6 Pin | Component | Component Pin | Notes |
| ---- | ---- | ---- | ---- |
| 5V | Power Distribution | - | Provide 5V to all 5V components. |
| 3.3V | Power Distribution | - | Provide 3.3V to all 3.3V components. |
| GND | Power Distribution | - | Common ground for all components. |
| --- | **Car Positioning** | --- | --- |
| GPIO16 | Front LD2450 | TX | ESP32 RX <- Sensor TX |
| GPIO17 | Front LD2450 | RX | ESP32 TX -> Sensor RX |
| GPIO18 | Rear LD2450 | TX | ESP32 RX <- Sensor TX |
| GPIO19 | Rear LD2450 | RX | ESP32 TX -> Sensor RX |
| GPIO0 | WS2812B LED Strip | Data In (DIN) | **Important:** For long strips, use a separate 5V power supply. |
| --- | **Garage Door Control** | --- | --- |
| GPIO10 | Relay Module | IN / Signal | |
| - | Relay Module | NO & COM | Wire in parallel to garage opener's wall button. |
| GPIO1 | Closed Reed Switch | Signal | Use internal pull-up. Connect other leg to GND. |
| GPIO2 | Hall Effect Sensor A | OUT / Signal | Rotary Encoder Channel A (black wire) |
| GPIO3 | Hall Effect Sensor B | OUT / Signal | Rotary Encoder Channel B (black wire) |

### Components Located Near Garage Door Opener

#### Relay Module

Located near Garage Door opener. Wired to terminals on Garage door opener for NO & COM.

5V Relay Module with High/Low Trigger Jumper - Set jumper to **H** (HIGH trigger).

#### Relay Wiring

| Relay Pin | Connect To |
| ---- | ---- |
| VCC | External 5V (+) |
| GND | External 5V (-) AND ESP32-C6 GND (shared ground) |
| IN | ESP32-C6 GPIO10 |
| Jumper | Set to **H** (HIGH trigger) |
| NO | Garage door opener wall button terminal |
| COM | Garage door opener wall button terminal |

**Important:** The GND must be shared between the ESP32-C6 and the external 5V power supply.

#### Rear LD2450 Sensor - Ceiling Mounted

- 5V Power supply input 5V
- GND Power Ground
- Tx Serial port Tx pins
- Rx Serial port Rx pins

### Components Located Near Garage Door Opening

Seven (seven conductors)

- 5V (brown wire)                                                                                                                                                                                                                                                                                                                                                      │
- GRN (blue wire)
- Reed switch contaact
- Rotary Encoder Channel A
- Rotary Encoder Channel B
- Tx Serial port Tx pins
- Rx Serial port Rx pins

#### Garage Door Opening - Reed switch

- NO
- GRN

### Rotary Encoder Wires

We need 4 wires to the Rotary Encoder(s)

- 5V (brown wire)                                                                                                                                                                                                                                                                                                                                                      │
- GRN (blue wire)
- Rotary Encoder Channel A (black wire)
- Rotary Encoder Channel B (black wire)

### Front LD2450 Sensor - Wall Mounted

| LEFT | RIGHT |
| 5V | RX |
| 3.3V | RX |
| PA9  | DM |
| GND  | OK |
