# Access Policy

Read this file when you need to decide whether an API token-backed skill can perform a task at all.

This is the public boundary reference shipped with the distributed Stingray skill package.

## Auth and First Check

- Use `Authorization: Bearer sa_pat_...`.
- Start with `GET /me/access` when the request depends on current capabilities or linked-account prerequisites.
- Treat `/me/access` as the authoritative capability snapshot for the authenticated user.

## Allowed Public Skill Surface

- Account and state under `/me*`, except `POST /me/api-tokens`
- Onboarding, credits, usage, growth, Telegram state, WhatsApp state, referral code, and attribution all live inside that account surface
- WhatsApp channel-management routes via `POST /whatsapp/link-code` and `DELETE /whatsapp/link`
- Telegram channel-management routes via `POST /telegram/link-code` and `DELETE /telegram/link`
- X link status via `GET /me/x-link` (read-only; `POST /x/link` is interactive-only)
- Entity news via `GET /entities/:entityId/news`
- Entity lookup under `/kg/search` and `/kg/resolve`
- Watchlist routes under `/watchlist*`
- Portfolio routes under `/portfolio*`
- Alert routes under `/alerts*`
- Private Replay result fetch
- Notification routes under `/notifications*` (list, unread count, mark read, mark all read)
- Studio assistant and linked-channel handoff
- Attachment download when scoped to an assistant conversation
- User-scoped growth routes via `POST /me/attribution`, `GET /me/referral-code`, and `POST /me/referral-attribution`
- Token list and revoke via `GET /me/api-tokens` and `DELETE /me/api-tokens/:tokenId`
- Public referral helpers via `GET /referrals/resolve/:code` and `GET /public/referrals/leaderboard` (these are public routes reachable without auth, not API token-authenticated)

## Explicitly Blocked

- `POST /me/api-tokens`
- `/hl/authorizations*`
- `/hl/delegation/*`
- `/hl/approvals`
- `/hl/orders`
- `/hl/cancels`
- `/x/link`
- Billing routes
- Guest lifecycle routes
- `/internal/*`
- `/webhooks/*`
- Tool-host routes
- `/slack/install-url`
- `/debug-sentry`

Blocked API token calls return `403` with code `api_token_not_allowed`.

## Capability Notes

- API tokens can read account, access, credits, growth, usage, Telegram, and WhatsApp state.
- API tokens can manage onboarding state and other account-setup flows.
- API tokens can manage watchlists, portfolio, alerts, onboarding, attribution, referrals, Telegram links, and WhatsApp links.
- API tokens can read alert notifications and mark them as read.
- API tokens can fetch stored Replay results (24h TTL; 404 after expiry).
- API tokens can use the Studio assistant for assistant work, feature requests, debug reports, and privacy-safe setup reports.
- API tokens can use linked-channel handoff, but channel handoff still requires an already linked channel identity.
- API tokens can list and revoke tokens for the same user.
- API tokens cannot create tokens, access billing, install Slack, link X, place or cancel orders, manage delegated wallets, or use internal/social posting routes.

## Precondition Notes

- Alert delivery activation requires Telegram DM deliverability.
- Channel handoff requires a linked Telegram or WhatsApp account for the target channel.
- KG-backed flows may fail because the KG backend is unavailable; that does not mean the API token lacks access.
