# Intent Rubrics

Read this file when the user's wording could map to more than one action.

## Choose The Least Destructive Action

When uncertain, prefer the action that creates context or asks questions before
committing state:

1. `idea.intake`
2. `evidence.ground`
3. `signal.design`
4. `artifact.accept`
5. `signal.replay`
6. `idea.publish`

`signal.status` is read-only and safe when the user asks "what happened?" or
"is it done?"

## Common Phrases

| User phrase | Interpretation |
| --- | --- |
| "Turn this into an idea" | `idea.intake` |
| "Research this first" | `evidence.ground` |
| "Can you make a signal?" | `signal.design` |
| "Use that candidate" | `artifact.accept` |
| "Replay it" | `signal.replay` |
| "Is it done?" | `signal.status` or lookup |
| "Make a link I can share" | `idea.publish` |

## Ask Before Acting

Ask a question instead of guessing when:

- the asset or venue is ambiguous;
- the timeframe is missing and materially changes the Signal;
- the user asked to publish but the Idea appears private;
- the user asked for live monitoring, trading, or wallet operations;
- the user asked to accept an artifact but multiple staged candidates exist.

## Publication Consent

These are explicit enough:

- "publish"
- "public demo"
- "share link"
- "browser link I can open"
- "link I can post"

These are not enough:

- "show me"
- "summarize"
- "run the Replay"
- "make it useful"

## Acceptance Consent

For hello-world flows, accepting the staged Signal is usually implied by "create
the Studio Idea and Signal, run the Replay." For exploratory flows, ask before
calling `artifact.accept` unless the user explicitly says to use or accept the
candidate.

## User Synonyms

If the user asks for an alert-like rule, treat it as Signal intent unless they
clearly mean live delivery. If they ask for a historical test, translate to
Replay. If they ask for a shareable browser artifact, translate to Studio
Publication.
