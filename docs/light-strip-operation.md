# LED Strip Operation Guide

This document explains how the WS2812B LED strip provides visual feedback to help guide you while parking. The behavior is designed to be intuitive, changing effects based on your car's position relative to the designated "perfect" parking spot.

## Parking Sequence and Effects

- No Vehicle Detected:
  - When the garage is empty (or the system is still acquiring a lock), the LED strip turns off.

- Car Enters Garage (Far from Target):
  - As you first pull in, the system detects your car. The strip shows a **blue scanning animation** moving toward the front of the garage.
  - This signals "keep moving forward."

- Getting Closer (Almost There):
  - As you approach the target zone, the animation changes to a **cyan scanning animation** (slower, narrower).
  - This indicates you are close — continue moving forward slowly and prepare to stop.

- Perfectly Parked:
  - When your car is correctly positioned within the target zone, the strip turns **solid green**.
  - This confirms you've hit the perfect spot. Stop here.

- Overshot or Too Far:
  - If you go past the target in either direction, the strip shows an **orange scanning animation**.
  - This means you need to reverse. The guidance text (visible in the web portal) shows `< Move back` for a small overshoot or `<<< MOVE BACK` for a larger one.

- Person in Danger Zone:
  - If a person is detected in the danger zone while the car is present, the strip immediately switches to a **red flashing alert**, regardless of car position.
  - This overrides all parking guidance until the person clears the zone.

## Summary

The goal is to **follow the effects until the strip turns solid green**.

| Effect | Meaning |
| --- | --- |
| Off | No vehicle detected |
| Blue scan | Move forward (far) |
| Cyan scan | Move forward (close — almost there) |
| Solid green | Parked correctly |
| Orange scan | Move back |
| Red flash | Person in danger zone — stop immediately |

*LED behavior is controlled by the `parking_guidance` text sensor and `person_in_danger_zone` binary sensor in `esphome/all-in-one.yaml`. Thresholds can be adjusted via the substitutions at the top of that file.*
