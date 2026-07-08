# Token Lifecycle

Read this file when explaining token setup, scope, storage, or revocation.

## Token Model

- Token prefix: `sa_pat_`
- Required public skill scope: `skills:full`
- Preferred local env var: `STINGRAY_PAT`
- Optional local file: `~/.stingray/credentials`
- Plaintext tokens are shown only once in Studio settings.
- Tokens remain valid until revoked.

## Creation

Token creation is interactive. Send the user to:

```text
https://stingray.fi/app/settings#settings-api-tokens
```

Do not try to create a token from an API-token-authenticated agent. Do not ask
the user to paste the token into chat.

## Local Storage

The agent may give the user a terminal command that writes:

```text
STINGRAY_PAT=<token>
```

to `~/.stingray/credentials` with mode 600, or the user may place the token in
their shell environment. The secret stays in their terminal.

## Revocation

Users should revoke tokens from Stingray settings. If future public Skills API
token-management actions are added, update this file. For now, do not advertise
token list or revoke API routes as part of the public skill surface.

## Scope Failure

If a token exists but the API returns insufficient scope, tell the user to create
or update a token with `skills:full`.

Do not include token ids, raw token values, last-four metadata, or source
metadata in chat, debug reports, Linear, Slack, PRs, or logs.
