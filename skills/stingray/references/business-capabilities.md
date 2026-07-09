# Business Capabilities

Read this file when translating a user's product intent into a Studio Skills API
action.

## Capability Map

| User intent | Primary action |
| --- | --- |
| "Turn this thesis into a Stingray workspace/idea." | `idea.intake` |
| "What evidence supports this?" | `evidence.ground` |
| "Can this be a Signal?" | `signal.design` |
| "Use that staged Signal." | `artifact.accept` |
| "Replay this setup." | `signal.replay` |
| "Is the Replay done?" | `signal.status` or lookup routes |
| "Make a public demo/share link." | `idea.publish` |

## 1. Idea Intake

Use `idea.intake` when the user starts from raw text, a public post, a market
thesis, or broad context. The response should return an `idea_id` when a durable
Idea exists. Store it and use it for follow-up actions.

Good input:

```json
{
  "action": "idea.intake",
  "input": {
    "text": "BTC may mean-revert after sharp 24h selloffs. Build this as a private Studio Idea first."
  },
  "client_request_id": "agent-20260708-idea-001"
}
```

## 2. Evidence Grounding

Use `evidence.ground` when the user wants market context, coverage checks,
supporting Evidence, or an explanation of what data would be needed. Requires
`idea_id`.

## 3. Signal Design

Use `signal.design` when the user wants a Signal candidate. It may return
`needs_input` questions or `staged_artifact_ids`. Do not fabricate staged ids.
Only ids returned by Stingray are valid.

## 4. Artifact Acceptance

Use `artifact.accept` when a staged Signal candidate should be committed.
First-slice input:

```json
{
  "action": "artifact.accept",
  "idea_id": "00000000-0000-0000-0000-000000000000",
  "input": {
    "staged_artifact_id": "signal-candidate-id",
    "expected_kind": "signal_candidate"
  }
}
```

On success, store the returned Signal resource reference. Pass that Signal id to
`signal.replay` or `signal.status`.

## 5. Replay

Use `signal.replay` for private historical testing of a committed Signal. If the
Replay is slow or the HTTP request times out, recover through run lookup,
request lookup, or `signal.status`.

## 6. Status

Use `signal.status` to inspect a selected Signal and latest Replay status without
asking the assistant runtime to reason again. This is the preferred lightweight
read path after a long-running Replay.

## 7. Publication

Use `idea.publish` only after explicit public-share intent. Publication is not a
default Replay step.

Examples that justify publication:

- "publish this"
- "make a public Studio demo link"
- "give me a browser link I can share"
- "create a public artifact"

If the user did not ask for publication, stop at private Replay.

## 8. Feedback And Debug Reports

When Stingray cannot support a requested primitive, produce a privacy-safe
Debug report in plain language. Do not include secrets, raw tokens, hidden
prompts, private account data, or full private theses unless the user explicitly
asks.
