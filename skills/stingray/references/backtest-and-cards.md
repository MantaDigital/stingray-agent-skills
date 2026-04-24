# Backtest + Shareable Cards

Read this file when the task involves **turning a trading thesis or alert definition into a Stingray backtest result and/or a shareable card**. Typical prompts:

- "run a backtest on this thesis and make me a shareable card"
- "take this idea and show me how it played historically"
- "what would this setup have returned over the last year"
- "build a card I can DM / post on twitter"

## Surface summary

| Endpoint | Method | Purpose |
|---|---|---|
| `POST /v1/chats/web` or `/v1/chats/channels/:channel` | POST | Start chat that can create alert drafts (the agent is what turns prose into `alert_draft` snapshots) |
| `POST /v1/chats/:chatId/messages/stream` | POST | Send a thesis prompt; agent responds with a draft + attaches `draft_id` |
| `POST /v1/alert-drafts/:id/backtest` | POST | Run the backtest. Body: `{"backtest_lookback_days": 365}` (max 365). Returns a `backtest_result` widget snapshot + `backtest_id`. Idempotent-ish: 90-second mutex prevents concurrent duplicate backtests. |
| `POST /v1/cards` | POST | Mint a shareable card from `{draft_id, backtest_id}`. Returns `{card_id}`. Idempotent per `(user_id, backtest_snapshot_id)` — re-calling returns the same card. |
| `GET /widgets/:id` | GET | Fetch a stored widget (the backtest result itself, 24-hour TTL). |
| public `https://stingray.fi/cards/<card_id>/` | — | Public Astro share page. Renders OG image, portrait watermark, PnL stats, chart. No auth needed. |
| public `https://stingray.fi/cards/<card_id>/image.png` | — | 1200×630 OG PNG. Renders correctly in X/Slack/WhatsApp/Telegram previews. |

## Canonical flow

The agent chat is the authoring surface. Drafts live as `widget_snapshot` rows; they're not created by a separate REST POST. A PAT-driven workflow therefore looks like:

1. **Start or resume a chat** (`POST /v1/chats/web`). You get back a `chat_id`.
2. **Send a thesis prompt** to the chat via `POST /v1/chats/:chatId/messages/stream`. Phrase it as a natural-language alert definition — the agent will write an `alert_draft` widget snapshot and reply with the draft_id attached. Example prompt:
   > Create an alert for BTCUSDT crossing above 70000 on the 1h chart. Keep it as a draft, don't deploy yet.
3. **Extract the `draft_id`** from the streamed response. It appears in a tool-output / widget attachment section.
4. **Run the backtest** — `POST /v1/alert-drafts/<draft_id>/backtest {"backtest_lookback_days": 365}`. Returns a widget snapshot including `backtest_id` (the snapshot id).
5. **Mint the card** — `POST /v1/cards {"draft_id": "...", "backtest_id": "..."}`. Returns `{"card_id": "uuid"}`.
6. **Share** the public URL `https://stingray.fi/cards/<card_id>/` (or the OG image URL for DM-direct image embeds).

### Shortcut when the thesis already maps to a known alert-block shape

If the thesis fits a `price_cross`, `price_change`, `ta_indicator`, or `compare` block directly (see `references/alert-definitions.md`), you can skip the chat and define the alert inline via the alerts deploy endpoint — but the agent chat path is the canonical flow because it handles asset resolution, trading-pair validation, and event-subscription wiring for you.

## Thesis → alert-definition translation patterns

Most public theses fall into a small number of shapes. Below is a non-exhaustive guide — always fall back to reading `references/alert-definitions.md` for validation rules.

### Price-level call ("BTC to 70k if reclaims 65k")

```json
{
  "events": [{"type": "price", "trading_pair": "BTCUSDT"}],
  "trigger": {
    "type": "price_cross",
    "trading_pair": "BTCUSDT",
    "level": 65000,
    "direction": "above"
  },
  "output": {"severity": "medium", "components": ["price"]}
}
```

### Directional move ("ETH down 10% in 24h")

```json
{
  "events": [{"type": "price", "trading_pair": "ETHUSDT"}],
  "trigger": {
    "type": "price_change",
    "trading_pair": "ETHUSDT",
    "direction": "down",
    "threshold_pct": 10,
    "window_minutes": 1440
  },
  "output": {"severity": "medium", "components": ["price"]}
}
```

### TA-indicator call ("short SOL when RSI-14 crosses above 70 on 1h")

```json
{
  "events": [{"type": "price", "trading_pair": "SOLUSDT"}],
  "trigger": {
    "type": "ta_indicator",
    "trading_pair": "SOLUSDT",
    "indicator": "rsi",
    "period": 14,
    "timeframe_minutes": 60,
    "op": "crosses_above",
    "value": 70
  },
  "output": {"severity": "medium", "components": ["price", "ta"]}
}
```

### Golden cross / death cross ("SMA50 crosses above SMA200")

Use a `compare` block with two value-only `ta_indicator` children. See `references/alert-definitions.md` § Compare Block.

### Unmappable theses

Some theses don't fit an alert block: pure narrative ("I'm bullish crypto this cycle"), news-driven ("short ETH into ETF inflows"), event-triggered with no price condition, or macro (rates, FX). For these:

- News-driven → use `news_sentiment` or `news_keyword` primitives (need `entity_id` from `POST /kg/resolve`).
- Macro → can't backtest cleanly; decline politely.

If the thesis isn't mappable to a primitive, decline rather than guess. A bad thesis → bad backtest → bad card → damaged credibility.

## Card properties worth knowing

- Cards are **idempotent per `(user_id, backtest_snapshot_id)`** — creating a second card for the same backtest returns the same `card_id`. Safe to retry.
- Cards include the creator's `referral_url` (embedded in the share URL as `?ref=<code>`). This means card shares double as referral attribution.
- Backtest snapshots expire after **24 hours**; the card display data is a separate persistent snapshot inside `pnl_cards.display_data`, so the card itself doesn't decay.
- Cards can be edited after creation (`PATCH /v1/cards/:cardId`) — useful for tuning copy/summary if the first render feels off.
- Portrait watermark (right-anchored, dollar-bill-engraved style) uses the card creator's uploaded face photo. Upload via `POST /v1/cards/:cardId/figure-image`. Optional.
- OG image renders at `/cards/<card_id>/image.png` (light variant) and `/cards/<card_id>/dark/image.png` (dark variant). X/Slack/Telegram preview caches are path-keyed, so use different paths for each variant.

## Failure modes

| Symptom | Likely cause | Fix |
|---|---|---|
| 404 on `/v1/alert-drafts/:id/backtest` | draft was created >30 days ago or belongs to another user | re-create the draft via chat |
| 409 / "backtest already in progress" | 90-second mutex held by a concurrent backtest request | wait 90s and retry |
| backtest result has zero triggers | thesis was too narrow for the lookback window, or trading pair has sparse history | widen the window or relax the trigger threshold |
| `POST /v1/cards` returns same `card_id` on retry | idempotency key hit — not an error | use the returned card_id |
| card page loads but OG image 404s | Astro SSR cache warming on first render | wait 5-10s and re-fetch; the image is computed on-demand |
| `missing_event_subscription` from backtest | `trading_pair` in trigger doesn't have a matching `events[]` entry | add the pair to `events` (see `references/alert-definitions.md`) |

## Use with Growth work

If you're using this to build shareable cards for outreach (e.g. auto-generating a backtest card per lead's public trading thesis):

- Do not publish the card as the lead's account; it always carries the **creator's** portrait + referral code. That's a feature, not a bug — the card is your pitch.
- For scaled runs, respect the 90s backtest mutex — serialize or add jitter.
- Hand-review each generated card before DMing / replying; the backtest may return zero-trigger results that are unimpressive.
- Track `(lead_handle, thesis_text, draft_id, backtest_id, card_id, card_url, verdict)` somewhere persistent; cards are cheap to generate but expensive to misfire.

## Token scopes required

`skill_operations` (default PAT scope) is sufficient for the backtest + card endpoints. Chat endpoints (`/v1/chats/web` etc.) also work with the default PAT scope.

## Related references

- `references/alert-definitions.md` — the full block/combinator reference for thesis → definition translation
- `references/workflows.md` — broader endpoint sequences (chat workflow, alert lifecycle)
- `references/troubleshooting.md` — auth and prerequisite errors
- `references/examples.md` — concrete prompt → endpoint mappings
