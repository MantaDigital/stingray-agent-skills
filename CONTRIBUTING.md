# Contributing

## Principles

- Keep the public bundle standard-first and cross-agent.
- Prefer open Agent Skills conventions over one-off local patterns.
- Do not add internal-only docs, QA fixtures, staging URLs, or private repo references.
- Use relative links only in committed Markdown.
- Use `StingrayTeam <dev@mantadigital.io>` for git and GitHub operations.
- Use `MantaDigital` and `Stingray` in public-facing metadata.

## Public Skill Layout

- `skills/stingray/SKILL.md`: agent instructions
- `skills/stingray/README.md`: human quickstart
- `skills/stingray/references/`: on-demand supporting docs
- `.claude-plugin/marketplace.json`: Claude marketplace compatibility

## Release Process

1. Update this repository.
2. Run `./scripts/validate-public.sh`.
3. Confirm `npx -y skills@1.4.6 add . --list` works.
4. Tag and release a new version.
5. Update the pinned public skill ref in `stingray-mono/apps/skills/public-skill.env`.
