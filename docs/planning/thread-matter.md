# Thread & Matter Protocol Support (ESP32-C6)

Decision document for whether and how to add Thread and/or Matter protocol support. Captures trade-offs before any implementation begins.

Related: GitHub issue [#3](https://github.com/jwilleke/garage-car-positioning/issues/3)

---

## Current State

- **Protocol:** WiFi + ESPHome native API + Home Assistant
- **Version:** v0.1.1
- **Status:** Working — full entity control, OTA updates, log streaming via ESPHome dashboard
- **Hardware:** ESP32-C6 has IEEE 802.15.4 radio built-in — Thread-capable without extra hardware

Thread and Matter are referenced as possible future features in `AGENTS.md` and [garage-door.md](garage-door.md) (hardware selection rationale).

---

## Thread

### Pros

- Low-power mesh networking built into ESP32-C6 — no extra radio needed
- Home Assistant has Thread Border Router support via SkyConnect USB dongle or HA Yellow
- ESP32-C6 supports concurrent WiFi + Thread — no forced migration
- More reliable mesh in RF-dense environments than 2.4 GHz WiFi

### Cons

- Requires a Thread Border Router on the network (additional hardware dependency)
- ESPHome Thread support is newer and less mature than WiFi support
- Adds complexity to the firmware build (`esp-idf` sdkconfig changes required)
- Harder to debug without USB serial fallback once deployed via Thread only

---

## Matter

### Pros

- Industry-standard smart home protocol — supported by Apple, Google, Amazon, and Home Assistant
- Works over both WiFi and Thread — flexible deployment
- HA has native Matter integration (no ESPHome bridge layer needed)
- Strong industry momentum — future-proof for broad ecosystem compatibility

### Cons

- Replaces ESPHome native API — lose direct ESPHome ↔ HA integration and dashboard
- Matter device type model is rigid — custom sensors (radar, parking guidance) don't map cleanly to standard Matter device types
- LED effects, scan animations, and parking guidance text are not Matter-standard — would require custom clusters or be dropped entirely
- Larger firmware footprint and longer build times
- OTA still works but Matter commissioning adds setup complexity
- ESPHome Matter support is marked **experimental** as of 2025

---

## Feature Comparison

| Feature | ESPHome WiFi API | Matter |
| ---- | ---- | ---- |
| Full entity control | Yes | Limited to standard types |
| OTA updates | Native ESPHome OTA | Works but different flow |
| Log streaming | ESPHome dashboard | Not available |
| Custom sensors (radar, LED) | Full support | No standard cluster |
| Multi-platform (Apple/Google) | HA only | Yes |
| Setup complexity | Low | Higher (commissioning) |
| Thread Border Router required | No | Only if using Thread transport |

**Hybrid approach:** A possible path is WiFi for ESPHome API (primary) + Thread/Matter as a secondary protocol. The ESP32-C6 hardware supports this concurrently.

---

## Decision

1. **HA-only use case:** ESPHome WiFi API is superior — custom entities, full control, radar/LED support intact. No reason to switch.
2. **Multi-platform goal (Apple Home, Google Home):** Matter over WiFi is the path. Accept loss of ESPHome-specific features.
3. **Thread value:** Adds value mainly if WiFi reliability is a problem in the garage environment, or if building a mesh with other Thread devices.
4. **Wait for maturity:** ESPHome Matter is experimental. Revisit when it stabilizes.

**Current decision: No action.** Continue on ESPHome WiFi API. Revisit Matter when ESPHome marks it stable and when multi-platform support becomes a requirement.

---

## References

- `AGENTS.md` — Thread/Matter listed in project vision
- [garage-door.md](garage-door.md) — Thread considered during ESP32-C6 hardware selection
- `esphome/all-in-one.yaml` — current firmware baseline
- [ESPHome Matter docs](https://esphome.io/components/matter)
- [ESPHome Thread docs](https://esphome.io/components/thread)
