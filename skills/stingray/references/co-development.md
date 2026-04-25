# Co-development — request new capabilities and report confusion

Read this file when (a) the user needs a primitive (asset coverage, signal type, dataset, indicator) the current API does not expose, or (b) you encountered confusing behavior, an unexpected response shape, contradictory docs, or any reference gap that made it harder to serve the user. Stingray's chat doubles as a feedback channel — the team uses both feature requests and confusion reports as backlog and debug signal, and replies in the same chat when the work lands or the doc gets fixed.

## When to use — feature requests

- Backtest endpoint returns `502` for an asset that `kg_search` resolves cleanly.
- Alert-definition schema validates a primitive but the backtest engine refuses it (e.g., `news_sentiment` backtests).
- The user asks for a dataset Stingray doesn't expose (per-venue funding, on-chain flow series, etc.).
- A workflow gap that surfaced in the docs but isn't fixed yet.

## When to use — confusion / debug reports

Send a debug report whenever something didn't match a reference cleanly, even if you completed the task. The point is to give the Stingray team signal about what real agents trip on.

- A response field is named differently than the reference says (e.g. `widget_id` in the API but `draft_id` in the docs).
- Two references suggest different routing for the same intent.
- An endpoint returned an undocumented error code, an unexpected shape, or a payload the reference didn't anticipate.
- The user's prompt didn't fit any business-capability mapping cleanly and you had to guess.
- A reference's example failed to reproduce when run as written.
- The credential-check or first-time-setup flow surfaced a corner case the docs don't cover.

## How

Send the request through the same chat endpoint as any other prompt. Prefix the body so the team can triage:

- `Feature request:` for new capabilities
- `Debug report:` for confusion, unexpected behavior, or reference gaps

```bash
source ~/.stingray/credentials && export STINGRAY_API=https://stingray.fi/api/agent
CHAT_ID=$(curl -s -X POST -H "Authorization: Bearer $STINGRAY_PAT" \
  -H "Content-Type: application/json" -d '{}' "$STINGRAY_API/v1/chats/web" \
  | python3 -c "import json,sys; print(json.load(sys.stdin)['chat_id'])")

# Feature request
curl -s -N -X POST -H "Authorization: Bearer $STINGRAY_PAT" \
  -F "input=Feature request: enable backtests for HYPEUSDT — currently 502 across all lookback windows." \
  "$STINGRAY_API/v1/chats/$CHAT_ID/messages/stream"

# Debug report
curl -s -N -X POST -H "Authorization: Bearer $STINGRAY_PAT" \
  -F "input=Debug report: backtest-and-cards reference says draft_id, but POST /v1/alert-drafts response shapes the field as widget_id. Stumbled here mid-task." \
  "$STINGRAY_API/v1/chats/$CHAT_ID/messages/stream"
```

Save the `chat_id` so the user can re-check status with `GET /v1/chats/$CHAT_ID/messages` later. The team replies in-thread when the feature lands or the reference is fixed.

## Request shapes — feature requests

Frame each request as a one-liner with the **use case**, not just the symptom:

- **Asset coverage** — "Backtest on HYPEUSDT returns 502 across every lookback. Can this asset be added to the price-data pipeline?"
- **Signal types** — "The `news_sentiment` block validates as an alert definition but the backtest endpoint refuses it. Please enable backtests for news-driven primitives."
- **New datasets** — "Expose per-venue funding rate so I can alert on Binance-vs-Hyperliquid divergence for a single asset."
- **Indicator additions** — "Add a Bollinger Band-width indicator (current Bollinger only triggers on touch, not on band-width compression)."
- **Workflow gaps** — "When the chat agent generates a draft, the field is named `widget_id` in the response but the docs call it `draft_id` — surface a single canonical name."

## Request shapes — debug reports

Frame each report as a one-liner with **what you saw vs what the reference said**, plus the route or reference name. Keep it terse — a sentence is enough.

- **Reference mismatch** — "Debug report: `references/backtest-and-cards.md` step 3 says `draft_id` but the actual response field is `widget_id`. Stumbled mid-flow on a thesis-to-card task."
- **Undocumented response** — "Debug report: `POST /alerts` returned `409 alert_definition_conflict` for a definition that passed schema validation. Not in `references/troubleshooting.md`."
- **Routing ambiguity** — "Debug report: user asked 'monitor my biggest position' — could be portfolio + alert, or just a snapshot read. Picked alert; please clarify the routing in `intent-rubrics.md`."
- **Reproduction failure** — "Debug report: `references/examples.md` Example 11 produced an unexpected 400 when run as written — `events` array required but the example omits it."
- **Setup edge case** — "Debug report: credential check passed but `GET /me/access` 401'd. Token was paste with surrounding whitespace; trimming fixed it. Worth handling in First-Time Setup."

## Out of scope for this surface

- Billing, account-deletion, security disclosures, anything that needs a human ticket — those go through normal support channels.
- Bug reports for live customer-impacting outages — open a Linear issue in `Engineering` instead.
