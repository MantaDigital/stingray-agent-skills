# Stingray

Human quickstart for the public Stingray skill bundle.

Install the skill from the repository root, then complete the one-time credential setup below.

## 1. Create a Token

Log in to [app.stingray.fi](https://app.stingray.fi) and create a PAT in **Settings → API Tokens**.

The token format starts with `sa_pat_...`.

## 2. Save Credentials Once

```bash
mkdir -p ~/.stingray
printf 'STINGRAY_PAT=sa_pat_YOUR_TOKEN_HERE\n' > ~/.stingray/credentials
chmod 600 ~/.stingray/credentials
```

Replace `sa_pat_YOUR_TOKEN_HERE` with the actual token.

## 3. Start Asking

The skill reads `~/.stingray/credentials` and uses the fixed public proxy at `https://app.stingray.fi/api/proxy`.

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
