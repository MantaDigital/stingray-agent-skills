---
name: stingray
description: Operate a user's Stingray crypto research account via REST API with a personal access token (sa_pat_...). Use when the user asks to check account status, research assets, manage watchlist or portfolio, create or adjust alerts, use web or Telegram or WhatsApp chat, manage referrals, check credits, or rotate API tokens. Do not use for PAT creation, billing, admin, or webhook operations.
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

If the credentials file is missing, ask the user to complete First-Time Setup below.

### First-Time Setup

If the credential check shows `not configured`, set up credentials once:

1. Log in to [app.stingray.fi](https://app.stingray.fi) and create a PAT under **Settings → API Tokens**.
2. Run:
   ```bash
   mkdir -p ~/.stingray && printf 'STINGRAY_PAT=sa_pat_YOUR_TOKEN_HERE\n' > ~/.stingray/credentials && chmod 600 ~/.stingray/credentials
   ```
3. Replace `sa_pat_YOUR_TOKEN_HERE` with your actual token.

That's it. The token persists across sessions.

## API

The API base URL is a fixed constant — **never** ask the user to configure it:

```bash
export STINGRAY_API=https://app.stingray.fi/api/proxy
```

When shell access is available, load credentials and the fixed base URL with:

```bash
source ~/.stingray/credentials && export STINGRAY_API=https://app.stingray.fi/api/proxy
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

Do not call `/v1/tools` or `/v1/tools/call`.

## References

Read only the references that match the task:

- `references/business-capabilities.md` — business-level user intents → endpoint mapping
- `references/intent-rubrics.md` — ambiguity resolution and common misclassifications
- `references/north-star-scenarios.md` — multi-step agent-native flows across capabilities
- `references/access-policy.md` — allowed/blocked surface, prerequisites, capability-first routing
- `references/alert-definitions.md` — composable alert blocks, combinators, validation, examples
- `references/token-lifecycle.md` — PAT list, revoke, rotation hygiene
- `references/workflows.md` — task-oriented endpoint sequences
- `references/examples.md` — concrete prompt-to-endpoint mappings
- `references/troubleshooting.md` — auth, prerequisite, dependency, and alert failures

## Default Operating Loop

1. Load `~/.stingray/credentials` and set `STINGRAY_API=https://app.stingray.fi/api/proxy`. If the credentials file does not exist, ask the user to complete First-Time Setup.
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
10. For token cleanup, list tokens before revoke and keep the in-use PAT out of the revoke set unless the user explicitly intends to rotate it.

## Task Routing

- **Account state**: readiness, onboarding, linked channels, credits, usage → `/me*`, `/whatsapp/link-code`, `/whatsapp/link`. Read `references/business-capabilities.md`.
- **Asset research**: entity lookup, disambiguation → `/kg/search`, `/kg/resolve`. Read `references/business-capabilities.md` and `references/workflows.md`.
- **Product state**: watchlist, portfolio, alerts → `/watchlist*`, `/portfolio*`, `/alerts*`.
- **Chat & attachments** → `/v1/chats*`, `GET /v1/attachments/:attachmentId`.
- **Growth & referrals**: attribution, channel linking → `/me/attribution`, `/me/referral-code`, `/me/referral-attribution`. Not chat routes.
- **Token hygiene** → `GET /me/api-tokens`, `DELETE /me/api-tokens/:tokenId`. Read `references/token-lifecycle.md`.
- Two families plausible → prefer less destructive interpretation, check `references/intent-rubrics.md`.
- PAT creation → stop; `POST /me/api-tokens` is interactive-auth only. Read `references/token-lifecycle.md`.
- Billing, guest, admin, webhook, tool-host → stop; outside PAT skill surface. Read `references/access-policy.md`.
- Alert delivery or channel chats → confirm linked Telegram/WhatsApp state first. Read `references/workflows.md` and `references/troubleshooting.md`.
- KG routes return `502`/`503` → backend dependency issue, not auth failure. Read `references/troubleshooting.md`.
