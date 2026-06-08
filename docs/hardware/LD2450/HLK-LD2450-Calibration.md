# HLK-LD2450 Sensor Calibration

This guide covers calibrating both LD2450 sensors after they are physically mounted and the firmware is flashed. Calibration sets the target parking zone so the system knows when the car is correctly parked.

## Prerequisites

- Sensors mounted in final positions (front sensor on garage-door wall, rear sensor on ceiling)
- Firmware flashed and device online in Home Assistant or ESPHome web server
- Car you intend to park available for the session

## Coordinate Axes by Sensor

Understanding the axes is essential before reading any values.

### Front Sensor (`ld2450_front`) — Wall-mounted, garage-door wall

| Axis | Meaning | Direction |
| ---- | ---- | ---- |
| Y | Distance from front wall into garage | Increases as car pulls further in |
| X | Lateral offset from sensor centerline | Positive/negative — verify by testing |
| Distance | Direct line-of-sight to target | Combined X/Y |

### Rear Sensor (`ld2450_rear`) — Ceiling-mounted above car

| Axis | Meaning | Direction |
| ---- | ---- | ---- |
| Y | Vertical distance from ceiling to car top | Increases as car is further below sensor |
| X | Lateral offset from sensor centerline | Positive/negative — verify by testing |
| Distance | Direct line-of-sight to target | Combined X/Y |

## Calibration Steps

### Step 1 — Park the Car in the Ideal Position

Drive the car to exactly where you want it to sit when correctly parked. This is the reference position for all calibration values.

Leave the car there for the rest of this procedure.

### Step 2 — Read Front Sensor Values

In Home Assistant or the ESPHome web server, observe:

- **Car Position - Front T1 Y** — distance from the front wall into the garage (inches)
- **Car Position - Front T1 X** — lateral offset from front sensor centerline (inches)

Write these down. Example: Y = `24.5`, X = `1.2`

### Step 3 — Set Front Sensor Substitutions

Open `esphome/all-in-one.yaml` and update:

```yaml
# ±6 inches around the observed Y value is a good starting range
front_target_y_min: "18.5"    # observed Y minus 6
front_target_y_max: "30.5"    # observed Y plus 6

# Set to ~1.5× the absolute value of observed X, minimum 4 inches
front_target_x_tolerance: "7.9"
```

The X tolerance controls how far left or right of center the car can be and still be considered parked. Start generous (8–12 in) and tighten after verifying detection works.

### Step 4 — Read Rear Sensor Values

Observe:

- **Car Position - Rear T1 Y** — vertical distance from ceiling to car top (inches)
- **Car Position - Rear T1 X** — lateral offset from rear sensor centerline (inches)

Write these down. Example: Y = `42.0`, X = `-0.8`

If the rear sensor Y value looks unexpectedly large (>60 in), confirm the sensor is aimed straight down and is detecting the car roof, not the floor through the windows.

### Step 5 — Set Rear Sensor Substitutions

```yaml
# ±6 inches around the observed Y value is a good starting range
rear_target_y_min: "36.0"    # observed Y minus 6
rear_target_y_max: "48.0"    # observed Y plus 6

# Set to ~1.5× the absolute value of observed X, minimum 4 inches
rear_target_x_tolerance: "11.8"
```

### Step 6 — Flash and Verify

Save `all-in-one.yaml` and flash:

```bash
esphome run esphome/all-in-one.yaml
```

With the car in the calibrated position:

- **Car Position - Vehicle Detected** should read `ON`
- **Car Position - Correctly Parked** should read `ON`
- **Car Position - Parking Guidance** should read `PARKED`
- LED strip should show green

Then drive the car out completely and confirm:

- **Car Position - Vehicle Detected** flips to `OFF`
- LED strip turns off

### Step 7 — Test the Guidance Range

Drive back in slowly and watch **Car Position - Parking Guidance**. You should see the sequence:

```
MOVE FORWARD >>>   (car not yet in zone)
Move forward >     (car approaching zone)
Almost there...    (car near zone edge)
PARKED             (car in zone)
```

If the transition happens too early or too late, adjust `front_target_y_min`/`max` accordingly and reflash.

## Fine-Tuning

| Symptom | Adjustment |
| ---- | ---- |
| "PARKED" triggers too early (car not far enough in) | Increase `front_target_y_min` |
| "PARKED" triggers too late (car too far in) | Decrease `front_target_y_max` |
| Car never reads "Correctly Parked" despite being in position | Widen the Y range or increase X tolerance |
| Car shows "Correctly Parked" when parked crooked | Decrease `front_target_x_tolerance` |
| Rear sensor never validates (front validates, rear does not) | Check `rear_target_y_min`/`max` — re-read rear T1 Y values and recalibrate |

## Person Detection Calibration

Two substitutions control safety alerts:

```yaml
person_max_distance: "59.1"    # inches — targets closer than this may be people (not cars)
danger_zone_distance: "118.1"  # inches — people within this range of sensor trigger danger alert
```

### `person_max_distance`

Determines whether a detected target is a person vs. a car. The car (Target 1) is typically much further from the sensor than a person standing nearby. Set this to a distance clearly smaller than the car's typical sensor reading but large enough to catch a person in the space.

To calibrate: have someone stand in the garage (car absent) and note **Car Position - Front T1 Distance** or **Rear T1 Distance**. Set `person_max_distance` to ~10 inches above that reading.

### `danger_zone_distance`

How close a person (Target 2) must be to a sensor to trigger the **Person in Danger Zone** alert while the car is present. This defines the active safety perimeter around the moving car.

A value of 118 in (~3 m) covers the area immediately around a typical car. Increase if your garage is narrow and you want wider coverage; decrease to reduce false triggers from people in adjacent areas.

## Troubleshooting

### Sensor reads zero or NaN

- Check UART wiring (TX/RX are crossed between sensor and ESP32)
- Confirm baud rate is 256000 in both firmware and sensor (use HLKRadarTool app to verify)
- Confirm sensor firmware ≥ V2.02.23090617

### Front sensor reads the garage door when it opens

- The front wall sensor may be too close to the door opening
- Add a zone filter: note the Y value when the door is open and set `front_target_y_min` above that value

### Rear sensor reads floor instead of car top

- Sensor is likely aimed through a sunroof or open windows
- Angle the sensor slightly toward the solid roof panel of the car

### Values are noisy or jumping

- Check sensor mounting is rigid — vibration degrades accuracy
- Ensure no large metal objects (shelving, tools) are in the detection cone
- Confirm no other 24 GHz sources nearby
