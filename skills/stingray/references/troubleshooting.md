# Troubleshooting

Read this file when the route family is correct but the request still failed.

## Common auth failures

- `401 Unauthorized`: token missing, malformed, expired, or revoked.
- `403 api_token_not_allowed`: the route is outside PAT scope, such as billing or PAT creation.

When you hit `403 api_token_not_allowed`, stop retrying and move back to `references/access-policy.md`.

## Common precondition failures

- `400 missing_plan_key`: billing checkout was called without a `plan_key`.
- `400 invalid_*`: the route exists, but the payload or params are invalid.
- `400 invalid tokenId`: the revoke request used a malformed or non-UUID token id.
- `404 token not found`: the token id does not belong to the authenticated user or was already removed.
- `403 telegram_not_linked`: alert delivery activation was attempted without a deliverable Telegram DM path.
- `400 Telegram account not linked` or `400 WhatsApp account not linked`: channel chat resolution was attempted before the account was linked.

## Dependency issues

- KG routes may return `502` or `503`: the knowledge graph backend is unavailable or not configured.
- `/health` or `/v1/tools` may reflect tool-host unavailability: those are runtime dependencies, not PAT-surface issues.

## Alert definition validation failures

- `400 invalid_alert`: the definition is structurally invalid or missing.
- `400 invalid_uuid`: an `entity_id` in the trigger or event subscription is not a valid UUID.
- `400 invalid_trading_pair`: a `trading_pair` does not match the required format (uppercase alphanumeric, 5-30 chars).
- `400 invalid_value`: a numeric param (`threshold_pct`, `window_minutes`, `period`, `multiple`) is missing or not positive.
- `400 invalid_enum`: a param value is not in the allowed set (e.g., `direction`, `polarity`, `indicator`, `op`).
- `400 invalid_keywords`: `keywords` array is empty or contains non-string entries.
- `400 too_deep`: the block tree exceeds the maximum nesting depth (5 levels).
- `400 too_many_conditions`: the definition contains more than 10 total condition blocks.
- `400 min_conditions`: a combinator (`all_of`, `any_of`, `sequence`) has fewer than 2 conditions, or `none_of` has fewer than 1.
- `400 missing_event_subscription`: a `trading_pair` or `entity_id` in the trigger tree has no matching entry in the `events` array.
- `400 no_events`: the `events` array is empty.
- `400 invalid_output`: the output config is missing or malformed.
- `400 empty_patch`: a `PATCH` request provided no fields to update.

Read `references/alert-definitions.md` for the complete block reference, validation rules, and definition examples.

## Safe recovery pattern

1. Re-check `GET /me/access`
2. Re-check linked account state via `/me/telegram` or `/me/whatsapp`
3. Re-run the smallest read-only request that proves auth still works
4. Retry the write only after the prerequisite is confirmed
