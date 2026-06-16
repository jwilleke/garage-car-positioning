# TODO

Last updated: 2026-06-16

---

## Security / Dependabot

None. `package.json` and `package-lock.json` were removed in ac18826 (2026-06-10); the 3 Dependabot
alerts for `@anthropic-ai/claude-code` will auto-dismiss once GitHub processes the deletion.

---

## Failing GitHub Actions

None — the two most recent runs on `master` both succeeded (Dependabot dependency update jobs, April 2026).

---

## Waiting on Review Sign-off

None.

---

## Open PRs

None.

---

## Needs Triage

All open issues are currently unranked (`needs-triage`):

| # | Type | Title |
| --- | --- | --- |
| #15 | bug | [BUG] Front sensor (ld2450_front) offline — Car Centering and Vehicle Detected degraded |
| #16 | feature | [FEATURE] LD2450 zone configuration — hardware and ESPHome software zones |
| #10 | feature | [FEATURE] Bootloader too old for OTA rollback — flash via USB once to update bootloader |

---

## Open Bugs

| # | Title | Notes |
| --- | --- | --- |
| #15 | [BUG] Front sensor (ld2450_front) offline | **Active — physical wiring fix pending (TX/RX swap)** |

---

## Open Features / Enhancements

| # | Title | Notes |
| --- | --- | --- |
| #16 | [FEATURE] LD2450 zone configuration — hardware and ESPHome software zones | Blocked by #15 |
| #10 | [FEATURE] Bootloader too old for OTA rollback — flash via USB once | Low priority; requires physical USB access |

---

## Easy Wins

None qualify. All open issues require physical hardware access (#15 wiring swap, #10 USB flash) or
are explicitly blocked (#16 is blocked by #15).

---

## Operator-Action Carryover

- **Issue #15 (front sensor offline)**: Root cause identified as likely TX/RX swap at the connection
  block (rewired from JST to bare block — no keying). Next step: physically swap the TX and RX wires
  on the front LD2450 connector and verify in HLKRadarTool + HA logs.

---

## Deferred

None with `deferred` label.

---

## Recommended Next Moves

- **Fix #15 (front sensor):** Physically swap TX ↔ RX wires on the front LD2450 connection block.
  Verify via HLKRadarTool and `Car Position - Front Target Count` in HA. This unblocks #16.
- **After #15 resolved, start #16 Option A:** Configure hardware zones on both sensors via HLKRadarTool
  (≈30 min/sensor, no firmware changes, low risk) for immediate false-positive reduction.
