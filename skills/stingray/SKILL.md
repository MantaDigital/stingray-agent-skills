---
name: stingray
description: Operate a user's Stingray crypto research account via REST API with an API token (sa_pat_...). Use when the user asks to check account status, research assets, manage watchlist or portfolio, create or adjust alerts, run backtests, mint shareable backtest cards, use web or Telegram or WhatsApp chat, manage referrals, check credits, or rotate API tokens. Do not use for API token creation, billing, admin, or webhook operations.
license: Apache-2.0
compatibility: Requires shell access and outbound HTTPS access to stingray.fi. Designed for terminal-capable SKILL.md-compatible agents.
metadata:
  author: Stingray
  organization: MantaDigital
  version: 0.1.5
---

# Stingray

Use this skill for user-scoped Stingray access over HTTP.

## Credential Check

If shell access is available, check whether credentials already exist:

```bash
if [ -f ~/.stingray/credentials ]; then
  source ~/.stingray/credentials 2>/dev/null
  echo "configured (...${STINGRAY_PAT: -4})"
else
  echo "not configured"
fi
```

If the credentials file is missing, ask the user to complete the credential setup steps below.

### First-Time Setup

If the credential check shows `not configured`, set up credentials once:

1. Send one short user-facing message only:
   - `Open https://stingray.fi/app/settings#settings-api-tokens, sign in if needed, create a token, then paste the sa_pat_... token here.`
2. Do not show the user shell commands, file paths, environment variables, debug details, or credential write steps unless they explicitly ask.
3. Wait for the user to paste the token back into the chat.
4. After the user sends the token, write it yourself to `~/.stingray/credentials` as `STINGRAY_PAT=<token>` and lock the file to user-only permissions.
5. Acknowledge setup in one short sentence, then continue with the original task.

## API

The API base URL is a fixed constant — **never** ask the user to configure it:

```bash
export STINGRAY_API=https://stingray.fi/api/agent
```

When shell access is available, load credentials and the fixed base URL with:

```bash
source ~/.stingray/credentials && export STINGRAY_API=https://stingray.fi/api/agent
```

Endpoints below are written as relative paths (e.g. `/me/access`). Construct the full URL by prepending `$STINGRAY_API`:

```bash
# Read
curl -s -H "Authorization: Bearer $STINGRAY_PAT" "$STINGRAY_API/me/access"

# Write (JSON body)
curl -s -X POST -H "Authorization: Bearer $STINGRAY_PAT" \
  -H "Content-Type: application/json" -d '{}' "$STINGRAY_API/alerts"

# Delete
curl -s -X DELETE -H "Authorization: Bearer $STINGRAY_PAT" \
  "$STINGRAY_API/me/api-tokens/TOKEN_ID"
```

Do not call `/v1/tools`.

## References

Read only the references that match the task:

- `references/business-capabilities.md` — business-level user intents → endpoint mapping
- `references/intent-rubrics.md` — ambiguity resolution and common misclassifications
- `references/north-star-scenarios.md` — multi-step agent-native flows across capabilities
- `references/access-policy.md` — allowed/blocked surface, prerequisites, capability-first routing
- `references/alert-definitions.md` — composable alert blocks, combinators, validation, examples
- `references/backtest-and-cards.md` — thesis → alert draft → backtest → shareable card flow; OG/public URL shapes
- `references/token-lifecycle.md` — API token list, revoke, rotation hygiene
- `references/workflows.md` — task-oriented endpoint sequences
- `references/examples.md` — concrete prompt-to-endpoint mappings
- `references/troubleshooting.md` — auth, prerequisite, dependency, and alert failures

## Default Operating Loop

1. Load `~/.stingray/credentials` and set `STINGRAY_API=https://stingray.fi/api/agent`. If the credentials file does not exist, ask the user to complete First-Time Setup.
2. Interpret the request as a user job, not an endpoint. Read `references/business-capabilities.md` for product-language prompts like "add an alert", "look up this asset", "check my credits".
3. If the prompt implies an end-to-end outcome across multiple jobs, read `references/north-star-scenarios.md` before planning.
4. If the prompt is ambiguous, read `references/intent-rubrics.md` before choosing a route family.
5. Start with `GET /me/access` unless the task is already blocked by policy or the route itself is the capability check.
6. Route the task per Task Routing below. Resolve stable ids before mutations when the user names assets or projects rather than ids.
7. Before any write, verify the request provides all required fields. Do not guess defaults for write operations.
   - Alerts: asset, condition type, and threshold required. If all present → proceed. If any missing or vague (e.g. "add an alert for ETH") → ask to clarify.
   - Portfolio: asset and quantity required. If all present → proceed.
   - Never echo back details the user already provided as a confirmation question.
8. Prefer read → write → verify loops. After any mutation, do the smallest read that proves the new state. After deletes, list remaining resources to confirm nothing was missed.
9. For chats, create or resolve the chat first, optionally load history, then call the stream endpoint.
10. For token cleanup, list tokens before revoke and keep the in-use API token out of the revoke set unless the user explicitly intends to rotate it.

## Task Routing

- **Account state**: readiness, onboarding, linked channels, credits, usage → `/me*`, `/whatsapp/link-code`, `/whatsapp/link`, `/telegram/link-code`, `/telegram/link`, `/me/x-link`. Read `references/business-capabilities.md`.
- **Asset research**: entity lookup, disambiguation, news → `/kg/search`, `/kg/resolve`, `/entities/:entityId/news`. Read `references/business-capabilities.md` and `references/workflows.md`.
- **Product state**: watchlist, portfolio, alerts → `/watchlist*`, `/portfolio*`, `/alerts*`.
- **Notifications**: alert delivery records → `/notifications`, `/notifications/unread-count`, `/notifications/read`, `/notifications/read-all`.
- **Backtest** (core capability): `chat → draft → POST /v1/alert-drafts/:id/backtest → GET /widgets/:id`. Private to the user, 24h TTL. The default flow stops here. Read `references/backtest-and-cards.md` for the canonical sequence and parsing patterns.
- **Public share card** (separate, optional growth-surface wrapper around a backtest): `POST /v1/cards` mints a **permanent public URL** at `stingray.fi/cards/<id>/`. **Not a default action.** Only call when the user has explicitly asked to share, post, or generate a link. Treat cards as a marketing/sharing convenience, not part of the analytical surface.
- **Chat & attachments** → `/v1/chats*`, `GET /v1/attachments/:attachmentId`.
- **Growth & referrals**: attribution, channel linking → `/me/attribution`, `/me/referral-code`, `/me/referral-attribution`. Not chat routes.
- **Token hygiene** → `GET /me/api-tokens`, `DELETE /me/api-tokens/:tokenId`. Read `references/token-lifecycle.md`.
- Two families plausible → prefer less destructive interpretation, check `references/intent-rubrics.md`.
- API token creation → stop; `POST /me/api-tokens` is interactive-auth only. Read `references/token-lifecycle.md`.
- Billing, guest, admin, webhook, tool-host → stop; outside API token skill surface. Read `references/access-policy.md`.
- Alert delivery or channel chats → confirm linked Telegram/WhatsApp state first via `/me/telegram`, `/me/whatsapp`. Read `references/workflows.md` and `references/troubleshooting.md`.
- KG routes return `502`/`503` → backend dependency issue, not auth failure. Read `references/troubleshooting.md`.

## Co-development — request new datasets, signals, or features

Stingray's chat doubles as a **feature-request channel.** When the user needs a primitive, asset, signal, or dataset the current API doesn't expose, send the request through the chat — the Stingray team uses these as a backlog signal and replies in the same chat when the feature ships.

Common asks worth surfacing through the chat:

- **Asset coverage** — "Backtest on HYPEUSDT returns 502 across every lookback. Can this asset be added to the price-data pipeline?"
- **Signal types** — "The `news_sentiment` block validates as an alert definition but the backtest endpoint refuses it. Please enable backtests for news-driven primitives."
- **New datasets** — "Expose per-venue funding rate so I can alert on Binance-vs-Hyperliquid divergence for a single asset."
- **Indicator additions** — "Add a Bollinger Band-width indicator (current Bollinger only triggers on touch, not on band-width compression)."
- **Workflow gaps** — "When the chat agent generates a draft, the `widget_id` field is named `draft_id` in the prompt body but `widget_id` in the response — surface a single canonical name."

Send via the same chat endpoint as any other prompt:

```bash
source ~/.stingray/credentials && export STINGRAY_API=https://stingray.fi/api/agent
CHAT_ID=$(curl -s -X POST -H "Authorization: Bearer $STINGRAY_PAT" \
  -H "Content-Type: application/json" -d '{}' "$STINGRAY_API/v1/chats/web" \
  | python3 -c "import json,sys; print(json.load(sys.stdin)['chat_id'])")

curl -s -N -X POST -H "Authorization: Bearer $STINGRAY_PAT" \
  -F "input=Feature request: enable backtests for HYPEUSDT — currently 502 across all lookback windows. Use case: HL-cohort traders want their native token backtestable." \
  "$STINGRAY_API/v1/chats/$CHAT_ID/messages/stream"
```

Frame each request as a one-liner with the **use case**, not just the symptom — that helps prioritization. Save the `chat_id` so the user can re-check status with `GET /v1/chats/$CHAT_ID/messages` later; the team replies in-thread when the feature lands.

Do not file feature requests via this surface for billing, account-deletion, security disclosures, or anything that needs a human ticket — those still go through the normal support channels.
