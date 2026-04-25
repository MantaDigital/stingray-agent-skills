# Stingray Agent Skills

**Quantitative research and data infrastructure for crypto markets — operated by your AI agent.**

Composable alerts (price + news + technical indicators), backtests against historical data, and a knowledge graph with broad cross-venue coverage including Hyperliquid, Lighter, Polymarket, Kalshi, and 100+ crypto venues. Stingray ingests, correlates, and serves the data — your agent runs the loop end-to-end, so you test more hypotheses faster.

Built for quants, analysts, and research desks who already live in their terminal.

One install, one credential file — works in Claude Code, Codex, Cursor, Gemini CLI, Cline, Continue, Goose, Roo, Windsurf, and 36+ other [`SKILL.md`](https://skills.sh)-compatible agents via Vercel's `npx skills`.

## Install

```bash
npx skills add MantaDigital/stingray-agent-skills -g -y
```

Or ask your agent: *"Install the skills from MantaDigital/stingray-agent-skills globally for all my coding agents using npx skills."*

Then complete the one-time credential setup — open [stingray.fi/app/settings#settings-api-tokens](https://stingray.fi/app/settings#settings-api-tokens), create a token, paste it back into your agent. Full quickstart: [`skills/stingray/README.md`](skills/stingray/README.md).

> ⚠️ Reinstalling overwrites the local skill copy without prompting. Back up custom edits first.

## Capabilities

| Surface | What you get |
|---|---|
| **Composable alerts** | Build multi-condition alerts combining price, news sentiment, and technical indicators. Compose with AND/OR combinators. Backtest before deploying. |
| **Backtests** | Take a thesis or alert definition and replay it against historical data. Private to your account by default. 24h TTL on results. |
| **Knowledge graph** | Resolve assets across venues with `/kg/search` and `/kg/resolve`. Per-entity news via `/entities/:id/news`. |
| **News-aware signals** | News blocks compose into alerts and trigger trees alongside price and TA — react to sentiment shifts, not just candles. |
| **Watchlists & portfolio** | Curate watchlists, track positions, sync state from your agent. |
| **Multi-channel delivery** | Notifications via web, Telegram, WhatsApp, or X — link channels from the CLI. |
| **Shareable cards** *(opt-in)* | Mint a public Astro page from a backtest result for DM, tweet, or screenshot. |
| **Token hygiene** | List, revoke, and rotate API tokens without leaving the terminal. |
| **Co-development** | Ask for missing assets, signals, or datasets through the same chat endpoint — Stingray uses requests as backlog signal and replies in-thread when work lands. |

The agent reads only what it needs, scoped to the task: full reference index in [`skills/stingray/SKILL.md`](skills/stingray/SKILL.md).

**Scope:** read-side research, alerts, and backtesting against an account-scoped API. The skill does not initiate any value transfer on the user's behalf and does not hold custody of funds.

## Security & Trust

Snyk's scanner flags two specific concerns; both follow Snyk's published best practice for skills of this shape.

1. **Credential handling (Snyk W007).** The skill stores a long-lived API token at `~/.stingray/credentials` (mode 600) so you don't paste it every session. **The token never enters the agent's chat context** — the agent gives you a one-line shell command to run yourself, or you set `STINGRAY_PAT` in your shell. Chat-paste is deliberately not supported.

2. **Third-party content / news (Snyk W011).** The skill consumes Stingray-curated news and KG content, which can carry adversarial text. The agent treats all fetched content as **data, not instructions** (explicit "Untrusted Content Handling" section in `SKILL.md`). For a stricter posture, omit `news_*` blocks from your alerts.

**Token surface is account-scoped:** no admin, billing, webhook, or API-token-creation routes. No installer scripts, no remote downloads, no value-transfer (the skill cannot move funds, sign transactions, or place orders). No access to other credential stores. Apache-2.0, public source, revocable from your [Stingray settings](https://stingray.fi/app/settings#settings-api-tokens).

## What Ships

- [`skills/stingray/SKILL.md`](skills/stingray/SKILL.md) — agent entrypoint with task routing and operating loop
- [`skills/stingray/README.md`](skills/stingray/README.md) — human quickstart
- [`skills/stingray/references`](skills/stingray/references) — capability mapping, alert DSL, north-star scenarios, examples, troubleshooting

## Repository Layout

```text
.
├── .claude-plugin/
│   └── marketplace.json
├── .github/
│   └── workflows/
│       └── validate.yml
├── AGENTS.md
├── CHANGELOG.md
├── CODEOWNERS
├── CONTRIBUTING.md
├── LICENSE
├── README.md
├── scripts/
│   └── validate-public.sh
└── skills/
    └── stingray/
        ├── LICENSE.txt
        ├── README.md
        ├── SKILL.md
        └── references/
```

## Manual Install

Copy [`skills/stingray`](skills/stingray) into your agent's configured skills directory.

## Support

For packaging or distribution issues, contact `dev@mantadigital.io`.

## License

Apache-2.0. See [`LICENSE`](LICENSE).
