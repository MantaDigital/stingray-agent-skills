# Token Lifecycle

Read this file when explaining token setup, scope, storage, or revocation.

## Token Model

- Token prefix: `sa_pat_`
- Required public skill scope: `skills:full`
- Preferred local env var: `STINGRAY_PAT`
- Optional local file: `~/.stingray/credentials`
- Plaintext tokens are shown only once by the provisioning flow.
- Tokens remain valid until revoked.

## Creation

Token creation is not exposed through the public skill. Studio Skills API tokens
are currently provisioned for the private-beta Skills API surface. Ask the user
to get a `skills:full` token from their Stingray contact or current provisioning
flow.

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

Use the current Stingray provisioning flow to revoke or rotate Studio Skills API
tokens. If future public Skills API token-management actions or browser UI are
added, update this file. For now, do not advertise token list or revoke API
routes as part of the public skill surface.

## Scope Failure

If a token exists but the API returns insufficient scope, tell the user to create
or update a token with `skills:full`.

Do not include token ids, raw token values, last-four metadata, or source
metadata in chat, debug reports, Linear, Slack, PRs, or logs.
