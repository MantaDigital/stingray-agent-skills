# Access Policy

Read this file when you need to decide whether a PAT-backed skill can perform a task at all.

This is the public boundary reference shipped with the distributed Stingray skill package.

## Auth and First Check

- Use `Authorization: Bearer sa_pat_...`.
- Start with `GET /me/access` when the request depends on current capabilities or linked-account prerequisites.
- Treat `/me/access` as the authoritative capability snapshot for the authenticated user.

## Allowed PAT Surface

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
- Widget data fetch via `GET /widgets/:id`
- Notification routes under `/notifications*` (list, unread count, mark read, mark all read)
- Chat routes under `/v1/chats*`
- Attachment download via `GET /v1/attachments/:attachmentId`
- User-scoped growth routes via `POST /me/attribution`, `GET /me/referral-code`, and `POST /me/referral-attribution`
- Token list and revoke via `GET /me/api-tokens` and `DELETE /me/api-tokens/:tokenId`
- Public referral helpers via `GET /referrals/resolve/:code` and `GET /public/referrals/leaderboard` (these are public routes reachable without auth, not PAT-authenticated)

## Explicitly Blocked

- `POST /me/api-tokens`
- `/v1/billing*`
- `/v1/guest*`
- `/internal/*`
- `/webhooks/*`
- `/v1/tools*`
- `/debug-sentry`

Blocked PAT calls return `403` with code `api_token_not_allowed`.

## Capability Notes

- PATs can read account, access, credits, growth, usage, Telegram, and WhatsApp state.
- PATs can manage onboarding state and other account-setup flows.
- PATs can manage watchlists, portfolio, alerts, onboarding, attribution, referrals, Telegram links, and WhatsApp links.
- PATs can read alert notifications and mark them as read.
- PATs can fetch stored backtest results (24h TTL; 404 after expiry).
- PATs can use both web chat and channel chat, but channel chat still requires an already linked channel identity.
- PATs can list and revoke tokens for the same user.
- PATs cannot create tokens and cannot access billing.

## Precondition Notes

- Alert delivery activation requires Telegram DM deliverability.
- Channel chat requires a linked Telegram or WhatsApp account for the target channel.
- KG-backed flows may fail because the KG backend is unavailable; that does not mean the PAT lacks access.
