# Component Placement Diagrams

This document illustrates the recommended placement for the major components in a typical garage.

## Car Positioning System

This setup uses two mmWave radar sensors to detect the car's position and an LED strip to provide visual feedback.

```
      +-----------------------------------------------------------------+
      |                                                                 |
      |                      GARAGE (Top-Down View)                     |
      |                                                                 |
      |             (Rear LD2450 Sensor - Ceiling Mounted)              |
      |                                                                 |
      |    +---------------------------------------------------------+  |
      |    |                       Car Here                          |  |
      |    +---------------------------------------------------------+  |
      |                                                                 |
      |                  ^                                ^             |
      |                  |                                |             |
      |                  |                     (LED Strip - Ceiling)    |
      |                  |                                              |
      |             (Front LD2450 Sensor - Wall Mounted)                |
      |                                                                 |
      +=================================================================+
                        (Garage Door Opening)
                   Rotary Encoder (on torsion bar)
```

**Placement Details:**

* Front LD2450 Sensor: Mounted on the front wall of the garage, *closest to the garage door opening*, facing the car. This sensor tracks the front of the car.
* Rear LD2450 Sensor: Mounted on the ceiling, positioned to get a clear view of the back of the car (e.g., trunk or bumper), *further away from the garage door*.
* WS2812B LED Strip: Mounted on the ceiling, running parallel to the car's parking position. This provides the driver with a clear visual guide.
* ESP32-C6: Can be co-located with either of the sensors or placed in a central location.

## Garage Door Controller

This setup focuses on controlling and monitoring the garage door's status.

```
+--------------------------------------------------+
|               Garage Door Opener Motor           |
|                                                  |
|   +----------------+                             |
|   |  Relay Module  |-----------------------------+-----> To wall button terminals
|   +----------------+                             |
|                                                  |
+--------------------------------------------------+
      ^
      |
      |
+-----+--------------------------------------------+
|     |           Garage Door (Side View)          |
|     |                                            |
|     +--> Rotary Encoders (on torsion bar)        |
|     |                                            |
|     |                                            |
|     +--> Closed Reed Switch (on track)           |
|                                                  |
+--------------------------------------------------+

```

**Placement Details:**

* Relay Module: Wired in parallel with your existing garage door wall button. It can be housed in a small enclosure near the garage door opener unit.
* Closed Reed Switch: Attached to the garage door track, with the magnet on the door itself. It should be positioned so the switch is triggered only when the door is fully closed.
* Rotary Encoder (Hall Effect Sensors & Magnets): This is a DIY component. The magnets are attached to the rotating torsion bar of the garage door, and the Hall effect sensors are mounted in a fixed position to read the magnets as they pass by. This measures the door's rotation and, by extension, its open/closed position.
* ESP32-C6: Typically located near the garage door opener to easily connect to the relay and encoder.

## All-in-One System

This diagram combines both systems, showing how a single ESP32-C6 can manage all components.

```
      +-----------------------------------------------------------------+
      |                                                                 |
      |                      GARAGE (Top-Down View)                       |
      |                                                                 |
      |    +--------------------------+                                 |
      |    | Garage Door Opener Motor |                                 |
      |    |  - Relay Module          |                                 |
      |    |  - Rotary Encoder        |                                 |
      |    |  - ESP32-C6              |                                 |
      |    +--------------------------+                                 |
      |                                                                 |
      |             (Rear LD2450 Sensor - Ceiling Mounted)              |
      |                                                                 |
      |    +---------------------------------------------------------+  |
      |    |                       Car Here                          |  |
      |    +---------------------------------------------------------+  |
      |                                                                 |
      |                  ^                                ^             |
      |                  |                                |             |
      |                                        (LED Strip - Ceiling)    |
      |                                                                 |
      |             (Front LD2450 Sensor - Wall Mounted)                |
      |                                                                 |
      +=================================================================+
                   (Garage Door Opening - Reed switch on track)
```

**Placement Details:**

* ESP32-C6: A single ESP32-C6 controls everything. It's often most practical to place it in a central enclosure near the garage door opener, as this provides easy access to power and is a good central point for wiring to the various sensors and modules.
* Car Positioning Components:
  * Front LD2450 Sensor: On the front wall, *closest to the garage door opening*.
  * Rear LD2450 Sensor: On the ceiling above the rear of the car, *further away from the garage door*.
  * WS2812B LED Strip: On the ceiling, parallel to the car.
* Garage Door Components:
  * Relay Module: Near the garage door opener.
  * Rotary Encoder: On the torsion bar, typically at the Garage door opening.
  * Closed Reed Switch: On the garage door track, positioned to detect a fully closed door.
