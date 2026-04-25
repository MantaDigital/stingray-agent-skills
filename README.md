# Stingray Agent Skills

**Crypto research and signal infrastructure for AI agents.**

Composable alerts (price + news + technical indicators), backtests against historical data, and a knowledge graph with broad crypto-venue coverage — operated directly from your agent's CLI. Built for quants, analysts, and research desks who already live in their terminal.

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

What this is **not**: a wallet, a CEX bridge, an order-execution endpoint. It's an account-scoped read/write API for research, alerts, and backtesting.

## Security & Trust

This skill is rated **Medium Risk** by Snyk's automated scanner. That's accurate — and here's why we think it's the right tradeoff for a user-scoped account skill.

**What the skill does that the scanner flags:**
- Stores your Stingray API token at `~/.stingray/credentials` (user-only, mode 600), so you don't have to paste it into every session.
- Calls one network endpoint: `https://stingray.fi/api/agent`.
- Uses shell to read its own credential file at runtime.

**What the skill explicitly does NOT do:**
- No admin, billing, webhook, or API-token-creation surface — the token can only operate your own account.
- No installer scripts, no remote downloads, no `curl | bash`, no binary dependencies.
- No access to other credential stores (`~/.ssh`, `~/.aws`, `.env` files).
- No data exfiltration to third-party endpoints.

**Trust signals:**
- Apache-2.0, public source, ~85-line `SKILL.md` you can read in 2 minutes.
- Token is user-issued at [stingray.fi/app/settings#settings-api-tokens](https://stingray.fi/app/settings#settings-api-tokens) and revocable from the same page.
- Snyk's [ToxicSkills study](https://snyk.io/blog/toxicskills-malicious-ai-agent-skills-clawhub/) found 76 of 3,984 scanned skills carried malicious payloads. Stingray is in the 98% that don't.

If you'd rather not write the token to disk, set the `STINGRAY_PAT` environment variable in your shell instead and the skill will use it.

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
