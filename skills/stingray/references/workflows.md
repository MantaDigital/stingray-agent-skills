# Common Workflows

Read this file when the task is already inside the allowed public skill surface and you need the lowest-risk product order. Use Studio nouns with the user. Route details are implementation notes only.

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

## Replay result fetch

1. Fetch the private Replay result by id.
2. If it expired, offer to re-run the Replay in Studio.

Results have a 24-hour TTL and return 404 after expiry.

## Thesis to Replay (private, default)

Use this flow when the user wants to turn a trading thesis into a private historical-performance result. Stops at step 5. No public artifact is created.

1. Check Studio access.
2. Create or reuse an Idea for the thesis.
3. Ask the Studio assistant to shape the thesis into a draft Signal. Keep Monitor off.
4. Run a private Replay over the requested lookback.
5. Summarize trigger count, event timing, and forward-return availability.

Read `references/backtest-and-cards.md` for body shapes, parsing patterns, and failure modes.

## Publish a Studio Publication from a Replay (optional sharing surface)

Use this flow only when the user has explicitly asked to share, post, or generate a link. Publications are public browser artifacts.

1. Run the private Replay flow above.
2. Confirm the user wants a public browser link.
3. Publish a Studio Publication from the Replay.
4. Return the public browser link.

Optional: tune the title or summary if the first render feels off.

## Studio assistant workflow

1. Start or continue the Studio assistant conversation.
2. Keep context attached to the relevant Idea or Signal where possible.
3. Fetch attachments only when prior context matters.
4. For Telegram or WhatsApp handoff, verify the channel is linked first.

For channel handoff, verify the corresponding Telegram or WhatsApp account is already linked before step 1.

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
