# Calibration Guide

Calibration is a critical step to ensure both the car positioning system and the garage door controller function accurately.

---

## Car Positioning System (`garage-car-sensor.yaml`)

This calibration defines the "perfect" parking spot for the visual LED guide.

- Park Your Car: Position your car in the exact ideal spot in your garage.
- Observe Sensor Values: Go to Home Assistant and find the `sensor.car_center_x_position` and `sensor.car_center_y_position` entities. Note down their current values. Let's say your `y` value is `2050` and your `x` value is `-50`.
- Set Target Values: Open your `garage-car-sensor.yaml` file and update the substitutions:
  - `target_y_min` & `target_y_max`: Create a "safe zone" around your observed `y` value. A 200mm range is a good starting point. For an observed value of `2050`, you could set `target_y_min: "1950"` and `target_y_max: "2150"`.
  - `target_x_tolerance`: Set this to a value that represents acceptable side-to-side deviation. The sensor reports `x` as a deviation from the center, so use the absolute value. For an observed value of `-50`, a tolerance of `300` would be very generous and likely a good starting point.
- Save and Re-flash: Save the changes to your YAML file and flash the firmware to your ESP32-C6 again.

---

## Garage Door Controller (`esp32-garage-door.yaml`)

This calibration tells the system how many rotations are required to fully open the door, which is essential for the position percentage to be accurate.

- Initial Flash: Flash the `esp32-garage-door.yaml` firmware to your ESP32-C6 for the garage door controller.
- Close the Door: Manually run the garage door until it is fully closed. When the door presses the "closed" limit switch, the firmware will automatically reset the encoder's internal count to `0`.
- Open the Door: Now, fully open the door until it stops.
- Observe Encoder Value: Go to Home Assistant and find the `sensor.garage_door_position_encoder` entity. Note its current value. This is the total number of "counts" for a full open operation (e.g., `10250`).
- Set Target Value: Open your `esp32-garage-door.yaml` file and update the substitution:
  - `garage_door_full_open_counts`: Set this to the value you observed in the previous step (e.g., `"10250"`).
- Save and Re-flash: Save the changes and flash the firmware to your ESP32-C6 one last time.

Your garage door controller is now calibrated.
