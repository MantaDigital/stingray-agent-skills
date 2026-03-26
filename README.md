# Stingray Agent Skills

Official Stingray skills for `skills.sh` and other `SKILL.md`-compatible agents.

## Install

### With `skills.sh`

```bash
npx skills add MantaDigital/stingray-agent-skills --skill stingray --agent claude-code
npx skills add MantaDigital/stingray-agent-skills --skill stingray --agent github-copilot
npx skills add MantaDigital/stingray-agent-skills --skill stingray --agent openclaw
npx skills add MantaDigital/stingray-agent-skills --skill stingray --agent codex
```

### Manual Copy

Copy [`skills/stingray`](skills/stingray) into the target agent's skills directory.

Common locations:

- GitHub Copilot: `.github/skills/stingray`
- Other agents: use the agent's documented `skills` directory or the installer above

## What Ships

- [`skills/stingray/SKILL.md`](skills/stingray/SKILL.md): agent entrypoint
- [`skills/stingray/README.md`](skills/stingray/README.md): human quickstart
- [`skills/stingray/references`](skills/stingray/references): public reference set loaded on demand

## Repository Layout

```text
.
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

## Support

For packaging or distribution issues, contact `dev@mantadigital.io`.

## License

Apache-2.0. See [`LICENSE`](LICENSE).
