#!/usr/bin/env bash
set -euo pipefail

python3 -m json.tool .claude-plugin/marketplace.json >/dev/null
python3 -m json.tool stingray/.claude-plugin/plugin.json >/dev/null

test -f stingray/skills/stingray/SKILL.md
test -f stingray/skills/stingray/GUIDE.md

for reference in stingray/skills/stingray/references/*.md; do
  ref_name=$(basename "$reference")
  grep -Fq "references/$ref_name" stingray/skills/stingray/SKILL.md
done

if rg -n 'HsuryX|ruoyang|Ruoyang|apps/agent-server|apps/skills/stingray|apps/skills/qa|agents/openai.yaml' README.md AGENTS.md CHANGELOG.md .claude-plugin stingray; then
  echo "[FAIL] forbidden reference detected"
  exit 1
fi

npx -y skills add . --list >/dev/null

echo "[OK] public repo validation passed"
