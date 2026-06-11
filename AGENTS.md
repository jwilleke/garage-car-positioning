<!-- KIT:START — managed by mjs-project-template; edit below the KIT:END marker -->
# Agent Context & Protocols

This section is **managed by the kit** (`install-kit.sh`) — it is identical across
repos. Put repo-specific context **below the `KIT:END` marker**; do not edit here.

## Session continuity

- Before starting, read `private/project_log.md` (local, gitignored) and recent `git log`.
  That is where the last session left off — repeating finished work is the most common
  avoidable mistake.
- Close a session with `/session-commit`: commits code + `TODO.md`, appends to
  `private/project_log.md` (the log is never committed).
- Run `/status` often (after every `/session-commit`): it ranks open work and recommends
  the next step.

## Priorities — GitHub labels are the source of truth

- `P0` critical/security · `P1` high · `P2` normal · `deferred` postponed · `needs-triage` unassigned.
- Security comes first. Scanner alerts (Dependabot / code-scanning / GitGuardian) become
  issues labeled `security` + a graded priority: critical/high → `P0`, medium → `P1`, low → `P2`.
- `TODO.md` is a generated mirror of these labels — do not hand-edit it; `/status` regenerates it.

## Working agreement

- Think before coding: state assumptions, surface trade-offs, ask when scope is ambiguous.
- Simplicity first: the minimum that solves the problem; nothing speculative.
- Use Conventional Commits for messages.

## Markdown conventions

- Dash (`-`) bullets; no bare numbered lists. ATX (`#`) headings. Spaced tables (`| a | b |`).
- Inline HTML is **not** allowed. Long lines are fine.
- Rules live in `.markdownlint.jsonc`; the editor, CLI, CI and agents all read that one file.
<!-- KIT:END -->

# 🚗 Garage Automation System

A flexible, DIY garage automation project for Home Assistant, featuring precise car positioning and a full-featured smart garage door controller, all powered by ESPHome and the ESP32-C6.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![ESPHome](https://img.shields.io/badge/ESPHome-supported-green.svg)
![Home Assistant](https://img.shields.io/badge/Home%20Assistant-supported-blue.svg)

## Overview

This project provides a comprehensive solution for automating your garage. It can be built as a standalone car positioner, a standalone smart garage door controller, or a combined all-in-one unit.

READ [CODE_STANDARDS.md](./CODE_STANDARDS.md) for code requirements.

## Features

- Precise, dual mmWave radar sensors for centimeter-level car positioning.
- Visual parking aid using a WS2812B addressable LED strip.
- Full-featured smart garage door controller.
- High-precision door position tracking with a rotary encoder.
- Powered by the ESP32-C6 with Wi-Fi 6, Thread, and Matter support.
- Seamless integration with Home Assistant using ESPHome.
- Supports multiple build paths:
  - Standalone Car Positioning System
  - Standalone Garage Door Controller
  - Combined All-in-One System

Keep [Project_log](./docs/project_log.md) with each code change or commit.

Update [CHANGELOG.md](./CHANGELOG.md) with any major changes or releases.
