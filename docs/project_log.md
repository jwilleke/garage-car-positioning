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

## 2026-03-02-02

- Agent: Claude Sonnet 4.6
- Subject: Standalone implementation guides, config renames, Thread/Matter decision doc
- Key Decision: ESPHome config filenames simplified — `garage-car-sensor.yaml` → `car-positioning.yaml`, `esp32-garage-door.yaml` → `garage-door.yaml`; Thread/Matter deferred until ESPHome Matter support is stable
- Current Issue: Issue #4 open — web portal layout tracking (updated with new Configuration entities)
- Testing:
  - No firmware changes this session
- Work Done:
  - Created `docs/car-positioning-guide.md` — standalone implementation path for car positioning only
  - Created `docs/garage-door-guide.md` — standalone implementation path for garage door only (includes Genie 2022 relay pulse note)
  - Added builder inventory note to `docs/hardware/BOM.md`
  - Renamed `esphome/garage-car-sensor.yaml` → `esphome/car-positioning.yaml`
  - Renamed `esphome/esp32-garage-door.yaml` → `esphome/garage-door.yaml`
  - Updated all references across CLAUDE.md, GEMINI.md, CHANGELOG.md, BUILD_STATUS.md, project_log.md, docs
  - Created `docs/planning/thread-matter.md` — Thread & Matter trade-off analysis and decision
  - Closed issue #3 (Thread/Matter) with link to new doc
  - Updated issue #4 (web portal layout) with new Configuration group entities
- Commits: ec308db, 7bb98bd, dc051ed
- Files Modified:
  - docs/car-positioning-guide.md (new)
  - docs/garage-door-guide.md (new)
  - docs/planning/thread-matter.md (new)
  - docs/hardware/BOM.md
  - esphome/car-positioning.yaml (renamed)
  - esphome/garage-door.yaml (renamed)
  - CLAUDE.md
  - GEMINI.md
  - CHANGELOG.md
  - BUILD_STATUS.md
  - docs/Installation.md
  - docs/project_log.md

---

## 2026-03-02-01

- Agent: Claude Sonnet 4.6
- Subject: Genie 2022 relay intermittent — configurable relay pulse duration
- Key Decision: Relay pulse of 200ms too short for Genie 2022 PB input to register reliably; made duration configurable at runtime via `number` entity (default 500ms)
- Current Issue: See GitHub issue #7 — Genie 2022 relay NO/COM intermittent, relay pulse duration too short
- Testing:
  - esphome compile esphome/all-in-one.yaml: SUCCESS
  - OTA upload to 192.168.68.151: successful
  - LED test across relay NO/COM confirmed contacts close on every trigger
  - 500ms pulse confirmed: door triggers reliably every time — issue #7 resolved
- Work Done:
  - Diagnosed Genie 2022 not responding to relay: correct terminals (P/B), correct jumper (H), relay clicks, LED test confirms contact closure — pulse duration identified as cause
  - Added `Garage Door - Relay Pulse (ms)` number entity (100–2000ms, step 50, default 500ms, restore_value: true)
  - Changed relay `on_turn_on` delay from hardcoded `200ms` to `!lambda` reading `relay_pulse_ms` entity
  - Created GitHub issue #7
- Commits: 951886b
- Files Modified:
  - esphome/all-in-one.yaml
  - docs/project_log.md

---

## 2026-02-28-05

- Agent: Claude Sonnet 4.6
- Subject: API Reboot Watchdog switch; remove device comment banner
- Key Decision: `restore_value: true` on bool global does not fall back to `initial_value` after USB flash on ESP32-C6 (NVS erased = reads zero). Fix: `restore_value: false` + force `true` in `on_boot`, same pattern as `led_auto_mode`
- Current Issue: See GitHub issue #6 — ESPHome global restore_value: true initializes to false after USB flash
- Testing:
  - esphome config esphome/all-in-one.yaml: Configuration is valid!
  - Compiled and uploaded via USB /dev/cu.usbmodem31101
  - API Reboot Watchdog switch confirmed ON after boot
- Work Done:
  - Removed `esphome.comment` field — eliminates device description banner from web portal header ("started X ago" is hardcoded in web_server v3 JS, cannot be removed)
  - Added `System - API Reboot Watchdog` switch to Configuration group (weight 35) — disables/enables the 15-min no-client reboot watchdog at runtime
  - Added `api.id: garage_api` + `api.reboot_timeout: 0s` — disables built-in watchdog, enables runtime control
  - Added `interval: 60s` — custom watchdog replicating 15-min default; only reboots when switch is ON
  - Added globals `api_reboot_allowed` and `api_no_client_secs`
  - Fixed init bug: changed `api_reboot_allowed` to `restore_value: false`, forced `true` in `on_boot`
  - Created GitHub issue #6 documenting the restore_value/NVS initialization bug
- Commits: cbe68ce
- Files Modified:
  - esphome/all-in-one.yaml

---

## 2026-02-28-04

- Agent: Claude Sonnet 4.6
- Subject: Doc corrections — LED behavior, calibration units, broken links
- Key Decision: ESPHome IDs cannot start with a digit; alphabetic prefix (`a_`/`b_`) is the only valid workaround for unreliable `sorting_weight` ordering
- Current Issue: `sorting_weight` ordering in web_server v3 is unreliable as of ESPHome 2026.2.0 — no upstream fix; `a_`/`b_`/`c_`/`d_` prefix workaround confirmed valid in `testing.yaml`
- Testing:
  - esphome config esphome/testing.yaml: Configuration is valid! (with a_ prefixes)
  - esphome upload all-in-one.yaml → OTA to 192.168.68.151: successful
  - Numeric prefix IDs (1_group_car, 1group_car) rejected: "First character in ID cannot be a digit"
- Work Done:
  - Tested numeric ID prefix workaround in testing.yaml — rejected by ESPHome validator
  - Restored testing.yaml to a_/b_/c_/d_ alphabetic prefixes (valid and confirmed)
  - Updated GitHub issue #4 with numeric prefix test findings
  - Fixed broken links in README.md (./hardware/ → ./docs/hardware/)
  - Fixed broken relative links in docs/Installation.md (../hardware/ → hardware/)
  - Rewrote docs/light-strip-operation.md: effects are scanning animations not solid colors; red = person alert not distance; yellow effect unused; added summary table
  - Updated docs/calibration.md: entity names, inch units, and file references updated for all-in-one.yaml
- Commits: 6b5dd48
- Files Modified:
  - esphome/testing.yaml
  - README.md
  - docs/Installation.md
  - docs/light-strip-operation.md
  - docs/calibration.md
  - docs/project_log.md

---

## 2026-02-28-03

- Agent: Claude Sonnet 4.6
- Subject: Log level dropdown, LED defaults on, web portal polish
- Key Decision: Compile logger at DEBUG max, default to WARN at runtime via on_boot; use select dropdown instead of binary switch for log level
- Current Issue: None — firmware uploaded and running
- Testing:
  - esphome config esphome/all-in-one.yaml: Configuration is valid!
  - Compiled and uploaded via USB /dev/cu.usbmodem31101
- Work Done:
  - Replaced debug logging binary switch with System - Log Level select dropdown (Off/WARN/INFO/DEBUG)
  - Fixed "Cannot set log level higher than pre-compiled WARN" — changed compiled level to DEBUG, set WARN at boot via on_boot action
  - Forced `id(led_auto_mode) = true` in on_boot lambda (always ON after restart regardless of previous state)
  - Renamed light "Car Position - Parking LED" → "Car Position - LED Strip"
  - Changed LED strip restore_mode from ALWAYS_OFF to RESTORE_DEFAULT_ON (boots on)
  - Removed explicit light.turn_off from on_boot (LED auto mode handles state within 500ms)
  - Fixed web_server group sorting_weight order (user corrected to 10/20/30/40 ascending = lower is first)
  - Updated packages/car-sensor.yaml: Front→Garage Door, Rear→Inside Wall entity name renames; inch conversion filters
  - Updated GitHub issue #4 with final 4-group layout
- Commits: 50333b4
- Files Modified:
  - esphome/all-in-one.yaml
  - esphome/packages/car-sensor.yaml

---

## 2026-02-28-02

- Agent: Claude Sonnet 4.6
- Subject: Door position tracking, status display, debug logging toggle, web portal polish
- Key Decision: Relay moved to Configuration group to prevent accidental door trigger; logger defaults to WARN (quiet), toggle enables DEBUG
- Current Issue: `garage_door_full_open_counts` is a placeholder ("64") — must be calibrated by opening door fully and reading encoder count from HA
- Testing:
  - esphome config esphome/all-in-one.yaml: Configuration is valid!
- Work Done:
  - Added `door_counts` global (int, restore: true) for quadrature encoder position tracking
  - Added A/B hall sensor quadrature counting logic: A rising + B low = count up; A rising + B high = count down; vice versa on falling edge
  - Added `door_counts = 0` reset on garage_door_closed_switch on_press and on_boot (if closed)
  - Added Garage Door - Position sensor (%, group_door weight 3) computed from door_counts
  - Added Garage Door - Status text sensor (group_door weight 1) showing "Closed" or "Open X%"
  - Changed logger base level from DEBUG to WARN (quiet default)
  - Added System - Debug Logging switch (default OFF, group_config weight 5); turns DEBUG on when enabled
  - Moved Garage Door - Open / Close relay from group_door to group_config (weight 4)
  - Updated GitHub issue #4 with revised 4-group layout table and design decisions
- Commits: c935136
- Files Modified:
  - esphome/all-in-one.yaml

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
    - Replaced single `target_y_min/max/x_tolerance` with per-sensor `front_target_*` and `rear_target_*` substitutions in all-in-one.yaml and car-positioning.yaml
    - Updated `car_center_y` to return rear sensor Y (wall = depth into garage) instead of averaged Y
    - Added `car_center_x` sensor (was missing from all-in-one.yaml) returning front sensor X (ceiling = lateral offset)
    - Updated `car_correctly_parked` to check each sensor against its own coordinate zone independently
    - Updated `parking_guidance` text sensor and LED effect to use rear sensor Y for move-forward/back direction
    - Updated packages/car-sensor.yaml with identical fixes + updated header comment documenting sensor mounting and axes
    - Updated car-positioning.yaml substitutions; added missing `person_max_distance`
- Commits: 3dcabeb
- Files Modified:
  - esphome/all-in-one.yaml
  - esphome/packages/car-sensor.yaml
  - esphome/car-positioning.yaml
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
  - esphome/car-positioning.yaml
  - esphome/garage-door.yaml

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
  - Fixed broken esp32_rmt platform in car-positioning.yaml
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
  - esphome/car-positioning.yaml
  - esphome/garage-door.yaml
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
