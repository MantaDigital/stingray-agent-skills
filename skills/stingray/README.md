# Stingray

Human quickstart for the public Stingray skill bundle: a Studio-native market
agent for Codex, Claude Code, Cursor, and other SKILL.md-compatible agents.

## Install

### Recommended: Ask Your Agent

Ask your agent:

```text
Install the skills from MantaDigital/stingray-agent-skills globally for all my coding agents using npx skills.
```

### With `skills.sh` / `npx skills`

```bash
npx skills add MantaDigital/stingray-agent-skills -g -y
```

Install the skill from the repository root, then complete the one-time
credential setup below.

Some agents load skills only when a session starts. If the current session
installed Stingray but cannot use it yet, restart the agent session and ask
again.

## 1. Start With Hello World

The installer may only say the skill was installed. The welcome happens in your
agent.

Paste this into a new agent chat:

```text
Welcome me to Stingray. Check my API token, then run the hello-world thesis: BTC pullback check, when BTCUSDT drops 3% in 24h, replay what happened next over 365 days. Create the Studio Idea and Signal, run the Replay, then publish a public Studio demo link I can open in my browser. Keep live monitoring off.
```

If the token is already set, the agent will create one public auditable Studio
demo and return a browser link. If the token is missing, it will guide setup
without asking you to paste the secret into chat.

## 2. Get a Studio Skills API Token

Studio Skills API tokens are currently provisioned for the private-beta Skills
API surface. Ask your Stingray contact for a Studio Skills API token with the
`skills:full` scope.

The token format starts with `sa_pat_...`.

## 3. Configure the Token

The agent will give you a one-line shell command to paste into your
**terminal** (not the chat). The token never enters the agent's context. Or set
`STINGRAY_PAT` in your shell config for env-var auth.

The skill deliberately does not accept tokens pasted into the agent chat. That
would leak the secret into chat history and the LLM context.

## 4. Start Asking

Once the token is saved, the skill calls the production Studio Skills API:

```text
https://stingray.fi/api/studio/v1
```

Best first prompt:

```text
Welcome me to Stingray. Check my API token, then run the hello-world thesis: BTC pullback check, when BTCUSDT drops 3% in 24h, replay what happened next over 365 days. Create the Studio Idea and Signal, run the Replay, then publish a public Studio demo link I can open in my browser. Keep live monitoring off.
```

The agent will work through:

```text
Idea -> Signal candidate -> accepted Signal -> private Replay -> optional Studio Publication
```

Example prompts:

> "What can Stingray Skills do from this agent?"

> "Use Stingray to test this Hyperliquid thesis privately: ETH funding heat check. Trigger when ETH funding on Hyperliquid rises above 0.75 bps/hr. Replay the last 365 days and report event count, average gap, and whether forward-return samples are available. Do not enable monitoring and do not publish a public Studio link."

> "Draft a Whale Liquidation Magnet Signal for Hyperliquid BTC. Tell me which parts are supported today, which parts are live-only, and what data Stingray would need for a Replay."

> "Continue the current Idea, answer any missing questions, accept the staged Signal if it looks reasonable, then run a private Replay."

More copy-paste examples live in [`prompts.md`](prompts.md).

## What The Skill Covers

- Studio-native Idea intake and refinement
- Evidence grounding inside a bound Idea
- Signal design through the Studio assistant runtime
- Explicit staged Signal acceptance through `artifact.accept`
- Private Replay through `signal.replay`
- Lightweight status and recovery through `signal.status`, run lookup, and `client_request_id`
- Opt-in public Studio Publication through `idea.publish`
- Hyperliquid replay boundaries: funding is the reliable replayable first slice; OI, whale, liquidation, and mark-to-liquidation are live-only boundaries for now
- Token isolation, token scope boundary, and privacy-safe debug reporting

## Bundle Contents

```text
skills/stingray/
├── LICENSE.txt
├── prompts.md
├── README.md
├── SKILL.md
└── references/
    ├── capabilities.json
    └── ...
```

## Support

For packaging or distribution issues, contact `dev@mantadigital.io`.
