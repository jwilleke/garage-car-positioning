# TODO

<!-- RESUME:START -->
## ▶ Resume here — 2026-08-10

- Last worked on: #15 diagnosis moved decisively — the front sensor (HLK-LD2450_E0E0) shows
  __no targets in HLKRadarTool over BLE__, a link that bypasses all wiring. Evidence now points at
  the sensor itself, not the cable path.
- Branch / state: master, clean, pushed (only `.claude/settings.local.json` modified — leave it)
- Running / in-flight: none. All CI green, no background processes
- Parked / half-done: `utility/ld2450_bench_test.py` is merged but has __never been run against
  real hardware__ — needs a USB-to-TTL adapter (~$8, not owned)
- Next steps:
  - Two benign explanations for #15 remain untested. Check both before declaring the sensor dead:
    - __5 V supply adequacy__ — BLE comes up on a marginal supply that cannot sustain the radar
      front-end. Measure at the sensor, under load
    - __Zone/region config in the app__ — a filter written during June debugging would suppress
      every target, in the app and over UART alike. Read it before changing anything
  - If both are clean: the front radar is dead. Replace it, and buy a spare — a second unit turns
    the next failure into a five-minute swap test instead of a two-month investigation
  - No-new-hardware alternative: bench the front sensor on ESP __GPIO18/19__ (the rear port) with
    short jumpers. Rear entities coming alive exonerates the sensor and condemns the front path
- Blockers / significant notes:
  - __#15 (P0) gates everything__ — #16 and #20 are both blocked by it
  - `bay_motion` (merged in #21) is __unvalidated__ — never compiled or walk-tested. Do not wire a
    door interlock to it until #15 is fixed; reading a dead radar returns a confident "clear"
  - Ruled out on #15 so far: sensor unpowered, firmware too old (`2.04.23101915` exceeds the
    required `V2.02.23090617`), baud mismatch, TX/RX polarity, harness continuity
  - Sensor identities are now recorded in `docs/hardware/LD2450/LD2450.md` — E0E0 = front,
    1A63 = rear. An active HLKRadarTool BLE session can suppress UART output; disconnect before
    any serial test
  - PR #17 (kit sync) has been open since 2026-07-27 and was not touched this session
<!-- RESUME:END -->

Last updated: 2026-08-10

---

## 🔴 P0 — Security & Critical

- #15 [BUG] Front sensor (ld2450_front) offline — Car Centering and Vehicle Detected degraded

---

## 🟠 P1

- #20 [BUG] car_detected is "target 1 beyond 20 inches", so a lone person is classified as a vehicle (blocked)
- #16 [FEATURE] LD2450 zone configuration — hardware and ESPHome software zones
- #10 [FEATURE] Bootloader too old for OTA rollback — flash via USB once to update bootloader

---

## 🟡 P2

- #18 [FEATURE] LOCK Door Operations

---

## ⏸ Deferred

- #19 [FEATURE] Firmware presence interlock — refuse HA-initiated close while a person is detected

---

## ❓ Needs Triage

None.
