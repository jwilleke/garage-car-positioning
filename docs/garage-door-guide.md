# Garage Door Controller — Implementation Guide

Standalone implementation path for the garage door controller only. Uses a relay to trigger the opener, a reed switch for closed-state detection, and a custom quadrature encoder (Hall effect sensors + magnets) for door position tracking.

For a combined system that also includes car positioning, see [Installation.md](Installation.md).

---

## Step 1: Bill of Materials

Gather the components listed under **Option 2: Standalone Garage Door Controller** in the Bill of Materials.

➡️ See [hardware/BOM.md — Option 2](hardware/BOM.md#option-2-standalone-garage-door-controller)

> **Note:** The BOM reflects components sourced from the builder's existing inventory. Substitutions are generally viable — any 5V relay module with a High/Low trigger jumper will work, and any NPN Hall effect sensor (e.g., A3144) can substitute for the NJK-5002C. Verify pinouts before wiring.

---

## Step 2: Hardware Assembly

Wire all components according to the **Option 2** wiring diagram.

➡️ See [hardware/wiring-diagram.md — Option 2](hardware/wiring-diagram.md#option-2-standalone-garage-door-controller)

Key connections:
- GPIO10 — Relay module signal (jumper set to **H**)
- GPIO1 — Reed switch (door closed sensor)
- GPIO2 — Hall effect sensor A (encoder)
- GPIO3 — Hall effect sensor B (encoder)

### Relay Wiring

➡️ See [hardware/wiring-diagram.md — Relay Wiring](hardware/wiring-diagram.md#relay-wiring)

Connect relay **NO** and **COM** to the opener's **push button (PB) dry-contact terminals** — the same terminals used by the wall button. Do not wire to the wall console data port.

> **Genie 2022 note:** The default relay pulse of 200ms may be too short to reliably trigger the Genie 2022 PB input. The firmware includes a runtime-configurable **Garage Door - Relay Pulse (ms)** entity (default 500ms). See [GitHub issue #7](https://github.com/jwilleke/garage-car-positioning/issues/7).

### Reed Switch

➡️ See [hardware/door-closed-switch.md](hardware/door-closed-switch.md)

### Rotary Encoder (Hall Effect Sensors)

➡️ See [hardware/NJK-5002C Hall Effect Sensor/quadrature-encoder.md](hardware/NJK-5002C%20Hall%20Effect%20Sensor/quadrature-encoder.md)

Physical magnet and sensor placement determines encoder accuracy.

➡️ See [calibration.md — Rotary Encoder Placement](calibration.md#rotary-encoder-magnet-and-hall-effect-sensor-placement)

---

## Step 3: Power Supply

- **5V 1A minimum** for the standalone door controller
- Share a common ground between the ESP32, relay module, and external 5V supply

➡️ See [Installation.md — Step 4: Power Supply Considerations](Installation.md#step-4-power-supply-considerations)

---

## Step 4: Firmware

Configuration file: `esphome/garage-door.yaml`

```bash
esphome config esphome/garage-door.yaml   # validate
esphome compile esphome/garage-door.yaml  # compile
esphome upload esphome/garage-door.yaml   # flash
```

A `secrets.yaml` is required in `esphome/` — see `esphome/secrets-example.yaml`.

First flash must be via USB. Subsequent updates can be done OTA.

---

## Step 5: Calibration

Calibration sets the encoder count for a fully open door, which is required for accurate position percentage.

➡️ See [calibration.md — Garage Door Controller](calibration.md#garage-door-controller)

Summary:
1. Flash firmware
2. Fully close the door — encoder resets to 0
3. Fully open the door — note the encoder count
4. Set `garage_door_full_open_counts` in `garage-door.yaml` to that value
5. Reflash

---

## Step 6: Home Assistant Integration

After flashing, the device will be auto-discovered by the ESPHome integration.

Navigate to **Settings → Devices & Services** and click **Configure** on the discovered device.

The garage door exposes a **cover** entity for open/close control and position tracking.

➡️ See [Installation.md — Step 7: Home Assistant Integration](Installation.md#step-7-home-assistant-integration)
