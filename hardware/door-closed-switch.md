# Gargae Door Closed Switch

This is a magnetic reed door switch mounted at the top (in my case) or bottom of the garage door to indicate the door is closed.

| GPIO4 | Closed Reed Switch | Signal | Use internal pull-up. Connect other leg to GND. |

## My Reed Switch

| No Magnet | Color | Connection |
| ---- | ---- | ---- |
| COM | White | GND |
| NO | Black | NC |
| NC | RED | GPIO4 |

Your reed switch is correctly configured with:

- Wiring: NO (Black) → GPIO4, COM (White) → GND
- Mode: INPUT_PULLUP with inverted: true
- Debounce: 50ms delay on both edges
- Device Class: Door
- Behavior:
  - Magnet NEAR (contacts closed) = "Door CLOSED"
  - Magnet FAR (contacts open) = "Door OPEN"
