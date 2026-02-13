# Quadrature Encoder

This guide covers a Quadrature Encoder setup using Hall Effect sensors. Think of it like two people standing on a track watching runners (the magnets) go by. If person A sees the runner first, the runner is going one way; if person B sees them first, they are going the other.

Here is a breakdown of how to get the physical placement just right.

## 1. The Magnet Layout (The "Runners")

To get a smooth reading, your magnets must be spaced perfectly. If one gap is larger than the others, your garage door "position" will appear to jump or stutter.

* Polarity: Ensure the same side of every magnet (e.g., all North poles) faces the sensors.
* Spacing: Use a template. If you have 8 magnets, they must be exactly 45° apart.

## 2. Sensor Placement (The "Quadrature" Secret)

This is the most technical part. For the ESP32 to know the direction, the two sensors cannot trigger at the exact same time. They need to be "out of phase."

* The 90° Rule: Ideally, when Magnet #1 is directly in front of Sensor A, Sensor B should be exactly halfway between Magnet #1 and Magnet #2.
* Physical Gap: If your magnets are 2 inches apart, place Sensor B about 0.5 inches (1/4 of the distance) away from Sensor A.

## 3. Visualizing the Signal

When placed correctly, the electrical signals look like overlapping square waves. This is what the ESP32 "sees":

| State | Sensor A | Sensor B | Action |
| --- | --- | --- | --- |
| 1 | High | Low | Door is moving |
| 2 | High | High | Door is moving |
| 3 | Low | High | Door is moving |
| 4 | Low | Low | Cycle repeats |

> Pro-Tip: If the door counts *up* when it's actually closing, you don't need to move the sensors! Just swap `pin_a` and `pin_b` in your YAML configuration.

## 4. Installation Checklist

* Air Gap: Keep the sensors 2mm to 5mm away from the magnets. Too far and they miss pulses; too close and they might collide.
* Rigidity: Use a solid bracket. If the sensors vibrate or flex, you will get "ghost" counts.
* De-bounce: In your ESPHome code, ensure you have a small `internal_filter` (e.g., `10ms`) to ignore electrical noise.

## Soem caclulations

So if I have a

* wheel (Garage door drum) of 5"
* How many magnets 1/2" diameter magnets would I need?
* How far apart are the magnets on the wheel?

### How far apart are the Sensor?

For a 5" diameter drum, you are working with a circumference of approximately 15.7 inches. Designing the layout involves balancing resolution (how precisely you want to track the door) with the physical size of your sensors and magnets.
Here is the math and the recommended setup for your specific hardware.

* How many magnets do you need? For a garage door, you don't need extreme precision (like a CNC machine), but you want enough to detect a few inches of movement reliably.
* Recommended: 8 to 12 magnets.
  * 8 magnets: Gives you 32 "pulses" per rotation (in quadrature). Each pulse represents about 0.5 inches of door travel.
  * 12 magnets: Gives you 48 pulses per rotation. Each pulse represents about 0.3 inches of travel.

Why not more? With 1/2" diameter magnets, if you put too many (e.g., 20+), the magnetic fields will overlap too much, and the Hall sensor won't be able to tell where one magnet ends and the next begins.

How far apart are the magnets?

To find the center-to-center distance for mounting, use this formula:
Spacing=π×Diameter / Number of Magnets
​
Number of Magnets Center-to-Center Spacing (Approx.)

* 8 magnets 1.96 inches (~50mm)
* 10 magnets 1.57 inches (~40mm)
* 12 magnets 1.31 inches (~33mm)

## Script to Calculate

See [utility/calc_encoder.py](../utility/calc_encoder.py)

>All dimension are in inches.

Script assumes 1/2" reolution.

Willouput something like

```bash
python3 calc_encoder.py 5.0

--- Results for 5.0" Wheel ---
🧲 Magnets Needed:     8
📏 Magnet Spacing:    1.963" (center-to-center)
📡 Sensor Offset:     0.491" (dist. between Sensor A & B)
🎯 Door Resolution:   0.491" per count
```

## Spacing for Magnets

Angular spacing: 360° ÷ 6 = 60° apart

Hole Positions (from disk center)
┌──────┬───────┬────────┬────────┐
│ Hole │ Angle │ X (mm) │ Y (mm) │
├──────┼───────┼────────┼────────┤
│ 1│ 0°│ +63.5│ 0│
├──────┼───────┼────────┼────────┤
│ 2│ 60° │ +31.75 │ +55.0│
├──────┼───────┼────────┼────────┤
│ 3│ 120°│ -31.75 │ +55.0│
├──────┼───────┼────────┼────────┤
│ 4│ 180°│ -63.5│ 0│
├──────┼───────┼────────┼────────┤
│ 5│ 240°│ -31.75 │ -55.0│
├──────┼───────┼────────┼────────┤
│ 6│ 300°│ +31.75 │ -55.0│
└──────┴───────┴────────┴────────┘
Easy Layout Method (no protractor needed)

For a 6-hole pattern, there's a nice shortcut: the chord length between adjacent holes equals the radius.

1. Find and mark the center
2. Set a compass to 63.5mm (2.5") and draw a circle
3. Set dividers to 63.5mm (same as the radius)
4. Pick any starting point on the circle
5. "Walk" the dividers around the circle — it will land exactly on all 6 hole positions

Drill Size

* Drill holes at 12.334mm for a press fit, or
* 12.5mm / ½" for a slip fit (easier assembly, backing plate holds them in)

Edge Clearance Check

Disk radius (75.2mm) − hole center (63.5mm) − magnet radius (6.2mm) = 5.5mm clearance to edge
