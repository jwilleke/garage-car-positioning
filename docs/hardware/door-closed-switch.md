# Garage Door Closed Switch

This is a magnetic reed door switch mounted at the top (in my case) or bottom of the garage door to indicate the door is closed.

| GPIO1 | Closed Reed Switch | Signal | Use internal pull-up. Connect other leg to GND. |

**Note:** Changed from GPIO4 (JTAG MTMS) to GPIO1 (stable LP pin) to avoid JTAG interference. See `docs/hardware/ESP32-C6 DevKit.md` for details.

## My Reed Switch

| No Magnet | Color | Connection |
| ---- | ---- | ---- |
| COM | White | GND |
| NO | Black | NC |
| NC | RED | GPIO1 |

Your reed switch is correctly configured with:

- Wiring: NO (Black) → GPIO1, COM (White) → GND
- Mode: INPUT_PULLUP with inverted: true
- Debounce: 50ms delay on both edges
- Device Class: Door
- Behavior:
  - Magnet NEAR (contacts closed) = "Door CLOSED"
  - Magnet FAR (contacts open) = "Door OPEN"
