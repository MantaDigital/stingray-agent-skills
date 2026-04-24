# Business Capabilities

Read this file when the user asks for product outcomes such as "add an alert", "look up an asset", "check my credits", or "see if WhatsApp is linked".

The point of this file is to translate business intent into the correct API token-safe route family.

## Table of Contents

1. Understand account readiness and current state
2. Research assets, tokens, and projects
3. Curate the watchlist
4. Track portfolio positions
5. Create and manage alerts
6. Read alert notifications
7. Fetch backtest results
8. Use the assistant through web or channel chats
9. Manage linked delivery channels
10. Manage referrals and attribution
11. Keep API tokens tidy

## 1. Understand account readiness and current state

Typical user requests:

- "What can this account do right now?"
- "How far through onboarding am I?"
- "Do I have Telegram or WhatsApp linked?"
- "How many credits do I have left?"
- "What has this account used recently?"

Primary routes:

- `GET /me/access`
- `GET /me`
- `GET /me/onboarding`
- `GET /me/onboarding/telegram`
- `POST /me/onboarding/telegram`
- `POST /me/onboarding/step/:step`
- `POST /me/onboarding/complete`
- `GET /me/telegram`
- `GET /me/whatsapp`
- `GET /me/credits/balance`
- `GET /me/usage`
- `GET /me/growth/status`

Notes:

- Treat `/me/access` as the account-readiness snapshot.
- Use onboarding routes when the user is asking about setup progress, not portfolio or alert state.
- Use credits and usage routes when the user is asking about quota, remaining balance, or recent activity.

## 2. Research assets, tokens, and projects

Typical user requests:

- "Find the right asset for PENDLE."
- "Look up Arbitrum and give me the entity id."
- "Show me the best matches for this ticker."

Primary routes:

- `GET /kg/search`
- `POST /kg/resolve`
- `GET /entities/:entityId/news`

Notes:

- This is entity research, disambiguation, metadata lookup, and news.
- Use `/entities/:entityId/news` after resolving an entity id to fetch normalized news for that asset.
- Do not pretend this surface is a full real-time market data API unless the returned KG payload actually provides the data needed.
- Resolve stable ids before downstream writes like watchlist, portfolio, or alerts.

## 3. Curate the watchlist

Typical user requests:

- "Add ETH and SOL to my watchlist."
- "Remove this item from my watchlist."
- "Show my watchlist."

Primary routes:

- `GET /watchlist`
- `POST /watchlist`
- `POST /watchlist/batch`
- `POST /watchlist/seed`
- `DELETE /watchlist/:itemId`

## 4. Track portfolio positions

Typical user requests:

- "Add BTC to my portfolio."
- "Update the size or cost basis on this position."
- "Show my current positions."

Primary routes:

- `GET /portfolio`
- `POST /portfolio`
- `POST /portfolio/batch`
- `PATCH /portfolio/:id`
- `DELETE /portfolio/:id`

Notes:

- `POST /portfolio` requires `asset_class` (`crypto`, `prediction_market`, or `equity`), `external_id` (a string identifier for the asset), `display_name`, `quantity` (number), and `mode` (`set`, `add`, or `subtract`).
- Use `mode: "set"` for new positions. Use `add` or `subtract` when adjusting an existing position.
- `external_id` can be a KG entity id or any stable string that identifies the asset.

## 5. Create and manage alerts

Typical user requests:

- "Create a BTC alert."
- "Alert me if BTC drops 5% and there's negative news within 2 hours."
- "Set up an RSI alert for ETH when it goes below 30."
- "Alert me if either BTC or SOL drops more than 5%."
- "Notify me when negative news hits first, then the price reacts."
- "Turn on delivery for this alert."
- "List my active alerts."

Primary routes:

- `GET /alerts`
- `GET /alerts/:alertId`
- `POST /alerts`
- `PATCH /alerts/:alertId`
- `DELETE /alerts/:alertId`

Notes:

- Alert definitions are composable block trees that can combine price, news, and technical analysis conditions with logical and temporal operators. Read `references/alert-definitions.md` for the complete block reference and construction examples.
- Resolve entity IDs and trading pairs through KG search before building definitions.
- Alert delivery still depends on Telegram DM deliverability.
- An alert task is a product automation task, not a chat task.

## 6. Read alert notifications

Typical user requests:

- "Show my recent notifications."
- "How many unread notifications do I have?"
- "Mark all notifications as read."

Primary routes:

- `GET /notifications`
- `GET /notifications/unread-count`
- `POST /notifications/read`
- `POST /notifications/read-all`

Notes:

- Notifications are alert delivery records surfaced for the current user.
- `POST /notifications/read` accepts `{"delivery_ids": ["uuid", ...]}` (max 100 per call).
- The SSE stream at `GET /notifications/stream` exists but is not part of the API token skill surface. It is a long-lived connection better suited to frontend use.

## 7. Fetch backtest results

Typical user requests:

- "Show me the backtest result for this alert."
- "Get the backtest I ran earlier."

Primary routes:

- `GET /widgets/:id`

Notes:

- Backtest results are stored with a 24-hour TTL. After expiry the endpoint returns 404.
- For the **full thesis → backtest → shareable card** flow (including minting a public share URL and OG image), read `references/backtest-and-cards.md`.

## 7b. Run a backtest and mint a shareable card

Typical user requests:

- "Run a backtest on this thesis and send me a card to share."
- "Take this setup and show how it played historically."
- "Build a DM-ready card for my BTC-breakout thesis."
- "Generate a backtest card I can post on twitter."

Primary routes:

- `POST /v1/chats/web` → chat id (agent creates the underlying draft when prompted)
- `POST /v1/chats/:chatId/messages/stream` → send the thesis; response carries the `draft_id`
- `POST /v1/alert-drafts/:id/backtest` → returns `backtest_id`
- `POST /v1/cards` with `{draft_id, backtest_id}` → returns `card_id`
- Public share: `https://stingray.fi/cards/<card_id>/`
- Public OG image: `https://stingray.fi/cards/<card_id>/image.png/` (trailing slash required; no-slash returns 404)

Notes:

- Cards are idempotent per `(user_id, backtest_snapshot_id)` — retries return the same `card_id`.
- The card watermark + referral code belong to the authenticated token's owner, not the asset being analyzed.
- Backtest snapshots expire after 24 hours; the card itself persists (separate snapshot inside `pnl_cards.display_data`).
- Full schema and thesis-mapping patterns: read `references/backtest-and-cards.md`.

## 8. Use the assistant through web or channel chats

Typical user requests:

- "Start a web chat."
- "Send this to Telegram chat."
- "Show the message history."
- "Download the image from the chat."

Primary routes:

- `POST /v1/chats/web`
- `POST /v1/chats/channels/:channel`
- `GET /v1/chats/channels`
- `GET /v1/chats`
- `GET /v1/chats/:chatId`
- `PATCH /v1/chats/:chatId`
- `DELETE /v1/chats/:chatId`
- `GET /v1/chats/:chatId/messages`
- `POST /v1/chats/:chatId/messages/stream`
- `GET /v1/attachments/:attachmentId`

Notes:

- Channel chat requires the corresponding Telegram or WhatsApp identity to already be linked.
- Attachment download is a chat follow-up action, not a generic file store operation.

## 9. Manage linked delivery channels

Typical user requests:

- "Is Telegram linked?"
- "Check my WhatsApp status."
- "Create a WhatsApp link code."
- "Disconnect WhatsApp."
- "Create a Telegram link code."
- "Disconnect Telegram."
- "Is my X account linked?"

Primary routes:

- `GET /me/telegram`
- `POST /telegram/link-code`
- `DELETE /telegram/link`
- `GET /me/whatsapp`
- `POST /whatsapp/link-code`
- `DELETE /whatsapp/link`
- `GET /me/x-link`

Notes:

- Some WhatsApp and Telegram routes are env-gated; if the route is unavailable, treat that as environment or deployment configuration, not API token denial.
- Telegram and WhatsApp both support link-code generation and disconnection via symmetric route pairs.
- X link status is read-only via `GET /me/x-link`. Linking X via `POST /x/link` requires interactive auth and is not available via API token.

## 10. Manage referrals and attribution

Typical user requests:

- "Create my referral code."
- "See what referral code I already have."
- "Attribute this account to a code."
- "Record this attribution payload."

Primary routes:

- `POST /me/attribution`
- `GET /me/referral-code`
- `POST /me/referral-code`
- `POST /me/referral-attribution`
- `GET /referrals/resolve/:code`
- `GET /public/referrals/leaderboard`

Notes:

- Attribution capture is growth instrumentation for the current user.
- Referral code resolve is public, but creating or attributing referral state is user-scoped.

## 11. Keep API tokens tidy

Typical user requests:

- "List my integration tokens."
- "Revoke old tokens."

Primary routes:

- `GET /me/api-tokens`
- `DELETE /me/api-tokens/:tokenId`

Notes:

- API token creation is intentionally excluded from the API token surface.
