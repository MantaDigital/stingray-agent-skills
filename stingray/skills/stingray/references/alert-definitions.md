# Alert Definitions

Read this file when constructing or modifying alert definitions for `POST /alerts` or `PATCH /alerts/:alertId`.

## Table of Contents

1. [Definition Structure](#definition-structure) | 2. [Event Subscriptions](#event-subscriptions) | 3. [Price Blocks](#primitive-blocks-price) | 4. [News Blocks](#primitive-blocks-news) | 5. [TA Blocks](#primitive-blocks-technical-analysis)
6. [Combinators](#combinators) | 7. [Compare Block](#compare-block) | 8. [Output](#output-configuration) | 9. [Validation Rules](#validation-rules) | 10. [Error Codes](#validation-error-codes)
11. [Examples](#complete-examples) | 12. [Request/Response Shapes](#request-and-response-shapes)

## Definition Structure

```json
{
  "events": [...],
  "trigger": { ... },
  "output": { ... }
}
```

- `events` — declares which data streams the alert listens to.
- `trigger` — a single block (primitive or combinator). Root of the condition tree.
- `output` — controls severity and notification content.

## Event Subscriptions

Every `trading_pair` and `entity_id` referenced in the trigger tree must have a matching entry in `events`. Missing subscriptions fail with `missing_event_subscription`.

```json
{ "type": "price", "trading_pair": "BTCUSDT" }
{ "type": "news", "entity_id": "00000000-0000-0000-0000-000000000001" }
```

Price events require `trading_pair`. News events require `entity_id` only.

## Primitive Blocks: Price

Every block requires `"type"` set to the block name shown in its heading. This applies to all sections below.

### `price_change`
Fires when a pair moves by at least `threshold_pct` in the given direction over a rolling window.

| Param | Type | Required | Description |
|---|---|---|---|
| `trading_pair` | string | yes | e.g. `"BTCUSDT"` |
| `direction` | string | yes | `"up"`, `"down"`, or `"either"` |
| `threshold_pct` | number | yes | Human-readable percent. `5` = 5%. |
| `window_minutes` | integer | yes | Rolling lookback window. |

### `price_cross`
Edge-triggered. Fires once when price crosses a fixed level, does not re-fire until price moves away and crosses again. Params: `trading_pair` (string), `level` (number), `direction` (`"above"` or `"below"`).

### `volume_spike`
Fires when current volume exceeds the baseline by the given multiple.

| Param | Type | Required | Description |
|---|---|---|---|
| `trading_pair` | string | yes | |
| `multiple` | number | yes | e.g. `2.5` = 2.5x baseline. |
| `timeframe_minutes` | integer | no | Measurement window. Default `60`. |
| `baseline_minutes` | integer | yes | Window used to compute the baseline. |

## Primitive Blocks: News

### `news_sentiment`
Fires when recent articles match the given sentiment profile.

| Param | Type | Required | Description |
|---|---|---|---|
| `entity_id` | UUID | yes | |
| `polarity` | string | yes | `"positive"`, `"negative"`, or `"mixed"` |
| `min_salience` | string | no | `"low"`, `"medium"`, or `"high"` |
| `min_confidence` | string | no | `"low"`, `"medium"`, or `"high"` |
| `min_count` | integer | yes | Minimum matching articles. |
| `window_minutes` | integer | yes | |

### `news_volume`
Fires when article count for an entity exceeds a threshold. Params: `entity_id` (UUID, required), `min_count` (integer, required), `window_minutes` (integer, required).

### `news_keyword`
Fires when articles contain the specified keywords.

| Param | Type | Required | Description |
|---|---|---|---|
| `entity_id` | UUID | yes | |
| `keywords` | string[] | yes | |
| `match_mode` | string | no | `"any"` (default) or `"all"` |
| `min_count` | integer | yes | |
| `window_minutes` | integer | yes | |

## Primitive Blocks: Technical Analysis

### `ta_indicator`

Two modes: **comparison** (set both `op` and `value` — fires when condition is true) and **value-only** (omit both — returns raw numeric value for use inside `compare`). Setting one without the other fails validation.

| Param | Type | Required | Description |
|---|---|---|---|
| `trading_pair` | string | yes | |
| `indicator` | string | yes | `rsi`, `sma`, `ema`, `bb_upper`, `bb_lower`, `bb_width`, `macd`, `macd_signal`, `close` |
| `period` | integer | yes | e.g. `14` for RSI-14. |
| `timeframe_minutes` | integer | yes | Candle timeframe. |
| `op` | string | no | `<`, `>`, `<=`, `>=`, `crosses_above`, `crosses_below` |
| `value` | number | no | Threshold. Must be set with `op`, or both omitted. |

## Combinators

Combinators wrap other blocks. Max nesting depth is 5.

| Type | `conditions` min | `within_minutes` | Behavior |
|---|---|---|---|
| `all_of` | 2 | optional | Without: all children simultaneously true. With: temporal accumulation — triggers once all fire within the window, then resets. |
| `any_of` | 2 | n/a | Fires when at least one child is true. |
| `sequence` | 2 | **required** | All children must fire in order within the window. |
| `none_of` | 1 | n/a | Fires when all children are false. Useful as a negative filter inside `all_of`. |

## Compare Block

Compares numeric output from two blocks. If either side returns no value (e.g. indicator not ready), the block does not fire. Both `left` and `right` must be value-only blocks (no `op`/`value`).

| Param | Type | Required | Description |
|---|---|---|---|
| `left` | block | yes | Value-only block. |
| `op` | string | yes | `<`, `>`, `<=`, `>=`, `==` |
| `right` | block | yes | Value-only block. |
| `scale` | number | no | Multiplier applied to `right` before comparison. Default `1.0`. |
| `label` | string | no | Label shown in notifications. |

## Output Configuration

| Param | Type | Required | Description |
|---|---|---|---|
| `severity` | string | yes | `"low"`, `"medium"`, or `"high"` |
| `components` | string[] | yes | `"price"`, `"news"`, `"text"`, `"ta"` |

## Validation Rules

- Max nesting depth: 5 levels.
- Max blocks total across the trigger tree: 10.
- All `trading_pair` and `entity_id` values in the trigger must have matching events.
- Trading pair format: uppercase alphanumeric, 5 to 30 characters.
- Entity IDs must be valid UUIDs.
- Cooldown minimum: 60 seconds. Server enforces `Math.max(60, value)`.
- `all_of`, `any_of`, `sequence`: min 2 conditions. `none_of`: min 1.
- `ta_indicator`: `op` and `value` must both be set or both omitted.
- `compare`: both sides must be value-only blocks.

## Validation Error Codes

| Code | Meaning |
|---|---|
| `invalid_alert` | Top-level object is malformed. |
| `invalid_uuid` | A UUID field is not a valid UUID. |
| `invalid_trading_pair` | Trading pair fails format check. |
| `invalid_value` | A numeric field has an invalid value. |
| `invalid_enum` | A string field is not one of the allowed values. |
| `invalid_keywords` | `keywords` is empty or contains non-strings. |
| `invalid_block` | A block is malformed or missing required fields. |
| `too_deep` | Trigger tree exceeds 5 levels. |
| `too_many_conditions` | More than 10 blocks in the tree. |
| `min_conditions` | A combinator has fewer conditions than its minimum. |
| `missing_event_subscription` | A `trading_pair` or `entity_id` has no matching event. |
| `no_events` | The `events` array is empty. |
| `invalid_output` | The `output` object is malformed. |
| `invalid_components` | `components` contains an unrecognized value. |
| `invalid_definition` | The `definition` object is missing or structurally invalid. |
| `invalid_name` | Name is empty or exceeds length limit. |
| `invalid_body` | Request body could not be parsed as JSON. |
| `empty_patch` | PATCH body contains no recognized fields. |
| `invalid_cooldown` | Cooldown is not a positive integer. |
| `unknown_block_type` | A block's `type` is not recognized. |

## Complete Examples

### 1. Simple price alert — BTC drops 5% in 30 minutes

```json
{
  "name": "BTC 5% drop", "cooldown_seconds": 300, "enabled": true,
  "definition": {
    "events": [{ "type": "price", "trading_pair": "BTCUSDT" }],
    "trigger": { "type": "price_change", "trading_pair": "BTCUSDT", "direction": "down", "threshold_pct": 5, "window_minutes": 30 },
    "output": { "severity": "high", "components": ["price"] }
  }
}
```

### 2. TA crossover — ETH RSI-14 crosses below 30 on 15m chart

```json
{
  "name": "ETH RSI oversold", "cooldown_seconds": 600, "enabled": true,
  "definition": {
    "events": [{ "type": "price", "trading_pair": "ETHUSDT" }],
    "trigger": {
      "type": "ta_indicator", "trading_pair": "ETHUSDT",
      "indicator": "rsi", "period": 14, "timeframe_minutes": 15,
      "op": "crosses_below", "value": 30
    },
    "output": { "severity": "medium", "components": ["price", "ta"] }
  }
}
```

### 3. Compound: negative news + price drop (temporal `all_of`)

Both conditions must fire within 60 minutes of each other.

```json
{
  "name": "BTC negative news + drop", "cooldown_seconds": 900, "enabled": true,
  "definition": {
    "events": [{ "type": "price", "trading_pair": "BTCUSDT" },
               { "type": "news", "entity_id": "00000000-0000-0000-0000-000000000001" }],
    "trigger": {
      "type": "all_of", "within_minutes": 60,
      "conditions": [
        { "type": "news_sentiment", "entity_id": "00000000-0000-0000-0000-000000000001",
          "polarity": "negative", "min_confidence": "medium", "min_count": 3, "window_minutes": 60 },
        { "type": "price_change", "trading_pair": "BTCUSDT", "direction": "down", "threshold_pct": 3, "window_minutes": 60 }
      ]
    },
    "output": { "severity": "high", "components": ["price", "news"] }
  }
}
```

### 4. Sequence: news volume spike, then SOL drops 4%

```json
{
  "name": "SOL news then drop", "cooldown_seconds": 1800, "enabled": true,
  "definition": {
    "events": [{ "type": "price", "trading_pair": "SOLUSDT" },
               { "type": "news", "entity_id": "00000000-0000-0000-0000-000000000002" }],
    "trigger": {
      "type": "sequence", "within_minutes": 90,
      "conditions": [
        { "type": "news_volume", "entity_id": "00000000-0000-0000-0000-000000000002", "min_count": 5, "window_minutes": 30 },
        { "type": "price_change", "trading_pair": "SOLUSDT", "direction": "down", "threshold_pct": 4, "window_minutes": 60 }
      ]
    },
    "output": { "severity": "high", "components": ["price", "news", "text"] }
  }
}
```

### 5. Cross-asset comparison — BTC close > 1.5x ETH close

```json
{
  "name": "BTC/ETH ratio spike", "cooldown_seconds": 3600, "enabled": true,
  "definition": {
    "events": [{ "type": "price", "trading_pair": "BTCUSDT" }, { "type": "price", "trading_pair": "ETHUSDT" }],
    "trigger": {
      "type": "compare",
      "left":  { "type": "ta_indicator", "trading_pair": "BTCUSDT", "indicator": "close", "period": 1, "timeframe_minutes": 60 },
      "op": ">",
      "right": { "type": "ta_indicator", "trading_pair": "ETHUSDT", "indicator": "close", "period": 1, "timeframe_minutes": 60 },
      "scale": 1.5, "label": "BTC > 1.5x ETH"
    },
    "output": { "severity": "low", "components": ["price", "ta"] }
  }
}
```

### 6. `any_of` — either BTC or ETH drops 5%

```json
{
  "name": "BTC or ETH 5% drop", "cooldown_seconds": 300, "enabled": true,
  "definition": {
    "events": [{ "type": "price", "trading_pair": "BTCUSDT" }, { "type": "price", "trading_pair": "ETHUSDT" }],
    "trigger": {
      "type": "any_of",
      "conditions": [
        { "type": "price_change", "trading_pair": "BTCUSDT", "direction": "down", "threshold_pct": 5, "window_minutes": 30 },
        { "type": "price_change", "trading_pair": "ETHUSDT", "direction": "down", "threshold_pct": 5, "window_minutes": 30 }
      ]
    },
    "output": { "severity": "high", "components": ["price"] }
  }
}
```

### 7. Deeply nested — `all_of` + `sequence` + `none_of` filter

SOL volume spike AND (keyword news then price drop), but not when strong positive sentiment is active. Three levels of nesting.

```json
{
  "name": "SOL exploit alert", "cooldown_seconds": 1800, "enabled": true,
  "definition": {
    "events": [{ "type": "price", "trading_pair": "SOLUSDT" },
               { "type": "news", "entity_id": "00000000-0000-0000-0000-000000000003" }],
    "trigger": {
      "type": "all_of", "within_minutes": 120,
      "conditions": [
        { "type": "volume_spike", "trading_pair": "SOLUSDT", "multiple": 2.0, "timeframe_minutes": 60, "baseline_minutes": 1440 },
        {
          "type": "sequence", "within_minutes": 90,
          "conditions": [
            { "type": "news_keyword", "entity_id": "00000000-0000-0000-0000-000000000003",
              "keywords": ["hack", "exploit", "vulnerability"], "match_mode": "any", "min_count": 2, "window_minutes": 30 },
            { "type": "price_change", "trading_pair": "SOLUSDT", "direction": "down", "threshold_pct": 6, "window_minutes": 60 }
          ]
        },
        {
          "type": "none_of",
          "conditions": [
            { "type": "news_sentiment", "entity_id": "00000000-0000-0000-0000-000000000003",
              "polarity": "positive", "min_confidence": "high", "min_count": 3, "window_minutes": 60 }
          ]
        }
      ]
    },
    "output": { "severity": "high", "components": ["price", "news", "ta", "text"] }
  }
}
```

## Request and Response Shapes

### POST /alerts — request body

```json
{ "name": "string (required)", "cooldown_seconds": 300, "enabled": true,
  "definition": { "events": [...], "trigger": { ... }, "output": { ... } } }
```

### POST /alerts — response (201)

```json
{ "id": "00000000-0000-0000-0000-000000000004", "name": "BTC 5% drop",
  "cooldown_seconds": 300, "enabled": true,
  "definition": { "events": [...], "trigger": { ... }, "output": { ... } },
  "created_at": "2026-03-22T10:00:00.000Z", "updated_at": "2026-03-22T10:00:00.000Z" }
```

### PATCH /alerts/:alertId

Send only the fields you want to change. At least one field is required (empty body returns `empty_patch`). When patching `definition`, send the full definition object — partial updates are not supported.

```json
{ "name": "updated name", "cooldown_seconds": 600, "enabled": false,
  "definition": { "events": [...], "trigger": { ... }, "output": { ... } } }
```

Response (200) has the same shape as POST, with updated fields and `updated_at`.
