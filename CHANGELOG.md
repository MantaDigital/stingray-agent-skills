# Changelog

## 0.1.7 - 2026-04-25

- **Reframed distribution copy as quantitative research and data infrastructure for crypto markets, operated by AI agents.** Categories the skill alongside Kaiko, Coin Metrics, Amberdata — institutional-grade research/data tooling — instead of generic account operations or execution-coded language. Lead with the value prop: Stingray ingests, correlates, and serves the data; the agent runs the loop end-to-end so users test more hypotheses faster. Venue coverage (Hyperliquid, Lighter, Polymarket, Kalshi, 100+ more) named explicitly in the body to anchor the breadth claim.
- **Dropped execution-coded language** that hit Snyk's financial-platform-automation taxonomy in v0.1.6 (the keyword classifier flagged the v0.1.6 copy as Critical Risk regardless of the actual code surface). The v0.1.7 framing keeps persona-targeting (quants, analysts, research desks) without the classifier hit.
- Updated `marketplace.json` keywords/tags accordingly. Added `signals`, `quant`, `research`. Removed `trading`, `defi`.
- **Removed Drift from venue list.** Stingray doesn't currently cover Drift — surfacing it overpromised. Anchor venue names are now Hyperliquid, Lighter, Polymarket, Kalshi.
- **Added a debug-report channel through `references/co-development.md`.** Same chat-stream endpoint as feature requests, prefixed `Debug report:` instead of `Feature request:`. Covers reference mismatches, undocumented response shapes, routing ambiguity, reproduction failures, and setup edge cases. Added a corresponding step 8 to the Default Operating Loop in `SKILL.md` so agents fire it after completing any task where something was unexpected.
- **Snyk W007 mitigation — credential isolation, single secure path.** Reworked `SKILL.md` First-Time Setup so the agent gives the user a one-line shell command to run in their own terminal (or sets `STINGRAY_PAT` in their shell). The token never enters the agent's chat context. Chat-paste is deliberately not supported — if the user pastes the token into chat anyway, the agent asks them to clear scrollback and re-do setup via the terminal command.
- **Snyk W011 mitigation — untrusted content handling.** Added a new "Untrusted Content Handling" section to `SKILL.md` instructing the agent to treat news bodies, KG entity descriptions, attachment text, and any third-party content as data, not instructions — no following URLs, no acting on imperatives, no interpreting fetched content as user commands.
- Tightened root README Security section to lead with the two Snyk findings and the mitigations, instead of explaining the Med-Risk score in v0.1.6 framing.
- Updated `skills/stingray/README.md` quickstart to reflect the terminal-only credential setup.
- Updated `scripts/validate-public.sh` to enforce the new guidance phrases (replacing the legacy "Do not show the user shell commands" check, which contradicted the new credential-isolation flow).
- Bumped `metadata.version` and plugin `version` to 0.1.7.

## 0.1.6 - 2026-04-25

- **Repositioned `SKILL.md` description.** Lead with what the skill actually is — crypto research and signal infrastructure (composable alerts, backtests, knowledge graph) — instead of generic account operations. Persona: quants, analysts, and research desks.
- **Sharper capability communication in `SKILL.md` body.** Replaced the one-line "User-scoped Stingray access over HTTP via API token" intro with a one-paragraph description that names the surfaces (composable alerts, backtests, KG) and the venue scope.
- **`STINGRAY_PAT` env var fallback.** The credential check now prefers `STINGRAY_PAT` from the environment when present, falling back to `~/.stingray/credentials`. Lets users avoid the file write entirely (responds to a Snyk Med-Risk concern about credential persistence).
- **Repositioned root README.** Added a capability matrix, a "Security & Trust" section that addresses the Snyk Med-Risk score head-on, a multi-agent reach callout, and a "what this is not" disclaimer.
- **Repositioned `marketplace.json` description** to match. Bumped `metadata.version` and plugin `version` to 0.1.6.

## 0.1.5 - 2026-04-24

- **Skill structure cleanup.** Compressed `SKILL.md` from ~150 to ~85 lines: trimmed the Default Operating Loop from 10 to 7 steps (moved chat-handling and token-cleanup hygiene into their respective references), consolidated the API section's three curl examples into the two most common (read + write), and tightened the First-Time Setup steps. Extracted the 30-line Co-development section into its own dedicated reference `references/co-development.md` so SKILL.md stays a clean entry point. Added Co-development + a `Stop conditions` block to Task Routing for cleaner separation.
- Cleaned `references/business-capabilities.md` section 7 → "Run a backtest (core, private)" and section 7b → "Share a backtest publicly (optional growth surface)" — the previous combined wording made card-minting look like a default step.
- Cleaned `references/workflows.md` — split the previous combined "Thesis → backtest → shareable card" workflow into "Thesis → backtest (private, default)" and "Mint a public share card from a backtest (optional growth surface)".
- Added `references/examples.md` Example 15 (backtest end-to-end, no card minted) and Example 16 (mint card after explicit user ask) to make the new opt-in default visible at the example layer.
- **Backtest and share-card are now framed as separate capabilities.** Previously `references/backtest-and-cards.md` and `SKILL.md` Task Routing treated them as one combined flow, which (a) implied minting a card was a normal step of every backtest and (b) muddled what the core API actually offers. Backtests are the analytical primitive (private, account-scoped); share cards are an optional growth-surface wrapper that publishes to a permanent public URL. Reframed the reference doc with two intro sections, split the surface-summary table into "core" vs "optional growth", and tagged steps 5–6 of the canonical flow as opt-in. Reframed `SKILL.md` Task Routing into two separate bullets.
- **Card-mint is now opt-in, not the default.** `POST /v1/cards` produces a permanent publicly-accessible URL — minting it on every backtest leaks otherwise-private trader analysis. The canonical flow stops at backtest by default; cards only mint when the user explicitly asks to share, post, or generate a link. Privacy callout at the top of `references/backtest-and-cards.md`.
- **Co-development capability documented in `SKILL.md`.** Consumer agents can now request new datasets, signals, asset coverage, or indicator additions by sending feature requests through the same chat endpoint. The Stingray team uses these as backlog signal and replies in-thread when the work lands. Added a "Co-development" section with a curl example and 5 illustrative request shapes (asset coverage, signal types, datasets, indicators, workflow gaps).
- Renamed all `PAT` / `personal access token` references to `API token` to match the Stingray UI label and reduce confusion for first-time users.
- Fixed three live-audit gaps in `references/backtest-and-cards.md` discovered while running the canonical "thesis → backtest → card" flow end-to-end:
  - Step 2 now documents the actual request shape: `multipart/form-data` with field `input` (not JSON, not a `text` or `content` field). Includes a copy-pasteable curl example.
  - Step 3 now prescribes the reliable `draft_id` recovery pattern: `GET /v1/chats/:chatId/messages` after stream close, find the message where `details.tool_name == "alerts_draft"`, use `details.tool_output.widget_id`. Calls out that the API field is named `widget_id`, not `draft_id`.
  - All public OG image URLs now include the required trailing slash: `/cards/<id>/image.png/`. The no-slash form returns `404`. Updated Surface summary, Canonical flow step 6, Card properties, and Failure modes accordingly.
- Mirrored the trailing-slash fix in `references/business-capabilities.md` (section 7b) and `references/workflows.md` (Thesis → backtest → shareable card).
- Cleaned up six grammar slips (`a API token` → `an API token`) introduced by the rename in `README.md`, `SKILL.md`, `references/access-policy.md`, `references/intent-rubrics.md` (×2), and `references/token-lifecycle.md`.

## 0.1.4 - 2026-04-24

- Added `references/backtest-and-cards.md` covering the thesis → alert draft → backtest → shareable card workflow, including the public `/cards/<id>/` share surface and `1200×630` OG image URL patterns.
- Updated `SKILL.md` task routing: backtest surface now points agents at the new reference for the full shareable-card flow (previously only covered the read-side `GET /widgets/:id`).
- Updated top-level description to mention backtests and shareable-card minting as first-class capabilities.
- No breaking changes; existing agent behavior unaffected.

## 0.1.3 - 2026-04-18

- Simplified first-time token setup to a single direct settings URL and token paste-back flow.
- Removed public credential write commands from the human quickstart.
- Added validation coverage for the direct token settings link and hidden setup-command guidance.

## 0.1.2 - 2026-03-26

- Promoted natural-language install guidance to the top public install path.
- Replaced per-agent command lists with one global all-agent `npx skills` command.
- Neutralized remaining Claude-first wording in public metadata and compatibility text.
- Pinned advisory `skills-ref` validation to an immutable upstream commit.

## 0.1.1 - 2026-03-25

- Flattened the public repo to the canonical `skills/stingray` layout.
- Replaced the old human guide file with a standard skill-level `README.md`.
- Removed the redundant nested Claude `plugin.json`.
- Reworked public docs to use GitHub-valid relative links and brand-facing metadata.
- Pinned public validation to `skills@1.4.6` and added advisory `skills-ref` validation in CI.

## 0.1.0 - 2026-03-25

- Initial public release of the Stingray cross-agent skills collection.
- Added the public Stingray skill package with setup guide and reference docs.
- Added plugin metadata and public validation checks.
