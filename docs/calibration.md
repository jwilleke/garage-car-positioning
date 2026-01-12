# Calibration Guide

Calibration is a critical step to ensure both the car positioning system and the garage door controller function accurately.

## Car Positioning System ([garage-car-sensor.yaml](../esphome/garage-car-sensor.yaml))

This calibration defines the "perfect" parking spot for the visual LED guide.

* Park Your Car: Position your car in the exact ideal spot in your garage.
* Observe Sensor Values: Go to Home Assistant and find the `sensor.car_center_x_position` and `sensor.car_center_y_position` entities. Note down their current values. Let's say your `y` value is `2050` and your `x` value is `-50`.
* Set Target Values: Open your [garage-car-sensor.yaml](../esphome/garage-car-sensor.yaml) file and update the substitutions:
  * `target_y_min` & `target_y_max`: Create a "safe zone" around your observed `y` value. A 200mm range is a good starting point. For an observed value of `2050`, you could set `target_y_min: "1950"` and `target_y_max: "2150"`.
  * `target_x_tolerance`: Set this to a value that represents acceptable side-to-side deviation. The sensor reports `x` as a deviation from the center, so use the absolute value. For an observed value of `-50`, a tolerance of `300` would be very generous and likely a good starting point.
* Save and Re-flash: Save the changes to your YAML file and flash the firmware to your ESP32-C6 again.

## Garage Door Controller ([esp32-garage-door.yaml](../esphome/esp32-garage-door.yaml))

This calibration tells the system how many rotations are required to fully open the door, which is essential for the position percentage to be accurate.

* Initial Flash: Flash the [esp32-garage-door.yaml](../esphome/esp32-garage-door.yaml) firmware to your ESP32-C6 for the garage door controller.
* Close the Door: Manually run the garage door until it is fully closed. When the door presses the "closed" limit switch, the firmware will automatically reset the encoder's internal count to `0`.
* Open the Door: Now, fully open the door until it stops.
* Observe Encoder Value: Go to Home Assistant and find the `sensor.garage_door_position_encoder` entity. Note its current value. This is the total number of "counts" for a full open operation (e.g., `10250`).
* Set Target Value: Open your [esp32-garage-door.yaml](../esphome/esp32-garage-door.yaml) file and update the substitution:
  * `garage_door_full_open_counts`: Set this to the value you observed in the previous step (e.g., `"10250"`).
* Save and Re-flash: Save the changes and flash the firmware to your ESP32-C6 one last time.

Your garage door controller is now calibrated.

## Rotary Encoder: Magnet and Hall Effect Sensor Placement

Accurate physical placement of the magnets and Hall Effect sensors is crucial for reliable rotary encoder operation. This section provides guidance on how to achieve this.

### Understanding the Rotary Encoder Principle (Quadrature Encoding)

Your setup uses two Hall Effect sensors (`pin_a` and `pin_b`) to create a "quadrature encoder." This means:

* Direction Detection - By observing which sensor triggers first as the magnets pass, the ESP32 can determine if the door is opening or closing.
* Increased Resolution - The system can often detect four "edges" (two rising, two falling) per magnet pair passing the sensors, effectively multiplying your magnet count for finer tracking.

### Steps for Magnet and Sensor Placement

#### Step 1 Determine Resolution (Number of Magnets)

* Decide how many magnets you want to use. More magnets mean more "counts" per rotation of the torsion bar, leading to a more precise measurement of the door's position.
* A common starting point is 4, 8, or 16 small, strong neodymium magnets.
* Consider the circumference of the drum/sprocket you're attaching them to. Don't put too many magnets if they are too large to be distinct.

#### Step 2 Prepare the Mounting Surface (Torsion Bar Drum/Sprocket)

* You'll attach the magnets to a rotating part connected to the torsion bar. This could be an existing sprocket, a custom 3D-printed wheel, or directly on the drum.
* Ensure the surface is clean and provides good adhesion for the magnets.

#### Step 3 Evenly Space and Mount the Magnets

* This is **critical** for accurate readings. Divide the circumference of your chosen mounting surface by the number of magnets to get the precise spacing between the center of each magnet.
* Use a ruler or compass to mark these positions accurately around the entire circle.
* Attach the magnets firmly (e.g., with strong adhesive like epoxy or super glue, or press-fitting if using a 3D-printed part). Ensure they all have the same polarity facing outwards (e.g., all North poles pointing towards where the sensors will be).

#### Step 4 Mount the Hall Effect Sensors

* You need a rigid mounting bracket to hold the two Hall Effect sensors (`pin_a` and `pin_b`) in a fixed position. This bracket should be very close to the path of the rotating magnets, but not touching them.
* **Achieving Quadrature:** The two Hall sensors need to be offset from each other so that their signals are approximately **90 degrees out of phase** as the magnets pass.
  * If `N` is your total number of magnets, the angular distance between magnets is `360/N` degrees.
  * The ideal angular offset between your two Hall sensors is roughly `(360/N) / 4` degrees.
  * **Practical Approach:** Mount the first sensor so it reliably detects the magnets. Then, mount the second sensor next to it, with a slight physical offset. You'll likely need to experiment by rotating the torsion bar slowly and observing the sensor outputs (e.g., via ESPHome logs or a multimeter) until you achieve the desired phase shift. The goal is that when one sensor is just about to trigger or just triggered, the other is at its midpoint.

#### Step 5 Test and Verify

* Once everything is physically mounted, flash your ESP32-C6 with the `esp32-garage-door.yaml` firmware.
* Carefully open and close the garage door manually.
* Monitor the `sensor.garage_door_position_encoder` entity in Home Assistant (or directly in ESPHome's logs).
* The `garage_door_position_encoder` value should increase smoothly when opening and decrease smoothly when closing. If the counts are erratic, jump around, or don't register, you may need to adjust the spacing or proximity of your Hall sensors. They need to be close enough to detect the magnetic field reliably, but not so close that they are always saturated.
* Once you have smooth, reliable counts, proceed with the software calibration steps outlined in this document (under "Garage Door Controller") to set your `garage_door_full_open_counts`.
