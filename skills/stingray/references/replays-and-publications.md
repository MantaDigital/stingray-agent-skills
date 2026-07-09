# Replays and Studio Publications

This file covers two separate Studio outcomes:

1. **Replay** - a private, account-scoped historical test for a committed Signal.
2. **Studio Publication** - an opt-in public browser artifact created from the
   active Idea state.

## Replay

Use `signal.replay` after a committed Signal exists. If no Signal is selected,
ask for the missing Signal context or use `signal.status` to inspect available
state.

Replay results are private by default. They can be long-running, so callers
should record:

- `idea_id`
- `selected_signal_id`
- `run_id`
- `thread_id`
- `client_request_id`
- returned `resource_refs`

If the HTTP call times out or the agent loses context, recover in this order:

1. `GET /skills/runs/{run_id}` when a run id is known.
2. `GET /skills/requests/{client_request_id}` when only the caller recovery key
   is known.
3. `signal.status` when the caller has the Idea and Signal ids but not the run
   id.

## Publication

Use `idea.publish` only when the user explicitly asks for a public Studio demo,
public link, share link, browser artifact, or publish action. Do not publish just
because a Replay succeeded.

Before publishing, make sure the Idea is safe to share:

- no private portfolio details;
- no API tokens or credentials;
- no private user prompt text that should remain account-local;
- no unsupported performance claims;
- generic enough for a public demo if this is an onboarding flow.

The publication belongs to the authenticated token owner.

## Hello-World Flow

For first-run onboarding, use:

```text
BTC pullback check: when BTCUSDT drops 3% or more in 24 hours, replay what happened next over the last 365 days.
```

Recommended action sequence:

1. `idea.intake` with the thesis and the user's request for a public demo.
2. `signal.design` with the returned `idea_id`.
3. `artifact.accept` when a staged Signal candidate is returned and acceptance is
   part of the requested hello-world flow.
4. `signal.replay` with the committed Signal.
5. `signal.status` or lookup routes if the Replay is still running.
6. `idea.publish` only because the prompt explicitly asked for a public demo link.

If the user asks only for analysis, stop at the private Replay.

## Hyperliquid Fit

- Funding-rate Signals are the safest replayable Hyperliquid example today.
- Open interest, whale-position, liquidation, and mark-to-liquidation primitives
  are not supported in the public skill today.
- If Stingray returns a coverage failure, report it as coverage, not auth.

## Failure Modes

| Symptom | Likely cause | Next step |
| --- | --- | --- |
| `needs_input` | The Idea or Signal is missing required assumptions. | Ask the returned questions and retry the same action with `answers`. |
| Replay still running | The action started work that has not completed. | Use run lookup, request lookup, or `signal.status`. |
| No staged artifact | The assistant gave analysis but did not stage a Signal. | Ask whether to refine the Idea or retry `signal.design` with clearer constraints. |
| Publication refused | Idea is not active, not owned, or not safe to publish. | Keep the Replay private and explain the blocker. |
| Coverage failure | The requested market or primitive is not replayable today. | Offer a supported Signal shape or produce a privacy-safe Debug report. |
