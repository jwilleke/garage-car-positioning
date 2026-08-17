<!-- KIT:START v1.10.2-0-g0903de6 — managed by mjs-project-template; edit below the KIT:END marker -->
## Agent Kit Protocols

This section is __managed by the kit__ (`install-kit.sh`) — it is identical across repos. Put repo-specific context __below the `KIT:END` marker__; do not edit here.

The heading above names the kit on purpose. It used to read `Agent Context & Protocols`, which is the
same wording a repo naturally picks for its own agent section below `KIT:END` — two identical `##`
headings in one file, and `markdownlint` MD024 fails on it. The kit owns one heading string in every
repo that installs it, so that string says whose it is.

### Session continuity

- Before starting, read the `▶ Resume here` block at the top of `TODO.md` (committed, so it syncs across machines) and recent `git log`. That is where the last session left off — repeating finished work is the most common avoidable mistake.
- Commit a chunk of work with `/session-commit`: commits code + `TODO.md`, appends a journal entry to `private/project_log.md` (the log is never committed).
- Run `/pstatus` often (after every `/session-commit`): it ranks open work and recommends the next step.
- End a session with `/wrap`: commits anything outstanding, refreshes the `▶ Resume here` pointer, and reports whether it is safe to shut down the editor.

### Priorities — GitHub labels are the source of truth

Priority labels are mutually exclusive and mean:

- `P0` — __Broken. Stop all work and fix it.__ (production down / blocked / security breach)
- `P1` — __Delivers value to the mission.__
- `P2` — __Nice to have.__
- `deferred` — consciously postponed; `needs-triage` — awaiting a priority decision.

Then:

- Security comes first. Scanner alerts (Dependabot / code-scanning / GitGuardian) become issues labeled `security` + a graded priority: critical/high → `P0`, medium → `P1`, low → `P2`.
- `TODO.md` = a `▶ Resume here` block (maintained by `/wrap`) on top, then priority bands that `/pstatus` regenerates from the labels. Do not hand-edit the bands.
- The two halves have one writer each and a deliberate handover: `/wrap` writes the resume pointer at session end, `/context` reads it at session open, and the first `/pstatus` of the session __removes__ it — by then you have already resumed, so it has served its purpose. A bands-only `TODO.md` mid-session is expected, not a loss.
- Kit files are overwritten wholesale on every sync — `.claude/commands/*.md`, `utility/sync-labels.sh`, `.markdownlint-cli2.jsonc`. Never add a rule to one of them: it is destroyed at the next sync (the installer now warns, but the rule still goes). A __generic__ rule belongs upstream in [mjs-project-template](https://github.com/jwilleke/mjs-project-template) so every repo gets it. A __repo-specific__ note about a command — a package manager the kit does not name, a scanner only this repo has — goes in `.claude/commands/<command>.local.md`, which the kit never writes, reads, or deletes. Read that file, if present, as part of the command; commit it, so it travels with the repo.
- `TODO.md` holds __no history__ — only what is open right now. Never add "merged since last run", closed/merged counts, a session narrative, a dated changelog, or work from other repos. A closed item just stops appearing; that disappearance is the whole record. Session history goes in `private/project_log.md` via `/session-commit` and `/wrap`, and nowhere else.

### Working agreement

- Think before coding: state assumptions, surface trade-offs, ask when scope is ambiguous.
- Simplicity first: the minimum that solves the problem; nothing speculative.
- Use Conventional Commits for messages.
- Issue decomposition — NEVER put "Steps", "Phases", or numbered sequences inside a single GitHub issue. Break each step into its own issue and link them using GitHub relationships: `closes #N` / `fixes #N` (resolves another), `blocked by #N` (dependency), `relates to #N` (context link). Example: a 3-phase migration = 3 issues with "blocked by" chains, not one issue with Phase headings.
- Issue/PR links — Never use a bare `#N` reference alone. Always pair it with the full GitHub URL: `[#333](https://github.com/owner/repo/issues/333)`. This applies in commit messages, PR descriptions, comments, and any agent output. Use `/issues/N` for issues and `/pull/N` for PRs.
- Awaiting approval — When work is complete but requires human sign-off before closing, apply the `in-review` label and leave a comment on the issue/PR that states: what was done, what the human needs to verify, and what action closes it. Never self-close an issue or PR.
- Closing issues — __Always remove the `in-review` label when closing__ an issue or PR (`gh issue edit N --remove-label in-review` before or with the close). Closed items must not keep `in-review`, or the label stops meaning "awaiting a decision" and the queue it drives can no longer be trusted.
- Commits — always use the `/session-commit` skill. Never run a bare `git commit` directly. `/session-commit` enforces the session log update, conventional commit format, and co-author trailer.
- Direct commits by default — commit to the default branch; do not open a pull request unless someone other than you will actually look at it before it lands. On a single-maintainer repo a self-opened, self-merged PR reviews nothing: it just splits one explanation across a commit message and a near-identical PR body. Put the reasoning in the commit message. A change touching a "risky" path, closing an issue, or feeling significant is __not__ a reason to open one — CI runs on `push` as well as `pull_request`, so a direct commit is still tested. Where a PR does exist, its body points at the commit message rather than restating it.

### Markdown conventions

__Read `.markdownlint-cli2.jsonc` before writing markdown.__ It is the control file — rules, globs
and ignores in one place, read by the editor, the CLI, CI and you, and identical in every repo the
kit installs into. Do not rely on a summary: this section deliberately does not restate the rules,
because a second copy drifts from the first the moment someone changes one.

Most markdown here is written by agents, so these are writing rules, not review rules — conform on
the first draft rather than relying on `--fix`. There is no exemption mechanism and none is wanted;
a disabled check is a check nobody revisits. Verify with `npm run lint:md`, or `npx markdownlint-cli2`
where there is no `package.json`.

Only committed files are linted: anything `.gitignore`d is generated or vendored, so its source is
linted instead.
<!-- KIT:END -->

## 🚗 Garage Automation System

A flexible, DIY garage automation project for Home Assistant, featuring precise car positioning and a full-featured smart garage door controller, all powered by ESPHome and the ESP32-C6.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![ESPHome](https://img.shields.io/badge/ESPHome-supported-green.svg)
![Home Assistant](https://img.shields.io/badge/Home%20Assistant-supported-blue.svg)

### Overview

This project provides a comprehensive solution for automating your garage. It can be built as a standalone car positioner, a standalone smart garage door controller, or a combined all-in-one unit.

READ [CODE_STANDARDS.md](./CODE_STANDARDS.md) for code requirements.

### Features

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
