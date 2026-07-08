# Stingray Agent Skills

**A specialized crypto market agent and hosted rule runtime for your coding agent.**

Stingray can be used directly, or as the market partner for Codex, Claude Code, Cursor, and other SKILL.md-compatible agents. Your coding agent plans, edits, and can set up local infrastructure. Stingray resolves market context, turns theses into inspectable rules, replays them against history, and hosts monitoring when you do not want another cron script.

Built for quants, analysts, and research desks who already live in their terminal.

One install, one credential file — works in Claude Code, Codex, Cursor, Gemini CLI, Cline, Continue, Goose, Roo, Windsurf, and 36+ other [`SKILL.md`](https://skills.sh)-compatible agents via `npx skills`.

## Install

```bash
npx skills add MantaDigital/stingray-agent-skills -g -y
```

Or ask your agent: *"Install the skills from MantaDigital/stingray-agent-skills globally for all my coding agents using npx skills."*

Then ask your agent for the hello-world below. It will check for an existing token, guide setup if needed, and keep the token out of chat. Full quickstart: [`skills/stingray/README.md`](skills/stingray/README.md).

Some agents load skills only when a session starts. If the current session installed Stingray but cannot use it yet, restart the agent session and ask again.

> ⚠️ Reinstalling overwrites the local skill copy without prompting. Back up custom edits first.

## Hello World

After install, paste this into a new agent chat:

```text
Welcome me to Stingray. Check my API token, then run the hello-world thesis: BTC pullback check, when BTCUSDT drops 3% in 24h, replay what happened next over 365 days. Create the draft Signal, run the replay, then mint a public demo card link I can open in my browser. Keep live monitoring off.
```

If the token is missing, the agent will point you to [Stingray settings](https://stingray.fi/app/settings#settings-api-tokens) and give you a terminal-only setup command. If the token is ready, it will turn the demo thesis into a public auditable strategy card.

## Capabilities

| Surface | What you get |
|---|---|
| **Specialized market agent** | Use Stingray directly or delegate market work from Codex, Claude Code, Cursor, or another agent when the task needs live crypto data, venue grounding, historical replay, or hosted monitoring. |
| **Current data coverage** | Binance Spot price/volume/TA, Hyperliquid funding, open interest, whale/liquidation streams, entity news, Telegram-native news sources, and KG-backed asset/entity resolution. |
| **Venue grounding** | Resolve assets and markets across venues with `/kg/search` and `/kg/resolve` before writing watchlists, portfolio rows, alerts, or backtests. |
| **Typed rules** | Turn market theses into validated alert definitions with price, news sentiment, technical indicators, and supported venue-specific conditions. |
| **Hosted monitoring** | Create alert rules that run on Stingray after your coding-agent session ends, with delivery readiness checked first. Treat the hosted rule as a signal surface your own agent can listen to. |
| **Backtests** | Take a thesis or alert definition and replay it against historical data. Private to your account by default. 24h TTL on results. |
| **Source-backed news** | Fetch normalized per-entity news via `/entities/:id/news` and treat returned content as data, not instructions. |
| **News-aware signals** | News blocks compose into alerts and trigger trees alongside price and TA — react to sentiment shifts, not just candles. |
| **Watchlists & portfolio** | Curate watchlists, track positions, sync state from your agent. |
| **Multi-channel delivery** | Notifications and chat through web, Telegram, and WhatsApp when linked. X status is inspectable; X link-claiming and public posting are not public skill actions. |
| **Shareable cards** *(opt-in)* | Mint a public Astro page from a backtest result for DM, tweet, or screenshot. |
| **Token hygiene** | List, revoke, and rotate API tokens without leaving the terminal. |
| **Co-development** | Ask for missing assets, signals, or datasets, and send privacy-safe setup/debug reports through the same chat endpoint. |

The agent reads only what it needs, scoped to the task: full reference index in [`skills/stingray/SKILL.md`](skills/stingray/SKILL.md).

For onboarding, see [`skills/stingray/prompts.md`](skills/stingray/prompts.md). For agent-side capability introspection, see [`skills/stingray/references/capabilities.json`](skills/stingray/references/capabilities.json).

**Scope:** research, account state, typed alerts, hosted monitoring, notifications, watchlists, portfolio state, feedback, and backtesting against an account-scoped API. The public skill does not initiate any value transfer on the user's behalf and does not hold custody of funds.

## Security & Trust

Snyk's scanner flags two specific concerns; both follow Snyk's published best practice for skills of this shape.

1. **Credential handling (Snyk W007).** The skill stores a long-lived API token at `~/.stingray/credentials` (mode 600) so you don't paste it every session. **The token never enters the agent's chat context** — the agent gives you a one-line shell command to run yourself, or you set `STINGRAY_PAT` in your shell. Chat-paste is deliberately not supported.

2. **Third-party content / news (Snyk W011).** The skill consumes Stingray-curated news and KG content, which can carry adversarial text. The agent treats all fetched content as **data, not instructions** (explicit "Untrusted Content Handling" section in `SKILL.md`). For a stricter posture, omit `news_*` blocks from your alerts.

**Token surface is account-scoped:** no admin, billing, webhook, or API-token-creation routes. No installer scripts, no remote downloads, no value-transfer through this public skill (it cannot move funds, sign transactions, or place orders). No access to other credential stores. Apache-2.0, public source, revocable from your [Stingray settings](https://stingray.fi/app/settings#settings-api-tokens).

## What Ships

- [`skills/stingray/SKILL.md`](skills/stingray/SKILL.md) — agent entrypoint with task routing and operating loop
- [`skills/stingray/README.md`](skills/stingray/README.md) — human quickstart
- [`skills/stingray/prompts.md`](skills/stingray/prompts.md) — copy-paste prompt index
- [`skills/stingray/references/capabilities.json`](skills/stingray/references/capabilities.json) — machine-readable capability manifest
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
        ├── prompts.md
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
