# North-Star Scenarios

Read this file when the user wants an end-to-end outcome that spans multiple business capabilities rather than one isolated API action.

These scenarios are where the skill should feel agent-native instead of UI-automation-like.

## Table of Contents

1. Thesis to Monitor
2. Natural-Language Alert Designer
3. Portfolio Guardian
4. Onboarding Fixer
5. Screenshot to Portfolio Draft
6. Channel Handoff
7. Growth Concierge
8. API token Security Concierge
9. Account Operating Report
10. Monitoring Coverage Query
11. Monitoring Gap Fill
12. Portfolio Import Reconciliation
13. Account Cleanup

## 1. Thesis to Monitor

User phrasing:

- "Research PENDLE, add it to my watchlist, and set an alert if this account is ready."

Why it matters:

- It turns a one-off curiosity into a retained monitoring workflow.

Capability mix:

- asset research
- watchlist management
- alerts management
- account readiness

Good flow:

1. Research and resolve the entity first.
2. Add to watchlist only after the match is clear.
3. Check alert-delivery readiness before alert activation.
4. Verify resulting watchlist and alert state.

Do not:

- create the alert before the asset is resolved
- skip Telegram readiness for alert delivery

## 2. Natural-Language Alert Designer

User phrasing:

- "If BTC breaks 70k and momentum looks overheated, remind me."
- "Alert me if BTC drops 5% and there's negative news about regulation within 2 hours."
- "Let me know when negative news hits ETH first, then the price drops within 30 minutes."

Why it matters:

- This is the most agent-native expression of alerts: the user describes intent, not form fields.

Capability mix:

- asset research
- alerts management
- channel readiness

Good flow:

1. Resolve the asset and any missing identifiers via KG search to get `entity_id` and `trading_pair`.
2. Read `references/alert-definitions.md` for the block reference and translate the user's intent into a composable block tree definition. Use the appropriate block types (price_change, price_cross, ta_indicator, news_sentiment, etc.) and combinators (all_of, any_of, sequence) to express the intent.
3. Ask for clarification when the intent is underspecified — for example, what window to use, what threshold, or whether "overheated" means RSI above 70.
4. Check delivery readiness before enabling notification delivery.
5. Confirm the resulting alert in user language, explaining which conditions the definition encodes.

Do not:

- pretend unsupported alert semantics already exist if the backend cannot express them
- bypass clarification when the user intent is underspecified
- construct definitions without matching event subscriptions for every trading_pair and entity_id

## 3. Portfolio Guardian

User phrasing:

- "Use my portfolio to set up monitoring for the positions that matter most."

Why it matters:

- It converts passive portfolio tracking into proactive retention.

Capability mix:

- portfolio management
- asset research
- alerts management

Good flow:

1. Read the portfolio first.
2. Identify the relevant positions or ask the user for prioritization if needed.
3. Propose or create alerts tied to those positions.
4. Verify resulting alert coverage.

Do not:

- assume a risk policy the user did not request
- mutate positions when the real task is alert coverage

## 4. Onboarding Fixer

User phrasing:

- "Why am I still not getting alerts?"

Why it matters:

- This directly improves activation and reduces setup abandonment.

Capability mix:

- account readiness
- onboarding
- channel management
- alerts management

Good flow:

1. Check `/me/access`.
2. Read onboarding and linked-channel state.
3. Explain the exact blocker in product terms.
4. Only attempt alert writes if the blocker is actually cleared.

Do not:

- jump straight into alert mutation
- treat missing Telegram deliverability as a generic auth problem

## 5. Screenshot to Portfolio Draft

User phrasing:

- "I uploaded a screenshot of my holdings. Turn it into a portfolio draft."

Why it matters:

- This is a strong input modality advantage over forms.

Capability mix:

- web chat
- attachment handling
- portfolio management

Good flow:

1. Start or use a web chat with image attachments.
2. Let the assistant reason over the uploaded image.
3. Produce a proposed portfolio import or batch payload.
4. Only write the portfolio after the user confirms.

Do not:

- silently write positions without confirmation
- confuse attachment ingestion with generic file storage

## 6. Channel Handoff

User phrasing:

- "Keep discussing this in Telegram instead of web chat."

Why it matters:

- It lets the product follow the user into the channel where they actually want the conversation.

Capability mix:

- web chat
- channel management
- channel chat

Good flow:

1. Check whether the requested channel is linked and usable.
2. Resolve or create the channel chat.
3. Continue the conversation there.

Do not:

- assume linked-channel state without checking
- treat a channel-state question as a request to hand off the chat

## 7. Growth Concierge

User phrasing:

- "Set up my referral flow and make sure attribution is captured correctly."

Why it matters:

- It turns growth primitives into something a user or operator can actually delegate to the agent.

Capability mix:

- referrals growth
- attribution growth
- account readiness

Good flow:

1. Inspect current referral state.
2. Create a referral code only if needed.
3. Capture attribution data when the task explicitly includes it.
4. Report the resulting growth state clearly.

Do not:

- confuse attribution capture with referral-code generation
- treat public leaderboard routes as user-account management

## 8. API token Security Concierge

User phrasing:

- "Review my integration tokens and clean up the stale ones."

Why it matters:

- This is a high-trust, high-value agent task that UI surfaces usually handle poorly.

Capability mix:

- token hygiene
- account readiness

Good flow:

1. List existing API tokens.
2. Identify the intended revoke set with the user.
3. Revoke only the stale tokens.
4. Re-list and confirm the survivors.

Do not:

- revoke the currently in-use API token accidentally
- treat cleanup as permission to mint new credentials

## 9. Account Operating Report

User phrasing:

- "Give me a full operating report on this account."

Why it matters:

- It is the natural preflight for external agent setups and for support-style diagnostics.

Capability mix:

- account readiness
- onboarding
- credits and usage
- channel management
- growth state

Good flow:

1. Read access and account state.
2. Read onboarding, usage, credits, and linked-channel state.
3. Summarize readiness, blockers, and next actions in business terms.

Do not:

- collapse everything into raw JSON
- treat the report as a request to mutate account state

## 10. Monitoring Coverage Query

User phrasing:

- "For ETH, what do I already have set up across watchlist, portfolio, alerts, and chats?"

Why it matters:

- Users usually do not remember what is already configured. Coverage visibility is often more valuable than another create button.

Capability mix:

- asset research
- watchlist management
- portfolio management
- alerts management
- web chat

Good flow:

1. Resolve the target entity first.
2. Inspect existing watchlist, portfolio, alert, and chat state.
3. Summarize coverage in one view with obvious gaps.

Do not:

- create new state when the task is clearly an audit
- force the user to inspect each product surface separately

## 11. Monitoring Gap Fill

User phrasing:

- "Take everything in my portfolio that is not already monitored and fill in the gaps."

Why it matters:

- This is where an agent can outperform UI: comparing multiple surfaces and applying the user's intent consistently.

Capability mix:

- portfolio management
- watchlist management
- alerts management
- account readiness

Good flow:

1. Read portfolio, watchlist, and alert state first.
2. Identify which positions lack tracking coverage.
3. Add only the missing watchlist or alert state the user asked for.
4. Verify the new coverage.

Do not:

- duplicate existing alerts or watchlist items
- create deliverable alerts without checking readiness

## 12. Portfolio Import Reconciliation

User phrasing:

- "I uploaded a holdings screenshot. Before importing it, compare it to my current portfolio and only draft the deltas."

Why it matters:

- The user wants confidence, not just ingestion. Reconciliation avoids duplicates and noisy imports.

Capability mix:

- web chat
- attachment handling
- portfolio management

Good flow:

1. Use chat plus attachments as the ingestion surface.
2. Read the current portfolio before proposing changes.
3. Produce a delta-oriented import draft.
4. Only write after the user confirms.

Do not:

- overwrite the whole portfolio blindly
- convert a reconciliation request into a raw one-shot import

## 13. Account Cleanup

User phrasing:

- "Clean up everything."
- "Delete all my alerts and remove the test data."
- "Reset my account to a clean state."
- "Remove all alerts, clear my portfolio, and keep only BTC on the watchlist."

Why it matters:

- Bulk deletes are error-prone when the agent assumes what exists instead of listing first. Missed resources lead to silent state drift.

Capability mix:

- alerts management
- portfolio management
- watchlist management

Good flow:

1. List alerts, portfolio positions, and watchlist items before deleting anything.
2. Present the full inventory to the user and confirm the scope — which items to delete, which to keep.
3. Delete one resource at a time using the correct endpoint for each family.
4. After all deletes, re-list every affected family and show the user the remaining state.

Do not:

- assume which resources exist without listing first
- skip the final verification loop
- delete resources the user did not explicitly mention (e.g., do not delete watchlist items when the user only asked to delete alerts)
- delete the currently in-use API token unless the user explicitly asks for it
