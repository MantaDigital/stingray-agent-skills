# Stingray Skill

Turn your AI assistant into a crypto research partner that manages your Stingray account through natural conversation.

## Install

### Claude Code

```bash
/plugin marketplace add MantaDigital/stingray-agent-skills
/plugin install stingray@stingray-agent-skills
```

### Cross-Agent With `skills.sh`

```bash
npx skills add MantaDigital/stingray-agent-skills --skill stingray --agent claude-code
npx skills add MantaDigital/stingray-agent-skills --skill stingray --agent github-copilot
npx skills add MantaDigital/stingray-agent-skills --skill stingray --agent openclaw
npx skills add MantaDigital/stingray-agent-skills --skill stingray --agent codex
```

### Manual Copy

Copy [`stingray/skills/stingray`](/workspace/stingray-agent-skills/stingray/skills/stingray) into the target agent's skills directory.

Examples:

- Claude Code: `.claude/skills/stingray`
- GitHub Copilot: `.github/skills/stingray`
- Other agents: use the agent's documented `skills` directory

## Getting Started

### 1. Create a Token

Log in to [app.stingray.fi](https://app.stingray.fi) → **Settings → API Tokens** → **Create Token**. Copy it. The token starts with `sa_pat_...`.

### 2. Save Credentials Once

```bash
mkdir -p ~/.stingray
printf 'STINGRAY_PAT=sa_pat_YOUR_TOKEN_HERE\n' > ~/.stingray/credentials
chmod 600 ~/.stingray/credentials
```

Replace `sa_pat_YOUR_TOKEN_HERE` with your actual token.

### 3. Start Asking

The skill reads `~/.stingray/credentials` and uses the fixed public API proxy at `https://app.stingray.fi/api/proxy`.

Example prompts:

> "What can my Stingray account do?"

> "Look up Chainlink and add it to my watchlist."

> "Alert me if BTC drops 5% and there's negative news within 2 hours."

## What You Can Say

### Research & Discovery

> "What is Solana? Give me a quick overview."

> "Look up Chainlink and add it to my watchlist."

> "What's in my watchlist right now?"

### Portfolio Tracking

> "I just bought 0.5 BTC at $84,000. Add it to my portfolio."

> "Show me my current portfolio positions."

> "Remove SOL from my portfolio."

### Smart Alerts

Simple:

> "Alert me if BTC drops more than 5%."

Composite:

> "Notify me when Bitcoin drops 5% AND there's negative news about it within 2 hours."

> "Set up an RSI alert for ETH — tell me when RSI crosses below 30 on the hourly chart."

> "I want to know when negative news breaks about Solana first, and then the price drops within 30 minutes."

### Account & Credits

> "How many credits do I have left?"

> "What's my usage this month?"

> "Show me my referral link."

### Chat With Stingray AI

> "Start a chat and ask what's happening with Bitcoin today."

### Channel Management

> "Is my Telegram linked? I want alert notifications there."

> "What's my WhatsApp connection status?"

### Housekeeping

> "List all my API tokens and revoke any old ones."

> "Clean up everything — delete all my alerts and clear my portfolio, but keep my watchlist."

## How It Works

The skill teaches your agent to:

1. Authenticate with the user's stored PAT.
2. Research assets through Stingray's knowledge graph.
3. Manage watchlists, portfolios, alerts, chats, referrals, and token hygiene through the public REST API.
4. Build composite alerts that combine price, news, technical indicators, and temporal logic.
5. Respect public boundaries by refusing blocked surfaces such as billing, PAT creation, and internal routes.

All API calls go through the public proxy at `app.stingray.fi`. No internal URLs or infrastructure knowledge are required.

## Package Contents

```text
stingray/skills/stingray/
├── SKILL.md
├── GUIDE.md
├── LICENSE.txt
└── references/
```

## Support

For packaging or distribution issues, contact `dev@mantadigital.io`.
