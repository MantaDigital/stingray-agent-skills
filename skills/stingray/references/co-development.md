# Co-Development Reports

Read this file when the agent hits a product gap, setup confusion, coverage
failure, or documentation mismatch.

## When To Report

Use a privacy-safe report when:

- a requested market or Signal primitive is not replayable today;
- `signal.design` cannot stage a candidate for a plausible thesis;
- `artifact.accept` rejects a staged artifact the docs implied was valid;
- `signal.replay` fails with a coverage or schema mismatch;
- `signal.status` or lookup routes cannot recover a run that should exist;
- onboarding copy confused the user;
- the public skill reference conflicts with the API response.

## Report Shape

Keep reports short and safe:

```text
Debug report: Hyperliquid open-interest replay was requested for BTC. Stingray treated the Signal as live-only and did not return a Replay. No token, account data, or full private prompt included.
```

```text
Setup report: Codex host, stingray skill 0.2.0, token existed in STINGRAY_PAT, but the API returned insufficient_scope. The user should recreate the token with skills:full.
```

```text
Feature request: support full strategy backtesting for accepted Signals, including entry, exit, risk, and sandboxed execution. Current public skill only exposes Signal Replay.
```

## What Never Goes Into Reports

- raw API tokens;
- token last-four values;
- private portfolio or wallet details;
- hidden prompts;
- complete private user prompts;
- account ids unless the user explicitly asks;
- publication URLs that the user did not agree to share.

## Where To Send

In the current public skill, return the report text to the user and ask whether
they want to send it to the Stingray team. Do not invent a separate feedback
endpoint. If future Studio Skills API feedback actions are added, this file
should be updated to route reports there.
