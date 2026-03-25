# Token Lifecycle

Read this file when the task involves PAT discovery, revocation, rotation, or explaining why PAT creation is blocked.

This is the public token-lifecycle reference shipped with the distributed Stingray skill package.

## Token Model

- PAT prefix: `sa_pat_`
- The plaintext token is shown only once at creation time.
- Server storage keeps only `token_hash`; public responses expose metadata and `tokenLastFour`.
- Tokens authenticate as one canonical `user_id`.
- Tokens do not expire automatically in v1; they remain valid until revoked.

## Lifecycle Endpoints

### List tokens

- Endpoint: `GET /me/api-tokens`
- Allowed for interactive auth and PAT auth for the same user
- Use this before any revoke or rotation cleanup

### Revoke token

- Endpoint: `DELETE /me/api-tokens/:tokenId`
- Allowed for interactive auth and PAT auth for the same user
- Success response: `{ "ok": true }`
- Common errors:
  - `400` invalid `tokenId`
  - `404` token not found for the authenticated user

### Create token

- Endpoint: `POST /me/api-tokens`
- Allowed only for interactive registered auth
- PAT auth is deliberately blocked and returns `403 api_token_not_allowed`
- Reason: token minting is interactive-only to avoid recursive credential fan-out

If the user asks for PAT creation while you only have a PAT, explain the boundary instead of attempting the call.

## Rotation Hygiene

1. List existing tokens with `GET /me/api-tokens`.
2. Identify the token metadata that should remain active.
3. Revoke only the tokens that the user explicitly wants removed.
4. Re-list tokens or inspect the remaining metadata to verify cleanup.

## Creation Rules For Explanation

Use these rules only when explaining the interactive creation flow:

- `name` is required
- `name` length must be 1-64 chars
- active token names must be unique per user, case-insensitively
- creation returns both the plaintext `token` and the `api_token` metadata record
