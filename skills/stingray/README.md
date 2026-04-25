# Stingray

Human quickstart for the public Stingray skill bundle.

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

## 2. Paste It Back Into Your Agent

Paste the `sa_pat_...` token into the same agent chat.

The agent should save it for you. You should not need to run any local credential write commands.

## 3. Start Asking

Once the token is saved, the skill calls `https://stingray.fi/api/agent` directly.

Example prompts:

> "What can my Stingray account do?"

> "Look up Chainlink and add it to my watchlist."

> "Alert me if BTC drops 5% and there's negative news within 2 hours."

## What The Skill Covers

- account readiness and usage
- asset research and entity lookup
- watchlists and portfolios
- alerts and notifications
- web and channel chats
- referrals and token hygiene

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
