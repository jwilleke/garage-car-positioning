# LD2450 Mounting

The HLK-LD2450 (also known as Hi-Link LD2450) is a 24GHz mmWave radar sensor commonly used in home automation setups, especially with ESPHome and Home Assistant, for presence detection, motion tracking, and up to 3 simultaneous human targets with position (x/y coordinates), distance, angle, and speed data.

## Official Mounting Recommendations

From the HLK-LD2450 instruction manual:

- Primary method: Wall mounting (typical and recommended for optimal performance).
- Installation height: 1.5–2 meters (about chest to head height for most adults; 1.5 m is frequently cited in examples).
- Detection range: Up to 6 meters forward, with azimuth angle ±60° (120° total horizontal field) and pitch angle ±35° (70° total vertical field).
- Orientation: Mount with the antenna plane facing the target area (the radar's "front" toward the room). The module should be aligned vertically, with the white connector/pin side typically upward or per the diagram in the manual, and the copper/antenna side facing outward into the room (not toward the wall).
- Detection pattern: Roughly pear/oval-shaped forward from the sensor, best for horizontal coverage when wall-mounted at the recommended height.
- Ceiling mounting is possible but performs worse (often limited to ~2 m range instead of 6 m) due to the radar's forward-directed pattern and reduced effectiveness for tracking at downward angles.

## Practical Tips for Home Automation

- Position: Place in a corner or on a wall facing the main activity area (e.g., living room, office, hallway) for maximum coverage. Avoid obstructions in front; ensure a clear line of sight.
- Avoid interference:
  - No large metallic/reflective objects in the detection zone.
  - No continuous non-human motion (fans, swinging curtains, pets in some cases, air vents, large plants).
  - Shield the back of the sensor (e.g., with metal plate) if there's movement behind the wall, as mmWave can penetrate somewhat.
  - Keep away from WiFi antennas or other high-frequency sources.
  - Firm, stable mounting — vibration affects accuracy.

## Mounting Enclosure

Use plastic/non-metallic cases with good 24GHz transmission (many 3D-printed cases exist on Printables/MakerWorld for ESP32 + LD2450 combos). Avoid metal enclosures.

- Angle adjustment: Some DIY mounts use ball joints for fine-tuning tilt/angle. In ESPHome, you can apply coordinate rotation if the physical orientation is off.
- Testing: Use the official HLKRadarTool mobile app (via Bluetooth) to visualize real-time targets, zones, and coverage during placement.
- Define up to 3 zones in the app or via ESPHome templates for automations (e.g., presence in specific area only).
- Common DIY setup: Pair with ESP32 board (e.g., via UART), flash ESPHome firmware. Many community guides show snap-together or 3D-printed cases at ~1.2–1.8 m height for reliable room coverage.

For full details, refer to the official [HLK-LD2450 manual](LD2450%20serial%20port%20communication%20protocol%20V1.03.pdf) (available in Google Drive folders linked from ESPHome docs or Hi-Link site).

ESPHome has native support for the sensor (requires firmware V2.02.23090617 or later on the LD2450). Wall-mount at 1.5–2 m height, antenna facing the room, for best results in typical indoor home automation use.

### LD2450 enclosure Veenting

The LD2450 module has very low power consumption (average ~120 mA at 5V, roughly 0.6 W) and a wide operating temperature range of -40°C to +85°C. It generates minimal heat on its own.

In typical home automation setups (paired with an ESP32/ESP32-C3 via ESPHome):

- Many 3D-printed or plastic enclosures are fully sealed or minimally vented, and users report no overheating issues from the radar module.
- The ESP32 board is the primary heat source (often reaching 70–80°C under load, especially with Wi-Fi active), not the LD2450.
- Community designs (e.g., on Printables, MakerWorld, Reddit, Home Assistant forums) frequently use closed cases without vents, or add optional slots/holes mainly for the ESP32's benefit — such as improving airflow if the ESP reports high temperatures or for added sensors like temp/humidity that need air exchange.
- Some printed cases explicitly include ventilation options (e.g., holes, full-height slots) as a precaution for the MCU, but not as a requirement for the LD2450.

#### Key facts

- Official HLK docs specify no venting requirement; the module tolerates enclosed operation within its temp limits.
- Enclosures must use RF-transparent materials (plastic, not metal) in front of the antenna, but airflow is secondary.
- If your setup includes the ESP32 and you monitor its temperature via ESPHome (e.g., `temperatureRead()`), add small vents/slots only if it consistently exceeds ~70–80°C in your environment.

In short

- Standard sealed plastic/3D-printed enclosures work fine without venting for reliable long-term use in home automation. 
- Vents are optional and mainly help if heat from the ESP32 becomes noticeable.
