# Co-development — request new capabilities and report confusion

Read this file when (a) the user needs a primitive (asset coverage, signal type, dataset, indicator) the current API does not expose, (b) you encountered confusing behavior, an unexpected response shape, contradictory docs, or any reference gap that made it harder to serve the user, or (c) install, credential, onboarding, or first-run steps were confusing. Stingray's chat doubles as a feedback channel. The team uses feature requests, debug reports, and setup reports as backlog and installation-debug signal, then replies in the same chat when work lands or docs get fixed.

## When to use — feature requests

- Replay bridge returns `502` for an asset that `kg_search` resolves cleanly.
- Signal-definition schema validates a primitive but the Replay engine refuses it (e.g., `news_sentiment` Replays).
- The user asks for a dataset Stingray doesn't expose (per-venue funding, on-chain flow series, etc.).
- A workflow gap that surfaced in the docs but isn't fixed yet.

## When to use — confusion / debug reports

Send a debug report whenever something didn't match a reference cleanly, even if you completed the task. The point is to give the Stingray team signal about what real agents trip on.

- A response field is named differently than the reference says (e.g. `widget_id` in the API but `draft_id` in the docs).
- Two references suggest different routing for the same intent.
- An endpoint returned an undocumented error code, an unexpected shape, or a payload the reference didn't anticipate.
- The user's prompt didn't fit any business-capability mapping cleanly and you had to guess.
- A reference's example failed to reproduce when run as written.
- The credential-check or first-time-setup flow surfaced a corner case the docs don't cover.

## When to use — setup reports

Send a setup report when installation or onboarding creates avoidable friction:

- The skill installed but the host agent did not load it until restart.
- The credential file exists but `GET /me/access` fails.
- The token setup path was unclear to the host agent or the user.
- An onboarding endpoint returned an unexpected shape or unclear error.
- Channel readiness was ambiguous after `GET /me/access`, `GET /me/telegram`, or `GET /me/whatsapp`.

Do not send a setup report for a clean install unless the user explicitly asks for diagnostics to be shared.

## How

Send the request through the same public API-token-safe Studio assistant channel as any other prompt. Do not invent a separate feedback endpoint. Keep route details out of user-facing copy unless the user asks for implementation debugging.

Prefix the body so the team can triage:

- `Feature request:` for new capabilities
- `Debug report:` for confusion, unexpected behavior, or reference gaps
- `Setup report:` for install, credential, onboarding, or first-run diagnostics

Keep reports privacy-friendly:

- Never include API tokens, secrets, private keys, auth headers, cookies, or full credential paths beyond `~/.stingray/credentials`.
- Do not include the user's full market thesis, portfolio, positions, watchlist, chat transcript, or private prompt unless the user explicitly asks.
- Include only the host agent, skill version, command or route family, sanitized status/error code, and the step where the problem happened.
- If you need to mention a token at all, say only whether the prefix was `sa_pat_`; do not include suffixes or fingerprints.

Use short report bodies:

- `Feature request: enable Replays for HYPEUSDT. Current bridge returns 502 across all lookback windows.`
- `Debug report: Replay reference says draft_id, but the bridge response exposed widget_id. Stumbled here mid-task.`
- `Setup report: Codex host, stingray skill 0.1.9, credential file existed but access check returned 401 until whitespace was trimmed. No token or user prompt included.`

Save the assistant conversation id when available so the user can re-check status later. The team replies in-thread when the feature lands or the reference is fixed.

## Request shapes — feature requests

Frame each request as a one-liner with the **use case**, not just the symptom:

- **Asset coverage** — "Replay on HYPEUSDT returns 502 across every lookback. Can this asset be added to the price-data pipeline?"
- **Signal types** — "The `news_sentiment` block validates as a Signal definition but the Replay engine refuses it. Please enable Replays for news-driven primitives."
- **New datasets** — "Expose per-venue funding rate so I can alert on Binance-vs-Hyperliquid divergence for a single asset."
- **Indicator additions** — "Add a Bollinger Band-width indicator (current Bollinger only triggers on touch, not on band-width compression)."
- **Workflow gaps** — "When the assistant generates a draft Signal, the bridge field is named `widget_id` but the docs call it `draft_id` — surface a single canonical name."

## Request shapes — debug reports

Frame each report as a one-liner with **what you saw vs what the reference said**, plus the route or reference name. Keep it terse — a sentence is enough.

- **Reference mismatch** — "Debug report: `references/backtest-and-cards.md` step 3 says `draft_id` but the actual bridge response field is `widget_id`. Stumbled mid-flow on a thesis-to-Publication task."
- **Undocumented response** — "Debug report: `POST /alerts` returned `409 alert_definition_conflict` for a definition that passed schema validation. Not in `references/troubleshooting.md`."
- **Routing ambiguity** — "Debug report: user asked 'monitor my biggest position' — could be portfolio + alert, or just a snapshot read. Picked alert; please clarify the routing in `intent-rubrics.md`."
- **Reproduction failure** — "Debug report: `references/examples.md` Example 11 produced an unexpected 400 when run as written — `events` array required but the example omits it."
- **Setup edge case** — "Debug report: credential check passed but `GET /me/access` 401'd. Token was paste with surrounding whitespace; trimming fixed it. Worth handling in First-Time Setup."

## Request shapes — setup reports

Frame each report as one sanitized line with **host + skill version + step + route/result**:

- **Skill load** — "Setup report: Claude Code host, stingray skill 0.1.9, installed successfully but host did not expose the skill until session restart."
- **Credential check** — "Setup report: Codex host, stingray skill 0.1.9, `~/.stingray/credentials` existed but `GET /me/access` returned 401 until trailing whitespace was removed."
- **Onboarding** — "Setup report: Cursor host, stingray skill 0.1.9, `GET /me/access` returned linked Telegram false but `GET /me/telegram` showed DM deliverable true; docs should clarify precedence."

## Out of scope for this surface

- Billing, account-deletion, security disclosures, anything that needs a human ticket — those go through normal support channels.
- Bug reports for live customer-impacting outages — open a Linear issue in `Engineering` instead.
