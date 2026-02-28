# Project Log

AI agent session tracking. See [CHANGELOG.md](../CHANGELOG.md) for version history.

## Format

```
## yyyy-MM-dd-##

- Agent: [Claude/Gemini/Other]
- Subject: [Brief description]
- Key Decision: [decision]
- Current Issue: [issue]
- Testing:
  - npm test: 58 suites passed, 1380 tests passed
- Work Done:
  - [task 1]
  - [task 2]
- Commits: [hash]
- Files Modified:
  - [file1.js]
  - [file2.md]
```

---

## 2026-02-28-01

- Agent: Claude Sonnet 4.6
- Subject: Dual-sensor coordinate mismatch fix; Hall Effect sensor docs; GitHub issues
- Key Decision: Front sensor (ceiling-mounted) and rear sensor (wall-mounted) have incompatible Y axes — cannot be averaged. Split into per-sensor substitutions; use rear Y for parking depth guidance.
- Current Issue: None — placeholder calibration values in substitutions; must be measured on hardware before deployment
- Testing:
  - No firmware upload this session — config validation recommended before flash
- Work Done:
  - Created GitHub issue #3: Thread & Matter protocol support discussion (ESP32-C6)
  - Added Quadrature Encoder Calculations section to docs/hardware/NJK-5002C Hall Effect Sensor/NJK-5002C Hall Effect Sensor.md (6 magnets at 5" radius, two sensors, derived spacing/offset/counts/resolution, firmware lookup table, general formula)
  - Fixed dual-sensor coordinate system mismatch in all car positioning configs:
    - Replaced single `target_y_min/max/x_tolerance` with per-sensor `front_target_*` and `rear_target_*` substitutions in all-in-one.yaml and garage-car-sensor.yaml
    - Updated `car_center_y` to return rear sensor Y (wall = depth into garage) instead of averaged Y
    - Added `car_center_x` sensor (was missing from all-in-one.yaml) returning front sensor X (ceiling = lateral offset)
    - Updated `car_correctly_parked` to check each sensor against its own coordinate zone independently
    - Updated `parking_guidance` text sensor and LED effect to use rear sensor Y for move-forward/back direction
    - Updated packages/car-sensor.yaml with identical fixes + updated header comment documenting sensor mounting and axes
    - Updated garage-car-sensor.yaml substitutions; added missing `person_max_distance`
- Commits: 3dcabeb
- Files Modified:
  - esphome/all-in-one.yaml
  - esphome/packages/car-sensor.yaml
  - esphome/garage-car-sensor.yaml
  - docs/hardware/NJK-5002C Hall Effect Sensor/NJK-5002C Hall Effect Sensor.md

---

## 2026-02-27-02

- Agent: Claude Sonnet 4.6
- Subject: WiFi debugging, faulty hardware discovery, all-in-one inline refactor
- Key Decision: Inline all-in-one.yaml (remove packages); use connect.yaml + utility script for MAC-based device provisioning
- Current Issue: None — all-in-one.yaml connected to WiFi and under review for deployment
- Testing:
  - Discovered ESP32-C6-DevKit-1 unit with failed WiFi hardware — persistent Association Failed / Authentication Failed errors regardless of config
  - Replaced with second unit (MAC 98:A3:16:B1:D0:88); WiFi connects successfully to SWIT2
  - esphome/connect.yaml flashed and confirmed connected (IP 192.168.68.151)
- Work Done:
  - Diagnosed WPA3/WPA2 association failures; added sdkconfig_options to disable WPA3 in all configs
  - Created esphome/connect.yaml — standalone WiFi connectivity test config
  - Created esphome/all-connect.yaml — minimal full config for WiFi testing
  - Created utility/connect.sh — reads MAC via esptool.py, passes as substitution to esphome run; device names itself by full MAC address
  - Refactored esphome/all-in-one.yaml: removed all package includes, inlined all content from simple-wifi.yaml using substitution variables for all GPIO pins
  - Added danger_zone_distance substitution to all-in-one.yaml
  - Updated num_leds substitution to 60
- Files Modified:
  - esphome/all-in-one.yaml
  - esphome/connect.yaml (new)
  - esphome/all-connect.yaml (new)
  - utility/connect.sh (new)

---

## 2026-02-27-01

- Agent: Claude Sonnet 4.6
- Subject: Merge simple-wifi.yaml features into all-in-one production config
- Key Decision: Distribute new features across all-in-one.yaml and packages rather than inlining
- Testing:
  - esphome config esphome/all-in-one.yaml: Configuration is valid!
- Work Done:
  - Added `person_max_distance` substitution to all-in-one.yaml
  - Added `esphome.comment` and `on_boot` (boot counter + LED off) to all-in-one.yaml
  - Added `globals` (boot_count, scan_position, scan_forward) to all-in-one.yaml
  - Removed static IP (`manual_ip`) from all-in-one.yaml wifi config
  - Updated base.yaml: web_server to version 3 with include_internal: false
  - Updated base.yaml: added system sensors (uptime, boot count, MAC address, reset reason, formatted uptime)
  - Updated base.yaml: renamed restart button to "System - Restart Device"
  - Updated car-sensor.yaml: added speed sensors (front_speed, rear_speed)
  - Updated car-sensor.yaml: renamed all entities with "Car Position -" prefix
  - Updated car-sensor.yaml: added active_led_count number slider
  - Updated car-sensor.yaml: added Person Detected binary sensor
  - Updated car-sensor.yaml: updated car_detected distance threshold (100 → 500 mm)
  - Updated car-sensor.yaml: improved Parking Guidance text sensor with person detection + directional messages
  - Updated car-sensor.yaml: replaced single LED effect with 9 effects (Parking Guidance, Solid, Parked Green, Move Forward Blue Scan, Move Forward Minor Cyan Scan, Move Back Orange Scan, Move Back Minor Yellow Scan, Person Alert Red Flash, Rainbow, Pulse)
- Commits: f1b428f, 65aca70
- Files Modified:
  - esphome/all-in-one.yaml
  - esphome/packages/base.yaml
  - esphome/packages/car-sensor.yaml

---

## 2026-02-18-01

- Agent: Claude Opus 4.5
- Subject: LD2450 documentation and danger zone person detection
- Key Decision: Use Target 2 from LD2450 sensors to detect people in front/rear of car
- Testing:
  - Documentation review only (no firmware upload this session)
- Work Done:
  - Expanded LD2450.md with sensor capabilities and placement guidance
  - Added dual sensor configuration docs (Front Sensor, Rear Sensor)
  - Added person detection documentation with multi-target tracking table
  - Added danger zone detection feature to simple-wifi.yaml
  - Implemented Target 2 sensors for front and rear LD2450
  - Added "Person in Danger Zone" binary sensor with red flash trigger
  - Added danger zone diagram and ESPHome configuration examples
- Commits: ced1873
- Files Modified:
  - docs/hardware/LD2450/LD2450.md (major update)
  - esphome/simple-wifi.yaml (danger zone feature)

---

## 2026-02-15-02

- Agent: Claude Opus 4.5
- Subject: Portal improvements (issue #1) and SEMVER setup
- Key Decision: Use naming prefixes for portal sections; shell script for version management
- Testing:
  - esphome config: All 4 configs validate successfully
  - Firmware built and uploaded to device
- Work Done:
  - Implemented portal sections via naming prefixes (Car Position, Garage Door, System)
  - Added LED scan animations (Move Forward/Back, blue/orange/cyan/yellow)
  - Added person detection with red flash alert
  - Added speed sensors for front/rear LD2450
  - Added parking guidance text sensor
  - Set up SEMVER versioning (v0.1.1)
  - Created VERSION file and CHANGELOG.md
  - Added firmware_version to all ESPHome configs
  - Created scripts/version.sh for version management
- Commits: 6da5de3, 070fba0
- Files Modified:
  - VERSION (new)
  - CHANGELOG.md (new)
  - scripts/version.sh (new)
  - esphome/simple-wifi.yaml (major update)
  - esphome/packages/base.yaml
  - esphome/all-in-one.yaml
  - esphome/garage-car-sensor.yaml
  - esphome/esp32-garage-door.yaml

---

## 2026-02-15-01

- Agent: Claude Opus 4.5
- Subject: ESPHome refactoring and issue #2 fixes
- Key Decision: Use ESPHome packages to eliminate code duplication
- Current Issue: Rear LD2450 not working - resolved (bad solder joint on TX wire to GPIO18)
- Testing:
  - esphome config: All 3 main configs validate successfully
- Work Done:
  - Diagnosed rear LD2450 issue (wiring fault on extended cable)
  - Created ESPHome package structure (base.yaml, car-sensor.yaml, garage-door.yaml)
  - Fixed broken esp32_rmt platform in garage-car-sensor.yaml
  - Fixed Color() wrapper in LED lambdas
  - Fixed X=0 validity check (now uses distance > 0)
  - Added NaN guards in parking logic
  - Added restore_mode: ALWAYS_OFF to relay and LED strip
  - Fixed typos in simple-wifi.yaml
  - Changed ap_timeout from 0s to 1min
  - Added secrets.yaml.example
  - Added comment to GitHub issue #2 with findings
- Commits: 360176f
- Files Modified:
  - esphome/packages/base.yaml (new)
  - esphome/packages/car-sensor.yaml (new)
  - esphome/packages/garage-door.yaml (new)
  - esphome/secrets.yaml.example (new)
  - esphome/all-in-one.yaml
  - esphome/garage-car-sensor.yaml
  - esphome/esp32-garage-door.yaml
  - esphome/simple-wifi.yaml
  - BUILD_STATUS.md

---

## 2026-02-13-01

- Agent: Jim
- Subject: Verifing wireing
- Key Decision: Magenets on NJK-5002C Hall Effect Sensor wheel should be FLAT Side up
- Testing:
  - All working BUT MWave sensrors
  - Build successful
- Commits: ec0962b

- Files Modified
