# Changelog

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
