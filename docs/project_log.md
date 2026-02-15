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
