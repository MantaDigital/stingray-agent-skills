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
8. Clean up old PATs but keep the current one working
9. Explain a blocked PAT creation request
10. Start a channel chat safely
11. Create a composite alert combining price and news
12. Create a technical analysis alert
13. Check and manage alert notifications
14. Fetch a backtest result

## Example 1: Inspect capabilities before taking action

User request:
"Check what this PAT can do before you touch my account."

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

## Example 8: Clean up old PATs but keep the current one working

User request:
"List my API tokens and revoke the old integration tokens."

Execution plan:

1. `GET /me/api-tokens`
2. Confirm which `tokenId` values should be revoked
3. `DELETE /me/api-tokens/:tokenId` for those ids
4. `GET /me/api-tokens`

## Example 9: Explain a blocked PAT creation request

User request:
"Create a new PAT called Claude Desktop."

Execution plan:

1. Do not call `POST /me/api-tokens` with the PAT
2. Explain that PAT creation requires interactive registered auth
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
