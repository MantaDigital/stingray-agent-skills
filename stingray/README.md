# Stingray Plugin

Plugin id: `stingray`

This plugin packages the public Stingray skill bundle for Claude Code while keeping the core skill files reusable across other agents.

## Install In Claude Code

```bash
/plugin marketplace add MantaDigital/stingray-agent-skills
/plugin install stingray@stingray-agent-skills
```

## Install In Other Agents

Use `skills.sh` or copy [`skills/stingray`](/workspace/stingray-agent-skills/stingray/skills/stingray) into the target agent's skills directory.

## Contents

- [`skills/stingray/SKILL.md`](/workspace/stingray-agent-skills/stingray/skills/stingray/SKILL.md)
- [`skills/stingray/GUIDE.md`](/workspace/stingray-agent-skills/stingray/skills/stingray/GUIDE.md)
- [`skills/stingray/references`](/workspace/stingray-agent-skills/stingray/skills/stingray/references)
- [`.claude-plugin/plugin.json`](/workspace/stingray-agent-skills/stingray/.claude-plugin/plugin.json)
