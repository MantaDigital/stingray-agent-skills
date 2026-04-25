# Examples

Read this file when you want concrete prompt patterns and the endpoint plan each one should trigger.

## Table of Contents

1. Inspect capabilities before taking action
2. Research assets and add them to the watchlist
3. Research an asset before taking any action
4. Check onboarding and readiness
5. Check credits and usage
6. Create or inspect my referral code
7. Check WhatsApp readiness
8. Clean up old API tokens but keep the current one working
9. Explain a blocked API token creation request
10. Start a channel chat safely
11. Create a composite alert combining price and news
12. Create a technical analysis alert
13. Check and manage alert notifications
14. Fetch a backtest result

## Example 1: Inspect capabilities before taking action

User request:
"Check what this API token can do before you touch my account."

Execution plan:

1. `GET /me/access`
2. Summarize the available capabilities and any linked-account prerequisites

## Example 2: Research assets and add them to the watchlist

User request:
"Find ETH and SOL, resolve the right entities, and add them to my watchlist."

Execution plan:

1. `GET /kg/search`
2. `POST /kg/resolve` if the returned ids need disambiguation
3. `POST /watchlist` or `POST /watchlist/batch`
4. `GET /watchlist`

## Example 3: Research an asset before taking any action

User request:
"Look up Pendle, show me the best asset match, and give me the stable entity id."

Execution plan:

1. `GET /kg/search`
2. `POST /kg/resolve` if the returned candidates need disambiguation
3. Return the best-match entity information without mutating watchlist or portfolio

## Example 4: Check onboarding and readiness

User request:
"Show me my onboarding status and whether alerts can be activated yet."

Execution plan:

1. `GET /me/access`
2. `GET /me/onboarding`
3. `GET /me/telegram`
4. Summarize setup progress, linked-state prerequisites, and any alert-delivery blockers

## Example 5: Check credits and usage

User request:
"How many credits do I have left, and what has this account used recently?"

Execution plan:

1. `GET /me/credits/balance`
2. `GET /me/usage`
3. Optionally `GET /me/growth/status` if the question mixes product readiness with usage

## Example 6: Create or inspect my referral code

User request:
"Create my referral code if I don't already have one, then show it to me."

Execution plan:

1. `GET /me/referral-code`
2. `POST /me/referral-code` only if the user does not already have one or explicitly wants to create one
3. Return the resulting referral code state

## Example 7: Check WhatsApp readiness

User request:
"See whether WhatsApp is already linked for this account."

Execution plan:

1. `GET /me/whatsapp`
2. Summarize linked or unlinked state and next-step guidance

## Example 8: Clean up old API tokens but keep the current one working

User request:
"List my API tokens and revoke the old integration tokens."

Execution plan:

1. `GET /me/api-tokens`
2. Confirm which `tokenId` values should be revoked
3. `DELETE /me/api-tokens/:tokenId` for those ids
4. `GET /me/api-tokens`

## Example 9: Explain a blocked API token creation request

User request:
"Create a new API token called Claude Desktop."

Execution plan:

1. Do not call `POST /me/api-tokens` with the API token
2. Explain that API token creation requires interactive registered auth
3. Provide the creation rules from `references/token-lifecycle.md` if the user needs the exact contract

## Example 10: Start a channel chat safely

User request:
"Send a Telegram chat message asking for the latest BTC setup."

Execution plan:

1. `GET /me/access`
2. `GET /me/telegram`
3. `POST /v1/chats/channels/telegram`
4. `POST /v1/chats/:chatId/messages/stream`

## Example 11: Create a composite alert combining price and news

User request:
"Alert me if BTC drops 5% and there's negative news within 2 hours."

Execution plan:

1. `GET /kg/search?q=BTC&limit=5` to resolve the entity id
2. `GET /me/access` and `GET /me/telegram` to confirm delivery readiness
3. `POST /alerts` with the following body:

```json
{
  "name": "BTC price drop + negative news",
  "description": "Alert when BTC drops 5% and negative news appears within 2 hours.",
  "definition": {
    "events": [
      {"type": "price", "trading_pair": "BTCUSDT"},
      {"type": "news", "entity_id": "00000000-0000-0000-0000-000000000001"}
    ],
    "trigger": {
      "type": "all_of",
      "within_minutes": 120,
      "conditions": [
        {"type": "price_change", "trading_pair": "BTCUSDT", "direction": "down", "threshold_pct": 5, "window_minutes": 60},
        {"type": "news_sentiment", "entity_id": "00000000-0000-0000-0000-000000000001", "polarity": "negative", "min_count": 1, "window_minutes": 60}
      ]
    },
    "output": {"severity": "high", "components": ["price", "news", "text"]}
  },
  "enabled": true,
  "cooldown_seconds": 300
}
```

4. `GET /alerts/:alertId` to verify the result

Read `references/alert-definitions.md` for the complete block reference and more definition patterns.

## Example 12: Create a technical analysis alert

User request:
"Set up an RSI alert for ETH — notify me when RSI crosses below 30 on the 1-hour timeframe."

Execution plan:

1. `GET /me/access` and `GET /me/telegram` to confirm delivery readiness
2. `POST /alerts` with the following body:

```json
{
  "name": "ETH RSI oversold",
  "definition": {
    "events": [
      {"type": "price", "trading_pair": "ETHUSDT"}
    ],
    "trigger": {
      "type": "ta_indicator",
      "trading_pair": "ETHUSDT",
      "indicator": "rsi",
      "period": 14,
      "timeframe_minutes": 60,
      "op": "crosses_below",
      "value": 30
    },
    "output": {"severity": "medium", "components": ["price", "ta"]}
  },
  "enabled": true,
  "cooldown_seconds": 300
}
```

3. `GET /alerts/:alertId` to verify the result

## Example 13: Check and manage alert notifications

User request:
"Show me my unread notifications and mark them as read."

Execution plan:

1. `GET /notifications/unread-count`
2. `GET /notifications?limit=20&offset=0`
3. `POST /notifications/read` with `{"delivery_ids": [<ids from step 2>]}`

## Example 14: Fetch a backtest result

User request:
"Get the backtest result with id abc123."

Execution plan:

1. `GET /widgets/abc123`
2. If 404, explain that results expire after 24 hours and suggest re-running through the chat assistant

## Example 15: Run a backtest end-to-end (default — no card)

User request:
"Backtest BTC crossing above 70k on the 1h chart over the past year."

Execution plan:

1. `POST /v1/chats/web` → `chat_id`
2. `POST /v1/chats/:chatId/messages/stream` (multipart, field `input`) with the natural-language thesis as draft-only:

```bash
curl -N -X POST -H "Authorization: Bearer $STINGRAY_PAT" \
  -F "input=Create a draft alert for BTCUSDT crossing above 70000 on the 1h chart. Keep it as a draft, don't deploy yet." \
  "$STINGRAY_API/v1/chats/$CHAT_ID/messages/stream"
```

3. `GET /v1/chats/:chatId/messages` → walk to the message where `details.tool_name == "alerts_draft"` → read `details.tool_output.widget_id` as `draft_id`.
4. `POST /v1/alert-drafts/:draft_id/backtest` with `{"backtest_lookback_days": 365}` → `backtest_id`.
5. `GET /widgets/:backtest_id` → display trigger count + forward returns to the user.
6. **Stop here.** Do not call `POST /v1/cards`. The backtest result is private to the user; minting a card creates a permanent public URL — only do that when the user has explicitly asked to share.

## Example 16: Mint a public share card after the user explicitly asks

User request:
"Now make me a card I can post on twitter."

Precondition: Example 15 was just run; you still have `draft_id` and `backtest_id`.

Execution plan:

1. `POST /v1/cards` with `{"draft_id": "...", "backtest_id": "..."}` → `card_id`.
2. Return the public URL `https://stingray.fi/cards/<card_id>/` (full share page) or `https://stingray.fi/cards/<card_id>/image.png/` (OG PNG, trailing slash required).
3. Optional: `POST /v1/cards/:cardId/figure-image` to upload a portrait watermark; `PATCH /v1/cards/:cardId` to edit copy after the first render.

Read `references/backtest-and-cards.md` for the privacy framing and card properties.
