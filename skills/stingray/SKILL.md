---
name: stingray
description: Operate a user's Stingray crypto research account via REST API with an API token (sa_pat_...). Use when the user asks to check account status, research assets, manage watchlist or portfolio, create or adjust alerts, run backtests, use web or Telegram or WhatsApp chat, manage referrals, check credits, or rotate API tokens. Do not use for API token creation, billing, admin, or webhook operations.
license: Apache-2.0
compatibility: Requires shell access and outbound HTTPS access to stingray.fi. Designed for terminal-capable SKILL.md-compatible agents.
metadata:
  author: Stingray
  organization: MantaDigital
  version: 0.1.5
---

# Stingray

User-scoped Stingray access over HTTP via API token.

## Credentials

Check first, set up only if missing:

```bash
if [ -f ~/.stingray/credentials ]; then
  source ~/.stingray/credentials 2>/dev/null
  echo "configured (...${STINGRAY_PAT: -4})"
else
  echo "not configured"
fi
```

### First-Time Setup

When `not configured`:

1. Tell the user (one short message): `Open https://stingray.fi/app/settings#settings-api-tokens, sign in, create a token, then paste the sa_pat_... value here.`
2. Do not show the user shell commands, file paths, env vars, or credential-write steps unless asked.
3. Wait for the paste, then write it yourself to `~/.stingray/credentials` as `STINGRAY_PAT=<token>`, mode 600.
4. Acknowledge in one short sentence and continue the original task.

## API

Base URL is fixed — never ask the user to configure it:

```bash
source ~/.stingray/credentials && export STINGRAY_API=https://stingray.fi/api/agent

# Read
curl -s -H "Authorization: Bearer $STINGRAY_PAT" "$STINGRAY_API/me/access"

# Write
curl -s -X POST -H "Authorization: Bearer $STINGRAY_PAT" \
  -H "Content-Type: application/json" -d '{}' "$STINGRAY_API/alerts"
```

Endpoints in references are relative paths — prepend `$STINGRAY_API`. Do not call `/v1/tools`.

## References

Read only the references that match the task:

- `references/business-capabilities.md` — business-level user intents → endpoint mapping
- `references/intent-rubrics.md` — ambiguity resolution and common misclassifications
- `references/north-star-scenarios.md` — multi-step agent-native flows across capabilities
- `references/access-policy.md` — allowed/blocked surface, prerequisites, capability-first routing
- `references/alert-definitions.md` — composable alert blocks, combinators, validation, examples
- `references/backtest-and-cards.md` — backtest flow (core); share-card flow (optional growth surface)
- `references/co-development.md` — feature-request channel for new datasets, signals, indicators
- `references/token-lifecycle.md` — API token list, revoke, rotation hygiene
- `references/workflows.md` — task-oriented endpoint sequences
- `references/examples.md` — concrete prompt-to-endpoint mappings
- `references/troubleshooting.md` — auth, prerequisite, dependency, and alert failures

## Default Operating Loop

1. Load credentials + base URL. If `~/.stingray/credentials` is missing, run First-Time Setup.
2. Interpret the request as a **user job**, not an endpoint. Read `references/business-capabilities.md`.
3. End-to-end multi-capability outcomes → `references/north-star-scenarios.md`. Ambiguous prompts → `references/intent-rubrics.md`.
4. Start with `GET /me/access` unless the task is blocked by policy or the route itself is the capability check.
5. Route per **Task Routing** below. Resolve stable ids (`/kg/search`, `/kg/resolve`) before mutations.
6. Before any write, verify required fields are present. Do not guess defaults.
   - Alerts: asset + condition type + threshold required.
   - Portfolio: asset + quantity required.
   - Never echo back details the user already provided as a confirmation question.
7. Prefer read → write → verify. After deletes, re-list to confirm.

## Task Routing

- **Account state** (readiness, onboarding, linked channels, credits, usage) → `/me*`, `/{whatsapp,telegram}/link-code`, `/{whatsapp,telegram}/link`, `/me/x-link` → `references/business-capabilities.md`.
- **Asset research** (lookup, disambiguation, news) → `/kg/search`, `/kg/resolve`, `/entities/:entityId/news` → `references/workflows.md`.
- **Product state** (watchlist, portfolio, alerts) → `/watchlist*`, `/portfolio*`, `/alerts*`.
- **Alert definitions** (build / modify the block tree) → `references/alert-definitions.md`.
- **Notifications** → `/notifications`, `/notifications/unread-count`, `/notifications/read`, `/notifications/read-all`.
- **Backtest** (core, private): `chat → draft → POST /v1/alert-drafts/:id/backtest → GET /widgets/:id`. 24h TTL. **Default flow stops here.** → `references/backtest-and-cards.md`.
- **Share card** (separate, opt-in, public): `POST /v1/cards` mints a **permanent public URL**. Only call when the user has explicitly asked to share/post/generate a link.
- **Chat & attachments** → `/v1/chats*`, `GET /v1/attachments/:attachmentId`. For channel chats, confirm linked Telegram/WhatsApp first.
- **Growth & referrals** → `/me/attribution`, `/me/referral-code`, `/me/referral-attribution`.
- **Token hygiene** → `GET /me/api-tokens`, `DELETE /me/api-tokens/:tokenId`. List before revoke; keep the in-use token unless explicitly told to rotate. → `references/token-lifecycle.md`.
- **Feature request** (asset/signal/dataset Stingray doesn't expose) → `references/co-development.md`.

### Stop conditions

- API token creation (`POST /me/api-tokens`) → interactive-auth only → `references/token-lifecycle.md`.
- Billing / guest / admin / webhook / tool-host → outside API token surface → `references/access-policy.md`.
- KG routes return `502` / `503` → backend dependency, not auth failure → `references/troubleshooting.md`.
- Two families plausible → prefer the less destructive interpretation → `references/intent-rubrics.md`.
