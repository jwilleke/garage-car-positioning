# LED Strip Operation Guide

This document explains how the WS2812B LED strip provides visual feedback to help guide you while parking. The behavior is designed to be intuitive, changing colors based on your car's position relative to the designated "perfect" parking spot.

## Parking Sequence and Colors

- No Car Detected:
  - When the garage is empty, the LED strip will be off.

- Car Enters Garage (Far from Target):
  - As you first pull in, the system will detect your car. The strip will turn solid Blue.
  - This color signals you to "keep moving forward".

- Getting Closer (Approach Zone):
  - As you move closer to the target, the color will change to Cyan.
  - This indicates you are in the "approach zone" and should continue moving forward slowly and prepare to stop.

- Perfectly Parked:
  - When your car is positioned correctly within the target zone, the strip will turn solid Green.
  - This is your confirmation that you've hit the perfect spot.

- Overshot the Target:
  - If you go a little too far, the light will change to Yellow.
  - This means you've passed the target and should reverse a small amount.

- Gone Way Too Far:
  - If you continue to go too far past the target, the strip will turn Orange/Red.
  - This indicates you are now much too far and need to reverse to correct your position.

## Summary

In short, the goal is to simply **follow the colors until the light turns solid green**.

*This behavior is controlled by the `lambda` code within the `light:` component of the `esphome/garage-car-sensor.yaml` file. The colors and distance thresholds can be fine-tuned there if you wish.*
