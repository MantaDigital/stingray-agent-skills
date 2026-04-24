# Changelog

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
