# Stingray

Human quickstart for the public Stingray skill bundle: a specialized crypto market agent and hosted rule runtime for Codex, Claude Code, Cursor, and other SKILL.md-compatible agents.

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

Some agents load skills only when a session starts. If the current session installed Stingray but cannot use it yet, restart the agent session and ask again.

## 1. Open the Token Page

Open [https://stingray.fi/app/settings#settings-api-tokens](https://stingray.fi/app/settings#settings-api-tokens), sign in if needed, and create an API token.

The token format starts with `sa_pat_...`.

## 2. Configure the Token

The agent will give you a one-line shell command to paste into your **terminal** (not the chat). The token never enters the agent's context. Or set `STINGRAY_PAT` in your shell config for env-var auth.

The skill deliberately does not accept tokens pasted into the agent chat — that would leak the secret into chat history and the LLM context.

## 3. Start Asking

Once the token is saved, the skill calls `https://stingray.fi/api/agent` directly.

Best first prompt:

```text
What can my Stingray account do right now?
```

The agent will check whether Stingray is connected, then show:

```text
Stingray Studio is connected.
Ready: turn a market idea into evidence, a Signal, and a private replay in /app2.
Blocked: live Signal delivery outside Studio.
Next: link Telegram when you want Signals to reach you after you leave the app.
```

Example prompts:

> "What can my Stingray account do?"

> "Show me the best Stingray workflows I can delegate from Codex or Claude Code with this account."

> "Look up Chainlink and add it to my watchlist."

> "Alert me if BTC drops 5% and there's negative news within 2 hours."

More copy-paste examples live in [`prompts.md`](prompts.md).

## What The Skill Covers

- **Agent partner workflows** — live crypto indexes, venue grounding, typed rules, private replay, and hosted monitoring for Codex, Claude Code, Cursor, and other agents
- **Current data coverage** — Binance Spot price/volume/TA, Hyperliquid funding, open interest, whale/liquidation streams, entity news, Telegram-native news sources, and KG-backed asset/entity resolution
- **Venue-aware resolution** — `/kg/search` and `/kg/resolve` for asset and market disambiguation across venues; per-entity news via `/entities/:id/news`
- **Composable typed alerts** — price + news + technical-indicator primitives, AND/OR combinators, validated before deploy
- **Hosted monitoring** — alert rules run on Stingray after your agent session ends, with delivery readiness checked first
- **Backtests** — replay a thesis or alert definition against historical data (24h-TTL widget result, account-private)
- **News-aware signals** — news blocks compose into alerts and trigger trees alongside price and TA
- Watchlists and portfolios
- Multi-channel notifications and chat through web, Telegram, and WhatsApp; X status is inspectable
- Shareable backtest cards (opt-in)
- Account readiness, credits, usage, referrals, token hygiene
- Co-development channel — request new assets, signals, datasets, or privacy-safe setup/debug reports through the same chat endpoint

## Bundle Contents

```text
skills/stingray/
├── LICENSE.txt
├── prompts.md
├── README.md
├── SKILL.md
└── references/
    ├── capabilities.json
    └── ...
```

## Support

For packaging or distribution issues, contact `dev@mantadigital.io`.
