# NJK-5002C Hall Effect Sensor

## Wires

- brown wire connects the GPIO header for the +5V supply.
- blue wire connects the GPIO header for the ground connection.
- black wire connects to pin 8 (or any input of your choice -- configure your software to match.)

## Quadrature Encoder Calculations

This project mounts **6 magnets at 5" from the center of the encoder disk** with **two Hall Effect
sensors** wired in quadrature (Sensor A on GPIO2, Sensor B on GPIO3). The calculations below derive
magnet spacing, sensor placement, and the `garage_door_full_open_counts` firmware value.

### Configuration

| Parameter | Value |
| --- | --- |
| Magnet radius from disk center | 5.000" |
| Number of magnets | 6 |
| Number of sensors | 2 (quadrature) |

### Derived Values

The magnets travel in a circle, so all spacing is measured along the **arc** at the 5" radius:

```txt
Circumference = 2 × π × radius
             = 2 × π × 5"
             = 31.416"

Magnet spacing (arc, center-to-center) = circumference / num_magnets
                                       = 31.416 / 6
                                       = 5.236"

Counts per revolution (quadrature) = num_magnets × 4
                                   = 6 × 4
                                   = 24 counts/rev

Door travel per count = circumference / counts_per_rev
                      = 31.416 / 24
                      = 1.309" per count
```

### Sensor Placement

With quadrature encoding, Sensor B must be offset from Sensor A by **¼ of the magnet spacing**
so that the two sensors are 90° out of phase. This is what enables direction detection.

```txt
Sensor offset = magnet_spacing / 4
              = 5.236" / 4
              = 1.309"  (arc distance between Sensor A and Sensor B)
```

Mount Sensor B **1.309" ahead of Sensor A** along the arc of magnet travel.

### Firmware: `garage_door_full_open_counts`

Measure the actual travel distance of your garage door chain/belt from fully closed to fully open,
then divide by the resolution:

```
garage_door_full_open_counts = door_travel_inches / 1.309
```

| Door travel | `garage_door_full_open_counts` |
| --- | --- |
| 84" (7 ft) | 64 |
| 90" (7.5 ft) | 69 |
| 96" (8 ft) | 73 |

Set this value in `esphome/all-in-one.yaml` under substitutions:

```yaml
substitutions:
  garage_door_full_open_counts: "64"   # adjust to your measured door travel
```

> **Tip**: After flashing, open the door fully and read the raw encoder count from the Home
> Assistant entity `sensor.garage_door_encoder`. Use that observed count as your calibrated value.

### General Formula

To recalculate for a different disk radius or magnet count:

```
circumference        = 2 × π × radius
magnet_spacing       = circumference / num_magnets
sensor_offset        = magnet_spacing / 4
counts_per_rev       = num_magnets × 4
resolution           = circumference / counts_per_rev    (inches per count)
full_open_counts     = door_travel_inches / resolution
```

A helper script is available at [`utility/calc_encoder.py`](../../../utility/calc_encoder.py):

```bash
python3 utility/calc_encoder.py 10   # pass wheel diameter in inches
```

---

## Product Description

- Model: NJK-5002C
- Supply voltage 5-30VDC
- Detection distance 10mm (effective detection distance 0-10mm)
- Load current 150MA (no more than)
- Output form NPN three lines
- Output state normally open (NO)
- Detect objects metal material
- Product Material Metal parts: Copper plastic components: PBT
- External leads 1.2 m (standard, others according to customer requirements)
- Output indication LED (red)
- Factor Diameter: 12MM; Thread length: 12MM; Overall Length: 37MM
- Package Include: 2* NJK-5002C Hall Effect Sensor Proximity Switch NPN 3-Wires Normally Open
