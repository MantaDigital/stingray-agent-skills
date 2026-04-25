# Common Workflows

Read this file when the task is already inside the allowed API token surface and you need the lowest-risk endpoint order.

## Capability and account state

1. `GET /me/access`
2. `GET /me`
3. `GET /me/telegram` or `GET /me/whatsapp` if the task depends on linked channels

Use this sequence before tasks that depend on current capability or linkage state.

## Onboarding and account-readiness

1. `GET /me/onboarding`
2. `GET /me/onboarding/telegram` if Telegram setup state matters
3. `POST /me/onboarding/step/:step` only when the user explicitly wants to save progress
4. `POST /me/onboarding/complete` only when the user explicitly wants completion

Use this flow for setup-progress tasks rather than portfolio or alert queries.

## Credits, usage, and growth

1. `GET /me/credits/balance`
2. `GET /me/usage`
3. `GET /me/growth/status` if the user is asking about growth or referral-adjacent state

Use this flow when the user asks what is left, what has been consumed, or whether the account is in a growth-ready state.

## Asset research

1. `GET /kg/search?q=<term>&limit=5`
2. `POST /kg/resolve` only when you need stable ids or disambiguation
3. `GET /entities/:entityId/news` if the user wants recent news for the resolved entity
4. Return the best-match entities before performing downstream writes

Use this flow when the user is asking for asset or project information, not yet asking to mutate watchlist, portfolio, or alerts.

## Research then watchlist

1. `GET /kg/search?q=<term>&limit=5`
2. `POST /kg/resolve` only if the write needs stable ids
3. `POST /watchlist` or `POST /watchlist/batch`
4. `GET /watchlist` to verify the resulting list

## Portfolio update

1. Resolve or choose a stable entity id and display name via `GET /kg/search`
2. `POST /portfolio` with `asset_class` (crypto/prediction_market/equity), `external_id`, `display_name`, `quantity` (number), and `mode` (set/add/subtract)
3. `PATCH /portfolio/:id` only if metadata needs adjustment
4. `GET /portfolio` to verify the resulting position set

## Alert lifecycle

1. Resolve the target asset through `GET /kg/search` and `POST /kg/resolve` to get a stable `entity_id` and `trading_pair`.
2. Build the alert definition: an `events` array, a `trigger` block tree, and an `output` config. Read `references/alert-definitions.md` for the complete block reference, combinators, and examples.
3. `POST /alerts` with `name`, `definition`, and optionally `description`, `enabled`, and `cooldown_seconds`.
4. `PATCH /alerts/:alertId` to change the definition, name, enabled state, or cooldown.
5. `GET /alerts/:alertId` to verify the result.
6. `DELETE /alerts/:alertId` when cleaning up.

Before enabling delivery, confirm Telegram linkage and deliverability through `/me/access` and `/me/telegram`.

Definition validation happens at creation and update time. If the definition is rejected, check `references/troubleshooting.md` for error codes and `references/alert-definitions.md` for validation rules.

## Notification management

1. `GET /notifications/unread-count` to check if there are unread items
2. `GET /notifications?limit=20&offset=0` to list recent notifications
3. `POST /notifications/read` with `{"delivery_ids": ["uuid", ...]}` to mark specific items as read
4. `POST /notifications/read-all` to mark everything as read

Use this flow when the user asks about alerts that have fired, unread alerts, or notification state.

## Widget data fetch

1. `GET /widgets/:id` to retrieve a stored widget (backtest, price chart, etc.)

Results have a 24-hour TTL and return 404 after expiry. Widgets are created through the chat assistant; this route only retrieves stored data.

## Thesis → backtest (private, default)

Use this flow when the user wants to turn a trading thesis into a private historical-performance result. Stops at step 4 — no public artifact is created.

1. `POST /v1/chats/web` → `chat_id`.
2. `POST /v1/chats/:chatId/messages/stream` (multipart, field `input`) with the thesis prompt (e.g. "create a draft alert for BTCUSDT crossing above 70000 on the 1h chart, don't deploy yet"). The agent writes an `alert_draft` widget snapshot.
3. `GET /v1/chats/:chatId/messages` after the stream closes; find the message where `details.tool_name == "alerts_draft"` and read `details.tool_output.widget_id` — that's your `draft_id`.
4. `POST /v1/alert-drafts/:id/backtest` with body `{"backtest_lookback_days": 365}` (max 365). Returns `backtest_id`. View via `GET /widgets/:id` (24h TTL).

Read `references/backtest-and-cards.md` for body shapes, parsing patterns, and failure modes.

## Mint a public share card from a backtest (optional growth surface)

Use this flow only when the user has explicitly asked to share, post, or generate a link. Cards mint **permanent public URLs** and there is no unshare endpoint.

1. (Run the backtest flow above; capture both `draft_id` and `backtest_id`.)
2. `POST /v1/cards` with body `{"draft_id": "...", "backtest_id": "..."}`. Returns `{"card_id": "uuid"}`.
3. Share the public URL `https://stingray.fi/cards/<card_id>/` (or the OG image at `/cards/<card_id>/image.png/` — trailing slash required — for direct image embeds).

Optional: `POST /v1/cards/:cardId/figure-image` uploads a portrait watermark (right-anchored, dollar-bill-engraved style). Optional: `PATCH /v1/cards/:cardId` edits card copy.

## Chat workflow

1. `POST /v1/chats/web` for web chat or `POST /v1/chats/channels/:channel` for connected channels
2. `GET /v1/chats/:chatId/messages` if prior context matters
3. `POST /v1/chats/:chatId/messages/stream`
4. `GET /v1/attachments/:attachmentId` for image bytes referenced in history

For channel chat, verify the corresponding Telegram or WhatsApp account is already linked before step 1.

## Referrals and attribution

1. `GET /referrals/resolve/:code` if the user needs to validate a code first
2. `GET /me/referral-code` to inspect current user-owned referral state
3. `POST /me/referral-code` to create or fetch the user's code
4. `POST /me/referral-attribution` to attribute the current user
5. `POST /me/attribution` when recording growth-attribution metadata for the current user

Use this flow for growth and acquisition tasks, not alert delivery or channel chat.

## WhatsApp channel management

1. `GET /me/whatsapp`
2. `POST /whatsapp/link-code` only when the user explicitly wants to start linking
3. `DELETE /whatsapp/link` only when the user explicitly wants to disconnect it

If the route is unavailable, treat it as environment gating rather than API token denial.

## Telegram channel management

1. `GET /me/telegram`
2. `POST /telegram/link-code` only when the user explicitly wants to start linking
3. `DELETE /telegram/link` only when the user explicitly wants to disconnect it

If the route is unavailable, treat it as environment gating rather than API token denial.

## Bulk cleanup

When the user asks to delete multiple resources or "clean up everything":

1. List every affected family first:
   - `GET /alerts`
   - `GET /portfolio`
   - `GET /watchlist`
2. Present the full list to the user and confirm scope — do not assume which items to keep.
3. Delete one resource at a time using the correct DELETE endpoint for each family.
4. After all deletes, re-list every affected family to verify 0 remaining (or only the explicitly kept items remain).

Do not skip the initial list step. Do not skip the final verification step. Silent failures during delete sequences are common — the verify loop catches them.

## Token hygiene

1. `GET /me/api-tokens`
2. Decide which token ids should remain active
3. `DELETE /me/api-tokens/:tokenId` for the tokens being removed
4. `GET /me/api-tokens` to verify cleanup
