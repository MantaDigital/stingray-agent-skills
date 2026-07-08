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

## 1. Start With Hello World

The installer may only say the skill was installed. The welcome happens in your agent.

Paste this into a new agent chat:

```text
Welcome me to Stingray. Check my API token, then run the hello-world thesis: BTC pullback check, when BTCUSDT drops 3% in 24h, replay what happened next over 365 days. Create the draft Signal, run the Replay, then publish a public Studio demo link I can open in my browser. Keep live monitoring off.
```

If the token is already set, the agent will help create one public auditable demo strategy and return a browser link. If the token is missing, it will guide you through setup without asking you to paste the secret into chat.

## 2. Open the Token Page

Open [https://stingray.fi/app/settings#settings-api-tokens](https://stingray.fi/app/settings#settings-api-tokens), sign in if needed, and create an API token.

The token format starts with `sa_pat_...`.

## 3. Configure the Token

The agent will give you a one-line shell command to paste into your **terminal** (not the chat). The token never enters the agent's context. Or set `STINGRAY_PAT` in your shell config for env-var auth.

The skill deliberately does not accept tokens pasted into the agent chat — that would leak the secret into chat history and the LLM context.

## 4. Start Asking

Once the token is saved, the agent checks your Stingray Studio connection and keeps the technical route details out of the conversation unless you ask for debugging help.

Best first prompt:

```text
Welcome me to Stingray. Check my API token, then run the hello-world thesis: BTC pullback check, when BTCUSDT drops 3% in 24h, replay what happened next over 365 days. Create the draft Signal, run the Replay, then publish a public Studio demo link I can open in my browser. Keep live monitoring off.
```

The agent will check whether Stingray is connected, then show:

```text
Stingray Studio is connected.
Ready: AI-assisted thesis design → deterministic Signal → private Replay → optional Studio Publication.
Blocked: live Signal delivery outside Studio.
Next: link Telegram when you want Stingray to deliver Signals outside the app.
```

Example prompts:

> "What can my Stingray account do?"

> "Show me the best Stingray workflows I can delegate from Codex or Claude Code with this account."

> "Use Stingray to test this Hyperliquid thesis privately: ETH funding heat check. Trigger when ETH funding on Hyperliquid rises above 0.75 bps/hr. Replay the last 365 days and report event count, average gap, and whether forward-return samples are available. Do not deploy live monitoring and do not publish a public Studio link."

> "Draft a Whale Liquidation Magnet Signal for Hyperliquid BTC. Tell me which parts are supported today, which parts are live-only, and what data Stingray would need for a replay."

> "Look up Chainlink and add it to my watchlist."

> "Alert me if BTC drops 5% and there's negative news within 2 hours."

More copy-paste examples live in [`prompts.md`](prompts.md).

## What The Skill Covers

- **Agent partner workflows** — live crypto indexes, venue grounding, typed rules, private replay, and hosted monitoring for Codex, Claude Code, Cursor, and other agents
- **Current data coverage** — Binance Spot price/volume/TA, Hyperliquid funding, open interest, whale/liquidation streams, entity news, Telegram-native news sources, and KG-backed asset/entity resolution
- **Venue-aware resolution** — `/kg/search` and `/kg/resolve` for asset and market disambiguation across venues; per-entity news via `/entities/:id/news`
- **Composable typed Signals** — price + news + technical-indicator primitives, AND/OR combinators, validated before deploy
- **Hosted monitoring** — Monitors run on Stingray after your agent session ends, with delivery readiness checked first
- **Replays** — replay a thesis or Signal definition against historical data, private by default
- **News-aware signals** — news blocks compose into alerts and trigger trees alongside price and TA
- Watchlists and portfolios
- Multi-channel notifications and linked-channel handoff through Studio, Telegram, and WhatsApp; X status is inspectable
- Studio Publications, opt-in browser artifacts for sharing Replays
- Account readiness, credits, usage, referrals, token hygiene
- Co-development channel — request new assets, signals, datasets, or privacy-safe setup/debug reports through the Studio assistant

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
