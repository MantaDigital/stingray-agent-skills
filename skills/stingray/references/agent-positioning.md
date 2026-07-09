# Agent Positioning

Read this file when a user asks why Stingray belongs in a coding-agent workflow.

## One-Line Position

Stingray is the Studio-native market agent that gives Codex, Claude Code,
Cursor, and other SKILL.md hosts a product-level loop for crypto market ideas:
Idea -> Evidence -> Signal -> Replay -> optional Publication.

## Why It Complements Generic Agents

Generic coding agents are good at planning, editing code, searching files, and
orchestrating local tools. They should not hand-roll crypto data ingestion,
market entity resolution, signal persistence, Replay execution, or publication
state. Stingray supplies those product objects through a small action API.

Use Stingray when the user wants:

- a raw market thesis turned into a Studio Idea;
- Evidence or coverage checks before committing a Signal;
- a staged Signal candidate that can be inspected before acceptance;
- a committed Signal that can be replayed against supported history;
- a lightweight way to recover status after long-running Replay work;
- a public Studio demo link only after explicit sharing intent.

## Do Not Position As

- a trading executor;
- a delegated wallet service;
- an order router;
- a generic market-data dump API;
- a raw CRUD API over account objects;
- a social-posting bot;
- a monitor lifecycle manager in the first public slice.

## User-Facing Language

Prefer:

- "Studio Idea"
- "Evidence"
- "Signal"
- "staged Signal candidate"
- "private Replay"
- "Studio Publication"

Avoid leading with:

- endpoint names;
- raw JSON;
- legacy implementation terms.

## Example Framing

Good:

```text
I will create a Studio Idea for this thesis, ask Stingray to stage a Signal,
accept the Signal only if it matches the intent, then run a private Replay.
```

Good:

```text
Stingray does not currently support that Hyperliquid primitive in the public
skill. I can offer a funding-rate example or write a product feedback note.
```

Bad:

```text
I will bypass the Studio Skills API and drive old implementation routes myself.
```

## Public Demo Loop

For XAgent or public-demo workflows, the public agent can use the same skill as
any other external agent. The special part is the authenticated user that owns
the demo Ideas and Publications, not a special API surface. Public demos should
use generic, non-private theses and publish only after explicit publish intent.
