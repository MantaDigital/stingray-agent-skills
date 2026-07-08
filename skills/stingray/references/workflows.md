# Workflows

Task-oriented Studio Skills API sequences.

## Load Credentials

1. Read `STINGRAY_PAT` from the environment or `~/.stingray/credentials`.
2. Set `STINGRAY_API=https://stingray.fi/api/studio/v1`.
3. Use `Authorization: Bearer $STINGRAY_PAT`.

## Raw Thesis To Private Replay

1. `idea.intake`
2. `evidence.ground` when coverage or market context is unclear
3. `signal.design`
4. answer `needs_input` questions if returned
5. `artifact.accept` for a staged `signal_candidate`
6. `signal.replay`
7. `signal.status` or lookup routes if the Replay is long-running
8. summarize and stop private

## Raw Thesis To Public Demo

1. `idea.intake`
2. `signal.design`
3. `artifact.accept`
4. `signal.replay`
5. `signal.status` or lookup routes
6. `idea.publish`

Use this only when the user explicitly asked for a public demo or share link.

## Continue Existing Idea

1. Reuse the stored `idea_id`.
2. Choose the next action based on user intent.
3. If the previous response returned `questions`, retry the same action with
   `answers`.
4. If the previous response returned `staged_artifact_ids`, use
   `artifact.accept` only when acceptance is intended.

## Recover Long-Running Work

1. Use `GET /skills/runs/{run_id}` when available.
2. Use `GET /skills/requests/{client_request_id}` when only the caller recovery
   key is available.
3. Use `signal.status` when the selected Signal is known.
4. Retry the action only after recovery confirms there is no useful active or
   completed run.

## Hyperliquid Funding Replay

1. `idea.intake` with the funding thesis.
2. `evidence.ground` to confirm funding data coverage.
3. `signal.design`.
4. `artifact.accept`.
5. `signal.replay`.
6. Keep private unless the user explicitly asks for publication.

## Hyperliquid Live-Only Signal

1. `idea.intake`.
2. `evidence.ground`.
3. Tell the user the primitive is live-only if applicable.
4. `signal.design` if the user wants a candidate.
5. Do not call `signal.replay` unless Stingray reports Replay support.

## Privacy-Safe Debug Report

1. Complete or stop the user task.
2. Summarize the mismatch in one short `Debug report:` line.
3. Exclude tokens, private account data, and full private prompts.
