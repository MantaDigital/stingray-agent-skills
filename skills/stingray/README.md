# Stingray

Human quickstart for the public Stingray skill bundle — quantitative research and data infrastructure for crypto markets, operated by AI agents (composable alerts, backtests, knowledge graph spanning Hyperliquid, Lighter, Polymarket, Kalshi, and 100+ venues).

## Install

### Recommended: Ask Your Agent

Ask your agent:

```text
Install the skills from MantaDigital/stingray-agent-skills globally for all my coding agents using npx skills.
```

### With `skills.sh` / `npx skills`

```bash
npx skills add MantaDigital/stingray-agent-skills -g -y
```

Install the skill from the repository root, then complete the one-time credential setup below.

## 1. Open the Token Page

Open [https://stingray.fi/app/settings#settings-api-tokens](https://stingray.fi/app/settings#settings-api-tokens), sign in if needed, and create an API token.

The token format starts with `sa_pat_...`.

## 2. Configure the Token

The agent will give you a one-line shell command to paste into your **terminal** (not the chat). The token never enters the agent's context. Or set `STINGRAY_PAT` in your shell config for env-var auth.

The skill deliberately does not accept tokens pasted into the agent chat — that would leak the secret into chat history and the LLM context.

## 3. Start Asking

Once the token is saved, the skill calls `https://stingray.fi/api/agent` directly.

Example prompts:

> "What can my Stingray account do?"

> "Look up Chainlink and add it to my watchlist."

> "Alert me if BTC drops 5% and there's negative news within 2 hours."

## What The Skill Covers

- **Composable alerts** — price + news + technical-indicator primitives, AND/OR combinators, validated before deploy
- **Backtests** — replay a thesis or alert definition against historical data (24h-TTL widget result, account-private)
- **Knowledge graph** — `/kg/search` and `/kg/resolve` for asset disambiguation across venues; per-entity news via `/entities/:id/news`
- **News-aware signals** — news blocks compose into alerts and trigger trees alongside price and TA
- Watchlists and portfolios
- Multi-channel notifications (web, Telegram, WhatsApp, X)
- Shareable backtest cards (opt-in)
- Account readiness, credits, usage, referrals, token hygiene
- Co-development channel — request new assets, signals, or datasets through the same chat endpoint

## Bundle Contents

```text
skills/stingray/
├── LICENSE.txt
├── README.md
├── SKILL.md
└── references/
```

## Support

For packaging or distribution issues, contact `dev@mantadigital.io`.
