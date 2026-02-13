# ESPHome review and recommendations — Issue #2 Body

**To add this to GitHub Issue #2:**

1. **Web UI:** Open [Issue #2](https://github.com/jwilleke/garage-car-positioning/issues/2) → Edit → paste the content below.
2. **CLI:** From repo root: `gh issue edit 2 --body-file issue-2-body.md`

---

## Summary

Review of the `esphome/` directory for the garage-car-positioning project. Findings include one **broken config**, several consistency improvements, and recommendations for maintainability.

---

## Critical issue

### 1. `garage-car-sensor.yaml` — Invalid LED strip platform

- Uses `platform: esp32_rmt`, which **does not exist** in ESPHome 2025.5.2
- Should use `esp32_rmt_led_strip` (as in `all-in-one.yaml`)
- The lambda uses `it.all().set(0, 0, 0)` instead of `it.all().set(Color(0, 0, 0))` — the `esp32_rmt_led_strip` API expects `Color()` wrapper
- Also uses `chipset: WS2812B` — the official docs list `WS2812` (though WS2812B may alias; WS2812 is the safe choice)

**Validation:** `esphome config esphome/garage-car-sensor.yaml` fails with: `Platform not found: 'light.esp32_rmt'`

---

## Consistency & minor improvements

### 2. Framework version mismatch

- `esp32-garage-door.yaml` omits `framework.version: recommended`
- Other configs include it (e.g. `all-in-one.yaml`, `garage-car-sensor.yaml`, `simple-wifi.yaml`)
- **Recommendation:** Add `framework.version: recommended` for consistency

### 3. Configuration duplication

- Car positioning logic (template sensors, binary sensors, LED effects) is duplicated between `all-in-one.yaml` and `garage-car-sensor.yaml`
- Door logic (encoder, reed switch, relay, cover) is duplicated between `all-in-one.yaml` and `esp32-garage-door.yaml`
- **Recommendation:** Consider ESPHome [packages](https://esphome.io/guides/configuration-types.html#packages) (`!include` or `packages:`) to share common blocks (e.g. `packages/car-sensor.yaml`, `packages/garage-door.yaml`)

### 4. Typos in `simple-wifi.yaml`

- Line 1: `inbtended` → `intended`, `caliration` → `calibration`

### 5. Potential logger bug in `simple-wifi.yaml`

- The number component's `set_action` uses `args: ['x']` — verify this correctly logs the slider value (may need lambda-based logging)

### 6. Hardcoded network config

- `all-in-one.yaml` has static IP (`192.168.68.100`) with TODO comments — consider moving to secrets or documenting clearly

### 7. Debug settings in production configs

- `ap_timeout: 0s` keeps AP always on (intentional for debugging per comments)
- `logger.level: DEBUG` everywhere — consider `INFO` for production, `DEBUG` when troubleshooting

---

## What's working well

- Clear `substitutions` with inline GPIO documentation
- Sensible GPIO choices (avoiding JTAG pins on ESP32-C6)
- Correct `hardware_uart: USB_SERIAL_JTAG` for ESP32-C6
- API encryption and OTA passwords via secrets
- Sensible use of `device_class`, `unit_of_measurement`, and IDs for Home Assistant
- `simple-wifi.yaml` is a useful test/debug config with boot count, reset reason, etc.

---

## Config status overview

| File | Purpose | Status |
|------|---------|--------|
| `all-in-one.yaml` | Primary combined config | Valid |
| `esp32-garage-door.yaml` | Door-only config | Valid |
| `garage-car-sensor.yaml` | Car sensor only | Broken (invalid LED platform) |
| `simple-wifi.yaml` | Test/debug config | Valid (typos) |
| `test-minimal.yaml` | Minimal test | Valid |

---

## Suggested next steps

1. **Fix `garage-car-sensor.yaml`** — switch to `esp32_rmt_led_strip`, use `Color()` in lambdas, chipset `WS2812`
2. Add `framework.version: recommended` to `esp32-garage-door.yaml`
3. Fix typos in `simple-wifi.yaml`
4. Add `secrets.yaml.example` with placeholder keys (documented in CLAUDE.md) so new clones know what to create
5. (Optional) Extract shared config into `packages/` for maintainability
