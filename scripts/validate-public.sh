#!/usr/bin/env bash
set -euo pipefail

python3 -m json.tool .claude-plugin/marketplace.json >/dev/null

test -f skills/stingray/SKILL.md
test -f skills/stingray/README.md
test ! -d stingray

for reference in skills/stingray/references/*.md; do
  ref_name=$(basename "$reference")
  grep -Fq "references/$ref_name" skills/stingray/SKILL.md
done

if rg -n 'HsuryX|ruoyang|Ruoyang|/workspace/|apps/agent-server|apps/skills/stingray|apps/skills/qa|agents/openai.yaml|GUIDE\.md|stingray/skills/stingray' README.md AGENTS.md CHANGELOG.md CONTRIBUTING.md CODEOWNERS .claude-plugin skills .github; then
  echo "[FAIL] forbidden reference detected"
  exit 1
fi

npx -y skills@1.4.6 add . --list >/dev/null

echo "[OK] public repo validation passed"
