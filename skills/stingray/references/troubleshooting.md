# Troubleshooting

## Token Missing

Run the credential check from `SKILL.md`. If no token is found, explain that the
user needs a private-beta Studio Skills API token with `skills:full`, then give
the terminal-only setup command once they have it. Do not accept chat-pasted
tokens.

## Insufficient Scope

Symptom: the API says the token lacks `skills:full`.

Fix: ask the user to get a Studio Skills API token with `skills:full` from the
current Stingray provisioning flow.

## `needs_input`

The API is asking for missing context. Ask only the returned questions, then
retry the same action with:

- the same `idea_id`;
- `answers` containing each `question_id` and answer;
- a new `client_request_id`.

Do not create a continuation id.

## Replay Takes Too Long

Use recovery in this order:

1. `GET /skills/runs/{run_id}`
2. `GET /skills/requests/{client_request_id}`
3. `signal.status`

Avoid duplicate Replay submissions until recovery shows no active or completed
run.

## No Staged Artifact

`signal.design` can complete with analysis but no staged artifact. Ask whether
the user wants to refine the Idea, answer missing details, or retry with clearer
Signal constraints.

## Coverage Failure

If a requested market or primitive is not replayable today, report it as
coverage. Offer a nearest supported Signal shape or a privacy-safe Debug report.

## Publication Blocked

Do not force publication. Keep the Replay private when:

- the Idea is not active;
- no committed Signal or useful public state exists;
- the content includes private account details;
- the user did not explicitly ask for a public link.
