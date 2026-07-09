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
python3 -m json.tool skills/stingray/references/capabilities.json >/dev/null

test -f skills/stingray/SKILL.md
test -f skills/stingray/README.md
test -f skills/stingray/prompts.md
test -f skills/stingray/references/capabilities.json
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

if search_fixed_quiet 'https://stingray.fi/app/settings#settings-api-tokens' README.md skills/stingray; then
  echo "[FAIL] legacy token settings URL detected in current public docs"
  exit 1
fi

if ! search_fixed_quiet 'private-beta Skills' skills/stingray/README.md skills/stingray/SKILL.md; then
  echo "[FAIL] Studio Skills token provisioning reality missing"
  exit 1
fi

if ! search_fixed_quiet 'API surface' skills/stingray/README.md skills/stingray/SKILL.md; then
  echo "[FAIL] Studio Skills token provisioning reality missing"
  exit 1
fi

if search_regex 'mkdir -p ~/.stingray|printf .*STINGRAY_PAT=sa_pat|chmod 600 ~/.stingray/credentials' skills/stingray/README.md; then
  echo "[FAIL] README still exposes credential write commands"
  exit 1
fi

if search_regex 'STINGRAY_PAT: -4|configured via env|configured \(\.\.\.' skills/stingray/SKILL.md; then
  echo "[FAIL] credential check exposes token source or suffix metadata"
  exit 1
fi

if search_fixed_quiet 'paste it back into your agent' README.md skills/stingray/README.md; then
  echo "[FAIL] unsafe chat-paste credential guidance detected"
  exit 1
fi

if ! search_fixed_quiet 'the secret stays in their terminal' skills/stingray/SKILL.md; then
  echo "[FAIL] SKILL missing credential-isolation guidance"
  exit 1
fi

if ! search_fixed_quiet 'references/capabilities.json' skills/stingray/SKILL.md README.md; then
  echo "[FAIL] capability manifest is not discoverable"
  exit 1
fi

if ! search_fixed_quiet 'prompts.md' skills/stingray/SKILL.md skills/stingray/README.md README.md; then
  echo "[FAIL] prompt index is not discoverable"
  exit 1
fi

if ! search_fixed_quiet 'data, not instructions' skills/stingray/SKILL.md; then
  echo "[FAIL] SKILL missing untrusted-content-handling guidance"
  exit 1
fi

if ! search_fixed_quiet 'https://stingray.fi/api/studio/v1' README.md skills/stingray/README.md skills/stingray/SKILL.md skills/stingray/references/capabilities.json; then
  echo "[FAIL] Studio Skills API base URL missing from primary docs"
  exit 1
fi

if ! search_fixed_quiet 'POST /skills/actions' README.md skills/stingray/SKILL.md skills/stingray/references/capabilities.json; then
  echo "[FAIL] Studio Skills action endpoint missing"
  exit 1
fi

if ! search_fixed_quiet 'GET /skills/runs/{run_id}' README.md skills/stingray/SKILL.md skills/stingray/references/capabilities.json; then
  echo "[FAIL] run lookup route missing"
  exit 1
fi

if ! search_fixed_quiet 'GET /skills/requests/{client_request_id}' README.md skills/stingray/SKILL.md skills/stingray/references/capabilities.json; then
  echo "[FAIL] client request lookup route missing"
  exit 1
fi

for action in idea.intake evidence.ground signal.design artifact.accept signal.replay signal.status idea.publish; do
  if ! search_fixed_quiet "$action" README.md skills/stingray/SKILL.md skills/stingray/references/capabilities.json; then
    echo "[FAIL] Studio Skills action missing: $action"
    exit 1
  fi
done

if ! search_fixed_quiet 'skills:full' README.md skills/stingray/README.md skills/stingray/SKILL.md skills/stingray/references/capabilities.json; then
  echo "[FAIL] skills:full scope guidance missing"
  exit 1
fi

if search_regex 'https://stingray\.fi/api/agent|/v1/chats|/v1/cards|POST /alerts|PATCH /alerts|DELETE /alerts|GET /alerts|alert_draft|alerts_draft' README.md skills/stingray; then
  echo "[FAIL] legacy agent bridge route detected in public skill docs"
  exit 1
fi

if search_regex '[Ll]ive-[Oo]nly|[Ll]ive [Oo]nly|live_only_boundaries' README.md skills/stingray; then
  echo "[FAIL] unsupported Hyperliquid primitives must not be described as live-only"
  exit 1
fi

npx -y skills@1.4.6 add . --list >/dev/null

echo "[OK] public repo validation passed"
