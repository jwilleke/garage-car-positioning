# Car Positioning System — Implementation Guide

Standalone implementation path for the car positioning system only. Uses dual LD2450 mmWave radar sensors and a WS2812B LED strip to guide a driver into the correct parking position.

For a combined system that also controls the garage door, see [Installation.md](Installation.md).

---

## Step 1: Bill of Materials

Gather the components listed under **Option 1: Standalone Car Positioning System** in the Bill of Materials.

➡️ See [hardware/BOM.md — Option 1](hardware/BOM.md#option-1-standalone-car-positioning-system)

---

## Step 2: Hardware Assembly

Wire all components according to the **Option 1** wiring diagram.

➡️ See [hardware/wiring-diagram.md — Option 1](hardware/wiring-diagram.md#option-1-standalone-car-positioning-system)

Key connections:
- GPIO16/17 — Front LD2450 (UART)
- GPIO18/19 — Rear LD2450 (UART)
- GPIO0 — WS2812B LED strip data

See [hardware/LD2450/LD2450-Mounting.md](hardware/LD2450/LD2450-Mounting.md) for sensor placement guidance.

---

## Step 3: Power Supply

- **5V 2A minimum** for the standalone car positioning system
- Power the LED strip directly from the 5V supply — do not draw through the ESP32's 5V pin
- Share a common ground across all components

➡️ See [Installation.md — Step 4: Power Supply Considerations](Installation.md#step-4-power-supply-considerations)

---

## Step 4: Firmware

Configuration file: `esphome/car-positioning.yaml`

```bash
esphome config esphome/car-positioning.yaml   # validate
esphome compile esphome/car-positioning.yaml  # compile
esphome upload esphome/car-positioning.yaml   # flash
```

A `secrets.yaml` is required in `esphome/` — see `esphome/secrets-example.yaml`.

First flash must be via USB. Subsequent updates can be done OTA.

---

## Step 5: Sensor Placement

Correct physical placement of the LD2450 sensors is critical for accurate readings.

➡️ See [hardware/LD2450/LD2450-Mounting.md](hardware/LD2450/LD2450-Mounting.md)

Typical placement:
- **Front sensor** — ceiling-mounted above the parking zone, pointing down
- **Rear sensor** — inside wall-mounted, pointing toward the car

---

## Step 6: Calibration

Park your car in the ideal position, observe the sensor values, then update the substitutions in `car-positioning.yaml`.

➡️ See [calibration.md — Car Positioning System](calibration.md#car-positioning-system)

Key substitutions to set:
- `rear_target_y_min` / `rear_target_y_max` — parking depth range from back wall (inches)
- `rear_target_x_tolerance` — acceptable side-to-side deviation (inches)
- `front_target_y_min` / `front_target_y_max` — ceiling-to-car-top range (inches)
- `front_target_x_tolerance` — lateral tolerance from ceiling sensor (inches)

---

## Step 7: Home Assistant Integration

After flashing, the device will be auto-discovered by the ESPHome integration.

Navigate to **Settings → Devices & Services** and click **Configure** on the discovered device.

➡️ See [Installation.md — Step 7: Home Assistant Integration](Installation.md#step-7-home-assistant-integration) for dashboard and automation setup.

---

## LED Behavior

The WS2812B strip provides real-time parking guidance:

➡️ See [light-strip-operation.md](light-strip-operation.md)
