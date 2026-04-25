# Co-development — request new datasets, signals, or features

Read this file when the user needs a primitive (asset coverage, signal type, dataset, indicator) the current API does not expose. Stingray's chat doubles as a feature-request channel — the team uses these as a backlog signal and replies in the same chat when the feature ships.

## When to use

- Backtest endpoint returns `502` for an asset that `kg_search` resolves cleanly.
- Alert-definition schema validates a primitive but the backtest engine refuses it (e.g., `news_sentiment` backtests).
- The user asks for a dataset Stingray doesn't expose (per-venue funding, on-chain flow series, etc.).
- A workflow gap that surfaced in the docs but isn't fixed yet.

## How

Send the request through the same chat endpoint as any other prompt:

```bash
source ~/.stingray/credentials && export STINGRAY_API=https://stingray.fi/api/agent
CHAT_ID=$(curl -s -X POST -H "Authorization: Bearer $STINGRAY_PAT" \
  -H "Content-Type: application/json" -d '{}' "$STINGRAY_API/v1/chats/web" \
  | python3 -c "import json,sys; print(json.load(sys.stdin)['chat_id'])")

curl -s -N -X POST -H "Authorization: Bearer $STINGRAY_PAT" \
  -F "input=Feature request: enable backtests for HYPEUSDT — currently 502 across all lookback windows. Use case: HL-cohort traders want their native token backtestable." \
  "$STINGRAY_API/v1/chats/$CHAT_ID/messages/stream"
```

Save the `chat_id` so the user can re-check status with `GET /v1/chats/$CHAT_ID/messages` later. The team replies in-thread when the feature lands.

## Request shapes

Frame each request as a one-liner with the **use case**, not just the symptom:

- **Asset coverage** — "Backtest on HYPEUSDT returns 502 across every lookback. Can this asset be added to the price-data pipeline?"
- **Signal types** — "The `news_sentiment` block validates as an alert definition but the backtest endpoint refuses it. Please enable backtests for news-driven primitives."
- **New datasets** — "Expose per-venue funding rate so I can alert on Binance-vs-Hyperliquid divergence for a single asset."
- **Indicator additions** — "Add a Bollinger Band-width indicator (current Bollinger only triggers on touch, not on band-width compression)."
- **Workflow gaps** — "When the chat agent generates a draft, the field is named `widget_id` in the response but the docs call it `draft_id` — surface a single canonical name."

## Out of scope for this surface

- Billing, account-deletion, security disclosures, anything that needs a human ticket — those go through normal support channels.
- Bug reports for live customer-impacting outages — open a Linear issue in `Engineering` instead.
