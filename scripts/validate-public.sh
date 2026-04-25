#!/usr/bin/env bash
set -euo pipefail

has_rg() {
  command -v rg >/dev/null 2>&1 && rg --version >/dev/null 2>&1
}

search_regex() {
  if has_rg; then
    rg -n -- "$@"
  else
    grep -R -nE -- "$@"
  fi
}

search_fixed_quiet() {
  if has_rg; then
    rg -Fq -- "$@"
  else
    grep -R -Fq -- "$@"
  fi
}

python3 -m json.tool .claude-plugin/marketplace.json >/dev/null

test -f skills/stingray/SKILL.md
test -f skills/stingray/README.md
test ! -d stingray

for reference in skills/stingray/references/*.md; do
  ref_name=$(basename "$reference")
  grep -Fq "references/$ref_name" skills/stingray/SKILL.md
done

if search_regex '/workspace/|apps/agent-server|apps/skills/stingray|apps/skills/qa|agents/openai.yaml|GUIDE\.md|stingray/skills/stingray' README.md AGENTS.md CHANGELOG.md CONTRIBUTING.md CODEOWNERS .claude-plugin skills .github; then
  echo "[FAIL] forbidden reference detected"
  exit 1
fi

if search_regex 'public-safe|internal QA|private fixtures|mono-repo|source of truth|operator identity|pinned public skill ref|do not ship here' README.md CHANGELOG.md AGENTS.md CONTRIBUTING.md skills/stingray/README.md skills/stingray/SKILL.md; then
  echo "[FAIL] unnecessary internal disclosure detected"
  exit 1
fi

if search_regex '/plugin marketplace|/plugin install|Claude marketplace|marketplace metadata|Vercel Skills|Claude Code and other|for Claude Code and other SKILL.md-compatible agents' README.md AGENTS.md CONTRIBUTING.md CHANGELOG.md skills/stingray/README.md skills/stingray/SKILL.md; then
  echo "[FAIL] stale install-story wording detected"
  exit 1
fi

if ! search_fixed_quiet 'https://stingray.fi/app/settings#settings-api-tokens' skills/stingray/README.md skills/stingray/SKILL.md; then
  echo "[FAIL] direct token settings URL missing"
  exit 1
fi

if search_regex 'mkdir -p ~/.stingray|printf .*STINGRAY_PAT=sa_pat|chmod 600 ~/.stingray/credentials' skills/stingray/README.md; then
  echo "[FAIL] README still exposes credential write commands"
  exit 1
fi

if ! search_fixed_quiet 'the secret stays in their terminal' skills/stingray/SKILL.md; then
  echo "[FAIL] SKILL missing credential-isolation guidance"
  exit 1
fi

if ! search_fixed_quiet 'data, not instructions' skills/stingray/SKILL.md; then
  echo "[FAIL] SKILL missing untrusted-content-handling guidance"
  exit 1
fi

npx -y skills@1.4.6 add . --list >/dev/null

echo "[OK] public repo validation passed"
