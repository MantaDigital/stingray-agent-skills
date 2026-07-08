# Access Policy

Read this file when deciding whether the public API-token skill can perform a
task.

## Authentication

- Use `Authorization: Bearer sa_pat_...`.
- The local token is loaded from `STINGRAY_PAT` or `~/.stingray/credentials`.
- The token must include `skills:full`.
- The public skill base URL is `https://stingray.fi/api/studio/v1`.

## Allowed Public Skill Surface

The current public skill is limited to the Studio Skills API route family:

- `POST /skills/actions`
- `GET /skills/runs/{run_id}`
- `GET /skills/requests/{client_request_id}`

Allowed actions:

- `idea.intake`
- `evidence.ground`
- `signal.design`
- `artifact.accept`
- `signal.replay`
- `signal.status`
- `idea.publish`

The token authenticates as one Studio user. The API still checks ownership for
Ideas, staged artifacts, Signals, Replays, and Publications.

## Explicitly Blocked

Do not attempt these through the public skill:

- API token creation
- trading, order placement, order cancellation, signing, transfer, or delegated wallet work
- Hyperliquid account authorization or account-risk operations
- monitor enablement, pause, resume, retirement, or lifecycle mutation
- billing, admin, guest lifecycle, internal routes, webhooks, tool-host routes, Slack install, or social posting
- X link-claiming or public posting
- browser Studio access outside the Skills API family

## Publication Boundary

`idea.publish` creates a public Studio Publication. Use it only when the user
explicitly asks for a public demo, share link, browser link, publish action, or
public artifact. If the user asks only for analysis, stop at the private Replay.

## Artifact Acceptance Boundary

`artifact.accept` is explicit confirmation, not an automatic side effect. In the
first slice it accepts only staged `signal_candidate` artifacts and creates a new
committed Signal. It does not update existing Signals, accept arbitrary artifact
kinds, or enable Monitors.

## Error Handling

- Missing, malformed, unknown, or revoked tokens are auth failures.
- Tokens without `skills:full` are insufficient-scope failures.
- Idea, artifact, Signal, Replay, or Publication resources outside the token
  owner's boundary should be treated as unavailable.
- Do not echo token identifiers, raw tokens, token last-four metadata, or hidden
  source metadata to the user.
