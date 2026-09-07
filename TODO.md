# TODO

<!-- RESUME:START -->
## ▶ Resume here — 2026-09-07

- Last worked on: housekeeping only, no firmware touched. Committed the garage door quadrature
  encoder debugging notes and cleared the kit-sync backlog. __No progress on #15__ — the P0 stands
  exactly where 2026-08-10 left it
- Branch / state: master, clean, pushed, 0 stashes. Kit at `v1.12.0-1-gd3d2248`. All CI green
- Running / in-flight: none. No background agents, dev servers, or scheduled jobs
- Parked / half-done: none locally. But see the first next step — there is a bot branch on the
  remote with no PR behind it
- Next steps:
  - __Delete the stale remote branch `chore/kit-sync-v1.12.0`__ (or leave it; it is inert).
    It is fully superseded: PR #32 merged `chore/kit-sync-v1.12.0-1-gd3d2248` into master, and
    master now contains every line that branch carried plus 9 more in
    `.github/workflows/kit-sync.yml`. Opening a PR for it would propose reverting those 9 lines
  - __Resume #15 where the last session stopped.__ Two benign explanations remain untested; check
    both before declaring the front sensor dead:
    - __5 V supply adequacy__ — BLE comes up on a marginal supply that cannot sustain the radar
      front-end. Measure at the sensor, under load
    - __Zone/region config in the app__ — a filter written during June debugging would suppress
      every target, in the app and over UART alike. Read it before changing anything
  - If both are clean: the front radar is dead. Replace it, and buy a spare
  - No-new-hardware alternative: bench the front sensor on ESP __GPIO18/19__ (the rear port) with
    short jumpers. Rear entities coming alive exonerates the sensor and condemns the front path
  - Optional: file a `[BUG]` for the encoder questions raised in
    `docs/hardware/NJK-5002C Hall Effect Sensor/encoder-steps.md` — no open issue covers them
- Blockers / significant notes:
  - __#15 (P0) gates everything__ — #16 and #20 are both blocked by it
  - Encoder notes recorded four unanswered questions: whether `sensor_a_count` / `sensor_b_count`
    reset to zero on close, whether A and B are reversed in the rotation config, how correct
    rotation direction is determined, and whether quadrature needs `resolution: 1` instead of `4`.
    Concrete next test: close the door to zero the encoder, open fully, watch CW steps for ~36
  - `bay_motion` (merged in #21) is still __unvalidated__ — never compiled or walk-tested. Do not
    wire a door interlock to it until #15 is fixed; reading a dead radar returns a confident "clear"
  - Ruled out on #15 so far: sensor unpowered, firmware too old (`2.04.23101915` exceeds the
    required `V2.02.23090617`), baud mismatch, TX/RX polarity, harness continuity
  - Sensor identities are in `docs/hardware/LD2450/LD2450.md` — E0E0 = front, 1A63 = rear. An
    active HLKRadarTool BLE session can suppress UART output; disconnect before any serial test
  - `utility/ld2450_bench_test.py` has still __never been run against real hardware__ — needs a
    USB-to-TTL adapter (~$8, not owned)
  - Correction to the previous pointer: PR #17 is __not__ still open — it was closed unmerged on
    2026-08-17. No PRs are open now
  - Kit jumped `v1.11.1` to `v1.12.0-1-gd3d2248` today across PRs #30 and #32. #32 rewrote four
    `.claude/commands/*.md` files, so `/wrap`, `/pstatus`, `/context`, `/session-commit` and
    `/semver` all carry new text that has not been exercised yet — this session ran the older
    `/wrap` and `/session-commit`
<!-- RESUME:END -->

Last updated: 2026-09-07

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
