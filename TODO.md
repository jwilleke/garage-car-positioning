# TODO

<!-- RESUME:START -->
## ▶ Resume here — 2026-06-16

- Last worked on: #15 front sensor offline — TX/RX swap attempted, no change, needs more troubleshooting
- Branch / state: master, clean, pushed
- Running / in-flight: none
- Parked / half-done: none
- Next steps:
  - Dig deeper on #15 — TX/RX swap ruled out. Check power (3.3 V vs 5 V), baud rate config, UART pin assignments in ESPHome, and whether HLKRadarTool sees the sensor on the physical port at all.
  - Consider swapping in the working rear sensor on the front port to isolate cable vs. sensor vs. config.
- Blockers / significant notes: #16 (zone config) remains blocked by #15
<!-- RESUME:END -->

Last updated: 2026-06-16

---

## 🔴 P0 — Security & Critical

- #15 [BUG] Front sensor (ld2450_front) offline — Car Centering and Vehicle Detected degraded

---

## 🟠 P1

- #16 [FEATURE] LD2450 zone configuration — hardware and ESPHome software zones
- #10 [FEATURE] Bootloader too old for OTA rollback — flash via USB once to update bootloader

---

## 🟡 P2

None.

---

## ⏸ Deferred

None.

---

## ❓ Needs Triage

None.
