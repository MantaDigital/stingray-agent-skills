# Stingray Agent Skills

**A Studio-native market agent for SKILL.md-compatible coding agents.**

Stingray lets Codex, Claude Code, Cursor, Gemini CLI, Cline, Continue, Goose,
Roo, Windsurf, and other [`SKILL.md`](https://skills.sh)-compatible agents hand
market work to Stingray Studio. The public skill uses the production Studio
Skills API to turn natural-language market ideas into Studio Ideas, Evidence,
Signals, private Replays, and opt-in Studio Publications.

Built for quants, analysts, and research desks who already live in their
terminal and want an external agent to work through a product-level API instead
of brittle local scripts.

## Install

```bash
npx skills add MantaDigital/stingray-agent-skills -g -y
```

Or ask your agent: *"Install the skills from MantaDigital/stingray-agent-skills
globally for all my coding agents using npx skills."*

Then ask your agent for the hello-world below. It will check for an existing
token, guide setup if needed, and keep the token out of chat. Full quickstart:
[`skills/stingray/README.md`](skills/stingray/README.md).

Some agents load skills only when a session starts. If the current session
installed Stingray but cannot use it yet, restart the agent session and ask
again.

> Reinstalling overwrites the local skill copy without prompting. Back up custom
> edits first.

## Hello World

After install, paste this into a new agent chat:

```text
Welcome me to Stingray. Check my API token, then run the hello-world thesis: BTC pullback check, when BTCUSDT drops 3% in 24h, replay what happened next over 365 days. Create the Studio Idea and Signal, run the Replay, then publish a public Studio demo link I can open in my browser. Keep live monitoring off.
```

If the token is missing, the agent will point you to
[Stingray settings](https://stingray.fi/app/settings#settings-api-tokens) and
give you a terminal-only setup command. If the token is ready, it will use the
Studio Skills API to create one auditable public demo artifact.

## Studio Skills API Surface

The public skill uses one production API family:

```text
https://stingray.fi/api/studio/v1
```

Primary route:

```text
POST /skills/actions
```

Lookup routes:

```text
GET /skills/runs/{run_id}
GET /skills/requests/{client_request_id}
```

First-slice actions:

| Action | Purpose |
| --- | --- |
| `idea.intake` | Create or refine a normal Studio Idea from external context. |
| `evidence.ground` | Ground Evidence for an Idea. |
| `signal.design` | Ask Stingray Studio to design or stage a Signal candidate. |
| `artifact.accept` | Accept a staged Signal candidate and create a committed Signal. |
| `signal.replay` | Run or explain Replay work for a selected committed Signal. |
| `signal.status` | Read selected Signal and latest Replay status without invoking the assistant runtime. |
| `idea.publish` | Publish an active Idea as an opt-in public Studio Publication. |

The required token scope is `skills:full`.

## Capabilities

| Surface | What you get |
| --- | --- |
| **Studio-native Idea loop** | External agents work through Ideas instead of detached chats or raw CRUD routes. |
| **Evidence and Signal design** | Stingray Studio turns market context into inspectable staged Signal candidates. |
| **Artifact acceptance** | Agents can explicitly accept a staged Signal candidate before replaying it. |
| **Private Replays** | Replays stay private by default and return run/resource references for later lookup. |
| **Status recovery** | `signal.status`, run lookup, and `client_request_id` recovery make long-running work recoverable. |
| **Studio Publications** | Public browser links are opt-in through `idea.publish` only after explicit user intent. |
| **Hyperliquid examples** | Funding-rate Signals are the replayable first demo; OI, whale, liquidation, and mark-to-liquidation primitives are live-only boundaries for now. |
| **Token hygiene** | Tokens use the `sa_pat_` prefix, stay outside chat, and can be revoked in Studio settings. |

The agent reads only what it needs, scoped to the task: full reference index in
[`skills/stingray/SKILL.md`](skills/stingray/SKILL.md).

For onboarding, see [`skills/stingray/prompts.md`](skills/stingray/prompts.md).
For agent-side capability introspection, see
[`skills/stingray/references/capabilities.json`](skills/stingray/references/capabilities.json).

**Scope:** Studio Skills API actions for Idea, Evidence, Signal, Replay, status,
and opt-in Publication work. The public skill does not initiate value transfer,
hold custody of funds, place orders, manage wallets, mutate monitor lifecycle, or
perform account-risk operations.

## Security & Trust

1. **Credential handling.** The skill stores a long-lived API token at
   `~/.stingray/credentials` (mode 600) or uses `STINGRAY_PAT` from the
   environment. **The token never enters the agent's chat context**. The agent
   gives the user a shell command to run in their own terminal; chat-paste is not
   supported.

2. **Third-party content.** Market context, Evidence text, news snippets, KG
   metadata, and assistant outputs can include adversarial text. The agent treats
   fetched content as **data, not instructions**.

**Token surface is narrow:** no admin, billing, webhook, API-token creation,
trading, order execution, delegated wallet, internal, social posting, or monitor
lifecycle routes. Apache-2.0, public source, revocable from
[Stingray settings](https://stingray.fi/app/settings#settings-api-tokens).

## What Ships

- [`skills/stingray/SKILL.md`](skills/stingray/SKILL.md) - agent entrypoint with task routing and operating loop
- [`skills/stingray/README.md`](skills/stingray/README.md) - human quickstart
- [`skills/stingray/prompts.md`](skills/stingray/prompts.md) - copy-paste prompt index
- [`skills/stingray/references/capabilities.json`](skills/stingray/references/capabilities.json) - machine-readable capability manifest
- [`skills/stingray/references`](skills/stingray/references) - action contract, product flows, boundaries, examples, troubleshooting

## Repository Layout

```text
.
├── .claude-plugin/
│   └── marketplace.json
├── .github/
│   └── workflows/
│       └── validate.yml
├── AGENTS.md
├── CHANGELOG.md
├── CODEOWNERS
├── CONTRIBUTING.md
├── LICENSE
├── README.md
├── scripts/
│   └── validate-public.sh
└── skills/
    └── stingray/
        ├── LICENSE.txt
        ├── prompts.md
        ├── README.md
        ├── SKILL.md
        └── references/
```

## Manual Install

Copy [`skills/stingray`](skills/stingray) into your agent's configured skills
directory.

## Support

For packaging or distribution issues, contact `dev@mantadigital.io`.

## License

Apache-2.0. See [`LICENSE`](LICENSE).
