# Examples

Concrete prompt-to-action mappings for the Studio Skills API.

## Example 1: Hello-World Public Demo

User:

```text
Welcome me to Stingray. Check my API token, then run the hello-world thesis: BTC pullback check, when BTCUSDT drops 3% in 24h, replay what happened next over 365 days. Create the Studio Idea and Signal, run the Replay, then publish a public Studio demo link I can open in my browser. Keep live monitoring off.
```

Action sequence:

1. `idea.intake`
2. `signal.design`
3. `artifact.accept` if a staged Signal candidate is returned
4. `signal.replay`
5. `signal.status` or lookup routes if needed
6. `idea.publish` because the user explicitly asked for a public demo link

## Example 2: Private Replay

User:

```text
Replay a BTC pullback Signal privately. Do not publish.
```

Action sequence:

1. `idea.intake` if no `idea_id` exists
2. `signal.design`
3. `artifact.accept` after a staged candidate exists and acceptance is intended
4. `signal.replay`
5. `signal.status` or lookup if the run is not immediately complete
6. Stop. Do not call `idea.publish`.

## Example 3: Missing Input

If `signal.design` returns:

```json
{
  "status": "needs_input",
  "questions": [
    {
      "id": "timeframe",
      "question": "Which candle timeframe should this Signal use?",
      "required": true
    }
  ]
}
```

Ask the user the question. Then call the same action with:

```json
{
  "action": "signal.design",
  "idea_id": "existing-idea-id",
  "answers": [
    {
      "question_id": "timeframe",
      "answer": "Use 1h candles."
    }
  ]
}
```

Do not create a continuation id.

## Example 4: Hyperliquid Funding Replay

User:

```text
Use Stingray to test this Hyperliquid thesis privately: ETH funding heat check. Trigger when ETH funding on Hyperliquid rises above 0.75 bps/hr. Replay the last 365 days and report event count, average gap, and whether forward-return samples are available. Do not enable monitoring and do not publish a public Studio link.
```

Action sequence:

1. `idea.intake`
2. `evidence.ground` to confirm coverage
3. `signal.design`
4. `artifact.accept`
5. `signal.replay`
6. `signal.status` or lookup until complete
7. Stop private.

## Example 5: Unsupported Hyperliquid Primitive

User:

```text
Draft a Whale Liquidation Magnet Signal for Hyperliquid BTC and Replay it.
```

Action sequence:

1. Explain from the skill docs that whale/liquidation primitives are not supported in the public
   skill today.
2. Offer the nearest supported Hyperliquid funding-rate example.
3. Do not call `idea.intake`, `evidence.ground`, `signal.design`, or
   `signal.replay` for the unsupported primitive.

## Example 6: Recover A Timed-Out Replay

If a previous `signal.replay` returned or logged `run_id`, call:

```text
GET /skills/runs/{run_id}
```

If only `client_request_id` is known, call:

```text
GET /skills/requests/{client_request_id}
```

If the selected Signal id is known but run ids are missing, call `signal.status`.

## Example 7: Publish After Explicit Ask

User:

```text
Now publish a public Studio link for the current Idea.
```

Preconditions:

- active `idea_id`;
- committed Signal;
- Replay or other committed Idea state worth publishing;
- no private content that should remain account-local.

Action:

```text
idea.publish
```
