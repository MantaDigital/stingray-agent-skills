# North-Star Scenarios

These are multi-step product loops external agents should be able to complete
through the public skill.

## 1. Public Demo From A Generic Thesis

Goal: create a public artifact that demonstrates Stingray without exposing
private user data.

Flow:

1. `idea.intake`
2. `signal.design`
3. `artifact.accept`
4. `signal.replay`
5. `signal.status` or lookup
6. `idea.publish`

Use a generic thesis such as BTC pullback. Keep live monitoring off.

## 2. Private Research Loop

Goal: help the user reason about a thesis before sharing or activating anything.

Flow:

1. `idea.intake`
2. `evidence.ground`
3. `signal.design`
4. ask questions if `needs_input`
5. stop at staged candidate unless the user wants acceptance

## 3. Closed Signal Replay Loop

Goal: start from a raw idea, create a committed Signal, and privately Replay it.

Flow:

1. `idea.intake`
2. `signal.design`
3. `artifact.accept`
4. `signal.replay`
5. `signal.status` or lookup routes
6. summarize the Replay and keep it private

## 4. Hyperliquid Funding Replay

Goal: show a concrete Hyperliquid workflow that is replayable today.

Flow:

1. `idea.intake`
2. `evidence.ground` to confirm funding coverage
3. `signal.design`
4. `artifact.accept`
5. `signal.replay`
6. summarize event count, clustering/gap, and forward-return availability when
   returned

## 5. Hyperliquid Live-Only Design

Goal: let users explore OI, whale, liquidation, or mark-to-liquidation Signals
without overpromising Replay.

Flow:

1. `idea.intake`
2. `evidence.ground`
3. explain live-only boundary
4. `signal.design` if the user wants a candidate
5. stop before Replay unless Stingray reports support

## 6. External-Agent Recovery

Goal: recover from timeout, lost context, or long-running Replay.

Flow:

1. use `run_id` lookup when available;
2. use `client_request_id` lookup when only caller recovery key is available;
3. use `signal.status` when Idea and Signal ids are known;
4. retry only if recovery shows no active or completed run.

## 7. Publication After Review

Goal: publish only after the user has inspected the private result.

Flow:

1. summarize the private Replay;
2. ask whether the user wants a public Studio Publication if they have not
   already asked;
3. call `idea.publish` only after explicit consent.
