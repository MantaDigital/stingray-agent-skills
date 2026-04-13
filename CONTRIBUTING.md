# Contributing

## Principles

- Keep the public bundle standard-first and cross-agent.
- Prefer open Agent Skills conventions over one-off local patterns.
- Use relative links only in committed Markdown.
- Use `MantaDigital` and `Stingray` in public-facing metadata.

## Public Skill Layout

- `skills/stingray/SKILL.md`: agent instructions
- `skills/stingray/README.md`: human quickstart
- `skills/stingray/references/`: on-demand supporting docs

## Release Process

1. Update this repository.
2. Run `./scripts/validate-public.sh`.
3. Confirm `python3 -m skills_ref.cli validate skills/stingray` works.
4. Confirm `npx -y skills add . --list` works (uses the version pinned in `scripts/validate-public.sh`).
5. Tag and release a new version.
