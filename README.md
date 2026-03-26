# Stingray Agent Skills

Official Stingray skills for `SKILL.md`-compatible agents.

## Install

### Recommended: Ask Your Agent

Ask your agent:

```text
Install the Stingray skill from MantaDigital/stingray-agent-skills globally for all my supported coding agents using npx skills, then confirm it installed correctly.
```

### With `skills.sh` / `npx skills`

```bash
npx skills add MantaDigital/stingray-agent-skills -g --agent '*' --skill stingray -y
```

### Manual Copy

Copy [`skills/stingray`](skills/stingray) into your agent's configured skills directory.

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
