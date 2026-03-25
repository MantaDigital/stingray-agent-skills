# Stingray Agent Skills

Official Stingray skills for Claude Code, GitHub Copilot, OpenClaw, Codex, and other `SKILL.md`-compatible agents.

This repository publishes only the public-safe Stingray skill package. Internal QA, private fixtures, and mono-repo implementation notes do not ship here.

## Install

### Claude Code

```bash
/plugin marketplace add MantaDigital/stingray-agent-skills
/plugin install stingray@stingray-agent-skills
```

### Cross-Agent With `skills.sh`

```bash
npx skills add MantaDigital/stingray-agent-skills --skill stingray --agent claude-code
npx skills add MantaDigital/stingray-agent-skills --skill stingray --agent github-copilot
npx skills add MantaDigital/stingray-agent-skills --skill stingray --agent openclaw
npx skills add MantaDigital/stingray-agent-skills --skill stingray --agent codex
```

### Manual Copy

Copy [`stingray/skills/stingray`](/workspace/stingray-agent-skills/stingray/skills/stingray) into the target agent's skills directory.

Common locations:

- Claude Code: `.claude/skills/stingray`
- GitHub Copilot: `.github/skills/stingray`
- Other agents: use the agent's documented `skills` directory or the `skills.sh` installer above

## What Ships

- [`stingray/skills/stingray/SKILL.md`](/workspace/stingray-agent-skills/stingray/skills/stingray/SKILL.md): agent entrypoint
- [`stingray/skills/stingray/GUIDE.md`](/workspace/stingray-agent-skills/stingray/skills/stingray/GUIDE.md): human install and usage guide
- [`stingray/skills/stingray/references`](/workspace/stingray-agent-skills/stingray/skills/stingray/references): public reference set loaded on demand
- [`stingray/.claude-plugin/plugin.json`](/workspace/stingray-agent-skills/stingray/.claude-plugin/plugin.json): Claude plugin metadata
- [`.claude-plugin/marketplace.json`](/workspace/stingray-agent-skills/.claude-plugin/marketplace.json): Claude marketplace entry for this collection

## Repository Layout

```text
.
├── .claude-plugin/
│   └── marketplace.json
├── stingray/
│   ├── .claude-plugin/
│   │   └── plugin.json
│   ├── README.md
│   └── skills/
│       └── stingray/
│           ├── GUIDE.md
│           ├── LICENSE.txt
│           ├── SKILL.md
│           └── references/
├── .github/
│   └── workflows/
│       └── validate.yml
├── scripts/
│   └── validate-public.sh
├── AGENTS.md
├── CHANGELOG.md
└── LICENSE
```

## Support

For packaging or distribution issues, contact `dev@mantadigital.io`.

## License

Apache-2.0. See [`LICENSE`](/workspace/stingray-agent-skills/LICENSE).
