# Stingray Agent Skills

Official Stingray skills for Claude Code, GitHub Copilot, OpenClaw, Codex, and other `SKILL.md`-compatible agents.

This repository publishes only the public-safe Stingray skill bundle. Internal QA, private fixtures, and mono-repo implementation notes do not ship here.

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

Copy [`skills/stingray`](skills/stingray) into the target agent's skills directory.

Common locations:

- Claude Code: `.claude/skills/stingray`
- GitHub Copilot: `.github/skills/stingray`
- Other agents: use the agent's documented `skills` directory or the installer above

## What Ships

- [`skills/stingray/SKILL.md`](skills/stingray/SKILL.md): agent entrypoint
- [`skills/stingray/README.md`](skills/stingray/README.md): human quickstart
- [`skills/stingray/references`](skills/stingray/references): public reference set loaded on demand
- [`.claude-plugin/marketplace.json`](.claude-plugin/marketplace.json): Claude marketplace metadata

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
        ├── README.md
        ├── SKILL.md
        └── references/
```

## Release Flow

1. Update this repository.
2. Tag and release a new version.
3. Update the pinned public skill ref in `stingray-mono`.
4. Re-run mono `skills-validate`.
5. Update the landing page only if public install paths or structure changed.

## Support

For packaging or distribution issues, contact `dev@mantadigital.io`.

## License

Apache-2.0. See [`LICENSE`](LICENSE).
